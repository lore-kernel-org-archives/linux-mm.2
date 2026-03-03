Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26576E67A95
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5936B0093; Tue,  3 Mar 2026 03:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5532F6B0095; Tue,  3 Mar 2026 03:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452456B0096; Tue,  3 Mar 2026 03:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31AAC6B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:30:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CED448B5B4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:30:17 +0000 (UTC)
X-FDA: 84504079674.20.C06C989
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 56B021C0008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:30:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JW8JpHeF;
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772526615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viUy7hzMU4+O4xdoDCnRaeiIoPG6PXt0vSgDJ4O3NVU=;
	b=f9WZNTUSNbIGCqKjBDgX/JgeV3jzpbSoQpzhKYtBYbjZgU6g0jzazs2F6NqnhR9eyZdmMH
	LK33SDHye0oyL1fRhxm6E8CxP7tPKAXKb6DqHg28S++8hMzTisVFx07PrqFS7zuV4n24Ei
	R0NiwlrD2wifiExEicP6S1Vlf2iLDRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772526615; a=rsa-sha256;
	cv=none;
	b=bBwYekp2WfOVaYrHyQI6WIGh3Fg1g4WwKPANf+3ByJ0Lxgf8+yzWd/T69fRlSmImWGdeA9
	s40CZ55IrxwzV2wiK6oSUfvzPQ+vj4vQA+Ir3OUbbY2UW/uS0pc+W/O1Hd6tnyy6jxFiWm
	I227V7uBrZ4eC9V7v469EQlL5NmmIfE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JW8JpHeF;
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772526614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=viUy7hzMU4+O4xdoDCnRaeiIoPG6PXt0vSgDJ4O3NVU=;
	b=JW8JpHeFJN1ImXt4APtdRJNU19DGK2bLkcsh2wCroz3ig0WDPAO5HLnKWOx/qlpwQxlpKF
	egm/JytVMdYWQ0znez7PE8anIe8zLgPssJipQam6B0jvk9S0q+J736CL+PIVGeJckiYVvN
	9TQPg+yI9Ss2X/jsCveuCXWK5/ZKiE0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-77Z9Eu1QM2SkEMrzQKVIBw-1; Tue, 03 Mar 2026 03:30:13 -0500
X-MC-Unique: 77Z9Eu1QM2SkEMrzQKVIBw-1
X-Mimecast-MFC-AGG-ID: 77Z9Eu1QM2SkEMrzQKVIBw_1772526613
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-79885818011so68980077b3.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526613; x=1773131413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=viUy7hzMU4+O4xdoDCnRaeiIoPG6PXt0vSgDJ4O3NVU=;
        b=uPob/gQ6YJFHi8wt7pkYXvQnyV23hmxn6wZgKDuSXA8jGtY35F5Bs0mGIyu4TcKcL1
         qfYWPeW1sFeu8hZwGnQplNBpkWz0MYLrZOx6eBIsQMdoRAtb73HgN+k5UiPLjV0p/PYZ
         298TnC+bzNowWkEnbB4Jn3n8BlDj4k9dW1EYHxZC38pdBfmSUbuWeknlEAOO7odNnVZl
         L75g97lh/14g1/Jeg/02noyV8E3cKMsEVd8uixP+Kd4FFYFJ6TxYpqFXkZpBcTD2PCi/
         uHqGmBMMKXwWmTU0P/zzfphBifNCnJoxyBq8P2qv7VAU6KqbS8f5ARgJjPGMFadwKEoS
         HNqg==
X-Forwarded-Encrypted: i=1; AJvYcCWldXHd+qirFDYFwcb7SpRh29OvvyZ0Wqq0VnItn3IFJ28cH7ptNkhT8voPSRLNAGFYjnLHM7w6hw==@kvack.org
X-Gm-Message-State: AOJu0YxQvomkSRGu7b3oZmeKt8RIRzDMgHbujxj/O5hsMDylrOVXrrQ7
	CySGOa/97Q66XOD33sLGyZDb/Iq6xgfgXhp3SpWfxogrT1wEpl5rg0S2iU+1FJw+wJmPogwXC35
	azvcmqDdO94IjpCxdq4upyTWAgofzRsuV1Ui0amPT46RiYYCqwkQrn/CXtXOkjYJaezduPi5dnq
	jvuKzRGujAMEWYdqigS6d9fWXsPhA=
