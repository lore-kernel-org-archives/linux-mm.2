Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01BCC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB6F6B008A; Tue,  8 Sep 2026 09:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92936B008C; Tue,  8 Sep 2026 09:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFB36B0095; Tue,  8 Sep 2026 09:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5D76B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:43:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B74C1A071C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:43:31 +0000 (UTC)
X-FDA: 85190712222.09.7A8E959
Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	by imf21.hostedemail.com (Postfix) with ESMTP id C11231C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:43:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsvSKsiP;
	spf=pass (imf21.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkvfxvXaSx42pccE/WdLCzbhqzNrm6oXN1wr/Yn3M+4=;
	b=YFNKPsBvnaDZitii85cQBTInCw9CHJI1r+ttKPYeHm9OoaWe3STylIhLtIp4DoHgZ201aS
	cAtDtfKoWTYGH20H2AlWhvU2hoD43mcjVm6GdNmI2gHax4540WTvTsYYkAtSbzp3TFEVfS
	b3Rq/zVQgGjQg0k9dYRK2QPpJL17KHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875009;
	b=SraOfFfbXA2ny+pD+E/QWdnLiy3hbWI+mf8JQU73LQnEp5Rx2IAtLOGiYSUFYhwaktrMwS
	JG3AUofjlCP5MGqTNot5xfvoVekaySqkO9ZBTYAHhCpJSu0B1tfMH98N1vYV/ffyMwqx38
	sj0E4MiKiKPxN5FA+jiXc/aGl7nPRTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsvSKsiP;
	spf=pass (imf21.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YVHXbf26rA+jKhFYHPEQQG1zeSvG9J2n54qBLSk4eXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788875006; v=1; x=1789479806;
 b=AsvSKsiP1qCoD7qYXZkQirh3mScZWgVvGFeQ8A3f4KDq5NotBxaFkX3sixHHiKD6xKxVVi63
 jzYF5gDn86/MYs3wamasAwWImCguV8rxuQPhBxINEtfs3/Qe++FrYdUl/34ncKF1kfWqBNGheXl
 p4vZK4YVPmRXZLVr98+zBxGM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fac4a1df8e1a2353;
	Tue, 08 Sep 2026 13:43:26 +0000
X-Mizu-Trace-ID: fac4a1df8e1a2353
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v2 2/3] selftests/mm: mark file-local symbols of pagemap_ioctl.c static
Date: Tue,  8 Sep 2026 21:43:14 +0800
Message-ID: <20260908134315.84431-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908134117.84405-1-zenghui.yu@linux.dev>
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C11231C0004
X-Stat-Signature: n735iffrdr1jeb3rexiob8pfwcpmb3qo
X-Rspam-User: 
X-HE-Tag: 1788875007-705978
X-HE-Meta: U2FsdGVkX19KZdYi0PxdBYCgHfvCYivIcF/5B3xaqD5/r7XrOagc1T6EGXQGXQ1U6RySvhHK8OVGVESh5nk0qettGtcsXYdX6OHGDMVtGLGxeRt9LdrDQC1cr4rmlgj82NyqYNrRjtF9HJtNC+hUpUKxrFxke2jd3llOxmRm9Clu8kyHI39NNtumKUvRPDnoU87FIGw77Hyb/ELBPcxmt/xySo2xQa849lQX6DWL6jC6OTIuDQpBSQwWe3BSJiOWztF6qnuuHuhGVNFvjsG36X97wEI5gLeewh/IXqx24sAM6svpx5PXyFUGs83c8lZWrwAfl5Fv4U5qrrw2KzC8ZnDv2I/P+KyYVM3CU3tLdLWwjTfVCIS352e4OkO5k1yFzcyltGaIllQJTeX+d7Aur4TuQ8CNAwFdsVsFO9oNSt3UQ8bNOURAWRN90fwa7T0sfjGH2uDbtP4JkE0kHL5cYjavVHZU0jg3wpWypvdFGTR34ve7RFqRMqoy6b3/2epwuO0cCVU5QYODoWqSIW6fxmwVXkqlZgc69hYVR27cf3ZRvj2kxBxfWYwfU++doXVB8zMBzgFaQV9UZQ7Zu2Mebu0kbYik4WK/levv2EZDjARNnKAZXg7DfzCH/TcwPJO1WGxe1UoLjMOww2CpJrYacDlsTQ0Exb8yiYtfTngmodA0ZnXeWKh/HtkRjKWi6NPxWoE4mBaH3SXc165iVXzEsYQo9lbbZNhaHwESGw+Ns7Ooz88yt2egjs5UkQO4fyfNrrRK81okwKIgqsDIlvwCaiPSFCE1x2RYbsFL9h8CGLM+DDfNh4q0D6/8SSTSDF9189XU51E+N0XBXDIIIlcTSuC9jympPM1FXdMNhxeMskz1Y/DcgDmW/++3U3y9Zlj2DlmM/CBst1GGl81IuW35S36qNmq4N0p6vTdc5WETu22BPNUGenK5mqzsCPwDI6LNeKPs+krQ7FAquXXVcgl
 tExTzJqD
 OM12CKRB4sknKnsdvYR7SqJf+KwSlJi2GWLsZ3J7ypV0PfySjSDUp76jyESk8oaBeIeNARz4VY5V+rjNcKkL1o/ky/HMuDMfmM4QMtC67ID4+mDLXt2P+9FTvPppJycgtKk4m+S0+TBouCKDPAp/1gNg3pSPKvlfYdPZ5ZGwR2gpA6G1KphMWYUkAC6oVPJzzGDnt8Q5ZmrDfv2K0MvtJ8LrZf7kpGyTVe8Uo1DXb9PIURKDxzF/PCkUjVLXLX+UENS0nN/FxCAkXX8MqgJct26SueyQPKYpqhdtADvAR0f8nMyLV4Ni63E9Zf0Bu1NG0Jd8KER3cnUzwu9fVcUrSEhcymbi79YdQcQjL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The file-scope variables (pagemap_fd, uffd, page_size, hpage_size and
progname) and most functions of the pagemap_ioctl test are only used
locally, but lack the static storage class.  Mark them static so that the
compiler can catch accidental outer references.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 43 +++++++++++-----------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 3665530eda76..1a87b7483316 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -36,11 +36,11 @@
 
 #define TEST_ITERATIONS 100
 #define PAGEMAP "/proc/self/pagemap"
-int pagemap_fd;
-int uffd;
-size_t page_size;
-size_t hpage_size;
-const char *progname;
+static int pagemap_fd;
+static int uffd;
+static size_t page_size;
+static size_t hpage_size;
+static const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
@@ -92,8 +92,7 @@ static long pagemap_ioc(void *start, size_t len, void *vec, size_t vec_len, int
 	return ret;
 }
 
-
-int init_uffd(void)
+static int init_uffd(void)
 {
 	struct uffdio_api uffdio_api;
 
@@ -116,7 +115,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, size_t size)
+static int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -140,7 +139,7 @@ int wp_init(void *addr, size_t size)
 	return 0;
 }
 
