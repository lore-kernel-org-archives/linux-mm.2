Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50465CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD6B6B0006; Thu, 11 Sep 2025 07:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4EA6B0011; Thu, 11 Sep 2025 07:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA518E0001; Thu, 11 Sep 2025 07:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 052376B0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:11:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96B3AC046A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:11:48 +0000 (UTC)
X-FDA: 83876704296.29.2F6645F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31F56C0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:11:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O9eEUmXW;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757589106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnoZL9IlsM4I8snaZrLtF+NT0iFbOyLl7iwd0dyctVo=;
	b=gWEqLZqPlZywTOwuDcqLkP8GiR/E9KwIAOrU2OPMsrRtwgl6SXknJoXBxSyq9nGwZ6Hbwg
	LQfAnYfl/06HmVIC9DvL+54rLSGNYk0FVhwV2of9EzZxZpfggjVjE7drbgj1hrt+boZNtX
	VbWMDP9yNMBC4Bu9VKJ7ux3U+NyHlyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757589106; a=rsa-sha256;
	cv=none;
	b=EbS37eRSP92SRZveH7EEV27ajEjeco4PWRZsSGAbbcGyowBPIBiPDJ+bukestkfBCG8fn4
	qxVdIz4hEzVa48GSFY9t/V1haeZy3RNWMCw8FbD3XXAXTE9vQEYLzYIyAJVFyXW/vcB8zP
	CF7aNChyBPv+Cqw9n/iv1zPGihxyUNI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O9eEUmXW;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757589105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EnoZL9IlsM4I8snaZrLtF+NT0iFbOyLl7iwd0dyctVo=;
	b=O9eEUmXWoqQ41fyUaO5ts3c2SZEu5wwGB6m+JyGIWOoWTYWP4r7nelGdk/7yM/SVJoN6JH
	hyJiPRyP9Ljl9zb7z+E9ktZ2iqlgBLhoXU11sR6yQhJiJ5RnTXtSausPZlAauXz3QaJlAu
	OGcS8CYUGfWLvIegC39SXr+Zw6FXdtc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-Kyl76s_8MQOQB5a89aNWAQ-1; Thu, 11 Sep 2025 07:11:44 -0400
X-MC-Unique: Kyl76s_8MQOQB5a89aNWAQ-1
X-Mimecast-MFC-AGG-ID: Kyl76s_8MQOQB5a89aNWAQ_1757589103
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-56088a475cdso317485e87.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589102; x=1758193902;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EnoZL9IlsM4I8snaZrLtF+NT0iFbOyLl7iwd0dyctVo=;
        b=fMYn6HnnN5wx7C4YU55yH9tMmbah4MU6Quo26v2Z89ARS4xlmqu1InI02s3M6VOOmx
         EU2wHdJO7zbYOPecL/ot834IaKbntzmEpaiO8nonUe5KECO0jDmdYyduBaJ4vrIyfxbX
         Esk3ju/mCLocZ3QMb/AxFvqFnF+BAD/mj7F5/13BggZp3MMX6AH5hZYtpiNeteJU43Ni
         UiYyqHFadtCNaseUjWHL2HmDTLTefq3ouJQcxh73gvicr3PlzcBvGlMAP8JRD8cVP4Ti
         LRAxFqxmuxm87tja20QtTJmdzJ/9L0B/Nyqv75aRa/PhBkBIEFbW5cHyByVOrt+k58by
         i9iA==
X-Forwarded-Encrypted: i=1; AJvYcCUKARwdyB9k2rS/Qit5jvHGD1WpaihilzuKy2y/eDwtEQ2ZnubKp9w75NluKb1b+BoheZNL53yBBQ==@kvack.org
X-Gm-Message-State: AOJu0YwiZ+e4CxLNIxAGDmWOA1G0nK8v7JcemQd1kByPdVtIFlqSRz99
	bVndFJ4iPvkIsNHS9vBUuwJUFubQy7TvRTya9Ri9W1WYWa1wBG74NPMV1x/OYphaUzTa4zGBhwZ
	3B4hCITxLFAoZfDPhnpG5m0OF2YMlUl/+RKXBilAdx/yQjkxV6gc=
