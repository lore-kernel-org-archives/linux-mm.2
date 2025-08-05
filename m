Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8661C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 05:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A266B00A1; Tue,  5 Aug 2025 01:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A3C6B00A2; Tue,  5 Aug 2025 01:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02866B00A3; Tue,  5 Aug 2025 01:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC1346B00A1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:19:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 767EEBC926
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:19:35 +0000 (UTC)
X-FDA: 83741551110.15.33D1228
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 19CF814000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:19:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Och5M2j1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754371173; a=rsa-sha256;
	cv=none;
	b=kYRtsbodATpYbMw3XkD+/zbvr18iobBPk7/Ou2IDDXGHn+2TiwgehCHVYKyJsR3ctgO6I8
	ed5ISpkEou7vEoX52Ntb6M3EEq9reL/LPDQYmfT/ANxFLT9bgfdDLOyUsPzMve6Wszgobv
	Aq9S2MBh90FjWJEJFpq9k1NukTY7cTs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Och5M2j1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754371173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGLPKOHCE4WHIZo2zl9wNosGejx/J5pqoktUTOJ9DEQ=;
	b=DYhjJURRmkKm4fVITcf+rUjT0TbLXNZXwHR6rQMUYtp7AFzgYcrgbKSe73RwK1umVSz9BQ
	D4Cw7yxJEyRiyRAnnS8HDJrR2Jil+gK5GEqAiFwnnx7uul+Goc4HK+YiSDc/hG2rzO/mR9
	4jOIB4f/WbcpNrSVY8KjcwklZThssfE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754371172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LGLPKOHCE4WHIZo2zl9wNosGejx/J5pqoktUTOJ9DEQ=;
	b=Och5M2j1R2WrJNQ02Y++odj7+0myYeoLsta3iheLKWNBLw0wJKdhHmt7MecT1H8JPj8AVn
	AuxOaB42gxGvzt8GuFFCBAeImOHW0hW+QaERb+4z/UBep7IKtI3QVoPugp/Fun3zY/JqOC
	HAKG/2qp460pQh7WBdR1SOttT2ArtRI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-INlOVGzuPc6zC7TFLVRcfw-1; Tue, 05 Aug 2025 01:19:30 -0400
X-MC-Unique: INlOVGzuPc6zC7TFLVRcfw-1
X-Mimecast-MFC-AGG-ID: INlOVGzuPc6zC7TFLVRcfw_1754371169
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55ba635f0ccso430070e87.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 22:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754371169; x=1754975969;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGLPKOHCE4WHIZo2zl9wNosGejx/J5pqoktUTOJ9DEQ=;
        b=pBH2qVayOZpNpWa7m1t8Mn9NxDEA52A6mYBFDC4bxG5k8cI/2zHmyUm9bmutvuqkz6
         YS3Fh1vBf/UpfDvK5EL0pcJNa7jhC7Vb1XhM2EH6lWCCQ+4HCP6aQuwaRrEWlbtNDab+
         zJAh86zt4GreGyvut8tUxY6wr0jS7i5iNDmdKFfxIdarwYAIGerLitaBRqr73IGcivhZ
         lppu3lI91vCyX0NmkC6XQxqvAH9lek/yqKUkctdug6+pXc/aqryLki3O2fP64txCKn/d
         ssbvAjo98QViUKzmi0BZj1ifReyqEi8G35G/a4hZTbLatVDLdqU7UcLbdGE4FXMKrJuX
         0Ijw==
X-Forwarded-Encrypted: i=1; AJvYcCWAjQGpr0ihGKRnSKzzqbJKpYdTgEBl5bNVIpTDasycUV88/en55koEzY0oIJf1OM934ybL75YvRA==@kvack.org
X-Gm-Message-State: AOJu0YzBifq+n5t1Xpucbsh6m+o6uZCUNsUeL3PUH+JrJppBdJf8jXVc
	uU0bX9plEAUF1zkbmLOGFVtxrMJd03Z1aRM9Jy+01XhFlPwKjBIkFAmeHf7hDYgT032JNUUIFG3
	wquqiHowkg2iXe74LzCaLP/M3bcuV5gbPC5sGDj1Q3DmviAwm/8o=
