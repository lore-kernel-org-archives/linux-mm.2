Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3908AC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 10:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08CC6B0005; Wed,  8 Jul 2026 06:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E926E6B0088; Wed,  8 Jul 2026 06:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D332D6B008A; Wed,  8 Jul 2026 06:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8716B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:34:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E137911B3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:34:35 +0000 (UTC)
X-FDA: 84965250510.08.E81097D
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31475180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:34:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=kIUtDK6S;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mMMCYaSE;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783506873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2h8jyIfaVxT1n76UeixMaq5PQ/5hlh5CP4XoQBQpKN0=;
	b=OKM9jwvxI46Em4zlxmIseeXruWBKyfYw0pBtabjtXJHyte8vSjncqHUxhhcy1aUiL3c9+S
	YQqOU4EkTfxXsxBK71F2rjrsvT2EeIuMb+mKDPGeZ7KpHkh8gsVyE2XhWfj61BGgPj+eHr
	XDYV00piJ5Jba/tFLTHYiqC/B+cimYk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=kIUtDK6S;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mMMCYaSE;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783506873;
	b=DcaN/H8wJ1ojJPGwUUgC0OwVKg9O+znV0fQNEPMscuecjpTnshVp/6Drhnga8GXGf2ldp8
	UbFOSPY6Tp6Zpj7MqZIp6kgmu5/M/8b9HPz6RHGAy5tl5r+MK7McIZgQyLwpnvnH0+G5pj
	5fmuETnGCfcV/XGJFtWT5UG803ozJAE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 000777A0118;
	Wed,  8 Jul 2026 06:34:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 08 Jul 2026 06:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783506871; x=1783593271; bh=2h8jyIfaVx
	T1n76UeixMaq5PQ/5hlh5CP4XoQBQpKN0=; b=kIUtDK6S2SV3BHIbHpNl7150il
	Xcjgv7aU6Ne6bpWk7peFRq8DpfiAEmxYjBzx/XXbAU2KgVnb+iZ1UbJ2eU5dtSrc
	fcefdE+1n0c+zBEvVir1GmyozLbViF414gqRnsIQcHU7sQLhbVQVSa4r44chvEqk
	4xftnLFdx+c1kEeUnHl5DD4ZwU3akEK3phC7EuZeG9NAsCyaOn6cVNBEZod6/CQO
	BpcOVEwAG7IDLFde3Snx6jebdnaE8pdgtI7qS04rAcS4wkhdrBu/8xytKsJdfSbK
	TKUXNs+EmH/nqoprbNafhoSFyvE7IUl6lix20ooD83w91KXIAI7+tKqRgfpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783506871; x=1783593271; bh=2h8jyIfaVxT1n76UeixMaq5PQ/5hlh5CP4X
	oQBQpKN0=; b=mMMCYaSEWrHESHn4kTMSGlkrX7InDtJHWZfYd8n2TD4PxeT8I+b
	VJGPpZl0yUjjURUx7znzca6Ddmk7KZrUT0tzigfm4qqqutBgDLuzVQpCZ8s+BNP8
	smDa47wzd7nihw9YiSMY7mdeDEnrpPoZiQeFrqtLI2aD82iXZirOl1qsrmt9EKaD
	6h4Xij7HHOQk3egZbQMoOtxydMIOn9LiZDVgYjrwuQqpfSMWqWRzy0qxRVj0iyEW
	oqbwchMkGXCwzeL/ZcM6P5eBY7bymWW3ujGm7mLrbzM8HjnqniJKI9s5qhvoJPea
	sM/rY2K0S+N3DpZhA9jNhUgozs9xVK2QzAg==
X-ME-Sender: <xms:tidOartV0wIEmIOf0xW-mAYOFIVHVU3Iqa7Up9AKyQA8bQu4G0bLWw>
    <xme:tidOajbgSFrrObj0ODgBCl0jv1EV_XrMCzLe6K_KpgyMZYUQq7GPrRmjNIEN7lst5
    M_VpBAA7fio8N7durg3-Mtk11GADrp3ozBsrcBE5VSGbmamU8TeYe0>
