Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C47606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YVUV/MEO
Received: by kanga.kvack.org (Postfix)
	id 306056B05B5; Thu, 12 Nov 2026 06:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6B46B05B7; Thu, 12 Nov 2026 06:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4B26B05B9; Thu, 12 Nov 2026 06:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006976B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:36:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9761F140531
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:36:04 +0000 (UTC)
X-FDA: 85426263048.05.43A6BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E4CD21A000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:36:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YVUV/MEO";
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483363;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbNbPo5M7kjtj66Mpyb8K2B8xJggS+YAHrIVoGzON1w=;
	b=fXXpjYJKoFVI0vfqPBUSFQJIFRksfaawYaOqGUV8ijdEqyOZl+37MWsra7NV1uQmyp0np3
	r4YlnO43+nY6O+YL1XcI73o0OuRnFxWXWSdOodAF3isMtjKpEeIDE12C+JojACC30D1nPE
	F51x6rBAgfjG2620FMSb5vIi2p6WJvI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483363;
	b=3qMAZrh9uFpvL27YMZ3llmAexX5qf5Npl7fon7olH2t03CVmJIvxg/0Mer+hz3R5kIEiyg
	79TQ2FfTS38SDZ2QY5tMA2GWW8IQqsPVKqaxgpcSJ4/PQ6QgRbDT0retvIqU+047Z0T+Cn
	1j0coQhAU4wBT948812hmKEC+uh63TY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YVUV/MEO";
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1385740B5F;
	Thu, 12 Nov 2026 11:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017A81F00A05;
	Thu, 12 Nov 2026 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794483362;
	bh=YbNbPo5M7kjtj66Mpyb8K2B8xJggS+YAHrIVoGzON1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YVUV/MEO5Ilf1u0oHShi3zD+nHCnfQqbRtsAJxud+r37cObayw/kIiVyoCRk1SyHL
	 xwe7ncCh9n9BTtO0/1BgouPny9YQBEpDMcX0DBIzJhWBxRGlXUiKFYcQX5HO2Yje+y
	 s5Bif4wHkoPtYlqvT1zONsPlhSNd47NS/CEgxEqepIaF7FE0ATUcIH1es83WMKKoph
	 8n7GlMtzct2b3Qk6b4hBuitnjQ1MmjMuipIs2EDPCuVrPsy9rRE5Rxx7jEw7LY98ZJ
	 7O6af89v0pWkZiP19OhaIi6wQdlnrO0TEp/bh/ulWgx10aHEt0dKrRHudf/QJ4gqZc
	 7CZvhkaX2Z5QQ==
Message-ID: <sashiko-outbox-211031@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/2] mm/huge_memory: detect partially mapped shared
 folios without per-page mapcounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Rik van
 Riel" <riel@surriel.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Jann
 Horn" <jannh@google.com>, linux-mm@kvack.org, "Joanne Koong" <joannelkoong@gmail.com>
In-Reply-To: <20261111113535.330078-3-azpijr@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
 <20261111113535.330078-3-azpijr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 11:36:00 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4CD21A000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yhnzwdebmtd5xc4d1bptazscp3h639ho
X-Rspam-User: 
X-HE-Tag: 1794483362-195024
X-HE-Meta: U2FsdGVkX19+fXsC+3NpeEgsfhR1K5WL/EquG+xglKgRTNk/bZxNht4S0Qf/Bw3RTQ5Icax+21mMciY8WHMb5cNDOCmtWv3hak08fPNBHXK1rRhQDZ1GUi7f6Ne4jK+4C7VPiyXcwXGg8o/8F41hNJx6/l2vJhvSLb92hileICp3KBFKtoWMyQ380rKXFqfr+bXAT+OvGFFWUk5GbIUfr8nVl78bJ24GIoBfksSJOvTt0oayTqwcyCDpeds6fkrx7J0d5MsJqtKynng3EId2D0QagXzOhSwS9rIVwg6a2dEMgOR8JVoF/Rc/UkSyjqrTweQJt4q5uLLqpLE1+cbBlitODCnBJLcSH/QCgVoRNDNPiwP33X8+ttNEC6JJq1f0T9QNLb+KoHIciFcEhRAfzZ9tW10fg4kdky21p3oR7IcALZUVRZV681Atj/uan0cZ93o8JHRLtxZ+CY2LuTRfJ3qVT5TUPqDUprdyICxoYRefuSSIeamv7shoA2yvctwhltlq0ymORquolisuwX7uWb+wdLbXlYSpx0XMqq9meLUiQDGRvwIlaBYBtgBopJi7A5nLqlFsWVI35j5kJ2fESlW/JWLFu9x8/s+SoRBaI9OdpLI6cB+DOFB+4q4Wgx/XmUdhqsoAQRLtkNXKXUdJqMbxoYGNZCoCVjpwfQRw5aw8tlNP0eaMZl+H5D5CzJIU4DKYP9ygqyJRnvngv+Wfvg3Lq8J+LDYrlCT18adv3BVgDHgUoPvbO57QhnnSwy0ZMbdgWdW/BG/tibRdhDfGwbTwjvM3Q/ZiLC1UjE9PUdqzeWyTTE9rLhp0xmjvsvJE5yscoeJ7UX7Y7rby3F2+Fpa7IAlIr2xJrKtDvWvdlsG/YVsaRf2YVMclSGTbOWPlwdSSZxNohVGr5rIp8YbON1IgljdGohPNwnuh9OFVOhmsL0P1HzXm8buyxerkCSvHbnrXusumwn3KBLOPLhI
 8gyqm2Bt
 z3l2DUIzUh8pO4F0CszPysxiC9d9wcUE1ii6Jukb+c9VlMrO5eYR4ugVYbR2jAJ/E9fgm6NcUIkWLbIAnvwulrE+66fr3/OZaVWjWpEp0RaQoJkK0zVNQAil1TdTbHD5N3318syyjr4oCEfYMmyoH94AF2W3jNlug5zR0K2D6IEQujLai2WdvsK0wyghgLBB9MfwMgxN1HIWtgGRjnRMjC8g+pU7w2XYK8fyxwc6TmBMO+mBr4piStY0PTS9K0CqRrEXrMqMin1ETlEKcdTXmzV8zf+hfFmyzsLmpFwhAjhZYvxmHqvSQcydORyWvhMl0L8El1lZ1C9LC49r8P/BvVeGHFvK82tnOoq1uAD9Weirx2oTWBQa/g3/8oXnVAGTWJ7yodS4kwwxNtNH1swFNM1IHxcSaEfw/VB4LUIkhKr8qbrfZ0S8DFcICJHhj/uZs48/AVCN9J/qoVY52VriwhsSx2m9e9nlDlo2TI5CgTQNmnspfg3wuX0xe77Feqc9Gf9rPjwbIeqCRfIADhnGxjr5L2TemrIVpyL3Pnrh8C76NJcKa2GI2cNvZKfddjMGq5j1srck1y7GYJTvWDg5Pq1rQ1Wfn9Ph8YQqTn616gh4hpJeYGEMt4G3Xwq3ZRLfNylSuwQjeVDfhK7E=
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
- [Medium] mm/huge_memory: deferred_split_scan() runs PMD
  thp_underused() on mTHPs
