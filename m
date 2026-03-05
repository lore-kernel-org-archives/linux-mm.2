Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDB8EEF312
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13A56B0089; Thu,  5 Mar 2026 02:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDBD6B008A; Thu,  5 Mar 2026 02:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA766B008C; Thu,  5 Mar 2026 02:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECD56B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:47:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27193140822
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:47:49 +0000 (UTC)
X-FDA: 84511230258.13.3562EA1
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5EF82A0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:47:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nagqFMze;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772696867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zIs5B4IfIJkIrNAqEi1uOTqaoKwddZrm56ShDHbB2U=;
	b=DYnaTwk1AHoKZn69iKwBoom4p2nA7MoHHEASxn3PV9d4XdrWYQJvpY1rzSqj4M3iH7AHuy
	n/mTOremoSxfLd/gjIrcehY5RQ8+2dusw+5+zvJbJvYyltxCgwN9DlkeONV4gA/Nyd4yt9
	JmHKbyk16KNd2fYfSvxpjhZKlzNqXHM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nagqFMze;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772696867; a=rsa-sha256;
	cv=none;
	b=NVsp+jbRUqO1BI1IDWNZn46Ld+S/kkRKqlsni/WUokfQbwCxNlHeetJS35FK9huk57upYQ
	zrVVvgk9gBzWY+lKQc5Hja9hIDY8yFL6JVZSbPdEK1niwck8z1KIN+UY3VuaxHXEuLcE94
	4Nk+7agj0FJkd8VtjS0cieruVd5zKLE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4zIs5B4IfIJkIrNAqEi1uOTqaoKwddZrm56ShDHbB2U=;
	b=nagqFMzeoY61aSNrKECedwVcACRxQ7UjHd3MZ5oLoA1mO1RmeP0h0mSYpbPhH+Buf5U240qnZ
	WUQ18nPJFgNkMfcP4bwvJTnBbI7+cjNiDcZ+1DC3msaFQ24Fbsy3PzfENX8EQAOyGEwhRTAeAtb
	GfagO01cpRXiKDffZVTctSw=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fRM2Y3nP8zKm7C;
	Thu,  5 Mar 2026 15:42:45 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C9099402AB;
	Thu,  5 Mar 2026 15:47:37 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Mar
 2026 15:47:36 +0800
Message-ID: <cd4995fc-6eb9-49b9-8474-000704ee0cda@huawei.com>
Date: Thu, 5 Mar 2026 15:47:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<fengwei.yin@intel.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260225081240.253057-1-tujinjiang@huawei.com>
 <db51a324-ee8e-44fe-b7bc-6ca65a3c2a3d@kernel.org>
 <2a46b99d-7f03-4e47-b0ec-da2475d49af8@huawei.com>
 <917a2a5a-f499-4759-8160-c8e7d9c0ed65@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <917a2a5a-f499-4759-8160-c8e7d9c0ed65@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EF82A0011
