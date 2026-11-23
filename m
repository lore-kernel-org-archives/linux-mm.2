Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA2E606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMeyM9w4
Received: by kanga.kvack.org (Postfix)
	id E10B86B05B2; Mon, 23 Nov 2026 07:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8FF6B05B3; Mon, 23 Nov 2026 07:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE9D6B05B4; Mon, 23 Nov 2026 07:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40E26B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:49:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 248A01406E0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:05 +0000 (UTC)
X-FDA: 85466363850.18.737A45C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D39F40005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMeyM9w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795438143;
	b=PfMu3YuWiz+Lke1/8kMHsyWGxsbz43AWVKWCmQ20CVPRciGkYI4Mu+5zS3TCw7Kds7prGv
	KJVymnA4QiU7vvSo8B+HmtQwWggIgjylOGzSKAP9iACkFKl3v1Nf+ZA7+aO98NWN8F1D6J
	xWfWQpd3Or/BZXQpyqSMvbOKwHkHR98=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795438143;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcUJZh2iVCey09WwO68bTuzXv/XpDY4bETROSLqmp/E=;
	b=F9aU8edx56SqMWky9coHSAUScVmMRiFSdo5SJcBfoh3Izq7dKefLN6mTtA2G4/7+QvWuZF
	N1a9hOVtwy0FR3JI/X8fxOCzjwBvhyjvD7zzcvEn3u7kDoIsL1fanPZb2PeXXbW+TRJeYW
	Xu2mILDpYZu5PAeRtP778AyW2+5JvgU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMeyM9w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13AF662115;
	Mon, 23 Nov 2026 12:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2D01F000CA;
	Mon, 23 Nov 2026 12:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795438142;
	bh=CcUJZh2iVCey09WwO68bTuzXv/XpDY4bETROSLqmp/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZMeyM9w4pQQQrRX0pMOl+4s1zqgbFyDx6KWLn42IFXbbVb5rWqfRuqMdEn4tyzSA4
	 d+/3/F2vMa5x51nTml3cIDWJe39BiwoSyfVcV0ocJah8KdM36IaVfKoG1oOtBWZR/D
	 YcV4EWTa3Pg9Vmhht1FCkHwo6lkJsYr3SLIz8TYycH3SAc8qKf2HrDvhbHqCv9SQJF
	 XxRAnV2uTghyv+2tvcJuRW3HELTCScxTC8E8VnBgOg7jBUi4G8R04V1vHlpOIaNEBK
	 Z3cb1+WQfVexYDThzQmP4oZu3QswBeFA+MZAETMJkgADgr2tdj+GzYKZCrzN9XtDsa
	 qrCeh2WdMAzkQ==
Message-ID: <sashiko-outbox-229261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/14] mm, swap: add xswap grow trigger on cluster
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, corbet@lwn.net, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261122124814.3489077-2-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
 <20261122124814.3489077-2-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:49:01 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D39F40005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: st1h8cs3bzyww8btgeo11k3zseeqnc3b
