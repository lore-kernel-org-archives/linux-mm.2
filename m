Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27704C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066556B009D; Wed,  2 Sep 2026 08:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CD06B00A5; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10116B00A0; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E3A6B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 710041401F0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:59 +0000 (UTC)
X-FDA: 85168703718.15.7E5FCAF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A3C04000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nxEbllyE;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMAqN7CQ7pdOG1DCr96moY0Mva5RDA4faIPAt3OXiP4=;
	b=ga+d/5dFKZBPvRm/9oXZu4E6N4Tqb5en3xksY1nXkuxwmWGLgFZODrETZdzULQaiI52TOr
	6fSuhNpFnisCQqzHhZzg8l1RApBpNU7MdY/GKx65r8gQiHGUKcglrNAmkCd7tZ/xpDN8vN
	YTZ82VsKoalNNXNvrp8ugCHZnFuqstg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350997;
	b=DtYUO22qPSXy18vASFDKzdnq+chXr73w1lU8tnDldU5nSxu8ppz6/ppXBkmgXobx79mP8C
	LvNZ3PBbBhwMkxOwAeth2/1V7Jf4O7SNBkSUop/X7HhkYLWIz3VPHuKaQnQP99gXDsbL9Y
	nNnLaUaYGzqqTH0XCvalL/PCOgk701U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nxEbllyE;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E3421596;
	Wed,  2 Sep 2026 05:09:53 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C55853F882;
	Wed,  2 Sep 2026 05:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350996; bh=DANlS/WG3vcZ3yRMTpJB3w5jDSlve3pDHHGfiHikqQo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nxEbllyEYJTlEJXINWff0bTEU0NA5uSll+EOAEgJTQnyzHtlc7SW00h/bXTM+FUZw
	 6SWQThEpXewR1Zq7OAefjvFRMWCaB9uC/3d3vJltpto0QPsAJGK5Mvh9umqebxp6ze
	 1UsXqwFs6bYlszPP2a8rgQQKywwC427WOKa1t1wY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 13:09:37 +0100
Subject: [PATCH v4 3/3] kselftest: mm: introduce alloc_isolated_mem()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-fix_split-v4-3-85f03905f7b1@arm.com>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
In-Reply-To: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10091; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=DANlS/WG3vcZ3yRMTpJB3w5jDSlve3pDHHGfiHikqQo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmBIHs7pF89cSxGwpki4jLKSqglpR1vGMk6Fjy
 qMjslalJ6uJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgSBwAKCRBt1cPRWsUx
 M4oIDADBB0qtxMU8lfxFpnCs1iB+JetjIBjDccWR/AOrM/QnpNr7v2AnXkEQqdYuOkOkU/yBaKA
 f6cibt3PA0Hh5L+87k1iM+CCYU61lr5cb0ADjxxcEMWOLqeWvOVq3OJvIEzGpIUNEDIv6eOtVPQ
 K0XwCUgdddVrA0fM5G+4ecjSzrRt6eiubh59XD3B+aZkbnslbJ/L0k7q8/7O2UyjYzxrKdSC0nn
 mN2lNi20NRAZPb1t8bP0gAlhXmVsJDAflv420L9yaQyqt9JL5S4RXQkrjNClslrCMyIxKJuh3mJ
 6apEKSvqImiQgr4xX85AA2Tdexsbapcvl5dHPXiWtB+athqtk1QImiBkRcIsjfimzH+7kLkG3AJ
 /x0/p/OPGCEQZdNuSVzjQpeo6PFbW1t4mm1NPNkcE3oIUtHLHn0b0miKDZduiPuc1vwzY782Hw2
 MWah08HovRwLOPhtPZx0dd+sbr/uoC4xw5elHtiwLQRk4G6ZjS725u7CThRcTODt0iyTo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 6861i3oxpa6s5kh9nh89bimkj6o4kwew
