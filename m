Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25159C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 05:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B266B0088; Fri,  8 Aug 2025 01:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8729A6B009A; Fri,  8 Aug 2025 01:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF4F6B009B; Fri,  8 Aug 2025 01:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0496B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:07:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D0F65F698
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:07:35 +0000 (UTC)
X-FDA: 83752407270.10.C2AF59E
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB43A120004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:07:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf29.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754629653; a=rsa-sha256;
	cv=none;
	b=WZkJ8adBVb/YZTfPKOmG9Hl3UJ7hlqcrTgBQV1RgJbgvAXILBgmtanEEUFJv8GLmA54Cfc
	qR4qzSOkfZPhOTR0Mp1lC2S61VHt4RiSIpxDXYFs4f3I83WDL64cFfkxTihA4YzFAW3Ew6
	rDdKi7E0yvFvfIsxbu2N7r4+GDZr5XM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf29.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754629653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PR3mXTvm1TEbk8uyyZeqYNJCeZ39LQ5LRG5oWb2m4C0=;
	b=PrKQ4IndSR5wWdlZK4TifM2t767jswhvtLQfCpA7JxYW3BXC7kqGhJ56mZ9K8mylApgA1H
	7RqpnaPk0W72oadwv/k+v+R/oOCIWfkCBZzoH5zRtUEx7al68w9ffg5/AI6Tj5DkqZ+O8m
	crKeD0soIohnh95x2s3ZaFUfcvfSzU8=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4bysTv1SGvz9sRs;
	Fri,  8 Aug 2025 07:07:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 136VSEc6Znrg; Fri,  8 Aug 2025 07:07:31 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4bysTv0NP1z9sRk;
	Fri,  8 Aug 2025 07:07:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id E9F118B770;
	Fri,  8 Aug 2025 07:07:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id ibwVE1n70MLp; Fri,  8 Aug 2025 07:07:30 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id E61968B763;
	Fri,  8 Aug 2025 07:07:28 +0200 (CEST)
Message-ID: <07ffb27c-3416-43c9-a50a-164a76e5ab60@csgroup.eu>
Date: Fri, 8 Aug 2025 07:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] kasan: call kasan_init_generic in kasan_init
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, ryabinin.a.a@gmail.com,
 bhe@redhat.com, hca@linux.ibm.com, andreyknvl@gmail.com,
 akpm@linux-foundation.org, zhangqing@loongson.cn, chenhuacai@loongson.cn,
 davidgow@google.co, glider@google.com, dvyukov@google.com
Cc: alex@ghiti.fr, agordeev@linux.ibm.com, vincenzo.frascino@arm.com,
 elver@google.com, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20250807194012.631367-1-snovitoll@gmail.com>
 <20250807194012.631367-3-snovitoll@gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250807194012.631367-3-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB43A120004
X-Stat-Signature: a7rwj69x1y5neyducwqsy3unnjq4siht
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754629652-690075
X-HE-Meta: U2FsdGVkX1+hMkG+gbxEeWuLmG6iXYCCfW93AShfTjwSjrSU64+ijvRrDTVhx9Q1el6ToykBJ95iZR18TmKnRXQEU+MNFhHWRm6UyZrOBSgtqtFgFQQys2NmYAa4nLgqju2XIGe/t4TyIWSiE5mJ97OFU39xljIZdu4Q59nb6W4PdSjo571QKNMeFbGG7WlbJHA6IT4GY5VycZtgSDAKdicY8C90SPzWSnhsnNVM1S9bDMV/EpdxrngNMAL3l4coI5LZHt6fs2sD7c6gJ8gGCHbCwNeBpXlo6o1GNTY8K17/2qfWRLPu6cJqAtwzSEI/oo2XairnCgvj+n2YMuD1oEJgyjU4HUEfg8Ag2Jos2dFEckchkz+KArwm+UPBE9JGJaT5zkXOm0lRidJ+irC7U8FgFklHaVgZSEkaPFYV1HLLw4znCHFEWIDQtLq0HEBmdgU6hfzZDktE9QizcdGwanjPsQBVobV5M5yEaY0zoYvPj4fEisdVEUBWJFAd3zG+rIVi54Kmqa35UvQsS5C70DFnthDbtlBc5DH+mpdpRCDuwMDUH8cAeBTAZUs+BGJL1jjAWGI7wNHl7huzNk/+nTtNw8+DYKw0zzy8DVWo3QgS9S8u8tGhNddHDdDO48bC/d6wl/rBI46P+e7GCtZsJjJqKMXHgiNPWwy2c4ddJXEhTf/eOnSTAwD83BLF/MFFLeOjHimEE+5omLYILwx8xqoyka5mq5x2opUWuD9vIF7yOCtlF7thpZr7Bi72pRw2N3KSJ0OqBtfQe6Pqn5BjxD6jkKCeLAMa8BlpT4Mj3E0RaSSFLMlmCUA2hVT0XhnbDzHyb5nnUsLq5HDJZ0ShBWbSEwThAgILEIvYx5LY6n2/tjBxcghVORpOXCEvd9d7BbGa5RnY5NR8EykZy1bXknPfWxtMALibHm6Vpt/bOABxvt+E0v0nXofvGTGP6x2bxiObxRijoVEAbTLRT0j
 n6nxg6bv
 PWuanX0tU6o5IlRsQi1op542OSvVQ9DxNCMtQOsNOdurm430uGwXKKaAJELI6YXr3+2VIAi2hYj+Ba+Hu+S7Mct0RoRpEfVoTbGIToS57kHr5BBcxGlVUoO7+AeAqf1ZmQLr/p5DAWxdp+DWFXBndPmBd7/3cymdMapIeruUQkBEetJ8+8GVNNeuichuPzqf6oI1ivxUfaBtref8U5SGfgs8PkGGW+CtFpB45W/PgrZKz/M+voZU538a4XoX8HEiiOPZVdr2ua8qpBVtfoXTPdqt31Ssqx7TNQVpNZym6xfVM5vLLWayLDxGWJU6CUSJfoUgh/6lMw41Guo8rUioF4sUrME2kkg2yXQx6buHIwc6FEtJC+leRnwi0E5QR2nXuxoWHVz9gZp40qUBZ8FjF76B1xvP9goezN7Hcr6ziw6F36ModlwQtk1dEHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 07/08/2025 à 21:40, Sabyrzhan Tasbolatov a écrit :
