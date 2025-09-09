Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE37CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA8B8E001B; Tue,  9 Sep 2025 12:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69938E0001; Tue,  9 Sep 2025 12:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E43A8E001B; Tue,  9 Sep 2025 12:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8117E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:45:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CF5486D44
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:45:15 +0000 (UTC)
X-FDA: 83870286990.11.0CA6840
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D4B040003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:45:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEknx3Ak;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757436313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg66ytqT5gW0pLgpcFNtD+RmpG9kakagwaMvlSmeZ+A=;
	b=i6rEKNbVlHj0BzqHGfNova+vaX9x2BTMUKmC333hYnYXWU31LWnnjVdZnVv/siJWVeELJu
	K4TXXJORJBMhvDGpZs/MFSxHH7AIjVhe6pLPtOC2+LmJL7XZOIK+tMa2BviBZi9PNIsiIA
	MSpqLik3AnN6oLPnNcLvIBXp3NRow4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEknx3Ak;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757436313; a=rsa-sha256;
	cv=none;
	b=KpWDIunGzD7GMIohl5SVWRulGb+yTwQQufMFhyvgKQKme+hAZmg8yRRVbE+7hBmU+mUSn9
	SQtfgBkaZ+TlA+HdHZ74zohOkxLEqANrzsF9pAq6s2MmOSiQYZKIA5JjdE9Yobo1nPx8ln
	lDZ8ogOk08joQrlcHzSvwKpKGoSBrHg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so86a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757436312; x=1758041112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wg66ytqT5gW0pLgpcFNtD+RmpG9kakagwaMvlSmeZ+A=;
        b=yEknx3AkNmfigX+0XgPH7rcaJSJqssyXUxtYKNewLHcw1/ULDfoIEZUvKnJEdpMfq7
         Cu7Eu8V55Vb5tB6omHTIafqF5b0PbQLT5WAcd5uRBvoqr3BnGYo53RJr6UvFB+SUfIYp
         D+zIkOI7hfQeFGbe96mIAbRwVbsCpoEXHlD+D1+hL9e9BNFOuH9RZNuUxH36vYVs3nU/
         VkQ9zsk6+mpKxIcsiDsY5YMSqYnLqmfiz3DBiffoI7wOVeKgVg0aUDd2sCs8eMmqvb1x
         zC4vlp1cwIDG25J30gJinTDRYuycXVBhyZxY39P6tAcQbuunr92DXqmtE/r8Ta0/pqqn
         dqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757436312; x=1758041112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wg66ytqT5gW0pLgpcFNtD+RmpG9kakagwaMvlSmeZ+A=;
        b=as5XPjhgwm/snY+CWttmmAfflGLTI/VSi+z7VZ28y+Z7BvSapDE3NxvqVZhZKI8zw9
         hBv+X34demymgVJuCFfcUb4fW9f0cqGSr8SiB+eqoe007y2qBULRCqt/sEZA6co7YEzR
         XHJVl/hHlWqhsTWPSJ9TyzhLx38CDOkt80eLFMDg/USVk9Uv16P/Gn3Shq6J18+/wc8P
         BoC+rldpjoWeBIqnk5vuPvtxwPigBuvGP7pIY232bkX2mLgcjw4L6cTJg3eXx2eaFcRZ
         lrOBHZ8MVK8OS0YpX0jV3Q0Oq8lTAsmX5lM57goqKE7mHBqwmHkBqZg5zSfebBK4/o9H
         p8Hw==
X-Forwarded-Encrypted: i=1; AJvYcCU6IdZ8JWB68j5O8Q+9pCZTYC+X4DZLP1sOGe+2TRlqBaZqno93Ejg7vidQXx7n2A/AIL/qWMmVbA==@kvack.org
X-Gm-Message-State: AOJu0YzfuQHz353JGsu1MW2pgvPKZZ7yDXsHtVWjLDZxrGFrfcy9JDj5
	dm4jBqjLmSUe4TG04Rbgp0JZWctkfibyf2EKFErqZpxpNv2ErZxxtWyHrz028uMo/o0uMIuK4LV
	t0X2J35+v2eP7pg3L/O5isq0mq/BJqF9gfRkAHIF6
