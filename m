Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B701606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tl7djDwB
Received: by kanga.kvack.org (Postfix)
	id 987386B05B7; Mon,  2 Nov 2026 08:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938D56B05B8; Mon,  2 Nov 2026 08:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826866B05B9; Mon,  2 Nov 2026 08:42:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E796B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:42:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6A7740D2C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:42:56 +0000 (UTC)
X-FDA: 85390294752.16.5BE94EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FFD320003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:42:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl7djDwB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N92l3jjvO00CtpEZOu8rveygTDy+OqbCyAbm8AeBzYI=;
	b=aAdtlySoFrJ9cjD7QjXDWIi2Yjzv/Pnhm78zKzsjNtMGb5RMbrb9xL9pfajWA3eBp7h8Zd
	dd2eoqoPXp97GIxxTmn94NkkGaQT3md50O6mvrqhYSdQo1r3yNwn0tiD9NNqEOeSkZ9UTI
	GYseBXpKlOUM8LPRDDvYowLiQ5l13GU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl7djDwB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626975;
	b=eR6Wx4kDklFhnsLMHqsY+IGXfsZx2XPW8+4em+ATuFjxBRM5Q0+rEw8nm35SO+4G3IJrjV
	GfU3j1U4bgkw1O44NNT90m6WMb6EVW3fVDBn+nM3rDV5s1CSONBdhsLvZQfo7exU1cDu+0
	wLfUEbyd/WizlF1Wiw+Za2N+MtSBd2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EE116060E;
	Mon,  2 Nov 2026 13:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AEB1F00A17;
	Mon,  2 Nov 2026 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626974;
	bh=N92l3jjvO00CtpEZOu8rveygTDy+OqbCyAbm8AeBzYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tl7djDwBaHB0P3Kuzzh7diRALB/XJy9zz68TIIVk13VN6FbCQF9rlMQTZ+oud5OLl
	 HWdrdGu92Aug5rumrxIjAlxSeiiGCK05JPKz7CjySd03tUiGnIMPEeY4RxKPlM4i80
	 DBwyqwD33qgtQ032BD3Wqd/FqZfcfOycAsImhKBSBE9gr0LdZkH3MJO08/pvLlQQVj
	 svMwhggPT2rj+R+FeAo817O/t8DLzYJ8t2drgE6WPataY85jbXk9eJTHug2kgBiV1n
	 0IhhxesRgcT5odVtnYFc1IRsmkrSeAyFybeAQwiHqdguNoJt3cghZKbcXpqjTLdDii
	 ocf436Tuj7SfA==
Message-ID: <12d9eb7a-a9eb-4e3a-b5fe-abc49f67f212@kernel.org>
Date: Mon, 2 Nov 2026 14:42:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/15] RFC: mm/hugetlb: account restored reservations
 before freeing folios
To: sashiko-reviews@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Dave Airlie
 <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, Gerd Hoffmann <kraxel@redhat.com>,
 linux-s390@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-14-a0a033db180f@kernel.org>
 <sashiko-outbox-189914@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-189914@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3FFD320003
