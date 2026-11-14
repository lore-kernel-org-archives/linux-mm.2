Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2906A606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKFF5W8J
Received: by kanga.kvack.org (Postfix)
	id 3F3B96B05BD; Sat, 14 Nov 2026 06:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB546B05BE; Sat, 14 Nov 2026 06:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C8D6B05BF; Sat, 14 Nov 2026 06:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F2C6B05BD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:08:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C408803BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:08:07 +0000 (UTC)
X-FDA: 85433450214.29.D7C36E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B766020004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:08:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKFF5W8J;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794654485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnF+uUTpxIcviorCaCf2ALCF9ao3nMlqUUwiTgupWxk=;
	b=qZ3o0E5Iu8AO1krXh+1KchGKTIfSsd3WEE1s0ITQP1OYDFlkdJssM4MTxR2csLdQryzbfx
	sT7CJdbhHlwmcmrxor74sqRo69qCtwt/re7RNjSy6uyq0w87qQvKH7uRFQRv8AV80gyTcP
	z5j4BfiEQHOpTOYEfbR+GhP9kw3aHL0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794654485;
	b=Ta0BbhcHtlJRUPY2RuAo/GZiX13WIp2rN9ni1bCoxuP5rnVfx3473fSsX8O4R3HF/uW35y
	hkl1z4T3a+twjfTeJuy+rIIrA4U+nbSOxeEO1knmLB/mBijGtlcZXm6BBS9ebibtdalMhK
	wywSGAiVcgXOmuRhtTsBUeKp3ysxSmg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKFF5W8J;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CACAE43619;
	Sat, 14 Nov 2026 11:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678DA1F000C4;
	Sat, 14 Nov 2026 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794654484;
	bh=LnF+uUTpxIcviorCaCf2ALCF9ao3nMlqUUwiTgupWxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZKFF5W8JXjvF47VMp+9kX3yY6h1WEi+JyW2lGmPeza3VAC+5l3vIwikFAG/JCwLUk
	 0YK1mIvCM8nd4hl3dLQIrmsRgcnSGkXmKSCKaeNTGvJZTgnTY+5tuQqgnoodx8qYS2
	 DTUoMfiEE7npor3jL97Ox40OqcbVBkmlxnml4LMiOZNTgkyQS5FdRhFYYeVolyKxe9
	 C8vbhLanW2gHBHWrgUbCbbL9Xde3r7i6lFJE4ceC/QFPEnpRZU8gu0R3wm4PrCKg6A
	 SGIKS+dNKj0Hv+63WfyeTljt77DxDfvUGlEMGQ3l+03uUfgxSxj5Ha2XSqb4nPskR0
	 vhn+a3+ZxCmHg==
Message-ID: <sashiko-outbox-214392@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 3/3] mm/page_alloc: avoid direct reclaim and
 compaction for costly __GFP_NORETRY allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Salvatore Dipietro" <dipiets@amazon.it>
Cc: dipietro.salvatore@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261113110724.2920455-4-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
 <20261113110724.2920455-4-dipiets@amazon.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:08:04 +0000
