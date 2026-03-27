Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCC010BA43C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873F66B00CA; Fri, 27 Mar 2026 04:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A656B00CB; Fri, 27 Mar 2026 04:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760396B00CC; Fri, 27 Mar 2026 04:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 677CD6B00CA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:26:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1478AC5739
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:26:46 +0000 (UTC)
X-FDA: 84591162012.14.5C3EC75
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id A8C031C0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:26:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ImmF2l1r;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJXEwsRSQCNQK1VLY40W+I6XlWOwNH/ZLywm9nkr5l4=;
	b=MI5FHwtXRdiYFJ5ejxlAtuwnwv1/neY1mkZyDovYRZXsDPcC4qF7zyHFzlyEqVDmEd8ZO0
	Trk/nMP+Ko1mwpIQkIT/sFeL3htmUdS9EVkAH7FjL8QP9/0wU6mn/P49uz8cDNraaPnOPe
	6ZJrz/XnwfLJFJrJbQ3tqhqitdOZjRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600003; a=rsa-sha256;
	cv=none;
	b=6vYgIlYk0n5aubwTdeuSp9IVBOAVpIqkb7ir3nX+k15RlI4jX2nCiQfl7k4dJqmHMgXcZ8
	eBtRbyGEqi1IfJr94t8yF9ROrJveePynR7r9EGAW4dg8RNQcPK6OgZchiBpCRDp72POV3/
	q5scBu4Tof74pEMmOHUFKI1CiptxB0o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ImmF2l1r;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R0Ql9n3430662;
	Fri, 27 Mar 2026 07:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fJXEwsRSQCNQK1VLY
	40W+I6XlWOwNH/ZLywm9nkr5l4=; b=ImmF2l1rTm+2qfn67EKymylI8OvpE3Glg
	77j8i5gx5DKrqYfcWGUeYJoJlcsoD7W0cQfJmWqhxuRynxccA292ZY6gk0NmVPVv
	2oERSC3fEL10bKNRnlgZIGRqlN0tBa2ZzKdVcepQUFSO4ngUOfg76MVsNjV8TyjD
	aT+4pnI4FcDQUGkOCs2zm0hMYhLTX+kLWlMxjtyuITGRacBtLLZvnARxeDO3pPlR
	VGVAnSNNCRkTFXBQbQ7tpzEPcloEOO5NVPexgET0CXt7csKjlPr53DP02IChtoSm
	QbrfOkBdzmCbmLpllkenag8RG8V6tPg/GXu00blfH+a3QATS/S5LA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty8xa2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R60MmD031605;
	Fri, 27 Mar 2026 07:17:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d25nt6mby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HNwS48103898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD8442004D;
	Fri, 27 Mar 2026 07:17:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A47520043;
	Fri, 27 Mar 2026 07:17:19 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:18 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 02/13] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Fri, 27 Mar 2026 12:45:56 +0530
Message-ID: <705e68507c9a0d20de835d53dd332eeda7dee772.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c62f07 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=oz-P9AN4QEfTUXci77EA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX7229uMID7rsD
 xK3ySMGDgQsPLysUXUjc+PwAdyy9zTLkQ4IS0J1ZGNIbi+u6Ygo1w3jmuZNpgv4ZQdBGVXI9WP7
 ozCT0bWPegx/TibkBM4XoCkwyqu6YgfcYghdQ9uHjWv3YSldeOKf8zYEofVfNxzGvkrrfAAbidw
 Hx7SbzXDCtt1sLNn2/r9bLoYIKlpFhHFsGslStH+25usXKoIj5KZ6LmiQLSE3eed+m0a3KdJ/AU
 ++91SL5ioxsO4bg70BghC0+0F0j4zIzazZD6JvA75j3FoK5EE1aAC6+jgRAdp83thPj5S9vsDLA
 zAv8Y/2ktwhlm2xNfAXRqTO73zrk5+H/L0pOLjXefHMEZnBpxN3wB2Yt43YgFiuWxPN5VJ8BW+l
 8OpF4XLw9k5KyHIjpJtsQ35tqK5Pz47kvP3m4tJ2HJJtL40yZuDEs1xun74qDXco/0a1h5hQrwT
 JnpHboQ6IYQlWmtOuGA==
