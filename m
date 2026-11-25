Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CE1606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B/Ww9kKn
Received: by kanga.kvack.org (Postfix)
	id 57BFE6B0A21; Wed, 25 Nov 2026 08:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5543B6B0A22; Wed, 25 Nov 2026 08:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4428D6B0A23; Wed, 25 Nov 2026 08:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19A266B0A21
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:47:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85D8C140EA2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:47:41 +0000 (UTC)
X-FDA: 85473769122.23.0F6BC49
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id B7712A000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:47:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="B/Ww9kKn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795614459;
	b=02jABatawJdQRSC3ISOkAmUf9+e9YwFI2RhOYgD9dDi3BqCJdKUj1kRw/Ix/shqlJ27+WN
	iyMpa7AeXN3esIlzkYnBrbyIznDI+RMS7v7W1OjF21jXqND0c98SxnPFlYzNMjAP0d/TKx
	Gcboo33mhLYP1ngbfINL9FdX3/heThA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795614459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNd0IbaZQFJuxJS+R9ayDKLW68Bcl2zYZx6i5ipU+qg=;
	b=fDXncLrs0nt3nLMQLcW1ok0l5uBK6GIOSF+x+pNM8pPKiImuNatlorrDyN4RAOY7vY6VYu
	mvH12K/AMaghRED0yS7s5w0Rj7fvt0nj/k7ylsIQqj17QD+lJDoVCasBi0rbJlukXNX53/
	AMhOHe0+vRcIg0KzsMMbVsC09EKw1jE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="B/Ww9kKn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b44bdcea8aso3162629a91.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795614458; x=1796219258; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tNd0IbaZQFJuxJS+R9ayDKLW68Bcl2zYZx6i5ipU+qg=;
        b=B/Ww9kKnNsIib50AKEC2g9Aa+dKjQPoBK78mRd2i5HJ0mdCibdIgSOsTyzDi6v3s37
         Uia1NlHC9aNa1fs4AmZz3HRM3oMCZX2cIXho/Kqm80WY5JqffKG/3G8kctu6oHtFkuPc
         66TGTonZUwNskTFJn5LN4hlCHkwgR1nJ49OT2BPR3ALZtHYNqdOVHoQOleqX5hYpZI23
         2EJ2UZQr6HgGWlW31H7+F8pJqsY/YOXXDr988n1dHoTSs/hUBzSvhkvZ1wtAnaW7gVS5
         jXtnjg0SA3hmgvmTLcBvRN8w8U+61nSKZ2Ed6b7J4fK+gjD9YAZFeeWudkV99MSfBouf
         xWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795614458; x=1796219258;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tNd0IbaZQFJuxJS+R9ayDKLW68Bcl2zYZx6i5ipU+qg=;
        b=pH15KsMc8u9GviA959k7uqc5TybwEEj8TbtsAqsjD4hDtkiF1ogubWOCKZdRguGxa+
         u7AhRnllWGtVXXPpyYNzpMfQWaWDYyfscKLQtCegWHZvvyPO6LIkaJtVgLDDj/pkDJF5
         Elehc/TQ000QRHq85qBvS5UJh21B0lnSmOM8e4hkRfsxYxaAK/kvez2n7dBpuoPQoQYD
         R/N1K83oVnAnMBsAio7IThdF/pOwbTIRW7RTMfVS/jAxUS+4VV0tXSjfbK7lW0ZYe7yn
         y0NJZ7LlsYYtTOEz5Ze1sZj6AZyhhBv0G552HCHKya3jAd6+yTI/EsaUO+b2YSMvymtt
         NhMg==
X-Gm-Message-State: APuU4Z+s0v2Eej94xoo1V/yPNluxAH9v6u7xPet+TS1l/AM5QgJoLwTO
	zoxCgbO2XGT36bLVKRbNVDCHIA1Ek/FZesB+5pWSDwrweAiFJFRjnhAO
