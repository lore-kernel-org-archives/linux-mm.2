Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC17606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRfO36dC
Received: by kanga.kvack.org (Postfix)
	id 770F36B0BF1; Fri, 23 Oct 2026 19:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7215E6B0BF4; Fri, 23 Oct 2026 19:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613DD6B0BF6; Fri, 23 Oct 2026 19:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3045E6B0BF1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:31:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB8381202F6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:48 +0000 (UTC)
X-FDA: 85355490696.18.06ED37A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 103E7180004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRfO36dC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798307;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0U/WoSsaRNQO1MenTP79HZhjU0z0zPCOkKNFxINsepk=;
	b=wgnU68aLoiEyLMoQlyoFIQLjO3LEMi99eTSs6HmuaUL7Sm4RZmHGD/1GkrXhJYaaAsSdND
	GW1LoVXAuMlbuq1GEbrKyi0vaxMHsrcSalVuIYEMDN6gITmV3gIepApRZOssrbpyo5pHIf
	S7Z0xjTcPmTTudleuRVnN8+Id/b1AWI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRfO36dC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798307;
	b=zw6PI3WcNr75k9i7HECBj1v/2yJSUI52eCVcv/uwjj3idg9tQt4Fpf3yA+wlTdxeQgn6Xf
	txhVEtRoU2OMYxB6d5uzG64EnAoGhM5e3PwaiMiSJB69Neap2iQ3IUe78vIDOO9xinV0GK
	0WrUKKEq2SuV/YNrIQ/nK9k1xG6w9eA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16835601DE;
	Fri, 23 Oct 2026 23:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73851F01825;
	Fri, 23 Oct 2026 23:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798305;
	bh=0U/WoSsaRNQO1MenTP79HZhjU0z0zPCOkKNFxINsepk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fRfO36dCskEVIkZdUyz1AP4sFNn3Vdizzf4q1mkANHNr0FdRfC1cT1dkho/liIZbN
	 Tvuu8o4tSzh1vHr94+Zt0gcIf4ZdXsZt794ecvWRA+P8mt+KLYIJYFV83ddcdnb5hN
	 njwUawLRHpfyj4ByNrTHlkIF7XPYj9UzAORGXOqes9M/qkTnYpYVeo4EkYHh9/7PXv
	 RzzIOvkL0YkbaF2pZOQx/5LPLJ5yucMi8K/Z9P8PJ55pZi85u+YyZ0OB/auUMRG1dR
	 llmZq4eXCFuY/1elRHGeiU1MEfh7laZv+z2HD70/UJs83Mwty9jtekPaLmYhIS11d4
	 hFNkMl2rBAxaw==
