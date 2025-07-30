Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD47C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 15:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301FB6B0092; Wed, 30 Jul 2025 11:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263A06B0093; Wed, 30 Jul 2025 11:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BAC6B0095; Wed, 30 Jul 2025 11:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 000FF6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:40:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A12C8113E30
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:40:27 +0000 (UTC)
X-FDA: 83721342894.22.F958A62
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 34B2D20017
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:40:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d/XgFRyr";
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753890025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXVJcyzQitkg69HpKmss8HJpY0HtUIPZr8ZaGUiNEY8=;
	b=efkVINYxnJdIbEJVBNh656R2m7eHA9GgfE3s/vpKKDA1KY788QCQPQmIUEyzMiP1cuZH9f
	UIYtxwbuzCACxkZrpG+VyVGMH3BUU6356EqSUPVGV+B/O1LXj1bB6JZLGygBdqoN2sb47+
	D6RRhDjhTYuBnCqfvYSq26qzUS9Lvg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753890025; a=rsa-sha256;
	cv=none;
	b=7U/y9RsnwoQ/kcx/9FXscoJ1vUcqsA2r7zJxrN4kHMN7wm5E1JUL7bNWNzrRB3+lYaxjsS
	B/jazYWg4R83SWebdYnE2jatCmRiIYsAJ4E6nPRwhN7dgOFJVKnanpcV0YhwoiF5HiONFL
	sasGvgdpSuhNxZM9f8nnriRweb2vPpw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d/XgFRyr";
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753890024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXVJcyzQitkg69HpKmss8HJpY0HtUIPZr8ZaGUiNEY8=;
	b=d/XgFRyrxEcONLXWVi8TUr8Wvxj5FlXancNQ0BNSsaStz8jus5KmoUpp5rf37g7JNmfLL1
	bNTkGhZqJdioQZfPp7a+VkvLT5XhgYMYI1AxChcnpFteNsfClyMzQEUxA8qSVGJwAGrnr7
	VfghjLoc+xJ8enkfODr4N2n+e+3dvU4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-Hkw5sfkkNuevFQTYhRjVwQ-1; Wed, 30 Jul 2025 11:40:23 -0400
X-MC-Unique: Hkw5sfkkNuevFQTYhRjVwQ-1
X-Mimecast-MFC-AGG-ID: Hkw5sfkkNuevFQTYhRjVwQ_1753890021
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-553a89531fdso4736791e87.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753890020; x=1754494820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXVJcyzQitkg69HpKmss8HJpY0HtUIPZr8ZaGUiNEY8=;
        b=m/RRWFqwwVhKE6qujC8J66IyQjIaiwwgmnkzif1tHO+ai6gvxPb67K5dNnqLoWrApu
         ZPiKbd3cvkZu7Yo/c6Xd2stwYTGd6pdtDOaFMNy8/C3wW1JCPybShv3qgGnDCQv9RHI5
         gpabhm/rHFLWCwJm6HKPY0hAtxJe5U6JYR83OQEy/AMn7I4whrWLwb15sN3UCgEUftFI
         LIUjdhlZPc+QfRfBpV/AprawMEdaqgO/O5toUlSwBhXOqaxPr97XrJfGA2MI+0QbwWVJ
         1JFZp/yYZLX6vrg1l8jQwAy9Jw/GhaqhluXxTkUpODJgutc0fQg1rckYO2Xe+S2iH6r2
         CM0g==
X-Forwarded-Encrypted: i=1; AJvYcCWIAlG2gllNqCLJa4/Wfrv5HH28G3FXlMg6WdM2yWHhxYR7C3n8O4kC4RX0GI8M/p98pvcnwYvcqQ==@kvack.org
X-Gm-Message-State: AOJu0YxrhPOZDDySMLbn8xf8wE1ZIZ8Dd2scj54UTDHhKoxPjD0+l4iw
	xHlJj21rjY2RBME6mIaqfosc5nRzSSsc0roxuqbzonL3fo2LiWPZthhWJLx2F80EpLxJUoeinbR
	UN+QFbsH3h2GsPioDV7ofsnkM1bfHTsUtK3L6y8LAJdLB2jlyVrQ=
