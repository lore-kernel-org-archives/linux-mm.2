Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A23A606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5KqtXjY
Received: by kanga.kvack.org (Postfix)
	id 34C496B05B1; Sat, 14 Nov 2026 16:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC986B05B2; Sat, 14 Nov 2026 16:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215046B05B3; Sat, 14 Nov 2026 16:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 018216B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:05:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2BF212042B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:05:07 +0000 (UTC)
X-FDA: 85434954654.21.575CA7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 570BD40004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:05:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5KqtXjY;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794690306;
	b=sS1Rvg3pLBfHqjvZU2zWzigC20Fz6mKD/h6Wc/LG9Phlsvjhhwvw/6kc86sgRIuupaYmCr
	i23UyTUQQfyIagbvE3ucNcF5bTa8abi8Bgu+FN+2p7iXTHhmg+apcwmkM1snmkmkfFZkQr
	8EbQmpbSnl/X13Or6qzeb2y5wudPefQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5KqtXjY;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794690306;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiAJBeuv8t1mj65wkkGDx68ULiS9stmdIW+66/u+VDg=;
	b=JBBe+fd19pVFeSCDQLhCeB4TRFGkA5UrRmSnB4WrE8WFO9NXceBUm3jiwJemzQhr5O5Ro5
	EhQGRGDDJuNbfJ2WlA6P7imRpl51SSOy4u4kq6+8XezqPaeVxWQE1qQn2p6an6mYJvvfFW
	+8p3BArhgQQkk46xC8LKIwg/WKEwTLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEBC4602CA;
	Sat, 14 Nov 2026 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54A21F000C4;
	Sat, 14 Nov 2026 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794690305;
	bh=AiAJBeuv8t1mj65wkkGDx68ULiS9stmdIW+66/u+VDg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J5KqtXjYAEBsxjdxjE7gIdOoM47qhC90dtsfCMAwACr7Lw0mq2H/EnWYTeOC4XGjz
	 ua4njKdZVtJik3KKuZ/0iakhIC3pn+D7GFQ5ZO5dbyDItZ25ypqDvKc5oXV/yCDQ0j
	 3mIC/swa52E3NDOyoY+J0spwflBv5YBEYF/6szfYz/H7qrCsgZox/nhPYUVMviqZuL
	 yuaT79UxWH+/8LN/dE6FBYPReEN6FlQNUKynxbDR643kOMHGptqhtzrLIBOEXuS/FO
	 cpeyQOBtrKyxC4QVf0LdWjpCJ7aMuCUaK/lrm9eLSS+dqVkCgJEyIrfBvy3Pg4TK3c
	 b3DPLsXYP4+9Q==
Message-ID: <sashiko-outbox-215027@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann
 Horn" <jannh@google.com>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, "Tal Zussman" <tz2294@columbia.edu>
