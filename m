Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E18CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABCE6B0088; Tue, 12 May 2026 09:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C536B008A; Tue, 12 May 2026 09:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BB16B008C; Tue, 12 May 2026 09:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 949896B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:25:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41AC11C0EFB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:25:41 +0000 (UTC)
X-FDA: 84758840082.05.19C2977
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13BEC4000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:25:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dDQimm1X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tUM7BnW0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dDQimm1X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tUM7BnW0;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778592339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLlP/U0XqQzf4ZxxvPLpA37cgquIeHojOmsRWrWUAj8=;
	b=jllQPozDFspSnJo3rd6gwRYhZEtiS4lUwJc4BFReQl36hsQZEvl2nVOoVAlSsBSWwAf5vH
	wFGrqmPhh0vUYuGkcE5zyYDkunq0VTKdS2GpAyObB4RSCSbLpO08z4o6JikWhZ9i95tOH6
	KSWBhBZ4c/tG15Vmy3Z62Tl7mbT91b0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778592339; a=rsa-sha256;
	cv=none;
	b=I3M2xy3OUkkPhODNcgqnq3VAtDxQNxPjE4yFTNeV5hOC9haOTAefZJLi2MjXGdqqcbkvvY
	lcGuoHcIGccqogDdI1I45kFDkvhUGwtFG340Q8cXdgEPaUnMNlVn/j7ZGBSBOD6Q4GruDT
	qSovtLgofQniUgfOzZFkY5vYhmNsX6A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dDQimm1X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tUM7BnW0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dDQimm1X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tUM7BnW0;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B7075D455;
	Tue, 12 May 2026 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778592337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLlP/U0XqQzf4ZxxvPLpA37cgquIeHojOmsRWrWUAj8=;
	b=dDQimm1X1xceRuI47hi+xdNGv65ih/HxqqXtFBL+9PYacdSU4lc8+Fzx3XsykC9+ju2t78
	Aiccd8lTU4RQ/az5JhsIaESm/FDBNC07I/Ox5xDValSWLV+VGSn6Hmc6Sbob7xbwqpBbvV
	YxG6v7gXczAABY+tvTL5e44+nmmnFz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778592337;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLlP/U0XqQzf4ZxxvPLpA37cgquIeHojOmsRWrWUAj8=;
	b=tUM7BnW0/kHQm8Kaor9TNZpVsgtk0tKmA5dawWoTnygrk6OSHKGkLrhbzWMVsIMy+9wWPL
	K2woTbknQ561u2Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778592337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLlP/U0XqQzf4ZxxvPLpA37cgquIeHojOmsRWrWUAj8=;
	b=dDQimm1X1xceRuI47hi+xdNGv65ih/HxqqXtFBL+9PYacdSU4lc8+Fzx3XsykC9+ju2t78
	Aiccd8lTU4RQ/az5JhsIaESm/FDBNC07I/Ox5xDValSWLV+VGSn6Hmc6Sbob7xbwqpBbvV
	YxG6v7gXczAABY+tvTL5e44+nmmnFz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778592337;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLlP/U0XqQzf4ZxxvPLpA37cgquIeHojOmsRWrWUAj8=;
	b=tUM7BnW0/kHQm8Kaor9TNZpVsgtk0tKmA5dawWoTnygrk6OSHKGkLrhbzWMVsIMy+9wWPL
	K2woTbknQ561u2Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00F4B593AA;
	Tue, 12 May 2026 13:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DfBROU8qA2oPUgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 13:25:35 +0000
