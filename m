Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B50FEF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51676B00A1; Mon,  6 Apr 2026 05:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28306B00A9; Mon,  6 Apr 2026 05:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EC66B00AD; Mon,  6 Apr 2026 05:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 871016B00A1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:25:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 464A18B383
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:13 +0000 (UTC)
X-FDA: 84627597306.10.A22C452
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0F6420008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cM40Y6hg;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4+alkDxk2QDPF16dmwas9Ikm+JFGV/Ks8483HUpmmI=;
	b=ajgYi/Exrqfpm2lUJ6CokznhbxDxB00sc/O6MfQELGMtr2+cXnitoXMo+hQy4nb1rSB9nN
	eE+c8LDII8yF6Gn+0nnyRDwccAMQoe99X+TDUW/CsL46BeCKkQCJiSWUhfnndyVFsav7rS
	9zR+tgZPlqrQGahtZPEw4xWlI1bUbKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467511; a=rsa-sha256;
	cv=none;
	b=t/PRwYXleXVSjqbkPAkfp6qFdKWoa7uRUpu/cgHLGKS7aq5zqBjtCC/LhrKuJkWqcITQ38
	mg+Gomw1viC/cIZt9xSBZJ5yrmPzTxpdqCACElqbl7oIVuP3+UJ9zi9RReLyCD8nxQ9EAQ
	jPEe2z2RXatVPnlGHVHWp/9R0r7A5wU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cM40Y6hg;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635NJB3Y3836137;
	Mon, 6 Apr 2026 09:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=M4+alkDxk2QDPF16d
	mwas9Ikm+JFGV/Ks8483HUpmmI=; b=cM40Y6hgSbyOdEX5FkSVGj4iL575l2al2
	+3Yxf/fkmwOsRfO8V7gRuUgPbyZyaGuhSkO4aR32H+s4XDeUNyaqv2uuz/9zcGPM
	cTwJGM4cKZeZA/iuY/G85rId296AoTk6WiKjgsLdSLP8ynuYihZsZ3OwmzxSKFQj
	JSuQotx9PWh7HkuvzAL60VAq5sbLPAIXansE3ZQFD7mGJ3q6Gfiv16FFZzmVMj+/
	mZd1E+g/YadSwEvofVV9yIBaAjUc83XG/MIQYej0Fke6fU4XyT/ullyE/VkqfAWe
	Q3wfQWBaDCpne8bL7yDl95IOC9Zhe85xQwxLwYu0TLswjLZb09yiQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63662whO022853;
	Mon, 6 Apr 2026 09:19:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbefkc0v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369JovV52494776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:19:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EA2E20043;
	Mon,  6 Apr 2026 09:19:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DDDE20040;
	Mon,  6 Apr 2026 09:19:46 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:19:46 +0000 (GMT)
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
Subject: [PATCH v4 02/15] selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Mon,  6 Apr 2026 14:49:21 +0530
Message-ID: <67c963da1868fd91d2814dcd1b80d385ebf63c35.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37abc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=TdliVB_93dTD34Rfq5YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfXyIR0f9sXMiHR
 4volGAleBjScG14mEgUoX/SYMxdizzzclNpUobfSCV7Ql3LhXXGj7T2MqsPnGC+PspTDAOXYo5G
 jfJ0Ewl5HLed8al79WODuTF3aqJVFSBXTRryiyhBYEYaejIKCTaivpy9bNLhXmG2ogW5dAKe8Mf
 1oEdpVl1rZ0wX7/A5F6ct3CIpj25IY01de9yV9vZIpGOpXVWbXGWTKk2Sg1yT+uJtwscll8Ege6
 /8aL/0MmcJvKwYIbcKDM/bSrdXnZClUpkdY1vPGaxo+pwgzNxzhdtTxBB3qAmdu0GIPw4Jr2mVb
 zNiVyx3VYV1JtMQpablqQWqDkI3WFnvaRNwJZVe2qYvRI5A5y/5HWynyK7LRjfvxwZZMHRYmJhD
 I3tKxtW5T7iHCkKsc6G/PItq+23so4jRni4eUig/g3s5IIxCy8Vo/C+bpaP7gOmEt/VNH1yTnK/
 k9xWAUO9tP1HQ9/DYBw==
