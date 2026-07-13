Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EAAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54F36B0005; Mon, 13 Jul 2026 05:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C926B0088; Mon, 13 Jul 2026 05:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42DB6B008A; Mon, 13 Jul 2026 05:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4FD06B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:17:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47B661C9754
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:17:15 +0000 (UTC)
X-FDA: 84983199630.07.679A344
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AF301C000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:17:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=1DRc3ocy;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="GoLaE/wI";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783934233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1xbhfj5oySSPiW3sBaN7DfF4z8QmtL8iTdPVFdxk3rM=;
	b=ee0YBcgPVsKn3NffFihI97gMOvncPMed6YY1t8b1TLmDaO5wC1Huimd/M5fQwElM8s64EM
	olBpTW5OKKzEgnqvWWFXNBSLrRUtZUqSeCqb5ZE35Top/5fMD8FnaNQ2Gg2m3nlZMbBLdT
	Iud3b208QciJxUtfP+DiE852gHS/qOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783934233;
	b=HwaTfCIupL3WV1FBlKP+VIH1r2n28xFUsijyvoyadTX/kVc2JAno6RXhiETxXOLtDmg9sz
	vjPRShYYhD8DfvSsksp7GvFG1Zz+eCnEA0pbe2r/Yr1d7k35wLytGpz7LWe97APyG4jW3s
	D+ukXa2kkN7DFnEWbH3QLsQHiloIki0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=1DRc3ocy;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="GoLaE/wI";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 433127A0009;
	Mon, 13 Jul 2026 05:17:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 13 Jul 2026 05:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783934232; x=1784020632; bh=1xbhfj5oyS
	SPiW3sBaN7DfF4z8QmtL8iTdPVFdxk3rM=; b=1DRc3ocySGz8o7d9DhtZsn9wyI
	7G571WjmfWfFlVddMDMRpVydSF4U9Vt2achLF4GDlotqJkax0UT5kZX5lYFnMHLW
	DoDNI6k4h66TgPMV8tSqG4WUmiN4MRC0qGm/8bem5WKHTyRJWVAp+VchYlfGB5hW
	rjOJIZtcqkopW45l4W1LKfe+KxReQWPyxLEcdK2A+xWACgJ8gKcfi9aIXs/2LrvA
	k0BwMIw3QBy86PSnpnnrU/5uOhHzn3MZX8JSwIrc0LJpn0QITdUbSUhpWOXbH93P
	oK9Tyqjf7BxeLBIVBmrXVP7DXr7/f/N7YBc4rwecJMYsA8dlVPs6JfH6mzsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783934232; x=1784020632; bh=1xbhfj5oySSPiW3sBaN7DfF4z8QmtL8iTdP
	VFdxk3rM=; b=GoLaE/wItcp9NR7PKmbrYNZeohMt/1xKCiEnvxKsTb/ohYycg4+
	fayaNADgUlpn3ACgRj0oJYScM5jJKNXGFIqux0NhPEhA96ef3OlBc1tfGcYlroeh
	BI/1YsWZrCMC4TYXt521BvtU2BkpaXQepW+A5xDv+aWMCdr9YkHmAzcdm/d7LZeP
	Qqky/uwi9zQCftOxCVaERfanyBKglXZ3Kbls6lWfzSnBruhioW4/XKIqOIrMfhYs
	6L2Vk5T0l0rdyq1czknrCf4cduoIagN3w1ls9nitT7wWOlXEuZmZ8N7UjnzGXGB1
	lJAHi4OMu970LHTO9Di6tJq8wc5Ng6S+F2A==
X-ME-Sender: <xms:F61Uavl8-waatKHj9xAKyFJqnTh86sne2sf0EEV9_HROueg1BjJ6fg>
    <xme:F61UapxJyyOlzYLljmH_iFm8mkVqYNBjOpXig9L3TcFU76MWvzMfWRD_9d4tqGrSv
    _zBVvvaiyroExHyzucEk-ADv_Iqsu7Zyic6iPsp6YcAD0scCXKnNII>
