Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB25CC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05116B0096; Thu,  6 Aug 2026 10:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7196B0098; Thu,  6 Aug 2026 10:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC986B0099; Thu,  6 Aug 2026 10:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6081A6B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:28:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01EC81A074F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:28:46 +0000 (UTC)
X-FDA: 85071075894.26.E4ACF4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35A65A0017
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:28:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P2CZHq/W";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786026525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRALKTV1zKMhBFx0Dmp3LzI+O3yS0lLJanyooXmsjYc=;
	b=JUSBOhl874E2HXL1mkWGq5OlnYrOg+2ONUJiuxKt3oH5/CsPWG/L8S54Z7bbfPVmEbX7v5
	0BNubtUoFF643DfdUcXGjhqqVClhNV3CsJ8zGojWxUqQxOEwq/Da9b1PL+jk5r1WL9B6dt
	7ijV/0Kp684QSjwEs0RCauZPzBSwqMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786026525;
	b=0SEyZ6itnAKz0i6lkcLAjy1XkIwzhfLuAJ/t28TeOWLsvIsyYJ85TwA2ty4bfzIXop3w9b
	RfgNIXnDAHTVcc4pp3MJEGQHwv26epZtK7/IuetM67FqtC5WT8JDFsCU6SVWfdUxH522jt
	aoaoa6LyJfaTu6hiqZzDxkFilfXvxgU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P2CZHq/W";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10CE340299;
	Thu,  6 Aug 2026 14:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785B71F00A3A;
	Thu,  6 Aug 2026 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786026523;
	bh=WRALKTV1zKMhBFx0Dmp3LzI+O3yS0lLJanyooXmsjYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2CZHq/WkTtMXOpcNiYIyEa8nU7OerOZT9LUJ/XDRMM5oEvQwPytKpSQFV0JGeHk0
	 Cyr6UVJZvPeWLm/GxOh5hM+1JXcMlHXNX0SY+H+Mw7Hm96z07lNyvmoCytOba2Rjsw
	 +wlwyoz1y8XQxUFpkIrqE436sCTMcMO1dZdoR+whb1yjjQZP3Rt3s7OvgUSu0duE51
	 4cPe6gGCG4YPZ2lAnklLhi9dn8iLH65esbMkvYnYwRz/CbbSjE1CwK/Obr2svtqVXX
	 ptV27F7DPPUNrSNzmYvaVgSc3GVahuL1SWqevaEZhhjvzx4YEubXffKgGU0lWqNa9Z
	 7+Ds2lZxDVZjg==
Date: Thu, 6 Aug 2026 15:28:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>, 
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anSZpAjt84Pn7O_b@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ynkd9tar9aqboqdn1z9m67yma83tdr8q
X-Rspamd-Queue-Id: 35A65A0017
X-HE-Tag: 1786026525-887176
X-HE-Meta: U2FsdGVkX18ddA8Dkc7RPa61A+vvVoRR1GnwitSQOJioGbyMpZyIIJxgjscgUuD/RwU98AFN1zIFtP7Y3FF6Cfx291t9ZblEUvmFUg2mOLrEDyglzNCsBmd2IGpBIUgSr42kwCdXsahAgOj9yH3ufYbu8T81YPjfX4HhgeMTYaB8kOcUQz+U1wcPxag1k3RBMHG+DbbhmUDkJfvrSF/KNfSLlb6CyfN2Ev8uY1BpfaCvcfZURInceXJhDTArjfRffdpzFVh4ChHrylwCSQ/dYHkRTEEluJqmadiHzKIcpu4LdoLPn/DmGBZghOy4QyI8G4iM+QvSotAhvg6lByRuaqmts+MQr3m9PIqJx6vKD6hBNsNMHZoHO4VhVsnzzR2tmp8QfcE1CSSDbDAtRjs11ZdaSfG6lAxh8pg1RnSXWJBamgCDpsPJqo0OmiFlzKbr/l3zY/BArc3CUKnjaLr8y55PL+MVBeOwlCK1c2w8bktPogWtfm/K3vR+/HgUiRsRkBimHx3Zrew8SEFpXs6UJFKs1n+Fjy8RWgl2IJARMbA8RiqqtTKVB03idL70jcNExGvhtQWkcK/xIyZFkusrTVhcdXRx61PwigJHw9c4HUe8Hd7orpDI3lvS30KpZS4yDikzQfx6DLDJTyMpZ/nuTs2oasV+GB2EMsDJLfnAPqGLfiDglU8keehRaeDUE1aR6pH29qMSh1DIH9SlLp+FeK/Ua+3vOwhAAVWxMbUnd+fqiHNSv0gbFdo1AEDgQtELhlGRij419JJwW71jZgtSXTZqsXkdR7GTCS2KKp5qaRo0TxCpjg2oEq3a5VEvdEzwKyU1Kv/3gMbPSf/mj22dFIOsic1ZDcz8ArQVJHbvLJNn9rr7VGwEorxeqTXcX70glFB9m3CuBpoH0n/+L62/O1djOJmvCt4Lzljo3xqULzDmQJdNGKYpP3ecmAIOMTGYuWTVW7dfbLQUC51qQj1
 AMKinq3H
 9eX+Ve9Au4U61y7dNDx7l4ixZwc9TgOUOqWFJ9GIBAdbIVnFaD1xHhfz+4+vGfwIYEcXMn3CYW0WFnA6JxieAY67BFIHOSAso0K/NCVheD6ez2r+jxQLhLCTgPm6zkgGm3/xTW7NRolI5XEF92NApwYOFRdfwnCQdZE7N5FWv34ItHoQeOPyeA8qvFPMrXrzEesYdBHX0SVk+2pyhiQhnsLA5eIeWAEgMQ8d963gMWQ0Qk5IFugqiOMQUQOE8hrYPRKRzGvmW2fs1YapUZ2NkrIq17EIIi/FX0jJF2Qqz6+TunKTDPOlWSxjJltsi8OZO26u2SLLJMFw6e3gRrdV+uVs4IaEzvweNtL1JV2PDVyism+2xe7XzucBGaFqg6s1Mn7PdES/tP0yYCENfoJ/EChspiTALcgQlkdxWdIIeNsKsyEdlb1ypnsrN7EawlG+Xv7StRuUtK3ayJgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:26:20PM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 07:55, Cédric Le Goater wrote:
> > From: Cedric Le Goater <clg@redhat.com>
> >
> > The global THP sysfs policy (transparent_hugepage=never/madvise/always)
> > gates the huge fault dispatch path in __thp_vma_allowable_orders() for
> > all non-anonymous VMAs, including PFN-mapped device BARs (VM_PFNMAP).
> >
> > DAX VMAs already bypass this check via an early return:
> >
> > 	if (vma_is_dax(vma))
> > 		return in_pf ? orders : 0;
> >
> > But "special huge" VMAs -- identified by vma_is_special_huge() -- do not
> > get this early return, even though they share the same fundamental
> > property: they map physical addresses directly into page tables and
> > involve no memory allocation, no compaction, no splitting, and no
> > reclaim. The THP policy has no meaningful effect on them.
> >
> > This matters for VFIO PCI passthrough of large-BAR devices such as
> > NVIDIA H200 NVL GPUs (256 GB BAR each). The VFIO driver registers a
> > .huge_fault handler (vfio_pci_mmap_huge_fault) that dispatches to
> > vmf_insert_pfn_pmd/pud, and QEMU's vfio_region_mmap() aligns the BAR
> > mappings for huge page table entries. Both prerequisites are met, but
> > with THP=never or THP=madvise, __thp_vma_allowable_orders() returns 0
> > before reaching the "trust huge_fault handlers" code.
> >
> > The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> > page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> > with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> > severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.
> >
> > Configurations that trigger this:
> >   - transparent_hugepage=never on the kernel command line
> >   - The tuned cpu-partitioning profile (inherits network-latency, which
> >     sets transparent_hugepages=never via sysfs)
> >   - transparent_hugepage=madvise (the RHEL default), since VFIO VMAs
> >     lack VM_HUGEPAGE and QEMU does not call madvise(MADV_HUGEPAGE) on
> >     BAR mmap regions
> >
> > Extend the existing DAX early return to also cover vma_is_special_huge()
> > VMAs. This is consistent with how vma_is_special_huge() is already
> > treated for supported_orders (grouped with DAX). The mm/Kconfig TODO
> > comment "Allow to be enabled without THP" also acknowledges this
> > coupling is wrong.
> >
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Claude:claude-opus-4
> > Signed-off-by: Cedric Le Goater <clg@redhat.com>
> > ---
> >  mm/huge_memory.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 58cabe6af33d031e48250e21db51506bc46c97b2..6dfef5500a054f09f9ece6df8bf7a0194624350f 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -139,8 +139,12 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> >  		return 0;
> >
> > -	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> > -	if (vma_is_dax(vma))
> > +	/*
> > +	 * khugepaged doesn't collapse DAX or special huge VMAs, but page
> > +	 * fault is fine. These map physical addresses directly — the THP
> > +	 * policy is irrelevant for them.
>
> emdash in a code comment?
>
> Then I spot
>
> 	Assisted-by: Claude:claude-opus-4
>
> and really have to shake my head.

Ha, I missed that!

Well all the more reason for me to take over this patch... :)

At least the AI is acked here (appreciate that at least Cedric).

I think the _actual issue_ is valid at least. The huge pfn stuff did seem to
completely miss this aspect of things.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

