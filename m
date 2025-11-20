Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93060CFA454
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 23:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30936B000E; Thu, 20 Nov 2025 18:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08026B0022; Thu, 20 Nov 2025 18:45:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944CC6B0023; Thu, 20 Nov 2025 18:45:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833CB6B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:45:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB12958C5B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:45:27 +0000 (UTC)
X-FDA: 84132619494.11.FC13392
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F0D514000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:45:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VA3MslyZ;
	spf=pass (imf09.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763682326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF7JALj20bmXZfrHGZoVsPPQ6JCJWc0J/jYCEO7HAi0=;
	b=Kx21XRvCpRiqgqouY7zgYqbeRYv1nul0hkW6KQMoZXfOOzLcBbcnFNZggS7oXmZVpG6I/z
	m5Q1Q0BeTzgxwGBmx6mRUlEoNrYHoXrOWsGuP/sh3dXCZDqz3HvfmW1Hv55y/Gr7IVIlGh
	fT8BN9E5yS9gm6IAm1HDjId2VA/+KWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763682326; a=rsa-sha256;
	cv=none;
	b=cG9DaOg/Un7C3OZJz4u9MUt+onvqi0wXnUx1MJOOnKNPAk/zZCVLGSQD8GQRB8LpbjfSop
	90HtWaDFirGF2Y62y3S1ryuL5ZrrZYuKKo6His+uarzVYj55ERbJtnBrjDRxjhR1P/yPm+
	DZnogZwhsQ2gdSkkbJrwTPCk2apW/1c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VA3MslyZ;
	spf=pass (imf09.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E495043E3F;
	Thu, 20 Nov 2025 23:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD5FC4CEF1;
	Thu, 20 Nov 2025 23:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763682324;
	bh=ImWWYk0PHw9JXlz/xZx3LovRWAEU+wr54LjbITQLl9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VA3MslyZbpymm5vh31u8bCqtScgQxq4YNX0wHTLCgY63ZlebhUUN80u3xqFbgqQd1
	 nnhj5YbTfs90XwPPcqscoR71rFf7aoeqUpH2z++tBO48mwXSPFG2WJ8f1m+K320Cgq
	 sGp8yejP7ZyZXMTlKceOeoC7SKYySm1jtWCBqxvRsIy8J2CjdcYMMVXxmRq9UbGVGj
	 dAOUZtNBzLs8bOb+9oy1/apHdyUY8+QdOeQBjoINr+Hx41VdQXwVUoEgUQOusFNvcg
	 YXVuItlrs9IWMIvdlLjt5G6gfg60xoJhG5AjvMZQ33LCgGrbQg17iLNP8JCCjEPB+x
	 GBAArzxJNaIbg==
Date: Thu, 20 Nov 2025 23:45:22 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, Tejun Heo <tj@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
Message-ID: <20251120234522.GB3532564@google.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-40-david.laight.linux@gmail.com>
 <7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
 <20251120095946.2da34be9@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120095946.2da34be9@pumpkin>
X-Stat-Signature: ejzcstr6kwjhjwxzsnb99kxck3pjqeua
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F0D514000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763682325-948673
X-HE-Meta: U2FsdGVkX19m0vkxejL86+nlXtTREIHpmhn9dbYtpqma4gjGP3HgBDW7fKEpbV7whrqNVWKsoNiDCvGX0fJBHvfgqNw6IkendjRdmPFFK+CtS9BN4+aQqiShIBkSSx5FU+NxR/cuzdUVDluRYtwfb4X4t+EOEgBQgJkKsnrzD7t0ZOiq+oajCWZqbwRoFenBP9OiOKboAqy8Qt5oSvSEbLZEYmDau9mYY7v7pU81ZLBCNXswiuvZhcp2dQV3WhRQ8StPLUApQXHoeAqNaZ2xyHqivj7N2zvb+ogVxtvD8CNVLtN4GmtSQ6j9Vilv/NsSaYrW1GLbLgCWVLDGP8pB9UPO7qt10w3OyGQel/xKLYqYcIIcjWrJF/ih0wKd0fMjEBMXlTbffTtBHOXj+Xm4lbLrzYz6vkh13U8d+2+TQi6m5rfmXBTlwwivIuTgr2OdCP5YS1qcs0rdYAG2AbTVJxoAiTDxdB75qutNO1zXpUNiSewiGY/r8aF3OsPWD63kpqOn8Vc5VoKCwNrl0/b9styfiamzWdEnQlFjTANXjTHTHLIYWzwWoVotqsviAZvy6oWrtu0W1qm5RyQyztKJgJnRlsqQNQoKyx9ONPdlr9PP+9KGdVmszgco/BJLorKsdw1yRdP/tg/NHu6H8AF/Qgc1TgUEdLzsTocnOQFh18weNqEmeDMbZlpYFM0EpmD5CXLj9V83XhyRl1fnUcJBB1lrHeAD01PnHEq99QG5FDmHj7xuzygVwYaJiNurnXkF0Pcd4dn8TMLNr451OyZsfb6YGUsg/i8i3Ps6RLRDwIT+KAeWeSGfzHad1LoNSCV7YTMlQdj9sa1zRydsj21jWqAP9TPLfHZWg8cmoWXpjngFV6MWZW8L1Bb9b9DKhd2R2TwuIdmETvgHqDCcxqVAyoW/cNGWyFsIVKsth35lLCY6r+nRgbdhTBZQmCoJjOmkAd6M+TIDmIoZjgA3yDs
 27Xg84iZ
 g9Oywu3H3bzxvwnAhT46WohY0w49mxNjtCYGdITx7dFzXdSgRZ8Elx5yaoV0L/ROy0kPexzbA4tOKVzqVRmS6mfABTfa27mEr0tY8CFSFiAgtIyE2ABbmkbvGn4zfk2nLaYl9MK4PSpApfCksMbw61mldw3aUyiGhoRQ5cr/rQr6lmqg6oqYCQg0pNVx3IMPSUHFT28Cdf5yDOvdrN43kRUAZ9uNX4K2BH5PjlH/0uHGg9H8tHouA2EoEJqfH6JfWf01NEI78Q+ukhBt4kePhUpErzOrZ0tme4DUaGheoJIwQnpg29gA4BOgWKeiJYaKXJZAk8gtOZSTH3XA6Zcbdd/fR9l2bhqZM/a2f60bQBQW4hOMTGMWJ3RoDR8Zn9BYVw7vFF362IoOV0nz1mtsVhuc3z6Q0gbeL/tWI1DXZfX8zE8AjxOXqnOtDm1zqmrNfNVcxzSRzuhbChoKfZNbP5bUJdpv2HIFRogqJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 09:59:46AM +0000, David Laight wrote:
> On Thu, 20 Nov 2025 10:20:41 +0100
> "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
> > On 11/19/25 23:41, david.laight.linux@gmail.com wrote:
> > > From: David Laight <david.laight.linux@gmail.com>
> > > 
> > > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > > and so cannot discard significant bits.  
> > 
> > I thought using min() was frowned upon and we were supposed to use 
> > min_t() instead to make it clear which type we want to use.
> 
> I'm not sure that was ever true.
> min_t() is just an accident waiting to happen.
> (and I found a few of them, the worst are in sched/fair.c)
> 
> Most of the min_t() are there because of the rather overzealous type
> check that used to be in min().
> But even then it would really be better to explicitly cast one of the
> parameters to min(), so min_t(T, a, b) => min(a, (T)b).
> Then it becomes rather more obvious that min_t(u8, x->m_u8, expr)
> is going mask off the high bits of 'expr'.
> 
> > Do I misremember or have things changed?
> > 
> > Wasn't there a checkpatch warning that states exactly that?
> 
> There is one that suggests min_t() - it ought to be nuked.
> The real fix is to backtrack the types so there isn't an error.
> min_t() ought to be a 'last resort' and a single cast is better.
> 
> With the relaxed checks in min() most of the min_t() can just
> be replaced by min(), even this is ok:
> 	int len = fun();
> 	if (len < 0)
> 		return;
> 	count = min(len, sizeof(T));
> 
> I did look at the history of min() and min_t().
> IIRC some of the networking code had a real function min() with
> 'unsigned int' arguments.
> This was moved to a common header, changed to a #define and had
> a type added - so min(T, a, b).
> Pretty much immediately that was renamed min_t() and min() added
> that accepted any type - but checked the types of 'a' and 'b'
> exactly matched.
> Code was then changed (over the years) to use min(), but in many
> cases the types didn't quite match - so min_t() was used a lot.
> 
> I keep spotting new commits that pass too small a type to min_t().
> So this is the start of a '5 year' campaign to nuke min_t() (et al).

Yes, checkpatch suggests min_t() or max_t() if you cast an argument to
min() or max().  Grep for "typecasts on min/max could be min_t/max_t" in
scripts/checkpatch.pl.

And historically you could not pass different types to min() and max(),
which is why people use min_t() and max_t().  It looks like you fixed
that a couple years ago in
https://lore.kernel.org/all/b97faef60ad24922b530241c5d7c933c@AcuMS.aculab.com/,
which is great!  It just takes some time for the whole community to get
the message.  Also, it seems that checkpatch is in need of an update.

Doing these conversions looks good to me, but unfortunately this is
probably the type of thing that shouldn't be a single kernel-wide patch
series.  They should be sent out per-subsystem.

I suggest also putting a sentence in the commit message that mentions
that min() and max() have been updated to accept arguments with
different types.  (Seeing as historically that wasn't true.)  I suggest
also being extra clear about when each change is a cleanup vs a fix. 

- Eric

