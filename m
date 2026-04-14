Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B024ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C316B0096; Tue, 14 Apr 2026 04:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CB16B0098; Tue, 14 Apr 2026 04:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BB96B0099; Tue, 14 Apr 2026 04:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C09DF6B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:22:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F2A614044D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:56 +0000 (UTC)
X-FDA: 84656470752.07.5576612
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 24B4914000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iryktERr;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzW3nDJIXN8nsOHErRm2SdUBfyLuevkgaiMQu8YlHjo=;
	b=YIZXwWrtn3ZzccJiM471JgeLB1wXda4DjRa9OLEGW5QVJBj8NH9OKg3zYy47hKUoDZxJVw
	lo2P5ssoqj5iVq5jR6VpF9nj5eLSrggD3Ee85VYXXIPAp7PkKMTYWLtZwLvKVhrB/1MfNg
	kUzvcF5ZrJpyKcjG+kpny84MkPQJ9OY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154974; a=rsa-sha256;
	cv=none;
	b=l2dkGQ4L3AjhRJz/Vr77hmL6vcaWlV8Rjlaa/pk5f0WQ8Buvkl/Ndvj47V2G5ly5QIWx6o
	fwev4jEzVjF7F5OyHha9mlwNNXn7rDxhKbqmAeK3wNb+WT0f0v3VWtvFcUdSWo67fRZoEH
	B32LU2/ge0wN3XyUb+odbPuFzkz29VE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iryktERr;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIcnT1833152;
	Tue, 14 Apr 2026 08:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IzW3nDJIXN8nsOHEr
	Rm2SdUBfyLuevkgaiMQu8YlHjo=; b=iryktERrd6Y/Nwof7K90/ikSSzyxnKP/j
	Xp3LYgHE1hd9O/VanGcILvy/gT+4CO7wK0Udrws8p8Mrktrzih1BeA1hirSWQf1J
	I4kWucS9e3rTLAAol5whtW/KAfhYU2PP/VVgc/WycxctNwJbhZNGkCZofFqAng8f
	IiXI2oxvfL43vzfJ97h2A7E/Nw6XBXRNofJUw9H31vq7L3R1HRrvytdmbfDzoZQj
	Wbcvqhvr2GsRwz9c3draDYhiB7DiBUxeHIpOUpnC4qThgRx49vtN+PYggc4K9H2Y
	4Pb+gJfLvcqWynah9YJUs7p3ZIBV8XXYgGvpoH+cm8OZlfs2oY6Lg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89r9sdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E605FX025862;
	Tue, 14 Apr 2026 08:22:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgeas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8Mbsd50725236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A876020040;
	Tue, 14 Apr 2026 08:22:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A977D20043;
	Tue, 14 Apr 2026 08:22:33 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:33 +0000 (GMT)
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
Subject: [PATCH v5 04/14] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Tue, 14 Apr 2026 13:51:58 +0530
Message-ID: <b7f12130daaa2c1c721cf06ff999b6439fb22c2e.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX3kLgvhN6Lv0/
 pl1pfELMA9A69dmDsY7xaok1Nd2OnASz426UjAUKOSXYg9VGa6FhZcG1ZbKZB0XIQiOS8dadASL
 UXk9ylVGf05RWXvZ70X99nroIPeQlzd+VSmn87CrVPeoONgbnEbr1d60wh28mERhgYAacTqZVH5
 9yMxPJGpZxmDKMLwNlNI/EZsMAHontkjgeWVQCJ74AR+aLC7bJ7WeKcZpm0VMOLU0ZX8Qm4JUnG
 Mh9exSxZU+PTMY+fgq/LAs3ptCTzQjQVlTlSPivS2Vv+c10JKl/3fW/peOMIAMTavCwiJ40+l90
 neBtfDsrkSxc9D77x8KGGdSnIDcfFo/PXqxqQVyQ9kcTq3dWeQpXg0yUcvktsZo7a+/rAMOMonk
 YMsRy0/xdJeMR8iDuY2/4MAy0+XXhOFP6mkrpxRdZL8m974HriG6XWynVpbimAZ/gPn5fbGkVBZ
 sPQS+miA5B22DsfEF2w==
