Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E2CF41808
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24626B0092; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E58E6B0093; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7742D6B0095; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5852A6B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03F901A057E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:55 +0000 (UTC)
X-FDA: 84529684512.26.30464F3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 992A34000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lyP0dIsm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cw44Ev1/zAENSpXEeuReJdL5ZvpgnF0re3DdMky3mQs=;
	b=bgY+GGwLR5iXsvA5M4yNTpjKpjvJ2+bGehLhBNzQIcwjGIycwt6y/2MRcVMQGXoaeK3uYR
	Tcden9QDLZwgWSYGNMOZSJjimCX5R73Ahw4gFAkfkmFmV7JQZZ7wHayJiN/s7SUkywN1FR
	fCjLLqY2WAIZCRbCKVNLs1uxRfKbnjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136253; a=rsa-sha256;
	cv=none;
	b=AyLYY2nyHbBSRuj83xqHbQmPcz/PLa2CjjHgwvSdadh9rlrFN+LVcw/SwkXFsUWHp3q98F
	GEDn73bJWs9I5lMVai0he1hlsvr8U1O2aysZXHQ6L1Cr5QLBumBCzXIGraJ0uGxmybY9bX
	i8Qh7y3JUuVaGxJJdgXs6OnmAVaQ6k8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lyP0dIsm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A94Q0d1368044;
	Tue, 10 Mar 2026 09:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Cw44Ev1/zAENSpXEe
	uReJdL5ZvpgnF0re3DdMky3mQs=; b=lyP0dIsm9hDMYlILb1SNLXBnHKyUlG22w
	Vt7cmdzYaee11RwMaJhcMXXPUx9lguAO3icrhUwQwPkQnvnUtltPo877bg6yEBHv
	bJwpxlRdFSfMKPbfdm8/eXJ0caSmGhRwJVn/4WYZSEefsekVuNtloTr74do358fu
	BDXEq5GxJK7P9ynufHB/FLySYVY6HZsspQ8JDuKBFkrbQfrOQqWiewGpcpgFBfiC
	bfYvFV7SvdSDMLlyOSU2p9ifflI7BWejxRaK87NJ64gwghgzM0vTSn8+r6qNxnaE
	osykauw2Q5q77Mrie50803CCsPf8DJ94QGbr26WgXPRjhoabq0SGg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvmab3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A70M3k015608;
	Tue, 10 Mar 2026 09:50:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crybn8jbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:39 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9obXE26607954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A6B62004E;
	Tue, 10 Mar 2026 09:50:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BF1B20043;
	Tue, 10 Mar 2026 09:50:34 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:34 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 02/13] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Tue, 10 Mar 2026 15:19:20 +0530
Message-ID: <c0b65c67b24d67fd3bdb21dc35d86fe01a21b576.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: RdjNCsGmQZzyb0peIk3itujAO3E9JNgi
X-Proofpoint-ORIG-GUID: hM6rH3FDdhvvlmLDwSMWhMZGbPngFpFr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfXzjsIWpV03x/s
 4tYjB/zqazNmAzJ5gZCTkEm6BIk0uyPdnf6W6ZqWIS7FKLPs9ZMGq05T5Gla9iZrBNmxFX+a3no
 pmIl0x6rIqN9YYBUEjTohBN/fszClJk8/gbRkmj2i/N6yB13wpqZcRrb0JOonzh/+2cQuBi0LaO
 Ci1KkmjI+GYpBlylGruZqMbFG/6z5Dd4XYvbmoWCwxKZKqrA7XH5j9F7gopaPPI2zzpDGWALhyO
 MTz+fKhHMaTzlqON4B8Q/Bt/bGW1JZlCUx6tg+uGQfg0zOMUjWw1CTz8+DO3aMU+pEOW+w9c5qX
 J0ZTSCFj1oZ6+O9ib1iRr1ydI7PurUj2A2naWcxaX3dL6rutkd6WqcVDXxYfDCAovtl0AahYGom
 DQgKY/D2Zv7cXNJljpAcOrfIiKGQKQ/sbS0RHxb8lNYD2pWnEuUCaxxB1UD+IZ8gEgh8S7F8zJD
 fxeKJN96makRHiUNhmQ==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69afe971 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=LwIMlKd5CMyaTAMP7K8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 992A34000F
X-Stat-Signature: ba5rh8ontqh6mdzmb65e4uao6i9eawq4
X-Rspam-User: 
X-HE-Tag: 1773136253-390145
X-HE-Meta: U2FsdGVkX19bVuG0m2yGWzsOD8whCdvOcGih5G7hlzv6HXFasbLW+HW6KeCmBbJvOTfeSV9YKTIjrUmeDohqtVJbfBmf/lrrzI3s+4wdrXluU0Dv/912HDp21MuKt1G7xtegydt4ZXdY3gaBzqbKEcYNWpz3fr6YC4zShyscdALEmCqyA69vP1+Cs2fo90YmWXTM4wYPEn+RYcAoIgHV2XpHIXQHz7TokIzwWRahdlFTkm8P2kv+byPCPZedFJK8OGNx5bDKTg0b0zYQnClU75FTdMATH5+UNf6NOYxTFeVVKxzZH+fxjLiH8KfpKu1o/RuwJ/3h3b30f7tlzbC35m9T9Uxzwkxj4SbFAiOC27GlBspvZ3bdCb/h0xy48WJI6i+hbTkptNOh1YlRwYZL36TbIKGVP1DAFdnGXRdQ5qw7WqhhnMSgAlmQ6ZG2H3b8W46yqNyxsCdwtq9NYdT4olNlO6R5Z1xftUrKc2+9QFJzmbSit6EYnymCAdytPY8QLBs9CMPkp1q0Urx/X78fPUiwH0GBEk2Xykb6BjMxVP8+9QZrzi6K1v/NJqG4J5HLT3vx9c5aTqyAzxI7icmyRkPzHpboMbsRmAhV03azN30WU9sDCc157UoxeADwOyRF898xs42mpb6c4qEg1WW01FgrWR4n3h1pWEG8jXfH/L7q6+7qRHQf5lW0vmnjrvoPV1ymj7yEP7CQf83GOJWDLJ5ke4AtL7kPvKJn8SLjL+e+X9kfD85hRd2Qn3CPc3dh2uWACsRuuT6/zpFZqdspscM8FEDF7CylQoEUUUzD8gIhMxemcn0otRgGCWjUaCsIrml5ZFC/GSgqrQhA6EnJ3YoroqoI/D+UcN3A9qd74nLYRvFRTp7h6q6g5faVRI3wb5lH4NaELfPWLPMe0A+8xyC9MStN3xgW5blcn1vSZ+qwqEulk4x1nBKDgI8zeu4AsgvqrqVj5IjDzPQSeS7
 ui894kFi
 elOWR1V7qac/ZdW4mWemHVltGec15DHCf6b55BFLFnzDPMNNiV1e/p74hSXeHMRkCc5fus0x7jMjYSUgtIV5D/r88qhaAi8/z+tUC1FDulFkupBm8UFN4Q0wiThRKYg1OVFEaF2XiMLbtuXUtKgziPpTLHxMFWNigfZjjxn1xIcQamtGWOtMQk+jQkLwx3sSYLCLtHim8EDKwW00SN5tHc4NZwrBH+AlrZo6bXAywSmts+mEZNmXGu4PV15gWvNvTn7GLBUtd/t2OcLVI4wQ94s+ACb/XBQTSCcfSyjTIKifjdZtMe6XKxqAfo46x8k+nek7U
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


