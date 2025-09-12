Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E6DCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C3C900004; Thu, 11 Sep 2025 21:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123EB900002; Thu, 11 Sep 2025 21:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0612F900004; Thu, 11 Sep 2025 21:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA154900002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:59:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9259D1DF041
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:59:21 +0000 (UTC)
X-FDA: 83878940922.15.3CF2B00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9E6914000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:59:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=difnhe8r;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757642355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjaSi0G8l11qUIurcoc9kI8DVjHYgorpEf/xcpDqoQM=;
	b=7NQtBBGNb/JSqtu8BXQdGKJ7mHywcM4X1wLreYM5JBUj2Okai4KD+Xsot5T3HYws4I3VYR
	6ybQtNpsHskjo3ciqjjYwHr/qGo/gOhtxp5vKjfAc86T0Tn5n66DaQ3lA/+/upLqc9JVSd
	QSfXOjOsHH3oE6oHOoLgVoK8HtFjQc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757642355; a=rsa-sha256;
	cv=none;
	b=irs/cMqAUqNzRGYTMkPowDHygHydud4pY2JcIjDqipw2jwA+lyZ5jjLSJyAT/rp9aUbawu
	MU2oCOZuMFikL+0bWVAfawC743kPxNgMrrrxlOR4dWadhwAeqqNto+1T5tHMTZeyM3IaRs
	qs5QSN8wkkx3dZLt0YtI4lZ6bkW9+nI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=difnhe8r;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4D3A4473A;
	Fri, 12 Sep 2025 01:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571FBC4CEF0;
	Fri, 12 Sep 2025 01:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757642353;
	bh=meu8m65eD3yfEwGMUX3MAwvZUXiaWLYcK+z9uaK0MG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=difnhe8rYJ5KYdrAC/LLuy/z68nGffP5eq6tURh51P5H9B0rWNM+2S29plk+JSMnb
	 R5ryLu093928ic6MByU1XZT5WhVqZ96NtoAIFYDgqsbXPmuUs/IbqDnDiDQTKltm4R
	 5alZpJVf4mXmpap37JqkD8Fm7i/zS6ow+yTWYafuFgu+mzq1MU6hAIn2GN9vxp+M9W
	 FS2zjM6LmhgsCUik5aa6LImOnIYw8J4QuxDH0LR93nSqPxZuk+aga2TECNsmGP/h5b
	 4lI9QMMGs0efuyZDuCNo5GXs26UfMwDI3qKKqAaL+9IH9+a4gRgLBj5lIkdZUiLijS
	 /eRxPF4CW5q3Q==
