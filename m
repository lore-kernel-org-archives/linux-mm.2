Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BBCC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3ADF6B0088; Wed, 30 Jul 2025 08:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB4C6B0089; Wed, 30 Jul 2025 08:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9FE6B008A; Wed, 30 Jul 2025 08:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8CF6B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:08:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 400B81603FE
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:08:57 +0000 (UTC)
X-FDA: 83720809914.28.1E29253
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F81410000B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:08:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4ZdBmeW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753877334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zayXxjXOJyhWgrxS4M7tAq9Of6SpcSVV6owXdHf3Lo=;
	b=hs9iWd47PN/ktGd3pmX3kSj3DRK5VcX7xN3Eo0wDk+nXty9rktyxixZJos1Go6zbr72puZ
	0SqWXKBvce/ZoHlTcTPz44ikzi89/gI4X6YJboyDj9up1B8dRmFunA7lmMBLTm9atk/jEj
	FK4IdObE1lV91sF90KrVDzfHq+kxNxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753877334; a=rsa-sha256;
	cv=none;
	b=t7+Gm+Hbk5+YSc+Khn1uT0OQQzA20uotym+PMUizSd2txSsSlJ9Uu1oRQLbQL5Nl6lclZT
	n0LL+Pa1oEWRCNgUESUkZvSFdK+qzgz5GndZlXbsnoex0aTnOZH08fbYTbH9a2eYJwr6lW
	jHpub8qHv22huWQj5Zg2iJUjv1L1dUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4ZdBmeW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753877334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0zayXxjXOJyhWgrxS4M7tAq9Of6SpcSVV6owXdHf3Lo=;
	b=X4ZdBmeWOIIyISo7TwdKj6j3f7tvD0JNiwwEal0jQDaNwBE3KNAas6N3msvCWutWy7fDT8
	rWN6OwzMucQnbKDhiDXn1dP6BamE4cykbmrdq217SJnQGRys2yxZh3Ea2JD/Im0ZnyUQP9
	fVV58CzZhduDkNUvLaeEEOljc0jsy9g=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-2GCWZvgSPNCx381X_RRO4Q-1; Wed, 30 Jul 2025 08:08:50 -0400
X-MC-Unique: 2GCWZvgSPNCx381X_RRO4Q-1
X-Mimecast-MFC-AGG-ID: 2GCWZvgSPNCx381X_RRO4Q_1753877329
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b760dc47dso911546e87.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753877329; x=1754482129;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zayXxjXOJyhWgrxS4M7tAq9Of6SpcSVV6owXdHf3Lo=;
        b=KaXSX0il8gpjLwdJAle6zFhujdUu7pUjxtHWaFDxsDm5b7LOirCiihIwrFygRsa71p
         vIOxMJMVWGQJAr5A5GnGaAS10gBg4N6oHNZq4aUsixwl88zusZ8wl3Jj31CmIWPkl4KD
         OhRgXQBzBtGT15bFSP4nSllH08lJdCm9qK4zcymjkcAeVKgdYWzzc1jozOJERGMMzWQa
         GQH7au13+eZJCBROLUYqj0wGEN6+5DLZj6YEQuHExUhMbHGobolKfDBAMA/MzyK5U9Oj
         Tpf5WRkfMZRsCKu0q3QUUac6jFq1MR4e+857xCOV+78UlKuHH1E1YTRY5/QwgBvViFot
         i64g==
X-Forwarded-Encrypted: i=1; AJvYcCXb5PPAdTgG2pH9q0wBmtO0DyX8IW/gx7BH4nTuy7Rknn93ZyMjAgHNLieP+StAEvIs6VMh2g8ooA==@kvack.org
X-Gm-Message-State: AOJu0Yz5c2nS6apJJzLa2EMhIqHFEV2fZQsWP5VOQX+44zAdoidTJBGk
	FqawqC7CveDSTbfh9AZjbVbj1J/CQRi6MNrxxf5moHYyMgst9eTIC+VW0mac52Hs0n3oI63Qd5t
	D1gMhC2XZkCdG4EHD3T048y5zNNep55DVTj0yu0NB9LULFzkA800=
