Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431CCC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C536B008A; Wed,  8 Jul 2026 02:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E466B008C; Wed,  8 Jul 2026 02:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF2E6B0092; Wed,  8 Jul 2026 02:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6896D6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:59:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E490F14065E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:38 +0000 (UTC)
X-FDA: 84964708836.29.AD695D0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 891A0100006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=g3rFAHyQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783493976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuWuZbFd5cy9VxUgXbfMs27Q7qYTzAcGtHe14pOZImA=;
	b=HYCoRG+nPSoQbCoiGddCgz1i0TtGywpUpXhSU6Q6fddiCwl8bGMf6KyIeWbUgP7Ia0UhXS
	Kt6Tr/WK3P/d8M22V57y35Azt/dyrp6k5xILqiGhnOIhira5LLRQ+5k31fuodImh/auG60
	8QK+/GK1/tqPWXrGlJnnqX8PsIWf0kw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=g3rFAHyQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783493976;
	b=fmFxghk5D1ZfXJJBcXssZ8ncuTlbBJgQsf5Mg//OiBdhwsmOV5oe2bXfJqYWLXjd0/0QZO
	/AqLmen0O7JwItvu4UgM+30rogDncGYjMAkYJqAbnq6RIs0M/rUr6jo1PUzafvoF8LBXZf
	0HfCz6yQccHEmg3DTefEUBKYj5YeLhw=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667MnDoe1239287;
	Wed, 8 Jul 2026 06:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CuWuZbFd5cy9VxUgX
	bfMs27Q7qYTzAcGtHe14pOZImA=; b=g3rFAHyQ0kmVzOFvBZTscjETjh2mUXRJu
	asKmpqTX2pBFzZU8nXjORbWbwvREV65o8u2PMujC76vBGyWPpTc1epubPAFchQic
	KynnaLp1xFlsbKn8yFqOaPUKLWVdmsF1T2uwyb98Q9NAghcSYyUxNZBmwOBuZLU8
	/q21E/MPnnkPA/a06B20HjHWe6syD/l7S/mMpLYDyQ7POcnfVDhWuzhzXzveg+XU
	ho3Gv3Lgc24V68XFA/NJ6yc+RuOGWaoYTL+MJWXK/BTnCC0cSl9PY7yw4N56efIQ
	5gcmlIgIQB4GUtqRYUwgWEevo6k+QkDdQrPwDmfV7nuBzmTlGJ/9Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6suqttx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6686njRo023486;
	Wed, 8 Jul 2026 06:59:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f7cvw6km1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6686xMbs52953376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 06:59:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F4CD2004B;
	Wed,  8 Jul 2026 06:59:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1A7F20043;
	Wed,  8 Jul 2026 06:59:18 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 06:59:18 +0000 (GMT)
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
Subject: [PATCH v3 2/3] selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
Date: Wed,  8 Jul 2026 12:29:06 +0530
Message-ID: <78a3b0e3fb94004c0710872c5bab6f7381b7d63c.1783446924.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1783446924.git.sayalip@linux.ibm.com>
References: <cover.1783446924.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX9B49MXdit5iA
 X7QjY3hnrSbLY3XwgFaNta8FJx3TPWWWb91bUp0GbFUfiOB0CvxJiarm3y7FVhWdD+g27YI1C2X
 phuhVMIbcAfBJCOBXmbN0e8T260D8gM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX0AyQTEIsdmoD
 GszLh6neojyxo48ZR/oCauHiYNPMRcrSjFppStDEI1Lz8KcDlIxOtYmX1jW8+kAW/PSAl/iBlGq
 VWeixNweyKpn6IeLQE78BOCk61srNFEkK7wJMJ2wwNzsISKavpzI2u+wgOZkLA/oW81q+VPqeSQ
 86FuB5EmKeeh7bNHkeuQcKSVKZltszCN9WkZM/lLMatDDaNijKpU8eMPkSApKG99iF7UqXlvNkY
 eeXIhm9nei4d5bGpM3OiqPw4dV0nWcUT8Y2jPdvjGw33/XbtSmhX1eMvk/0L4DvasxLvbJCrqNW
 V7bo/m/0bjocQ/zRsnCJYiBccBM1upSr1GDgXrais/v12qBJq9QJ1NQE4mrwF3DH0UXnjjVPz+a
 DQFetPixjJ+ZEZTzuVLI21qg7PFSPVl2Sexp+S32GUouh32qDSPiVjKNth0UQI/YhZ71Kz2SQou
 VC2Sm6nCKq8vujpsF0A==