X-ME-Received: <xmr:F61UaqvRb7fguUzC_ccSHB5sQbRrI0W0es-UGUYdKZE_RtVhDd5KEEC7Ufjm7A>
X-ME-Proxy-Cause: dmFkZTE35eLaqsHY29rP40wHpmJD0ZW+LFgqEemL/dqDmHLkgVIAH97RfjNaUeDsnOovwg
    s8X0LoMSXDzSdJLXvBsq67KNQ+4EVBtxQhbc6fbVIcjqrOKWgVKoN5TKGozmSfSzF9x44F
    oyjmSMEPHSeWEKBIV1JQDTRR70WMDbRr49k9OSyP7QvC0zubimzViNGnqQL3++PTWI2Q1A
    dLEWwV5CDWW9Fv8zm95Ft+GYkhoiQUyN7i404w6T/gXFjBXPsGGUuJeDjWjV2NFaYSri4h
    KFMLvO/53Eodwd0mDcCop777H/LlbaTpSDAkiKHZ5UWxDi4mfQlk2BC8ZDLS4Zmohh3tga
    WxnjK8OkH9ZWZhFLC+YsqOsyE+IJ1jcAOtq3+OpEQUgGtiJmLMD8/nODR03OF3pjERgPaM
    KsF7H5t9vkdamUuLxmkp1lYWD5w9w0SrbjlOiQt9+g40fZxx38O3kTnpixNGUf70RdgU5q
    SWrhhR5WkZMQIBFg7HFpnctTokpsYnlZRSwAKqsxDLkf2xJO1U2MZk3i0TtiEMwtir7Tmi
    A2guud5YT7rwg8nK04gTy2NwuFg7oVgihZwdTUdEB23rFt6b48LJo/YKy8AIYs21u7ZhIP
    7+0E+fgyj9LSZidVdy0Xu2Jo/ZpOp2jFj8xl3MIB/zFSJtNJqJfahLPqbdfA
