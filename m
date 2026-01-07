Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8429CD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990AF6B0088; Wed,  7 Jan 2026 16:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914186B0092; Wed,  7 Jan 2026 16:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D336B0093; Wed,  7 Jan 2026 16:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 706466B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:19:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E3A81404F5
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:19:32 +0000 (UTC)
X-FDA: 84306434184.16.E875B35
Received: from mail46.out.titan.email (mail46.out.titan.email [3.66.115.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id B59BD140012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:19:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=techsingularity.net header.s=titan1 header.b=GRT6GfwD;
	spf=pass (imf09.hostedemail.com: domain of mgorman@techsingularity.net designates 3.66.115.72 as permitted sender) smtp.mailfrom=mgorman@techsingularity.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767820770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Gsude5bCr/12iFzuhvBklS0UCcOFjMel4nHpQJlVUA=;
	b=tOWuZ3J4jpb9rpRO0EmAc1eTPvPJx6rKEWDE9MSOTCng93eGpGVn4SFfWMF9mTD498wHcK
	tVmifXSXBonM88DWwQpsAoJ4IzfciiSxCDnx09m4BPbk4djRmW+yqi4gu9BDE51quibNff
	e4ZPPDKtNwhMqSIjxA6yaohkLuUGWk0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=techsingularity.net header.s=titan1 header.b=GRT6GfwD;
	spf=pass (imf09.hostedemail.com: domain of mgorman@techsingularity.net designates 3.66.115.72 as permitted sender) smtp.mailfrom=mgorman@techsingularity.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767820770; a=rsa-sha256;
	cv=none;
	b=8DgUwUOwwH1yfstejq7xeJQpyYMgZ73aGIkCareAseBWDCEfYWhoAzkncNezFT5TRRgVkx
	a4DCWJ92EyGMkAJLT+lv2z7guzhul9ScsxD8s8FWYVn77yB2c4s7xx9T1jw+KG6/auDtag
	GsiY5ztMdV0Bv3dajGm79hW8JhKXmUc=
Received: from localhost (localhost [127.0.0.1])
	by smtp-out0101.titan.email (Postfix) with ESMTP id 4dmgsD0gw6z4vxF;
	Wed,  7 Jan 2026 21:19:28 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=3Gsude5bCr/12iFzuhvBklS0UCcOFjMel4nHpQJlVUA=;
	c=relaxed/relaxed; d=techsingularity.net;
	h=date:cc:subject:references:from:to:message-id:mime-version:in-reply-to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1767820768; v=1;
	b=GRT6GfwDFe8MjeAHbU3WKrjHJH5MTG7P8YHkSbQMBx54D0v53MuQJdCG5+JS3kgyrGD8/SK4
	0xIJuW6Q/2GJUf4qzG63maVHTQrzpMu5pRc9JTwzGkn0K8keeQZYXtRxc5kaz5DUiUGKzH0QJU5
	uxSEYB1hDcy8bRcRj6eAeiQk=
Received: from techsingularity.net (ip-84-203-20-110.broadband.digiweb.ie [84.203.20.110])
	by smtp-out0101.titan.email (Postfix) with ESMTPA id 4dmgsB4LfWz4vxD;
	Wed,  7 Jan 2026 21:19:26 +0000 (UTC)
Date: Wed, 7 Jan 2026 21:19:20 +0000
Feedback-ID: :mgorman@techsingularity.net:techsingularity.net:flockmailId
From: Mel Gorman <mgorman@techsingularity.net>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, stable@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH mm-hotfixes] mm/page_alloc: prevent pcp corruption with
 SMP=n
Message-ID: <h33pscn2orhpb5dapttmo4vy4s3drfsjaahmjp4arsjjfngzno@bzbacqjvfe6r>
References: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1767820767945683141.1240.1245684775781968541@prod-euc1-smtp-out1002.
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B59BD140012
X-Stat-Signature: 5u9ztrw7d99hp4pgrhnn71u8aitaikjq
X-Rspam-User: 
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=T/SKTeKQ c=1 sm=1 tr=0 ts=695ecde2
	a=5dAXIHdmPTy1nBlDlZrV4w==:117 a=ycgmuL0lqxUANBz+XI9aLQ==:17
	a=Q9fys5e9bTEA:10 a=vUbySO9Y5rIA:10 a=CEWIc4RMnpUA:10 a=CDkG8U_cDq8A:10
	a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=JfrnYn6hAAAA:8 a=R_Myd5XaAAAA:8
	a=MC9sqzVPiPx8m3HZA18A:9 a=PUjeQqilurYA:10 a=1CNFftbPRP8L7MoqJWF3:22
	a=L2g4Dz8VuBQ37YGmWQah:22
X-HE-Tag: 1767820769-929072
X-HE-Meta: U2FsdGVkX1+87npRkRl64MEvsfdHtpx9PbpTBLtdWXb3xuwPdAhdfpVkTeasTHmSsvdcH9hOl+G43PFXPGYVnifwLQf90gusBQcJ1TFrWAAZ7V5BKm3P68YOFmfS/3QnbI2DFhlPq24r0s6HBgPhZgbSDyoWkTdb0kRIQY6uc0MSc25zW0FHexyopdLbivGzpsCxeMjrmTaZ2qUFPUov0THdaCH+ulitkZUHamvbHViIwQ3wUmGdReNBWUDqDy1YgJiOH+P0cj3GYfgZF9Fqqz4YcexUhXpX3iOp/hVCAZcCqFLq+TnOZebYKkaUeskmJSQn/U/0UQPtCGpOPJhMkhekgVn0lRnW10MIdVYYIBYLAmR/Hx2rcxgo4hDGbVgU7qGH5MWqoT9WKvI/30tmETos+dVD8F7KW4Xyw4aZ9hFeE2z9Cu8atmXNJlC8whsyZCPQNj/nonVtNY37y12srJ6FgB1CTFYiIVxLO8U5mO2X/qdCwRjAqjXl3MX4BkSXudlQPGPrTduacckCVVviBS7ocs7CJJZdTZ6yg3kZnp/5PEonqs6wGFWtyHG9XTLW/nSf+1lBBVd9deX81tFiPndWdNzg58KEEgOJsb8/ub37b3+Ccri4qAhD53MJbQlmmVwN0Yf98bXbMrq5+zcTPasiaHCyTfMjaL1NJDTfSilCJEZ+FeESNB+UxxtdIYP5a4vNtcWAs+PyLvn7jI43MsQwHCEhaF74lai4GGY0EJqEH/JzJOZfDwzV3EBu0AP4FaT06c2sWCCXkw3SEYK/y8ho2lahRbsLAZYLjBXKWeBIL0J1IlyjlaTlKoU6BTStIQmxATuC87fasT1GJEe48CQwMuBmSNDnQi5gPt5XrOs0QhMuBEKpwx5b0d7Uc95BvHIdK0z/eu/p1r5rMbS6kIT2bXqC3PrD95v/27Ec2Dv9L6UMaMnueQCm1qGAWrxu1Eg6K2FbY65kqfdFImh
 QmU8pxEx
 nJi8loBLLJhc2LeD9A7HBVoD102Jvol2Sr6lbgBewMs5odykviWEHVcAoZeuI8buS8anWe317itETsm1r1BCreMUdayNuHktZAFDoUwdeUkBPDSoDqeFHGDC82yWfxYEHi70YcaOuYSQKsyhaQ7Cod0U6IN/cTA2ek6Hdm3xZLlBPk6a8Zj3NDKBLlgLu00u+r8BZnnyA83ZjvS7J5hUzfMnT3SG81HC4rQOQovtdb3HkMJmkHGY2iugKk93ueBuFW5v3SkkZtzDjbTOyoo0MbgUDvqYA+qmCMNakrE27tZc0tdB0ghd0xgy/ABauiSiGMgUjYw6Z7haskAxrVRJ+yeogUS/p4IiJU3G4CziwxP/ow4DTThTapqszVXgJYRsUY8Mmt3dK9qb8IUxbR5X8UpmrcXPlH3PxFVaiHviz2CWPf3GT10CSIu+S9BM25AIAx6sMD9mBJl8/w4OkrAJPytjMtMqT0CjyNVS/p6iu9ilpllKYtCN+O4AU3TqJhQr9x0BCYl5mLoiD5coVC4JWX0eZ43hiDAeV0wN6RcHeZH8KOeE3H1ZAjmitmqTS6bmHT85pnnKSXbJu/mlrGKpOZzDXtpkwROCczzmSrUvYl4i+WGC0QxXT4eIgXp6pVH0CD3XdNrbs0IKa8qXg9Q2hIEnfD5a8nv629B3KqBB6BSU4naDkHGsrikqiYvngpZjGQvee1s3GHmdLWarcxuuRvFMmcwxSsM7mnlN6sxZHZdXkrodprMpN4HZSwEkQLWt+d3y0koxPRUWE84bTdAjX06ybdiOpyxDsE+9VSzR49GcJTNh5sgHvUMm6PL2BiKhPW3aPRHjcl04i4m6q/SqJ6hlwPGRQ6f8DxQwUn6DiCOyAThasUWvWZvMO6vCNER0zMLWMl9qCdwSC/svLF2MK9nlJ8ni8YUk72I41sIjOK26bM04JuKSkus04r9Pa2gguNdQZUkKt2j8UHpjB04QEAzue3MG2
 328JRH1x
 0VQaaRHPZl5NZbacqae82U2R3QgrwhOXz7D1/P8Lu48gP0PHF77uY91P1vhkdSIyHYRVOXbqRe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:08:56PM +0100, Vlastimil Babka wrote:
> The kernel test robot has reported:
> 
>  BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
>   lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
>  CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
>  Call Trace:
>   <IRQ>
>   __dump_stack (lib/dump_stack.c:95)
>   dump_stack_lvl (lib/dump_stack.c:123)
>   dump_stack (lib/dump_stack.c:130)
>   spin_dump (kernel/locking/spinlock_debug.c:71)
>   do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
>   _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
>   __free_frozen_pages (mm/page_alloc.c:2973)
>   ___free_pages (mm/page_alloc.c:5295)
>   __free_pages (mm/page_alloc.c:5334)
>   tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
>   ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
>   ? rcu_core (kernel/rcu/tree.c:?)
>   rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
>   rcu_core_si (kernel/rcu/tree.c:2879)
>   handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
>   __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
>   irq_exit_rcu (kernel/softirq.c:741)
>   sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
>   </IRQ>
>   <TASK>
>  RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
>   free_pcppages_bulk (mm/page_alloc.c:1494)
>   drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
>   __drain_all_pages (mm/page_alloc.c:2731)
>   drain_all_pages (mm/page_alloc.c:2747)
>   kcompactd (mm/compaction.c:3115)
>   kthread (kernel/kthread.c:465)
>   ? __cfi_kcompactd (mm/compaction.c:3166)
>   ? __cfi_kthread (kernel/kthread.c:412)
>   ret_from_fork (arch/x86/kernel/process.c:164)
>   ? __cfi_kthread (kernel/kthread.c:412)
>   ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
>   </TASK>
> 
> Matthew has analyzed the report and identified that in drain_page_zone()
> we are in a section protected by spin_lock(&pcp->lock) and then get an
> interrupt that attempts spin_trylock() on the same lock. The code is
> designed to work this way without disabling IRQs and occasionally fail
> the trylock with a fallback. However, the SMP=n spinlock implementation
> assumes spin_trylock() will always succeed, and thus it's normally a
> no-op. Here the enabled lock debugging catches the problem, but
> otherwise it could cause a corruption of the pcp structure.
> 
> The problem has been introduced by commit 574907741599 ("mm/page_alloc:
> leave IRQs enabled for per-cpu page allocations"). The pcp locking
> scheme recognizes the need for disabling IRQs to prevent nesting
> spin_trylock() sections on SMP=n, but the need to prevent the nesting in
> spin_lock() has not been recognized. Fix it by introducing local
> wrappers that change the spin_lock() to spin_lock_iqsave() with SMP=n
> and use them in all places that do spin_lock(&pcp->lock).
> 

Bah, correct.

> Fixes: 574907741599 ("mm/page_alloc: leave IRQs enabled for per-cpu page allocations")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
> Analyzed-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/all/aUW05pyc9nZkvY-1@casper.infradead.org/
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> This fix is intentionally made self-contained and not trying to expand
> upon the existing pcp[u]_spin() helpers. This is to make stable
> backports easier due to recent cleanups to that helpers.
> 
> We could follow up with a proper helpers integration going forward.
> However I think the assumptions SMP=n of the spinlock UP implementation
> are just wrong. It should be valid to do a spin_lock() without disabling
> irq's and rely on a nested spin_trylock() to fail. I will thus try
> proposing the remove the UP implementation first. It should be within
> the current trend of removing stuff that's optimized for a minority
> configuration if it makes maintainability of the majority worse.
> (c.f. recent scheduler SMP=n removal)

It would be fair. Maybe it'll take a performance hit because from a
maintenance perspective, it would be preferable. It's true that
spin_trylock within a lock protected region on UP is somewhat bogus, but
not impossible either. Even if the resulting code is buggy anyway, it
would be preferable to fail early than hide.

> ---
>  mm/page_alloc.c | 45 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 8 deletions(-)
> 

With or without the renaming on top;

Acked-by: Mel Gorman <mgorman@techsingularity.net>

Thanks.

-- 
Mel Gorman
SUSE Labs

