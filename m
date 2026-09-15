Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F593C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525096B0088; Tue, 15 Sep 2026 00:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7146B008C; Tue, 15 Sep 2026 00:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3A66B0092; Tue, 15 Sep 2026 00:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7C16B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:49:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A04EE14031D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:49:13 +0000 (UTC)
X-FDA: 85214767386.28.933373D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E917340002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:49:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y1XOSA9m;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789447752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBi1oH0/CTNATCkjFwhK+8zaxvaVE7CGcZmLnTYGtxo=;
	b=xHcgeVgOYAljJQy9vpKcRxmjsR0T07T2ojwuFVq5o8NuqTJtoiw3WN8ptla/c7zajLN/qp
	lB7PogDM6LxB1m3k7Ccb71VnTSXDjgWCD/kmAJ7W83GnChnOtiJWmBVK6pfjzlqQDrOhgg
	mgriN61d0LJSWUN137Dxf3t7lwGUdds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789447752;
	b=26/dlBa9FgEI/tN/HHPZ+aaHLHgZ56OtsAEyMea1WttcQU2rKnwGgqw62Z94ogt2aYVeRA
	zIE0ug0p6ywLvVuSXlY+DAV8g8rhkqhhNBRd+a98wWA6ma8/TqmOg7NxGr5BFrCT5h3vWG
	iFRz6rY73QmiInVYyf3g6KC+lHto1GQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y1XOSA9m;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51EE86025F;
	Tue, 15 Sep 2026 04:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F641F000FF;
	Tue, 15 Sep 2026 04:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789447751;
	bh=SBi1oH0/CTNATCkjFwhK+8zaxvaVE7CGcZmLnTYGtxo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Y1XOSA9m0nN9zLzax/SfzWcFsuLnMJKkYnksyk08t120nLnejZYf5YU5lNLBJWkHB
	 eTboNh/c/oQJHhNFJBFoXaPY5X3tRDxtwiwMY94sW+i8jtMoCiWgsfQV82syPf1Fsd
	 o32hT4L6yqA8zPT1Dl1pVl80dSp+UXQmqVu8VcJ4=
Date: Mon, 14 Sep 2026 21:49:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 peterx@redhat.com, jgg@ziepe.ca, david@kernel.org, sashiko-bot
 <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] proc/task_mmu: handle special PMDs in clear_refs and
 pagemap
Message-Id: <20260914214910.a22cfcdc250bfbb6b14edaf8@linux-foundation.org>
In-Reply-To: <20260912122822.3348978-1-gourry@gourry.net>
References: <20260912122822.3348978-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E917340002
X-Stat-Signature: zguj9kc9mnbbnbq1brem66gdgsanc7nc
X-Rspam-User: 
X-HE-Tag: 1789447751-33443
X-HE-Meta: U2FsdGVkX19cSQHzsTg+d3WjRGl93SpfBPRUkMlFBCs2Jez3k1RnggdIuac+Ws4mZ4sUi9KhMoh0I2ABtB5147JnSk3/tp/+jScnINSz6wpVwHK8mEtE4zPsKgWPV0807UmaogeWCFNKBBsYR5kUV08D3WNSMShVqmb9LNbV1ABBD9opwJH0/Ic5uvzkQm/rrOx2x9S+D+aGYaWXPTadvoNhY/pydklqj5997xg1I+FcJPSIW58JZbeW8ukCQvB8UMJHPkxHkGtPe0fN91KROvWSrvJCYJQFh+jiYpEYOvzFOCMWxdq0B5+FdANDem1wdMJm/r+G/3JlEKHct3w2092iRiXLQyOjFPCsRt0pjx7pYzk2ypuGoEJIoCxvZFB5FulPoSEPadsu/hP5J2EZGK2uMm0PY+E7vc7wQlxHqaJUmJcJJqs6L/6CJLjXWGL+uXISHmQE8f5aM/kAX2HRVVxoGAhWwXUpBv0w4jB7nuRIN3Zic94ItYj+dMnorcEshKnYDIFtQy8HShh38uL9bZiAP38Wj5+OT91phcRCu98UlaeF+e1wUqKkP+cqC9KElVJzD1UQk5E7V0CYHFEEv9wzpgpP2BtpXEAyZPXNpuXyJCvcf6n84+Ts2jl6Eha14Dl3EbvA7g8aGNGy1dXSSlqKHTdIZAld6YuqJsCGYbo/OIq+Hi8Gwc9/orFlftvz8Gt0nmySV/+fjG0yoYFhyNiWe5koCQyzRnUFwhFdAHi4891oDD+93Bkw7VHwsLQf9HYQRPxdGlyVt/hbjGv2rOa9PNKziq/tJVk5JtCnmRbUzhVkhtNPUqz23HqPV3/io/qrf0bGdl1+8tpjpjioSIlUlmaFYZ6LD39jr9Gk5iInD1iBoq1HzEUHyuMzXYkDAN4XMjbpuE3TA66jB/yKxUc5He0OzsBiyovLO4cw1lgGPrgZNzwYBR/FdP9IlS8sg8nt0cBSmK7yvqFIzh2
 EHtgAadf
 7MvsnfvrHecjS/mx2uf6J2t643nYRBgmE4IucZ3CkmrIE/YguYvUWp8VTduUhwbGaSmLMfzP+lBnb31EqTpv2yzOLder5QIeG0gNj0r/uHn7knv9ni7UPDULQMqsdtuAFZCYMx9/ItWHZbEWLLrzL81/ULlZhcnUr0ZKAUKhJjkCnp5WUXyoU0Mq5ld6gdOC79B2Auo3F8jsUE+Qjw3eWGdmR7i9knJjiqTBbZQfB2UDmmz8e/2+WAf/vTnEtU0yM9cn6abzgr1exyGK2BIhXXUm6o8KO6PW7SjyFzUe5r0htHGu3IN5JgUHG4qZjswps8gUjVp0a09leV/fn3/uI9fDuPFEjzfQiM6bbTPnidYCla9eL8KuqRgXR4gloi5pF927J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 08:28:22 -0400 Gregory Price <gourry@gourry.net> wrote:

> mshv_vtl_low can install a special PMD from a PFN supplied in the mmap file
> offset.  That PFN need not have a memmap entry.  Reading /proc/PID/pagemap
> or writing /proc/PID/clear_refs for such a mapping oopses the kernel.
> 
> With a test driver mapping the PFN at the 1 TiB mark:
> 
>   echo 1 > /proc/self/clear_refs
> 
>   BUG: unable to handle page fault for address: fffffb5b80000008
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   RIP: 0010:clear_refs_pte_range+0xb1/0x1e0
>   Call Trace:
>    walk_pgd_range+0x50a/0xad0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_mm_unsafe+0x193/0x230
>    clear_refs_write+0x18e/0x3f0
> 
>   pread(pagemap_fd, buf, 512 * 8, addr / PAGE_SIZE * 8)
> 
>   BUG: unable to handle page fault for address: fffff57840000008
>   RIP: 0010:pagemap_pmd_range+0x3cf/0x6b0
>   Call Trace:
>    walk_pgd_range+0x50a/0xad0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_mm_unsafe+0x193/0x230
>    pagemap_read+0x1dc/0x350
> 
> clear_refs_pte_range() passes the PMD to pmd_folio(), while
> pagemap_pmd_range_thp() uses pmd_page() followed by page_folio().
> 
> Both paths assume the PFN has a struct page and dereference bad address.
> 
> Use vm_normal_folio_pmd() and vm_normal_page_pmd() so clear_refs skips
> folio operations and pagemap skips folio-derived flags for special PMDs.
> This matches the PTE paths, which already use vm_normal_folio() and
> vm_normal_page().
> 
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> Cc: <stable@vger.kernel.org> # v6.19+

Why cc:stable?  Is a crafted test driver the only way of hitting this?


> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1671,7 +1671,9 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
>  		if (!pmd_present(*pmd))
>  			goto out;
>  
> -		folio = pmd_folio(*pmd);
> +		folio = vm_normal_folio_pmd(vma, addr, *pmd);
> +		if (!folio)
> +			goto out;
>  
>  		/* Clear accessed and referenced bits. */
>  		pmdp_test_and_clear_young(vma, addr, pmd);
> @@ -1991,7 +1993,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>  		goto populate_pagemap;
>  
>  	if (pmd_present(pmd)) {
> -		page = pmd_page(pmd);
> +		page = vm_normal_page_pmd(vma, addr, pmd);
>  
>  		flags |= PM_PRESENT;
>  		if (pmd_soft_dirty(pmd))


