Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF66C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CCC6B00A1; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363066B00A2; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A366B00A3; Tue, 21 Jul 2026 04:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7D956B00A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C12A1A0419
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:17 +0000 (UTC)
X-FDA: 85012083954.21.9A5D1E2
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D628180004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cmIYzAmI;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621955;
	b=u/qIZex/kCbuRj0qios/0AkS368/XFoXxdEAzJ1mHQR7zHPR1ruysAQuYzy+e8WiV2tWkF
	gjjTSuRypOg4+xYsD8JyQyaRzxRK4ftOl5VWciLvqos/8BLKkE0YlcqdcJgUiWv/IJgM7l
	qq+YyJNfXw3VL6C35IahdjrD1JcLBR8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cmIYzAmI;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJShMCtyimdX2KeHs8Tw3X37eMg1YBO6wlLxysxraB8=;
	b=bc0ePi48uwcwhm0fmnnsu0zFIJwKbP7xxhegpgcdXH03L+lKCxFXdSUucpIpxbBf8B0RwI
	bC+0tI4IG9uOkcNJODCir/Xb5ZJxBlswjg8rc4pxV/SxFyRwkYfodVZOb0cO/Q0ONYWPN9
	GOm95La1Qejv9kEiezHVtUn6mg4w9t4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZJShMCtyimdX2KeHs8Tw3X37eMg1YBO6wlLxysxraB8=;
	b=cmIYzAmIqMsTiv/FxICiXdfjvxj5m9TGMUun0VTU6HFiEqjVehHP6Loq1QRmd8gQ5kRLlc0nP
	0DDQolTtMS9cFFmiti+L6B8NKZIRGeB6/RV30wFlV/JTX7tKnhs+V+U2mbGs/H/TJPVfOOh+Hhn
	o+JYuqsNiDKCAUCgjh492gg=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h495z1sL2zcbMk;
	Tue, 21 Jul 2026 16:09:43 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 21B1940537;
	Tue, 21 Jul 2026 16:19:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:08 +0800
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
Subject: [PATCH v17 10/15] arm64: syscall: Use exit-specific flags check in el0_svc_common()
Date: Tue, 21 Jul 2026 16:18:53 +0800
Message-ID: <20260721081858.1169276-11-ruanjinjie@huawei.com>
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
X-Rspamd-Queue-Id: 5D628180004
X-Stat-Signature: se1ayf48gqfozasjqqdjxqtt5p3uhnrj
X-Rspam-User: 
X-HE-Tag: 1784621955-230837
X-HE-Meta: U2FsdGVkX18DnopeP0dUWcHxDRkbYtFaCUZ6A2uJ1hC0pN1nyOMf3/KkRuoEaKZaMpyTIRY865sZnCQzhk6lg9rzwjKNN+bv+zBYpIZeKjHN17v7dKlCRQNxz0LGf2Ifmx5eL6WoKKO49OB3GkTjLHdgULf3UZeXQ4kNB6FrfRe2yoPLY4PU1tVbtvROPZwemJFhDdAEphOblhkZbGDTKbaeBpRAY0h7ElFe/8bq3b/aRQ4Clekk22D4+tcX+cAaNHlpyMmcb8k/crg2deGtLhTOstTGSqnSRmjGdZ0ef0QJu5FiX9gN1wnSPhJ5AGtxtRMaUSlH3YJUabzJm3XxnDDvny7+96aDJG0C3oiXHP+4rfhVPhKSGUUlItCuBrpoqCuY/17xeCvN9bY1+wOlJWljheitobFO1C6WQRlew/slAEQZsgZ0vwQFbP2yvcfCs9w4yEuP34dJ4reM0cjtQpl7yVm6KXN6v8ZR9GWAw6aVEMDaZpwhasgjv5vTZ2NDCBBgdOT0JDCTNGZMt/JvipHfHfPSycMHsDUcuB+Hu5WTRa/JueKoZT8UZ87v4zNO2Lo3h+96HNKiQvZBnTXyEEPopqvOHNC2Xhl1L/hQ9UDgmA9arH3rFqQEwcWvUpf96J14PI974ggMMtWJtOFj60lukIg7fLY2cZi+YEmBpLv80E25UUA8Wy0/Pq1cLZlmJi7JYoFDieqRJx6p2ZATsAIeg8KxAFGNmafGGXLYzPhv0aAfJIZaYpFTlH9TvMHDqtZPuDfE9YvwZUIsr5jQ4kKZwsd+jqM34S1BsFGVmQgRCVbXRHVEJ01ZLyGli4m17IS8FdVI/aZ7wCYGR989gnqSD/O+p/Oil3hWSbuaJKFo9w0+8W2G9hb4Jbt2zZ6bSPXJ4I0CUxKQHO20rVQHByouDi6ef0HtyvpL2GN/LlfmQcYINRNB9CkM4J7j0ySBEV9mbWALMiEHdrOIaH4
 uoVyWqS1
 c07jLM/rUV/V8bv0w454pFPj1Q+5O9M907vQYlzdD3IZjes5IKiJ4Uhscu12YZ2TexQBm3AEKuCNR03XofdOfXFaTtxgXEhaz4JHG8MmWWcFZ/MzuZyImFWoaFNEa4VRy/7+egSj3old0kMF6Sv0Vh/Kjrj3kxsHcadyvKYrdBMSV92ilbq2wM5w+89L/sAbWh3WRaRszNNV7xIymvvpnnTNp695bFo8k+NH0nBHsRaw/uCL6nYNo0LIK8mOBszhPoaR9xehdkA3np9OmBu+FC7QgkSiakLCRftpVVUP0A4BNlSCnTABjIVwjVYXJM7mk5bcmfeh4FpCEPZMfAdlIKYqfmHe6ccYvFxJrDagTmVHEHT8UCvvoa7nD1tVIwPL4qHoZvAUOmuBkQzsi1u+Oj5ITUpPNDyHaOc35ahNDNszHosU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use exit-specific _TIF_SYSCALL_EXIT_WORK mask to filter out entry-only
