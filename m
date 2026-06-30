Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59503C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F716B0106; Tue, 30 Jun 2026 11:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06FA6B0109; Tue, 30 Jun 2026 11:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43E56B010B; Tue, 30 Jun 2026 11:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B85866B0106
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:32:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F1CEC2AE7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:32:11 +0000 (UTC)
X-FDA: 84936970062.09.4D653C9
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AC0B1C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:32:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="qu/1s0nH";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=vVSU3b5g;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833529;
	b=yS7O7exrzFwNFUs+ojkUaAaKDESlYxrjXm/orz87V+2eiJP63hFuvaHUJHnOzAtrQOeJmY
	OzV7KqIREG6FBfMLIQ/syhNWjUD7vu2gbZekmt7ik/kgfyR7EnYqiMeIpTIJ7lPGPguIgu
	Gnp0pkT1y2SBhS0od6bq9P5USGa178E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdsRgNbVkI3Xb/bXMSfj+yw5lewzrynD2xqGGnGzV8Y=;
	b=yvPdvlv6KCimHUFctD1HyfEVxvF1Z2R+IUq9lMbdjiJy1D3iKmRxlf8HEVGmxIep8V5m6S
	aTZ+Y4oZT0PJM3KbYV7VMSN7qIkV7Ni+csJRyQ+fYUUGFTBgv9gt5/R+EB5WXJo7c4R5Qy
	JJxkAzOcDXpkX5gjVXtg+yeQzqZMA0U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="qu/1s0nH";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=vVSU3b5g;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Tue, 30 Jun 2026 17:32:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782833526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RdsRgNbVkI3Xb/bXMSfj+yw5lewzrynD2xqGGnGzV8Y=;
	b=qu/1s0nHQC6KFpDGuKrxXJLqBTdl1FoH/4yCYl34ohT2guoTuARwKQEULMNqdYWydigyrj
	UQsxj+D6QvmsMUbHcM7u3rM86IjWKPJT39xqCzzGIvsLgqe2Hz4HBOvbz7iysNXKPy5W/u
	R/GUuEzOAf1ZZdsDdNL4Jr6q/bCrdt9+3kstOwvKETmQg7hIqCfC8XESzPiKTthZJ9Oc09
	xpBcumA8KxG/PCdAqz4l1iGj82SI/tB9ALWL8NP8tofOtWsr179TrHBkKBYCmCED0scKGL
	24UnriDqIvgBJ16vM4xBQFbAgoL54zsV+WuM26JgtD+5w8qeomuxalv2Kqf/NA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782833526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RdsRgNbVkI3Xb/bXMSfj+yw5lewzrynD2xqGGnGzV8Y=;
	b=vVSU3b5gGX9pyXfPgfu3YTbbfDnrmDCkQKRUwm+vxUCIXLFG0mbsTHQglZDx4c5OUPi7Tu
	n00gEBCaZoE4kFBg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com, 
	linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	geert@linux-m68k.org, tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, 
	glaubitz@physik.fu-berlin.de, richard@nod.at, anton.ivanov@cambridgegreys.com, 
	johannes@sipsolutions.net, luto@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	peterz@infradead.org, wad@chromium.org, thuth@redhat.com, mark.rutland@arm.com, 
	ada.coupriediaz@arm.com, kevin.brodsky@arm.com, linusw@kernel.org, yeoreum.yun@arm.com, 
	song@kernel.org, james.morse@arm.com, anshuman.khandual@arm.com, 
	broonie@kernel.org, liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com, 
	austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de, sohil.mehta@intel.com, 
	andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org, x86@kernel.org, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-csky@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
