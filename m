Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE15606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YXF/YS7f
Received: by kanga.kvack.org (Postfix)
	id DEB646B05C9; Wed, 28 Oct 2026 11:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2BD6B05CA; Wed, 28 Oct 2026 11:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8CC6B05CB; Wed, 28 Oct 2026 11:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3C126B05C9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32DA5120162
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:35 +0000 (UTC)
X-FDA: 85372467390.16.AB74E83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 938B1180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YXF/YS7f";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202513;
	b=GB72iGzR3joH2a77GKVq0Kw7/m5UU100UnVZjeBKk2VWdYrLGAoVsSrPzjF0r9vjTX/f/+
	YYV88sRoj96KKzurBXPNdnBdavOh1duoq7/N+4rXm2W5rkNZeOBk2Kbky12VPI3/ueRQVH
	6qPp1ojnceg57XnSAn0YYNu3TH1Yk8g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YXF/YS7f";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202513;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9FswEhsqUAoLXxb6XOa2/ngLfV3IiEobglb2Mjl9Jk=;
	b=CmkBXKBjMBXIMuRaQvmTSK1kHqsZ1oZMaGIoFFhbeVZxjk2Yx+kWfiiGHj7tm1ONVuck4r
	5D+EaFsmvyl4NDhL5S80frf4iOg3oFxiDxE9iT1E0hKanpJ7kFUEtQ0PXqYnzO2GzA5nCx
	yt2aepmfhPhKA8hWa0vogI7jumDhmik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BD360120;
	Wed, 28 Oct 2026 15:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B892D1F01825;
	Wed, 28 Oct 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202512;
	bh=r9FswEhsqUAoLXxb6XOa2/ngLfV3IiEobglb2Mjl9Jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YXF/YS7fng8zjqrLjdH5iyQ3VtTk694E54InSg6ZCq2Po2lu6Tl3KPfgTskghyOHw
	 +tc5CQszyYHPABEu5Ly/SoIX4Hv5TTtzZ9ohtRnQgvjTuHIM8MovQwhqfIrGMdQTBU
	 AR/gNbSU7BuctmXhLyLvLfUT3tJdh0NGQLxefh9WV49CMjIv6F4ki3QiDlqIQRwhnS
	 u2BVaodJveIi7n7VdS0Aqof5m1QS+dixs5N+fD5PmvvJWhN+KTCz76JuFTspKhpgCE
	 v/hm5KUX4xGEYR6odAjuPlfluIz8hjBrNuq8+9z6hDxyhXtudTYKB9xfApLX4Fl9M0
	 OiZjatYBTurDQ==
Message-ID: <sashiko-outbox-188083@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 01/14] KVM: guest_memfd: Clamp the order of PFN mode
 blocks to what KVM can map
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>, "Ackerley Tng" <ackerleytng@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Kevin Tian" <kevin.tian@intel.com>
Cc: "Alex Williamson" <alex@shazbot.org>, "Alexander Graf" <graf@amazon.de>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Alexey Kardashevskiy" <aik@amd.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Baolu
 Lu" <baolu.lu@linux.intel.com>, "Bill Wendling" <morbo@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Catalin Marinas" <catalin.marinas@arm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Gregory
 Price" <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, "Hugh
 Dickins" <hughd@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jianxiong
 Gao" <jxgao@google.com>, "Joerg Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John
 Starks" <John.Starks@microsoft.com>, "Jonathan Corbet" <corbet@lwn.net>, "Justin
 Stitt" <justinstitt@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Robin Murphy" <robin.murphy@arm.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261027154649.91571-2-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-2-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:29 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 938B1180003
