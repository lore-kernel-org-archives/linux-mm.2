Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED695105A595
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21536B0098; Thu, 12 Mar 2026 08:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E206B009E; Thu, 12 Mar 2026 08:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74B36B00A0; Thu, 12 Mar 2026 08:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8846B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B4C61B6BD4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:18 +0000 (UTC)
X-FDA: 84537333636.03.E16D52B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1A3FD1A0010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gVZCnkgO;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0QkydkOKhoLNmLJgLF/owlQRw5h90x1mIX9afrQBgE=;
	b=gkE+GQLJzcaGxuTLz8mCxaSSsGUu1aFr/bbHUPE03Tkv0xJ75QAUpmfGf/M+v/wylyXgRW
	NI2In2t3KKVIjf3y/Fd7C9iItlwhxJHWRIdu8HAV3R7hap3hj8AiH6jiNA0EQVEadrSLBl
	2+0WxLnhp+hLv7fs7bC7A/KA+Ee8FG4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gVZCnkgO;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318376; a=rsa-sha256;
	cv=none;
	b=ioFNKW/2ZJoiB+C4NsWPP5dqg6mCPN6jTnUnC4G7VpDOW09kmdoqefOLju3qPBbLiM18lP
	Nv38wem2lH5GSWIgUj9+DWl7o2DVffRq2lhfc/0fAyM17hpW6PurM9bVgAMEVIgwIrb76X
	ryZc9R8E823kL2pT2hlv7OFsgODyPF4=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMXQdF2308712;
	Thu, 12 Mar 2026 12:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=m0QkydkOKhoLNmLJg
	LF/owlQRw5h90x1mIX9afrQBgE=; b=gVZCnkgOb+jOzr7+G80MZXqXWf2pW/A9N
	Kqo1Cr2/8wQfLMOt5cMWs1T8PJgg6DgZKWQyFmkmw6mp1JTu701oorDplq/gRTtZ
	Pw21/KYQalezf+yyE7GoHvSn4GMpxJLQJ8OIKrRJb5pnweebipO0+MOXGtgf1Vz6
	vmGwQ3H1yAHOH9NXVyQcUMW4tx3ollPCtRbVHNYeFzTxcPgQdwl/RqQt8rJBjE5G
	bfsHQblJuZnKftQ1GqFXmlwXE3GczsbuSKE9U5faj9eRBGSP+8v2Z7aSlDP0fJl6
	CELjl+ukQyRzRa892BwF6Xn0OYlA07mzHhi6uTOAn7OB0FTlusF5A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh96agsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9hP1a006110;
	Thu, 12 Mar 2026 12:26:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha9j8sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQ89J13304120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42FCD2004E;
	Thu, 12 Mar 2026 12:26:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0261A2005A;
	Thu, 12 Mar 2026 12:26:05 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:04 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v2 02/13] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Thu, 12 Mar 2026 17:55:29 +0530
Message-ID: <3b34767f2cb705c8de0f085a85bd21bdf6998ca6.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX0ukJMSfphzEA
 uAzBGRh78Kw7ScuYW8BhTs2ugeD4vnm4kXcC3K+dBDbtaUPvc7S6rzbdxfyqVy4aNsRUG6ZZTkP
 pcjtaUagRzim/kALYQYvj57LubPic+2hr1nDLaSzbUeB+h0nea+8x+1jBeYPB3BbgTAHz6sGZRE
 J3E0M30xkCgZViNkESSUihmbOy7evboAjikDrQBfNKLjJh5IShZIAV39/DjutVQC55HkPJ/h2CN
 EOM/yeo7rJBJPLeUtEesM1PddNJyn8OSY452aq4ci6h4GdEFrV8EfjzQgEx1Nsu1dwzHrwiTFaX
 FLIUcuolsyx9pqgxVGKX++Nm9XgJDPYhlbZ0sbz3hIQt83HsXyH59v5GnVK3YgcixUDGI3Y9ZPN
 0/4Y6u06aPEyz61dVtzF6uks78m6s3+lXw6Q5j8iyBAlVqKCBYnUyorlZ6TcbsPR/dzrso0r1Yw
 JNI+je4us8hjk6OzOnA==
