Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40378C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3E36B00A6; Tue,  7 Jul 2026 10:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155576B00AA; Tue,  7 Jul 2026 10:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D046B00AB; Tue,  7 Jul 2026 10:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D30FD6B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:26:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 497E0A0358
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:26:11 +0000 (UTC)
X-FDA: 84962205342.13.19DDCBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E97840006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:26:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGl6sOyk;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783434369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCVwdRoQOoP+N6WsXBwnYD4SR1Rf4w9pPgdBdTS1BFw=;
	b=K2p9aFL3JizStJIsZOmyS1UggnQN8GJP7Ak2tFl8NC4YQWNySkzn/jyJoNMD//pPGK/beK
	smKs8HHl5YRWgbc7/typ1dILgKDhqGshkZSPn0hi9jUaKj7l4G8DB1t17rIlC8PGR+lZh0
	enNrp5bP0UD+jX1g4fRlTpjzuSSmxXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783434369;
	b=NkF/L16zQh50+YTCb8ifeGH6tkDWaWbQLPFaaA1llrEdMR99uDup7kQRn6QtYjn/Gtptk+
	Qm9t0d6bVF/77TQY/52nnRId/DFHoZRHrXsCjmcWfmnLEMvizrUt9FeN9GKoIo4FUjFtNK
	EKAu8//qZX3kBx6OZSe78Qs1jmlFSDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGl6sOyk;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86E1743C49;
	Tue,  7 Jul 2026 14:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CA01F00A3A;
	Tue,  7 Jul 2026 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783434368;
	bh=PCVwdRoQOoP+N6WsXBwnYD4SR1Rf4w9pPgdBdTS1BFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OGl6sOykpiKuUGpPHYNW3WsssRjASb58n/v+6w4wigNQnm45sUm2cXaKSfDidrUzc
	 3TMlGcU+6HxYy/Jz0JrMmF0OXfYgOwsVli/Au+F95g7+6yZqMB1dzhm/kT1e7TAhaF
	 wiWO6tTmG+eE7AMFB2xAgFpPM69bTpivyA2TtibNIODXgjpLPDpwJfFTxpW5YU1+hX
	 QheZ8hXHu3X3v9IkQYbhwGTa8myw0VrgXcri6E12B5sXkN8KaS5NMP91RUY/lr/U7w
	 +AUgO3bx8yrsyWyqinrp/OtkE9SGuDz8msiUUTfvnvXCfpj7tF+M8ZJA1+Z12a0d28
	 5r6D8VDXA1OhA==
Message-ID: <1221180d-6217-401f-a479-3a5d9684659e@kernel.org>
Date: Tue, 7 Jul 2026 16:26:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/rmap: refactor anon swapbacked folio unmap in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707121128.373192-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E97840006
X-Stat-Signature: b4kadbnq6dyj85u1otyzh7ibgikkqtb7
X-HE-Tag: 1783434369-553877
X-HE-Meta: U2FsdGVkX1+DQOK91RHx08mzLKLbc+Zjk8rz+T2wtW3SvmGkORLnx+inhOZ53SHDVEdLdKx2OpxMXtXuxhHnsirDMfGBGyMKFqTyxLECMI6tOYlswoQQj9nwmozSxTQgSC2gOvKQMDRaECjOHOzbiCbb79YhaOzcjL3eaPP+lBHYa9Wbw87TUnQVocUoiAtsL8AZgluL09Bu2TORfOq36bEFR4VMh585SdVShVKtJllNQOXE12fr2DTPKsdxORRkXgP4zfWDNmnpDqRM8hCq8xVy0zL+sVnJ5gonF+yZqtfVotAc2E6iIC7kYSAozmdAMPHnsUZCJJcS6b27eOSK8BH6o3Wn2iqL5VQbkrw2In8xtg1308M3m50gC8At9IYUqvMnfCETUjoBfxUWJiJ/C7tH13YgiCQqHOep46uvTzZYsDawt3EG6HUTJ0afH5zgj55GCZ/yNcgL9WUWkPwdClAU88kK7qMhEsRyL0kv83ZOCGTwQ64MYfRBpgzVAWNp4PgxU7tBBF982Ek5ZR0DZ1lz1Tfg9ME0gvTewZ78kARwZea8CSp8jIXgrn1i5lYblbB03JlEcCPLLYIL4bhGOberO4auaTcZNxfCSqdqmNKDfNhxF9wq9HV9Wp49GirrVK8uji5/XtLms2xRQu+IpDVmEjVqhYCXnNmmawUHEunus2B2xfnALut+KP7oWW5zFFzaDLvLOqU/m7XQcgalKGdYFrgMqg14KXjl+0Zg8xye6+1v5uvo0HUEclpx1y56i36OgTy6Hl+K4FFNrd6SzfqSq2UWDzSEM9iw2R0SVCqro0X7Y5BHmNeq83l9ocCssCvvO78Ollp6uPkBjq8V+XRrwwJpkDDkjej9ykVXnYi7MrgcBLelQ5kpvXzAaaEYwMAap1FTsrGOpKFt6r3jTe9HHMuwty8E8nUHYJ8Bu4uCi8dDbAHJ679MYfmeN9P+hNsmkMxPB3bVDGyQwSj
 kLW5YZs1
 0tb0nxKFxUmPHI9g43a7FPUIpWfy93pp7HelyI7EyJrvqyK2MPAlHzn4HQIAC2faJY2wlbK10hHtuySsVJ6ckCLpojmuXaYtAl6skOxCVWUx5X7aEOg3W7zPmuGlhyMrFMIcaHOdFz3GBvANhz5BvQBcu9RHNW6zuBEZRk8fresAakzdC9qzuVGL5f3R4dKqT4/iIF27A0YjiNfbgFLDkShdzjkudo2xAorI4GOowR+Elro2y24JBIz/3erSQyG5MsZxg2An5JwnxoJtqHrMwi4fk95E42I+P9HAHuBHKkOc3o4CfNdEUgV6OY2MGjXf89PpoQuyiCHEgiYmbh77YaGHZlKFP8mWeBJlxaUsyF4qTsJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:11, Dev Jain wrote:
> Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().
> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 105 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 62 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 00b571c2a1bab..ade78df5be2bd 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2113,6 +2113,64 @@ static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
>  	return true;
>  }
>  

BTW, no need for the "inline" for most of these functions (applies to other
patches as well).

> +static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
> +		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)

It's confusing that we say "set_swp_pte_at", but the pte_t we was is actually
the old pte.

Can we instead have a function that creates us a swap_pte from the other data,
and then do the set_pte_at() in the caller?

static pte_t swp_pte_prepare(...)
{
	...
	return swp_pte;
}

> +{
> +	pte_t swp_pte = swp_entry_to_pte(entry);
> +
> +	if (anon_exclusive)
> +		swp_pte = pte_swp_mkexclusive(swp_pte);
> +
> +	if (likely(pte_present(pteval))) {
> +		if (pte_soft_dirty(pteval))
> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +		if (pte_uffd_wp(pteval))
> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +	} else {
> +		/* Device-exclusive entry */
> +		if (pte_swp_soft_dirty(pteval))
> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +		if (pte_swp_uffd_wp(pteval))
> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +	}
> +
> +	set_pte_at(mm, address, ptep, swp_pte);
> +}
> +
> +static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct folio *folio,
> +		struct page *subpage, unsigned long address, pte_t *ptep,

Subpages do not exist :)

> +		pte_t pteval)
> +{
> +	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);

const?

> +	swp_entry_t entry = page_swap_entry(subpage);
> +	struct mm_struct *mm = vma->vm_mm;
> +
> +	if (folio_dup_swap(folio, subpage) < 0)
> +		return false;
> +
> +	/*
> +	 * arch_unmap_one() is expected to be a NOP on
> +	 * architectures where we could have PFN swap PTEs,
> +	 * so we'll not check/care.
> +	 */
> +	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
> +		folio_put_swap(folio, subpage);
> +		return false;
> +	}
> +
> +	/* See folio_try_share_anon_rmap(): clear PTE first. */
> +	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, subpage)) {
> +		folio_put_swap(folio, subpage);

I recall I stumbled over this before, but there is no way to undo the
arch_unmap_one(), right?

> +		return false;
> +	}
> +
> +	mm_prepare_for_swap_entries(mm);
> +	dec_mm_counter(mm, MM_ANONPAGES);
> +	inc_mm_counter(mm, MM_SWAPENTS);
> +	set_swp_pte_at(mm, address, ptep, entry, pteval, anon_exclusive);
> +	return true;
> +}
> +

-- 
Cheers,

David

