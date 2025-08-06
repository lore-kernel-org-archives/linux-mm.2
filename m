Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19954C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA0E8E0015; Wed,  6 Aug 2025 06:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A6F8E0001; Wed,  6 Aug 2025 06:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8627B8E0015; Wed,  6 Aug 2025 06:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 725A38E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:29:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 223D11603F0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:29:04 +0000 (UTC)
X-FDA: 83745959808.24.890B09C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5F14C000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:29:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iPmg3q+F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754476140; a=rsa-sha256;
	cv=none;
	b=zGpWDbzwcEMNPPsT22cg1/Yks6vzNyLjI+MJxKbyUr9mZ5wv3i2/TivfYanrEh8Cbpcv0p
	khwPn4r2tzGwjMvtDW/sWqY1IPaem8c4u7nH4yWOookgc2xmROaaalQAlQl8QbjoRIEeoY
	0qrlf7hFc83c6TYq0x2VpJx7gVM+CkQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iPmg3q+F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754476140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s85fEJ1hPbwJ1lBrvMiN3B9Ym2qPT06ksiPFgWtT3io=;
	b=ptvjCD+B603cf4cEVXFChBCOr+aZtEQqk0Zp+jg4p4lWYJ3ebWgbSC4HjsPhWq7ZhfWhEI
	arOBiPkLMB14jnq9Ty40MiGdSa8tOHW+ah7wUaK9uo193Li+b+QPCrV0sh1WkyOHkgf/ZL
	8hMyZSn7N/A2Myf1kWmBX4I2QJGVHC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754476140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s85fEJ1hPbwJ1lBrvMiN3B9Ym2qPT06ksiPFgWtT3io=;
	b=iPmg3q+F/sojUi33Z2fWC2fap8LUEfu4bx1xJ9+okO+6bFGL57aWkJfeiV0oZQ4961P5D/
	9KharUHSf3ABbvAbzmxR1nbEX83VlP87eg9CWRJ124R8aaTfiFClU4cXbOpo+D5fn4zsK5
	5C0RROzMqTHj180vKwQSQc0ojhRCboQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-VATewoarP7q1X-adnBonlQ-1; Wed, 06 Aug 2025 06:28:59 -0400
X-MC-Unique: VATewoarP7q1X-adnBonlQ-1
X-Mimecast-MFC-AGG-ID: VATewoarP7q1X-adnBonlQ_1754476138
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b8d612996cso3449439f8f.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 03:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754476137; x=1755080937;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s85fEJ1hPbwJ1lBrvMiN3B9Ym2qPT06ksiPFgWtT3io=;
        b=tN6ex/oQSy+4FpWxadQjieA0jDFP3qIYDuqnRMOvO7/2pkuYUwSdOrQ6VspVSDFucc
         ILaDYfahe9xOIgdhtHG9XfCLe6wMjuIDQFmpkjdctITR9MTZBRPLI8BJ9cJeBk/sRLLu
         HM6KT9f9OMPf6vEUW+5dh8eD/tPk3TtoyOLr9FJS+ZMGYeGM+HiyPkOrvKPcWYAwPNCS
         7HlT0qCWtkAxWdRojsqrzXfvPXgN6YXSGe6hakvOXm1pAsvZw1W7s0zcCYzUOYts9dON
         wy5KIScHL+HOyIz9BGHykrVO0S+IJl4oCKNRF+W7zhstOHqZMiNdrzEUL1t6u6kciRNC
         UwzA==
X-Forwarded-Encrypted: i=1; AJvYcCUVMUmrJdKGPee/trJaot3yY0b8TJOdbcWugT22XP7U4wvPyRSOy6NdLTDl6IhR5vpzkLCn21/r9Q==@kvack.org
X-Gm-Message-State: AOJu0YySodxrs8CQJGfO2B+A8YNYicYiyLJTUXM4DFqg1+v6YvZKU5Sa
	7/KJPq6qk3Fek40BS5rHkIAdfWI8j+HNW711CnJS0Am7M4rw0UFWu4UevCWoObLpdEKfIcN+YPi
	77zTd10HPzhZMeyyf7YUwUZlgHA83L22UrfDswIyhx6y6KEFCIE29LIFpYcHY
