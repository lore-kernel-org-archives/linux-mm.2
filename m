Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7662EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB5C6B0093; Tue,  8 Sep 2026 09:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7827E6B0095; Tue,  8 Sep 2026 09:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699996B0096; Tue,  8 Sep 2026 09:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9506B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:41:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E48FF80510
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:41:58 +0000 (UTC)
X-FDA: 85190708316.22.F3B21EA
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 98CBB40008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:41:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTNKSg6x;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788874917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IH/Mam/MtAb/UBI0BhjDUWUlvqcprGVjAu2d6h6z+zA=;
	b=3H1cCccjR+/eW+tOiPSfufmDt/Z6RFKABQQoBf8oRKi2EgPcANwKt1+KRYxBQMMeWEi/HZ
	1ntXHgAfvI9F3VU6gyxyP0XSpQeE8qmGepy/eUagdQcVYGj2ZJFIvMw8xvCHiyurFztlrn
	9wDMZulcePNzTTvzqK+UCm5gqTN8/h8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTNKSg6x;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788874917;
	b=ZDLQjyqy1wP2xWTu1Yl0wjZ95BtnZ8cEPrgqGJcanA4vwxeDdiz9Y7KM7TTUQI5UX0x4DM
	TYAZ2ScOp/am6uA+VZ7d4Bgn42X6M/ow6G5hQCMue6mzieXvYIlcONoMR9Uptcw3Pb30ql
	yC3htK8yc5SyUzfDaz8F3d/6cKNViuQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9Pn6WEKh9yWLcc46n2nOTgd0OJ+T+gFpMQTRrWx1hgs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874914; v=1; x=1789479714;
 b=MTNKSg6x6bEVRkvz5ATOcXafg42L1fEJGfhYrjA4SxtaGYbfsuv7iekjWiQRnKbGAHj1NkgK
 Vv72SyhOmcdnVqHu8Qyg5/OCZrw21YpYBSfKtN+fct1ZDPj4A1kL3VjT55uMvf6eD2HmP9Wr98n
 nVjZ6w+UbXQV5F3S+iOXBlB0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d22640a39a64a70b;
	Tue, 08 Sep 2026 13:41:54 +0000
