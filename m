Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15FCEF8FF3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE2F6B0098; Wed,  4 Mar 2026 10:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC7E6B0099; Wed,  4 Mar 2026 10:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203336B009B; Wed,  4 Mar 2026 10:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEE36B0098
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:02:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B58221374A7
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:01:59 +0000 (UTC)
X-FDA: 84508695558.16.0FF6C99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3C7D1C002A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:01:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772636518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RsD2KXo/5uEm3T9d0++Do1JcUCIvfCYK9b/f5tqI3q0=;
	b=5Z+qb1pYvoukpn4098UQx/skPnjMhrihOmlB9uae2zrsmGPC/Ei5g5hdsEAKgrHSE574jm
	taANKnaiDlMTR3EbSb52g73xNqAqSCE7E8Ll3vK7mlyj1UT4znfEGOhNRrFdOItOdT5Vl1
	bLLOMguwoa1kfa4B97trQDUEFEBqmH0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772636518; a=rsa-sha256;
	cv=none;
	b=eDTWeoxQ3RoblJOc880xKGMU7y6QCHHxX+LuYB1syCIJHAV5ZfDgHSLjiVrIuwljPrTeLW
	zylw8aPddgaX1VL1g+5gJ1sQni6f4P7JpzXLBBl/H2Nd9Hrc2bdcBZ+TfO1h8lEjDG13yF
	hcmlA2Y2+0V+Js8Lt6Wp37U+Dpq4Ulo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25B47339;
	Wed,  4 Mar 2026 07:01:50 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EB233F836;
	Wed,  4 Mar 2026 07:01:54 -0800 (PST)
Date: Wed, 4 Mar 2026 15:01:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <aahJX0NwtYHy1ILe@arm.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <aagUtDTca5d0le2Y@arm.com>
 <20260304134313.GM972761@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304134313.GM972761@nvidia.com>
X-Rspamd-Queue-Id: A3C7D1C002A
X-Stat-Signature: tm6komp4k35rkug4pfou3kx9xn4eczfq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772636517-886871
X-HE-Meta: U2FsdGVkX18QYRK/HyqsTQnrHhcZU4T+qigfOjXReQ8KQeyYI1ASydLE0P+sYWMd2tgVGRrf/J1A/c/6Mr9qhu2SUn1zwDL98yq7oBdLsHnJP3ouBYNuGrSBu6Y1FCxBHe2Aq1R14mh9Um6h7UnHDlXa4AIs+Y6F+WIsGtd13RUNK/aT/X1Y2KQqDHDFLcA4cqj4Qcg7UiwC6psY+74pwdssS2hFO1hDqgW7OrFlsey7+2kcF8ttOGlrsMPGu6W5SAjwe4dHpwElPZncE3VETZb401GQWIVhdxmtRriff+UylwnsXNoninwLMl2iShRncasMATEp16ywcEFyYN3njXaT30jTe8mCcyQJ+FICwqQdumYYBSCnBIc6NVnDlDn1L0ApKiRPwNEEp8SBlaE3IVbEGaOyCQCf4wp9XJuODsj/yH4kPlo8OjXhKyKTTZWUm8UfVU362agGFuwLGNyN+qgk5rJAwn+vSbVtGQLWfMMKxayDAWLrKWmN/1LZqVxnn2mMtjqZa2I1GT73qyE6zRYBqtQB9WkFC3omnsC/SLkuYo+LjYulWxqua/6FcfMPqdfJyzQYCn8c92gibHwAZd3MeGe36n3tW3c7rBMwcKWnrnDNldYRf6lDY69Nyxxdrtntx/qT5NDBNWGPc8zrM0PZ/fO2Rcr59CyYs49Rg6H+tzyqWPXUyomYsqE2CzGxystTydxY6RTK6jI5B7SAd0ZUxEHMcKB3sYu/ZSfefTnfQ0xtrqIB74zJ3KGn9zp/M7/CDQ2ezGIUT/CgzLe5BFCF92EBxsQ80EjadpOk51rmlwRCAIT0WLyq9yEawaw4eYG+GNJMDT8yfkxR9ToQqBU7Bbl5RrD9d1o6lkyrOEizfj2jg69Ya0ta5+h/CZC+s0spfLILdscbOQrACFAtJK53KF4ubuowi9H1WfBYs7erfo94tOub1vJuYQrOBWVXfMn9I3YwACyvQFhNrxc
 /FAgSOeS
 wDuLyynzf4T1/WFHTLns+QbnbmdX0Y0lhHb6MXQlLRwEDOGsTsbqYf2jPdXq885mNaKOiMe460w/vCZ3VFhbkgugJuuZsHUo/Oe8xVnaFOWZcDfjubeqPy/y2uxmdIWOwsELSwGEdUi8YB/sKwirFgBpQKNqmpSWqpDWgPUnUSP/9PjT+/oRhTYM4jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 09:43:13AM -0400, Jason Gunthorpe wrote:
> On Wed, Mar 04, 2026 at 11:17:08AM +0000, Catalin Marinas wrote:
> > > @@ -399,13 +416,35 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> > >  	int i;
> > >  
> > >  	/*
> > > -	 * Gather the access/dirty bits for the contiguous range. If nothing has
> > > -	 * changed, its a noop.
> > > +	 * Check whether all sub-PTEs in the CONT block already have the
> > > +	 * requested access flags, using raw per-PTE values rather than the
> > > +	 * gathered ptep_get() view.
> > > +	 *
> > > +	 * ptep_get() gathers AF/dirty state across the whole CONT block,
> > > +	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
> > > +	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
> > > +	 * the gathered result as authoritative for the entire range. But an
> > > +	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates
> > > +	 * each descriptor individually and will keep faulting on the target
> > > +	 * sub-PTE if its flags haven't actually been updated. Gathering can
> > > +	 * therefore cause false no-ops when only a sibling has been updated:
> > > +	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
> > > +	 *  - read faults:  target still lacks PTE_AF
> > > +	 *
> > > +	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
> > > +	 * become the effective cached translation, so all entries must have
> > > +	 * consistent attributes. Check the full CONT block before returning
> > > +	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
> > > +	 * range.
> > >  	 */
> > > -	orig_pte = pte_mknoncont(ptep_get(ptep));
> > > -	if (pte_val(orig_pte) == pte_val(entry))
> > > +	if (contpte_all_subptes_match_access_flags(ptep, entry))
> > >  		return 0;
> > 
> > Actually, do we need to loop over all the ptes? I think it sufficient to
> > only check the one at ptep since it is the one that triggered the
> > fault.
> 
> With CONT we should not be thinking "the one that triggered the
> fault".
> 
> The PTE that triggered the fault is the PTE that the HW happened to
> load into the TLB, we cannot assume it is the sub PTE we are faulting
> at. For instance it could be a sub PTE for a completely unrelated
> access at a different VA that got cached.

Good point. For the AF bit, the hardware is not allowed to cache it in
the TLB, so we can't get an AF fault for an unrelated VA nearby. We can,
however, for the dirty bit since PTE_RDONLY is allowed to be cached in
the TLB.

> Again, the requirement here is that a fault on a CONT PTE must fix all
> the access flags to be consistent or fail. It cannot resume the fault
> and leave the sub PTEs inconsistent as the HW is always allowed to
> load the RDONLY one for any access to the CONT.

It should fix all of them to be consistent if it got a fault. I was
wondering whether we can simplify this with a single pte read (but still
setting all in the range). It only works for the AF bit, not dirty. We
could add a check if it makes things slightly faster on this path.

Now I also wonder if the `pte_write(orig_pte) == pte_write(entry)` check
to elide BBM is still valid if we have hardware that does not support
DBM. I need to dig some more into the Arm ARM.

-- 
Catalin

