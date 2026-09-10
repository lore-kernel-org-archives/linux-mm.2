Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8265EC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941536B00AC; Thu, 10 Sep 2026 19:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1C26B00AD; Thu, 10 Sep 2026 19:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC0C6B00AE; Thu, 10 Sep 2026 19:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 468B96B00AC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:51:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC04AA065E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:52 +0000 (UTC)
X-FDA: 85199502864.21.70585E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 342CCC0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArNsIwce;
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084311;
	b=und+78y4Hf/b6PdBsVyIZ8MglZ8bwleNCgZqxAdTTN5jcrl5o6Qo/MtSk4oxpNnytLs8Xy
	EW7N9dcl6HNi7UpFQ0NJxp2lq/FkYkSYhODw3IrcjpQvExYK+GwvpmDedXkTB0pXf3Taq5
	uB6KgBqw0+JLLeaLSWi3YOWxozhLO2s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArNsIwce;
	spf=pass (imf22.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=OQOxkycwoGLNXGUfFmcr/J4SGntOXSZHAc0hvOFZlQU=;
	b=IjIDlkImRqT0OEXJbGapx35Xn5/Cdxtz6p9Qz+kv6p8zaPlTnMVB1F9lEIkldZOMfZyF57
	k8lAoP/+p4aG+Oh5B/itptPhOvoO+17AN2vfXXcnqYy+kf2iosuJlr5tlX/xpXZo890+9Z
	J9Zggro1TfcHlDHtIdyIg64UUqo5h2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA5A460200;
	Thu, 10 Sep 2026 23:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448D51F000FF;
	Thu, 10 Sep 2026 23:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084310;
	bh=OQOxkycwoGLNXGUfFmcr/J4SGntOXSZHAc0hvOFZlQU=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ArNsIwcez5Uh3JsEBsAM0lOJjUMbXFHtBInHoiTTWHMtCAnNNGjd0GIaOeoyodhi3
	 RVYHyIskfdIeLq2oYTHbGRM+jPvi6pwgX1y88UP32m2kJZ+eTc2ZESKtwhTwMMTB26
	 RWyl5hUnei4gbHrytcDcV4H8icCzz97ZBQNBPtVSE5Wy4kHLvtO07PCBMXXTA6rGnO
	 jbQBaEFncQwijJZ/Y+TD9Gy2yatx4vvD112VrtMsVNgBWZZWLyTopL0P4sW0Kig272
	 gTRlFxN7Up1pmrq2wlISFeFjbRgJkc1ZRKoKvnV/5j963bDN9pT3LLl5mKsgjJdOxW
	 2jYXvBzVAXIxQ==
Date: Thu, 10 Sep 2026 18:51:49 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 08/12] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <20260910235149.GA364189@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-9-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 342CCC0003
X-Stat-Signature: 5jakem4cs76ibj4y5ft4pxjj5ujn8g5z
X-HE-Tag: 1789084311-668581
X-HE-Meta: U2FsdGVkX1/+z2wdyYT+ws+vYazSHpAsjTo5mAN4ZDpuT+H7g5aWvfmJdGzfcx3S5TfLCHV4PkhWsUGCtO/jQRGfeASgPevLetw4/jAVnAryCz3CqhR7b5af64rCF+Psaodpe7MhpwSCKgHy8D1kbZdI0wcohJ2dbcq984OwSoFYHNx9T0AkbsH6ffYrsmMdI0ROQ28URzfUcsqtR8PnWBP8AVJbEDW4Rh+1QdJS/pvVQCRkRNDaxu2Zz9co1ThJnpwkZlo+7h64e/LCS4TsJlCzdxq3AOcfkEejDFtnOxi6fkbRqtRdAOvYDt6OdGKQpTqlJJG9sTiGhXS4dySdU6hy7pv0XJAUVdMI9VC0ogt9N7abydliu/m4U2/pKQbEtfi8hOJQzo7OdFLo6+bsM57j1elS3u7um2S24IDB3pOZqwvePFrl/cK9KfvYCBmsjhH7iBgFCPuhluwsLBwzSpZOIzN8SuO9CEJqpPrimTz5S7CXOBwmlVtKZ2T2IpDneX1+3etk+/j0UI91g/5SW1qfecZ8WaawwBHL+D1Z6Oa6su+58lKLWb0WDlP7B+TKqWtJHNwUwNI6X01pSVyTZQrvt1Fl7HjtS1TUm5lChlMbQWERbWpcuEJq7V+nNvhYJYdiOs2vR2R8wMjzRd1B4/9B+AL8PNyPF6Y9zm4UDnE7f3jjdaLV57VCoDYulve6dBlGweTFtDk4erV23CNyI7zNwQznaU2Ip3FF8gliCI+jdUfGGUPQmK78UcPMGy/0tvTl/7Dzqfzhyq7XfuP4E3sWEcmjxd7uolRML+PR2n1K6eqchxG4Qn7oIMaUyB5lTffXzUMXVIpuG8yGd7rzXwtqOomeM/QU0xWtkkVjtZQMsgopJN7FiayQ7gsJUnHPwEx6g4hAPt1VqI10T0rr/a5/qeEIaKUUHimXAq2D+uaNSTmHkyhB0nsh2eHf9nyfWFZzhhRDp/KIS28ocz1
 RAfIZ24h
 zpzBavqMUYrsIzY8aQuYIUXvN5dMImFEW14yzColasjlat76aWVAux56+kfqoWMA16pMRmcOgTsYE3zAVWCrnsxlmM19v9UUNmUNQuvuGt9lD3mGqONz3xeuxLkvMLiCjxJ+lKIghZS7tKPMqR2G2LA9vIfn5pwR5+JVS8HDuU91A2RwGFrCweL/Iy825WEbYq9wOjoOB0xBKvE01YyTqB1gaGE+zCGheCYCOW0D6n8ryWw1zMUY7RvLFqtesXSc9H++y7jTCSHCrAjzAQ2CUHuTM+gknMdAQtuQOHu1htWNqhDSUxbIL8OnIVeMX0hXSq7M32/piRD7pDer9GVDr8fxqEXSjtXTwtjGNae7XRsloNhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:02PM +0000, David Matlack wrote:
> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change during or
> after Live Update.
> 
> Cache the inherited ACS controls established by the previous kernel in
> struct pci_dev so that ACS controls do not change after a reset
> (pci_restore_state() calls pci_enable_acs()).
> 
> To simplify ACS inheritance, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account.

> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c       | 87 ++++++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.h       | 11 +++++
>  drivers/pci/pci.c              |  6 +++
>  drivers/pci/pci.h              |  5 ++
>  drivers/pci/quirks.c           |  7 +++
>  include/linux/pci_liveupdate.h |  6 +++
>  6 files changed, 122 insertions(+)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 08e5ff8c1fe7..fb602dd3933e 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -71,6 +71,9 @@
>   *
>   *  * The device cannot be a Virtual Function (VF).
>   *
> + *  * The device cannot require device-specific quirks to enable Access
> + *    Control Services (ACS).
> + *
>   * Driver Binding
>   * ==============
>   *
> @@ -113,6 +116,18 @@
>   * This enables the PCI core and any drivers bound to the bridge to participate
>   * in the Live Update so that preserved endpoints can continue issuing memory
>   * transactions during the Live Update.
> + *
> + * Handling Preserved Devices
> + * ==========================
> + *
> + * The PCI core treats preserved devices differently than non-preserved devices.
> + * This section enumerates those differences.
> + *
> + *  * The PCI core adopts all ACS controls enabled on incoming preserved devices
> + *    rather than assigning new ones. This ensures that TLPs are routed the same
> + *    way after Live Update and ensures that IOMMU groups do not change. Note
> + *    that a device will use its adopted ACS controls for the lifetime of its
> + *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -128,6 +143,7 @@
>  #include <linux/slab.h>
>  
>  #include "liveupdate.h"
> +#include "pci.h"
>  
>  /**
>   * struct pci_liveupdate_global - Global state for PCI Live Update support
> @@ -417,6 +433,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Do not preserve devices that rely on device-specific ACS equivalents
> +	 * (for now) since that would complicate keeping ACS constant across
> +	 * Live Update.
> +	 */
> +	if (pci_need_dev_specific_enable_acs(dev)) {
> +		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
> +		return -EINVAL;
> +	}
> +
>  	if (dev->liveupdate.outgoing) {
>  		if (!dev->liveupdate.outgoing->refcount) {
>  			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> @@ -668,6 +694,7 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
>  
>  	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
>  	dev->liveupdate.incoming = dev_ser;
> +	dev->liveupdate.was_preserved = true;
>  	pci_liveupdate_flb_put_incoming();
>  }
>  
> @@ -746,6 +773,66 @@ void pci_liveupdate_finish(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
>  
> +/**
> + * pci_liveupdate_cache_adopted_acs_controls() - Cache adopted ACS controls
> + * @dev: The PCI device to cache ACS controls from
> + *
> + * If @dev is an incoming Live Update device, read its current ACS configuration
> + * from hardware (which was set by the previous kernel) and cache it.
> + */
> +void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev)
> +{
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->liveupdate.incoming)
> +		return;
> +
> +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
> +}
> +
> +/**
> + * pci_liveupdate_enable_adopted_acs_controls() - Enable adopted ACS controls
> + * @dev: The PCI device to enable adopted ACS controls for
> + *
> + * For devices preserved across a Live Update, write the cached ACS controls
> + * back into the hardware's ACS Capability. This ensures that the device
> + * continues to use the ACS rules established by the previous kernel.
> + *
> + * Return: 0 on success, or -EINVAL if the device was not preserved or requires
> + * device-specific quirks.
> + */
> +int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev)
> +{
> +	u16 acs_ctrl = dev->liveupdate.acs_ctrl;
> +	u16 acs_cap = dev->acs_cap;
> +
> +	/*
> +	 * Check if the device was preserved over a previous Live Update (even
> +	 * if it has already gone through pci_liveupdate_finish()). This ensures
> +	 * that the device continues to use the ACS controls established by the
> +	 * previous kernel.
> +	 */
> +	if (!dev->liveupdate.was_preserved)
> +		return -EINVAL;
> +
> +	/*
> +	 * The previous kernel should not have preserved any devices that
> +	 * require device-specific quirks to enable ACS, but if such a device is
> +	 * detected (e.g. new device-specific ACS quirk in the current kernel),
> +	 * log a big warning and fall back to the normal enable ACS path.
> +	 */
> +	if (pci_need_dev_specific_enable_acs(dev)) {
> +		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
> +		WARN_ON_ONCE(true);
> +		return -EINVAL;
> +	}
> +
> +	if (acs_cap)
> +		pci_write_config_word(dev, acs_cap + PCI_ACS_CTRL, acs_ctrl);
> +
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index 107881183fda..ac5b8bf2edf5 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -16,6 +16,8 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
>  bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
>  					 struct pci_dev *dev);
>  void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
> +void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev);
> +int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -34,6 +36,15 @@ static inline bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
>  static inline void pci_liveupdate_scan_bridge_end(struct pci_dev *dev)
>  {
>  }
> +
> +static inline void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev)
> +{
> +}
> +
> +static inline int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 77b17b13ee61..22001bdf4c97 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -34,6 +34,8 @@
>  #include <linux/aer.h>
>  #include <linux/bitfield.h>
>  #include <linux/suspend.h>
> +
> +#include "liveupdate.h"
>  #include "pci.h"
>  
>  DEFINE_MUTEX(pci_slot_mutex);
> @@ -1008,6 +1010,9 @@ void pci_enable_acs(struct pci_dev *dev)
>  	bool enable_acs = false;
>  	int pos;
>  
> +	if (!pci_liveupdate_enable_adopted_acs_controls(dev))
> +		return;

