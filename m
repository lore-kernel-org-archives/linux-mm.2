Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4303C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C2E6B00FC; Mon, 11 Aug 2025 01:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CA46B00FD; Mon, 11 Aug 2025 01:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704746B00FE; Mon, 11 Aug 2025 01:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9D36B00FC
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:39:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E04D116B99
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:39:08 +0000 (UTC)
X-FDA: 83763373176.10.E6D7994
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id E12128000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:39:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754890746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1+62RvIlGZfmQnxVgcVSsABjdaj8FSJ42aUXvVPiGuY=;
	b=fRo2NLAXoou/GZ504Cyj7KLToBrYt91ZmQl3gX/Q8u8N7/c7JucWkSDtPDnC0y+LoRty4f
	uAqQFTbfUIqCprNu+TcnA8TeG3i4NFTtxAW3Dgr7/aPaKNgE9IqjgnI1Jjo+fbhXEsPJpD
	9zQjyjfc8DCs7icRpNCDETo9aD5E6Qg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754890746; a=rsa-sha256;
	cv=none;
	b=EHTMFL7xXnZl6QNCeooSjbGPThVlLXM54k2a8JY2UMtQVd8z5PGgX37ZwmFseqpd9ak8/5
	pwjZDAkmkDyRQTrKj6BWTOfZ66fy26CMcFRPw80iAgkCGnwO/eqTQ9QPWSi6H6zVFBvSXg
	KQoC9kYjMWOuf8eJE8S1HTU07pzVybs=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c0k2w2kRcz9sSL;
	Mon, 11 Aug 2025 07:39:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Mxf0H61E1tl; Mon, 11 Aug 2025 07:39:04 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c0k2w1bMnz9sSK;
	Mon, 11 Aug 2025 07:39:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 199008B764;
	Mon, 11 Aug 2025 07:39:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id bIxmuQ19phXS; Mon, 11 Aug 2025 07:39:03 +0200 (CEST)
Received: from [10.25.207.160] (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BAC418B763;
	Mon, 11 Aug 2025 07:39:03 +0200 (CEST)
Message-ID: <b8345cfe-0bde-44cd-b9b7-9a946ff8fc36@csgroup.eu>
Date: Mon, 11 Aug 2025 07:39:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] kasan: call kasan_init_generic in kasan_init
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, ryabinin.a.a@gmail.com,
 bhe@redhat.com, hca@linux.ibm.com, andreyknvl@gmail.com,
 akpm@linux-foundation.org, zhangqing@loongson.cn, chenhuacai@loongson.cn,
 davidgow@google.com, glider@google.com, dvyukov@google.com,
 alexghiti@rivosinc.com
Cc: alex@ghiti.fr, agordeev@linux.ibm.com, vincenzo.frascino@arm.com,
 elver@google.com, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250810125746.1105476-1-snovitoll@gmail.com>
 <20250810125746.1105476-3-snovitoll@gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250810125746.1105476-3-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E12128000B
