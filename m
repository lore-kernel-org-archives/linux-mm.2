Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDECCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174006B0098; Wed, 27 May 2026 07:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124DA6B009B; Wed, 27 May 2026 07:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014016B009F; Wed, 27 May 2026 07:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4AAD6B0098
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:35:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 840EC120485
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:35:38 +0000 (UTC)
X-FDA: 84812994756.12.F471E3C
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 324D44000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:35:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ucMAHRXi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljP6BEZRfa2JICSJhYIpT1vvboqfLa/iWqpeXBqZPPE=;
	b=SquPhcu4nhkGUWRIsZFfwV1v2R6Bo+XpWEkPYb9M187XC9BooI63WYvNvcNT9vylt9c7N6
	5FASPjCMPniAs4vTgxce6awOFyD/fRipAFw6T1uEG48phAQcOI6Z5gVer29VE9ueLa1Wgs
	sTzYVA9Q6mUI5cW9DjX87VXaNu/lYgM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ucMAHRXi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881736; a=rsa-sha256;
	cv=none;
	b=OaQO4Ftz8CRHBvy+EaDCfJ+oKOVKjVTdbOquCEiI60400mlwVz0hQqQVqqqCHfRrOPvS4V
	OwNVIZhqgyNFIB1vy1LGExG3xSPROxhdftfcNCqoCaglFEEdBI5jpt10NeCm9T1nso1AmC
	7RPYXiWBBP2yLwHIHhZk8ZfqFNXm+7Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779881732; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ljP6BEZRfa2JICSJhYIpT1vvboqfLa/iWqpeXBqZPPE=;
	b=ucMAHRXixxfSBSaodMCzJ986D059faLdvpem7GLzA32S7ycNmXxSvgIMyiK50645RnRDFGYvTg/AFVJvbYSmZDMOi+CEDiOWrdAPQ/X0Iq1u+vZPwTx4YAkVf3d2Mx1IIUus2UWq3LtSPkFTn3CDDAdEejdRZJl/UEWEMW4OsT0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3jdQYC_1779881729;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jdQYC_1779881729 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 19:35:30 +0800
Message-ID: <056610fa-0dcc-46e9-a0b4-7c72067437ae@linux.alibaba.com>
Date: Wed, 27 May 2026 19:35:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 3/8] arm64: add support for ARCH_HAS_COPY_MC
To: Ruidong Tian <tianruidong@linux.alibaba.com>, catalin.marinas@arm.com,
 will@kernel.org, rafael@kernel.org, tony.luck@intel.com,
 guohanjun@huawei.com, mchehab@kernel.org, tongtiangen@huawei.com,
 james.morse@arm.com, robin.murphy@arm.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
 <20260518084956.2538442-4-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-4-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 324D44000F
