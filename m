Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5D8CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBE66B008A; Wed, 20 May 2026 08:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B416B008C; Wed, 20 May 2026 08:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2176B0092; Wed, 20 May 2026 08:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65006B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:56:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ED7D1C0151
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:56:11 +0000 (UTC)
X-FDA: 84787796142.11.E397F4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BF7340004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:56:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odw+ysF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779281769; a=rsa-sha256;
	cv=none;
	b=rNQHTm0y14h41xtBOBNbmWqm4GBp1oQn3r3pgdd1rM+OdaixsGh8D1GnW6jpj/8RrREuJI
	8DePb8NX3TNDeDck1KSDm9zyQEWsbVcqu2ItVejTQIXdbMonPJkY8WZNf1qxZLVlP/YY8+
	4QH9fzYXZlWogvz8X413HMH6wO2Gt0g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odw+ysF2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779281769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHcIhsCGtp+zFimfYJhlVXiifBlHPpWiDOsOVHQEJSk=;
	b=VcjXlaYCkmXM25QItdf2Tnhf6ZFyLv+iu+atM37qwodkGkboLBC9yewGo46x0JXacNrFx+
	VD4bxJ+zMB5Gkl8en1m4c8XoGchxGsXgCLo3J1XqOPzulRxVlppENd2FgIsgrjfIVx5k70
	GLulCEXK2rMTzBxwGq50fT4AqWxXDSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1BEF4184E;
	Wed, 20 May 2026 12:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195301F000E9;
	Wed, 20 May 2026 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779281768;
	bh=IHcIhsCGtp+zFimfYJhlVXiifBlHPpWiDOsOVHQEJSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=odw+ysF2fSGs0CYgREQtSvLkA7C1vnjLq+yTGH8uUyZQL5gIwy8l0sgOhMQFrvR/U
	 uhiwWUqoaRwvkgB0dpBHlc/BUJ1q5+UUOAqod11j8iXpTYoTcMdKWbeJzuR6xMAqQ+
	 OvTmgxH6iYYQP1hB8J7APtE6URdQBmktp1g/AVzlcWRxqXXJ8L/XVRnaqQo7zC7Xng
	 ETzTvLZhkt1SvKxjfJTjvTYcMABci75fb1o2/YPfIpAPbJkiRERe++WMYYQiw7kmc/
	 0b+T91xT73D5pkQltTZRR+EMWtVC4246AhUUcvutCmfPfiXeX8053NtPz89QYDfQc2
	 xRaHqWoL1+79g==
Date: Wed, 20 May 2026 13:55:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
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
Message-ID: <ag2vKm3K00wCiwUV@lucifer>
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer>
 <e6d1017a-e4c5-493e-bfca-932c6d64eaac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6d1017a-e4c5-493e-bfca-932c6d64eaac@kernel.org>
