Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A1EC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D7D6B007B; Tue, 29 Jul 2025 14:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E04D6B0088; Tue, 29 Jul 2025 14:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7FF6B0089; Tue, 29 Jul 2025 14:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48BC96B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:15:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF0591A0147
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:15:16 +0000 (UTC)
X-FDA: 83718104232.17.1245E8C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5411310000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:15:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4vtOIB5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753812915; a=rsa-sha256;
	cv=none;
	b=GlqR5WQQAMBkbMkusAR7aexBr6SdbJ8J8r0Nae/SHCtoFxgBFflcaAb7rTDyCF6GEEr4/K
	auRO8MunnWB7q4SnPBZaCAHPnOmwFWYeEamQ2CCSa0GqU4ICXG7n/x1DMSF0j8bWEkXPpe
	j7ALnfl0kEpT0GzkvkwnTJnJza5RWU4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4vtOIB5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753812915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyVBvtKU+zLoM/d9XpJsoQEkDVqP1PsxdrNsqCOp7iI=;
	b=gR5SV1XjLKKdc+JH5NeJ0b27tgTEUyP4B/Q/dIDa/HRmYzr5XywPa5zl75CD5FuLZcCseY
	XU9Cq0dVNe6QxODnAn/q3AyVZ9269HGj3CCFFpwMjMH0sgYw1C0tci1b7czQ7UBm0uiIne
	/vWX2DdRpQPKfJtCvHgS+YSkz9iIxTk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 86817A54816;
	Tue, 29 Jul 2025 18:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DF3C4CEEF;
	Tue, 29 Jul 2025 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753812914;
	bh=TZBXNASe2pDArkZUxLGfDiu3sHbEqjRKTJxrS5ouBFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4vtOIB5goB0G2wlEpeI5Fr7i+EoWJ8c2jyBLUs/g4xSJrX7T5EDUNm/GeORWt8lN
	 O6QZ1bzxPmee+Kyx0SCq6Yn0fCBdqimJL99tm9FG+TIqWijEPg4N5yNIOdabvM/RkR
	 8Mg40E7YPj8cMkto4MLdbB7oWrJfKbGekJwUPEp38Zkxly9g8mOb094yEdGTy3B+ef
	 F0HmC4djkXyrHOfqFbZtrv3Rv2qCHtlcTC1YVlzlP3B505aWU49bxMMuYJ2mZfORBn
	 yBPv4yLzzCnQjtUl4sOr78vy2soY3fdtb2MgdJKYxBzGdxiGhEl4laSs7DOZrUEBXr
	 pw7CGR7wAtTYw==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 11:15:10 -0700
