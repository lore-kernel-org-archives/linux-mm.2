Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25F6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD346B00A3; Wed,  5 Aug 2026 04:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85796B00A7; Wed,  5 Aug 2026 04:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C986F6B00A9; Wed,  5 Aug 2026 04:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95AA36B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:59:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09FF6403D7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:59:42 +0000 (UTC)
X-FDA: 85066617804.26.1A4E126
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 72DF220006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:59:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+1Rt2ao;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920380;
	b=DEjsv7yPXjnHfQkbklpHJNu1yEeuHer9W9JJFw71Ulf3iMCdFYGm7U+b8Hsd+sJtGzu1Ek
	EjlgV/RDt5c1pyrBFWldVnLFImT/wI/9tdehC8rf1En291kjoh12JUTeJvWwCf3BToH3fY
	q7piQ0rfJyTNzQpy6/nXd+lIYwMDjwU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+1Rt2ao;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yRpRg/YjcbX7C2paRrZom5mhwTrr0QvF5ECsYRO/+w=;
	b=SdxGJ3fTpNi2jJvXnDBvPLSuPOa7TjATBwLERlwfoIfbGBBEppF0UkT6WF4PHF+01pzm+b
	OITXiN2Z3MC5Qfkj6yY5HZi3w/DWLkSaRYQqdvsHFZ1XaAF/iE3CWJhIJ8onF5MwqHFh8i
	fvAHFbxzH7+yZJ140OixbdGCKpWDgHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A15D600B1;
	Wed,  5 Aug 2026 08:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018091F000E9;
	Wed,  5 Aug 2026 08:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785920379;
	bh=1yRpRg/YjcbX7C2paRrZom5mhwTrr0QvF5ECsYRO/+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K+1Rt2aozvXZ6W3FHxtBV97CQTGhnvf409HxCGwFj1X7JitOXG86TUEDPv2k6/x1G
	 9O21hqeZLoY80QDCALep3ZAzkMnjq2H4JgVfTCNCL3LSyWqgHDPxpQkvn6OEdCzSTP
	 nFTo5dTvUmevSjaaFR31pHViXEAjraEDTdHwz8ddfwS+yWdKF9/yRqpRB/xSbt/oU/
	 9gsWhKTBxLM2/PQ9fPfZu+Y5waWH5MhkyPQergkWmtzoLZgE1MUZ+ljzvSOkksvxg9
	 P3PI82Af/rplRRKV01PYALUmNe+GNe41JF0++hzkt1334sQRaqV8XOvJxYe66oAdn7
	 Fn3FDMZalFhGg==
Date: Wed, 5 Aug 2026 09:59:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 06/15] mm: propagate VMA anonymous page offset on map,
 remap, split + merge
Message-ID: <anLyhaI6kW-EWk13@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-6-e8ecfefea812@kernel.org>
 <4ad4b17b-bae6-4169-8649-bff4a29e7fde@kernel.org>
 <anB9MWSSITYpDibA@lucifer>
 <6ea7cdad-afb1-45af-a63c-30b760fe160d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea7cdad-afb1-45af-a63c-30b760fe160d@kernel.org>
