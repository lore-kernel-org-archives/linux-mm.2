Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D99D1093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731056B0088; Sat, 21 Mar 2026 01:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1936B0089; Sat, 21 Mar 2026 01:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7616B008A; Sat, 21 Mar 2026 01:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE4E6B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:16:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 747028B960
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:16:00 +0000 (UTC)
X-FDA: 84568908480.12.18C7C32
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3953120010
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:15:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vrjHU6Mf;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774070158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvE5u6hIUEMa2cVmHPs2YrFYnl8iGvj61myQt4xkm9o=;
	b=kt7sBP1kKVi/hvyQGOji20/8pE8ozHUZD8i/cfghlykzqBZJenzkhPob+uvWdk7tenIEJZ
	kFW9zZiGkghyV2bL9x74H37U2SZw1QtJM1IRrkGv4ikdMIfkaAIU1GPlby72RfCEHXCIlb
	ZhdoP1j867XgqIDX0PP8+bFmRrOrxMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774070158; a=rsa-sha256;
	cv=none;
	b=DVWSHG5nM3aO6UOzuZUzS0LooBhf4xmJWFSaQBoKwYcqLEA04GRp6bqVODtQpu+UbuOpQG
	c84pfcr1NEJTf6faI9drksQ/fM1onjspoL/3nuakoAyGs59rXrYv0+GJ8gwANM5xQNRkeJ
	ZjY4S900a79fsweRHbOmmj8kzudcjhE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vrjHU6Mf;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774070154; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FvE5u6hIUEMa2cVmHPs2YrFYnl8iGvj61myQt4xkm9o=;
	b=vrjHU6Mfzz9yKrBjZVAfq/mdqo3lO61CMuGym7S/d8tpzPKsg1KmycPSOV9F/WNKWnS6pCemODqYP8M7T3ciKvmmozXbuhdRJTxioGSB2hSdcyDKzb8rvkrqiWrKkGjcbPTaoOsHIKMmmaoNN4Wr7z2eBuBMOcm1BMEUzxp9olo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.O3cfU_1774070150;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O3cfU_1774070150 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:15:52 +0800
Message-ID: <a39eed3f-2d94-4e40-b011-94172e03ff25@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:15:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm/huge_memory: deduplicate zap_huge_pmd() further
 by tracking state
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <440f68edcb597c28918d89b0be279d498561c89a.1773924928.git.ljs@kernel.org>
 <d67ff262-a627-4cd3-b126-dd82eb8d3412@linux.alibaba.com>
 <a1962a7c-1638-444d-ba9c-6d60fca752c6@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a1962a7c-1638-444d-ba9c-6d60fca752c6@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C3953120010