Message-Id: <20250729181510.56035-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bd6xmmm9cuhghsdwbmr71fm7j83db6mu
X-Rspam-User: 
X-Rspamd-Queue-Id: 5411310000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753812915-720799
X-HE-Meta: U2FsdGVkX19FlTf48ZLmu6q8Nd8Dz9hBqK+nI4dGM6NSrRfc9U/RgbldKA54vZS3GC2t13l5hcFTeegipTgzLoNm6viV3/f71G3QvswL2Vq7kIy5EpjlEKFXDokas15bGf6NYmsQWbMbWiV2AudOKg/wc1SR9rLr5p+755KWEH0ZVj6yHPitH3VfMvF2JonPPtQ5O6t1kH/O9KvzuvdQJq22oep/rTTXRS/pe+FwVKmHuJNIDjDel5Mhn5vGM2GDSH3tQeA2ekxb5JtcIBXuZ6zQKEpT6qbo78RTcWXG6cxy1ZAjFRE7ymur374n1IUfnB9ailsCHp2mkd4qFvKj0+eKKPnu6396E+QYUVmQSuY+VLkoA6ZZA+LhwFeF6JB6kRNxdzUY2t0QpMIPIz4nzWalMCRbjrF9ALI8/ivaGFhq5c3NA7Og7ZL9cb6F9vsZt9YeIxppoIIFvwz8KBw0+t8mzBcQ0DA9VDVB/8gaFdkMSJp/a88rU+g8XUUUHMMx2f0OrhptayIARygmmsqhMH3nPmpUWE3SSQeFtvzUNgQUDrfkXRHtbAwWVase6TkjeycMUzaS06SeMn1mGOSbRb6ScsDf59TFklzvhLFMtZW2EaehCI1YP91nP3aK1FGLTSDTLzaty5UfsImePCPbpNuNEAa19i+UfwuFIxwF7vNej/iv5NIHG2k1cYrw1+RHXo2CkYsl8CtcKYpMcPNo5Tjw8SfxTe+Jw4hAucvclvA+U5yU0aNUNnU45uUfohl4kPISgM2HJfw3Y8GNCZJ4oFb5ez1xLQgoLki3VRRsKXViHD6zj0kW8phEHVK9Aeji8a8yKfmBDmYXkiyw+vsuUMs5Ur3VZW/nR0+a8lxvjkETq5/tqBHSodPEEWNjZmsXtx5AJm7w4Ly+LIjNLznL6ldlNm2u5UwYDVmdIcCfIeM0O7ncwPbcIBR5C06rewsKuwnzS88+svKVP91Ki40
 96Nglymx
 1z6qnzK8dIKaPdsQzR4lUxC5M5DOfem472agrwLyHc9gTJkHEIq4KfF1S3POpYdtbzdx2f58WgeZdvE0BN3rWzX/7WJYXvFs7NOyoH+/qsBr2w80+C7MMHGsdOE0RsyI78vIPbAY4oDqCePfks0flQJrZgnU7f9NTTcnmzs/LRcUqOyl6XELBaabOV90IoV2NCheEvmVRf5oHGOmGq3wxks2HwtCWFyCid6MY7yfG+BUHWUtfQrHph8KxC7A4YreHJhjheoMY1Hj9lIaYvl99Q70nNNQEYHpsYRdBypr1KQ6UvZw0cj89Z74x/4yw0elEOnhc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 06:53:30 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> From: PanJason <pyyjason@gmail.com>
> 
> This patch adds support for damos_stat in virtual address space.
> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.

Thank you for this patch, Pan!  I left a few comments below.  I think those are
mostly insignificant change requests, though.

> ---
>  mm/damon/vaddr.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 87e825349bdf..3e319b51cfd4 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -890,6 +890,117 @@ static unsigned long damos_va_migrate(struct damon_target *target,
>  	return applied * PAGE_SIZE;
>  }
>  
> +struct damos_va_stat_private {
> +	struct damos *scheme;
> +	unsigned long *sz_filter_passed;
> +};
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long next, struct mm_walk *walk)
> +{
> +	struct damos_va_stat_private *priv = walk->private;
> +	struct damos *s = priv->scheme;
> +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> +	struct folio *folio;
> +	spinlock_t *ptl;
> +	pmd_t pmde;
> +
> +	ptl = pmd_lock(walk->mm, pmd);
> +	pmde = pmdp_get(pmd);
> +
> +	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
> +		goto unlock;
> +
> +	/* Tell page walk code to not split the PMD */
> +	walk->action = ACTION_CONTINUE;

As David suggested, let's unify this with pte handler following the pattern of
madvise_cold_or_pageout_pte_range() and drop above ACTION_CONTINUE code, unless
you have different opinions.

> +
> +	folio = damon_get_folio(pmd_pfn(pmde));

As also David suggested, let's use vm_normal_folio_pmd() instead, and drop
unnecessary folio_put().

> +	if (!folio)
> +		goto unlock;

damon_invalid_damos_folio() returns true if folio is NULL, so I think above
check is unnecessary.

> +
> +	if (damon_invalid_damos_folio(folio, s))
> +		goto update_last_applied;

Because we didn't really apply the DAMOS action, I think it is more proper to
goto 'unlock' directly.

Oh, and I now realize damon_invalid_damos_folio() puts the folio for none-NULL
invalid folio...

Because the code is simple, let's implement and use 'va' version
invalid_damos_folio(), say, damon_va_invalid_damos_folio(), which doesn't put
the folio.

> +
> +	if (!damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd)){
> +		*sz_filter_passed += folio_size(folio);
> +	}

