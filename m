Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D866EF53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 22:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCA26B038D; Mon, 16 Mar 2026 18:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AC96B03A4; Mon, 16 Mar 2026 18:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1438C6B03B0; Mon, 16 Mar 2026 18:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0259F6B038D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:14:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 853C0B88DB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:14:50 +0000 (UTC)
X-FDA: 84553331940.02.7E7DA8E
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 804D3180010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:14:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KbPS6Lty;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773699288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1TI05GxVOzwi8Lp4rr2cTv/CbMBWmj36+RO6nniHqE=;
	b=6J/VwWjvmAlFJYqJzXWL6AACx0H8zpJqVW2w8QoF/WaCKiGeFiXm2JSLMYGr2kOaHrc3tq
	Y/SV4+wwlBBjW/6tVrfPWlhNfODKivFKLJmpvVdmCfG572+I0nEGZnNRWsPhE8vOvj6HZN
	OFEHtgLUW7aJ54cykQfXtBXM6whhKyQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KbPS6Lty;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773699288; a=rsa-sha256;
	cv=pass;
	b=ywA9HTFzoyb0StIYEeZv9Wg/SdXRq6MBhqdZQtipt3Zo6XLztNQjHBlXDuHOd9Ld2aib0z
	LxF8QGTcN3J1hL4l9oigbLiWSj67wZosgNf+Qw72KD/FHF92Pj1wVu5fKT4RakflZ9OpMC
	XgKa/1LHyxFBhUpEXWZpGP9JW++t0u0=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59e4a04f059so5184977e87.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773699286; cv=none;
        d=google.com; s=arc-20240605;
        b=MfoNrnlP/seNqNuFigx3wyxZVEGxQw0kCjmeGVVepooGYyOOtoCIzco+8URPNm3d0p
         TpzuRxR+CxU3fJniK+fWowTKC+/JIKB2QO7OF6Thx65wpu4yGZEWWT3s+G+8jA0JC63L
         lQjNDgCSzEdFZN2yBbJN/DxNtfuHZK3hjG6Il+90DnkMZWuAScwWnZ+TUBK4NNeCaR1c
         fbjxWXTEB9hcWXI6Wc2oFSldc0nqBCL6KNrSiWr8cxk0HoylyG8gofzWdFvN+RRo0Ii7
         CYsGr8XtUVUiQC8wXdXpzuU0bt21an5JxT1Hw9hOkXmenDjUyHnGRs5qsECILYmc0lEM
         kHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/1TI05GxVOzwi8Lp4rr2cTv/CbMBWmj36+RO6nniHqE=;
        fh=z/xje3cnEGmBSmaE0tZdFklxhIqxbCymhAkgBJ2n2dQ=;
        b=OAAfaeEWw/lzC6f/Zu8pZMAJfx2aBD2C2ZDxHf/Os/ZshyFHiog7w+SbETtmMphmtt
         RFq+OdkoZ9WNIjdeyeawJ9/wawe9VVM2OLetWfvX+RCbOH1/F0bL8JbuZ2zWaM0J3qTv
         VHs0GO33SJzhhal3U1I+L+c5oMHjsNwFHXHDMBlUyyfeprwX9EdrVtmMcagHfggIfr14
         TG5G4tZvvXTX72kZloNTx5TmyAF93UeN4TljqmmSXxxICwEnvcl63T98813gQTcxmWjC
         8NW6Y9sNuNkNUEqZMQJ3zwP6C542p/4aLy0CwnYDRGURtFExdEgWjBhKA0UddLGvOr9j
         ml7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773699286; x=1774304086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1TI05GxVOzwi8Lp4rr2cTv/CbMBWmj36+RO6nniHqE=;
        b=KbPS6LtyB7PabU3n0XgOhdH2/+bzY1ysOzhdj1K6WE8fMjKJ34DJbjWZR329MoRKJv
         A2ajWno1Rq1ktW1UnNFK/JpZKXfNcF+dyIBFWSV+oUnODIPE7P10Ihleh6gTuh/Zoe8L
         Vcpbs+R15/nOFWoBcD6EkXHuK9Tiq9E8mGjg2gqqER4C7FyaMqJasJOBf643JNut5UMG
         F3wmpAaVsBUrlx4V31VCMi4nR0NVJC7L+y2RLribOq5xIhinr9dr08vx0E5UjswEWiY9
         axZQ6Do4xL+bbLd+zhsNaar7DeZOwqr540Zp1F/0R8cIK1xV7QfLJ+ofhZ5TQ5DhO5P3
         XSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699286; x=1774304086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/1TI05GxVOzwi8Lp4rr2cTv/CbMBWmj36+RO6nniHqE=;
        b=nhRFOvX8bm+N4F5sNsCGQgXXaxBYNKfKBMSzbKtbDfhh4cqZkz9CSPOtZG3OQMY8bZ
         wJPPk1poZnKbb25s8o6BNH/kOQRJQUa1JfQOPbUt27GkVMDCBCbFC++ittpO7B/2wgku
         WHxVJKuQIFDBLSogTSLs6chjTH12wL/9+cfuF1kvqh5dGcN2eUwbA0q1OFRGoEnRK4p9
         vCpqq8330NwvK6WUNPnnbn+rviFNaWSj2i4TV1rjYwm4PHJY7dotSA4rohN98PN2EI1P
         Jzlaf69c6Qa+GziLujp9rHCDQ5p9ZYz4MmfUngNd1inwqgg8hguq2fD1IHZukt+guSYD
         /gNw==
