Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33DCCCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789518E013B; Tue,  4 Nov 2025 08:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760A88E013A; Tue,  4 Nov 2025 08:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FFF8E013B; Tue,  4 Nov 2025 08:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC728E013A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:14:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 024F4B6B60
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:14:01 +0000 (UTC)
X-FDA: 84072967524.06.7A77824
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 042511C000D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:13:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T56CV3Nk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762262040; a=rsa-sha256;
	cv=none;
	b=XEkUQvgb8woBIPK1tP8JxGLbhGGmB+eg56v+ZrjVN7BBOqcyN35mhKxW9ZZwAiEwquCDZb
	PYwOxeQwwIpidl8LV++hCBKhDrbbTlGLdrcOqrS6guug3mv74l6Qk0G2SLQ/eqOg4EXJX0
	jBKzV5kCZSMEQjiSSaZOyE6j9RS3Yo4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T56CV3Nk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762262040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htheXeHYFH0rHBiPohNUpeYbuuhI1fDU6CfL2d8wKps=;
	b=nO66F5Mxt+ly4nbFe5259YW1Dt9Ey77vKmO3QhS0ZxWlE7O2rjZqIUAh5Kymvqno/ZUCr3
	pXVOsyn0/ByVq4+H9Kln8OGDgorIerjiydhKRTL1ocIzEFVMPWJp+cAJuiYxKRNhVFFLnZ
	i04nk1k3xBi/8j8J64J2VaZUukd6XGs=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3407f385dd0so3582540a91.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 05:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762262039; x=1762866839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htheXeHYFH0rHBiPohNUpeYbuuhI1fDU6CfL2d8wKps=;
        b=T56CV3Nk6kTvgn5+Kfe/IX4OjvWxHNmlo0jlt9ntnUtHuQTo03UqvmDHIvz5rTIq/D
         c4k+/UW0N9pTilCMWE02vn8xsHZ1KnDeQzdNvnToiYDJH+bHjWzZSd5/ZTT4pdYsvNIU
         dmbXY9Fqv1Wa5ihqOd43uHWtW3QMhlLz9tmTfyZqVQuOeHNkAvPofENnP3Ahx5tkZ1rb
         BaTOkEKJLAlfs6j7SGvcOHMWaMClXpOe5nLn4rSyAIPsin3e3JdArcG17e6BpucE+9nb
         WLkEd3HnAiv2RqA5wQ33lwBXsuqtUwqVJLvPZZVoPI5/b4UkTYbXJsejYX7oo+Xt6IrQ
         Wrow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762262039; x=1762866839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htheXeHYFH0rHBiPohNUpeYbuuhI1fDU6CfL2d8wKps=;
        b=bwMmATZLvgEpiWvQlc6c43u46o3FwmnD5n08bgwaDPd4eA+WrQVMoNSPu8V6xk1Xt/
         gHbq4S401jh3gqlUIUoZLzWhSGsRKH+cd/hx3nb7jJ0/M4U7lNKxjY+wl23T/X7ujAtE
         Av89L8CmKRo0tIzBBWtFedfgcjo6WBk5o41KGmzJ86nav0THbfq89OM9sqKG5IR5C5hA
         rfIPYhqyqkkbKdhX8+HJGUDzPfBnl93xSNspprdsC7ro6YImxgml5kZlsy5Y2SYRNki0
         bwydUE78XslTPdmlp9J15P5SNp7NlkbCRTtdyHlJqzWjoGM4y3Bg9c9PjdvjWKTHwYqL
         8Zsw==
X-Forwarded-Encrypted: i=1; AJvYcCXtgiMc/vYPiiOqirQ7wYrGDG149d6A9BuVtJ4meNQf/xYZC4cQMRaYHnEFrlq+63HrpnUVeDcZ4Q==@kvack.org
X-Gm-Message-State: AOJu0YyAreZPOtfpHDtTa4U/Kml603PnqNE9Nk34gMin0gAo3hzfcWUE
	Gl8AIjC5lC5HFrunOmh0mLMlLV2TinnbtRGDXlU3tyLE9eYqMQbei9ao
