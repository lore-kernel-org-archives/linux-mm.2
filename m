Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83E9D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9146B0005; Wed, 21 Jan 2026 03:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287276B0088; Wed, 21 Jan 2026 03:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172556B0089; Wed, 21 Jan 2026 03:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0377E6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:05:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC181AF824
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:05:12 +0000 (UTC)
X-FDA: 84355235664.06.DA2B61B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38D0D1C0002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:05:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F5uEdu6/";
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768982710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiuCPaQ6y66CwHu1niFEC+ixeY8SAH33F9VRoniFSg8=;
	b=eYKAPptB6Qwpk3K4dFkKgGXsTdGjsxuoS5Q/hxZqfSSANIUwiOB4C7wluMgk141GJM3kMI
	zWF6ripd+VGjbfWOTHmk/3aS98xRdgAO0P7P6fQtc5+UWUQFIBfH8RiIl1iWYC0bDhvfNt
	PfPSMub+3YSOuqqTCwl6lbnoyjMPQO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F5uEdu6/";
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768982710; a=rsa-sha256;
	cv=none;
	b=K+Gqg6kL8CNGX/BocRWeiw5xNoZfGxg3AoVV2WKckaBcust3M8CHhIWQtlufN6SW+mk8tE
	5u3MXR8e0AZtVEzYkuWiXYFs0k8qidMYGLDl+C16zG9Oa//+EZ30VJ+eyavZFTrYCGcn2z
	YxnhCjdu98NjBBYpR/upS+19qzrwZnA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768982708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IiuCPaQ6y66CwHu1niFEC+ixeY8SAH33F9VRoniFSg8=;
	b=F5uEdu6/wNy2b4SHhM3C7X/C/OC8cOmmZsIy84lPEpoAmm6HL9K7uRiNR2fPOELS1RrhKy
	2iKWHsQVR8fTZQTmj+E6ixpslXvreo+3f58FwJc7Ufi98/uvatAP51QYATIm350yj8GQaK
	5xSOPDUg/z0kCrkEpPE4FJts5IV5E44=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-uPo_el1RPi2J7R4f-hgjSA-1; Wed, 21 Jan 2026 03:05:03 -0500
X-MC-Unique: uPo_el1RPi2J7R4f-hgjSA-1
X-Mimecast-MFC-AGG-ID: uPo_el1RPi2J7R4f-hgjSA_1768982702
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59b7972367fso3063787e87.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768982702; x=1769587502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IiuCPaQ6y66CwHu1niFEC+ixeY8SAH33F9VRoniFSg8=;
        b=IVW3YSTSbNbQU2qWmwCCV0QISqLhx0SDpk9FwEh0ZwalG73DAG9UD950CVRVykRErB
         5f0WN1TJTdg504OyO1AuyLV0zacUgUlpM3Q8ywJ8XKZjNfr1sYWOSelQ5BW/y4PMbhjs
         tDLcbTDrHPTvR9JFfIgu3IR7ytWTOa2E0/HK4sgopzmw29Gu6N2MHx8LQ+0KkVAbFbgM
         N+6ZVVTgwmsN7jAmcfq3kqY+bSSvVf1Y+VLrNa62ysiUgN2L0cuqCUe1C2rmdLYItjRw
         j9ASFuokb9oC/n56Q1qJVzYpPGE+jaCKp0WkFTceRWe0htyiUozuxDInrrfxlIse1tM1
         emNA==
X-Gm-Message-State: AOJu0YwfvmLsmKRYOPBGqekEZimWdsdzbpNNw200cgVCHQ4jXojcNNON
	ujkfYgWeNX/+bQXPBVAmn0SoWkurVLxY3Jv7qdUWZzOSPnIVisK/dK+anHKJBh+kFiQFO+b9C2p
	BcGfuxGYxuATElL/uMVSsLYypqaRF/J3uzGBjLO54bi3v+MQYTNQ=
