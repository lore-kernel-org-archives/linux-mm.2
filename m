Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEE9606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9FNudeU
Received: by kanga.kvack.org (Postfix)
	id 716866B05B1; Sat,  7 Nov 2026 17:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7986B05B4; Sat,  7 Nov 2026 17:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6B26B05B6; Sat,  7 Nov 2026 17:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3232A6B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:07:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B11E4A03F4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:07:47 +0000 (UTC)
X-FDA: 85409710974.21.9F799C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23AB6140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:07:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9FNudeU;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiKQUeIKpVvbJzgJsUwSZkeZUL7L/684J231+1lYczQ=;
	b=01t1AR6/ZHymz+ZTqpE42mCCalB28OB9o2rmJr8i8kZLfvWRM6V8XH+SjNFaoJnXLE0RJ0
	4mIFPzW85v5p82S0Ng7l5XKHTyLVHDeFPziBpuUZj0ZAuXBC+Itni1ibKPitqQMbC1wGyE
	uQk5QGZkIX9EyxbreUbTnDCDv5EhplE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089266;
	b=eQM3yVgJ1qA3NQEgJJtQnYqsIaJvXWKJg9berf1CpzyK9kOVLofJTKhHka398SvEjSaHol
	qj/gjEfxjEBHkbbX+IUQA/tvjFpcOUFaO090ZjfwGkMffgnYwJm5eKzCJbGTpGWSPDmRT5
	ZLxuRUQ8VguW8rr6zdjKdnrlDmKgVrg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9FNudeU;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A80236121E;
	Sat,  7 Nov 2026 22:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBEE1F0089F;
	Sat,  7 Nov 2026 22:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089265;
	bh=XiKQUeIKpVvbJzgJsUwSZkeZUL7L/684J231+1lYczQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g9FNudeURvQ7ZCXvQJju+rQFFLU2at/y6IqhsgXfSYi8Ag/LRnHQ18UUmrH8WXk/R
	 9DX8GXG0TdPa8nVGWS5wDIXwo1g379zo3i1a5dypyoMUPIsJTdEThisqQ3Dm31qRDp
	 VUR4eI2MH29ksAhH4OwGbtzHDPyviui12NSLGBRoK5059+BUgUroN9xicTY0Gqb+yj
	 b4nv3oKk3anTyx6g3A/Ect7Sw0DmmvO/LSRKedfZIcMSx2ehDsWV951tNtRISlEeGt
	 4EokXqmwpsThdvaq4t2y1gxtnAKHNIDPDGimjmbnsAGdRNN4oyAcoZPZsBCmfm9Dcw
	 1+MzLqeLT6QnA==
Message-ID: <sashiko-outbox-203354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6.1 1/2] mm: replace free hugepage folios after
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261106220715.2869940-2-mkbund@amazon.com>
References: <20261105070346.3099207-1-mkbund@amazon.com>
 <20261106220715.2869940-1-mkbund@amazon.com>
 <20261106220715.2869940-2-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:07:44 +0000
