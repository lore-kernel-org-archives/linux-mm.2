Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05243C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 06:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FAE8E00E3; Tue, 12 Aug 2025 02:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFF58E00BE; Tue, 12 Aug 2025 02:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791938E00E3; Tue, 12 Aug 2025 02:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 648588E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:25:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1748E1A01DE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:25:38 +0000 (UTC)
X-FDA: 83767119156.19.89ECDAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81F4CA0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:25:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ieFGBDna;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754979935; a=rsa-sha256;
	cv=none;
	b=qwjxrfEe8P9pDVBPSp+YaEgpn9nNue254D610ovmvdpHq74f2k5MQpvMUWL/tG5/4gMzOb
	r5Rtl6XGRAoaqKcWtavkIgz0sRx6KMmJuDF7CWJZgkWEE56wjS2GVnLdQ+F1wcXJa/tpUu
	B4MEBX9+j1h0qVXolX/cYxvwHcGtYbA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ieFGBDna;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754979935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4b1h5it7hQAfk6co/FTWaAEG6kVFNfYsnIT5BpGkOXc=;
	b=5s+qFbjqU/S0eQHgT25/nqBvFpUiX7yEEWixnH9G7SH5U5vzOkAQen11VX5e6LvGmuXxNh
	iE/fWbk+YkwhCWYSAh2bHfUU3iL23URBCDLyTVLA//8kmsOPmshLtZoAroud1GNQNpStbM
	5hjIm/3ozRXtsDojDYIjJVdUI4VWW48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754979934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4b1h5it7hQAfk6co/FTWaAEG6kVFNfYsnIT5BpGkOXc=;
	b=ieFGBDnauYN7ViD3kzzNIJOfroI5Yf0ar8iDBOJeMjt7h66N624ZXKBs9YJDcTgn+5+Wh+
	tgufOFncmkdvxpv/tUhqi2ELeBUw1voCUwQV9vqf4bYVpLxz5HqPP1Mpb2akA16NYUAQDA
	5Xi0VEUuowYPoRHlByCA/hsOwXgSSC4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-s3ZItQqAP_yIaIvN6hxKCA-1; Tue, 12 Aug 2025 02:25:33 -0400
X-MC-Unique: s3ZItQqAP_yIaIvN6hxKCA-1
X-Mimecast-MFC-AGG-ID: s3ZItQqAP_yIaIvN6hxKCA_1754979932
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55b91b8f858so3470747e87.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754979932; x=1755584732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4b1h5it7hQAfk6co/FTWaAEG6kVFNfYsnIT5BpGkOXc=;
        b=Yz+1pKfz/BzRzGMOs5NvBVRCW6z2NVdd7xrGobktlxFuRnBV9xAlCsc6yh/k5CTdSe
         N+Xp/4X5sZD6YagizhjhFx6BbwqbQx5m8BmEaZJ+8dHgDo7yNKBgHr0XXTaQ5kcxRr2t
         CM/bCz8kuV9F9SG7fRgaxq7LwBihpFZtIYAkJxCef+ztPr8KlX52C8VSie+IEh5nz8P8
         DuVqhtxKYu8QopT68gi2TNyJj7Hg3S6rAIr2pf9xdXwgpHcmrvmE/cPP/3sRx/qzSS1F
         9d1r90HPCE13wGso/YpD5nw0pcfep+6IIC5L3HzSUAPYF1fuysq2JUQnVQcEB4iLaQAM
         43YA==
X-Forwarded-Encrypted: i=1; AJvYcCXTQzBVX97M25ICoGyDgB4QEtzEhrhP+7+pMJwW7PWGa8ZmhMC7UZbCMyjj8pqGF0rDv7rZgIvZbQ==@kvack.org
X-Gm-Message-State: AOJu0Ywjwa1pHjonKPNgAdLsKzawuyCtPMohx61Vu7kOMY7WQqmW5yRI
	uiraxE0GwBryElVcnmDTOeWIOfQLWwKbkFlK1sm8ST5dTO8bgHenfX1a0albSKAj4sBJ3Lge9Um
	lNGABBtsb2I0BFOxxKcKuJem5RtY5E7NzWRuKQGe1XUUV5Hi2Nlo=
