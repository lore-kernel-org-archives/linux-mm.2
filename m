Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF06C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 19:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6066B007B; Thu, 31 Jul 2025 15:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786D06B0089; Thu, 31 Jul 2025 15:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EDD6B008A; Thu, 31 Jul 2025 15:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51D176B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:18:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7FE5160A3A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:09:53 +0000 (UTC)
X-FDA: 83725499466.27.4EEA02E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DCB540011
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:09:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJ6vpm5+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753988991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m456apx6lHPosIGF2sYNtRsOfQ2+GUs03b3NxC4V0Rs=;
	b=VIp59dKBKaBrP/kTT8mh7U+rZtTwAet0cUZEoUbKKny+QAxr9Tk4TbXl1PGOXnnHBPXzkn
	NAZvAihcBWWcwyBmNQqFXJ1bV3Wg5OEN1fKzbUz3MPEQpH0SC3RDkyUbgvQweG6PCeUFKg
	JD9AdX/PMLHindD/W1/bGqL1u5fklHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753988991; a=rsa-sha256;
	cv=none;
	b=pBH/Q34fzt+YmnnFl5241P8EZMT0NUY63qMjRATpC6HdoYpA9xLK4GGxqLRE+Gp4x4l+s0
	mPPaNOMszuq9EH+6x3sNTPHUVlXNjGxwqIjrSTtKhbGoACToon1YcgY7AQlupny8PCR3Z+
	ZZ+p0KPASG8KHT8m8hwaOmUa/4H/ARA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJ6vpm5+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753988990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m456apx6lHPosIGF2sYNtRsOfQ2+GUs03b3NxC4V0Rs=;
	b=eJ6vpm5+s4GE4YPzWFgFaTJkzwA10povrN+B/Y7to/rpuJFtzQXpOceZ/VzCMMDWdLjtJl
	4CYFyZi3pqDSEVuR4u1ZApZsNoHVBbq4TF6j106PIXplXfkS+YAHOtCPTKI59CbZFwjYDy
	3mXsS9cqXId5nAzrtZsjokeNWBdvRX0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-5yNQZzXHOpyV88NyVew6uA-1; Thu, 31 Jul 2025 15:09:47 -0400
X-MC-Unique: 5yNQZzXHOpyV88NyVew6uA-1
X-Mimecast-MFC-AGG-ID: 5yNQZzXHOpyV88NyVew6uA_1753988987
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4538f375e86so11296075e9.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753988986; x=1754593786;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m456apx6lHPosIGF2sYNtRsOfQ2+GUs03b3NxC4V0Rs=;
        b=D63NCJKLEj+NJP7Z7U4v6q8lloolNWYvhi1e1OAI4QhfzQXFfuBd5211gNm0o2Hb50
         VG8DencgAZPWxUw5LcG0sW1ukoCb3X2aYTe1P7dyOGuZbSwJa4lCvGkf2njDuoPuRnMR
         YbhIqw69BJSXDnEEtmtbP/3JQMOn0IqW8Agavwzs4C5YxQzs6jVveJsCwgntq0HA5QoR
         nF217+QyCbJMUaGxHiupYMeaZHEAqhoUQAHJvg/bqccRCM4eDDQF+EsR/055VGDWqF6E
         sK6OrdQK3mok81xQiFFOnYcAtFjQSeVNg+vbJBDXDi+go1xIqwM1kPlKNmaMd6mo4vMB
         51SA==
X-Forwarded-Encrypted: i=1; AJvYcCUqvzjmNW0wYTv4P9q1ns8aZ0vrewg0KamVj6W26FXkaW1QQS0Sf/SxUeChc76TCW/jcYGHMR5JGA==@kvack.org
X-Gm-Message-State: AOJu0Yyy1J6TZYclH4Wy/IljqzWcr+OPIzX+ga6d5/WaAPlyfQ5ubEcO
	RzRX/mkMSxofgIxQ7cEk4vQM9QXlZJSKGwImC30HEPYBTQ7xbEBoltX+YDGmr1yHPkbhNWbpUf1
	T/fdpDOyAd6Om4ioVhwTxdLdrgEoMQj3db4gEeBv9ig3+0oQEoHl7
X-Gm-Gg: ASbGnct4/zIWAmuKf8uNfRAewaRTFGzNrieqSaY44bV1Q5FmNqNbr45UGpBbLFn+CkV
	H7zlFfNgTL8olIsbAfo2/ojDpGHGiOrwoS2OJmH8+1ZcCJRNI39+igHszrzQRe3STI4YLtCC+Ny
	slnZu6//UWTRsRp1jNkCLDg+r47BTAc6NGHErMO2Fl0lfIkesujqAUOs9NsYPa3o9FRmD1ceW18
	BtfMnOZTjFS/ojLnmTwkc27wsPw5qKcFXcAbwWJBUJDK7/eX+OseCpNctiT+C2ZSLk2m9FDGETp
	vSc2x8wSqE7Lq/dbUv102872wQq9/gLTwqfz996+EGmG3OVv6ZoKHZ+5lJXLTNzP2dsth3h4P0k
	hFtmaJ4nj5q+SqYItTxkf+6F5EsEN6brG5rHvJyQVuy7X5Okcvyfo79kTFmGt6z1FWCA=
X-Received: by 2002:a05:600c:1da2:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45892b9e27emr100098525e9.12.1753988986535;
        Thu, 31 Jul 2025 12:09:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/VPoIzJ/0NvGvkSO7m8YY1QgGBsMic0EFvI/odEnZvHl6qdx8sA6nFsaSwjXXrK0MBS+Oww==
