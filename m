Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A73EC5AC9F
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E216B0092; Fri,  7 Aug 2026 12:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DEEA6B0093; Fri,  7 Aug 2026 12:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDFB6B0095; Fri,  7 Aug 2026 12:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04FEC6B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:31:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 913251A0488
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:31:50 +0000 (UTC)
X-FDA: 85075014780.06.7C33B40
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 588B5A0008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:31:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HrXn6Lj5;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786120308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYO5gL84ZfhgoOGOa76MHQFHtbyAJJVUdQQDYUbGmIY=;
	b=odT+CB7/YwiLjQSBqpgnORXY7boCIruAjm4TF0q4YFCNWl3fkH3jGBfYlqFuAWhexckbB1
	82fzXDCdrPDrkFMssVF6tBbcLOojVs/4tLK2S+14UCUG/qIXsyMfBTbXPYQgtRyLG4QvdM
	pco7+pvoZ+O10yo4F95Q57/fR5Lkbjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786120308;
	b=4zSd8/Vo14thmxLbm6VjsX49f1Qn9HKxZb01G5jkvoUkZ/N/BdcAFiF2e3B8uNk6r7Dfng
	cUyEysedjUOHOsHOX/zL0kH/Bl6NswQRyg8qt7fzg/OU4xFSuc/wiZO4pzX50hMAD2rcEV
	xUKVHrC/bSx520GJxsTTfY5bwh1cw+4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HrXn6Lj5;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-902e4af2d9dso17090886d6.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786120307; x=1786725107; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dYO5gL84ZfhgoOGOa76MHQFHtbyAJJVUdQQDYUbGmIY=;
        b=HrXn6Lj5TRProEQ95CUOYkC+5BJjIxMbNO5LMGFr0qACxZvz2PAXvSk4HYmEorsqNb
         eEYVPRVIJO99t+AtIez9vFrnTUapxw6Dr4BcZM3kzxVlo4dWpHi1q+gqsDtl49xEkkDY
         d7DQaIAbgtfv+yCJ9A+OUt25Dn27TjqMtTBYLwgOSxDZkdJrx7h/oVU4eI4Jh/ZOq2Qe
         ZJvLoGlLjhpGqntzYl8U45m2K7rbNKwrRnJ6rEp5hQrhITz6eWfapcUQusCfLIWBPQg/
         0ik82yk0Kklkf+9DSN0fW+ElSQ6rnM7Q25BXw3GZvPkZ9KTUBVvzUj9UUGXAfBAsUWd4
         i2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786120307; x=1786725107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dYO5gL84ZfhgoOGOa76MHQFHtbyAJJVUdQQDYUbGmIY=;
        b=erRI9i5ljTC2M5GnfMLVlh9xIYQhbsXe/CaOUJKVGE3aSuKvsuRkjMANknkpSgGsua
         sucJWAfbVvLnmG+soKiUJFlRGbuwxwtVpXYtesK6qQQ3t9TZ8G564rYzpF6K/2zlAUpG
         aFRoLyNCdNZNJUpEN19cdA3i/OLSLy4+eylr+33gSAWiJDatVCvvJbMp2hD6xLTtaiST
         aUDLmh53AGyfWgdUIOCy/bUYavYm+UCYWI++Kk1fQMx5oSSLnF9sstR+UeV9lIoKpzOp
         ix059JH2Rl5ugwE9OC0rg1MRknHDop5eCenZ0ikpCzbOwtq4cGgKUOQ/s7C1eKZXAIjl
         2DhQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4IMFLEQn2kEHlgUqxoOHCtkQAQ+rTO8OvxaBo4jmm/oOZSJnJ9u6mbq79gjiJrtxUv2JBMqT9Ag==@kvack.org