X-Stat-Signature: gjawqc3jirf63pmxc9o47i3nfjxf5i8f
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793626976-590055
X-HE-Meta: U2FsdGVkX19gr3QuU6odxEOU0NX6rIYI2qcjfecA+TByIRuOP4i89+L/1xjLi18op0hKRNQPxvdk+RKvE5yILmTvwqI5b3LMqCew68J1wikrCHfxyAzruVxwNccfNns0Bkhp0G/B8MuH0TfVyz1hlHjNgh9OYOJq66CBIysILpgipNYKx4LpQLcPQvgiA+gDBqJt3GS6aMvFYwyMFjD1qvLktfQzR5JJq3F30zB7VV+o07GJCjpk2p+4l11q9SgZ0KNmAcc6r7HFp1hoTe408YcoOzEpl0wVnkG+HVwkzbmooGEs75JNW1WJZLaufO47qJEwgoxrb3H5U4386KM9pb4QuPpgZBpZh0XJ0da9tn8eQYkKe+p+QdOGO99NDMwTxp0KN2AXvip5iYRBiXbXtmehjbNVn58fsZEC75M8CrAUn8KaQDJH/LQl0Jpx4i58VI85FdHX5tCqjRQ4WVNPct4SugnZUA7Pieb+ejJhJlj+zc3pZ8Qxy6+1bn17zmkdWjr5jIPLVTetiPlot4Koaa5M+qVnk8gQruyn5fggUa396+vbMdJcf8NFpdk7HX1v6bCy5u0wP2FfjycMvrUkWTVRA9yRs2MZD9hWGWVMdxBX/b4+TY7Hp3dchygn4ZfCFny4Ef3j3iMSuViC7weyoiS/FPsVtWVHtiWTRBOfFQQGMzs85L+eGOWDlr6JlmuZXjVHfkmJhfSU5yMUHwpTqVAWOOpSgiqYAGS9VhH2VQymZ9tHx3NTwxrJSAwYt8tjJCeYlAuuLPITso9wSTwnF6ki16hIOXIlvMQLiGI3ZK9AQBS1w1uoD3rBnnlnsqpCc1bcy2M7moRvSFkZbDk1pPOmAseeHWLMhkQUuPucZZlf8HbANplsIXXTq5WvZmTGR510kls+lNQHI0WPEBuFhJIz/9cG5J4OBqem8d9G7TI2Kr70kZQoZ8dmDmAQbNtJKLs5acmUBSB7I6lZTXV
 Bz4RjjaI
 pD/YxWsTR8sOY5G/vfAlggUiBJkIkg8UrAXsXyQ7GwxE5sPQH3bNqvIkuzVEDi6V6S1J5fYptkpBOyoXocAvBU/Chd3fvEbH2RWKwht9Ln8A7WWrWH2vb1qUpv3Wt/+WWI9E38LriKPSj9XsGe8ph3a+qZkEwV6+8NfZbYEz+UicH+v+3nkzTEQ0JZPVtepMg4auRSAXWyuptCaVOe4vBdD8ROFEhK482IIQUup1l9POdYipU9LRUpI/3amTWR9xSlhmiX6UToWdSmf6Wd1sczpPzX4lA77B+7KjzgOq72OYV6lOGKdZq5Wnt3SuiBOHmkRAvvawFPMhzEeQ2O1usdDnETUTpraDjEUn9S6X0rO2AWBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 21:16, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm/hugetlb: gather_surplus_pages() over-allocates and retains surplus folios
