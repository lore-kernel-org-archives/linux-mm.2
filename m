Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC93AC61DD3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0699C6B008A; Fri, 28 Aug 2026 10:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040C46B0098; Fri, 28 Aug 2026 10:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFD06B0099; Fri, 28 Aug 2026 10:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDFAF6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:00:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A94B160398
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:00:00 +0000 (UTC)
X-FDA: 85150836960.19.90C365A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 609AC18000E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:59:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MGYbK7pg;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787925598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/vQkPRWfO3dMD1qnZW0cONo4+Wv9gcM6DMq0ft41q4=;
	b=4zOaC974qayzNMbOuL2Tbuoa0zMOqCRFVQxM7q4NdQMabu93JDLB/2rNsPeoZrohMYA3xm
	Ia7rXBDIEdSjIENy1mJ8gkBeLMf1gMZ/tgKL+1SqgtD0jO401FDKvgtGzBVJ/tlhWGo0Yt
	vvi1Eh/deJCws4uTqImKb1hLTbEL10M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MGYbK7pg;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787925598;
	b=ObFd5EFiH+ft9+mJyxtD5gxBOe7yt43i5CzmkaSvvkwxB3o41kV7lv4tZ50zt+BnaTUndG
	RYYhBg5jBckM/rmLATsZH1Ofk3PS3wLg3Av9HG1TjgLcMvds35CgSjA2fO7gP9q+ysEryY
	bEHxYRFjAm7Eg3D9w3iLAx5rNvQlGbY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z/vQkPRWfO3dMD1qnZW0cONo4+Wv9gcM6DMq0ft41q4=; b=MGYbK7pgkLwreR1NbEJ2ExVAGl
	KTSjrpILVYOMD0bXalDOVqN/fVKi44fsPfymsoGuNmuRRaofeLVyUrTIHNb0siKB3sHW1QfFH/ElJ
	XJqv6SDJOSrPIt+kYiBVrZwpvDs7W76upT8P/0xg+JI1Uyn2mz5bsErnOPePpn3Q6EeVga+qZWe8P
	aFyvCXNgTh8vEzFs4LxWN7e6eFMAk6q9tFW/1D3cAhu4R2IZPpdqSf72p3g1JzFYqCHmn4H5doMo5
	+U3XKywepWEMgvPNZ8vWLa/1x4zGYEyw/PiASNH/8vyscBy1cgu06aUJ2BsbF/FK0ZwUBrskyEqax
	Yp9ajIzQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzx7U-00000008IYq-40GE;
	Fri, 28 Aug 2026 13:59:49 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5325230030F; Fri, 28 Aug 2026 15:59:47 +0200 (CEST)
