Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE998CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4A06B0005; Thu,  4 Jun 2026 15:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D077F6B0088; Thu,  4 Jun 2026 15:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7A76B008A; Thu,  4 Jun 2026 15:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A587F6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:12:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47E09120286
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:12:11 +0000 (UTC)
X-FDA: 84843175662.03.E80069D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05FD920002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:12:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=du+BNIwg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MIZ1n7v5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=du+BNIwg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MIZ1n7v5;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780600329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9L7i2swvOC+jyqEqBi6J71Dz7ZL2TF4c4yN/go0BL5o=;
	b=3Lpzj/JvqmCjIG7d+Gpap5hCG6v6jeCrZwvGwgLWvdQCTtYNCPdLyXwWC1BNMaqlqLbPiR
	mLibtsSF8r6REEUWg4rwhj6NGlJY0spvzTOdzL7ndfqbUpTy49NiY4zCHn5Fb4Zh0uHces
	2uyoN5L3KZR9guGj4xCK4w/apd/zI0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780600329;
	b=T/DCDcLRO+pMc9JD20Kj+Cq3EmieLqqWoP9qePepOiavHCorRTEle47EJ+O5fRxdgJxeXk
	PnAt7q+wyk6z1PmHF4kLuolBBD9qP4C2TGBjNDJr53NriyvFuZn+dtjHnUL9NUqMkmRTqt
	fgDTyKea5AHal9ffTKX/EvR5NAFC5NY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=du+BNIwg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MIZ1n7v5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=du+BNIwg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MIZ1n7v5;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71F816B029;
	Thu,  4 Jun 2026 19:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780600327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9L7i2swvOC+jyqEqBi6J71Dz7ZL2TF4c4yN/go0BL5o=;
	b=du+BNIwgZkPrCHvZZp6Z5pgYTtbhQg6LVpneHU5VcpuZUPHfCuNNJJxDn08F6cRF8XjfEg
	kpwU2X5A5fBjRAkEaQx2ZvKzsCBjTktKKMF8uRkANugAs8Lr+LvgrAVxAreIEihf045E0z
	+B447SxeQm16FMgnEJ7FVzy/TqQ7cW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780600327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9L7i2swvOC+jyqEqBi6J71Dz7ZL2TF4c4yN/go0BL5o=;
	b=MIZ1n7v5OoSUdcDUgR1RvEt12w6lYFbzx5nExRtHBJkzaCfLmp/gyJmNpZoCjbgRfzoaIy
	SLLWM/u6shUkS6BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780600327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9L7i2swvOC+jyqEqBi6J71Dz7ZL2TF4c4yN/go0BL5o=;
	b=du+BNIwgZkPrCHvZZp6Z5pgYTtbhQg6LVpneHU5VcpuZUPHfCuNNJJxDn08F6cRF8XjfEg
	kpwU2X5A5fBjRAkEaQx2ZvKzsCBjTktKKMF8uRkANugAs8Lr+LvgrAVxAreIEihf045E0z
	+B447SxeQm16FMgnEJ7FVzy/TqQ7cW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780600327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9L7i2swvOC+jyqEqBi6J71Dz7ZL2TF4c4yN/go0BL5o=;
	b=MIZ1n7v5OoSUdcDUgR1RvEt12w6lYFbzx5nExRtHBJkzaCfLmp/gyJmNpZoCjbgRfzoaIy
	SLLWM/u6shUkS6BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFEFC779A8;
	Thu,  4 Jun 2026 19:12:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F7e4LQXOIWr4fQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 04 Jun 2026 19:12:05 +0000
Date: Thu, 4 Jun 2026 20:12:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, linux-hardening@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
Message-ID: <aiHIQ4ZxnMSifhmi@pedro-suse>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
 <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 05FD920002
