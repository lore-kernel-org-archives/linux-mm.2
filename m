Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3703DC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C066B008C; Fri,  8 Aug 2025 03:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733DC6B0093; Fri,  8 Aug 2025 03:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670C76B0095; Fri,  8 Aug 2025 03:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5D36B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:21:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 053015F863
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:21:42 +0000 (UTC)
X-FDA: 83752745286.02.E0E3D7D
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf30.hostedemail.com (Postfix) with ESMTP id C6C358000D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:21:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754637701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/QklETFhE/HaMV63Zcte41AoyA4FbhUpoG+hqiHyGs=;
	b=lSV4dDsdG3RoFMAVfscRLbF5S+RRyOxHJuVd9GXHdlD/4bxMU070tpcsJtuyto5xf/Phpl
	yx2Ml+lpyQsZ5jiPcs+0Vs1KI7DybMRlInrYyq+aQ07WPI5WTaHjnC4ZzcnMipL/rb2QGB
	6hFHkM38XmC0Nz3fXzK10UrRGj2OiuA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754637701; a=rsa-sha256;
	cv=none;
	b=I1g7GTojfKUH6qdAovsH0aYY39fnmBljXzzxqiQRskSkOXwaGBCyVmOHfLX1dZXS/k5Lxw
	MeQGYqxmRWsa/fvHwfy0IKD3SeTDD+ZXRTXdeNpy2ZS2qL+CxyKuhgbq53Gg4PCibxCe0m
	ZcsEeNoxbHP2Z7BT6nB4zBFzS95etFA=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 37190443D6;
	Fri,  8 Aug 2025 07:21:33 +0000 (UTC)
Message-ID: <7487516c-3eb1-46fa-aed5-6dc72600c952@ghiti.fr>
Date: Fri, 8 Aug 2025 09:21:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] kasan: call kasan_init_generic in kasan_init
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: ryabinin.a.a@gmail.com, bhe@redhat.com, hca@linux.ibm.com,
 andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, davidgow@google.co, glider@google.com,
 dvyukov@google.com, agordeev@linux.ibm.com, vincenzo.frascino@arm.com,
 elver@google.com, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20250807194012.631367-1-snovitoll@gmail.com>
 <20250807194012.631367-3-snovitoll@gmail.com>
 <07ffb27c-3416-43c9-a50a-164a76e5ab60@csgroup.eu>
 <CACzwLxhahYWfRc5xKshayniV6SuFFnMT0NfHttippcASzZgtRw@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CACzwLxhahYWfRc5xKshayniV6SuFFnMT0NfHttippcASzZgtRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduvdefudelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeduffeugedvtdegleeuhfeuteetueegfeefkefhheffvdduhfegvdehuddukeffgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhinhhfrhgruggvrggurdhorhhgnecukfhppeduleefrdeffedrheejrdduleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepudelfedrfeefrdehjedrudelledphhgvlhhopegludelvddrudeikedrvddvrddutddungdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopedvhedprhgtphhtthhopehsnhhovhhithholhhlsehgmhgrihhlrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhphhgvrdhlvghrohihsegtshhgrhhouhhprdgvuhdprhgtphhtthhopehrhigrsghinhhinhdrrgdrrgesghhmrghilhdrtghomhdprhgtphhtthhopegshhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehhtggrsehli
 hhnuhigr
 dhisghmrdgtohhmpdhrtghpthhtoheprghnughrvgihkhhnvhhlsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeiihhgrnhhgqhhinhhgsehlohhonhhgshhonhdrtghn
