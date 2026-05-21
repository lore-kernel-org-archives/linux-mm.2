Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7585FCD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B2B6B008C; Thu, 21 May 2026 02:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD36B0092; Thu, 21 May 2026 02:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3AD06B0093; Thu, 21 May 2026 02:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55196B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:34:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 724DA1C03E3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:34:17 +0000 (UTC)
X-FDA: 84790462554.30.8BC1A94
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1763F18000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:34:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kyaoG8R6;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779345255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgPvStPGREceM4mKr9/dWDqLQj7sY9BELv0RlZiiqEs=;
	b=t+0mOy9qViJphnZVfo9Y+ym5OgzOr1m/wdqK8hcKAdN6S+I9j40fqZaos8X909iZp+kJQh
	d7Ly7i5uewAGEO4lfVvHJ/L7TAqCnar3N/skt8nceAOhE+BG2r9F6+Tvv7uivoZyzZawT6
	8H8fyTF3/Y5BbuY/5L8Cd3SLtyAADOU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kyaoG8R6;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779345255; a=rsa-sha256;
	cv=none;
	b=ifTEyZSjjk8qRqDykwzcbxHXc5Zq98L+CgAFlO1E1HgQTnMLMcsjsZ8wSJO2aQVj5oxUvo
	mSAwUCEusm17VRb2NPnV/ykVp7CPbnM+ier/S5uvSsIGRhuxguQ+yYtNGN97RSufSvF/Cr
	tL174yF2M1A4dwFM0nqafeAKuf8trhQ=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L5oYLv3690499;
	Thu, 21 May 2026 06:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EgPvStPGREceM4mKr
	9/dWDqLQj7sY9BELv0RlZiiqEs=; b=kyaoG8R6Md6Go+p/1ydpucSbS/fcHTDsz
	lK2WfSPicaIzn5E+8ZtZAGCU8Ct3Qgo9BZKV4h60j91nc++bckIIGJpf5iwmR4cG
	V95s0WvUi9qQ7iv4uTbTCAxqOyjRQL7yjeCksJZhZiT2o/bxbC/gwL2hUp1Z6WFp
	frj1zEGUUKY8N/Zbn6QcyqUneN7OMEIc2feSPTHBevfGFh/zJ5Z9Dn+Rdh4TakKx
	P/B0lP7waa/l1sWhbP6TzHf3NxoVCt5cyUaePFqN7gVRStcJwtmaH/vnULeOh/fT
	tgjo/Cl2Lq9lVaT90zQwVys+w3k+lOuVe9hsl9LNLdlsKTmy3GlUg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawcbrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:34:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6O9sJ026822;
	Thu, 21 May 2026 06:34:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhtq6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:34:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6XxPH30474932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:33:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 171E32004B;
	Thu, 21 May 2026 06:33:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AC2F20040;
	Thu, 21 May 2026 06:33:55 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:33:55 +0000 (GMT)
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
Subject: [PATCH v7 02/13] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Thu, 21 May 2026 12:03:28 +0530
Message-ID: <04b6b49e4a2acf46319f627caf82b09e6dc1ad7f.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA1NyBTYWx0ZWRfXy2zZ1SaT9IdJ
 rTates2YpOfzmmG4rnGF85LultnSzYXsfTYWf5pAn2B8TK3UQVHgWvRRz1F5UXKApl6izvikpDd
 DT9gq5UNUBTvbLE00i5JHr9Imu3p+brbIfLl59deP4tAzdfiB729wudt6M+RoP+qZw57AkOxAml
 Nxzhg2R0ZI/sh05Ac733qeu3A/eT1cDGoZGXZVU3TryBQo5Ac0VjdK7fOwmxmxkWyYSJB0ZSNUy
 f44sZnEhgsrk5/gxX79oN7dYrPTyq0tp7emH1ZXUoXzM6P19PjBTZBOXHAk1U34FnuqtktAgVPO
 k4mOc/m2zrxspqeKldTfcoaEfx+XCsuPO0LaiWl/81QkCBB2fAUJMU063HNSwL4/QkU85aLLkm5
 /A7Q30Gb8/NVzBRWzeWkEMmkkgFgn1PdkXDcIZu73kXHGpKEol8VnfpXzU+w4FzrnB9X6O9l9S7
 KR+q13s7iAUWqzr3RIQ==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0ea75c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=TdliVB_93dTD34Rfq5YA:9
