Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F06A606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=diEZgidU
Received: by kanga.kvack.org (Postfix)
	id A949D6B05B2; Tue, 10 Nov 2026 22:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44C26B05B4; Tue, 10 Nov 2026 22:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933F06B05B5; Tue, 10 Nov 2026 22:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 629806B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:52:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D483E1601FF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:52:31 +0000 (UTC)
X-FDA: 85421466102.15.F9C02F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 297E0160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:52:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=diEZgidU;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794369150;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rzvg6Rv2egbPNtYO117p4fqoKUmOvabHG1IQqYz+24U=;
	b=Ws6YHrNE4gshW3z381f8Jq81sY9cmtv8DMkUF7rLRcygRinSS8IeNT/6+aMit2K79ANslU
	xPg6QvhbVTpORThDe+/obCARoLv5mf9igxomfTtz9Z1GJDnNtW/K6lUg0rZlt2MFwMtE6T
	EIbjjEkP2WGdlBtE5P5yhva4GnvXQl0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794369150;
	b=SwINqhYAR3HQHB2n1JfCznIvNsjCEB3epFG4VJZwynHU0MNsVbf94IxXeHhFHrNs/6s8GD
	paTR5YZe+sOC1T1bUGWjlEOpRhQ2zhR1FbBCc2kWUHgQRH8Qkz35fj55SOWe1NFDvGWmY9
	EwQjIUH6jsJvBHNnxPfhHtOLhK5UNy4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=diEZgidU;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 704444581F;
	Wed, 11 Nov 2026 03:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D661F0089F;
	Wed, 11 Nov 2026 03:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794369149;
	bh=Rzvg6Rv2egbPNtYO117p4fqoKUmOvabHG1IQqYz+24U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=diEZgidUKB8AbmecuZJCoq52ECZBcwggkxMQ2gY+Sx/kFokOLNaZ6USbftGInT730
	 tncLRjGNYpUb3WH8sFp/FmE2+S8+qwFD/Xl/OZuIvWOLSTYgXV6NPAIYx9X0wvIzng
	 vFg7T1EfzBDHqq40hqwrgs4nYrL8PL60tupGJLazwN7ulGO8n+d3pCCoDUQWzT3bm7
	 P7qsvGWLo56+FcmdT15VmKDliy/BX4jVQnr4asc8s7AzW2jm0kWSvoF+XBgQrsbD/1
	 4yF1CTKvOy9tz8jEQbmVGnwHWS6KKTz8EAJMkg6sncAqUFiEu2kVhvOnbBDWQ4TVOb
	 kEUepw8kfT3Mg==
Message-ID: <sashiko-outbox-208240@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/3] mm: move folio split code into mm/folio_split.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fang Xieyan" <fangxy@xiaopeng.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew Wilcox" <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Hugh Dickins" <hughd@google.com>, "Carlos Maiolino" <cem@kernel.org>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, linux-mm@kvack.org, "Liu Chao" <liuc63@xiaopeng.com>
In-Reply-To: <20261110035205.3036-2-fangxy@xiaopeng.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
 <20261110035205.3036-2-fangxy@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:52:27 +0000