X-Stat-Signature: u9oiicrpjkjpi1i7jt643h5j3gxz61gs
X-Rspam-User: 
X-HE-Tag: 1779881734-514190
X-HE-Meta: U2FsdGVkX1+JkdDlEWkbplweaVvtooUXL9WZ3VqgyIbqTjYM517taI5LW63/8sCpM6tcjVcUN0NBLsZc+kkDWhJlk34iIlidSoIX/ob803lmdqPtTZg3EbXdlJBti9gMzETp4cWWOVmM4JUIV/5PDjsMexIGaC3toO9XUGT6KaH6lG7oLUpTRRjiMcqb/ua7F/dMgVxF2kpYyoqKhAr/aqqxUuq8h0xhdq9KpQzQfVvkz1qKZuq2lY0UjUvg3cwgS9EW2cxIbnNNEIUiVn41pKp1hX6S/+kk18EgGPik4a0ToCaPK9+HEDmJ8rgaki7Y1Ozp8g5zfahmkP4st8ujSxWWaSYgg7eeZirOevwhwC0w8LVjGX6/hEZ22DaJgLaRbLl1tlgmwDV0OHnFCZJ8tatG6fXvYOlA25sHXwmsz+NEdhWPdhMnrvCnX/HtQaEWgXABMH2nzO2y6DvS46deub5vdvaT5UcBA2WNtCluDSEHP6nhcNK/id1otytfiw61IL4cxVVBKfFW3YmYi0Jus6JEapCdTEG/8mLLfmSHOk1r2iFJ4T80uNa7/jamVWm/knp+woYViPdgbR7GqXPjf3cVCqAcTEm5A1dATjNr6dU8Y6fFfP2YJFe5RsMPEf/sku5yb1sqHHpX7Qh7y1AEjTLCe8IXeNYBM5oLrm4zrpccd/+qqN8IFjoAldT4RZ0+vquP7Xw9uVe6IeSbMP5oooVKIrudip2OHqE5FS+F4hFIayu0ltJylBZTPHQ0URgRwjqGNCs60fvzsOrVkPgPO/KdzBMBWXnOqLVcPLLQ8XxAGseBBy7ws7wpMendbuJn/9lKc3w9G3DN7ILtkhVf9V1+uKsrALPSrvR8WE2CnfF1YJlaWI9qXnks/51uziDe8uXM00jbbj41Me/ZHfwwoGSXJFtDfjPjdoPhHTDnsvxfg261d4zrnIaVFNtrTNyeY4WuUB85x7TR8VgI/7U
 PJV5Tu17
 2clCEvABNY6mdutqkYX0L2Vrhv7/U1av+FU65fq5wV4n60GZr0AWBd4AHXufAEONYyui+t4D0bFtKd9F7iCadCcpu2Mpot+OWlVOlyYbimYSn+jc5DDB8D+RC/YLukLfDqaC+UWqZ2ghel2noUuhigAZxAb0v011naemmwcG9tVlgcrArm0RWb7e9Wcq7wZT87KW0sKFwsjpXTxxsgkMwmnhMc0hYgg/G1bse2GzLUnTqHtcs0SqNLg41IOGJNbscZI+lL+2TcJxmTnPm85VDH1RBrxso/wO/Igs9e5lRfodxp9C9li/ILvu+/TnG62rjyt5G+SVrjecnQHhp0kms42atfNIox9F0Iki44MwbMMy2jCedbJrhk6n+CdinkV0TC1pceUetFiYOcL0CY+NKO2fpkVGYMd3LhKhqtU4W1J2g7MsAYf8I/Rmxtvjfxxqb3bi5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> From: Tong Tiangen <tongtiangen@huawei.com>
> 
> For the arm64 kernel, when it processes hardware memory errors for
> synchronize notifications(do_sea()), if the errors is consumed within the
> kernel, the current processing is panic. However, it is not optimal.
> 
> Take copy_from/to_user for example, If ld* triggers a memory error, even in
> kernel mode, only the associated process is affected. Killing the user
> process and isolating the corrupt page is a better choice.
> 
> Add new fixup type EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR to identify insn
> that can recover from memory errors triggered by access to kernel memory,
> and this fixup type is used in __arch_copy_to_user(), This make the regular
> copy_to_user() will handle kernel memory errors.
> 
> [Ruidong: handle EX_TYPE_UACCESS_CPY in fixup_exception_me()]
> 
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
> ---
>   arch/arm64/Kconfig                   |  1 +
>   arch/arm64/include/asm/asm-extable.h | 22 +++++++++++++++++++-
>   arch/arm64/include/asm/asm-uaccess.h |  4 ++++
>   arch/arm64/include/asm/extable.h     |  1 +
>   arch/arm64/lib/copy_to_user.S        | 10 +++++-----
>   arch/arm64/mm/extable.c              | 21 +++++++++++++++++++
>   arch/arm64/mm/fault.c                | 30 ++++++++++++++++++++--------
>   7 files changed, 75 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fe60738e5943..831b20d45893 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -21,6 +21,7 @@ config ARM64
>   	select ARCH_HAS_CACHE_LINE_SIZE
>   	select ARCH_HAS_CC_PLATFORM
>   	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> +	select ARCH_HAS_COPY_MC if ACPI_APEI_GHES


At this commit:

   - arch/arm64/lib/memcpy_mc.S does not exist (patch 7)
   - arch/arm64/lib/copy_mc_page.S does not exist (patch 5)
   - arm64 has no copy_mc_to_kernel() override
   - __HAVE_ARCH_COPY_MC_USER_HIGHPAGE is not defined

Build does not break because the generic fallback in
include/linux/uaccess.h and include/linux/highmem.h covers it, but
ARCH_HAS_COPY_MC=y silently means "plain memcpy() with no MC
handling at all" between this commit and patch 7. Anyone bisecting
an MC regression in this window will be very confused.

Please move this select to the last arm64 implementation patch in
the series.


