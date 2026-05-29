Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8439CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363226B0005; Fri, 29 May 2026 08:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2E46B0088; Fri, 29 May 2026 08:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B57F6B008A; Fri, 29 May 2026 08:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05FA56B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:04:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5DC21C2D88
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:04:11 +0000 (UTC)
X-FDA: 84820324302.12.2A2210E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BACF3180012
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:04:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SXwaAx3i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780056250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S10gyhVYxahoA8Irz4eAewQjf2OZmpshI7uoubc38/E=;
	b=ehdBqHW850o8F9hKOX3rsdOGoHUDx35FKpvmRP9tKHyoJdtgZiS74Yge3iwCglaZgjwE1y
	dDairNSABURLzZBX4mKrz4gkCCTJmU63TnV9Zta+mu9eR1uPcFYx6oU/zL24oZtfwUGNWu
	8GZ1Pd3d7pPDlLV1DyKlI67cVlmZLEw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SXwaAx3i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780056250; a=rsa-sha256;
	cv=none;
	b=HsrFPNTkgOlg38bjTN+h4j5B9GiNg3pS9WwaWaRXILS+NBypnUNHFvsetqp0q8TCuz/Ezn
	pWHADstmSd2azGdozX2RPTqK3UIn6O8limB3oguI3GW/FDeQXTUCCnPlP4fV9SPvWpXIL3
	UYd+AxJW2xRLv6A0MVhotwDV0WF/HLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B15E0441F8;
	Fri, 29 May 2026 12:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E861F0089B;
	Fri, 29 May 2026 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780056248;
	bh=S10gyhVYxahoA8Irz4eAewQjf2OZmpshI7uoubc38/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SXwaAx3iEvTQtUvlgzMSScqJifFY1t2jzb7lWTw7MFUJfI+AuUj1bFRememAZ2fm/
	 7KXJexgp3I8iSkyNeWNAgMD8lhCObwWUL6TemUN4yE+WM+AOMxIwtm6hxkv0giNAna
	 77x2jcfZuS2Cbek6EzeuDMYDqxKzjx9sgi26NZj9LG0MWj3vFbFcD++D4an+t+vWGW
	 5Jt4mVinrFsvaIc3hWqRCPoLlfYMyhlFODqhQ/v/sh/5FRSLIf25f+Iw0C3pkJZWxm
	 t0jIfbiUKgjSYdGrMOOOm4n5hxuK2WBrBpRguD18NCHcHZO8xUBAag/hkKHUyMWDvj
	 CSczn3LWb33MQ==
Date: Fri, 29 May 2026 13:03:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: Barry Song <baohua@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahlzj--3Gm5pD9ge@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
X-Stat-Signature: 8779ptae7afquj9werp16rwnp8dgyurc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BACF3180012
X-Rspam-User: 
X-HE-Tag: 1780056249-290387
X-HE-Meta: U2FsdGVkX187l4L5L7fYk1EQ/18w7qO58x20eUShZypRCB3ZP0HvyJ5Dbv/rI8NbZxcNeIju66dAmHE5hj8CsgcAuWZLqb7h1X0zRS1tlXjC/gzFvQ3xN59c7apwTHEXzsZF07LPosZWv/6R4BQw48W6ZVfmRhr1RYCOudSpqMpWSs+5srZr349CM4iy09qP2FCLJoHwA5Qrv6LOfhHScX68HK2kNP7+weG5S0xhu1HQ6eKzlyvNrfdIN+59o5n48duJnG9YXmQu04Fwv12qhsmnj3+7yzpyGv4bBN4ntedWp1HnukSz/QVZ2CCu5o+IhlPx1EHDkqO9G1QoroKUXUoAD5e57aWFu2rYewoN3HSdnR3ERrS7C7DljiCeMSbCDwT//O733H3Af4wJci3QGvUVHb+bMTtOOUGjOJgCnQiE8EJ3Yq3DU+bZVWpNHg0sJbugnrKJEXRaCdr7UO/I1Vw5bKTA7qxH4RjfIbesjvrSquIzaSa1Fs6SZupqDmRECflo1jtmT1a89QAJm7s8qNBjESBoy81ENk1woQ2DjIMz8nlpmnNP3v+aj6G2sGPhCLoO7Yfiw32LmFaS/n3zZdsipZhAolfvf98O9jzpJMLXenpBuYkqg1ygDC4FH5spPzOCK5BhRrSREaNmxHHnnSZAaqGSc6zzmm/E3/wSMnhQb17rdU9wqLYlREzlShGCgI7ljrwFCmkL6M7XGuT3RXplqaREMHzNuHCJhncYa5JhqYUxCMb40TxwUreVPU1o1ZRUIa7pO2vUxeN63aUBBkpB9rHFWrgNaPjwHaebWMF4tdV+n6X//nWOrVOxn1GGaLUrJGmm3w/Pgj/HkYOZS/HoUFUAKKKWse93qSCeYhq4yibg+wJbWZRbgDnaIJ1ihD+NfdrpNTeeXx0S6LdUgQ22OABCWg23UJTc/648CGLg95Vwr7ZcJQxjmuEgoMd8vdrhVPv9btLX5yflyrD
 3viZhaNW
 2tmEHPeQyrxtZW9t/nHhdLg/Tlg0sL/Q1Byk/P0ile/X5PS3Twp8MFh6KIu6VCfhLLw99ecB0Dqwvu/p47SMgx7gs9KflnpZkxPq0yIfpsjUMQsvhUo3q4FnH2Xsx56bxABiopB1KRAPuL27VA3qKDenl6jW3iaNEiBR60Cq48HidzrDgo51kP7ExsQ/3IY13X1Bggbc6P3Vcs3VpX79AFywN3+AHzUY2rb0MYDgQyHkoO98xQcvLJ8FnY/9VN+32T+caWZiI+UeUB5ZFeBeD8pzDc93tqhVgdDtINERCMofm9jPnmGNgh+hm9QjNEsTILLn6rb+YCIzp1bE/LdNmdPxrtBjg5tiAhSfnl4AMPlGS6lLCbnpePN3l2JuC1UnJ0M8XLg28PIeKZBPMMidQqxv4n9r9kMUF1oforOOuAB5V6FvQnLdZHY024w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 09:41:20AM +0000, wangtao wrote:
> > Hi Tao,
> >
> > Lorenzo had a discussion about rmap in Zagreb here:
> > https://lore.kernel.org/linux-mm/aec533b2-37a7-4f44-a279-
> > c4aa604206ac@lucifer.local/
> >
> > He also shared the PoC code here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/
> > cow-context
> >
> > and the slides were shared as well. In case you can't find them on linux-mm (I
> > actually couldn't find them myself), I am attaching them again here -
> > "scalable-cow-lsf-longer-version.pdf"
> >
> > After coming back from Zagreb, I kept trying to find one or two full days to
> > read Lorenzo's code and slides carefully and write a blog about them.
> > Unfortunately, I have been completely busy with other work. Sigh... we
> > always seem to have too many non-upstream tasks.
> >
> > If possible, I'd really appreciate it if you could take a deep dive into it and
> > write a detailed blog post. I'd be very eager to read it and better understand
> > the overall design.
> > Otherwise, I'll try to find some time next week or later to go through it
> > myself.
> >
> Hi Barry,
>
> Thank you very much for your reply.
>
> I took an initial look at the cow-context code, and a few points
> might be worth noting:
>
> 1. cow_context_walk currently assumes that the rmap walk runs
>    under RCU protection. This may need to be adjusted early,
>    since paths such as try_to_unmap_one, page_vma_mkclean_one,
>    and try_to_migrate_one may involve task switching.
>
> 2. In cow_context_walk, traverse_contexts appears to involve
>    multiple nested loops. When there are many child processes
>    across several fork layers, it may not be as simple or
>    efficient as the current anon_vma approach.
>
>    It needs to traverse all child cow_ctx, and within each
>    cow_ctx, remaps_for_each() has two levels of iteration:
>    remaps_for_each_entry and remaps_for_each_entry_offset.
>
>    In other words, it first iterates over cow_ctx and then
>    traverses rmap_mt inside each one. The rough complexity

>    seems to be O(#proc * log(#rmap_entries_in_cow)), which
>    may be somewhat higher than anon_vma's
>    O(#vmas_in_anon_vma). However, in most cases the number
>    of processes is not large, so the impact may be limited.
>
> Previously, I also considered converting anon_vma's rb_tree
> to a mapletree. If one entry records a single VMA, the
> average overhead could be less than two longs per VMA.
>
> However, unlike rb_tree, mapletree does not support storing
> multiple elements under a single key. The key would need to
> look like (vma_id/mm_id + pgoff). On 32-bit platforms, since
> 64-bit mapletree keys are not supported yet, the remaining
> 12 bits are not enough for vma_id/mm_id.
>
> Because of this limitation, I later started thinking about
> ways to reduce anon_vma allocations instead.
>
> I will try to find some time next week to analyze the
> cow-context design and code more thoroughly, and then
> write up a summary.

Tao,

This response is so full of misunderstandings it's not really worth me
responding to any of it. You've even hallucinated an imaginary field which
is REALLY suspicious.

You've no mm expertise or history and came up with this in a few hours. I
asked Claude to analyse it and it puts it at 75-80% chance of being solely
LLM-generated from cow_context.c.

I simply don't have the time to deal with this, so unfortunately I'm going
to have to withdraw the suggestion of further discussion with you on this
topic.

I am working on the scalable CoW project and will solicit opinions of those
with relevant expertise.

We are not interested in your approach or analysis.

Thanks, Lorenzo

