Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6129D105F79E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF45F6B0088; Sat, 14 Mar 2026 05:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1BA6B0089; Sat, 14 Mar 2026 05:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD6B6B008A; Sat, 14 Mar 2026 05:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3CA6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:24:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C76BBBCD1
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:24:21 +0000 (UTC)
X-FDA: 84544132722.09.9A7402E
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id B79D540007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:24:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsK5K+Vt;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773480259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/26zDPIzlVnVYCAwRg8kCyAuGthhfTM/GMXEiZ2pHbo=;
	b=L8bN76pX3I/1ZpZBLfLXR1hsfdNJn8fjcfP5AJCcLP5VX+SXQ0hXQC9vcqvaq4AOQmV+gD
	IKhOVAOXylelGXsjXClB0jZmtLvdlJAiitAs97gJC3OnnbyjbODk6kw+1Y9yXJPSN0iEyc
	hrgnsOdGYbSub+8K08bDv93AaOl4o6E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsK5K+Vt;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773480259; a=rsa-sha256;
	cv=none;
	b=QRbBsHGOGoXyCqpk5MZjGdsiiy2/+1UR36KNPua8LgMEsNkXLzbxVS/kRR/ofkIFyGwsSs
	VBxlo3FpzO0hrrugG6WkIktZR95dSvGgPrui81rpRBtW/qVk501/r0NhwIqO8jwJL5oksJ
	8LPzYKdTjgcKomqzX5gDNyrdDzWK0w0=
Date: Sat, 14 Mar 2026 17:23:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773480255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/26zDPIzlVnVYCAwRg8kCyAuGthhfTM/GMXEiZ2pHbo=;
	b=UsK5K+VtvTiQ5S8BBGmYWe49Esw4gy18Fihlq6Z5+wcdAnSu7ohQN/XHcEXN0WABLD3qkN
	m9Hul48NC7OWfG2ZJ+CczRuUVwRuVKSzHwvN3XHggNsSAXS/Yiz13b9gJeRlt7wMTeMrbY
	M7FI7iJ9T2jbcaGU2fXwFiJQ7u/NML8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: clarify kmem_cache_refill_sheaf() failure behavior
Message-ID: <dbkgniglboyu5m65vlr4uygfhhjv75vgtutg7lky73tyabrxez@vnz3x7fhclli>
References: <20260312114309.213731-1-hao.li@linux.dev>
 <abQExi4z2mhCzKPw@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQExi4z2mhCzKPw@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B79D540007
