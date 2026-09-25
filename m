Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCFAC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652126B0088; Fri, 25 Sep 2026 16:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602736B008A; Fri, 25 Sep 2026 16:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1A36B0093; Fri, 25 Sep 2026 16:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 221356B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:04:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A49B1A6E0D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:04:11 +0000 (UTC)
X-FDA: 85253361102.16.830649C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED858140005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:04:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH1E97ke;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790366650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ePJQkIFnt4F6epeLD6EuDPC3hOp4CqTE9+zCYw95jpI=;
	b=WDaUd5PDFh/hXo8JDoT6st1TrxNeNPqYYpArOF19g7g4KA6i/VvxKqJDIIkuDEEzbt3n4Q
	czOYlyp+uIoGf+MmqsjdhpFTPFDpksgWzL9P0HBIJwXIflpOzlxT+aA5XdDwNX198JTvZi
	UcORbtFQPQMUJatV3tj+faqt1Puqxns=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH1E97ke;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790366650;
	b=liIQjJJg/3f9Ml8VzHeuNR9QzGiM1yJ4wIlflh+QD5OO9fwwsVQK8S6VJrqJilD/bKTs47
	2NGdYl0Mh6cVnl+0Phb5Uf8eR3W4pmSbRFJ76RBRccXz05dOYNEg+AXtNeKJrWK+El0z82
	JDuT0bOWjyEKkpoUd/LD9+xWKCQwHLU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E000439B9;
	Fri, 25 Sep 2026 20:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAABE1F000FF;
	Fri, 25 Sep 2026 20:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790366649;
	bh=ePJQkIFnt4F6epeLD6EuDPC3hOp4CqTE9+zCYw95jpI=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=JH1E97kezkKPIcz7LwNFF3K1iKvj9euda68sv7W2yJ9qsjlzc0ssvJKALY+6ylfG4
	 ybzL9EF1N3nOKx/mJovi2dH6Ael6VB8u6vOVoo3EPq/fo3BGnoFBVowf9hXX8IMgLg
	 dD2fpKfE1K8Y6ynjbKP5IfQYfq5eJby+Xbhm7W7LLeOuInDLlYPVZL0caXXD/qc7hr
	 ZVLikbkiFvpI9mgXB44hIhvNxa7LzErt10gsQKDRhxTpfqdPQmBRTR/WeNGUGWZ7BL
	 3rvrZKp8UskVAQUja2xGgd1kZA9LfYNzND6v9EmOm+NewSpsBnVaGJ/CG1HjwosEqI
	 BXFfGMqEzApaA==
Date: Fri, 25 Sep 2026 15:04:07 -0500
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
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 06/13] PCI: liveupdate: Preserve bus numbers during
 Live Update
Message-ID: <20260925200407.GA2082921@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-7-dmatlack@google.com>
X-Rspam-User: 
X-Stat-Signature: p4doczajp5rg671b4c7zd7gyptzfcdmf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED858140005
X-HE-Tag: 1790366649-11366
X-HE-Meta: U2FsdGVkX1+Bjli47SnZMKSW5xOw+1ZxCAnt2Jk6WmfJfT0l94K1EgJOSvlSpoW5a4EDXKPiDiDuIgjZKwVVBQQf14/95PxKuuqZpHrzxWat6t0jZCEKLtBCOA3h2xYK2bRtdCkSdVhIqyYDbqM2V+47DJf7b8bSPN/tAaLIRiDPTq1QRnZAl1j9WEYNS58FvH8TnUMhQqMNu0t9R8g5quvN3+bkJWvvL12B1h5lzsYL/YuXEn10VQ2jlHTuu/YAajoXq4HTRqpI0s3sf1nm/b0al62UKw0XXYj9zTsWPyrZiZDW3BdUTfByQVadlYm2SmYDVsJLm14fFPo8rJINdECoUcvRmzeqwlQ4WpR/+GIQgb2Nj3HN42s2D5zjBVoZbmoYSz1ub5g9BwfKVdXohJLw3nh34LzJsXBYns305Y3UCLzSH+fiViVyjjsw7Sdbj4y6VtZ1szd0o9101I+YkN5zU1jimODkVSUtdePRCfZOEnY77EGo12YneotV9KcpGDbVi7JPSanA2X7KOjVq+zG5n0OwRwp7SJIJbOcG0uSAKop35IKYKvCz7ux3kgAvw4ssHNXch6r8IrexY+qhkiKObHvsBkAjM1oCjB8NB7hQw4DVVrQ2ww6VzvPzgqeVfSjzNDNfU9m6TFnFTRs6zovq9m1zcOznh8MhIRkMrmPk8ZgUqYz4D3PZEehP05WrhEVBUoMyznMvJpLNODIq/xMwoVjDhZp4PFK3UCYnFUPKx4Zm5R8YvV+V05rrB5HHRGeh5LczTnD+10zEk2wIBm/+QJC1fYzUGTypUyFQUq3R3jcxWzSJW/gdSJ7TJZDlH01Hyf1CJHNzaSDkqtLe5YrQF4k09H8hIv4y0c47w5hZsipRuJLgLZ6GiVIy4c/Kpy7eZ+m3qW9cSc7LRlEsBZlSfnXQnY6zEOgP46q1txIXtdQAKAnwZBpiEraqRWENoXBKtPeu0D/eQdjkW8I
 5N2wCjKs
 to7SO9KblisRYUMf4E4dzSHzRlBePVOXK1r4OOLxADzbVRkr5YpvHdKiNRIfcZ1USQyav0YIlkiT1w3M9y+OC7lrChmHTfUZX8VQMejPr46ewgo1RC59jf78zUE47EOlORpPgWhKjb9OKVTvRmlKZ0qhHfWuW6EIxrCtn2tOcQD0qyXoSiIvFrnYUaUXbJ7sjS0FaIUuTz/RP3JOqPwgj0gh+QXaEkfUzAuVE1+NIzRyzdxuDBDAaxyzE2dS1TMnjx2RwXF/qAcP0iDb1frq8ZWcoFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:06:32PM +0000, David Matlack wrote:
> Keep the secondary and subordinate bus numbers that the previous kernel
> programmed into bridges, rather than assigning new ones, if the previous
> kernel preserved any device across a Live Update. Do this even on
> architectures that would otherwise always assign bus numbers themselves,
> e.g. when pci=assign-busses is passed.
> 
> Preserved devices must be allowed to continue performing memory
> transactions across a Live Update, so the kernel cannot change the
> fabric topology. Changing the bus numbers of a bridge changes the
> RequesterIDs of the devices below it, which would require disabling and
> flushing any in-flight memory transactions first.
> 
> Apply the policy globally rather than only to the paths that contain
> preserved devices. Bus numbers have to be preserved above a preserved
> device anyway, since an upstream bridge cannot expand its window. A
> global policy matches the scope of pcibios_assign_all_busses(), and
> gives an answer that cannot change part way through the two passes of a
> bridge scan.
> 
> Bridges that do not have bus numbers are still assigned new ones, so
> hot-adding a bridge keeps working, both during and after a Live Update.
> The two-pass bridge scan guarantees such bridges are only assigned bus
> numbers above those already claimed by preserved bridges.
> 
> The exception is a bridge that was preserved but comes up without a
> valid bus number configuration, e.g. because it was reset during kexec.
> Refuse to assign it new bus numbers, since that would silently change
> the BDF of every preserved device in its hierarchy. Also refuse to
> assign bus numbers to the other bridges on the same bus, since the bus
> numbers of the failed bridge can no longer be read from hardware and
> handing them out would let an unrelated device inherit the BDF of a
> preserved device.
> 
> Require that CONFIG_CARDBUS is not enabled to enable
> CONFIG_PCI_LIVEUPDATE since preserving bus numbers on PCI-to-CardBus
> bridges requires additional work but is not a priority at the moment.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  .../admin-guide/kernel-parameters.txt         |   7 +-
>  drivers/pci/Kconfig                           |   2 +-
>  drivers/pci/liveupdate.c                      | 114 ++++++++++++++++++
>  drivers/pci/liveupdate.h                      |  13 ++
>  drivers/pci/probe.c                           |  11 +-
>  include/linux/pci_liveupdate.h                |   5 +
>  6 files changed, 146 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..7eabf6320abf 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5170,7 +5170,12 @@ Kernel parameters
>  				explicitly which ones they are.
>  		assign-busses	[X86] Always assign all PCI bus
>  				numbers ourselves, overriding
> -				whatever the firmware may have done.
> +				whatever the firmware may have done. Ignored
> +				if any device was preserved across a Live
> +				Update, where the kernel must preserve the
> +				PCI topology (including bus numbers) to
> +				avoid interrupting ongoing memory transactions
> +				of preserved devices.
>  		usepirqmask	[X86] Honor the possible IRQ mask stored
>  				in the BIOS $PIR table. This is needed on
>  				some systems with broken BIOSes, notably
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 8af20f558086..16fbd4212e0f 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
>  
>  config PCI_LIVEUPDATE
>  	bool "PCI Live Update Support"
> -	depends on PCI && LIVEUPDATE && 64BIT
> +	depends on PCI && LIVEUPDATE && 64BIT && !CARDBUS
>  	help
>  	  Enable PCI core support for preserving PCI devices across Live
>  	  Update. This, in combination with support in a device's driver,
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 825df024eec4..686887a6c8d9 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -148,6 +148,32 @@
>   * This enables the PCI core and any drivers bound to the bridge to participate
>   * in the Live Update so that preserved endpoints can continue issuing memory
>   * transactions during the Live Update.
> + *
> + * BDF Stability
> + * =============
> + *
> + * The PCI core guarantees that preserved devices can be identified by the same
> + * bus, device, and function numbers for as long as they are preserved
> + * (including across kexec). To accomplish this, the PCI core keeps the
> + * secondary and subordinate bus numbers that the previous kernel programmed
> + * into bridges, if the previous kernel preserved any device. This is true even
> + * on architectures that always assign new bus numbers during scanning. The
> + * kernel assumes the previous kernel established a sane bus topology across
> + * kexec.
> + *
> + * Bridges that do not have bus numbers are assigned new ones as usual, so
> + * hot-adding a bridge keeps working, both during and after a Live Update. The
> + * two-pass bridge scan ensures such bridges are only assigned bus numbers above
> + * those already claimed by preserved bridges.
> + *
> + * If a preserved bridge comes up without a valid bus number configuration, e.g.
> + * because it was reset during kexec, the PCI core refuses to assign it new bus
> + * numbers and does not enumerate anything below it. Assigning new bus numbers
> + * would silently change the BDF of every preserved device in its hierarchy. The
> + * PCI core also stops assigning bus numbers to the other bridges on the same
> + * bus, since the bus numbers of the failed bridge can no longer be read from
> + * hardware and handing them to another bridge would let an unrelated device
> + * inherit the BDF of a preserved device.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -168,9 +194,13 @@
>   * struct pci_liveupdate_global - Global state for PCI Live Update support
>   * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
>   *         FLBs, and the references to them in struct pci_dev.
> + * @had_incoming: True if the previous kernel preserved at least one PCI device.
> + *                Set when the incoming FLB is retrieved and never cleared, so
> + *                it stays true after Live Update finishes.
>   */
>  struct pci_liveupdate_global {
>  	struct rw_semaphore rwsem;
> +	bool had_incoming;
>  };
>  
>  static struct pci_liveupdate_global pci_liveupdate = {
> @@ -298,6 +328,14 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
>  			      ret);
>  	}
>  
> +	/*
> +	 * Remember that the previous kernel preserved devices for the lifetime
> +	 * of this kernel, even after Live Update finishes and the incoming FLB
> +	 * is freed. See pci_liveupdate_preserve_bus_numbers().
> +	 */
> +	if (!xa_empty(&incoming->xa))
> +		pci_liveupdate.had_incoming = true;
> +
>  	args->obj = incoming;
>  	return 0;
>  }
> @@ -606,6 +644,80 @@ static void pci_liveupdate_flb_put_incoming(void)
>  	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
>  }
>  
> +/**
> + * pci_liveupdate_preserve_bus_numbers() - Determine if the PCI core should
> + *                                         preserve bus numbers when scanning
> + *                                         bridges.
> + *
> + * This function is called by the PCI core when it is scanning a bridge. It
> + * determines whether the PCI core should preserve the secondary and subordinate
> + * bus numbers that the previous kernel programmed into that bridge, rather than
> + * assigning new ones. This is necessary to keep RequesterIDs constant for
> + * preserved devices issuing memory transactions.
> + *
> + * Bus numbers are preserved everywhere, and for the lifetime of the kernel, if
> + * the previous kernel preserved any device. Bus numbers have to be preserved
> + * above a preserved device anyway, since an upstream bridge cannot expand its
> + * window. Applying the same policy everywhere matches the scope of
> + * pcibios_assign_all_busses(), and gives an answer that cannot change part way
> + * through the two passes of a bridge scan.
> + *
> + * The incoming FLB is retrieved while setting up the first device, which always
> + * happens before any bridge is scanned, so this returns the same answer for the
> + * entire enumeration.
> + *
> + * Note that this does not prevent the PCI core from assigning bus numbers to
> + * bridges that do not have any, e.g. bridges that are hot-added after the
> + * Live Update. See pci_liveupdate_refuse_bus_numbers() for the one case where
> + * the PCI core must refuse to do so.
> + *
> + * Return: True if bus numbers should be preserved, false otherwise.
> + */
> +bool pci_liveupdate_preserve_bus_numbers(void)
> +{
> +	return pci_liveupdate.had_incoming;
> +}
> +
> +/**
> + * pci_liveupdate_refuse_bus_numbers() - Determine if the PCI core must refuse
> + *                                       to assign bus numbers to the provided
> + *                                       bridge.
> + * @bus: The PCI bus the bus numbers would be assigned from.
> + * @dev: The PCI bridge device the bus numbers would be assigned to.
> + *
> + * This function is called by the PCI core before it assigns bus numbers to a
> + * bridge that does not have any.
> + *
> + * A bridge that was preserved by the previous kernel but came up without a
> + * valid bus number configuration, e.g. because it was reset during kexec, is
> + * left alone by the PCI core and therefore has no child bus once the first pass
> + * of the bridge scan is done.
> + *
> + * The PCI core must not assign bus numbers from @bus while such a bridge is on
> + * it, including to the failed bridge itself. Assigning new bus numbers to the
> + * failed bridge would silently change the BDF of every preserved device in its
> + * hierarchy. Its bus numbers cannot be read from hardware anymore either, so
> + * they cannot be excluded from assignment, and handing them to another bridge
> + * would let an unrelated device inherit the BDF of a preserved device.
> + *
> + * Return: True if @dev must not be assigned bus numbers, false otherwise.
> + */
> +bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
> +{
> +	struct pci_dev *bridge;
> +
> +	for_each_pci_bridge(bridge, bus) {
> +		if (!bridge->liveupdate.was_incoming || bridge->subordinate)
> +			continue;
> +
> +		pci_err(dev, "Not assigning bus numbers, preserved bridge %s lost its bus number configuration\n",
> +			pci_name(bridge));
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
>  	struct pci_flb_incoming *incoming;
> @@ -634,6 +746,8 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
>  
>  	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
>  	dev->liveupdate.incoming = dev_ser;
> +	dev->liveupdate.was_incoming = true;
> +
>  	pci_liveupdate_flb_put_incoming();
>  }
>  
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index eaaa3559fd77..e5d2a19d2ca2 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -13,6 +13,8 @@
>  #ifdef CONFIG_PCI_LIVEUPDATE
>  void pci_liveupdate_setup_device(struct pci_dev *dev);
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev);
> +bool pci_liveupdate_preserve_bus_numbers(void);
> +bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -21,6 +23,17 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>  {
>  }
> +
> +static inline bool pci_liveupdate_preserve_bus_numbers(void)
> +{
> +	return false;
> +}
> +
> +static inline bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus,
> +						     struct pci_dev *dev)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index ad7fdf0d56b6..debe0ad1ef68 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1397,6 +1397,8 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  				  int max, unsigned int available_buses,
>  				  int pass)
>  {
> +	bool preserve_bus_numbers = !pcibios_assign_all_busses() ||
> +				    pci_liveupdate_preserve_bus_numbers();
>  	struct pci_bus *child;
>  	u32 buses;
>  	u16 bctl;
> @@ -1449,8 +1451,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		goto out;
>  	}
>  
> -	if ((secondary || subordinate) &&
> -	    !pcibios_assign_all_busses() && !broken) {
> +	if ((secondary || subordinate) && preserve_bus_numbers && !broken) {
>  		unsigned int cmax, buses;
>  
>  		/*
> @@ -1492,8 +1493,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		 * do in the second pass.
>  		 */
>  		if (!pass) {
> -			if (pcibios_assign_all_busses() || broken)
> -
> +			if (!preserve_bus_numbers || broken)
>  				/*
>  				 * Temporarily disable forwarding of the
>  				 * configuration cycles on all bridges in
> @@ -1507,6 +1507,9 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  			goto out;
>  		}
>  
> +		if (pci_liveupdate_refuse_bus_numbers(bus, dev))
> +			goto out;
> +
>  		/* Clear errors */
>  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
>  
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index 710026ada2d5..d45a5b524909 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -17,10 +17,15 @@
>   * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
>   * @outgoing: State preserved for the next kernel.
>   * @incoming: State preserved by the previous kernel.
> + * @was_incoming: True if this struct pci_dev was incoming-preserved when it was
> + *                set up, i.e. it was matched to state preserved by the previous
> + *                kernel. Unlike @incoming, this is never cleared, so it stays
> + *                true after the device finishes participating in Live Update.
>   */
>  struct pci_liveupdate {
>  	struct pci_dev_ser *outgoing;
>  	struct pci_dev_ser *incoming;
> +	bool was_incoming;
>  };
>  
>  struct pci_dev;
> -- 
> 2.55.0.1082.g2b9226bbc0-goog
> 

