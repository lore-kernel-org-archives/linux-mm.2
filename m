Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB4CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A76F8E013A; Tue,  4 Nov 2025 08:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D848E0124; Tue,  4 Nov 2025 08:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394BB8E013A; Tue,  4 Nov 2025 08:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 282E38E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:15:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF54316053D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:15:36 +0000 (UTC)
X-FDA: 84072971472.19.34798CB
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id C74C7140009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:15:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F25st835;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762262134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaPdklETLQOqQGht0Ouglwao5ZyyFqDFyIPDptevZDI=;
	b=x6YZVHJ4v+QGs594w7qrhnqSXZ8i/NZuN0/kC7Puw8UqD9WwdyZCZYDabYBH6s8fKbgcrx
	8J+RD36PoFdpiyfgu6IQGrkg6jXIQFYcstQkyPJfyvbwPe3tDeTrvKqq3lNOd6K5LmHZfd
	+QIeWoV0bi+122rzfrCpgxyLvwdHMLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762262134; a=rsa-sha256;
	cv=none;
	b=Hbx4osWn2b2bBmKgP9ihppxLGBf0GfXX9nBvOhuomQt75LjYxnFoaU3IOQL/2vuo3v6LWP
	6JRMfF1Ikt46VuInyvJc1rImA4EFL01B7L/2NwPpS5y7Co5BZea7T6GnFkRtYk6BgWL0sU
	eSnxuOS8BbSq1STWhoUwSIPuM9EJW6E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F25st835;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b95cdcacd95so2175011a12.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 05:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762262134; x=1762866934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KaPdklETLQOqQGht0Ouglwao5ZyyFqDFyIPDptevZDI=;
        b=F25st835vdNssvJ+6B/qRd6LMCwCVIlXLWskT5WlylS9ZQWmf0W+7dLfZO5cFdT2mo
         T3mmoUEadHWgUkwDb5dUeTxsdQtRPJV781CklRyG6ouaYN+psLQNAvXTP9QAgKHbmgA4
         I7y0ocKepw61HpuyMrIH2bzT3v5SpD6Jj3LUwg6jrwhmjWvQRQnFHNCRIXt5F5mVLcHU
         5q0d0dZV3crNo7j+BPjaSEbcTq3AtKnuOUBRh4JqASB9ZR3lrHo5MuJ19EnXyL76WRzs
         CVLoVeTpp4iPaq0VwEPfACK/sTqtcBgyPYjHHptbLQse0BFM2cGXNXIdvzaGFf6aw64B
         MiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762262134; x=1762866934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KaPdklETLQOqQGht0Ouglwao5ZyyFqDFyIPDptevZDI=;
        b=CKJKD1WLIYbOXmxGkN77ZLVdDkGhJq8+hsGymRK+oIJr6JlP5RauaVh7uYMueEeWkE
         O2rPbwIPfo7VjEVUfWahtKrV9+zrqfiGKIbOm2MpuByY1xAb6uYUTi2LxJo1DozOEcXU
         WxAnI5zpYyZwHNLK8WOy4/MHvvQ54U+R4w3n5Zw0eh15Rt4mmxIxn+HMuq7v3fr5gdwY
         9yhPBzY+7yAhp2mIKH2/wn++MEvfLHB9YVmZK69OJzLv3DyCZCs4npfu4YLFJjnk5kZN
         k68EzdVvMsnd444kufLrO57a7nuLJmf9FUgJzWFzmycNlZWgbN0qOY8h3wx9avqJ0I+u
         gGuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYn2Wnmjd+HK8kFrSBLyXcmwGjg/2fr7ZziS+MJFgwWVnY0jqAfFUsVC3+w4uL91uxDITGz+sgBw==@kvack.org
X-Gm-Message-State: AOJu0YzCAGve8ZjuG2QKJSAYVeaLk4ngBQbtWAUm3sY+whBaMA5GmIbN
	DaqSR3Ae2VBACgVMj3gwMGINvp4Bj+fdXoE1W9BS3roQqUga+EzaPWbF
X-Gm-Gg: ASbGncvo4cHgdUzAevjU6/Q5V58paYdzgU4zAvDVzHLr2+hIJyJdnAS5+MitYbQASJj
	kssKODXpfa42PrpxpXdZYMsc1DWuSj2+lmvaJnXyclmoRQlx/HjfhGNUwfSS4Hl99sZzlK82nVA
	1arURKChUXFLIHuwgBKgjCXR9n6x5HyKhuvbh8kejmbdIKZwAD/PjD1yy1YItsM24X8S8n2dmXr
	DPdGezihyXcDy2eh1a9Drb2h66Nl3nnaYhtq+Buc0NHEdXsz/5Kq2Z5EKzHDAzy+nTt4YbPJyu0
	iIRTvG615w8lencTvuZ0XTNahq0zD1AcS7eGI+gS9ykY6ckBqt9bY3zQOhJ72M6MolXoZGsHItl
	6KIJ4QQfca8UyUvCScGv2NCmqepz0SnFhdiklZvR6yhyb8l1/tlYmHSuDKR6Xo/LW1bMGktCl2S
	Ab4vp+rXw=
