Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DC5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 01:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2C96B00B5; Thu, 31 Jul 2025 21:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3536B00B7; Thu, 31 Jul 2025 21:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B8C6B00BB; Thu, 31 Jul 2025 21:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 222776B00B5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:16:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE0CB1DD36A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:16:38 +0000 (UTC)
X-FDA: 83726423676.04.19F0BEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3630E180007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:16:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOlnpOZu;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754010996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmKDTP2LCmKxpAdC2A4AhnBImuLDo82eBAViB5J6yPo=;
	b=svxLUnrxHi1zVHEiMazdEqyx+o7fjc7IMycN+jFBC7qAc/r1Tn10trtAB36IKDeVDx0e6O
	T8anHFCfbY5YBwxi3FywZJs8r8L4kC36Rp5muhRV7LBUQ3NCQAZVqfgLAmLdMwcPo5suHs
	0xCDP2scsQ0wI5SWOaryRlaW+s8/M4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754010996; a=rsa-sha256;
	cv=none;
	b=18sCVlakcYVmZYHY7xHQHXngEhV+F+dBEF/fW+Xqmh42Cp0oTWxaLGxejFSsboo+XO+OvW
	AHQ2qLQh1MUNi0tdjgZrGdmgqKSLMna4BcVJHH0Pk+ltwOBpwWZI0BJSSpY7OnKNxxCUsN
	90Avioee3IBhc/Yv0+Veh/WRmik89Yg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOlnpOZu;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754010995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmKDTP2LCmKxpAdC2A4AhnBImuLDo82eBAViB5J6yPo=;
	b=JOlnpOZuDkDeDPXQBkeuVvj9k2Oe540bZ8GBCys4hqAvH0P72uGYVclo3moQGesiALFcwU
	BOAGiPHWhJV+ynkCE2S/R26gQzC+hzbQ+t3mk8Q7KLj6Pjpee1bcrh5AnfNc8qFlk9DnS0
	KGMztMivXEWuJbe6wZXjx/g40lAldSc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-of7q3Jj_Ofy_IO7MALFQPA-1; Thu, 31 Jul 2025 21:16:33 -0400
X-MC-Unique: of7q3Jj_Ofy_IO7MALFQPA-1
X-Mimecast-MFC-AGG-ID: of7q3Jj_Ofy_IO7MALFQPA_1754010992
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-553c6367ec1so701647e87.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754010991; x=1754615791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmKDTP2LCmKxpAdC2A4AhnBImuLDo82eBAViB5J6yPo=;
        b=Fm2EpLlPKosV3DgK3ZBzHZ7sRrlzIzpH8cSy9vv/Gt3VvYaxWZ+11iO9BUoLY/pDep
         PT6JQGIKQR5HxoFukagx9N1p45p89hR9EHeZyvfUyRlsGSV3JAnvdvhImoOQ7ybDY4ed
         v8H/6/TNj5r77dvnBNlx0tv2PiRKCo5zHmxrqWi8PvKoGwCxuirD+P9poSEY9IMJox/u
         pWXfsD351W9Rr/ssMnWME2pEgj7S6YFDYMg/rgS/zuLSwgC8aLDoHcBq4b4XqXRsUfQl
         tzyVZIGmP1yFs3f/5IkcSrmzt0bHL1zwqieSwwewD0/tgD9P/5B3RV7OFghUNwf+CC4L
         2izw==
X-Gm-Message-State: AOJu0YzVjJsqoC5aKPY39bzWqCuHONy5+Ms2oHwri9613En1tD+QgY8K
	m015cgsdq4uz97x9UWGr1Zs8gLRVSUggpjBSxwiHWWR1jyOQM0/AOjFGQTJH1fATvjw44d73bIT
	gpgPtjj+kNML85Ch/SKPPQCIUZ+jQLINVvdY6uZF9KYmc45CkS/E=