X-Stat-Signature: tgtxf5upuraqp8j553kh1hshbsh1ns8f
X-Rspamd-Queue-Id: 23AB6140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794089265-823152
X-HE-Meta: U2FsdGVkX1+Rq5leUtKqjSsJuEnBCIaDlr/D0qH3ewWVXLyMRqKbElmM5bfePG4qED5QpdmHm229oNaHoigK38fiEDWWgyiJBf2KI/H4hSCMvcrJec774+q9W6vXUbnKm8PZJz6ARtARB7gpeX0KC0QmLh/w869q53i5mdiWenTgl/l1CnkVDtOV+zlgOOMXOtiWurEFySu32T8OfuwC7GXXeFE6az3MZ9ZYrTCDPJSHQQWHg3rWx0JCWXfLSj8eIUW47jzuKPn5vrcQ92y/IY4hw98RbnQi0Xl2s0ROJCimBWBfhEtqI+6puxdIYGzhTdsGyuPH9JDZh1ICaM5qWrhtHFCn++sXVy7DilpLa+c7pL9ixadgMcTvZ32aOpAgHT85NTGq6o+gH6SkWzrhzI6evRX1NpU0JEqOJKX4dXV9QH6g0Q3b6pkK9n9fJqB+JDlMce9RBfkE1VDLzjRjze1Eq9KZRY+FHOZiFPD0z/x+E6kMPZ5ad/xZA32iYJhEF4o0t0nDOQtwu4/sjDxWrzQ0F2PCQ/kPdz0UlVdza+YYX42/QOczoWGhFCyPAFQqcLvdc7aJqdDX8k/N2IzRBR/BbqLliihvbZiAAlYLhIcdRCm5KpYybU6pq2Sgc4JNMxejFYrBClA4k5W0OjtSwB5t/PYZW5v9S5PooXBePOkpWvXBSHNTwJAHV0ul2oLDLjMMJ8n3fa8JZ0vaEO45oyHyiXy5m7BmH3NHW677IP3IZ7O/doHfA4T2gVrWBJcOIywBYpZw8gH0cIBU+kaCxTx8H4kVzWqn56eVxzPNheUZu7g46ljnKdFMosMtmda62ppZuEF+9wM6zZLSDynb/vP+DXn4DqmUZqv3uGANs1kp5/wrqom6H2mMoHwICxDSQW5ZI2MJ4vWrbejqqLgL5meELVrJN7/1RFP2DUjhLaMzjqDLUwylBYTlMFf/pj2IO1DeduxtnW+VSWdgsAW
 LHElaiI/
 KR54lPyrkJ207Ae9brrDChuog7JffZaNNvldfakOEGucg2pOk7ZyU8pYX7uD4wtNiMMjzKsxtTs5IEfLWPym5DwV65lhSFJ2nLzsFnvEA1IfoD0fkSQhSGlda8eDp4spKfUHMUtyQ+XOEj6xJY9UxoNS5nkp4K0X+aKPoPn7YWU//Fm7C5O6nEEvU+74hjRbTJsOQ8y4nF24c33QVcReOlkV976SnuOB8UqTdxH1z0jFDjdDoEnYr5kmYRFBBC0+i9Mq6CpTMR9PwxAr/V4fdBFrslJjcBAz0cz5VzsyiJWUSMme3bEMrGgim6xGVj71Hyau717QU3iGESnYS30d+/4e+oiCPbPJ3PEat7B7MTiLcfxkpOjs7rl1xlX9z4s/KxrpT7Hny7LB6ZkxVKRi88Kvus1M9xEr5iyqi6NElLGlAj2sFVVKCL9ISRk4PIrtkgDqAfW63nnNGO2526MHAfHfe7EaaKRKWsxWEqwAGRPBNSmCx9tCC64EwGHooT4kRxwXxNZrFsasIcBdHRoT/0BLqo17uZnQmrqk7TV8Wkuw9vrbzth0SKt6sm3iURhwK10Uh8iKweUvcJaLPA1O6rC2mIY8MefL/mGJSkjmb70pKXy8KY/l+M+abUMKmUMM+WhOcexsp/lA2FtFZFWNMKOfuF1hRI05Xk9yx
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
- [High] mm: hugetlb: skipping isolated free pages in
  dequeue_huge_page_node_exact() breaks reservation accounting
- [Medium] mm/hugetlb: repeated hugepage replacement across tail PFNs in
  replace_free_hugepage_folios()
--

commit bf676e0a7d0d63af3750623a0cea703c4c123b82
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This commit adds replace_free_hugepage_folios() to replace free hugetlb
folios in an isolated PFN range after migration and skips MIGRATE_ISOLATE
pages when dequeuing free hugetlb pages.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f549adc0b6705..46031ca5a7fb1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c

[ ... ]

> @@ -1343,6 +1344,9 @@ static struct page *dequeue_huge_page_node_exact(st=
ruct hstate *h, int nid)
>  		if (PageHWPoison(page))
>  			continue;
> =20
> +		if (is_migrate_isolate_page(page))
> +			continue;
> +
>  		list_move(&page->lru, &h->hugepage_activelist);
>  		set_page_refcounted(page);
>  		ClearHPageFreed(page);

