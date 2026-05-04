Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB9CFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906CC6B0093; Mon,  4 May 2026 05:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7DC6B0095; Mon,  4 May 2026 05:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD806B0098; Mon,  4 May 2026 05:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60DE46B0093
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:11:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28EF7140347
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:25 +0000 (UTC)
X-FDA: 84729168930.02.E4DDB80
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id E663A160003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rzpG1e2C;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777885883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVBCdFlyMQ1V6MUtuwPKBgnAngZgz58IaT05OqVtHI4=;
	b=EPCvktzuN90CYEhY/k5zzhFb8iQZ4aBS+kkebEkpFZw2A008UUU3EsUH91E8QLd6Rwef/N
	hlNhT9X+rV2y93TNwNToAqiC9e6vFV+xLM0FU7L3Fg+X2QLyTamzhLhqy17LK9VyRqppMi
	0m/QB336cBgUnczPrfVPgNV1b8gn0Kk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rzpG1e2C;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777885883; a=rsa-sha256;
	cv=none;
	b=MU7qbkrFnFRaE1STCTNt7Q6MCmdVOx2mqPmUe2dHRdsbjbp2GlyGJflJrI9CbG7SYS/u4I
	IVW0yh7pzHiYAOoEO+se1j2HbdQNHMkf/WahR5mzGbThCqqPXb9WHBvizYpyWhpyWzTUdr
	6Jy31VCCsLF5UuPzSkrKr2hXLD9O/Tw=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643Kl0V93279333;
	Mon, 4 May 2026 09:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uVBCdFlyMQ1V6MUtu
	wPKBgnAngZgz58IaT05OqVtHI4=; b=rzpG1e2CGiWiPal63UGg0n8vqK4Rrvbez
	p1VZZjElDPxpLRmCMZ4ljOdxq17CadnirTR9PrUNrQAbAhy6HATmYmAJBdJoMM8h
	sgrYtqsiUhA17b9MUMMY3sBcWBB8SVO1oegzOfICfIr7gFxm+C/Xku16streG6Kv
	zzuC+ITlqm+iqUU07tBtyHudRM3S0fiAF2SGeOC1czpyAolaXiEnmzdZFHCNchCw
	K5KoCZaW0dEm5IKEJ+h26gb0fX2NTtkBWuszFtDFypCm55y/sQ0e/ySsK0gILmgU
	+lIiQSgOCFRTqutmHJFJI7xfsBsJFxZq+4Ddhmoxr0w1wAzPGCkDw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxe20k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64499Zbc004421;
	Mon, 4 May 2026 09:11:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvvjq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6449BFO356689010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 09:11:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5640520040;
	Mon,  4 May 2026 09:11:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94D282004B;
	Mon,  4 May 2026 09:11:13 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 09:11:13 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH 2/3] selftests/mm: remove hardcoded THP sizing assumptions in hmm tests
Date: Mon,  4 May 2026 14:41:07 +0530
Message-ID: <e90a1bb96096bfc6a7062dcafcb8c1e1dee05de0.1777870179.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777870179.git.aboorvad@linux.ibm.com>
References: <cover.1777870179.git.aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA5NyBTYWx0ZWRfX4Ce7Mg2HBbJT
 j8Qe/FwUv4MOtlWOCR0HA7k8E5wj+eOWk7o7cQI3bhgrFIb31MXB8+wutCnDTsir/vlVNcnYrsy
 T2pSqSgVb/VGmoR3q5UDmC74bTAttQc48XnYww+9fuzsPQzsx7gj2dQioRb5+bR71qUu+0nmpDw
 0yZ/2aLQQeUM71caCKU1/DN7cJ/c0ZZBQhnYYxBwHuDoeM5gruKe/F99/VBgTBYkXZepFkRIU7M
 1/b98dwWT6BSuFPs3FztFzN1J1BrSduSJjA+K8lb9cRSRh5p2JecYtMxv1BcEoupb8/91+WvWsO
 rk4XaXe0NgvQfQAXN3FHFMlP6+ZqhaTq7axbXcJojSp+r7DT8s83/C9Si0tlum/fefAJu1MxaHj
 gwsjv0JDFBI4klfkFFdlYL+CRMcNr9scBPgzEsnCum8X9/l55LH+D2xCAz8pwVDay9dGezUgpsY
 Pxt68d8880F3uolZAAw==
