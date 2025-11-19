Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 491D9CF6481
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 21:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C3D6B00A5; Wed, 19 Nov 2025 16:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3B76B00A6; Wed, 19 Nov 2025 16:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9F36B00A8; Wed, 19 Nov 2025 16:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5346B00A5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:56:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EB7FBAA3E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:56:51 +0000 (UTC)
X-FDA: 84128717022.29.108F6F6
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E45240017
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:56:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=H227m8XO;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763589409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNCgiEwH4yoLxLSeabt8BIXDk+2v90qbq38QcBVyYpw=;
	b=V5r1LpChLAgmrAiMZsAkf7saAAHDWDeHj1M7XFsFvOotjcXAaCnQBpBYKf5TSwb4seUxlq
	u3fai+ndvMrKLzmkcGPzQPAfImpj8cO0dwVXnoBcr2h7lGzWbvEsTzlvDh3ZgqbT5SHb6m
	7YJpsFkTis22KxUaV0Hc+1PlEreENpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763589409; a=rsa-sha256;
	cv=none;
	b=GqB8tESM2MZwy/OxoyjVAaPYJh9pYEPAgbdWECLRgt0KwqvdYbhYR5GZ9byDHFD0Yj6ar2
	ntOveYu38RWeaNERzPK/ROmviaUnhixve9Y/OYgPXIFbZfzq9Psw8jVrD7RrFbLYYx/V38
	khqFbk/T4Qd3dTumMH010/QQdFiaOvk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=H227m8XO;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so298220a12.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763589408; x=1764194208; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNCgiEwH4yoLxLSeabt8BIXDk+2v90qbq38QcBVyYpw=;
        b=H227m8XOD2uSgK8sX3KmAfxf4b5UusTjg3pSlRYodzCiQYmGoRA6yo3CH8WkULOeJY
         ug2YlOs4dyjdE6FTGuJUoMiRSnCcGzbQYAfaJeFp6wJhRzxZfN6ZF9Qwb3T3C2SUrEP0
         hsmlTPbt4I6PChv/hl6Box+oNEv+U9rKtbDwHN6iBELi27R39CQlwoUg5MXw0rJ0YMEf
         YRRAlT6pEwJh3o3RBOrZcEJpGmopXrZR9xgfPwvsDYYripOWpP6UpcJmO8KzSocUGl7j
         UCigKFgkYna+YcIVxkQhMjwGuBMjctFa3ftUI8vcsTcD6eBikJDpB5rtlBxOMo24LlBt
         DJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763589408; x=1764194208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GNCgiEwH4yoLxLSeabt8BIXDk+2v90qbq38QcBVyYpw=;
        b=K6BUWQL9jvYsQnkH+nNQBrIkNIx6nTqMdoVQ1Cqbw+cJO0fxukhYxOlT20tFWUBx4V
         QHRu/tbrSr20nWvQW9x/Q9lgBSkwOyoIvrdB3w1gjvR39WoGR1ilsL1cJCRG0RknmMoC
         PCydB/QCwZQhZXcDw6p3NBwlZlhEau9q1l10soTSK+Lz9dDoZLKlToqBHG3gz86xgiwr
         8buv3wOqQyg4nm+oRzv4kBFaYy+z5c+CSJ1ln+GFohQ1hctv0mVfFwkjAEcHBDhxUS5Y
         xW7CCzDQuMgvXszMcga8MXKq50NVTOq8PSM24ES/SJzNTDyteoLLSx4dqBkoDTPBZoh8
         V+uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH/nkSWpyVEOjalbNXacwtCJj96RJbldeLFKOMNEJjXGC9o5EJXcH3259vJ77+RA7l005u6iUzkA==@kvack.org
X-Gm-Message-State: AOJu0Yw1hOlAzitFzmEFgJu4GyUDJdbWd+s4OPN+I4kvi4QjmSmvB9gl
	4oywBzVkrrMqvpOAIj7O4PyLhIl44aCNCRQLc47U5OO8ELnA7wZgS2T1Y8Ban/ZHZt0REr9Opmb
	Wq9lSEBV2mOQdcnQ4NVss3wZZvPUqSYBggcMiMtkbgQ==
