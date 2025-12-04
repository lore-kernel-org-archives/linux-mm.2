Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82B6D21686
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5376B6B009F; Thu,  4 Dec 2025 09:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F656B00A5; Thu,  4 Dec 2025 09:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425536B00B4; Thu,  4 Dec 2025 09:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3217D6B009F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:51:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF697139A45
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:51:07 +0000 (UTC)
X-FDA: 84182076174.12.783DDE7
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE2D540009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:51:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SG8v1Ojr;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764859865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ow5IwXw2xGmPvayEhI3mpOX/A9rxj1tnVvZcYdHjxYE=;
	b=he6HW2H7wrTaxgJmKcvg4DpuK7zVtv8oxjqxW+2Oby5MhyY1hVwXoMTERTzp1jxH9l9dsx
	t2fFMpetcYN7GjkcYd4vsbIBjLh5lCILeU2wTfkhpH0YyzQB37CsKL0Fk3cCeY1AJElyno
	ElAz3N1g0kzaqMmr2mN72zvGR3zIayo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SG8v1Ojr;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764859865; a=rsa-sha256;
	cv=none;
	b=AddR7E1c+yY7RCASmReW35srZIs4fRqL5oRYUTzrMpN70Bcl6zmjMTmjGAixsXy0o+5pru
	LmGZRH0pH0Cs0hXwd7XkUC/B7Tg+K1PrWsSJF/uqqOr5xq8fFbmjVbwuwnBEh5DlVwBfyO
	ABohgpQmTSMJ6HXQU36zlUUFa0snKyk=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so649445f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764859864; x=1765464664; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ow5IwXw2xGmPvayEhI3mpOX/A9rxj1tnVvZcYdHjxYE=;
        b=SG8v1OjrjQ1Gc8Rc0yHWkTac4AUQnvjDcXypBeOVXiNPSzl22Mm8uMt4fyopeIguoM
         9nOLO4+pYkZnFXVgIkppEtJcfPeYAlFc41f+boYAdlKETFxHRD5DyKQClTSsZjvpsLd7
         xiJYMgOb7/hD8L78ubRjBHF9G0ADkg/+lOceuy7htG4QTDBmpTwJstnwF2GuT5iC+1X4
         iJ7YEYb/tQFhbJa3J1xT7xhr5syzwNPS55EFBpWenXfb/xn+YbjgsUJ9AdJ/diV4MnHW
         FCLMK+HtZ/p6yCzonuS7xXvNmJuxyRQAaKRobS6PzW211Qe9e8phjy1FTsGK+CVgOiOC
         40UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764859864; x=1765464664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ow5IwXw2xGmPvayEhI3mpOX/A9rxj1tnVvZcYdHjxYE=;
        b=ZR2ixEMQLGHNISG5MQSn6hSLmq4P5PN825yr1Y/70Yk5nWwazaYr2kdeYtb1Bf31eG
         w4ADPjEeYJu8M7pEcssHqwwvrJdrgiVkmXfKvAEqaf/qzzk7zSUeRUPsMVcuXEXKKn2m
         VHuOTgKsanr5mMetNf8nUEDmatq8NmUb5ltHPzr7aa15q9GtizlXo2JTC03pJLGmvPsx
         BdGtzan5Hr3MEg6NEo+/9+zVpo9Qo/L4uuvb1CLRfiD7RbTh6WkvtI25FcZzCOMs4DYT
         5Tm5weJhYAPR+J4hMOFYY7byVkziZf3oqBIN5YB9630gH9r+Qmcb3UsPS3T040enBZhn
         p4QA==
X-Forwarded-Encrypted: i=1; AJvYcCU7YEQjm9q26IYNRxxBubWVJgTXjLdPEy5sK3/GgvmPpHEe20a0szOpaWMLPmlATSyBfvcaDem47A==@kvack.org
X-Gm-Message-State: AOJu0YweO+Lhcuou6PDGwfr5NuJnn2qzCvBLliIMyM5mOnEOd7o8t8Zi
	X3BnALguSn0uVsLZmprNJkA8/da9e2J0+sWBwzMbx0EFYfXlrzjFS6XD
