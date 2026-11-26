Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62076606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQr3SgNQ
Received: by kanga.kvack.org (Postfix)
	id 8C7A66B05B6; Thu, 26 Nov 2026 07:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F096B05B7; Thu, 26 Nov 2026 07:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B57A6B05B8; Thu, 26 Nov 2026 07:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 567146B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:09:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFB6316038A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:09:49 +0000 (UTC)
X-FDA: 85477151298.10.6AC395F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0986C1A000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:09:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQr3SgNQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795694988;
	b=sgX4dyek3Ih2y1Rg4IwWNPqQjL9wV08iidVeLBQXy5tzn96rr/E7HNd9hm0LdBZ69E6FW+
	1QXjo7/OsSXLJ8HwiU41dKgc5EZF1lt962oKCZwMNvne9Xdst8ZOS0vxT87YfeNUDBESlK
	KmRSuP4JoFmeJH8srAzvEIdiuHeybqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795694988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+JKvzGnMxlxThC9PfaTX+KOyMwuxYvBqRDEjjzOohQ=;
	b=cLcibO+06FwD6iqaAhEd1o3+ytDtoqt1cyLQYMcKj0Mw2j/vfOdC4+MtMRVUvALBNUNVXk
	KrwKxNNrM2xIneWRvu+ImUkqUIVsGDWqb2BaPgRqDRBK2EycKe6tPTGsvcOGBisiXlx3XK
	U+tYLDqXUzU+FkdOEqtmV7ullLKJPaE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQr3SgNQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 410AD4577C;
	Thu, 26 Nov 2026 12:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43561F000C0;
	Thu, 26 Nov 2026 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694987;
	bh=Q+JKvzGnMxlxThC9PfaTX+KOyMwuxYvBqRDEjjzOohQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bQr3SgNQfQAEZHGz+o97ehtKZmTADTK1Kj0izJYkEd/3ErC9S30REW4MIpK3i3bZZ
	 +z8sENqAIhOEPA1BQcT1qvru+PAcKptCy9tqZOhOJVaWBNdGaGDsZ3i2yJXoAucbdX
	 Lbv0JKYtKuZyCsADY3qyZwRs32ENRfwtXcvahdfWhQyk+xiWxGepKKFn+mkJHC62cf
	 vShICvX3Tf2agEBtxUMV7wBjXHSP8gkIpqc3Qszhvx0YrR4Topjh3CBNTMLXmft1cT
	 XFLdFt8Lf5EnVMdbOSVcuWwEC9qAhv6oZGSqLnm9GiT/+LaQt8011wyxCBtQxi/UU6
	 qPxn8J0LVtUwg==
