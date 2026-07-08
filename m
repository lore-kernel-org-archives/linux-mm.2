Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1744C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3CB6B0092; Wed,  8 Jul 2026 05:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB2E6B0095; Wed,  8 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D12A6B0096; Wed,  8 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 539D06B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:34:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D05E91A06E5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:34:49 +0000 (UTC)
X-FDA: 84965099898.04.17B08E7
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf20.hostedemail.com (Postfix) with ESMTP id 001141C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:34:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=DDP1QmsH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VVnbUFBm;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783503288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=354C8DBsR7lF4EpLDAAJWqKRblHNIMZkSshlcNBNqWs=;
	b=6qc7DpqboxEC4R4UgQTe0r/545PKCo1ndlrGqcD6agErEOOH0Y1T8kjzOF5/4S92YmE4Wi
	z6aCeCpMZUVgvEcxkmYJ0oNMtqjtOom3bTyqo266FbZUdL7Rnir3TP3HTopd9Rsuq8tD/y
	1GXYxuN9YhvWH8mj9+9OjjO/QPkiJ4Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=DDP1QmsH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VVnbUFBm;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783503288;
	b=umd9gdZfWU2JlrB56sVnKrFCz2YoPr4UaGQ80Dm3WliLQqDYxsV23EiOoKkjTxt+rgAbtb
	9dYs2hLPBolpKk60RhiiitT8HztsC5dgBQnvoxdbXOTu1n4PPbKXR85fS+meLdeeAHSAGZ
	CrFkjGo0OokBxcWsTotldd6/RLByq+M=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E085C7A016F;
	Wed,  8 Jul 2026 05:34:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 08 Jul 2026 05:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783503286; x=1783589686; bh=354C8DBsR7
	lF4EpLDAAJWqKRblHNIMZkSshlcNBNqWs=; b=DDP1QmsHSKXfn+JLx1agr/0Br/
	A+F/4v6HskCmvd2Eyg5wDuy57ZjuCMMlzBbAyffSZeTlVrPrQVwPibdh+6kJUpo6
	dYay1yDzhbngbTo8Rsst1g0aHWR8I2CPgUt+67vYK+/0NS3YeoKTVny+l8L57wmE
	E5KOMVE6t2tPFdbybzkLJukRVl9BQsgJhTxRzPyELZhm158E2iGfaHS5NZUZNpzn
	80H5SCg/VQGd/JObaAFRsv9tp+Ed3DbjpIa4Bz9Aqp/AwN81FLrtRV/R7UAECVab
	PrzYeOzueDC8zx5Ly59ZnUsXtzMKC7lhUFNDG9a78NIpo6rnG+rlBl1gV6xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783503286; x=1783589686; bh=354C8DBsR7lF4EpLDAAJWqKRblHNIMZkSsh
	lcNBNqWs=; b=VVnbUFBmvmynrC163RNbdyGqOsznuZJig/23T+WeDM/mjlSMF6A
	nN/TJxSOs8VORjUDpvSCz5LQr9oT5RsDK3eSLYEVhyiQ9rdmGlfTdmrVOxE5/A7K
	1jPzhaNhg5SeoGXbwyHC21uwr7TRE7MItYqBv9cKFPwLEgACOP5Pn0JdbcJHBCQZ
	BJOxjIZTF39W10BEskVm/88Rt2dMqS8Peg0zPToiyZRVu3qBHb2gl/OLJQ4ZBL00
	lyYBPr+blwbLucwW64p86wGAFfV7DEea6ok3HWs9rpkbZoyH+DWULAg5sGNn6SWm
	L95TA3btdxfq7eHsW3L13o6qFO0aFasMusA==
X-ME-Sender: <xms:tRlOaohLueCyGgg-gIJURW8Cdn_DrAinYwof4vuDK5Q36PmvnbsDhw>
    <xme:tRlOan-2BM9bsXgAFXbKED1YJIZcKjA9h52FWzIhnW4Nh4SsRnlovKDP8NoPg0KUV
    mmRCdOZv_kEojXOfSi4Aheu_FWmaC6bptawN2ojBmAp_yCdYjN-wRJS>
