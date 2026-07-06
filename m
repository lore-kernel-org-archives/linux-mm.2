Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F62C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828F46B00D9; Mon,  6 Jul 2026 06:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801346B00DA; Mon,  6 Jul 2026 06:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFB56B00DB; Mon,  6 Jul 2026 06:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4155B6B00D9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3CCB40363
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:43:13 +0000 (UTC)
X-FDA: 84958014666.05.1E57230
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf12.hostedemail.com (Postfix) with ESMTP id D12EC40004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:43:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=11ruPhqW;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="kpzctZV/";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783334592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eV/9alPWS8ElGqEhPLcVMrChiDA40ZmyFXIEDHgejGQ=;
	b=Iwzv3AVY7qpVYt/wAStL+Ek8IMwgPTve7EbtFVXH3QyURd6Y2doQqqe8O2U5QAkGNhjJpS
	eCebJGbekPjQbvyEl+UaBNs7/CeFl6PBz1+ZVwdx5U7SBg1oQs1/ZwrF5RGef7FaSozbCA
	sOSyDGMcoKV5lC92k3tD+GKxesErZ4Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=11ruPhqW;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="kpzctZV/";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783334592;
	b=J6OR2mxKMfea2a1ix6l6RWeH6G5HJ2vv1DXzqHq7dKPyYLWNT5pBwMfosELL3UDuXo7Cr8
	arN8+KX0sjA+O3lMKiX9NS+xkdQnBnyIrL2bIRARdJlt+I/Elt/+34N+/U3PDTC2dP55cC
	XTsW3lqbRadqMT163A71M36lVmowwxE=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id A24171D000F7;
	Mon,  6 Jul 2026 06:43:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 06 Jul 2026 06:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783334590; x=1783420990; bh=eV/9alPWS8
	ElGqEhPLcVMrChiDA40ZmyFXIEDHgejGQ=; b=11ruPhqWi+gRLBt/DOpMRs+VB9
	c88OCV08j/eTOF+kQWpqSrR4UFoQO6x9iuIxHlcjN+4UaB0uMoYpWP1S7cvWfkfm
	TySuq1LjXaEtuOTbCnDoVd/7lJGCg3Vjof4twe77qJB84BpLKbR1lJPSiCXn1W57
	9Z0DzJ2vW1+pmG37cpoQeJmEZa+Vych4seJsibFGa/1dqdVbHzUQPAd+8qPJIIYc
	N1VdIvXYadS0Ky0XU6McP5NYa2rr0KPwMA4LLLUC+Ht3sk/B19XDA8shGgGk0Usd
	ig9FW3ky56aIYT4sSHVO2Nur1CmAtiCs/1ptUcOzI2p0skvKwvaiB7EOSFYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783334590; x=1783420990; bh=eV/9alPWS8ElGqEhPLcVMrChiDA40ZmyFXI
	EDHgejGQ=; b=kpzctZV/IWAhQ71XrUSRAbj3a9CwzIk1s48NpSIe+Mb6hL9Qm95
	cvhZEF4ifOcQvFulwMKQ+V9nBNwI1BwA5j4jAka8N2Kt6z0DRcif8Id4RXU7vJu5
	xn+3pQqPCy69OtJabyGRhBmw8AEm3dSuMcCFf4kc4OZx6eDy5T5FpPp3ChB2edgp
	xqez8ppcvPH/Z4DLdzva40TokvP2MOGRbEOuSba/ELeftfJBV67T3pyzxsz97oPq
	gIYZh8/couKP0QcDV1ETRRpDcTYvlZIcnJZGdEjuy0QJbubQdSCpxzsL082cVYAY
	EEX45bSp+kU/YjrbHrPLEKqKbRT+4bP5VDA==
X-ME-Sender: <xms:vYZLalawRMGJGRfL0jCDBViPEJdOzZAXKHFZgScdU5COTXleVsYynA>
    <xme:vYZLat2q49XorsjGXtWTvyByiUJP6ThFu6mLF-3cOUELnwKltuUJpGhFbenI5Av7k
    jeNdZczhirHwivdly-c0eABeHhNRIodjSmObV2Fr2P0BmDs_8S-mro>
