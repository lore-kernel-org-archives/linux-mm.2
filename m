Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C30CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 05:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24F98E0006; Fri, 12 Sep 2025 01:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD178E0001; Fri, 12 Sep 2025 01:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912D28E0006; Fri, 12 Sep 2025 01:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA868E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:28:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2564A160673
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:28:41 +0000 (UTC)
X-FDA: 83879468442.14.8394535
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B361E180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:28:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lh4m5648;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757654918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJ9I3kFrAfuzRn5zG3IfhkcbkFVirVLdOlMEX4ozb3Q=;
	b=rvJ0dMVLsoRG90p5iCpHQG4L/LercLm43awWCmavRCE/1azAQFM+Q2zFy2tnzsuIVI5OnD
	WyVuTBL3B+7yXMwgPMOFSCNTGz3Dmw0oWZAEV4TpOKzC4H4knzCLuCHCElX9rErmwTYWae
	zcA/C6nrxi8/q5zQBQqKqkB5pJgUnNs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lh4m5648;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757654918; a=rsa-sha256;
	cv=none;
	b=pEQVORsGt07s2Bo4qrRQYwoMaPzlZIQ0sxvSoEvvgC5h18akSv+iktNmEuBw/ODvlKAAlS
	jSuLNhk9yj4naVi2Uq/HnIaw+iqVZX4rIOZPTCSPI7EsChQWdyfInLCWdYVjT6HqknethZ
	cO6xWb4wf59ecW60u5bPLJjdnsG8+8Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757654918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJ9I3kFrAfuzRn5zG3IfhkcbkFVirVLdOlMEX4ozb3Q=;
	b=Lh4m5648XNvKQlKdjYrL00gkPUvQtUC9sn5PelqqyzIvEr0gAoKedpxlJ8rkqkFiWtG+Qr
	3XQV9BnpwY9iMQyvTTqlCjX6e7fAmcsEWnCmK33u3kFsAv3In+KVQJ4yjnCkOfy8Nan0GV
	jqHCtZbwkPsEWsyedxHdOo1wTAloAq8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-RWG5iUfzOjO0twY8q-YDxw-1; Fri, 12 Sep 2025 01:28:36 -0400
X-MC-Unique: RWG5iUfzOjO0twY8q-YDxw-1
X-Mimecast-MFC-AGG-ID: RWG5iUfzOjO0twY8q-YDxw_1757654915
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3365be0c13aso7540021fa.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757654915; x=1758259715;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aJ9I3kFrAfuzRn5zG3IfhkcbkFVirVLdOlMEX4ozb3Q=;
        b=IEaQBzY31NoOEH4waGPSypwAy1TGaM5ffPyuUzdU7z78m0vHVyl1fwWwM3xnU4wf3T
         s1ZdEEzEkxi/kBxw8S0I/MovsntKQbHiCr2KWpi50TJ1U5osRTo9/hHtSeLOzMw+txO4
         WcjXXWcU0sojB93+0UmJnALatVy9qT5gg99X53i/6B8I/zzdJBTwJ3dp4iMyApVBjSmM
         AhyPmPE/Ohrd46AMkG9mb+bBw3AH9J3LQMq6oc/ebzsjRPpnQlGqLeX3E6V1NdpE8ppz
         JNtrpJ0q+D/8uOawN9WY0gLoxMZd/LV0HnjW+UvQ4gj7LP+GA5UdxaIMjZM74sIqAiok
         ggBA==
X-Forwarded-Encrypted: i=1; AJvYcCXztPQxmD+cVjtqFL66t8eS30Jzill10A3ry2bUu+ERtQMRmtVZsabPreTeEqv9FwTvOkFsnbP2Qg==@kvack.org
X-Gm-Message-State: AOJu0YwRRPxNwFC0or2WpSPQAbzTBUBwybzxwR3TnA/BgQJIpMoykG4Q
	6nXDzZJ09Y/JP9BoJUvlDk2Pu+6lEvoCgOT0NOsnYdd+uTuXtNj3jDdSzwOMdn1Fay49Dc1JjdZ
	FMF3/jxPQghgI3PfWVyEnLk9YptV2blh7qmGxBiwL/nIX6zLNN90=
X-Gm-Gg: ASbGnctRCaeUlJ3DREy1e03XSura6M+ilrVYvQoKN5b+wm2RHyq8tUZJbCzaGX+FX8v
	mGCZnrVsnaQ3ayk609AJzevtEMOywaWIylKCSjrNRSgV0apbiht7s/F5mrzM/qgj+KXq/ys7yLP
	gfgYI715u6mPRplPEv3XCBFNvVMukq06VDNFDz1yVN/fVV4NURvM6Fw1b5fauxeRfgOdn7OyD42
	knqw2JHVNXqtQXtsUZHhnVgrcSWB6TJw1yaXdC2ocKCyHIUwg6uxNvjOYA4fUn9LVgn1sr1zpf0
	hbbGwIXZ8UwJwtkTZkwWp91uiilBEnHw3TYmt3hSW/7YkGdezWytPM++O1re+urrMHiEyYQA4VS
	kzgKeM59oCbzF9hghDYIx5046UaqmAkhqShlLIeJfiwmyZz98j3Qj