X-Gm-Gg: AZFdTZefkavUwck3rOXePUKx9s6slG0lpB3Z1w61ChHEZyQMwgrHb9sAG4dRzxFzsH9
	afLzrPd/AyzjPF4DTCDP1188H2aLlaVAkcTo9vX/GxQqflOR9IGV/YEWFF0/8yT5oIZHYAmbMxy
	Itxed1H4MjoW43aKEUQ93VAp4k91IgOUn83n5vWMr9/K9wOAx2huhQJwaJl7Ra7n/Fomey3Ff4x
	ab6WlH4Q0Md/eUYNBHmzm9Kz8/Fa/5by3ZMRUmkPfJbtNjUjDYlIOOkY2BnL3D603lbhL1i1C8N
	ECmtirz/T3F5AKF0TEh5+8SnqPzYsDCo++JsVvQVjhMvonE8VDfmmJrl1ehUjavf4g7k51deMpK
	jnQCKfgWCXwgxTqVGmGYwCygxo5XLKjhN2lO7lngkrIETFMxQAbJxVdvcCykaAEvmnvp9ObwfoF
	MIQIeFFzGxjgZwAUjq9ZICYphafMJ+TzCWT7RrY/MeSIaklgDY4Ky96sA4SQ9vPViTgiRy4i+gk
	x5/l4pOm1WG+hslJ8ovchlfQszTizxag+Qoj4UTLNiLEScvvVwHHK8ONjPImnLf9/z5rtYnkkEu
	4DMO7HAQ6f7Rz+7Xp5skKVneunGtyDVtaMMB6SBQz06u
X-Received: by 2002:a17:90a:d2cf:b0:3a0:e568:ed63 with SMTP id 98e67ed59e1d1-3b41c8e0507mr11255737a91.8.1795614458296;
        Wed, 25 Nov 2026 05:47:38 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b7d36bcsm11786323a91.3.2026.11.25.05.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 05:47:37 -0800 (PST)
Date: Wed, 25 Nov 2026 21:47:18 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a
 fast helper
Message-ID: <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
X-Rspamd-Queue-Id: B7712A000B
X-Stat-Signature: 83nm88bpunwzbrux8mpj1547gc6oped5
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795614459-838968
X-HE-Meta: U2FsdGVkX18ylUrFRaMhs0xHqnfo5ZBpUlkYLbdkk518v4jSMiqD6tUNPEKroRMD/yftqWYfP+9kWq6f3Q73j/wqoFeJXSLdfvp1LAwxEVUzq+Oaz/52Z4n170nhlmjzND35v4/vg1kYF3DzqOdPLnlIypxY0ZOfO/HpUZJGPHjixu24nmAbPD8D0E+S6gqDNP4Z00JZ9e8ARGBI4RdG/DJb0/MSzqw/tT1NgBvf+9HDusK1RCAg+TS1AeOFfF1pj1KFhApykz6LaJUOxcqc4bmcmTAwLvADnUEZzMfKwvasfPITQW/AUiDa4Gb1NalzB5OHohTm3ocJg7niBmhdidnFcXrRW8cKuRGjdGmur3+2oOfYy/EtP/geWoysgAvEQac3BSQWBv8NgXROLii77PL/YD+P6eovRrbDfAo+B8ZAjiF3840ezStohUBD0E6elaUizpwTd9axG0zub2A3lodcnfgNMbBZmpdf3SKjpFR5reU1gSZNKoTQq9LUIykY7BXJMVhsGE7FbCnJc5FUA8tv6LilxF+msB1whGfQwxvcZ1Uddn8sfM333I/UO8yD6KfrHQuhOBiWRhdskzKXG86VU/uov1Y3CFc0EZyV18Ev+jMw0urJtZoskIXycMRVGfSIxGwFb6WNS70cuLMwA5OztruVMcIMqmRpRPRXPkDYQPniuBda4kkBOA09sWnNXUiKNVlKkOqEy3cxqmGVBmmJbKeC9Ezi3/+Wy3Q0osnhIa7Qe3Yk4E1pSOAraja+b7khASB8k5rDWWP5HnzGlUECRoqPGL05Jb/QYi7rOmfs3PRRF+v9+kmCieglkskA5FUxQce3nUAnMP07df4efdl2tPvaL5RHrCXBlChn2tURA3iwy1nYqXVGwhAPkpTGsw6M3Rpd8EUk6LP0tgLwVB3ax7H0ghhlhqqzYZ4mNZx1PpImYb/lf3pvSq0znCFIFKyO5nF4LK+3cHyhXg7
 jDHEp+oz
 vyO+8NVKjIIxItVv2fuVoPaRtufd1+du9Rj8u/ptnzuzrlKx0/hdFU17dgOqmVsNs3ZjG4hQXrAf6SxfKLSAH+t2QeBCiufDkgMmaR0np1NO1JCsnduuQeBKfx+L3TjYmO6FEJKfCWtZ8yYwcv/wxMmP01+9yHbrw5jz61W2hR6xxetTaV3INABsLi4zZWyZqhSGXSI8iH1RVeNkWIxvtXT78OP7C+Pu9jiAI0duuGhqRaerzZYnwwuhh8vqFxYjoMUbVhxSvjfOSMHTlk0DaC2Gfvv0vknJXExIX3TzuI+EP+aXTme/61mBJwTyWUwwo8paGKseNi3155aD7BYUOU2VcOv/3hnMhgpP15gvLSUynPy9KYWRa72QQJO309TRYUzpsrUka18S3ql373fqzo6cjAN/NC1z/3Lh6mCrrCX34bT+l0vj6rVkS5l/RvextzEsqWpmhl7TvAGT9d3D9OLWMIn1du/jXc/+zaPMScrCFTFcY6IQEJXR5eTTc3/fqh+PWTjgj4AthTM2TVj42B9TfOfwh8vxHuCMIV4v2ZvL+qj5K99oC2gpeq1tP5or6sReSPN/Gie25S0zLOiBoTIOWr9K5cWbpPjfLR8eTWIW0EZiNS0XG5943Wg/2jociJIGGA1AvG6meYVNiiiI4yxU0D4bZB6d+2Kw/zteITD8mcX28X6KUlgMuQxC2elZ5HKRSshzyeCwP83YKMeiQeGhqwAW88/XEMPUBFgpxsf16gpNaWursPIKfWb6V0g0is5uwIITqJrAZ9azd9YRFQ/a2v9DTiclk2XMwkeZ56xjRGEWTWzikNUViU0NTXcBdq3eokZJlnD0fT2d/iiyl3nPDZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 02:53:02AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> classical LRU as before. No counter update or promotion is needed,
