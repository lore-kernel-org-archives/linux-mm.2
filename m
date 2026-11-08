Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB43606A331
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dTOLwSAe
Received: by kanga.kvack.org (Postfix)
	id 489256B05C7; Sat,  7 Nov 2026 19:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462046B05C8; Sat,  7 Nov 2026 19:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3020C6B05C9; Sat,  7 Nov 2026 19:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 066866B05C7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBF29A0413
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:19 +0000 (UTC)
X-FDA: 85410105438.21.4E6323B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 30436140004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dTOLwSAe;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098658;
	b=MyrhuW0Yg40GnOih+kJiVe4dtCaqHnZFzOEyT/L/TU0uXzKnkWM6hw6ZWdQg4u4PQFyS2n
	iZi9SSMEUNBH2XQmGtfS6G339/HNlJcLCN5d4TLtScYBNzHsRo9YZuAghY6//ZSVRNrgkM
	Au8de6awAcpkkjb//QP+FlA59edFw4A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dTOLwSAe;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098658;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2KkAkl+NVXgKCoi6ASrSyMiMBJsAg9qAqcOWsd3wPc=;
	b=DwmKyJ8EFmKLJCgSP07iOBu2r7zbkPnoWM0Lw3yOaNzyYg7yD88hYP+Q+w5Okx8LskcY5a
	sOMqDyEK0yc1bKxespN9Kt3MCPpAXzDMCUf0UIgrw/VqLxunOoE31xp0WruHJ4gSPaxzOI
	vj9IqBSWadiAratCkcXObe+fD6JjyIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89B4E409CF;
	Sun,  8 Nov 2026 00:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA5A1F0089F;
	Sun,  8 Nov 2026 00:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098657;
	bh=E2KkAkl+NVXgKCoi6ASrSyMiMBJsAg9qAqcOWsd3wPc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dTOLwSAe863MLpQUUIkQs8ypUGkcYK+RmsQ/BE3MMWEdMJ9OYE/N4y2a9eUnSkGnm
	 Hso3tWqgC2naZDdhCsnQl1oJwtQJm+Oq80m3g35fDkMEShYkO9dcV3mvV4ds9pJCd7
	 bBDI7Q7EB+BweD6YuF+YXBAc6R4bduoHAHxqKPbz4qdBHE27UfxGVlnAMZqnMo1OVE
	 UAj02ppuG/SGwOOadPm72t6deY+5DYDrSILya4ZyKsUno30YYkWJioRzS7c+uWrtHJ
	 t1u4yRDCJcBnZ1bpb0wQym6IiyEMILfTwPP5Ii22DZDKmD+7Bv6HsZBxhnLypf4FVI
	 EhMdtF+GPGNOg==
Message-ID: <sashiko-outbox-203463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 52/88] KVM: guest_memfd: Support mmap provider
 operation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-52-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-52-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:16 +0000
X-Stat-Signature: qgb3m5h6twgjjiixympzixbqhtmk4cqe
X-Rspamd-Queue-Id: 30436140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098658-200607
X-HE-Meta: U2FsdGVkX180Gxz0CQLJVWW7lvDk/17d/r3nS4Aj5UAtDHRSR1MwPv3GI+Bg+z48Dz/L8jv9iW6sUbRDCZ+8vk/pJ1m40z0Xu/SB4iE39QU/KEfEU4CT58ZbXHWpU/P5PJPtVfE2QrfEYZHy9/GVcutCwwVjStRHp3pxwWYcMONzvvA0irJMFHY1w6eYeUE1Pk7cMdn/fqlUbKJRwRZSGIuTYV94ZJu6aep7/HqZIXuBEZ2ASE/tMSwIuP/P/0l8qS4K+Hc6FbS9BqRVpl9HGKTrQuXFF27gzX5CQT6OlS8wBlHkkevhKkB9nYpsXDbVFQiScGIC+QYYtoRDGsHgiFxl4LWnb9IGLfox5EWmkvAhSc+JBx6D75HQDNlLqDEQWBbxCFoQ87+3gJvOtET3cgZyl72P2RIgiDxU3tWh8z3YQbMa2DmHGVRpmKfG7mBI4te5OMsnhNAc6WNWmZ0CjF7TL6jlIIUtdbT3OvOr5wIJdrrcxVazRdzc+CEtSbneIQg9PWkpQt8WVZcAbB+6gPyU8HnOgCaerl/7IL8E8XB1pMpjn10zPkZhaBpyYv1xFYf6DbtyJILolWXZRDPU5KtfVP+Wg7/Gmr2J5vjslWBldN8mUwQTdLzdZr08o5/rZLJPvrpibqc3L7b3NRuGipps885XiB1ZsSjb1CNzc7u2s2mUKoO6KCzupZ0+N5nzGq85cry5W5g8wW98VzQBL4Iwktn4U9raFMoSc37knHD0Tlu1WnT+8lj4oPV8bpMMaaR951bszYlG1dq/ZooZoKEwTNY6Eg6hGbUKjYWDmg4SB/Usl+b5mjnE+G60QDubd5yGdyDct2drFWUmlrGUbOAh2x6rc3gUMQDzWrWor3b7czpexmrP3jdIjmXhlv+AqfVCpSmXqqhP6f1gB4nueS2q8pRYOQzuYLRlkRJn7cfWioP51yJXuK/3S3p6H1l4BgtCqVA8bGGCJemh2kp
 PL8MT1oI
 5jxkM1fAfH2yX1C+yG2zXmxuNOspifR0L+CppMwZzf7nO1Xw9UDZbO0/iDMnQl4a2FIHnCOl0f4c70tM09VvMySmBjLY2U8F5c95go9Z9cLc/TRzIhsTTAkWH5i/n2FyeNvU3T4aFGxVGXoph3e8pM5tAscN6TewdGIt10mCi0KHWRyoa4F0NUIUADA+ro7//IdVXZNz+4dGYZPouC4u/iZwZqYl1Im5KxmXxt9YfdtVOjJJbPSWLQEuiDfe3Z8/Tlymqss7BdTIJpOgLckOQn9ZgqL6l7pvDqKBmyxG9KXp1KwyXlklpSbZXuC93jqCnbvCjrFr2rhM4K7U7nyCFyRYEOEjagIUk8qz0FwxUmFWwWuYx5y4DHYwT2o8RQ2Tz4NBvvUDeg9vMJw2nveO/I14h27d1yroH6k6AUdlq6Lcofh41aVBswWk38xzzfiaWnvk5mocARQ9TjvSd0jbtby6/fWf2G2boMOPPPYVoU5X3GuH2eMEXNQuT7H230zq18rW3w4CtUTkemAigt/87RTx95g+9oSsH4UM/bryS8iSlpN9Ibw1c2J79FbignKb3MKa/j+4N7iygCa5Dcg3bICgZ5j54iLPgM7rCbpYpsLUwQ0uFcLbnXEx83wkPppJWK4NMByvHRTHM6GqXh/aWO9tFlwm34/V3+FHf1gCB1A/uSx6drU57Go0cynbiHv+BImnkMs4xWfdFLzcx+nQFsP4LRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] KVM: guest_memfd: gmem_insert_pfn() discards provider mmap
  vm_page_prot
