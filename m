Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29523C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377B76B0096; Mon,  7 Sep 2026 12:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E186B009D; Mon,  7 Sep 2026 12:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D606B009E; Mon,  7 Sep 2026 12:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E934C6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:19:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77AF7401D7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:19:39 +0000 (UTC)
X-FDA: 85187476878.21.8E80AF9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62DC21A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:19:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcWjuxFa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="iQlNs/Te";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VK8MzL9a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wei6+CSs;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omJY25/XWUjhUvy4Wr9FGwgJZb4rjKPTul22yTeJeNY=;
	b=kTf3Lm/yOkyPUC0ysFuK8KiEqZVDNNkdguawn9el0qTI2e70FEyrjwLga6kasmF0K1PMQ8
	uDGAbWacl2MyUHzKWgP2wC95+oD39Y+sHcN/984e6FolhmTltQ2WdAVTqnKoBWlwTjv6fW
	v+t62zSDO9blSjlOgUksHG3OqGWALm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797977;
	b=gA92wataMc8MlpPx9+D3tF+NSHIsc53/M0TglsWeM/KPifTtgrscSLybWDbBwg1zrAXIJL
	y2TRxKxl8WXd90tYWxTL1q/RbNSCAKIfFOWzdbU2HaOKNBqz/wQu2ZfNDUBCokTvWK3y46
	SSryJPCIHa1E9bEZIVXtLve0wRbi1dU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcWjuxFa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="iQlNs/Te";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VK8MzL9a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wei6+CSs;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 867C31F7B3;
	Mon,  7 Sep 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788797971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=omJY25/XWUjhUvy4Wr9FGwgJZb4rjKPTul22yTeJeNY=;
	b=LcWjuxFagTfgCxZiGMG2drQIg+8W6egTjIS6uSptZRYLxuwbIbeam1AVwPV9VWbMABBb8I
	BqST/rAn9TqkejTpNHhc9iev+h9KQuz6UDMdgJOx2gsDo1fR32e8Vzcr2rPVCtwdVlX/xu
	VT+wvyxeiRcowTN+orMnAFm6e+n7Yig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788797971;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=omJY25/XWUjhUvy4Wr9FGwgJZb4rjKPTul22yTeJeNY=;
	b=iQlNs/TeiPSDeUixWjWYeH/JE/agATjevDEFmK4T71kQgf/0l8R6ISlaii1LvMSUC00mYD
	svdl85RIQy8RaTCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788797967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=omJY25/XWUjhUvy4Wr9FGwgJZb4rjKPTul22yTeJeNY=;
	b=VK8MzL9apzKb9jpYbvPW7iGfWlWRKefhXHnYVZLdEhKMj/XP0Cmx8CMASRlvUVsThm2d6V
	6kl5+QpZJK3NNaxbOOhhgbeLJ+IDJlbA6KP4ByjVsWqy4FnWxYFoMcXgLNj8B68IapJqJ/
	y6uzBWvnZrm4jCw7PjlZTUljzNiXsXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788797967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=omJY25/XWUjhUvy4Wr9FGwgJZb4rjKPTul22yTeJeNY=;
	b=wei6+CSsK4PmGx/vpSZzXgBIjvTAvqgm5u/D6DLyOMbwTgn77kJkBn9W39mEoJtPUvbvdr
	V8d1BvQOCQ/pe8CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 892A41339B;
	Mon,  7 Sep 2026 16:19:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n7jOHA7knmpQFAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 07 Sep 2026 16:19:26 +0000
Date: Mon, 7 Sep 2026 17:19:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Message-ID: <ap7f_w8hHkvpk9Vg@pedro-suse.tail5790ac.ts.net>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
 <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: 68duuhrmzjw986fs16wa38qetbxqegh3
