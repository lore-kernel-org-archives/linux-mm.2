Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88715CD342C
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 03:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6667D6B0088; Mon,  4 May 2026 23:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0476B008A; Mon,  4 May 2026 23:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491606B008C; Mon,  4 May 2026 23:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33AF86B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:15:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73E3D8A842
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:15:22 +0000 (UTC)
X-FDA: 84731900484.28.7FF5C4A
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D7991C0011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:15:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYIkqPYu;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777950920;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBjsTW0dEtUCthjX44ExoD3Fq62IAM3qg+4oT6BKLWM=;
	b=WfktSq94Xlio9l8YvLsRQBmKpU6CxDa+Kqs+cyYWYNzGybyzgpfkIaj2ROwyvlicYR1vYx
	Uuoquw/N6l5MxIMgiH9B4wru27AUmsrE3wsWZm5FuSE+qkTHNHclC9HmNcRvhxF2mbgrvW
	nSvU8qFusmNzkhQMKBl7b4lPPaJ0iUY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYIkqPYu;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777950920; a=rsa-sha256;
	cv=none;
	b=Q5b1831zUZxDs8VocMcII+SvtRhcT3Y6zlZKgNCg908nMlMZdK0SfySTJabpDMwx7zZuOS
	s91KgrzH1XRT9IOx6HQOEqiw/1GuOWsq9QZoPTUAL5Nk3p3T/S0zlC6sZ1oIe+zrPk3pvE
	EuTREXiyHMhxFynJXTbFK1OU9J/wfFc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bc1f0f48351so261398666b.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 20:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777950919; x=1778555719; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBjsTW0dEtUCthjX44ExoD3Fq62IAM3qg+4oT6BKLWM=;
        b=eYIkqPYuHzusGVoLmH4nyGcMy3HgITFyRCIrJBTtgWIBsJc9VHRX5AxvC4OsBkjHWM
         o93xO1aGZXLtYk3Q63CzUJGnreC6eeuM5DG1HKN+8CrD4UatiRNccPAkU/mxpmwq0XcP
         yDueJC9sKV9m+Zpyv/WhWpLORfWtezQZZvH80CYrwpGZtiR4a1jM0c8XOnM8pTvIV2X4
         9rQGvfFRh5trq6VcvUc+XA3JwKAohy8X5Ve/JmKfSEQyMXRtRkJLhm4tkrfArcRBh4rR
         eW0oBMf/UIQJZzZ62vHZuvfaQrE7gl9mhcKUcGeVg+Zz4rI8VvZCCZ/PFVHE2VWsrkKE
         MPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777950919; x=1778555719;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBjsTW0dEtUCthjX44ExoD3Fq62IAM3qg+4oT6BKLWM=;
        b=DTeLZJa6JMU2+80RPkB+TuJ0wi/1ULfr+CmlaxWcD9nJTcZGIX4RHEDNzEHOfxGz/m
         OKVY3znyvdvzxefQAPVIRZTV2bpsX4+kSGuBmvyzAGBoHBj1ORHCOhkrwjKllmHnFGm9
         p1yTXVUQtMbYG171A2HNz70mplxI6o2JjI/sHGX3BWefw8qbIR4VLahhXjGL5BenZ0Ft
         ULGezNqAg9DKTQDsAeibJSk5xim1mBgVS2E4Y0cF6WjeUXSBRHqhjH9JaO3zhpbYVrlk
         vYXzIoXb1C1er7ZBx+nmL3rK+fy2jIkCcGRXQd3fzpIKsOwjJstInzpNq61Wr0QKNhbW
         Ryvg==
X-Forwarded-Encrypted: i=1; AFNElJ98BSKgwDmftGeT+S1/e94hGEhK9PKb/JE/21tHIWNtqAZ7yswVZSQcubrM+FP/eSCa28lQ2iWPZQ==@kvack.org
X-Gm-Message-State: AOJu0YxjpKtXSSPdLeFzeFvzJj88t3OVEEwVREPGVaPZtvZ/q+CeQtbp
	49JdzItkxQ+wsLniCPSoaIt5/7mBWgvVKmmKDUUkHT0J5GmhtWgWTuiT
X-Gm-Gg: AeBDieuoudo80cDEeILPbQI8arAxCf5s5jOUQ+usNkmGfSWQNE54ZGKR0m7827FzSQW
	DHk5yTTozT1FagANacnK3bhL7GeLGyGqS3fkgvRAFqeXOnENS0ljiCInCSH13OhXnWMEdhWHG32
	BLNcfA0ELZlidW0G7zn+Xi3eN8ovrPG7R/DRw7DgycDrvUquWLHu2+FBuXCTw744R/5APp9r0Dg
	yYr7KU5kHcisqxOnhy4SeaC5uFSdUgWdUkTtkl6OkqYagz+NgTPpu6HdxxvnY7CHZRSe02HQ1wZ
	KD5SHAmAtLAvqEBm+NY7zfUqUYoCXTWh/zRRANtW7YXwIdpdNsZpN9bvbckbamHJCN2CdOPUxpU
	xf4sbSVYw1uxLS8mY8br6OzYN9SwBRInZyePqhxgRpcnRW02tbx1Qgh1rYAsKhCnYHCVRUxR6XG
	0v0j/xWo1NJfr0l5afP8zG126XSpcuLrEO
