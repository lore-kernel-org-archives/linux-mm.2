Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36725C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 11:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888926B0095; Sat, 22 Aug 2026 07:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867C06B009B; Sat, 22 Aug 2026 07:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F576B009D; Sat, 22 Aug 2026 07:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2D16B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 07:34:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83EBD120390
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 11:34:08 +0000 (UTC)
X-FDA: 85128696576.15.5F74F21
Received: from latitanza.investici.org (latitanza.investici.org [185.218.207.228])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57E1740005
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 11:34:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=g3XcHBIG;
	spf=pass (imf04.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787398446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNwyVkbrl/IZdn/NaEk3v2rcVEw/q2TX5VaMaY7Fz6A=;
	b=nMDd7cVdq75Nyjij54m5irMDPYLZNKwLxD9iJzch983xaiE+zp86OuBn2fdTD7H7pH+You
	1P7pbDftDxxcs/HwkA57nmU9ZwYUEP5xTjl3EIkYwFpRdjcRVEMdzqkWZke9Z/R/toNK/p
	rr+eUT8LSaR3cEkwdoerBCzqTfmJz8E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=g3XcHBIG;
	spf=pass (imf04.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787398446;
	b=LeuqS6qI7nyGdMEpq0n9ON7DVnuovTnK3b8fFNN6Qqqz7Rwk+E8Z9TtWVj8hYrJPRWJNYN
	NZPwuuIY02kTZqYj3kNbkJdRSo+ULje+iwVrJxOYv2Li0rSCf5J9pOKyzXJuP5OO0db7t3
	xS6ahnOhcpYBjp4dCSq2X+EY2JT+ZHw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787398443;
	bh=GNwyVkbrl/IZdn/NaEk3v2rcVEw/q2TX5VaMaY7Fz6A=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=g3XcHBIGCwsDyRRltTA0CXu6mdQ3t4HGha31MglU1M7NlMpj/jeh0+kFAcIgLu9os
	 193Cse5ZjVk1d2pXg1/47VABuzinLhWeN43czqHojC4XvKbDwSj6UGUzVv30+mZnhD
	 RQ3hmNlvcrmak+RJg0vPnvx4j7dPlq/eKzMvi9nc=
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4hRw6z52rGzGpCY;
	Sat, 22 Aug 2026 11:34:03 +0000 (UTC)
Received: by mx3.investici.org (Postfix) id 4hRw6z1sVRzGpCG;
	Sat, 22 Aug 2026 11:34:03 +0000 (UTC)
Date: Sat, 22 Aug 2026 12:28:17 +0100
From: Bradley Morgan <include@grrlz.net>
To: =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de
CC: bsegall@google.com, dietmar.eggemann@arm.com, kees@kernel.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rostedt@goodmis.org, vschneid@redhat.com, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_fork=3A_initialize_functi?=
 =?US-ASCII?Q?on_graph_state_before_copy=5Fexec=5Fstate=28=29?=
In-Reply-To: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <E33C59B8-755C-403F-A06C-7B7DE3F81926@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57E1740005
X-Stat-Signature: n5xdyjbspuad95ufzfrop6m6s3u6hpiy
X-Rspam-User: 
X-HE-Tag: 1787398446-24879
X-HE-Meta: U2FsdGVkX19hKKlYZwcJW8lm+qEsrVFHXLSyzoycZujR6uDoQ5zjtYfhbjz+4o/JyUzaKmDrW/6tw6d2SWTN1CLcigY+nSlNt8f5BGOer2LOb7IORoEgsYyHDIbK1xWuIzdISEGwjZPts/RIJLGqm1iQX0x7zONtOW6Ysn8FV/X/xiW5POX9UzNjVymUEF2sUsfyNXyZRo5TJAQwtWQW9XZuJe4vOU+kSISM8S3G720KlArAQZTo5elMTUv3J5yOd+bDWJg/CY5qOtGMTnR6RvS14q0Jln+y10hBZv20OTOvtGSeopGS3xn2MAP5zsiF6WaRXkegLoegdI+4B+kP1ymrpaDVTf2fJEg3/ncxlmWmycxIkzeJl4wggpjF0RvRlouDzMDa6yDS1wSwWOwSRuThrxAMVGI1Y6To5hH3B3V7P0M8eBzwMt02z7Q4CAuahaXl+vA9y3TUIQ68F2u5pnVj1Zy81c/4lTag8BWPfjCk8/JaDQqUtJrbI5ZN3VMBkwqlJS48NfybaJbsZYkdYf2h1Z79+jhiV8k3N0JC7v2xntQ4Y7s/eWbPLaRxp4Ah65QAJ7G7FMH4dzR3MG3ABCWd8IktDvgN5k793mNaHHLyCCdjXiHkqxxVY7RAh+JvcgrxeFGmKwzcGnCL/Yyggh9dFGl1sTeuaxW724pvrFCoIcrUAxw8IGVqnXt8v+TeEJ/DU1rwScuulIf02nKj2J2Kcp+a8OXw08T0igUA0ASfKlvbyEv7WJFh+8QlwBQB96Z0FRdjZDL/ZmVJJLI8Wr7iF4dM8M7j7HcXbYavDBN/CQEk54E79UlpOWnZkY8fapbPAVcGdks+49or1LrpBxoOjjUW+EF+gfmWabZdvX0PdAEICIipBxc67j2e4jJxqag0NmpstnHimjbQaoP5KhhFWfjQVFhRedv3ahqDNwuqkzseLmEYelDqqJ7kzU2TkP9nuzE6/npEOA9DmSb
 nfxwSpX+
 zkMgucuciCilBMUcvQAT7OWehCJ7fa39VRe6xbRS6ko0MmJCeGvU3xTlxGFLiMEQx5eY3yd+ew5BARo/oGDYa/Q5jNcXBXkuDYU8/4zXnOP31Z9n1wr8rfiDgTKpc+wBDTJjl9lqdRIWlaAFmYMeuf1s6uEH0wOlQOqVXQj9afAA2ROv0Ygz/vD4rAh70XsjCDYm21s1VKGFYHbtZzXdv/kPzDPG3TpdxUBY9cRiDHgZvN14fcYuKI4WNmFAUxaMsrjeFkuKJK90v6nq/FhyCB/bHWL5kuMaqawx3C484t4LGlDYAOJ8LMkivILZLkzWtSRMIhGKwfHMv97acic11684VAAqKapNujc3r2IMG8HyP8nkqADyy+8+NoX4aJrKOHb5sIrJxXFX/HXe80xJ0YlPxuhKkX8CAO1/YARJC+a5TFmUNfYACOgaCkCqtn+DifeXt7BL4e8fDa2eMdE1BMaCXi5HlMr3eH4JN6/SCLEtbKstjAV/G9grJiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 August 2026 09:49:27 BST, "Jérémy Jean"
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>dup_task_struct() copies the parent's task_struct, including ret_stack.
>ftrace_graph_init_task() clears the copied function graph state, but it
>currently runs after copy_exec_state().
>
>For non-CLONE_VM forks, copy_exec_state() allocates a new task_exec_state.
>If that allocation fails, copy_process() reaches bad_fork_free and
>free_task() calls ftrace_graph_exit_task(). Since the child still carries
>the parent's ret_stack pointer, the unwind frees the parent's active
>function graph return stack. The parent subsequently accesses freed memory
>from function_graph_enter_regs().
>

Wow! Real life use case?


>KASAN reports:
>
>[   22.190920]
>==================================================================
>[   22.195899] BUG: KASAN: slab-use-after-free in
>function_graph_enter_regs+0xa76/0xb90
>[   22.200747] Write of size 8 at addr ff110000054dc0a8 by task repro/1
>[   22.205134]
>[   22.210770] CPU: 0 UID: 0 PID: 1 Comm: repro Not tainted
>7.2.0-07732-g9328b3b03bdc-dirty #3 PREEMPT(lazy)
>[   22.212576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>1.16.3-debian-1.16.3-2 04/01/2014
>[   22.213750] Call Trace:
>[   22.215271]  <TASK>
>[   22.216242]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.217774]  dump_stack_lvl+0x4e/0x70
>[   22.220531]  print_report+0x157/0x4b4
>[   22.223202]  ? fixup_red_left+0x9/0x30
>[   22.224407]  ? complete_report_info+0x83/0x110
>[   22.226679]  ? function_graph_enter_regs+0xa76/0xb90
>[   22.228084]  kasan_report+0xce/0x100
>[   22.230109]  ? function_graph_enter_regs+0xa76/0xb90
>[   22.232860]  ? stack_trace_save+0x4/0xd0
>[   22.234156]  function_graph_enter_regs+0xa76/0xb90
>[   22.236090]  ? kasan_save_stack+0x30/0x50
>[   22.237752]  ? __pfx_function_graph_enter_regs+0x10/0x10
>[   22.238694]  ? ring_buffer_lock_reserve+0x345/0xf80
>[   22.239628]  ? stack_trace_save+0x4/0xd0
>[   22.242121]  ? stack_trace_save+0x4/0xd0
>[   22.243588]  ftrace_graph_func+0xda/0x160
>[   22.245362]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.246520]  0xffffffffa0000095
>[   22.250528]  ? stack_trace_save+0x9/0xd0
>[   22.251757]  ? ring_buffer_unlock_commit+0x11d/0x5c0
>[   22.253152]  stack_trace_save+0x9/0xd0
>[   22.254264]  kasan_save_stack+0x30/0x50
>[   22.273631]  kasan_save_track+0x14/0x30
>[   22.276763]  kasan_save_free_info+0x3b/0x70
>[   22.278296]  __kasan_slab_free+0x43/0x70
>[   22.280157]  kmem_cache_free+0xbf/0x3b0
>[   22.282963]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.284001]  free_task+0xa2/0x160
>[   22.285699]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.286752]  copy_process+0x2aae/0x7bc0
>

