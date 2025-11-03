Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C6DCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFEB8E004A; Mon,  3 Nov 2025 04:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87388E002A; Mon,  3 Nov 2025 04:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D0E8E004A; Mon,  3 Nov 2025 04:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2DBA8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:07:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 500F212BD3E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:07:34 +0000 (UTC)
X-FDA: 84068717628.23.1AD5ADE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C15940009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:07:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iyiooCOM;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762160852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IXR4W/3bU885mnocYWtgD1fWaKiafANwqtbBTb2/Bg=;
	b=8ZFD65KK8yBdCcOxALSC8DSARW+WTNT4J1iVEYwpI+S4Q++JmEC0LAfkhOr1DVrGqjU5Ko
	QQILR417LimEOZGHGpV8ndYz8i2TDA3LFIRwLJxMYlVZHLYVYYN8k4ptwGwHovikJoysQK
	/b4VjxIjzAv1rGMXoFs/hpXkIJumWn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762160852; a=rsa-sha256;
	cv=none;
	b=mhVFxNvdO/YWeYGZf/yYMebbdJK3skBuvUOuGe1v7FtxBuwXU3EMYpRCm25/n/g8cJnEOP
	losVIq+CZ6TRM+KBwCVCw6rKBr3rtf8WWWiCg1c+V8Q0ODLfBgqvqgBNb3HGRaCdvl1Rmo
	JatkNjL2BnKLIH5aJ4SmNJB/EOghcWA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iyiooCOM;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so3868360b3a.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 01:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762160850; x=1762765650; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IXR4W/3bU885mnocYWtgD1fWaKiafANwqtbBTb2/Bg=;
        b=iyiooCOMHpM8fi7TCbzohFJKsT06TgOd4ggmNmrFC1PHayZbfLrlj8bk53hH0FW0qg
         /Ih3u2zbL9xnENXXggIpaFVRRMvDpDymPypftALLRSvC1rCv+DAUmQ8sCQcwqHZFrRGP
         H3AYupginbJ9CvBCyTXwzLS/evT06JCqmTl2Mu0FK5jiHashwHlFpTh+LsYjmCW9bpie
         nKPkPOb99M5ZlNkLzGHSXAh4K+zavjsqc55ARDiwmvx7ZOv55SY/SRjOhFue6LBjNmbQ
         ZlnVx+MekyIsRS2faH1wKDc2uu4Q83nsq5LPa4uZzKG4e4HKnoTju5wCon8sj8lB8juh
         sTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762160850; x=1762765650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4IXR4W/3bU885mnocYWtgD1fWaKiafANwqtbBTb2/Bg=;
        b=eQwOG3KAviD8KuGuDzVP1FHo99uagiL+cmRcJjnIMmje0oocC1Y7MFtpcl17ZoQ787
         m1q8whz1jP86WXvGAHqGwLFWXMlvhN8Fox4ENHDoI7GC4SNtY3f9XWBAPty6Wv/6Bb4H
         wbIuAK8+GZul0c9WiAQEoYwLlT72QWO3ymmhtns52npae6NnlUSmf84nV7Cl1VhLaVzD
         jaJDPJY9sD3IuwRq6SE2qGD5fVI+rLlIwmtlXp0xVmmUAxZUVGPeJEl+a+1ngpMOU3uR
         zRpxCPN+YpiIYUEcLInYQEzyitcyBGGzRNA6JOkyv+NTBQikTClkfNtPMqAglJrzVkdd
         6foA==
X-Forwarded-Encrypted: i=1; AJvYcCVYAhwadpnM6yUAHB8/zB1NMmdRyrCN15fxH4I5s0D3qmviPmTBtRGbOoJrvmvvIAYloMKieqoPGg==@kvack.org
X-Gm-Message-State: AOJu0YzVx10BR1gXfmTRbPg7QSkRx52JbCLlkUn3BLxKtaYXQmkyEhkA
	Hyzoz9kiV0weOX5NWx1tHUdlzZLd/mB+A95UuEgQ/g395Bb89GhRAL1ls4krihV9XpA=
