Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1338E74ADE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF6C6B0005; Wed, 24 Dec 2025 02:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7E06B0088; Wed, 24 Dec 2025 02:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE73A6B0099; Wed, 24 Dec 2025 02:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAE9E6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:49:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACC28133F4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:49:30 +0000 (UTC)
X-FDA: 84253589700.30.9504826
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AB561A000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:49:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CGbaVs09;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562568; a=rsa-sha256;
	cv=none;
	b=Z6pe1L8ZL9pAO6jO/D/MPI2fHb+A3o481hnh+rESNhiNKLnKkHuKwKnQN672CZ0VQVAiaU
	1fuzggNgFwa8OnmaUdk2pRohbTlltrOoi6//0TbTholgNkLshOFDRzWldHFepyxZjwTOjf
	TPxDPR62vt7WcjcZNv1uCIG8SFIGHF4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CGbaVs09;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0/Sg9vEcVPykAL4iwpmTNn0DtmSkFDaeo8PJsZs1/M=;
	b=TU2RseYykcY5D67Bj5py8jNTq1MazIzKC4fUJwuF7jl/NqehQZDNdoXf+g67wfzDcpB2B0
	u3MoMP87i5pTb6qV8PbaLoezG3AtxkyAkl6jDfGPL4PqPNTY+77W3Ov4LoVQJlPv4iy9Gj
	8IJB5RSegx5RavSSTS813o3QgRDBgLk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766562564; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=h0/Sg9vEcVPykAL4iwpmTNn0DtmSkFDaeo8PJsZs1/M=;
	b=CGbaVs09K2AqzUrE1mpWGcjItOfE9O35lYvYtCAI5o97lFvSPvAyq3MLgoRQ9Ae6oereBiXsfWssLGjYzKUaHPBI6jsH3gS04t8gFzUlfyZ/WmZsN37nMq1kVa+6dE8l4PblyTnLMX84qffPy2/RFc9QE8TVLP4QvoETph0oIE8=
Received: from 30.221.132.102(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0WvaN3qJ_1766562562 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Dec 2025 15:49:23 +0800
Message-ID: <db72933f-cda7-4196-8e54-73cbefbf1a26@linux.alibaba.com>
Date: Wed, 24 Dec 2025 15:49:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/5] arm64: add support for ARCH_HAS_COPY_MC
To: Tong Tiangen <tongtiangen@huawei.com>, Mark Rutland
 <mark.rutland@arm.com>, Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, James Morse
 <james.morse@arm.com>, Robin Murphy <robin.murphy@arm.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, wangkefeng.wang@huawei.com,
 Guohanjun <guohanjun@huawei.com>
References: <20241209024257.3618492-1-tongtiangen@huawei.com>
 <20241209024257.3618492-3-tongtiangen@huawei.com>
