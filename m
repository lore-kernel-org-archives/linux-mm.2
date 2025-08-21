Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527B2CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B9C8E0057; Thu, 21 Aug 2025 16:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D237C8E0056; Thu, 21 Aug 2025 16:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA45D8E0057; Thu, 21 Aug 2025 16:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9218C8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:49:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DDBE14022A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:19 +0000 (UTC)
X-FDA: 83801954838.13.3B07203
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0D4214000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G40SbERB;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755809356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQbfbvrWDouK+ZcKIphQE1nervr1PSIMFSTWfTxDfjA=;
	b=jDnYaR+5A8bUYNTSh8XUfhHboW+GdibJR2sbAFz6h24TjHT7sNrAUPpgvbhAbsrKtIsrI9
	RU+Hnp4QvFdwQ4jiO0oRaSWVrim1Ku+lixyBzI84gfx65tlDGwPLO31NGDRjNt1+ejdUhY
	3xUX1b9ig+rZk4NRdJvk9ASY7l27xvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755809356; a=rsa-sha256;
	cv=none;
	b=F8x3v4SYWUjBfevq+mltsGWqRnQEPOhsyP20QpWiVS5tnOSw+pqUaZszmgyPgXj4HRgNty
	oRgDpcW0ztLV8C++GeGfc+W5r4XS9m9H+fIc8OvviKo/2+Zs8cPb3sGG3gxrVcJymJi4Fc
	JQMFIWMWADRZhuccG3vECASJEB+xYOU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G40SbERB;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OQbfbvrWDouK+ZcKIphQE1nervr1PSIMFSTWfTxDfjA=;
	b=G40SbERBJh+llM8CAKgG2B3k8FjrE5hIXCq1ar/UQVQSUJ4IdqSKKuzvTm661gIjP3WNLP
	JNzZ475Kkf3BemLcxh6G1AzU13YsAEZiT/JXPsB1QTM3Lkotehf9TPH8Q7UDHEG78MP5RS
	34NbAef/ZzkwMcl75fsfXwlzf8McXvk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-QZpJc3w5M7i5t4QTCN3ztg-1; Thu, 21 Aug 2025 16:49:12 -0400
X-MC-Unique: QZpJc3w5M7i5t4QTCN3ztg-1
X-Mimecast-MFC-AGG-ID: QZpJc3w5M7i5t4QTCN3ztg_1755809351
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso7963505e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755809351; x=1756414151;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQbfbvrWDouK+ZcKIphQE1nervr1PSIMFSTWfTxDfjA=;
        b=buySvqOBSXP1RVJ9j+xeYVos7OJsQsbzZoFua77L/pp2ALSYTZ9xLVBQzWHvsQ1Z9Z
         Km4oCrltjSyQXywK7MXUsQ0Hr4mIi23KhOt8WJKAbPy11VpVSPqeW5p0tKHh9Y8lIyR5
         YOP/CPy8mA6MqEkdId7jnmNt+NBKGU0TcZr8doob9CkY8itgxzaOQFULKsx2Y8QYiPbA
         5Mh0TrwZs6kRtmwP1P43CF6Q0YZsWQr2owMhT0aRd79p3+S9ztoH0iujs/Atf7iHcvR9
         Z78vU/BxIwlJkgcZ0x36+d/YK/Fd288MYNkc2OsJqPIDhArirO/oLdKdXMMfdGBSTIbb
         SumA==
X-Forwarded-Encrypted: i=1; AJvYcCWm2zNFfZLGn5hyMbXrglx6g3H76RCbmQ0mm+0lpSilfV/CQbCDNYBVy1IE8kJOiTRQeS2HPCT82Q==@kvack.org
X-Gm-Message-State: AOJu0Yx2BOxY6alFKeQ5JZ4lgeY/dU74oU3pk661/gxUwno0Tayf0EyY
	AKT2LdcSbckcVreEtNCc7naCTcnq1RS7lz1300TWJGGTYaos2S8bJl4d95X6OEax+1shMaPpvNR
	SeFNDlAEATBqpUcEfhk5GJQxvGk5dzylFL7Jt7eX6gbdVxUw3BPdG
X-Gm-Gg: ASbGncujQIrvXIVN+9tTkoFNFiI1q2ws91DR5r2K4dXEsfQv+BhaSk8jtrI9NHNT1pD
	jfwmN7euCcyUocaGovfgz7uZprXnO9VdudDmUewt077EfmXVp1yfSJvf0JeRj/iUijbpGuW14z7
	xmd3lrkOzSVwfzp+F0ZuBAUmhXuXzinkxRAT7Nj+W3Ywxw8vTm+kH3ElIS7F+/Q7CaZIUkzQB4U
	H5CSJb4o5QFEBUCTzrasZlcwnjfLI/mfMlTv6aYmHJaperwfZDWYotmBjgfCsjlfgDIpOGH+wSj
	6ZcPYQZFKL++lfHtiVu8u28jzyvnS/iyys3dw/Wy/KlR7Jn+L0KJFM04IqYI99/wFuGZDm2jgiy
	OQ0QHPwlp+rlQml+H+uubm2JwRV4vSL2E7h9nJY+iUDy3WDxM8krN5EWYt9Ebhw==
X-Received: by 2002:a05:600c:3584:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45b517c5dc0mr2897985e9.22.1755809351421;
        Thu, 21 Aug 2025 13:49:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQxIz6cJmjwdOB6bO2j0uv4baEhvDU693i3u6jJ5B08S4e/6/ILSJ1Cj5B/IwK2GJTi24SIA==
X-Received: by 2002:a05:600c:3584:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45b517c5dc0mr2897695e9.22.1755809350879;
        Thu, 21 Aug 2025 13:49:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c4c218c599sm3550158f8f.67.2025.08.21.13.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:49:10 -0700 (PDT)