X-Stat-Signature: aqpmmkkoiwg1effe1yi4w9gxsmqn8de3
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BF7340004
X-Rspamd-Server: rspam07
X-HE-Tag: 1779281769-333851
X-HE-Meta: U2FsdGVkX18674lDj6rMK6sqs3m0KmBysA/q95CQiHWFxzBGRd6fkGVQ+Ha9ES0EHsJKAD4tx9hHqGgTIks7TEonHGIi/w04kpImGWeNQrOiPxWo3bewpxZGA75RvwVhimdY3Enz4Dhs5FAJhgTPtlyGsqBbSKYjWOg1JYynG9ngXsOPT5GZtOQ8djr3jRxvnSCvvISzzQ4MxbANhNnl8BGG1t22px+M4Ms4GufZp1xCCDkvA2P6N62kBp4sPi4JKFypj9fN8nIcn3kJ7LaTVwtvLrFMIc0uFUdq426cb9Ou2v+xktyEk9BCkDnFjCqGq7x/KBZuUXxDCWgiY92Ij55jb6kHoDW2TbfwInrW3wclyX2L1zNIM10i321cYUxpCLUqzwOuy1wjUGGDwug7U8c2UBHR+FXkYp0wkKfPcNoHEZG/BJLzmh9jkZH0h8Ulw/Rb+FozKZ0L3WJGTOpVZjNR2KMzKTEkXkOa0hBTpq7yC8lATd+zOYvTQwwD1u43d85TUaA7dhYARGRYs7SDCo63AuLzmgVNY21GSDeiaVS8gPa4A6mNCiCglhTDoxbrHlhnifRvo3zTXvrzB9ygop1K/izG8dSlNtRhG8ptKaDTFcOwhnKWO/1cDq/jOpmmKQ/Qi1wQbzwEx0dmy/ZepSenIHtxv4O+G/m9/EzeU5rJDNNluV1Y7ndUvH8uzD9itIRUQPYNnc0Q7EMzaDyEW2AyoVCeXp3T7ZaXkxMzTjtyxoLB4fYG+RwnttHuG6yReS0/teYxB+RrmO0Tnc5t6m6k49MMyVJw+0BUkIkSMOnjuxCGHBtekwEJp9u8SdS2oL1wMbr762DFg41sJa6nio2E+35gnzq0d/ie+4l4mPPHb3Pc8N8WBx3qICXeNqLfMCKhRuGxBMKU3XxdcPaZCA9pPi08U/3wX5hM/h41o0VDfIJx/X1O5bp5vdYKASWDftDpfXR0n14d7AL6EWk
 2H5f4b4o
 Y0TnBTg3FFZX9lw4vtqRYbzYQmyd9rln0ffupFAc/Y0jKpIU+0v0Za63E3HXW5ENZgbhFOaNfg0FTYkjfulwglKCBsojz753R/crctU5G8cupgOjcHDlgRu+PiVOdlrZnR7rcESZSGUjlgCxEcAVoveR92/l8PzNjpuYFeRftThNGwMl1jaOZiEryINMyLmrHoX5HwZeLlhw1z3+MyMHTd/Kd3n+10Bda6tV88fvfEl9z/P1vHXgq6cIFbmH8yHn3aLf+vcAH1K6X8aDougXv5LmaXMWy7twkR17VNXMa9Kl8FJKrHGgTZheAcZjPjm1ZT+ddD6PSqfsmH7ytmMQXmgV/KydeqdyTp03cITjVa9+jfLRm2y6yr7PHqq+rUD1qhuMfxzwIObkO0REDQ1wvDoCpYCuEiAhmloPC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 12:33:56PM +0200, David Hildenbrand (Arm) wrote:
> On 5/19/26 14:53, Lorenzo Stoakes wrote:
> > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> >
> >>>
> >>> I think we either need to fix `fork()`, or keep the current
> >>> behavior of dropping the VMA lock before performing I/O.
> >>
> >> I see. So, this problem arises from the fact that we are changing the
> >> pagefaults requiring I/O operation to hold VMA lock...
> >> And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> >> is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> >> anonymous and COW VMAs only while holding mmap_write_lock, preventing
> >> any VMA modification. On the surface, that looks ok to me but I might
> >> be missing some corner cases. If nobody sees any obvious issues, I
> >> think it's worth a try.
> >
> > Not sure if you noticed but I did raise concerns ;)
> >
> > I wonder if you've confused the fault path and fork here, as I think Barry has
> > been a little unclear on that.
> >
> > What's being suggested in this thread is to fundamentally change fork behaviour
> > so it's different from the entire history of the kernel (or - presumably - at
> > least recent history :)
> I don't want fork() to become different in that regard.
>
> There is already a slight difference with vs. without per-VMA locks, because
> there is a window in-between us taking the write mmap_lock and all the per-VMA
> locks. I raised that previously [1] and assumed that it is probably fine.
>
> I also raised in the past why I think we must not allow concurrent page faults,
> at least as soon as anonymous memory is involved [2].
>
> ... and I raised that this is pretty much slower by design right now: "Well, the
> design decision that CONFIG_PER_VMA_LOCK made for now to make page faults fast
> and to make blocking any page faults from happening to  be slower ..." [3]

Thanks for the background will read through! :)

But yeah I think the transition from !vma->anon_vma -> vma->anon_vma being a bit
slow is kinda ok most page faults will of course have anon_vma populated.

Be interesting with CoW context, because we won't need to mmap read lock there
at all :)

>
> [1] https://lore.kernel.org/all/970295ab-e85d-7af3-76e6-df53a5c52f8b@redhat.com/
> [2] https://lore.kernel.org/all/7e3f35cc-59b9-bf12-b8b1-4ed78223844a@redhat.com/
> [3] https://lore.kernel.org/all/2efa2c89-3765-721d-2c3c-00590054aa5b@redhat.com/
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