X-Proofpoint-ORIG-GUID: tbQtdIaClcfvD8ppY-xugGVIW4tjpR7a
X-Proofpoint-GUID: tbQtdIaClcfvD8ppY-xugGVIW4tjpR7a
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f862b7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=77g_uzDykyn2lBTOjWkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040097
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E663A160003
X-Stat-Signature: ikrm4gthnif3u4jer4ht99eq448mjn8r
X-HE-Tag: 1777885882-542933
X-HE-Meta: U2FsdGVkX197APNu3h2ZcxBaoJWWjtc9EETRuXJDMvdzwX1Mw8q/b4zlTXBXVQcTCXE4q6S6t8e+9o7qe0TWszMYEveiDCpXOHAzzzHyrtUjgCFDtqGeacak7vgQLKIV7+bsVh/tk6F+/Gx53lScClsy+MO6uGxmWbOEbO7SY09IRL/BoWlO8b55228kK6OCLYwqw/5QPdBs7Alk7eQa+7bNo27M8vGIY4UCk4CfRYwmNn//lQ6Lve9SVHBosXhlmswE3IOzzPSROVBajq0Cdl57tUcHnKbgMoME2mnbHsKOQYhXLZ02u/vngiHUnkNbB3ohiCznV85yrZmYP6XXSL/5sYwtbbBwUW3d8bGBifhItYR5yqMjgq6IVLlicgq47ZG4Z3ah2qO5xfZDkp8ivV7EEEOFE/6zf47KPPQqeRObXOYKKRd+IR/0Zj1Tpq6u820Q715sCegMticpBOS12gA+0IBHT4ePhhGM9XwT4ojGoYRg+XrfM8an1FEVPylQT2E4sVk4t39Qd3v+kVD53VWuXDXQ5XunsgT8v0u/ed35PIEvukJDA+LtoIbzvdGyG5C+IgxNi0nfto7GwUsXcj5VUFVmbDZI1kXvN5i0XmDW0rqrRcfSpZWKfayt3f5kALRRWrsegjtAZMhG7GO4y5k0Ri7FLLs+HLZGjrodh8JfG1x+I8FM6Hnv0fu1f4ybvXU7oKQ2YC4QrLLvkdbK+OjWW62KtfboOGH0KPlTXLb/+uPFjyJr00fHy0Np8wMz9Nm/jbqvnCCjxtkA8ASBO68pxbfkNWi5zz0M63/EDOu4drXfleCTr4LtBCb0OMDcm3tctLawKYhYb7u5nY8p1zrAcq+yhF6BBgWG60KdBVb5zllqjNZTU8XP9h65TDEmPPaMQ11tCFITYi/Am5LBUiHnJ7tUXw4liNDJ936pd/ucqubtLhR8f0zWfD7il1ikOsCyJtEoxLfC/kq8kXe
 ye6wa3GA
 QOsgsTEqY+dgyMfenEkoQhQZqhyGkIFasfid49Q6AYoH0+lDhLXEZ0cMgfFGHvFpghds9Bp1yuX7qzEfdH1ZoU1LpIBlFr+nA2OTzr2NoSd7VXbP0zF+I4huBwX2qXpC2oKb244wdyC3NyX5BDAwNNHMQKshLaRzcYHFq6dfSPa0CWdZmzvPeK4hScKh6TgdR3RnAFS8AUG7hEqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sayali Patil <sayalip@linux.ibm.com>

migrate_partial_unmap_fault() and migrate_remap_fault() currently use
hardcoded offsets based on a 2MB PMD size. Likewise,
benchmark_thp_migration() assumes a fixed 2MB THP size when generating
test buffer sizes.

Derive offsets and test sizes from the runtime PMD page size returned
by read_pmd_pagesize(). This allows the tests to adapt correctly on
systems where PMD-sized THP differs from 2MB.

Also replace the fixed 1MB unmap size with a PMD-relative value derived
from the runtime PMD size.

