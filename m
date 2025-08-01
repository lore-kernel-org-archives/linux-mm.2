Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F718C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E6C6B008A; Fri,  1 Aug 2025 19:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F1E6B008C; Fri,  1 Aug 2025 19:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945136B0092; Fri,  1 Aug 2025 19:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84B346B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:39:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0515850449
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:39:20 +0000 (UTC)
X-FDA: 83729807322.05.F3F0447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4CE68160002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:39:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yit97oU8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754091559; a=rsa-sha256;
	cv=none;
	b=EgbNAVDsoTVVDggn2nGzuMI5bfY60J5oCGj+Gi+OIsnANksX50PTIaxJUVhRaemD1nDg1i
	XHMWPrRcV3bmSExh1ihA65ojNMGLpN2OKLw7cQtdzI680cPp8/i1w2b5cGDcM7lcjkm7jG
	TYFQJO3kjJos59/3ADRQslmMhFNMHDs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yit97oU8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754091559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLdSpgArUnLnlbaM7ch/ATDY76UX9L+2hv+QGRMBqqk=;
	b=IMNcfW59sR6INHqDtb+56O2QF2Vxz0MgIhqtQtDKK7NWQA7d2JQbLTxqsM5Jbj+IQoBu39
	GL+oqcLp9TPs+zrCpA2T/CKgcOEqV3CKJrTUSUCCqEQ8iTfMN1KGBXf7JGoVEt4AhxqZgK
	S2wx3TQp+klZotbIgfDnjmuY76zwTo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29FE644BA2;
	Fri,  1 Aug 2025 23:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DEDC4CEE7;
	Fri,  1 Aug 2025 23:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754091558;
	bh=MnEEczPpbP4/NoVuZ+RGReSlbA6n00lVLaBy9fFX2Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yit97oU8o/aPbODWMoTlA86Rdvr8PwSZ/vBkVD7JqI8gSje7SsoPMqqkYLmuo1FUI
	 7foTlQDXiXeCrz/5rGgbtSB5aYQaYOOkuNDSK5glcDLPiSU11I9p0ik5nvmNenP63c
	 XqjJwfgdKUS9WTI2P80oq9NrUvO1A0JfFk4DK+gprYZsevZiiirhgo5CUwsMWclgth
	 +oExuvyJaIo3eejodBZFnDuRw7mbGQs5yxTEdy1C/KAsp4dUrLaqIWIdadwenQexTq
	 0BTE0KzWZYuJifphC85L4+6OwRA4ulX8pJhNkCB3pWrsJsWVHF3kzcR8L7bD3JrzoH
	 FDRTzW8f8X9fw==
