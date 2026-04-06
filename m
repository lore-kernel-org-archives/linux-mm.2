Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAC5EF4ECA
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC856B00AA; Mon,  6 Apr 2026 05:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A44B6B00AB; Mon,  6 Apr 2026 05:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAA36B00AC; Mon,  6 Apr 2026 05:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABDB6B00AA
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:21:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB41B16039F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:21:13 +0000 (UTC)
X-FDA: 84627587226.14.E8050CF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id D9A9E4000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:21:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DJrgnWAx;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzW3nDJIXN8nsOHErRm2SdUBfyLuevkgaiMQu8YlHjo=;
	b=NJbNhrcbOYr/FAS3oQmuiBiOsCEsXxc8iY72UR+yqJFs/EFwcS29dxiA332mYbgmLA5afq
	7psG/CsAKEqWvuAQX2j4zGIFlrhJ2L7Ykz+tu46w9Jdo1kjScpcvNjFGeyJlNn1/B5LyKq
	M3jeREI/PERRCI+rh4cfPlvzsDt28bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467272; a=rsa-sha256;
	cv=none;
	b=NMoNEI2tb4bO038PKFIdhAnW3mU0bIa6Fnk/cdHnGZFD9uXdB7TQhnrnpMxVWA+Kkb1Gph
	2Qg7txu7Qsk4NPiqVtqo91Vif1gZCF0Ewz0lRVHqzxcbizft53likY2zVtco+n0SLBjqY8
	RNWJdN6z9us/fND7W0Bd/23TW+isTJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DJrgnWAx;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635NHOWM3843862;
	Mon, 6 Apr 2026 09:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IzW3nDJIXN8nsOHEr
	Rm2SdUBfyLuevkgaiMQu8YlHjo=; b=DJrgnWAxI0s+EN9MXFk/IFww26nA1vFN4
	5n48QJ3MBLa/22Pzd/frmFvmQrG24BKIlIyuTxBI7fv5xL8ncwVqbpNwfZXHe/Mx
	sAP6DLueZdG4zor8HYb+lpCQ5Zu8/SRMRCvHj1SrYkZsuJInpz9Oaas41qFR78BI
	6ws6pvtZ9kYCGW75F3oldzDG09HnV+pRo9QzO0+t3qdlsJX6ZKK1FS+Ewid4bTgu
	1lliWf4mXCBN+b5sbW7n0J5EU/y37ihy9LkCYw7CW5RQ+LPSbJmgk7gL2JUHs+uX
	MqXIbuuSy5Qg2S7OgmnpyiRJWTgGJEkSoJZ7It5kcHypMwwjJVzpA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dar2gdnxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365xCrs020514;
	Mon, 6 Apr 2026 09:20:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdync2vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369Jvev52494842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:19:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFE4A20043;
	Mon,  6 Apr 2026 09:19:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CDFA20040;
	Mon,  6 Apr 2026 09:19:54 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:19:54 +0000 (GMT)
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
Subject: [PATCH v4 04/15] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Mon,  6 Apr 2026 14:49:23 +0530
Message-ID: <b7f12130daaa2c1c721cf06ff999b6439fb22c2e.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: laJStrGfrx-5hJqn0NaLVa4oNMtk1AUV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX/FdR5335PD2E
 vWUZJkT4KGTtLa+POhqWXvuXW0SIszX2yllb2+hrG1V53QXPbpVQVUdU3QbjghEZEhfgxZ+szN4
 mqKns4U3miZD5SB/ku3RR4iLgWmbNuKsACyKT87baMpiUpW+TdZI56Llot+bZI4yTxAOUZ5m02B
 74/hZvf2SZwyzezpZiREsOO9ZoeXnqBPt1VPD0VIxDFrVLNC/IEFDOp3HEN0m+hozD12XkxNiFb
 mvD/tuUUeNo/onwp+7U9gvulLzPiUEO0TkTLH5CqXwZXm2E+RcenMP2jZz1MvRPZ49xvEV08s2s
 oZfq5vmkkE6CLgBWJI5wtZlhGwFsdveZ5Ic3tlhwR+YQPCZ9a4MUQfkVt8bEyNamG6INqKwNfo8
 P8+o9p42mBMHFhGAnVoFED+3f1gEGM6ROr/ixcHczJm9vS1GOcareXKXP2xpbMVkDjubGCboekU
 gkl4sL1DnCYOQ1E6w6g==
X-Authority-Analysis: v=2.4 cv=b+u/I9Gx c=1 sm=1 tr=0 ts=69d37ac3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7yu59zDboRqKFyXxuvEA:9
X-Proofpoint-ORIG-GUID: JDz4J-ei1bkd7_U0fa4EqpJcExAwF915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Queue-Id: D9A9E4000E
X-Stat-Signature: o3warthtfkx7gzh3o56i4cxmk75kfwft
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775467271-429710
X-HE-Meta: U2FsdGVkX1+7j6E75KpX0+wqGCNuiYsj/0NFZCmy3DqS4OGZnrObqaC1hNo3pKsaFBObjkiorRDgFPoGlbqS9QkwtBqv9CVIjqqBakf4lDMU0ndEidhRWFqUEMhEcbSxdnWO9v+aLLlY4OeikswSfioq8ZH67IyVCdjmJ7cZc54hpQ2mrpOmuxz0PSZjIpEvg6f7jaqsmNwd75Vlc5VkWp6M/Q2UHBPzElVjh97ZKrIFo8HaHLSJWl7iIQj2YyYbzdxTrmmSV/LX18xmTo8HClgS3BECihhtrD71KtGgTTAZhWvhK6edq9EXCQk7d0ovG8z3c4HaMUaN1ZULAbhMLPtCUca+46W0adcD1pqvOQch819Gl+cfgT/dYuChWe4n1J7mDCUrn7he4b0Dv6n9r5QSautDKvWjXK0N/bslNWNEdysTQxOpypkb1rqmmPS1rU5hk7E4te5EeApN+hGsW0LSIPwLHpuBDSWUvkS8WDTDHKAJmFJYCpgNkb633FZcTzkdVSTJ4M7ydexIN/7Dy0jaswwVCXyTajdIfxvLoYnZRp+qKotIPVGtNI6m+CegqDOAv23JyBJNywFXv8OKUxIGAxWBm9xidyx7QQU7UXTl+9g1wy2gOU0wfj5x8FgTLQaDumfk1rxJWi5kBv5mFxhoxjFCcf2GKLrH6pY0Rm6tf+UjsiHmO/E1Yg6N0zbn2pPXVswCSJxamotBK2RXk3rkMNxgKux+vE4jhAjK7tc2R/rzSY9JkCQa1ll9S5+Z0/+wgIMetJ2N5dKe4JrxIPpTO0WCUXUsy2orf8HNBKVUb++CS5v9L1YiYVVphvnBmtfVYUC5E5h2gae4OioHuNwbXNCvTRsgrHmHKVxbQP4rmx/ME39MxHSK1SKjer3Q4bNjZ6XNZ+rGPKk5kHiNi+tck2gYKAphu2BKtpqzkCxgW3YdGlJFeLuEhID1Yf/Zi7esk1KsYpZK1dr69Q4
 LiR7ePJ/
 GEaj6J0lhn1gVwYs=
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