X-ME-Received: <xmr:tRlOalIg-3EL4QcLpQcm1Po4uOflLkinBjuzFdeFxpXz3DbFEDIpDfv0vOjg2Q>
X-ME-Proxy-Cause: dmFkZTGULlKgltsBsg1+Gkf5WdAiwxiXDitmE7/sdEIta7s7Oo3eqRsLH4S/mjncebxwRa
    ZYAO8ntGqM7qKllzMHbJtsYbhHNGvLryo9pRwYkwcxImXh2E/Jx1iiKBCbvnS1nBpa7aog
    oIhqm7fzmz6L7PkMEgLVXaPFmx4u1aXn8I5/z17/cXbd08ie/mxiKrD3XUaEtslYZ+VYpW
    RV/dHfpjb3ztmmD83Lw7kUv/rLHqW3jXBoN2ATNGg6KVIepMybVHLQV08XTJCYKIdR/1As
    nDe/9GsxHmmg+GGmva+HMeWmsC3i7RL07p4pi8Itc5SE9CBuyfg5zUn7Sx3k34NO6S9Wkb
    WfQiBYbS6dRJdMNF/2IKvZW267kCHTezGJnbTInJNnvNeLcD4npAVpJ8NsEwrc/A2XsvkO
    wF55pCrephlyAVW8I5g4q9TylrIAuZs6weZ4WJTL/i7Owg2k3ImqvTFqC+ZZU463DSai0R
    NcScZqBAVRb/oArOEkd/Hsl/VjFftsqqJWLNRKX+SpDz8XcOEZiYZXQyH8pUk79Kcr8eba
    nalYud8HhW8gIYwXonLK0EKsE1KsnPSZ/jUkvnpGa7hTtwGABj8U2QBRz6csTQ4tHFcu/q
    L9GQdOzNCYYbzqgX6BHCf+PBfwKnlIWDLWHCc7U/aUKHowq/z6pZs/4PMfpQ
X-ME-Proxy: <xmx:tRlOaganRDOo4bWmuWWMT1B7OWrjyAz2lrnpb1gH4-7otSNzqLelSw>
    <xmx:tRlOagh2McqZiEO1xgALwFW-y63b_fG1MLI0Kg906Nqg_0hv_Pj2Qw>
    <xmx:tRlOat5ITMPKcUfQBHUpcTLc-CTQPz-KYvltZ2Mr6dqJywxLeP0WTw>
    <xmx:tRlOagrD5pSI95arKBK8wXc9KmuiqH8inwmP7nP66vCn-BiU2NZHgg>
    <xmx:thlOapVcPNmQt3Zie5hC76MHY4Z0pmbUg0eHkhiZW2Iz3ECc8ljU5CfP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 05:34:44 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org
Cc: usama.anjum@collabora.com,
	peterx@redhat.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Wed,  8 Jul 2026 10:34:44 +0100
