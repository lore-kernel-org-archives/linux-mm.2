Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FF7C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8B26B008C; Tue,  5 Aug 2025 06:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8D06B0096; Tue,  5 Aug 2025 06:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671056B009A; Tue,  5 Aug 2025 06:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 502C86B008C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:47:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8D5EB6258
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:47:04 +0000 (UTC)
X-FDA: 83742376368.07.98DE8A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F4CB40007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:47:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B6owrVtq;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754390822; a=rsa-sha256;
	cv=none;
	b=TxUgp6FHUsJekZ5UFdK0IV/dnQFXTkM7+3FWOb6RKvl9TceyVDbT8IHgx7703tXiwG79cK
	3tf+UzDW3MczWtMXaserL313q0CZDewNeax4N0fT+eWXUu+Lbpl4YZuQnW+hTh1OhkVw81
	iGEFNjbFXxDsDko/guosON5urIE3sps=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B6owrVtq;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wk5GXKT9wz3dvDgQdeYLI9qgkV6XRvZlyWZQe8HtFwg=;
	b=V820rxBzY/eN4wJqdcR3ItxTXozxc1uCvLQZhSTmvhdewJcoHFxfTCCsr3rlNjkQWv5KV9
	Jk+s78A3rydCVFaeu6Cd3SVB7lbGA2p9RS3FjrV+TzHOMIou5CYssjidqURjd+99UmSbVu
	8cHFsP2gXTyXmBEbQQRv6MIL4V9tMyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754390821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wk5GXKT9wz3dvDgQdeYLI9qgkV6XRvZlyWZQe8HtFwg=;
	b=B6owrVtqy2EuIlHvVEP4u07LMVtWkeoZDYO8jXOIj5pp1qvxWzpQNqawVB+YrYETjJXMOW
	MOiuPRpO0CgAUIeEF01pCqKhELluLZLRmLWf2x46rCLkykeOxvpDj1RYj+4OLZzt9noYtI
	OhSkOMU+BQ00/KDUw9bosFUbokTNVAk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-AfAjaOcDNIC-KcrJE1hbIg-1; Tue, 05 Aug 2025 06:47:00 -0400
X-MC-Unique: AfAjaOcDNIC-KcrJE1hbIg-1
X-Mimecast-MFC-AGG-ID: AfAjaOcDNIC-KcrJE1hbIg_1754390819
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55b87768966so2438504e87.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390817; x=1754995617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wk5GXKT9wz3dvDgQdeYLI9qgkV6XRvZlyWZQe8HtFwg=;
        b=k3YlZj9K1ZkyrJ50nT078VrLuz5q7avanve24/iLfE6n2RLfs36dGcdVFfGV3J1U2k
         arWQluOa3QZVFlaYcM+NR/3f/Q0NAd1pORJO+epHZvn07e/ImMYmZvxflWoasEM5TnXz
         PLKm3r2i5bQQeuvd2ZxXnNJT4t4atwFnYpzmJ24x1HXaNnqBuZtFRf2lWxVwUXTtLSiP
         UVB7dqE/A27Yq0Fi8g1cNqJOKxX5UTgpeOxqG485ReIUKMiqVlI4fYrJIV63sr7QK5Uu
         hIIrUEeihkxf8KmhhW4kyotKeh74NJFGigDxviVqAJmglgYe6tT1WToYW+1lMRJYuLhC
         kugA==
X-Forwarded-Encrypted: i=1; AJvYcCWma0uJUjtk1/PY1C4/Xe3+aumooNqD2NtaS7goreyqEVS9BuLPmuY0TrbssUaYCynRBZQi+2lRcA==@kvack.org
X-Gm-Message-State: AOJu0YwNX0Mo/+NWb26VIXYR6oXcTF899mhV7kXcIbvKgGcC0s1Dm7qR
	2hn3afCvz7GysWiug9Ad3nyJx+yLS85NZJQ2/JKGTObBoV2kxOYe7C+chGDB07+hjJfFd7P5VF3
	Gra3BarAr8RONU1xEbyEMoD9+i7tW2Av0Tk1r2mgWwOwyMvzsYkdvMloVUnF5Yw==
