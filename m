Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47F0C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4558E0002; Tue,  5 Aug 2025 06:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654E08E0001; Tue,  5 Aug 2025 06:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C4A8E0002; Tue,  5 Aug 2025 06:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A80B8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:35:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6527C0144
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:35:21 +0000 (UTC)
X-FDA: 83742346842.08.6BC2A7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 377D0C0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:35:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fQDuVivy;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=894SiI2/fY9/koqN6aMtskvCnlH/KvMKu9PCRPNaiDI=;
	b=CDAs8/p2U7RfTlpWyg13Icvu+YxzQvZY+miD0mxsRbYaMrh7+A1HAnSdQpXKLZ/ccx9tIH
	MmtgZcgZCYAOSXCAK7BQ3jZxWMyQbEyybPtBHV4uhazrCd2F0ChvfyTJuv6WxlogsjKa4t
	C7Pu0vlreglVRGAIAJw50UXAETf9hN8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fQDuVivy;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754390119; a=rsa-sha256;
	cv=none;
	b=8XygGsV/2VXzCSBxcZ04bm5XFhoLfbBI/1CNifP6XCEfgNW9elhegF5evDfHHmhHq/yONS
	WBtmrPyoJ8bKdcbsXXvGS7nAHNxfaWah88Rga46BI724dQBnevHmBbu3Tkh8QjxID9E/Cn
	jqPkd14g3uZ5jvrHw/4QPLj3i2CDk5Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754390118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=894SiI2/fY9/koqN6aMtskvCnlH/KvMKu9PCRPNaiDI=;
	b=fQDuVivyFSa/ORmTo4vi2jl0mUd/YefwxuWbDWv1lPseCncIl+3L0ZfHS5QH1J6Z/ERxna
	5q2mLds9vtU9E1Li/BI3M+O+nb2Esla0N109QmZRoh2eVozXgcKVC8j6Z98rsrMsYbBJ5B
	HP8UCnuW/qHoo8VihHlJsjV9FpWAg0c=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-jvW6bNXCPGqRwXlh2qCLSQ-1; Tue, 05 Aug 2025 06:35:15 -0400
X-MC-Unique: jvW6bNXCPGqRwXlh2qCLSQ-1
X-Mimecast-MFC-AGG-ID: jvW6bNXCPGqRwXlh2qCLSQ_1754390114
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b8ab4b478so2901907e87.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390114; x=1754994914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=894SiI2/fY9/koqN6aMtskvCnlH/KvMKu9PCRPNaiDI=;
        b=opiMK+DClAkcwrL5Nw1z/ZaT/yyKFLrKysbTDSXvvoytMy97FAIoutXI3CB5yiHn7K
         ClKy3k94f8KfE9b3Bsxaokzdyt4UKi08GtfYQgVmL7Z5R/8E5nxlMExI1D/CIJ2W9cMN
         WGqTo4NmkBexfEnQYhSVqYvbCbUOm+8YsGNRZ+f5i3cA0UE7KMT2tF3z0/+2baNMfHtf
         +/h1a/I8V0qD1jt1LDrzoDTtZIj3qeCbPp6fPOZHoedne2tJC2WPESc+W9fBdW/S8tAG
         moUbyvKa9XMwZuaIAKEJkVB5SLqQfpQAA4tlc0BuAm5DaTlmgCP2X9m7s+OE43P5Mzfu
         K9Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUhz6DGjOFVhSLaiS64wnLx/1jsWzH07awwe4c/NsTd1p+BxmJvKWbRb4VLJW7ON9iX7aVR8qIVJA==@kvack.org
X-Gm-Message-State: AOJu0Yy86Nrb1rsmWgLuThXzqU9eFf7K0cbCnjIq9E+6GZwkcYMBVmlg
	6dn4EdY3xnB0i/YFGXAQsO+7zEsTQZidUYEyQWHNAD6qnxcjm49AoTBqnz/48GFFX4ic6+ydyJn
	jetBp3zn6MNZBHXYV/7RwFpcz7wqGZXUDLj9EeItmZ0AS8tVz2+k=