X-Gm-Gg: ASbGncv3xI6C5VOsODxhDbta+2kdZonzZo/eDzu1Tne6bR9y01H1gcOYNE3LOptBi3X
	msORNbCYtr+Wgek+rLs9fhTcdI8SW+Lbk52fiku8dNqqyXpPeD9/g4G8N/SkQMoYQf7hlcIu8+C
	2DCwXXeGdx0aAQZeas17c9AIo1H3b0TTGdKHxID+rBUJa2UvmU06yrO43OOX6GdUfXyBh+vsshb
	lStR8J0GqbJDYc495UGA210r5w2CiRZX7TK0xw5zLoYcULQchRBsfLLN6+NUa3Tu4Vj8GvBf6df
	u5vkUX13jLlWTlTWlvXw/XUu5v1MJExGUnuWJmvAwjN4XIPkz021C4XysqGVBCKT3bF4IMr1sqI
	72MrJbJdCHTJRMypc35LsDC0sagtD1GKqBH2kQE2oRvZ23QbT/P03fBe8BdRNuPDM+5KYzt9foa
	T4M+Yo5B83IY8m2krr/rafet0PuYA=
X-Google-Smtp-Source: AGHT+IHh54ogHRgLZ5oCFCpwo7pndIkikgTzZE7KUbmx78mSc7CxlZ6V2BvH9MS0x7/fAgICWjZBSQ==
X-Received: by 2002:a17:902:da89:b0:295:5d0b:e119 with SMTP id d9443c01a7336-2955d0c24bbmr89339565ad.26.1762160849656;
        Mon, 03 Nov 2025 01:07:29 -0800 (PST)
Received: from [100.82.90.5] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407f24ee93sm4810869a91.9.2025.11.03.01.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 01:07:29 -0800 (PST)
Message-ID: <9359ce51-5ac7-4312-8ef8-79fa51d014f5@bytedance.com>
Date: Mon, 3 Nov 2025 17:07:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
To: Dev Jain <dev.jain@arm.com>, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, hannes@cmpxchg.org
Cc: ryan.roberts@arm.com, hpa@zytor.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shakeel.butt@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251103063718.90743-1-dev.jain@arm.com>
 <044e3f9a-3de2-4939-afff-3bb527eb024b@bytedance.com>
 <666e012e-0b13-4def-82de-55ccd5868d36@arm.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <666e012e-0b13-4def-82de-55ccd5868d36@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C15940009
X-Rspamd-Server: rspam02
X-Stat-Signature: uts4a96wx7ewk8zz3pjfypb5ugyiposs
X-HE-Tag: 1762160850-342464
X-HE-Meta: U2FsdGVkX18Ps7nxBRLQ7oH6cNoBZ0IJGcbAUMJoT+XMa+uctvBWhe9t8V7RlSudUGymeKlfYyPlRJiW3kNXS3w8O1djgN5vpEO14gw20j/DIpEdxwrRSPhWJPdHvrwzEVZvn6mOYs9pIwzC6gmYt4osQNIhaYfaFsd09W9KWtjsHRS4zvftXK8Iu6OSXCh1bFYiqbQF6teVYVi0VEFy8uMzvJ35Hw4TREuhKpivQrmYWpVcRl+njmlCl27yDHGUjlAgdasPK//GXKy1HZhC8GzGLmUl85mSpkeMmx7qC72tCGFzf9B7iI2n0Z0PooEJi9eCDnqqJDChTK+KtTBBFCuB7Y564faqij+A3A8mcookIQ2L4CQBpvINGdIAijvRBC4KeX/FksmNS8fwNzY+JXqES33Bsy1UOtTlW6r2/QnCANhk3eOHHXBgITG4SZ9aMXhwJtf8CQ2wtqelMTVUjSti00PwclsZu5M4VooE+JP6gJmXAOYrqY93JxIIxzruYzcJmdgpSFHzJsgxYVj2OOgJlfelwcOQNzH/UHLa5dYnVju7vTkPlPal1WWuZSa+BYIH/nh8soNUJRUWSmwoHXrwweYI365mbG5HfUTwK6GQLmJV9srAxQo6h06CeX/iO3n/fP1p0LiQbV6hBvWvzlOQi+Ah+AAt/vycpr0uo4HQTNKMr/4i9g/v6BwkSME1y1pN1j5U9I4yB2HkVSKHVOA9A8DfFkSZ9bAO1pdsjWyB4i/NDpvUa72kBoSEp8/arGdVb1sNgFGIhjTCaCueG5gf/T3qz8qLS9MoEwVKa2aILSRg8119ZcrwI7+aUbcKxyvVYN6o1Yv/4GZll9FN8rBWGeNPmZiyANSbqC8+nAx8KjaKoI3LKKX4MqxEO2iPYi7PbjE7quVTPwcwUy8za/e2iPtJUI1gXBCMF+xv/BYi04Bt1mX0qONGWr8KgH8LdRXFywkShF3MjgUbB8t
 jCDbGFzN
 seMIUNVHNB2aJ00bnO08wD0zK1tBctv4bnKKYhhaJGKE3gYBtZf7BfQlS8me7jtF3kcL/fm4JOTGVKSPtiuFbZeoYk+oFbI4LuJY6zPgV8Du+A65Fgbuo48OHkJTkAjD97L7FpZYwVIeFAuzI53XTWVFo1PIXTdIPXWi4+pxcYXahTu4PY8VEOO5MBKh5rnoHQudRDj/c1GGkehi5CORYVnTFr8lRGPniR0Vu5AawdMAx1ZMpegkMYgE45VSyLPxr7La8Wzo4GbrvCbKXrniBAu/OIdLOLPyvIc0V5L5Y7K26VoZ8oNQeFh86qqTzdX0f3MyGxW8L0NgZ99rJfgcKS7z5xO79JChCHE4euwQtBjbAATXzZubHVWtmJP83vOSLRqqZX12C1k/SbNYyFSWXRJEqc/RPX19GrEAtrUQkDJjcFEeFUTKY9ocpkr0dWONLyKiSn61B4PScfGuM1eCpYrMAXHkWGhJnvTlETi1Zw+0yW2yJJ2dgI/shyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

