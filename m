Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA171CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 21:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF956B0088; Mon, 12 Oct 2026 17:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB69F6B009F; Mon, 12 Oct 2026 17:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4236B00A0; Mon, 12 Oct 2026 17:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8206B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:05:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB85CC0CE6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:05:08 +0000 (UTC)
X-FDA: 85315204296.21.5C83408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B63618000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:05:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6KuxaON;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791839107;
	b=Uq3jVJCj5/EXx3NJ30tQXtG6b6a0TNHwfCqZgg0zZlWvw0p0QQZz3qJHxUD5eCLYxUBQil
	tBrM1w5tiH0MjejuVtN+y37csa0AsaWQ92A9+bk+TsUQ/GcUoZ2z+z5Ia9go2s4+W1zXmD
	FqwHIUj6dCHR48sZKvtV48CeYuMwnw0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6KuxaON;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791839107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEthCKb0rkLjJTmItEReVKIpiCN+N7TNwVq0rSj7hO4=;
	b=ozLJ+u8Zmq0uT/KVlbIQwmbdxhzUVx3LqBtn8xacSdW/G4cX16MOqEpChCwprA8NIqlnRo
	JKCfsv26Q2vTqPrEUMSfdR9Vjt1IMs3icVbu+7tdWCXCdfSfgepZaVJtA0yaWHwhwzJxSO
	T+IGrmysn3d9wSI5Yst+TlkaV5fLzfY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3B6E601E4;
	Mon, 12 Oct 2026 21:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC491F0089B;
	Mon, 12 Oct 2026 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791839106;
	bh=OEthCKb0rkLjJTmItEReVKIpiCN+N7TNwVq0rSj7hO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C6KuxaONUZ6vdX4/61BIkmE1jjMCaFkuoNssbRGuxhkoCoRChHiehx/gflbLzFTeg
	 ePOcsf0OZjJENTZ+rxQ045XvO2AzDuRNVvqnqgK2D8ZxHtPOQXKbAmkVAAaFMN1ZOH
	 5e1S5n3vivd2CiL0xcGXjF5tiT+7ariYKigSpk9BjeIso8kyBUgT03n3Big7tljZdV
	 0IKhGJUaoh3AejelgkYiqRzPYeypahhFE5zfrvqtWCZkbN7ALVTfUqUgkY4GMZbIj+
	 A/nSG7mgEh1s3SbdbAkEJGvHiBwYKT/Q9TjSH0/p36KXG6AIsMCYaeZBYSO6Hn8kso
	 SjFx/g21JgAUA==
Date: Mon, 12 Oct 2026 22:05:04 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <as03h8sgRzpw7JXI@thinkstation>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
 <202610092014.AAB20B81@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610092014.AAB20B81@keescook>
X-Stat-Signature: n7yaotngm6hgenucjy8bi18affpam6s7
X-Rspamd-Queue-Id: 3B63618000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791839107-381037
X-HE-Meta: U2FsdGVkX18MjaKAfkPLU6WC0MuEyNaqm2xfDByW8Q8Ks0M/elBq5Q6MWu/5gnOK4wJBpifypxIi/8yrjvYdK4Risny+dLod0NUde+udi2MFxNNuzqmVdzBZ0h5G19U7ySUR2M3e98uGGOWbN7ukVEakrX9iGjU9Jx579uUkAzV8efXrSq7Zcqlj8Hx+2Tmt5hb3R6D0cBI1krVYkBzNBxCvOZaHWmEv8uyobolcG+IWXkinfepdSKmuJ/uMO5oScYBiwK12FQ3QJzt7wCnxsr2AjE9bOUNsRxi/qbeFEfIGi/qu59gqR89i3D7mSIoHHBaM8EhpB0h2qAdbOlAKutt87zw9eaEFCRH5qDuWJQPW2Qt783fx+7QGkOEjshilBzl1Bxw55XZ9czI6ZYOtY/YrZwo+vUtDs3mjNotSWtUGhUBlc3kNICBPtVEyq7lCiL6QjloNiY6xUNhcE+QJF5IKlxHKn/E1cAy8yEdZrzkL9+oDk81T/YF+68bOY3HJPpTTzGKU+/x2llzgR7xj3t1ZMSxkwawu6B2D9PgczEse3neBYMn6CogjiTaEyREctdN7jinyeVp5fFWRL2c1FEvNcpi3SBEM94Z85VlpM62opNOH7JSi7cI4XmsnOQ2+lFUnV/0NoD4mElAbiFRI98hc8kzysg1Eg4WcZ2VIIrBJjIhM5fjhYzh6IVitCaKp9YjZWKfQyrzV68aoNixVwwkbeevRDhN4PDd8I94AG6mGD4xD+JmLmZTrsWw40Pb5m/SJNGy9eKoOqhA+RmJ4whaIuL3ink5GMbwXoYgyRqi8FDN88ln4mpCnr1DZQ77u8FBu+5inMLIvrs6y3pWeAD3hY7v1prtUMDtvMDnhZPQVPH4wf3HB/qoi+EV0sTisd2eVbnZaYlMoNaO9lL8SfwT4VJZQ+FDEkq4hLMn5W3JGTTGDNwqU6bJD+43ssPWlroaC7zjJOSgxi6iD4+d
 gpj0tuvw
 Cl9Nvwe4GoMb1Gp0j33swJOycrUDcKqcq/2vPOklasR01vp4WiE8jWccRtjTohLVwPX+8CjicNGLGKGVuwVLidQU8dT6mY48cHS2ycTCjHrxtToaIBOw1f92n4qiqote00CE4KAL2GHpD1wRnucSjpI4ocHE2LBwVBTN36sC/ucE99u+XWmkc4iItV17CFgbu98OmqGcvoczHkDqqbz5rhVR2pEWfkECsAL+Mwn5ppLYb4O/KdL+3Wch8pUZr97lilZRDtZ8Uga76oI0YHExlEjOT/RcsK+i1hPB6d16IBSp6xrdjOEafTMaSembl7oEgDVpE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 08:18:59PM -0700, Kees Cook wrote:
> On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> > On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> > > And now I see the initial kmem_buckets design did not sufficiently
> > > tackle the question "How this should work when kmem_buckets falls back
> > > to kmalloc?"
> > > 
> > > I suppose the kmem_buckets' abstraction should not be too tightly
> > > coupled with kmalloc caches. Creating a kmem_buckets should be
> > > conceptually equivalent to creating a set of caches with speicifc
> > > slab flags, size, align, useroffset/size. (for variable size allocation).
> > 
> > Just to clarify... I have a few concerns on this area.
> > 
> > 1. Complexity.
> > 
> > It's very counter-intuitive to understand how it works when
> > SLAB_BUCKETS is not compiled. My brain cannot easily process two
> > different implementations w/ and w/o SLAB_BUCKETS.
> > 
> > A "compatibility layer" allows us to assume certain expectations
> > and ignore all implementation details when SLAB_BUCKETS is not compiled.
> 
> I'd rather make kmem_buckets not have a SLAB_BUCKETS option. :)

We'll need some data but looking at the discussion thread [1]:
> I wasn't able to measure any performance impact at all. It does add a
> small bit of memory overhead, but it's on the order of a dozen pages
> used for the 2 extra sets of buckets. (E.g. it's well below the overhead
> introduced by CONFIG_RANDOM_KMALLOC_CACHES, which adds 16 extra sets
> of buckets.)

[1] https://lore.kernel.org/all/202404280921.A7683D511@keescook 

If the data still shows that the cost is still "dozens of pages"
for a few buckets w/o measurable performance overhead, I think that's
certainly doable.

> > 2. Making kmem_buckets tightly coupled with kmalloc's implementation
> >    details is not reasonable.
> > 
> > Let's say, at some point we make SLAB_BUCKETS always enabled and drop
> > the config option. Then all kmem_buckets users will now have certain
> > assumptions inherted from kmalloc (e.g. alignment), which is not
> > reasonable.
> 
> Until it's always enabled, I don't see a reasonable way to separate
> those assumptions.
> 
> > 3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
> > in the slab cache. For kmalloc, these flags are only used to select
> > the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
> > or __GFP_DMA) to serve the allocation.
> > 
> > Specifying it on individual allocations (rather than as SLAB_ flags)
> > makes it easy to break the assumption.
> 
> As in, you don't want a "pass-through" mode for __GFP_DMA?
> 
> It's a lot of overhead for __GFP_DMA to have multiple providers, so I'd
> rather allow kmem_buckets to allow pass-through (perhaps explicitly
> opt-in) where then the other options (e.g. alignment) must match the
> general kmalloc caches so that pass-through is consistent.

Having both "Specifying __GFP_DMA for slab caches without SLAB_DMA is
illegal" and "However kmem_buckets is an exception because creating
separate buckets for SLAB_DMA is costly" in mind is confusing and
easy to get wrong...

Perhaps the user should bypass kmem_buckets and fall back
to kmalloc?

> > > When it falls back to kmalloc, kmem_buckets itself should provide a
> > > compatibility layer when falling back to kmalloc.
> > 
> > For example, calculate_sizes() converts certain SLAB_* flags into
> > GFP flags (s->allocflags) for allocation. We can have a similar
> > logic when falling back to kmalloc.
> > 
> > Though current implementation does not allow this and requires
> > some rework.
> 
> I think the current series does everything correctly in the sense that
> nothing is allowing for mismatched fallbacks/passthrus. We could iterate
> from there once we have a need for this where a non-kmalloc-alignment is
> wanted, etc?

Making kmalloc tightly coupled with DMA alignment requirement was
a mistake, and now it's too late to fix that. It's better to not
repeat the same mistake again?

-- 
Cheers,
Harry / Hyeonggon

