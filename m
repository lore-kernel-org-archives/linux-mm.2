Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52983606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=R8Ftrnix
Received: by kanga.kvack.org (Postfix)
	id 565FA6B065D; Wed, 21 Oct 2026 04:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0C36B065E; Wed, 21 Oct 2026 04:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390266B065F; Wed, 21 Oct 2026 04:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 096796B065D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:11:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09CA914048D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:11:57 +0000 (UTC)
X-FDA: 85345915074.22.C9F7D92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BB9B140004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:11:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R8Ftrnix;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792570314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9nlbn0Kjji4QycL/33Denq/qFQLa7BpbrMZy29ygbI=;
	b=vLxKDlUtKOOzonUeKzo4hi7HyGT1tz3KMCodKYpj6i7o/c8n4n/JafGOhElj3wUtk/2jok
	Ca4zqs6fPlopWN7FxkZPROBEkZUSFoVZ3pqGVU+ssuPawYB6iEVxJ+gr9OY/UycHUHvU0X
	hsAZLNgxWvtoXKZbkvFFyPJNcWne5fA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R8Ftrnix;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792570314;
	b=bnbh8D38VBVkS6tEhIh9w5OG6pCExRy/rqnmm7ee4busuvF0Q1khYRk8z9SseAHzsbM/di
	f89DcymdwA7FRKzdn92J+c6kBAaHiZoyRCtHP4saNzi6iPGNgX1tpjXsPdntKjYF5Ptyq5
	vQqlOXKdHi2UwUFDQUon6KE+pcr587w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792570313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9nlbn0Kjji4QycL/33Denq/qFQLa7BpbrMZy29ygbI=;
	b=R8FtrnixmJfx7YT5jQNxeY4qw4NSSxeW3645PxFJunc5J9wqR0vpTy4iMjqN3N2BOi/yKn
	+HmbW/J9t3y+PO/Wm9c5ebc1B9JrP+AArA4vuOHCdmovkFlG1oLSbskKOncIgztLg+DXMW
	QbYCsNbXD+dsQZ9+ovborl7qZvo/klg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-LNbOb3EONva_63RNaL0U7Q-1; Wed, 21 Oct 2026 08:11:52 +0000
X-MC-Unique: LNbOb3EONva_63RNaL0U7Q-1
X-Mimecast-MFC-AGG-ID: LNbOb3EONva_63RNaL0U7Q_1792570311
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1e672580aso2908705e9.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792570311; x=1793175111;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x9nlbn0Kjji4QycL/33Denq/qFQLa7BpbrMZy29ygbI=;
        b=CZQ9zAX3mmyTroyX+dtrLLn+zC/aMmLliopD2Fh7BetVdWHDPABrU6nsgWo9ZB8aNW
         HtV/gk8oQmWlFwQw+9nSsVzC3c+NmErvXbn+IiIlHpgF9NiH2ncyexj/R3Wm2HFG/6i9
         xJnp0lJgBK4KFVO+OwTEu1c8j5ocdpjJwvvqBoykvg5YjiRUrxc3x/EDhpP+x5evfgEP
         fDAcBgVoHtXNYBih0GnUaedfACbnWVhwrXXw8PNSaXhPAGSx9WTkzaqTBIXMyzuu1AHf
         0OEFA2U1IiaUKjoY1vNeVGjXwOB2cQYnhmK7pTOvSThLGBVMzttmYJwOVx9Tsk+uJjdN
         ojyw==
X-Forwarded-Encrypted: i=1; AKwUvBzu3dW2f2CbV20/OYarUfLLUimuj5rHPvHq8sJiEv0wB2swG8T8E2vc+Ky/4os4A0Z2GO10eLxXkA==@kvack.org
X-Gm-Message-State: AFq9FYKtmu3GD4WWbqX62B+daNObjmhu38JrTc9RpnQfpvxpGtC7v4Ml
	Xcy+/6Y97+4//JMXJPqPuJFBpV/hdJEBTWyEZyEKAwx60EKk2G8YX8dqCjrs4ghMZdOBgHfO4wc
	5gSGmQwsu4xk/En36U4oPcfqjfGDm2O/jzS+mBR8GXwA/TR31G6U=