X-Gm-Gg: ASbGncsZl9GLvY3+q99Zx1AAiS2uoZpPg0d0IfiMAFxshmAOV6B+47Zlkrn1TnUJ5GX
	0tjy64L3EDevx4Cz+6+zJjTY5hl/fHSYKVH/v5ALvBMP3x8jTim8i11icbydVWXLvZ8PDGPoFds
	v+KEHfI3A5RAsXYABoHAjYXFTLOALyBZ7oiWIwOfQtHL9yPF+wfzPGQkgMcFkEN1r78KBBuvosm
	XiKYmxzCRxjDfZzn1/mMebA4i1lAP4j2bRLSAMF01wK2cH157gM48xOASS/zfP9eXLgAdASy2T8
	C6U=
X-Google-Smtp-Source: AGHT+IFLyS+wG0rWTlTQxvo48mFxi5vli+cxPH15GpPZdhy+X8F56gfcnoxRYXFwUVFltbkM5G+J1V5jBE1mGtvRoNo=
X-Received: by 2002:a05:6402:27cc:b0:643:8301:d107 with SMTP id
 4fb4d7f45d1cf-645364828ddmr742149a12.30.1763589407434; Wed, 19 Nov 2025
 13:56:47 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-16-pasha.tatashin@soleen.com> <aRsBHy5aQ_Ypyy9r@kernel.org>
In-Reply-To: <aRsBHy5aQ_Ypyy9r@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 19 Nov 2025 16:56:10 -0500
X-Gm-Features: AWmQ_bkST9g5qeVKeHrDii74Rowe2_O-kbr5Wx0FA7LJaDDxeXF38UaoBxVWMYo
Message-ID: <CA+CK2bADcVsRnovkwWftPCbubXoaFrPzSavMU+G9f3XAz3YMLQ@mail.gmail.com>
Subject: Re: [PATCH v6 15/20] mm: memfd_luo: allow preserving memfd
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 158mmzf3jco3sutk9cpbcruy69t8dsrc
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E45240017
X-Rspamd-Server: rspam01
X-HE-Tag: 1763589409-629181
X-HE-Meta: U2FsdGVkX1+pyTSxSe6DNRB7wYBqW/As27eA/1yte9uARbJiNOT7HLDV43ECKbfCHXYgfQEdl2qOpXwjb6t0cEE7WiIliMEefIFSt2ywOwPQwCldRjz/eK6J2+karOH2lFxG/NFwMUp+cW9SY07a0qF2DE96Wmfw214rI3MbxeN6JKg70grYHghjrgIj0J2DVYf9OGr/CfaA6GkQU8bUAHwqwnsGmnxkWFtLfBWtTnf8eHc85/EQYCE+EV10AOaPDb5jpem/OOasNzsd8Lmmw0Dfl6shcYo8BAFvhQAqaZDjZh67P2fjmTRkGdXXbWXAPwXvAAzOsj18VTfWOfx5CInnBoUOkUkFI2Q3e17dG+dMYC+J2ARQxi8WAQV7Tla0tuyjc2lpDGhNaZUxeDSCZGlKQhRHjAPQOAiUzxmNTLXrXYGkm4xkoUKmHjpNSY6cjlEWqj9WQqtAgPjUzTMV9AFJ86bz6sZv3xYqgfyeXm4/TJs7anBLXfR0dw5jVcMBtLnnW3z1ZYAuBnKOO4JQ1UVrz9iTiVTp5SO/lhgOiEWYTWDgeBxl4WHkGIbl0/yKwqwSfpBJeGfC0in7gPt98S6K00yH4a7Mb64udvfhbZRMHSBKznKhD9zKPh6dQqmr1FaIXN+vXWTZnMtihc8TXwpkiWjFOVGT3mOp6L2/amE+01ttso95NxOPPBJ+jPmzaa0uKZFoWuvbPOp2gZRvVzl3+SVDHvvbJU+iG6s1ALGECyEsMG8EE+Td5wXdJbIs3uOUBT2abFLZbKhMgkXDBCpRw72OOJ6YbFyz+zVCDqDXZj9B2d25xedAQPqbyDibKxrDeOPodTMDE+g7gt0DFFHYCUamidKy7TsLe8s/S3qX2veJyy+ATH5O5aVCt2tocdCpVdG8n9kMObvgNNYsXHPE0nXyVe1aMT7CKeLiGT5C28H0XLvvqzrd67BUQgafjb0Laoam6iEcsh2JJbm
 lh6NAUeK
 EoiuEPmzzLvEoC46nrhXhwtC8LA/0kLgg90VTzYfo00AXvx4RELE624/rPK6MY9GQ83E0os+KzARvnavip3L7QL9WU3KYHJWC/oMdlX8eObAySPCOQIlngA3Ea5f6HBFbViYuFBZg8C7IF0D2LYOyHKkVWmH6lyi5+UFPYDF4BuxBPGdhvFI22Uld6KhNVIX5Urq4nRip+iLy8VRpb2ci3Wanlvf8Zeo95SCfz91OOF+JGvZWfNoTuDWoC2VPbovthAmEg96nVwTtPq0K8fJFbrmXSoRHBfCSLKwEEg8TUeyrK85TLCL5+asHmDucj5tMA3U+ND4gPeDLQGicGJip40u8eapVoF5ZtAJyfXUwjdC0KWGJlLvPdOQUKHSimhhDgYPFyI0yhgV4wpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 6:04=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 15, 2025 at 06:34:01PM -0500, Pasha Tatashin wrote:
> > From: Pratyush Yadav <ptyadav@amazon.de>
> >
> > The ability to preserve a memfd allows userspace to use KHO and LUO to
> > transfer its memory contents to the next kernel. This is useful in many
> > ways. For one, it can be used with IOMMUFD as the backing store for
> > IOMMU page tables. Preserving IOMMUFD is essential for performing a
> > hypervisor live update with passthrough devices. memfd support provides
> > the first building block for making that possible.
> >
> > For another, applications with a large amount of memory that takes time
> > to reconstruct, reboots to consume kernel upgrades can be very
> > expensive. memfd with LUO gives those applications reboot-persistent
> > memory that they can use to quickly save and reconstruct that state.
> >
> > While memfd is backed by either hugetlbfs or shmem, currently only
> > support on shmem is added. To be more precise, support for anonymous
> > shmem files is added.
> >
> > The handover to the next kernel is not transparent. All the properties
> > of the file are not preserved; only its memory contents, position, and
> > size. The recreated file gets the UID and GID of the task doing the
> > restore, and the task's cgroup gets charged with the memory.
> >
> > Once preserved, the file cannot grow or shrink, and all its pages are
> > pinned to avoid migrations and swapping. The file can still be read fro=
m
> > or written to.
> >
> > Use vmalloc to get the buffer to hold the folios, and preserve
> > it using kho_preserve_vmalloc(). This doesn't have the size limit.
> >
> > Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>
> The order of signed-offs seems wrong, Pasha's should be the last one.

Updated.


> > + * This interface is a contract. Any modification to the FDT structure=
,
> > + * node properties, compatible string, or the layout of the serializat=
ion
> > + * structures defined here constitutes a breaking change. Such changes=
 require
