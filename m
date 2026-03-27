Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EC410BA436
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52016B00DE; Fri, 27 Mar 2026 03:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01E66B00DF; Fri, 27 Mar 2026 03:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACADE6B00E0; Fri, 27 Mar 2026 03:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93B4E6B00DE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:18:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D0155D08E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:20 +0000 (UTC)
X-FDA: 84590989560.24.02D05EE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id EBD1F4000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f+hd0QrZ;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW/GuYujOO0/v8oUPeC7pky7jQo4u6+VMRwG135GnDo=;
	b=Jwy+S7R2AxuzLmyI6O7TQCmhsP2yMfU1+K8z4/11VLK6UisTOxYHQdXB74EzpBUc1vgeO6
	jGcFvRYSS+jp2P75AKr8DSU93t2vYop45KxdjDMjR2vbQE+JlXpqiMDnc2iMw6vh8mi99m
	vRPPe2mKFVAQtxsuwFnodX2v+WEEUhg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f+hd0QrZ;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595898; a=rsa-sha256;
	cv=none;
	b=O060gBp4nscsolgqhGYPaerCRI98B1yYrTOKOCwlQn+5BJO2TepHlrEuodzmpkKd8JZlTH
	iK4MK8nve2T+GeJXL80eAQiZ/fqAJo81NJ9dksX2qDsxywFA61ZrisO+uphKF8NC+C8dZx
	YHFr2EHqXOnTejvyLw0NS7BGhXGZmR8=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R2n0Hd3658690;
	Fri, 27 Mar 2026 07:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tW/GuY
	ujOO0/v8oUPeC7pky7jQo4u6+VMRwG135GnDo=; b=f+hd0QrZeVIivoYu1gdOAn
	ntWfUSB/PZAF92qbDTOw8RdjO/m9Hm5wU68ZAwgsYxSXAjIAaE84FxTd+9K0w0tN
	V1cmte8a/bgdDMnxMOiD3L1pBIXZev4127BmXMCKwLcauQ2Q2z52dsWHjz/KYQE8
	2ASzX0CLMRcyC1z7ZRhGaLZ+P4JfJevBlJ6/Xzu5WUFS9eXv8oaST2TIcDrQuVk6
	FffgznXmCaHXd6JVtFwxQzJtoHu/VJAlHPUJT3BIuGevse5c7JFwQvXcmaIdBOnp
	OJOyTtysekC445fZBSD/lbqSM/9pLmUTGXJpNnS7TAuHUhL33VqRDlzta9sjRJLA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty8xcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6lvRM004375;
	Fri, 27 Mar 2026 07:18:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d28c2e8rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7I5BJ42729776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:18:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C58E820043;
	Fri, 27 Mar 2026 07:18:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DFF22004B;
	Fri, 27 Mar 2026 07:18:02 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:18:02 +0000 (GMT)
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
Subject: [PATCH v3 13/13] selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
Date: Fri, 27 Mar 2026 12:46:07 +0530
Message-ID: <41fc5be38d4205b5a4aee8499631cf60a9026163.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c62f33 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=sc5eBBQPW9lzBnlyZiYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX7R3ord31TZ8m
 3AWPD1DeP37V769ZTm5A+vKyEW7h7mKzvq8P3zZ2q6pIDdy0CbejiuqEItg8+1b8dPUj2vvhFDN
 j9bqOsAKfMNOeEoEIMJ56UnYMFyIoai+9HjMTa+2HyfV90GAK39TmBi2EpSRZ8jIa8RPqMRfkhA
 cu30lJlJmSM/jytJcW/A+jknpYX0WRymDBdQobNY42f3kW/T1NuYtKRvgQrpfvNrDiS5EdRt4V7
 Z1Nye6mHR2SjfWFR2wBaFh8tsZlYRWtkxXeiU56gTnvNEUTEAEQF6W3+RJv9iyXf/RWy3suAy3O
 JYopgvAKUcZRRDXATZyPjQJCccZdYTVeuczszcZoh2D8sPmEqouc84pZVHivJa4Ki4Usnx9Qlh7
 Tmdmsg9bt0H4DcqiucdVzSUaGAK/ZaTjCUKi4qrE1Yio3495q7k2NIjelbgIViQuhkJYuqqfQzR
 vVpGZzs5CFGTOFp0Msw==
