Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A143CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 18:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786568E0002; Fri, 12 Sep 2025 14:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737936B0011; Fri, 12 Sep 2025 14:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FED68E0002; Fri, 12 Sep 2025 14:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFE56B000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:07:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF51D1DFA55
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:07:09 +0000 (UTC)
X-FDA: 83881379778.24.CBB822F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B639140007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:07:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VldnXYru;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757700427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmdkZLbdLSDDxZDU8t/+sxOF1CdFc107tWgexy0Hn8I=;
	b=L/kXA76mLz/DX9aj5igkPWTsEf7MsxZZcKjYZBzJycUOyLwRqyACWE1BDYYQ1M+N74JHdS
	0TBN4vjnUbm6bIszcuy8QJRKdYLYjBoCCwixPgmLjKDvXGI0dngAT9rhP7iEJgkQnUfzu6
	9ex6+EQwA7emH6Qc9fnEfDaCNOQEXDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757700427; a=rsa-sha256;
	cv=none;
	b=pGVkapnYy79hPlcYREtiGWua/c96vKYyVxsC1166XDGzc3gtEbflJkuWEErZ1jfNH1RLYu
	5qseNHWqwbkTBCY0vW65AMkTCmv1fI3N7Q+LWJyPTbtbapeLeUj+FyqadFamQE/9XuiYt2
	vr1R2jmP+ohKpeft5BtcPepevPpCu8c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VldnXYru;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757700426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UmdkZLbdLSDDxZDU8t/+sxOF1CdFc107tWgexy0Hn8I=;
	b=VldnXYru3hwj7uqmg4N7V8nT8k336ohfsjFjkyUtGw/jmTFhU/sjffNDajFezAaMXOi5xx
	SOaGmgP4frVEtN1UZeBwHV0R1G1lSRd/ahLsgf0PueMW2jEPJ7nEvb8oRS/4yRVBpQot1d
	nTXrFelDF40zUQWFkmWMcXWwg5TkURg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-cExZD5x1NluJzbeFNBiYoA-1; Fri, 12 Sep 2025 14:07:05 -0400
X-MC-Unique: cExZD5x1NluJzbeFNBiYoA-1
X-Mimecast-MFC-AGG-ID: cExZD5x1NluJzbeFNBiYoA_1757700424
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cf12498799so1120691f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757700424; x=1758305224;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmdkZLbdLSDDxZDU8t/+sxOF1CdFc107tWgexy0Hn8I=;
        b=luAZactpC5YorwZmYXvR5hisei0X03rDkRuU9X+hBse/JeRHU1vbGbt1TyioJcYN5Q
         yXcKiWm/5R4LrvLHU2hoN0QHdPy0KtOWfoMTtqVgylUgtY6iAq8zKht6TlzM609/cQHK
         6Fcw26t0hvOTXbS7M9COnWZi6lw9zV3pebCXNAc0a0GS8BNC9BKg1WVYfaVDlPpUpJJF
         /9/TudZd95BrF8tFDHeKOOIKx3R9efFwKkVFyvyzSCeUXuIRx66bD9yd4EVUcJk4u+Kb
         BxWrTPFlBfrMXuAX69iCFYXeAxlwhxA+iA5xOWF1hitGKCG/s9T1yDMMDdeAEoIDDk4b
         vwxA==
X-Forwarded-Encrypted: i=1; AJvYcCXUopptEMkb/iA/iWPagagbxy85yKO+WxuFqmKmxLASVYuv3pqo5s+fr44yDlz2EqSN7cB371aZgA==@kvack.org
X-Gm-Message-State: AOJu0YxhQpGARDXiMxWw0cndCZpiczG6U/pBUu558HfV3rEClY9jWSmM
	hszeGPHTLw9Dqb1fm496Hlh992ikluGgy3HwQrLlvWwBpi2phq0b5JVwSR0C5Co8tDgi6yxCGxK
	AoLGZBOYvK8MVhWGnx2dUgRE4cxFwCDQkJ5Ddq5bGn88N8RiByu/R