From: SeongJae Park <sj@kernel.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v5 03/15] mm/rmap: extend rmap and migration support device-private entries
Date: Thu, 11 Sep 2025 18:59:09 -0700
Message-Id: <20250912015910.59404-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908000448.180088-4-balbirs@nvidia.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9E6914000E
X-Stat-Signature: ii8qefm5gucpcyrt65dup4c5tb6tewhm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757642354-364600
X-HE-Meta: U2FsdGVkX19drfrH0StmseT4CDoL7yoeiBkdxXcmwGZ8fuLpvtchfeHmTXHCy43t2sVET9knz62RN3G/3lq0/JgZXPaB+tI3qG4sT6W5ic3OlmZ2cixfMCF9clQf6jkRWxyDm9EBaFFFStVZOk4VnndEwThh9TEu6NSEdiCwOONsETboBD7rG+X3zVQq3kycnf2wn0dnfVrWGzl6V8qT2nQU1G3IAPjdHtfkFF76N6nh+Z6D5ikg2oGdAmGNyG3F1sdslMnhUaWoFIkkQsPK6BGgDiXYJwuzSEQM4ERTVxVhntAJbR0wA6J52HuQ/vtk3WU1y5TPyUmSNJ4ezmOU3r+UijcxRKoJXQMa8KTvjdy9IywEoaVeUP7m3JBhJXqCzH6PjXxJaQ4RnixhBtcTEp/15CGT08qocJhzfUpTwBXQ2X/0nRscayJRMPFFT52Af3A+F/ukAqgCCoMl52j8HgoxiZPJjkMJanSq421O0DJDYbJtkH+WIDwk4gMNkFzLGuD3/UPgqwdu0WL90mqd2pX0l3JCpDUnrStmCgpXuN6kP/WSQk5+LjU31ogn800lB9vgPhaC6lD8p18h24e0hXpir2+XJ9PUjvtxZvaroscZrJTKz2GnXBxlRVVDoR3cMiJ+p1m5NkyMRIoDPs57vemHHy2sSZ7VqPE14cJyt5OlugAZ9khxIyRV0Vc47Z4/SOEkJ7DAXlHbRRLZrDngD0wDwrYUAXO313+fA4WO1uPHOwqpRsRyNDooukzZ34T7C7GXaFtHEiAD3RwIeUQ10KpYL6hUdrUdxxh+2xeheJpTsOs9UKGhZe7f2PCMWyQ4P0WXT/LbLDuj1p8FEoQOp77wMT0CdnZlkvyu0qBynfTUrKHcQ3Dtk0Lkv3IUDPcg6IyFF0ShzidjjNlp9dAG3kEazkH7EzUf0P/yAv95UKLsYsWXlR5Y51d3RoMiXOxX6cGnrn3YFRo7TMSpiB2
 CjO90xyS
 FcjXQK6Pmk8B1ZX3l5hRLcJC0FaIiMcJ/t00rrs+zTx7Xt+uTx3JWFI6Yt3rbCs4900RUQuWDsSRXS4auEwQaETHZilnMl75ZssVpT/0fJPD3bK6tuFCc3HtoeSr36QqVSVrEApRWLIMMyAC0euX5XM531kZNSrJBocz8DPuriQsFjvRWfGoqZIi/Gc0+LHavYNnvcXNAc5cJ3cTgjTkRrTPnGuBRG3w1CJIhTyeJ87lR2burN1xwUN5ah4tpxCNcZ0oldWklBe24SgwCJvc7J0bDN5Iwpr1jjMCGaaWYAGzV+mh2RQaTMdLRoK6+kThIs72aGcnWQ3V7pbEVI4VH16/mHULzTAe1EzfoJkwzAw+485vC1DIkDagoiG3PVBHS8hZ4JIgIOBCCozWCngsHdDZFWRueM2MTI+epPQhRfxEz+E8MDl3Wf4ACOln58X9ZoATyVvxFrJZciUImvZwpPfLGZaqXaRi7uzmw4WCufWh8Bx7ra4BAiwdf96kk35wDvgJSBZPINjKpQT0VgZT9uEH/ZqUCynRm10ZKstRx9BS/xNUXCP3h981jvmXOam21JREdiUTtyJRDnpnk0SbtNzw3PpxpC/LcwpGMF0Gb+O4DhOyww6LiwCAQCgOlmQfQikGysvKRViPDIITO7I1xfcCsVWuSgJCydSdwEa2Lt3KpGDsodkHAwuOYjQhRXoC/0LzbXEYgh+NRW+PoVfMU4UnmfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 10:04:36 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> Add device-private THP support to reverse mapping infrastructure,
> enabling proper handling during migration and walk operations.
> 
> The key changes are:
> - add_migration_pmd()/remove_migration_pmd(): Handle device-private
>   entries during folio migration and splitting
> - page_vma_mapped_walk(): Recognize device-private THP entries during
>   VMA traversal operations
> 
> This change supports folio splitting and migration operations on
> device-private entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/damon/ops-common.c | 20 +++++++++++++++++---
>  mm/huge_memory.c      | 16 +++++++++++++++-
>  mm/page_idle.c        |  5 +++--
>  mm/page_vma_mapped.c  | 12 ++++++++++--
>  mm/rmap.c             | 19 ++++++++++++++++---
>  5 files changed, 61 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..eda4de553611 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
>  void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
> +	pmd_t pmdval = pmdp_get(pmd);
> +	struct folio *folio;
> +	bool young = false;
> +	unsigned long pfn;
> +
> +	if (likely(pmd_present(pmdval)))
> +		pfn = pmd_pfn(pmdval);
> +	else
> +		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
>  
> +	folio = damon_get_folio(pfn);
>  	if (!folio)
>  		return;
>  
> -	if (pmdp_clear_young_notify(vma, addr, pmd))
> +	if (likely(pmd_present(pmdval)))
> +		young |= pmdp_clear_young_notify(vma, addr, pmd);
> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
> +	if (young)
>  		folio_set_young(folio);
>  
>  	folio_set_idle(folio);
> @@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct folio *folio,
>  				mmu_notifier_test_young(vma->vm_mm, addr);
>  		} else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
> +			pmd_t pmd = pmdp_get(pvmw.pmd);
> +
> +			*accessed = (pmd_present(pmd) && pmd_young(pmd)) ||
>  				!folio_test_idle(folio) ||
>  				mmu_notifier_test_young(vma->vm_mm, addr);

Could you please elaborate more about why the above change is needed on the
commit message?

For example, I found below from v3 of this patch series:

    pmd_pfn() does not work well with zone device entries, use
    pfn_pmd_entry_to_swap() for checking and comparison as for zone device
    entries.

Adding that kind of elaboration on the commit message would be helpful.

Also, seems the DAMON part change is not really required to be made together
with other changes.  If I'm not wrong, could you make DAMON part change as a
separate commit?

The code looks good to me.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

