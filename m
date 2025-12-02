Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A7FD116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 13:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6F56B000E; Tue,  2 Dec 2025 08:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677A16B0010; Tue,  2 Dec 2025 08:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4816B0012; Tue,  2 Dec 2025 08:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5676B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:03:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55491C014C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:03:31 +0000 (UTC)
X-FDA: 84174547422.11.907D4D9
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id 01E54160020
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:03:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lt78+yZY;
	spf=pass (imf08.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764680609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW6anQe+oLE0EKfJdPntunSgyOR4oOu5YRcRbL0hNo8=;
	b=b+sMyEe8sYbAfxUqd73l/l0Vf3FmOJO7jwekNI8obg/ch+RiPDvtGvLeeCAJKj2qVEvH33
	hRsOPcshMmblwmacNgmUXOh8IYIX14wRJDPHe7QS+hwMFQY3l8w1UM6t7CfRG7zk4dG5HG
	Jc9Ht/pSNiet5+ht0LdQX8bYhkO/09c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764680609; a=rsa-sha256;
	cv=none;
	b=hBKOXG1fzXHxlwusWrCb3yLWGSHV0vWftKArtDmFUXtUF6gRCiy/h9nTJ218QBWP1oAcZy
	KkrvTPw3idHHItLce/j9yEjrLtXcpcmv8BgtkfcXGtpqX3QJSsWmNuE3DfkntPh+1er675
	4KbiBohBLmUb6U+ucd+I1tU8hhm1sb0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lt78+yZY;
	spf=pass (imf08.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aW6anQe+oLE0EKfJdPntunSgyOR4oOu5YRcRbL0hNo8=;
	b=lt78+yZYRHvYg5avVm+Rhd87KT9ImxmJ017DGVZpVir/urktGskUe7450cajX2iW46QJ3RNyW
	cog1/A/drM91gD8GLIy8N+QLuAdv6CUpUku1rFEaa0CilArBvwSuIIPUbeCVZ/D9RA76RXxmoc0
	5+uhZv1fpfUSWEfTIc1yEVk=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dLLVW0qkqzcb07;
	Tue,  2 Dec 2025 21:00:51 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AE79180B36;
	Tue,  2 Dec 2025 21:03:17 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 21:03:16 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <torvalds@linux-foundation.org>,
	<wangkefeng.wang@huawei.com>, <will@kernel.org>, <wozizhi@huaweicloud.com>,
	<xieyuanbin1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Tue, 2 Dec 2025 21:02:24 +0800
Message-ID: <20251202130224.16376-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aS7e9CbQXS27sGcd@shell.armlinux.org.uk>
References: <aS7e9CbQXS27sGcd@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01E54160020
X-Stat-Signature: 4rgwkebd6hazjcbd1h76sjxs7k1a3jww
X-HE-Tag: 1764680606-873650
X-HE-Meta: U2FsdGVkX1+eELaIHqCwNSMuDwMhGqK+BxG+oACCRUAy/5s2DcbnLHNfDmJhdsqa5QTK9YII8ueL9WVgh+Lb8wU4Uzr9JAyU/p8upSGf71HJ3qwVRHlnc9oIbsGJLINiCkx55xcSaL3v0CjFBHG7gDdYopXGUeeHDY0jfQasfVcNRClNY927S4umHx3EXQOsMDUbPtP/qGGfc9k6dkM+Mo4md0L7LlvYJFwppQ+Nmw4Y6HFqU+EUZwmyucdLs0Pifh/2iJ8/B2SHrep3rv/yAnyRhfDdMGIo8T1yk+0ShYfPZQ+h3qCQwDCTQH58/lIzV94kFe4Q0mimAbBYUYjHQoH+TVlaI05HfDkzP5wSek2n8b5y5pkok5TKcYn08YYzVSvpP/4zb5EsmCokF0HWsdS1jlD1QQlw8+tjCngHCoicTu4wrMHQTazpJb5s18htwBioU+ZPNe9Aw8BpqP9E2zMdQe2/wsk3aJZqcb8w9Gszr9WkLLZ62v0SsU/LwS3pQcNxBxvSxa8PG3taQjWfJ2tiziCkWmMcGpxnbhjeK/5HiQ9SG7VLRXN91I+QfMjCRQOKLa5fsAOtMc9tQH+U9MAjTBvhJXYBkwwp+UYN91DCGDkRxZK8hn2Aq8idg4DVjWnmtHY6mwFb/0RoFfYgdkTohGg3h+T0sprpY0vv9GkvFvNtN9lZ0xaIlRBWTxn5+B3ywnKfO1bob4zqhUeBmaiwflLriv6DxxZycHPS3wJYqOs2NRtGMbY6xPs1rp4vAptwgsuQ3Zqr2x1K3gbjXF1nfPO4sKjqJ+AA/XhWNFfGij4kydllldC7kx96MNhQIC9ZSfU5rD3LuF1/J14WKVR2AX1EEdl0EzgNIbl2CNIGFh6HsgL+aGx6BlcdH5saJDt0z2SG2XunTFoFlFNiH9PLOLbYJEZpZXSfAgaf8SrZWpSNbfYC9wQvZ4wPc7q3IzsGUe4qvS3i+CY8vuZ
 WXXPpW/2
 si7FcYXg20IPM0m1j8wtt+jwyx7PmxyzwZxxxOkcxZ5ys1uuZ4V62kSx8aW/ubCrvpXuGP+jPvPuyf/2xAYxTqrA7ws50Ldo4ekseBuLNGQnXtBUzqQ6Rzj/XQWlINhCVtAkK8HNvsKUPHcd0Lh5ZuZMT79GlLVP4G4YrIk4qze5oI/FxZvGx8ucxVJ3vf0ckFbxI00oweTo/6pKOD7rALtfMDcTz6ojfWVyOBbiCV2yapZmZ+rd49GZQskgLn8QEkCfhoStnrP3T0BREC0Mu/bLrh+2OXWwJsvyQnIsiRvihmuy8s+Ka/EYebQANOK98oBPx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Dec 2025 12:43:32 +0000, Russell King (Oracle) wrote:
> We have another issue in the code - which has the branch predictor
> hardening for spectre issues, which can be called with interrupts
> enabled, causing a kernel warning - obviously not good.
>
> There's another issue which PREEMPT_RT has picked up on - which is
> that delivering signals via __do_user_fault() with interrupts disabled
> causes spinlocks (which can sleep on PREEMPT_RT) to warn.
>
> What I'm thinking is to address both of these by handling kernel space
> page faults (which will be permission or PTE-not-present) separately
> (not even build tested):
>
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 2bc828a1940c..972bce697c6c 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -175,7 +175,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
>
>  /*
>   * Something tried to access memory that isn't in our memory map..
> - * User mode accesses just cause a SIGSEGV
> + * User mode accesses just cause a SIGSEGV. Ensure interrupts are enabled
> + * here, which is safe as the fault being handled is from userspace.
>   */
>  static void
>  __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
> @@ -183,8 +184,7 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>  {
>  	struct task_struct *tsk = current;
> 
> -	if (addr > TASK_SIZE)
> -		harden_branch_predictor();
> +	local_irq_enable();
>
>  #ifdef CONFIG_DEBUG_USER
>  	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
> @@ -259,6 +259,38 @@ static inline bool ttbr0_usermode_access_allowed(struct pt_regs *regs)
>  }
>  #endif
>
> +static int __kprobes
> +do_kernel_address_page_fault(unsigned long addr, unsigned int fsr,
> +			     struct pt_regs *regs)
> +{
> +	if (user_mode(regs)) {
> +		/*
> +		 * Fault from user mode for a kernel space address. User mode
> +		 * should not be faulting in kernel space, which includes the
> +		 * vector/khelper page. Handle the Spectre issues while
> +		 * interrupts are still disabled, then send a SIGSEGV. Note
> +		 * that __do_user_fault() will enable interrupts.
> +		 */
> +		harden_branch_predictor();
> +		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
> +	} else {
> +		/*
> +		 * Fault from kernel mode. Enable interrupts if they were
> +		 * enabled in the parent context. Section (upper page table)
> +		 * translation faults are handled via do_translation_fault(),
> +		 * so we will only get here for a non-present kernel space
> +		 * PTE or kernel space permission fault. Both of these should
> +		 * not happen.
> +		 */
> +		if (interrupts_enabled(regs))
> +			local_irq_enable();
> +
> +		__do_kernel_fault(mm, addr, fsr, regs);
> +	}
> +
> +	return 0;
> +}
> +
>  static int __kprobes
>  do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  {
> @@ -272,6 +304,8 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	if (kprobe_page_fault(regs, fsr))
>  		return 0;
>
> +	if (addr >= TASK_SIZE)
> +		return do_kernel_address_page_fault(addr, fsr, regs);
>
>  	/* Enable interrupts if they were enabled in the parent context. */
>  	if (interrupts_enabled(regs))
>
> ... and I think there was a bug in the branch predictor handling -
> addr == TASK_SIZE should have been included.
>
> Does this look sensible?

Hi, Russell King!

This patch removes
```c
	if (addr > TASK_SIZE)
		harden_branch_predictor();
```
from do_user_fault(), and adds it to do_page_fault()->
do_kernel_address_page_fault().

However, do_user_fault() is not only called by do_page_fault(). It is
also called by do_bad_area(), do_sect_fault() and do_translation_fault().
I am not sure that if this will lead to some missing
harden_branch_predictor() mitigation.

What about something like this:
```patch
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..5c58072d8235 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -270,10 +270,15 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	vm_flags_t vm_flags = VM_ACCESS_FLAGS;

 	if (kprobe_page_fault(regs, fsr))
 		return 0;

+	if (unlikely(addr >= TASK_SIZE)) {
+		fault = 0;
+		code = SEGV_MAPERR;
+		goto bad_area;
+	}

 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
 		local_irq_enable();
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 5c58072d8235..f8ee1854c854 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -184,10 +184,13 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 	struct task_struct *tsk = current;
 
 	if (addr > TASK_SIZE)
 		harden_branch_predictor();
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_enable();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
 		pr_err("8<--- cut here ---\n");
 		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
```

Thanks very much!

Xie Yuanbin

