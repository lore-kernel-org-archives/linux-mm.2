Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA92C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4256B008A; Thu, 17 Sep 2026 01:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E646B008C; Thu, 17 Sep 2026 01:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24C86B0092; Thu, 17 Sep 2026 01:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9E66B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:58:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19FD9A4A0C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:58:39 +0000 (UTC)
X-FDA: 85222199958.01.F8B2ADE
Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	by imf02.hostedemail.com (Postfix) with ESMTP id 82D1880004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:58:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjTmazg9;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789624717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6sskj9GLiZ9PhHGpWEzfx92mj2D3CU0O4mIIDyV7XY=;
	b=XoU4l2FUA1HZFD1cy3r8HcZ0p8BZA1DwIDL3osPp4NXDmivnjwpypCR+t7GAs5gZ3V6pZD
	NJu9zkFEvNgpAbWokINPf9NBdNzN84Ewyab4GPJ1AuK8ka+gjTAXgIiU9Wp0HMZ3+qUHvT
	rWJksh0fOHJ2RmMfvJurC/WKJgPj5z8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjTmazg9;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789624717;
	b=iwFOlywHm2NCrIGF+pDyp0idvCkSpu9dgcQuD8LRZ7/CLMymeCBYLPrCJRpdS4wIkm21O/
	dUB5Vs2S4PuCYL56XoGEtdYUTyJISjLGGJGYR2eHb+QdmBh2XjBbifRKVlqAyG1w2Bac4+
	icswwjfyQJkrcB8CsG2iHnZY5fkJZ20=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J8DscqG4a4GeiQzq3/0ZMuMoJ5VdAvhrxumKrU8mFcI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789624714; v=1; x=1790229514;
 b=YjTmazg9aIQBpzd39HD+qdjdHyMQ6IWhBBlRR3dFFJuYswwbtw9NutY2Wvkq8zHBRWlR/wXv
 QSoUrX9UyeYdZ7JPEhyY3cxYOz71ydRYsLA3ZZN2QTexx8OQi605WPUH2GaUBqauuIIDhwCMS5I
 Od/QQGNhp1SqgHUx99quepG0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 67928f8b5859cc35;
	Thu, 17 Sep 2026 05:58:33 +0000
X-Mizu-Trace-ID: 67928f8b5859cc35
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb_cgroup: move per-node usage on cross node
 migration
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260916-for-hugetlb-charge-v1-1-70fb708b2e4a@kylinos.cn>
Date: Thu, 17 Sep 2026 13:58:11 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kees Cook <kees@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mina Almasry <almasrymina@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E35A1286-33DF-4B54-8338-888EE28BFD06@linux.dev>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
 <20260916-for-hugetlb-charge-v1-1-70fb708b2e4a@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: r4y8x1nsy8hr6k38uhgex79wi1y5w577
