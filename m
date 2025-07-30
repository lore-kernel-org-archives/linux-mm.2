Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFF8C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85F96B008C; Wed, 30 Jul 2025 07:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56996B0093; Wed, 30 Jul 2025 07:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BFE6B0098; Wed, 30 Jul 2025 07:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9760A6B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:42:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DB171403BE
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:42:14 +0000 (UTC)
X-FDA: 83720742588.22.9983F80
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D66F71C0005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:42:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IZBVQfLv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753875732; a=rsa-sha256;
	cv=none;
	b=1fQOYMeOXxAKZMrR/96uRXeeLwHVjQ1xeHtpP8835LAH3aOBOGX8ttT58J1+kfeY7TIJk+
	8aby4JskyeoDGxX9ocj0g5QqrfreKUtTNZyaM0StzRfq+F5swadCHGRbxMDghDiP90cEac
	4usXZ1VYXWnPHRrGP2lr9AJ4XQCl2Cw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IZBVQfLv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753875732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6VJryhEVMx1lwOdZs4jCrrpFWzvXShieQVAVyEHU5c=;
	b=1swnjRJYzB9ThXiBYouxYWd3ALV5gk++DhZNjMkZKGNOrgai2MPI+jx0FXaB53OTz10Gvs
	mFiUlfjdNSdvqKSC4zVtFt+UlGZu3tq5WlhWXa7ThsYIzL6zf/K8AEUoHXHh5BnudOOKy5
	s9FBFf3Ojjb4nMXSNc+JY/O4cdLU+e8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753875731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6VJryhEVMx1lwOdZs4jCrrpFWzvXShieQVAVyEHU5c=;
	b=IZBVQfLvH/FyD37wxvi03bHV/urOZ60FgVyb0yMkNH68XWBcewNWrdQeK9cf1hRWSh0ZLd
	rE1juIUQlLHenzTo+Ua9XGGb6W3gbbrPrR47TQH8fhQ4KwkKZCzEYVrBrRXgQjimbW0AOf
	jhDZGdpJDPiJYm35ae5TSsQ/4+mDpBg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-mK5KBYcJNwaiFqdr3EUFhQ-1; Wed, 30 Jul 2025 07:42:07 -0400
X-MC-Unique: mK5KBYcJNwaiFqdr3EUFhQ-1
X-Mimecast-MFC-AGG-ID: mK5KBYcJNwaiFqdr3EUFhQ_1753875726
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-32cbc4a763eso24315141fa.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753875726; x=1754480526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6VJryhEVMx1lwOdZs4jCrrpFWzvXShieQVAVyEHU5c=;
        b=pmXv+6lR2/K5v9CIbPWHtibjrY4zDtfnYr+Ga4GxTuqA/8x/7It90oARmJzPGmaH2r
         0pI9ep9fbRtgQzDgazBYYAHCCfdHM8wxuWegE/LgzhKVU1PA3+twpBZZIoii+h2sEYWy
         wDqJ0vXh+7fT+0JZU4btfpVDDe4p583w5xAfPn3wR78wltm/TKyorVV6yHqbFRWbNfeZ
         XZIRyu6aMzW8AGdgYFXFA6xdu3f/ce2y/xQvdNqmoVK5/k4NASv7iozbeM6QmNAXGbfo
         YnuNWqmHD4skVSbupt8iUVuaiSazW3z+J9sAQb5eiI47kalaWxrJ25v+Oah6Q66u4hkN
         SuLQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+Y3RBUF88GdLd3SYHL612wCQ+3vXADB6KHdTJwljyA2kBUHZYgaHhmEkhGlB4NfWqbSqgkCviVQ==@kvack.org
