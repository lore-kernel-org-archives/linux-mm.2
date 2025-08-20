Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DDCCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B7B8E0038; Wed, 20 Aug 2025 18:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C246E8E0031; Wed, 20 Aug 2025 18:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13CC8E0038; Wed, 20 Aug 2025 18:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7ED8E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:47:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 339EA16018C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:47:49 +0000 (UTC)
X-FDA: 83798624658.01.893FD3E
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6D7B2A0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:47:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGSiqUiB3uU2ebJvfoWCsRjOXyUVURD9Zk/0bkeoJUI=;
	b=Rx4xeXEB4Guyb7leu61LPdpGn1Yqe1Nv0L42tpyUqA9VRY7Y6PEY9TIOsLY4yveS1zeDn6
	1EMRY4UlQ1f0pP6ebRmbfFTnOkp5PpTOc3rBglsEa7sNCey3+1mqP+qqKf/AfCVfyXwggm
	YlVEzK90q8BByGbszwCr1y7L2n+uOBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730067; a=rsa-sha256;
	cv=none;
	b=aSQA1833fq6a+iKlvCHPOEttjMElx1chTY7wn04Zb4AMGhYKCVUrPRAINpAmZuHrMe1px0
	40CIrzMqdRukAGbi+1BrLQ9KJkt/4KKQDC1HhVbKBczhlVcnpIVu1zrtLfRQ4veaF7dMJ3
	eKnqes6xAGvYosIbUChPpcZrfweAfcs=
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13F431A01A2;
	Wed, 20 Aug 2025 22:47:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 6CA042000F;
	Wed, 20 Aug 2025 22:47:40 +0000 (UTC)
Date: Wed, 20 Aug 2025 18:47:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Daniel Gomez <da.gomez@samsung.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Petr Pavlu <petr.pavlu@suse.com>, Sami Tolvanen
 <samitolvanen@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yann
 Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v3 8/8] x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace
 allocations
Message-ID: <20250820184743.0302a8b5@gandalf.local.home>
In-Reply-To: <20250713071730.4117334-9-rppt@kernel.org>
References: <20250713071730.4117334-1-rppt@kernel.org>
	<20250713071730.4117334-9-rppt@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18niudp8MzlJSk2CKpi7L3PVVfh56aRSjY=
