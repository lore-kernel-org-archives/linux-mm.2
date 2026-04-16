Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45121F8A160
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989CA6B0005; Thu, 16 Apr 2026 08:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93ABB6B0089; Thu, 16 Apr 2026 08:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803A96B008A; Thu, 16 Apr 2026 08:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE936B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:28:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1D648C52B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:28:29 +0000 (UTC)
X-FDA: 84664347138.30.37940A5
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09EBF1C000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:28:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p5fsBm5a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776342508; a=rsa-sha256;
	cv=none;
	b=jaYJk6ld5E9cfR2Cq5puAiz0fbu7o5zMT6SBfMZxjaRUk/uHtcxmpTTymakxOuVX8g+mIp
	NwcsAquyl24ReE4fyg0AiCEcDj/nAJLjfbZFNA3w8aVmJs5Gc1C1OOpizPzSUnu1jpIYDd
	fOoD44SGX3N3MdzG1YiRWTwroHHTt70=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p5fsBm5a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776342508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZ9wqYq/QjB3jbobfNvsubm1vMuCdM+BbT/Jqfm468w=;
	b=LpnPV1v1D/76f+VGMZN8Saq3u+ZeC2h0i20JkZzizln5XM0QNfS133mzb1uQEIwfaf2GLC
	JhoxHaQ23/0RCoaSv5NxxqCCZl8HPBrN9/E/CjvGXy46nqyXvl6NbFT0V7s3tYncYaypiA
	HQDCYHrYdcZybB37t6RZl1J3SmLTt2U=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a4053964e3so4097780e87.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776342506; x=1776947306; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sZ9wqYq/QjB3jbobfNvsubm1vMuCdM+BbT/Jqfm468w=;
        b=p5fsBm5a3q/L1HaJ6VG0Ln4XvZBMY+PppOgup3wC472n+wYpvVdz+7CmcZsWYlL6Ih
         xGB2KV0X06qaftu5QHPxEyiRvNxHyMmqpCilDSRPIzMXaWhEaZJLRW7LG/fAkY8N5+jr
         Xob9ERFe2Bby0Z3Hsa0f12sWzoMHXD2KrsyN5UqX/6xQfJlNUbE6yVjx2PTgtXwcCMSf
         C+8PG0TAvX+0Xk/43E0YS0PPhv0Ojd1q85fzjITC7gACipxNFTriTYwGj5Djo8CkJd8y
         LgRr2oMpOVPqs+I7F7Y53X2J7CmiG5/9t2AJWfGFIKCOukrStfx9AICbBfg1BMNd4XgR
         0Q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342506; x=1776947306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZ9wqYq/QjB3jbobfNvsubm1vMuCdM+BbT/Jqfm468w=;
        b=bohN0/5zlC9BB9scwttcFLKxBM0/DLqjWHoKYgEUIsClDfajvq9yqpqSL4k0B+l/c0
         QyD/JopGXNguOV2P/n6hdX8Hz6UY/XyFini5ONbCkPjlR+c6+ioehof8I/1TPr/Em0p4
         ajFdJyb7TD74qkOfSaRqvof6weI1GY9gnc8F4+fzh7zAVYwrSij02nh0QBe65mBkmH/U
         8H46yVKpOO21f83+QzCRDLnRS4NQhm2/Miofn1neLQ9QidrtIcWtXkuWanKjkogewIAh
         C0KJ9bEcTSefvQlXxMJMhy6+PkiNJiDqygE7gzXA7TMXtRKhkuGPpzJdDvtLPfWcuGAb
         jj5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/zJnT6MJPbQf4ENwKY2+5F2tdx+GZlzBJA+niw/LzkVfLj4S/ZcOH5aORXzFpluBCj4udQYf7/Xg==@kvack.org
X-Gm-Message-State: AOJu0YxIv2d2HLoP0AUcVc7qRXcqCkWUanaGxEn6qfuVvgoVPvnhnXPW
	AdEUToLjkvgv5yoVoIbUs9YhLZuFiNTx3+TXyOJaGx1U3+iclXJUJYx3
X-Gm-Gg: AeBDiettMUmpG9IvdUrABM/qLgTsSSXR+VyakBzvKjPNGtmocjwDH+f1gHOJbpe9WxY
	v4H7wdb6QhTp9ie6SnoK/PPm0relw5tG6ImyM4XsAOeN59DCuCvU3ewuSdvbjgBBhjhEqfZdAk7
	nQNrliZX74jN7diTimCJzs5qpscA6uZt4ea0JBO5SII0ouIebDxYp1OPnvUc0nCCMWvj7MsLN7q
	e9LED53tbJGqoEQ6Vg4GBt79gZCWZwHUyjCWUyKlr8HLh5yAgXiHmdxRUWqTkFVfOhlb45IGbha
	ZKwgi2Pgr/ccA/sO/1xAPKs5QOfmO/J8gR0/rQN4w+vdyKBLHt71KPMIjDXEK5YXJat6KsDQbVN
	6jQxdOvKQTO1ZRBGfdDi8uv2WHMSFhH0UysMVb+OKcn+kkkf2HOcG2gG8VYHdvtW7