X-Mizu-Trace-ID: d22640a39a64a70b
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
Subject: [PATCH v2 1/3] selftests/mm: fix size truncation in pagemap_ioctl test
Date: Tue,  8 Sep 2026 21:41:15 +0800
Message-ID: <20260908134117.84405-2-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908134117.84405-1-zenghui.yu@linux.dev>
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98CBB40008
X-Stat-Signature: otxu8wkzha5xhsjgm4x7u15bcc9h59oi
X-Rspam-User: 
X-HE-Tag: 1788874916-731868
X-HE-Meta: U2FsdGVkX1/T0B1mwDEwfZjwJ53sf9vkdelD11t3j/w1Zk+IHXCNpVOUwmvbqZJxinyifQP+suMH0nYuKzZdI3S3Fmpoxi+xbFw68ts5YqNzjiK6sSzDKJQz/fJIfSKP4XdZFIbzxDSP8zhuKV8AUczHAi/jPkEmPIS0xnAU+t+HOaVWTcV62r8qVQn06C7KecMarXdUJPVDZnW0SxHDFWVNaAFj/qSTKJzA1xNHrod7mJ7B3hz06sYMvetPkrjZJi6vbQxOBcABDk6CeBbYU5sn3hnSfe0AaNLynEFdV22msxeTIZLswVpju6IVe2A7X7EFcAEVqwdVZXEYpArC1+HZne6qndtc8Dwa8wTmDpv/3tRCOj8HLUoolEJgFH73Uu/Zy4xtkeqUMeQd8FK1peF/Dfay365//cdGGNtbO7ZWm13V993tyyYaLElo7yrVBHFpG7Lb5KHogXyikNJo3igkXbEM6+WCSwVtocaDgf3vP+T8kOLhhL8Frukp1wS7e76EPQsuRZn5j2yfejGtsWNenWaQZdB+Mo04r7rV/a7t2wLPqvTiCOstLFHZ2YGRJSafaB28mkGZCuNbgZCppCr2DgI7LEd59PWKQ8J09pfoqyAPjLw3hkjdExT62oJttYmNnr1lNRTKj98skayyOl5uCYL6e1fjkMpGoEy3NkzKG0RU3DKiN7XJC0mFKmuS82cynybtWZVdZhGHC/ekEcFjPbgrQ4A0LqZI7mH/wiOw0GOOZtIS55qCAWjk2Jrc7ctmKLV84qFwz0oezTT8hhlQYX3uIpH4zbjNTa/KKFlNKjOAl9C0vU1pWd+qvj+KK6q6sMS3xtpX55HAkJHj+EoyUIb1fVuWNt/FeV2Ajrx1avJ8oy7KB1bx258/Nk3TAptiOJLUuXVIwGcVu9RHJ3o5lLZf4peRhyp6+BLSdSBXyDZ5NLjycKaN82kVqA0orf8M7sJB3hCrxQu4vvP
 JVWWnzh9
 OGPy59SQceSkV7kWz5zlZ3VI+mlsZBWiU7h6T3kIgWVMG+II+zMEUFF7MftaRmVkER1cDKpE8Ng/O5/YA/VTHmxdl8HoBasEMvsEh+52jDTVeZNdvHTz99opr8FY73YviVALO6M0y1fDOUL8lHlbE56WXeSjwJ5kgaMk9yV9QnUBofO8FOJFB7JTAyCZVjJc/eXu13yTYemhm8MfDPOvYrmMvnsPbk75T7dHtgZs5r4UbZw7rZxPFJ3PRjLe8ljDHt2WP5KCp2eww68HXmJ0NsBOhI+TZxuEvXo1TD3Sq0u473Bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

On arm64 with 64K base pages, the huge page size is 512 MiB, and
hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
exceeds the range of the int size parameters of gethugepage(),
wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
makes gethugepage() allocate a too small buffer, while the callers keep
operating on the original 5 GiB range, resulting in spurious failures or
SIGSEGV.

Fix the truncation by changing those size parameters to size_t, and for
consistency, also convert the remaining size-related parameters and
variables that use int, long or unsigned long long to size_t.

Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Assisted-by: GLM-5.3 OpenCode
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 55 ++++++++++++----------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index eadc7159ca5b..3665530eda76 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -44,7 +44,7 @@ const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
-static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioctl(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			  int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			  long return_mask)
 {
@@ -65,7 +65,7 @@ static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag
 	return ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
 }
 