X-Proofpoint-GUID: VJ_xrzwcuXC-vroi3TFYp2X8yZdEDM4A
X-Proofpoint-ORIG-GUID: b946YoOhPzDH-DYXEfvGjeWxDd728GXO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspam-User: 
X-Stat-Signature: o5bmktrjs11aggd8eyk7wu3f1n5wpn9w
X-Rspamd-Queue-Id: EBD1F4000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774595897-481598
X-HE-Meta: U2FsdGVkX19CmlMAbBq0XSRYg77MUCuu1OOSiSDQPQ3TbNZOyMkmboNwkpOO2TxuH6AQZ0OwXphHSExUuY6JPi6mssfi/VNKpo46QWoKpAzO+YUTJ044A158zJ7nN4H4TQ0sO4sJaY40n4Wj2M6OUgBlpCmtntSaHvOWW5EoParGIXSZfahkWPHP3shKRf1s04Jje90FaBCwK/Xwlm+hoYYArWSiE1RQVDDcPMtCYBssfrLinDCw+/YjGhbQXvoh5vWpLTj9DNybIE4zvgW9lfinpeZzHRiNePTKtCYrMOyceKMYuNI73hncMKzHeHcOT+HA2kadYUdn1Tg04TrnLDKLjQ1BdZku3JMuW6fjqcpNBkInMm+HPAPO3vxKS/IB9/PjLByptEcYAQNliurf4b4quco9/TRL1r4x0LBqojqrPq8RWBKDlmD6OFpfzZrsAZVN22MK+0tL2vg6HUosz3G829fk8JxbgBKVUyLQXYT0ucmpG5PpQVF3AK88/34LyT3pTRpgt566K/RLYPrsuqwt6rHcmPOJiOOdNfMrH36eVbGseR3MxZHsCTalDNDR/xkh28TBpH+sILW2LJ1dWbivXaRTY0Y7QKzigXRPuDaihahEItZPml7V4CrwikMvcYH+8DkwdonUwqnoNP21IksfU7eG7k/Np1TwXugCkS7DK6Ssj2BviIsLyH58IBuQXpAVAw89zXawY/vzyEv6GNOGwwt0TMFw4sxm4fvjj4UP2wzR8KwEWrZ0trQsuGx3k9vx60Qz9XIIrQlFy1CyWDLYloJy1dm3OJj8dwrFxnnca0uIOSbWf590iaaGAY+JjdwNyjPdrvn2KKVH1WyzspX8fc7FVRS/VBYfxsdjVA7hfHgKz8E0zjNi3Op3UFyQ15IorEleDW9gLYV04LRsfcyTGVT288fOoeXIfEyhCYQ8ow3lVnFv31iIHc184dYifspla7HLGPKVLHBg+pB
 qtJuAHK9
 ZkfcG1lnHEY9LzihAnwAcnPv0KBayw6t5zMDQ+v2dzMNz3Khv0pkgwIObkE1VZk76u9rstWhTGSVYBk4VTGQr20Lv9LHAR1EbfFBouyX97BDs8pE8ofG+A3x5EzHaBs70cVJxshK93kw+XgCgTSWGMBwEhbci3iHlm36akN13hH+Y40kRQTq0BQPlYhJTuXzwNwXX34NQuT2f9gTpRs4XNxZ+cTpkdDMh9Ulm3iNNaWH8EqkeCP4KC/dNjeJc1U3sbouf3d60Zrsu06pMikLqRKenHDzts4v5sMZjChqCTzkI4oq93xH1lSoHjVF76h03UoBzX8W8pHlKbXnsxlVgm4Vafpys4PSelp4MRE5wiM6uWVZ6E2NNn4QgfrCzBqQWCqWBI6ql1H2R5reqleZBXwfDzruXKABXmcubAOTn8mLEumkcRHFE6zkgc6NWfSlYvlWv
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/cgroup/test_hugetlb_memcg.c     | 66 ++++++++++++++-----
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index f451aa449be6..a449dbec16a8 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -12,10 +12,15 @@
 
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
@@ -84,11 +89,11 @@ static unsigned int check_first(char *addr)
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
 