-int wp_free(void *addr, size_t size)
+static int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -152,7 +151,7 @@ int wp_free(void *addr, size_t size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, size_t size)
+static int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -162,7 +161,7 @@ int wp_addr_range(void *addr, size_t size)
 	return 0;
 }
 
-void *gethugetlb_mem(size_t size, int *shmid)
+static void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -186,7 +185,7 @@ void *gethugetlb_mem(size_t size, int *shmid)
 	return mem;
 }
 
-int userfaultfd_tests(void)
+static int userfaultfd_tests(void)
 {
 	size_t mem_size, vec_size, num_pages = 16;
 	long written;
@@ -230,7 +229,7 @@ int userfaultfd_tests(void)
 	return 0;
 }
 
-int get_reads(struct page_region *vec, size_t vec_size)
+static int get_reads(struct page_region *vec, size_t vec_size)
 {
 	size_t i;
 	int sum = 0;
@@ -241,7 +240,7 @@ int get_reads(struct page_region *vec, size_t vec_size)
 	return sum;
 }
 
-int sanity_tests_sd(void)
+static int sanity_tests_sd(void)
 {
 	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
@@ -684,7 +683,7 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
+static int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
 	size_t vec_size;
 	int written;
@@ -789,7 +788,7 @@ int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 	return 0;
 }
 
-void *gethugepage(size_t map_size)
+static void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -807,7 +806,7 @@ void *gethugepage(size_t map_size)
 	return map;
 }
 
-int hpage_unit_tests(void)
+static int hpage_unit_tests(void)
 {
 	char *map;
 	int ret, ret2;
@@ -1001,7 +1000,7 @@ int hpage_unit_tests(void)
 	return 0;
 }
 
-int unmapped_region_tests(void)
+static int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
 	int written;
@@ -1158,7 +1157,7 @@ static void unpopulated_thp_scan_test(void)
 	munmap(area, 2 * hpage_size);
 }
 
-int sanity_tests(void)
+static int sanity_tests(void)
 {
 	size_t mem_size, vec_size, i, buf_size;
 	long ret, fd, nr_pages;
@@ -1330,7 +1329,7 @@ int sanity_tests(void)
 	return 0;
 }
 
-int mprotect_tests(void)
+static int mprotect_tests(void)
 {
 	int ret;
 	char *mem, *mem2;
@@ -1450,7 +1449,7 @@ static ssize_t get_dirty_pages_reset(char *mem, unsigned int count,
 	return cnt;
 }
 
-void *thread_proc(void *mem)
+static void *thread_proc(void *mem)
 {
 	int *m = mem;
 	long curr_faults, faults;
@@ -1583,7 +1582,7 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
-void zeropfn_tests(void)
+static void zeropfn_tests(void)
 {
 	size_t mem_size, i;
 	struct page_region vec;
-- 
2.53.0


