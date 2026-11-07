Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4335606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+rUaoXJ
Received: by kanga.kvack.org (Postfix)
	id 31AA56B05B8; Sat,  7 Nov 2026 17:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2826B05B9; Sat,  7 Nov 2026 17:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FF06B05BA; Sat,  7 Nov 2026 17:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA9A56B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:05:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BDE916040A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:05:31 +0000 (UTC)
X-FDA: 85409705262.30.012674E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id AB72220002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:05:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+rUaoXJ;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnEq6QNNob8nRZ5ySQiHArqzOs/msSYvaIjD337cPL0=;
	b=CyEw/+vZ+NRiomx7RqVVKswlovrpLZwVniNUm0wZzUXaHVgAlfk3ykw3u4f/IxP/eonBTN
	KKWU2fCRcqthVW2qZmjaTF2pqUk47x5ZwiFhC5oT9WSUSyD8HSGOB/ZglCBolMoNfX5IbF
	ca804Q9zGcKxdCNaSzvIOiwgXM/HGrE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+rUaoXJ;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089129;
	b=HSvQSShTOS3nl8OrWhTWAi5OTdCIZm5XabvaANsEOoaEAXG623RFHY2QVB7If5bbhjE6gi
	7s+m3inDqYYoaKhl1F8K1OUXDK4cIKss+UBM1n5uslSuYrG3jEqov1BU3sLq+5gQ0ifGlm
	y1+hWpmxNC557SROrxlZdV2TKF0saWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 436AB6114C;
	Sat,  7 Nov 2026 22:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D8C1F0089F;
	Sat,  7 Nov 2026 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089129;
	bh=GnEq6QNNob8nRZ5ySQiHArqzOs/msSYvaIjD337cPL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+rUaoXJdlbZij3TXegRupLMvMLFLVq2dTs2rzAZUXM4tGYrbewk1RvVX9z7ehOTc
	 SuGwYnYeXIumFxBtw46TEGdHGHqC+P5XHJsZt3r4niSWgiB2tFLSd+tszcOHeg4k7B
	 f05Nch8riQtq4PFWaKWj6C1NMidqtcp2BJ6ZR7p8MRsOJXOT1DRn+kThAsRxRrJR9X
	 PO+YYSNvkBm0N/JVZ/bcDpJfa+/kV2ITuTEAG2RAJ4gZR3fJgBj6eiwLsGYCI5410l
	 XDzoPCTJWH13BKaaM3NFg3hDPgBxXOThJjlBJqUz3npwJLZKfdP4bWoggCAjO4bzY3
	 BK1oudK3AvsvQ==
Message-ID: <sashiko-outbox-203353@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5.15 2/2] mm/hugetlb: fix kernel NULL pointer
 dereference when replacing free hugetlb folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, "Ge Yang" <yangge1116@126.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261106220445.2859944-3-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
 <20261106220445.2859944-1-mkbund@amazon.com>
 <20261106220445.2859944-3-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:05:28 +0000
X-Stat-Signature: 9escg4aieyoii55a1hw91hm99jwr1yxg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AB72220002
X-HE-Tag: 1794089129-312153
X-HE-Meta: U2FsdGVkX186CeW6uaKHlbQMw92D1ROl2g0cdoNMonr8K7MFhlmW56gqgRZb+nYBauLR+Hrt5G71Iy3ko+kfnsYW5k/JC7C4Y4qW/qdEdDSqB7eatB37RJz+QHxk3FbP87C+Gen74ZpbVZxh5XhnDLuv+d7RV3RYQG7XSfkNoMB0h5hpfUXjT7vrJSOZpT6vAxgrrOxA1aPfYQpca2b0AccVJroP3tGAx6shzGvq/SxoZCSyxaS1FbG9uWx25YpdV3jxNOV5hPNsYYS9hM9+EMysdRwEWP32wMTeo13pVniYgDAoWEViBGwht1npEwqUdnO6n5X+NVk1IxZKH1g8y0fRMaFJvm+BvDCZySaBz95IG/ZESIrrKr/Hf5QYqufBwRBOlAZjZMQJPF0VLrktWs7KigjYt+3Tzd8Lmgstcf3Z3Upm8RErSFOoL/Juf5SJKcA5tvrp8KA7RiZ0IblQNR2lndhu/slJ66zlKbwED/Tn7vySg72Oj8v4Pxp+HZIv7fLd6r8ckdZNQjmucFNzEKNyyg3TUgVQ1mqp3Wysi86qGFKnmPNshIJsR5I6aqPyz/M6LUijklaOzFHGP1mTKHce708+bl6IaZOOQimJMakdNzXZv7KKf87qz/0jHFGplEtrRx0y3Cmqx+0FvEpHq8DoyRfCmTAJSOTYKMT1dYbTGL0OgCZO7kspsHZI4xdpKJ6mcDTHdHZobMDW+2Jv+KU44gof9uE/XrbBQO/B/7tN2dk0pcDutbAEwFyaRlvNCT1f6ib43kgUDnXq4JsjrOkMOj1zBET9O/fMws6R95B/0Wp+QIYTc8o5y+1WvEvJyvA2yRZKGoe62DjF4/r5iXxL49/9t4g2M8BaSm7A542rVH0ew2enqo1YUUd1Fx8eL2lwsYOwwKH4cl3bzT6pzUOSuTAzEd0BnKqAcH3grBHqYx5qVXaWHjJl64lqnSce9/P6JLEZiMMHChC+4zB
 icol8qnY
 IslstDklmQl6nupMay8VWGy/tIwBJynzLTU03mIA3nD/SJMVFFNnK1GJOtw7bhGh/QWXPjqfhukrmUUUgaoyTYZ7p/vppCou9CSDaDSQd92u//yuxlRvc7zk2welpEaseSyqKsFg9Z1UTKvmUaLisyuw/bq+BCf7AeSXCG+UhAULOrIKu10BAU/R4lkWj+HAg28320yPYVHbqUAhftjLFSWAypZqFl7HJzB+Wl9p9tDHVwWr1eZ2kU5EFh8vNWFRBCdKaMWfX+qzBVzPfhVgjKYLiLozsNr9Mbi46M53XkBSOKT90Tigg0a0poBzfHQKqknAzilpc7MhlsWIgMj5Rkat+I4Xyd2jrB54eYpP2jj4HNwM67WHJaSi18nx3HodsnZ6x+PLoH0uR6ioQ0cmcNHanPYWF7QJaBeDJnCQ77t9diS3bRRYeA6OwIGsUTVIKVJygdgZMk41Cn5GR7f4n7zckDM2eSpHnWZUqQyTjr8Ka0OxfohkIT5pBA0sfAE8lrA5P3tQzDulNCqUXoHPUAYftrncvc9o3d13+gRlJTT/aEdsiX54oRm70Nda5c6ZWGeT27OQfx+4Phm7a9g546exQQLjGxQCl02qNm1n0+ObB94cpsKUx5ThuMHDPgJWuiHQBH54QV1f7bSg3BQHHosyOaC6JJKUA9JHcECtYemtoPMo=
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
- [Medium] mm/hugetlb: compound_head() evaluated outside hugetlb_lock in
  replace_free_hugepage_folios()
