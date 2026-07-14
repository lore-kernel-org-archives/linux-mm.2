Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03848C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E627A6B0093; Tue, 14 Jul 2026 07:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11BF6B0095; Tue, 14 Jul 2026 07:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3B46B0096; Tue, 14 Jul 2026 07:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 975F56B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:34:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08058403CF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:34:14 +0000 (UTC)
X-FDA: 84987173628.09.8F1C5CD
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDAC14000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:34:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="E0RO/Cl/";
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBR9GB4eP2IBRWceSzgIs35meZqLIN2i5MroWVCDAUM=;
	b=6saN04kUP3j+9G0SIveq+d84A8wmSayVzbwu7ZZhrlV/XaCyQJBxKIIBF3MGjFw8iO0m2y
	aEm0HRoa9qDdDy59qP6wpfizdERQMlgSnSN/OchGjzQC+Ll3LGmjohiwI7iIKFOxaw5Zmq
	Q0KLsAyXruH6BGJComKmv8ujkZScHd8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="E0RO/Cl/";
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784028852;
	b=08sW85A6h+QHpbuBGL9c15utbwPtvoYwh5Fw3eEFF+e7+0/aZos5kyh9HM67rjqOlBsYqb
	efHhchtuiYvIaIG7lpCFrop54o7phZFs+MxjjvYOTKBjF64YY1e0iy0xVhHu8zjJF+txm9
	ckSp2AMd0+6+4Wl3Al+mJI5iDgiosg4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4720d22c94aso828935f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784028850; x=1784633650; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tBR9GB4eP2IBRWceSzgIs35meZqLIN2i5MroWVCDAUM=;
        b=E0RO/Cl/0qDVCSiOlUf2K/VXKYfmkL8E6aSEGr1OLuBf8x40rfnhhcHy7O6d2aoMm/
         BScZJFjvpK4sXuQa8eVUZZzYrKEt1xlxPUm4Ro/1fJYh7NBscMZxKOpIMwA886pOdLld
         egIk6FuZ1GwnSBpFqgJ0jJnxl1HJvgkNCMSeGpD0Z5sNGtnjldPkv1Ze48Go30D9muZs
         b9zWClCHhBZ0KzivKEVdr1AGqEHkIpP4Qtn3Ir0CTuC1HhOkPqpl0Dcb3ygDyqYAqigz
         GJztmMaaKejlSXwSJWwHdeam3ZYDDsDrzC396f/PKa/nhI04vBwhz6nhPCjQYiKk6y1v
         lFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784028850; x=1784633650;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tBR9GB4eP2IBRWceSzgIs35meZqLIN2i5MroWVCDAUM=;
        b=VKywQd8K5d6+sUjRkfeXC3Arc9veuIpi5Ey2QjAJ3KjR0ashEVBdAkyIxkpR7TIa4h
         gZ8hGew3fxOF0LUGNxDFi83v0JrE3TOQ4W9qrBT0C8NS8pODIqVSP7idYjhMg1yFlQsL
         WDAQWxexgNVgH2+6s5jiY413+63zbqNm6ZLn/0aKgpLLNEZvmfr7u1PWiOVKnO4mzGX2
         RgTDi8zU8wKTSN5X0dj2rwKXAjNa+zlwKuwfqx7JmKQGgPcKntoW9e6Ce1MFuwPX0Avy
         JyQW7iFR72gJV65xt79nF56vit4rg9ZPG0LimYnIP1BlrSSgg+cYFiqE+A8LcAXDo3ku
         b5pQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqb4Rtb0EDSmLL5gYOhe/VTMbv91eApb59VcuUnNTUKaQ71AcLuxPEcY7I0vl5i2KlAaATJ27DuWw==@kvack.org
X-Gm-Message-State: AOJu0YxOuQQ6VUerQOr0utQds29sVjwJyHzCS0hGbHvqlRZ5cTXxrA0M
	W3gWUPLDJT1pI1363M9P4wfIP73sOIwnS9zKs89Y/ixkFkeBt+I56tBjvKc3J5wSKEs=