X-Proofpoint-ORIG-GUID: N0OmnNEPCXgKEKiDcOtdJjyUD_NIpF_m
X-Proofpoint-GUID: iZqF1tYzYIkORx5DQxZSgFOKaFmfIvHY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210057
X-Stat-Signature: y5ui7h8rymbkzu9kbapy7kxyqydkqptp
X-Rspamd-Queue-Id: 1763F18000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779345254-614393
X-HE-Meta: U2FsdGVkX18deHikH0R+YU9a+c3q8NECUNagcg4rI19LR6wdtKqiBpJ2f5lybiWSbfSyS3oNhe2TkNkwmQWKt69/5B+kc9gOYtpPIt3kmdpRqKYwMBBZTRGfFfBrBoYsEug1M+B4PIx6/kwmrJKewKuOVmndkXQpBfcB8YbUY08+pxdmGF20Ui4SevuSKhCHuPatZJpC9fdXopov9CrisVFw1rMSLrYMjXS/TYJ322k5+YtZmr2ETQjaCAc3oK9Pdar0lS9A6KT9UjTxKmLl68msUvscIU3G3//lWjsx1xmW2UG+w39iI3pK0a0bBHovsmf9yNtoorgiLdHfwdfSjTfOOTSRE1YIy9D4/Lvi+SaHooi8EVnRc6grSAqXH3Gbb868TQAu1pTi7Ts96qdSBYXgphPzkTHaZIm48sBB+tQ1+GkMSvRouSZq84tsMb4q7uzvz4SnVNX0ONFZeb5xQNQteZi8fb9pQk1JWjadD8iHmBe50+U+q+Xq0FLFj4nk40bjzRmqzf9/VCPRNMZXMTvSdkdluNGYSFp/3gAhhbUGJAQHUoFDLr2MvJ3TXVyqr5bIX7PZ/on5d+xrCiv4ggyVGFzjoHcxC0+bgmWfD7QkXvCxzbIKlFDOKrDcLeAcIuhSE+0qB7X/vS5BLKEqWJmTsoWWBhkfMZ4xZ5PiQgbx6E0NXzZysAZegeAAe4NA4Qf2mntjMePFpvhPHxtaaxZm1RzC11j6FJVfBUlYcO44oMIib6SmwpHvO2Mwc3WaqUdkK4/SN3AvIPOw/2z03d+C5GjR1TCbcOMTeTvCB74+VAARvh07+pmkznw8AhNmYk4eRuidfER8aiVu0n+nG4BCeFZNt3OIHhOFB64nud3LG7Jjr4IXCp9LPTBfvSNTvH85FuC47lHd8t4tK5ABShL439aYdTMw9sKLjqK0aV/+k7ayItVuT2cEEYrU6LkSgaeBV/4E+Y4KcMLOgut
 lLmslqcm
 5ucmmH6rBRsBmbh3OGQI+Fke0lU6zJq2HqY/rmXhsQHeDm0sQL4zH4i57lsyYtL/QeBNG58bJsPFdlbXMUuBWHpRWSjtAdN89KbeyqmWmyHPSXl03gGsQ0jcghs7A+xs8VYrPWI2WsIxZQDTBZl1+EQ6zyHuIAA8MulAaeXpIKusz4FHYoRLMDjhNvwGprWaXnLO9CA9Pj1BYtf4kSLXrutKT/0+A9FnskMzNeYQDlMiOBMWava0FtVa7xVbRZzgRYd5VTqw2s/8rez7F2F5pY/d1ySbwPErb6a0oRWEBLWeONF5SSNh7HkE77V/d+ZI58QvK20pgAxdodWyWxwxtrWRE+JyghWUb3VRlq5gyzH3mWKc=
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