X-Gm-Gg: ASbGncvMdVzEyMbCYG+UjPkVAnRG/iYYqXXIqbis9UCRX+OUxx3vZok02Mw1+mWU+93
	UKmv9ZAAUuBRmn3duYvCpipouQj46g7HyoAQY+yNGR1PBV6yK9Rb7njbbSOpgJR9yssxB/vYbJp
	utpn9PGpQg5ypn8Ntiqdv8iut0aHS1pzD2Q8qLAB+lxR3nDf4kkPLyh+OxQnmF7jL8N1u6T+P4Q
	9S+RcGcuiyon3x5+gAbsWeVN3xA8b78QB8Cffy6EQEaSfg4hhIiWuATB9nrPmjV6rJaSobPAtIP
	P6z73NyTMerjtI2udQ2KrF3uW7Etz6JeRKRPQ01apPwaUvYaIuShJPQFDbTdU6HozeDZM9Y63F7
	GZ73CXXAzKd8QG/t9wzNpawY1ZLsA+baLzMvnFJJbBd8MsSNX4bo+DMQE/GdhK8Pqy24=
X-Received: by 2002:a05:6000:2908:b0:3b8:d1d9:70b0 with SMTP id ffacd0b85a97d-3b8f49274bemr1706360f8f.40.1754476137480;
        Wed, 06 Aug 2025 03:28:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqcuMGgXTI80XNd7U4VUy0jmmg4JtekFe2gy7z4uJGY7EhGa5/HqatfjsYaIs+GhSWHgVy7w==
X-Received: by 2002:a05:6000:2908:b0:3b8:d1d9:70b0 with SMTP id ffacd0b85a97d-3b8f49274bemr1706322f8f.40.1754476136998;
        Wed, 06 Aug 2025 03:28:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac036sm22401606f8f.15.2025.08.06.03.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 03:28:56 -0700 (PDT)
Message-ID: <aa496798-5ac6-4cb0-bdc2-91515172e935@redhat.com>
Date: Wed, 6 Aug 2025 12:28:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
 <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
 <2d0d58a4-bd27-41ac-9b25-1cd989c02383@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <2d0d58a4-bd27-41ac-9b25-1cd989c02383@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wPmVTOGS8h26XmEL10yX65wm9LPG-QtUiTOqD5LHRVs_1754476138
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5F14C000F
X-Stat-Signature: j75j7hk4s8u8on6pzb15widay839q8da
X-Rspam-User: 
X-HE-Tag: 1754476140-81807
X-HE-Meta: U2FsdGVkX18dttK+IcyQvC4ufnY1uPv44bJ5ETlwIqLk0g2YrI32Thu7/202CpQtP9VBj64E0nViTfoEtbWabvilPr0Ewr6Qv17QPhdLrQQ/W6nUwxPuyIBnrsuP9BzIdUTFeSl2GRMVPteG9xQtSwOdKSyXd5DDqS7vjdJO62oElRr6jl+uj1e+NbZgW60sZ+6az9pdARW7m87zST2jeajucHBkws7nO0WLur6okAIX1bv9CTn4xGDu6dTn4hqRsWOXd17dDzO+7NGK3HGYLzmenJGxXRy7gjviSaVlvmQPt3smUC+rbnlV1yTS7SHhdvsK7aD+I8uUq426dsmcerbforhtuXgp31DNA95RQZJ3pL5P6bfCqrH0A1kl384Yxz9KTHds+2V39n1wMkAyuAOHmJTLsQp/hVqGEtFCI8NnESHzwRCgLPim9o6CtuVwIDgIZ9DGfwV7k+09ZCWllmYU3qj0XSzAF5UsciyMKh0o59x2ZohopIw5hPNxvXQ03S1lXFYtRt9CcSH/Fsed7kC85kyhcUITnjT6bYNwdpdw3THX8h/61UPz2jf1L2d8WXX1WN7crYB/Vnwo5744fgci8vaHDZGw5RRBNWplQpP7kYDBDE7ATA4IC8Y921NA9ZChN2mOgYzN9GkTabU/722V6zUfpw8Us6J1gxPnkDTWxKmCsetMF8Owck0e3hfM+4OHkWFCL4ba6zAd0SQkcb5juAQW5jMifgRyv5a9t+buVqX327GZw7SweKR6H8VvdzGWDCRqtNsribHTVbg4gqiR52/4OGkFo0uoTjVP359mCYRc8pQNziYFConBBr5Dlw1tBriJnycMV67N/qVWSaRzYRNd0lkFHQZpzFjc3JBcFL9oW3Cdt+/vzWOa1T1L/6DdIR4vW4opm6TAIf20uLv6SCL+ClmtRv8KtoKF+RZoI3snmC6s1Fg3St+72yX7H/f7JA8dZC/w/248UP6
 KshJiQxM
 RZuEWpb97qWROf4Uu8z4K9kx0o3Z6WBDRJHKAam0zxyFBw8b0QJCQx3GaGSCPZQRcnjPL6UVbutSSgF4DuUzJ1eoBX0Q78hNiQbrTzPBEC3XqB+SDMEfxJEuSxtB4wmkgn8nrT4DId+E6wCUPprqfEPr5Yci99OcU0VqsmZPeujESDzjfvxxQmYpYAfaKy3Ja258UBIaH64PDn5Oh5GD3/d/uNeiEtDVFXiUWlHRRKR1A427z+15Xj9RHpaS671aLjPrx45AlFJZN+KFYAgG0btELRmi8vMh6Y73bRnxQmPXKD42BAEMhAtFmoaywtUSEGk4Dv0KGuAeyXRckyetT456OlebZw2lwO4k/Bje7A/p2Xr5SwPq3VHub5zKs6efk2wNby4mpAos3DitiduMS/Eh0EPmMKdBR2RFkWdS3Ls8blBvyVGM37KgIG0IrcgdPIaHwXxch6karZHUiGaAC07H73mH8UThM5YyAxlyV5RXlxPc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 12:20, Dev Jain wrote:
> 
> On 06/08/25 3:41 pm, David Hildenbrand wrote:
>> On 06.08.25 11:50, Lorenzo Stoakes wrote:
>>> On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
>>>>>>
>>>>>> You mean in _this_ PTE of the batch right? As we're invoking these
>>>>>> on each part
>>>>>> of the PTE table.
>>>>>>
>>>>>> I mean I guess we can simply do:
>>>>>>
>>>>>>       struct page *first_page = pte_page(ptent);
>>>>>>
>>>>>> Right?
>>>>>
>>>>> Yes, but we should forward the result from vm_normal_page(), which
>>>>> does
>>>>> exactly that for you, and increment the page accordingly as required,
>>>>> just like with the pte we are processing.
>>>>
>>>> Makes sense, so I guess I will have to change the signature of
>>>> prot_numa_skip()
>>>>
>>>> to pass a double ptr to a page instead of folio and derive the folio
>>>> in the
>>>> caller,
>>>>
>>>> and pass down both the folio and the page to
>>>> set_write_prot_commit_flush_ptes.
>>>
>>> I already don't love how we psas the folio back from there for very
>>> dubious
>>> benefit. I really hate the idea of having a struct **page parameter...
>>>
>>> I wonder if we should just have a quick fixup for hotfix, and refine
>>> this more
>>> later?
>>
>> This is not an issue in any released kernel, so we can do this properly.
>>
>> We should just remove that nested vm_normal_folio().
>>
>> Untested, but should give an idea what we can do.
> 
> This puts the overhead of vm_normal_folio() unconditionally into the
> pte_present path.
> 
> Although I am guessing that is already happening assuming prot_numa case
> is not the
> 
> hot path. This is fine by me. So I guess I shouldn't have done that
> "reuse the folio
> 
> from prot_numa case if possible" thingy at all :)

I mean, it only applies when trying to NUMA-protect something that is
already protected. Not sure how relevant that is in practice.

As we don't even batch these today, we could just do:

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4e0a22f7db495..2154a1a3c6656 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -127,10 +127,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
         bool toptier;
         int nid;
  
-       /* Avoid TLB flush if possible */
-       if (pte_protnone(oldpte))
-               goto skip;
-
         if (!folio)
                 goto skip;
  
@@ -304,6 +300,9 @@ static long change_pte_range(struct mmu_gather *tlb,
                         struct page *page;
                         pte_t ptent;
  
+                       if (prot_numa && pte_protnone(oldpte))
+                               continue;
+
                         page = vm_normal_folio(vma, addr, oldpte);
                         if (page)
                                 folio = page_folio(page);


But with my change, we could actually batch-skip such large folios,
because mprotect_folio_pte_batch() would see the folio.

-- 
Cheers,

David / dhildenb


