Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA770D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C336B0088; Thu,  8 Jan 2026 12:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9936B0089; Thu,  8 Jan 2026 12:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB8E6B0092; Thu,  8 Jan 2026 12:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A41D6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:00:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CB02140216
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:00:35 +0000 (UTC)
X-FDA: 84309410430.07.3445AFD
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33048C001F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:00:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EzurTzmS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767891633; a=rsa-sha256;
	cv=pass;
	b=2NF3YquYCDxIzA+bxArI1at4iD2SYjhoBCf+A//dqU3dw2J929IDFWZK0sIeoXNP/TIDRc
	A/2wJHKiByN9GaeGjsmwH39ozMoqEDHvZFi5IZ890oCw4Ye8ZeQp1zxrqzWXXN1r9/yOeE
	NuB1sqllDBTL33/DYUQlDP++X/9vAtA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EzurTzmS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767891633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
	b=XPjEJdgG3YzTDY5vfYUPZ3S3VGDAnqdS/cMSDOUBPMqBqsB1ZNTGn9OzS6/JJTiCefO36t
	1V479FuhaSK5SGp7oCfa4WzjNBu2j9uTb58S9NsX46VE8szqDDymiyBXU/FK63MPfk+3zA
	HtO8XrUwj1EgFiIcesqHAkLiKnAHAlI=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so134165e9.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 09:00:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767891631; cv=none;
        d=google.com; s=arc-20240605;
        b=JGywbQbtrODqpwjCoR8fNMy2jKPDG/3O6heRo46OrmylPIEIIB5MUKb/2OPLxdWieI
         ccqxXdHqabkeI3qbDmyXIKNqfltvVipBfCBDCFc/z2j3ldwenZDlSrlbsPGmDjxum5Cb
         k+omQWjJNf+tusrfMnaRgKUga+LEg1TOplGbNQdHQ2d+TqrJUULF9M006mLcYzIomfZh
         EOpLujDq6iIyqFJn9YdDifFT8NUfXknN+CTAPB7VhvbCOH5yinYAHLNH7y0gkYkB4h8z
         CRQmvM0oYARXmRDExHy10WvLBW8EH8RNkRH1F27JPRc+jtakOXyr/T8x6bAWY1KtYMcG
         GDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        fh=z0T/Jdb2XLSnwOaQM40nVu6d1zLhDU7FbVWSdNAu1XI=;
        b=gtaAtUFtcRb8snusjls51+/75hd9Sno4X5dgO6epjQYnKgU/ibcEnKkzA8mgfjx0Hr
         4Fq3tWipsz7Gm1CvMuonCDJY/674OBVe2appQbf1BPQYj8QFBY183/1B9f6x6Oi5OVVu
         AYWpd8d83qvrfARXACc1mTO/qOP4bMKto/uJ0BVOkMwiXySct9LRBriD5vqaZKRK5fgg
         ktg/VPkDqD1ti5s9gVrVy6w0Dz4dnc2XKledSXUaahdp8xZlbul2xoDAE1bcNObDcSGm
         X93chtGJPTiJ47GJeyqu+OXm+Ki4gO2jCV8J6ot91A7KBDC+2ELjY1+R+cqaDZEfKb23
         cDqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767891631; x=1768496431; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        b=EzurTzmSZ+yKWkmLAsboovHtUoNaw76oZBU/Xd4BrPYShBrGCaMlcGD2RCyPlHdVES
         0USeMKApVDRdYhjbx2ToyobOVMsBNetoxsXLt0NUowFuAT+203p8ATqfV+97U+jsgEwU
         nlI4bOnEeSm6MpdGanWnYTanPGFbI/owQUTJsJDLxJqbTqTJ7LICKGRMeQsV37/W4XqG
         /JG70XNBNv3NJCkazPxyZNLLSDI0DN11yTKxz6JXT/p5ie/mb/41HaJv1+ffIBVlGWhl
         ynvRqGcQn7eyvEmi24ktTTXe82v7zTnwm56l1sLwp9sKcxLapJIZihhHhL6dbFYLGl3D
         bPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767891631; x=1768496431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        b=DC/P9GhSOlaCrj8A2DXTLD1j7yDbMxXSPB3qqgMwhK/v4+IusYej52+0uple5KqlZs
         umeCFpn5/qd6WnB7JFXo+R5T9ZfFm64ZLfIe6m/kUXTwXQB8jkPN/0R1eVOZm+jK+yE+
         cst7ryEjff7qnx/tMWnnNPhcXXYWX+BTdgcgYdXfERjUhOv8MBCwbPBbZCtOEK4J5R3L
         YwINyTkuUOr4nWuvxC0HftwV1fLO1Ak/g8d7GFiPdIhr/Gh9i7kWPwiEWepBGeR2A+3M
         wGjzAASeT4glEBpOozWENjJ0Al9J6rWg6aXOZ9ONZ58KN5liNgZrJI4sIgOhkgS8e/Rp
         K2KA==
X-Forwarded-Encrypted: i=1; AJvYcCX+6cjV9nzD49Hc9C7NHp96tZYl5N7S7ybr2msbdsnxCHUjhkPKtr3MVhyI7B8Vz4Kaz19rArgKZg==@kvack.org
X-Gm-Message-State: AOJu0YymHC8aJPZu+hw9v1rrQtXkMpO5fmRZkB4/CsUHiFYPNAkc1u82
	pQl97ZnAo+H6MXLZr+9K+KTF/HSWhUyYwXw3N9staH82RzS5KuCguDOSNjAT+a7CmIlaNSxsGyS
	ppJiAptkJIG1b8GmtJ36bjAwGLtWNdquRhfKO0sij
