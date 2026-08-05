Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F8CC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5772B6B0093; Wed,  5 Aug 2026 06:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B086B009B; Wed,  5 Aug 2026 06:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418566B009E; Wed,  5 Aug 2026 06:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 057E96B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 643CE120424
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:09 +0000 (UTC)
X-FDA: 85066875978.11.B0A465B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F50DA0008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAvR95RI;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785926527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRDF1mhbIufLQkNvACHtHyLl20FTi2l1DXvG2VDWt8o=;
	b=hChBeKYmj/YerpdmgC/WJKvwhw0UjYf2GB6T5NwKjy6o39oGAqARrT0EhMVfkG6IL/VNhr
	NULTrPTminapflzqzQXhVDhAY017p2N00fV6gxmw15ybwIheVWolbFWzbHKVFKG1cJ+DaW
	INT/Up7VF/DNWsLZNDFksITy+Ya7UJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785926527;
	b=IWr0vG+nvh23R75zyDJQJ0YnWPaezpt/2uS+d/bGi1yVM16GXpIivv8m00COX0rAdBQi8l
	GCLIZUICn/Bq0E8sh+Qhn7X0n24qrbov77QCEBbXIintdV13yHGEUAwCsF326dn9nbPrg+
	7TuiIIHbTRlphR7UNn5EJKS+wcMU92Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAvR95RI;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9114B45379;
	Wed,  5 Aug 2026 10:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47F51F000E9;
	Wed,  5 Aug 2026 10:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785926523;
	bh=wRDF1mhbIufLQkNvACHtHyLl20FTi2l1DXvG2VDWt8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aAvR95RIJiKW62G7z8/H3teFaJ6eqeq/fhV8PW9UFRLZEYjM05xk5/3+82CAkT+AV
	 aRFL/Gvv0OjCMCMmgdBuu+4eamJRkG5en0zIAzmmErFTm5tUuxAKnphtUdkQoUl8o/
	 b+c2JwLodMiHbtWnINP5yVQ2vJV9ps9SZ8drYlay8MMH8cLb+mC/8V6FXKi7F0SMun
	 G2ifAwIj4Xem3RRBO4l1CbGOJegJDR+PS9mjAgtVarw3Va7ld7XbqZGb0BgJnBA0hF
	 wHazsXXA8CC3WV1tBLa1Z0UpGVmce6pbWK1mmA8p2M4dbmLX+bRMgrOIBziEM1b0+q
	 joSJCiamNlEvQ==
