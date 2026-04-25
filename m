Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 738B4FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE6A6B0005; Sat, 25 Apr 2026 01:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E8E6B008A; Sat, 25 Apr 2026 01:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3018B6B008C; Sat, 25 Apr 2026 01:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1676B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:48:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9182FA0278
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:48:13 +0000 (UTC)
X-FDA: 84695997666.12.3FF7860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C262A0004
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:48:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=thmNnp1Y;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777096091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AV1g9Sat2a/9+oVe3xDX65z/aFyH5b3s+05X3o6F9K0=;
	b=D7OzSoP+Xzh36ShCAZaOIV30H1Yup/l6i9LDOhecAeqWGUYYPCQdOOEs7ioFoX1jpGHg67
	gqCiYyiPffHOgfm7FEWXAtmhQUyDYXwK5EcxYLzTCBV7Hred/aiKFrhA3HiwwjdaCP90UT
	kmVdsqqjCjJGnuGSdpOkwul4AiWiJIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777096091; a=rsa-sha256;
	cv=none;
	b=2rYlV3Mmf2SmwMmaOEaw0fJVr/y8kYN/nEbEZil8zNDvP5rP7v5mrzGyUKZ16xNYM4Ckcd
	8Hj6hVogCrMi9YE4aif1HiOiGZJu5qgZY0vncsscQSPn0LlNbrmvnaeZBTZdIyCsaAQBzR
	kvMnE8yqPx7wiAwn6nF9M2ZuNiZE2Dc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=thmNnp1Y;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5958440925;
	Sat, 25 Apr 2026 05:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0166C2BCB0;
	Sat, 25 Apr 2026 05:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777096090;
	bh=TFZoT4ewW+EPY1kuAmOC4+PMIwzgunDufK7tVV63EtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=thmNnp1Yn+JoZRSrZrnw31qyHr0rBUVFdo5m+quhGp2LjGFrYFb4UIPF/Wx07E2aL
	 azR//5GhR+f9zh4S3NoiamDS6ftW9JO848KW3AR3TNBsbS/jAW2gFooLe0AUAeQPpm
	 whRl5VUTGjXRQYFrGWS76ZiiuHhZM50Zghz5WrWK86bcZGnVwwdXYWHxn2WiXMVkxQ
	 cmaSwx8B7u+0WXo1g+SxrNWFU0gYpRsmmjYujpX3BDnRSkJDzMHdfwIPBRpkD1gt/a
	 wK5WWKU4G1A3OxYbp7L4ZVo6uX0DYE90Xq3DikbapSu94miVg8RWYrkr3LMupRML4e
	 rg/FpCe4XsDdw==
Message-ID: <02e35414-8c30-4753-9403-432d90263f39@kernel.org>
Date: Sat, 25 Apr 2026 07:48:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-5-songmuchun@bytedance.com>
 <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
 <4C6CE53F-918C-4D03-9DBD-1745E28A2D9E@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4C6CE53F-918C-4D03-9DBD-1745E28A2D9E@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C262A0004
X-Stat-Signature: j37bstr1p4u7u1ouf4t7ytdxqnfu6yd7
X-Rspam-User: 
X-HE-Tag: 1777096091-240438
X-HE-Meta: U2FsdGVkX1+Fz6sP6WjPXhWJkUYwEHJexALEwdOpjcRv5YMcfCXaU5yuiMouLtbZKE0GNO2OhPzX0L4nuFc007fGXH/49TiMU61BlqFolkCDxTJO0rUfQP7LfWSX8tGK5AhGBFza/uCpsTijtaNttEghmGwQDS4LIpgTVqIDGotD8sEbeI/5tEjz6BLIJVuRRweCwcjDHSrpiq6mbRuTkl6zrLkznJn80Sdx8AVW+e0ncRaKkkJTup1ER/PbJNDmWB+fLfuiRloFoGyMf4VB79W9urdwnL4t29Sd/AwtX5OoaXpJzzzwYMKSPeU4/eQBp1trR+yNpbsXoL0AQ3XaxtD1Uf4uPoaFOCicfqIytHNe8kJ1COjEXzLwgcW09IRy/bPpMHKEY9p2WJYx7SMZdUlCN50TYK+CS8nhfZXKR6+C5Fh4IzfB7A6YMHpq3LrBmsg4UR+Hf1VjSC1hzRoFpCUX66ez5J7s1e3qPVaJA4or1rKXINbP3g4x97qfp4H4G2PBjB0tXRkuafPf5Is3Xqrv1dl2pejKItzuoJjm7vjdQxiMZBWwtKWl6brPrtIVuAEOXcriF9NoDDz04BA+By3Kir9CMZQlLM643LlIT4IRYXMXEkHTM+9nyH3j/WBC0ekaFJwRSgDzVolmmYlAz27GJrgSvXBqZqTNFWwrwiGmytw1ZUBlqpiBVW0sh9fSpLG1vTXRlOSlsd7ODoXjVeGAto1WXulW06fJja9BLrcRjxuQCjvh1sssI4djManj+EObEYtWhXe/5glc+AOADUvCnaIGaTi4YohVuEYU1cQznIlO0mMV3QFC8hZfvlYzR9zd0cl4fxNS8gh8J2Vv/mCnIywHyISRt09e3W2tDUzz6DroxiNbsc9OkNnISLq0Krhybx86Bt79fj4VznsScAaz6ZFFd35ZEarOgqgwN5X2YR2I/O42qMBLHskdkWZqc60ai+job4BU9bFju3X
 C84N2kno
 OWTC19Yx5RtHPv/ZBHE37pr3IHbzVXpGni4fYrNvDTFKFs5viI32S0ogkpxDMrKc+BLawvHuG13tRMT+BYypXWquxIohKdA40/s+dSah3IDsUKmC3v85EE6ynipoEVPbWMnEhZufiPm0nyK991CYBXLuWfM2DTln5yEejY1SgCaM29G2QVa/Kjhn40iG/Mjpqd1hCztKhyP9iHBWT8LCvWiB0laHYOq80pAlTGPHRQHjcJGqfhi7274ns9QFENqL2aG2U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Hi David,
> 
> Sorry, I missed the 1GB hugepage scenario earlier. Given that sparse_add_section()
> operates on a scale between PAGES_PER_SUBSECTION and PAGES_PER_SECTION, the pfn and
> nr_pages parameters wouldn't be aligned with the hugepage size (pages_per_compound),
> but rather with the PAGES_PER_SECTION boundary. Do you think this explanation makes
> it clearer? In the interest of code clarity, do you think the modification below
> makes it easier to follow?
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 2e642c5ff3f2..ce675c5fb94d 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -658,15 +658,18 @@ static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long n
>         const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
>         const unsigned long pages_per_compound = 1UL << order;
> 
> -       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
> -                                   min(pages_per_compound, PAGES_PER_SECTION)));
> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));

That here makes sense. We can only add/remove in multiples of PAGES_PER_SECTION.
I think what we are saying is that we want that check in addition to the
existing min() check.

>         VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
> 
>         if (!vmemmap_can_optimize(altmap, pgmap))
>                 return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> 
> -       if (order < PFN_SECTION_SHIFT)
> +       if (order < PFN_SECTION_SHIFT) {
> +               VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
>                 return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;

That makes sense as well, within a section, we expect that we always add/remove
entire "compound"-managed chunks.

> +       }
> +
> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));

And this is then for the case where a 1G page spans multiple sections, where we
expect to add/remove an entire section.

So here, indeed the "min" makes sense. I guess we also assume:

	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);

Looks better to me!

-- 
Cheers,

David

