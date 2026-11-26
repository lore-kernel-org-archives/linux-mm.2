Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E865606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGnBv2u0
Received: by kanga.kvack.org (Postfix)
	id 436CE6B05B2; Thu, 26 Nov 2026 13:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7856B05B3; Thu, 26 Nov 2026 13:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE856B05B4; Thu, 26 Nov 2026 13:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7B7D6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:03:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49EE980538
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:35 +0000 (UTC)
X-FDA: 85478042790.23.630301E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E3A240016
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:03:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGnBv2u0;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795716213;
	b=xH12Wo5C2fX501LSMYI2et0NSWaXy7bhwceuuGR2pHIJkRyGiDd1iQKp1ugCxqzGyACtBR
	KiyZKhWpH7N5KtJ6nBBiAoI0oYZAM0xHIlNqiNE3WILzor8yBC5ia562o0IQReIeXbJ/CG
	qUpcn5s6RHkJJ/BPld6jeqfqKQ01EQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795716213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRMbopjT2ZDCp3S0bduHH4K2gvQ2HvHqic8ibWdFK5o=;
	b=xiO7OC+8Fkg3eMWLUV9MXeSVOkKP3i8AKXGF7yvhtBU03T7DBWFjse/KwusfJZxuO3V2Wq
	rnnYhPsoUtKych/mSNwmm6ByRTfmq+ykF5uwRuNNaopQqyMJCytIuWMd+a97PFhCKI4x8w
	Mqp+FedPnflvCCWaI/sBmfBnG3/evgo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGnBv2u0;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D993F43BD5;
	Thu, 26 Nov 2026 18:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F3F1F00AE3;
	Thu, 26 Nov 2026 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716211;
	bh=SRMbopjT2ZDCp3S0bduHH4K2gvQ2HvHqic8ibWdFK5o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OGnBv2u03WCFZWsDn0SqFklZyJny8+Af7jkPORwbwrdfJO9Uuyh3rw7lkea/8Q6vB
	 cSIp8xQifnWtaWmwzYmEuwcFqqquwhEDZYU9qydrjf+sBZlYdV0Uh4OcohneorzOIF
	 dQPa+xbeiqQcdPDC9Oa7jdvVgs4qB+n6553AGLoeNcTPRVh325vt+HhS5HZHGL1sQs
	 OkUadX01xuDVnzUkH625JGfejnQ3/CAK3j6h3DWaPExj7QpjphDplmcLYj/MRIcgd0
	 eVototx5kDwOQb/DevkWMQPYQDKm10UmfNq6zCKguaXM2lSgE0EpwfzgMQkEYxMgnP
	 jCJ1NS7tAygTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/19] kho: vmalloc: Add the feature header
In-Reply-To: <20261110050202.529473-8-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:50 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-8-tarunsahu@google.com>
Date: Thu, 26 Nov 2026 18:03:23 +0000
Message-ID: <2vxzh5h3wjv8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E3A240016
X-Rspam-User:
X-Stat-Signature: cthb3ptqbxk8b1cfdafe1dnwnsbfzj56
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795716213-608315
X-HE-Meta: U2FsdGVkX1+30MNqm713usZWQReyr6I9Lb6MtM0n0NKHlq2xy6pQYGw59+cCXxrLH9Vfd4OHrOrSrMfIE7ZdQrkJ6fi01GoaIB971lPfk6UDt3J0wP6HFGEylhB91xYmnNNTj/lsLD8U0t3c+ZHpc+eFJcTYMIgYXojC3vZ8IJb3lXRAqR6ndbhiBiQsQ/m5sbSN2L1JDaA3s+3w90Y7T6dOgwSTeG7N9NDtNHeaajCHth7zP4NS+uuthby2eks5tEzPLf/xcluChCZTE3Lis0wXpbapGr4dFFctSBEX9Hd14sCHtOiVFK+KQZsdkcvjfcH1VQNcm0VFHCKq49cth4tPuRq7t9lzwRQ5hnJMTvt732pUxzTuWEap55KlCHgm9up7SCJxfirWUp4yBr3cdoJYHEeAb6jSiAVGIiixA3UMsetX4Eqr0gowCg91VY7jbTXTBh2FrZwL5vbyF7/4n8ilZkGMjXGrszexuqDrQBm4nKYJYAyJIHO+LqL7fVXoela82DYb7sTU37leBqDTvgMhaWSgfh9fvpxzlv5/LGj2bfqGgxVpma5XUUB249Q5+FxuUUv3yA9smkGJaqgc48zkgu66s5jtHYWWMKmhJfUlhQU9jJ6u5Z9JcSCMQIo71PeYFPSEWjQ6c34VSXrGFKP3Tgqjo0fCzzpLb0XDg+i6ShiGkNLhrzBNbMPy4wKzDkttKQWMUsPK++8nrdu/7u6G1sjnMCeduHz+6xCy/BbV2QR8ol4FJiqK5k6whg4nHureUZY+6BLGX5psbKRF6Q+DmHAURNz4F9FCvicSVfJEKRpE0HsmLOUXFsFjq/zH+qBy3rkk3tyXdi1uGk1utFQrEdVMHYkbxMVFWZJrQeOxQNzD3CxL0yLyKZBglzNCrOoPO6l7WLwrdU1tviUNV/NJNNHr2O6HUuj8Csc+8/tIihkJzRXiFeiPeLaWtWDFX+JkPtsImmE5eGU5dQq
 feB0FKD2
 LoF59D2aBHXING08t4iuAnS4bVzpgboOrCOXolyv2rQqdCcBmCwvZFcNCx3s6vuYrEYpM2z5UMZoVnyQ5Ipcm0j5nLMD+Y0cbisliBZKqzqzC5/PD24qJ0v3aEsTjetagwnFS3Mdkq4rlIlxJSubG+UsXWvADMwj0JBKN2ZrIiOMEPatXv05fJpB3Wgs56y7CS2PjuR05fBRKRyCc6Eas0kk5NUiqlGCSN6cgOaYKBdoqj2J5MB6IQwuoGBP7QNGyIkSdWpkLTyNSZ13+QgPPD2aKF74BcPWMExnNoi7O1S7pD56Y3G/oIF6hvuOzLhYQqeF4UD915sPFNOyc5Un8K5ibXserL0eu38yYtz/7/a/C8AgIyzxc9THxnnmlaBz5EKrp+3buuK/caOEcKt1c0TWQu/GwZogRnR5GXgYrdRa/vHl4bQfdZjVnstuTUA5kaYOCCd0XKDbbzGjJDQD6w6lPXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Register struct kho_vmalloc with the KHO serialization feature header
