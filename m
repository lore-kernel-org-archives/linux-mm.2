Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ABACF6BE9
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 04:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE83C6B0092; Tue,  6 Jan 2026 23:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF706B0093; Tue,  6 Jan 2026 23:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6CF6B0095; Tue,  6 Jan 2026 23:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB87B6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:08:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 726B3160134
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:08:00 +0000 (UTC)
X-FDA: 84303834720.22.5AA30A1
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id AECB4C0004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:07:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JChzz8JP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767758879; a=rsa-sha256;
	cv=none;
	b=cFAmScYjvCHLeTiwB2HDFlfvKliONK8BodxaKEx2gkwB0N9Nu11PQP0eIQfV49GhoFohpo
	9W8FyImNyPEYmACmwcVWDrNgXiezQgh6lUQTRRgS2+5/ZNP6CJj0Am1pLM/B7C97qMp2gM
	JeEkXkmenX0652cCJrjmUy7SCIT2RY8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JChzz8JP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767758879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpQ5rJZWPuYDYZOiEs7ucS7UwBx/7FvHyEGjqrQa6bU=;
	b=xpBq9O9Fx9Kfeo6UpVEa6++TCyeJhcDtjyrpTeiFJiVs9pVD4kce+06XPg57l7XongBdVb
	Pj7HI5CYmjo9bZa4LJ/8IdWzOWpD7lle+sCdwGGyYkwIcTOs+PnHgO4saD0XedevVArZcv
	bfv/Ht2bCoLr82yrP2GYM71rnMuZyAo=
Date: Tue, 6 Jan 2026 23:07:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767758876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpQ5rJZWPuYDYZOiEs7ucS7UwBx/7FvHyEGjqrQa6bU=;
	b=JChzz8JPhTtft7tIloMgX1wvE/JiSsAUMmMhb6Cermsqcm1dL7/mzbjjbGuAowXHX70fW4
	z62ipmFe8hARr9BTobOl8CHtBtAnjQWuVVyorJTe2QPvhsBrCgIGSLbLz0r/pfoP0p0UaU
	k0fmQCLxIqSkeofX1Rma95c+gsHKT98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, pasha.tatashin@soleen.com, souravpanda@google.com, 
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
Message-ID: <aV3bykzqkyUcBJBf@moria.home.lan>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
 <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
 <aVzorksJEyI0wlxh@moria.home.lan>
 <37169c79.a0e5.19b93a2768f.Coremail.00107082@163.com>
 <aV2VWbY4Rb_w-QTs@moria.home.lan>
 <4736b304.38a2.19b96888104.Coremail.00107082@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4736b304.38a2.19b96888104.Coremail.00107082@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AECB4C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: qusoss7pff7zhkmik5g6cax6s9w639j1
