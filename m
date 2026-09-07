Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8310C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81D26B009B; Mon,  7 Sep 2026 09:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A592C6B009D; Mon,  7 Sep 2026 09:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921186B009E; Mon,  7 Sep 2026 09:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6862E6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:56:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C802140188
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:56:02 +0000 (UTC)
X-FDA: 85187114964.27.BFD617C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4538F40004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:56:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gI8ftB0Y;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789360;
	b=2ogvQ4TRfhFddrHZZ2aplI5TfQdXdVLXd/yWAVtM1t9w54mmVyOAix0Jm6/DUBeU5M3Emy
	sEZ799xYWE9oiEzrcxGfEdCWsnbcsBJ23LCv6Ci58ukVD9DL6fpW60NtVJr4jukG6P4DwW
	iVx+lC60K1rEtBIsTV8XjwUU3O+3pJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZB4SZnhJn7B8NJkES4V3S9ML1xc3yKh26KW0DCPkAI=;
	b=JmExVVc/Oq+cvi/tcuYqS8uY39A741p16A6C2wW5lOtWwHk1ghjxKuSEAiZvtIeTYKkoeN
	n0Jm7raXeotmAFRPvzJposaHE0MMsIFnpasrfmw284iEbGvNKkxijwY+k1rjnrb3EaW0h4
	ONO9HZ6Rbll3SWyO+ocToIgUr0EpbDo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gI8ftB0Y;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B82FD60D86;
	Mon,  7 Sep 2026 13:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5841F00A3A;
	Mon,  7 Sep 2026 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789359;
	bh=EZB4SZnhJn7B8NJkES4V3S9ML1xc3yKh26KW0DCPkAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gI8ftB0YMB5vFgdTJ/VqSy11B4Hgym+5tR+cWMB1A5tmkqCbZ/XV45UeEkAae5CQp
	 ThqtR5Ty7VZZyVLE+VWPHUJ06pm2305BGgyL5gsuJo79cG+78PL8Nn2/Kq0BFXEbtx
	 ZCnozSOxaLCXytDG5G4qd0K+rIk7GVTlL/GtgC8NlNJOnijP94SSajKkEqwDWvBzxT
	 DyB8P/UTClwDwgCX8ReGWUGXZQCKn3zJ7wvxVf4QulqIGQDxC3I4+DnWtAeUmZQpOB
	 qVTZNLTV8kDg8HIQV09OZ7gOxF1epLwiTS1PLIVCJKHKh3lWeYBZnPb1G4u4arAAkw
	 GfbSDawgyVYKA==
Message-ID: <f44181bb-ff82-4537-b2eb-fcbde304d7eb@kernel.org>
Date: Mon, 7 Sep 2026 15:55:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/huge_memory: dequeue the deferred split after
 the split freeze
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev
Cc: lance.yang@linux.dev, ziy@nvidia.com, kasong@tencent.com,
 hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, balbirs@nvidia.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-3-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260831091514.1879786-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4538F40004