--

commit 2f9d38ddfb170d3656f9925bef1e82e9b94ecc37
Author: Jose A. Perez de Azpillaga <azpijr@gmail.com>

mm/huge_memory: detect partially mapped shared folios without per-page mapc=
ounts

This commit queues shared anonymous folios onto the deferred split list
without setting PG_partially_mapped when CONFIG_NO_PAGE_MAPCOUNT cannot tell
at unmap time whether all subpages remain mapped, and walks the rmap in
deferred_split_scan() to check them.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8c4a69c797edd..f80fa028dd340 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c

[ ... ]

> @@ -4744,6 +4811,15 @@ static unsigned long deferred_split_scan(struct sh=
rinker *shrink,
>  		list_lru_unlock_irq(lru);
>  		rcu_read_unlock();
> =20
> +		if (!folio_test_partially_mapped(folio) &&
> +		    folio_needs_mapped_check(folio)) {
> +			if (!folio_trylock(folio))
> +				goto requeue;
> +			/* Sets PG_partially_mapped and puts it back on the queue. */
> +			if (folio_mapped_shared_partially(folio))
> +				deferred_split_folio(folio, true);
> +			folio_unlock(folio);
> +		}
>  		if (!folio_test_partially_mapped(folio)) {
>  			/*
>  			 * See try_to_map_unused_to_zeropage(): we cannot
> @@ -4752,7 +4828,7 @@ static unsigned long deferred_split_scan(struct shr=
inker *shrink,
>  			 */
>  			if (folio_test_mlocked(folio))
>  				goto next;
> -			underused =3D thp_underused(folio);
> +			underused =3D split_underused_thp && thp_underused(folio);
>  			if (!underused)
>  				goto next;
>  		}

[Severity: Medium]
Can deferred_split_scan() now call thp_underused() on a sub-PMD mTHP?

Previously, only map_anon_folio_pmd_nopf() queued folios with
partially_mapped =3D=3D false, so any folio reaching the !folio_test_partia=
lly_mapped(folio)
branch was PMD-sized.  __folio_remove_rmap() now queues shared anonymous
folios of any order > 1 with partially_mapped =3D=3D false when a partial u=
nmap in
one process leaves the folio fully mapped in another.  When
folio_mapped_shared_partially() returns false for such a sub-PMD mTHP,
execution falls through to thp_underused(folio):

mm/huge_memory.c:thp_underused() {
    ...
	for (i =3D 0; i < folio_nr_pages(folio); i++) {
		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
			if (++num_zero_pages > khugepaged_max_ptes_none)
				return true;
		} else {
			if (++num_filled_pages >=3D HPAGE_PMD_NR - khugepaged_max_ptes_none)
				return false;
		}
	}
    ...
}

Because thp_underused() compares against unscaled HPAGE_PMD_NR and
khugepaged_max_ptes_none thresholds, any khugepaged_max_ptes_none below
HPAGE_PMD_NR - 1 causes reclaim to scan subpages with pages_identical() even
when neither threshold can be reached, or to split fully mapped sub-PMD mTH=
Ps
and increment THP_UNDERUSED_SPLIT_PAGE.  Checking folio_test_pmd_mappable(f=
olio)
before calling thp_underused(folio) would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111113535.3300=
78-1-azpijr@gmail.com?part=3D2