X-ME-Proxy: <xmx:F61UausfVkmtu6EeLIdmnD8AexHFhQRDuwMO45PefpqHd73Rm3sXHw>
    <xmx:F61UaomtW-sauB1nwH5w2cfZaAiLKzJsecuaB7fUpiDc3qKQoSRk3w>
    <xmx:F61UasvQD9lymr_Mow2vV4LEHh3J1Q9HoIItHGFhUW3b36kh7qVYGQ>
    <xmx:F61UavOQwlnYs0pkUcIChUibj3oACboUsdA2uBDhLFyaCzkSPhGuqw>
    <xmx:GK1UaoWXe3FHj45Vyfm8QJKvT80s0Szs68jvHlgmMHNO-8elpTiIfrp8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 05:17:11 -0400 (EDT)
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
Subject: [PATCH v4] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Mon, 13 Jul 2026 10:17:10 +0100
Message-ID: <20260713091710.206548-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AF301C000C
X-Stat-Signature: bjdu68bxufz743u8imub58rnu754d3w1
X-HE-Tag: 1783934233-614168
X-HE-Meta: U2FsdGVkX1/zPC5n6FLVh+h4mdraNzyAD39+Wczh41rRwZrrb2QEt1UBYRK9ER3LN4q2NsospgvUJ3IBD6Sq4fE9pfUCI4ZpbdYnJuvY2fIZl5GEE6ELRQvikCJP2h5SxMYR2IuOtS8AsAsCWwyskRRtv20djomKKlCPf9SNAdDOV8DiQuNstZCZsT/wFDk+ESxRFDoTRJpUnJYthe4o57Zx9hztDZ5q0stha1QaiEh4hcFnS7Yuu5rKHQOa13ihIA8QRIOe1cmBfsqxD2Y1NFnfqxY1rJAaibT1hWuxEFjDoqFM0iWTbM90T4yXkPVkNQE7pFbSJfjcjrVj3h3Gj0ZkRRyCx9Geoh4PuRvVAMZn0qPMz75ohzYSBPFnBEn5eg7iGAIQonjOHn8Aeyv5i9LE7GBMoHRnfMeKFMz88VxcEEAeXwSgamB5iyM6QWO8lNkMivdkxwyVfTTJZAsa117cUpLoNaBsgefo9VXKr28SkbppgFxsVbLsEb51PI/9Kd6pIavRtoHAu4K2sWvx8ZDADbqthyoroUuddNXDfx7NTy6UUn+4hkF4SmktsovRAkZDnHmGTo6eUIamLZoOJpiV11HMiaY8O+c1PGczxwz6/RG0Wx2Wzm98GLLzVauCujUB4tjQzg6FGVzEQWtGTRkVh5Bi5tmb3SE1BdAgfreMihu7at9DlR8wwwiqmqCjZm9nYnvOBqZ8XCBGpKWJcd6lpKt1SXpTwzxhAR4s8xY26GsRWdMud/ZL9rCSgREL7N1DicFv6TWLnc27ppxwVWD9HTtnHTasz+qe21f2ykGvErx6GzYAs3OZqN3eD3hy+YOC5eoK/YAIewSAOvuWbJVsZCA7A5VWtVnIc47T6vhKmo4i3HVsjrAJrqC8zMJNcDCivqHxpCC1kOG3lEtONcliBsZXU6C2NfB7OISfVRCAlHUBqi1cfORJExIBNvntl3YDR/o2bvppKJCCfvS
 o57Eqxet
 NA2tfrne9Im90AxmEc+7WDBdcH8ZoZKQiVDdCY9uuj8Cc/rKnzGVCifyxP4teP4AEBm95VEPxIVR8+91CfLiAWiqE8QBPCZO8MopOt/NsCqb3hzmw0r5rDhvU8rrwfSSQWc4PXxeu2d4zDNGk29WzGLBNE4ZCnA9Um5V+o7adbISUBaIBTTsGEPqjHbZ//Ygmy0PAzGw6nasus3QQACZVzgsfA+P/pHPCORb02jiSqT/zPncOKPTxEY/59x56DedQZco9L3+5dOOvonoaciGab0LEchBN1cuHY7B9clBsLk9LMpoUNLpktGm8ExZjjMxnE6gVVpoPytB8DjkcUms+2/OI84U1ocEpTmBUF6ODl6HDGoslzgnDK6bwdQ6QsQIGHhNNa7o3D0qaNglA1hS4I71FrCy9MUPQiyR8eh6oTED7hvZhx4DQHdhfgDdLhulB7Da8z/IRyh4+efMqhHKfkwU8S8i1g9uQHxH0qgXmFCre6wqROs4WXrwpd4bKLZ0ln6YBMGY1OBeAiAzuW11ciD+ojBCqzhQoV+B3Wb4eyT3nBf/fZqgyUu/bCYf3qLQep5iaZrAe338BpnZEc0q9hFecC40r5k0l4T5ffD00eiBD4NqiAgBlFTsvZidQseQr57+v
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

Changes since v3 [1]:
  - Include <linux/mman.h> for MADV_COLLAPSE; <sys/mman.h> lacks it on
    older glibc (e.g. 2.34), breaking the selftest build. Same approach
    as fd5295afae91 ("selftests/mm: hmm-tests: include linux/mman.h to
    access MADV_COLLAPSE"). Reported by Zenghui Yu.

[1] https://lore.kernel.org/all/20260709121629.205562-1-kirill@shutemov.name/
 fs/proc/task_mmu.c                         | 27 +++++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 57 +++++++++++++++++++++-
 2 files changed, 81 insertions(+), 3 deletions(-)

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
index 550d1f2c059b..2bb3cf6208ee 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <malloc.h>
 #include <linux/types.h>
+#include <linux/mman.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
 #include <linux/fs.h>
@@ -1102,6 +1103,59 @@ static void unpopulated_scan_test(void)
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
@@ -1610,7 +1664,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1844,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_hole_test();
 
 	close(pagemap_fd);
 	ksft_finished();

base-commit: 9795ad96d277c4af049fe30de1cebd4e39d7bcbe
-- 
2.54.0


