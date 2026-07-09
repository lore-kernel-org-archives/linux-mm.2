Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C84C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203646B008C; Thu,  9 Jul 2026 04:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB146B0092; Thu,  9 Jul 2026 04:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F15D6B0095; Thu,  9 Jul 2026 04:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E36586B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:28:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87A571C8442
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:28:03 +0000 (UTC)
X-FDA: 84968560446.15.DC37D9A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA17D40002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:28:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UMXxHBpp;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ja1LHTEE;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783585682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lx0GPfIb+p9dvxHOdBuxBw9NKashWf8lY5lGPcZuetQ=;
	b=IG/0D0bL3Z0Hup4T2BQgG6nigQ14eagrbXexTvgj60MCqTVvPntrxBtGlpxBS5340iB0Cs
	ynzkd7DEb0El+XysGH/cE0R7gvfnmtkVTGebgBojyz6ZD7xU48Poer6bdiBfYflxVR4sVi
	naycvcVrcS4e4lXl652ItCWuTRQylSI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UMXxHBpp;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ja1LHTEE;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783585682;
	b=LKRdzzxDfb/vDJoGYENC9c2RFP7SDklx8c0iq56yIV/WARiuIJd2c5hIFWFPogqtTJiV6l
	GI6XRf7UI9Rh2lhL+XzyqoANqtoEdQNXscj8tlvEjH28FpJ6kpdHMM+Gj9y077EhxYoIAj
	wO+lwOkhcsxKGQlURlTGhV1fWv+oeA8=
Date: Thu, 9 Jul 2026 10:27:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783585679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lx0GPfIb+p9dvxHOdBuxBw9NKashWf8lY5lGPcZuetQ=;
	b=UMXxHBppphhTbYxa+BqOd80W4ngqWYhzPYL77GljpeFMyXukW5uGAsLDprtKEJyeETmgFN
	msqYnUBjEJpozd4qRINi/gEyl3eXmF2JPhb5bRF2Yb5RUoZMBkLPEgJNOqb7n5jnrIsz1J
	T/EBLiEGVbgE7kFtiNNGRfmCBxiNT6X9Xm8U+cdKwvRKu4vfD+B+cdupmGQos4JbCaBuBM
	3S2JvvwStqAxmiRXN9m9xk6wUV5Sz8TVKl60PYbK5h/Xqn/t8B/VKJmV+gEAfJXWT5pqum
	3QEumRjVd9w0RwuzH4WlnvukX96IcDYpjIFc4OGRgiDohFmqu7XaFHUL9oUstQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783585679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lx0GPfIb+p9dvxHOdBuxBw9NKashWf8lY5lGPcZuetQ=;
	b=ja1LHTEEnpn4UBUpRMLUNv43JZPCLqwtNJbKK8I1pjYisGl/FUXT1xQeXCjf2brcux0Cb1
	vjeEfDRtTffYYZCQ==
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
Message-ID: <20260709102117-c4dc4d58-f8d9-46b0-8246-61e8fb8825ce@linutronix.de>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
 <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
 <21875fb4-434b-480d-b68b-e2ffd5fff5ae@huawei.com>
 <20260709090525-b1e5ae06-1fb4-454e-919c-6503dcf3d073@linutronix.de>
 <d9c9686c-dfd8-4539-b301-8726bab7443b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9c9686c-dfd8-4539-b301-8726bab7443b@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA17D40002
X-Stat-Signature: xa5xsbuu7he1iemmocb6qmxu1yt39ik3
X-HE-Tag: 1783585681-911339
X-HE-Meta: U2FsdGVkX18Med4eICvscKs1ao/ouE55C0WTbaHo2uWWNatkmmfV1DycOcgg792BkwuiTa0mSf5I6GKdqYFda0ipUov7G9ebwvQFrkR+hty6w2aiaT70UNm416fnA9ZHdl5ad5Vs4BoiC2RXFfGFdeJ1O/RyXJYV9U5N7GriTTsF7LheLM+AfFxxxDjra7wfIGCTMfPkKYq8vJGcd9P53M0kBeDgzWUtu1apE2LzLebhsEzAaTn9N3JdfqxwAsCKcfMEOo8cEqEja2hNg54n46tYQJ1A/E3o0gbd4JhGdTsbAjxKbCeFgso3c8FEYHnZbYDjFg2Sn3vd+45QOJiz26Rm057svCew1HNkNUm40DWN1K8tWmm+72C7ZM986/n06E4dF9xjZ7YToVBVJyP9OOA0fG83GKT7vn0OYp6wPWVz2beVbGLlpUBmb61Ds8HXJgXnDoYxCH/s4NoZHDrI/3w+eL/ili0I0PIDsbhbWcCl5ANjfLSl2Oc62XdP5GCSAc7GmKYVC+/30jpUOryjRiyuUKLkGflayESah4Qc+nni87g/XYVDjtf8O2XNfALJoVWDKNLVk4DqgdJLMXM/XB9Rx5GBcjkZCrEHUar4nhgelcM3dFGEx3fKf0jBYRIXXlkaItQR+gO8f3OuvA26wDO2soVr53Jhp7RmzvFExwgjVJCNfhM2x8Uk8szZtfpmMEbsg7njY4pr4IK7kA4sOK4SlLdvyPJ+e8giFnUyODtwv4512sQj2CHI1fGa6HruwxQ3L5IMhG3hNK2R8Ah7xL5ynw8BGlkqnupDZtaQkwYqsccN1w8wxqTe7uWhsUHyyKi+ABuoaEzAOsZ+7a9Gd7WZDJ/ad1Y2ZaXJiA0tWRTgD6cdjnWnxRRU7OVqI6bFi223TydgMYKe81GaG0ISqpz0Mkf5052Yiv6TCCJ1gmfz9GoHvA2z9B12SlJqacS5GZvvgO+UrEzWRHj62H/
 t6G17vrU
 v8hC8vxdQLSdPFsqRxBJ7ac5OaCvlPQop7RINFsZitym+YJGTYbSfSpauk18EGzIDl3uvy6lnByCphIdYfFvLtqzcNwOQuJIFy0raw5M8zA0E5FW0fo3v3s3YPV5/aK5AVOTa06oSuYS8ueRmTMoeJf8hPRXTVqEkxKlTvBhixuDW0pRIeU2d9KaPP4Di5MsotnDnQYPhAVrj8MBcAdOVcNYmGR7I0qGKDil4+L5Aht83YfNpjX8XPq+DCyH8DpaYPJ3B7SEV7qg4GshzTNPKMcak8aWMvprvWfp+Mo40VAl99E81Fl01MTeUsyLORucnYRJBAY3ZhgCHvqpvyCjtO7J7mqMxe4QD4gx4ieaBljfynsLMacSDWD5hKCmu4g60qli9c8P3WpnQWXBdrLRqEsI8KULvHD9laSV1VFXdzureQDhQohJFnN56fp6kdGxIv5+LZWhjxKqMLJ3qpbOtIo8kzo1lCcjcJloSAgmR4/L25eDsFDxD2IwwpEfynG07N5eI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:15:15PM +0800, Jinjie Ruan wrote:
> On 7/9/2026 3:17 PM, Thomas Weißschuh wrote:
> > On Thu, Jul 09, 2026 at 02:37:05PM +0800, Jinjie Ruan wrote:
> >> On 6/30/2026 11:32 PM, Thomas Weißschuh wrote:
> >>> On Mon, Jun 29, 2026 at 09:06:16PM +0800, Jinjie Ruan wrote:
> > (..)
> > 
> >>>> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> >>>> index 592dd8668de4..5a0314a3c26e 100644
> >>>> --- a/arch/arm64/kernel/vdso.c
> >>>> +++ b/arch/arm64/kernel/vdso.c
> >>>> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
> >>>>  
> >>>>  	return ret;
> >>>>  }
> >>>> +
> >>>> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> >>>> +{
> >>>> +	unsigned long sigtramp;
> >>>> +
> >>>> +#ifdef CONFIG_COMPAT
> >>>> +	if (is_compat_task()) {
> >>>> +		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
> >>>> +
> >>>> +		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
> >>>> +	}
> >>>> +#endif
> >>>> +	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
> >>>> +
> >>>> +	return regs->pc == (sigtramp + 8);
> >>>
> >>> Instead of hardcoding 'sigtramp + 8' you could add a new label to the 'svc #0'
> >>> instruction and use that with VDSO_SYMBOL().
> >>
> >> It seems that the modification of __kernel_rt_sigreturn() is not recommended
> > 
> > For the changes to the object code of the function this is obvious and
> > well explained in the comments.
> > 
> > Such a label however would not change the object code of the function.
> > In fact it would not change any bit whatsoever in the final vDSO,
> > save for a new build ID.
> 
> Yes, and using labels is easier to maintain than hardcoding offsets
> directly.
> 
> Similar to the code below?

Exactly.

(...)

> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index 592dd8668de4..609d7bcd8308 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm
> *bprm, int uses_interp)
> 
>         return ret;
>  }
> +
> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> +{
> +       unsigned long sigtramp;

Could be named better now.

> +#ifdef CONFIG_COMPAT
> +       if (is_compat_task()) {
> +               unsigned long sigpage = (unsigned
> long)current->mm->context.sigpage;
> +
> +               return regs->pc >= sigpage && regs->pc < (sigpage +
> PAGE_SIZE);
> +       }
> +#endif
> +       sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso,
> sigreturn_landing_pad);
> +
> +       return regs->pc == sigtramp;
> +}
> diff --git a/arch/arm64/kernel/vdso/sigreturn.S
> b/arch/arm64/kernel/vdso/sigreturn.S
> index 0e18729abc3b..8d2d413ff45e 100644
> --- a/arch/arm64/kernel/vdso/sigreturn.S
> +++ b/arch/arm64/kernel/vdso/sigreturn.S
> @@ -73,6 +73,7 @@ SYM_CODE_START(__kernel_rt_sigreturn)
>         mov     x8, #__NR_rt_sigreturn
>  //     PLEASE DO NOT MODIFY
>         svc     #0
> +       SYM_INNER_LABEL(__sigreturn_landing_pad, SYM_L_GLOBAL)
>  //     PLEASE DO NOT MODIFY
>  //     .cfi_endproc
>  SYM_CODE_END(__kernel_rt_sigreturn)
> diff --git a/arch/arm64/kernel/vdso/vdso.lds.S
> b/arch/arm64/kernel/vdso/vdso.lds.S
> index 52314be29191..5fee2927e4c5 100644
> --- a/arch/arm64/kernel/vdso/vdso.lds.S
> +++ b/arch/arm64/kernel/vdso/vdso.lds.S
> @@ -104,6 +104,7 @@ VERSION
>                 __kernel_clock_gettime;
>                 __kernel_clock_getres;
>                 __kernel_getrandom;
> +               __sigreturn_landing_pad;

This should not be done. The symbol is not intended to be used by userspace.

>         local: *;
>         };
>  }
> @@ -112,3 +113,4 @@ VERSION
>   * Make the sigreturn code visible to the kernel.
>   */
>  VDSO_sigtramp          = __kernel_rt_sigreturn;
> +VDSO_sigreturn_landing_pad     = __sigreturn_landing_pad;

