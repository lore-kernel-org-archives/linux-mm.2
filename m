Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E5DC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 16:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2233E6B007B; Wed, 30 Jul 2025 12:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3E46B0088; Wed, 30 Jul 2025 12:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2A76B0089; Wed, 30 Jul 2025 12:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE9456B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:29:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7436F1A04FA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:29:35 +0000 (UTC)
X-FDA: 83721466710.30.04A3FF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B14581C0011
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:29:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WqL2MU/w";
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753892973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEQXawrDSm/zTim30qZTufFHeqh0z4KbFmTdRdtP3Ts=;
	b=5jjNrZ4ulWN39aXjxT+tFYl+CSBjGJ8qtRE8PDFKev5YD0bM3iX/5QaHF1Y5puFqrOzBXi
	CrCwaffyDNFqQBPyGdGZKUraAcvmlvtM2OiKFfo4tunYCCPumVGvWvS+SC/qS0o5EugBdr
	ToZMXvE3F39MSu1Z10cXLvGJhyehTpQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WqL2MU/w";
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753892973; a=rsa-sha256;
	cv=none;
	b=hXYmpCgDVhdTsr5E22kCFwn/30txJmlnIEbBLK+tcrwNXI+f9sBMCxfMR874hcPkmxAD7u
	Yd96pDihGmhvjy6UZvZJAZXsMJNlX9S/k1MLPLaxS+nUjS1ccj0P3hgi+qSzaLJ3N73Sx/
	9euT483XNn0+diOwxTTEkWYTIwfN02o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753892971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEQXawrDSm/zTim30qZTufFHeqh0z4KbFmTdRdtP3Ts=;
	b=WqL2MU/wnkYiq03/qgn2EnidpT/cQRHTlE49wVBi4MtlUK4BTLw3YjaE8PPj8KdqWNGaIN
	4zfGcOVD9ccYTcVrfhZgjlXDAuK0zuf3mW8YdTBT9VkCVPW+aK2c5McpTUOHtsNDQe8aFc
	vpbTVXamWkbqoWda1DwuSr7Yue6GUh0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-sKUhkA3XNoCN2T6rW4M30g-1; Wed, 30 Jul 2025 12:29:29 -0400
X-MC-Unique: sKUhkA3XNoCN2T6rW4M30g-1
X-Mimecast-MFC-AGG-ID: sKUhkA3XNoCN2T6rW4M30g_1753892968
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5550e237ad0so644086e87.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753892968; x=1754497768;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dEQXawrDSm/zTim30qZTufFHeqh0z4KbFmTdRdtP3Ts=;
        b=wfOJxrTgUss9RsvBj8BlRNQ3dN9Iiw0xJVpHpNqJvLQchmo8wWh/UcNlJFskZB5NoS
         zlAzHqOdEUbKNfbXoHMIvgKi+d1ed/xU5n6SSXvY07YUDq/noew/KzHrq2FKh0yBB5Dj
         +QMjlOwr8QwwE5eo4eenc/rWabgqJ+M4F9AYVJKKIaJI3yFDEbpYaFXbckzoTl2yeiyG
         wVDQ6zUPWPhXLvDBJDcYo/kKXJ3u+WFmbard4y7zhbHSPSBrRLNCRZiI1cg8V8Xyx7Tx
         ALOVNOXQpUdYLvS9s0Rhti/lddEQIuoa40tPeKK5lPO0150/Adp5n1XzDYJgf3SH9Ehp
         qZ9w==
X-Forwarded-Encrypted: i=1; AJvYcCWdjO6NiQZ/2HRFOrlWAHL7zHbI61E1JzhRY8HsrKcqC1OnPDAfZzKhpZhMXz/GnLfbL4lraHiLqA==@kvack.org
X-Gm-Message-State: AOJu0YzCD6UN4kBhTL5MuGVoX6HsEMaKobF9RNOdsgfl5SffgxaDPoGq
	fl5rFYfhrm6M0iT1+wnUqFzHQEqeceledhN+KL786SDMQnVML6y+LQknI8IoxAEpEdKBmexexBI
	NJkbQPiJfSuDCQ9hxHbSQAPpnsmWb2f9dCayec4EOgc6Yq4myL7U=
