Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6513C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6656B00A1; Tue,  7 Jul 2026 06:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE076B00A2; Tue,  7 Jul 2026 06:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4446B00A3; Tue,  7 Jul 2026 06:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 803006B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:02:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE09D8D3AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:52 +0000 (UTC)
X-FDA: 84961541784.24.34DECCD
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5827340007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RHCrShFX;
	spf=pass (imf12.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OASSxXJmGaDT/uwBYzqLU/UJt7dS4PW4F+eiwSUGvN0=;
	b=8ky/g4ShwbcYJc8aDU390bdvUdrPFjSe+9D5DkI0dPMf890EgpUO0V/AHSq4fmM3Zx9d8j
	tPjFeIeq+R7LPq+x0gn6lzUIwEDUouE+Z4Pt2dYg4TdDqvFyryEcW+9sTmKwaRxvLFZp+t
	xdSB9rWo9rYgkIaX3uyIbNpMh6gl6OU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418570;
	b=vKCQpBUmfVpBSlaaRNxEnpCTxK0L0iVLUiXsonOQIWd/Y5gYFGJq1sjYKIY6eu6M7UYRmB
	BiIXopGPxZEdXlmlLpWyPlHLGUGyBfplBvG4t/ZuJhKNEiCKsLP9/L1KulX2Fdp7suvcNV
	EfP9cZ04txhIxhHXksyqvCo/Yn3DfMU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RHCrShFX;
	spf=pass (imf12.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260707100248euoutp02c128470cd60985157ba2f1951ac410ba~-_b0ZdUlR0057200572euoutp02G;
	Tue,  7 Jul 2026 10:02:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260707100248euoutp02c128470cd60985157ba2f1951ac410ba~-_b0ZdUlR0057200572euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1783418568;
	bh=OASSxXJmGaDT/uwBYzqLU/UJt7dS4PW4F+eiwSUGvN0=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=RHCrShFX9Zi8e6102GUrdmlOX/rENJ+/+JuCky5tdn57zI6kqM/nq4spocntdRJKD
	 cxPgadB2teIqAQFmTL+UKcTizeCAL0ubzPJa+xDu1F3MyMDbRsL1NOEyOPlSjJZo4G
	 44B/fzM2C25EXEtbRRF8gVk2FDX0DehKHmBzMIF0=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260707100247eucas1p1439bac88cad923ef2478e1b2f63f9adc~-_b0IsPTq2255222552eucas1p19;
	Tue,  7 Jul 2026 10:02:47 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260707100245eusmtip202869722a30826a0db562dfb7a375b13~-_bx0DY2s0196401964eusmtip2h;
	Tue,  7 Jul 2026 10:02:45 +0000 (GMT)
Message-ID: <3f47aeab-33b1-4966-a5ce-5d6d5261e0e2@samsung.com>
Date: Tue, 7 Jul 2026 12:02:44 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, Mikko
	Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, Rasmus
	Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
	<gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
	Gorbik <gor@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Andrew
	Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
	Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Robin
	Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey
	<Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, "T.J. Mercier"
	<tjmercier@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
	Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org, linux-trace-kernel@vger.kernel.org
Content-Language: en-US
In-Reply-To: <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260707100247eucas1p1439bac88cad923ef2478e1b2f63f9adc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
X-EPHeader: CA
X-CMS-RootMailID: 20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
	<CGME20260701160902eucas1p1214af933ba0f54b85630a3a4e5a4689c@eucas1p1.samsung.com>
	<20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5827340007
X-Stat-Signature: ox7xfuaw3qtdzja9c589atraicw3w4u7
X-HE-Tag: 1783418570-524364
X-HE-Meta: U2FsdGVkX19GhGYRUtPtuz1kdkA/k7XVkH9uqsLSdNYIDzWczk6BvWKh4SflXEU1TVW1/Ftaxf9pAvpC6B92Sgmp/yPpFh9yW6nNxdVDrOwsOeKM1fFm7M0Rqch+b6Y/eGK7PM1rvnnarn2XndbkqDU7omnnkYDLgRIzC7yfEL1SfVCBqT/I++cdn06rmFuEHnqYy2rbEx3cvthsmWwB3YIGK9Se3tzbouc/bAcCqM1OluNtEgZGqfmcmt5hTvJ17ZaANUoui6bWwiQK1SuZltY0CUNGdxnMgQZqHYY0NO9G7tQSYkpLe6aF2JyiyKiYEsRcSpnbbTHJUHZTe0edvya8HAEIifVBiTNKenT7lsMhiceL2n0sR2hT77enu+Zc6BDsXZL2g1xhjkh7TVMyIK167VwQnYj7GeoBB6PVi0V9H+jkrlC7VsQZ+r+zWNBUkqbgA4LhW/iN7Ri8MU3sMTadhVQdm3dLhlBBURdbxhD0fz83ZUzRM5MGDcEQp1wyhstNUmpgnd/QjhLeDODeeMVOYBb2ombCfig7dYQPifYVqbqF3E9e5Ry4aYbTOS/7XprCWQcIFAYfvcQtCpTfQZ6Ed5ZkiJZ60gBIVkrkqpwIytCKWQ6Pw/SgRXcgSATy2OzTCQzjJVU5vhKCj5KrW8Nk+i2kZGWEtxXFfk7uTxmmS97IpuVeFuuNT7YsLYTqjmZQVZ+PzNSjqdXK3yYNzK7RSLG3j4fjHoF+7bpYDoLzNo9Sn4gpj84FpatVSx/6rCnoiyJ9mtX94AT20qPye7zO/BvY0l0oBgunSUNjkd2C843m+LEY0a/D0NdFeUqzbJHGz9C/Hkj2rh3rS6UtqCo6oI99nbxLFHKqvaqZX/9jlqJYifSA9Wmzy+rncmDb5pLuaWvKXUAA33iCtJScm1/r0W7Eyjao1c0KQKo+BDvCLekdS72+9YC+QbSd/7D1AtkBAMKfoab2K6hyW7x
 6A4fRwwf
 J3tptSLCi4XPo0GTQfVKmUqM8rezHnfwrPLKfopO13X0WGfpfnReyU0pyReQk4bNnXMyoiExvkLC0uRe8HkOLQ3hsVT6436x1cwfILii4bYw9vNTHz1X8npqYoy+PTysU5aS6Xzo5/uoTGKTAJeOGzkgsxTwqKBYl9AQl/hCbH8g3Ct8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.07.2026 18:08, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.


Well, the technical reason for not creating cma regions dynamically at
runtime is that on some architectures (like 32bit ARM) the early fixup
for the region is needed to make it functional for DMA.


I would add a comment about that in the cma_create() and ensure that its
future callers explicitly depend on !ARM_32BIT.


> The static array of CMA areas cannot be replaced by dynamically created
> areas because for many of them, allocation must not fail and some cases
> may need to initialize them before the slab allocator is even available.
> To account for this, keep these "early" areas in a separate list and
> track the dynamic areas in a separate list.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v3:
> - rebase on top of recent linux-next, update kernel/dma/contiguous.c
> - use kzalloc_obj() instead of kzalloc() with sizeof()
>
> Changes in v2:
> - rename fixed number of CMA areas to reflect their main use
> - account for pages in dynamically allocated regions
> ---
> arch/arm/mm/dma-mapping.c | 2 +-
> arch/s390/mm/init.c | 2 +-
> include/linux/cma.h | 8 +-
> kernel/dma/contiguous.c | 2 +-
> mm/cma.c | 187 +++++++++++++++++++++++++++++++++++++---------
> mm/cma.h | 5 +-
> 6 files changed, 165 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index f9bc53b60f99..934952ab2102 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -254,7 +254,7 @@ struct dma_contig_early_reserve {
> unsigned long size;
> };
> -static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __initdata;
> +static struct dma_contig_early_reserve dma_mmu_remap[MAX_EARLY_CMA_AREAS] __initdata;
> static int dma_mmu_remap_num __initdata;
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index f07168a0d3dd..f8f78f1434ea 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -241,7 +241,7 @@ static int s390_cma_mem_notifier(struct notifier_block *nb,
> mem_data.start = arg->start_pfn << PAGE_SHIFT;
> mem_data.end = mem_data.start + (arg->nr_pages << PAGE_SHIFT);
> if (action == MEM_GOING_OFFLINE)
> - rc = cma_for_each_area(s390_cma_check_range, &mem_data);
> + rc = cma_for_each_early_area(s390_cma_check_range, &mem_data);
> return notifier_from_errno(rc);
> }
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1..fb7a4923c3ba 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -7,7 +7,7 @@
> #include <linux/numa.h>
> #ifdef CONFIG_CMA_AREAS
> -#define MAX_CMA_AREAS CONFIG_CMA_AREAS
> +#define MAX_EARLY_CMA_AREAS CONFIG_CMA_AREAS
> #endif
> #define CMA_MAX_NAME 64
> @@ -57,8 +57,14 @@ struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
> bool cma_release_frozen(struct cma *cma, const struct page *pages,
> unsigned long count);
> +extern int cma_for_each_early_area(int (*it)(struct cma *cma, void *data), void *data);
> extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
> extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
> extern void cma_reserve_pages_on_error(struct cma *cma);
> +
> +extern struct cma *cma_create(phys_addr_t base, phys_addr_t size,
> + unsigned int order_per_bit, const char *name);
> +extern void cma_free(struct cma *cma);
> +
> #endif
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index f754079a287d..7975551f69b3 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -52,7 +52,7 @@
> #define CMA_SIZE_MBYTES 0
> #endif
> -static struct cma *dma_contiguous_areas[MAX_CMA_AREAS];
> +static struct cma *dma_contiguous_areas[MAX_EARLY_CMA_AREAS];
> static unsigned int dma_contiguous_areas_num;
> static int dma_contiguous_insert_area(struct cma *cma)
> diff --git a/mm/cma.c b/mm/cma.c
> index a13ce4999b39..f989e2e98594 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -34,7 +34,12 @@
> #include "internal.h"
> #include "cma.h"
> -struct cma cma_areas[MAX_CMA_AREAS];
> +static DEFINE_MUTEX(cma_lock);
> +
> +struct cma cma_early_areas[MAX_EARLY_CMA_AREAS];
> +unsigned int cma_early_area_count;
> +
> +static LIST_HEAD(cma_areas);
> unsigned int cma_area_count;
> phys_addr_t cma_get_base(const struct cma *cma)
> @@ -198,7 +203,6 @@ static void __init cma_activate_area(struct cma *cma)
> free_reserved_page(pfn_to_page(pfn));
> }
> }
> - totalcma_pages -= cma->count;
> cma->available_count = cma->count = 0;
> pr_err("CMA area %s could not be activated\n", cma->name);
> }
> @@ -207,8 +211,8 @@ static int __init cma_init_reserved_areas(void)
> {
> int i;
> - for (i = 0; i < cma_area_count; i++)
> - cma_activate_area(&cma_areas[i]);
> + for (i = 0; i < cma_early_area_count; i++)
> + cma_activate_area(&cma_early_areas[i]);
> return 0;
> }
> @@ -219,41 +223,77 @@ void __init cma_reserve_pages_on_error(struct cma *cma)
> set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
> }
> +static void __init cma_init_area(struct cma *cma, const char *name,
> + phys_addr_t size, unsigned int order_per_bit)
> +{
> + if (name)
> + strscpy(cma->name, name);
> + else
> + snprintf(cma->name, CMA_MAX_NAME, "cma%d\n", cma_area_count);
> +
> + cma->available_count = cma->count = size >> PAGE_SHIFT;
> + cma->order_per_bit = order_per_bit;
> +
> + INIT_LIST_HEAD(&cma->node);
> +}
> +
> static int __init cma_new_area(const char *name, phys_addr_t size,
> unsigned int order_per_bit,
> struct cma **res_cma)
> {
> struct cma *cma;
> - if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> + if (cma_early_area_count == ARRAY_SIZE(cma_early_areas)) {
> pr_err("Not enough slots for CMA reserved regions!\n");
> return -ENOSPC;
> }
> + mutex_lock(&cma_lock);
> +
> /*
> * Each reserved area must be initialised later, when more kernel
> * subsystems (like slab allocator) are available.
> */
> - cma = &cma_areas[cma_area_count];
> - cma_area_count++;
> + cma = &cma_early_areas[cma_early_area_count];
> + cma_early_area_count++;
> - if (name)
> - strscpy(cma->name, name);
> - else
> - snprintf(cma->name, CMA_MAX_NAME, "cma%d\n", cma_area_count);
> + cma_init_area(cma, name, size, order_per_bit);
> - cma->available_count = cma->count = size >> PAGE_SHIFT;
> - cma->order_per_bit = order_per_bit;
> - *res_cma = cma;
> totalcma_pages += cma->count;
> + *res_cma = cma;
> +
> + mutex_unlock(&cma_lock);
> return 0;
> }
> static void __init cma_drop_area(struct cma *cma)
> {
> + mutex_lock(&cma_lock);
> totalcma_pages -= cma->count;
> - cma_area_count--;
> + cma_early_area_count--;
> + mutex_unlock(&cma_lock);
> +}
> +
> +static int __init cma_check_memory(phys_addr_t base, phys_addr_t size)
> +{
> + if (!size || !memblock_is_region_reserved(base, size))
> + return -EINVAL;
> +
> + /*
> + * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
> + * needs pageblock_order to be initialized. Let's enforce it.
> + */
> + if (!pageblock_order) {
> + pr_err("pageblock_order not yet initialized. Called during early boot?\n");
> + return -EINVAL;
> + }
> +
> + /* ensure minimal alignment required by mm core */
> + if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> + return -EINVAL;
> +
> + return 0;
> }
> /**
> @@ -276,22 +316,9 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
> struct cma *cma;
> int ret;
> - /* Sanity checks */
> - if (!size || !memblock_is_region_reserved(base, size))
> - return -EINVAL;
> -
> - /*
> - * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
> - * needs pageblock_order to be initialized. Let's enforce it.
> - */
> - if (!pageblock_order) {
> - pr_err("pageblock_order not yet initialized. Called during early boot?\n");
> - return -EINVAL;
> - }
> -
> - /* ensure minimal alignment required by mm core */
> - if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> - return -EINVAL;
> + ret = cma_check_memory(base, size);
> + if (ret < 0)
> + return ret;
> ret = cma_new_area(name, size, order_per_bit, &cma);
> if (ret != 0)
> @@ -444,7 +471,7 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
> pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
> __func__, &size, &base, &limit, &alignment);
> - if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> + if (cma_early_area_count == ARRAY_SIZE(cma_early_areas)) {
> pr_err("Not enough slots for CMA reserved regions!\n");
> return -ENOSPC;
> }
> @@ -1051,12 +1078,12 @@ bool cma_release_frozen(struct cma *cma, const struct page *pages,
> return true;
> }
> -int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
> +int cma_for_each_early_area(int (*it)(struct cma *cma, void *data), void *data)
> {
> int i;
> - for (i = 0; i < cma_area_count; i++) {
> - int ret = it(&cma_areas[i], data);
> + for (i = 0; i < cma_early_area_count; i++) {
> + int ret = it(&cma_early_areas[i], data);
> if (ret)
> return ret;
> @@ -1065,6 +1092,25 @@ int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
> return 0;
> }
> +int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
> +{
> + struct cma *cma;
> +
> + mutex_lock(&cma_lock);
> +
> + list_for_each_entry(cma, &cma_areas, node) {
> + int ret = it(cma, data);
> +
> + if (ret) {
> + mutex_unlock(&cma_lock);
> + return ret;
> + }
> + }
> +
> + mutex_unlock(&cma_lock);
> + return 0;
> +}
> +
> bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
> {
> int r;
> @@ -1147,3 +1193,74 @@ void __init *cma_reserve_early(struct cma *cma, unsigned long size)
> return ret;
> }
> +
> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
> + unsigned int order_per_bit, const char *name)
> +{
> + struct cma *cma;
> + int ret;
> +
> + ret = cma_check_memory(base, size);
> + if (ret < 0)
> + return ERR_PTR(ret);
> +
> + cma = kzalloc_obj(*cma, GFP_KERNEL);
> + if (!cma)
> + return ERR_PTR(-ENOMEM);
> +
> + cma_init_area(cma, name, size, order_per_bit);
> + cma->ranges[0].base_pfn = PFN_DOWN(base);
> + cma->ranges[0].early_pfn = PFN_DOWN(base);
> + cma->ranges[0].count = cma->count;
> + cma->nranges = 1;
> +
> + cma_activate_area(cma);
> +
> + mutex_lock(&cma_lock);
> + list_add_tail(&cma->node, &cma_areas);
> + totalcma_pages += cma->count;
> + cma_area_count++;
> + mutex_unlock(&cma_lock);
> +
> + return cma;
> +}
> +
> +void cma_free(struct cma *cma)
> +{
> + unsigned int i;
> +
> + /*
> + * Safety check to prevent a CMA with active allocations from being
> + * released.
> + */
> + for (i = 0; i < cma->nranges; i++) {
> + unsigned long nbits = cma_bitmap_maxno(cma, &cma->ranges[i]);
> +
> + if (!bitmap_empty(cma->ranges[i].bitmap, nbits)) {
> + WARN(1, "%s: range %u not empty\n", cma->name, i);
> + return;
> + }
> + }
> +
> + /* free reserved pages and the bitmap */
> + for (i = 0; i < cma->nranges; i++) {
> + struct cma_memrange *cmr = &cma->ranges[i];
> + unsigned long end_pfn, pfn;
> +
> + end_pfn = cmr->base_pfn + cmr->count;
> + for (pfn = cmr->base_pfn; pfn < end_pfn; pfn++)
> + free_reserved_page(pfn_to_page(pfn));
> +
> + bitmap_free(cmr->bitmap);
> + }
> +
> + mutex_destroy(&cma->alloc_mutex);
> +
> + mutex_lock(&cma_lock);
> + totalcma_pages -= cma->count;
> + list_del(&cma->node);
> + cma_area_count--;
> + mutex_unlock(&cma_lock);
> +
> + kfree(cma);
> +}
> diff --git a/mm/cma.h b/mm/cma.h
> index c70180c36559..ae4db9819e38 100644
> --- a/mm/cma.h
> +++ b/mm/cma.h
> @@ -41,6 +41,7 @@ struct cma {
> unsigned long available_count;
> unsigned int order_per_bit; /* Order of pages represented by one bit */
> spinlock_t lock;
> + struct list_head node;
> struct mutex alloc_mutex;
> #ifdef CONFIG_CMA_DEBUGFS
> struct hlist_head mem_head;
> @@ -71,8 +72,8 @@ enum cma_flags {
> CMA_ACTIVATED,
> };
> -extern struct cma cma_areas[MAX_CMA_AREAS];
> -extern unsigned int cma_area_count;
> +extern struct cma cma_early_areas[MAX_EARLY_CMA_AREAS];
> +extern unsigned int cma_early_area_count;
> static inline unsigned long cma_bitmap_maxno(struct cma *cma,
> struct cma_memrange *cmr)
>
Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