X-Received: by 2002:a17:907:d109:b0:bae:c57e:d192 with SMTP id a640c23a62f3a-bbffbf85c9cmr702429166b.41.1777950918179;
        Mon, 04 May 2026 20:15:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bbe6d06e1b4sm450599166b.31.2026.05.04.20.15.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2026 20:15:16 -0700 (PDT)
Date: Tue, 5 May 2026 03:15:14 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	Gavin Guo <gavinguo@igalia.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
Message-ID: <20260505031514.hlnn5o7wkad4teo2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
 <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
 <20260429024913.iepoi7cit3xnwca2@master>
 <413feed4-6aab-43d9-b7e5-a9386fa79f4b@kernel.org>
 <20260503003818.t35q5roc7osx6se2@master>
 <ccb23360-d257-491e-926e-2a7f7b9c98c6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb23360-d257-491e-926e-2a7f7b9c98c6@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D7991C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: orh9n1pfyju6f7btnbaw85ek8zx7j5ie
X-HE-Tag: 1777950920-159063
X-HE-Meta: U2FsdGVkX19ZvyFiZKVLLP2UpnZzJFqdO2L7o2/59SYdJrMvyZ5VLYQ8UPiLBszSPIeKjrl8jT/dIEhhr+UMV4MWs9bGrWO2p3qvOWWidmldh8PBfdqs/TtMURft9tZBffVlnrdA8+fksfTxcpFVASDXaMW6cgZiZ+hO54hRKBBo7/ZrEIUn5MK096eP8NDFo832gv3361fgIlsAUnIAvQoX1NoV0IWVAlXIha2i/b37wDVPfnWgULeyed1rN4765tgyFtE5aCIIgrCQITtbZKn+3X8cNN+hW/hpmJxVwx9daLXvpbry6IuwcXsG6G5SGxnkvFA4Q5jNKkqxeJdPAhuqZY/km0p8b8X1Zbx8DRQJvE3XqQb3WDbnsIUG2wlYdiMY0Ta9b8O/Mg3BBopFK/b2kVEqx3cF63D+FC3Nn8Evnd3WtgwWSay5JJjxu51swHs24okOz8vXPV9pjyp+sJEUmT2u+SG/nzR932Ef8Okg4pKgPhZhrKMPR6wCK0MuGfKcqFPYJD4KuPtSTdp25NqaQkHhjfK7RQFiLCz/I3T3OS2+zH/dyWODjuPrhw3k+xndo3WaccRz/b47obPGG5V2Ti1Uk8PFimum3PqjqVc/VRny3iKkAhcdQZYFYOzcLrxe5+w3Y3HHfQjaMs6Jxm+SZ775hkjelOM9ym+Jb3RpaYGFdXvtHuzRxmk/ZcGmTtBRngVrxgSDyS8JbiFuRlyf/sKZ8DrFDZWx1Lnqse1fPwHc/JuPoKtS1RQ0BEXvaYgGyK+0/q2E4yKxOtmt1ia5OZEmHPN7NthEqmWuEug9/UeY7u2j36wHefA6qNH4BJGkYsZYaO197d/yq7092orqN/UNz/O54cn8njxtrmOdNcnyia1l+wrbeCJ5fyNzCF3YP9XNUsem/MmhEqNU7mOkKd8FJDCnlXsf1n/1J9cfqFHlZ0tq453kmC3ByDoWRPrvmtaON/X0cUHnh3I
 w9CgTp9U
 iNpKkBPOl9f0LQvPG3l6J6h6onIRh4V1hlhM+AyWfhI9iREhlcOUAu+b3jwdf2kxTXZAghZ/6Ezolf2zkY26rHVwPtfRv3D2tpTUVZleBzl7dr5h2JWAzyhFbVwjIatQlk+K1OFNHC938CipGBxxG7X2e/1NdyuI1+q4jdmT+9USO+zSmvQ4NZX5Q6DpVbpeSM6fmlj3gRSE594vbNxlh2G5WVKfiuFTj7wt/Pi3KBcAhjcafSfpbv6rp1hrcr9vzcUwfuk6cVBa/JNjYLJ440nbCqE00R/oYfOG58kfQfQWQVOOHX5BcBZLzMPWbmYZ375ijhzAGkr6CKFJK85Whmop16ZfQoghiEnGXnzN+5jxgGVIYbtQUMvIrj5dbPY2GwaQ/Kdq2fMUE0/1ur61gx4dnKiKgbvVG1z+J8b4fs2YpditcKNRElficiuU+opBXffhYoRSx/IXq9p2X1u/8URNIq4bEez/BzhjXrMldqL7BZjCMxBi0PTPrs97IjMaahq7zOx+z1/Ks5yWlYeQa3QB1a3cIdzzdVlgfOJXnAIL9DpRkrORhlnuJ+zQVAvuHaokuqBOY9quY+ouensz1lKuv2WbfcHXLqa0OQzkrovHykDbCLHw76tpkWXuE3CVffOqOak2GHdY2QcgjqPxchd5+ilpzYd3NohS9mFq1KALWNk1HZ/zh+l6LHz3hoUOhJ5CUDnaJWoq1abdwkHUnETLVZj0vJ5F287id8kp0YbJewfpO+F0GzzTbCpnvkbAMQS9aVtXSAi/8LhHLPkiU8SR/Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 02:44:43PM +0200, David Hildenbrand (Arm) wrote:
>On 5/3/26 02:38, Wei Yang wrote:
>> On Wed, Apr 29, 2026 at 08:55:07AM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/29/26 04:49, Wei Yang wrote:
>>>>
>>>> Below is my proposed change:
>>>>
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index a4d52fdb3056..6e915d35ae54 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -273,17 +273,21 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>  
>>>>  			if (softleaf_is_device_private(entry)) {
>>>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>> -				return true;
>>>> +				if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))
>>>> +					return true;
>>>
>>> As we have a softleaf entry, I assume we wouldn't expect to get any other bits
>>> (access/dirty) set until we grab the lock. Verifying
>>> softleaf_is_device_private() again would be better cleaner, though.
>>>
>> 
>> Got it.
>> 
>>> But really, I do wonder if we should just have a "goto retry" back to the "pmde
>>> = pmdp_get_lockless(pvmw->pmd);" instead?
>>>
>> 
>> Sounds reasonable. See below.
>> 
>>>
>>> And now I wonder why we don't have a check_pmd() handling in there? :/
>>>
>>> Should we check for the pfn here?
>> 
>> Thanks for pointing out. I think you are right.
>> 
>> After re-read the code, more questions come up my mind. I am afraid we need
>> more cleanup for page_vma_mapped_walk().
>> 
>> Below is my finding based on current understanding:
>> 
>> 1. thp_migration_supported() seems not necessary
>> 
>>    The code reaches here means pmd_is_migration_entry() return true, which
>>    means CONFIG_ARCH_ENABLE_THP_MIGRATION is set, otherwise
>>    softleaf_from_pmd() should return softleaf_mk_none() which is not a
>>    migration softleaf.
>>    
>>    CONFIG_ARCH_ENABLE_THP_MIGRATION is set in turn means
>>    CONFIG_TRANSPARENT_HUGEPAGE is set, so thp_migration_supported() must
>>    returns true.
>> 
>> 2. if migration entry change under us, we may need to handle on pte level
>> 
>>    In pmd_is_migration_entry() -> !pmd_present() branch, we have:
>> 
>> 		if (!softleaf_is_migration(entry) ||
>> 		    !check_pmd(softleaf_to_pfn(entry), pvmw))
>> 			return not_found(pvmw);
>> 		return true;
>> 
>>    But I think we need do this:
>> 
>> 		if (softleaf_is_migration(entry)) {
>> 			if (check_pmd(softleaf_to_pfn(entry), pvmw))
>> 				return not_found(pvmw);
>> 			return true;
>> 		}
>> 
>>    Per my understanding, if the pmd_is_migration_entry() change under us, we
>>    need to handle on pte level. Just like pmd_trans_huge() case. Break the
>>    loop and return false seems not consistent.
>> 
>> 3. add proper check for device private entry
>> 
>>    For device private entry, currently we just grab lock and return. While
>>    according to the handling to pmd_trans_huge() and pmd_is_migration_entry(),
>>    we should:
>> 
>>      * re-validate it is still device private entry after pmd_lock()
>>      * check PVMW_MIGRATION
>>      * check_pmd()
>> 
>> 4. consolidate pmd entry handling
>> 
>>    Per my understanding, there are 4 cases for pmd entry handling:
>> 
>>      * pmd_trans_huge()
>>      * pmd_is_migration_entry()
>>      * pmd_is_device_private_entry()
>>      * !pmd_present()
>> 
>>    Now we handle them in a mixed state check, which complicates the logic. And
>>    the first three share similar logic. (If my above analysis is correct.)
>> 
>>      * grab pmd_lock()
>>      * re-validate pmde
>>      * check PVMW_MIGRATION
>>      * check_pmd
>> 
>>    Here I would like to take a more bold step: consolidate handling for these
>>    three cases.
>> 
>>    Below is what it would look like.
>> 
>> 	pmde = pmdp_get_lockless(pvmw->pmd);
>> 
>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>> 		unsigned long pfn;
>> 		bool is_migration;
>> 		bool for_migration;
>> 
>> 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> 		if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd))) {
>> 			is_migration = pmd_is_migration_entry(pmde);
>> 			for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>> 
>> 			if (is_migration != for_migration)
>> 				return not_found(pvmw);
>> 
>> 			if (pmd_trans_huge(pmde))
>> 				pfn = pmd_pfn(pmde);
>> 			else
>> 				pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>> 
>> 			if (!check_pmd(pfn, pvmw))
>> 				return not_found(pvmw);
>> 
>> 			return true;
>> 		}
>> 		/* THP pmd was split under us: handle on pte level */
>> 		spin_unlock(pvmw->ptl);
>> 		pvmw->ptl = NULL;
>> 	} else if (!pmd_present(pmde)) {
>> 		if ((pvmw->flags & PVMW_SYNC) &&
>> 		    thp_vma_suitable_order(vma, pvmw->address,
>> 					   PMD_ORDER) &&
>> 		    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> 			sync_with_folio_pmd_zap(mm, pvmw->pmd);
>> 
>> 		step_forward(pvmw, PMD_SIZE);
>> 		continue;
>> 	}
>> 
>> 5. use "goto retry"
>> 
>>    As you mentioned above. Instead of "handle on pte level", go to
>>    pmdp_get_lockless() for retry. This looks more reasonable to me.
>>>
>>>> +				/* THP pmd was split under us: handle on pte level */
>>>> +				spin_unlock(pvmw->ptl);
>>>> +				pvmw->ptl = NULL;
>>>
>>>
>>>
>>>> +			} else {
>>>> +				if ((pvmw->flags & PVMW_SYNC) &&
>>>> +				    thp_vma_suitable_order(vma, pvmw->address,
>>>> +							   PMD_ORDER) &&
>>>> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>> +
>>>> +				step_forward(pvmw, PMD_SIZE);
>>>> +				continue;
>>>>  			}
>>>> -
>>>> -			if ((pvmw->flags & PVMW_SYNC) &&
>>>> -			    thp_vma_suitable_order(vma, pvmw->address,
>>>> -						   PMD_ORDER) &&
>>>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>> -
>>>> -			step_forward(pvmw, PMD_SIZE);
>>>> -			continue;
>>>>  		}
>>>>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>>>>  			if (!pvmw->pte)
>>>>
>>>> After this, we could simplify the logic in try_to_migrate_one() as:
>>>>
>>>> @@ -2471,14 +2471,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>                                  * so we can detect this scenario and properly
>>>>                                  * abort the walk.
>>>>                                  */
>>>> -                               if (split_huge_pmd_locked(vma, pvmw.address,
>>>> -                                                     pvmw.pmd, true)) {
>>>> -                                       page_vma_mapped_walk_done(&pvmw);
>>>> -                                       break;
>>>> -                               }
>>>> -                               flags &= ~TTU_SPLIT_HUGE_PMD;
>>>> -                               page_vma_mapped_walk_restart(&pvmw);
>>>> -                               continue;
>>>> +                               ret = split_huge_pmd_locked(vma, pvmw.address,
>>>> +                                                     pvmw.pmd, true);
>>>> +                               page_vma_mapped_walk_done(&pvmw);
>>>> +                               break;
>>>>                         }
>>>
>>> Right. But just to be clear: Let's split the page_vma_mapped_walk() validation
>>> (which looks like a bugfix to me) from the other optimization.
>>>
>> 
>> Sure, maybe we can split the page_vma_mapped_walk() cleanup out to another
>> patch set for better reviewing?
>
>Yes, but I assume it could even be fixes?

Agree.

For those above proposed changes, #2 and #3 is proper to be fixes.

 2. if migration entry change under us, we may need to handle on pte level
 3. add proper check for device private entry

The corresponding commit to fix are

   commit 616b8371539a6c487404c3b8fb04078016dab4ba
   Author: Zi Yan <zi.yan@cs.rutgers.edu>
   Date:   Fri Sep 8 16:10:57 2017 -0700
   
       mm: thp: enable thp migration in generic path

   commit 65edfda6f3f2e58f757485a056e4f1775a1404a8
   Author: Balbir Singh <balbirs@nvidia.com>
   Date:   Wed Oct 1 16:56:55 2025 +1000

       mm/rmap: extend rmap and migration support device-private entries

As Andrew suggested, I would send fixes and cleanup separately.

After all these settled down, I will respin this thread.

-- 
Wei Yang
Help you, Help me

