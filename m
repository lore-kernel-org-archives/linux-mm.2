Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB857606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UcB6K23C
Received: by kanga.kvack.org (Postfix)
	id D9BC76B05CC; Wed, 28 Oct 2026 11:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA9D6B05CD; Wed, 28 Oct 2026 11:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7876B05CE; Wed, 28 Oct 2026 11:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 991886B05CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 284351A0165
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:46 +0000 (UTC)
X-FDA: 85372467852.10.6D24BCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70932A000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcB6K23C;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202524;
	b=N4GzCVGjt3WEyVRl+97tCegERmh4XKg8CVDszK6f2g9+Qy9+PcCsLG9TAZKZgZHcxP9oU3
	ODCaYH9Ay268fM6KP8YY3v0lwkPqUVQpWZA7EY2HSWtD7KxcgrQhOQ8sItk8cfEKBVzTtJ
	yC6qqTAqVINsp+GBjMCieuPrR2uYgLE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UcB6K23C;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202524;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WB+g+Slbuqa3OAFsR/L9R+koPQb3pE6dF2HAbJEZAnQ=;
	b=pBZ+LBWuyMlvNxfq/uKX52axdjCO1D7kOvJ/ZF4AAurMhgxeq8Jh68opwjVUgp7KbkaIfV
	q/KCjHmZC2C+hCFTcsnHk/HgUPKJg7/l9J3UVvLXV8JxWmrKKO0aXqMG8Vw/oF0EgTnpbt
	78p36XeeQTsLzB9IlJa5Lqz0sVWM3Fg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C159743D62;
	Wed, 28 Oct 2026 15:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9361F01825;
	Wed, 28 Oct 2026 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202523;
	bh=WB+g+Slbuqa3OAFsR/L9R+koPQb3pE6dF2HAbJEZAnQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UcB6K23CVpLO8P10LHZqJX9STIGFLjDAkR4Z2JOHlTMmVdxlQK1gQFGZQ5YZBKNrZ
	 GCsvWHVAJt+/YfJhux+cVn7zLG+hYDgRYSKLht5Wy39cUp1bY8FnS1rkxBXKggmW8+
	 ufYcdx0lrb8+8W3bM0Qz7iQFN2vFi3ms6sG7ySHH64j2eNEbU+T7CJ89yGdVAicFMu
	 qbdNAjTCJ7yV9IkMmA1VBtbHgsF9ghrif1/gRYoJ94Nsr6G+WmcxfYKJVRKLLRpFCM
	 MKLDmU9vUZGGP+Ixtq08YhHNec4bMivEO9QLU5mxPymN0FAqYuIFd6FmhSNn64j3WN
	 +q/asZnjvgo5Q==
