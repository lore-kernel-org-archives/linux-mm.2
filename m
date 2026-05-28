Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91EACD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 03:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45616B0005; Wed, 27 May 2026 23:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF60F6B0088; Wed, 27 May 2026 23:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4E66B008A; Wed, 27 May 2026 23:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB5E56B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:10:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 296381C0629
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:10:52 +0000 (UTC)
X-FDA: 84815351544.06.0516C9F
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51AA010000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:10:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HosR2o2V;
	spf=pass (imf14.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779937850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEfE+Ulbhtm/9YGb2V0pAxWrbZ5fQJlm0gwRSXFsoMw=;
	b=2KViA8Ov8QyZhYlGSaqNovLGuI/VfJX6btsLL2DYb+m9FD+jFHQAGdkrPP1rfhjA8/nEdz
	GUdBy7qNg4ZOU/cxFrU4v7t2MAZAaSWftrOxehT7n2DK1Q9hNED+Xic1nfBvjCFeYeL4On
	p4tArSh9ZiOMEUTRxKl/+Q0LsPzC3Qg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HosR2o2V;
	spf=pass (imf14.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779937850; a=rsa-sha256;
	cv=none;
	b=RWCKsWbInIQkFtHXKHbd9PwBxWKY70wb2oZ7S0bf9h7M/LlNGASqNr8YYqj9utcKzEeIUN
	4dsKtmk4G5u/8DNuvxFcuvKNcCzIJ/YFy2pbu7FH2OxVecFO9EmOf29TGjWhcSjIzVJbrL
	PD9ZuCvKuBUnAUXhVNMKrd+OXDQ3oHE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779937846; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KEfE+Ulbhtm/9YGb2V0pAxWrbZ5fQJlm0gwRSXFsoMw=;
	b=HosR2o2V5NNDkrhkC24yLBwIGiSyBaNJx211vUJAlnY5dkGRg6U1D1BA7Cl6kwXR0yes5vsphQlGX67dJb/7OspLTOhfN1g0c2r5l+TPFbVXmOJm6yNgFd5DwIq0rc+tA0pC/SFSYd3sq8VtYU24Il0FJfONyPHB3FSCo/Oa5ps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3l98-m_1779937843;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3l98-m_1779937843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 May 2026 11:10:44 +0800
Message-ID: <05accd00-bcb8-4f23-bd2c-d5eb3bf408f3@linux.alibaba.com>
Date: Thu, 28 May 2026 11:10:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 7/8] arm64: introduce copy_mc_to_kernel()
 implementation
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
 <20260518084956.2538442-8-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-8-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51AA010000B
X-Stat-Signature: ogy1f95x496h9xdh6yjr3s9yud15n3qe
X-HE-Tag: 1779937848-28179
X-HE-Meta: U2FsdGVkX18PnZDYEzmXdMxBSaFREJeva6rKBcxvzfnAB/5egdYkrtfPUxSwnt4wuseCPoR7W7MdYFww23nEENa0JQW78igbFk06NdXdL3P7VvwmeM+1HGm4n20lP8IoUxQ06BRH0idTT9YpeaUZzt2S9Q7p3DO9PNLbk6LA8A7uCP/9VNVzeFsprsi7MYbAgzyMZvVWge6grRPNzyXCalYKUjKkSuUPz02Swn+LR/p9cwQzAuidpGqfWub1aKO2Ak6cjC+VSP7C6QrwiFiMV3zdSljnxdIRlEN0GF4fn6MH01P1iOiwEUIKj/YivxjWfGTzU5rKWw+4oJUYD7ItHTHUq5l5PeecLxCQs7lHTezdp0J+qrcoxBlieMjuqf5CcMVkBNLzO7lN2cJQno25U83RN7qvuL2vQBFBZdx6Z14gKjk7o3UxHxeE9AI4SC6POik3kn74CgM6SGiqes2kSuXSKfB4nSSk4rzmEA/68yrGBeo614xOFI2nFf//M+MKfkwGZS84jCAapf09dIMBDeVZcmHF8Rc9R/73dociBsN17aPnLMCM807nFxXOUTTwt/eKgy/kaTIV/4gj/EDgIBGupwVu2fxfpso7nSzafnmLmEYQFdxBK3QTbETTRokztJPvhE8uPorrdo0daMZqIYnIKmZgYd+WwFvLV98E2jz2Ft3q9Cr1knyCs8LI8f0N+9rihq1+np2v7qO4D2uMY811bRp1F6xNOztQIkVC7cbtIu7syaJic5BWzdqnfRpRbBL0Hkd/5HADk69EmBt3vK2+EpT4pIjNjFR+mTFX+ixktRP3MbZMzj7+H/L3683kFZxOH8+509LMJUHZsO6R6IA13Y0QkWSsw6EMOv/6b0Ykikp5K32t8GO7Yupm2MzOMMwXg9eXFzQ8kbINE9acyNEHJ62Cjo28v7i2umqBPsSshamiKvUT3IUOFtPc28bheFCYpl6SAZNfll0OkUi
 PMdUZi0P
 8PGex+2why2zsQhCmkzXlBU6WbnLjpuy0muvjKIG4wCSxTOJmwgrAJiM8+m8NHFS6tDC/m9sijViCC2lZXXThcstjdxJfCoHisirNJxXnHGLz2FTxMz7gfj6X7ZUfGI7+izSdziVuG+0uSWrGg/4csUjsY1u3SXynszMs3p8zH7WpV/KFNYNekfpfHM5mzPI4tYjO3N5q08HFjBIgk7a5FW2dCJSPsuH6P0+GMBGhXRn2PPVi3uVkyujuRSQmRpmDyS0DH1Sm92J37R20QMzcakarmJwnFKpRvqpdAFIDW5NEqN9BUNNj5clQKjlq+vn01gBF3UcD0ZNEzCdXVBwHT+EE3TdMukGCeB9Qay5OYrbpApqgvJDRwYd3u/kGBUSwK5zqrOQC0LtVm/vvEOgYFfAukaOouq+cow6wfwUFZ2AExhJQiMGUR5JgLmor/f4/nVsFY0H148gsOoQZz5p7BG4evyRD93k7PSq6Zw4NjY2wz0JBZxOmhLuO3HDnpfPrtjRLOcQkzwQ4p3qvHRrmsiHeL1T5Zia1DXmq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> From: Tong Tiangen <tongtiangen@huawei.com>
> 
> The copy_mc_to_kernel() helper is memory copy implementation that handles
> source exceptions. It can be used in memory copy scenarios that tolerate
> hardware memory errors(e.g: pmem_read/dax_copy_to_iter).
> 
> Currently, only x86 and ppc support this helper, Add this for ARM64 as
> well, if ARCH_HAS_COPY_MC is defined, by implementing copy_mc_to_kernel()
> and memcpy_mc() functions.
> 
> Because there is no caller-saved GPR is available for saving "bytes not
> copied" in memcpy(), the memcpy_mc() is referenced to the implementation
> of copy_from_user(). In addition, the fixup of MOPS insn is not considered
> at present.
> 
> [Ruidong: refactor memcpy_mc on top of the new memcpy implementation.]
> 
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
> ---
>   arch/arm64/include/asm/string.h  |   5 +
>   arch/arm64/include/asm/uaccess.h |  17 +++
>   arch/arm64/lib/Makefile          |   2 +-
>   arch/arm64/lib/memcpy.S          | 253 +++----------------------------
>   arch/arm64/lib/memcpy_mc.S       |  56 +++++++
>   arch/arm64/lib/memcpy_template.S | 249 ++++++++++++++++++++++++++++++
>   mm/kasan/shadow.c                |  12 ++
>   7 files changed, 359 insertions(+), 235 deletions(-)
>   create mode 100644 arch/arm64/lib/memcpy_mc.S
>   create mode 100644 arch/arm64/lib/memcpy_template.S
> 
> diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
> index 3a3264ff47b9..23eca4fb24fa 100644
> --- a/arch/arm64/include/asm/string.h
> +++ b/arch/arm64/include/asm/string.h
> @@ -35,6 +35,10 @@ extern void *memchr(const void *, int, __kernel_size_t);
>   extern void *memcpy(void *, const void *, __kernel_size_t);
>   extern void *__memcpy(void *, const void *, __kernel_size_t);
>   
> +#define __HAVE_ARCH_MEMCPY_MC
> +extern int memcpy_mc(void *, const void *, __kernel_size_t);
> +extern int __memcpy_mc(void *, const void *, __kernel_size_t);
> +
>   #define __HAVE_ARCH_MEMMOVE
>   extern void *memmove(void *, const void *, __kernel_size_t);
>   extern void *__memmove(void *, const void *, __kernel_size_t);
> @@ -57,6 +61,7 @@ void memcpy_flushcache(void *dst, const void *src, size_t cnt);
>    */
>   
>   #define memcpy(dst, src, len) __memcpy(dst, src, len)
> +#define memcpy_mc(dst, src, len) __memcpy_mc(dst, src, len)
>   #define memmove(dst, src, len) __memmove(dst, src, len)
>   #define memset(s, c, n) __memset(s, c, n)
>   
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index b0c83a08dda9..93277eca2268 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -499,5 +499,22 @@ static inline size_t probe_subpage_writeable(const char __user *uaddr,
>   }
>   
>   #endif /* CONFIG_ARCH_HAS_SUBPAGE_FAULTS */
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +/**
> + * copy_mc_to_kernel - memory copy that handles source exceptions
> + *
> + * @to:		destination address
> + * @from:	source address
> + * @size:	number of bytes to copy
> + *
> + * Return 0 for success, or bytes not copied.
> + */
> +static inline unsigned long __must_check
> +copy_mc_to_kernel(void *to, const void *from, unsigned long size)
> +{
> +	return memcpy_mc(to, from, size);
> +}
> +#define copy_mc_to_kernel copy_mc_to_kernel
> +#endif
>   
>   #endif /* __ASM_UACCESS_H */
> diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
> index 1f4c3f743a20..a5820e6c33d4 100644
> --- a/arch/arm64/lib/Makefile
> +++ b/arch/arm64/lib/Makefile
> @@ -7,7 +7,7 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
>   
>   lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
>   
> -lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc_page.o
> +lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc_page.o memcpy_mc.o
>   
>   obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>   
> diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
> index 9b99106fb95f..ef6aea2de9b4 100644
> --- a/arch/arm64/lib/memcpy.S
> +++ b/arch/arm64/lib/memcpy.S
> @@ -15,247 +15,32 @@
>    *
>    */
>   
> -#define L(label) .L ## label
> +	.macro ldrb1 reg, addr:vararg
> +		ldrb  \reg, \addr
> +	.endm
>   
> -#define dstin	x0
> -#define src	x1
> -#define count	x2
> -#define dst	x3
> -#define srcend	x4
> -#define dstend	x5
> -#define A_l	x6
> -#define A_lw	w6
> -#define A_h	x7
> -#define B_l	x8
> -#define B_lw	w8
> -#define B_h	x9
> -#define C_l	x10
> -#define C_lw	w10
> -#define C_h	x11
> -#define D_l	x12
> -#define D_h	x13
> -#define E_l	x14
> -#define E_h	x15
> -#define F_l	x16
> -#define F_h	x17
> -#define G_l	count
> -#define G_h	dst
> -#define H_l	src
> -#define H_h	srcend
> -#define tmp1	x14
> +	.macro ldr1 reg, addr:vararg
> +		ldr   \reg, \addr
> +	.endm
>   
> -/* This implementation handles overlaps and supports both memcpy and memmove
> -   from a single entry point.  It uses unaligned accesses and branchless
> -   sequences to keep the code small, simple and improve performance.
> +	.macro ldp1 reg1, reg2, addr:vararg
> +		ldp   \reg1, \reg2, \addr
> +	.endm
>   
> -   Copies are split into 3 main cases: small copies of up to 32 bytes, medium
> -   copies of up to 128 bytes, and large copies.  The overhead of the overlap
> -   check is negligible since it is only required for large copies.
> +	.macro ret1
> +		ret
> +	.endm
>   
> -   Large copies use a software pipelined loop processing 64 bytes per iteration.
> -   The destination pointer is 16-byte aligned to minimize unaligned accesses.
> -   The loop tail is handled by always copying 64 bytes from the end.
> -*/
> +	.macro cpy1 dst, src, count
> +		.arch_extension mops
> +		cpyp [\dst]!, [\src]!, \count!
> +		cpym [\dst]!, [\src]!, \count!
> +		cpye [\dst]!, [\src]!, \count!
> +	.endm
>   
> -SYM_FUNC_START_LOCAL(__pi_memcpy_generic)
> -	add	srcend, src, count
> -	add	dstend, dstin, count
> -	cmp	count, 128
> -	b.hi	L(copy_long)
> -	cmp	count, 32
> -	b.hi	L(copy32_128)
> -
> -	/* Small copies: 0..32 bytes.  */
> -	cmp	count, 16
> -	b.lo	L(copy16)
> -	ldp	A_l, A_h, [src]
> -	ldp	D_l, D_h, [srcend, -16]
> -	stp	A_l, A_h, [dstin]
> -	stp	D_l, D_h, [dstend, -16]
> -	ret
> -
> -	/* Copy 8-15 bytes.  */
> -L(copy16):
> -	tbz	count, 3, L(copy8)
> -	ldr	A_l, [src]
> -	ldr	A_h, [srcend, -8]
> -	str	A_l, [dstin]
> -	str	A_h, [dstend, -8]
> -	ret
> -
> -	.p2align 3
> -	/* Copy 4-7 bytes.  */
> -L(copy8):
> -	tbz	count, 2, L(copy4)
> -	ldr	A_lw, [src]
> -	ldr	B_lw, [srcend, -4]
> -	str	A_lw, [dstin]
> -	str	B_lw, [dstend, -4]
> -	ret
> -
> -	/* Copy 0..3 bytes using a branchless sequence.  */
> -L(copy4):
> -	cbz	count, L(copy0)
> -	lsr	tmp1, count, 1
> -	ldrb	A_lw, [src]
> -	ldrb	C_lw, [srcend, -1]
> -	ldrb	B_lw, [src, tmp1]
> -	strb	A_lw, [dstin]
> -	strb	B_lw, [dstin, tmp1]
> -	strb	C_lw, [dstend, -1]
> -L(copy0):
> -	ret
> -
> -	.p2align 4
> -	/* Medium copies: 33..128 bytes.  */
> -L(copy32_128):
> -	ldp	A_l, A_h, [src]
> -	ldp	B_l, B_h, [src, 16]
> -	ldp	C_l, C_h, [srcend, -32]
> -	ldp	D_l, D_h, [srcend, -16]
> -	cmp	count, 64
> -	b.hi	L(copy128)
> -	stp	A_l, A_h, [dstin]
> -	stp	B_l, B_h, [dstin, 16]
> -	stp	C_l, C_h, [dstend, -32]
> -	stp	D_l, D_h, [dstend, -16]
> -	ret
> -
> -	.p2align 4
> -	/* Copy 65..128 bytes.  */
> -L(copy128):
> -	ldp	E_l, E_h, [src, 32]
> -	ldp	F_l, F_h, [src, 48]
> -	cmp	count, 96
> -	b.ls	L(copy96)
> -	ldp	G_l, G_h, [srcend, -64]
> -	ldp	H_l, H_h, [srcend, -48]
> -	stp	G_l, G_h, [dstend, -64]
> -	stp	H_l, H_h, [dstend, -48]
> -L(copy96):
> -	stp	A_l, A_h, [dstin]
> -	stp	B_l, B_h, [dstin, 16]
> -	stp	E_l, E_h, [dstin, 32]
> -	stp	F_l, F_h, [dstin, 48]
> -	stp	C_l, C_h, [dstend, -32]
> -	stp	D_l, D_h, [dstend, -16]
> -	ret
> -
> -	.p2align 4
> -	/* Copy more than 128 bytes.  */
> -L(copy_long):
> -	/* Use backwards copy if there is an overlap.  */
> -	sub	tmp1, dstin, src
> -	cbz	tmp1, L(copy0)
> -	cmp	tmp1, count
> -	b.lo	L(copy_long_backwards)
> -
> -	/* Copy 16 bytes and then align dst to 16-byte alignment.  */
> -
> -	ldp	D_l, D_h, [src]
> -	and	tmp1, dstin, 15
> -	bic	dst, dstin, 15
> -	sub	src, src, tmp1
> -	add	count, count, tmp1	/* Count is now 16 too large.  */
> -	ldp	A_l, A_h, [src, 16]
> -	stp	D_l, D_h, [dstin]
> -	ldp	B_l, B_h, [src, 32]
> -	ldp	C_l, C_h, [src, 48]
> -	ldp	D_l, D_h, [src, 64]!
> -	subs	count, count, 128 + 16	/* Test and readjust count.  */
> -	b.ls	L(copy64_from_end)
> -
> -L(loop64):
> -	stp	A_l, A_h, [dst, 16]
> -	ldp	A_l, A_h, [src, 16]
> -	stp	B_l, B_h, [dst, 32]
> -	ldp	B_l, B_h, [src, 32]
> -	stp	C_l, C_h, [dst, 48]
> -	ldp	C_l, C_h, [src, 48]
> -	stp	D_l, D_h, [dst, 64]!
> -	ldp	D_l, D_h, [src, 64]!
> -	subs	count, count, 64
> -	b.hi	L(loop64)
> -
> -	/* Write the last iteration and copy 64 bytes from the end.  */
> -L(copy64_from_end):
> -	ldp	E_l, E_h, [srcend, -64]
> -	stp	A_l, A_h, [dst, 16]
> -	ldp	A_l, A_h, [srcend, -48]
> -	stp	B_l, B_h, [dst, 32]
> -	ldp	B_l, B_h, [srcend, -32]
> -	stp	C_l, C_h, [dst, 48]
> -	ldp	C_l, C_h, [srcend, -16]
> -	stp	D_l, D_h, [dst, 64]
> -	stp	E_l, E_h, [dstend, -64]
> -	stp	A_l, A_h, [dstend, -48]
> -	stp	B_l, B_h, [dstend, -32]
> -	stp	C_l, C_h, [dstend, -16]
> -	ret
> -
> -	.p2align 4
> -
> -	/* Large backwards copy for overlapping copies.
> -	   Copy 16 bytes and then align dst to 16-byte alignment.  */
> -L(copy_long_backwards):
> -	ldp	D_l, D_h, [srcend, -16]
> -	and	tmp1, dstend, 15
> -	sub	srcend, srcend, tmp1
> -	sub	count, count, tmp1
> -	ldp	A_l, A_h, [srcend, -16]
> -	stp	D_l, D_h, [dstend, -16]
> -	ldp	B_l, B_h, [srcend, -32]
> -	ldp	C_l, C_h, [srcend, -48]
> -	ldp	D_l, D_h, [srcend, -64]!
> -	sub	dstend, dstend, tmp1
> -	subs	count, count, 128
> -	b.ls	L(copy64_from_start)
> -
> -L(loop64_backwards):
> -	stp	A_l, A_h, [dstend, -16]
> -	ldp	A_l, A_h, [srcend, -16]
> -	stp	B_l, B_h, [dstend, -32]
> -	ldp	B_l, B_h, [srcend, -32]
> -	stp	C_l, C_h, [dstend, -48]
> -	ldp	C_l, C_h, [srcend, -48]
> -	stp	D_l, D_h, [dstend, -64]!
> -	ldp	D_l, D_h, [srcend, -64]!
> -	subs	count, count, 64
> -	b.hi	L(loop64_backwards)
> -
> -	/* Write the last iteration and copy 64 bytes from the start.  */
> -L(copy64_from_start):
> -	ldp	G_l, G_h, [src, 48]
> -	stp	A_l, A_h, [dstend, -16]
> -	ldp	A_l, A_h, [src, 32]
> -	stp	B_l, B_h, [dstend, -32]
> -	ldp	B_l, B_h, [src, 16]
> -	stp	C_l, C_h, [dstend, -48]
> -	ldp	C_l, C_h, [src]
> -	stp	D_l, D_h, [dstend, -64]
> -	stp	G_l, G_h, [dstin, 48]
> -	stp	A_l, A_h, [dstin, 32]
> -	stp	B_l, B_h, [dstin, 16]
> -	stp	C_l, C_h, [dstin]
> -	ret
> -SYM_FUNC_END(__pi_memcpy_generic)
> -
> -#ifdef CONFIG_AS_HAS_MOPS
> -	.arch_extension mops
>   SYM_FUNC_START(__pi_memcpy)
> -alternative_if_not ARM64_HAS_MOPS
> -	b	__pi_memcpy_generic
> -alternative_else_nop_endif
> -
> -	mov	dst, dstin
> -	cpyp	[dst]!, [src]!, count!
> -	cpym	[dst]!, [src]!, count!
> -	cpye	[dst]!, [src]!, count!
> -	ret
> +#include "memcpy_template.S"
>   SYM_FUNC_END(__pi_memcpy)
> -#else
> -SYM_FUNC_ALIAS(__pi_memcpy, __pi_memcpy_generic)
> -#endif
>   
>   SYM_FUNC_ALIAS(__memcpy, __pi_memcpy)
>   EXPORT_SYMBOL(__memcpy)
> diff --git a/arch/arm64/lib/memcpy_mc.S b/arch/arm64/lib/memcpy_mc.S
> new file mode 100644
> index 000000000000..90624d35af4b
> --- /dev/null
> +++ b/arch/arm64/lib/memcpy_mc.S
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2012-2021, Arm Limited.
> + *
> + * Adapted from the original at:
> + * https://github.com/ARM-software/optimized-routines/blob/afd6244a1f8d9229/string/aarch64/memcpy.S
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +#include <asm/asm-uaccess.h>
> +
> +/* Assumptions:
> + *
> + * ARMv8-a, AArch64, unaligned accesses.
> + *
> + */
> +
> +	.macro ldrb1 reg, addr:vararg
> +		KERNEL_MEM_ERR(9998f, ldrb  \reg, \addr)
> +	.endm
> +
> +	.macro ldr1 reg, addr:vararg
> +		KERNEL_MEM_ERR(9998f, ldr   \reg, \addr)
> +	.endm
> +
> +	.macro ldp1 reg1, reg2, addr:vararg
> +		KERNEL_MEM_ERR(9998f, ldp   \reg1, \reg2, \addr)
> +	.endm
> +
> +	.macro ret1
> +		mov	x0, #0
> +		ret
> +	.endm
> +
> +	.macro cpy1 dst, src, count
> +	.arch_extension mops
> +	USER_CPY(9998f, 0, cpyp [\dst]!, [\src]!, \count!)
> +	USER_CPY(9996f, 0, cpym [\dst]!, [\src]!, \count!)
> +	USER_CPY(9996f, 0, cpye [\dst]!, [\src]!, \count!)

memcpy_mc.S annotates kernel-to-kernel MOPS with USER_CPY, registering
EX_TYPE_UACCESS_CPY entries. fixup_exception_me() then routes those
through ex_handler_uaccess_cpy(...., esr=0), whose
cpy_faulted_on_uaccess() applies page-fault read/write match
semantics. It only happens to work today because uaccess_is_write=0
matches a hard-coded fault_on_write=0; any tightening (e.g. real esr
threading) immediately breaks recovery.

Please fix this in conjunction with patch 3:
   (a) introduce KERNEL_CPY / EX_TYPE_KACCESS_CPY_MC, or
   (b) give EX_TYPE_UACCESS_CPY a separate MC handler in
       fixup_exception_me() that just redirects PC.

> +	.endm
> +
> +SYM_FUNC_START(__memcpy_mc)
> +#include "memcpy_template.S"
> +
> +	// Exception fixups
> +9996:	b.cs	9998f
> +	// Registers are in Option A format
> +	add	dst, dst, count
> +9998:	sub	x0, dstend, dstin			// bytes not copied


The MOPS branch in memcpy_template.S executes cpy1 *before* the
no_mops block runs `add dstend, dstin, count`. So if the cpy1 takes
an SEA, control jumps to the 9998 fixup in memcpy_mc.S:

     9998: sub x0, dstend, dstin            // bytes not copied
           ret

with dstend uninitialised. The "bytes not copied" return value is
arbitrary garbage in this case, and copy_mc_to_kernel() will pass
that to its caller (dax/pmem), which will then re-touch dst[0..ret]
based on a bogus boundary. Please initialise srcend/dstend before
the cpy1, or save the original count to a callee-saved register and
return it directly


> +	ret
> +SYM_FUNC_END(__memcpy_mc)
> +
> +EXPORT_SYMBOL(__memcpy_mc)
> +SYM_FUNC_ALIAS_WEAK(memcpy_mc, __memcpy_mc)
> +EXPORT_SYMBOL(memcpy_mc)
> diff --git a/arch/arm64/lib/memcpy_template.S b/arch/arm64/lib/memcpy_template.S
> new file mode 100644
> index 000000000000..205516c6e076
> --- /dev/null
> +++ b/arch/arm64/lib/memcpy_template.S
> @@ -0,0 +1,249 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2012-2021, Arm Limited.
> + *
> + * Adapted from the original at:
> + * https://github.com/ARM-software/optimized-routines/blob/afd6244a1f8d9229/string/aarch64/memcpy.S
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +
> +/* Assumptions:
> + *
> + * ARMv8-a, AArch64, unaligned accesses.
> + *
> + */
> +
> +#define L(label) .L ## label
> +
> +#define dstin	x0
> +#define src	x1
> +#define count	x2
> +#define dst	x3
> +#define srcend	x4
> +#define dstend	x5
> +#define A_l	x6
> +#define A_lw	w6
> +#define A_h	x7
> +#define B_l	x8
> +#define B_lw	w8
> +#define B_h	x9
> +#define C_l	x10
> +#define C_lw	w10
> +#define C_h	x11
> +#define D_l	x12
> +#define D_h	x13
> +#define E_l	x14
> +#define E_h	x15
> +#define F_l	x16
> +#define F_h	x17
> +#define G_l	count
> +#define G_h	dst
> +#define H_l	src
> +#define H_h	srcend
> +#define tmp1	x14
> +
> +/* This implementation handles overlaps and supports both memcpy and memmove
> +   from a single entry point.  It uses unaligned accesses and branchless
> +   sequences to keep the code small, simple and improve performance.
> +
> +   Copies are split into 3 main cases: small copies of up to 32 bytes, medium
> +   copies of up to 128 bytes, and large copies.  The overhead of the overlap
> +   check is negligible since it is only required for large copies.
> +
> +   Large copies use a software pipelined loop processing 64 bytes per iteration.
> +   The destination pointer is 16-byte aligned to minimize unaligned accesses.
> +   The loop tail is handled by always copying 64 bytes from the end.
> +*/
> +
> +#ifdef CONFIG_AS_HAS_MOPS
> +alternative_if_not ARM64_HAS_MOPS
> +	b	L(no_mops):

Trailing colon. Should be:

     b   L(no_mops)

GNU as either rejects this outright or accepts it as nonsense. Either
way, FEAT_MOPS-capable toolchain builds (binutils >= 2.39, recent LLVM)
will fail or produce broken code. Please verify v2 with both
CONFIG_AS_HAS_MOPS=y and =n.


> +alternative_else_nop_endif
> +
> +	cpy1	dst, src, count

Does this execute the hardware copy instruction using an uninitialized
dst (x3) register?

Before the refactoring, memcpy.S had:

     mov  dst, dstin          ; x3 = x0 (preserve x0 as return value)
     cpyp [dst]!, [src]!, count!
     cpym [dst]!, [src]!, count!
     cpye [dst]!, [src]!, count!
     ret                      ; x0 still holds original dest

After: the template jumps straight to `cpy1 dst, src, count` which
expands to `cpyp [x3]!, [x1]!, x2!` with x3 uninitialised. On any
CPU with FEAT_MOPS (Cortex-X3/X4, A720, etc.) this writes src data to
whatever garbage address x3 held at function entry -- silent memory
corruption or an immediate abort, depending on luck.

This affects both plain memcpy() (through memcpy.S -> memcpy_template.S)
and memcpy_mc() (through memcpy_mc.S -> memcpy_template.S).


> +	ret1
> +#endif
> +
> +L(no_mops):
> +	add	srcend, src, count
> +	add	dstend, dstin, count
> +	cmp	count, 128
> +	b.hi	L(copy_long)
> +	cmp	count, 32
> +	b.hi	L(copy32_128)
> +
> +	/* Small copies: 0..32 bytes.  */
> +	cmp	count, 16
> +	b.lo	L(copy16)
> +	ldp1	A_l, A_h, [src]
> +	ldp1	D_l, D_h, [srcend, -16]
> +	stp	A_l, A_h, [dstin]
> +	stp	D_l, D_h, [dstend, -16]
> +	ret1
> +
> +	/* Copy 8-15 bytes.  */
> +L(copy16):
> +	tbz	count, 3, L(copy8)
> +	ldr1	A_l, [src]
> +	ldr1	A_h, [srcend, -8]
> +	str	A_l, [dstin]
> +	str	A_h, [dstend, -8]
> +	ret1
> +
> +	.p2align 3
> +	/* Copy 4-7 bytes.  */
> +L(copy8):
> +	tbz	count, 2, L(copy4)
> +	ldr1	A_lw, [src]
> +	ldr1	B_lw, [srcend, -4]
> +	str	A_lw, [dstin]
> +	str	B_lw, [dstend, -4]
> +	ret1
> +
> +	/* Copy 0..3 bytes using a branchless sequence.  */
> +L(copy4):
> +	cbz	count, L(copy0)
> +	lsr	tmp1, count, 1
> +	ldrb1	A_lw, [src]
> +	ldrb1	C_lw, [srcend, -1]
> +	ldrb1	B_lw, [src, tmp1]
> +	strb	A_lw, [dstin]
> +	strb	B_lw, [dstin, tmp1]
> +	strb	C_lw, [dstend, -1]
> +L(copy0):
> +	ret1
> +
> +	.p2align 4
> +	/* Medium copies: 33..128 bytes.  */
> +L(copy32_128):
> +	ldp1	A_l, A_h, [src]
> +	ldp1	B_l, B_h, [src, 16]
> +	ldp1	C_l, C_h, [srcend, -32]
> +	ldp1	D_l, D_h, [srcend, -16]
> +	cmp	count, 64
> +	b.hi	L(copy128)
> +	stp	A_l, A_h, [dstin]
> +	stp	B_l, B_h, [dstin, 16]
> +	stp	C_l, C_h, [dstend, -32]
> +	stp	D_l, D_h, [dstend, -16]
> +	ret1
> +
> +	.p2align 4
> +	/* Copy 65..128 bytes.  */
> +L(copy128):
> +	ldp1	E_l, E_h, [src, 32]
> +	ldp1	F_l, F_h, [src, 48]
> +	cmp	count, 96
> +	b.ls	L(copy96)
> +	ldp1	G_l, G_h, [srcend, -64]
> +	ldp1	H_l, H_h, [srcend, -48]
> +	stp	G_l, G_h, [dstend, -64]
> +	stp	H_l, H_h, [dstend, -48]
> +L(copy96):
> +	stp	A_l, A_h, [dstin]
> +	stp	B_l, B_h, [dstin, 16]
> +	stp	E_l, E_h, [dstin, 32]
> +	stp	F_l, F_h, [dstin, 48]
> +	stp	C_l, C_h, [dstend, -32]
> +	stp	D_l, D_h, [dstend, -16]
> +	ret1
> +
> +	.p2align 4
> +	/* Copy more than 128 bytes.  */
> +L(copy_long):
> +	/* Use backwards copy if there is an overlap.  */
> +	sub	tmp1, dstin, src
> +	cbz	tmp1, L(copy0)
> +	cmp	tmp1, count
> +	b.lo	L(copy_long_backwards)
> +
> +	/* Copy 16 bytes and then align dst to 16-byte alignment.  */
> +
> +	ldp1	D_l, D_h, [src]
> +	and	tmp1, dstin, 15
> +	bic	dst, dstin, 15
> +	sub	src, src, tmp1
> +	add	count, count, tmp1	/* Count is now 16 too large.  */
> +	ldp1	A_l, A_h, [src, 16]
> +	stp	D_l, D_h, [dstin]
> +	ldp1	B_l, B_h, [src, 32]
> +	ldp1	C_l, C_h, [src, 48]
> +	ldp1	D_l, D_h, [src, 64]!
> +	subs	count, count, 128 + 16	/* Test and readjust count.  */
> +	b.ls	L(copy64_from_end)
> +
> +L(loop64):
> +	stp	A_l, A_h, [dst, 16]
> +	ldp1	A_l, A_h, [src, 16]
> +	stp	B_l, B_h, [dst, 32]
> +	ldp1	B_l, B_h, [src, 32]
> +	stp	C_l, C_h, [dst, 48]
> +	ldp1	C_l, C_h, [src, 48]
> +	stp	D_l, D_h, [dst, 64]!
> +	ldp1	D_l, D_h, [src, 64]!
> +	subs	count, count, 64
> +	b.hi	L(loop64)
> +
> +	/* Write the last iteration and copy 64 bytes from the end.  */
> +L(copy64_from_end):
> +	ldp1	E_l, E_h, [srcend, -64]
> +	stp	A_l, A_h, [dst, 16]
> +	ldp1	A_l, A_h, [srcend, -48]
> +	stp	B_l, B_h, [dst, 32]
> +	ldp1	B_l, B_h, [srcend, -32]
> +	stp	C_l, C_h, [dst, 48]
> +	ldp1	C_l, C_h, [srcend, -16]
> +	stp	D_l, D_h, [dst, 64]
> +	stp	E_l, E_h, [dstend, -64]
> +	stp	A_l, A_h, [dstend, -48]
> +	stp	B_l, B_h, [dstend, -32]
> +	stp	C_l, C_h, [dstend, -16]
> +	ret1
> +
> +	.p2align 4
> +
> +	/* Large backwards copy for overlapping copies.
> +	   Copy 16 bytes and then align dst to 16-byte alignment.  */
> +L(copy_long_backwards):
> +	ldp1	D_l, D_h, [srcend, -16]
> +	and	tmp1, dstend, 15
> +	sub	srcend, srcend, tmp1
> +	sub	count, count, tmp1
> +	ldp1	A_l, A_h, [srcend, -16]
> +	stp	D_l, D_h, [dstend, -16]
> +	ldp1	B_l, B_h, [srcend, -32]
> +	ldp1	C_l, C_h, [srcend, -48]
> +	ldp1	D_l, D_h, [srcend, -64]!
> +	sub	dstend, dstend, tmp1
> +	subs	count, count, 128
> +	b.ls	L(copy64_from_start)
> +
> +L(loop64_backwards):
> +	stp	A_l, A_h, [dstend, -16]
> +	ldp1	A_l, A_h, [srcend, -16]
> +	stp	B_l, B_h, [dstend, -32]
> +	ldp1	B_l, B_h, [srcend, -32]
> +	stp	C_l, C_h, [dstend, -48]
> +	ldp1	C_l, C_h, [srcend, -48]
> +	stp	D_l, D_h, [dstend, -64]!
> +	ldp1	D_l, D_h, [srcend, -64]!
> +	subs	count, count, 64
> +	b.hi	L(loop64_backwards)
> +
> +	/* Write the last iteration and copy 64 bytes from the start.  */
> +L(copy64_from_start):
> +	ldp1	G_l, G_h, [src, 48]
> +	stp	A_l, A_h, [dstend, -16]
> +	ldp1	A_l, A_h, [src, 32]
> +	stp	B_l, B_h, [dstend, -32]
> +	ldp1	B_l, B_h, [src, 16]
> +	stp	C_l, C_h, [dstend, -48]
> +	ldp1	C_l, C_h, [src]
> +	stp	D_l, D_h, [dstend, -64]
> +	stp	G_l, G_h, [dstin, 48]
> +	stp	A_l, A_h, [dstin, 32]
> +	stp	B_l, B_h, [dstin, 16]
> +	stp	C_l, C_h, [dstin]
> +	ret1
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d286e0a04543..3128f0d9cc46 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -79,6 +79,18 @@ void *memcpy(void *dest, const void *src, size_t len)
>   }
>   #endif
>   
> +#ifdef __HAVE_ARCH_MEMCPY_MC
> +#undef memcpy_mc
> +int memcpy_mc(void *dest, const void *src, size_t len)
> +{
> +	if (!kasan_check_range(src, len, false, _RET_IP_) ||
> +	    !kasan_check_range(dest, len, true, _RET_IP_))
> +		return (int)len;
> +
> +	return __memcpy_mc(dest, src, len);
> +}

memcpy_mc() is declared `int` while copy_mc_to_kernel() returns
unsigned long, and the asm side returns the full 64-bit (dstend - dstin).
For len >= 2GiB (real on dax_copy_to_iter over large NVDIMM regions)
the int truncation produces garbage "bytes not copied". Please use
unsigned long throughout:

     extern unsigned long memcpy_mc(void *, const void *,
                                    __kernel_size_t);
     extern unsigned long __memcpy_mc(void *, const void *,
                                      __kernel_size_t);

and in mm/kasan/shadow.c drop the `(int)len` cast accordingly:

     unsigned long memcpy_mc(...)
     {
         ...
             return len;          /* not (int)len */
         return __memcpy_mc(...);
     }


Thanks.
Shuai

