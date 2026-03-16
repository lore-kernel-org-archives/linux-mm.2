Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D995BF53D78
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2011B6B032B; Mon, 16 Mar 2026 13:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEFE6B032C; Mon, 16 Mar 2026 13:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0842A6B032D; Mon, 16 Mar 2026 13:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E94546B032B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:18:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9953C8B177
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:18:56 +0000 (UTC)
X-FDA: 84552586272.03.336B7F0
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80823C0007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:18:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t+wdOITw;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773681534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jK2scyfYwBMU55V+xfenTzy10C1cc5BhbFAgTj9RHSs=;
	b=NzD9eKj0x4z4klTzVp0IzuREFYSqsBJO4QZM6+6tDK8ihcIRYdxBQbOW4pzQF0j3I60bcn
	fFNoMx/Sj/xFnbMmrzt4hsQzRdlQoGl4r15GvrGKA66G2qXvEEKG4bmAZfRMZIDH+uDsOM
	1zgT01gMtL+NEPLnZ4rV7AxTed/Y7Ao=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t+wdOITw;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773681534; a=rsa-sha256;
	cv=pass;
	b=UYbbT1BrFjFA7Ya8wYL4ElbEkTSMYcQ6TDjDGkWBMaTexur2nauaHNzMYhuDhdDd7iVgGA
	CQ+sQJy/l4BbxpPfJk68977FVkEY0wwjyirXlQhqnyeGBEu/7l5QzDomPXqazCDZptFL7d
	zam7zgCSfaZSOjVFb5VMVY7XcYfwBW8=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ffe16290e2so977300137.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773681533; cv=none;
        d=google.com; s=arc-20240605;
        b=kchwGMoZfGYDhulsKgqQzcLiXs2bzq6DGNWWwKz8+4bAJD4qhEI2XxFmf7a0ZgwKQw
         ZI6bb/U+7n4Zy1vVcsTOHrDIZXhErV9AyjZ4kvVuxYNeXclH0ZCbV9tuDCraeeMfgs9j
         d8Df6UsbaSkW411e7frMdGCf6UkVmFlc8OA0U3DwUai10IhGKRE7fiapApVb9lfjIU2q
         FvyabdCnAI6sc9EMaQhcUq9ytwEHP1MG78Nz78Ee/R9BeeFllgXdOrP+yvJtpjPVav2K
         kpUAeIbm86Qi1zU3Mg2vTDLHDVrGDaG2Epy4Hi7jyfAk9ZakU11NFXJVS7h5Yaz+EhF5
         G6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jK2scyfYwBMU55V+xfenTzy10C1cc5BhbFAgTj9RHSs=;
        fh=sH7oZqrwRyBgLwI6pu8f4WYxzeHZ28/yfdWE/Ybfots=;
        b=cw4DXaAGM5CqTZT0XoN5snAFWGfkY5Ys1y9URsOcCTFghbRP8sILSJImijDFAEMZA1
         RDOIJBGJCU8d/kCKoMpeMabLS4PpF42mCnjxXtGmVUcVYBgGK+NlWc1a21dbSY3sM7GU
         LKy1Lunlf1c4/l4ZEaRmL5VPMdPIOSAO22zS3yh7QAeOo4EGDFZ4fvnMaJiqlXw6G8Gm
         gYVX9NM3sLEfTvaVzJvu5fm6P3sd6YIhpvz32RdWQLoByB3RkeRFJhCzIYGg9BYwU8rJ
         em3V4s95T6O1WoZzoIUwi5MfRg5U1g428xPCrQ/0sjoMGJq+XvnURn+6KFgM/TTjoCc/
         ePMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773681533; x=1774286333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jK2scyfYwBMU55V+xfenTzy10C1cc5BhbFAgTj9RHSs=;
        b=t+wdOITwz3sQ2vz4H1l3amgC6L1SiOoHBm8RDrTIcQnGquRV4CbcbVOC2XVANLU51J
         TifDVWczHpu1MfgdMvYU1WzjwfJdnCxElCLf7gjpp01CnR9Fv5t5J4sb2SEnmKIK0hJC
         s7QnfFfhqmv2SJaV9nHFu3jf8zvmQFeV6KYTGTLZx+ABrTqBnzBeF/unhgDkacxXzIcb
         Tou5d2KR0/dJX9gqW0PGv8h+bHKFEQLp9VDwiZtZjthalKVQ+ke+Wxd4MgwjGZwWgiJ8
         8Hr3xGkivXgzGUvCKW3h/NbWRzIfgMxfpUW1vvTLY9smjbzLsoJ8Yd3PsH/046CvlMp8
         clMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773681533; x=1774286333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jK2scyfYwBMU55V+xfenTzy10C1cc5BhbFAgTj9RHSs=;
        b=jF3NSqdSTbwlWgUQPpXRrn9qEr/bjxhgAiCNdD0uFIHzM+JZxqKKOjiqABgvafgQiG
         jiILA3yIfkv/PMCsP5XaxpR5UQgs6Wns4s7l7FPKmxHge2F/gaxe9uvyRD6IAHvpLn9K
         iM/1lJu468SUYT+1QGTjxvFYlD8t8QJkWJOzgXo3Xyy0BChfxQiO+wm0zpYeR7AC7mTm
         u8YTXgKXnCNw90lvCH0rTZsBX/e0QrqqlWlNiACzt6LqB5FThmGkIhCQYbwSjTseuTIC
         GLG4f9HpEBVhNiTCD6n5v4Y5KmC5oa3D+5lD8btPgwa+tWOCGxR4b/Pylj9N6EB2Wn+o
         65/g==