X-Received: by 2002:ac2:5604:0:b0:5a4:10b5:624e with SMTP id 2adb3069b0e04-5a410b563camr617997e87.24.1776342505434;
        Thu, 16 Apr 2026 05:28:25 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a40a308feesm1235140e87.78.2026.04.16.05.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:28:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 16 Apr 2026 14:28:23 +0200
To: Sechang Lim <rhkrqnwk98@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: Prevent RCU stall in decay_va_pool_node()
Message-ID: <aeDV5_fiMCNpjN9G@milan>
References: <20260415084837.1001739-1-rhkrqnwk98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415084837.1001739-1-rhkrqnwk98@gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 1mzdgj4fx64xbywhsc5t4ybf9ig9zqw6
X-Rspam-User: 
X-Rspamd-Queue-Id: 09EBF1C000C
X-HE-Tag: 1776342507-781914
X-HE-Meta: U2FsdGVkX182pauBxQQrltl5p500opn7fKTxlRltbfrqe4H+D+DtX1I8hktHbkKe0aRoLu/e8vGOOrz5TNdv/n9FMUby9I/No5H0OoehJbD5cDlwdsXYCxLD4y5Gm3XFCc+rAmeBx4ELBHBlHC3k+5jvuNhmj0Wr4QQNiWpO2+5M/pM1EMenANgOo2oXX1nOSiJhkgLIHOqC7hEtUfRMi96epoMVYvIwjh/RqPYKEBSBquZ85L6szM1HUiYaXIFx7r5e26EAHyJwkuezGgXJ9AIWTXBEiiikHsDjnKHslibMSzcZFoO1CPEWXPw2sru7Pwc2IhDDCABloND5N3+xFQwzdSsnFUs1WlnVxeBywbpmJvLxt0JEna9h/Znr0LmuBEXGqpqo1MR8HNoQ6p6GyhGYSCYFY/9rLFnzy5NH8nPTyO0aq+2t8L4GqteuIeSDF6OPT+DHfiXLLX9pXzDYBb7H9DLK/XmT9gttfoGfANwA/QG8OSi+t1/lQqTy3620KNyFuQNeQVBkypgBAW7mie0IxY+mzz1/LBNlSo1jfmQyI10qksAVTdEagALBxh811B7eGh/S90WdHSfZQUKKz4BDE7rTBH1OtNApGPhhEVjWNW4+NV4sYWBfugGiagXdCgSJNbVG5hXqzwzduXwh4Jrf94enw/VKpIgqqVCnhxpCRgkguYadAOUJogWYFFxMMJpbOGcOeiCKSgrgNp1Ad13iAGpjsqE6IaOhy1L+zSdPscV1EuJ5VLnh9ivFZJaTtPpaStetIYZnyOp2tlsS5AAe4VWiTVPaYDLuGirS2OT80abuJt8WMVrYF2oj2kILLOCZHcs+dfL/zTIXop3QANgKCaJZRbXgO2DQAzL/ZDiIsDEnPuhWS0NW6JN56LKwxo9ly3FYI5Ssj4BoGNBWVLVMBN6CDhomkhpcWyAE/KgIVCm5TcCfB0eP5cIVRh4GvDeXgHQPQLr+Qw7UPcO
 VAjVw9lt
 mn4By9WhdNd5EtGtrUr1bobNjGfrx8ah4W+xw1YSXE9k5xtVLx2lup4H5O5iHXvKN0rluVN3cPFihkLLIVtHsgq01uAqRNjfDobIV7rjkpArSkjgR84ZaUXuNOLpjmAhOAtGXnGvG709KXx364xZkmhkhRv2hCKBP4TXZHB37Xxb2qNZAtqmJuJPjGgxKkoMbzK49Pipc+VT1kS81n8hPKkwR+AiptwLeKXwZHTJtZ4DsAbuJCa4rWxdHh4w5uDrvjWVpMjUt+PafpLJbuR3MOMPKTvFI/sP8qu8EcOWCCe3jujHCaad4CaHHXMWtKN1CmxU1H6Y660nc9NC2bd3j8xWhj+c9PBnkGZYgOR5qtGJYH+wUjwl50Hqs3gChwN0Yhin5jPRETQRqyJXUjMhR1FSnYZ1ppi1MjWVZt8cfk4IVrwze+l8pvrJm7lHWPR/C7a4DyqAsKf1DjWgC9TAw3ZSJdjUDOwAZNPgIl+JnHqFQVFxCXqAV6Jk/9wr95sz4fK4fUzyhe18BEWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 08:48:37AM +0000, Sechang Lim wrote:
> decay_va_pool_node() walks every per-pool free-list entry under
> vmap_purge_lock and merges each vmap_area into a global RB-tree via
> reclaim_list_global() without yielding. The outer loop has no
> rescheduling point, so when many vmap areas are queued the function
> can monopolize the CPU long enough to trigger an RCU self-detected
> stall:
> 
>   rcu: INFO: rcu_preempt self-detected stall on CPU
>   rcu:    2-...0: (6344 ticks this GP) idle=853c/1/0x4000000000000000 softirq=41536/41536 fqs=3211
>   rcu:    (t=6528 jiffies g=37549 q=4652 ncpus=4)
>   CPU: 2 UID: 0 PID: 1516 Comm: syz.5.318 Not tainted 7.0.0-rc7 #4 PREEMPT(full)
>   Call Trace:
>    <TASK>
>    finish_task_switch.isra.0+0x23e/0x990     kernel/sched/core.c:5155
>    context_switch                            kernel/sched/core.c:5301 [inline]
>    __schedule+0xb3d/0x3680                   kernel/sched/core.c:6911
>    preempt_schedule_common+0x44/0xc0         kernel/sched/core.c:7095
>    preempt_schedule_thunk+0x16/0x30          arch/x86/entry/thunk.S:12
>    __raw_spin_unlock                         include/linux/spinlock_api_smp.h:169 [inline]
>    _raw_spin_unlock+0x43/0x50                kernel/locking/spinlock.c:186
>    reclaim_list_global                       mm/vmalloc.c:2213 [inline]
>    decay_va_pool_node+0xccf/0x1070           mm/vmalloc.c:2273
>    __purge_vmap_area_lazy+0x136/0xc80        mm/vmalloc.c:2361
>    _vm_unmap_aliases+0x469/0x6e0             mm/vmalloc.c:2996
>    change_page_attr_set_clr+0x24d/0x4a0      arch/x86/mm/pat/set_memory.c:2082
>    set_memory_rox+0xc2/0x110                 arch/x86/mm/pat/set_memory.c:2314
>    create_trampoline                         arch/x86/kernel/ftrace.c:421 [inline]
>    arch_ftrace_update_trampoline+0x79d/0xb50 arch/x86/kernel/ftrace.c:479
>    ftrace_update_trampoline+0x45/0x360       kernel/trace/ftrace.c:8391
>    __register_ftrace_function+0x238/0x340    kernel/trace/ftrace.c:365
>    ftrace_startup+0x3b/0x370                 kernel/trace/ftrace.c:3098
>    register_ftrace_function_nolock+0x5e/0x160 kernel/trace/ftrace.c:9162
>    register_ftrace_function+0x32b/0x4c0      kernel/trace/ftrace.c:9189
>    perf_ftrace_function_register             kernel/trace/trace_event_perf.c:494 [inline]
>    perf_ftrace_event_register+0x159/0x240    kernel/trace/trace_event_perf.c:518
>    perf_trace_event_open                     kernel/trace/trace_event_perf.c:184 [inline]
>    perf_trace_event_init                     kernel/trace/trace_event_perf.c:206 [inline]
>    perf_trace_event_init+0x17b/0xad0         kernel/trace/trace_event_perf.c:193
>    perf_trace_init+0x176/0x290               kernel/trace/trace_event_perf.c:226
>    perf_tp_event_init+0xa6/0x120             kernel/events/core.c:11270
>    perf_try_init_event+0x103/0x930           kernel/events/core.c:13029
>    perf_init_event                           kernel/events/core.c:13127 [inline]
>    perf_event_alloc.part.0+0x11dd/0x4970     kernel/events/core.c:13402
>    perf_event_alloc                          kernel/events/core.c:13283 [inline]
>    __do_sys_perf_event_open+0x764/0x2eb0     kernel/events/core.c:13924
>    do_syscall_x64                            arch/x86/entry/syscall_64.c:63 [inline]
>    do_syscall_64+0xa9/0x580                  arch/x86/entry/syscall_64.c:94
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
> 
> Add cond_resched() at the bottom of the outer loop in
> decay_va_pool_node(). At that point the per-pool spinlock has already
> been released and the outer vmap_purge_lock is a mutex, so sleeping
> is safe.
> 
> Found by Syzkaller.
> 
Could you please point to the link with Syzkaller report?

--
Uladzislau Rezki

