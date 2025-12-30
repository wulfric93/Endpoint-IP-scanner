ftb(); 
var isLongID = false; 
var mainband = null; 
var _2ndrun = null; 
var havename = false; 
var suspend = 0; 
var status = ""; 
var netmode = ""; 
var signal = ""; 
var nroption = ""; 
var arfcn = ""; 

console.log("type: netmode , signal , status");
window.setInterval(Main, 300); 

function Main() { 
    if (1 != suspend) {
        $("#dhcp_mask").show(), $("#dhcp_dns").show(), $('#apn_list_input_dns_operate').show(), 
        $('#network_preferred_mode_control_father').show(), $('#network_5g_control_father').show(), 
        $('#network_4g_control_father').show(), $('#network_3g_control_father').show(), 
        $('#dialup_network_mode_control_father').show(), $('#network_band_control_father').show(), 
        $('#LTE_band_control_father').show(), $('#LTE_band').show(), $('#mobilesearchBtnSave').show(), 
        $('#mobilesearch_input_support_5G_switch_operate').show(), $('#mobilesearch_network_mode_5G').show(), 
        $('#mobilesearch_btn_save_div').show(), $('#mobilesearch_input_support_4G_switch_operate').show(), 
        $('#mobilesearch_LTE_band_select').show(), $('#mobilesearch_LTE_band_list_items').show(), 
        $('#mobilesearch_network_notes').show(), $('#mobilesearch_input_support_3G_switch_operate').show(), 
        $('#apn_connection_mode').show(), $('#eths-manual-mac').show(), $('#secondary_dns').show(), 
        $('#wanspeed').show(), $('#dualntwk_ipv4').show(), $('#dualntwk_ipv6').show(), 
        $('#dia_trace_maxhops_father').show(), $('#led_switch_content').show(), $('#ip_type').show(), 
        $('#antenna_page').show(), $('#wifi_save_power_wrapper').show(), $('#wifi_save_power').show(), 
        $('#wifiadv_atuoApti_div').show(), $('#LAN_LAN_Ping').show(), $('#statistics_daily_flow_switch').show(), 
        $('#wifiadv_2g_mode_div').show(), $('#wifiadv_2g_maxassociate_div').show(), 
        $('#wifiadv_5g_mode_div').show(), $('#wifiadv_5g_maxassociate_div').show(), 
        $('#developer_mode_div').show(), $('#mlog').show(), $('#calltrace').show(), $('#band').show(), 
        $('#apklog').show();
    }
    getNetmode(), getStatus(), getInfo(), Signl(), ReadHardBand(), B_4GType(), PlmnPh(), DeviceBoot(), getPublicIPCountry();
}

// NEW FEATURE: Fetch public IP + country flag emoji
function getPublicIPCountry() {
    fetch('https://ipapi.co/json/')
        .then(response => response.json())
        .then(data => {
            if (data && data.ip && data.country_code) {
                const flag = countryCodeToFlag(data.country_code);
                // Update the existing WAN IP field with public IP + flag
                $('#ipv4').html(' ( ' + data.ip + ' ' + flag + ' ) ');
            } else {
                $('#ipv4').html(' ( Public IP: Unknown ) ');
            }
        })
        .catch(err => {
            console.error('Error fetching public IP:', err);
            $('#ipv4').html(' ( Public IP: Error ) ');
        });
}

// Helper: Convert ISO 2-letter country code to flag emoji
function countryCodeToFlag(isoCode) {
    if (!isoCode || isoCode.length !== 2) return '';
    return isoCode.toUpperCase().replace(/./g, char => 
        String.fromCodePoint(127397 + char.charCodeAt(0))
    );
}

// ... (All your original functions below remain unchanged)

