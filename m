Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FE4CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DB98E0007; Fri, 12 Sep 2025 17:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505B98E0002; Fri, 12 Sep 2025 17:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442418E0007; Fri, 12 Sep 2025 17:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33ECD8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:12:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 021451DFAC1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:12:09 +0000 (UTC)
X-FDA: 83881846020.08.4D814B7
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B60840004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:12:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fesVLqO3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757711528; a=rsa-sha256;
	cv=none;
	b=V5mzphDGOeY/IPkIfM+Hh/mTSfDZHlPiv8VQS4TvujkXmBIw+QhqRJlYSlvv0VBB3S/nG3
	t0BB+NuLsHX9ojqCO/aGQ+/1Ps+KfUsLHF2UuoZhea3UNikzt77ZvgA/9bN+s66teXnQAC
	V5PAOFiZglcxR5lHlgQLt7QjvoVnCPE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fesVLqO3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757711528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1iy96TgkS7WHq5/odvTgYGKNjQS3AcZjxGa0biOKkQ=;
	b=rbPSzwjI0eYhdTW/41msPnxaYvLpHvcMNplyPXHxMPRKChpBH/eUm9knMS6aW3EwABz8hZ
	sEZw4nu7+TKZxtyqt5CMwRHUHYKotSfmxQEgDDev/dmHbhtdiRNMR8ENJ1jBhaie7Kq0RL
	pNyAUe67SoGNLkd5eSNONOSULI3KnFc=
Date: Fri, 12 Sep 2025 14:11:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757711523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1iy96TgkS7WHq5/odvTgYGKNjQS3AcZjxGa0biOKkQ=;
	b=fesVLqO3DPPZfy0knzjdCqF+npTedXM005odVu1M+PKq7OSCmK7RVHSpNaQKMT+rQshgkg
	0xdAOfJF/iFP25TpQ+mzS1+diMmTThKjrZgS9wW6syv6VcASiuiHEYViatucq9ogWFXfkB
	VJwAMhad7c4X4N4Bb0jivh41wYh04wE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, vbabka@suse.cz, harry.yoo@oracle.com, mhocko@suse.com, 
	bigeasy@linutronix.de, andrii@kernel.org, memxor@gmail.com, akpm@linux-foundation.org, 
	peterz@infradead.org, rostedt@goodmis.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B60840004
X-Stat-Signature: hjxprie661f3ou6k31kp4twh784w8x7h
X-Rspam-User: 
X-HE-Tag: 1757711527-197855
X-HE-Meta: U2FsdGVkX1+ruOMPFl8Hlc2Kt0DmQv388KHlJ5GLqUDAqYBSFvf+cVfnqVoUYYD66CLRlTURiWfJH4sSG4anxRZX9GG3b7yI6t5HGX5sx1qItMVDBalgKAH50DX9uwlOQLWuXNoO7HR+ZxXVeKh6dbK/0tgtPucQ9PvM5crZ+wknrBfuk+oRn0YA1F82LpeLrB/qMaYPLfJ5VH8/4pi8dp17UOEWuDeakQ2zGHXrZ2qgI73m5JuFq7AnYM3MAPOo0jZY3+PbTTEcnABxipajh7lniAhUWBT/ohb2glP0kzHZugUI9CTDfqTOhF4EIxAy+67HfwJFvh7wg4FwnmBBFWBSQms31LCExNoZY38RFNuny2KDFEeBRUqA/nGYvAzw6IoLs/x2svj+z5JuIE3UBRkvxUnFIFDCtxwRkZrOBbPbZy6CWR8GgSzL+CMmThhEBHztzt5x+dUpeOGZzYEMAIG8XMZ0Jgo9WybgEz9dA3XkPd05Q/y88Q0x0bmevEYXLnlAfMHuTglHGfIKOate8IXnD8UX1OAqsAaHuhUaiQdrk3EjrSgMmmJ/FCNE1bIQnPZCPYdY3yc3DjtjvJzLyZOxr/jggLR2Q/MSSS99Q5lkkyipIheQlocKn5218PimERt3B2035yNDMXFtfLkGX/es7wWWp2jkwgMPUw/znjzkF099qUmeYMRZxr9pGwKEjq5OmLzP3Qh09oVuoXjAAzL44ub57tWoQKGWXgRLsIIxkXjIZUv33cQ7oShpFsaDeQLR8wVXZRQJDPXBkMQR8m9nKbnGQ/OdfqLU9Du9axjN0TWWt+9lpE0NPbl8Djlfj0eDrKxarP3kPznCbvWxPVXbkiTBuwtJ8LpNSZGBfdcIzq26CtUyG4awsjkYDYWmPYQiumoEMA9Zdru+Phy2AAod7p3CHf8iPTzeceEROXT94YgvbemUCB+XmNpdmF8RhlzRjvlkMYoUejrgl0c
 /S6DsPcP
 OOLGW9iszRHPHlrjGfJBNJ0MdFT0RnRTkB7ePQOQ6n9vOK5KIKsx7A2EdoomvLv/jwDdxGn8xg+3btzjJksH7NwMvj1cW8HTgwPEH2v/40ws9vPhi0eFZKIg9fwiNaOGUyP33DGbezj96mQWdZj5eKSnK2vHS9C6PCPf2LflOfFM2JnemQphcTg3vk7bB40zLHlBjP4EIGO6SWnN7dvpDc6BNd1O6arQq6T6ZWPtpxs2bcm4wCJ1NYzOHoyvjecyeBw9MJixefSvtWuJrh/hzH0I2+uCsQ6UI6B/JPk1R2zestmcpDgSue7wb3V8/IDK7DUlEBdD3wxU+tuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:03:03PM -0700, Suren Baghdasaryan wrote:
[...]
> > I do have some questions on the state of slab->obj_exts even before this
> > patch for Suren, Roman, Vlastimil and others:
> >
> > Suppose we newly allocate struct slab for a SLAB_ACCOUNT cache and tried
> > to allocate obj_exts for it which failed. The kernel will set
> > OBJEXTS_ALLOC_FAIL in slab->obj_exts (Note that this can only be set for
> > new slab allocation and only for SLAB_ACCOUNT caches i.e. vec allocation
> > failure for memory profiling does not set this flag).
> >
> > Now in the post alloc hook, either through memory profiling or through
> > memcg charging, we will try again to allocate the vec and before that we
> > will call slab_obj_exts() on the slab which has:
> >
> >         unsigned long obj_exts = READ_ONCE(slab->obj_exts);
> >
> >         VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS), slab_page(slab));
> >
> > It seems like the above VM_BUG_ON_PAGE() will trigger because obj_exts
> > will have OBJEXTS_ALLOC_FAIL but it should not, right? Or am I missing
> > something? After the following patch we will aliasing be MEMCG_DATA_OBJEXTS
> > and OBJEXTS_ALLOC_FAIL and will avoid this trigger though which also
> > seems unintended.
> 
> You are correct. Current VM_BUG_ON_PAGE() will trigger if
> OBJEXTS_ALLOC_FAIL is set and that is wrong. When
> alloc_slab_obj_exts() fails to allocate the vector it does
> mark_failed_objexts_alloc() and exits without setting
> MEMCG_DATA_OBJEXTS (which it would have done if the allocation
> succeeded). So, any further calls to slab_obj_exts() will generate a
> warning because MEMCG_DATA_OBJEXTS is not set. I believe the proper
> fix would not be to set MEMCG_DATA_OBJEXTS along with
> OBJEXTS_ALLOC_FAIL because the pointer does not point to a valid
> vector but to modify the warning to:
> 
> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
> OBJEXTS_ALLOC_FAIL)), slab_page(slab));
> 
> IOW, we expect the obj_ext to be either NULL or have either
> MEMCG_DATA_OBJEXTS or OBJEXTS_ALLOC_FAIL set.
> >
> > Next question: OBJEXTS_ALLOC_FAIL is for memory profiling and we never
> > set it when memcg is disabled and memory profiling is enabled or even
> > with both memcg and memory profiling are enabled but cache does not have
> > SLAB_ACCOUNT. This seems unintentional as well, right?
> 
> I'm not sure why you think OBJEXTS_ALLOC_FAIL is not set by memory
> profiling (independent of CONFIG_MEMCG state).
> __alloc_tagging_slab_alloc_hook()->prepare_slab_obj_exts_hook()->alloc_slab_obj_exts()
> will attempt to allocate the vector and set OBJEXTS_ALLOC_FAIL if that
> fails.
> 

prepare_slab_obj_exts_hook() calls alloc_slab_obj_exts() with new_slab
as false and alloc_slab_obj_exts() will only call
mark_failed_objexts_alloc() if new_slab is true.

> >
> > Also I think slab_obj_exts() needs to handle OBJEXTS_ALLOC_FAIL explicitly.
> 
> Agree, so is my proposal to update the warning sounds right to you?

Yes that seems right to me.

