Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248BACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 05:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F506B0027; Thu, 21 Aug 2025 01:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57AD6B0028; Thu, 21 Aug 2025 01:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946B56B0029; Thu, 21 Aug 2025 01:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80D7B6B0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:10:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24D67B7A0C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:10:41 +0000 (UTC)
X-FDA: 83799589482.17.2550149
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA32E120008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:10:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjeUCYM4;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755753038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5z9LNM2nfkryArujiLAKBVPxaFVEA2Yxt2rNTcj6tw=;
	b=ACGfAd8jAfMhIEtkSzPj8LyhEFiBopKJ0Ug5trWodriOozis6nN7/6Oc0ka3/hiGt3Db5C
	cYPhP2Afqzh3/2h6t7sPnZ7Y4Dc3p4yLjvdpl+al96YYhjxs/Y1wTVJFscAoqiHjvd/55P
	jr8UpXjcuVdlBz6jKsMHmHpIvPYxFkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755753038; a=rsa-sha256;
	cv=none;
	b=ZUMHOcDtixBF12StT3dvGLVCPDiAFlsYBuwZy6Dj6p84Uetfiq5G6ydc/Qq5moe6Di8DNx
	xWRMM9bVZwtNuLXVxIcPGwgMEhQ5z24/3LLgeE2nWr0SkOkW+yn6YLAyUkX3sGIk2e+Jb2
	I3aJZKKBytAmXqyEIHxKAAbuKJJanIw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjeUCYM4;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755753038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5z9LNM2nfkryArujiLAKBVPxaFVEA2Yxt2rNTcj6tw=;
	b=AjeUCYM4i3MOsBTerOMTzsnlbEjHPrKVCir02cW4A+jAEUpQ2bFFruNEAFQuH3lPP6b444
	7BaZ4jEY4stlJZ9TpnYTOfY1qu6krUSQn+YsEGKRpwXzvIErq8DXomCExZtP37zNz/J9L5
	VvR5+xlcUE4L2hJd1Mffwh3gbmW9kxM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-ekiPUHMGNfGX6H257rBfAw-1; Thu, 21 Aug 2025 01:10:36 -0400
X-MC-Unique: ekiPUHMGNfGX6H257rBfAw-1
X-Mimecast-MFC-AGG-ID: ekiPUHMGNfGX6H257rBfAw_1755753035
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-333f903c00dso1958711fa.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755753034; x=1756357834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S5z9LNM2nfkryArujiLAKBVPxaFVEA2Yxt2rNTcj6tw=;
        b=cbvwHfykSfKT2gUZhOf3rMDKhhhhPPhooreYhEn9gIhq2WeQZjce+jsW2aZJ8WA/qb
         iKUpyyo1aHyohQMd+yB9uXFqJcCUsJONT67BgSYtbqmQYsxssdCuuHdAmjYrXHq+ylsr
         iNaaKreDv/dxLiVcIM+UUULZwlCby7JeBNTlEtxUCTbPVp1UWAbWztwAtYsragM7kEx+
         hxmZvSzZ4uPCpfxRpJcpTh8tnfgkKbJlOoDdBo1/FbSbZuiBKUCbSalUMwjVTzFyu+Tl
         VYmBbCCTXkXQfYqiwzp9PDcUVvn8kTVGTJto8dWZn4XM7X59Myd76D9gkxqcxamu1E+I
         Lulg==
X-Forwarded-Encrypted: i=1; AJvYcCWACuuwbsDzLTciLOk8d/DOOrUyfs3Ah2+MnPGMGLQQ5gpISTCQk4QtrgITnk+7NtmKzIp6q0ADkA==@kvack.org
X-Gm-Message-State: AOJu0Yx4bhBmv6gml5dBXmapsrTItzh0K+qEEo38u9FoYtBIEKGMKSkK
	Xw6SZCPpCSC4iTBrA7tg7bbHbBO58HQtp2tCS7NLQyCdkPUhbj1i/h2+SywklbpNKX3FBRTRtgM
	CpN0Uof8FAKvZf8pNJR8BIwGIaT43HW+prikMmXAxIoJeAtg9EcnmDDIS4/o=