X-Received: by 2002:a2e:be91:0:b0:351:b11d:e630 with SMTP id 38308e7fff4ca-351b11ded0amr3280541fa.11.1757654914807;
        Thu, 11 Sep 2025 22:28:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpGJ8fEYHY6vVQRRiNssGfCLT3ZkT3GfJOpIxVKWucfTurAjgfRecqT3PfQJdvJQYHVWNvWA==
X-Received: by 2002:a2e:be91:0:b0:351:b11d:e630 with SMTP id 38308e7fff4ca-351b11ded0amr3280201fa.11.1757654914261;
        Thu, 11 Sep 2025 22:28:34 -0700 (PDT)
Received: from ?IPV6:2001:999:408:6576:1142:7350:b6c5:671e? (n4ctkw60s7hbahed3xa-1.v6.elisa-mobile.fi. [2001:999:408:6576:1142:7350:b6c5:671e])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-34f15a591fasm6136911fa.9.2025.09.11.22.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 22:28:33 -0700 (PDT)
Message-ID: <4cc2ba18-e7de-448f-aaee-043ed68dc6e3@redhat.com>
Date: Fri, 12 Sep 2025 08:28:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 06/15] mm/migrate_device: implement THP migration of zone
 device pages
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <49039b9d-4c42-480f-a219-daf0958be28e@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I8nDIK6QVqdyhH8ITq2CX5K0HlKrlqFcJdfKYn77RSA_1757654915
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B361E180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rtqa9k6wsadd6npiozrbe47y4hp69fkd
X-HE-Tag: 1757654918-126942
X-HE-Meta: U2FsdGVkX196ai/IaPBSSvvQbs3xhnDftyxy2X//gJdDWLLiQjYugE7Dv1LTv69dCevQVWPiwPIhe/CxO0Ex9afy+NfevtWvofVcZ/s3y3RkIqPm3065FfOwWycCqZsewb2PPGJwrc3TBTztwF70w1HnLx8KoiCbYWRhFJCgsJfFtNAnayC/8tJ0bcZuP4p5GVHqoNhqE4XfvE0EUM8wg7xFu2eAXgHCN87q4FkHJvC9TeyCVt+nAsH1J+4nd0Pqo+JFpbfblpbsDjdpoh/eFLOH8+bOLQ6JLmiBSAotxKSgLXgKH/qg8+YrLvPsHXRhRlKzYhPe8TPp054UT59zRzePlUYQXA6FRJ4yyet7IxdeKRwYr99Wc4LPJmomT3gKtIE3YDftm7kYPCAleQ6GZbBCrcFh+L5HwhBIQsF8160CS/kXf4GUt90Gs4yM+YBYPI6s/b4o+3llg2V6S27LwMgS9UdJ74a1N7uBDoMQHpEYcR3xIxT5x4SDHIU90pocvwFcV8SbrT+rYJDDaQI6rAWAbzDX0/dGlru94PFBr1Z6tiavTcaLYG+9VhJBfviICQhq3hOx54wqLqGpuvYWajnxg8FEsJp2XgaWNqvHJ7YR97yq5klUAQ6CvwmUtRNFd7MRVeSh+3kVqiOdijopeUNBgssmpojjtssC6nkDI/pN4eYp+/QTA6mVV0QoKSP6EkGm+DA0G9470uz3IJ6nKrHvFw02FB2y8D6KHcgMWmtzcoTeOhE4CIX8nAAEbXWr8xwyf28uNtikn1Wf3a6zF2wO0B1hnfuhvijtd34jQRiDhbI/JWwKGYFPDW1OKxmv1jVnCcfqJIlm2Ca3ali/ZQa67vSXv8DUJWbVUuZTBbUOGC6CMnv+kxVnn51/tuSdqPprlgILAPHoSybXGY9a49q5lVtyODa/GLR28YtVvIU+hmH5ug03zcHW156oG4JROexrzaU8wwsfNRRUliZ
 +rJHu+aV
 VOsOySwiwvJ7458XGjuBMoOpVyKFTSgfGo996zdaVB9dCiG+iFgUslkjYAHeySpvl3218DsCqGyLTgYwHU5qhF+BPqI6BP733DJEcinJzvfsog8mN2psf0E67iysHl1mMKPehzr7g6ffhsLDWJePSI/w7XW1qX8AoXALodx6Qj9WPD+BhK/KbaWXtPj3nDVO3OU1l/tGUJOOqAutR7NP+sj6ZzwKTbjMsoBQwiDDSkp1uEchaujqjJxGe03zP/oUSDlHcbuzHkjvzE/LZSVDNfkyhRyR3rZ/EOu28L1eIWGgMw2n3zzbIjE8u2bXVnRSA0ovAVOSQ+BImm7jUUrJ+gUimKkX69eeZzuJiMHqc6wAqHJr6dIBNg84rVPlRI6rod+2XQszVA2AGH3smxho1iYoAKsVx4Mia0YN+vAvqgozA+KNLhZUqpyoLKqeThhDJJeHAvyMjK8QQ4M80czYAUM8Vd3VwlV0zP1YtF0xXgQhWdEitOXz7DdW1u2glhMaLqG0poUXhY+6RgKrgZvAuBuBSQNyEms7yHUmkUgNCU3PTvHKJQTN59tNbQnu5vauCARMbfH+PtP/Lbh6aeeBk57zD4bg4sbBveHRP3lEopWbA9vQMsZ4YZRWOV9Osr0dBFuUiSUtzCcemwlxNRoDFW2ZH2l4NBmjoZrvsje537nlQo3t+bkvg2ryNWODgBov5WE2zAtyHEGXfDzMQkdAcmc8sQiPtwR75hOAndFV5B0yenybo6tUV9v9XfKoKnGNn7Js9kVWi8OobCaH7YcfLCf4uInYNaV2CovyZ23P0DotgwYQIvfPrb7HyLLJPNqJ/O95ZH2NMMwI0cFca9BVien5twN0AxBQfoFgFiuPnlwJQ9XHYiE2wWw2ZOORlqV3o58dhTWZ5sMF4aZggvSxFE9PJnPZEkHbyPrBBFA3jj3voJ5z9MUtgFQLTLf46EbKJ5gUlo+8kznTLLB9d6prvqsUrMApb
 s1O8RUmp
 pGWpMESt8a8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 08:04, Balbir Singh wrote:

> On 9/11/25 21:52, Mika Penttilä wrote:
>> sending again for the v5 thread..
>>
>> On 9/8/25 03:04, Balbir Singh wrote:
>>
>>> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
>>> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
>>> device pages as compound pages during device pfn migration.
>>>
>>> migrate_device code paths go through the collect, setup
>>> and finalize phases of migration.
>>>
>>> The entries in src and dst arrays passed to these functions still
>>> remain at a PAGE_SIZE granularity. When a compound page is passed,
>>> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
>>> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
>>> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
>>> representation allows for the compound page to be split into smaller
>>> page sizes.
>>>
>>> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
>>> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
>>> and migrate_vma_insert_huge_pmd_page() have been added.
>>>
>>> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
>>> some reason this fails, there is fallback support to split the folio
>>> and migrate it.
>>>
>>> migrate_vma_insert_huge_pmd_page() closely follows the logic of
>>> migrate_vma_insert_page()
>>>
>>> Support for splitting pages as needed for migration will follow in
>>> later patches in this series.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>  include/linux/migrate.h |   2 +
>>>  mm/migrate_device.c     | 456 ++++++++++++++++++++++++++++++++++------
>>>  2 files changed, 395 insertions(+), 63 deletions(-)
>>>
>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>> index 1f0ac122c3bf..41b4cc05a450 100644
>>> --- a/include/linux/migrate.h
>>> +++ b/include/linux/migrate.h
>>> @@ -125,6 +125,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>>  #define MIGRATE_PFN_VALID	(1UL << 0)
>>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>>>  #define MIGRATE_PFN_SHIFT	6
>>>  
>>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>>> @@ -143,6 +144,7 @@ enum migrate_vma_direction {
>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>  };
>>>  
>>>  struct migrate_vma {
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index f45ef182287d..1dfcf4799ea5 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/pagewalk.h>
>>>  #include <linux/rmap.h>
>>>  #include <linux/swapops.h>
>>> +#include <linux/pgalloc.h>
>>>  #include <asm/tlbflush.h>
>>>  #include "internal.h"
>>>  
>>> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>  	if (!vma_is_anonymous(walk->vma))
>>>  		return migrate_vma_collect_skip(start, end, walk);
>>>  
>>> +	if (thp_migration_supported() &&
>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
>>> +						MIGRATE_PFN_COMPOUND;
>>> +		migrate->dst[migrate->npages] = 0;
>>> +		migrate->npages++;
>>> +		migrate->cpages++;
>>> +
>>> +		/*
>>> +		 * Collect the remaining entries as holes, in case we
>>> +		 * need to split later
>>> +		 */
>>> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>> +	}
>>> +
>> seems you have to split_huge_pmd() for the huge zero page here in case
>> of !thp_migration_supported() afaics
>>
> Not really, if pfn is 0, we do a vm_insert_page (please see if (!page) line 1107) and
> folio  handling in migrate_vma_finalize line 1284

Ok actually seems it is handled by migrate_vma_insert_page() which does

        if (!pmd_none(*pmdp)) {
                if (pmd_trans_huge(*pmdp)) {
                        if (!is_huge_zero_pmd(*pmdp))
                                goto abort;
                        folio_get(pmd_folio(*pmdp));
                        split_huge_pmd(vma, pmdp, addr);   <----- here
                } else if (pmd_leaf(*pmdp))
                        goto abort;
        }


>
> Thanks,
> Balbir
>
--Mika


