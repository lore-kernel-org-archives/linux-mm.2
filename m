Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A117CCC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998B86B0088; Wed, 14 Oct 2026 11:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970556B0096; Wed, 14 Oct 2026 11:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885FF6B0098; Wed, 14 Oct 2026 11:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675576B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:38:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04036405FB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:38:07 +0000 (UTC)
X-FDA: 85321637856.27.C066763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41C57120004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:38:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIwfbI0t;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992286;
	b=0ITaG/ziFf4yR8itJ6DWdBP/Ii3w07WvnxRS7sUbiV1RjzsUGhAKreLTLnv2SgEfjyAwLe
	1BbS1xYhEmOp1h3qw4bnJbxmmDkkTuQ32NJVx3X6DfgCHBgcpC1vwszsjiyW9fsRsqfSdw
	DZuxDQWHbSstmrPkznwkIU9AhSv1tQs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIwfbI0t;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovHBYbcBVfimIe8eIAVC5wulfBTP62i70vORa5b5ogA=;
	b=jci6A/aGMUlvhU1ePsMIr0dOesU/4Ip6EflFjobUBi6Hi6MC1FVKkbm9GEv7p6aR7D6n2M
	RKA/s/eVJA+b+DV9F3xsj9AcF6ZZohFUIEMOd/Rs4dpDdaZzwNAx8LDjJKUBoivzXONsA9
	45e0v9WW3guj5f5Ey1g4IUHmY4JrOuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36073403E6;
	Wed, 14 Oct 2026 15:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1E61F000C4;
	Wed, 14 Oct 2026 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992285;
	bh=ovHBYbcBVfimIe8eIAVC5wulfBTP62i70vORa5b5ogA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XIwfbI0tm0ACdckGwvsEBkJRpeZAVoo0Z32DQrUoOFZcHwSY8TWZaYye3wWEgpO5B
	 OU7t2Uy6e3aD3Xh6jukKRqrVockHpcBY269mio57JdUrm5mBevYtlvollmaNu7RbK5
	 IGZ7ejU75rAcRvm1p6BAZ12Lv+wE9v26HpP24KDEkvUvCMy08CojuMyogVxNb6ey5r
	 hr9L3b14eST3c1C4g+DXO1WjIiFbZJlZP+ZTVaarlkLJRB2WFqLd9l89qVud7yj2vz
	 lEt6OuXSM4M8jaNP7lAh9kbZGObS8nI4P1InddjPqH/HmJioyXFSQWUzz2pD2oqjW5
	 PWz/Y7F/CPPNg==
