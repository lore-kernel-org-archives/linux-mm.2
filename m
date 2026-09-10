Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CA2C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56F16B0096; Thu, 10 Sep 2026 05:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E946B0098; Thu, 10 Sep 2026 05:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44986B009B; Thu, 10 Sep 2026 05:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B52686B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:20:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C4D8A4D16
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:20:55 +0000 (UTC)
X-FDA: 85197308070.20.AE4DA67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 767F980005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:20:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8N2gmLV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8N2gmLV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789032053;
	b=bSgxPnmM5sJsST8n7NuMgrBWqL+eRIiG8keHctv1g+aglgnlDPZV2x3taUOaPb3GujcKx3
	kbyQ7ZWQpOELgfFeZzShUN1FZYh/QwmjlLy+HqNur25JQorrhA64MYySOYy5Tk09P1y5Sg
	/JE1/Gj+kGqSoEe2AavHNjcUoEgxZe8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789032053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqTjSSKuqTCF1mU8hfCM689lnN+IiDNFzRzwjltxKp4=;
	b=Z3LcKJag0QmJevKaPgJkfBSWh3kJoooL74J68Z5G+wB9jvIstvLahwx3LQ2rdSaMg5XLE9
	XY9aY9oC3v7I+5evUBKZQDMGGXGPL2zrg+w5QxxC+jskt3OeGBOPRpzbfxR1chibeLL71E
	KMFsGQkT2vet8mcwUkVF2BPKLnhajFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A25F7447AA;
	Thu, 10 Sep 2026 09:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093E71F0089C;
	Thu, 10 Sep 2026 09:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032052;
	bh=IqTjSSKuqTCF1mU8hfCM689lnN+IiDNFzRzwjltxKp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i8N2gmLVcVLG7tk5zvPtWOdiSMoN32tL5GsqkLrRd18I3N040Vz+EpntjxKI8GGC/
	 3GG2/Y6jNKHeIQGAzgzZboy55guFHdxAap2VEXM7+Hn0PUM5fa6hz/W9p8CuWdiLFG
	 GO6AWH15nOsBuy8Wi/XvrwB9ss9ZBjzkK4Jb0HSSkZwxONsSGmApur62G/NYhepnJc
	 4EJy47RXybU5ElqT1iPuKX3Nj4qLQrXTcEd207cZ0O+sbqKvCE5XjLqGK1zBTkzB4m
	 Cj2RFcnsW5kswVAV4Bylz3zuTJH4CVikBQKKCaHAITtv8cvIoYHkO2KjGQo3NCJz3B
	 MPbI3ZovEV9Vg==
Date: Thu, 10 Sep 2026 10:20:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm: bypass datarace check
Message-ID: <aqJnU1OtGhPBg2kF@gremlin>
References: <aqFWqqvUEiie8cYq@gremlin>
 <20260909212943.539665-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909212943.539665-1-trintaeoitogc@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 767F980005
X-Stat-Signature: 1a9a18eqyp61537x83stobe8kxkt8cce
X-Rspamd-Server: rspam01
X-HE-Tag: 1789032053-164209
X-HE-Meta: U2FsdGVkX19y8nZcO3VEHFDEg2Nu/751oesjOZKPBv4sVoz+zMkUojUL0/6w+UYU8pNR7hseFwvDNX22x7LUkewjMdwUqoa3rECG3X0cv/AxzTh95JZfCFycnCSxEKVwDwqLcizr6SMwoZS1ngyv2uCGACjXu2/TPI1F4HjTnpqpMnuh4/pOjIxM10kkDK4hzf6x0Oc/SQ4ZVGd0OKdG3Ng5pVCSJZRGkdbAY9pty368Z91+idb6Tfj6yh/n9+7x/97RTQJshFAYNGIyU9Akf0B0AyMTvrROb6yZVp4Ob4EMYP3dXZEyHgU0F/zXwr6Io8m8ESKZOq36IYZb9R1OjSXgI3HwcL5i0vfKmKGUHcrqtXlrOA1QqYu1BPN1BIWjafZBT8B3ICuZoLPri9RMK+4hqvxwK2/ZS6v5RsL4R5UyZosPmkR4ZGoH2a7EFAWH6iiHUz99LZyCtQ7IhRRdiR8to8lgVmY6AjdCfm034/TcbijqWdo/Bk00WVBPh3925dX68+4bHBhA9WsymLnafzC0O0Gix0BFnBnORqupP/jMpeBD65gtIEESrofRb3wlBWzFWdEpOkqSvp1p8aWB/wJoV+CmvIsNVeXUiBzlbPf53Z3Hkdg3tRs3yfRBILzfXL7WxeGoc4PdXaxBOKZxooovPnjkBCYCS2gEPImw3v8IcS56MkFhHGKanUp30vbJuBLHQUaR+br9DWTNYccOZBUBeWiQ6t3hgHtbPBNDkGGc5CQiNNM+bUhcFxKSYGJk17QtTgqykRe4AO+GSvwVGIFlrylFtBiUt3vhdFQpXRnMyCFa2MGkklRu6sC262vvSjwOqhRhYWUB/mykV9RmpIFu3iybyMEwA69aZUvpo7jgbpPCk+/QHSCT8fAV8g9m0px4YrfBDDDAmwKMGHix+RWKBGNsGTZc86c7t9im1WgdBaQcH34PDasjyqofcKQEM/IW0chtsorYMmO7VCP
 FraJpy0d
 79R6LqBADgNbMBKXryfJvUtBE8dRMGIM05XCxIxq5poB9Meo3wA3QWU3OqjEiBa4jh/wSoMl5yj70vEICbMEFjhl4azVBsdtVtVz7HGUl3UiEXYiRfazhX65D4WgLVkvY31wKjBftIVtenvjTIehKygoJ9CNh1MACoK3DRHo+avi2YU4O93bkL5vFhM2ywselXDbIWjLvXXpET4kU6SVYBLrZF+HuAIQwCYJbbbAuU2vrv2rxj21Snk1CQmkgXL8z84Ixv/wrixLZijU9AZoKnt3Id8cKHqo8tefEyaTlsLxxL1SG5ew4nlAVrR4bHUEH2Dnp/lgFaaR4OqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 06:29:43PM -0300, Guilherme Giacomo Simoes wrote:
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > I started review below but honestly this patch is confused in multiple ways
> > and it's not entirely clear you really understand what's going on here.
> I can be wrong, but was understand that due the order that the code was write
> probably the data race problem will not happen.
>
> The reader (__vmf_anon_prepare()):
> ```
> if (likely(vma->anon_vma)) // lockless check
> 	return 0;              // OK
>
> // if the check above fail
>
> if (!__anon_vma_prepare(vma)) // called the __anon_vma_prepare
>     return 0;
>
> ```
>
> inside __anon_vma_prepare()
> ```
> spin_lock(&mm->page_table_lock); //ACQUIRE semantics
>
> if (likely(!vma->anon_vma)) // re-check under lock
>     // ... alloc all
>
> spin_unlock(&mm->page_table_lock);
> ```
>
> This is safe because, if `if (likely(vma->anon_vma))` return NULL, we will got
> the mmap_lock and then page_table_lock.

