Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B308CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B948E0014; Mon, 29 Sep 2025 12:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461EB8E0002; Mon, 29 Sep 2025 12:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3510F8E0014; Mon, 29 Sep 2025 12:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21C538E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:12:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A84CC140404
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:12:54 +0000 (UTC)
X-FDA: 83942781468.26.069C42D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E2A2160011
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:12:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CZl6iC67;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759162372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzvElMudVSfvbJETPxHv1iAKDOnPfrzp7voXLszfl/0=;
	b=DWR6bxdsfwPcnHHJG+mUrcBR78y74viohJJ+4WfeD16H8VmnELjFH/4zH2vmJRBXB8+op5
	dIFF2/q2AAsqNA1qaK0wVPRdaoMbgx3rDc/KTUjrMabUrd6WBtRIIl540XPykqgY6m/9E9
	m7GXdLICLDzgxUv30tsQN+xpsY8qmfI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CZl6iC67;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759162372; a=rsa-sha256;
	cv=none;
	b=s2+QWTdmo0NbhNLug5trMKh2/xV5k183SgKbWi4tX1n7ZwDvWi9T1W56gAFqispkP7+gUt
	V+k+H84MrtDm9pOQp6vXaC6c6pGYIsmYOAneQl+vViboE3FNvQnKOz09hvmQdAwANy9mHD
	K9BlWdS2XwG1PJK2o7T8EjCF1PFCScY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759162371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OzvElMudVSfvbJETPxHv1iAKDOnPfrzp7voXLszfl/0=;
	b=CZl6iC67LGPwuaqx90P88zejKIxlKK6vxE+A0bSfNpcVYc6VJanKmjK7cu8IakRS4sRbdt
	dXUaNPbG/xFKleyOiE1i3HlqjcgNjEX/Z0P+OCEdF9t2E1k2MFpaqdBvi/NwWywF1m48BY
	JvO2CvX5jlzYRXeXN+b1l8C4vjzzOkk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-bhtpIyfvPKa1OYz1TVJwmA-1; Mon, 29 Sep 2025 12:12:48 -0400
X-MC-Unique: bhtpIyfvPKa1OYz1TVJwmA-1
X-Mimecast-MFC-AGG-ID: bhtpIyfvPKa1OYz1TVJwmA_1759162367
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e32eb4798so24441055e9.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759162367; x=1759767167;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OzvElMudVSfvbJETPxHv1iAKDOnPfrzp7voXLszfl/0=;
        b=VnQC9bbHWPRrWze/+SbLBDB1ZocB4fd0ZF+rVb0be1ZdFhNLkSL2VwQiJJ6WFWjFkj
         TbB9xsPJGe0vz/MKpKR4dfQjYKs/uIKEZ3EOxvR+OiyBw3GbzBXrp2thaspp29SPtIaU
         hqiUI4v3dl8tyOKXLzzNR4if6nd3W84VjiAdnjyG+RSGv84uISSEMWkj7baqIXTgI9Rz
         Oc3DDfzmgkuhpDfSdmFCfx66DiA5KX6U/NsHnaPorjv3nTgKUQDrDUgx7hYUhaBeiwiI
         ZeS/9UTn6YaqbszkXfeJjLv2xmi1HIESa5UAi2ORT5yWMt8VSpkiAJvBLJT16VQ0dFVK
         5TeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPjOrNhXo1lT7XeatLhHn1ipExl7UZB6Zvg1QuwD7W/DZnusHkdVMhS0XfH/ncqt7cBKzTV50fDg==@kvack.org
X-Gm-Message-State: AOJu0Yz/nOqekIfxjEyqSdxwq70s+XcWvbcjqa32Jl+xESk0VXp0r+9z
	48GsQLYi2hMo0Qs9L87JCt/InO/FVlsct/rzVYJ5XRiFGAVB8Z+H2TxTl8IkdSzXQxfLKzVohoZ
	2WQ4NXpH27bNXsDPNWZQK4Frup3BEgTqKogOv7QoPa9tABFrMYm4K
