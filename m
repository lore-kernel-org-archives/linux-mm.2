Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FB7CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C996B008C; Thu, 15 Oct 2026 04:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD6A6B0092; Thu, 15 Oct 2026 04:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B138A6B0095; Thu, 15 Oct 2026 04:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D94F6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:10:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12A721607AE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:10:15 +0000 (UTC)
X-FDA: 85324137990.15.B14996C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 737ED1A0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:10:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLA1R6w7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792051813;
	b=QNe45nUUysmPPHwwFx7/jLxM7tuNvXQR1quE6JOsqF6IW7WwLsVa0hu2M94ifSbs5kVp7h
	07Q/dRrux8koigOwtFZu34p5PL5lU4cOrBlwyPN3qAxyNKqQlX7UnWByIYmJ0J2jVMCHk4
	dt87JxSd1nxA6h5COnnnabcps878B60=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLA1R6w7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792051813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWANQrIBt+o5Te9K+Cx4q+iilLxoAqyqlNJJibWJAUw=;
	b=s5iHlcdSiddxgSN6KmZC+328xSYrBFUUFscB76k1dHyDwAC3bTaNuaeBo5pyJNo5HddZoV
	UhqStpz30l3hhM+nGkjrGYpA3AppvEHjKRYBuluDbxL9bkjV9B4dXOTF0XmOnAM0Zc5fhQ
	MjSxvvxhzA2ElAOiDal89096gAI6rbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 393496022A;
	Thu, 15 Oct 2026 08:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FBD1F000C4;
	Thu, 15 Oct 2026 08:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792051811;
	bh=kWANQrIBt+o5Te9K+Cx4q+iilLxoAqyqlNJJibWJAUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bLA1R6w7ZavorYN62P5qil0DosQzk1pbJRNUM6tiRIoWrGtDWk6W5nD0SalKwKr2/
	 ms/ID6/ryqzAt6lnJLkqufJHlmor4EDZogFhelj4cNRSxidzpBoCFF0Tz9zFmHkG/p
	 Fk0wGna58goiPOaWYuA8vd3LNlkp2keP3e6zQcW9NMXxGdiSIQchqDiwxNhR1vlWgX
	 5d7gfRyNhMYabni2VHceeqQqYImFVQSGkk3+yH+0VSc1YLQcc54U9ebvNg3nDQUiso
	 nM0ILsn1mTqtAytkcdiI5dEFvU0trYHQm4zDMFZR79Y208gbanKandvk/RfyjfqVkp
	 N8d/u8cdYRjcg==
Date: Thu, 15 Oct 2026 11:10:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Arnav Kansal <rnv@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Rohan Kumar <rohakum@google.com>
Subject: Re: [PATCH] mm/execmem: only free ROX cache vm_struct when fully
 unused
Message-ID: <atCKXeWnVAWvhSn0@kernel.org>
References: <20261014233058.1410692-1-rnv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014233058.1410692-1-rnv@google.com>
X-Stat-Signature: sirkbisjgu8pojee98i9rje6k71sz7jn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 737ED1A0003
X-HE-Tag: 1792051813-698087
X-HE-Meta: U2FsdGVkX1+K2gBecGBIGSoJb45W2gz45kGg2DPOEFwS1Y0zMIfaiu/g2Jvboks7qg2QYldicteoT+IUvZfBC6OI9DxmLC4j/MSIfrsup+s2vbObnaUxUcnOmcZTfkOzUBW+7SVeNayOm9KJUuEF35GicJrMYnRoSLI5t/WAw2BBXTpnU+TwrIvnlaPSrKkGSrDUIW9ZdKJX2TW60H6yHd5OCoK+iqTl7U4AWMduZ1ehUJJxO3movS69wwHLeujGktgvHBNpz94e/kLH87EaSxKHcD5tlpfKGNnqfMVuaD0N73C58ieaKgTuV9GwvCW3NBnMrUPpgQ7oBntJqYOveI7TwRIda17l4fri6HzP/DMhjkem2tFEvz39QBeiXMcee4WwAN5b136W0jJo9XJjCeFDQOAWtGmLAfPOjKp94Qj/E/psCmTQbq07mAJbgonV7hDELGYW93+wN5sXKZ9kBtJRD02PdYmUtkw29f+zOvd4pC07Sa8YfpmMbfS7dCr1Vw51m6LJEEt6J+4jzVjHd+hX3HXzzMxIxEtjThXQ0HUoqba7e2fMcjiotCW+gSRF9d2U4oWi41IQVU6HQkQaYOnsHQgyP2rL2rMMJ81WfRyG7nPGlRXVo+GNRSuDLN0I8BMwWBUkBxo1zHfXVvPm0turoKfYeU4rIxTAvIUQDf9w6An8eAa0Iqdji8bYTEE2G2dcmB2AynPzcNv/S9i9e3mRKziwvGYQ5auROsMCuy0gd9t6DLGTYrbMCtYWF4fSeqTq+SqLC4eJ9h0821ELBmvQfecykkhlNKrcKVvQvy/cMOJq+itkF7s/MAUxoXR/SIvZg//jqRBbW6LiIxd4CYhIFxc28N1eTgT4Or3gSLiH83EDc6EScp3zM7H4Ar5PYuPltJbGSDZp60MWZh6PUzIhB5YQ/lL4+dSAbbhupkt8zf/Mey+ZQpv8xFo58RnK5kKtSIi9gUsRXpAv8Dz
 8kbfirm8
 uIW4WwyrJ59SwAJh7hZ+DW8hhPHTvGsKi2lD0O2XpMixmJYHD+k5oVwJsPdTF9kHZEPZddgVS8sKyi6cKzlyokiuMU7N+QP3yLdpyECqjEiHuhVsJqb7aOPFlmG6PIaqr67uB02tZyUKHJYquyoTOSXbr1eiuQBwyDhSdKjlg5BcdVDIUfk4o8pizEIFA9ryaBRYhE7I9m/anN81kuQIZvgMK/eyBXaJHrCgq1ywoUra/nH6X+IUMQVhlo4JmjF4EDzCrJHFI98Pcu5GSF2fOWW7NCwIUchWY+qv/CN8iJ5X05Pv8VV8j5CMIUzgm4Um4rUj4eZiWn+iYEkBYW4CkV+V6EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 04:30:58PM -0700, Arnav Kansal wrote:
> execmem_cache_clean() currently uses:
> 
>     IS_ALIGNED(size, PMD_SIZE) && IS_ALIGNED(mas.index, PMD_SIZE)

This is not the case anymore:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/mm/execmem.c?id=569db54d8b7a4ec463a62c444de0d6f5f10e9dc1
 
> as a proxy to determine whether a free range in execmem_cache.free_areas
> spans an entire unused vm_struct that can be returned to vmalloc.
> 
> This heuristic is broken in both directions:
> 
> 1. Premature vfree() of multi-PMD vm_structs (Use-After-Free):
>    When execmem_cache_populate_alloc() services a request larger than
>    PMD_SIZE (for example, a module with > 6 MiB of .text),
>    alloc_size = round_up(size, PMD_SIZE) creates a single multi-PMD
>    vm_struct (e.g., 8 MiB) whose remaining tail space is handed out to
>    subsequent module allocations (e.g., kvm.ko). When a module inside
>    that vm_struct unloads and leaves a PMD_SIZE-aligned free sub-range
>    (such as a 2 MiB or 4 MiB chunk at the start of the 8 MiB vm_struct),
>    execmem_cache_clean() passes the IS_ALIGNED() check and calls
>    vfree(area), which unmaps and frees the entire enclosing multi-PMD
>    vm_struct while sibling modules are still live:
> 
>      BUG: unable to handle page fault for address: ffffffffc07dc030
>      #PF: supervisor instruction fetch in kernel mode
>      #PF: error_code(0x0010) - not-present page
>      PGD 2c33067 P4D 2c33067 PUD 2c35067 PMD 0
>      Oops: Oops: 0010 [#1] SMP NOPTI
>      RIP: 0010:dummy_exit+0x0/0xfd0 [tailm]
> 
> 2. Failure to reclaim fallback vm_structs:
>    After commit 3bd4e0ac61b2 ("execmem: add fallback for failures in
>    vmalloc(VM_ALLOW_HUGE_VMAP)") and commit 4afb85f5e359 ("mm: remove
>    PMD alignment constraint in execmem_vmalloc()"), ROX cache vm_structs
>    allocated via the base-page or exact-size fallback paths are only
>    PAGE_SIZE-aligned in address and/or size, so they never satisfy the
>    PMD_SIZE alignment check even when completely unused.
> 
> Because vmalloc allocations include a trailing guard page, separate
> vm_struct allocations can never coalesce into a single contiguous entry
> in execmem_cache.free_areas. Replace the PMD_SIZE alignment check with
> an explicit check that the free range starts at vm->addr and spans the
> entire get_vm_area_size(vm).
> 
> Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Co-developed-by: Rohan Kumar <rohakum@google.com>
> Signed-off-by: Rohan Kumar <rohakum@google.com>
> Signed-off-by: Arnav Kansal <rnv@google.com>
> ---
>  mm/execmem.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 74a178a87e75..3a1da0498fe2 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -166,11 +166,9 @@ static void execmem_cache_clean(struct work_struct *work)
>  	mutex_lock(mutex);
>  	mas_for_each(&mas, area, ULONG_MAX) {
>  		size_t size = mas_range_len(&mas);
> +		struct vm_struct *vm = find_vm_area(area);
>  
> -		if (IS_ALIGNED(size, PMD_SIZE) &&
> -		    IS_ALIGNED(mas.index, PMD_SIZE)) {
> -			struct vm_struct *vm = find_vm_area(area);
> -
> +		if (vm->addr == area && get_vm_area_size(vm) == size) {
>  			execmem_set_direct_map_valid(vm, true);
>  			mas_store_gfp(&mas, NULL, GFP_KERNEL);
>  			vfree(area);
> -- 
> 2.47.0

-- 
Sincerely yours,
Mike.

