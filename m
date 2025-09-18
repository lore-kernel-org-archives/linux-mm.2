Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31D6CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385EF8E013A; Thu, 18 Sep 2025 10:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336B08E00F6; Thu, 18 Sep 2025 10:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D4D8E013A; Thu, 18 Sep 2025 10:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 153A88E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:58:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A29631DCF98
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:58:33 +0000 (UTC)
X-FDA: 83902677306.07.3A9D5A5
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id 905291C0019
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:58:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a dPc1VE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DV6F3pbz;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758207511; a=rsa-sha256;
	cv=none;
	b=UOa83sxWiG0XaGQcVSSte83j4ipdAxoXqQ99OgfeofRyiPGWAMvK+puFgCX9ZtSfxJuEka
	dJZxCjlDe3zzhAIBqIxGNr0LuKAhMzDNrIPrGObZP4qznNHEh3ySShhFqtoRXcntPpOivT
	ufMexmcqe3EMGzPnB3rpQzHQHyobrrk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a dPc1VE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DV6F3pbz;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758207511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8pg48vNYs6t9/+XwPwkU2uiasNJp6vX14PGIKbK9co=;
	b=KLp14o1LfvKifybFGMfvT1nPYlhYVRn2Gkdg53gnUX9fq7+cI+sAJ38JilHyaFiYljjzBu
	kD1vfNHWm9t09PF5gPJVlgJx5qPg5zd403DgyUg3ExdN1UQOxTOGLXwHYh+bjZkqhgEyno
	TjY5wnGvdWb1HIJOGNJgtpaW6hYn45Y=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id EED511301561;
	Thu, 18 Sep 2025 10:58:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 18 Sep 2025 10:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758207509; x=
	1758214709; bh=L8pg48vNYs6t9/+XwPwkU2uiasNJp6vX14PGIKbK9co=; b=a
	dPc1VEod5zAB8+jl+a8T/k9xXjRLP2d+JuqGORhZIvOB0iSBlLyWbTeQS0RCnnNr
	l7Oe67B/Vb5SPerFR/MrSBS58pVXnXZ58xU3WLlKpK0sR//JTbbtYb0wY5Ahy2OC
	cOUV2qqkbG8dqTQCsxt4Dlwnh22sBwNH+W+UUk00mBNsHb3jwOY6tVyN+e2OTLF+
	bXqfZxY7E7vH8rstUdUVNGz3/bGkdhXRXiq+hXN/oyKC57479C11+fdCEy+pGlAL
	yKm1FniUs+XjXgbLrQue7usEni7CiOVUplUlUnE9ts6iyy3RgGPbk+vBnBSvCZCO
	kmxNhoG7XVIyurW23zIMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758207509; x=1758214709; bh=L8pg48vNYs6t9/+XwPwkU2uiasNJp6vX14P
	GIKbK9co=; b=DV6F3pbzYhifjM1R7ZFYdtv5Gd7EEK2g+aLSxmCSmTIGeutj1Lm
	BL1hearz+fakRDrPMULpsM5TNiL3pm3f4zi//yWIPv9GdieNckH07ik7j3ULRhZo
	+J6/eR0hpYE50igO/sjAFKtKa/lbyure5og8Jhg8lFZIOg01dBgTdcvFX84oUk9I
	PcQUqBWH2JCDj0o5S/R6eiXTUGeKh2Bh+2U7UQv+cTJtjiD1wjnEvFaA8B6Y2OLq
	TvnaaqA0UkvSlsmtJgQqTSZ+Wd8IKOnYNvqrUyX6SHJ872Q6FNMYM4TieT+Ai9sk
	FfCn46S9oqJoVgt9csRvI+6iqBOFpgoHQiA==
X-ME-Sender: <xms:FB7MaDNan9yyHFIiR65MXoLKi_L2TawaFQnpMyoroeEsEdfqR4z0GA>
    <xme:FB7MaLFPXIaWk5b_HryoBuZ-rxTZ2-Xg-JYDtfxzx4BZlLPWxnh8WOq4R7NwfZjyR
    lT1V4ifkPgMhXKNliU>
