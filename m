Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F67F531E6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 02:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37F06B0088; Mon, 13 Apr 2026 22:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6BA6B008A; Mon, 13 Apr 2026 22:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88416B0092; Mon, 13 Apr 2026 22:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2E1D6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:50:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DF571603B2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:50:14 +0000 (UTC)
X-FDA: 84655632348.20.96A50FA
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3D75B1C0009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:50:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776135012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bayHOvQQIo2JPsC/BFZ0TB2pODsaVqJeoQH6psRSml8=;
	b=cLr5b1Ka7TX+E4fnFoEQ3amcKv6EEj4jr/7rQxEQhwTk5GBG6gwGnApc3XCN45HPNp6Nc/
	vW1v21KV7ytMb9EWGrl5n3DCVk3zhra6POt35h+OssH6Q+pWZqTM6uy4Y5HRDXWxRDrKmA
	Q4tS1lzsPvbaYb9UJ8P1VFyqY1kfmoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776135012; a=rsa-sha256;
	cv=none;
	b=K0tZ94O3wOF9uNGKGFIwkXSKXOlyu8ivYEwJlXEo7Y0t1huPKKWRNsbbGx6oF14CZy/XSY
	OFHSuQcukBsy1BV9VZ/BsuE9ONgCLEG0GcFP2JttlmvOjhPbb0x0CJUeap3xHKFJWiRSL0
	TzYq9RNkDzq81sw+CEblZIGaDBEMtz8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 14 Apr 2026 11:50:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Apr 2026 11:50:08 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <ad2rYH9tUPthHFoj@yjaykim-PowerEdge-T330>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
 <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ske6bzb9fw1x6qgcg1nfq4en4y4frknd
X-Rspamd-Queue-Id: 3D75B1C0009
X-Rspam-User: 
X-HE-Tag: 1776135011-944346
X-HE-Meta: U2FsdGVkX1/jfMa4wlfhRgGublq08qwKEisrO8ao8xN8Wc9JMhZUm0aEpzzGYf0ugREPqFoQSvFtGY/f5qPZ/1QFs4RgTnc15iMJDk8SqIFrBUlgWSCc4djoYFn7rRVG9B2JwmSHEVzaqWycx8ONzMT/i+BpTnmrqiFtCQIwexo/YaEnKkvTBzJDfpeR650sEX6ajhOr4q954dcNK2NIm1dszPz54u+Xh0SNEbwE85bkaR8lquZFe9WY0lknsb2SL7cTOLC87mDpZjJOYVrrjZ1EGQGqSBVbtdAfEI/rZ16uqRcqNYv6OVE7uWIJIvKXsgqztQcuESGOdtfYd+7edovmGe1lUTLsxXXhOfIAVDAHKXwnm6eRfWbykVWLKbv0Zzs0pELJj28Zuw/RdovO7GOIgvc8W93tc6N1pEC1M9j0AQUyKqoLrrmsP1ehJbHP4QPCWzA8TePQ1qvEGTormpL1cGZCeRiTT1DZH921cge9jOvVSrF0WtIIbjEmzWJS7eXmNQew/rDIPR0IM/gcM7ET2KeP9APkacuQ6X6Ik6QK+j4TRPda62iqEjVpZv9G/+stvFkN3Nu6Hp47IgOX0YBjSJEpd10vFeMKOhqVfO/7+lTo1bQzALzUSbtEKyAEVCYC++dsXvKcVfEi4ItrPJC4hHDIZFhEvajNAf6HeK43+CO6kWyvD4G25k+hP35BPsXG5X57vf1x3s1ZktxhJmeJNII+ThbW+qvUZFXdiZXX/kaTK7r1CCF1uc46CUatLX0ki7hQ3lzOAps9NExO2NhkCWAb8QpKTMHM3Xf2u/KRQWqfZGNTzDnPQUwL5sqjZXoPRAbgngfFnVzSZZIvBkrU5SQ45Sc+LBgCzV0mosMKcqCdwLiAAZYApRV0hEHQkYoVYUhq9Qq7BNGgVQuX2yVLiih98NmyQi6mJQnf54yF0qUaUxTs9h1aCbunbzqRb04ywPR6ADR6RBPMCqa
 fxvyHOmA
 DsIpGe0zQjsDZ+Dx7qc/vK5gOjImZ12b1oPEFoSyVrFHaBWIM/C4IqdujhUq9YiOGUUV6DwfqW2A1eq/71pQsahG9KKTNY5diBuWazNytRD1DOfTf3t6QEcxN7vgUSfiylwIxLtlh/6ZaVkKJLuJAX1/Bi3j2UaN+Rvn0epErYH2hc087P8wEorw2rwJ8rVBiG9LH0M93zYbDiUCKgjEpcwjvddRmn6yGvH4898MCwdrZsOP+MKn+uaFXCnt9R1vrftnmZ4eLjtq4wyvCXVZ5BoJbTPA89J2Y/mTa+pLSRS1vwJV0L44gBSaEOS2Xz1vGAFFG9sCSMZEpGoB8hRNPLod0iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 06:40:44PM -0700, Nhat Pham wrote:

Hello Nhat!