Message-ID: <835b776a-4e15-4821-a601-1470807373a1@redhat.com>
Date: Thu, 21 Aug 2025 22:49:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
 <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aCzoPIcDBdOVnaFiPntwFRy8qpYF90Hdss4F08lvc2s_1755809351
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0D4214000F
X-Stat-Signature: tj3uqx7jpmap3y5sxmpoaq1ip11qhjx8
X-HE-Tag: 1755809356-118370
X-HE-Meta: U2FsdGVkX18NXgeBklOFxCepQHrDBQaRlTMKvaLT5NQt+kiSfTRAYkK0Fr1WdawivUHbPpmXx1fbe3BpJCJHIXlo8/Y125wMoOk/oyqV1aE0VSABYg8mepk18QdQPp+oPS0rtouIfDa/3QBUvFpohufpkLlau92mV5itdh90dpF9588w2EL7utyJX2xcEBJmREWkO/g+DYG848sC/h42NC1OPQs3h/Pe+6NP2QOEd5THVr4IBfhyBEFgVolh00KAqRGgsXf4apyEB5vqxnlJHGSbyyqBoNuJ1nMt1HD9GTRaCHKZBwr8iOzYPB+VR8zf+rQTXdvs3Z7mfry26HGpmdWoT+SkMC59IIJDCYK5MSnsBO6ZSHgyFwEx5ZTp+NVg/zfMDA8dxWlYrPARVaxXbpsNJKA3fvCVJVtrOmN9+b10wQL5v7LeJAthlVO944Ast0GIC3ijQV3bAMcozxnQZjp5aFUG9o66dRuWdrCeMiuBKz2MIm0Y8OC1zLoPlp8NzNTdktbVGcqGCM9fDUepXgG4CJLdmqAXXYCmGqg+c8E9iyyZspieyLxoBgkzgnLXZ2X5lP3+XFnlEHB38yo+fKnQpDBFTyBuON6tPflOXqackwoEjziJDqJSvIeQD651Izr0KoytS6+h9DdGTvlrEG9jkbCN/Q21N5EiqbgfpBxRvb/PokcBpG7yxK4UzuVR9Un1r9glOQcjde2hLPLyGOOYoD8uypKTZf1F1JXiPlFsf1SmOmZMMBRPT3jyMwOOm77vbnzHMUTwK/5BwsFWePp7hp3mE1p0b9sGH9+RUZVSc1r/OyvKCCNoGWrUki+ny1LhuYvlKP1VW0l+ew7WSPEB4F8vkwjqp73zqzk6D1IlTlKwie710sGukPnZbcMJWaNJBxJT16CDvqQ2pESWWPBSOP14YzsfDtgwg2W0cyVljQBq/SN1kOUiWIHM14D3hrSs9NOuDR+UuNks/gc
 HfLRFyu+
 H4m/qI5M3aROAZKoJ8+oU14kQPyZMivCnZSmLQsY+T48R+MY18qfUOZwcLq4ZK+lMXI5OVKnZ9eMgdsA7zn19Oq1yQTFv8nRGbRmozgBVvGmzoHhQg0mGYK56eReaR/U7j7Gw6jZLP1CAwUngU8bIu1nT9H6NjVvcqLLgCoL0BMQEPTwEdX9WouTE7ir4ObIlb4jwaC5eZetz/kJvsiOsxWA5h1rsxjWzUf5gADggpnL2b24cJUal2TN+qxb1DAgdKNH0fIm6ybzu49H4E3p+d6/ES39zTP4vFFnEio1Wn8I1C49BsK58XRmmMHeN+lgaWGmYzykSVKo4coogdLpxKQl1wvS3kVdpNj/WO9VUVoq4qGwau2gjjisgy9gI0OLNgJiQljUjpmRCxEw+lIbr3xO2fNMYIH/4K9v2Z2LSlgyKXl0OkBWyq9onIkKd4u+jWrarM7IrCjOyMMoTn89GqEkqw1eRaPqMLJ/o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 22:46, Zi Yan wrote:
> On 21 Aug 2025, at 16:06, David Hildenbrand wrote:
> 
>> Let's limit the maximum folio size in problematic kernel config where
>> the memmap is allocated per memory section (SPARSEMEM without
>> SPARSEMEM_VMEMMAP) to a single memory section.
>>
>> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>> but not SPARSEMEM_VMEMMAP: sh.
>>
>> Fortunately, the biggest hugetlb size sh supports is 64 MiB
>> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>>
>> As folios and memory sections are naturally aligned to their order-2 size
>> in memory, consequently a single folio can no longer span multiple memory
>> sections on these problematic kernel configs.
>>
>> nth_page() is no longer required when operating within a single compound
>> page / folio.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/mm.h | 22 ++++++++++++++++++----
>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 77737cbf2216a..48a985e17ef4e 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>>   	return folio_large_nr_pages(folio);
>>   }
>>
>> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#define MAX_FOLIO_ORDER		PUD_ORDER
>> -#else
>> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>> +/*
>> + * We don't expect any folios that exceed buddy sizes (and consequently
>> + * memory sections).
>> + */
>>   #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +/*
>> + * Only pages within a single memory section are guaranteed to be
>> + * contiguous. By limiting folios to a single memory section, all folio
>> + * pages are guaranteed to be contiguous.
>> + */
>> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
>> +#else
>> +/*
>> + * There is no real limit on the folio size. We limit them to the maximum we
>> + * currently expect.
> 
> The comment about hugetlbfs is helpful here, since the other folios are still
> limited by buddy allocator’s MAX_ORDER.

Yeah, but the old comment was wrong (there is DAX).

I can add here "currently expect (e.g., hugetlfs, dax)."

-- 
Cheers

David / dhildenb