X-Stat-Signature: 1xwtz6osqujcp5pp3tgy7deq3qpdda8n
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793202513-658222
X-HE-Meta: U2FsdGVkX1+ha47MZI9P+/ntNqY4qM8+Xw12XQ5EOKP4avLp6pH+2NDqh/kMi9Bi8CoRngCLk645L8PJ86G0ZTXB4qQ3AIhwET1DfnC+YIwLZWjLIEYptUXRIXaIrWPqFw6RSkmQ87rv+LT9Gwwx/v8v97AI4DxXK4tPdJTemhE7Hh6OUVC28CrMNRlaGUgoLjya7mOc+83zzu3NDHuSGTtqlv7g68cFVAz8gE8k16+eIRhAmL6f/27Ig1sST/X6iOqG0wkJLd6MELqwMN8FcZQuG0bIgO0fXoAV4QBPr2ylmFKeUp3Oz3IYP0xVjEidtadd1e5ar7zuh6Bg4iITCSnZWJQN/XOAtAyxxUiOLZzEhuxuRNsXslTrc9r9reHJxXhAWHnh4Qz1y8BZnxoKB6bsGRrHtgafF2IcR3xC1BOLeIw5iXj+q71SoWluItYBZk4IZQ1V1txzUUWafsGOtvqwklth2PX8HL1Ztj8XNR7loAfSd0XHSx5o1B+e1fl1m+Qbr//VuCR/albwQvaETQcx3UI2269aM2gALSHgHAUL0/cehLtZeilaYkN3ick9ZbRKSE4TtSwFSMVaR/Ap4Ab3eso0PSAOJxY1spoUbQ+Z1HG06H0nYXxAcF6IajeFmanQb/bf50ezqtKypnZPW1nvI86gqtterHGBIYYPItP7qHSMZad5QP/llw/ONNWzyvsUXe61WkGHq5X67ZS/84ctkAnvwZ7BZLdaHSdNy9n7v1PDJjzihUu4/6MddHw26TfK+DMDEvIc0ZwT1oZgeOBoiPMhspe0zBJGwWH3iIZNPlqpS3C/yKcE7p70pVYYrGYbUWEBsPRuCLVrq1qfzDFPsCN+He3eS+NQ0Nm/U3R3Oey7P2GsNJHWS0Qddfmx0Hf5F1kCy7GZucVwiGadFf2kN8fhN3lLTosyhZiA1Deodved5t9JPuWJ5EB+scjws1DgpCVEA+LcNk+jfOV
 O61nCu//
 /F71JibqwrZsAE4B8uxf2YH6h0p2Va9n/HYbR8hobdYTEAGmg16H/ikiDZFMOVGHGHFZK5x2yKurVxqVv0AAG7gw8KBU9XalfIYKJXffEl635tuzh+MieaFufTvHHGo2yXOVPgQWB8nxtWVGBiBDx5K4WPS0RhB8kUW6ASIOoG1PBkMB7v0gq4k6QZGoN4aNSwksDqYFZ1o0H8Vq9nCxVc2XXXBGnzqT+jQantRdbzhAv2h7NPmCzf6kd+itKB3HekoDUn0h6DefTVLBZ5P5obZXaiGlrTdGhAYcPl+wxITWjIjAMeca9qR+ZQzcDlDJLhd7lkrsB4OjhvmLY1GxaSpOLG0TWsv9GF3OkFJOoGlLzji/gCSMJN+uMsGsXTs4kKGlVn6WH6neKRkMLk9sevwHpbtfgzHSckC+ryBimDR7D/pf6hprYxMUBrl4TZTMZVUsmPuVFmyzptIvXn5ZtQkNOrURLOBFkkR/nzWD42sBWyA+RhJqFHTS+4kcnLBmiBObxI92nwd2bwmU2KctiSejo0dCMO49pEVrpxhM9CaF/O3WBY1MLgFhHt09gc2Y5gPhtqZgz56Jd0+FmQcROGCx+LZr8iySQAZS8QTeYqUC/GJEaoYhuyncXVtoh7s9cAvVJqiuUCwYxKdhGuFieRfmAj4ef/ikbIFc2D+ypRooOW4eIpXLMgZRDS5U7BvcXiV9JYEWSVM4FQ5BaqqajMMGCyOQ+fi0rBAqORrMBoiEyPBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] kvm: guest_memfd: race in __kvm_gmem_invalidate_start() due to=
 late range expansion