X-HE-Tag: 1795438143-541853
X-HE-Meta: U2FsdGVkX1/sR3cQBn1V6jB3sSD5tmZx+1hn3f6fKgwMvDXjdNWHw/I0HEzpff1SxheRWwSXLCApM/ud40gbOdPAkYFxjbm5bpZScVHh50+PIT1NqoBoyxpBhbcEj3wfVdOm1Fz6kCuxxxbD0iklP6GLjZZSycO8Jo0X8BCyFbloPPBDcdd62brJLhkYs7TDeqP9gfj6ZblrlAF1BDsOfO2olTOs4hH38eYRkvhIqPERkpkEp20vrsXRVSIBvc6H5GunM6H82a6jCUOZSBMf7NZhr8dYn1sAnKfbN90612roYJobwGMWuOM5atTilkI9Vw/3jc7ihuSft3KYYag8sCMdAPGBi03mDTdkIFhH+uAnUf6he1nfp8/FvPpCrvtqBWitRJleW00Q2KuSVjqmDttqqbz2UDEsAd66vmUCJ6TZBnfmtjoIVGliYVGvEcFQ+AkBvIEjKZVhEzd1hyOq4SSRU60v9alRoOvVPeDc04vNx3dZOcPRKNhSEKEGwGERlNAyzvy54y3IOKAk4qZV8c2jYzwr9Mdsw98cVsKU0hykb/rhRa0x6/4h4Y6PnURv6PY2U9LVmvF/VjVftcctFb0eR1dw0XP0R/EGMs+92rJhK20l/E4ZMkc4uZukKzAa3IypP/1lUZp7Vn85KP5HZc5zOL92s21AO4KjJXe/HKZVxuIuM+Be7Al0i0zEAaCMp1YXFlbFTdQcEJ8mlS1Kdsx5zr2pgvFv1bbjtVzr5liVws5C0PEEpPUmwVDtcOc0BqAg24VWUXAjaEk9xz8b1OpifmyV264WgWR1G84FO3nNUm+5c+/GGOrFLZ8cw/p+82dU9bHPxuxUGTJF31dT97jsYekiRHX61kYlkYrBNNk5BnQzVAki9PaCsaVO2pxguMRFjhozBRnrn7qtDts2ZLaClBmwi9zQqcgSulmpe+E+DuYxkG3iTJkmbnwZPZobIqgVgzr3g7qtd9F67vV
 4PP8+XVG
 958gXZVvD3N3DW4E+aVTciMoBeAzIOLevaJ80Wd3lAxs7a65xwgF6hRIvRxUcWU6+0qC0V1epK6n5WoEn7IiLfaYWd1KJkCAbotDnf/8CtoK2YHC32hwkkOQzQuBwytP0ZbiUubB8IBOoLEhbepkY6CyC2Ycz73R5J7E3Rf3ZXQbNORyUH1Xun2fum5M/hBFN/HdE47lKp7KynjxgPe+RHSOL2KVp3j8MiQCU5IhcooXONoKKsx+EZrrqARpJIhkQwvuLBwKUOb9mPD9uAvCMAH7rObgYX13DLpWDggiBR9Xod/rCWZu7X5c4gOOZQqzcfUbEIjjS0SmvqJJ9WdqphmhSo6QyyzdffGwZiaxvpaQ8+VtwY2C8VPLGxCPNv64bebgmRvq7/zRnNerMkTNx2X5NvylufKfkBoTz5mm0zPDP3MbEZjKWiD9V9tRHFM04c2Qx9mvN5Z6mBPcL5EDbkSL3xLgCF7yACgez7wlin+vCZUuhBqJZUSRVsbrqm/Fw9wEUdmmJOly1bAUZBSvFQmm/CBUKpqwC1JSu/ZC2dVo31L/EYJSmvyTr97qrx6K5CQRiB2XZ/ulg5jKnGHGHLSvKuv/jMlDY3GjZ9zFxhbTDAsZUr21eiGgzA6Mt0cc4pYDYiteBJO4tcdFCViNNoUT5IsXTxpvHQYG0ybJrgTMjQrxzdde9463rfIbXnz2WR5H9W51BN8zo8cf2G7Vc1hAt0JORQbcQ37wi4sTAs0xk7SqAZ6tfa5SR7TUM0tWiZiIEg4lNsQgfjAGJ7UYP60VqRw0XP5wp5cUzQkoKpw78eX2sEM+jHHjUowP27zytcjDiw/qMi0Ti6sKKL3GfhMMSivnS5DhdbhSloucjfDDLvn8=
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
- [Medium] mm, swap: premature xswap allocation failure below 85% usage
  in xswap_grow()
--

commit 71fd2887206158954afee3bd83d348af42ba786c
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: add xswap grow trigger on cluster allocation

