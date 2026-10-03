Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9C1CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD826B00A1; Fri,  2 Oct 2026 20:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E2B6B00A4; Fri,  2 Oct 2026 20:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9105B6B00A2; Fri,  2 Oct 2026 20:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1D86B00A0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9539A781B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:40 +0000 (UTC)
X-FDA: 85279411560.03.C222147
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D8B240006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kDKrsUB9;
	spf=pass (imf04.hostedemail.com: domain of 3kUrAagoKCIQr1pw2op1wvowwotm.kwutqv25-uus3iks.wzo@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3kUrAagoKCIQr1pw2op1wvowwotm.kwutqv25-uus3iks.wzo@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SHdCJPwxJseGLQVvNpBndLozFHVWi7DqdUkRWyPzrM=;
	b=FjXCkMnX1P5Zknz4bYjFXQ4XmnqWi/4V4xvDkBfpDpFWIk9bBAJdnZ709RCjABqrj/8QUv
	fiacY+lvfgGw1oTMziD0jQxwKrA6IwrndEpK1LVOzn5AmFZdOoChUKI7hLPU6REfJLxKdL
	8XhuNLFha9OI7jn5XHBNuFAAMCWDqKw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kDKrsUB9;
	spf=pass (imf04.hostedemail.com: domain of 3kUrAagoKCIQr1pw2op1wvowwotm.kwutqv25-uus3iks.wzo@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3kUrAagoKCIQr1pw2op1wvowwotm.kwutqv25-uus3iks.wzo@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986899;
	b=jEG5jvhMikaulCCTEpeP8ZRQmeVB/bYJvKn+wYWTKol8mqZw3nzXpiSXDz9DDjdRF2vADk
	v1H+ybotA/V4zDCJfo19hgDwOMp1ScvtLt/nE1EdKKJqZPzINmeZno84c2D9GZ5MgWdnPq
	NUT2erjd6+6ZFxBElUKrWhV19t6Kq08=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88c4da716f4so139980b3a.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986898; x=1791591698; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+SHdCJPwxJseGLQVvNpBndLozFHVWi7DqdUkRWyPzrM=;
        b=kDKrsUB97I1GktD0A3MZ1auCF2zu8Zl16Y4UkiIxG95VIQ4RoSpCrwMhhckSv0jRpY
         oAjy3C6zj5A8xtRZjTuVPR3suy/kD/nDTeXyNy3QpFpwQhKyetLiQG3tWi1YIMZYhtA+
         IpMMEA5vcO9pHZJ/kgVwdjCwpL+mGXCYJ1CDPF8Vr1addbez2rtyOD0tempUuM8s/14w
         HBoUel6Kcef3ibmLSEF/Gu72+PMKKCDQfkkmKb3e0j+yEl+bSNkDIJ4BgS2tOCmQSR1J
         rgu/PEASMQv2e87GJ5RRsqJxiSzJZIJpYcAZo3/IQGL/ijRUZ//1iZlCjiYUPxYDd6Zm
         Mbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986898; x=1791591698;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+SHdCJPwxJseGLQVvNpBndLozFHVWi7DqdUkRWyPzrM=;
        b=Ylkx3Lr0pXZPnyXcQHEKLYUzHP7/xUO1JITmLahtV2bXqO4b/hIc5IgtmcQSlYekz7
         e0g+FejWaE0+4hd5o/x6CIQQyGJur3k7dEkZ3nxxVnlEOFeJXNgHm6FfGBjShlxAYjNZ
         gEzr0EBfuRI8uYdRiIJG82oyhQv7Uhbk8CQrkX3TP/sv/HU+xbZ7OXUcvXm3O+HhVvOv
         +YHce+/n+POISqORORL2nQtlVog8gvu2Izm2rMh0Pxql3XaNMQzHrkgUZD2qeiCc6sfu
         cVEBKkH+Muf8teswtODCy1bwKO9Y82JURKgmGh6+cmMYIVl+Q0skRa+KgOIFVFCA4LJ2
         F2tg==
X-Forwarded-Encrypted: i=1; AKwUvBxW5HpD1YUmjRF64pXmg/1gca0NsVpd+YekM+OLG64p4sPmnCeD9gdYkna+5saRD2cQYUMlF4HuQQ==@kvack.org
X-Gm-Message-State: AFq9FYKQL5muWkqdM4QDOIjF9l7CvDD9a9bUXpv/1Xd94h/B06n3ZPnH
	sVglxcSUxqCDrcy1IFREXF78egYGTz9mYszzV4fc4P20WIyco2QG/QfQJd+vTd4bCxQelAkqz6t
	Y68NT6YRCpDmOG008en0XKA==
X-Received: from pfbf1.prod.google.com ([2002:a05:6a00:ad81:b0:88b:18fd:b97c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3308:b0:886:cae0:fa28 with SMTP id d2e1a72fcca58-88c64645740mr768676b3a.40.1790986897754;
 Fri, 02 Oct 2026 17:21:37 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:07 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-5-jthoughton@google.com>
Subject: [PATCH v2 04/20] hugetlb_vmemmap: Leave pages partially HVOed upon
 restore failure
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D8B240006
X-Rspam-User: 
X-Stat-Signature: k7dojmtimc4yn8yy34998of3ahr1za93
X-HE-Tag: 1790986898-719525
X-HE-Meta: U2FsdGVkX1+RYvwJA562e0/lr21MiWi72HE1YBGSODq72WixPn1vg6Xr3JVEKgYB9ruO5MqBk4U7MfOXYV57fAGrhYXfB1HVod7ZoUIBGRKlEpWt4EaDdABjFM1lshr/p0HUF3HSLUt9629saOv70tYE/GbhkmUl7jAhntAHO+lTVFgeaD9Aoyo/cj0Wrk6pc7OQO6vmEKdbpb0qHJwtsCvV3wdJN7LHgQfVhwnmAho6tY0oO69c8yM1SkgXRYmQrDk9mAcIhM8P/HUG/nSESV2jPT4CgAULumk41l32XEDOaexXHTgJ5cmJVAL/oLm38ijzHm/ShE1WgDas6kX/vZoEvZ1tcvfNB3BUZLr1WdtrXkubloZuy760dGr78kcptA3uiSnpAA1s+o3EtF7GEMrWfPxBVmMPpBffqagKIgszEB3mTKysYn7Iw5PHOs67febn0STDdUSXC7yj+v6769loc9B1zMFMLKSyg7o1faGBLUs22XVpG8Im3UqUpHhjpVvOaaR3PYolIouO6ivK0oXgQm1GqY1wnJL5+uyC1H4M+lIWuOtBGL+6Gn3jBkKgAzUdIZBy0laJ5zfXScAtf8iv98Y1hThJSAnaLbYreooDZYpRoDIBpgDLJdheqOBN512xmrZABPUloynvJqW7seoD00lM3o4BmpdHKdy+j8lSCvYOxRB7X876fQXDNqkwDPlv9sW4MBW0ZW4h1Ku8f8pwLyiSCqI8VmELqeXjhO4VO9udsxlzCVu80ge/7CMlZwTzuHKbe7XwZE1TUx5scX6xudzWotCojxlpBXnn58zZ5m+z0OPnKWdNyZw6gMh6SL2O28VDFomWsKTqnecHlT9yhSCoIWSl4AeRm0AbrJiCj/nEtoqub+vJ1gz98SyVsr9e582ohQfeKGGHgUHzMhp9jrtARp+jTflN5e8J/2tDoTBdv1J3gD1vTctrDsvlHhTnlPoUWdEUec4oSTF
 ULL9hvTx
 To3CucaSWMREsWSm8MHODnWOM64PnDfY3nmcrR5AhfL27vCGl1+CVMeldRZ01Xr6kSjmdOPCGAaNxO/MJ2cSMFFc0wxLd2oCZhhTsF1wAUvgX6RWn7afYNH+rRnfJMGGmn1z8OV4BCLJEnlYYPV9RC2KJrvb9t0DmMKxAC5qzU7YxGPvINe0UKphPRhJBrftojmnIh4ChyUrouOJBBIWp8tYzVWK7cmhvUhS4rVicMszl6tvqm5T+DyYm5uVE2O26CiqvSRPNcxmbg6Y/Q3nNreXm9726ZKn7ZL/dSmdqNEz5NIEkOc1+QNQkOrzVkRxhWCxSwGUxvMo8vTEz6MPxp4UMcMcOelFPmWOSn5gU0XP4YLF4ZdrjPGGRpiu7+CJ0kaz7J4BBYXyOsxIqSsn1zYxZjfQXpeVf1oOPRAZc++bb3Z07H/nOo5gfpM102CNhM3vejXSrabj7m9/yBjWLjOZDu8Gnc3FFD5l4ZqEpwEFwtTjw2JjAG3ouCm+HJimnuLdL72Wz4VZPG4z7lp1FElXjtatJeKqOPpjNGoe3wJkZyVz0Iin1YDPVe9bTmmQDFda++cPgoLbGH1SpTvgs+AHuGO8VnjPhamB75HyiH8tNbqgOjAxp835nJ2fNhgJHy7GgQo/LEbjoD77oHvrHvqLR7jy84dCVrypF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now it is assumed that the restore routine in vmemmap_remap_free()
will not fail; that is, if we fail to fully optimize a folio, it is
assumed that restoring the folio to its pre-HVO state is guaranteed to
succeed.

Although vmemmap restoration may never fail in practice, properly handle
such failure cases now. This will leave folios in a partially HVOed
state. In a follow-up patch, failure certainly becomes possible.

In the event we end up with partially-HVOed folios, make sure to:
  1. Leave the HVO page flag in place.
  2. Free any unused vmemmap pages.

Always pass the vmemmap_tail page to the restore routine to avoid
leaking the non-optimized vmemmap pages for a partially HVOed page.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 49 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1a2645c382ba..90db4d069ff6 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -235,12 +235,15 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 {
 	struct page *src = pte_page(ptep_get(pte)), *dst;
 
+	if (WARN_ON_ONCE(!walk->vmemmap_tail))
+		return;
+
 	/*
-	 * When rolling back vmemmap_remap_free(), keep the copied head page
+	 * When restoring a partially-HVOed page, keep the copied head page
 	 * mapping and restore only PTEs currently pointing at the shared tail
 	 * page.
 	 */
-	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
+	if (walk->vmemmap_tail != src)
 		return;
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
@@ -276,6 +279,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 	return vmemmap_remap_range(start, end, &walk);
 }
 
+#define VMEMMAP_REMAP_INCOMPLETE 1
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
  *			to use @vmemmap_head/tail, then free vmemmap which
@@ -290,7 +294,8 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
- * Return: %0 on success, negative error code otherwise.
+ * Return: %0 on success, VMEMMAP_REMAP_INCOMPLETE if the page is incompletely
+ *         optimized, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
 			      struct page *vmemmap_head,
@@ -325,7 +330,8 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 		.flags		= 0,
 	};
 
-	vmemmap_remap_range(start, end, &walk);
+	if (vmemmap_remap_range(start, end, &walk))
+		return VMEMMAP_REMAP_INCOMPLETE;
 
 	return ret;
 }
@@ -358,6 +364,8 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
  *			 respectively.
+ * @h:		the hstate for the folio whose vmemmap is getting remapped
+ * @folio:	the folio whose vmemmap is getting remapped
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
@@ -366,20 +374,35 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
+static int vmemmap_remap_alloc(const struct hstate *h, struct folio *folio,
+			       unsigned long start, unsigned long end,
 			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
-	struct vmemmap_remap_walk walk = {
+	struct vmemmap_remap_walk walk;
+	struct page *vmemmap_tail;
+	int ret;
+
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
+	if (WARN_ON_ONCE(!vmemmap_tail))
+		return -ENOMEM;
+
+	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
+		return -ENOMEM;
+
+	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
-		return -ENOMEM;
+	ret = vmemmap_remap_range(start, end, &walk);
 
-	return vmemmap_remap_range(start, end, &walk);
+	/* Not all pages may have been consumed */
+	free_vmemmap_page_list(&vmemmap_pages);
+
+	return ret;
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
@@ -412,7 +435,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_remap_alloc(h, folio, vmemmap_start, vmemmap_end, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
@@ -545,7 +568,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret)
+	/*
+	 * If ret == VMEMMAP_REMAP_INCOMPLETE, the folio might be partially
+	 * HVOed. Leave the HVO page folio flag in place.
+	 */
+	if (ret < 0)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
 	return ret;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