X-Gm-Gg: ASbGnct8EfYOEZUl14RjVkC0rq3KytmBCdnMj0sR+S8VNKMPB33//94X0iY4kpni0Nu
	h2P7Zc34oVgM6DQtbRgrWXGGgIJpMDYVxcpwR/IP0Cwkwb2ljn4OUKRWuLrIyYlUwPTRsvS/gnj
	OvJ9mVl+3JX3zD78xrDYel/b6KfuQh68o8EtjYb5Cx2/MXA6PougGzxXmAUPjZglY83X/v5RiMX
	l0F0CE1No9Ky9SPPi6hV9c/+hcxfR5i2lZKdTduyiKFXSioJyUsTj/3zITv3OnD6vEBQnVAje9+
	B6xJ+gvuijs5ZPpPIj623x7jyYP2bN9Hv1iMaU6AdkZoTco0zhJbBhfKhl1SCctDHw==
X-Received: by 2002:a05:6512:3b28:b0:55b:822a:3ca2 with SMTP id 2adb3069b0e04-55b97a8b6d4mr3460820e87.13.1754390113653;
        Tue, 05 Aug 2025 03:35:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMPydzvB1MxHAirhVYP4BK0ywZFVHEmje/lMvvFJjFu+K7Cg8lZTaUjG1l5MvkMhLB1PQbsA==
X-Received: by 2002:a05:6512:3b28:b0:55b:822a:3ca2 with SMTP id 2adb3069b0e04-55b97a8b6d4mr3460793e87.13.1754390113099;
        Tue, 05 Aug 2025 03:35:13 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cabf55sm1927641e87.147.2025.08.05.03.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:35:12 -0700 (PDT)
Message-ID: <6a08fa8f-bc39-4389-aa52-d95f82538a91@redhat.com>
Date: Tue, 5 Aug 2025 13:35:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
 <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
 <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
 <196f11f8-1661-40d2-b6b7-64958efd8b3b@redhat.com>
 <ede98867-bc17-4894-a375-d17d8f83dd55@nvidia.com>
 <087e40e6-3b3f-4a02-8270-7e6cfdb56a04@redhat.com>
 <b3f97ffd-2e25-4df6-9da5-65264ee6916b@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <b3f97ffd-2e25-4df6-9da5-65264ee6916b@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0GykV_5Kf9WOq7_k314BzwgoNJdWPjYdvt4hGCRWX6c_1754390114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jbbzgfr9xmt46rd3rqea6r1fyk5kuc8q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 377D0C0005
