Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12A2C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60E66B008C; Wed, 22 Jul 2026 03:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37E56B0092; Wed, 22 Jul 2026 03:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DFE6B0093; Wed, 22 Jul 2026 03:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A20BA6B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:46:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C840A0E2D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:46:43 +0000 (UTC)
X-FDA: 85015630686.11.D965F93
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 26C5320004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:46:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lmaxkazs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qttBPexa381gB8dNrmOWiqVVVFWZcu8GPXP1TDIp7Lk=;
	b=bCLT4GyouAM962yEufrc34ru3rg89rAMG6IIStu4uuz0l47E0CB3kDfPVqe1LOtVBLOotg
	t3bq1CX0rwAUM8vBYhfjj1OkcyLLwVBJPfd6yA9JnVqR1XEPC4uPbo4OeF9+6Jg+gdQ8uH
	OII93TbCCZ3DVGMvd2RVwA0/gahZ/o0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lmaxkazs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706401;
	b=n38niddHP1TGF1wmpO4m9bpF62A1YXSgVacvYVAiv1/BbYWqrhKVx5McylmsGxhOkKtF1i
	4xI9kIDIhUOQVnIbhIG/Jd9/jri2ix/uEfCOXb/t0ncmJWn+JXkp5M8djQyS1mORe/gKgr
	LqVeSyfpn1/NkA7L+gIIbmz0ZrT6dK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784706399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qttBPexa381gB8dNrmOWiqVVVFWZcu8GPXP1TDIp7Lk=;
	b=Lmaxkazs20TZza7wu/lmnoBZ1YnLuTHIn+G7+G4oew2pjz+cx04LjlaGEv0QjH3XlMJQ7j
	Tbbdl4zS3EvPNX+y5fAREB+TFdMKxR3zE3kMfEsqrs4gfd5PUdfzYiDXo5/upHQ7lEmfC+
	XTvSBZfKPTwXHgC6pTxIi4ok10T+VjU=
From: Hongfu Li <hongfu.li@linux.dev>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
Date: Wed, 22 Jul 2026 15:46:25 +0800
Message-ID: <20260722074625.33547-1-hongfu.li@linux.dev>
In-Reply-To: <amAcAVdFT4O59Svw@casper.infradead.org>
References: <amAcAVdFT4O59Svw@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26C5320004
X-Rspam-User: 
X-Stat-Signature: mws1uqwwjmdk4te3z8k6dso73aqa1pab
X-HE-Tag: 1784706400-774961
X-HE-Meta: U2FsdGVkX19yJrxWgKMp+ljGovgoIdT0F23uUnyL24X9oLrtD9jrebxgHIcCKfCQTTAFfz0zx/dUI3txUfoCcuq0fEQ2HH2Zgl8t7FLxx8LabQOn7E4SU3A7o2CI2MDmbu6R1A9xRwKKqUrIzXNDRNvQngyP6l1SzlcT65QA+JxevYLjwEMsfz25hIzilxC3xHcwFYqHptWcDiw3RRDUdbgVrqTv+imFzyJ1TPCtaLuHV+tj0lqkRD7KAtRcrmjUmrc9ITY/uU2yvAhnIkT3/hrx/yAVBBPwNGWieNNO4cahMz902Me9P4+UPpDl9GlU36sfOuEd0g5cEqS4wLjnSFnMR1QjHuMsssUgSLI/1ZpLG+lYjZ+Cca4HN2Iwz7rR1zdeqmmeKmuLP9dxD1JwymH1SUrquWUuo8fN1BetfWhuX1cpDpI8wowrXi3PVGa0SeH5Ds/1JG0Ja2RMkimUyplK+pSDV48LHpzB5cCPVe8Prl7m83VoAXsG9keZtOtPhjrzd66em1UVAABfMFJQshG6qfhXAAA4bFTkJ5dgCH1IGB7zZoyXHjrdkt8IPOYxepTL4HXhqPl7CS0UShJ86SPGMws1KoKrN9JYEmWMwZtJPioJmSofBVWhnm1eB4OxOQdw/8+7xZo0nBpWNQkA0Fi6d+k7v0RAMN084tiQYTLSbSDq1DISJjil54MToxDBBJtgUrGRO8OZLwtBLxcAubOE+hbOroVTZkP493XR8VqFFHnmiu0gqknnRN8NaDg4KddxC5kmihrQ/Tn9Fnuw2+vyMMwEUKc+GvXgqr1Oz4DHv+1Knyle85EdWKrjhEffdYG4eJ3CUoTFX5ysLjadrkDh8by1YhUYAt8JNxDdG8FjAxeuU4r9F5Kg6bUvzKAWZElTFPMq9MT/Ya9RVfRFh+mDtOzBuB8RhUnidAMgsUEB5CdDKmkhw/rfO6vV9RmMUJXxz6hGwXqDk7yg6uH
 izg1c/Xj
 Tl45TgqAjR9EDdlbjKMai4xSUrMoLPtLAtefNCGRjSa6+QK1wBxPEO1W5xnPI+QMf87+WICDoT0G1l0nW+eLSTotiGbhhBZsgBNwAXkefFowoKCKFXaM6KxyXUPksMeXoUmaqRQZ6+boAJYu+GvuEVgjbbxO8cnV4aorfD9gxRd8dKxJ8dIapduLwvBz56yvGiwuGqbf9fjgtafvar9IwxJfvJZ5EV8Ng6XtpjL6QjofJJvDKesGpk1L0pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From: Hongfu Li <lihongfu@kylinos.cn>
> > 
> > Replace page-level lock/ref operations with their folio equivalents
> > in the device_private migration path of do_swap_page().
> 
> When I do folio conversions, I like to mention the actual advantage
> of the patch.  Here, I'd say something like ...
> 
> mm: Use a folio in the softleaf_is_device_private path
> 
> Use the folio APIs, replacing four calls to compound_head() with one.

Many thanks for your patient guidance.
I will update the commit message per your suggestion for v2.

> > Introduce a local fault_folio to hold page_folio(vmf->page) to avoid
> > repeated page_folio() invocations.
> > 
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> > ---
> >  mm/memory.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d5e87624f692..bd27372a1052 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4852,6 +4852,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  			vmf->page = softleaf_to_page(entry);
> >  			ret = remove_device_exclusive_entry(vmf);
> >  		} else if (softleaf_is_device_private(entry)) {
> > +			struct folio *fault_folio;
> 
> You can just use the existing 'folio' variable.
> 
> Although this function is far too long (400 lines!  14 function-scope
> variables!) so I don't blame you for not noticing that.  Pulling a
> do_non_swap_page() out of it might be a kindness.

Thanks, will drop the local fault_folio and reuse the existing folio
variable. This change will be included in v2.

Agreed that we can split out helpers from do_swap_page, and I will add
a new patch for this refactoring in v2.

> >  			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> >  				/*
> >  				 * migrate_to_ram is not yet ready to operate
> > @@ -4863,6 +4865,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  			}
> >  
> >  			vmf->page = softleaf_to_page(entry);
> > +			fault_folio = page_folio(vmf->page);
> >  			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> >  					vmf->address, &vmf->ptl);
> >  			if (unlikely(!vmf->pte ||
> > @@ -4874,15 +4877,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  			 * Get a page reference while we know the page can't be
> >  			 * freed.
> 
> You should also replace 'page' with 'folio' here.  Pages don't have
> refcounts, folios do.

Right, I'll update the comment to "folio" to match. Will include in v2.

Best regards,
Hongfu

