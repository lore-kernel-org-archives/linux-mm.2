Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51C3D72352
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4315D6B045A; Fri, 23 Jan 2026 03:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409586B045C; Fri, 23 Jan 2026 03:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336226B045D; Fri, 23 Jan 2026 03:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6B06B045A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:48:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B972D13AD70
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:48:07 +0000 (UTC)
X-FDA: 84362601414.03.6AF0A56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D2AB40003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:48:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iZzwfhrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz1hmo4sSOhoz2FxWOsGfJMwh3+kqtlWiuCtHGdA2jw=;
	b=Nmmf3fbcDNbEPKoQlk4pPCvtMpxvev5pz4D47Pm6A5gz8a+h7S/ArHP/FTlL812PMNesI0
	oQEZx865TYASKXa4PvHZNg0jibYsuODRT+CzjpPmRULV3S9GgZ8AaoG/p9OMUpkGVXcHcY
	XjzZt06RowST9iNjyyt1l5jafZuBNt0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158086; a=rsa-sha256;
	cv=none;
	b=umJETtfELKdz/pykPhmIk8xM2S/in54914AqmTQusCnOyRXv7qDWgurtnKsXTYK3aPmjcU
	jMXLmQsULuCqtGWHiwg91YxHl6BJR7p8f8nMIJ45IJxfBA2NrH8zbgUNlZI/ak/lsOibVR
	2jjjv5FKhoEAQgiNNeaix09M/ZXErsw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iZzwfhrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C23943C2F;
	Fri, 23 Jan 2026 08:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4844CC4CEF1;
	Fri, 23 Jan 2026 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158084;
	bh=rVZ2b/M2elvLd9oSAfscYONQkqOhn+v+x4ixSf7WcUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZzwfhrI7qdWTFJkOeg6GtD3NUpF7uCWTGgbKZHOntekUsH4J8JTvqW098ocRzCy0
	 mkyk34UKQ6jFs/HDYw8akI+8dVLf/sfLOnkMsQeOIYAb4cHB6gE6TFo+FONSuXd73N
	 Vu0cIVG8TuunkM+qmIumzCLiv6A1OgNaNJU1No5O+eygLfxX/seRfMLgp/l8T+w2q7
	 ciGhYonIXO7EiE3bolXMNWxS+RP3HDORF3q+vul0iG/GLFV50NkZpyJ6sDlYd5ZZEP
	 hqajgJBbFBqFs2rsVOfURvyIB2OoEsKKhF5uTnpjlk08FLcuYCl1FUnHl4EroNDEDC
	 o2a3FepxtRh/w==
Date: Fri, 23 Jan 2026 10:47:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v3] mm/mm_init: Don't cond_resched() in
 deferred_init_memmap_chunk() if called from deferred_grow_zone()
Message-ID: <aXM1vUeSjwEG683R@kernel.org>
References: <20260122184343.546627-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122184343.546627-1-longman@redhat.com>
X-Rspamd-Queue-Id: 3D2AB40003
X-Stat-Signature: wu4u9q15ociaohox1nucd9e4dc3u16nc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769158086-933633
X-HE-Meta: U2FsdGVkX19NzIKMBgjQ0kNVISckfFkQd2P8YlXMY8UxMPWjI2V6zptPvvpiG5q/XEBO0i48+AXLOOculBqlXji69J8//IQ/d/so5S3tnygxus1nrzv69YyZA3A51DLScP0/vP7Xa7RCnC4uqZk3NygQwxYq6VmyRMbc3xQPkrjfxhGYRf8Anehf2HMCEt/tcCaSyTMja6qfLqIDX/l/jf4yAGPmmPTJlNouc06W14Vlz2wqQYdYvHxrC0GFty8VRpVUxoJWMAlyMB8JgVtZ1DDxXB+PPMQ0CRPZhgIrB3C+gUPG4+1pwtjCeUo09ERlWGSY8opEv6anZCK1Th1BVMGfGVkwuPJ3CSli267OaymzZLKOhrRdvcAdZF4IW7xXA+f0L2DINCrLZ+jQSIN7yorZOGRTmqhHhSehHiVKWPOkNc2QEgwio7FL+n0PbIZTNCTYEWqMxF6RhFSVXATD44027tBNvUJeqPoSsYVlrsEccXJQLRAKipJu6+erWLyvA+hxoPbkk2P6kiUgJrBJdWG54OWZhs89c3xzcalv+ZQF5/BWGVSBYntigJeqyC2c3vtdCYd4WmgdirVDmgTAYtyuih653i9OMqjRhmTuyCw10bTn1kKlGqqdHSGxh5hVN48Mt+CX7qIzKzXDZa2qiIF10AvWdsqr8h1L+D/KoudXD3eGTCnLPw4dhzl70rAYRJWcyUOxOYJrXVG7k3Iy/trVREEp+TNf+mZ0OFKhwzR3iBhqOics8Cw0ABeiC/z+Zasa7c872Z1sRFWkPyKz0xXp3mqKwc2EeZKIi62WAnM61Rvy8K2ib8cFjcPqa6o4SJHZb+9RRQPLz/yTsjLokWCJ97Yb8GIVL5kktaoBueDn5X1mUO8CuJJ8pQig8+h2GcwjnP1Mp8JqCiMPeGvnULkX+fvaW5hUdytcdAIhM2FXaRaQZvt9eWCX4FQCGSHqOg49mqd3qLF3NxrsQGw
 pA1rjzCh
 creOOub6QAq+WH6UEcUR0ZcwNuOmMpkEp29dTV1KPX0O2bc1f3/bglREzcVhYipvjQ9keioFMotR707E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 01:43:43PM -0500, Waiman Long wrote:
> Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
> in deferred_grow_zone()") made deferred_grow_zone() call
> deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
> section with irqs disabled. It did check for irqs_disabled() in
> deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
> PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
> interrupt but rcu_read_lock() is called. This leads to the following
> bug report.
> 
>   BUG: sleeping function called from invalid context at mm/mm_init.c:2091
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>   preempt_count: 0, expected: 0
>   RCU nest depth: 1, expected: 0
>   3 locks held by swapper/0/1:
>    #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
>    #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
>    #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
>   CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
> }
>   Tainted: [W]=WARN
>   Call trace:
>    show_stack+0x20/0x38 (C)
>    dump_stack_lvl+0xdc/0xf8
>    dump_stack+0x1c/0x28
>    __might_resched+0x384/0x530
>    deferred_init_memmap_chunk+0x560/0x688
>    deferred_grow_zone+0x190/0x278
>    _deferred_grow_zone+0x18/0x30
>    get_page_from_freelist+0x780/0xf78
>    __alloc_frozen_pages_noprof+0x1dc/0x348
>    alloc_slab_page+0x30/0x110
>    allocate_slab+0x98/0x2a0
>    new_slab+0x4c/0x80
>    ___slab_alloc+0x5a4/0x770
>    __slab_alloc.constprop.0+0x88/0x1e0
>    __kmalloc_node_noprof+0x2c0/0x598
>    __sdt_alloc+0x3b8/0x728
>    build_sched_domains+0xe0/0x1260
>    sched_init_domains+0x14c/0x1c8
>    sched_init_smp+0x9c/0x1d0
>    kernel_init_freeable+0x218/0x358
>    kernel_init+0x28/0x208
>    ret_from_fork+0x10/0x20
> 
> Fix it adding a new argument to deferred_init_memmap_chunk() to
> explicitly tell it if cond_resched() is allowed or not instead of
> relying on some current state information which may vary depending
> on the exact kernel configuration options that are enabled.
> 
> Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

