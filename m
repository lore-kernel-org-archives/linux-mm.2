Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A86606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U13IRDaq
Received: by kanga.kvack.org (Postfix)
	id 53C6D6B05B1; Sun, 25 Oct 2026 06:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED546B05B2; Sun, 25 Oct 2026 06:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBC66B05B3; Sun, 25 Oct 2026 06:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02A966B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:46:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DA4B1205BB
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:46:23 +0000 (UTC)
X-FDA: 85360819446.03.63D8361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C4C0340004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:46:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U13IRDaq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792925181;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4SZFTTNmF7qBoPXPsj8haA0Ke7UgDMpEIh4UfNrrZs=;
	b=Q2tU8Jb2w+CigyEPj/a4Ca/T5Qllkol+8lZVHwqyyZRHAS3Gijpwo/2NT8mD4g7DvOK5MG
	dm8uDZT1wO7hX2v0AAtJIEhIPdrXg7qjJhbt8fepto2+MiaxyaQAatbcClQ6X8kUb3R0GF
	SoFfKy8SuH76kd/kEAdXeNkwjKfwZFo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U13IRDaq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792925181;
	b=rrRcfVYwnSPdktlNOLL24MvOUBGMUxdwD98SOfvIc7CbnyCrRodeRCBR2MxrcoYJix4Qur
	tBuHPl0QAfLhZ2Aw0vsPGvY8frI7iULNIpEwkleGJ7sd6GCETByWwglU3UL9fIQiEng5TN
	Y6KljE1YG4rId7RItKalKq7c3ok63gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBDBC438AA;
	Sun, 25 Oct 2026 10:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CD11F01825;
	Sun, 25 Oct 2026 10:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792925180;
	bh=E4SZFTTNmF7qBoPXPsj8haA0Ke7UgDMpEIh4UfNrrZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U13IRDaqfJpW1legBOXZAnni35ufcRObxGxtboN3LvDCsufLjkzbKx6DoKTvFl5pj
	 1ngwTa1D0eWPJfqZyybHhKa5fFspZlQl/z6EL73zF4OMf1tiGnPRBSTq7bcOBzlzMm
	 yRk55belLsBkjM8XVXnndZXxvQAf8HJw9i5llR8YvGc44WgwKs7pMzR1Y7KKRmp5yA
	 MR6PGoaXhTJBJww43jAH/GaZmwyRSbDhzvIdccVj6E423APMNDjHhhKChc6QE7SPVg
	 W4XP/d1oD4bXHb//7sjiQ5/WykHvyIwhEK9H0ZABGcumLqs+I6Dz2dwpjBBOE1/2Df
	 g9Bg+AZwpIAzQ==
Message-ID: <sashiko-outbox-184189@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page
 Fault and Overcommit elimination