X-Gm-Gg: AY/fxX6XjdTJriku1qewl7lMpeN374YHzyd8whVPmBjCxyzvoIqh4gfxEy/jH5qipYC
	YaN2N29hLmxx006OBUc7smddaYc0Vi9HZqeADxgsYrlMN2kp0/oLFXIi/MKjq+LmK1nCv2NrF/r
	vvNzGZGWDU0w1upNF4+7WTiv1/BZcwwe+6Q7uRB9bxfpl9b08LANmkaoluVB6upxVVAxEwTKhZ8
	MBsHNzqGDN0naXM7x/3SJoKrHDR1YcVcYDj8qWn7OaRi+c9EImo4qNW6bGsrK3HaairpqZxOD21
	EyBwDXnMSu8VE6iUBVBUAayYTfkI
X-Received: by 2002:a05:600c:c04f:b0:47b:e29f:c63f with SMTP id
 5b1f17b1804b1-47d8ac29207mr513175e9.11.1767891631095; Thu, 08 Jan 2026
 09:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20260108153548.7386-1-ankita@nvidia.com> <20260108153548.7386-3-ankita@nvidia.com>
In-Reply-To: <20260108153548.7386-3-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 8 Jan 2026 09:00:19 -0800
X-Gm-Features: AQt7F2pWPhT0eCqMnR2VcSZQSmqDj9xv_IbsaURHMRa3NGydFYcQ5GkWfgoWDic
Message-ID: <CACw3F52rHjxv8gWzz6_YdR038CiA1=JxUD6YuW4As=rQ2oMdag@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
To: ankita@nvidia.com
Cc: vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, jgg@ziepe.ca, 
	skolothumtho@nvidia.com, alex@shazbot.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, cjia@nvidia.com, zhiw@nvidia.com, kjaju@nvidia.com, 
	yishaih@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 33048C001F
X-Rspamd-Server: rspam06
X-Stat-Signature: ez8818kf6soectynb8916mik6fehj6zw
X-Rspam-User: 
X-HE-Tag: 1767891632-304791
X-HE-Meta: U2FsdGVkX1+pfpEzpI+d7dRTT2rvl2KAzTNrDrlTJ7zi4lfUD2zevUIVExesfr4q7tSSXm8RbQrJybob3r9qxbuly0ihWICx2ZbUWw5D4BuDK88UgT/5JBrg5HvoUrAzfgDwvqUS1iEQc0qhUTOvg6ESEt8WPtlKZymNgwcwbvcs8A4bmrKYolnwMZpVqtJCnzevxIpNsfQfDBdeXdii1LT9ylD3iKcOCGiYTknV1UQ10yVkjItwWQP6guh1oYP85tA3mhlwz1mHJ0By4GQCPHPAB+qMnQuc2IwrJzxkFDisEZHVSeu7NHfAWho92obd/ArFIPSZmKlyPZE4UMDa+E2NDrtyumSiXtL87P2raTkOogV3lI9nrXSnGcDTAaHEWnx0KDkthB2jiRHQx0QUlSqpQRADi6DVyuKsPmZ8+BF1xA4Y1CZVqdxdIALNdUzQbtNcUaPZKBXCmvrfvx3VSMd3RaAwC3+d8GFijLiIe+/LR8Pzr9/LmIKmgi53+w87+Ouoi4yyEQi02Vk60gzWeterTuh1KUJigKcnQgQL+b5ltGEWvMgkRuj6scLxAW3x4ms2tWZjaDkMfiWyRYicPFESvXVgJS0YIj47oNNVnPEPP4/yxDVd7CyzE/3FMk1J/6m3Xf1AZ15e23orWJjeLTmgIDszmmELvwgIldUN1qC+ZUbsC1McCcGQaZalxnJs9av3tMh4yzVa0P6gENTMuTUmJwZQfPkIGwVWOE6IGkJ6CmAEJXqOUayWiMvuindJh3+JYUgoii3ju9tDv86rJ6BN5t/C5qN3m/9hVAPvN+wd9+diClqf4x/HqNWvvwcKFpY2h7z5QRs8j451oyy9F7Y7KDKjkYkk/Bg5L9j/n11gfOxFuqahw/wCXobyO4QjmebCW/ViIpRjEmOBhRKb5vV0bxAz9a6K2GtlDxZckj8+Nu3m8hrSoVsE1kSsaRIYHe0iI2wKx6YYWlxZDdr
 Gtfe9IKQ
 4FmD/7AFQyoZnE8UzM1SE2oRtQe1kEz/ntAaz+BGV9AWJbiwhNHg432Mh9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 8, 2026 at 7:36=E2=80=AFAM <ankita@nvidia.com> wrote:
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
>  drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
>  1 file changed, 112 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-gpu/main.c
> index b45a24d00387..d3e5fee29180 100644
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
> @@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
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

Any reason not to define vma_to_nvdev() here directly, but later?

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
> +       int ret;
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
> +       ret =3D register_pfn_address_space(&region->pfn_address_space);
> +
> +       return ret;

nit: I believe "ret" is unnecessary here.


> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>         struct vfio_pci_core_device *vdev =3D
> @@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_devi=
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
> @@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_dev=
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
> @@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu=
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

