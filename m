Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB28CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 08:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF516B0005; Thu,  4 Jun 2026 04:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0E06B0088; Thu,  4 Jun 2026 04:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EA76B008A; Thu,  4 Jun 2026 04:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 544836B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:10:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E64B3404CA
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:10:37 +0000 (UTC)
X-FDA: 84841508514.08.4F5EEFF
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E1E3C000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:10:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uZ7Nw1GO;
	spf=pass (imf22.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780560636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P85ckZTk9u8LnBjRMxQ2RWcMT/9mNbK4Xr+1MlYh7A8=;
	b=HV8Rijuo6ONhWKnUg1O0qA58qVi987o7nDK6nfIIsJZykyivTjhRkpvFPnf3nq/ewEO+OG
	XxaMv6d3+wEdbsl1hmkJEnEu2b/mH9siJQz8eciBKdErbwHCrSoRcyQKtrCKfWukkshnrm
	M6B6BCFKw5xl59gBYkzaH1nThVs+wRg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uZ7Nw1GO;
	spf=pass (imf22.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780560636;
	b=4UlS2ycn7sckukRJofYlxmnB0YyBML/8gqxBHv+n7XZQpUUhWRC6DbMVhuRLG5nq5aI9ZM
	P0YflellHTAEe1X5qCGHlEkkIX/hmgCHJiZ9XE0bGbAPFPxvnZYaV0yUN5zlH56DG7QjTa
	7aDSK0lKjhUn7UY/gHKS2oiC5Jr5Ym4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780560629; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=P85ckZTk9u8LnBjRMxQ2RWcMT/9mNbK4Xr+1MlYh7A8=;
	b=uZ7Nw1GOHo7rjGj7mFXXGhuwyikz2RgOPwxCyC1gVGMW3z7QzhXt1qKZcPEfQ/dnny2N6l8eOPug1h4K8zdGo3AmIPWHIon8+UY6RXYXiMvk9eIgJg5K2nqS37zpBehDzuT3Sc3DjQ46oq5zi8A3igZLwH1jLgsU7l0/3NEa018=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X49dg.w_1780560626;
Received: from 30.74.145.98(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X49dg.w_1780560626 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Jun 2026 16:10:27 +0800
Message-ID: <3e6c2559-cc95-4545-83ee-807bbfc1b3e9@linux.alibaba.com>
Date: Thu, 4 Jun 2026 16:10:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 3/8] arm64: add support for ARCH_HAS_COPY_MC
To: Shuai Xue <xueshuai@linux.alibaba.com>, catalin.marinas@arm.com,
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
 <056610fa-0dcc-46e9-a0b4-7c72067437ae@linux.alibaba.com>
From: Ruidong Tian <tianruidong@linux.alibaba.com>
In-Reply-To: <056610fa-0dcc-46e9-a0b4-7c72067437ae@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E1E3C000E
X-Stat-Signature: 69cwis6itsceygn9i3mieqxac6h36ry3
X-Rspam-User: 
X-HE-Tag: 1780560633-333829
X-HE-Meta: U2FsdGVkX1+y3n9uR6t6XH4F6Ye8sYGr5z3EZUeAek7eGHDqZ0OXeR8EUeMb3mRjXvtFjUgyPhy758dswkuLDF8zvc/cE8syMK3Afak2EMeDEFHREwsIm8EhaF6tDY8ZYJxIWhcjtyRip+0W/LEc/0UKW2XuK8MJclUtds0KA66Y3zIAHysIPvn+NDrNpPHJBg3Z88C9YS4wQ+dFYSMLHQjS09sNDKfF3uVqV7ct9Jh5RuE7LGBXAfWLcPrMYZZAwUnbSUnbC1oXgg+3sECict6tnd3hbv+MDUcQkfOv3ZZ+pxlcZDykcJftxJc/YfkjoSjJq9LHXPsob/kH9pmuQpu7bf+GC5Iu7Id+0NWciEGDeVzSKNQPOupyqiZzx26cjS3iUQigswDGzooyn/GepL+2I9rxTq4twhP2dpqiIY3Wy5l6BvwEWAo6QlP1lfkx6BtYjvCoXEvmVnNyW0W7jZQ5KjfsrZm42b13yH9D4MZXO6CbmwiKG3RmTBXt8Zbwy+BB2ucPxuB/7TtdubJ8+hPOx4QMgi0WschCmThFoQu1JyrVGZALVHyRUaE/Utl5ve0y5fOM1a5f0lyUDJybOfLUx058lBmCMNuNp6yxmPpZ5/XGgU5KjNWxFwb+gOPV3w9Lc66KcfGRg/u8aFYlpf03nfPTRsFMeF4otj128MaDSH+QCvwwZaTHKzFzcm7mxK5aXOj0zN/hTzALwMGEGbJvNvXweJxVUF32xWD3tQxOPicOgDeXFRrm9hZazejHDn0LYfTjTZGWuK7nRGrkYhyfn5UvCVq4EmJDj5gb4tNBqIjrMYsAbwpuhtQeGej5/R67qcZUxoFulttH5oB9T4E/0QPKjvsYxWr4SKLHrMRj0tcIa6PmBpaE7UxyZV3XNi5sb4fAzPwQGtn4a2lMPHztig5DEgJIlcQFrcUKxHcnz6yTMpzOQQ5FKJoJE5yMOwCEZ4ninNscZi6Qdj5
 76og2Fxm
 /c11ZrifJfLs/RlfTHI7CraQnIj875wWZ4tvdx3KizeGDcuTeqxfQ3STYrK9S9tQFk+aoF/C2FnUgrA51Qlk+s+6UJPZdUUHzqnBUB5a3mn05OPMCc2CuFc6zQnu9sxBAxF3gcBqfCH72XcLbWzeZ7Gmw6TobWgIsz2Y6C8gsnGmuMNbjyy5xKdlULBWJZbzRuVBlvZZrdEQUrSXM3YTdfqBDT4Y3969pOOmzFUUY5iUTnekp9AfaiOGU0Bx4n3CNII4tqC4T6vg8k0wAdqWClhBp1OMQi6MXzpuY5ejw5eE+cAs+RbRs3W8hkVnIDBN/C5H4PWBYUj/h7xvprDLO6ZlHYhP4Y/wJ/vclMfDzy0gmrVL+FlQadTafvLuGdVwr5JxnC6ORCTVgM16OiqgR+pivtEAcIbL/Bdnkhi7FE8sVKwptfw6JIsUG89WZPI3ZZrecOTif2fG9GU/CPXv3uPOiTl5n+CuUTclR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/27 19:35, Shuai Xue 写道:
> 
> 
> On 5/18/26 4:49 PM, Ruidong Tian wrote:
>> From: Tong Tiangen <tongtiangen@huawei.com>
>>
>> For the arm64 kernel, when it processes hardware memory errors for
>> synchronize notifications(do_sea()), if the errors is consumed within the
>> kernel, the current processing is panic. However, it is not optimal.
>>
>> Take copy_from/to_user for example, If ld* triggers a memory error, 
>> even in
>> kernel mode, only the associated process is affected. Killing the user
>> process and isolating the corrupt page is a better choice.
>>
>> Add new fixup type EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR to identify insn
>> that can recover from memory errors triggered by access to kernel memory,
>> and this fixup type is used in __arch_copy_to_user(), This make the 
>> regular
>> copy_to_user() will handle kernel memory errors.
>>
>> [Ruidong: handle EX_TYPE_UACCESS_CPY in fixup_exception_me()]
>>
>> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
>> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
>> ---
>>   arch/arm64/Kconfig                   |  1 +
>>   arch/arm64/include/asm/asm-extable.h | 22 +++++++++++++++++++-
>>   arch/arm64/include/asm/asm-uaccess.h |  4 ++++
>>   arch/arm64/include/asm/extable.h     |  1 +
>>   arch/arm64/lib/copy_to_user.S        | 10 +++++-----
>>   arch/arm64/mm/extable.c              | 21 +++++++++++++++++++
>>   arch/arm64/mm/fault.c                | 30 ++++++++++++++++++++--------
>>   7 files changed, 75 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index fe60738e5943..831b20d45893 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -21,6 +21,7 @@ config ARM64
>>       select ARCH_HAS_CACHE_LINE_SIZE
>>       select ARCH_HAS_CC_PLATFORM
>>       select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>> +    select ARCH_HAS_COPY_MC if ACPI_APEI_GHES
> 
> 
> At this commit:
> 
>    - arch/arm64/lib/memcpy_mc.S does not exist (patch 7)
>    - arch/arm64/lib/copy_mc_page.S does not exist (patch 5)
>    - arm64 has no copy_mc_to_kernel() override
>    - __HAVE_ARCH_COPY_MC_USER_HIGHPAGE is not defined
> 
> Build does not break because the generic fallback in
> include/linux/uaccess.h and include/linux/highmem.h covers it, but
> ARCH_HAS_COPY_MC=y silently means "plain memcpy() with no MC
> handling at all" between this commit and patch 7. Anyone bisecting
> an MC regression in this window will be very confused.
> 
> Please move this select to the last arm64 implementation patch in
> the series.
> 
> 
>>       select ARCH_HAS_CURRENT_STACK_POINTER
>>       select ARCH_HAS_DEBUG_VIRTUAL
>>       select ARCH_HAS_DEBUG_VM_PGTABLE
>> diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/ 
>> include/asm/asm-extable.h
>> index d67e2fdd1aee..4980023f2fbd 100644
>> --- a/arch/arm64/include/asm/asm-extable.h
>> +++ b/arch/arm64/include/asm/asm-extable.h
>> @@ -11,6 +11,8 @@
>>   #define EX_TYPE_KACCESS_ERR_ZERO    3
>>   #define EX_TYPE_UACCESS_CPY        4
>>   #define EX_TYPE_LOAD_UNALIGNED_ZEROPAD    5
>> +/* kernel access memory error safe */
>> +#define EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR    6
> 
> KACCESS_ERR_ZERO is already "encode err reg + zero reg". Tacking
> _MEM_ERR on the end reads like "+ another mem-err reg". Please
> rename to e.g. EX_TYPE_KACCESS_ERR_ZERO_MC, which directly tells
> the reader "MC-safe variant of KACCESS_ERR_ZERO".

MC is an x86-specific term and may not be appropriate here. I plan to 
rename this to EX_TYPE_KACCESS_SEA (and drop ERR_ZERO, since this case 
does not need it) so it is clear that the current fixup is caused by SEA 
rather than a translation fault.

> 
>>   /* Data fields for EX_TYPE_UACCESS_ERR_ZERO */
>>   #define EX_DATA_REG_ERR_SHIFT    0
>> @@ -42,7 +44,7 @@
>>       (.L__gpr_num_##gpr << EX_DATA_REG_##reg##_SHIFT)
>>   #define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)        \
>> -    __ASM_EXTABLE_RAW(insn, fixup,                     \
>> +    __ASM_EXTABLE_RAW(insn, fixup,                    \
>>                 EX_TYPE_UACCESS_ERR_ZERO,            \
>>                 (                        \
>>                   EX_DATA_REG(ERR, err) |            \
>> @@ -55,6 +57,17 @@
>>   #define _ASM_EXTABLE_UACCESS(insn, fixup)                \
>>       _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, wzr, wzr)
>> +#define _ASM_EXTABLE_KACCESS_ERR_ZERO_MEM_ERR(insn, fixup, err, 
>> zero)    \
>> +    __ASM_EXTABLE_RAW(insn, fixup,                    \
>> +              EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR,        \
>> +              (                        \
>> +                EX_DATA_REG(ERR, err) |            \
>> +                EX_DATA_REG(ZERO, zero)            \
>> +              ))
>> +
>> +#define _ASM_EXTABLE_KACCESS_MEM_ERR(insn, fixup)            \
>> +    _ASM_EXTABLE_KACCESS_ERR_ZERO_MEM_ERR(insn, fixup, wzr, wzr)
>> +
>>   /*
>>    * Create an exception table entry for uaccess `insn`, which will 
>> branch to `fixup`
>>    * when an unhandled fault is taken.
>> @@ -76,6 +89,13 @@
>>       .macro        _asm_extable_uaccess_cpy, insn, fixup, 
>> uaccess_is_write
>>       __ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_UACCESS_CPY, 
>> \uaccess_is_write)
>>       .endm
>> +/*
>> + * Create an exception table entry for kaccess `insn`, which will 
>> branch to
>> + * `fixup` when an unhandled fault is taken.
>> + */
>> +    .macro          _asm_extable_kaccess_mem_err, insn, fixup
>> +    _ASM_EXTABLE_KACCESS_MEM_ERR(\insn, \fixup)
>> +    .endm
>>   #else /* __ASSEMBLER__ */
>> diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/ 
>> include/asm/asm-uaccess.h
>> index 12aa6a283249..c8f0af5fde63 100644
>> --- a/arch/arm64/include/asm/asm-uaccess.h
>> +++ b/arch/arm64/include/asm/asm-uaccess.h
>> @@ -57,6 +57,10 @@ alternative_else_nop_endif
>>       .endm
>>   #endif
>> +#define KERNEL_MEM_ERR(l, x...)            \
>> +9999:    x;                    \
>> +    _asm_extable_kaccess_mem_err    9999b, l
>> +
>>   #define USER(l, x...)                \
>>   9999:    x;                    \
>>       _asm_extable_uaccess    9999b, l
>> diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/ 
>> asm/extable.h
>> index 9dc39612bdf5..47c851d7df4f 100644
>> --- a/arch/arm64/include/asm/extable.h
>> +++ b/arch/arm64/include/asm/extable.h
>> @@ -48,4 +48,5 @@ bool ex_handler_bpf(const struct 
>> exception_table_entry *ex,
>>   #endif /* !CONFIG_BPF_JIT */
>>   bool fixup_exception(struct pt_regs *regs, unsigned long esr);
>> +bool fixup_exception_me(struct pt_regs *regs);
>>   #endif
>> diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/ 
>> copy_to_user.S
>> index 819f2e3fc7a9..991d94ecc1a8 100644
>> --- a/arch/arm64/lib/copy_to_user.S
>> +++ b/arch/arm64/lib/copy_to_user.S
>> @@ -20,7 +20,7 @@
>>    *    x0 - bytes not copied
>>    */
>>       .macro ldrb1 reg, ptr, val
>> -    ldrb  \reg, [\ptr], \val
>> +    KERNEL_MEM_ERR(9998f, ldrb  \reg, [\ptr], \val)
>>       .endm
>>       .macro strb1 reg, ptr, val
>> @@ -28,7 +28,7 @@
>>       .endm
>>       .macro ldrh1 reg, ptr, val
>> -    ldrh  \reg, [\ptr], \val
>> +    KERNEL_MEM_ERR(9998f, ldrh  \reg, [\ptr], \val)
>>       .endm
>>       .macro strh1 reg, ptr, val
>> @@ -36,7 +36,7 @@
>>       .endm
>>       .macro ldr1 reg, ptr, val
>> -    ldr \reg, [\ptr], \val
>> +    KERNEL_MEM_ERR(9998f, ldr \reg, [\ptr], \val)
>>       .endm
>>       .macro str1 reg, ptr, val
>> @@ -44,7 +44,7 @@
>>       .endm
>>       .macro ldp1 reg1, reg2, ptr, val
>> -    ldp \reg1, \reg2, [\ptr], \val
>> +    KERNEL_MEM_ERR(9998f, ldp \reg1, \reg2, [\ptr], \val)
>>       .endm
>>       .macro stp1 reg1, reg2, ptr, val
>> @@ -74,7 +74,7 @@ SYM_FUNC_START(__arch_copy_to_user)
>>   9997:    cmp    dst, dstin
>>       b.ne    9998f
>>       // Before being absolutely sure we couldn't copy anything, try 
>> harder
>> -    ldrb    tmp1w, [srcin]
>> +KERNEL_MEM_ERR(9998f, ldrb    tmp1w, [srcin])
>>   USER(9998f, sttrb tmp1w, [dst])
>>       add    dst, dst, #1
>>   9998:    sub    x0, end, dst            // bytes not copied
>> diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
>> index 6e0528831cd3..f78ac7e92845 100644
>> --- a/arch/arm64/mm/extable.c
>> +++ b/arch/arm64/mm/extable.c
>> @@ -110,7 +110,28 @@ bool fixup_exception(struct pt_regs *regs, 
>> unsigned long esr)
>>           return ex_handler_uaccess_cpy(ex, regs, esr);
>>       case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
>>           return ex_handler_load_unaligned_zeropad(ex, regs);
>> +    case EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR:
>> +        return false;
>>       }
>>       BUG();
>>   }
>> +
>> +bool fixup_exception_me(struct pt_regs *regs)
>> +{
>> +    const struct exception_table_entry *ex;
>> +
>> +    ex = search_exception_tables(instruction_pointer(regs));
>> +    if (!ex)
>> +        return false;
>> +
>> +    switch (ex->type) {
>> +    case EX_TYPE_UACCESS_CPY:
>> +        return ex_handler_uaccess_cpy(ex, regs, 0);
> 
> Pointed by sashiko:
> 
>     copy_to_user.S annotates its MOPS prologue/main/epilogue with
>     USER_CPY(..., 1, cpyf{p,m,e}wt ...), so uaccess_is_write=1 for the
>     whole MOPS sequence. With esr=0 hard-coded here:
> 
>         cpy_faulted_on_uaccess(): uaccess_is_write=1, fault_on_write=0
>                                   -> returns false
>         ex_handler_uaccess_cpy()                       -> returns false
>         fixup_exception_me()                           -> returns false
>         do_apei_claim_sea()                            -> returns -ENOENT
>         do_sea()                                       -> panic
> 
>     So any MC SEA taken inside a MOPS copy_to_user() panics the kernel,
>     exactly defeating the recovery this patch claims to provide.
> 
> 
>> +    case EX_TYPE_UACCESS_ERR_ZERO:
>> +    case EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR:
>> +        return ex_handler_uaccess_err_zero(ex, regs);
>> +    }
>> +
>> +    return false;
>> +}
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 0f3c5c7ca054..efbda54770be 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -858,21 +858,35 @@ static int do_bad(unsigned long far, unsigned 
>> long esr, struct pt_regs *regs)
>>       return 1; /* "fault" */
>>   }
>> +/*
>> + * APEI claimed this as a firmware-first notification.
>> + * Some processing deferred to task_work before ret_to_user().
>> + */
>> +static int do_apei_claim_sea(struct pt_regs *regs)
>> +{
>> +    int ret;
>> +
>> +    ret = apei_claim_sea(regs);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (!user_mode(regs) && IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC)) {
> 
> The IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) test is also dead on arm64:
> ARCH_HAS_COPY_MC is selected iff ACPI_APEI_GHES, and without
> ACPI_APEI_GHES apei_claim_sea() returns -ENOENT and we never reach
> this branch. Please drop it.
> 
> 
> Thanks.
> Shuai


