Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7848D16819
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 11:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9286B0088; Fri,  9 Jan 2026 06:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76A36B0089; Fri,  9 Jan 2026 06:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58926B008A; Fri,  9 Jan 2026 06:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5ADD6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:48:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C38D13B42A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:48:47 +0000 (UTC)
X-FDA: 84312253494.22.8015378
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CE5112000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:48:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGG+debD;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767959325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYF757VFZbjPp9+rgGQc+tuvo82+suocCGJ/1TmFUs0=;
	b=YuYegY9aDs5kLu2SxXePu4fc9XKyXJpE+KzD1Z77xihP4KqqtpHfYKUL8QrfVUqI4s2/zD
	lmbb27NS/oj0D12nNvbyIAOcOVOOrwXXcwJbcmPx7jK+1dKbN+bVXjpcqSnAU/faVhLkzp
	ltaH27oZm5QkJT3ZK69l7NFTauqbSnw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGG+debD;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767959325; a=rsa-sha256;
	cv=none;
	b=3zXEgaTUSTd1aycmAM5VpUPDGF3v+EJlCIQvF0V3bD059VK7OV4DrqeI7gFbYFj39uzyoU
	6llCXX6rfSFXAAIDfC9E+OWwBOfXH/oWWhdWBi4TibGNz1+aK1Yp2k38PAwS0Xa7a9/GXi
	6T+4IQetnx0HeHHmsqfZccoGxWBbGts=
Date: Fri, 9 Jan 2026 19:48:20 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767959323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oYF757VFZbjPp9+rgGQc+tuvo82+suocCGJ/1TmFUs0=;
	b=DGG+debD1nXBpLE0MoRfyiShZtxYlLel08B5gTq+kCz48gVHJQcOg0/1PR9z7KH/fhJbRi
	+YEQA1Le1H2Bu4DPWxSQyN7g6gxXcrzw9wUwJ68Z1KZtbsot2V9xdcPpeZsFkyVHo8vwrD
	yusszebGfsODVk/Td+V3bNeApIR86+0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC 14/19] slab: simplify kmalloc_nolock()
Message-ID: <6lagtqkkxsnuphgmluwodah7nlhiuovw74fzdzr7xgq4nwdwup@eyfgwukzbynd>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-14-6ffa2c9941c0@suse.cz>
 <4ukrk3ziayvxrcfxm2izwrwt3qrmr4fcsefl4n7oodc4t2hxgt@ijk63r4f3rkr>
 <4fca7893-60bd-41da-844f-971934de19b6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fca7893-60bd-41da-844f-971934de19b6@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CE5112000E
X-Stat-Signature: jp8313jxmpkdsncqc4xe7t18crbd5hso
X-HE-Tag: 1767959325-404579
X-HE-Meta: U2FsdGVkX1/c8eWZnSsY92cOX4JER6XyYjv4fa0HS+d3+PuStjjiT0PZRYUs9N7MZMkDgzqJZJLvwTErGzORTGgo+JIBy46OCAe86Etx4FG1ylp6LTg5wWSPZk/kO0TwNI85Fy2JJdIvcBwCrr21K6nadNyYtE2d5vGKg6iiJiCY9Jh8JUaRxUICTsc0Sq5mqhFAvCXIEYIDns8tGgDCkW03eLEvSA/vTkBCCJN84sRzWnXZ5hsM62G+3dMBWtJVLT0/5Lk97hfroIoumwodHPSgKfX+LLFpMcAiCv2T5JXFhByUYcP1cqXDjLaxtDOaLSTT4AMlbGrz4FoT7MbVcy6vuSjojpmjvYsj4quvzyYfv31dV+V1JnLIVOwrMgFmSnJa6Mo4zzq1ZsJ7Quq8vbQZ/1bY5XFS0W8gg3012BLrwcnvqfL8kO83AV58vDg4Imc1+y0Q5WYR8ruUGkAUvg1P1GU5gn7pof1sYgRReP1vCLKcMirlkm4XY6pCxrAJoWCk050CoBMnN5RE1nRXh/nChVH8W+TbavP8YW29sKApL3Q26fS8UuWfRsAIdescp8ivFLD3Me0GMFM26y2idakr2MaQsni4HzLqYVa9ajo5NJgG5XrrFTNEcjWubZO8+PcICM6+6sPENvwbHaTWEGSsaB2STElNLfVKkBbV40xrTKqcRgXK1FFFj+iBEB1BZNdjhQlsDZjOyTziW7ZNrOimEBz/C7CmzEeVLM/TUQGxflvkUb4IipMXTG0aTc1kZWF7gwdhbGRVjukNF8mDZjA++YEJ0p8SKJoJS5ZWYbjCRZ0ZD3l24akfFEos4g8e0p6h4W/7Nxt/vD+MNv4o/6BBYND6RMbR7sT9Cl/tqLJSE1J8HIxi4f4o/7Resc7DjnUaauwE5fijWtKuxjU+eulNDNoL3oDGlBRa96t6IqM3KeewsJFztz6XJuM7HHePYiSzqT8sMw/03Ie/oRe
 AidpHzvo
 ORzQXLGufU3Ew6J82Fw7K+sEoUa8cp8qc3mc0S2Wq8HM6jfd+UXdeVLbrpO0jSBHu+OlDxGGMoDgos1NCs0Dcm6/+DatbV8/nAflr7HXicDWYtEKjEG1M/CL64i/1PkCB6mU79W0cA6eX1cedV80AvMW9F8iS3o8UyhAqqSS6c7SHt+ZyUvD9CCcthMaW5sFcI9AfgODP9BQwGRjpOJ3KXGhHxt/VwLzsAKqef7DN1NFZQD3r8gsY/a6fDP/Gc7pnlFgG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 11:11:26AM +0100, Vlastimil Babka wrote:
