Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064E7C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E7B6B0098; Thu, 27 Aug 2026 15:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E460D6B0099; Thu, 27 Aug 2026 15:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BBE6B009B; Thu, 27 Aug 2026 15:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E15B6B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:09:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33CDD140173
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:09:50 +0000 (UTC)
X-FDA: 85147988940.22.8CFCB3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 610E340013
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:09:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCK46U9G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmdUPSYR2AcdjAucovMZ8EmnRUeNl7d20UAIuOxbQ8k=;
	b=1W2Sdwl3mGXwTtfhd4g33dc6zkblYTS1lOKi1oGw5XKq9hmGFRUniGirAqQ7JsG2yYSkNy
	ADXHsPF3sun6/ZuAjMHAOqPtvqNCEDMkCGBUXoWUA4YqeQ3Dgk4udbKgTn20SoBn+XoNzj
	ggx1Dv/BC1+b6L6gq0B9X9l9maYe8Yw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCK46U9G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857788;
	b=ZWo+1AcahffSyEf02B2JDGged9tY/x3nNQf0XMKZdlGFkTzpqJrBdDavKlllehAJcSOD2s
	48J4ghMK4iaZat+3k4MVqzrkv8J5BszhxZ9gGo92zhsob/gQHUh3z6cv4+OU7X8EDC6U/g
	psWoDgnuu08eockLWIKJR8H1Ug6cmFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5DED601EF;
	Thu, 27 Aug 2026 19:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3BC1F000E9;
	Thu, 27 Aug 2026 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787857787;
	bh=nmdUPSYR2AcdjAucovMZ8EmnRUeNl7d20UAIuOxbQ8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kCK46U9GJsjgih26JbOgTFvf19ZRvaA3OjLF6t1W7k727EvqR/ZqCyJb9kG92Obs+
	 yDXNJI2yu9tJoCRDRbEb2Scw3GqbPELEJLWdX88Gg01vfACI7Gw20B0U4e8ImItvWb
	 B17FTjV/umV1s3xyAx0tDgRzVczL9U0ae3QU3YXv2/IZMyrLuchaYoAvWwJE264GTV
	 FO9NJqDy8VpRHnBg1UkTx6F3BiEvCBqOPupJOioFmVH0QKrV8t7MpywAbXTnw2GXGn
	 36+paRYqrDvnw5Mxh3EmxpotdMXOq+lVqNuBSSlCoq1x0VWjAdtqCLgRQAiFgPWIyo
	 N78N0439LuNPQ==
Message-ID: <ee4e771a-b8ef-4ffe-9b79-301c22033d5d@kernel.org>
Date: Thu, 27 Aug 2026 21:09:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/18] mm/huge_memory: move unmap and remap into the
 split helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-8-9b43f5163238@tencent.com>
 <a7f16d6b-217e-400e-812a-528493d45134@kernel.org>
 <CAMgjq7Ay3T6BRJ2E1kGD7BNq=4bMMOpw_EKOskM-9im_fjq-MQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7Ay3T6BRJ2E1kGD7BNq=4bMMOpw_EKOskM-9im_fjq-MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 610E340013
