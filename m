Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E5AFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531566B008A; Mon, 27 Apr 2026 12:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB466B008C; Mon, 27 Apr 2026 12:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382FA6B0092; Mon, 27 Apr 2026 12:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21D926B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:01:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C8C89F7AE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:57:32 +0000 (UTC)
X-FDA: 84704790786.07.F18B16B
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 476331C0018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:57:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=OhQoS5cT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf20.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777305450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LeH8B86nKcZOpLZaBsejYDxB8jSKUcx+rF/bpcYhS4=;
	b=BiSjkexmB55az6PFUa/3l8NEvJQef18BM9Jjw27kVrGQpf1PqPAcNx6xongilXlIxQV4zl
	HjCibjdVitxS/8TzKRxSRc+RBrOdYYBuALHsutgiTcQb/fF9TJqDRbPfQsyTNLJSA4Edoh
	lpoeGre0W7iIxgAZyWbVLDBebrz+NxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777305450; a=rsa-sha256;
	cv=none;
	b=wtPZ5F5TdfFqYBLVyceA9PZiEiuK9F+kU0tnYFBDuFmubsLjn7+khIU5qNu9pDobMK8T31
	xu28Vutd/WsdtuzWRDSZIlWDfc7mir9sm6q+y+DYP18wBv3b8zBxqr8BUi/xMKGbUwgp3B
	WX4iqmFkl6/8avSafZGK36HC1ygx0Sc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=OhQoS5cT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf20.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com