Message-ID: <sashiko-outbox-183367@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 03/50] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
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
In-Reply-To: <20261022-gmem-alternative-providers-v2-3-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-3-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:31:42 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 103E7180004
X-Stat-Signature: 4h6gb6ab8ekiqmcjdiq936xw5e48g1cx
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792798306-428992
X-HE-Meta: U2FsdGVkX1/K1NK3EXFMQhgieAeNunJogi+vqrGte3RdFeB35RaNooL6PfmzUIjPAr58a8731uYify5aROLJIEMpmIZhKA+fYJC3qj8iDiSntM9ad+ZZrNiEHeGuVpHDfi+Qd4AHdJKMwwi3bR3vRzZTfxeEAzoynwCQ+U+Hw7AGoKChVDAA9te2YvQ60nRs7rGQu5ooN2hBbYiTdu1ezisHFR3n8+P3qr0+x2YwZVKDuQvfhSgtpYdMalj+3OhW7Wje2l8uOSgTxXyYxyNLd+qNlWQQIQzDjlJDq6pRCEsvIqBruHASuKILYHqypuNMDTz7c88Y4BpuRI10P3eNMnF0B2dREnclRYShYRvCthaP/SMuxqBcxcko3a+XzFKiMOlHXwqYA++krTh033QpRjtE0L4otqhk0YaRkmLwg8gyzp7KIyEyKRUSQgaajd5s/Q0kyOOvCvEH13lSLAgIyZmVtweBGDKb8IumBD5dKU1s8Jxjis+TjcRw1Pve+9Z1boXnFcdWI4XED+5BIZCHPFzqtLQiuQH5NubWlbS4zpriTK8gm/HXi7pYxUXM8uSLA+9d2uhYPj9t2J97G2ZBaxh+0aUjPSPHP5EpxbVuaCNYSW2Kv9sAgww/dOm4wxKyP/pUtuJ3QpO8WQ+K7cGgUhOjphKqXt3JUmtLZg3+DNtIQ4K/EcNssqAMyQBaYTCPv7vH1+93guFeUKPBYpBe6x2QyD8yRLKehdYSiDBfreO73kSKSqFnRNmknWAL9ot/YMnYxldStCx5htQeLnY9xmRVdrKz3JU3zKlu9sT73Qe16SyJcCUZc8DgAtzjc5ODSsD3DXlj9o81zoGTi/AJ+40FFVrfDNZ6ZWA1hEkVfQbDlTOgr611BdUh30aKBWXVZmHcz8FtfHDZbuT73QOt2nDBq+8KkXEDTUHXC8h9fQ4lBr/N4FE18LGJ2N53LErRIahd28aPsbJH0kfn7U/
 hfDdlD/s
 ALX4LOnjeJjgCCeudTPG2Z8YiOD5QQmyUkNFv5kwLQkM/usrx41RrKzzw4DM2tmD4htwuCj8pViknqAR1m9UgLjNb9YJdWf05xBtHS5QcusUqAdb0x3PHNvACiWV9ocVSooDNASRAP/aJi2ZSdTDKOfAvgLzSOKrNEMc9pW+Ess+MSL/8Ny8ruy6Gu6lnGrWEcPe/cNjgGMT9G8MZX63jqTHM6HC8FtX5dg4hN4jCTFPt7cn5bQrfOwcgbXRXHqFqzHLf98XHWY67MMTLEflAXXCFp6vZxX243DgJFCRCeTm4BrubAMJz3IaQm1p6AP06eiradHzu7whQ2ix/8yvBdjGm2RvrzO8RFFhNU7kamqgA+FzQCMMaWbKIa4T3N84DkbpUNKSkl3uCX0DxJgVOM3VxachUIQu4MT3hPWCZNjRUOc07/yvJiJn1U/6Q1Cv7UZMghvA/+137SxBcSVQKHjpT4eJzaB0oR2IFTc3+UxQHNoTnaQH9msA/ixPcghtQ7TDmpHA2WstbMF0VaFHTqd7qINa9xfxCJGgy+5k6/0tzgzjMAr9x23ZMnMurchcXf12cO4mZKJ3Y89rkBURekDma7z+NjwIT0D+DlxAShwG3Keq/k/wTuHcTIN6edKlwhb70ypaqqIE8/E4yOxq0/rpSwBHtvRWKppWQvBV4CsaZDPzSfI56tvKJEdoGrYpFrmN/tkFQrVSkg7M=
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
- [High] mm: shmem: reference count leak on sbinfo->mpol in shmem_gmem_allo=
c_folio()
- [High] mm: shmem: shmem_gmem_alloc_folio() allocates unmovable folios as =
movable
--

commit 88b5d5c54fc1c479ad407c9b1ae1787c3dad600e
Author: Ackerley Tng <ackerleytng@google.com>

mm: shmem: Implement guest_memfd provider operations for tmpfs

This commit adds guest_memfd_provider_operations to file_operations and
implements tmpfs memory provider callbacks on shmem_dir_operations so that a
tmpfs root directory file descriptor can provide backing memory to
guest_memfd.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 848316eaa7f4f..2a9faf8be7382 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

[ ... ]

> @@ -5237,6 +5245,124 @@ static const struct inode_operations shmem_specia=
l_inode_operations =3D {
>  #endif
>  };
> =20
> +#ifdef CONFIG_KVM_GUEST_MEMFD

[ ... ]