Message-ID: <20260708093444.145566-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 001141C0002
X-Stat-Signature: jwsxxn364fuz36zuc1y36ywr88pcdnqq
X-Rspam-User: 
X-HE-Tag: 1783503287-815448
X-HE-Meta: U2FsdGVkX19q34kjBH2hPgWC4eUSNIPpbOEAVkXdN6Lk5cTulhWOk/7bg09+fD4jMc0RKZj11LDUqr5tYLGg3OXWHu8kinMA2q2SD5860Q8FxbpnDgeVP+EBj7+bs0s3IewVxpfcZOS8igS6llyhFZCkL2lwGcTZYkMI2C1H36iIIZ3QE86estph9Ik4oj2xbh9UJd9QbwL+naiK1IQ1wMMS+ZWMpTFg7VVC94L9bAt5Fpjp+kxn62r3pJ271cLxR7ZP5virjarQQm3lBMxTTRXwwKJqoG8aGCXGkeaesrgLku4B+G6oI1+/Stet+HnocwQuykw4sFujqaUA86+d1+Ju4lV9sN8nT0D2hopNrfsFa5RHo21A66Ry69OX6F/3l2Zyk105yE9YIIN5KH1scRV1S77L+E8kei6sfHdw6SQ0C8Hsg4fDNQRCVVRZ89zmu7spYYJboETm3zIlVE5LVY3dRydeSnY52dsXswvD4yRiI7ZQaBOmIvEH4D/PNFv6oXeYUfM8LZlYr8uyWFa2Jt9hz8KLImC7ndDzLP3s3NpSh/7EZ3n27f/of9ucAJFWmzQVsue9/J2euWgHey4oR+28mrJLaLK7PXQ7Bc/fep3EVKyvgHPIqQPahnCNtYufCbt87HultD+igFQhFOHEmXaXCcOxPKGqqmJVEHizEu3I/G4ReQlJqblcmneWqIxA9+BrVoRyAP4kdjEx1JZI6xDbDPPLNjZLk8wHwsaBAS8+k6r21doz/VG5v6uTLtkElYOU/yYIv9MeYI3cKAwJbeOD0t4yvckZWdntKj4zINhy3RTnlMwWlIkYqyWmmJOljJNHMJQZ4Qu5e+t/q9ABe80aijStIcKN04YBc8Teu6ojWvJSe7ySftYtN8QCh6n5oBoT5bx7GU2/9vMjVJwHA8t5O+Xd3BJOTS4Aq2lLMBajjSgiZtEQfLdNXmHjT950nTO6mGcTA57NDQfpj7g
 4dzPigvY
 UOMXZd5akoJ0EhhWT8l6s9wlAhbKRHWYWJCdYbOcGo2rhP3W3wrheQt0kq8AaUHlJwz0+fGylkh6KF1rMywp5ngQorO6VKnEbezzjU+GxX/4zHxboNgEXSgfVrLgmi00nSoIWaP5VGwrA9wYSngLbZD3MaKldLXiy2uY+e455WFTOeIRJe9BaO5Rok/YsWlDSMcnA3Ki2S14yKhehn1oV91LTHHSthPUBi6G3U6ltuJeVuvFbIPithH48CkHuPo91ZXW/G/KYhIJOBGpsvLQ95IO9EwfUQdW+8wmJHxv7ynlDge378CLEBGM0k4cZ+xn4PTrwQUZD2sAKcSBpAmjRs5jxPgOOTObp8+d9R0QueduojoxI/aF7c9U0ttXxqVMGGarQ5dDR9XuZy9COJeBNDSLImGXTYVWqpuhS5bBZ+pvYzs6D2Ty1SvGqrLXk4oc8Atro4Q//tL/8azMSE+zK0oprJwdfTmgf6MVFlx8lMlmfWN3Qkw8lUlLZkaJnvTeZ9PYhas3jCG4mzyTp18XSfd85Ah4pwFdn7MUpFdPv+nBumQgtLOvHVoDY9lSZFE3nGJGRl8YOT3dGgNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written
(pagemap_page_category() and the PAGE_IS_WRITTEN fast path), but a range
with no page table at all -- a PMD hole -- is skipped.
pagemap_scan_pte_hole() evaluates the hole against p->cur_vma_category,
which pagemap_scan_test_walk() builds from only PAGE_IS_WPALLOWED and
PAGE_IS_SOFT_DIRTY, so PAGE_IS_WRITTEN is never set: the hole is neither
reported nor, under PM_SCAN_WP_MATCHING, armed.

This is reachable. An anonymous THP is write-protected in place as a huge
PMD (change_huge_pmd(), anon is not split), and a full-PMD MADV_DONTNEED
clears it to pmd_none. A WP-async consumer such as CRIU then misses the
2MB drop -- the range is not reported written and the next incremental
dump keeps stale data. (A file/shmem THP is split on write-protect, so a
later DONTNEED leaves a populated page table of pte_none entries, which
are already reported; only anon THP reaches the hole path.)

