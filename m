Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED2BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22BA8E0007; Wed,  5 Nov 2025 18:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9A88E0003; Wed,  5 Nov 2025 18:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9128E0007; Wed,  5 Nov 2025 18:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3168E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:58:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24313B9DE0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:58:29 +0000 (UTC)
X-FDA: 84078220338.27.725BBA2
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38046C0006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:58:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVeMDr21;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762387106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NAdb2RYMsOKqXCLjIHqi6asFca+VS2/BSmuj46dnV0=;
	b=VWbrlQXxTozY/6jbh4bxxCxwhZe9oM8VHZsWnC35t+MZaEnPAokanVKhGv/HmwX17pnC33
	63v/c8aYVr0C77Tf98FAuyWl6B8D5+kNKbgk8jFHirWUpLe4QuxoIUNQGfnvcpG87T+omH
	ADzWFoi44AxFsyF1J/sTkt1aly2w64M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762387106; a=rsa-sha256;
	cv=none;
	b=JIyRkCtjhafJbpQWFvsZQPTHOwztEbFnNoZEK5hOW5cSN/YMU2FWE9rRL3njVn5hdebsWS
	P8yfW4YTm7zZAwvNRA7BoR1ZQQ4u5Ym/l1aIhJ2YerC+ClOTFPfEPc8nQU2+GG973XYeEc
	FAoAmQJR7T9E7SZCJ0Yu0mRQcfDoG9w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVeMDr21;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340c39ee02dso424951a91.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762387105; x=1762991905; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NAdb2RYMsOKqXCLjIHqi6asFca+VS2/BSmuj46dnV0=;
        b=PVeMDr21l7PdGU62LEHTO/LHMEVGNZPr6I9XqdmTkkoRRx5mg8NXrwsIx3dSTh0V2u
         NxRSVt/M3JRgOsJYPbCkEkS1qDJogiCkhUwdmP2KjHXnursCsdkRAzvnnmnneRF2Og95
         xow22rPYc68CYO4z+4CD21qnG+sU+VS8lD37oINOuV7Rl8l4gU87o5VQity4EeUsDHpb
         A5KtqR5yl6zrR1XBJC4L8yv6kuEWzyejCWC9kdzuhxTnYNqg8hVsjuwxf2MIV0v4P5ho
         g39HxDiH5HR9f4+JEgsmNCD/ngndvPKQGCD5odWwKYe8WrADCHlq2Umm3pg/hvnUnv1W
         5P1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762387105; x=1762991905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NAdb2RYMsOKqXCLjIHqi6asFca+VS2/BSmuj46dnV0=;
        b=AL40ZUsRiQRoQ5FOz1DlJ9g50R7VtPKsadg/DZmUmtb+sGcbIPhJyoUWVC70b0TNny
         d0bQCs1E32TJHKjs1ED6tZRfB3JH7DV3+D1iLxRT6gs6u8LpE2IEtGg/G5y1WqwBpeuS
         t9DTQ0C8X+BKIonYlKJavbvOxSQ23QYauDRa21oiCFg6hI1GZq4bdziSjSt+8Cd8T0K7
         FODcT11a/au6PPqp+oZ517oQopxTvIAZErq+7+aH8aVRzyxiosuSkKUpT2i+McI5F1EG
         cUJVF9X2qurnLxQFFMg3SRBf9+RpDjYLL7v932qai9obZu7Dc2gjbm93QOspRYTAXWcc
         EOGw==
X-Forwarded-Encrypted: i=1; AJvYcCW8wMC479F0pZ9KI4oUfZpb42L9ZZykQviPAk0zFhFaWAatr3dGOsbwASu7dZ7pgkrne95TqfhOXA==@kvack.org
X-Gm-Message-State: AOJu0YyEx9nEw8tFhqmvbIq/dXPrzX3x4T33Sd8q7lDl1VaE4SDoEEa5
	TsM9JBEX+YlhKJmy8vNyGRuFOUANyBCf0TBvIYgVjoqHDx99zoOobxVh