flags during the system call exit path checks. This aligns arm64 with
the generic entry framework's SYSCALL_WORK_EXIT semantics.

[Rationale]
The current syscall exit path re-evaluates the thread flags using
the global _TIF_SYSCALL_WORK mask. However, _TIF_SYSCALL_WORK includes
flags that are strictly relevant to system call entry processing:

1. _TIF_SECCOMP: Seccomp filtering (__seccomp_permit_syscall()) only
  runs on entry. There is no seccomp callback for syscall exit.

2. _TIF_SYSCALL_EMU: In PTRACE_SYSEMU mode, the syscall is
  intercepted and skipped on entry. Since the syscall is never fully
  executed, reporting a separate syscall exit stop is unnecessary.

[Changes]
- _TIF_SYSCALL_EXIT_WORK: A new mask containing only flags
  requiring exit-time processing: _TIF_SYSCALL_TRACE, _TIF_SYSCALL_AUDIT,
  and _TIF_SYSCALL_TRACEPOINT.

- Optimize re-evaluation check: Use _TIF_SYSCALL_EXIT_WORK inside the
  el0_svc_common() fast-path block to prevent redundant exit work execution
  when entry-only flags fluctuate or are synchronously modified under
  the hood. The outermost gating maintains _TIF_SYSCALL_WORK to preserve
  architectural entry-exit symmetry for tracers.

- Cleanup: Remove the has_syscall_work() helper as it is no longer
  needed, supporting direct flag comparison to clearly distinguish between
  entry and exit mandates.

[Impact]
Unnecessary exit tracing and auditing processing are safely bypassed when
entry-specific flags fluctuate during the fast-path re-check block. This
safely streamlines the syscall exit sequence to mirror the generic entry
syscall exit behaviors without breaking debugger expectations.

No functional changes intended

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 0061fc63e7ba..a8e0bf8d362e 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -54,11 +54,6 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 	syscall_set_return_value(current, regs, 0, ret);
 }
 
-static inline bool has_syscall_work(unsigned long flags)
-{
-	return unlikely(flags & _TIF_SYSCALL_WORK);
-}
-
 static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 			   const syscall_fn_t syscall_table[])
 {
@@ -95,7 +90,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 		return;
 	}
 
-	if (has_syscall_work(flags)) {
+	if (unlikely(flags & _TIF_SYSCALL_WORK)) {
 		/*
 		 * The de-facto standard way to skip a system call using ptrace
 		 * is to set the system call to -1 (NO_SYSCALL) and set x0 to a
@@ -125,9 +120,9 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 * check again. However, if we were tracing entry, then we always trace
 	 * exit regardless, as the old entry assembly did.
 	 */
-	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
+	if (!(unlikely(flags & _TIF_SYSCALL_WORK)) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
+		if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
 			arm64_syscall_exit_to_user_mode_work(regs);
 		return;
 	}
-- 
2.34.1