From: SeongJae Park <sj@kernel.org>
To: pyyjason@gmail.com
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/damon: Add damos_stat support for vaddr
Date: Fri,  1 Aug 2025 16:39:14 -0700
Message-Id: <20250801233914.1530-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <88cc271642476fa6025f3789781dfc8c2f576eab.1754088635.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CE68160002
X-Stat-Signature: jr7u3fnq3acz733pxxebxqqm3uw4x1td
X-HE-Tag: 1754091559-625431
X-HE-Meta: U2FsdGVkX19LoqoCZA3wx+IgrW8SOycdpoFtG0suC+eJCezw33PX9Coc9/Mz/VBIGJEY+nYEYDXZojiNHSRizsjL4u1vYLObhgBkBof87NsfcbeMjHswakDhufKpYWbUhbMbcj4j/ClvCu/YMQnKq1R3UIN1yaGgMoQBRuImAwh+qqO2vA8nH01pHrPZZ4Hc6iT3EOOukaKidpw1AYvKpoQrqnv9BIAPtPFM+wsF+4unl2jcNUcx3odMJnB2CBcDFDSF9l+AMeEhTI1V3GkVS1XBpayIArll864lGU+pn3q5DihyCUbseaq2a7uQGPJVv56eYBQB/cAjSSLC78Gz1hM5acARK6jrhle2/jYPTga3c18/56edSJbWxeM33j6jnRWvv0UxOoVC80ICxdAeAywlwMMYZYkGi7v8C4VbB0mbd5d6Cbgrj+jOx3HBPFIy1h1iPP4YjX6vMy+ergzUIZCxpWgc4E8xdRCImjr+S4qiw4wHvsiQYnP9PHqCxT0drrtq7muAw8XjRqHtu8qvYg1xo/ApjHSO6HgxKOxr6t6Ik/4D1IuU0fU9FF5PPOWhCJxtmg/fQixSP2pPfIn1X2Uw26uVoFrPQXDiQWDwrZmmLtI9fizEBTR8+h20givUp38yCh9BKlwGuliPlBRZPyXOeqj3A1Yhohce05150BJQS62vlzYjLgU0Zi4mwGO8cfmck+wz96AJi7/gR5lkiwVUCDf/QANai1mGLOyy65u8Ikdf6RZFB/oDB4iHAy4mmX9cAZD7avyor8kFyI5aAHeT3kD+bERIIXnNgMVrRRS73BehoZfaNGR8LEGYx03wK29cZ86qeojEPlVD8rbp/cYiz3o1LCp/2p2TxEOxiyIexeTm1EhvHNQGi0IJo7KrjcXSVJdyJMYWHAZ9fzhRGPAD0MLQxYPunppEH6KE3hszaXGvbEIMEKA7mFKfhIc2j6973ktoBYqpq85xqRk
 NQLwJPWi
 3EymNLJQpUc0vbQr8Sq9wWfdbv6AGFzTwu3CFY07h4WhwaJcE2MExAJaw0V+m9ZUKel7ogsCZ0hLNs1d7b0lkoQflZrxjXsc6Z9Sl9Ln4WYCha5V3c/cG8Ztch3+uE5K8tlpWunuJndHHjr35uKtsJ6m8QQLrslC0+CaCbxYHZTTbf9Xe7mH4EXCVsxRBlh9z6DWxLzFTNW1BfaNM8jzRgU6xobb57AgsMwfJ5i20NwtAJ1zC3V1pEwPRwPemuK9pnWSczuUksCh9Acf1XJ8335zo9QM5z/VLDB81fBwOw/XV5tQD0rdbZxRTJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 Aug 2025 22:59:51 +0000 pyyjason@gmail.com wrote:

> From: Yueyang Pan <pyyjason@gmail.com>
> 
> This patch adds support for damos_stat in virtual address space.

As mentioned on the cover letter, this is not very technically correct.  Could
you please change the subject and above changelog, as suggested on the cover
letter?

> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/damon/vaddr.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 87e825349bdf..5960d5d36123 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -890,6 +890,107 @@ static unsigned long damos_va_migrate(struct damon_target *target,
>  	return applied * PAGE_SIZE;
>  }
>  
> +struct damos_va_stat_private {
> +	struct damos *scheme;
> +	unsigned long *sz_filter_passed;
> +};
> +
> +static inline bool damos_va_invalid_folio(struct folio *folio,
> +		struct damos *s)
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
> +		if (damos_va_invalid_folio(folio, s))
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
> +		if (damos_va_invalid_folio(folio, s))
> +			continue;
> +
> +		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
> +			*sz_filter_passed += folio_size(folio);
> +		nr = folio_nr_pages(folio);
> +		s->last_applied = folio;
> +	}
> +	pte_unmap_unlock(start_pte, ptl);
> +	return 0;
> +}
> +
> +static unsigned long damos_va_stat(struct damon_target *target,
> +		struct damon_region *r, struct damos *s,
> +		unsigned long *sz_filter_passed)
> +{
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
> +	if (!damon_ops_has_filter(s))

I suggested to change this function's name to damos_ops_has_filter() on the
previous patch of this series.  If it is accepted, this should also be updated.

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
> @@ -916,7 +1017,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_MIGRATE_COLD:
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>  	case DAMOS_STAT:
> -		return 0;
> +		return damos_va_stat(t, r, scheme, sz_filter_passed);
>  	default:
>  		/*
>  		 * DAMOS actions that are not yet supported by 'vaddr'.
> -- 
> 2.43.0


Thanks,
SJ

