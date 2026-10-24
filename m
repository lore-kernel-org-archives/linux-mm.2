Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B862A606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bL+NkwUn
Received: by kanga.kvack.org (Postfix)
	id D3E076B05B0; Sat, 24 Oct 2026 19:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9A36B05B1; Sat, 24 Oct 2026 19:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F6E6B05B2; Sat, 24 Oct 2026 19:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6950F6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:01:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A552120584
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 23:01:55 +0000 (UTC)
X-FDA: 85359044190.07.B2130C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA092100006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 23:01:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bL+NkwUn;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792882914;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ifik7ywdJzSlBWTh4fZClNn0YBG7LwNrhRPYJqoiXR4=;
	b=Fgc+g9JEXdS4Vphm14rW62m3VoE5I0eHPtebsaENuXRnW/ZTcuOiorHviy69AMbZVb24xj
	xp+rpp99HBzkWNVRf58RE5cXkWQftoQ69sM4nu9DRDPU0hB7IupWpIqJcQXWlNm2/jtVUe
	Ku/nL8eGxryd20SHXF/ZTsAdc0u4RWg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bL+NkwUn;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792882914;
	b=WCosj8fCbB5OM12Kg2Z07k8BmM56G6Se+vA+a995aUFMl+cCioe83izuq5IkOpwBoZhqPi
	SLYqTjj4auJzztxhsKkzJXLjLDWYVecKEoQrfEgALwGl1TZ2IgPikooAXY7X28iZPPrNMO
	BaDVLXqE+vxRdgwslDgVafOLsLOUjEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6691142E7C;
	Sat, 24 Oct 2026 23:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C5F1F01825;
	Sat, 24 Oct 2026 23:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792882912;
	bh=Ifik7ywdJzSlBWTh4fZClNn0YBG7LwNrhRPYJqoiXR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bL+NkwUnyBtU1LyTojYqwxxZs6kkrlFJStrOSIGKp4LA28Vn4osiprS+xPImlhwEA
	 mPTozbJNmKPp3TtSfStLQGWNJNqP2BXgFRajT9Uc/WXW249zKrQyT5QXCEuYc+UgMj
	 7I7IxgYudAlKo9YA9k2ILmFqF2rxidvluMp8JpIgMfnHTorzF2Mel3LHdg+jQWs70U
	 294FRfAiR5NfoecIB7h96sOl/5Gfvc72g2eXBb6jhfXUvNzDTejC2SLpLPJTvLPLr1
	 OLZh30srMxJHciWS/EiGpaQq1uMugYxbFBmHV0Zf0YttoVLSGZGgsG7GSpN4PZcRLp
	 pLBEo/q3IXAOw==
Message-ID: <sashiko-outbox-183933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] mm/huge_memory: scale thp_underused() to the
 folio size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
In-Reply-To: <20261023230006.3759543-2-joannelkoong@gmail.com>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
 <20261023230006.3759543-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 23:01:50 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA092100006
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xtm6h1azczjrcd9mhraffosnqaj7meay
X-HE-Tag: 1792882913-553494
X-HE-Meta: U2FsdGVkX19gQJwiVdEBMpA+C7u292h3lqz4/bxtgQnumlgYvY57plJrkWagWPSnLsHcyHYoY1PDV3ounmac/oCsK3597u+ObV8ECtMliWW77kIt8xFLFd+IXlfuJ7KpCCcmmnI10JOCYNWH5z52BKpq7JactL+cp2qyGi8VyQQ49yrigEa7bUu8anovD306MjmFzG6it7p0vKugrSLGoWJYVffecuzoESIJtWqUn81ZqSGEeAlK5ckToGchxx4FJ30D1fO4UfiOFDNbZnU0ftnCZkb1t3cILJY0NvinxaWhE7dkJsE+r1ue1LS4r8LFB18AEmzFeDQj+bF/SsDWFPV/V/fD0F1d3IjEnPVW+bKQqr6FeNbkZeZcPHxfQJLL6/x2n1NDOnG4wK69oqkmdq+MW/BSXaL+1Yoss0FHCzyawlSb+xkejw3L0dTybceKz0yVD7+G08wb27xZsKn0R41v5DRYSxlOG89IMAvtBQ0xAjwXQ2ShPv7qh/Vb1rMAAkQjoMMBXr09Y/GUXPSdUCAlGj7vmPJJHMbwYaA+n399mc/hJx3NlAAcBxH6mPyp07ww1L+wk8y6GLT4SLZOwhROsr0A4LoCI/zkV8KQHxV+62UfCeSzhvZdqvL3bOujpcPH60OpRuTUZLmfAG3Y4aG0pNOxIqi9Nxx6pPGl9VehP1rOju+kMG7tOfeHuQTBUbRc4IFTON3n4oi0CAP5Ul7JMfYiLlkmd1suh0vO2emNiL9xzZ3SIH4vjVoJxYO3ntCuEzCpXWcW7lnTDXzN85u3W/TZCFhBALd4lltobW/UTadCysAL36EBUWElM1KY+S4NWWktn9f8qvJ6ACAo+AipXWfN+NdRlPNwPWweQpZ2XdUq3vwxSVm+ifMH58nZ6xfJK7uJftAsqd3YWidNVSjAM6ncQL1yx9Jv7Q95/rW6FNW3cjxSVSisqDkzLHvWsE3OKxXjg1MlVodwIsf
 dy+s74/F
 LWnJjTz8RlgPwjfLxjly55/vduc8HxT6vJlptr3Z7aY6J6r0XhpWJKcoZ1C9n7mz0i4vMntR9VcJmZqIu8MnlUGvHSpM/nLAl2w7+VQWrYX7xLhOYtsUGm+1K25kD8etajRCV5DfCvRhex1VNyPydhKxy7l3M4CnBUr981pNO5GVQ2keLkMYMQP6Pw7qtTFT50wpYJfVHfqKn/D4Zy36tJMa+ZPwGGkI3biNWPw2i2Rw5uL/V57Hpbk02bITP/DyGj/Tdvc9goeJnc14mJh7bO2i9a3v+7zauD/Dno0XNiYFAGNxQEJMc7SOOjrO/EkSl3QrzHyI/AhtA5bwlHAlrnoyAcFpWDnUToB8L6mF6lkcNqowQv2/QwnaoT0psUA1RZ/hGv2O22TONCx2baitXDFdCKVJBWHPZo6iI22mdFZB/IAUYIFgziOc5qvlGa8KY1ImmTRmpKPVmI5uDuTzUv3mBApN0uIiRmOzTKHLO3VSXOp13HD3stex2WibZGdFaol8UKQfUwSpvOHoWdHAMBWyqaZPIZyT5q8/rnYnwYOuv/vQaQhSWrZeodPSYomIIbV3S9Fk1ebV/QiblFyIpo1CH1fRZTQslV/aEc+z81NcGvZM4Kd2qa6rYzjeIC/ZUlGyYda+mDlsY9Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/huge_memory: wrong rounding in thp_underused() max_ptes_none =
