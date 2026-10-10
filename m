Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EFCCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598676B008C; Fri,  9 Oct 2026 23:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548926B0095; Fri,  9 Oct 2026 23:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410436B0096; Fri,  9 Oct 2026 23:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1703E6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:14:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F307C16072A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:14:22 +0000 (UTC)
X-FDA: 85305248364.15.5A9E667
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 525F740005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:14:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oc1T4x/g";
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791602061;
	b=bEEw7yxgTmE+1m86Q0bmMXtPg9XGtXwcfukrNGhR854/JlkSdM/j3QwmmlJkA3Ax5Erbqu
	9ZMdv07ZxxwzzXFPfqD4yu6SnrhUN7I3dAMGV82f2C+4PynM9o6elLjnM+ZTVUDAk8X/16
	84lu4+CuQWhtcQgwM0nJSsOnp1tFKrg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oc1T4x/g";
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791602061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yx/JVeS1tmYz5AP+LsJLVcBiKsmoT3twRZPPXFAPFaI=;
	b=HlnoAHKovaREUYhkXEgqP3K6XRPmTsCOc13v5QVNXHGNuAG2LP0VYQFZviiXZ0C9zB8D1h
	aFcg1jCT7dLwrMKEbmh6lUZECg9xT/2nOblxBtPXYO0zgY6+ztLo854UJ9K2lqc77/Cj74
	PNjRtVrOf0to7f8jpL2DsBKkH2MCFkY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85712401D2;
	Sat, 10 Oct 2026 03:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B551F000FF;
	Sat, 10 Oct 2026 03:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791602060;
	bh=yx/JVeS1tmYz5AP+LsJLVcBiKsmoT3twRZPPXFAPFaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oc1T4x/g5lQjaBIT/nueAYeZavtGP25+leC8be+gNguhGbZjR6bQbufUOCFqkGJse
	 fZfUGdwCrIvpkUvDT/bELtH+vWc7VCf8BIbqu3Y0DyABc/Yxaz4t0+VeFClAM5baES
	 PEo323XO8rYESGmi6Y2zH0mJ5kJHZrUfPOO9FAz1cjpGA/0gM0AagD/iwfcZxxgbby
	 OBTJyyRUkt884jgmmXoGZRJsXiiM+/SzsSRQ68LVNndJ02kfx9gF9dOaGpNqRkEJua
	 41Hov7gvPXLYJMP6HGMp+vHU0iagrg8j2hCnI+lEhujPCNEIQEfQxNbauTe9p+WZRJ
	 /73/mYX4wJAEw==