Reply-To: sashiko-reviews@lists.linux.dev
To: dev12124 <joaoanandalima@gmail.com>, linux-mm@kvack.org
Cc: linux-efi@vger.kernel.org, ardb@kernel.org, keescook@chromium.org
In-Reply-To: <20261024104552.394-1-joaoanandalima@gmail.com>
References: <20261024104552.394-1-joaoanandalima@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 10:46:19 +0000
X-Rspamd-Queue-Id: C4C0340004
X-Rspam-User: 
X-Stat-Signature: xqhbfy3ut8ziybhwicuzmsbphhyd1c8z
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792925181-746488
X-HE-Meta: U2FsdGVkX1+rtv4i4PwNIse4EVgFAxrL+EPo2Gow/OdMVZ4ZeU3petzvIp7vkbNLXP5gwUao3OHPkaFJcE4a7MEXc/UgTBzP5fM01jzflNxASN1efEp38Du9nEmrruNSCXsiKkV9yZLZug9UsdOKvdzYmDbrVrFd6T7p8ZXAf8+vPLXxPDywJI5KlADI8eEP6l5Dt70u+9bVe3ziqJiex5unvVMbl/3AvIjXMGI0cYXklcXah58XiFK29JNfY19NE1n8aeTvx5RakEkADgfxhO04zueewNv/tDY86eH0pbn0T2LTWMxjxnRrmgYnEaC/W6hIrlpmoKuKakCkuG90TOPdmwRebgGV7PRiYODsPbCJxdZTLQ7ynWNjuTCk0s3e7rEa3DKELh43y8JyL5RCJOufIOngcoIGM+eqPnvtd3vO/UCMImkgEwNNYWIZno/BWyQ0atS88BmPaCd9MVQ41MUXsG8AD4DRhShP7uzcOX138glBTsyKP9IIwbwrWqSR1TknLzkhbq6VJYMxuqg9tVSd75bhyNdS2MAxPuLMNpyKF5jdy6Usm6zB92woqin2Kg8sqhBPcyGyJENZhsxdUVatszqSc/WmKSXJCAKr1ASTVXEw2cWOVqVH9ah6V1hSDA6HFEIyuQ2lElT1QfhTMI5xa1HPTwA5KlLZjJRYAOGx8HsGId9FitzTrDVvqsjjD6L/ApQREdNrVgxryUzRLYA+PivTHksqlTiSAvH5rqL0r6hQeNyb/qbNdy22lk0HeDAFyJw7JFxbJULx0E1SF7E8hB//R4a0ivCNq6rhE6krhbOYgJXsKfoeSLQmvlQGnBZjc29k+p6fRhym+A9vlAfcfLEgZZbSh0n/UKSCvzxwzrmxhTFQZ7jeWxUvJy9sfX7UdGQdn5LJU1t1Hdp1K26/vWlYt5NpNTGb8kORUj+oRHOVx0cVj8zFyfyp4r7sMYuiKrwfBnYKEmr46p9
 5RDcRD7u
 aQC+NWbV//yPeNlNB3dGNFVL8flK6D/EkmC+gdfH76dpUWdfsNKt+9J8BJLa2bGS8hNqHWB/M5bbj9lZKSmvD5g9x0r6qJOd4RGsvOfXEQyUS1lW0YUX6tZ934Uz7HMaUCSoohLhyH0WPAijSq+aUA9oKVjSp2c1qslcmSaH/8crEVx4+z6DQlcYJekxViJaesh1AG5pWjLUWHqqZ0neWnoFY42o6/zZJSE87UGPwDU3s39Bcu2k/Wh3uO5Kr5Lk2vuFNaKKikQRSBbLz8JwAPZ7lI0XYHJc2DxcW5nq2JQRPDEuyrcOnFpUukfeSNepJxDtH9T+5Qpu9QYTodJK/5MP4fTaPPd55cEbd/MvaXYBtvpxel9tkD1KwrSC7WR/pPmACTDszzBpgrVpNMAJs+D+dQFMZPT3qgi5FzbkadCDS7RGFKXcwYiAHFKVhlcSJ6CRLEKBBN+fPyjmR5qamU8ooSvjL7yElTtm+NtB6kSZIylZmdEB1d4OgPMLYYKKTttxbr40J4oAYW65tG7zCkfIuyvVF3p9i2tKTC8+aCYGB/1hlfzrZ9VJtaz5EuQYtn5N+FHu5VsUJGosBscM21sAnrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] mm: slab cache leak and lock inversion calling __init_ppm_memo=
ry() on fault
- [Critical] mm: non-constant initializer and unsynchronized globals ptl an=
d order
- [Critical] mm: NULL vma dereference and uninitialized PTE install in ppm_=
kalloc()
- [Critical] mm: compilation errors and invalid free_pages() call in ppm_kf=
ree()
- [Critical] mm: undeclared size, fault flag mismatch, and check bypass in =
handle_mm_fault()
- [High] mm: conflicting gfp_t typedef and non-const header globals in gfp_=
types.h
- [High] mm: invalid enum syntax and kmem_cache_create() call in __init_ppm=
_memory()
--

commit 469364dbfcb846300b827ea6edfe96aa5fd8142d
Author: dev12124 <joaoanandalima@gmail.com>

mm: ppm: add PPM (Page-Plugger Under Memory) to Page Fault and Overcommit e=
limination

This commit introduces a new Page-Plugger Under Memory (PPM) mechanism with
include/linux/ppm/gfp_types.h, slab cache initialization, and page allocati=
on
and deallocation routines hooked into handle_mm_fault().

