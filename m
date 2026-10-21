Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAEC606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=honor.com header.i=@honor.com header.a=rsa-sha256 header.s=dkim header.b=adye7O36
Received: by kanga.kvack.org (Postfix)
	id 720156B01FF; Wed, 21 Oct 2026 04:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6A36B0200; Wed, 21 Oct 2026 04:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DA46B0201; Wed, 21 Oct 2026 04:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0E86B01FF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:38:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A9E31204AB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:38:27 +0000 (UTC)
X-FDA: 85345981854.25.183E014
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90984180002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:38:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=adye7O36;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0E3k5w9CNVufTL0u7G2hV7VFMWQrRB7ev5VkwT5ZY/w=;
	b=IGcNGJHx87NRmJqMCEtHC+2LdE+OMBtKjdCPXD+qqR2wOGBrPiCj7kYYBkQAdwIHIkQozD
	oCC3RblkoznvCyld6PlO4deoqKTJg/3NWCTtVEO5yLpOgemoza/vXgia9BDsEv7oKCP6Ng
	/N5a25eKIApWK2L/HH+eqqpDbhHZsZQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=adye7O36;
	spf=pass (imf06.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571905;
	b=0ZDQkfzOy+aYs8OsJqiw6oIPzYY7P9Gswb4znfK6kjCoL39YukkjiIwUxIzkE4OYiPsbnt
	dKfr3XIj1M8Ec6cNI74F2AOkVQAqMbBx1i7bhXPcUbDvRw01EWWwZS7NyySYHKC/NRd0fW
	/bHKhDXQsRFe7v54hXiaJVojFdWuayc=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=0E3k5w9CNVufTL0u7G2hV7VFMWQrRB7ev5VkwT5ZY/w=;
	b=adye7O36KeeXjIUvTtvaSsYzLlZ9yINZBiR8Z5UbuoQLKPHR4vJ4N76WjPTZ0WIIrUZMQk0Gt
	TnZmwCM6mOFiFEjbKUDRNQuzjdek+JTS5k3YF3AQwUqBrVALV+bV7thbLnpCJN6C91itKE5KQJ2
	Ue2EP5cG6OOexzqaIAuLzeg=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4j8jNV1Jx2zYl8L2;
	Wed, 21 Oct 2026 16:38:18 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 21 Oct
 2026 16:38:18 +0800
Received: from [10.144.5.36] (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 21 Oct
 2026 16:38:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in
 lru_gen_folio_seq()
From: <wangzicheng@honor.com>
To: Ridong Chen <ridong.chen@linux.dev>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Ridong Chen
	<chenridong@xiaomi.com>
In-Reply-To: <20261020023548.3242028-1-ridong.chen@linux.dev>
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
Date: Wed, 21 Oct 2026 16:38:17 +0800
Message-ID: <179257189711.741142.157439930403322311.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792571897; l=7204;
 i=wangzicheng@honor.com; h=from:subject:message-id;
 bh=npX0BKN6Y9GvZwuJEDSaGDu/guxI30HeaYdlAc8oFy4=;
 b=f/voRK03GH3mF2PvO6wVcSA3sVC9Hyl29JaCthXME2KGgX+dm5PCp2A+PYPUdflUATMptZumx
 MLx9lDFGQT6BetMYWqkgUQGwiZ6QbJgJxl3oAT9hw8SjF8Rn+Xa7E0V
X-Developer-Key: i=wangzicheng@honor.com; a=ed25519;
 pk=g+Qn/iierc6RbauMzxguVPAh7jEJCJf1WMdMV9Kk2sc=
X-ClientProxiedBy: TW003.hihonor.com (10.77.199.161) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90984180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: em4onqwr5i6qzqpffd88d8pmgudhcjk3
X-HE-Tag: 1792571904-601064
X-HE-Meta: U2FsdGVkX19NPuh6JLZV0DS9JWhhCUyrDtaMUe6xGaZP7uzYvzGR9QFSoBj/RBQPSuSVLZ2fVcX7qbsQVWsijC1yavuR3GPQPQlRmuqxBhxC0ffQJ50ZkcGut/Ny2IMxUYsAm8uWqsCI0XldCLDOVr/YZ4VVK3oS3yPJ+pyhRRrqHh6DTaQSnoVst5rIN137mpgSHkNPZ+PG7ta5yHhpEIV0LZayDnTYPa+4v4gxMeqYpAeeR0FUuIymQtWGUYQkMw1UwYnLFiy85DpDH23AsuSrD0VAVlewt86weyJDLdifI2LPl197NdL+aBsEWMrs/o6tNRhhznOBBf1J5aG59vPIHqMmKQ7LAGj7GV9oofxZ9GPrmIRpVd792JHdxe/ZcbKxOX+NeRVLzM2DDw3fe4nqvXVUFrQWoXl1XKp0LsCaFR8e6lYuyXiamGkc/UUWkM4A93c1iMpqKsfjO3ItKoAQFt9wqOntKQXowD9hC+yzzCVbm1+/KwYPftUZAzeh+dH6gBFdUEnCT4Ry7N6ToVSxjW+/+rSZxpzouZAocilyIFkPe0N8O8J4DLml34b3qOSTvWnv9KmJPYVobAJ9DcTNiPZUDZfqs+oOIFRvZH/SzgbnMKMzFIxeSg9np7N15E/JulL3PJYyc2vJfWM+8WcV6XAAABW1CwOh/cwlhkx/qVZAv+PlY49kGcxyBrugB9c7YwiuR0P5Yh4Y2XpxW9C4w4Wty8OcrlLwUAJp1mu5PPjjYYsNRbxs6R4YUlNvbfD5FQYw4Zq/+LgN/sxs+a2QiiZNyLJUXbnvO/UFuMl8suaCmXjQHRMzePcf/040hQB5vJFln95q2YmeziHbDT7e5+ynfSSwazsdRV5sqOy20zVU46ORXMDgLfAMGtcuGXwwQG65qnXfvGZni0KgHNDTriTdhlGPIrAccICir62Bz509+NVwBly4jUmpzds2akF+aGvY5HEpIEC0ebf
 U+/R3NbM
 6N/m4ZiQm6DTxXk5yE7dIog+EiE0jhs9suehkmTKm8enTZETmV+npNQoWK+AcNjdMPZb7IwBNC522++TtU38+5VqbfXhys2sZ2H6Xu46RY6Q1bZrkH5k9BOq8pxD46hfVdn21qwXjACCAtV3qM6woLkqonFnrbLHNaLzZXFOWW9cSz+QOgMeke0+//u7QhvtBHIKbQ4Sk6W8HcBS7DadkR9sR6sA3AWj7wn9SJfWiYOBVjd+vDxk64qOnV7sgbhabPtKeoslK4UUyFHhfA2fVuQn02vHUrvT2ZATCyiOftlqza2tZsXnHymIea4aW8U84XxvgZpKTCCH0U0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 10:35 +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> lru_gen_folio_seq() computes how many generations below max_seq a
> folio should be added to, but stores it in a variable named "gen".
> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> confusing.
> 
> The comment table above the code also no longer matches it. It only
> covers the PG_active and the final branch, leaving out the reclaiming
> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> although lru_gen_folio_seq() never looks at it.
> 
> Rename the local variable to "age", redraw the table so that each
> branch maps to the age and seq it produces, and note that the result
> is clamped to min_seq[type].
> 
> No functional change.
> 
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..a933d8c14558 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>  					      const struct folio *folio,
>  					      bool reclaiming)
>  {
> -	int gen;
> +	int age;
>  	int type = folio_is_file_lru(folio);
>  	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
>  	/*
> -	 * +-----------------------------------+-----------------------------------+
> -	 * | Accessed through page tables and  | Accessed through file descriptors |
> -	 * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> -	 * +-----------------------------------+-----------------------------------+
> -	 * | PG_active (set while isolated)    |                                   |
> -	 * +-----------------+-----------------+-----------------+-----------------+
> -	 * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
> -	 * +-----------------------------------+-----------------------------------+
> -	 * |<---------- MIN_NR_GENS ---------->|                                   |
> -	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * age        |        1        |        2        |        3        |        4        |
Hi Ridong,
  
Agreed, I also found this part confusing.

One problem with the new name: in MGLRU a larger seq/gen means a
younger generation, but a larger age means an older one, so every
read needs a flip (max_seq - age + 1). Assigning the seq directly in
each branch might read more naturally.

Also, both tables run past 80 columns (~95 for the art in mglru-fg
4/17, ~96 for the redrawn one here, tab as 8). Would you consider
something vertical and shorter? I had prepared a comment for
mglru-fg, and since this is being discussed here too, here it is
(conditions are per mglru-fg, where the flags became the refs
count):

    /*
        * The seq is clamped to min_seq[type]:
        *
        *   destination     | folio state
        *   ----------------+--------------------------------------------
        *   youngest        | PG_active, refs >= LRU_REFS_WORKINGSET
        *   (max_seq)       |
        *
        *   2nd youngest    | PG_active, refs < LRU_REFS_WORKINGSET
        *   (max_seq - 1)   | anon folio not yet in swapcache
        *                   | PG_reclaim folio, dirty or under writeback
        *
        *   2nd oldest      | refs >= LRU_REFS_WORKINGSET
        *   (max_seq - 2)   |
        *
        *   oldest          | reclaiming
        *   (min_seq[type]) | otherwise: refs < LRU_REFS_WORKINGSET
        */

With a comment like this, developers can see the generation
placement directly, instead of working it out from the code.

Best,
Zicheng


> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * seq        |     max_seq     |    max_seq-1    |    max_seq-2    |    max_seq-3    |
> +	 *            +-----------------------------------+-----------------------------------+
> +	 *            |<---------- MIN_NR_GENS ---------->|                                   |
> +	 *            |<---------------------------- MAX_NR_GENS ---------------------------->|
> +	 *            +-----------------------------------+-----------------------------------+
> +	 *            | Accessed through page tables and  | Accessed through file descriptors |
> +	 *            | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * PG_active  |  PG_workingset  | !PG_workingset  |                 |                 |
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * reclaiming |                 |                 |                 |     always      |
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * can't      |                 |  anon && not in |                 |                 |
> +	 * evict yet  |                 |  swapcache, or  |                 |                 |
> +	 *            |                 |  PG_reclaim &&  |                 |                 |
> +	 *            |                 | dirty/writeback |                 |                 |
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 * else       |                 |                 |  PG_workingset  | !PG_workingset  |
> +	 *            |                 |                 |       or        |       &&        |
> +	 *            |                 |                 |  PG_referenced  | !PG_referenced  |
> +	 *            +-----------------+-----------------+-----------------+-----------------+
> +	 *
> +	 * The resulting seq is clamped to min_seq[type].
>  	 */
>  	if (folio_test_active(folio))
> -		gen = MIN_NR_GENS - folio_test_workingset(folio);
> +		age = MIN_NR_GENS - folio_test_workingset(folio);
>  	else if (reclaiming)
> -		gen = MAX_NR_GENS;
> +		age = MAX_NR_GENS;
>  	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
>  		 (folio_test_reclaim(folio) &&
>  		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
> -		gen = MIN_NR_GENS;
> +		age = MIN_NR_GENS;
>  	else
> -		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> +		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
>  
> -	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
> +	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
>  }
>  
>  static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
> -- 
> 2.34.1
> 
> 



