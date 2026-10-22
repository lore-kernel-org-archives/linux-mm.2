Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7966606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=brNOBsaX
Received: by kanga.kvack.org (Postfix)
	id 3CDF06B091E; Thu, 22 Oct 2026 07:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5116B0920; Thu, 22 Oct 2026 07:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1736B0921; Thu, 22 Oct 2026 07:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC156B091E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:48:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 833191203D0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:43 +0000 (UTC)
X-FDA: 85350090126.13.AB64D07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D74FBC0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brNOBsaX;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669722;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXPvpwHeVTnRNrbcldpY8xd/jc3yXKLTJg27GcD9kWM=;
	b=6ko8YvSEqRXxPEeXWsQCnQAFNRc2k02w+T0BvvbCicT3j0sfAEqOeFT1MXeRTjgEwSShch
	+V9fHnW4EQy9yery3p/CZl6eFDMUp49z4GgKpJMtcUxX6ONRukd2Mh1U8Nl1uFynXztxJo
	apljuCq1wkwZLcpQ+FGJLvxU66EpWmo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brNOBsaX;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669722;
	b=uQWuTwPxbIpF5Qi9KagT+DKgFFdYdsPatsAnfR+DWlr/b3k/k5Bfr7rdZFUgnVpc2hfqUm
	KsPm7gY8Eoa0OLT2+/ZzBNALWT0oRhxNCLtJlOnZBlNSu3AF9M90wrOUhq2G5UOLOQWS5X
	c3bBEqfIXZ2xQgdZg4UdsIX/fn/DwY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A8B141933;
	Thu, 22 Oct 2026 11:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1B01F000C1;
	Thu, 22 Oct 2026 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669721;
	bh=EXPvpwHeVTnRNrbcldpY8xd/jc3yXKLTJg27GcD9kWM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=brNOBsaXknI0Xsr4QBmVI1i0babjkUnsjwlV3kCHXmMZSmGy/4dYnxcAJbZbXSgqX
	 ww0c1B2yQOoUymTHt63jlh5l1E95XRAK4u2xznzgYqraGVgSN5eLVIjk3rrmxM24xf
	 Z/AqjHJ9zf6nTEvqi0X9eddnpRj3zJWn77ujkJHpmcpN0HwUnieyTeJk21+YU3ECmp
	 c0r1IGvTdJiMtEIpwKmDotAvaWx3yPFtJJLBILGK8L3ggRSqyS9E07f87dPS5ZpVfH
	 PXDAislCvc765pDuSXqkeQTnIpYdOD/iWrfwDx77fcK3iWZL+pWlims6gi+ubMlv4Y
	 ENnpYpatH/4pg==
Message-ID: <sashiko-outbox-181395@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH slab/for-next 14/14] mm/slab: do not set
 SLAB_MAY_ACCOUNT for all caches
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Hao
 Ge" <hao.ge@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-14-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-14-096800aa3330@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 11:48:39 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D74FBC0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ezrzszeqogek7i8tnnwgbyqx14ufuouo
X-HE-Tag: 1792669721-633876
X-HE-Meta: U2FsdGVkX1/SoQJhlO0Uy4l3r9UbnIy6Mr4ccZicBnMxjUOU+TYP2xuwkxECpuoQgsfzKETgFE12kSAeelkmVek+GwoM1+AH7wsKzxd4DHK4TmeIUozRr0Q5RooF8eN36j4E6gmkb1/YjmDCR/kD4jI5y6vi7j0QjSlqoiXUtXLZLjTLmH/7qq759uQqf+NSytOODe1zsAdZW5Ox3ennRXi4DavBRM//TjFLelzLVkZe4C9odGtj07TTdeLtQrrqo4foD1+an0JxTDAmtD/aWh8zCDsc933VMQWz0HwVlE3rpzRaTlkzHTvcZK7tiB2O0bfy0wUq1P7liLtz+ikN7GqFO9GUfrOOfkrWVd4oGmrUJWhfDkWXjL2v24IzHWkLR3Eou0lucwvGarVLFbb3p+FMfl+Jzy4vj9oiTRjzPndeHP1aHkDTUNNHgYpnQEUb5l1ZvFRxJJvBIvyahem+rEwhC3ytEsXF6aU/vS3MOEwwccXhc0aLvveHXZ/nbaccn9546Uxt1AbYWbJC26cw2n4XX931VB9cnRyjdv+QS7G7Wwj2n5lbrJ6YEY84L6TIkwmXO/9mF3eTi+aggj+b4MMyjsDrD8gUfSXl9Lc4TNt9JqlqVc7dPMASnz9acl9xN9uL36GVXM7lro43C3U8vq9m66k9s0DA4aCvVi9mFwo+HqfAuZzPqOFdD+jkiBJKQAtPn8WWvT+zVFQta+gXks8/R6Eb5vaWiQZo42dVNi9HvBOz0UZJm18vse+vviT1VsK5sKejJHzYnBlQQ+ceFIpFUeplcj/fonWLI1M2e2uvB251m4mhSWPk+dFVKNOlbc9bBOePsXhkdxdrujjitEZrJ67XaWZkXat+jzmCe/kJgcea0iyYrcY1J7yeXXoeyv247yzo1ZzSL7jrN2XLBvucHYlJlPk05wpwerRm0YIKn1LNnxnIHdx0MvUnRcvaPLVzOtlP68C9DYbcRwN
 CKYEIYe9
 9YieFKPiTi1Fkjhv874P6qmERCQRwgI2kRAEXvqioz7P6yIqAEcDUs1TrO4yq7bdHgk5zJtTS38Rdtwd8bBSdXJz+k7QZD4hXc7p9kUj5JyGkrVtjKbtQfKAPU6vT1t4BJOovYWTI+gQ9KAp8JtTtfh1vGCZ4ImYf0lSrX+QabRLrA5ck+slXWJXXa3Jd5Ti2ujnLLhqD/RhCnID70CwXUlD9Kgvjk2DcgLFClqTHMKEpYytUyLCi81XVY4rKiEcZXGCjDPlEX7YesLnYaR7Fv793k+X791RwEU/BGsLECPIOCuFCv+AWb0amXsqTQrl7rYq5t4pa2AG0X7r9DD4ITj7msb3n/yhtXgoMPIyjZ5AiqRRo7xPsnHipfPYamWQL0U1L0jnYRr3sUVFFNsUAXcoxVwkhLWNVYW0Tqr6gaeONETrDkgAiRYG2+ykX1NVxbltwmsFsk/qThXHOyV9kESZgJvVdbUlNNGr1voM+gjrsyOTjlSWMLC8d4G2swEFsH2g1inG+wdyIV5pJD+J6utiiBr4cfNNHV3KFQkVx1ZjHow52g1a1Fji7iRWjHJQnC6x1a7bvtktkLomix7pGEy0c+M0qiaVLRgfx+6wAPTAUikyvKCNz6AU+HwJmzwcZFCPJYxfTonlHKV7dmsV9QRxsNiQSsKZP3xoEtlsXOxxxrr0=
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
- [High] mm/slab: missing SLAB_MAY_ACCOUNT in create_unique_id() causes sys=
fs collision
--

