Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB8B1CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0515B8E0009; Thu, 16 Oct 2025 15:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0022C8E0002; Thu, 16 Oct 2025 15:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33648E0009; Thu, 16 Oct 2025 15:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D34158E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:45:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 404C0119F64
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:45:09 +0000 (UTC)
X-FDA: 84005005938.14.9AEE6CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9748440006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:45:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOLVRhfR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760643906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ksp8408IsxwecTmUGjzpuXH4WucsZWUXVX7U4eYiGcs=;
	b=QelWDuOMgrEzSW/4xGNHFr1zOwIAfjmfNUEyd+1zNFlUF9mOXle1Rgri+i/dGJQ2eDcDbP
	aBGdve0eTyBxWtnthBYnHeHshIxxY6AOWu2SVIWbBLRfo+Ni7eB70ClufwtrbdL+oeIIp2
	xUwSrChyQTZ6Ap4VUeTQBxkXbtlkkXU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOLVRhfR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760643906; a=rsa-sha256;
	cv=none;
	b=DaGTIq3bwbEwOrICs03jo+oB2J+6/NyD6iX2ZC3W4w7ctkHgjpO5tOxkvhlIOlvnTALzoT
	v/AsRPv9PLIJke4RHU8l+3jJimL305iT749g/V5K843RtBo+s/SAOJZLyDd4PnrQ/PZscT
	xq9PpE1PNyVHTTs1FNVAgVHlZuTE2Z8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760643906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ksp8408IsxwecTmUGjzpuXH4WucsZWUXVX7U4eYiGcs=;
	b=JOLVRhfRMk9WkFIErDbPcIXj6bHQ7uux+oqO/nIEMeUGdpRIIvhSwdhreUMW1fUMcB8gKi
	3gC/P+HlqJdTPfxZCYjZMrrYmegONughiaJWzzUmB5oil3/LMTXF+l/EfvD4Fc44VjfTcg
	ll4rGerHLwmareKaOUkiBbCiAbOJM+s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-OUhft9iaNOGq8OSOhfJI8Q-1; Thu, 16 Oct 2025 15:45:02 -0400
X-MC-Unique: OUhft9iaNOGq8OSOhfJI8Q-1
X-Mimecast-MFC-AGG-ID: OUhft9iaNOGq8OSOhfJI8Q_1760643901
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso7456065e9.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760643901; x=1761248701;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ksp8408IsxwecTmUGjzpuXH4WucsZWUXVX7U4eYiGcs=;
        b=WMw6Ss94QRZshG8ldAn13v1lp/qAe8C74tQ49Ky16drhqJadrLY41QNsnHRd4O8z4N
         YtAOJEdhywusVz5+iJwnfOHlUvylFHsVySFpmB6MO2vhIFBc0yyA6fCUwjMkEDsIPMrx
         qG1devqhiNNAserxwXDm4AMukO5+FqQ6edRRpA9HB5PHKay1JbWztgxOOp2evuMo+8Lk
         WJ6oUg3wuJYcnTJBtUPX5WoFF4aOX6XboBT/Gf/CThz09l7qdDlYL/e0lK3TmS8DvWm5
         lZxrhe0izzhQLJqbTpMLJOLYfLWtxc7T5J6ZrWbCvKqH9sU3h3aH45nRn8/CfcLBLtz6
         IWnw==
X-Forwarded-Encrypted: i=1; AJvYcCWUqLfGH7gDDYjg32+IcD6dd2HExs6s3H1Q/+LryyXvT/s1/WkoBTlE9I6g9bVtTQFQAyr0i0TRew==@kvack.org
X-Gm-Message-State: AOJu0Ywg47McY23wbhfwiKWvPDhK/iEo9NKT7G2RM3MvtlmHCepOb6r2
	Sd/RnmCgyAEhUZTdkeh5tr9Vkp9kX8RrgEL8MDxDMaLoavsH9k/kaUdXvGdf2zAF3ZN9yLDzRTI
	p8RuCRdvZ9RyqHc3PCCYAozySSGOD5Yh+cye4D8bstjFCEl/ArQzD
X-Gm-Gg: ASbGncv6ukA34JsFqqungmX7hkBfCzvlZTNrYNAStCKo8qIbL0fuolQrn7oWhOF4asX
	i48SvYThz/N/OCcw3JAwCvUUe90aWoOuO+8X0/VnPlfOyRqhK/nauplgw4k6L7s886+fIV8QsFD
	jxPtOVAtRQp2oyuMJQ1DYwlOFJ8sKVL156naD1ptBPVHg8zSRgRaTAVVl/AlXZX06LWHnsOIYBz
	N8cCujbJlFna1BYDNYge0/8jztg/ZN6Zghna1/jcWYFwxeNDtPHDNQH0om/3ZTSX6NCU2Z8INHg
	bveX0XEZLsok9FbAQRUmpfmt6QOBOrIU0Of0GTE80EbnkFXVmohe5hXFH99XMN0OCu7AIBu8fzn
	Twm5Q9F1MStrl9JAcHiC3WkPRBmhiDqj64Cmaj+WxFw19WNUcbwVWFWqJPl08UvuYGWC1UlJ6+b
	ZLUrg6mZBcrYpSDuE5po6yD2m8GkE=