X-ME-Received: <xmr:FB7MaCvcg7hHLw1fqP7i125-8IDYR7fTB5iFg99gUCGrMqHarjsawGV771CNWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegieeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlohhrvghniihordhsthhorghkvg
    hssehorhgrtghlvgdrtghomhdprhgtphhtthhopehfvghnghifvghirdihihhnsehinhht
    vghlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonh
    drohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthho
    pehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrh
    gruggvrggurdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghl
    vgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhope
    hrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:FB7MaIvhcOW8RTLi_NxS_a3fBcVdbItDPNhUHF_c4xaBwBQsK0XKBw>
    <xmx:FB7MaDGldt__88ouzLItUh1EOPj0GT1Q1S_Z02Bm3b2z_uijm32KeA>
    <xmx:FB7MaLLtUlQzEM4ja34ahIQj1sYFImhwuFvYdJp5fboqgIgHCKlxsw>
    <xmx:FB7MaDbtHLd8j7zybuLllrSBICNl3R35yn-f5Oiz3oMwbYcc8FB2LQ>
    <xmx:FR7MaN6MkmK4rzorT_6u6oh09ihRs147rAPqBhpcZUaP_e4VSiDjWbIl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Sep 2025 10:58:28 -0400 (EDT)
Date: Thu, 18 Sep 2025 15:58:25 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Yin Fengwei <fengwei.yin@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
Message-ID: <5c4gefrln7nnkhl4pcnlq7qtaj56wmpp6r3lagpuzcjoi2uyms@cd7c5oehjorz>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
 <429481ef-6527-40f5-b7a0-c9370fd1e374@lucifer.local>
 <ndryzvkmrfidmjgj4tl27hk2kmspmb42mxl2smuwgmp5hyedzh@thggle3dhp5j>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndryzvkmrfidmjgj4tl27hk2kmspmb42mxl2smuwgmp5hyedzh@thggle3dhp5j>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 905291C0019
X-Stat-Signature: jgaa1d6m7iazs1yr1n4sr7d9c8ohgji7
X-Rspam-User: 
X-HE-Tag: 1758207511-491635
X-HE-Meta: U2FsdGVkX18u/qA4OUDmnt4wosiEwcxcBsWZqV2wEqibu3GjpYA60TkdaKa0/UnO07TpMGNsxRNbBKPCB0Z3WY3Pj5ItPfOW75Fx2lejJV+oNPkQuSuOJ3C/p+EhVrDYbF1qM9SrmLgFElDrfKIqg2jOq+MiiSJhoRkuiiP1GkVa+3mX4ApcIJ/fK9ZjAhcbZO/fflK1xIniCRfm4Z4DBibCwJHH5B2o86Rf2ORTyzX2YwuY+cMG0r0Gi5j3BNH8lTxNCYNQu3+iZnaLiiaV6g2P/zZ7bvfv6fLyILUuBUk21uMZA2VT2ndZNJWgUhxxjkku2GRgDZyjCDr2wwPNHDCbFSgmJBaeGOaGmroJoIarapXZVOzWkvSu7uhF/BnCA4lsylsjIDaqVcPaocYkJvygvDZcb4O5x7i6PXIZ7YggNatCOj+4pdMgVUjsP6mX3EsBgs7aupO5Nel/fagAGm2Iz4P/q5fclgxNbLQvUVm5ESJLYL1zSjL5/AbylOTKiosgyf4EgWTjTWtrpxSIJ8qxrkWSub2OIt4zHU61FJ/TXeOoPbHncTiwZqvH9Y//v+XmcIqhyCztduywoF/9USFplFZDKGlHLXicQmy7wxvt60ANAb5jW6ljwTCXxlJtZ8vId1boFOMKx3qqRb87BL3M0wla6yYT90Zt8CWt2BH58WTMjuEbZcFddcgilw9t+bG/GBQTbktI4vq4VVZMgLtxXiW35TnClVbzOnUbQhghEd5HX3rr4nDISMPrSLbtbCY6R9V9WSgCaaNHrJcRhMRoyoCZzeNfZcjTxc2SlKAKAJ6j3yfOTdsHfjAafxb/NX+F+SmS5EMB+x6S56Qwxq/z5zfxB6xw6+6QBc4x9EHvgoWnou1BT9AOqZzpJyI5cSny3YnrjEvWBActM4oZX4/6kheeWUMDWWstyGHjBgbOQJ2QT1Ts7GBy21tb73eGDiOn2TGc9K2GsaLhq1s
 e+eiWmFu
 Jzs3m701ADwggfsrXoGTLVDeKOjXtJc0Yw8H17AvfSLh9skrnTUAa2+0d2AEsQ5RIUigFKnADm8eC0Wv5m8XfQOEaFYeLso9trPckJQ7zThbeBxFtK9UpI23gDdKiGbziQoN+yGC60ZWpv8MErc+Zf7BrJccAvG2DZEm9zx4P6Z+XfL9tiCT795qv3lVUK7wKQSaJxWfxzj8qLyIYXrcJmks+76nbwzQgqqFMUAppLPdEK5he7u03ZXePNo2YE95uuhc4v/fp0TksXa4Yq8/1hv0z7mokH7rK3W8WWvv4tO+KZ3DRAy1N1RZHBKnhKEbiGpjuqhzfgSQ91adHXe2qEoLR8Vup7bykTnbdL8iZDbDUMtfoj6P5qHReWq5EAc+IVAdLmb00KI8Ve0ZB4vf36qNRPat/1xdHDNuFpJ73/WHP3fw3yt7IfGv8LB52+p/rHc9y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 02:48:27PM +0100, Kiryl Shutsemau wrote:
> > So maybe we could do something similar in try_to_unmap_one()?
> 
> Hm. This seems to be buggy to me.
> 
> mlock_vma_folio() has to be called with ptl taken, no? It gets dropped
> by this place.
> 
> +Fengwei.
> 
> I think this has to be handled inside the loop once ptes reaches
> folio_nr_pages(folio).
> 
> Maybe something like this (untested):

With a little bit more tinkering I've come up with the change below.

Still untested.

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6cd020eea37a..86975033cb96 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -928,6 +928,11 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
 
+/* Result flags */
+
+/* The page mapped across page boundary */
+#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d2..a184b88743c3 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -309,6 +309,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
+				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
 				goto restart;
 			}
 			pvmw->pte++;
diff --git a/mm/rmap.c b/mm/rmap.c
index ca8d4ef42c2d..afe2711f4e3d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -851,34 +851,34 @@ static bool folio_referenced_one(struct folio *folio,
 {
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	int referenced = 0;
-	unsigned long start = address, ptes = 0;
+	int ptes = 0, referenced = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			if (!folio_test_large(folio) || !pvmw.pte) {
-				/* Restore the mlock which got missed */
-				mlock_vma_folio(folio, vma);
-				page_vma_mapped_walk_done(&pvmw);
-				pra->vm_flags |= VM_LOCKED;
-				return false; /* To break the loop */
-			}
-			/*
-			 * For large folio fully mapped to VMA, will
-			 * be handled after the pvmw loop.
-			 *
-			 * For large folio cross VMA boundaries, it's
-			 * expected to be picked  by page reclaim. But
-			 * should skip reference of pages which are in
-			 * the range of VM_LOCKED vma. As page reclaim
-			 * should just count the reference of pages out
-			 * the range of VM_LOCKED vma.
-			 */
 			ptes++;
 			pra->mapcount--;
-			continue;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				continue;
+
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
 		}
 
 		/*
@@ -914,23 +914,6 @@ static bool folio_referenced_one(struct folio *folio,
 		pra->mapcount--;
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) &&
-			folio_test_large(folio) &&
-			folio_within_vma(folio, vma)) {
-		unsigned long s_align, e_align;
-
-		s_align = ALIGN_DOWN(start, PMD_SIZE);
-		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
-
-		/* folio doesn't cross page table boundary and fully mapped */
-		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
-			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma);
-			pra->vm_flags |= VM_LOCKED;
-			return false; /* To break the loop */
-		}
-	}
-
 	if (referenced)
 		folio_clear_idle(folio);
 	if (folio_test_clear_young(folio))
@@ -1882,6 +1865,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1922,9 +1906,24 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				goto walk_abort;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_abort;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
+			mlock_vma_folio(folio, vma);
 			goto walk_abort;
 		}
 
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

