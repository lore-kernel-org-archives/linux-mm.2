Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA71CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 06:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3E78E0005; Sun, 12 Oct 2025 02:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DDB8E0002; Sun, 12 Oct 2025 02:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C6A8E0005; Sun, 12 Oct 2025 02:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2DC8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 02:11:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27200C07D5
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 06:11:26 +0000 (UTC)
X-FDA: 83988440172.29.B951FEA
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8696A0005
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 06:11:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AmCm4OLd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760249484; a=rsa-sha256;
	cv=none;
	b=k+7tc2FGHHa/EgJNVT6q4kHJ6RuwltdCWtz7c7uHtRLWCe0MLZc/OXnt2KvsFgjin2O+JF
	d/3rj0w2KPi8OpxTo57cQXKzXXqbSBWVvLaLIJihnL+dfvxkX1xBFogw8jB4VIsLQF1XaB
	WJpus0a+SfTcveGiPS50p1w+7gF5/g8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AmCm4OLd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760249484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foNWJ4E25V51roHi1w2GGGZKjeKD6i3dCTeTVLACyRo=;
	b=hKKzDrOQoprSnI0Ey1aEGJVnAWAFd1t2HkHSu6nQPksRnXFhsjjkoK8yLwgEi9K9Ba+4OH
	Us+9E6CIoPewb/wEdQtAwh9+E2begMCVXNAW03nsMQRPa10XiuPVCkuPl1NSM2pSpDUhV3
	wVcepK0O8sH/tnXBFAd3xaC88g5s6pU=
X-Forwarded-Encrypted: i=1; AJvYcCUTE/4NKt4vo4McidoKHh+CpIV4VxB2Jtd1ZMAqb62tAmID/CNH8PbXCnuYZS18gf6VYZIcH+vdbw==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760249481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foNWJ4E25V51roHi1w2GGGZKjeKD6i3dCTeTVLACyRo=;
	b=AmCm4OLdBdqJRTSKZ0PkYqRKPYjzUZqX01C5LZUmqFHedTlI7wqVY6k+FHuIGzb97HZ0fT
	xsJcz7/F1HAPxcstmf+uysirAQHmwZFhNll1W+mxiDrpcjm5W4Yh5vwdf0yerFDgnG1viM
	yXL4mSqkWEwiItv9MxTFfjCMH2q38vg=
X-Gm-Message-State: AOJu0YxjrjQbUXSwVRJz2avdp0Hi6Jwa/PxdW7GQMzwrTGHZE9PY6iTx
	bLNRHWyIBttlmN/9ARr3dplQHvl8p2afj9zGnGDECQlD9f2UUoI6Gjx/AUdTVmYyW9/lcRtMDea
	/2iHiKF1FCTcrVljwvsGcMe7iOos1hRc=
X-Google-Smtp-Source: AGHT+IGS0m07WNkCv+xO8uTbgSUz2CohzI7fDRMEZdBsffTcs/wloxbDLAkjPyEDGkuh6+Hjmc9gNd3T1rXw4qkFyCk=
X-Received: by 2002:ad4:5ca4:0:b0:77c:a783:c9c6 with SMTP id
 6a1803df08f44-87b21015103mr220167516d6.3.1760249475096; Sat, 11 Oct 2025
 23:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <20251001065707.920170-1-balbirs@nvidia.com> <20251001065707.920170-2-balbirs@nvidia.com>
In-Reply-To: <20251001065707.920170-2-balbirs@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sun, 12 Oct 2025 14:10:37 +0800
X-Gmail-Original-Message-ID: <CABzRoyYJXVdgTdoz9uYxeYHeejU1bbe6_rQnvbKns7fjvz_kqQ@mail.gmail.com>
X-Gm-Features: AS18NWC8_Z-3ZIKnbl1wff6T8kbSmzYyB0uKsUmMixJLXumxkUIzTUIiVVMKwFw
Message-ID: <CABzRoyYJXVdgTdoz9uYxeYHeejU1bbe6_rQnvbKns7fjvz_kqQ@mail.gmail.com>
Subject: Re: [v7 01/16] mm/zone_device: support large zone device private folios
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
	Matthew Brost <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: isgw16guduujmd3eoameetszmdjfdhfr