> > 1. Modularization
> >
> > You removed CONFIG_* and went with a unified approach. I recall
> > you were also considering a module-based structure at some point.
> > What are your thoughts on that direction?
> >
>
> The CONFIG-based approach was a huge mess. It makes me not want to
> look at the code, and I'm the author :)
>
> > If we take that approach, we could extend the recent swap ops
> > patchset (https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/)
> > as follows:
> > - Make vswap a swap module
> > - Have cluster allocation functions reside in swapops
> > - Enable vswap through swapon
>
> Hmmmmm.

I think this would be a happy world, but I wonder what others think.
Anyway, I'm looking forward to the future direction.

> > 2. Flash-friendly swap integration (for my use case)
> >
> > I've been thinking about the flash-friendly swap concept that
> > I mentioned before and recently proposed:
> > (https://lore.kernel.org/linux-mm/aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330/)
> >
> > One of its core functions requires buffering RAM-swapped pages
> > and writing them sequentially at an appropriate time -- not
> > immediately, but in proper block-sized units, sequentially.
> >
> > This means allocated offsets must essentially be virtual, and
> > physical offsets need to be managed separately at the actual
> > write time.
> >
> > If we integrate this into the current vswap, we would either
> > need vswap itself to handle the sequential writes (bypassing
> > the physical device and receiving pages directly), or swapon
> > a swap device and have vswap obtain physical offsets from it.
> > But since those offsets cannot be used directly (due to
> > buffering and sequential write requirements), they become
> > virtual too, resulting in:
> >
> >   virtual -> virtual -> physical
> >
> > This triple indirection is not ideal.
> >
> > However, if the modularization from point 1 is achieved and
> > vswap acts as a swap device itself, then we can cleanly
> > establish a:
> >
> >   virtual -> physical
>
> I read that thread sometimes ago. Some remarks:
>
> 1. I think Christoph has a point. Seems like some of your ideas ( are
> broadly applicable to swap in general. Maybe fixing swap infra
> generally would make a lot of sense?

Broadly speaking, there are two main ideas:
1. Swap I/O buffering (which is also tied to cluster management issues)
2. Deduplication

Are you leaning towards the view that these two should be placed in a
higher layer?

> 2. Why do we need to do two virtual layers here? For example, If you
> want to buffer multiple swap outs and turn them into a sequential
> request, you can:
>
> a. Allocate virtual swap space for them as you wish. They don't even
> need to be sequential.
>
> b. At swap_writeout() time, don't allocate physical swap space for
> them right away. Instead, accumulate them into a buffer. You can add a
> new virtual swap entry type to flag it if necessary.
>
> c. Once that buffer reaches a certain size, you can now allocate
> contiguous physical swap space for them. Then flush etc. You can flush
> at swap_writeout() time, or use a dedicated threads etc.

I initially thought implementing this in vswap would be complicated
(due to the ripple effects of altering behavior at swap_writeout timing),
but it seems entirely possible!

1. We could change the behavior (e.g., buffering) at vswap_alloc_swap_slot
   timing by checking things like the si type.
2. Additionally, if we can handle the cluster data structures and
   mechanisms in the swap_info_struct privately, a virtual-to-physical
   one-direction approach seems feasible.
   (Come to think of it, it might be better to refactor the infra to let
   other modules handle this, potentially removing the swap_info_struct
   mechanism entirely. Just imagination ;) )

> Deduplication sounds like something that should live at a lower layer
> - I was thinking about it for zswap/zsmalloc back then. I mean, I
> assume you don't want content sharing across different swap media? :)
> Something along the line of:
>
> 1. Maintain an content index for swapped out pages.
>
> 2. For the swap media that support deduplication, you'll need to add
> some sort of reference count (more overhead ew).
>
> 3. Each time we swapped out, we can content-check to see if the same
> piece of conent has been swapped out before. If so, set the vswap
> backend to the physical location of the data, increment some sort of
> reference count (perhaps we can use swap count) of the older entry,
> and have the swap type point to it.

As for reference count management, applying it loosely might be a good
approach. Instead of strictly managing the lifecycle of the dedup contents
with refcounts, we could just periodically clean up the hash. This also
has the benefit of reducing I/O for the same swap content compared to
deleting it immediately.

> But have you considered the implications of sharing swap data like
> this? I need to read the paper you cite - seems like a potential fun
> read. But what happen when these two pages that share the content
> belong to two different cgroups? How does the
> charging/uncharging/charge transferring story work? That's one of the
> things that made me pause when I wanted to implement deduplication for
> zswap/zsmalloc. Zram does not charge memory towards cgroup, but zswap
> does, so we'll need to handle this somehow, and at that point all the
> complexity might no longer be worth it.

Since our private swap device is similar to ZRAM, I hadn't considered
the charging aspect. It is indeed a complex issue.

If it goes into ZSWAP, there would definitely be a clear advantage of
seeing dedup benefits across all swap devices. It's a technically
interesting area, and I'd like to discuss it in a separate thread if
I have more ideas or thoughts.

Just a thought that comes to mind here: if vswap becomes modularized,
how about doing memcg charging for this entire area? 
(Come to think of it, to fully benefit from vswap modularization,
zswap should also be applied within its scope.)

Best regards,
Youngjun Park

