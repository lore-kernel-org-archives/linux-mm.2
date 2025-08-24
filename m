Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B8FCA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68858E0008; Sun, 24 Aug 2025 09:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A198C8E0001; Sun, 24 Aug 2025 09:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E8E8E0008; Sun, 24 Aug 2025 09:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE848E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:08:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB425114C3A
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:08:11 +0000 (UTC)
X-FDA: 83811679182.12.F22EBDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 772734000E
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:08:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMLqhO8Y;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756040890; a=rsa-sha256;
	cv=none;
	b=H5c5Zty2x18GZCRY4a7ENAg6GbtscSaeG3rkyB9Cw4Vr1cjXftQ0egZtNj58KZ6gK22k+P
	iV5Yd0SW70WpN5f3w5H8EardK1ARthnnZnWRd/3cCea1rxbGamAIajz3TcoUNTHWnqa30H
	eDeeBgoFANs8ThwyE035LLR4iFcoriQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMLqhO8Y;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756040890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pp8ToLUkKJ1HOeEJXTubDWsSZ9lYngLBdR/X7Ieo04g=;
	b=YmTSKtZwt26EmJdDSJ5KMVN6zVx/ZLHw2+cXPVQBB53PLUaGaY0Qja23GW51pBp4s7y9ur
	B82Y5nj2LtdNP7ON2ECrOaJBDSKudCSDTfrcHSPJxsDA2lNa11KM3422Uo/NO42vm/3XxK
	CqlXGOoBy9m1Zc4ZQioMugTI9SgQqSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE3D6601E2;
	Sun, 24 Aug 2025 13:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A3AC4CEEB;
	Sun, 24 Aug 2025 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756040887;
	bh=c/pmFE4hhHdYRQMOehbBMtIk9AjMFS+JxZ7MckvIVMM=;
	h=From:To:Cc:Subject:Date:From;
	b=CMLqhO8YykEmBddsn1YaWApi85Vtax3IOM8A5OtISl56VsnwYsRIogHVJZNsDeWJx
	 sGLwfH8I/jGN0HKUiLenRDinB1qGvTGkme1JfyOcjRFNJIgbtzY1QDVBdoMTZGrkW7
	 TLhBuvWQOJ3ZxKEv6/lZhIuUXQlVKBtLzLGvDgJc/1bNbez8AS46SSHDqhtKzf68EY
	 OYMDlPy1y+HwKEC2XZ2EG5M/rdQC/DTrQs/rG9E1EsHFY8wPUWF0T3wxgRlE7HaBL4
	 CWkYghfcyCF/3ACTCVLM/MaFKdmlEVGYCsD2y7/G8cPYXYOEK96mu8K6syMW+H1A9e
	 OvKx3AFqX+VNw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH] init/main.c: fix boot time tracing crash
Date: Sun, 24 Aug 2025 16:07:59 +0300
Message-ID: <20250824130759.1732736-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 772734000E
X-Stat-Signature: xqz9r79a61endqjh8wz6bococu6c7z5z
X-Rspam-User: 
X-HE-Tag: 1756040890-498936
X-HE-Meta: U2FsdGVkX1+iLx95xgBBvQ9WHFj2XJkW1X/tOzEW07t33kLvKxNGrApxKI8IpNgeUbb7PSg7KYHLfrJLKPIh46iDYpkxfHWONHVzY80VLhglF+3Z/nZlA6Y58U+Zb5vZ+SGaoRzve+BkQg7dJ25h2V07IvqGanoU/87ZujqMThjaudGBQTfbbnEv/t05EMfsZgvCK1XNlGkoXq6V/b94SRIg8F4e15MCmne/sUuYes6A+pXSXQqrRF8qBnuLHE/cFjX4l/+L13FKySSGMiF4ONf6Ie1OwdwhAJrv7mnHBXq993ygxbI/sm6J4KYj6zXlavk3BF/J7oLdWQfGzkR7mpRIBFSh/sCs63tKk4aAchpTSxzSzsqOrkn4xCcdDvEq5NC1IVaFzCaoMg86e5pQlTYGzG3ng7GNsBy0ilwea4AJMQFbH7YZWEYYJJTrV8PTno6+EdT5Mt9n9J/6CV3cynXnFnYoug3RF48PdTL7JfEWzosyBoqvAUgIE4Iw49d/tu7UAXHjWVUDnSnux14/h/sntQcXLhe6XHeWOs6vE9mrFY4kNKUn8hKZZ3BhT+cB3vqamx2L1CobNVANKqbAMRLSNwCBn+Lueg3Jwi9omgkFLZ7T6+wD2+gMfcEKoqpYlvSSP+QJY/2o3H3Pcg6Kia/iXGFwQmjLYXYAru5TYAZ46yxJVfxMEzhmqSx0alCVkZzhXUk+AeDjw73+q4++5VWl1953QDmjTUa/30D6Tc8aMk5Hkc7/8zxuYFcSAE9nmWfbhU84bbV44kZzJlWOU7xg6ZXXEbddM5cxz148IdY5nWb0IXvtkyv4APuFAzzZ69wCJvuZ/GzdMvcL2C0tXikYyZZ0ZabT8nRFH5/aT46570+LPJ5uPWIUN41lhzavAOybPPZTChaOzv0DJDI9MX8xuHEPu0V5bqKNcHLWRaXcoTwRMNotZBOUze8or0gtO/Y2mv40W6PFnSxoiJq
 ZPI2Dwz2
 bxYinFYIbu/nxfJ1bOJRynyP+NojAKSbkSzCXTFLnLPtVIXld8sB5WZx/Kc8X0XJHn1FQFQEt+ft1nndStcw5QBihme6gFmjpNNVhZXKZa0eCApj/fUWAiMNxJHgaH3C85Th4dDFTs0TbXwKDtH9eWe5FdG5u/h+wrpDP02ynJxshs3A1e1NRxClXUbJCDv6skKiI7gmePPkS1ma5gySNJGCkaKfVj5boejOs2XR+SswB7K0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Steven Rostedt reported a crash with "ftrace=function" kernel command
line:

[    0.159269] BUG: kernel NULL pointer dereference, address: 000000000000001c
[    0.160254] #PF: supervisor read access in kernel mode
[    0.160975] #PF: error_code(0x0000) - not-present page
[    0.161697] PGD 0 P4D 0
[    0.162055] Oops: Oops: 0000 [#1] SMP PTI
[    0.162619] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc2-test-00006-g48d06e78b7cb-dirty #9 PREEMPT(undef)
[    0.164141] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.165439] RIP: 0010:kmem_cache_alloc_noprof (mm/slub.c:4237)
[ 0.166186] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 e4 f0 48 83 ec 20 8b 05 c9 b6 7e 01 <44> 8b 77 1c 65 4c 8b 2d b5 ea 20 02 4c 89 6c 24 18 41 89 f5 21 f0
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

The crash happens because on x86 ftrace allocations from execmem require
maple tree to be initialized.

Move maple tree initialization that depends only on slab availability
earlier in boot so that it will happen right after mm_core_init().

Fixes: 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
-- 
2.50.1