X-Stat-Signature: 5b1o9n8jzo8dnd7bqopudfouutf8iw86
X-Rspam-User: 
X-HE-Tag: 1787857788-611803
X-HE-Meta: U2FsdGVkX18KoEuAwQe1ikAsz2CbDbaDvz2gIAFtbPQcQuRrvPbenHg8/IKQ8av0e4XCIHSkxqOh99H0NJ9JniOH+n0LOAvtvsDFLaa5ZZveel6cYlfoKPTDmw8bKBSLxnd8L9wIdLet/8G0CEvDKsvD5YM0irW+gBbS+UwL59QP8FN7J6FaXztG2LhXOpAk2j9rkREIpn+J+pbhZKCH2R50soao4OKsC0bAA2VgIsnQBj29lhgUP6Hem0wqcvs3rr+fcIekynMeu9HEK0+f+Flo40dKuEymHEzHlbC9aMM7y0/vAmGH7bf8DAgeEmfiVrnulX3C9LaTNA5Teb+kMlhrypOzFluchJNagdteBVtGaO97rF0YqkSKsk7B5cuu3U9jThmFQMLV4ogFSRCuDvOFG5n61EyqYNZI2gSPdjS7Uma5MjVjx0WbjzwwB0hXxAy1z5DzWOwokbKxQfmcM6/zQR6vhM1z6EdtBNAM0210uV2+HNSObj8o5ddNd1LC/op3sAI6NWEIaWkm0akaNvgchaYSX59i2A3bxL875Vf3bIUCn9EJkL9be1OB4HRONnXRi0tbY/ykoQRREaDiomnLV4DXpP8al5nD+rafrXhKcx54fkVW8fB0+JXSKkdyXfRgQ1hyShzwl4eiDKOBTrtfjUUV9LllnTf8JWqAe0oKT6RZCJXDzX0FLmO+CYB/JWtSCHNPhJK3gyu22kevDhksjzVJWUWdr8DwIveeFBLHVQiTVL7WM1w+shlDZkauyEtUmMB0mHTjLIxgY03l6fq7G505dNqPdJxBgnc+PYCemaxzP+bHjt0BCVDLCALHuPkjrA6ye5LtbInyH3yVoSUCcXEs2ltZkKAK4Z8dt1RCM0bNl0XrgfJoKHEsgeeYXp/IocPxvxeoHkhqK6hrbeSKZ4pJCaAI3a6RSWyxM6RAqu9U5TqYS5dgilS+mOMYLTu92TJcS4AYpO6dYMG
 GoFIVpiJ
 xBxG85eHxhPXCfu46rHrlDBxchbRXUeiGnEGuuMzUGhRLOLaMdxp7a3cy8sb1C2bW6EaPGHs3SPPO9Hx9Xc0Gf54Et3/ONSC+7RrrujSNKvqaM5H5W0+wbYVK2E6fcLY0px+5F/JZWcbyFV3ifINh3TaqlXLqI9Yo0lOCVp0qhdfNDKrP0GBA+3BzNsagbL/CbfxT1iGxVqyJYH3MP+KQg7nFXrhW3oEXfVynC6qZTraStLcY05iFtHpZi20WEh080gZPpNjYIMzPiJkblgUtmKMctN732lbFyk8o4hUcsnD311qmy/N83JF2mEAoaStOv7xB1Y9t7HgW+8l6tlf5OuUztaAcBRcTYGARLhaHaheXgz+iGVGxAyLzUtpt7A5nyqEhbeiAN44YUU+oKg7AIO1jNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 19:35, Kairui Song wrote:
> On Fri, Aug 28, 2026 at 12:32 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> To prepare for further cleanup, move the unmap/remap handling from
>>> __folio_split() into the split helpers.  Only anon folios need to
>>> be remapped, so remap_page() is now only called for anon splits and
>>> the anon check in remap_page() is redundant and can be removed.
>>
>> I can understand why we would want to move the remap_page().
>>
>> But why the unmap_folio()?
>>
>>>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
>>>  1 file changed, 31 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 01c8cf428595..af9c2edd1fba 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
>>>  {
>>>       int i = 0;
>>>
>>> -     /* If unmap_folio() uses try_to_migrate() on file, remove this check */
>>> -     if (!folio_test_anon(folio))
>>> -             return;
>>>       for (;;) {
>>>               remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>>>               i += folio_nr_pages(folio);
>>
>> I think we should rename that function now to unmap_folio, but likely better
>> unmap_anon_folio().
>>
>>> @@ -3933,19 +3930,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
>>>       return folio_nr_pages(folio);
>>>  }
>>>
>>> -static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
>>> -                                           struct page *split_at, bool do_lru,
>>> -                                           struct list_head *list, enum split_type split_type)
>>> +static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int new_order,
>>> +                                            struct page *split_at, bool do_lru, bool unmap,
>>> +                                            struct list_head *list, enum split_type split_type)
>>>  {
>>>       struct folio *end_folio = folio_next(folio);
>>>       struct swap_cluster_info *ci = NULL;
>>>       struct folio *new_folio, *next;
>>>       int old_order = folio_order(folio);
>>> +     enum ttu_flags ttu_flags = 0;
>>>       struct list_lru_one *lru;
>>>       struct lruvec *lruvec;
>>>       bool dequeue_deferred;
>>>       int ret = 0;
>>>
>>> +     if (unmap)
>>> +             unmap_folio(folio);
>>
>> I really hate that "bool unmap" parameter.
>>
>> folio_split_unmapped() has this VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>>
>> So you can really just do
>>
>> if (folio_mapped())
>>         unmap_folio(folio);
>>
>> Or have an early exit and hide it in unmap_folio().
> 
> The only special case here is device private memory, from folio_split_unmapped.
> 
> Maybe I can just keep the unmap_folfio where it is, but
> __folio_split_unmap_and_freeze_anon need to know if the folio need to
> be remapped.
> 
> Will a "bool remap" parameter look good?

I'd avoid that and rather have something like the following in the function.

if (folio_mapped()) {
	folio_unmapped = true;
	unmap_folio(folio);
}

...

if (folio_unmapped)
	remap_anon_folio(folio)


...

-- 
Cheers,

David

