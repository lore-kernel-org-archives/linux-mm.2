Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5200CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 06:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33DD38E000C; Thu, 21 Aug 2025 02:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF928E0002; Thu, 21 Aug 2025 02:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205698E000C; Thu, 21 Aug 2025 02:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 114FB8E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:12:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8005682D5D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:12:00 +0000 (UTC)
X-FDA: 83799744000.24.5C1AEF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C4C0C80010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:11:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qP+aS7CD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755756719; a=rsa-sha256;
	cv=none;
	b=BGrOVP6tY/fbiadn2nbM2/MXBSa1hLwg9nHv/EBHXt74fDqHsVjyS37yHbMOCc78d2LKTs
	/c87gQocS+NQThVtTlSluUxmyzUCdz4pRID1RMAtLgoW4+jz/QRzKoj9zP4nILdtOyhGVQ
	aH66PcSxQaCW+SoMjf8UHsZpHrTleBY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qP+aS7CD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755756719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44grnMZ+lfm7bRh7/NW89Mb44lGvvNMD/U+BuxtC924=;
	b=i78XR8Y9hfdHlp0AjE5vbVmLNjx3JogIFrx8tJeTyWf4djayKfUQ+ehpxLTIPsRfhNhaf8
	7MPMKaJ3WGwuRGeGZxLHI/1MfEXW4CzYmEj5CD7zz20Rxb02H0LMA1LoVhsi676FAXUBA7
	t5epdvS54Lbc7W5L1xmFRr72wiz5NTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FF9644A34;
	Thu, 21 Aug 2025 06:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8EFC4CEED;
	Thu, 21 Aug 2025 06:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755756717;
	bh=+PhorBsR6XMQ86wn4MXz/aLDVw7PeqDWpjqLZ/xx6is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qP+aS7CDTcx3AaSCB8aROP8Z3j5y7rpn2d+cQ4/5rom6GopCD2X8201ocHvfjnbPq
	 o/Cqmum51WzIu7FGUPN30V/Q1n6m5dy0uwtUrdhJW1EV/uJuj/LsDDJ2sDRmKQqJo2
	 CDMaQEuOQUOPifZxG8sSL97Jjg1Azpr1lNncNe8HEw0UAEVpeN7hHxCIuv8ABSHBtf
	 ah/5gVJtO3HEOHaOFnydT/vSubHbRhIUY++u+Vr8YnV3gnCseqsBygmFo/gYGa45bo
	 T7HdPJpFfC9C6URSWpKF+U5IQlLjeZifbgPzsNweYN9q2OxnY1BS8BTLpZ4uV/EAXI
	 AaBmI9I71YYBw==
Date: Thu, 21 Aug 2025 09:11:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Daniel Gomez <da.gomez@samsung.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yann Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v3 8/8] x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace
 allocations
Message-ID: <aKa4otIF6AbhD2X3@kernel.org>
References: <20250713071730.4117334-1-rppt@kernel.org>
 <20250713071730.4117334-9-rppt@kernel.org>
 <20250820184743.0302a8b5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820184743.0302a8b5@gandalf.local.home>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C0C80010
