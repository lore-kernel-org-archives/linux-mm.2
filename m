Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D421CCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 05:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A488E0002; Fri, 12 Sep 2025 01:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B058E0001; Fri, 12 Sep 2025 01:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0028E8E0002; Fri, 12 Sep 2025 01:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFB8A8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:38:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84E4713B8C5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:38:44 +0000 (UTC)
X-FDA: 83879493768.08.14EAB08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A4BE40002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:38:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/zlw6hl";
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757655522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/fMTw17wcHtqFRGn0LVfXt45GBXrdFjvwip8q4HpKI=;
	b=8WYNFdJtggb9FXXnR0n2mLXNKQvVVgvtZTUjDl6nc0Q2Ofh4aFzfyxnJk6G3uDe1PmuVbd
	80pHxK5+1AM0Ag8QWHY+5i1zQtBxdkeM7oH205KcGrDosEmV9Frols96hGINq+yFQNVQyH
	zIwOzFppZHtn+SQkyUlN291tBWxLGeY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/zlw6hl";
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757655522; a=rsa-sha256;
	cv=none;
	b=1DaA+fFcPN8TKPk0a63OEGbAlvBDrd7GXMrsozeHGffpKzC9aA+w/KMlMjiA0aej3ze7Dr
	ljrMdWfOKRYyOEazoC12nn7xH+6zbHnVP/+j8bXJLS2LgOSRm4039jkpWaGHr46rkWW4oa
	LcGvLzlT4Tvn34j7Rc9gdkvn2i9hcu8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757655521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/fMTw17wcHtqFRGn0LVfXt45GBXrdFjvwip8q4HpKI=;
	b=E/zlw6hlB2dP8QeBk2QRA35rP3j1wAOYNCd+1OHzaL231p+kkRi8PpxMSHCqi9fJ7W3Ix9
	txGFKFP+28knnoZ6gR6W3b0gsrVih7uA3i3BVANSp4Y86vMuZqSKqepz/xg2vFzEPbNd17
	OMyZDXB43AyvtSOQZVBTh+UztFwbOk8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-9BU8izxTP8WC5YwrpQukDQ-1; Fri, 12 Sep 2025 01:38:40 -0400
X-MC-Unique: 9BU8izxTP8WC5YwrpQukDQ-1
X-Mimecast-MFC-AGG-ID: 9BU8izxTP8WC5YwrpQukDQ_1757655519
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-56089d79c97so1034591e87.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757655519; x=1758260319;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/fMTw17wcHtqFRGn0LVfXt45GBXrdFjvwip8q4HpKI=;
        b=kOGj4hu0mtJvQrmHvsyCUSG8qScH9KSi+9JhU/lI7CWFKEsg643qUF2UNaD4BQ6uqu
         Hzz0VraQUnHohMTLTx8yt5V3nPTCntvZxNpQqjOIWtZdEIRFXM5iWPVeV/Qk765qrNG4
         t2GKhlBkmGyQtwJ+e+U6c2BhumPb31v0TUIK3SiS5K1VYRX1PmOYFR/1Lv176zL8ngro
         F+YIgiOoNxzsZSKtO932wu0Zg/a7YcuCaSE8bOeR74NEbnH3RHKEnZ2EIF6FKzrh5lYa
         msi6pBZRyICEPUDXQbzjnW+aSoVZ8gZdUCLmrXRLwND9aq0IffoPDi9ObhZfjXSrH5an
         X5lQ==
X-Forwarded-Encrypted: i=1; AJvYcCV828/V+vEv8lJAZr26v0n4IZcvxqliN0hXzpfgAWDcbWSWZyyLqwQmIt/1j9980oeBP8rh6rNZ9g==@kvack.org
X-Gm-Message-State: AOJu0YwQFjCHqeiUB2gWZD+JHg3FMFKTwcWk2a8SohXKz4D5YMRb+rAW
	rBj5WM1UI3EXqGaMbe26ptKyahy107Q7Wnz+PwmSYMXxBp7Jso4Z5nhGiT8/XSiC95HNWIAvJ95
	HssWDPN/bF4n5Prk+U4blo3fuJXedrRCN47dtofHE0mN3gr9VPuk=
