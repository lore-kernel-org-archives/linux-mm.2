Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644A7ED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE6E6B0093; Tue, 14 Apr 2026 04:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF96C6B0095; Tue, 14 Apr 2026 04:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D236B0096; Tue, 14 Apr 2026 04:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 967526B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:22:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4941A1604E0
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:45 +0000 (UTC)
X-FDA: 84656470290.28.75C0F68
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0814E80010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="D/QIcjvQ";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154963; a=rsa-sha256;
	cv=none;
	b=bu7TWs/mrDmTf/XutmmwKvHE1v2EfWKg6KeRT8FmABYEE5yIC6JXYzK/ipAT0g4u/JRkcK
	71RU+AIaMF+L4wPkbBg/OKkGFqqmtYjf2CVS0q+gSSjqUALeA0p9SGefPqu79WQRsPlkjf
	cjcG4owRYzkfsIX0TSK+ej644n8hhI0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="D/QIcjvQ";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4+alkDxk2QDPF16dmwas9Ikm+JFGV/Ks8483HUpmmI=;
	b=H2wft6ObJrc5hBI+skoW+dshaHrDXp9UwJvRTA1N0R8TEsg3ThXKRb8dOOWLuqdAotBkGm
	pS6UM2QSOoHtLl/BZ760kgKTgdXV5FexpuwUb5n6c9XbO8qalhH/rWOCyjYh2exEUYOp/O
	CCf5CyCO80zIPNM8cwe0N4kbWz7REU8=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIVJV1734017;
	Tue, 14 Apr 2026 08:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=M4+alkDxk2QDPF16d
	mwas9Ikm+JFGV/Ks8483HUpmmI=; b=D/QIcjvQY9cXbIRtZLpjLMr1M2mTa7Rup
	SX+VYFeVvJrQSyKRg2FzGoBgj39lm/6Ls+B33TbPy6bZVc0zHqQYzNYM9krlCfuu
	OHauRRzL0AJzeyFu3cvNPYooL83YbYk1PnePzEatvhAz5ciW9RPMevheAJqh+uB2
	rW6NuHmtPEOx/Z1l5IjAgHV5X8s0PJee5sTPzNA+Vtgdnt8NkpkNCMXijXTu2mcx
	oU7EwLZ1ZzlWbBbJvrCcWHX2GMJektet/LQkxMqasn9Q3UV4p0FICcEHDVSI2RuB
	MbcfClrqHJ5hm6dhFev/+eZvzIteUWzbbzRZwmI+nfdDoUf72vpbA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89m1pmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E3q3Dm003514;
	Tue, 14 Apr 2026 08:22:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mn8m6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8MSNm15794556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6ADD20040;
	Tue, 14 Apr 2026 08:22:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7478C20043;
	Tue, 14 Apr 2026 08:22:24 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:24 +0000 (GMT)
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
Subject: [PATCH v5 02/14] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Tue, 14 Apr 2026 13:51:56 +0530
Message-ID: <67c963da1868fd91d2814dcd1b80d385ebf63c35.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69ddf949 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=TdliVB_93dTD34Rfq5YA:9
X-Proofpoint-GUID: GTYupr-bCnNQiQo-oX9tYfwjx4Af8n4c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX24I3ZB5pBoIC
 AtKOebc6JGrM5cm5PRVFB865mVlXicRbs76WiZPpbRJl1oMNXKpcjaIkz5KS5c1Flx4pQZmxVx/
 u8LyZiMHRCL6KiNMWX5oK685GxU9NpaQFfupyQ93OcIf1jKperEcJYibZMHeeX4+7rZAyPke9+R
 jSiSX6n1DELRYQiOjq9QxNvhzGJrvtRsqDBWhN97hb97EbqYsVK341fhPhtWpNtVs8KYj6BbKFx
 87J5OYE/PXBDHottSFJHYqxmgnA+G8p3ija8DFRTQzOF6u6+YYnh+NVgqbAW3TC/8R/9E26v6WX
 aQEvsBq5Dl4rMUDpI8zq6xYhZCUZ8Vgi9HEMGkX0WUxurUOAvihcKFGt6zVIcK86V/QCErbJHNH
 JZ6vlCIkS46EXLOEmyn+SSs2YavsHH1MeyoXCMr8uQFNyujJvAHdB6McfQ+DKS/Cn1M+0aYFDmP
 W/ymGbuo6h02chDIebA==
