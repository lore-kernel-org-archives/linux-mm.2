Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4561D4662B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6396B0005; Thu, 15 Jan 2026 16:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483C66B008A; Thu, 15 Jan 2026 16:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386146B008C; Thu, 15 Jan 2026 16:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25FB26B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:20:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C90AF13A945
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:20:23 +0000 (UTC)
X-FDA: 84335466726.03.C86DBDE
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id B765E1A0010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:20:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JyIFlezB;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768512021; a=rsa-sha256;
	cv=pass;
	b=etrJ+FxVLrwKTRppbX1oRFTPEllLBoSNfTvWZz7iVVVd27hJ+y37SLxb+l5EaXFGY5NE/T
	KUxiUTyF0ZqUF8wlAbWm1I28X+FATgLjYFp+iRPoZxnZ5qDeKKihkvEqhnGnHedrMOYZon
	9RFsmqrPVo+d55l9zuibj88suuXYuzE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JyIFlezB;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768512021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
	b=5LIuBPOWMGwC1KyLCxs6cqTkPkU5E+HzRk0ipzMZPB0xlZkiqQgl9Um+dmO0xqWtPPQbyc
	S/dufF3aqhwqteZ3zjw74HFWNVx/AgzGFBfynAcgBbiZ7mUfqbHuvOAT3ofFaFXe5TjxUa
	qZDCiy9IzUs1c7r8XYXDGmWs8x1Iewc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so3745e9.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:20:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768512020; cv=none;
        d=google.com; s=arc-20240605;
        b=LZS0kEJoVaMlhJo09yWYW7g5txCh9JvfyDNeWjgUannhqB/gjMQVEvWNyUj6f2cD4t
         V2Lh74JVc5GPxHB9MGAwCoUrBWZRC6+idplhkm0ZLflRoKkM14Tbcza4or4jEmC8L69S
         NCDE47/EaB/el/Uhx8PQUbcUh6laji/tYyNAsxdso10mYErCvBwJRhh04/wBzE+5tnkq
         JdZmuDC9vEecGEWr+89qgtikFPqiD4BaBOdrIpAZolK5I9X/0Hjh95ggkNF4kusjPpkB
         8JUMEGfaQXJFLMYCEgBS+RHMRkv10lmEN8IZrXsDuJ0R5kLeXCeP4wjQ1OCluNtLG7Ns
         1CGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        fh=eIbNFR4AylngGskugOuGKQjIEpO7B24OLl5zdcGrJOM=;
        b=RdhDAkbTz5g+2vthqttpRZQSytkrwyBWs73vazT5sYPcxa0sW0JinlYEtebUgSOnc+
         zktsBnmyO/qnbczguanFlBAn5RqItKyD4Xsu2QdJ9zZ/VFuNi52rnHqUd/7wD3MHXfwA
         Lt/jLck3IF8SZgqACVRZ/vrM83+K2ug2GEAiJJpkZLrWoNlNHfCHAIGCH7s+RAAj2+2i
         el7Hh/G08AOqutSIShzBtCIh2JLVWPxMDKMMkd+QSqNTi8XcPYiLBPxsYSSKPbKaAm1T
         LrMnQlvDENcxUzshaCLtj4GZ9yeyNPIJn5rjMWBp75GwB4a805g3gynyb6qJGS+6CDtz
         xbcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768512020; x=1769116820; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        b=JyIFlezBTXU6XI8t+JiQos6D65dlfiNIcuCN47o8Nq3wfrxrd9Zm0bNEdmEtPLpfp3
         P1FruJ1HYA50EP//r+Ey3Fa94Q7lb0yBULVEqt9RqvArvTZRB1Zk6rHMEgRIZACqymp5
         jubOZxHPBSL9wfoHma+H2s2ow61rWn3AhOuwT80n3L/xGu8pEe003X6YZR1+HZmUYQBf
         JxI67Q5pVoORO8LNuCj9dEceN1sggtPvy0hQxcEm1Mxjncme4fl7iaZMznmoMl6X7VGF
         PSpNGDJ8F/1xRZ/WaAC/TcLdnqrZTbfk3f76fnUHWzAPakV9iptB2SUI4FnR8OqriuGR
         EzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768512020; x=1769116820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        b=iCOQql9+dDW77fAvfiQf0TMTxr5ReNtsTGBj3p0dVsaDA2vXfyWNz3DM7w7Ivj0Sye
         rWPWTGAXRvOIbGc0fHsSyyucarOmGtVWgNVb/guvWKoseaOVizT7CNSrLf4m21gwUF/q
         2iXpPpMs65e+PZfFvN9araWy+zF6eqKeGesTjZgGLI2dFuL5hcdngkCrF/i/c5FWuu4/
         MURAlbBegx9QgWUOgTo0aDi/ABt+pNM0O6wvsgs/FPI7WaDekm6KDZZqeyoovfk6ORpp
         1/PK0rxwnjH0NrmYB6cyOUDh6Yljit68o427ovNKPBKT36zELnjiQl2jUirrVfervLE6
         EAsA==