X-Proofpoint-GUID: LKt_BxzuBH8bzleBrGrxCSLKpGzLkXXc
X-Authority-Analysis: v=2.4 cv=Oot/DS/t c=1 sm=1 tr=0 ts=6a4df550 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=SdE_JmCAbqlUaBO606EA:9
X-Proofpoint-ORIG-GUID: NRA9Fm3-EzcvBxL3cOVjSqePTr9fbEEi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080063
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 891A0100006
X-Stat-Signature: zzohe4t56g5u7d3tdz76jhjmbop9ky1x
X-Rspam-User: 
X-HE-Tag: 1783493976-525943
X-HE-Meta: U2FsdGVkX19uc9sxBfuo0Fsv2kJYsVjWK/ohFtdSse9674LlrVHi2f8s0jkdoAsijSSQRW2dskA6KEXaXC2rVkuEXs1sqJQ5n4Ip1lxtxBTf87WlYKBpDovfZhDoC5h7aSFX1qmSndtoJbMl+g0Rp1S6wDJBBNZWb+C83mxo0QDjJ0COTpFsn883QKCdxLTDynQiEYpWNdJv/jQaswFa2FJaddB5YyYnKt/+skCmpEPL3FBUQMm+lZ2bxw4F6npMSZFwOt1/BdP9V+TalrqPCMLHqDgHHtHQtSaiG89KKXAB0n2vb4v5laa+tpcUQLj6y0R3gJbA2M6WPzbDt2b7DcJ9WWFj68Wxcs/5CTmgQ7vlPriaCGAu3JtelXOMcFfRoSNzSOebZnGV8WEpzbsLs7FSsZpwqnU8Qh0/BFLgC4HqSEenSOhmQg7msh+W8kHXakkR/m7jyM51rWLK9U24H9rUtM3T2P351Oc3ociadghChNgLIaEBwco8U8Bo9PSg1KaQ6FihEcYoH/Nh7SElkFRNTG6RiC+eREuhz/gZTk8X8XFIyscGFh8L/aNtkgd3Sgfw4Ir7U9fnNyIHBzm5AUoFiNHLthaL2sa8bHgpmhSAmvS6T5KJtWABus+/fhmRbLFLuMbwie8dmDgphx7tml/KpGLCV2lX1xyFnJLS1j0cN3O1rvCTOhJp2hW2KXaPV3Hh+A9Yg9nvM8F6vuUqL7R0dum3duqvNkOkowhlzZteIzc6Pfyt02uzlrqK2A6DZWDeOxwrR5DUHhl7xxW9yqY/qWM5Kdf4Up2NFtSaX4NjX6yFcMxXFPZb/j5iM7KXrCsdBxTQ/4HlA+fbmQSaVHITaFhI2i5Wn3spNcSkwDljwrl2tJ4KtbNp3giwoN5Gi0q2tvcEGkLIAFAwgu12Sv88OZTIFCmENXSvlobwKnyxMJBpo3d3+BcVY9HzNL+S0sJe7PGrtBu1duHk4YZ
 sbsJ9iPA
 8XmR3pHSBOvYAdNCeUUifL7mdJaU/XaGvXSUbsKFOn/mJSKZeurINrn4Ct2GRkB0sOxMTCzL2DAbO3G6sxyuU02IEAjp18V0WlC3ANhApGECYm7gnGrzjL0dFcjIc3uxmmkBbtddViaMSBMXiiO53HIO00pzKifrVKC+dreh1dGHvhZwbB5f9CF5JjqUwnRYAMO0M3nVcJyZ7jJdjCCG36x6NUyrMpk0aFYte5PYu3xwCkUaNG+sGke2ZyNKdJ2wpSr77ptjiDv8VIMsHZfw71VybD3WrZ9onEWLLt5jMgZ6mPxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The KSM NUMA merge test allocates identical pages on different NUMA
nodes and verifies KSM behavior with merge_across_nodes enabled and
disabled.

On systems with memoryless NUMA nodes, for example:
 #numactl  -H
      available: 2 nodes (0,4)
      .....
      node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
      node 0 size: 14825 MB
      node 0 free: 1382 MB
      node 4 cpus:
      node 4 size: 0 MB
      node 4 free: 0 MB

the test may attempt to allocate memory on a node without memory,
causing numa_alloc_onnode() to fail and resulting in a spurious test
failure.

The test currently checks numa_num_configured_nodes() to determine
whether sufficient NUMA nodes are available. However, configured nodes
do not necessarily have memory.

Reuse the existing get_first_mem_node() and get_next_mem_node()
helpers to locate NUMA nodes that actually contain memory, and skip
the test when fewer than two such nodes are available.

Before patch:
       ---------------------------
	running ./ksm_tests -N -m 1
       ---------------------------
        mbind: Invalid argument
        ok 1 KSM NUMA merging
	Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
        [PASS]
       ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        mbind: Invalid argument
        not ok 1 KSM NUMA merging
	Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
        [FAIL]
       not ok 2 ksm_tests -N -m 0 # exit=1

After patch:
       ---------------------------
        running ./ksm_tests -N -m 1
       ---------------------------
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 2 ksm_tests -N -m 0

Fixes: e3820ab252dd ("selftest/vm: fix ksm selftest to run with different NUMA topologies")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/ksm_tests.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a050f4840cfa..2ebbb544c671 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -440,9 +440,9 @@ static int get_next_mem_node(int node)
 		mem_node = i % (max_node + 1);
 		node_size = numa_node_size(mem_node, NULL);
 		if (node_size > 0)
-			break;
+			return mem_node;
 	}
-	return mem_node;
+	return -ENODEV;
 }
 
 static int get_first_mem_node(void)
@@ -455,8 +455,8 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
 	struct timespec start_time;
+	int first_node, second_node;
 	int page_count = 2;
-	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		ksft_perror("clock_gettime");
@@ -467,17 +467,19 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
-	if (numa_num_configured_nodes() <= 1) {
-		ksft_print_msg("At least 2 NUMA nodes must be available\n");
+	first_node = get_first_mem_node();
+	second_node = get_next_mem_node(first_node);
+
+	if (second_node < 0) {
+		ksft_print_msg("At least 2 NUMA nodes with memory must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
 		return KSFT_FAIL;
 
 	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
-	first_node = get_first_mem_node();
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
-	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
+	numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
 	if (!numa1_map_ptr || !numa2_map_ptr) {
 		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
-- 
2.52.0