X-Forwarded-Encrypted: i=1; AJvYcCW3G+Lwc9aER/3NF/pNK1WA0Xj9wHLwHhbVeNEhjQ7Sxo1J3kW47IHPnjlkgWRLpg/gKg3PAvDM5Q==@kvack.org
X-Gm-Message-State: AOJu0YwcakTHKKtSseyASw6mh8QbDKZgyTxGbyEMTRjkWV8EZvd4OjXt
	8CioaTBq/4OBH4Tlxuf5t32n3QmUzPF8Cz3AVDma0Pf85my2t9rbrpI/B+zqQFKYSGvHFh2LzXJ
	5iXbQmDzgjbqehKX7or+g0eIUFi4ChAfBC26JiKGb
X-Gm-Gg: ATEYQzwXmBncL/ygzR5CuW6kFY+mH+ip+idmRxuJaF5hPR3o4jFlpc/5SdGF7hqb3s/
	0AA24H9smRDChtA02rDbaQ4haB8cNfW7v5YwXD5UgTHp3QvqLZUbTE1kqCJ0ClTVnW20fQYEkM9
	dp/Due/wsK5wBNngcG/3zGs6HZ00st1apOSCR7RlLQ5FCzuj4+PylXzor+JKkKG1MacnJc0g9ob
	YCRsm3F1kKdLjvWNfbvGuyknR0a5fqgMqHlYZUGz2eonO7yaIdfvZ+P0CWpEBYFUXRL3i67XkaI
	0X6Ywq5k
X-Received: by 2002:a05:6102:d87:b0:601:f3b6:f2ce with SMTP id
 ada2fe7eead31-6020e27c32bmr5393489137.12.1773681532920; Mon, 16 Mar 2026
 10:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org> <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org> <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com> <20260316160759.GA1767448.vipinsh@google.com>
In-Reply-To: <20260316160759.GA1767448.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 10:18:22 -0700
X-Gm-Features: AaiRm50L1lnLwO1eCIJNJtk4Bw53fGwzF8hjQ-eN_1dFmVAntzs-kWI2tT0ZbZU
Message-ID: <CALzav=cskxLZtZ5-uRa0+aV+1Kb3fwQQJ5dS=Yes4GAHrS6GpQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Vipin Sharma <vipinsh@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 80823C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: wp1971b4ya8d7usgicrhmst3oc8trxmo
X-Rspam-User: 
X-HE-Tag: 1773681534-645275
X-HE-Meta: U2FsdGVkX18YQho5ySG+RRHBbXcfmqOmE1FftRWhOIULkWnTR3bEkUXXi2kZK8uwosCPt8N8OhtOgfuHRXYBSzzRFwybwHKCkdHXXeyn1rQe0UE3kAyH25IpcJltOLLYsmRfr4o99XKKUmFbBNGuRSWxgDdWfM+ukFvUs9Wjkv4o0BISxleEiASFiLzjTtCgE1WvyD8VHlATvmTsQeybqOltbxyoOdAL9U3foFfADrmSrbCgIyOTi5GkCbLsH47FMMIwtxEQj5t1UqBelc0GdrKjouI5ICGIKWenCPcojl2tOwtdjLIe+QmZ5n706aKOTdQlVXukzM6thLq+J6G9offbRyglYyOKsiBk7pzZ9XlWIbxmYzXTI2DTt8xHsUkEac+Gg5uNJEe1u8+pIUNoRBCmxtv2fMlUhLuDszfgKM3ihkCTRHTja05PN+yq9syU5f9v+WNzCUdHhR7ceM3+3nUwwIwcq9QTXU7Yd3TXrao9pHg+o5jgK0VWfh9iZioZQYIQjuNV4eKj/XLWF/xUfCnREZm7QzM7CYQMyrzAN+Gt0AclN2bGh6otmAkxsyeph6Cl6qr+Q3b5PU9FyLBaYOdGMYcHwXH6hfZLVuQbesiERGPSTEeV8BQRd5dh4HjRubB0KC74ykFn3jWlgqlV3yf8flkDO7r1ZCTKPos4+Xmg9lMTz7CzfhUgwHusTY4UFduyPy32l8k92wBRgEZhW/KMz0jBCaAPnXVFbn5eiME0M8xvI3XIYRsu/5tCCA51P7CGpM7mtaihR6zkU1/ManSD/uTSFoyI3EhwiU2OmEV8Hct1p4IAHFvSDfpNNp77pwD3N7IdSTh15l7X6AR6gpthE1NDb2gzHUeKFiYnIa8/sfuRo7JiJH+jkSQpCBMo670vTEkNzZ9rXiSICDvVZl9o5EhVInZNteRibJdchPAvPQ3Woq/yjqIH3X8aawuAsuVH5piAaMxo6viNwEj
 oQOQl8Wq
 kD7TGxrM1xNcbvl4sTfqDUF+5MRwC5EQ6IYVgMR63XYwUNsASbrtn/cCyMUDNJPBibC97/iVBFYZCBAzl0lHYLhJAtHPdKKyglkhoulz1pjNRgn9WyVrm+CzEzT7wvTgALHOwEOnp/diZzog3kaG638Oqi9v1CrbUZS7BaSfsaiM056NQJyijAoUU7OlkpigYVDjRAVhbIDcT/z2tqf9PrKd0Q6kbhk+kA35wbboleSR2aWaiR/ssdIXr1XG9bLeOTtt57XFv6XWpSAY/g0tK6FqXka9MFbGpi+LnM7AtkwgSXU5ULKSuP80FRvUwGgDLG987
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 9:22=E2=80=AFAM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Mar 12, 2026 at 11:39:45PM +0000, David Matlack wrote:
> > On 2026-03-09 10:32 AM, David Matlack wrote:
> > > On Fri, Feb 27, 2026 at 9:57=E2=80=AFAM Alex Williamson <alex@shazbot=
.org> wrote:
> >
> > > > Sorry if I don't have the whole model in my head yet, but is exposi=
ng
> > > > the restriction to the vfio user of the device sufficient to manage=
 the
> > > > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP push=
es
> > > > the knowledge to QEMU... what does QEMU do with that knowledge?  Wh=
o
> > > > imposes the policy decision to decide what support is sufficient?
> > >
> > > Hm.. good questions. I don't think we want userspace inspecting bits
> > > exposed by the kernel and trying to infer exactly what's being
> > > preserved and whether it's "good enough" to use. And such a UAPI woul=
d
> > > become tech debt once we finish development, I suspect.
> > >
> > > A better approach would be to hide this support from userspace until
> > > we decide it is ready for production use-cases.
> > >
> > > To enable development and testing, we can add an opt-in mechanism
> >
> > Here is what I am trending towards sending in v3 as the opt-in mechanis=
m:
> >
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 1e82b44bda1a..770231554221 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
> >  config VFIO_PCI_DMABUF
> >         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
> >
> > +config VFIO_PCI_LIVEUPDATE
> > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > +       depends on LIVEUPDATE && VFIO_PCI
> > +       help
> > +         Support for preserving devices bound to vfio-pci across a Liv=
e
> > +         Update. The eventual goal is that preserved devices can run
> > +         uninterrupted during a Live Update, including DMA to preserve=
d
> > +         memory buffers and P2P. However there are many steps still ne=
eded to
> > +         achieve this, including:
> > +
> > +          - Preservation of iommufd files
> > +          - Preservation of IOMMU driver state
> > +          - Preservation of PCI state (BAR resources, device state, ..=
.)
> > +          - Preservation of vfio-pci driver state
> > +
> > +         This option should only be enabled by developers working on
> > +         implementing this support. Once enough support has landed in =
the
> > +         kernel, this option will no longer be marked EXPERIMENTAL.
> > +
> > +         If you don't know what to do here, say N.
> > +
>
> To use VFIO liveupdate, user has to do at least two things:
> 1. Enable CONFIG_LIVEUPDATE
> 2. Pass VFIO FD to a live update session.
>
> This means someone using it has to know what live update is and
> intentionally pass the VFIO FDs. Isn't act of doing this itself an
> opt-in mechanism?

If it is, then I can leave this out. Alex?

My thinking was: Distros are free to enable LIVEUPDATE and use it. The
support it enables today is all fully functional (albeit new).
vfio-cdev, OTOH, is not. A separate Kconfig can help express that
difference.

Consider that LIVEUPDATE could be enabled by default in a future
release, but vfio-cdev support might not be ready yet at that point.

> I am not sure providing VFIO_PCI_LIVEUPDATE alleviate Alex's concern
> about how userspace will know that sufficient VFIO support exists.

I was thinking we can flip VFIO_PCI_LIVEUPDATE to be enabled by
default (if LIVEUPDATE and VFIO_PCI are enabled), and drop
"(EXPERIMENTAL)" from the option title. That would be how distros and
downstream users of the kernel know that sufficient support exists to
enable VFIO_PCI_LIVEUPDATE.

> May be write in liveupdate documentation (PATCH 11 of this series) that
> support is experimental?

The documentation in patch 11 includes largely the same text that I
put under VFIO_PCI_LIVEU"PDATE. But I can explicitly mention
"experimental" as well if that's what you're asking.