> nonzero MGLRU refs are left unchanged.
>
> The classical path is taken for a folio that is off the gen lists while
> MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
> turned off, a folio can still be on a gen list after the static key
> flips, and setting PG_referenced there would bump its refs count.
>
> That check uses lru_get_gen_flags(), so move the helper out of the
> CONFIG_LRU_GEN block, it is now built with the option off, where
> LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
> an int so the subtraction of the offset-by-one encoding cannot fold to
> ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERROR.
>
> This helper only aims to be fast, it exists so the gup fast path can
> stay a fast path. The new helper doesn't account for refs above
> LRU_REFS_REFERENCED but that's fine for now as GUP never used that
> or anything similar for CLRU either.
>
> Convert the gup fast-path sites. No behavior change for classical LRU,
> no regression for MGLRU either. Just prepare for the following changes
> by providing a helper that follows the new convention.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 62 +++++++++++++++++++++++++++++++++++------------
>  mm/gup.c                  |  6 ++---
>  2 files changed, 49 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index b15c3618a1f2..13c8b6bce349 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
>  	return lru;
>  }
>
> +/**
> + * lru_get_gen_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_get_gen_flags(unsigned long flags)
> +{
> +	int gen = (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	/* The gen is stored offset by one, so zero means off-list */
> +	VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> +	return gen - 1;
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>
>  static inline bool lru_gen_switching(void)
> @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long *flags, int gen)
>  	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
>  }
>
> -/**
> - * lru_get_gen_flags - Return the LRU generation number from folio flags.
> - * @flags: folio flags
> - *
> - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> - * -1 if the flags indicate the folio is off the list (e.g., isolated).
> - */
> -static inline int lru_get_gen_flags(unsigned long flags)
> -{
> -	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> -
> -	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
> -	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> -	return gen;
> -}
> -
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>  	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> @@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  }
>  #endif /* CONFIG_LRU_GEN */
>
> +/**
> + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> + * @folio: the folio
> + *
> + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> + * untouched. For a folio off the gen lists with MGLRU off, a plain
> + * PG_referenced set.
> + */
> +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	unsigned int refs;
> +
> +	do {
> +		refs = lru_get_refs_flags(old_flags);
> +		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
> +			/* For CLRU, just do folio_set_referenced() */
> +			if (refs & LRU_REFS_REFERENCED)
> +				break;
> +			refs |= LRU_REFS_REFERENCED;
> +		} else {
> +			if (refs)
> +				break;
> +			refs = LRU_REFS_REFERENCED;
> +		}
> +		new_flags = old_flags;
> +		lru_set_refs_flags(&new_flags, refs);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}

The implementation code of this function looks a bit convoluted.
Would it be better to simplify it into the following code?

	do {
		bool clru = !lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0;

		refs = lru_get_refs_flags(old_flags);
		if (clru ? (refs & LRU_REFS_REFERENCED) : refs)
			break;
		new_flags = old_flags;
		lru_set_refs_flags(&new_flags, refs | LRU_REFS_REFERENCED);
	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));

--
Cheers,
Vernon

