Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6D7EB3631
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF376B0088; Mon,  2 Mar 2026 14:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACA16B0089; Mon,  2 Mar 2026 14:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED8D6B008A; Mon,  2 Mar 2026 14:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD5BD6B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:43:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AAB58B1CD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:43:57 +0000 (UTC)
X-FDA: 84502148514.11.80364C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A639A4000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:43:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoZ457FS;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vw71yjYi3n4LND8CiFkyeXmVZ7ZLMpruk2kBbA6uEuQ=;
	b=iCfrpHMH7Ja5ZzuxQiRtaqkyUJzsI2u0vSrSap8vxtZqNVyKjshTu9+jZ8/qf5MDyY09ub
	3M08Vlv5fJHZP/YuOiKSUAe1Kyz+rMyIvcyZwirzkNSzELRjIM+qLqFCPHqMjHudhv8m/Z
	EOGcxdao+3s+RmEi3R40PHGWyVpPqjQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480635; a=rsa-sha256;
	cv=none;
	b=HXvK7aGyxJdqoEq/7c3wAp0fwh7OWIWgsdlof/+iDxmiqpttKJ5NkSyh9FV0qfBfJkt9xq
	X4xX+T5lj4RWZNVej9q34wxGjFwN1v2ACLNiV1cVyTKDUMg/3PjRno7bRgAMnaZwLCLFrj
	23g/MofIbNH/CyJ4d0Hk63oWcPspVT0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoZ457FS;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8B5642B15;
	Mon,  2 Mar 2026 19:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB4C19423;
	Mon,  2 Mar 2026 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772480634;
	bh=a7WlQ1idduSzrEp/bsM+zJr//DeKX2NVFrLr7fv48tA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qoZ457FSJ41XR2WrW1mZL2ObusGMYGFNfDToNiar5cUHA7/N1zhs8/UGzIPl+qBhh
	 l8DmXkoSdzLGRJfVjdMOImOuBrEZ3B4XqFyITWWKjXK+K5ULs++oAKjyzLlmPQiYeM
	 CYd3QSDaB2YaqzkkFZGN2S4wE58IrNGcyAbvu4DUw3CHPU0SOnjeff97l97f08xPgG
	 hRj84AfWUv/T7Ik25XpVxdcQf62HkSdaU/Nz5Af+MAVR0VFXRkJNXPzxfKamF4PdvL
	 z92q9kAgps7eJPPoPDRIuqSDpSu8Lnzup7kMob826aT/wCdJi3Iaa4wOrO2kEfHa9c
	 +4jUkPU71Rr6Q==
Message-ID: <917a2a5a-f499-4759-8160-c8e7d9c0ed65@kernel.org>
Date: Mon, 2 Mar 2026 20:43:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, fengwei.yin@intel.com,
 baohua@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260225081240.253057-1-tujinjiang@huawei.com>
 <db51a324-ee8e-44fe-b7bc-6ca65a3c2a3d@kernel.org>
 <2a46b99d-7f03-4e47-b0ec-da2475d49af8@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2a46b99d-7f03-4e47-b0ec-da2475d49af8@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A639A4000D