X-Gm-Gg: ASbGncs9Hk6SDS+sYU0TDuyPm6FAC/v89V7DdHzm0ZaXuuqsw3oG/tb/l/NWtHske+h
	iTioPP9d7KXnRYfQ7kal1T5jXlrlbZgG45p1Js0xbJzVle8jT/+PdsgrqICOV+FQs+s2cbHIhQM
	A/Wq/hb5L9XcU4F0LgwJxO6AjOKtCwHymoGAZcIx24uWSXnfDeS+SIrB2NVLR+srrZwBc1P3utI
	1s6yvW53xHG8a4NOyqJl47xuEfa5PGpLZv8ldKWfwEP6u06xtje+o8LgPn3dPVxEsJ4OXA35kT5
	QyYyBjsMLbFi5a/3HjoFighoUqC9ZbpO7Adq+SqSZt/KX0c+R+o1pc8eM7oxd99E3w==
X-Received: by 2002:a05:651c:20ce:10b0:334:7f8:a632 with SMTP id 38308e7fff4ca-33549f783d3mr1319581fa.21.1755753033765;
        Wed, 20 Aug 2025 22:10:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8WOaUBQlFB6bJoC/HjvY5Rb/H1AL2COXAWvsi+ce5AI3zJ+OdFtkTvz90JUAt98AuHWI5qg==
X-Received: by 2002:a05:651c:20ce:10b0:334:7f8:a632 with SMTP id 38308e7fff4ca-33549f783d3mr1319531fa.21.1755753033232;
        Wed, 20 Aug 2025 22:10:33 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3340a473b7fsm29096571fa.27.2025.08.20.22.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 22:10:32 -0700 (PDT)
Message-ID: <953cb2f5-a27f-4eac-b2b8-ee67e35bd1e4@redhat.com>
Date: Thu, 21 Aug 2025 08:10:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: unified fault and migrate device page paths
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-4-mpenttil@redhat.com>
 <099ffad3-489b-4325-b5dc-90fa002132f7@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <099ffad3-489b-4325-b5dc-90fa002132f7@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ijOytgwNzOJlZZLSYeQpqpUYf9HHsD5OWwQ9sePcyRI_1755753035
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA32E120008
X-Stat-Signature: dozjuhbmszag4tu46c8sgahc9wz1cyte
X-HE-Tag: 1755753038-154057
X-HE-Meta: U2FsdGVkX18Z1mgUt5pG+cXbbUKiEqD9nzVLHH11C+R527bhb43OY1307SPuTSLCutzqroO0mpb4pr6wqAziiHAb0pusLVFEfM0JRdE54tqQcBHNR7oAysX1drdBE/rpTc/2dc2td+FmT7MVKEwL6nIXu1CgaCQlnNIYDq2jJvJViAam2+OOCEGi5+JlX57Cbfo4zby7PhD12lXcpyMDR1T70GhJSrcpsCWTo1AOOUveDbokPj3z4OWr7kqQkZXKZGGsKMOHT5Guw7yZQj3IY0OBzyVkRY2j45b6Rz0I9SjATs92/b4tV2zQ+gNt63Hr/MsJxoIXfY0we6klPAhoQQwR/aHdCxLPIu0WBjePKdN0MpZOynpm8LQBkJgwEHEsgDTfmayj7iRAGgZMG4MsXnWB+oAoFmDM3OxgT7h4SBMImVcvgp5pPzXsuKMH6KNwRXBtE/ORp42jnFwKuo5WcOgrWl/hCCQ0poMSHLDXh7GPbhe5ZlwKH1sPOvQ8yKup0JMznkb7CriQmMob6+xO+yulRDj8gU3FCH8IDLxkH5y74FtdsQoUxRDEFNt2n+9BXReD/8pi3nQJU6cJRqk3NK3q4NlHgqZNWAvofusuXrenJQiJJIVs9eAhFQSS/0QbAKfrU8+mMGwzVe+dE5jwtNeCnZvQNvDpWNTLRfdMOYI5i48y62GHIXAE3PaDPHOsn7pNAV5pDY0fWDRodC6GEAezUdzBVuU15Ty6pktoud5kwxPjsFbs8GLqX63oo8+d7i/RQDuYoi5kioOSFIFswUbVyFTnnwxSo9rvjPxa742VClETjVn9d2H4yo1f47LiaC5go8zLucGZY/RUI7EL4degIShgicQkuGNv2ziC6VUtmu8pI2U1TEWKSsDlUMq0aascGVHt0jCOwrYVYgT4UDgDTN91SKF0QKumZ76o2HRaWvalkAYPXN8C/enPqu1qVgWETr/jlqpDrtj3yfS
 z32ixwrf
 zxQ4OME5ccx0IXllTrdk9RXv4uwvIe1iWctvjgcascsd5FG9RYx2YIkP2kXB/SOm5tBQkZdwGme4cUTQoPR83DPS3lAEE9Dqm8skZ7CmUl/wcZIyMYKxMvoK7vRCF0P8FdovqqREw/AElefBmG/u+24HwKMfpyTMNdpzU02hK9MDk4ulQTj+Lb5TWV+F5xAmBlzOmptImMnuE/Os2bDax6AjNLbuDYAtMWOvKkypvbxXd92oReRZ3S9WU1tdmYdfigZbvXnTEN2L0vhbhUQLsciLzgoztRoSV2s9DJQKFiZxWhr/bE9dxaEeaU8oC0kTkyr+m5oRKqnoLHiH+L3jnJZIAhzoU19QVGlQ/tWY2OmLFYi1iKRABZBisjwJB6OUA14Dhc7A5Uy3Jpxtk1jfGvZs5lLP1EmeL9zSoAKtP8fEYtLqOrZzgbjRBbEBvoreTaLgvdb4Ba3BAqJfVcts1mbMEzj7xGBgd4S/k8Uucg8PtMo0NNyxvPefya9OZxtQ3cG9X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/21/25 07:30, Balbir Singh wrote:

> On 8/14/25 17:19, Mika Penttilä wrote:
>> As of this writing, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It also tricky to code correctly.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>>
>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  include/linux/hmm.h     |  10 +-
>>  include/linux/migrate.h |   6 +-
>>  mm/hmm.c                | 351 ++++++++++++++++++++++++++++++++++++++--
>>  mm/migrate_device.c     |  72 ++++++++-
>>  4 files changed, 420 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>> index db75ffc949a7..7485e549c675 100644
>> --- a/include/linux/hmm.h
>> +++ b/include/linux/hmm.h
>> @@ -12,7 +12,7 @@
>>  #include <linux/mm.h>
>>  
>>  struct mmu_interval_notifier;
>> -
>> +struct migrate_vma;
>>  /*
>>   * On output:
>>   * 0             - The page is faultable and a future call with 
>> @@ -48,11 +48,14 @@ enum hmm_pfn_flags {
>>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>>  
>> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
>> +	/* Migrate request */
>> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
>> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 12),
>>  
>>  	/* Input flags */
>>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
>> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>>  
>>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>>  };
>> @@ -107,6 +110,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>>   * @dev_private_owner: owner of device private pages
>> + * @migrate: structure for migrating the associated vma
>>   */
>>  struct hmm_range {
>>  	struct mmu_interval_notifier *notifier;
>> @@ -117,12 +121,14 @@ struct hmm_range {
>>  	unsigned long		default_flags;
>>  	unsigned long		pfn_flags_mask;
>>  	void			*dev_private_owner;
>> +	struct migrate_vma      *migrate;
>>  };
>>  
>>  /*
>>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>>   */
>>  int hmm_range_fault(struct hmm_range *range);
>> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>>  
>>  /*
>>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index acadd41e0b5c..ab35d0f1f65d 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -3,6 +3,7 @@
>>  #define _LINUX_MIGRATE_H
>>  
>>  #include <linux/mm.h>
>> +#include <linux/hmm.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/migrate_mode.h>
>>  #include <linux/hugetlb.h>
>> @@ -143,10 +144,11 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>>  }
>>  
>> -enum migrate_vma_direction {
>> +enum migrate_vma_info {
>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>> +	MIGRATE_VMA_FAULT = 1 << 3,
>>  };
>>  
> I suspect there are some points of conflict with my series that can be resolved

Yes there are some, I have also been looking into them and seem not too bad.

>
>>  struct migrate_vma {
>> @@ -194,7 +196,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>>  			unsigned long npages);
>>  void migrate_device_finalize(unsigned long *src_pfns,
>>  			unsigned long *dst_pfns, unsigned long npages);
>> -
>> +void migrate_hmm_range_setup(struct hmm_range *range);
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #endif /* _LINUX_MIGRATE_H */
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index d545e2494994..8cb2b325fa9f 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/swapops.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/migrate.h>
>>  #include <linux/memremap.h>
>>  #include <linux/sched/mm.h>
>>  #include <linux/jump_label.h>
>> @@ -33,6 +34,10 @@
>>  struct hmm_vma_walk {
>>  	struct hmm_range	*range;
>>  	unsigned long		last;
>> +	struct mmu_notifier_range mmu_range;
>> +	struct vm_area_struct 	*vma;
>> +	unsigned long 		start;
>> +	unsigned long 		end;
>>  };
>>  
>>  enum {
>> @@ -47,15 +52,33 @@ enum {
>>  			      HMM_PFN_P2PDMA_BUS,
>>  };
>>  
>> +static enum migrate_vma_info hmm_want_migrate(struct hmm_range *range)
> hmm_want_migrate -> hmm_select_and_migrate?

Yeah maybe that's better

>
>> +{
>> +	enum migrate_vma_info minfo;
>> +
>> +	minfo = range->migrate ? range->migrate->flags : 0;
>> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
>> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
>> +
> Just to understand, this selects just system pages

Yes it indicates the migration type for the fault path (migrate on fault).

>
>> +	return minfo;
>> +}
>> +
>>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>> -			 struct hmm_range *range, unsigned long cpu_flags)
>> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>>  {
>> +	struct hmm_range *range = hmm_vma_walk->range;
>>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
>>  
>> +	if (cpu_flags != HMM_PFN_ERROR)
>> +		if (hmm_want_migrate(range) &&
>> +		    (vma_is_anonymous(hmm_vma_walk->vma)))
>> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
>> +
>>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>  		range->hmm_pfns[i] |= cpu_flags;
>>  	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -171,11 +194,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>>  	if (!walk->vma) {
>>  		if (required_fault)
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  	if (required_fault)
>>  		return hmm_vma_fault(addr, end, required_fault, walk);
>> -	return hmm_pfns_fill(addr, end, range, 0);
>> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>>  }
>>  
>>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
>> @@ -326,6 +349,257 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  	return hmm_vma_fault(addr, end, required_fault, walk);
>>  }
>>  
>> +/*
>> + * Install migration entries if migration requested, either from fault
>> + * or migrate paths.
>> + *
>> + */
>> +static void hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>> +					   pmd_t *pmdp,
>> +					   unsigned long addr,
>> +					   unsigned long *hmm_pfn)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct mm_struct *mm = walk->vma->vm_mm;
>> +	struct folio *fault_folio = NULL;
>> +	enum migrate_vma_info minfo;
>> +	struct dev_pagemap *pgmap;
>> +	bool anon_exclusive;
>> +	struct folio *folio;
>> +	unsigned long pfn;
>> +	struct page *page;
>> +	swp_entry_t entry;
>> +	pte_t pte, swp_pte;
>> +	spinlock_t *ptl;
>> +	bool writable = false;
>> +	pte_t *ptep;
>> +
>> +
>> +	// Do we want to migrate at all?
>> +	minfo = hmm_want_migrate(range);
>> +	if (!minfo)
>> +		return;
>> +
>> +	fault_folio = (migrate && migrate->fault_page) ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>> +	if (!ptep)
>> +		return;
>> +
>> +	pte = ptep_get(ptep);
>> +
>> +	if (pte_none(pte)) {
>> +		// migrate without faulting case
>> +		if (vma_is_anonymous(walk->vma))
>> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
>> +		goto out;
>> +	}
>> +
>> +	if (!(*hmm_pfn & HMM_PFN_VALID))
>> +		goto out;
>> +
>> +	if (!pte_present(pte)) {
>> +		/*
>> +		 * Only care about unaddressable device page special
>> +		 * page table entry. Other special swap entries are not
>> +		 * migratable, and we ignore regular swapped page.
>> +		 */
>> +		entry = pte_to_swp_entry(pte);
>> +		if (!is_device_private_entry(entry))
>> +			goto out;
>> +
>> +		// We have already checked that are the pgmap owners
>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>> +			goto out;
>> +
>> +		page = pfn_swap_entry_to_page(entry);
>> +		pfn = page_to_pfn(page);
>> +		if (is_writable_device_private_entry(entry))
>> +			writable = true;
>> +	} else {
>> +		pfn = pte_pfn(pte);
>> +		if (is_zero_pfn(pfn) &&
>> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
>> +			goto out;
>> +		}
>> +		page = vm_normal_page(walk->vma, addr, pte);
>> +		if (page && !is_zone_device_page(page) &&
>> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>> +			goto out;
>> +		} else if (page && is_device_coherent_page(page)) {
>> +			pgmap = page_pgmap(page);
>> +
>> +			if (!(minfo &
>> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
>> +			    pgmap->owner != migrate->pgmap_owner)
>> +				goto out;
>> +		}
>> +		writable = pte_write(pte);
>> +	}
>> +
>> +	/* FIXME support THP */
>> +	if (!page || !page->mapping || PageTransCompound(page))
>> +		goto out;
>> +
>> +	/*
>> +	 * By getting a reference on the folio we pin it and that blocks
>> +	 * any kind of migration. Side effect is that it "freezes" the
>> +	 * pte.
>> +	 *
>> +	 * We drop this reference after isolating the folio from the lru
>> +	 * for non device folio (device folio are not on the lru and thus
>> +	 * can't be dropped from it).
>> +	 */
>> +	folio = page_folio(page);
>> +	folio_get(folio);
>> +
>> +	/*
>> +	 * We rely on folio_trylock() to avoid deadlock between
>> +	 * concurrent migrations where each is waiting on the others
>> +	 * folio lock. If we can't immediately lock the folio we fail this
>> +	 * migration as it is only best effort anyway.
>> +	 *
>> +	 * If we can lock the folio it's safe to set up a migration entry
>> +	 * now. In the common case where the folio is mapped once in a
>> +	 * single process setting up the migration entry now is an
>> +	 * optimisation to avoid walking the rmap later with
>> +	 * try_to_migrate().
>> +	 */
>> +
>> +	if (fault_folio == folio || folio_trylock(folio)) {
>> +		anon_exclusive = folio_test_anon(folio) &&
>> +			PageAnonExclusive(page);
>> +
>> +		flush_cache_page(walk->vma, addr, pfn);
>> +
>> +		if (anon_exclusive) {
>> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
>> +
>> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
>> +				set_pte_at(mm, addr, ptep, pte);
>> +				folio_unlock(folio);
>> +				folio_put(folio);
>> +				goto out;
>> +			}
>> +		} else {
>> +			pte = ptep_get_and_clear(mm, addr, ptep);
>> +		}
>> +
>> +		/* Setup special migration page table entry */
>> +		if (writable)
>> +			entry = make_writable_migration_entry(pfn);
>> +		else if (anon_exclusive)
>> +			entry = make_readable_exclusive_migration_entry(pfn);
>> +		else
>> +			entry = make_readable_migration_entry(pfn);
>> +
>> +		swp_pte = swp_entry_to_pte(entry);
>> +		if (pte_present(pte)) {
>> +			if (pte_soft_dirty(pte))
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (pte_uffd_wp(pte))
>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +		} else {
>> +			if (pte_swp_soft_dirty(pte))
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (pte_swp_uffd_wp(pte))
>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +		}
>> +
>> +		set_pte_at(mm, addr, ptep, swp_pte);
>> +		folio_remove_rmap_pte(folio, page, walk->vma);
>> +		folio_put(folio);
>> +		*hmm_pfn |= HMM_PFN_MIGRATE;
>> +
>> +		if (pte_present(pte))
>> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
>> +	} else
>> +		folio_put(folio);
>> +out:
>> +	pte_unmap_unlock(ptep, ptl);
>> +
>> +}
>> +
>> +static int hmm_vma_walk_split(pmd_t *pmdp,
>> +			      unsigned long addr,
>> +			      struct mm_walk *walk)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct folio *folio, *fault_folio;
>> +	spinlock_t *ptl;
>> +	int ret = 0;
>> +
>> +	fault_folio = (migrate && migrate->fault_page) ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	ptl = pmd_lock(walk->mm, pmdp);
>> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
>> +		spin_unlock(ptl);
>> +		goto out;
>> +	}
>> +
>> +	folio = pmd_folio(*pmdp);
>> +	if (is_huge_zero_folio(folio)) {
>> +		spin_unlock(ptl);
>> +		split_huge_pmd(walk->vma, pmdp, addr);
>> +	} else {
>> +		folio_get(folio);
>> +		spin_unlock(ptl);
>> +		/* FIXME: we don't expect THP for fault_folio */
>> +		if (WARN_ON_ONCE(fault_folio == folio)) {
>> +			folio_put(folio);
>> +			ret = -EBUSY;
>> +			goto out;
>> +		}
>> +		if (unlikely(!folio_trylock(folio))) {
>> +			folio_put(folio);
>> +			ret = -EBUSY;
>> +			goto out;
>> +		}
>> +		ret = split_folio(folio);
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int hmm_vma_capture_migrate_range(unsigned long start,
>> +					 unsigned long end,
>> +					 struct mm_walk *walk)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +
>> +	if (!hmm_want_migrate(range))
>> +		return 0;
>> +
>> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
>> +		return -ERANGE;
>> +
>> +	hmm_vma_walk->vma = walk->vma;
>> +	hmm_vma_walk->start = start;
>> +	hmm_vma_walk->end = end;
>> +
>> +	if (end - start > range->end - range->start)
>> +		return -ERANGE;
>> +
>> +	if (!hmm_vma_walk->mmu_range.owner) {
>> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
>> +					      walk->vma->vm_mm, start, end,
>> +					      range->dev_private_owner);
>> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  			    unsigned long start,
>>  			    unsigned long end,
>> @@ -351,13 +625,28 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  			pmd_migration_entry_wait(walk->mm, pmdp);
>>  			return -EBUSY;
>>  		}
>> -		return hmm_pfns_fill(start, end, range, 0);
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>>  	}
>>  
>>  	if (!pmd_present(pmd)) {
>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +	}
>> +
>> +	if (hmm_want_migrate(range) &&
>> +	    pmd_trans_huge(pmd)) {
>> +		int r;
>> +
>> +		r = hmm_vma_walk_split(pmdp, addr, walk);
>> +		if (r) {
>> +			/* Split not successful, skip */
>> +			return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +		}
>> +
>> +		/* Split successful or "again", reloop */
>> +		hmm_vma_walk->last = addr;
>> +		return -EBUSY;
>>  	}
>>  
>>  	if (pmd_trans_huge(pmd)) {
>> @@ -386,7 +675,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  	if (pmd_bad(pmd)) {
>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  
>>  	ptep = pte_offset_map(pmdp, addr);
>> @@ -400,8 +689,11 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  			/* hmm_vma_handle_pte() did pte_unmap() */
>>  			return r;
>>  		}
>> +
>> +		hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
>>  	}
>>  	pte_unmap(ptep - 1);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -535,6 +827,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>  	struct hmm_range *range = hmm_vma_walk->range;
>>  	struct vm_area_struct *vma = walk->vma;
>> +	int r;
>> +
>> +	r = hmm_vma_capture_migrate_range(start, end, walk);
>> +	if (r)
>> +		return r;
>>  
>>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>>  	    vma->vm_flags & VM_READ)
>> @@ -557,7 +854,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>  				 (end - start) >> PAGE_SHIFT, 0))
>>  		return -EFAULT;
>>  
>> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  
>>  	/* Skip this vma and continue processing the next vma. */
>>  	return 1;
>> @@ -587,9 +884,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>>   *		the invalidation to finish.
>>   * -EFAULT:     A page was requested to be valid and could not be made valid
>>   *              ie it has no backing VMA or it is illegal to access
>> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
>> + *              is too low.
>>   *
>>   * This is similar to get_user_pages(), except that it can read the page tables
>>   * without mutating them (ie causing faults).
>> + *
>> + * If want to do migrate after faultin, call hmm_range_fault() with
>> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
>> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
>> + * migrate_vma_setup() and after that follow normal migrate calls path.
>> + *
>>   */
>>  int hmm_range_fault(struct hmm_range *range)
>>  {
>> @@ -597,16 +902,28 @@ int hmm_range_fault(struct hmm_range *range)
>>  		.range = range,
>>  		.last = range->start,
>>  	};
>> -	struct mm_struct *mm = range->notifier->mm;
>> +	bool is_fault_path = !!range->notifier;
>> +	struct mm_struct *mm;
>>  	int ret;
>>  
>> +	/*
>> +	 *
>> +	 *  Could be serving a device fault or come from migrate
>> +	 *  entry point. For the former we have not resolved the vma
>> +	 *  yet, and the latter we don't have a notifier (but have a vma).
>> +	 *
>> +	 */
>> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
>>  	mmap_assert_locked(mm);
>>  
>>  	do {
>>  		/* If range is no longer valid force retry. */
>> -		if (mmu_interval_check_retry(range->notifier,
>> -					     range->notifier_seq))
>> -			return -EBUSY;
>> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
>> +					     range->notifier_seq)) {
>> +			ret = -EBUSY;
>> +			break;
>> +		}
>> +
>>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>>  				      &hmm_walk_ops, &hmm_vma_walk);
>>  		/*
>> @@ -616,6 +933,18 @@ int hmm_range_fault(struct hmm_range *range)
>>  		 * output, and all >= are still at their input values.
>>  		 */
>>  	} while (ret == -EBUSY);
>> +
>> +	if (hmm_want_migrate(range) && range->migrate &&
>> +	    hmm_vma_walk.mmu_range.owner) {
>> +		// The migrate_vma path has the following initialized
>> +		if (is_fault_path) {
>> +			range->migrate->vma   = hmm_vma_walk.vma;
>> +			range->migrate->start = range->start;
>> +			range->migrate->end   = hmm_vma_walk.end;
>> +		}
>> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
>> +	}
>> +
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(hmm_range_fault);
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index e05e14d6eacd..87ddc0353165 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -535,7 +535,18 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>>   */
>>  int migrate_vma_setup(struct migrate_vma *args)
>>  {
>> +	int ret;
>>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>> +	struct hmm_range range = {
>> +		.notifier = NULL,
>> +		.start = args->start,
>> +		.end = args->end,
>> +		.migrate = args,
>> +		.hmm_pfns = args->src,
>> +		.default_flags = HMM_PFN_REQ_MIGRATE,
>> +		.dev_private_owner = args->pgmap_owner,
>> +		.migrate = args
>> +	};
>>  
>>  	args->start &= PAGE_MASK;
>>  	args->end &= PAGE_MASK;
>> @@ -560,17 +571,19 @@ int migrate_vma_setup(struct migrate_vma *args)
>>  	args->cpages = 0;
>>  	args->npages = 0;
>>  
>> -	migrate_vma_collect(args);
>> +	if (args->flags & MIGRATE_VMA_FAULT)
>> +		range.default_flags |= HMM_PFN_REQ_FAULT;
>>  
>> -	if (args->cpages)
>> -		migrate_vma_unmap(args);
>> +	ret = hmm_range_fault(&range);
>> +
>> +	migrate_hmm_range_setup(&range);
>>  
>>  	/*
>>  	 * At this point pages are locked and unmapped, and thus they have
>>  	 * stable content and can safely be copied to destination memory that
>>  	 * is allocated by the drivers.
>>  	 */
>> -	return 0;
>> +	return ret;
>>  
>>  }
>>  EXPORT_SYMBOL(migrate_vma_setup);
>> @@ -1014,3 +1027,54 @@ int migrate_device_coherent_folio(struct folio *folio)
>>  		return 0;
>>  	return -EBUSY;
>>  }
>> +
>> +void migrate_hmm_range_setup(struct hmm_range *range)
>> +{
>> +
>> +	struct migrate_vma *migrate = range->migrate;
>> +
>> +	if (!migrate)
>> +		return;
>> +
>> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
>> +	migrate->cpages = 0;
>> +
>> +	for (unsigned long i = 0; i < migrate->npages; i++) {
>> +
>> +		unsigned long pfn = range->hmm_pfns[i];
>> +
>> +		/*
>> +		 *
>> +		 *  Don't do migration if valid and migrate flags are not both set.
>> +		 *
>> +		 */
>> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
>> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
>> +			migrate->src[i] = 0;
>> +			migrate->dst[i] = 0;
>> +			continue;
>> +		}
>> +
>> +		migrate->cpages++;
>> +
>> +		/*
>> +		 *
>> +		 * The zero page is encoded in a special way, valid and migrate is
>> +		 * set, and pfn part is zero. Encode specially for migrate also.
>> +		 *
>> +		 */
>> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
>> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
>> +			continue;
>> +		}
>> +
>> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
>> +			| MIGRATE_PFN_MIGRATE;
>> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
>> +	}
>> +
>> +	if (migrate->cpages)
>> +		migrate_vma_unmap(migrate);
>> +
>> +}
>> +EXPORT_SYMBOL(migrate_hmm_range_setup);
>
> I've not had a chance to test the code, do you have any numbers with the changes
> to show the advantages of doing both fault and migrate together?

Not yet, but plan to have some numbers later. 

>
> Balbir
>
Thanks,
--Mika


