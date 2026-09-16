Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80327C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2773C6B0095; Tue, 15 Sep 2026 23:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225506B0096; Tue, 15 Sep 2026 23:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEE16B0098; Tue, 15 Sep 2026 23:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D53526B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:32:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FC58405BF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:32:03 +0000 (UTC)
X-FDA: 85218201726.21.054EAC6
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf22.hostedemail.com (Postfix) with ESMTP id 722D5C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:31:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwWPvvae;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789529521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHHetD7z2LKY658fw/GAuF9X+vsebDmUpxUUa3RkYoM=;
	b=qtW1n0bP53tUcz6mDE0oXmSCvDfCoF8IsxR2iOkmCxsEircAUuhptAx+/39GMLgh9iP0Og
	7um0bqagvQOKBcp7+7K/8XI4fjOqL96TBXGtG7FzQFpNCcI3rybxVgSAZibc+ao5nmIykT
	TlCqlTMrL++D7g28tiYyQLTqaltVzhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789529521;
	b=Uh2xumolt0AdjbBl/HdT66OYnF1ISEDae5kQh1LwVrMsryNrkyJKWqutSFJNzmVkF2DRmU
	rDQPJHWq5uyIEDzSylyn8V7Ha/bl3RfooGUa4ZmKubawojmxd79RYTy4i7ko0oZ1c6Tikq
	iFV9U+FXjJJLp4YpL+zs4AcAG4qb3Q8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwWPvvae;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/gKDc1UJUEW3gZkDgmnO4FI9/og2soBWPviRlsd2j9E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789529516; v=1; x=1790134316;
 b=LwWPvvaeOVIcO+QfTmpcnPfm4GG+j31VryVD+rtm579dAsPPrwrq2KsAqD0sQuVdPjJI7Ty5
 uvCli8zJ7Tm/JoeU5gFrW2h54M0MLpJZQpTaE43NaBbjwkMwjKdHpAOVafvQPxXs4TTTTujCZec
 Bauja0qz4PkkxVOvJBt7A7tM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f83172af188618d;
	Wed, 16 Sep 2026 03:31:56 +0000
