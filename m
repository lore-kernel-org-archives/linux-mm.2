Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB927C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 04:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BABC6B0093; Tue,  5 Aug 2025 00:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BB36B0095; Tue,  5 Aug 2025 00:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532F66B0096; Tue,  5 Aug 2025 00:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE216B0093
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 00:24:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A86BDC0D6E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:24:47 +0000 (UTC)
X-FDA: 83741413014.13.11B0FC6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1ACC880009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:24:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=doRtWLst;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754367885; a=rsa-sha256;
	cv=none;
	b=mL874TDjbr4Om1Bcvz+ZVaJGp95hM/wACGYmfEBBavf6Y+pfjam3mkJC3EZLbz2n+6ZwmO
	GExTHT9n3xzVoRYEsdrMy99XVetWCh6+2CmVATRCnpy8HPIN9wqxCkT1rconkHL8qCh7tl
	tyQ9E+m5iA/a5PNzFNIgwYRxsXDoZxA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=doRtWLst;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754367885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMAMOBOEqJtPphtd0X+hPY/9bdMZAOIxqSHXSbKc4X4=;
	b=nIWM1XiUngZU7Al+yshyHmLQEABYRIk+VvAnX2vg3yJ86RnjoxwY8Lkf8ltihgpS+MlXcw
	OvnhXrtBmlLVw/FGm7tGg0QKD7qzAh1W7875SxFbMS8k6MV2oXicTvla2MBif8XTBEmFgJ
	Czzh12cvkKTdQrkutqRje6b22zVtFUs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754367884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMAMOBOEqJtPphtd0X+hPY/9bdMZAOIxqSHXSbKc4X4=;
	b=doRtWLstz9JnxD7j8EaYS+7RxBJTgqfr5gXLoDc62U6eeNY6RXBlJX+NvZW02mgR4o8yfd
	YxsYjBqcshoqjq580UD/L1uh3dBPED7cJL9jscPDfh/LdmW3sKikXlDaadnv9vdJGWJFf6
	gQ1HV0uCdY7viH7HkKf29gsUl8te3us=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-r3IzrSE7OmWdSS8SpkXoDA-1; Tue, 05 Aug 2025 00:24:42 -0400
X-MC-Unique: r3IzrSE7OmWdSS8SpkXoDA-1
X-Mimecast-MFC-AGG-ID: r3IzrSE7OmWdSS8SpkXoDA_1754367881
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-33234172d73so25849221fa.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 21:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754367880; x=1754972680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YMAMOBOEqJtPphtd0X+hPY/9bdMZAOIxqSHXSbKc4X4=;
        b=TIcgcuMa0jZOS81vTdIg6CJ0BIUo9nAStVVVTE6x6IauZPYQ5VsH++6PNKnC1qC2up
         AVLy42/G6MpgfOlwHbUJjIv5aFyxoTEtAcoSrviFvB1eJGFZ37QK9yZwHp5fIjnrb86p
         8Bw8pSSe2eT4P3a7qk1Zby/zeFSq0x8PQBJcrPGNvUYpHIKe2MF/lT2GAvswMsMmH/6S
         eiGz2ekPeMHCDs4WRLh54s4UvMrZFIx/XviXiIbWeQmP27RyxoM5cRBwk4WYaHXTUUG6
         H5viAJrG3s+MShGKHpxl6Zivax0mnyQBoHy/L1u67/vxBp4jG+A+7+2T+kzHAyI9PA+e
         tzBg==
X-Forwarded-Encrypted: i=1; AJvYcCX8kLKjTX9zw+IELjSnVXT5+YnGiZcvxvNhwOmFhoQ60/dcaZuTiVpS9e/pAUGw/kM9s/cc/mh5vw==@kvack.org
X-Gm-Message-State: AOJu0YwDGvvSSb80rWrf4WopGvp9tBijnqBp7Ut9sUl3WFJXKuc94HXA
	jxuVDAyEdDpeWKdzUFukcs64O0ruw83nMJyLJoTFrUoWsf5LTkH1+0fgFUfm578b7GZautytj3F
	ioGXSNXQqKmWZctCJeQi/FrFPbUmn+OP0LLBN2dzh8QazlHkrRLI=
