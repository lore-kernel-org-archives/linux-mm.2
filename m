Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15478105F7B5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714BC6B0088; Fri, 13 Mar 2026 11:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C23E6B0089; Fri, 13 Mar 2026 11:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEC76B008C; Fri, 13 Mar 2026 11:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE1C6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:39:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06ABB1BCC2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:39:24 +0000 (UTC)
X-FDA: 84541449048.10.1DD42D7
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B7B9180002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:39:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bxGjZFhV;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf16.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773416362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVQdnkFvzB/gHBAeEfjDOu3ipWHlOC3d2TtGMa0Nogc=;
	b=Ga0ADQPBsaykETh0KFfjTQqqSN/4eui+6ZlEOpOBI1AKsAn/2vYOclzFcOPh0f4lVP5J5R
	IIoQFY87m2SplkHn8BDQ2t8qROsB7jUsWSb/I0/xPQYnsPaTwHHro42zrdvYgcaC2wWeKG
	ND2lROwWorxx/LqXZlA2FU9FKBm1/nE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bxGjZFhV;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf16.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773416362; a=rsa-sha256;
	cv=none;
	b=WhlR1TOYMG4x61u0Vtf4hlqT/HGDFHtM5kvQLkj2z4LWRDhBuZPC+ohJtoG47ppsYBAFxq
	I0hqI2ENWyCmJ1tZmSIUosheYr9t3+TsqVDkHPGQG3aBjh5KsPrddID+luhYzL3HlPDtA8
	tqC2eIxFfTbjjnginBUJbWL9AwFyNwI=