X-Gm-Gg: ASbGnctgr1duWv7FjzFHv6BX/rn8CMUVkc1Uj5SXaldAbNh00rdFjwhVa5H0Uf66RiO
	bh78S1lWeUphxPCHvEhm+C1nLGkJYYzST4JPzv+H3/D3arTeDO/cpcGtLxg6EnZ5p15L86zHmeM
	fBkbE7OBm/NP2TWd2UTRwlej+bKNBL04lQUIh9KlRgRPr/X9jS5h6cR8G/ixknI/zI1MO34zbOB
	SpS/FCh6hg/GjOAttxbf/VQU6U8pqfQ7raHPihXpaubMKpZgLisVTOYx2TRo62W8dGKCTI7SYvw
	F9bk+U1lbmkmBbWZYiHzWWpP4q5LTwmza01NQkiIamsljgoEuPBhoUXm2/W5Ocr1sjwpWwE5WAs
	lkPQe3S03ZT0yBcxMrq0nRcPq5+SGeGqXRMDOS8Uukedl8Qib37eY
X-Received: by 2002:ac2:51d4:0:b0:571:75c8:43a5 with SMTP id 2adb3069b0e04-57175c845b8mr65109e87.1.1757655518532;
        Thu, 11 Sep 2025 22:38:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe3otVU1/RsO3+BWrCGouA69nfgwLCHLM+77KekXiYcNhrEbv3mMPoDIbeIVC1KQsturvUHg==
X-Received: by 2002:ac2:51d4:0:b0:571:75c8:43a5 with SMTP id 2adb3069b0e04-57175c845b8mr65076e87.1.1757655518018;
        Thu, 11 Sep 2025 22:38:38 -0700 (PDT)
Received: from ?IPV6:2001:999:408:6576:1142:7350:b6c5:671e? (n4ctkw60s7hbahed3xa-1.v6.elisa-mobile.fi. [2001:999:408:6576:1142:7350:b6c5:671e])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e63c63cc6sm914214e87.66.2025.09.11.22.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 22:38:37 -0700 (PDT)
Message-ID: <06a0e258-2c68-43ee-ab53-313a13ed0d68@redhat.com>
Date: Fri, 12 Sep 2025 08:38:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 06/15] mm/migrate_device: implement THP migration of zone
 device pages
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-7-balbirs@nvidia.com>
 <d35eea42-ed32-481f-9dcf-704d22eb8706@redhat.com>
 <49039b9d-4c42-480f-a219-daf0958be28e@nvidia.com>
 <4cc2ba18-e7de-448f-aaee-043ed68dc6e3@redhat.com>
