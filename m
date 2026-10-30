Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB4F606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Phsnf3OJ
Received: by kanga.kvack.org (Postfix)
	id 155F96B05B6; Fri, 30 Oct 2026 06:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DD16B05B7; Fri, 30 Oct 2026 06:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043036B05B8; Fri, 30 Oct 2026 06:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C43E06B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:19:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BA3E160571
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:19:18 +0000 (UTC)
X-FDA: 85378895196.03.2151CCD
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F3DA20002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:19:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Phsnf3OJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UyhghDqbkh6Fs4bKf9cC/vT2//GoTRNOpMJ8SvItkI=;
	b=Vonm0nFfm65OHu30teYoR+ZamvZy36dL4TOY6lazQ2+qnWUBdRRtkG+qjPqR11IBz6j1c0
	H7/eQ5DpUI5bqzxicMlWjYFSeVxOMGzHGUN2XjEATnhoE5P0BGFEVV5dF7r7cjzhRVXoNe
	KmnVJhROtWVz5M3t4K7cwhk7O0XVeMk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Phsnf3OJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355556;
	b=F42i2aev6ANho/UysTR14YdAVWs+25IK99vq08j9pnOvLy/UnRzIASyfAVvOLPduKsVPxP
	zYFbxSAuzPGuuRh/maJ97Ax6CL43p5tlEpE/DUpEcckZTYLLugUY4eKfDWFUJg9Z97zn8n
	/5jBuQtDEinA6A5DEiMnvUjZm85rjfE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2h88SG0HENwuhHsaFHjwKEoGobN7MhTMT5AdNQYTdWM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793355551; v=1; x=1793960351;
 b=Phsnf3OJA12Yb93IF69DCa72LskXapSWk35l29hO5xHgsrvXVCidMhaDo84fxQiDsUgDzLuq
 MmMv1DgwoBH6UiFa5Qo5VgKUE4JJ8trRT2D5EPcFDamxOqjyP8ggOHwfdsGIVgRXWgDuRTKQZuJ
 aYjx+KfkUijH7SB4nPvWAAgA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 67ac1b4e1752f144;
	Fri, 30 Oct 2026 10:19:11 +0000
X-Mizu-Trace-ID: 67ac1b4e1752f144
X-Migadu-Flow: FLOW_OUT
Message-ID: <3ae9717b-ed65-426e-b06f-e25e7c2fb5f9@linux.dev>
Date: Fri, 30 Oct 2026 18:18:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: linux-mm@kvack.org, Kairui Song <ryncsn@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261014090821.227366-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F3DA20002
X-Stat-Signature: 9gwps6xntczxt734iiydybwm9gxiqhxu
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793355555-781608
X-HE-Meta: U2FsdGVkX187Uc0IUEE/8ku+v52tkrS2KZsOR84YrnTBWlq8p3Xw93bP+IYFqYMe9VMdAlJg3AZ/M95utihBrp/Ci+AnqZabrIwD9NEmMQHTLVToNoeMcUze5N/fPR36F2asDKaChJ0Jf+TBQ3aF1fD0eElqZeRunUNt0ejx+YXMnJqv+gRIYCtE6cxknWiWJ27fYI5MkF/puGaF/9gBPB6iyrcDnA4y2sxnPptr2uwDj55OZIubrmOPeaUFpsvhfdDyiYat210WzH89UK0Ijpzhr6wODI2ayAkqfktlVkrEd/NivIejSZcSDrlykvE7X1YIxnCvRYaJOEOFigiVM78hDFDCDFhfofhhdouZ1zGkQptK2rC0h08VgdWmmmu7pU9MtqJpWvyV5V0Yw9yqsjCk5REUApW2Rovy26BCs2QUWl9SbLjX+cZGuJDgA7lPD6v9UD7FFCFSalCeYDYltaOMbsBKkcCYGQiHNqXGF/l3ZPMnfFz5gtrUT5tYW3QhFQso5ryvifoxehwehqIncIUm6Zwutlma1Py4vmgIL+7wUgq7MzuZqN+L1+WUYlUuE7bA9XzCHEsys0W0TIcllC+4VoM4T0JcZOhv0+qQWrwAxDcdm/p6gh1wv8Wllli0bDnPp8qpAZdNAkj9tPjQgSXykCWXLp2VGp+ZPA/MR8uuKQubUuaJjA08vyBMrQ+i65AVqg3VZwxMqeeT8g8om2tOxklCFrE9CjoNLb94K/NQx3t71jcUKobM0iPFMk44vkrbQv8ZztvUegYfNP6EpsRIbn52nITHcTcVMDnpt39/E0+KUtH6iIVOFl4/Nw/Eu/NmCd2HWwXi1h7XF8PnRXWrVdgvM7aT470u8WiBp4kVBkd5UGFJPSQriwkNLT5HM+TnG6gEwt9GIHYTgTk7+aYV+0sikRc+5KXFYHGFyIhq2bRQmXaNhTpiHQ7EVEz1fcOwhsijhONhHh+plPb
 ogz4OIUo
 CU+g42iM9NHxqtJYvWxYcOFnnYK+6n+xwyH3ZmBFSidJ68oj8loQE89n41VLn+BMdTCAvNmn2JKObcTDF9A8SY32/khFwIYKqeP0s4XTPdrOzIhQcfJA8exf8/2S+vtlazuQO6wK8bCYTwymbDXAwyHa8WXpX3Ho7FDu7e/YcFHrJPS0fJtNr8596fdiTai008HanLSdWJmmLmPl4t9T6uIkGrFaw0+LIrJM3OCMIXpwRTBag+mi+OFT8DAAB8L1nkUpzBHJ+W8kP9mwp18K3HeRXdnEYDM8mNeoe71E1FFmbHGoxqHpHFm4KJ/HvyDGTrCBSuDdzRC7fv6jHx3xGgoZc7YjWsaQb9I7/Zi4TAfIJLI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/14/26 5:08 PM, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> On our production hosts we saw swap cache only pages keep growing for days:
> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> swap slots were held by folios that no process mapped any more, charged
> to cgroups whose workloads had long exited. The only way to get them
> back was swapoff, and with other services actively swapping on the
> same host that is not an option.
>
> Such a slot has swap count 0 and an unmapped folio pinned in the swap
> cache, left there after a process exited or did MADV_DONTNEED. No page
> table holds its swap entry any more, so nothing comes back for the
> slot; LRU reclaim drops it eventually, and the allocator only reclaims
> such slots once swap is half full. The growth stopped exactly there:
> at 50% of the device, where vm_swap_full() becomes true.
>
> The race is readahead against a zap in a neighbouring thread. Readahead
> works on virtual addresses, so a fault at the end of thread A's range
> pulls in the entries at the start of thread B's range:
>
>    thread A                               thread B
>    do_swap_page()
>      swap_vma_readahead()
>        swap_cache_read_folio(B's entry)
>          folio locked, added to cache
>          swap_read_folio()                MADV_DONTNEED
>            zswap_load() / bio in flight     zap_nonpresent_ptes()
>            .                                  swap_put_entries_cluster()
>            .                                    swap count 1 -> 0
>            .                                    __try_to_reclaim_swap()
>            .                                      folio_trylock() fails
>            .                                      gives up
>            folio_unlock()
>        folio_put()
>    -> slot: swap count 0, folio in swap cache, not mapped, never freed
>
> The lock is one reason it gives up. The other is writeback: with a block
> device as backing store, B's own PAGEOUT leaves the folio in the swap
> cache under writeback, and when the DONTNEED comes __try_to_reclaim_swap()
> gets the lock but folio_swapcache_freeable() refuses. The write
> completes, nobody frees the slot. The present-PTE side has the same two
> outcomes through free_swap_cache().
>
> Options considered:
>
> 1. Fix it on the readahead side: after the read, check the swap count
>     and free the slot. Covers the lock, not writeback, and the
>     asynchronous read path unlocks in the bio completion where the slot
>     cannot be freed. Two places to patch, neither clean.
> 2. swapoff/swapon clears it, as does memory.reclaim on the right cgroup.
>     That is a workaround, not a fix.
> 3. Have the side that gives up come back later. This patch.
>
> The zap runs under the PTL and the fault path takes the folio lock
> before the PTL, so waiting there is out; a worker has to do it. On a
> lost trylock or a writeback refusal under TTRS_UNMAPPED,
> __try_to_reclaim_swap() schedules si->sweep_work. The worker walks the
> in-use clusters and, for every slot with swap count 0 whose folio is
> unmapped, calls __try_to_reclaim_swap() with TTRS_WAIT, which takes the
> folio lock and waits for writeback instead of giving up.
> free_swap_cache() now calls __try_to_reclaim_swap() as well, so both
> paths give up, and wake the worker, in the same place.
>
> For now the worker scans every in-use cluster of the device; marking
> the clusters that need it can reduce that later.
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>   include/linux/swap.h |   1 +
>   mm/swap.h            |   1 +
>   mm/swap_state.c      |   9 ++--
>   mm/swapfile.c        | 101 ++++++++++++++++++++++++++++++++++++++++++-
>   4 files changed, 104 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..5777f10e9aa4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -267,6 +267,7 @@ struct swap_info_struct {
>   					 */
>   	struct work_struct discard_work; /* discard worker */
>   	struct work_struct reclaim_work; /* reclaim worker */
> +	struct work_struct sweep_work;	/* frees swap cache only slots a zap gave up on */
>   	struct list_head discard_clusters; /* discard clusters list */
>   	struct plist_node avail_list;   /* entry in swap_avail_head */
>   	const struct swap_ops *ops;
> diff --git a/mm/swap.h b/mm/swap.h
> index d5bf21f517dc..f62f36c0ce5c 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -309,6 +309,7 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
>    * - See the comment of get_swap_device() for more complex usage.
>    */
>   bool swap_cache_has_folio(swp_entry_t entry);
> +void swap_reclaim_entry(swp_entry_t entry);
>   struct folio *swap_cache_get_folio(swp_entry_t entry);
>   void *swap_cache_get_shadow(swp_entry_t entry);
>   void swap_cache_del_folio(struct folio *folio);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ebef568cd62e..99708f149b25 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -598,16 +598,13 @@ void swap_writeback_dropbehind_folio(struct folio *folio)
>    *
>    * Its ok to check the swapcache flag without the folio lock
>    * here because we are going to recheck again inside
> - * folio_free_swap() _with_ the lock.
> + * __try_to_reclaim_swap() _with_ the lock.
>    * 					- Marcelo
>    */
>   void free_swap_cache(struct folio *folio)
>   {
> -	if (folio_test_swapcache(folio) && !folio_mapped(folio) &&
> -	    folio_trylock(folio)) {
> -		folio_free_swap(folio);
> -		folio_unlock(folio);
> -	}
> +	if (folio_test_swapcache(folio) && !folio_mapped(folio))
> +		swap_reclaim_entry(folio->swap);
>   }
>   



I spent some more time on this and I'm not happy with any of the
options I have. Advice welcome.

   1. Trigger the worker where the zap gives up (this patch). On the
      swap entry side that works, __try_to_reclaim_swap() has the si.
      On the present PTE side it doesn't: free_swap_cache() lost the
      trylock, so it can't read folio->swap to find the si, as Kairui
      pointed out. And that trylock-and-give-up is not in one place,
      free_swap_cache(), do_wp_page() and __uprobe_write() all have
      their own copy. Chasing every one of them doesn't feel right.

   2. Clean up at memcg offline. Doesn't cover the root cgroup or a
      cgroup that stays alive, and on mm-new the folios are reparented
      at offline anyway, so there is nothing left to find there.

   3. A swapon flag, say --clean-cache, that enables the cleanup.
      Pro: covers everything, and the cleanup can live in its own
      function without touching the existing paths. Con: we know to
      turn it on because we hit this, others won't. Needs util-linux
      too.

   4. A per-device worker that walks the device on its own, say 1024
      clusters per second, backing off when a pass finds nothing.
      Pro: same as 3, and nothing to turn on. Con: a worker that wakes
      up on its own for this, I expect objections.

   5. A sysctl (or a drop_caches bit) to kick the cleanup by hand.
      Pro: same as 4, all in the worker. Con: same as 3, someone has
      to know to poke it.