X-Gm-Gg: ASbGncs4peqnZ/qgvfcn5w4ILKIZ2oxlZlKBTiYp/JjQhhkfE2Ll4RLjZu70aAu6/g/
	dQRhm/KRPU2T2UedrnmCKc8s7LqqmYTmAGdYt0yUDCJYhpjppSa1FQywaL7AqFjwQ02OqSozV8B
	g/QLEyK8lixExvmjyd1acv0Mkmec1zpAmhxqoBCzGdpPcQvxXSWc3awnNV5eLsL3WaA/vgLswBe
	WM92+7w9jgV3wo3fOLfrUCLiw9M6ANqP+1ls9GqpopA1B4D7PSM30c=
X-Google-Smtp-Source: AGHT+IGPGk0qf/IiaeJSTR25Y6zNMAmob9Bf6pRZiB8Cz91tPx5tFvdw6FMK8xHuP6h0JHF887G6sd0LUCfFyNW1CIU=
X-Received: by 2002:a05:6402:d60:b0:61c:d36d:218c with SMTP id
 4fb4d7f45d1cf-6234d3ee779mr242645a12.0.1757436311257; Tue, 09 Sep 2025
 09:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com> <ea1a5ab9fff7330b69f0b97c123ec95308818c98.1757329751.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <ea1a5ab9fff7330b69f0b97c123ec95308818c98.1757329751.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:44:58 -0700
X-Gm-Features: AS18NWD_8AWrPfmI0tsMVHUiuAGzDjgerBQcQZeWasEIUA51d1DPsE14BgjCaGA
Message-ID: <CAJuCfpFr+vMowHzAs7QDwMmNvS4RMJg0xqXkYAxBLCKh1wdAmQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] mm: introduce the f_op->mmap_complete, mmap_abort hooks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-mm@kvack.org, ntfs3@lists.linux.dev, kexec@lists.infradead.org, 
	kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1D4B040003
X-Stat-Signature: q57mdguxx1jjqxxzwrzn8shdnn1oczp3
X-HE-Tag: 1757436312-161559
X-HE-Meta: U2FsdGVkX1+D2RbCOgjb5t2RR9HphcSEQTKzx3YttmRZpv5bnLIOfUmy7Nq4Ro7rhp4k0JY6I5vG86Bi5Lb6bX1U85l3X2QD93z9CX2yz5BajT8Hw8xlpsA9FY4T3b6RMUs1Bwqv0nZL9hSdi8Jw4598ZwKRON+KBqKlaBTugvn6N10VYdU9sRBefyTYytcA92S1FWQEQrrvs2QdCXrOicFqeTjC3tqweA/kS0GQ/o+cLbio1+WLw0kbfkYxL1djSQr40tFoTme1CP9dTOEVBDpi6Tr8uT3ve85/iZET9jk2sri2KPdAfgxJjAFa2RgNXn/fdqiUax9j0ZpaPx/W2mnsX5zgSVLS5PxK97vQGmDpZEg2tA6jHyNpSKv1PZb9Y5alMzLmGDUf76idy7CNOFZtkimhGRdh6I4L3WwqXfy+4b7+gOyTqWq7yGe6BT6YkzOnV1VF7SXrrRL/7deWq8lxfiI/ks8GE+8+qr9Kd+f8WKjp2/RcWZzYOhY+YX4kbWycnX9JYS0prS4ifVDzSGvk/n6gtzGPGpmf/NWcOm2svHIYsqms80ubz/ZDedKyXRDZ8uQv+ARnt1iYjXVRM0fV4B9p5Q8wH8s5FYOk3itO0mUYt7IkqUqDXTJ+mvHI+xGhRTUyLJgJImtQxM9VdeZH5r2ctflrBsEDLYyKpX3K4BszxIIK+SumVk5nuA4b+0yNZZyHcYF6ZuTHFQy/YiYNxT9ff8ZePo/GBbgdWYeNzG+jpXN2C/hV0v8xxoePUjiNwZ32v1mWvBdH1lF8snMSHiX1aqRQ86XcWSrGDs9Xskj6ru5oCXbcJgH4/JO+aAsexrXxJDXlN+YWsFB9KkbFkwY6l3LIPeGeDWGHVwLdVNW7oW940wVdRCQ/qx8vtQgYGFf0H8P3WwY1WocnmPfLdjgZMFr92snWRF3mZ5V2d5WDQfJlXmPy9LXUoOE70auhQQFfqaOxlK+Eo34
 j+o2yEVX
 8BDxZA+X3/kUuWwyZ7ptXKqPQerHhC3wPlCORa6SXIfbv5xTfafphyPI7i15LXmymamZj66jYgdBZcHz9V8c3UPDONZYrozearfhNuOcXktoU7YdcaRC1BrHS/BBbtUnr7tZc88wCtEghaMkeOxRjjxHJKa6D/pLE5OnEfUBIKF3Jpp+C0bJkje4jK9hPWGIAKZkoEyppj5Vq1xtQgm1RLs+TAN/x460dYO6hRJVU8LSww1Gy2kkJuiI//N2yrsijnDVEmMnJvaX3GPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 4:11=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> We have introduced the f_op->mmap_prepare hook to allow for setting up a