I mean yes but it's complicated (the anon rmap is like this all over, it's
complicated for _everybody_ which is part of why I am working to change it).

There are 2 cases basically for _attached_ VMAS - mmap/vma write lock held
(you are the only thread that has access to the vma by definition) or mmap read
lock held in which case it's an optimistic check that must be re-checked with
mm->page_table_lock held to get exclusivity.

And it turns out that _all of mm_ screwed up some aspect of this also see:

https://lore.kernel.org/all/20260908122924.554373-1-tujinjiang@huawei.com/

>
> The critical re-check inside __anon_vma_prepare() happens under spin_lock(...)
> with has ACQUIRE semantics.
> With ACQUIRE semantics , the cpu (or compiler, I don't know) cannot reorder the
> memory access acress the lock boundary.
>
> I'm right?

Well the issue with acquire/release semantics is that instructions that are
outside of a critical section can be re-ordered within the critical section.

See my analysis here:

https://lore.kernel.org/all/ap6ybQeSg_rrmC95@gremlin/

(Again we were all confused about it! Memory barriers are very counterintuitive)

>
> >
> > It's also basically implementing what we suggested.
> >
> > So at this point I think it's easier if I send the patch with a:
> >
> > Reported-by:
> > Closes:
> >
> > tag -> you, this patch.
> >
> > Thanks!
> ok, no problem

Thanks, sorry about that but I feel in general, it's super sensitive and
confusing this and it's the best way in this case.

>
> > On Wed, Sep 09, 2026 at 08:57:23AM -0300, Guilherme Giacomo Simoes wrote:
> > > Despiste kcsan point to a possible race condition problem, this is a
> >
> > Typos  -> Despite, point -> points
> Hmm, is not the first time that any person points my english mistakes... I will
> improve this point, thank you for yout jints

No worries, I make typos all the time and have no excuses for it :)

>
> > > safe race condition due the access memory ordering, since
> > > spin_lock(&mm->page_table_lock) have ACQUIRE semantics and ensure the
> > > ordering mapping.
> >
> > This sentence is a bit confused. Acquire semantics mean absolutely nothing
> > unless paired with another operation and etc. etc.
> missing full stop, my bad.
>
> > Needs a:
> >
> > Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Yeah, I forget
>
> >
> > Also:
> >
> > Assisted-by: LLM?
> > The list below reads very LLM-ish so I have to ask did you use one etc. etc.
> >
> > https://docs.kernel.org/process/coding-assistants.html
> >
> > Perhaps given I am suggesting a lot here a:
> I don't have installed any llm (not even cursor), I just use a deepseek,
> chatgpt, etc.. to clear up a few questions. (maybe I should start use this to
> help me with english too)

Ah sorry, there's such a wave of it and the list seemed that way, I guess
because you had it help on the language it flagged it up :)

>
> > There are other places where this check is done and etc.
> I would should checked this, sorry. Anxiety.

Understandable, this is delicate stuff!

>
> Thanks Lorenzo for your review, help and patience

No worries! :)


--
Cheers, Lorenzo