X-Rspamd-Server: rspam07
X-Stat-Signature: xmehg3saipxrxda7nepjdzrdci5p7nnz
X-Rspam-User: 
X-HE-Tag: 1773480257-786144
X-HE-Meta: U2FsdGVkX1/RiVzP2uAyE0R3HnpSpyRnAQ2IYBX6ycn4rRi1AKlA8/2+KJq9ld+vriGYDHD76fVUnRNKgBkkwOeusCaH3V8Zxtm79UvHAbA0L/kA2+T9OcQeyTh+lG0d6kX65dmgpkMkylGaVEigHinFflTMlUFienpMvYPz1LKP0pw5BfWebM9JTpqpn/CoijDeUPumxQKSohRbUTRT8rgYL/JvUB1zv7TFeD7g7q3CR2dCZVd/mAgrmaVYk4vzqYMaKaHDxBc3o0rQpz7hSroBONr6Cc2LekKzet3OhnV003oLq51shohABVnLbqJd15pSyNrCzffbZHUM5DgB789O2SFgMJsXm4Z8P4smXhLgxZdGwB9/TJXCdppyvTvwSzFGqOKAEcidSIna/2Ooa5gSsz91/sn+xNSD9/6dMfHtiVnCwU6RAfsMG12CIFAGwdpi7axN6gCF3J0KcPWa63HiGOcfesArGXpcMRqTD3xhXSCD+GjFdBRTqWZ+yUlIJ5h5w79slf4f5b0VhZxV41Y3kTQm8cRAz5uXrbY+75RXh6DFjDrOT/M7JsBlziYHCWm5B5E/fK198qZRmk+cUOKMhp+zk7A/BBLIjCMW/HE8DG5DqsegGVfGTmScRTD+96RGew+CahoymKWmGGeGPyQbLYp0vEFEt6r7Me31gjl8ffauvFQZBWkPXSOd0m44WuLFV+y2/Vy5TV6UwiCioEe3arG0WnD32OP8Hv5ZLmnZiyBQCkhTjUHRLDRGnlVl3uOo4KPyuu72TkvD3nR8gdFIQFHpa5DSvzD90j6hKOF+PB859gHqtvx8uSTXjnDmEoemgmULZfn5av1Y7LNAdAX0DWwBrw6Lo8aXWXQTtB84rzOBs1S2EcEDjpIf1/7X6bvLh8PjavMAofP6ale0ru566SnPTbWPH8HOJzYDHel+9hRHfTqTDbOKg8fqblBeG5sbzVOAk/Kgs3wENg+
 rb58Ofvo
 jPdhAKAoBJvi1bOpb++w8hvh3+S7RUE8dEg4w75R9awh7t77XS/v//TX6yCvnW8CYFOxUuPap8Yg9ucp/Nq53QTV9J4f353HFElKqeHS+PeCF2G5Og8aM9vn0sKu/qB2dHpzHir+KKCTaxRE+Ke1mRCFntUxG2rXJadS91zSOKmkn9yFSpWk4/Oq11VC0Txdi8P8ylCIfA1HlS2ehGq7vUTufjVYmRWnE5ZYh8vT2wBkKDkQ8OaHYid8WeCeV73y+eYm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 09:36:22PM +0900, Harry Yoo wrote:
> On Thu, Mar 12, 2026 at 07:42:25PM +0800, Hao Li wrote:
> > kmem_cache_refill_sheaf() can fail in two slightly different ways.
> > During an in-place refill, some objects may already have been added
> > before the function returns -ENOMEM. On the other hand, if allocation of
> > a larger replacement sheaf fails, the original sheaf remains unchanged.
> > 
> > Update the comment to spell out both cases explicitly for clarity.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >
> >  mm/slub.c | 21 +++++++++++++++------
> >  1 file changed, 15 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 11a99bd06ac7..8ae248b5b384 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5005,14 +5005,23 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  }
> >  
> >  /*
> > - * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> > - * the given size
> > + * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> > + * the given size.
> >   *
> > - * the sheaf might be replaced by a new one when requesting more than
> > - * s->sheaf_capacity objects if such replacement is necessary, but the refill
> > - * fails (returning -ENOMEM), the existing sheaf is left intact
> > + * On success, the sheaf will contain at least @size objects.
> >   *
> > - * In practice we always refill to full sheaf's capacity.
> > + * On failure, there are two cases:
> > + *
> > + *     1. If the requested size fits within the current sheaf's capacity, the
> > + *     refill is done in place. In that case, a failed refill may still fill
> > + *     some additional objects into the existing sheaf before returning -ENOMEM.
> > + *
> > + *     2. If the requested size exceeds the current sheaf's capacity, a new
> > + *     larger sheaf may be allocated to replace the original one. In that case,
> > + *     if allocation of the replacement sheaf fails, the original sheaf is left
> > + *     unchanged.
> 
> This is correct, but users of this API probably don't need to know the
> implementation in detail.
> 
> I think it's fine to simply say the sheaf may have additional objects even
> on failure?

That makes sense.
Too much explanation could actually distract users.
Thanks!

> 
> > + *
> > + * In practice we usually refill to the sheaf's full capacity.
> >   */
> >  int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  			    struct slab_sheaf **sheafp, unsigned int size)
> > -- 
> > 2.50.1
> > 
> 
> -- 
> Cheers,
> Harry / Hyeonggon