Date: Wed, 14 Oct 2026 16:37:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Minchan Kim <minchan@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	stable@vger.kernel.org, Samarth Narang <samarth.colleges@gmail.com>, 
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
Message-ID: <as-dr-S6c3FALwQb@gremlin>
References: <20261013191719.95502-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013191719.95502-1-pfalcato@suse.de>
X-Stat-Signature: 64ihuurtg5tpkpf8o9914mbs3uuao3d1
X-Rspamd-Queue-Id: 41C57120004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791992286-708855
X-HE-Meta: U2FsdGVkX19E7P+iaT5xA9MWbgtfU03oqrG0CQoZSZG5CreC2Udt9hhyndwK+z51nNHg1pLOHavZIqG3CuUv5dd8AuojXcyKQCesM1meqneKY2BLpXNkc0HnTBeP+VQF7cWeMP3xYEc9z2TT8fo1goXmxkWyX5FrS9hClaNdkYwjcxcxvMQXZIc4KY5Qs5qvRdMxEmxXydBdoLi2Dq5Sx75uBNpZjzQfImD5EdfpSJqrmNpPKqNNj3YTwLQuEG+HFURVaRHkI+g//SOHoAFFqwmvCAx5dFO07MeoN5fKX4pJDmYMsQ9E3VfkUOvWFHt0PF7+Ugit/SlcGeqrM8DH1M/gRo9Mi+0hHNM7B+45qeMO2/A8nHnxAfMUDR+kIdaQbv3JAU0niDQY7GG2xf8WiIf5+jzAPZAPIelb58ncow0V8UV7DzM91+ZORgRLoa9OTLH6Znb3xq1Zr+DKYlWYK9aAkgjJLYEmnd/K+L2U9PvCoBHD6lz5w3bhFGu4IfygkAuko2QX8ZXIS78/HeLSokHf+QjbxC0jTnRsj18qLDphCQ3wyBd0pM4OqnW2B3r22ZVqlYnqXd1VtthKo22ulIfUaByYHl8Mfpzk7QAL7dhvZxy9R2aJQOnjjAkBuMqqXHGiCJSH7KYr6w5T4RlqBlSc3AF3Ynezka6r5RKR+bBuTEPoXcYwWBLUJok/Ai2BD1xmgQS9vvqRKQHGTLidAgQ0Nf+7o35kqtmNHRQL+voilS8xYu1BilqORabXpd5W8S5hjrj+xSbv5uVbh8HXCJhV5LhFzW7eFa8a5wuiS2PomMLRyVeAoLfCDpGGj7jTP8hxSjHyugEPheh0IUVjiJNV8YltdzYtnooiozj7ZhRFOL5uWVkaXuymX0KUz+p2T0Xo2FUnWn9+T8JnMIG9eTpr2XiKyfwMC3OaKeGvfUkme5ur9EW8bA/kcli40NslnFqL9/k6FRbKqbYdTGH
 HCKaLrHJ
 T8CkAgtvid968OpbZQ/Z0sCgqbB8s/QZ2b4QhE8HiEsk60pwhC2m/LbVVugO8ITuh1gD1skmgf2X2kvcRvSkkdFzUiu3bv0ULaamarHFfN9jGAUAi0Lj4hD20KPw87haPMABem1qphjRy9WRt2SKWthDx9m44S5ER1IcTvAcFRzxoKeYsYg+ghZRIM2ycG2V+vofKBza1Ait88GhC27UvtnkBgFfy33kR5U2lsJkkT2ObgTtmmx/El5D2pknNBizVFI7ZyO2mZnGUKKUTR4VHAXKlR2oNAuyMeBj0m92YwmActY/SgZZ3Lfs4XKOtuymLCorP/j/pSrM6IoeUh+d96ETrM7auq/XDOCTBHd7IhxWJjHkmkm/5fax5Nd6uXAP+k1o3YVhN+EZyGZ86qyLo/ZrUffqc0PKw0Oq/RvAl8Va4fV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Gregory

On Tue, Oct 13, 2026 at 08:17:19PM +0100, Pedro Falcato wrote:
> As-is, madvise_cold_or_pageout_pte_range() discards the hardware young

The function from hell... Gregory - PLEASE FIX THIS SOON :))

> bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> to the pmd again. However, it does so in a racy manner, looking at a
> possibly-stale snapshot. It's entirely possible that a write elsewhere
> set the hardware D bit, which this logic now loses.
>
> Fix it by using pmdp_test_and_clear_young(). This is an atomic
> modification of the PMD entry, and thus safe against any possible racing
> writes. As a (nice) side-effect, this elides one non-required TLB flush
> in pmdp_invalidate().

Nice, I'm guessing the tlb_remove_pmd_tlb_entry() does what we need already? (as
discussed off-list :)

>
> This bug can interact with the swapping system in complicated ways, leading
> to data loss. For instance, if a folio is marked lazyfree, but was later
> read from, and then MADV_COLD'd while racing a write to that same THP,
> dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
> the "clean" anon folio:
>
> T0                                T1
> ================================================================
> MADV_FREE(thp)                  |
>   folio marked lazyfree         |
> read(thp)                       |
>   PMD marked young by hardware  |
>                                 | MADV_COLD(thp)
> write(thp)                      |   if (pmd_young(pmd)) {
>   PMD marked dirty by hardware  |     set(pmdp, pmd_mkold(pmd));
> MADV_PAGEOUT/reclaim            |
>   dirty bit may or may not be   |
>   set                           |
>     reclaim/pageout may drop    |
>     the folio                   |
>

Thanks, nice explanation (even if the >quoting ruins the indentation on my editor
:P) [untabbed for my benefit]

>
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Reported-by: Samarth Narang <samarth.colleges@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/madvise.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 85ab9bc76e06..19cd3bb4d1b9 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -431,10 +431,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  		}
>
>  		if (!pageout && pmd_young(orig_pmd)) {
> -			pmdp_invalidate(vma, addr, pmd);
> -			orig_pmd = pmd_mkold(orig_pmd);
> -
> -			set_pmd_at(mm, addr, pmd, orig_pmd);
> +			pmdp_test_and_clear_young(vma, addr, pmd);

Lovely diffstat :)

>  			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>  		}
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

