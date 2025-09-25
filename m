Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F903CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAF28E0008; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792E98E0001; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEE88E0008; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD3C8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:06:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02BD71DF92F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:06:26 +0000 (UTC)
X-FDA: 83927342814.26.31BA666
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 863DA1A0007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:06:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JuC04U5k;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758794785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtwmpZPCjNOwjMItaLVn8GYJUr1kz1Bfb1+TI3PcNUE=;
	b=5Dw6FLzFUEndAJTe9bSNb+EucUgk9DlX84TYoA9Zi46qoH52Q06R0XULOq/Dkd9G2k/Ub5
	wvzvbotSTMFEbnE6XHoyVTBIbrAggsQokUPrSBszHrECZpqG1Ap+rHy5Un97y1Fw3Rl+wX
	ofcH5eF+hUPbO2OGzMfOJB76QlMPzvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758794785; a=rsa-sha256;
	cv=none;
	b=51gd+7HnARjUKIU9KpfR1k68CDLZsvpoRV/nPClWuBvgmgJNXKPaNxLw/rWC4W8hw6LkE1
	ET40q+p6WzVhuatLVW1CfrCPp0jEp8zkdMbpol9Vr40FqXOlt1QJhsvfL+zlawdO8dP32+
	KJ4WG71joDA5oO2Lhuj6v6WO8ZyI/W4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JuC04U5k;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCVnYr+wCI1Ugl9RAgtdZ4AL7G+yOdkNfUZoCG+6AEb1INBpTgk1pBqE6Id0oVrHDsM7IF1F4DXdMw==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758794780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtwmpZPCjNOwjMItaLVn8GYJUr1kz1Bfb1+TI3PcNUE=;
	b=JuC04U5kE+Zytn/tVDr5fwzrezSENOm/k/joUgSMaiOdgyDI304LDB1kD+qxtoM8ZK+9aB
	KUizVhyvPKpboRAl45Sw3v8YNeP6nAq5Bu5ISI/nAyWlxGw1YdIPfcfcJlRR20w3DOMzcY
	RBEkaJ71sw5TiqehnVrY89LhUI/ilWQ=
X-Gm-Message-State: AOJu0YwMSAn89jA8z5YUTohHWOMe9jX5IzJL/lrKcqTHvGz6mCrqlmod
	kD2RRpiXRkvtOfeRgSwxuP2xWcuPS/THq60jKytqUnG7d+EgqjIpedbjZ7PBZRQ/v6ogj1UwWPt
	9hzpDdZsvDMjbYiUFJsBZOpoTFcIU6T4=
X-Google-Smtp-Source: AGHT+IF71+HS7nj4AXMSTXwCRsiI/oIr44gPCeQOdfiXJRiyJBTrygGIFffFbShN0CYuQklLT8TN/1t/9FCPuUGyTcs=
X-Received: by 2002:a05:6214:4f05:b0:804:9bb6:fe77 with SMTP id
 6a1803df08f44-8049bb7022bmr13404236d6.49.1758794774193; Thu, 25 Sep 2025
 03:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
