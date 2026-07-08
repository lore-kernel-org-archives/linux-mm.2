Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2CFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3912A6B00B0; Tue,  7 Jul 2026 23:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367316B00B2; Tue,  7 Jul 2026 23:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E276B00B3; Tue,  7 Jul 2026 23:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D80E46B00B0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FB04120674
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:39 +0000 (UTC)
X-FDA: 84964134318.27.0D64855
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB1BA180005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T6ci5S2E;
	spf=pass (imf24.hostedemail.com: domain of 36L9NagoKCPcisgntfgsnmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=36L9NagoKCPcisgntfgsnmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480297;
	b=5iwHe+uKIi9P8eOSiCwGwuaLcV+oHQgWU4H/eIHP83msPtwXBDc+6piVI/KFHDYOI/lsWW
	wzql+szlBdnQ1NuPHB9UdvJacgIJ5QzXzrkyQ6aMUsE+O+EN3DUDC2uYyV7Yc5k7Ja8Kwd
	eTJvPbvXOSA4oyuaI+kw3UX56Dr3Pw4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T6ci5S2E;
	spf=pass (imf24.hostedemail.com: domain of 36L9NagoKCPcisgntfgsnmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=36L9NagoKCPcisgntfgsnmfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziyOxc8kPU1zkWqQd/xo7T152fH4QK1CRdbLsKeEh/w=;
	b=lnV6qVtQD/KuZbpfgsUIuxhQfDuRkAzmXr5wQun29CwlahSo7AuTeeyQ4+dl374gvIbLHE
	jvtD9f4JCJeFPu+AgVYiUmKi9WyLMPz0C+TEnWxNPc8JUcGMV2XZrNuyXQUITmXsJuRhNd
	+SPz1RNZrrKHeGSJFwpTSwMYnoBc5Rc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cce406883eso2612555ad.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480297; x=1784085097; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ziyOxc8kPU1zkWqQd/xo7T152fH4QK1CRdbLsKeEh/w=;
        b=T6ci5S2Eu0m9gyFdIHfeLGI5wZCCOlOkjqH7N164s78rsMwXm1av8O0//K7NtI7mRK
         qbuxV1wvke606SZCwuuo7o3SnVXWY1Qaj7IrBZ6aUSOyHYkgu4D+qXd+44RWtjobp3Kd
         3kAj9hlEnpErJ1h2gxmLA6EFahcpkOYKWmPdwztIc8PP7ppVO3WYsusOIWzmCI3ssLXb
         fK5p1BvGkOSuJMR3BIhebNWXWbvyr5BkwJq4H4GZuG2rPWCdx6WrcsX0SjufFe8Pe3X8
         Kb19DDc15bO+zmpM0S5Pm1WWad1zCBFIjRnr7vKBcc6A/y3HLUB2iQrWHsD1gIv3KgCL
         jQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480297; x=1784085097;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ziyOxc8kPU1zkWqQd/xo7T152fH4QK1CRdbLsKeEh/w=;
        b=s2Ym+F6LgN6tWsN0Y3uZMLtXg+7TenM8ou7ZQQPza4XUnmI+2EPaJveqtfboHOERHa
         ZjwSomtgGuv5Gvl8hZj+ZuhcnT2vUJsJ5WOnrOt1PQ4oFUrFNfqhxkNELDxi7aOPgv2B
         tvxXwGTuyVaUeX1NuaELCm24ZBlGEg2Qk+qnczkJ45oAtXcVYtE9M5ZnE7uZOASHGByU
         bJWbj/ye3hTEMXuDNfQv/xKWfj8KKlI35pFRYpwv6hXgXE+gDu9tspiNnkZBLPrwd2t5
         LqhiuwCXRpQTFM0N044wolYUpT0s69UAGVaEgjk+pu4SY9j+Xz5EI1AJuiRLWttN9Eu4
         jghA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9KDjeUBhF649fIV7paDR7X/DjGyKo1gU1qLr4vkUbMR250U2eDq1zDB0RLMi5/EquR7AF7xS3EA==@kvack.org
X-Gm-Message-State: AOJu0Yysycz27C/oEQEXMEyDZ17nxGmgdF9kOmnXwHJAqAYZG21Qb2LD
	8X3dH9cOASdtY5bGZp6BBECWTbyOdwuf4wDAu0/jQTdPSB6rMH9gcEOJf9kwVBKDvR4HwO3C5XJ
	oTisGeWFMLerIeExKz+oLXw==
X-Received: from plbkv5.prod.google.com ([2002:a17:903:28c5:b0:2ca:d66c:97b2])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1c9:b0:2cc:86a9:ebfb with SMTP id d9443c01a7336-2ccea47c361mr7188645ad.33.1783480296362;
 Tue, 07 Jul 2026 20:11:36 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:13 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-4-jthoughton@google.com>
Subject: [PATCH 03/18] hugetlb_vmemmap: Leave pages partially HVOed upon
 restore failure
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB1BA180005
X-Stat-Signature: yjuy1re6bifm1ucwurxuqkm4q89gg38t
X-HE-Tag: 1783480297-135195
X-HE-Meta: U2FsdGVkX1/nzVeg8EsskwAGMC8jw7cxFDC5lnwC9TlqFpS6/Yz2vjCOntUWs6ul0zWFzk+d24KO/ddUw8WLPS39kUeXCe4zKO81miUX+TCfpd+YB7votrpnvNoEWYbne5WHHlbZvhgRVjpwkOUinc/uMwbCcFtXypPT9rRSsCtp4Sz/+cgGIyh2ng0dGoJSIFtR6uGvf/ZFTjjF6gbanXZsBV7GRNsHwwsS4YFbpZBoldnqV4Q97Zoiwzld9EZfF8WtI8wUlma8Kw8aM8Gqh+eklk7i2SimCuyvP1+99LlMWx5ziHmn+q/GEuUEGpP/tB3y8M1AJKfBGL09E3o8BtDv+Fx5mFdd4ZTTofbaaHs5yWnPkoIyxZoXzti7D6GfKlOL6iVKtsq2OvoN9BpDeM7DgUhKoSq+9mfSrYWU5CWtvIEAbJ6bDMSkqbM41FA7bq8/OGUapts0meS8+iMZSZe9NunD1ode4/SA1jvtA0quxh0zbsYR4eoDs8j82bMqZ/sM9sTmJZEy96IRXAXsWFds2Lv60bm64+Cop6Ymswvo/ez1z390w/Cf4bDCOoTWmGJJ3GLfCnYGs2w/A0QCPdQpPpVkuIjsdncU5U67BCa+8F3MsJ1XWTXAE7DYdoelVHhu7mINdeZJJZAb2VsCVZBoC2YE7L90t7L6wm/m+WrDOxeLyZwXQjmbUNOr+ZG5ViUiueaJxzb0VZNTKCxkvati4m4dUfOsnP3ioA8xFipw2h/O7SMwwk5X3Q8DHv3rZass71S7TuQW03pAjporHt3ucAGQK+leyj7zS51HSOQFbv/jmN2tbNDHLBro5wWSfTi2OimcFHXlfA8mFK5L5K9MytqiiJA+sQ7rDLbWBlpzVrJLzSNcE4e0pdc4tUs0z9WbP7voFPfQT982w12mYzi4VXJrLVyD/OUWueS5LB8poWQ0VSKYk2KpDAkLxtA2G7M8mhs8t5wXXPa3xP+
 dvGbtWaB
 aXjWGx57pLfD/Em6dVAwRZ+HQsoo5N9lNKWKMzVmG/00eIDfYUR660BX/gEBK5bUwiSVMTqT6T0w4RiCNnVTyQhnkcVyV5PYau3krMtBCsaCuGX6n7y8f0ReFyHGms1GhUILDAv/K0QSgrgDePtvM7Hvd0Hlj/q2i9lHtlg1d45A9yOJEdAJsg2dZ6xfCtaRPceOBTmdX2BHaBYNNoj/eEjs+T33pkfuM1nawxak6IBLVWgg7Zqhzb2LxeOhjvCBH/QqvHJfD/d3F6ytM1ZwlDkpA22ijMilJQISqEmDK5zQqTdqOiwXFNyyyungm8nrZLqAqh1b5VSSKAAundQr8gTWcRa6tephdH32NjYXKZFm0nKd+mSj/sn3reyWBl4ideuWYCLmxvpIctxYBHFMGg0rsMayhRMO3ocEF8Lgftpm5pGdwVZU97M4GdLjzOqhv/CposR65FJu4LVRILTAqf8WutZTBAUGVTktlFZ0STOZNu7/mKh1zFbhUbzF//GysP4Awhk7GfyxCAThqHX56ltHMMetjCESUbvHvihoIyAcic0gu6mkvLHWo6sNea5/76fj6blejCFlbFEB6XcPZzDt8sD3Cbqt3BzqaNvLx4omux9Oim07t9C2s2rba0jf4lNG78QXDTZUcAUzrr28FXFIl10uNzBzA7AdJ
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
index 8d4e8ee51fdd..5fee01bf5b34 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -236,12 +236,15 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
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
@@ -277,6 +280,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 	return vmemmap_remap_range(start, end, &walk);
 }
 
+static const int VMEMMAP_REMAP_INCOMPLETE = 1;
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
  *			to use @vmemmap_head/tail, then free vmemmap which
@@ -291,7 +295,8 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
- * Return: %0 on success, negative error code otherwise.
+ * Return: %0 on success, VMEMMAP_REMAP_INCOMPLETE if the page is incompletely
+ *         optimized, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
 			      struct page *vmemmap_head,
@@ -326,7 +331,8 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 		.flags		= 0,
 	};
 
-	vmemmap_remap_range(start, end, &walk);
+	if (vmemmap_remap_range(start, end, &walk))
+		return VMEMMAP_REMAP_INCOMPLETE;
 
 	return ret;
 }
@@ -385,6 +391,8 @@ static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
  *			 respectively.
+ * @h:		the hstate for the folio whose vmemmap is getting remapped
+ * @folio:	the folio whose vmemmap is getting remapped
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
@@ -393,20 +401,35 @@ static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
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
+	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
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
@@ -439,7 +462,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_remap_alloc(h, folio, vmemmap_start, vmemmap_end, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
@@ -572,7 +595,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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
2.55.0.795.g602f6c329a-goog