X-Gm-Gg: ASbGncuOmJ/gaBFn9pq/6iRPJYgecx3ddKwAgk70fGw6pCR5kmrfR1AhGI5yqG7xKkE
	AeMyNP/bA5u7xQL5Pn/3eWatDXgDLbpQd0PydPNQ/hgCGrql4XApn2VvUMili93RSya9ILJ0kN+
	85GyRgC9IioXSdqeIZAYDvXng7moMgRi7sPx/rIO1H7ZGiYrKRqDuuZVIAhzZi4cpllzcXEJj84
	zFP1Zk/BO5wXGl/TDSmIi/4yCEwUI/VLmCbEoUj7/inejB9bBT9smUa9OCVSsYpcYaDWW6C4NzV
	RtMlnwsxqeEMGcTrhiMkufKMOu5o4n2W7FAslnavbGqVHJs65B0RZVZqHre4wtai9tqkDUe50tm
	iShWXfIyZHnAxMYbWeEO25cNsTvLQORE8QTEpffaAyWtGZDDWs+dfzR973S0T+Ou+VZE4T2MDty
	Gs4qTEdSTKu+Y9Fx06ug==
X-Google-Smtp-Source: AGHT+IHUCOHDOpY+jomk9+xhanjpsBEdHr6SPe8Xr4SpqUQogzIVi9n8mhwvDLW5yvR6G0BAdhVDBQ==
X-Received: by 2002:a17:90b:3c50:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-3408308ab16mr21572001a91.26.1762262038771;
        Tue, 04 Nov 2025 05:13:58 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3415991d381sm4616141a91.2.2025.11.04.05.13.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Nov 2025 05:13:58 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: zhengqi.arch@bytedance.com,
	dev.jain@arm.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	bp@alien8.de,
	catalin.marinas@arm.com,
	dave.hansen@linux.intel.com,
	david@redhat.com,
	hannes@cmpxchg.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mingo@redhat.com,
	ppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tglx@linutronix.de,
	vbabka@suse.cz,
	will@kernel.org,
	x86@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
