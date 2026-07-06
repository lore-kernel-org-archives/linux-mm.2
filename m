Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBC9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 03:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443556B009E; Sun,  5 Jul 2026 23:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4486B009F; Sun,  5 Jul 2026 23:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2926B00A0; Sun,  5 Jul 2026 23:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E93FD6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 23:01:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AFCFC16FD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:01:22 +0000 (UTC)
X-FDA: 84956850804.03.A902CB8
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97E4620005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:01:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h4WuptXJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783306880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mNg8uTBUEP+kdeHtZVc8H2D2K8xV49JXzmGSxQo2r8=;
	b=xSz5G7ne3hP7AqWUQOL6DpQS19IDuJPciy+tZfAAyJlR3ORuCQf1sCv9ZoctQjy4bYju1H
	JSs4hFhCnMq/bpBFacCiZU2e7tlfp5UKggFDZSnayFBt9bMNJT0yT4/yOaJdDXm/di/uj+
	EnRVIsShigSkxefT/2bnLP2PJGLXWoY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h4WuptXJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783306880;
	b=Cbj/pUXcsBIvFC1FJmP8ehgBvsM3Nw+k+A/eOyxsKWYBrJ4oN5UHYEnP7/iISzRpQkxMvx
	VAJ/bucjSlUKt8omTTMZqFK+xlzfBeZUiJeQmCjRAxoUniBBNdOQqO0/o4smlnZ/WQrktM
	gjXr7+VYAdz38AnypOKf33uEwLJrN44=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783306878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mNg8uTBUEP+kdeHtZVc8H2D2K8xV49JXzmGSxQo2r8=;
	b=h4WuptXJGTMFsEeIm0BZYZ4V0I4pmNKKI6vHYn577zDVcEx6pVWmMpEm1XnXvNhMPmL1J4
	/68NGmhYURhAKTNPgwIopj8EEMzZ/nF87Z2r5SgH/ICOONcUzE7D7oX7gTIyA9JoiJEBOE
	fte8zEQwW5s68CSiG75PABKsNuy2o2k=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
Date: Mon, 6 Jul 2026 11:00:32 +0800
Cc: Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B0CB4ED-C190-4F49-97EE-E1F14F08DED2@linux.dev>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
To: Vivian Wang <wangruikang@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97E4620005
X-Stat-Signature: aim41y7cc9gcqg83yd9iqqit7q8r9ipw
X-HE-Tag: 1783306880-391061
X-HE-Meta: U2FsdGVkX19GbpcGkdBRzi3xTapk21lMqWGr7BHnmiGPCR4k7/Ijb9awnP4B+ONzP+1zlCxdOOIVGZoC4iPUgZJQZfFsQnPj2FoOCtLdDAhucwr8Y24R/kmZdMQznq/K4lDQMw/5QVVhzV76wv5hJqI7Bs0TQlefnajJjw3y5FE7DzxzYF4VV54R0rGengVpe5dRq1CIZbw+CrkqM+WRpPQU7nmU8lwaJo4CTkbNYeVgb9hdy40/uph98eGi9uEIi0pPEkUg8Xu++E/kWDii0tdlUM/9tvf4EB9LJqH3xs5SMMMcWtLB+aTDJCTtLtvNULlq5JXemJ0evuhhtk6h4eR3UMlBnYbO+EcCNBAJvdKb+MyQO/N5O5sDoWJaOFDMAcLePkvVAPptRuan4TUDvBg67g3KH9GO9+BTP6m1ymint9KTHe3sd2K3qYEdzBNuM9YwrCsG69II/Z+atG9dnzhphMrWQpA0WOTnrBR297MOYm+aUAAG74gCrd0Gk/p9EIQz5xKxtAqDxdL3Zt6n1xzC7ZyT5BURmHgbmtiUrCjcH0mRS/E4wyKl0B/8ZhRs3NY8+3cuUmugApLiF4KfMFS+vdvDSKnSCjOK88Fvu8Y5tkhMLd2WNGc1Kz8tcDm8pLsSHfCAFpkVNMc820RZ8D9cmuP8ZrB9yqalmhlnk32M1zQlwfDXKABJxreQ+tfUPzr7JSFv8oobcFaFPAZOeGsP2Owg4k+F8rqSRj6Fj4jbOrL+SILO7mYA/MpLbgRG8I/KLIT+K1Kjm6cG3EQSxvn83ds+Ax9cXUiOYQ8Fn9PLRIrvPGyEk+CWvxBfVdrz5xhbhUYWPPzUPlEOhEU7sY4dga835zt0WLTNsNXSqwlEcAgLQSvpFSzbTjRF91UXj0z83u3cLr+bnqaIjQ2Nc6zu0cPymFQZynwyQRqQc+UT7u9LeBUeKlxgdKNqAdOtjz1do5JJK/NuvUz+dih
 kDPmS1Cv
 udD+CHVwZg1CpmliNJRX5e45IGoUOKO21d6zMnzFoVT8dRWSYthvRrJ0viaiuUGWCKwmXICIGl9X2aboMtqmm6FKBX+fRv9y1LbNgc7tmUQDu0ywOL9dYMrG3vOyO1Qcaz9dJ8kKFEU43VhZRBMLPfZyxkSVr5nZHbW+XLWdlLM1XMPC6nqt3ItzVoDapLeaIwZdeEE3D1ADVzuDWoeGbB7M660tKeNENoxeLZ8EEgY1bf5IlvBd8FN0rGyLh5DkTfrNCXxTqyFJp1ctI3XR2WbUzljJqj//I7q4mqrhtiQb240A3S5o2LCs3InP8eapjr0CBnRPzKzQYt4xaRJBCGp+IvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 30, 2026, at 15:51, Vivian Wang <wangruikang@iscas.ac.cn> =