> --
> 
> commit d5256483029a06972dd519de19de57831de33af4
> Author: David Hildenbrand (Arm) <david@kernel.org>
> 
> RFC: mm/hugetlb: account restored reservations before freeing folios
> 
> This commit updates anonymous hugetlb folio unmapping to increment
> resv_huge_pages immediately when restoring the VMA reservation rather than
> waiting for the folio to be freed. Because resv_huge_pages can now
> temporarily exceed free_huge_pages while unmapped folios still have
> elevated reference counts, available_huge_pages() is updated to clamp at
> zero.
> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 69a5d2c73ee1d..06ef8ba41df7c 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
> [ ... ]
>> @@ -5313,6 +5309,45 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>>  	return len + old_addr - old_end;
>>  }
>>  
>> +/* Must be called after rmap removal. */
>> +static void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
>> +		struct folio *folio)
>> +{
>> +	struct hstate *h = hstate_vma(vma);
>> +	unsigned long address;
>> +	long rc;
>> +
>> +	/*
>> +	 * Restore only on the last unmap, otherwise the owner could reuse
>> +	 * the reservation while the folio is still mapped by a child.
>> +	 *
>> +	 * TODO: Handle migration temporarily dropping the mapcount to zero.
>> +	 * TODO: Prevent reservation reuse before the folio is freed.
>> +	 */
>> +	if (!folio_test_anon(folio) || !__vma_private_lock(vma) ||
>> +	    folio_mapped(folio))
>> +		return;
>> +
>> +	address = vma_anon_address(vma, folio->index, 1);
>> +	rc = vma_needs_reservation(h, vma, address);
>> +	if (!rc)
>> +		vma_end_reservation(h, vma, address);
>> +	if (rc <= 0)
>> +		return;
>> +
>> +	rc = vma_add_reservation(h, vma, address);
>> +	if (rc < 0)
>> +		return;
>> +
>> +	/* The restored reservation owns the subpool charge. */
>> +	hugetlb_set_folio_subpool(folio, NULL);
>> +
>> +	/* Account before the VMA can close or fault again. */
>> +	spin_lock_irq(&hugetlb_lock);
>> +	h->resv_huge_pages++;
>> +	spin_unlock_irq(&hugetlb_lock);
>> +}
> 
> [Severity: High]
> With h->resv_huge_pages now able to exceed h->free_huge_pages while an
> unmapped folio is still referenced (for example, via vmsplice() or GUP),
> can a concurrent hugetlb_acct_memory() -> gather_surplus_pages() over-allocate
> surplus folios and retain them in the pool?
> 
> In surplus_pages_needed():
> 
> 	static long surplus_pages_needed(struct hstate *h, long delta, long allocated)
> 	{
> 		long global_free = (long)h->free_huge_pages + allocated;
> 		long allowed_free = (long)allowed_mems_nr(h) + allocated;
> 
> 		return max((long)h->resv_huge_pages + delta - global_free,
> 			   delta - allowed_free);
> 	}
> 
> When h->resv_huge_pages > h->free_huge_pages, (long)h->resv_huge_pages +
> delta - global_free includes the deficit from the in-flight unmapped
> folios on top of delta.
> 
> If gather_surplus_pages() succeeds, needed += allocated equals delta +
> (h->resv_huge_pages - h->free_huge_pages), so it allocates and enqueues
> extra surplus folios beyond delta (or fails with -ENOMEM if
> nr_overcommit_huge_pages only had room for delta).
> 
> Furthermore, when gather_surplus_pages() cleans up unused or aborted
> folios at the free label:
> 
> 	free:
> 		spin_unlock_irq(&hugetlb_lock);
> 
> 		/*
> 		 * Free unnecessary surplus pages to the buddy allocator.
> 		 * Pages have no ref count, call free_huge_folio directly.
> 		 */
> 		list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
> 			free_huge_folio(folio);
> 
> free_huge_folio() checks:
> 
> 	} else if (h->surplus_huge_pages_node[nid] &&
> 		   h->free_huge_pages >= h->resv_huge_pages) {
> 		/* Free this surplus folio that is not required globally. */
> 		remove_hugetlb_folio(h, folio, true);
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> 		update_and_free_hugetlb_folio(h, folio, true);
> 	} else {
> 		arch_clear_hugetlb_flags(folio);
> 		enqueue_hugetlb_folio(h, folio);
> 		spin_unlock_irqrestore(&hugetlb_lock, flags);
> 	}
> 
> While h->free_huge_pages < h->resv_huge_pages, free_huge_folio() will
> enqueue the aborted surplus folios into the hugetlb pool instead of
> returning them to the buddy allocator. If the in-flight unmapped folio is
> a persistent folio on node A (where surplus_huge_pages_node[nid_A] == 0)
> and the surplus folio was allocated on node B, dropping the last reference
> to the persistent folio on node A will not free the surplus folio on
> node B either, leaving the surplus folio stranded in the pool.
> 

Damn that's confusing. What an overengineered mess :)

Surplus pages ... another thing that should have never been merged.

I guess we'd have to clamp also in surplus_pages_needed:

@@ -2317,11 +2312,13 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
  */
 static long surplus_pages_needed(struct hstate *h, long delta, long allocated)
 {
-	long global_free = (long)h->free_huge_pages + allocated;
-	long allowed_free = (long)allowed_mems_nr(h) + allocated;
+	long available = min(available_huge_pages(h), allowed_mems_nr(h));

-	return max((long)h->resv_huge_pages + delta - global_free,
-		   delta - allowed_free);
+	return delta - available - allocated;
 }


And in gather_surplus_pages() we'd then have to be more careful about which
surplus folios we're actually freeing.

-- 
Cheers,

David