X-Gm-Gg: ASbGncs95sdXphZ0bW8psblxzBtOiLQKsht2VocwnJPgvbDdtMTgz9XpsLbycGHwjty
	WHemj0rgZXQNd0C3EgKDyhNITqKd2CCw905IIuYY8L6RkIH0Q62LkU0AXBlD6UdymcQdglcc/iw
	TyNCNvSNmdp+YyRCo28A2rdzZk7gyE2dYuOhkagQApNMJC93vH3v79LD4iq1PN7yY/owg0GDnyc
	OZclI35Woy0iBcZ628I2r9xorxLtFQGvhxi7y0SZNwc29bI+nrP9CsP0bjknuZjtGWJAnWqh1gq
	kQRtAgYXfJRrkvJV+vTCFLiYtJS9+0ZQV0AtxJOGCRWB7XGYBqBB5xxtV5hKLNLq/g==
X-Received: by 2002:a05:6512:1188:b0:553:2668:6f34 with SMTP id 2adb3069b0e04-55b7c07f9ccmr1183028e87.45.1753890020330;
        Wed, 30 Jul 2025 08:40:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhHAkbosESgOHtK+TLbzZRkJ0+s3tZB6YDIybLt+V9RyMPuHRew80ikAzaLwrE9zZIHOcTgA==
X-Received: by 2002:a05:6512:1188:b0:553:2668:6f34 with SMTP id 2adb3069b0e04-55b7c07f9ccmr1183009e87.45.1753890019823;
        Wed, 30 Jul 2025 08:40:19 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b6316d9bbsm2197627e87.9.2025.07.30.08.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 08:40:19 -0700 (PDT)
Message-ID: <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
Date: Wed, 30 Jul 2025 18:40:18 +0300
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 22vGqDYMn_38f3N-ZOm-ckmlDIR2Kb4E26FPVkJUWbw_1753890021
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34B2D20017
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5ugxksy8mxdxcwtyutyts6kxfjpir9pi
X-HE-Tag: 1753890025-510426
X-HE-Meta: U2FsdGVkX1+6Xx4Aci/A7DyAfiPhDNOHFJd5D95JTs7jLBg+rjJU1tMTedth3QCMonIfEmbXbcxu+K55FcDRCD/hCvwSQexovlSgiSSpF94zgDoL+TuX1jEOyos8rZmZoNj7SdSmEEqrGReNnmD4IjLZogCZIUDEM62e9Zp+TQ55H8pNy9bY/3BKT4S4/EDmgf7yS4jx9AeW/A9f0Q5Z/5S2jp3e7RAkvSNhZUUWDu/CfSPGXd/+FGQz1dOfsomo5uWR/TokcNE7U1WV4J/mGHir9Ff6Qm2rwSXcQNhB1Rr6kBmipFpZRD6irmAH/oyu8+sPQyRFNg6gEG1JUbVgafZRgWou8ZK2NF9iOoxeazz9wA7JDpojqhl1KMBof42Qm1f8vyqSrr4TyQdCDA0TRI2CdjjzB5O0RF8X6+32H4PT+wGmDsLDjMvvJNrd/38+Gja6iBClhKtUFrnT2z8mR09Z4hC4ebLH2kAFKHTtxIIzw0PB46/ed4+40od8/2tmGbxtMNIcFgkvWVWS8yHsC1330kkqf5cWgTP+dy1VBEhM8nvv3K6kNon+EP5satxeDuCvbvx/4MSLuWnlnxhQpNQiteOso5XUDBTSFPZ/hJa6+5M1AuAyGdxCxHCar/AjfZd/OHWobUXON4991fFzjpYqxGfrp+w09UK511meyH3z9NDxqz/E7vBUA4jNcSNXLghtGTfXuNW3HCrNnI3c8IlGfwO98Ng48ToTgaX2mrzr5zRk85lipDvga6b0kR/F54FdGH+J4D3nBKpAx8O7v+6Rk6dWTLdgKr+tYJJSeW9rr7yxtSRECPZDG2q157PTN5FJcBXoQIuRoO5vc6eoUjz2+iLEtDhg3M+z3Cc14Ozb0103oXQQJzAq0hB+bkH5/U4LAVIJSSfdUq8wIEQBbhPIPps88+uS2868xVDNi5WRAgTz8/sjKO69+RBajr6W9R1nV2vPMboSY7g38o3
 HD18ve+r
 5NoODgIP7Wd0yxk0suw4FHfbt19yIqoqRR3M4CVYgPO5feHeL9msY2Gl46+BseEHhZcZsj7fYRrVH0zOhGZ2T+laUZHbtufuc0QeZsXyB6lYgvPDXS7sOSa1RXSUUkwxGyoCkG/CLvyWn4UwmST9xZD0ueobGIyDpTR2AaKPnPOQAT13rHFPsxktQOlSRmBQDMVYeyt4bvr0EJPHgZIivSgv2OA+NPQbyDgb7ZJXggkZ0tg522tQBA4sNK8+5LN9kEMLx03CLsolgbmvEBEUuVVue9itj7AHHM7oH9M9w7HQLFM5juXjZOfZ62ud0ksAUTCF2mIuiwk743QetSRtG/b1jSjzqSnej7l/MQU7t/0dBl830+PILpptGz27KGKtXk+N+3yi9wZMk5pMmYcsWR+XLFu77j394+DgA3Wd/lsXoFtYCnM2jIfKwAnlSzM/hlpvOnPOGacscYXPY2Bff0Voedd9R+MHEkbgSa4CvXGx71ujwOW8hC70MKGUtXQjGxlpmTqj8d64HfjF+5C//BFfA3oSn2CL0JLZ95y83xxztBhUw2Nvc2Gpi8txdehzngR3i0BB/pVBiKFIy4Znka0Xyv4Yk/gOLp2vJVU6sv7tW3h3bCzJuSMm9AYgcgXOyWu2Hlu7wIc29lEJIox445EUSyrBuVBDqDZq90HtPjqqM9sDc3i0gTakHh5tleubHEdcJTaYg16NITT8lZfOG8GDypUz8/iwSx78fjHsxjUOtsOgGtL9TO01PEapkxVpbbXlkDqdNO5ClfdseQm67u5BJ8J62SP5lSC1uumu3PXypk/VYt2KmSFtTxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/30/25 18:10, Zi Yan wrote:
> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>
>> On 7/30/25 15:25, Zi Yan wrote:
>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>
>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>
>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>
>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>
>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>> entries.
>>>>>>>>>
>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>> folio.
>>>>>>>>>
>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>
>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>> ---
>>>>>>>>>  include/linux/huge_mm.h |   1 +
>>>>>>>>>  include/linux/rmap.h    |   2 +
>>>>>>>>>  include/linux/swapops.h |  17 +++
>>>>>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>>>>>  mm/rmap.c               |  22 +++-
>>>>>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>>> +/**
>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>> + *
>>>>>>>>> + * @folio: the folio to split
>>>>>>>>> + *
>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>> + */
>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>> +{
>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>> +	int ret = 0;
>>>>>>>>> +
>>>>>>>>> +	/*
>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>> +	 *
>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>> +	 */
>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>> device side mapping.
>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>> 5) remap device private mapping.
>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>> The folio only has migration entries pointing to it. From CPU perspective,
>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>> folio by replacing existing page table entries with migration entries
>>> and after that the folio is regarded as “unmapped”.
>>>
>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
> Yes, but from CPU perspective, both device private entry and migration entry
> are invalid CPU page table entries, so the device private folio is “unmapped”
> at CPU side.

Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.

Also which might confuse is that v1 of the series had only 
  migrate_vma_split_pages()
which operated only on truly unmapped (mapcount wise) folios. Which was a motivation for split_unmapped_folio()..
Now, 
  split_device_private_folio()
operates on mapcount != 0 folios.

>
>
>> And it is called from split_huge_pmd() with freeze == false, not from folio split but pmd split.
> I am not sure that is the right timing of splitting a folio. The device private
> folio can be kept without splitting at split_huge_pmd() time.

Yes this doesn't look quite right, and also
+	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));

looks suspicious

Maybe split_device_private_folio() tries to solve some corner case but maybe good to elaborate
more the exact conditions, there might be a better fix.

>
> But from CPU perspective, a device private folio has no CPU mapping, no other
> CPU can access or manipulate the folio. It should be OK to split it.
>
>>> mapping, IIUC.
>>>
>>>>>>>>> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>>>> Confusing to  __split_unmapped_folio() if folio is mapped...
>>>>>>> From driver point of view, __split_unmapped_folio() probably should be renamed
>>>>>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
>>>>>>> folio meta data for split.
>>>>>>>
>>>>>>>
>>>>>>> Best Regards,
>>>>>>> Yan, Zi
>>>>>> Best Regards,
>>>>>> Yan, Zi
>>>>>>
>>>> --Mika
>>> Best Regards,
>>> Yan, Zi
>>>
>> --Mika
>
> Best Regards,
> Yan, Zi
>
--Mika