> VMA far earlier in the process of mapping memory, reducing problematic
> error handling paths, but this does not provide what all
> drivers/filesystems need.
>
> In order to supply this, and to be able to move forward with removing
> f_op->mmap altogether, introduce f_op->mmap_complete.
>
> This hook is called once the VMA is fully mapped and everything is done,
> however with the mmap write lock and VMA write locks held.
>
> The hook is then provided with a fully initialised VMA which it can do wh=
at
> it needs with, though the mmap and VMA write locks must remain held
> throughout.
>
> It is not intended that the VMA be modified at this point, attempts to do
> so will end in tears.
>
> This allows for operations such as pre-population typically via a remap, =
or
> really anything that requires access to the VMA once initialised.
>
> In addition, a caller may need to take a lock in mmap_prepare, when it is
> possible to modify the VMA, and release it on mmap_complete. In order to
> handle errors which may arise between the two operations, f_op->mmap_abor=
t
> is provided.
>
> This hook should be used to drop any lock and clean up anything before th=
e
> VMA mapping operation is aborted. After this point the VMA will not be
> added to any mapping and will not exist.
>
> We also add a new mmap_context field to the vm_area_desc type which can b=
e
> used to pass information pertinent to any locks which are held or any sta=
te
> which is required for mmap_complete, abort to operate correctly.
>
> We also update the compatibility layer for nested filesystems which
> currently still only specify an f_op->mmap() handler so that it correctly
> invokes f_op->mmap_complete as necessary (note that no error can occur
> between mmap_prepare and mmap_complete so mmap_abort will never be called
> in this case).
>
> Also update the VMA tests to account for the changes.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/fs.h               |  4 ++
>  include/linux/mm_types.h         |  5 ++
>  mm/util.c                        | 18 +++++--
>  mm/vma.c                         | 82 ++++++++++++++++++++++++++++++--
>  tools/testing/vma/vma_internal.h | 31 ++++++++++--
>  5 files changed, 129 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 594bd4d0521e..bb432924993a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2195,6 +2195,10 @@ struct file_operations {
>         int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_bat=
ch *,
>                                 unsigned int poll_flags);
>         int (*mmap_prepare)(struct vm_area_desc *);
> +       int (*mmap_complete)(struct file *, struct vm_area_struct *,
> +                            const void *context);
> +       void (*mmap_abort)(const struct file *, const void *vm_private_da=
ta,
> +                          const void *context);
>  } __randomize_layout;
>
>  /* Supports async buffered reads */
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index cf759fe08bb3..052db1f31fb3 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -793,6 +793,11 @@ struct vm_area_desc {
>         /* Write-only fields. */
>         const struct vm_operations_struct *vm_ops;
>         void *private_data;
> +       /*
> +        * A user-defined field, value will be passed to mmap_complete,
> +        * mmap_abort.
> +        */
> +       void *mmap_context;
>  };
>
>  /*
> diff --git a/mm/util.c b/mm/util.c
> index 248f877f629b..f5bcac140cb9 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1161,17 +1161,26 @@ int __compat_vma_mmap_prepare(const struct file_o=
perations *f_op,
>         err =3D f_op->mmap_prepare(&desc);
>         if (err)
>                 return err;
> +
>         set_vma_from_desc(vma, &desc);
>
> -       return 0;
> +       /*
> +        * No error can occur between mmap_prepare() and mmap_complete so=
 no
> +        * need to invoke mmap_abort().
> +        */
> +
> +       if (f_op->mmap_complete)
> +               err =3D f_op->mmap_complete(file, vma, desc.mmap_context)=
;
> +
> +       return err;
>  }
>  EXPORT_SYMBOL(__compat_vma_mmap_prepare);
>
>  /**
>   * compat_vma_mmap_prepare() - Apply the file's .mmap_prepare() hook to =
an
> - * existing VMA.
> + * existing VMA and invoke .mmap_complete() if provided.
>   * @file: The file which possesss an f_op->mmap_prepare() hook.

nit: possesss seems to be misspelled. Maybe we can fix it here as well?

> - * @vma: The VMA to apply the .mmap_prepare() hook to.
> + * @vma: The VMA to apply the hooks to.
>   *
>   * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However,=
 certain
>   * stacked filesystems invoke a nested mmap hook of an underlying file.
> @@ -1188,6 +1197,9 @@ EXPORT_SYMBOL(__compat_vma_mmap_prepare);
>   * establishes a struct vm_area_desc descriptor, passes to the underlyin=
g
>   * .mmap_prepare() hook and applies any changes performed by it.
>   *
> + * If the relevant hooks are provided, it also invokes .mmap_complete() =
upon
> + * successful completion.
> + *
>   * Once the conversion of filesystems is complete this function will no =
longer
>   * be required and will be removed.
>   *
> diff --git a/mm/vma.c b/mm/vma.c
> index 0efa4288570e..a0b568fe9e8d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -22,6 +22,7 @@ struct mmap_state {
>         /* User-defined fields, perhaps updated by .mmap_prepare(). */
>         const struct vm_operations_struct *vm_ops;
>         void *vm_private_data;
> +       void *mmap_context;
>
>         unsigned long charged;
>
> @@ -2343,6 +2344,23 @@ static int __mmap_prelude(struct mmap_state *map, =
struct list_head *uf)
>         int error;
>         struct vma_iterator *vmi =3D map->vmi;
>         struct vma_munmap_struct *vms =3D &map->vms;
> +       struct file *file =3D map->file;
> +
> +       if (file) {
> +               /* f_op->mmap_complete requires f_op->mmap_prepare. */
> +               if (file->f_op->mmap_complete && !file->f_op->mmap_prepar=
e)
> +                       return -EINVAL;
> +
> +               /*
> +                * It's not valid to provide an f_op->mmap_abort hook wit=
hout also
> +                * providing the f_op->mmap_prepare and f_op->mmap_comple=
te hooks it is
> +                * used with.
> +                */
> +               if (file->f_op->mmap_abort &&
> +                    (!file->f_op->mmap_prepare ||
> +                     !file->f_op->mmap_complete))
> +                       return -EINVAL;
> +       }
>
>         /* Find the first overlapping VMA and initialise unmap state. */
>         vms->vma =3D vma_find(vmi, map->end);
> @@ -2595,6 +2613,7 @@ static int call_mmap_prepare(struct mmap_state *map=
)
>         /* User-defined fields. */
>         map->vm_ops =3D desc.vm_ops;
>         map->vm_private_data =3D desc.private_data;
> +       map->mmap_context =3D desc.mmap_context;
>
>         return 0;
>  }
> @@ -2636,16 +2655,61 @@ static bool can_set_ksm_flags_early(struct mmap_s=
tate *map)
>         return false;
>  }
>
> +/*
> + * Invoke the f_op->mmap_complete hook, providing it with a fully initia=
lised
> + * VMA to operate upon.
> + *
> + * The mmap and VMA write locks must be held prior to and after the hook=
 has
> + * been invoked.
> + */
> +static int call_mmap_complete(struct mmap_state *map, struct vm_area_str=
uct *vma)
> +{
> +       struct file *file =3D map->file;
> +       void *context =3D map->mmap_context;
> +       int error;
> +       size_t len;
> +
> +       if (!file || !file->f_op->mmap_complete)
> +               return 0;
> +
> +       error =3D file->f_op->mmap_complete(file, vma, context);
> +       /* The hook must NOT drop the write locks. */
> +       vma_assert_write_locked(vma);
> +       mmap_assert_write_locked(current->mm);
> +       if (!error)
> +               return 0;
> +
> +       /*
> +        * If an error occurs, unmap the VMA altogether and return an err=
or. We
> +        * only clear the newly allocated VMA, since this function is onl=
y
> +        * invoked if we do NOT merge, so we only clean up the VMA we cre=
ated.
> +        */
> +       len =3D vma_pages(vma) << PAGE_SHIFT;
> +       do_munmap(current->mm, vma->vm_start, len, NULL);
> +       return error;
> +}
> +
> +static void call_mmap_abort(struct mmap_state *map)
> +{
> +       struct file *file =3D map->file;
> +       void *vm_private_data =3D map->vm_private_data;
> +
> +       VM_WARN_ON_ONCE(!file || !file->f_op);
> +       file->f_op->mmap_abort(file, vm_private_data, map->mmap_context);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr=
,
>                 unsigned long len, vm_flags_t vm_flags, unsigned long pgo=
ff,
>                 struct list_head *uf)
>  {
> -       struct mm_struct *mm =3D current->mm;
> -       struct vm_area_struct *vma =3D NULL;
> -       int error;
>         bool have_mmap_prepare =3D file && file->f_op->mmap_prepare;
> +       bool have_mmap_abort =3D file && file->f_op->mmap_abort;
> +       struct mm_struct *mm =3D current->mm;
>         VMA_ITERATOR(vmi, mm, addr);
>         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vm_flags, file);
> +       struct vm_area_struct *vma =3D NULL;
> +       bool allocated_new =3D false;
> +       int error;
>
>         map.check_ksm_early =3D can_set_ksm_flags_early(&map);
>
> @@ -2668,8 +2732,12 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>         /* ...but if we can't, allocate a new VMA. */
>         if (!vma) {
>                 error =3D __mmap_new_vma(&map, &vma);
> -               if (error)
> +               if (error) {
> +                       if (have_mmap_abort)
> +                               call_mmap_abort(&map);
>                         goto unacct_error;
> +               }
> +               allocated_new =3D true;
>         }
>
>         if (have_mmap_prepare)
> @@ -2677,6 +2745,12 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>
>         __mmap_epilogue(&map, vma);
>
> +       if (allocated_new) {
> +               error =3D call_mmap_complete(&map, vma);
> +               if (error)
> +                       return error;
> +       }
> +
>         return addr;
>
>         /* Accounting was done by __mmap_prelude(). */
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 07167446dcf4..566cef1c0e0b 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -297,11 +297,20 @@ struct vm_area_desc {
>         /* Write-only fields. */
>         const struct vm_operations_struct *vm_ops;
>         void *private_data;
> +       /*
> +        * A user-defined field, value will be passed to mmap_complete,
> +        * mmap_abort.
> +        */
> +       void *mmap_context;
>  };
>
>  struct file_operations {
>         int (*mmap)(struct file *, struct vm_area_struct *);
>         int (*mmap_prepare)(struct vm_area_desc *);
> +       void (*mmap_abort)(const struct file *, const void *vm_private_da=
ta,
> +                          const void *context);
> +       int (*mmap_complete)(struct file *, struct vm_area_struct *,
> +                            const void *context);
>  };
>
>  struct file {
> @@ -1471,7 +1480,7 @@ static inline int __compat_vma_mmap_prepare(const s=
truct file_operations *f_op,
>  {
>         struct vm_area_desc desc =3D {
>                 .mm =3D vma->vm_mm,
> -               .file =3D vma->vm_file,
> +               .file =3D file,
>                 .start =3D vma->vm_start,
>                 .end =3D vma->vm_end,
>
> @@ -1485,13 +1494,21 @@ static inline int __compat_vma_mmap_prepare(const=
 struct file_operations *f_op,
>         err =3D f_op->mmap_prepare(&desc);
>         if (err)
>                 return err;
> +
>         set_vma_from_desc(vma, &desc);
>
> -       return 0;
> +       /*
> +        * No error can occur between mmap_prepare() and mmap_complete so=
 no
> +        * need to invoke mmap_abort().
> +        */
> +
> +       if (f_op->mmap_complete)
> +               err =3D f_op->mmap_complete(file, vma, desc.mmap_context)=
;
> +
> +       return err;
>  }
>
> -static inline int compat_vma_mmap_prepare(struct file *file,
> -               struct vm_area_struct *vma)
> +static inline int compat_vma_mmap_prepare(struct file *file, struct vm_a=
rea_struct *vma)
>  {
>         return __compat_vma_mmap_prepare(file->f_op, file, vma);
>  }
> @@ -1548,4 +1565,10 @@ static inline vm_flags_t ksm_vma_flags(const struc=
t mm_struct *, const struct fi
>         return vm_flags;
>  }
>
> +static inline int do_munmap(struct mm_struct *mm, unsigned long start, s=
ize_t len,
> +             struct list_head *uf)
> +{
> +       return 0;
> +}
> +
>  #endif /* __MM_VMA_INTERNAL_H */
> --
> 2.51.0
>