Add PAGE_IS_WRITTEN to the categories evaluated for a hole in a uffd-wp
VMA, matching the pte_none handling in pagemap_page_category(). The
existing PM_SCAN_WP_MATCHING path then also arms the range:
uffd_wp_range() allocates the page table and installs markers under
WP_UNPOPULATED, so the next scan sees it clean until re-written.

Add a pagemap_ioctl selftest that forms an anon THP, drops it with
MADV_DONTNEED and checks the resulting PMD hole is reported written.

Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---

Follow-up to the pte_none fix [1], which is a prerequisite (this touches
the same pagemap_ioctl selftest). [1] handled populated-then-dropped PTEs;
this closes the remaining anon-THP PMD-hole case.

[1] https://lore.kernel.org/all/20260707151349.92143-1-kirill@shutemov.name/
 fs/proc/task_mmu.c                         | 20 +++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 60 +++++++++++++++++++++-
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d45c729ab6bb..6a4725ecb780 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3049,12 +3049,28 @@ static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
 {
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
+	unsigned long categories;
 	int ret, err;
 
-	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
+	if (!vma)
 		return 0;
 
-	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+	/*
+	 * An unpopulated range with no page table -- e.g. a 2MB anon THP
+	 * dropped via MADV_DONTNEED, which pagemap_page_category() never sees
+	 * -- reads as written on a uffd-wp VMA, matching the pte_none case
+	 * there. Reporting it also lets the PM_SCAN_WP_MATCHING arming below
+	 * install markers (uffd_wp_range() allocates the page table under
+	 * WP_UNPOPULATED), so the next scan sees it clean until re-written.
+	 */
+	categories = p->cur_vma_category;
+	if (userfaultfd_wp(vma))
+		categories |= PAGE_IS_WRITTEN;
+
+	if (!pagemap_scan_is_interesting_page(categories, p))
+		return 0;
+
+	ret = pagemap_scan_output(categories, p, addr, &end);
 	if (addr == end)
 		return ret;
 
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 550d1f2c059b..c0e45d0f7478 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -25,6 +25,10 @@
 #include "kselftest.h"
 #include "hugepage_settings.h"
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
 					 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
@@ -1102,6 +1106,59 @@ static void unpopulated_scan_test(void)
 	munmap(mem, mem_size);
 }
 
+/*
+ * A 2MB anon THP dropped with MADV_DONTNEED leaves a pmd_none hole with no
+ * page table, which pagemap_page_category() never sees. PAGEMAP_SCAN must
+ * still report it as written on a uffd-wp VMA, via pagemap_scan_pte_hole().
+ */
+static void unpopulated_thp_hole_test(void)
+{
+	long npages, written = 0, ret, i;
+	struct page_region regions[16];
+	char *area, *mem;
+
+	if (!hpage_size) {
+		ksft_test_result_skip("%s THP not supported\n", __func__);
+		return;
+	}
+	npages = hpage_size / page_size;
+
+	/* Get a PMD-aligned range so the range can be a single THP. */
+	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));
+
+	memset(mem, 1, hpage_size);
+	if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
+	    !check_huge_anon(mem, 1, hpage_size)) {
+		ksft_test_result_skip("%s could not form a THP\n", __func__);
+		munmap(area, 2 * hpage_size);
+		return;
+	}
+
+	wp_init(mem, hpage_size);
+
+	/* Drop the whole PMD: it is cleared to a pmd_none hole. */
+	if (madvise(mem, hpage_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	ret = pagemap_ioctl(mem, hpage_size, regions, 16, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		written += LEN(regions[i]);
+
+	ksft_test_result(written == npages,
+			 "%s pmd-hole reported written (%ld of %ld)\n",
+			 __func__, written, npages);
+
+	wp_free(mem, hpage_size);
+	munmap(area, 2 * hpage_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1610,7 +1667,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1847,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_hole_test();
 
 	close(pagemap_fd);
 	ksft_finished();

base-commit: 9795ad96d277c4af049fe30de1cebd4e39d7bcbe
-- 
2.54.0


