Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2398CD342F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233116B008C; Mon,  4 May 2026 04:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2BF6B0092; Mon,  4 May 2026 04:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D21E6B0093; Mon,  4 May 2026 04:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F27A76B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 971D712043A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:35 +0000 (UTC)
X-FDA: 84729053430.13.B36E141
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1D067A0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cKpPVuNH;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgPvStPGREceM4mKr9/dWDqLQj7sY9BELv0RlZiiqEs=;
	b=uGlEiYfUcwtMkTLY/bMeZHxFwLVFznLtlFAFn9TYNKPVgt5D850AMOPNz7gOjpGtqs7msW
	TgKGnJnbYwfa+SxUll0KKqyHrz0omrz51UeASWR+ZwcaTo/AEjuCTXbUIA5VsTMy1ghrOs
	5dVwyTu2zmJKxuaL8rJU6hrWuBmiR8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883133; a=rsa-sha256;
	cv=none;
	b=BcUJSwSkTXMVJVbgI09fb/bMh16ypBpDeUnRSPWwIl9/W35dLmXfpglWIARAgdIiCd6JvX
	JUygvB2kF39XlYngClf46TjZe36dll1n4GTLPyF8JNbGj26c8UThINkaxZXZHazkbfhX+d
	vAqIz64JfffOHYEKYuIXhqJrbiwuChI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cKpPVuNH;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64480dcL851433;
	Mon, 4 May 2026 08:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EgPvStPGREceM4mKr
	9/dWDqLQj7sY9BELv0RlZiiqEs=; b=cKpPVuNHE7dn9/eZ4jjsn6o1VB19//MoU
	3LZJILkihurvmIiHIgPD04ZDge83V/T1w0v4BipOQ4V+f1iwi6MiGp4DNlpP6Nu9
	JBq+/xW5lPIcdFjg8cMf2Fn6gZYIidowQDSoXwrKPNZO6i+bcbfpGj6DLF6oGC0/
	RNvC8flKhv2gr/WHILWU7k+eaBgpfUmMsfXZYO7mBwaV/PGs5XQo01C7ZZntYPfT
	zb1qknlUmPHBCslvoRktmjGa/PnjBhiONHtTuE4+Zyqn8IiwvBtXpLZ9HUkcxAS6
	aIO91TkoXeCHoQykB0xS3xHNo+IybNuH5hUwvCVNtnUqndnqAPolA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y4dxjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOUM031438;
	Mon, 4 May 2026 08:25:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjma9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PCAN62062902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87FBE2004B;
	Mon,  4 May 2026 08:25:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39DE920043;
	Mon,  4 May 2026 08:25:09 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:09 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v6 02/14] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Mon,  4 May 2026 13:54:39 +0530
Message-ID: <2a78c1d4dc4772c8e828c809d1e1a74e9503b257.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX3J2sMhaqjENq
 rWuoJIvzMjCKWFm73lakuXSb+Qe5xhI1HDqgBjhIsh54VDK7Ut2nByJ/U2kZnMeTA4dulXqW99P
 TL+CFWcD6jPJ879/QVcV6aGnV5G+4s+CW7t9z9L4LFh3jussW7MyKN8fxXknuabASI3OyjDOpRP
 leqTjyKUxqV8yF/FtxXyjx+i9uIrwfE9VAFJq0k19nv4tcJWHWxNwjc4un0NLMcauq5B7l9Oo4O
 796bsiINH8KIYQRqKX/w1oTzKocSyXDt2EepK8F4Nwo2xWKQI5Kyur3xNyiceYWxzD0gJSHE2RD
 qWcFVMOX8n8eXRp0Ys/NMjg8I4Qj81b3prZQqTlogDk/7/fWbG8dGRiNJrNjkSFWAnSvIBZgTwX
 aOlqdz6LazUOGWVRzX5/Epye1K5aa4m8jlEd5HtyBFq3SSY3sVtmt5AmO+OBAkIOUFTq5hCFRHL
 TtQKtctcy6nDlrzYq1w==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69f857ed cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=TdliVB_93dTD34Rfq5YA:9
