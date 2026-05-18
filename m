Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E96CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 04:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AAF06B0005; Mon, 18 May 2026 00:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B626B0088; Mon, 18 May 2026 00:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870E66B008C; Mon, 18 May 2026 00:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750B76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:49:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08B9D1A034D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:49:35 +0000 (UTC)
X-FDA: 84779312310.24.79EDEAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75DE840003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:49:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XBqhwp3b;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779079773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fmfdF2XgrN2EQD16d5EYQ2Dh+HrIW4etd+I/EVEmto=;
	b=YuKzeAH+t6bHFnCNqIzlEC2fLzDxo5HXijuO29/ttgu78FWdGV82fl18J/GGKuAKIfmzEE
	in3NQwBXcSLkz0ONa1lcMhhJWvZXNku9y5wvp8tQ7cFf5SVxlvCkXUa8jwRUS5xh4sTqfU
	lt789q42h+DI2n14PqiINdnyppMBQPU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XBqhwp3b;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779079773; a=rsa-sha256;
	cv=none;
	b=szPACueoAG3aLDJmExLzv8kzkx9Crpnv2qW4DCs9SI08OaKqggNySAjrUvqYZX8ILMMqc3
	8RM1ppJfs0+CLno51SmusDGIdj9s9DQB++WnoGmbScnPjQOdSNPYf4F0StskB0qiH9LN9y
	Mk9Mcp4MWgtzYd7TtW3esFWld3q0wdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCFF56001A;
	Mon, 18 May 2026 04:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8904C2BCB7;
	Mon, 18 May 2026 04:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779079772;
	bh=ddstMBPXuzDhxfV/zDKcv0EX+9y5aSk2ybQr7szpmtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBqhwp3b7Or4r/oRklsbjLwMjXxsLdQgLNlYK0lwHjMBOcSzGuoQxnwVC/xpdMPeq
	 x/4wlWaU/A0cjtalw9ozh56yn4OvDdStyEHMT6man46ypwbbrvwsOXEQRqp3Mvy3Qo
	 i8DJHWtYJywJ+TE+O1UmGmfuISFLVitgTozeGtQJSiWXJIfU1lcd8oqfHYw35VYZjW
	 hujdecs86StuFxrbYc4XihS2/4uIwGHypyn25uoVIs0VDS4fuqwkFK2W1ncnO+8IoC
	 7om0UafwM8b6WPLg5BzF1Jo0W9DhzRafpCw4IeHuRUVybrM0S73Z4bg0bBLh9k09KR
	 1GTkHs3joleTw==
Date: Mon, 18 May 2026 06:49:21 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: ackerleytng@google.com, Muchun Song <muchun.song@linux.dev>,
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
Message-ID: <agqaUcVp_hwH-VXr@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-6-826a0c5f28fc@google.com>
 <agMqSlFloJJ22kgB@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agMqSlFloJJ22kgB@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 75DE840003