X-Gm-Gg: ASbGncuGEYqp/zK3kzoHtwxroKU7eE7+CpfQjVxjw/c4G6IJBa18NEyQ6MdtgvTqEDi
	v0D9beI9eqB3MgDI72OP4gxsXdcwR9sqwumFVDQKvZfCtru6MjUG9w89nQkn7ZsC7Kw2AORe9LK
	SLhhAHMjk7HGqC+4Naa/tfvqLbUgxtK1+SDquDDma6EOb/tLhu88ORBvDhkEZvrqCEzsq0DAQ71
	r+6nTGo1nff1gBNWsGmvpVP0kXu9pzwFTcvm1st+Wshoaaw7fWZgKmabNVGpDvoWAMk5b6Sgyj0
	0Dc/FfGufg2qSgB7qdckh3TlOD1EyYKhXyG3XND902vCjBycm0gYcVZoncqHlYfkZg==
X-Received: by 2002:a05:6512:2210:b0:55b:8827:b7c4 with SMTP id 2adb3069b0e04-55b97b933fbmr2790467e87.40.1754367880267;
        Mon, 04 Aug 2025 21:24:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEL02ize8GRHM9rNlRgyTroZ9wz58VzZXq9iQJXfnMFISrcR6FCo97dbuVFAOEC8WDkwTThqg==
X-Received: by 2002:a05:6512:2210:b0:55b:8827:b7c4 with SMTP id 2adb3069b0e04-55b97b933fbmr2790447e87.40.1754367879738;
        Mon, 04 Aug 2025 21:24:39 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88ca296csm1832935e87.119.2025.08.04.21.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 21:24:39 -0700 (PDT)
Message-ID: <087e40e6-3b3f-4a02-8270-7e6cfdb56a04@redhat.com>
Date: Tue, 5 Aug 2025 07:24:38 +0300
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
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <ede98867-bc17-4894-a375-d17d8f83dd55@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FNYSC2xoJZv7vBN1nCNbYirQjQocZKBZv45JtIk8S_g_1754367881
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1ACC880009
X-Stat-Signature: rtcihdr779gzupwd8tteeh7bqa4szc84
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754367884-86324
X-HE-Meta: U2FsdGVkX1+UNQ42YUurNa8SXrKQm734M6u6elpUQNM5KxERlz8R+FEnbKiubiwXCjzWDsRb9PfARCO5d8JyxUbK5+pOzv91JFzrzPsEEm5NGQWDQ6kfGjw7lTQwpxEILWrvrPfvH13msiqHTRBAYM245T5TniJCSGLzvQ67lmIyihMzt74NO+tEYrd9IK/1XeB/Uu21aytlkd2RLsPj7jekGvzmGTk8kTqHKBKU4ouGZmgrC7VNEKfgPlxDctO2q3OaTeTtf3X5T1myEdDuVOViiLfVhtDAYndOCvm5qPF1OCLxRcemlIBm2c2Hw5RaetAA6fbbky6VoOp4ew7t/GdqUNbHjGY5xkO7+RlAe3RDMxXhvJWlqkqwJazoF18Ij7nNw3KNxpB3REXKm5LZISS2nAcW9fc7OsQk0iZzQ+gE3hWhxIgecXD5LIWMmU1Vj6SEoOdKUuGjGesdHHoygdm/3UiTcjiVIMSMOzCWe0qKdAdS+47OFSC8V4tcNbzHo0zlOi2Wknni7AByU7mvkyG6P0xy0J/hL4qA//LOVi1TwrCqMwAfl541zKm4KG+U6jnJxlmWNYZS+3k7rKSa+jfwAN2LlFB3co/SpvwKS8Hbn1mmEaDBJb5ATYgqhBnNuhtjJktmKJazydiWb9lwdiKw5OD2elyxrLtChTrYDwq1fmn3qOD10/YKas9ZrBb1X7VDUPCbnP9SDGPH/MsaEgEL3R3fdXKsqxK8tgaiC2Appyrt07gPCBDx+TMLj4/MzbMtd8fdwA/CiTfj6uCNCP9Mp7fky27gYlxRZFhlgScg/3WpWPXhWqZyH3EpBdGwhOskZEu92f5k03X2SuqXcwlMJD8aSTt0D39HScnV1F53oJN6n2XOkHwEFXtz4uXxnIBEIEi5hpL1VPowCXMww8rl9e7fvoeJDgqkKKW1Yo2ra+HoPuiaPQWghwgOgxMZCYOy0MUsfBY0vmLEXca
 GnrUkrs4
 rAoH1YqQUfo4rZIV1rCJOJpTJdfExbEkL32qpuKioQP2ivhmNWD1pUNxcB4OAMxyitgbpkHgo2wB6AG4WTn9FVdRdQmHOsqoRCgdwEHJ3v2ZJiFUoFfz2LsrQfHMD8zkzSsbg4OtBovOEViwKDU5NPGQC0nkDZHLgE3ikBLsqsqbXRyNnDcWK+YZydYzJNxV94REEL8++Azo5zqd+zz1z4f+TAnm4HspVrRcA8oxj9cRqlc5flckPlJ2U5tjW6Oj8stoKKz5b0IFaR4Y58BEU1ofpr5oBne+CH4/N0TZWgIILRj/sCTsKpC54Gm+J/utFQRl3YLZVlat3enp5ONLDK4KL/6gAISM9b2OyN71roHADanLdsKtB/ZQ0Bdn0JJ6rodRj3OHblQDypgyjml7yX56jL2RRCaORZjrKKCzVasLfwrVMllCi4nxlqmvnEEIt3zdDTWFcH2Yqubnn2gHiH7NtoyCg94zebgwd/dmB8t+bR5OYvAEFyg1t0HrBGzc4xHUBKHN+X+ij4ewZtdkp85cSv2AwMNA6LX/P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/5/25 07:10, Balbir Singh wrote:
> On 8/5/25 09:26, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/5/25 01:46, Balbir Singh wrote:
>>> On 8/2/25 22:13, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>>> FYI:
>>>>>
>>>>> I have the following patch on top of my series that seems to make it work
>>>>> without requiring the helper to split device private folios
>>>>>
>>>> I think this looks much better!
>>>>
>>> Thanks!
>>>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> ---
>>>>>  include/linux/huge_mm.h |  1 -
>>>>>  lib/test_hmm.c          | 11 +++++-
>>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>>> --- a/include/linux/huge_mm.h
>>>>> +++ b/include/linux/huge_mm.h
>>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>>  		vm_flags_t vm_flags);
>>>>>  
>>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>> -int split_device_private_folio(struct folio *folio);
>>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>  		unsigned int new_order, bool unmapped);
>>>>>  int min_order_for_split(struct folio *folio);
>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>> index 341ae2af44ec..444477785882 100644
>>>>> --- a/lib/test_hmm.c
>>>>> +++ b/lib/test_hmm.c
>>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>>  	 */
>>>>> -	rpage = vmf->page->zone_device_data;
>>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>>  	dmirror = rpage->zone_device_data;
>>>>>  
>>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>>  	order = folio_order(page_folio(vmf->page));
>>>>>  	nr = 1 << order;
>>>>>  
>>>>> +	/*
>>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>>> +	 */
>>>>> +	if (vmf->pte) {
>>>>> +		order = 0;
>>>>> +		nr = 1;
>>>>> +	}
>>>>> +
>>>>>  	/*
>>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>>  	 * large number of cpus that might not scale well.
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>>  					  struct shrink_control *sc);
>>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>  					 struct shrink_control *sc);
>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>> -		struct page *split_at, struct xa_state *xas,
>>>>> -		struct address_space *mapping, bool uniform_split);
>>>>> -
>>>>>  static bool split_underused_thp = true;
>>>>>  
>>>>>  static atomic_t huge_zero_refcount;
>>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>>  }
>>>>>  
>>>>> -/**
>>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>>> - * split folios for pages that are partially mapped
>>>>> - *
>>>>> - * @folio: the folio to split
>>>>> - *
>>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>>> - */
>>>>> -int split_device_private_folio(struct folio *folio)
>>>>> -{
>>>>> -	struct folio *end_folio = folio_next(folio);
>>>>> -	struct folio *new_folio;
>>>>> -	int ret = 0;
>>>>> -
>>>>> -	/*
>>>>> -	 * Split the folio now. In the case of device
>>>>> -	 * private pages, this path is executed when
>>>>> -	 * the pmd is split and since freeze is not true
>>>>> -	 * it is likely the folio will be deferred_split.
>>>>> -	 *
>>>>> -	 * With device private pages, deferred splits of
>>>>> -	 * folios should be handled here to prevent partial
>>>>> -	 * unmaps from causing issues later on in migration
>>>>> -	 * and fault handling flows.
>>>>> -	 */
>>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>> -	VM_WARN_ON(ret);
>>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>>> -					new_folio = folio_next(new_folio)) {
>>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>>> -								new_folio));
>>>>> -	}
>>>>> -
>>>>> -	/*
>>>>> -	 * Mark the end of the folio split for device private THP
>>>>> -	 * split
>>>>> -	 */
>>>>> -	zone_device_private_split_cb(folio, NULL);
>>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>>> -	return ret;
>>>>> -}
>>>>> -
>>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>  		unsigned long haddr, bool freeze)
>>>>>  {
>>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>  				freeze = false;
>>>>>  			if (!freeze) {
>>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>>> -				unsigned long addr = haddr;
>>>>> -				struct folio *new_folio;
>>>>> -				struct folio *end_folio = folio_next(folio);
>>>>>  
>>>>>  				if (anon_exclusive)
>>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>  
>>>>> -				folio_lock(folio);
>>>>> -				folio_get(folio);
>>>>> -
>>>>> -				split_device_private_folio(folio);
>>>>> -
>>>>> -				for (new_folio = folio_next(folio);
>>>>> -					new_folio != end_folio;
>>>>> -					new_folio = folio_next(new_folio)) {
>>>>> -					addr += PAGE_SIZE;
>>>>> -					folio_unlock(new_folio);
>>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>>> -						&new_folio->page, 1,
>>>>> -						vma, addr, rmap_flags);
>>>>> -				}
>>>>> -				folio_unlock(folio);
>>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>>> -						1, vma, haddr, rmap_flags);
>>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>> +				if (anon_exclusive)
>>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>> +						 vma, haddr, rmap_flags);
>>>>>  			}
>>>>>  		}
>>>>>  
>>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>  	if (nr_shmem_dropped)
>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>  
>>>>> -	if (!ret && is_anon)
>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>>  
>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>> index 49962ea19109..4264c0290d08 100644
>>>>> --- a/mm/migrate_device.c
>>>>> +++ b/mm/migrate_device.c
>>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>  			 * page table entry. Other special swap entries are not
>>>>>  			 * migratable, and we ignore regular swapped page.
>>>>>  			 */
>>>>> +			struct folio *folio;
>>>>> +
>>>>>  			entry = pte_to_swp_entry(pte);
>>>>>  			if (!is_device_private_entry(entry))
>>>>>  				goto next;
>>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>>  				goto next;
>>>>>  
>>>>> +			folio = page_folio(page);
>>>>> +			if (folio_test_large(folio)) {
>>>>> +				struct folio *new_folio;
>>>>> +				struct folio *new_fault_folio;
>>>>> +
>>>>> +				/*
>>>>> +				 * The reason for finding pmd present with a
>>>>> +				 * device private pte and a large folio for the
>>>>> +				 * pte is partial unmaps. Split the folio now
>>>>> +				 * for the migration to be handled correctly
>>>>> +				 */
>>>>> +				pte_unmap_unlock(ptep, ptl);
>>>>> +
>>>>> +				folio_get(folio);
>>>>> +				if (folio != fault_folio)
>>>>> +					folio_lock(folio);
>>>>> +				if (split_folio(folio)) {
>>>>> +					if (folio != fault_folio)
>>>>> +						folio_unlock(folio);
>>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>> +					goto next;
>>>>> +				}
>>>>> +
>>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>>
>>> test_hmm needs adjustment because of the way the backup folios are setup.
>> nouveau should check the folio order after the possible split happens.
>>
> You mean the folio_split callback?

no, nouveau_dmem_migrate_to_ram():
..
        sfolio = page_folio(vmf->page);
        order = folio_order(sfolio);
...
        migrate_vma_setup()
..
if sfolio is split order still reflects the pre-split order

>
>>>>> +				/*
>>>>> +				 * After the split, get back the extra reference
>>>>> +				 * on the fault_page, this reference is checked during
>>>>> +				 * folio_migrate_mapping()
>>>>> +				 */
>>>>> +				if (migrate->fault_page) {
>>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>>> +					folio_get(new_fault_folio);
>>>>> +				}
>>>>> +
>>>>> +				new_folio = page_folio(page);
>>>>> +				pfn = page_to_pfn(page);
>>>>> +
>>>>> +				/*
>>>>> +				 * Ensure the lock is held on the correct
>>>>> +				 * folio after the split
>>>>> +				 */
>>>>> +				if (folio != new_folio) {
>>>>> +					folio_unlock(folio);
>>>>> +					folio_lock(new_folio);
>>>>> +				}
>>>> Maybe careful not to unlock fault_page ?
>>>>
>>> split_page will unlock everything but the original folio, the code takes the lock
>>> on the folio corresponding to the new folio
>> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
>>
> Not sure I follow what you're trying to elaborate on here

do_swap_page:
..
        if (trylock_page(vmf->page)) {
                ret = pgmap->ops->migrate_to_ram(vmf);
                               <- vmf->page should be locked here even after split
                unlock_page(vmf->page);

> Balbir
>
--Mika