> diff --git a/include/linux/ppm/gfp_types.h b/include/linux/ppm/gfp_types.h
> new file mode 100644
> index 0000000000000..741122b2dd2a4
> --- /dev/null
> +++ b/include/linux/ppm/gfp_types.h
> @@ -0,0 +1,74 @@
> +/*=20
> +  Memory Tatic: PPM (Page-Plugger Under Memory).
> +  This File is for PPM Flags/Macros/Functions/Types.
> +  Engineer (brazilian): Jo=C3=A3o Guilherme da Silva Freitas Lima <joana=
ndalima@gmail.com>
> + */
> +
> +/* Types Include Guards */
> +#ifndef __PPM_TYPES_MEMORY=20
> +#define __PPM_TYPES_MEMORY=20
> +
> +typedef unsigned char uint8_t;
> +typedef unsigned short uint16_t;
> +typedef unsigned int uint32_t;
> +typedef unsigned long long uint64_t;
> +typedef uint64_t gfp_t;
> +/* For errors in Allocation */
> +#define __PPM_ALLOC_ERROR -102
> +/* For errors in Desallocation */
> +#define __PPM_FREE_ERROR 0x04=20
> +/* For success */
> +#define __PPM_SUCCESS 0
> +#endif
> +
> +/* Functions Include Guards */
> +#ifndef __PPM_FUNCTIONS_MEMORY
> +#define __PPM_FUNCTIONS_MEMORY=20
> +
> +/* Initializer */
> +void __init_ppm_memory();
> +
> +/* Allocator Optimized */
> +int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags);
> +
> +/* Desallocator Optimized */
> +int ppm_kfree(uint64_t size);
> +
> +#endif
> +
> +/* Flags Include Guards */
> +#ifndef __PPM_FLAGS_MEMORY=20
> +#define __PPM_FLAGS_MEMORY
> +
> +/* PPM inits/starts in Bit 54 of a=20
> +   64-bit variable=20
> + */
> +gfp_t GFP_PLUG_MEMORY =3D (1ULL << 54);=20
> +
> +/* For free memory, the Bit 55 is=20
> +   used=20
> + */
> +gfp_t GFP_FREE_T =3D (1ULL << 55);
> +
> +#endif=20
> +
> +/* Macros Include Guards */
> +#ifndef __PPM_MACROS_MEMORY
> +#define __PPM_MACROS_MEMORY
> +
> +/* For Kernel Kernel tests 2 Bits (54 and 55) in=20
> +  1 Clock Cycle (or in small clocks, example: 5 Clocks),=20
> +  is used a mask using |=20
> + */
> +gfp_t GFP_MASK =3D GFP_PLUG_MEMORY | GFP_FREE_T;
> +
> +#endif

[Severity: High]
Will including include/linux/ppm/gfp_types.h from include/linux/slab.h break
the build across every translation unit that includes <linux/slab.h>?

In include/linux/slab.h, <linux/types.h> is already included and defines
gfp_t as a 32-bit bitwise unsigned int and uint64_t as u64. Redefining
uint64_t as unsigned long long (which conflicts on 64-bit architectures that
use unsigned long for u64) and redefining gfp_t as uint64_t causes conflict=
ing
type definitions.

In addition, GFP_PLUG_MEMORY, GFP_FREE_T, and GFP_MASK are defined as
non-static, non-const global variables directly in the header:

  gfp_t GFP_PLUG_MEMORY =3D (1ULL << 54);
  gfp_t GFP_FREE_T =3D (1ULL << 55);
  gfp_t GFP_MASK =3D GFP_PLUG_MEMORY | GFP_FREE_T;