X-Gm-Gg: AfdE7cn4DMGkBUPEv/gBCwOv1VmyOcbUNXok1Y7wwcC6/N+RST6teEN8B61gKRzd/XH
	Gw1mlFDGxO1XOUfltU8jjUARJ0enEfdSxbdo5vIqC8W8iqQ4p1igA2hV82ZK9EWPxTVYjtF3gce
	bfE23xS6+V1/5wm+7mt8gRnUaY8l73VCI2Ipwq/wwq5SNI9nt1JmPC3nhfpOJyd4VvqtppcPDhj
	pYI61ivI1VYxZ5RERRR9SpaP4qevknB+PUbDt1WuzZzTJ+N42T5xFDHKW/NlK/HQJD9c81eEwUI
	diVdkS3uEqqOT2E3tKwweidI39Pb/iZsXOUsbwixUnQw8QDh95X2sTK9nJcwlyw9uUP0Vs8rgfn
	FMzPivUJiTnFxqAkuFZzefPLwVQzQBSqLRipeMZbo7I7VTFWkymPucG+ysmz4Tkc/ZDa0eZaUsL
	jLIx2Ouu3bK7o2t3pa1LTkJ8+pBQ==
X-Received: by 2002:a05:6000:2c07:b0:475:f0d1:eb5f with SMTP id ffacd0b85a97d-47f2dd1b13dmr15238319f8f.58.1784028850320;
        Tue, 14 Jul 2026 04:34:10 -0700 (PDT)
