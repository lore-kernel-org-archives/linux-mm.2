Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE203CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0F56B0122; Mon, 11 Aug 2025 04:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871636B0123; Mon, 11 Aug 2025 04:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE846B0124; Mon, 11 Aug 2025 04:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66FE56B0122
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:06:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB06CC0725
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:06:08 +0000 (UTC)
X-FDA: 83763743616.22.ED9BF9D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F93F8000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:06:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FyessW4/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754899567; a=rsa-sha256;
	cv=none;
	b=KLGwb64oYbnWA8SkR9VRmDMv5G1+qXrHTDFAjr78tlxQs3lSxhcChwJiDInxTSlReLr4bk
	0jIErZCkbL9suTFIMyKJxRPWdqhUXYlVBdVDB42ByOVQas3H9NqEa4WDWKeKcDe/Dxg6U+
	YP0gPxtNjSGAmhojeHXNCN2TMKKnGSo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FyessW4/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754899567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkhwaYsOlNpQnkvKInIJcg+qBvI8c4bNMxUHogr91So=;
	b=P41YBdHzOep0SPVy3/xs/Y+3V3h+e+9x3DWgfozKuCjaLxOXAOeFtqcU6mjkuEoa9DbKn4
	J4XBQHWBkLPseJj62Wtx+6kOuXxUpUWa3vxsK9CQgvMx/yXe6xE/SvyPYIFzG416kthP6T
	gnzVAn/h7bsJKOOmCffi2AfEiBhKEhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D57F4A56AA5;
	Mon, 11 Aug 2025 08:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C29C4CEED;
	Mon, 11 Aug 2025 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754899566;
	bh=yaMU/nHBhn8GkjD+KNfZv140D6dMpYnx9IMLLJNJ3Og=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyessW4/T3kSKzJjb0PEMUIXS+OI/MSkBPD9t3M4y8bEwRbREqt2QNPQ+kni4nDL6
	 pzFPvxpE3YkK8MbVjzMMoXWhSKpjhrQZWjSc5pobloPrBebHiwnpclNmoE/ps3dRHf
	 C/w0LubB5PizyfG2oDgOJtjbrGhhjHyK3CoXDWhHhpQhBeujHmu90X10x0d+Wu/YcX
	 BFG6tloNNS5RZuBYHIYfPCKjGsPBNmt5i7FYps5o7aHr7ZiF0e4UFdDedTFdByW6mA
	 Ssv8jadFBOV29pIl5X8xrAkjHAOeYQgfLhQ4wdjRZysgEU5Phahtug5e0BjSDLdnWT
	 LYNqxq6ljOTiw==
Date: Mon, 11 Aug 2025 11:05:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Huth <thuth@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Alistair Popple <apopple@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	linux-arch@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 1/3] mm: move page table sync declarations
 to linux/pgtable.h
Message-ID: <aJmkX3JBhH3F0PEC@kernel.org>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-2-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811053420.10721-2-harry.yoo@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F93F8000E
X-Stat-Signature: hfp4hcdbik1tt8f9h1j3hm1fq8k89r4i
X-HE-Tag: 1754899567-728207
X-HE-Meta: U2FsdGVkX1/mvgt+bZ4v7iUPDm+PTv5OGBzKjSsxyXxiclDS3dPb3BWA8u+6+v6HaHWueUzO1g8b43C59Xmktw2yJT+cD5zcIAzpn7qQ4jbUGh3MBxJDonIOckYyVb0tM1uZXQZYxwQbYVDa3JIs7sh1MTlHHS9E1jBZ2C2p+psl5VHBHIvaga6I6Zc5rSGYDqX1Iqmq/6ts98eX+YF1hHBd6undwdjfr29Osl59ePvjy0ofrL5C0Bv1guLqs1lP6nU0PnyBF9orwI9xvPFqAj/PXub/SnHkv6FnIuOYQXT4PwKGEZy9oNrkK/YMqU9D8sJZVB9DIpeHHNBDLRI7ImQy7zKg83hb3LH411CuSFLg1t7KXgvMd6+S4u2LTAltcJha6+fB9sDwX/ka0aQicgmfKtWzB1Z7rLrPiMFtVX7a0gzAPkEbcWDu98EqSz2TugGFaN6Tpa6N6ch+kqLEVyQI3+TEE79RVmP1CQN/uCVlfv+Nchg/9eeuZ6d7IxdyLQgxuJDDTlh8x7hBfF7jgRBz1T9HNhiaQM58lEeWtbi4dQ0Hus5pXsXJKDrPdLg3ENTWKSqW2UBIFxTz8oNoqgArvcAq1cKrVp3eDEDIbfSBgP1FlAk35pb/QRpPfbT//o5k6aym2zFJ+QrF1jSDdsuMq+2DO4vlsW2MXmWgtB3N2WuiKn4Gzs4iggvl6WD0S17/eyGcJI71mqC4+tSmFAodPpp8ST8mpZ5TiaSF02lxRp8PQWZ240lyFm2FQba/9v0IDVIHAF8XDvvLCqaDete8QIkMRkF7lajBfwuqATOgJG/9rB9PifhfmfJJphpxuc5hIBEEmbx8NKTwGCk3SSw2HTZow+EwSNwKzlgjqgSLRTAPgpnNK/pZoH9/vSVKH2O6DkQ8NZsxeAGMTgzPiUEOZQpblHc4NaS3/NDYodKRuBsLstIhTOIT/tIexOjBPQg+67T3iLEaG3nyqaK
 bLuzUJ6A
 Fhqbp5TEamEMRttqJNyZVYuJw5/XN0jQ24FyDh5N+qQnOMiVgkcJ2ihRtXswrWj2tZqL5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:34:18PM +0900, Harry Yoo wrote:
> Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
> linux/pgtable.h so that they can be used outside of vmalloc and ioremap.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/pgtable.h | 16 ++++++++++++++++
>  include/linux/vmalloc.h | 16 ----------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c035637eeb7..ba699df6ef69 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1467,6 +1467,22 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
>  }
>  #endif
>  
> +/*
> + * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> + * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()

If ARCH_PAGE_TABLE_SYNC_MASK can be used outside vmalloc(), the comment
needs an update, maybe

... and let the generic code that modifies kernel page tables

Other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> + * needs to be called.
> + */
> +#ifndef ARCH_PAGE_TABLE_SYNC_MASK
> +#define ARCH_PAGE_TABLE_SYNC_MASK 0
> +#endif
> +
> +/*
> + * There is no default implementation for arch_sync_kernel_mappings(). It is
> + * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
> + * is 0.
> + */
> +void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
> +
>  #endif /* CONFIG_MMU */
>  
>  /*
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index fdc9aeb74a44..2759dac6be44 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -219,22 +219,6 @@ extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
>  int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
>  		     struct page **pages, unsigned int page_shift);
>  
> -/*
> - * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> - * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> - * needs to be called.
> - */
> -#ifndef ARCH_PAGE_TABLE_SYNC_MASK
> -#define ARCH_PAGE_TABLE_SYNC_MASK 0
> -#endif
> -
> -/*
> - * There is no default implementation for arch_sync_kernel_mappings(). It is
> - * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
> - * is 0.
> - */
> -void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
> -
>  /*
>   *	Lowlevel-APIs (not for driver use!)
>   */
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

