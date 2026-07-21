Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3188FC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53FC6B0096; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28BD6B0095; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EA86B0095; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF256B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B4AD1C0714
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:09 +0000 (UTC)
X-FDA: 85012083618.15.6B4C6A3
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81F6DC0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AdCiGYI8;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6B3Gao3CM3hLw8ujO0Qq5QsLTpHvJFrMR8p5PSsAXY=;
	b=jZXWrVFnOSpnBEpWQ+NHERyCrydri042WamgdIWH+jLg7rcGuZle4fOAM37WO6F8l9Tv5p
	VeZ/UiLk87H+gOZnJe5pVL9iI1xKi0gAtTFhjgFsykfaI+NAsJzTqHn6r/5EOv15vWq/F8
	xCyHAcLMCG/TP7xxUXvAlzHCk6UYtq4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621947;
	b=wYbf865t6cLGan6bgdTMRuFPpz0Fr1b//UgTwknTStm8pISPYU5ZK4xiIksUPCwiixvj2M
	5CKfRfn57IHxIoJ+6Irzm8zLxMmiHxKo+Vm8DkGLA/hKigQEVS2EehlXT+Nb4qg7y5JaKo
	4x5LtgLoR39Ql7/OWCNTb5cJNRaO4W0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AdCiGYI8;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=B6B3Gao3CM3hLw8ujO0Qq5QsLTpHvJFrMR8p5PSsAXY=;
	b=AdCiGYI8A8KoydTh1/IldScgqbMkAmZbBsJNyxB82Q/JL5wixzDJATHG4in9BaEh+iiMsbUjm
	QBf6fPc/imWDqQ1EHokeN6tBsOp2jPQ9qB3kmdaIl9Xb7WqK59FxqO47SDV3ULDID3SkUrtv/PY
	tezZPJgpjiZXumwzbu8TPtc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4h496J4f8pzpStj;
	Tue, 21 Jul 2026 16:10:00 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id BC514203C8;
	Tue, 21 Jul 2026 16:19:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:02 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<linusw@kernel.org>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <broonie@kernel.org>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v17 05/15] arm64: ptrace: Protect rseq_syscall() from tracer PC modifications
Date: Tue, 21 Jul 2026 16:18:48 +0800
Message-ID: <20260721081858.1169276-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81F6DC0003
X-Stat-Signature: 949jtkdsj3n3mit7sp7n7zcgkp5njzzn
X-HE-Tag: 1784621946-199136
X-HE-Meta: U2FsdGVkX19HM4dId5YMSnpBA1Yqz9YYBM3CxW3auKcoc0Ic2XPfW0vR9auSFWR/aX7tTqhutq19kGsBZgfRLAu8PVTnNmSYItHyD+egPsG9ZaMc08kfwL2jFTnrPXhvuezTqweAoIzXuW6Gt9eJkhVod+Z8SfQ1YEAonQApm1WlNpdULFmUTFqcyGu219iM+WAAzTYAIDBJJVbBOeXx+I0KNg89W0eKC9+9b2Np9yEQtiZSLQi2EWazocF5Pfgi0f2Ey0hhIJv0MPbMvrV4XZgYNGopDBSB60IAeDT5UmFybBLc8JVFpswExFkRSNl47Ie91z/9h8hVrQN/F4y/sRCppKbE3l4bKrqaKVADUD86IM/H57zFjyiahoOVVbdtl7N9a/j1FLHsEkyDJcxMIT+a3x276r/ogL9AoBDZWo8+25uQLmEeHtsDoKERfOMim1PRRFChiHt+ngbZ8luV5YN4oCSHocni0kgJYFZwql0hGewicbJmA1ggqdQdU+cbz0bMcFWag+Fm6iO99xJz0wu0ZF/SUKLCw/VZDxWViijKpdKx/a68sPIeTta4fmb6z6/lmdizdkmV8ln/vuNQ1aDP/Vk9FvYz7CIFuHn5jh2us4jN4rMxPNSnkgXtzuH8SlqPIV3JyaK5VvqMNdF01fWNTgl4T1V4/j1dqVH3SUFW4cRjv63whSh3rIHfhUH3qGxJpCAw0rnBnM8yLfu5Kny29+B5JkC8Eg7kd5I97GQjWkafbrdCwhpXqSkEEafrM/eRL2JOQJwho+SIr4wPOOaIP9YagrA78PpD4Gbv1Ms4RuK9fzcoX4pRxfpLeiQGwN8mjLhigJ30C7nb83tbKMdwAZmDnTa/VUJi56XWyyTMj8/uaUWMBdRQFPivbp9uafHhu1Qn8f3LmdCTnbXnA0eLwu0SjR+HskI6zH8UDnQLnfr+sRXr6rNPPTgNFblaIPlCmFZwF8nu1I5cdHg
 QIBVwm1H
 GXbS85SkgkHRWd3Qwo5jKam1gYbIl++0ZgJJUxdabWw1khxlh6JnQuIxLi3Khd2aFQrHyEmVgL7gUlYgqNG5MB2h5E1jsSyrEWBwBvc41bRP+YUN0wDLgYNF6lxB0NsGHkr00Wsk551w2uvn3xxvqImczaBiUpQL6A+IjGUwmlsqpCb/C6+omj71JWWQp8+5d+wOJuBLHiBBcvylsMOS7R14+RUCkGbuT6/79TJqBK6IYGrl3W1ms9rNgvAz1xDeNEDQ4/K5IFhis5WbD6WYrHKAuA11JE5fgWhUF68an1CuqDQDE8NGzHCoY4Kg0ubuXoVj+ezo7bLpPPO7SLsn/laErUEGHO5SXuOb0dJoKslCWaA+QaUbtNXHsGnqDBdE4EtDAQUiS2puIOoBtYubL251UIu1DtWAD1nUnhJ4CfGgrSsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the rseq_syscall() check earlier in the syscall exit path to ensure
it operates on the original instruction pointer (regs->pc) before any
potential modification by a tracer.

[Background]
When CONFIG_DEBUG_RSEQ is enabled, rseq_syscall() verifies that a system
call was not executed within an rseq critical section by examining
regs->pc. If a violation is detected, it triggers a SIGSEGV.

[Problem]
Currently, arm64 invokes rseq_syscall() after report_syscall_exit().
However, during report_syscall_exit(), a ptrace tracer can modify the
task's instruction pointer via PTRACE_SETREGSET (with NT_PRSTATUS). This
leads to an inconsistency where rseq may analyze a post-trace PC instead
of the actual PC at the time of syscall exit.

[Why this matters]
The rseq check is intended to validate the execution context of the
syscall itself. Analyzing a tracer-modified PC can lead to incorrect
detection or missed violations. Moving the check earlier ensures rseq
sees the authentic state of the task.

[Alignment]
This change aligns arm64 with:
- Generic entry, which calls rseq_syscall() first.
- arm32 implementation, which also performs the check before audit.

[Impact]
There is no functional change to signal delivery; SIGSEGV will still be
processed in arm64_exit_to_user_mode() at the end of the exit path.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 4c7dba12629c..a7091333a9e9 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2511,6 +2511,8 @@ void syscall_trace_exit(struct pt_regs *regs)
 	unsigned long flags = read_thread_flags();
 	bool step;
 
+	rseq_syscall(regs);
+
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
@@ -2519,8 +2521,6 @@ void syscall_trace_exit(struct pt_regs *regs)
 	step = report_single_step(flags);
 	if (step || flags & _TIF_SYSCALL_TRACE)
 		report_syscall_exit(regs);
-
-	rseq_syscall(regs);
 }
 
 /*
-- 
2.34.1