Date: Wed, 5 Aug 2026 11:41:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>, 
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anL-NZkNMSSxN0YN@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260805055544.1568534-1-clg@redhat.com>
X-Rspamd-Queue-Id: 9F50DA0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jxxk9yghz961obozdgice78f8in65cq9
X-HE-Tag: 1785926527-385771
X-HE-Meta: U2FsdGVkX1/qN0/7c1vq77Kvw1+BBh/Sym+0tHxDBd9hGptCZoinlQhf6Aqrbva9QNXnlbyAm6mqxP08w4qH/Wlyv0yJjwia/spAABG4jezzFoDwzFUq7AVP2Nc06uWZ16PfdSVrLYgoZ7oLPvbpxJaqyFzf/S4l8nNrsDzF7X4o6wDfr84ZtnxKgbgx5viypEuKDUp8WPHdo75Y7qSSLou1WOvCue2MucetrimkOG0kpr92PnB+Vjxxgx+2CSFqVul+qOjLyil6TD4yfFkKnrplYPlb0SYVaaZtB9Ths6LF3RMcey+m5vnpMpazXQ3Jvkjd97ROUx4E2O2oSQVbxpLuRFtz3ZtZ8cO5FH/7OVS1m4FcGuZtzbhQc9wjtAK7b3e3z6kZnCc26Ezg2IgGy2ErZ4oFLuh1DWpT03iAs7ugD5uaCbJ49C+v0MLVtuO9FOSYORK/y14JFghY6Lbvh9BZafjhSx3v/2jQbdub27Kb0FujA9FU1dim8+IGSl58O+InZ3TOLRkBQ2zHVc2cKIjk9otXpFQFG7omrUjAQJnhrUfDmZU1YNPp8IgP9jmX342BSayvB+vHrKzMzzUEPvWRqP3PJuPu35eEYfYT48DpQYeSftAe0Fvgf83d2ACBKfWNfRRf+c6CbUqQcBCGbx54pQjH3VYxDL7jMkJ9KXQaSDmQtdt5RT6Ng5Bj7AN32fzca+lVtOBjqUq6HDBZSkDplQaN/M2Q0KfT23GY2WeqsfbLmhgkiKXXdFzCiphLYsZMfRHf82w2PZA7db/yhEYX4kFqYgMh9vg8TMK17zK4bubOM7n5rCDDVvZnTxFZ/tcOES+tBtr3DYXstLMiyW1/QsiyxsB9F3EdyvJNkpsNCo4K1w+pckDc2YdXnaAav24c42n1ES/seAdNoShq2rjqYQi9P7Ot8+LJxUoHWWoukL2/4X1LxMlPI5LMskdLNJ7dh7XXmmjC/86vLZy
 0ZV2ta95
 RwVOto8grq1GL8CN4C8rSqeZADkGfHC516fI1VPqCTAbSBwr3p6OXUEMPu09YQUVy5G5cgwvUgRv8pc00aB4W+mgEopRfVZ4juGTIKDQU2TXqLa+d5YtZ4CEVcP/hd7fdRn2djkeiTirXjiejJ5vW8Er/WPTaMyK8F5mS2CrUUPeuz0T6ZhlDtp/U7Yqd0y+pcuDBlbbj0Y0mnRriYZdx2GW1zE2yuzCus+gsbqJR7LVszI7J6ugw/uraXuH69tZHXWiuXGHJ+rlvmbokQk7tFnz5mEWdvcGCCZbJesTKxKfKUvtEtoJk0wrpNpZWza0v/jcHyhXwONmoC8rrB4Mey/zUi0mtNcL5/PIpZ18vFqZWL4aQHX4w+Q5EeY/C8I1GS8rVL02pKNQMqyGLJhkm8aUi7cpWwpZkKQcOjwtu5VZ4HU/DEwHQl4TqWkvBG/bLE32uZAyYLaK1Two=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 07:55:40AM +0200, Cédric Le Goater wrote:
> From: Cedric Le Goater <clg@redhat.com>
>
> The global THP sysfs policy (transparent_hugepage=never/madvise/always)
> gates the huge fault dispatch path in __thp_vma_allowable_orders() for
> all non-anonymous VMAs, including PFN-mapped device BARs (VM_PFNMAP).
>
> DAX VMAs already bypass this check via an early return:
>
> 	if (vma_is_dax(vma))
> 		return in_pf ? orders : 0;
>
> But "special huge" VMAs -- identified by vma_is_special_huge() -- do not
> get this early return, even though they share the same fundamental
> property: they map physical addresses directly into page tables and
> involve no memory allocation, no compaction, no splitting, and no
> reclaim. The THP policy has no meaningful effect on them.

Re: allocation that's not true - vma_is_special_huge() returns true
for !dax PFN/mixed maps, and mixed maps can absolutely have allocated
memory in them however obviously they are not rmappable, nor subject to THP
in the usual way).

In general I think this patch description is misleading.

Page faults are gated on the THP tunables on purpose with DAX being
specifically excluded because it's statically allocated.

So you're asking for a _policy_ change and it's far too broad - now you're
saying all PFN and mixed mappings (regardless of whether they implement
.huge_fault) should _ignore_ THP tunables, while citing one specific case.

It's in any case as specified seems far too wide.

So at the very least this should instead check .huge_fault.

But we are _explicitly_ disallowing .huge_fault page fault if the policy
doesn't enable it.

