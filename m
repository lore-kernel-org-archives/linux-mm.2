Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5C4C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F266B007B; Thu,  6 Aug 2026 10:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25626B008A; Thu,  6 Aug 2026 10:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CCA6B0095; Thu,  6 Aug 2026 10:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF996B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:17:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A991120758
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:17:31 +0000 (UTC)
X-FDA: 85071047502.22.7BB1040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 376D840012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:17:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jdYnerw0;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1GD69MNdL2Krccft9/mtd7QqmRzRsRy1YD00dFIkeg=;
	b=38FBRdygfJH19T+60X6Uwu/k80E2CUlOJePOBw/ti/gnpQiQxcdL23rvtI7ukCKpm7hdB/
	U94+5afzQb7mWWYTXHQak9vLr6D7yk+JaNtAocXumWV3d51qN9O0HILguYBzERG0euxTO3
	Gj+SUcUvYr9wdmfkQgzb1kKvLhFKu4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025849;
	b=l5XHMicpDgQxV0xO1cDGNmCQ8H15owfJBRHdwYpcOH2KrRFOJx9rhrSL+5b2Oz4j1jptoe
	jJDFWBnobVjIzHZFeBqx3Qa9+7sZxcPpDZk1YYVBBDjK6F2y4GmvOXq3xkpYa9htFJNInC
	uoee+Ix2fHu3hbWuJk557cqas7KOLQg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jdYnerw0;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AEAB43E8E;
	Thu,  6 Aug 2026 14:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12301F000E9;
	Thu,  6 Aug 2026 14:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025848;
	bh=t1GD69MNdL2Krccft9/mtd7QqmRzRsRy1YD00dFIkeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jdYnerw0CkZ1v8zKbVpb8lg+5/Cu1a1C5J3KMKf49jA+sxF/FJvIdIzTRESCyxc0V
	 MXkf/75wJEeSvUna6C9cfzeeZSNEBuMZyHjYVLfqLDjW29FxtbWbU1EOEVu8M7yQVA
	 X4+vAFhC1RC8SlukZaR9CGXkWRDqXQjQomb1TNKjJy6VVx4FLjRSXZH9SXENf7YEJF
	 bvi50poZcSv2lQse2elreq+SY6wtqm5HEl21Ymx0ntPAqUaw4wS9zyH7p4avONeLb5
	 ejoFwMT6DC3aUWj59ojbFR5JCjsE5eBzTnpOE9lAaV5U6F7gVLqF4XNSRKVeCk5bIE
	 yimQY/TKgtjRg==
Message-ID: <d6e665cd-08a3-4598-8a4f-1af21eea4132@kernel.org>
Date: Thu, 6 Aug 2026 16:17:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
 <anRv8ngsyOjkgOHM@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anRv8ngsyOjkgOHM@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 376D840012