X-Rspamd-Queue-Id: 9A3C04000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788350997-44036
X-HE-Meta: U2FsdGVkX1/Vi468XlWdR6H2HfpPCv3Th8eawtNAKWf+ke3Q8DfE61Rs+duBD7zxQERATg1PkO8IM44xzJTTag5HO147EKWjVjRhCkqrim4ljUsMnFyvU5ZC2sYnjn/eo5zRgvVO+2cpkf+QU2CS0xnUxd8zfihT+72VdruffCabSLYxZLCmbbGyj6U8NVkYvzx9tsMu+yXhkqQYzDms7A1R8Ers+crpQz4Q2JDehUBHctjSp70iLKJbxBga+lJJjU9EHilHcm5G8M9HlDdurhD/y0uR+zeFGo/mpltYF+ikIdT7zgq3yNvgmv/kA6Ogf5fi7T54j7mAN0Ju9qv0lmctF13pREijMzA26bgZCoR7bBVZGvL8EFT2DE0XXTlANEuHmWX1ZUGKdo0knuBNce6xGtq7X1Zqk67j/f90TWasrDVrJdJk/ywuFJuKnSzdUZyWlggm4bZWG17HBaqwQnQx4cbKUD1ADiciTHKZ7Zf81ELFbCYufxJHBzuCyvmcKxY657/DxusNP4Xj0CJXuqNKx4J8qN4LpAUOPmtwPhsEb0xrN+Esb6cmq0uO8h7FSrqLyKVGsjXvWDfxRSpO7r+loFOoREVpH74dX1APFkcW803GuFTHpUSwdnN/NsWfYZhL9+8eD5ELyzoOzXeS+gUQ+iowbLe1CVNZu2Y4C8ptxZRVhQl5F9NlwRUmdPf2Y2/pvbGI2AWzp6q/S24U4NaYAbc7aPSaLp0+VeIirXfUC6LNshaF2KTxQ1lvEB2+cr+sqz7QkTcF1r0TcwCCeGM4jFj9yHD4gymuaoTvBQ0GkTUDM9LOls2NM3qu1xpWsKijliesdjpzxUyLUZiifw2IkBlO0TtoUIuj++LHpp8heqapjTv2FNMDEui/dyCaoeqWrnfx/X8RkRaz/PB3Z6Ak+vDZUc/Ld9JgJmk+kfzxR2mwZ8A8vtF3dECOWMDMOMF8PrcUSx4s32lwRXy
 VTI2Kp/g
 HJUWvDB3MJzrSr1eKR+zGwbbN+Qh7wShu4QRLQqnukgn/3G86xEBzTBgbhQ8OhyAbPss9WAZOVWwxd9+DFLrOvwARTl36ei2jt1WAzSb92YeQ2mrY5Di+/VWO6xKD0pTq1Rbq8S5ZRWJrWfk4fqW/01wQwsy+9URv8XYGE7cMLGpO80oYqG0PIgTpomoLTcFWObclG1W3KIkllI2/GldUI0jfWoJirUXZf6+l+FfwWhxXqPz4ITkHIJy90Dyt6wV3SYmk54LFiA97jifK4dNoZ02nMSQJbvLuHOnwtm0Mn+/8VVgdG6wiYuNhpz49llT9fFjyZ4jvDfCMDrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some MM tests use memalign() to allocate memory. However, the resulting
memory area may unexpectedly merge with an adjacent VMA, causing tests
that inspect it through /proc/self/smaps to fail.

Eliminate this potential source of test flakiness by introducing
alloc_isolated_mem(), which places guard regions before and after the
allocated area to prevent unexpected VMA merging.

Replace memalign() with this helper and use the helper in
softdirty_supported() instead of mmap().

