Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13B1CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DCD6B0005; Wed, 10 Jun 2026 08:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EA96B0088; Wed, 10 Jun 2026 08:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F6E6B008A; Wed, 10 Jun 2026 08:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D66A66B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:50:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F496C1CE0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:50:23 +0000 (UTC)
X-FDA: 84863986326.01.7937049
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6CD2F1C000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:50:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcwyUptX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781095821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0M+Qgy/sOeq59mcTqkZkDfQ6T/hhXMWDMAVnwKiAVOo=;
	b=7PtezAYqY0RM4HB4n6y6u+shslGRlSLfYj+thbBdFKOjDhSKRq0IIo7BArY8AJX88Cn0en
	nvO5Fs4XPWcZezrdLc85LKURcIPFl73MEslDaEC0/kCB3j4RuQ7qIaxdmL59xIHgPrEanb
	N15vcEWZJZjsExtcP0VfQAPQGpK/uH0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcwyUptX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781095821;
	b=7tS0Vq4y3dvNGqSDqhzh9PF1gMxPOUhlk0Ypc2kNtc89AszZIW7lMA8i7LvtO89uOhm0dE
	I3qy6yIGQD1Gm++NlKRO01XMPMKd9hSz+cm+y8F/mdtYDDzHesl2QAr+L9l9yzMHJzVayI
	cJqqFxKwu00GSfIDkHPDwqCF9fLcg2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72DA1436AB;
	Wed, 10 Jun 2026 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1941F00893;
	Wed, 10 Jun 2026 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781095820;
	bh=0M+Qgy/sOeq59mcTqkZkDfQ6T/hhXMWDMAVnwKiAVOo=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=AcwyUptXAVKDgs7dDfJTMdatj89P6udKIskCQOwGquK4q/Bb2n5AeCS9JM7oiy047
	 0T3hNszhKr6bpkffyXNCRzbiwB8BRYNIZihhOM2BikRKIyfIbLxqaUDWYKO8m2FTlH
	 LVFLU3PaFcncbrHe51ORYaTMU4Dq21A5ZAZ8TQfw2tlN60Ja3yf83yyYAsvBVzsXIp
	 T/d81/f5CO4rJo39/iiVy0fY9eiNlG6rG+7qWAqgimCikVT9qVjGHKdd5/spCWhoc/
	 46uTdp32r5WBZE65FqnuBrcxth2lkcPSDQsmGaqdI66325OirtFyuhiZG0me0L0jTY
	 PQN/ddtO3Q8eg==
Message-ID: <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
Date: Wed, 10 Jun 2026 14:50:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song
 <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6CD2F1C000D