X-Gm-Gg: AZuq6aLNuPJP0K2WnjApLXfmAqi8psCXG5LMExPY+CkuhMK+Ybsn4mQkVf3z/0+mAct
	wa+JZfzd1su1NWm2gQAHy7Kza0uOoN0yrG/4G+6WnBM/5FWhfRRxmHWBl9tfYn5Qwa852/vasqt
	BTLNSlUbYDnW9sPgUEmdz5fHyrQOCE80hskhhfB+kg0HtAfnHHP9rlooG6bxdIEWZpua6NyAxfv
	VKBFFfaixKokthN6M3oXmvxsHcVo2Ksa/VqomoyZrMFvc9Vc/3dGnoqKtx1HyU7YnoNDNu1xNBj
	nX6XGtwh5RJAYhKCRgOox6Jy5WqCisWr7Qm/gbqphrfT+xsuYpI+jC0c4JQO44PoY66WCQ1enrB
	BLjpc1GJZI1YZN+psl0KHdhjDbl6g+lm1Efc=
X-Received: by 2002:a05:6512:1592:b0:598:eed6:4975 with SMTP id 2adb3069b0e04-59baef0bc12mr6310275e87.48.1768982701623;
        Wed, 21 Jan 2026 00:05:01 -0800 (PST)
X-Received: by 2002:a05:6512:1592:b0:598:eed6:4975 with SMTP id 2adb3069b0e04-59baef0bc12mr6310255e87.48.1768982701027;
        Wed, 21 Jan 2026 00:05:01 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf33eb76sm4693651e87.10.2026.01.21.00.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 00:05:00 -0800 (PST)
Message-ID: <a326dfbc-a1cb-473d-b69c-28d6f292c2ec@redhat.com>
Date: Wed, 21 Jan 2026 10:05:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
References: <20260119112502.645059-1-mpenttil@redhat.com>
 <20260119112502.645059-2-mpenttil@redhat.com>
 <aW+nOf33ojgyaQUv@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aW+nOf33ojgyaQUv@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WAAEzzIFcBwv9IipMEnMa5QLwx6B_DovKYE8NxWzBrE_1768982702
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 38D0D1C0002
X-Stat-Signature: uhe36dx1n4b3ho3btmqyti86c797iif4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768982710-524975
X-HE-Meta: U2FsdGVkX19BeSa2oRAMtvjhPZUqQS7Cjrh5zPoLk5hyOwYYv8LL5X+wxDPFf2iTE9G+aAqbpVhUd76V51y0UVaLBgQvG8GxT0/aNdpWLcLvogUb8+pycEd9s8PgwCSdaPskNi/upalMpZZtndxbzHj4qdHaw9pLGVkxZ3jiLBFnuIfD3yUnXxjb/NGBkgGSQKQ0mahnxqTE/alvPLoxi1PAr+HFWO/jcSLW7CNKcg/XDwaOYgjBgjJ6kkXa4fmZRNZLTJCUkKwX45QrmcY4c7Cj7Ecnzd0mpcXs2xZL0ypjVJRjDD4+kqFyumtONz4IAeZ5d8yWhF5rNhcJUSvB5KsCqaXa7Vyfm6QQr4SNQFoSwnNTepDmo7OnUffmgwnIIaVpEbUka6OtzH6d/+fVFVP660kKW9ctNvi0q/11lm4G37hS/5Kwl6Fjp6cqIDWYdois75M5zO/8g1JfnpNUnMPSjZWWED8lzic9F5YXGbesP/J84vcfYA3JUyNTHgu1mDPeGX87K1Sk/6gyjy6cO93QdPj0OM46ljy2l3eRfep1VE8ASuLrH9H7bbrs6v8Zv4f3aOLpCypNAxtpFYb+jCSZanUm7hWDR4sAQJnZjehchosOt47ImFMA9zwIOO63PSzG41JG21lnAcDHFDEQQ5EGsDoTBa+4KXtGGtbY40yFuMp/PIui8dfrvWR66oAzKHnnQP9I8Iac1g8S4x5Zxo4rGmPuUB37OwIVheFOpCotLI54zvt7lUkIaYi7Z2R3EJReS6gSUZl9r30PLbbCAGxtxtniJCfMGV73lB3+yJNp2cyvnUivgberHNMbsh0E3pPX4Mx+HCpFg0G//ttheT8JchCDnRA+6uX+4yvCmAhLBbFoVa3jAqa5+ePIx9RR0BEPErkobfxn+6IDx279R+coVAcpH0VvAMMWfDJTVFfaDwirvibCfdbCZ5bLdnDiZeO8vNmMSHT0XEVg1EE
 jWyKunTy
 ALVhBSzOA7n2+TxW8OCEWEbUEn4scMzXTfp5XkLK6zvkGdtIyguFvqhWXqTlkn14zZcoPmb/L4OeN86dUL2qfnLiIs1VMa8K8qM4ebUG3NXmXrdKc7OJgr39zDnFC7EkgwKX/B/qsjGCJSlgUamWYfm0e1zioFoJCu28zl2baxRWmqHt1xP04oW3ces3QpFtobQI21j0Nme9AbsVFz1W1h1M0wSIZfk5afTL9WnMdi1mrThPqJ2ms60ylINO6nIcnjYDyn29Dp1gpwVbW5z29pNpnrIy8uKPMJt5WbU1sYpU+S0i19Z+BCdOECRUXbZwhCeDuzTwBirmxzAy1JkC6A1Lk8LRBju3PY26h2qHpVHEbzXQe/esQsWy8jb52J+Ub1O/RBJzOA5vnByQt8S8y88P2UFEikJcs4FCGs5DlQS8PWVcEAsQzsPt/gv+FX7e+dO/uK0+lrsmziyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/20/26 18:03, Matthew Brost wrote:

> On Mon, Jan 19, 2026 at 01:25:00PM +0200, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
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
>> migration). It is also tricky to code correctly.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
> A couple of comments/questions around the locking. Personally, I like
> the approach, but its of the maintianers if they like it. I also haven't
> pulled or tested this yet and likely won't have time for at least a few
> days, so all comments are based on inspection.

Thanks, your comments are valid. Will prepare  a v3 with those addressed and fixed.

>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  include/linux/hmm.h     |  19 +-
>>  include/linux/migrate.h |  27 +-
>>  mm/hmm.c                | 770 +++++++++++++++++++++++++++++++++++++---
>>  mm/migrate_device.c     |  86 ++++-
>>  4 files changed, 839 insertions(+), 63 deletions(-)
>>
>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>> index db75ffc949a7..e2f53e155af2 100644
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
>> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>>   *                      to mark that page is already DMA mapped
>> + * HMM_PFN_MIGRATE    - Migrate PTE installed
>>   *
>>   * On input:
>>   * 0                 - Return the current state of the page, do not fault it.
>> @@ -34,6 +35,7 @@ struct mmu_interval_notifier;
>>   *                     will fail
>>   * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
>>   *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
>> + * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
>>   */
>>  enum hmm_pfn_flags {
>>  	/* Output fields and flags */
>> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
>>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>>  
>> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
>> +	/* Migrate request */
>> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
>> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
>> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>>  
>>  	/* Input flags */
>>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
>> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>>  
>>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>>  };
>>  
>> +enum {
>> +	/* These flags are carried from input-to-output */
>> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>> +		HMM_PFN_P2PDMA_BUS,
>> +};
>> +
>>  /*
>>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>>   *
>> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>>   * @dev_private_owner: owner of device private pages
>> + * @migrate: structure for migrating the associated vma
>>   */
>>  struct hmm_range {
>>  	struct mmu_interval_notifier *notifier;
>> @@ -117,12 +130,14 @@ struct hmm_range {
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
>> index 26ca00c325d9..104eda2dd881 100644
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
>> @@ -97,6 +98,16 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>>  	return -ENOSYS;
>>  }
>>  
>> +enum migrate_vma_info {
>> +	MIGRATE_VMA_SELECT_NONE = 0,
>> +	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
>> +};
>> +
>> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>> +{
>> +	return MIGRATE_VMA_SELECT_NONE;
>> +}
>> +
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #ifdef CONFIG_NUMA_BALANCING
>> @@ -140,11 +151,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>>  }
>>  
>> -enum migrate_vma_direction {
>> +enum migrate_vma_info {
>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>> +	MIGRATE_VMA_FAULT = 1 << 4,
>>  };
>>  
>>  struct migrate_vma {
>> @@ -182,6 +194,17 @@ struct migrate_vma {
>>  	struct page		*fault_page;
>>  };
>>  
>> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>> +{
>> +	enum migrate_vma_info minfo;
>> +
>> +	minfo = range->migrate ? range->migrate->flags : 0;
>> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
>> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
>> +
>> +	return minfo;
>> +}
>> +
>>  int migrate_vma_setup(struct migrate_vma *args);
>>  void migrate_vma_pages(struct migrate_vma *migrate);
>>  void migrate_vma_finalize(struct migrate_vma *migrate);
>> @@ -192,7 +215,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>>  			unsigned long npages);
>>  void migrate_device_finalize(unsigned long *src_pfns,
>>  			unsigned long *dst_pfns, unsigned long npages);
>> -
>> +void migrate_hmm_range_setup(struct hmm_range *range);
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #endif /* _LINUX_MIGRATE_H */
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 4ec74c18bef6..1fdb8665eeec 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/migrate.h>
>>  #include <linux/memremap.h>
>>  #include <linux/sched/mm.h>
>>  #include <linux/jump_label.h>
>> @@ -27,12 +28,20 @@
>>  #include <linux/pci-p2pdma.h>
>>  #include <linux/mmu_notifier.h>
>>  #include <linux/memory_hotplug.h>
>> +#include <asm/tlbflush.h>
>>  
>>  #include "internal.h"
>>  
>>  struct hmm_vma_walk {
>> -	struct hmm_range	*range;
>> -	unsigned long		last;
>> +	struct mmu_notifier_range	mmu_range;
>> +	struct vm_area_struct		*vma;
>> +	struct hmm_range		*range;
>> +	unsigned long			start;
>> +	unsigned long			end;
>> +	unsigned long			last;
>> +	bool				locked;
>> +	bool				pmdlocked;
>> +	spinlock_t			*ptl;
>>  };
>>  
>>  enum {
>> @@ -41,21 +50,38 @@ enum {
>>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>>  };
>>  
>> -enum {
>> -	/* These flags are carried from input-to-output */
>> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>> -			      HMM_PFN_P2PDMA_BUS,
>> -};
>> -
>>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>> -			 struct hmm_range *range, unsigned long cpu_flags)
>> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>>  {
>> +	struct hmm_range *range = hmm_vma_walk->range;
>>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
>> +	enum migrate_vma_info minfo;
>> +	bool migrate = false;
>> +
>> +	minfo = hmm_select_migrate(range);
>> +	if (cpu_flags != HMM_PFN_ERROR) {
>> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
>> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
>> +			migrate = true;
>> +		}
>> +	}
>> +
>> +	if (migrate && thp_migration_supported() &&
>> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
>> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
>> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
>> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
>> +		addr += PAGE_SIZE;
>> +		i++;
>> +		cpu_flags = 0;
>> +	}
>>  
>>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>  		range->hmm_pfns[i] |= cpu_flags;
>>  	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -171,11 +197,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>>  	if (!walk->vma) {
>>  		if (required_fault)
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  	if (required_fault)
>>  		return hmm_vma_fault(addr, end, required_fault, walk);
> Can we assert in hmm_vma_fault that neither the PMD nor the PTE lock is
> held? That would be a quick sanity check to ensure we haven’t screwed
> anything up in the state-machine walk.
>
> We could add marco like HMM_ASSERT or HMM_WARN, etc...

Good idea, will add.

>
>> -	return hmm_pfns_fill(addr, end, range, 0);
>> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>>  }
>>  
>>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
>> @@ -208,8 +234,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>>  	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
>>  	required_fault =
>>  		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
>> -	if (required_fault)
>> +	if (required_fault) {
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
>> +		}
>>  		return hmm_vma_fault(addr, end, required_fault, walk);
>> +	}
>>  
>>  	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>  	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
>> @@ -289,14 +320,28 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  			goto fault;
>>  
>>  		if (softleaf_is_migration(entry)) {
>> -			pte_unmap(ptep);
>> -			hmm_vma_walk->last = addr;
>> -			migration_entry_wait(walk->mm, pmdp, addr);
>> -			return -EBUSY;
>> +			if (!hmm_select_migrate(range)) {
>> +				if (hmm_vma_walk->locked) {
>> +					pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +					hmm_vma_walk->locked = false;
> I don’t think it should be possible for the lock to be held here, given
> that we only take it when selecting migration. So maybe we should assert
> that it is not locked.

Correct. Will fix.

>
>> +				} else
>> +					pte_unmap(ptep);
>> +
>> +				hmm_vma_walk->last = addr;
>> +				migration_entry_wait(walk->mm, pmdp, addr);
>> +				return -EBUSY;
>> +			} else
>> +				goto out;
>>  		}
>>  
>>  		/* Report error for everything else */
>> -		pte_unmap(ptep);
>> +
>> +		if (hmm_vma_walk->locked) {
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->locked = false;
>> +		} else
>> +			pte_unmap(ptep);
>> +
>>  		return -EFAULT;
>>  	}
>>  
>> @@ -313,7 +358,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  	if (!vm_normal_page(walk->vma, addr, pte) &&
>>  	    !is_zero_pfn(pte_pfn(pte))) {
>>  		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
>> -			pte_unmap(ptep);
>> +			if (hmm_vma_walk->locked) {
>> +				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +				hmm_vma_walk->locked = false;
>> +			} else
>> +				pte_unmap(ptep);
>> +
>>  			return -EFAULT;
>>  		}
>>  		new_pfn_flags = HMM_PFN_ERROR;
>> @@ -326,7 +376,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  	return 0;
>>  
>>  fault:
>> -	pte_unmap(ptep);
>> +	if (hmm_vma_walk->locked) {
>> +		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +		hmm_vma_walk->locked = false;
>> +	} else
>> +		pte_unmap(ptep);
>>  	/* Fault any virtual address we were asked to fault */
>>  	return hmm_vma_fault(addr, end, required_fault, walk);
>>  }
>> @@ -370,13 +424,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
>>  					      npages, 0);
>>  	if (required_fault) {
>> -		if (softleaf_is_device_private(entry))
>> +		if (softleaf_is_device_private(entry)) {
>> +			if (hmm_vma_walk->pmdlocked) {
>> +				spin_unlock(hmm_vma_walk->ptl);
>> +				hmm_vma_walk->pmdlocked = false;
>> +			}
>>  			return hmm_vma_fault(addr, end, required_fault, walk);
>> +		}
>>  		else
>>  			return -EFAULT;
>>  	}
>>  
>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  }
>>  #else
>>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>> @@ -384,15 +443,486 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  				     pmd_t pmd)
>>  {
>>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> -	struct hmm_range *range = hmm_vma_walk->range;
>>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>>  
>>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  		return -EFAULT;
>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  }
>>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>  
>> +#ifdef CONFIG_DEVICE_MIGRATION
>> +/**
>> + * migrate_vma_split_folio() - Helper function to split a THP folio
>> + * @folio: the folio to split
>> + * @fault_page: struct page associated with the fault if any
>> + *
>> + * Returns 0 on success
>> + */
>> +static int migrate_vma_split_folio(struct folio *folio,
>> +				   struct page *fault_page)
>> +{
>> +	int ret;
>> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
>> +	struct folio *new_fault_folio = NULL;
>> +
>> +	if (folio != fault_folio) {
>> +		folio_get(folio);
>> +		folio_lock(folio);
>> +	}
>> +
>> +	ret = split_folio(folio);
>> +	if (ret) {
>> +		if (folio != fault_folio) {
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +		}
>> +		return ret;
>> +	}
>> +
>> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
>> +
>> +	/*
>> +	 * Ensure the lock is held on the correct
>> +	 * folio after the split
>> +	 */
>> +	if (!new_fault_folio) {
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	} else if (folio != new_fault_folio) {
>> +		if (new_fault_folio != fault_folio) {
>> +			folio_get(new_fault_folio);
>> +			folio_lock(new_fault_folio);
>> +		}
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>> +					      pmd_t *pmdp,
>> +					      unsigned long start,
>> +					      unsigned long end,
>> +					      unsigned long *hmm_pfn)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct folio *fault_folio = NULL;
>> +	struct folio *folio;
>> +	enum migrate_vma_info minfo;
>> +	unsigned long i;
>> +	int r = 0;
>> +
>> +	minfo = hmm_select_migrate(range);
>> +	if (!minfo)
>> +		return r;
>> +
> Can we assert the PMD is locked here?

ack

>
>> +	fault_folio = (migrate && migrate->fault_page) ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	if (pmd_none(*pmdp))
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>> +
>> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
>> +		goto out;
>> +
>> +	if (pmd_trans_huge(*pmdp)) {
>> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
>> +			goto out;
>> +
>> +		folio = pmd_folio(*pmdp);
>> +		if (is_huge_zero_folio(folio))
>> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>> +
>> +	} else if (!pmd_present(*pmdp)) {
>> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
>> +
>> +		folio = softleaf_to_folio(entry);
>> +
>> +		if (!softleaf_is_device_private(entry))
>> +			goto out;
>> +
>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>> +			goto out;
>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>> +			goto out;
>> +
>> +	} else {
>> +		hmm_vma_walk->last = start;
>> +		return -EBUSY;
>> +	}
>> +
>> +	folio_get(folio);
>> +
>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>> +		folio_put(folio);
>> +		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +		return 0;
>> +	}
>> +
>> +	if (thp_migration_supported() &&
>> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>> +
>> +		struct page_vma_mapped_walk pvmw = {
>> +			.ptl = hmm_vma_walk->ptl,
>> +			.address = start,
>> +			.pmd = pmdp,
>> +			.vma = walk->vma,
>> +		};
>> +
>> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
>> +
>> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>> +		if (r) {
>> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
>> +			r = -ENOENT;  // fallback
>> +			goto unlock_out;
>> +		}
>> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
>> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
>> +
>> +	} else {
>> +		r = -ENOENT;  // fallback
>> +		goto unlock_out;
>> +	}
>> +
>> +
>> +out:
>> +	return r;
>> +
>> +unlock_out:
>> +	if (folio != fault_folio)
>> +		folio_unlock(folio);
>> +	folio_put(folio);
>> +	goto out;
>> +
>> +}
>> +
>> +/*
>> + * Install migration entries if migration requested, either from fault
>> + * or migrate paths.
>> + *
>> + */
>> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>> +					  pmd_t *pmdp,
>> +					  pte_t *ptep,
>> +					  unsigned long addr,
>> +					  unsigned long *hmm_pfn)
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
>> +	softleaf_t entry;
>> +	pte_t pte, swp_pte;
>> +	bool writable = false;
>> +
>> +	// Do we want to migrate at all?
>> +	minfo = hmm_select_migrate(range);
>> +	if (!minfo)
>> +		return 0;
>> +
> Can we assert the PTE lock is held here?

