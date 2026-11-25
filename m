Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66094606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUuUTauS
Received: by kanga.kvack.org (Postfix)
	id 805CB6B098D; Wed, 25 Nov 2026 05:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5D86B098F; Wed, 25 Nov 2026 05:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D946B0990; Wed, 25 Nov 2026 05:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D23A6B098D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:14:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61BAFA0C9A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:14:04 +0000 (UTC)
X-FDA: 85473230808.30.FEACB55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9868740004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:14:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IUuUTauS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601642;
	b=aF+DTjzlqhcvLl/W567UuN1UcgY42fROSOZX4YhuAx6Lv3835T8sORJG5C5jxX8g72sECm
	2MiwvYCQaGTvVMvcRw/EvwIgRexhQmxkAwOiv2DX9v5yvh2lcFnTU+UmDcBqkeGdVtfi0/
	bJLUeYCJZSsVZIXxS7I1L3j8esx2x3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKTW9I4A/a5NbLrwMrCbtVNu738y49BTojEZbBS2Lgk=;
	b=61bkOCUwOswNOZl1Y+59UHDup9EI0oFvnk/5GTgIi2YtlmAqiA7y2jg+jCTx4Yj0hbocc+
	kaaXDUw941Uz/UjhXFVIaO2mWioSncLprtn2bEWuactDwmDysnFVAq48CYGD1HHU0ysVpT
	Vn9efeqYfN1IBu2xSqrU6kbnj9/glRI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IUuUTauS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C47762502;
	Wed, 25 Nov 2026 10:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBA71F000C0;
	Wed, 25 Nov 2026 10:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601641;
	bh=NKTW9I4A/a5NbLrwMrCbtVNu738y49BTojEZbBS2Lgk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IUuUTauSKloNitDExogUjT43GCMQeT3ArIt1cvwfhQW4c8kv83KjK79TmT4zz2Hgc
	 RmWBbDyusenraXxeufAPNbeAGHE8EnvAQ7rx7Q6ROd3w9g0qVYlPrR3dAym6aPQgSR
	 coOAD3rEx5yO25jrY8YuFdJaLuwWpxAyCu5hz2oPlte2vdCuKYHTsX6xQE3j6Ot48f
	 bvjyXqnkrE0XWqq3INi6TCUrW9O5bVdo6VWuUDBbyxoO4mB1eXI9oeWjJqh6ftfZ9F
	 SScyFkAUC09E/YQYnFnCma10o3gpeAsOqkz44xM+ANfC263XsB/xcOWMZ3fNm6exuo
	 o+Cq15qgVZ9xA==
Message-ID: <ce7c1974-2524-4d49-91f1-508acf2e33d8@kernel.org>
Date: Wed, 25 Nov 2026 11:13:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a fast
 helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hjte6skgz3ecpsoyj1yw8hcm538snfdm
X-Rspamd-Queue-Id: 9868740004
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795601642-694386
X-HE-Meta: U2FsdGVkX1/WcG0SUPtjI/UFMskMEGEU7moTE/Nr+JCyhZrmsnSDcoD0pOSmQtGEY5dVTwSqfy+zXx38/JH8qbDllm9wiWrg238KCDIhn4DxaorTHpVlzV37gNHyLtvvJ3IWlcozfbk1HS5/IIvcUnsiPlQ3GTjTKkOz6ep1EbzyQsDEZbTpzl29n0SymribkgHfNUruGYDlrX4rId6AlC/euIGQMDhCMe2C+E6p4KF5KI+2JNNQalEEcAL2qY2q9Uzfjm1CEeQ4oFnk/Pg8nsuwAqwP8fdwAJg/452nMQUMRv8juEfUXhrYbTt9vheIWZsrotsNBEltNCgwZ1C6bWrHzS2IOhIjQeKkOjud8+82CCiH4v2DRuANKMuq44qPbvo0y5Z42duihlqstNjW16Sy3RvKPVZWJzFN+4uBCNoXraEgdBtiYZuqRuF6JDFV28NK7/uf3T961TkGfndNKkU5RBG4ZRpAqVy40fgcZVLgkZiBYJ35XukEcklez1XU62dKaifWLJ9QwC16FOjgJ/sqEmavXN/Vo6yESELVKcEpWR3D/cnphCUkFanDYRtUGeRSjF+9W7StYunUJeqbgM06FL5isODE7KJelYc2/OiShcjN+zka2atvk1HuIobFkMai4RlQ+hd+Q/5k5pHNa8RgrV+PC0mpPc5AfgaEmMSNzUL5bD8QT49sQ51YAtuiDDm5u9Wi00YoVSj1cYcbdsZEgCeTvwO/mzvZNl428HF+aqgBVp4SsjvfWybN8AD0XmR+5JV97w4BW+i1v83koFsQNlRDue9Sq6TduV7vR6AsBlRe6sBQhoGwGSgiGYNFTQUKsrUjZx9KbV7x+ePAqM5f2vYIdupiKhUaDUOyjE6H/bL9AeWxlaEVuNAA9Oz4hY5/w6WiV2m65ZRHpnzM86r4Tarqs3L6HdvJjPaOLc5g+9Kt+l1tJmNi3z5Iwyza6XcIZRUJyJBJgk/EBFH
 gjev3Yhe
 LUB5k8uU96X9b8ybJSuOh+9+HqfutmpQIQzhwBYN7vueEK9RV+OkNRxBnkxjnSjvwOelKAQZXTWqYOLnl/6jDaSeWKr1ptS3ub36u4h1N479/vKiUx2KhfFMnrq56X8JUm4ahvuYC/5TBx6S4FNF/3pqvt3nau++u1Wi4oBruge3OZhXsipcOq2sLScmxoQaxp6XkktRGQ/pzXarW0mvGB5wRSpCI0/LlECF0cGygqQ+AMOAE0AILbW9iqWmO78R8oQs96StJZH2d2NxwjLG7A8Th/usizftvPnrae95v01wrykqO8iSjoGA4VlT+yD+s9lHIJIHtK2JUaCapeyoL3GTVKpLtlkCSCigODAT2c5Q6/mhJFJyZ49DfUitFoFjVKPqVnXYaBaj5QapFnFrI0tEhvODS8dDPQ40Kqz2Wd9I8qpRRt329vxqMY9X49onD/SrhA2orOWas+K77B8AU37ZwbV7NFbLB9OkKOxtmJIYH0anxjQjZ78l4x7srHyv2eRkNZevGNM0vUNOgN/VjMMwhf2r/GWGK+2hF0Ppn7QkFLg81PIMk9LvazdG7QsL1hgoWeIPnukc2ofjsPBZ7mXqaLwWnv1FyUjUciSMGOmpLt5/j4Uz+k9zxnHDvtBp562Hq9jg0i5XdChbo/tcMSnqS272z8XM7HQgy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
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

It's unclear when this function should be used and why it should be used.

For someone reading/writing GUP code it's completely unclear why this magic is
required.

-- 
Cheers,

David

