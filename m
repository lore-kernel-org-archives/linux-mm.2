Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBA1CEACF9
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1853F8E0008; Fri, 14 Nov 2025 19:51:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D868E0005; Fri, 14 Nov 2025 19:51:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099DD8E0008; Fri, 14 Nov 2025 19:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEBAD8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:51:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 932ECBA138
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:51:51 +0000 (UTC)
X-FDA: 84111014022.04.0188E67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BE11D1C0006
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:51:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Yr5VhBnK;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167910; a=rsa-sha256;
	cv=none;
	b=oU9P0JDDaYC+p7FaXqN5EkqDKJtouYsHDbqGxqRwiSvUzmvo6z9qtzHPbI1p0LAjcL4TjC
	c72k9N5ZfaoVpB4LHB8adwsr1MWE8+ybfCQp0fznw58HbFYS2sp3kS9MsagtyFqWdvphiM
	i8naW0/DoLfp2UQwR7GzWGVz6JDWjIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Yr5VhBnK;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDlylOnz+ORVorwvLjmMDSiJAZfaaswj3Od3QI7/A8g=;
	b=DglZh8z3BUZilYgdWmc/r7FXhBTs5Ya/lkNNDjwzL5awJa8/mpEFhp2Kqq+sao3OfyZteL
	Q3w8vIC12tXjt7cD/MgoFnNiDOJxCNqFapei46ymuKby5uMDFS9t0kTAxqmjX254xHA9hP
	RnfSSraAStgW4Vd+/oINE2bAUMAYOgc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCA6641AD7;
	Sat, 15 Nov 2025 00:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB6CC4CEF1;
	Sat, 15 Nov 2025 00:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763167908;
	bh=c34bXnZOMXHB1/otiiYKeqjSsUyBsx3eTgV6OQSOEQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Yr5VhBnKAuzj9cC+8XdpDTsNmuHxB6kbc7gGiLO0L9h/IvJnsYCzBILmm3BDLjQh3
	 JgU3YmTjZ48ntDuyp2AVorPbLdrmM1POS7rvsWOIFtsRM0MCNuApKBdMCuLns/6tpS
	 dCWkfu6Fa+z0adCrzQgoXMqGsYM3IW5H52Q76bM0=
Date: Fri, 14 Nov 2025 16:51:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, David Hildenbrand <david@redhat.com>, Zi
 Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Matthew Brost
 <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] fixup: mm/rmap: extend rmap and migration support
 device-private entries
Message-Id: <20251114165146.5c51eeeee200bd37b378bd45@linux-foundation.org>
In-Reply-To: <20251115002835.3515194-1-balbirs@nvidia.com>
References: <20251115002835.3515194-1-balbirs@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE11D1C0006
X-Stat-Signature: 6d5hbduynpggd3iftjtaz7r3eug53ees
X-HE-Tag: 1763167909-886808
X-HE-Meta: U2FsdGVkX1+pFeks5gvMz1Tu2CyhDFhUWHiSFon+IMe0S4gXz8Bqe/DXQPPnu2BIkx5zOxv32za2xpsiAKx2/jTWF9lkLo0ngwfKX0lb0/oYbsHlMDG4nI6XHXKzH4x3JSPBaGqBtQv2lKHHP3FCin6JzSafhYkzenylxEYJteP6fiWoj0N2ehECSOxTtBfsfNtsnxaMUPJzbachkn8D+qHMVcz5kXdxntmo/tGWsw5fmNva05VpU/1pVAzM86vOz1ixKYmMgu3EuXP+k4VdrCqCecWmwnsSo9FQfMwAO+8Z/arlblFKUmFdIny8Hjfpy7S2UeTFOJFifXaAUow4zNUDr+i628lJmM1ypTD/Sk9/u7dIjyLvYxmmnsKdo00g2FGYJO6w9Ln9cTHEwvpCloZZrWZR7mdnDQ6LdnIVK4dccc+NhpnCC7WGrM2htTdwn9Q7Pdkz+XOcCMIM3n+RndcEgSPAPjv7kjud3tmzcp5BGll84gFNb/j4+JnvF9UTznE51dVIKJhA7KkpWnk7e/ZU2NXdjf6ljPzPVO3KoESIMfNckWAYeNuPD/ONfYBiUH0zLclq9BxVdHgrgl0SXF9DRkC64pfC7AEh+EhluzbsXorW+erTPMTNG5n9t6/9PoZATswmoCGMEZTr8CIJn4iUVUp4OeHpU/MQEhXdA9GAXbvDf1OFr5yZrDUtQvIN4eR3wbzFiupW/xGjRYoX20/0V2RMBWNm1nvUQ+SMjPM25t+Pb54OY1OzUv/quH8eYpzfRUhMjYkVghhZ09O+DHFs1M9bVBcAN+nJkACiIz63C9M3hKJWa7rtxuuuyIXCa3Mb6vA9IUMpWSWtrMXCfSEJcMUP22H6ze2n26DfG1qVm1vKGIfrYEiRIhKxRM0ZUMTAJxMizh5Xgw8l8mN3B7SeN5Je6sm70UKIRyvL8/F+eOOsYKnTJl3z1p7GURuf815R5hbhkZjHBtWLspe
 Xv6KQkR8
 rrCfaOMfxWaPdF1lsa75/qlR6B6Yju0FqDOcHyAhC//TtPFyWRd4lKV9mwJNrWUeKTIayNR0qD0oFMLc3r62LviaXpPtVjw/xy/U7bAR10iP/C9pTBPbBM543YB9rfg52xcUDs/whfkVHe1zQpVf9cj6jOGOvsExunve0chg//Alxxqo56zWzZ6W3qYKQ1JvMF8o4C9b+81CKR5dLXGIYDGrljtXqCIJxYEbo99YMLcn6dH2HbueYUitRXyt3YNXUKs2PN/SMrA+35ha11bJJ/rIyjC/Ry5bgUQQ9Zrb59YmDO3/GGKvtmv6cYcLT4iSTg0GkRv46954MQAg5+14NbW9RkIs91ueJIBErJXzGFB+n0unGKt+N//twtsfIuZ6oWaQ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Nov 2025 11:28:35 +1100 Balbir Singh <balbirs@nvidia.com> wrote:

> Follow the pattern used in remove_migration_pte() in
> remove_migration_pmd(). Process the migration entries and if the entry
> type is device private, override the pmde with a device private entry
> and set the soft dirty and uffd_wp bits with the pmd_swp_mksoft_dirty
> and pmd_swp_mkuffd_wp
> 
> ...
>
> This fixup should be squashed into the patch "mm/rmap: extend rmap and
> migration support" of mm/mm-unstable
> 

OK.  After fixing up
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch, mm.git's
mm/huge_memory.c has the below.  Please double-check.


void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
{
	struct folio *folio = page_folio(new);
	struct vm_area_struct *vma = pvmw->vma;
	struct mm_struct *mm = vma->vm_mm;
	unsigned long address = pvmw->address;
	unsigned long haddr = address & HPAGE_PMD_MASK;
	pmd_t pmde;
	softleaf_t entry;

	if (!(pvmw->pmd && !pvmw->pte))
		return;

	entry = softleaf_from_pmd(*pvmw->pmd);
	folio_get(folio);
	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));

	if (pmd_swp_soft_dirty(*pvmw->pmd))
		pmde = pmd_mksoft_dirty(pmde);
	if (softleaf_is_migration_write(entry))
		pmde = pmd_mkwrite(pmde, vma);
	if (pmd_swp_uffd_wp(*pvmw->pmd))
		pmde = pmd_mkuffd_wp(pmde);
	if (!softleaf_is_migration_young(entry))
		pmde = pmd_mkold(pmde);
	/* NOTE: this may contain setting soft-dirty on some archs */
	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
		pmde = pmd_mkdirty(pmde);

	if (folio_is_device_private(folio)) {
		swp_entry_t entry;

		if (pmd_write(pmde))
			entry = make_writable_device_private_entry(
							page_to_pfn(new));
		else
			entry = make_readable_device_private_entry(
							page_to_pfn(new));
		pmde = swp_entry_to_pmd(entry);

		if (pmd_swp_soft_dirty(*pvmw->pmd))
			pmde = pmd_swp_mksoft_dirty(pmde);
		if (pmd_swp_uffd_wp(*pvmw->pmd))
			pmde = pmd_swp_mkuffd_wp(pmde);
	}

	if (folio_test_anon(folio)) {
		rmap_t rmap_flags = RMAP_NONE;

		if (!softleaf_is_migration_read(entry))
			rmap_flags |= RMAP_EXCLUSIVE;

		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
	} else {
		folio_add_file_rmap_pmd(folio, new, vma);
	}
	VM_BUG_ON(pmd_write(pmde) && folio_test_anon(folio) && !PageAnonExclusive(new));
	set_pmd_at(mm, haddr, pvmw->pmd, pmde);

	/* No need to invalidate - it was non-present before */
	update_mmu_cache_pmd(vma, address, pvmw->pmd);
	trace_remove_migration_pmd(address, pmd_val(pmde));
}

