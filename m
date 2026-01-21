Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14AC9C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7AC6B00A0; Wed, 21 Jan 2026 14:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6336B00A1; Wed, 21 Jan 2026 14:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2A06B00A3; Wed, 21 Jan 2026 14:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 478896B00A0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:43:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFEF4C3C34
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:43:33 +0000 (UTC)
X-FDA: 84356995506.02.6A90A86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 530601C0006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:43:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QRyULm6C;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769024612; a=rsa-sha256;
	cv=none;
	b=BoWoPI5iB56F6z1eEU+MDvQsgAl/mb/XOEIF5zzi3OiqYYJNh9HhswGSh6QUOSCPWsJKyH
	VX2DBVS9j7YQRikqTbGsSHjuvq+6hIaQUg6pJhlH10DiKQXdfzil1ihQEpV66m4ZKiRCxR
	/6TTNuPaRQhQuWtZUCUCeS9aSwwfrlI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QRyULm6C;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769024612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgW3JAKv1YqQXdDZa7FZGl4gfVToQ/eDvXos1HdI+QI=;
	b=ESPflACzCl9L5c9rxlRtx5jOxUWpdrS5qhA1v4eBMCW3bBgIoXXAEcR6//aZjF5kjPlY2A
	bJGnxf7HALR+oHhkJFpJSln4hbgIBdAcn08NWrXCZQh7zStQArWrlJtouqkGOjk7tqB9EW
	sbY72ObsfKzpJtbp37hoy4fzFHhiHnQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76FCE60130;
	Wed, 21 Jan 2026 19:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0EEC4CEF1;
	Wed, 21 Jan 2026 19:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769024611;
	bh=fcYWIsY0a8jIMini5uUJGd2fm0NxOpMRtgEzKTWhHT4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QRyULm6CgvL82pTCiKEubsSOP4+Sp5QzXCaiAOxoy0mSmABrwU+dA5Dn6zJDej0bG
	 FIt8bQf2R1qzEjPkHh+U2/phU6X/z7WYVfwrIRCXDoeyJvDC9jA1yysvMVrOWZ5lNF
	 fcxZXM9IBFBfEJ62arS8BA7Hv6Zgk8SM5odv+KCE=
Date: Wed, 21 Jan 2026 11:43:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <longman@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
Message-Id: <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
In-Reply-To: <20260121191036.461389-1-longman@redhat.com>
References: <20260121191036.461389-1-longman@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 530601C0006
X-Stat-Signature: f6853ayt6bgpg1hs8bf3wawt759wazsg
X-HE-Tag: 1769024612-441400
X-HE-Meta: U2FsdGVkX18acW0VWVqVkiOk4nIQr99muKKEj2Uza2N1frQyXMHVOZNybvCleAYEmUMx5XuKkxly+ecnHfvS88Ic8zKwIVMhde+L1yyeq+92FwkXWDXnT/e8Ka+GRC8hWiOYrfBKTupa2nmtSW4o+QwhBmf6y4ossvx+37/ZlIfzOGPvPNc0JGoH15rLSTPNxQ1xLxLY9Sb6d6IE5FoOJ62w1Kpon7f7IQ6Iin6/cLlWodyiLvKVri7/WLlavbYnwrXHgfhR8wM6MtMjFL9ENaYtP5GiGhdDdTUPLReX5q8b4oVdkS94kldJpsswMzYQ7l5zIch+BPHN2/Z/onUO4V8l3LKverY1Q4M16YtqHBhuq9/xkj6I54yZeHRbdb5uEM9+ZKr52sR2XCXB0Kk1wCCLeOeo/WAuJWQHlAW4e4DhdVezaNE8lVAXBFB1CD5LrEsuvUf9b19MU49kl2BM0rKS7+o1Ss57LCrMViB6nppKat2e+sz0ss4QY9KETRJyjHaDVPNm+aOFyxVomLu0c4gykmcflRJ5fjR1GqlL4EmhYtsoATyYjfmbbnQebUAk0zPzIICIT1BL6oIUOdabETi0vFrcnQDYkvZKZSQOj6ov0plgh1+uxXWXSpk5P/qMqM645ehaPfiKdLysn13Pn6CMf3v6SKyNtaz76FMoeaQ+/HkTbZd2YIxo3u2wnExY9rJyJP6cVDDxvV5cMLOPJ+QxxfkGyfVlot+RtB7oFEo0AvAaQ5EWC+qPG+hzfc0kfuYzzzvvKRINfCWHOawwr8iv7amKVUVn5hxcyeii8MobD+8Vpw3IoS5BNIsYOwyvthvbA2miH1Yv3kL6mzrMq97OHQ/E6NHWEajtDCudJWdfyTvmqQ3sboju/wwGyvYzQRe+RZR3KXc9CKmfB93Da1oDCv7cF+U1w/zhxkdtSUiYfodLTmpGmgIvUh9h7txicFmL7crrZvT1635Nh0s
 g8H4FAOt
 rMzTS83rVHYEMaXVCio8d3xd9olvOp4P/DylRCyr2ICquxVCAKaS+RfF8bHyrODkRSxOIgsjUiMt+UPXCYHVPCTipsArrTayoZGtMALhDFBY07RzTllsq48kqI50aS5sn+Lld62AE+OTmzyDu41M2j0BrqV92DovtkO2wr/6JfC1CMuy9uY5TKGmbwkuVYYFTqRz3bsV1KuwWBQRFHczfRe3ZiWGdIFQn0Q557sckcaJFEQ9/+DkY3GeOD8Yk8hvLISb3t0fjNBOnou/MW4rlq7/LilD9Utjd4FxBVkTqcbtonsnlg4ci+30AwsoffR1c/2QdjWQdIvSEQM0qrDGPPVnZpLmma9Y9q0chUoLDLiKPyIQmZnkFZOWikG0FMOMl70jjzWQ6NXB+A4U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 14:10:36 -0500 Waiman Long <longman@redhat.com> wrote:

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
> Fix it by checking rcu_preempt_depth() as well to prevent calling
> cond_resched(). Note that CONFIG_PREEMPT_RCU should always be enabled
> in a PREEMPT_RT kernel.
>
> ...
> 
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  
>  			spfn = chunk_end;
>  
> -			if (irqs_disabled())
> +			/*
> +			 * pgdat_resize_lock() only disables irqs in non-RT
> +			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
> +			 * kernel.
> +			 */
> +			if (irqs_disabled() || rcu_preempt_depth())
>  				touch_nmi_watchdog();

rcu_preempt_depth() seems a fairly internal low-level thing - it's
rarely used.

Is there a more official way of detecting this condition?  Maybe even
#ifdef CONFIG_PREEMPT_RCU?