X-Proofpoint-ORIG-GUID: johh-BF_ABvG_awVKqKkD1dMRoaMwX2R
X-Authority-Analysis: v=2.4 cv=RLO+3oi+ c=1 sm=1 tr=0 ts=69b2b0e3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=WRIUL9nW219isnRS5p8A:9
X-Proofpoint-GUID: baVXooe1AnCFNjzDB9OMaTSxLDY9wfTr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Stat-Signature: e9cceq8ajsn83xuzootjw6z4x31yn8y4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A3FD1A0010
X-HE-Tag: 1773318375-945832
X-HE-Meta: U2FsdGVkX18XudJobSznD0sUtfDMYQB2zOnmLAHJC7vLUt4qLvlKPKSoUu1W43AjCT28ORPVrRErtOfrXyGS7P/HOx3kVlaD5tw+rbKIDeCukJos6CpXc48q/a41VgUHds+sRplP7YoYmYcM+2NabUHf89HTO5oulynK9ybcncXEpvltMGCgog35GfYvQ/fBKClFfZBFAfPG/KKd7zwNaEPu6RwRFFiowaFuIx/3M2+u3Ed0pWp2/ADInWVbVPhRPxskH3ZtJh2MI1EvJLbdKd3xSFoDJxtqIvq6WlZc3ISTlEeMSEeFe78dTwebiqWoxOt4/qv13Q7yAI2mgvyenxZRL0vWUxApJSE5FtiGhFL2/yIwZvtTW4HPKtGI3UVy7VKM76/43pfehRhcfNZhFmf6Nxg/D0gG9DrA6AlqhQzrT0Dc+h5aUfc3rI03yVTOCRbrNdWATYIgKvQXRlca9LWGdp4TBdSTMguO7QT5omvoDVN3idKlWyvGWAbr540dudFrUM+GwHfzfmq0XChGuQC3F6BedsREz1fOEE7vTjuVs0NmYNJ0pI70dMuWDHm/bNK5aVOOYTPwC6uJGeWg8gBTmUQbSlXprLnrQIC9D269v7TbMfQQcoUBgoPAFvTdexsnEJNTmJiuHegy/s0LNsiR3A76ETKwqiUhMh/8P+V6XS1YzByrglS6uvbmYQwTcI2lo758HE+aLuR12RPi51FTxHYuW5lcAWOfVctmpzQPQfDUyDNEY+xbAQYyI1cLa5WvgvntNzex4fqQcZrmWmEAAkAfcJE/Fj6ltLe22VgFCTF70DLNTUtTX+KZMccqQBAdYXLqZdGx3om4Nca9R3/e2Lt5CPEGCeC4L+pQMeHzUvpMJYSHin6qPhvDcaL9E8/Am+LYYHUNxA8KewmCKXbBZWQHZubMrD7GZg8ClOzTzDxrsdU6semVGxzJOUcKmddhoYyNftf+6jUsV0z
 Lm0/DFXh
 umhLMOWFfJIRtFUJDZz7rlfmSRckNpTZJPjNFzxw7aWDUIv8yynYJgUrmZp1WE251GFfy4NTEsBIyl6ggwdyeeZK7yS+T0T7STgoHa0G6MAJkDiyV+V5vZ425eXy4PSuegj3VB+Lv+syvpOkBB80oIAkwBJltJElMTTbxPDlGahLov5M3y8/7r60oRNJBApDfMt5uE1al+kUkRZ/SJxhncC8ejOGv2AeYJIHKrHfOHu2U273pQYtmZLR5MgxTHMvA/rIezS3EuPwHhNR5Ta7EnBDZO/kakko/ie0L19yYNA9VgisSNHaHbHd7lnuT8GQEFg1jFtnEF2k970gaeXeofuk0zRj3BIkOKeocCXGCEnZ9hOtcNtQ8/9jjPc2NZFAWBr/k8pgEpJpStNViPfWnZdch03F5tvQ0Wfwk2Xe+YYSQMLGONiuLjRyT7w==
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


