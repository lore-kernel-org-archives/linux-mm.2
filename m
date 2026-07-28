Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D3DC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 00:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0F16B007B; Mon, 27 Jul 2026 20:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5917F6B0088; Mon, 27 Jul 2026 20:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480C96B008A; Mon, 27 Jul 2026 20:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225C06B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:57:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CCA04027F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:57:08 +0000 (UTC)
X-FDA: 85036371336.01.3B38D8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6D29C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:57:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V++APQda;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785200227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XKvUBtNz8mAqieUy7X2gVA3uFyDYAi8JFETA7NGeYQ=;
	b=BGcVmiDvpBr3AAbwMk1wu//nuiCfiYVhXttNiSjn53STb1mmcFeWLA9O0fBPrSr3AeklUo
	yCbgB00Nl4Of7L7uKhdUIw5olrYAGsLsDH8AUQdz8ITmyZMc8DUOPihWwHsbcWmPOFgE0u
	n2gg+1iqdtRWSRWo5VPGrBWL4/mhFls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785200227;
	b=mkl5A7fkCnzJqZGv8tZ4QhhWVydJ6EEnFzIjfEtLA6DM1IvS1E9Aei29M/WJW6gH7KU01U
	0dYMYHybuV16vGQ1iDDw9hNwbnyIcCv7xksjeKK2dGrGR51lTwRAIs6h3nBMYVQjCsiNXi
	I+YkdJDiFtTI2zaiXPqKXUFDmn4UOwM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V++APQda;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BE12416E9;
	Tue, 28 Jul 2026 00:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F4C1F000E9;
	Tue, 28 Jul 2026 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785200225;
	bh=9XKvUBtNz8mAqieUy7X2gVA3uFyDYAi8JFETA7NGeYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V++APQdav59a96D19Bw6Q+BKElEnxWZXtnDS0ZWNXgt2ft1PMcLZYLfkE85fSRbpk
	 +tHp+5bqUDzoTZ4QBZY3lUItBQnMcwHEcu2Ii5rwe7rHBs8qZMJcu8XAjLz436egUb
	 Qg0UbksZCPLgM8IcUqWepEXgStmbMeeh/sj5ayqY=
Date: Mon, 27 Jul 2026 17:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Usama Arif <usamaarif642@gmail.com>, Shakeel
 Butt <shakeel.butt@linux.dev>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-Id: <20260727175704.0e4ccd4a6201435a6284d260@linux-foundation.org>
In-Reply-To: <20260726072935.3513996-1-souravpanda@google.com>
References: <20260726072935.3513996-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ekt5fhkposeax6sbaihycx5r74giijxx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6D29C0004
X-HE-Tag: 1785200226-10116
X-HE-Meta: U2FsdGVkX18rkh9iMSVjTJFEt6SFigEziFwXhA5wk4/CRgqkU2ZLFvSVD/k1aHm04Q4eMj2v5xr3m9d6O0+8q2wAAxw+EWIO7HyJimpJV2qcHCZ4ExtmZEm469p8b8VEy1Uybs4c5aEeN/ChwxB8Ms5v0OJFW6ut/VH9B/bH/JnHorFhX2KaJelzCZZBqqXpqk3HwZy9xL93zeDxe50P4Hj13XiCtmFzE75vZwUHrx55nS4rIHSo5UEeGpCnAdDvvQqJXsejcl5UNVKjJ8WDHCoYoxfuzeMNQAIuhaR/ArOHJi+gUXpkfwdJut/5yJwfSChGWfgeLVWuUvV+xbjyUZNN0sTptYT/IYqwncvofNCJ8aToSjsO2Lv9UhS72wN/7532o1cPJpNfq1FFqz8Kn1okJQTwSABLwRlS8X//79HR9K6dWRekKFpvECD1+MjPzRMSmQAaEbDX5E2lFloYs2sN/pqHO52mTqlIOIAIZ9iqTvih349a2i1/ZdscAI9nYXXJBckZxYdtPdwjQQek98kqU7Z1PG7JLb52VBJnNfZISj3YzSFGjW5x8Fyh1YPlFA2fbJcfSolO3aSkxmc4n/HeuRBb8010+9lt2uWKV0SEWcegsMXoYxfOhF9bQe6jf7coq5D26d+vfxleibzVF/W6KmKv6pHH3KQ0qjtcPLYxD0JhciOFDuPGcB7t2vd/Rcl6odlGQu5zV00Q8Zj3y03o/aEu4NSRQN6J3DfYxhoqPk4tIMGivc2KN8UWpTN0VEtjrQ5CQken3NRWLM6rCEAicnHP8n9tkzmWG//xJ3EM8tbgUoUHkVQ4XUqwWj8dtg+bxxcHJOcGHRPl4XZ4rtL5yYb5wjiZtI1kKxQhNKYGXA5ApXGs2bAqRozyL+Uqo41MUD9U7iFrKVx9vCqUDamj4KuSltiJcaaNSs0sPlKP7B3BRbvsOqJmWosDJl9Dw8GMLPOLIr2bSVH1Yrh
 78TLJTwW
 tKz3wxpc8PXx5t2SO0qBkowQe7ZbjcortHYumtl9ZPGJVG8BYY+HDVfIlxsENzHmUQCfVlCsFFEANJZ/u14saxeyAx6B4MrYo1vYJu5iZ6DwUhXHNo+LSShMfbNf4w1syK5eORpyHSXSjbYH/2KdsTiUt5V6jVeyZ4vYp6gg+i7iAOD5ltVvOPs3NTyJSuRRXE9lY858QxlvA/bdnvyPdIpnQdOylep8mLoeZII07Yu7is46QyImqGt3CephHPozsT5jfzQ13Vsh16+rPsZuE0pBwtH+xL20Ivhny8O9AWx3XW6x2w8KBMesTyYuCq89u4Ydc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic.
> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> back to any node with memory, keeping behavior consistent with
> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> 
> >From a userspace perspective, this bug allows an unprivileged user to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.
> 
> This can be reproduced by booting a VM with two NUMA nodes, restricting
> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> hugepagesz=1G hugepages=0), and running a program that allocates a
> 1GB hugepage area without reserving, restricts allocation to Node 0
> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> 
>   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>   unsigned long nodemask = 1; /* Node 0 */
>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>         sizeof(nodemask) * 8, 0);
>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> 
> This results in a NULL pointer dereference:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>   Call Trace:
>    <TASK>
>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>    alloc_surplus_hugetlb_folio+0x6d/0x100
>    alloc_hugetlb_folio+0x3c5/0x660
>    hugetlb_no_page+0x3d9/0x650

Thanks.  I'll queue this as a hotfix while we await review.

> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")

It's a good idea to cc the people who were involved in the to-be-fixed
patch - Author and Reviewers.

>
> ...
>
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>  	if (!hugetlb_cma_size)
>  		return NULL;
>  
> -	if (hugetlb_cma[nid])
> +	if (!nodemask)
> +		nodemask = &node_states[N_MEMORY];
> +
> +	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>  		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>  
>  	if (!page && !(gfp_mask & __GFP_THISNODE)) {
> -- 
> 2.55.0

