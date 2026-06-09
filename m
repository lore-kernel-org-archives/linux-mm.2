Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E707CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C770D6B0095; Tue,  9 Jun 2026 04:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E4E6B0096; Tue,  9 Jun 2026 04:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64D96B0098; Tue,  9 Jun 2026 04:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5DD76B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:13:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CA03140475
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:13:51 +0000 (UTC)
X-FDA: 84859660662.13.FCA370D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC10D1C000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:13:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PB6NWsR4;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3/jNBu5N7OCPMcWMcRwgTuxydIWRqWnD8HUI8iOmjs=;
	b=yATnNQeQEaDN8p2S75nqmq9EaPeNWj7J3Jq7+7BVGZXt7t+OiY21IbA97kkkc7781lg40r
	vpTSXwWGUpOInfRROjwUM0kwmiCh3zEyhqjNbmGqmcUNzGv3k5nZMIixbR7xEc0fQ074Qm
	BjjfjhMIZHLwgAhi37rKkkIrhp669+g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PB6NWsR4;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992829;
	b=7p7aWPcIBwB1q93/TGQE+1INDagaaB4nWwSwNU/1V5QcBCjk+dRKP9DGwy+AAm7RMtzwUQ
	rMgdbt5o6RUgb5P3jbzPDfzfzAGgVuURpPPGkcUfd8H5q+FJz57RQh06Aira1ELiygCuBw
	dPqVTZTE7VUdpk+NhZb/BhSJLc0ADlk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2923B601E1;
	Tue,  9 Jun 2026 08:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702151F00893;
	Tue,  9 Jun 2026 08:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780992828;
	bh=F3/jNBu5N7OCPMcWMcRwgTuxydIWRqWnD8HUI8iOmjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PB6NWsR4+oVPktwfSl2DPOt9yWl9YbtkJepNVYv6U7Wjormv0lqP1TJEto6Ojbd8e
	 F8+uBW9J43tW8SI4U62b+6gEkza+rScAxWTLZbJ970WWqbjDcFwEDVS0lmbTyV/Goz
	 CMVlyoEz+l9WK8j9o6W6ME9gY6eMVVn5YIIukI7T+mUL3TZs+FlVszUuvYtEE7lrA2
	 a5xVkN2hKvFI7UKhH93mv/WT5DXi706A+Ro0syhpvXHuMwDiBKQBFs/Bz10A0eegAC
	 tcQ3y/AEa/o/p5rwIFarRgGv4n9wk9RupiImfc3gP+dg37RmbobFwYh3X5GC4KGFfJ
	 TJm6NmAUjb9zQ==
