Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94066C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557D46B009E; Thu, 27 Aug 2026 12:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F436B009F; Thu, 27 Aug 2026 12:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446A46B00A1; Thu, 27 Aug 2026 12:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C05586B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:54:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E43381C0042
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:54:19 +0000 (UTC)
X-FDA: 85147647438.09.44A7F41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3751614000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:54:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1mbqkIR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0EijgfI0VhQhjrOTV+mfho0EuTlFA7vhzH58UT/Nl4=;
	b=FsB/rvz3m/xn0KqBFgi3pMuTExBX5awBlFIJfRhgA++LRNT1lPwbh4HIJIOBtCsPKi/IMc
	CbJt0dtudWVvdj5JgpsNtXWBlw6pcZ5FvH8hJGLi30HW4EqJVGDdQp8tU8cUrIqn6erdKF
	2p3pgqtYyLmbSW60IgeM9I6EWu24B2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849658;
	b=YHOuMoiKH59rnFJ/zh4Xl8uTmv0EI4+goy3fkZzN5jA9HGZMhiP/G6JUA/FMVChvisRhHC
	jnz5mn76NiH5gZwceuEn73CuZCWFF31/10IKAbps/hiwm7gejWwoDd4SrvvJcL4jRxWAWX
	6Vcs/4IkeZuA4yjIBVRdej42oYaUxaU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1mbqkIR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6C7E600D4;
	Thu, 27 Aug 2026 16:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557821F000E9;
	Thu, 27 Aug 2026 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849657;
	bh=/0EijgfI0VhQhjrOTV+mfho0EuTlFA7vhzH58UT/Nl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q1mbqkIRp/j8VBTOJgQerAlZU8RI7OgMeuHkcQerXu9CaZBcqP7GmXXu/I7HJd4UV
	 nvesbXLzUiwZJILNPf+do8UBEBx2LlzwBCFJV4eUzdKAYa6h5uSoIJ84Zkl7QawPdb
	 Kb57R5YJkfKxgl8s56xglIX1+EAU882cbnWtS827eSn5DSGlkG9lEqkYhhD9v3zSq5
	 2+oobrJHgm0lDln30e2YrGv5zDLds5wuUgPLaGHKREyWeNjoSp2hDzL3LqPskXtk87
	 6BlFyemKV7gEye1DEnBcLG5K4Wy24J50jRxArPG3d3ew4VqgxEQT/pzACBPe6X8kKD
	 BxcsE9VUob95w==
Message-ID: <f495537b-90a1-4d22-9281-d1074af2ac1d@kernel.org>
Date: Thu, 27 Aug 2026 18:54:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/18] mm/huge_memory: clarify supported split orders
 in comment
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3751614000E
X-Stat-Signature: k9auzw646wrtt4kwfqhqfjwdh9tcgent
X-HE-Tag: 1787849658-456708
X-HE-Meta: U2FsdGVkX1/y0rEqx8PHs38QcUBcCKXdtJtos68qUi2hOOltc2Jq3o5lwU3tiyegZsBdAKee8qxILqcp5Yr6SXIbKzAbmUnm983/M49pvxvzMyUlZekUx4Ihd5Up6cZ69LdCgnP9NoXhdFtvA/IfB4qDmZdivjssp505+I1a5Nr3dnZnvxY9TTeDDkl8fBFcnHSOLyagnZwiaqdgGQ807KkIRijF8/Y5L+mrEmKbpsMtWTPksYdcVcqfQb6yI0jzoIILgwYbZF+WndSIw0hhp7anPdRXDLgttxNuyBy8UGxGxpRLjuCTblrF+pkkS5C8rtjRpYiFJC+2Zlu0fbWUMdbZSo2i7Z3ybeoodbvp1UJOKLxsjhQEq4PPz4Oop+OtFEVN2dEfcU2JkuqEZXRQAEK7yF2K8YvKEWDWkNAUYcJ1yiejPGRclECBMJCIa4+U2zHr9fY69slO4VgW9BPDxIs8qnRt6lp9jfp4LaIXtHMQ9mgw7IEQrMahxKIT4qoCp1EEGCXNBV/WC3z5LTXnvMBTksArAtImfS/CgCAond13cwEmIFdIIgH711PmLE9jysYK4F38jsR29zVFWUdru7s62UwYGhBtdihaECdb7V4wIIjoGVBGZIzfKyLmGBujfG3SvmVg8LMBZ9+rVnEP7b4IUk0xYsd6xf/tLvAtoAx4dIKvdOfmHtoOLyqH+cUpAYftUFwBpIMET65Irlu4UU3rXl2EzqldB0r6Hiyhnwi3rFnazb59MBatYXwOzcUnidrFR1f2PeRvyWBNdqPVeGPV/94aqIC6IP072A6lnY8w01F68IqvVfasC4oZOjCr/YLLAI/dGBEy2jDZvIHA36r5Loy1m5k0lxk+IO4A9PxaBaBMmPFP0zS9JLtVkAWBKPCsAKn3q8+NPDt2UG3v0UKFLL9A+3hDnKHa+if9As0uEBLFq9R/IAxRgTcdDsTRr9jskToThcygmFXxjGc
 WNEnigzp
 JRr43EogPLEp0W+GB9r47fWNrxuUsw8ur6wtB246ve2YuQQFhlnxXTEshXhzLgqJI0vduiNaiCfFiLunnBM1LSAQR7A9ybhToqBHsmw0bt/LXmO61Ws/WgQ3h5oSJ3X2ow+wSlV2dqUMWJHyT0cuaBizitsBf1NQT+O4qCMkswjYXva7zLYTfSlFer4rhBiM0bImNM1AMgPKQswKEv2T6v+WwUwG59zFQxO+x07B6ZrRvfpbk3Qz/WEkmdvQkVFk+vkEzfzNJdAXqDVCY7tBDV8zzG2WrKfxAUza+yxjpCvTmB9d5YAeu2EpwDi3RzPsGyG0O9zafJA7ye+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The doc comment for __split_huge_page_to_list_to_order() needs an
> update: only order 1 is rejected for anon and swapcache folios,
> matching the new_order == 1 check in folio_check_splittable().

I'm confused, why is that not updated in patch #15, which also updates that comment?

If there is some preexisting inconsistency, the comment should be fixed before
patch #15.

> 
> Also realign the continuation line of the function signature while at
> it.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 06f353f937d1..0a971ca48151 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4400,11 +4400,10 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>   *    GUP pins, will result in the folio not getting split; instead, the caller
>   *    will receive an -EAGAIN.
>   *
> - * 4) @new_order > 1, usually. Order-1 is not supported for anon or swapcache
> - *    folios: anon folios need subpage 2 for _deferred_list, which order-1
> - *    folios lack, and a swapcache folio may become anon once faulted in.
> - *    File-backed order-1 folios are supported, since they do not use
> - *    _deferred_list.
> + * 4) @new_order != 1 for anon or swapcache. Anon folios need subpage 2 for
> + *    _deferred_list, which order-1 folios lack, and a swapcache folio may
> + *    become anon once faulted in. File-backed order-1 folios are supported,
> + *    since they do not use _deferred_list.
>   *
>   * After splitting, the caller's folio reference will be transferred to @page,
>   * resulting in a raised refcount of @page after this call. The other pages may
> @@ -4432,7 +4431,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>   * with the folio. Splitting to order 0 is compatible with all folios.
>   */
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> -				     unsigned int new_order)
> +				       unsigned int new_order)

These functions should all be concerted to double-tab as we you them.

-- 
Cheers,

David