X-Rspamd-Queue-Id: 62DC21A0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788797977-305610
X-HE-Meta: U2FsdGVkX1/f9kmjtpOJd+gF1H2Fz/+B+gTqmD17ShpbLqBdKhvKB2Y1vpWS6MuuqRb5MvNUk/c2ekk6AU5B2pk6jYF8L3Rysbv51EMkK9Zk1EKAi1AYI4DDeHuwcsXQQbSLF7duTZSeXecuIUPdOzXi3HtD9JcStZMy1awqJFh0i7QGdTncS1zoMvXcCPdbF4oztDxw2wGu0iwuf/x81QXEdKPMmWgJ8SqalzYUb9YeRc4AuAX6TSvNmZOXdoVQLXC7oCZ+wrrNUqCO8g9Z3BTbgADdsPmw994Ny769RuqbrORYjEc80dpnwA6bA05985ymTAdK3b2vfv20uNNIusImcf8fQYcWrEihjk83Pl4iDPC773kDOREKaOKOqo5o3Udc+xL/TZC0Gu8bjU+PrQGhzq00AormZ/HvAr9YiD54GLqahshXM16ZLPnNLFn/G1Zb6RUsOkPs5eq9RxzS1O6JzgWQPY1MM7k6xvPSW5gsoFXfCnbhEk1aTQSIw0nCtKHBtDfNnJuMUaIFd5a2/HaL+w8h8Tbcbv+pnaIHTvrbo4SZrTPi8zyWhaurQeZnSrOakKY85gKCT80MVkVuGcb1J5pdAU48GmNworQ5KFgyKNGWx/FikyLmT6prE+reRmdtzPtaTAnf1yB2Io2yX8PHlSieZv69VBL2okU5KdggWDwNY126A9ehPAgNiYv5BVBc2eblyNfXZcMyuoodN4iOyFrcAG3baDkwJgaN/rmgrPbH5QRhep9GsZagRyQhxU6/sjS98Qw7MEsYs+U7bEZqkYrnSs7SgLZ/cyd+DaYSIgap8ZDpcuVHVY8uyFJKAV1RK4ExF69ck1eo8CQICHGeyrcR30UP+P10NV3qN+/wrfDo/Lb5+TPi4qWicYXuvYQufYWt+thoyXqWlRkvWd+vxiqgjfHM/gBAfJ5cbG3DdolUO+NxyitGN3ZX07Cg6bJD/PbvdcvtQF+wjSk
 LhhN0rw4
 p6Rrd30qUMqnIgyFsk9B4F5exLAYaB5j6UMznsIPkXtfiEZZFrhEyQQmsGuabQj4bw1hEuYoMYFjPLU2Oa3hCEGrZ3znHPU7qoQf1j0TQ6JOVRsmUgKl/j1EKUV3HINSAdUJ/LSvQpJgxghgrQMN+7aMzTIG5g/vjXRKIuAc+TsftX+iHtY0f1jGeR0a4/XmLUEkO+XKxbor6MfEG29XYkzwwP4UYn0X0Pp5QKXFxx3UtirZ+BHQi25wVJZ9AyOCdf9iHXb5nbLwPfH6GNM8DoPy+ClzkyZY3dxDjhqIQXCvJXJcGid/ypfa0jtQTYwqHg4ZR0z0zmvT1a9gLTtwxhJJ7FTk4NYN51+SCvZtUlxGeWThztchd78QSl+lBlAOayD7wHWrIZ6TLFpxtHIYSPBFYyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 03:38:22PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/24/26 14:25, Hao Li wrote:
> > Introduce a mechanism called parking to mitigate lock contention in the
> > free slowpath.
> 
> Interesting!
> 
> > In the free slowpath, when __slab_free() transitions a full slab into a
> > partial/empty slab through a free operation, it must acquire the list
> > lock to add these newly freed partial/empty slabs to the partial list.
> > 
> > Why must partial and empty slabs converted from full slabs be added to
> > the partial list? Because only by doing so can the sheaf refill or alloc
> > slowpath see these partial slabs and allocate from them. Therefore, the
> > list insertion must be performed, which requires acquiring the lock and
> > leads to heavy lock contention under high concurrency.
> > 
> > Analysis of profiling data from the will-it-scale mmap1 benchmark shows
> > that full -> partial transitions account for a large proportion, second
> > only to partial -> partial.
> > 
> > With extra instrumentation added to __slab_free(), the following data
> > was collected for the maple_node cache (in counts):
> > 
> >   partial->partial    843017414
> >   full->partial       550719384
> >   partial->empty      17459564
> >   full->empty         2
> 
> That's a lot inded. I'd be careful if it's some specific aspect of the test,
> i.e. lots of parallel allocations followed by lots of frees, that wouldn't
> be that common in realistic workloads. But worth looking into at least.
> If it's this kind of pathologic behavior, then I expect changing sheaf size
> as suggested by Pedro wouldn't help much.

mmap1[1] is a very simple test. It just mmaps and munmaps. I assume what we're
observing here is the churn in maple tree nodes as we allocate/free/split/etc.

I suspect it's also possible that bulk RCU freeing is causing this. It might
1) be substantially delayed and 2) dumping a lot of freed maple tree node
objects that overflow the pcs.