X-Gm-Message-State: AOJu0Ywe4TJ1Ht46ByD7v7huKNxFFPO+86wizRoamgO3Mwu4tXcvafuT
	ai/RwhUirMP7ya4tdmN618SBHocxu5tc3k0FRNrSG3ZYMcRyLSSL6xvi1ursUqqKBj+3XKh2vK8
	XC7oW0P1JH9GcuO/43af1slfsVJwp/nLl1Xw3x2VDKa1E9dnwjIw=
X-Gm-Gg: ASbGncvJCndlmQ+l5uO0BpPhauu125N/cT5RdhrNnacEKXgI3o+NMgRZszL1vclslVd
	nTXVK47pn0vKUCGSSmDoLZYh7hzUa3cu7WXtV1anqJWiUouG8dIyNmzFj27MMwJ7eyDr+cY5Akx
	3aijPfqJtIbAjl11x/Xdy1ogjsGn4TUQL+Jk2gbI7M6hx+cZs8/jFDip1U6GYKmIiQttWyuCtYg
	yGizPDDqpUyxtQsw8m+KNLu+Lhm74x1zRCXiXTLeF13Uxbi6gg4FJAOKs3anMfh+qEcmgYFYG8E
	2W9e7aQ18kRdzBjzXlUnD4VmU2TQJo7ljt1B/o3jkSpWUeyI4jwQghL5HsYW2CWVPA==
X-Received: by 2002:a2e:b88b:0:b0:32b:9e00:1237 with SMTP id 38308e7fff4ca-33224be10b7mr10327321fa.32.1753875726172;
        Wed, 30 Jul 2025 04:42:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGs9ngHPB+tu/9eDEWrFOEnZfpKYOAMZyv8bEY/A9NAiVGysSSEIhOPDSQM7MiLIqxglBjJUA==
X-Received: by 2002:a2e:b88b:0:b0:32b:9e00:1237 with SMTP id 38308e7fff4ca-33224be10b7mr10327111fa.32.1753875725689;
        Wed, 30 Jul 2025 04:42:05 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-331f4235880sm19577641fa.58.2025.07.30.04.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 04:42:05 -0700 (PDT)
Message-ID: <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
Date: Wed, 30 Jul 2025 14:42:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hVMkbAsQ31wgRecvi_RlF0r9-ytt46BpgQiEN_hgXcs_1753875726
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D66F71C0005
X-Stat-Signature: edigzsqnfefeghgqap3oei7cipur3168
X-HE-Tag: 1753875731-828904
X-HE-Meta: U2FsdGVkX1+1IQAuktn7ou70vr139bTnQ/4Ak2DItOkHxXv2gGbzjQSV2gqJ47RoATRSN9DML0pL+bnANvNFY8r/nInnAqV2mA97J191OeWtzjAJeA94CKgRD3YbQ29fAyLBUU/khLuXIdb7uJyHdCZGN+EiJt0V9jAhBlp/SiYbuIA0JrPD3FTlRqWDD02rq2GnK0dPIAt/2/M1bfY18d2SKjU9NgEcDPIPQW4oWOt8/7kamXv9H+hfc8RvCOEiQRj2ihVH/iPxy7/trVfA8DEljA2+aGC7jtNO1eMvnanv4olhrJ/q5D3Ty+JhHaQ6oUbBBtjFLETrgGgiq1vjMW6lPS5XYFwRVvpGBvSGfIYjqa2Mt7nhY91ukUbKPn3dErJNjYmkhjQlVmUnLpE0OXaj8yg2mrJCdzHefAuXzsCC2WvA2Rk8jC8Xlk9di5x8agXhJibpO4/uKc5i7dzLdls4OzC4Dbdayks7mkGxe/GgC4ek0EnErczE2TdWp0yLvsAUJOdNoCegeEyYzlJxCFRrOZpkbfFvydE5Pm8sr9XdQ7gp0z/B3q8ds12C4JdKXzik8zDECRoRZp7BRhJNZvfX7IjWR/vXONYuklbKUkU0C4+XF6McHPtVq2fw15PguZnsDc4CUb0c3B9d5mQfM/4TG8tUJ8S9yzFa0AZWTA94rDdAssYwhWGMXPSLNHyhWVBWHCpPyfz+G7nvj6VcLc8x07V9no4Eh6FqQ470fertDif37npDSBnPbWrmpf9G3FI1qxlmtswIG6F81X9SI2eiz8aCvSM3xbwuLrtfzGxI7zxcgWomKzE2CP9Yp+RyX7LMHfBM5zSIWVVOozZxIqIOhEdeTBz2im9aBOcnHOjcf15jMMLoOGUQwp+dzvTJqZtxD2h4V8j4QPxpZh9JB7kehkRbA3oByK7sHbien+G85G1xbJLwfM80eUofzgf0KU/Keqt00JmZWUkObCj
 hVqZM6+h
 ISB191krZJnyfIZds1HiCVRqc1PXDN3dJFf1GDozUslD47QbbfkJsWW1NvIhYzV1r3pFFoqsWQja0NQZ7SsPxoU1gAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/30/25 14:30, Zi Yan wrote:
> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>
>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>
>>> Hi,
>>>
>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>> device pages. Although the code is designed to be generic when it comes
>>>> to handling splitting of pages, the code is designed to work for THP
>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>
>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>> entry is present, enabling try_to_migrate() and other code migration
>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>> return true for zone device private large folios only when
>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>> not zone device private pages from having to add awareness. The key
>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>> not significant when it comes to pmd level bit harvesting.
>>>>
>>>> pmd_pfn() does not work well with zone device entries, use
>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>> entries.
>>>>
>>>> Zone device private entries when split via munmap go through pmd split,
>>>> but need to go through a folio split, deferred split does not work if a
>>>> fault is encountered because fault handling involves migration entries
>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>> same there. This introduces the need to split the folio while handling
>>>> the pmd split. Because the folio is still mapped, but calling
>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>> code is used with a new helper to wrap the code
>>>> split_device_private_folio(), which skips the checks around
>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>> folio.
>>>>
>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>> Cc: Peter Xu <peterx@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>
>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>  include/linux/huge_mm.h |   1 +
>>>>  include/linux/rmap.h    |   2 +
>>>>  include/linux/swapops.h |  17 +++
>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>  mm/pgtable-generic.c    |   6 +
>>>>  mm/rmap.c               |  22 +++-
>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>
>> <snip>
>>
>>>> +/**
>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>> + * split folios for pages that are partially mapped
>>>> + *
>>>> + * @folio: the folio to split
>>>> + *
>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>> + */
>>>> +int split_device_private_folio(struct folio *folio)
>>>> +{
>>>> +	struct folio *end_folio = folio_next(folio);
>>>> +	struct folio *new_folio;
>>>> +	int ret = 0;
>>>> +
>>>> +	/*
>>>> +	 * Split the folio now. In the case of device
>>>> +	 * private pages, this path is executed when
>>>> +	 * the pmd is split and since freeze is not true
>>>> +	 * it is likely the folio will be deferred_split.
>>>> +	 *
>>>> +	 * With device private pages, deferred splits of
>>>> +	 * folios should be handled here to prevent partial
>>>> +	 * unmaps from causing issues later on in migration
>>>> +	 * and fault handling flows.
>>>> +	 */
>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>> Based on my off-list conversation with Balbir, the folio is unmapped in
>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>> device side mapping.
> Maybe we should make it aware of device private mapping? So that the
> process mirrors CPU side folio split: 1) unmap device private mapping,
> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
> 5) remap device private mapping.

Ah ok this was about device private page obviously here, nevermind..

>>>> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>> Confusing to  __split_unmapped_folio() if folio is mapped...
>> From driver point of view, __split_unmapped_folio() probably should be renamed
>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
>> folio meta data for split.
>>
>>
>> Best Regards,
>> Yan, Zi
>
> Best Regards,
> Yan, Zi
>