X-Stat-Signature: zseyexem7ejbjes8hxicewjn4m8parmw
X-HE-Tag: 1779079773-228266
X-HE-Meta: U2FsdGVkX18uVCSjMr0aIxxG9CcdJP5jz+VcOCsFtuQ1zdDVp7Ew/nYFHntJNN0BlO0o6x2FgmFx4fXOAcD3bcOwnfPOSnfZiDxbsBJF7vjqJi4ZBWvLQASGLRiSHKOZW983T9V5rs/Ae1yoOMZgEcSGg9JH9S/9jfGDVU8xLmGvtLdYmZ8bC8s8XNnb+ALVnOEXQFmAIMdJkM+IoQZ6vWveQLNs4hRTYTOomCAZoF7p/QQoe2i8szuQ1+ldtpK2AViA0cjDZGrROF7I1V3vPiS0bWRgX9Mt6xlESwqh2EKfWDfEgOEFBbmM+evamTejc1HsVzi05dQCkVw3LH31UhN8ZbWdU49GqgLKoIQzQUQnmyLNpWjTgSAKIo/8y8RRAC4dBxoh+vYt9nDRE2+y7E3pYLRliUEbE2Wk568LPOv1FuvDQmm/0rKgELdf6tsF/dqCHnNYXyn6nMdufMzOnNpvktNNRNcyvFKiabmZPH6DWqql1TOTdeaOVp9DMD79A7uI7dVsrUD74ns5hr01VgPDEmg3m1TeXMqBNQOrwYx46/YLU0Z1v9o5+IMUugOpUvIJ4kUto/DnFlJ8PPMQmskOq/xiDyelEgvJDCK6hDFXeYf/7o6y6fC5XbKcOVl55g69NKzEu07i326v9wiqdRo6BgiAgygTfSJJAzl5P8JaNVGREBatbZUUiF3LeqxRQatsW4MHh0uKorQYkZC8Wpc0okgFed/+jvZZ7VbWD9RvgvGAuoolgRFxEbVoUCW/SSMeASSqLuqVqhFyYpF/eQ/GBBx+CATx6tGI3lx76whvuw3Ms9mFs0pXngaEEv8xTzeUHM6eFH8nFDrVQxe4uuvTeUBZBqQeD40CPZQcJnr2BNq6Pi81cG/XcJ98kRJoKqeb0IdFWie5Tg1u//2fA9HJi71wH8FAUu+h2PWq7rL1PiWsebdcl7tF/U4v9u2lD4Wp1Pdei6mCK4tt7v0
 Y64f3w/J
 euO6cxZ2Kobp0BOTFEQRL6HMfo7GhSYgVVg+gUFQ6HYmqlAzY90oAnHEhW2IUnHU1deomZE2I8dlGqglEa8EFllmXq3PKFpEsENrpEP0U7lc+7agneo45umu7zw5q09TynxmJWWDOrI1TnRavBfJK7PMJBs5INefRupBL9PAHcL322C8uiSYSGQXY7sAeQTQ0Uyg1TMDXOxDUFBYoaoLI9rV7eLStH4NExQsUhRx31j3hy6gcaQ3qNzhseqZwzQDTFMDZBEbjJrhJZ7OmwzgwPLMHhrEa26LE3E3fERiOeZVSN5+cAM44rGFvb90HJgVsYx0eKhtZtPvhi3H8JoHQR0qu048QxuzvrZB6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 03:25:30PM +0200, Oscar Salvador wrote:
> On Wed, May 06, 2026 at 08:54:42AM -0700, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
> > handles allocation of a folio and memory and HugeTLB charging to cgroups.
> > 
> > This refactoring decouples the HugeTLB page allocation from VMAs,
> > specifically:
> > 
> > 1. Reservations (as in resv_map) are stored in the vma
> > 2. mpol is stored at vma->vm_policy
> > 3. A vma must be used for allocation even if the pages are not meant to be
> >    used by host process.
> > 
> > Without this coupling, VMAs are no longer a requirement for
> > allocation. This opens up the allocation routine for usage without VMAs,
> > which will allow guest_memfd to use HugeTLB as a more generic allocator of
> > huge pages, since guest_memfd memory may not have any associated VMAs by
> > design. In addition, direct allocations from HugeTLB could possibly be
> > refactored to avoid the use of a pseudo-VMA.
> > 
> > Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
> > subpool is stored at the fs mount. This is also a requirement for
> > guest_memfd, where the plan is to have a subpool created per-fd and stored
> > on the inode.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> I yet have to review more thoroughly, but I have a comment below:

So, I thought about this some more and here it is what I came up with

- Ideally this new hugetlb_alloc_folio() function should be as generic
  as possible to try to fit other users in the future
- I would create a ctxt struct to pass all the parameters
- charge_hugetlb_cgroup_rsvd and use_global_reservation could be a flags
  thing (action_flags?) within the ctxt struct. We might want to add
  more flags in the future to tweak the allocator behaviour.
- Ideally gfp_t mask should be created in hugetlb_alloc_folio() and tweak it in
  there before being passed down the road, which means do

  gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)

  in hugetlb_alloc_folio() instead of doing it in alloc_buddy_hugetlb_folio_with_mpol()

  As of right now, we define it in four different places:
  hugetlb_alloc_folio, alloc_hugetlb_folio, dequeue_hugetlb_folio_with_mpol, and
  alloc_buddy_hugetlb_folio_with_mpol. 

- I think we could strip _mpol from both   alloc_buddy_hugetlb_folio_with_mpol and
  dequeue_hugetlb_folio_with_mpol, and pass a boolean "node_preferred_many".


I am probably missing something but I cannot remember it right now.

 

-- 
Oscar Salvador
SUSE Labs

