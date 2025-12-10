Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BB0D3C90B
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 14:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6DC6B0006; Wed, 10 Dec 2025 09:07:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E3C6B0007; Wed, 10 Dec 2025 09:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95436B0008; Wed, 10 Dec 2025 09:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99BFE6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:07:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 123ED134C4D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:07:56 +0000 (UTC)
X-FDA: 84203740152.07.0F36767
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 341F8A001A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:07:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iw0wItrX;
	spf=pass (imf25.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765375674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isY3pC3KfoTie795hDxX78zLawOW/LPbyXDtjOeHtnI=;
	b=WWmKMluCURORPix/fE4P9Km96cTr5yUzMC1PPFp12muo2Vq+AWsci05Vtj1Gqv4Q1+6v8k
	GujdzrHRiXAjgz4UW01w2rWgAP31cvNJ4NCXyOpO2IzjmpDhwpuJfLaUJy1peknFEcaBkt
	TlWEzQe7cirSRecC/pm02C/4K2Wc/Eo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iw0wItrX;
	spf=pass (imf25.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765375674; a=rsa-sha256;
	cv=none;
	b=whsepDqckb84oeptlqWnwVsfwcoz0MPDY6Z8rHzBkPqH98UzCFFZKtN7jcGC4kT/jU38qb
	HaUlZZOezFnrIerPIpE5oPeUUld+wZhmg3gZOeoW418qK8BacPKl4TtsCMeK8o7IlHrJBw
	z1EPSuuq7FnG7R0ROdlRabCgyHee/Yc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FBDB6017B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECBBC2BC9E
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765375673;
	bh=yQrmP/ddz2UFF9U8IaDxmVhZCjQWvJ69Icm4YAnbV68=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iw0wItrX7C0nJcgcSkuC2hPfsGcyLB+ObuJw3KhWylu8TCWzr0Uuw9lpypfQciGLA
	 OEmua7XZnAhspzkOU5AP33CxzmlqcwrVgiFVI0WPjaiz5wa2u9fk2gmUheeNwPM65I
	 dFIeto2jezE70L2ILAcodRANSBBGWCyrJZKTIv3KRqALGll0ddmfJM4+qMDS5599XQ
	 k0L3dfKTTlug2JWo4bnomNFy437u8W8ITiwUqGHwagayHzCgHoOTsjbqXET6lhvLQT
	 7t4VM9GuAO7OMMdJZdZGdEYm4pD8D4013NyVCCFCWk7gB9RCc9otpX4s1owPB02CZX
	 lvae0ygL90EBQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so8925989a12.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 06:07:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUtt7jQGhnAlq75xYBTreC3cXwFw7QFhDFxo/StdwP9Jt86Su27cwS8RLELLA0W4XxMES9xsGfxJQ==@kvack.org
X-Gm-Message-State: AOJu0YxRDYYB4C7vs+yQhhWvsGgnf2wtjtYnB6vyDDx9KkWsIOZNyvUs
	MM4kWidnSLyryA6gRAPF+0aExm0WPmMUIf9hSFPdwGsW1k4qsAdfCuLN/a4tDD8Kx6YmnaM4bMq
	svnvag8G+/XezDIiVgjnjaVkuiJQETw==
X-Google-Smtp-Source: AGHT+IHR6xFYszK4+K1zJ7x34fdqaraQe5y8W2mKlsyfVWqY61VgJjpoj/hoG+yp3nKa95huvBVNGi6O5OEIefwAUag=
X-Received: by 2002:a05:6402:35cb:b0:647:57c5:549a with SMTP id
 4fb4d7f45d1cf-6496da194dfmr2513983a12.20.1765375671662; Wed, 10 Dec 2025
 06:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
In-Reply-To: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 10 Dec 2025 08:07:40 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
X-Gm-Features: AQt7F2p_dxGJAxRHeQhlsZFZpT-Z5idQ0sbvxfj8M1nY1-hCH2HKJsHw2kaRQuU
Message-ID: <CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
Cc: m.szyprowski@samsung.com, ye.li@oss.nxp.com, kernel@oss.qualcomm.com, 
	saravanak@google.com, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, robin.murphy@arm.com, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: io88z7coa8dw5e7rtq4zr9ge3usbskkx
X-Rspamd-Queue-Id: 341F8A001A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765375674-272160
X-HE-Meta: U2FsdGVkX1/JqXtUc7iFI7VFBDm2zKosXbBaaQXAIRDpUl0g86Tpv1ytJ+wB6jZpcy84/jS1ggBmSsBPafIhXBDAUt+er33x325Z8Jg+KF6zKzMG2zWOyjfYlJs+h4Y4qwflVoNhi3Oh8jFbqMYxDkYFJWPf6+0fvJkRObNKuAfrukoGHx6Km+4l6WTN60Wr1n2QKgVHb9triaQmEC908IfD4zmpHBO7C3hwa6iX1jnpt3/gwiCJxGs2/gjENLRWjx9gYPi11E6zbyRxIxkLVyM/087XwE+Gs8ccETqbJIp/xFKqE43RGu8xra4lKtGkhodmXk/CgvjLNDCuRKw7g5ZCYwzJpwDfEJ1UXY1UCPleNAx3J+FIjiraYMveqoUlByV5rSk7p5ywuV5blnRkmd9mQrqjtLGKgPzW4RXkME1eEv50coptK/esWjzzrrZ8WsgCsJpaeYardDLjimZs3mo9WJUcdHvI2eWDaLKj6IXpCt+6Y/1F/D8U04XUYff6flFjPojzhxNw+xypNhRDe925EsOH6R5cV0lpxSRXwityFh2r4gZljz4Y/KmtsR5i8d5kmZbDXpqlxSxgnK/X+JkrMJu5udxCEmASNmbGVw4+Q5MYv9rEALFHjU714+yarbFQa0aBPugyy3IWdYZYDezD1F5D6Q7vF4UQbAtXfVhdZz3OxLYCKU9D4c72PUP6/AuRv3KHJcdjDOwj/0bkjFGjnVGU99IEv3yCOP4JKAeZjT9Z6YXi5W6FiG+SoJPY5bLYREnDrXmEeC5ak1kErxi5NLLXYammHklDdSA++H6L3xDA1syVBT6XLF1THDRfUyBanzdpHckNWhNNTfV1MTcFc98oNh9BJtX52I8ZkOzbNXk6pVAfeurp6gDl2DPOfMjnIxtsA/cHkAIWY3WkvGjUdbONS3eR5YqZHQcnchF44Mg1OrRwzfsdA1gcV7qSeoVl/iFTIKx+3zmCkcq
 9Cr9jQP6
 dRM+SvkbE4jiic6AFtr5fI/zHXCkPetu7w28kf0RqWjsD3T++xCWWamDdMxjX2QbsJ0JxOg2fmdKHyN+mTbZ5BabV6e3TJEwRGZuYd2Jl+5LDCCqrIhuq0nn4XZ0I/1lg6EQ1kHU2bee7vVoOO5L+3WvHXNueKGZYfUPVUN2dBYbPpe5u8ZI+dlOi7ZM2JQh22QKyvbtQeTi8VgWnE+F/pX9ACe7XqRAJRfk67YJZwsBztjmUGIXI4/sADf+yoNd5RY46fBP9o0okMrUA+e9R4/YGfI7s+QIBDYiZvnrc62tOYu+oqbjlpWUR1pn4ivZre0Slwlm4A7gaF2MhhUTUxaDd/WE4OdjV5eKg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 9, 2025 at 6:20=E2=80=AFPM Oreoluwa Babatunde
<oreoluwa.babatunde@oss.qualcomm.com> wrote:
>
> When initializing the default cma region, the "cma=3D" kernel parameter
> takes priority over a DT defined linux,cma-default region. Hence, give
> the reserved_mem framework the ability to detect this so that the DT
> defined cma region can skip initialization accordingly.

Please explain here why this is a new problem. Presumably the
RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
early_param hook. And why is it now earlier?

I don't really like the state/ordering having to be worried about in 2 plac=
es.

> Signed-off-by: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
> ---
>  drivers/of/of_reserved_mem.c | 19 +++++++++++++++++--
>  include/linux/cma.h          |  1 +
>  kernel/dma/contiguous.c      | 16 ++++++++++------
>  3 files changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 2e9ea751ed2d..bef68a4916b5 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -158,7 +158,7 @@ static int __init __reserved_mem_reserve_reg(unsigned=
 long node,
>         phys_addr_t base, size;
>         int len;
>         const __be32 *prop;
> -       bool nomap;
> +       bool nomap, default_cma;
>
>         prop =3D of_get_flat_dt_prop(node, "reg", &len);
>         if (!prop)
> @@ -171,6 +171,12 @@ static int __init __reserved_mem_reserve_reg(unsigne=
d long node,
>         }
>
>         nomap =3D of_get_flat_dt_prop(node, "no-map", NULL) !=3D NULL;
> +       default_cma =3D of_get_flat_dt_prop(node, "linux,cma-default", NU=
LL);
> +
> +       if (default_cma && cma_skip_dt_default_reserved_mem()) {
> +               pr_err("Skipping dt linux,cma-default for \"cma=3D\" kern=
el param.\n");
> +               return -EINVAL;
> +       }
>
>         while (len >=3D t_len) {
>                 base =3D dt_mem_next_cell(dt_root_addr_cells, &prop);
> @@ -256,12 +262,15 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
>
>         fdt_for_each_subnode(child, fdt, node) {
>                 const char *uname;
> +               bool default_cma =3D of_get_flat_dt_prop(child, "linux,cm=
a-default", NULL);
>
>                 prop =3D of_get_flat_dt_prop(child, "reg", &len);
>                 if (!prop)
>                         continue;
>                 if (!of_fdt_device_is_available(fdt, child))
>                         continue;
> +               if (default_cma && cma_skip_dt_default_reserved_mem())
> +                       continue;
>
>                 uname =3D fdt_get_name(fdt, child, NULL);
>                 if (len && len % t_len !=3D 0) {
> @@ -406,7 +415,7 @@ static int __init __reserved_mem_alloc_size(unsigned =
long node, const char *unam
>         phys_addr_t base =3D 0, align =3D 0, size;
>         int len;
>         const __be32 *prop;
> -       bool nomap;
> +       bool nomap, default_cma;
>         int ret;
>
>         prop =3D of_get_flat_dt_prop(node, "size", &len);
> @@ -430,6 +439,12 @@ static int __init __reserved_mem_alloc_size(unsigned=
 long node, const char *unam
>         }
>
>         nomap =3D of_get_flat_dt_prop(node, "no-map", NULL) !=3D NULL;
> +       default_cma =3D of_get_flat_dt_prop(node, "linux,cma-default", NU=
LL);
> +
> +       if (default_cma && cma_skip_dt_default_reserved_mem()) {
> +               pr_err("Skipping dt linux,cma-default for \"cma=3D\" kern=
el param.\n");
> +               return -EINVAL;
> +       }
>
>         /* Need adjust the alignment to satisfy the CMA requirement */
>         if (IS_ENABLED(CONFIG_CMA)
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..3d3047029950 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -47,6 +47,7 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys=
_addr_t size,
>                                         unsigned int order_per_bit,
>                                         const char *name,
>                                         struct cma **res_cma);
> +extern bool cma_skip_dt_default_reserved_mem(void);
>  extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsi=
gned int align,
>                               bool no_warn);
>  extern bool cma_pages_valid(struct cma *cma, const struct page *pages, u=
nsigned long count);
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index d9b9dcba6ff7..9071c08650e3 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -90,6 +90,16 @@ static int __init early_cma(char *p)
>  }
>  early_param("cma", early_cma);
>
> +/*
> + * cma_skip_dt_default_reserved_mem - This is called from the
> + * reserved_mem framework to detect if the default cma region is being
> + * set by the "cma=3D" kernel parameter.
> + */
> +bool __init cma_skip_dt_default_reserved_mem(void)
> +{
> +       return size_cmdline !=3D -1;
> +}
> +
>  #ifdef CONFIG_DMA_NUMA_CMA
>
>  static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
> @@ -463,12 +473,6 @@ static int __init rmem_cma_setup(struct reserved_mem=
 *rmem)
>         struct cma *cma;
>         int err;
>
> -       if (size_cmdline !=3D -1 && default_cma) {
> -               pr_info("Reserved memory: bypass %s node, using cmdline C=
MA params instead\n",
> -                       rmem->name);
> -               return -EBUSY;
> -       }
> -
>         if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
>             of_get_flat_dt_prop(node, "no-map", NULL))
>                 return -EINVAL;
> --
> 2.34.1
>
>