X-Gm-Message-State: AOJu0Yy2q6cgDvrEFUrWg5nZ6UXKe3ckou772qs6muNSOhd4wqMaImge
	V/zu++NCA6GZ9TL8Ghv52tWKM0gLk2RiU5PwYLxG1jfTXYSSNAy0lItZvNYRPgsu1h0=
X-Gm-Gg: AR+sD13znNly+ISEvc7DIxNSY2LUae7WvEY8xjYtU0HbHnV0tkCtwuk7qly19erdII9
	Yger6alUMdB7odG3088EjlayaiG/YULuHJ6MSQXVi55tejLnTKQzVA3wjAew45yHHtMaiepHX/0
	4OIe4/P1V6LI7Qwu6cezBfwNmyhAf3ECXCEd81x9A3hIK6cz+G29UNzcmiL1w2a6MyVf7uRQBsa
	xkYyFge+lZ90JLWPYkXnJRuLwXdgc1q51yOHVMQJyk6CzhMoFe4lZVjLzlaI8wEA6Mb5iEq2b/j
	KAvS2QTwZnlJloS+2aaZCnbiIbsoPvFVHgSc5ay/gXm8r4qDIVj69mjc9FNz0+61uBSq8dwIsNa
	Ip12fSP8IraMYUlMBWN2A44yL3mAWNJd1lHl64usOLHMHkWJ+sbSS7oDK/YVPBfLXTno2t4jWmR
	SJzR5cjLaPOiYyuom9jZk5qzYi2lo0DrHzbOCkUZ31FPV/Q9NTmWABi2CfrJA=
X-Received: by 2002:ad4:5c8f:0:b0:907:6f9c:3b43 with SMTP id 6a1803df08f44-90a34c86e42mr12128346d6.2.1786120307299;
        Fri, 07 Aug 2026 09:31:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a932ce88sm12048886d6.38.2026.08.07.09.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:31:46 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:31:42 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, riel@surriel.com,
	gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/11] mm, swap: only charge physical swap entries
Message-ID: <anYIboHEUZb4fhHv@cmpxchg.org>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-9-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-9-nphamcs@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 588B5A0008
X-Stat-Signature: a6hzt4w4odj9cn6i9kqw7sn99bo67fj7
X-HE-Tag: 1786120308-509450
X-HE-Meta: U2FsdGVkX18Q6onwH1vnAI7YD3f5AGtIfGD7yNrY+mrrptXQjqSs3U524lKaLDpVYU8BfDi6X26ISgxA4Ix7vWM/MFEfPXM44dTwxLtStQm0+rZIK73rCa9/Svtt9842wDdMlK53b0SVIwQA9YEg+wsNI6CCpkZcGyCF9fme50S9sCYx/h1Baggw3RXTa8V+i/eVu+49vxGCkk8izKlKl3Z9/qchH2Z/dwRtL5h6SYs+dNxsByg5hAlyZUkFvvSNdBojGIn8oB2g4llKw1Xx1f1ZMdPJT68KYvICNN6fRYwy1iwjqO6JXMvZu92hKmebpjD3s3nTGT9p0H8bcqtjT6XDdJxYKoxUoDQSqLI5wfN2KeAtyxXqt2D5apTHPX4gVn5fNn6ELrpYMi67UroXPAJnG/VBbQa1XxEpQysDBBbIit1tHECmCXU2N8gEpjVDZsJxuX4CfHvqutj5z+c1bTQqpP8dX6Ah45ppKt/tzxOnsgWeQ5Jfbje4CPG6O9nbGGebzI1lPr53Vk6EiRA04RaDFCz/HRPRxzinVgKWROAUPfKCVOqOlvZ8ngIopMuPbFwtRlR7nH1Vmh5jRmwAiCZDAoPt/KBO2yFvrsMxiJYzSNvpH8yu1l51bR++Lc8T1qLmxblPOYbGulCeE3Pv6vN+n7/n93jSLmEOdxGXZ9cyBW/9sAOH2BjHKjY4Br0hAVqANFDTolHraYedgnV9HOgr8BpyO0jOScM6OFFOrmfy/I2NzS2kjMg10Vd+CfENmKc7wTRTd8Ul+wE6FaujGERIEOk/SjXopbfRX0JPFbRy1SR29Np6A0kVs2gkBmBnE0SEs9ZK2y8WV5mA5lCMeM3sRjwlpY2BUBpguBazuGcOSLgP0PoHObK5Nhn3j1scLOk+ceQZHUvWTBOpIzuvEWHqMaHxNriE7pbKvzLvfDNtIAWzd+xbqNOucRXZ8MwOBqzljArSSLFLPOIoJnl
 A1ug5A4P
 oPb8r5GDRBfiyIXgj4oY2sTAKVlMw3zS21gHq6klqdWU78X0zzdLeTptImad+9N6QfI67eNJGZ2/uDpbUExGAQQ0wrLQ5A0HCQYOQd4sChmt2XiNgsPh9q6k7W3ihbxSYEEhYQPjrohhrm86rf8jcDRuHjcBaB0wpM7VPml3MGYL2GHcfILNjPruJSJlNAVECPCnQyTlYmuu/TGVy28Lj7ObIxPSIZmcmFMEiUx8w4An+X7v12dIg0MmJXG0gUFs/WwC4mJVjlQ4YRpU66+hEir/q/XrCQ9F3wDNwwCZ7ujm+PXDHp8UBcAKtkvoObYYVVuJOhr1yia34EgsMYUnHS3EBhTPAFiNm3RtdLuU6EW+xPhAAGVXwB65Jo+hlzn2RT6HqbgbOciLQ/lukR57OvhZ5UpXZl9J+ATR2KL81zETtAlYaHlwOnZueMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 11:42:51AM -0700, Nhat Pham wrote:
> Charge memcg->swap when a vswap entry acquires physical backing rather
> than when it is allocated, so memory.swap.current tracks on-disk swap
> usage. Zswap-backed and zero-filled pages occupy no swap space but were
> charged as though they did.
> 
> memory.swap.current therefore no longer counts them, and a cgroup whose
> pages all land in zswap can now reclaim anon memory with memory.swap.max
> set to 0.
> 
> Direct-mapped physical swap charging is unchanged.
> 
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>

To head off any uncertainty about this: this is exactly what needs to
happen in terms of cgroup semantics.

memory.swap.* are about physical swap space. They track, control, and
enforce fairness for a finite resource that is separate from memory.

When a user switches on vswsap and a bunch of empty pages are stored
inside the zeromap without consuming swapfile space, these counters
must be 0.

When a user switches on vswap to use zswap without a backing file,
these counters must be 0.

When a user switches on vswap to use zswap with writeback, only the
pages that get written to the swapfile must be tracked and controlled
by these counters.

A few inline comments on the implementation:

> @@ -5701,6 +5702,116 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  	return 0;
>  }
>  
> +/**
> + * __mem_cgroup_record_swap - record memcg for swap without charging
> + * @folio: folio being added to swap
> + *
> + * Pin the memcg private ID ref and record it in the swap cgroup table
> + * without charging memcg->swap; the charge is deferred to physical-backing
> + * allocation (vswap).
> + */
> +void __mem_cgroup_record_swap(struct folio *folio)
> +{
> +	unsigned int nr_pages = folio_nr_pages(folio);
> +	struct swap_cluster_info *ci;
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> +
> +	if (do_memsw_account())
> +		return;
> +
> +	objcg = folio_objcg(folio);
> +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
> +	if (!objcg)
> +		return;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	if (!folio_test_swapcache(folio)) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> +	rcu_read_unlock();
> +
> +	ci = swap_cluster_get_and_lock(folio);
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> +			  mem_cgroup_private_id(memcg));
> +	swap_cluster_unlock(ci);
> +}
> +
> +/**
> + * __mem_cgroup_charge_backing_phys_swap - charge memcg->swap
> + * @memcg: the mem_cgroup to charge (may be NULL)
> + * @nr_pages: number of physical swap pages to charge
> + *
> + * Charge the swap counter when a vswap entry gains physical backing. The
> + * private ID ref is already held (pinned by __mem_cgroup_record_swap() at
> + * vswap allocation), so this only moves the counter.
> + *
> + * Return: 0 on success, -ENOMEM on failure.
> + */
> +int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
> +					  unsigned int nr_pages)
> +{
> +	struct page_counter *counter;
> +
> +	if (do_memsw_account())
> +		return 0;
> +	if (!memcg)
> +		return 0;
> +
> +	if (!mem_cgroup_is_root(memcg) &&
> +	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> +		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> +		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> +		return -ENOMEM;
> +	}
> +	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> +	return 0;
> +}