[1] https://github.com/heatd/will-it-scale/blob/master/tests/mmap1.c

> 
> > Since the fundamental purpose of __slab_free() is to make newly freed
> > partial/empty slabs visible to the sheaf refill or alloc slowpath, these
> > slabs can be temporarily stored in a staging area in a lockless manner
> > instead of making the free slowpath contend for the lock. The sheaf
> 
> However the lockless manipulation is still going to contend on the
> llist_head. But perhaps it's limited enough in both users and lenght of
> operations to make a difference.
> 
> > refill or alloc slowpath then checks this staging area first when
> > allocating objects. This achieves the goal of making these slabs visible
> > to the sheaf refill or alloc slowpath while allowing the free slowpath
> > to operate locklessly. This process is called "parking".
> 
> I'm gonna pull a David Hildenbrand trick here and question the name :)
> It seems to me it's an (extension of the) partial list, but lockless.
> Parking would suggest to me that it's put somewhere aside not to be used, or
> something.
> 
> > Parking occurs in only one case: when __slab_free() encounters a full ->
> > partial/empty transition and the trylock fails. In this case,
> > __slab_free() attaches the slab to an llist locklessly, instead of
> > waiting for the lock unnecessarily.
> 
> It could be interesting to also see if skipping the trylock completely
> (another cache contending operation) helps even more. Also whether moving
> the llist_node to a different cache line than list_lock (and fields
> protected by it) helps even more, or not.
> 
> > Conversely, the process of moving these parked slabs from the llist back
> > to the partial list is called "unpark". Unpark occurs in four cases:
> > 
> > 1. Sheaf refill or alloc slowpath: This is the core case. The sheaf
> >    refill or alloc slowpath must see the parked slabs, so the first
> >    thing done after acquiring the lock in the sheaf refill or alloc
> >    slowpath is unpark.
> > 2. Cache shrinking: shrinking also needs to see slabs in the parked
> >    state.
> > 3. Cache destruction: kmem_cache_destroy() must also see parked slabs,
> >    which is obvious, otherwise memory would leak.
> > 4. delayed_work (see corner case b below)
> > 
> > Why is this scheme correct? Because paths entering the sheaf refill or
> > alloc slowpath can see both slabs on the partial list and slabs on the
> > parked llist, while allocation paths that do not enter the sheaf refill
> > or alloc slowpath would not check the partial list in the first place
> > and naturally do not need to care about parked slabs. Therefore, whether
> > an allocation takes the sheaf refill or the alloc slowpath or not, slabs
> > on the parked llist and slabs on the partial list make no difference to
> > the allocator. This visibility equivalence is the core of the scheme.
> > This analysis also shows that the scheme does not affect the utilization
> > of partial slabs or lead to increased fragmentation.
> > 
> > Corner cases to handle:
> > a. Parked slabs may become completely empty. Therefore, unpark must also
> >    check min_partial and free excess empty slabs instead of adding them
> >    back to the partial list.
> > 
> > b. In rare cases, the system may go idle immediately after slabs are
> >    parked, and the sheaf refill or alloc slowpath may never run
> >    again. These parked slabs would then remain in the llist until the
> >    next sheaf refill or alloc slowpath performs an unpark. To
> >    solve this problem, add a delayed_work named unpark_work to add
> >    parked slabs back to the partial list when no other path unparks
> >    them.
> 
> OK, but is this a problem that needs the delayed work? If the slabs are
> still partial, they would just sit on the partial list rather than on the
> llist, but it would cause no extra bloat?
> It could be a problem only if free slab(s) got stuck on the llist.
> 
> So I'd try to avoid the delayed work as it's quite a red flag. Periodic
> flushing of alien arrays used to be a very unpopular part of SLAB
> implementation. I think there might be two ways:
> 
> 1) submit the delayed work only when transitioning partial->empty slab on
> the llist. Would likely require flagging slabs that are on the llist.
> Hopefully this will limit the submissions to negligible amounts.
> 
> 2) remove the delayed work completely, instead __slab_free() would perform
> the "unpark" immediately when detecting partial->empty slab transition on
> the llist. Would need flagging the slabs as well.

3) Don't do any of this and keep a small(ish?) barn locally, for each CPU (welcome
back per-CPU partial slabs!). I'll play around with this idea and see if I can
get interesting results...

I also have other vague, handwavy ideas... Hmm...

But I really, really suspect that deferring work and playing around with
trylocks is really just working around allocator deficiencies.

-- 
Pedro

