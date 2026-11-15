Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7F9606A880
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddU/m/1O
Received: by kanga.kvack.org (Postfix)
	id 5BC776B05B2; Sun, 15 Nov 2026 12:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5460D6B05B3; Sun, 15 Nov 2026 12:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DF66B05B4; Sun, 15 Nov 2026 12:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C06E6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:35:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D6451406B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:35:45 +0000 (UTC)
X-FDA: 85438055850.11.A945CC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C108C1C0007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:35:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ddU/m/1O";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794764143;
	b=8nQjPIEFzIDmRh1iuUolA5B8WM7YxC562xh9C0d83Vgq+8ECm6bDrE2UonMBUZD78+ER9q
	DgxV0tDInFOltHM0yv9ELX3ShGS2uhbsSrAQkSAP7ecb5cmNkJwAPiWreWk98YRyuwC6KP
	3wntjyUZEM5FY+yILuR6BOgSBbaQ23Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ddU/m/1O";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794764143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcvhgN18/XYE74JlLdDetDkiu4aCL1FUsX9bNl85AkY=;
	b=MnHYBesLrbbRVEHE1/VooJsVVYZ3lCECHhL3yb5LwYMMfqaMYpovcrYEZ9pCETj/5H2wS+
	xDsd8FPp/kRvPKJXDEtayJN0Xq1NnnxGLen/fOmBGAAjax6W9FGZX6Aqu9f6svt1aXiVym
	sQPjtsXL9eXEDBzAC7boF34aXMuF52g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6DAC4175A;
	Sun, 15 Nov 2026 17:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20351F000C7;
	Sun, 15 Nov 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794764142;
	bh=fcvhgN18/XYE74JlLdDetDkiu4aCL1FUsX9bNl85AkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ddU/m/1Ov9hH52C17Sf1BxhZx39khyeZ73nswpSZtY3X610LZRBj0Idbdtnd8O4T/
	 EN4L7mJHIP90IjKjPaVbuRABJRbCOFNs789jv1X/5x2xRUJV9rkbUsZCBa9T1q7cIu
	 mXovLK/9jRwlwDkMfLKVRB6VcXBPkMhFXDlxbOv54EPM9joTvwF761sm+dzD5jiPKA
	 ku00S0Tc0YtsZmBVrp36zvAcqfUSnx0FPUQpd4J20hQkwHNyXRghC2rIG3RrOXVC5u
	 MOVkj0NIqYJuFV43NNl2an85+Dbj/v1rVbrpoXoYLzDFTOHSo1H/UsUmcXwD1o8oaK
	 9mR1epb9dYlUQ==
Date: Sun, 15 Nov 2026 19:35:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>, robin.murphy@arm.com, maz@kernel.org,
	will@kernel.org, David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com,
	pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
Message-ID: <avntYdLF2xvDh47A@kernel.org>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
 <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
X-Stat-Signature: s7qfm9oyou6r8crne7rmdu5qy3y1ieie
X-Rspamd-Queue-Id: C108C1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794764143-85105
X-HE-Meta: U2FsdGVkX18JunnczKbuadNbvbWSgaeI4t8smFlZjngBNsPkvkFzvVip9qwjhOlkn+wK3xPEbJST/MGp5Qt6yQ5wdZnFNIUcKb8JBhp/5JYd1Ojy9qYn8uUweVG2l+ncUV57f7cW1yFljeeM99V7Lu1R3IVazX0ZPHBv4k+oDlZxrts5hVvwkgk9sMMGUCvopsWdu0Wr8K7lfsQjavMfNyDeVsgAEzUhq+2Z4unb3sqXFqjLPAdeoX3TEWrYRYJlfNIUSTcAdDUgSJhLeD6BrPZ4cDwFQPGcYf0g7lmU4ESIX7jtDdX3fb7TAntq2NxY6Olfx3glcqwbtB5iVpk+tqSpF/JnFWe7qPPGMPE0iQ9688VRIbuS2xAP860pbBub5V9cRq25jDOVlZt/t79NPqZQFqcUOmYwVR9N0miukyQpWffqy8HhBHpKsZhY9nreIbrM7e6rB0t+C3JyyN+RjSTJs4ok481BBc2KLuJc8nXSvYF4XUkE/Fq8X9WBJMtJjei3XZrOaFeAE3yDMC0vloOZ06Y672mW1vqwiDF7F72N+oaFfZagl5WrVEC4c83vJqDSziUjQzoO883KcRiQ4dId7mgwM7q8BmYazXikxDXGfNB/mu8/a0U8thET4+CFuuCaQG3ZJL8+5a/X0nuxjVpw6Y+8bO+lX6jsTTo34svcON/bJlXvQBZCwMrAzI++SFBb1zsIDL2jicmcRYrxgCwsYjGG/jV2oh8uW5cd1QdDRFP1XOHaOEGZ8WMwHWH/YSr37u+7r/b6059rG05bdmGDsj/BJX+AE3tyB2fG2EGObNrqmVekz5eISXeV8adxtFQHTd3Oc4Zc0npQI+d41DwMubDI4IYGUe6Y6hlQNOD/AVpxRX5stBJ279DYrRoDGbxEFdkLiT8zHYtgAhRtrEbhEHWHrafrnlklZeOD8q9t/4M0z9pEBtowXGOde6wKICEELA+rrhU0Oelb0EW
 oR1nf5XR
 0+QFGKWnWgfDi4aC9h64c+DdkBx6Wkh9DvXGu/r7AKmdiX8yPC3KPeoo+iaDjPofMGF907utxKtZRCGCm+kCv85JRorWlrafdavcrpQkwCIvg9HSqnTOhevc8F8GhbGF/lOajT9B0mYsa4yULY6BpRlSwr/EBp7RkIFqbP9e2Z7c3k3G//QaBl8OujM7hP5+y0dSx3zfYo5W9buKdQd8oIJsJK95OakF18TPWhJn2v7SRF+peqsDucvndn5A2ZP5pxDWAmDGcZjhLu62tH9kENcTwYPKWYWHKjvzuUirfuemn6ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 08:10:32AM -0500, Pasha Tatashin wrote:
> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
> > Subsystems using the KHO Serialization Blocks framework currently do
> > not record the serialized entry size in the block header. The entry size
> > is only known to individual callers, which must track and store it in an
> > owning serialized data structure. If a newer source kernel adds fields
> > to an entry, the changed entry size breaks the stride when an older
> > target kernel iterates over blocks.
> >
> > Add an entry_size field to struct kho_block_header_ser. On the outgoing
> > side, record bs->entry_size into every block header during allocation.
> > During restoration, derive the entry stride directly from the block
> > header instead of relying on caller-supplied dimensions. The
> > kho_block_set_init() interface remains unchanged. A zero entry size,
> > or one that differs between blocks of a set, is rejected during
> > restoration.
> >
> > This change modifies the serialized layout of struct kho_block_header_ser
> > and shifts the offset of serialized entries within preserved blocks.
> > Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
> > kernels cleanly reject mismatched handover state during boot. Also
> > update the stale compatible string example in the documentation.
> >
> > Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> > Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> > ---
> >  include/linux/kho/abi/block.h          | 10 ++++----
> >  include/linux/kho/abi/kexec_handover.h |  6 ++---
> >  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
> >  3 files changed, 38 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > index 36bdbaf9b3b8..a40b0906c821 100644
> > --- a/include/linux/kho/abi/block.h
> > +++ b/include/linux/kho/abi/block.h
> > @@ -40,9 +40,10 @@
> >  
> >  /**
> >   * struct kho_block_header_ser - Header for the serialized data block.
> > - * @next:  Physical address of the next struct kho_block_header_ser.
> > - * @count: The number of entries that immediately follow this header in the
> > - *         memory block.
> > + * @next:       Physical address of the next struct kho_block_header_ser.
> > + * @count:      The number of entries that immediately follow this header in the
> > + *              memory block.
> > + * @entry_size: The size in bytes of each serialized entry in the block.
> >   *
> >   * This structure is located at the beginning of a block of physical memory
> >   * preserved across a kexec. It provides the necessary metadata to interpret
> > @@ -51,9 +52,10 @@
> >  struct kho_block_header_ser {
> >  	u64 next;
> >  	u64 count;
> > +	u64 entry_size;
> >  };
> >  
> > -static_assert(sizeof(struct kho_block_header_ser) == 16);
> > +static_assert(sizeof(struct kho_block_header_ser) == 24);
> >  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
> >  	      __alignof__(struct kho_block_header_ser) == 8);
> 
> The above change goes away once my comment on the previous patch 
> is addressed.
> 
> >  
> > diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> > index 2f4fb9c63942..6f12f5037ea5 100644
> > --- a/include/linux/kho/abi/kexec_handover.h
> > +++ b/include/linux/kho/abi/kexec_handover.h
> > @@ -41,7 +41,7 @@
> >   *   restore the preserved data.::
> >   *
> >   *     / {
> > - *         compatible = "kho-v3";
> > + *         compatible = "kho-v5";
> >   *
> >   *         preserved-memory-map = <0x...>;
> >   *
> > @@ -62,7 +62,7 @@
> >   *     };
> >   *
> >   *   Root KHO Node (/):
> > - *     - compatible: "kho-v3"
> > + *     - compatible: "kho-v5"
> 
> These are just examples, don't update them.
> 
> >   *
> >   *       Identifies the overall KHO ABI version.
> >   *
> > @@ -90,7 +90,7 @@
> >   */
> >  
> >  /* The compatible string for the KHO FDT root node. */
> > -#define KHO_FDT_COMPATIBLE "kho-v4"
> > +#define KHO_FDT_COMPATIBLE "kho-v5"
> >  
> >  /* The FDT property for the preserved memory map. */
> >  #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
> > diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> > index 0d2a342ef422..9b148009085e 100644
> > --- a/kernel/liveupdate/kho_block.c
> > +++ b/kernel/liveupdate/kho_block.c
> > @@ -16,6 +16,12 @@
> >   * array of serialized entries. Multiple blocks are linked together via a
> >   * physical pointer in the header, forming a linked list that can be easily
> >   * traversed in both the current and the next kernel.
> > + *
> > + * Each block header also records the size of its entries. A newer kernel may
> 
> "newer kernel" does not make sense in the documentation comment, as any 
> kernel can do that. I would suggest "outgoing kernel." 

My understanding that here "newer" kernel refers to a newer kernel version
rather than incoming or outgoing. So the docs should say something like
"different kernel versions may have different size of the entry"

> By the way, in this series you use the terms "source" and "destination"
> kernel, whereas traditionally we have used "outgoing" and "incoming."
> While both conventions work, it would be preferable to maintain
> consistency.

-- 
Sincerely yours,
Mike.

