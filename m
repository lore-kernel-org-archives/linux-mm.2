Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621C8FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869E66B0088; Mon, 27 Apr 2026 16:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A9A6B008A; Mon, 27 Apr 2026 16:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730D46B008C; Mon, 27 Apr 2026 16:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF296B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:56:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13C0A1A01CA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:56:32 +0000 (UTC)
X-FDA: 84705544224.09.C9DCAB1
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 219D480011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:56:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=g3klIaNv;
	spf=pass (imf30.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777323390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4+T1q5j1gjl12AzNykoZ9kgKNsM0AyLqJTGq2x4mJw=;
	b=MOHmt4I3k+yjN/68d32IoAHyTBPttUyXIQ0MdI4+s8zPX75x/8NPYy1LoFSpMPYhqQ+00g
	HihsII1WFDnhQC+pB5bxUE+HN6vDvnU6LMBG6QIA6FA/0Jhb0wpLJAaPbflk1rqzP5o1js
	DVidwQTUM5tAlRkdmqufg11lDNTTxVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777323390; a=rsa-sha256;
	cv=none;
	b=sBjN4IlqwabbdaP86mQvSuB/oxcqcqaS7Pffm2nAUfbdAHumZ2JcQvN+sCct8/rOTofLtw
	Z3d1iur6a4C/URBqwW0tEUfdGPrckcICzeTbtMDOlVBStrAUlXhROK5M6sgjqgbzBWjKxo
	bzjcwLaceVMVxEThC2/3NmFSIbtblHs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=g3klIaNv;
	spf=pass (imf30.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from localhost (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 80A2820B716A;
	Mon, 27 Apr 2026 13:56:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 80A2820B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777323389;
	bh=w4+T1q5j1gjl12AzNykoZ9kgKNsM0AyLqJTGq2x4mJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g3klIaNv0aZDwiuY6aSr9d1ovw1UNaC1yS0v955Li3fu510xl6luT8FxEwoEqgsV9
	 qO5XgODem35nBKQSBw1Y/oPQwo73ezTIvaKLd6m9LDkmCPmXDtkuNmar6v6P8E4uZZ
	 NJTPwgA90pNAQX3lXJdDUBe1VtE8QmuErhznSO4I=
Date: Mon, 27 Apr 2026 13:56:25 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex
 Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris
 Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet
 <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky
 <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja
 <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, Will Deacon
 <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, jacob.pan@linux.microsoft.com
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
Message-ID: <20260427135625.0000413e@linux.microsoft.com>
In-Reply-To: <20260423212316.3431746-9-dmatlack@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
	<20260423212316.3431746-9-dmatlack@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 219D480011
X-Stat-Signature: bdih5jo9a8fipox9my38phuyhf171ky8
X-Rspam-User: 
X-HE-Tag: 1777323389-226082
X-HE-Meta: U2FsdGVkX1/jgHVR0fk/CykeM0h5Mm6kOiRt8MVkOvk+rKhOO1FFpOvaUk8rJ2sgUu4ypbyVVoFtfVDr1pK6lZNv9QGxdouVF74UBrwg6bIl/KCiVxuNi6MXUKJtWRGb2agwXRcFbd6CU+JYUYPBmNnnn77hj4YLNykPuNXE1+imOQeKr8SSkLiWdrl61hRjSAeyk3mqNfpxI+cfe5086CGYb0kCOYdb6B9+vUOV9COYNCtym1PFKXtcHQExKfMhkYXDnKr4eLsm0xMBsb+EyyCQTvHyUUxV6FtkZgy10JqrJ9MtHJIGXDd1BiVDnazpHSx3sGBLaJ34X0jruft9tRihjo/qDlVMUUAyxl6OpSIDnCgm6NA4tBZ/8cbuIc8ym7cKtrgPkM3wv8nvCe42wsKZ6Dp4qHwVZArVrB6To0DrSZem3t4RJXHB16PYHesiDEHsfdMk9pfOLjaERuzCjjs2rWSNy32cfngYdl4p3GoascEoUPLJmbJKciYhF9N+nP8kaOeSkQQIC7ExnhX66UXWQfhKR1zja3Ey+LtaB67osgWv2/272YJzY3OMGHtlLNdWrDJX3gp/A84ybOYuerVRclirvw71hsJIksTv/keANv7LDD67vdHwnJBcBUvcmUN6fqpNJZmHUvSBEJSAIBAaqQezHJzIzQJ8MogGFsmigcqfd7YCgpJUxrXKy5foSO8rJdxeavf3HS3GJUOAyStUWYZXtUxFITYVHIF9wbqLLMvGbcpzAIlQm9ft3i+S45O6wSfKpwBdX5p3vyLpLZ+wY3G8jnYEXS14jfa/pgTWEaFk+/NjobQTsxFD/liDu756LWSQnwaeTm/f4VjLE/pF06zbALB7SMqLI5e9YH1wVK4eg/iSvaQ5pCPv5nmwVfU0ycTuwmpzWREHRSJUHmgccdIcPABmmZp3LYhl0x8/DlL6uY/vcxd2Wu7p0mvlwo5Xvw0sQ1yaRy4iDT5
 M18zFgrY
 lJGJTAmTagBQ+pE0bFNRP9O2X39R2DwdfkZeQT33H8ZdNWPwhi5UxQfo6nhu2G+ozrv9a2acQwqxzJQkY1xt62TsuxpSnYhao6fs555XKj01N9SECMPLI05DK3lahCvg2qkaHeMGJ+B5cw4Zb5zECU6ry+SLEG9H4a9rFRV154d1sjpuU7t8SIwlOQUf/bFTY+VwBolfeDq4c7Ce7C7u8IYyNr2Nnk8VQEwvlIe4RQW3odj9c6oKwYDCL2SZf39kLOHPsApoLwzClz42mS7RwprVZIoKAPsOMPjeNUV2j8zh/pkKG4WZEDpmb+tgDmjwWObaEdInzflQbYutgLeVpKzwtWy6eGE5EuYbEgr16Jurk9duu7bAi3RRD57+PjjVGdiJ0+V7D8ORkJYj2b7jNqdMkyQAfk9+LP7pYtAS3p1ZzUjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 23 Apr 2026 21:23:12 +0000
David Matlack <dmatlack@google.com> wrote:

> Restrict support for preserving PCI devices across Live Update to
> devices in immutable singleton IOMMU groups. A device's group is
> considered immutable if all bridges upstream from the device up to the
> root port have the required ACS features enabled.
> 
> Since ACS flags are inherited across a Live Update for preserved
> devices and all the way up to the root port, the preserved device
> should be in a singleton IOMMU group after kexec in the new kernel.
> 
> This change should still permit all the current use-cases for PCI
> device preservation across Live Update, since it is intended to be
> used in Cloud enviroments which should have the required ACS features
> enabled for virtualization purposes.
> 
> If a device is part of a multi-device IOMMU group, preserving it will
> now fail with an error. This restriction may be lifted in the future
> if support for preserving multi-device groups is desired.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/iommu/iommu.c    | 35 +++++++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.c |  6 ++++++
>  include/linux/iommu.h    |  7 +++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 61c12ba78206..782e73a9d45f 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1664,6 +1664,41 @@ struct iommu_group *pci_device_group(struct
> device *dev) }
>  EXPORT_SYMBOL_GPL(pci_device_group);
>  
> +bool pci_device_group_immutable_singleton(struct pci_dev *dev)
> +{
> +	struct iommu_group *group;
> +	struct group_device *d;
> +	struct pci_bus *bus;
> +	int nr_devices = 0;
> +
> +	group = iommu_group_get(&dev->dev);
> +	if (!group)
> +		return false;
This may not work for noiommu mode where we could have a null group.
Maybe I can add special case later?

> +	mutex_lock(&group->mutex);
> +
> +	for_each_group_device(group, d)
> +		nr_devices++;
> +
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
nit:
	scoped_guard(mutex, &group->mutex) {
        	for_each_group_device(group, d)
                	nr_devices++;
 	}
> +
> +	if (nr_devices != 1)
> +		return false;
> +
> +	for (bus = dev->bus; !pci_is_root_bus(bus); bus =
> bus->parent) {
> +		if (!bus->self)
> +			continue;
> +
> +		if (!pci_acs_path_enabled(bus->self, NULL,
> REQ_ACS_FLAGS))
> +			return false;
> +
> +		break;
> +	}
> +
> +	return true;
> +}
> +
>  /* Get the IOMMU group for device on fsl-mc bus */
>  struct iommu_group *fsl_mc_device_group(struct device *dev)
>  {
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a9a89f7bd3e5..54a90ff02bdd 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -133,6 +133,7 @@
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
>  
>  #include <linux/io.h>
> +#include <linux/iommu.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/pci.h>
>  #include <linux/liveupdate.h>
> @@ -359,6 +360,11 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
>  	if (dev->is_virtfn)
>  		return -EINVAL;
>  
> +	if (!pci_device_group_immutable_singleton(dev)) {
> +		pci_warn(dev, "Device preservation limited to
> immutable singleton iommu groups\n");
> +		return -EINVAL;
> +	}
> +
>  	if (dev->liveupdate_outgoing)
>  		return -EBUSY;
>  
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index e587d4ac4d33..6f5d1dec3f89 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1096,6 +1096,8 @@ extern struct iommu_group
> *generic_device_group(struct device *dev); struct iommu_group
> *fsl_mc_device_group(struct device *dev); extern struct iommu_group
> *generic_single_device_group(struct device *dev); 
> +bool pci_device_group_immutable_singleton(struct pci_dev *dev);
> +
>  /**
>   * struct iommu_fwspec - per-device IOMMU instance data
>   * @iommu_fwnode: firmware handle for this device's IOMMU
> @@ -1528,6 +1530,11 @@ static inline int
> pci_dev_reset_iommu_prepare(struct pci_dev *pdev) static inline void
> pci_dev_reset_iommu_done(struct pci_dev *pdev) {
>  }
> +
> +static inline bool pci_device_group_immutable_singleton(struct
> pci_dev *dev) +{
> +	return false;
> +}
>  #endif /* CONFIG_IOMMU_API */
>  
>  #ifdef CONFIG_IRQ_MSI_IOMMU


