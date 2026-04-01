Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D3ED35144
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A574D6B0088; Wed,  1 Apr 2026 03:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A081F6B0089; Wed,  1 Apr 2026 03:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6BF6B008A; Wed,  1 Apr 2026 03:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F02D6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:05:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6357C6415
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:05:58 +0000 (UTC)
X-FDA: 84609102396.25.0914ADF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0629D1A0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:05:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkQVQASh;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775027157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTQTdfmufH2EOweeeilKJr7KloWw8t6HzsQXkHwD79s=;
	b=TOhvA/3Ee60sPDzK2TDYhPzZ6xRYSi35wxW8TkBFpSjlpKMxg5zuL8BssZ8IOL6o/pUkV4
	dvUOip0/PVRITXeCn35b0VdCYlE9aT0gskQSQ8L9BR8fwUR7T+47TduLpPdDTbcHDfGvLM
	DHwRPQJOwu6rnpCp7gPqem+Qpebzk90=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkQVQASh;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775027157; a=rsa-sha256;
	cv=none;
	b=OSy8LmvtZuWJAHHoIU546fzfnnZtUL5zIwIXeovrs0wWqxt309uuZ3lIGTOL9BoUI442et
	JHg3c9zU8O2rGQBQiSjDUiMhkWf5HKaQBZtPxIMmcwAiUdRy6k9vaA0s+GxNDFb3maSRlE
	EO80iDM22TNsE2diTdXRPV0CrMPlnWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98471404FB;
	Wed,  1 Apr 2026 07:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01500C2BC9E;
	Wed,  1 Apr 2026 07:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775027155;
	bh=c3l6MPA4k0TQ0xyReyvOamQy+3h8kUAjazcvuAgobGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TkQVQASh19TdIE+kSJCQVylESD/gh9WNHjm+1ZaxFTtvW/Tm88WijUSmhVopEuP7Q
	 P6m9W2moTIeXZcx1kzsNkFvwnT3ubCqFs19USnBKKTEJLVv16VDsR0kGy/II0S177L
	 AcXrm4yLCQudSpD3y/RjZ86rarGElt+/x5rynEI1oUKEODe6e0HQu/odmnwT5yS67v
	 H6CsFr+QoA7JliPDDu5IWdSAKfRyD17zHFHS/M1C8X1wMFeXs54/stDLEdaa/SFhoc
	 gnJnjlK1S1Il7UJuIZyssypjNbnuk9h/BtAAfLphXMqayX1r9Y1Rcavw/NIH3yjJM1
	 Yyg6bBB8fMPxw==
Message-ID: <1cdec848-4822-402d-91fb-50237488aec3@kernel.org>
Date: Wed, 1 Apr 2026 09:05:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Nico Pache <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <20260331143538.f41a5fef4201a7384388f31c@linux-foundation.org>
 <CAA1CXcB8D9o=5EC2dbL8N=o9p2WqrHnugoGYmwUvLh8n=w5p=w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcB8D9o=5EC2dbL8N=o9p2WqrHnugoGYmwUvLh8n=w5p=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u6m49q1p6qi6nqpxcphcm9pb93k1xtsa