X-Rspamd-Queue-Id: 72DF220006
X-Stat-Signature: fontrjwg7icn4cqwbb6aqg94e73cqxab
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785920380-148729
X-HE-Meta: U2FsdGVkX19JEPJyVnMUCLvX2pAOFGvgvkg0GxML5uU5ZupVZ56+car7ZSt+xowcBjRXy7WhBZgUc9oe0p7zCMVP/r5YXLkAIbtPFGbIHjbBzVB6UMVxMk5UhL9zSeFOCpfw9MiqGi/8orUPDY+CXmRPTA2dvlchtLLVt1A61mh2B/3n2Nxtm28a+R0/Y7pZ1juKU/4kDy2KrRgQP8my45PQmPyKOJsfiCz0N87p72ZnDsoxWJINbSfIFz/kifKPlrKuFxO+aKDalA5jgclvIipWBPf1AnZ/5/+S/w3bbtfh53uystLIBVRi1rCe8DS3fBlJLsWF6ioicmXmcwAdtvtGb+lSCs3s0/0DxI/5QHw/rJJOagdYrb2za1sjp+QCf8tcGUTNyVzcWpeO/pXxgj9bPnQ1vYxnGhxcGV2gSTMahs3FEY7fhF4JWKA7R5PJkiOPv8KzRCVapusHzE4nJrI8l7r6AsiNS9pq3dS4wQqhLFhmuzUp7yPO8oa9/Ixz2MOMAHerPiLIRuV5GgkP6yOlFE/S9ltkjKt3P4OTr4YXZtHmj0aIbfwHuSM7nNyMvzCnFOUvMP4sFAC+Qzzf3M7QTYJMtTyG4vG5PLm964ZHi0ldZ30ReAZ+/SrfIBKE8VscfHQanW/xIT1Mb3D0mIYgVQ8wzm7nP5jA5LDDpsS4C1iposZT8cndUR0bI15uXlo+Fwq5hnSb0+pCfkcwK8novwKQevG9UIIh0PhEDRIB4lsuC1GK/zrpINUIw5bGhYJr+vxkgggkxyTU21xueyuLirNIdhSKWXtqbQFF4w251ucuVimqmMLraf7OpiPsK4ZG8cticsgZhDXo3prkbDYl8SLR6H2156Q2xcJ3g0MadwghlEUfCrKOSpq4gCvt7Z1Db3NscvgO+YcFFL5E6iEK5qGsy/5Wnp6707ku9db4ChqUwI09XfnwWdU6X2/skfNsiwUZZxvx4S7b3Ru
 dGPLAXwD
 W2vI8ya6DzK1JaIN91TCJke7yArAPxqQsbpkSjBI3SLJ3N52040pzOXRzlvAMyO4Yw93o7R61OFH3WnphRvA03djoqV3/ajEtgCPwWmSwW9UNe80cI7g/1GhIrSY+iEnKHc8E/v2UYkwqfPYB3ndK1s9wJkgIj0Zh2uiK6mdJbuSwxdIyCq9BgYk0mCrAzFMgMdEEiQgqJy4Rx1f50gbpy6PQOOSsYMRbgTgEHea+uoCRwXBo416uHrmn2at0ANlkbBEHowsJIAOGUPYcj5Xyu1G5peawCPCXkDH5Mnb2Xk1U4QIKBMoMT39rzky2TdCRn0DJ0PpDsvP/lT24yTXteEDqrnOb1nFFJPKI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 09:35:56AM +0200, David Hildenbrand (Arm) wrote:
> On 8/3/26 15:46, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 12:52:42PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> >>> We must correctly update VMA anonymous page offset state on all VMA
> >>> operations that would result in it changing, with special attention given
> >>> to remapping.
> >>>
> >>> We cover most cases by simply updating vma_set_range() to do so (with a new
> >>> anonymous page offset parameter), but also notably must update the merging
> >>> and mapping logic to propagate this parameter correctly.
> >>>
> >>> The remap logic remains the same - we may update the anonymous page offset
> >>> if the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
> >>> mappings too, so we update the code to reflect this.
> >>>
> >>> Note that we use __linear_anon_page_index() upon remap as the VMA may be
> >>> shared, in order that we update the field consistently regardless of VMA
> >>> type.
> >>>
> >>> Similarly, pass through anon page offset to the merge logic, updating the
> >>> vma_merge_struct struct to propagate it, and also use
> >>> __linear_anon_page_index() to obtain the anonymous page index so it can be
> >>> safely used for both shared and MAP_PRIVATE file-backed mappings.
> >>>
> >>> Finally, we update insert_vm_struct() to correctly set the anonymous page
> >>> offset on insertion of a VMA.
> >>>
> >>> We simply ensure state is correctly propagated here, so no functional
> >>> changes are intended.
> >>>
> >>> Also while we're here, replace a VM_BUG_ON_VMA() with a
> >>> VM_WARN_ON_ONCE_VMA().
> >>>
> >>> Also update VMA userland tests to reflect this change.
> >>>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>
> >>
> >> [...]
> >>
> >>>  	struct vm_area_struct *vma = *vmap;
> >>>  	unsigned long vma_start = vma->vm_start;
> >>> @@ -1919,11 +1929,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
> >>>  	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
> >>>
> >>>  	/*
> >>> -	 * If anonymous vma has not yet been faulted, update new pgoff
> >>> -	 * to match new location, to increase its chance of merging.
> >>> +	 * If a vma has not yet been faulted, update its anonymous pgoff to
> >>> +	 * match the new location to increase its chance of merging.
> >>>  	 */
> >>> -	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
> >>> -		pgoff = addr >> PAGE_SHIFT;
> >>> +	if (!vma->anon_vma && !vma_test(vma, VMA_SHARED_BIT)) {
> >>
> >> Could we also use is_cow_mapping() ?
> >
> > No this would be incorrect.
> >
> > A read-only mapping would become unmergeable here. So this is something apart
> > from the rmap aspect,
>
> I'd assume that we should never even consider anon_pgoff when merging
> !is_cow_mapping(), it doesn't make any sense.
>
> No anon folios -> no anon_vma -> no anon_pgoff

You can merge unfaulted ranges is the thing here.

But anyway I actually wonder whether this whole branch shouldn't be:

	if (!vma->anon_vma) {
		...
	}

Because that way we keep anon_pgoff updated even for MAP_SHARED mappings. This
isn't necessary and doesn't impact anything _except_ print_bad_page_map which
outputs both pgoffs.

But it'd be consistent, avoid any confusion about gating on VMA_SHARED, and
simplify the code :)

>
> But I think I am missing one detail here:
>
> > and it is a contract that upon move of an unfaulted
> > mapping (which for read-only anon would always be unfaulted) that vma->vm_pgoff
> > is updated.
>
> "read-only anon": I assume you mean an anon mapping that does not have
> VM_MAYWRITE set?

A MAP_SHARED mapping of a read-only file becomes a MAP_PRIVATE !VMA_MAYWRITE_BIT
mapping and must adhere to the same contract.

Also mmap hooks can clear the VMA_MAYWRITE_BIT.

However:

- If you're a driver clearing VMA_MAYWRITE_BIT you should only be doing this for
  'special' mappings anyway (I have a series I've not sent yet that establishes
  this as an invariant also) - and these are not mergeable anyway.

- If you're a !VMA_MAYWRITE_BIT MAP_PRIVATE-file backed mappings you never set
  vma->anon_vma and always update anon pgoff so you always have alignment for
  purposes of merge.

So I think also we can then change needs_adjacent_anon_pgoff() to:

static bool needs_adjacent_anon_pgoff(const struct vma_merge_struct *vmg)
{
	return vmg->file && is_cow_mapping(...);
}

[I have to create a vma_flags_t variant of is_cow_mapping()]

With those two changes we gate on VMA_SHARED_BIT nowhere :)

>
> I recall that that's a combination that cannot be created. While you can create
> something that does not have VM_WRITE set, IIRC VM_MAYWRITE is always set for
> anon vmas.

For pure anon yeah, see above for the MAP_SHARED->MAP_PRIVATE-file backed weird
case.

>
> --
> Cheers,
>
> David

(It's funny to me that if you want a truly read-only MAP_PRIVATE file-backed
mapping (no idea why you would but anyway) you have to MAP_SHARED, but an
actually MAP_PRIVATE file-backed mapping of a read-only file is writable [which
makes sense obviously] :)

--
Cheers, Lorenzo