Received: from localhost (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id D661420B710C;
	Fri, 13 Mar 2026 08:39:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D661420B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773416360;
	bh=VVQdnkFvzB/gHBAeEfjDOu3ipWHlOC3d2TtGMa0Nogc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bxGjZFhVAxog3QqvD0UQFk4sXHeeQ5NE2qTFN5kayLXjvmuIDnMGr+7++bUo9CucU
	 ozt1v8CCrq0QALAxMV7zkbSKkHJCrii46ijMqsaPNHRiGsN8elmzY4FJG5Ye5XbnF8
	 qQbz/XGG8TzAcfJfbSL0GA/sFnxPqdXJNavH1QSw=
Date: Fri, 13 Mar 2026 08:39:18 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro
 <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, David Rientjes
 <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke
 <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org, Leon Romanovsky
 <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, =?utf-8?Q?Mich?=
 =?utf-8?Q?a=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260313083918.00005731@linux.microsoft.com>
In-Reply-To: <abNOwcOTXqxCxNzt@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
	<20260227084658.3767d801@shazbot.org>
	<CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
	<20260227105720.522ca97f@shazbot.org>
	<CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
	<abNOwcOTXqxCxNzt@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B7B9180002
X-Stat-Signature: onmkr3eeazs95e9ars5yko8j9jtzwtbq
X-Rspam-User: 
X-HE-Tag: 1773416361-845995
X-HE-Meta: U2FsdGVkX1+iCHW08Jlq3kDdsUaSjw6SaSajIP1wd2qFu8bD8FYqKm2R5h22Vhrt1BHruIAM3rUP/t933q6nEJ8njJB1SPbjLguhWgK2tcHuKBl0J8LwF8Gan2ZF1iXUlaYmQ2Ph7w5YcFKGWh2L3AUi10mh+6XImb0ysZElo+mqXGYF72dUJ+0fswjIm7QX85PQqKX6875qJgwrDufwSf+AZLvaGfDaLvA+AzlVpa8P3KySKWethZMJKe/aX8GX9hTXZHaL+DUsuQUxoLKaIbkVR2+ioBwyWa1mThIvkbYFiXTHvkCnbAIO29N33ujqoIjG0n0QdrXl1QTb3mJYZf9WL1vjMnltxOwosBw6f6ZEWSDz0fgiPtj0OoPyKGkvSv+jTBXxPtAzAAiyQTeWSzwiRZMCbfxGvFLdxqo5/Zu5HqiOnse7ZNg1x40hrjpPZX+FsvCHNAIfgzvu6JHnujWaV6pTIkk207ssCJ1VMxRkG8DW9WJinZE7ADVoqzd18loxiMLmg3rwNLqGoEt5vo+z0BRL890fG3G7TVS6DLwVqy+b/fM2cjDmTX7KmHqwTzn+kvtMs9sZJYs1LbL8kY7G9gxQZNk5yHG0gyF3pJ8F7r59t1aXv8magSEO071TOcmmIrRCAOP91BCj+Uyg3l6jk74sSvOW3jZqk664b6o7dJnbmD2Oup1rJK92J+VD3Z4WnKoZLFE7w7VloSSmTyjDLTRM/WQO72OiE7YZn5Yp5yP2rxUmirXhdhoRUfAebfrxECTA0dhADOQ+R5odxRKWkIK4dYUUxTzjcm1qr7a0vVeNHgcGgSeJgGg/wSS7HKCu8t3ZYAn7eA+vnRzg6I+q8QBcEeOlSQEmqiA8ETNNiwHenJXQwJERwvSDz5JykzpAVyH83IKt7Roy8KiUknl7CXsxpEzGGcTXpCQ/ZrvS9XNxQDPeNB8M1uHcdzPxAEC/mPSV17Ft2XrDDmU
 dJtygh6X
 +mra5NMWPhhtBF2D9wKSChvRo6yLiA2dPvcX028Bzu+6vqmzrh+CltoFlV7kNrLOI1uwUmpx3ML+8lP1gzMjyg1+jv2WYPGkBVAauF91d9S3YhXNohv7r1ZfohR1TN0gqUZUWnx/Lw6C4YgymXxje1czqMu4MGDS9Ks6owAMgOmq3+Lf7cUfekOVx9jsuaHojiv6TqkW7mJD64Oaq8HhGOAwgbhnyREoaYTTdE3J5qzjF/99BsyZv7qxy0haP59SqJrwQlcrwi8byofsihTR9h/50ODx/yCH5iv8qr73bHS+1ftU5aYoX1eDCxkVcHnQMGT9wOUV0IA9BbgL/5/Zdy8Acb5NY0hnfzqyE07y0dGPyB8UEqNdP3Rq6zpPfoIn6S5Q+DdR3QvjGJluuby8xSqknlmlC1vxVljGAuS7PrC1xir5t3HvfDQJxEO837oWiQJpd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 12 Mar 2026 23:39:45 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-03-09 10:32 AM, David Matlack wrote:
> > On Fri, Feb 27, 2026 at 9:57=E2=80=AFAM Alex Williamson <alex@shazbot.o=
rg>
> > wrote: =20
>=20
> > > Sorry if I don't have the whole model in my head yet, but is
> > > exposing the restriction to the vfio user of the device
> > > sufficient to manage the liveupdate orchestration?  For example,
> > > a VFIO_DEVICE_INFO_CAP pushes the knowledge to QEMU... what does
> > > QEMU do with that knowledge?  Who imposes the policy decision to
> > > decide what support is sufficient? =20
> >=20
> > Hm.. good questions. I don't think we want userspace inspecting bits
> > exposed by the kernel and trying to infer exactly what's being
> > preserved and whether it's "good enough" to use. And such a UAPI
> > would become tech debt once we finish development, I suspect.
> >=20
> > A better approach would be to hide this support from userspace until
> > we decide it is ready for production use-cases.
> >=20
> > To enable development and testing, we can add an opt-in mechanism =20
>=20
> Here is what I am trending towards sending in v3 as the opt-in
> mechanism:
>=20
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 1e82b44bda1a..770231554221 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
>  config VFIO_PCI_DMABUF
>         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
>=20
> +config VFIO_PCI_LIVEUPDATE
> +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> +       depends on LIVEUPDATE && VFIO_PCI
> +       help
> +         Support for preserving devices bound to vfio-pci across a
> Live
> +         Update. The eventual goal is that preserved devices can run
> +         uninterrupted during a Live Update, including DMA to
> preserved
> +         memory buffers and P2P. However there are many steps still
> needed to
> +         achieve this, including:
> +
> +          - Preservation of iommufd files
> +          - Preservation of IOMMU driver state
In the interim, what do you think about moving forward with noiommu
mode without preserving IOMMU driver state? I=E2=80=99ve tested your
vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works as
expected.

> +          - Preservation of PCI state (BAR resources, device state,
> ...)
> +          - Preservation of vfio-pci driver state
> +
> +         This option should only be enabled by developers working on
> +         implementing this support. Once enough support has landed
> in the
> +         kernel, this option will no longer be marked EXPERIMENTAL.
> +
> +         If you don't know what to do here, say N.
> +
>  source "drivers/vfio/pci/mlx5/Kconfig"
>=20
>  source "drivers/vfio/pci/hisilicon/Kconfig"


