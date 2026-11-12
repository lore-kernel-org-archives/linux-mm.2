Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6FE606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YzGrzmHr
Received: by kanga.kvack.org (Postfix)
	id 90CFD6B05BB; Wed, 11 Nov 2026 21:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD686B05BC; Wed, 11 Nov 2026 21:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB8C6B05BD; Wed, 11 Nov 2026 21:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAFD6B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:50:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2B16A047E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:50:05 +0000 (UTC)
X-FDA: 85424937570.03.166E631
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB96120002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:50:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YzGrzmHr;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794451804;
	b=ZsIPozYEu2F8MUkFYcKH1CbVFmsRFMiiovLFiocOp1NJWtoX9KtLIIw0mqwGrO8ZH296ZY
	27vJOcQu5oGnbbzM/E+JmQtNMEuySaV2ZpFNesWVB3uM+lBZUhvdwpcHadvLPSxhqYWlnO
	G4XW7ZiNYZiZ4CVkEe1bU1sa1fnoxEk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YzGrzmHr;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794451804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Sw15fLJElTIXiA3Qe5WXtECxHOt5O6ombPZ3J8UKq8=;
	b=s+lj3IIy1vRFnSqWgyyp0xLi1I+6nQYHAk+pOgQG5KPFwlDE0fBYP4Pgo3PmTLgE0/ND4i
	+eEGFKV+5v0owRVx5QgxX+eNtEpin0fB2qVrUnKbL1s3DoAAFKaPH4ZilpD6hTvjenek9E
	PUPTf5pyLx6dg3TikSZyzWg7vwQuVW4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N31htkiw7FeFclqPnxejrLhX+YXxP1RzI9SGKIi5828=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794451802; v=1; x=1795056602;
 b=YzGrzmHrmkAvLjtEQ0tx1a5d1kXvDK8yiijclYAhGn+60DKOnMsqbLOsMYqt5phJio+KFQAN
 9pDk96x/GnNjkNQq7jbH0xMRoq5RjkWr8Mlu2E4tZhBd2badnKnO+HvRkWWXn5zXo5SKnYuaLp6
 y3MLawk8E9vPBsSqy+tpyeoE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2bcdc9690615e9fb;
	Thu, 12 Nov 2026 02:50:01 +0000
X-Mizu-Trace-ID: 2bcdc9690615e9fb
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm: list_lru: fix NULL deref when a folio moves to the
 root memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261112024140.648088-1-shakeel.butt@linux.dev>
