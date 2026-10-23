Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D8A606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JR8lD4D/
Received: by kanga.kvack.org (Postfix)
	id 06B896B0BFF; Fri, 23 Oct 2026 19:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39536B0C00; Fri, 23 Oct 2026 19:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFEA6B0C01; Fri, 23 Oct 2026 19:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4B906B0BFF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 855DBA7738
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:59 +0000 (UTC)
X-FDA: 85355491158.18.6D60060
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF00514000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JR8lD4D/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798318;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+diKSILau60FQDUjTdx5UoHodS14mwn6X+vaOuVd5hE=;
	b=AuZeBLQx1Ur55qTr5/wF+xciKMQleMJO2DjOD7iXPW5FjAXAU00IsqY7c48SjAuMzRseh0
	dpiMjvNQPryRd5ZWxAoxU+2b5/CvuI2BaS8hTAwMKM2cCuCFTjNEVyPV4+hex0IbqaJL8/
	z7xIvvycl8d8SFBHjRSTpjwOb159pLY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JR8lD4D/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798318;
	b=RXQt+gOJsBt/4nLnXf3ApZvcijJlzeAJ4JecdESqRZLfuQ2Vpkwo8nZUPdyVdydUq9E98K
	8Zndagq5TsJPqqkVM8J/drQ73Yw3LyZwjdkPeBr7LYPyRysinw3bBQyeyTdUcWa6zeTS80
	Is20Jl4Vh+x66gXIusMBTOwnDjDNZs4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 493B54373D;
	Fri, 23 Oct 2026 23:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE331F01825;
	Fri, 23 Oct 2026 23:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798317;
	bh=+diKSILau60FQDUjTdx5UoHodS14mwn6X+vaOuVd5hE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JR8lD4D/r1IhwFw1MhkSvd1DkDY0zntfswkkDdRv/iTkfCFqBtZDl8VJGGPOIGOhM
	 8PqWe9K/G2bjpgOfVuwf1GeJbJCQcVNHoWm+y4zHjjs4y3LpSZyR9NZpC4+CZ7UqIf
	 m9pg1vGPP1VnAEEeQitl6TDQ3ospeQmJjRedL6ArPVBsww/7sWeBcjvoqHu0HZm7s1
	 EoipNtOU5W4CS6gZlCd4qLAwctsk0YzgU7/2DwPoeKDC8xEC1AU8rQMmC+Hr2EhgZ+
	 DC/4ITE36fSobAYbxtVOak1EJ/V6kBlHRaJRKBwDbFViWzjaAxOVdiBLRhx+b8DkR2
	 kuhLvBskE0sZg==
Message-ID: <sashiko-outbox-183370@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 06/50] KVM: selftests: Add helper to create
 guest_memfd with a resource file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alex Williamson" <alex@shazbot.org>, "Alexander
 Graf" <graf@amazon.de>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexey
 Kardashevskiy" <aik@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Ashish Kalra" <ashish.kalra@amd.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Baolu Lu" <baolu.lu@linux.intel.com>, "Bill
 Wendling" <morbo@google.com>, "Borislav Petkov" <bp@alien8.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Brauner" <brauner@kernel.org>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Fred Griffoul" <griffoul@gmail.com>, "Gregory
 Price" <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, "Hugh Dickins" <hughd@google.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jianxiong Gao" <jxgao@google.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John Starks" <John.Starks@microsoft.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Justin Stitt" <justinstitt@google.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261022-gmem-alternative-providers-v2-6-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-6-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:31:53 +0000
