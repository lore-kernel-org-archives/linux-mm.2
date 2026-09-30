Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBB2CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4005C6B0092; Wed, 30 Sep 2026 08:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D82A6B0096; Wed, 30 Sep 2026 08:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3149F6B0098; Wed, 30 Sep 2026 08:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1DB56B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:08:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B16114078A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:08:41 +0000 (UTC)
X-FDA: 85270306842.06.320E531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2E44100007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:08:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5ufWsKr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790770119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcPo3OnPL6RO7WwH35+drtHu3m/6Ime40gJXU1+/524=;
	b=Qn6v5G4V/doktQRojKFWIWsKuDMmkjPvuD6TI/eyfhpEaKkaQTQ0EPr/NNDiCSV/0STVvj
	jBWtmVSSnHZnR+E3twKIeO2USiW1pi+XwNbjI88oaCjn1h1Drkb1S9am2P2RH4mhtzoZmJ
	cJhU7i8vRbgqipKS76k+4CI792DCPEg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5ufWsKr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790770119;
	b=Zz+KyqOUKHtbQhN978/cooa3Ym7OCpSatGCuarCU/kChkyNDZpjqu6f9gYwfSnFA39FbY8
	bXGthw0eg2Vk4ajs1Lt+GU4TOOzbcrO3bPvYUFKyV3PdTnF0Chn09k7z/w5FxxaXD+T59V
	BfYnVACdkc/3bogM9GKB9t0EAUtoijA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE81540B6E;
	Wed, 30 Sep 2026 12:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743031F00893;
	Wed, 30 Sep 2026 12:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790770118;
	bh=TcPo3OnPL6RO7WwH35+drtHu3m/6Ime40gJXU1+/524=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a5ufWsKrcz4aVVeiS2LCppb3IIMjw1/skgfG51rMMiuR1Cwsaqgwk5mBKeB7BU7sn
	 efotMRaP2USZwSZxh4AvS3COM1aJMENH8ObZc/PcRWd44rW3MGcTSsu67+WWqASVZI
	 IkfgiZYJc89rCjz7ReygeiX/oIO5DurXn8JyRfh2oMw345y83H0tfgjrdsYdTGvpIR
	 Dxi6fZmytbZzlR6eiTMKDEabXT4REPyJlqYkwTbZyY+ymKqMrkxaHpEI/FS+7Zvjlq
	 8P5+Z21mddvvuiul9gM6O0XF5NLZqmCc+OBmtwllbUnjvUCiAzXkzd1YGscHYljHQo
	 YaO/H9TXZJbfg==
Date: Wed, 30 Sep 2026 13:08:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <arz0auULA33fqoWu@gremlin>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
X-Stat-Signature: u4t6gy1xo6j5dwu1usawage7xzifjyoo
X-Rspamd-Queue-Id: B2E44100007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790770119-484226
X-HE-Meta: U2FsdGVkX18DPvt/t2NFSOF2EkHYueteIVvz4NWab8WWOdj0hM+lxe6umofLQ/f4dXgOUqP5ztbVMiFp6c6/8u3SDcM9jXIxbh5hzrpD6OGW13E+3hSUCUvUbiJkrZlDZB4j53wWEHsdcJVOEgMIVtZyYUyNGjaHb2aBfWFI9lVXGALNchNUbdTaJPaGX1bZ6UpMrc4HPWa+vdrzMTOamhBtlfdh38rnPe+xQxpXdHygmxiLSQTXgP8PVy1CcW8uKb64kVeiNbrW1kZBlKnwla01IM2cmG5ObC+GoVz49ffQ2vGxUpR5NGIOk6zE3/NT9z+fmwlRH2K38T8tK05BtPrFGx0mJoOIwTKgf8d8mkUQhpXMgyG5bCunUDYTSuassZTOKVDkywYg+M7rJq4HyrzNSt/XkdCA5Asa5tUAlUv7Vk0b9y2oq0MnlMCVYdMx3QWg8XAhBOC9prUvvVE6LFVkpDLSA4cteg32Jq9tZSvmUz0RqZm5ZdI8KtzYFcUE/vTiJatF4y4rbxo++i9L4TTBtcLlWl0zqPRscr5l4x+cSZZ/J2KB4csZyWWsMD5Gtdqx51I8dhgZIbLHS/Kb/GgA2Eo9pwK/IxtJADiehN6aD3SR1lUW2xj6B/ab9yGUxYmh14PY/HkCH8Oc+Zc/zO0JbuYK6MxJDR4ijBJQkGSiGzrJDbxMEwb4XvCM+n4C03g+Umu6XN4kmWFVk175pjeQFRC4U1fxu773wcgm3tf82jvMJ+yHZHlNzCg8HbqNLbDj0m+nx4+SXRrxL+c/9bsq5nnAQ1QzSdA0LDgVZfFC4qhnyUGMSga+L1t6xX5nP9fUjuhBNyqL3ZMBaVh+jIMtalEth8iZn3z1aFvMKSYdagusTR3aWV9M7N1WcVbKpile0xmdMQ260YAMYJ+LbSSXnmRA0G/V8XUZB7zWLp2cd/D7P0tmAVXfcf4zW2otdUS5u/+BynjQt5Am5e4
 xrVlN7lr
 WFIqV2ZG6e8hLl3XgZYdvKCMM8p2Jdve0SThL6LuESBBd8n4q+H9dJ+FRQX/BAleIitYhBOOyf5JMUWF6YWfsQqr8R/kRlPLSyQjgvDduL1JCPizrY3Wrh+CDPJeRpO5lIOBlMsJfw8w3Dlw5YMWKvXGQjG3igGe+3ddTFY8pSBrzMfVqN28rS2+TUNAnrseMrZdKg0NY1Ybr/hMRy0EfceLhq15li4FT1lg60v/Fi1RQGD8/G8RLd6WWA9ALbp48ej8j97FNoNNEQaW41VqPxdF8tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 06:27:14PM +0800, 天狼 wrote:

> > You really need an actual file on disk. Shared memory / shmem / memfd is
> > not sufficient?
>
> Yes, an ordinary disk-backed file is the intended output, and subsequent
> consumers access it through mmap.
>
> Shared memory can preserve state across a process crash if the shared
> object remains alive. However, using shmem/memfd would introduce a separate
> staging and transfer step to put the data into the final file. Building
> directly in a file-backed MAP_SHARED mapping lets us preserve the latest
> userspace writes across process crashes and retain the same file-cache
> pages for subsequent consumers.

In general, writing to files through MAP_SHARED mappings is discouraged.

>
> > I also assume MAP_PRIVATE mapping the file so it's anon CoW'd is not
> > sufficient either?
>
> Correct. With MAP_PRIVATE, modifications remain private and are not carried
> through to the underlying file. If the constructing process crashes before
> transferring those modifications to the file, another process reopening the
> file cannot access them. That would lose the process-crash survival
> property we obtain from MAP_SHARED.

But you can solve that with a memfd?

>
> > It'd be problematic to effectively corrupt the page cache by saying "hey
> > this is dirty but just clear dirty state and pretend this is what the
> > disk has".
>
> To clarify, the proposal does not involve clearing dirty state or
> pretending that memory and disk contents match. The pages would remain
> dirty and continue to count toward the existing dirty-page limits.
>
> The requested hint only expresses that the application expects to modify
> the data again soon and would prefer background writeback to happen later.

But that's the same as saying 'don't writeback'?

When there's a lot of dirtied pages on disk writes are delayed in proportion to
how dirtied with various other heuristics taken into account.

I don't see how this requested feature wouldn't just give programs a way to work
around that, meanwhile everything else doing dirty writeback are _impacted by
the dirtying that the requesting process has done_.

That seems really problematic.

>
> > Delaying writeback could interfere with the writeback balancing logic.
>
> I understand that concern. The hint should not exempt the application from
> dirty-page limits or throttling. If writeback is needed for balancing,
> memory pressure, or explicit synchronization, the kernel should override
> the hint.

Hmm.

The delay before background writeback happens is, by default, quite long,
until you have a lot of dirtied pages.

dirty_expire_centisecs defaults to 3000, i.e. 30s before it is considered
for writeback.

And then that only happens every dirty_writeback_centisecs, defaults to
500, i.e. every 5 seconds.

If you're not writing to the mapping within 5 seconds even, let alone 30
seconds then that seems like an issue with your program.

I guess you are re-dirtying again with later changes, but the _triggering_
of writeback is at an inode granularity on dirtying - so you want to delay
writing back some pages because later pages are not meaningful?

All the while you are adding to the total dirty pages but not paying the
price anywhere, nor allowing the dirty page count to reduce.

Unfortunately there's no real way to avoid the per-inode thing, and
delaying valid writeback there because SOME of it isn't 'valid' is not
really sensible.

Either that, or you are actually concerned when there are enough
dirty pages to trigger background writeback i.e. dirty_background_ratio is
exceeded (where the above limits don't apply).

But later you say you don't want the proposed change to impact how that
behaves (the balance_dirty_pages() logic), which contradicts that.

So are you taking ~35s to actually write to this properly?

And is it that you're wanting the _triggering_ of writeback to be
per-folio? That isn't really sensible.

And nor is it really to delay writeback for dirty folios because later ones
are 'invalid'.
>
> The intended benefit is to avoid writing intermediate versions when the
> kernel has room to defer that work. There is no requirement to prevent
> writeback until construction finishes.
>
> madvise is not the only option, deferring writeback for the entire file
> would also be acceptable.
>
> Could such an advisory preference be accommodated within the existing
> writeback balancing policy while retaining its limits and fairness?

I think the fundamental friction here is that you're charging a cost to a
global limit then doing something that prevents that cost being paid (you
can't writeback), and meanwhile the process can wait for arbitrary time
before having to write to it.

And the fact that it is taking you so long to actually write what is
intended there that this matters suggests to me there's something wrong
with what you're doing here.

I'd say in general the shape of the solution would be something
cgroups-ish, but since all of this is global stuff and the knobs are all
global I think you need to think about your design a little more.

Having a process that is kept around maybe with an appropriate OOM score
that issues a memfd would get you the sharing even if process dies stuff,
and then it can periodically write to a file when necessary.

I think that'd work a lot better, and I don't really see a kernel change
here that would make sense.

All in all my intuition is that you're looking for a kernel solution to
something that should be implemented differently in userland.

And in general we've seen a pattern of 'writes to MAP_SHARED, experiences
problems' before.

And the solution is generally - use something like memfd, have a process
that does writebacks manually for you as you need.

So I strongly suggest you do that! :)

--
Cheers, Lorenzo