X-Rspam-User: 
X-Stat-Signature: kf5aihq5nq4thsryksujws4do1epo3pw
X-Rspamd-Server: rspam08
X-HE-Tag: 1780600328-806048
X-HE-Meta: U2FsdGVkX1/EaA32K+y+IiZpI2na8wr7VWHEvTQUJoYNujQhdKk1ae5f61Z5o+2mLc20Nz6NSj1APtyabGi5X2V7bvXg+Mb9TeO9Ie6x+b7VhWDl3bfY7uclEo8jjEsue/Lj70ZMtFuP1+7SfKSkTln7NgsVKMyiUam+QYT9nzVjHQM/KkE2B60z3Uw4txRsqvpJLfD8uvEwVlmJ0ApM7tVt8xB57qBum0cxKOd1fmxA4DR+EGh/dSZRJ/gez+zbENtfkGXpK19R1uMQAIpmjH6LOzO3in3rKJ9qw+Z285T2frrgGJcS9EShX/sbulDoTcKjrtrO+XP3G3kp1H/GOJTjPKsjq+RHr3abIt9HHj+U72TSd6zimhG9d289Zgt4z21Mk5BPb0bw3BLEyfqB6hdf8hrrYFsTHrLfft3YCDyPzAsyEuspDgbGqBwqWkh0nQiXT0JPyr1f3wxyP4Ed5q4Jsq2l8CbVInEwZi4VzUfNaSZZ9h2kKYhsMphcYVvv8DuZ/01eHcfF+Ce2FrYR8A7BpLPe+tnXu52w4e2+1ZA1HgXiSyr3Wv3gzkovAelr3vtKNs2+bRy6HirANNSbCKuPmdaCyfPOKCGXyUKFaCcudCHZdKaf8QxA7aqQmj8sfvLsrWq4pFkbwtYOiQgGCJLzWpbKm73/3ROcnS43/Pb76akLTLQK0ZbhlCauIv32yHpAF7iac4Qy6SRXKCqZutZplKRBep2vfMNYBA9j5dVevrZdynYbsEn46C6JSbf38XBQLI+B7VLcUzmGHjtTxy46p5uM7TtSyflLFxG2mJ3MnGgPSFAXPIqWqzHDtvaL+uXnCXu7YKWfygoZcZ5fhLrJ89aVfXyLUyb96hnJ61L4V/y4DOtr2ruvop6vWqSqLOgnWQl/jU817gEaA0ga+NdNU8GxwltmYkGxLKoIdG4xXcSSKEiIdCkTzO0JbSOEEvF2H4b8iyE5YpVE4Nc
 XqSqEg6E
 1+OuGDXftBZGL5mBzL/N6OjwvJNB6MXB8qyKRN4VKJOA/W2qMZ3008olMG3eaa7DGU+EZ0ckatTjwNzvnBOFyQyFuPgH56+N8QVjYehUBnP0u83+QNDYoW7CfTX47NI4Mwpln8shJGue2/iBAmTVzAeyFzTix6U4+6GxjrinHEscW+dg6OKa9svPFJ7NcrUdIws3phE3iIFVl5hojK+4wLrmPEgdqNIUZSN1WKAF7B9wZKmCDbW29YLv+gdpVOxBGoCPmGdDm4V7D1rBjGft2rO8Lgjm/XBvqLCRjnc+PyjPwulfH6ChgVhVe5Ba7bmUJ+yihB34hN4DNvc8RFYrun9j7ICZNR97DnTg5Zs1UmQivxac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 02:30:34PM +0900, Harry Yoo wrote:
> 
> 
> On 6/3/26 3:31 AM, Pedro Falcato wrote:
> > SKB data area allocations (as done from alloc_skb()) use kmalloc().
> > These allocations can be variably sized and their contents can be more
> > or less controlled from userspace, which makes them useful for attackers
> > that want to overwrite a use-after-free'd object from the same kmalloc slab
> > (which often just requires the sizes to roughly match into the same kmalloc
> > bucket). [0] is an easy example of an exploit that uses netlink skb
> > allocation to target another similarly-sized accidentally freed object.
> > 
> > While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
> > probabilistic. Use the existing kmem buckets API to further isolate these
> > allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.
> > 
> > Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  net/core/skbuff.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 44a7f8401468..1f6c6b531ece 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -594,6 +594,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
> >  	return kmalloc_node_track_caller(obj_size, flags, node);
> >  }
> >  
> > +static kmem_buckets *skb_data_buckets __ro_after_init;
> > +
> >  /*
> >   * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
> >   * the caller if emergency pfmemalloc reserves are being used. If it is and
> > @@ -632,7 +634,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
> >  	 * Try a regular allocation, when that fails and we're not entitled
> >  	 * to the reserves, fail.
> >  	 */
> > -	obj = kmalloc_node_track_caller(obj_size,
> > +	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> >  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
> >  					node);
> >  	if (likely(obj))
> 
> What about kmalloc_pfmemalloc()?

Good point, that looks free as well.

Sidenote: isolating kmem_cache_alloc for possibly-aliasing caches could also
be useful. skb allocation has net_hotdata.skb_small_head_cache. It doesn't merge
with anything for $raisins (odd size, plus I don't think usercopy caches are
getting merged?) but it feels too... accidental?

Maybe passing something like SLAB_NO_MERGE and making the size
standard-looking would be nice. I have a size of 704 bytes per object, and
this probably causes some weird wastage for each slab.


-- 
Pedro