X-Stat-Signature: 39irxt4crgk7yu7qe7ik95iyokauepyk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781095821-76094
X-HE-Meta: U2FsdGVkX1+UU+xNwzjWKwPO4qhpzjpZ5BJoNAE40uGQSTsgrU4KJg6j00a/CQlN/r/vM13nP7CiIyChu6qwxaf1y8Qa7mtd6sGLEs0bi15bLH/82vTQj7UDp5ibl7AXCt1XtbVLkQgniOwMcxm0+BILQfXmEp6jCnFiJfxgLmuPSFR9T4ke/ZbxX1tGFHmeH4TAzAPFyUvaX8WBxlbkWERvxSjN4eauG4KzR0KBICsHhxtXagUVvhwUGMC9Zpyp6JpiTP/oId15jfSEvNy7gKc2FExkiwDFmOeQh430ZewkrmL6N5slAmNTwHd44gbqDvSSwAF1JmIaT4KowwrTyyB9VjyshHdP8ItM9w2G9qNBR8598XeTD3pxmhlOx8IQI7k645s7LWPQlr/y0Gqg/bgMgZR1ZNcGbPwKk0G5i9vgHy1RqikFxNqPTy7x4WcY9n3h/GxWptDHRO5E0ROKrrFTGAoAs5uU/c8yYhZBbqVjoCisQorsg/nvXTvlhpEk62FZgh7TqaEpe8iMr6xvGzxCPFH3PZGivgXkfdfLlWhYgBasdh4geeRd0jTHvdvIgJQo94YlujndadKMqXJVFiySVpiTSDwYnFoNRYxNNpS+SsSxo2q+tSv4o4JZIdAm2s3XLP+EFkWYYgcdWMHb7AJZ0AeTD/yuU8e3AqYWHz1KnVDBJn6tiiDr81/j40EHOqo6ZGr2nqXZ3J8tzx+2DlZ0lvHm7G9TBQ+OZIM4tRSYxSUJLPHK+zcRpcSgT+zeby6+Ptmm18IapGvkSVcikDRpJzb9MnezySSerneNeRy0yqWkgrMe1pU61fbb+wEB3ZXD9D8u1q1BlfTR1//PwnK5vLEMh7t7wCFHa9EgcbiIKXB4+ykfVyf9xuCRD7We2KNHGVNJNh7Phne3P+3a+NOzQISkpU5GjOin4DlFWCk52m9q8Ff3mYmoN/FAmMNjWAsKQlmo/kk/kd+h1OE
 QaHREVHb
 6UoskJofh3n9o6UNuF+YPvgK1ezElqCNopKx3ygjzbhg9y+MChicCGEk7jQoZcELUxQVCWBrjbQesV1l9Ax1EdY+YOqxNBw+5Xq73nMOXwcwsuoyBOHQIhbBsezJsvgO5/b7d6cID9sEcAb8XhX6iPqFL6rdmEzJZV5PKyXfFOUeoJZGg3ipzKQjOBu/kxWPsWelfW61bIfo9fIZDSGb46vidgUvgqbb4RK95yCaK0Oudsu7gdJ83BwMXxMLZdriXpvWVR5Z7TGXeRhlh2cEqovOyiKfeltKvaqlGW9R0K946oUqYU838CPYzpVtJ3ElTiwb9PRracj8DXw8rXhSWERyb+B+7RPGJ2ezfff4hXm72/yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 14:05, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The kernel panics are keeping to be reported especially when the f2fs
> partition get almost full. By investigation, we find that the reason is
> one f2fs page got freed to buddy without being deleted from LRU and the
> root cause is the race happened in [2] which is enrolled by this commit.
> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: remove
> non-uptodate folio from the page cache in move_data_block").

But I assume, that other FSes can trigger this as well? Any insights?

> 
> There are 3 race processes in this scenario, please find below for their
> main activities. However, by further investigation over the code, I
> think there is a common race window for the truncated folios between
> split_folio_to_order and folio_isolate_lru, where the folios lost the
> refcount on page cache and remains the transient one of the split
> caller, under which the folio could enter free path and compete with the
> isolation process. This commit would like to suggest to have the folios
> beyond EOF stay out of LRU.
> 
> Truncate:
> The changed code in move_data_block() lets the GC path evict the tail-end
> folio from the page cache through folio_end_dropbehind().  Once
> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> page-cache references for all pages in the folio are dropped.  The folio
> is then kept alive only by temporary external references, which allows a
> later split to operate on a folio whose subpages are no longer protected
> by page-cache references.
> 
> Split:
> After the page-cache references are gone, split_folio_to_order() can
> split the big folio into individual pages and put the resulting subpages
> back on the LRU.  For tail pages beyond EOF, split removes them from the
> page cache and drops their page-cache references.  A tail page can then
> remain on the LRU with PG_lru set while holding only the split caller's
> temporary reference.  When free_folio_and_swap_cache() drops that final
> reference, the page enters the final folio_put() release path.
> 
> Isolate:
> In parallel, folio_isolate_lru() can observe the same tail page with a
> non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
> reference.  If this races with the final folio_put() from the split path,
> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
> The page is then freed back to the allocator while its lru links are
> still present in the LRU list.  A later LRU operation on a neighboring
> page detects the stale link and reports list corruption.