X-Forwarded-Encrypted: i=1; AJvYcCXUy3yMfTcl8QM+auHIvQXbagY3FqH4yw25Nttnw4EUPI9i1lZtfU7PBc0nGBeIsI/VTJBFfQxnew==@kvack.org
X-Gm-Message-State: AOJu0Yz52Xu5lS/Wu1YhosFdeEkFmmJ6KNVLlYeqWConjXPntKw8BM12
	JRn25SmOtjNBcq+wFrgy8rEYq/+2bmwRuyGSDIfvbnfbipa9/sd0esUHqtbfM21TJ74Wp4jOIgY
	Yp9MYZmT7W+dqAqIMz0LCJXQ7mblotJYR+cq/vvyU
X-Gm-Gg: ATEYQzwlD1SFU/w9RXd8hcjPzdMscia1iXfYe4fTPCTxZKPwTic3pL8V6A1RU++zsV1
	I0zn3BjWoujcJptS5dn6IHK9UY9ikjZfnifoWfgNktLvqc8cWt0iwq4pBrqL2srhiT/OUWdqSog
	CUtcIzQhJPcWF9pwvMH5IYdUiib6xQ4xLHJHpBTbuQPEAk7M+h1fktM27uZqWCkGslKTH8fZeOW
	pUdV3JeHvY7zY34g374F8OcaNKB6TDbXxqwejl4jPyHXIQb2U03jLZ92DxaJs9Umti9vKsv0Wjc
	DPfmIn2CqjyFncD9cso=
X-Received: by 2002:a05:6512:208e:b0:5a1:34d2:b6da with SMTP id
 2adb3069b0e04-5a162b0a440mr3032307e87.31.1773699285744; Mon, 16 Mar 2026
 15:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-11-dmatlack@google.com> <20260226170030.5a938c74@shazbot.org>
 <aaDqhjdLyf1qSTSh@google.com> <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org> <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com> <20260316160759.GA1767448.vipinsh@google.com>
 <CALzav=cskxLZtZ5-uRa0+aV+1Kb3fwQQJ5dS=Yes4GAHrS6GpQ@mail.gmail.com> <20260316214055.GB1846904.vipinsh@google.com>