[Severity: High]
Does skipping MIGRATE_ISOLATE pages in dequeue_huge_page_node_exact()
break hugetlb reservation accounting while those pages remain counted in
h->free_huge_pages?

When a free hugepage backing h->resv_huge_pages lies in a MIGRATE_ISOLATE
pageblock during alloc_contig_range() or offline_pages(), a fault on a VMA
with a valid reservation sees dequeue_huge_page_vma() return NULL and
falls back to alloc_buddy_huge_page_with_mpol() ->
alloc_surplus_huge_page().  With overcommit at its default of 0 (or for
gigantic pages), alloc_huge_page() returns ERR_PTR(-ENOSPC) and delivers
SIGBUS to the faulting task.

Similarly, an isolated unreserved page on h->hugepage_freelists still
inflates available_huge_pages(h) (h->free_huge_pages -
h->resv_huge_pages), allowing alloc_huge_page_nodemask() or an unreserved
fault in dequeue_huge_page_vma() to pass the available_huge_pages(h) check
and consume a non-isolated reserved page instead.  Once only isolated free
pages remain to back h->resv_huge_pages, dissolve_free_huge_page() fails
with -EBUSY on !available_huge_pages(h), aborting offline_pages().

> @@ -3073,6 +3077,44 @@ int isolate_or_dissolve_huge_page(struct page *pag=
e, struct list_head *list)
>  	return ret;
>  }
> =20
> +/*
> + *  replace_free_hugepage_folios - Replace free hugepage folios in a giv=
en pfn
> + *  range with new folios.
> + *  @start_pfn: start pfn of the given pfn range
> + *  @end_pfn: end pfn of the given pfn range
> + *  Returns 0 on success, otherwise negated error.
> + */
> +int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long =
end_pfn)
> +{
> +	struct hstate *h;
> +	struct folio *folio;
> +	int ret =3D 0;
> +
> +	LIST_HEAD(isolate_list);
> +
> +	while (start_pfn < end_pfn) {
> +		folio =3D pfn_folio(start_pfn);
> +		if (folio_test_hugetlb(folio)) {
> +			h =3D folio_hstate(folio);
> +		} else {
> +			start_pfn++;
> +			continue;
> +		}
> +
> +		if (!folio_ref_count(folio)) {
> +			ret =3D alloc_and_dissolve_huge_page(h, &folio->page,
> +							   &isolate_list);
> +			if (ret)
> +				break;
> +
> +			putback_movable_pages(&isolate_list);
> +		}
> +		start_pfn++;
> +	}
> +
> +	return ret;
> +}

[Severity: Medium]
Can advancing start_pfn by 1 cause replace_free_hugepage_folios() to
repeatedly replace the same hugepage across all of its tail PFNs?

alloc_and_dissolve_huge_page() calls update_and_free_page() ->
__update_and_free_page() and returns 0:

mm/hugetlb.c:__update_and_free_page() {
    ...
	if (hugetlb_vmemmap_restore(h, page)) {
		spin_lock_irq(&hugetlb_lock);
		add_hugetlb_page(h, page, true);
		spin_unlock_irq(&hugetlb_lock);
		return;
	}
    ...
}

If hugetlb_vmemmap_restore() fails to allocate vmemmap pages,
add_hugetlb_page() puts the undissolved compound page back on the freelist
with refcount 0 as a surplus page.  Because the loop only increments
start_pfn by 1 and pfn_folio(start_pfn) resolves each tail page back to
the head folio, the remaining pages_per_huge_page(h) - 1 iterations call
alloc_and_dissolve_huge_page() on the same folio again, allocating extra
hugepages and inflating h->nr_huge_pages and h->surplus_huge_pages.
Advancing start_pfn by pages_per_huge_page(h) (or the next hugepage
boundary) avoids revisiting the tail pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106220715.2869=
940-1-mkbund@amazon.com?part=3D1