So really I think this should be instead - 'is PFN map and .huge_fault'.

But it shouldn't be done here, see below.

>
> This matters for VFIO PCI passthrough of large-BAR devices such as
> NVIDIA H200 NVL GPUs (256 GB BAR each). The VFIO driver registers a
> .huge_fault handler (vfio_pci_mmap_huge_fault) that dispatches to
> vmf_insert_pfn_pmd/pud, and QEMU's vfio_region_mmap() aligns the BAR
> mappings for huge page table entries. Both prerequisites are met, but
> with THP=never or THP=madvise, __thp_vma_allowable_orders() returns 0
> before reaching the "trust huge_fault handlers" code.

Yikes...

>
> The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.

Yeah but the users explicitly disable THP.

It is wonky that we have huge folio support and THP support... but
.huge_fault is explicitly a THP thing (at least for now).

But OTOH it seems the huge PFN map series should have addressed this.

>
> Configurations that trigger this:
>   - transparent_hugepage=never on the kernel command line
>   - The tuned cpu-partitioning profile (inherits network-latency, which
>     sets transparent_hugepages=never via sysfs)
>   - transparent_hugepage=madvise (the RHEL default), since VFIO VMAs
>     lack VM_HUGEPAGE and QEMU does not call madvise(MADV_HUGEPAGE) on
>     BAR mmap regions
>
> Extend the existing DAX early return to also cover vma_is_special_huge()
> VMAs. This is consistent with how vma_is_special_huge() is already
> treated for supported_orders (grouped with DAX). The mm/Kconfig TODO
> comment "Allow to be enabled without THP" also acknowledges this
> coupling is wrong.
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4
> Signed-off-by: Cedric Le Goater <clg@redhat.com>
> ---
>  mm/huge_memory.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 58cabe6af33d031e48250e21db51506bc46c97b2..6dfef5500a054f09f9ece6df8bf7a0194624350f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -139,8 +139,12 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>  		return 0;
>
> -	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> -	if (vma_is_dax(vma))
> +	/*
> +	 * khugepaged doesn't collapse DAX or special huge VMAs, but page
> +	 * fault is fine. These map physical addresses directly — the THP
> +	 * policy is irrelevant for them.
> +	 */
> +	if (vma_is_dax(vma) || vma_is_special_huge(vma))
>  		return in_pf ? orders : 0;

So yeah I think this is wrong.

As above it should be a narrower check. But also it breaks the smaps case
causing incorrect reporting  (!in_pf -> THPeligible: 0 for things that
are, in fact, THP-eligible).

It also eliminates the huge_fault check in the !vma_is_anonymous() branch
below this.

So I think it should be something more like the attached.

That way all the handling remains the same and the override is applied in
the right place plus smaps keeps working.

Cheers, Lorenzo

>
>  	/*
> --
> 2.55.0
>

----8<----
From d6537260722c8741586e6295c8eea68d06087efa Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 5 Aug 2026 11:35:13 +0100
Subject: [PATCH] ideas

---
 mm/huge_memory.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index abc65d608c23..5fa01364f089 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }

+static bool should_obey_thp_file_tunables(const struct vm_area_struct *vma,
+					  bool forced_collapse)
+{
+	if (forced_collapse)
+		return false;
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
+	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
+	if (vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault)
+		return false;
+	return true;
+}
+
+static bool can_thp_collapse_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, bool forced_collapse)
+{
+	/* Override THP tunables? */
+	if (!should_obey_thp_file_tunables(vma, forced_collapse))
+		return true;
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise? */
+	if (!hugepage_global_enabled())
+		return false;
+	/* Has VMA had madvise(..., MADV_HUGEPAGE) applied to it? */
+	return vm_flags & VM_HUGEPAGE;
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		 * Enforce THP collapse requirements as necessary. Anonymous vmas
 		 * were already handled in thp_vma_allowable_orders().
 		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
+		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
 			return 0;

 		/*
--
2.55.0