X-HE-Tag: 1767758878-510823
X-HE-Meta: U2FsdGVkX1+t51F8mHeQr/9uM1I+mEcTRx+JNk4aP6SX6W6W5YQRcTzWJsq5O0+iVoKgZhtYbb25BVGcO5PWjHe5MeRjAkoJorYwqgi9kZcq9hJS/aB4fjWk4cCkDkbjFghIk51o/d/lOQOO5EdKe9uZUoSVuobSime4RY7652y6dDKh+trsIBFl9uvYIY9mcITlMfUNiBjwEGGjwTbMIPDFbFyawwg0HnweIVcDyMUrEm1fi/VaFiVXoWlEXdiXb4Arvn4PwuE4s8dTvFMpMR4NttQCuQPo0rPxJJxNywF7Mn7hVzX5gkoEzkJRY2YmgVLTsVui50A7SYPT8wTlnFuPE0EgvGMwr3j2xutnA0D6mDTAD0AnzMxY852PN67ou/aG7LHfbbd6auICkXTgVCn7R9SA59leUhVyH+wau2sAI/dlEwuJfc7m5zJ3N7QKJ+wuN+ar/9L6tTHHp3b7KSlUq+akDzGuVpIg++7zaIGJs+OxmkhYWwTkxH3t335XumqKnQfH3bgcHEnqwQI7jLxXt1gJZi9QV/k2915MSN2fPVoEWcR0DZ1cbId+jNdVeRKuBS47wv0h6Et3avDIQc5KFtaaKhYSiLucu89rn5inY1LWp5rk2TJxcTchW6Y82HUR/tqNYPcxZA5VTqjSWWI18NrQ9ZEBnoLLNkaVs0tR1fvmvdnHZCKwX0HT0q80/BRgdzKsUY1t7f7k/80kSFgiNOh81OUEJnuKy/MzBQMhnrxoo3WPnvTyJFg6MdkoAcb5D1/sZAnCGa1x6jENeeEpdGcYWYzCi+pJok/u5yK7LbpX17HsGmltbEVYpTiCa//h+hHQOTa9924xR7Hc/EMdBGY8MLvgqZsHmnn/8bXccAaTbz5P6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 11:38:06AM +0800, David Wang wrote:
> 
> At 2026-01-07 07:26:18, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
> >On Tue, Jan 06, 2026 at 10:07:36PM +0800, David Wang wrote:
> >> I agree, the accounting would be incorrect for alloc sites down the callchain, and would confuse things.
> >> When the call chain has more than one codetag, correct accounting for one codetag would always mean incorrect
> >> accounting for other codetags, right? But I don't think picking the first tag would make the accounting totally incorrect. 
> >
> >The trouble is you end up in situations where you have an alloc tag on
> >the stack, but then you're doing an internal allocation that definitely
> >should not be accounted to the outer alloc tag.
> >
> >E.g. there's a lot of internal mm allocations like this; object
> >extension vectors was I think the first place where it came up,
> >vmalloc() also has its own internal data structures that require
> >allocations.
> >
> >Just using the outermost tag means these inner allocations will get
> >accounted to other unrelated alloc tags _effectively at random_; meaning
> >if we're burning more memory than we should be in a place like that it
> >will never show up in a way that we'll notice and be able to track it
> >down.
> 
> Kind of feel that the same thing could be said for drivers: the driver could use more memory
> than the data says....this is actually true....
> Different developer may have different focus concerning the allocation site.
> 
> >
> >> Totally agree.
> >> I used to sum by filepath prefix to aggregate memory usage for drivers.
> >> Take usb subsystem for example,  on my system, the data say my usb drivers use up 200k memory,
> >> and if pick first codetag, the data say ~350K.   Which one is lying, or are those two both lying. I am  confused.
> >> 
> >> I think this also raises the question of what is the *correct* way to make use of /proc/allocinfo...
> >
> >So yes, summing by filepath prefix is the way we want things to work.
> >
> >But getting there - with a fully reliable end result - is a process.
> >
> >What you want to do is - preferably on a reasonably idle machine, aside
> >from the code you're looking at - just look at everything in
> >/proc/allocinfo and sort by size. Look at the biggest ones that might be
> >relevant to your subsystem, and look for any that are suspicious and
> >perhaps should be accounted to your code. Yes, that may entail reading
> >code :)
> >
> >This is why accounting to the innermost tag is important - by doing it
> >this way, if an allocation is being accounted at the wrong callsite
> >they'll all be lumped together at the specific callsite that needs to be
> >fixed, which then shows up higher than normal in /proc/allocations, so
> >that it gets looked at.
> >
> >> >The fact that you have to be explicit about where the accounting happens
> >> >via _noprof is a feature, not a bug :)
> >> 
> >> But it is tedious... :(
> >
> >That's another way of saying it's easy :)
> >
> >Spot an allocation with insufficiently fine grained accounting and it's
> >generally a 3-5 line patch to fix it, I've been doing those here and
> >there - e.g. mempools, workqueues, rhashtables.
> >
> >One trick I did with rhashtables that may be relevant to other
> >subsystems: rhashtable does background processing for your hash table,
> >which will do new allocations for your hash table out of a workqueue.
> >
> >So rhashtable_init() gets wrapped in alloc_hooks(), and then it stashes
> >the pointer to that alloc tag in the rhashtable, and uses it later for
> >all those asynchronous allocations.
> >
> >This means that instead of seeing a ton of memory accounted to the
> >rhashtable code, with no idea of which rhashtable is burning memory -
> >all the rhashtable allocations are accounted to the callsit of the
> >initialization, meaning it's trivial to see which one is burning memory.
> 
> Not that easy, ....code keeps being refactored, _noprof need to be changed along.
> I was trying to split the accounting for __filemap_get_folio to its callers in 6.18,  
> it was easy,  only ~10 lines of code changes. But 6.19 starts with code refactors to
> __filemap_get_folio, adding another level of indirection, allocation callchain becomes
> longer, and more _noprof should be added...quite unpleasant...
> 
> Sometimes I would feel too many _noprof could be obstacle for future code refactors....
> 
> PS: There are several allocation sites have *huge* memory accounting, __filemap_get_folio is
> one of those. splitting those accounting to its callers would be more informative

I'm curious why you need to change __filemap_get_folio()? In filesystem
land we just lump that under "pagecache", but I guess you're doing more
interesting things with it in driver land?