X-Gm-Gg: ASbGnct1xuA8prTaKDaK+D21LRLSrnjSgzcjf3a/+Afkw5UQszd2B61x7LY0KeOs/Nw
	NCxyXPKR6QEPZ6E3yxfnVuWco9pPBgZ69EJIjDQ+F3+Ety7Xm8MdoEBpSqV5J+wTPj9rtEz9B+y
	rKqIGWqftLhxhM3QRdTvhm4gzDV+tnrwfIxSpPYVvqO21E/z7vjuqn23CGAME4iIdwaIfE+YIQo
	sXafA0HJoyznbPWtYac6D+b00AdODG6eYUMggSvqC33sxke1FJQNNqanvah7pj3JG5UIIG5CeBZ
	Gd0dFGrWrNnDc9xpCwPDEcleFtsgH4md9gyjruD0ZV/PXYT4NYh39YjmcVkY22NQOg==
X-Received: by 2002:ac2:4e0f:0:b0:55b:930b:3582 with SMTP id 2adb3069b0e04-55cd75b47f1mr570107e87.10.1754979931836;
        Mon, 11 Aug 2025 23:25:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk46MpSuFsVM6NcIYAx6Ghd9M8yiLeUsRPho78aVmCFUaIH2LPtZcHS1lt9FMxW7jXl4YUIw==
X-Received: by 2002:ac2:4e0f:0:b0:55b:930b:3582 with SMTP id 2adb3069b0e04-55cd75b47f1mr570097e87.10.1754979931310;
        Mon, 11 Aug 2025 23:25:31 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55ccb356d87sm1421100e87.89.2025.08.11.23.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 23:25:30 -0700 (PDT)