X-Stat-Signature: ng9kguueoc6in75zh1jmhoh8pra8tmp6
X-Rspamd-Queue-Id: B766020004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794654485-737189
X-HE-Meta: U2FsdGVkX19wUwu2PllnJO14Skl6om/G4DEqqxodMz3r/XlyNimhynlIdNoRqgrIurlXJKt2Lkvbv14WhkAuxga+yDlec8xaaeSk9XRw4h7pw9luUW9d/cUUO+pJNDmukYBIyQ/Nq/JuyoIAsuPU4gsvFEbGOuOmwPI/Gan+nBO/NO+HPGsvMmdY4u1kk36hOSuTW6CIGKdxLCq/G2qKlFayrAHoB4ZW6FaCBAMoYs/rZnQeulxCPEdf9QjJW3OfOCbPgNo+YWF764xyEpcEq2DHDjhwYh3nkS3WjFsC8/0/KgIyEpvvI5LJWsG0KF765ccG/OZtjIT0Bt1Fvsksom/nsodm14niVcYMj4wRdHVlmqMCYezPz+jJAjE6S4F+TAX8Ve1XuCMP3i/XgHuRe0LxoLGaZWMER8ObX0FrVY1Mao+KMszvIGkQmGxRhMg64uv7H5kc470EhY29w3lsAnWYmT0ek5ZVs4gqHtoG1V86XGU5WkeN2PdVOkIrHZHBSgab/8QorTEWU+amtWiVDpyb9Gw8oSeZoByB46c5UfdqhlKONSmSDnDG0EIOeqybw2yHQaceF7GYwAdvEMtPjGgBqECK0F8gNG8Wedka2mKNMvHrOTzrtlL+ZT571v/MtJt+Yx68l3Ijn+gAplQh+Ql8nZM+g+xrhp79/MdZIkxds7AINyEWigzKeDmKpZFEVK9w/p7IQ2MrjMc4bxBampwUtJRSTXm6xHyJc/+Qg9v/MH7w/7ka1sQsksQwZSQUxdrqix6WzJS4xFGOFetGT1OCUgg2s6JVN3G13TZqAesnTyJvyflBHQzfYBb/TPOWNQ1Hx0V1P6QpBaAFTQ6u+CmMcADtINj0aaRmHwzKZMwiI8s2qeT3Gzi0r6NnmI/0HnuEeaXLLuRe+YECRbiMJ6tLJ2Bj/z//DVwUSR+DQWOYr67WNFU1JMliGrmzO7RtVn78yQX1gXLr5hF54pd
 z+c+ugvb
 ageZtFTPwqjWMWiwp4/zp8xhKchzy9BwM8AhIJRR6Sd0f+bdvtHVE6VmARmH/g9s6NhQEuYw/ES6YFOQWzOrDSa7fbrnuvCyqqU5vF7nFkpwMz4R7qEZXihjS81kuhkIWtRtZcblpv+VXwv+pXA0xzU/Xq743DiZlvSP/W//Yvp5RGa3mfY0Rbjo4sDXvz2Y7+yq6wgItONv2wYcu+9fN1UXnXZvRiAT/noTerCv6D/YIdSheLjSPeFsx0CW5PNFrQHo/hMtwVwIf6IrkifX1sFyXc9oBAlJmM4qZFlrltN14Ac3BErZ70Sy5q2isDVLxy+hbd/xjtV2fzzGHEZU7rQhgk3lKbkb8dUEKliWrrjmBIRIaFx5c36Fzy/y6T1WUeEhb7SWqvoEzXBNnRwwQSS0xh/nTWKEvXNDLAtoraFGzxEzRrPCN903RqxygB6L1D5Fxh4ODghiV5e5r1Ahi4ne/4ZM8iE2sYvzmzvfO/agKId+vHHi1q7XkD4pc0F7724iRZd8aRBcENT7AbH/Rn7AYWFt1/VDN5LfU28LVSim1rtD3JZ/HBTLrkyh7CYThKHaI6psZ0hsgWvllObQ25gRmIgEQySZ6mVS4jxCLnEahdJkRJspJPZZPlRC7WXyx/H8n695EE0ywaKhvfOf11eJtGxC9DEzsQY5PVYOxPy3iuLTOxDdCCBgINyzbgd//jqYwhC60RMUhpnU=
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
- [Medium] mm/page_alloc: __alloc_pages_slowpath() skips reclaim for
  defrag=3Dalways THP
--

commit 96be855a15aa5fcbbe0ed938a76cc7cd6f5771e1
Author: Salvatore Dipietro <dipiets@amazon.it>

mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY=
 allocations

This commit clears __GFP_DIRECT_RECLAIM on slowpath entry for costly
__GFP_NORETRY allocations that do not specify __GFP_THISNODE, avoiding
direct reclaim and compaction.

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
> index 8ac6556d19c13..02993879aa233 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3950,7 +3950,7 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;
> +	bool can_direct_reclaim;
>  	bool can_compact =3D gfp_compaction_allowed(gfp_mask);
>  	const bool costly_order =3D order > PAGE_ALLOC_COSTLY_ORDER;
>  	struct page *page =3D NULL;
> @@ -3964,6 +3964,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned in=
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
> +
>  restart:
>  	compaction_retries =3D 0;
>  	no_progress_loops =3D 0;

[Severity: Medium]
Does clearing __GFP_DIRECT_RECLAIM here disable direct compaction and
direct reclaim for non-__GFP_THISNODE THP allocations when
transparent_hugepage/defrag is set to always?

For a VMA without MADV_HUGEPAGE under defrag=3Dalways, vma_thp_gfp_mask()
returns GFP_TRANSHUGE | __GFP_NORETRY:

mm/huge_memory.c:vma_thp_gfp_mask() {
    ...
	/* Always do synchronous compaction */
	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepag=
e_flags))
		return GFP_TRANSHUGE | (vma_madvised ? 0 : __GFP_NORETRY);
    ...
}

When vma_alloc_folio() retries across all allowed nodes after the local
__GFP_THISNODE attempt fails (or allocates under MPOL_INTERLEAVE or
MPOL_PREFERRED_MANY), it calls __folio_alloc() without __GFP_THISNODE:

mm/mempolicy.c:vma_alloc_folio() {
    ...
			if (!folio && (gfp & __GFP_DIRECT_RECLAIM))
				folio =3D __folio_alloc(gfp, order, hpage_node,
						      nmask);
    ...
}

Because HPAGE_PMD_ORDER > PAGE_ALLOC_COSTLY_ORDER,
__alloc_pages_slowpath() now clears __GFP_DIRECT_RECLAIM and skips both
__alloc_pages_direct_compact() and __alloc_pages_direct_reclaim() on
those attempts.

This also makes the async compaction priority fallback in the initial
direct compaction block unreachable dead code, since reaching
costly_order && (gfp_mask & __GFP_NORETRY) inside the can_direct_reclaim
block now requires __GFP_THISNODE to be set, so the check there always
branches to nopage:

mm/page_alloc.c:__alloc_pages_slowpath() {
    ...
		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
			...
			if (gfp_mask & __GFP_THISNODE)
				goto nopage;

			compact_priority =3D INIT_COMPACT_PRIORITY;
		}
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113110724.2920=
455-1-dipiets@amazon.it?part=3D3