X-Google-Smtp-Source: AGHT+IFYJ+Ef86npfeYUTM5p40wZKPAA18fU6R4aES1geEESlAZFL0CbAepJgKE0wSrpDsdnIncgPw==
X-Received: by 2002:a17:902:f68b:b0:274:3db8:e755 with SMTP id d9443c01a7336-2951a4936a6mr213193865ad.30.1762262133305;
        Tue, 04 Nov 2025 05:15:33 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601972a87sm26839245ad.15.2025.11.04.05.15.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Nov 2025 05:15:32 -0800 (PST)
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
Date: Tue,  4 Nov 2025 21:15:21 +0800
Message-ID: <20251104131522.33079-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
References: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C74C7140009
X-Stat-Signature: 5qoix6f166yzjckcbo3ke6amwf354ncm
X-HE-Tag: 1762262134-747873
X-HE-Meta: U2FsdGVkX19F9WCicJ1S3s9sdNyx3myI5RPjbWF+C4CSu/ay5vHVpsH0aeAHqCKD7pLrC7w4/q+aWxRDWnXYeuNjB1+TA0EcpmpxzWL2RrMiOktS5gP7aWsv7/nwVkq2tRp0Z6ImMpjsTBQhTZz0z+bjjhTbXQRHVNzASYbThNOFbEW+PvK3p4wVCOjNxbhPoqZWr3ZBctAgfT5P+VEskPkGSyYLpylmrP4R2ejfuQZk4Na6bugt5RK7DCiZR2gpSm63GRZemzYBY7HB8p+hq4CvXNDZUwdfCC6YyDcLVxjhemSL+FK4hl1rzw5i6ADrMzOyFLK35oBllu4GHhhlSE/jPvgfMzzT8YFvA7sL+4R1YIMhwCbul76AVJ0waDbA6yiQqvuwG94h170ADcJu1bAxtW79nfWG8GHZmfAhMs0TMKuLmPAqxequPkyQjqvGKa67EFj+ch7iqFo55pu+xrCEdS3bp7OX6qgnHpyVw4pzaAWNDu6ne/YuIiD8gVmbucw7QSgB9PO542+dJpT20lW+BVXVIbXQgWWTCFE2cakHrmrrK6lIgIv0H1n0415L06I26ObykMxZP6xtAAPmYlytSnjEBTJRbtAgsgV/OLZLtZI5nGmhlAmCwJv719qPxOHlqHcBKOuX/UtqQo01wT3PE6rUqSq9fzw2bZDgsPtkdoNgLeTJPdTaM87J7sw9lJf5yP4hz23/55GY1om5Q8QpANt/32oXYgtxVroMqZ2zUf3SYKaI9+IuP9mYAL3J+wyDsrVq91CdSP7k/cxVnCf72YHODzdfoy445Gc4NHhYW7qMicdY3kfPbq4ZtLHZ7O+O7tFovfeHh/GyivDLdNeYwZM2xrLzFh1BgQ0V+FTNq7IzPSmc0/OULMOcntQEXz4f7TsXNUOILZTubUCGDo3qDahCA0pdELB0kmluJ4ib5rr945ufvfOsRX9xd8PO9r9W6GM8qZSMGaA11pA
 M0Ifm7m6
 0DOfPWkXlTIUOLRIdmTOjbQHrs44kN50asu0Smb6PsuGqPROsn8/Xt3OVI+2u4PcTITKS5n6rkohZ80zvtHG0675v2p3lLbkNUpjsdfrhk+LiL6HoNimTZtW1GUxPSHvioYfvBmh970DXayDLBY46o13SSKCh7ZdPL3bW14HpMeLeX6c3rJ3d9lpYD3UIloGk5AcQfowoF1J9T5sHQkMK1mNS7ymkwAw9cQlSLNlYKfC7L18hAil/06PvBe9q8saHU26iDog/2TPGeUB2hqXgoJuUx92VtJEA3zNjjGLjuD7Ev5kKojv2S98iMVdYh13G8epKIyNdooo8SgxW/P4uDY3CEuoqGHGP23qb0H0MkYbv5rQ+/JUqxC0KlgO6A1rS2wS6zSVXk1a0yO6mFw1gesa4Di0CJGfk4qdECKROLYLDUmsn5ObwLdaKxo+XyKqqEmybaZqh76zThYPlZEDvtyXg0HgFKsDK8CRYKWxu0ByE8MURMFSk44dAt3GbYxOVKRZbsq0VhPyXipqo6mDt6eM5CD29qtAWGj6pYVZHZouqKaPDQIa+7tqNkXZh1ZW6tbPa
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