In-Reply-To: <20260316214055.GB1846904.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 15:14:18 -0700
X-Gm-Features: AaiRm50S3PNCrqX_TvZ1JiMZN8vQiYVbYC7Ez3YpAEpqzQo0lUEJ7c1xPn8zOqk
Message-ID: <CALzav=df8K0R0gJyQ=ifoznp_CMRRtyrWchbNvcw2-wpkdaBaQ@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 804D3180010
X-Stat-Signature: xg9p6cgi3xnsjxi8df7wookuh3kukrc5
X-Rspam-User: 
X-HE-Tag: 1773699288-650349
X-HE-Meta: U2FsdGVkX1+YDleypNg/Ku7KRzbKCWthY0SPHW5jvDv8PoajcHplUlQntLoK6rnLpxHDh5uSUdAaVb4WeYFMIrOU0jgMT6CY9f/OrhfEJj0bLM0lnpCv8sEtwlFIfbXvY9Svs1zAX1puWSNsrBCIhqFwkvTAS46Dj4ZqXVftgLeskCoppwjVXGawDO7NAUk8idQQDDSjg+TcQQ06Zmyih0hIxx1LG65v0RphFkQ9F2EIbGfRZ8ai/2cck7ysap/bj3lZfMaGP8iG/JdhJvTUNKCftpteiJpnZXVK8Dh2v2qnzbU7nJkMEP4JGttuw8oHARYkrc/V6ewaIvxJO1Hv3MMVkOHcTKVQVsEgsFkpNWnOOuslk2AD7ikiorgfYtED5lUPrUFJXV5sOzmf+KeLXh6rgsFPxWexfdCOfO8eQc9wGd/6L4mijVh0hPp0Rj+mCN/A+zYEJn/KUJ8X2uFnqcrdO1WIHZ0Hye90UBukgeesyjeMr0ud4uJedarPD03pefyTIbGE/xt+pjCC9XHIW+i9KdPATXOpGapq0fpqgO4noh5cbeqkOwZKQf5em0u3KL6E6LT9kioiAbQy1riFgFJTy1aQlSgkH4dZIxruh21T4OZx2BBFM41nACyLVbJSMiDJ0LPLkj3XIvwJ8YPz0Xx/L5MJ0GzrayAhQNl1IL0y2lUmYg9JVzGdYXHD2dky4WzEtk/TKMGTWexo8jegSCsnWbPSlJXdEezapx1PEMP9M0saeYeT6QhWsjqgWV0Me46u1NhqH9ac2SBq5tQq+D0GZIRC5zRtJubG2xvK+7fHJZIkkVC9Sx9KL76VbgmbFTEhI6Z+kKBUvfbNorJCfDqZwxFqN97h3BBprFVptgHbjf5dmGYNfNFpq/T1aKKggFjuSdGkygInFeSkbMCQoAI+PG2LU/YbQ47Cv8O9XQfV5TqYIzAzRchdAbTEs/D8c/b1FtaK+gkZb+yZ51p
 bNTijg4E
 gAnk+utdCXYl/NIsH5/TCbUliKNXRRMyqY6XoLTnz9CirvkVdmznTJOAiKb2cYR53wlh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:49=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Mon, Mar 16, 2026 at 10:18:22AM -0700, David Matlack wrote:
> > On Mon, Mar 16, 2026 at 9:22=E2=80=AFAM Vipin Sharma <vipinsh@google.co=
m> wrote:
> > >
> > > On Thu, Mar 12, 2026 at 11:39:45PM +0000, David Matlack wrote:
> > > > On 2026-03-09 10:32 AM, David Matlack wrote:
> > > > > On Fri, Feb 27, 2026 at 9:57=E2=80=AFAM Alex Williamson <alex@sha=
zbot.org> wrote:
> > > >
> > > > > > Sorry if I don't have the whole model in my head yet, but is ex=
posing
> > > > > > the restriction to the vfio user of the device sufficient to ma=
nage the
> > > > > > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP =
pushes
> > > > > > the knowledge to QEMU... what does QEMU do with that knowledge?=
  Who
> > > > > > imposes the policy decision to decide what support is sufficien=
t?
> > > > >
> > > > > Hm.. good questions. I don't think we want userspace inspecting b=
its
> > > > > exposed by the kernel and trying to infer exactly what's being
> > > > > preserved and whether it's "good enough" to use. And such a UAPI =
would
> > > > > become tech debt once we finish development, I suspect.
> > > > >
> > > > > A better approach would be to hide this support from userspace un=
til
> > > > > we decide it is ready for production use-cases.
> > > > >
> > > > > To enable development and testing, we can add an opt-in mechanism
> > > >
> > > > Here is what I am trending towards sending in v3 as the opt-in mech=
anism:
> > > >
> > > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > > index 1e82b44bda1a..770231554221 100644
> > > > --- a/drivers/vfio/pci/Kconfig
> > > > +++ b/drivers/vfio/pci/Kconfig
> > > > @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
> > > >  config VFIO_PCI_DMABUF
> > > >         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUF=
FER
> > > >
> > > > +config VFIO_PCI_LIVEUPDATE
> > > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > > +       depends on LIVEUPDATE && VFIO_PCI
> > > > +       help
> > > > +         Support for preserving devices bound to vfio-pci across a=
 Live