X-Forwarded-Encrypted: i=1; AJvYcCUmf09gikRcLXajxqJ2vdQFoIMk4/LBf/GRSEXzel0qwV34w/srwTOvyKYR6c2Kn18FipyUc0S86Q==@kvack.org
X-Gm-Message-State: AOJu0YzdKMze4CBZbOjj9gZScm/UcrMBvE2BRaipwfRJ8SYf3VmtwsF9
	WdDtepAXNOUsrioVhH978WY4cH8gLJj3qshJcw/lWeSD6KEECQUATyKApVqJ2+7Ri3k2h+/sll2
	lnquPhYJVKJNigDrrewWhgsru106TYBtpmzrjeNlS
X-Gm-Gg: AY/fxX40lDHd0VBKI1tFSrjggdNJKkbhtP/EhYvMBbpGTxfKoZ+XRqfQBYUGEH1BF5n
	dtzurOKBZbXY3Rk4V6nqg07QGzth6Wm+ui3CPAyf8geT8DafnI8sLOXBafLKLJ2lpTZNEfhzwtc
	eWagEFsFZ6THR4HOpKkICj+6JsOHcdlWpE/NQWBODi/9gJnW1lO85PnsMuap74v4FH9sYVFz35X
	RxGxNUOivq6gc5r2oB/p2r89y/abmHMe9GSN5Z8iO5qvsAjgLa1N9Pi/pTLQ+lDArckqXO+fqdO
	lMwJiY7/5B5y26CqOc9pQY4T
X-Received: by 2002:a05:600c:468a:b0:477:b358:d7a9 with SMTP id
 5b1f17b1804b1-480204bfffamr24575e9.17.1768512019664; Thu, 15 Jan 2026
 13:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20260115202849.2921-1-ankita@nvidia.com> <20260115202849.2921-3-ankita@nvidia.com>
In-Reply-To: <20260115202849.2921-3-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 15 Jan 2026 13:20:08 -0800
X-Gm-Features: AZwV_QhBtJQLpsGGps1RVbuG0tmlIx9i0vGhKXKUsXRR6UijAxEGWZEH6i07fe4
Message-ID: <CACw3F50xHwggyfJWoMKExGwP1-zPbc3ePsUDNjzVmuigixNG_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
To: ankita@nvidia.com
Cc: vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, jgg@ziepe.ca, 
	skolothumtho@nvidia.com, alex@shazbot.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, cjia@nvidia.com, zhiw@nvidia.com, kjaju@nvidia.com, 
	yishaih@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B765E1A0010
