Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AB9606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jSTGdRM8
Received: by kanga.kvack.org (Postfix)
	id AB8F76B0677; Thu, 12 Nov 2026 23:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97EC66B0679; Thu, 12 Nov 2026 23:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBB26B067D; Thu, 12 Nov 2026 23:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3DD6B0677
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:07:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD9A016011F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:07:36 +0000 (UTC)
X-FDA: 85428761712.02.DB83911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C90220007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:07:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jSTGdRM8;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794542855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aldM43iDnBgK669O7/TyzrI++PflsmX7+Dloxg69GQ=;
	b=igeRIvf1jQ5fgG0cA2wHRzPmE3L/dD12OGQCvGK5ebcApC+X7H8uQIO6xqXq8yNwCZu8RL
	NrvnIDUjh2RvGjw0pg2szzoAK958QlshmHh9ldF1PRS1Vl+xU8JwwxEiBQ2qwka+H1mn/d
	HJ9kUGc2ntDfDeF2N6RjCSa+jP6xx+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794542855;
	b=rxtktue5oSsKioWgtiv+xvz2ZE07LaO/89JPBkKvN3U/3H135RFFgjobnTvJClCPMZmwQU
	Ji7Evx3Qx4Fmf04Rh+vmomxS0Y1/YvFv2uzkAcR+qdnDoadjQkKcdKVSbC/jD0481jxVoW
	JIjUQIbqqXVuhmffVTvk3ikZuodYLUg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jSTGdRM8;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 563FD447C7;
	Fri, 13 Nov 2026 04:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B691F000C4;
	Fri, 13 Nov 2026 04:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794542854;
	bh=9aldM43iDnBgK669O7/TyzrI++PflsmX7+Dloxg69GQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jSTGdRM8IgWThxf0PcqRJfP2Un8sdy7nckG8gyJRk1L66huSt+isTWrpEhvcvMpPE
	 6CmCAhtON7D5l8NEZk/TQdafHISB93QU/8VNUoVSuJBGgSIFJmFTg74VobDu4z4rxb
	 LsW6i5e2YfQtb+moSG9sxyGGO/xsv+sjCfOWx1Expv9Hv2fqPC59y9/vXjCD1LiqkA
	 LBjGV1hvWzygJ7ra0ogQ6dWRzuMs6nDDzb5QDlUvASRR71504cxoY/DnW9n3gBmehH
	 99wM79hMqryR3CjmCXeibBiYVQPiPtM9ViRLyLNMgnLNv4yw/DQR2ht4Oh814JtLi2
	 /qvRe+8XJbVqA==
Message-ID: <sashiko-outbox-212157@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/14] mm/cma: centralize CMA pageblock
 initialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Li Zhe" <lizhe.67@bytedance.com>, "Andrew Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Muchun
 Song" <muchun.song@linux.dev>, "James Houghton" <jthoughton@google.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261113033442.62970-13-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-13-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 04:07:33 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mfitftbyw9jsi9seoby4badn8dthj5ck
