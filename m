Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C683BCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2642D6B00B0; Mon, 24 Nov 2025 14:23:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2146B6B00B6; Mon, 24 Nov 2025 14:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104036B00B7; Mon, 24 Nov 2025 14:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE8DF6B00B0
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:23:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BA9CC0546
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:23:05 +0000 (UTC)
X-FDA: 84146473530.26.2055EBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C197210000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:23:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kznAdjy3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012183; a=rsa-sha256;
	cv=none;
	b=UNTfBAOhZpAh3AgR5eUyqwVVQSzYSdBhS3lLFWt5YHPSbNWWv6UWVK6TWF5f4k+U5JorOz
	MIKQlUWpeh6LBrvmxy7LXN5TE09/LCNkZuRjQ3ORk56F+FF9tlia1FpseYHcA6nLKnRE+b
	y4AhV0AWf2Tr6v9otXEZBLuAEwYy/Os=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kznAdjy3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpPZ2Ka4AHKzWrVw9fZI8U9G0FESOhT/Q1nFfUzeQEw=;
	b=0yCEPeaOay2X3uFAy0ScBQHHE/TctID/d8Nprju6OpeF+bpHtfJIGXAh+OsWUB25kh5HtD
	yqOSplHFGk6fP9E59XM3NGyA8xNrTYhDeak6oN+/0IwUBZeUIZTRB6zCzBkqEAEbgXUBa+
	PLNensH9K9q54VOLShLWVYoEXp7segU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C2BC60122;
	Mon, 24 Nov 2025 19:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77013C4CEF1;
	Mon, 24 Nov 2025 19:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764012182;
	bh=EVW8rxvFH63h3jyD2ik3N8abrAtng6JWEIMfvjgB+CM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kznAdjy3fEZWRWT8KExUzkrJpgA8UyzN5PAEUkJc0Wd8oilFuvPZ0tsjiUHgVN6et
	 jVtITKEAyD2aXjB0+YUE49lR74EVMCqAJdmxbNSfHgbw7pKyX2CT0ruButPwGeGcIa
	 5K65ke6LF14HVuMfKIVVN27yqEhmcLVblJ27c4X+1GRk+G5RTSKRbKOuHUFq+ATrv5
	 0F+n1t90upJbQ66jyr8TMBwwJQ1+D18bwwLyrPaJmIyhsATLQaiBlEqgJDGqWxo4Rc
	 AFJOkjv141Xn/hMSIZzAkY2tzanD43ZXVi2kBjvtYg9G5ZnQ+y2xGknvy61+3pMYTF
	 63q7Q/WR+s/OA==
Message-ID: <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
Date: Mon, 24 Nov 2025 20:22:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C197210000C
X-Stat-Signature: s1pdmifsd3r7ddyrzfrtizb9m6zkkxfg
X-Rspam-User: 
X-HE-Tag: 1764012183-373350
X-HE-Meta: U2FsdGVkX1+hu17w6Yo1DMsURUFdhcxolJb5/uK1VLpJSWYKdOHpFfN4h+Wsgo6Vlc/l14quHZiqa8yKug8EcZKVPUnLrgqVd8bQdqe5Y9HtyAeGN+0hlFUcjW21sqRnfmvQo8pXH6hgt6x+9NN8uy8osPonmLZwgizn8QL6wvCCOYVBLYVRzhmb9sPRuJ4zY6w0ibBGN5xYUuwEwgsyjomBlkMkaNm8Xgz50iNJ5gAxEfplK3g1u2ltQvcWbNzF/E9QbqOaPtR5Fd8WvNizB+iTVRMgQaAM4dDUvRU0PUGPlCKGOg7U7A6leTg4Jr3aeDkqGwS7SebA05/cSGUHFnBbYKGznTZeHMrXIJsIUa68CWLeONdWSNZsbZwcXh376N4HB0nsvb/j/CDKuYHp+Qu0n8YhhAkOsLhUwSQ9IFQmJrSdIdwW+Q9Vh7FD3ZJrdS7ABSaq3Z3s9rMXbAP2uAoxnSb68zzAJREGPVmakodTJPM0tBwYo3tiS8XTzytGRBT9/httLEANG9EiRAlL9tFRLvxbP27WRf47L5qlkF0LWaSV2mOIiSX/9G8dqsnK4xFuxmXYiWzO/imaU4jXwSca7nEqhlM6725mkAAQSe3QVj9T/m0Xg39btrLBgQqO/zunuwype0aIGkS+/1O53A8nxNIwnQ4n80Ww5uwz1S1bShAuzCd7HqNJBd1CIHJ6uL60+arDnixpd7eV6eMiOGGNoj4oycnEMGCDd7w2EMqLHI0KvfBiZWyaDpoCsAUEO7kY7Xiu7+VTRdqAOXEGm9YKwSSdMo9VFgQlZqGa6YiBvcn4IhGE4OIrXGWa0KmsGiKxcvpW2ZiCczahSGV2wV6YPS5qBRGGDeKhm4TigMqUVo8BrOC1aD97GZ8p4CEuWAUN0YBYsH7u/YWlPZD6vr5zWJwApXXtdF6Kuao90YZSHIkNCP6nHkw09DND7W7bENgCqj8pry0ZkpE//Bv
 6LsN4kSa
 T3qwYv3dARjkausljwl7G1Q6HB6yFdNnDVJvzFo4Ty4ZYW/pMMtQxcl+XJ/L9sdzwbW9YsWfUvNnQ2lAU4Q4NNBuCGZj9725uj/3xHxS11uMd6JqyqwHkDhPQZCKfPcRtbceMN7iJ2MG3ymenL6RXIE2Lhq1k37Bk8pkdVZVpuaDuz7DDONLiCFgxc71G0mqtlBKFIgTQxRjURuXBiI86rs9uTzlbS6icVRj0jdvFsiyL4C8XATDibAGyvLoYGhJiE8MUkk8l6eJNVrN07osy6mw2BZnySnTXAUUnl26Tnlku2OeHgVZQPIqKkOgN70Esq2BDgYHckj5mAn7BheHb3ZoJfZnR3nzbuDXwpPOGI9djeUz/HERTMb+vnYEDIQ6utellSasrWh0KnQAhU1cFYIKcHv+jQQ/pNA0KukK4kJWR/Kc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 18:05, Zi Yan wrote:
> On 24 Nov 2025, at 5:41, David Hildenbrand (Red Hat) wrote:
> 
>> On 11/22/25 03:55, Zi Yan wrote:
>>> can_split_folio() is just a refcount comparison, making sure only the
>>> split caller holds an extra pin. Open code it with
>>> folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
>>> used by folio_ref_freeze(), add folio_cache_references() to calculate it.
>>>
>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    include/linux/huge_mm.h |  1 -
>>>    mm/huge_memory.c        | 43 ++++++++++++++++-------------------------
>>>    mm/vmscan.c             |  3 ++-
>>>    3 files changed, 19 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 97686fb46e30..1ecaeccf39c9 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -369,7 +369,6 @@ enum split_type {
>>>    	SPLIT_TYPE_NON_UNIFORM,
>>>    };
>>>   -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>    int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>    		unsigned int new_order);
>>>    int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index c1f1055165dd..6c821c1c0ac3 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>>>    	}
>>>    }
>>>   -/* Racy check whether the huge page can be split */
>>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>>> -{
>>> -	int extra_pins;
>>> -
>>> -	/* Additional pins from page cache */
>>> -	if (folio_test_anon(folio))
>>> -		extra_pins = folio_test_swapcache(folio) ?
>>> -				folio_nr_pages(folio) : 0;
>>> -	else
>>> -		extra_pins = folio_nr_pages(folio);
>>> -	if (pextra_pins)
>>> -		*pextra_pins = extra_pins;
>>> -	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
>>> -					caller_pins;
>>> -}
>>> -
>>>    static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>>>    {
>>>    	for (; nr_pages; page++, nr_pages--)
>>> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>>    	return 0;
>>>    }
>>>   +/* Number of folio references from the pagecache or the swapcache. */
>>> +static unsigned int folio_cache_references(const struct folio *folio)
>>> +{
>>> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>>> +		return 0;
>>> +	return folio_nr_pages(folio);
>>> +}
>>> +
>>>    static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>>>    					     struct page *split_at, struct xa_state *xas,
>>>    					     struct address_space *mapping, bool do_lru,
>>>    					     struct list_head *list, enum split_type split_type,
>>> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
>>> +					     pgoff_t end, int *nr_shmem_dropped)
>>>    {
>>>    	struct folio *end_folio = folio_next(folio);
>>>    	struct folio *new_folio, *next;
>>>    	int old_order = folio_order(folio);
>>>    	int ret = 0;
>>>    	struct deferred_split *ds_queue;
>>> +	int extra_pins = folio_cache_references(folio);
>>
>> Can we just inline the call do folio_cache_references() and get rid of extra_pins.
>> (which is a bad name either way)
>>
>>
>> if (folio_ref_freeze(folio, folio_cache_references(folio) + 1) {
>>
>>
>> BTW, now that we have this helper, I wonder if we should then also do for
>> clarification on the unfreeze path:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0acdc2f26ee0c..7cbcf61b7971d 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3824,8 +3824,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>                           zone_device_private_split_cb(folio, new_folio);
>>   -                       expected_refs = folio_expected_ref_count(new_folio) + 1;
>> -                       folio_ref_unfreeze(new_folio, expected_refs);
>> +                       folio_ref_unfreeze(new_folio, folio_cache_references(new_folio) + 1);
>>                           if (do_lru)
>>                                  lru_add_split_folio(folio, new_folio, lruvec, list);
>> @@ -3868,8 +3867,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>                   * Otherwise, a parallel folio_try_get() can grab @folio
>>                   * and its caller can see stale page cache entries.
>>                   */
>> -               expected_refs = folio_expected_ref_count(folio) + 1;
>> -               folio_ref_unfreeze(folio, expected_refs);
>> +               folio_ref_unfreeze(folio, folio_cache_references(folio) + 1);
>>                   if (do_lru)
>>                          unlock_page_lruvec(lruvec);
>>
>>
> 
> Both make sense to me. Will make the change.
> 
> By comparing folio_cache_references() with folio_expected_ref_count(),
> one difference is that folio_expected_ref_count() does not give right
> refcount for shmem in swapcache.

Good point. Likely nobody runs into that right now because nobody can 
really does anything with these folios before they were re-added to the 
pagecache or mapped into page tables.

> 
> This is the folio_expected_ref_count() code:
> 
>          if (folio_test_anon(folio)) {
>                  /* One reference per page from the swapcache. */
>                  ref_count += folio_test_swapcache(folio) << order;
>          } else {
>                  /* One reference per page from the pagecache. */
>                  ref_count += !!folio->mapping << order;
>                  /* One reference from PG_private. */
>                  ref_count += folio_test_private(folio);
>          }
> 
> shmem in swapcache mean !folio_test_anon(folio) && folio_test_swapcache(folio).

See below, it's actually

folio_test_anon(folio) && folio_test_swapbacked(folio)&& 
folio_test_swapcache(folio)

I think ...

> The above code gives 0, but folio_cache_references() gives folio_nr_pages(folio).
> It should not cause any issue, since IIUC shmem in swapcache happens
> when the folio has an additional ref,
> folio_expected_ref_count() != folio_ref_count() anyway. For split, it is
> not supported yet, 

Right.

> so folio_expected_ref_count() in split code does not
> affect shmem in swapcache. But folio_expected_ref_count() should be
> fixed, right?

We should better handle it, agreed.

Staring at the history of folio_expected_ref_count() once again, back 
when we had folio_expected_refs() in migration code we didn't seem to 
handle it I think.

-static int folio_expected_refs(struct address_space *mapping,
-               struct folio *folio)
-{
-       int refs = 1;
-       if (!mapping)
-               return refs;
-
-       refs += folio_nr_pages(folio);
-       if (folio_test_private(folio))
-               refs++;
-
-       return refs;
-}


gup.c doesn't care, because the pages are still mapped.

khugepaged.c similarly.

memfd.c doesn't care because the pages are still in the pagecache.

So I suspect nothing is broken, but the migration case needs a second look.

> 
> Like:
> 
>          if (folio_test_anon(folio)) {
>                  /* One reference per page from the swapcache. */
>                  ref_count += folio_test_swapcache(folio) << order;
>          } else {
> 				/* One reference per page from shmem in the swapcache. */
>                  ref_count += folio_test_swapcache(folio) << order;
>                  /* One reference per page from the pagecache. */
>                  ref_count += !!folio->mapping << order;
>                  /* One reference from PG_private. */
>                  ref_count += folio_test_private(folio);
>          }
> 
> or simplified into
> 
>     		if (!folio_test_anon(folio)) {
>                  /* One reference per page from the pagecache. */
>                  ref_count += !!folio->mapping << order;
>                  /* One reference from PG_private. */
>                  ref_count += folio_test_private(folio);
>          }
> 		/* One reference per page from the swapcache (anon or shmem). */
>          ref_count += folio_test_swapcache(folio) << order;
> ?

That is incorrect I think due to swapcache being able to give false 
positives (PG_owner_priv_1).

-- 
Cheers

David

