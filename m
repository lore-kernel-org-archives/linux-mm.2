Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E47C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7D16B0088; Wed, 30 Jul 2025 08:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98E96B0089; Wed, 30 Jul 2025 08:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87396B008A; Wed, 30 Jul 2025 08:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A93686B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:49:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65F53B98D4
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:49:14 +0000 (UTC)
X-FDA: 83720911428.17.9D1BD46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF2EE100005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:49:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SrfqaeoH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753879752; a=rsa-sha256;
	cv=none;
	b=hOCM/n7xSPFO2ZIRKsbPLvW7QDAUSEgANxMVUfM0gKBbNK5euVmLv1hropxL+TPh5mGTyG
	XDivbEH/HipSW+CpGeucV5hrw8sSxwO+n7uCfMK0GPZHOjBpk1g8/uoa0WVGSC9OVQTmkS
	xRVVrSZB7Qd1BVe5rPsyrbkfSlPyc9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SrfqaeoH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753879752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZUN75x2L14EgNPJJUNjgv3vPQSsoNHFr+OA9tV21yY=;
	b=nEMtk/5TfAsJo3ZgmHycLvAlYQKGewEfXFxOs/x35xUBbsZaj3E4Z1mFxeLvC9IeaaNdrT
	XwgWZ8SrBERyiynVUfr6IZxQ2cUmJTVZscU+UHci6/7sibPIEe8mLt7/FHVr763ibi6gzr
	lkWutf8Vp/EN4u/bWIiLA/Oq65zLTdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753879751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZUN75x2L14EgNPJJUNjgv3vPQSsoNHFr+OA9tV21yY=;
	b=SrfqaeoHi7t+xiBTS8wY907w1icpf4VoXgNzD27y5H4XD60TZbztR2dU0jHv3+mzva18Dx
	4TxJ/yYNQTWIK/iSV0/4TFskKDVKMGHyz9m9kHxwDP+1dq7REosVv/eGjE4JjdLMoynDL3
	QyLJal2CdftGr5+/8cJqXIrTNetjGTM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-gk2PRz80N6SvxkreZaOI3g-1; Wed, 30 Jul 2025 08:49:07 -0400
X-MC-Unique: gk2PRz80N6SvxkreZaOI3g-1
X-Mimecast-MFC-AGG-ID: gk2PRz80N6SvxkreZaOI3g_1753879746
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-32b3ba8088fso3675101fa.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753879746; x=1754484546;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZUN75x2L14EgNPJJUNjgv3vPQSsoNHFr+OA9tV21yY=;
        b=NfR232wf83VBhgACQwXL7uZTuRef8DqqXbAEwxt+kKclxUIYF5dQCqU+ouYlIOLT/a
         kEoMdCe4kYXnRLizBhOADeNHgyLpH7qsDNJBN7vlzpAuJNWVuWWAKtsfszkc081RIvGM
         u73FJF2Q/dzF2iLkqt2sCFIVByIpZvHI/lj3jp5lPaHTrqFk8JdF0mqE13jNI8cmGDAt
         e4jBEKXWlxphGZAfkWFZof7hwr80OiEwTvmLfnKyehPVLChZYOXgZqaKNZVBGW1R04Ma
         l4j3y+13nzl3GGLvkA6BcXXtWAwg7QceOIOGcF2V23hfQ0GOxhlq+pqYrkcCE+6ESKGE
         NR+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtgIzgu2FMCvQ7qXgcZt36KAQ2+SPDhnY6eeCnz9J0r3i0xM3viKenK2gr5hre09ahm5J88Q1oJg==@kvack.org
X-Gm-Message-State: AOJu0YytJvlJXiuSlPtBa/YrCX+4fqeI9clAgVvlOeBnIavBRiuV06It
	df/MyVghSEwZVo6gzQXr7LP6gDWDB5gbA7ywVQxIUEiGQpkJ6oWKPx9Fst7fzMbT/EfO1Oq5PQu
	vnj3JM6lS3e/1Upy5MLoikZwAR+0owOCMri6xBPMGxZdTROZWUY8=