X-Rspamd-Queue-Id: 82D1880004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789624715-669813
X-HE-Meta: U2FsdGVkX1+BQXbQTcEbXpRdigdqVUlPUkCJNcbIziqZ+RSvkxPqDAquGHlnYivJzVianvFNZ0fmG3VqBA/KU2ZFpD74PAJ5zd9VV/OkmWDVTi4uZ6cDGuiPdDoVjj5OyBJpLk6lRO25flShTlS/mG3TXMoc0SwOHbuLYWqrKePBeILSQP20A146trQL6CzpKu3LPfhcWiSsykhWGrhgNWfmHSmhpVDiEKsHJAYr3mllPgbXNZOJBtY4K2F3EsbCGFGWShIXDgQb/87PciuVDuieV9vbcF3TOKo+vO5P8w/kMWTCZ2Bb730z2RXaIsNbW4w2V0t0a3Td5Y4AYXPl8eXvAzCAL7D+fCe+GU7Xc3zAVAjQbR2xzz0umLuaAFB1lzbf9NA/AvKt9yFDtaV/AztCZTgSVY5ljWKnKsp+WqxTWNucNZfx0L9zltQwUItUg98ZoiaPAnIorUtHOuE9DeWurYwsUIy7nmP7o1ORTjmeD5lZko3jj4hERhJ/cEeJhGlA7l+I/WeZM+d4xgyEyi2q+1Rm3w8WrfAz3gE/p4xYoJsp8irm3KRIYI4Y6vNpzwtC8OHmaiiCpknxV2RptyRuWkEHEtbvvLCYNe56KLZkWhOD8p6UFMXFpKixoEgcqbhLRj2gZub3//V9ucc/vilIC8dJfjU7U/m7MqcBmHwNgwK4pbaBeQqVyo/fl/woP2oWwMkN88HiIOC4kzGK0j/6VAyg6J1AJpz3xZtIIU6WDl65BrKY2fRZe/4b9uWOU7LkoWgm4xwKXzcouAR4XNyQFYDLJkvHCYd7NjmoNzIG+sMm1qG2yfDo1gP5cQfDFxtpytovOr0XvG2SK2IyqpHEOs71u6p0VhXPQhLBhiyxBonsESiuO0CsY7XYe626q5KDuGw0B22dRqBjUZoKrHXSHGOsos6uSBCGq4dvwg7yu1xKVvcqCbx/t8QjQzfoZqzt4EHA5ayUtSMzrD+
 /JSu9Tkm
 M1dn0lNFyK6Cif5h0ZXX3J/Gn9ByRvDodlZj5PAgfhfk4aYxuKd8dBetfs8AxN3YcLimt8FQVdX6P6E0U0FLL7HmtsypTLZiqJGUMw294VADA/kWidHqnXB+6kAzQutN085H1Bu68pq8/KmpNbQkg7n9TBXg/Sx+hEvvq3azvsrQ1y2z79cTHZTIdzNKA1u7UScOIV+zpAlQemDzh8ohwfSfabkiLMfAjTwO58Oc8mIfVkPZe2snZofpXZUlTiHZA3VJ54CT7fYuX/URPxwdXNCkLezjenYJoQbbfDshkbrrwPnmh7uxZZwHP8NyG/fX3sMNBHt6eYinaAAqOzZdFgVGe/EkhtRVcUKXIykf+NkuTTuZMgklDVV9vQgIRQm/gdducz1jkdY8AlEAQsbqYvBgk4yV+WXFNrr38q5rcyJxslV49IwG5TmlxejfkUl6u0Y6X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 16:30, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> hugetlb.<size>.numa_stat uses folio_nid() to account usage in
> __hugetlb_cgroup_commit_charge() and =
__hugetlb_cgroup_uncharge_folio().
> hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
> per-node usage behind on the source node during cross-node migration.
>=20
> When the migrated folio gets uncharged, we subtract usage from the
> destination node counter. This creates stale usage on the source node
> and unsigned long counter underflow on the destination node.
> The hugetlb.<size>.numa_stat interface exposes these incorrect =
per-node
> usage values to userspace.
>=20
> Add a hugetlb_cgroup_move_usage() helper which moves the usage from =
the
> old node to the new node, and call it from hugetlb_cgroup_migrate().
>=20
> Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> mm/hugetlb_cgroup.c | 31 +++++++++++++++++++++++++++++++
> 1 file changed, 31 insertions(+)
>=20
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index ecb6e0b7819a..1040406e7e1d 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(struct =
cgroup_subsys_state *css)
> hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
> }
>=20
> +static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
> + 				     struct hugetlb_cgroup *to,
> + 				     struct folio *from_folio,
> +  			             struct folio *to_folio)
> +{
> + 	int idx =3D hstate_index(folio_hstate(from_folio));
> + 	unsigned long nr_pages =3D folio_nr_pages(from_folio);
> + 	int from_nid =3D folio_nid(from_folio);
> + 	int to_nid =3D folio_nid(to_folio);
> + 	unsigned long usage;
> +
> + 	lockdep_assert_held(&hugetlb_lock);
> +
> + 	if (!from || !to)
> + 		return;
> +
> + 	if (from =3D=3D to && from_nid =3D=3D to_nid)
> + 		return;
> +
> + 	usage =3D READ_ONCE(from->nodeinfo[from_nid]->usage[idx]);

READ_ONCE is unnecessary because there is no concurrent writer.

> + 	if (WARN_ON_ONCE(usage < nr_pages))
> + 		return;
> + 	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - =
nr_pages);
> +
> + 	usage =3D READ_ONCE(to->nodeinfo[to_nid]->usage[idx]);

Same here.

> + 	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
> +}
> +
> /*
>  * Should be called with hugetlb_lock held.
>  * Since we are holding hugetlb_lock, pages cannot get moved from
> @@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio =
*old_folio, struct folio *new_folio)
> 	/* move the h_cg details to new cgroup */
> 	set_hugetlb_cgroup(new_folio, h_cg);
> 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
> +
> + 	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
> +
> 	list_move(&new_folio->lru, &h->hugepage_activelist);
> 	spin_unlock_irq(&hugetlb_lock);
> }
>=20
> --=20
> 2.54.0
>=20


