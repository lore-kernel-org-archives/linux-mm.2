Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02F6FF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455FD6B008C; Mon,  4 May 2026 08:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407596B0093; Mon,  4 May 2026 08:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5A66B0095; Mon,  4 May 2026 08:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0316B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:44:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABCC41C01FA
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:44:52 +0000 (UTC)
X-FDA: 84729706824.04.29CB3C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E69668000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:44:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cMiyvhB3;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777898690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpVXvPZV/zFRtaX4eEFUKzGXHRxGzcYHVpBA8Lc91to=;
	b=szMC7EFi2ux8q45l3B3CVVZNyyMx+Q5tGY386AP1IRH6pBq6h42WkTCsyR8n5Kvxhx9CBC
	cWhlq83bfWZYqGAD0cbR4NwZh5XGf56t3+jU7sxI2eov5TsjgDp4G/TcR5TYfyk16d7Ks6
	wsOPwoHi/mg/cx3xegzLZxCt3eI2m24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777898690; a=rsa-sha256;
	cv=none;
	b=ctEr76FZb8tVEd8AApmWkpxV4cOfFNbE9/Ce/IZQtZ9EFWCuM17GsQlrqcYW8bFmQ0iuT6
	HWpBURT4fuu5yTyaptvROT2DamBC5+4l4A8Wvc7T01EQHNjNKZj3eukY/1xh7Fwe25AqBe
	KZYmyyS4rJcqk3c7XVfRG/31zQzCqtM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cMiyvhB3;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54AAF600C3;
	Mon,  4 May 2026 12:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9327C2BCB8;
	Mon,  4 May 2026 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777898690;
	bh=4lxY/tJN+EMZZWhTvHOfJiwS3xawS0nruBOHDNuQpJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cMiyvhB3L5THRWy1Mp3cA0sCr0CcMi0YSaKsal0JoT36wZgm59hvkr5FXwaUB8guF
	 zp5ysitfWQ/pzI8bVbPBRVUJHfSE+ZP5R5JnqEWSA6/zxP0gpQkblSiI6O/E58yY9b
	 +IIkqXFhr5oPuFtLoxzqR9tyf55EfRFwtlSeYk+xu0839fFdU3M9dBC0HMwbFgH0xn
	 t1877igCVh5apTocKdvDO+Sf1qGeUyXocwwZtvzM5WlcdOZb9134PcUkT5WeqWk/AW
	 Sdc16sRy2e6xY8nsphWW9zWUmHYcnGZk0x+NQ9bo6TBdMtCxBiaME/QLS1Pzb1ZGAY
	 cFF9B9UdBYgxg==
Message-ID: <ccb23360-d257-491e-926e-2a7f7b9c98c6@kernel.org>
Date: Mon, 4 May 2026 14:44:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, Gavin Guo <gavinguo@igalia.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
 <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
 <20260429024913.iepoi7cit3xnwca2@master>
 <413feed4-6aab-43d9-b7e5-a9386fa79f4b@kernel.org>
 <20260503003818.t35q5roc7osx6se2@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260503003818.t35q5roc7osx6se2@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E69668000F