X-Received: by 2002:a05:600c:2a94:b0:45b:92a6:63e3 with SMTP id 5b1f17b1804b1-47109a24fddmr26392975e9.9.1760643901293;
        Thu, 16 Oct 2025 12:45:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIKmtm5OtXO7fBnLBPXWoptqR/y0fSk3woBtfDJ5Y9MjcCQX5Zq0k9GsqIgEbeF4forh+F7A==
X-Received: by 2002:a05:600c:2a94:b0:45b:92a6:63e3 with SMTP id 5b1f17b1804b1-47109a24fddmr26392895e9.9.1760643900900;
        Thu, 16 Oct 2025 12:45:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444d919sm43215855e9.14.2025.10.16.12.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:45:00 -0700 (PDT)
Message-ID: <9d9912fe-3b0b-4754-87f6-6efb49d92a7b@redhat.com>
Date: Thu, 16 Oct 2025 21:44:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Jann Horn <jannh@google.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <e4277c1a-c8d4-429d-b455-8daa9f4bbd14@redhat.com>
 <CAG48ez0yz2DauOuJy=-CcpQpqReWhYH1dpW3QGHPSHQ1VbAf3g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez0yz2DauOuJy=-CcpQpqReWhYH1dpW3QGHPSHQ1VbAf3g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KXRAsdprO7cLVnd3WqVBXSVnUnKlrRPga5KKRPBKV0A_1760643901
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9748440006
X-Rspamd-Server: rspam03
X-Stat-Signature: gys4pto3o7kufa783118ddnryyh6cjzq
X-HE-Tag: 1760643906-303878
X-HE-Meta: U2FsdGVkX1+SMGw/IUse7YZs+q1+tzq7ArMhHgAryHhsinkR2yED2/aRX6evTG9/IUn7vd0JcRvDBYBpvYWlSLEfZNLePgmpFla3vDaK6sUOASbtuHkud79YsyNEMHi2KdrZP5vtwRlV91x/cogtzCzDcG4w8s1U6gKaxDOBsGzFIetO2vRfU4qaQpRtNzw/qDIj/zhwt7SdYcXEhovX6GKuYjM9+jTvjj6u/XFZf5g/a03IlsXz83EJ6U9uX0xw0XOjRJpM3DSPK2CSrFgSeCWXWYUHr3IienB/ZZpWNPlYmKnw6P6hxf0wPrHXOKSiNYjseVMHwiMQEVHJjfOyCAivLGRA/EpFRZTEj3psjvaO/PCSSfctGoILwH6T+rWbRGal+iyeMhmRncynDILWJkjYHfBuwlXnkqWBxkggRP+4dT+jUVbK1He3eSXfKkRED+eVQokuEvQbc6bGp5plLkmYz22Lm360dkefdL7afC8pCmhd6GuTBnECan3Jb7tZb5ZfudK5t7wDLKhrBAQVSGLl8+oA8tPq3lyBRmHgMnbJqTcavB4CCEdzEGlLh63QZdgts0knS6JTTaYZ6ASWJVdBS2inqDt1DRTZmDlLIxlLDqYPxR/mI0iUrKK6Ahl/L1peXKnQ52+uHhd7IQeE/7IYl+hC6Hk9tI+pkN7riT3OzvUpDlGN6oc613U197dlTCvLrykRygxfi/HcASo2IrAtoXfm/DJnYFSpuZ+YwPHmzllzeWJIOZaJgYsBi8z6EqjR1/EdA0hp1yhe08IV2ZKFbdnuAXZZ8YYEn2iwu/isvlDrRk9pZcu4RDgbj/NvV1+riqhukUsadsOFJfEod70EdosC/CkyqMq39g1ZXm3q7so3bOwykZshl+Wnqug0/wSSHrNn4GW/uQC7bevqCCVD7YmU7Seh3iHnnTPMXBmGznqaMffDI4+Z7yidQeOnWfrzhGQGJpWRIkENbUX
 JFNP5vF4
 7s2zdK4uset1GTQmDZxwXlhuaG8Fv+MRlWTlhOuF9LZCkyijRKS9I/Xn1EC6bReJ5F5Ia/XRPqbX9rhP0DrrwS7x6sexlHuTDfgb8xoxIoosoKzELhYIaI3P0K2k9c0xHRTrixCyZ9huTj9sw2+P2GzoWefmfK/I9UP8CDG/dKuBisVp1ouzGY3bpA16087lKKI+h2DM7w0m5gQJJ6vaiqbr7LyZ+HyyrucjVSG0KxGg9lxDxP0JjEp+8LObuMWvFZOENGD5wrzhkKpq6o1v8p41aOu/WyHtsIDsuUscCoPtZRIn92+eW6SFX9FBu16Iuhq+//rRCpOveVHB1RxUdTOjiDXYFDV8I+RmPmpmAO5lk4LVz8VhY3PY+MjW8e86qDxavtzUX3Gm63SdVf/6xc5467xYiiG+7emaJkhI3xuBIxU9MM+qDR80OzQcWcko92hQ2uiGkWaVp4xJplybZU6jmVKhfjRKysyvyLnz3eC0MmHU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 21:26, Jann Horn wrote:
> On Thu, Oct 16, 2025 at 9:10 PM David Hildenbrand <david@redhat.com> wrote:
>>>> I'm currently looking at the fix and what sticks out is "Fix it with an
>>>> explicit broadcast IPI through tlb_remove_table_sync_one()".
>>>>
>>>> (I don't understand how the page table can be used for "normal,
>>>> non-hugetlb". I could only see how it is used for the remaining user for
>>>> hugetlb stuff, but that's different question)
>>>
>>> If I remember correctly:
>>> When a hugetlb shared page table drops to refcount 1, it turns into a
>>> normal page table. If you then afterwards split the hugetlb VMA, unmap
>>> one half of it, and place a new unrelated VMA in its place, the same
>>> page table will be reused for PTEs of this new unrelated VMA.
>>
>> That makes sense.
>>
>>>
>>> So the scenario would be:
>>>
>>> 1. Initially, we have a hugetlb shared page table covering 1G of
>>> address space which maps hugetlb 2M pages, which is used by two
>>> hugetlb VMAs in different processes (processes P1 and P2).
>>> 2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
>>> walks down through the PUD entry that points to the shared page table,
>>> then when it reaches the loop in gup_fast_pmd_range() gets interrupted
>>> for a while by an NMI or preempted by the hypervisor or something.
>>> 3. P2 removes its VMA, and the hugetlb shared page table effectively
>>> becomes a normal page table in P1.
>>> 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
>>> leaving two VMAs VMA1 and VMA2.
>>> 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
>>> example an anonymous private VMA.
>>> 6. P1 populates VMA3 with page table entries.
>>> 7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
>>> uses the new PMD/PTE entries created for VMA3.
>>
>> Yeah, sounds possible. And nasty.
>>
>>>
>>>> How does the fix work when an architecture does not issue IPIs for TLB
>>>> shootdown? To handle gup-fast on these architectures, we use RCU.
>>>
>>> gup-fast disables interrupts, which synchronizes against both RCU and IPI.
>>
>> Right, but RCU is only used for prevent walking a page table that has
>> been freed+reused in the meantime (prevent us from de-referencing
>> garbage entries).
>>
>> It does not prevent walking the now-unshared page table that has been
>> modified by the other process.
> 
> Hm, I'm a bit lost... which page table walk implementation are you
> worried about that accesses page tables purely with RCU? I believe all
> page table walks should be happening either with interrupts off (in
> gup_fast()) or under the protection of higher-level locks; in
> particular, hugetlb page walks take an extra hugetlb specific lock
> (for hugetlb VMAs that are eligible for page table sharing, that is
> the rw_sema in hugetlb_vma_lock).

I'm only concerned about gup-fast, but your comment below explains why 
your fix works as it triggers an IPI in any case, not just during the 
TLB flush.

Sorry for missing that detail.

> 
> Regarding gup_fast():
> 
> In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is defined, the fix
> commit 1013af4f585f uses a synchronous IPI with
> tlb_remove_table_sync_one() to wait for any concurrent GUP-fast
> software page table walks, and some time after the call to
> huge_pmd_unshare() we will do a TLB flush that synchronizes against
> hardware page table walks.

Right, so we definetly issue an IPI.

> 
> In the case where CONFIG_MMU_GATHER_RCU_TABLE_FREE is not defined, I
> believe the expectation is that the TLB flush implicitly does an IPI
> which synchronizes against both software and hardware page table
> walks.

Yes, that's what I had in mind, not an explicit sync.


So the big question is whether we could avoid this IPI on every unsharing.

Assume we would ever reuse a page table that was shared, we'd have to do 
this IPI only before freeing the page table I guess, or free the page 
table through RCU.

-- 
Cheers

David / dhildenb