X-Gm-Gg: ASbGncsrqvaex3CJuAnvta2IuGd+Ny0sUb6wXjkrZG06vv7s8lXy/VowluoR61Ow7ZD
	daqFvxG2YWtr2LBbBtPgo7y3yD/KkQ99udruMkducqnDagh6Nu6vJYCz2yByPBHh55pez5HPXdt
	WLD/fUWRw0hnW6VB530JS3VPtf91svJju7agndfMEumK3j52CfL+LtEaP7xjBuz2Yx/00g4gg7d
	J5Km2E/tGJr+hoa9CI8v+rYzA6JtV2N/rKYPv0T8Fk0pE9Tx6SV3k61fi/XCwT26FRaXTKTMtHv
	Cu5hO+XTeQeh5srNt1tKFZYJJF2sJZFjaFIXaaLi2eHK094E5c9mvU7H9Ebc0maDCQ==
X-Received: by 2002:a05:6512:3b07:b0:55b:958f:8c2f with SMTP id 2adb3069b0e04-55b97b9f381mr4069026e87.49.1754390816974;
        Tue, 05 Aug 2025 03:46:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd9Bp5Ekm55BL1kqJkB8HhmkPyDmXgdV3CuPhFjBM5LjSOKm7EIc8UH12gC8OvPnbsri0MZA==
X-Received: by 2002:a05:6512:3b07:b0:55b:958f:8c2f with SMTP id 2adb3069b0e04-55b97b9f381mr4068990e87.49.1754390816427;
        Tue, 05 Aug 2025 03:46:56 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c99041sm1928200e87.81.2025.08.05.03.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:46:55 -0700 (PDT)
Message-ID: <b6ac5739-03a4-4abf-b492-b009ad523474@redhat.com>
Date: Tue, 5 Aug 2025 13:46:55 +0300
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
 <6a08fa8f-bc39-4389-aa52-d95f82538a91@redhat.com>
 <6442f975-6363-4969-a0bf-55d06eec9528@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <6442f975-6363-4969-a0bf-55d06eec9528@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8UHuqVFgjP1Ai-nN3kGxAoEuiyXTJI8eQEpxRyKhz8M_1754390819
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F4CB40007
X-Stat-Signature: 6s5q7j8h6zpkad31neahs5jaqbd3qexr
X-HE-Tag: 1754390821-249235
X-HE-Meta: U2FsdGVkX195rWtXUQoZuZQDX6dQTnQBj9lMBl4W2EcpORXR/mqm0TrBQ2SZHox6hJMwX37KXuPsaV5qqEsvVB9XhhykRZOoQqhyetKQfUqM6b5uFhuVT1Z12MdVKw/x2JIwlh5PpYpHrXCHQu3cXtePxmj1chdvD7k1oPDLKFAKk/igv2qjOnkXnsvzzUHPNQwTdP7STwILwn4ubxsU9sQuuJx3iiyBVywjP6pOWW/jaUiY4e1p66/xxO/tqvJpdfNn4bDAijib2w2zZiabRZXk0vOxB1gQaHTiHDC6p4MelZYwA97EYSyW4eVaMifsEbwG5Kus4rFyQpTUGjdUwnwkEIMz7y8CmSlkGHKXxGTzl6/uag8nrLFhf+jg1pMImR0pH0vYGyQwKWR8d6rTwB7DUr8rY5DezpTkGGhmiJIbu4zzp5DQUK4pauPkQtPUI184QWwAoVFBEqCgciHwyU72C28b8pYSBxNEBYApN0Ec0gg6ABHCZ68q61Qnf/bqJy6BLnCF1XnXYoTdWh9GN6QEDr2rAqfnOWyjRqNigsAA1we6dp9Kh0l5RFdyDXEh74qJ+uuo8QMdCEk5OEIUYToTofFc3j+0YToVuzDqeD+kaqB5msZpoD2z7PF8dONQrr/HHRrQJPd4jkPnbztrCd7MNO2SLmO4mm7ITgIpxjzJvPQjB/WYMSSY9stEh7SFxsHLMfIFx+8ZdSwXukQT+KHHvyLZFUYt5GpCLdfRiEPozJpH5mBHnyje99Oe0iuxrJhykMchRI1VL32EQihbZp8+QLaQvA7iHdK6Yg7WeFTHI462IiGmJbUHeRCamAywnWCZ+boM3HKtBq03hIwoxf2/TJ5OH+KsmPmPyt6GqhJuT7atcnN73TBUpYHdWvOcaMYJzzUdrOy0zRJHiZOLW50JJNrqlcyEbxI0O09fkDmnN03Ei9P1fwmOOsMjIVTfWdBQlJDke1anoq8iuJB
 brT37M1t
 mzKxIUxgSsbO6sZHN9lUJfROu4SuHS6gkwiHCKGcUwRfUjWHJBhyWd0ECmzaFOSgDuKF0WBrsRe6JmVy1y2ry8C9hq4XcfqEVvNWCzlPm7I7kPh17EnuS7DbvkHTv6k8QANdwsHY0gl3Q0XCvdtvlFUQsmjfg6peQyXvun/PWNnplrrb/c+3HZ+8jSpvbnf1gQqhDmLof8saNPICTS1cvjpkb9e6bPoXMfL6m/WCfXCJu8ToLUOeI44WrokyPuz/cj9kOUr9UQwRFnRhye3V+IuGD9RUAiv4D1A0oceWrJez1JXCIe9Ps17VE/fC/GU1WWiNIA5XKWdW2jmcZMSm6fZNH5N5pP/61gSfjiWqA3EqrpdfNOa9uMLwR05kVt/QIDRhLg9cv38CtxSoMcep35YLNcZAgf8Rbagatx2oETfuQMav8S+pLrpAdpZshu0Im6gHG0IpS9Bg+ILjxLgJXaVTHvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/5/25 13:36, Balbir Singh wrote:
> On 8/5/25 20:35, Mika Penttilä wrote:
>> On 8/5/25 13:27, Balbir Singh wrote:
>>
>>> On 8/5/25 14:24, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>> On 8/5/25 07:10, Balbir Singh wrote:
>>>>> On 8/5/25 09:26, Mika Penttilä wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 8/5/25 01:46, Balbir Singh wrote:
>>>>>>> On 8/2/25 22:13, Mika Penttilä wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>>>>>>> FYI:
>>>>>>>>>
>>>>>>>>> I have the following patch on top of my series that seems to make it work
>>>>>>>>> without requiring the helper to split device private folios
>>>>>>>>>
>>>>>>>> I think this looks much better!
>>>>>>>>
>>>>>>> Thanks!
>>>>>>>
>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>> ---
>>>>>>>>>  include/linux/huge_mm.h |  1 -
>>>>>>>>>  lib/test_hmm.c          | 11 +++++-
>>>>>>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>>>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>>>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>>>>>>  		vm_flags_t vm_flags);
>>>>>>>>>  
>>>>>>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>>>>> -int split_device_private_folio(struct folio *folio);
>>>>>>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>>>  		unsigned int new_order, bool unmapped);
>>>>>>>>>  int min_order_for_split(struct folio *folio);
>>>>>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>>>>>> index 341ae2af44ec..444477785882 100644
>>>>>>>>> --- a/lib/test_hmm.c
>>>>>>>>> +++ b/lib/test_hmm.c
>>>>>>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>>>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>>>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>>>>>>  	 */
>>>>>>>>> -	rpage = vmf->page->zone_device_data;
>>>>>>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>>>>>>  	dmirror = rpage->zone_device_data;
>>>>>>>>>  
>>>>>>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>>>>>>  	order = folio_order(page_folio(vmf->page));
>>>>>>>>>  	nr = 1 << order;
>>>>>>>>>  
>>>>>>>>> +	/*
>>>>>>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>>>>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>>>>>>> +	 */
>>>>>>>>> +	if (vmf->pte) {
>>>>>>>>> +		order = 0;
>>>>>>>>> +		nr = 1;
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>>  	/*
>>>>>>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>>>>>>  	 * large number of cpus that might not scale well.
>>>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>>>>>>> --- a/mm/huge_memory.c
>>>>>>>>> +++ b/mm/huge_memory.c
>>>>>>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>>>>>>  					  struct shrink_control *sc);
>>>>>>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>>>>>  					 struct shrink_control *sc);
>>>>>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>>>>> -		struct page *split_at, struct xa_state *xas,
>>>>>>>>> -		struct address_space *mapping, bool uniform_split);
>>>>>>>>> -
>>>>>>>>>  static bool split_underused_thp = true;
>>>>>>>>>  
>>>>>>>>>  static atomic_t huge_zero_refcount;
>>>>>>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>>>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>>>>>>  }
>>>>>>>>>  
>>>>>>>>> -/**
>>>>>>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>> - * split folios for pages that are partially mapped
>>>>>>>>> - *
>>>>>>>>> - * @folio: the folio to split
>>>>>>>>> - *
>>>>>>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>> - */
>>>>>>>>> -int split_device_private_folio(struct folio *folio)
>>>>>>>>> -{
>>>>>>>>> -	struct folio *end_folio = folio_next(folio);
>>>>>>>>> -	struct folio *new_folio;
>>>>>>>>> -	int ret = 0;
>>>>>>>>> -
>>>>>>>>> -	/*
>>>>>>>>> -	 * Split the folio now. In the case of device
>>>>>>>>> -	 * private pages, this path is executed when
>>>>>>>>> -	 * the pmd is split and since freeze is not true
>>>>>>>>> -	 * it is likely the folio will be deferred_split.
>>>>>>>>> -	 *
>>>>>>>>> -	 * With device private pages, deferred splits of
>>>>>>>>> -	 * folios should be handled here to prevent partial
>>>>>>>>> -	 * unmaps from causing issues later on in migration
>>>>>>>>> -	 * and fault handling flows.
>>>>>>>>> -	 */
>>>>>>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>>>>> -	VM_WARN_ON(ret);
>>>>>>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>>>>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>>>>>>> -								new_folio));
>>>>>>>>> -	}
>>>>>>>>> -
>>>>>>>>> -	/*
>>>>>>>>> -	 * Mark the end of the folio split for device private THP
>>>>>>>>> -	 * split
>>>>>>>>> -	 */
>>>>>>>>> -	zone_device_private_split_cb(folio, NULL);
>>>>>>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>> -	return ret;
>>>>>>>>> -}
>>>>>>>>> -
>>>>>>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>>>  		unsigned long haddr, bool freeze)
>>>>>>>>>  {
>>>>>>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>>>  				freeze = false;
>>>>>>>>>  			if (!freeze) {
>>>>>>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>>>>>>> -				unsigned long addr = haddr;
>>>>>>>>> -				struct folio *new_folio;
>>>>>>>>> -				struct folio *end_folio = folio_next(folio);
>>>>>>>>>  
>>>>>>>>>  				if (anon_exclusive)
>>>>>>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>>>>  
>>>>>>>>> -				folio_lock(folio);
>>>>>>>>> -				folio_get(folio);
>>>>>>>>> -
>>>>>>>>> -				split_device_private_folio(folio);
>>>>>>>>> -
>>>>>>>>> -				for (new_folio = folio_next(folio);
>>>>>>>>> -					new_folio != end_folio;
>>>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>>>> -					addr += PAGE_SIZE;
>>>>>>>>> -					folio_unlock(new_folio);
>>>>>>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>>>>>>> -						&new_folio->page, 1,
>>>>>>>>> -						vma, addr, rmap_flags);
>>>>>>>>> -				}
>>>>>>>>> -				folio_unlock(folio);
>>>>>>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>>>>>>> -						1, vma, haddr, rmap_flags);
>>>>>>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>>>>>> +				if (anon_exclusive)
>>>>>>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>>>>>> +						 vma, haddr, rmap_flags);
>>>>>>>>>  			}
>>>>>>>>>  		}
>>>>>>>>>  
>>>>>>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>>>  	if (nr_shmem_dropped)
>>>>>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>>>>>  
>>>>>>>>> -	if (!ret && is_anon)
>>>>>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>>>>>>  
>>>>>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>>> index 49962ea19109..4264c0290d08 100644
>>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>>>  			 * page table entry. Other special swap entries are not
>>>>>>>>>  			 * migratable, and we ignore regular swapped page.
>>>>>>>>>  			 */
>>>>>>>>> +			struct folio *folio;
>>>>>>>>> +
>>>>>>>>>  			entry = pte_to_swp_entry(pte);
>>>>>>>>>  			if (!is_device_private_entry(entry))
>>>>>>>>>  				goto next;
>>>>>>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>>>>>>  				goto next;
>>>>>>>>>  
>>>>>>>>> +			folio = page_folio(page);
>>>>>>>>> +			if (folio_test_large(folio)) {
>>>>>>>>> +				struct folio *new_folio;
>>>>>>>>> +				struct folio *new_fault_folio;
>>>>>>>>> +
>>>>>>>>> +				/*
>>>>>>>>> +				 * The reason for finding pmd present with a
>>>>>>>>> +				 * device private pte and a large folio for the
>>>>>>>>> +				 * pte is partial unmaps. Split the folio now
>>>>>>>>> +				 * for the migration to be handled correctly
>>>>>>>>> +				 */
>>>>>>>>> +				pte_unmap_unlock(ptep, ptl);
>>>>>>>>> +
>>>>>>>>> +				folio_get(folio);
>>>>>>>>> +				if (folio != fault_folio)
>>>>>>>>> +					folio_lock(folio);
>>>>>>>>> +				if (split_folio(folio)) {
>>>>>>>>> +					if (folio != fault_folio)
>>>>>>>>> +						folio_unlock(folio);
>>>>>>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>>>>>> +					goto next;
>>>>>>>>> +				}
>>>>>>>>> +
>>>>>>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>>>>>>
>>>>>>> test_hmm needs adjustment because of the way the backup folios are setup.
>>>>>> nouveau should check the folio order after the possible split happens.
>>>>>>
>>>>> You mean the folio_split callback?
>>>> no, nouveau_dmem_migrate_to_ram():
>>>> ..
>>>>         sfolio = page_folio(vmf->page);
>>>>         order = folio_order(sfolio);
>>>> ...
>>>>         migrate_vma_setup()
>>>> ..
>>>> if sfolio is split order still reflects the pre-split order
>>>>
>>> Will fix, good catch!
>>>
>>>>>>>>> +				/*
>>>>>>>>> +				 * After the split, get back the extra reference
>>>>>>>>> +				 * on the fault_page, this reference is checked during
>>>>>>>>> +				 * folio_migrate_mapping()
>>>>>>>>> +				 */
>>>>>>>>> +				if (migrate->fault_page) {
>>>>>>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>>>>>>> +					folio_get(new_fault_folio);
>>>>>>>>> +				}
>>>>>>>>> +
>>>>>>>>> +				new_folio = page_folio(page);
>>>>>>>>> +				pfn = page_to_pfn(page);
>>>>>>>>> +
>>>>>>>>> +				/*
>>>>>>>>> +				 * Ensure the lock is held on the correct
>>>>>>>>> +				 * folio after the split
>>>>>>>>> +				 */
>>>>>>>>> +				if (folio != new_folio) {
>>>>>>>>> +					folio_unlock(folio);
>>>>>>>>> +					folio_lock(new_folio);
>>>>>>>>> +				}
>>>>>>>> Maybe careful not to unlock fault_page ?
>>>>>>>>
>>>>>>> split_page will unlock everything but the original folio, the code takes the lock
>>>>>>> on the folio corresponding to the new folio
>>>>>> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
>>>>>>
>>>>> Not sure I follow what you're trying to elaborate on here
>>>> do_swap_page:
>>>> ..
>>>>         if (trylock_page(vmf->page)) {
>>>>                 ret = pgmap->ops->migrate_to_ram(vmf);
>>>>                                <- vmf->page should be locked here even after split
>>>>                 unlock_page(vmf->page);
>>>>
>>> Yep, the split will unlock all tail folios, leaving the just head folio locked
>>> and this the change, the lock we need to hold is the folio lock associated with
>>> fault_page, pte entry and not unlock when the cause is a fault. The code seems
>>> to do the right thing there, let me double check
>> Yes the fault case is ok. But if migrate not for a fault, we should not leave any page locked
>>
> migrate_vma_finalize() handles this

But we are in migrate_vma_collect_pmd() after the split, and try to collect the pte, locking the page again.
So needs to be unlocked after the split.

>
> Balbir
>


