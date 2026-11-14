Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F9F606A332
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3CM7N1I
Received: by kanga.kvack.org (Postfix)
	id 528AA6B05B0; Fri, 13 Nov 2026 21:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDC96B05B2; Fri, 13 Nov 2026 21:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8546B05B4; Fri, 13 Nov 2026 21:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F236B6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:02:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BEBE1402BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:23 +0000 (UTC)
X-FDA: 85432074966.20.ACF4EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD7C01C000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:02:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3CM7N1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794621741;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxIn41mSnTkR+VFIArN1eEKPRZUA9po2VD+NvxLbjx4=;
	b=tU2kVdrkEFaQLfh77l0OKEgyJ28RnaOOOnYUAU4gxVhw0jfhF2cF2TolGDbicFAP/PkSPw
	8Ebml4cNZnx0qHWyVv1kIOyVY95B7a3QrKvzNPlBOLhI4e/xFT2qiqrCPf/QwJAtwx2h+U
	Wd6FsZzQ2ZE6oNZZb84lhboglDWMkX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794621741;
	b=6NULCgpWK7J9wgZ4oPLwcBSl+MjXBpppCT7741t7qNgX/7EQ6v7/diGeBkdIfcNwHZepJn
	c0RG19mb/LYMtM4fFe0JFZ9oEnock2473wmTcU6q1prKwf1uuvoIRjG0ovGvuagxQxztTr
	C/0ILhMBGtsdxkFkZ2BjDljyxtLGr58=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3CM7N1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CF6C61EB1;
	Sat, 14 Nov 2026 02:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54471F000C4;
	Sat, 14 Nov 2026 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621741;
	bh=IxIn41mSnTkR+VFIArN1eEKPRZUA9po2VD+NvxLbjx4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n3CM7N1Ich9ZdQbXkboFuGluZFfVVDaysQybdLCnUx5dBMBxc8hSesYOnj3cPVbnQ
	 UHPFAMf0haNzH5Gl9/I6jAXLhh+7N16GkZxcJjbMpmVSQ6nZEd+/LUioks12rcG3Kq
	 e2SuXbS+xVrxcO3ivb2EhWX8JBiVqLqtbYpCYZCzqU3QGiw2Us/VOI/YVB1qE6Cvw9
	 DLHn+1wQlYwifhmFr35LNRWNgf2GUWFMeeOcGkXpDNOTFHoGMMgfdALJYaKEIn1hQh
	 51iXCFfCVwEcV2YhAIhRdCTix0X4KvfTRAeGOCQWz7/N9YrC9EplNNo5dQrK9Qt59J
	 pbHX3Ct11YJYw==
Message-ID: <sashiko-outbox-214031@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 12/16] mm/mglru: Restrict eviction accounting to
 eligible zones
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261113185541.70203-13-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
 <20261113185541.70203-13-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 02:02:19 +0000
X-Stat-Signature: geti484mk534w68pz6itashkazso17h7
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD7C01C000A
X-HE-Tag: 1794621741-252183
X-HE-Meta: U2FsdGVkX18XcTFQUUqxqGwuOk1M6KKmvMSkl8+Gf8UvAbEHqB/tfJLigdRjDjoLYGTYQos/nk+LuxGmKAVcnsucfiEZOhGCMv3trZ6JdThtz3xhvMII+11a6XL6KAErzVIFSVODArq2mxwrGFygZKA9/UAc0YGJigUTdPqhCdUdFzT1bayos8DaGmvWd/Liv036dDFuSyaJAgq22RD0Uzmny1dey3DENunSxUbLYhAVACJaDw9e+c9HYXS/1bBbnz0XKa4e6deijRDSZ5wqr+AECRsWDXS3jvUNPEk2YqpELOOCZXosUA4iFQVFwop197Pfx6JTKHuux3WBojyIHXm6smTsmiGSiNHaaTIqDHsK0pMwHimeNubYq+IOpVH0ZQNJMgFnfju7QpnrtIDxZbP1AmwYfA/V4QLwS5biJ6PnwvgnZMo2wISRDcu3R4xyrB+MJZaJpWJwIEzq6rC9KgO74iNY19xcOEQXOYOY1OIG7ftuBuoE53x/4KfVh8Rg1cHGHp/aj74ndkJZr3GLOzjLveOqXD7b2Z2Fn91D8Pba/nvk28ZYt/WcB/bQ/beAfEmX+lxPdCstkl67A8xtX2c8assrY7V4d3JneKZypH1HtqmOjR1lsl/uHir6aMNJG+gAK0ylq7TlhTjpvEKeH+iec6jW5btAHAHl7/LDTX1B3JXT6VASyfLZEjAb/L+siRnpps43L5+QPyE2Scvynz19TMnNuCtBIzlhwFo7Dvj2yLk9Lh4m9JrCcH84Wgy0Z/XmpHdu0MKa8JEYnfPb/wts1AWSB2S8vRBZFoJmyP8xcqy3TwsF9pkPohqCOfHDdmgcllFmon3IYn8sBQKPnzcyDkaP8tvGNThc8E/0Q46im6u+hNq1MdoRoA5dMMx9GbZNAfDGPUFA3/mCWcemr40JDIVHOciDJ7JEcz7ghf7AzhbU5vs1pa55YRMWeN2nEJgoC1ukyeujOpQ7sqH
 zzbYcluz
 go/pyGMI3LluGPZqhK9b2Q1rzRvbQTn1DvjK8R4tB8fuyFXG24zVshUacXr2cEH30Oa1Vta+I/M60U0RkN2KpZ0+Jz7x1P4JQ2thPv1f3oCUhS5j+9Efy8XuiorylvbyIowU2opBsGFPgh+jEBKXrFpsQIMg/kANgbUqKUTYF1fGnbuqU3CothKWZVxVDSiI3J7Gny8C1SV8TzNVEAbQXuj+2ixIOwh5rVJQmX11oMC70Jh8q4ygFLIF3TuRScQouu0zmf9PsugYeSE73BMJYcnD/ahM/G+9JnEfR10QmmPhkkYG+is8keQz7jupMrzg4pMF1mlL9+IELvR+uNO1Jah9YuP6SHJirYJIf2E10Pu6cdBlWYbKDrV6QLN2ZPpq2ncRUGcSOQlPJVEBJn5HiiRiFJc7AZ2P2j3dr8pSzatz1zxNyT+eTK1xYQ6vDtg+n6NmTpErE8EMT6VpeD5JVVBXgd68xyQst66+0H6GLLigQLVTYBdqbi0RSpkF3xxx9HEKHQgNMiaITagWmM/dYcjm76/c15nHytv1HHbNAbamFjug7tiRVPKnDhoBLW79rn/n0mpY4xUZJ+AhspMQqC86a8m+8UiSJ9dCpUIVAP4pkr5LjCs20dOHo7hB7vGeZSsigB6on5NEK9Pe3CyhYyko+Ndh94wPMCB072bKlM7kXoOWL2Bmb7AtSPG5D8hknBGbK9HX4CCEnuuc=
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
- [High] mm/mglru: broken min_ttl and low-zone OOM checks in
  lruvec_is_reclaimable()
