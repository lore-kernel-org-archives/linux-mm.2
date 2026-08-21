Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B92C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC61B6B00A2; Fri, 21 Aug 2026 06:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DEC6B00A3; Fri, 21 Aug 2026 06:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAFC6B00A4; Fri, 21 Aug 2026 06:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2D86B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:22:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B9791203E3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:22:52 +0000 (UTC)
X-FDA: 85124888184.02.4725285
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5B4EA0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:22:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=lthBTzfx;
	spf=pass (imf25.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307770;
	b=PdX6KlvuTUmEJm1h1g6fdwGxbwb9KdQNB2i+hen2RZkFjzbRxGc8QRWh3rExI4M6Aiu7io
	/4Jb3RQ6crpe1/7L4VeB7rg1SqGsczqyzCJhD5d3lgls8ySs93PCtkGDq9ukcMfe88cilG
	/kFVhd3jp9YKEv6Dji4jF37D4OFOj5o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=lthBTzfx;
	spf=pass (imf25.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JEr8w4nR21pzOukAyhBhhXDwo5ooGu0VwxUIJYQuB9g=;
	b=QBDF9zIKjWU6YtkrPFwdZnfXWLZq8UbPkBcm3MCQAYwzWrwsJB8blSA4GsDoKpuou+X31X
	7jN6Yo1Q55MhSVCyaT4g+iUhE1MZ1+/+Er0OX7ABLw/On592awb8UGFi3ki/X0fOUdFbEA
	QxpYt7cCRDvUEo2ZmDZGYUBA/VZUsmU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JEr8w4nR21pzOukAyhBhhXDwo5ooGu0VwxUIJYQuB9g=; b=lthBTzfxbAaZnvwdXTpDEjEvDb
	b0MDMHOKvzWsMTxkkRzamBEfAaWQwI7uM2/4bH1ZlNm5FVT7HOhKnOQr9QmakA6c4mgdxDAWsLkfd
	aYc3dGEvP+sF/BsJ0czbqqRp9V8+JhDSv3bQ5bdh9VRd59kI16tOVR/NDs2kDDweSRKltXNN/Fks5
	5LrLMYAQ9iPICSNzqBOPirLDcrjgF7si6CZ7BdkVXaV11FDy+2CEUAa15aIQqkTolfnOuCuvUCS0s
	W1ShV1poidagoCTmJ9aHbQ4vMBgVln0njDGClV8tCgAEwuKehRYzILT8FNoqxrFI96hjX0tzLxLWH
	pnxQ/VrA==;
Received: from [151.115.150.205] (port=45678 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxMOd-00000004kiq-1h8z;
	Fri, 21 Aug 2026 12:22:47 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] fork: initialize function graph state before copy_exec_state()
Date: Fri, 21 Aug 2026 10:22:08 +0000
Message-ID: <20260821102207.3626491-2-Jeremy.Jean@oss.cyber.gouv.fr>
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
X-Rspamd-Queue-Id: E5B4EA0007
X-Rspam-User: 
X-Stat-Signature: gtrpqimuh3auezh6omh8pubgjjm1c3uj
X-Rspamd-Server: rspam06
X-HE-Tag: 1787307769-958940
X-HE-Meta: U2FsdGVkX1+3LNRT6FULKoX+IRiXaKB3pvYQEcgaZhONhMXa4F2f3lQmAIkr5pGygv71KngxrfteobpLcN0KPWZaVx8nz5cQicvxIxI0lMi/EPMEqBVyhMvfvqL4SxRWWqdGq2Fk9ajr14RbeMqQ2eS77tk75uoZLFmw+jVFrkGFYY9DI9mnULHayiHSnvQeWovSk0BtFsm9EDmX0xfrHRKOwi/mtk+7x7ZG5L8osdQzR4JCaq/I68DizgYCxoUvz3CbF8PWbf26NVHFLzaiTFArTzx8xthsTJNeCdzTNeS1IH0Cy3e6Y+HRnm0s3WBcGaNCDfBrKYQhffd0eubaHa+ynSHFB+iwBfIxk6iTfQBFcdkV4UDT9yxHAgSZ1iePqwEqNka1CfqSlo5ajn9bJ2ifaOsj+/P+kkH4tlbSvFH38xtwCwBikpv96TdurXhZf6L75diLOhufyD4Ui7+Bv9GOFcdnJi0FobfYcxP7L2Oo0qWLPjpq4/CNyLF4vnjLR66jURt9sZ20AXqnuWC6uLNmkcBSpPEGPAKx6/X3MbPD0riCJCSiFO6b+xZs6T6nOyh9FwIy9bcYf63/MFo1AtG/+0n7TMTLR25HsNK3WtN9ivflGzf3aWXvOaYu3wPx9UGA8ARCA+AZP2kqoZO/6wfCjhtLAfhe29g3RgMcwA36bxH0AfyAl/7g+CexXFFqri6GPMJG4Y/VxG3WXLrP1dZ0zmJ4iqjFrFuBN1LLiU15sPEa1OlFxASkNK0A+MdhOpcn3oOokKHuGRPZmQbWrPu5ecX1xlAitOM4u9ZfPFJg96IHyr1AfHeam2ELibXIup4Qk02Af3SSUXslI2PzjGQuszlrdgtcdo2+rY0p5USHVhQ16Ui5KGs0V5Ifw07n5O2BZUF3Rr0fIG/v1ux9CZuVyb2zPR3HeCpVSyWXChWpDjYGP+9s0OpMwD1S2ShWa2PgVHZdibXIe8fnilD
 ELKcZNkI
 jMMkZXYnR97gkQ/K1jkB4x6fyM7bIPRzGy9b4HcJBgfQCh/o3rMBuUsaRB87Zf3m38Wa9HaJa3fAUhHv8wKViMA4LOkDtk1ZSwE0q+oBcvjJdWaPmuN4/5DniYJjxizeSJqoxjy2gzbyds49/gjryDjR7Ug3YRun3nr79kuJuhpv9aNZRknF2wvIdowRmRu5WvZLZZc+G8uT20Yl7ekyONJlOLGIAIzGs2O8L75013yegaVrfy1mvg/Dh1StuLhum0SbjMK6+jZL25XUvaVX6dIOPxLHb+bSrBRJFZTy8WNnkoO/2uv7He/K9MZyQOXv8hEXz0vM0dfQiIqqk3g8DSyT+Oacb9xvPchxz+Fsgi4zC6TtyX9GRCoh8crqhyV2/n+TDF0ZCBGd3ZB8TSgvPkPRqwJBxktNNZ3xIhFwyXvXs84vtmtzp8Zop8jl2lQUi0tTB5ebBlQGr7VC1uJTYaclmADRBRsQ5pGU/mexRMtkE7IqlDSNI/bFOzC9FiiVYZez8E9+Yku2daDyEb/5rYjdc4H1Wq1vtnkGvrcF8qcpOm4o0ahho8FaXv70GoVvKFcgYbImeaE+RK6DmNHHz+gGVgDl+mQ0DMuFEgB/Xh2JT2JY1jpLy9X9DNsmozvqFNZGBWkuEgBAh8EYeuRU9F92+lVoKvTGmobpBWh8dhQStAcks6BZQvvAh1Ax8CUhjjXUpkPNRC+OM0cM=
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
from function_graph_enter_regs(). KASAN reports a UAF.

Initialize the child function graph state immediately after
dup_task_struct(), before the first fallible operation.

Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 kernel/fork.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1e68404bd773..cec82a64a07c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2139,6 +2139,7 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	ftrace_graph_init_task(p);
 	retval = copy_exec_state(clone_flags, p);
 	if (retval)
 		goto bad_fork_free;
@@ -2165,8 +2166,6 @@ __latent_entropy struct task_struct *copy_process(
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
 
-	ftrace_graph_init_task(p);
-
 	rt_mutex_init_task(p);
 	raw_spin_lock_init(&p->blocked_lock);
 
-- 
2.47.3