X-Rspam-User: 
X-HE-Tag: 1754390119-569077
X-HE-Meta: U2FsdGVkX1/6EgH6zD4kNY95yEV1hfHi0qTLA1X/Tku3kF5ZkAprHi68pMOghloEmxYMiKVuAws2QgTll/XHcZPoI+3d1jWZun8Z7XzR3pqmAQELrwNUjoehI/lHRS3dBrxEjVLuPYGsBBPVltfQob0NIwXSv9+UTbpQLY14DcvLiQA9L2z6MS1LueWoT0OdSRtNJHkvvKL47wDO5WFoDozcDoBUsm+AZZCxKw5vW8YlMOOGRwDGRDuSisdlXNhHJXZJDIOmHpFm+jva8ImCGkLh8ou/03ncH2uNbkU5SD/WELvcmo6eiB+tvvXauU/3QTfTo0vPdKVv+ZwH60LxIhwA0WgJDsDnL9B97M/4PYSrE2jkBqtK141mn10RWnAPov/FWBBCOEhtamAwWyIxZx8YQnuw3ypxVHV7WKdvMFcqAMq83VOlAtT0UhQ3GdR747Owei0g6gdo5pv69YpiLzo55YtzYMsgGAt40b4VZx+4bnK/OYqEOezR+S0PndtyNDwo5JBB2q6YP5fMfqJkEce5vmUIBY00TbQWDHakKa3jSFvbTVHNQAo4tuMgbak9kGBYfgfEMlZkkRvwE4RWkIqxXUK7iWvHHUNmdGO5Xg5rsiGtD1r20fbqfT3btBMu+iFIcdQz5ZkJJNMRTUHIzlQiBICQYvdJv4LetAiZh/SXl/C9M6jE6apbYEuAjrXfKZe66ik1MHe8sAPJZ8gx9Io6TvOZJ8wtl+9oO/pdqAE85s/M3vNyfTUh5yk9CWOh055X/KKqNCtxrVfPhUdBHft1l1wa77TmCkD7ZbJpamTP6UAk2FPgnJNTOXaXLWo0/oyCluNC4w6tKUQ2sPC/STyoJJGU4t0Jxelggy20MeHmek96ibXNXuhczRatxB0GZ/F/PBlPkZDTSadjBMTg+ZFNaAyhNahwCeW7OxHRM9qcVud6RFNlS8psAiYTCiv4Uo5Q3d9mw21GNd4GLfX
 JR63RnmN
 BsQ2NRqDv+stEdIJlnk9ATSyQI2u39F3PUcaIE0uJJDnBG1Z5gPcHboK6Z8yoRMVNBYa1CVwR+zfW4mX+BMg9x072f7G1vTg5tDtx9X3STk+akBo0OOMQzpDEPrwJn4rJk/jZXBu3nL5J0D4jLR0nUgXtGYx3dtflu0u994vTf3fIHVHYipMLYfeH74Q0/TSjfjty0PPx5syHIPTl4mnuntaXB0uhWARFMHMdaU+LMoM7k6BtiuzwS4MD4tWBlt4VZCB/18uc/v95PZ/gnf3VdckMr7/jE+7iC589B1eNpbb3+yDbZilQwELCowpYZc6EZWxWqRtYu6/V1ItkJ2UyyH1y6OV6fp5YAvxJ4jMcs9LzLd+YXOeFQNTN1fm6U5TTOY78ytGnboT6urV33cEHD+Fdl0sVEIZ6XNAwOUplzRqB5duVjHZCDWInlT0a0Z4W1uoMZ04ZaQgLdcngQrCqM42HQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/5/25 13:27, Balbir Singh wrote:

> On 8/5/25 14:24, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/5/25 07:10, Balbir Singh wrote:
>>> On 8/5/25 09:26, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>> On 8/5/25 01:46, Balbir Singh wrote:
>>>>> On 8/2/25 22:13, Mika Penttilä wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>>>>> FYI:
>>>>>>>
>>>>>>> I have the following patch on top of my series that seems to make it work
>>>>>>> without requiring the helper to split device private folios
>>>>>>>
>>>>>> I think this looks much better!
>>>>>>
>>>>> Thanks!
>>>>>
>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>> ---
>>>>>>>  include/linux/huge_mm.h |  1 -
>>>>>>>  lib/test_hmm.c          | 11 +++++-
>>>>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>>>>  		vm_flags_t vm_flags);
>>>>>>>  
>>>>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>>> -int split_device_private_folio(struct folio *folio);
>>>>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>  		unsigned int new_order, bool unmapped);
>>>>>>>  int min_order_for_split(struct folio *folio);
>>>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>>>> index 341ae2af44ec..444477785882 100644
>>>>>>> --- a/lib/test_hmm.c
>>>>>>> +++ b/lib/test_hmm.c
>>>>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>>>>  	 */
>>>>>>> -	rpage = vmf->page->zone_device_data;
>>>>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>>>>  	dmirror = rpage->zone_device_data;
>>>>>>>  
>>>>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>>>>  	order = folio_order(page_folio(vmf->page));
>>>>>>>  	nr = 1 << order;
>>>>>>>  
>>>>>>> +	/*
>>>>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>>>>> +	 */
>>>>>>> +	if (vmf->pte) {
>>>>>>> +		order = 0;
>>>>>>> +		nr = 1;
>>>>>>> +	}
>>>>>>> +
>>>>>>>  	/*
>>>>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>>>>  	 * large number of cpus that might not scale well.
>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>>>>> --- a/mm/huge_memory.c
>>>>>>> +++ b/mm/huge_memory.c
>>>>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>>>>  					  struct shrink_control *sc);
>>>>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>>>  					 struct shrink_control *sc);
>>>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>>> -		struct page *split_at, struct xa_state *xas,
>>>>>>> -		struct address_space *mapping, bool uniform_split);
>>>>>>> -
>>>>>>>  static bool split_underused_thp = true;
>>>>>>>  
>>>>>>>  static atomic_t huge_zero_refcount;
>>>>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>>>>  }
>>>>>>>  
>>>>>>> -/**
>>>>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>> - * split folios for pages that are partially mapped
>>>>>>> - *
>>>>>>> - * @folio: the folio to split
>>>>>>> - *
>>>>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>> - */
>>>>>>> -int split_device_private_folio(struct folio *folio)
>>>>>>> -{
>>>>>>> -	struct folio *end_folio = folio_next(folio);
>>>>>>> -	struct folio *new_folio;
>>>>>>> -	int ret = 0;
>>>>>>> -
>>>>>>> -	/*
>>>>>>> -	 * Split the folio now. In the case of device
>>>>>>> -	 * private pages, this path is executed when
>>>>>>> -	 * the pmd is split and since freeze is not true
>>>>>>> -	 * it is likely the folio will be deferred_split.
>>>>>>> -	 *
>>>>>>> -	 * With device private pages, deferred splits of
>>>>>>> -	 * folios should be handled here to prevent partial
>>>>>>> -	 * unmaps from causing issues later on in migration
>>>>>>> -	 * and fault handling flows.
>>>>>>> -	 */
>>>>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>>> -	VM_WARN_ON(ret);
>>>>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>>>>> -								new_folio));
>>>>>>> -	}
>>>>>>> -
>>>>>>> -	/*
>>>>>>> -	 * Mark the end of the folio split for device private THP
>>>>>>> -	 * split
>>>>>>> -	 */
>>>>>>> -	zone_device_private_split_cb(folio, NULL);
>>>>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>> -	return ret;
>>>>>>> -}
>>>>>>> -
>>>>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>  		unsigned long haddr, bool freeze)
>>>>>>>  {
>>>>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>  				freeze = false;
>>>>>>>  			if (!freeze) {
>>>>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>>>>> -				unsigned long addr = haddr;
>>>>>>> -				struct folio *new_folio;
>>>>>>> -				struct folio *end_folio = folio_next(folio);
>>>>>>>  
>>>>>>>  				if (anon_exclusive)
>>>>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>>  
>>>>>>> -				folio_lock(folio);
>>>>>>> -				folio_get(folio);
>>>>>>> -
>>>>>>> -				split_device_private_folio(folio);
>>>>>>> -
>>>>>>> -				for (new_folio = folio_next(folio);
>>>>>>> -					new_folio != end_folio;
>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>> -					addr += PAGE_SIZE;
>>>>>>> -					folio_unlock(new_folio);
>>>>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>>>>> -						&new_folio->page, 1,
>>>>>>> -						vma, addr, rmap_flags);
>>>>>>> -				}
>>>>>>> -				folio_unlock(folio);
>>>>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>>>>> -						1, vma, haddr, rmap_flags);
>>>>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>>>> +				if (anon_exclusive)
>>>>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>>>> +						 vma, haddr, rmap_flags);
>>>>>>>  			}
>>>>>>>  		}
>>>>>>>  
>>>>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>  	if (nr_shmem_dropped)
>>>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>>>  
>>>>>>> -	if (!ret && is_anon)
>>>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>>>>  
>>>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>> index 49962ea19109..4264c0290d08 100644
>>>>>>> --- a/mm/migrate_device.c
>>>>>>> +++ b/mm/migrate_device.c
>>>>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>  			 * page table entry. Other special swap entries are not
>>>>>>>  			 * migratable, and we ignore regular swapped page.
>>>>>>>  			 */
>>>>>>> +			struct folio *folio;
>>>>>>> +
>>>>>>>  			entry = pte_to_swp_entry(pte);
>>>>>>>  			if (!is_device_private_entry(entry))
>>>>>>>  				goto next;
>>>>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>>>>  				goto next;
>>>>>>>  
>>>>>>> +			folio = page_folio(page);
>>>>>>> +			if (folio_test_large(folio)) {
>>>>>>> +				struct folio *new_folio;
>>>>>>> +				struct folio *new_fault_folio;
>>>>>>> +
>>>>>>> +				/*
>>>>>>> +				 * The reason for finding pmd present with a
>>>>>>> +				 * device private pte and a large folio for the
>>>>>>> +				 * pte is partial unmaps. Split the folio now
>>>>>>> +				 * for the migration to be handled correctly
>>>>>>> +				 */
>>>>>>> +				pte_unmap_unlock(ptep, ptl);
>>>>>>> +
>>>>>>> +				folio_get(folio);
>>>>>>> +				if (folio != fault_folio)
>>>>>>> +					folio_lock(folio);
>>>>>>> +				if (split_folio(folio)) {
>>>>>>> +					if (folio != fault_folio)
>>>>>>> +						folio_unlock(folio);
>>>>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>>>> +					goto next;
>>>>>>> +				}
>>>>>>> +
>>>>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>>>>
>>>>> test_hmm needs adjustment because of the way the backup folios are setup.
>>>> nouveau should check the folio order after the possible split happens.
>>>>
>>> You mean the folio_split callback?
>> no, nouveau_dmem_migrate_to_ram():
>> ..
>>         sfolio = page_folio(vmf->page);
>>         order = folio_order(sfolio);
>> ...
>>         migrate_vma_setup()
>> ..
>> if sfolio is split order still reflects the pre-split order
>>
> Will fix, good catch!
>
>>>>>>> +				/*
>>>>>>> +				 * After the split, get back the extra reference
>>>>>>> +				 * on the fault_page, this reference is checked during
>>>>>>> +				 * folio_migrate_mapping()
>>>>>>> +				 */
>>>>>>> +				if (migrate->fault_page) {
>>>>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>>>>> +					folio_get(new_fault_folio);
>>>>>>> +				}
>>>>>>> +
>>>>>>> +				new_folio = page_folio(page);
>>>>>>> +				pfn = page_to_pfn(page);
>>>>>>> +
>>>>>>> +				/*
>>>>>>> +				 * Ensure the lock is held on the correct
>>>>>>> +				 * folio after the split
>>>>>>> +				 */
>>>>>>> +				if (folio != new_folio) {
>>>>>>> +					folio_unlock(folio);
>>>>>>> +					folio_lock(new_folio);
>>>>>>> +				}
>>>>>> Maybe careful not to unlock fault_page ?
>>>>>>
>>>>> split_page will unlock everything but the original folio, the code takes the lock
>>>>> on the folio corresponding to the new folio
>>>> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
>>>>
>>> Not sure I follow what you're trying to elaborate on here
>> do_swap_page:
>> ..
>>         if (trylock_page(vmf->page)) {
>>                 ret = pgmap->ops->migrate_to_ram(vmf);
>>                                <- vmf->page should be locked here even after split
>>                 unlock_page(vmf->page);
>>
> Yep, the split will unlock all tail folios, leaving the just head folio locked
> and this the change, the lock we need to hold is the folio lock associated with
> fault_page, pte entry and not unlock when the cause is a fault. The code seems
> to do the right thing there, let me double check

Yes the fault case is ok. But if migrate not for a fault, we should not leave any page locked

>
> Balbir
> and the code does the right thing there.
>
--Mika


