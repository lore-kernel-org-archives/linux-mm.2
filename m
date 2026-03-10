Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0F2FCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2612D6B008A; Tue, 10 Mar 2026 04:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BB26B008C; Tue, 10 Mar 2026 04:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C146B0092; Tue, 10 Mar 2026 04:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0087D6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:19:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA8861404C7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:19:32 +0000 (UTC)
X-FDA: 84529454184.13.89D85E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3607414000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:19:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LPN5XdK4;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773130771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUybclS64PKWFufgF6aQ8JgaWSAYT+y02bRA5IUp4WA=;
	b=tdEQS5sHXkhVIayFm1rcQ0B0m9YDZt5VKXJ/kTzVcMIcU6egdhySnILyP5vFXj1cU4oBPt
	YiUH7aGgMxuMXB65TegRkLJHdAKju7PmpUrirI6iVk2m8Re1EgdG/LRIbZF4RYrstPyRQC
	cafIXYf//lV6AEh0zIk92nvDm4OwAv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773130771; a=rsa-sha256;
	cv=none;
	b=ixkH6/rGuT3+cvyaoqrBAO/AnSKOp/yKr8gtCVcff31/YHirwaHLi82gDucyI9COwVYfIv
	apudYZhOSlNyUq/UhsTgHwV5mCJw9LYfIrj1S3pkRyCMmvEH6RM/rW+Py7LD0qd+wtcY8H
	loTyPZYmR6VX15oSvISwmQ1jNaqxK7M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LPN5XdK4;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D13260054;
	Tue, 10 Mar 2026 08:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A169C19423;
	Tue, 10 Mar 2026 08:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773130770;
	bh=8WZa6uKoHgCJog3B3JTAsJwy5aNoFExhEXTWApc7brM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LPN5XdK4RD/9ann95QRaRMH8iwCmfE4xqsiUbUaSIFW1gOQAi3jvkAPFy9Ne/gex0
	 DLq3806t9o1ar6v61LMZvyQHR3hlaHI531/DnVgdpM8gBvebmMS1SSs+MmtDFG8f9N
	 Z4VyTuW22OeWZX3cNF5LJ3Vi+wmPMYHZUGl/hvW4fBr1moDmQjsf1ioBivxDYGR74a
	 vyLnb4EsN2jQDcPqNOXaOBp3xiaMmZtv74phnPa3SzZrYDty8Ptd3siyGMFLg/3awr
	 HSMV8IVunt+MYsHoKG/Yb37zdRfQwhqtarfQlqv1BrvHDRz/zymKfcNiS8TGUN5r9F
	 /8h4M49rEjnhg==
Date: Tue, 10 Mar 2026 08:19:20 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 3/9] mm/rmap: refactor lazyfree unmap commit path to
 commit_ttu_lazyfree_folio()
Message-ID: <3915e3bc-c390-44bc-a463-bdd687598284@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-4-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-4-dev.jain@arm.com>
X-Rspam-User: 
X-Stat-Signature: 5pjtwi8mxhgs89tqiiuyjx8t8mzeaez1
X-Rspamd-Queue-Id: 3607414000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773130771-916926
X-HE-Meta: U2FsdGVkX19g5UVrwmS9KwXITGZkpYbRywve/b6Oozmq3lhjUEg/I3tDDQN7YNXWjXzKhXethXnzp6HphYpWFeWL4uohzp1vMkxRfqKx4UQgcrwuN1C/wUi7yv1dzpfTc7awyFrqsw1q0t91fh9nPbro6Jtps4qIvKe1u/Wcv703Gu03X8bAigMKtGL5Z4r7MosX5mAW+awH/ZbhL108nwzvV62FgRU781eHR+jEtThwi4nPFHvLll+lOshnFV60iYcFJilptqFjdc4Rxy8wbt2u4qLAHMyYETWa4QM/Edx3CGhHaDwlbEPxUOqQX90fmjiCxuWeVRLAAqgSIupx4vroOyZGsTkDq/L/FiHt46SZePjAYrcG17mmbYZcz2Ug/MEzg+5raUWkm/Z6aFpt5Gz6wJZgCHwjelJGPSnUzJtGrIIuXvhwk66Du72coX9OlUFrWVuCOBnQzr74sNYiAUdlbO7RcrQS3Htds/lZIP2pEeE69a2l32pOIrG6K9jUmg40Jl0UaeBLTpCSNlqPtsspwHvwPPicY5C0xDoKBj+Voe1igb6lwf42eoFeFYgMuJbM8PF5V8vNAu+Z9exSM0oXvZ6XW8g3JY3Rj7tDcrx906dl8b5NBE5eezs9zCtCnV8Rb09JOsRYx48RYL1DNW7VhGW8+SNP7IaQ+VVCcWZxNJV0rbL9kuJ+6FpEr8ppX1XRHOgBFcpehBKdSbM1+Adlm2bX5FLuAsplohuOSvzSAP1G3rVLeixWpEiuvxAUf2pbEMQe52BQM/Ky9PLDopAb0koBOkLS+QF2YKyhXbt8AmjUpMGJFZVmVNNs7aE3hdYLfZ+SRcmaNBxKQ+FlLJg/sEySxX1r6Xh4xIBJivQ2Q8bNw7vEnogLtl0lwo1ekVcwCPd5KckxqaQo175gSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:07PM +0530, Dev Jain wrote:
> Clean up the code by refactoring the post-pte-clearing path of lazyfree
> folio unmapping, into commit_ttu_lazyfree_folio().
>
> No functional change is intended.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

