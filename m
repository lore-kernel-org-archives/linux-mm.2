Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C8BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 04:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135206B0010; Thu, 28 Aug 2025 00:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5936B0011; Thu, 28 Aug 2025 00:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F176A6B0026; Thu, 28 Aug 2025 00:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBB706B0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:10:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68441A0947
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:10:55 +0000 (UTC)
X-FDA: 83824840470.15.496B849
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05DD140007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:10:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OXD82Ye5;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756354254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8f1ae0heZCsSyx41NqIpudnC/2sBcuVhQtIs5D6BbnA=;
	b=ZExbpMRV6YIYusZEumedD9fKJaVaaSrWMd5t8YZby2Y6tv0l+zLhr01xwoeYC4GC/NugDK
	1jI9iJ6seEUlObQXrvFMKOIWjDkM6Q0hTjpGGhiRGKyfOcVnJdYWbh8VFzE6tjX6jucE8r
	84bAgm8WhmEplLbgQC7oaHCN46GJIXI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OXD82Ye5;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756354254; a=rsa-sha256;
	cv=none;
	b=MrYXSwXYqYKiQoXHy09saT4s5ixdCTtDRmgiTlWNPqZRXZ1kKzInPjlkWuBzYPFbGrxzTi
	Uc7t5/M3v6w9R6UjxYXIOasQ62oTHxPKz59OBiKguca9ZKZqNgQJyN/3wxOcgxktTNfPQy
	BeqhfZX1fetPgbQdW8FoTmjAnL/F+04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0D70409AF;
	Thu, 28 Aug 2025 04:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2ECC4CEEB;
	Thu, 28 Aug 2025 04:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756354252;
	bh=Pni7gwm2Fih+x+CwuJerBVTL9CsbWshBAuOHEybmPig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OXD82Ye5muAMyno8BiCwFQ3ri6cxsVNk2VA2yh9hPq3yM2ijQF6OEF8xb6IyNjwZ9
	 tROktiyxgtiCUx25Jaardt22HPr7/L/wIfYZsBCdSEQLifY05vwsYpyqvToeJvscj4
	 FQi2XHcmsuIpnl38zAyZKNks8nrPhf8LO3b4LNVX4QUcxwsj+O8mW10R1r8hELMWUT
	 hhhQi9P70wRWAfiAQHjnQ72te/+iNdUakfN6V8eEOLYZaeziF7h+YdwcUBmnskU1yT
	 qeQzYKVFz+BgqULyIzDZNnuiNjffI0n0FyhT/WVLZb0Bd5CraZ4qUPhhX5zamH9SIH
	 uQ9tDKA9oE7vQ==
Date: Thu, 28 Aug 2025 13:10:49 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar
 <mingo@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] init/main.c: fix boot time tracing crash