From: Ruidong Tian <tianruidong@linux.alibaba.com>
In-Reply-To: <20241209024257.3618492-3-tongtiangen@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3AB561A000B
X-Stat-Signature: h6yt8g5o4ma4noc74woprzr7wcdo67s5
X-Rspam-User: 
X-HE-Tag: 1766562566-593450
X-HE-Meta: U2FsdGVkX18FF/htIBLTFTa09DA+1kWvftEp0I7aGoESIrIhyxONI42bLBrU6NRwi/1uMasrdQZj6y9tCN7m4ey1wi8YINyJPbvzXEArYZh3SxyfmFijI7Kr1YZ+PhKFpSLEp2r6VD/3AGxMrspgSpobbA+s3JlA3K0tsTV8opZws1uvJ3r/WJAwRS5n7SuMbTOfsPbeIUe11DyW707GBYtKkzMhJwr+rfyZN8xNILjp+LcyZlN3kURFiexqj5vw6nBQXes6DhjDD31hjI8fRBqP1sDcgTH82XfuGjrULxZAhv6z28uPBVcSAbDO263j4aTWcX3ne1p/qzBaxusf7LsIp4X2WiJlNeXQFgqjWptdWwEIjNBJqfDCVzlRDZRqL1KqO9lOlolZ8ssSrxpHB6vOYrNxwlm55BpYVv5K/s9u9liYReoLLybnu/LMSgP+Irzb2wMEHtFKG0PV0p875RTGJKsUB3HrCTOUQXMNFYD8JyVKUJ5MbQxwLPDvZXN1kMyfrVF3myrs/t3G+5E/hzkt/1d6HWxKQLoNN+1jhFB+01AI5LrOal3tPGWFzDxDjIGKsmUGW7Ijljkl1tNpMn1vLWO87+iWXV0JWQeqwc2Vn+ZX2X9gB8CZJf5nrFYTwq4qWqlp8zNq/D8TM6aIpUoD6rCavaqXSfUQlXg5PA6PJvVzmGjuu2UO5kPBlae4qYGwMXOxiRIuBF6RftIDLKhWCm1tB7hLHXKcl2S4+tH2KGhJvxE2nvvlb8gLRBY48yJm1cyIWnIhjLrUZzVsrOVkdP95MpHl+tKcS7raOkC3eVC6+fcu5Iee0v+urmDX8BHx4MopuAJwDKrB2CLPwWL4VKoG1eucKcfFf3NbINgCvbMvO0wJ4fylHpu7csodFHQ/8ggnM0YJN5zkPXvYhkxbDG0Affyn0Eq+IzWRmlerVu2EwN61AxXZoGRitp0WkLvFJDqrn2Oq7WEevHN
 EU/lDmDS
 wHIwZBLVFxw8O82ndrAbwbxIeCeUGWJ33CLPtrHSe9jfdUa3YOutR3n5sPBdgLbYk8PvSokcav9i1+d3XN3YMDBCRDkImvIY7bSHgYKqZBdp4ZMLwU6CzSXgww5mPSPA6eBTfEmLMATMGz6UUd2t7eTb4fa5vGow+j2KJPTUUOb7xz2x6yqblD6xBj13i+aDoF87Di576m5ICXsxQXbHvevPg+lpSK6LPo8t5J2H2Gzv14tS72n+5LK6Ln/Bof9L/+KTjgjsRX5tsFS+YMARKIepDmavNtmYKJxPMaJqkFP3OBnlYqh14/bthqx37NiSR2O5Dv4/2OD0PcOqBgcNdb73YVlUE86BGDl99nWzQnMSvN+p/5BnsjtvQCWXYJ2czkQoI5LwPtR2AXQtfr08rpsOyLNznfXBERUSSijuaR7CElIm3oZbqJoBcMdZ4TD7NMGGC91fRlHT5RfVDwfql2rJlsZK4rWL7E6iioJ7qIEEXB9qkkOabLhh6RQGqKoFpUgdM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tong:

I applied this path on 6.18 and tested on Kunpeng920, system still alive 
when i inject a error in copy from user context, but I found that user 
application receive a SIGBUS, this action is different with x86 machine 
which return -EFAULT rather than send SIGBUS.

I added a patch to fix this behavior[0]. Feel free to incorporate it 
into your series, or I can send it as a formal follow-up patch, 
whichever you prefer.

[0]: https://github.com/winterddd/linux/tree/arm-copyin

Best regards,
Ruidong