X-Gm-Gg: ASbGncuwk+GZ6DCu1OSdbeg6059lJmhJ434YOlZdlGPGvjOdBvwKBXsJ2Qe9YgTaGrD
	mJ2oyhp8Hz8WNrfuObXqaoPTdTpKpzIa627ocZ9oT8F7K1DqGVEFtOV0kVBnrLuHmWuga+DRyY1
	vpfqXo9q+DfU3/RfFpHE2zOinkmI2K9H8WTmmhqAF0FwrRJ5MmEMqsrPMz2aegAyrVQdXbkPY1h
	nRUXGmMZSqefPljPATVlfmnC7ALr3PKaBC3zsU3T46hqend0syY1SjMuA9QgtiUJyOaGXBAyw/E
	zLtTmwx+dniXfJawB4SLtGCgpp/8IOuCSwZlRa9xPdyEnIG+Ah3Qx1cbOuLpICqv0A==
X-Received: by 2002:a05:6512:110e:b0:550:e608:410b with SMTP id 2adb3069b0e04-55b7c05d518mr1073821e87.33.1753892967804;
        Wed, 30 Jul 2025 09:29:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCtSmMjqj8jYBMAEp8khqU0VrRa4oUIthwQ+vCPSkdQiuj611DDDkU8OVhVcpRR0AOxttI2g==
X-Received: by 2002:a05:6512:110e:b0:550:e608:410b with SMTP id 2adb3069b0e04-55b7c05d518mr1073815e87.33.1753892967335;
        Wed, 30 Jul 2025 09:29:27 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b6316db1dsm2211386e87.40.2025.07.30.09.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 09:29:26 -0700 (PDT)
Message-ID: <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
Date: Wed, 30 Jul 2025 19:29:25 +0300
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
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P1lqQzwlfcVua0Ms5FFW4wOsr3SEwT4tjnINgXnpVgw_1753892968
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B14581C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: oq6dyz4gq37tcgiahgftiufm9hy7hpak
X-HE-Tag: 1753892971-78276
X-HE-Meta: U2FsdGVkX1+QoKQAhUsz6075ygaD9qskbk4LO8zvDf9n0KUrs+8wl79ARgPeGEKH1fbIl7hp5Mia0a4AgabKYFAL8J4o3LFSaOrM9Xu1/MnfliS9WFb+gVwUmQiMgYNDzTtEW8tVshgAJdebBUcH626zbagCiHvFmZQ15Hji3lWxTaS4CbElSL4dDq/vtSddBOSY+N1D1UwINzQh0HpLcHoUAo7Ju0iU2Svx6PpVTD1ta5xwHhaNaLDkG220mv3Zm9dD7PFICj5o429K966HeDPhk8opxwpDCGLF8VEM/p23ujxZNvr4guZguEEVARdCj/6zWVH4ie4S42fBLk4i6BqKb62jMtwQ+EMPOp1QfhPaQzi0J4gklxh3CId7Ml78paLH0tqc7wZOpvw0hqBmvInr5TRsCVBSWf/BuriksHon77FLWPFjKvYvjIOWz5bOSjXAMiwbj6e4cgMjdKPsOFVt9vntApuuCC7vn55Mn1SJiWcJcf4cHA+SpkXm5dakjuDyEDykDkNJR48f105UoCNpqNVSQY4Cmq+KTL5Cf/wVLq0/Y9jdpntntIkX5UoidZN34y7Hu/WQYs0EcpUnmScapKJFVaxunCsEjhQKvtcfBpyQFdNrC0dZ8/Q8LvERsq001bre3SZ2hHSISfFGKKg4meoEpZH8aePnHsVqMkmmfZ8Qx7uVFwMt9l83mfBSfdDCfUdv/xliHjSjWixrdvkM8RCh1P1im5h8uRCbjYNNbDwAALCsYfymSosYQ0I27A2y0XjSF9Hr/u2ffu54T7bZiFkP3BQ9pwpEXXHns+llg7gNv0O5c9DZHz5RU4blBGQfG64OVZX7aVufWEJ9McWwbv4Lht+LBfU7fykguhGNeoFhyIiYQuVTv5IWXC8cv2OuKj920GOyCYoOrEv9PGmTWKoW2cubuE7DaykOGyiM4Z4FahuOuVuAv6eKw/t+6s5+9tx5MrYT80q5s4s
 bZJEzKvB
 JniFxY1cyeG/XrZKzIXtG12xOxxXd/SKwDujExaJsStg/MTrDXOWJ+OMlvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/30/25 18:58, Zi Yan wrote:
> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>
>> On 7/30/25 18:10, Zi Yan wrote:
>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>
>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>
>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>
>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>
>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>
>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>> entries.
>>>>>>>>>>>
>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>> folio.
>>>>>>>>>>>
>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>> ---
>>>>>>>>>>>  include/linux/huge_mm.h |   1 +
>>>>>>>>>>>  include/linux/rmap.h    |   2 +
>>>>>>>>>>>  include/linux/swapops.h |  17 +++
>>>>>>>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>  mm/rmap.c               |  22 +++-
>>>>>>>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>
>>>>>>>>> <snip>
>>>>>>>>>
>>>>>>>>>>> +/**
>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>> + *
>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>> + *
>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>> + */
>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>> +{
>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>> +
>>>>>>>>>>> +	/*
>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>> +	 *
>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>> +	 */
>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>> device side mapping.
>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>> 5) remap device private mapping.
>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>> folio by replacing existing page table entries with migration entries
>>>>> and after that the folio is regarded as “unmapped”.
>>>>>
>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>> Yes, but from CPU perspective, both device private entry and migration entry
>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>> at CPU side.
>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
> Right. That confused me when I was talking to Balbir and looking at v1.
> When a device private folio is processed in __folio_split(), Balbir needed to
> add code to skip CPU mapping handling code. Basically device private folios are
> CPU unmapped and device mapped.
>
> Here are my questions on device private folios:
> 1. How is mapcount used for device private folios? Why is it needed from CPU
>    perspective? Can it be stored in a device private specific data structure?

Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
common code more messy if not done that way but sure possible. 
And not consuming pfns (address space) at all would have benefits.

> 2. When a device private folio is mapped on device, can someone other than
>    the device driver manipulate it assuming core-mm just skips device private
>    folios (barring the CPU access fault handling)?
>
> Where I am going is that can device private folios be treated as unmapped folios
> by CPU and only device driver manipulates their mappings?
>
Yes not present by CPU but mm has bookkeeping on them. The private page has no content
someone could change while in device, it's just pfn.

>> Also which might confuse is that v1 of the series had only
>>   migrate_vma_split_pages()
>> which operated only on truly unmapped (mapcount wise) folios. Which was a motivation for split_unmapped_folio()..
>> Now,
>>   split_device_private_folio()
>> operates on mapcount != 0 folios.
>>
>>>
>>>> And it is called from split_huge_pmd() with freeze == false, not from folio split but pmd split.
>>> I am not sure that is the right timing of splitting a folio. The device private
>>> folio can be kept without splitting at split_huge_pmd() time.
>> Yes this doesn't look quite right, and also
>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
> I wonder if we need to freeze a device private folio. Can anyone other than
> device driver change its refcount? Since CPU just sees it as an unmapped folio.
>
>> looks suspicious
>>
>> Maybe split_device_private_folio() tries to solve some corner case but maybe good to elaborate
>> more the exact conditions, there might be a better fix.
>>
>>> But from CPU perspective, a device private folio has no CPU mapping, no other
>>> CPU can access or manipulate the folio. It should be OK to split it.
>>>
>>>>> mapping, IIUC.
>>>>>
>>>>>>>>>>> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>>>>>> Confusing to  __split_unmapped_folio() if folio is mapped...
>>>>>>>>> From driver point of view, __split_unmapped_folio() probably should be renamed
>>>>>>>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
>>>>>>>>> folio meta data for split.
>
>
> Best Regards,
> Yan, Zi
>

--Mika



