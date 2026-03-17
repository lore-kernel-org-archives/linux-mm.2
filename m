Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF23AFD8763
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2306B0088; Tue, 17 Mar 2026 09:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553336B0089; Tue, 17 Mar 2026 09:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469076B008A; Tue, 17 Mar 2026 09:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 351556B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:01:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79437B68D4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:01:19 +0000 (UTC)
X-FDA: 84555565878.12.D1A27BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB460C001A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:01:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXEIzKn8;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773752477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n20AEbq+bhcepRzgl/xYIcvQpLC81/e/06fpntOlePw=;
	b=jzy2BXV2oOFCOdkaOqFFI6cmEawvzyEZJBcGTTyXWt0Us2hR80dZsfITgE57eV1rjisM/X
	VvBzLNJGMyFUZKyxyDm4NXNji0Ki7K7kc+1+JmS3AMYaeTKNpR+m+5EH+7zTcya63e51ws
	Dj1fNYR2uXmzWRtP6QGn8Af+DKsVd5I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXEIzKn8;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773752477; a=rsa-sha256;
	cv=none;
	b=0G43W2M/C9KPTVRcGi6ik7EA/ahEWL/KW3i6rdJWBYn9tpzZcHFURiwksPwfzO/vbIxzER
	iChj46naeSOCcX4ZkpcTp4H5veh/ZRzhXuKdchqj/47xQEUVWHv3nQRzVCqeB7o17qtEiv
	9MGbBd59hvfvUvNH5xqdeM1YnYcssSc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773752476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n20AEbq+bhcepRzgl/xYIcvQpLC81/e/06fpntOlePw=;
	b=PXEIzKn8ys2DXLSB9ZeBbMj8n/v5NXo/3EA1l9LyS4fOr8SMYT/p74JX9upyytPHc+JCZo
	yazPXBDgNeNMpX4U0CcmZmb2Jb+yHd70KDL0IsZSCyBpkaTzjZnNE3ZO8OiF1GLNJMOrn9
	KIdfcq6UMeGfmZLaKBZ4gHBC9a2zS7c=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-QG4_uJbcNK2cL3KKT3CbIw-1; Tue, 17 Mar 2026 09:01:12 -0400
X-MC-Unique: QG4_uJbcNK2cL3KKT3CbIw-1
X-Mimecast-MFC-AGG-ID: QG4_uJbcNK2cL3KKT3CbIw_1773752471
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a2794fbc5so23087071fa.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773752471; x=1774357271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n20AEbq+bhcepRzgl/xYIcvQpLC81/e/06fpntOlePw=;
        b=kU327svQQSJoRsOQ42OuQ18Y/O4sXccQjTXDvq2CdJg6M3VpXip2+svQt7FZVvoPiw
         KRYv7C2GVhq5MOzlcF7QfAJgl2ARUuqBOGajF01J09ZVa+n8xnSMXjrug893gBRUuS7u
         K3ayplVloEu++epRILStmOXDrfE3TekYP46gB9qGIFHX2KddIeGPqTl3ADUdDjAL/dSJ
         AAL2TNXXwQiKx804ivVE3p3wTMvQm1IZcihL1G59VmrSNZsvbmDRmpNL8cgJVUd6xqdd
         30quPZHMvvEV53zFuV5HXXdNnmKtUKoGFvUMWFmeVgi87Q77Co+WjnjNNDqLzlVY4/P/
         xHVA==
X-Forwarded-Encrypted: i=1; AJvYcCXWB7efSZ/oFHa3OEq/6myYoTtikfJdkRQsquLO9hmrIXiCGK3AN27rb0McrG3dYFExrXRGTU/DtA==@kvack.org
X-Gm-Message-State: AOJu0YwOsyjR8nhdGowfLePJmB/bDpmz0In9M47YM4Mc+jFXOVv1rXVS
	1JCUItG8GcJU+Y1TXsvaPOSHQsywLVu5dlnpEaPsT94ZxHGefcHqg1HwbnvlwnuxCo62aSTWX8x
	7pwB6CM6WHqLBDWKX6tBDNDY+Jdp21aW01jTeCqRd7oVce/r4HsxWuOpFZiQ=