I see.

>Initialize the child function graph state immediately after
>dup_task_struct(), before the first fallible operation.
>
>Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")

Ack.

>Cc: stable@vger.kernel.org
>Assisted-by: Codex:gpt-5

Good, declared AI.

Reviewed-by: Bradley Morgan <include@grrlz.net>


>Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>---
>Changes in v2:
>- Add the KASAN report excerpt to the commit message.
>- Add a comment documenting why ftrace_graph_init_task() must run before
>  fallible initialization.
>
>v1: https://lore.kernel.org/all/20260821102207.3626491-2-Jeremy.Jean@oss.cyber.gouv.fr/
>
> kernel/fork.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/kernel/fork.c b/kernel/fork.c
>index 1e68404bd773..0d1ad92e2d33 100644
>--- a/kernel/fork.c
>+++ b/kernel/fork.c
>@@ -2139,6 +2139,11 @@ __latent_entropy struct task_struct *copy_process(
> 	p = dup_task_struct(current, node);
> 	if (!p)
> 		goto fork_out;
>+	/*
>+	 * Must run before the first fallible op, so error paths never
>+	 * free the parent's ret_stack.
>+	 */

Used my suggestion, good.

↓ good fix.

>+	ftrace_graph_init_task(p);
> 	retval = copy_exec_state(clone_flags, p);
> 	if (retval)
> 		goto bad_fork_free;
>@@ -2165,8 +2170,6 @@ __latent_entropy struct task_struct *copy_process(
> 	 */
> 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
> 
>-	ftrace_graph_init_task(p);
>-
> 	rt_mutex_init_task(p);
> 	raw_spin_lock_init(&p->blocked_lock);
> 
>

Thanks!