X-Gm-Gg: ASbGncvAfDPjvAYgee2tdihg5S4Ym8GDiDkk7y02L4bykbnquZ1owSIa6rRYiKIG0KW
	HHX4BaBx4er0ZmNiJo66DeAvZO916xKZZRIn/+CrFDuxbEv0sxY0o7pzJBeTADah/Dz160wVC4w
	v4THfaoODITSsnZr5PWmdcKB1PO3nslhQL/qWvso2JRA9kImALOVWUHJEbYu8/bPsqmbho3j06O
	UuZKxG98lWqFHCyrXlayqS9KWCNOoCAfGbSKQGpQL02Ig+I/gNEn6kRsD2RbIqaVz1L5CEaDsg9
	pSUvXsikTaYVw0TT4uKz9PXU4L6TFHmXX2hj9/Sw/SeQ4b7JVsF+vREDqqQudoR0yA==
X-Received: by 2002:a05:6512:3c84:b0:55b:2242:a9c1 with SMTP id 2adb3069b0e04-55b7c089e2bmr964221e87.49.1753877329125;
        Wed, 30 Jul 2025 05:08:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvIhc4qMQOPIbpnZe14iwXH/4Cx+G2ep9eLTTzMWEJn+T/HUl1X158JOxA2msrN/fq149EBA==
X-Received: by 2002:a05:6512:3c84:b0:55b:2242:a9c1 with SMTP id 2adb3069b0e04-55b7c089e2bmr964196e87.49.1753877328627;
        Wed, 30 Jul 2025 05:08:48 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b63393c72sm2127002e87.178.2025.07.30.05.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 05:08:48 -0700 (PDT)
Message-ID: <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
Date: Wed, 30 Jul 2025 15:08:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
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
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
In-Reply-To: <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oj0QI6diTGmJWmxkicAHf8Hs-flkAuZMpW5IuQB5_Zk_1753877329
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F81410000B
X-Stat-Signature: 9g7hf1d9g73ebt5fd94qc6jzfjm9not9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753877334-79615
X-HE-Meta: U2FsdGVkX1/kHChbszpwNidjzrjJqXY29vkejwnvOVElb8o3OkJeRD7gMXxTnR0FUs1pvZjcclsbkRPAGm93Y0ShBYpbtfbOgvKObrUOkkhYcxc+vl47BxtklFmKGv9cv0UYar65YNh079UaJWBbP9ZLxByiryfOulfX/JYlyBdGiQgkBM9KFxBToVx+Vikk3UZN4ryGj7XiyHJGGim3o8ro5ZrVYHv8D8z/UKDgOP0moqlybsNZIMfQkv53Dz4gBoT8cc5g0dfBy9Vs8BXPNmoNEB4RaX3p3/EWE5kPIaXUFbLnvlMpky0yewYIJooESgpXAyDaltr8Dv/5yyWjiNycc5zr8GHp0RTcncUX+lOBUelbn8LB0fAL9B+kpBpX79caD59a9a1fsd4NV/1px+1fs+7n1gVVBQlXGo1rk3g7tTF1Kqy/Ww4ofOhMLOcJGOqVdestDGtnxAikMojX/HbO4Nqhrzch2zGAtUjtAKnhNrIOciP6Qm0bgQwBCOYwVAfn2qBRn69WhvpgBl+ebiO2PKkNJoLR6frnus2f2bGwhzTrNcJSlFCiNGKN/JcsfB3zpOOOvgrtWwlFi5yVAk6gViFiGf9fwRykkXt3kN9iw9sHJh/8kAxDeWgMhbNfzNrwH7450OLCk08OGIQMoJsSmSaD+DCTNnjc3q+8tZg2/fzqTrd64yzHtt43gx4unJntzDCMfB7jQS4QNaPIxYauUMAeaYYVjSanG/PHwumk8wOhnxGd/R2nLzaDzMSkYTCkosCfAW0jItJFWoCa77q1VQpz0yJA464wolQ0hjW3O/OuW0jTtVsLCva4UVV9GBH6kZnhWL1TvA2aTml6rnmfOABHI9Y+7a2XL2vp+V0J0uIVvFZddTG7/k+5SrBfJg94rePGdZwXx4WNtTyHEJcEwzxELQxIgQ+KJjJLTd8UO5TY4I2jF2YSFAS5WIqyR8n8w0jsMEtX5VjwF5Y
 OH99K0uU
 oimjU2GUicrn+yoUUU4vUghc1Ow8VKL8roh3GSMtrwnDUYAS5a2j4gdyT3Y8Gcjw4FT5sF0kELHla8l31U075efaqDr0kr/oF4OChblmsNl/Suwv97Zpx+yY4ZjWMiRjNWuK586Y8DbmnXoZ8+8p22+AeD/Pxui7dA09Ud0C1qVvcqkCw04tMLwFs4gVWVNU0VLjcybNWmY16UdY7ItUVD4aN/54eohCzxzqg50OMao9WcxgYyN2ye6NhHAIuhM/XrLFpJhf11PcEWvxhavak5qf+yGSr3PopJxytBCItvJu9jeiuKgTGFbbRcugbm/QZ4b8NX6R9TL0H1dP+74KWiizEM4wgnjdPDLKnbc7HDzlS5BjLyXGYj+99tIB1j/6deuqsEouFn7pyY7e+R8amVVaTv4Qyx0LpcsF5yW576i60TMn27DkOdkNVqvCQmYPfhVJnbSatYJ7H3qQbSzOsByDb5Q8rXanMQioGekD4kYsF/SuhxKy+Q4kIDUTb8aYEWxLarVXSEnA7XiKE1cQG38tOXWGLoBObSAhFVpj/YdGhWdzSMuoPaWN4fk4G0nfcCG0+Nt/SM3lEvmAUR/ic3Iw0tFVu9IX1pCsxzuXUYnPcopzYuZGTYX1ssiZn00rq5ifNj3scJKqpFH8SFqxHdffih2mf6GD00T65tkKchEHCL8xG+G9dcM4mCZmdKXGfBF1IHBHDzRdnjLf4zxXwQ1A3Fgr132ImuQ8voW7TK9vbVvqmN9KrnnYkQvB61NiKa044kwwFhvgjl+OqCbhsIgehOREvJKZPbIxZ0dgh7KjH7vGQcFB5FtX92w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/30/25 14:42, Mika Penttilä wrote:
> On 7/30/25 14:30, Zi Yan wrote:
>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>
>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>
>>>> Hi,
>>>>
>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>> device pages. Although the code is designed to be generic when it comes
>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>
>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>> return true for zone device private large folios only when
>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>> not zone device private pages from having to add awareness. The key
>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>
>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>> entries.
>>>>>
>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>> but need to go through a folio split, deferred split does not work if a
>>>>> fault is encountered because fault handling involves migration entries
>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>> same there. This introduces the need to split the folio while handling
>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>> code is used with a new helper to wrap the code
>>>>> split_device_private_folio(), which skips the checks around
>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>> folio.
>>>>>
>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>
>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> ---
>>>>>  include/linux/huge_mm.h |   1 +
>>>>>  include/linux/rmap.h    |   2 +
>>>>>  include/linux/swapops.h |  17 +++
>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>  mm/rmap.c               |  22 +++-
>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>
>>> <snip>
>>>
>>>>> +/**
>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>> + * split folios for pages that are partially mapped
>>>>> + *
>>>>> + * @folio: the folio to split
>>>>> + *
>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>> + */
>>>>> +int split_device_private_folio(struct folio *folio)
>>>>> +{
>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>> +	struct folio *new_folio;
>>>>> +	int ret = 0;
>>>>> +
>>>>> +	/*
>>>>> +	 * Split the folio now. In the case of device
>>>>> +	 * private pages, this path is executed when
>>>>> +	 * the pmd is split and since freeze is not true
>>>>> +	 * it is likely the folio will be deferred_split.
>>>>> +	 *
>>>>> +	 * With device private pages, deferred splits of
>>>>> +	 * folios should be handled here to prevent partial
>>>>> +	 * unmaps from causing issues later on in migration
>>>>> +	 * and fault handling flows.
>>>>> +	 */
>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>> device side mapping.
>> Maybe we should make it aware of device private mapping? So that the
>> process mirrors CPU side folio split: 1) unmap device private mapping,
>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>> 5) remap device private mapping.
> Ah ok this was about device private page obviously here, nevermind..

Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?

>
>>>>> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>> Confusing to  __split_unmapped_folio() if folio is mapped...
>>> From driver point of view, __split_unmapped_folio() probably should be renamed
>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
>>> folio meta data for split.
>>>
>>>
>>> Best Regards,
>>> Yan, Zi
>> Best Regards,
>> Yan, Zi
>>

--Mika



