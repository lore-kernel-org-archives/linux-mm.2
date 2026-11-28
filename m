Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FFB606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=pbe93rMo
Received: by kanga.kvack.org (Postfix)
	id A81736B05B0; Sat, 28 Nov 2026 01:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A326A6B05B1; Sat, 28 Nov 2026 01:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948086B05B2; Sat, 28 Nov 2026 01:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E66B6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:36:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 611BDA060E
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:36:27 +0000 (UTC)
X-FDA: 85483568814.28.5E8A927
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 869C4140006
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:36:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pbe93rMo;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795847785;
	b=1gmJOqenvW7hWxaPxaD9Xdy/eIxRF9KQk62jKHXH//47ZgWATzxZ/pQXWyPLq1tkwO45/K
	JTRC8LYwJqb5wpWdB4Zf37WuuT8Exc06wIK8TD3G9ocXmKF7/KsaJ0/3Z11l4TxZnpU0QE
	LFDnO0LfofQi0bksoHWnbCNMast/Syw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795847785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n9roixnfIFYGSNY3LMoNE58r2H0x9JeIG09TUUKABSI=;
	b=6iGOLY0fh9fEPThbPQuJP6cPa6kv+HkVRliTaPWH4i+bxJ/Sx67c+zG4j1MGHTznAVozIV
	xH+nMl8uLV8GCcBaVlYRKm0LJPC209e61l1fWxOOgVWxpVZHbYngxHS1nJx0dh1nqYAgcV
	ITs0ryJc1wmJaVgaT03bBX+Diqwdw4Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pbe93rMo;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=n9
	roixnfIFYGSNY3LMoNE58r2H0x9JeIG09TUUKABSI=; b=pbe93rMoYYlHSA8n9S
	uee3LDCMVLphX9GkzTuTdf2zQxWKHNqJS580d+bSgYplBXEYbBaDU/0De+OSSUXJ
	qbaetvBx9+TW7cGdGU6Gw67/jOCT8GpWMR3pTABvzYdu7HMTjI9wzXCW1HgCKEbU
	+Pq4Q+INwbumpBLf3FKGz5b2g=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3X_Bjdgpr7k+nLg--.44267S2;
	Sat, 28 Nov 2026 14:36:20 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH] lib/test_vmalloc: check vrealloc page counts and data ranges
Date: Sat, 28 Nov 2026 14:36:08 +0800
Message-Id: <20261128063608.3434982-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X_Bjdgpr7k+nLg--.44267S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GrWkXw1UGr18try7JrWUurg_yoWxJFWfpF
	W3Jw1vyFWrJr1xXFZ3Krs2yw4akw4kKayUGrW3W34Ivw15JrnIkF93KFyFvryIyrWkuF1j
	9r4qqF45Cw4DZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeoGQUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbCzQQU-GsKdmTzFgAA33