Date: Fri, 28 Aug 2026 15:59:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828135947.GU776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828133620._x2XfJR_@linutronix.de>
X-Stat-Signature: 7uuu5uoej9ds6idcojogw73m93jx55o8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 609AC18000E
X-Rspam-User: 
X-HE-Tag: 1787925598-911302
X-HE-Meta: U2FsdGVkX19YiZMbxTk0mqaM9E8Vg/KdikudgRVMmi5Ptz4eLslbScEewG1C13jzwtWaAAFNV6ilf5qlw/oMpeqCk+EDj1h39blzyiTfEm05I92pc3PWRsTXKKhM25hEscygwqjc8Q5f+MHQJzYKvin2+nAgO31GLxy1pigV8rWnLPs8dds521gibGWOMnMAITduij2W8giMFinvC3PYuUY9Wm3RI3IYk+aAI+lRZV1n8MgRNERQguflW7uj6jr+pGjdMGo7jCXboocaydx3l5h6fFyzcaugmWrFOLERciilEKvWaLvMK92c6o8zlJ4laE4+P1gUOqIL5yRpp1hU2Zvw3wLt+MExAMcxoyow9t0wMNh4kDihAHQJZG35kvR9NyRDDiAWev9ADj7Ru3Bw35JQNo8Bwh0Wbp9eA9gTGBUPl1Wxbjdj5lWIQz+v2ewL20gfK3dqceIp3rT/MW2Gaw/708VyWW1vAzcPw20jf6XI1egm2PHmgUBf67l6ZvwSMotkQXXzTnbClsHk7sUBRvLQhuazIOGdnerTG4gzCoCgczyc9tJMq7KUmH4kdGv46N7Y5pUXZWYhYRtLxA3udXpAzzwjzGduLJZN8iv2Mzr749Sdygn5IDYH7nsBYI/T0G62ty0nc1dB+CRgFlzCBFdMDrk80QNN5v7ZXSzQBkaN9u7J5mD84A2r/i/a1gtHs/e//kJEDyM4c7S/j050KYokc/pAjkEm6yt6UcfXaSMCl2VH9dpvl3taPTUHIyfUez/QJAgYY2JbCfgSliQjiKNFBS8XW2ysClQNtVjJPTmBIKAiR6qLCg2ZJQypMd5qQDm2js5TGQk1LO0xgDmmQJcfMQpZ5acDtf12r2Ujr+hba3j+6dwU/Jv4DiTv7ZxzXYCfN8NVZ/rUkQPFn6Y80H/iuEk/wXbx8vBusnuYO+/faTHHwCiV0CKS+CkJsM2p54j5WrEJE0/64ZBb86r
 wp7okHZZ
 hh2N6vNubc8xYdiDvdl9m6+ysSsLwfC766bSRNSF89rWZZh3V4iaHXixeZmsUBnAWX//JlXzy2FtK/usl4fVMcebBWJ7ZMqjbB8vNcrzXe565zOPjqMVB0WBK5OKAghRALrAg+YfVsfTRmVZjzD0X8LG2IJVY4mHesddpod2UjTlUHMPjuMyjwb3xX9EEZEH7Nsqx1v/Wmj6RX56rG/0jHJw/vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:36:20PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-08-27 16:29:44 [-0700], David Stevens wrote:
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index fa7507ac8e13..adb4a5957996 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -1534,6 +1534,24 @@ config VMAP_STACK
> >  	  backing virtual mappings with real shadow memory, and KASAN_VMALLOC
> >  	  must be enabled.
> >  
> > +config HAVE_ARCH_RECLAIMABLE_STACK
> > +	def_bool n
> > +
> > +config RECLAIMABLE_STACK
> > +	default !PREEMPT_RT && !PROC_KCORE
> 
> This shouldn't default like this for RT. It either is useable or it is
> not.
> 
> > +	bool "Allow stacks of some blocked threads to be reclaimed"
> > +	depends on VMAP_STACK && !STACK_GROWSUP
> > +	depends on HAVE_ARCH_RECLAIMABLE_STACK
> > +	depends on !DEBUG_STACK_USAGE
> > +	depends on !KASAN_VMALLOC # TODO: add support for this
> > +	depends on !DEBUG_KMEMLEAK # TODO: add support for this
> > +	help
> > +	  Enable this to allow the unused portion of kernel stacks of most
> > +	  blocked tasks to be reclaimed.
> > +
> > +	  The wakeup latency of tasks with reclaimed stacks may increase,
> > +	  especially while the system is under memory pressure.
> 
> It says *may* increase and on RT it _definitely_ will increase since
> there is a kworker involved not to mention the memory allocation itself.
> Anyway. This either needs to stay away from PREEMPT_RT or find a way to
> exclude at the very least mlock()ed tasks.
> Did lockdep see this?

It should have. They're taking spinlock inside raw_spinlock and lockdep
should very much warn about that by default.

> If I understood the whole exercise correct then you have a kernel stack
> of two pages and in best case you can unmap and release the second page
> while the task is napping.

THREAD_SIZE_ORDER	2
THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)

that makes for 4 pages.

> What might be a tad simpler is to memset(,0,) the remaining part of the
> stack. Since the stack is vmap-ed it should be swapped out on its own
> without additional tricks. That memset() would help zram to compress
> better so it uses less memory. ta-da.

That would still be a 12k memset with IRQs-disabled and rq->lock held.

> What also should be simpler (and I am not saying just to move you away
> from the scheduler) is to have a shrinker which iterates over all tasks
> which are marked for reclaim and then similar to swap just unmap both
> stack pages and release the second page which is not used.
> Upon wake up the task should create a page_fault which would be used to
> allocate the second stack page and map the whole stack again.

Right, so you can FREEZE the task, unmap its stack and then thaw it or
something. But there should be a definite opt-out on all this, because
taking faults on your stack will be horrible.

Not to mention you'll suffer wakeup latencies while frozen.

This all really sounds like what should be addressed is this insane
number of tasks rather than trying to cope with the consequences of
that.