X-Stat-Signature: 4nh65d4n9ftmfnxhs6y67irbqes5rkbu
X-Rspam-User: 
X-HE-Tag: 1786025849-854169
X-HE-Meta: U2FsdGVkX19bS/umh/KjKVJVYZGmFqUUw5fXYUYXWnx8rNn+rr0mstRu6gV9BNKS0vAlhJh37QuEGnNlURrkHynJqHEwF+sjhoHGXsFjTTd4JTmBi7meCbD69pyoBFetI5TGNCkSowJdvu535iUp8hgnX5twaT8TvcCP+GmSwSfp59T+7HRyzKKxLdjTFfXnpEP/4IEV9EKTPDlJwWM93/UYuXK3eMDzWCuOw1AogtHKKulO8/Wx8+fhgb87btFftUJmEOcr4kw/iNXcMl6uVetmaoek9XpTp75Vw1nXG3H+GdhV1pa+JTNdhXqNgplXqtNwEYOkGGmOpXRRHodqkbpsAn2IbMP6AjTAOjCrEEbiFm0HsarPYGa88mBm3GUteoeN1GypFT3Nc56vuZ6OdhMbl5qKaJ9VzQMhaNzsqduJ33qYupgei87AHQO081AXK+ECf3F7uRrIT2HizT8ixxXIEIjkcMUL/3G9z4b82QyMfLpqQDi1eJxugJmg5elyh6Zg6Apfc9/rq5ip1QXFToRUoSddMiPC0A6AkdvT9CfIIhImuCH8+RktefD75XMIUhEhFkA9hy2T0HmTH6heem0p7ZU6uFwgo/8lukwEr5EgW77AiHPtHF2T7LzyOl+8xrO4yAgj4iFE6QawGHtRfb5GiFRT6PJP4+UwpiAOA5O5FZbyXI+9yNLWBtnmHTcyDkuaYiH79vt/YorVlg62tK4TTf+XiVfgeDbudyMAnjY/qoQ/KPFNAltGSCG89je35T0QP4yBKJIY8E6XBvZMLnUxYsmLjzD0VPV0VRGhK5/rU1KKEON3bxoOw3ONByrCkJVMYGVjH299zcB/Vxxe2tvYMD0++yVuJ+qM3TNpYFzJdFE+z3NWT/vT2fnjtjX8rfJNrvRPSIy1++DxI77wps87LANTJLZAzW/AotDCXy7yKntL7KPO/OXvXwfZAGe+BTZc+APOuyvDXxzEQ5f
 +NB6w5f8
 vvbw1+6IPX2avZw4jq5v+3yBcGHKzFXkHz4aPPvQqDILO47hcNveubIsPZrBQvd5iSTLhSMrZTibGOMsoJ8f7GfAabpx4uGSE4ioJznMTigG797OsHED67wntfS7x5BHoToseR8qDg0guhQfWkfRgjvteYJdItbvzi5ndCCj4sbzuiPRIWvZo0oq7rh05zY1l2scv9YSPvnxMvuYQEhxvzciKfZx7ng/h0Abphu4H5E56n0ejiQOu7yCxybdq7MdoOpB7iHNjf5q5ZZLYlgKBzpsLNZ2ZAPYeYMYkJiB1eN2L7aOTxio7iyr7M57m1HBtoWiM2+HfnBYJlg0Bo2f1CAE0dgMjVVNliSBtF4SoBHzOGTKctvJDsN1X3k/3+gOjc7McXyNpQWiLICkYZ3AJNrhxRYB8Kc6z64dlmHprcsQ1puo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 16:03, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
>> hwpoison code can end up calling min_order_for_split() without holding
>> the folio lock. There isn't really something that would prevent
>> concurrent folio split. Consequently folio->mapping can get set to
>> NULL after checking for "!folio->mapping", and if the compiler
>> reloads folio->mapping, mapping_min_folio_order() would try to
>> dereference NULL.
>>
>> While very unlikely to happen in practice, let's just enforce that
>> min_order_for_split() is called with the folio lock held. We can
>> significantly cleanup the calling hwpoison code, and just get rid
>> of try_to_split_thp_page() to hold the folio lock for a bit longer.
>>
>> Just work on folios now, which further cleans up the code. We just
>> have to be careful about doing the page_folio() after splitting, which
>> we have to do already either way. Do not change the way we split for
>> now, this needs more thought and should be done separately.
>>
>> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
>> would currently have leaked a folio reference.
> 
> Yikes...
> 
>>
>> In folio_split(), document and assert that we need the folio lock.
> 
> You mean min_order_for_split()?

Very right :)

