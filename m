Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C502CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4FF8E011C; Thu, 18 Sep 2025 09:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55F78E0112; Thu, 18 Sep 2025 09:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44928E011C; Thu, 18 Sep 2025 09:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C07508E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:48:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BEA31A01DB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:48:29 +0000 (UTC)
X-FDA: 83902500738.05.A63A69C
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8319F1C000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:48:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R UJ/Qgj";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MoRYG7Fj;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758203307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZalRXM+ih7z4lKmTI8idxOfS+fA0LyXhXzRx13xw350=;
	b=X7ABwWeXuEpZYC2o5GQo/ZeZKRieKx1j4jdYgq0KCEf3PM52MqjuNXfDqmpoYHvTdvaoEl
	tRl+F2AJFNSuPuRNNld3E0kDX8Ov/GlJjRHfNvZzERh9fT32Rgv27q7W70TuFes2NKO2VC
	eWf+sI2udS1xx/mfTtx3rZtZBFCfymY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758203307; a=rsa-sha256;
	cv=none;
	b=hfYuluIrDLDqNwVGBFhTTWVZ+fuObsIRZTGcFF5SMpDjhG6JGKVZc6O6raXZz56ej2YlUf
	waCglc8E76wXIuCGsds4j7uaZelUO3yg31SQmRNlY+qg6MnGrbsH50YArbVu7jvMGiUxXZ
	pvh7yt7xYDHjjaG62aMerhmqxMqrvEU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R UJ/Qgj";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MoRYG7Fj;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id DB67B13019F5;
	Thu, 18 Sep 2025 09:48:25 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 18 Sep 2025 09:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758203305; x=
	1758210505; bh=ZalRXM+ih7z4lKmTI8idxOfS+fA0LyXhXzRx13xw350=; b=R
	UJ/QgjvNh02Um20o1XKolnS4U/m/Ue9cYIRtI5AMxhEk/Vy5kzlkD5QGc7aw+occ
	QOd9M+yLXbODxop49rbl7w0MStACjQdMlalllDeE/Kg9ZXqEot+rSAGamjkjotZX
	gkBP0dEd6gawv7iLSy85PcBce5gavmPVQNfeMXlPB8GSDgQwZZyq2Yh76YCDn5AU
	rA1gNPPT/IsCrfWrJ1i1hoJ7qOz09DMxU3T76aecf0Dc1O7lhXlwWE2STgxZN213
	+LkqCP/HRMPtgS0IMgNqY6/ukdYyYg+MCjTPDACA54LOqYS4+opF+ap1WgcK5kdF
	ln3raqWrKxE3dJY54LLGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758203305; x=1758210505; bh=ZalRXM+ih7z4lKmTI8idxOfS+fA0LyXhXzR
	x13xw350=; b=MoRYG7FjKrY0RzuWeTIZ1jIcTWirf8DX7shOqkV0WeoxpQGRbse
	4hz0FKbzZR8X5SWOygZJidtvXBflhxaiurkLjRbH2I4VaNSM1CV5N2LioPFLjsWF
	jhLnVizSYMlXEmR48YayP63EZhgRub6L9kzTSE0IxH0Gmu8OLWaD7i+Mwr1DktiP
	9gN7Vo+F1WTqW+c/28uKKC4uqtNHsWxxY9RS2cWjXJ9d6foMN81dMAOjsEw4u+G4
	CNxH08YgAczFPw7uf3ZSskgJHRwo3YEA13tk1LwnALMBDN51C3aZnqjoJ3a3JBBC
	apGDCZG6PeL9y7kF9/7XEGxBs3EFWTtpXOg==
X-ME-Sender: <xms:pw3MaKyJKTv9LzP8XQ-TeTS8_8zKraJhi1Kr2Y0veFGl6-h1o0tRFA>
    <xme:pw3MaDY8ZZ92zmeAvgp3GS6fm1ReK8Scx3chNd8a0Ld3AaPOzxqct5ZWCjx2u1-qO
    jEm2_WYYpwyM2ShoT0>
