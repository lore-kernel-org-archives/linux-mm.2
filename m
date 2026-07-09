Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5308CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230A96B0093; Thu,  9 Jul 2026 08:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208386B0095; Thu,  9 Jul 2026 08:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8206B0096; Thu,  9 Jul 2026 08:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D39696B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 607321C6DE6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:16:34 +0000 (UTC)
X-FDA: 84969136308.30.23BD0C8
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77912140008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:16:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=RaOb4PrC;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VawiVj7X;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783599392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hEK13WQWeA5ZwXQid57FnwbvuSZ4wKnTcJfZBsCwn1g=;
	b=OaKBN20LGCzixPiUsP15EO1yiEhG5pfg11vqi91dO/Q2mKfMiT6W4eMXZ18+VMk6uGK5fR
	thxvQBNpD7yBiMP0rwQ9PGFfsE4h6G6tCGwLoCcDn1a0FqKHug8u3wdtvkNitPDgA5BZGp
	rN6xhYuKnXDviuLONvM+InfFTKqbgRA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=RaOb4PrC;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=VawiVj7X;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783599392;
	b=FXJzvxeMzmbkFjObay6lgYLQ35rwabad8B5YY5fv54xNlPUSQJ1qCsuS118rEYe29n/P9L
	A6uwausL3Sef/tU9o/sF5Kl9ZmXC2QrMyFfpSc+ZwQj8/c6F4xuXkKWv348kekFZN9LVLq
	ShOJkyMfh1WwhT7eIuxh0ONK8d8YRM0=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 68A607A00AE;
	Thu,  9 Jul 2026 08:16:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 09 Jul 2026 08:16:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783599391; x=1783685791; bh=hEK13WQWeA
	5ZwXQid57FnwbvuSZ4wKnTcJfZBsCwn1g=; b=RaOb4PrCyjy7SpIM8G6dbPD1su
	cWCIM58P9O1ioUagMnuYs0qg6dOaO2ORYxlDcXyBQH1g+cXH6KDuc3ifwhq/UdcL
	4vHix+g3h692IXoYv4FHNcgcwccN5O6s+j9gnwfwRFxMmGFRnGr4pDrcgVc39iuU
	jmH+yaDh8iXUqg1bqsOySZeCnKpUrkTwK7s+aF362URcIJk0aORpeOhl08FxkCBf
	4dvCcgF7FnxP+bSE794OV6l8cDNF6lftJ/jl/tCmxuqqL+CMskWVRb1r1a7Cgyi0
	ATdafHZFGperFQPd8jfyC5Qhn3HLJqZx1+/wGEClG4Ut8oR9eMJaoK4DRaLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783599391; x=1783685791; bh=hEK13WQWeA5ZwXQid57FnwbvuSZ4wKnTcJf
	ZBsCwn1g=; b=VawiVj7X0FHuqwIxai9RfnMk/O3DyvqxhrWY6R4UENVayH+fNPk
	fgTCjdpvm3SWSVxAyTp4F84zCAkC9nfeM9YsNXzNg30jbQyFVSnl+yFha2l0EIqI
	reIijW1qd1PjyuAUUkmg8XkKDARvPqv6BFEg18qKsnDZamBBPZ4dRIFEPcXncfuC
	OYuHV4m+GZNwkNBnftuF1bHgXyfSDj17H2+F5nIDtCG6MjRIeXdKbdT584NOU7/o
	MXWNUV3g7CwuIzUsPD5pxDaAXBpqARzIp66tsL/pRrL5+AhE+lQjGSgejp+uXAc5
	FMCtUwhP4b5dDm0u45d54c9pEpoj0QVqRKg==
X-ME-Sender: <xms:HpFPalSZp4DLZjZjLmlfXGrkWJK7Wd-E5Oy9BXhPTzNs4DfcY1Cd6w>
    <xme:HpFPalsecaEyh2ctWJ8mv1Rd1msg98gC6GyM7AU0sTfUov3NJhK_Uux47-LbA0nkB
    G_jsaCKWEJ06rcs6agcIpVWfrnpABEfhBkdDR90p3HLY2H67ECVyNg>