> Call kasan_init_generic() which handles Generic KASAN initialization.
> For architectures that do not select ARCH_DEFER_KASAN,
> this will be a no-op for the runtime flag but will
> print the initialization banner.
> 
> For SW_TAGS and HW_TAGS modes, their respective init functions will
> handle the flag enabling, if they are enabled/implemented.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
> ---
> Changes in v5:
> - Unified arch patches into a single one, where we just call
> 	kasan_init_generic()
> - Added Tested-by tag for riscv (tested the same change in v4)
> - Added Acked-by tag for s390 (tested the same change in v4)
> ---
>   arch/arm/mm/kasan_init.c    | 2 +-
>   arch/arm64/mm/kasan_init.c  | 4 +---
>   arch/riscv/mm/kasan_init.c  | 1 +
>   arch/s390/kernel/early.c    | 3 ++-
>   arch/x86/mm/kasan_init_64.c | 2 +-
>   arch/xtensa/mm/kasan_init.c | 2 +-
>   6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
> index 111d4f70313..c6625e808bf 100644
> --- a/arch/arm/mm/kasan_init.c
> +++ b/arch/arm/mm/kasan_init.c
> @@ -300,6 +300,6 @@ void __init kasan_init(void)
>   	local_flush_tlb_all();
>   
>   	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
> -	pr_info("Kernel address sanitizer initialized\n");
>   	init_task.kasan_depth = 0;
> +	kasan_init_generic();
>   }
> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> index d541ce45dae..abeb81bf6eb 100644
> --- a/arch/arm64/mm/kasan_init.c
> +++ b/arch/arm64/mm/kasan_init.c
> @@ -399,14 +399,12 @@ void __init kasan_init(void)
>   {
>   	kasan_init_shadow();
>   	kasan_init_depth();
> -#if defined(CONFIG_KASAN_GENERIC)
> +	kasan_init_generic();
>   	/*
>   	 * Generic KASAN is now fully initialized.
>   	 * Software and Hardware Tag-Based modes still require
>   	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
>   	 */
> -	pr_info("KernelAddressSanitizer initialized (generic)\n");
> -#endif
>   }
>   
>   #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
> diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
> index 41c635d6aca..ba2709b1eec 100644
> --- a/arch/riscv/mm/kasan_init.c
> +++ b/arch/riscv/mm/kasan_init.c
> @@ -530,6 +530,7 @@ void __init kasan_init(void)
>   
>   	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
>   	init_task.kasan_depth = 0;
> +	kasan_init_generic();

I understood KASAN is really ready to function only once the csr_write() 
and local_flush_tlb_all() below are done. Shouldn't kasan_init_generic() 
be called after it ?

>   
>   	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
>   	local_flush_tlb_all();
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> index 9adfbdd377d..544e5403dd9 100644
> --- a/arch/s390/kernel/early.c
> +++ b/arch/s390/kernel/early.c
> @@ -21,6 +21,7 @@
>   #include <linux/kernel.h>
>   #include <asm/asm-extable.h>
>   #include <linux/memblock.h>
> +#include <linux/kasan.h>
>   #include <asm/access-regs.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/machine.h>
> @@ -65,7 +66,7 @@ static void __init kasan_early_init(void)
>   {
>   #ifdef CONFIG_KASAN
>   	init_task.kasan_depth = 0;
> -	pr_info("KernelAddressSanitizer initialized\n");
> +	kasan_init_generic();
>   #endif
>   }
>   
> diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
> index 0539efd0d21..998b6010d6d 100644
> --- a/arch/x86/mm/kasan_init_64.c
> +++ b/arch/x86/mm/kasan_init_64.c
> @@ -451,5 +451,5 @@ void __init kasan_init(void)
>   	__flush_tlb_all();
>   
>   	init_task.kasan_depth = 0;
> -	pr_info("KernelAddressSanitizer initialized\n");
> +	kasan_init_generic();
>   }
> diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
> index f39c4d83173..0524b9ed5e6 100644
> --- a/arch/xtensa/mm/kasan_init.c
> +++ b/arch/xtensa/mm/kasan_init.c
> @@ -94,5 +94,5 @@ void __init kasan_init(void)
>   
>   	/* At this point kasan is fully initialized. Enable error messages. */
>   	current->kasan_depth = 0;
> -	pr_info("KernelAddressSanitizer initialized\n");
> +	kasan_init_generic();
>   }


