Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759E6C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB2F6B009F; Wed,  9 Sep 2026 11:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1BF6B00A4; Wed,  9 Sep 2026 11:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7786B00A6; Wed,  9 Sep 2026 11:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49CF46B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:04:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E74B12023E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:04:34 +0000 (UTC)
X-FDA: 85194545268.05.B681206
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92E21140011
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:04:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAcK3OrW;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788966272;
	b=Hi2XC5L9e06xhneSPq9/G5w2H1dV6iLXp3CuPZYhv0dku6cYWmbaeewm1P9EXRGs6p9tKb
	rW0QXRbhJrkwMbRbdGHDoljl+mGL/DIgqWWULewVCe57m6F+1o20vFABrei66kxxgqEN8M
	Qe7GUj9oSZGwjoSrB6X3Zy9laCBWhEs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAcK3OrW;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788966272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeXzLXfVC8e+tzbtM1PdBxXt6XZbDS/FpvLHCNUlfWg=;
	b=NXEwC7/MHavfp06U/ZyyZBTbn9iFraxYfT/WG41uDcwezZFfQmcDNbWP836X35m613fo0l
	qSh0mC6fIpXXJ+/YSgGGecLFT0JVBw0rCKVSzPUiGXm12VjUQTaaEulXJWJJg147ZHsPfP
	xEy9zGhqlys/dJxgvVb2LUbruA4Pg4w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8C114162C;
	Wed,  9 Sep 2026 15:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BC11F00A3D;
	Wed,  9 Sep 2026 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788966271;
	bh=aeXzLXfVC8e+tzbtM1PdBxXt6XZbDS/FpvLHCNUlfWg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SAcK3OrWdGIvBXHFshnW4N1kmYi8uwxh70A6GyDCuxzs3FrmYJeKrYDCHVjEu2pmw
	 UIZKF5N1faibN8kfZYJSfF5CU0Dibdmu/VfarSip3jGeg3La2SN17ZRb6kR4YVvsot
	 nQBn/sJrXnnzCKvNgRfFOdliI3BHkx1Ijv5u+yF5K2mxhLL29fk6n2Ubh6H215S+2u
	 ztCV5CLMnDkfxc7sSS0yPfugcoX62t41N/Mi36hA5mdjlUYs/CSFuPjQV3hsoJOekf
	 blBoiFCh2VK5IXhrzqYxtDOLjqBw5HErG+DVT55hQ7Yik6LSawqEn0JIz4cOub2UYd
	 c+QYLaq1P1OqQ==
Message-ID: <af864862-90f9-4b16-a06e-1c189c4c4d6b@kernel.org>
Date: Wed, 9 Sep 2026 17:04:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/26] mm/fbatch: lru_add_del_folio()+folio_add_lru()
 after clear_lru()
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <b2e312f3-6909-5496-195f-ab71b45970ac@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b2e312f3-6909-5496-195f-ab71b45970ac@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92E21140011
X-Stat-Signature: x6zxk69bjkps7fj7crbujga61hc1x7aa
X-Rspam-User: 
X-HE-Tag: 1788966272-24531
X-HE-Meta: U2FsdGVkX19T00NKrhAD4yPtJOO8TOW7s5fSmLspr81gPGoGbksB/tmHJtBRq8lzzaW30h17oqG/Kt3Xg91DPVipAPy++bfh+VERuneOpuo9xavR4Bi789GdRQIWcev0QVVjtquIZCYfyEuCLxFb8KwOe3OuJWnybjz7jnmbdL4xwg61oATp8TQ+gftOL4IfNIKk38+dLOKF2l2sHsyZwVdsjGQuy1+85vGCs+vfgcgrmCp7qgGPXauIj7FhyidFs9ukh0DwoD/vSZOum5ukEopbXlBtzw+QRkSzF+Y3l+x/f/tLrlmAA+8rxcOMtjmGkeNJrQRPCXgbQeCpDbb+WGCaOV9+FIkRRnKszQiNPQmqd3LAM8IYIdk2tJI10wCUd3Sza758PfBWbR43Kflp9u+M23hhVLhhIcVij8T5NwKeAlVMy0tXBul/KgE+KKqynMsjWrPjOK0RZGiEe873UOd8P3EZWqwsSsoWPai9qviWeZZOVUqNjBVFcC5gu/c6yQ8SEfU7a5+4aYB+54VG09pJyErWRsvW3kcFwBapMXCBHD1ssAY8xJdTX/AGPwonqTzsW5obhRBckU8q71gGAa7IHhcm2uj9KZvnuqHTfyRYv3rGgMS3/XRDWlEswJfrkZX6AStiLnKmnhcp+cVAsArwyZWW4wZ54Lk4ROhYVtyWJToLLVliZVGGrLNCxtfqUHquGBr3K94FW6pfbXJ0hnVIyyd/QY1rZVddQc5cx+5Ps7YwdueTaOLGqCEnoy0F3CtHPA4me8POmwqx8dD8PNeYJakKGh2YnmYkWnXUuEgwiGKPZIF16Vg2C04/h+18AAf9s+FXBgsu9yPwXnJ0iEyK9tTBbOF4SzNQL5QsF/2bzzhm25lWGGWw9Ko3u8Bsk3XxrMDVycJoo1PiEg84FXEch0jcAxCrnjfYyvcg+DZAZP8zDwc7aGcoiqdE/gQ/VpGOtplSEj8AT/rHJ9B
 RVLHywlR
 Ji6vZpchgkUj0rQri9PYnlZQZKwUJVfX6anPgtqBAezg+e9LxcKMJDr5vRXEA/rgFqOWso+Q93FzbAA4wsh0N7M9DWNZBnV6+WHPwdcDN7jioSNRjHSnByfoxuixZ4ZmFDOha03LBDCdL11qFlC+rakWW8r/8lTZmongZY/vXd0LPT6ZAgHuVX/QwDjCjRTe4YeYtve/30DcYNXwq2l7vPaFGmnuOGwm30GsZkBYv5sRB29ikyH4QUqZX+L9aGlHs9YP/nf1IkcIjeoU0n137lyjSPsb10ymu/nKJXWnzOdDp6/BgLbDOcchdI9ut4L5roNDv4Roh74Vz/IVjwxg1qssY+ETo7LtNi+fggPsiDGq2W1iCC1nKIM0UVQahPJBOGuuKQrvvbPeP+Bjz/odq87oY8huYU0m+d01POAYAZ9UzhWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:51, Hugh Dickins wrote:
> Most callers of folio_test_clear_lru() then proceed to remove the folio
> from its lru, and add it back at the end when they're done (if still in
> use). But isolate_migratepages_block() and check_move_unevictable_pages()
> sometimes decide against, and release immediately with a folio_set_lru().
> 
> Which usually works fine: but there's now a small chance that while they
> held the folio with lru bit cleared, an lru_add fbatch drain came along,
> and had to skip that folio because its lru bit was transiently cleared
> (previously, the lru_add fbatch drain relied on finding lru bit never yet
> set). This risks leaving that folio off lru, unreclaimable until freed.

So this makes the previous patch a somewhat bisection hazard? I guess it's
acceptable given it's not fatal.

> Fix such cases by trying lru_add_del_folio() (which only takes action and
> returns true if the folio was on an lru_add fbatch), then folio_add_lru()

Oh ok, that's one detail I didn't realize on the previous patch, and
explains the name of the function. But it's still IMHO confusing.

> if it succeeded: invalidating the old fbatch slot, appending in a new one.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

In general, LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit below:

> ---
>  mm/compaction.c | 13 +++++++++++--
>  mm/vmscan.c     | 16 +++++++++-------
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a049415512c6..9e045a90ba21 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1204,7 +1204,13 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  				     !cc->alloc_contig)) {
>  				low_pfn += folio_nr_pages(folio) - 1;
>  				nr_scanned += folio_nr_pages(folio) - 1;
> -				folio_set_lru(folio);
> +				if (lru_add_del_folio(folio)) {
> +					lruvec_unlock_irqrestore(locked, flags);
> +					folio_add_lru(folio);
> +					locked = NULL;
> +				} else {
> +					folio_set_lru(folio);
> +				}
>  				goto isolate_fail_put;
>  			}
>  		}
> @@ -1293,7 +1299,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  	if (locked)
>  		lruvec_unlock_irqrestore(locked, flags);
>  	if (folio) {
> -		folio_set_lru(folio);
> +		if (lru_add_del_folio(folio))
> +			folio_add_lru(folio);
> +		else
> +			folio_set_lru(folio);
>  		folio_put(folio);
>  	}
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5..4e8d5cc34f07 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -8093,17 +8093,19 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
>  			folio_clear_unevictable(folio);
>  			lruvec_add_folio(lruvec, folio);
>  			pgrescued += nr_pages;
> +		} else if (lru_add_del_folio(folio)) {
> +			lruvec_unlock_irq(lruvec);
> +			folio_add_lru(folio);
> +			lruvec = NULL;
>  		}
> -		folio_set_lru(folio);
> +		if (lruvec)
> +			folio_set_lru(folio);
>  	}
>  
> -	if (lruvec) {
> -		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
> -		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
> +	if (lruvec)
>  		lruvec_unlock_irq(lruvec);
> -	} else if (pgscanned) {
> -		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
> -	}
> +	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
> +	count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);

AFAIU this is done because we can no longer rule out that !lruvec means
pgrescued is 0.
But we can still distinguish the cheaper __count_vm_events vs
count_vm_events? Probably all the same on x86, but I hear on arm64 this_cpu*
ops have a cost worth proposing rather elaborate schemes to deal with...

>  }
>  EXPORT_SYMBOL_GPL(check_move_unevictable_folios);
>  


