Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8097C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69D76B0092; Wed, 16 Sep 2026 06:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42996B0093; Wed, 16 Sep 2026 06:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7FA76B0095; Wed, 16 Sep 2026 06:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8726B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D15701406BF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:54:08 +0000 (UTC)
X-FDA: 85219315776.18.3FE15F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4851F20002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:54:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmVxjWAI;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789556047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk85xeNcSE092LkOlJCMQ/OGCYgiaRkt+beVhCe3upM=;
	b=y0RghM7ifpyxbY1BFb7HqfZhWGXfEaruM0cWwe0Qd5T5+uKJuWpF5o8cOR/d+FjKQFSZfg
	LXo5W2tn+89rb8owQJOWZmjvTEM0bw0+VoOCg16rX83/VCnUICTnYzcijgFPD5GiLIcw4H
	oAWJBViOAqBdKmvjkYR39YHkv4NQdvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789556047;
	b=N2psPfknnqOch88TkEv+cgzYt+GWGdkNvy6bvV8ZX4da+7bhKQmhQJmOj6slLFMBRsRfsR
	WNH6VhzO4wUnXvZUR4S4af/y0lsKXsID1WScO5kB/YeOrZdqBC7nOGU/grjqZDOPZx1aoJ
	Wdg0N4CwMqd3srpBmYKdUhdwU0bvJ4A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmVxjWAI;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60D7A60234;
	Wed, 16 Sep 2026 10:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB51F00898;
	Wed, 16 Sep 2026 10:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789556046;
	bh=Lk85xeNcSE092LkOlJCMQ/OGCYgiaRkt+beVhCe3upM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HmVxjWAI/6i5FoXl7rUite4rysWcEEQDdkTWX9veRxbkCPUBQRW4yRQPavj6GyaiC
	 qnTvgs5NZhGjxQppVb8aqE4tAutWQoMp+9vYiQuCgqIpTp2SI0HQ1+Djv8ai3/QQih
	 6HcOCKtn1YR3ZOtKQYjcpltUEWEEqi+8g2PmODGmZ89S2lpW4LEMtciuNosj1bm7c+
	 oL7AYPKNo9yWbdDQ6mG40BdlSXVUg2VPj21bZ9O2X5GEFJYqAngksppgV2WhE3hEu3
	 vXwFUmQGi3Qs/RIkbKCZD9YDnoGFrqUaSsuSqCYWWg2XiLRT0+qCb1moi4oHGMuOc/
	 nkKuYhImINXxA==
Date: Wed, 16 Sep 2026 11:53:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/mempolicy: use vm_normal_folio_pmd() in
 queue_folios_pmd()
Message-ID: <aqpyp7ouLyxGhJDK@gremlin>
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260912034833.2952750-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912034833.2952750-2-gourry@gourry.net>
X-Stat-Signature: p466ddc9mbhnuq3uxs7w5qe1mtqc7pxn
X-Rspam-User: 
X-Rspamd-Queue-Id: 4851F20002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789556047-967490
X-HE-Meta: U2FsdGVkX1+eEm1dz+NtjZ6A2wtJbarkm8PFxIkvJJhIY2HnMR0jWdPxyW4V7mE9H5JrFZwMCSr/Nh/mUf2MnEtaDNRe6M/0myiipJSrZf5xWMhPj5Ds9hFeYBkI4jA6y44jGiCndlUeB2FZJCVgttpxfdcWvH1fQWGeG0p2RgRJV8XfR3C1UBp1XNxro9OBic0O3n/fS7JnumyL7fHfDkvupvmhzJCVdGNhIhP9L2d7t1+EoXxyZjvJ94HlIqnW/gA9pyKldCJFUixEL15311oejs1KptmvQsuviSc3bgUvtv7K++monUOyK6uZW4+3Q7uP/pETXmwK7QpX/LgSYam4hOJZiZBAEJ8J43bPtdOZOQHSfXUcVWcrYCP6KNWdCZzJ0foblXoOQ8qyrZufFkNQ/HeMjSpuEmkAesCcDHMqM+fBB+dhrKvsmMXPqBD2VDs3lgIDKwiYnbh2m90t7SU9N/4JhGTL+NFZyyad3Bjk28DDutybvbqNz1pvU3xDC3UnFg+3C7lqVRtM3rz+2hkwvAbYDKnLyht7/j5h6CW1193M00tQ9UCGCYNzwIt5ZK1hQHFoiCyggh/OYwXHodd8vDcTW6zcOZRBMq6Can0V0OXEIxtANivTjI5kfCeuib/urli6nDM2dMttYVfUaGETT5IhQmYhkpftFb6s5XHUGzC2tzrid+VOvGIeKR4tiJJ+qidGGOxp/ZxiBwjiSbcrSJ9nDKCaQv6K222k6EVkIzydoMARvyLEXbHMOB7J+Ffi6by9PV46hZNGiiUGGLS+93qhfHO45RSQVZwmVs2yzghuzL12ZKbNIVW1qtnj5xotQAfb/wv3L3iXQCekNAPIUvMAgPW3wyE9X+qGpndqKIyNR7rbsbgIMyAL/60TXYNrS25ij8U5rHNgyN5EyJZaaJa/U8E1GvXdJwFDAwipJ8Dxlv9P6uouN2Zr3+TciL8U7gOCHvMg09WGttq
 m+pqZsGB
 5Wtl5z1jbwfzR+zkJJuAhoz9TEpBxMyxmmCW/PmkJdOCWGww5BdiCi7Hx8X6S9CXyMIw94KsVisnXVG0YBntedDXLbN4dMAlsa/X4pnoIEIWI/MarkwgiQTIZ39c14OcWPgOiabs574YuAkUk3kdFCvmiGlCMUPYIIJHKS7v+rC4BJj/7FocPvk8n+yaB76QjgGVMVvZEEvFUQEuIoQK+jCx+rNYGG6GVQM1C963mlKK+L2fzdBxvzLDXkGGSEm2WFROHQlHWLXuqmWGDgwyUWRRJJqqSTGVGESvDraguY26Md6nqO1C/5JCtxl5IqtnOMc+MYns/3+sKPlXmnOWMQtIxKo0qUJZqZyy9s1NeuAc+ojFHq5Rw1044Vh3sNrwYxQOgNvyA0Y+oSgHGSDTCWfUU25peFz9Tppq+8NF9w4UTreoEi2le8EPk/8C9EgAsQ62l+FPHbV/+uqaKxQ2RCtPOHJDZpCA0vZR1+9/WHFLEoqt6gkqWJDa0Y2uaC1vfPfY53D5V1kFt6LA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:48:32PM -0400, Gregory Price wrote:
> mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
> vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then
>
> 	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);
>
> With a stand-in module for the driver:
>
>   BUG: unable to handle page fault for address: fffff96dc0000008
>   RIP: 0010:queue_folios_pte_range+0xaf/0x440
>    walk_pgd_range+0x52b/0xaf0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_mm_unsafe+0x193/0x230
>    queue_pages_range+0x64/0xa0
>    do_mbind+0x25e/0x640
>
> queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pfn

This makes me wonder if pmd_folio() is just generally defunct in favour of
vm_normal_folio_pmd()?

> is raw MMIO with no memmap entry, so the folio lands in unpopulated
> vmemmap.  Neither guard stops the walk:
>
>   walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
>                            supplies ->test_walk, so it never runs
>   queue_pages_test_walk()  honours vma_migratable(), but only while
>                            MPOL_MF_STRICT is clear
>
> A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
> mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
> into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
> mapping.
>
> Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
> queue_folios_pte_range() already does with vm_normal_folio().  On the NULL
> path, retain ACTION_CONTINUE handling for the huge zero PMD.
>
> mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
> rather than -EIO.  The PTE loop already returned 0 there.
>
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/mempolicy.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 2ad0a5f18280..8fc8a975657e 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -667,7 +667,8 @@ static inline bool queue_folio_required(struct folio *folio,
>  	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
>  }
>
> -static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
> +static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
> +			     struct mm_walk *walk)
>  {
>  	struct folio *folio;
>  	struct queue_pages *qp = walk->private;
> @@ -678,13 +679,14 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  			qp->nr_failed++;
>  		return;
>  	}
> -	folio = pmd_folio(pmdval);
> -	if (folio_is_zone_device(folio))
> -		return;
> -	if (is_huge_zero_folio(folio)) {
> -		walk->action = ACTION_CONTINUE;
> +	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
> +	if (!folio) {
> +		if (is_huge_zero_pmd(pmdval))
> +			walk->action = ACTION_CONTINUE;

Since you've already identified that this is a leaf PMD, is there really any
difference between setting walk->action to ACTION_CONTINUE or not?

There's nothing to descend to in the subtree here so either way you continue to
the next PMD entry don't you?

So there's a pmd_entry specified for both set of walk ops:

static const struct mm_walk_ops queue_pages_walk_ops = {
	.hugetlb_entry		= queue_folios_hugetlb,
	.pmd_entry		= queue_folios_pte_range,
	.test_walk		= queue_pages_test_walk,
	.walk_lock		= PGWALK_RDLOCK,
};

static const struct mm_walk_ops queue_pages_lock_vma_walk_ops = {
	.hugetlb_entry		= queue_folios_hugetlb,
	.pmd_entry		= queue_folios_pte_range,
	.test_walk		= queue_pages_test_walk,
	.walk_lock		= PGWALK_WRLOCK,
};

But no pte_entry or install_pte handlers.

Reading walk_pmd_range() in mm/pagewalk.c:

static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
			  struct mm_walk *walk)
{
	bool has_handler = ops->pte_entry;
	...
	bool has_install = ops->install_pte;
	...

	do {
again:
		walk->action = ACTION_SUBTREE;
		...
		if (ops->pmd_entry)
			err = ops->pmd_entry(pmd, addr, next, walk);
		if (err)
			break;

		if (walk->action == ACTION_AGAIN)
			goto again;
		if (walk->action == ACTION_CONTINUE)
			continue;

		if (!has_handler) { /* No handlers for lower page tables. */
			if (!has_install)
				continue; /* Nothing to do. */
			...
		}
	...
	} while (pmd++, addr = next, addr != end);
	...
}

It seems that setting ACTION_CONTINUE or not makes no difference.

This is really just a long way of saying maybe you could just do:

	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
	if (!folio)
		return;

? :)

>  		return;
>  	}
> +	if (folio_is_zone_device(folio))
> +		return;
>  	if (!queue_folio_required(folio, qp))
>  		return;
>  	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
> @@ -717,7 +719,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
>
>  	ptl = pmd_trans_huge_lock(pmd, vma);
>  	if (ptl) {
> -		queue_folios_pmd(pmd, walk);
> +		queue_folios_pmd(pmd, addr, walk);
>  		spin_unlock(ptl);
>  		goto out;
>  	}
> --
> 2.55.0
>

--
Cheers, Lorenzo