> mechanism to allow future additive fields or feature extensions without
> breaking live update ABI compatibility.
>
> Add DECLARE_KHO_SER(kho_vmalloc, 16, 0, 0) to register the 16-byte
> structure with 0 required and 0 optional features. Update function
> prototypes in include/linux/kexec_handover.h to take
> DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr) parameters, documenting which
> registered structure the feature header belongs to while enforcing
> compile-time type verification.
>
> In kho_preserve_vmalloc(), initialize the feature header with
> kho_ser_init() and access the payload fields via kho_ser_payload().
> In kho_restore_vmalloc(), validate incoming required features with
> kho_ser_validate() and access payload fields via kho_ser_payload().
> In kho_unpreserve_vmalloc(), access payload fields via kho_ser_payload().
> The chunk page format and traversal remain unchanged.
>
> Update memfd_luo and test_kho to pass typed feature header pointers
> and use kho_ser_size() for allocation sizing.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
[...]
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> index 7b49dd6d7e2a..b0597c438973 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -80,9 +80,9 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
>   *             to directly use them in the ABI.
>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
> - * @nr_folios: Number of folios in the folios array.
> - * @folios:    Pointer to KHO vmalloc descriptor for the array of
> - *             struct memfd_luo_folio_ser.
> + * @nr_folios:   Number of folios in the folios array.
> + * @folios_fhdr: Pointer to KHO vmalloc descriptor for the array of
> + *               struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
>  	u64 pos;
> @@ -90,7 +90,7 @@ struct memfd_luo_ser {
>  	u32 seals;
>  	u32 flags;
>  	u64 nr_folios;
> -	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
> +	DECLARE_KHOSER_PTR(folios_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));

This doesn't _only_ point to the feature header. It points to the
vmalloc buffer of of folios, conceptually. So it should be called
"folios". Reading folios_fhdr everywhere is super confusing and hard to
read. Users of KHO vmalloc should be pointing to the KHO malloc
serialization structure, not to its headers or so on.

The feature header is an implementation detail of kho_vmalloc (same for
others). It should not be visible to its callers.

>  };
>  
>  static_assert(sizeof(struct memfd_luo_ser) == 40);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 641a3b4c88fb..6e428df717cc 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1378,20 +1378,20 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
>  /**
>   * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
>   * @ptr: pointer to the area in vmalloc address space
> - * @preservation: placeholder for preservation metadata
> + * @fhdr:         placeholder for preservation metadata
>   *
>   * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
>   * physical pages mapped at @ptr will be preserved and on successful return
> - * @preservation will hold the physical address of a structure that describes
> - * the preservation.
> + * @fhdr will hold the preservation metadata.
>   *
>   * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
>   * restored on the same node
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
> +int kho_preserve_vmalloc(void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
>  {
> +	struct kho_vmalloc *vmalloc_ser;
>  	struct kho_vmalloc_chunk *chunk;
>  	struct vm_struct *vm = find_vm_area(ptr);
>  	unsigned int order, flags, nr_contig_pages;
> @@ -1404,13 +1404,18 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
>  	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
>  		return -EOPNOTSUPP;
>  
> +	kho_ser_init(fhdr, kho_vmalloc);
> +
> +	vmalloc_ser = kho_ser_payload(fhdr, kho_vmalloc);
> +
>  	flags = vmalloc_flags_to_kho(vm->flags);
>  	order = get_vm_area_page_order(vm);
> +	vmalloc_ser->order = order;

Nit: Why is this moving around? Seems like a stray change.

Also, renaming preservation to vmalloc_ser adds a lot of noise to your
diff. Perhaps keep it as-is for now?
>  
>  	chunk = new_vmalloc_chunk(NULL);
>  	if (!chunk)
>  		return -ENOMEM;
> -	KHOSER_STORE_PTR(preservation->first, chunk);
> +	KHOSER_STORE_PTR(vmalloc_ser->first, chunk);
>  
>  	nr_contig_pages = (1 << order);
>  	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
[...]

-- 
Regards,
Pratyush Yadav

