Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D335F3C246
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00626B0088; Mon,  9 Mar 2026 08:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADE26B0089; Mon,  9 Mar 2026 08:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA0E6B008A; Mon,  9 Mar 2026 08:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78F0C6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:29:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27D0816013E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:29:50 +0000 (UTC)
X-FDA: 84526456140.16.70F92B5
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 52E3D40005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:29:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giJ6uyzb;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773059388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRTUY7L1+zfWa7FrKj8m+lxFggj9JT5Y8hyCI1P5DCw=;
	b=8EHNKW5KmtObHhnXiDFhvNqQTXcJGVBDDHSaGEYdMXvZYvJ5D1yO/sYUjJEQ8Cn/xa2N+4
	fefyHmhb9eDqZzlLzJXIERhFtPkPHtk4kKrtYyOGOQ0NAQ/e/grecIxOyGkQH8nAAbwS9n
	h6MUwSuMBQynueW9Yj2Di0A/2aiaQ6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773059388; a=rsa-sha256;
	cv=none;
	b=VXbK+WuEt3Rq9U2BmOK+oKoItsk0HL25sIOdJHZWplMp4fFLzffLWrLYP5aM1zwj+6MjuU
	kxmwpACoi/XztezIPwZRAKBNV38wghoT5i7pnKrbDriN43tqRhcxxPN7ZqPjmGP9cVIcyr
	uOFREZI6HJH9M4QpGPBGWteB8zWNajQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giJ6uyzb;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773059386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bRTUY7L1+zfWa7FrKj8m+lxFggj9JT5Y8hyCI1P5DCw=;
	b=giJ6uyzbaCw5mgUDlmB4+C7sCrdwGCRJa2mfqVGMVsnsSJXO2BCpB/b9xU7pfUMJ30TVZL
	1u7uiqGCCO5CMeP3QoikMUqr0YlrgpIBY/c/zexzFcK+c1G503fPPPO439bpbK8yNn/vWo
	DxnFfBvabP0q5vjQY/JE5vbOsUtpGyE=
From: Usama Arif <usama.arif@linux.dev>
To: Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>
Subject: Re: [PATCH 2/2] mm, vmscan: flush TLB for every 31 folios evictions
Date: Mon,  9 Mar 2026 05:29:38 -0700
Message-ID: <20260309122939.723610-1-usama.arif@linux.dev>
In-Reply-To: <20260309-batch-tlb-flush-v1-2-eb8fed7d1a9e@icloud.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52E3D40005
X-Stat-Signature: 9rjdd56pk1zu8p3bgza4tt8rqcwsfn43
X-HE-Tag: 1773059388-652432
X-HE-Meta: U2FsdGVkX1/px6K7r7VtAWxjT3TZ8tcXViX1bzl/50q6DFBdNFlfFIoAf3ykzWExWYEW4My8j4NpDnRJDumOmkqrdCV6z059SuETL0LrmhXQ/8k0g4oIvEP6rdYddyKBBzura3tallBfMPf2mEFElanVD2SwtWrkZnKj6yq3U4cSyIb3A80RZT66YTV7IGf4SqLFMtJBYFztr1xTi0xLimO2SM7LeRQtaxuz1aw/8Fki7BauSdERG9Iy3gC8qLtTocQeooQ1tQeR/KlfWhDCtbjoVAOwMA4SE2U8aPFlX1duCxVuM3rlcDOgcunMS4PeT2Xv/bwoSZeFvC9VP+3/epvbxA7X9DMF9vsYKXXQloMAUgpNX9A/pxhFfPOSzq0rhznpv7pQqTp9OkZDVGY2QL+V3+dItk2ghiTf1ljNhaWQB9lucSpO+gejS/OtaXcy8CilcnY09nyVQUvodMn8thKClqOepbVW1kqPJJ17NZzqsc/YYtcPZW9q/iVBSDskDzx/Wg7RU5XXW+xuP7u8f0FgLtBrOvEC5GG2Pewg22FNg18tcPmggh/VzGVvqZg5/qrrg4P5lldUzBn9JM6eDhvfj17oidG4WU77tunlvfPGpttc1uSabwEy6I8IU8eF8PiigZZesKt7s7my5ZnphPc1m00hQYJOww7jAVRGiwZYbLM5xqCwVlnmyvV9+ng5QNnsZrbu/LDcaO1a4ZCMXlMgyAvSow7cdB8LguZLBVhc3Z5lf0ixlklVAFS1OqL9QzFFTmk8nMQZe+rVFSZIluHxeYI5ch64+Nw9miUWbuAmibMtEJecUIiDSf6QTcKQEHqgvhpYFhu25NEK3vHNiSQuWGGT9EFO8YH24AMMfQdGA1yEseesIr2f/eXhzKnW1ZhcTP4Rbvn3+UhP4GiA68gzCCXfK5n6/tpJNjU1DdiY428mg9Hes0SrYDmBpTPD6uCYdF6D8X4paAzVvyJ
 G5zW5rl4
 jaou0hS24dF2XiUKznu23K5S0bvJbcdeGfq9y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 09 Mar 2026 16:17:42 +0800 Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org> wrote:

> From: bruzzhang <bruzzhang@tencent.com>
> 
> Currently we flush TLB for every dirty folio, which is a bottleneck for
> systems with many cores as this causes heavy IPI usage.
> 
> So instead, batch the folios, and flush once for every 31 folios (one
> folio_batch). These folios will be held in a folio_batch releasing their
> lock, then when folio_batch is full, do following steps:
> 
> - For each folio: lock - check still evictable - unlock
>   - If no longer evictable, return the folio to the caller.
> - Flush TLB once for the batch
> - Pageout the folios (refcount freeze happens in the pageout path)
> 
> Note we can't hold a frozen folio in folio_batch for long as it will
> cause filemap/swapcache lookup to livelock. Fortunately pageout usually
> won't take too long; sync IO is fast, and non-sync IO will be issued
> with the folio marked writeback.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: bruzzhang <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a336f7fc7dae..69cdd3252ff8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1240,6 +1240,48 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
>  			folio_test_unevictable(folio), folio);
>  }
> +
> +static void pageout_batch(struct folio_batch *fbatch,
> +			  struct list_head *ret_folios,
> +			  struct folio_batch *free_folios,
> +			  struct scan_control *sc, struct reclaim_stat *stat,
> +			  struct swap_iocb **plug, struct list_head *folio_list)
> +{
> +	int i = 0, count = folio_batch_count(fbatch);
> +	struct folio *folio;
> +
> +	folio_batch_reinit(fbatch);
> +	do {
> +		folio = fbatch->folios[i];
> +		if (!folio_trylock(folio)) {
> +			list_add(&folio->lru, ret_folios);
> +			continue;
> +		}
> +
> +		if (folio_test_writeback(folio) || folio_test_lru(folio) ||
> +		    folio_mapped(folio))
> +			goto next;
> +		folio_batch_add(fbatch, folio);
> +		continue;
> +next:
> +		folio_unlock(folio);
> +		list_add(&folio->lru, ret_folios);
> +	} while (++i != count);

Hello!

Instead of using do {} while(++i != count), its better to use for loop,
a standard for loop would be better for code readability.

> +
> +	i = 0;
> +	count = folio_batch_count(fbatch);
> +	if (!count)
> +		return;
> +	/* One TLB flush for the batch */
> +	try_to_unmap_flush_dirty();
> +	do {
> +		folio = fbatch->folios[i];
> +		pageout_one(folio, ret_folios, free_folios, sc, stat, plug,
> +			    folio_list);
> +	} while (++i != count);
> +	folio_batch_reinit(fbatch);
> +}
> +
>  /*
>   * Reclaimed folios are counted in stat->nr_reclaimed.
>   */
> @@ -1249,6 +1291,8 @@ static void shrink_folio_list(struct list_head *folio_list,
>  		struct mem_cgroup *memcg)
>  {
>  	struct folio_batch free_folios;
> +	struct folio_batch flush_folios;
> +
>  	LIST_HEAD(ret_folios);
>  	LIST_HEAD(demote_folios);
>  	unsigned int nr_demoted = 0;
> @@ -1257,6 +1301,8 @@ static void shrink_folio_list(struct list_head *folio_list,
>  	struct swap_iocb *plug = NULL;
>  
>  	folio_batch_init(&free_folios);
> +	folio_batch_init(&flush_folios);
> +
>  	memset(stat, 0, sizeof(*stat));
>  	cond_resched();
>  	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
> @@ -1578,15 +1624,19 @@ static void shrink_folio_list(struct list_head *folio_list,
>  				goto keep_locked;
>  			if (!sc->may_writepage)
>  				goto keep_locked;
> -
>  			/*
> -			 * Folio is dirty. Flush the TLB if a writable entry
> -			 * potentially exists to avoid CPU writes after I/O
> -			 * starts and then write it out here.
> +			 * For anon, we should only see swap cache (anon) and
> +			 * the list pinning the page. For file page, the filemap
> +			 * and the list pins it. Combined with the page_ref_freeze
> +			 * in pageout_batch ensure nothing else touches the page
> +			 * during lock unlocked.
>  			 */

page_ref_freeze happens inside pageout_one() -> pageout() -> __remove_mapping(),
which runs after the folio is re-locked and after the TLB flush.  During
the unlocked window, the refcount is not frozen. Right?

With this patch, the folio is unlocked before try_to_unmap_flush_dirty() runs
in pageout_batch(). During this window, TLB entries on other CPUs could allow
writes to the folio after it has been selected for pageout. My understanding
is that the original code intentionally flushed TLB while the folio was locked
to prevent this? Could there be data corruption can result if a write through
a stale TLB entry races with the pageout I/O?


> -			try_to_unmap_flush_dirty();
> -			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
> -				&plug, folio_list);
> +			folio_unlock(folio);
> +			if (!folio_batch_add(&flush_folios, folio))
> +				pageout_batch(&flush_folios,
> +							&ret_folios, &free_folios,
> +							sc, stat, &plug,
> +							folio_list);
>  			goto next;
>  		}
>  
> @@ -1614,6 +1664,10 @@ static void shrink_folio_list(struct list_head *folio_list,
>  next:
>  		continue;
>  	}
> +	if (folio_batch_count(&flush_folios)) {
> +		pageout_batch(&flush_folios, &ret_folios, &free_folios, sc,
> +			      stat, &plug, folio_list);
> +	}
>  	/* 'folio_list' is always empty here */
>  
>  	/* Migrate folios selected for demotion */
> 
> -- 
> 2.43.7
> 
> 
> 

