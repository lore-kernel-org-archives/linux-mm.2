Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EF1606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZrwuuAfc
Received: by kanga.kvack.org (Postfix)
	id C91876B019C; Wed, 21 Oct 2026 03:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BD46B0649; Wed, 21 Oct 2026 03:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3F76B064A; Wed, 21 Oct 2026 03:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E80A6B019C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:09:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10C59A7FBA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:09:34 +0000 (UTC)
X-FDA: 85345757868.14.364F63E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 500B140008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:09:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZrwuuAfc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792566571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsBG8HpW85VGH4TsI9kJ5JFOjaqz4u5SyPuzO7nucOA=;
	b=zs79k6bUz0qnq8VXPX0ETjJK9iX6LZQS/H8Lc4gVNwpF8qS3kcDqc37Z82kGeNwbcAMdNd
	UozuSpXgGZTMlaTjjdwiM7j2SFKNXOucXYfwKwSQ8313Z4WT4G1vMFJw7Awa8jd/COhKu1
	h+4jrxmClEQ95tat41xeYa0kFWeN7Ds=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZrwuuAfc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792566571;
	b=A1qkHgfIss/OP4ywoA9tqN+Li3RP2UrDpAdxqQx1kXf1+k6jfnI6ppJyIngSceGjodeoYh
	z4YnMdGQK1+EqF3tryM8NjFLJjGm3WS4leDnvR0x7AzL54M3kjzXvvbQ3QBk74sCudHEMY
	z8vfjRR0ahCHYbDSmW181ODahQO0KBM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792566570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zsBG8HpW85VGH4TsI9kJ5JFOjaqz4u5SyPuzO7nucOA=;
	b=ZrwuuAfcd++r/INl81mgFnFnJEQA10EgcTZ6dK1iDNs/l135NPuxwqiHUHgtozeXEgjDzk
	HUspgtKgP6wHpk3lj3Ecqh+wyOnN4b3oAVxTp5+hQpFyFQdLeefsoKN4SEocKLM09zVsZg
	cwQxsVV81d992vjK646uxvbBwHn25TE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-4VOdSE17Ocyq8Ucf9wEeLQ-1; Wed, 21 Oct 2026 07:09:29 +0000
X-MC-Unique: 4VOdSE17Ocyq8Ucf9wEeLQ-1
X-Mimecast-MFC-AGG-ID: 4VOdSE17Ocyq8Ucf9wEeLQ_1792566568
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b027578a4so267732f8f.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792566568; x=1793171368;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zsBG8HpW85VGH4TsI9kJ5JFOjaqz4u5SyPuzO7nucOA=;
        b=qyg7NZNAFeV4E4V7fFmM6ejtWtqIKmXCz7RDfbW6QHxqw3rG8duPnZIghgzWdEuI46
         TUwxY7Z0i4Eh7DmX3RFd5GZqCjN9YmMagpxAPQm0pIWZqbZ/BD/WtgVZ6gg4/KVjMSPn
         3AAaW2eK4yRJzH8ChMb7nRYK3OkENYFvEaWON5xmwb5MqCQ+/SlhEnfn/252tZSGQmTf
         VRc4PCiqs4KA2mejaDi8KjXmXkbA9IimoqaSax450ys9LsdwkYRsABj2102Q1X9oz+s0
         S07VxjtDXYIFBnaOGbm4B/3KNknffZOMHg/iFZ2FcpY/vERkBonhIk3FpQ+UfIbP+PUZ
         MvBQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLs8nzkn+h4zEmMqvynrYhCNlN7Z39ttCKjIIOB1J1ihk2ky5cYRjwuOS25Jw9dyMRpr2gg9mmMA==@kvack.org
X-Gm-Message-State: AFq9FYJsMvk6xrrJE2rmCVM7ntChRagO10NMva1XAAKlylMqlvkPgaqH
	k7wyyNg0UeKlqPAUeeVDNihiHTWGMJnMZbcAOyL8Yr6h3Q8TCAAWwpOTDYTsx5EmEMe/1WNZgwi
	6ill+uq8BxhYKhCq+TgGoGl93/h4CdmkBeHmV4+6WkxaPYTRxra0=
X-Gm-Gg: AYBFou2RGabABNDzZDqbcRPRYOuiQRu2Af1q65fsIfw9DYePTNQQ4nj8qLDwP37Jg2t
	z/LSJp0Cgf0Re5P8xfuRLcfIwqAEpZMuqPu16FUL/QyE6CkDRwHaYim+nganuXs5+n9GILZtelZ
	iJ3Zk2DWban+k6SFTjIHm2VMFzXV0cncOlEmi6SmIILx9juuT2xPvs5NeBAGHjcZ2aOfISKBbuu
	rUB8fPs3umGBQEP+JzsfDo5SN8vvS9MATa13mNe7dhEvbA151zaLUEpKkeZoRcOVfQbkrB3e5bf
	wGsBXgwmfh2LBt91yI3soMXsFo4geA82CuqdPAoWMCqDYvYpFNykubL1B5OEDfwYWaXHauVDXOu
	rtvPyen8sIKYtWe2KD2lU3PJP42nY/T4=
