Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2CDCCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2C96B008A; Wed, 20 May 2026 06:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3EC6B008C; Wed, 20 May 2026 06:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9B36B0092; Wed, 20 May 2026 06:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDEC6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:07:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0904F8C2EE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:07:31 +0000 (UTC)
X-FDA: 84787371102.15.D19D02E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 301C340002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:07:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX7QZvvd;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779271649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uTpCdf27XDZ7rU8VT2nSx6sZs8Bwa/a+nJN9dsTFZs=;
	b=Bby2y2Lzp9ZzzFXlWP3BTf/KmLNwBmcuPXtsifLnjcGuHGEsjf+1K6qhRQBu9aNBlr0TVh
	xPcgZCW+Gk0xxRolTzuSZ3OioorvmBG/p57LBv+baF8IOKWa1azNAVwGfUw9KZKNHlOnaN
	bgV6hmRmDTe64nFx8qsnPzPWwCkxC1g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX7QZvvd;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779271649; a=rsa-sha256;
	cv=none;
	b=WQRekWGyBf28o+gp659mY0QjyYPOyAaCT+Di4rxJDxnJHuCKl9MN/COvENOvg32T61VQ2V
	gSaVSmpjUS5fx2zzb+WjmYmOiHLBg+ZigkAFnhtoLKbvEsaq7QX/Qu2KNeJQrY4EoxqSG2
	IONBVRbx71ndmw7hYToL8u/VNY1iigE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3C3F400E9;
	Wed, 20 May 2026 10:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8006B1F000E9;
	Wed, 20 May 2026 10:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271647;
	bh=5uTpCdf27XDZ7rU8VT2nSx6sZs8Bwa/a+nJN9dsTFZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bX7QZvvdTxa3YSpPgJR/CpVIiAr4LsFJHToqBiUpqQ7OjAJ3JKFYFh8HzISIXKnFl
	 1E+J/2n87sXxTBfiFUF8qRdzuKZRCrbEiW5rd6ddSTbKXsJZyMjM1T70x1mbw9v0iy
	 YXZDa7aQwxVF+CY8701SKVnLs7kwSt8WRsZCkxc6xexoxRufJyztW+awoUYKcSOR3V
	 ZphoL6Dwc5cIDbOia4oI1lg7iHirtApfH1lnEv5WUDqQL/WaQSKARD2Sz4E/mNZ0i/
	 CCS5/OgWZ5wmRKzFA5XnlGREVMcvJ2weIMSEG1wzLcm4yLFjdP3cRCAdnhnZwf44/+
	 wOJEQPBG/nIXg==
Date: Wed, 20 May 2026 11:07:18 +0100
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
Message-ID: <ag2GKrvRHzP4KhOl@lucifer>
References: <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer>
 <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
 <ag1mk2DSJsiORaxK@lucifer>
 <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 301C340002
X-Stat-Signature: i8x6ny5fbmi9156h6annfy9r141tdhm7
X-HE-Tag: 1779271649-307882
X-HE-Meta: U2FsdGVkX19TGOVGb+L2gS1zBFeZwCnYd93pZMcwMFNroC9aWHHQgYlu/HxiObC4kixBR6nud4c2x9DS8QX3wnMqdEdpcI70JG/fvXn+XJqVodUejhANfRMfN1cEcNslzWMxdMTWzMb7ijdQV/dE0Y6lClFEKGKlvisO7MLNbsDxDjf0cGGsvJKK5l4VYNTEVPh+fGx+UkMH8+Jo/zBuQFsFsqBAeIA5Pwmtl2aPvgyStAKKgyFpipvv1bnGoJSwJtNoYRjJ90L8IP9+hEDrGxQDNEsRDZSj5e3qMSCBLzKzEa59oBwMozSM/Kp+Jwi0DACwJKXTgxMSfUPu4fljyRhMoY3AhsW8YwkfSzSKABi5zA5fw4cEcH0m7aIYmWIE4tDs3Pw2QD5gZZYw+SMheUi6AB2VXnwqAS91KRQ+7c5VUWjiH1Di4rtoA60rFxvAQWXAAt93BTPZcLIXyG0FIOkpX8HE3YYKhoJbgyfdKUBypl1jpRU3MCkjO37vkK0QDzbO6k2eABi5feaKExEBIfgSe+wK/VSr87ByKLJmaNJmCuI1iXvSV8aK360RbODzqT/jOE9uukFM+S+GcBV9JciU4kjqwe6AWbQh+Vql9QL9l+yBxJ7nIaT8HdhV4u2ZU81/o4Pbtzetdg3BmZhb4gR7jndsOmlTnvUZa3dr6DKIoWyS1jlEatoHTo68UHlU0IoduVmQYyaABJcawl6oLfQv03v4KshFJBjMl+xS99bhHXjbPdFvbdwjpCLPbQNPB4H6/3arQBjQvQMBHvx7rnbF3XMmbq9OjCooNvart45BWXe/ABqyKdkuFt35gttJ9dNYO2yCjxW6VkgAANQfrb48foTfTtDEgFau27pU2ar0Ds9UfFJ3kin563woKwpaOU/nxMcVnPDcBXLnHIuLYieBMOVqSmVdx6wKaR4zkJno02Y9j8k48DT3qh/La9x2xCUuQnTmCoVU1JzHWdT
 27GZbHcw
 5ldxt5xf2mJefMhSnywxuYq0xAbKQPXwVkPSZDXSkByLNTvKRZzxAFm7vonjfaxPXnh5V2Yhlt19ew8NOWNt6mLmytodDS0mJ0t+NXwTdC7k3BIWjK0hDTMplllvZsPfFD+RQ1d6nVOe6roUxRglF7K0z+jc08r85G8YZ8i4UzbiCytjUCpGos1Ms8N1IbLaThLJ4XaUpBDVbZ5wC2sYvMIkq9X5RfzBZUJr0t2A8NHLQ8rn9YdIwF5rmlG9S4ohwSWhLwrBqQeMputpTrv081WsBDkRfVsyhiEoa/7zA/o9mAZkpNMe9JTlakp2vhS36ncH47+eYPb90yQCHIm5qBHk5RMdZtxVvmAKyXYuuUivfVnwzJXVghzixqRdcNoR+F1ko8gJgghashzd8+lqof6/RUhinyqrZAboC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 05:07:16PM +0800, Barry Song wrote:
> On Wed, May 20, 2026 at 3:50 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Wed, May 20, 2026 at 05:18:52AM +0800, Barry Song wrote:
> > > On Tue, May 19, 2026 at 8:53 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > >
> > > > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> > > >
> > > > > >
> > > > > > I think we either need to fix `fork()`, or keep the current
> > > > > > behavior of dropping the VMA lock before performing I/O.
> > > > >
> > > > > I see. So, this problem arises from the fact that we are changing the
> > > > > pagefaults requiring I/O operation to hold VMA lock...
> > > > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > > > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > > > > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > > > > any VMA modification. On the surface, that looks ok to me but I might
> > > > > be missing some corner cases. If nobody sees any obvious issues, I
> > > > > think it's worth a try.
> > > >
> > > > Not sure if you noticed but I did raise concerns ;)
> > > >
> > > > I wonder if you've confused the fault path and fork here, as I think Barry has
> > > > been a little unclear on that.
> > >
> > > I think I’ve been absolutely clear :-)
> >
> > On this point sure, I would argue less so around the fork stuff but I responded
> > on that specifically elsewhere so let's keep things moving :>)
> >
> > > We should either stick to the current behavior - drop
> > > the VMA lock before doing I/O, or change fork() so that it
> > > does not wait on vma_start_write().
> >
> > Again, as I said elsewhere, I think there might be a 3rd way possibly. It's a
> > big mistake to assume that there are only specific solutions to problems in the
> > kernel then to present a false dichotomy.
>
> I recalled that when we discussed this part in my slides:
>
> ‘For simplicity, rather than using a whitelist mechanism for
> per-VMA retry, we could use a blacklist instead: default to
> always retry via the VMA lock, and only allow mmap_lock-based
> page-fault retry for specific cases such as
> __vmf_anon_prepare().’

Yeah that's an itneresting approach actually, sorry if I missed that.

>
> Suren mentioned introducing a FALLBACK flag. With the
> FALLBACK flag, we would retry via mmap_lock; with the RETRY
> flag, we would retry via the VMA lock.

Yeah, and honestly I'm beginning to wonder if we don't just have to pay the
complexity tax anyway and eat the fact we have to deal with that.

But as per Josef's comment re: this whole mechanism, simply not waiting for
file-backed I think is another option (but I don't recall where we left that
conversation actually?)

Anyway I want to make sure any complexity we add is necessary so will take a
look through patches and have a think (and obviously others will have their own
opinions!)

>
> Not sure whether this could really be called a ‘third way,’
> but it seems more like a shift from a whitelist model to a
> blacklist model, without changing the fundamental design, but
> it does change where we would need to touch the source code.

Right yeah, good to have more options.

>
> >
> > We absolutely hear you on this being a problem and it WILL be addressed one way
> > or another.
>
> Thanks. This is a bit of light in what has felt like a fairly
> dark situation. I really appreciate your thoughtful and
> responsible approach.

Yes, sorry, I maybe was a bit too harsh in my tone here, I didn't really intend
to be negative as to addresisng the problem as a whole.

Moreso I've been concerned about the fork approach, and that is what's led to me
being shall we say 'emphatic' about it :)

But of course I sometimes make mistakes in quite how my tone comes across, so
apologies if it came across overly negatively - I am negative (on a technical
level) about the fork approach, but not the fact we should address this.

To be clear - I'm very glad you've brought this up, it's important, as much as
it's painful that we have this issue in the first place! :)

>
> >
> > Of the two approaches, as I said elsewhere, I prefer what you've done in this
> > series to anything touching fork.
> >
> > But give me time to look through the series please (I'd also suggest RFC'ing
> > when it's something kinda fundamental that might generate converastion, makes
> > life a bit easier on the review side :)
>
> Thanks! Sure, I’m happy to wait and there’s no urgency.
>
> Last year you made quite a significant contribution to the work
> when I tried to remove mmap_lock in madvise. I really
> appreciated it. Now we’re back to the same lock again, just in
> different places.

Yeah :) one day maybe we can get rid of it altogether (maybe I'm dreaming :)

>
> Best Regards
> Barry

Cheers, Lorenzo