-static long pagemap_ioc(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioc(void *start, size_t len, void *vec, size_t vec_len, int flag,
 			int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			long return_mask, long *walk_end)
 {
@@ -116,7 +116,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *addr, long size)
+int wp_init(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -140,7 +140,7 @@ int wp_init(void *addr, long size)
 	return 0;
 }
 
-int wp_free(void *addr, long size)
+int wp_free(void *addr, size_t size)
 {
 	struct uffdio_register uffdio_register;
 
@@ -152,7 +152,7 @@ int wp_free(void *addr, long size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, int size)
+int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -162,7 +162,7 @@ int wp_addr_range(void *addr, int size)
 	return 0;
 }
 
-void *gethugetlb_mem(int size, int *shmid)
+void *gethugetlb_mem(size_t size, int *shmid)
 {
 	char *mem;
 
@@ -188,7 +188,8 @@ void *gethugetlb_mem(int size, int *shmid)
 
 int userfaultfd_tests(void)
 {
-	long mem_size, vec_size, written, num_pages = 16;
+	size_t mem_size, vec_size, num_pages = 16;
+	long written;
 	char *mem, *vec;
 
 	mem_size = num_pages * page_size;
@@ -229,9 +230,10 @@ int userfaultfd_tests(void)
 	return 0;
 }
 
-int get_reads(struct page_region *vec, int vec_size)
+int get_reads(struct page_region *vec, size_t vec_size)
 {
-	int i, sum = 0;
+	size_t i;
+	int sum = 0;
 
 	for (i = 0; i < vec_size; i++)
 		sum += LEN(vec[i]);
@@ -241,7 +243,7 @@ int get_reads(struct page_region *vec, int vec_size)
 
 int sanity_tests_sd(void)
 {
-	unsigned long long mem_size, vec_size, i, total_pages = 0;
+	size_t mem_size, vec_size, i, total_pages = 0;
 	long ret, ret2, ret3;
 	int num_pages = 1000;
 	int total_writes, total_reads, reads, count;
@@ -331,7 +333,7 @@ int sanity_tests_sd(void)
 	if (ret < 0)
 		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
-	ksft_test_result((unsigned long long)ret == mem_size/(page_size * 2),
+	ksft_test_result((size_t)ret == mem_size/(page_size * 2),
 			 "%s Repeated pattern of written and non-written pages\n", __func__);
 
 	/* 4. Repeated pattern of written and non-written pages in parts */
@@ -682,9 +684,9 @@ int sanity_tests_sd(void)
 	return 0;
 }
 
-int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
+int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
-	unsigned long long vec_size;
+	size_t vec_size;
 	int written;
 	struct page_region *vec, *vec2;
 
@@ -787,7 +789,7 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 	return 0;
 }
 
-void *gethugepage(int map_size)
+void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
@@ -810,8 +812,8 @@ int hpage_unit_tests(void)
 	char *map;
 	int ret, ret2;
 	size_t num_pages = 10;
-	unsigned long long map_size = hpage_size * num_pages;
-	unsigned long long vec_size = map_size/page_size;
+	size_t map_size = hpage_size * num_pages;
+	size_t vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
 	vec = calloc(vec_size, sizeof(struct page_region));
@@ -1002,8 +1004,9 @@ int hpage_unit_tests(void)
 int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
-	int written, len = 0x00040000;
-	long vec_size = len / page_size;
+	int written;
+	size_t len = 0x00040000;
+	size_t vec_size = len / page_size;
 	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
@@ -1072,7 +1075,7 @@ static void test_simple(void)
  * with no page table, exercising pagemap_scan_pte_hole(); a base-page range
  * leaves pte_none entries.
  */
-static void unpopulated_written_test(const char *name, char *mem, long size,
+static void unpopulated_written_test(const char *name, char *mem, size_t size,
 				     bool use_thp)
 {
 	long npages = size / page_size, fast = 0, slow = 0, ret;
@@ -1115,7 +1118,7 @@ static void unpopulated_written_test(const char *name, char *mem, long size,
 
 static void unpopulated_scan_test(void)
 {
-	long mem_size = 16 * page_size;
+	size_t mem_size = 16 * page_size;
 	char *mem;
 
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
@@ -1157,8 +1160,8 @@ static void unpopulated_thp_scan_test(void)
 
 int sanity_tests(void)
 {
-	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size, nr_pages;
+	size_t mem_size, vec_size, i, buf_size;
+	long ret, fd, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1582,9 +1585,9 @@ static void transact_test(int page_size)
 
 void zeropfn_tests(void)
 {
-	unsigned long long mem_size;
+	size_t mem_size, i;
 	struct page_region vec;
-	int i, ret;
+	int ret;
 	char *mmap_mem, *mem;
 
 	/* Test with normal memory */
@@ -1642,8 +1645,8 @@ void zeropfn_tests(void)
 
 int main(int __attribute__((unused)) argc, char *argv[])
 {
-	int shmid, buf_size, fd, i, ret;
-	unsigned long long mem_size;
+	int shmid, fd, ret;
+	size_t mem_size, buf_size, i;
 	char *mem, *map, *fmem;
 	struct stat sbuf;
 
-- 
2.53.0