--

commit 4a520d7db30ed5c782371c3ef4bdf4fd79c1de3e
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Restrict eviction accounting to eligible zones

This commit restricts lruvec_evictable_size() and lru_gen_imbalanced() to
count only zones up to sc->reclaim_idx, and defers the lruvec_is_sizable()
check in lruvec_is_reclaimable() to low priorities when sc->reclaim_idx is
at least ZONE_NORMAL.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9071f8889b5c4..6ed47089a3305 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4205,8 +4205,8 @@ static void set_initial_priority(struct pglist_data=
 *pgdat, struct scan_control
>  	sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
> =20
> -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> -				  unsigned long nr[])
> +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_con=
trol *sc,
> +				  int swappiness, unsigned long nr[])
>  {
>  	int type;
>  	unsigned long seq;
> @@ -4219,7 +4219,7 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, int swappiness,
> =20
>  	for_each_evictable_type(type, swappiness) {
>  		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> -			nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
> +			nr[type] +=3D lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>  	}
>  }
> =20
> @@ -4228,7 +4228,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec=
, struct scan_control *sc)
>  	unsigned long total, sizes[ANON_AND_FILE];
>  	int swappiness =3D get_swappiness(lruvec, sc);
> =20
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> +	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
>  	total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> =20
>  	/* whether the size is big enough to be helpful */
> @@ -4247,7 +4247,13 @@ static bool lruvec_is_reclaimable(struct lruvec *l=
ruvec, struct scan_control *sc
>  	if (mem_cgroup_below_min(NULL, memcg))
>  		return false;
> =20
> -	if (!lruvec_is_sizable(lruvec, sc))
> +	/*
> +	 * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
> +	 * allocations. Also, defer the LRU size check until reclaim reaches
> +	 * a very low priority to avoid premature OOM.
> +	 */
> +	if (sc->priority <=3D 1 && sc->reclaim_idx >=3D ZONE_NORMAL &&
> +	    !lruvec_is_sizable(lruvec, sc))
>  		return false;
> =20
>  	gen =3D lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));

[Severity: High]
Does skipping lruvec_is_sizable() at sc->priority > 1 bypass min_ttl_ms
working-set protection whenever any empty memcg exists?

For a memcg with no evictable pages (such as root_mem_cgroup or non-leaf
slice cgroups like system.slice under cgroup v2), lru_gen_prepare_scan()
computes a zero scan budget, so try_to_shrink_lruvec() never ages it and
lrugen.timestamps[0] remains at its creation time.  At priorities
DEF_PRIORITY down to 2, lruvec_is_sizable() is no longer called to filter
out empty memcgs, so any empty memcg older than min_ttl returns true from
time_is_before_jiffies(birth + min_ttl) and sets reclaimable =3D true in
lru_gen_age_node():

mm/vmscan.c:lru_gen_age_node() {
	...
		if (!reclaimable)
			reclaimable =3D lruvec_is_reclaimable(lruvec, sc, min_ttl);
	} while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));

	if (!reclaimable && mutex_trylock(&oom_lock)) {
		struct oom_control oc =3D {
			.gfp_mask =3D sc->gfp_mask,
		};

		out_of_memory(&oc);
}

kswapd_shrink_node() then runs and evicts folios from active memcgs even
when all of their generations are younger than min_ttl, satisfying reclaim
before sc.priority reaches 1.

In addition, checking sc->reclaim_idx >=3D ZONE_NORMAL only around
!lruvec_is_sizable() does not prevent low-zone OOM kills: when
sc->reclaim_idx < ZONE_NORMAL and all memcgs have timestamps younger than
min_ttl, lruvec_is_reclaimable() still returns false and lru_gen_age_node()
still calls out_of_memory().

Finally, because lruvec_evictable_size() now sums only zones up to
sc->reclaim_idx, if kswapd reclaims with sc.reclaim_idx =3D=3D ZONE_NORMAL =
when
user LRU folios sit in ZONE_MOVABLE or ZONE_HIGHMEM and ZONE_NORMAL has
fewer than 2 evictable pages per memcg, sc.priority drops to 1 and
lruvec_is_sizable() returns false for all memcgs, triggering a global OOM
kill while higher zones have reclaimable memory older than min_ttl.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185541.7020=
3-1-baohua@kernel.org?part=3D12