X-Proofpoint-GUID: PUjkF3GxY4USF1WyGh822UorCISuXIi8
X-Proofpoint-ORIG-GUID: 3RpdCWffShFdQCnh0XuyZO3JxijIhfaY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D067A0005
X-Rspamd-Server: rspam04
X-Stat-Signature: b1o3trzrdr6tj37bc881iehsgh6t6a1m
X-HE-Tag: 1777883132-393032
X-HE-Meta: U2FsdGVkX18GRgUJCVQZMyhqWxy9RMLlTyAnoyzxHDdOdznBi9VPb6hi7fSlB7Zqo1nqckl4SKZ+8I6xlHv5KY4XE6w0rLJ6iwxJAvzU+8zTCP4vL03n4/R3K657oOJDQ04xbBRNarxpTtE2WsdRNrVWBTNY1cfq5gvEUvagYMzfSh+6kuknWyQ9ejWV92k8WxllxeyBZL0H308lntk2JuFJJQuMlEfmwKIm95RzyDKhE1NZOUSr4/9JHm7wZLJUjlTCw9xJiTtDBficahcSxF3sdPVMM+dspEXOvm+gOWW+kaSendDNczGyTbGkso12ubj63Ho71xEZ/s0Qwuv+jV12MRrE0iBVMit85j07o2E8qYzU2ObXqvtIY5QwhwsHEC5TguZ9qimFFbDbTq0R3l9FS26GmlpzAfkwJuayytpTWQcmC3TTZH5MlhtrbQ8cG8YH5pKetU4gNc5hCD9eKOii9HK99hk5mqjtTDAnznkZ8bBD7u4bdNVK+wtkHo8Agw4N/NJypRh74W5TAobM9u0sa4KRocc6rD+47gvxO+OiE0DUF/ApaV2yji2tGX5G1+YR4qHm0yvsvQpEwWipMkDDCjJkk2dnYwhHXaPsHQRH1u0JracyxwVJpixBVvxIfromLW2J90sfBWWSLEwRAnZdxfIijFQ29DIIc9WoGTktfFP71eVzICct0/OWNg+KZvbZmyAAvuwqxpM0tP2ikThG+Aprt8gPDGOrhk73D/J6OADVhCJ9Z6Az7qgw2VZcA8mxdRf7lkSAvPDBnzqjoy28T6mc5jKyNqcVJLHI4wIKSWx7OswVKE3tefmd/Cb2uAJ0ODPd1B+p3D0neYSBhnWWDu6z/V+XyLzl0MrQB8wKJcyQaatHgXfMAehoPfTA18ZuZg/xerIoA+BUSlID6DwexwVrL0RAGD8xTaThEn0XHAszjlVIKpDFcEZNkb3H6hPaku3BneYWy1TGFXz
 rlMg7CxA
 h8ZwWZX5l49hZ13QZlS6UU9RqEKhWwYgsPmQie83Ob9pW1ZsTES2YaO0ArU82B4mE5omva4/uBAx7Z8K+/tW7sSj/AdNkXXIkqjabDKyYm7djoIdx8FbbbEJCUQX5Vw2a+ydkrtoeFGdwbwZZ/4D8NUjEAY7AwIfrcpLqhsY8cydwKkcS39dwq0hGoIZof/1LJ9xuPVhvtHmI2rIEIgXSaWitqgD9GRoXqEzBmrbBDp8MfLEHs5F4ZiASYcKtag2t5czVjdDAnlX/9XNWr64ThunOfzWjJpUbNtOHJfaOOQQNxUk8tvtBzpG7VSfG83kppkdi6iizWIddmOoraZbziF8Ym6xpNsxn93sSugstYROCUWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The charge_reserved_hugetlb.sh script assumes hugetlb cgroup memory
interface file names use the "<size>MB" format
(e.g. hugetlb.1024MB.current).
This assumption breaks on systems with larger huge pages such as 1GB,
where the kernel exposes normalized units:
    hugetlb.1GB.current
    hugetlb.1GB.max
    hugetlb.1GB.rsvd.max
    ...

As a result, the script attempts to access files like
hugetlb.1024MB.current, which do not exist when the kernel reports the
size in GB.

Normalize the huge page size and construct the pathname using the
appropriate unit (MB or GB), matching the hugetlb controller naming.

Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   | 42 +++++++++++++------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index e1945901fd20..a1cfd3a349db 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -94,6 +94,15 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+        # For 1GB hugepages
+        UNIT="GB"
+        MB_DISPLAY=$((MB / 1024))
+else
+        # For 2MB hugepages
+        UNIT="MB"
+        MB_DISPLAY=$MB
+fi
 
 function setup_cgroup() {
   local name="$1"
@@ -103,11 +112,12 @@ function setup_cgroup() {
   mkdir $cgroup_path/$name
 
   echo writing cgroup limit: "$cgroup_limit"
-  echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
+  echo "$cgroup_limit" > \
+	  $cgroup_path/$name/hugetlb.${MB_DISPLAY}${UNIT}.$fault_limit_file
 
   echo writing reservation limit: "$reservation_limit"
   echo "$reservation_limit" > \
-    $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
+    $cgroup_path/$name/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_limit_file
 
   if [ -e "$cgroup_path/$name/cpuset.cpus" ]; then
     echo 0 >$cgroup_path/$name/cpuset.cpus
@@ -142,7 +152,7 @@ function wait_for_file_value() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "0"
 }
@@ -150,7 +160,7 @@ function wait_for_hugetlb_memory_to_get_depleted() {
 function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -158,7 +168,7 @@ function wait_for_hugetlb_memory_to_get_reserved() {
 function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -180,8 +190,8 @@ function write_hugetlbfs_and_get_usage() {
   hugetlb_difference=0
   reserved_difference=0
 
-  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file
-  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file
+  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
 
   local hugetlb_before=$(cat $hugetlb_usage)
   local reserved_before=$(cat $reserved_usage)
@@ -312,8 +322,10 @@ function run_test() {
 
   cleanup_hugetlb_memory "hugetlb_cgroup_test"
 
-  local final_hugetlb=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$fault_usage_file)
-  local final_reservation=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$reservation_usage_file)
+  local final_hugetlb=$(cat \
+	 $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file)
+  local final_reservation=$(cat \
+	  $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file)
 
   echo $hugetlb_difference
   echo $reserved_difference
@@ -369,10 +381,14 @@ function run_multiple_cgroup_test() {
   reservation_failed1=$reservation_failed
   oom_killed1=$oom_killed
 
-  local cgroup1_hugetlb_usage=$cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB}MB.$fault_usage_file
-  local cgroup1_reservation_usage=$cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB}MB.$reservation_usage_file
-  local cgroup2_hugetlb_usage=$cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB}MB.$fault_usage_file
-  local cgroup2_reservation_usage=$cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB}MB.$reservation_usage_file
+  local cgroup1_hugetlb_usage=\
+	  $cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local cgroup1_reservation_usage=\
+	  $cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
+  local cgroup2_hugetlb_usage=\
+	  $cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local cgroup2_reservation_usage=\
+	  $cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
 
   local usage_before_second_write=$(cat $cgroup1_hugetlb_usage)
   local reservation_usage_before_second_write=$(cat $cgroup1_reservation_usage)
-- 
2.52.0


