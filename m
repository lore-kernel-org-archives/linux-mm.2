Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6BECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A855B6B00A3; Wed, 27 May 2026 08:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35BD6B00A4; Wed, 27 May 2026 08:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924636B00A5; Wed, 27 May 2026 08:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E42B6B00A3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:11:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ACE91A05BF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:11:29 +0000 (UTC)
X-FDA: 84813085098.07.DDD33AD
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id C6DC840014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:11:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iCU4PczS;
	spf=pass (imf01.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xwqbmiv0R32lR8BuocOfuqeBrCq/zaUsqLAFm0txiGU=;
	b=2bfI9KwBNvqIanTRH4dtl7jiUdnQ4nE2fWZ1CdETa/6j1av3IgZ2h/yXYU5xM7qwYY51yN
	1LZ3+uqgZjy90U5dgtDvUcj3IXd0V+LcGDCdJiLl5RmqaQhUgwf9aeCq5+AuP8UNITrPCw
	HWBJKVsermtJAcoU8G3uQ9dL1IIQMP0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iCU4PczS;
	spf=pass (imf01.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883887; a=rsa-sha256;
	cv=none;
	b=2DmqAauSV4RD6kDpF0cp5dVQRIhM8i4gIGpDVU1kmsY09sYln3j9EgpEpUnTVTknHrn8Oy
	5jV0HY8UdqNwe6PeIgdt8X/2iriXm0UQgnxpWIt3GKNm8IYiusDJ6IDVb/8xKvQM9lGYi8
	BcSVJk6a34lXXTPptet1/Jc9+vw5FZE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779883882; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xwqbmiv0R32lR8BuocOfuqeBrCq/zaUsqLAFm0txiGU=;
	b=iCU4PczS8JygRUNZ0JcOO6zy5tp8NBzRPLhHSLzgW0rEuQmZPELfx5FfDbFfVw3H88Hm/lsKX8UbULVLHa4k3q+IJa5dSqivIoblczClYN0+YftSIkSq7aEmIs1a3FF7/xI7nX0nO/PfAvLcy+Xb8d1GP9xPSAcuQSxN2kHzggo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3jgBSf_1779883878;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jgBSf_1779883878 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 20:11:19 +0800
Message-ID: <037abe53-860e-4a87-afd8-8abfd3f6093a@linux.alibaba.com>
Date: Wed, 27 May 2026 20:11:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 5/8] arm64: support copy_mc_[user]_highpage()
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
 <20260518084956.2538442-6-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-6-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b3kdah54gcpdxj4qsuj56u9h3jaqxxup
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6DC840014
X-HE-Tag: 1779883885-171124
X-HE-Meta: U2FsdGVkX1+zxDQcnqnaDx309tVqKfvp0clhY7DQ8KoDSf3Cqx2rqGluqXJWEhzyRqQav0kwQ9Ok9rEOcnCj86vli+koMjm1d4NYrGxtOebpxMVXPK3+iZk5ZVt8ZGfp7RvcCiJtC0p4hduFw9OCl2sa0NYrTaGCAFa2upewce9NwpGbaA9xbYBCtprTIK/UhOa4P8au3d+FVDL6Cd4DbuCBvECmaxV8ro7dUnvzHwOjrlYZceaf9GjbzH/5VJkDk+rimMngSfEJqYdygKvbuu+lvLjV/qlM0x3kvhjMBTdxvWQcIHxvbiiA3Gh59a/F8Wo98PRMCEaddLcy/P0aE6uLB4n02HkuFonc58IdZ1kx6fq7m3N9DCdAgw1G0F/G544l2iyg6bACSMAOvyZ1xlRFejozFuQXiKMEAdsNEz4bShbsc5IKJtUwQL4uL7l5b/T3+kDh3n7FfIaBfiYdTOx5CTZwOEXfshTWDHRVE9a+W/qp6I52QL3fVi6Uuwrm8shtFLpBe+r3YEgiNQFc8jzs7wsmajgif5KMn2PHNHUhUeBL5k68O8vtoY3CohAZ2Arp2MUIHuh/c0yknSi5jKCD0twnh0PKTUHZPPknm8N2BxU2XS7YvsWBmMLn+bl4n1BtSJk1S7kW73Mqfl2EuS8FV4SEBRKd+TVE7Qvaz9mKT0eWqZ/aOLPvy/AK6U/cL8eKRtPgUK/ntvijQYwJT+pbtN69CEP0//sINM11Tw94W5MCTbGPLrWP6XvQT5U6ZGJ8gBh+tXbsM4DypGVpFW5RgI5renR96qvheh+NGCYaC6KIqa+pLdfWrDvnFTIRDYglVN4Y9ezH+iJ2bz/4BsYLcAFeQI7gT4mJsRv5qzejnbfoRoebHmWlzlCXiRNZD+Hgyyui04foUQsSL8IJTKrABUp4YQ+xfL5bOgxlUs92Q7JBc7wT8J9ITs/PoJmxuEk4S58CConidJRJagD
 M8yvo0Rq
 n57KXUmumK6cwnACQerXbIucwOd5vxIX0rAeqJUAFmoLhraXoYmKWLlsXGZs8l4teHifyObcfw8PPrhY+csri/vp7OLPusoG0jrPPIp3Ve70DUDhKeKyOmcf21Vz5ka+LxEwkaoEDczRJLmgDVEGXBQdRpF4me3b/0r/88Rql+0UtR4h3+AChQFNlCl1jPHRMssERDa3aW9tVjQWVIRRxniv8kniWTFo8tdBoizNMPasto45gFKCgD8xSgbWszov3cx31ZPnUxFilOs6yaHhYCUG/ioE/G/XajXulAHjAaPq4lIcEtXMV63Z7UB8kgJNMmaK/X09k6dQ13G9G4DjOYuzcmPDUmDURmnMRzqBQHe6f5E4r6Lg9lQJjmAr9KjO+zAIRuR/tH8JwQj5SUAWwyz9Pn4Iz+I2eG0d0linPp7TBMr5DnT4tEZu49U1a6pXF+Eb/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> From: Tong Tiangen <tongtiangen@huawei.com>
> 
> Currently, many scenarios that can tolerate memory errors when copying page
> have been supported in the kernel[1~5], all of which are implemented by
> copy_mc_[user]_highpage(). arm64 should also support this mechanism.
> 
> Due to mte, arm64 needs to have its own copy_mc_[user]_highpage()
> architecture implementation, macros __HAVE_ARCH_COPY_MC_HIGHPAGE and
> __HAVE_ARCH_COPY_MC_USER_HIGHPAGE have been added to control it.
> 
> Add new helper copy_mc_page() which provide a page copy implementation with
> hardware memory error safe. The code logic of copy_mc_page() is the same as
> copy_page(), the main difference is that the ldp insn of copy_mc_page()
> contains the fixup type EX_TYPE_KACCESS_ERR_ZERO_MEM_ERR, therefore, the
> main logic is extracted to copy_page_template.S. In addition, the fixup of
> MOPS insn is not considered at present.
> 
> [Ruidong: add FEAT_MOPS support]


    copy_page_template.S now references the cpy1 macro inside the MOPS
    alternative:

        #ifdef CONFIG_AS_HAS_MOPS
        alternative_if_not ARM64_HAS_MOPS
            b   .Lno_mops
        alternative_else_nop_endif
            mov x2, #PAGE_SIZE
            cpy1    dst, src, x2
            b   .Lexitfunc
        .Lno_mops:
        #endif

    copy_mc_page.S provides cpy1 (using cpyfp/m/ert + USER_CPY).
    copy_page.S, however, only provides ldp1 -- no cpy1 -- so any
    toolchain with FEAT_MOPS support fails to assemble copy_page.S
    with "unknown mnemonic 'cpy1'".

> 
> [1] commit d302c2398ba2 ("mm, hwpoison: when copy-on-write hits poison, take page offline")
> [2] commit 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
> [3] commit 6b970599e807 ("mm: hwpoison: support recovery from ksm_might_need_to_copy()")
> [4] commit 98c76c9f1ef7 ("mm/khugepaged: recover from poisoned anonymous memory")
> [5] commit 12904d953364 ("mm/khugepaged: recover from poisoned file-backed memory")
> 
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
> ---
>   arch/arm64/include/asm/mte.h        |  9 ++++
>   arch/arm64/include/asm/page.h       | 10 ++++
>   arch/arm64/lib/Makefile             |  2 +
>   arch/arm64/lib/copy_mc_page.S       | 44 +++++++++++++++++
>   arch/arm64/lib/copy_page.S          | 62 ++----------------------
>   arch/arm64/lib/copy_page_template.S | 71 +++++++++++++++++++++++++++
>   arch/arm64/lib/mte.S                | 29 +++++++++++
>   arch/arm64/mm/copypage.c            | 75 +++++++++++++++++++++++++++++
>   include/linux/highmem.h             |  8 +++
>   9 files changed, 253 insertions(+), 57 deletions(-)
>   create mode 100644 arch/arm64/lib/copy_mc_page.S
>   create mode 100644 arch/arm64/lib/copy_page_template.S
> 
> diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
> index 7f7b97e09996..a0b1757f4847 100644
> --- a/arch/arm64/include/asm/mte.h
> +++ b/arch/arm64/include/asm/mte.h
> @@ -98,6 +98,11 @@ static inline bool try_page_mte_tagging(struct page *page)
>   void mte_zero_clear_page_tags(void *addr);
>   void mte_sync_tags(pte_t pte, unsigned int nr_pages);
>   void mte_copy_page_tags(void *kto, const void *kfrom);
> +
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +int mte_copy_mc_page_tags(void *kto, const void *kfrom);
> +#endif
> +
>   void mte_thread_init_user(void);
>   void mte_thread_switch(struct task_struct *next);
>   void mte_cpu_setup(void);
> @@ -134,6 +139,10 @@ static inline void mte_sync_tags(pte_t pte, unsigned int nr_pages)
>   static inline void mte_copy_page_tags(void *kto, const void *kfrom)
>   {
>   }
> +static inline int mte_copy_mc_page_tags(void *kto, const void *kfrom)
> +{
> +	return 0;
> +}
>   static inline void mte_thread_init_user(void)
>   {
>   }
> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index e25d0d18f6d7..f65818ee614a 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -29,6 +29,16 @@ void copy_user_highpage(struct page *to, struct page *from,
>   void copy_highpage(struct page *to, struct page *from);
>   #define __HAVE_ARCH_COPY_HIGHPAGE
>   
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +int copy_mc_page(void *to, const void *from);
> +int copy_mc_highpage(struct page *to, struct page *from);
> +#define __HAVE_ARCH_COPY_MC_HIGHPAGE
> +
> +int copy_mc_user_highpage(struct page *to, struct page *from,
> +		unsigned long vaddr, struct vm_area_struct *vma);
> +#define __HAVE_ARCH_COPY_MC_USER_HIGHPAGE
> +#endif
> +
>   struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>   						unsigned long vaddr);
>   #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
> diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
> index 448c917494f3..1f4c3f743a20 100644
> --- a/arch/arm64/lib/Makefile
> +++ b/arch/arm64/lib/Makefile
> @@ -7,6 +7,8 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
>   
>   lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
>   
> +lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc_page.o
> +
>   obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>   
>   obj-$(CONFIG_ARM64_MTE) += mte.o
> diff --git a/arch/arm64/lib/copy_mc_page.S b/arch/arm64/lib/copy_mc_page.S
> new file mode 100644
> index 000000000000..ad1371e9e687
> --- /dev/null
> +++ b/arch/arm64/lib/copy_mc_page.S
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#include <linux/linkage.h>
> +#include <linux/const.h>
> +#include <asm/assembler.h>
> +#include <asm/page.h>
> +#include <asm/cpufeature.h>
> +#include <asm/alternative.h>
> +#include <asm/asm-extable.h>
> +#include <asm/asm-uaccess.h>
> +
> +/*
> + * Copy a page from src to dest (both are page aligned) with memory error safe
> + *
> + * Parameters:
> + *	x0 - dest
> + *	x1 - src
> + * Returns:
> + * 	x0 - Return 0 if copy success, or -EFAULT if anything goes wrong
> + *	     while copying.
> + */
> +	.macro ldp1 reg1, reg2, ptr, val
> +	KERNEL_MEM_ERR(9998f, ldp \reg1, \reg2, [\ptr, \val])
> +	.endm
> +
> +	.macro cpy1 dst, src, count
> +	.arch_extension mops
> +	USER_CPY(9998f, 0, cpyfprt [\dst]!, [\src]!, \count!)
> +	USER_CPY(9998f, 0, cpyfmrt [\dst]!, [\src]!, \count!)
> +	USER_CPY(9998f, 0, cpyfert [\dst]!, [\src]!, \count!)
> +	.endm
> +
> +SYM_FUNC_START(__pi_copy_mc_page)
> +#include "copy_page_template.S"
> +
> +	mov x0, #0
> +	ret
> +
> +9998:	mov x0, #-EFAULT
> +	ret
> +
> +SYM_FUNC_END(__pi_copy_mc_page)
> +SYM_FUNC_ALIAS(copy_mc_page, __pi_copy_mc_page)
> +EXPORT_SYMBOL(copy_mc_page)
> diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
> index e6374e7e5511..d0186bbf99f1 100644
> --- a/arch/arm64/lib/copy_page.S
> +++ b/arch/arm64/lib/copy_page.S
> @@ -17,65 +17,13 @@
>    *	x0 - dest
>    *	x1 - src
>    */
> -SYM_FUNC_START(__pi_copy_page)
> -#ifdef CONFIG_AS_HAS_MOPS
> -	.arch_extension mops
> -alternative_if_not ARM64_HAS_MOPS
> -	b	.Lno_mops
> -alternative_else_nop_endif
> -
> -	mov	x2, #PAGE_SIZE
> -	cpypwn	[x0]!, [x1]!, x2!
> -	cpymwn	[x0]!, [x1]!, x2!
> -	cpyewn	[x0]!, [x1]!, x2!
> -	ret
> -.Lno_mops:
> -#endif
> -	ldp	x2, x3, [x1]
> -	ldp	x4, x5, [x1, #16]
> -	ldp	x6, x7, [x1, #32]
> -	ldp	x8, x9, [x1, #48]
> -	ldp	x10, x11, [x1, #64]
> -	ldp	x12, x13, [x1, #80]
> -	ldp	x14, x15, [x1, #96]
> -	ldp	x16, x17, [x1, #112]
> -
> -	add	x0, x0, #256
> -	add	x1, x1, #128
> -1:
> -	tst	x0, #(PAGE_SIZE - 1)
>   
> -	stnp	x2, x3, [x0, #-256]
> -	ldp	x2, x3, [x1]
> -	stnp	x4, x5, [x0, #16 - 256]
> -	ldp	x4, x5, [x1, #16]
> -	stnp	x6, x7, [x0, #32 - 256]
> -	ldp	x6, x7, [x1, #32]
> -	stnp	x8, x9, [x0, #48 - 256]
> -	ldp	x8, x9, [x1, #48]
> -	stnp	x10, x11, [x0, #64 - 256]
> -	ldp	x10, x11, [x1, #64]
> -	stnp	x12, x13, [x0, #80 - 256]
> -	ldp	x12, x13, [x1, #80]
> -	stnp	x14, x15, [x0, #96 - 256]
> -	ldp	x14, x15, [x1, #96]
> -	stnp	x16, x17, [x0, #112 - 256]
> -	ldp	x16, x17, [x1, #112]
> -
> -	add	x0, x0, #128
> -	add	x1, x1, #128
> -
> -	b.ne	1b
> -
> -	stnp	x2, x3, [x0, #-256]
> -	stnp	x4, x5, [x0, #16 - 256]
> -	stnp	x6, x7, [x0, #32 - 256]
> -	stnp	x8, x9, [x0, #48 - 256]
> -	stnp	x10, x11, [x0, #64 - 256]
> -	stnp	x12, x13, [x0, #80 - 256]
> -	stnp	x14, x15, [x0, #96 - 256]
> -	stnp	x16, x17, [x0, #112 - 256]
> +	.macro ldp1 reg1, reg2, ptr, val
> +	ldp \reg1, \reg2, [\ptr, \val]
> +	.endm
>   
> +SYM_FUNC_START(__pi_copy_page)
> +#include "copy_page_template.S"
>   	ret
>   SYM_FUNC_END(__pi_copy_page)
>   SYM_FUNC_ALIAS(copy_page, __pi_copy_page)
> diff --git a/arch/arm64/lib/copy_page_template.S b/arch/arm64/lib/copy_page_template.S
> new file mode 100644
> index 000000000000..d466b51c8ed9
> --- /dev/null
> +++ b/arch/arm64/lib/copy_page_template.S
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + */
> +
> +/*
> + * Copy a page from src to dest (both are page aligned)
> + *
> + * Parameters:
> + *	x0 - dest
> + *	x1 - src
> + */
> +dstin	.req	x0
> +src	.req	x1
> +
> +#ifdef CONFIG_AS_HAS_MOPS
> +	.arch_extension mops
> +alternative_if_not ARM64_HAS_MOPS
> +	b	.Lno_mops
> +alternative_else_nop_endif
> +	mov	x2, #PAGE_SIZE
> +	cpy1	dst, src, x2

copy_page_template.S now references the cpy1 macro inside the MOPS
alternative:

copy_page.S, however, only provides ldp1 -- no cpy1 -- so any
toolchain with FEAT_MOPS support fails to assemble copy_page.S
with "unknown mnemonic 'cpy1'".

Trivial fix:

        diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
        @@
             .macro ldp1 reg1, reg2, ptr, val
             ldp \reg1, \reg2, [\ptr, \val]
             .endm

        +    .macro cpy1 dst, src, count
        +    .arch_extension mops
        +    cpyp [\dst]!, [\src]!, \count!
        +    cpym [\dst]!, [\src]!, \count!
        +    cpye [\dst]!, [\src]!, \count!
        +    .endm
        +
         SYM_FUNC_START(__pi_copy_page)
         #include "copy_page_template.S"


> +	b	.Lexitfunc
> +.Lno_mops:
> +#endif
> +
> +	ldp1	x2, x3, x1, #0
> +	ldp1	x4, x5, x1, #16
> +	ldp1	x6, x7, x1, #32
> +	ldp1	x8, x9, x1, #48
> +	ldp1	x10, x11, x1, #64
> +	ldp1	x12, x13, x1, #80
> +	ldp1	x14, x15, x1, #96
> +	ldp1	x16, x17, x1, #112
> +
> +	add	x0, x0, #256
> +	add	x1, x1, #128
> +1:
> +	tst	x0, #(PAGE_SIZE - 1)
> +
> +	stnp	x2, x3, [x0, #-256]
> +	ldp1	x2, x3, x1, #0
> +	stnp	x4, x5, [x0, #16 - 256]
> +	ldp1	x4, x5, x1, #16
> +	stnp	x6, x7, [x0, #32 - 256]
> +	ldp1	x6, x7, x1, #32
> +	stnp	x8, x9, [x0, #48 - 256]
> +	ldp1	x8, x9, x1, #48
> +	stnp	x10, x11, [x0, #64 - 256]
> +	ldp1	x10, x11, x1, #64
> +	stnp	x12, x13, [x0, #80 - 256]
> +	ldp1	x12, x13, x1, #80
> +	stnp	x14, x15, [x0, #96 - 256]
> +	ldp1	x14, x15, x1, #96
> +	stnp	x16, x17, [x0, #112 - 256]
> +	ldp1	x16, x17, x1, #112
> +
> +	add	x0, x0, #128
> +	add	x1, x1, #128
> +
> +	b.ne	1b
> +
> +	stnp	x2, x3, [x0, #-256]
> +	stnp	x4, x5, [x0, #16 - 256]
> +	stnp	x6, x7, [x0, #32 - 256]
> +	stnp	x8, x9, [x0, #48 - 256]
> +	stnp	x10, x11, [x0, #64 - 256]
> +	stnp	x12, x13, [x0, #80 - 256]
> +	stnp	x14, x15, [x0, #96 - 256]
> +	stnp	x16, x17, [x0, #112 - 256]
> +.Lexitfunc:
> diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
> index 5018ac03b6bf..9d4eeb76a838 100644
> --- a/arch/arm64/lib/mte.S
> +++ b/arch/arm64/lib/mte.S
> @@ -80,6 +80,35 @@ SYM_FUNC_START(mte_copy_page_tags)
>   	ret
>   SYM_FUNC_END(mte_copy_page_tags)
>   
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +/*
> + * Copy the tags from the source page to the destination one with memory error safe
> + *   x0 - address of the destination page
> + *   x1 - address of the source page
> + * Returns:
> + *   x0 - Return 0 if copy success, or
> + *        -EFAULT if anything goes wrong while copying.
> + */
> +SYM_FUNC_START(mte_copy_mc_page_tags)
> +	mov	x2, x0
> +	mov	x3, x1
> +	multitag_transfer_size x5, x6
> +1:
> +KERNEL_MEM_ERR(2f, ldgm	x4, [x3])
> +	stgm	x4, [x2]
> +	add	x2, x2, x5
> +	add	x3, x3, x5
> +	tst	x2, #(PAGE_SIZE - 1)
> +	b.ne	1b
> +
> +	mov x0, #0
> +	ret
> +
> +2:	mov x0, #-EFAULT
> +	ret
> +SYM_FUNC_END(mte_copy_mc_page_tags)
> +#endif
> +
>   /*
>    * Read tags from a user buffer (one tag per byte) and set the corresponding
>    * tags at the given kernel address. Used by PTRACE_POKEMTETAGS.
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index cd5912ba617b..9fd773baf17b 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -72,3 +72,78 @@ void copy_user_highpage(struct page *to, struct page *from,
>   	flush_dcache_page(to);
>   }
>   EXPORT_SYMBOL_GPL(copy_user_highpage);
> +
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +/*
> + * Return -EFAULT if anything goes wrong while copying page or mte.
> + */
> +int copy_mc_highpage(struct page *to, struct page *from)
> +{
> +	void *kto = page_address(to);
> +	void *kfrom = page_address(from);
> +	struct folio *src = page_folio(from);
> +	struct folio *dst = page_folio(to);
> +	unsigned int i, nr_pages;
> +	int ret;
> +
> +	ret = copy_mc_page(kto, kfrom);
> +	if (ret)
> +		return -EFAULT;


The generic fallback in include/linux/highmem.h does:

     ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
     ...
     if (ret) memory_failure_queue(page_to_pfn(from), 0);

The arm64 implementation in arch/arm64/mm/copypage.c does not call
emory_failure_queue() on failure.  Please document it explicitly.


Thanks.
Shuai

