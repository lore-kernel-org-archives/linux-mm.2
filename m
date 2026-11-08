Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09CD6073CC1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evCJOY+g
Received: by kanga.kvack.org (Postfix)
	id 443286B05B0; Sun,  8 Nov 2026 15:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4906B05B1; Sun,  8 Nov 2026 15:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B826B05B2; Sun,  8 Nov 2026 15:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C8B6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:23:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 781F280505
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:40 +0000 (UTC)
X-FDA: 85413077400.06.3712834
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3C55140004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evCJOY+g;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794169418;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLSNq312cKLDEo3U4exWhRNTp6plA4woo3CVLNEmLks=;
	b=dvTntOLPYqnCzmOHFz0Abx2HuTI7S2DWOI5r5Wk4wXd6Lc7dEtJTpb+ORP5d/uot9lXG4i
	nTg1eYl2JCG6nhw8QOSm5rQTvZHoRl0XK0y/9Im3HfWVn21CcFJYLRQwSgNPRAR6phJcQs
	PqFKEPvXh8t/wnt1moV4RYBiZRSCYco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794169418;
	b=Akp04kv/kolDTDsoAc2EkY64D3uVYoNJbdpGXY4IUfoUuOD+cWO0QBkogKBEIWodbIyeNi
	duAKLXgnVoVHsNmBpKgMIi/K82Y2X8FSofErXprwuB7WSlujrsZbeHD12RLDz1PqR0eCa8
	9JYUMLhQNN1JtgiX7WfTmReKRiGUv94=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evCJOY+g;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F20D440676;
	Sun,  8 Nov 2026 20:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2DC1F008A5;
	Sun,  8 Nov 2026 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169417;
	bh=RLSNq312cKLDEo3U4exWhRNTp6plA4woo3CVLNEmLks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=evCJOY+gVUzp1DzjbiFmkH/UuXhVATwMh845mwI4vVAh+Aa/q0GFq0cVn8tFnIO9A
	 5TCvjXUI75bQz0elpEuxKCFYvuScWi2cHh6OeupP6bAtMpQiik+Hp+f+K3Z6PgSdBZ
	 YjNFeyiiuUJLlGAgQgp9aEXbdrv3E5Bd0KYIUuMIjJw2V5AWmDjw8fqRqIBtymfj/D
	 N3fr0iIppXQ5GKTAJTZ6An87iDVqgbhPyvHPRbosKi13NgqPe7ued6w3ES30fbwyPt
	 xIOjqFJfoio2T6CBZgpsb/oLNKUncrosAxykc7yQTqxEvLIyuEo64V9R63sIcv7MGE
	 fkPCTTYMs6Cig==
Message-ID: <sashiko-outbox-204013@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if region
 split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261108201456.116824-2-sj@kernel.org>
References: <20261108201456.116824-1-sj@kernel.org>
 <20261108201456.116824-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:23:37 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3C55140004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ijumcqansp7ci6ncm5osy1gmr5jz3xwm