X-HE-Meta: U2FsdGVkX185NYSqNdNBNsPuTnEliAO8Pc9z/2zyL0/XZrgDjC2inAGrNVdtT8LaunP4GdSwgzUzAn0ieYTKYrkbJp3U73834SFXYZuN7MPquEyZfj5HnY3VvzSvP8qywLdkkudYQ2iBDo0rKKZ2Z2PvVVo77G5u3qQ6vh4roaJGnq6fG7h4qIt/EcJN4NcwslrDJloAhoMhNTWc/+k0jLFaIT+RUaSQCiHki1SfKSCtJUP9PaWU881E2pAAQo9VoCuEnfmObDwj9kkkLrT0pvuxR9LGxQr4OXtwTYzRILsya/suHDdPWf24wawtOurEPMWbSml/gm4JHnwobNCY2fmluAzlK6zAAAAIwM1AP2VVrDDmRRbVbJ9Nx+QY3dxvRvS3KddU+q5e3ucoNss1rQ==
X-Rspamd-Queue-Id: 6D7B2A0006
X-Stat-Signature: zd7uszrmc5g8u8to7ufteyinugba4atg
X-HE-Tag-Orig: 1755730060-24004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-HE-Tag: 1755730067-186377
X-HE-Meta: U2FsdGVkX199TQpv8MNhcq3S849wQq+29yCYzY/NkD+MTcmawx1y/Ptpp5RprjVvTFnhm8b2BizHQxywqo0q2ziMzqIvucUICjXehOPo9pzIBa7v/+I2xtfuOFxdM8tBFpvI6i7tUGG8p+bBlTQmkFbNBCuyc1UFVy1Fq3QFfRIBgI+XiF39UA14JKqOb3k2HbNgyeX9dzy8MKbsY0DCbgwjI0y/dUlMA0G2ChZ8mgM0/VuiKrKQPbll8gVJeYCcOgR63BJNaIt6mEj5TSaYtCF+uDFOHk9kpGrY9ZZ3+TgRejIGobsJVV/gBjE8sxEAUnLlOglcjZxMErZz+DIDIO/M2QMSvMYVHm/exOhtnAzUwokGOksyO3Nz7wgf/gHXsjVVZrDb7Tp5hMoLJegw+Wmbicawyuq/9xFrSSpY6MhK/K7OYoGJ1rj79fnAK4Px9cWGpBW80xw8l9GvJg/q0QFMPc+bUkQM+9lkoNDnzxn4ySstIhcMS4ypfJjPwp5jDgsCVi1kK9UphPRNLxZgOOVml8ESGncq4mvV9EaNsxfnWuFnKvAltRDEgjEJD8VLT89GL/TnIebjPN1c0/RDSJi0be1i/kTStjsj9tOU6On495WgOwKLGAzi1viUeFDktg4EUJ+brw0jvCugVjtVNu4jeC0jRzoHx68jcsyltWT5rWj+sKQoJ5/E1QHno6KONsrAJxf/hXrQbfi41jIy+QQIgqgqGCp6zENYeMyJDBWNrq52vz8E4B2abeSUdtUNd5GJ2oMhBRVb1hOYOX2lCEHPogmv8yj0kszU2VTd5In6a0h4T4hgeD55el2q4lu0cVdk8pa5XKB8KnXL+OX6OQRw2k5ME063JYi7taSz9irZPHUsCAvyQtaei3XSxxe3OXv7Yr0q0kUv3aMjV1tQOqFEK+/H+TcRpR7qZrBYQNV7HGDE7UmYWP6gDpAxqi+4GdiiJR8Y8qVDbfVnZDb
 T6XKS9zP
 Vy6JDUU9hcnhzdzYr0+KoMWNfzDdBYD8Ti5zUPj3L9eX0WPkVAp9LitIS4JULWgOePJ2H9pGEZMmMXT8lBnn/3QQ1DqZtUEalSdi5KSN2XcIE1kLEqWNLTjSTHJ5ByysOgkuOgCL1yLVTFHU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Jul 2025 10:17:30 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> For the most part ftrace uses text poking and can handle ROX memory.
> The only place that requires writable memory is create_trampoline() that
> updates the allocated memory and in the end makes it ROX.
> 
> Use execmem_alloc_rw() in x86::ftrace::alloc_tramp() and enable ROX cache
> for EXECMEM_FTRACE when configuration and CPU features allow that.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

The "ftrace=function" kernel command line started crashing with v6.17-rc1,
and I bisected it down to this commit:

 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")

On boot I hit this:

[    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
[    0.160254] #PF: supervisor read access in kernel mode
[    0.160975] #PF: error_code(0x0000) - not-present page
[    0.161697] PGD 0 P4D 0
[    0.162055] Oops: Oops: 0000 [#1] SMP PTI
[    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
[    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237) 
[ 0.166186] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 e4 f0 48 83 ec 20 8b 05 c9 b6 7e 01 <44> 8b 77 1c 65 4c 8b 2d b5 ea 20 02 4c 89 6c 24 18 41 89 f5 21 f0
All code
========
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	f3 0f 1e fa          	endbr64
   7:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   c:	55                   	push   %rbp
   d:	48 89 e5             	mov    %rsp,%rbp
  10:	41 57                	push   %r15
  12:	41 56                	push   %r14
  14:	41 55                	push   %r13
  16:	41 54                	push   %r12
  18:	49 89 fc             	mov    %rdi,%r12
  1b:	53                   	push   %rbx
  1c:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  20:	48 83 ec 20          	sub    $0x20,%rsp
  24:	8b 05 c9 b6 7e 01    	mov    0x17eb6c9(%rip),%eax        # 0x17eb6f3
  2a:*	44 8b 77 1c          	mov    0x1c(%rdi),%r14d		<-- trapping instruction
  2e:	65 4c 8b 2d b5 ea 20 	mov    %gs:0x220eab5(%rip),%r13        # 0x220eaeb
  35:	02 
  36:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
  3b:	41 89 f5             	mov    %esi,%r13d
  3e:	21 f0                	and    %esi,%eax

Code starting with the faulting instruction
===========================================
   0:	44 8b 77 1c          	mov    0x1c(%rdi),%r14d
   4:	65 4c 8b 2d b5 ea 20 	mov    %gs:0x220eab5(%rip),%r13        # 0x220eac1
   b:	02 
   c:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
  11:	41 89 f5             	mov    %esi,%r13d
  14:	21 f0                	and    %esi,%eax
[    0.168811] RSP: 0000:ffffffffb2e03b30 EFLAGS: 00010086
[    0.169545] RAX: 0000000001fff33f RBX: 0000000000000000 RCX: 0000000000000000
[    0.170544] RDX: 0000000000002800 RSI: 0000000000002800 RDI: 0000000000000000
[    0.171554] RBP: ffffffffb2e03b80 R08: 0000000000000004 R09: ffffffffb2e03c90
[    0.172549] R10: ffffffffb2e03c90 R11: 0000000000000000 R12: 0000000000000000
[    0.173544] R13: ffffffffb2e03c90 R14: ffffffffb2e03c90 R15: 0000000000000001
[    0.174542] FS:  0000000000000000(0000) GS:ffff9d2808114000(0000) knlGS:0000000000000000
[    0.175684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.176486] CR2: 000000000000001c CR3: 000000007264c001 CR4: 00000000000200b0
[    0.177483] Call Trace:
[    0.177828]  <TASK>
[    0.178123] mas_alloc_nodes (lib/maple_tree.c:176 (discriminator 2) lib/maple_tree.c:1255 (discriminator 2)) 
[    0.178692] mas_store_gfp (lib/maple_tree.c:5468) 
[    0.179223] execmem_cache_add_locked (mm/execmem.c:207) 
[    0.179870] execmem_alloc (mm/execmem.c:213 mm/execmem.c:313 mm/execmem.c:335 mm/execmem.c:475) 
[    0.180397] ? ftrace_caller (arch/x86/kernel/ftrace_64.S:169) 
[    0.180922] ? __pfx_ftrace_caller (arch/x86/kernel/ftrace_64.S:158) 
[    0.181517] execmem_alloc_rw (mm/execmem.c:487) 
[    0.182052] arch_ftrace_update_trampoline (arch/x86/kernel/ftrace.c:266 arch/x86/kernel/ftrace.c:344 arch/x86/kernel/ftrace.c:474) 
[    0.182778] ? ftrace_caller_op_ptr (arch/x86/kernel/ftrace_64.S:182) 
[    0.183388] ftrace_update_trampoline (kernel/trace/ftrace.c:7947) 
[    0.184024] __register_ftrace_function (kernel/trace/ftrace.c:368) 
[    0.184682] ftrace_startup (kernel/trace/ftrace.c:3048) 
[    0.185205] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210) 
[    0.185877] register_ftrace_function_nolock (kernel/trace/ftrace.c:8717) 
[    0.186595] register_ftrace_function (kernel/trace/ftrace.c:8745) 
[    0.187254] ? __pfx_function_trace_call (kernel/trace/trace_functions.c:210) 
[    0.187924] function_trace_init (kernel/trace/trace_functions.c:170) 
[    0.188499] tracing_set_tracer (kernel/trace/trace.c:5916 kernel/trace/trace.c:6349) 
[    0.189088] register_tracer (kernel/trace/trace.c:2391) 
[    0.189642] early_trace_init (kernel/trace/trace.c:11075 kernel/trace/trace.c:11149) 
[    0.190204] start_kernel (init/main.c:970) 
[    0.190732] x86_64_start_reservations (arch/x86/kernel/head64.c:307) 
[    0.191381] x86_64_start_kernel (??:?) 
[    0.191955] common_startup_64 (arch/x86/kernel/head_64.S:419) 
[    0.192534]  </TASK>
[    0.192839] Modules linked in:
[    0.193267] CR2: 000000000000001c
[    0.193730] ---[ end trace 0000000000000000 ]---


-- Steve