Date: Tue, 12 May 2026 15:25:30 +0200
From: Oscar Salvador <osalvador@suse.de>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
Message-ID: <agMqSlFloJJ22kgB@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-6-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-hugetlb-open-up-v2-6-826a0c5f28fc@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13BEC4000F
X-Stat-Signature: rmfaif9bhy8weagbrzschrydfx41d6r3
X-Rspam-User: 
X-HE-Tag: 1778592338-878124
X-HE-Meta: U2FsdGVkX19cDWVfYNmQD+xGYUco5R8F6WPl1gEBox/xxepadfH5ffUVc4xpk/4NsUQferjsy5WZLWcojIeGNTKAfMiSNTB9TgZcsgGvmccR+7IQY5eYVf9EyKTjrSPnMnnzr/bnLyv4R8kdPNIbDYopO3oECoGJVwjfcZG5ErW662QIxRkdgUTKbuzowxuNBzRdNfEWi8qMMXePTqGi/sKTQ3cYj3DNMoDKcw7LuhynUdrr8Pw18r8Pc75807nI5W0hEW1TMF62Jalk247kloJ2ag/UzFMzq6CDrCziNQ0sZIby5bqsXJhW9KakXFf4It9s8HeQSIAvENW2xHYRs1rmqyBQObPYP0TrRHSTcGPkHMiQHFYOfKNGnwHdpmfj2qRMLwTmYN0FY4kuKqPxdFlGzF4ZY816ImdBgLsBUxPhWNoXAwedma6pCkVFdiA7kGKHyfPfFnq3p3tELp2IBzpephHOzY5njBMO/Y6xfafvTZrtiflBDlH2e6dHiUAb5fA0ASMY8VUqbkEuftYbDiQhJkkGVXmT3B180HBvf0cCqxr72UsybHdLOolY2Sg6mpOXb4+ItygjVK+VyOdG7l+opvZihWz9IuMehYAjAMPP+Cou43BoP1HJWGe6IhWOvhuy40p+LH7X/G1rM8hWSXgs5NV0f9ncu8TbexmtbpHnqf9iZL3gXmqeGppatf7qXgw4+2JVgqBwQZVrNFx6gouCpsLS3zS+IVMJmpW6NeDZ4JGDBaiko8BlqMbzgDiJBxZ2CXMqEo25JImFhWJO1o6fHxFb1Z2NayBPgf2FzR75AABbh8vRAy8bPsPBQNuFSxnnjYNaFj9Tl/WEx1uck9WP0JXbAgQisPkBTXf6dflOEj3OKzNiF3mP8kdvYzKYOlAwWulRTXZNRqobEZHcnnAG2p53pEdFRq+yvcU81RdcPwHR2SepKz28vsESVC1+gu3oIXhRkH+o+1GwvgB
 r1tH7T07
 XrRpQr+iEkSqPj6MxnBX7G9P/RLTY6ImC3Kgq+Uc75ZhlpcQ39I3oz6RSNabsm1HHJ88djNO7JpozOuCL9IEQRhmcahN+ANupqw4IKFqPznBFVbmoYF7KfGS70JL4RR9kcIrMSlTH/xPEPr4cGHtO/tL4TbPZa4995WGmLNtHN0uCTYuWmINYZlzTkgwQ0OjQLFE2/N7YGE/Ir/1wZEd4jSHAX9kV5oAGG4ZaywiJ/3QX0gV/USzy2vUa7gVz9rjaml+V8rn/3b12mh1gbc5lbAAli1seIDtpwucAKZ7zDQ7a0emFBWjbym/ooxfzgw1ACQYS4ndgJb70XKcfXD3v4WaTRoxVf4W9F9fcY5m/uafscSx9nE9VdqSNhD20ZZmBwlmi1V0BiZLmEi7cwWnYpetVAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:54:42AM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
> handles allocation of a folio and memory and HugeTLB charging to cgroups.
> 
> This refactoring decouples the HugeTLB page allocation from VMAs,
> specifically:
> 
> 1. Reservations (as in resv_map) are stored in the vma
> 2. mpol is stored at vma->vm_policy
> 3. A vma must be used for allocation even if the pages are not meant to be
>    used by host process.
> 
> Without this coupling, VMAs are no longer a requirement for
> allocation. This opens up the allocation routine for usage without VMAs,
> which will allow guest_memfd to use HugeTLB as a more generic allocator of
> huge pages, since guest_memfd memory may not have any associated VMAs by
> design. In addition, direct allocations from HugeTLB could possibly be
> refactored to avoid the use of a pseudo-VMA.
> 
> Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
> subpool is stored at the fs mount. This is also a requirement for
> guest_memfd, where the plan is to have a subpool created per-fd and stored
> on the inode.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

I yet have to review more thoroughly, but I have a comment below:

> ---
>  include/linux/hugetlb.h |   3 +
>  mm/hugetlb.c            | 179 ++++++++++++++++++++++++++----------------------
>  2 files changed, 100 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 93418625d3c5f..ec205d8580885 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -705,6 +705,9 @@ bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
>  int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
>  int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
>  void wait_for_freed_hugetlb_folios(void);
> +struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
> +		struct mempolicy *mpol, int nid, nodemask_t *nodemask,
> +		bool charge_hugetlb_cgroup_rsvd, bool use_global_reservation);
>  struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  				unsigned long addr, bool cow_from_owner);
>  struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4159b3565a9be..a1c5b94e52e0a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2821,6 +2821,88 @@ void wait_for_freed_hugetlb_folios(void)
>  	flush_work(&free_hpage_work);
>  }
>  
> +struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
> +		struct mempolicy *mpol, int nid, nodemask_t *nodemask,
> +		bool charge_hugetlb_cgroup_rsvd, bool use_global_reservation)

I think I would put that information into a context struct that we can
pass to hugetlb_alloc_folio, otherwise this seems too overloaded, and
maybe we need to add more params in the future to tweak even more the
allocation. E.g:

 struct hugetlb_alloc_ctxt {
   struct hstate *h;
   struct hugepage_subpool *spool;
   gfp_t gfp_mask;
   ...
 };

Maybe we can go even further and convert those boleans into action flags.

I have the feeling that as is, it is quite ad-hoc code, and the thing is that if
we want to open hugetlb allocations into the world, we should make it as generic as
possible, foreseeing that we do not have to change the API whenever a
new user pops up.

 

-- 
Oscar Salvador
SUSE Labs

