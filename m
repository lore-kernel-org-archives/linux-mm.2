Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A72DC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CDF6B0088; Wed, 30 Jul 2025 13:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBD96B0089; Wed, 30 Jul 2025 13:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1B16B008A; Wed, 30 Jul 2025 13:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1F46B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:56:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8DDC1345D4
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:56:58 +0000 (UTC)
X-FDA: 83721686916.22.D3BD093
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5133C1C000B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:56:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FmhIB6rw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753898217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYgfJDyz2xwIXG5cQAozKpj0KEiIL+nHO0Hr7irD6zc=;
	b=IedunSWrRV4UdZh1Ax9jLPgcsFAhaCnmJZvJri6JDu/Te8BBJjb7VCDI34pDScHn2VcOxs
	xLe8h9li588N2rqoUnScB694VmGRNX2R+rZgYLKpYndX5NkAeaDrkafxNQlMO9tTDT93k6
	RyoU7md+Iuw3zu3WdLUaRyEs4AUuwFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753898217; a=rsa-sha256;
	cv=none;
	b=48tEYR0bSKnP115aAZcCRUA8gO/Kd5dvGpas9qoZpH93c24Nvd5J3QIXlO56m1eiIK3Yrs
	PsDi/Hmcl69kWxEyzPF0z2ls+D9udeIAPQanltphd8DqDUdVNrgHZA66DPagOB4Uww2puW
	GINTV2SsHIQxvmW8UiczXNYvfFo23L0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FmhIB6rw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2BC865C2609;
	Wed, 30 Jul 2025 17:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1176C4CEE7;
	Wed, 30 Jul 2025 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753898215;
	bh=LxlL3e6vR/HG4aAeNYWdTWRtYhjSKsDeB3n9zodRNKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmhIB6rwEPaQO/Kz2XplzMkph3aNpT/mO8O9r3oM07r1u2d/KSkOmLDTwvIIVGs+9
	 qrS9w9JcKtrEzhSH1eZVWTCgNdV9WqCbiFnGSf7fpfPJ9a1uXtQg2rnucfQbXyH7vt
	 YpWeppA9eHbXki8P8Kpsuduy5rbUCSW7J3KH6wJ2gIXeNhmmVgjlC+aUguWjnEBVpI
	 Kw5w8z0hcK/sfavGU6AsLX39TbLvXrJ+6c0x9xv3m/kukaKKBgFDqbSLuU1VS9paIp
	 Mv37T8M6Bslm1zXa+gB5/ar0I71926sLzi6DcZRFjDj3mqUvRiMt2PyTVVnlwai9uj
	 aqDRnYn18lDrQ==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon: Add damos_stat support for vaddr
Date: Wed, 30 Jul 2025 10:56:52 -0700
Message-Id: <20250730175652.60173-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <c05b1b4f66758c0154e4d037adcb15c43917f38b.1753895066.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5133C1C000B
X-Stat-Signature: 8bst39kwia3xkhnrt7p9p79ppdpihg7b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753898217-327498
X-HE-Meta: U2FsdGVkX1/cleOrJbXOoKhlV8sQ/ijjCV2+YD8Eah0tm4K7wRqK1I024FBcluKbTF/oBzODslw6jSJw5JVXxmIbUjwhjmRSHUTScmqPnSNTTopGVA6XCMd2h+PNBR7kMRB59Jhh2crn3shQbxRNA21QV9nw7aIcrYdiG9pBZF8oqlEtmhq1j/X5aLBRWuiB/E+cIvRfHj8CLnBessvKyPrfRIA1Owg7aj+HwqSMcIqYObD/fDHBcxDhcsyuntEKBzOpOfPiwMh/7mlPRV5CAveKvOMs3jRjxHoMJR2RnZjf1yU+S5x2sZbMRu0GP/isc5TzqaVMetViXzuVSC3lknayC8eidJp3kHx0svX7/ay7iceaEGouqNbPuCrR7opugXegY+8cBs8JULFP9c1EOZ8DrhACrCZuhxEh4dz/ZsvW7A3ykkS9OjSrR3OUpJKk0POS+gwHvZnLU/Y7ut5gVyZDN4f0CeEhpAteeRtFaHibpw0mQdq/JgMYmsIr0KCKZOf6VLeIQ5aBBucXqkQ45g9WytR4epLDIXdCvM/DCkzVxzxJrjeIA5Gvyc7aRrgYosT3pmNXOgFpEKilJWSkkAqvdaN69tnr7e2x4v0Mf/fxTQHJMHmDWTMeOs8N6+DG3Yz04aSXw2n/NpngauLGfCtsFLRpHLfoY9hfUh6G38XLAmdomup7jQmqlwf6JjpeISOc9alBm8VNeKAmthxwWbCI3bFbVZ/+wIBTsRM5XwQYvuOsR6iYrF/PX6rE14BG5iZMqmh/CAscpiVx7Oz5Wt4aEi+xtJJEnAJxdFWn5TEkXfVSHCSinKaoOS/tYvDa60rt7+al5umHuRNodt/dLTxxoyBOBFlE/kL0VBbAcGRPmJjmsTjaEzm+vdLawOGot9jj+RNfsU22riaM9p91/xsMjdk/pJH+47OJhaVBKi+bbQY8awyT8Vr7sBeEKRt1hWQA9mdvBYBNjYTRp9g
 ad9AQxY+
 YhH7OBdR0R8Kq+7ze3qAr3ZL6cDSIpm06TuRaKY66d1UR8J77HFCybmeHtN4vw7qeYvfmp33OPCgKspwmVfD2U2LUxHvsghlO7U3LlLG/2wh6c8epGxw9/iovefbB8LHomtMGlKc5J66dlhLsbVYJ2FxAMbqc/Lykiqag3952B6/OiKYasnYR9tgCmYzWQefOpX0zsvLOVGq7OaluR6E1DmeYzUgH9tkziQ73TH/8CJoNHOFsfnPG3R8Du4IURDRgO1edoAsXLKzoqeOOshphtfhiIYvfYv1yHgM9ZN32N/5XD2UX320mYOOx/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 10:19:56 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> This patch adds support for damos_stat in virtual address space.
> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/damon/vaddr.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 104 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 87e825349bdf..6ed919e817e2 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -890,6 +890,109 @@ static unsigned long damos_va_migrate(struct damon_target *target,
>  	return applied * PAGE_SIZE;
>  }
>  
> +struct damos_va_stat_private {
> +	struct damos *scheme;
> +	unsigned long *sz_filter_passed;
> +};
> +
> +static inline bool damon_va_invalid_damos_folio(struct folio *folio, struct damos *s)

Weirdly DAMON code usually keeps the 80 columns limit.  Could you please break
down this line?

Also, the name feels long to me.  What about damos_va_invalid_folio()?

> +{
> +	return !folio || folio == s->last_applied;
> +}
> +
> +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long next, struct mm_walk *walk)
> +{
> +	struct damos_va_stat_private *priv = walk->private;
> +	struct damos *s = priv->scheme;
> +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> +	struct vm_area_struct *vma = walk->vma;
> +	struct folio *folio;
> +	spinlock_t *ptl;
> +	pte_t *start_pte, *pte, ptent;
> +	int nr;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (pmd_trans_huge(*pmd)) {
> +		pmd_t pmde;
> +
> +		ptl = pmd_trans_huge_lock(pmd, vma);
> +		if (!ptl)
> +			return 0;
> +		pmde = pmdp_get(pmd);
> +		if (!pmd_present(pmde))
> +			goto huge_unlock;
> +
> +		folio = vm_normal_folio_pmd(vma, addr, pmde);
> +
> +		if (damon_va_invalid_damos_folio(folio, s))
> +			goto huge_unlock;
> +
> +		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
> +			*sz_filter_passed += folio_size(folio);
> +		s->last_applied = folio;
> +
> +huge_unlock:
> +		spin_unlock(ptl);
> +		return 0;
> +	}
> +#endif
> +	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> +	if (!start_pte)
> +		return 0;
> +
> +	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
> +		nr = 1;
> +		ptent = ptep_get(pte);
> +
> +		if (pte_none(ptent) || !pte_present(ptent))
> +			continue;
> +
> +		folio = vm_normal_folio(vma, addr, ptent);
> +
> +		if (damon_va_invalid_damos_folio(folio, s))
> +			continue;
> +
> +		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
> +			*sz_filter_passed += folio_size(folio);
> +		nr = folio_nr_pages(folio);
> +		s->last_applied = folio;
> +	}
> +
> +	pte_unmap_unlock(start_pte, ptl);
> +

No strong opinion, but I'd like to drop above two blank lines (one after the
for loop, and one after pte_unmap_unlock() if you don't mind.

> +	return 0;
> +}
> +
> +static unsigned long damos_va_stat(struct damon_target *target,
> +		struct damon_region *r, struct damos *s,
> +		unsigned long *sz_filter_passed)
> +{
> +

Seems this is unnecessary blank line.  Let's remove it.

> +	struct damos_va_stat_private priv;
> +	struct mm_struct *mm;
> +	struct mm_walk_ops walk_ops = {
> +		.pmd_entry = damos_va_stat_pmd_entry,
> +		.walk_lock = PGWALK_RDLOCK,
> +	};
> +
> +	priv.scheme = s;
> +	priv.sz_filter_passed = sz_filter_passed;
> +
> +	if (!damon_scheme_has_filter(s))
> +		return 0;
> +
> +	mm = damon_get_mm(target);
> +	if (!mm)
> +		return 0;
> +
> +	mmap_read_lock(mm);
> +	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
> +	mmap_read_unlock(mm);
> +	mmput(mm);
> +	return 0;
> +}
> +
>  static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		struct damon_target *t, struct damon_region *r,
>  		struct damos *scheme, unsigned long *sz_filter_passed)
> @@ -916,7 +1019,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
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


Thanks,
SJ