Link: https://lore.kernel.org/all/apHDdRSr59mva3ey@lucifer/ [0]
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c        | 18 +++---
 tools/testing/selftests/mm/soft-dirty.c           |  6 +-
 tools/testing/selftests/mm/split_huge_page_test.c |  8 +--
 tools/testing/selftests/mm/vm_util.c              | 67 +++++++++++++++++++++--
 tools/testing/selftests/mm/vm_util.h              |  2 +
 5 files changed, 81 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index eadc7159ca5b..7ed5b8fb3b25 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -792,9 +792,9 @@ void *gethugepage(int map_size)
 	int ret;
 	char *map;
 
-	map = memalign(hpage_size, map_size);
+	map = alloc_isolated_mem(hpage_size, map_size);
 	if (!map)
-		ksft_exit_fail_msg("memalign failed %d %s\n", errno, strerror(errno));
+		ksft_exit_fail_msg("alloc_isolated_mem failed %d %s\n", errno, strerror(errno));
 
 	ret = madvise(map, map_size, MADV_HUGEPAGE);
 	if (ret)
@@ -856,7 +856,7 @@ int hpage_unit_tests(void)
 
 		/* 4. only middle page written */
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 		map = gethugepage(map_size);
 		wp_init(map, map_size);
 		wp_addr_range(map, map_size);
@@ -871,7 +871,7 @@ int hpage_unit_tests(void)
 				 "%s only middle page written\n", __func__);
 
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 	} else {
 		ksft_test_result_skip("%s all new huge page must be written\n", __func__);
 		ksft_test_result_skip("%s all the huge page must not be written\n", __func__);
@@ -898,7 +898,7 @@ int hpage_unit_tests(void)
 				 vec[0].start == (uintptr_t)(map + map_size/2),
 				 "%s clear first half of huge page\n", __func__);
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 	} else {
 		ksft_test_result_skip("%s clear first half of huge page\n", __func__);
 	}
@@ -927,7 +927,7 @@ int hpage_unit_tests(void)
 				 "%s clear first half of huge page with limited buffer\n",
 				 __func__);
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 	} else {
 		ksft_test_result_skip("%s clear first half of huge page with limited buffer\n",
 				      __func__);
@@ -955,7 +955,7 @@ int hpage_unit_tests(void)
 		ksft_test_result(ret == 1 && LEN(vec[0]) == vec_size/2,
 				 "%s clear second half huge page\n", __func__);
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 	} else {
 		ksft_test_result_skip("%s clear second half huge page\n", __func__);
 	}
@@ -988,7 +988,7 @@ int hpage_unit_tests(void)
 				 "%s get half huge page\n", __func__);
 
 		wp_free(map, map_size);
-		free(map);
+		free_isolated_mem(map, map_size);
 	} else {
 		ksft_test_result_skip("%s get half huge page\n", __func__);
 		ksft_test_result_skip("%s get half huge page\n", __func__);
@@ -1702,7 +1702,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 		wp_addr_range(map, hpage_size);
 		base_tests("Huge page testing:", map, hpage_size, 0);
 		wp_free(map, hpage_size);
-		free(map);
+		free_isolated_mem(map, hpage_size);
 	} else {
 		base_tests("Huge page testing:", NULL, 0, 1);
 	}
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 5f278913c4d7..b6fad38c8bee 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -92,9 +92,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 	if (!hpage_len)
 		ksft_exit_fail_msg("Reading PMD pagesize failed");
 
-	map = memalign(hpage_len, hpage_len);
+	map = alloc_isolated_mem(hpage_len, hpage_len);
 	if (!map)
-		ksft_exit_fail_msg("memalign failed\n");
+		ksft_exit_fail_msg("alloc_isolated_mem failed\n");
 
 	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
 	if (ret)
@@ -130,7 +130,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
 		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
 	}
-	free(map);
+	free_isolated_mem(map, hpage_len);
 }
 
 static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 4bbad892bc57..7a600131f7f0 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -154,7 +154,7 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	char *result;
 	size_t i;
 
