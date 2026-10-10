Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B677CA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AFF6B009B; Fri,  9 Oct 2026 23:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B996B009D; Fri,  9 Oct 2026 23:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43726B009E; Fri,  9 Oct 2026 23:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0BF46B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:19:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59A31160731
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:19:02 +0000 (UTC)
X-FDA: 85305260124.09.EC48E73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8F8B140006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:19:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVmjNQFt;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791602340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvErx1WWrmavZpAWawNx/SxSWFSIPpRG5LFKnvSw2A0=;
	b=SGx2CQADXFKocrsBkU5KBkcjWLsJhNK4QqDDOgMjo5n4gsgK2zeLDBD+JY6lWhD+uSwkP3
	g03YN+ziQt3V9YZ9E2ElPCIUbIVeLO9/I7TICN3wSHPs07nBuvCa/R8Zej4yIWP/xuLOF6
	c/i/olp8O9VsczK2koxizXExJzwREmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791602340;
	b=jjiyBGELa1ckZXtZfsNWzo2uHMUzD+EScjM0SOdigRcgtblHermqRVW3FXXMEhuUUrofTY
	8ezGxcOHEroq83fyBsyweAqj1SZmvnTv08kefnjJ9nhjObX3m4MBH3TKG9jC1xQIIqQjJo
	lR+ixOE2XMbsdxz1kTZ9is+2cG0T1hs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVmjNQFt;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BBC560DCB;
	Sat, 10 Oct 2026 03:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42761F000FF;
	Sat, 10 Oct 2026 03:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791602339;
	bh=mvErx1WWrmavZpAWawNx/SxSWFSIPpRG5LFKnvSw2A0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jVmjNQFtVai+W7WXC+h3kBaL0yjWXjUQJYTf2QnXM6D3GAH9/NAhARUSIpFOV0ocz
	 ldAQ277Wo7iqm+PAjlF23ZdAK1uixhqlEROEG4z6b13Dftr/BL+rzd6RoAuKK5qweZ
	 CUe5/3NsUdVjpRG/ava7nnO58ZC5r8ewUiFIB+xTaOUcmHx1krhNwlHvU6+KWDQplT
	 RA1laodn+A61NsVE/vx1EED1Ew5/AINNnK9pSkEWxhOllREjl9+3cxE6oRP+GKBfdc
	 Jj9BT6Foz6Is5IHwk76OmFoK50H788A3TiXNzSJGWK9kt+ceeBVH3TG0EOeu4FAfwo
	 j8pwAY4y1zMdw==