X-Rspam-User:
X-Stat-Signature: 58hy4xp3a5e4ppzq1wd5b7rf3ynmodcs
X-Rspamd-Queue-Id: 869C4140006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795847784-677116
X-HE-Meta: U2FsdGVkX1/+H2HbGwUrCr3F/ndg8VqDLAcX67I0TjGTiyxCg1FlOSwLQ98MJi8+CPp0OvUiaPibOuz8TFXAgJRKZ+nBXIGi1t3GKa3Q5QlVwffLLQRq0B90U92BlSpVxqvQP9F2FJAuuXDxcdB5fPo9yQHSILL2PmikLCPOimqHQ+lKbhC46Pc4BYiAugHxkHYkg99lcQUgAvZQ8o67nfLCMrFJgEEKLzdsomlsq8RBxyNLiJ2sVVl9xhyMX9OspLXUvOAgcyYcQbW/1Ff8Ph5mAKuimCFIsHBdekP9hQOQVlK/ap8U/Yr1F2HtoIPQ/LRuYccdHMVNEerOFS67MHmkl2iNpSpVHa5X5ZRk8220izjs8d0ZTffDWlmflZNIiW11aql0XfSjJ1diLBUGpwAcgby/Jso14Em4ZvFxlVf1Peafsy8PDXjbcqW847dpIDM9M84AI9sdkvlh3cFLXw1GFbqRuPd7Dutt0Qg1AfrdiHtSTkYnvHOTbMyZ2YpGnIx0zWkqILm387t5j/OZkv5GwU91QcW62nNBAVY7t3QWDQ8HWjahdbkKQGhGr3mA2ookKREB4TxKb3loi1KGQfebQho6gi+jyrhyHL47wXnXSs7P/zga0wBjRAMaYmZVBdQisSp0CB2Wjg0P/xEWK/0Cy5wzyDyeYzLxayGJc1a/+4AWEJC/Hqwjh1D7QFDu5zR/+UP2HWSScvQUdTUQ/cd157JGKGTuzSEaw5L5JQv4P/FJ1RosJW+yiRZkTifhHfruy1UgafUY4S5K/8crb9oprbd/g4UoCK/l0QpCaYmG1AbOlyGLDdH+BFZ4z5EiUCHFqfz9gacs+dBHV7p6Wij3lJrOfOAitn21dns5MUQ3Usl526K2Qat9BDcV84oNnfFmOBx8x5KIlKBx21njKQ86hooGPb+2cpjXXuWzcJb79aw03isucZgTmIpt2FR0Gw8i4QdZhdGQumnm0/H
 oXB0hOy7
 Khf5KA5PwzBd9/+cwlJ1AVVLkzMbT6V/nUai53K3GB6s8Wbe1jyCxOIv6iTxKftf3uW4DSkSkWbfsWPrLNIxil35A/jbLCTd35E3Xv40Yix4bBM4+IkJZZ8hBX8mO3FdpCAY7Uy9Uj+YacqWmRtIKytT8Sp8lCAWOjHUxqU7PN9bShxNdotUoEsyPkkdvFmGM0GXginpQ7plwC7X7U+UGxDA+27AJbGVZ73Mq1boE+bhQpi2g1SLaIZk4swSzaTaEEr5UsuGnoIzCkz4tt8M6VYv+0c47cqy8/SyV0xk8GJX/k3RAjdS453R97uy6PQDsbrdxiAeDWOvgl+qGPiN6vkxe3DAsJzIfcBDofi8wuiwJC8GKwCZZ5myu/L2aXf6tf6iB1Q+JeOfpJPwhgkRnhUYYXxL3TZWpWJyALjDQS8k7OA54knHsWFwZdo8agbtguodp7D3QiZDemoDdvRhmprY0cq1c5B9kd12eWbnnHU/xkV1R6/aDXsPM7Hga6wL/9R/7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

The vrealloc test currently checks only the first byte after each resize.
It can pass even if shrinking retains all tail pages or a later byte in the
preserved prefix is corrupted.

Check the backing page count for the ordinary order-0 allocation path and
validate the entire preserved prefix with an offset-dependent pattern. Add
a non-page-aligned shrink and a grow beyond the pages retained after
shrink.

Run the sequence both with GFP_KERNEL and with __GFP_ZERO used consistently
from the initial allocation. In the latter case, also check that each newly
exposed range is zero, including when growing within a retained page.

Export find_vm_area() under the existing CONFIG_TEST_VMALLOC_MODULE guard
so the test can inspect backing page counts in modular builds as well.

The additional resize operations and full-range data checks increase the
work per iteration, so timings are not directly comparable with those
from the original test. When running vrealloc_test alone, use a smaller
test_loop_count, such as 32, to keep correctness runs short instead of
using the default million iterations.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Validation:
- x86-64, 4 KiB pages: built-in one/two workers and module two workers 
  passed, with three repeats of 32 loops per worker. Every loop runs
  both GFP_KERNEL and consistently used __GFP_ZERO sequences.      
- Private x86-64 mutants suppressed tail-page freeing, corrupted the
  final copied byte, or skipped shrink-time zeroing. The enhanced test
  rejected all three; the original first-byte-only test passed all three.
  These were artificial defects, not discovered allocator bugs.    
- arm64, 64 KiB pages: built-in one/two workers and module two workers
  passed with the same repeats/loops. Guest userspace checked the actual
  page size.
- The same arm64 matrix passed with KASAN_GENERIC and KASAN_VMALLOC
  enabled. test_vmalloc.o contained __asan_load/store references; full
  serial logs contained no KASAN reports or kernel warnings/oopses.
- With TEST_VMALLOC=n, find_vm_area has no export in vmalloc.o.

 lib/test_vmalloc.c | 104 ++++++++++++++++++++++++++++-----------------
 mm/vmalloc.c       |   1 +
 2 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index b23f85e8f8ca..420b4bd5bf2f 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 #define __param(type, name, init, msg)		\
 	static type name = init;				\
@@ -422,55 +423,71 @@ vm_map_ram_test(void)
 	return nr_allocated != map_nr_pages;
 }
 