In-Reply-To: <20250910024447.64788-3-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 25 Sep 2025 18:05:36 +0800
X-Gmail-Original-Message-ID: <CABzRoyaFv4ciJwcdU=1qQNvSWE_PPQonn7ehE7Zz_PHNHfN4gA@mail.gmail.com>
X-Gm-Features: AS18NWA9LEHOEgT6nKT_-lHmoS0ZA6SZH1mIenV7DALkzBHtOcVtCyJGULS1h_k
Message-ID: <CABzRoyaFv4ciJwcdU=1qQNvSWE_PPQonn7ehE7Zz_PHNHfN4gA@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 863DA1A0007
X-Stat-Signature: 4mjhbi71t3tbfm7dgza75iep136apdwt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758794784-888720
X-HE-Meta: U2FsdGVkX1+B1OhjSnhDFq5tX+ZwiWpV1HLBygpbjzIIMX8hddR5+oiMpbrgXV0KuF4eSanzmD5wNS0UUvpZ/5Qu6N5KvbkAR2A1HKj85y0Yv4RnrtH5FB4q54zhEB1w2OMYrzHdiN9WViazDlCbyW06jRN9mIDUo8SOz0TCgrR6sEMbA/TRC/VmZeMxtzmRiyA9kEF3ikEB9vGB4rbSykJ/ap3vIDzrSzfCRxUjRnzPIQ4yjFrwQTFcC+1uka2zKaxXs4hgteqAMZWG+hsX3xUYezox5E5MCUdR5XEh16IIVaJ/hP7Yd8GxTkFTrRv9//xYtq+Gjx/eWYHE2bbgDWvEi8TDONvTLP7BYFtiC8Prji2TxuTYqkwJTqHicoA4nLA2KUWUaNJvUCitcMLjrnHxBa9zmhn5yAuch62F3Pg/KVhPsaLdf9wdcmL6Ier9zIWsm157BYtyzmCT8JXsSIRH5mh/NsOXD33f9m4SgSutgW5uq86rxIAa1oyj5o0d2kPT2+9FIZb8fNC6xEesH4E5Vy5c8xIEK1QvoWIeBgcvy+y4lBTJeDPfORWaY1mnNSs0IhbXy784faX9x6Qey/+Eog92tBA1X+Vy4NZGlZuf93kklTE+sNtvS0xmY3Wt7TxHiY0lhb50T/vGJNNCplM1cfntCqI2+iaIc2tFdLFiSQzB7cb1wcWNp17cp4JiVp40fKZj8XH4pakpXWbi63ZnaX/+0RrE+xHANnZd1iRaUFAJNepup87SV8yn8Lc771pfK2Ih/SGehlzEmqylpJWQflpmjnRUfaj4FKx3rkLia/9eM3xG+qXhUEiUMh52Tzs0xu1Uf0ieQkT64bnDftkKn45QA23k8SRxy5Mrwaqc3MsvG+qqNTVEexhtLIQ3yMCywTnX2gSfdQIin8RwHgmoVwbY0Ra2OsIcYENdmofhkYNHgtrkhHu9lNsc14lq9DIKSwHNpcHne8BSvYW
 3SMORk9i
 GK3xX8uDL/plkzs8OZK7DgXd6pFeitPNkj6p/usL61qomUKmsbFiNikT+Sb/0AKhojh5f0dvb7zobswbGd7xbcVCnCUwRm0ILuhVYqs9fkW5ZBbEgiQw+hP5/RuiaPXAG2iGiKnNPgGIV3yUxnTPUbUga4PoX1SP5IVXg/J2uRupwrrv1bsWpkseD77xn36abLeaIaFWAAhmpnBpeGmbLVkWZCaaiL71lysaLIMutvZUs4xoo48r+OWHi8I5oZISjQ6UqDKDk80bdz+Tr5FtHPpiMLmynq9ofJdm3M81jJpalu3AyCJSRpk6HxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
> THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> programs to influence THP order selection based on factors such as:
> - Workload identity
>   For example, workloads running in specific containers or cgroups.
> - Allocation context
>   Whether the allocation occurs during a page fault, khugepaged, swap or
>   other paths.
> - VMA's memory advice settings
>   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> - Memory pressure
>   PSI system data or associated cgroup PSI metrics
>
> The kernel API of this new BPF hook is as follows,
>
> /**
>  * @thp_order_fn_t: Get the suggested THP orders from a BPF program for a=
llocation
>  * @vma: vm_area_struct associated with the THP allocation
>  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is=
 set
>  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_V=
M_NONE if
>  *            neither is set.
>  * @tva_type: TVA type for current @vma
>  * @orders: Bitmask of requested THP orders for this allocation
>  *          - PMD-mapped allocation if PMD_ORDER is set
>  *          - mTHP allocation otherwise
>  *
>  * Return: The suggested THP order from the BPF program for allocation. I=
t will
>  *         not exceed the highest requested order in @orders. Return -1 t=
o
>  *         indicate that the original requested @orders should remain unc=
hanged.
>  */
> typedef int thp_order_fn_t(struct vm_area_struct *vma,
>                            enum bpf_thp_vma_type vma_type,
>                            enum tva_type tva_type,
>                            unsigned long orders);
>
> Only a single BPF program can be attached at any given time, though it ca=
n
> be dynamically updated to adjust the policy. The implementation supports
> anonymous THP, shmem THP, and mTHP, with future extensions planned for
> file-backed THP.
>
> This functionality is only active when system-wide THP is configured to
> madvise or always mode. It remains disabled in never mode. Additionally,
> if THP is explicitly disabled for a specific task via prctl(), this BPF
> functionality will also be unavailable for that task.
>
> This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to b=
e
> enabled. Note that this capability is currently unstable and may undergo
> significant changes=E2=80=94including potential removal=E2=80=94in future=
 kernel versions.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