X-Gm-Gg: ASbGncuV9kd69YpVt7ZxgXVld+EcB4Zxo8UZ8NIF32k/UEwsVBSvUYyHj45H0pj/GB4
	rrxSt5tR/eqj+YQZ3N/ncC6JFT3oZfMkbDhGroGEQaRyNxtmDjN75RIA8bLVd/6U2pGAtIohTnj
	9Vh4EgZ3rNfdj8dGzZq7UQKmP0GOWM+aTUc6WBeCpWqhL49bR7rOUF+G1u+YWJfUd8uRlo0lpNF
	4e/aZmv39f6xoX/ib4vQ06KgtJ91nnPdVNRvASMpkLR/mpGKdosmQ9bFuHiFIvVqoXFFDTHxWun
	v97lpkB6rmzoctnPg/ltNXj9/r1sElQdAACRxVVOmV6HPYfDpkDhHT18CZt+DBBIUYr+mjnycA3
	e1JYvW+3tGjooxk/XAxvRPa8THEODECLnLKWcQvXrXtTRGttVtA==
X-Received: by 2002:a05:6512:1593:b0:55f:3faa:7c2e with SMTP id 2adb3069b0e04-5625f535a77mr5703526e87.22.1757589102499;
        Thu, 11 Sep 2025 04:11:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHndKi4ZUjcu5xTRlvMfXjlXFcDZdujE+IlsZ0U4neE95H5mnTNxQ6YofItgf/sP/wsePXmQ==
X-Received: by 2002:a05:6512:1593:b0:55f:3faa:7c2e with SMTP id 2adb3069b0e04-5625f535a77mr5703497e87.22.1757589101977;
        Thu, 11 Sep 2025 04:11:41 -0700 (PDT)
Received: from ?IPV6:2001:999:704:9310:43e6:e14c:406:e339? (n7kwfhcd2z0e9u7cxfd-1.v6.elisa-mobile.fi. [2001:999:704:9310:43e6:e14c:406:e339])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e5c3b6002sm364013e87.28.2025.09.11.04.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 04:11:41 -0700 (PDT)
Message-ID: <9047198d-7b35-435b-a933-ff7b1357919b@redhat.com>
Date: Thu, 11 Sep 2025 14:11:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 06/15] mm/migrate_device: implement THP migration of zone
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
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-7-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250903011900.3657435-7-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DR_7ULMOHyRpLWsZKzFifqypm9lkgOCnLzs59H3onuo_1757589103
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eo13gwyrqqgegikwcf9cccjie5g6558i
X-Rspam-User: 
X-Rspamd-Queue-Id: 31F56C0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1757589106-787188
X-HE-Meta: U2FsdGVkX18iueMLsek8/PTMChcciVyGDpvZXwXv0KzGIWjTqePQW4J/grs5ivKPgQdOmpb4Y2xXywixYLKxQ3+uo151t6VvNxcMCH3AACVuYTcq2yVcBuhjJE+3JQ9l+vZTKcl0cagPAb4osikxQYbVtXUGOUGrYiHXrZryxJsVFOd7uVgaFx8E79jZI8jFpFU1HWgpDojmhTdAN9r4mQj73Hb5eNgrx03RbO9Ue+CD9TmN/Vm+LluWPJsP76AgxkQqLa/2K63phjWtIZJIvhLYrvudqnetEL7hg6Mll1fstmFFJ7kVUgV4nAC2DqbNPjrjNt7cgs+rmY8iGdv4qos+R/VkuxvsENe0HyTODYa2CR2mE7D3gHvLjezVqwp+Yx6RPGTsRfBjiVHDyM7kqSL+X0d7bH4/O76xYd6WcnjdY5htrpy77Mw5CSLQGEuhnk1ZqEP0DDxawp96a0ZUw92/bJCQ6h4hwqKhb4BrlqBhFp6ygYY7Mcaa+RIXma77RDwtSnWZLp/XUeF2qNcoZq3b4vZNWpBVyoNKW4rZqbzhEqc5FwoqEmtMNSxse2+Ouxcg2jV3vSH2ICmHw9j7sRoicJbRlhqVw87S7ZpURu1LcAjvGgzdE/ehA3MTJilfIxTJWfJ5zP05c08S2pmvDYGrW6nrb24p29bKCo4B+GwNe8El/sHC3Jd2vyW1GSkD2n0R7Z8YR5J8a7LrqQwYZARhkC0dLOCI9GYTRYsPDY3drtwqqf9PklHQtPPt6JuUkED/UWyoRLcfLaoTNxnF6Zv1MpDfEL8UPJyFe5QneahBPlManBsX2zxKQGRJr4mA0HsG7qUx4jPZsuYbx46DQVwKAO6j7nC2UI7tIqTWJ1SOVa4KypxuE/+mtIVTpO3qxZr0fmsnCmfupNKHQmmDvZNYUCeDvgt6sZBGfpLfaWf5QloGoRqiQq2RZnbZFYDH309nQp/j7+zrBaLKQNm
 7M1ChkWk
 JdAyjnRcPqJ/Z6vWR9vqkrcP6b9WDSQnedVz1CFYTB59ZnfR8NCwITyhih/9rBIOHQ3JWhmJtjV5OLjGo5J8nLBqAAcWcuPejUBCrAzHWY0fyuw3Y/MHQacRQybW8VANlzC+TwBYqYO7ZwLh+7QnztCC/svJR9k3tgbUixZkkCzYeLjfdLtZp0dcfjXg6M49aA7qHTtsVFjO6U845u2tHz5l2g1J7+l0NROI2/ExPIM+U80UeWVTiM8xSPSQHMUSmgYYqczWwjOVJgfLIpIGRXsS07Agia4zhUMuCf1VFahcJXBApHLuddR+Ev3XUUThnHwxJF3UAWnFRxVJysA5Y+BasbCQLqMf+sKZ0uzRK+SHlCFOj9cZ1vmTsKQ1fPahQSaBeIRq8i6xwhFW7TsCxxFbQoGw2HEWGxfiPuYRUyN3JEXvkXIP0Y5p6mGqZjuFvIWDa4sG3H9AKdtjkId+5hHhyVIJsLFrwnZ0idkMbEC+H2pVc+x4H9Fqlf2tFqsxdwYsKv77lqtzzBNe+HD88TVCtuWIAKW0EjK+re9lDqXva5/xMziKlSefF9HgtLgaduWLiBxgqC4w2soUcHFQjybnzGC6o9zomMK7UAlAZM0YrVCD7lKoELv8jxf9MlD58yPC35wKlMKVTZEVuc+keYOZIcv336MSZXTSsmZx92v55K97l0KLpR/3VU9XGEQzCB/OJ3DeF1XuvuYHbrRPqzZ/uYzORc89n1x3SxmtJKxkkIoyDsQcnRJ3PcnX8Plww69Do37eigUCbKwXCWzHTXOwuvTmTg6GxS2lZ58jDKI9oFWuN1jzNz8Db0ERQflX7VcGNZFcBmtb1UD7L0W5emT4xMZJlUCvfpH/NMZYP5gRUjm9kvS+R2pTf7ynPRHVM1wVZhh+nnKH38CEYyByV9tQurnGj0FQoLgWDOIerQn/dqTt6bBFP7NW7sIHdTBYJ0Xlp9Da1hHNeLcOMk8XFxkdKXHLo
 O87l+Xpj
 gkppmWdPAeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/3/25 04:18, Balbir Singh wrote:

> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
> device pages as compound pages during device pfn migration.
>
> migrate_device code paths go through the collect, setup
> and finalize phases of migration.
>
> The entries in src and dst arrays passed to these functions still
> remain at a PAGE_SIZE granularity. When a compound page is passed,
> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
> representation allows for the compound page to be split into smaller
> page sizes.
>
> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
> and migrate_vma_insert_huge_pmd_page() have been added.
>
> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
> some reason this fails, there is fallback support to split the folio
> and migrate it.
>
> migrate_vma_insert_huge_pmd_page() closely follows the logic of
> migrate_vma_insert_page()
>
> Support for splitting pages as needed for migration will follow in
> later patches in this series.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/migrate.h |   2 +
>  mm/migrate_device.c     | 456 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 395 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 9009e27b5f44..40e1c792eb54 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -134,6 +134,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  #define MIGRATE_PFN_VALID	(1UL << 0)
>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>  #define MIGRATE_PFN_WRITE	(1UL << 3)
> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>  #define MIGRATE_PFN_SHIFT	6
>  
>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
> @@ -152,6 +153,7 @@ enum migrate_vma_direction {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>  };
>  
>  struct migrate_vma {
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index e58c3f9d01c8..aba0cd7856da 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -14,6 +14,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/rmap.h>
>  #include <linux/swapops.h>
> +#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "internal.h"
>  
> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	if (!vma_is_anonymous(walk->vma))
>  		return migrate_vma_collect_skip(start, end, walk);
>  
> +	if (thp_migration_supported() &&
> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
> +						MIGRATE_PFN_COMPOUND;
> +		migrate->dst[migrate->npages] = 0;
> +		migrate->npages++;
> +		migrate->cpages++;
> +
> +		/*
> +		 * Collect the remaining entries as holes, in case we
> +		 * need to split later
> +		 */
> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +	}
> +

seems you have to split_huge_pmd() for the huge zero page here in case of !thp_migration_supported() afaics

>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
>  		migrate->dst[migrate->npages] = 0;
> @@ -102,57 +120,150 @@ static int migrate_vma_split_folio(struct folio *folio,
>  	return 0;
>  }

--Mika