X-Stat-Signature: a5zknz16xjwwmnny8ohuo78t9itctb5j
X-Rspam-User: 
X-HE-Tag: 1774070157-740506
X-HE-Meta: U2FsdGVkX1+GkD7GPup7ZvHAREZ5ptONT1sykd6NAkBf3rB5esofLM+q3p3NawFescZW3Ljb2H2Ovsx5cFwoWiwfsXLBPMYGy3pzBm3ub+LIbqnfqkS01YdokmhdrFv1ZaN7awKuRw8VSKlMVDMpcA30SQ/Jdb9k9kPGgIfKJabKeLwysJh2wda2JQEqp9oBLa8xOyPVelCjy1/SAu0acl46wzc08H926tYvPjQ8BurIKluxqbC4ZTQfhvTZ23jv0QwSJto9tojPpJOIuYO94VwwpUgsmI37VZr75ocp3pIK0ubXYCfQvTTkFL8NPgvWdSSo6O8GgqaxmuMYyTVn0FfmDLGwcOl2XUlIFrcLtCjeJIXVeVpog9pgcyV3t09Jpli7nLBQRXUe04EPfNS2r/5yMuJN5vHlEouFJ49DipJSoAsWS+BJz+7dzafRxMgmIf3cJPt/XhNMKaf+BEXpYWuIrcTQqk5vfTLJgt/kpo8WTPTPQz2XxnCx2cV/UheGtl0Xvi3vkL+Wtwes6fdhl/tYDamU0dwX5rYtj6yNmVMBSrPYGCT8yk1BhdLcRP0lHxcWpPxXwA2bT1SpgxKAARi1zY/WlK/EqqfAuoNODFd802E9p2YKThXTGHn1RCSLhljBAqYcnNct/MAHqQUE0omrYKRTRXI7ztH+Vxupjvsda9Zjd5VqJy40WrZwj8RCzfUFKaCdkuABIC7HvOseD66J0mhf1O7XbTdDvcSi5yM2d7fW1uJsgzQPG5imVVj4237mqFnlrHQuG7eLb5BpxMcIMeCuojpcHeqo86hmfSiakgdmv6EBX2dcCkBjMo96ZdXY8CoDk3/1PZW715LUQsCgoTs74ziWG5MW/gq8WmvpEs3XS3agVLD2vbZjmNXkvtu+a/ed9fIlkIlKJw8ONLiPdilgTCy/vQEN0jYY8RyrfP8J9wTEY+Rlqmx+aHrXv4QAobEb69LVeIns35o
 L1T4bAgC
 Odj2YzImuFV7xNG0/ehqvAO/dTnIao48HCtfsRfGb0X2UYp91S0ji8EHuG86mlIlVQXnHOKLbOTYGqHCvzBsXipLyjjse7X0vWxUwjsx2aMqTDLuTEeqc9aFcHH8kxQcwYjDDt9LQxLWFeitnNd9YYFNJf5mRSN05k9sHoUrrm6Muu3E1PgtnqJKbAgXB99Rm+qIXEk390wjWbfaW6Np9ss8+Fz/EGMS9UqIaqkG6vFr23ClCQGvDTnh0Tw76QVRU/Q3ob29wrLt3Cv5U8x6D0qxfb9KxIrfryPPT/S4QlqFazIIVhb7ZOVB63Xvg/p55AzKRtiim7jusNZWYAv4bCIydvLNqLdjT7YuWpElE86FmnZRxiO36FdPVVIGUFHHX2ets
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/20/26 9:51 PM, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 20, 2026 at 11:49:18AM +0800, Baolin Wang wrote:
>>
>>
>> On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
>>> The flush_needed boolean is really tracking whether a PMD entry is present,
>>> so use it that way directly and rename it to is_present.
>>>
>>> Deduplicate the folio_remove_rmap_pmd() and folio map count warning between
>>> present and device private by tracking where we need to remove the rmap.
>>>
>>> We can also remove the comment about using flush_needed to track whether a
>>> PMD entry is present as it's now irrelevant.
>>>
>>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> ---
>>>    mm/huge_memory.c | 28 +++++++++++++---------------
>>>    1 file changed, 13 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index c4e00c645e58..22715027e56c 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2430,9 +2430,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>>>    bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>    		 pmd_t *pmd, unsigned long addr)
>>>    {
>>> +	bool needs_remove_rmap = false;
>>>    	struct folio *folio = NULL;
>>>    	bool needs_deposit = false;
>>> -	bool flush_needed = false;
>>> +	bool is_present = false;
>>>    	spinlock_t *ptl;
>>>    	pmd_t orig_pmd;
>>> @@ -2449,6 +2450,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>    	 */
>>>    	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
>>>    						tlb->fullmm);
>>> +
>>>    	arch_check_zapped_pmd(vma, orig_pmd);
>>>    	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>>>    	if (vma_is_special_huge(vma))
>>> @@ -2458,17 +2460,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>    		goto out;
>>>    	}
>>> -	if (pmd_present(orig_pmd)) {
>>> +	is_present = pmd_present(orig_pmd);
>>> +	if (is_present) {
>>>    		folio = pmd_folio(orig_pmd);
>>> -
>>> -		flush_needed = true;
>>> -		folio_remove_rmap_pmd(folio, &folio->page, vma);
>>> -		WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>> +		needs_remove_rmap = true;
>>>    	} else if (pmd_is_valid_softleaf(orig_pmd)) {
>>>    		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
>>>    		folio = softleaf_to_folio(entry);
>>> -
>>> +		needs_remove_rmap = folio_is_device_private(folio);
>>>    		if (!thp_migration_supported())
>>>    			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>>>    	} else {
>>> @@ -2483,27 +2483,25 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>    		add_mm_counter(tlb->mm, mm_counter_file(folio),
>>>    			       -HPAGE_PMD_NR);
>>> -		/*
>>> -		 * Use flush_needed to indicate whether the PMD entry
>>> -		 * is present, instead of checking pmd_present() again.
>>> -		 */
>>> -		if (flush_needed && pmd_young(orig_pmd) &&
>>> +		if (is_present && pmd_young(orig_pmd) &&
>>>    		    likely(vma_has_recency(vma)))
>>>    			folio_mark_accessed(folio);
>>>    	}
>>> -	if (folio_is_device_private(folio)) {
>>> +	if (needs_remove_rmap) {
>>>    		folio_remove_rmap_pmd(folio, &folio->page, vma);
>>>    		WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>> -		folio_put(folio);
>>>    	}
>>>    out:
>>>    	if (arch_needs_pgtable_deposit() || needs_deposit)
>>>    		zap_deposited_table(tlb->mm, pmd);
>>> +	if (needs_remove_rmap && !is_present)
>>> +		folio_put(folio);
>>> +
>>
>> This kind of deduplication splits the device folio handling into three
>> places, which is not easy to understand (at least for me), since the device
>> folio has some special handling.
> 
> I think open-coded the exact same thing over and over again is FAR worse.
> 
> It's also actually 2 places for softleaf, because we were duplicating #2 below:
> 
> 1. how do I get a folio?
> 
> 2. do I need to remove this folio from the rmap? (yes for device private)
> 
> 3. Do I need to put the folio (yes for device private)
> 
> You're maybe now just seeing exactly what happens here because the code is
> clearer? Because before it was an unfathomable open coded mess with no
> explanation.
> 
> Now you explicitly see what's happening :)

Yes, I understand your point:) I saw that you changed the code to use 
the 'is_device_private' variable in the new version, which is more 
readable for me. Thanks.

>> Especially here, without looking closely at the if condition, it is unclear
>> why we need to call folio_put(). Maybe some comments?
> 
> I can add one, the original didn't. This is an existing issue :)

Thanks.