X-Gm-Gg: AYBFou2JeWwuZhrKLwnOxuu5eObV2mVyARyB0oAPX9Y+N5lABqyDsbvTAqJwUL46r7r
	SCr0YSSg+te8ohVKHXZfjBQDj4k2EJwy5cVwXDnylJwQ2s8oo9oIAJURiWJ+wg7GfStJOXsY0kr
	2YT9sry0tDTCTQPJBZVxbYYMDakTJC6LjX1bUZcKeV9PwAgJGlUaGr82dxr3v8u5v7w+6o6KNdz
	C+zmbC4U4pLspPlYpTvdLjTQn/ChczuSCesR+VQL2OcEmv/belm1m0xcRWa1JiA3vbqKfLpApEn
	B//yro+6dnl/9bcVfDg25R1PPA4a2qv8HvakBmaRDtDpkLMlVZj9YcO4sigqhaQmu4/tiL5phnx
	wDuFl6dnVN0cXPHYOFeeGj9BYRl8/Ky8=
X-Received: by 2002:a05:600c:1d21:b0:4a1:cef3:fb3a with SMTP id 5b1f17b1804b1-4a1fdb1d85amr25860795e9.9.1792570310842;
        Wed, 21 Oct 2026 01:11:50 -0700 (PDT)
X-Received: by 2002:a05:600c:1d21:b0:4a1:cef3:fb3a with SMTP id 5b1f17b1804b1-4a1fdb1d85amr25860095e9.9.1792570310261;
        Wed, 21 Oct 2026 01:11:50 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835247sm3779888f8f.41.2026.10.21.01.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 01:11:49 -0700 (PDT)
Message-ID: <8affcad2-7489-4f6a-aa64-3e5911073afb@redhat.com>
Date: Wed, 21 Oct 2026 11:11:47 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/12] mm/hmm: preparations for HMM to participate in
 migration
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-4-mpenttil@redhat.com>
 <017202b1-1c48-4fb1-a951-6d909fb30016@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <017202b1-1c48-4fb1-a951-6d909fb30016@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OvWUCqmszhAljbmEzswVaLQyl3yjse1Oog7RinK1sZo_1792570311
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BB9B140004
X-Rspam-User: 
X-Stat-Signature: wn4iy6fo3dueds7hc9in3po8g5mftqq5
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792570314-711181
X-HE-Meta: U2FsdGVkX1/uiJ5XgdqFuhsRtCFOeVyS4WQDeYTrIKPjlDsD5RgqRauJGuMvzmtgJfZ1UUoJU7j7IwoqMVOlDPRt0slq5OxMqawqNDOMImJkG5cUUs+Cu7EHCZtjBonHle9iFrjZUCZ/SbjHq1CtKuYI/3IHvCm5OqYbWOeiDW0sucJvkHV9nOKEJSLRDUA6KNhudkNATtg8WclK6a/HsRKRRtiMatSBqxh0RsGCmgPTI9UjcagZYxkaAVK6cozHhLY/SC7qMfq4dGo7iVvmU+L6Fj5gAkwqFY/XAChOwgjN649jYhuXcfzt6dPbsFFzt+sbLh4a0gj5XcOX48RQE41rri9rrH/Yf8Ed6nGVOnLxs0EXZ49CIgqS+Ye/UAIMirS6taGkw3OEGyAk/Hd7hwU+kPDdsDL2NZpZQQ/CZNMPhKYyT7kWClPxvlC6Bjm2lWfwzwop2gcR2RZ5Y1NQV+b+KXMWe71xwWCHVV/bCWGXyrfcnVK15dfJxlBXezAB7hiQK2lRpUbUptxl5/7lWa93I5z/S+NgHsVfSIu5wKrfljhv4nY/jy8/iZM/oUSYmrDda0k7nFT3K84lLvMLmSqwj7advkFdI6dTa2sO2CLLkGsNB7Ff8oDqs80sj3WRXQQGB5g/3Zbo6IbADz+Anr+uB9O1pqWpymApbt/9FasCac42PJQNpztUm/RymaUUZyLPZMIoV8SrzRWzSASP/VuhiN+KxvyNvLNZcbbdsxRZfpPswYCkTR78HtyvG34UNr2HdMjgnKr11EcZNwZSjd0wT3deW3AOf9gbNTTgzjsUDQMk4QbKPAbseKa77MBUo1IVLssShuQnJjeBuAB9JfvrZhvk+egnzivc3v62EEqiT7awjcx8cFtIApJMKg7cBwJWT1lNgY6SlQX68spDsUb9tRtOq4pAzGVFlhA8dgQj+JIurS0SddEgalM7Em8VtLmOYQDZWBRnZCJX7fy
 U4qh1M59
 dP/MI+6vGonPrDPGy7PzrGKol8x8amvkc2W5fTABKSzeqXWj3AsixvlAq4teAIke65A6CrmclIK8hufQkGjmlkaEndX0Tejh2j6xJGrJoyERIcdfypbjD/HInYqXV9oX8ptpPcIDH8/cGCY6NLk339/h3X3T4pXtvF6NsP+yrIpo2WPcP5NwFsS+Gg0O3lzByIctqicuMSk2PepbIY6yQUnWh4S1vPlMief8ufHoN1rY+JkKvH3a4Q+YT6UHxIWVNPe4rXVyoF+sDfBsHBiFl/cllJTjmlBsPfxr8ePpDOyia7vFOE0h+9qEMQH2kQh+9PVyBLRfFK4NQfImjZaAkSEjsq/GF8iP7ir+uy9ApBIvPUwkIKZITjVsEUQl9p35LjD4czZ7MZeH/xQ67l8ePuU9kXflVqVOJByJO9wWx5+Oa72/PBou9VgZ/PG4vkYKl2zkfy7Aqo6jaYj16qdQhJsYz5tJI+vgjKj/aC0MBy9NYBCrIrkn+5T3Qxyyb4Y9cjqxPoX6IKxKLCw5nUKVUMXzQQvV6rt+OVhRFJ8l7dKciUPUdvSIpwf3Tkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/21/26 10:17, Balbir Singh wrote:

> On 10/21/26 5:04 PM, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> For migration to happen after hmm_range_fault(), the vma has to
>> retrieved. Luckily, pagewalk already resolves that for us, so
>> just have to save it for further use. For migration, mmap_lock
>> has to be hold for the whole operation, so vma stays stable.
>> In case lock-drop behavior is requested, return an error while
>> migrating. Also, rename some struct hmm_vma_walk fields to solve
>> namespace collisions, and we are later introducing more
>> xxlocked fields so be unambiguous.
>>
>> Take care also of firing the mmu_notifier when migrating.
>>
>> Also, prepare for differencies of how mm_struct * is retrieved
>> in fault and migrate_vma paths.
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
>>  include/linux/migrate.h |  50 +++++++++++++++++-
>>  lib/test_hmm.c          |   2 +-
>>  mm/hmm.c                | 110 ++++++++++++++++++++++++++++++++++------
>>  3 files changed, 145 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index 280ec9a866c7..dd7dd7ec6995 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -5,6 +5,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/hmm.h>
>>  #include <linux/mempolicy.h>
>> +#include <linux/mmu_notifier.h>
>>  #include <linux/migrate_mode.h>
>>  #include <linux/hugetlb.h>
>>  
>> @@ -108,6 +109,29 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
>>  	spin_unlock(ptl);
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
>> +static inline void hmm_fill_migrate_vma(struct hmm_range *range,
>> +					struct vm_area_struct *vma,
>> +					unsigned long start,
>> +					unsigned long end)
>> +{
>> +}
>> +
>> +#ifdef CONFIG_MMU_NOTIFIER
>> +static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
>> +{
>> +	return range->notifier->mm;
>> +}
>> +#endif
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #ifdef CONFIG_NUMA_BALANCING
>> @@ -151,7 +175,8 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>>  }
>>  
>> -enum migrate_vma_direction {
>> +enum migrate_vma_info {
>> +	MIGRATE_VMA_SELECT_NONE = 0,
>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>> @@ -193,6 +218,29 @@ struct migrate_vma {
>>  	struct page		*fault_page;
>>  };
>>  
>> +// TODO: enable migration
>> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>> +{
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_MMU_NOTIFIER
>> +static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
>> +{
>> +	return range->notifier ? range->notifier->mm : range->migrate->vma->vm_mm;
>> +}
>> +#endif
>> +
>> +static inline void hmm_fill_migrate_vma(struct hmm_range *range,
>> +					struct vm_area_struct *vma,
>> +					unsigned long start,
>> +					unsigned long end)
>> +{
>> +	range->migrate->vma   = vma;
>> +	range->migrate->start = start;
>> +	range->migrate->end   = end;
>> +}
>> +
>>  int migrate_vma_setup(struct migrate_vma *args);
>>  void migrate_vma_pages(struct migrate_vma *migrate);
>>  void migrate_vma_finalize(struct migrate_vma *migrate);
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index 6911daa9f854..cd88e8177d0a 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -145,7 +145,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
>>  		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
>>  }
>>  
>> -static enum migrate_vma_direction
>> +static enum migrate_vma_info
>>  dmirror_select_device(struct dmirror *dmirror)
>>  {
>>  	return (dmirror->mdevice->zone_device_type ==
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 2f1e98c6b644..4e9542aedc25 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/migrate.h>
>>  #include <linux/memremap.h>
>>  #include <linux/sched/mm.h>
>>  #include <linux/jump_label.h>
>> @@ -28,15 +29,23 @@
>>  #include <linux/pci-p2pdma.h>
>>  #include <linux/mmu_notifier.h>
>>  #include <linux/memory_hotplug.h>
>> +#include <asm/tlbflush.h>
>>  
>>  #include "internal.h"
>>  
>>  struct hmm_vma_walk {
>> -	struct hmm_range	*range;
>> -	bool			*locked;
>> -	unsigned long		last;
>> -	unsigned long		end;
>> -	unsigned int		required_fault;
>> +	struct mmu_notifier_range	mmu_range;
>> +	/* Set once mmu_range is armed with mmu_notifier_invalidate_range_start() */
>> +	bool				mmu_armed;
>> +	struct vm_area_struct		*vma;
>> +	struct hmm_range		*range;
>> +	unsigned long			start;
>> +	unsigned long			end;
>> +	unsigned long			last;
>> +	/* fault and lock drop related fields */
>> +	bool				*mmlocked;
>> +	unsigned long			fault_end;
>> +	unsigned int			required_fault;
>>  };
>>  
>>  /*
>> @@ -95,7 +104,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
>>  
>>  	WARN_ON_ONCE(!required_fault);
>>  	hmm_vma_walk->last = addr;
>> -	hmm_vma_walk->end = end;
>> +	hmm_vma_walk->fault_end = end;
>>  	hmm_vma_walk->required_fault = required_fault;
>>  	return HMM_FAULT_PENDING;
>>  }
>> @@ -400,6 +409,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  }
>>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
>>  
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
> I don't quite follow the check for -ERANGE, it checks for hmm_vma_walk->vma !=
> walk->vma, but then set's it later to be the same?

The intention is to catch a range that crosses a vma boundary. hmm_vma_walk lives across the restart loop in hmm_range_fault_locked(),
so test_walk can run again for the same vma after an -EBUSY re-walk. The first call records the vma, a re-walk of the same vma passes,
and a different vma means the range spans more than one vma, which migration doesn't support, so -ERANGE. 
The assignment only takes effect on the first call. I'll restructure it as "record if unset, else -ERANGE if different" and add a comment.

>
>> +
>> +	if (end - start > range->end - range->start)
>> +		return -ERANGE;
>> +
> Have we established that end > start and same for range->end > range->start?

Yes. walk_page_range() rejects start >= end before calling any callback, and hmm_range_fault_locked() walks from hmm_vma_walk.last 
(initially range->start) to range->end, so range->start < range->end holds whenever test_walk runs. 
The test_walk start/end are a sub-range of that walk clamped to the vma, so start < end too. 
That also means end - start can never exceed range->end - range->start, so the check is redundant. I'll drop it in v17.

>
>> +	if (!hmm_vma_walk->mmu_armed) {
>> +		hmm_vma_walk->start = start;
>> +		hmm_vma_walk->end = end;
> Does the walk range matter here?

The walk range is the caller's range clamped to the vma: with the caller's range inside a single vma the two are the same,
and the clamp keeps the walk range's end within the vma (migrate_vma needs that) if the caller's range extends past
the vma into a hole. The walk range is used as both the MMU_NOTIFY_MIGRATE invalidation range and the migrate_vma start/end,
and is set once on the first test_walk call. I'll also add a check that the walk range starts at range->start,
since migrate_vma indexes src[] from there.

>> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
>> +					      walk->vma->vm_mm, start, end,
>> +					      range->dev_private_owner);
>> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
>> +		hmm_vma_walk->mmu_armed = true;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void hmm_vma_post_range_fault(struct hmm_vma_walk *hmm_vma_walk)
>> +{
>> +
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +
>> +	if (hmm_select_migrate(range) &&
>> +	    hmm_vma_walk->mmu_armed) {
>> +		/*
>> +		 *  The migrate_vma path has the following initialized,
>> +		 *  so take care of fault path below.
>> +		 */
>> +		if (range->notifier) {
>> +			hmm_fill_migrate_vma(range,
>> +					     hmm_vma_walk->vma,
>> +					     hmm_vma_walk->start,
>> +					     hmm_vma_walk->end);
>> +		}
>> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
>> +	}
>> +}
>> +
>>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  			    unsigned long start,
>>  			    unsigned long end,
>> @@ -594,6 +655,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
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
>> @@ -646,12 +712,12 @@ static int hmm_do_fault(struct mm_struct *mm,
>>  			struct hmm_vma_walk *hmm_vma_walk)
>>  {
>>  	unsigned long addr = hmm_vma_walk->last;
>> -	unsigned long end = hmm_vma_walk->end;
>> +	unsigned long end = hmm_vma_walk->fault_end;
>>  	unsigned int required_fault = hmm_vma_walk->required_fault;
>>  	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>>  	struct vm_area_struct *vma;
>>  
>> -	if (hmm_vma_walk->locked)
>> +	if (hmm_vma_walk->mmlocked)
>>  		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>>  
>>  	vma = vma_lookup(mm, addr);
>> @@ -670,8 +736,8 @@ static int hmm_do_fault(struct mm_struct *mm,
>>  		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>>  
>>  		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
>> -			if (hmm_vma_walk->locked)    /* needed by sparse */
>> -				*hmm_vma_walk->locked = false;
>> +			if (hmm_vma_walk->mmlocked)    /* needed by sparse */
>> +				*hmm_vma_walk->mmlocked = false;
>>  			else
>>  				WARN_ON_ONCE(1);    /* broken fault handler */
>>  			return HMM_FAULT_UNLOCKED;
>> @@ -694,19 +760,31 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
>>  {
>>  	struct hmm_vma_walk hmm_vma_walk = {
>>  		.range = range,
>> -		.locked = locked,
>> +		.mmlocked = locked,
>>  		.last = range->start,
>>  	};
>> -	struct mm_struct *mm = range->notifier->mm;
>> +	/*
>> +	 *  Could be serving a device fault or come from migrate
>> +	 *  entry point. For the former we have not resolved the vma
>> +	 *  yet, and the latter we don't have a notifier (but have a vma).
>> +	 *
>> +	 */
>> +	struct mm_struct *mm = hmm_range_fault_mm(range);
>>  	int ret;
>>  
>> +	/* Migration is incompatible with mmap lock drop */
>> +	if (locked && hmm_select_migrate(range))
>> +		return -EINVAL;
>> +
>>  	mmap_assert_locked(mm);
>>  
>>  	do {
>>  		/* If range is no longer valid force retry. */
>> -		if (mmu_interval_check_retry(range->notifier,
>> -					     range->notifier_seq))
>> -			return -EBUSY;
>> +		if (range->notifier && mmu_interval_check_retry(range->notifier,
>> +								range->notifier_seq)) {
>> +			ret =  -EBUSY;
>> +			break;
>> +		}
>>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>>  				      &hmm_walk_ops, &hmm_vma_walk);
>>  		/*
>> @@ -732,6 +810,8 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
>>  		 * output, and all >= are still at their input values.
>>  		 */
>>  	} while (ret == -EBUSY);
>> +
>> +	hmm_vma_post_range_fault(&hmm_vma_walk);
> Have you checked to see if we could end up with notifier start/end inbalance?
> For example if hmm_select_migrate returns false?

Yes. invalidate_range_start() is only called from hmm_vma_capture_migrate_range(), after the hmm_select_migrate()
check and only once (mmu_armed). invalidate_range_end() is only called from hmm_vma_post_range_fault() when mmu_armed
is set. hmm_select_migrate() doesn't change during the call, so if it returns false neither is called.
Every exit from the loop goes through hmm_vma_post_range_fault(); except after test for lock drop which happens before walks.

>
>>  	return ret;
>>  }
>>  

Thanks,
--Mika


