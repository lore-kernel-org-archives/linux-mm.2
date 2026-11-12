Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74731606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SgGAGdzm
Received: by kanga.kvack.org (Postfix)
	id 6198D6B00EF; Thu, 12 Nov 2026 01:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1E66B05B0; Thu, 12 Nov 2026 01:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EC26B05B1; Thu, 12 Nov 2026 01:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 303B96B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:07:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC5751C3C94
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:07:09 +0000 (UTC)
X-FDA: 85425434178.17.2E08219
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 193B440004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:07:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgGAGdzm;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794463628;
	b=AR7HwGJXouWdlribU2k3w9Osz26Gp9I3bQxboiPMCrlCDX1N2UZh9B0f4gChmK8/Bszof8
	SmkyHMB0Z6k7jLlKKyKWcJOCWRU0Mgvm5c8eHRUBIvnZq+/tpXrM37wjSbkIvu+0C3QFqm
	FT0tjV3UwybnisN7by6vae6h5Nf+3E8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgGAGdzm;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794463628;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRIXRk3nJ6W4+3mJe1lvct3coGVmnoL/srO9QS4HR/8=;
	b=khJCS1RUv57xeJ6LkJg7MnLTWhu4W8pTxblK5/3E7D4TE4lN46RJxbBcw/ohs0ZSlbtdPh
	pNqBOQsN7Ac057cf6eEGDVaicPgXesJhAlW2izngcMUPx8cX1HpZUiXKe5b5RuQ/i/YXPt
	u+zPKJISEPFG3feTpQiTHKFPRjNK3gg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D55F60D1A;
	Thu, 12 Nov 2026 06:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416241F00A05;
	Thu, 12 Nov 2026 06:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794463627;
	bh=gRIXRk3nJ6W4+3mJe1lvct3coGVmnoL/srO9QS4HR/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SgGAGdzmlpeb9nZ8QDim04cFYdAdwKeCscZzBqqyBPvhwAMY/ZAlcwo6SrmB8Vd+W
	 /pZTLe9i5ys0RJObqyvlli20yVUOk2v/ZDGrSmmEci2x7FnGjOG7+Et5ymoj0ZGZY+
	 Il5+1rzTOwE/dqqq8kvrQFbVnU88DbdNwij4CD2Lkq7qzec1Mj/niB9MuVP5nSA1tx
	 ODBBM3pOU28JZy7cJjaBs65Ac4p+vBm6i4YxubjYUyoNrNgYNkx5oqBGeESLsiOBfR
	 lyv0Wm1ZSHUQeoU9C0URaXBeQYV48TErnhChx0CncipCu6MNlDc7xUzroIBHZxjyTf
	 JBVgkG1TsRVPA==
Message-ID: <sashiko-outbox-210496@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: use memory barriers for non PMD-sized folios to
 sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, harry@kernel.org, jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, pfalcato@suse.de, linux-mm@kvack.org
