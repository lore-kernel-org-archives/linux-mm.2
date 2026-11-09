Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C189A606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PwQB8JQP
Received: by kanga.kvack.org (Postfix)
	id E59A56B05B4; Mon,  9 Nov 2026 05:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2B76B05B5; Mon,  9 Nov 2026 05:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAAE76B05BB; Mon,  9 Nov 2026 05:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6D366B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:43:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 420B8A8220
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:19 +0000 (UTC)
X-FDA: 85415243718.02.642AA10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9C5DE20005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwQB8JQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220997;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYVCCokiSk7cuJZxSFfUZM6UOn/u/+I/eRssbo70fAM=;
	b=30AXhD2rq3ApesjUL4WBerZUm80XEOBPIC51KFZ8WWxvV07xzN2KrjxiYdcm8z6bs3LNDR
	1Dzp1fRiVNc844eMqNDZSDs4G/Yl5Ygv3fzQ7sFApeeOquDyUnzJ0BjhC+khGNwPQa7NUA
	Xo98oCqM5NznAq4IrdlUYmlBMKoonRM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwQB8JQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220997;
	b=WT8euZW8Hz0ZcIAiKxXLQf43NFmnuhFByIn//cuCp/OHw/ZP0qMgbAKLZDsLQ2a26GDjDF
	npvdTQ2SeJvJMh0Mui+O4A/A3XN4I3JQZ5gPpwbgaZUShIpvVpugMK1VQFXayuir8lyzpI
	jJFs/tnEdQH+etOp0nJ7zEy/JP1EZkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62A8A609EF;
	Mon,  9 Nov 2026 10:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C01F0089F;
	Mon,  9 Nov 2026 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794220996;
	bh=HYVCCokiSk7cuJZxSFfUZM6UOn/u/+I/eRssbo70fAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PwQB8JQPM2YjDng4zChMq/v1z4jgcMw0C2+/xyoo57qECEOXvoEtyBuiJ37eCsYIm
	 yQ9Ewcz4yOn5xw2fg5flYYBLwTZMKAPfToDvrNPuuAvL/Dm8tL5TakD3rH5YMmXo2S
	 kGLiMbuTb7jV/P6DFhzverbwDigdHJxA1cHJbVtMYKHLO+Z9VuyQWpH+matV07Y0ie
	 RrBJgQ3YFPIRcxxPH/+y2gFc3Z/jzvUzJYBV98zU6p9eMvXmGnGXbxcB7A4kkf+nMq
	 Qki/D0uL0HVG8a+LV+HWm1B3FeXCunkZVRjsL3e+Tn3fiPiNJkkW1bBVKg7eqFo1Ox
	 ElNt5SMuDIKgg==
Message-ID: <sashiko-outbox-204836@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/11] mm/mm_init: factor out common struct page
 initialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "James
 Houghton" <jthoughton@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261109095807.41547-3-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:43:15 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C5DE20005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kpmx65ko64s8wk1g7w7p7m9rs9j8hu6t
X-HE-Tag: 1794220997-486473
X-HE-Meta: U2FsdGVkX19hYfkcRanvEl/7PWHJwjrkHvEeDEWbgevQm2kOfHJJ6vdJGEdTqp+L8um9vVmYfW3kvzeBBwrVE2cGOYmRWTy2XIMwDZJFNH0wUH9s843tDDSdMRR+C740OC+qJNwNlCl9c4TXqnqzCJMzja0shHXwCUCrSNWz9VeRjrSKWx9uecKA2zeKUF7BJ1JjBRG4v9e5fdhAqyyiOcW+YRuzw8SaVlYEtAXv1wZdwgZZ53lz5Gb9GeMNMVw13l55ntUqX5ccAKLrIqHlp+v9a+OGDyRTk4XwCA3oJ7yPWBQQtlSfUPkla7r8E6gBlZxbIJ1Wm47ABcneNG0N3ZZ8ystf/85Nf92QuhOlCtm62uwWWeGjberDKkMbBgYKNwJX1sqdfBVLeLgN7SKKOq4eY9eNzJVbEogb7/6gKwIZDqAjaAJMvH5mcx7oQLBXw7PSTcG0GjOi+ZajLQmrF5edQe7ufA0yvYaxUuMvNPtvViK1waw2fx1tWda2Rqz8xEWwoQ8ubD8dnIt1X4eYdXg1m3Nhs0FdY4/cpQssM3wS9OIM7lkCv6R6FiwfdLyWDeAMjYg20f0iUkPbOzV6J0w41llBFRB5XVX8731IMq2S/2MvKjR+qM/9A0yXnPdPKdTVO9cpCmYJ1j1erFYsSJw8Xe0Kgh02Hs9A6bQtLDvYdbKdc6FGZBsrPXkV5CbXgGii/h2aJu7aYKuD1eqmYc7fk3fiwu5M2PI6Lud+tnn0OGJ/2Ke2XARkzDuGoFuINljFQ4dpGmrPmG2Dlp5fpUJqA/8ZVmSP7BU143ant4lFYBQqdwaOJeNTyMaJV4QodlEpla7awj43gf+n0QSNcIEWXyrQKKAa1cAVvGdRcj3E6TyHHkprP+xs4FFZK+/Y/dC1j6F7O+950yVRurv44HGRDOSsa3nH+gChudAmk+cHFHAut1+lUo5MtlyovftkCDs5DYckodgYxN02SKl
 A1X3TSol
 4S4Teks+3ODwVpkXeHu1+AequhTBQUv8yjCymT14sbkhmhVrPJZq4dmCnfBV4VjlChH6qTFYiYEIFk4Q+JXgS7Zr+aw8+7WEBJRFkAWxNa838VNEqHnl6+b/U/mK1Zw+tkv7C4BsnY2jzyzjcoHLvD2/10uBRcSmSP1OL8qxkjpt7WSjX1n7XJ4Z/RfYnaCdILOCYs8QVXtsNnpZXuzcI8XCBSH4MIz72WuxaikVYdidAMb1GLxd1woV5qAAVNQ58PBQLr2zl3sWNpKW4Ow8RAS7p1D+Z9KRxOx3Hi2OEoKA8sP+PU3Mx4qMxxGJyw5Q2OwzUkEG9ESDPMwHxCek86DlRpSb3MxY1EYgjsm7gH+izczUck2ZkAcRKgy/2TSdcn2yCAsScRgezfHVKxX7fE78XgNfQ/v7ijnDqFc6zKXV7KpbMd0qPDQjAo/PznkhPL/jdseSbmK4/fNUIAJbrUKdTpTQR89mH8oScelrlEdLduWnYmGuWWbPNH2fBcXMZnwiSS3SYvmgRFobWod5iNAKS4Zi6T/bzVVfqBkONta54m4livC0eT8q8WrhhyNF3A9p7pwsIsgKQ62MbZnCoCwuJ2e8oHu4kErWkyyp6tFt3XnPpQP/qr5DIuf88RTm3fidT
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
- [High] mm/mm_init: __meminit on memmap_init_page_common() crashes at
  runtime