Message-ID: <sashiko-outbox-188089@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 07/14] KVM: guest_memfd: Update exports when pages
 are allocated
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
In-Reply-To: <20261027154649.91571-8-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-8-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:40 +0000
X-Stat-Signature: 4fickkpzstt11hhbxhyz7kda1p189isk
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 70932A000E
X-Rspam-User: 
X-HE-Tag: 1793202524-550892
X-HE-Meta: U2FsdGVkX1/ZIeW/8gxwY3llD1nbJ8DT+4Y2uylnmrpSOjjYTTjAXqKfrfZ2FJXNTXBPQj5CSCdZS9v3te+9xBfdAngN0pXxl9uwvnRBRTVqgjVTNA0CGzXFGxtf+If0UetJr0AnQSXbWq3qld2jlGC2sFF6UkNrhgg4cronw+zvz05J3gTUWCF28P7vXgVtep6et6E3D30nYEXEN0UPS59Q4N3BbarK9ZCnmyqF3MVG0rmtEsGp6qCPtRllrr88FyWhmHE7/ZM+aYzaYayqHOhV7TZufA1G58KRWeOWQPox8dLp5BdCmeDJJCOq3i0sgkiWAJlXYF7y/LpI/Eo7iUCIel7dQVndkw3X38teyQGgDJ95IRZzdK14kPfCknprA8PvDYw9Whh2K08n0MlqegmDyOpNBPv0iDG/tH57JD3HIke+PYKTVn5K4GOSBHH2c6EQv9UjqABd3kcvXean7gi2A3Xt3hQA7PlH/8oQVjs6bu0j5yM8fL8i2LiiZ9/p7UykSCE3DcLui8y54oQ1mJoD7chiXGGYDiQWDD+rU20FzDkZOLAif/sHRV58PTt0CLe55V6kx9mMbwhe0WINkBr4LJS0xQTvzaUVVOgAo10zRoFuOW04drm4FKu0rfw2JLysxE6YwlK9g/9PI7xIP45itSi7SPuuRcyUygvmpssp2A5kCIeRqsQ4jt/9etXMFqkdXpzfPouczaYPStPup7mNXHA+yYB6Vs+w2pwynDFE3dHZL1InfAEGSCMRk3M4uVQ+PSH0FJOfi7TgTvsJzKIXax0CI9luo48E1TnDnDEqiBDykC9bt4ldBINikrIXfiRm1ILVAttTbsNNMJcM4ToP9C+qSgbSs134qjN6A93+NfMdB3Ai43zKcYMDc0Sg/pHJMX1Z6xgA2ip5phGnUXXseKBtDUYB4oxvFO1Nq5WGGtHu3zGzI7udaPkA4KIaDIVLMcEcT8VLB9Jvzj4
 SuQks8uT
 3YDGHhtM4CDqByhGuai/xemombb515/MnsdFdtmzzDOsjYKc/UVjNjSq60d8iQyAn9QS5/U9udepIzDR30bleiOsagv+GoOshaAoiH7dnj8g9azvu6xAtqk+FMioeDPWnQxa7CySI1I6WjDArjPU3ItoXQl5XISP/tWqBOFMkWyJmJ1Il1giwA5imuCR692t/1Y4LhFXpPyttdg3QCXqVEbA+kZsXEOnQLzEtQMPbJ+1tSO3aH0p0ibsVU2vhsoCpBaf5a7HslPMK2d+9rBiw52sxSa71u/qYpqJQvEd/1CPqrIeCfuefEFY9Ng3LJhGPWosOtDb/NYJ9PTNs7Y+VxPFdlKLvugMYv0InEKvhlbxZ6hKjafsTKkvk2GW0SxRzTTjXT/4rIqwbsZ+igLdVd+TKNhD54RHEJhBx3Uhuobs9DZOJbTio2eBY8tEDnM167LvRTKdiqSDQLQYCMsvewxr1ugGb9ONLcaKGMyH5g9x3yXd/kso733sdhD8Rd+3/6tMXKIe+PTlrzrM7WKdojLU2R1x+0CvW6BPWu1px+2wnuU+EM/YbNGMr++DwwY8zd4070fejl6rLkvW0BWO1fukBi7hr3VOrJqDisD9HuLMUK0QKKg/HFKaX4as0VcGeuYq14hvRWD3OeV7fAbvHJOU7RXXzhWs6rX0T0NiXJF+MwFqGC31k05q1jydyFQnqvMKwG4PUoSqQBANv8XgE9hUvebpsgzwqOqHd0aXPWUQ0taU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: guest_memfd: race between lookup and export update in kvm_gme=
m_pfn_get()
- [High] KVM: guest_memfd: missing export update in kvm_gmem_pfn_mkwrite()
--

commit 4b6454858c8ba7cdab87cd12917c8977ac8eab47
Author: Fred Griffoul <fgriffo@amazon.co.uk>

KVM: guest_memfd: Update exports when pages are allocated

This commit updates attached exports when guest_memfd pages gain backing
memory via host faults, KVM get_pfn(), or fallocate(). In folio mode it
zeroes newly allocated folios, marks them dirty, and notifies exports under
the invalidate lock, while in PFN mode it checks if the page was a hole
before get_pfn() and updates exports for the populated block.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1c5826c5384ed..42bb5f263e234 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
[ ... ]
> @@ -590,6 +592,64 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t sta=
rt, size_t nr_pages,
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
> =20
[ ... ]
> +/*
> + * get_pfn() in PFN mode, which may back a hole: then tell the exports a=
bout
> + * the whole block that get_pfn() reports, as the provider may have back=
ed all
> + * of it.  Called with the invalidate lock held.
> + */
> +static int kvm_gmem_pfn_get(struct inode *inode, pgoff_t index,
> +			    kvm_pfn_t *pfn, int *max_order, u32 *attrs)
> +{
> +	pgoff_t npages =3D i_size_read(inode) >> PAGE_SHIFT;
> +	struct gmem_inode *gi =3D GMEM_I(inode);
> +	bool hole =3D false;
> +	unsigned long raw;
> +	pgoff_t first;
> +	int order, r;
> +	size_t nr;
> +
> +	if (!list_empty(&gi->exports))
> +		hole =3D gi->provider_ops->lookup_pfn_range(gi->provider, index,
> +							  &raw, &nr) =3D=3D -ENOENT;
> +
> +	r =3D gmem_provider_get_pfn(gi, index, pfn, &order, attrs);
> +	if (r)
> +		return r;
> +
> +	if (hole) {
> +		first =3D round_down(index, 1UL << order);
> +		kvm_gmem_update_exports(inode, first,
> +					min(first + (1UL << order), npages));
> +	}
> +	if (max_order)
> +		*max_order =3D order;
> +	return 0;
> +}

[Severity: High]
Can concurrent calls to kvm_gmem_pfn_get() race between lookup_pfn_range(),
gmem_provider_get_pfn(), and kvm_gmem_update_exports()?