Additionally, cap the maximum number of THPs used in benchmark tests to
avoid integer overflow when computing large buffer sizes. On systems
with larger PMD sizes, multiplying a fixed THP count can exceed
INT_MAX. Compute the maximum number of THPs at runtime as
(INT_MAX / thp_size) and use the smaller of that value and 128 when
constructing the largest benchmark buffer.

Fixes: 24c2c5b8ffbd ("selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests")
Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 44 +++++++++++++++-----------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 6dc839866dfe..1e5c1432ef6b 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -21,6 +21,7 @@
 #include <strings.h>
 #include <time.h>
 #include <pthread.h>
+#include <limits.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -2332,12 +2333,13 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size = read_pmd_pagesize();
+	unsigned long unmap_size = size / 2;
+	unsigned long offsets[] = { 0, size / 4, size / 2 };
 	unsigned long i;
 	void *old_ptr;
 	void *map;
 	int *ptr;
 	int ret, j, use_thp;
-	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
 
 	for (use_thp = 0; use_thp < 2; ++use_thp) {
 		for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
@@ -2379,12 +2381,12 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 				ASSERT_EQ(ptr[i], i);
 
-			munmap(buffer->ptr + offsets[j], ONEMEG);
+			munmap(buffer->ptr + offsets[j], unmap_size);
 
 			/* Fault pages back to system memory and check them. */
 			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 				if (i * sizeof(int) < offsets[j] ||
-				    i * sizeof(int) >= offsets[j] + ONEMEG)
+				    i * sizeof(int) >= offsets[j] + unmap_size)
 					ASSERT_EQ(ptr[i], i);
 
 			buffer->ptr = old_ptr;
@@ -2398,12 +2400,12 @@ TEST_F(hmm, migrate_remap_fault)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size = read_pmd_pagesize();
+	unsigned long offsets[] = { 0, size / 4, size / 2 };
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
 	void *map;
 	int *ptr;
 	int ret, j, use_thp, dont_unmap, before;
-	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
 
 	for (before = 0; before < 2; ++before) {
 		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
@@ -2806,8 +2808,12 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 {
 	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = 2 * 1024 * 1024; /* 2MB - typical THP size */
+	size_t thp_size = read_pmd_pagesize();
 	int iterations = 5;
+	size_t max_thps, num_thps;
+
+	max_thps = INT_MAX / thp_size;
+	num_thps = (max_thps > 128) ? 128 : max_thps;
 
 	printf("\nHMM THP Migration Benchmark\n");
 	printf("---------------------------\n");
@@ -2815,23 +2821,23 @@ TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
 
 	/* Test different buffer sizes */
 	size_t test_sizes[] = {
-		thp_size / 4,      /* 512KB - smaller than THP */
-		thp_size / 2,      /* 1MB - half THP */
-		thp_size,          /* 2MB - single THP */
-		thp_size * 2,      /* 4MB - two THPs */
-		thp_size * 4,      /* 8MB - four THPs */
-		thp_size * 8,       /* 16MB - eight THPs */
-		thp_size * 128,       /* 256MB - one twenty eight THPs */
+		thp_size / 4,      /* quarter THP */
+		thp_size / 2,      /* half THP */
+		thp_size,          /* single THP */
+		thp_size * 2,      /* two THPs */
+		thp_size * 4,      /* four THPs */
+		thp_size * 8,       /* eight THPs */
+		thp_size * num_thps, /* max THPs without overflow */
 	};
 
 	static const char *const test_names[] = {
-		"Small Buffer (512KB)",
-		"Half THP Size (1MB)",
-		"Single THP Size (2MB)",
-		"Two THP Size (4MB)",
-		"Four THP Size (8MB)",
-		"Eight THP Size (16MB)",
-		"One twenty eight THP Size (256MB)"
+		"Small Buffer",
+		"Half THP Size",
+		"Single THP Size",
+		"Two THP Size",
+		"Four THP Size",
+		"Eight THP Size",
+		"Large Buffer"
 	};
 
 	int num_tests = ARRAY_SIZE(test_sizes);
-- 
2.54.0


