Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FE9109B47C
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D3A6B0092; Tue, 31 Mar 2026 10:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D6B6B0095; Tue, 31 Mar 2026 10:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1642E6B0096; Tue, 31 Mar 2026 10:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04C876B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:47:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4AEEC4069
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:47:08 +0000 (UTC)
X-FDA: 84606635736.29.0030A56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9E9B2120012
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:47:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2hZlHle;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774968426; a=rsa-sha256;
	cv=none;
	b=BQm+dm/e8b9Va47dq0UE0CwDdXdb45LiMxKPSvfgZ5j/uAui0U7r5wp35mn0J6uWC54+Oo
	7x9St9JrztuAMZIbZYL3rLVcD+db6OpwXw7zvKY4vY0t7qXKSSMBqZzx0UnL1fBlj7Ri5x
	fOAunA3pdzyA8WeKn63JSh34m1XtTjs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2hZlHle;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774968426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OK0myDRu3OKV5caDIXk6Q+NA1Dw1beRV2xjuFRH6YQ=;
	b=IIUr19wJ69bxLqKIF15Ko7TF3QZP6nYBwtHTz9L6rUiNzSgwCj7XGaMYrqb0wHKjnc+LKN
	UMBGZeCwZyGa6uQtPFa81j2KGatNjYYjVmHbukBKk75KHmPBsJdXSpP9A9h+7CjYSPtV2k
	HZCnpqtKdw3r/eaJet9muW214b0HgAE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F0A041997;
	Tue, 31 Mar 2026 14:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D63C19423;
	Tue, 31 Mar 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774968425;
	bh=Ykir5ONzmHomVd+ALx+S4o3LLuSFRljRqKIFub+1lSg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E2hZlHleGJjipODBYKXQl9jJ8ua2xERXwE4CkSZ594U5xwhzxhOx+jj76KuT1Q9Y/
	 ruBFE5IlBVrZXtKxeBRBYJn0DLLdthndOQ6v7N+v2Npghp+uLJyUbbj9bKSq67VEmr
	 z5ByoQm/oWCBs+ia+K28uqu5Poj7TI8iGoRFY4/shY5gE1kUXShkOz55IzMVCMWYsc
	 1/3ubpogkyxRp4AcxyEzoVsG9sScT16Z+VWld1qYFDvkUuFPO8DrUy1FVwURyXkZs4
	 4Xn9/cLIn0ZPG6ZZ30ylOZTtWn1cTaNq+5exskDL4H3+McS98z+F3hyVGf3b6FRKmT
	 r/Omw50/+qqAw==