In-Reply-To: <09736bc2e01bec0ca7436733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com>
References: <09736bc2e01bec0ca7436733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 06:07:05 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 193B440004
X-Stat-Signature: x7t6598c6fndsdcmzzehu3e13ga5w3wh
X-Rspam-User: 
X-HE-Tag: 1794463627-371161
X-HE-Meta: U2FsdGVkX1+gS9CcgVOtwwXgjOKzqC0TfIVRz6TtltQm3HnIsmkrzmdDjLeizpAi4fvhkm+9tQMI2QMEBepZN6RNNjKqAK3z9vX5I9FG1XQrn5HkfLkNLDBVasaQ+XFKRgcoqM/b9uBRYIZjES+mzX3qs3QtRWrIXGZxEMhXRLyHagvCtCRTPC/RPfvsmokpXgz9HgU1pIJGoo3xF93LPAgqtEIH5TMAFMIKJOYpd8UNYq5cc6y6piDbGnriXWkcL80vfTsWHBLnKD5Ky7GCVVJ+ibJf8ogHGATE2bqZlelYJeFh+dX2T3J7fuL3aLLAH6ON9NDhE8GL8Uno5Q5Z7JgzjBHcT0ISU02aLBpMC3UGqhNmXPAaZl5Wn/AGu0EEwe/pyK7Tfi0XNyAY9nWa2Ox3MBInGdvOOXfnT7+V7n80gBgo3a0DIpWkSCXPm2BFdzPUBO2gwediVFOhrf02U3/zUS8beSZ/sSQCLhep2C3jEC0g4jkC7qMNwkyJWzh0xn8c3InRkZCkC62iFm8AxvIxK9JTXH0BoJkq9udLtdnEt/O9G0s8Y+6wu7O7xctZoQIVl1Mmaq/OyEwo3E/6hzjC3vGnuBk4tjuy0KVGOBRYrnwevZAMgqA7r0k6fqDqMLN/cUD/GVuLyvCBs1mkYJiHy/vgYi3NOX08o5avTiixiIe7xbhn/jLRjEpuBuXpWNOtVFMO6hkPJyoeMOlYiIGngUSmD6g8zD1g6dMxobZoTNOLlRbPVHrJQjDU3zHZcAU6jN78gg3xCTLi6rCGQsyd7N3Sdilx+k0h5D8xgWNvmBIcR3/vlD72Z3bVaFPXRAxR5dqFtRNw3olRjEpMQeAz/iYnwDAgy63FRxjbU4n6voG7oZjrBNfLeiV+SjHAYurKzgupHQqZdZK2k9ZkhoJlweSa7uiivWk7LM0tYXVqQDOdZZL0Jp0umRAXG62LTpGoLCjPRtwzI3GNXNC
 qNwwHpOp
 moTvxxseDQLsQ0ew9XZ3jSIfHtmcbm0tTarlVIYykfOGcpyXZtttPzvDe5m6WHyDEE5ohQ0Hel3oXh+c47xwuuKwaJbDyb+dwZHpCGvj6YLtuQyY13Kd/Cos91OwN/uUZ0iSr7G7AGmlZyRhhicD9GD9G4cyrL2eLr/CfNcT2gmUk3zpdWJsS0SMM5R8XNKAx77czHOPSQ/NpZ1vSq73QwvEe1hKc4F3x7G//npX8h1Iwy3mTnxjWXaoJucWn4B2OD0gOmKntmjATpyunL3bqAE67otMYQP5EADEMgd0vtP6zWjVMvKiZ/AzsMfDSLweSWTb9WQrtvgkFqoUZUctcY5lzhBBqQmcNa9cYk/gPlBPdwhxVzp94FX53X9OPHIr8PyiBCbo3HH40NKOwLxjrd/Bxerk1lHWpdDx3wcT2OpKukarxdLRyyRqN8lYSfSfVeYtp7xITpfpWnw769SQAPmhE15iXI1TBfN68HqIAm+9rOfrRP2sCcpLP931otbnu08wtsFMAB8T32pFeJrXRCVvHfIFs0As7EJaE2xl2J3E5SGVXL7DI3bOCr+pyXWqrDSc+6AhxvBTZ3hhocOUzLar4zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm: sync_with_folio_pmd_zap() triggers BUILD_BUG() when huge
  leaves disabled
--

commit 6fcd156071f8ff19dadc585e086208ca97feaaa2
Author: Baolin Wang <baolin.wang@linux.alibaba.com>

mm: use memory barriers for non PMD-sized folios to sync

This commit replaces the PMD lock in sync_with_folio_pmd_zap() with an
smp_rmb() paired with an smp_wmb() in zap_pte_range() when synchronizing
concurrent zapping of non-PMD-sized folios.

> diff --git a/mm/internal.h b/mm/internal.h
> index cd3675c044e0a..a277bf4841f80 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pg=
table_t *pte);
>   * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>   * @mm: The mm_struct.
>   * @pmdp: Pointer to the pmd that was found to be pmd_none().
> + * @nr_pages: The number of pages in the folio.
>   *
>   * When we find a pmd_none() while unmapping a folio without holding the=
 PTL,
>   * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, =
pgtable_t *pte);
>   * against later mapcount reads. Skipping the PMD without synchronization
>   * could make folio unmapping code assume that unmapping failed.
>   *
> - * Wait for concurrent zapping to complete by grabbing the PTL.
> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-s=
ized
> + * folios, otherwise smp_rmb() is sufficient.
>   */
> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *=
pmdp)
> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *=
pmdp,
> +		unsigned int nr_pages)
>  {
> -	spinlock_t *ptl =3D pmd_lock(mm, pmdp);
> +	if (nr_pages >=3D HPAGE_PMD_NR) {
> +		spinlock_t *ptl =3D pmd_lock(mm, pmdp);
> =20
> -	spin_unlock(ptl);
> +		spin_unlock(ptl);
> +		return;
> +	}

[Severity: High]
Does evaluating HPAGE_PMD_NR against the runtime nr_pages argument break
the build when CONFIG_PGTABLE_HAS_HUGE_LEAVES is disabled?

When both CONFIG_TRANSPARENT_HUGEPAGE and CONFIG_HUGETLB_PAGE are
disabled, HPAGE_PMD_SHIFT expands to a BUILD_BUG():

include/linux/huge_mm.h:
#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
#define HPAGE_PMD_SHIFT PMD_SHIFT
#define HPAGE_PUD_SHIFT PUD_SHIFT
#else
#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
#endif

#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)

Because zap_pmd_range() and page_vma_mapped_walk() call
sync_with_folio_pmd_zap() unconditionally, the compiler cannot eliminate
the HPAGE_PMD_NR evaluation and triggers BUILD_BUG().  Guarding the check
with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) avoids evaluating
HPAGE_PMD_NR when transparent hugepages are disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/09736bc2e01bec0ca74=
36733078c82c7e0cc6627.1794376686.git.baolin.wang@linux.alibaba.com?part=3D1

