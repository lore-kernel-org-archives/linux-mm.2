Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836F7EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB7E6B0092; Fri,  6 Feb 2026 17:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF4D6B0093; Fri,  6 Feb 2026 17:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDFF16B0096; Fri,  6 Feb 2026 17:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC27C6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:38:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A07E81B275C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:38:03 +0000 (UTC)
X-FDA: 84415496046.02.BC7E1AC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id A5AC94000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:38:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ltabsfcp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770417482; a=rsa-sha256;
	cv=none;
	b=hayYJQaju/qEolQt/r9vbETwzVRfQ2xK92Dh4Dou9YecU9SdC+uXkIwPS3KGojiot5rrLv
	LQQwp6ua36rw6dd6wo2x600PomHJz+nKvDDARKkOi+vVKJG/7qnGgLyCpIO8IsH2zSFEj3
	YjAmN0f8tcZLCPVAmsAWmzK5jN8fWv4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ltabsfcp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770417482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jJ4UYueeYSPKpn5obREQWJr7THiJ5jfhsdhIm5npyc=;
	b=x4kz1PnN497oYExviPdyrAkDqN94l8GRqnW8+2NX7PNXqzpHC+FjIKLpgwEqUSQ7DWaNtp
	kXBii6Z46Zza2yh/JIDjdryPkGRqOCtkIw4zRAFdQbjXpN4KG/dflMNenwXF/L31tVLURG
	aVs662shWtoO4FzjobafXcBamSwcXnM=
Message-ID: <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770417479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jJ4UYueeYSPKpn5obREQWJr7THiJ5jfhsdhIm5npyc=;
	b=LtabsfcpkYYNEXj4rk6UxoAeebNMHH+eAxM6nF6ShkMfYHLDWCU9u7fr+tGWlVOjNlm5Ou
	2OCzSUYh05QKsYDU3hO1T/8obHmFYsBVToWOzWid2CAfWQklQinbky6jUjgvnMC1r7RgMq
	3l//E3MjKtfTYGC+VYr6MkBgsyp5+9w=
Date: Fri, 6 Feb 2026 14:37:45 -0800
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260129212510.967611-5-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A5AC94000F
X-Stat-Signature: 1rxek3iope6747oxq3cgk3neg9bmaf5d
X-HE-Tag: 1770417481-577732
X-HE-Meta: U2FsdGVkX1/FZkSUS4vaGDZ8ozMLPDICMGMv4+Ka/QyT4I1cwyQxwfV8RUV1lJ40r7+KvmRcyZNtlZPFBNXWN5CYHlNAs4O4Mkpx5H4azKyst4BzKH1D9CxNB11RQaLOBuYKmStoNGrHqhtwof4vO8CSDp3EFEJhCtpuP3WsKeSvZFAXAinIzDiAOrgZ3iRDTAu/nGkd+5OcZ9pbUDR/m65WOpx0uKLg8zdoP5P8Std1Q5IjapCqdjxBlG/Jbl+dR+M0dhin4+wJ9L7ZoZmnj/rakNLbdyZk/Ib9soZwEFuZqLdeIi92n95qRazp6L4deYb6Ly7yFaJmHFue7vPYYj9+lhikHV4aFVNbZpPYBC8qDzTDxANxJsGX3hIzDJ+kPG+agU0bBaNDWk/hMxKmxmFTHcTBiJHBDiLqHGvJzAOkmvBH0+M2rLw4o2cbYyneVIF8ArD+1oxrN5awXcRLOW105D/3zjsV+wNXpHbQtU9HK++OfzdYHtTn9fsjHPHlBY+v+CtUeCA8bcU4lBLZqHSHU25IZ4po85a0PN8IvhYKKFRoOFOjRDP5mboTX1hvdEktwnv7M50e4LspaOTtcuvQhEDtIgk37mNHUJixUYMCQcomhh0Uu5f3S8jKTfwGyLBQ20kmSapNVM/Nto4q7DbRwkPkzPazxJ2XzmWAhY6ZxwK3Qg1UnB1C030fVOhCqQbvRn92GBCsgpitBdzaRYb9z6lBm6C7H0Vf4hf9pwUceIx8/5j5Ll5qqzn9V6OoP/OpdCXlyu44pS8dkuhSafm78IFmwj1bs+yENcpub5iQPv44R67Y6K4c6UP9hS6N5UKTq+e/8X5cntssnVvfSv7SdU6L94l4CoZNuZL8RzvH/aBh8S1DFvkXUAPPTcX3VVhufN82xKd0HrS7LRbRYj9BT7nCW95LLb3RR8q0v4o/YPpPCStMfZVxwWYuj77aHDOYLuv4QqggfXdf97A
 nzx0YV0z
 rw5OW0m+K9H6bmCepu1SzaG4h6mxyEHpaT0GY1+3vuLcrQvvDSlK+2g+HimurctyIPktQIBOzNGNBa//w/TJsZWQYMpeNu80/Kc1megMyWBjX6pMGk3F3H6z+sm/FUXf4N8AVHbCr3W2ikNRYrVywUVZQF596aOYLoIf6k3yjrnS0lax5Rs+m2qXmCFTSRlKJs5Buqt2WNXdXt9VA6dcVbJgtvZUvtjLbLHIxEW8LE+ziwdAMcqxqDrL92IsI0LoOZHJg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/29/26 1:24 PM, David Matlack wrote:
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
813 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
814 {
815         struct liveupdate_file_handler *fh_iter;
816         int err;
817
818         if (!liveupdate_enabled())

819                 return -EOPNOTSUPP;

In the function liveupdate_register_file_handler, liveupdate_enabled is also checked.
as such, it is not necessary to check here?

+
+	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+}
+
+void vfio_pci_liveupdate_cleanup(void)
+{
+	if (!liveupdate_enabled())
+		return;
+


ditto

Zhu Yanjun

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