X-Received: by 2002:a05:600c:1da2:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45892b9e27emr100097325e9.12.1753988984161;
        Thu, 31 Jul 2025 12:09:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abec8sm3424614f8f.8.2025.07.31.12.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 12:09:43 -0700 (PDT)
Message-ID: <6c85ebe8-55f9-4f1e-8da0-5a3587a047d4@redhat.com>
Date: Thu, 31 Jul 2025 21:09:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
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
 <ce3e6955-4a4c-4cb6-8dca-9f15807b6165@redhat.com>
 <182044F2-657E-4FFA-AED8-225304AAD2FB@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <182044F2-657E-4FFA-AED8-225304AAD2FB@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DNMRi3UWqdm2nIW2Tcoys9Abw4sEtH4v-LUugkNcP1A_1753988987
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2DCB540011
X-Stat-Signature: xupyzm3wesich16858pqsa395qxbtw5w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753988991-40600
X-HE-Meta: U2FsdGVkX18R16V3YiL0gQtnKbceKSILhR9fcaiYiXnQhWR8QhrT5O4tjbF/gxd3rrRsHdiM4k2YIwGxtvN3071eC48I1gAe7KF69VgjWX69/ck/yJeOsHcNP2tiwZ5vCIqwsT3bpKoMw3UeNSu07mUq7Cx0l9vKLCUZ81kOFEegPwV4fx+E/wK+I45TYjRUmnJF/tFJTP4G+SCsvd7tJ7cf+77vdkG5DlxjmKwyi5Nne7iM07sVUmkZw2mvu/S8/iwXhoorKIXZqQUSO+BGofnMIrKgBt+tdCMymAWAoj4XxumIko9Yrd76ucBV0szg0rJMLQyPktsapwfKDn4HTAXG2bCTWU4zymIAhCpKlGDDl3DfQb/r5+h2tli8qXI+S/3emMEvTwQ7fr6geRZOA7m9X9OgcCpGxpli4IHQlZW1ptG65XYOvJeVcZ3xSdDmsFIreRCt3W+Jrp3UKoG57gYYVRjxFTLUAIUCF1dx0KtzcAQfWAVY9+au7pDjEI8FCYNA72wdX/9FdhOQM9d1OaOnSK0LCLm+mJaBoHGHVUIgZrf6b6QqFndcygH33ERk4qbDTeb4/HQIVoWW7W4tgppqRlfDKKxabHUxCsvWp3hFvGkwoAQQBqLhz2K7aKaPbDCpBil/uzi6tO8GxrJa5MfBz1B0MuTms3DKmx1As83DWfOKcjJZnCfrm+PAwUnGwFZM7UwUjln7+kZnivUNenEFhwbtbRNoJZ2bASWeGncSp10R726SXvOqR5ZZtPowisvPZlO6l58POeF/vVY+PALCL3q6WeRsx28UKvqn4/d4B0EKq3UTcbMqDpUIMp5v2ERJx3LgUn9vmpFlSsuZ8GV8BYDq9vDhMAgBAsgI/bOVlQmoVAA5aLITapnchv9D4qxIFhItZpK+cmQv9ghmTfvbqkBDBSRfWpp20XgeCc/fgPQ1omvpJM7AnN6/P1PJ7bK1dxGFw6GAfJ2TF3G
 12VAkTOC
 ukfmlY4LncVj6vUv78RQVLv+7w01G3u2hBgYM+o0kAZCuQTCff4Q7oLqoVzZLIYahnIfLye9BPLzlYXdkp2QFhFjNGoAVEFBb+xHpj4RYHvGg6CD021pgDSzjvvP+GgubHOOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 15:34, Zi Yan wrote:
> On 31 Jul 2025, at 8:32, David Hildenbrand wrote:
> 
>> On 31.07.25 13:26, Zi Yan wrote:
>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>
>>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>>>
>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>>
>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>>
>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>>
>>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>     include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>>     include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>>     include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>>     mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>     mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>>     mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>>     mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>>     7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>>
>>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>>> at CPU side.
>>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>>> CPU unmapped and device mapped.
>>>>>>
>>>>>> Here are my questions on device private folios:
>>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>>       perspective? Can it be stored in a device private specific data structure?
>>>>>
>>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>>> common code more messy if not done that way but sure possible.
>>>>> And not consuming pfns (address space) at all would have benefits.
>>>>>
>>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>>       the device driver manipulate it assuming core-mm just skips device private
>>>>>>       folios (barring the CPU access fault handling)?
>>>>>>
>>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>
>>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>>> someone could change while in device, it's just pfn.
>>>>
>>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>>
>>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>
>>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>>
>>>>
>>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>>>
>>> Thanks for the clarification.
>>>
>>> So folio_mapcount() for device private folios should be treated the same
>>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>>> Then I wonder if the device private large folio split should go through
>>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>
>> That is what I would expect: Replace device-private by migration entries, perform the migration/split/whatever, restore migration entries to device-private entries.
>>
>> That will drive the mapcount to 0.
> 
> Great. That matches my expectations as well. One potential optimization could
> be since device private entry is already CPU inaccessible TLB flush can be
> avoided.

Right, I would assume that is already done, or could easily be added.

Not using proper migration entries sounds like a hack that we shouldn't 
start with. We should start with as little special cases as possible in 
core-mm.

For example, as you probably implied, there is nothing stopping 
concurrent fork() or zap to mess with the refcount+mapcount.

-- 
Cheers,

David / dhildenb