Message-ID: <da818e2b-f6c0-47cc-a9a7-472500151315@kernel.org>
Date: Tue, 9 Jun 2026 10:13:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] ksm: Optimize rmap_walk_ksm by passing a suitable
 page index
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260609124703736MQ6Jkpc_7wR7HaeDDPk6k@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609124703736MQ6Jkpc_7wR7HaeDDPk6k@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC10D1C000D
X-Stat-Signature: 5t1zfr9f7s3kmr3679xiy4qthjdbwo89
X-Rspam-User: 
X-HE-Tag: 1780992829-448183
X-HE-Meta: U2FsdGVkX19flmUL04mQHnNQcO6wMoTC8qmO4OqJVsQM60UG253ANbRYS11iMa9PkjOXcnmCcyHwbFRTCi6xWh+ZAJIkZFUS26D+V6iStD+dmkWYvooJMSbFxRggQAfTqPzgERqpO7b2m4EQo5LPuD+QnQlIi/ZMhh2hpY/zcTDdYxo2SoXQlrvCyzQKYsLkqCEEjRksI38V5Jan4E8+g7NQYc0siV6SiBelxT5fdu48IMjPxllgLB4Pg7exQTVlTBj6TUpetohUwHJQ1ZKBHpXuwuh+bAwr1fTYUSRLxFRcZWflBF/D1gkaivpMMD6Df3a2pO15RHsGAaFiKK/QfLYyMKNs3OsjjH1HWDN8D1qIHc8QBsFV+rmT/gtRoe6oDv2xroOEVpkOrWnnOBZrYZu2TtusZvcDe+B0Krk05nThhK4DrEGlID396H6DXZ5HeGyAiZJUCx4ifcuyliZZYiDh7HSSYDrfRhuyZ+zoSigbDPXQf8JjdZ2dTGM7lIDBg8U3yqxsh1A8h6jvqGCOU9SZNW9DuM55s8UorZRffdsJYzi+MdcRsA0Ne4u5LuYw4kFgC/IpRZDi3VvQAX/2vrS1TOcSSu/HjH2YuLBPm/UiZSSfUWOTxIjQhUC9ngdqyrtlX+imDkJLvZSmdzDOaK8tlLNkiQdeNhGbb6//5RAqIovbbAr9ebVzVnd5HSjgicKe1iqiq9IvKSQB5dgjtEH9z3AQoKLYzk3anlj2BCPZFlFJwvSpspiYeUIvlmFd2n1k9Av1KxdaqXLf4dXY/w+2dLOSMfgK0BxefRXMLJ6IBkqpNjDYl1j998pyecR4D6IOdLwFpqTqZckGQ7BZt6ZIzPrz+TBI2URQNQoCzWxtmee9x1QnsVMKekiYttMEedJiY7jojpj9dX6zj1De4/0jLmQrQvC8PV7tmoehjmjbipTASZWN2SOiB43IukeDVF3lmotudAD61fWqhH+
 E8CoKQ/W
 /G45qaGDbxsNHWAz3yCkV2w0u2yp3nB3/GqXzNforz8K7fKa3tzCcDKQZO2w3avCCRHljOYpumgpmIogUyFbteHB2rqSp2arzFuxZvxHMTQxHNjzp4wY01NaKEyr3gRlu9FROiNc4FkfM+sbkN6Cq2g4fGRSmtg7vl/+BEycXm6Jb9QKUM6x9d5SobzvyXLqd1tPinJUIdRT2xyOZ2eYVtvAW4wZjJ7WeDK/dScIEmhw7rQAMh/ArVgXfn+L3u1hcmBuHApcF5P+Ko8mrUKiyXT1rTVgviQ5l5ARLp0Dlg+SF9h8bvWnsNRJaceejg1gPKaauDryxC6rwjgP3q0/RJ7kDvJ/vjHGRQlu0gfgjmhraxl6IQjqBlqowmHRH4gRaDOHRy59LmAcUUixW7Kx9mepOpy+G72GaTwHg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 06:47, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> User impact / Why this matters to Linux users
> =============================================
> When a system runs with KSM enabled and memory becomes tight, KSM pages
> may be swapped out or migrated. The kernel then performs a reverse map
> walk by rmap_walk_ksm to locate all page table entries that reference
> these pages. If A large number of unrelated VMAs can attach to a single
> anon_vma related with this KSM page, then rmap_walk might be severe
> performance bottleneck.  In our embedded test environment, we observed
> ~20,000 VMAs sharing one anon_vma without any fork – purely from VMA
> splits， which cause 200~700ms duration of rmap_walk_ksm.
> 
> When one of those VMAs mapped a KSM page, then this KSM page's rmapping
> will become bottleneck with hold its anon_vma lock for a long time. The
> anon_vma lock is not only used by KSM; it is a core lock protecting the
> VMA interval tree and is acquired by many critical memory operations:
> 
>   • Page faults: do_anonymous_page(), do_wp_page() (during COW)
>   • Memory reclaim: try_to_unmap()
>   • Page migration & compaction: migrate_pages(), compact_zone()
>   • mlock / munlock: mlock_fixup()
>   • Process exit: exit_mmap() (tearing down VMAs)
>   • Cgroup memory accounting: mem_cgroup_move_charge()
> 
> If one thread holds the anon_vma lock for hundreds of milliseconds
> because of an inefficient KSM rmap walk, any other thread that tries to
> acquire the same lock (e.g., an application taking a page fault, kswapd
> reclaiming pages, or a migration thread) will block.  This leads to
> stalled application threads, increased latency spikes, and in extreme
> cases container timeouts or watchdog triggers.
> 
> This patch reduces the worst-case anon_vma lock hold time during KSM
> rmap walk from >500 ms to <1 ms, thereby almost eliminating this
> source of lock contention and improving system responsiveness under
> memory pressure.
> 
> Real-world examples:
> ====================
>  - JVM / Go runtime: These use mmap for heap regions and later call
> mprotect(PROT_NONE) for garbage collection barriers or guard pages,
> splitting the original VMA into thousands of small pieces over time.
> 
>  - Database engines (MySQL, PostgreSQL): Large shared memory buffers
> or anonymous mappings are managed with madvise(MADV_DONTNEED) to
> release specific pages, which also splits VMAs.
> 
> * Why the benchmark numbers are realistic: We observed ~20,000 VMAs