Ugh.  The asymmetry between pci_save_state(), which does nothing
ACS-related, and pci_restore_state(), which enables it, is sort of
sketchy to begin with.

The command-line parsing in this path feels like kind of a wart (not
that you're touching it).

It just seems like this path is already hard to analyze, and
liveupdate is making it harder.

If we could save/restore the ACS state around the reset, wouldn't that
solve this without any liveupdate specials here?

>  	/* If an iommu is present we start with kernel default caps */
>  	if (pci_acs_enable) {
>  		if (pci_dev_specific_enable_acs(dev))
> @@ -3689,6 +3694,7 @@ void pci_acs_init(struct pci_dev *dev)
>  
>  	pci_read_config_word(dev, pos + PCI_ACS_CAP, &dev->acs_capabilities);
>  	pci_disable_broken_acs_cap(dev);
> +	pci_liveupdate_cache_adopted_acs_controls(dev);
>  }
>  
>  /**
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 4469e1a77f3c..988a18b3204a 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1047,6 +1047,7 @@ void pci_acs_init(struct pci_dev *dev);
>  void pci_enable_acs(struct pci_dev *dev);
>  #ifdef CONFIG_PCI_QUIRKS
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
>  void pci_disable_broken_acs_cap(struct pci_dev *pdev);
> @@ -1057,6 +1058,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
>  {
>  	return -ENOTTY;
>  }
> +static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	return -ENOTTY;
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7ac39ec2843e..99b819f38e49 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5473,6 +5473,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
>  	return NULL;
>  }
>  
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
> +
> +	return p && p->enable_acs;
> +}
> +
>  int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>  	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index fc1f5640968a..04a2b2a3102a 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -17,14 +17,20 @@
>   * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
>   * @outgoing: State preserved for the next kernel.
>   * @incoming: State preserved by the previous kernel.
> + * @acs_ctrl: ACS features established by the previous kernel.
>   * @preserve_bus_numbers: True if the PCI core should preserve the secondary and
>   *                        subordinate bus numbers assigned to this device due to
>   *                        an ongoing Live Update.
> + * @was_preserved: True if this struct pci_dev was preserved by the previous
> + *                 kernel. Unlike @incoming, this field is not cleared after
> + *                 the device is finished participating in Live Update.
>   */
>  struct pci_liveupdate {
>  	struct pci_dev_ser *outgoing;
>  	struct pci_dev_ser *incoming;
> +	u16 acs_ctrl;
>  	bool preserve_bus_numbers;
> +	bool was_preserved;
>  };
>  
>  struct pci_dev;
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

