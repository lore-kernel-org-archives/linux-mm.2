Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04110C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09A56B008C; Fri, 21 Aug 2026 04:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB106B009D; Fri, 21 Aug 2026 04:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1126B00A0; Fri, 21 Aug 2026 04:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0CFF6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:03:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DAEA1403AB
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:03:25 +0000 (UTC)
X-FDA: 85124536770.18.D0802CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B4134000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:03:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYXyUBvH;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787299403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl/eqcse8q01TGfMWGAYjBFpqsEhjPokKNvvi+tLs1Y=;
	b=Hth2rSl/Zgu8Iumwg9vm/O/lLb3PxrMbQpDuPQ77EwPB+pXDyHrybD9D1BwJMoT0gj4WVl
	7WjwpynHq38WL8R0xw0UZuvYuyXiF6C27MVT16xsxJOIFyP92Wa+jIEVX9B8VE8+hQH5Kd
	1BHuNcYpve/GV1wN8e0TJiKPuLoC/yk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787299403;
	b=LeNgt1rD0Qv7/qMY0fvZeKNl0MEFlN4fTb9pU6H4E9Fu/PHplrhwSoVpoS44EQG3Yd+/nR
	tkYvN+/KltSEC59TjVHSXpZDv4uPseu1kCQ1f+y5yT7pkVQRWQW2577dPsnviKjenFFqhX
	J8KWO/3PUEE+oc7e7v56wE0mysrPgM8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYXyUBvH;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBCA160A77;
	Fri, 21 Aug 2026 08:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DAC1F000E9;
	Fri, 21 Aug 2026 08:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787299402;
	bh=Xl/eqcse8q01TGfMWGAYjBFpqsEhjPokKNvvi+tLs1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aYXyUBvHuWjxr5r5eke88584RfNeQiUv+Z11RSeOyKCJggIp2nOOOkrdSWdQub4Oo
	 FEmsOg1wM0tLHoJClvfXiLGGTuPCPmlyT0ak6hbN/HUGcC409TYNT1hUMrU7+3CkbK
	 oEV7YcB8aSyGuYu9ujOHDN/hxTNq20RrzZ+2vDp1M62m5veKaUf9wVdMhzcm9D/fHt
	 IipPH+TMQDy/DeS/BGCKZ9euJ3ugymN70cPWTNl8Y3qBGrrhRBGgt7ltQqma7NKJGx
	 BzbrDqjhhZyfMSZVPoqVEKP1dZdaVhqgwdNlgait2VYyzRfa34YE7PS0dhPzQDrcKf
	 lG8NCr2eeNcIQ==
