Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836F9F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3C06B00A2; Mon, 13 Apr 2026 14:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83DA6B00A3; Mon, 13 Apr 2026 14:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974016B00A4; Mon, 13 Apr 2026 14:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 839516B00A2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:41:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BFD9B7497
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:41:29 +0000 (UTC)
X-FDA: 84654400698.04.260E579
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E0E9180008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:41:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYUiTIEB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776105687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiEX8vjXSz/sh85xNdxBgd8SRdc3RYTujnGNxoxRGJs=;
	b=qxxY5AoGdinGM1xvPYi5wL47VYaBi4QypDlz5HDQNQJTzgypUHJWPz0SPwfxCYQwu/gGNE
	zBHOmi0knc77A5ihplTLlAJzN/bH8QYVvXjT6K1fU2I50oW0r7ccfNUQ69Pem2iCY599kX
	afLVhBJHBfsVWC7JtUGGfWGAk+hkVaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776105687; a=rsa-sha256;
	cv=none;
	b=vOKCUrBrnpk3behbL12r80g2gJOuPgM5SPxiDkaYcj1K3rNrhdr1elMR5Zh4UWvbVkt1oP
	8WmwzgCFtawkxaJpNb2BiJ1FakpDWqt0m7e+oarB5mCV1D3dFYbpBk7TFd/wI8NVzlm7+P
	nie9EJ0cS1GomsY9M7d1i0HqavdfEfU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYUiTIEB;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B7A54017D;
	Mon, 13 Apr 2026 18:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52627C2BCAF;
	Mon, 13 Apr 2026 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776105686;
	bh=Ag34EiRSRProjSszPBmIGU7K92Xfr0e+QDVz287fZs8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RYUiTIEBiWUn3y/EkLaQ+B6or6WPDAJLf1CGVxYVwTegeS8M6EoDmczfXWKz0ZXOz
	 0+9etjUpPxVxm6h1D6hH6ELi0BENK6eMTe+EfabF0ADKvKCW9kJIwUAjXqMsEv/K1m
	 o589wnQnYobBXyMAFP4ggd9Xoa1oeu6Bm2Di8fpJQCKBQcvyZ/gKGIwtidfpEQA17O
	 3zXGd2OlwjNvDVYdCbwlRlVWXcWTPStWTQnnpDld2QBNtqFDSk7x+JetUtJL/wwPVZ
	 y3i5WrOphiKj9EZ/Ag3DqRTX/GyJaTBe+tkAp/xIQ//2KXChkz1ph2H3wZRDkubPFS
	 1HIUjTKc95cwQ==
Message-ID: <2b51659e-5527-4e15-a0a8-41f30f589d07@kernel.org>
Date: Mon, 13 Apr 2026 20:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/49] mm/sparse: fix vmemmap page accounting for HVOed
 DAX
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260405125240.2558577-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E0E9180008
X-Stat-Signature: 8wrktt79buttgsyt9sygdbxduo9kgf9o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776105687-801125
X-HE-Meta: U2FsdGVkX1+7jX3e8uf4iXYSORfyW9XU1cx2ZzxuDbm4JcbER95+fikynjF7b6ViF+K6HYCwBHxti97FAAGIt6bVk2VuxQHzcKcw3SVFFFKZM9araO2QeaWq+U+YGT6eiWnz84boj41HYuKGr4FtEPgJHskHH7KI2o4+kbqzqPIDoKvIJVyeGxkNc0UappvpoNwTQf19HsuZQYbiS0nqbYCdOZVjkLy8ZYw7inj0HlNC/9QyRYEVYalA8dHYlZ35mDXioU9tqyRwzQmb0pArkQIo/anfQNDA1tsfMOtPbbO9pF5P6p2YorlOX3DnLIAriiDSb5i/r0GybROKkwcNBSNk/qqXdIOXCmbTBCWkT0OtxZ+Im9Jcr/O4IhOy7yS4L0yjDXex2st9fxO5QKaAXqOzQ6jSUMWIH3k4NkMl5LoMLHyRbgA6kYz6LZ4x3yzWJLY26sf8Or0UZoar4ECz4ygOlwJFWWcuAO7inO/AeEnAwaiTjlzd07qNVnbCeoONLmvH29mLzPMeXoE4XzT0CFzM/oEVClxK3UJubREb11AHnQ/53N08pwl/XKbJTJTndb5OC2pl8CciUb3VWBWNvzU9eo5k3l+m/f0z0C68fkdAof2Sg9N1DNNsCaP2SQwzvdZ+7AVPOayZTICiepz0dpkRT9ih8bPAF9Yomr1cX34hThiBkb2mLXGBhI5IhQPdDQUQhYW33y73viPbt9r30DyxV8JHHSzraXCOIxeV/ffS3gGa4rv8t2rH+qaCKO7XyvD8d2aAC/LRLOQZZcpywYlMt9BQh1VPD1J6G2dVi1shXkSkgmvj0I/eSVaaC6UJS92Pwuof3SjhGPFPMO+GeLEA2XU56Jfd0dsk4FJN6VOtRnzTgn9tmOWivt3gg01SNqDacQ6HPsvxXrbb1ZrWYrfJcGI98Zn0WduMUsgOzuxZPT88jTBwS3NJqYK34jjRZH3kxIolPzXHOJ9Kv8x
 U/9UrMTH
 x1YbsynofFPR9mBH2Yxhutno/sVM5q+1Tx8x2zUswMFa5XUv9OjLnt3/cE4Y46oPULqbmOu0EGzFc7lIoHgHkEwrZ7vB3mdsdQ6MFle8xocvI/g8bl5H7G/eAbI6l8zA4fSZ1EXsG54BJyvqJvDs+MSQX/+jkGQnlAj73im+UQYc4wa/i/UwJ48Zwr9KSuhmnr2WoELJueDv0kCBhwELQR6eSFcDkCDpmYzqoJhttMRZIKPBAiwgGu11/ZVmX0Sm+Fkv5MexM+QHQBY4OQrViaKPgk6uczhGvrCWA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 14:51, Muchun Song wrote:
> When HVO is enabled for DAX, the vmemmap page accounting is wrong since
> it only accounts for non-HVO case.
> 
> Fix the accounting by introducing section_vmemmap_pages() that returns
> the exact number of vmemmap pages needed for the given pfn range.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/sparse-vmemmap.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 7aa9a97498eb..0ef96b1afbcc 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -724,6 +724,27 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
>  	return rc;
>  }
>  
> +static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +					   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	unsigned long pages_per_compound = 1L << order;
> +
> +	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
> +	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
> +
> +	if (!vmemmap_can_optimize(altmap, pgmap))
> +		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
> +
> +	if (order < PFN_SECTION_SHIFT)
> +		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
> +
> +	if (IS_ALIGNED(pfn, pages_per_compound))
> +		return VMEMMAP_RESERVE_NR;

This makes me wonder whether that is really the right place to update
the counter. Can't we update the counter where we actually allocate/free
the pages, so we don't have to re-calculate that?

-- 
Cheers,

David

