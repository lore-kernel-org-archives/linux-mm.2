Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC66606B105
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QF+5/olx
Received: by kanga.kvack.org (Postfix)
	id DBA286B05B3; Wed, 18 Nov 2026 14:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92296B05B4; Wed, 18 Nov 2026 14:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7B36B05B5; Wed, 18 Nov 2026 14:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2616B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:32:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F69BC0872
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:32:42 +0000 (UTC)
X-FDA: 85449236964.08.288FAEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DB7040005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:32:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QF+5/olx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030360;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lqCKHGP4NPPkZjb/PHIe+Us5IVzoa0YCjJzMTNgr1g=;
	b=ewvyED7UaYoN/MFqa+V/sApskU+Vo7OAj0YCtVbgP0qxc1lud9cxm7Up3ksg8bCrMvbbc0
	muGCyTvRqKCW8fu5cwGUlNcZpJW0Bgegwb0UKcnWVbAzMNpK69h4JlBixURxqzLLEBydd1
	2jr94YsJSvx2M+xPSJcdSsE5X+M1yxw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QF+5/olx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030360;
	b=2si/sviFhLzcVrZkhKhvFcLnhSWoEhr/qb3gjLQp8E3Gk18U9/3rbgmepgR9idO/e0Atcu
	aEURiL5AbVxVfz+vhICoPwMylNsGLuLH37W64zT4XgaN0emRR3g7rWDqy6gRWPUA89MqOw
	0ob0/XtxUbh566lHoQz7vE99UuWDmcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55F4944869;
	Wed, 18 Nov 2026 19:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C991F000C5;
	Wed, 18 Nov 2026 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030359;
	bh=3lqCKHGP4NPPkZjb/PHIe+Us5IVzoa0YCjJzMTNgr1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QF+5/olxJtjwNaJPV96bw0pqKg6FelZ78n4exRIbrbrChyUN0b0yq2m/xABpbOnEx
	 BUG7B/SyIBFrr4f7Au38U/BcpGDfwW8NQMuppZMct9uashSLZVmicj75a19qSbuESf
	 4f1VzoOn+n3IjNlAHo3KymqaGuxpkCWykgPmlnrGydtPnA/W1zggKwgzHhXitTAqiB
	 NrwusXdfDwmj1mNeqRgiF5b9n9EAKDH65F5aommnlJng10Gl6T545SZrgblSb0NeU7
	 piMvTVT63lmz2oDAIs0UaEiKlREEhU7dcpzEJD4YdYnNUqlbP+1nFCrtWi4k4YbkX1
	 WxXSrud4T3FEA==
