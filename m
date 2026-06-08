Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A96CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384E06B0005; Mon,  8 Jun 2026 11:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335906B0088; Mon,  8 Jun 2026 11:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2243D6B008A; Mon,  8 Jun 2026 11:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6EC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:25:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5DBA140174
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:25:45 +0000 (UTC)
X-FDA: 84857120250.17.16AB6AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E821B20003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:25:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9Jd5nfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780932343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmENGgQRwxMmo42f5vCP8Aa9knmtXvGq5kfEhKqCwHg=;
	b=EfOoEYKOhnpXWN4x9Ea2nnrU4RvwArXGScKjCv3kS6Outxyz51aAr4onHHJfIWap1H6kJj
	lmCbkJBp3N6XdiqA/T2eAd0CDvL2X50xHOMA/JO3W08/aoFC7GoxHUZu41E2NQcHJFJUIV
	VKbiAoqU1ZV0WdxIDbHwhMbv/cfXvJ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9Jd5nfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780932343;
	b=vMieEJ6Q1oftU1YpIcDGL64wIyjzBqHZOnsKkLZbC3JXPZco/MKIuJDzBcafT9C2BJ2jun
	Z4NP8TM3x4qtF0w/a681GqPw22jqNEBuhSAz6IVKKcfJW+kJINt9rgWO3l4hZNjpk/yz4U
	/oRwmcfKrq45X5RpJCwCStMoftkw17Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55D27601D8;
	Mon,  8 Jun 2026 15:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6111F00893;
	Mon,  8 Jun 2026 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780932343;
	bh=DmENGgQRwxMmo42f5vCP8Aa9knmtXvGq5kfEhKqCwHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I9Jd5nfZWYnAAIWkm5HtQ41vtn2X45+QnXvjTYfZ712ObRMdSmxGFfCesA+4JOlm1
	 cC0u7ZPHAxYlA5LuSH9cuJmMpOxJxp1Wx1+tW3CxsTnzw8ntiXntwwgVtroS152JtP
	 knfcQ9x/RL97zasSs7R+JZxmE0it9X/eiJp8LW1/EqJl7IBvM/uVHyB5uj7ZHUpeNK
	 AnWw9ANRmaBo2M/YHJc5hoEZRA48jwd3tY98B0YruB01EhZddZQK2KhAAzcHLvEPMu
	 BKlkMRkq6pKa+bUSGtbYLQduocH5Bq8y8pbCvH9jkLMUfjn2rRPXDww2TZE80P+q3P
	 RanO510TC6Lsg==
Message-ID: <27f6f5d6-e81b-4e0a-af39-b175187299e2@kernel.org>
Date: Mon, 8 Jun 2026 17:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-10-shivankg@amd.com>
 <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
 <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: umh9iigsca1kkx6bk5zft54a6t4ghgmf
X-Rspamd-Queue-Id: E821B20003
X-HE-Tag: 1780932343-549464
X-HE-Meta: U2FsdGVkX1/Bu9Gn9/cPmVTeiYILNb0RvD74VA9ylRCkDpaqPV17l8CZaEA9izbEqJYcl+ueOksR9kMVIjwbV51oKlbPRFK+tMo5j6JFR1cW08dOroJhzKt+wUXgGTj+koNhl+jSg/04DdZ0syAcnYz3T9mQ69uUkn08ZakR/SrAZxtS9+9+y9bw0cqlWIUYFAHT8sBDlhe2GdSLAW8/uMK7/xJesmw/+awzr4rew/c90g8ptEIqSeqdLUfw9B9OKuJzn8nw5aubR6yh2Hj5oarRng18vUl5oeaRoe/xs809Gkb6ALMjHOC1pTrV3aE08PLmT31s/csklycVdKLNwL+VQtUPiHl5VQV75i6WWutCTWsHUunYTPT05n78dgd/hYSrZnCNwSAf1udK9V9jn5+CQ3umwKL+xie/zdjg58Arljvi5DmwItx77rsY0KcJKIdH1GRNHQ5hFgjjQ0twV4p9sWwz3/CfkC+zYF8HicyDJ4g4t3A/YEamblcmwJdVKAethXeSYUsTu/eFEVRNfmuwqjjvKOMqrLFAsXR6ZHMRajMJn1SQ6lCPcQHitFMxUgmYHogjZG/lTd+ivplGbG6GqmNf696wR8ShAPs7J9/K4Dp8v1Stjl6EJXhBv9xx2vRUkhH4i7Q+DSWvwsFH8S5k/fibHsE/1s2aWgWYvox3aKkpvOixI6nLO90BKb7LjitECmkA122iLF93tJSkB/WWglNcV3N4B40aqPOSj2dley9sdoEVkyOs1Wtyt10adV+OGS2/jisE0IT8Q8YVi69FPF/vGNXbMtVd0sRLLZNCP7A+dJqey5akY9PCiOtPojNJ1sg/ogyAp5Krd5XF8jCb5AiZLQWLmjZgRELG5YWc/oeWEXscczpUV2EbQ9nrhmwsk8SrZ/B5SIrgX81kyYbTzhCGzBVbbWMkLglL4JsvrD2OLUX4JK/PaOl1LZph029Zfq6/5Oa46K1su3v
 RkSzOOmu
 2AH8iEi0T3yV+RKrCafiTT4Mp8r9dIyOcEtd8FCik+jm0LZbeH+lm17o84bAwybkY+YOTnhY3ri/hr0VmR4lXmqeduvs4fTGq5um5aIhz7g4WC/MFqiYs62Z2JJJavQfm2LdNfUNrvhX1oceKlWLE6NsbA2aO7AqqhMnuA504T9oOq2z7oGVDPb1uyLjru6QcNcfP2N+6ldso7LK+ESVudfrJSiVrVDA8TT+IY5kkYfA4aCkmuz+bFXOiUFsDntSX58o2cLT5bcuAcUB+5BV9NmpY2tFHf7y94Z9bc7SWl3HzD0biZbP/ivj+cOaR9X1DaKuaopa2AE2VhhHCgzumAdjDP5Y28v7DotIRqthGA74Mvg5w1esUh873oodVSMYxIVR4VUtJCDaqvXUeCeKyYkrt2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 17:06, Garg, Shivank wrote:
> 
> 
> On 5/11/2026 9:10 PM, David Hildenbrand (Arm) wrote:
>> On 4/28/26 17:50, Shivank Garg wrote:
>>> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
>>> and copies folio content via folio_mc_copy(). folios_cnt parameter is
>>> unused here, but is part of the offload_copy callback signature used by
>>> later patches in the series.
>>>
>>> Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
>>> standard (unmap_single/dst_single) lists, gated by the
>>> migrate_offload_enabled which is off by default. So, when no offload
>>> driver is active, the branch is never taken and everything goes
>>> through the standard path.
>>>
>>> After TLB flush, batch copy the eligible folios via folios_mc_copy()
>>> and pass already_copied=true into migrate_folios_move() so
>>> __migrate_folio() skips the per-folio copy.
>>>
>>> On batch copy failure, already_copied flag stays false and each folio
>>> fall back to individual copy.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>  include/linux/mm.h |  2 ++
>>>  mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++-----------
>>>  mm/util.c          | 30 +++++++++++++++++++++++
>>>  3 files changed, 79 insertions(+), 14 deletions(-)
>>
>> [...]
>>
>>>  
>>> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>>> +
>>>  static const struct movable_operations *offline_movable_ops;
>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>  
>>> @@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>>>  	return nr_failed;
>>>  }
>>>  
>>> +/* movable_ops folios have their own migrate path */
>>> +static bool folio_supports_batch_copy(struct folio *folio)
>>> +{
>>> +	return likely(!page_has_movable_ops(&folio->page));
>>> +}
>>
>> As these things are not actually folios (and callers will have to be taught to
>> distinguish them way, way earlier), I guess you should make this
>>
>> /* movable_ops pages have a separate migration path */
>> static bool page_supports_batch_copy(struct page *page)
>> ...
> 
> I'll change this.
> 
>>
>>> +
>>>  static void migrate_folios_move(struct list_head *src_folios,
>>>  		struct list_head *dst_folios,
>>>  		free_folio_t put_new_folio, unsigned long private,
>>> @@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>>  		/*
>>>  		 * The rules are:
>>>  		 *	0: folio will be freed
>>> -		 *	-EAGAIN: stay on the unmap_folios list
>>> +		 *	-EAGAIN: stay on the src_folios list
>>>  		 *	Other errno: put on ret_folios list
>>>  		 */
>>>  		switch (rc) {
>>
>>
>> [...]
>>
>>> --- a/mm/util.c
>>> +++ b/mm/util.c
>>> @@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
>>>  }
>>>  EXPORT_SYMBOL(folio_mc_copy);
>>>  
>>> +/**
>>> + * folios_mc_copy - Copy the contents of list of folios.
>>> + * @dst_list: destination folio list.
>>> + * @src_list: source folio list.
>>> + * @folios_cnt: unused here, present for callback signature compatibility.
>>> + *
>>> + * Walks list of src and dst folios in lockstep and copies folio
>>> + * content via folio_mc_copy(). The caller must ensure both lists have
>>> + * the same number of entries. This may sleep.
>>
>> This *function*
>>
> 
> Will add function.
> 
>>> + *
>>> + * Return: 0 on success, negative errno on failure.
>>> + */
>>> +int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
>>> +		unsigned int __always_unused folios_cnt)
>>> +{
>>> +	struct folio *src, *dst;
>>> +	int ret;
>>> +
>>> +	dst = list_first_entry(dst_list, struct folio, lru);
>>> +	list_for_each_entry(src, src_list, lru) {
>>> +		ret = folio_mc_copy(dst, src);
>>> +		if (ret)
>>> +			return ret;
>>> +		dst = list_next_entry(dst, lru);
>>> +	}
>>
>> Wouldn't it be cleaner to remember "already copied" immediately after we ...
>> performed the copy? (succeeded with folio_mc_copy)
> 
> IIUC, you mean something like:
> 	list_for_each_entry(src, src_list, lru) {
> 		ret = folio_mc_copy(dst, src);
> 		if (ret)
> 			return ret;
> 		dst->migrate_info |= FOLIO_CONTENT_COPIED;
> 		dst = list_next_entry(dst, lru);
> 	}
> 
> This will be cleaner. However, it will make the folios_mc_copy() specific for
> page migration and can't be reused by other potential callers.
> And offload driver (like DCBM) must set the already copied marker
> themselves for successful copies.

Right, maybe some helper for that would be possible?

> This will have an upside that on partial-success (even a single failed copy),
> it will no longer forces re-copy of the whole batch.
> If that's the intention, I'll move this to migrate.c itself.

True. I'd probably have to take a look at the end result to see if it looks
better that way.

-- 
Cheers,

David