-static int vrealloc_test(void)
+static void vrealloc_fill(u8 *ptr, size_t size)
 {
-	void *ptr, *tmp;
-	int i;
-
-	for (i = 0; i < test_loop_count; i++) {
-		int err = -1;
+	for (size_t i = 0; i < size; i++)
+		ptr[i] = i % 251 + 1;
+}
 
-		ptr = vrealloc(NULL, PAGE_SIZE, GFP_KERNEL);
-		if (!ptr)
-			return -1;
+static int vrealloc_check(const u8 *ptr, size_t size, size_t preserved,
+			  gfp_t flags)
+{
+	struct vm_struct *vm = find_vm_area(ptr);
 
-		*((__u8 *)ptr) = 'a';
+	/* vrealloc() allocates order-0 pages, allowing tail pages to be freed. */
+	if (!vm || vm->nr_pages != DIV_ROUND_UP(size, PAGE_SIZE)) {
+		pr_err("vrealloc: unexpected page count for size %zu\n", size);
+		return -1;
+	}
 
-		/* Grow: beyond allocated pages, triggers full realloc. */
-		tmp = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
-		if (!tmp)
-			goto error;
-		ptr = tmp;
+	for (size_t i = 0; i < preserved; i++) {
+		if (ptr[i] != i % 251 + 1) {
+			pr_err("vrealloc: data mismatch at offset %zu\n", i);
+			return -1;
+		}
+	}
 
-		if (*((__u8 *)ptr) != 'a')
-			goto error;
+	if ((flags & __GFP_ZERO) &&
+	    memchr_inv(ptr + preserved, 0, size - preserved)) {
+		pr_err("vrealloc: nonzero bytes in newly exposed range\n");
+		return -1;
+	}
 
-		/* Shrink: crosses page boundary, frees tail pages. */
-		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
-		if (!tmp)
-			goto error;
-		ptr = tmp;
+	return 0;
+}
 
-		if (*((__u8 *)ptr) != 'a')
-			goto error;
+static int vrealloc_test_flags(gfp_t flags)
+{
+	static const size_t sizes[] = {
+		PAGE_SIZE,
+		4 * PAGE_SIZE, /* Grow beyond allocated pages. */
+		PAGE_SIZE + 17, /* Shrink to a partial final page. */
+		PAGE_SIZE, /* Free the remaining tail page. */
+		PAGE_SIZE / 2, /* Shrink within the same page. */
+		PAGE_SIZE, /* Grow within the allocated page. */
+		4 * PAGE_SIZE, /* Grow beyond pages retained after shrink. */
+	};
+	int i;
 
-		/* Shrink: within same page, no page freeing. */
-		tmp = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
-		if (!tmp)
-			goto error;
-		ptr = tmp;
+	for (i = 0; i < test_loop_count; i++) {
+		void *ptr = NULL, *tmp;
+		size_t old_size = 0;
+		int err = -1;
 
-		if (*((__u8 *)ptr) != 'a')
-			goto error;
+		for (size_t j = 0; j < ARRAY_SIZE(sizes); j++) {
+			/* __GFP_ZERO must be used consistently, including at allocation. */
+			tmp = vrealloc(ptr, sizes[j], flags);
+			if (!tmp)
+				goto error;
+			ptr = tmp;
 
-		/* Grow: within allocated page, in-place, no realloc. */
-		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
-		if (!tmp)
-			goto error;
-		ptr = tmp;
+			if (vrealloc_check(ptr, sizes[j], min(old_size, sizes[j]),
+					   flags))
+				goto error;
 
-		if (*((__u8 *)ptr) != 'a')
-			goto error;
+			vrealloc_fill(ptr, sizes[j]);
+			old_size = sizes[j];
+		}
 
 		err = 0;
 error:
@@ -482,6 +499,17 @@ static int vrealloc_test(void)
 	return 0;
 }
 
+static int vrealloc_test(void)
+{
+	int ret;
+
+	ret = vrealloc_test_flags(GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	return vrealloc_test_flags(GFP_KERNEL | __GFP_ZERO);
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f7aa4686fe5b..a0ee9dc742de 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4220,6 +4220,7 @@ void *__vmalloc_node_noprof(unsigned long size, unsigned long align,
  */
 #ifdef CONFIG_TEST_VMALLOC_MODULE
 EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
+EXPORT_SYMBOL_GPL(find_vm_area);
 #endif
 
 void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
-- 
2.25.1