Complicated mess :(

So, folio_isolate_lru() really only requires the caller to hold a folio
reference, which can happen given that we did the folio_ref_unfreeze(). It can,
for example, be triggered by memory offlining or page migration.

So we really want to not allow folio_isolate_lru() while we are still processing
the folio.

What your patch does is, simply not add folios that we will drop from the page
cache to the LRU?


You should describe here how you are fixing it: "Let's fix it by..."

> 
> [1]
> [   22.486082] list_del corruption. next->prev should be fffffffec10e0ac8, but was dead000000000122. (next=fffffffec10e0a88)
> [   22.486130] ------------[ cut here ]------------
> [   22.486134] kernel BUG at lib/list_debug.c:67!
> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   22.488502] Tainted: [W]=WARN, [O]=OOT_MODULE
> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488539] sp : ffffffc08006b830
> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000000000000
> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffffec10e0ac0
> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000000000122
> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc080061060
> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000000000058
> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000000000003
> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85721f0e25f00
> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645f7473696c
> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000000000010
> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000006d
> [   22.488647] Call trace:
> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> [   22.488661]  __folio_put+0x2bc/0x434
> [   22.488670]  folio_put+0x28/0x58
> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> [   22.488689]  f2fs_gc+0x230/0x9b4
> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> [   22.488725]  invoke_syscall+0x58/0xe4
> [   22.488732]  do_el0_svc+0x48/0xdc
> [   22.488739]  el0_svc+0x3c/0x98
> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> 
> [2]
> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)
> 
> F: pagecache refs = n
> F: extra refs = GC + split
> F: PG_lru set
> move_data_block()
> folio = f2fs_grab_cache_folio(F)
> ...
> __folio_set_dropbehind(F)
> folio_unlock(F)
> folio_end_dropbehind(F)
>   folio_unmap_invalidate(F)
>     __filemap_remove_folio(F)
>     folio_put_refs(F, n)
> folio_put(F)
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)
>                               ...
>                               lru_add_split_folio(T)
>                                 list_add_tail(&T->lru, &F->lru)
>                                 folio_set_lru(T)
>                               __filemap_remove_folio(T)
>                               folio_put_refs(T, 1)
>                               /* T refcount == 1, PageLRU set */
>                             free_folio_and_swap_cache(T)
>                               folio_put(T)
>                                 /* refcount: 1 -> 0 */
>                                                                   folio_isolate_lru(T)
>                                                                     folio_test_clear_lru(T)
>                                 __folio_put(T)
>                                   __page_cache_release(T)
>                                     folio_test_lru(T) == false
>                                     /* skip lruvec_del_folio(T) */
>                                   free_frozen_pages(T)
>                                                                   folio_get(T)
>                                                                   lruvec_del_folio(T)
> later:
>   list_del(adjacent->lru)
>     next == &T->lru
>     next->prev == LIST_POISON / PCP freelist
>     BUG
> 
> Assisted-by: Cursor:claude-opus-4-8
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

I'm wondering if this has been broken the whole time, or if some rework allowed
this to trigger.

I assume the issue can be triggered for other FSes, and we want Fixes: + CC: stable?

Looking into the history, I think we always unconditionally did the
lru_add_split_folio()/lru_add_page_tail().

> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..7465525a94a8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  			folio_ref_unfreeze(new_folio,
>  					   folio_cache_ref_count(new_folio) + 1);
>  
> -			if (do_lru)
> +			if (do_lru && !(mapping && new_folio->index >= end))

It might be clearer to write this as

	do_lru && (!mapping || new_folio->index < end)

To match the page-cache check further below

	if (!mapping)
		continue

	...
	if (new_folio->index < end)
		...

>  				lru_add_split_folio(folio, new_folio, lruvec, list);
>  
>  			/*

folio_check_splittable() makes sure that we have a mapping for non-anon folios.
(no truncation). end is then only set for non-anon folios.

@Zi, any thoughts?

-- 
Cheers,

David