X-Gm-Gg: ASbGncvfhuLS6yfNJBSb5FX04lQo9jCikcuiM0zDtTRaYyj8XeomjFq6E/+P6/d+d8j
	m7U6dzALqRMj66QBToWFeLbBGv5c37scyXNcaFoucFBgtwBaursNBYZZfaxi4u0OGkWe4v+SxoC
	bxToABMJ5Dlvix7bUjhs7/y8icTdUroO25za3iMhC8tb2wircOC64ch0qYvjqRTc8abU3mKOQBN
	Wh4rzre+m8VOl6GkQ2lIz+L2nsjnxmdpPLpzJQ7O399sQORfVbDk6vMcplOw1NK5/OB6p9JOmQV
	dQvG0SkKtu0cD9TjLs0MtD/DiJRqoc60bARczXsZIBW9aCVGC7Szwy+5lNzdFJmtag==
X-Received: by 2002:a05:6512:3991:b0:553:65bc:4232 with SMTP id 2adb3069b0e04-55b97b50600mr3043097e87.31.1754371169050;
        Mon, 04 Aug 2025 22:19:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7ovAchybYJl5BUGKvnbj7PL2Is1KUsQyv2BFYPbPag/hcXmOub4Fc8vBEeILkJIX7hJjvYQ==
X-Received: by 2002:a05:6512:3991:b0:553:65bc:4232 with SMTP id 2adb3069b0e04-55b97b50600mr3043080e87.31.1754371168498;
        Mon, 04 Aug 2025 22:19:28 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8898bdcfsm1813347e87.32.2025.08.04.22.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 22:19:27 -0700 (PDT)
Message-ID: <4fa4f448-ebef-47dd-ba99-6ef6e5862fda@redhat.com>
Date: Tue, 5 Aug 2025 08:19:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
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
 <087e40e6-3b3f-4a02-8270-7e6cfdb56a04@redhat.com>
In-Reply-To: <087e40e6-3b3f-4a02-8270-7e6cfdb56a04@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wcVq0CapwLECAy1XWQ2ukshlNPIHw1nw0wXlo5HLWls_1754371169
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19CF814000C
X-Stat-Signature: xt6orr7ebciho5raogqzhtdfh9qqh7hh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754371172-193136
X-HE-Meta: U2FsdGVkX199d8/2P/bGTesaaZQQ1jpP02fO+nXflWj794zlLuqMMVHu3wUM+w+X+5Z0jYxvT40ExeqiT7XEMtaIyM4ZceI12ET4gXuNoE8/c5sq1xLtp7pB2IiJgl6h2k4kC7UEDVGElrFezsJtL9rNoivT6af1McmQMtXem76SB3gBFRzUQsHyREtT8N+N+Pk+dhojgxVb7xufMnZduk6rBdpw1V1zpwwnwOV5aQE+TvY51DcubaNOcS95yDHAs75t/tJ1rdhJWN6QFxw9WD+vwczN7288UgNHDVpj14ZdJTlO9HF9nofOnkxmVjMB6ZBfDoj+aZf6W+Xs7mpoemr5cLlAOPC20L7oxHNHE9fQyKVY1ITczhElkqIbv6dFA3anZ+fo2ZF4tLey5vYF3C0Bp042mpuYRXyetelCtgFTE5tvViwv8s/H/VFVhPE5K6kmujeJmHHS7c6v/FTskCho74CKox7ZlkIP9KusqslNhpPbfeWrtcIJl7Bd6jdb84qdH7jp2oiJRsnAYJAlpCu5oG568p/4r/JOy25TDl2oIp/x/lN/6Qk4aZdW9h4L3kRfNev879Si704rY+zNiEaVp1TAROv4iQYOd7s2TUqrmLaXtuoFOB5rnYIUcC+9Ri+x1yHOeGiayyHKfdvOMjd2WysOjuJokHjUAal9jVF5DclM6tG1+/1lNJ9TX08hGNkYFxRMzPoBPQSELi9BsQPUnyyBTCdh1tclC6CacmtgQtUCNoZHitaLryikrI0A+V7s0gI2tNaEYQfsKMVbuPoPPVHlvtntfwKD1+pEyE/JUJ6q3AJjYH/IM9k7PEjPNq63jzi3oY/0tfSzV+X3U+z5iS8MxhlOvJT7M+bZcdO3QH49krAqcWc6lMUH+1/US8nhKANpbUlUiIEyUinvMgs2BTc/EYTj7XghpEX7qWMmGm9qPxSvIM/dWMP4aR9w93pIL/J3PeR8SgSlYR5
 krMAb3nE
 dK9Q/pOIQ2RwdFDBICCyoYQARUJRZRmHAkcnAzHBOG1kTO9q+/lO00AuKX2RiLpnu5hp4zios3GNA6WERdEgw8IoihqDf/lO5v6VgXZYlyik2GLUD/iQyc26/GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/5/25 07:24, Mika Penttilä wrote:

> Hi,
>
> On 8/5/25 07:10, Balbir Singh wrote:
>> On 8/5/25 09:26, Mika Penttilä wrote:
>>> Hi,
>>>
>>> On 8/5/25 01:46, Balbir Singh wrote:
>>>> On 8/2/25 22:13, Mika Penttilä wrote:
>>>>> Hi,
>>>>>
>>>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>>>> FYI:
>>>>>>
>>>>>> I have the following patch on top of my series that seems to make it work
>>>>>> without requiring the helper to split device private folios
>>>>>>
>>>>> I think this looks much better!
>>>>>
>>>> Thanks!
>>>>
>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>> ---
>>>>>>  include/linux/huge_mm.h |  1 -
>>>>>>  lib/test_hmm.c          | 11 +++++-
>>>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>>>> --- a/include/linux/huge_mm.h
>>>>>> +++ b/include/linux/huge_mm.h
>>>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>>>  		vm_flags_t vm_flags);
>>>>>>  
>>>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>> -int split_device_private_folio(struct folio *folio);
>>>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>  		unsigned int new_order, bool unmapped);
>>>>>>  int min_order_for_split(struct folio *folio);
>>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>>> index 341ae2af44ec..444477785882 100644
>>>>>> --- a/lib/test_hmm.c
>>>>>> +++ b/lib/test_hmm.c
>>>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>>>  	 */
>>>>>> -	rpage = vmf->page->zone_device_data;
>>>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>>>  	dmirror = rpage->zone_device_data;
>>>>>>  
>>>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>>>  	order = folio_order(page_folio(vmf->page));
>>>>>>  	nr = 1 << order;
>>>>>>  
>>>>>> +	/*
>>>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>>>> +	 */
>>>>>> +	if (vmf->pte) {
>>>>>> +		order = 0;
>>>>>> +		nr = 1;
>>>>>> +	}
>>>>>> +
>>>>>>  	/*
>>>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>>>  	 * large number of cpus that might not scale well.
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>>>  					  struct shrink_control *sc);
>>>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>>  					 struct shrink_control *sc);
>>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>> -		struct page *split_at, struct xa_state *xas,
>>>>>> -		struct address_space *mapping, bool uniform_split);
>>>>>> -
>>>>>>  static bool split_underused_thp = true;
>>>>>>  
>>>>>>  static atomic_t huge_zero_refcount;
>>>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>>>  }
>>>>>>  
>>>>>> -/**
>>>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>> - * split folios for pages that are partially mapped
>>>>>> - *
>>>>>> - * @folio: the folio to split
>>>>>> - *
>>>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>>>> - */
>>>>>> -int split_device_private_folio(struct folio *folio)
>>>>>> -{
>>>>>> -	struct folio *end_folio = folio_next(folio);
>>>>>> -	struct folio *new_folio;
>>>>>> -	int ret = 0;
>>>>>> -
>>>>>> -	/*
>>>>>> -	 * Split the folio now. In the case of device
>>>>>> -	 * private pages, this path is executed when
>>>>>> -	 * the pmd is split and since freeze is not true
>>>>>> -	 * it is likely the folio will be deferred_split.
>>>>>> -	 *
>>>>>> -	 * With device private pages, deferred splits of
>>>>>> -	 * folios should be handled here to prevent partial
>>>>>> -	 * unmaps from causing issues later on in migration
>>>>>> -	 * and fault handling flows.
>>>>>> -	 */
>>>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>> -	VM_WARN_ON(ret);
>>>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>>>> -								new_folio));
>>>>>> -	}
>>>>>> -
>>>>>> -	/*
>>>>>> -	 * Mark the end of the folio split for device private THP
>>>>>> -	 * split
>>>>>> -	 */
>>>>>> -	zone_device_private_split_cb(folio, NULL);
>>>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>> -	return ret;
>>>>>> -}
>>>>>> -
>>>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>  		unsigned long haddr, bool freeze)
>>>>>>  {
>>>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>  				freeze = false;
>>>>>>  			if (!freeze) {
>>>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>>>> -				unsigned long addr = haddr;
>>>>>> -				struct folio *new_folio;
>>>>>> -				struct folio *end_folio = folio_next(folio);
>>>>>>  
>>>>>>  				if (anon_exclusive)
>>>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>  
>>>>>> -				folio_lock(folio);
>>>>>> -				folio_get(folio);
>>>>>> -
>>>>>> -				split_device_private_folio(folio);
>>>>>> -
>>>>>> -				for (new_folio = folio_next(folio);
>>>>>> -					new_folio != end_folio;
>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>> -					addr += PAGE_SIZE;
>>>>>> -					folio_unlock(new_folio);
>>>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>>>> -						&new_folio->page, 1,
>>>>>> -						vma, addr, rmap_flags);
>>>>>> -				}
>>>>>> -				folio_unlock(folio);
>>>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>>>> -						1, vma, haddr, rmap_flags);
>>>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>>> +				if (anon_exclusive)
>>>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>>> +						 vma, haddr, rmap_flags);
>>>>>>  			}
>>>>>>  		}
>>>>>>  
>>>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>  	if (nr_shmem_dropped)
>>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>>  
>>>>>> -	if (!ret && is_anon)
>>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>>>  
>>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>> index 49962ea19109..4264c0290d08 100644
>>>>>> --- a/mm/migrate_device.c
>>>>>> +++ b/mm/migrate_device.c
>>>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>  			 * page table entry. Other special swap entries are not
>>>>>>  			 * migratable, and we ignore regular swapped page.
>>>>>>  			 */
>>>>>> +			struct folio *folio;
>>>>>> +
>>>>>>  			entry = pte_to_swp_entry(pte);
>>>>>>  			if (!is_device_private_entry(entry))
>>>>>>  				goto next;
>>>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>>>  				goto next;
>>>>>>  
>>>>>> +			folio = page_folio(page);
>>>>>> +			if (folio_test_large(folio)) {
>>>>>> +				struct folio *new_folio;
>>>>>> +				struct folio *new_fault_folio;
>>>>>> +
>>>>>> +				/*
>>>>>> +				 * The reason for finding pmd present with a
>>>>>> +				 * device private pte and a large folio for the
>>>>>> +				 * pte is partial unmaps. Split the folio now
>>>>>> +				 * for the migration to be handled correctly
>>>>>> +				 */
>>>>>> +				pte_unmap_unlock(ptep, ptl);
>>>>>> +
>>>>>> +				folio_get(folio);
>>>>>> +				if (folio != fault_folio)
>>>>>> +					folio_lock(folio);
>>>>>> +				if (split_folio(folio)) {
>>>>>> +					if (folio != fault_folio)
>>>>>> +						folio_unlock(folio);
>>>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>>> +					goto next;
>>>>>> +				}
>>>>>> +
>>>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>>>
>>>> test_hmm needs adjustment because of the way the backup folios are setup.
>>> nouveau should check the folio order after the possible split happens.
>>>
>> You mean the folio_split callback?
> no, nouveau_dmem_migrate_to_ram():
> ..
>         sfolio = page_folio(vmf->page);
>         order = folio_order(sfolio);
> ...
>         migrate_vma_setup()
> ..
> if sfolio is split order still reflects the pre-split order
>
>>>>>> +				/*
>>>>>> +				 * After the split, get back the extra reference
>>>>>> +				 * on the fault_page, this reference is checked during
>>>>>> +				 * folio_migrate_mapping()
>>>>>> +				 */
>>>>>> +				if (migrate->fault_page) {
>>>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>>>> +					folio_get(new_fault_folio);
>>>>>> +				}
>>>>>> +
>>>>>> +				new_folio = page_folio(page);
>>>>>> +				pfn = page_to_pfn(page);
>>>>>> +
>>>>>> +				/*
>>>>>> +				 * Ensure the lock is held on the correct
>>>>>> +				 * folio after the split
>>>>>> +				 */
>>>>>> +				if (folio != new_folio) {
>>>>>> +					folio_unlock(folio);
>>>>>> +					folio_lock(new_folio);
>>>>>> +				}
>>>>> Maybe careful not to unlock fault_page ?
>>>>>
>>>> split_page will unlock everything but the original folio, the code takes the lock
>>>> on the folio corresponding to the new folio
>>> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
>>>
>> Not sure I follow what you're trying to elaborate on here
>
Actually fault_folio should be fine but should we have: 


if (fault_folio)
        if(folio != new_folio)) {
                folio_unlock(folio);
                folio_lock(new_folio);
        }
else 
        folio_unlock(folio);




>> Balbir
>>
> --Mika
>