在 2024/12/9 10:42, Tong Tiangen 写道:
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
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> ---
>   arch/arm64/Kconfig                   |  1 +
>   arch/arm64/include/asm/asm-extable.h | 31 +++++++++++++++++++++++-----
>   arch/arm64/include/asm/asm-uaccess.h |  4 ++++
>   arch/arm64/include/asm/extable.h     |  1 +
>   arch/arm64/lib/copy_to_user.S        | 10 ++++-----
>   arch/arm64/mm/extable.c              | 19 +++++++++++++++++
>   arch/arm64/mm/fault.c                | 30 ++++++++++++++++++++-------
>   7 files changed, 78 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 100570a048c5..5fa54d31162c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -21,6 +21,7 @@ config ARM64
>   	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>   	select ARCH_HAS_CACHE_LINE_SIZE
>   	select ARCH_HAS_CC_PLATFORM
> +	select ARCH_HAS_COPY_MC if ACPI_APEI_GHES
>   	select ARCH_HAS_CURRENT_STACK_POINTER
>   	select ARCH_HAS_DEBUG_VIRTUAL
>   	select ARCH_HAS_DEBUG_VM_PGTABLE
> diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
> index b8a5861dc7b7..0f9123efca0a 100644
> --- a/arch/arm64/include/asm/asm-extable.h
> +++ b/arch/arm64/include/asm/asm-extable.h
> @@ -5,11 +5,13 @@
>   #include <linux/bits.h>
>   #include <asm/gpr-num.h>
>   
> -#define EX_TYPE_NONE			0
> -#define EX_TYPE_BPF			1
> -#define EX_TYPE_UACCESS_ERR_ZERO	2
> -#define EX_TYPE_KACCESS_ERR_ZERO	3
> -#define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	4
> +#define EX_TYPE_NONE				0
> +#define EX_TYPE_BPF				1
> +#define EX_TYPE_UACCESS_ERR_ZERO		2
> +#define EX_TYPE_KACCESS_ERR_ZERO		3
> +#define EX_TYPE_LOAD_UNALIGNED_ZEROPAD		4
> +/* kernel access memory error safe */
> +#define EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR	5
>   
>   /* Data fields for EX_TYPE_UACCESS_ERR_ZERO */
>   #define EX_DATA_REG_ERR_SHIFT	0
> @@ -51,6 +53,17 @@
>   #define _ASM_EXTABLE_UACCESS(insn, fixup)				\
>   	_ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, wzr, wzr)
>   
> +#define _ASM_EXTABLE_KACCESS_ERR_ZERO_MEM_ERR(insn, fixup, err, zero)	\
> +	__ASM_EXTABLE_RAW(insn, fixup, 					\
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
> @@ -69,6 +82,14 @@
>   	.endif
>   	.endm
>   
> +/*
> + * Create an exception table entry for kaccess `insn`, which will branch to
> + * `fixup` when an unhandled fault is taken.
> + */
> +	.macro          _asm_extable_kaccess_mem_err, insn, fixup
> +	_ASM_EXTABLE_KACCESS_MEM_ERR(\insn, \fixup)
> +	.endm
> +
>   #else /* __ASSEMBLY__ */
>   
>   #include <linux/stringify.h>
> diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
> index 5b6efe8abeeb..19aa0180f645 100644
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
> index 72b0e71cc3de..bc49443bc502 100644
> --- a/arch/arm64/include/asm/extable.h
> +++ b/arch/arm64/include/asm/extable.h
> @@ -46,4 +46,5 @@ bool ex_handler_bpf(const struct exception_table_entry *ex,
>   #endif /* !CONFIG_BPF_JIT */
>   
>   bool fixup_exception(struct pt_regs *regs);
> +bool fixup_exception_me(struct pt_regs *regs);
>   #endif
> diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
> index 802231772608..bedab1678431 100644
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
> @@ -64,7 +64,7 @@ SYM_FUNC_START(__arch_copy_to_user)
>   9997:	cmp	dst, dstin
>   	b.ne	9998f
>   	// Before being absolutely sure we couldn't copy anything, try harder
> -	ldrb	tmp1w, [srcin]
> +KERNEL_MEM_ERR(9998f, ldrb	tmp1w, [srcin])
>   USER(9998f, sttrb tmp1w, [dst])
>   	add	dst, dst, #1
>   9998:	sub	x0, end, dst			// bytes not copied
> diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
> index 228d681a8715..9ad2b6473b60 100644
> --- a/arch/arm64/mm/extable.c
> +++ b/arch/arm64/mm/extable.c
> @@ -72,7 +72,26 @@ bool fixup_exception(struct pt_regs *regs)
>   		return ex_handler_uaccess_err_zero(ex, regs);
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
> +	case EX_TYPE_UACCESS_ERR_ZERO:
> +	case EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR:
> +		return ex_handler_uaccess_err_zero(ex, regs);
> +	}
> +
> +	return false;
> +}
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index ef63651099a9..278e67357f49 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -801,21 +801,35 @@ static int do_bad(unsigned long far, unsigned long esr, struct pt_regs *regs)
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
> +		if (!fixup_exception_me(regs))
> +			return -ENOENT;
> +	}
> +
> +	return ret;
> +}
> +
>   static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
>   {
>   	const struct fault_info *inf;
>   	unsigned long siaddr;
>   
> -	inf = esr_to_fault_info(esr);
> -
> -	if (user_mode(regs) && apei_claim_sea(regs) == 0) {
> -		/*
> -		 * APEI claimed this as a firmware-first notification.
> -		 * Some processing deferred to task_work before ret_to_user().
> -		 */
> +	if (do_apei_claim_sea(regs) == 0)
>   		return 0;
> -	}
>   
> +	inf = esr_to_fault_info(esr);
>   	if (esr & ESR_ELx_FnV) {
>   		siaddr = 0;
>   	} else {