X-Gm-Gg: ASbGncv6YXhLlsXHeY9VsOVwvrsGTw8Ni/IdM5MirSdNuLJ631L7XX2riCcZANqmImx
	6z4OanKSANZ1TrBZb1smX61MGOYDfqArTsVoBpkscDhMxCE+sZjBhi6lUSlmb/DgR9wFnkV2jsX
	Hjr2EQf/nWmVlAjoYryoA9kyEwlC3aFD1FHM8XmUh1CWpHiuKswmlyPrAGCdA9JdJ+Vox4D19rC
	xc0znM+iHfiISk9ojOuiB7bJbMtu9wrdZyG4+8AQ/bj9lsTJafWNxcWaDiQnweBJ7GYWlXmFQBb
	2bIUka/sF2sAo4mW4Mfs6fPum/mziVcSi5EZWci6aZMbiVGbpG1US11dtvUu1pLs+Q==
X-Received: by 2002:a05:6512:a86:b0:55a:4ca6:d757 with SMTP id 2adb3069b0e04-55b7c02614cmr3207574e87.24.1754010991408;
        Thu, 31 Jul 2025 18:16:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6R0ne2W8tKccUoWJJ4G6iyMiqk3uthQZecJz66iI7n8/toamcmFPa3PkOZPUcebrk9+ohlw==
X-Received: by 2002:a05:6512:a86:b0:55a:4ca6:d757 with SMTP id 2adb3069b0e04-55b7c02614cmr3207562e87.24.1754010990909;
        Thu, 31 Jul 2025 18:16:30 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88ca314bsm404252e87.128.2025.07.31.18.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 18:16:30 -0700 (PDT)
Message-ID: <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
Date: Fri, 1 Aug 2025 04:16:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
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
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ijSUXK2bSHihDyQrqHDVHtq8tiKsrIeRce-l1LLRSSE_1754010992
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3630E180007
X-Stat-Signature: t7qioag8xwennctw56jo8bjdrtrq5eh5
X-Rspam-User: 
X-HE-Tag: 1754010996-665727
X-HE-Meta: U2FsdGVkX18ozuEZe2qCpaCxoy2NAy1ucvDDBWPEVVdzPH8BZfoWulC/9kY+S9/wOCEPm20spdx29jUp4WjbJ1GKyhUpCMEuwAlOv1Js7lENqnogWGQk35gO6HfxprrAAufz5dm+CbESNo4gVaf8bvojB1wgHArk5NDPbjvVVMvi9+t7lxPvCK2AFl5TJLr1LGn5vkjyf+BkhXIDmB8Z3VaD6h6UKH8pwCC7Z2p8sNcVUXncDsIp7RSbLvSnvgTbcAxzcx37NRXSCvtIRWm7CqXc5v5EAmksbs45KwrXokPGXewRqZ8DfoqKgHqw5kwAvvdUYDZ9xmv68yggw49/7w+ATXPCPti43P+ALQuJTSSLpAs74QpdcajYZHDIH35NPKb1pN65UkwLm8A/81ekiFQeKazp3axbtwrILrEN2H5tCviwiwO4y1JiFsJNLBDBvX/hxLk6BR6T47yHulkNBXDcGHxkOICtoRg0bvJZvJGYzzoxCVG95r3fuYGpaln1e3s+bBzXsXr9YHAlRUDSPRwRgr5MFP+DIcOPNbYynX6nxYzTcREqnFXN4AHyv0UcmxuWZC6EoM+2jp/B6/GY0G/sm+NtjdDD7T432b6C6PCMhxfa8L/FKulTXoMW3V9LfJLXM19rpneh6QLYMuzJ6eyJo4Db/lHTLUGF6xWV6EAmZBZARLY7wVJiMEkTSAiGJBsmw69yhAVWzivaMlcpWRLf+He5gojr5BBAYtIUvcPQfdZO9Kwmpx++j8Dmt2GCpVItrBtOswk4uT+u9gBozkfgzk5f4KECGjFr92Ik6aFcB1CjhKyEeQPIaYgMLRPjgsps4C8JJBLHxAKIrTMWBjZ5OOXNwoGRChGWe9YKTqUAXjuixFO63y8cQrX02gYNgQRvS/mCCV2s1FushBnSoDJO4uyaw5l1OH9lghD6OzZXVZ/e5IaBQHhEn7uo/m0ppqwqOIcB7Wunn1d3O2H
 dRxsLKLO
 sRa5dmVmJFXaNOM332jRLJRboNYGD+RQ0uKYb2Gir8YKjsFePQJYKaH9bOxdhxrWURFTAMaMC6AZQqmNN1d8mtzYnSQSu0lWONFuMlE1utwP7N2dSfyJUvx+HGbxhqDM5xXxmkThNrilUx8pqWL8Up8WmZG3G0J+lBPI8XYjxPOi/88pQcYL01Sf4Pk7DGAOvyjyRqgkJeqaQKMJOjTedSqDGxjWwJe2OxmvJzvQGMJj5DgNE+o9OscaEkPmJyY2qeJuSbrg2Fw98n8iJeLb1MfnoqbV8x+6fQmm8kJ559ML9qyt6umLgdb4jTkCGV5GKUK7MuhtKoIChAlYOww2v8JouH3PueZR0UrnAJiB6Hb/GzNUrLkXtnb0NeIezIOcL7ZL4mhDNl+o/n7Ya5XYasKse2sFluzieoJHDuG92zqUY+HZAuqatPKGVipZzQ2nnDylE/j9FJOKKx1xFFCkc7Dmukd7jmF9OL9sfEh0JaRa4mOa9WcZCprgGGY2bOO0BLuzbMs0ipVUm0oG20av0n9ufeAEMbXKoagtSmSv/gCyLzaRO5U3GxBb0yC6o1s6VDbCq6mrz6fEmuitamsRkzrZz0RslJgUEFJ0lVDuAHkd09Je3dEduJinvqTVHy2CeJ2dlSQDyBlzmYQn0UWw1wsXc7KPhtCUYuTqT0uEfM1tlUAcaUUVctaPyHd3KOtY7kPprXpZcFBlX9RxxtL36TmuqJ6+SrGh3dd/GY05ypN3bQB6NY34ED337RrSqQn2xm89pzl/IGFpcv9f0z3CtQpuoDTz5q6mTS69jVIRGzFizNrXnAwx3Dc1t5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/1/25 03:49, Balbir Singh wrote:

> On 7/31/25 21:26, Zi Yan wrote:
>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>
>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>
>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>
>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>
>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>
>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>> at CPU side.
>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>> CPU unmapped and device mapped.
>>>>>
>>>>> Here are my questions on device private folios:
>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>     perspective? Can it be stored in a device private specific data structure?
>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>> common code more messy if not done that way but sure possible.
>>>> And not consuming pfns (address space) at all would have benefits.
>>>>
>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>     the device driver manipulate it assuming core-mm just skips device private
>>>>>     folios (barring the CPU access fault handling)?
>>>>>
>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>> by CPU and only device driver manipulates their mappings?
>>>>>
>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>> someone could change while in device, it's just pfn.
>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>
>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>
>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>
>>>
>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>> Thanks for the clarification.
>>
>> So folio_mapcount() for device private folios should be treated the same
>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>> Then I wonder if the device private large folio split should go through
>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>> remap. Otherwise, how can we prevent rmap changes during the split?
>>
> That is true in general, the special cases I mentioned are:
>
> 1. split during migration (where we the sizes on source/destination do not
>    match) and so we need to split in the middle of migration. The entries
>    there are already unmapped and hence the special handling
> 2. Partial unmap case, where we need to split in the context of the unmap
>    due to the isses mentioned in the patch. I expanded the folio split code
>    for device private can be expanded into its own helper, which does not
>    need to do the xas/mapped/lru folio handling. During partial unmap the
>    original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)
>
> For (2), I spent some time examining the implications of not unmapping the
> folios prior to split and in the partial unmap path, once we split the PMD
> the folios diverge. I did not run into any particular race either with the
> tests.

1) is totally fine. This was in v1 and lead to Zi's split_unmapped_folio()

2) is a problem because folio is mapped. split_huge_pmd() can be reached also from other than unmap path.
It is vulnerable to races by rmap. And for instance this does not look right without checking:

   folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));

You mention 2) is needed because of some later problems in fault path after pmd split. Would it be
possible to split the folio at fault time then?
Also, didn't quite follow what kind of lock recursion did you encounter doing proper split_folio()
instead?


> Balbir Singh
>
--Mika