commit 51cadd40978b52beb867d85f64efe89a03c7cbf8
Author: Harry Yoo (Meta) <harry@kernel.org>

mm/slab: do not set SLAB_MAY_ACCOUNT for all caches

This commit stops setting SLAB_MAY_ACCOUNT unconditionally on all slab cach=
es
when memcg kmem accounting is enabled, instead only setting it when
SLAB_ACCOUNT is specified or when the caller explicitly passes
SLAB_MAY_ACCOUNT.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e66c0778ee984..c69aac8bb0e41 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -359,12 +359,10 @@ struct kmem_cache *__kmem_cache_create_args(const c=
har *name,
>  		goto out_unlock;
>  	}
> =20
> -	/*
> -	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
> -	 * may need to store objcg pointers for objects
> -	 */
> -	if (!mem_cgroup_kmem_disabled())
> +	if (flags & SLAB_ACCOUNT)
>  		flags |=3D SLAB_MAY_ACCOUNT;
> +	if (mem_cgroup_kmem_disabled())
> +		flags &=3D ~SLAB_MAY_ACCOUNT;

[Severity: High]
Does stopping __kmem_cache_create_args() in mm/slab_common.c from setting
SLAB_MAY_ACCOUNT on all caches cause a sysfs filename collision in
sysfs_slab_add() -> create_unique_id() for mergeable caches that differ only
by SLAB_MAY_ACCOUNT?

In mm/slab_common.c, SLAB_MERGE_SAME includes SLAB_MAY_ACCOUNT:

#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)

Previously, all mergeable caches had SLAB_MAY_ACCOUNT set whenever
!mem_cgroup_kmem_disabled(). With this change, find_mergeable() in
mm/slab_common.c will keep a mergeable cache created with SLAB_MAY_ACCOUNT
(and without SLAB_ACCOUNT, such as fanotify_mnt_event, fanotify_path_event,
fanotify_perm_event, or buffer_head) separate from a same-sized mergeable
cache created without SLAB_MAY_ACCOUNT.

However, when sysfs_slab_add() in mm/slub.c registers mergeable caches in
sysfs, create_unique_id() does not encode SLAB_MAY_ACCOUNT in the generated
name:

mm/slub.c:create_unique_id() {
	...
	if (s->flags & SLAB_CACHE_DMA)
		*p++ =3D 'd';
	if (s->flags & SLAB_CACHE_DMA32)
		*p++ =3D 'D';
	if (s->flags & SLAB_RECLAIM_ACCOUNT)
		*p++ =3D 'a';
	if (s->flags & SLAB_CONSISTENCY_CHECKS)
		*p++ =3D 'F';
	if (s->flags & SLAB_ACCOUNT)
		*p++ =3D 'A';
	if (p !=3D name + 1)
		*p++ =3D '-';
	p +=3D snprintf(p, ID_STR_LENGTH - (p - name), "%07u", s->size);
	...
}

When CONFIG_MEMCG=3Dy and cgroup kmem accounting is enabled, won't two
mergeable caches of the same size that differ only by SLAB_MAY_ACCOUNT
receive the exact same sysfs ID (for example, :0000056, :0000064, or
:a-0000104), causing kobject_init_and_add() in sysfs_slab_add() to fail with
-EEXIST and trigger a duplicate sysfs filename warning during boot?

> =20
>  	/* Fail closed on bad usersize of useroffset values. */
>  	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-memalloc-p=
rof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org?part=3D14