X-Gm-Gg: ASbGnctINERUzjhWQ3v2QI8TfZGhMTNI3POLnCa9KwmsZHjYqyhC3ldhMTMHxTd3n8q
	Z7pSYpKXJnzp2BBAlKQ7T0M7BCkiZoS/Ifn9yQDWBezLMG2zShFbNZ7Sb6qIHJUJ41S5uYDE6z1
	IYZ69vB+vxdBGSMB/lYtnevMRpphhrbuhDUyOI+J+5FfQ97ilJkm+LDIw8PQHMfA3c/Jt3PKdtz
	gH18emVUCU3lyIyVZStjedbUnuEGiwXCkpQB4Fe6v3PjLzTjwxS17aReX5E1MDeFLoOm8Vyygd5
	FC/e5r1bCWPylZ3PLbR+3swgoXtNnJn69TGPDudlrnUcur8ndtqfmEzZWmd0V9EIa9wGibzDOvE
	QFsdC26099bNSGPfhVO60VXPooAk0xCNHsxm4XZo+IU/TOsvMFdUTr/+y2mmgqKVQq51YHLZoQn
	hZfyeAfSwvYOEhixtsWu4Kq6w/IP4b5uYW
X-Google-Smtp-Source: AGHT+IFZB7bBXnEbqvebED2T2KOf547Mj9I4EsLz2bjCgt2rcDFuTIl4ej/PgGwJjspkGhoOMyEb2A==
X-Received: by 2002:a17:903:988:b0:290:ac36:2ed6 with SMTP id d9443c01a7336-2962ad1ef70mr72459715ad.14.1762387104985;
        Wed, 05 Nov 2025 15:58:24 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c7409esm6967865ad.64.2025.11.05.15.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:58:24 -0800 (PST)
Date: Wed, 5 Nov 2025 15:58:22 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQvknlh6n7ncfAlA@fedora>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
 <aQopoAj3i2jdIX6V@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQopoAj3i2jdIX6V@pc636>
X-Stat-Signature: 4ss44ozfm3c88juica8rdc3szwmxnhx3
X-Rspam-User: 
X-Rspamd-Queue-Id: 38046C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762387106-5198
X-HE-Meta: U2FsdGVkX1/eNcwerL1XEW1vtIRYSPlksxCmnmYan6LSPMxAOAcAiiCV35BeKbxUD5UNQApjqSlH6IKU5ifvK/tvRn+RB7iPumfrXP8D8mDKeSjS9TilnaDWsjDkfnFK2eWf6VPxdx1lJwz09WLSTBvzPtOa07ybv+KKjHN7hEsYEGJb74A0KTVsCEaaBaOjwE6rgSJkaJjWVnsJfTFXvg+QhKL6NlErSorT3ClxlRPEmgMTgBnp6Vm+//o9UYSIA1FqchWmKjbW/FWgL8lpjGUiUHcyCzmbOkOXkony0KY+MNKUxovjBpFTkNAIlvkswb47R5N53nMhJrhoyme8W9n4WwDCXdzzGcqGE4jDV/i8nZMLnZYLZychCn4v4ijC1J5WYAB9FCdsquN/yZwvIMYHe14Aca1QPjH1X09gRhm8IqJErGIsj9hSPuDpWVhd7kvSfJ0qq8RZZ5xPmjz15oOnKQ9+JRDZEWeEt+ArYPU8NPpcU1anjf6o6XQTF+n77t6B+fzGMIhfmyP7xovIdeyEvApVYY4tDU74cUiXUsCpNqQTqAYvfMnlPtfREpCberAqPn6zIZJm+bsMWUWQh1y/X1WJu14imYFWaV/Vqs7W3/y0FBwToCmVDz/HSHXtOJ4vD+5nF25voHQ9VOruME72bg6tyMVQlJ8wcWOixT9zDzowPOJh+wEA5X/5CwRVWDulBePiW9ew599Ul3X8Ppo5mvrWJnbztIyBbm+WMT9S8/Cpbc5Nnwu6w+5phmOU/AX4EbbhiRo29VnjkypBQpxnyzTPxm/tkUtf+L1QuAoZVtSayk4OqerqTnHM2oFKBcSFPhq2mRs8GE2i/FFe7YgaQPKTlVFBrjeaNdCdRnTjBVb2zG2H9DNeU3iFlktp4Kg1JWOcDSlf3MpX2E6/GFuTMX5QmRWIwpBNPpek5nrkq0D2lwcV+hPy4wIYFc5WF8ZF9lF+AmA44v7hvuF
 iE5sKWyZ
 ODDg1/8k3yS8GOmItR4TOzySqCsMbLpSR9Pui1UE6j9aMqtc5UhNU+KnJHCsNFvfg5YpVw6Om3N1kY+16/H+prEaxf4nFviWK1k1HADdqiZ57J4hmY3+F9B0WTk5j0nKrb0NlwkkMv9eqQrkYMD/b4mPt9e/Xw8xhV1AfJNEqmG6hECGfwj08uwi0dWEZEb3ym235qSZxLvjqS6g5VTcJguBI9Ymte/ThEQ6Ew6clfSELLU2J5E7Z2urUG8VkOwaITZdrtIg09u4R39m8AnTYiEYOgACmGuPeKxnmgmbA5F/ugSPEHDGsUwWqwyGikwBI3tVM8BIq4yka0S2pnGEFzV+kNh7bDKeBLmKWqXkAZC2ICptou/wPw4Vpr9WND2lgXemO9793KrulCxPSSLt4a/ETT0M9awX+/bL9ydalCV1FqYj6Y4w0MakETVZzr3OVEMPHJJ7Dipx+jEnqhRaHyXfb6TMObtNgPTmcXINI9oy36a5/Evg+R7Pspk8CGt+Np+aD4kJlms8af2JOmqNto8W1PUoPrKdkHExVTqAnR7tlDNQyk/0xDRhzhB/B8HoMD6zfhTmSeicknRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 05:28:16PM +0100, Uladzislau Rezki wrote:
> On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> > Vmalloc explicitly supports a list of flags, but we never enforce them.
> > vmalloc has been trying to handle unsupported flags by clearing and
> > setting flags wherever necessary. This is messy and makes the code
> > harder to understand, when we could simply check for a supported input
> > immediately instead.
> > 
> > Define a helper mask and function telling callers they have passed in
> > invalid flags, and clear those unsupported vmalloc flags.
> > 
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  mm/vmalloc.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 0832f944544c..290016c7fb58 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > + * This gfp lists all flags currently passed through vmalloc. Currently,
> > + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> > + */
> > +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > +				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> > +
> > +static gfp_t vmalloc_fix_flags(gfp_t flags)
> > +{
> > +	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> > +
> > +	flags &= GFP_VMALLOC_SUPPORTED;
> > +	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> > +			invalid_mask, &invalid_mask, flags, &flags);
> > +	dump_stack();
> >
> WARN_ON() or friends? It prints the stack.

My understanding of WARN_ON() variants is they're used for internal
kernel concerns, while the pr_warn() variants are for situations like
this where proprietary drivers can cause unexpected behavior.

> > +
> > +	return flags;
> > +}
> > +
> >  /**
> >   * __vmalloc_node_range - allocate virtually contiguous memory
> >   * @size:		  allocation size
> > @@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
> >  
> >  void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
> >  {
> > +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> > +		gfp_mask = vmalloc_fix_flags(gfp_mask);
> >  	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
> >  				__builtin_return_address(0));
> >  }
> > @@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
> >   */
> >  void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
> >  {
> > +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> > +		gfp_mask = vmalloc_fix_flags(gfp_mask);
> >
> gfp_mask = check_and_fix_flags()? 

I just mirrored how its done in mm/slab.h. IMO its cleaner to keep
the check out here and have vmalloc_fix_flags() stick to one thing.

If you really want it as check_and_fix_flags(), let me know and I'm open
to changing it in the next version.

On another note, I'm now realizing I forgot to mark the check as
unlikey(). I'll include that in a final version once the other 2
patches have been looked at.