I've tested this patch on my machine, and it works as expected. Using BPF
hooks to control THP is a great step forward!

Tested-by: Lance Yang <lance.yang@linux.dev>

This work also inspires some ideas for another useful hook for THP that I
might propose in the future, once this series is settled and merged ;)

Cheers,
Lance

> ---
>  MAINTAINERS             |   1 +
>  include/linux/huge_mm.h |  26 ++++-
>  mm/Kconfig              |  12 ++
>  mm/Makefile             |   1 +
>  mm/huge_memory_bpf.c    | 243 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 280 insertions(+), 3 deletions(-)
>  create mode 100644 mm/huge_memory_bpf.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fef05bc2224..d055a3c95300 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16252,6 +16252,7 @@ F:      include/linux/huge_mm.h
>  F:     include/linux/khugepaged.h
>  F:     include/trace/events/huge_memory.h
>  F:     mm/huge_memory.c
> +F:     mm/huge_memory_bpf.c
>  F:     mm/khugepaged.c
>  F:     mm/mm_slot.h
>  F:     tools/testing/selftests/mm/khugepaged.c
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 23f124493c47..f72a5fd04e4f 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
>         TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
>         TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
>         TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> +       TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached *=
/
>  };
>
>  struct kobject;
> @@ -270,6 +271,19 @@ unsigned long __thp_vma_allowable_orders(struct vm_a=
rea_struct *vma,
>                                          enum tva_type type,
>                                          unsigned long orders);
>
> +#ifdef CONFIG_BPF_GET_THP_ORDER
> +unsigned long
> +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_flags=
,
> +                       enum tva_type type, unsigned long orders);
> +#else
> +static inline unsigned long
> +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_flags=
,
> +                       enum tva_type tva_flags, unsigned long orders)
> +{
> +       return orders;
> +}
> +#endif
> +
>  /**
>   * thp_vma_allowable_orders - determine hugepage orders that are allowed=
 for vma
>   * @vma:  the vm area to check
> @@ -291,6 +305,12 @@ unsigned long thp_vma_allowable_orders(struct vm_are=
a_struct *vma,
>                                        enum tva_type type,
>                                        unsigned long orders)
>  {
> +       unsigned long bpf_orders;
> +
> +       bpf_orders =3D bpf_hook_thp_get_orders(vma, vm_flags, type, order=
s);
> +       if (!bpf_orders)
> +               return 0;
> +
>         /*
>          * Optimization to check if required orders are enabled early. On=
ly
>          * forced collapse ignores sysfs configs.
> @@ -304,12 +324,12 @@ unsigned long thp_vma_allowable_orders(struct vm_ar=
ea_struct *vma,
>                     ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled(=
)))
>                         mask |=3D READ_ONCE(huge_anon_orders_inherit);
>
> -               orders &=3D mask;
> -               if (!orders)
> +               bpf_orders &=3D mask;
> +               if (!bpf_orders)
>                         return 0;
>         }
>
> -       return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
> +       return __thp_vma_allowable_orders(vma, vm_flags, type, bpf_orders=
);
>  }
>
>  struct thpsize {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index d1ed839ca710..4d89d2158f10 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -896,6 +896,18 @@ config NO_PAGE_MAPCOUNT
>
>           EXPERIMENTAL because the impact of some changes is still unclea=
r.
>
> +config BPF_GET_THP_ORDER
> +       bool "BPF-based THP order selection (EXPERIMENTAL)"
> +       depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> +
> +       help
> +         Enable dynamic THP order selection using BPF programs. This
> +         experimental feature allows custom BPF logic to determine optim=
al
> +         transparent hugepage allocation sizes at runtime.
> +
> +         WARNING: This feature is unstable and may change in future kern=
el
> +         versions.
> +
>  endif # TRANSPARENT_HUGEPAGE
>
>  # simple helper to make the code a bit easier to read
> diff --git a/mm/Makefile b/mm/Makefile
> index 21abb3353550..f180332f2ad0 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
>  obj-$(CONFIG_NUMA) +=3D memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) +=3D migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o khugepaged.o
> +obj-$(CONFIG_BPF_GET_THP_ORDER) +=3D huge_memory_bpf.o
>  obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
>  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
>  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> new file mode 100644
> index 000000000000..525ee22ab598
> --- /dev/null
> +++ b/mm/huge_memory_bpf.c
> @@ -0,0 +1,243 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * BPF-based THP policy management
> + *
> + * Author: Yafang Shao <laoar.shao@gmail.com>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/huge_mm.h>
> +#include <linux/khugepaged.h>
> +
> +enum bpf_thp_vma_type {
> +       BPF_THP_VM_NONE =3D 0,
> +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> +};
> +
> +/**
> + * @thp_order_fn_t: Get the suggested THP orders from a BPF program for =
allocation
> + * @vma: vm_area_struct associated with the THP allocation
> + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE i=
s set
> + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_=
VM_NONE if
> + *            neither is set.
> + * @tva_type: TVA type for current @vma
> + * @orders: Bitmask of requested THP orders for this allocation
> + *          - PMD-mapped allocation if PMD_ORDER is set
> + *          - mTHP allocation otherwise
> + *
> + * Return: The suggested THP order from the BPF program for allocation. =
It will
> + *         not exceed the highest requested order in @orders. Return -1 =
to
> + *         indicate that the original requested @orders should remain un=
changed.
> + */
> +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> +                          enum bpf_thp_vma_type vma_type,
> +                          enum tva_type tva_type,
> +                          unsigned long orders);
> +
> +struct bpf_thp_ops {
> +       thp_order_fn_t __rcu *thp_get_order;
> +};
> +
> +static struct bpf_thp_ops bpf_thp;
> +static DEFINE_SPINLOCK(thp_ops_lock);
> +
> +/*
> + * Returns the original @orders if no BPF program is attached or if the
> + * suggested order is invalid.
> + */
> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> +                                     vm_flags_t vma_flags,
> +                                     enum tva_type tva_type,
> +                                     unsigned long orders)
> +{
> +       thp_order_fn_t *bpf_hook_thp_get_order;
> +       unsigned long thp_orders =3D orders;
> +       enum bpf_thp_vma_type vma_type;
> +       int thp_order;
> +
> +       /* No BPF program is attached */
> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +                     &transparent_hugepage_flags))
> +               return orders;
> +
> +       if (vma_flags & VM_HUGEPAGE)
> +               vma_type =3D BPF_THP_VM_HUGEPAGE;
> +       else if (vma_flags & VM_NOHUGEPAGE)
> +               vma_type =3D BPF_THP_VM_NOHUGEPAGE;
> +       else
> +               vma_type =3D BPF_THP_VM_NONE;
> +
> +       rcu_read_lock();
> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_order)=
;
> +       if (!bpf_hook_thp_get_order)
> +               goto out;
> +
> +       thp_order =3D bpf_hook_thp_get_order(vma, vma_type, tva_type, ord=
ers);
> +       if (thp_order < 0)
> +               goto out;
> +       /*
> +        * The maximum requested order is determined by the callsite. E.g=
.:
> +        * - PMD-mapped THP uses PMD_ORDER
> +        * - mTHP uses (PMD_ORDER - 1)
> +        *
> +        * We must respect this upper bound to avoid undefined behavior. =
So the
> +        * highest suggested order can't exceed the highest requested ord=
er.
> +        */
> +       if (thp_order <=3D highest_order(orders))
> +               thp_orders =3D BIT(thp_order);
> +
> +out:
> +       rcu_read_unlock();
> +       return thp_orders;
> +}
> +
> +static bool bpf_thp_ops_is_valid_access(int off, int size,
> +                                       enum bpf_access_type type,
> +                                       const struct bpf_prog *prog,
> +                                       struct bpf_insn_access_aux *info)
> +{
> +       return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static const struct bpf_func_proto *
> +bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *=
prog)
> +{
> +       return bpf_base_func_proto(func_id, prog);
> +}
> +
> +static const struct bpf_verifier_ops thp_bpf_verifier_ops =3D {
> +       .get_func_proto =3D bpf_thp_get_func_proto,
> +       .is_valid_access =3D bpf_thp_ops_is_valid_access,
> +};
> +
> +static int bpf_thp_init(struct btf *btf)
> +{
> +       return 0;
> +}
> +
> +static int bpf_thp_check_member(const struct btf_type *t,
> +                               const struct btf_member *member,
> +                               const struct bpf_prog *prog)
> +{
> +       /* The call site operates under RCU protection. */
> +       if (prog->sleepable)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int bpf_thp_init_member(const struct btf_type *t,
> +                              const struct btf_member *member,
> +                              void *kdata, const void *udata)
> +{
> +       return 0;
> +}
> +
> +static int bpf_thp_reg(void *kdata, struct bpf_link *link)
> +{
> +       struct bpf_thp_ops *ops =3D kdata;
> +
> +       spin_lock(&thp_ops_lock);
> +       if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +                            &transparent_hugepage_flags)) {
> +               spin_unlock(&thp_ops_lock);
> +               return -EBUSY;
> +       }
> +       WARN_ON_ONCE(rcu_access_pointer(bpf_thp.thp_get_order));
> +       rcu_assign_pointer(bpf_thp.thp_get_order, ops->thp_get_order);
> +       spin_unlock(&thp_ops_lock);
> +       return 0;
> +}
> +
> +static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
> +{
> +       thp_order_fn_t *old_fn;
> +
> +       spin_lock(&thp_ops_lock);
> +       clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepag=
e_flags);
> +       old_fn =3D rcu_replace_pointer(bpf_thp.thp_get_order, NULL,
> +                                    lockdep_is_held(&thp_ops_lock));
> +       WARN_ON_ONCE(!old_fn);
> +       spin_unlock(&thp_ops_lock);
> +
> +       synchronize_rcu();
> +}
> +
> +static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link =
*link)
> +{
> +       thp_order_fn_t *old_fn, *new_fn;
> +       struct bpf_thp_ops *old =3D old_kdata;
> +       struct bpf_thp_ops *ops =3D kdata;
> +       int ret =3D 0;
> +
> +       if (!ops || !old)
> +               return -EINVAL;
> +
> +       spin_lock(&thp_ops_lock);
> +       /* The prog has aleady been removed. */
> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> +                     &transparent_hugepage_flags)) {
> +               ret =3D -ENOENT;
> +               goto out;
> +       }
> +
> +       new_fn =3D rcu_dereference(ops->thp_get_order);
> +       old_fn =3D rcu_replace_pointer(bpf_thp.thp_get_order, new_fn,
> +                                    lockdep_is_held(&thp_ops_lock));
> +       WARN_ON_ONCE(!old_fn || !new_fn);
> +
> +out:
> +       spin_unlock(&thp_ops_lock);
> +       if (!ret)
> +               synchronize_rcu();
> +       return ret;
> +}
> +
> +static int bpf_thp_validate(void *kdata)
> +{
> +       struct bpf_thp_ops *ops =3D kdata;
> +
> +       if (!ops->thp_get_order) {
> +               pr_err("bpf_thp: required ops isn't implemented\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int bpf_thp_get_order(struct vm_area_struct *vma,
> +                            enum bpf_thp_vma_type vma_type,
> +                            enum tva_type tva_type,
> +                            unsigned long orders)
> +{
> +       return -1;
> +}
> +
> +static struct bpf_thp_ops __bpf_thp_ops =3D {
> +       .thp_get_order =3D (thp_order_fn_t __rcu *)bpf_thp_get_order,
> +};
> +
> +static struct bpf_struct_ops bpf_bpf_thp_ops =3D {
> +       .verifier_ops =3D &thp_bpf_verifier_ops,
> +       .init =3D bpf_thp_init,
> +       .check_member =3D bpf_thp_check_member,
> +       .init_member =3D bpf_thp_init_member,
> +       .reg =3D bpf_thp_reg,
> +       .unreg =3D bpf_thp_unreg,
> +       .update =3D bpf_thp_update,
> +       .validate =3D bpf_thp_validate,
> +       .cfi_stubs =3D &__bpf_thp_ops,
> +       .owner =3D THIS_MODULE,
> +       .name =3D "bpf_thp_ops",
> +};
> +
> +static int __init bpf_thp_ops_init(void)
> +{
> +       int err;
> +
> +       err =3D register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
> +       if (err)
> +               pr_err("bpf_thp: Failed to register struct_ops (%d)\n", e=
rr);
> +       return err;
> +}
> +late_initcall(bpf_thp_ops_init);
> --
> 2.47.3
>
>

