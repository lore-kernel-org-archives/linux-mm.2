Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762DCEF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94996B009F; Mon,  6 Apr 2026 05:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C586B00A0; Mon,  6 Apr 2026 05:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83146B00A1; Mon,  6 Apr 2026 05:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A64A56B009F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E8C0140316
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:56 +0000 (UTC)
X-FDA: 84627586512.18.753CB0F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA7B412000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HCyNBrsG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467253; a=rsa-sha256;
	cv=none;
	b=jgC0l0SZtHLkabv8KdCGD3KsRXc1oSzGtnff/eS8UcyYP16k+8bFxZVcN9d2Otuzlhs05e
	8WuTQougpYUcQhL3/gucqWjjsDTBuOH9H02c6YeC7B2azy4Aq76hxnC5FBP1nCZ0qcSVFm
	1UvyGDQVULCUTVKc2XQsSHBvwuGYfJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HCyNBrsG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hR9AvsESc0VB0jLe+QQG3Q1Tfmm/xPeUm+bAL5UGGaM=;
	b=oOCWhQWA292BensAu2tEZ/9wIzHmMsXnyREExseiDddmEue/scmpU+RgeygRZBS2YzM/P7
	L2FzYmQ8BGC4virz5kizwmEDuYwNu3CVXLoyYRl+muPMd1UKUBmgcJyDscLrGpgXaoBK1W
	cnQYGirxE3pIzZz+v9XqWlF6YJ2yGJ4=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635GnGdO3110257;
	Mon, 6 Apr 2026 09:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hR9Avs
	ESc0VB0jLe+QQG3Q1Tfmm/xPeUm+bAL5UGGaM=; b=HCyNBrsGgoDyc9Z7Kd9xLT
	ffrSA3KEavgwn0qfI6gwSvKJsuAdrOmLwp9ilyKiL4WC4vAsRdXr/zZTfICU1xEN
	QzGbkrA9DW+Utvyq4FCoHc6BeBqyk+LCge8iFRaZLWO4WpJFiIylXepXJM53TSZI
	0zaiRekDsuymj+DIxSyFqOYhGviW/KGKFsiBGA3YcsDpuibyiXs+GkLNYf1V7zZm
	vTB9z3uHNQAhtc0hhigJQ6LD6/MmZnVLFxJGlXnMi5cnpeCcbSyZvD4cViuEpPJJ
	E30BV8eufjiLvCEpIkBc+yORAC9W150PQYlgZI3+lGvI7ZaqQEt682byis6Uwygw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6364i7Mf021117;
	Mon, 6 Apr 2026 09:20:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdbyc5jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369Kd6a51446198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC7E920043;
	Mon,  6 Apr 2026 09:20:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A56520040;
	Mon,  6 Apr 2026 09:20:35 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:34 +0000 (GMT)
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
Subject: [PATCH v4 15/15] selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
Date: Mon,  6 Apr 2026 14:49:34 +0530
Message-ID: <fcc9eb99566af8f37e63924a77dc633c5f200417.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37aec cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=4tZCw_sC0xjTHO7m73IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX5n0Or/YQTGbD
 zXROJzFv7cLnirHO9BgQRuNEPQr+ZEVKCUhyxfdr3hxWBvM+7OLz8myBm2C7Z7B3zUT6MBslmAf
 AeBNQUtaXcQV+vBnj17KLPuQ2WDiEz0YZTpkZ6pKjYKxV5xz4oHmBU0fTFPOADbWuCEEazlLu7B
 biHajIZRQsJuqBbpt0h3v6UnI/zY2PYOi55yanRYBPyUDR8ToKc4HPmF25rIdQC1Ik+eNbssUV0
 Gl9+XMJsQx9wjZS/h+232McNGZ1gcI7clYMqH9Rav6y69rhHLMDuea2g7BdjVbwYjRa262KMrDa
 gOajp5FgX7CMdet1sEEaSs+XMJJlGDMd83IPNNBLdfZvnZLknWjpET6qdoQNK45+IAoSOAb3w+g
 uRsXNs6xF+EBOKbL+K5qBiYXSsiyp23/kFkQw7uovc7esvIWc82ndcaYzyKTr+t3I0o5G5AL7A0
 8Kg8KQzjRVWmnmTBj2A==