ack

>
>> +	fault_folio = (migrate && migrate->fault_page) ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	if (!hmm_vma_walk->locked) {
>> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
>> +		hmm_vma_walk->locked = true;
>> +	}
>> +	pte = ptep_get(ptep);
>> +
> How would we get without PTE lock being held? Shouldn't the caller take
> the lock?

This was leftover from previous version when there was a jump to the beginning. Will remove.

>
>> +	if (pte_none(pte)) {
>> +		// migrate without faulting case
>> +		if (vma_is_anonymous(walk->vma)) {
>> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
>> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
>> +		goto out;
>> +
>> +	if (!pte_present(pte)) {
>> +		/*
>> +		 * Only care about unaddressable device page special
>> +		 * page table entry. Other special swap entries are not
>> +		 * migratable, and we ignore regular swapped page.
>> +		 */
>> +		entry = softleaf_from_pte(pte);
>> +		if (!softleaf_is_device_private(entry))
>> +			goto out;
>> +
>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>> +			goto out;
>> +
>> +		page = softleaf_to_page(entry);
>> +		folio = page_folio(page);
>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>> +			goto out;
>> +
>> +		if (folio_test_large(folio)) {
>> +			int ret;
>> +
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->locked = false;
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page);
>> +			if (ret)
>> +				goto out_error;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		pfn = page_to_pfn(page);
>> +		if (softleaf_is_device_private_write(entry))
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
>> +
>> +		folio = page ? page_folio(page) : NULL;
>> +		if (folio && folio_test_large(folio)) {
>> +			int ret;
>> +
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->locked = false;
>> +
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page);
>> +			if (ret)
>> +				goto out_error;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		writable = pte_write(pte);
>> +	}
>> +
>> +	if (!page || !page->mapping)
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
>> +		if (pte_dirty(pte))
>> +			folio_mark_dirty(folio);
>> +
>> +		/* Setup special migration page table entry */
>> +		if (writable)
>> +			entry = make_writable_migration_entry(pfn);
>> +		else if (anon_exclusive)
>> +			entry = make_readable_exclusive_migration_entry(pfn);
>> +		else
>> +			entry = make_readable_migration_entry(pfn);
>> +
>> +		if (pte_present(pte)) {
>> +			if (pte_young(pte))
>> +				entry = make_migration_entry_young(entry);
>> +			if (pte_dirty(pte))
>> +				entry = make_migration_entry_dirty(entry);
>> +		}
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
>> +	return 0;
>> +out_error:
>> +	return -EFAULT;
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
> Assert the PMD lock isn't held?

ack

>
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
>> +
>> +		if (folio != fault_folio) {
>> +			if (unlikely(!folio_trylock(folio))) {
>> +				folio_put(folio);
>> +				ret = -EBUSY;
>> +				goto out;
>> +			}
>> +		}  else
>> +			folio_put(folio);
>> +
>> +		ret = split_folio(folio);
>> +		if (fault_folio != folio) {
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +		}
>> +
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +#else
>> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>> +					      pmd_t *pmdp,
>> +					      unsigned long start,
>> +					      unsigned long end,
>> +					      unsigned long *hmm_pfn)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>> +					  pmd_t *pmdp,
>> +					  pte_t *pte,
>> +					  unsigned long addr,
>> +					  unsigned long *hmm_pfn)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_walk_split(pmd_t *pmdp,
>> +			      unsigned long addr,
>> +			      struct mm_walk *walk)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static int hmm_vma_capture_migrate_range(unsigned long start,
>> +					 unsigned long end,
>> +					 struct mm_walk *walk)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +
>> +	if (!hmm_select_migrate(range))
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
>> @@ -403,43 +933,112 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  	unsigned long *hmm_pfns =
>>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>> +	struct mm_struct *mm = walk->vma->vm_mm;
>>  	unsigned long addr = start;
>> +	enum migrate_vma_info minfo;
>> +	unsigned long i;
>> +	spinlock_t *ptl;
>>  	pte_t *ptep;
>>  	pmd_t pmd;
>> +	int r;
>> +
>> +	minfo = hmm_select_migrate(range);
>>  
>>  again:
>> +	hmm_vma_walk->locked = false;
>> +	hmm_vma_walk->pmdlocked = false;
>>  	pmd = pmdp_get_lockless(pmdp);
>> -	if (pmd_none(pmd))
>> -		return hmm_vma_walk_hole(start, end, -1, walk);
>> +	if (pmd_none(pmd)) {
>> +		r = hmm_vma_walk_hole(start, end, -1, walk);
>> +		if (r || !minfo)
>> +			return r;
>> +
>> +		ptl = pmd_lock(walk->mm, pmdp);
>> +		if (pmd_none(*pmdp)) {
>> +			// hmm_vma_walk_hole() filled migration needs
>> +			spin_unlock(ptl);
>> +			return r;
>> +		}
>> +		spin_unlock(ptl);
>> +	}
>>  
>>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
>> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>> +		if (!minfo) {
>> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>> +				hmm_vma_walk->last = addr;
>> +				pmd_migration_entry_wait(walk->mm, pmdp);
>> +				return -EBUSY;
>> +			}
>> +		}
>> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
>> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>> +
>> +		return 0;
>> +	}
>> +
>> +	if (minfo) {
>> +		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
>> +		hmm_vma_walk->pmdlocked = true;
>> +		pmd = pmdp_get(pmdp);
>> +	} else
>> +		pmd = pmdp_get_lockless(pmdp);
>> +
>> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
>> +
>> +		if (!pmd_present(pmd)) {
>> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>> +						      pmd);
>> +			if (r || !minfo)
> Do we need to drop the PMD lock here upon error?