X-Proofpoint-ORIG-GUID: lxA0h4Y3fSLyq5FccXyGLxv8Hx1wPh7r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Stat-Signature: 5wwqbhohwp7fj39rn335mabdkkkrbjps
X-Rspamd-Queue-Id: 0814E80010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776154962-373277
X-HE-Meta: U2FsdGVkX1/S6FOOzTdbhVVi+HBQQdqadCKnV9VIhIawks3qslVht8RcRZLFYu5SrQX0TyRHhWyz2nUyd3gC2HFa9O51iZLcInwdloVU7MXR+ah/4WtWSMp0700pPo15hyR/tQR1QF5TUTzhSXHa8Zduem/P9jP6oo7V4qdu2hcGliu8vgK2km64v22izCmM7BEu6888jsRw68gCbOzQHygRenB9zAzLCM6n0gGoC3ZJDDOcrdNxEJYnsJJdVGWIgj77DtG1+jEM0SCevCBMd+ejKa67ioMlOdvR3qLTpaiO5Z2geUpUjjkVSOhcB6hZquQCMtrFM4wQLelAs0VEWFFZFCmIiG4r5XQ2GfKaPAFjgHVVCZyNStG/1IsYTUMdkWMEeVNdqZMTlxfW0pfs4fT08XcoNnMF8aVCibuAhEPm+TJ5/r7B0ng5F25S4885FkJRJcq3p6/OzBMc4n6pCjhCnVWHN0eIkmCHLD6A04thT7l4zSwFkWtYH+BMBm9PYKzLnDJsWTt268BZCtwJsPNkt5Cn10bmwjfpV0n8LQEcrxDtq4yu0Jm9Pb+hPv2OYjE14EI11nwhX7qgnY3dnSIVeg3Oh+2fbmnxxu4p0bfeA/12XeFX1vXZo8mjxGLxsLTL1OAX3kmJkO8Dtg5AYWB4rmT/lsMLhfF6bY8qGXQs0CAXrACEeMVXBCTQx8TNKYYznDjnzUZ/P3Pau/OSVk6ZyhO9NFJ+73wBvHFk5jUK8CVui6RChAQrlLDxo3pxG8wnKCTsjhqvcHOmzom3tZLuuNF8ZogW5WgRFJKvEIZ+HWzWM+SG7D6e+emky9iWqzl7yLRGecvUTESsHYsktkL2s8aef6kJS0cxqlFcRwMTDYkWaVuC6mKP00agBUrBJIVvP45UE2lbjSc0UpRWxFsAbArVoODM3rGwsph3xVPyyBEq5ZakPELKkky/n+LrKWcfbPyqHicShkMFMq/
 ryJF3wZZ
 Vw8Sy0bv2RwvGkGO1muruFGWNRBONwm7Tz99Vh4UdXlL0GDJ0KuhrVVCk4qWkmrM12/CBcVmxeRlGfUxrbocfs//6i8tR7Eff6LF2CA2AZdFRwhchnU84cLdbLDHEQa1uIZ86SvZB2etcgs9P4q5ksVN3L+a6cRe4hv+yYd0w2B7RY9syUxOHorxvSRyJLH7kBqqunKJQP2O+koEwZZ+pPHOge2DSzwB04+rbQe3ropuU+nzGsPHlP7Ewvl1fbdLq6a2wzDc1mCwmrH4t7GnOFSMWsuSFC4XbfwZD/1W2KFQyOk2ooddz7w16tCoZ4TK/5E1lsdtPmoKgOVrhCA5bP4t0SHAYe4gih9BqfL0FtG6vPe8=
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
index ca33ec83ebf2..4aa7920b533e 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -89,6 +89,15 @@ function get_machine_hugepage_size() {
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
@@ -98,11 +107,12 @@ function setup_cgroup() {
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
@@ -137,7 +147,7 @@ function wait_for_file_value() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "0"
 }
@@ -145,7 +155,7 @@ function wait_for_hugetlb_memory_to_get_depleted() {
 function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -153,7 +163,7 @@ function wait_for_hugetlb_memory_to_get_reserved() {
 function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -175,8 +185,8 @@ function write_hugetlbfs_and_get_usage() {
   hugetlb_difference=0
   reserved_difference=0
 
-  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file
-  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file
+  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
 
   local hugetlb_before=$(cat $hugetlb_usage)
   local reserved_before=$(cat $reserved_usage)
@@ -307,8 +317,10 @@ function run_test() {
 
   cleanup_hugetlb_memory "hugetlb_cgroup_test"
 
-  local final_hugetlb=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$fault_usage_file)
-  local final_reservation=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$reservation_usage_file)
+  local final_hugetlb=$(cat \
+	 $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file)
+  local final_reservation=$(cat \
+	  $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file)
 
   echo $hugetlb_difference
   echo $reserved_difference
@@ -364,10 +376,14 @@ function run_multiple_cgroup_test() {
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