X-Gm-Gg: ATEYQzzW53zfr+a6OnIePygyBw9FdzJcu8Yorei6GVD7L3zSjQ8WzetdWwAhqRWRfOx
	fOZhM8U6pbF/zZXHd4aqholcVjkn4jy1SR/kCQSvx4nofo5pMiJk813lgJCkBZ+U2Q79/JuqZmC
	SdTV6HELapTb3BC38pih1TkbFpyLzVrBwXjKkhn7UNFTaLiEtj6yk89Fhs7XOPYUEbLSw/8XN1O
	g==
X-Received: by 2002:a05:690e:2026:b0:64c:e819:1b63 with SMTP id 956f58d0204a3-64ce8191c0fmr2298992d50.23.1772526612874;
        Tue, 03 Mar 2026 00:30:12 -0800 (PST)
X-Received: by 2002:a05:690e:2026:b0:64c:e819:1b63 with SMTP id
 956f58d0204a3-64ce8191c0fmr2298965d50.23.1772526612385; Tue, 03 Mar 2026
 00:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org> <20260227-dma-buf-heaps-as-modules-v2-1-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-1-454aee7e06cc@kernel.org>
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 3 Mar 2026 09:30:01 +0100
X-Gm-Features: AaiRm51O-7HLXl5WqAQFt8ndmggiU93wYFS2Jxqx5wmhO0yrhCBFx8LCXAa_vkY
Message-ID: <CADSE00KTKhzuB1vDj=hkBVE+5dq+=q3xRsj6dK_96Jhqi49OwQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] dma: contiguous: Turn heap registration logic around
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XY12xs1QBObsOEQe4tDgWiHpEct62VQToifgCZfEPWU_1772526613
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ee3pgpgx43id8bsridprr98ig641f38m
X-Rspam-User: 
X-Rspamd-Queue-Id: 56B021C0008
X-Rspamd-Server: rspam12
X-HE-Tag: 1772526615-619901
X-HE-Meta: U2FsdGVkX18U469Bc0jDuHCIYlg5n8KHaO8vtu4XB/so5M74thxdRX1tDUonY9jCqEAjlsU7ercTfjI54MBUhr86CnELjNt5Eju1n5B3hGGLwtMzQSHqfXXVDdACdMkx+c6d1p+tVBBwXUK9qY8lUKd77flbY2mJ4QU3JF/V3qYoWJoyh4pzcU0b9BMknaPmHzWFiQ1xZBj/10mxKWUD1Hxi1gVbRaMxz60iYJFrlBJOIwUWA4J1GjHaMKWH4gK8i+ot9a/leCePnOVmYC1UCWugDDnYV7X4J99otaXtgepzxOaB7YOvl/mU2IpLuZCb9JEBFVpgcFe5odSPk3TdrM5TrkCmT5dxnCz1YiayeifVhQqStZhBzh713G8TO/jlStuP/VztCLPp/BMK5W5SlapVvdCNP03mPsbVk5cDeRhyIWprcqhIGustZ7T++kDZPnn/0HAalLGBesvvKf5VAvGjQ2E2Jas6kIo3XlWECfrocuqC5hlV7L61leZdt2tXHPPSBj2Mo4wUq+sSQf5hLE2D3ljTWCe8ummhxi/vb+KTZUHYZ+5x1/fRQLz/sZgZfyVaVITpz738NwOIcib0AG1j4Vfb26XgG40Ht4AG52qTJgD77CZEkRSCFKza4pqWZAIs29+pSfewrB0JmmI7QBe67o9zNG+YFGjWBqzHWt0KL/nqBAnIuwojT1jmcYt8cdou78q35Q2Dep9OrIOM4Qx+NR+bkDvzIPRv/qGuOQzou9kIQiyrppqQgnzTQL5u2WltJrzEhS8Rezijl+wZMKjuuSfe5xJSBzEJgDDOS4bWkt77aLkiM/MYSLu70by+DNiuH9pm6lMR8qyiJ9O3wAHxeLNykuRkbnNlSZJvbjpKRAOE0LUNTmfv5ke6IxJu076w0gP+01eH4jl5ZfvLXfhYhIJqhlod48Mmw0PqNn0Gsl3fbxy+b5pGPzJH24rsvp8Wtfnneq9g3Bc1pCL
 PTmRp3X4
 XPPKrc2sEQ9c1DkSs+EjpkrQ+3EppcQiucR+629MWk7G97/wDfB3Mqy7Fk0fEutozheFK3LB95Y9vzmJgjKa0yUj5VLRsRsDdHcqpH0LWK/DpXtAW2YwXCf14GZmOFIr78hV2s/1zgLZDfQgOXmzQqwGlw5XIam9RwPteMcZ4RatfeMSI83n+I/hTryVFiud4yE57/Mh6g+hp+8NQ6og3XZ15NopMeqjEVvDQMqdmFwbINasnWGtmcoQPw926bsNnpTvVbRLAZAjrDF3A1yo3KwSIQ50ouWQLWPDhlDbV7GyvkCkgDbh1hFyBFzggLsRnyaZmmaUIRVpt5srsLHgxQwmcAZOdLr07Qw55oYA2ytnkDP9OIskdFPQWmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 2:23=E2=80=AFPM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The CMA heap instantiation was initially developed by having the
