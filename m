Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76C1606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izoUe4pp
Received: by kanga.kvack.org (Postfix)
	id 857A36B05B9; Sat, 14 Nov 2026 06:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808B76B05BA; Sat, 14 Nov 2026 06:03:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722026B05BB; Sat, 14 Nov 2026 06:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37D866B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:03:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A801A1403C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:03:50 +0000 (UTC)
X-FDA: 85433439420.29.222A592
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 101D3180004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:03:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izoUe4pp;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794654229;
	b=qkL55s8eeQT2UEIyoqhzVljcJ5704MhwPAQNMoQs/yrHPqf5KdET224WWSYItYDuf5Nob3
	mdIHoQmxC3p6fdODJUSYtsR2STlQk33+toNZ5cj/ztX2xgJI8QDONoKVKgFjDhUQpVp7PB
	zXqKO7o9laMa3E4ZTb6xm4zmFMd/SNA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izoUe4pp;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794654229;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2yvN6p0CMcKTPXWgEhokRWnvBsx4PbkcEfOzWdlE7o=;
	b=rnCEIUclEK9J9s1X9aDcxHg9KhWRRbXpNEWX4CXEtOREgiEWXkudtKQGgeU8TzAlejxdf8
	cxDZ2ZEzsqmyx6Ob1dt6e36PKlWd58Dm90WZC0J8xlzumnJiNbfTYEVQRgpCidveM5/TMv
	fFIsoN+xcpzMwI0Cc4bC5dtoR65RIH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90E6E60CFB;
	Sat, 14 Nov 2026 11:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008CC1F000C4;
	Sat, 14 Nov 2026 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794654227;
	bh=W2yvN6p0CMcKTPXWgEhokRWnvBsx4PbkcEfOzWdlE7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izoUe4ppxY2kboEQgZ5ncKIDZKm5vr9Lsy/xyUJYvEjxmhJNAzu9Vo9X/JGYu/T9Z
	 PXmThVWQR0JqQQw3gGpqyTqMh7XHY82k/C1NBoH7gcHcgGNxLB7m+XChMzQKzmRjyN
	 pUpEHhkAX4dCS5BT7Mk9gUYViAAcYVqIaCQShqM964YqqGhO7FBFMYceG86J7e/NKt
	 no8bKbxkKnMW+BClFSa1rnhcfVn2zVD53LlSjnGORwCXSX8bcCgMqs6VExfUA+yy34
	 GFBrVt7faF1sf62Rt13MPKtLYENk/S8qPMxTUQDS626fofw95MyBDMX9pnchi3oYDw
	 oEeGJI1QQmWnw==
Message-ID: <sashiko-outbox-214380@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18.y 3/3] mm/page_alloc: avoid direct reclaim and
 compaction for costly __GFP_NORETRY allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Salvatore Dipietro" <dipiets@amazon.it>
Cc: dipietro.salvatore@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261113110259.2901456-4-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
 <20261113110259.2901456-4-dipiets@amazon.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:03:46 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 101D3180004
X-Stat-Signature: yg4iiodci39w1j8zhn5a3zyyibt86755
X-Rspam-User: 
X-HE-Tag: 1794654228-479055
X-HE-Meta: U2FsdGVkX19fMY2aCDOWRiYM7qrz+bjzqTN8piKqldjVdUOgCPmctSemtL3bYjk4hSxvFZKqUSUfK7KC9THslTQCJ4EGedt8R5WQr3pb6e53V/1LBBGMv9LjsYJdj1KxKLuh2vIFP8FQ+ClDYykvuJrYa64cNLNneDT9N+br8GCWtD5te0Ss6rLninxfWoeXg+pjdYm+vsFinYwjTcmfH3tNsqLbDS+e4i5fL5WyBRIbLgTQVuyssvEbBXXiprihH9rOi+FEeDgEPg4f9Ds/IRkYAnFH78Ea3JeRjH6JAvjts4IgwulbKTMpWE9PGrfiPbVl5iDL2T94mRTwIVIyc2tvD67MOdArflkW2v1eHE86QoFujKytYbLBQsM70jJT5t5eowYPhSo14R0JBXNWs919TeBMq+rAfNsndkfe6OZGvI19oAtn0Cp2Jbs4mL4egJffkpHvTMYmxjpcU6M3QaGCC3cxzvyFyNqVsY8H7CY4oLH1Bo/M+CSERHvMbRE9N9uHLIkVujM00h1FVzNpG6QY04T91dZCIq5uLVcIemkvzffSRgTK365UJtmE8jvOVYS+o6nZ1SK0vmKAzyAr+xbDjDalAIw7wFAp5NyLWFVco0NHCM1sE/6JfcC1lCto6NSsisbOqsxmiFIMa0wbAm0xDyF9PvQS64O1ZwEiS7dGxyreK2sIBUlGibafNn6JtHqPWFinJPr8KyWnjhFisivAzMv1wHZF6okzgMJnIoaSW2y9AGoWg6/3tWlOAukGE+sj/ElsfUJZeKxxHYxa87eTAK37DB/XO8NOeayd0Hum9qGCJklpFhN+wR83aDHL9bbZykXvvjnSCgLgArWPxGApuPVfyUm0KJR47tgt2ZudxK7LwUHUxP+ZD7wLplTz+G4VAS6GmDqEMxv0GpXm52Mjm6kqEsyBOOCz7f67mcCAjvf+x9f3+Gb18KKcKrCkUM6hCzOqbDvOL+5GabF
 mTSnBjwB
 s6j7P3TShErqTS4YQTmt7HMjLYSuBVfyxzPtNly3YzJWwal1TTgoy2i3rb6fdiqDLgTJcsdwJdq76um5fAG6giA0ZDtBXT2UlNO8m2f+2Rnl6YApahznMRS2tg9E4dlLStFXkEyowJHZUS8HKCA12wQd2rToMmehFKPVZpOy4Qz3q3eHvt+I2olKJR9QI0qmYjbdPdbCAkXWp4k9u6TyCfScs8CjWr7eMS434Bc6xz7lXzXSOLsZOFv8e9gdsZawD/H0vRiQbffJMvAHatjEXkkuXWO3Y60N+Wb+WfR0agw+lbEvAJCIuLTCPPCl9Nv6yQm/1Z3c/dLhF10l8fbHdxFizd8cFpmjKAwsu/TrurVOE3UFi50LOr55dCV18rUca278cpuDQWk+ifoa7cvHnJmaxsOF/YGUESaB2wTAwd+taB0wBTa8YTJZ/WFwvK91hzasCglZHlDLaiCXDnNpPKrScMONDUL9ld+eXlGS6X1lTWnK2oSHHwNSEGbUQB8Er9xClQIRbigGER1x7rOfxnMMHstmewKui2LlmLDB2C/sNUsSeuFgP075H2fJk9z39XvKzq+6LOamUvZcQFUh/nGI7+WRQAwp+laBfoSKNNFUx9zjWDVOZSQG8H+xiHSGmBz6CMzE/33RIWz+n/yez19iDxs/EcIhviNkxxxQQ1DCkuW6DRJAIsxMVsTDakKDpQ9Nw5kZecXEIY/4=
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
- [Medium] mm/page_alloc: clearing __GFP_DIRECT_RECLAIM breaks THP
  defrag=3Dalways
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] mm/page_alloc: premature OOM kill due to concurrent defrag_mode
  update [1]