Date: Tue,  4 Nov 2025 21:13:45 +0800
Message-ID: <20251104131348.32332-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
References: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 042511C000D
X-Stat-Signature: 9n4gj78agtor8n11ounm4csxtqehahw9
X-Rspam-User: 
X-HE-Tag: 1762262039-255797
X-HE-Meta: U2FsdGVkX1/uKI/z404kYmT5ogfUkk6EbtMrDz4LkvCXt76WRHhdwKyY3fXsZQSOiG1sZXKdHHrd8dm5RPKapg8TPt2SktZIupSrtw/GD3ZPmKURPT++UXM7keWjCT6td8WuL/hgYTdvJ60DaaQyjtQOSe79OfhQA/2vGN0GEaSxLH3P5CZ3xsWJvgA7298ir+DJpqq8M7VU+/YLqDVeifw802r01xGlw1CYQUcsT1cIEWM+fvNDzwCDK/lID0Rl2WBTXNqDJEdb/3ARucPVb/MpM7FLIbdmgSc9GSYxkwVBPJJBZ2Ks+bpkLgDz/QbE7cXa9geeeDoySJAR8jmF/T2tqcHUacrQTys2HI1zCZc2gGBGFyP50QJMqxTp3Zdy3yolHlA2pAfaFG0zxk2hPFH7k/8NFQ2wFMh5CekkYiS3qRljWOLzTZtrWUxbSE7v+twjIMbfdCZi8EUIX01r1biQAVJ14m65T9usSw/L1U5aoyBLEbVEyLm3WCZWKN0xz3Qi0NsEHQy1kIMtde6YMdNbE8d0oqkQIAxtWe7KMqAMimSg/Uxsrk1dSZ3VZj7Yr1QEy/9JOoUB2mKLCGc/ehoVVl0pu3+aA4mSDN2k0CYRPKCvupm/SNqRTHfc7aPZJLzCkZe/Pyql51Lzwf2RrOW5ncUO5nwfasKcux/26m+c1cji3SjoeLsOf6JA8Oyczti94bKdcBv3TJLCUxX7nxZD537nl7tjW3lsAo16YHYFBgk1xWodFlMfGimOdNDBHEXFpVV343KjYnbQH3Ho5UBqVZb38z9uCG0Vz0dtHYJ2RMRBg0aTBdumjWciBta/FAfulEEVYoEVujJ1QBfdJimrrXQEsz8Hf23hFhuBU2srrkM5rQuJ17/8NOBXtXsb+L5Kt8uM1VzhlsCgAFn8XkyKcWIW4XprWceBzLtI7Od29hklMY+yI1xUuEXCw/wG4PcwKRY1w6hIAdFXN0V
 TRLrveE8
 YTMNLDq+LzEB0CEhgmA63BdhUP187XtFfntHUZaU6+p1q1fQMTKNTDeNbWHuAwbaT2TJGlQs5kHFtO2htwDvW3pZ4admmO7tTzcYzV3jHQHJmnxN7Zx3JX4QZr8DPEaL2QAvOipZYtClTuEx/vycF1kGDc6kRwDLE1vf5mDNwtlpTpWKHg/o9Ow5p3N9CLJwWae3vk7cQXHE8GITonGe58jn2b46au4XB0dydgIhpGlAK78/W2ZDwvbz8hWqW/76aef1a/tIRCUe1wHIxP0oS3QxlPEqErzlJArkPMWCBR7NaQD5FQ3giLf5aOnUZFBoVlbr5NqHh+6/Eg5QmgJ9eohBGJx06nL+hLZrzmz/VGBHScCyt3l4SKAN02AveKgnL/6HsZfHl8Jt4uktPRi6OOwwBSTf4MYrYsgLLSj12n876dfB2vZ9SLs+vRs8EmmWwCfFoNymlCRumD1OGEpfn2/URZajzDhGx34cX0wcE4v9yQ+DhOkKCACaPx5xN/wvBUkXf9FwJfZ5mMEsiFJlU9wWJuC+iCg1PdlzR9DVfFXWAybMyAmw6LGKVpy3RoSoEhrLQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Tue, 4 Nov 2025 14:33:00 +0800, Qi Zheng wrote:
> 
> 
> On 11/4/25 12:02 PM, Dev Jain wrote:
> > 
> > On 03/11/25 2:37 pm, Qi Zheng wrote:
> >> Hi Dev,
> >>
> >> On 11/3/25 4:43 PM, Dev Jain wrote:
> >>>
> >>> On 03/11/25 12:33 pm, Qi Zheng wrote:
> >>>> Hi Dev,
> >>>>
> >>>> On 11/3/25 2:37 PM, Dev Jain wrote:
> >>>>> The implementation of CONFIG_PT_RECLAIM is completely contained in 
> >>>>> generic
> >>>>> mm code. It depends on the RCU callback which will reclaim the 
> >>>>> pagetables -
> >>>>> there is nothing arch-specific about that. So, enable this config for
> >>>>> all architectures.
> >>>>
> >>>> Thanks for doing this!
> >>>>
> >>>> But unfortunately, not all architectures call tlb_remove_ptdesc() in
> >>>> __pte_free_tlb(). Some architectures directly call pte_free() to
> >>>> free PTE pages (without RCU).
> >>>
> >>> Thanks! This was not obvious to figure out.
> >>>
> >>> Is there an arch bottleneck because of which they do this? I mean to 
> >>> say,
> >>>
> >>> is something stopping us from simply redirecting __pte_free_tlb to 
> >>> tlb_remove_ptdesc
> >>
> >> Some architectures have special handling in __pte_free_tlb(), and cannot
> >> simple redirect __pte_free_tlb() to tlb_remove_ptdesc(), such as m68k,
> >> powerpc, etc.
> >>
> >> For those architectures that call pte_free() in __pte_free_tlb(), it
> >> should be easy to modify them.
> >>
> >> If you're not in a rush, I can take the time to finish the above tasks.
> > 
> > Right then, I'll leave that up to you!
> 
> OK, I will do it ASAP.