X-Stat-Signature: 1xt99rq55uwrdg7713hi8rj518b79usi
X-Rspam-User: 
X-HE-Tag: 1768512021-611803
X-HE-Meta: U2FsdGVkX18Usis1JiDFEhD3rm8EIF3Mt9UtBURw5FnyBHGqeTMOlZR9unH+g0kZGNnS00s8Rq8K7ZucOi6YzkwgrsWmU34IRFTWlliVYAmryZdl+6Vq2ubJw2JZgryeudsUUvIXoUAdWh1O0JHkWRJeHeParuiSiIjFQdVrkQzGVF1jCPkgcYrq6d8yRCb6idQeCCGM4MuTTZzqFT/HEnndX3JaU9E0+w1DW5o8yl+yPOW727EdkcATpWkN2+OKykjed+gePekySbgphHfzbLMCVhH7vWfxRexp5A6tLQiM71UJO1xbGKsMZDTp/jDozu81KbpWsjrMXVGcRU5lXGApApSjN5Fpd47lDUk2hPqy6JT0N08B1RQMUHeGbhguA2E1rt1jxjxt61zwhIfwfYeFA9Bx7eOVQVvbyTIDjyJJAWgT1OfP2Mo+bvgGXQFZXRcRaNqmFVgPjIZGlDcfU7R8OoSKQb/OcTZ26N3vMFce4szDLvKiFQekFE7S/MLCLCVoIcofsWdN/8tvFRdrY+JQdqUM99EKzCG7TqA/rj29H9p7BUplhqxutCKqRVe5/vNOjl07LMt/39xbZlpCe0CEMcaYPOBRBbxeoIh7FF1jy3GenVSNqc03HwqGi12aidBuETRAA61lJr5uXQdgOqqFJhqInk7CbEa/yjVNhwfplu+zXxPs6dyHVY6ovnXh/nLv77ysDgTaf7XjXcNlIgoRigCbiYI3tf1KGLcpopFOpzVRQlTtofsA9UZbWwtF1bdgzjzKsvlJc7gkGrz3WZqgsUKi5k9EyKvAD5tzrhIsugXggmtwh5mqv9aLr1nfTbcnJPn8gkuB3wZ0QGQkT2rNEV8GXDa9sevkQ5rpwYa3/p2J9alUkdVQnZEETBqfBAXXKpfZBzd85H6C8vDxdX5LrdSpHoHW9SLO+Q5TeRRqdf/8WWiK0ubU/qRA8VcYfub2LlVOh5Y96gUfl5m
 goW01Ch4
 7nMO1trzgydIywGoX6onZ3mATDmguMjenbeRICcORd7B9svfyEV3TZLjJLDUlNOsgJvhFn+Wr6V/vcEVxuqDsA3Jd8XAEcnYWq0wr3tJRw2lSMHRpOQsJErBaMfA3Pngw8XojZpBDcLxW2mJ3WewCUEtoje6zYm+yvHutHUfaPESo06PGZY+bJ5njPB60BrTPUc49edpwlPmvlOm2eT2C0tUtcVawgPAWjoEtIFxgwRaUcsLkrq6eUmpyBkKvyY2gtWxzq7LWfUnDzNiw4tWMjIyec7pcaQibchQXBwSZ9M/h89pT/RMYz/UyQigd5AGbOfE6YzeI+zM+GS1909VTzHlZEVXHJMdWiyjWIqECYzW6yKfOVyAC5IxUjSxRm4XQ341pOkjXUCKMpahUMhve8jap9iDOvL3fTX5Og7o6721+TAysi8LQ+Bio5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 12:29=E2=80=AFPM <ankita@nvidia.com> wrote:
>
> From: Ankit Agrawal <ankita@nvidia.com>
>
> The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
> without adding the memory to the kernel. The device memory pages are PFNM=
AP
> and not backed by struct page. The module can thus utilize the MM's PFNMA=
P
> memory_failure mechanism that handles ECC/poison on regions with no struc=
t
> pages.
>
> The kernel MM code exposes register/unregister APIs allowing modules to
> register the device memory for memory_failure handling. Make nvgrace-gpu
> register the GPU memory with the MM on open.
>
> The module registers its memory region, the address_space with the
> kernel MM for ECC handling and implements a callback function to convert
> the PFN to the file page offset. The callback functions checks if the
> PFN belongs to the device memory region and is also contained in the
> VMA range, an error is returned otherwise.
>
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.co=
m/ [1]
>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-gpu/main.c
> index b45a24d00387..3be5d0d97aad 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -9,6 +9,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/memory-failure.h>
>
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -49,6 +50,7 @@ struct mem_region {
>                 void *memaddr;
>                 void __iomem *ioaddr;
>         };                      /* Base virtual address of the region */
> +       struct pfn_address_space pfn_address_space;
>  };
>
>  struct nvgrace_gpu_pci_core_device {
> @@ -88,6 +90,80 @@ nvgrace_gpu_memregion(int index,
>         return NULL;
>  }
>
> +static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvde=
v,
> +                               unsigned int index,
> +                               unsigned long pfn,
> +                               pgoff_t *pfn_offset_in_region)
> +{
> +       struct mem_region *region;
> +       unsigned long start_pfn, num_pages;
> +
> +       region =3D nvgrace_gpu_memregion(index, nvdev);
> +       if (!region)
> +               return -EINVAL;
> +
> +       start_pfn =3D PHYS_PFN(region->memphys);
> +       num_pages =3D region->memlength >> PAGE_SHIFT;
> +
> +       if (pfn < start_pfn || pfn >=3D start_pfn + num_pages)
> +               return -EFAULT;
> +
> +       *pfn_offset_in_region =3D pfn - start_pfn;
> +
> +       return 0;
> +}
> +
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *=
vma);
> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +                                       unsigned long pfn,
> +                                       pgoff_t *pgoff)
> +{
> +       struct nvgrace_gpu_pci_core_device *nvdev;
> +       unsigned int index =3D
> +               vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +       pgoff_t vma_offset_in_region =3D vma->vm_pgoff &
> +               ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +       pgoff_t pfn_offset_in_region;
> +       int ret;
> +
> +       nvdev =3D vma_to_nvdev(vma);
> +       if (!nvdev)
> +               return -ENOENT;
> +
> +       ret =3D pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_re=
gion);
> +       if (ret)
> +               return ret;
> +
> +       /* Ensure PFN is not before VMA's start within the region */
> +       if (pfn_offset_in_region < vma_offset_in_region)
> +               return -EFAULT;
> +
> +       /* Calculate offset from VMA start */
> +       *pgoff =3D vma->vm_pgoff +
> +                (pfn_offset_in_region - vma_offset_in_region);
> +
> +       return 0;
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
> +                                       struct mem_region *region)
> +{
> +       unsigned long pfn, nr_pages;
> +
> +       pfn =3D PHYS_PFN(region->memphys);
> +       nr_pages =3D region->memlength >> PAGE_SHIFT;
> +
> +       region->pfn_address_space.node.start =3D pfn;
> +       region->pfn_address_space.node.last =3D pfn + nr_pages - 1;
> +       region->pfn_address_space.mapping =3D core_vdev->inode->i_mapping=
;
> +       region->pfn_address_space.pfn_to_vma_pgoff =3D nvgrace_gpu_pfn_to=
_vma_pgoff;
> +
> +       return register_pfn_address_space(&region->pfn_address_space);
> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>         struct vfio_pci_core_device *vdev =3D
> @@ -114,14 +190,28 @@ static int nvgrace_gpu_open_device(struct vfio_devi=
ce *core_vdev)
>          * memory mapping.
>          */
>         ret =3D vfio_pci_core_setup_barmap(vdev, 0);
> -       if (ret) {
> -               vfio_pci_core_disable(vdev);
> -               return ret;
> +       if (ret)
> +               goto error_exit;
> +
> +       if (nvdev->resmem.memlength) {
> +               ret =3D nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev=
, &nvdev->resmem);
> +               if (ret && ret !=3D -EOPNOTSUPP)
> +                       goto error_exit;
>         }
>
> -       vfio_pci_core_finish_enable(vdev);
> +       ret =3D nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev=
->usemem);
> +       if (ret && ret !=3D -EOPNOTSUPP)
> +               goto register_mem_failed;
>
> +       vfio_pci_core_finish_enable(vdev);
>         return 0;
> +
> +register_mem_failed:
> +       if (nvdev->resmem.memlength)
> +               unregister_pfn_address_space(&nvdev->resmem.pfn_address_s=
pace);
> +error_exit:
> +       vfio_pci_core_disable(vdev);
> +       return ret;
>  }
>
>  static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> @@ -130,6 +220,11 @@ static void nvgrace_gpu_close_device(struct vfio_dev=
ice *core_vdev)
>                 container_of(core_vdev, struct nvgrace_gpu_pci_core_devic=
e,
>                              core_device.vdev);
>
> +       if (nvdev->resmem.memlength)
> +               unregister_pfn_address_space(&nvdev->resmem.pfn_address_s=
pace);
> +
> +       unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +
>         /* Unmap the mapping to the device memory cached region */
>         if (nvdev->usemem.memaddr) {
>                 memunmap(nvdev->usemem.memaddr);
> @@ -247,6 +342,16 @@ static const struct vm_operations_struct nvgrace_gpu=
_vfio_pci_mmap_ops =3D {
>  #endif
>  };
>
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *=
vma)
> +{
> +       /* Check if this VMA belongs to us */
> +       if (vma->vm_ops !=3D &nvgrace_gpu_vfio_pci_mmap_ops)
> +               return NULL;
> +
> +       return vma->vm_private_data;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>                             struct vm_area_struct *vma)
>  {
> --
> 2.34.1
>
>

Thanks for fixing the nit, Ankit! In case you need it:

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