Message-ID: <c0b75d88-3559-4a0f-957c-dd9d8748d176@kernel.org>
Date: Thu, 26 Nov 2026 13:09:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-6-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123053543.295467-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0986C1A000D
X-Stat-Signature: ectghdkiacg76mf4x9gtdjcyf495kdgn
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795694987-111987
X-HE-Meta: U2FsdGVkX19GYrFGSYZQkPKvjqi+glizrvUUH+FQe934o7xUlBBvYlB8WwuInkAqPlO29IC7seZ0Ep1YfIJr4DxJp4iHxEN8BX88BfEcOJcnelYLwXuHK5frrb/phiFlGltdQDg7EZ6+TsCfpNagFHIbdd9dtHjeuX5cOkiDKodb3wCYFfA8SzCH/RMPqaFhsSTc9jVLDbX4gIgl9NIa8OIpnx2ifXMtzukkk4Uaj4NeOfGSFoIWiItZdKYy194UwtAzNRKbxlA2CofKJaA7aLOzHSX2WR4UTcDo/49CdptANxR0AWXFGbqrkvIVm/oViY0qrgIQxRakbIKNJclOKhM4Q8Au48/t5OXUmto1poJRbXun2ivcaDhPB9Z7JGv/DjT0cZSaGI0SPpU1udV9sz7w8T9OzEUzq0KzwUIaZXQ/mjuCIaRlh35JVoADqye233ke7KuW2dpahtRlHPurOO43iHXKEexnp8XiXea2qIiCfsjk8j3Sik3jgHOohcOIRlVPOfXaNnIRqghJEQhlQgGgAIgqC3NPxgHBiw2d3xNn8KKV7Fo62vln0Qi+YFe7qQPZh73+wbLPeSPgw4bsOQyRSa9YdhMyZ+0JhiFIiukDJiUbl4Ca8BZNqbIrU5mMvQapRqEjn+AdshtfVpZWas0nEQvd33lhQGOlFIP+C1asPzs2JVzgaWUxnggG+HUdk15zcLwA8NB+NOrxsBwZh6AtlB14uZLBZs+jUkca1DQZwiKAj2s/OdLBEsGGpkJo2hn1uPXzlH/NCfG81V2W53hnqjtMrunOQ/ToWH7m2J4Br11Hnwgfoa78d8x/rZvAu+5ydNEBjNwUgtZV1REWtesxtaiFZGMhGdAlTOIsO4RymNUT75+Nn9tm1ZEqE0VSSjQt3zIGhYWK5TaV+PQ0Sl+U+ZvvEaxEvQ8hN4eO7ZHK8tbhSWDgQckvafqx9w6xaG7O4cf0npj6ZJEc002
 nMGAha7V
 pCyyBZLnfP7Hhwlm3rMsd9i0wafoSuFClKsnVDmz0+C5CcyStrBErQdGRyeQg4M0osTPldBTAJURbSyxABCVXM+DG5+11ON6+aHVOBe81H0UKsIv1ViXHfyLadKS5RseWL4SEpNKoxee/TGun1kCvcjHZmRRKO3qFYBC2gsxnaG7k9igk4VyJ7aqqf2ACqQgHMqAe2ifTa8SPFpQLwOV5bEcZaKUiFY7hTT2CcnJvvSSDgS7ry3Zw45cqi5BS+18ygtBcE726tTIo1wt4XOCv7A+oXjQLz4AHPrIWuH0uhtXs/4BoGrXWgURiybOqAgtRlqUKNT+O7WXOMpm0gvh3mBWEULHK7Gd4X3DbQR4bV6hutbl7OYFGHeHI9rSAXKP/Z5OAvAUeJOW6x8B20ieMFUoMwOlqSdKFTHdx49rpagBHdmqOD7IDvV1un828iN+UoMdeyglbYTwPl8YZ+tpRxmq/it//lCo8Av7YiLfCIKTKicBeFAFDgSobLkMgZRHME1XWMq8K6MNz2x7txmriU4LNYm0+stn5atH97quGhDMxvPQMwwF/MMUMc9FQJKTtyaMn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
> In preparation for adding a helper to set softleaf PTEs in one go,
> generalize the helpers that advance a swap-entry offset so they operate
> on softleaf entries.
> 
> Softleaf entries use the same type/offset layout as swap entries, so
> advancing the offset works for swap softleaves and PFN-bearing
> softleaves. Preserve soft-dirty and uffd bits across the move. The
> swap-exclusive bit is meaningful only for swap softleaves, so guard that
> preservation with softleaf_is_swap().
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/internal.h | 31 ++++++++++++++++---------------
>  mm/memory.c   |  4 ++--
>  2 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 530c022117ab..ae0c37ee3406 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -480,16 +480,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
>  		unsigned int max_nr);
>  
>  /**
> - * pte_move_swp_offset - Move the swap entry offset field of a swap pte
> - *	 forward or backward by delta
> - * @pte: The initial pte state; must be a swap entry
> + * pte_move_softleaf_offset - Move the softleaf entry offset field of a
> + * softleaf pte forward or backward by delta
> + * @pte: The initial pte state; must be a softleaf entry
>   * @delta: The direction and the offset we are moving; forward if delta
>   *	 is positive; backward if delta is negative
>   *
> - * Moves the swap offset, while maintaining all other fields, including
> - * swap type, and any swp pte bits. The resulting pte is returned.
> + * Moves the softleaf offset, while maintaining all other fields, including
> + * softleaf type, and any softleaf pte bits. The resulting pte is returned.
>   */
> -static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
> +static inline pte_t pte_move_softleaf_offset(pte_t pte, long delta)
>  {
>  	const softleaf_t entry = softleaf_from_pte(pte);
>  	pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
> @@ -497,7 +497,7 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
>  
>  	if (pte_swp_soft_dirty(pte))
>  		new = pte_swp_mksoft_dirty(new);
> -	if (pte_swp_exclusive(pte))
> +	if (softleaf_is_swap(entry) && pte_swp_exclusive(pte))
>  		new = pte_swp_mkexclusive(new);
>  	if (pte_swp_uffd(pte))
>  		new = pte_swp_mkuffd(new);
Do we want to check that our softleaf either is a swap entry or softleaf_has_pfn?

I'd document that and throw in a VM_WARN_ON_ONCE.

Apart from that LGTM.

-- 
Cheers,

David