Message-ID: <2b2f935c-e72f-41db-81f9-3ef33139e60c@kernel.org>
Date: Tue, 31 Mar 2026 16:46:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E9B2120012
X-Stat-Signature: tt8jwpnenrrbmc9yrfbnd9go936bcyk3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774968426-565916
X-HE-Meta: U2FsdGVkX1+ZAMC3AbyeFqWzCtlAMMzOt2GRB1vPRv+kj2baqKc9MBXwcrLRDLg2fH46Z0vqSTlE0IYaiSt2yH5FvEjNhXI03IXeMqwt5xhcfzH0q/0ctBwUvTd/BEjRVye2KUBykr72N/0SQ8AV+Wxrg9bZfoZ24yR+tHl2cqAuR9m75vHyyJm0Kft4MISwvzmRbnkoNsFVPHHAvt6MxH8hzETawqEbQajq5nvdqE4qHTjtgarThAyxc9Z3slglKbli/kB4IV7ch/buMoRYSQXgvzzExOuSw9xiKh7RsubVaZbrOuzHhSq4lac7pYJRcuilUi8IjYtvNPw5oyelfvLJuNcYNKB2umapVbqQhqduh6QAw03Io1TzVwHzWIRk/oWDHet3zuxpwN6hBcCL4B3YjLwi0nT85yeit9yAtaGMrcnf02Aeo8yymw83+l0uvcbmRxAQcyqJCAxVCSqx6U4LBtyVAL4uJs8weJeBcOHKXdGkT2DGI9aNU55/OQ77MwW9lV5X2OaS8tcgG+lA4ken7uGcCSjj09XuUXO9d+Lsw/JkCOYvoLuIP2/9DU35MftjszWFDVoLoEeCnAczQonF6gmIW3w6dxzTrT+aDi0/wTS6hJYf1jZagkwzpd0J0lfY+9BT0UN8aVqxHnFa/sQZAF7TeDO5/f0bcqPKeq+M73UJMvgKLosfhzk/qcdi7sTx5PswCidA9vFycvwnAUDNaX6B15TDLwNFkgv87e+R+O3NX3MzqyXsX63TZ9SEQPQsE3Rz8nmnE98xlKl+PQjsHzJiqYndkgRNm033HeA3oc9Pz57Lr2xgKHDc6C1csrKPp5Ypi209yUlwOojvu2fAJcCkQrJ4exofeUtK+wDl+c0of8fkVYOKOe0kP1/vTcLd9LP7YuzM2qOcWxW4/XmG1nsfVFJ13NO0yPBwMolFGYOOy9X1JJ0pup9dMb1UNROjw5cH0Y7pT8F6m4+
 P0cDgMnQ
 Iy3XzuUROCR7XgvUPuRZq/gknhaaWwsTWM6uMggMUkHAds0fWvQDFXWnuZDh7wX0z+DV/13o2kMGiTwac/KSDSNN0TZ1cy1OIlcYWnKXKzQw6Cd1VWVJfQnFn9ZetIewtIpiW9cWW7JlT6fSb5Vd4Eg6boaOY+2PgPQhBYKI3zuOzaMOTAqH2YAWjksGgAp3T6iXGxZ2aVx0LlEejupC+jqCl38a6ZkMhqgbXzDtoCnzMEwNWFFehyyR1EoohPFsZFiY4Cnxj/RNJvDQBOaoPQFETtuRGES3kqcAxBoe1SLgrd/jnbrhQce8Y1opbHgJ2g5Q42cYLxYhaZfCjqdSiMY3JmudZDHEo/WKbBTWVsEa6U2DfDZ3r3rhwiwABC1WqJUueKvZXAEa0xB8Al7cEBVeu6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 16:15, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 31, 2026 at 04:13:29PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
>>> dropped, not if it is _currently_ dropped.
>>
>> Ah, well spotted. I thought we discussed that at some point during
>> review ...
>>
>> Thanks for tackling this!
>>
>> [...]
>>
>>>
>>> ----8<----
>>> From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
>>> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
>>> Date: Tue, 31 Mar 2026 13:11:18 +0100
>>> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
>>>
>>> We are incorrectly treating lock_dropped to track both whether the lock is
>>> currently held and whether or not the lock was ever dropped.
>>>
>>> Update this change to account for this.
>>>
>>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> ---
>>>  mm/khugepaged.c | 12 ++++++++----
>>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d21348b85a59..b8452dbdb043 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  	unsigned long hstart, hend, addr;
>>>  	enum scan_result last_fail = SCAN_FAIL;
>>>  	int thps = 0;
>>> +	bool mmap_unlocked = false;
>>>
>>>  	BUG_ON(vma->vm_start > start);
>>>  	BUG_ON(vma->vm_end < end);
>>> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>  		enum scan_result result = SCAN_FAIL;
>>>
>>> -		if (*lock_dropped) {
>>> +		if (mmap_unlocked) {
>>>  			cond_resched();
>>>  			mmap_read_lock(mm);
>>> -			*lock_dropped = false;
>>> +			mmap_unlocked = false;
>>> +			*lock_dropped = true;
>>>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>>  							cc);
>>>  			if (result  != SCAN_SUCCEED) {
>>> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>
>> (in hurry so I might be wrong)
>>
>> Do we have to handle when collapse_single_pmd() dropped the lock as well?

Great, thanks!

-- 
Cheers,

David