--

commit de1b340d0acd3398ffa967e9c36bcd2099c3b383
Author: Ge Yang <yangge1116@126.com>

mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb=
 folios

This commit acquires hugetlb_lock around PageHuge() and page_hstate() in
replace_free_hugepage_folios() to prevent racing with concurrent hugepage
freeing.

Link: https://lkml.kernel.org/r/1747884137-26685-1-git-send-email-yangge111=
6@126.com

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4fb98320f9df3..3d7e8826e4525 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2756,12 +2756,20 @@ int replace_free_hugepage_folios(unsigned long st=
art_pfn, unsigned long end_pfn)
> =20
>  	while (start_pfn < end_pfn) {
>  		page =3D compound_head(pfn_to_page(start_pfn));
> +
> +		/*
> +		 * The page might have been dissolved from under our feet, so make sure
> +		 * to carefully check the state under the lock.
> +		 */
> +		spin_lock_irq(&hugetlb_lock);
>  		if (PageHuge(page)) {
>  			h =3D page_hstate(page);
>  		} else {
> +			spin_unlock_irq(&hugetlb_lock);
>  			start_pfn++;
>  			continue;
>  		}
> +		spin_unlock_irq(&hugetlb_lock);

[Severity: Medium]
Can page_hstate(page) still return NULL if pfn_to_page(start_pfn) becomes a
tail page of a newly prepared hugepage before hugetlb_lock is acquired?

CPU0                                    CPU1
replace_free_hugepage_folios()
  page =3D compound_head(pfn_to_page(start_pfn))
                                        alloc_gigantic_page() / prep_new_hu=
ge_page()
                                          prep_compound_gigantic_page()
                                            /* page becomes a tail page */
                                          spin_lock_irq(&hugetlb_lock)
                                          __prep_new_huge_page()
                                            set_compound_page_dtor(HUGETLB_=
PAGE_DTOR)
                                          spin_unlock_irq(&hugetlb_lock)
  spin_lock_irq(&hugetlb_lock)
  if (PageHuge(page))
    h =3D page_hstate(page)  <-- returns NULL
  spin_unlock_irq(&hugetlb_lock)
  alloc_and_dissolve_huge_page(h, page, ...)
    htlb_alloc_mask(h)  <-- NULL pointer dereference

In upstream 113ed54ad276 ("mm/hugetlb: fix kernel NULL pointer dereference
when replacing free hugetlb folios"), pfn_folio(start_pfn) is checked with
folio_test_hugetlb(), which returns false for tail pages.  In 5.15,
PageHuge(page) resolves compound_head(page) internally on its local paramet=
er
and returns true for tail pages, while page_hstate(page) calls
page_size(page) -> compound_order(page), which returns 0 when !PageHead(pag=
e)
and causes size_to_hstate(PAGE_SIZE) to return NULL.

Re-evaluating page =3D compound_head(page) under hugetlb_lock after
PageHuge(page) succeeds, as isolate_or_dissolve_huge_page() and
dissolve_free_huge_page() do, avoids passing a tail page to page_hstate() a=
nd
alloc_and_dissolve_huge_page().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106220445.2859=
944-1-mkbund@amazon.com?part=3D2

