Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA10FCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD8A6B0005; Wed, 20 May 2026 03:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E7B6B0088; Wed, 20 May 2026 03:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA42D6B008A; Wed, 20 May 2026 03:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B78BD6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:50:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 493631201DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:50:27 +0000 (UTC)
X-FDA: 84787025694.14.429791D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 899ABC0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:50:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEybL7aB;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h8QzQ3bvGW1O7RXX739a+wEI+Rm3n1kyOMDOPSvEn4=;
	b=3HCG7nEQoLlTMDY8f0MEkaZKq0w/BvumbkSSfOo5pF4+PeFyU9Ok52COPAB0X/QGqXCHQ/
	PJp4GWrrnW1LfWHwnxf9UrFkv4+lFaBkxiIZ5v/fjTLBQEkGu+8vct23ccHP+JpubxMLvV
	mQdnILOxScAbCAYwTvEZImQcieNZA2M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEybL7aB;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263425; a=rsa-sha256;
	cv=none;
	b=xSToq/VswqiZAXouUwon/+rAD3IFnY/6I0eJb7BFSVNqtDCBktQB75HXsSJrZIUEamLjX3
	62lMAkhsMylVzz5ThN7kyLQVyNE+qPU9T25BL9dfE0H2qBB8tMnMYxp7CfQ6HtGS5q3oFx
	utcEkUvjPYUMpJ1qMy2TnOLxFSyyQpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B429431C9;
	Wed, 20 May 2026 07:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B43D1F00893;
	Wed, 20 May 2026 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779263424;
	bh=8h8QzQ3bvGW1O7RXX739a+wEI+Rm3n1kyOMDOPSvEn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gEybL7aBm3ng+QrbW0I+5Hs8oWbvhLnqN9+2v+IeAKE9ieM9FaKfZzY/r0KtvGAMv
	 UlbzgbPaCjqJHKsyF34JuP43LJBXrfZAZzHDm+DgqhrfaYDvVdJKPK2wZl0LGe4aDV
	 DBmnddYsaubogT9yRSf7C3WuNGyGQjd901PXhgvoWTTKLjmCjQCIVi1K4OqAzSKlXj
	 61TWkO1lsLpElgwhATl1xyR4ojLPcrMK/IY8eJJgK50WvGOcidhzXThsmufAMeqiFt
	 PseREKIwrtV7FeW3hPz53msuOkY9tNmm/x3Njh/sOFlQGLBEaSTgEbViYdNEZovb3M
	 9u5XlFtsz9bdw==
Date: Wed, 20 May 2026 08:50:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ag1mk2DSJsiORaxK@lucifer>
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer>
 <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 899ABC0004