X-ME-Received: <xmr:HpFPav4AQ_ZGamdCHcGkU5a13wd1pX4aW1oxuD_jp38sUl3ppatNeHTGfRhcBw>
X-ME-Proxy-Cause: dmFkZTFnh0a4DmHDBAHfJT6epMK+/J3A1HQhCntMiAF0QwbbbcPW8f71gxvjyIJwQP37pS
    BFvjCsK8ULXrO/FtdkuprFHp6cb/XCg6cydWcltNhUI6oLT1nd2AnziV90SYwWxfExly52
    wu+542vsAzOeVeCwMVs0nV4CNiTBAI3kRd4E/9ansCVIoDeuwGDBipM1I16+p2LN82OKzR
    MjqUSVS71MKxK3REj3IRTT1t6VBtI7aoyg8AJcY0O30w7nZw28IQ1+dBAmKWL8L3jk8mi4
    ggx0Q4e0IErxk7B8EQ7SgXToF7hYnedW4eyCUhnwTn4k15B3wV7imE3v6WKbBMVPvAlxS6
    al6t/Ic676gaa77h5ZWvWF0OTBcMogaNAntC6DA0j4QBsvxVYZ3tlMPGT6eXpOHB2B1nR2
    ynYRL5hWTE13VlxYs08fQDwrBRGXaZ1flgEVeSPkXq5tJ9a3iyDriFH1ULsx31xgcXv7E4
    M64kp/pcsHk3XRJLOc1UXw4jP9roszvlwxMHT0vCCqVZbu5dBSnb5Lw4hgiS+1zUCeWtor
    JgkuCjKP1yvvSv/l9kMPEU+Mq3UzHuuXxiVT7HBXY6LUwrSW+OI2UhLFZAUP49YB4/Jizo
    ykA2JQVnbzhA432Jf7C8FSnSx4A/wfMJ9Wi7Cs7zwe13128zOvSyF2qol78A
X-ME-Proxy: <xmx:HpFPakLYSWA-AEiCX1d0jVBSy3t1bqwKtvpdBKgGGwPoVpep3EQJWg>
    <xmx:HpFPapRU8wru2OGFck22y3HgF2Pyr6mg8m5wFKeC_FjWBdc-527z_g>
    <xmx:HpFPanrS2RRG_c-JUNdpU9WHBxrulLSM_0JBKHMxjyA4wGI-pQhl6w>
    <xmx:HpFPanaCnJukfanbmjKE1ulX8D92nMRuXxKihUMpXI-WW29pwCCwJw>
    <xmx:H5FPahHxQFXpYdU1Be5xkso9GDOU9C5OHT7pWy1-taaO8E3tBXi36_Uc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 08:16:30 -0400 (EDT)
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
Subject: [PATCH v3] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Thu,  9 Jul 2026 13:16:29 +0100
Message-ID: <20260709121629.205562-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77912140008
X-Stat-Signature: 38cow8nr193zd3yrg6w1nnjaxq8onayt
X-HE-Tag: 1783599392-587473
X-HE-Meta: U2FsdGVkX19QtrHjqAsls4bhNXBUPXwXtcwv0IE0WeJ2ldV46fM+s3rYFiMQ+GdWs5zS3pWJi/42ethDNQr3ySRsN749B6a3sxdHQMnqHvkyDLjgVQYfLoYMFTfBM+FJN8O6Km5p6JgqYjwbwdWfIpIQM9AitaclZHny45xFA5xYBjpKp2evTdkZLCrOdq4s9NDuEfYpW0Yr2c5jPi8NYoNDj5ceOuhP0WslWevINZ6hmXESjFSog+HJ7Rq+KeC+cP5wb0R2TJ/oK9tVofPYp0F9x94r842d/YWLDBZR7ShNKSNAiVv4LwEBUIQWfCjPR0yHd+hsj12z6+WMMTMk/WQrCr4Rx64ELDyaYLDPLLB5TRl48c3HmNaG//olslOgK33JwpxgYSDdIKiXkg3CMiH/ZRlPAExX0027YD0OQzvV4HQv9G0trdnJD80snnYvw0RaAjBgOkfRPGFiWPtALVmoQjOSAueKttd6dpcV+QiXIs/kCvAvU+Z+uohYE9pGQnyr0vTZnBOwggQJE8HM/7nqMuzqFSpai5SviqOSJcsu75/l0zmL1jhpIchjkE0hQxhwkwTgzYIVg59lF5G852r4ynbagg85r4FY8L5QMlQBPBzth1w5sUitcniVrn5EatWBH+H1UpfsWqyb291aJ/8uPpJY6MtGwIApuS0aoysl6vKHxL/qDoeDCdDQbo0rc0whc1QS0XgMRE87ZkSt9NMeEZDsh9+XKsL3EvRn0m9STwyswqELPaSTAziGotuvlMDfOW1M5nsZFW79I+TfZ5IJjxjNg4r8t3muggSR0ozvwDblF7A7YJGjLo5k7dHmmTNPDZM6EF3pPTd3JekkZPESOE54nqwLJ1Y99B3TCqN90mi45YK6yu7xafhziiJpLN3e7wARIk661jlbVYUzdFn4wjb22/wluc/i9bmj0I0U29TS8SEsO1NYCz6QcAnMw0PeDe6AJrDjsWhdyPR
 D/iW/KqI
 ZRLF1+17MjZflAJKpAvzmma8ASIFo9rJmYlG0Wb7HKkaoYOwb3Zu4hYggKF3uliauM/jnn9hVWuGm9xGa+62aKxhCXHMMIh7PR6QNxs7pU1/zk843Zotm3mXkCO3SYhIXrcVTxBD6/KVE3xIZiaKvTvAFE1yvy9mQyXv5Yvou2bQkMFFC0iYdYsRHvdIHUizky490x9fEDYBKw2UB3P6ue8YtaiKfZ4HzvkVixojvB2jdvhb7LnVEGJg5gJWuIFDqA8ZnBgYJ+ymPoP2kzGpT0Esk3/qSmRa8NP+L5OjPvqT25jBcpqlueJyrN8YD8rFCe8q6WQX55DKSCklfxXPXz3zlvbHw4B8PKRZ7tCqEmfnjzlTbHizA3KL7+tVWcDylt8xCOLarVo1TVzvLUGqc05TekIx3DwzxePD0umTyUgTRlE3VBgDlzsdPwI+VQw1UpyN8oFN8aPjTh8MDr7xBwwOXyG2NmzO6SwWBllOpm4heXNoqGlDYjDT37sOwrAQnyC/5BfdZqaRpWMl41qcv5nWoqEZVGiGaHzF2bLCVVvAapYerb9/xM5CrqQ1boy7fi84RgsLRIGMFKf3sOiX63B43HqIdnWovMzgjdq0BceqbzFYfuolg6P2gzb4/HLS6RbED
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but
a range with no page table at all -- a PMD hole -- is skipped:
pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
PAGE_IS_WRITTEN, so the hole is neither reported nor (under
PM_SCAN_WP_MATCHING) armed.

