Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6075F3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117976B00AA; Tue, 10 Mar 2026 05:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFE06B00AB; Tue, 10 Mar 2026 05:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015F86B00AC; Tue, 10 Mar 2026 05:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E076F6B00AA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B00F41C694
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:27 +0000 (UTC)
X-FDA: 84529685814.19.2A17FC2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CCBC40002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lUNse13u;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCXEgYVNSLIHqttIpjBfM4opFxQVGZY/tJEQ2JpOh0w=;
	b=j+NoF+hUkux1QdX7qONdBwASSxWNnCjaSLElsMTOxtvvaMZyGeZqfh5GhS29tNrPhH7VAw
	8JeVRXf5seN9Y4SW+cgalxzJz6vJn6sRh00TplEa4MFB2i3xobPglFvQ+7Sn1ZLRRfLNmV
	Ue2h1LT5bkIUWeBMLq3Fe1H99m/HQXk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lUNse13u;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136285; a=rsa-sha256;
	cv=none;
	b=zGd08d7DDvzDl1O9xRcNwXOmdjnDDtG5glnpu57Khtk5QGhbS+g2BPUGJfdYa5g6aNs7bY
	rNA11BKeSliIxuNN0h7HJWNNBq/7hr07HacOFup9DC+TyIDN8+jUBbb2KwCVNgt0YHdIzn
	PjC0rWzThQIdyfyfDQ+kGszdHEWKoZI=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629HUh3E1888503;
	Tue, 10 Mar 2026 09:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CCXEgY
	VNSLIHqttIpjBfM4opFxQVGZY/tJEQ2JpOh0w=; b=lUNse13uhEku1AkULnPxm+
	ONduspGGaiNkYVFolbwIP9rx5tzSvojhMUBFCeiWU8QxW+Y9XJgs+7QY1/aATPEA
	WZYHrrD0mbfkPjrALjSY5qT5URCgy8D1j6JKyleLObXHCdEbGKzEC5rH12Emlx0m
	20B0kvmAkhGteFXalHPGM6tGcU+1jPu294U9wRoTasAqyp1AO+ty2T1RmqSw8yac
	WOaJtHAFZN+ZTrW0BSS7Lkh/ORbMQCWaEfTQAVn8pnU/UC/SMgoQqXOotJl2J8S9
	23Km1B8Gcodd/3613xdzoGbS3ZZuEXJcflAHd6bSCOybobR7yIoOQ/EY/0ELfemQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crd1mhxk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A622jE015653;
	Tue, 10 Mar 2026 09:51:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crybn8jdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9pEW748038182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:51:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A40C20063;
	Tue, 10 Mar 2026 09:51:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E76E20043;
	Tue, 10 Mar 2026 09:51:11 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:51:10 +0000 (GMT)
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
Subject: [PATCH 13/13] selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes
Date: Tue, 10 Mar 2026 15:19:31 +0530
Message-ID: <97f1fc6020b1d63d1d73de6edd1525d91e4f7123.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ds3Wylg4 c=1 sm=1 tr=0 ts=69afe995 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=qf4gfuq51q0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=sc5eBBQPW9lzBnlyZiYA:9 a=3ZKOabzyN94A:10 a=k40Crp0UdiQA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX+IYdXkj3Hwrp
 JWK/8uU7PTOLBCzu0NSU//hfoghnHiON3UZgxK3QW+ofiA84Yu4HipVxgPr++sxcVWr9bCPyLPq
 S5+LYWl8cXAdkU23MUC6H7VRP+jRAisRM64uwtXfityTaI4x1RSKaHHsWt47jnB363gQwJRPxqn
 kdNfBj8H4/9hJjfDhD6HjytG8HFbE0JyCDlYJinZCeIk0dlkM2RM0ytEMaJli+MA+by6V59IiDq
 pgcBiDgXhO6e30+0ZvMc2rk57ofOURgL8D2C2pBjr4fFdBvP0vQ117AVxsD+OPr6PP0qfIuPwnl
 oQGM3u+nw0bT9PwcpQ+JFdQ8/aCBWpZt/8nJZm7DuL3SkQuE0c0TVYFXVfdL5pnIGsuek7oXMK8
 FZDxebHQvWygfvm5CJre+bbQ4UjEElOhoZiaOR6bOK9msrSBUkOH6K9DrcEh7KCRbrgvW7DG1RI
 fPyERXIaSt5wV1DtSyw==