scaling
--

commit 56eb0cfccba9e5e4276f2a8250815399987bc848
Author: Joanne Koong <joannelkoong@gmail.com>

mm/huge_memory: scale thp_underused() to the folio size

This commit updates thp_underused() to scale khugepaged_max_ptes_none
proportionally to the number of pages in the folio rather than assuming
the folio has HPAGE_PMD_NR pages.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e86845..218259940f24d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4613,25 +4613,35 @@ static unsigned long deferred_split_count(struct =
shrinker *shrink,
> =20
>  static bool thp_underused(struct folio *folio)
>  {
> -	int num_zero_pages =3D 0, num_filled_pages =3D 0;
> -	int i;
> +	const unsigned long nr_pages =3D folio_nr_pages(folio);
> +	unsigned long num_zero_pages =3D 0, num_filled_pages =3D 0;
> +	unsigned long max_ptes_none =3D khugepaged_max_ptes_none;
> +	unsigned long i;
> =20
> -	if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> +	if (max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>  		return false;
> =20
>  	if (folio_contain_hwpoisoned_page(folio))
>  		return false;
> =20
> -	for (i =3D 0; i < folio_nr_pages(folio); i++) {
> +	/*
> +	 * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD_NR.
> +	 * Scale it to this folio's size (rounding up so that the folio is never
> +	 * split when fewer than the configured fraction of its pages are
> +	 * zero-filled).
> +	 */
> +	max_ptes_none =3D DIV_ROUND_UP(max_ptes_none * nr_pages, HPAGE_PMD_NR);
> +
> +	for (i =3D 0; i < nr_pages; i++) {
>  		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> -			if (++num_zero_pages > khugepaged_max_ptes_none)
> +			if (++num_zero_pages > max_ptes_none)
>  				return true;

[Severity: Medium]
Should max_ptes_none in thp_underused() be scaled with truncating integer
division rather than DIV_ROUND_UP()?

Because the loop checks a strict inequality:

	if (++num_zero_pages > max_ptes_none)
		return true;

max_ptes_none is the maximum number of zero-filled pages tolerated without
splitting, not the minimum count that triggers a split. Since num_zero_pages
is an integer, the condition that the zero-filled fraction exceeds the
configured PMD fraction (num_zero_pages / nr_pages >
khugepaged_max_ptes_none / HPAGE_PMD_NR) is equivalent to:

	num_zero_pages > (khugepaged_max_ptes_none * nr_pages) / HPAGE_PMD_NR

using truncating division. With truncating division, any folio with at most
the configured fraction of zero-filled pages already satisfies
num_zero_pages <=3D max_ptes_none and is not split.

Rounding max_ptes_none up with DIV_ROUND_UP() alongside the strict > check
requires floor((khugepaged_max_ptes_none * nr_pages) / HPAGE_PMD_NR) + 2
zero pages to trigger a split whenever the product is not an exact multiple
of HPAGE_PMD_NR, allowing sub-PMD folios that exceed the configured zero-pa=
ge
fraction to escape splitting in deferred_split_scan() -> thp_underused().

In addition, for any sub-PMD folio (nr_pages < HPAGE_PMD_NR), whenever
khugepaged_max_ptes_none is in the range
[HPAGE_PMD_NR - HPAGE_PMD_NR / nr_pages + 1, HPAGE_PMD_NR - 2] (for example,
481..510 for an order-4 mTHP on 4K base pages where HPAGE_PMD_NR is 512),
DIV_ROUND_UP(max_ptes_none * nr_pages, HPAGE_PMD_NR) evaluates to nr_pages.
In that case, ++num_zero_pages > max_ptes_none can never be true during the
nr_pages iterations, so even a 100% zero-filled folio scans all nr_pages
subpages with pages_identical() and returns false, dropping the folio from
deferred_split_lru without splitting.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023230006.3759=
543-1-joannelkoong@gmail.com?part=3D1