Message-ID: <sashiko-outbox-221869@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
Reply-To: sashiko-reviews@lists.linux.dev
To: Samridh <samridh@modal.com>, "Hugh Dickins" <hughd@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com>
References: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 19:32:38 +0000
X-Stat-Signature: s4wke8ae4ifkcton7phjnfhcg6nz8uwd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DB7040005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795030360-655018
X-HE-Meta: U2FsdGVkX18xALRXgbpHM6IhX6ZaqprszFF1i8fi2kiQsvtpdv98TnFFM4+G6lb/lHZ9kDZMVWzX7nhEvFhbOJC8fUF43BmauDoJbIp+SAnEyfF/aPMZCh//OyrMk+o0w8EYdSDk1EMTlKIn8kX4grPqHs20Q5dOgjmZYqCC20kNd+r1qOlIa0YC1YWHsMiJ0LSlZl7gBszmi/gf0VH6FlrdSsCGMiOJPwmQT3e+9BYagwOhTpiqKyPrO6VyIuSC3W3AEofyw/llGfkYTRGdjTN1E3Xc3r2j1LFOBCCH2ZWl/zX101AlV7cPhZgsp0tA+pUxTLMvuWWWcpRIaMktbSN6/mnSbwpgNCgag/iytApBEdrRPOTJbMJYZlOym4dMDBR9ky8JJoXR3obp/BslwezhdEWTPpqfsh6Q16sNIee2Mz6avPHDsLAmw4Vh8S+/JBPdd+SimKjpqd5umXEejYFem7xU9F4VatXI390OZyUVGz0sJav0+OIYSn+9/xmgnM9Oo5w/zXwa+fXJCXzPRCrSgFX35OL+4jdXW7nt4LsZOZRz06N2iG2DOXywb1rJwCQfBC/jc8rpnnvIT5BpYBa11C5feYhvCZV4n56yZoi/A8r7lmi//YkDWKKvieVaTQAiiZ/quac4vAldVi1dIe6i1XY53ADq6y6gGkxGFmChjrrhc4hkzIi5MEAofRpxe5AJOPLEzmfam+iPaLLoXqn8gLTlGLqhkzEqBwrmyhnTLSCyhtaqlEcjNc4oF4LauKSHxbPisNnlMzHLVDrJ0gk6oB5M5TDl3AIWZOL4lBroHBSgQqftWwyKBMxLpKQi/Dl2lbAXXh361Sn85XKq87fPM5ZoSNdaddEMd9yDZP+VHQnOccB34k6zCSiohRyuXuumuH9g27VvV0tV1Iox53+SrUqsxwh3RsLwVZUiuD7KqtS2Iy2o+ys8DfJTgdZJCqqJvoYldrpOyqbPDHE
 BniVZeHf
 FH6vEP2RWJGR9Y41IRQQ7dVhrU4xFRT2meLGvNxIUvVNc3xmP5oW73tkLZvQ9YvH3k9X130wnVzmkemv9hLE0ZJXGnFzxfh1KOq86tHzByOzhCqWO7vPFWtEvg19DnWrgqFCfUTGGRtNkSz7Ahu20m4trUSR8u7uBYpYXoaR40Jj+QzBDolxyrTgC2EyJany53PAJp70QGl/4O8MOI+gqOf0BwAhOOuF0wVw1n0LWUZRBXvSRUYi6rrA0VVgPe0Hy9m9dpe+68BdFgXgcA3zSnXV89qLS1tUXvVGSkVst7dl7wyntx5ugKRof/usGzhRfrewsglKopGI4ULKbzwCzwd3hohfzxhMIkAdqThtGi2DtJoh3uVebu/Y27YxmeHxWqI6F39wVd2SFOi98MwhNOfMz5up9B5s2fBwwbZH7onxFBSYQ7yldPwl/QZOZVTl9SCnDd+JaZMGjdysh8i0V3v+XKqJPxDfiYV65zjs46DrxMlrOZ0ZT7CLOXGgcxjY9huC3J7vAenV2l241fp/zvQO1vvGwQ42pCChV6zFggai/2EQHnLwnoBXNuCRaJaEGA8o5ceWvjm95qyZlSZ5J9LBOrSqXO1G86ifa8qRIOTKxgkzyk7ywmIKQtUN1G6uM0INWsg2g4XZ0qRsVflcFuuPgcR1dTpvI5jqunTg3ACx9X0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/shmem: single-word Signed-off-by identity in commit message
- [High] mm/shmem: cross-CPU dcache flush after __GFP_ZERO in
  shmem_get_folio_gfp()
--

commit acaf023dbfc00405b46eac6010b09d293eda6ffd
Author: Samridh <samridh@modal.com>