Date: Fri, 9 Oct 2026 20:18:59 -0700
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
Message-ID: <202610092014.AAB20B81@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ask5kpMS4mpI8Api@thinkpad>
X-Rspamd-Queue-Id: B8F8B140006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: djx13q3twanfp86xnun9zmtbuqzioenc
X-HE-Tag: 1791602340-803935
X-HE-Meta: U2FsdGVkX1/a3QdZVAxJJcZ9eCAN8aG5Y6Ocuk/toAlA4ZBCCEtNj2H5mOzWXazAJsDwYxv3QF5MmTUD33ijovcOsXgWtbHrjUYw2zPp9LvIVbQFVvF9sDXVG0Y1TFl1kJzAAx3Sn8m3LBY9gaR45l2fqtMM/BqkNOKJS9VTCBeHkgIYvQ3Ojr0wtQJxuteyEKHpr+n9k9oaXFvin3ACbao/1O7befc+xIp4JZUiMq2gXpTsPGaRnE8lgeSYwn1Xrn3vuHn6mXTTqlbSLGaVJd8EN/kQ1fAT2nuhavWAPbwNdHOmvAKNU8S0+kHWO/ddl7KI7Sig2IufynSNYdN8+0k3Uzi+ar2G+pa3/WFF1/kO0B7xYe9D5wz6AFxN+jVfpIYum5ruHWfs5oiuTHUSxSOPHVit/mjm3VOtCQ9hkECMQFwFWuoLxzpYLogGLfbaN+/JoHaz4HbkpkZTM5PmEBnSOFxYl4FLd/nrGiygUwYiRGhTxRn4r+I8oZzcb3JBwtxMzdhOmqH/pfao1oGVcXv6LyT6QbTT+lgSS/B6MoTXnTir0b94l40mSq9AcejqHAEWj7ETylo8FkktcToBC2+Y9o7wji4ssjUQl6oR6+IeB1ZoZP3tnGGVu2BqL8vwaSD1iYJ+WHK1NX+v9Kx8ErqXbwOdSRfpyASXAI+xDTm+fKP8E1QvSg5yJJyJEcT5zWp4uYtbUkejVz8GCRzbDEYNRTdbgXQp6jTY/WTjUhE+mFPHKPD087mNUvnvzvyNoGKbwH4PgGwRINXu2woJZ/yTxvWKeqdN7Xff97c3lqRVR/tLiU+QYEt8M5Qdnfbh0gcyU9wh557rbkXNTmrIICXuak/NvL/HN8Ep8xlzB8WmeE+ZrNzqiJsdyZiwo+UqiCdpe6R5JUZC0ptBC3oTON6SCSx7VlhNBV8mzSE/Wc8R2xpm8DOI/LEOTqm/Ydm0AYnvHKCuO1neFQd4VoD
 Fd0XO7Db
 r2I8OK9VHqbjIDq4pMBwQA+INd/rUs55itOEiF1McL0PuAK6nyhDZZnZ/zgQdYIvZd7++n5wWxejwA4tf3FTyFjMVa+637egsFrNDER4OY84woSZRkc1idu19cJkm5XyLr7RBDLrgOskoXgUkRVLTIeXRxcyimhx2zhsxlmSOoX6ShnkrCkO/HB7sy5y5MnhqNB0AN89TUwxxAmitPfQ+4ZrZyWuTFvzOfFfhxcjYxSHkflI9E/Hn1dS6bGJ5LL+8uhsNSj1KNQhBWETCNOhznv67WlLk2TfhW/ia7zUYLwojrO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> > And now I see the initial kmem_buckets design did not sufficiently
> > tackle the question "How this should work when kmem_buckets falls back
> > to kmalloc?"
> > 
> > I suppose the kmem_buckets' abstraction should not be too tightly
> > coupled with kmalloc caches. Creating a kmem_buckets should be
> > conceptually equivalent to creating a set of caches with speicifc
> > slab flags, size, align, useroffset/size. (for variable size allocation).
> 
> Just to clarify... I have a few concerns on this area.
> 
> 1. Complexity.
> 
> It's very counter-intuitive to understand how it works when
> SLAB_BUCKETS is not compiled. My brain cannot easily process two
> different implementations w/ and w/o SLAB_BUCKETS.
> 
> A "compatibility layer" allows us to assume certain expectations
> and ignore all implementation details when SLAB_BUCKETS is not compiled.

I'd rather make kmem_buckets not have a SLAB_BUCKETS option. :)

> 2. Making kmem_buckets tightly coupled with kmalloc's implementation
>    details is not reasonable.
> 
> Let's say, at some point we make SLAB_BUCKETS always enabled and drop
> the config option. Then all kmem_buckets users will now have certain
> assumptions inherted from kmalloc (e.g. alignment), which is not
> reasonable.

Until it's always enabled, I don't see a reasonable way to separate
those assumptions.

> 3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
> in the slab cache. For kmalloc, these flags are only used to select
> the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
> or __GFP_DMA) to serve the allocation.
> 
> Specifying it on individual allocations (rather than as SLAB_ flags)
> makes it easy to break the assumption.

As in, you don't want a "pass-through" mode for __GFP_DMA?

It's a lot of overhead for __GFP_DMA to have multiple providers, so I'd
rather allow kmem_buckets to allow pass-through (perhaps explicitly
opt-in) where then the other options (e.g. alignment) must match the
general kmalloc caches so that pass-through is consistent.

> > When it falls back to kmalloc, kmem_buckets itself should provide a
> > compatibility layer when falling back to kmalloc.
> 
> For example, calculate_sizes() converts certain SLAB_* flags into
> GFP flags (s->allocflags) for allocation. We can have a similar
> logic when falling back to kmalloc.
> 
> Though current implementation does not allow this and requires
> some rework.

I think the current series does everything correctly in the sense that
nothing is allowing for mismatched fallbacks/passthrus. We could iterate
from there once we have a need for this where a non-kmalloc-alignment is
wanted, etc?

-- 
Kees Cook