Date: Fri, 21 Aug 2026 09:03:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Saravanan D <saravanand@crusoe.ai>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: allow huge pfnmaps regardless of THP mode
Message-ID: <aogCjEc9uyMjFP6S@gremlin>
References: <20260821070520.25759-1-saravanand@crusoe.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821070520.25759-1-saravanand@crusoe.ai>
X-Rspam-User: 
X-Stat-Signature: eq4skaaaaa3eqf6payk7q3jjtn4jtp7w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B4134000C
X-HE-Tag: 1787299403-777214
X-HE-Meta: U2FsdGVkX1966X+HJwi1hZbICKeOtIPYBD+p+QWrGl9oy9CPEHLnaz69Ie33amYxdvJan4fNk0rmoj5MXNYmZA7+il9Yq7rnLVTUk2lcxh4tJKVr0Sin4KmTK0OkDSO08KY0gIGQkZ8Mh8BCsTYWt3lc9MkIKkeOuxjrGoo2xie9X6oMHd5VCcfrdMhyqpHGW0ekPu/JL8Y4BOuxpXGwvkZCIZX8hy3+SahDpubg4IpYf07KR9t9tTNU7ztt3fvutqxGuKkE0wCARzbHLo0loZYqTHLJX0fQm7SrzHmTn7vhhSbeb1m5ctvrAeBYqe4Plldj9ejFY0vsLGUUxSkfna4ZXrzqfrLnzxZPYT9iMreaG/SUd5Jw6aw5qRaYMEfDDzichPvt/uWNZrMknUQlc9QDYDaL/UFQD6uOUiPfFYJyflDF/B2mPBGQF9BKyXolYJFuMHXqWILG+4p36ezYDK7jCO8VKMJUfqDQNAG/a7GeJE/7ej1bVMk8oUuGKo8dsNkXL9jKwmjN7FD/DOk/nzWqnlc0WT887OkUgCAk9p/KPI9b2lSH83TR9FU8K1g4urCnCi99FvReQA+Qm745xm4hM9xMaLi4oqi1bIZ8JALy/Zm3sbOVxwQXTW4uSFficeyCPMu+cZWZwDHOoqsZB/hhLfOriotAwFvTL6gc7IeRyMKgacxatTnqX0dpU0hEItKilqYHQK96vyikUkchSXa9QgVViCj2z8dEsEq8PCPUUxHOzhE1nJtXG0oaGmbzofjjqapJBseXjc8A/CQq9KAnWvUTrkBYvO1tE6PmkAiCDeVJ4ylL2XRbt49r9PfqMSbeHVzbB9YO9ybo4MhG7GRx6SZFQNp+b3hWjLe6gN7VzkXlvHmLQWEusdFVNgkii46wBfXy9+bUjTEQGMR9Jw3KzVUFWhgDOXpJv+oYkMc0Ch5n942KC2VVSOAbjdLhwih6WteOxER4mcY7Yao
 Z53DXhus
 TNf51gqDmlaCanAhGucFf3NSAJWLjtXYQQTz71qhjjbL/iJWpZhkh5pX0WXxfaBuKlRulIdNdfOImp1TD21mdqg5YZvve1AuL2OhgUv+XG7bnvWmk6964mAlq9V6g/T4zgQiVob2zmrux7K963a8v4G056wodCSWJfmh5D8XsNjh3S6pzRypUsC+iDSM2CiCecDhYEpMWoeSoMu1+9QKR4V4pTR5tMrBlgxQRvhfdc7SIwg6BrfewZXYd8oesc0uy7lM5hMdNl5sDbFwa0IZ5qyitZn5uYC6nJvUXyCSmpSTOLzawIGd3lq3X4/NLFTRiaUdt2Bx0d2D+DG89khy8VEen+rfeUQHvdpH252hhQosTHjt8uirjIxMV4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nope.

On Fri, Aug 21, 2026 at 12:05:20AM -0700, Saravanan D wrote:
> The THP mode check in __thp_vma_allowable_orders() runs before the
> clause that trusts huge_fault() handlers, so huge pfnmaps only
> materialize when THP is set to "always". The THP modes exist to
> limit the memory and khugepaged costs of transparent hugepages.
> Special mappings are backed by pfns instead of THP folios and
> khugepaged never scans them, so those costs do not apply and we
> can exempt special mappings from the mode check. This also makes
> THPeligible in smaps report 1 for such mappings.
>
> This matters for VFIO device passthrough on distributions where
> the default THP mode is "madvise". Mapping a 128 GiB GPU BAR
> through VFIO_IOMMU_MAP_DMA costs 33.5 million order 0 faults and
> 20.7 seconds when the mode denies huge pfnmaps. With huge pfnmaps
> allowed, the same mapping takes 128 PUD faults and 0.4 seconds.
>
> Signed-off-by: Saravanan D <saravanand@crusoe.ai>

This seems like AI slop. We don't want it, thanks.

Read https://docs.kernel.org/process/coding-assistants.html and
https://docs.kernel.org/process/generated-content.html and follow kernel
guidelines please.

In any case if you'd taken 5 minutes to search the mailing list you'd see
this was:

a. Already submitted (so your patch reads like plagiarism).
b. Already rejected in favour of me doing an actually sensible solution.

https://lore.kernel.org/linux-mm/anL-NZkNMSSxN0YN@lucifer/

> ---
>  mm/huge_memory.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd22..bc61b8020af6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -193,9 +193,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (!vma_is_anonymous(vma)) {
>  		/*
>  		 * Enforce THP collapse requirements as necessary. Anonymous vmas
> -		 * were already handled in thp_vma_allowable_orders().
> +		 * were already handled in thp_vma_allowable_orders(). Special
> +		 * mappings have no THP costs and are exempt.
>  		 */
> -		if (!forced_collapse &&
> +		if (!forced_collapse && !vma_is_special_huge(vma) &&
>  		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>  						    !hugepage_global_always())))
>  			return 0;
>
> base-commit: a032d41a86cb82a747bc14d9c82b3e153a9a9ab7
> --
> 2.53.0
>

--
Cheers, Lorenzo

