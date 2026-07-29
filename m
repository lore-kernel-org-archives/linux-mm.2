Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938C9C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721C66B0088; Wed, 29 Jul 2026 12:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9206B0092; Wed, 29 Jul 2026 12:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E346B0093; Wed, 29 Jul 2026 12:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35A996B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDEDA1A072A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:25:43 +0000 (UTC)
X-FDA: 85042340166.29.D8F0F9D
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFE3C12000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:25:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Jg/ruSG9";
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785342342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3757SJdmqZVERewPVHqeMVYgjkUIDr+1uHBBRmZIMQ=;
	b=qlzdX8c1kF0JAHn/M1SG1ne52YHIrTUH1Y4p9cbhEPdb3/82mBwvg/ACWl7sDUIHy4YbpF
	E+29Q/3PFb6Nerk1L9fwtMW1haTdAut1hCsU12blToCDoYaVDMOtS6YQiWlNkv3B6ANbWd
	lTD6/FI1xNgTDWHan4IkBw02QeUgORk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785342342;
	b=VwGopv/L6WZB7S8vMrnb7IWI+HQHNEk3lraEy1BuvPjsJmoiC1BjyCr9EUFEHszHXjNuhh
	DAdDhinkewPFFVxhTLYQMot00dLnQcSy0tjiyWf+/IyETXil94eWOmiQLdKuilPdDOEU+J
	+YCvtXoLvAM+dcrKcr6yFTQToNV6JF4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Jg/ruSG9";
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 30 Jul 2026 00:25:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785342339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3757SJdmqZVERewPVHqeMVYgjkUIDr+1uHBBRmZIMQ=;
	b=Jg/ruSG9Q19yLyn2YpylYetRoq5tibhBI8BE85ok2sKXB5DAqvloeml1mJlNo4dXbiqkAU
	xXGdTKTsRBUXJZ2Fss066KONse6v6hVUzLL0qqZcCKtmFwCTQDUox/va1uOxRT6R8znmNu
	vuQfCzvaBulJE/aDRiP3wdLt0N1uvX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/11] mm, swap: dynamic cluster management for xswap
 devices
Message-ID: <amopdxwZErs_1TNP@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <CAKEwX=MNhfDr5WbkNAy7kO7z5JFcJT0DE+_hgMoz5Xi7vZ5_yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MNhfDr5WbkNAy7kO7z5JFcJT0DE+_hgMoz5Xi7vZ5_yg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5hub4877jgw9ui876tw47tzku98pdcs9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFE3C12000E
X-HE-Tag: 1785342341-637945
X-HE-Meta: U2FsdGVkX1/4BF/TWleV0KBiEXsmbwentXe46kcKt0EOiTL8Ug6yxZNKOONT03GECOf6QoSFph9l+cFlKWuqZYToKdwoZGJK2u27CJ51TY/6H4YCvkncorNns9Eg382w0xMPgg3jXu+3JTr9bj8zOJfKQ2qw1aJtj0YrsRWgp3O3MpPsKIwBxhJljYiy8YzgG0FmFWlp5gDcUU6nrGg1280xMCHYBkTfF7AjesXNFySsD7hqCUxII6QpYBSnWQy7WPxJI1fjGgzrCDxbAInDsCHiYQFS9tXlnNor4w/gI1M6vojspCZuIXuuT0LfTt2Q4KkMcMBfoyd8Lzp8UUG7+1Avv1DEMeQEjDgbYRNR893Q0frKYoiI1tegSUUki0nB4H0LLlDR//jyJxpBXCV73pPTGI6dVEo9ys2MFsU88IUYOZyP/5RZpc05IoLJgM8wfam8y3LleTGuVdVf0m/YBP50rQ3OzFwMaxvu9mFvZIDXMDJDgPiRkTJz/alcuzJTX5us7inuGeWc0/x8a/udzvy2eL3MePXSSJgsn1OrZSrzYxmQUWBvedc/U0JMlJqvecFxkdLS5CbIXgjRz/uza9K/PzRb+h5VuEP8gqprYLBqS7i411JTVpogX14Ar6SgC4r4mMmMBChgwV828mgiZuGSVXscTizUDJwPVpurigtcvhI7evl25mN0+xtVN/Q2W4oIF2BG7/ouweuLfU5O6rsZKVSM0v3V/Wh0oYjBhokIqs5A3UvZ8tLcp5Cei6mLAIWwaPDmOt23Yk6O84RaiJKjs2ApUB1PGHY0RpUnkisP6JqpDQgBajKfbtLRtxrGRwhy2s/sZB0LJfSLAnGnBvZ7Dg6aLFOcq2yrafqKrmUDThZ6UNFEfrOe1EauW8JX8ffmuERjzL0QtzrnMwj1wlOobGrx9wRrcAnzUFIUYXZthkSm+q4b2qr8ZyZA5k6lecsTlJygiQmVhzJfL8o
 1L9cI5SS
 kdei/2IAv+jn5oUoiXE7vSm65IjPLIXlLXEPtKj34h9FIFZDBItwFMScnODQXAOGJdN2dfDVbqajoAx9F+DiWSqhgD/vnwfCq2Ft6bnmInIxnmk3cIS4WDbXLqv0tsPKx4Yfn00oi8hFLQkOJJjQucAlNPw/2uKbhmID/1oiL6ey1ZP+RJctHGhWG3+9wavTffAx+MVAko0MrqTm7IGcVPJSE7iS0b+13DhjaSokOvCiQA+k5lAi9enOlWG8LtvqYHe7zKiB0bx56HkYoH853tV0ATA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/27/26 at 08:48am, Nhat Pham wrote:
> On Mon, Jul 27, 2026 at 6:50 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > This series implements step 3 of the incremental path proposed in [1]:
> > a virtual swap device with dynamic cluster growth and shrink, backed
> > only by zswap, no writeback yet.
> >
> > During the discussion in [2], Chris and Nhat debated xarray-based vs
> > array-based cluster lookup for virtual swap.  Chris argued for keeping
> > the swap table and cluster_info in the same place with O(1) array
> > indexing, and suggested that the kvmalloc grow approach here should
> > provide the cluster management VS needs.  He further proposed using
> > the same grow technique for the future per-slot backend pointer array
> > (vs_table), keeping a single coherent array layout throughout.
> >
> > This series therefore serves as the foundation: once the dynamic
> > cluster management lands, Nhat's VS series can build the per-slot
> > backend pointer, writeback, and rmap on top of it — without an extra
> > xarray lookup in the cluster access path.
> 
> Thanks Baoquan. I've given it some more thoughts over the past week or
> so, to figure out a way to so that everyone would be happy with the
> final results.
> 
> To be perfectly clear, I'm not married with the xarray data structure.
> I only care about use case aspect (as you have seen, I switch over to
> swap table the moment I figure out a way to realize Kairui's design
> proposal - it's way cleaner) - and I've seen that you have addressed a
> lot of the design concerns I had that would hindered the use cases I
> presented. If the vmalloc data structure outperforms the xarray, it
> should *definitely* be the data structure we use when everything
> settles.
> 
> That just leaves the sequencing of our efforts :)
> 
> My only fear with landing one piece at a time is that that we land
> something that ended up not working for the entire big series in some
> unforeseen cases, and we have to rip it out or rewrite a huge chunks
> of it. Besides, without an actual use case, we can't really test its
> correctness, and purported performance improvement benefits.

Thanks for the thoughtful and honest reply, Nhat.  I really appreciate
the clarity — and the fact that this is a sequencing discussion, not a
technical objection.

Personally, I still lean toward the incremental approach.  The cluster
management layer feels like a well-defined, self-contained foundation
that can be reviewed and tested independently, and landing it first
would let the later change built on it with less effort.

I think the overall direction is converging nicely.  We've reached rough
consensus on the big-picture architecture — decoupling backends, writeback,
dynamic cluster grow/shrink, and per-device xswap/vswap — that's a solid
foundation.  Once we settle on the cluster_info implementation, everything
else should fall into place quickly. From there we can move on to actual
swap-tier usage of xswap/vswap and other extensions on top.

However, if the consensus leans toward merging your xarray-based vswap
series first and then switching the data structure as a follow-up
optimization, I have no problem with that either. One concern: if we
land the xarray-based approach first and then switch to a pointer array
later, the cluster_info type change (e.g to struct swap_cluster_info *
flat array or struct swap_cluster_info ** pointer array) will cause us
touching those codes twice. Just something to weigh against the
"land early" argument.

I'm quite optimistic about how things are shaping up.  It's been a long
discussion but I think we're very close to something that everyone can
get behind.

Thanks
Baoquan

> 
> That's why so far I have bitten the bullet and sent out the whole
> series (even if it's really large) with the core use cases
> implemented. I understand that it is big, and is burdensome for
> reviewers - but at least you know that the core use cases works - and
> if you don't take my work for it, you can test with it and benchmark
> it, etc. And with Kairui's proposal, we still maintain the old
> machinery, which allows us to even merge with something a bit
> suboptimal, then optimize later. FWIW, so far in my testing, the
> numbers have been quite close, at least for zswap backend, and the
> core concern (memory overhead) has been resolved. So it might actually
> already be usable out of the box? :)
> 
> This patch series has reached 700 LoCs, and I still have some
> correctness concerns - I have commented one in another patch. It has
> gotten more complicated now, which is no fault of you - we just need
> more logic to handle the things xarray provided us out of the box,
> with the hope that it would be more optimal. And that's fine. I just
> think it would be better to land the xarray version first to unblock
> users, then just slot your patch series on top as a follow-up
> optimization. It would show the actual win of your data structure over
> xarray data structure with concrete numbers :) Win-win?
> 
> But thanks again for taking a stab at it. Seriously, you're awesome. I
> want to re-iterate again - this is NOT a Nacked-by Nhat. Not with this
> patch series, nor with the direction. I'm just trying to figure out
> the sequencing of our efforts that would make everything work. I'll
> spend sometimes on my own trying to synthesize this data structure
> with vswap design too, to see if I can fish out more gaps, and to see
> if I can clean things up in a way that would make the switch from
> xarray to this new data structure as painless as possible. As well as
> the other design points we have touched on in our last conversation -
> it makes sense to me at the time, but I need to code some prototype
> out and stare at it a bit more.

