Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA45FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD686B0005; Tue, 14 Jul 2026 08:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD57D6B0088; Tue, 14 Jul 2026 08:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6EA6B008C; Tue, 14 Jul 2026 08:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 723476B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:40:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 344CF403D5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:40:53 +0000 (UTC)
X-FDA: 84987341586.09.F4A9EED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5332B40007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:40:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPz4aySG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784032851;
	b=3TN7QYhTXHEJIDYkss5TfPkzvqVzSO3VnI08LGO+wsRSoyNerxjFySHCVnFlaeTUWPVYuk
	VnXnz7cRnORRERjvJfLszSx89P97dtMHjVeKbkui8f5tS3iSUBU25+Zc1Kj16u2ueWOIDD
	bsqUeo7fGJCyS53A3mNwUL5iqd1knQc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPz4aySG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784032851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0rBPlTsEzRp/Ye+ZoX2yRP8RB6n0a6y3H1XZFG/zxI=;
	b=QhGR3fJHCPGS8rL+ozlGKr/N+VqYETzJH8aQtIZE6PPsEcWy7z101xDInreEKa8nHkiKlg
	hVtxUpo6caSEsoPsabfGIu2c4G8VJbclnYbkCBn6GdjJJoPg2rLOwuXmTszQYOqkFzQies
	cqS+vfeA3MS6xROwOJ1yP+cph74+HJU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 700024016C;
	Tue, 14 Jul 2026 12:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB61F000E9;
	Tue, 14 Jul 2026 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784032850;
	bh=R0rBPlTsEzRp/Ye+ZoX2yRP8RB6n0a6y3H1XZFG/zxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QPz4aySGSAume9/oSmDGYSYrt1uHtR6upDLsBahbkseVZ/IVx9/rIzGwxzvoBVAvH
	 rSpbPdwm2XiuC5SDy4lXJNyUK/dVdV5KrPx2DpDpmJUsHjD+uKoDKf6MudCteNpkGR
	 xXv6GiQWIGmfXj8FFxr4zMe6iCRB4QXasJPkB0r/fa3HdBHQuDDUiwJuYGD4FwJbju
	 rAz0Z9LfenKPgQpQw/m5bkNWenXgluEbk9GCLEeQBEaM3lQxIuDfssEN9gxwwMHwIK
	 EsO8uWWyET6r4x/KlS1UxquBMwI/SeFUY/BzFDlpXWNv7ycK4RCNxFnVCrpCh3eCmT
	 wSCo/obj0mtnQ==
Message-ID: <be2fedae-8caa-4a8f-9ede-cdf735e64357@kernel.org>
Date: Tue, 14 Jul 2026 14:40:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] mm/migrate: split remove_migration_pte_hugetlb() out
 of remove_migration_pte()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: Karim Manaouil <kmanaouil.dev@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Kinsey Ho <kinseyho@google.com>,
 Wei Xu <weixugc@google.com>, Bharata B Rao <bharata@amd.com>,
 David Rientjes <rientjes@google.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
 <20260712-migrate-rmap-batch-v1-3-872a734431d1@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260712-migrate-rmap-batch-v1-3-872a734431d1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5332B40007