The "*" at the start looks odd (the list above used "-", and I assume this
should be separate from the list).

> sharing one anon_vma on a production system running a Java application
> with KSM enabled. The lock hold time before the patch was measured at
> 228 ms (max) during rmap walks triggered by memory compaction and page
> migration. The benchmark reproduces that VMA count and lock‑hold
> behavior in a controlled environment.
> 
> Root Cause
> ==========
> Through local debugging trace analysis, we found that most of the latency
> of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach(), leading
> to an excessively long hold time on the anon_vma lock (even reaching 500ms
> or more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the start page index and the end page index parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> We cannot rely solely on anon_vma to locate all PTEs mapping this page
> but also need to have the original page's linear_page_index. Since the
> implementation of anon_vma_interval_tree_foreach — it essentially
> iterates to find a suitable VMA such that the provided page index falls
> within the candidate's vm_pgoff range.
> 
> vm_pgoff <= original linear page offset <= (vm_pgoff + vma_pages(v) - 1)
> 
> Fortunately, we have already linear_page_index. in ksm_rmap_item in the

Misplaced "."

> previos patch of series, so that we use it to get the index to accelerate
> the searching.

Avoid talking a about "previous patch" in a series. Something like:

"Fortunately, an earlier commit introduced the linear_page_index to struct
ksm_rmap_item, allowing for optimizing the RMAP walk."

> 
> Test results
> ============
> A rmap testbench can be obtained with two Out-Of-Tree patches at [1][2].
> After applying the OOT patches and building rmap_benchmark from:
> tools/testing/rmap/rmap_benchmark.c, we can start the performance test.
> 
> The testing result in QEMU is shown as follows:
> 
> KSM rmapping	Maximum duration		Average duration
> 
> Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
> After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)
> 
> [1] https://lore.kernel.org/all/202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn
> [2] https://lore.kernel.org/all/20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn/
> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/ksm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index e0ba29e3c0a4..9e1879d96751 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3208,6 +3208,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>  		/* Ignore the stable/unstable/sqnr flags */
>  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> +		const unsigned long index = rmap_item->linear_page_index;

remove_rmap_item_from_tree() does the hlist_del(&rmap_item->hlist); once we
clear STABLE_FLAG + rmap_item->linear_page_index.

So, this should always be valid (just like rmap_item->anon_vma). Good.

>  		struct anon_vma *anon_vma = rmap_item->anon_vma;
>  		struct anon_vma_chain *vmac;
>  		struct vm_area_struct *vma;
> @@ -3221,8 +3222,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  			anon_vma_lock_read(anon_vma);
>  		}
> 
> +		/*
> +		 * Currently KSM folios are order-0 normal pages, so the end
> +		 * page's index should be the same as the start page's index.

Maybe best to say "Currently, KSM folios are always small folios, so it's
sufficient to search for a single page."

I don't even want to imagine how large-folio support could look like, and how it
interacts with rmap_items :/ Let's hope we'll never have to go there, and if so,
this code here will be the least of our concerns.

Do we want to explain a bit how this works and on which properties this relies on?

"We can simply use the linear_page_index of the de-duplicated anonymous page
that we remembered in the rmap_item while de-duplicating. Note that
mremap() always de-duplicates KSM folios: so if there was mremap() in our parent
or our child, we wouldn't have the KSM folio mapped in these processes anymore."

> +		 */
>  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> -					       0, ULONG_MAX) {
> +					       index, index) {
> 
>  			cond_resched();
>  			vma = vmac->vma;

I hope we're not missing some other weird corner cases. Sashiko seems to be
happy, but I don't trust that ;)

Hoping other people can also give this another look before we move this upstream.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

