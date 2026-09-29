Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900CFCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC506B0095; Tue, 29 Sep 2026 04:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C296B0096; Tue, 29 Sep 2026 04:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3916B0098; Tue, 29 Sep 2026 04:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAD46B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:59:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA36F120458
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:59:34 +0000 (UTC)
X-FDA: 85266201468.03.B5BF8BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09C4F1C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:59:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sauccq4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790672373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH6NqdFwbzWFb6zeZpuetJKrjnA6GtjWSMB/X9fu530=;
	b=MHlsM6qQ+U2+KU1htGtXlbDmryvpXL8TvjmNHzLiCloko0I6bNd91gL8NanBvOgyG1ZjYx
	F+9SrI30TRHrPzApljnfqERMid4tQMux73XaihGvFK/1SmKxdjb7MEabvcI6M/SPSwBMFy
	eGus8bNfy+RykPx71b5hzJT/q19zNNo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sauccq4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790672373;
	b=n5bSXXr0Iyai8gyS1MALClgi+/27Wkf+MoxFo2IyrBhQrDf3knTHN/uG7aa0NbG/A3PMox
	c0V/GBcB/4sU8vOomJ/0oEq6sjhSJclfcNnUZYNQQ5Pw6AZVOdFdpF7mV5A6tjq+GKWil3
	NsuC1sKM1wIlPpPi11Dw0GhhYdU1tK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78C6241977;
	Tue, 29 Sep 2026 08:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6116E1F000FF;
	Tue, 29 Sep 2026 08:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790672371;
	bh=RH6NqdFwbzWFb6zeZpuetJKrjnA6GtjWSMB/X9fu530=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sauccq4nD1vS3R16bUqBJT3/gYHACi8YrQHkU6oyBUDgw+nTiGTFSmsTM0HOTzFxw
	 Ax8SsGH4ZeXvg6DUNr6bvTghN232LZ1keVbNh57zCOyk+IS7ItPXBoJLUkd1L2eyoI
	 drv9e4bnoVjU9RaCLcKMXFuETAdWsBrDZwX3wTy0j5hQYwSdQ/rHdcxPv6oT/XP9l0
	 +ca/RwwEiP79iQR83eW1RLRsRJ4TBKAxdcSC6Cb0nebZX7iD4ow7QRJJDi/tG5PyIn
	 Z+2DfrFg1FiOTkMkTF9P7xVRwvmEuaXc2lUUkpM16GNnaMVS3COBblO36eYihk8yFi
	 oovdCF9gp7OkQ==
Date: Tue, 29 Sep 2026 09:59:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <art8EKRKMdwSDCkr@gremlin>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
X-Rspamd-Queue-Id: 09C4F1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: d8rjx39g8hifak9abieuiokjtix1ds76
X-HE-Tag: 1790672372-415766
X-HE-Meta: U2FsdGVkX18h/Cxmuch9rZp1tTLW43a+HS5abw5C688uY3UPiToaAiEa06LvmB/oOE/dlMr5ttQKlrleUj0AwHaiNauitKtdjhCneZFW4YfN5RlUbaTg8JqVSDhEOWT73IRsDVXAnGzpf+Mn8ookHrYHvJfa1E3FtvEArdHyX22G8nq/EDKazcX6NwM8Bffa007uKGhMR0C1qQ9pGczOMMOSZ0wrMmXgmIE1HkOfZUbsFuxqYUYt8fX76ZstBQkF/Q5ZCbKG3jSMgtiZ6YXi4PYVvsLhrD3ty0THsc+ha7pxKt4+g/kw8jwaFl0KirePRBaFdtS83pZAkNfAgdizEylDpdIbbc28ZZQwhm0Whh20C69W1ocZ842sBA95950ylPTHuI7Y/fFVWSqVcyZqt3+tSPhBrO0ninbNy0UNq6dCAVbUIaAaN0Kz9/Ak56B45vLWUScgANIoPPWA69a7ZVz1htUm8GvA4UwgUHMPbPTfCkDc3Dp6IvMCHFJrf0WjfbGhpCXqtfXG7ylav1X0SFse/TyI7/aLOn9e4MjbyBFZj20v5R2dlSTd9LtVm+GGkhX+x88knudnGrwyeyhjCfWfQrXmamAfO6oGh5dZAGKd5GjnXT72Yoj/r7yLXH9ONwrcbKZZ9b+lH262jad2GTzm37nSTf0ZGQpoP4DyOogcJPSugFmyoI52z1/S0NcBlY7Gn4KjR8joAdx696uOyKuwj6ToodP/6+r3GZV1MRn9ZrfGKC0QIKA2dfFRx2w/5b4SlMGrggNu9qNTGrW0BQ8Z/5FgbbnVL4NKb3ag3nbOspUWGZvE3zetqSRl0bsVcy+vRj6VJ172vvPbZ4CLvB8EQWbhAkOj2heHZ5nTK8pMIfxYX6hSAmUmi6c8m7cBuzoJCDBnGx6PCYvLpk0NfcEgfO1hGv0ll/fkBlaWAyXOWgfHP7H2PP/W2wXseJfFuTWoquejilHlbhVfQKY
 uACg33r+
 GB/fnvYKO0JrLMXunIPdmMAc8lmlweowovYfh02+nFwYAqlK8M9oy94T/lZ6gpDv4vZpUbEmkGHU547fMIsVKeKtB012zkjTEzAKKo5e/uY+LipLRXEBosgqix2rvPNcLmrlHgzDwyD2Z4K2S5Xv4G6ZIBBkmZLqjF7+jXDH1fR74W6r2cNqdeaz+PtEmEE6lwRC+DJt3QDUwLyhXXw+bOGjZOVrkO12hlhbDv5VK/ehSKfRcecZ5683wojtqwRtcEpsPJNBOAUjgw9wzMFQ60KFw9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 08:59:57AM +0200, David Hildenbrand (Arm) wrote:
> On 9/29/26 06:06, 天狼 wrote:
> > Hi David,
> >
>
> Hi,
>
> >> What is supposed to happen if the process crashes when updating the
> >> MAP_SHARED region halfway through?
> >
> > The data structure survives an interrupted update through its
> > application-level copy-on-write and lock-free concurrency design. A
> > file-backed MAP_SHARED mapping preserves the latest userspace writes after
> > the process dies, even if they have not yet reached disk, provided the
> > kernel remains running.
> >
> > This does not depend on preventing writeback. Deferring writeback is purely
> > a performance optimization, not a correctness requirement.
> >
> >> It would be helpful if the use case + data structure would be explained
> >> in a bit more detail.
> >
> > The data structure originally used uint32_t offsets instead of pointers to
> > reduce pointer overhead. On that basis, we implemented lock-free concurrent
> > reads and writes, obtaining crash safety for free at the same time. We use
> > a file-backed MAP_SHARED mapping to turn that capability into an actual
> > feature that survives process crashes.
>
> Ok, thanks. Just be sure: you really need an actual file on disk. Shared memory
> / shmem / memfd is not sufficient?
>

I also assume MAP_PRIVATE mapping the file so it's anon CoW'd is not sufficient
either?

> >> What exactly is the problem with writeback here? Unnecessary I/O? Is
> >> writeback the problem or actual reclaim after writeback?
> >
> > Unnecessary I/O. Reclaim after writeback is not the problem I am trying to
> > address.
>
> Ok.

I mean if you're mmap'ing it you're literally mapping the page cache folio and
dirtying that folio.

So the kernel really does have to do writeback and it might be quite problematic
trying to prevent the writeback algorithm from doing its work on a specific
range.

I think the shape of a viable solution really is either MAP_PRIVATE-mapping it
or using some anon shmem/memfd as David suggests.

I think it'd be problematic to effectively corrupt the page cache by saying 'hey
this is dirty but just clear dirty state and pretend this is what the disk has'
or something.


>
> >
> > During construction, background writeback can write intermediate contents
> > that the application will soon overwrite. Those repeated writes waste disk
> > bandwidth. Delaying writeback would avoid that waste where possible; it is
> > not required for correctness.
>
> Understood.

Yeah again delaying writeback could interfere with the writeback balancing logic
which tries to keep dirty page levels sane and is fair and balanced so processes
that writeback a lot get delayed in doing so under heavy dirtying.

I think anything like this would interfere with that.

>
> >
> >> In a fuse server you can in theory delay the writeback request.
> >
> > Thanks for the suggestion. That sounds like a possible way to experiment
> > with delayed writeback. The feature I am requesting would make this
> > advisory behavior available to applications using ordinary file-backed
> > shared mappings.
> >
> >> So fadvise would be an option. However, this "defer mode" is really odd.
> >> It sounds more like you would want to have a custom policy there [...]
> >
> > madvise is not the only option, deferring writeback for the entire file
> > would also be acceptable.
> >
> > The application only wants to indicate that it is still modifying the data
> > and would prefer background writeback to happen later. The kernel would
> > retain control over the actual timing. Memory pressure could override the
> > hint, and explicit synchronization would keep its normal semantics.
> >
> > The hint should also expire automatically when the owning mapping or handle
> > is released, including on process exit.
>
> Ok, so while you are updating the large mmap'ed file concurrently, you don't
> want writeback to go crazy, because you know that you will modify the memory
> immediately anyway.

Yeah see above, I really think the only sensible solution is a MAP_PRIVATE CoW'd
mapping or memfd etc.

>
> Let me CC some more people.

Christian and probably Willy also? But I'm not so sure there's anything sensible
to do here other than something-anon.

>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

