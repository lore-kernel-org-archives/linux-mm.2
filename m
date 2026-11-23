Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFF9606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UI8TsO5e
Received: by kanga.kvack.org (Postfix)
	id EACC96B05B1; Mon, 23 Nov 2026 07:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DC06B05B2; Mon, 23 Nov 2026 07:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25CB6B05B3; Mon, 23 Nov 2026 07:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A402E6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:49:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43F06C088B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:03 +0000 (UTC)
X-FDA: 85466363766.06.816698D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D647A000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI8TsO5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795438141;
	b=LiXnALE9EB3M7jDALGc0U8kJYcDlbySVTzs1cXy8t1JAEJ755WpI2ah59ceAuxOpx/b39D
	0sUbt1ylPNiqEtXL7+3VQd5nS96WQp2VOG4QbUTD2y/wuQW8APlRTMHGuYy7dINPad/xX5
	kfw3vav+snyl5BuiegYOTjCqdEG2N1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795438141;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JC9YmPJ2LrQXvduH7B2fcZk6U1dHPA3n7WznDqWAu4=;
	b=yXYDGeKrcCo8IsYNDo3O1xnpfpW0ueXxsF1NUnOpdLgafv3INu5cQNWhrie+fcjMEK2PyD
	dIiJKzVCNAs2rCvcEIPIJmFr/KU0NvWaspbjvWMWJSdpuQPA7VZ8B0P8J1I05YSVT3Cjd9
	XRtk9YzC5LOZZ+YSmAAGpp+70wJPvUU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI8TsO5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FB7A62111;
	Mon, 23 Nov 2026 12:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1261F000EB;
	Mon, 23 Nov 2026 12:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795438140;
	bh=+JC9YmPJ2LrQXvduH7B2fcZk6U1dHPA3n7WznDqWAu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UI8TsO5e7YHq1TaocyCe6lhFzp5JJSfJRpWV7Nje+l2r+rnOlw63lta8rdjdqnd/y
	 32DMrQrHqtN9LmxPYYfCRdduQIg+5nzgBBM2c+Wwg5o/vBQcSVPiUSMJcDGarEtaKv
	 QUpZoJo62AzqPqNhs4mACijCmLBhnc5+xUC5v7Iej7zkvIcTw/3iPKvJ4Lrfk47PQ2
	 O2qjzSujM1SRKOBVg4ZpuCPWu70Q3+90sTK7/+ixyuosh3EhDLWcOOrkVvYI4biDHR
	 FM+BwRi/FlUK78mjCzcJoNgEXwJerKDiCPRy2d1pZc+UIv0P3KT8+eBh+qTEwpjSfc
	 UGSZ9MflS0oJw==
Message-ID: <sashiko-outbox-229259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/14] mm, swap: let the command line set the xswap
 device size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, corbet@lwn.net, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261122123918.3486916-10-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122123918.3486916-10-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:48:59 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D647A000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xk1hbpir6hoxqm7ie8pjs3yo9hw9d1uw
X-HE-Tag: 1795438141-373086
X-HE-Meta: U2FsdGVkX1+nEetCqtSFZ5HyUfgJNMEgYmu4naO5U/7Ip/mNZpbfzNQXwKP0Oy9Bl3Sj/NftI2Q2gshsiwMLJ2oAs5F6S9j0TuLwIR2DaiMDtrxp6JtiZNfLs4Pr/e7UB1qefPIXm+65HBF05ClfDDFuKLyH5e+cAtdVgDIHuAx+z3uawpUgn0uGc14jktLVbSW/P0yvl26ppAHyaLWIBAOh6nc2ZaMAQ80vOKH/9/bn0xv66rgcTVcEpfPgRyz8bEK6BnO2XjAMwAxmzg8GdBjTYfTEsJp5fUTlPozOh9CeZt7uD+dFj+Jzwkz+hfzPUJN5gXwaaEQvOIUtXzGp9qIrQggddptOZA6FfLkY/LU5MGywXMHHAQnJjNjOKJC1VD/PqMexULu6Gp9MzsAgqSqIJ0Ld+n1BYRHB8hClYoN7Z0JWGZi8VcQWNxogdfv+WwUMsyyTfsef2jAGyBpm7UGmFdPN/kSTD82+244I2dV+28J5W1XNhy74xalRd7OaZrYFojbOtSpA0vNYjFgI1AZoWqkZVuEpvPzURqbes2qOJ5EgUkAGxMuLCWLWB7ltA7ftSTogt43cE22iEaEXuAVUzIW9iDxZNEVznuzsFitAJdj8glS86CzvCMA9vo4Fw3l0ftqEF/dYHLX9plGwDkHVGFGVohXyEiemHRQl89mhi6njO5NMvJ7d7egN5wfpud5x/xLa7mVKIRxk92OYEcB5D572KXft37X5WcEFx4zfL+9squKYI5p99kOAyiStyOhHAwQ1So2TbkRBQ56Matac3M3OFYrr9vvzj69fcB7MEe6BfAt0G/lRaO3NoxEGQLNzR8rSMQsiaOhu57wwRMEdYGrIZ3XiZ+cWoGvqZg+TPS6S3RFXCegeQYBBsFSz0dFfnxaB3hE8WoeJpltbv0eG+QgsL+IaVtfUnZpaG2FkKB2uUlIQxbiLcZrv74bqup42LmEfRwCgNIMd8fF
 k+oY6rhe
 YH1D92hSdHQLsDcLy9isGX0nY8spUhRYTcJc8bcJC3wWHedIpYpqlra64gaVgqBcIOPoQgirbDRmNCwQMAowPsajQGMhO1dh37GpnXNWDFhhc/PC83g3zJ5FeWg+tIdkn1bEdaaejViDqM91bhy8Uf6XPh9vCJUbNgCpjVBpqkrIPyZ5Texmu7WLgUq6OHhFRWVy1Op/Fc4fD+/Ae2oCvadASQbnB7eWhqjJHtJNkInTs8XJRYavFuYSVfMx8cHT5jon2Q0LNX4u+H8Yl58duOi9cC7EWx0DCG3wuVzoX21G4lG8+C8tRouxGmLTW23YRPh55xcqC9XizLRObBJSU7jePVd81Cm9ovpg/2xrhV/u1oJs4PW8zNVFtu8G4vIZRvbTnsDxjkpYCfKmFVXZmmoXyiqOztSTTMAKLt7wQiwldOttnlN0ftAKq2qjMPnNiQlQjNqOWeKAcdgfBZMHKI83/XRWklHoYu9nn7R8S6U7G/4tLxFINuKScK1x6IhUHkGShZvAye5EjBvOQ5wnynAGwPyniylIzrsZL2Aoj8TZMPwDNa6Ikh8NFl2o3JLyN48GVyoVzA1+xGytNVdtQNa58qce1pxfpsl5bL95gWIjihNNxYuMVnkYJV1osyzXVcSlUV1zNT8liebW9iobgD64JFOmNUxT8ukCIrBAFhbQVRZR5WHbpdHmKuBI9GpjQTo0UoQZzjySOVV3wmLgy2Zxkx+NHIKuCB1sFWiwzgH2o3RRYiziA6R5raZndBxVx/8Vh8Y5FzHCU4f8Tv9dLja2+Io4R0wdKJjgJMoVtyUm72fpdJ+osdb60AGRDcQplB8VBKXirYkk6MNCqhunDq4H2Po0jMDJ1Lx/ab4hm7daVAYg=
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
- [Medium] mm, swap: multi-GiB eager allocation in xswap_create() on
  xswap.max=3Dmax