Message-Id: <20250828131049.3feb168ab25f564b8e3b24e6@kernel.org>
In-Reply-To: <20250824130759.1732736-1-rppt@kernel.org>
References: <20250824130759.1732736-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 05DD140007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ksczqmxjqkbw7ktye3snxncnaabt6z54
X-HE-Tag: 1756354253-232158
X-HE-Meta: U2FsdGVkX18VyYeiOVN7ZivntyJgGGe+kutZ1VA3B1kFTEdP4hdbrg3F03FJitheZoiTlqwHdC+qpmYNc54kIYWimG//gpt3WCuZQ4XzFm5uj+5BBVAzGXNDHAHsQDneuSpUd8u+3cQ17WJfe7/l4l3G3oUb9HA1z2uE1VnUsjFjhkGvFD7tHcZrqz9BP8iyo7aXUYPOR32vyqYE2ro3UGceqvy18CjNxccSWHTTezyHHgywA/nOSkmerorOqv7iRn3PYe9363EXsr2abPAn3eHDcQZw1Bh6EmaE7ed7OJF+QX3YLqEb4vSw03ONiYpF0hiAB0Hrhbp71HiTTYEbFlsuefa43gdDWjhL1+9AX189TsaTa8p4Cs5Kgs1WEXGxNbnTSouPth4tnDhIMJGqMy6PF4q6txRsNrOL8nq3AL6DiXkkb1reuWXh8jfy3KGDOsfkPsjgjJDQID3FppuOJ9Vdmw5wSS6KiTcqHxv8h2Wox739323oZUgeyuoeIHQz2I6ouyLRZy2alURGQzZQ71Dj/LFyNySN8tLYdmBr28fYjB8m/jh+CfgxC5IQY3sHgeCadTbogLcOnudWKm5rwp6YUBjbUruL9TTTOialeKoByBGzWF6RlpeOni/VxcUKa5uAWRQau//rXJ70imdwtw8LcaCNubEXFCLAmfXcg2aP4qfCZQkGZ3G8YBHbl+h7OdC4Qtg0EnjgrA/kDZAo2ql2BPD4TVl2rcQA5iqm6bsuIrVM+g/B+jiN9SM17RXTiC/v3BXzgbMUNpWpogdmIIBPrgAXMKSs4WtC57utGw7bq36zlTjB6tiRQVj955z2UQYeDIQIXe5r6N9nDasyiuU2JVjwcRz2oycZK8pdeDZ46jIdfG3EF5YKQzZwxZ5qlqQJCCylZ5zeNl6LjzZHlIB1OuviEzPV7cwGeqPQjwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 Aug 2025 16:07:59 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Steven Rostedt reported a crash with "ftrace=function" kernel command
> line:
> 
> [    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
> [    0.160254] #PF: supervisor read access in kernel mode
> [    0.160975] #PF: error_code(0x0000) - not-present page
> [    0.161697] PGD 0 P4D 0
> [    0.162055] Oops: Oops: 0000 [#1] SMP PTI
> [    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
> [    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237)
> [ 0.166186] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 e4 f0 48 83 ec 20 8b 05 c9 b6 7e 01 <44> 8b 77 1c 65 4c 8b 2d b5 ea 20 02 4c 89 6c 24 18 41 89 f5 21 f0
> [    0.168811] RSP: 0000:ffffffffb2e03b30 EFLAGS: 00010086
> [    0.169545] RAX: 0000000001fff33f RBX: 0000000000000000 RCX: 0000000000000000
> [    0.170544] RDX: 0000000000002800 RSI: 0000000000002800 RDI: 0000000000000000
> [    0.171554] RBP: ffffffffb2e03b80 R08: 0000000000000004 R09: ffffffffb2e03c90
> [    0.172549] R10: ffffffffb2e03c90 R11: 0000000000000000 R12: 0000000000000000
> [    0.173544] R13: ffffffffb2e03c90 R14: ffffffffb2e03c90 R15: 0000000000000001
> [    0.174542] FS:  0000000000000000(0000) GS:ffff9d2808114000(0000) knlGS:0000000000000000
> [    0.175684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.176486] CR2: 000000000000001c CR3: 000000007264c001 CR4: 00000000000200b0
> [    0.177483] Call Trace:
> [    0.177828]  <TASK>
> [    0.178123] mas_alloc_nodes (lib/maple_tree.c:176 (discriminator 2) lib/maple_tree.c:1255 (discriminator 2))
> [    0.178692] mas_store_gfp (lib/maple_tree.c:5468)
> [    0.179223] execmem_cache_add_locked (mm/execmem.c:207)
> [    0.179870] execmem_alloc (mm/execmem.c:213 mm/execmem.c:313 mm/execmem.c:335 mm/execmem.c:475)
> [    0.180397] ? ftrace_caller (arch/x86/kernel/ftrace_64.S:169)
> [    0.180922] ? __pfx_ftrace_caller (arch/x86/kernel/ftrace_64.S:158)
> [    0.181517] execmem_alloc_rw (mm/execmem.c:487)
> [    0.182052] arch_ftrace_update_trampoline (arch/x86/kernel/ftrace.c:266 arch/x86/kernel/ftrace.c:344 arch/x86/kernel/ftrace.c:474)
> [    0.182778] ? ftrace_caller_op_ptr (arch/x86/kernel/ftrace_64.S:182)
> [    0.183388] ftrace_update_trampoline (kernel/trace/ftrace.c:7947)
> [    0.184024] __register_ftrace_function (kernel/trace/ftrace.c:368)
> [    0.184682] ftrace_startup (kernel/trace/ftrace.c:3048)
> [    0.185205] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
> [    0.185877] register_ftrace_function_nolock (kernel/trace/ftrace.c:8717)
> [    0.186595] register_ftrace_function (kernel/trace/ftrace.c:8745)
> [    0.187254] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210)
> [    0.187924] function_trace_init (kernel/trace/trace_functions.c:170)
> [    0.188499] tracing_set_tracer (kernel/trace/trace.c:5916 kernel/trace/trace.c:6349)
> [    0.189088] register_tracer (kernel/trace/trace.c:2391)
> [    0.189642] early_trace_init (kernel/trace/trace.c:11075 kernel/trace/trace.c:11149)
> [    0.190204] start_kernel (init/main.c:970)
> [    0.190732] x86_64_start_reservations (arch/x86/kernel/head64.c:307)
> [    0.191381] x86_64_start_kernel (??:?)
> [    0.191955] common_startup_64 (arch/x86/kernel/head_64.S:419)
> [    0.192534]  </TASK>
> [    0.192839] Modules linked in:
> [    0.193267] CR2: 000000000000001c
> [    0.193730] ---[ end trace 0000000000000000 ]---
> 
> The crash happens because on x86 ftrace allocations from execmem require
> maple tree to be initialized.
> 
> Move maple tree initialization that depends only on slab availability
> earlier in boot so that it will happen right after mm_core_init().
> 

Looks good to me.

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks,

> Fixes: 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 0ee0ee7b7c2c..5753e9539ae6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -956,6 +956,7 @@ void start_kernel(void)
>  	sort_main_extable();
>  	trap_init();
>  	mm_core_init();
> +	maple_tree_init();
>  	poking_init();
>  	ftrace_init();
>  
> @@ -973,7 +974,6 @@ void start_kernel(void)
>  		 "Interrupts were enabled *very* early, fixing it\n"))
>  		local_irq_disable();
>  	radix_tree_init();
> -	maple_tree_init();
>  
>  	/*
>  	 * Set up housekeeping before setting up workqueues to allow the unbound
> 
> base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
> -- 
> 2.50.1
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