X-GND-Sasl: alex@ghiti.fr
X-Stat-Signature: ouxyq8hpkrdwz83agrhayawqr9bs4354
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6C358000D
X-Rspam-User: 
X-HE-Tag: 1754637700-388598
X-HE-Meta: U2FsdGVkX1/3S0R6Ls8+NWZq8Lz2j/MyfwXyJx4IZYhYTBWPlFtSOjtYUH/tn0FUZ+OqbHQojilMtU2WkTEjrLtSUsV1GyAlKk6Zf4p2E7lev9p6+Idp31ZxOeVS/94hK8wcIDG43t6b/FDTbsUB3aje+yU98cdb5IKGokPjREEg3J3OAXQp4QTJHNAPw1hMdQ6xoqlIQphbI5fopcscqyTr29jouQoZ+JV2SF0TLTIGUyGcwF8AQ98heEiS9NW8VFjNaRrUCoWJrDP0LMOOmyLs+jVUE9h04V8KwSUbPCXxcO1fIHiZP4ze7NcLzHjauzsxM66BCOyxzCWUnjIwwxRpAfHJI6wWsQbQsJClR7EwpJZk/VPUpu1JYhVR8m1x9Vgix6xFl4hkVAh15R4UJr/7trlmteOZXIYsPeqKlhUqYxmDmLmqXROcpHHgVCKURbUi/mY012GtuQ1n9I1nUfhYQx3n6z8K1wxQuF9y/qHP0Qe18LZTR+3ZqFgeAVm+lvSvTUetdT1X7sx64JRDrFYWLWggciMJXlnV5QCbEQrs5LVAb6SxHZGttMpZYlvn3r+e3eOIzY1ancpHlFPoX7POkN8XveHZmVMHm1yq6NfJWrOBaE7u3rdJ3SGJfwLyILtDIoS7gqA8l3mT27KzGq7O2AzBy1Yro3FljgmauLCHOfuB8Yv25jhxmvCFO+e110eYSPYQsqOWu0RTgBnVTfoeOne+A+97kn9rvpIj/l6Z2LfZakb5H9ijq/vaJTbpkoryP/TH/RsLaOTnc9TN5guVVGnts4gkZRoLZv4QHKpGaYhJjNNG3vuqUITTqwVtH3IYs2YW4feVQMagefBHW8FmPJM5XKibfVtkJfik2pTDyjW6L7/nkX2KLyOjl1ggSC4D0O7Iqhl8IK75GWpw/1D+fYT0fRXw/rEb1+/fC0iGjTJG5XAgkwmTnmI6PNgI5WSDixJZ6rD3GoXpXGa
 Mfk4QQZK
 FmTfACHONZyqpPl8ueC29WhjJ40mnyMFWKIGPvpYHv7leN358iel8Jqlp9/Bdr7sDQcafjb6OwtYIMWcJ5ecRTOqmfn8MDe93denl+EwHZmh63AerjfL8/8oaHy0HBLaLO0jMn1HekG/Z/hFVLCHE8maYmGAXKkGW1v0p+NiW6uxjYRQyFjuhN3F1ZdL21LmEyKiE8BukRbOjPxuApL1hZIn5KJtNDk1+n7mwl7FxDePkHDMTKa5rzD46stpfxDfuDjlUb38LbH28g/zFY5ierNwtMm974HyAVpV5sSjp31d6yCgQkKPM1nbq0Do0g0sV+OQDtoAzfYqjTZho+WxzLdrMd+ByvfbCW4MUJf5JvxvP5X/3YsBvccBPWzva8W5hmJQz39hNLfuoyd/vMgK+nv4XrbClv9ngRytQNs1m/fWQcz9/3RfrsN5bf1ddCDSm+v3A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/8/25 08:44, Sabyrzhan Tasbolatov wrote:
> On Fri, Aug 8, 2025 at 10:07 AM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>>
>>
>> Le 07/08/2025 à 21:40, Sabyrzhan Tasbolatov a écrit :
>>> Call kasan_init_generic() which handles Generic KASAN initialization.
>>> For architectures that do not select ARCH_DEFER_KASAN,
>>> this will be a no-op for the runtime flag but will
>>> print the initialization banner.
>>>
>>> For SW_TAGS and HW_TAGS modes, their respective init functions will
>>> handle the flag enabling, if they are enabled/implemented.
>>>
>>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
>>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>>> Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
>>> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
>>> ---
>>> Changes in v5:
>>> - Unified arch patches into a single one, where we just call
>>>        kasan_init_generic()
>>> - Added Tested-by tag for riscv (tested the same change in v4)
>>> - Added Acked-by tag for s390 (tested the same change in v4)
>>> ---
>>>    arch/arm/mm/kasan_init.c    | 2 +-
>>>    arch/arm64/mm/kasan_init.c  | 4 +---
>>>    arch/riscv/mm/kasan_init.c  | 1 +
>>>    arch/s390/kernel/early.c    | 3 ++-
>>>    arch/x86/mm/kasan_init_64.c | 2 +-
>>>    arch/xtensa/mm/kasan_init.c | 2 +-
>>>    6 files changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
>>> index 111d4f70313..c6625e808bf 100644
>>> --- a/arch/arm/mm/kasan_init.c
>>> +++ b/arch/arm/mm/kasan_init.c
>>> @@ -300,6 +300,6 @@ void __init kasan_init(void)
>>>        local_flush_tlb_all();
>>>
>>>        memset(kasan_early_shadow_page, 0, PAGE_SIZE);
>>> -     pr_info("Kernel address sanitizer initialized\n");
>>>        init_task.kasan_depth = 0;
>>> +     kasan_init_generic();
>>>    }
>>> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
>>> index d541ce45dae..abeb81bf6eb 100644
>>> --- a/arch/arm64/mm/kasan_init.c
>>> +++ b/arch/arm64/mm/kasan_init.c
>>> @@ -399,14 +399,12 @@ void __init kasan_init(void)
>>>    {
>>>        kasan_init_shadow();
>>>        kasan_init_depth();
>>> -#if defined(CONFIG_KASAN_GENERIC)
>>> +     kasan_init_generic();
>>>        /*
>>>         * Generic KASAN is now fully initialized.
>>>         * Software and Hardware Tag-Based modes still require
>>>         * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
>>>         */
>>> -     pr_info("KernelAddressSanitizer initialized (generic)\n");
>>> -#endif
>>>    }
>>>
>>>    #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>>> diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
>>> index 41c635d6aca..ba2709b1eec 100644
>>> --- a/arch/riscv/mm/kasan_init.c
>>> +++ b/arch/riscv/mm/kasan_init.c
>>> @@ -530,6 +530,7 @@ void __init kasan_init(void)
>>>
>>>        memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
>>>        init_task.kasan_depth = 0;
>>> +     kasan_init_generic();
>> I understood KASAN is really ready to function only once the csr_write()
>> and local_flush_tlb_all() below are done. Shouldn't kasan_init_generic()
>> be called after it ?
> I will try to test this in v6:
>
>          csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
>          local_flush_tlb_all();
>          kasan_init_generic();


Before setting the final kasan mapping, we still have the early one so 
we won't trap or anything on some kasan accesses. But if there is a v6, 
I agree it will be cleaner to do it this ^ way.

Thanks,

Alex


>
> Alexandre Ghiti said [1] it was not a problem, but I will check.
>
> [1] https://lore.kernel.org/all/20c1e656-512e-4424-9d4e-176af18bb7d6@ghiti.fr/
>
>>>        csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
>>>        local_flush_tlb_all();
>>> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
>>> index 9adfbdd377d..544e5403dd9 100644
>>> --- a/arch/s390/kernel/early.c
>>> +++ b/arch/s390/kernel/early.c
>>> @@ -21,6 +21,7 @@
>>>    #include <linux/kernel.h>
>>>    #include <asm/asm-extable.h>
>>>    #include <linux/memblock.h>
>>> +#include <linux/kasan.h>
>>>    #include <asm/access-regs.h>
>>>    #include <asm/asm-offsets.h>
>>>    #include <asm/machine.h>
>>> @@ -65,7 +66,7 @@ static void __init kasan_early_init(void)
>>>    {
>>>    #ifdef CONFIG_KASAN
>>>        init_task.kasan_depth = 0;
>>> -     pr_info("KernelAddressSanitizer initialized\n");
>>> +     kasan_init_generic();
>>>    #endif
>>>    }
>>>
>>> diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
>>> index 0539efd0d21..998b6010d6d 100644
>>> --- a/arch/x86/mm/kasan_init_64.c
>>> +++ b/arch/x86/mm/kasan_init_64.c
>>> @@ -451,5 +451,5 @@ void __init kasan_init(void)
>>>        __flush_tlb_all();
>>>
>>>        init_task.kasan_depth = 0;
>>> -     pr_info("KernelAddressSanitizer initialized\n");
>>> +     kasan_init_generic();
>>>    }
>>> diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
>>> index f39c4d83173..0524b9ed5e6 100644
>>> --- a/arch/xtensa/mm/kasan_init.c
>>> +++ b/arch/xtensa/mm/kasan_init.c
>>> @@ -94,5 +94,5 @@ void __init kasan_init(void)
>>>
>>>        /* At this point kasan is fully initialized. Enable error messages. */
>>>        current->kasan_depth = 0;
>>> -     pr_info("KernelAddressSanitizer initialized\n");
>>> +     kasan_init_generic();
>>>    }
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