Message-ID: <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130616.642022-19-ruanjinjie@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AC0B1C000C
X-Stat-Signature: fwgasr1tq5hjtrrkpof3f47niepr8a9x
X-HE-Tag: 1782833529-746302
X-HE-Meta: U2FsdGVkX1+zXWT11GRgjHqVCk9GqEhljFukjo4nTmb3MIIaumM6fJnCCvo+LnW8XnNNsG9sFqw6KB5RSVBrTyH5l1030iJOVyBreOy7tAMh4447kBwM6Xo1DEp0cYSvPT+bfSQ3SNKNFbIdxUcB9Zzu1SkMsJ2aUVwkscXe6VZrRRRZEzDjwngtJPTmS5D+g5cRwTMqfwIMuH0D+Pz6L5PZHjgB32Sy/zATK1MqqZMh0qOboKj8TD1V2quzPpbtYwxIzQuVDRJMZyLQLiBI5HzlVw8K0su0QQIjlXsi0xUA+TABD4akFEgadkle7BHwsS0dIqwLuUcadObk1pmIiiQB/VWCCFyAoMEDd9U+ZHum3zacj1S4DqrBKYP9+bNgmPlJcto3AhSmEDukbldgUR5D/yKYe2+DIjAd31yNNHzOrrwytE9FYDkdNiIjxkoz1GI06sBnTockEoFBK3495HNF5Nwhnyp42wDOqmYuorXCmP9xJli5kzwh2sQwGidgLIlMRYNYwyCCHfSsURma0F97+mceGQ1TufPjQBLIgvThAJXrHSmSZLJLOluZNw6YmB9LjiXRDHou0hXah0M4/Oi5DzDW5tRRTTNNXEtY4foLVbm4K598p+4nDptjmGughIaHgmuG2TKiam48O6Fgm4Sn9IcyZ+dnV9pN+CjEq1dZ+rvjDpxu/SX1OAZHuxPOgmLEoq2OCtz5GzjTepAt8oEs8NFULaWdiHlRCcOT7Kl1VvIig7FS1tioaUr6lnStTwamh4nv7TEwvO0oi+NKzH76YdmMPMu0vjRCq8aAD6MKW8M4fV17r4uS1dqzBk6sQwZ0AwFGB+GVXcCGC2oEn/II9neN+RyMIpghQlTn5VVELbFLwH5iKkPimqru+4piNVcjjZWVCFCIYak+e1+bIEz9TtwLcb7tiX+pL0K6+zAakwLmB9M6YEcW62SRGSKyI/3pcPknHHvGrKbCds0
 UoFqrd/x
 n8VLZ7efu2NvnI1GeCY5LPDpKufR83MyaFhF/dl7cF0XD8to8brsTds/WVL0spFsnJhWtg7vhP5cW1j+olQHHfABKt0SA4M3psDCrpvoPCXK1B0oM0OGblYhWT3Yflg+qf7QD2DyDjWPwCdMISMBWTSenBUoSxU9/FqQO+ZukTIHU38gRnsjywek7ZZ4RB9K4Y7nz6xXOJCKMZHp5Hmqcb3oePGh84laJPDCz+oF2CHHQrG/eN/W5lGa67lpqFAYknkkcqkN5D2vR2b+rRhGltTdFLYbOPkV6vUAEdN/81bHVlZ2vjnjTgdBawFeu1+UoJ+ck5INoPYwLz4FefMSnX9EoRaQ8qUKT9SkwHT7tJGTmg3wnGIUCe/Jca6Sl4Fd+M3+unesZzavK4Mt6z/SBeN8llQFmZ7+U0iFWXhRJuz/rhaGa5Na5fA5mwdVBAlbHfyWMMX/KAhdz4FN1ULspgTk12N9RI3BzU6sKyxIic04KQey/fV3mEXN7Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 09:06:16PM +0800, Jinjie Ruan wrote:
> Syscall User Dispatch (SUD) requires the signal trampoline code to not be
> intercepted. This is necessary to support returning with a locked selector
> while avoiding infinite recursion back into the signal handler.
> 
> Implement arch_syscall_is_vdso_sigreturn() for arm64 to support this
> exclusion mechanism. For native 64-bit tasks, it checks whether the current
> PC matches the 'svc #0' instruction inside the vDSO sigreturn trampoline.
> 
> 	SYM_CODE_START(__kernel_rt_sigreturn)
> 	        mov     x8, #__NR_rt_sigreturn
> 	        svc     #0
> 	SYM_CODE_END(__kernel_rt_sigreturn)
> 
> For COMPAT tasks, it verifies if the instruction falls within
> the architecture's 'sigpage' range, allowing the kernel to safely bypass
> dispatching syscalls originating from these areas back to userspace.
> 
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: kemal <kmal@cock.li>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  arch/arm64/include/asm/elf.h |  1 +
>  arch/arm64/kernel/vdso.c     | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
> index d2779d604c7b..f43d4dea916a 100644
> --- a/arch/arm64/include/asm/elf.h
> +++ b/arch/arm64/include/asm/elf.h
> @@ -185,6 +185,7 @@ do {									\
>  struct linux_binprm;
>  extern int arch_setup_additional_pages(struct linux_binprm *bprm,
>  				       int uses_interp);
> +extern bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);

A header for that?

>  /* 1GB of VA */
>  #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index 592dd8668de4..5a0314a3c26e 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>  
>  	return ret;
>  }
> +
> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> +{
> +	unsigned long sigtramp;
> +
> +#ifdef CONFIG_COMPAT
> +	if (is_compat_task()) {
> +		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
> +
> +		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
> +	}
> +#endif
> +	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
> +
> +	return regs->pc == (sigtramp + 8);

Instead of hardcoding 'sigtramp + 8' you could add a new label to the 'svc #0'
instruction and use that with VDSO_SYMBOL().


Thomas