X-ME-Received: <xmr:vYZLajWG5OullFblYLdL1sH6QsMr-9xi15akicSUL5fKpEZtXEeLJ5nOPLs1Kg>
X-ME-Proxy-Cause: dmFkZTE59eE0a8v92zvMt2CZRWlI+3piJHg5kS4n5Ij9aa8GawoG4+qulLS96Kun/O16B7
    wkCscgn2uFgvPJ0vvjLjF/OvSijQNoCmJKrMH0kJdxorhmid7e2jGKg0oTanAelyO1yN/u
    NBe5aO3gZ3S3h5sR9c7l3epWPYbDBI1kUi/L9wjXUTJIrC03wKamtizkalYNeG3n3VsnNs
    xeGgUqYSzV60mrCS2pP3viLogAEVHgNs1vgFISbbuNc6iQyV0uJXE/wTKcpo+N2hc4F/uY
    Y9m3N9+FGt9DhIuVe4lHp9Shw4xR21m3aAHGM2Cheqzgf62jSy9xB9iW6y/t0CslHR0Ccu
    yyGZymsqnYP//sL4RVCkbCMT0cDaEmE5HBUEBS76/CkerFzEb0Ck45pR+5Heg5Dpeyt7Ly
    F4V3Ykx64gMeGQ3Pb56r/E2uV12kMggljpR2HmJX7T3acHGIzYoU+dksbKkxoTrD4Ynsfl
    +X+WrGX/5eSChHv32oUfX0JEK0tTPb71l4CKgu7H0wgBDLS3nPnFrSgkkZWQIZs9952YrM
    N46dsJcoqW/lspps/qk56P8nbkv088ChChz23Z1ehBpzzV9au9+aWAZoMP2ANNaA6etRpb
    3Qkew/Q3KXsHEDDaya20rgPaYLJtgsYdukxUtPHsj1amVrZcM0Ta0eVGeFxA
X-ME-Proxy: <xmx:vYZLagu3G4p79s9FvMZ-hZFwFzJkeiXf5IRll00PpnRGhh70vvKWbw>
    <xmx:vYZLaiWpNnktHknJFUg-y7vfZhoGnGSByfe0GrR9fv18S6JqGFK4YQ>
    <xmx:vYZLakWLpe9_QX-y3hvmkZND8t7u1UYxKkptHR6B25H8cuZUGvg_bA>
    <xmx:vYZLakeZO9rGDkK5lH3vZm4-8uEOMJU_Y_r-JzcebEUhR58GDtTMEQ>
    <xmx:voZLauCuA_ivlEqjXGxH7r_0HbUontP3qVcVL9GGNvtiY_nnkUdzko8L>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 06:43:09 -0400 (EDT)
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
Subject: [PATCH] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
Date: Mon,  6 Jul 2026 11:43:08 +0100
Message-ID: <20260706104308.34741-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D12EC40004
X-Stat-Signature: 49he5f3og76axfjjozygmm796jzifnah
X-HE-Tag: 1783334591-955369
X-HE-Meta: U2FsdGVkX1+TWJ7qUhKj+w6E5kmRwqMfcLmUTkxGuIGIl956Ae/j2Mo1Hrvrqga9UNZHk2HcMZOPHv+BZgBwVLhcI/rfn5lI7hIVvrVDJtNXciiBj7Gj9GIYypkoAiLnV0XwpOfTZW4YMd3Bs05KtVdMXO3jc9CYLG+J8PzfvpglLHndaXeDJ1oOUPXGxfmbiw15BKIYXH68oIU7MBn8rlo+NpY0b7GkwUD8UE7Fmj/SAbQADZ5U7cY9tTVHh16uSDRK+jxtFVlBRqCuoIj5wkYOmXI5pEAhDjG6z/FBrCE5QI/Z3Hk+u1i2uNcis36J3P0suIpxB/4w914RcatQuZH59J7QKhzjQXUIincL4zRZS2/Pue9gxRk/t+7VeDFCgROuzTHvUxodO2zWmWBXdowcVMGHWb912aSu0guHQsDhHvHmrauQIJG/vKWWzoXEfWEf8nmMMFmlO2mVAWQDDHCoKBdf7LWMJYtaabQtVlKQXVQmljzhxc0akwKMXfhUWkKU2kxFtJ3E/7uxBwsiNlgmMogaB9++BE7AdW624O63Bc+E1sm3RSLNFoZx1DLAQbuNP7DtPjGGuGPTDOfW3MWomHexnA+LLK/uFeOEmcHCbGusl/1mC9l85GDUPHuOoAi6tQSAlHkBf+oq673uWHDDE/Sh1UW1gATP8t+F7EGv7oDjlM/uYlBWpfbfIhYnN7dEaal9cZJvd4dAPdpQiKcGIYsbl+yNCj9BigvHn1fJ8KvFbPpZFHM9CcCA4BuH5KdqPCz+I9UEfkiXSzfMs/OxY3LC/mnxODukHM5Nr5QO5zxzyWgRZze6oUJwf+L2Tm3iT8hRNFG6gV+4xC1TNCFJIHdugAx0BPU+Oq25GIoyzyihfLABSQzSRIgTiCwArkHgL6RrpsTBJ0YQ66ZtKo26TCUcF+V2Pk5apY9C9dHwwhlReOI0FjjxgpA+rBiA85jo2ZID1bXrzRWTdmf
 wPECTu9h
 0oT3zJDWehKFbT/8eBRiLh9CT9S132HAr2nviydxN6Ix6f6rftj4UoxMGo2oxZCVS1VK3blMR8+aKjvqrwC3yFqj0TmewJIklbSnvHKlRraVkXCoHzrmoe85BfEjTWc9AYXMWLayfYJY7BPNc5HaDNnQGap2/10P73AUfFPRw+bZ9czH3d7xpeA/IWrY3mrCzLOb5kG6r4x/6bo5t7z+J64asVkNlrCXVoBassjiEd1VgaCFl1u8yZjhW/XbZcLPxxAidkbMUxwiPc55XQ+x/py0LFcMfEppByMMa0xGn0smod60Lxq4Id/gVSMAP4nLO2VfB7CdrTyLjI4FPiAmy7E6BWt9iyE3YQ22RUaV9l8cG4QJ8xKZosuG9n4dvcORhuV94tpWOcu2H4GwPRldmj8YsS/CkSrq3FT/PiO9Z/dgmLj3EogvceP0tXX2hNVEwtXuvQ/dH8oEAd2DmDSWigv3x9OpbE9IOt6vvpmrpiLPTG83qfgddcstHeGD1PAHIWDD37a92aCDjJfJDANVNHAk4Fy/7OghfoKA87aJSTY3lWxVy3nL8cNm/c7SjrathrrVs1YL0rDLdwrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