Yes, will fix.

>
>> +				return r;
>> +		} else {
>> +
>> +			/*
>> +			 * No need to take pmd_lock here if not migrating,
>> +			 * even if some other thread is splitting the huge
>> +			 * pmd we will get that event through mmu_notifier callback.
>> +			 *
>> +			 * So just read pmd value and check again it's a transparent
>> +			 * huge or device mapping one and compute corresponding pfn
>> +			 * values.
>> +			 */
>> +
>> +			if (!pmd_trans_huge(pmd)) {
>> +				// must be lockless
>> +				goto again;
> How can '!pmd_trans_huge' be true here? Seems impossible based on outer if statement.

Good point. Will fix and refactor this.

>
>> +			}
>> +
>> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>> +
>> +			if (r || !minfo)
> Do we need to drop the PMD lock here upon error?

Yes, will fix.

>
>> +				return r;
>> +		}
>> +
>> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
>> +
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
>> +		}
>> +
>> +		if (r == -ENOENT) {
>> +			r = hmm_vma_walk_split(pmdp, addr, walk);
>> +			if (r) {
>> +				/* Split not successful, skip */
>> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +			}
>> +
>> +			/* Split successful or "again", reloop */
>>  			hmm_vma_walk->last = addr;
>> -			pmd_migration_entry_wait(walk->mm, pmdp);
>>  			return -EBUSY;
>>  		}
>> -		return hmm_pfns_fill(start, end, range, 0);
>> -	}
>>  
>> -	if (!pmd_present(pmd))
>> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>> -						 pmd);
>> +		return r;
>>  
>> -	if (pmd_trans_huge(pmd)) {
>> -		/*
>> -		 * No need to take pmd_lock here, even if some other thread
>> -		 * is splitting the huge pmd we will get that event through
>> -		 * mmu_notifier callback.
>> -		 *
>> -		 * So just read pmd value and check again it's a transparent
>> -		 * huge or device mapping one and compute corresponding pfn
>> -		 * values.
>> -		 */
>> -		pmd = pmdp_get_lockless(pmdp);
>> -		if (!pmd_trans_huge(pmd))
>> -			goto again;
>> +	}
>>  
>> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>> +	if (hmm_vma_walk->pmdlocked) {
>> +		spin_unlock(hmm_vma_walk->ptl);
>> +		hmm_vma_walk->pmdlocked = false;
>>  	}
>>  
>>  	/*
>> @@ -451,22 +1050,41 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  	if (pmd_bad(pmd)) {
>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  
>> -	ptep = pte_offset_map(pmdp, addr);
>> +	if (minfo) {
>> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
>> +		if (ptep)
>> +			hmm_vma_walk->locked = true;
>> +	} else
>> +		ptep = pte_offset_map(pmdp, addr);
>>  	if (!ptep)
>>  		goto again;
>> +
>>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
>> -		int r;
>>  
>>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>>  		if (r) {
>>  			/* hmm_vma_handle_pte() did pte_unmap() */
> Drop the PTE lock if held?

hmm_vma_handle_pte() does unmap/unlock on error.

>
>>  			return r;
>>  		}
>> +
>> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
>> +		if (r == -EAGAIN) {
> Assert the callee dropped the PTE lock?

ack

>
> Matt

--Mika