Let's remove braces for single statement, as suggested[1] by the coding style.

> +
> +	folio_put(folio);
> +update_last_applied:
> +	s->last_applied = folio;
> +unlock:
> +	spin_unlock(ptl);
> +	return 0;
> +}
> +#else
> +#define damon_va_stat_pmd_entry NULL
> +#endif
> +
> +static int damos_va_stat_pte_entry(pte_t *pte, unsigned long addr,
> +		unsigned long next, struct mm_walk *walk)
> +{
> +	struct damos_va_stat_private *priv = walk->private;
> +	struct damos *s = priv->scheme;
> +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> +	struct folio *folio;
> +	pte_t ptent;
> +
> +	ptent = ptep_get(pte);
> +	if (pte_none(ptent) || !pte_present(ptent))
> +		return 0;
> +
> +	folio = damon_get_folio(pte_pfn(ptent));

As David suggested, let's use vm_normal_folio() here, and remove below
folio_put().

> +	if (!folio)
> +		return 0;

As also mentioned above, let's drop above NULL case check, in favor of that in
damon_va_invalid_damos_folio().

> +
> +	if (damon_invalid_damos_folio(folio, s))
> +		goto update_last_applied;

Again, I don't think we need to update s->last_applied in this case.  Let's
do only necessary cleanups and return.

> +
> +	if (!damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL)){
> +		*sz_filter_passed += folio_size(folio);
> +	}

Let's drop braces for single statement[1].

> +
> +	folio_put(folio);
> +
> +update_last_applied:
> +	s->last_applied = folio;
> +	return 0;
> +}
> +
> +static unsigned long damos_va_stat(struct damon_target *target,
> +		struct damon_region *r, struct damos *s,
> +		unsigned long *sz_filter_passed)
> +{
> +

Let's remove this unnecessary blank line.

> +	struct damos_va_stat_private priv;
> +	struct mm_struct *mm;
> +	struct mm_walk_ops walk_ops = {
> +		.pmd_entry = damos_va_stat_pmd_entry,
> +		.pte_entry = damos_va_stat_pte_entry,
> +		.walk_lock = PGWALK_RDLOCK,
> +	};
> +
> +	priv.scheme = s;
> +	priv.sz_filter_passed = sz_filter_passed;
> +
> +	if (!damon_scheme_has_filter(s)){
> +		return 0;
> +	}

Let's remove braces for single statement[1].

> +
> +	mm = damon_get_mm(target);
> +	if (!mm)
> +		return 0;
> +
> +	mmap_read_lock(mm);
> +	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
> +	mmap_read_unlock(mm);
> +	mmput(mm);
> +	pr_debug("Call va_stat: %lu\n", *sz_filter_passed);

I don't think we really need this debug log.  Can we remove?

> +	return 0;
> +

Yet another unnecessary blank line.  Let's remove.

> +}
> +
>  static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		struct damon_target *t, struct damon_region *r,
>  		struct damos *scheme, unsigned long *sz_filter_passed)
> @@ -916,7 +1027,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_MIGRATE_COLD:
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>  	case DAMOS_STAT:
> -		return 0;
> +		return damos_va_stat(t, r, scheme, sz_filter_passed);
>  	default:
>  		/*
>  		 * DAMOS actions that are not yet supported by 'vaddr'.
> -- 
> 2.47.3

[1] https://docs.kernel.org/process/coding-style.html


Thanks,
SJ