> On 12/16/25 03:35, Hao Li wrote:
> > On Thu, Oct 23, 2025 at 03:52:36PM +0200, Vlastimil Babka wrote:
> >> @@ -5214,27 +5144,13 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
> >>  	if (ret)
> >>  		goto success;
> >>  
> >> -	ret = ERR_PTR(-EBUSY);
> >> -
> >>  	/*
> >>  	 * Do not call slab_alloc_node(), since trylock mode isn't
> >>  	 * compatible with slab_pre_alloc_hook/should_failslab and
> >>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
> >>  	 * and slab_post_alloc_hook() directly.
> >> -	 *
> >> -	 * In !PREEMPT_RT ___slab_alloc() manipulates (freelist,tid) pair
> >> -	 * in irq saved region. It assumes that the same cpu will not
> >> -	 * __update_cpu_freelist_fast() into the same (freelist,tid) pair.
> >> -	 * Therefore use in_nmi() to check whether particular bucket is in
> >> -	 * irq protected section.
> >> -	 *
> >> -	 * If in_nmi() && local_lock_is_locked(s->cpu_slab) then it means that
> >> -	 * this cpu was interrupted somewhere inside ___slab_alloc() after
> >> -	 * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
> >> -	 * In this case fast path with __update_cpu_freelist_fast() is not safe.
> >>  	 */
> >> -	if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
> >> -		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
> >> +	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
> >>  
> >>  	if (PTR_ERR(ret) == -EBUSY) {
> > 
> > After Patch 10 is applied, the logic that returns `EBUSY` has been
> > removed along with the `s->cpu_slab` logic. As a result, it appears that
> > `__slab_alloc_node` will no longer return `EBUSY`.
> 
> True, I missed that, thanks.
> Since we can still get failures due to the cpu_sheaves local lock held, I
> think we could just do the single retry with a larger bucket if ret is NULL.

Sounds good - this is a clean approach.

> Whlle it may be NULL for other reasons (being genuinely out of memory and
> the limited context not allowing reclaim etc), it wouldn't hurt, and it's
> better than to introduce returning EBUSY into various paths.

I agree - it seems cleaner for __slab_alloc_node() to return only NULL
or a valid pointer. If it could also return -EBUSY, the return semantics
would be a bit less clear.

-- 
Thanks,
Hao

> 
> >>  		if (can_retry) {
> >> @@ -7250,10 +7166,6 @@ void __kmem_cache_release(struct kmem_cache *s)
> >>  {
> >>  	cache_random_seq_destroy(s);
> >>  	pcs_destroy(s);
> >> -#ifdef CONFIG_PREEMPT_RT
> >> -	if (s->cpu_slab)
> >> -		lockdep_unregister_key(&s->lock_key);
> >> -#endif
> >>  	free_percpu(s->cpu_slab);
> >>  	free_kmem_cache_nodes(s);
> >>  }
> >> 
> >> -- 
> >> 2.51.1
> >> 
> 