X-Stat-Signature: u1keng1net1h1ierd9bgpbkqt5romoo4
X-HE-Tag: 1779263425-809138
X-HE-Meta: U2FsdGVkX1/3xLk259HVL1phpoQbAeC1UTcSs62KkAgeEAinDKubMC3DW+/iM7f5qz1aICW+9VNQg9IRFr/oNIZHEapL5+ZS7wKtDyPIoLacMWyiVfx9b8A2V7C6lJ2EIg8p5Lxc92ax9Ut5bOhp//kArlEgD/HDfF9D7qUjcgafABaTZ6eQogHk++dbt57p4bqO9FoE4zECxqLdt9s5lQNyIvKxT4gRJD/1cAMgsG8/ROzbFo1GCzM3L3RMlYnZGX1wHALpkDeqiD7OhO7m7HGPXfqwx5zXUjhzPS9blXsPP8DHRgpb9RaXXlx72l9xF0l78O5IGTM+CyP5bpm2/w2qPR50X72At7Yt0pkNbhy7zDaKyo/MmTZ8Q+5hXjgWf725+gRZxOFmmyaMQmniRcu8EzKMd28q2S4gP8fNlQBsxWamjKwAeLlND80T440T0tlWad0Vlasy9CyWqf6mhxk0Ew2BlLuR1yMatdyQZcyH7WOTrADB+lmAMR3IgxBcQokDVo+nAa4evxvVk0saU5QJEz66QhZR7Ytw+9RSF5gfcPTu+Y4MOe5jDkAI0+Wbok880G8p42Ia5FblVXUqWqApjkldHsRpduCUuQsjHSuYm3NKvgloSMZN1qQd18JzCqzA715fCkX7g755N2YyYCUFwEnuQ9izA+5AyvJhG+HJX5Pe+PhSzAQPX0RbYRatmYOXLe77M/1XsBUR+v5Nzf0a82huKClAVq031WHPrGMHl2+bQh/nQTNLnjS/4GeWu3WcbUPDNoMuDByw033jpFdMR4x9GziSxkjhGz9mopCRW6qF+3v6IVYoE27QpvOdiiuNUIC2Hi/mmeL89rIG+YtceeP0OToADnstIV+uE2X5MMD0VKyN7L5GbCa2rlytpo3uyPLMymGz7npAlf8q0dRiesq9AB+UpNMckXJk0H5ICa1iqytmL7bmB2veVc4G50WTGtOb71OPR28YVVM
 zHmYIjA9
 bQemMPfBxfobYHShQoRnM1SXCiWwjS93nsOMqYc5TDMO+CyT4t4b2CvlSbgRlFtsF+EhycoCpEb2noGnTfOCIsODnbnsqK/f+JshKcRJYV+TVjpcmnuZMDYsWOQFcK3U19Lw/NFuxVJeFNGCFMn8QFNLNDAovLM0gl1Ras2049sq/Pj9oy0Pgskamq0YfUQAf6H52aL2NJfqPAGdmMt8hPbRRgM98z4KW8y2aUFkK4DZSQ1n7nCK5qTiJjgzq3Kmm6MvEwSZB9lJdVEz703aQUtEtvS7iEOn0cqC//kow94dnwg4smBFCjAWVdXVp2lQl4tfuSdeH4j1i4t1ddQ6MGPHE5U1ueH7L/y9tBs0OK9MPxBiF4ierM6VTOTe5wKvlaZHXkUrqg2AFr00KiopxeUNMA91j+6bnudem
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 05:18:52AM +0800, Barry Song wrote:
> On Tue, May 19, 2026 at 8:53 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> >
> > > >
> > > > I think we either need to fix `fork()`, or keep the current
> > > > behavior of dropping the VMA lock before performing I/O.
> > >
> > > I see. So, this problem arises from the fact that we are changing the
> > > pagefaults requiring I/O operation to hold VMA lock...
> > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > > any VMA modification. On the surface, that looks ok to me but I might
> > > be missing some corner cases. If nobody sees any obvious issues, I
> > > think it's worth a try.
> >
> > Not sure if you noticed but I did raise concerns ;)
> >
> > I wonder if you've confused the fault path and fork here, as I think Barry has
> > been a little unclear on that.
>
> I think I’ve been absolutely clear :-)

On this point sure, I would argue less so around the fork stuff but I responded
on that specifically elsewhere so let's keep things moving :>)

> We should either stick to the current behavior - drop
> the VMA lock before doing I/O, or change fork() so that it
> does not wait on vma_start_write().

Again, as I said elsewhere, I think there might be a 3rd way possibly. It's a
big mistake to assume that there are only specific solutions to problems in the
kernel then to present a false dichotomy.

We absolutely hear you on this being a problem and it WILL be addressed one way
or another.

Of the two approaches, as I said elsewhere, I prefer what you've done in this
series to anything touching fork.

But give me time to look through the series please (I'd also suggest RFC'ing
when it's something kinda fundamental that might generate converastion, makes
life a bit easier on the review side :)

>
> Before per-VMA locks, page faults dropped mmap_lock before
> doing I/O. After per-VMA locks, page faults dropped the
> VMA lock before doing I/O. In both cases, fork() would not
> wait for I/O in the page-fault path.
>
> Now you guys are suggesting performing I/O while holding
> the VMA lock, which means fork() must wait for that I/O to
> complete. Since an application can have more than 1000
> VMAs, and I/O can be stalled for an unpredictable amount
> of time in the bio/request queue or filesystem GC, fork()
> could end up blocked on multiple VMAs while taking
> vma_start_write() for each of them.
>
> As a result, fork() could hold mmap_lock for a very, very,
> very long time. fork() itself would become extremely slow,
> and any other task needing mmap_lock would also be blocked
> behind it.

Yep aware, we spoke in Zagreb about this, and on this thread, we know :)

>
> >
> > What's being suggested in this thread is to fundamentally change fork behaviour
> > so it's different from the entire history of the kernel (or - presumably - at
> > least recent history :) and permit concurrent page faults to occur on a forking
> > process.
> >
> > I absolutely object to this for being pretty crazy. I mean I'm not sure we
> > really want to be simultaneously modifying page tables while invoking
> > copy_page_range()? No?
>
> If you object to touching fork(), can you at least accept
> keeping the existing behavior of dropping the VMA lock
> before doing I/O? If you object to both approaches, then I
> really do not know how we can continue :-)

Again as per above, let's not impose a false dichtomy, let's take our time, and
specifically - please give me time to read through the series and think about
this.

>
> Thanks
> Barry

Thanks, Lorenzo