@@ -96,26 +101,31 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 {
 	char *test_group = (char *)arg;
 	void *addr;
+	long hpage_size = get_hugepage_size() * 1024;
 	long old_current, expected_current, current;
 	int ret = EXIT_FAILURE;
+	size_t length = 4 * hpage_size;
+	int pagesize, nr_pages;
+
+	pagesize = getpagesize();
 
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
+	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
 	if (addr == MAP_FAILED) {
 		ksft_print_msg("fail to mmap.\n");
 		return EXIT_FAILURE;
 	}
 	current = cg_read_long(test_group, "memory.current");
-	if (current - old_current >= MB(2)) {
+	if (current - old_current >= hpage_size) {
 		ksft_print_msg("mmap should not increase hugepage usage.\n");
 		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
 		goto out_failed_munmap;
@@ -124,10 +134,24 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 
 	/* read the first page */
 	check_first(addr);
-	expected_current = old_current + MB(2);
+	nr_pages = hpage_size / pagesize;
+	expected_current = old_current + hpage_size;
 	current = cg_read_long(test_group, "memory.current");
-	if (!values_close(expected_current, current, 5)) {
-		ksft_print_msg("memory usage should increase by around 2MB.\n");
+	if (nr_pages < MEMCG_CHARGE_BATCH && current == old_current) {
+		/*
+		 * Memory cgroup charging uses per-CPU stocks and batched updates to the
+		 *  memcg usage counters. For hugetlb allocations, the number of pages
+		 *  that memcg charges is expressed in base pages (nr_pages), not
+		 *  in hugepage units. When the charge for an allocation is smaller than
+		 *  the internal batching threshold  (nr_pages <  MEMCG_CHARGE_BATCH),
+		 *  it may be fully satisfied from the CPU’s local stock. In such
+		 *  cases memory.current does not necessarily
+		 *  increase.
+		 *  Therefore, Treat a zero delta as valid behaviour here.
+		 */
+		ksft_print_msg("no visible memcg charge, allocation consumed from local stock.\n");
+	} else if (!values_close(expected_current, current, 5)) {
+		ksft_print_msg("memory usage should increase by ~1 huge page.\n");
 		ksft_print_msg(
 			"expected memory: %ld, actual memory: %ld\n",
 			expected_current, current);
@@ -135,11 +159,11 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
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
@@ -147,7 +171,7 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
 	}
 
 	/* unmap the whole range */
-	munmap(addr, LENGTH);
+	munmap(addr, length);
 	current = cg_read_long(test_group, "memory.current");
 	expected_current = old_current;
 	if (!values_close(expected_current, current, 5)) {
@@ -162,13 +186,15 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
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
 
 	test_group = cg_name(root, "hugetlb_memcg_test");
@@ -177,7 +203,7 @@ static int test_hugetlb_memcg(char *root)
 		goto out;
 	}
 
-	if (cg_write(test_group, "memory.max", "100M")) {
+	if (cg_write_numeric(test_group, "memory.max", num_pages * hpage_size * 1024)) {
 		ksft_print_msg("fail to set cgroup memory limit.\n");
 		goto out;
 	}
@@ -200,6 +226,7 @@ int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
 	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+	long val;
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -208,12 +235,15 @@ int main(int argc, char **argv)
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


