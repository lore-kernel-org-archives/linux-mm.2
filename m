Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CA4C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50B86B00A0; Tue, 21 Jul 2026 04:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01C66B00A1; Tue, 21 Jul 2026 04:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EA46B00A2; Tue, 21 Jul 2026 04:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1C76B00A0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3C4E1C03ED
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:15 +0000 (UTC)
X-FDA: 85012083870.21.97E4B8F
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5264A0008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TbmmB0kh;
	spf=pass (imf15.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621954;
	b=c18IHeP5nVwDdRqworpqjawzDlA6QH5+SScg4nahLEPvyaLVqVHnoLg4xdDz0/QFSYBF1N
	F7uOzGLqlWk24TgFZi8183qIs7av3wvoUp5t/iY6KauWrNAJvyEvzgj6JsWWOY1aKr+AZm
	M5GEX1lk0/aHMz0vhhEIy9HcI8wuuBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TbmmB0kh;
	spf=pass (imf15.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJeAdwdxWOOSys6gC+zXvLV8FMT7RnU+jSncR7MBcTQ=;
	b=6SI1b8bj5rB02dUhSP7y7kxFyzsPW6Qdbw2LApfVZC+HAybeNNI6ur6zaRlNOurdxtopSb
	c31Gln+otJ5N8IV1SINguPr0HdAWL/TLej5V7fEOs2mczqgH2uEjWrLZTwTaSic1a6w6hP
	pXmXtQ5KpE3U2SxIas4GAjerQsJFk2s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NJeAdwdxWOOSys6gC+zXvLV8FMT7RnU+jSncR7MBcTQ=;
	b=TbmmB0khGaHtXpeDcUUIXptONjXPj43FzUyeUQ1RfNjScRToqG3B1xy+rOBAcV246tsnMce5c
	Tqz/Bcf/7v9QxN/Jti5CjoxBj4ZPbsoH8s4tzGPSo35jqsMfywnmUqAPtYxwg5b1MWQCHSlUZrN
	EI3lQedyWGYVe6IKy/936Do=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h49652fj3zLlWC;
	Tue, 21 Jul 2026 16:09:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 63FD440565;
	Tue, 21 Jul 2026 16:19:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:10 +0800
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
Subject: [PATCH v17 11/15] arm64: syscall: Simplify el0_svc_common() syscall exit path
Date: Tue, 21 Jul 2026 16:18:54 +0800
Message-ID: <20260721081858.1169276-12-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5264A0008
X-Stat-Signature: 4jerybj6gktwanezgm5xwtjsodupqcj1
X-Rspam-User: 
X-HE-Tag: 1784621953-962407
X-HE-Meta: U2FsdGVkX19cmQ84eADhFhQkAEH/ZMuASkm/TlJCUyHo5WmzelspbyJGby0UaMs/4+BIbIN3a8GG76w0iB27jgAItiW48LWklymIMjh1dCBX8s1up74Fge7jn+pt7gFsx8W/JZcvQmvK1O8ZGq/TMUppz9KqNXNkymuDjsPZQqssootLpxFwfGnbvN6KR8LW3dSOddBaJ3v3A0tatwK6y3a9SOKDNyiVnu7Q0F9w3l2EogmAXaF9//wqz5Bz12z82TXVpy8lcD1kfGF9EDYPwd/TJfDWyD9Du4sAB9+xNRAbc6Kkjy1olCJqjafCIygyRhKE3Ie8/KeggRR+bwuw6x7OtRNq8dkZ7n4PAucGezWfnvE78t1PbolG17mllMErNayA4MqVs5LPwWek4SfM+JgKmUz8R/mk7YXLGpmDVbtFgxBcdxo8VUFSNHbcAQk7L+3Y3YtjQ5OGmdTqmbMFZMf/NVtfqIyjm9EFqG0ZV9ozetHzCnWHFX4RHvtka0DL9SqLtHhrmEqMkK4ghVuQskqO9bYBl+8NzeKil+HCtKVG8tbL22hOb3zjAy9hSR3P+t0JdnkK7cKWZUSITTQnMnIKChxawMCyNXxEj8AJnEJMQ5nO/vRAYuxwCycV+j8vGbasrjzPTPNv0OJ8QFAkaWxJUo8vRHjcKuySvRlJ6JaqV1nGmm7RFmX4UyxV+Fx7pUdw68gZXPutb51q0gNhVSaG/aYJSp0gIPRFgqBnWnd687VMPcIUP7yN7/XLJRPxZQmtrVmW5PwxAP5w0/e9pejbId+V3AGCXtvsbMY/RORjxKbTBaRcAvz3O7vS/zuW8nFDQW/vGUiw9/r3YlUETBnhjON0T9B9ZBiF7ULOHmAEqUf1ydvwtVdj18WasTlewlAZWtKtoNRkqTWjQNuTQl9TdWUu2KaNcvXC4iPFGAVcUIpYN/3Rnw39eARmA7Oy63bx+IQP/dpydSHypIc
 tIXdqe7u
 YteYWOxz7Xt6I6uWgnIKvyO4CoqvX0MsE7Y0u+uSEwkZFVLB0y+6DHtrZ7+qxE8Y5vtWzn7jbhbt/kGGxStTUS+mgEx1n8vpLjPEUW/7wEmZvPkmxjuXA7fZbJU1InFvEFnS2W48e/51Mws4yrrfy5Oq1HVfTm0HXtcj8Fw2Xj6dKhH7rEbfPejeCZDmBeacdgQDbowK23zzp0LOISVR7l+te/wQs7EompKMgvsU0sbUioPbPZ3vO6ygjrnXkkYC4ERLUgPmd/ZS/YlGm2TEZ0TxRMBTJuhjfbL8/Lvj1zb45NaH342/YPGc6MQtWXP+aRIrTtfcyvUfP2geJmo/x2o40ldG/CynR6Wi3uBpPmZ+aBXwx2Ra3MbFDcSo9AQEQDpnRSgrWi/avMiJSZLufz/uDjEhIAW0ScJHHC8i/NUA4zz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the redundant nested conditional check within the system call
exit path of el0_svc_common() to streamline the exit sequence.

When entering this fast-path block, CONFIG_DEBUG_RSEQ is guaranteed to be
disabled so the call of rseq_syscall() is a no-op. Under this constraint,
the code logic inside the block becomes completely identical to what
the arm64_syscall_exit_to_user_mode_work() helper already does. Replace
that nested logic with a direct invocation of the helper, eliminating
redundant code.

Before:

| if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
| 	flags = read_thread_flags();
| 	if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
| 		arm64_syscall_exit_to_user_mode_work(regs);
| 	return;
| }
| trace_exit:
|	arm64_syscall_exit_to_user_mode_work(regs);

After simplify:

| if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
|	arm64_syscall_exit_to_user_mode_work(regs);
|	return;
| }
| trace_exit:
|	arm64_syscall_exit_to_user_mode_work(regs);

Furthermore, Since both the conditional fast-path and the fallback
slow-path now uniformly invoke arm64_syscall_exit_to_user_mode_work(),
this explicit conditional branch is entirely redundant regardless of
whether the evaluation is true or false. Removing it collapses
the duplicated logic into a single, unconditional path.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index a8e0bf8d362e..3488afd45d20 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -114,19 +114,6 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	}
 
 	invoke_syscall(regs, scno, sc_nr, syscall_table);
-
-	/*
-	 * The tracing status may have changed under our feet, so we have to
-	 * check again. However, if we were tracing entry, then we always trace
-	 * exit regardless, as the old entry assembly did.
-	 */
-	if (!(unlikely(flags & _TIF_SYSCALL_WORK)) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
-		flags = read_thread_flags();
-		if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
-			arm64_syscall_exit_to_user_mode_work(regs);
-		return;
-	}
-
 trace_exit:
 	arm64_syscall_exit_to_user_mode_work(regs);
 }
-- 
2.34.1


