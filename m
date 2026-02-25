Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4C6FD3764
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8576B008C; Wed, 25 Feb 2026 09:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FB16B0092; Wed, 25 Feb 2026 09:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9721B6B0095; Wed, 25 Feb 2026 09:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 822F86B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:29:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0F2216064A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:29:12 +0000 (UTC)
X-FDA: 84483211344.18.A214D29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E95FD1C0011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:29:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dih97yUw;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772029751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hglIMTi5yH96FKO0KlPxpmEj708Ntm0CckS6EOHKm+8=;
	b=O7FACRhmB+LY5dC7nu20XyFeclWqh8e5Tc0F8OX3SCMoyD0UO1SEBBgOfag13a73QJxTZG
	ufv6lgoTho1r+CmRiXc+wjm0z9MEg2UEchFlLPPZhBGuo/d23xUWxZQNgonIwsHE+ou5aU
	9bLaYUaOqfk2ovuZOk4Ym9rbUGG9/Ws=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dih97yUw;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772029751; a=rsa-sha256;
	cv=none;
	b=qJggdJUWxaz04+YJSSmIQdksxW+HbnBND2erEwuN7XR7o3vYI42COfGDIHVRVLZogDTX7/
	jd/CQ682fTgyAgiMomD4KULZr2OEDWGk3TmbvavnqaeNILh3Oir/prrcR+UlsnqQO4JT/X
	bEnV8lYYr8thDZQAVOV6DmuU2A9rJSA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA5B343EC2;
	Wed, 25 Feb 2026 14:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACDFC116D0;
	Wed, 25 Feb 2026 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772029749;
	bh=xTbnO8irbggftyZ2HO6Vjdj/n/hlLlq5vQffuB15YcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dih97yUwR5cLKaWMB8pNBZDprkzmb2dUqR1rK3NfIEcPxo5Yz3wpWHdSS+aSQMt9X
	 Cc7g0YLwBzPzQ6TESotA72/54lLfRW5hMzQrpKjQbAlRJdkhE0JRaXGiUDgKW/pWh1
	 7OUBCvIIOgb6dpnuJsEs+HaNqKjYkdEp+Id2lTstuh8LNGUE02GL7TMl+tbhvrZJ13
	 MSfXqC8jTOZ5gm7Li2V+zJCFcZ+gSrhbTOZ3vt8VbD1LLtplr60rphx8sjXSQ/Og9H
	 HwnI+5iVAKaZleRVtiLbQKo0bZZWq5+uUcF4yjxf9coxPjhsFwvKD8fKzl5AVAu6DN
	 I0kbaOLLWxTmg==
Message-ID: <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
Date: Wed, 25 Feb 2026 15:29:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E95FD1C0011
X-Stat-Signature: im4c6jcbs1g8kbke4bk38meekc6ugxqa
X-HE-Tag: 1772029750-11800
X-HE-Meta: U2FsdGVkX18jyr/hAMT+Rc2U4CwTeKT+n9LrHe3XobbqiK7ZJcOPFbO+A4uaHjBrp90t923lY5vbwN3XlEt3jwInRAbuOk7AgkqviwXvpNbeSIL5QnodFGIui0ObSGS2OLLJP2eri1z+kLBgnTk81OqAx7Ytb75hfeoTMomUpxvxmwUEHtKnhCJF9X9pwmA0hHuUI7TrfI+kXCTHHpiOg3a8ymjD53Nm5OP+3JjolrJe4KeqsgbNnBnqEi//Fet8CxWOls/qSrXHsGrpu5zPJzOcDMU5Rlvl+YkBt8bBOWTRXr+Xp8oppg2xDO8Xsl+WJzpSQaQIjpPvqGZqGGcYfDmMJWOlLAOdfhovYRpM0XF/KqBwZ879ST67iJ5v8+yCFLak2ysFZA/6KBmqv2qYrLU2eJCi/lNUinSWnK9e5QDE0V1npuk+MsQUgv0G74Opm8yxinUkntxdo9tzlQ8QFwc8WGztFC8WoLwiCwIB/+NeRWee5mlWXvMo12eojHC5GbG845P4jfvRlx304J63N6ueNHarbP2dPCRNHK++D3mBeXfEUu0G3JuUZCBM3CQEucPvMGQfLVyfSmgHBVnx6+CmNPsRacWkGgYwjnkrGYd6k7193nonoD83H33k8g5rH6FQvmIPvKPn+taAKP2ZDGiZWrnXenGWUgpFweiAhECf9WYRbPJi4Nl+GCbONfuWpnDKyUF0hZpu/yN/MmxC5uxim/CZsTmQQcNl6SQy3gZr8IZyjxe1xDIEp6MTDKyEvadwN8GbQcyH6u4+EgKErjWFlmSyXvvlW2P64z1i/eT7EbVbD1i0hXGUDZmX5kNhelyrRKKQMU48tWUYQ2q5rBAKHQLkThmRhrrXPfYJmsOIu1ff7CRwYHZQHdbgEY0MsNUYW6DZSY1rq6IBS4Ao60eiSfZWUWlnJo8c5k1iFJ0HOQbTYkJ3atG47PjPOrFE/g7zZmL1GeNzWLBNfsL
 UoM/IGs3
 pASQXXZDnKgY+S3z7ZemGNc2kU27w9MVsaWKsNQI4jqGRkvNjhGbg2vgRshB30PbcVjhYmepwnY0nTzTrkbiZuvjKkpfuPUNQFPD6DT07X9SdtyEKIlKEAAAS/DPWyJ5Z7GBNq4PqXu0m7Niw+6PC0UeOf5h6QOBJvdWmFvPKMOcTmRscNW7t0aITWyqmXkha2Pejkzdh96zm2rkyHYfJTvDX2p73epHhq27J3igEVFkD2k2W+j3J9fm2Erz3EuWVhWo8lm5sRfDfvC2WGVtmFp8Gv0vLtBozmoGn59IgUSxqHFw3Rayx2gt4JaJiC/sv4cdBdnzQ61W8V9FQ6LP2smfyxLNgwOlsw9bQiMadyv29u4TDhFxWveNGjdiAxp5gVuyUTtiJ/1MUseEE7505aPbwpIMY+4HzkTdd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 15:25, Vernon Yang wrote:
> On Tue, Feb 24, 2026 at 03:52:47AM +0000, Wei Yang wrote:
>> On Sat, Feb 21, 2026 at 05:39:16PM +0800, Vernon Yang wrote:
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>
>>> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
>>> even if only scanning a single PTE/PMD entry.
>>>
>>> - When only scanning a sigle PTE entry, let me provide a detailed
>>>  example:
>>>
>>> static int hpage_collapse_scan_pmd()
>>> {
>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> 	     _pte++, addr += PAGE_SIZE) {
>>> 		pte_t pteval = ptep_get(_pte);
>>> 		...
>>> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
>>> 			result = SCAN_PTE_UFFD_WP;
>>> 			goto out_unmap;
>>> 		}
>>> 	}
>>> }
>>>
>>> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
>>> directly. In practice, only one PTE is scanned before termination.
>>> Here, "progress += 1" reflects the actual number of PTEs scanned, but
>>> previously "progress += HPAGE_PMD_NR" always.
>>>
>>> - When the memory has been collapsed to PMD, let me provide a detailed
>>>  example:
>>>
>>> The following data is traced by bpftrace on a desktop system. After
>>> the system has been left idle for 10 minutes upon booting, a lot of
>>> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
>>> by khugepaged.
>>>
>>> >From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
>>> following statuses were observed, with frequency mentioned next to them:
>>>
>>> SCAN_SUCCEED          : 1
>>> SCAN_EXCEED_SHARED_PTE: 2
>>> SCAN_PMD_MAPPED       : 142
>>> SCAN_NO_PTE_TABLE     : 178
>>> total progress size   : 674 MB
>>> Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
>>>
>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>> as long as the task is not destroyed, khugepaged will not remove it from
>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>> scan it, which wastes CPU time and invalid, and due to
>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>> scanning a large number of invalid task, so scanning really valid task
>>> is later.
>>>
>>> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
>>> SCAN_NO_PTE_TABLE, just skip it, as follow:
>>>
>>> SCAN_EXCEED_SHARED_PTE: 2
>>> SCAN_PMD_MAPPED       : 147
>>> SCAN_NO_PTE_TABLE     : 173
>>> total progress size   : 45 MB
>>> Total time            : 20 seconds
>>>
>>> SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
>>> https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>> mm/khugepaged.c | 42 ++++++++++++++++++++++++++++++++----------
>>> 1 file changed, 32 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index e2f6b68a0011..61e25cf5424b 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -68,7 +68,10 @@ enum scan_result {
>>> static struct task_struct *khugepaged_thread __read_mostly;
>>> static DEFINE_MUTEX(khugepaged_mutex);
>>>
>>> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
>>> +/*
>>> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
>>> + * every 10 second.
>>> + */
>>> static unsigned int khugepaged_pages_to_scan __read_mostly;
>>> static unsigned int khugepaged_pages_collapsed;
>>> static unsigned int khugepaged_full_scans;
>>> @@ -1231,7 +1234,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>>> }
>>>
>>> static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
>>> +		struct vm_area_struct *vma, unsigned long start_addr,
>>> +		bool *mmap_locked, unsigned int *cur_progress,
>>> 		struct collapse_control *cc)
>>> {
>>> 	pmd_t *pmd;
>>> @@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>> 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>>
>>> 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>>> -	if (result != SCAN_SUCCEED)
>>> +	if (result != SCAN_SUCCEED) {
>>> +		if (cur_progress)
>>> +			*cur_progress = 1;
>>> 		goto out;
>>> +	}
>>
>> How about put cur_progress in struct collapse_control?
>>
>> Then we don't need to check cur_progress every time before modification.
> 
> Thank you for suggestion.
> 
> Placing it inside "struct collapse_control" makes the overall code
> simpler, there also coincidentally has a 4-bytes hole, as shown below:
> 
> struct collapse_control {
>         bool                       is_khugepaged;        /*     0     1 */
> 
>         /* XXX 3 bytes hole, try to pack */
> 
>         u32                        node_load[64];        /*     4   256 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>         nodemask_t                 alloc_nmask;          /*   264     8 */
> 
>         /* size: 272, cachelines: 5, members: 3 */
>         /* sum members: 265, holes: 2, sum holes: 7 */
>         /* last cacheline: 16 bytes */
> };
> 
> But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress"
> will be counted, while madvise(MADV_COLLAPSE) actually does not need to
> be counted.
> 
> David, do we want to place "cur_progress" inside the "struct collapse_control"?

Might end up looking nicer code-wise. But the reset semantics (within a
pmd) are a bit weird.

> If Yes, it would be better to rename "cur_progress" to "pmd_progress",
> as show below:
> 

"pmd_progress" is misleading. "progress_in_pmd" might be clearer.

Play with it to see if it looks better :)

-- 
Cheers,

David