Initializing GFP_MASK at file scope with non-constant variables fails C
compilation, and defining non-static variables in a header produces
multiple-definition linker errors. Also, declaring void __init_ppm_memory();
without (void) triggers -Werror=3Dstrict-prototypes.

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index cda126def67af..c76243128eb65 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -22,6 +22,17 @@
>  #include <linux/percpu-refcount.h>
>  #include <linux/cleanup.h>
>  #include <linux/hash.h>
> +#include <linux/ppm/gfp_types.h>
> +
> +/* A Structure enum with objects and codes
> +  for PPM Tatic Memory=20
> + */
> +enum __PPM_OBJ_CDE_BITS {
> +	_PPM_OBJECT_CACHE, /* A Simple Cache to store objects */
> +	_PPM_OBTAIN_CODE, /* 0x04, -102 or 0 */
> +    _PPM_FLAGS__ /* The Special Flags to PPM (Page-Plugger Under Memory)=
 */
> +};
> +
> =20
>  enum _slab_flag_bits {
>  	_SLAB_CONSISTENCY_CHECKS,
> diff --git a/mm/memory.c b/mm/memory.c
> index 976cd03954e3e..1700dd54a51ba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
[ ... ]
> @@ -94,6 +96,137 @@
>  #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame =
for last_cpupid.
>  #endif
> =20
> +/* Small Variables for=20
> +  PPM uses=20
> + */
> +int ppm_free_error;
> +int ppm_alloc_error;
> +int ppm_success;
> +unsigned int order;
> +unsigned int nr_pages =3D 1 << order;
> +unsigned int i;
> +struct vm_area_struct *vma;
> +spinlock_t *ptl;

[Severity: Critical]
Does defining nr_pages, order, vma, and ptl as file-scope globals in
mm/memory.c break compilation and introduce races across concurrent faults?

At file scope, initializing unsigned int nr_pages =3D 1 << order; fails to
compile because order is not a compile-time constant, and nr_pages is never
updated after order =3D get_order(size); in ppm_kalloc().

Furthermore, because spinlock_t *ptl and unsigned int order are single
unsynchronized global variables rather than local stack variables, concurre=
nt
calls to ppm_kalloc() or ppm_kfree() overwrite them:

  CPU 0                              CPU 1
  ppm_kalloc()                       ppm_kalloc()
    pte_offset_map_lock(..., &ptl)
    /* ptl points to lock_A */
                                       pte_offset_map_lock(..., &ptl)
                                       /* overwrites ptl with lock_B */
    pte_unmap_unlock(pte, ptl)
    /* unlocks lock_B instead of lock_A */

Wouldn't this leave lock_A permanently locked while unlocking lock_B early
(followed by a double-unlock on CPU 1), and similarly corrupt the global
order passed to free_pages(ptr_result, order) in ppm_kfree()?

> +
> +/* Initializer of PPM */
> +void __init_ppm_memory()=20
> +{
> +=09
> +	/* 1. Define the variables for=20
> +	 the rest of System uses=20
> +	 */
> +	ppm_free_error =3D __PPM_FREE_ERROR;
> +	ppm_alloc_error =3D __PPM_ALLOC_ERROR;
> +	ppm_success =3D __PPM_SUCCESS;
> +
> +	/* 2. Connect __PPM_OBJ_CDE_BITS to=20
> +	   flags under gfp_types.h=20
> +	 */
> +	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE =3D 4 * 1024 * 1024; /* 4MB for a=
lloc, used to store important objects */
> +	__PPM_OBJ_CDE_BITS.__PPM_OBTAIN_CODE =3D 0; /* Is modifyed in ppm_kallo=
c() and ppm_kfree() */
> +	__PPM_OBJ_CDE_BITS.__PPM_FLAGS__ =3D GFP_MASK; /* The Kernel uses this =
for test */
> +
> +	/* 3. Alloc the Cache of Objects */
> +	char *ppm_identifier =3D "PPM Cache";
> +	int *result_ptr =3D kmem_cache_create(ppm_identifier,=20
> +		8,=20
> +		_slab_flag_bits._SLAB_HWCACHE_ALIGN,
> +		_slab_flag_bits._SLAB_PANIC=20
> +	); /* Number 8 for a 64-bit Pointer */
> +	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE =3D result_ptr;
> +
> +	/* 4. Return success */
> +	ppm_success =3D __PPM_SUCCESS; /* The Kernel Optional-Action is verify =
if ppm_success is __PPM_SUCCESS */
> +}

[Severity: High]
Can __init_ppm_memory() compile as written?

In include/linux/slab.h, enum __PPM_OBJ_CDE_BITS and enum _slab_flag_bits a=
re
enumeration type declarations rather than struct instances, so applying the
member access operator (such as __PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE or
_slab_flag_bits._SLAB_HWCACHE_ALIGN) and assigning values to enumerators is
not valid C syntax. The double-underscore names (__PPM_OBJECT_CACHE) also do
not match the single-underscore enumerators (_PPM_OBJECT_CACHE).

In addition, kmem_cache_create() is called with 4 arguments where the third
argument is an enum constant instead of struct kmem_cache_args * or void *,
so _Generic dispatches to __kmem_cache_create(), which requires 5 arguments
(name, size, align, flags, ctor). It also passes raw bit indices instead of
SLAB_* bitmasks and assigns the returned struct kmem_cache * to int *.

[Severity: Critical]
Aside from the syntax issues, doesn't calling __init_ppm_memory() from
handle_mm_fault() leak a kmem_cache and cause lock inversion on every page
fault?

handle_mm_fault() runs while holding mmap_lock or a per-VMA read lock
(FAULT_FLAG_VMA_LOCK), and may be called with FAULT_FLAG_RETRY_NOWAIT.
Calling kmem_cache_create() unconditionally inside handle_mm_fault() acquir=
es
cpus_read_lock() and slab_mutex and performs sleeping GFP_KERNEL allocation=
s,
inverting the lock hierarchy (where cpus_read_lock() orders outside
mmap_lock) and leaking a new slab cache on every fault.

> +
> +/* Allocator to PPM */
> +int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags)=20
> +{
> +	if (unlikely(!size))=20
> +		return __PPM_ALLOC_ERROR;
> +
> +	/* 1. Alloc the size */
> +	order =3D get_order(size);
> +	struct page *pages_ppm =3D alloc_pages(
> +		flags | GFP_PLUG_MEMORY,
> +		order
> +	);
> +
> +	/* 2. Navigation in PTE (Page Table Walk) */
> +	/* 2.1. Obtain PGD */
> +	pgd_t *pgd =3D pgd_offset(current->mm, address);
> +	/* 2.2. Obtain P4D */
> +	p4d_t *p4d =3D p4d_alloc(current->mm, pgd, address);
> +	/* 2.3. Obtain PUD */
> +	pud_t *pud =3D pud_alloc(current->mm, p4d, address);
> +	/* 2.4. Obtain PMD */
> +	pmd_t *pmd =3D pmd_alloc(current->mm, pud, address);
> +=09
> +	/* 3. Plugging */
> +	/* Entry in PTE */
> +	pte_t *pte =3D pte_offset_map_lock(current->mm, pmd, address, &ptl);
> +	for (int i =3D 0; i < nr_pages; i++)
> +	{
> +		/* Calcle the memory allocated in 1 step */
> +		pte_t entry =3D pfn_pte(page_to_pfn(pages_ppm) + i, vma->vma_page_prot=
);
> +		entry =3D pte_mkdirty(entry); /* Active bit dirty */
> +		entry =3D pte_mkyoung(entry); /* Active bit young/present */
> +	}
> +
> +	/* 4. Finalize setting in the RAM the page */
> +	pte_t *new_pte;
> +	set_pte_at(current->mm, address, pte, new_pte);
> +
> +	/* 5. Unlock */
> +	pte_unmap_unlock(pte, ptl);
> +
> +	/* 6. Return */
> +	ppm_success =3D __PPM_SUCCESS; /* If value returned =3D=3D __PPM_SUCCES=
S? */
> +	return ppm_success;
> +}

