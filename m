Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAD810F9951
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0570E6B008A; Wed,  8 Apr 2026 11:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007816B008C; Wed,  8 Apr 2026 11:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38936B0092; Wed,  8 Apr 2026 11:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D230D6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:32:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0711E04F5
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:32:33 +0000 (UTC)
X-FDA: 84635780586.27.0ACCA7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D33B112000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:32:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cXAalaX8;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775662351; a=rsa-sha256;
	cv=none;
	b=ySLsS7TUor4UoewbdUUBrbBZ7ox42UK6a17dfS/aw9CDskMhGJJxxf5i1pzCu0gzvPZVx1
	r6eDPVx7H7tRRmKUuXw7WiULIZDqps6zvpw+dTK30keE9TbrMsRMhTWVTCAzW7GfSjS+ND
	g9Dz0qqXPUKwgcW4Hd4yxQ+WDoBySHU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cXAalaX8;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775662351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iym+0a0Q3LWMp7oJxjFLeJv8F2i2NNpdEhQLYauh2Vg=;
	b=DTF3RG99IkWgr55laeyRxTOJLCTM4zr39UglD71mXXupIPas3S7esqAGEN6SvEUWcrfxwO
	4tuOx//tl519pMvHuvre3s08FVltjFukvSML7D6UAPlBW1Cc7q0GppKvxlJe6V/Bv0HeE+
	JZMmCxRGvHsDTRCAnzcdI8nvl4elkUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35B9A600AD;
	Wed,  8 Apr 2026 15:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70835C19421;
	Wed,  8 Apr 2026 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775662350;
	bh=HO2ZYIG3YM4JE4/kgSviA/LwkaeYL9Ge2VXlcgtxWxY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cXAalaX8cQA5O0FWAdJ/j0E31YxR5hXdxTCgFyDdBG9qJqvKpOvZPH4M9x8F+kCfZ
	 r+aoE8qRe9m8d1lmxMGMNq/iAXbL4zNNsMbeDUWioFnq9LZ8JGxoeIisZR184H2Vxy
	 KV02QokV1S7zjW3gTXjWAtmDLzNQJ8ig68XgQBSk=
Date: Wed, 8 Apr 2026 08:32:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Salunke, Hrushikesh" <hsalunke@amd.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <rkodsara@amd.com>, <bharata@amd.com>, <ankur.a.arora@oracle.com>,
 <shivankg@amd.com>, "David Hildenbrand" <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Message-Id: <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
In-Reply-To: <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
	<22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
	<4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D33B112000D
X-Stat-Signature: jhz6nmrasudecynq7y4zd7fq5a861etq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775662351-544554
X-HE-Meta: U2FsdGVkX18uov+sebl3xS14DPJbmUaGY6ALLLrmULo2s+cWd1D9NRFkIF1v2fNoX8CoqkhWB746NuDfzbG/tq+0FS4JpYxqCvnwBdohtV/TLkSHCnbQUss8kZIOZ1BbVW4q55dwbqh2kDJh4WKnbC9lzh+ICcPAYI9JOIdb7FvAJAf/0Rb0Tj1B41uWyuIz92fvn+zrOuhDj8fD6mEdEntpAUGUeXVqKIxv5IaRtE60YzsNSxXFP0YOZ9tVzEF9DYR8IPPsn2r1oGaRMp7MYEA4hshUps2zQ67ITzQpztDeg5RI+ARg72MIsEvSRwg37e9OHUd0837FXEpGaTYyvmZ1rRGyxIDGSZMgnbYllG7EazFqVYD+sl4S1f7D6pSaf0b224zThgNdkw0CumgtbA9ic+2La+HWQU35gPixWrn/6gUp040V76ZevS91RB7YOcjGjHBLAj6b+piY0zTglesTgaAbYS7nt8Kb1ioisTdSiCYWyAZ+rts1GO28sXNcGdjm8kknatU2qJwWc4wpPapEsC5jWyE+23HlMIycHtsnJ+7zg4eT21DXptQytFarzdUgK1uewwWyE6wKbJWrTZ3lzR3M2Pfh2Rop1KPSFe6S9i0B2413lujBY9Mh39Oer73PKDoddtrJSf7wyGGeXpz69uoWfXerl3S52V2AWfvk4iYpEa35fgKxrvkahu3l5+A5t4YkSOISKva+Y5qXWU9wiR0Rhu3t596XPayjn3y5SGz6TkHMHRQkddo6gbQ/OWjTmQcvEnt96bJWr0PstKjudBLwIO9ssRnuyD/JadEdFC7vOlivdJdLVXiVUlXU35nNV6NtoADcvmOyGF0koDINBro1kcwHEh1PaJQk2PtZCx1r9UZZe5NzWObnfsvWS6wSHdXfwEL94aGhNI9SBrEOVMRQ7pmGrxOyi7SbhnaQ1zXLaYmkAfMIA/Imm2ljMIza3ensMj/L5TOkKUn
 H/7qaHp5
 frp/8mrOG9BG+A9OtXMjJinNrgZ0n6bUc+9wfuhwrGxA0t3th+XMWEEsOZLVxmTYFS7k4y1ExqAu9DMUze+O9TOu9jToK+EZE8kEDfNCh3A132HBURMKzViMLlaNeh4VMDBDriYSOo31LGT5E8muugkDfqdMGry/WsAxJ23/KAt441OSLuG7uFtL2MCADoK0gDDGrrT0gav6SqhK89uLm/f+0huoLkiK2H6pkuXKovfF84+SvYYn3W/rP3DlPBYXwHzn2yQvi0dxfr0yYNB2tr8ycj6zln8Wy7X8vOYrav6SUBey6lXHJ64n5zi98uovdzzcw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Apr 2026 16:14:03 +0530 "Salunke, Hrushikesh" <hsalunke@amd.com> wrote:

> kernel_init_pages() runs inside the allocator (post_alloc_hook and
> __free_pages_prepare), so it inherits whatever context the caller is in.
> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
> page allocation happens while the PTE lock and RCU read lock are held,
> making the cond_resched() in the clearing loop illegal:
> 
> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
> [ 1997.353572] preempt_count: 1, expected: 0
> [ 1997.353706] RCU nest depth: 1, expected: 0
> [ 1997.353837] 3 locks held by bash/19725:
> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
> [ 1997.353868] Call Trace:
> [ 1997.353870]  <TASK>
> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
> [ 1997.353877]  __might_resched+0x15f/0x290
> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
> [ 1997.353934]  exit_mmap+0x10a/0x430
> [ 1997.353943]  __mmput+0x3d/0x130
> [ 1997.353947]  do_exit+0x2a7/0xae0

tlb_next_batch() is (fortunately) using GFP_NOWAIT.  Perhaps you can
alter your patch to not call the cond_resched() if caller is attempting
an atomic allocation.