X-ME-Received: <xmr:tidOaj1NLyKGtfVtk3H-JYqehPwbSJ8c00zNDRb4H8fqkp-cQRCtDfAnhZf5Wg>
X-ME-Proxy-Cause: dmFkZTFi9VmUiW6GoSgieIDCNHZMP6Q4DB8+o7rZTrkdeg57rA0WNV4UEMbgfG0zqEFRUN
    bXrFMDzJDmZVhoVTGiGO/YRZN4+1ov2mMJFLC5jX/nlhFoDFmzTj8HNBkDkHBGBbyyKNkf
    xZyAkkud2L2K5Av8QUdjQ5XYi8pC5FMJ9A1ss/qdDvFmJlh+CQ6jFJwaNX0ej5Siij9oFZ
    cP0MKYvpt39/1cQ3CBE3x8ZOPmF/uGsecIgtn1+CV1GNHhyQ4cOMS01XDL40bu5rWXZprv
    BWtgM3ddnbRujsfBq+Fby5hiFsr6MLJ86Q8b7L7JJxrVIwGb0u9jFP9lAv+zowk++T7YB6
    HOp4mtnq70dVslAGbj3R2UOMUBNZYJPdTV0DnCz3sQCR0Ek0+QQxnRlIF3JB58ygEszI25
    p4oYA5aFORyfRBSBqv1I8QCaPHQPsfLaYbWOLk2WrRj8Y79U/KL6Nx/tsXtaMydAm9Tes5
    Mc1/rFgMwhq6lPUtSoiJpgHrFify7+Xbn+wbI+hSH74ekV6owJG2yDPKf7PDin/JadrBDa
    CCy2A3i7dD+EkUwWBamz61NVgNQCCLDmfhurQjHdOlK0YdpinJ79m3XCX999cNur+mPXji
    DuqIyzIZE1sjoMgFv/Fwp5bD2A/vxM0aPV9PThvHFbmin+zESmqICQg5mu9A