>   	select ARCH_HAS_CURRENT_STACK_POINTER
>   	select ARCH_HAS_DEBUG_VIRTUAL
>   	select ARCH_HAS_DEBUG_VM_PGTABLE
> diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
> index d67e2fdd1aee..4980023f2fbd 100644
> --- a/arch/arm64/include/asm/asm-extable.h
> +++ b/arch/arm64/include/asm/asm-extable.h
> @@ -11,6 +11,8 @@
>   #define EX_TYPE_KACCESS_ERR_ZERO	3
>   #define EX_TYPE_UACCESS_CPY		4
>   #define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	5
> +/* kernel access memory error safe */
> +#define EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR	6

KACCESS_ERR_ZERO is already "encode err reg + zero reg". Tacking
_MEM_ERR on the end reads like "+ another mem-err reg". Please
rename to e.g. EX_TYPE_KACCESS_ERR_ZERO_MC, which directly tells
the reader "MC-safe variant of KACCESS_ERR_ZERO".

>   
>   /* Data fields for EX_TYPE_UACCESS_ERR_ZERO */
>   #define EX_DATA_REG_ERR_SHIFT	0
> @@ -42,7 +44,7 @@
>   	(.L__gpr_num_##gpr << EX_DATA_REG_##reg##_SHIFT)
>   
>   #define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)		\
> -	__ASM_EXTABLE_RAW(insn, fixup, 					\
> +	__ASM_EXTABLE_RAW(insn, fixup,					\
>   			  EX_TYPE_UACCESS_ERR_ZERO,			\
>   			  (						\
>   			    EX_DATA_REG(ERR, err) |			\
> @@ -55,6 +57,17 @@
>   #define _ASM_EXTABLE_UACCESS(insn, fixup)				\
>   	_ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, wzr, wzr)
>   
> +#define _ASM_EXTABLE_KACCESS_ERR_ZERO_MEM_ERR(insn, fixup, err, zero)	\
> +	__ASM_EXTABLE_RAW(insn, fixup,					\
> +			  EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR,		\
> +			  (						\
> +			    EX_DATA_REG(ERR, err) |			\
> +			    EX_DATA_REG(ZERO, zero)			\
> +			  ))
> +
> +#define _ASM_EXTABLE_KACCESS_MEM_ERR(insn, fixup)			\
> +	_ASM_EXTABLE_KACCESS_ERR_ZERO_MEM_ERR(insn, fixup, wzr, wzr)
> +
>   /*
>    * Create an exception table entry for uaccess `insn`, which will branch to `fixup`
>    * when an unhandled fault is taken.
> @@ -76,6 +89,13 @@
>   	.macro		_asm_extable_uaccess_cpy, insn, fixup, uaccess_is_write
>   	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_UACCESS_CPY, \uaccess_is_write)
>   	.endm
> +/*
> + * Create an exception table entry for kaccess `insn`, which will branch to
> + * `fixup` when an unhandled fault is taken.
> + */
> +	.macro          _asm_extable_kaccess_mem_err, insn, fixup
> +	_ASM_EXTABLE_KACCESS_MEM_ERR(\insn, \fixup)
> +	.endm
>   
>   #else /* __ASSEMBLER__ */
>   
> diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
> index 12aa6a283249..c8f0af5fde63 100644
> --- a/arch/arm64/include/asm/asm-uaccess.h
> +++ b/arch/arm64/include/asm/asm-uaccess.h
> @@ -57,6 +57,10 @@ alternative_else_nop_endif
>   	.endm
>   #endif
>   
> +#define KERNEL_MEM_ERR(l, x...)			\
> +9999:	x;					\
> +	_asm_extable_kaccess_mem_err	9999b, l
> +
>   #define USER(l, x...)				\
>   9999:	x;					\
>   	_asm_extable_uaccess	9999b, l
> diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
> index 9dc39612bdf5..47c851d7df4f 100644
> --- a/arch/arm64/include/asm/extable.h
> +++ b/arch/arm64/include/asm/extable.h
> @@ -48,4 +48,5 @@ bool ex_handler_bpf(const struct exception_table_entry *ex,
>   #endif /* !CONFIG_BPF_JIT */
>   
>   bool fixup_exception(struct pt_regs *regs, unsigned long esr);
> +bool fixup_exception_me(struct pt_regs *regs);
>   #endif
> diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
> index 819f2e3fc7a9..991d94ecc1a8 100644
> --- a/arch/arm64/lib/copy_to_user.S
> +++ b/arch/arm64/lib/copy_to_user.S
> @@ -20,7 +20,7 @@
>    *	x0 - bytes not copied
>    */
>   	.macro ldrb1 reg, ptr, val
> -	ldrb  \reg, [\ptr], \val
> +	KERNEL_MEM_ERR(9998f, ldrb  \reg, [\ptr], \val)
>   	.endm
>   
>   	.macro strb1 reg, ptr, val
> @@ -28,7 +28,7 @@
>   	.endm
>   
>   	.macro ldrh1 reg, ptr, val
> -	ldrh  \reg, [\ptr], \val
> +	KERNEL_MEM_ERR(9998f, ldrh  \reg, [\ptr], \val)
>   	.endm
>   
>   	.macro strh1 reg, ptr, val
> @@ -36,7 +36,7 @@
>   	.endm
>   
>   	.macro ldr1 reg, ptr, val
> -	ldr \reg, [\ptr], \val
> +	KERNEL_MEM_ERR(9998f, ldr \reg, [\ptr], \val)
>   	.endm
>   
>   	.macro str1 reg, ptr, val
> @@ -44,7 +44,7 @@
>   	.endm
>   
>   	.macro ldp1 reg1, reg2, ptr, val
> -	ldp \reg1, \reg2, [\ptr], \val
> +	KERNEL_MEM_ERR(9998f, ldp \reg1, \reg2, [\ptr], \val)
>   	.endm
>   
>   	.macro stp1 reg1, reg2, ptr, val
> @@ -74,7 +74,7 @@ SYM_FUNC_START(__arch_copy_to_user)
>   9997:	cmp	dst, dstin
>   	b.ne	9998f
>   	// Before being absolutely sure we couldn't copy anything, try harder
> -	ldrb	tmp1w, [srcin]
> +KERNEL_MEM_ERR(9998f, ldrb	tmp1w, [srcin])
>   USER(9998f, sttrb tmp1w, [dst])
>   	add	dst, dst, #1
>   9998:	sub	x0, end, dst			// bytes not copied
> diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
> index 6e0528831cd3..f78ac7e92845 100644
> --- a/arch/arm64/mm/extable.c
> +++ b/arch/arm64/mm/extable.c
> @@ -110,7 +110,28 @@ bool fixup_exception(struct pt_regs *regs, unsigned long esr)
>   		return ex_handler_uaccess_cpy(ex, regs, esr);
>   	case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
>   		return ex_handler_load_unaligned_zeropad(ex, regs);
> +	case EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR:
> +		return false;
>   	}
>   
>   	BUG();
>   }
> +
> +bool fixup_exception_me(struct pt_regs *regs)
> +{
> +	const struct exception_table_entry *ex;
> +
> +	ex = search_exception_tables(instruction_pointer(regs));
> +	if (!ex)
> +		return false;
> +
> +	switch (ex->type) {
> +	case EX_TYPE_UACCESS_CPY:
> +		return ex_handler_uaccess_cpy(ex, regs, 0);

Pointed by sashiko:

    copy_to_user.S annotates its MOPS prologue/main/epilogue with
    USER_CPY(..., 1, cpyf{p,m,e}wt ...), so uaccess_is_write=1 for the
    whole MOPS sequence. With esr=0 hard-coded here:

        cpy_faulted_on_uaccess(): uaccess_is_write=1, fault_on_write=0
                                  -> returns false
        ex_handler_uaccess_cpy()                       -> returns false
        fixup_exception_me()                           -> returns false
        do_apei_claim_sea()                            -> returns -ENOENT
        do_sea()                                       -> panic

    So any MC SEA taken inside a MOPS copy_to_user() panics the kernel,
    exactly defeating the recovery this patch claims to provide.


> +	case EX_TYPE_UACCESS_ERR_ZERO:
> +	case EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR:
> +		return ex_handler_uaccess_err_zero(ex, regs);
> +	}
> +
> +	return false;
> +}
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 0f3c5c7ca054..efbda54770be 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -858,21 +858,35 @@ static int do_bad(unsigned long far, unsigned long esr, struct pt_regs *regs)
>   	return 1; /* "fault" */
>   }
>   
> +/*
> + * APEI claimed this as a firmware-first notification.
> + * Some processing deferred to task_work before ret_to_user().
> + */
> +static int do_apei_claim_sea(struct pt_regs *regs)
> +{
> +	int ret;
> +
> +	ret = apei_claim_sea(regs);
> +	if (ret)
> +		return ret;
> +
> +	if (!user_mode(regs) && IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC)) {

The IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) test is also dead on arm64:
ARCH_HAS_COPY_MC is selected iff ACPI_APEI_GHES, and without
ACPI_APEI_GHES apei_claim_sea() returns -ENOENT and we never reach
this branch. Please drop it.


Thanks.
Shuai