In-Reply-To: <4cc2ba18-e7de-448f-aaee-043ed68dc6e3@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _gcEWDQKSE421o21WfaxaUN0IGq8n96jMQGCEtzxl8c_1757655519
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A4BE40002
X-Stat-Signature: pa58iddo316d67xc97ix8wejt8hz3ean
X-HE-Tag: 1757655522-973881
X-HE-Meta: U2FsdGVkX1/AC0jbJHc1A1aMsgjRSGWkVgG87zVN5aDi+czIF5oeSp0ua5T+lckH5habM/vAyDhwj4QEarotioYp5+ck9fhmgFWEYG5JGL7sdpHP+JpWbRPwcDk3G+oYfipYrBZrwgy6pe4DY99mSRxCYBvAZjaejESQ5z8fURcCCICJo2qrSrs5AP00LafCqHbjUgI5rxkjHUKCCJ6KAnLOXCmrs7ZMpGbNNcHAlBwo6cm4Q9y/6JPOGw+IVctBDSEB49vpKwpTHE7ZYA4zZ4qpc+3iIRxDs7SjJvqkBF6cPxi15sXpHkonxUw6jCrMvfnFXKjlohV+QMMbF1JBTzzsbcCBiQIWT/WTi3a42IghUepF/kzeA85cirlo/uMP/FOeCHy21PBlCHRwqmpBO7voTy1YGYG2m2tFz4zAIVdmG0clgl+mFVMjR3vK0NYR0/tBfWhJyJwaqExY+g8TnxpWITgeo8lNH0FHWrT3AzSO6Z4oUuUJAB03P3x7+7SmVO9BTexijz6NnouPbTjYNEhXMjIDGmfn9BrWRCyYhJw5V6a2Gp0rmKryu9f9CQaGFg3pEOAKpwqqoAnbr6bqjZehkcyqNzYLg2KfQH/MGFsth1BZdVLvdYyG4byED2BA9u14/UcqS2ng8oi/23Qs88mrXsKuoMBoT5aaLfrIEWhgAogBernWLmcQL3hOTAXW131nwaUWG4JDwbmGiHMCUjfX/wy0EGLufb2Diuz4CgZJfNETYIgQuRJ7NQqECzrfLUhIr7AgEjbjiu8n2WQGDQZ+eG5ZTgIMjjJvf2eWHpcjjrDCW3BTPRnE7wB7esPCKodKf2zsPHEtugb8FKu6ALhT6B6Cyn5tSVHB/y4pc2zBMOmtmiwLHF6RzXF8ZyoQIPNjAW1BoNfdx/CJnRlioYB3ZUdfEWsRZPTTYvKeyxhCMj2DD3nD+Jl9UTrw3Wz3VnC7WetP7IbSGwZ0f7L
 wRxcLjKm
 wrWDXEjE3996ZtkOnoLvrHZJn67u/qYjp2PkjNTo1MXlJrtqZUZgE1HYYrS3SpYXs73JBXiVKCja2ZA/5S0PTiI7rh83PATWJtrF3Ie1vTMZS/mP3h2LKGsC6b0TQ5/CyHb1f14qgcf2EpQGadhlLyTyrYCs9E4L5w4LctUXbcd6Jc/V4SlwnGVQ1n2eAQHtjykfCTVrd6tnH5uJ3p4aRa81WyRnsXnG+Nrd/dFC6u2SVoKwptyLNeyzucgZrB0YE/lUQ/oCVfyTN6hKAbK/BYNN4Hao8roUnb0ZfwmXuXVXqFEXl9iSGJuRKNUMeKF8JVjMFwQ+yslU5KKs6oibcW5Vom6/AhKKXvi6l6pmJ3nl5WGchc4Ui14+hz/w0ebpFQw8B0IImf2ytoxTUniQoRIhlOjHVzvrGynmrWZNe/oFN2D9JT9mAtfa50O7A2Z7721U+0gIJ79ET/VWb4sArCQA79lCBi6zYkrxQlV77uGLLe20/bKAhtwBFSFq3j/K5bRJD2+2/A9AhuuJ4x2lyHKsbbbqjdS98BL86796BVaqBy07QC/hr2W3k3BWGUqkdWIrdyV1eI7eYrwrStI//h8yOcgNaI1kDV6iCrys7Vk+YMUrPZ/XxPiIk/rAdyPHrlsnUzOVJcuXbLXc2kgbBYPvEMFcT+OPZYNWxMi9yQXXy9NfodLzN7xfVRs+CRkXo6ZFVMV0hRIlAK8VSacmI0wP2RgXQIJJZ8HPXm4Nk/jsppLIeGDP411Xp7+8hhF5M8tWJdFMy7myT2U6XsDynE14P1P/dmM5jIKHnqb17Wclfxl2Jgr7z9RbRi4umZVI3kUbNMhzCfavYsc5qjBEdonh3WJDHk3mciUVA/lCv86ov1Dqk/EK71W51bT3ZTkI7FR99NomapsXaD7OzVJajMK8Bst85IBzatft+hjnrdt72N3zd+RvNxwLp/gIK2xPb7SU9+ppTvP4TKpUPhUxa+NlpvNTE
 bVDM/XKN
 ie2f3cb+xVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/12/25 08:28, Mika Penttilä wrote:

> On 9/12/25 08:04, Balbir Singh wrote:
>
>> On 9/11/25 21:52, Mika Penttilä wrote:
>>> sending again for the v5 thread..
>>>
>>> On 9/8/25 03:04, Balbir Singh wrote:
>>>
>>>> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
>>>> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
>>>> device pages as compound pages during device pfn migration.
>>>>
>>>> migrate_device code paths go through the collect, setup
>>>> and finalize phases of migration.
>>>>
>>>> The entries in src and dst arrays passed to these functions still
>>>> remain at a PAGE_SIZE granularity. When a compound page is passed,
>>>> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
>>>> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
>>>> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
>>>> representation allows for the compound page to be split into smaller
>>>> page sizes.
>>>>
>>>> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
>>>> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
>>>> and migrate_vma_insert_huge_pmd_page() have been added.
>>>>
>>>> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
>>>> some reason this fails, there is fallback support to split the folio
>>>> and migrate it.
>>>>
>>>> migrate_vma_insert_huge_pmd_page() closely follows the logic of
>>>> migrate_vma_insert_page()
>>>>
>>>> Support for splitting pages as needed for migration will follow in
>>>> later patches in this series.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>> Cc: Gregory Price <gourry@gourry.net>
>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>  include/linux/migrate.h |   2 +
>>>>  mm/migrate_device.c     | 456 ++++++++++++++++++++++++++++++++++------
>>>>  2 files changed, 395 insertions(+), 63 deletions(-)
>>>>
>>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>>> index 1f0ac122c3bf..41b4cc05a450 100644
>>>> --- a/include/linux/migrate.h
>>>> +++ b/include/linux/migrate.h
>>>> @@ -125,6 +125,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>>>  #define MIGRATE_PFN_VALID	(1UL << 0)
>>>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>>>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>>>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>>>>  #define MIGRATE_PFN_SHIFT	6
>>>>  
>>>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>>>> @@ -143,6 +144,7 @@ enum migrate_vma_direction {
>>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>>  };
>>>>  
>>>>  struct migrate_vma {
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index f45ef182287d..1dfcf4799ea5 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -14,6 +14,7 @@
>>>>  #include <linux/pagewalk.h>
>>>>  #include <linux/rmap.h>
>>>>  #include <linux/swapops.h>
>>>> +#include <linux/pgalloc.h>
>>>>  #include <asm/tlbflush.h>
>>>>  #include "internal.h"
>>>>  
>>>> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>>  	if (!vma_is_anonymous(walk->vma))
>>>>  		return migrate_vma_collect_skip(start, end, walk);
>>>>  
>>>> +	if (thp_migration_supported() &&
>>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>>> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
>>>> +						MIGRATE_PFN_COMPOUND;
>>>> +		migrate->dst[migrate->npages] = 0;
>>>> +		migrate->npages++;
>>>> +		migrate->cpages++;
>>>> +
>>>> +		/*
>>>> +		 * Collect the remaining entries as holes, in case we
>>>> +		 * need to split later
>>>> +		 */
>>>> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>>> +	}
>>>> +
>>> seems you have to split_huge_pmd() for the huge zero page here in case
>>> of !thp_migration_supported() afaics
>>>
>> Not really, if pfn is 0, we do a vm_insert_page (please see if (!page) line 1107) and
>> folio  handling in migrate_vma_finalize line 1284
> Ok actually seems it is handled by migrate_vma_insert_page() which does
>
>         if (!pmd_none(*pmdp)) {
>                 if (pmd_trans_huge(*pmdp)) {
>                         if (!is_huge_zero_pmd(*pmdp))
>                                 goto abort;
>                         folio_get(pmd_folio(*pmdp));
>                         split_huge_pmd(vma, pmdp, addr);   <----- here
>                 } else if (pmd_leaf(*pmdp))
>                         goto abort;
>         }
>
While at it, think the folio_get(pmd_folio(*pmdp)); is wrong for here,
we split the pmd for huge zero page.

>> Thanks,
>> Balbir
>>
> --Mika
>


