Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF00AC5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 19:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F31C6B009F; Sat, 22 Aug 2026 15:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F886B00A1; Sat, 22 Aug 2026 15:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CF36B00A2; Sat, 22 Aug 2026 15:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4036B009F
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:54:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A47C51201E0
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:54:35 +0000 (UTC)
X-FDA: 85129957710.06.B7DCDC3
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F7AE40004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:54:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b="T6/GK7x8";
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf07.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787428473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DeaaWX1ouakkcNaKozCGuM3FyQea1VdOoTXNpsxvZMc=;
	b=BRc3B/pYCmj4zSDBmDiMVCuBVwyJWy0PqiK7s+jYoqbZPmliEBRZ3WaQtQnHeVvcOTNXvf
	tnpm7M13kh1+ZC/ywnlAj47vR1ffWGp1/4y8NktOwSbn3UqGDgBzVvoR2CFOqsWlWyLKyy
	gIZ2HSFqPsCzBihq3gw35Q/N+uwomeU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b="T6/GK7x8";
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf07.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787428473;
	b=wXNE1BOPvBbwJOXxssL2I9x9XdBK26o0dXcq8Agrl4URGnIXjTeQxQWWXLN0sthXGE7M0e
	uI81nPy8zPc1ZmfApiOWXR8N0EHQQHsmAsLINMOOGD/MCb7wtylXpIoSA5/l/ZkWAjLSDF
	l4qE22JEZVdSmBwKFeMZyt7ywasgqiY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DeaaWX1ouakkcNaKozCGuM3FyQea1VdOoTXNpsxvZMc=; b=T6/GK7x8daDmjTIhhuJdakugFd
	u7Sc7g4itfX3T8oyRt69Mi0c5BqmafQ47rpExNKShdb7iwNrpStR/OSQ9E05iJs0wTQjvGO+FAft9
	x+NrHhL/ea/6HZf/x5mIy+zuPCkpXG2Ot1uZ83LizlZGiHrWBUYrWWJZO28Dq2Qjc/jS77idsLC+n
	UYXRUW3Vpr3zawqUybI4xhGzOf723p0UPUB+QM6SSsAMTAspZ80WPek0IbsdUvTcu003SEk1C5JZ7
	DURbGM2VLeAR5Lg6G5OnbPmqtGqZEh+lkZ9q1S3jVKVkpnHg8QydXU4yKFgQErU8APehke3XQGF0u
	94bsmKlQ==;
Received: from [151.115.150.205] (port=58538 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxrnU-00000001KTo-1srE;
	Sat, 22 Aug 2026 21:54:31 +0200
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
	linux-trace-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH v2] fork: initialize function graph state before copy_exec_state()
Date: Sat, 22 Aug 2026 19:53:22 +0000
Message-ID: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F7AE40004
X-Rspamd-Server: rspam07
X-Stat-Signature: pt1qjxeymyanfrjzijhfarjue1g4dx5c
X-HE-Tag: 1787428473-198121
X-HE-Meta: U2FsdGVkX18P/cUO4txrch6pV2Ce7dnrMR4iD69VsCprZQrPCBpdFCEwG7UGWzIVQTZgxq9tiv8IJyd8znLKpSSWfRRVF0pQMGz0mPRt3soaQTZXJwS1q3zg9JVJJJ/1rju5faXNIvh3BXq84A7C0UsSu3YoF4bReIUCI9N6nSkJ3z+4floQDcb6xUzGo5HMIe7V4U1xX+BVieUaDWyP3NHtE/BIwTA9LZcNVoVXzPUJCgZxGUmL5n+H31qxRrC/NcVm0r45ekx/Dq3jLh76EYzHRYMqFrczAv0yFa/iISEr6st39ErdIEp+4WPLmBrMZl1BOjg85z1vSBZeRczTrG32klr6jaM902jPTV1WzIPWc+XbEF92WnwGvTK6JW1TOXSIhELoIWFbC8o8GO9TVEdUYRnf9/r7LMFzsU342TlWWmRjnSeuWJwO7jloVLAHaz1iTwPbQvoBaI1daDjaQi9QnZLpnMmatVHlJAa/aoQegeC/SShvonbFjDPI+viD+Vw5mPb0cBfLjLB4nxmu8EnEB/4zDs4y7UkGpHQnZIAxhA48kQHol20Awx0dJU65IzvJQO3WgzqqZQjgECSHn475hYxGexLaCbZcxJ5wAj2cH7zVpsZ3fsZMO3pcnvab7BLijc4JXjGu32m/fxTvjXH7A8l8rK3aBcw9Kmot87SMjcCqgCHInkNMHTsSjAXR//wUyGTVk9Pt26W6UXolAPyVy1uiritzN+hgI5TVhC6BAdMrGlgG24NtbxWEZFKD39AbJS9FZ683njqjl4eianWdM+3NV5tRrY30k4wLf24OVso12ys5cF3cx3qotsRokeGZT/ytHbk42L+dvH0N9kVoOjBMp2sM/N0IriNwzwYYGc6p96bsBP6EOwnioDFnPmkG5Feaj9ieNdcf/swPiAcLJI+CS08Jz8cHjX/GmTxgTNwDS/9/qsbNs78auLfFSiueeRtlgcgep2/1pLR
 JH3FExQ2
 rX2FQEzS1i0OPkdD7cLq2V+K48U3oP3jR0N9FN1WpA337kzb+/JvDbpppNU4Dsjnvwj8jGGjkk2RxN/A1+hKFai5+xh5pl5EnP8LWsJmzGQSsbxFRcCkmLRpw3+VO0t9CAOtmQ6WBCbJ28V+iQHYg+5Zfm4Pmcvf97fvSnvC7AjPvmXMZWgnifKS6g9Ktx2Qll4rsCBUMKBCkvuonJzZnEn+jPUMeu2Vs7MvaqDaxKjCf63qHWztV5cbCK9Gmz/KNJB6CZWMdv7n18arawKPDpCiLdG3K9UIrsMpZFk5vMytAqvR8EJBCDyBYXnjhW2LdA79nahUqDz3X4L1wK9ASQ+KRydlwBAU0X1RoTdP6PxMXaAY3FvlOP8RPAxbv424u6WoMAMq6Zl3vLHG2bcZRWPPz5by7BEaZWUMHrxFSFK7x0Pb4Ia2XuX6nKCDvKcXe1Lts4qbX3FEBlUlfxiz10Ju9ZfXA1CXBPp71omGjO00bdrRpHYoc8n6TNpeNtxcKGH2N5F5LEMEoqDVfyPQc22XAFUJxdaQ8hkGrN32Bb6ljGZa5Wbzj8Rq45ldjuQFxkePndFdavIPeHufFKD77I8juzWw3FbPzHSahbTjmCAe7xoiB6dVmalij7s5/UR9brLl7T9LZ92IBnq79Mcfi1/xtXWB1AveYeQ1LUzJvp2D5eGh4eqwudR2y9rplhebAVxa2bL2fCvx6/aEqQW6Q0fluXgkhL1lFzX6+
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
Resending v2 as requested by adding Cc: linux-trace-kernel@vger.kernel.org

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