> > > > +         Update. The eventual goal is that preserved devices can r=
un
> > > > +         uninterrupted during a Live Update, including DMA to pres=
erved
> > > > +         memory buffers and P2P. However there are many steps stil=
l needed to
> > > > +         achieve this, including:
> > > > +
> > > > +          - Preservation of iommufd files
> > > > +          - Preservation of IOMMU driver state
> > > > +          - Preservation of PCI state (BAR resources, device state=
, ...)
> > > > +          - Preservation of vfio-pci driver state
> > > > +
> > > > +         This option should only be enabled by developers working =
on
> > > > +         implementing this support. Once enough support has landed=
 in the
> > > > +         kernel, this option will no longer be marked EXPERIMENTAL=
.
> > > > +
> > > > +         If you don't know what to do here, say N.
> > > > +
> > >
> > > To use VFIO liveupdate, user has to do at least two things:
> > > 1. Enable CONFIG_LIVEUPDATE
> > > 2. Pass VFIO FD to a live update session.
> > >
> > > This means someone using it has to know what live update is and
> > > intentionally pass the VFIO FDs. Isn't act of doing this itself an
> > > opt-in mechanism?
> >
> > If it is, then I can leave this out. Alex?
> >
> > My thinking was: Distros are free to enable LIVEUPDATE and use it. The
> > support it enables today is all fully functional (albeit new).
> > vfio-cdev, OTOH, is not. A separate Kconfig can help express that
> > difference.
> >
> > Consider that LIVEUPDATE could be enabled by default in a future
> > release, but vfio-cdev support might not be ready yet at that point.
>
> But that also requires point 2 above i.e. userspace explicitly passing
> VFIO FD to liveupdate. Unless there is a capability mechanism like KVM
> then userspace cannot know what is exactly supported.

Yes that is why I propose not exposing the support to userspace at all
until it is ready, by compiling it out of kernel via new Kconfig. This
way it does not get accidentally enabled in distros or downstream
kernels before it is ready.

> Also, users who
> are using these APIs will already be advanced users and have to know
> many details about what liveupdate supports or not.

VMMs will be the ones preserving VFIO cdev files. I think you are
suggesting they should know what versions of Linux support what kind
of preservation? Like QEMU would know that Linux 7.1-7.4 supports
partial VFIO preservation and 7.5+ supports fully? That does not sound
like a good situation to be in.

I think it's much better to hide the support behind Kconfig until its
ready. That way the PRESERVE_FD ioctl just fails on kernels that do
not fully support (because VFIO_PCI_LIVEUPDATE is not enabled), and
succeeds on kernels that do fully support.

If someone wants to enable and use VFIO_PCI_LIVEUPDATE while it is
still marked experimental, they're on their own.

> > > I am not sure providing VFIO_PCI_LIVEUPDATE alleviate Alex's concern
> > > about how userspace will know that sufficient VFIO support exists.
> >
> > I was thinking we can flip VFIO_PCI_LIVEUPDATE to be enabled by
> > default (if LIVEUPDATE and VFIO_PCI are enabled), and drop
> > "(EXPERIMENTAL)" from the option title. That would be how distros and
> > downstream users of the kernel know that sufficient support exists to
> > enable VFIO_PCI_LIVEUPDATE.
> >
> > > May be write in liveupdate documentation (PATCH 11 of this series) th=
at
> > > support is experimental?
> >
> > The documentation in patch 11 includes largely the same text that I
> > put under VFIO_PCI_LIVEU"PDATE. But I can explicitly mention
> > "experimental" as well if that's what you're asking.
>
> Yeah, even though documentation do get stale but I think there is no
> better way in this scenario.

Ok will do.

