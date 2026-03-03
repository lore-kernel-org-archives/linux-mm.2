Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A46E67A69
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 06:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05926B0005; Tue,  3 Mar 2026 01:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB38A6B0088; Tue,  3 Mar 2026 01:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95026B0089; Tue,  3 Mar 2026 01:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9B2C6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:22:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A648B73B7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:22:16 +0000 (UTC)
X-FDA: 84503757072.18.88A3E44
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BB951C0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:22:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBFbBJNe;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772518934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXvC0W9BK/qCDM2luuVOjFiw+pG7WQpudbkrpHQ06Bk=;
	b=Hyq4tX9r8AxSSlghFKQ4QuJbRGcR7wZ5RYkHkpwc4LFRe1/uufc0k1Xixic+Rt8khZHf0Y
	tXjiZsOpJVV1F3AuKWWZZ6yxtzbC6MPd3Dx4Hdp773x+f0cljAEWeG9NyeY52ulKE6Rg36
	wdaC1flZ0AjmBcIU4HxJXFR0wq4Ct7w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBFbBJNe;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772518934; a=rsa-sha256;
	cv=none;
	b=8EVTa6QiIrosC8sJpx8kAlHGLo6ahbNieBgolt+rFNEuhzcisGs73XsuKZGWV3TAq5iq/3
	K/9CSok8Iir7jXXdlbcGr5HPOZrhtwf/ML4bVJpRdw6nLjy+DcQ2aiqE6aYtVjKfP5r3PV
	CDbfXmt8hK4x1QxhFRC64aT2V1ITF1w=
Message-ID: <63622051-f128-4450-8579-97f25305beb5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772518931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXvC0W9BK/qCDM2luuVOjFiw+pG7WQpudbkrpHQ06Bk=;
	b=hBFbBJNeRGCjHua0QjXLgz/eHaN8IFODEb3GXPUD8UbMcTeR5gfAlvWl0O3UihX48thOvt
	iQ65ft3idSC9hFOIMyAXX0qKP2XgbVR99CJAnOOkPB00eEHxxmhlfz9pNXQ2DLDcq9edGY
	7UJwXmxf3sVgeP7+cgWF1X5/kjOz/Tk=
Date: Mon, 2 Mar 2026 22:21:55 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260129212510.967611-5-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BB951C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: pb19bt1ynowrp7ogthqnxhty1f9tcuqr
X-HE-Tag: 1772518934-766964
X-HE-Meta: U2FsdGVkX19TVGBt04bE1GzSpzxhEFr3M3j1/FezUO24zv9HbILgfgF00F4dA9o18qvfYfUA6A1LxI/HP+0UgVLAILQBuJofIBUpWDaTmt3OLTHgyKLkz1Phf3fkGBx9SOa5SKVfmHLDgQDpdtTCTWZ0SEZFFE5FZXyVnkjo9wuI2l2fR1WKMZX8PKMMw07D9FQddTMSydph91PIRan4uqK1oe88IcE3Rgan4nTWIYPgAOB9Vf6PXviORqFtak6JH0+ns0R+BuY1Y76LGpAn3vyOpftJ+WmRGDXF+R7M7YCedQ7Lf3sNlBnjbcr+E5KsmzLAnfBSXeBpfdntQFIP785dbQTh+lRkC0zGhVaLpdl1G5r1YRPuyMd/zcVbxRth5UbWCa+ARb2ziookq0+ypae9K9EeewGrhkt9TzNSPiEg+tG1/7gp4XdJ0bYuvQN5gWHeOOHRiQ7+xo+KfgxwFqlI8PxV3keSmUAAqkhz/ZSM5S/UGW8Ym1gRN9r1wI4iYWNIpwIukM9ypb+b+kxUiwLJgKHQ9udufZsNp7y8m/yjXTutFhFyLSIUYMx/wix3+ieAWEpuSp/Zq5tvNChuGJnUJanOORiYwpOw0ZvJFXjqQEmEniXKdw9ZdrMt74CmxC+lg3WUDTQCwMoXhng+Kx0dCxyjlDnyA50paKAejgWp5fQa+WVAel3yvkaCz4V1SKsdBBd6JjIT39MQhBFr2ae1u2N/I7w3sAmSKxyaSOLhlG6547cQUog7ARmXpOIDu+bGFpUybuqpRY1so8O/Q6N2YvTuCaJeTEmuSGUiXVobbLlSXB1vuzpxLTxAaTFkhJfzbWErIBnM+czrneMKhzWk0rzSYd7zzOz7aGrxbodQqNpyx3Q42hq98Pkx7wPe1bp+ddUdhf7MiMktD7PTaR6h76kCoPqRtwhyj4c0yur9IfgyMa50FiEoB7100udXaYps/hNR3KEC4HFuRVo
 RIszuMBG
 o602xxPW5BQ3KqlAi5JVjgvbfxHIjJwvwiREe/208vn7BLgkg4wVsjP2qTc0j5JEnu4dkXmT/XZYV52t17OU3nVVfZstAXIdAlKoHeT0H6e2Pi84P3oBdjxlAe53jAl/KPZ/0sa2CJ9eBmEKNLSh71RzeDwQ8C0qCVqLzS7ylim0PzWlMuXdfqaBCMWp1A/DmJaZNqM1XTC3l5uFQDgNHEBP55G8P2o72E+TzBPwYJ+ORYiWj9Vf/VPuP5za5zbJhz/4e/bijoXThIJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/29 13:24, David Matlack 写道:
> From: Vipin Sharma <vipinsh@google.com>
>
> Register a live update file handler for vfio-pci device files. Add stub
> implementations of all required callbacks so that registration does not
> fail (i.e. to avoid breaking git-bisect).
>
> This file handler will be extended in subsequent commits to enable a
> device bound to vfio-pci to run without interruption while the host is
> going through a kexec Live Update.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   MAINTAINERS                            |  1 +
>   drivers/vfio/pci/Makefile              |  1 +
>   drivers/vfio/pci/vfio_pci.c            |  9 +++-
>   drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
>   include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
>   6 files changed, 121 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
>   create mode 100644 include/linux/kho/abi/vfio_pci.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a671e3d4e8be..7d6cdecedb05 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27520,6 +27520,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
>   F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
>   F:	Documentation/driver-api/vfio.rst
>   F:	drivers/vfio/
> +F:	include/linux/kho/abi/vfio_pci.h
>   F:	include/linux/vfio.h
>   F:	include/linux/vfio_pci_core.h
>   F:	include/uapi/linux/vfio.h
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index e0a0757dd1d2..23305ebc418b 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>   
>   vfio-pci-y := vfio_pci.o
>   vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> +vfio-pci-$(CONFIG_LIVEUPDATE) += vfio_pci_liveupdate.o
>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>   
>   obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0c771064c0b8..19e88322af2c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
>   	int ret;
>   	bool is_disable_vga = true;
>   
> +	ret = vfio_pci_liveupdate_init();
> +	if (ret)
> +		return ret;
> +
>   #ifdef CONFIG_VFIO_PCI_VGA
>   	is_disable_vga = disable_vga;
>   #endif
> @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
>   
>   	/* Register and scan for devices */
>   	ret = pci_register_driver(&vfio_pci_driver);
> -	if (ret)
> +	if (ret) {
> +		vfio_pci_liveupdate_cleanup();
>   		return ret;
> +	}
>   
>   	vfio_pci_fill_ids();
>   
> @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
>   static void __exit vfio_pci_cleanup(void)
>   {
>   	pci_unregister_driver(&vfio_pci_driver);
> +	vfio_pci_liveupdate_cleanup();
>   }
>   module_exit(vfio_pci_cleanup);
>   
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> new file mode 100644
> index 000000000000..b84e63c0357b
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2025, Google LLC.

The live update support for vfio-pci was initiated in 2025, but 
developments are into 2026. Update the copyright to 2026 or 2025 - 2026.

Zhu Yanjun

> + * Vipin Sharma <vipinsh@google.com>
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kho/abi/vfio_pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/errno.h>
> +
> +#include "vfio_pci_priv.h"
> +
> +static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> +					     struct file *file)
> +{
> +	return false;
> +}
> +
> +static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> +	.preserve = vfio_pci_liveupdate_preserve,
> +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.finish = vfio_pci_liveupdate_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> +	.ops = &vfio_pci_liveupdate_file_ops,
> +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> +};
> +
> +int __init vfio_pci_liveupdate_init(void)
> +{
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +}
> +
> +void vfio_pci_liveupdate_cleanup(void)
> +{
> +	if (!liveupdate_enabled())
> +		return;
> +
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +}
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 27ac280f00b9..68966ec64e51 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
>   }
>   #endif
>   
> +#ifdef CONFIG_LIVEUPDATE
> +int __init vfio_pci_liveupdate_init(void);
> +void vfio_pci_liveupdate_cleanup(void);
> +#else
> +static inline int vfio_pci_liveupdate_init(void)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_pci_liveupdate_cleanup(void)
> +{
> +}
> +#endif /* CONFIG_LIVEUPDATE */
> +
>   #endif
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> new file mode 100644
> index 000000000000..37a845eed972
> --- /dev/null
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * Vipin Sharma <vipinsh@google.com>
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> +#define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> +
> +/**
> + * DOC: VFIO PCI Live Update ABI
> + *
> + * This header defines the ABI for preserving the state of a VFIO PCI device
> + * files across a kexec reboot using LUO.
> + *
> + * Device metadata is serialized into memory which is then handed to the next
> + * kernel via KHO.
> + *
> + * This interface is a contract. Any modification to any of the serialization
> + * structs defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the VFIO_PCI_LUO_FH_COMPATIBLE string.
> + */
> +
> +#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
> +
> +#endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */

-- 
Best Regards,
Yanjun.Zhu