Cool! Looking forward to seeing that land ;p

Cheers,
Lance

> 
> > 
> > 
> >>
> >>>
> >>> or pte_free_defer?
> >>>
> >>>
> >>> I am looking to enable this config at least on arm64 by default, I 
> >>> believe it will be legal

Great proposal, Dev! That looks like a very useful feature. Let's make it
happen on arm64 ;)

> >>>
> >>> to do this at least here.
> >>
> >> IIRC, arm64 can directly enable CONFIG_PT_RECLAIM, as it is supported
> >> at the architecture level.
> >>
> >> Thanks,
> >> Qi
> >>
> >>>
> >>>
> >>>>
> >>>> We need to modify these architectures first, otherwise it will
> >>>> lead to UAF. This approach is feasible because Hugh provides similar
> >>>> support in pte_free_defer().
> >>>>
> >>>> Enabling PT_RECLAIM on all architecture has always been on my
> >>>> TODO list, but it's been blocked by other things. :(
> >>>>
> >>>> Thanks,
> >>>> Qi
> >>>>
> >>>>>
> >>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >>>>> ---
> >>>>>   arch/x86/Kconfig | 1 -
> >>>>>   mm/Kconfig       | 5 +----
> >>>>>   mm/pt_reclaim.c  | 2 +-
> >>>>>   3 files changed, 2 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >>>>> index fa3b616af03a..5681308a5650 100644
> >>>>> --- a/arch/x86/Kconfig
> >>>>> +++ b/arch/x86/Kconfig
> >>>>> @@ -327,7 +327,6 @@ config X86
> >>>>>       select FUNCTION_ALIGNMENT_4B
> >>>>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
> >>>>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> >>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
> >>>>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
> >>>>>       select SCHED_SMT            if SMP
> >>>>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
> >>>>> diff --git a/mm/Kconfig b/mm/Kconfig
> >>>>> index 0e26f4fc8717..903c37d02555 100644
> >>>>> --- a/mm/Kconfig
> >>>>> +++ b/mm/Kconfig
> >>>>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
> >>>>>         The architecture has hardware support for userspace shadow 
> >>>>> call
> >>>>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
> >>>>>   -config ARCH_SUPPORTS_PT_RECLAIM
> >>>>> -    def_bool n
> >>>>> -
> >>>>>   config PT_RECLAIM
> >>>>>       bool "reclaim empty user page table pages"
> >>>>>       default y
> >>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> >>>>> +    depends on MMU && SMP
> >>>>>       select MMU_GATHER_RCU_TABLE_FREE
> >>>>>       help
> >>>>>         Try to reclaim empty user page table pages in paths other 
> >>>>> than munmap
> >>>>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> >>>>> index 7e9455a18aae..049e17f08c6a 100644
> >>>>> --- a/mm/pt_reclaim.c
> >>>>> +++ b/mm/pt_reclaim.c
> >>>>> @@ -1,6 +1,6 @@
> >>>>>   // SPDX-License-Identifier: GPL-2.0
> >>>>>   #include <linux/hugetlb.h>
> >>>>> -#include <asm-generic/tlb.h>
> >>>>> +#include <asm/tlb.h>
> >>>>>   #include <asm/pgalloc.h>
> >>>>>     #include "internal.h"
> >>>>
> >>
> 
> 

