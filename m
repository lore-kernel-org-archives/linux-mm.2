Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA60ECC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29E36B0088; Thu, 15 Oct 2026 11:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDAC36B008A; Thu, 15 Oct 2026 11:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3646B0092; Thu, 15 Oct 2026 11:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0E9C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:48:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51E0E1A02F2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:48:27 +0000 (UTC)
X-FDA: 85325292654.11.8086565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E4ED4000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:48:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbmIPg3M;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792079305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKYxbZUwVotNEVMIbNl0nivjJJ0OoZD4nTbemWC4y4M=;
	b=lr69RRDBzVmFxYcQ1AxX1gVIyleSwPrhyZFTIMtUFyCOCNOHSYjPvQ520kxSnLqzsWmUVl
	tHOL2LWCROsX2GGCtJ3L1D4wrFjRVJi58UMQcbvdxrL9vTQ6TnNxYLIG/8OBV02PRNG/it
	hM9VU3FZJpW2o/cDeXYuIjD9kvwIPe4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbmIPg3M;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792079305;
	b=E1qlfc5xzBXMFdOYZumDup1WLJYUsNWyRu2cFyqycQDhbRbpwHd6OLA8KDPmkDNbMnIj8p
	AA/jOXvR3GOAzdgiMOWNW3PG++9+O0kGd6q08bC0ACilkhiPd0Bvppuj1oWDY7tN+3Fi5o
	iKknrgo4zY/muopwTmyGoF7nyEj6V7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5723601EF;
	Thu, 15 Oct 2026 15:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACC11F000C4;
	Thu, 15 Oct 2026 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792079304;
	bh=KKYxbZUwVotNEVMIbNl0nivjJJ0OoZD4nTbemWC4y4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NbmIPg3M1nE3t0SveamnjAch6hz4YUVyRo3Lmxk6mjby6t9kleTRe7gTyNUZe12ha
	 BjmbVMW7+w4ZZvddeg1U7zVqRhplVFB9wY/dJAqnr+R2ILmqliDeTcA3Ybs2idt/lV
	 OE89VnTiuroc9R8SkifPKah08UeOe2N0P2KB0Fn8gGFDdK5HfbExVOqzUwRgogXy6E
	 8QyG2sd+NB4s/CQZ6vfBb58ay703XtCQikPZg26WCfpxVlz3HYRClHZMYZhpiZkjOR
	 vPDpyuTg1N1+kr0dBXwFTuGczz3D1mza4v6BO2/XjwW7RkDNe2ii8ejQsMC3Dg0xHo
	 XshQYVliATdCw==
Message-ID: <79b299ac-a588-43e1-af46-e69d8b3e7aca@kernel.org>
Date: Thu, 15 Oct 2026 16:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/huge_memory: deposit a page table for a special
 PMD copied by fork
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
 <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-2-85eaec8417f6@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-2-85eaec8417f6@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E4ED4000B
