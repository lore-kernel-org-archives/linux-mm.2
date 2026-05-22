Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC24ACD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0187E6B00A0; Fri, 22 May 2026 11:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2ECE6B00A2; Fri, 22 May 2026 11:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E717C6B00A3; Fri, 22 May 2026 11:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D73536B00A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:38:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91B6F16168F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:38:06 +0000 (UTC)
X-FDA: 84795461772.28.91C428D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D125E1C0010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:38:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3S85iit;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ue6+BrgA5cCiK29yEQFjVEW/61iWgshQWpISoK0a5mo=;
	b=RCb58aCXoN0Njin65xQ/JkcIyRP5Rl/Xyx5ahI3mp5CKJg+64rIghu6hNYvpImhqbagiYf
	3vyNK2WXktcYIFJva14JbI/8aX3GGnR7ZWIGmhmtkYBwjdpBSahxLLzjVUHFIvap+slwEh
	P7b51tRjCp0yen/vrA+Q6kiC77wzJKM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3S85iit;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464285; a=rsa-sha256;
	cv=none;
	b=ABYSSA71giKfpD8GRbFKClTxyRiC/szaE5QARUG1daT5bc/pmaXv+PK37uFdcGSdAea3Mq
	0G21NzWUkOnPWEbq+jPq5lHqmlLZ3Oox8HuYOrgdBlhPGX+Drv762IDTLvIejVscp4dbbj
	COtCAMwte10PuDFSsbNklWXWMM/VsdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE1CE41738;
	Fri, 22 May 2026 15:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4206E1F000E9;
	Fri, 22 May 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464283;
	bh=Ue6+BrgA5cCiK29yEQFjVEW/61iWgshQWpISoK0a5mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3S85iit9E//Da14omyK4sSzq5E+5P6CirUlrWrNKkWRCr0gH3q2SRSlfFihqMpFf
	 lNIJ+Ym6rgTd0CfoB7Pca50HGx7yg/Kc5w/2lEe4qOmRDVIKJHaZ2mwp0lyokkwzMM
	 6vLSr5NafsQy9TfFAYNw8jc2lOZNyREETBaXhqe0wsF6vVu5L5ph14ppOzYFh+6m+v
	 gJ/dcbqjjuTKEbZXZCc79Pa0JwpRwFDh/QUW0F5E1DEDjYhtDdgK1JyVd4OtmokLSn
	 On0u89WSmNioM38n363WRHRzMjaBZLPk3SQhu/mA8NqmleLSnwm2/5ltuBOTzidZnQ
	 dj5LZD2lAZZXQ==
Date: Fri, 22 May 2026 16:37:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ahB3DSwipVXw6tmK@lucifer>
References: <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer>
 <e6d1017a-e4c5-493e-bfca-932c6d64eaac@kernel.org>
 <CAHbLzkq3S7NDYe4LXjurKNQU+40-wtqrD_PT18YcyHbAcNxiRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkq3S7NDYe4LXjurKNQU+40-wtqrD_PT18YcyHbAcNxiRQ@mail.gmail.com>
X-Stat-Signature: hcz1m3azdn4wu46czpx51nn4exq4tro7
X-Rspamd-Queue-Id: D125E1C0010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779464284-721420
X-HE-Meta: U2FsdGVkX1/+ewXcok0zJ0/LeZXHoCrCS70Q9+j1cY396/B1dzunjyVqkVY/twzYWa2VJCICyfAmkEQnilk/6Tnn8ElMNUU1MMsdiJJN7XT7iR15IyFLW09NMtxYqcbQkJFriTrQkqSErLnOuIzV0OvZ91yjQU1ish94j8WTSIThqS6/hT/tjxpUb96sNIBUly1E9e4Xs2WWqzIJOE2BhZvt2JOHCisdl4Ly7EOGw8OxiSQ8lJq5dQ10NBK+AVsFzwlzoEXjy3+Ptdg6nlZ4koaVg75H2kN9qZ07h9GC9muSqHVGwmZqJUBisGqMueT4ujspIMS/Qrr/vYdgTqdofavOzaO9I+KaC2vhuOGvkdOLbT0jPscbW78pb4pY5/MJEeGoCf2E27sdU9pSufgiea2RKya8q8RYBfkApAwL58pwWRoZ/iMePqTEmXSQyr0eFUwA3hmXqCRbe4Ge9emsx0MTsO4oKtQTHpQhxUhiZoIA7/ymEdkRURJx/VVRvhQwNfzyJSaMGJkn0HCtYbFeo6HJFUVyrcvpJu9gmuuMOm4BdGjy9szaRx3SfYh5tKxNgCaloKC6/UzRDG50LNghpB+z53T62WDQD7Z/mmjmvhJMUjLPiwnJ5mkmrDC3FzZnGfNL89L6UlDwa4cB6ExLqTDzrhBYVb+140cXjhGvhq508gC/w8lF4hhQjlslm8BDSwIUZ2byBDNglZndq6w4MQ48TIE4Pl+bHZDtoIk0BrZIInYh8BbEtIlsGqXyd+y+hnDS3Edo5n52EPgQz/0PFsISK1SCqXqfzClE0ZGVoD5tN3taYyNwPKkmXblBQ9YhIfnpL4bL2qSX4RjtuOVkKth6qiFuzzsX40JET7JlLjIvZ3j/4iUXGOD47Q833AGYeP898mEL6dpfD/1fazvV+ZsNlTQ4AggvVUO1lt5vuLGBtiDW07uV2d4zi75AsGSBcSHQJy3YTgJ3WgO/kY4
 S7n1Dsl+
 hWs6oM5uyOZ7JmqZNRPhzWu/bqR1kiTJ+uP0EY+OQjhlRL9pYp4iUrfrZGvH0r1TSR5PkqbGEOA9/as5t0G9/Skr1sBe3UWxzbB0tQPAF5toLALW2sHazIf7TAyScl3edTvnYzFGzP90HPmnw9MtkvnqGLAHd6wa62O7RIqg9Tq4YiR0dCr/uk4lmGFoBxKMbcldIGIVwBxlF/H9LiQIxbTaYZG7wfkvKYb/rF3BKHwllgV4kK1X9Kzl6Nhh5GALmHDPx475vhXpYl4ql8eAIgzhDxm5muxtlMJgY6ywM4dKg7Ym+LTxZN2/mAPPBZjvuHYdwKBwYRgvorrikf9MFnD7rTBdYYqwh7Gyk8B7ex0A6rL3wFieLI/cE9mQGDMO1bJm/0WQE/Se7bBnhJc1kFaOmF6Jwz10ZHpv6c7e7mEp08jpm9JlSEOuYZdOkFoudPEti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 02:39:49PM -0700, Yang Shi wrote:
> On Wed, May 20, 2026 at 3:34 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 5/19/26 14:53, Lorenzo Stoakes wrote:
> > > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> > >
> > >>>
> > >>> I think we either need to fix `fork()`, or keep the current
> > >>> behavior of dropping the VMA lock before performing I/O.
> > >>
> > >> I see. So, this problem arises from the fact that we are changing the
> > >> pagefaults requiring I/O operation to hold VMA lock...
> > >> And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > >> is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > >> anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > >> any VMA modification. On the surface, that looks ok to me but I might
> > >> be missing some corner cases. If nobody sees any obvious issues, I
> > >> think it's worth a try.
> > >
> > > Not sure if you noticed but I did raise concerns ;)
> > >
> > > I wonder if you've confused the fault path and fork here, as I think Barry has
> > > been a little unclear on that.
> > >
> > > What's being suggested in this thread is to fundamentally change fork behaviour
> > > so it's different from the entire history of the kernel (or - presumably - at
> > > least recent history :)
> > I don't want fork() to become different in that regard.
> >
> > There is already a slight difference with vs. without per-VMA locks, because
> > there is a window in-between us taking the write mmap_lock and all the per-VMA
> > locks. I raised that previously [1] and assumed that it is probably fine.
> >
> > I also raised in the past why I think we must not allow concurrent page faults,
> > at least as soon as anonymous memory is involved [2].
>
> Thanks for sharing the context, it is quite helpful to understand the
> race conditions. Because Lorenzo also raised the concern about page
> fault race, I will reply to all the concerns regarding page fault race
> together in this thread.
>
> IIUC, there is already some sort of race with per vma lock. Before per
> vma lock, mmap_lock did lock everything. So page fault happened either
> before fork or after fork. But page fault can happen on other VMAs
> which have not been lock'ed yet during fork with per vma lock. For
> example, we have 3 VMAs, we lock the first VMA, but page fault still
> can happen on the other 2 VMAs during fork if they already have
> anon_vma. This is the status quo now, but it seems not harmful.
>
> The bad race shared by David is caused by racing with copy page. So it
> seems like it will be fine as long as we serialize copy page against
> page fault if I don't miss anything. Since we decide whether to copy
> page or not by checking vma->anon_vma, so it seems fine to not take
> vma lock if vma->anon_vma is NULL. This will not introduce more race
> either because setting up a new  anon_vma in page fault or madvise
> requires taking mmap_lock according to the earlier discussions.

NAK. No.

We're not doing this, we're not changing how fork fundamentally behaves because
of concerns about the fault path.

I've delineated exactly why I think this is a problem and you're pressing ahead
without addressing those concerns.

So at this point I'm going to be a grumpy maintainer and just say no, stop
please :)

Let's fix this in the right place. You don't fix a leak in the roof by repairing
a shelf next door :)

Thanks, Lorenzo


>
> Thanks,
> Yang
>
> >
> > ... and I raised that this is pretty much slower by design right now: "Well, the
> > design decision that CONFIG_PER_VMA_LOCK made for now to make page faults fast
> > and to make blocking any page faults from happening to  be slower ..." [3]
> >
> > [1] https://lore.kernel.org/all/970295ab-e85d-7af3-76e6-df53a5c52f8b@redhat.com/
> > [2] https://lore.kernel.org/all/7e3f35cc-59b9-bf12-b8b1-4ed78223844a@redhat.com/
> > [3] https://lore.kernel.org/all/2efa2c89-3765-721d-2c3c-00590054aa5b@redhat.com/
> >
> > --
> > Cheers,
> >
> > David
> >