--

commit bb3e83c26b241fd60613632a0fd50cc529ce8be7
Author: Muchun Song <muchun.song@linux.dev>

mm/mm_init: factor out common struct page initialization

This commit factors out PFN-independent struct page initialization into
memmap_init_page_common() and uses it in both __init_single_page() and
vmemmap_shared_tail_page().

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 0129152b74d87..9677698f30d3a 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -602,15 +602,28 @@ static inline void vmemmap_optimization_verify_zone=
(struct page *page)
>  			page_zone_id(page));
>  }
> =20
> -void __meminit __init_single_page(struct page *page, unsigned long pfn,
> -				unsigned long zone, int nid)
> +/* Initialize PFN-independent fields common to pages in the same zone. */
> +void __meminit memmap_init_page_common(struct page *page,
> +		enum zone_type zone, int nid)
>  {
>  	mm_zero_struct_page(page);
> -	set_page_links(page, zone, nid, pfn);
> -	init_page_count(page);
> -	atomic_set(&page->_mapcount, -1);
> +	set_page_zone(page, zone);
> +	set_page_node(page, nid);
>  	page_cpupid_reset_last(page);
>  	page_kasan_tag_reset(page);
> +	atomic_set(&page->_mapcount, -1);
> +#ifdef CONFIG_ZONE_DEVICE
> +	if (zone =3D=3D ZONE_DEVICE)
> +		__SetPageReserved(page);
> +#endif
> +}

[ ... ]

> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 9b80dd7326f7e..fd869617423a3 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -212,12 +212,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned=
 int order, struct zone *zon
> =20
>  	for (int i =3D 0; i < PAGE_SIZE / sizeof(struct page); i++) {
>  		page =3D (struct page *)addr + i;
> -		mm_zero_struct_page(page);
> -		atomic_set(&page->_mapcount, -1);
> -		set_page_node(page, zone_to_nid(zone));
> -		set_page_zone(page, zone_idx(zone));
> -		if (zone_is_zone_device(zone))
> -			__SetPageReserved(page);
> +		memmap_init_page_common(page, zone_idx(zone), zone_to_nid(zone));
>  		prep_compound_tail(page, NULL, order);
>  	}

[Severity: High]
Can vmemmap_shared_tail_page() call memmap_init_page_common() after
.init.text has been freed when CONFIG_MEMORY_HOTPLUG is disabled?

When !CONFIG_MEMORY_HOTPLUG, __meminit expands to __init, placing
memmap_init_page_common() in .init.text, while __ref on
vmemmap_shared_tail_page() suppresses the modpost section mismatch warning.
With CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=3Dy (which does not depend on
CONFIG_MEMORY_HOTPLUG), allocating HugeTLB pages at runtime reaches
vmemmap_optimize_pte() -> folio_vmemmap_shared_tail_page() ->
vmemmap_shared_tail_page() and executes freed .init.text the first time a
zone's shared tail page for that order is allocated after boot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095807.4154=
7-1-songmuchun@bytedance.com?part=3D2