X-Rspam-User: 
X-Stat-Signature: nteie8bw6sdhg73s81hbnpbtgqmsujar
X-HE-Tag: 1777898690-61154
X-HE-Meta: U2FsdGVkX18IEF4mUqMYOl9dRt3luijHT8g1Hk1QE+MJzl15jpqIuQNrrW448ggMiDcugDhrl1wXbVZtuoluuQRlR5FlUTUShNuiwtkugT7VvkJAWIImCH5C+NWpGLtd0tyDhOiVBizVXh34fqt2QGjjIul7uV+1p+pcGR2lFbmeCV2tAl4XDK7hVdhVfVr33gRJlKLh5r6vKjSPuVfj7ICJKi2TVshZeomepRzcMQFbIOI5+YyviNzLCZBm4vrlNdtKV0eFXbSW/FSxk3t+0uwV+p4e5cghYJnOEiddc2PBeuCpePFqP9pv4X9aAhw2ytWSqbuK/bWYjJU9fZI7yPnAByaKbsbd0uCf0zqSg6+ZrleFgduR9lyeA/eg+yyFJ8mFALakrjxthLxZG09lAs0LL8Z+0SfhzTgGBVao83o1yritPBhGd91Ek/ZNioXkY7SDcHOAUpo3Vxeq6P+qxjWl+Yjvj5162STIIqmq/jQ2AnGzAt1Jo3ylUdnUnnJAokCKtVIULUUYQbM3Naluh+CTE8rcJKvk6alDwqlbtpAyd0F2bL9ha0aDqEfbLQqJpDH4rgE4RJQYrzu9kxlUPbhjMDGTLJNISl8Kau2jpg7E6ZVbAhEbfIBTP5bx2G2PE21Pr8jcNO4E5muYMHpSKI3n3z2gVIgX+vYaHe7g0acIeQh43RstWg5k8/tt+M6m/80z2VzOlFXdowMdRe0FLZ2WwvG8d8b9HkMLd70xc71ibQ8KTCnBkuiBgc8TY744Prfxhv8m+3YSHPAbC8tVFOpH9KwsQzAg58JNiE2KrayaOeGNO7Faiq5tOu2pqNHnbS7xXlumilDmn6bvpTw7A3cUZfw9/O2iG7WCa7tL4qPliuZ/l/ozNJiQEjEs+jbxfpyjq80te8Z81kPq0OTrEyQ22YkDVeYP2iJmQKcw0iG8VcKQLgaRYMpQsicwwqbN4egOK68Are1fiXNTXMA
 xai6Gsfe
 uo0lIaH+Y4zsmJ0XZKurPjmePBtOhFO3jQPFt8MaJOrAi/ubVvB2jZ9jKCSYYBVK8nwd5xGnKWoHqlZDUHzbTnp4b2b5ds7/HLN3J0K3YuMcKU5IGRg6pEFRZ+AKY01GwxArCF0TW8wNlXmcWoHX4V4faKmNEUtrKd2SpDyyedbw7Hee8MMhpT2fbST0G5SWejsPO6zh0r4wwNOdv1uB9h05lGf/0GZGvSWjqCU2L5OGn/ac1KocmVPmhPUx3WAZBjRAjZr+5UPNiYxpKcVJfUzaoY83PBo56VdQFe1oDTNXHZMLQrub8WeZDHlGU38Yk4OZm6dSEkrySUvCP+E6TT5ieualCXjLz75d3Wp2Wg2WXW4M3KVAhkN0PAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 02:38, Wei Yang wrote:
> On Wed, Apr 29, 2026 at 08:55:07AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/29/26 04:49, Wei Yang wrote:
>>>
>>> Below is my proposed change:
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index a4d52fdb3056..6e915d35ae54 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -273,17 +273,21 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>  
>>>  			if (softleaf_is_device_private(entry)) {
>>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> -				return true;
>>> +				if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))
>>> +					return true;
>>
>> As we have a softleaf entry, I assume we wouldn't expect to get any other bits
>> (access/dirty) set until we grab the lock. Verifying
>> softleaf_is_device_private() again would be better cleaner, though.
>>
> 
> Got it.
> 
>> But really, I do wonder if we should just have a "goto retry" back to the "pmde
>> = pmdp_get_lockless(pvmw->pmd);" instead?
>>
> 
> Sounds reasonable. See below.
> 
>>
>> And now I wonder why we don't have a check_pmd() handling in there? :/
>>
>> Should we check for the pfn here?
> 
> Thanks for pointing out. I think you are right.
> 
> After re-read the code, more questions come up my mind. I am afraid we need
> more cleanup for page_vma_mapped_walk().
> 
> Below is my finding based on current understanding:
> 
> 1. thp_migration_supported() seems not necessary
> 
>    The code reaches here means pmd_is_migration_entry() return true, which
>    means CONFIG_ARCH_ENABLE_THP_MIGRATION is set, otherwise
>    softleaf_from_pmd() should return softleaf_mk_none() which is not a
>    migration softleaf.
>    
>    CONFIG_ARCH_ENABLE_THP_MIGRATION is set in turn means
>    CONFIG_TRANSPARENT_HUGEPAGE is set, so thp_migration_supported() must
>    returns true.
> 
> 2. if migration entry change under us, we may need to handle on pte level
> 
>    In pmd_is_migration_entry() -> !pmd_present() branch, we have:
> 
> 		if (!softleaf_is_migration(entry) ||
> 		    !check_pmd(softleaf_to_pfn(entry), pvmw))
> 			return not_found(pvmw);
> 		return true;
> 
>    But I think we need do this:
> 
> 		if (softleaf_is_migration(entry)) {
> 			if (check_pmd(softleaf_to_pfn(entry), pvmw))
> 				return not_found(pvmw);
> 			return true;
> 		}
> 
>    Per my understanding, if the pmd_is_migration_entry() change under us, we
>    need to handle on pte level. Just like pmd_trans_huge() case. Break the
>    loop and return false seems not consistent.
> 
> 3. add proper check for device private entry
> 
>    For device private entry, currently we just grab lock and return. While
>    according to the handling to pmd_trans_huge() and pmd_is_migration_entry(),
>    we should:
> 
>      * re-validate it is still device private entry after pmd_lock()
>      * check PVMW_MIGRATION
>      * check_pmd()
> 
> 4. consolidate pmd entry handling
> 
>    Per my understanding, there are 4 cases for pmd entry handling:
> 
>      * pmd_trans_huge()
>      * pmd_is_migration_entry()
>      * pmd_is_device_private_entry()
>      * !pmd_present()
> 
>    Now we handle them in a mixed state check, which complicates the logic. And
>    the first three share similar logic. (If my above analysis is correct.)
> 
>      * grab pmd_lock()
>      * re-validate pmde
>      * check PVMW_MIGRATION
>      * check_pmd
> 
>    Here I would like to take a more bold step: consolidate handling for these
>    three cases.
> 
>    Below is what it would look like.
> 
> 	pmde = pmdp_get_lockless(pvmw->pmd);
> 
> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
> 		unsigned long pfn;
> 		bool is_migration;
> 		bool for_migration;
> 
> 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> 		if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd))) {
> 			is_migration = pmd_is_migration_entry(pmde);
> 			for_migration = !!(pvmw->flags & PVMW_MIGRATION);
> 
> 			if (is_migration != for_migration)
> 				return not_found(pvmw);
> 
> 			if (pmd_trans_huge(pmde))
> 				pfn = pmd_pfn(pmde);
> 			else
> 				pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
> 
> 			if (!check_pmd(pfn, pvmw))
> 				return not_found(pvmw);
> 
> 			return true;
> 		}
> 		/* THP pmd was split under us: handle on pte level */
> 		spin_unlock(pvmw->ptl);
> 		pvmw->ptl = NULL;
> 	} else if (!pmd_present(pmde)) {
> 		if ((pvmw->flags & PVMW_SYNC) &&
> 		    thp_vma_suitable_order(vma, pvmw->address,
> 					   PMD_ORDER) &&
> 		    (pvmw->nr_pages >= HPAGE_PMD_NR))
> 			sync_with_folio_pmd_zap(mm, pvmw->pmd);
> 
> 		step_forward(pvmw, PMD_SIZE);
> 		continue;
> 	}
> 
> 5. use "goto retry"
> 
>    As you mentioned above. Instead of "handle on pte level", go to
>    pmdp_get_lockless() for retry. This looks more reasonable to me.
>>
>>> +				/* THP pmd was split under us: handle on pte level */
>>> +				spin_unlock(pvmw->ptl);
>>> +				pvmw->ptl = NULL;
>>
>>
>>
>>> +			} else {
>>> +				if ((pvmw->flags & PVMW_SYNC) &&
>>> +				    thp_vma_suitable_order(vma, pvmw->address,
>>> +							   PMD_ORDER) &&
>>> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>> +
>>> +				step_forward(pvmw, PMD_SIZE);
>>> +				continue;
>>>  			}
>>> -
>>> -			if ((pvmw->flags & PVMW_SYNC) &&
>>> -			    thp_vma_suitable_order(vma, pvmw->address,
>>> -						   PMD_ORDER) &&
>>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>> -
>>> -			step_forward(pvmw, PMD_SIZE);
>>> -			continue;
>>>  		}
>>>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>>>  			if (!pvmw->pte)
>>>
>>> After this, we could simplify the logic in try_to_migrate_one() as:
>>>
>>> @@ -2471,14 +2471,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>                                  * so we can detect this scenario and properly
>>>                                  * abort the walk.
>>>                                  */
>>> -                               if (split_huge_pmd_locked(vma, pvmw.address,
>>> -                                                     pvmw.pmd, true)) {
>>> -                                       page_vma_mapped_walk_done(&pvmw);
>>> -                                       break;
>>> -                               }
>>> -                               flags &= ~TTU_SPLIT_HUGE_PMD;
>>> -                               page_vma_mapped_walk_restart(&pvmw);
>>> -                               continue;
>>> +                               ret = split_huge_pmd_locked(vma, pvmw.address,
>>> +                                                     pvmw.pmd, true);
>>> +                               page_vma_mapped_walk_done(&pvmw);
>>> +                               break;
>>>                         }
>>
>> Right. But just to be clear: Let's split the page_vma_mapped_walk() validation
>> (which looks like a bugfix to me) from the other optimization.
>>
> 
> Sure, maybe we can split the page_vma_mapped_walk() cleanup out to another
> patch set for better reviewing?

Yes, but I assume it could even be fixes?

-- 
Cheers,

David