- [High] kvm: guest_memfd: infinite loop in kvm_gmem_pfn_map_order() when P=
UD_ORDER =3D=3D PMD_ORDER
- [High] KVM: guest_memfd: non-zero order passed to kvm_arch_gmem_make_priv=
ate()
--

commit ec431028c58523e8ac8bc3e4a0b8d9a1a1868bb2
Author: Fred Griffoul <fgriffo@amazon.co.uk>

KVM: guest_memfd: Clamp the order of PFN mode blocks to what KVM can map

This commit clamps the mapping order returned for PFN-mode guest_memfd
files to block sizes supported by KVM where the gfn, file index, and pfn
share the same alignment and memory attributes. It also expands invalidation
ranges in PFN mode to 1G-aligned blocks so concurrent faults on the same
block retry.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3c4bedceccfc2..be26bd16d4207 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -355,6 +360,16 @@ static void __kvm_gmem_invalidate_start(struct gmem_=
file *f, pgoff_t start,
> =20
>  		flush |=3D kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
> =20
> +		/*
> +		 * In PFN mode, a fault may map a block of up to PUD_ORDER
> +		 * pages, sized before this invalidation (see
> +		 * kvm_gmem_pfn_map_order()): make faults anywhere in the
> +		 * blocks around the range retry.
> +		 */
> +		kvm_mmu_invalidate_range_add(kvm,
> +					     round_down(gfn_range.start, blk),
> +					     round_up(gfn_range.end, blk));

[Severity: Critical]
Does expanding the invalidation range after kvm_mmu_unmap_gfn_range() leave=
 a
window where a concurrent fault can install a stale huge mapping?

In __kvm_gmem_invalidate_start(), gfn_range.may_block is true. When
kvm_mmu_unmap_gfn_range() runs, it registers only the unexpanded
[gfn_range.start, gfn_range.end) in kvm->mmu_invalidate_range_start and
kvm->mmu_invalidate_range_end before calling kvm_unmap_gfn_range():

virt/kvm/kvm_main.c:kvm_mmu_unmap_gfn_range() {
	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
	return kvm_unmap_gfn_range(kvm, range);
}

Because may_block is true, kvm_unmap_gfn_range() can yield kvm->mmu_lock
(for example via tdp_mmu_iter_cond_resched() in tdp_mmu_zap_leafs() or
cond_resched_rwlock_write() in __walk_slot_rmaps()). Meanwhile,
kvm->mmu_invalidate_seq is not incremented until kvm_mmu_invalidate_end().

If a vCPU fault on another gfn in the same 2M or 1G block already completed
kvm_gmem_get_pfn() with a large *max_order before the invalidation began, it
can acquire kvm->mmu_lock while kvm_unmap_gfn_range() has yielded the lock.
At that point mmu_invalidate_retry_gfn() checks only the unexpanded
range->start..range->end and sees the old mmu_invalidate_seq, so the fault
will not retry and can install a huge SPTE covering the range being revoked
or converted.

Should kvm_mmu_invalidate_range_add() with the blk-aligned range be called
before kvm_mmu_unmap_gfn_range()?

[ ... ]

> @@ -1535,6 +1550,44 @@ static struct folio *__kvm_gmem_get_pfn(struct fil=
e *file,
>  	return folio;
>  }
> =20
> +/*
> + * The order a PFN mode block can be mapped at: the provider's order, no
> + * larger than the alignment of @gfn and @pfn to @index allows, rounded =
down to
> + * a page-table size, and never over pages that are not all shared or all
> + * private, since KVM maps a block with a single attribute.  Called with=
 the
> + * invalidate lock held; an invalidation of any page of the block makes =
the
> + * fault retry (see __kvm_gmem_invalidate_start()).
> + */
> +static int kvm_gmem_pfn_map_order(struct inode *inode, pgoff_t index,
> +				  gfn_t gfn, kvm_pfn_t pfn, int order)
> +{
> +	u64 misalign =3D (gfn ^ index) | (pfn ^ index);
> +	u64 attrs;
> +
> +	if (WARN_ON_ONCE(order < 0))
> +		return 0;
> +
> +	order =3D min(order, PUD_ORDER);
> +	if (misalign)
> +		order =3D min_t(int, order, __ffs64(misalign));
> +
> +	if (order >=3D PUD_ORDER)
> +		order =3D PUD_ORDER;
> +	else if (order >=3D PMD_ORDER)
> +		order =3D PMD_ORDER;
> +	else
> +		return 0;
> +
> +	attrs =3D kvm_gmem_get_attributes(inode,
> +					mtree_load(&GMEM_I(inode)->attributes, index));
> +	while (order &&
> +	       !kvm_gmem_range_has_attributes(inode,
> +					      ALIGN_DOWN(index, 1UL << order),
> +					      1UL << order, attrs))
> +		order =3D order =3D=3D PUD_ORDER ? PMD_ORDER : 0;

[Severity: High]
Can this while loop hang when PUD_ORDER equals PMD_ORDER?

On arm64 with 2-level page tables (CONFIG_PGTABLE_LEVELS =3D=3D 2, such as =
64K
pages with 42-bit VA or 16K pages with 36-bit VA),
arch/arm64/include/asm/pgtable-types.h includes
include/asm-generic/pgtable-nopmd.h, which defines PMD_SHIFT as PUD_SHIFT.
This makes PUD_ORDER equal to PMD_ORDER.

If a PFN-mode block of order >=3D PUD_ORDER has mixed shared/private
attributes, kvm_gmem_range_has_attributes() returns false and the loop
evaluates:

	order =3D order =3D=3D PUD_ORDER ? PMD_ORDER : 0;

Since order =3D=3D PUD_ORDER is true and PMD_ORDER =3D=3D PUD_ORDER, order =
remains
non-zero and unchanged, spinning forever while holding the shared
filemap_invalidate_lock and kvm->srcu.

Would checking order > PMD_ORDER instead of order =3D=3D PUD_ORDER avoid th=
is?

> +	return order;
> +}
> +
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
>  {
> @@ -1556,6 +1609,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_m=
emory_slot *slot,
>  		goto out;
>  	}
> =20
> +	if (kvm_gmem_is_pfn_mode(GMEM_I(file_inode(file))))
> +		*max_order =3D kvm_gmem_pfn_map_order(file_inode(file), index, gfn,
> +						    *pfn, *max_order);
> +
>  	if (kvm_arch_has_gmem_convert() &&
>  	    kvm_gmem_is_private_mem(file_inode(file), index))
>  		r =3D kvm_arch_gmem_make_private(kvm, gfn, *pfn,

[Severity: High]
What happens on SEV-SNP when kvm_gmem_pfn_map_order() returns a non-zero
order for a private range?

In kvm_gmem_get_pfn(), *max_order is now preserved up to PMD_ORDER or
PUD_ORDER in PFN mode (even when the caller passes max_order =3D=3D NULL, s=
ince
max_order is redirected to &__order), and then passed to
kvm_arch_gmem_make_private() as:

	r =3D kvm_arch_gmem_make_private(kvm, gfn, *pfn,
				       (kvm_pfn_t)1 << *max_order);

However, the x86 implementation in arch/x86/kvm/svm/sev.c only supports
single-page conversions:

arch/x86/kvm/svm/sev.c:sev_gmem_make_private() {
	if (!sev_snp_guest(kvm))
		return 0;

	if (WARN_ON_ONCE(nr_pages !=3D 1))
		return -EIO;
	...
}

In addition, gfn and *pfn are the faulting subpage's frame numbers rather
than the base of the aligned 2^(*max_order) block. Won't a PFN-mode provider
returning order >=3D PMD_ORDER for an SEV-SNP guest trigger WARN_ON_ONCE() =
and
fail with -EIO?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D1

