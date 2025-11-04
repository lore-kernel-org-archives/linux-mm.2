Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63788CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 06:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57F78E00ED; Tue,  4 Nov 2025 01:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08738E00E7; Tue,  4 Nov 2025 01:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7588E00ED; Tue,  4 Nov 2025 01:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87C7D8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:33:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36474160414
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:33:18 +0000 (UTC)
X-FDA: 84071957676.20.A5E1EAE
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 90FCE40009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:33:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CFaUl3Ze;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762237996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okre2wWfSe1mulYIwiBesIuo2idWuGwL5MuWvzP58j8=;
	b=BULCSRu8E+TB9rRsuALrvxiy1SdpAvqx9IRU3vHK3B2jp3kRM0cNTaBTjf2ZPBI3fiqnYh
	3RZwkTo2BhoqnLu2DMUrNhitXB7scF2Z3KyMML+eiEX3DSmQSjOXUsT8g4usdzyUuSaIXm
	9XXZZHkV4DMv0jnnptYBUfZ0Zupmc6s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CFaUl3Ze;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762237996; a=rsa-sha256;
	cv=none;
	b=szO3cmc88yvcz04VQzjl0Luut5aANpgkQJ75zQoj26Ksovm4Hh2ACeNPLdxg946kinAxtX
	lb1JWGajXs4iTYYGETCyg1smniAtQkSUoo+VPnKiTl7Sx4O0DQ9qNlBSzh3wu5Rfo+SyES
	C+kSUaqqDlH5smm0nbDKLYUvuqRFOlA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso237780b3a.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 22:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762237994; x=1762842794; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okre2wWfSe1mulYIwiBesIuo2idWuGwL5MuWvzP58j8=;
        b=CFaUl3ZeUKHX5siiNiY0iGHrG+fhz496aNR2KqYIZqsL6BqXaIS27B+JWMQrcrdzyF
         utqZkMa5GUJUT+3+nveV7w1INQIGS35bK85nyZYo732YveO6Qseb6SCaHLjXBWTNYDrX
         ERaSsFo2b3eANiyVUPmX9oQ/6B142HnJBfHfU+qEdlR2YAolFBDpo9i4HwjnGOWlTSTI
         z3+FuJ1VviDn1bPVa0NFdhc/8ITR3IrxXncssik4u3ckENqEuBkyBdmaOqHYszplM13a
         PmMbJzpwTlPBSsv2McaDSg0kcvUiJK5u3t9tLiO8ymQw9slGkgSs90aV7hUzWmcG7TeV
         //9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762237994; x=1762842794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=okre2wWfSe1mulYIwiBesIuo2idWuGwL5MuWvzP58j8=;
        b=uxADceKFZQ+zOhKIJc0JL6+tLhw/9KmXFw8DElU1G2gLXVCGYkgbA+KP4Tx7dSv2SK
         iY/T9rs7D0kQcspgk6BN31Ax+mWHZIjpY5NF2hYmiBGx7HVBstTfV0zweBIsMa6KohLj
         QrhjzrP5y0nGyDcWTFw38p+GPIiMrOg5iUXSk2MJixGZbF87v6sF60tI5YyYHldIhW2a
         YXWTqqbBYf3QdXmwdVvD5F0ZMORDve02QNReXfX1GDNFy4etbm5YcD3wMdvTaomqWiOs
         7ReXiwjmBp6Ir5BijAjGRemTrpFmvH6NpbND6rpJO/xj2MCSt8ORtWzpYF4n3YDa5OiK
         fUPw==
X-Forwarded-Encrypted: i=1; AJvYcCVIo3fiGtaNgm2ZqtOoEe0qezZIpmcohPUEtLbUmJTXNAKBXYDwO1n4yvbHGcoA2z8uoIX4NdIq7g==@kvack.org
X-Gm-Message-State: AOJu0YwCkskAXP8Ydn+cnROlEft0klj0eq8dRzb5WFnnLKf1a8GXhFiz
	dnIR/rqiPajNPsfCl1ijvOfOiiK+vEkPm5S6UD1HHo6Xon9j+z/Vh883pEVGWoWkUmU=
X-Gm-Gg: ASbGncsN+EN4y2k6bEMah9B8tic0v1HgVmBTefKCv/u3nfDQHeUFqdnmm9qVrCa0JeM
	MYyfEDezVJC2dvqWls79gqwqQsvu8WiROKgzYcAk6lA/jmuddtQU9yoVTq3EDwT3vTTnu1XQTBS
	qR+4NAhCKj7paeqhCOlrCyOPicfoJ6QwGmuR1IkypRdRNQ7qT38DwZypDa4RcTzeHHjgKqdjnSf
	UVQ/bN659dfSuQmtVHcG8CC7j44MW378ZF9om7WV+b1v218jfaqgw4Bu5iy/yEbbz/M710A/Kle
	UX8gnfKgqzRCqARGN/H5oaD7CFppdoivqjGe9HX3JhY0M6Wz+owo3b6ZIDTHEWYPi+Iji775J5p
	u+JAuiRQ2CsDoBQ0qjP9FJxu0ci/4Xjqm9kNdbNPBOV9NH/X0wwBLQz1STJbLF9RaxrKnEOd5T0
	FwbpSSYKZri19ZO7uiZagNrmu6PgeKuPVKXuQYqg==