Received: from localhost (109-81-95-153.rct.o2.cz. [109.81.95.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464b7f84sm7267657f8f.27.2026.07.14.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 04:34:09 -0700 (PDT)
Date: Tue, 14 Jul 2026 13:34:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
Message-ID: <alYesAbH_i-v9mPh@tiehlicka>
References: <20260710024429.70923-1-ahacigu.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710024429.70923-1-ahacigu.linux@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDAC14000C
X-Stat-Signature: rhsqrzntm89rcgaa5qig5wkq9t47tt9a
X-HE-Tag: 1784028851-845124
X-HE-Meta: U2FsdGVkX1+Er5Feaktwt/3x28qX8qxrYVA6GwlLTG/6kpWI8VYB8qMuNRhHfWArwQsUYk6ynJ6+AHC4GrFCYB4nbjOhGT4nftdtauPNkFG7AODobbiISUyZ2/l/zOMtDWz6UDH1NzRiBjfd5ecHcJfFXkhnFAMThhr9wLQiQGNjXqjlLfDC+shLU0xyS3ZUtPZd8Pewc73NKvzJ7Ps65/MucyuryN+QdID/+kUpIK3Fmvn3mGu0RtoNIrPZb6iirw9owVGq7LDtgfN8x/nqjfTQ2qnG6tFCPWBn6NMtwlUkaMQKEOJP+6zlWDXuxcgVqyRK0/vhfW1X8tE4tWkvlMCC8puUvrwTU0iiRTgzC692F5pMCvw9MAWM4FABzHGWq4Kqs0SvKNweNGFiqX5Jn1EylJ+lICkPWG9b9jmdBeJHDXnVNMX/hxRkFq/V4T2kzHRsiS4I6pLPrsHCJliqul+TZC5FohHa1dYkCPpYvMQsq15JaUXVPiw7SbLL3iIAtus6C50uPdbhpMrPcn2pAKmMcUr+jHYDAC8JTVqa+h2Y0SNLGLFPGbYdOlVAHdXYx8jUWie7ZCXjl/E2MEjWY25rsmUyHgd449A7oOe9ISEeLnsrs3PQqzcsrHvjTCXH/X2lShzl2YwRQ0yXUcZd6yMTcuOGYmI6c5M921PYCb4ELxEvmTvwy8l7pxVhw17v9Xcnu0nF1FGiqKbMl+ureQQJVD96zwahb35qlXoPGfhcw3ep5sdgYNjyHrPDuJQilvrHXdm/O2mXWpgs9G+Eozjzgl5GPM6pA96q9t8H9tfX1zk8HIns7aqmmLcfGDQj8M6mpj3U2gsQvNsZmoujgB3dhJsPWP/ea9ClwNcDdwfIXj3ypnrLpyeWRr/wGgOyB4fjeIccTbcf+DSMGfNL9W7yb18QiHt9xB6CIukckMAjhB1qUxseHznHwETvmCOMIyrZ5mB8gijTOP75qY5
 w/zJBg4f
 J8PA6zUqJRP8jS22h6POTB5NJEP5BBtqmvE+56oEUYDBRvbSaw1lw5abCkBfciQOMSCCA2zgD2dQkFWqLUdaeytD9lYmI0AM0jvGdTOc34C6WEpICtrRoEFuyJo6MpdmS6DhDNLkTvpLAF7YFy7hdNfyolM+6scwIAsdF9QN+aA/+8jPR28Ys2IZGMbn15S83HJAhagBdVruHzRW4tUUI0y2ueVFdVtfrv3BqRZMYijPjXO41SHrkRwpncxfZR9oKsKJusOaQuc9NUSDlpF1sZABA7zz9pSNM205wiFbVpXLUUfh5VYL7HquJz34dgR80RHO56zUEUX34Jem+ZYOb3mGQjF5mEL4w4QDXrT6t85Iyzj35XoQnvOqp98gHLHEZieZaFNT2kiPJwcshQt4RplxgFkeFB5eApj8Dhr6Z8ntvkOop3AzTX9/Vjsqi19U5oRyVK89Yfh4ZioQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-07-26 19:44:29, Altan Hacigumus wrote:
> Direct reclaim clears the hopeless kswapd state only once the node
> becomes balanced. This avoids cgroup memory.high reclaim repeatedly
> reviving a kswapd that cannot balance the node.
> 
> However, it also prevents global direct reclaim from reviving kswapd.
> Under sustained memory pressure, global direct reclaim may continue
> making progress without the node ever reaching the high watermark,
> leaving reclaim to allocating tasks.
> 
> Unlike memcg reclaim, global direct reclaim follows the same node-wide
> reclaim path as kswapd. Clear the hopeless state when global direct
> reclaim makes progress, while continuing to require a balanced node for
> memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> scan_control is private to vmscan.c.
> 
> On a workload with most memory mlocked and the remainder under sustained
> churn, with swap enabled, comparing the same 60s window:
>                               base       patched
>   allocstall (all zones)    413441          6532
>   pgsteal_direct          15889552        255619
>   pgsteal_kswapd                 0      26079382
>   PSI memory full avg60     13.10%         9.37%
> 
> Direct reclaim was already reclaiming many pages in the baseline;
> this change lets kswapd resume doing that work asynchronously.
> 
> Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> ---
>  include/linux/mmzone.h |  2 --
>  mm/vmscan.c            | 23 ++++++++++++++---------
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..1db6f8dac927 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1630,8 +1630,6 @@ enum kswapd_clear_hopeless_reason {
>  
>  void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
>  		   enum zone_type highest_zoneidx);
> -void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> -			       unsigned int order, int highest_zoneidx);
>  void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason);
>  bool kswapd_test_hopeless(pg_data_t *pgdat);
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..78fd35a11eee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -198,6 +198,9 @@ struct scan_control {
>   */
>  int vm_swappiness = 60;
>  
> +static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> +				      struct scan_control *sc);
> +
>  #ifdef CONFIG_MEMCG
>  
>  /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
> @@ -5172,7 +5175,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
>  	blk_finish_plug(&plug);
>  done:
>  	if (sc->nr_reclaimed > reclaimed)
> -		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
> +		kswapd_try_clear_hopeless(pgdat, sc);
>  }
>  
>  /******************************************************************************
> @@ -6251,7 +6254,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  	 * successful direct reclaim run will revive a dormant kswapd.
>  	 */
>  	if (reclaimable)
> -		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
> +		kswapd_try_clear_hopeless(pgdat, sc);
>  	else if (sc->cache_trim_mode)
>  		sc->cache_trim_mode_failed = 1;
>  }
> @@ -7530,15 +7533,17 @@ void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason r
>  }
>  
>  /*
> - * Reset kswapd_failures only when the node is balanced. Without this
> - * check, successful direct reclaim (e.g., from cgroup memory.high
> - * throttling) can keep resetting kswapd_failures even when the node
> - * cannot be balanced, causing kswapd to run endlessly.
> + * Reset kswapd_failures when the node is balanced, or when global
> + * direct reclaim makes progress - then kswapd can make progress too.
> + * Memcg reclaim can succeed where kswapd cannot (memcg protection is
> + * not enforced against the reclaim target), so its progress resets
> + * kswapd_failures only when the node is balanced.
>   */
> -void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> -			       unsigned int order, int highest_zoneidx)
> +static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> +				      struct scan_control *sc)
>  {
> -	if (pgdat_balanced(pgdat, order, highest_zoneidx))
> +	if ((!current_is_kswapd() && !cgroup_reclaim(sc)) ||
> +	    pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
>  		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
>  			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);

Is there any particular reason why pgdat_balanced is evaluated for
cgroup_reclaim? Shouldn't this be global reclaim logic only?
I.e.
	if (cgroup_reclaim(sc))
		return;
	if (!current_is_kswapd() || pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
		kswapd_clear_hopeless(pgdat, current_is_kswapd() ? KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);


>  }
> -- 
> 2.55.0

-- 
Michal Hocko
SUSE Labs