function arfcntoband(arfcn) { 
    if (arfcn > 422000 && arfcn < 434000) return '1'; 
    if (arfcn > 386000 && arfcn < 398000) return '2'; 
    if (arfcn > 361000 && arfcn < 376000) return '3'; 
    if (arfcn > 173800 && arfcn < 178800) return '5'; 
    if (arfcn > 524000 && arfcn < 538000) return '7'; 
    if (arfcn > 185000 && arfcn < 192000) return '8'; 
    if (arfcn > 145800 && arfcn < 149200) return '12'; 
    if (arfcn > 149200 && arfcn < 151200) return '13'; 
    if (arfcn > 151600 && arfcn < 153600) return '14'; 
    if (arfcn > 172000 && arfcn < 175000) return '18'; 
    if (arfcn > 158200 && arfcn < 164200) return '20'; 
    if (arfcn > 305000 && arfcn < 311800) return '24'; 
    if (arfcn > 386000 && arfcn < 399000) return '25'; 
    if (arfcn > 171800 && arfcn < 178800) return '26'; 
    if (arfcn > 151600 && arfcn < 160600) return '28'; 
    if (arfcn > 143400 && arfcn < 145600) return '29'; 
    if (arfcn > 470000 && arfcn < 472000) return '30'; 
    if (arfcn > 402000 && arfcn < 405000) return '34'; 
    if (arfcn > 514000 && arfcn < 524000) return '38'; 
    if (arfcn > 376000 && arfcn < 384000) return '39'; 
    if (arfcn > 460000 && arfcn < 480000) return '40'; 
    if (arfcn > 499200 && arfcn < 537999) return '41'; 
    if (arfcn > 743334 && arfcn < 795000) return '46'; 
    if (arfcn > 790334 && arfcn < 795000) return '47'; 
    if (arfcn > 636667 && arfcn < 646666) return '48'; 
    if (arfcn > 286400 && arfcn < 303400) return '50'; 
    if (arfcn > 285400 && arfcn < 286400) return '51'; 
    if (arfcn > 496700 && arfcn < 499000) return '53'; 
    if (arfcn > 334000 && arfcn < 335000) return '54'; 
    if (arfcn > 422000 && arfcn < 440000) return '65'; 
    if (arfcn > 422000 && arfcn < 440000) return '66'; 
    if (arfcn > 147600 && arfcn < 151600) return '67'; 
    if (arfcn > 399000 && arfcn < 404000) return '70'; 
    if (arfcn > 123400 && arfcn < 130400) return '71'; 
    if (arfcn > 295000 && arfcn < 303600) return '74'; 
    if (arfcn > 286400 && arfcn < 303400) return '75'; 
    if (arfcn > 285400 && arfcn < 286400) return '76'; 
    if (arfcn > 620000 && arfcn < 680000) return '77'; 
    if (arfcn > 620000 && arfcn < 653333) return '78'; 
    if (arfcn > 693334 && arfcn < 733333) return '79'; 
}

function PlmnPh() { 
    $.ajax({
        dataType: "text", type: "GET", async: !0, url: '/api/net/current-plmn',
        success: function(data) {
            var xml = data, xmlDoc = $.parseXML(xml), $xml = $(xmlDoc);
            if ($xml.find('FullName').text() == "") { 
                $("#brand").html("No Service").css('color', 'red') 
            } else { 
                $("#brand").css('color', 'yellow'); 
                $('#brand').html($xml.find('FullName').text()); 
            }
            if ($xml.find('Numeric').text() == "") { 
                $(".nu").css('display', 'none'); 
            } else { 
                $(".nu").css('display', ''); 
                $('#numer').html($xml.find('Numeric').text()); 
            }
            // ... (your long country list remains exactly as before)
            // (omitted here for brevity, but keep it unchanged)
        }
    });
}

// ... All other original functions (DeviceBoot, Signl, color functions, getNetmode, getInfo, getStatus, etc.)
// remain 100% unchanged. Paste them exactly as in your original script.

// Just make sure getPublicIPCountry() is called in Main() as shown above.

function ftb() { 
    // ... (your full ftb() styling and HTML injection remains unchanged)
}