> 
>> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
>>
>> The folio->mapping problem was identified by Sashiko, and Li Youhong
>> reported it by sending a proposal fix.
>>
>> This likely does not really warrant CCing stable, but I expect little
>> conflicts when doing the backport, so let's just CC stable because of
>> the refcount leak.
>>
>> Reported-by: Li Youhong <liyouhong@kylinos.cn>
>> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
>> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> A typo above and a nit below about a comment but otherwise LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>> v4 of the last fixing attempts:
>>
>> https://lore.kernel.org/r/20260806031958.677935-1-dayou5941@163.com
>> ---
>>  mm/huge_memory.c    |  4 ++++
>>  mm/memory-failure.c | 56 ++++++++++++++++++-----------------------------------
>>  2 files changed, 23 insertions(+), 37 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 9b1f3b24f7e0d..a00df56a68b57 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4362,10 +4362,14 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>   * If a file-backed folio is truncated, 0 will be returned. Any subsequent
>>   * split attempt should get -EBUSY from split checking code.
>>   *
>> + * Context: @folio must be locked.
>> + *
>>   * Return: @folio's minimum order for split
>>   */
>>  unsigned int min_order_for_split(struct folio *folio)
>>  {
>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>> +
>>  	if (folio_test_anon(folio))
>>  		return 0;
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index aaf14608b30e2..f4f3f1fc9eaff 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>  	return page_action(ps, p, pfn);
>>  }
>>
>> -/*
>> - * When 'release' is 'false', it means that if thp split has failed,
>> - * there is still more to do, hence the page refcount we took earlier
>> - * is still needed.
>> - */
>> -static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>> -		bool release)
>> -{
>> -	int ret;
>> -
>> -	lock_page(page);
>> -	ret = split_huge_page_to_order(page, new_order);
>> -	unlock_page(page);
>> -
>> -	if (ret && release)
>> -		put_page(page);
>> -
>> -	return ret;
>> -}
>> -
>>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>>  		struct address_space *mapping, pgoff_t index, int flags)
>>  {
>> @@ -2509,9 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
>>  	folio_unlock(folio);
>>
>>  	if (folio_test_large(folio)) {
>> -		const int new_order = min_order_for_split(folio);
>> -		int err;
>> -
>>  		/*
>>  		 * The flag must be set after the refcount is bumped
>>  		 * otherwise it may race with THP split.
>> @@ -2526,24 +2503,25 @@ int memory_failure(unsigned long pfn, int flags)
>>  		 * page is a valid handlable page.
>>  		 */
>>  		folio_set_has_hwpoisoned(folio);
>> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
>> +
>> +		folio_lock(folio);
>> +		split_huge_page_to_order(p, min_order_for_split(folio));
>> +		folio = page_folio(p);
>> +		folio_unlock(folio);
>> +
>>  		/*
>>  		 * If splitting a folio to order-0 fails, kill the process.
>>  		 * Split the folio regardless to minimize unusable pages.
>>  		 * Because the memory failure code cannot handle large
>>  		 * folios, this split is always treated as if it failed.
>>  		 */
>> -		if (err || new_order) {
>> -			/* get folio again in case the original one is split */
>> -			folio = page_folio(p);
>> +		if (folio_test_large(folio)) {
>>  			res = -EHWPOISON;
>>  			kill_procs_now(p, pfn, flags, folio);
>> -			put_page(p);
>> +			folio_put(folio);
>>  			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>>  			goto unlock_mutex;
>>  		}
>> -		VM_BUG_ON_PAGE(!page_count(p), p);
>> -		folio = page_folio(p);
>>  	}
>>
>>  	/*
>> @@ -2861,9 +2839,8 @@ static int soft_offline_in_use_page(struct page *page)
>>  		.reason = MR_MEMORY_FAILURE,
>>  	};
>>
>> +	folio_lock(folio);
>>  	if (!huge && folio_test_large(folio)) {
>> -		const int new_order = min_order_for_split(folio);
>> -
>>  		/*
>>  		 * If new_order (target split order) is not 0, do not split the
>>  		 * folio at all to retain the still accessible large folio.
>> @@ -2871,15 +2848,20 @@ static int soft_offline_in_use_page(struct page *page)
>>  		 * preferred, split it to non-zero new_order like it is done in
>>  		 * memory_failure().
>>  		 */
> 
> This comment is:
> 
> 		/*
> 		 * If new_order (target split order) is not 0, do not split the
> 		 * folio at all to retain the still accessible large folio.
> 		 * NOTE: if minimizing the number of soft offline pages is
> 		 * preferred, split it to non-zero new_order like it is done in
> 		 * memory_failure().
> 		 */
> 
> Which references 'new_order' twice - probably need to update this.

Agreed, thanks!

While at it, I'll just drop the NOTE that is not of any value, really?


diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f4f3f1fc9eaff..9f1e547e7b472 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2842,11 +2842,8 @@ static int soft_offline_in_use_page(struct page *page)
        folio_lock(folio);
        if (!huge && folio_test_large(folio)) {
                /*
-                * If new_order (target split order) is not 0, do not split the
-                * folio at all to retain the still accessible large folio.
-                * NOTE: if minimizing the number of soft offline pages is
-                * preferred, split it to non-zero new_order like it is done in
-                * memory_failure().
+                * If we cannot split to order-0, do not split the folio at all
+                * to retain the still accessible large folio.
                 */
                if (!min_order_for_split(folio))
                        ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;

> 
>> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
>> -						       /* release= */ true)) {
>> +		if (!min_order_for_split(folio))
>> +			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
>> +		else
>> +			ret = -EBUSY;
>> +		folio = page_folio(page);
>> +
>> +		if (ret) {
>> +			folio_unlock(folio);
>> +			folio_put(folio);
> 
> Wow, incredible that we had a refcount leak here for ages and didn't know. Ugh
> what a mess this hw posion crap is!

I mean, soft-offline handling is not what runs on ... everyone's box. And the
memory will effectively be dead soon either way (hardware tells us that this
memory is likely going to get hwpoison soon) in most cases ... :)

-- 
Cheers,

David