Date: Thu, 12 Nov 2026 10:49:44 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <26CC0CD2-97FE-4842-AE51-605EC77AC91D@linux.dev>
References: <20261112024140.648088-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: fc55gsqnr7sgnxzt1uqzgty8wn4dxjwp
X-Rspamd-Queue-Id: BB96120002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794451803-908301
X-HE-Meta: U2FsdGVkX1+JIYkGxEepcVTLYW2UyW9hCIqCFDZqVA+7g6KPcXcvD2l+VjkhBHmAfG2XP3jsbnb2m4d5twHLZT3zCRpaxFYAgRf+gGweeaFFcOvJlXG+LKPPBd0QY2kvDmht7milzAWcoRjcWIzL9O0J/yYLkMK3iCu5Vnk7BmY+OjDTTViB1lnwYWBPS3B+Fe4jz6E9FT/k1/VI44gDsU3R+ZG/rFYd/oZG7MxVFxatZTKS8icdxkun8XzWKfWR/OzfdbbC1qMcX36oQIXTG5ATfC14y6A8Sn2Ug2v5VmZObPI1A60WA43nAInwpqS82qMYm/s+9h86Ra4DtO3HwN/kmIEsOkjxaEvRxTNiqehwlYgciggWa7wFoO5DaWI6H2XFy6UHb2dsBT46laYFm0AMY099kve0cgaxusJ1GHwYWtCLsiqTgqoHKtRaLkB6+h9tfjnPFPLWjHiMocJBpRNz8nxz6mgW59IZeVDS3geJZC4FHAFKlF28yj91DruCXUpfDNRfUW90jerCe6P8l+sD+u6mImLE9y+01HvH0uNftwQsfe5b8vOeS6cCyWXOgFw/3eGHN+iBvgKQpDe3ekCcjU3IAdfdhXrrBKhGQXp0cqse4AGN8LOm0eSy0vohqB1ApXW/3Hr3/Dahw2o6jJqTiCyPMGUx85wfdbHjG8V01r/IwN+MmsZkiZZsMm4YuC49q/PrgYXpj2cbwVsezNQFLC03jfyDVcu9OnvT8YwKJIqbiggszgD0YNHjZUlk0/Wg9bondltl/nauiMqnu2H5Q1rKHWTMCel6ftcaeTIAv4wKtsKSyZaRexTvlu+K5+slJSnzaCJSbauaRFyHIBCwghfUs0YlKayzSLol5JE89yBjzV8/gZw9UeWkIEEJenOVhKWuVsnD64G1021Z2Y6JMevq9kTpq6JdGqAD2WHMYiOf+Ycsy47Z5M380xZWXJlSQvSDEOrwJgPG+13
 1SPW8wrh
 0YATvGOE92XyHcG0rvf8bYOhwtHrYiVEts5cYUA/0DGk9R7zl+o0MNwb6uOjkkMS12gN5Z+FaUcOMsawcBH2eriBpjv2j2QajcrJfpK+Kj0pg2tb4zjgiv5B0HsaFaBfxRLzX4g2t7NNMIo0ldyb8Do6+vpAbZa+BTEfcDPD2I08qxH+fMEHsGd4H5/by9HN4tI+8YuTNk2aob6dm7uIRyeygXfVVgJ+1NVrdTZt33zYCwkTB9s9PnmkPNS6U9U8fIENGAshvAqsHZzEZnhMBUTTQnNrt44QUtl7k8TwZLcD42vx6+Yf9tBFN6NiTwe48oSo2Q28Y3+drkpe/QSGJmor/IQio9vl69T/G2ydmlAZessjb7pvLzTiQFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 12, 2026, at 10:41, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
> own lists in a list_lru, such as the THP deferred split queue. It =
looks
> up the folio's memcg twice: a fast path under RCU checks if the lists
> exist, and a slow path takes a reference and allocates them. The fast
> path returns early for the root memcg, which uses the global lists.
> The slow path does not check for the root.
>=20
> The memcg can change between the two lookups: when a cgroup is
> removed, its folios are moved to the parent memcg. If the folio is
> moved up to the root in between, the slow path gets the root, and
> __memcg_list_lru_alloc() dereferences the root's parent, which is =
NULL.
>=20
> Users see a NULL pointer dereference oops while a THP is allocated,
> such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
> are affected too, and for them the oops can also happen in reclaim,
> for example in kswapd. The task that hits the oops is killed, or the
> machine panics if panic_on_oops is set.
>=20
> The race is narrow: the folio has to be moved up to the root right
> between the two lookups. For example, its cgroup is directly below the
> root and is removed, or has its memory controller disabled, at that
> moment.
>=20
> Fix it by skipping the root memcg in the slow path too. The root needs
> no lists of its own.
>=20
> Fixes: ae64f07a6a40 ("mm: list_lru: introduce =
folio_memcg_list_lru_alloc()")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>=20
> ---
> mm/list_lru.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d1d256822ccc..566691ca3dd8 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -645,9 +645,15 @@ int folio_memcg_list_lru_alloc(struct folio =
*folio, struct list_lru *lru,
> 	if (likely(res))
> 		return 0;
>=20
> -	/* Allocation may block, pin the memcg */
> +	/*
> +	 * Allocation may block, so pin the memcg. If the folio's cgroup
> +	 * was removed after the check above, the folio has moved up to =
a
> +	 * parent memcg, which can be the root. The root uses the global
> +	 * lists and has no parent, so skip it.
> +	 */
> 	memcg =3D get_mem_cgroup_from_folio(folio);
> -	res =3D __memcg_list_lru_alloc(memcg, lru, gfp);
> +	if (!mem_cgroup_is_root(memcg))

How about using memcg_list_lru_allocated() to check this, it's =
consistent with
the above check?

Thanks,
Muchun

> +		res =3D __memcg_list_lru_alloc(memcg, lru, gfp);
> 	mem_cgroup_put(memcg);
> 	return res;
> }
> --=20
> 2.53.0-Meta
>=20


