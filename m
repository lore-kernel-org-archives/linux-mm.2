Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D7CC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A3C6B00A2; Mon,  7 Sep 2026 10:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72066B00A3; Mon,  7 Sep 2026 10:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9880F6B00A4; Mon,  7 Sep 2026 10:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6659E6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:30:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08914A29A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:30:39 +0000 (UTC)
X-FDA: 85187202198.19.63DA9FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C22140003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:30:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DL41gg3h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788791437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BN/and5SrvPGCMH6UXxYUAtRBxJQHSA6KDzQU2113lg=;
	b=VPvCqdCG/yWPewvWlaXyL6J0kSQv5Ol0idqJas5VkSvgtjn+wF0Ot9K8+pfny3IrkNsnSj
	SycVHzo2dkGIW+stxKrqhJW3g6svF3TZcgTvSKYntctuIhEESZNQE75NhNYlkHSDgvA6bI
	+BXPJOUPCR58wh+3UzBwcwhRpSqCVBk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DL41gg3h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788791437;
	b=ONrfpZ1sLo5DAs2n0coVYAjVMj+/6O+it2+obdhtB0khc3ztNtlpkVgKiHAR7LiYl+u797
	4hIDRWEDIVg7VmpDp/QzmvrjkwQ+k2utxZZooAMwgNit6VKrpMpbApxwLvxGmceSzQAuGj
	PfH9YvqCZ8y7mQ3TJ/e7BRBzYeFOKjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2BED60AB5;
	Mon,  7 Sep 2026 14:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7579D1F00A3A;
	Mon,  7 Sep 2026 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791436;
	bh=BN/and5SrvPGCMH6UXxYUAtRBxJQHSA6KDzQU2113lg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DL41gg3hXNC/cq90W8a3nkPQ5S8npsYyl3Elz+j7FnAf1iArK02ZWOKrMEedVMUhz
	 xZXAWWeuHXIW510rXC3MDxB3E+PnDuhUZsS7vTUD/XxT9CLcWUFUYiCX0cHFjzjj76
	 CmTIf2duTl5aOoydeXP1M/+MdlWv1YtQ8yoMggTbIWccFI4G4EtyncbGv9yafZBBP/
	 V918pMvHzgudeorImk7RjdvHeWnUDiZDGCc5EHqWap4wKAgpFH5n93uftOzY2srSAl
	 cV3fJGpi0+YrDMO+5zb559pLfa0b5zLb52tgIOfWh39zP9sSr5JcJ4KjMAa4FltC9Z
	 gGuxTfHBa8jMA==
Message-ID: <d9502e78-f98f-4958-9770-8db808718103@kernel.org>
Date: Mon, 7 Sep 2026 16:30:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/huge_memory: dequeue the deferred split after
 the split freeze
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, ljs@kernel.org, hannes@cmpxchg.org,
 usama.arif@linux.dev, lance.yang@linux.dev, ziy@nvidia.com,
 kasong@tencent.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, liam@infradead.org, nico.pache@linux.dev,
 dev.jain@arm.com, ryan.roberts@arm.com, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-3-kirill@shutemov.name>
 <f44181bb-ff82-4537-b2eb-fcbde304d7eb@kernel.org>
 <ap7Fs9DCP3PVOxwY@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ap7Fs9DCP3PVOxwY@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9woh9magkqds6dufkijj1kjnxuimqryi
X-Rspamd-Queue-Id: 4C22140003
X-HE-Tag: 1788791437-610
X-HE-Meta: U2FsdGVkX1/Vpo2I5MgTUszD92hJ8YWZAk0tVbSkdnn4yqfSyrL2JJ/MkmPhEFUHwbmYuXQHiBypf0ZIfuedCsMhIzebV7Op080w4gXE+u0d6+dl21i6ORm0SREKzZLfXEIIHJ6oqLmTkdqfRbtTpHyMVQ7KjXGFWz4R6QXuXWMBoU2lXqUkD+cj2heWBmEk+OyhR3WG49se9Kp1wOvR20m8JOa8sKpWuf/5rsT4RRHjwQIvVw34UsCwuStb47dxeCi33fsFO1q9eob0dAJndUrgG+X6DKIlV0gW1b1xKIPuTHCXQc0VUazIY9CUY2e/XC2h/7A7rn+hrXrgNQRO3Q7mY1omFyC35CGVqEwJSbR1uqqSreTOsvpgz6tF8jXKoKrQ3a63iVIGDrqkqsnhO1CuEcjmilrwRmCHjAKGUMsQoSIJbU9AfydAsdDxaenBIokA8vw5MmxlwP0px/QNHwSWWbbd3ZPsuBB1aFIpt9Jqo5Ow9R3Pra3viLmDjSEYZnHmPshcxH9BqfSLKtpQVEda4rPdm0QIRrlxTFZbOVQVwKmmKGCKWtAZdvxFX8mABTcb6qlHBndSgf1q4bzmmTnTykdRgRwMyaHloZesgJHwBjQvEWQitVS8ZnA3eYmTTNCAIGyUXRtmhBeBFezq3r5vVHs6tXO6m0UH93ckbLtsY1B/ftLhhYGRfgVSalG9bKrJQXjH/EtSMMxDustMj1qYN8frs0efBX6UYkxKbe+y90MakLW0QrvqV40NdFYe3XkBrQknGQWU9MkWgXLFvyL/zVUl+VhZkZ3cpsww66KrJeoysRHlX9o67tgP4zl0832U/Shs5iy/87eLd4UfWddFrSDgML+jX8iHUR5KdoQy78XhaVsZwzg71lcNpCL1Oub33ce7HnEWZ7pcYz9AKgCQmSOCIYsHQqpcPn6D115C47lJsTswIt0F3OqOcpdedRzK9sdtKRb3HQEgVHD
 s2+bUTZ8
 o/g2r5vzPj7A2JCzqchP89PuQbghuCJfcOm5r+jCUp6R/q+CFngt51DrIcIhk507jXyycHqlLo44iV/I8BFdQi212TeLDekhr3KeQHqRhx5aculAh2zs5jcXOUk8I/xwcazvZ72dz5ZBLHPWrPfqPBPRfl8imF5uZ+QYnFhfCQgXWyl9XBCOigvrxjdH41COioJOCkqbtSeUIkY0WjGQWLqBFsa6wXIYmLoHtmKmDW97QJKW6PNXK2X3oCdMOcLFoooCnuGGKbChB32dQIBkhpBiPS4naLBzKNDfq1YbaysANs2mBgDDFBAgL5DEdLDt5lzdqDwxOvg+8QAZ2t9I1xulHpfzhZU0iaVMB1x0zOchxL5y8FpPi1xavX02YChdhLwzKB1SU0Q6xVMtLM7UZpRbgQRD8UC8DH6QK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 16:12, Kiryl Shutsemau wrote:
> On Mon, Sep 07, 2026 at 03:55:53PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/31/26 11:15, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
>>> across the freeze. It is only there to stop deferred_split_scan() from
>>> touching the folio under split.
>>>
>>> With deferred_split_isolate() fixed, the workaround can be dropped.
>>>
>>> Unqueue the folio after folio_ref_freeze(), the way
>>> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
>>> zero refcount and a memcg still set, and both hold there.
>>>
>>> If the split is called from deferred_split_scan(), the unqueue is a
>>> no-op -- the folio is already removed from the list. But
>>> PG_partially_mapped is still set, so it has to be cleared here or
>>> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
>>>
>>> Assisted-by: Claude-Code:claude-opus-5
>>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  mm/huge_memory.c | 44 +++++++++++++-------------------------------
>>>  1 file changed, 13 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 6281ed993243..c84e8cbc986d 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3931,41 +3931,27 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>>  	struct folio *end_folio = folio_next(folio);
>>>  	struct folio *new_folio, *next;
>>>  	int old_order = folio_order(folio);
>>> -	struct list_lru_one *lru;
>>> -	bool dequeue_deferred;
>>>  	int ret = 0;
>>>  
>>>  	VM_WARN_ON_ONCE(!mapping && end);
>>> -	/*
>>> -	 * If this folio can be on the deferred split queue, lock out
>>> -	 * the shrinker before freezing the ref. If the shrinker sees
>>> -	 * a 0-ref folio, it assumes it beat folio_put() to the list
>>> -	 * lock and must clean up the LRU state - the same dequeue we
>>> -	 * will do below as part of the split.
>>> -	 */
>>> -	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
>>> -	if (dequeue_deferred) {
>>> -		struct mem_cgroup *memcg;
>>>  
>>> -		rcu_read_lock();
>>> -		memcg = folio_memcg(folio);
>>> -		lru = list_lru_lock(&deferred_split_lru,
>>> -				    folio_nid(folio), &memcg);
>>> -	}
>>
>> Nice cleanup.
>>
>>>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>>>  		struct swap_cluster_info *ci = NULL;
>>>  		struct lruvec *lruvec;
>>>  
>>> -		if (dequeue_deferred) {
>>> -			__list_lru_del(&deferred_split_lru, lru,
>>> -				       &folio->_deferred_list, folio_nid(folio));
>>> -			if (folio_test_partially_mapped(folio)) {
>>> -				folio_clear_partially_mapped(folio);
>>> -				mod_mthp_stat(old_order,
>>> -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>> -			}
>>> -			list_lru_unlock(lru);
>>> -			rcu_read_unlock();
>>> +		/* Take off the deferred split queue while frozen and memcg set */
>>> +		folio_unqueue_deferred_split(folio);
>>> +
>>> +		/*
>>> +		 * deferred_split_scan() takes the folio off the queue before it
>>> +		 * splits it, so the unqueue above finds an empty list and
>>> +		 * leaves PG_partially_mapped set.
>>> +		 * Clear it here: the flag does not survive the split.
>>> +		 */
>>> +		if (folio_test_partially_mapped(folio)) {
>>> +			folio_clear_partially_mapped(folio);
>>> +			mod_mthp_stat(old_order,
>>> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>>  		}
>>
>> In general,
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> But I do wonder whether this sequence (that also
>> __folio_unqueue_deferred_split()) performs would deserve a small local helper in
>> mm/huge_memory.c
>>
>> Could be done as a separate cleanup.
> 
> Just to be sure, do you want a helper like this:

Something like that. I'd probably call it folio_reset_partially_mapped()

-- 
Cheers,

David