X-Rspam-User: 
X-Stat-Signature: ka3afs7sagmnu9cd3gmmo85jhyo6qb8a
X-HE-Tag: 1792079305-994136
X-HE-Meta: U2FsdGVkX1/V+cqDzwvwTQV+XH9MBQd3wBTmgoRzw4Az/hIy0HZ9ir5GakOB4se/FK0H4IUmqalOJ03G/tVt5n+EGfpOP1mBV3sMuvUT0X/U2Q/2BgNfQdP3s9iS/18WewbE4/axgdsY163CMZSo2lj2oyujVzbRpyh6mzxyxa3SMftskuyzdP1c8VpdEQq12n8lUbk4fZuY6s343+gxtcYVtvlA+juT8Xzj83o0sRCDXgisQCUOoCQtP1ENXjBWetTGhwPeofP4XWYRnGhsnsN2SoWDaVAI/hd0wymqHH8KnNJfzeERIu8LNta83DMt1iwbCwDKmt4QFkfXfRLpr38OVO8QdW3kQkNT5lsCtNYl+T0IFyOBwMdL292+UhRWhnGDscNFUo0JfOsu8GD/sn6JDk9OzWnqLd/ea+J1cfe3AIZxVgGhXhw02MlPJ9/O8cfuo96Z0yko/S7pOsAJ7PO7InqchMlxeOJJ8ZD8/QQzrFBoyqCfERYSBICbRqHhtEW3B98TTM9n+wgNHH5HEcycDV1iNNsvjt56Lazhg2g8pncgkkYqzJEKXB58r8pSdIuN0gT63A8RZ9m8CyIXO0Ed3J87sAsYRNggqvhCr9BBPH0PknacVx5kcuaQy0UrwHhG0Pc/swDDCa81aC6GSTwwbQWKFeRB2H+gx85Ky5EADidd5heIvHlydXhUljeCT3cnECZbpFexWgU7je8O4D+DuztZkZCx+3N+ccyc3WyDJKXy0TN/kaXncrJNNVmst+41Noi5taQzbkIPjDEP7d2CTbO7yw2L7ny+SaLXKQYzCx3akKOCHJCXHbj1A94j/wlUBAX0j/D65ZOE0cS7gAGvRrw49s1x7Fg8okjmtHie91lbZzNZG/VbcJozypDAmVf6gi8ANa9FkTtimFmiGnMqlVdlqr9QIU0UprYV20cUuCN4vJIYUfhV3ltZPN2VLZC8TxzzC+flVlaywSb
 a4jrJxyq
 LkGGnPB6rr5mXzmRt3j9zP3/HHrc/HN7Y2UFu77xG3gMWDCfjQ1rE/O7xtclGlB31adcEAJ00BTQqPBn3N//IHzUycAC6BEMZIYY0qgwYUloHT23Nndj9z9uNpH4RV5vnuU6HjGjX7rrbV5pit1ajDipLrcXgPL1s/cOBq2XSd+YiIlEfyPmrsRbiHzDmTXvJXgiEmKm8bYa2R1GYTCbY57vduHfJ3Ard+ZRfr1MYdstLfXae6qP1+WsNKFkZ2bEVCiykyCn5Rr+oDdBO5kTscWXsaQOvhGU64S+MoqkxtilHj0k7oerpQb90lfhvuQIGuP50YBfnUggND1QBh3lrj1z68BFRRdZerLMdpqSTIeYBq32gEbI1BKZVVVhztjXeUWuFxFMM1DDPQDHHmbWO2mWUl+rlshTzh3VKPtCfHzsP+Z6Okw90gIdZx8s4rt8rle3fyMcIQu+ZIv5D3Uj5PdJltfY+3+9JJ32A4xqcQpSFlXZCVJ6jsBcR1MMer/EnE/1lxjc6nW5i/es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 17:46, Konstantin Khorenko wrote:
> Where arch_needs_pgtable_deposit() is true, every huge PMD needs a
> deposited page table. ppc64 in hash mode keeps the hash slot array of
> the huge page in it, so vmf_insert_pfn_pmd() deposits one for each
> special PMD it maps.
> 
> copy_huge_pmd() copies a special PMD into the child without a table.
> The child then dereferences a NULL table:
> 
> - on the first hash fault on the PMD, in __hash_page_thp();
> - on the zap at munmap() or exit, in hash__pmdp_huge_get_and_clear().
> 
> Allocate a table before taking the page table locks and deposit it
> with the copy, as insert_pmd() does.
> 
> Fixes: d1503aa9ab805 ("powerpc/64s: Add support for huge pfnmaps")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  mm/huge_memory.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf788bb231691..2380e4e877f82 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1961,6 +1961,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	pmd = pmdp_get_lockless(src_pmd);
>  	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
>  		     !is_huge_zero_pmd(pmd))) {
> +		if (arch_needs_pgtable_deposit()) {
> +			pgtable = pte_alloc_one(dst_mm);
> +			if (unlikely(!pgtable))
> +				goto out;
> +		}
>  		dst_ptl = pmd_lock(dst_mm, dst_pmd);
>  		src_ptl = pmd_lockptr(src_mm, src_pmd);
>  		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> @@ -1974,6 +1979,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		if (unlikely(pmd_none(pmd))) {
>  			spin_unlock(src_ptl);
>  			spin_unlock(dst_ptl);
> +			if (pgtable)
> +				pte_free(dst_mm, pgtable);
>  			return -EAGAIN;
>  		}
>  		/*
> @@ -1983,6 +1990,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		 * wrongly write to the backend MMIO.
>  		 */
>  		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
> +		if (pgtable) {
> +			mm_inc_nr_ptes(dst_mm);
> +			pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +		}
>  		goto set_pmd;

It's another sign that the pmd_special() is just entirely misplaced.

Let's get that sorted and it will just naturally fix the other case.

-- 
Cheers,

David

