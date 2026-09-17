Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E73EC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23036B008A; Thu, 17 Sep 2026 16:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4246B008C; Thu, 17 Sep 2026 16:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8E76B0092; Thu, 17 Sep 2026 16:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C1D6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:17:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB14CA04AE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:17:40 +0000 (UTC)
X-FDA: 85224364680.05.DD7C06B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4834D10000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:17:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cifno/se";
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789676259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=rAg/Yg/DqWx7Pxj9VVqEz4+jt8Yppr1YHw8Z6DY3rWg=;
	b=Zx/Lx/Ly9cfCVlrKYg6bFBvEq5YIgzmdAHqa/U70eLPRNGrI0F4fHw4aP3JWBlY9M43p+m
	BLEslGYfpdM4pF++SessGRoszc+HQaSUYPrpiSksExr4sfcp0eMYZoFeIu9np3FoHJssJk
	e4jYMw2pT4+k5RPOg5Mfc4v89TXGf8M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cifno/se";
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789676259;
	b=POq/+CEhs90kVHbLdPp9hDvRMT7CVJ5+8+s3cO9/s7H/59m7dwZ4t7RPsExfHnRqOLPGdV
	zCcRk/nBZs6c5NwZmT6Jn3pl5VtVpbHZIMIEwH77asdya1lksAtpK8mgjbo84wDQ1+dsD4
	/ojpF+pV10mGZgrERb5sMzwCFKX/YUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D94E3601EF;
	Thu, 17 Sep 2026 20:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BD01F000FF;
	Thu, 17 Sep 2026 20:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789676258;
	bh=rAg/Yg/DqWx7Pxj9VVqEz4+jt8Yppr1YHw8Z6DY3rWg=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Cifno/seyID/kYnwEs9+FDv8lDl1iWkhIbTZOCPYv/Zl3U125NOEahqqxlcPptx84
	 Lp+WwS5UwXz/cE4pxyhTPmDq18IuA97tb6+2/EXTfb40xf7gXew560HWki//BNg5Md
	 H7BSt20m8+K0EtOHWRWg13d3vTanCYcfD/ZnAmCnqUvBVdF93rIQGxmXbUx+PpnZDU
	 crxNVg/ZxechdqZsl3il8cA/fsemgpg3ig+1w7IAHO7YmVWbOnOqiGbOl8yoGm3Ihh
	 Tqqfwyso+aUaiAND0Smu6s+0pb3Z1KrGeXCrJ14Q2T0e5PjzzsNNugJznZbfYTAcPi
	 Mpe8P3u+jQcjQ==
Date: Thu, 17 Sep 2026 15:17:37 -0500
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
Subject: Re: [PATCH v8 10/12] PCI: liveupdate: Freeze preservation status
 during shutdown
Message-ID: <20260917201737.GA1047708@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-11-dmatlack@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4834D10000E
X-Stat-Signature: dca99ixrcu4jwz5nks19sejsnp49pzjf
X-Rspam-User: 
X-HE-Tag: 1789676259-764278
X-HE-Meta: U2FsdGVkX18NHm/6Raj9IWdO6iKLcPkCNb9K8MoaCEtN/4iEOilc6Kgna+SQQF54KyWSzNdP5XC9px0H+i40NsCXyZp9D2JegTOmEYKqCOOSAOTUOTV9YHEGhIP8tCdKxgZJLZhM/RHuN+t5sXhMLzA21Vw00jGJ3GuIIHDku4wIRA8/XrN0HVl1C9SguoUJELXiRupZTc9yWnJvYekmdUJJLc52VsmgtALbk0OFjwENeDjUcA5UztJFXFbC8wGgGqektFckvcOJAXQl4xabRONAdVAJxxUg+y8sns3p5C7ovB8paF5S7OjGWoX7dLR+N4WoxyzW2zwZw8PzzWYgrGUKjVJ6+EX9cCvSKNZUvSbCYlTroCAUm1oeWoQ37xRiIcETwQvpFOh2oV0lm+EoW2PqOFg7HLm3x8rgHj3vCYSDhCVjAqHW3WX0FubjLi9zIL/ocgrcsvMiKQ3XFeyzS8SYhbved4OeB1HRsqIgtsrTo5uCTX54e+CsfE9ChkDs209M9EfeE0sWXmcsPHwWhJaN1k7GHrP1F7U6uyitQSG2P4EV9yX2rQXq9k1WvnxY/LzM4LpJrczzBvb9IvQ4Sa3GZ+GBvKZMj8IkAFvaezIPq7TX86PnczDjRk6kGSGizTZdNBx20HKwL+VJjcpfrWtFZMyllLBW8wmKii8UbN4gzseuIRE8NH9fxGJaA7kV70OoOv/qKrGnHzuncuOc8y+DUqTVD8JihNEvnuwUlsmhDg6fWOVRe8C3og+mJZIcfahVxbIM5V6FwZFR9xX1DEX3Ex524slLFntmJX2BAkzxFsWApeFt/DabM7Qb/zKCe2cAwILNj3VAI+ghCInoEJxIYpnRPoRk92m00zs5IoZj6+CABAoOMb4o6rNma5un71iRfSCyT1+g8oBJc9rlRhWj1Vz2j0oSRFO+gfOVLqkFo7E2y2d4Cl8y2DknltkiWlMu33m07fwQhyKGm0a
 zlNe5lHO
 x5bj4QwDP/vAsCYhwveKgp5OErxt8WWan8Ftfvtr2px78ijmR54IRhIhZqmrRDyAYMOhcddqthNf/wVu5r+e/hr7sIuAEDjLk9AsxLG3HErM/K/VLlRoR41hv01FnML4UXrdve/0+KdZ1Y7H9gHTlX8MCLjs3OEyYGilgC62+Zru9HzMVmCZPy5/S00QvuCzMmIlG21W6Su0dxcnzU+cIY5G3wjamfXAKPcSkcgp3USmYW9FFWtc11xlDbMgbOmTRsHg29VguVPC+rbDq4o8ntHOPERRanBV1WVJGLo87fNrgTajYtFLasvBgh/2NhFx3xUz4dXjGVxXTAJBP+rgslmMlvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:04PM +0000, David Matlack wrote:
> Freeze a device's outgoing preservation status (preserved or not
> preserved) during shutdown. This enables the PCI core and drivers to
> safely make decisions based on the device's preservation status during
> shutdown.
> 
> Note that pci_liveupdate_freeze() is triggered by the PCI core rather
> than from drivers participating in Live Update so that all devices can
> have their status frozen (i.e. prevent non-preserved devices from
> getting preserved late).

This calls pci_liveupdate_freeze() from pci_device_shutdown(), the
pci_bus_type .shutdown() method, which I think is only called from
device_shutdown() in the kexec or restart paths.

Since there's no error exit after we get as far as device_shutdown(),
and this applies to all devices and dev->liveupdate.frozen is never
set to false (at least at this point in the series), is there benefit
to tracking this per-device?

> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/liveupdate.c       | 16 ++++++++++++++++
>  drivers/pci/liveupdate.h       |  4 ++++
>  drivers/pci/pci-driver.c       |  2 ++
>  include/linux/pci_liveupdate.h |  3 +++
>  4 files changed, 25 insertions(+)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 744513ee11ed..65bcecb1b64e 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -394,6 +394,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
>  {
>  	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
>  
> +	if (dev->liveupdate.frozen) {
> +		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
> +		return -EINVAL;
> +	}
> +
>  	if (!dev_ser) {
>  		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
>  		return -EINVAL;
> @@ -447,6 +452,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>  		return -EINVAL;
>  	}
>  
> +	if (dev->liveupdate.frozen) {
> +		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
> +		return -EINVAL;
> +	}
> +
>  	if (dev->liveupdate.outgoing) {
>  		if (!dev->liveupdate.outgoing->refcount) {
>  			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> @@ -718,6 +728,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
>  }
>  
> +void pci_liveupdate_freeze(struct pci_dev *dev)
> +{
> +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> +	dev->liveupdate.frozen = 1;

Nit, the series assigns "true" to other booleans
(preserve_bus_numbers, was_preserved).

> +}
> +
>  static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
>  {
>  	if (!dev->liveupdate.incoming) {
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index ccc23031e99d..49d07fd02132 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -13,6 +13,7 @@
>  #ifdef CONFIG_PCI_LIVEUPDATE
>  void pci_liveupdate_setup_device(struct pci_dev *dev);
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev);
> +void pci_liveupdate_freeze(struct pci_dev *dev);
>  bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
>  					 struct pci_dev *dev);
>  void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
> @@ -28,6 +29,9 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  {
>  }
>  
> +static inline void pci_liveupdate_freeze(struct pci_dev *dev)
> +{
> +}
>  static inline bool pci_liveupdate_preserve_bus_numbers(struct pci_bus *bus,
>  						       struct pci_dev *dev)
>  {
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index f36778e62ac1..51616e4327d3 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -21,6 +21,7 @@
>  #include <linux/acpi.h>
>  #include <linux/dma-map-ops.h>
>  #include <linux/iommu.h>
> +#include "liveupdate.h"
>  #include "pci.h"
>  #include "pcie/portdrv.h"
>  
> @@ -536,6 +537,7 @@ static void pci_device_shutdown(struct device *dev)
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  	struct pci_driver *drv = pci_dev->driver;
>  
> +	pci_liveupdate_freeze(pci_dev);
>  	pm_runtime_resume(dev);
>  
>  	if (drv && drv->shutdown)
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index 04a2b2a3102a..31898685a406 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -24,6 +24,8 @@
>   * @was_preserved: True if this struct pci_dev was preserved by the previous
>   *                 kernel. Unlike @incoming, this field is not cleared after
>   *                 the device is finished participating in Live Update.
> + * @frozen: True if the outgoing preservation status of this device is frozen
> + *          and thus cannot be changed.
>   */
>  struct pci_liveupdate {
>  	struct pci_dev_ser *outgoing;
> @@ -31,6 +33,7 @@ struct pci_liveupdate {
>  	u16 acs_ctrl;
>  	bool preserve_bus_numbers;
>  	bool was_preserved;
> +	bool frozen;
>  };
>  
>  struct pci_dev;
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