These functions are just __mem_cgroup_try_charge_swap() in two acts :-)

Please refactor this properly:

__mem_cgroup_swap_record()
__mem_cgroup_swap_charge()

> + * __mem_cgroup_uncharge_backing_phys_swap - uncharge memcg->swap counter
> + * @memcg: the mem_cgroup to uncharge (may be NULL)
> + * @nr_pages: number of physical swap pages to uncharge
> + *
> + * Uncharge the swap counter on physical backing release for a vswap entry.
> + * The private ID ref is dropped separately via __mem_cgroup_id_put_swap() when
> + * the vswap entry is freed.
> + */
> +void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
> +					     unsigned int nr_pages)

Same on the uncharge side...

__mem_cgroup_swap_uncharge()

> +{
> +	if (!memcg)
> +		return;
> +
> +	if (!mem_cgroup_is_root(memcg)) {
> +		if (do_memsw_account())
> +			page_counter_uncharge(&memcg->memsw, nr_pages);
> +		else
> +			page_counter_uncharge(&memcg->swap, nr_pages);
> +	}
> +	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> +}
> +
> +/**
> + * __mem_cgroup_id_put_swap - drop memcg private ID ref without uncharging
> + * @id: cgroup private id
> + * @nr_pages: number of refs to drop
> + */
> +void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_private_id(id);
> +	if (memcg)
> +		mem_cgroup_private_id_put(memcg, nr_pages);
> +	rcu_read_unlock();
> +}

__mem_cgroup_swap_put()

and then remove __mem_cgroup_uncharge_swap(). Handle this split the
same way as on the charge path.

> @@ -2116,8 +2117,16 @@ int folio_alloc_swap(struct folio *folio)
>  			goto again;
>  	}
>  
> -	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	/*
> +	 * A vswap entry has no physical swap yet, so only record the memcg;
> +	 * folio_realloc_swap() charges once backing is allocated.
> +	 *
> +	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
> +	 */
> +	if (folio_test_swapcache(folio) &&
> +	    is_vswap_entry(folio->swap))
> +		mem_cgroup_record_swap(folio);
> +	else if (unlikely(mem_cgroup_try_charge_swap(folio)))
>  		swap_cache_del_folio(folio);

This becomes:

	if (!vswap && mem_cgroup_swap_try_charge())
		abort
	mem_cgroup_swap_record()

> @@ -2614,18 +2685,28 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
>  		/*
>  		 * Uncharge swap slots by memcg in batches. Consecutive
>  		 * slots with the same cgroup id are uncharged together.
> +		 * For vswap, only drop the ID ref - physical swap was
> +		 * already uncharged in __vswap_release_backing above.
>  		 */
>  		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
>  		if (batch_id != id_cur) {
> -			if (batch_id)
> -				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
> +			if (batch_id) {
> +				if (is_vswap)
> +					mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
> +				else
> +					mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
> +			}

And this becomes:

	if (!vswap)
		mem_cgroup_swap_uncharge()
	mem_cgroup_swap_put()