On 11/3/25 4:43 PM, Dev Jain wrote:
> 
> On 03/11/25 12:33 pm, Qi Zheng wrote:
>> Hi Dev,
>>
>> On 11/3/25 2:37 PM, Dev Jain wrote:
>>> The implementation of CONFIG_PT_RECLAIM is completely contained in 
>>> generic
>>> mm code. It depends on the RCU callback which will reclaim the 
>>> pagetables -
>>> there is nothing arch-specific about that. So, enable this config for
>>> all architectures.
>>
>> Thanks for doing this!
>>
>> But unfortunately, not all architectures call tlb_remove_ptdesc() in
>> __pte_free_tlb(). Some architectures directly call pte_free() to
>> free PTE pages (without RCU).
> 
> Thanks! This was not obvious to figure out.
> 
> Is there an arch bottleneck because of which they do this? I mean to say,
> 
> is something stopping us from simply redirecting __pte_free_tlb to 
> tlb_remove_ptdesc

Some architectures have special handling in __pte_free_tlb(), and cannot
simple redirect __pte_free_tlb() to tlb_remove_ptdesc(), such as m68k,
powerpc, etc.

For those architectures that call pte_free() in __pte_free_tlb(), it
should be easy to modify them.

If you're not in a rush, I can take the time to finish the above tasks.

> 
> or pte_free_defer?
> 
> 
> I am looking to enable this config at least on arm64 by default, I 
> believe it will be legal
> 
> to do this at least here.

IIRC, arm64 can directly enable CONFIG_PT_RECLAIM, as it is supported
at the architecture level.

Thanks,
Qi

> 
> 
>>
>> We need to modify these architectures first, otherwise it will
>> lead to UAF. This approach is feasible because Hugh provides similar
>> support in pte_free_defer().
>>
>> Enabling PT_RECLAIM on all architecture has always been on my
>> TODO list, but it's been blocked by other things. :(
>>
>> Thanks,
>> Qi
>>
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>   arch/x86/Kconfig | 1 -
>>>   mm/Kconfig       | 5 +----
>>>   mm/pt_reclaim.c  | 2 +-
>>>   3 files changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index fa3b616af03a..5681308a5650 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -327,7 +327,6 @@ config X86
>>>       select FUNCTION_ALIGNMENT_4B
>>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>       select SCHED_SMT            if SMP
>>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index 0e26f4fc8717..903c37d02555 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>         The architecture has hardware support for userspace shadow call
>>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>   -config ARCH_SUPPORTS_PT_RECLAIM
>>> -    def_bool n
>>> -
>>>   config PT_RECLAIM
>>>       bool "reclaim empty user page table pages"
>>>       default y
>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>> +    depends on MMU && SMP
>>>       select MMU_GATHER_RCU_TABLE_FREE
>>>       help
>>>         Try to reclaim empty user page table pages in paths other 
>>> than munmap
>>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>>> index 7e9455a18aae..049e17f08c6a 100644
>>> --- a/mm/pt_reclaim.c
>>> +++ b/mm/pt_reclaim.c
>>> @@ -1,6 +1,6 @@
>>>   // SPDX-License-Identifier: GPL-2.0
>>>   #include <linux/hugetlb.h>
>>> -#include <asm-generic/tlb.h>
>>> +#include <asm/tlb.h>
>>>   #include <asm/pgalloc.h>
>>>     #include "internal.h"
>>