X-Gm-Gg: ATEYQzxf1KVDavXCR92GCT76ntRNbbuyjz5Hvw8jEx9yLiQ8XSCfhQ+dXyHsErm09u/
	aGE233M///rGqjdXWeyzpf7MUYbGEpcjk3SAbWU/Ua8V6hz6Pi2+mR8yV8Qk+M9QyaPzI+ECjJm
	3HHjfAjT0aLqZX6FvgLmtNeNYH59uNr9oeh60tAumszItG90Ky5bF9eIej7cdKhoQZ31qwxivOt
	N9CdhOESgxXzURXuiAkZGwACXh/GHiIwFd0j6xEPpw/XaPdi4anfI6sanV2drgNkFe54eQAfQ5W
	S3uS3aTbfZx54vNGMWybKo0eTlOOD10G4G4C/WI2t9Xmy9QJClnGay6Y1+eNWAk+YnJOr1fSL1O
	/+/u0n7XY2k+VQdK0ogyEVHpdwwxWjkvLG5jOHyo8qgTlViI=
X-Received: by 2002:a2e:9251:0:b0:38a:3668:283c with SMTP id 38308e7fff4ca-38a89811c32mr41227401fa.33.1773752470646;
        Tue, 17 Mar 2026 06:01:10 -0700 (PDT)
X-Received: by 2002:a2e:9251:0:b0:38a:3668:283c with SMTP id 38308e7fff4ca-38a89811c32mr41227161fa.33.1773752470026;
        Tue, 17 Mar 2026 06:01:10 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38a67d61f25sm41532751fa.7.2026.03.17.06.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 06:01:09 -0700 (PDT)
Message-ID: <59d3c0e5-23fb-4a30-825a-d90fd07bd34e@redhat.com>
Date: Tue, 17 Mar 2026 15:01:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm: Add helper to convert HMM pfn to migrate pfn
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <20260211081301.2940672-3-mpenttil@redhat.com>
 <3c0578a9-ce1c-4d26-86d5-681cae4b8200@kernel.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <3c0578a9-ce1c-4d26-86d5-681cae4b8200@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1ALgVwV_Nr_nRdvyU-KOER4JIpiuNn8C83mzZ0TESMM_1773752471
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tmd5nn8c7cxapjo47zb8jmqcbmy1omch
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BB460C001A
X-HE-Tag: 1773752476-77642
X-HE-Meta: U2FsdGVkX19UDXBcr3qf0jeAu5nOH2jEhy6BquAyVSRnT8qWmbb0HGM1lqFWZ/1fZakx3CQjnSY4tGRked/1vMLBecdqbI/aEkokHl3OUyWQJUsHAa38QpwnbngbwCseZCY1gYjHyJ/QxYjQcAt4L87qly6j7G92FvxPph0I1ODXFahwCGpHnIIvciGrB3r1ct86o+VjZwrGq8Jhh58yLZeu5BIGJ/BInQGu7E/MQ0lExJs+CrNQEFyHZN+oTczRKxJix10qcFojVa+B+77BV9O3S5K2JjVcmWSoOF8IZsw0OLFjsXLb4Az906wEZugp/fA+WhgT74dPLyrRBwifqDdY89uHKsuyC/vbN3thCe3vjH9CluIvQNLyehvYR9odat5/gg3YZ3xe+wd9ds5z76eATk/WkDxLc1UoDhgzhhqyDNnMomCnKJ/JPvGFEwDiQOaAnVf/100SbOkwwgLNtt9Dd9+vi0FOdvx8QalkdSlJ0CB2X/VeC5N1bA0ngd8ovqKoBYiSYAdXTWW5P6nCsp6qvEJxaSZHz0aBKYEYZYpfUQa3zuy6LLD9O2gqNsnq2xmghA0B3weM4nVbd/II+NwlQyhpWg/g7jk1fBepN/L8fbgui1kU6kSj/6jJUYUgQMNaaW56hJTuZ3R7bb9tdNIF77sgI5cP6lGE6xyvgK8XRUR9Q7MKaXY6fuc4eZnR431g6UMli0PjiPsaENz5wBkt3A3cXDEPjWKg8zDqQGmTMKDyAzFb1v5FPhJAnXFLWYBAETwbeS7wet4i2fYBIhTrO/W14rXT7YlTXshhsMBKKgYBR+/tyrtgPnxQoLNFMBm4GfeJfmmfkWMnv/V74GZTubffTCj7TrserfYuRCc6gdaGbBKJ5RlHZQtJcEFhnBR1gi32QvjN2GS4HUyPLJ1OAYtGnoJhR52+spCqDkdO1G8M6fD6MWWeFWAtDNUxiTbIybyypGtfG1fEnny
 KvWN07Qv
 cHIkd+mWFQsBOc+u9EUdsebW/vaRu21TLyjH+/+s2rPUhKfQFFwx9K1L6MVnvmZqIzPAYk6WF/MD900soM1n8nit5Bo8XaHvCCybVDNm5VqdWowNW8sliuNmXYVxmMMNhK0Njc1mmJGEYJhSSlJlxtLVllDZPo7ZLYTTWCrgCBmGFrKo1HWJWbmtKcfMI045eJqfpcMGi606ujYPgAVjVlrcNPEa8AjtlVL/Ba4Zt57HzJCTWzhCYXmxXOpFzKcmX59rxmWu+Urs2xNdtpUWz99Pp77irawplpIfDHghOIgHhqYbuuR5vmp5NoeXpMqSCqUYQNkkgKkqkxgS50tLWmZYb7Usk0U4lgbp0mKDuF1JMz2teirLhk0r99XyGpGvgEa/I6KVzj9PC7nPRrjN5GB7F7UKedCVkDT/CYHSm5jhDBpA6veUskt2VcEMRqiYgIKjULLUOHPm2SyzcFpIQDyuSuXQ3Un8sIXXwqe1Mj5C9PbjDsvEy7MvJJG5i8yoQ+v96PrT2lBkPeqkxzPakV/RrtEGM5h2KK3gIooMG6Kz+J30GObbnhD52ol5ny1EYfS7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/17/26 11:05, David Hildenbrand (Arm) wrote:

> On 2/11/26 09:12, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> The unified HMM/migrate_device pagewalk does the "collecting"
>> in HMM side, so need a helper to transfer pfns to migrate_vma
> s/in/on the/ ?
>
> "so we" ?
>
> "to the" ?

Yes will correct.

>> world.
>>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  include/linux/hmm.h     | 18 +++++++++--
>>  include/linux/migrate.h |  3 +-
>>  mm/hmm.c                |  6 ----
>>  mm/migrate_device.c     | 69 +++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 87 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>> index db75ffc949a7..b5418e318782 100644
>> --- a/include/linux/hmm.h
>> +++ b/include/linux/hmm.h
>> @@ -12,7 +12,7 @@
>>  #include <linux/mm.h>
>>  
>>  struct mmu_interval_notifier;
>> -
>> +struct migrate_vma;
> Keep the empty line, please.

ack

>
>>  /*
>>   * On output:
>>   * 0             - The page is faultable and a future call with 
>> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>>   *                      to mark that page is already DMA mapped
>> + * HMM_PFN_MIGRATE    - Migrate PTE installed
> I have no idea what exactly that means. Can we a bit clearer?
> Especially, what does it mean when this is set alongside HMM_PFN_VALID? What if it
> is not set alongside HMM_PFN_VALID.
>
Agreed needs more documentation. Look below for explanation also.

> Shouldn't we document what HMM_PFN_COMPOUND and HMM_PFN_MIGRATE mean as well somewhere?

I think they deserve some words as well.

>
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
> Why is that an anonymous enum with a single value? Ah, you are moving
> that. This should be spelled out in the patch description (and why you
> are doing it).

Yes I moved for visibility to migrate_device.

> Is there any reason we can't move that into hmm_pfn_flags?

Can't think of any, I think that would be good to do.

>
>> +
>>  /*
>>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>>   *
>> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>>   * @dev_private_owner: owner of device private pages
>> + * @migrate: structure for migrating the associated vma
> Is it really for "migrating a vma"? I assume it's for migrating a range
> of a VMA.

Yes, a range. Will fix.

>
>>   */
>>  struct hmm_range {
>>  	struct mmu_interval_notifier *notifier;
>> @@ -117,6 +130,7 @@ struct hmm_range {
>>  	unsigned long		default_flags;
>>  	unsigned long		pfn_flags_mask;
>>  	void			*dev_private_owner;
>> +	struct migrate_vma      *migrate;
>>  };
>>  
>>  /*
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index 26ca00c325d9..8e6c28efd4f8 100644
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
>> @@ -192,7 +193,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>>  			unsigned long npages);
>>  void migrate_device_finalize(unsigned long *src_pfns,
>>  			unsigned long *dst_pfns, unsigned long npages);
>> -
>> +void migrate_hmm_range_setup(struct hmm_range *range);
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #endif /* _LINUX_MIGRATE_H */
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 4ec74c18bef6..21ff99379836 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -41,12 +41,6 @@ enum {
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
>>  			 struct hmm_range *range, unsigned long cpu_flags)
>>  {
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 23379663b1e1..c773a82ea1ed 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -1489,3 +1489,72 @@ int migrate_device_coherent_folio(struct folio *folio)
>>  		return 0;
>>  	return -EBUSY;
>>  }
>> +
>> +/**
>> + * migrate_hmm_range_setup() - prepare to migrate a range of memory
>> + * @range: contains pointer to migrate_vma to be populated
> "pointer to hmm_range to be migrated" ?

Tried to say range->migrate's src and dst arrays, cpages and npages get populated.

>
> Why can't we just pass the migrate_vma? Or is there another use case for
> adding the migrate_vma to hmm_range?

We have to pass hmm_range anyway because of range->hmm_pfns.
migrate_hmm_range_setup() is supposed to be called after hmm_range_fault(), which
populates migrate_vma's .start .end and .vma. So passing a hmm_range
also emphasizes the intended usage.

>> + *
>> + * When collecting happens by hmm_range_fault(), this populates
>> + * the migrate->src[] and migrate->dst[] using range->hmm_pfns[].
>> + * Also, migrate->cpages and migrate->npages get initialized.
> Can you please document what exactly this function does with
> the magical HMM_PFN_VALID | HMM_PFN_MIGRATE, and why it skips
> everything else?
>
> What is the caller supposed to setup?
>
> I am getting the feeling that this is severely under-documented :)

Yes will add documentation. The caller of hmm_range_fault() is supposed to
fill migrate_vma's pgmap_owner, src and dst array pointers, and flags for migrate direction.
(there is minor change in v6 https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/)
for the flags requirement.

>
>> + */
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
>> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
>> +
>> +		/*
>> +		 *
> Please don't add unnecessary empty comment lines above/below the text.

ack

>
>> +		 *  Don't do migration if valid and migrate flags are not both set.
>> +		 *
>> +		 */
>
> /*
>  * There is nothing to migrate if the entry is not valid
>  * migration entry.
>  */
>
> Which raises the question:
>
> When would HMM_PFN_MIGRATE be set without HMM_PFN_VALID

As is HMM_PFN_MIGRATE is not supposed to be set without HMM_PFN_VALID...
But, I just realized that in order to allow hmm pfn 0 we have to
make HMM_PFN_MIGRATE alone mean the "empty page" (hole, pte_none, zero page)

>
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
>
> I think you can simplify all that by doing a
>
> if (pfn & ~(HMM_PFN_VALID|HMM_PFN_COMPOUND|HMM_PFN_MIGRATE))
> 	migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)));
> else
> 	migrate->src[i] = 0;
>
> migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> migrate->dst[i] = 0;
>
>
> And I wonder whether you could replace the (HMM_PFN_VALID|HMM_PFN_COMPOUND|HMM_PFN_MIGRATE)
> by HMM_PFN_FLAGS, to only check for non-zero PFNs?

For current code the above would be ok. With HMM_PFN_MIGRATE alone for empty page
have to adjust. Will fix.

>
Thanks for the review!

--Mika