> +static struct folio *shmem_gmem_alloc_folio(void *provider, pgoff_t inde=
x,
> +					    struct mempolicy *mpol)
> +{
> +	struct mempolicy *sb_mpol =3D NULL;
> +	struct vfsmount *mnt =3D provider;
> +	struct shmem_sb_info *sbinfo;
> +	struct folio *folio;
> +
> +	sbinfo =3D SHMEM_SB(mnt->mnt_sb);
> +	if (sbinfo->max_blocks &&
> +	    !percpu_counter_limited_add(&sbinfo->used_blocks,
> +					sbinfo->max_blocks, 1))
> +		return ERR_PTR(-ENOSPC);
> +
> +	if (!mpol) {
> +		sb_mpol =3D shmem_get_sbmpol(sbinfo);
> +		mpol =3D sb_mpol;
> +	}
> +
> +	if (mpol)
> +		folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
> +					 numa_node_id());
> +	else
> +		folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);

[Severity: High]
Should shmem_gmem_alloc_folio() allocate folios with GFP_HIGHUSER instead of
GFP_HIGHUSER_MOVABLE?

In virt/kvm/guest_memfd.c, kvm_gmem_get_folio() inserts the folio returned =
by
gmem_provider_alloc_folio() -> shmem_gmem_alloc_folio() into the guest_memfd
inode->i_mapping via filemap_add_folio(). However, kvm_gmem_init_inode()
configures that mapping as inaccessible and unevictable:

virt/kvm/guest_memfd.c:kvm_gmem_init_inode() {
	...
	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

	/*
	 * guest_memfd memory is neither migratable nor swappable: set
	 * inaccessible to gate off both.
	 */
	mapping_set_inaccessible(inode->i_mapping);
	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
	...
}

Because mapping_inaccessible() is true, move_to_new_folio() in mm/migrate.c
and isolate_migratepages_block() in mm/compaction.c reject migration with
-EOPNOTSUPP, kvm_gmem_migrate_folio() triggers WARN_ON_ONCE(1) and returns
-EINVAL, and shmem_gmem_attach() requires sbinfo->noswap. Allocating these
folios with __GFP_MOVABLE allows unmovable and unreclaimable guest_memfd
pages to be placed in ZONE_MOVABLE, MIGRATE_CMA, and MIGRATE_MOVABLE
pageblocks, which can cause CMA allocations, compaction, and memory
hot-unplug to fail.

> +
> +	mpol_cond_put(sb_mpol);

[Severity: High]
Does mpol_cond_put(sb_mpol) leak a reference on sbinfo->mpol when
shmem_gmem_alloc_folio() is called with a NULL mpol on a tmpfs mount
configured with an mpol=3D mount option?

When mpol is NULL, shmem_get_sbmpol() in mm/shmem.c unconditionally takes a
reference on sbinfo->mpol via mpol_get():

mm/shmem.c:shmem_get_sbmpol() {
	struct mempolicy *mpol =3D NULL;
	if (sbinfo->mpol) {
		raw_spin_lock(&sbinfo->stat_lock);
		mpol =3D sbinfo->mpol;
		mpol_get(mpol);
		raw_spin_unlock(&sbinfo->stat_lock);
	}
	return mpol;
}

However, mpol_cond_put() in include/linux/mempolicy.h only drops the
reference if MPOL_F_SHARED is set:

include/linux/mempolicy.h:mpol_cond_put() {
	if (mpol_needs_cond_ref(pol))
		__mpol_put(pol);
}

Since sbinfo->mpol is allocated via mpol_parse_str() -> mpol_new() without
MPOL_F_SHARED, mpol_cond_put(sb_mpol) is a no-op and leaks a reference on
every allocation, preventing sbinfo->mpol from being freed on remount or
unmount (and eventually wrapping atomic_t refcnt). Should this call
mpol_put(sb_mpol) instead, matching shmem_show_options() and
mpol_shared_policy_init()?

> +
> +	if (!folio) {
> +		if (sbinfo->max_blocks)
> +			percpu_counter_sub(&sbinfo->used_blocks, 1);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	return folio;
> +}

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D3