X-Proofpoint-GUID: m4HyO0ZIRK_eqt9ccxcPHTQAEcwgKJu7
X-Proofpoint-ORIG-GUID: atSLOqao42o4kE-yPdnswbyTGD3OzxTC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CCBC40002
X-Stat-Signature: ohjgtomkipgfs6fc5emyprnswh3ipsas
X-Rspam-User: 
X-HE-Tag: 1773136285-644719
X-HE-Meta: U2FsdGVkX1/zvfMeCGfttBX4cr9l15fbmAoHxBOmV+Y93Lssg61WvuPAHT+3UPx1DwLRJDIZnd+Lbcm0A5BLBhV+mumaqkracQt/s3VFh6OkbDjks4lGwQW956DxtEd/7JqbRKzRvMzwekPnkrMAWQf5GqvcGXQzHwXcWNd320SpV0h9o7YTwh+D5nwFjx5flMcegu4tB1cl9db7CgU26keWhmVAtI6D3ubsDYZLhxLYdwPawcaIfZMaUOaP0IbL8/n+Ijv37V3NLJXuaFlDe+TFV8Nek7bsFxgpYN8Vy02gtz0pZpiz8EQ5NPfWEyZr4TwaGMhoiKyxhx2RZdeeJv0jzvflb8CHb7fq5Z8d0bqjB4Zytfs9rDx/IiP5BI76pbrSDmLkMEdITgSwlfzNhKtsvcT86wvBu5gr3KAJ9cp3COqTXsdzgQvErvRzH9BKbMr7LMOqCc550MqGUCk9nBWBMiXz1xVGnxvFR+t6SX3MehYMLXE9RSZiszF5rWMVlVy1tNsFPQdPyDCYuUPybG2J4njTc2I8q0fJCwKm8FmZUM7dwHd7qzEkv36JjtKBoU9Q9z64mjLN0MHLpjcQwMbAwrDrQ2g8JjUcG8B0+XJZOX722IFFzBVaGB/vDTxgjdDfWG3zspNiLcq8OvDUOXikrCfUE2m0JeNJHO4jOO3m3a2oH905VfNrAc7kvEqzIVdNpVWi/37KJjCu8hMeSiIpOLD5Ibb4XQpt0UQgKHGphRSzOJJzd38ZsNracEYeOklaFWMCqWE7EdxYlyOa90AK4CQXhZOd7oen90ActIcChR4apFfe3xlXrK9RB6V2wLPRwpdV1d61QHpvkEJC0Ea4qa4BDuPBLOhHtvy9+3yYdEox0sLQiZCieAMfIxcWS5J1u1JXvyg7odxHMQnzwVpOpQwjp2G9Isiq90zgA89wqCbB2FWE8tTXZUSpjZWx9ldYf2bU9vKx/KAy9h5
 kWtgt9vV
 BB15FU69iBNe7xvfTrBmgf4D1+4O20o47vd+t7cPOuzIwEhkl7X1H867KmBMSmCcnZ9zhFUELjeT2WajYeCv6cL97xYBYAoYJp/91xewpzlSyZ5wZHZmM39LzpWsAZY0WHpEFfTr2+qx+maSY9IaixhzHbCr7G0kMOLbFPiQx/KBT8cwZwRG7NIXeCtFmVtPVQXz6F97S3PadbObNIcjnOXMRFShPI4x1cQ5q/ZP3uFtdrTmooYqBRA7wlX22GUV7FbsHE1ZG0GFJ2t3d15yrd8l5ryDisbrmpvUdFnMBqYQ5EIlp7attnBOj9/t9IStZ3QkYw9IAeU1RDiW57yxXTKBRqc6IMdGkYF/hIqzGdtHV+IM=
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


