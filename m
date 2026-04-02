Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72CDCC6B35
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 09:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD7A6B008A; Thu,  2 Apr 2026 05:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE596B008C; Thu,  2 Apr 2026 05:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3B16B0092; Thu,  2 Apr 2026 05:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCC1B6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:07:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FC38E1076
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:07:47 +0000 (UTC)
X-FDA: 84613038174.10.41FDA62
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id ABC111C0003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:07:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B06f2IHC;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B06f2IHC;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775120865; a=rsa-sha256;
	cv=none;
	b=2aFLkgVGHIfiHvqZo2s4oH7mwCOMskLVWUy3/thJkYHD+USqLDTb/4brMx4Z/qKJrhKTsI
	zLp1XJsW3LUNGkhpucpopxsNFLexMcbqCDyv08I9rcd2ZruQZ9eeb0OOsXcsTFQdi4hPQ5
	h+gAHk6OOO6FhPddkgjspJpBFTrV2xw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775120865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBn01IuI1LdTbc0OwbYPZveJ2JJ5p4ySRGGii3V86h0=;
	b=xlj/Zl08dB4pDlbTTePltlqfhGf8YU51oqNHYZ4e3TNn2IAs4ReIsEsxsnesP0BCZoh3lX
	yF6fk32GASbTKv7BHjcbImJ6lHJqsRoXP1sYs2HN3yqTmIjgkEBA5bMRt52HNJPWp/pBKk
	4LPLcFu3JnkV7I7kO5HeA295pn8B7M0=
Date: Thu, 2 Apr 2026 17:07:35 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775120863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xBn01IuI1LdTbc0OwbYPZveJ2JJ5p4ySRGGii3V86h0=;
	b=B06f2IHC7MUfIRB5kAXbteTXMpJIFkEb2d/dDU10U9P5Ym3Mu5PL26ITw3Pmhep1Nu/Fw5
	Lhl/kKO+hGJ2D5uml4k6JSoedV4pNtzLAToTHpUgWhMLfx7GyIdGlpyjEb09agVG1xRyV6
	Czws7crLmG9zbtIvWyQvNURlWEwYI9Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	xu.xin16@zte.com.cn, yang.tao172@zte.com.cn, yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: skip freelist construction for whole-slab
 bulk refill
Message-ID: <sulhwzij76rurwi22fxwegf6bm26efmkz6tqeey22ismy3z5z3@ml73mrdwlibb>
References: <fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x>
 <202604012156491419-Nl283guZ6jw8h0k2omv@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604012156491419-Nl283guZ6jw8h0k2omv@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABC111C0003
X-Stat-Signature: xcmb89pibknz81m9i3z53timuxgzasr4
X-Rspam-User: 
X-HE-Tag: 1775120865-635885
X-HE-Meta: U2FsdGVkX1/urf3NyoSk3KOS7L0nuWAj3ziQ+vvC/Sq6YjGgVxjRRExvZByj3t93bRywWBKuGpnYV9aPsSQkRJTLF4hw2pXiO8Gzz0XwvY28UNAnnF0Cs1Q0O9Cwdr4sLxkRLBfeqOrnv2QAw2EQAJvAuBYOdxA+v6gF7LqcILiE8rPFFJ8ZygsLnjJzL8HAxRovTGk33FTswotDUqIvaOgkDtw2fk3gY/cHOojniI8Le7QccKyVnQgssVN5dEG+L49Z9Te4uuIOkr3hSpAfatkG2+K98c9QTVU8c6G/WW2azlRqNCBBS8UaC/hJ4d9EkQjuBM7mBO4yoC80uA0CwSQwLXbN3xn6sZxJ4dHxv7Qt4Oe4vhEIR88Yu5T5q1ikD5cnEGfjjI3peZOvnaNQ+nFxj6+EOoM7CqxPyDMpx5MwLQHYZVZ3RIZAumS7rkeQJQonqflWOadmh+h3xnigvVXZReVO9YOLDWdUfO4B+cOeRcBE8gEXtHQxBFtNeP9jQiMh7v0C37YC0o81SLdzkBuXAuC6qrcKEnPSOBs1lFPIw7Rdlr+jFfDYoAhTsxkPTaByu0TmiNAhvKWfrWml2nOuetNX29s6qCp9nLIF9nV4dYSREC9JUt4Bm1B7/mWcXsFHTO5oD2eobjgYIRNB16iJrCCnOAuJZfY1uARsW750VJdrg1JOPaaKmTLA24K+eqMGPIWrbbZLsaHr2mciYMAqQ/PFxEra/F+vBj8I/glFiKKeTMToFXw+lQgaWCjjNuTpMNSpNgh33h90VpkOlxRor7sbktXuMwHzTJUEy6veN5s+WrF1wNNeCcnzuapdXrS2l3feHkSFCKsbHh8oBfATNuB9Kr4MNODO3W1DmKqnczjb8PoD5v3liAohWEdFPTktmX2ZLSl/qQW1VYInvezssIVERfoBnIRwLFT6VAdfCky2L3BJP2cReYCsu45Oxs9qAn+DaELkOQclUQ2
 8s956FlA
 odSf0Pwv/4PAqZp05WLtl5ov9jNdVfcAAQ+y6KY0jkj86VmiQpD/3UsLQM2sqhWAQzXHVi0Le9bM2F03DejsJWLvzAZBubcnmK2e3MVY/7CKHlXXCs/mbq78ozur4taOZugCtnQD+AeK1hvkGTdeLZDoR1ZzULxO49W39XWk5POKLpFvqwFgv0eZhUxhN+XaETLOAfFSKbe/uzNSzVmof7wUFQ3AW9MgR2g5QIEamc6XElEAYWrOZ/c5ZipQx1vyqzmOw+EIqSVGtteA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 09:56:49PM +0800, hu.shengming@zte.com.cn wrote:
[...]
> > > +static inline bool bulk_refill_consumes_whole_slab(struct kmem_cache *s,
> > > +		unsigned int count)
> > > +{
> > > +	return count >= oo_objects(s->oo);
> > 
> > It seems using s->oo here may be a bit too strict. In allocate_slab(), the
> > object count can fall back to s->min, so using s->objects might be more
> > reasonable (If I understand correctly...).
> > 
> 
> Good point. I do not see s->objects in current linux-next; did you mean
> slab->objects?
> 
> oo_objects(s->oo) is the preferred-layout object count, while the actual
> object count of a newly allocated slab is only known after allocate_slab(),
> via slab->objects, since allocation can fall back to s->min.
> 
> So I used oo_objects(s->oo) because this check happens before slab
> allocation. It is conservative, but safe.

Oh, right.. sorry, I misread that. Please ignore this point..