--

commit 29d7f4cc8e13bb0b7ff644445a526d24fc58d1df
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: let the command line set the xswap device size

This commit adds the xswap.max=3D kernel parameter to configure the size of=
 a
new xswap device as a byte size, a percentage of RAM, or "max".

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ba899e349e992..6ce5dbb3b1035 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
[ ... ]
> +/*
> + * The most a device can address, whatever xswap.max=3D asked for.  An x=
swap
> + * slot is still a swap entry, so the swap offset limit applies even tho=
ugh
> + * the data never goes through a physical address.
> + */
> +static unsigned long xswap_size_limit(void)
> +{
> +	unsigned long limit =3D swapfile_maximum_size;
> +
> +	/* A cluster index is an unsigned int. */
> +	if (limit / SWAPFILE_CLUSTER > UINT_MAX)
> +		limit =3D (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
> +
> +	return limit;
> +}
> +
> +static unsigned long xswap_size_pages(void)
> +{
> +	unsigned long long pages;
> +
> +	if (xswap_size_max)
> +		return xswap_size_limit();

[Severity: Medium]
Can setting xswap.max=3Dmax cause multi-gigabyte eager allocations and a lo=
ng
unscheduled loop during xswap_create()?

On 64-bit systems, xswap_size_limit() returns (unsigned long)UINT_MAX *
SWAPFILE_CLUSTER (~2.2 trillion pages with 4K pages and CONFIG_THP_SWAP=3Dy,
or ~35.2 trillion pages with 64K pages).  Although si->cluster_info uses a
VM_SPARSE area to populate cluster metadata lazily, xswap_create() passes
the full maxpages to setup_swap_clusters_info() and zswap_swapon().

First, zswap_swapon() allocates and initializes one struct xarray per
ZSWAP_ADDRESS_SPACE_PAGES of si->max upfront without cond_resched():

mm/zswap.c:zswap_swapon() {
	...
	nr =3D DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
	trees =3D kvzalloc_objs(*tree, nr);
	if (!trees) {
		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
		return -ENOMEM;
	}

	for (i =3D 0; i < nr; i++)
		xa_init(trees + i);
	...
}

At xswap_size_limit(), nr is 134,217,728 (2 GiB of xarrays on 4K-page
kernels, or over 10 GiB with CONFIG_LOCKDEP) up to 2,147,483,648 (32 GiB on
64K-page kernels).

Second, mapping the first cluster chunk calls vm_area_grow_pages() under
PF_MEMALLOC_NORECLAIM, which allocates area->pages for the entire 192 GiB
VM_SPARSE virtual range at once (384 MiB on 4K-page systems).

On systems with less physical RAM than these metadata arrays, swapon(2)
with xswap.max=3Dmax fails with -ENOMEM and a warn_alloc() splat; on larger
machines it pins multiple gigabytes of unswappable memory before any page
is swapped and stalls CPU in the xa_init() and swapoff xa_destroy() loops.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122123918.3486=
916-1-baoquan.he@linux.dev?part=3D9