X-ME-Proxy: <xmx:tidOahXpekzdcOJWgMsRZQaihlEpSI84kMkNVgBSEc2QCHz6j74NVQ>
    <xmx:tidOamsQeS1_J8zdCYwbRdXomYM9AymNteYnMTnTj6V-0BrXlKLorw>
    <xmx:tidOagX3wYp3u8_ZPY3-tqCV2NjE0KHtChFS14L2dc320tsRm3TpUw>
    <xmx:tidOaqXzbJrykAwT5pEjXxVYvh2ZmPuDHw6-j9gZqiMBGo-CKJaomw>
    <xmx:tydOarwHV-PCon1kFV8UbIIIzFdPO9Y-Wi8ZAokZAu8erJB6G63gxMh_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 06:34:30 -0400 (EDT)
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
Subject: [PATCH v2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Wed,  8 Jul 2026 11:34:29 +0100
Message-ID: <20260708103429.150655-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mkjmxf6h4ypnxkjk653itoccgsnbphqb
X-Rspamd-Queue-Id: 31475180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783506873-210834
X-HE-Meta: U2FsdGVkX1/DF2XPQFklakoeXDbKWdXzF/Iwjn6ZdqK1LgtVnvG2+OFmOQHNyH1mZtD1mKN8OmN+tutZYQGNGP784LmLZLwsdsvtoqB/0JJHyaOiu6rFhuEkNciVD3KLB0jCY6guRSdKmI4HmkUIVzCIjdbglnDyshI23+jyYbU4fke5ye3DZdTY6EMm4mMQg48e/Gg8ZRdJq2LSbczW09EHP1E//xTq3j+yDt7kKKTUdxxOGYsJ0uesoqxqI5ekIo5I5HeoRoiKbEfl3wpdnUMNRFZBOJeoA+UQnx18tclrLMsnNskfZ0NNWFWBXGnD0efAFu8b+L/W3llwvMKRlbsgrwUgRoZeXGTyIIlr2QbqkB4YUVZqltX7HXBn1KBxh7R5Xv4WFCiMp4YvnCIdKH/tB7XN6A6e3iQq57W2MmUU4ltS6Ybz6B36env3IhYN6cA/qDnZcJRop95TeKWuzVSSnxo3TKgbfrkJICc1keXiFuTFf2voUHT3cjXQeK6S+uomOWJDcZ3nOw+8n1AWqQrThDlLAlqUgsjX+geGwzxgpMmd/JYdQHdeD72CzxIbzJb0qUe9/kdSM3mh796w7wXFnHWKcmPXL+Jx8tj71LUAi9si3+P6BorzXZfCPubj9NONBqG9saiQ0UHnfraNVTycSg9wp8qZ1BGHF53PjheKumoUvYTRC9dfjFjHseQsF2kVThtoauhBjYSIofiZ3w2NVAA6r9RU5ot63vl8gnECxEQoEcrNTIFmKbRw0gu4pkhOupSOrbM3Oag8bZTWCEOpBBIW751TUg4YamGJjbauvTGJ0SF8vyh227MNqpdbjZfaAMSVDhbtS+awTtnnpF9A2FuUxzwvE5/xeDUwXHk0wMX85SPoKZXbAwDMKExp2TTrWdG9CJCOdPYyKfcY+R3IKjf1z2SoWkPuoi9yem21psYwIkEMoRnm/OCF0lhsGn8wOs6t/qPTbD+ArqZ
 MSWM7Hdo
 X09OhQSUBn57y6RP09gg5QKOcjDTig+jF8WcMIiureuSeCmL2mHh4pXH4FuD0O1iCLv6ZQ9BUH59OlMyg0EfrUN3y1CUe05fExE0H0lF3LZI5CSV3dYNWOqHAnNaO95WVeP6Gphh8QL0qxDYnMG/o1hccCIiho35TMHV6tZ4giqGoDirHMrgz5+ANPg1h2OCIZfMJwFqRlqMK94xWN8hJAKun7R4yT5sKgHW377xyJU4F/ZSskMkay1LQsJ0A3NprVT4rfns/MItV8HXezVY0Fg5IMrbD2GYkV5RUTAJHbW81RVyRle8WtUYbhvS1iG2ur9NQ9KCev7pP9g7DuutfqX1Di5Km7cSZ0u+zk0NjM3sOg5CeITQwMbUzG+mzrMo9MCxCnxNaxIRok3Y8Um2WA5CAe6jJJb9ljTdIJ1za9c8OJJBFrCzOEyKz6mtQkhthyTcLwupCDtPsaw0lvd1LDfnOvgYhoyNcrbjOOhsE7qE2y588r2bdIisCh5GMkETKsIk2MxXjQ0psOOkAfkSgim/sOEZesFwLeLLATXWMLQCGrN/rtwE7ES3BCfwi49ELGAOiR2MG3zGHYU8=
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

Add PAGE_IS_WRITTEN to the categories evaluated for a hole in a
non-hugetlb uffd-wp VMA, matching the pte_none handling in
pagemap_page_category(). The existing PM_SCAN_WP_MATCHING path then also
arms the range: uffd_wp_range() allocates the page table and installs
markers under WP_UNPOPULATED, so the next scan sees it clean until
re-written.

hugetlb is excluded on purpose: an allocated-but-empty huge entry reads
as not-written via pagemap_hugetlb_category(), so reporting an
unallocated hugetlb hole (which also reaches this path) as written would
be inconsistent within the same VMA. hugetlb hole handling is left as-is.

Add a pagemap_ioctl selftest that forms an anon THP, drops it with
MADV_DONTNEED and checks the resulting PMD hole is reported written.

Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---

Changes since v1 [1], addressing Sashiko AI review:
  - Exclude hugetlb from the hole PAGE_IS_WRITTEN report. An unallocated
    hugetlb slot also reaches pagemap_scan_pte_hole(), and reporting it
    written while an allocated-but-empty huge entry reads not-written
    (pagemap_hugetlb_category()) would be inconsistent within the VMA.
    This also keeps the pre-existing pagemap_scan_hugetlb_hole_wp() range
    concern out of scope here.

Based on the pte_none fix [2] (same selftest file).

[1] https://lore.kernel.org/all/20260708093444.145566-1-kirill@shutemov.name/
[2] https://lore.kernel.org/all/20260707151349.92143-1-kirill@shutemov.name/
 fs/proc/task_mmu.c                         | 25 ++++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 60 +++++++++++++++++++++-
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d45c729ab6bb..fad648f9a40c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3049,12 +3049,33 @@ static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
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
+	 * hugetlb is excluded: an allocated-but-empty huge entry reads as
+	 * not-written via pagemap_hugetlb_category(), so reporting an
+	 * unallocated hugetlb hole as written here would be inconsistent
+	 * within the same VMA.
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