X-Rspamd-Queue-Id: 1C90220007
X-Rspam-User: 
X-HE-Tag: 1794542854-725578
X-HE-Meta: U2FsdGVkX1+YJs8g8tr+MrDnDNKzBp/wDFILlZRCaH6knYja7Qpz9amAMNpeHKX/glGfwqc7pCY0h5itvyBFVlcx4VlkZkd9/ba6B3D2kvjpv9TtTrX4Zj298RlucutJNcegWHGKtmqzqtFTYuFYbTjwkul4Xpea2kZrBtQ1C4UQKD6Hl9DABBG3gqLaDDpxeprkY2z9/P5fuMEEbdkfA/0SapXK9wbTbCNFk1Jl3voV0Ct4YxR/v5VUyU8ss2eue/divh78+Lvw30+K8eH3tZJtOhkAnF2FL9ZZbOsBMR0P3tHTn0hU/zjRYN9dzk+V0dpCkAv+vWJPjpmmKtyclveJlE1/hdsfaFtbu4M/ktlu47SWnpyf0rrBdeCAHHvHgp49vRkMPK7mnM/mZGhnoE/alDX5VAWF1ql/fxRSJoTLYSRaQOqpmbkOlsmUpSG7Uh8a8OXUKqbe76mLJy3Xxm89Ci2GiPLw6+Sp1r/eGFjjMgsyTI1ahs254nkpsR8LYgXdEIzOePIicpsjh+TzPEytDok4f6fg9kOBPIRuSQAmlKnvkU4P8isxeGKUFTTNsd2GP019IVHyHlKFQosRClQqS7EQgZ2VtCpdONlbb7a4VAnnfi8xK5rxnzaQe3fgUB2qhXW3gFryrEL9RZXujB8QV6PtAqbXpqqLntfJjSM2FQKFbDpCHVZi5vUYF0HFfPc0d0hhRLhXy6KBgTaVHK98y1QpOcBLPg1lgrYTwf+WRR1gXpg6g92NNDED5ljaUZdDZow5aYqe0COlZqRimYiD3okQsFNpWViC2PTamiwKbnUHbT7oUE1eyjpmmFgZ/X+jX3b9EQyuo+yU/qUCSBq7h94SUgqqbqL28i0LABkk7K1L2Yk6SK+PWCXZahU758PpbsH7atQoDV36uir3nCL3TxG332AFPA2bW/r/MlbATVzwQevNTBxR9iVkWCC/xQnX+pndJ+XoI+073If
 uHS6eTsy
 EEsCtM3hFY9KhI8djYrDEly7KHhJCICPvmfQfz0AZYHYb5QESWZ7cZai3tShvwb5VdUjhyHhs6OMH6OlN0cAAPMDPYfBSJi0C+YhA/77OnRrD4y8/nC1TP17xTZznTcI1t6kqPQznZNo13OVt7rKOxKBierl99f7OX1yvVGRLN8kzGoXsFpyQJ3jSlhXIDeDSOG7kgUS2GiWfqJWgVS/f6GKyAXDnaATrGqm+EhkIve4N8eiD9ReiE9YghU7aHQR266zBYfYQRmVGV7pJ6gep57txZDRikUxHYH1V8rDVrzN0176UR1Vb3aAHixZpDWaLoFgrXlOife/AcbblOZNMGdCSUpg2dSt/Y3S73MGH8s3fcvJxWxxFPDGXdDA19V2/gUVgx5pRhVVv5Zc3luNCqjd4ksUP8YwjrAkjR/IuyKbAKqYG7r3/NvonbXPkoQmyJwTe6RoUGiR+Stmp3sJV58ztD06IJNxW8+vsvK13e8IsVkrM8+AqcHACeHEUJuyb2UOzqG75mY4rfX4zWIdUyTowaWZPghHd3RxU1sQoJkiQUBXRNCaw3UeV7aEQwe6PUZz2wVOES+R/KeVxDUSsZ1+R5Q==
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
- [Medium] mm/cma: skipped and per-PFN managed page accounting in
  cma_activate_area()
--

commit cd588f911bb59c4583e63d2e776ba252d0663161
Author: Muchun Song <muchun.song@linux.dev>

mm/cma: centralize CMA pageblock initialization

This commit moves the initialization of early-reserved CMA pageblocks from
hugetlb into cma_activate_area() and restores managed-page accounting for
those pages if CMA activation fails.

> diff --git a/mm/cma.c b/mm/cma.c
> index 9ec1d1fd5dff5..46e72734ba729 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c

[ ... ]

> @@ -191,12 +195,13 @@ static void __init cma_activate_area(struct cma *cm=
a)
>  	/* Expose all pages to the buddy, they are useless for CMA. */
>  	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
>  		for (r =3D 0; r < cma->nranges; r++) {
> -			unsigned long start_pfn;
> -
>  			cmr =3D &cma->ranges[r];
> -			start_pfn =3D r <=3D allocrange ? early_pfn[r] : cmr->early_pfn;
> +			end_pfn =3D r <=3D allocrange ? early_pfn[r] : cmr->early_pfn;
> +			for (pfn =3D cmr->base_pfn; pfn < end_pfn; pfn++)
> +				adjust_managed_page_count(pfn_to_page(pfn), 1);
> +
>  			end_pfn =3D cmr->base_pfn + cmr->count;
> -			for (pfn =3D start_pfn; pfn < end_pfn; pfn++)
> +			for (; pfn < end_pfn; pfn++)
>  				free_reserved_page(pfn_to_page(pfn));
>  		}
>  	}

[Severity: Medium]
Does gating the adjust_managed_page_count() loop on
!CMA_RESERVE_PAGES_ON_ERROR leave early-reserved gigantic hugetlb pages
unaccounted in zone->managed_pages and totalram_pages if CMA activation
fails?

When crashkernel=3D...,cma is used alongside hugetlb_cma,
hugetlb_cma_add_crashkernel_ranges() sets CMA_RESERVE_PAGES_ON_ERROR on
the hugetlb_cma area before hugetlb_bootmem_alloc() reserves gigantic
pages from it via cma_reserve_early().  gather_bootmem_prealloc_node()
always skips adjust_managed_page_count() for hugetlb_early_cma(h) folios,
and those folios remain active in the hugetlb pool even if
cma_activate_area() fails, so their managed page count needs to be
restored regardless of CMA_RESERVE_PAGES_ON_ERROR.

Also, calling adjust_managed_page_count(pfn_to_page(pfn), 1) once per base
PFN invokes setup_per_zone_lowmem_reserve() for every 4 KiB page (262,144
times per 1 GiB page) instead of stepping by pageblock_nr_pages or
adjusting by end_pfn - cmr->base_pfn.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113033442.6297=
0-1-songmuchun@bytedance.com?part=3D12