X-Rspamd-Queue-Id: E8696A0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760249483-255940
X-HE-Meta: U2FsdGVkX184ZCOcQOx0IWNtum/nP1vXK12OGu39cGVAGgLyVX3fY5TlRpftt3HW6O/zsDJs5svNPNdYuYQXockzwCGYmECc2i4JmjP1oDqnKsOdWxrESDloyQP/xjSxubzckmmNhETpgyvK9UXu1/FFUtt5teBoeF+cq5Dk7fdUH5qjpftVnZDFYRK0yREdr3JSvtBOreolBR7YwupJ+Tcjkd7ibW9SLEv4s4uJs106pguaqx8PtIgOnyTiAU9tKUTQy9lsz2rG23j9pQtS2nUX2mwXX/e7mBwW+etgpoqO8d/4gv+5a5aDSfliKg/DRF+KL1rybBxD4FOf9BSRE+Fi9ihsqTGXeZokqg8z1uoy42xd2Tn9u7D+H5nU2Omt0ioO29QUP2giUx6zPCoILt3Cgv2tjkqdKBRyIZq+eRtHcA2K8oQSuARkLdnhP5tLetgyZ5oHzH63n/uyTqMi51KE+sdbeg1OLqgOtAmKTAToHapn36lInWdmskUQTgjlW16cMSwJ/MHAT7IYNS9SSIVdGnPA8Rn5Zq6F6xSdSBMdfAPayckY165AxI1gyvpnhNZXk5Ocd2F1tn3PK31CHvATIk0irhODS3XzrfeuFYlHgsTqGErMzfMvf8POPOHRsIPwwN/mCICI0mRiB6KXfP3jeZAOWTeh9sEX6ZZ6BYVSuyzs7BjANuNEcVC1azMs+hPfTw4lx9IqKFzXDZmhsaYgNVbSHDsdlsbonH1D/0ujqOdwMb8r7x+RHqLAzIA8xQJvB+5qNcSiaQID5zm5snrvvXO763koTCcVJxCauxpCyZ/lHAbymvCJSWE6OgI1Sv7KzDSsIxsvpw0nW6NXRLXjtBpeokSJmzp+kZhKy64PovS8kl1E5DIWG/1+vlMIT18elr2259zcwnRPbSyNsFWBfDRF963VDkm17zYya8BEyJJgDbBGHrS20s7c/N67UyCUZEpWik09Wzu8E2D
 vyFVs/fv
 3BB0nsMwNcqTUYnvvvTN5vfpS1BWNBFqDlhIMbGBfs8vMqO3gUmeNTu3JY3skmXE9MBUWFeStJOkTbyTCbgCONsNaW1qFiTJGgTvWrk5ODHKI3Qbhmbl60/3fe0K/wt9/DcvGU/+z8jlciCdzzFUGrIdOkrEFRwoFbP0kr9TW06CoQgIDMshqhpX27ZOYSH1U4ubJWYiwtJrtzaEt+TqdOEBt3srIXnmwraCLLSwrSFnNcZ78gNlixnm3AoVgxd4HLB8RHyDGGXTFdZTHqL2hAcAQE+/ELBScyDtgCZEHauxQthTdfiMv9cs2cgnH8hJGLoJiUkDLXapkR+1ZRTGpIONpd3Bmhf7z8NjqkO15tpuSfi/F/pZ/xyQ/TaeSCNu8AZUi7IrdnuEjm4XF4v4HwgSoRdCC4owKHvJrJaEGULBDwhPc95a/cYH0KcZT0k+ePiScXr4tPw3+G2vC0eNNT7Vr63seqZiB1C/wkjSyidalYpwC321AX0OsAa8on2PtvAr+udxbhdD/BsCmT2xdZpKmNHyCHygRYLPAXhBOQjJLhL2SZxP7zmQwGVqPbg4eGbKdg2zjOPV+HMFfPYrvNflS+5/p6lS28g1ZaEhsjJtEPek7L2RBXnx5iuARn+w+d4ZcJQilAEazcdQ+iCIEAen0P65OE1LqiODscEmIlv6WYC67AsXgnhKr8/Coyk6LP8vhzUoUNXUgFG/Kn2sxEmnJlqhE97N4VKpBr/vtOUcZIgXhT8ihLOUufVDvbnHZqrLKHo2vUbmQMRTcd1CVur5Er4spQBiIcXjB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

Just one nit below :)