> mm/shmem: avoid zeroing new folios twice with init_on_alloc=3D1
>
> shmem_get_folio_gfp() clears a new folio before marking it uptodate.
> With init_on_alloc=3D1 the page allocator has already zeroed it, so the
> folio ends up being zeroed twice.
>
> For SGP_CACHE, the only mode that clears a new folio, ask the page
> allocator for a zeroed folio with __GFP_ZERO. Folios that are already in
> the page cache but not uptodate, such as those left by fallocate(), are
> still cleared. With init_on_alloc=3D0 the zeroing moves into the
> allocator, so a folio is zeroed for nothing when the memcg charge, the
> page cache insert or the block accounting fails.
>
> Time to write one byte to each page of a new 4 GiB memfd mapping, with
> shmem_enabled=3Dalways and init_on_alloc=3D1 (median of 24 runs on 6.18.5=
5,
> x86_64 VMs):
>
>                   before   after
>   Xeon 6975P-C    0.620s   0.416s
>   EPYC 9R14       0.216s   0.158s
>
> With 4K folios, or with init_on_alloc=3D0, the times change by 3% or
> less. We found this while running gVisor, which keeps sandbox memory in
> a memfd.
>
> I wrote this patch with help from an AI coding assistant (Claude Code),
> then reviewed and tested it.
>
> Signed-off-by: Samridh <samridh@modal.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a full real name in
the Author header and Signed-off-by: tag rather than a single-word name or
handle.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5cb628cc9c6bb..d2c6781e86a55 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2692,6 +2692,7 @@ static int shmem_get_folio_gfp(struct inode *inode,=
 pgoff_t index,
>  	int error;
>  	bool alloced;
>  	unsigned long orders =3D 0;
> +	gfp_t zero_gfp =3D sgp =3D=3D SGP_CACHE ? __GFP_ZERO : 0;
> =20
>  	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
>  		return -EINVAL;
> @@ -2770,7 +2771,7 @@ static int shmem_get_folio_gfp(struct inode *inode,=
 pgoff_t index,
> =20
>  		huge_gfp =3D vma_thp_gfp_mask(vma);
>  		huge_gfp =3D thp_shmem_limit_gfp_mask(huge_gfp, gfp);
> -		folio =3D shmem_alloc_and_add_folio(vmf, huge_gfp,
> +		folio =3D shmem_alloc_and_add_folio(vmf, huge_gfp | zero_gfp,
>  				inode, index, fault_mm, orders);
>  		if (!IS_ERR(folio)) {
>  			if (folio_test_pmd_mappable(folio))
> @@ -2782,7 +2783,8 @@ static int shmem_get_folio_gfp(struct inode *inode,=
 pgoff_t index,
>  			goto repeat;
>  	}
> =20
> -	folio =3D shmem_alloc_and_add_folio(vmf, gfp, inode, index, fault_mm, 0=
);
> +	folio =3D shmem_alloc_and_add_folio(vmf, gfp | zero_gfp, inode, index,
> +					  fault_mm, 0);
>  	if (IS_ERR(folio)) {
>  		error =3D PTR_ERR(folio);
>  		if (error =3D=3D -EEXIST)
> @@ -2810,8 +2812,11 @@ static int shmem_get_folio_gfp(struct inode *inode=
, pgoff_t index,
>  	if (sgp !=3D SGP_WRITE && !folio_test_uptodate(folio)) {
>  		long i, n =3D folio_nr_pages(folio);
> =20
> -		for (i =3D 0; i < n; i++)
> -			clear_highpage(folio_page(folio, i));
> +		/* A folio allocated with __GFP_ZERO is already zeroed. */
> +		if (!alloced || !zero_gfp) {
> +			for (i =3D 0; i < n; i++)
> +				clear_highpage(folio_page(folio, i));
> +		}
>  		flush_dcache_folio(folio);
>  		folio_mark_uptodate(folio);
>  	}

[Severity: High]
Can skipping clear_highpage() here cause flush_dcache_folio(folio) to run
on a different CPU from the one that zeroed the folio?

flush_dcache_folio() requires running on the CPU that performed the kernel
stores into the folio.  On sparc64 and on 32-bit SMP ARM (when
cache_ops_need_broadcast() is true), flush_dcache_folio() only flushes or
records the local CPU's D-cache:

arch/sparc/mm/init_64.c:flush_dcache_folio() {
	...
	this_cpu =3D get_cpu();

	mapping =3D folio_flush_mapping(folio);
	if (mapping && !mapping_mapped(mapping)) {
		bool dirty =3D test_bit(PG_dcache_dirty, &folio->flags.f);
		if (dirty) {
			int dirty_cpu =3D dcache_dirty_cpu(folio);

			if (dirty_cpu =3D=3D this_cpu)
				goto out;
			smp_flush_dcache_folio_impl(folio, dirty_cpu);
		}
		set_dcache_dirty(folio, this_cpu);
	} else {
		flush_dcache_folio_impl(folio);
	}
	...
}

With __GFP_ZERO, the zeroing stores can happen on another CPU before
flush_dcache_folio(folio) is reached:

CPU0                              CPU1
shmem_get_folio_gfp()
  shmem_alloc_and_add_folio()
    shmem_alloc_folio(..., __GFP_ZERO)
      post_alloc_hook()
        kernel_init_pages()
    mem_cgroup_charge() (sleeps, task migrates)
                                  ...
                                  flush_dcache_folio(folio)
                                    /* flushes/records CPU1, leaving
                                     * zeroed lines dirty in CPU0's L1 */

In addition, when init_on_free=3D1, post_alloc_hook() skips zeroing on
allocation because the page was zeroed when freed in
__free_pages_prepare(), which may have happened on another CPU without a
D-cache flush.  In either case, a userspace mapping at an aliasing virtual
address can read stale non-zero data from memory instead of the zeroed
L1 cache lines.

Anonymous folio allocations avoid this by checking
user_alloc_needs_zeroing(), which keeps explicit post-allocation zeroing
when cpu_dcache_is_aliasing() || cpu_icache_is_aliasing() is true.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-samridh-sh=
mem-send-v1-1-1b897ff562d9@modal.com?part=3D1