X-Stat-Signature: prymw9unfeom8uxgethaho936wsxdwb5
X-HE-Tag: 1788789360-880987
X-HE-Meta: U2FsdGVkX1/TWwLCFoXtP+r1JuSh3V/MUvPXxy7gI2x0aNgWqG1etBQivr5y+A0+Br+wBo/Px/37+S46QPgB9vB13sSp28XNoiWFkWO5ddvrP/Kz4W2uo3ZMSI6z192oxLvieSjYg7IsIYI9eV3pcTxlToX8MX32Sw0INoWD8urIX9QFGxKhlp/SPsO42dGUq8cS4J1PUVL60r1oO5pOd5CjJGIXSGMGyNfFuzer8UfpKMyRz+zYjgsZddyQ2QiBLOXFe0SZ4JPMUJEafZflzqDxztECaPDJLcHngMW/7Qbb9nYKqJTxnwyKWReey1dVK3cAyTh1IK12eaS/tjn9S+qDbkIWJyswUM4gxH9P8fBJ1pqSup/QWGe3G2pvT1TmvrCqb59Snkk1FaVXI+TJS8ZyjbFuHr4VDiSZV0NCua3FgHYkUpxy3AeINGKLwE1RqY1EKbOt//AThGXEBi6jtSRgUO4LwOTPh0X6lENSPq8IGgRz/RO60wOjphf7vMXeXyhTP8gDfedmoaMFRfThj7tTifDfZN6XYTJ4sJPUQ/lIqrQqCScmA1ymtb998GkEqE62NZylzmCX2LmmbZg1536+yjc1BFllNrqd3Xg1i0I861KWlBV1PbVVJLjfQog68RrSuepc7JVNitXuXIg0styqBXI34KxLJuWsgRwDX4fL7ciN8Z7xdZ6yqq6PX6XXm3vxEFDnxH8iItZpl2F5SuKDTZrx7xPlGdgKjIk4QD+nDMDDVZmvyZJCiDiFuw9Fwa14iJPeIy74qHu53ybo4LWkSNBxD7DPv0wrYQX7xxNLvGskcvcMMFqJnJMXI33dKAAMhKMTamRQ5ekqku1GH1eV9MhpcWyavl0pZalXSTq8XmuTvFy16EqeWUA07fIQw0oTFydLZ/E4Z5IRrnFHYQfv07Vasn+ZLRD6l5e+TH6x/RkPI65sCc48wWZ+IxkJy0Q3VAYzK5Kr6fat48T
 VSKw2cqt
 n6/Q33+gEem/xyFuEsw/H7YVeCXnDougHfoAIFhvvrc0ZONgYpqOvsotduow9ab0KrOlhgzZH+1qkROjU1nkO8NkKrFENU9I4BChztL6NCVO8/TYktdp+9/N2lrcQe/Y6UEB+dm7bBIojQwlAuaJ8adZrSuTPNWuaKgQshHtr9Lh/bJqbd3SezBUTtcrbZToMM/AaFlVMxYeRv4ak66qT8kx7FklNBwLxZia2SMKd3STvmI9oT3En1JSGeO9dNGOQzSHlef9smIF+wTL1Y3kuKBiUrL14NPK0/iEFhVdbF9Osnizs0tm3RMzn3juamcAMoyIYtUL5yMTe3ineaYqXOTuZnD7t5FjtndcojfvkfNxE8LH9AUgXXV80fpVAovA1Amj0lDNdKhcS0RcWnN9nx2/yTEB8m8HLBKOq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 11:15, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
> across the freeze. It is only there to stop deferred_split_scan() from
> touching the folio under split.
> 
> With deferred_split_isolate() fixed, the workaround can be dropped.
> 
> Unqueue the folio after folio_ref_freeze(), the way
> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> zero refcount and a memcg still set, and both hold there.
> 
> If the split is called from deferred_split_scan(), the unqueue is a
> no-op -- the folio is already removed from the list. But
> PG_partially_mapped is still set, so it has to be cleared here or
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/huge_memory.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6281ed993243..c84e8cbc986d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3931,41 +3931,27 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
> -	struct list_lru_one *lru;
> -	bool dequeue_deferred;
>  	int ret = 0;
>  
>  	VM_WARN_ON_ONCE(!mapping && end);
> -	/*
> -	 * If this folio can be on the deferred split queue, lock out
> -	 * the shrinker before freezing the ref. If the shrinker sees
> -	 * a 0-ref folio, it assumes it beat folio_put() to the list
> -	 * lock and must clean up the LRU state - the same dequeue we
> -	 * will do below as part of the split.
> -	 */
> -	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> -	if (dequeue_deferred) {
> -		struct mem_cgroup *memcg;
>  
> -		rcu_read_lock();
> -		memcg = folio_memcg(folio);
> -		lru = list_lru_lock(&deferred_split_lru,
> -				    folio_nid(folio), &memcg);
> -	}

Nice cleanup.

>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci = NULL;
>  		struct lruvec *lruvec;
>  
> -		if (dequeue_deferred) {
> -			__list_lru_del(&deferred_split_lru, lru,
> -				       &folio->_deferred_list, folio_nid(folio));
> -			if (folio_test_partially_mapped(folio)) {
> -				folio_clear_partially_mapped(folio);
> -				mod_mthp_stat(old_order,
> -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -			}
> -			list_lru_unlock(lru);
> -			rcu_read_unlock();
> +		/* Take off the deferred split queue while frozen and memcg set */
> +		folio_unqueue_deferred_split(folio);
> +
> +		/*
> +		 * deferred_split_scan() takes the folio off the queue before it
> +		 * splits it, so the unqueue above finds an empty list and
> +		 * leaves PG_partially_mapped set.
> +		 * Clear it here: the flag does not survive the split.
> +		 */
> +		if (folio_test_partially_mapped(folio)) {
> +			folio_clear_partially_mapped(folio);
> +			mod_mthp_stat(old_order,
> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  		}

In general,

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

But I do wonder whether this sequence (that also
__folio_unqueue_deferred_split()) performs would deserve a small local helper in
mm/huge_memory.c

Could be done as a separate cleanup.

-- 
Cheers,

David