- [Low] KVM: guest_memfd: duplicate @mmap kernel-doc in
  guest_memfd_provider_operations
- [Low] KVM: guest_memfd: missing vm_area_struct forward declaration in
  guest_memfd.h
--

commit 649219a71c7e85644f581e90c9dd003891e92c1c
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support mmap provider operation

This commit adds an optional .mmap callback to struct
guest_memfd_provider_operations and invokes it from kvm_gmem_mmap() so
memory providers can customize VMA setup when userspace maps a
guest_memfd file.

> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index 8cdc334d1c9aa..a2af279cd3c34 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -85,6 +85,9 @@ static inline bool kvm_gmem_pfn_is_cacheable(u64 pfn_at=
trs)
>   *                 available, the provider should skip the unbacked rang=
e. Not
>   *                 called on kvm_gmem_revoke(). Do not take locks held a=
cross
>   *                 kvm_gmem_revoke().
> + * @mmap: Optional callback to set up user mappings. Called when userspa=
ce calls
> + *        mmap() on guest_memfd. The provider can customize VMA flags, o=
r reject
> + *        the mapping.

[Severity: Low]
Does this add a duplicate @mmap entry to the kernel-doc comment for
struct guest_memfd_provider_operations?

Earlier in the series, commit "KVM: guest_memfd: Export kvm_gmem_revoke
for provider-driven revocation" already added an @mmap description to
this comment block (right after @get_pfn), so scripts/kernel-doc will
warn about a duplicate section name.

>   *
>   * Used by filesystems and device drivers that provide memory for guest_=
memfd.
>   */
> @@ -99,6 +102,7 @@ struct guest_memfd_provider_operations {
>  	int (*lookup_pfn_range)(void *provider, pgoff_t index,
>  				unsigned long *pfn, size_t *nr_pages);
>  	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
> +	int (*mmap)(void *provider, struct vm_area_struct *vma);
>  };

[Severity: Low]
Should include/linux/guest_memfd.h also forward-declare struct
vm_area_struct alongside struct file, struct folio, struct inode, and
struct mempolicy?

Without a prior file-scope declaration, a translation unit that includes
linux/guest_memfd.h before struct vm_area_struct is declared will scope
the incomplete type to the parameter list of .mmap and trigger a
-Wvisibility warning.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1fbb719f0e31f..ec908419e5faa 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
[ ... ]
> @@ -869,6 +878,10 @@ static int kvm_gmem_mmap(struct file *file, struct v=
m_area_struct *vma)
>  		return -EINVAL;
>  	}
> =20
> +	ret =3D gmem_provider_mmap(gi, vma);
> +	if (ret)
> +		return ret;
> +
>  	if (kvm_gmem_is_pfn_mode(gi))
>  		vm_flags_set(vma, VM_PFNMAP);

[Severity: High]
When a PFN-mode provider customizes vma->vm_page_prot in its .mmap
callback (such as vfio_pci_core_mmap() setting pgprot_noncached() and
pgprot_decrypted() in commit "vfio: Implement mmap provider op for
guest_memfd"), does gmem_insert_pfn() discard those protection bits on
fault?

virt/kvm/guest_memfd.c:gmem_insert_pfn() {
	...
	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
				   vm_get_page_prot(flags));
}

gmem_insert_pfn() recomputes the page protection from scratch via
vm_get_page_prot(flags) instead of preserving the provider's attributes
in vma->vm_page_prot.  On arm64 (which does not select
__HAVE_PFNMAP_TRACKING, making pfnmap_setup_cachemode_pfn() a no-op),
device MMIO BARs will be mapped into host userspace as write-back normal
memory instead of device memory, and on x86 hosts with memory encryption
enabled, vm_get_page_prot(flags) will re-set the encryption bit and drop
pgprot_decrypted().

Deriving the fault protection with pgprot_modify(vma->vm_page_prot,
vm_get_page_prot(flags)) would preserve the provider's vma->vm_page_prot
customizations while still clearing VM_WRITE on read-only PFNs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D52