[Severity: Critical]
What happens in ppm_kalloc() when walking page tables and installing the PT=
E?

1. alloc_pages(), p4d_alloc(), pud_alloc(), pmd_alloc(), and
   pte_offset_map_lock() are not checked for NULL. Note that
   pte_offset_map_lock() does not allocate a missing PTE table (unlike
   pte_alloc_map_lock()) and returns NULL without acquiring ptl when the PMD
   is empty, yet ppm_kalloc() proceeds to dereference pte and call
   pte_unmap_unlock(pte, ptl).
2. Inside the loop, vma->vma_page_prot dereferences the global variable vma
   (which is never initialized and is always NULL) and references a
   non-existent member vma_page_prot instead of vm_page_prot.
3. The local variable entry computed in the loop (which also never calls
   pte_mkwrite() despite the commit description) is discarded at the end of
   each iteration.
4. pte_t *new_pte; is declared as an uninitialized pointer and passed to
   set_pte_at(current->mm, address, pte, new_pte), which expects a pte_t
   value rather than a pte_t * pointer, installing uninitialized stack data
   into the page table and leaking pages_ppm.

> +
> +/* Desallocator to PPM */
> +int ppm_kfree(uint64_t size)=20
> +{
> +	if (unlikely(!size))=20
> +		return __PPM_FREE_ERROR;
> +=09
> +	/* 1. Entry in MMU Directories */
> +	pgd_t pgd =3D pgd_offset(current->mm, address);
> +	p4d_t p4d =3D p4d_alloc(current->mm, pgd, address);
> +	pud_t pud =3D pud_alloc(current->mm, p4d, address);
> +	pmd_t pmd =3D pmd_alloc(current->mm, pud, address);
> +
> +	/* 2. Entry in PTE */
> +	pte_t pte =3D pte_offset_map_lock(current->mm, pmd, address, &ptl);
> +	/* Verify if the PPM plugged the page */
> +	pte_t result_for_check =3D ptep_get(pte);
> +	pte_val(result_for_check) & GFP_PLUG_MEMORY;
> +	if (result_for_check > 1)=20
> +	{
> +		pte_clear(current->mm, address, pte);
> +	} else `{
> +		/* No executes/call, is ignored */
> +	=09
> +	}
> +
> +	/* 3. Flush for clear the TLB */
> +	flush_tlb_page();
> +
> +	/* 4. Unlock PTE */
> +	pte_unmap_unlock(pte, ptl);
> +
> +	/* 6. Extract the Pointer to free */
> +	int identifier_numeric =3D pte_pfn(result_for_check);
> +	struct page *ptr_result =3D pfn_to_page(identifier_numeric);
> +	free_pages(ptr_result, order);
> +
> +	/* 7. Return success */
> +	ppm_success =3D __PPM_SUCCESS;
> +	return ppm_success;
> +}

[Severity: Critical]
Does ppm_kfree() compile or safely free the target pages?

1. address is used throughout ppm_kfree(), but it is neither a parameter nor
   a declared variable.
2. pgd_offset(), p4d_alloc(), pud_alloc(), pmd_alloc(), and
   pte_offset_map_lock() return pointers (pgd_t *, p4d_t *, pud_t *, pmd_t =
*,
   pte_t *), but they are assigned to non-pointer value types and passed to
   ptep_get(), pte_clear(), and pte_unmap_unlock() without NULL checks.
3. pte_val(result_for_check) & GFP_PLUG_MEMORY; discards its result,
   if (result_for_check > 1) compares a pte_t struct against an integer,
   } else `{ has a stray backtick syntax error, and flush_tlb_page() is
   called with 0 arguments instead of (vma, addr).
4. After unlocking the PTE, ppm_kfree() unconditionally extracts pte_pfn()
   into a 32-bit int (even if the PTE was not present or the else branch was
   taken) and calls free_pages(ptr_result, order). Because free_pages()
   expects an unsigned long kernel virtual address rather than a
   struct page * (unlike __free_pages()), won't passing ptr_result trigger
   VM_BUG_ON(!virt_addr_valid((void *)addr)) or corrupt memory?

[ ... ]

> @@ -6936,6 +7069,31 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *=
vma, unsigned long address,
> =20
>  	__set_current_state(TASK_RUNNING);
> =20
> +	/* If PPM returns no is =3D=3D __PPM_SUCCESS, ignore the PPM Mode and=20
> +	   sign the default flow=20
> +	 */
> +	int code_error =3D __init_ppm_memory();
> +	if (code_error =3D=3D 0)=20
> +	{
> +		/* Verify flags */
> +		unsigned int ppm_check =3D flags & GFP_MASK;
> +		if (ppm_check =3D=3D GFP_PLUG_MEMORY)
> +		{
> +			ppm_kalloc(address, size, flags);
> +			return VM_FAULT_NOPAGE;
> +		} else if (ppm_check =3D=3D GFP_FREE_T) {
> +			ppm_kfree(size);
> +			return VM_FAULT_NOPAGE;
> +		} else {
> +			/* Executes none */
> +		}
> +
> +	} else {
> +		/* Executes none, is jump to the instruction of=20
> +		   'ret =3D sanitize_fault_flags(vma, &flags)' and next=20
> +		 */	=09
> +	}
> +
>  	ret =3D sanitize_fault_flags(vma, &flags);
>  	if (ret)
>  		goto out;

[Severity: Critical]
How is this block in handle_mm_fault() intended to work?

1. __init_ppm_memory() has a void return type, so assigning it to
   int code_error fails compilation.
2. ppm_kalloc(address, size, flags) and ppm_kfree(size) reference size, whi=
ch
   is not declared in handle_mm_fault() or at file scope.
3. The flags parameter of handle_mm_fault() carries 32-bit FAULT_FLAG_* bit=
s,
   not gfp_t flags. Masking unsigned int flags with GFP_MASK truncates
   GFP_PLUG_MEMORY (1ULL << 54) and GFP_FREE_T (1ULL << 55) to 0, so
   ppm_check =3D=3D GFP_PLUG_MEMORY and ppm_check =3D=3D GFP_FREE_T can nev=
er be
   true.
4. Returning VM_FAULT_NOPAGE before sanitize_fault_flags() and
   arch_vma_access_permitted() bypasses VMA access permission checks, memcg
   fault tracking, and mm_account_fault().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024104552.394-=
1-joaoanandalima@gmail.com?part=3D1