This commit grows the mapped xswap cluster range from
cluster_alloc_swap_entry() when swap usage reaches 85% of the mapped
range, mapping enough clusters to bring usage down to about 65%.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 074c5114d129a..213b66bb1d6de 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1325,6 +1340,13 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>  	if (order && !(si->flags & SWP_BLKDEV))
>  		return 0;
> =20
> +#ifdef CONFIG_XSWAP
> +	/* Grow before allocating: mapping pages can sleep. */
> +	if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK) &&
> +	    xswap_should_grow(si))
> +		xswap_grow(si);
> +#endif
> +
>  	if (!(si->flags & SWP_SOLIDSTATE)) {
>  		/* Serialize HDD SWAP allocation for each device. */
>  		spin_lock(&si->global_cluster_lock);
> @@ -1397,6 +1419,12 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>  		if (found)
>  			goto done;
>  	}
> +
> +#ifdef CONFIG_XSWAP
> +	/* A concurrent free or grow may have added clusters; retry once. */
> +	if (!found && (si->flags & SWP_XSWAP))
> +		found =3D alloc_swap_scan_list(si, &si->free_clusters, folio, false);
> +#endif
>  done:
>  	if (!(si->flags & SWP_SOLIDSTATE))
>  		spin_unlock(&si->global_cluster_lock);

[ ... ]

> @@ -4023,14 +4082,62 @@ static int xswap_map_clusters(struct swap_info_st=
ruct *si,
>  	for (i =3D start_idx; i < start_idx + nr; i++)
>  		spin_lock_init(&si->cluster_info[i].lock);
> =20
> -	/*
> -	 * Publish the new mappings and cluster lock initialization before
> -	 * the count; walkers without xswap_lock use smp_load_acquire().
> -	 */
> -	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
> +	/* The mappings and the locks are in place; make them visible. */
> +	xswap_publish_clusters(si, start_idx, nr, link_free);
>  	mutex_unlock(&si->xswap_lock);
>  	return 0;
>  }
> +static bool xswap_should_grow(struct swap_info_struct *si)
> +{
> +	unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +
> +	if (mapped >=3D READ_ONCE(si->nr_clusters_max))
> +		return false;
> +
> +	return swap_usage_in_pages(si) * 100 >=3D
> +	       mapped * SWAPFILE_CLUSTER * XSWAP_GROW_WHEN;
> +}
> +
> +/*
> + * Map more of the cluster_info array, up to GROW_UNTIL in use.  The cal=
ler
> + * holds percpu_swap_cluster.lock, which this drops while it sleeps.
> + */
> +static unsigned long xswap_grow(struct swap_info_struct *si)
> +{
> +	unsigned long mapped =3D READ_ONCE(si->nr_clusters_mapped);
> +	unsigned long nr_new, want;
> +	int ret;
> +
> +	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +
> +	want =3D DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
> +			    XSWAP_GROW_UNTIL * SWAPFILE_CLUSTER);
> +	if (want <=3D mapped)
> +		return 0;

[Severity: Medium]
Can cluster_alloc_swap_entry() fail without growing the mapped cluster
range when concurrent CPUs isolate or lock all mapped clusters before
swap_usage_in_pages(si) reaches 85%?

Each CPU missing in swap_alloc_fast() isolates a whole 512-page cluster
from si->free_clusters (taking it off the lists while
swap_cluster_populate() allocates ci->table, or holding ci->lock while
allocating from it), whereas swap_usage_in_pages(si) only counts individual
allocated slots.  When more CPUs allocate concurrently than there are
unlocked non-full mapped clusters (initially XSWAP_GROW_CLUSTERS),
xswap_should_grow() returns false and the !found fallback only re-scans
si->free_clusters without growing, returning SWAP_ENTRY_INVALID and failing
folio_alloc_swap() with -ENOMEM even though unmapped clusters remain.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122123918.3486=
916-1-baoquan.he@linux.dev?part=3D11