X-Rspam-User: 
X-Stat-Signature: dm741iea95bmnmn15fiesxej5qutgcwu
X-Rspamd-Server: rspam03
X-HE-Tag: 1784032851-621146
X-HE-Meta: U2FsdGVkX19dsLGlyJhqn46iQWJGsQL8nv18pndyLLIDbz+eQ13YISAS7kmPAfzH+RVvcrVkqsPb4IaLUjpdaEWRDVR0keZi+MNnVHD8D3OjyLYLGA877XlD/mf8TPAT9aLsIqLT6qMcuxKBKxkutByVRgZAxkdTPiBlsuB1WO4Zb2yAICnLnOEzZhX0/bfX0HfXkE5WyeEl9vXLyRx3cJe25uPsQqpKjzTimnxb0P/vtojp9jOB6KNd8bWElmrmBP2+GlSH+1oNvrNr6wGyzHFJu4Iu8/99wK2G9zX2gl14uNFvWUKTiUh37eWYtsgsi6WZMUyPPeGsgFaR/0ys9WeZRoih61hu7Joa0PbcVcWInAB3irGsA5gqtNe+StKwlo5ugDulKTLR01I2W3XNzzCuszvNqd4u6cGXQ6BrlVILb0y7aUbY54uYItrgnrNAkvVZ78DvTz7V8o9fGUIWzkGjU5C9xWexSZFZY87a79qcJNFQHNkwhujDVepwMv8NqYs4mwL1DRtiziUId3tjZ9o7HH2LmAVAEhP71ZiyKndy9Mr+BaqzVjOw2ukr4dDNPiRajU23SkpBXeHn6tZapqW0tRwbfdDQ118/9Xp2x+01Rj9ppsqUF2SLzOrMeazfUy9AlqBDcpPD5SWc4bp0XjwGzXMaEFfbpW+PVR+43j0djy7ZtkvjH5BV0Km8fbfM8+wSRXTc5ML9tWACO9RB0yvbavJA4kWZXl76B8AnEYQe7amHGf5KTAGH3UVmxUVSc4qcuqoV26TLSvsdqZZxBbaiQKlEYqKw3GRPMIz1B9L68GYYc5PHHYJ9VnfbmsGN7foQ4SURT7DQLERvH4OvRrsQPrL2Nd2mCK5nDqe1gYE9isCyTIQvvs7GELWEeNQB7vRsexQDc0bXEYvLVnRjWJeqf0bi9ztVQQ4ezOCn8QP3AOsn3/4znpOQ+9H+vgj7mSpxw6MYIFZy1g/N4c9
 Dz4BW4Ts
 ph4YIAIz55nVdQSFyn1P9gwFiD3R30Cz4rjIM6MWQASJ5K2utRbf54BF9DOv8MPHVUHwk67OAswD3LykuWsSMOGKMXGsWvr5E/XLMBx7Sqt4FxTs/Po3Fli/9zQx2JiCR16YV/DNNlkcQFhT0kBU4FTsPsRhQLkdbr5WScUaqOcdbqMVUq95o0zKwYV+tm2VRa/VGXsG2dGJEE5icb6uEuj2EOd77oLzNC6mAW5akujMSGygZWG1I3YGf7/4dJywt4cbrIi/iLyqjDZwgOt3R3xy6vdaGnwn4bmK+cYwpX/MB0CmYUAcQ7PViWsM1b8QCLwPYOhNQina4iAcFlNvagiVlsGT1pb0y06n1LQrLJqB1jsGeLh8nBKsVuV1xNWsMaf/JponCFR1TsUtRijSULwY1FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/12/26 09:38, Shivank Garg wrote:
> remove_migration_pte() interleaves the regular folio path with the
> hugetlb path via folio_test_hugetlb() and CONFIG_HUGETLB_PAGE
> special cases. Simplify this by seprating the hugetlb handling into
> remove_migration_pte_hugetlb().
> 
> Factor out working-PTE construction from migration entry into
> migration_softleaf_entry_to_pte(), used by both paths.
> 
> While here, convert the VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO().
> 
> No functional change intended.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 153 ++++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 98 insertions(+), 55 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 222c8c15f782..8a098402b8c9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -345,6 +345,89 @@ struct rmap_walk_arg {
>  	bool map_unused_to_zeropage;
>  };
>  
> +static pte_t migration_softleaf_entry_to_pte(struct folio *folio, struct page *new,

"migration_entry" should be sufficient, right? It implies "softleaf".

> +		softleaf_t entry, pte_t old_pte, struct vm_area_struct *vma,
> +		rmap_t *rmap_flags)
> +{
> +	pte_t pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> +
> +	if (!softleaf_is_migration_young(entry))
> +		pte = pte_mkold(pte);
> +	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
> +		pte = pte_mkdirty(pte);
> +	if (pte_swp_soft_dirty(old_pte))
> +		pte = pte_mksoft_dirty(pte);
> +	else
> +		pte = pte_clear_soft_dirty(pte);
> +
> +	if (softleaf_is_migration_write(entry))
> +		pte = pte_mkwrite(pte, vma);
> +	else if (pte_swp_uffd(old_pte))
> +		pte = pte_mkuffd(pte);
> +
> +	/* See do_swap_page(): restore PAGE_NONE for RWP */
> +	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
> +		pte = pte_modify(pte, PAGE_NONE);
> +
> +	if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
> +		*rmap_flags |= RMAP_EXCLUSIVE;
> +
> +	return pte;
> +}

Can you move splitting that out into a separate patch? IIUC you can do that even
without messing with the hugetlb stuff.

-- 
Cheers,

David