wrote:
>=20
> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
>=20
> This seems to be most easily reproduced with DEBUG_VM=3Dy and
> PAGE_POISONING=3Dy, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
>=20
> Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
> after population, to allow architectures to handle such situations as
> needed. Then implement it on RISC-V to arrange for the existing
> exception handler code to deal with these faults if they happen.
>=20
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> Changes in v4:
> - Rebase on v7.2-rc1, drop dependencies
> - (No code changes otherwise)
> - (A concurrency fix for mark_new_valid_map was sent independently)
>  =
https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-orderi=
ng-v1-1-60d8c10c6292@iscas.ac.cn/
> - Link to v3: =
https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001a=
c9264@iscas.ac.cn
>=20
> Changes in v3:
> - Merged back into one patch (Mike)
> - (No code changes otherwise.)
> - Link to v2: =
https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d0=
3b434@iscas.ac.cn
>=20
> Changes in v2:
> - Split patch in two, hook point and riscv hook=20
> - Explain hook necessity in patch 1 message (Mike)
> - Make hook #define based (Mike)
> - Call finalize hook only on populate success
> - Link to v1: =
https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d85=
9ba16@iscas.ac.cn
> ---
> arch/riscv/include/asm/pgtable.h | 4 ++++
> arch/riscv/mm/init.c             | 6 ++++++
> mm/sparse-vmemmap.c              | 8 ++++++++
> 3 files changed, 18 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/pgtable.h =
b/arch/riscv/include/asm/pgtable.h
> index 5d5756bda82e..6b000c990ba7 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1253,6 +1253,10 @@ static inline pte_t =
pte_swp_clear_exclusive(pte_t pte)
> #define TASK_SIZE FIXADDR_START
> #endif
>=20
> +/* Needed on SPARSEMEM_VMEMMAP */
> +#define vmemmap_populate_finalize vmemmap_populate_finalize
> +void __meminit vmemmap_populate_finalize(void);
> +
> #else /* CONFIG_MMU */
>=20
> #define PAGE_SHARED __pgprot(0)
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 5b1b3c88b4d1..800cb5c007d1 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1372,6 +1372,12 @@ int __meminit vmemmap_populate(unsigned long =
start, unsigned long end, int node,
> */
> 	return vmemmap_populate_hugepages(start, end, node, altmap);
> }
> +
> +void __meminit vmemmap_populate_finalize(void)
> +{
> + 	/* Avoid faults on cached non-present TLB entries. */
> + 	mark_new_valid_map();
> +}
> #endif
>=20
> #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 99e2be39671b..290cafcfd723 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -544,6 +544,12 @@ static int __meminit =
vmemmap_populate_compound_pages(unsigned long start_pfn,
>=20
> #endif
>=20
> +#ifndef vmemmap_populate_finalize
> +static void __meminit vmemmap_populate_finalize(void)
> +{
> +}
> +#endif
> +
> struct page * __meminit __populate_section_memmap(unsigned long pfn,
> unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> struct dev_pagemap *pgmap)
> @@ -564,6 +570,8 @@ struct page * __meminit =
__populate_section_memmap(unsigned long pfn,
> 	if (r < 0)
> 		return NULL;
>=20
> + 	vmemmap_populate_finalize();

Does the hook of flush_cache_vmap() work for you?  =46rom the document =
of
cachetlb.rst, it said:=20

	6) ``void flush_cache_vmap(unsigned long start, unsigned long =
end)``
	   ``void flush_cache_vunmap(unsigned long start, unsigned long =
end)``

		Here in these two interfaces we are flushing a specific =
range
		of (kernel) virtual addresses from the cache. After =
running,
		there will be no entries in the cache for the kernel =
address
		space for virtual addresses in the range 'start' to =
'end-1'.

It seems that flush_cache_vmap() is supposed to be called after a new =
kernel
mapping has been installed, but before this address range is accessed.

Therefore, invoking flush_cache_vmap() here aligns perfectly with its =
interface
definition. But how would this change impact other architectures? =
Currently,
among architectures where CONFIG_SPARSEMEM=3Dy, only RISC-V and PowerPC =
provide
a concrete implementation for flush_cache_vmap().

For PowerPC, the implementation is as follows:

	static inline void flush_cache_vmap(unsigned long start, =
unsigned long end)
	{
		asm volatile("ptesync" ::: "memory");
	}

Here, flush_cache_vmap() is also intended to supply the ptesync =
instruction
that the kernel address mapping lacks. However, flush_cache_vmap() is =
not
called in the __populate_section_memmap() path. So, how does PowerPC =
ensure
ptesync is executed there? The answer lies in the architecture-specific
vmemmap_set_pmd(), which injects the necessary ptesync.

If we choose to reuse flush_cache_vmap() in the generic path, it yields =
the
following benefits:

- Avoids architectural churn: We do not need to introduce a new hook
  like vmemmap_populate_finalize().
- Cleans up arch code: PowerPC can deprecate its custom =
vmemmap_set_pmd()
  and migrate to the generic implementation.

Let me know if this rationale makes sense, or if there are any hidden =
edge
cases I might have overlooked regarding other architectures.

Thanks,
Muchun

	=09
> +
> 	return pfn_to_page(pfn);
> }
>=20
>=20
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9
>=20
> Best regards,
> -- =20
> Vivian "dramforever" Wang
>=20