On Wed, Oct 1, 2025 at 3:43=E2=80=AFPM Balbir Singh <balbirs@nvidia.com> wr=
ote:
>
> Add routines to support allocation of large order zone device folios
> and helper functions for zone device folios, to check if a folio is
> device private and helpers for setting zone device data.
>
> When large folios are used, the existing page_free() callback in
> pgmap is called when the folio is freed, this is true for both
> PAGE_SIZE and higher order pages.
>
> Zone device private large folios do not support deferred split and
> scan like normal THP folios.
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian K=C3=B6nig" <christian.koenig@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
>  drivers/gpu/drm/drm_pagemap.c            |  2 +-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
>  include/linux/memremap.h                 | 10 ++++++++-
>  lib/test_hmm.c                           |  2 +-
>  mm/memremap.c                            | 26 ++++++++++++++----------
>  mm/rmap.c                                |  6 +++++-
>  8 files changed, 34 insertions(+), 18 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s=
_hv_uvmem.c
> index 03f8c34fa0a2..91f763410673 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned lo=
ng gpa, struct kvm *kvm)
>
>         dpage =3D pfn_to_page(uvmem_pfn);
>         dpage->zone_device_data =3D pvt;
> -       zone_device_page_init(dpage);
> +       zone_device_page_init(dpage, 0);
>         return dpage;
>  out_clear:
>         spin_lock(&kvmppc_uvmem_bitmap_lock);
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/a=
md/amdkfd/kfd_migrate.c
> index 79251f22b702..d0e2cae33035 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_range *prange, u=
nsigned long pfn)
>         page =3D pfn_to_page(pfn);
>         svm_range_bo_ref(prange->svm_bo);
>         page->zone_device_data =3D prange->svm_bo;
> -       zone_device_page_init(page);
> +       zone_device_page_init(page, 0);
>  }
>
>  static void
> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.=
c
> index 1da55322af12..31c53f724e25 100644
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -196,7 +196,7 @@ static void drm_pagemap_get_devmem_page(struct page *=
page,
>                                         struct drm_pagemap_zdd *zdd)
>  {
>         page->zone_device_data =3D drm_pagemap_zdd_get(zdd);
> -       zone_device_page_init(page);
> +       zone_device_page_init(page, 0);
>  }
>
>  /**
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nou=
veau/nouveau_dmem.c
> index ca4932a150e3..53cc1926b9da 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> @@ -318,7 +318,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *dr=
m)
>                         return NULL;
>         }
>
> -       zone_device_page_init(page);
> +       zone_device_page_init(page, 0);
>         return page;
>  }
>
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index e5951ba12a28..d2487a19cba2 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *p=
age)
>  }
>
>  #ifdef CONFIG_ZONE_DEVICE
> -void zone_device_page_init(struct page *page);
> +void zone_device_page_init(struct page *page, unsigned int order);
>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>  void memunmap_pages(struct dev_pagemap *pgmap);
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)=
;
> @@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pf=
n);
>  bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
>
>  unsigned long memremap_compat_align(void);
> +
> +static inline void zone_device_folio_init(struct folio *folio, unsigned =
int order)
> +{
> +       zone_device_page_init(&folio->page, order);
> +       if (order)
> +               folio_set_large_rmappable(folio);
> +}
> +
>  #else
>  static inline void *devm_memremap_pages(struct device *dev,
>                 struct dev_pagemap *pgmap)
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 83e3d8208a54..24d82121cde8 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -627,7 +627,7 @@ static struct page *dmirror_devmem_alloc_page(struct =
dmirror_device *mdevice)
>                         goto error;
>         }
>
> -       zone_device_page_init(dpage);
> +       zone_device_page_init(dpage, 0);
>         dpage->zone_device_data =3D rpage;
>         return dpage;
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 46cb1b0b6f72..e45dfb568710 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>  void free_zone_device_folio(struct folio *folio)
>  {
>         struct dev_pagemap *pgmap =3D folio->pgmap;
> +       unsigned long nr =3D folio_nr_pages(folio);
> +       int i;
>
>         if (WARN_ON_ONCE(!pgmap))
>                 return;
>
>         mem_cgroup_uncharge(folio);
>
> -       /*
> -        * Note: we don't expect anonymous compound pages yet. Once suppo=
rted
> -        * and we could PTE-map them similar to THP, we'd have to clear
> -        * PG_anon_exclusive on all tail pages.
> -        */
>         if (folio_test_anon(folio)) {
> -               VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
> -               __ClearPageAnonExclusive(folio_page(folio, 0));
> +               for (i =3D 0; i < nr; i++)
> +                       __ClearPageAnonExclusive(folio_page(folio, i));
> +       } else {
> +               VM_WARN_ON_ONCE(folio_test_large(folio));
>         }
>
>         /*
> @@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
>         case MEMORY_DEVICE_COHERENT:
>                 if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>                         break;
> -               pgmap->ops->page_free(folio_page(folio, 0));
> -               put_dev_pagemap(pgmap);
> +               pgmap->ops->page_free(&folio->page);
> +               percpu_ref_put_many(&folio->pgmap->ref, nr);

Nit: &pgmap->ref here for consistency?

Cheers,
Lance

