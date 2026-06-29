Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41348C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B922F6B00D6; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4206B00DA; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4036B00DC; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7269B6B00D6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 169151A06C8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:46 +0000 (UTC)
X-FDA: 84932977332.20.DDC3ECC
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4B64100018
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WOSDlhXC;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738464;
	b=5UTC+hXYCWbQvaSnTjVNJCNKgWNjHXkFC/T43yQrSISN+JJjwJLrA2eelaEacyHxpk/0FR
	/5WEbEh2Ar0CNkIoObhUTXV3d7db4cBciSwaImf94ApS68ow6QJAfsFuMwlVrHhHWMp0Jg
	4Z/rLpk5/m1HWlRKy86tvoRfQV9kr28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sNn+EhmZkPBnxB5RQNDtHQcKZyPX1Y9+NQI7nSKf14=;
	b=3qJYH0LXl3coGYSI9cjj6TWde50XGIlkP9FzBna/+zYtpe2OAezYJWokp/bO3wHhuIwgxJ
	UbVozdniwcA4DNXUpZVV1+PFbJbeQn8F48rCqB6k7HUGJe5ijlk3tjmwrTZTNicUwhd1fU
	EcViMTlVJiVTKc2et3Enk2Y3Tj2AozE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WOSDlhXC;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2sNn+EhmZkPBnxB5RQNDtHQcKZyPX1Y9+NQI7nSKf14=;
	b=WOSDlhXCtKSH9DuQjQF7cN7xo24WszR3BWM9oku/cs7+saNJ+E9vPIIg/8CLYSaNprTRXxF7A
	hEdudLHYk8HD7RmzXNu55qhb9nXz/Ltq92CIWHTtxa3KkGjW/uQOvRjsjjeEpCF/QRk1Rs1R7/e
	KTNbN8PrEwYPo0zlJjtVoUU=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gpmY93R04z1cyPd;
	Mon, 29 Jun 2026 20:58:21 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E40040586;
	Mon, 29 Jun 2026 21:07:28 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:24 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <linusw@kernel.org>,
	<yeoreum.yun@arm.com>, <song@kernel.org>, <james.morse@arm.com>,
	<anshuman.khandual@arm.com>, <broonie@kernel.org>, <liqiang01@kylinos.cn>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>,
	<sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>, <austin.kim@lge.com>,
	<jchrist@linux.ibm.com>, <arnd@arndb.de>, <thomas.weissschuh@linutronix.de>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>, <jgross@suse.com>,
	<kas@kernel.org>, <x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
Subject: [PATCH v16 12/18] arm64: syscall: Use exit-specific flags check in el0_svc_common()
Date: Mon, 29 Jun 2026 21:06:10 +0800
Message-ID: <20260629130616.642022-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A4B64100018
X-Rspam-User: 
X-Stat-Signature: hy6k83dkkygh99uk6f3z4pw9i5zoc3mh
X-HE-Tag: 1782738463-705660
X-HE-Meta: U2FsdGVkX1+GQyc/dokxLUeFa8MZhT8REEX0M0tcW5Sy2JE4n6W/X5uMV0n32jZSA8WUih7lUwjLqXvEA3zEQymOtq+NeqIH+4rEwJcQP0pK6Lcs364uX+4FGdUL/r3HBZQlshHryyE317QfbZUaXDDXu/k9XEo8/aWqnjjByudz4J5u2shzxzskau9yjN2L4qc2qhfbtHme/SC8bmNyd74jWSBS9cHrUVNGa7Cas0Fc1H8mvAv9C7Gj+msG6bkF9Zs3Er+OLfUc03Xcu9Te6sk9TZSxGAOTUR6qNQiL2trZLRRNXkNSpLKRxRO6nl1lbCJQYBnR3weiIEqePu+bCFKJyekn3KiR+Xl276HTGKkqeZj/zRbd4lLIb6W0ATK+7xb6wwiEUdWoOXmbHF4E6AtKnldH8Q5XXksVFKRp5W5tACRKSB8+t1gEPBEcMi9GcQQjXohcoiBo/Def9n7gnJesDq9D3oBX/YyjnzAEN6e3s4RUuWz0wovJvKETzyonZZ36a2HM01mjV2zFPGQzs6QFT0424XxrDyzzLBkUULa5I8iuT3mkO4NmctmLcFSBJwsiNUwruS0mwNcHQ6Cik2/ixBxLho25F9Qs4teF6ZVOeB5iSKyq2zj2YfTTweUCCypev8MjsfPV8v5X+ZmgdhniHxMUEqOYkuZwM7XGQVbTHcWyWg29XGD33hQUrD8OormHYMnAY+CwFX8ilPtNQGtex6+HuBIQSUOcV9t3xVf9kl1/2dlAoMWwCp+n2PQB6KW+gCTaxZdTr0P5HeDO2k/ACKKwX9BNTaP6r+3P3dhgf1tApNe+C333XtouDwh+3NUdOb5Q+EFezS3cBWDsJKQZyQ39SzlWuBBuhUoI0tPy3E0WXMVuWVmiysLFyX8z1Mw8R1f9x46iPqg1PajkudcuM/O6cojJWxvE9SBh1wJ2h+yIVx5CenYqiPcQC3yRjAFwNsZcieg4096Uw2l
 90NdpOuz
 qyQB9cggjTiOYpGtVNrVBLEvvc1dztVYE6x0cQtlyq4s4Qp6+ywNDs1UYdUhl5MLeC1Jrbjgl8eTVTfPG8JjtdhWqVS5KgqfJuGf+jfwt/h2+lbwuMA2/+zo6Kgyy6raksyopOQFjZEaQSQo2xDqzvVKytw1I3kLANXZAVd6iaCxsFfuFXha8MKNmLYXw6So5B8lk9AgeEtRcnrrUx+WncxJBaU3g31GojaOlyRdsZdMOkCuLd+fT1um15lBkKbcMUq109qua+Csyv7CfPTfcx7RSMZOheJ6ESwOamFg8TABQsotYRX5fBtalKMzvzDdRgucIQMFKYeeacsBy9wITg54mmrIRPwPD6uhaKTVB3CZ5VxDPhUyUs1f7uFTPimzX+CP4JYGllLOUpqYhybad7XJuB0cyRnfyNRbeUojilpJt/aU=
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

1. _TIF_SECCOMP: Seccomp filtering (__secure_computing()) only runs
  on entry. There is no seccomp callback for syscall exit.

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
loop behaviors without breaking debugger expectations.

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
index 6de1fe281d61..5dd94bece929 100644
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
 			syscall_exit_to_user_mode_work(regs);
 		return;
 	}
-- 
2.34.1