X-Rspam-User: 
X-HE-Tag: 1794169418-873484
X-HE-Meta: U2FsdGVkX1/Sr10S3gl02izbQopRGOSFz+cKMVFu3D0ztrHGmAc/46jCLDQZ3bWpInTmz5tnoxcG7PAs28SlGoO0uZ7Y0c0UNZ/unvrjWP2fDgqN2gGkqfs53b9j01zGv/hNS9G0sn3t2dSB+ajgPJ2adEB4WDlEI1rzDdHF14/tM16Bj/NreDhzTMh43bZth5OiUBHutly4bA8DbiTv2ZT3zC9KLf1MCkRdLL7o5wZ6hNn7Tv2+rICm/G6uFMn8GcFKG7BjmQ1h8QxkQqMd+mkqJMVUK6xFBaWt8eJ9h5kbXqNyZophTTC6MKk2aydwq4FJH0ZOy8BmKvkdeodznJPlESl5Bw/KRD3lHkZMK9qW1mUAB7pMS3KxbOUHHtLROSgXKdn1qZIj9ulWUNFtC6gt91WMVlh+bCU9R8LoYW2/VYGMnN7AdJ1q3oziSpp2Ru+DeyZfxwhTZyEDFahQVngF+PwzmOxbSveAzea/tKlj8/u4qBlstpVlqbv2tndaliNR7q62h19V4n5ELJbuWtO45UZgR6ve3BG8SXd5mg4nyhuGacKNVHGqUER8koE8/D3MJhvzxSH0oVOzBnsXj8D9/d3XSRsE/mL3gXIpMdlGyTpOuOTTgDVl4jq1EVfyxICxtYZU8U4tLOhTGuDKPURpsL9lRCPsQKXDxp6UCnO8q1Ob/yFVDRR/1SlzKskUkr5Rz519fAoDHMt2S1PBArwS3J/Nywls6LXZsFEczzV4bTaqgnr5t6PRffUYax2mC7op9fj4cFE1yy5oHshM39U1LGDTKrvzXGfkfEFVIDSwjAjSth2iBUIFnIovQL4nsGrKqRdHHKobyeKSbLcw3Syo1V9iKXwTpu8qao8ENQSTSSF0jtb08+25UkeDUbKBrUR3SccBzkzp0v0qAvGHNIElT9Wpzhdhp6NAPacg5nwrisIZVuKKACmv+GW8iY3K7QfFqNUPeQjg4bAGKgh
 hBWHhq2D
 0JxggKjWbcY7m/i2BCqNcOrEaiPaG8dA8Pv6JxBR37WE/8py7zdOlvAj7og0kMSggoYrN3mFYFTc/zM784wOiRFRWD+w5cBYuC/EgDKmwER5q2E4vwqO+r4GmVfxvLLpeFRqpoOVDV1OyId1V/d6x4J7YD0u6aqlUnmx2DDj26cX2wvEIqGjh76caykIFcK0tBLrvSguFgQ2iN1hwb7nNhDWkrHiFEguJHffRCHkpaE04oXn6R72T0aBqnrRUWC5CtbkeHA5ZAzDEQGVrmmzElat2/yOpggQ0uj7kdxPQeXlhZUvDbuiYZ6RdN0gQqoT+KPeKUc8P3ieaINnhvRC4K9cJEh69QnSOn0HI53udm1fB5LTCHpByKgBef2Kju4C74PudL4uFdkGa4SjpX0aThwP9LW25A+PDBcyg2RpPEhAj8XFkKL+bQEdCpFXsZRBY/Fwc04FMJqZUlac9jsTrdFo43Ik6ej4SiQNEOkhklLZ1mlQqJUHEFODrVm9jx75mvNlhF5U9JGL0FnYhWZTYd2pM+rA6+m74pONhzwPV2kDsWcgclQkfcH2PCUQMHt7SoxsrRArI9zqStbJmDx5H5Pgm1Q==
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
- [Medium] mm/damon: false tried stats on split failure in
  damos_apply_scheme()
--

commit 17459070b1916b2d77f607f0fb7f0f9158e6224f
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damos_apply_scheme() if splitting a region to fit within the size quota
fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b5b6d00d7a3b5..9d4a78deaa06a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1004,7 +1004,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  					DAMON_MIN_REGION);
>  			if (!sz)
>  				goto update_stat;
> -			damon_split_region_at(t, r, sz);
> +			if (damon_split_region_at(t, r, sz))
> +				goto update_stat;

[Severity: Medium]
Does jumping to update_stat here falsely inflate s->stat.nr_tried and
s->stat.sz_tried when damon_split_region_at() fails?

At this point sz is the non-zero remaining quota size, and
damos_update_stat(s, sz, sz_applied) unconditionally increments
s->stat.nr_tried and adds sz to s->stat.sz_tried even though
damos_filter_out() and c->ops.apply_scheme() were skipped.  Because
quota->charged_sz is not updated on split failure, every subsequent
matching region in the walk that exceeds the remaining quota and fails to
split will also add sz to s->stat.sz_tried again.  Returning early here, as
damos_filter_out() does just below, would avoid counting skipped regions as
tried.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108201456.1168=
24-1-sj@kernel.org?part=3D1