X-Received: by 2002:a05:6000:3106:b0:48d:f14a:9179 with SMTP id ffacd0b85a97d-48e264afb68mr1929038f8f.48.1792566568010;
        Wed, 21 Oct 2026 00:09:28 -0700 (PDT)
X-Received: by 2002:a05:6000:3106:b0:48d:f14a:9179 with SMTP id ffacd0b85a97d-48e264afb68mr1928883f8f.48.1792566566663;
        Wed, 21 Oct 2026 00:09:26 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25b04883sm3585158f8f.0.2026.10.21.00.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 00:09:25 -0700 (PDT)
Message-ID: <cd1dea21-64d7-445c-8595-448e4f283cb0@redhat.com>
Date: Wed, 21 Oct 2026 10:09:23 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/12] mm/hmm: migrate collection in HMM pagewalk -
 pte level
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
 <20261021060506.2377545-6-mpenttil@redhat.com>
 <cc42cbd1-2030-4fbb-94f6-5e92cba2431e@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <cc42cbd1-2030-4fbb-94f6-5e92cba2431e@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R5kGjvlcrSlG7uGeUbPS8hHWr7_yuJrFvUt5IEoVPNE_1792566568
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 500B140008
X-Stat-Signature: wf1dtcr9wj4tztzuroxt4yzcedwfm3t9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792566571-125505
X-HE-Meta: U2FsdGVkX19rIWxa9sr2wnrPZgaBRySObNjmtTvba48QiaP+fAlEnoZSvMhhaaVkmC3l6ZWwXwfYAZcuiaHu7jVRmjQjlu1vrfyXmRV9vCRhd69LSnI2SWG7/nP8w3BcbWLzu+4dBY7ardW2kNMUBWEVDgyMNBWY9yWbu99uZ0lA81joj3QnHuSx94+1cCU9ObhSJ3OoLfLDQM93fHdkgRlBGC7YUbRN+8md3WIRBNBVdALS1y8ouLmMGI8/DqMimCfV475GyeuLfnwN1ggEtXX2AY6MshJhvMG4zbO6j262Onn+kZ04F8LH6o7NWXZlq4n9isv5X4sHc8fOiX/uO9nvzZx0zOD2pXjXx6XMb6QQbK2ILYgb+DF1bqXSh1aTNvJy6OXnkWqbGGvF+ix+Xs6PaP7Le8Zp2IdmrcGp/IlbbhTmqqnml1o98ze1ZS8Tk1h7KATfXHa3FJQ+EOHOXImFNmiqb3ySAXA73wZQontD34BdS/ojY3VSdg5qJSAx9f+U386jZfv0Uhxwfp1FMdZQHQOYhKNpKsuXi5WfgTWmcHxHUs7IRyhvZNQbYpY9ZjZ+uA9KuXMuTE3NhFg5cGT3Of1slpbwhoRWeMvBUC3ZRPwnnRKDrQt5g4XV/lIhPcEiiTNZPDdwSp6bTlBdS7NKD6mtCLqAjFdxoczCen6wPhMl06ZqfHZq9Ow4quq8jvLIzkVPVUwHInOQRfGn1FVU/u0uL6eiPkRazTpZ0efxi05z4QZXdY2ftPwc6NrT3u0XGDeYWZuI0K1XyF/ISDo/gPEjcuWLikSE6yd4XnXVJ1luVNgGKZB64zUWIAshCSMCOuyhwp32spgiYTbWxR1Qn8JazcurCnqsn386YPkbKP7Id1gVKP1+VkxsFsIrckwLIW3FJ9pE/JmEG4v/kuJq/fOzSa+blMfqBj9UGqcMcvpjjOqq97Jk/8zQFsLlCJRAw3sNSsdF8s6dt/r
 H0v+EsiE
 a7IzmBAqmW17XgwduTvEcc2Twibcqm8s15FgJT/NbB98enu0zGCYf5oXmATfOd7kwblejeaF00zih2NmuPGkD3NGEREdUuk7kW85TZkYkaikROY4ha0OoLtA6SGQ94aZgP1OSw9vkLTDmB9n+VocLj6Q6LPbyqHan8N74g0RwFVBwtq9lQRBuPXn1kZZ8jCw3fiv4DtZx2TI3oHBRlmSJbwfgOLIuawZmTQY62+OdrykGCEK6WdP0yK2WZNIm8F+Rd9POY9RssrCOjcttkkGiOqm+Mv5/N2lPDg88amFRT44n/QTWVYLnAS0Dlj7BhBH8UNPa4kK1k8xK5Nm0+vmX7nM23Lyyw8J8BBSByznaN87Pqs3o7gjZDz0kOo1EmgHF5/RUBKwgggOeB8M7yRcy0dF4tyQz1yuPHewbsUo/KFyHCyrQkhmDme0MVPVZBVBcUxRYF46gCGF9ffIpM4yYrP13lOnfVBQ+fkDDhfuL8t3YrTfEGSI8AKJ8kXY4+q1T21j2UPX8GUJp1Uh+E+oeIJvp8GkO1LOcxfMCkO819R+wK9UoW6qr+u4YIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/21/26 09:56, Balbir Singh wrote:

> On 10/21/26 5:04 PM, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Implement the needed hmm_vma_handle_migrate_prepare() function
>> which is mostly carried over from migrate_device.c's
>> migrate_vma_collect_pmd() function.
>>
>> Also implement the migrate_vma_split_folio(), for splitting
>> pte mapped large folios. It is also mostly from migrate_device.c,
>> with care taken to reference folio before relasing page table
>> lock.
> Typo - releasing

ack

>
>> With HMM pagewalk based migration, the idea is that
>> hmm_vma_handle_*() are responsible for faulting,
>> and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
>> do the migration decisions (with HMM_PFN_MIGRATE), possibly split
>> folios, and insert migration ptes/pmds.
>>
>> HMM pagewalk based migration is enabled in later commit, for now
>> now hmm_select_migrate() returns 0.
>>
> now now -> now

thanks

>
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
>>  mm/hmm.c | 263 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 262 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 119e70dbca56..0ce947d0e572 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -491,6 +491,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
>>  
>>  #ifdef CONFIG_DEVICE_MIGRATION
>> +/**
>> + * migrate_vma_split_folio() - Helper function to split a THP folio
>> + * @folio: the folio to split
>> + * @fault_page: struct page associated with the fault if any
>> + * @hmm_vma_walk: walk in progress
>> + * @ptep: pte_t * for unmap and unlock ptl
>> + *
>> + * Returns 0 on success
> and drops the pte_lock associated with the pte

agreed

>
>> + */
>> +static int migrate_vma_split_folio(struct folio *folio,
>> +				   struct page *fault_page,
>> +				   struct hmm_vma_walk *hmm_vma_walk,
>> +				   pte_t *ptep)
>> +{
>> +	int ret;
>> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
>> +	struct folio *new_fault_folio = NULL;
>> +
>> +	if (folio != fault_folio)
>> +		folio_get(folio);
>> +
>> +	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +	hmm_vma_walk->ptelocked = false;
>> +
>> +	if (folio != fault_folio)
>> +		folio_lock(folio);
>> +
> Could you add a comment on why the get and lock is split into separate steps
> with the pte lock dropped in between

yes will add

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
>>  static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>>  					      pmd_t *pmdp,
>>  					      unsigned long start,
>> @@ -501,6 +558,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Install migration entries if migration requested, either from fault
>> + * or migrate paths.
>> + *
>> + */
>>  static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>>  					  pmd_t *pmdp,
>>  					  pte_t *ptep,
>> @@ -508,8 +570,207 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>>  					  unsigned long *hmm_pfn,
>>  					  bool *unmapped)
>>  {
>> -	// TODO: implement migration entry insertion
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
>> +	WARN_ON_ONCE(!migrate);
>> +	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
>> +
>> +	fault_folio = migrate->fault_page ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	pte = ptep_get(ptep);
>> +
>> +	if (pte_none(pte)) {
>> +		if (vma_is_anonymous(walk->vma)) {
>> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
>> +			*hmm_pfn |= HMM_PFN_MIGRATE;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
>> +		goto out;
>> +
> We use *hmm_pfn and then hmm_pfn[0], could we be consistent. Based on this I
> assuming that there is just one entry in hmm_pfn?

yes

>
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
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page,
>> +						      hmm_vma_walk,
>> +						      ptep);
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
>> +			*hmm_pfn = HMM_PFN_MIGRATE;
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
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page,
>> +						      hmm_vma_walk,
>> +						      ptep);
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
>> +		if (pte_present(pte))
>> +			flush_cache_page(walk->vma, addr, pfn);
>> +
>> +		if (anon_exclusive) {
>> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
>> +
>> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
>> +				set_pte_at(mm, addr, ptep, pte);
>> +				if (fault_folio != folio)
>> +					folio_unlock(folio);
>> +				folio_put(folio);
>> +				goto out;
>> +			}
>> +		} else {
>> +			pte = ptep_get_and_clear(mm, addr, ptep);
>> +		}
>> +
>> +		if (pte_present(pte) && pte_dirty(pte))
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
>> +			if (pte_uffd(pte))
>> +				swp_pte = pte_swp_mkuffd(swp_pte);
>> +		} else {
>> +			if (pte_swp_soft_dirty(pte))
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (pte_swp_uffd(pte))
>> +				swp_pte = pte_swp_mkuffd(swp_pte);
>> +		}
>> +
>> +		set_pte_at(mm, addr, ptep, swp_pte);
>> +		folio_remove_rmap_pte(folio, page, walk->vma);
>> +		folio_put(folio);
>> +		*hmm_pfn |= HMM_PFN_MIGRATE;
>> +		if (pte_present(pte))
>> +			*unmapped = true;
>> +	} else {
>> +		folio_put(folio);
>> +	}
>> +out:
>>  	return 0;
>> +out_error:
>> +	return -EFAULT;
>>  }
>>  
>>  #else
> Thanks,
> Balbir

Thanks Balbir!