> contiguous DMA code call into the CMA heap to create a new instance
> every time a reserved memory area is probed.
>
> Turning the CMA heap into a module would create a dependency of the
> kernel on a module, which doesn't work.
>
> Let's turn the logic around and do the opposite: store all the reserved
> memory CMA regions into the contiguous DMA code, and provide an iterator
> for the heap to use when it probes.
>
> Reviewed-by: T.J. Mercier <tjmercier@google.com>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: Albert Esteve <aesteve@redhat.com>

> ---
>  drivers/dma-buf/heaps/cma_heap.c | 18 ++----------------
>  include/linux/dma-map-ops.h      |  5 +++++
>  kernel/dma/contiguous.c          | 26 ++++++++++++++++++++++++--
>  3 files changed, 31 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma=
_heap.c
> index bd3370b9a3f6d4e18885a1d0e8ba3f659b85ef47..f8a3d87f3ccee9630383ba285=
02eb40b10671cc2 100644
> --- a/drivers/dma-buf/heaps/cma_heap.c
> +++ b/drivers/dma-buf/heaps/cma_heap.c
> @@ -28,23 +28,10 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>
>  #define DEFAULT_CMA_NAME "default_cma_region"
>
> -static struct cma *dma_areas[MAX_CMA_AREAS] __initdata;
> -static unsigned int dma_areas_num __initdata;
> -
> -int __init dma_heap_cma_register_heap(struct cma *cma)
> -{
> -       if (dma_areas_num >=3D ARRAY_SIZE(dma_areas))
> -               return -EINVAL;
> -
> -       dma_areas[dma_areas_num++] =3D cma;
> -
> -       return 0;
> -}
> -
>  struct cma_heap {
>         struct dma_heap *heap;
>         struct cma *cma;
>  };
>
> @@ -412,22 +399,21 @@ static int __init __add_cma_heap(struct cma *cma, c=
onst char *name)
>  }
>
>  static int __init add_cma_heaps(void)
>  {
>         struct cma *default_cma =3D dev_get_cma_area(NULL);
> +       struct cma *cma;
>         unsigned int i;
>         int ret;
>
>         if (default_cma) {
>                 ret =3D __add_cma_heap(default_cma, DEFAULT_CMA_NAME);
>                 if (ret)
>                         return ret;
>         }
>
> -       for (i =3D 0; i < dma_areas_num; i++) {
> -               struct cma *cma =3D dma_areas[i];
> -
> +       for (i =3D 0; (cma =3D dma_contiguous_get_reserved_region(i)) !=
=3D NULL; i++) {
>                 ret =3D __add_cma_heap(cma, cma_get_name(cma));
>                 if (ret) {
>                         pr_warn("Failed to add CMA heap %s", cma_get_name=
(cma));
>                         continue;
>                 }
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 60b63756df821d839436618f1fca2bfa3eabe075..3007c68a8ec5b85990d1938d0=
4a2f05c1a71acdb 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -110,10 +110,11 @@ bool dma_release_from_contiguous(struct device *dev=
, struct page *pages,
>                                  int count);
>  struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t=
 gfp);
>  void dma_free_contiguous(struct device *dev, struct page *page, size_t s=
ize);
>
>  void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
> +struct cma *dma_contiguous_get_reserved_region(unsigned int idx);
>  #else /* CONFIG_DMA_CMA */
>  static inline struct cma *dev_get_cma_area(struct device *dev)
>  {
>         return NULL;
>  }
> @@ -148,10 +149,14 @@ static inline void dma_free_contiguous(struct devic=
e *dev, struct page *page,
>         __free_pages(page, get_order(size));
>  }
>  static inline void dma_contiguous_early_fixup(phys_addr_t base, unsigned=
 long size)
>  {
>  }
> +static inline struct cma *dma_contiguous_get_reserved_region(unsigned in=
t idx)
> +{
> +       return NULL;
> +}
>  #endif /* CONFIG_DMA_CMA*/
>
>  #ifdef CONFIG_DMA_DECLARE_COHERENT
>  int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_add=
r,
>                 dma_addr_t device_addr, size_t size);
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index c56004d314dc2e436cddf3b20a4ee6ce8178bee4..14bd54fb758537f01a6fe2731=
8e7b683964e20b1 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -456,10 +456,32 @@ void dma_free_contiguous(struct device *dev, struct=
 page *page, size_t size)
>  #include <linux/of_reserved_mem.h>
>
>  #undef pr_fmt
>  #define pr_fmt(fmt) fmt
>
> +static struct cma *rmem_cma_areas[MAX_CMA_AREAS];
> +static unsigned int rmem_cma_areas_num;
> +
> +static int rmem_cma_insert_area(struct cma *cma)
> +{
> +       if (rmem_cma_areas_num >=3D ARRAY_SIZE(rmem_cma_areas))
> +               return -EINVAL;
> +
> +       rmem_cma_areas[rmem_cma_areas_num++] =3D cma;
> +
> +       return 0;
> +}
> +
> +struct cma *dma_contiguous_get_reserved_region(unsigned int idx)
> +{
> +       if (idx >=3D rmem_cma_areas_num)
> +               return NULL;
> +
> +       return rmem_cma_areas[idx];
> +}
> +EXPORT_SYMBOL_GPL(dma_contiguous_get_reserved_region);
> +
>  static int rmem_cma_device_init(struct reserved_mem *rmem, struct device=
 *dev)
>  {
>         dev->cma_area =3D rmem->priv;
>         return 0;
>  }
> @@ -504,13 +526,13 @@ static int __init rmem_cma_setup(struct reserved_me=
m *rmem)
>         rmem->priv =3D cma;
>
>         pr_info("Reserved memory: created CMA memory pool at %pa, size %l=
d MiB\n",
>                 &rmem->base, (unsigned long)rmem->size / SZ_1M);
>
> -       err =3D dma_heap_cma_register_heap(cma);
> +       err =3D rmem_cma_insert_area(cma);
>         if (err)
> -               pr_warn("Couldn't register CMA heap.");
> +               pr_warn("Couldn't store CMA reserved area.");
>
>         return 0;
>  }
>  RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
>  #endif
>
> --
> 2.53.0
>
>


