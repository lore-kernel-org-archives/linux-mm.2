Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C04FC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC596B028D; Thu, 13 Aug 2026 07:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3A66B028F; Thu, 13 Aug 2026 07:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9B16B0292; Thu, 13 Aug 2026 07:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9AEF6B028D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:38:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75722A0101
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:04 +0000 (UTC)
X-FDA: 85096047288.23.2D0B94D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD77C1C0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xr4HrNQw;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0q0foin1r7ZJY1ZfoJ0F+Tbh2/pSdHGZVciFlboEyA=;
	b=FW6+Byt6pJ2tvK75p2jTDjjwXAyBESxYIhMDzv8JqbSuHEfwzGuj3HX1lpMDIGspvOMKBN
	/fR/Ydj6zMc69ZnzbWwlfiMykv1ew2kqwzQD+Y3p8aIa2qb5zFXGPF13vdwY5Ql9YvzkuT
	yCaYqyeZAzP6bU3JazaUUEhu4jbI7N8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xr4HrNQw;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621082;
	b=zCKuaSgIv/T4kOkGV3KL0zMSJNyNj9iWpnbkpvgkuNC0hd1Gu2vPnLDkuuYD3d3jnuhRxa
	IY4n+B6vy4iqT9Kga6X9BXHJ7vnpmC7sZcFKMz4Bk4809YPoLICekKntGVlM5L2XPTLskc
	sPS1dEga6yAVJJRUlixCISpq79OjEyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7612A600AD;
	Thu, 13 Aug 2026 11:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609681F000E9;
	Thu, 13 Aug 2026 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621082;
	bh=E0q0foin1r7ZJY1ZfoJ0F+Tbh2/pSdHGZVciFlboEyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xr4HrNQwh1yloKOrotLUQovwW+pRON76NvZ3uDr+evkMZafPCejupzsd5yBqPJ1UI
	 8c1Z7UFUcFosV32c+w6CUUBxTlQGVry1vPNCGrZ4hZdeIv5MIq6KaRCuf74zQTgL7P
	 f/bjtoRUhw9dKOgimuT6IBOIGFXYRiy7udigDY2AXqW6VvR71WzkIrRG3OBWiip83n
	 1WOnqeLkXpb3LbsR1fVpm96w86faUihlVa7V+kU0jXqSfZEI1PnVw2/TM213tS2FrZ
	 jBEVHg85KNMML/cnocL9oX73xBHkE93gLGMGs17bZsag4n2O0hp3IxCaBMlQOiAPZp
	 4W+30ugtrf2SA==
Date: Thu, 13 Aug 2026 14:37:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Pranjal Shrivastava <praan@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] kho: Introduce a helper to init high order pages
Message-ID: <an2skkjrNXBTFagK@kernel.org>
References: <20260803113944.3694290-1-praan@google.com>
 <20260803113944.3694290-2-praan@google.com>
 <2vxzqzk338y2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzk338y2.fsf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD77C1C0007