X-Gm-Gg: ASbGnctKhQDvb+0AIYMGjwnncW8JHMAVvoypni9MsC47FiPThZryWlVFH58Jvu7kxSq
	TNLXO58DkF/C0GWorMGkRdwdFavgzmNB2xa15tAzNgooj6NDgBo8XmwM8C3SERad3YcQm7TRwgh
	Uu8+s8Qv2CS1C0XFzWRONn77mUlaJFtnf4nTas8gZVBuIvTBavBMDHnFmxIN/pLURk6De+Ep/n6
	jIK6jwo/YVGPlPtsRve+ikhJiSlqkbfqzFT/woMGAwOmQT55/pRaeotUCOpR5La6IH/qHWTUBg1
	Rlx+neFRHCleDJTgTEsot24/T+BgITXLyudFxLAJ8+VKgy5iDMcNjD8miBnzSS3CvO+Yss8/H8s
	qyWU=
X-Received: by 2002:a05:600c:c04b:20b0:46e:4cd3:7d54 with SMTP id 5b1f17b1804b1-46e4cd3808cmr49439535e9.18.1759162366865;
        Mon, 29 Sep 2025 09:12:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1GaUJvPE9CIRgzTsnjb5wMg+CWX4smf8zPGHwXWsu5AFuVLyV5tu3ni+AZ0lmEZbiWGdluw==
X-Received: by 2002:a05:600c:c04b:20b0:46e:4cd3:7d54 with SMTP id 5b1f17b1804b1-46e4cd3808cmr49439145e9.18.1759162366448;
        Mon, 29 Sep 2025 09:12:46 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc82f2ff6sm18806375f8f.56.2025.09.29.09.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 09:12:45 -0700 (PDT)
Message-ID: <ea6aafea-59ea-4df4-b5e3-796cca047c76@redhat.com>
Date: Mon, 29 Sep 2025 18:12:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "Luck, Tony" <tony.luck@intel.com>
Cc: "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "Chen, Farrah" <farrah.chen@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <8ef5e3fd-2ee8-453a-b8ae-584e3d606aa4@redhat.com>
 <SA1PR11MB71303A772356C994DB932077891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <SA1PR11MB71303A772356C994DB932077891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aRmCsIjOheF2sO0_763646aoLu6Z89h9PfZ2xVRQ7yo_1759162367
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ih4cqwh5rhunqtgz8tyyf8y5td8h7fmz
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E2A2160011
X-Rspamd-Server: rspam04
X-HE-Tag: 1759162372-836474
X-HE-Meta: U2FsdGVkX1/KzsEsgIQjqfTfps9Hw0zrYmBrl4opeWonsdobWdsbIx08LTM4B0StYncl9VluokmhZ4Xm0/YwcZQjFKsC82PXmQVATejdjx2PA8KHUCrNm4oAAH9/j6pVHJ/QQlyIVJ8loPWgcrnEAEy4ay52hzm/le+jqrD+IKiEocWnjYdbiR8/Y0/q69drNzGAUAQmXL81jc0UwRTsQVrcb367BRRqAY5BdCVNaBltBszPnFz4tNxRFqM1CqEziIg91f+/3ep5y6E6V9yV7LRJ9jw87A+8Zt3TtnBuHSO1VNh6ZyaZm19aWFtP5R9FBu3XkgmF0pceUj2IFGNvUqXakv4sau7JP16v0QDmoLuCG8BauW5oY4VFkwPrIoFQtSfPz88Y13Lw/49hWyZ0YUs9feit47Gf9YnWR3eZs49Eerfvw1vw6lHWGFNl2kpq9IA7z0SAG62wa3vVkbLVLNLbf9gKCrE6J6L8/WxUnk8F8IRxplTeS/RBzwYuOU4Hmyrc4w652maVw+sJkGti2mk1ZlSoV+yqAxW2+2qAg23jWQzw2OTKDci8TqQRFwG0Hh0trL8RIZBk0uyBGSc6VM87CA6nrJl9bFt/8PgcuOPPqKjU3U4t7v0mDYeT1iQCXuG60QvhxI7h+Rvt6CMDpnX5kucOxu9MhXjAKWHU7hGL8QcL6//Yl5poic1LVChFC9fWABqJG4MK76FFOsxlyqTZDnuZWpy0GQSTe3kShOYp8fppTSkpLj6t7/AKKIu+ch6/xXxcBgvU4JvsxGk1tsj2sAe/O0Hu7LnKi6xTGvoQlgoG7XsiovoxyejBj8nFQm46bnLynbg9Q9iUhnZ9VwS6px1k59rLGwClZOXIRLnY7c7eU5X/fuG6fXg5HJCpgjfcy3qzEUzkcYzDJxya8gXSOV9n3DUeHGXmypp5w2sCbzEWZcxoiz1A3ZbCiM2wallc672VJoJoa54jVMc
 lrTrjFVx
 1Atvkeidng5el8X6MFEEsUvj8cy8KXjucwNVic1pG+3dZCzAz2RR/WVGTLoR72MaY2m4RviAEd7lVouvJwrCYD/ynXzZN2UAB1if/dzbz3hAFTl4RNurH87LM22/mjYh3oaggrZg8wjhTXJYyQfjo/Cd+mmmqSaKZG3zDnelugXjT5y0QFa0Ek+3o9lHE3ENo/MOPXEHxgs5YhV8YC/LWJL03cwYVJnDoSEj0aNt+Mrvaa2xEyRdnF4moqDFzAXLBkYA3GJGDxQ6glSqfLPFTVEri6dzxTvDetOulg9wN9bNOelECyztdFrLoo9IcQDNrMQ9c5iCLofJCuPP2JMfyIRFjyWO3D9dyZuR502Lu0rLZ08SYR3uiTQprTqzL+iGrnAoi15L+cRXMACcypV/6fzxPGyndnU0gmUl0BSX4mQFpFQ8VV7mkAnwKZBfLmB4mhlhLj7HB0oNGO/3PHR6a6vV6CvZmxIuYCiRHSqTEjzIxrIVFuS+kuSGwvQ8sIbynO+9z0ZwKkx/sTDD+kgeb7z6xv24eurSk4BhaWXK579Ov6FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 15:52, Zhuo, Qiuxu wrote:
> Hi David,
> 
>> From: David Hildenbrand <david@redhat.com>
>> [...]
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2351,8 +2351,10 @@ int memory_failure(unsigned long pfn, int flags)
>>>    		 * otherwise it may race with THP split.
>>>    		 * And the flag can't be set in get_hwpoison_page() since
>>>    		 * it is called by soft offline too and it is just called
>>> -		 * for !MF_COUNT_INCREASED.  So here seems to be the best
>>> -		 * place.
>>> +		 * for !MF_COUNT_INCREASED.
>>> +		 * It also tells split_huge_page() to not bother using
>>> +		 * the shared zeropage -- the all-zeros check would
>>> +		 * consume the poison.  So here seems to be the best place.
>>>    		 *
>>>    		 * Don't need care about the above error handling paths for
>>>    		 * get_hwpoison_page() since they handle either free page
>>
>> Hm, I wonder if we should actually check in
>> try_to_map_unused_to_zeropage() whether the page has the hwpoison flag
>> set. Nothing wrong with scanning non-affected pages.
>>
> 
> Good point about continuing to scan non-affected pages for possible zeropage mapping.
> 
>> In thp_underused() we should just skip the folio entirely I guess, so keep it
>> simple.
>>
>> So what about something like this:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c index
>> 9c38a95e9f091..d4109fd7fa1f2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
>>           if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>                   return false;
>>
>> +       folio_contain_hwpoisoned_page(folio)
> 
> Typo here 😊?

Yes! :) As always, completely uncompiled.

> 
> if (folio_contain_hwpoisoned_page(folio))
> 
>> +               return false;
>> +
>>           for (i = 0; i < folio_nr_pages(folio); i++) {
>>                   kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>                   if (!memchr_inv(kaddr, 0, PAGE_SIZE)) { diff --git a/mm/migrate.c
>> b/mm/migrate.c index 9e5ef39ce73af..393fc2ffc96e5 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct
>> page_vma_mapped_walk *pvmw,
>>           pte_t newpte;
>>           void *addr;
>>
>> -       if (PageCompound(page))
>> +       if (PageCompound(page) || PageHWPoison(page))
>>                   return false;
>> +
>>           VM_BUG_ON_PAGE(!PageAnon(page), page);
>>           VM_BUG_ON_PAGE(!PageLocked(page), page);
>>           VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>>
> 
> I tested this diff and it works well.
> If there are no objections, I'll use this diff for v2.

Sounds good, thanks!

-- 
Cheers

David / dhildenb