X-Gm-Gg: ASbGncswj3Y5kCKjEbAfOmHRR9X95QUW02qu1bLScq5CcYSNC2VwTAkq+9YZVoEDpXq
	kSWvxtQLckMIcRzgXjDAn44cVMZHublKQ4eYdXAP8UndWatyDcUl0pc07Kwj9lM3vOAsiiWsQM9
	qwEvYSeiR7QHlHJVmcPzWYkwdgN31r9/iDJioPfhDbI/nhjKtGZXgwJ9j4UU8z7RM+znLyPK2cD
	Aeoe0yke+CQZXd0jNCPfswf4xyWTdnlq8XMEPwiOXnywpGcqk3dYMLpFl+IqEec2WHApZKkx5qn
	a2abdAOB/7sI4iAh1m7Pse4CKTCLjgIVbKg03GnBbDSXwUBB9EnUm0I7zfYFo/7cww==
X-Received: by 2002:a05:6512:4015:b0:553:23f9:bb37 with SMTP id 2adb3069b0e04-55b7c072c36mr1043804e87.40.1753879746220;
        Wed, 30 Jul 2025 05:49:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6BFlRd8e64dL1jm2ku8mwGgkk3C2uMqJsm2lCzIapccB0coiry6mKgtB9ZE0tEYSS0gk96g==
X-Received: by 2002:a05:6512:4015:b0:553:23f9:bb37 with SMTP id 2adb3069b0e04-55b7c072c36mr1043777e87.40.1753879745647;
        Wed, 30 Jul 2025 05:49:05 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b6316d9e7sm2128039e87.26.2025.07.30.05.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 05:49:05 -0700 (PDT)
Message-ID: <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
Date: Wed, 30 Jul 2025 15:49:04 +0300
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2aTAF4UbmN7V8uENQInz1a9Rnc1rNSmCfUdyaDmNQqo_1753879746
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF2EE100005
X-Stat-Signature: h6ystkwjc1mijct48875dyqmg448n5gc
X-Rspam-User: 
X-HE-Tag: 1753879751-824353
X-HE-Meta: U2FsdGVkX1/B+9V61qZ90sAXrLnp5kB6o/vd+3ls1gtaV5VSIHcdNtgvh37EDWA2bL/QKHQEJtDL6/nNZTERAu+CiTx61rY56keeu5/mo31rBEH4ZjQfCFa5PpMH8269GeIYehXzUIm9l+RmpkIwsWgvUCA7h1K7nfGLjs83Dpcx1/ekCf6YUyWmdaGRC07f/vtW49xtN5oTzUVDkM5gLejB/1ieHLFXM4HXaUc97TxO6Nw06XMttWmN2G9fW+8oo9shxplEXkU7WU1N6hOgp+stzxKLCq79JvxnFk8rTDYYVbm/eKeZKwNUgd3d8khg0D6YeF3T8ILLhkAuVFSvcfGmRlCnstuH+8WD5s3Pd7QZikriyWt5Gw8lU0ZQ8YGPrl1CCH2enJmJqJqQdpRBlOSYKUldPPRH/YGL28OWnkawbsaijtJB1lQPF6ip95roOBI4HrmJ4wtFHQ/SDaKTbw4D/atL/D5SZz7oMIQrn+3g5jfy1Wwue3NCZX0m7RYItxunwdl/F3mWyJXYctrqw6oa9fnGiYdLPI5AIikzm38j5w4iRL2hisoRHTBhzBEYPc59mpaC/zdwWCfHWmWgx9LUEjh0ElgJc28Qm51BOYSs1So2+zWlQEPFe0ca+jSH5HlVOBVqgCWq0qcsaLdcOwiIcv2xqWi0ZrcMiBBAmhi1cmFkBsl4idn2dcIphx5W605TCbkbCfAi7Yrdbz4+ofOS+Q6s4dAn7a9kdkOPZVS7Te6SYPUF2VijFFzhZdquA8BMaEjo8XWy9EM28JZmaV/Yi6KF3Pm4IHCtY/UJ8slmtjjHS4xK7t81LyKiggZY4RvM93nFCS3+bZd5QFrTn+2cMUGLVEd8mgojDMRzR95vW9ELKF+IHoP+YiL45DLdSbwIQNc4+URmm3x9hdBkuCyf0/VFo5Sf9gYEOE44Jd2mvakv9dyylfvyQuqwM9Fpc6NfpUUAShkmkq7gzSw
 49ptP8Cb
 vA3nztLPlJPTfWkv4irxwXTC56r19k5D9DvVKVdxD3r9KUA8VoZ8PlCdlmjDHcwzKuUAmYVK4n5+ZZNlnjgxrioMGxpmj56+2bGPZS2H3Mpug2YZSJW4bMmCEjXHGeEE4znAMVxwlIxNVkTu2QyP92gKMZUNXT0137rcXumH6EO/gIV+8PworiDoPdrUp6nOfaISeMUxvBwVYHgDQO8XUKPtJKUx/Nb/pbgRSvYGXu8gba1QGZwtEu4/CnTCFFf5XdDNu7fRQdBA78hO6VwKYxsRsBa0QfqghkD9bpi+DSFbjN6EZKBrSJgxLrsJvj6UoJ+MhV3hv79w3ilkImEB/4FZkP4NDOS7Y3dPJLBdqS1pg8rDG7BdwsFByqloAxXBDNOcdxj/4fTUFgt4m/f1eqUfGdScPA6CV7oTYSnjpCh7KtK8LwxVXbZpBoQU8sIGcDozNO3ENxZIDjP3ogBUzNXpZ9uawrjnqmjuk+TL7+SaDi8cdVbev6+GDTPa/zJ7o9PaUhLJeKrXEYNq6Y2m/wHhQVuI6emeTywq6XesX9IBiJIh1PZZnpTGoMhjGxaW0wYzl2vWV3qJ6So/PVk9L7wNBFxddRN6PL86KdOVYu79PGUjcdGvyALfuFlZLiqP6to2MrNatgMxRI0C+OjC9BptDOaEA85Qj+FldalPLlI+zD6aGZ+sJNMv5mROoJCFhCp3wiq2UQVGZRw9+0p4vAyh9AWwV9hWmA6V+V5093h0FGb5RREi+obvdPk7s2NFpSYAUcfz/4BD16HCYQpSbnOYxY5OdhkHDlKfb4d2EOYgb4eyIxUvnh0fKEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 15:25, Zi Yan wrote:
> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>
>> On 7/30/25 14:42, Mika Penttilä wrote:
>>> On 7/30/25 14:30, Zi Yan wrote:
>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>
>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>
>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>> return true for zone device private large folios only when
>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>
>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>> entries.
>>>>>>>
>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>> code is used with a new helper to wrap the code
>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>> folio.
>>>>>>>
>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>
>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>> ---
>>>>>>>  include/linux/huge_mm.h |   1 +
>>>>>>>  include/linux/rmap.h    |   2 +
>>>>>>>  include/linux/swapops.h |  17 +++
>>>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>>>  mm/rmap.c               |  22 +++-
>>>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>
>>>>> <snip>
>>>>>
>>>>>>> +/**
>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>> + * split folios for pages that are partially mapped
>>>>>>> + *
>>>>>>> + * @folio: the folio to split
>>>>>>> + *
>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>> + */
>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>> +{
>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>> +	struct folio *new_folio;
>>>>>>> +	int ret = 0;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>> +	 * private pages, this path is executed when
>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>> +	 *
>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>> +	 * and fault handling flows.
>>>>>>> +	 */
>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>> device side mapping.
>>>> Maybe we should make it aware of device private mapping? So that the
>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>> 5) remap device private mapping.
>>> Ah ok this was about device private page obviously here, nevermind..
>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
> The folio only has migration entries pointing to it. From CPU perspective,
> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
> folio by replacing existing page table entries with migration entries
> and after that the folio is regarded as “unmapped”.
>
> The migration entry is an invalid CPU page table entry, so it is not a CPU

split_device_private_folio() is called for device private entry, not migrate entry afaics. 
And it is called from split_huge_pmd() with freeze == false, not from folio split but pmd split.

> mapping, IIUC.
>
>>>>>>> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>> Confusing to  __split_unmapped_folio() if folio is mapped...
>>>>> From driver point of view, __split_unmapped_folio() probably should be renamed
>>>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
>>>>> folio meta data for split.
>>>>>
>>>>>
>>>>> Best Regards,
>>>>> Yan, Zi
>>>> Best Regards,
>>>> Yan, Zi
>>>>
>> --Mika
>
> Best Regards,
> Yan, Zi
>
--Mika