X-Mizu-Trace-ID: 0f83172af188618d
X-Migadu-Flow: FLOW_OUT
Message-ID: <e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev>
Date: Tue, 15 Sep 2026 20:31:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-4-dmatlack@google.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260728221007.2098560-4-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mpcygdpwkaypi9o6acqhj4rnne4ws5nz
X-Rspamd-Queue-Id: 722D5C0005
X-HE-Tag: 1789529519-649154
X-HE-Meta: U2FsdGVkX18vuWFatU5zkDSAW+QIHDDANkcXiON2UEdMUufdsqYHIeiUxUxRRf261l6VDIUmiBjqrABAJu4qBHUmLUIE8PKFJb23Iic+8tFjMipMlKS4uAKaY1m27/ltVMM1I2ziUcu9yu5Q97KrNMx+eUGxxazuoPvByviSfNtYOtn42bGouQR47id1ThnA3LKYSYdxh7y+CzmL1OY0ehqyY0x9DX7qHfIP+EKDksV7wMh6ggAKoTYPrm5M4ZLt+eJxOiT5FL4BIwRGD/j631PN4oXrYG4tMQnh4b6flRGIm3YMEvAaDzt452HbJyaLCF5ekX1ceFNYikTGyFmQgd9NbEbySZhoMCIiAb0VjaNkTEKfv2LTT2jdvrlQ9PnJ/onNgYCnZKgG0SSB+ivueDxDIlXF/LhwGldcxcVJ2UYtLVyoo8+HIW4Y0O+1xpAii52BKwAPntU3kJ3ai1VViTs4ZNWQnGFzDZ9PkRdN/8bszz1gCkNNHEhsZYGe8JHb5+CUh+oEP38iWbYD5hwJLQq8dxsLymZ2+hM2H9Nzzz2WprGBLJvpiNWK/kfWxd2zFo2ImgY2PRyCm3WITepsuwsu019pAEwc4QFJ+xOBqCdFchP+91E0OKBsXj0ntxveMQlI7/44N2nRIrDHjQZNpRkXRkvl07+RKj8Xj4R9LDgW/XzQxff0r2aTficZzJUAedKijH+xX9gRfC1tQMPVAt/L6uqbuZPi59zZmT91rwN+g+PHPcZUvmG3TTXeXa3GCF6gMXPWntncnKYQjjWNjK8mVN6JSKwKWriOwkRGcYQhTy/qhQHMJT2haqDIo0gyOPEFL2CkDGg1aRSJfp1oQq0ZEME2Iu+x3v91d7WCo3u47fWXs1BLjSb1SjVc46ivaYd5221a+foiaU+3JWeKP2lrvTHc7vbaKzoXwlMF1fz+GX51un0pJHEhHeCaQJGXagiivY9Sdzc7MqtltDH
 Lt1pniHC
 YfVRckWT72eMswfQ4Z/Plt6wVSeorZ/6qlICn3Gu8gWfCt3Or3WzuPDQ6zNtS1K6366g+tWIj46BP1/76fkkCbqFa1YvObS/fri1L6oMhyEuw265SXCz/pZal4irCXbFBftnapy2v1pRPb2uIumMhOzhdJQOaesTsQ8aQ7Jq2aaZxOQxQkANLpQsUUZM9ZVCnDkEFJxatUVur2O3aM0wfGYhjmXVqcGSysQs2ptN68NCKloyD+K75tX0NUM6n+gy3DBHwIQBnye/kNPO8rc4oDrMLY8T1syI0NV4nGQwrXIhlmGxiSBRWgHhhuiRj3vJsR7iE6dVXga63zU3TJmwveYE65GqkycTaDK/VuRVo56DlA7W7rucitYtOhxHsZjXdLeGhxiJGMtCaIIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/28 15:09, David Matlack 写道:
> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.
> 
> Add pci_liveupdate_setup_device() which is called during device setup
> to fetch the serialized state (struct pci_ser) from the Live Update
> Orchestrator. The first time this happens, pci_flb_retrieve() will run
> and convert the array of pci_dev_ser structs into an xarray so that it
> can be looked up efficiently.
> 
> If a device is found in the xarray, the PCI core stores a pointer to its
> state in dev->liveupdate_incoming until pci_liveupdate_finish() is
> called by the driver. This pointer allows the PCI core and drivers to
> apply Live Update-specific logic to incoming devices in subsequent
> commits.
> 
> Drivers can check if a device is an incoming preserved device (e.g.
> during probe) by calling pci_liveupdate_is_incoming().
> 
> CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
> domain and bdf can be guaranteed to fit in an unsigned long and be used
> as the xarray key.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   MAINTAINERS                    |   1 +
>   drivers/pci/Kconfig            |   2 +-
>   drivers/pci/liveupdate.c       | 256 ++++++++++++++++++++++++++++++++-
>   drivers/pci/liveupdate.h       |   5 +
>   drivers/pci/probe.c            |   3 +
>   include/linux/pci_liveupdate.h |  13 ++
>   6 files changed, 277 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9cc7b9291ace..08a724b860dc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20834,6 +20834,7 @@ L:	linux-pci@vger.kernel.org
>   S:	Maintained
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>   F:	drivers/pci/liveupdate.c
> +F:	drivers/pci/liveupdate.h
>   F:	include/linux/kho/abi/pci.h
>   F:	include/linux/pci_liveupdate.h
>   
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 3781e2b5f095..8af20f558086 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
>   
>   config PCI_LIVEUPDATE
>   	bool "PCI Live Update Support"
> -	depends on PCI && LIVEUPDATE
> +	depends on PCI && LIVEUPDATE && 64BIT

One question about adding 64BIT to the dependency:

As I understand it, enabling CONFIG_64BIT essentially means that we are 
building a 64-bit kernel, and a 32-bit architecture cannot normally 
enable CONFIG_64BIT.