Message-ID: <3df6fbed-7587-44f5-bd12-29e59ecde123@redhat.com>
Date: Tue, 12 Aug 2025 09:25:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
 <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
 <aJrW/JUBhdlL2Kur@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aJrW/JUBhdlL2Kur@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5Bzi4ENym1Y2AZc-kryTqGsotIflsafRBAx1VmTm59k_1754979932
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81F4CA0003
X-Stat-Signature: 8qcqonn7b7mumctamfbo6ftypk5pkdpn
X-Rspam-User: 
X-HE-Tag: 1754979935-599212
X-HE-Meta: U2FsdGVkX18PN4EPebHwvCNFJ0gZV9YYCSr0J5YsBex+eiNTLbpdPFjFKK49LRnNdSkqAa4Zi/quoyhjYwZpw3qjcmjxg4wUIofgymjVdmnogoPQyZZV/OBCGh2r80d3BxO4Rwlm5dgRwqKWw6edawDQac6vgfgjbFJQ9gQuAgg54qbrPjNd2N2+HJ+u7tcIsICij49OFv2EeimrzSaxRmD/CBzD8OO4/vieEZzgvxk5BAo19KYDEnVhAjOrRKIOuZm7u3TRl7Z8TL44UVwgbrQNJOKI73KftzlJiH0oFVGptkDxLiMbxz6Y8zNMRoNhQ98h/kjVZdRiZ8uYvmW95mil2RzrH7wujwlYmDwGcASTkqDAa5ROjfjLcv7H/A0F5IRYkWdnOUg17qG1KMaCIRAPfobvVqj8dUiPWjiqjuy7mU0QDzghXrLgD1Oyh8QiWiDDFQZZH6hL08D7h3Yi33C3c2AZ6oW8CXrWaX1sZuSWHkiQQNDB5YkFuaSR7OnwJMw/MWf+6dl06H0F2BfTBPhn8h7lmCGXTvUAdnjJEdSHgn2uf6hVVybcgvhLFDA5RZI1G8QbW2FgycTaYFevoEmvt8og73uQCt/EFWly0ssNzT3458yGpRlxvZhTSRc1fcpurHPQf1cC+TAZV5Z5Gpjrjkm9R/R6CPPyFwrB6P1em2G2qYX3ZJdkDsaXAp0SIdxTgfIDg7owkBl+VFi6nTv5g9QvNtpV8zCF0LpWRWHFzVuWHlQXyBxJunIltlfX7luePhf0gctbXIP/liPyRuZzKpQogudlGDwUCPQm+OJ0udVYkD0DFkEAj5+gmC13jkO1mjwbeBdhm419a02RyZmGi1Wig/SIigrf/gFCUmZFsAoasaLkfoFsqTX9gxNlTDCv91AsDeBlmTy1NjgSlC+LpLhcXK5SCnU2HGb6F5wuuvqZPYUjIrFfIisVqdMdaaI+abW0r6LIHVCBvUB
 jxoLfySi
 bREKlUUO/kY028O7d/bu9l2r8wPG+FyOS9gywiZ+VBPg2GHKrZTg68HcSQF+JRaJEktDHYc3qgG3UWHM0klP4GrxIj1OUckBIR+C9m1tI0SodqgnvyJj75D4xpw1dwCc4zeUogDButkjaGCfddZ8GCa3nLH1WB7pzdEXPIUt6CrivrMPPa3wefoMjqGPBm03McQALvNlzmCSBfgpWoj/DSiDcyKtmH4pZQetAQOgUuwcgJzZvTspK/7sHIrk+UR7TUJbmqSNYyd0/dYTgAkeMaIGy43gbuQ3ETvelIgEUfdTNmlINoeBxAHvAk9vpsJITi7ym3MyAKv/vVcnJyzD/oAQPcGn7ZekjBMN1uerp6/h/SIg65hZbhFOlDH2U7QVTLdX4VX6Ns8r3CJO5f5tX0RY14DgXIwxKnjKEN1r/rxOf/nDCF6WCRi/lfbbu/RpnXcKPOc4mL26LUKlY5oYVkwi9js4MoMDf8BH2X/qKfpGCbcE53pTSqVD/DrIjngFjsb8Tch5tNRAcZ/Y6TaAxfxiE3JMxO+kCFdgqIdx8a5QeVyY/fiJmPvrD2BQelA1AQbmggu0YvtnPa7Tw2MzgIJBdvmEs2C0pfZbBqv9Nm7Bb5m7LfY++EeMCMaMF7He18XhlpZDkiSpVswcvWIdKgWL5QBbXae+yDJC+actL9sDl3oK5M49rG3Mk1JJxh5fD3lwduXilAtU00vgk8Nm6bgqyMPG0jP4H/cejg/eCVdt2sVIL7GlHMkZ2X4ZYk+i7e4K925jjxWC8Oo11mOqVc+n8F1EeHAFxZJiD4CN3iJyNvK5X1PDEsj3TN8eF7tJb5Q8qQKD8IOcr3KH0vWMyOkRkl4RBzNoaTbxXdCelYKTEN51NZsBvWpejh/WdnxPFL9rBg9aDXMTa3ljPqGW7nG/JlTAhFyJz5y1Y6kBQCHkhDUYysB9bEA2tGIe5CutD7NEkUHBPpnywnvgYYAqyO9An2N6x
 4uU5jXVG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/12/25 08:54, Matthew Brost wrote:

> On Tue, Aug 12, 2025 at 08:35:49AM +0300, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/12/25 05:40, Balbir Singh wrote:
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
>>>  mm/migrate_device.c     | 457 ++++++++++++++++++++++++++++++++++------
>>>  2 files changed, 396 insertions(+), 63 deletions(-)
>>>
>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>> index acadd41e0b5c..d9cef0819f91 100644
>>> --- a/include/linux/migrate.h
>>> +++ b/include/linux/migrate.h
>>> @@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>>  #define MIGRATE_PFN_VALID	(1UL << 0)
>>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>>>  #define MIGRATE_PFN_SHIFT	6
>>>  
>>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>>> @@ -147,6 +148,7 @@ enum migrate_vma_direction {
>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>  };
>>>  
>>>  struct migrate_vma {
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 0ed337f94fcd..6621bba62710 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/pagewalk.h>
>>>  #include <linux/rmap.h>
>>>  #include <linux/swapops.h>
>>> +#include <asm/pgalloc.h>
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
>>>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>>>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
>>>  		migrate->dst[migrate->npages] = 0;
>>> @@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>  	return 0;
>>>  }
>>>  
>>> -static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>> -				   unsigned long start,
>>> -				   unsigned long end,
>>> -				   struct mm_walk *walk)
>>> +/**
>>> + * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
>>> + * folio for device private pages.
>>> + * @pmdp: pointer to pmd entry
>>> + * @start: start address of the range for migration
>>> + * @end: end address of the range for migration
>>> + * @walk: mm_walk callback structure
>>> + *
>>> + * Collect the huge pmd entry at @pmdp for migration and set the
>>> + * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
>>> + * migration will occur at HPAGE_PMD granularity
>>> + */
>>> +static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>> +					unsigned long end, struct mm_walk *walk,
>>> +					struct folio *fault_folio)
>>>  {
>>> +	struct mm_struct *mm = walk->mm;
>>> +	struct folio *folio;
>>>  	struct migrate_vma *migrate = walk->private;
>>> -	struct folio *fault_folio = migrate->fault_page ?
>>> -		page_folio(migrate->fault_page) : NULL;
>>> -	struct vm_area_struct *vma = walk->vma;
>>> -	struct mm_struct *mm = vma->vm_mm;
>>> -	unsigned long addr = start, unmapped = 0;
>>>  	spinlock_t *ptl;
>>> -	pte_t *ptep;
>>> +	swp_entry_t entry;
>>> +	int ret;
>>> +	unsigned long write = 0;
>>>  
>>> -again:
>>> -	if (pmd_none(*pmdp))
>>> +	ptl = pmd_lock(mm, pmdp);
>>> +	if (pmd_none(*pmdp)) {
>>> +		spin_unlock(ptl);
>>>  		return migrate_vma_collect_hole(start, end, -1, walk);
>>> +	}
>>>  
>>>  	if (pmd_trans_huge(*pmdp)) {
>>> -		struct folio *folio;
>>> -
>>> -		ptl = pmd_lock(mm, pmdp);
>>> -		if (unlikely(!pmd_trans_huge(*pmdp))) {
>>> +		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>>>  			spin_unlock(ptl);
>>> -			goto again;
>>> +			return migrate_vma_collect_skip(start, end, walk);
>>>  		}
>>>  
>>>  		folio = pmd_folio(*pmdp);
>>>  		if (is_huge_zero_folio(folio)) {
>>>  			spin_unlock(ptl);
>>> -			split_huge_pmd(vma, pmdp, addr);
>>> -		} else {
>>> -			int ret;
>>> +			return migrate_vma_collect_hole(start, end, -1, walk);
>>> +		}
>>> +		if (pmd_write(*pmdp))
>>> +			write = MIGRATE_PFN_WRITE;
>>> +	} else if (!pmd_present(*pmdp)) {
>>> +		entry = pmd_to_swp_entry(*pmdp);
>>> +		folio = pfn_swap_entry_folio(entry);
>>> +
>>> +		if (!is_device_private_entry(entry) ||
>>> +			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
>>> +			(folio->pgmap->owner != migrate->pgmap_owner)) {
>>> +			spin_unlock(ptl);
>>> +			return migrate_vma_collect_skip(start, end, walk);
>>> +		}
>>>  
>>> -			folio_get(folio);
>>> +		if (is_migration_entry(entry)) {
>>> +			migration_entry_wait_on_locked(entry, ptl);
>>>  			spin_unlock(ptl);
>>> -			/* FIXME: we don't expect THP for fault_folio */
>>> -			if (WARN_ON_ONCE(fault_folio == folio))
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> -			if (unlikely(!folio_trylock(folio)))
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> -			ret = split_folio(folio);
>>> -			if (fault_folio != folio)
>>> -				folio_unlock(folio);
>>> -			folio_put(folio);
>>> -			if (ret)
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> +			return -EAGAIN;
>>>  		}
>>> +
>>> +		if (is_writable_device_private_entry(entry))
>>> +			write = MIGRATE_PFN_WRITE;
>>> +	} else {
>>> +		spin_unlock(ptl);
>>> +		return -EAGAIN;
>>> +	}
>>> +
>>> +	folio_get(folio);
>>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>>> +		spin_unlock(ptl);
>>> +		folio_put(folio);
>>> +		return migrate_vma_collect_skip(start, end, walk);
>>> +	}
>>> +
>>> +	if (thp_migration_supported() &&
>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>> +
>>> +		struct page_vma_mapped_walk pvmw = {
>>> +			.ptl = ptl,
>>> +			.address = start,
>>> +			.pmd = pmdp,
>>> +			.vma = walk->vma,
>>> +		};
>>> +
>>> +		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
>>> +
>>> +		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
>>> +						| MIGRATE_PFN_MIGRATE
>>> +						| MIGRATE_PFN_COMPOUND;
>>> +		migrate->dst[migrate->npages++] = 0;
>>> +		migrate->cpages++;
>>> +		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>>> +		if (ret) {
>>> +			migrate->npages--;
>>> +			migrate->cpages--;
>>> +			migrate->src[migrate->npages] = 0;
>>> +			migrate->dst[migrate->npages] = 0;
>>> +			goto fallback;
>>> +		}
>>> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>> +		spin_unlock(ptl);
>>> +		return 0;
>>> +	}
>>> +
>>> +fallback:
>>> +	spin_unlock(ptl);
>>> +	if (!folio_test_large(folio))
>>> +		goto done;
>>> +	ret = split_folio(folio);
>>> +	if (fault_folio != folio)
>>> +		folio_unlock(folio);
>>> +	folio_put(folio);
>>> +	if (ret)
>>> +		return migrate_vma_collect_skip(start, end, walk);
>>> +	if (pmd_none(pmdp_get_lockless(pmdp)))
>>> +		return migrate_vma_collect_hole(start, end, -1, walk);
>>> +
>>> +done:
>>> +	return -ENOENT;
>>> +}
>>> +
>>> +static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>> +				   unsigned long start,
>>> +				   unsigned long end,
>>> +				   struct mm_walk *walk)
>>> +{
>>> +	struct migrate_vma *migrate = walk->private;
>>> +	struct vm_area_struct *vma = walk->vma;
>>> +	struct mm_struct *mm = vma->vm_mm;
>>> +	unsigned long addr = start, unmapped = 0;
>>> +	spinlock_t *ptl;
>>> +	struct folio *fault_folio = migrate->fault_page ?
>>> +		page_folio(migrate->fault_page) : NULL;
>>> +	pte_t *ptep;
>>> +
>>> +again:
>>> +	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>>> +
>>> +		if (ret == -EAGAIN)
>>> +			goto again;
>>> +		if (ret == 0)
>>> +			return 0;
>>>  	}
>>>  
>>>  	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>> @@ -222,8 +334,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>>>  		}
>>>  
>>> -		/* FIXME support THP */
>>> -		if (!page || !page->mapping || PageTransCompound(page)) {
>>> +		if (!page || !page->mapping) {
>>>  			mpfn = 0;
>>>  			goto next;
>>>  		}
>>> @@ -394,14 +505,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
>>>  	 */
>>>  	int extra = 1 + (page == fault_page);
>>>  
>>> -	/*
>>> -	 * FIXME support THP (transparent huge page), it is bit more complex to
>>> -	 * check them than regular pages, because they can be mapped with a pmd
>>> -	 * or with a pte (split pte mapping).
>>> -	 */
>>> -	if (folio_test_large(folio))
>>> -		return false;
>>> -
>> You cannot remove this check unless support normal mTHP folios migrate to device, 
>> which I think this series doesn't do, but maybe should?
>>
> Currently, mTHP should be split upon collection, right? The only way a
> THP should be collected is if it directly maps to a PMD. If a THP or
> mTHP is found in PTEs (i.e., in migrate_vma_collect_pmd outside of
> migrate_vma_collect_huge_pmd), it should be split there. I sent this
> logic to Balbir privately, but it appears to have been omitted.

I think currently if mTHP is found byte PTEs folio just isn't migrated.
Yes maybe they should be just split while collected now. Best would of course
to migrate (like as order-0 pages for device) for not to split all mTHPs.
And yes maybe this all controlled by different flag.

> I’m quite sure this missing split is actually an upstream bug, but it
> has been suppressed by PMDs being split upon device fault. I have a test
> that performs a ton of complete mremap—nonsense no one would normally
> do, but which should work—that exposed this. I can rebase on this series
> and see if the bug appears, or try the same nonsense without the device
> faulting first and splitting the pages, to trigger the bug.
>
> Matt
>
>> --Mika
>>
--Mika