X-Proofpoint-GUID: UQqDuCzvxJXuNF9VCUai46TOluqGlLmY
X-Proofpoint-ORIG-GUID: 70yvyT2i2bR0oABye0WkT-5h7pHBZuNW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Queue-Id: BA7B412000B
X-Stat-Signature: c4e3jyfwm6ks6onpk8o7j5te77oknt6n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775467253-66911
X-HE-Meta: U2FsdGVkX19DQUJV9zTwRQKCiXT3T4il5RXZXK88+jtqUv+TfJ+NCNtF15gVrRyCsvSbdistiTNogvhlfymN1Ok4/Cl3RjMN8WC4Rkk0fKVCzq1o5/wBahgE9+TKJ3fgP0l0YY439isYij5er2esLM6Z3krZrcYPr7e2Zu16m2TZkjXNjUBPYG8QYRTp6UUiRL5yoU8EpbF/M8LQFTjdUN86s3i0zW3+J3zCd9v+mo0t1KF2m3s8M1TGaLeNOg4usVKqCHVb7YqmDY8a3zUsHn41zK8TA7BTraml4EL+qpC9YSkGddEh5zm3Kq8TvNbZDI4QtNOHms+mNdhdwQl53Ldzl5sCQOSwoWJeMPsGiV05Feqi3JUW/snpyJMFqXqXb/+I5pDN3bQ3xFQPRQ2/hna0eO4XxK5tHATODIO7tuph/tTlaS+CvcCR1gqxBsBeWrJMt99alQejwR0RSIcNqWj325rI1aOI/zicA4ACj8D+wfWojor1X6IlxSYOWtJfar638EaXwGKAu2CSGdNWkYNDD36txHxuXs3PTsr/PyDV+cJcDfvCxQRH9Y0V06vUhTFPs1XRju8nNK9jfBIAT3z9c0ztwV2frmrIw8Wrd+UuZvcAE36dtzhK8oaEV4AwvZTQ34tWzEpV2F6vnxC4fCw/cxCpA/6dBvM928Xwf0Iat+AWUEk9DgHI1Qa/qVwtE97dVazQe4yOFt1nos+/DOPAL2xEUtQO4pvOQiLlU9Ps9zXW/5bBVJtnDYeGv4rkPFGZrDzyVW7dHdH+KWi+Q7EX8kCNpmKuhx99uZVGMYMynzN6jORDTGvH1p/4Nc2sv+8Y5pg1icbpsZQ1OSGM04RwMJ2cvyoaduncvHpmtPJMlZtcykJlKBxDInDzPP2+3ha1/z56ub504cxalFFrTrbXt553rGb/JCCGn78GSQRawK3mehWZ8R1XMpCirE1J4h5AzZ9pBjQ4Rgzhr9C
 +HlJTmrA
 IfdkUi+krrsTa/aCnPMYzvWNnHETXUF4NK/kK3qgYF5+tEjxoyh4vAaYSXcC3eZx9i/CU6Uhmdbu2TxnuT0waYP+/1qQbyU9YwCZZ4FwK89kWDnlWN3XeS52W+MISEHg2BsjnL2WKw0XCwLSaOb4rvtYldyDFZ/d/j55Z4ft62KwAGWMTCUM3RnNenAV582mzSu7owHabeLPa/RjyGVds5RmQ9tNfBfBGBj5T68z5yzsPss0+aiwLxDcK7nNkPDMz5u+9l0xCkUDSLwX8sXbRTRqTIN0or4ttafgd7d+/DCiL4ucaj7XIFgb4Q/ONe7U/FF4SO5lINs18dGefr6t8juWdtuvSuvBE1I+/AIrnXka6N/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb memcg selftest was previously skipped when the configured
huge page size was not 2MB, preventing the test from running on systems
using other default huge page sizes.

Detect the system's configured huge page size at runtime and use it for
the allocation instead of assuming a fixed 2MB size. This allows the
test to run on configurations using non-2MB huge pages and avoids
unnecessary skips.

Fixes: c0dddb7aa5f8 ("selftests: add a selftest to verify hugetlb usage in memcg")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/cgroup/test_hugetlb_memcg.c     | 90 ++++++++++++++-----
 1 file changed, 68 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index f451aa449be6..e6157a784138 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -7,15 +7,21 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <stdint.h>
 #include "kselftest.h"
 #include "cgroup_util.h"
 
 #define ADDR ((void *)(0x0UL))
 #define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
-/* mapping 8 MBs == 4 hugepages */
-#define LENGTH (8UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
+/*
+ * This value matches the kernel's MEMCG_CHARGE_BATCH definition:
+ * see include/linux/memcontrol.h. If the kernel value changes, this
+ * test constant must be updated accordingly to stay consistent.
+ */
+#define MEMCG_CHARGE_BATCH 64U
+
 /* borrowed from mm/hmm-tests.c */
 static long get_hugepage_size(void)
 {
@@ -84,11 +90,11 @@ static unsigned int check_first(char *addr)
 	return *(unsigned int *)addr;
 }
 
-static void write_data(char *addr)
+static void write_data(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		*(addr + i) = (char)i;
 }
 
