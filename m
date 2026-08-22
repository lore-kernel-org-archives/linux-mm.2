Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7796C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 19:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEFC6B009D; Sat, 22 Aug 2026 15:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7216B00A1; Sat, 22 Aug 2026 15:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514036B00A2; Sat, 22 Aug 2026 15:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2F46B009D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:58:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 204C3A014B
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:58:20 +0000 (UTC)
X-FDA: 85129967160.09.0BBB9A2
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id EFAAE40007
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:58:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=XfQXjUjK;
	spf=pass (imf04.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787428698;
	b=pTURnVLGnxPC+EWa/DTU3Bm0QhS+Vfws8KRY7SBGzncRWctd+0FL71RtkrcCrtDTHt/lSb
	WOa2utUCWSr4PhVOnZN+wYrJfQH2XiCgpZ73eVv6rCmH8v5x5E12iyWHpvE9ALLFwAbgDc
	t24vEXhOPS9nuxKtkjCCPma9Ptqzgrg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=XfQXjUjK;
	spf=pass (imf04.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787428698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9EquugxwSIyMKJNunDeenMEdYCUweRVw+5sun3wzco=;
	b=QHI0WBQSrf7QEEgqvVeN2noMxP/bkcsWSZP+WiJhSkG/eme+La2TrHwASeEHYpQKkLBiPB
	vA5bqpbP321eSfTmanihQvAdcZsl6nz6zue40TxdtGzVJVf90G2y/+iBEuLFprlaO48iBS
	SgCa27e0z7rGE6QHavoKal9T8Bo9uvU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787428695;
	bh=j9EquugxwSIyMKJNunDeenMEdYCUweRVw+5sun3wzco=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XfQXjUjKWD5d4WorvWY3dtHsOfvDKR+zJrsyZkttC81JtngJk3PjzAd/TKVH6xFh6
	 VPSESmhVw3u2EDAAullSrHNK9jd2FlyMoJlKwogcxxuDZaTPryYMDGKBXaXtcXz4n/
	 KFCsaTHOSQhn57m91M73+kZCUy0eAMh33wEpxTHk=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hS7Jl0Hvwz6vK0;
	Sat, 22 Aug 2026 19:58:15 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hS7Jk4dT5z4y6W;
	Sat, 22 Aug 2026 19:58:14 +0000 (UTC)
Date: Sat, 22 Aug 2026 20:58:15 +0100
From: Bradley Morgan <include@grrlz.net>
To: =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de
CC: bsegall@google.com, dietmar.eggemann@arm.com, kees@kernel.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rostedt@goodmis.org, vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3=5D_fork=3A_initialize_functi?=
 =?US-ASCII?Q?on_graph_state_before_copy=5Fexec=5Fstate=28=29?=
In-Reply-To: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFAAE40007
X-Rspam-User: 
X-Stat-Signature: dbqeiewwethp57ffgt1zqkt7q13rnc5e
X-Rspamd-Server: rspam06
X-HE-Tag: 1787428697-734473
X-HE-Meta: U2FsdGVkX1/phOuU3yEBW7F0Zhmg+MB2TmeCjNj2mv5nCvAaZr9zPChbV7dTiE2NUMY0AIWPoGC4PvqDZTAz6nEHfnyxaXgX8716tIGs7PX9CXUllx4NUeIR6WEnVt3M0P01HSmBlv8MXgaYQ08we2J6I6vrCkkTq4ajsFisiyGP3F+aOd8f7drSiiubqagxc/8MWe8T57G4p2F7pNnyxdAzobcjZWrxWjAZnVaLPMzqE0CaHZjAKvTW2YlDFRU/avgmU1rBzPjOE42OYfb6fvJFXbZymV958HKFk0ayS3+ih7FPN2J5DohRBjYLY6OuWllBjenhSH9iZ8lgiSUGHCMjN1Gi1f41R/HNVGhhF8yzicIwNrYkn4tZPjd3XwJs4Jb/OVZQI79HzrloOfG19uZkxjkjRuFaWskuADnvErVUmxIx1wXdsFHEf5pR7av00JzaOMbVXKhilX2RvRR5JDaBOrr3V8cytqCajj6fwl7TTeCL2akWv8+jeLN6ceIhMBzpFh8MzWfsXR784tIUJ1DH1u8noiRZl/oP+oBp+mV7q4LB0Ir7AyzIksZm4/z8msSuGSQ8nEnCDq2VKCt2XeuxrYnioFL1BwqtGD2ptm4/e/wQdG113pGPftRir481/0gQJgB3PUhECyQfrD6OgT8/7FVM1cWUoGtsVlrCLJ/m6zG+nxSv9sOvzzzNFbkRCGqZUJl8c7AhLniBaYv6VVD9SOIhbLOTrVWeMrgXAENQV/uBF3ibtSxr0plcTlZEghUxNHOLyqnvNmig6+L00G2SD7YIAK8RS8kdYJ0udYQV4SW4wF7VFFgKPNWXJUcJwBZMe7VJGgb+srlh7PLOokbylZO1MT19Apfjz3ZSBk6/meiYXWL6sjRCg8WUXIge5MmO+2h6dPH18mUtZ41XAm93JkGmiKF5roCO/kjTT8z+qRWanygb3MDnF5nHB5ug7aQ+qXLaxYPr//73EQ+
 3G/SmoAX
 vmiaRVYI0QrR0LKT9wIf53bn5a+x7zd8hIZPW7EezY1h3nLWQrmkLCQX1ByIgVrrhpLKcH+M8XNbTdsLGhwinrXuLypV5QLnbCMbGZPIksrQhFPzP/ZWM2MdgFawTyODuS0s/5OlIZPePIXhKMaPV4J+7elCLZOsn6c04DQ8qK7Vgt6auBEuaQc9dsmQ1/dRdI09ysb8hy0o4Y48LCw6zzuDgpL7nwzDmRGNKM3jJmqBxxVoXfJYy7f1LEVueqBCQP/16H33d48rqDuZSWXLx0V+j4Nr80/qj++HxUT0pfcQvD/hci5BN6CHoJY6DBuWL1xsfyKSTR9duuVsebARusHc6ysq+2u981t6iiOrPjTwJFeOecRHGQ+MwMyo+U1BIiQYT4lXj0tz2wytU0hVpIA5ROvRRmHgbuLUzKqG6wq66ieNdDqbVDKQbEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 August 2026 20:53:22 BST, "Jérémy Jean"
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
>Initialize the child function graph state immediately after
>dup_task_struct(), before the first fallible operation.
>
>Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
>Cc: stable@vger.kernel.org
>Assisted-by: Codex:gpt-5

Where's my R-B, nothing changed also, it's V3!!!!

>Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>---
>Resending v2 

(no! V3!!) 


>as requested by adding Cc:
>linux-trace-kernel@vger.kernel.org
>
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

