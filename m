Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B41CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E656B0088; Fri, 19 Jun 2026 04:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525BB6B008A; Fri, 19 Jun 2026 04:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F296B008C; Fri, 19 Jun 2026 04:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18E5F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:09:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9835AC1D4E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:09:53 +0000 (UTC)
X-FDA: 84895938666.27.F827E33
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9BE8140014
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:09:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XpFYsiGQ;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781856592;
	b=shJhp2dXEr7Kc+kjVjtWkRIEECzkN6C8mVgwcctL3G2Q2UTnPiKGJKs9pPyQXu83/c7gED
	nb42dqzQQp2Kal+eAGmnLXbrL3lXj14IJYKcM/1rEbT54WDa2j0yfY52wFXd3rOzot6Ce3
	PZsVJxdOtX/ukaGESRMwKxFz925Zv3I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XpFYsiGQ;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781856592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVvrfHdKVlkWU88SLenudF1VwsMgMs2vGchEywPlSls=;
	b=NC+dVG0yV8d/W7SVdDSVchflxbtCy31Kb2p/gPyZZyuVxJ1Or9tAFRl74p+mHwow0l1+lU
	356iYdWUMoU35qd8Tyga9ZV3TBmFcuC7ooeN7Wq986szD7ZZjbplqHTm6ck+qwHZnoGpAL
	0AyEs8UdGiiF4Y/rtmqVnVgblr3hj+M=
Date: Fri, 19 Jun 2026 16:09:35 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781856589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yVvrfHdKVlkWU88SLenudF1VwsMgMs2vGchEywPlSls=;
	b=XpFYsiGQv2pL5zw6fLTyYK00qQzKYChVCUvwpw8EmY7yk9ZZWVfUWrvCpDK5syPLL/nhR9
	cSfllERlD584EVpnpU4p6RPrtDFFmSZpbqmdgK0ISmXykmeQGb35Mo5C4ZxtGSQ8bGMZ28
	hmFY3IaRnCY3sdPC7V8GioGl7xo8et4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
Message-ID: <ajTzDB7duDjTeomc@fedora>
References: <20260618100913.346636-1-hao.li@linux.dev>
 <f3804d8e-f615-4e0e-91de-10a97f26643b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3804d8e-f615-4e0e-91de-10a97f26643b@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BE8140014
X-Stat-Signature: j8iorbgqhi7ad9ag3gmipn1cufcwat5w
X-HE-Tag: 1781856591-803314
X-HE-Meta: U2FsdGVkX1+9+iPofqGiVwEgmY0Uv4eBiklxwZn9DClEAiZV2GsjwQnMcGWZifdLleY4OGc9Zo68btpYYVk0CP8KBjZPBsROzNFlCHwrge6bG2WjPXNi/hgQzo6hLwQVfVDEGCePC+7i/JU/R9bjMzD9UXt974R0VatY+kub33ehdcfC7pw3x9h3Tt3TZ5YKU5j8LwjlTpvBSBnK5LZOF2lSPwd9T7P7FZo/WtlP4w54JIztQdRQV+ZU/X52xI+0rYnkJmO25IDGkUXLSJSanUskEXrnO1imeBPluM0mNKA1JR7qrGjkP0AuQoLpJdWMEKCPDXiFRIbu9b/iZLFL3xFdyAcf2WQZ8bvpVyWUuPSofVwzuDRg63Af9p6hiDxwSbKAa2HFxfcLKHkhdYIXOFwtlr3KWmqRQY0S8Ov8QoFxIFzQR4Cd29xLV0AA7/+bcciawFtuKXalK/+TKq4DueGn9IWT5JYVs8QnQZaWl3v5SfEwTQ38uINe7oOY2hOFcoVR6ca4815ZTHLb+87pG19VlR1XVHHp98KOxRQ7BNvmdZo1P7U3qAdQu/7vU+s5quE34IiaM+mt2QnkREzV64dzJHdB4Lu0ylswsfA4htWtXTlLlLGzjMDryZd5LRrrxCjCzcws0NF5VaY8dxiQivqhrtvKji26T2BUwNb0mweksibqsPUmO39dlJxTfNYekf1703sYRXH91S16Lb3JsTLpF5k8YCeIMta0zUHcPRxWQfSXeq5/SLhveyA4fSy383246VGbx/GX5odnsv4Zjq0Fo5dr02hXln2duc2w+fMVM2t+kKjPxhm7+oo4HtLijVLIYgGcVGc+ITmYT0knY9ud70aViwEFDnfXdoO4oA1H+5LJ9VB0kznYoL9+SnC5y8ktYaFlYtgaCrxnmewNcaNk8YRIKaf+obUtCmLIkQPk4Z9gn37HbROALql4BalnXg4OmJSdDEHuaaA6w1P
 mFoLFTgm
 2qJlbowAe/Ff1KL0uVShM9B7iL94zh6Xb3aPi0/G3bFdpbDQE5jiD/wAxcyMNO9nkxCaYQHK3DuGac9VITtB9zxNzqu62cR6WTOqNXcSas+rfAtsyWP8T/vKuHbdAwjn9PtV7a2lcEO0yW9fO2Xld51PmKLK+E1eTeRD4R4FyAO4C3Jn3fyUR9X/FTzOrRzHEfdUK+Iq2lCsnDLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 02:50:04PM +0900, Harry Yoo wrote:
> 
> 
> On 6/18/26 7:08 PM, Hao Li wrote:
> > Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> > NUMA policy independently. Since they are called consecutively in paths
> > like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> > redundant computations.
> 
> It uses a static key, so probably just slightly larger code when disabled.

Yeah, make sense. The performance impact in this case should be negligible.

> 
> By inlining both __slab_alloc_node and alloc_from_pcs(), I assume the
> compiler would have deduplicated it, but there is a patch in
> slab/for-next that makes it not inlined anymore :)

Thanks, I hadn't thought about it from that angle before, and that's a
interesting point.

Building on that, I thought about it a bit more. While in theory the compiler
might be able to help us here, some of the information inside
mempolicy_slab_node() seems only could be determined at runtime. So I suspect
the compiler might not be able to infer that the two code blocks are equivalent
and deduplicate it.

> 
> > Introduce a helper function to resolve the NUMA policy once, eliminating
> > the duplicated code and reducing execution overhead.
> 
> Nice! I think there's no reason why we shouldn't do this.

Thanks!

> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >  mm/slub.c | 72 ++++++++++++++++++++++---------------------------------
> >  1 file changed, 29 insertions(+), 43 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 62e9cd46916f..45e9f379b7da 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -4523,32 +4523,36 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
> >  	return object;
> >  }
> >  
> > +static __always_inline int apply_numa_policy(int node)
> 
> apply_numa_policy() is bit confusing because we usually don't apply
> mempolicy for each object (unless strict_numa is set), but rather when
> grabbing new slabs.

Yes, this make sense. it's only for strict numa mode.

> 
> perhaps apply_strict_numa[_policy]() will be a better name?

Agree, apply_strict_numa_policy is indeed a better name!

-- 
Thanks,
Hao