This is a good idea, and we need more refactoring like this in the rmap code,
but comments/nits below.

> ---
>  mm/rmap.c | 93 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 54 insertions(+), 39 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1fa020edd954a..a61978141ee3f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1966,6 +1966,57 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>
> +static inline int commit_ttu_lazyfree_folio(struct vm_area_struct *vma,

Strange name, maybe lazyfree_range()? Not sure what ttu has to do with
anything...

> +		struct folio *folio, unsigned long address, pte_t *ptep,
> +		pte_t pteval, long nr_pages)

That long nr_pages is really grating now...

> +{

Come on Dev, it's 2026, why on earth are you returning an integer and not a
bool?

Also it would make sense for this to return false if something breaks, otherwise
true.

> +	struct mm_struct *mm = vma->vm_mm;
> +	int ref_count, map_count;
> +
> +	/*
> +	 * Synchronize with gup_pte_range():
> +	 * - clear PTE; barrier; read refcount
> +	 * - inc refcount; barrier; read PTE
> +	 */
> +	smp_mb();
> +
> +	ref_count = folio_ref_count(folio);
> +	map_count = folio_mapcount(folio);
> +
> +	/*
> +	 * Order reads for page refcount and dirty flag
> +	 * (see comments in __remove_mapping()).
> +	 */
> +	smp_rmb();
> +
> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> +		/*
> +		 * redirtied either using the page table or a previously
> +		 * obtained GUP reference.
> +		 */
> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> +		folio_set_swapbacked(folio);
> +		return 1;
> +	}
> +
> +	if (ref_count != 1 + map_count) {
> +		/*
> +		 * Additional reference. Could be a GUP reference or any
> +		 * speculative reference. GUP users must mark the folio
> +		 * dirty if there was a modification. This folio cannot be
> +		 * reclaimed right now either way, so act just like nothing
> +		 * happened.
> +		 * We'll come back here later and detect if the folio was
> +		 * dirtied when the additional reference is gone.
> +		 */
> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> +		return 1;
> +	}
> +
> +	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> +	return 0;
> +}
> +
>  /*
>   * @arg: enum ttu_flags will be passed to this argument
>   */
> @@ -2227,46 +2278,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>
>  			/* MADV_FREE page check */
>  			if (!folio_test_swapbacked(folio)) {
> -				int ref_count, map_count;
> -
> -				/*
> -				 * Synchronize with gup_pte_range():
> -				 * - clear PTE; barrier; read refcount
> -				 * - inc refcount; barrier; read PTE
> -				 */
> -				smp_mb();
> -
> -				ref_count = folio_ref_count(folio);
> -				map_count = folio_mapcount(folio);
> -
> -				/*
> -				 * Order reads for page refcount and dirty flag
> -				 * (see comments in __remove_mapping()).
> -				 */
> -				smp_rmb();
> -
> -				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> -					/*
> -					 * redirtied either using the page table or a previously
> -					 * obtained GUP reference.
> -					 */
> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> -					folio_set_swapbacked(folio);
> +				if (commit_ttu_lazyfree_folio(vma, folio, address,
> +							      pvmw.pte, pteval,
> +							      nr_pages))

With above corrections this would be:

	if (!lazyfree_range(vma, folio, address, pvme.pte, pteval, nr_pages))
	   ...

>  					goto walk_abort;
> -				} else if (ref_count != 1 + map_count) {
> -					/*
> -					 * Additional reference. Could be a GUP reference or any
> -					 * speculative reference. GUP users must mark the folio
> -					 * dirty if there was a modification. This folio cannot be
> -					 * reclaimed right now either way, so act just like nothing
> -					 * happened.
> -					 * We'll come back here later and detect if the folio was
> -					 * dirtied when the additional reference is gone.
> -					 */
> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> -					goto walk_abort;
> -				}
> -				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>  				goto discard;
>  			}
>
> --
> 2.34.1
>

Thanks, Lorenzo