@@ -96,26 +102,33 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 {
 	char *test_group = (char *)arg;
 	void *addr;
+	long hpage_size, batch_bytes;
 	long old_current, expected_current, current;
 	int ret = EXIT_FAILURE;
+	size_t length;
+	int pagesize, nr_pages;
+
+	pagesize = getpagesize();
+	hpage_size = get_hugepage_size() * 1024;
+	length = 4 * hpage_size;
+	batch_bytes = MEMCG_CHARGE_BATCH * pagesize;
 
 	old_current = cg_read_long(test_group, "memory.current");
 	set_nr_hugepages(20);
 	current = cg_read_long(test_group, "memory.current");
-	if (current - old_current >= MB(2)) {
+	if (current - old_current >= hpage_size) {
 		ksft_print_msg(
 			"setting nr_hugepages should not increase hugepage usage.\n");
 		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
 		return EXIT_FAILURE;
 	}
 
-	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
-	if (addr == MAP_FAILED) {
-		ksft_print_msg("fail to mmap.\n");
-		return EXIT_FAILURE;
-	}
+	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_skip("mmap failed, not enough memory.\n");
+
 	current = cg_read_long(test_group, "memory.current");
-	if (current - old_current >= MB(2)) {
+	if (current - old_current >= hpage_size) {
 		ksft_print_msg("mmap should not increase hugepage usage.\n");
 		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
 		goto out_failed_munmap;
@@ -124,10 +137,34 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 
 	/* read the first page */
 	check_first(addr);
-	expected_current = old_current + MB(2);
+	nr_pages = hpage_size / pagesize;
+	expected_current = old_current + hpage_size;
 	current = cg_read_long(test_group, "memory.current");
-	if (!values_close(expected_current, current, 5)) {
-		ksft_print_msg("memory usage should increase by around 2MB.\n");
+	if (nr_pages < MEMCG_CHARGE_BATCH &&
+	    (current == old_current ||
+	    values_close(old_current + batch_bytes, current, 5))) {
+		/*
+		 * Memory cgroup charging uses per-CPU stocks and batched updates to the
+		 *  memcg usage counters. For hugetlb allocations, the number of pages
+		 *  that memcg charges is expressed in base pages (nr_pages), not
+		 *  in hugepage units. When the charge for an allocation is smaller than
+		 *  the internal batching threshold  (nr_pages <  MEMCG_CHARGE_BATCH),
+		 *  it may be fully satisfied from the CPU’s local stock. In such
+		 *  cases memory.current does not necessarily increase.
+		 *
+		 *  If the local stock is insufficient, it may be refilled in batches
+		 *  of MEMCG_CHARGE_BATCH base pages, causing memory.current to increase
+		 *  by more than the allocation size.
+		 *
+		 * Therefore, Treat both a zero delta and a batched increase as a
+		 * valid behaviour here.
+		 */
+		if (current == old_current)
+			ksft_print_msg("allocation consumed from local stock.\n");
+		else
+			ksft_print_msg("memcg charge batched via stock refill.\n");
+	} else if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should increase by ~1 huge page.\n");
 		ksft_print_msg(
 			"expected memory: %ld, actual memory: %ld\n",
 			expected_current, current);
@@ -135,11 +172,11 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 	}
 
 	/* write to the whole range */
-	write_data(addr);
+	write_data(addr, length);
 	current = cg_read_long(test_group, "memory.current");
-	expected_current = old_current + MB(8);
+	expected_current = old_current + length;
 	if (!values_close(expected_current, current, 5)) {
-		ksft_print_msg("memory usage should increase by around 8MB.\n");
+		ksft_print_msg("memory usage should increase by around 4 huge pages.\n");
 		ksft_print_msg(
 			"expected memory: %ld, actual memory: %ld\n",
 			expected_current, current);
@@ -147,7 +184,7 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 	}
 
 	/* unmap the whole range */
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 	current = cg_read_long(test_group, "memory.current");
 	expected_current = old_current;
 	if (!values_close(expected_current, current, 5)) {
@@ -162,14 +199,17 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 	return ret;
 
 out_failed_munmap:
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 	return ret;
 }
 
 static int test_hugetlb_memcg(char *root)
 {
 	int ret = KSFT_FAIL;
+	int num_pages = 20;
+	long hpage_size = get_hugepage_size();
 	char *test_group;
+	uint64_t limit;
 
 	test_group = cg_name(root, "hugetlb_memcg_test");
 	if (!test_group || cg_create(test_group)) {
@@ -177,7 +217,9 @@ static int test_hugetlb_memcg(char *root)
 		goto out;
 	}
 
-	if (cg_write(test_group, "memory.max", "100M")) {
+	limit = (uint64_t)num_pages * hpage_size * 1024ULL;
+
+	if (cg_write_numeric(test_group, "memory.max", limit)) {
 		ksft_print_msg("fail to set cgroup memory limit.\n");
 		goto out;
 	}
@@ -200,6 +242,7 @@ int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
 	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+	long val;
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -208,12 +251,15 @@ int main(int argc, char **argv)
 		ksft_exit_skip("memory hugetlb accounting is disabled\n");
 
 	/* Unit is kB! */
-	if (get_hugepage_size() != 2048) {
-		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
+	val = get_hugepage_size();
+	if (val < 0) {
+		ksft_print_msg("Failed to read hugepage size\n");
 		ksft_test_result_skip("test_hugetlb_memcg\n");
 		return ret;
 	}
 
+	ksft_print_msg("Hugepage size: %ld kB\n", val);
+
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-- 
2.52.0