X-Rspamd-Queue-Id: 0629D1A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775027156-285954
X-HE-Meta: U2FsdGVkX1/gc3cTR+OZBzufqElwbaPYPrI6feNHrul3sQX3Hq/1pJOdavq/nzrYGHq1NQNMNr9QqSAUzu+Ir821I7SKfyH/6pAJ5YYHtXgQs+mBfKgp9vUzKw5deEXgmZaNxpIG9lUiXkXjmXggcyaiu4UA9muladl0G6r3WwBx/hvTFyA4S0ijdbVIFbjAwoi/yDm1B3st7Yv30PE/WpVnn9Vk4cuN9tMFUqbQO6HLHN0eVKDWRABZHTQ2zf/XsCeuv5sRL7L9A2PxXWGCEwprHNNBGd0dKd2w/IDoriv62LlzNsmRA44Rw/dAWn6RZkIqUqB3zgpOKYv+dapCp3V2g0Oke49oKgJRECLZNdTwGKsCtsUkt5cDdIpZxTcNt7deG81VEnHxFXMog1GxeeqNI6luA2y6EbJYEYHr3XcY6zmRAb8vbjFKrvcFQYf+jKqdnPaoWB0VoEmdoPbQKwSJd630lC78MSfmAHfPFksdonU3iG9pG3t4MTgrRtBDCBVSCKlEiCO3oia2jBSC1uKlBrryEguWLOiHVFyfX7kXvpaKKPf5Yg7VIRp6LDgXStfStllWrE7TUEUoHhCVD7v1epD/0nOwuCTZnq4CmbuLdqHxM1PAjNUz5l5ASTUNKAZBbtskIFB0rNfMbNUm6IvJrVoRpc9aZorhAyBX6vGrfSnCgbKiTYSVrRXsT8HsOqJIhmATjJnrs0BDbdnikcmaJzJuxxJ3ShEonjk96RpEvr7646JVjhNsBJ43qnZGsDtpL5GQlV1+Zc11sbQzoC49PoXw6ZbvIq81LSBezeOtLE02LNjNWHwAEKj5fmCOAA5/6TKtdRPpcO6ngcMNmWTsZ9T0th96G+dVb040dqhxmXXh7bP0Sj3YV/DkNA7jdSgjZoG+Z5oxN2ZQJTpJLMqvRreSrEWXrL6osjmBzqRNqWVe6vxdjF+TFVDr/PI8a3XUkUYGpuBgNoYLa7b
 gpuOt2ED
 19o7QGL4QsoNKTnckvAmlgrP33Wog763DkhbxDMVMOiSl/fYXOpiNKvdjFzcyvtAnhUoIHYd7wWAHq2ShCRpwTiRmLZQVSA/1g6S/2QI283SuJGCDf/z2GL0OgiqOEhQZLzlmHWRYuXDfyq34zWc4xdot66Xz8znsb3YWRd2YBCJXEthSwGZ6Bb5PtMgUtBzkiCiWg4iredNtbq4Xv5nYqP7PJtDTo+dVXdSTFBU44TLEecT6tAqYKrnDmAWaagTyh07shK8boTonULZMmcnmLjDQVev2cZ00WHp/XAk7cV6TJt0/pNWxqVkmIsHLTx3EFNpaZ/tXFvpPDyWEez3NS0ncn+shXcn5D+JCCT2o+fEYLEPG9FFPjF+uar0Elf8dHwREANuV7f/mCWXBr1xtxDk3Bp7MMemrH424Vppt6wwgS0Ms5zofIxMWS02YSkGiXAz7R3bV3LVjTdXfKnYlIS7W4mDQJzFNTNckJQveT1C+TEivlmdzsPSlMrGX6uU/Et6W43VhTCm/DeBFaUBFhQJQBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 23:49, Nico Pache wrote:
> On Tue, Mar 31, 2026 at 3:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 31 Mar 2026 22:00:58 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>>>
>>> Right.
>>>
>>> The original code used
>>>
>>>       bool mmap_locked = true;
>>>
>>> If the fix get squashed, maybe we should revert to that handling to
>>> minimize the churn?
>>>
>>> (this is not in stable, right?)
>>
>> "mm/khugepaged: unify khugepaged and madv_collapse with
>> collapse_single_pmd(): is presently in mm-stable.
>>
>> Doing a big rebase&rework isn't the done thing, I believe.  So queue it
>> afterwards, add the Fixes: and tolerate the minor runtime bisection
>> hole.  It ends up looking like a later hotfix.
>>
>>
>> Below is what I added to mm-unstable.  I added a note-to-self to check
>> in on Nico's question at
>> https://lore.kernel.org/all/CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com/T/#u
>>
>>
>> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
>> Subject: mm/khugepaged: fix issue with tracking lock
>> Date: Tue, 31 Mar 2026 13:11:18 +0100
>>
>> We are incorrectly treating lock_dropped to track both whether the lock is
>> currently held and whether or not the lock was ever dropped.
>>
>> Update this change to account for this.
>>
>> Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lucifer.local
>> Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()")
>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Nico Pache <npache@redhat.com>
>> ...
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  mm/khugepaged.c |   12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> --- a/mm/khugepaged.c~mm-khugepaged-fix-issue-with-tracking-lock
>> +++ a/mm/khugepaged.c
>> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_stru
>>         unsigned long hstart, hend, addr;
>>         enum scan_result last_fail = SCAN_FAIL;
>>         int thps = 0;
>> +       bool mmap_unlocked = false;
>>
>>         BUG_ON(vma->vm_start > start);
>>         BUG_ON(vma->vm_end < end);
>> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_stru
>>         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>                 enum scan_result result = SCAN_FAIL;
>>
>> -               if (*lock_dropped) {
>> +               if (mmap_unlocked) {
>>                         cond_resched();
>>                         mmap_read_lock(mm);
>> -                       *lock_dropped = false;
>> +                       mmap_unlocked = false;
>> +                       *lock_dropped = true;
>>                         result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>                                                          cc);
>>                         if (result  != SCAN_SUCCEED) {
>> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_stru
>>                         hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>                 }
>>
>> -               result = collapse_single_pmd(addr, vma, lock_dropped, cc);
>> +               result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
>>
>>                 switch (result) {
>>                 case SCAN_SUCCEED:
>> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_stru
>>
>>  out_maybelock:
>>         /* Caller expects us to hold mmap_lock on return */
>> -       if (*lock_dropped)
>> +       if (mmap_unlocked) {
>> +               *lock_dropped = true;
> 
> Hmm this was =false in David's example and = true here? Now i am also
> confused hahaha. It seems Lorenzo's code is correct. I think i
> responded to my own code changes, when I thought David was replying to
> Lorenzo's.

I think I messed up that in my posting when manually applying :)

So this here is correct.

-- 
Cheers,

David

