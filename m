Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCD8C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 08:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90FC6B008C; Sat, 22 Aug 2026 04:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42036B0092; Sat, 22 Aug 2026 04:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32506B009B; Sat, 22 Aug 2026 04:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC5C86B008C
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 04:51:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D3991201C2
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:51:27 +0000 (UTC)
X-FDA: 85128286614.24.4BD2DA3
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36225160006
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:51:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=qHq26KYl;
	spf=pass (imf08.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787388685;
	b=H6QuxSt68HDwYUR9d6J+8CIMYuvmJ2zGpdg81alP6ITsBnq1jFidfcCVnt9AhWb7/IQkp9
	r/aW3HbWVzAmQ7Mtc8jng++ipONG+guq9i+SrNy7ItsGKqV/k5syXTbEvpffgCDtoOSHfq
	S+GtIZGdMZHLIFFdcB7+uXDn/Be1/ps=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=qHq26KYl;
	spf=pass (imf08.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787388685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ncN1aZMmV6xHB8ic5cG0BXjnJV9bO5CRL7wguB6z12Y=;
	b=lVOdN/ocraaZszyE8wujn8jXpq5Lvnl3KsmP8gK1/tD8Q59oes8ko+iGwFcgxKOVDLPrru
	ARf1ujp7qAZs8afYv4e0EyIR+pLaezY9aFRXgq/oVND649XtZEfOOAEzwSwde424WWsaTS
	q3ZQgZHDIUE8ydWA+qxQxbnlJGgDqw4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ncN1aZMmV6xHB8ic5cG0BXjnJV9bO5CRL7wguB6z12Y=; b=qHq26KYllmoP//SB365t0KyUKS
	iGaT6e6PzZobA0vz40PHHxmdc8U5YB++TezJqjmVfmc0vHhzllPi/+bUAUoPsRvCQ+fr5EHe3e3w2
	HFgpZzJGbrd3F/Z/lqeWOr+XOUuK9HHzOfdm5xr8ctKN6gdJoybSIjsCVpo9KokTleTKSMqg1k8l9
	kjrhqQxKuDcpc+MbL5vgwfB5evGRlzvB4Ftf13MMjVWjMtmWKpOeok8QIB+coxvTqpo+aoEML+Hf5
	/ItKgH0+wY2qF08IZjaYuUisFU3fFtQk6rAS1b8k02BpB/V1HZOo0x1/cof8Cz5iidrV1TDEEPDj+
	fAHvPuYg==;
Received: from [151.115.150.205] (port=36964 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxhRk-00000008mtz-1llr;
	Sat, 22 Aug 2026 10:51:23 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	mgorman@suse.de
Cc: include@grrlz.net,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rostedt@goodmis.org,
	vschneid@redhat.com,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH v2] fork: initialize function graph state before copy_exec_state()
Date: Sat, 22 Aug 2026 08:49:27 +0000
Message-ID: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Queue-Id: 36225160006
X-Rspam-User: 
X-Stat-Signature: dckz7ieyxxr1jfy97cejg34nj4h61rba
X-Rspamd-Server: rspam06
X-HE-Tag: 1787388685-570618
X-HE-Meta: U2FsdGVkX1/+jPpH7XHtMTqLNk2wSjCrqunQBIDLBMQi9oCPHIllcVGVt/QuCDio05XbdqFQvyh4YOo3LVC+wI9JYnckYUdaRLA1o47pgC3j/Yjrs/Dz70mpdBdtcmjgl/et/B1R9YmRd7KKbkFzkHG0Bmqt7gEZm2T89CY1fDHfNMj/WMOB3Ty0k1BXE0LF38OAHsO47A1EUI4VckwGpIk//RB/Pn5dMVNkLWj/kNMTd5X+ia8xZmWu9CNKuW9PyR5M3K4ABbuJ6LGbZhndDCFDEYFJuJyJT9V5DQBpcdgdHYF1CE0GjuYLNetFuNh4qqZMiqRXC/n+5hhcM0h1W7Dxp/vzKwkDRrkLmivYm2g1zlNPCZ9U1u2jZSzWH2KdyZ6O7MCNUrTSEECWSD3Zm3u1q1aJ6FfiDN5Zs4mKGA+a+VLvjjOAjwcjiBIia2hm5cHS6fVgr9DTYuwaFnSCc5/Go5CUmegCYAPoYsVGCC4UmuQbQTDy50AcnTRDFf9fFQ6fyGk0eFH68QUa4f1GGfK0yWbNlTYsoqWgg7mRnMhgZ1Cw3TMP+wXTkoYTR2q7EF9zW0RE03QwY2N+wUDZuwNM+zDhti3j/rcuS4oBLlu0yN98Q8LD1oz6IkA0Y5pWdceqVZJREmNAEodKNh/YiK3DKS4r4atLzl9jNDpcVcNBt2XzhKeIsl4y80Mvs9bBUc92R0M5fMWUO414X5YbYwulxk95l+v/nTE7MYdnNPe2TgesWQvjRsuh+iEnv1ty+IuO62NxkzXXrHq1voZhE8YnG56FhluZ1gfyTspRWmezQG487bLA/0BqLGgkXYaibmUTHkvqXWG2CpbMzPoo6AqqJk5cr3M8iinzgM3j/7B9EcHxBLvzD6tP8mygzm8hVdhJnrG9MkuNbEwHGhJS+5wghRvRrbWyn1edRErSojOrk9eev1npqaCYdQuv/H31GvsKfV+PoqjPKXpGxiC
 S6l0f0E1
 736Hu1eeKY6h7mrMPCUo/88c4dsG/KS1UWsVuaVyL/rvkA7HgY3Q4g474Kq33RPUTjeHweX9AmwXL+vXZ8m5NA7q0+Dd9OUnHifsy04L1Lt5Zur6Z9iEV9RVCREjxpZxZ6VEmZzkitGEI4QVdODlho7g/OPX7FzLqus+7jBMft0m1o7rphlk40DE/yT4fbX594UkmA3uqYDtNU2QtKTajykfkj7VRBBzUQgtVdGnUEwUqO7Ik5EP1qbLJgwnVbz4mHHDiADUpHhD+xj1ODVaqMrFP3vasFe0c2UnAw5kjk/LP2QoeO+ozpD834/xUT8q/bpMJoDEQNYMjyzgtoPjO9oPSJxnTjZiAr+kHXo/KfDC50Zl6Y3my51pIbl5KZrGh2ES6bFBLgOvOJGwNJh4sikZwgnXRMGUpfvFGSzJey9CnsZ+r2Gcz4Eyq315GM1yS4yHx3ozUY3bNSQnIpmPwggvZ8LwwSGJqZss6KcC+NG/GcT0Uty8WmtVOozE5xoXjVO+MZUEUkvm6vliYt6BCE03lwbbWqZ+KejN8+Dqj/yy8ltbk4Djfmzw9sAcHWgEVeOdvgenlS6DYjK1R3VOIi+5PrfzM/Gnxa8y2rH+T2vSU+3qF5iU7e5A3HXkZ4D9DxPRJ/s0xwf0lwFyYQvk95eGGYWORQV3bw9HEZnBN2y85jtx/69ZHLMIsGNKr9tLdFOEkacuWF6LS2muTgYYWzThn/ovY1UaxpP3a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dup_task_struct() copies the parent's task_struct, including ret_stack.
ftrace_graph_init_task() clears the copied function graph state, but it
currently runs after copy_exec_state().

For non-CLONE_VM forks, copy_exec_state() allocates a new task_exec_state.
If that allocation fails, copy_process() reaches bad_fork_free and
free_task() calls ftrace_graph_exit_task(). Since the child still carries
the parent's ret_stack pointer, the unwind frees the parent's active
function graph return stack. The parent subsequently accesses freed memory
from function_graph_enter_regs().

KASAN reports:

[   22.190920] ==================================================================
[   22.195899] BUG: KASAN: slab-use-after-free in function_graph_enter_regs+0xa76/0xb90
[   22.200747] Write of size 8 at addr ff110000054dc0a8 by task repro/1
[   22.205134]
[   22.210770] CPU: 0 UID: 0 PID: 1 Comm: repro Not tainted 7.2.0-07732-g9328b3b03bdc-dirty #3 PREEMPT(lazy)
[   22.212576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   22.213750] Call Trace:
[   22.215271]  <TASK>
[   22.216242]  ? ftrace_stub_direct_tramp+0x10/0x10
[   22.217774]  dump_stack_lvl+0x4e/0x70
[   22.220531]  print_report+0x157/0x4b4
[   22.223202]  ? fixup_red_left+0x9/0x30
[   22.224407]  ? complete_report_info+0x83/0x110
[   22.226679]  ? function_graph_enter_regs+0xa76/0xb90
[   22.228084]  kasan_report+0xce/0x100
[   22.230109]  ? function_graph_enter_regs+0xa76/0xb90
[   22.232860]  ? stack_trace_save+0x4/0xd0
[   22.234156]  function_graph_enter_regs+0xa76/0xb90
[   22.236090]  ? kasan_save_stack+0x30/0x50
[   22.237752]  ? __pfx_function_graph_enter_regs+0x10/0x10
[   22.238694]  ? ring_buffer_lock_reserve+0x345/0xf80
[   22.239628]  ? stack_trace_save+0x4/0xd0
[   22.242121]  ? stack_trace_save+0x4/0xd0
[   22.243588]  ftrace_graph_func+0xda/0x160
[   22.245362]  ? ftrace_stub_direct_tramp+0x10/0x10
[   22.246520]  0xffffffffa0000095
[   22.250528]  ? stack_trace_save+0x9/0xd0
[   22.251757]  ? ring_buffer_unlock_commit+0x11d/0x5c0
[   22.253152]  stack_trace_save+0x9/0xd0
[   22.254264]  kasan_save_stack+0x30/0x50
[   22.273631]  kasan_save_track+0x14/0x30
[   22.276763]  kasan_save_free_info+0x3b/0x70
[   22.278296]  __kasan_slab_free+0x43/0x70
[   22.280157]  kmem_cache_free+0xbf/0x3b0
[   22.282963]  ? ftrace_stub_direct_tramp+0x10/0x10
[   22.284001]  free_task+0xa2/0x160
[   22.285699]  ? ftrace_stub_direct_tramp+0x10/0x10
[   22.286752]  copy_process+0x2aae/0x7bc0

Initialize the child function graph state immediately after
dup_task_struct(), before the first fallible operation.

Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
Changes in v2:
- Add the KASAN report excerpt to the commit message.
- Add a comment documenting why ftrace_graph_init_task() must run before
  fallible initialization.

v1: https://lore.kernel.org/all/20260821102207.3626491-2-Jeremy.Jean@oss.cyber.gouv.fr/

 kernel/fork.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1e68404bd773..0d1ad92e2d33 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2139,6 +2139,11 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	/*
+	 * Must run before the first fallible op, so error paths never
+	 * free the parent's ret_stack.
+	 */
+	ftrace_graph_init_task(p);
 	retval = copy_exec_state(clone_flags, p);
 	if (retval)
 		goto bad_fork_free;
@@ -2165,8 +2170,6 @@ __latent_entropy struct task_struct *copy_process(
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
 
-	ftrace_graph_init_task(p);
-
 	rt_mutex_init_task(p);
 	raw_spin_lock_init(&p->blocked_lock);
 
-- 
2.47.3