X-Stat-Signature: b3b6twpyn1d3rt4fkn8jj6tamemaa4ug
X-Rspamd-Queue-Id: 297E0160003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794369150-299659
X-HE-Meta: U2FsdGVkX18qlee4j0Pg0Fn+3tMzUYvPcQyqPk4eNeYEUeeMiVVZjiTMGtuVJ9kmkoH0JkpvCID3jXkN1hTkOhA/A6/rnKFiIZRAUDHutuaFsp6SPmTf6lHPhHwTzA6Pjb6/EPKGgTSZ6FP3IRFCfBArUawCrUrfzA06QPP6m6EP0h+qPsc3AEFQJMecqr58CnEHA1URN3tIfpbAfWMPtQhdjxidEZ2oHjdsjkgBEw9MnX+1gPESPHSm72yWXMruHCa4xWA+Iwk65wjhMKq86CdB8v6Qd0FVHUsfJJm/F6fciJdA9mcqzDERndJr4ICrjW7jn4PnHmdGgMt4K+I4Xl1U7CqoRiiO7D1PPBbcr2u6eROBuqBFIIgjbWJLYFRfZi0BOVKN+PeOCktKdIMmmrpLpSsNUU3e7NDjl9MB/S0WIVoUs6veFghuyrRpSnsPqtb/3BL0GQwBJTX2itn8saGkWMumHndS+kcltTizM2gr4ynQdKLOD5/427ZIwZf6Y+31yDIVtIg1g9wdskwldoNzhD50QNO4S7Vzk5nni3GHEaSJURZTpYTzIdKNxGPjG0p09zBtVDD/jfAJBPcZ26nb1qJTOpA6Jzb93jR184UKYTha47Qf9DCP5kpmQyo7/dA3lWrxg4EczFGruDg2WMI3wMi21uZ3oytUfEzdjn7EtQ6R4TBwYJI3taaj7gPzkAeHk9lER18dV3PnMU2Svj90fp1RLnddTjRcRW6EI0EqXhkZ/Nws9mvI5MPfs4YLrJi6Dh7pCQ/9CZiGMtkKGJgMYzVopBfqVLy8Th8MQlBcECxSNggCEuwb8iaQ25TW7jpVRYVSeGzoyVnJPH6pG6N14ydeIMogGU5jYwGqZF9oRSF99KPrPVfxel9OQE774qdfxpiD1hSYUQ2cjpDWSLDTvK4KDcdjmGMXZLqFnBKtRH1z2WDa371eJyHBsTseAVbvZQ5l4Zf23SsY/4a
 gb5YHOmA
 QdPJL6NUPfPOuChXIjT0RwIBeN5tdCRFfJGsFnSRKwu1tFv9SadmHwPWGQ771b0YApMN143Z286PCm7ij7vGKULu+d+yTn6uIOAGjIeCH5o48L78ptKTcrGam6JD6rLIiVJZDKT/BC+9o8pbKhpgiqZ1WpU8I1R0UM12n/A18yINCvUCno0siCoiZV9kPN3NsepIBnMdRC0FS6QwIOU1SFDrMVEbTOxGsNjbKZtaTQEAcSjtT/rsZUpII4qd70MeZxtBSpzUueWReVBt6Fevrp/HQkq3Su1UPngoKcipOLYOHkG+jI6rn1VR9sLeDCIGLoJq+33EDgc8a7PGasfxLK1+ILppPL2cV8IYgfD+607QnYLjRKuEO8nDQr2M1+cqTubhIHQh7WjvqkwffPtmNLxU5TxUefmvchW06GUYSy291K+cKdyG0+M/hv4e6nm+zs4niV4MTiO4n5dPdpOZryB15SLzLO5nfLs8Bpl5P554oP/PNQaWgE54nrtrjWG0x6qmnpIPM7WK0DjHsen3wYi2xFoteKDVXG2dPOz9aQti5ELoAi+3qsUKR79kY5SwfAhq6Z+v6kUaBKlOno85E2Xw6os2euAGzol+AoKUDxAZquNVkCoPfxt7OLsK1CjFB1Mqia3dLyQCJME7ckn5/R+HJIieePzV4Ilv+jOeoJUPwUN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: missing linux/page_idle.h include in mm/folio_split.c
  breaks 32-bit build
- [Low] mm: missing mm/folio_split.c kernel-doc in
  Documentation/core-api/mm-api.rst
- [Low] mm: commit message misidentifies caller of
  folio_reset_partially_mapped()
--

commit 6a62de8a2d72809396114752978350fdd94905
Author: Fang Xieyan <fangxy@xiaopeng.com>

mm: move folio split code into mm/folio_split.c

This commit moves the folio split implementation out of mm/huge_memory.c in=
to
mm/folio_split.c and exposes folio_reset_partially_mapped() in mm/internal.=
h.

>  - folio_reset_partially_mapped() is no longer static and gains a
>    declaration in mm/internal.h, because deferred_split_scan() in
>    huge_memory.c keeps calling it,

[Severity: Low]
In mm/huge_memory.c, __folio_unqueue_deferred_split() is the caller of
folio_reset_partially_mapped(), not deferred_split_scan().

> diff --git a/mm/folio_split.c b/mm/folio_split.c
> new file mode 100644
> index 0000000000000..7770d8215a076
> --- /dev/null
> +++ b/mm/folio_split.c
> @@ -0,0 +1,947 @@
[ ... ]
> +#include <linux/page_owner.h>
> +#include <linux/pgalloc_tag.h>
> +#include <linux/vmstat.h>
> +
> +#include "internal.h"
> +#include "swap.h"
[ ... ]
> +static void __split_folio_to_order(struct folio *folio, int old_order,
> +		int new_order)
> +{
[ ... ]
> +		if (folio_test_young(folio))
> +			folio_set_young(new_folio);
> +		if (folio_test_idle(folio))
> +			folio_set_idle(new_folio);

[Severity: Medium]
Does mm/folio_split.c need to include <linux/page_idle.h> (and drop it from
mm/huge_memory.c)?

When CONFIG_PAGE_IDLE_FLAG=3Dy and !CONFIG_64BIT, include/linux/page-flags.h
omits folio_test_young(), folio_set_young(), folio_test_idle() and
folio_set_idle(), and defines them in include/linux/page_idle.h instead, so
32-bit builds with CONFIG_PAGE_IDLE_FLAG=3Dy fail with implicit declaration
errors here.

[ ... ]

> +/**
> + * folio_split() - split a folio at @split_at to a @new_order folio
> + * @folio: folio to split
> + * @new_order: the order of the new folio
> + * @split_at: a page within the new folio
> + * @list: after-split folios are added to @list if not null, otherwise t=
o LRU
> + *        list

[Severity: Low]
Documentation/core-api/mm-api.rst includes .. kernel-doc:: mm/huge_memory.c
without function filters.  Should .. kernel-doc:: mm/folio_split.c be added
there as well so the six moved kernel-doc comments (__split_frozen_folio(),
folio_check_splittable(), __folio_split(), folio_split_unmapped(),
folio_split() and min_order_for_split()) are not dropped from the generated
documentation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110035205.3036=
-1-fangxy@xiaopeng.com?part=3D1