X-Google-Smtp-Source: AGHT+IEsK3Ywd+KdKURpAwPHwPCTZY4XIOGPtIduvvF1tV0A6LQireFulxj6l1bJiYfahHfhZiyCQw==
X-Received: by 2002:a05:6a20:918a:b0:33f:df99:11e5 with SMTP id adf61e73a8af0-348cbda9889mr20185915637.28.1762237994112;
        Mon, 03 Nov 2025 22:33:14 -0800 (PST)
Received: from [100.82.90.5] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd62428dfsm1576009b3a.60.2025.11.03.22.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 22:33:13 -0800 (PST)
Message-ID: <827b647d-798f-4775-bb31-ef735485c6bb@bytedance.com>
Date: Tue, 4 Nov 2025 14:33:00 +0800
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
 <9359ce51-5ac7-4312-8ef8-79fa51d014f5@bytedance.com>
 <2be04785-d725-4e79-a609-87f174271f83@arm.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <2be04785-d725-4e79-a609-87f174271f83@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90FCE40009
X-Stat-Signature: chrzm5g8dz34jqrokp8nqmyg9bd61dnx
X-Rspam-User: 
X-HE-Tag: 1762237995-691295
X-HE-Meta: U2FsdGVkX1+N3DCm0xqZIMrMoPled6JU7j5mL3ghsPaSjoCUTH+pTfUItPicqoROThmPTkyIabq2E1ELWpeia6EzvhWrq7BZPZpumfFYT1FqD36Y3TIAVhncw0HVn3cGSPeEUDYTTpGnnjHkKclQ2uwhMOK573YfbvY4C15lOM7b4P7iN8Z68H6UccxNzxWtGgq7FW38MBJNG+Ak0iYN1Fw0jC6acLpFRiqPp4DY60yjaDJtwShkvvJbhy01oD6kcIrlfIGMYQYSyb4C1wbrbWsak2lwv29y/SM4/VYo/PqRM4GgEPe33bDy7JH7gpQVUe2brlvD1e4ZYsoun7/+dYtk6/FTL4eLVuboWvb3NbDcrBgGNVUwFUuY2lkfRuJLM7vd477+MKDvmCw1JviqULVWfc4/gqL3OyS+lSsfMNQ0efRWAB1UGr+O2VSi8APsyDCkfyuLjsMdPriQzmKu28YOhHyT60u1KI+MzzEp6DsMFHxUh/bIxspMy0NCFaVbs0zz/uRXk4Dg4h4m4Q2jxKU1CMHJUSj+zdeOA6LlDtLuqp2w+QkI2BRzQ/wr47VZ4n7C5ZKAkn7xzFaE80ZODJDs8IHkzh5kMGW+NoUI6npgIY07ZmCQVKCwf9eNYdNyyLCx83eZZ8asAPmCQwUmbgos7hYeddLu90vt5Do+nqpn9fFSpQi5S9sGkk7EcQzw0KQ7Oie7Smly6nFB3fGo5hFK5ujYhZnOa6nZIbSMNXDqgK0oAqyd0GA6iMFj/O3pJDMmxNJtvcBp+blJ3gkfGFQwZtLuDCpOAbYOPjunotIj5Kpl9Z4vG6AYeoo3hzkcWH/Ocek3wd8tfg5hSj56OHw+0LMYIVuwoPHRB8+xMd1JJNmR49PbORGx1H7h7xyOnwlZq7e57KwAyaQIhVLtGAlS+kJV4yA+J/oJMNEvB170IOOtBYzFbaOFJB/WpLC+yYLGhZKGRBOI091cK6d
 5wMddm5a
 sJftfA/PikKR+4/VLbA4TvC7ZGlexEWCyHlMd7O3/dgKxUKAi7aSjbQdbt5+KpjEVanROjjb1pYv60qAjy5ks8L15JmRVmgKsUDZqwRpqXq7D4M0qrLniXpZ3p1lhJRFlAQPdDXyPJBBHVmTqGJwpD5AW9VD93PLDKr9llHa7esoHKQcaEM16pe6ZmTdgY9n54f2RIux+p4bRuxUpu8ZxEMWT44ksEd/zCKo2u+heB53WB2/bSrAYVS9aliyj+7VAijopvCUYJ7jii8kXAMxJZDZWusgCUpyJKEokaNYDSEVKcbYQyc7MLrOKzdcuQDNUn5KgNzY5Vrj/+WjVMuE567NHSAxmfdPoqLX1G6qMWeSYL3XCIvHpnEtVS86G+ZtiN3F77A3yvK9QebYHIi3a1U3cMkLicea1piVVC07Gz1Afd+2wJy+Wgy7jrArS7QT95rwedRUUlrXlBwzvgvq08XOExisY9UhTZ3/va1gm4gtd8HLII6Gezfqglg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/4/25 12:02 PM, Dev Jain wrote:
> 
> On 03/11/25 2:37 pm, Qi Zheng wrote:
>> Hi Dev,
>>
>> On 11/3/25 4:43 PM, Dev Jain wrote:
>>>
>>> On 03/11/25 12:33 pm, Qi Zheng wrote:
>>>> Hi Dev,
>>>>
>>>> On 11/3/25 2:37 PM, Dev Jain wrote:
>>>>> The implementation of CONFIG_PT_RECLAIM is completely contained in 
>>>>> generic
>>>>> mm code. It depends on the RCU callback which will reclaim the 
>>>>> pagetables -
>>>>> there is nothing arch-specific about that. So, enable this config for
>>>>> all architectures.
>>>>
>>>> Thanks for doing this!
>>>>
>>>> But unfortunately, not all architectures call tlb_remove_ptdesc() in
>>>> __pte_free_tlb(). Some architectures directly call pte_free() to
>>>> free PTE pages (without RCU).
>>>
>>> Thanks! This was not obvious to figure out.
>>>
>>> Is there an arch bottleneck because of which they do this? I mean to 
>>> say,
>>>
>>> is something stopping us from simply redirecting __pte_free_tlb to 
>>> tlb_remove_ptdesc
>>
>> Some architectures have special handling in __pte_free_tlb(), and cannot
>> simple redirect __pte_free_tlb() to tlb_remove_ptdesc(), such as m68k,
>> powerpc, etc.
>>
>> For those architectures that call pte_free() in __pte_free_tlb(), it
>> should be easy to modify them.
>>
>> If you're not in a rush, I can take the time to finish the above tasks.
> 
> Right then, I'll leave that up to you!

OK, I will do it ASAP.

> 
> 
>>
>>>
>>> or pte_free_defer?
>>>
>>>
>>> I am looking to enable this config at least on arm64 by default, I 
>>> believe it will be legal
>>>
>>> to do this at least here.
>>
>> IIRC, arm64 can directly enable CONFIG_PT_RECLAIM, as it is supported
>> at the architecture level.
>>
>> Thanks,
>> Qi
>>
>>>
>>>
>>>>
>>>> We need to modify these architectures first, otherwise it will
>>>> lead to UAF. This approach is feasible because Hugh provides similar
>>>> support in pte_free_defer().
>>>>
>>>> Enabling PT_RECLAIM on all architecture has always been on my
>>>> TODO list, but it's been blocked by other things. :(
>>>>
>>>> Thanks,
>>>> Qi
>>>>
>>>>>
>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>>> ---
>>>>>   arch/x86/Kconfig | 1 -
>>>>>   mm/Kconfig       | 5 +----
>>>>>   mm/pt_reclaim.c  | 2 +-
>>>>>   3 files changed, 2 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>> index fa3b616af03a..5681308a5650 100644
>>>>> --- a/arch/x86/Kconfig
>>>>> +++ b/arch/x86/Kconfig
>>>>> @@ -327,7 +327,6 @@ config X86
>>>>>       select FUNCTION_ALIGNMENT_4B
>>>>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>>       select SCHED_SMT            if SMP
>>>>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>> index 0e26f4fc8717..903c37d02555 100644
>>>>> --- a/mm/Kconfig
>>>>> +++ b/mm/Kconfig
>>>>> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>>         The architecture has hardware support for userspace shadow 
>>>>> call
>>>>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>>   -config ARCH_SUPPORTS_PT_RECLAIM
>>>>> -    def_bool n
>>>>> -
>>>>>   config PT_RECLAIM
>>>>>       bool "reclaim empty user page table pages"
>>>>>       default y
>>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>>> +    depends on MMU && SMP
>>>>>       select MMU_GATHER_RCU_TABLE_FREE
>>>>>       help
>>>>>         Try to reclaim empty user page table pages in paths other 
>>>>> than munmap
>>>>> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
>>>>> index 7e9455a18aae..049e17f08c6a 100644
>>>>> --- a/mm/pt_reclaim.c
>>>>> +++ b/mm/pt_reclaim.c
>>>>> @@ -1,6 +1,6 @@
>>>>>   // SPDX-License-Identifier: GPL-2.0
>>>>>   #include <linux/hugetlb.h>
>>>>> -#include <asm-generic/tlb.h>
>>>>> +#include <asm/tlb.h>
>>>>>   #include <asm/pgalloc.h>
>>>>>     #include "internal.h"
>>>>
>>