> > + * incrementing the version number in the MEMFD_LUO_FH_COMPATIBLE stri=
ng.
>
> The same comment about contract as for the generic LUO documentation
> applies here (https://lore.kernel.org/all/aRnG8wDSSAtkEI_z@kernel.org/)

Added.

>
> > + *
> > + * FDT Structure Overview:
> > + *   The memfd state is contained within a single FDT with the followi=
ng layout:
>
> ...
>
> > +static struct memfd_luo_folio_ser *memfd_luo_preserve_folios(struct fi=
le *file, void *fdt,
> > +                                                          u64 *nr_foli=
osp)
> > +{
>
> If we are already returning nr_folios by reference, we might do it for
> memfd_luo_folio_ser as well and make the function return int.

Done

>
> > +     struct inode *inode =3D file_inode(file);
> > +     struct memfd_luo_folio_ser *pfolios;
> > +     struct kho_vmalloc *kho_vmalloc;
> > +     unsigned int max_folios;
> > +     long i, size, nr_pinned;
> > +     struct folio **folios;
>
> pfolios and folios read like the former is a pointer to latter.
> I'd s/pfolios/folios_ser/

Done

> > +     int err =3D -EINVAL;
> > +     pgoff_t offset;
> > +     u64 nr_folios;
>
> ...
>
> > +     kvfree(folios);
> > +     *nr_foliosp =3D nr_folios;
> > +     return pfolios;
> > +
> > +err_unpreserve:
> > +     i--;
> > +     for (; i >=3D 0; i--)
>
> Maybe a single line
>
>         for (--i; i >=3D 0; --i)

Done, but wrote it as:
for (i =3D i - 1; i >=3D 0; i--)
Which looks a little cleaner to me.

>
> > +             kho_unpreserve_folio(folios[i]);
> > +     vfree(pfolios);
> > +err_unpin:
> > +     unpin_folios(folios, nr_folios);
> > +err_free_folios:
> > +     kvfree(folios);
> > +     return ERR_PTR(err);
> > +}
> > +
> > +static void memfd_luo_unpreserve_folios(void *fdt, struct memfd_luo_fo=
lio_ser *pfolios,
> > +                                     u64 nr_folios)
> > +{
> > +     struct kho_vmalloc *kho_vmalloc;
> > +     long i;
> > +
> > +     if (!nr_folios)
> > +             return;
> > +
> > +     kho_vmalloc =3D (struct kho_vmalloc *)fdt_getprop(fdt, 0, MEMFD_F=
DT_FOLIOS, NULL);
> > +     /* The FDT was created by this kernel so expect it to be sane. */
> > +     WARN_ON_ONCE(!kho_vmalloc);
>
> The FDT won't have FOLIOS property if size was zero, will it?
> I think that if we add kho_vmalloc handle to struct memfd_luo_private and
> pass that around it will make things easier and simpler.

I am actually thinking of removing FDTs and using versioned struct directly=
.

>
> > +     kho_unpreserve_vmalloc(kho_vmalloc);
> > +
> > +     for (i =3D 0; i < nr_folios; i++) {
> > +             const struct memfd_luo_folio_ser *pfolio =3D &pfolios[i];
> > +             struct folio *folio;
> > +
> > +             if (!pfolio->foliodesc)
> > +                     continue;
>
> How can this happen? Can pfolios be a sparse array?

With the current implementation of memfd_pin_folios, which populates
holes, this array will be dense. This check is defensive coding in
case we switch to a sparse preservation mechanism in the future. I
will add a comment, and add a warn_on_once.

>
> > +             folio =3D pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc=
));
> > +
> > +             kho_unpreserve_folio(folio);
> > +             unpin_folio(folio);
> > +     }
> > +
> > +     vfree(pfolios);
> > +}
>
> ...
>
> > +static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> > +{
> > +     const struct memfd_luo_folio_ser *pfolios;
> > +     struct folio *fdt_folio;
> > +     const void *fdt;
> > +     u64 nr_folios;
> > +
> > +     if (args->retrieved)
> > +             return;
> > +
> > +     fdt_folio =3D memfd_luo_get_fdt(args->serialized_data);
> > +     if (!fdt_folio) {
> > +             pr_err("failed to restore memfd FDT\n");
> > +             return;
> > +     }
> > +
> > +     fdt =3D folio_address(fdt_folio);
> > +
> > +     pfolios =3D memfd_luo_fdt_folios(fdt, &nr_folios);
> > +     if (!pfolios)
> > +             goto out;
> > +
> > +     memfd_luo_discard_folios(pfolios, nr_folios);
>
> Does not this free the actual folios that were supposed to be preserved?

It does, when memfd was not reclaimed.

>
> > +     vfree(pfolios);
> > +
> > +out:
> > +     folio_put(fdt_folio);
> > +}
>
> ...
>
> > +static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> > +{
> > +     struct folio *fdt_folio;
> > +     const u64 *pos, *size;
> > +     struct file *file;
> > +     int len, ret =3D 0;
> > +     const void *fdt;
> > +
> > +     fdt_folio =3D memfd_luo_get_fdt(args->serialized_data);
>
> Why do we need to kho_restore_folio() twice? Here and in
> memfd_luo_finish()?

Here we retrieve memfd and give it to userspace. In finish, discard
whatever was not reclaimed.

>
> > +     if (!fdt_folio)
> > +             return -ENOENT;
> > +
> > +     fdt =3D page_to_virt(folio_page(fdt_folio, 0));
>
> folio_address()

Done

>

>
> --
> Sincerely yours,
> Mike.