X-Gm-Gg: ASbGncu/VsQTAlreWaPyRDxFFXkmCgxPGRGaPtdQvPjm5MUZ55sU//6bTlX3vShQQny
	0jpSD/KqKHkS6rS20L8VDA9UewxliJC5Y30PwqxNUsMUwakh3hDZLvgODZHeR9UL+UYRvYV/ERk
	5PuEf08J9PyjMNtNmA0gbSc3LLmBGgnbskJjizg80wEjHAQJc8J9dTIprFtY/Rb3xnRUjmbtfbb
	yF8cDhb6HUtR6HFWEiTMclbndvqCMxOpmtY4pNMNnt0kXa+9P6XzDxrazgyqTsUX/aWJqodgo4f
	kSdInv9WIpid+fWN8QxvHR55rfsa0RRSR89ZSD6eQ9z9r2G8zkIx5N1Bmzr/6+qlM1MGBp6K/3m
	Ttj5EJ4tfjb/WDNPHslPLlrVQ27GdZtWXc+dUSMMGh7s3AiB9Ro5DBem7c9MNy/Kf/HU=
X-Received: by 2002:a05:6000:144f:b0:3d8:1f1b:9c9f with SMTP id ffacd0b85a97d-3e765a160bfmr3166960f8f.55.1757700424143;
        Fri, 12 Sep 2025 11:07:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGheSJ2ELvEQp3ed99QgyzYKFelgt7XBLhRxYYBDYWhVp62sEY6MRvLFVYtuU2FXFbK7g3Sfg==
X-Received: by 2002:a05:6000:144f:b0:3d8:1f1b:9c9f with SMTP id ffacd0b85a97d-3e765a160bfmr3166934f8f.55.1757700423731;
        Fri, 12 Sep 2025 11:07:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760786ceasm7553054f8f.16.2025.09.12.11.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 11:07:03 -0700 (PDT)
Message-ID: <5ede233c-c8c6-4067-afb3-df94b4222cda@redhat.com>
Date: Fri, 12 Sep 2025 20:07:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
 <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
 <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
 <1da42002-9dad-45a7-98f8-90a97801002d@redhat.com>
 <8a524eda-c3fe-4e28-a24b-4050484e472f@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8a524eda-c3fe-4e28-a24b-4050484e472f@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hNtFPzdhoNXnH7ETcHx52ouNO01REy2Y1quRPxWqzZI_1757700424
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B639140007
X-Stat-Signature: oj9umf46iu1qjwh9y7ef9zy9ttgnsfse
X-Rspam-User: 
X-HE-Tag: 1757700427-887876
X-HE-Meta: U2FsdGVkX189wp7aJO8NfyvMhiAP5qkbY5eEkplKJSX2uLtbPiHCVHVL/0UMdJX59ETuusTCio4vRT4iYn2rP2aKhEwwFoe1nwzC29RO0jk/LfrKlbBXmyhHsPmAS3Zg8qaL7s/SBtQlm5EougjgcOyECWiUJaCNT8+vNMia6xAo8LAVuxzzj5Ct96/df/wAL3warHr05hdVlhoEiZAoHXD+Df7s9L76r0l8sLmjx1Avkgm90Rr4T0/YHEkAu7SMswvpVeDiBCRb2ObRbdXJAkuoyvcNQ2L3gLjrh159xWQZ/BMk8ZYVMS1twnGGowKPchnGQcNQXem2P3plB3WeB+V7tAkh/dq+JwaD4+DXHGjvbkiqp+H9SVFqBd0Mty/QjzExcbX9VqqP8E61RyYWLSz1PCWEX2tVUkzXGyClpCNQeyVJdUY4k4sHJwhB74VpqK70KZWUGkgiRFYtnqIQbbj6JVnp0Kn7I1eNiAeTx2YWFC93DvMK6oVAZ8rKTx8sf3ZAyGQQLzspI/YLgZkCZTLeI6k8YhFPJ2qj+BFTmqKkzHDWImnpfXElwudWIa/lcspYGjiPDlN/F94/V5m7mB1WrxxS4Ly/srqvo7Q0KAD9s7rHUNozBWXczQYbanrZhsCEw+qX+a86PjJ1qB24ti3q/EPVxodcg9SG6nSyMyJHNR/T94CVHa6GJ4rx6izGUjCXnEz46gyQXmecskc8cRDHvB3Dm+5V4+pbp+JvWqYjTUFPOJ4n72q1ShY76RR36ZSFxOQ/Lywz57QAWyGSM9BkWHtKzlGQmBJPxW5Chojg6gpW2omxMx9HsMkzwqmmmry9hHPbZE/5nEr4CgokMLY4ZWxzd+hm+tAJpljgJUW8fG2sGsU6W6+D0ALf2nWzXIDTnxg1PpaSDqzesFfmEs6cttdcNsPWbpOslFn89oL1IlCQm98IrRV9moFSF/4DnHy1gq1tJJxTT8m77r8
 8qqgdSN+
 Vh5chVDEXmKaGMhfwOyal1ClrhJEDaiZjzvf88yXQ5sfLAz5QXW1mbDfN1EHoehz21mWGcWhV10UGtAPkcbqjtdH9yDNq31UhqwMqHaUEujCNoa+8Z8nWPJpn5SF7scAYt4m48H1VfdoywutJ1de0FzyR4Qmm0MgUHDuUJ94NgbA1Xm/77Ghr83RcNo4cEpigx6MXzzZtqVM9Byi2ydafS134zJCaf/sUgX8nTPQoGzyNGnUZ8YVKVjECgwbdzGqz8KdyoUi/Qu50jwEzxlug1yLcWIcoZna3nFBabMNNcehATL9hB8boKgKZoz6//JZjhQUw2A4yjSPFSdDlgnTNbMJZtVwCeCs1FAGHzMNNzWvlF0WCA/6MYNDmHHiRKT1urDTc9I0ar3zBdZObBL0yRhIqMCNprUC5Vh1cPo3I3M4LT6os9VH/KGm5Z2D2psASHB0o25k5nUA5fPjJgRqYe8/pK11/gYdC6uZ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>>