All shared-access callers of kvm_gmem_pfn_get() -- kvm_gmem_allocate(),
kvm_gmem_pfn_fault(), and kvm_gmem_get_pfn() -> __kvm_gmem_get_pfn() -- hold
inode->i_mapping->invalidate_lock in shared mode via
filemap_invalidate_lock_shared(). Unlike folio mode, where
kvm_gmem_get_folio() returns a locked folio and holds the folio lock across
both kvm_gmem_folio_zero() and kvm_gmem_update_exports(), kvm_gmem_pfn_get()
has no per-range synchronization across the lookup, allocation, and export
notification steps.

If thread A calls kvm_gmem_pfn_get() on an unbacked index,
lookup_pfn_range() returns -ENOENT (setting hole =3D true) and
gmem_provider_get_pfn() populates the backing frame or 1UL << order block in
the provider. If a concurrent thread B calls kvm_gmem_pfn_get() for the same
index (or another index within that newly populated block) after thread A's
gmem_provider_get_pfn() completes, but before thread A finishes
kvm_gmem_update_exports(), thread B will see lookup_pfn_range() =3D=3D 0
(hole =3D false), skip kvm_gmem_update_exports(), and return to fallocate(),
the host fault handler, or the guest vCPU fault handler while the export's
IOMMU mapping is not yet installed.

Conversely, if both thread A and thread B call lookup_pfn_range() before
either thread's gmem_provider_get_pfn() populates the block, both observe
hole =3D true. After thread A finishes kvm_gmem_update_exports() and returns
the mapped page to userspace or the guest (which may immediately start DMA),
thread B will run a second kvm_gmem_update_exports() on the same block,
causing export consumers such as iommufd to unmap and tear down the live
IOMMU mapping.

[ ... ]
> @@ -819,7 +881,7 @@ static vm_fault_t kvm_gmem_pfn_fault(struct vm_fault =
*vmf)
>  	u32 attrs;
>  	int r;
> =20
> -	r =3D gmem_provider_get_pfn(GMEM_I(inode), vmf->pgoff, &pfn, NULL, &att=
rs);
> +	r =3D kvm_gmem_pfn_get(inode, vmf->pgoff, &pfn, NULL, &attrs);
>  	if (r)
>  		return vmf_error(r);

[Severity: High]
Should kvm_gmem_pfn_mkwrite() also call kvm_gmem_pfn_get() instead of
gmem_provider_get_pfn()?

In virt/kvm/guest_memfd.c, kvm_gmem_pfn_mkwrite() still calls
gmem_provider_get_pfn() directly:

static vm_fault_t kvm_gmem_pfn_mkwrite(struct vm_fault *vmf)
{
	struct inode *inode =3D file_inode(vmf->vma->vm_file);
	vm_fault_t ret =3D 0;
	kvm_pfn_t pfn;
	u32 attrs;
	int r;

	filemap_invalidate_lock_shared(inode->i_mapping);
	r =3D gmem_provider_get_pfn(GMEM_I(inode), vmf->pgoff, &pfn, NULL, &attrs);
	...

When userspace writes to a present read-only PTE in a shared VM_PFNMAP VMA,
handle_pte_fault() -> do_wp_page() -> wp_pfn_shared() drops the PTE lock via
pte_unmap_unlock() before invoking vma->vm_ops->pfn_mkwrite(vmf):

mm/memory.c:wp_pfn_shared() {
	...
	pte_unmap_unlock(vmf->pte, vmf->ptl);
	ret =3D vmf_can_call_fault(vmf);
	if (ret)
		return ret;

	vmf->flags |=3D FAULT_FLAG_MKWRITE;
	ret =3D vma->vm_ops->pfn_mkwrite(vmf);
	if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
		return ret;
	return finish_mkwrite_fault(vmf, NULL);
}

In the window before kvm_gmem_pfn_mkwrite() acquires
filemap_invalidate_lock_shared(), a concurrent hole punch via
kvm_gmem_punch_hole() -> __kvm_gmem_revoke() can acquire the invalidate lock
exclusively, unmap the PTE, notify exports to unmap the hole, and release
the backing frame in the provider.

When kvm_gmem_pfn_mkwrite() then acquires the shared invalidate lock and
calls gmem_provider_get_pfn(), the provider allocates a new frame for the
hole without calling kvm_gmem_update_exports(). Afterwards,
finish_mkwrite_fault() sees that the PTE was cleared and retries the fault
through kvm_gmem_fault_user_mapping() -> kvm_gmem_pfn_fault() ->
kvm_gmem_pfn_get(), where lookup_pfn_range() finds the frame already
allocated by kvm_gmem_pfn_mkwrite() and sets hole =3D false, leaving the
export unmapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D7