Date: Fri, 9 Oct 2026 20:14:20 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610092010.934197B@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjhg2e4-WSeKuXd@thinkpad>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 525F740005
X-Stat-Signature: epr4n49hr8q1d65mzfcun7rsbxmkrj5o
X-HE-Tag: 1791602061-282954
X-HE-Meta: U2FsdGVkX1983e5hC/nonp3S6CFYiFFM0RRXM1fBouMc4Ujgse5DeKYkTMgz/t29rzXVYHA4LA5gAng0Ik2b+n0rVi2WZOLM3xITnPnzwPoaOtiLox9AoKvFYjV+Cja2bW9W+Gg7H7QodJzKzAheeXD8TOSr3Ngf4E8ECAXsWEWPv7o0VjYxaMb4+6AFwW2kOsghi84UtFyTdKZiDsYfZeWrCdBZqbqtoWR3GWPMkYFGA+O7o2Qb7YRItKPhg90vCl1IIX5zDMxUFssgFGhX3MS9ZnW5q+lDajsXXd7ozDiGQIi2NoWVCaCdwrIdrtwhjkIOWEyoyhCRFDaC2pNl1J3cnga0JmWI6HRGTf+Xl7LigIS8gm09MMWJA9IAk3c921sG/uEOTlwjLYL0Fbao35Z7XeWhr8z+KYmlWA9tGkW3SkdNOUDw+YwDcroW5owN4snOgrS8wcdZyckdanEXXY4/Y3vGm1JszwurZWPD4UCtXRAcCGl+vZ2czuHGlsXWaA+n4D9J/zRsSRS+7Y22zUhfnjOpuCQ2Vh3TeAi5uiIE52o3HrHTdLkwvnG5YbWRJz5/eZSjw6IfJIK9Cw0BsoiknzzimLRgFIsMVnNtCh5BU/kqADEDhpJXSuEcmNZrGHelArqO+mtgWFnh320+atGRYxGbP6XDDLVF1DTVB7bGFQyAcvvbEN3MxyZ4NQ/9rgVY82uaT8zB2F8KRb8rWImPIbz0kfX7ltfuroKZ9Pqmaa3RGttkZIAoDiSExLl5xn5hfS+rpLn3BxXTgJok+r2vRHnKBjeSTL7L8mWjQBpn6j3ZIg/APnNVsrks45LT6kUkR+PqB1ekH0q+gM1uqZ70xjjBZbKD5WMkWxNDfzLPnSEmmJjNdt6xuBidSPvhPKLpllKJdWlFhHmOxR6I0RN7klYGrd1QmPSosCY1PH+UDBcKNjM5U+JDACT1QSe21ZJaULq4h0FWyiRcXkJ
 m+8s9WXu
 KE+HD8hR+C+vUq96dp9VU9lB8DrWYBHuBsJ+zpFjrVOcrP1qTZ9C81CpH92TIqlbIfmPjQ01jpQf5JfK6XDHAEGTW69lV/vsnX9pdANw01A5WFgAzfz6Fq6omw9PEeDCKeFvx8U0BeF2GfqVehTAHm3CvcfqJv9s1Wk/L/EEVZwCtVzHHEwKB1rZuGsaSqQbl0KODdLItZzIvpivVWzfhUUp82MzQ9OYwjRo5OxvlyCu1aAIyniAhVlX8WB/5MZNdUyzErrL85nkqv4G/qruyIr2N1fPDmhrN6xKwm+GcUWP66aIygz2GOlzoo77cj8sPuuA8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 04:22:01PM +0200, Harry Yoo wrote:
> On Tue, Oct 06, 2026 at 02:20:28AM -0700, Kees Cook wrote:
> > Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> > alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> > accounted only through SLAB_ACCOUNT on its bucket caches.
> 
> > With
> > CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> > kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> > which do not account it; the same happens when kmem_buckets_create()
> > fails. Either way, the allocation is not charged to the sender's memory
> > cgroup.
> 
> Ouch, now I see what's gone wrong here... 
> The fix for this bug should be Cc: stable IMHO.
> Allowing to escape memcg charging is not good.

Anything with Fixes: will end up in stable, so I just leave off the
stable CC these days.

> > Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> > charges such an allocation in whichever cache serves it, so drop the
> > SLAB_ACCOUNT, which no longer adds anything.
> 
> Hmm in the long term we don't want allowing __GFP_ACCOUNT allocations
> that are served from slab caches without SLAB_ACCOUNT, as this wastes
> memory.
> 
> See: https://lore.kernel.org/linux-mm/20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org

This is how I thought things worked, so my original version of this
series kept separate caches. (I can return to that too, but it doesn't
seem to be needed today?)

> And now I see the initial kmem_buckets design did not sufficiently
> tackle the question "How this should work when kmem_buckets falls back
> to kmalloc?"

Right. We could just make kmem_buckets non-optional, too? Then they
could have all the caller personalization they need.

> I suppose the kmem_buckets' abstraction should not be too tightly
> coupled with kmalloc caches. Creating a kmem_buckets should be
> conceptually equivalent to creating a set of caches with speicifc
> slab flags, size, align, useroffset/size. (for variable size allocation).

In my mind, the general kmalloc caches are just a specific instance of a
kmem_buckets...

> When it falls back to kmalloc, kmem_buckets itself should provide a
> compatibility layer when falling back to kmalloc.

IMO, it'd just be better to make kmem_buckets not NEED a compat layer...

> (Okay, allowing ctor is completely broken, but other attributes are fine)
> 
> ...I don't agree with the idea that "since kmem_buckets can fall back to
> kmalloc, kmem_buckets can only have the same requirements as kmalloc
> (slab flags, alignment, etc.)".
> 
> By that logic, shouldn't we give up specifying useroffset and usersize
> too? :-)

Yup, but I kept that since only the hardening guarantees change under
that condition -- nothing operationally depends on useroffset/size.

-Kees

-- 
Kees Cook