PAGEMAP_SCAN reports an unpopulated pte on a uffd-wp VMA differently
depending on which path serves the request. The PAGE_IS_WRITTEN fast
path in pagemap_scan_pmd_entry() treats a pte_none (no uffd-wp marker)
as written and, under PM_SCAN_WP_MATCHING, arms a marker. The generic
path does not: pagemap_page_category() returns 0 for pte_none, so a
request that cannot use the fast path (extra category bit,
category_anyof_mask or category_inverted) reports the same pte as clean
and skips arming it.

So a range that was populated and then MADV_DONTNEED'd reads as written
via one mask and clean via another, and in the latter case is not
re-armed for the next round -- an incremental-dump consumer (e.g. CRIU)
using a richer mask drops the zapped range and stops tracking writes to
it.

Return PAGE_IS_WRITTEN for a pte_none on a uffd-wp VMA, mirroring the
present and swap branches just below which already report it whenever the
entry is not write-protected.

Add a pagemap_ioctl selftest that asserts the two paths agree over a
MADV_DONTNEED'd range.

Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---
 fs/proc/task_mmu.c                         | 14 +++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 55 +++++++++++++++++++++-
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..a5f5d2e04257 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2432,8 +2432,20 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 {
 	unsigned long categories;
 
-	if (pte_none(pte))
+	if (pte_none(pte)) {
+		/*
+		 * An unpopulated pte carries no uffd-wp marker, so like any
+		 * other entry that is not write-protected it reads as written
+		 * on a uffd-wp VMA. This matches the PAGE_IS_WRITTEN fast path
+		 * in pagemap_scan_pmd_entry(); without it a scan forced onto
+		 * this generic path (extra category bits, anyof or inverted
+		 * masks) would report the same pte differently and, under
+		 * PM_SCAN_WP_MATCHING, skip arming its marker.
+		 */
+		if (userfaultfd_wp(vma))
+			return PAGE_IS_WRITTEN;
 		return 0;
+	}
 
 	if (pte_present(pte)) {
 		struct page *page;
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 762306177ad8..78fa2d1e3719 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1051,6 +1051,56 @@ static void test_simple(void)
 	ksft_test_result(i == TEST_ITERATIONS, "Test %s\n", __func__);
 }
 
+/*
+ * A range that was populated and then MADV_DONTNEED'd is genuine pte_none
+ * with no uffd-wp marker. Such a pte must read the same regardless of which
+ * PAGEMAP_SCAN path serves the request: the PAGE_IS_WRITTEN fast path and the
+ * generic path (reached e.g. via category_anyof_mask) must agree.
+ */
+static void unpopulated_scan_test(void)
+{
+	int npages = 16, i;
+	long mem_size = npages * page_size;
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	char *mem;
+
+	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("%s mmap failed\n", __func__);
+
+	wp_init(mem, mem_size);
+
+	/* Populate, then drop: the ptes become pte_none without a marker. */
+	memset(mem, 1, mem_size);
+	if (madvise(mem, mem_size, MADV_DONTNEED))
+		ksft_exit_fail_msg("%s MADV_DONTNEED failed\n", __func__);
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s fast scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, mem_size, regions, npages, 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	if (ret < 0)
+		ksft_exit_fail_msg("%s generic scan failed\n", __func__);
+	for (i = 0; i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == slow,
+			 "%s unpopulated ptes agree across scan paths (%ld vs %ld)\n",
+			 __func__, fast, slow);
+
+	wp_free(mem, mem_size);
+	munmap(mem, mem_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1559,7 +1609,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(117);
+	ksft_set_plan(118);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1737,6 +1787,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	/* 17. ZEROPFN tests */
 	zeropfn_tests();
 
+	/* 18. Unpopulated pte scan-path consistency */
+	unpopulated_scan_test();
+
 	close(pagemap_fd);
 	ksft_finished();
 }

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0