X-Stat-Signature: rxtpspopezyru1k8snwkdb68phzcp6jg
X-Rspam-User: 
X-HE-Tag: 1772696864-592409
X-HE-Meta: U2FsdGVkX1+kRg+5FQIM3LCo3X/NneVfqjkd42OvqhMgFn9JPjCDthvskCY/1SU+k5FzTKtoE8Jq6GMYX++snLzefwBSbmCxBeEU03YDtt6ISsm8ldkyTU/BgnE6BQ8fXLqRPdhqWDe4HMjFFOxGIUiPxPQkl+eL48Ov0rhd29CaRpwuvbAtMW/cQ2uH6fIN4tRD1H1g9JA3391h8UU1cF9HjbIJcUbpxfxoFN4cpC+CDyCj8iK27PhPadxGmjhOO2fm1gZtmNK61pXFOaIsjXwsCrWfArQWzQDqVY3cUdnwm8g7Eync3xoJagoFQ9JPL6NkuVB0bsg0kA5GCJezzzv2pJDfFeGvwqsVkbWfNSEFs2OtG29ZgI5wup74nlQSjZ1E+kBn1wD7a/aJnFIYZO0dj8ltEOoWgaGHk6249oNQkeXvx95P0AVGudAHPmDNbmCPGvy5NTWVcNtIntHG7SAV8sWwRpH6a6Bo836vKanUXHGZiW4LmK26gVCXw9mniI0TbURsbbhQUxXf8KHxNNfTvpbrIuqimy9ijvKmf+yU6qDHsdKPZVU04xnP3uJ5W6n+5X9Y5EnhmciYzn9FIThdA50xrh+fU3OMgsJej0XjBOVegxYI63mgJddm2qRXgBkci4CLxYVacVwlYDUdLrTA3ncKDsdAJRZuRJhQqwzg5A/plWw5ZxH9GDKIaHUcCXjRN6PC+XAxKY1X35wg6bRqkSoscr0wviOYMV2OvpNYsTt97mnfg+FbSLYrzih+MQrMn2G7OIu6Op0zASG8kCBFGACT6yfOAsEd7/jSWAuKw6dRL7M7ZAXxz93zoICsVOiyp9QBS2I5GM2ZLfqkQd5MUJ3lNmHpjoAq7HqO1wnTdu8DzWZIiBDokwYH/0OYvKpzv/pTbVDC1ff8mC7wDydSaP5/W0/GsDuPoUv03WlzkLwcWgUEnYy1LOUKm3pR0Z8kyUJQ/wC0Uu8pE+Z
 rB2vzuHU
 SS9lUUnHudltoKeMjuoPbs9/MLBJU7kXiC6juYOV4LaDda5x92cSrgI/4BbQ2l4Zc0EyDZmmVgb6mBgSlvdFSAz79XzSa0ZpIi/jgKgna9kDmAO3Nhy6JogbJKL3r/CQT/v3+IawmKZRqYPdTfJHs9kkasMGCnc5HACjn/IkGSpV0s9tjKGfRSukPKNh4wm4Xb/Aeyw+JDjPxvACeliy/42qyqHaKuxZBo3Pkk7smHUSv9D1aQeJiUeqTlXZZ/cP3266znYETKHWN5c6x4gp4Okc8B7OmMBfJG8AKL3g8Zh5AkXWdX6eb5pTUYTzIYnFYNU0k0dCQtnpyCvwyVCfgXClMY5fnmZiZdxf2ACdqj8CdQnjYsC+sA3wzCGknr2X/pMv8s992zMV/8AG9HZ4UtWjUGVE43aqfqyO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/3 3:43, David Hildenbrand (Arm) 写道:
> On 2/26/26 03:01, Jinjiang Tu wrote:
>> 在 2026/2/25 17:15, David Hildenbrand (Arm) 写道:
>>> On 2/25/26 09:12, Jinjiang Tu wrote:
>>>> On arm64 server, we found folio that get from migration entry isn't
>>>> locked
>>>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>>>> zap_nonpresent_ptes() races, and the root cause is lack of memory
>>>> barrier
>>>> in softleaf_to_folio(). The race is as follows:
>>>>
>>>>      CPU0                                             CPU1
>>>>
>>>> deferred_split_scan()                              zap_nonpresent_ptes()
>>>>     lock folio
>>>>     split_folio()
>>>>       unmap_folio()
>>>>         change ptes to migration entries
>>>>       __split_folio_to_order()
>>>> softleaf_to_folio()
>>>>         set flags(including PG_locked) for tail pages    folio =
>>>> pfn_folio(softleaf_to_pfn(entry))
>>>>         smp_wmb()
>>>> VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>>>         prep_compound_page() for tail pages
>>>>
>>> In general, relying on a "struct page" for a migration entry is shaky,
>>> because it can change any time from being a large folio to being a small
>>> folio.
>>>
>>> So we generally only check properties that would be true for either the
>>> old (large) or the new (smaller) folio, like folio_test_ksm() or
>>> folio_test_anon().
>>>
>>> It's important that these properties were written for the new folio
>>> before a migration entry user might look at the page indeed.
>>>
>>> So it's not just about the locked state.
>>>
>>>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail
>>>> pages
>>>> are visible before the tail page becomes non-compound. smp_wmb() should
>>>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>>>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>>>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>>>> page before page->flags.
>>>>
>>>> Although the code exists for long time, this issue should only exist
>>>> after
>>>> mTHP splitting is supported. For THP splitting, there is only a pmd
>>>> migration entry
>>> When splitting, we first install a PTE table, no?
>>>
>>> unmap_folio() passes TTU_SPLIT_HUGE_PMD.
>>>
>>> and it's impossible to access migration entry that stores
>> Indeed, I misunderstood the code. So the fix tag is incorrect.
>>
>>>> tail page pfn.
>>>>
>>>> To fix it, add missing smp_rmb() if the softleaf entry is migration
>>>> entry
>>>> in softleaf_to_folio() and softleaf_to_page().
>>>>
>>>> Fixes: 7dc7c5ef6463 ("mm: allow deferred splitting of arbitrary anon
>>>> large folios")
>>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>>> ---
>>>>    include/linux/leafops.h | 39 ++++++++++++++++++++++++++-------------
>>>>    1 file changed, 26 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>>>> index a9ff94b744f2..f823f390ba6b 100644
>>>> --- a/include/linux/leafops.h
>>>> +++ b/include/linux/leafops.h
>>>> @@ -371,14 +371,21 @@ static inline unsigned long
>>>> softleaf_to_pfn(softleaf_t entry)
>>>>     */
>>>>    static inline struct page *softleaf_to_page(softleaf_t entry)
>>>>    {
>>>> -    struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>>>> +    struct page *page;
>>>>          VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>>>> -    /*
>>>> -     * Any use of migration entries may only occur while the
>>>> -     * corresponding page is locked
>>>> -     */
>>>> -    VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>>>> +
>>>> +    page = pfn_to_page(softleaf_to_pfn(entry));
>>>> +    if (softleaf_is_migration(entry)) {
>>>> +        /* See __split_folio_to_order() comment */
>>>> +        smp_rmb();
>>>> +
>>>> +        /*
>>>> +         * Any use of migration entries may only occur while the
>>>> +         * corresponding page is locked
>>>> +         */
>>>> +        VM_WARN_ON_ONCE(!PageLocked(page));
>>>> +    }
>>> Conceptually, wouldn't the smb_rmb() have to happen *after* the
>>> page_folio(), like we have in softleaf_to_folio()?
>> the comments of page_folio() says:
>>   * Context: No reference, nor lock is required on @page.  If the caller
>>   * does not hold a reference, this call may race with a folio split, so
>>   * it should re-check the folio still contains this page after gaining
>>   * a reference on the folio.
>>   * Return: The folio which contains this page.
>>
>> The old large folio is locked and freezed during splitting, page_folio()
>> couldn't be called with reference held, so the result is unstable, the
>> caller should recheck after gaining a reference, at that time splitting
>> finishes, and folio_get() contains memory barrier already, ensuring the
>> folio flags is seen after compound_head.
> Let me elaborate what I mean:
>
> __split_folio_to_order() does:
>
> 	/* setup flags and mappings etc. for the new folio */
> 	new_folio->flags.f = ...
> 	new_folio->mapping = ...
>
> 	smp_wmb();
>
> 	/* Now re-route page_folio(). */
> 	clear_compound_head(new_head);
> 	if (new_order) {
> 		prep_compound_page(new_head, new_order);
> 		folio_set_large_rmappable(new_folio);
> 	}
>
>
> So I would expect the opposite direction to do:
>
> 	/* Lookup either the old or the new folio. */
> 	page = pfn_to_page(softleaf_to_pfn(entry));
> 	folio = page_folio(page); /* looks up compound head etc. */
>
> 	/* Make sure we'll see proper flags, mappings of new folio. */
> 	smp_rmb();
>
> 	/* Continue using new folio */
> 	folio_test_locked() ... folio_test_anon() ...

Yes, it's clearer, and consistent with softleaf_to_folio(). Thanks for explanation.

Since softleaf_to_page() and softleaf_to_folio() have duplicated code, maybe we
could extract a helper:


diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a9ff94b744f2..34d280af98a3 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -363,6 +363,22 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
         return swp_offset(entry) & SWP_PFN_MASK;
  }

+static inline void softleaf_migration_entry_check(softleaf_t entry,
+                       struct folio *folio)
+{
+       if (!softleaf_is_migration(entry))
+               return;
+
+       /* See __split_folio_to_order() comment */
+       smp_rmb();
+
+       /*
+        * Any use of migration entries may only occur while the
+        * corresponding page is locked
+        */
+       VM_WARN_ON_ONCE(!folio_test_locked(folio));
+}
+ /**
   * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
   * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
@@ -374,11 +390,7 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
         struct page *page = pfn_to_page(softleaf_to_pfn(entry));
  
         VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-       /*
-        * Any use of migration entries may only occur while the
-        * corresponding page is locked
-        */
-       VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+       softleaf_migration_entry_check(entry, page_folio(page));
  
         return page;
  }
@@ -394,12 +406,7 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
         struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
  
         VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-       /*
-        * Any use of migration entries may only occur while the
-        * corresponding folio is locked.
-        */
-       VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-                       !folio_test_locked(folio));
+       softleaf_migration_entry_check(entry, folio);
  
         return folio;
  }

>
>
> Instead of
>
> 	page = pfn_to_page(softleaf_to_pfn(entry));
> 	
> 	smp_rmb();
> 	
> 	PageLocked(page) /* internally does page_folio() */
> 	folio = page_folio(page);
> 	
>
> Maybe that is fine, but it sure is harder to argue about correctness?
>