>>> Would be interesting trying to see how much overhead would remain when
>>> just dealing
> 
> Patch2 skip atomic update in split_page() with alloc_contig_frozen_pages(),
> I could test performance about old alloc_contig_pages() with/without
> GFP_COMP and new alloc_contig_frozen_pages() when allocate same size.

Yes, that would be very interesting.

> 
>>>
>>> OTOH, maybe we can leave GFP_COMPOUND support in but make the function
>>> more generic, not limited to folios (I suspect many users will not want
>>> folios, except hugetlb).
>>>
> 
> Maybe just only add cma_alloc_frozen(), and
> cma_alloc()/hugetlb_cma_alloc_folio()
> is the wrapper that calls it and set page refcount, like what we did in
> other frozen allocation.
> 
> struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
> 				unsigned int align, gfp_t gfp);

I think it's weird that cma_alloc_frozen() consumes gfp_t when 
cma_alloc() doesn't. So I would wish that we can clean that up (-> 
remove gfp if possible).

So maybe we really want a

cma_alloc_frozen

and

cma_alloc_frozen_compound

whereby the latter consumes an "order" instead of "count + align".

> 
>>> Maybe just a
>>>
>>> struct page * cma_alloc_compound(struct cma *cma, unsigned int order,
>>> unsigned int align, bool no_warn);
>>
>> ^ no need for the align as I realized, just like
>> cma_alloc_folio() doesn't have.
> 
> since cma_alloc_frozen is more generic, we need keep align,
> 
>>
>> I do wonder why we decided to allow cma_alloc_folio() to consume gfp_t
>> flags when we don't do the same for cma_alloc().
>>
> 
> cma_alloc_folio() now is called by hugetlb allocation, the gfp could be
> htlb_alloc_mask(), with/without __GFP_THISNODE/__GFP_RETRY_MAYFAIL...
> and this could be used in alloc_contig_frozen_pages(),(eg,
> gfp_zone).

Take a look at alloc_contig_range_noprof() where I added

	__alloc_contig_verify_gfp_mask()

Essentially, we ignore

	GFP_ZONEMASK | __GFP_RECLAIMABLE | __GFP_WRITE | __GFP_HARDWALL
        | __GFP_THISNODE | __GFP_MOVABLE

And we *always* set __GFP_RETRY_MAYFAIL

I'd argue that hugetlb passing in random parameters that don't really 
make sense for contig allcoations is rather an issue and makes you 
believe that they would have any effect.

If cma_alloc doesn't provide them a cma_alloc_frozen or cma_alloc_folio 
shouldn't provide them.

> 
> For cma_alloc() unconditional use GFP_KERNEL from commit
> 6518202970c1 "mm/cma: remove unsupported gfp_mask parameter from
> cma_alloc()", but this is another story.
> 
> Back to this patchset, just add a new cma_alloc_frozen() shown
> above and directly call it in cma_alloc()/hugetlb_cma_alloc_folio(),
> get rid of folio_alloc_frozen_gigantic() and cma_alloc_folio(), and
> we could do more optimization in the next step.

Yeah, that's probably a good first step, but while at it I would hope we 
could just cleanup the gfp stuff and provide a more consistent interface.

-- 
Cheers

David / dhildenb