In-Reply-To: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 21:05:04 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 570BD40004
X-Stat-Signature: zbcwi5naz4mg7nxgsebaby5trh7whkik
X-Rspam-User: 
X-HE-Tag: 1794690306-29303
X-HE-Meta: U2FsdGVkX19Yfl86XY1kHkAZ6/B8PtWgdREWpuIPRKrYPKmCTinW76i0L5O5rInCK0mX/3KTfc/gx/hhnCYjzmhuUpJ4veTByncL78pZBaBD4j6hKNBxD0AwTrrpsWtKxkpvIi6T91K33klNMDtmQksG+9As2qyXFG7AVMVefU1c8M1Re8tbAIchZcFbMcyLfIu1xOstJsvt/28p05xtjS5lh7H+flPWgTIdWgN6ABHpnj22v8pdHs715ajnLMxKPoaXLRNe+XQKYlHE1Vsdxe1UC4BoP8OAPAXGxTNEZY9E43WMLjNbAtNhiTOuodV8VpKZyzNDL9fKVjGMHWWJN+WvzRe7CTQpM9PXV9/hn/Q2t1VN5l+JqDkU2tUKluQ8Vifd5R1ECTVhP3KTPQpsl2So95VutY6V4oQe4qIkquUT0U7temqjaPRD2wGMFKvFqJ+deB6nzPXBFokxLYO95cJIAzDcaRZHBv41To7CHzIBrw5ffoEWCCSeLsoPBqTBAfwRsTNQzf65HdZ4jEJPbYHS9Tt9SfJsKuWL7UoyJJwSA8pZZwNafgBS1wPfuI7bFu+05qmjBi4EJPpF3lbMyGcHbArF98RhKGGjkIw9DXsdpNCI/A9Pk5xzkEs35EQG8ZSVW/XXolPaRrGOwVQe01QW1HJbkrPsW8e6KB7B3d6RymvldMfhq2uvLXITGDMtqDXOrGNYohFb7JPZAg6dOvbaxeRG1frydYYXSrMbMU9T7/UqV7Q6ixtKG66HZHucYWX8t4O6E/a2XS08vFvKmnUPnwrLXvtOVBO5Rjhb2V5UXT5v14qFV0+l/MQrfHD1JFAQZwgK3WR6f3zWg5lHH+MPAbmziwPKOgAMBWvIuJLoWpWs5r3zndy2AIcbH8t/wknIy9L8Ki2iXB/QgUKqbb0jHyxfrBKGSRCEq85mpzPIR1WIbS2nMW6RNash9X+aU6+6POJYH1275pT9m94
 KPgdSkt7
 IHq9GYncxIigA1mvohMUd2ur5SqVYX55zPy6Lertp4A3i1J4SI10neDDuYy4UuXVJkLWFohBlCM5e/SDPLFFBvqw9tf4Sbdq/u162RcPh8le5QLTs6lm1LVK/ki7ECQMteVlKKs2u161VXjG904FnlO61GIGv3lSPB3UicslulJZtESVxkasQ090vnewPSgpg7tI+IEagtx+oIVJSHB9zoJKCuayEDpOB1xg+6bIFI9f85JLssIgWWnyohZw3WXHW/IKgPoZ17RbJM4G6JED5AS+Tu1AN/XdyAUM8muIs/F4wQohYfr9vZM+FpA06BWKaAItZBbd9JVqgNUd+ESohcrYuJgtTSTxaaS2jSJb05CktcHr2Z36s19lq7aNIIo+oTd0/dEWQf1TinwWe2jGL7+2ybuHil2D7U8MbBcCopEoszE4qtrvp2ZpCaYGOR2HXXllzSFLZ3X1ZSoenn/kXSCSuBWItw3VZsL/HbI5FKf3zARedAZaPQ6vypVOkiZYPG2y74BRzsAtcSToypcQNVdNMvfQLinX/6qWSSU2aww76wlQX2lfdPEUstznthrbwd4izIJsV/5fy0VK15BDrUYmGhmESLDMkD4hmbfQ3Mtw6ByukzfIlXc7tRzpKS5TMPCO0
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
- [Medium] mm/madvise: zap_range() reclaims PTE tables needed by
  madvise_guard_install()
--

commit b93124c4df6f4f255fb9c4d2510c6ff4b474ec35
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/madvise: zap markers from guard regions

This commit introduces a zap_range() helper and uses it in
madvise_guard_install() with ZAP_FLAG_DROP_MARKER so that existing PTE
markers are dropped when zapping a range prior to installing guard markers.

> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014f..4f77285832079 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_be=
havior *madv_behavior)
>  	return 0;
>  }
> =20
> +static void zap_range(struct madvise_behavior *madv_behavior,
> +		      zap_flags_t flags)
> +{
> +	const struct madvise_behavior_range *range =3D &madv_behavior->range;
> +	struct zap_details details =3D {
> +		.reclaim_pt =3D true,
> +		.zap_flags =3D flags,
> +	};
> +
> +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> +			      range->start, range->end - range->start, &details);
> +}

[ ... ]

> @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_b=
ehavior *madv_behavior)
> =20
>  		/*
>  		 * OK some of the range have non-guard pages mapped, zap
> -		 * them. This leaves existing guard pages in place.
> +		 * them. This also drops any PTE markers in the range,
> +		 * including existing guard markers, which we reinstall on
> +		 * the next attempt.
>  		 */
> -		zap_vma_range(vma, range->start, range->end - range->start);
> +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
>  	}

[Severity: Medium]
Should zap_range() avoid setting details.reclaim_pt =3D true when called fr=
om
madvise_guard_install()?

When a guard installation range spans at least a full PMD and contains any
mapped page, swap entry, or non-guard marker, zap_range() with
ZAP_FLAG_DROP_MARKER clears every PTE in the PMD and reclaims the empty PTE
page table via pte_free_tlb().  On the very next iteration of the loop,
madvise_guard_install() walks the same range to install PTE_MARKER_GUARD
entries and walk_pmd_range() has to allocate a replacement PTE page table v=
ia
__pte_alloc() while the old table is still queued in madv_behavior->tlb.

Besides the unnecessary page table teardown and reallocation, __pte_alloc()
on the retry pass can fail with -ENOMEM under tight memory or memcg limits
even when the PTE page tables were already allocated before the zap, leaving
any pre-existing guard markers in the zapped range removed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-disallow-u=
ffd-guard-install-v2-1-9d0063c70542@kernel.org?part=3D1