Received: from localhost (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id D338920B716A;
	Mon, 27 Apr 2026 08:57:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D338920B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777305448;
	bh=9LeH8B86nKcZOpLZaBsejYDxB8jSKUcx+rF/bpcYhS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OhQoS5cTppvzXia529YlPHyl3gEpjLWlCpqEjC0wytPu1aoMn+auy5b+Twna7AZOq
	 Lvng4260i2n0yzHjGfSp5eYpSAvQTyiXS2IYISChFXvH/uD1Pd2GiYxD6n9fpiMfwn
	 a+1mc9wLudzyJ4EU5tC+TsVbZknBuN1SpzNpVqY8=
Date: Mon, 27 Apr 2026 08:57:25 -0700
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
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260427085725.00005283@linux.microsoft.com>
In-Reply-To: <20260423212316.3431746-3-dmatlack@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
	<20260423212316.3431746-3-dmatlack@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 476331C0018
X-Stat-Signature: us4uspjp5tiozwtuhnssg6ikcdtbwdjt
X-Rspam-User: 
X-HE-Tag: 1777305450-980331
X-HE-Meta: U2FsdGVkX1/Ny6ouWxOAQwvuo4UHVJ5YoebpQqmbseaqQ+ZRXGTs+eNDkXMs6AFVJi5EerXk0VOjSqNbN8X7MYOIc6iwvVyH2UbbSybXscSgeGEOUbBlb4CGaO1fhf8B7PcEoRBEYOAH2jdV62StFb086yvETxLZ4yacyGYcmXjXcTGe+PI+Ey0VTxSdlIV6HNYThRClyClBvxxhTQJIf7mocRm9+5qp/hAW3VUlTT17sODvJq13B79KnAGnNM3oQLZ/j1vriQBgzTB55ZZ5vkqXIjzD+T8TT7z1n2+nAcpM1wZ+5y3BlJLbsFm8uJsP2fF+IybxHaTuXv4TiZzZC1/svjJvZbGho832VVs4fzj9lkpSI/HD4lPGnnIdM+SKZbRWeR3RBCNVItl6YG02hTKUQLsZFPizq9CdX3d69jDOY7eBhvOQZh1DTxA5kSqpDt19LjJ1aSINr60tt6ser5pfkMc61U4GWzLdD4u7UX6B2SjNiWnNG0MvCVem26jDDNaMMmh5z5ng36RzeVncHr8kFQAxYY68+cOApJgaFJNBgwhEGBhA6q96QeAyz88N4fCzq3BJfUQAbKaxOc1K4bKpVm5XFNwHekRLyQX3KsDMe6o04UiciwmrtGpYYbQ8SDV+nniBxD8IIoA97sVvM2u873JFwDPP8ymRjMTDPolvbFJwf1p8jKwlKdgk7bEWJlB46Q00RtTrLPeIf9mZiSOZ+9exxwsU8ZothWEuFqzmBMDw7uhDzg/4wf6X93vfcq/Vjnrpf1aTtvdfYn6w1YaMINZZNE0xl7OjzkMLCmyn2swLBhYlgPiN3KsogsNwiIK3k5b0kY0hzyPnnChrmpOSrEg/oJVk4B5aTda7vKLbqoVQcGq/cf5wwbyGQ9Mp2AszNYIeXmvmqXI7aZFXI76YIGN3VapwQqUjelsXWedxoW2/CFE+KzoSJVyYWCefK7BfPQDXemGHSTSiaKn
 zXm7hNIS
 3XgdDbbcaWXGrpQ4FR8hODp7cCQNHEvvBkpiY7aUQ+ohK4g3tqKZrRkKptFW2EJLuOhuhdGkQateESm+57uKMaqbmFwWL3M4gJ5QBayq+snnvoKHR8v0PQI+pFla8LOhT0DBZKQrWRFmLU9hkiOhhJa7FStREEkdAmyauUZJYZIml16w9YfI+NSZhRFJtPVsBUi4SrFeWCV0ZQjrsJPmc5afTnU6Pe9kHSD63zqme1Cf3GvQD1eml0ZO25YRCr0FJrRxHJTMEXeeAHO0CHsNz5w/bTY64ZCWw7ve+rxvCETcaGV8W+fcRIIF+S6CuHXS3xzzYplm3SMY15yaO42wQhMhOP+rY7sRyjZo/4oZBK3K+RH4wFuuCXOth1N8Voxgim6Rowp7GL9y/jfuOxvC1i/+6CpLERBVvH9Ek+CdP6RAHGys0A7tdn70aMsrE+M9tjKmeZJ8QLpgwNUCe99Jq2idYDQfATO+aD+zX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 23 Apr 2026 21:23:06 +0000
David Matlack <dmatlack@google.com> wrote:

> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.
> 
> Drivers must notify the PCI core when devices are preserved so that
> the PCI core can update its FLB data (struct pci_ser) and track the
> list of outgoing devices. pci_liveupdate_preserve() notifies the PCI
> core that a device must be preserved across Live Update.
> pci_liveupdate_unpreserve() reverses this (cancels the preservation
> of the device).
> 
> This tracking ensures the PCI core is fully aware of which devices may
> need special handling during shutdown and kexec, and so that it can be
> handed off to the next kernel.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c    | 101
> ++++++++++++++++++++++++++++++++++++ include/linux/kho/abi/pci.h |
> 7 +-- include/linux/pci.h         |  26 ++++++++++
>  3 files changed, 131 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index d4fa61625d56..2dd8daa2f17c 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -43,6 +43,26 @@
>   *
>   *  * ``pci_liveupdate_register_flb(driver_file_handler)``
>   *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
> + *
> + * Device Tracking
> + * ===============
> + *
> + * Drivers must notify the PCI core when specific devices are
> preserved or
> + * unpreserved with the following APIs:
> + *
> + *  * ``pci_liveupdate_preserve(pci_dev)``
> + *  * ``pci_liveupdate_unpreserve(pci_dev)``
> + *
> + * This allows the PCI core to keep it's FLB data (struct pci_ser)
> up to date
> + * with the list of **outgoing** preserved devices for the next
> kernel.
> + *
> + * Restrictions
> + * ============
> + *
> + * The PCI core enforces the following restrictions on which devices
> can be
> + * preserved. These may be relaxed in the future:
> + *
> + *  * The device cannot be a Virtual Function (VF).
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -57,6 +77,8 @@
>  #include <linux/pci.h>
>  #include <linux/sort.h>
>  
> +static DEFINE_MUTEX(pci_flb_outgoing_lock);
> +
>  static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>  {
>  	struct pci_dev *dev = NULL;
> @@ -124,6 +146,85 @@ static struct liveupdate_flb pci_liveupdate_flb
> = { .compatible = PCI_LUO_FLB_COMPATIBLE,
>  };
>  
> +int pci_liveupdate_preserve(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int i, ret;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void
> **)&ser);
> +	if (ret)
> +		return ret;
> +
> +	if (!ser)
> +		return -ENOENT;
> +
> +	if (dev->is_virtfn)
> +		return -EINVAL;
This can be left outside the mutex?

> +
> +	if (dev->liveupdate_outgoing)
> +		return -EBUSY;
> +
> +	if (ser->nr_devices == ser->max_nr_devices)
> +		return -ENOSPC;
> +
> +	for (i = 0; i < ser->max_nr_devices; i++) {
> +		/*
> +		 * Start searching at index ser->nr_devices. This
> should result
> +		 * in a constant time search under expected
> conditions (devices
> +		 * are not getting unpreserved).
> +		 */
> +		int index = (ser->nr_devices + i) %
> ser->max_nr_devices;
> +		struct pci_dev_ser *dev_ser = &ser->devices[index];
> +
> +		if (dev_ser->refcount)
> +			continue;
> +
> +		pci_info(dev, "Device will be preserved across next
> Live Update\n");
> +		ser->nr_devices++;
> +
> +		dev_ser->domain = pci_domain_nr(dev->bus);
> +		dev_ser->bdf = pci_dev_id(dev);
> +		dev_ser->refcount = 1;
> +
> +		dev->liveupdate_outgoing = dev_ser;
> +		return 0;
> +	}
> +
> +	return -ENOSPC;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
> +
> +void pci_liveupdate_unpreserve(struct pci_dev *dev)
> +{
> +	struct pci_dev_ser *dev_ser;
> +	struct pci_ser *ser = NULL;
> +	int ret;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void
> **)&ser); +
> +	if (ret || !ser) {
> +		pci_warn(dev, "Cannot unpreserve device without
> outgoing Live Update state\n");
> +		return;
> +
> +	}
> +
> +	dev_ser = dev->liveupdate_outgoing;
> +	if (!dev_ser) {
> +		pci_warn(dev, "Cannot unpreserve device that is not
> preserved\n");
> +		return;
> +	}
> +
> +	pci_info(dev, "Device will no longer be preserved across
> next Live Update\n");
> +	ser->nr_devices--;
> +	memset(dev_ser, 0, sizeof(*dev_ser));
> +	dev->liveupdate_outgoing = NULL;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> +
>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
>  {
>  	pr_debug("Registering file handler \"%s\"\n",
> fh->compatible); diff --git a/include/linux/kho/abi/pci.h
> b/include/linux/kho/abi/pci.h index 5c0e92588c00..5b4c8d9e462c 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -23,19 +23,20 @@
>   * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE
> string. */
>  
> -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
>  
>  /**
>   * struct pci_dev_ser - Serialized state about a single PCI device.
>   *
>   * @domain: The device's PCI domain number (segment).
>   * @bdf: The device's PCI bus, device, and function number.
> - * @reserved: Reserved (to naturally align struct pci_dev_ser).
> + * @refcount: Reference count used by the PCI core to keep track of
> whether it
> + *            is done using a device's struct pci_dev_ser.
>   */
>  struct pci_dev_ser {
>  	u32 domain;
>  	u16 bdf;
> -	u16 reserved;
> +	u16 refcount;
>  } __packed;
>  
>  /**
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d70080babd52..eb94cbd8ab9d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -41,6 +41,7 @@
>  #include <linux/msi_api.h>
>  #include <uapi/linux/pci.h>
>  #include <linux/liveupdate.h>
> +#include <linux/kho/abi/pci.h>
>  
>  #include <linux/pci_ids.h>
>  
> @@ -594,6 +595,9 @@ struct pci_dev {
>  	u8		tph_mode;	/* TPH mode */
>  	u8		tph_req_type;	/* TPH requester type
> */ #endif
> +#ifdef CONFIG_PCI_LIVEUPDATE
> +	struct pci_dev_ser *liveupdate_outgoing; /* State preserved
> for next kernel */ +#endif
>  };
>  
>  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
> @@ -2880,6 +2884,14 @@ void pci_uevent_ers(struct pci_dev *pdev, enum
>  pci_ers_result err_type); #ifdef CONFIG_PCI_LIVEUPDATE
>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler
> *fh); +
> +int pci_liveupdate_preserve(struct pci_dev *dev);
> +void pci_liveupdate_unpreserve(struct pci_dev *dev);
> +
> +static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct
> pci_dev *dev) +{
> +	return dev->liveupdate_outgoing;
> +}
>  #else
>  static inline int pci_liveupdate_register_flb(struct
> liveupdate_file_handler *fh) {
> @@ -2889,6 +2901,20 @@ static inline int
> pci_liveupdate_register_flb(struct liveupdate_file_handler *fh static
> inline void pci_liveupdate_unregister_flb(struct
> liveupdate_file_handler *fh) { }
> +
> +static inline int pci_liveupdate_preserve(struct pci_dev *dev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
> +{
> +}
> +
> +static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct
> pci_dev *dev) +{
> +	return NULL;
> +}
>  #endif
>  
>  #endif /* LINUX_PCI_H */