--

commit c68a1136d4935b5c8880839164e923ec2040b9fb
Author: Salvatore Dipietro <dipiets@amazon.it>

mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY=
 allocations

This commit clears __GFP_DIRECT_RECLAIM at the start of
__alloc_pages_slowpath() for costly-order __GFP_NORETRY allocations that
do not also specify __GFP_THISNODE, avoiding direct reclaim and direct
compaction.

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T=
/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.=
it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/=
T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.i=
t/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.i=
t/T/#u [v5]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c1ba49ba51d75..a7aab8dde3ad6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4743,7 +4743,7 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;
> +	bool can_direct_reclaim;
>  	bool can_compact =3D gfp_compaction_allowed(gfp_mask);
>  	bool nofail =3D gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order =3D order > PAGE_ALLOC_COSTLY_ORDER;
> @@ -4758,6 +4758,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned in=
t order,
>  	unsigned int zonelist_iter_cookie;
>  	int reserve_flags;
> =20
> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
> +	    !(gfp_mask & __GFP_THISNODE))
> +		gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;

[Severity: Medium]
Does clearing __GFP_DIRECT_RECLAIM here cause a regression for transparent
hugepage allocations under transparent_hugepage/defrag=3Dalways?

When TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG is enabled,
vma_thp_gfp_mask() returns GFP_TRANSHUGE | __GFP_NORETRY for non-madvised
VMAs, which lacks both __GFP_THISNODE and __GFP_KSWAPD_RECLAIM.
alloc_pages_mpol() only adds __GFP_THISNODE on CONFIG_NUMA=3Dy for the
initial local-node pass of order =3D=3D HPAGE_PMD_ORDER.  As a result, cost=
ly
mTHP allocations (orders 4..8), !CONFIG_NUMA THP allocations, and the
all-node retry in alloc_pages_mpol() have __GFP_DIRECT_RECLAIM stripped
here and bail out without direct compaction, direct reclaim, or waking
kswapd.

In addition, because reaching the costly_order && (gfp_mask &
__GFP_NORETRY) check inside the initial direct-compaction block now
requires __GFP_THISNODE to be set, the if (gfp_mask & __GFP_THISNODE)
goto nopage branch there is always taken, leaving compact_priority =3D
INIT_COMPACT_PRIORITY unreachable.

[Severity: High]
This problem wasn't introduced by this patch, but can a concurrent sysctl
write to vm.defrag_mode [1] cause __alloc_pages_slowpath() to trigger
a premature OOM kill?

When defrag_mode is enabled at the start of the slowpath,
gfp_to_alloc_flags() sets ALLOC_NOFRAGMENT in alloc_flags.  If reclaim and
compaction fail, the fallback check before __alloc_pages_may_oom() re-reads
defrag_mode:

mm/page_alloc.c:__alloc_pages_slowpath() {
	...
	/* Reclaim/compaction failed to prevent the fallback */
	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
		alloc_flags &=3D ~ALLOC_NOFRAGMENT;
		goto retry;
	}
	...
	/* Reclaim has failed us, start killing things */
	page =3D __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
}

If vm.defrag_mode is cleared to 0 while the allocation is in the slowpath,
this check evaluates to false, so __alloc_pages_slowpath() never drops
ALLOC_NOFRAGMENT and proceeds to __alloc_pages_may_oom() even though
unfragmented fallback pageblocks may be available.  Checking only
alloc_flags & ALLOC_NOFRAGMENT avoids depending on the live sysctl value.

[1] https://sashiko.dev/#/bug/linux-47853a87-6054-4869-a159-48ddf577eff4

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113110259.2901=
456-1-dipiets@amazon.it?part=3D3