X-Stat-Signature: p7gudaeb4o764mdnymrbpitwzhaee8ec
X-HE-Tag: 1755756718-446761
X-HE-Meta: U2FsdGVkX1+FwTE6ESuW+vMfiV5oPf39AMZTb+vk3z8xtx1qFMEMfeJ1Eprqa2Tys26eCRU5xG79TwMFNDbOMxlbrWSmYzKJUfOUvVWLxaeZknAfo9PGehxgxyTFWBjFeHUEevkbO0oEMJvf87CSkbPeQtNvC1ywPJT/pvdoZMvF5zf/mPHG/N2dtOUxhF+sdpWk/Ln7GbIhNDuGcg2BTrCNCjGAlhufkQ0K4OZ5gQsG2lHIAcEZWXwGuOfbtYWl04ESrbAxkSg7sHp4xaf4C6FHJa+hmx1CdIEnK7A1epB47ugxwCdA/0RcLYnf4PzqbTmOAaVtX9+pne7gdzws97r8aIc5+m8mBmxHoW7hgxwL8VY9boIS8KjJ9JSd9i9uRpZtgDc/75U4Rm+oSPvcSGkAN8186UiuGBI9IHfDC2ezafUD9ixgxWvOD7f+TI++mnZCHWxgyCX0FrZo4YVha8mFJdB6eQRtdjRombK9m/4TKJcCVK9/iIePS6BPXsfedSAgJ3yfLLFdql3WoMoDu1KR6C/Atz0VT60fZ52XZO1+MwbZlsZth9SQaCnxt21pv73xns+krS1aA/3Ct9y2Hn2X+McRX/SBPNBWd8ChKKr3S3JhvUgQqmuaaP9d6pToZmy4pzLvmjrjpIff26tT7D2pDUmx7/kLfoqkzLjjo07EdRLFuzRykPQtQuHC64rT+fz8N5y2O8uESSazSvQ94gX+8aXjwcGU8VrI3q+bllAE+NqHaXQp2VT0gtGi/szdpm/ijaoaSr5ctf+6PuL6rrhM5rFEbk0p8R0BLcfBsPpwVOXCSr1oCt6S/K/mi2WF+sYxgwqDANj/M6d6aCDE5mE1yHSbv/UPx9svLtAQ5rAvEFfOT5lSA/e1UjPK3oxXdJmi9IncPh2PbaQwMU+ZjSnLOgNkuEwGknzddXYu2+vIMA1iJJIywEOtIfZTBnEtkKY0DudBKE6ZPIZ5ih8
 ZsIV1tRQ
 RQ+4vO7WRIf/p/6tZnDi2QMr3QzlQZlNWQSq3sZmHTchUTFGGkxjvIV9Zm4NIfurSqB35V6p0cIt3U5jup6TW2sLcIRnP0Jlyq+a5HDeXPuBFfP8VcoGOPPfGTZROzjH1jdiMTl1Y0dp3MH3cnsdjTjbduqFten924kRMbYy2BoOf82egY9VLuBv4Xf7SsXNIbIJkFpwydLUHlD7WqRI2BQCWOHatHxIWhXATEdP+p+4sPxsebhxi7ghnJZKnVjH27afqwIs8W90pVmp30PV4OyLaey//hYPCadDdxQMEcCTv7Qnt+fY9y+IVqtGoVmMq5TfXkQV33U8GRo48Lxg84yt79/slov4gRRMyv5OYmFl/XdB6HXWrAUrHh9b3jmw5odwxJsHM65HpufnYXr6dY5prhK04JpgAbZ9Jp73Et6bldRBzD5M+TIVqpHCNnpSGiGH1d3sYSzymtl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 06:47:43PM -0400, Steven Rostedt wrote:
> On Sun, 13 Jul 2025 10:17:30 +0300
> Mike Rapoport <rppt@kernel.org> wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > For the most part ftrace uses text poking and can handle ROX memory.
> > The only place that requires writable memory is create_trampoline() that
> > updates the allocated memory and in the end makes it ROX.
> > 
> > Use execmem_alloc_rw() in x86::ftrace::alloc_tramp() and enable ROX cache
> > for EXECMEM_FTRACE when configuration and CPU features allow that.
> > 
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> 
> The "ftrace=function" kernel command line started crashing with v6.17-rc1,
> and I bisected it down to this commit:
> 
>  5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
> 
> On boot I hit this:
> 
> [    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
> [    0.160254] #PF: supervisor read access in kernel mode
> [    0.160975] #PF: error_code(0x0000) - not-present page
> [    0.161697] PGD 0 P4D 0
> [    0.162055] Oops: Oops: 0000 [#1] SMP PTI
> [    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
> [    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237) 
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

maple tree is initialized after ftrace, so the patch below should fix it:

diff --git a/init/main.c b/init/main.c
index 0ee0ee7b7c2c..5753e9539ae6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -956,6 +956,7 @@ void start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
+	maple_tree_init();
 	poking_init();
 	ftrace_init();
 
@@ -973,7 +974,6 @@ void start_kernel(void)
 		 "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	radix_tree_init();
-	maple_tree_init();
 
 	/*
 	 * Set up housekeeping before setting up workqueues to allow the unbound
 
> -- Steve

-- 
Sincerely yours,
Mike.