X-Rspamd-Queue-Id: DF00514000C
X-Stat-Signature: fg17rusmyjhkt5367xcgguoorrzyx1c3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792798317-400814
X-HE-Meta: U2FsdGVkX18KWRvLPVwJcU1d9qfn0HVxkias9URJ8FChn8an1H+thHwImOQwgXSjsyRsvhKSmHgghbI5W54+jNJ8XjVmSPE5qWzvPPoKR3uXXp3A1wIf8xEz1fbmYbvlEbCQb+4PEYeJ4R7diErZYthQd1DrmRMOEMQu+LTA0DsF+vW6Y8rq/JM4fmvT83brbRZFkn/i6MnVfG6N6DrEdnayFpDBVPxQrvC1U/gn5e+WYj0BeBeXfJ55wsKGRp7BGLJsYV2G3OesorjCEILGTrTJn2MK3gBYBzATAjtzLOlwPflwZ5L2D8Lx3GmHlUs4w2Ucdaw8wuSoNWEGP2VDYbcCPkLpySdGZdFdpXJTl4RNpGNlUxmaCDmnN3K86N7LlxVAH9ji4EOshUNCLDV76fgnK0Kgx1WWf/FGPHd8wl56XRv7CKdHXAxkfOvw5VFmHGateHkF/ENjBGjXzTPN3P4l4e4eF1tf2T1tg+wnuzqXZDJsKnguuzCFBFTqFmwuECMHGE3G0K35nt8499ZL5fIcuNqfnszbKr5/GPBfZSU4nTsLnNnKVQ7LICAUOgHDWwCJZjwowHdgvaxhB8z54lqxdZY9qoQW9uRmuadfTuBiOPxIWE3A4NfqW3sew8hypdVDDkGoh5fkeXiXq0hP8EfXx4MdQTR4Z1g8VHtKXWE1MTsitvGE3TyaNZtL1q72f7ujbjOe/ROK+HK8mcqW1czcYuwvUZla+0+cqx4DXo4ZtVM/Mp+uthASAuZwQE0qmenvjmp0FCpT1Rbrktq+xKOKR+elWpY3KpfkPOPK9RpoTKSe0w2abwwZ1W5BOSFvyPMLYc86uydoYm91u+jfDYN0D0RLdBhAEsLwyCwc2W3Ju9mjSgjjTsOfnT7pKkU7L8BhJZhJqf+b4Ll8spaksfx/rJpQWltsgjBnX8jzZtdPYnpL0cmFmvsy0+Y2A57PfC0/Lkdu5w8n71B1ZxH
 Ff+6aAjO
 aAmVxOhhuvYVZYNFuZwu+RPXgR29Lnp01KEZV9+hQJgbIc50WCDQb2NAuHDqkh7e6AlAmfXE5DsVTjbb0HyPtfsj+c2Lk2rXsZUzz/Fsir/AXbQphfeI1wuLEdSeWKbtrLRjYYFMl4Vrp3ozk5Ql2x33OFK1GK4g4KejW6O9gSciKIlYkoKputjias+erUhykK2CWr5m8sSIiwPeLc1gcBIqB5Qta2fUIov93G7vHW28qivSr++JTQ4QVwFtXns2pmLkDI901lfb9v/LLsNBkbzqlR9ebAbZJLFPFqQ7fIibGgY6/UvoR4RUK47NLrklbgifjM+SIzDlfcXH8p9n5sRyjg8IDA4bDJILFYXT/dx5Qvm6Hg1b8C9FgksDB/dhuakBLeym0FiQrXCzY7B7O+2UfVv6/+w93CY1NLFXXOTSMU2/d/XQc7wWHPeQt5iw2WdJ7ROxlI6Xzl9ydSrFlJDLA+jIpXwCc8hA1ql6L9n9sTDyf9fhSiCcb5vgis1LoAtnr2YHkU7Ijt1TujgrF9j/plNofjq9BF1eZuir31z9H1shN/cCp91PBLQTqXmev5SHGZO3b8pJfBUzkzIl44QsgobN1Y2P5Adok77DjO1767b0/bkCLHPJiaFVSd6qYec3Z9+AYvHdErO0rgf1XRdzJkd+lizGn8ipg8IoVcjC2ZiKEY/kn4NgDg33ajxHSyocPuUZUeqr+Zj2jjbhSptQJxg==
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
- [High] KVM: guest_memfd: missing release_folio() with mapping_set_release=
_always()
- [Medium] mm: shmem: unmovable guest_memfd folios allocated with GFP_HIGHU=
SER_MOVABLE
--

commit 27616bb0c537e1022b72cd23715bdb3c99505f19
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Add helper to create guest_memfd with a resource file

This commit updates the tools UAPI header for KVM_CREATE_GUEST_MEMFD to
define GUEST_MEMFD_FLAG_USE_RESOURCE and resource_fd, and adds selftest
helpers to create a guest_memfd backed by a resource file descriptor.

> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kv=
m.h
> index 419011097fa8e..66c1f40b50c29 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1654,11 +1654,14 @@ struct kvm_memory_attributes {
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_gue=
st_memfd)
>  #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
>  #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
> +#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
> =20
>  struct kvm_create_guest_memfd {
>  	__u64 size;
>  	__u64 flags;
> -	__u64 reserved[6];
> +	__s32 resource_fd;
> +	__u32 pad;
> +	__u64 reserved[5];
>  };
> =20
>  #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_mem=
ory)

[Severity: High]
To support provider folio invalidation for guest_memfd in this series,
virt/kvm/guest_memfd.c:kvm_gmem_init_inode() enables AS_RELEASE_ALWAYS so
that truncate_cleanup_folio() sees folio_needs_release(folio) as true and
invokes kvm_gmem_invalidate_folio():

virt/kvm/guest_memfd.c:kvm_gmem_init_inode() {
	...
	mapping_set_inaccessible(inode->i_mapping);
	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
	mapping_set_release_always(inode->i_mapping);
}

However, kvm_gmem_aops in virt/kvm/guest_memfd.c does not define a
.release_folio callback:

static const struct address_space_operations kvm_gmem_aops =3D {
	.dirty_folio =3D noop_dirty_folio,
	.migrate_folio	=3D kvm_gmem_migrate_folio,
	.error_remove_folio =3D kvm_gmem_error_folio,
	.invalidate_folio =3D kvm_gmem_invalidate_folio,
#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
	.free_folio =3D kvm_gmem_free_folio,
#endif
};

When folio_needs_release(folio) is true because of AS_RELEASE_ALWAYS and
mapping->a_ops->release_folio is NULL, mm/filemap.c:filemap_release_folio()
falls back to fs/buffer.c:try_to_free_buffers(), which hits a warning on
guest_memfd folios and returns true:

mm/filemap.c:filemap_release_folio() {
	if (mapping && mapping->a_ops->release_folio)
		return mapping->a_ops->release_folio(folio, gfp);
	return try_to_free_buffers(folio);
}

fs/buffer.c:try_to_free_buffers() {
	/* Misconfigured folio check */
	if (WARN_ON_ONCE(!folio_buffers(folio)))
		return true;
	...
}

If soft_offline_page() -> mm/memory-failure.c:soft_offline_in_use_page()
(via MADV_SOFT_OFFLINE, sysfs soft_offline_page, or corrected memory error
handling) runs on a clean, unmapped guest_memfd folio (which has PG_lru set
on LRU_UNEVICTABLE by filemap_add_folio() -> folio_add_lru()), or if
mm/memory.c:__do_fault() handles a PageHWPoison fault, it calls
mapping_evict_folio():

mm/memory-failure.c:soft_offline_in_use_page() {
	...
	if (!huge && folio_test_lru(folio) && !folio_test_swapcache(folio))
		/*
		 * Try to invalidate first. This should work for
		 * non dirty unmapped page cache pages.
		 */
		ret =3D mapping_evict_folio(folio_mapping(folio), folio);
}

Can this cause mapping_evict_folio() -> filemap_release_folio() to trigger
WARN_ON_ONCE(!folio_buffers(folio)) and then call remove_mapping(), evicting
and freeing the folio without calling kvm_gmem_invalidate_folio() or
kvm_gmem_invalidate_start() / kvm_gmem_invalidate_end(), leaking the tmpfs
provider sbinfo->used_blocks accounting and leaving stale stage-2 mappings
pointing to freed pages?

Should kvm_gmem_aops define a .release_folio callback to prevent
filemap_release_folio() from falling back to try_to_free_buffers() and
evicting folios without invalidation?

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index e2618877619e1..eca296539db79 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -809,26 +809,39 @@ static inline bool is_smt_on(void)
> =20
>  void vm_create_irqchip(struct kvm_vm *vm);
> =20
> -static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
> -					  u64 flags)
> +static inline int __vm_create_guest_memfd_resource(struct kvm_vm *vm, u6=
4 size,
> +						   u64 flags, int resource_fd)
>  {
>  	struct kvm_create_guest_memfd guest_memfd =3D {
>  		.size =3D size,
>  		.flags =3D flags,
> +		.resource_fd =3D resource_fd,
>  	};
> =20
>  	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
>  }

[Severity: Medium]
When creating a guest_memfd with GUEST_MEMFD_FLAG_USE_RESOURCE and a tmpfs
resource_fd via __vm_create_guest_memfd_resource(), faulting or fallocating
pages calls kvm_gmem_get_folio() -> gmem_provider_alloc_folio() ->
mm/shmem.c:shmem_gmem_alloc_folio():

mm/shmem.c:shmem_gmem_alloc_folio() {
	...
	if (mpol)
		folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
					 numa_node_id());
	else
		folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);
	...
}

In virt/kvm/guest_memfd.c:kvm_gmem_init_inode(), the guest_memfd mapping is
configured with GFP_HIGHUSER (without __GFP_MOVABLE) and marked
AS_INACCESSIBLE because guest_memfd folios cannot be migrated:

virt/kvm/guest_memfd.c:kvm_gmem_init_inode() {
	...
	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

	/*
	 * guest_memfd memory is neither migratable nor swappable: set
	 * inaccessible to gate off both.
	 */
	mapping_set_inaccessible(inode->i_mapping);
	...
}

Unlike gmem_native_alloc_folio(), which uses
mapping_gfp_mask(gi->vfs_inode.i_mapping), shmem_gmem_alloc_folio() passes
GFP_HIGHUSER_MOVABLE. Once kvm_gmem_get_folio() inserts the folio into
inode->i_mapping via filemap_add_folio(), isolate_migratepages_block(),
move_to_new_folio(), and kvm_gmem_migrate_folio() all reject migration on
the AS_INACCESSIBLE mapping.

Could allocating these unmovable folios with GFP_HIGHUSER_MOVABLE place them
in ZONE_MOVABLE or MIGRATE_CMA pageblocks and permanently pin those blocks
against contiguous allocations and memory hot-unplug?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D6