X-Gm-Gg: ASbGncsL8NOZZo9NnkJHxPFIpFbztpnrtv2WAyUAZOoTUGBxYTdMwzyTHLIfhHDv+Bu
	QksSvbRn8iYos9JZM7WAUA7wuadxHCSAkbVWe/P5htkgLs74AV8QXVVjbXhrlTlhMgbvZa/PXrW
	gFMao4ulxhBkk5+d7yqb5Jr9J86uHDkVjKQL3hyciYuyBTy/5EXAtudidqndz7cdZD1IpTqp/2m
	AgptIT1NN75zjH4cm2zol/clFE2JtGcKtaXLT3b/APGHPyeTom8jJj8ZlAPrqnWtOszdHyi3pdN
	cQ9qnKuTeEnfMZ4svIcZywK+1jSBr9uBWHWfhmRqNKnKQT3JaRvMHGh2K+dJ4fw/kO8hRPfQlR+
	JmluG01raAYv3GkvkocFzxaozG67lL+muif13BOLNvRM4NUw7xlIu8angiYeGyG779Z1yq8TjtI
	1Ovw+QRszlj6IEOoAbnH8QpVztQmnKwRzDr933+f7a79a4ORTT/TNPEeiV+Az51DI=
X-Google-Smtp-Source: AGHT+IGvV1Zswwu1oJG2QS2fyLuIDHh1tQIO2KS4R5I6TQImGVCLVLw7PButGZXPhz76RrnPilswUQ==
X-Received: by 2002:a05:6000:2c08:b0:428:52c7:feae with SMTP id ffacd0b85a97d-42f79848239mr3355142f8f.32.1764859863970;
        Thu, 04 Dec 2025 06:51:03 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1126:4:ce0:a4eb:eabc:d420? ([2620:10d:c092:500::7:99d1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3763136f8f.13.2025.12.04.06.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 06:51:03 -0800 (PST)
Message-ID: <f1ee34be-44fd-4286-8b02-f69d3a2dbd26@gmail.com>
Date: Thu, 4 Dec 2025 14:51:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Content-Language: en-GB
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
 changyuanl@google.com, graf@amazon.com, leitao@debian.org, thevlad@meta.com,
 pratyush@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com>
 <aSwFwMVyFcPlOR10@kernel.org>
 <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ymm9efbwnuomohxfowee4gs83qtdkmur
X-Rspam-User: 
X-Rspamd-Queue-Id: BE2D540009
X-Rspamd-Server: rspam09
X-HE-Tag: 1764859865-863553
X-HE-Meta: U2FsdGVkX19L3tfMKsSmOyRJ4HyaGtSbmG82rtKWsLeVDqWKIsl8WyStq9XdBKiUVVY/MzoeJP5DmXIY8aKvAmsruV5phFwo03hI9WyXwo2uGY2EmgiwtvMAO9mw42gJLicrpkJEUJefbG26vzDOFPPUk4KaHobZ7EInFDPEzhIdTr4/Qr4QQVOMdq+olbaqzlsomq/eKr0WpMhrRMEAFz+BuyXydl6E70kr2SoeVhviNNz3kjLYVN9Uz8fj6lc5kgtlc6PSfIMuCicDNKetT/XSxMHkIB1pnX8CoKJZ6cIZ2zTPuT5XEU7Noc0G5sFqR7/kNj65Z46t4FKgicVb1CPGd1Ay6+g2l7IbucmsDDu/f/FAFD0cFNxmkSdmpSHD46T86re/EmeEHfDrYi9daEq3AxUNAltBHdF4zfd7Xc9loQhjr7htPKDuQWbYrqjDnXznezd8CxH6+oZz84hh19HWP/C0BAvq/yAz8fm5NzxFP/tV3ZMBn7SWkLE7haLQm2L55cFnQ8KoOM3LDfKDgJK4uDkbbDSG8R5SLjj8xtPs4oVyl0y+Qb45eHoNjeJEHjJoK2zWtuLyf0NY9YlHgvNOFNGcgQmwWIJLq8n8mYSngYmO0d4WGd3NuRpd0C+uK44yxMolx30zKrhAKixE1h2tZXNwr701KxJ8wXrwdsY+MU6pWQZf725NSYLdFzHeL85R1p95gyPMwYonU38PJWHX/bLrKSlXsiGP1EZKnZpRw8A8NHoceceWjCgj1c1djf7VaRPuhZbAhMSRXV2+3F9pT8QIAkRrku5LJlXmUFDvUe7hAoBq0FSOc+FAPIPws66+P03ipRF9JB5Oy5mkWn3tvkMVF8kqiGrw6BR9QCt7ybNIeP9haRTuEp/T5LLCNv+H3eWH9cgJzabysWrbp8TRrK+y69SvWHcBw+nG+kp+FqMJpZ2BugS6D4JBjAmLiTnUmxYigsYtO80HQDT
 RVaeq4z6
 s0ATbp2tU3unwkHvqKIiIhlTeJQwNikSlJGlvLvQzLQ/FmeAeXRoqhMzK5AVlf7DXR0k3zIIEAg5FPQQAtiPRODzprXOV7rFjQNx8Inf96de7c7NHExDehW7pGnceipvIAyHMHclkiFMTE3HO7Z64vIl6dWCtj41Txx85XLwTeF1cz+OQnTMfezM6e/xTuL/aB1/Ft6CtloYghjYn1ZpkkuXJX7PvrxjOHYB0mCqhfqzLHS5beC3vpD1FeywOAq/TAZAomsPPhMG9bGpU/87XG6WTnK97xdMUeym9yFnuV2cFYRqAOM6Q/EgYW3RWcE4gw/WmIsl2yFHe+r8KQTpuovRX3zVcmsnmJ0IBrR/Yn9Be1ZVhkiUc4+u6kFxFVQFvDGtbWZZG+/lT92BKE1W7vPTsbrGcQ8FYAEBQ+X0xvm4Stnpz9os0H24FhXdYe9IpTSRVZtyU3ak0uOnBtx1PByzu3+iJCg87FlbeV+6EUqy0SDKEuc+SETqP1KhDKfcxqRkwbNyv1N7NCNQWQ6sbFsvY501nyfTwTgIz/Gx3l5MTYHA5eUOGmXaXUT2HlfRDQGQZjkZ3dQpEqq/fH6KL/l7NKYSV2/Xztf0T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/12/2025 14:04, Pasha Tatashin wrote:
> On Sun, Nov 30, 2025 at 3:52 AM Mike Rapoport <rppt@kernel.org> wrote:
>>
>> On Fri, Nov 28, 2025 at 05:29:34PM +0000, Usama Arif wrote:
>>> The scratch memory for kexec handover is used to bootstrap the
>>> kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
>>> hack to get around limitations with KHO. It is only needed when
>>> CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
>>> (both checked by is_kho_boot). Add check to prevent marking a KHO
>>> scratch region unless needed.
>>
>> I'm going to rewrite the changelog and queue this for upstream:
>>
>> The scratch memory for kexec handover is used to bootstrap the kexec'ed
>> kernel and it is only needed when it is a KHO boot, i.e. a kexec boot with
>> handover data passed from the previous kernel.
>>
>> Currently x86 marks the first megabyte of memory as KHO scratch even for
>> non-KHO boots if CONFIG_KEXEC_HANDOVER is enabled.
>>
>> Add check to prevent marking a KHO scratch regions unless they are actually
>> needed.
>>
>>> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
>>> Reported-by: Vlad Poenaru <thevlad@meta.com>
>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> 
> This patch causes panic with my tests in linux-next.
> 
> [    0.000000] Kernel panic - not syncing: Cannot allocate 17280 bytes
> for node 0 data
> [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
> 6.18.0-next-20251203 #2 PREEMPT(undef)
> [    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 0.1 11/11/2019
> [    0.000000] Call Trace:
> [    0.000000]  <TASK>
> [    0.000000]  ? dump_stack_lvl+0x4e/0x70
> [    0.000000]  ? vpanic+0xcf/0x2b0
> [    0.000000]  ? panic+0x66/0x66
> [    0.000000]  ? alloc_node_data+0x32/0x90
> [    0.000000]  ? numa_register_nodes+0x82/0x100
> [    0.000000]  ? numa_init+0x36/0x120
> [    0.000000]  ? setup_arch+0x667/0x7f0
> [    0.000000]  ? start_kernel+0x58/0x640
> [    0.000000]  ? x86_64_start_reservations+0x24/0x30
> [    0.000000]  ? x86_64_start_kernel+0xc5/0xd0
> [    0.000000]  ? common_startup_64+0x13e/0x148
> [    0.000000]  </TASK>
> [    0.000000] ---[ end Kernel panic - not syncing: Cannot allocate
> 17280 bytes for node 0 data ]---
> PANIC: early exception 0x0d IP 10:ffffffff89007a13 error 763 cr2
> 0xffff991090a01000
> 


Thanks for reporting this and sorry for the bug!

So the patch was designed to remove the memblock_mark_kho_scratch in e820__memblock_setup if not
in KHO boot. But it broke memblock_mark_kho_scratch in kho_populate.
Moving kho_in.fdt_phys = fdt_phys to before the memblock_mark_scratch
should fix it. I dont have a setup where I can easily test KHO, but I think below
should fix it?

TBH using fdt_phys to check if the boot is KHO might be a bit hacky? Is it possible
to have a better check for this?


diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f1..c331749e6452e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1483,6 +1483,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
                goto out;
        }
 
+       kho_in.fdt_phys = fdt_phys;
        /*
         * We pass a safe contiguous blocks of memory to use for early boot
         * purporses from the previous kernel so that we can resize the
@@ -1513,7 +1514,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
         */
        memblock_set_kho_scratch_only();
 
-       kho_in.fdt_phys = fdt_phys;
        kho_in.scratch_phys = scratch_phys;
        kho_scratch_cnt = scratch_cnt;
        pr_info("found kexec handover data.\n");
@@ -1524,7 +1524,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
        if (scratch)
                early_memunmap(scratch, scratch_len);
        if (err)
+       {
+               kho_in.fdt_phys = 0;
                pr_warn("disabling KHO revival: %d\n", err);
+       }
 }
 > 
>>> ---
>>>  mm/memblock.c | 14 +++++++++-----
>>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/memblock.c b/mm/memblock.c
>>> index 8b13d5c28922a..913cf322eb89a 100644
>>> --- a/mm/memblock.c
>>> +++ b/mm/memblock.c
>>> @@ -20,8 +20,8 @@
>>>
>>>  #ifdef CONFIG_KEXEC_HANDOVER
>>>  #include <linux/libfdt.h>
>>> -#include <linux/kexec_handover.h>
>>>  #endif /* CONFIG_KEXEC_HANDOVER */
>>> +#include <linux/kexec_handover.h>
>>>
>>>  #include <asm/sections.h>
>>>  #include <linux/io.h>
>>> @@ -1126,8 +1126,10 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>>>   */
>>>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>>>  {
>>> -     return memblock_setclr_flag(&memblock.memory, base, size, 1,
>>> -                                 MEMBLOCK_KHO_SCRATCH);
>>> +     if (is_kho_boot())
> 
> Looks like memblock_mark_kho_scratch() is called before is_kho_boot()
> is working:
> 
> [    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
> [    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
> [    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
> [    0.000000] KHO: kho_populate: is_kho_boot: 1
> [    0.000000] memblock_mark_kho_scratch: is_kho_boot: 1
> [    0.000000] memblock_clear_kho_scratch: is_kho_boot: 1
> ...
> 
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1514,6 +1514,7 @@ void __init kho_populate(phys_addr_t fdt_phys,
> u64 fdt_len,
>         memblock_set_kho_scratch_only();
> 
>         kho_in.fdt_phys = fdt_phys;
> +       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
>         kho_in.scratch_phys = scratch_phys;
>         kho_scratch_cnt = scratch_cnt;
>         pr_info("found kexec handover data.\n");
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 87e7495a68c1..f55b5cdba5dd 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1126,6 +1126,7 @@ int __init_memblock
> memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>   */
>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> +       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
>         if (is_kho_boot())
>                 return memblock_setclr_flag(&memblock.memory, base, size, 1,
>                                             MEMBLOCK_KHO_SCRATCH);
> @@ -1142,6 +1143,7 @@ __init int memblock_mark_kho_scratch(phys_addr_t
> base, phys_addr_t size)
>   */
>  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> +       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
>         if (is_kho_boot())
>                 return memblock_setclr_flag(&memblock.memory, base, size, 0,
>                                             MEMBLOCK_KHO_SCRATCH);
> 
>>> +             return memblock_setclr_flag(&memblock.memory, base, size, 1,
>>> +                                         MEMBLOCK_KHO_SCRATCH);
>>> +     return 0;
>>>  }
>>>
>>>  /**
>>> @@ -1140,8 +1142,10 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>>>   */
>>>  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>>>  {
>>> -     return memblock_setclr_flag(&memblock.memory, base, size, 0,
>>> -                                 MEMBLOCK_KHO_SCRATCH);
>>> +     if (is_kho_boot())
>>> +             return memblock_setclr_flag(&memblock.memory, base, size, 0,
>>> +                                         MEMBLOCK_KHO_SCRATCH);
>>> +     return 0;
>>>  }
>>>
>>>  static bool should_skip_region(struct memblock_type *type,
>>> --
>>> 2.47.3
>>>
>>
>> --
>> Sincerely yours,
>> Mike.
>>