X-Proofpoint-GUID: DQyqYMenVBNw9l3d5jFQchyRFqiv8lKe
X-Proofpoint-ORIG-GUID: DQyqYMenVBNw9l3d5jFQchyRFqiv8lKe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspamd-Queue-Id: A8C031C0005
X-Stat-Signature: cg3yaiqokgqngu8a3in49pdpab3dukju
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774600003-924132
X-HE-Meta: U2FsdGVkX1+mABoEoBLyRepoo6TvaicurX43jEd86zAtr1ymhLK+vbvEYu+B5VhFKig0iRbJNRc5U8fHRWBeIjuvB056ztIFtcaZ/sKcVVeWbD2WKLP3kMs+vo3HsrfsmbJOUBaTrAu9ghrG8YsfNvGWwvzViZP7sdaUzly2rCcnN02yKiIKyet3GPxqtJqTsP/dq3mrTp3WJjf7vPPhmz+6KMRXGczzK38k8JEQuf8voShPjVKgnLUp/UvJXCtMmYMHfdYE5QHJJguRmYg/j7669pqcvBZuavfCfOJOaFNvrH46ZLcp88rZV65m9PuFnW3Cupqab3NcQIb7gxJStDGnBVzvXCoX6T0ZPICiQWcc1gWVQg/VNneDjCwQlk2kki2nAx8x/5ml8lSidt4WTu5gENpD7Fh+U2fYhS3LHfRyP2qslXLXvDXjbxTR/PcSBjOfonM4oqGXgD92vdJuvaUg3tWTGlOC3vPDk1eh3o7fwNv4pgitW5jnATZYGfEAHk5uA48FeJYTrUohc79mGN7xleXLO22H5peSZ89QsrK12cKcfsyEieV65YmjjQ/hHatZs954Ya6FkcMDl/1bH8uVzLPyNhqqGQKwbUdaKFsTcB7Ny67g5mS3hH7RwszitRu8ZLyBocs/yG8++z8YvmYckVIKW6HvQDUhp5e4LP2/K+JW+UERNUG/HPyQrL3N1tTVisrlC5fuL3Gbr2CMm7j640ShK63jgO4ZfpyKaHkR1JV/0shBUjeFmaQbgFU2ECj/S7MF/3zadH2fE8+C2lVDuVQhC57PIHU/75QJADZmv43oEyKgA80tFCHRat9pKYM7P+1j2LGInXHPTb2eSmpJ284I9eF75ICbbnMAAOxSpVW6TEaz9qIUyyz+8d1MepOqhxB/bfFVGIXbCJgSAapMSEb8QQc3/9U5Oho4zmSjFPZtYHHIx5v4+LkkK9ehXbFSTvA2tTpB6rMMkNT
 DQ6I1oBI
 Z0NaTDIseJUA5Hh8sXJfoRk54jV4Vv4DzvnkRs8hPvxMCjnFq/oxGZXFIjbqFYrCt4U+sWZR7KO2tyZI7u0Cc1fpSZe6tqpmcjosVifLTOMvS3j4tP/vgNhAiEeWFv1icifiSELkK0DhKkKcoHL6aE8WLNosh8dzyUv24LLD7XS8GyaXN42uMLU4k/XWqJYFZDKYTjMug8MUJ8+KSEXtqaZZz/SXjQDqrKThcMN4BbF3Yo0KHZUCdfMCha2AHYe4fkx2D65hREcbMuJ8hvdz3WrLIMABKzUbo/dzE6BnNJz64n2oqzlceiRAbtwbWmZR1WKMSz01ydKtIEBKqahaTGwQil2d6rkdZJMTch2IN2NFxII4LIEQ2swhJuXmI6Ug2aOUO1YIJGp251WkUFGonjeoJYlOslCg1xnXU9KgvdSNCBRBylX2474iHtw==
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   | 42 +++++++++++++------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index c9fe68b6fcf9..6bec53e16e05 100755
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