X-Stat-Signature: 9px1bw6i97czo9s687sk6qmyhujny4jc
X-HE-Tag: 1772480635-773512
X-HE-Meta: U2FsdGVkX1/X6FTtGJGuJrE1tKsbDxgFS2xLKA0stxoIvjWYjp9o1iiGe3gcCsrMXZqB/E0OCBD8ITdTgfWBwmKJmNcsu+RMMKWrcdz0yE+K+Xd3vmkoqoyd3VL4Drvt8M5ar1Q1823nOslmhSW8RsNH9oqAJPLsN0AltxHXkyDYiqL1ItNbc1NoPk9bKB+T6uK3rkao+wG7uPG/d/BbF+TsOeBmGIQLo8PfKnPnwI8/xcuD+IKRUMwZcMyVIJMKf8iJj76UTJFtRwtscDkBwoDns6lbcTyA64owJb1BvlwWI7nnlG6HZe4uL4xmTi+qHxlgsPLWZ4SRG9p3WqUGDFWU1ZPcrGIY1cNpcXAilZi/tWAGjTVVLKzGo5ZgG1Ic4pnN2VSxSE4BOCe7G4e0qYIH9OILCwI3ySVT1SaEMnfVFf1SGPaMlGsrsi1DunOniIT2f9Xsj709+9u0+laXCtfVk9xbr3zZzLVD0cdnqe3Ihs8/N3V/VJx0wDzldMtONfaQjR41mm+4CmDhCan4Tf2li4myYJWXuwo/QdSfC3fMip8S8Y6kmsuW58+3YoMdgWYxIluNKmQ3u/zxnBbpsYmw4+YSpoXC5mjjvHcyp+S8s9Efj0Zz3U10QSwE1shZ2I92R7y+HVgwQIld55C521fENCmay/D0PuuyqlI/VS2FuaK4Yn/IwRbNuLWjNCOVdDswDOjcX3V87yOuc9mO1jEe9FoX9VlEJrWv4OHvcsFjifB6EXbWrXNhgr6AgbFhV/W5h0vLjdjATbvPjP7zydcm1fKa4yVn1uewZAqSJYHuIdCvLRSaB/8JmR+xizk3oYcbJB4jVEVTgijnR75BkzS0cuyVy9Kc8QDKSyByDTOsX+/IkCGe3SB5uI0GA1wO62b53ykgl+rtWfuqwyQmGrHr02CVjyFQLwAcXuO7QN/v0fexJpooxC/ph/pjbfw5NmP8NBJbZkffeRtQ2wZ
 uTtTJPAN
 yhy0bwLb8+u6+79Awo1bi6MsYIH05eYUFEgOTbit8XvgCrmq4XSJdrWcutqM0RDQ/GJZ5pmEjRf5nI0Jr6IQmWfsS91VqKCcID4i+IewyRZlnN/UKuWLob2gZVh4/in+DLADl/TuRVzR7qff3OgLAhOUvjt1Zx0z1bgzlpG50ZOu/HiAw39h1gSegFH+AC8nn/K2xzBl7oZJIbQOPlDf16KvDeOiB3Ip/oC60i2OcNsinrn/GrpnC6SZ/T4SllG0OfoRLifP3Gcp53bSauuxNl2EgA6P9cjg45nEDqd74b9IFOXfs1shaFyiuuu5pDtNNR+kJ2VgOgg8tGbz8cMPmqUG4Dat9NoBFktNr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 03:01, Jinjiang Tu wrote:
> 
> 在 2026/2/25 17:15, David Hildenbrand (Arm) 写道:
>> On 2/25/26 09:12, Jinjiang Tu wrote:
>>> On arm64 server, we found folio that get from migration entry isn't
>>> locked
>>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>>> zap_nonpresent_ptes() races, and the root cause is lack of memory
>>> barrier
>>> in softleaf_to_folio(). The race is as follows:
>>>
>>>     CPU0                                             CPU1
>>>
>>> deferred_split_scan()                              zap_nonpresent_ptes()
>>>    lock folio
>>>    split_folio()
>>>      unmap_folio()
>>>        change ptes to migration entries
>>>      __split_folio_to_order()                        
>>> softleaf_to_folio()
>>>        set flags(including PG_locked) for tail pages    folio =
>>> pfn_folio(softleaf_to_pfn(entry))
>>>        smp_wmb()                                       
>>> VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>>        prep_compound_page() for tail pages
>>>
>> In general, relying on a "struct page" for a migration entry is shaky,
>> because it can change any time from being a large folio to being a small
>> folio.
>>
>> So we generally only check properties that would be true for either the
>> old (large) or the new (smaller) folio, like folio_test_ksm() or
>> folio_test_anon().
>>
>> It's important that these properties were written for the new folio
>> before a migration entry user might look at the page indeed.
>>
>> So it's not just about the locked state.
>>
>>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail
>>> pages
>>> are visible before the tail page becomes non-compound. smp_wmb() should
>>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>>> page before page->flags.
>>>
>>> Although the code exists for long time, this issue should only exist
>>> after
>>> mTHP splitting is supported. For THP splitting, there is only a pmd
>>> migration entry
>> When splitting, we first install a PTE table, no?
>>
>> unmap_folio() passes TTU_SPLIT_HUGE_PMD.
>>
>> and it's impossible to access migration entry that stores
> 
> Indeed, I misunderstood the code. So the fix tag is incorrect.
> 
>>> tail page pfn.
>>>
>>> To fix it, add missing smp_rmb() if the softleaf entry is migration
>>> entry
>>> in softleaf_to_folio() and softleaf_to_page().
>>>
>>> Fixes: 7dc7c5ef6463 ("mm: allow deferred splitting of arbitrary anon
>>> large folios")
>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>> ---
>>>   include/linux/leafops.h | 39 ++++++++++++++++++++++++++-------------
>>>   1 file changed, 26 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>>> index a9ff94b744f2..f823f390ba6b 100644
>>> --- a/include/linux/leafops.h
>>> +++ b/include/linux/leafops.h
>>> @@ -371,14 +371,21 @@ static inline unsigned long
>>> softleaf_to_pfn(softleaf_t entry)
>>>    */
>>>   static inline struct page *softleaf_to_page(softleaf_t entry)
>>>   {
>>> -    struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>>> +    struct page *page;
>>>         VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>>> -    /*
>>> -     * Any use of migration entries may only occur while the
>>> -     * corresponding page is locked
>>> -     */
>>> -    VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>>> +
>>> +    page = pfn_to_page(softleaf_to_pfn(entry));
>>> +    if (softleaf_is_migration(entry)) {
>>> +        /* See __split_folio_to_order() comment */
>>> +        smp_rmb();
>>> +
>>> +        /*
>>> +         * Any use of migration entries may only occur while the
>>> +         * corresponding page is locked
>>> +         */
>>> +        VM_WARN_ON_ONCE(!PageLocked(page));
>>> +    }
>> Conceptually, wouldn't the smb_rmb() have to happen *after* the
>> page_folio(), like we have in softleaf_to_folio()?
> 
> the comments of page_folio() says:
>  * Context: No reference, nor lock is required on @page.  If the caller
>  * does not hold a reference, this call may race with a folio split, so
>  * it should re-check the folio still contains this page after gaining
>  * a reference on the folio.
>  * Return: The folio which contains this page.
> 
> The old large folio is locked and freezed during splitting, page_folio()
> couldn't be called with reference held, so the result is unstable, the
> caller should recheck after gaining a reference, at that time splitting
> finishes, and folio_get() contains memory barrier already, ensuring the
> folio flags is seen after compound_head.

Let me elaborate what I mean:

__split_folio_to_order() does:

	/* setup flags and mappings etc. for the new folio */
	new_folio->flags.f = ...
	new_folio->mapping = ...

	smp_wmb();

	/* Now re-route page_folio(). */
	clear_compound_head(new_head);
	if (new_order) {
		prep_compound_page(new_head, new_order);
		folio_set_large_rmappable(new_folio);
	}


So I would expect the opposite direction to do:

	/* Lookup either the old or the new folio. */
	page = pfn_to_page(softleaf_to_pfn(entry));
	folio = page_folio(page); /* looks up compound head etc. */

	/* Make sure we'll see proper flags, mappings of new folio. */
	smp_rmb();

	/* Continue using new folio */
	folio_test_locked() ... folio_test_anon() ...


Instead of

	page = pfn_to_page(softleaf_to_pfn(entry));
	
	smp_rmb();
	
	PageLocked(page) /* internally does page_folio() */
	folio = page_folio(page);
	

Maybe that is fine, but it sure is harder to argue about correctness?

-- 
Cheers,

David