If that is the case, would depends on 64BIT be necessary here? Or is PCI 
Live Update already inherently restricted to 64-bit architectures by the 
existing LIVEUPDATE/architecture configuration, so that this dependency 
would be redundant?

If this problem has already discussed, I am very sorry about this.

Yanjun Zhu

>   	help
>   	  Enable PCI core support for preserving PCI devices across Live
>   	  Update. This, in combination with support in a device's driver,
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index b003b7069cdb..5ce5f8b36902 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -49,6 +49,20 @@
>    * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
>    * with the list of **outgoing** preserved devices for the next kernel.
>    *
> + * After kexec, whenever a device is enumerated, the PCI core will check if it
> + * is an **incoming** preserved device (i.e. preserved by the previous kernel)
> + * by checking the incoming FLB data (struct pci_ser).
> + *
> + * Drivers must notify the PCI core when an **incoming** device is done
> + * participating in the incoming Live Update with the following API:
> + *
> + *  * ``pci_liveupdate_finish(pci_dev)``
> + *
> + * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
> + * ``pci_liveupdate_preserve()``. i.e. A PCI device can be **outgoing**
> + * (preserved for next kernel) and **incoming** (preserved by previous kernel)
> + * at the same time.
> + *
>    * Restrictions
>    * ============
>    *
> @@ -100,6 +114,26 @@ struct pci_flb_outgoing {
>   	struct kho_block_set block_set;
>   };
>   
> +/**
> + * struct pci_flb_incoming - Incoming PCI FLB object
> + * @ser: The incoming struct pci_ser from the previous kernel.
> + * @xa: Xarray used to quickly lookup devices in @ser.
> + * @block_set: The KHO block set holding the incoming devices.
> + *
> + * This structure holds the runtime state for the incoming PCI Live Update
> + * state. It wraps the serialized pci_ser, the block_set used to restore
> + * the serialized entries, and an xarray for fast lookups.
> + */
> +struct pci_flb_incoming {
> +	struct pci_ser *ser;
> +	struct xarray xa;
> +	struct kho_block_set block_set;
> +};
> +
> +static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
> +{
> +	return (unsigned long)domain << 16 | bdf;
> +}
>   static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>   {
>   	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
> @@ -140,15 +174,91 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
>   
>   static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
>   {
> +	struct pci_ser *ser = phys_to_virt(args->data);
> +	struct pci_flb_incoming *incoming;
> +	struct pci_dev_ser *dev_ser;
> +	struct kho_block_set_it it;
> +	int ret;
> +
>   	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
> -	args->obj = phys_to_virt(args->data);
> +
> +	if (ser->version != PCI_LUO_FLB_VERSION) {
> +		pr_err("Incoming PCI FLB version (v%d) is incompatible with this kernel (v%d)\n",
> +		       ser->version, PCI_LUO_FLB_VERSION);
> +		ret = -EINVAL;
> +		goto err_restore_free;
> +	}
> +
> +	incoming = kzalloc_obj(*incoming);
> +	if (!incoming) {
> +		ret = -ENOMEM;
> +		goto err_restore_free;
> +	}
> +
> +	incoming->ser = ser;
> +	xa_init(&incoming->xa);
> +
> +	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
> +	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
> +	if (ret)
> +		goto err_free_incoming;
> +
> +	kho_block_set_it_init(&it, &incoming->block_set);
> +	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
> +		unsigned long key;
> +
> +		if (!dev_ser->refcount)
> +			continue;
> +
> +		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
> +		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
> +		if (ret)
> +			goto err_block_set_destroy;
> +	}
> +
> +	args->obj = incoming;
>   	return 0;
> +
> +err_block_set_destroy:
> +	kho_block_set_destroy(&incoming->block_set);
> +err_free_incoming:
> +	xa_destroy(&incoming->xa);
> +	kfree(incoming);
> +err_restore_free:
> +	kho_restore_free(ser);
> +	return ret;
> +}
> +
> +static void pci_check_all_devices_finished(struct pci_flb_incoming *incoming)
> +{
> +	struct pci_dev *dev = NULL;
> +
> +	if (READ_ONCE(incoming->ser->nr_devices) == 0)
> +		return;
> +
> +	for_each_pci_dev(dev) {
> +		if (READ_ONCE(dev->liveupdate.incoming))
> +			pci_emerg(dev, "Preserved device was never finished!\n");
> +	}
> +
> +	/*
> +	 * This should only happen if a driver violated the contract to call
> +	 * pci_liveupdate_finish() (something is extremely broken).
> +	 */
> +	panic("Some preserved devices were never finished!\n");
>   }
>   
>   static void pci_flb_finish(struct liveupdate_flb_op_args *args)
>   {
> +	struct pci_flb_incoming *incoming = args->obj;
> +
>   	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
> -	kho_restore_free(args->obj);
> +	pci_check_all_devices_finished(incoming);
> +
> +	xa_destroy(&incoming->xa);
> +	kho_block_set_destroy(&incoming->block_set);
> +	kho_restore_free(incoming->ser);
> +	kfree(incoming);
>   }
>   
>   static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> @@ -325,6 +435,75 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>   
> +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> +{
> +	struct pci_flb_incoming *incoming = NULL;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
> +
> +	/* Live Update is not enabled. */
> +	if (ret == -EOPNOTSUPP)
> +		return NULL;
> +
> +	/* Live Update is enabled, but there is no incoming FLB data. */
> +	if (ret == -ENODATA)
> +		return NULL;
> +
> +	/*
> +	 * Live Update is enabled and there is incoming FLB data, but none of it
> +	 * matches pci_liveupdate_flb.compatible.
> +	 */
> +	if (ret == -ENOENT)
> +		return NULL;
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but retrieve failed (pci_flb_retrieve() returned an error or LUO
> +	 * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
> +	 */
> +	if (ret)
> +		panic("Failed to retrieve incoming FLB data (%d)\n", ret);
> +
> +	return incoming;
> +}
> +
> +static void pci_liveupdate_flb_put_incoming(void)
> +{
> +	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
> +}
> +
> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_flb_incoming *incoming;
> +	struct pci_dev_ser *dev_ser;
> +	unsigned long key;
> +
> +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> +
> +	incoming = pci_liveupdate_flb_get_incoming();
> +	if (!incoming)
> +		return;
> +
> +	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
> +	dev_ser = xa_load(&incoming->xa, key);
> +
> +	/*
> +	 * This device was not preserved across Live Update, or it was preserved
> +	 * but has already been probed and gone through pci_liveupdate_finish(),
> +	 * e.g. due to removing and re-adding the device. Either way, it's not
> +	 * treated as incoming-preserved.
> +	 */
> +	if (!dev_ser || !dev_ser->refcount) {
> +		pci_liveupdate_flb_put_incoming();
> +		return;
> +	}
> +
> +	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
> +	dev->liveupdate.incoming = dev_ser;
> +	pci_liveupdate_flb_put_incoming();
> +}
> +
>   void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>   {
>   	/*
> @@ -336,7 +515,80 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>   	 */
>   	if (READ_ONCE(dev->liveupdate.outgoing))
>   		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
> +
> +	if (READ_ONCE(dev->liveupdate.incoming))
> +		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
> +}
> +
> +static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
> +{
> +	if (!dev->liveupdate.incoming) {
> +		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
> +		return;
> +	}
> +
> +	if (dev->liveupdate.incoming->refcount != 1) {
> +		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Drop the refcount so this device does not get treated as an incoming
> +	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
> +	 * again because the device is hot-plugged.
> +	 */
> +	dev->liveupdate.incoming->refcount = 0;
> +
> +	pci_info(dev, "Device is finished participating in Live Update\n");
> +	dev->liveupdate.incoming = NULL;
> +	ser->nr_devices--;
> +}
> +
> +/**
> + * pci_liveupdate_finish() - Finish the preservation of a PCI device
> + * @dev: The PCI device
> + *
> + * pci_liveupdate_finish() notifies the PCI core that a PCI device that was
> + * preserved across the previous Live Update has finished participating in Live
> + * Update. Drivers must call pci_liveupdate_finish() from their struct
> + * liveupdate_file_handler finish() callback to ensure the incoming struct
> + * pci_ser is allocated.
> + */
> +void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +	struct pci_flb_incoming *incoming;
> +
> +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> +
> +	incoming = pci_liveupdate_flb_get_incoming();
> +	if (!incoming) {
> +		pci_warn(dev, "Cannot finish preserving device without incoming FLB\n");
> +		return;
> +	}
> +
> +	pci_liveupdate_finish_device(incoming->ser, dev);
> +	pci_liveupdate_flb_put_incoming();
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
> +
> +/**
> + * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
> + * @dev: The PCI device to check
> + *
> + * Check if a device was preserved across Live Update by the previous kernel,
> + * i.e. the device is incoming-preserved. Note that a device is only considered
> + * incoming-preserved prior to pci_liveupdate_finish(). It is up to drivers to
> + * synchronize usage of pci_liveupdate_is_incoming() with their own call to
> + * pci_liveupdate_finish() to avoid acting on stale data.
> + *
> + * Returns: True if the device is incoming-preserved, false otherwise.
> + */
> +bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> +{
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +	return dev->liveupdate.incoming;
>   }
> +EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
>   
>   /**
>    * pci_liveupdate_register_flb() - Register a file handler with the PCI core
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index b2335581f8d0..eaaa3559fd77 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -11,8 +11,13 @@
>   #include <linux/pci.h>
>   
>   #ifdef CONFIG_PCI_LIVEUPDATE
> +void pci_liveupdate_setup_device(struct pci_dev *dev);
>   void pci_liveupdate_cleanup_device(struct pci_dev *dev);
>   #else
> +static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +}
> +
>   static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
>   {
>   }
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 14b66acbdb15..5dc9d86e3597 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2065,6 +2065,8 @@ int pci_setup_device(struct pci_dev *dev)
>   	if (pci_early_dump)
>   		early_dump_pci_device(dev);
>   
> +	pci_liveupdate_setup_device(dev);
> +
>   	/* Need to have dev->class ready */
>   	dev->cfg_size = pci_cfg_space_size(dev);
>   
> @@ -2188,6 +2190,7 @@ int pci_setup_device(struct pci_dev *dev)
>   	default:				    /* unknown header */
>   		pci_err(dev, "unknown header type %02x, ignoring device\n",
>   			dev->hdr_type);
> +		pci_liveupdate_cleanup_device(dev);
>   		pci_release_of_node(dev);
>   		return -EIO;
>   
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> index 894052ad6961..710026ada2d5 100644
> --- a/include/linux/pci_liveupdate.h
> +++ b/include/linux/pci_liveupdate.h
> @@ -16,9 +16,11 @@
>   /**
>    * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
>    * @outgoing: State preserved for the next kernel.
> + * @incoming: State preserved by the previous kernel.
>    */
>   struct pci_liveupdate {
>   	struct pci_dev_ser *outgoing;
> +	struct pci_dev_ser *incoming;
>   };
>   
>   struct pci_dev;
> @@ -28,6 +30,8 @@ int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
>   void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
>   int pci_liveupdate_preserve(struct pci_dev *dev);
>   void pci_liveupdate_unpreserve(struct pci_dev *dev);
> +void pci_liveupdate_finish(struct pci_dev *dev);
> +bool pci_liveupdate_is_incoming(struct pci_dev *dev);
>   #else
>   static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
>   {
> @@ -46,6 +50,15 @@ static inline int pci_liveupdate_preserve(struct pci_dev *dev)
>   static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
>   {
>   }
> +
> +static inline void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +}
> +
> +static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> +{
> +	return false;
> +}
>   #endif
>   
>   #endif /* LINUX_PCI_LIVEUPDATE_H */