X-Proofpoint-GUID: 6uWWAE2Cts1bRfKlzPWidc2c4_HYNEm9
X-Proofpoint-ORIG-GUID: 5uGU7oxt_xsx-GFfGTIr0VVr179USnLp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Queue-Id: E0F6420008
X-Stat-Signature: tp3fftqou5ukq7rftuj1p4f1simsmsnw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775467510-82136
X-HE-Meta: U2FsdGVkX1/b4Qa2JyXeQYEg4j09h17+TeBYrup2zI0zonFiZBdezqDanUKCtkgjFZAlIy95sO4vHS13fAPGKVJFFmAO46bvTEB1qz44RZ43yhAUvRo/5QhncVTQuAoScX1dOGKF4Hm1Eu9YKKcd8F0k8VWkWjZhk8vDGpEwTwdTsj/3C6KkzPDehcbT1FH0v6aNSnfTzxieHeWsopTlPadWCbXjvPD4UmMTEszMLRpLeALT7l6PxX6xVT9v+4jKJGQ4YWX+sRCci/F1c/oqolCXuCJECMJOhB4ULm3xJW4a4MDa1Ae9pqcO5x7+u2I0y2LsDS2Pba7F6FtKqRWOthnF17sCf/VbuJ+rFAb5z4yZcQXJWsyCFwM2xzIIYQDUkquBdUnOevdTitruO1xhh6MRipuzjfFHHGa6z3B6jZU43aJZv4BAcHPAi4xsewd5qbW6TS7rSkqSZvG9M2FdiaShhHCVl6qNMr94Lix5fagGFww1cLAoUq83TVo9bi+ZrQYG/D+0DbAETY9mHOJzTQeZj8AZdzoXBb8Qt+djWwXRdsxbZuqj3nPXh20CpK1u5XM31eEqg/bLZ4HyiCiqnsYi24kPTeksnhk7I7F4KohI27l9XfEDpGJTjBIisXX5NIXO+JdoxbQBZhX1n/n+xXr1WZaeNsj/DHqWs8TPKtgC6oSlDgVp1XutFeABpsyWq4oCTKt+WIpu/Oo8ECriKhtlJ72/HAmZ0xJRlcGC+Gc5cbp2uJQoNckGPdwD3+Rxy1WQySfZYAL7SRJt6ByQ98Q+MkTWrNZrdaL2XkMDCgrcpyke81Hdc96E5oS4g4FUy69zBAsNQaBmXo4bcoEQSTHdvPuJswYYk9MhGLc+GDX2GlrP+K8CnvM0F+hcYqR2JNWBScr1YF9/Q6hcZLnvVyycvlof0iGyjajMXbLeVWnf/Yq2/p0FEgcJsJCLUDUo1jT8Orgx8tDr3cNymqA
 vqlUMRv9
 5go7oIa6zdzk2LIv7t0N/KSZ5DEWBBIXDWyhgm2g7UvnZ6lEtaMmWMgeahOPI/sWdYtjhqK3Jl9hzfAuz2ZMWayUnND5lu2dWBSWSsf3A0nEzt7kDPo7/pgpH3TolLASHuylqomlV4pDtLME735125DLgiYFfsthLBL/j0O96EXH209wGavf8dzJJ5OFyeb8mCpkM8PxrB8aFerje/0FwkonxmwJ5qp2yaUu8o/xQlvhVhEV/acmW0PPM9FoOKua6FzboplZe10zjVM2GNTlNqQNZM91Cc+O3gmb/XugRYDfmzZXqAIg0OVgLwGGeDkqOcAvyY+YMBxKtt4DbzdPiigNuWuToin4nkzF7J8QIiiG+pZU=
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


