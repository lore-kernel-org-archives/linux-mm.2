Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF74D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C6B6B00AA; Thu, 29 Jan 2026 17:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0E56B00AC; Thu, 29 Jan 2026 17:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E1E6B00AD; Thu, 29 Jan 2026 17:22:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 213CC6B00AA
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:22:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ADC2C1AE8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:22:04 +0000 (UTC)
X-FDA: 84386425368.25.3470DBD
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id A470616000F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:22:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=JFbmvvQb;
	spf=pass (imf08.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769725322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l69U1dIrB2ccHzImzegm889MzCj0l8Bz/N1WHXvfoHo=;
	b=yqAOiVqyUVjHxbmmCmQoHG3TdHaJQdwDw9zhZ+n2QPqVqKpnHywWzvdB+RcM03VvmZPSgj
	76t4pkt0MCpv/XOn3Cf2CJ0TfKzIzIYCilx5wr+Gy3pOdCvuQVAv0Uo3PgMYT9OsvnOSNA
	jpvFpzga1hhpvLPQ5TNwvSSku/TvsSw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=JFbmvvQb;
	spf=pass (imf08.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769725322; a=rsa-sha256;
	cv=none;
	b=Nrvgyfpi1y4wM14IGoYvOfMn3sTCxFOr77hlKNdUhdoBkvLREUzsZvNfD82UwdTXYTFtWL
	MoU+15g7qviCedRP2r7aRLf5tlCNdAdcWIj/3l2nNtvFfo2xvd8YNGlY9G7O8NRF25+epm
	5TjysXrgeBwN9U33YO/yAvr/A5NHQQw=
Received: from localhost (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5D12120B7168;
	Thu, 29 Jan 2026 14:22:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D12120B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769725321;
	bh=l69U1dIrB2ccHzImzegm889MzCj0l8Bz/N1WHXvfoHo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JFbmvvQbSZuWgKtGygvkszx2JeEWdtJpgkKy9JrbMd/Wd5/9p+qh8F8DQZUL3TZRu
	 2F9IotVi63Q1+5xtXPAj5Z5VpgM5SnxXvlYLMhpARcjtNuquJ02rdkhqPezl4x+bzG
	 YQ4Gy7p2dGglcG8jvPE5kn+665aOMwS0WLDY/OxQ=
Date: Thu, 29 Jan 2026 14:21:58 -0800
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
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, "=?UTF-8?Q?Mic?=
 =?UTF-8?Q?ha=C5=82?= Winiarski" <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, "Thomas =?UTF-8?Q?Hellstr=C3=B6m?="
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260129142158.00004cdc@linux.microsoft.com>
In-Reply-To: <20260129212510.967611-11-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A470616000F
X-Stat-Signature: wpnu4w9qni1q3fxdxrkeuknbgkhqshi9
X-Rspam-User: 
X-HE-Tag: 1769725322-401480
X-HE-Meta: U2FsdGVkX18jMxz4PLQj7T60z2g3fiuT4J0lp1UX2KMl/TQQAaAC2ZFi9V44j6pOSWsTW5z8e+0iZoW0XqbgVTKIkg3U//SNxlKRUfzqHXvJoSUinnt/8kfsPmGw4xQ9ehI029sIQyVuj3tr96kTZ7S6xKqZrQkj+pf4ZlYoIR/Jht7ij4LacOg1/IOkaF0KjPB2QjhoN3hESeOlqF5t2wtKfZaeyvU8hXHZv2ruZO4+EfD/fejMUHBglQi8RlYe9BwoLsxP/01cQfw63WSs4sEwQ4i7hez5Ytt5Wns2YHc1969QRQUqRTkOThXL/vkAepl99h7sgZNmPN55bKNE1Jbi4FsZJdYYtIfD9iwawmhpgEM8ccwx92f7FLahUCeJ1NhwBK78Zn5FOassLpOC+AWwmHwduPlWhRoUS4Gu5hOkRCSvrGqedIEuRDpjadxBTFljDiDXs/GzI9YQq4EhPcOGXN1xO4UGUCNCHpe6Gak8H5iecbZymqJIRaqXzk75jUCBupqDAWQj2iJc4DjWqy8IFUSZGSTThZViw2myIZz7qegXMQbHLaBeeQqkWcbbj3yFpUq/qlC8I7DWRr7N7oDppO40NtQuZEKHZ7iZDTKAxGWFnyKDSLZTPpbkDjPvEBbFYm0YUYjtFnOLK/QkgQzE5cGirTbkU1+ASrL5m7voHGsXRBkXVNMnM+LVDluLLN1h+L0OFkl4t6xchb/IZTvN7K/YQEe3i4cIeQo+SJJLnYiz0H6i0u3hoq33puZS8WmYg1VO91FsFoyMoOR9gzQJhZiXvOXHVu+DPenmRxtWccHfBJDs4JCWoTWH2qHxshiqpnDEkRnY0dnDrKpPrqz7iYosv7QxrVoI6w2bxb+6VSKxyVrsxXzs/E44c+V17T49gOlAaqsmM1bpCH+zbrbYOLZTynhZFogWXzAfILO5IpmCeCZTud7o2+6HXQ7Sea32xSGaQTGd7pkENYb
 G+qEcvaJ
 DTLBPUS/XGebKv+M5EzCODRxof2OwWggJdEKXJUF0+TWx70sFuoIQWfk4CfdRCF6sjEG8sTegynuhRJ2libRFovIf9MYtYQtAu6O7wRC0drG58jMvutwgrPxPsOOmZH5eVvbiFjTQy+aSr9q9jg59aYpcAbey6U48hBdEYVlZBRFVRJ7oJ5YgF53jAbPaPsMH8n4NtiwDi2gRctdu3++mn+dah8+DxWGNNYcqU3CEerIr1p8zCnhPuPF1LCYhFWld6UgpKAQOFY9olc+440NlKpjTkeIy3izRYA8ar5XZRf4bpdzNq278/q9kZtL5tKrFdsxW3tnlK6euQn6rEyvchhjtVmZ1ueLOBD6DhNOc9lZT3dRCxefimSyA0weHJL6oK9K2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 29 Jan 2026 21:24:57 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
>=20
> Do not reset the device when a Live Update preserved vfio-pci device
> is retrieved and first enabled. vfio_pci_liveupdate_freeze()
> guarantees the device is reset prior to Live Update, so there's no
> reason to reset it again after Live Update.
>=20
> Since VFIO normally uses the initial reset to detect if the device
> supports function resets, pass that from the previous kernel via
> struct vfio_pci_core_dev_ser.
>=20
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       | 22 +++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_liveupdate.c |  1 +
>  include/linux/kho/abi/vfio_pci.h       |  2 ++
>  include/linux/vfio_pci_core.h          |  1 +
>  4 files changed, 21 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c index b01b94d81e28..c9f73f597797
> 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct
> vfio_pci_core_device *vdev) if (ret)
>  		goto out_power;
> =20
> -	/* If reset fails because of the device lock, fail this path
> entirely */
> -	ret =3D pci_try_reset_function(pdev);
> -	if (ret =3D=3D -EAGAIN)
> -		goto out_disable_device;
> +	if (vdev->liveupdate_incoming_state) {
> +		/*
> +		 * This device was preserved by the previous kernel
> across a
> +		 * Live Update, so it does not need to be reset.
> +		 */
> +		vdev->reset_works =3D
> vdev->liveupdate_incoming_state->reset_works;
Just wondering what happened to skipping the bus master clearing. I
understand this version does not preserve the device itself yet; I=E2=80=99m
just curious whether there were specific difficulties that led to
dropping the earlier patch which skipped clearing bus master.

> +	} else {
> +		/*
> +		 * If reset fails because of the device lock, fail
> this path
> +		 * entirely.
> +		 */
> +		ret =3D pci_try_reset_function(pdev);
> +		if (ret =3D=3D -EAGAIN)
> +			goto out_disable_device;
> +
> +		vdev->reset_works =3D !ret;
> +	}
> =20
> -	vdev->reset_works =3D !ret;
>  	pci_save_state(pdev);
>  	vdev->pci_saved_state =3D pci_store_saved_state(pdev);
>  	if (!vdev->pci_saved_state)
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c
> b/drivers/vfio/pci/vfio_pci_liveupdate.c index
> 1ad7379c70c4..c52d6bdb455f 100644 ---
> a/drivers/vfio/pci/vfio_pci_liveupdate.c +++
> b/drivers/vfio/pci/vfio_pci_liveupdate.c @@ -57,6 +57,7 @@ static int
> vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)=20
>  	ser->bdf =3D pci_dev_id(pdev);
>  	ser->domain =3D pci_domain_nr(pdev->bus);
> +	ser->reset_works =3D vdev->reset_works;
> =20
>  	args->serialized_data =3D virt_to_phys(ser);
>  	return 0;
> diff --git a/include/linux/kho/abi/vfio_pci.h
> b/include/linux/kho/abi/vfio_pci.h index 9bf58a2f3820..6c3d3c6dfc09
> 100644 --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -34,10 +34,12 @@
>   *
>   * @bdf: The device's PCI bus, device, and function number.
>   * @domain: The device's PCI domain number (segment).
> + * @reset_works: Non-zero if the device supports function resets.
>   */
>  struct vfio_pci_core_device_ser {
>  	u16 bdf;
>  	u16 domain;
> +	u8 reset_works;
>  } __packed;
> =20
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> diff --git a/include/linux/vfio_pci_core.h
> b/include/linux/vfio_pci_core.h index 350c30f84a13..95835298e29e
> 100644 --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/kho/abi/vfio_pci.h>
> =20
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H