X-ME-Received: <xmr:pw3MaMwObMb4NOxt4_5RrHieq4ak8S3UW_Cd-iuTxlk2TCzeoYBNzkjGz0Ordg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegieegkecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:pw3MaBgWN7lOfFilTA1O1MD-40ZnsqBlYSKoqZx6oyw8luBj1-2HTg>
    <xmx:qA3MaDqzDdY806RD5Xd5cc_Lfk_J43N8Q3mq0j-nXLdJ-NtkbtXaQA>
    <xmx:qA3MaIf9i8c3H63G3Mj0YYKJUSRGVmkHOe6hoXTPQA-j84yyJO0QLQ>
    <xmx:qA3MaOcI_ljYO-K_-gGa2XrGhE_3u56aT-E9FisIM-lVe3-ciDTxbA>
    <xmx:qQ3MaEM_uZbje8pDoD1Hmr3YS7gZwjEy4WXoURQi0NpWx5YAOT3550BI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Sep 2025 09:48:23 -0400 (EDT)
Date: Thu, 18 Sep 2025 14:48:20 +0100
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
Message-ID: <ndryzvkmrfidmjgj4tl27hk2kmspmb42mxl2smuwgmp5hyedzh@thggle3dhp5j>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
 <429481ef-6527-40f5-b7a0-c9370fd1e374@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <429481ef-6527-40f5-b7a0-c9370fd1e374@lucifer.local>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8319F1C000F
X-Stat-Signature: rthzbiimpsezzibqdu4qbdqe3hzjh5oe
X-Rspam-User: 
X-HE-Tag: 1758203307-469893
X-HE-Meta: U2FsdGVkX1+uHKvRxFJJp9GbmzqmQyMVyv52b6lHtIERNbkTreBWYsPTAUE5aFuPWSEipgt750uF1m9Qlb/CT+xSbgxIacKctTj9Wm4wQW68VgkBQ9onuui3GzN0OGHVtbjg4rRo/xyOECZnUPJljF4fiLhdOVUP0Vbs6MB7DhZFjJzvkP7jI4xGaJNdRo1R6Xd+oud3VtILAJJE9zqz6Q4kMyZBsZVbdVr5E3nsvMzBobeSsSMuZsv3h7ed/G2cLZGglLKCNMD18lmu0SCdS3tXosFYHsUWDaStwyvh3RkJvXPQUZbM6zbR2zg8GYCsp3WUM4IzfRHaTgscCuqFmyeKA9u9b4n4pKmMlsipfNVQ/usgQqFKaza5uu78gfWrEJRu11aLf6ErAc1j6wOC5iV/7uwLt72v8Y6ZD15R7Q3O1jcoHFm6Okxy8xaZ7jjnywRyicpJ5m62jiuAl0coGBjbUIFEIkij5a3O+5DkTQCCdU2Ycn/6nExApdbFZc2/9XHKMjv+xofAx0PWZFi+2VxBqleqymGbDjY2uKqtQpip4CrUpistLfIs6/kaV4QYTod+/MdwcL5RAhOA7Jp+ndfCP4vp4O9uXZw49EdlkTTr8FgkIluRCJtArs8wegYYvHxh47b3gKy28HDh5VdVxmDVOC2iU5wFKUu7l3/HpmybQ0+OkcccAL4pdIaGr/Re8VIlM9qURV538mEPmo+f7OcgA2nchMftspFIsY6JVroRgHfVeAc0sY8LAM3tF9cQuqVDd4kcI0fhzniKZnVHYwCnXXMFVDkg0fJD7VEzOCGK/z0xDoy+vSdLNsPxiXS6pps8n2qoC5LDxxC3NnshoRFS/IEYEK0W1CMLi3Mz5YQGFeBQqbm+z0E+vdD/CkagBg3KhX6jZQUu5YV8S5l7PjQ2yC6TNB/uEkYRyqmFhgCKdHXaevmyHKPH97wSyLpHtXtxWx3Sye5lECH7V9F
 HZ4+hHEa
 fWsUp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 02:10:05PM +0100, Lorenzo Stoakes wrote:
> On Thu, Sep 18, 2025 at 12:21:57PM +0100, kirill@shutemov.name wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> >
> > The kernel currently does not mlock large folios when adding them to
> > rmap, stating that it is difficult to confirm that the folio is fully
> > mapped and safe to mlock it. However, nowadays the caller passes a
> > number of pages of the folio that are getting mapped, making it easy to
> > check if the entire folio is mapped to the VMA.
> >
> > mlock the folio on rmap if it is fully mapped to the VMA.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> The logic looks good to me, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> But note the comments below.
> 
> > ---
> >  mm/rmap.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 568198e9efc2..ca8d4ef42c2d 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1478,13 +1478,8 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
> >  				 PageAnonExclusive(cur_page), folio);
> >  	}
> >
> > -	/*
> > -	 * For large folio, only mlock it if it's fully mapped to VMA. It's
> > -	 * not easy to check whether the large folio is fully mapped to VMA
> > -	 * here. Only mlock normal 4K folio and leave page reclaim to handle
> > -	 * large folio.
> > -	 */
> > -	if (!folio_test_large(folio))
> > +	/* Only mlock it if the folio is fully mapped to the VMA */
> > +	if (folio_nr_pages(folio) == nr_pages)
> 
> OK this is nice, as partially mapped will have folio_nr_pages() != nr_pages. So
> logically this must be correct.
> 
> >  		mlock_vma_folio(folio, vma);
> >  }
> >
> > @@ -1620,8 +1615,8 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
> >  	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
> >  	__folio_mod_stat(folio, nr, nr_pmdmapped);
> >
> > -	/* See comments in folio_add_anon_rmap_*() */
> > -	if (!folio_test_large(folio))
> > +	/* Only mlock it if the folio is fully mapped to the VMA */
> > +	if (folio_nr_pages(folio) == nr_pages)
> >  		mlock_vma_folio(folio, vma);
> >  }
> >
> > --
> > 2.50.1
> >
> 
> I see in try_to_unmap_one():
> 
> 		if (!(flags & TTU_IGNORE_MLOCK) &&
> 		    (vma->vm_flags & VM_LOCKED)) {
> 			/* Restore the mlock which got missed */
> 			if (!folio_test_large(folio))
> 				mlock_vma_folio(folio, vma);
> 
> Do we care about this?
> 
> It seems like folio_referenced_one() does some similar logic:
> 
> 		if (vma->vm_flags & VM_LOCKED) {
> 			if (!folio_test_large(folio) || !pvmw.pte) {
> 				/* Restore the mlock which got missed */
> 				mlock_vma_folio(folio, vma);
> 				page_vma_mapped_walk_done(&pvmw);
> 				pra->vm_flags |= VM_LOCKED;
> 				return false; /* To break the loop */
> 			}
> 
> ...
> 
> 	if ((vma->vm_flags & VM_LOCKED) &&
> 			folio_test_large(folio) &&
> 			folio_within_vma(folio, vma)) {
> 		unsigned long s_align, e_align;
> 
> 		s_align = ALIGN_DOWN(start, PMD_SIZE);
> 		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
> 
> 		/* folio doesn't cross page table boundary and fully mapped */
> 		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
> 			/* Restore the mlock which got missed */
> 			mlock_vma_folio(folio, vma);
> 			pra->vm_flags |= VM_LOCKED;
> 			return false; /* To break the loop */
> 		}
> 	}
> 
> So maybe we could do something similar in try_to_unmap_one()?

Hm. This seems to be buggy to me.

mlock_vma_folio() has to be called with ptl taken, no? It gets dropped
by this place.

+Fengwei.

I think this has to be handled inside the loop once ptes reaches
folio_nr_pages(folio).

Maybe something like this (untested):

diff --git a/mm/rmap.c b/mm/rmap.c
index ca8d4ef42c2d..719f1c99470c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -858,17 +858,13 @@ static bool folio_referenced_one(struct folio *folio,
 		address = pvmw.address;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			if (!folio_test_large(folio) || !pvmw.pte) {
-				/* Restore the mlock which got missed */
-				mlock_vma_folio(folio, vma);
-				page_vma_mapped_walk_done(&pvmw);
-				pra->vm_flags |= VM_LOCKED;
-				return false; /* To break the loop */
-			}
+			unsigned long s_align, e_align;
+
+			/* Small folio or PMD-mapped large folio */
+			if (!folio_test_large(folio) || !pvmw.pte)
+				goto restore_mlock;
+
 			/*
-			 * For large folio fully mapped to VMA, will
-			 * be handled after the pvmw loop.
-			 *
 			 * For large folio cross VMA boundaries, it's
 			 * expected to be picked  by page reclaim. But
 			 * should skip reference of pages which are in
@@ -878,7 +874,23 @@ static bool folio_referenced_one(struct folio *folio,
 			 */
 			ptes++;
 			pra->mapcount--;
-			continue;
+
+			/* Folio must be fully mapped to be mlocked */
+			if (ptes != folio_nr_pages(folio))
+				continue;
+
+			s_align = ALIGN_DOWN(start, PMD_SIZE);
+			e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
+
+			/* folio doesn't cross page table */
+			if (s_align != e_align)
+				continue;
+restore_mlock:
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
 		}
 
 		/*
@@ -914,23 +926,6 @@ static bool folio_referenced_one(struct folio *folio,
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
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

