Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3827CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25286B008C; Mon, 12 Oct 2026 10:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5E06B0096; Mon, 12 Oct 2026 10:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C57D6B0098; Mon, 12 Oct 2026 10:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74D656B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:03:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 066B2140E9A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:03:28 +0000 (UTC)
X-FDA: 85314141696.07.D60DAD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18C34140011
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:03:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gw/Cr0tm";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791813806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae6+9fsHBuTqfSzmzTNh6Q0vtGeTZM5nGNA/BO85wZw=;
	b=qjEHx8bqCSvBeWtsdxPlh58pxx4wHi0CiqxvZfz3fzGEdnw1KGoLx8aIPVZz6wDb9mnz8I
	DXUSrP4dP+22g1+U1oAebHihBxHxbMLzpDKzLCGlSaGKQ/yjI3Se3D3Zx9lxfl5C//bahp
	Z8FHVh74e/AC8k1frrnA+W+voBQccNo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gw/Cr0tm";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791813806;
	b=4dQyY23Dw5juYpU4e5fNZZUq1WvJpbWJA/7t3jmTcnfC8N8G5HFGkAz8vtVnmrjdBlowkO
	CU3WUPhopT+LXFYGzMtVZ+JUt/y8Z2F//RUZnnmuVmXSgsQ2n9mjNMlI/VJqQFh3RhW/Pw
	fCOf8UdpLOxHNvCmGuhijx6trKLFmIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75AAA40F59;
	Mon, 12 Oct 2026 14:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BC1F0089B;
	Mon, 12 Oct 2026 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813804;
	bh=ae6+9fsHBuTqfSzmzTNh6Q0vtGeTZM5nGNA/BO85wZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gw/Cr0tmM7dts1lWLtfjm/zCdTtZJ74AtM8vagxoe9q7mR1K3KfpA49DxZxe05xR3
	 c352MZQ2TN/rShWV46Mgn3fC3f9eLoUlryf4CvXuEYDYKcO1vBp76FcZEBeRir0NAc
	 8XsgYJrzlod1y/OZxikQeqK3ikSMb4qsQifQX9SXq3M0EK5fhrKL2VVQFqZCse4mFB
	 LsM8e2e9EYjvAaiia4Zfx9edDBPyAr3yxapc2yzhiZVFPyxBvcYD1ltkjK3t6TD+x0
	 rP2okYLeI/e2SJPI8B+OaXJrrgmzEw4PofuLnvClkH04b6Gn+eLZOOvBKg2PiGHDXF
	 DDBzI09shhopQ==
Message-ID: <11e317b4-8e28-4234-843e-96ad80fd6d96@kernel.org>
Date: Mon, 12 Oct 2026 16:03:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memfd: fix hugetlb reservation accounting in error
 paths
To: Andrew Morton <akpm@linux-foundation.org>, Hongfu Li <hongfu.li@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, muchun.song@linux.dev, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
References: <20260927094757.31665-1-hongfu.li@linux.dev>
 <20261007153526.cb4473601fc9038a9ca4f517@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261007153526.cb4473601fc9038a9ca4f517@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18C34140011
X-Rspam-User: 
X-Stat-Signature: ygm5d88bhgutgdbs3yham3kfifptbtjj
X-HE-Tag: 1791813805-495694
X-HE-Meta: U2FsdGVkX1+f37kuuYu19kFuwJxLDluGUt0Xn7HC4Ptqy6V/lRpRQpvYtkd1ofr2fSebj2Oj/y6hBU7EvSFH2alwetSI4xN/NBVIsLm0FcJXFkIYG1qZDkgB7CwzgzKgvQ6I0tIG16UC+5JVkt/FuCj02fJYKXlpGD6OLG2aNfLftAFjhWbNgipa4Im+2kDB4nZ3sLdmLKxaJsrQgGBqkDq5RrX/BxHFKqts4+PRSlBGuZVG/6rmNBTqaHVX3eNXcTQABNGzLSoZ8jX3imaTuR8crUUg28Cxk7mv396fL3+fItx7tdUILvFijaeWjslelrhB68XV+OhMwQedwjylLjRh9skxDRVP2OOzSPao76QseDhwvK+S4EoQ+z3SuIVcu16yZlrQuDPIQihml/f4YjTy3DTqpE/G336kVHltovQzjvRSYLen+zMxUOcGNRO2Cdlbp/h3PeWqwwdh4ZfuTLTDU+jFuoi3ZH1eH46BwscPTrLeYVCBAxXGUYt6yr/NeQ9eyy0mkS62RcfnUIA7Mf9c6s0qVngt3qU6Gks+luyNOvQ2Bu6UTNlD1rvszvq6pub3qdSvS/ZovZwxL+IbQ27jFngSh0gF2tg/0AxQzSpnWoPrJSTrWpWRcFSPvRnbHHVIznPokD7xtASW63gcrSEksAJpoMeHa6YzvjG5z9loBX8GEjZ5k3vxd+7zx6vLsqXMzeTBdDNmLTJab5cMe1yn6JH03tm5qz0dj+vyPQRVgAO9ws3RDz/wSCYNSIxFpcGhMxSG9WqzRMnbTGzLIBHTpG8SFyb+WyLGYPleq6L9KZMegIrb/Y1Kat8x3tkTSH9R+X0C6HnXJGCfb4O506A4nDK2Y4bMK2W7MJd1OSFdnAFFUjXVPTRuNvrhRtkP66L8Xio7iTwmQMAHVhZ/TGqSPyKFC+WZRxIuVhCPK2xrErc77Mf/NHLJCMsHL4Er6Yu6b7YzTGScUVT0TF3
 RExYIG5L
 fJVNXLvGS+GAVkgdquO7BQftAE7cASSE6Q7Nw4ZanlDFDM7fw0Fh1o6Hg7c42a2k/cbi3cu4BhLLW72vZzdNn8THZg3n3UQPUh5KBOnj2TWiCqKbgOliWqwm22+3ortkJKjPJDVNBMLJQiiXYHz9ZVMJatauNMt37gRYIdBSEf51WAtQEVyZpnqTfXHL0FGsxu7Lkeuw9hC8c46hUE9+hPaPeYPWhwHeMPRCAhZpLrzn+RQb62RxIX18cORxFqdsi7K9DYc4+f5z/DxW0mgh9a1qA4rpnCkG6fGqK0Z6w6kLCBD/cNB1vc62mX2wshVcYFNKh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 00:35, Andrew Morton wrote:
> On Sun, 27 Sep 2026 17:47:57 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
> 
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
>> a concurrent fault has already instantiated the folio in the page cache,
>> and the reservation now belongs to that folio. Calling
>> hugetlb_unreserve_pages() in that case incorrectly removes the region
>> backing the cached folio and releases one reservation more than it
>> should, leaving that folio in the page cache with no region recording it.
>>
>> That leaves resv_huge_pages one page short until that folio is removed
>> from the page cache, so available_huge_pages() reports a page that is
>> not actually free and the pool can grant one reservation more than it
>> can back. Applications using hugetlb memfds can then fail to allocate
>> or fault in a page they already reserved. They see -ENOMEM or -ENOSPC
>> from the allocation or fault path even though the reservation and
>> HugePages_Free still look healthy.
>>
>> So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
>> error-path unreserve completes to make the reserve, allocate and
>> instantiate steps atomic against concurrent faults. With the mutex held
>> from the start, a concurrent fault can no longer consume the reservation
>> between reserve and allocate/instantiate. If a fault completed before the
>> mutex was taken, it has already added the region for that index, so
>> hugetlb_reserve_pages() returns 0 and the error path leaves the region in
>> place.
>>
>> Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> Can we please have review of this cc:stable regression fix?

Hugetlb AND reservation? what could possibly be nicer to review ;)

> 
>> v3:
>> - Update commit message to describe the accounting damage and its
>>   user-visible effect; no code changes.
>> - Add Cc: stable@vger.kernel.org.
>> v2:
>> - Take the hugetlb fault mutex before hugetlb_reserve_pages() and hold
>>   it until the error-path unreserve completes.
>> - Update commit message
>> - Link to v1: https://lore.kernel.org/all/20260831090631.29227-1-hongfu.li@linux.dev/
>> ---
>>  mm/memfd.c | 31 ++++++++++++++++---------------
>>  1 file changed, 16 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index c708d92533f4..0f6fff004f5e 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>>  		struct hstate *h = hstate_file(memfd);
>>  		int err = -ENOMEM;
>>  		long nr_resv;
>> +		u32 hash;
>>  
>>  		gfp_mask = htlb_alloc_mask(h);
>>  		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>>  		idx >>= huge_page_order(h);
>>  
>> +		/*
>> +		 * Serialize hugepage allocation and instantiation to prevent
>> +		 * races with concurrent allocations, as required by all other
>> +		 * callers of hugetlb_add_to_page_cache().
>> +		 */
>> +		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);


I'd just do

	const u32 hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);

above, but doesn't really matter for the fix.



>> +		mutex_lock(&hugetlb_fault_mutex_table[hash]);
>> +
>>  		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
>> -		if (nr_resv < 0)
>> -			return ERR_PTR(nr_resv);
>> +		if (nr_resv < 0) {
>> +			err = nr_resv;
>> +			goto out_unlock;
>> +		}
>>  
>>  		folio = alloc_hugetlb_folio_reserve(h,
>>  						    numa_node_id(),
>>  						    NULL,
>>  						    gfp_mask);
>>  		if (folio) {
>> -			u32 hash;
>> -
>>  			/*
>>  			 * Zero the folio to prevent information leaks to userspace.
>>  			 * Use folio_zero_user() which is optimized for huge/gigantic
>> @@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>>  			 */
>>  			__folio_mark_uptodate(folio);
>>  
>> -			/*
>> -			 * Serialize hugepage allocation and instantiation to prevent
>> -			 * races with concurrent allocations, as required by all other
>> -			 * callers of hugetlb_add_to_page_cache().
>> -			 */
>> -			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
>> -			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>> -
>>  			err = hugetlb_add_to_page_cache(folio,
>>  							memfd->f_mapping,
>>  							idx);
>> -
>> -			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>> -
>>  			if (err) {
>>  				folio_put(folio);
>>  				goto err_unresv;
>> @@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>>  
>>  			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
>>  			folio_unlock(folio);
>> +			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>>  			return folio;
>>  		}
>>  err_unresv:
>>  		if (nr_resv > 0)
>>  			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
>> +out_unlock:
>> +		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>>  		return ERR_PTR(err);
>>  	}
>>  #endif

We now run allcoation+zeroing under the mutex. Which is the same as done in
hugetlb_no_page(). (I just looked at that function, now I have to wash my eyes)

So holding the mutex for longer seems to be the right thing to do.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