MADV_DONTNEED has fill-with-zeros semantics: it changes the contents of
the range to zeroes (a subsequent read maps the zero page), which write
tracking must report as written. An anonymous THP is write-protected in
place as a huge PMD, so a full-PMD MADV_DONTNEED clears it to pmd_none --
a hole -- and the zeroing goes unreported. A write-tracking
checkpoint/migration tool (e.g. CRIU) then treats the range as unchanged
and keeps its previous contents, so after restore or live migration the
process reads stale data instead of zeroes -- data corruption.

Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
pte_none handling in pagemap_page_category(); the existing
PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().

hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
which reports pte_none as written. pagemap_scan_pte_hole() fires for a
hugetlb slot only when it has no page table; keeping that not-written
matches how an allocated-but-empty hugetlb entry reads, so the hole and
the empty-entry cases agree within the VMA.

Add a pagemap_ioctl selftest covering the anon-THP PMD-hole case.

Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---

Changes since v2 [1], addressing Andrew's review:
  - Describe the user-visible effect: MADV_DONTNEED has fill-with-zeros
    semantics, so the range must be reported written; otherwise a
    checkpoint/migration tool (CRIU) keeps stale data and the process
    reads corrupted contents after restore. Add Reported-by/Closes.
  - Reword the hugetlb carve-out to rest on the category functions:
    pagemap_hugetlb_category() reads an empty hugetlb entry as
    not-written, unlike pagemap_page_category().
  - Drop the redundant MADV_COLLAPSE fallback #define; it is in
    <asm-generic/mman-common.h> and used directly by other mm selftests.

No functional change to the fix itself since v2.

[1] https://lore.kernel.org/all/20260708103429.150655-1-kirill@shutemov.name/
 fs/proc/task_mmu.c                         | 27 ++++++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 56 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d45c729ab6bb..03ead4184546 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3049,12 +3049,35 @@ static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
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
+	 *
+	 * hugetlb is excluded: pagemap_hugetlb_category() reports an empty
+	 * hugetlb entry (huge_pte_none) as not-written, unlike
+	 * pagemap_page_category(), which reports pte_none as written. This
+	 * path fires for a hugetlb slot only when it has no page table;
+	 * keeping that not-written matches how an allocated-but-empty
+	 * hugetlb entry reads, so the two agree within the VMA.
+	 */
+	categories = p->cur_vma_category;
+	if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
+		categories |= PAGE_IS_WRITTEN;
+
+	if (!pagemap_scan_is_interesting_page(categories, p))
+		return 0;
+
+	ret = pagemap_scan_output(categories, p, addr, &end);
 	if (addr == end)
 		return ret;
 
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 550d1f2c059b..560499eb4737 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1102,6 +1102,59 @@ static void unpopulated_scan_test(void)
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
@@ -1610,7 +1663,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1843,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_hole_test();
 
 	close(pagemap_fd);
 	ksft_finished();

base-commit: 9795ad96d277c4af049fe30de1cebd4e39d7bcbe
-- 
2.54.0