X-Rspamd-Server: rspam06
X-Stat-Signature: p98r8e9pefmh6ud4joe7kxmbrboa3kq9
X-HE-Tag: 1754890745-826239
X-HE-Meta: U2FsdGVkX19KkJ9c0L8PzMa33eNxRUa+SP6CdYjcb/TJyEfewaK8zag6tZpq22kMsLuoTrAhHCnvFdws3fDRSv+nJjn0lpcfSjoAB/wH0bhxybLMS1pOuuIaN+swh8j2DAZp2c0nDwQF3UGQXw3l5rDu9s3SkjfR9w4L7vQyEA1X48BfUkVvUqq6Wfa8ZUUXEmzNuI6vUTAtnyCnNlhhlbZ96rMVtdFUbqyWDK7K9jdGtazulz1PXFBmMLnchFhrk7D2kqjiet0QuLt7IUF5AzAli0OOOCI8UZYmW9VqcszwjYOcedLU47s5RnZHz6LKTBHs6Xtbqv4KFNxIhPOLftXHLJp9/3tS1EvhRVbSdJinQWiYDxCydYh5mlyg6vNAJL7XD5W+J8MfUKdBMl7k2002Ip3P4q4SR03wKBSs6DlnFBIz5esWIQr4fGUYLyo0Bw9jfIDQeQBHFxRCSIQDYYipB8DNgzhYWag1WtooFW9/AEcNuRLJbwGEyKXpSBtzs0oXGz1/JSYGBrEB8G8IYEWjCFAAHMr+1DTBBrMRMvqTBlwD8rwIJHpB6rZWhtDYjOSXYaVWutMu5lGBK5oQ/Ncpf4l7jVxFW1K3SWxqnFSOB8G1Vaf7uTfXeffKRCCD8vHaDjwjMwgt7/dhm0CJKaHqHmLHRc0caoSfQA+u1rRl1sVPVehnilsAWISIZL49DkhDsa9V7WafzEqqBFU6BgV0iVo8V5Wxs3xzw/gBPBwCEfIxlBKjO/2xzOqBZgcVIGXwmBCfERAbGfY+kHHPioV+lrn1YtM1McD0aBgA8JGPqT0rTXGMvPXbzbjLYLeZSVO4/Vw/IyqKQzzMbGp0PsEy/keGaGtnYN3/L7dakLop8vdjbnjsCJ/VTenzQr9rg2e6710cdr1NVjE5UUj8HUNz7HM2KAA1m5iwnoF+lHVr4OcuBkMuieMd5F+NH1eaG34Bms1/E5n5uX69TeU
 JDbhFLW2
 MoLae8xfrHbD4FiC+BhOudycI5SLg6Ou2kxV7ZR/Bb//kx8KQyR7h8JeLGgshqe/hpdzHA1G7LfYoHJukdDhTsN48C/frbc4d2qJ1zGA1pgGwDUTR7HJChgjuQdLv+hAhoiYqXtncupZJH+UkTsQcxbz2DdP7S490G639dLfbP3ZRGOBlqntO1ZR+MBcDqvD56yeYtpvuz1lQV5IZj8ZDnyqH3U+U+d8XuaZbJWhsfLtQo9zVK2soP0yXvdjd+VQQ0r7iOpkixyzeyl/zZ3+Oa5rwGrLPNu/tl2M6Ux58YqnlS5q/Fr8ZGoVgzJi3ncX1SGyOE0Ga2BtC4LEuezL71A1Z+odux+4mZDhmC3AsSPycr0ceHVnJwYixq3l95Z1xBRhp0hWzy+IA+4WvpDE1V4S3H10/UCOj7qUnZipJ0lSx6dCSSaJX2F7Bdsn9v3qwHbLBg4COzAGWIKzOAF5VSFDDPJUx/W25uqJYdEfb9JsXwfij2x3O/6Kqeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 10/08/2025 à 14:57, Sabyrzhan Tasbolatov a écrit :
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

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> Changes in v6:
> - Call kasan_init_generic() in arch/riscv _after_ local_flush_tlb_all()
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
> index 111d4f703136..c6625e808bf8 100644
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
> index d541ce45daeb..abeb81bf6ebd 100644
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
> index 41c635d6aca4..c4a2a9e5586e 100644
> --- a/arch/riscv/mm/kasan_init.c
> +++ b/arch/riscv/mm/kasan_init.c
> @@ -533,4 +533,5 @@ void __init kasan_init(void)
>   
>   	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
>   	local_flush_tlb_all();
> +	kasan_init_generic();
>   }
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> index 9adfbdd377dc..544e5403dd91 100644
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
> index 0539efd0d216..998b6010d6d3 100644
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
> index f39c4d83173a..0524b9ed5e63 100644
> --- a/arch/xtensa/mm/kasan_init.c
> +++ b/arch/xtensa/mm/kasan_init.c
> @@ -94,5 +94,5 @@ void __init kasan_init(void)
>   
>   	/* At this point kasan is fully initialized. Enable error messages. */
>   	current->kasan_depth = 0;
> -	pr_info("KernelAddressSanitizer initialized\n");
> +	kasan_init_generic();
>   }