-	result = memalign(pmd_pagesize, len);
+	result = alloc_isolated_mem(pmd_pagesize, len);
 	if (!result) {
 		printf("Fail to allocate memory\n");
 		exit(EXIT_FAILURE);
@@ -217,7 +217,7 @@ static void split_pmd_zero_pages(void)
 	one_page = allocate_zero_filled_hugepage(len);
 	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
 	ksft_test_result_pass("Split zero filled huge pages successful\n");
-	free(one_page);
+	free_isolated_mem(one_page, len);
 }
 
 static void split_pmd_thp_to_order(int order)
@@ -226,7 +226,7 @@ static void split_pmd_thp_to_order(int order)
 	size_t len = 4 * pmd_pagesize;
 	size_t i;
 
-	one_page = memalign(pmd_pagesize, len);
+	one_page = alloc_isolated_mem(pmd_pagesize, len);
 	if (!one_page)
 		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
@@ -261,7 +261,7 @@ static void split_pmd_thp_to_order(int order)
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
-	free(one_page);
+	free_isolated_mem(one_page, len);
 }
 
 static void split_pte_mapped_thp(void)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index dc62ce84e143..159d627ae3b0 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -19,6 +19,11 @@
 #define KPAGEFLAGS_PATH "/proc/kpageflags"
 #define MAX_NR_ORDERS 20
 
+#define ALIGN(x, a)		(((x) + (a - 1)) & (~((a) - 1)))
+#define ALIGN_PTR(p, a)		((typeof(p))ALIGN((unsigned long)(p), a))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
+#define PTR_ALIGNED(p, a)	(IS_ALIGNED((unsigned long)(p), a))
+
 unsigned int __page_size;
 unsigned int __page_shift;
 
@@ -514,6 +519,61 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 	return -1;
 }
 
+void *alloc_isolated_mem(size_t align, size_t size)
+{
+	char *ptr, *guard, *addr_align;
+	size_t map_size, guard_size, page_size = psize();
+	size_t padding;
+
+	if (__builtin_popcountll((unsigned long)align) > 1)
+		return NULL;
+
+	align = (align > page_size) ? align : page_size;
+	guard_size = page_size;
+	size = ALIGN(size, page_size);
+	map_size = size + align + guard_size;
+
+	ptr = mmap(NULL, map_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (ptr == MAP_FAILED)
+		return NULL;
+
+	addr_align = PTR_ALIGNED(ptr, align) ? ptr + align : ALIGN_PTR(ptr, align);
+	padding = addr_align - guard_size - ptr;
+	if (padding) {
+		munmap(ptr, padding);
+		map_size -= padding;
+		ptr += padding;
+	}
+
+	guard = ptr;
+	if (mprotect(guard, guard_size, PROT_NONE))
+		goto err_out;
+
+	guard = addr_align + size;
+	if (mprotect(guard, guard_size, PROT_NONE))
+		goto err_out;
+
+	padding = (ptr + map_size) - (guard + guard_size);
+	if (padding)
+		munmap(guard + guard_size, padding);
+
+	return addr_align;
+
+err_out:
+	munmap(ptr, map_size);
+	return NULL;
+}
+
+void free_isolated_mem(void *addr, size_t size)
+{
+	int guard_size, page_size = psize();
+
+	guard_size = page_size;
+	munmap((char *)addr - guard_size,
+	       guard_size * 2 + ALIGN(size, page_size));
+}
+
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 {
 	size_t count;
@@ -618,13 +678,12 @@ bool softdirty_supported(void)
 	const size_t pagesize = getpagesize();
 
 	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
-	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
-		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (addr == MAP_FAILED)
+	addr = alloc_isolated_mem(pagesize, pagesize);
+	if (!addr)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	supported = check_vmflag(addr, "sd");
-	munmap(addr, pagesize);
+	free_isolated_mem(addr, pagesize);
 	return supported;
 }
 
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index f19bd17817e5..ce1da9a55310 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -95,6 +95,8 @@ bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
+void *alloc_isolated_mem(size_t align, size_t size);
+void free_isolated_mem(void *addr, size_t size);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);

-- 
2.43.0