X-Proofpoint-ORIG-GUID: zTr6KwF_QvhABTELM7IKKRaP-NPGpUy8
X-Proofpoint-GUID: Y7TTvvaiWtyymfglIwRNPlpIJUAuhrby
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69ddf953 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7yu59zDboRqKFyXxuvEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Server: rspam12
X-Stat-Signature: uc4ykhgyec73q3aashpwhrrd4sbsyw1k
X-Rspamd-Queue-Id: 24B4914000B
X-Rspam-User: 
X-HE-Tag: 1776154973-234551
X-HE-Meta: U2FsdGVkX186wTE9WDxwH0X5Uj1nfEAZH19BkCkpG118WR5Jh1s3Zc7MsoxHkSX+negSatRI14XoylDQ2mxBzXL2UZ5p7tmgGIcgr0aZle/QmysgH7o94XSfjtcZZOugKnbZxkNzcsKEtgFEG/Vdq2g5EhpqttuWmDKybRfaXbq3+45/XXJWRm4eLs3CQJk84IZwLD0yXcmWGJWqhev4G0jKth43Wni+VQBJUzGFkWL10LXLeRUi6Umfzyy/2arSghbRe/pxjhNxJkxLXOzcTzOJjy2BijVWBnx8u+0xUUZgnSSYqqAbTe1v96fehUr84PFSrstxHV+jgYHjvWb9Pu1VFFIM7kJOKFFdcmTC49zfXvLfiSapLg18ma/O8E3yXOhppPgpqrAXHrHKQOnNIGQzd8aOjf8OvG/KRZwsysGfNeQEJ2BVBymtjRsVN1nbP/fg5mHw7XlBxPqrKO3XVCCRxNzfy5GVUVgvMDL71pHPBBESNbnWr4LnvzMxAkH+uOzK7hrGC2KFddOP90PJ9G5lzDuvmbO93806xQhZIxX52DKf6D9qTzfg7ufZhA98u2Gu+yIfYwgbJOm9p6C3Gbdjhpvz3Gqu/zZl9+d48oprMBa2gu76FoJxo3q+OuR5Zku/qGIvFGG9x3MrLDwc7583DN6qsEFBFyOSULfcvG0iyTDqOcw0fg8e+2+AowO0JNQjg2XixkmGGjVLob8DliWpSd8Q+3BC3NYgjV7uLPlS7bdBreRdowue8aKg2lJGiua0ImWRiZ42gFoxmI2NCrbwW7YvcBZKsg1b36bPPAY9r12SVx84QZ0aP4o/r/x0sRWsxv1g2cj2m4NVYUg4gmj2/BWVphHuHXSi36UWPFLq4rNZB7uuu3mHMkb/YHX5RDSwWbjACPXie79FIrYGiy8FnpmIO3Fx9eaPAoeRQbKg+/Nl4oOmhgu3QlPSNDB59oeize7y66fDHJ2uRPx
 Ze5aWoSG
 0tsbiNC5rCbEsGuSyexKI7/bO9zTf+REG1Rruxlge3eZXfgyuaa05IW4LgAP3fvWLWQquCrwR3OEvB1HczOvOAogmOccdwGH1uXxA24Dfhnd+WFrbczVK4AzQD+QHnCXLzRXGWE0u+ZrqFO8kIGUtjmLhMJilVhsW96kK25HgYHqsiBEmDdWvuLhH/+o5pgGPK/TDzOQ0TDN+J58cRdGlbAdtZlKEQLxwgtXbBcRGyiIiu0ttE7iUbuCVGyh1kpsS4G3uISiOiJ2dlH367Qz1qhryJmUpgk6WcaOPZGn7hj7Zc10qA2zoIKb1VSUFK+jsSkaxC4/mILBTEyVJuSOs/j1PL2l9666uFX4qVQbBaYfIZzVgToqbNjnkYTqFav3WxJ/4+dr+r2y4cWrf4TnY7jvQbOGeuQZlKqKQOzqc/LGd2Cn1G0DCqI8E6Mntk+dEqpg4UhlVm3CaKrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_reparenting_test.sh script constructs hugetlb cgroup
memory interface file names based on the configured huge page size. The
script formats the size only in MB units, which causes mismatches on
systems using larger huge pages where the kernel exposes normalized
units (e.g. "1GB" instead of "1024MB").

As a result, the test fails to locate the corresponding cgroup files
when 1GB huge pages are configured.

Update the script to detect the huge page size and select the
appropriate unit (MB or GB) so that the constructed paths match the
kernel's hugetlb controller naming.

Also print an explicit "Fail" message when a test failure occurs to
improve result visibility.

Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/hugetlb_reparenting_test.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 7ddb370e1572..00f3f3cd8909 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -48,6 +48,13 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+  UNIT="GB"
+  MB_DISPLAY=$((MB / 1024))
+else
+  UNIT="MB"
+  MB_DISPLAY=$MB
+fi
 
 function cleanup() {
   echo cleanup
@@ -88,6 +95,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -108,11 +116,13 @@ function assert_state() {
   fi
 
   assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
-  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
+  assert_with_retry \
+	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
   if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
     assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
-    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
+    assert_with_retry \
+	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
-- 
2.52.0