X-Stat-Signature: qdsgufersjyccggb4cmhzo3rhuss44n4
X-Rspam-User: 
X-HE-Tag: 1786621082-363108
X-HE-Meta: U2FsdGVkX18n92CtEVbpbDDRJ4d7PaFe1MtKx3Y9VCFmL5Xb5zE4qq8ASHcTgztjgKKzWinmHDr1Ha1L16Inv6UrdtVZ7tdBA4F+Jsdv0iA30ZjqFcoMEVXXS8zvIi+zPn9/aPQaVVdsjruWMqbaIoWwItE1o3wsuvhVQ4+im9gaUOpUvTwtc0jQjHKVYW60/AdMWIzXA8Wdm+6mkM1kIXFGeMDlp/VlY7COu3Hctli1pQDCSc8dJrChkjKbMetJacpkbToefV5CZpk99X5c8TGlJaA/E5qc8o9WoupMwBigfaRCj4Cj7nNHDYLXrTqGtkTgfTkr4mx2F2rOZyGaIfWeiRca1D9+zuW4TWLbf70DTZ4cNK813efiMsC+f+w5+yAanmQah8jtIqXc50XVb+vqeif0gk6aFL6rN7G6Ps33d6wNMO5KZCzvYcWJhBvGYeu63FFyXrJQFP9uUrY+dLSFNsSP6lYYQLFfEbCAkZ9XcDSchqT/iLUpTu3al7Vp8fCQ0Tym3aKZ/Gi+PeCGqRBoL4ATeZi06MFisw5h8Gl3lLa8XdBrr7M++ogVi3YJ7RCIHq0OevaD4yLMz2suzMxLL5pV0OL8J3Zt+KATkWhxUhel5qp0GCFNi9Clv4IdfWX2dPOoI1aFI66HGJii79UfYjImsXqRGnsXzJU1/OHbdtcJeI17haxOKDGC/5L/UjxtAFw8Alq37VJEMF6PuowM7FCybzi5cZ5lw34LQUWfgTfGV3RuGXSicH0eb51ygc5Cn9s2Hy9WA4yXnewgaKWcXgr/UancM/JBd+pFjhhtzdYmI6i8KgJiZA4YK70YZVyWH03UzQ6NxgVPoyH9m6rrJjsKkqazWxvNw4f2olsqga8yVnf90YDVBj67m0KrxjJoaumFrY81Iee2OeXIJ74KS1TYqmayR1V0eeEYVDbI0pvD0HIg/BNnL9iM/w7AVig71B4wWkHnskyVEyo
 6oHWsYeF
 LBvuB8Bh6S4snGPZptnXTTwLz0+gsq72dg6FjKLI/cIZ7QhQjcB+lnvget7YGctDCEjoh5fux9rFlTdJYIl/iW0J9gcpE4I1525oRF3v/O9B/RZZwQL3Bk1smbdbpvqQwxrBgWnvDmi6bWT2TJ2RoSTI3WQOyxDnayFz4JoQwMt2ZAlUmFgye2AnYEErSH1vXOARrBwzPWlKj/GM3fT80UDKfYZ7JeT3DSrWVNhQXkT/eGqaLQs7ppqGgaTr377qMv559pNLYZQ0RbN+rKMEPxLy4Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added Suren)

On Wed, Aug 12, 2026 at 12:54:45PM +0200, Pratyush Yadav wrote:
> On Mon, Aug 03 2026, Pranjal Shrivastava wrote:
> 
> > The current KHO restoration logic assumes all multi-page blocks are
> > split into independent 4KB pages. Break out a helper to prepare for
> > supporting high-order non-compound pages.
> >
> > Extract kho_init_high_order_page() to handle the refcount pattern
> > where only the head page is refcounted. Use the helper for folio
> > restoration that requires a similar refcount logic.
> >
> > Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
> >  1 file changed, 19 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 4834a809985a..e836efd98795 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
> >  }
> >  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
> >  
> > +/* For physically contiguous pages. */
> > +static void kho_init_high_order_page(struct page *page, unsigned int order)
> > +{
> > +	unsigned long nr_pages = (1UL << order);
> > +
> > +	/* Head page gets refcount of 1. */
> > +	set_page_count(page, 1);
> > +	/* Clear head page's codetag to avoid accounting mismatch. */
> > +	clear_page_tag_ref(page);
> > +
> > +	/* For high-order blocks, tail pages get a page count of zero. */
> > +	for (unsigned long i = 1; i < nr_pages; i++) {
> > +		set_page_count(page + i, 0);
> > +		/* Clear each page's codetag to avoid accounting mismatch. */
> > +		clear_page_tag_ref(page + i);
> > +	}
> 
> That's sneaky...
> 
> The patch _almost_ looks like pure code movement, but then adds this
> little change. I'm not saying this is intentionally sneaky or anything
> of the sort, but these kind of things are easy to miss during code
> movement and should get a patch of their own or at least be called out
> in the commit message.
> 
> I don't know how page tags work, but IIRC when the change was originally
> added by Ran, he said that we don't need to clear the tag for tail
> pages. That held true for folios, does it not hold true for non-compound
> high-order pages?
> 
> > +}
> > +
> >  /* For physically contiguous 0-order pages. */
> >  static void kho_init_pages(struct page *page, unsigned long nr_pages)
> >  {
> > @@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
> >  
> >  static void kho_init_folio(struct page *page, unsigned int order)
> >  {
> > -	unsigned long nr_pages = (1 << order);
> > -
> > -	/* Head page gets refcount of 1. */
> > -	set_page_count(page, 1);
> > -	/* Clear head page's codetag to avoid accounting mismatch. */
> > -	clear_page_tag_ref(page);
> > -
> > -	/* For higher order folios, tail pages get a page count of zero. */
> > -	for (unsigned long i = 1; i < nr_pages; i++)
> > -		set_page_count(page + i, 0);
> > +	kho_init_high_order_page(page, order);
> >  
> >  	if (order > 0)
> >  		prep_compound_page(page, order);
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

