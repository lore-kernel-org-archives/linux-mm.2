Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF31E7C70D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 06:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597CA6B0005; Sun,  1 Feb 2026 01:38:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B266B008C; Sun,  1 Feb 2026 01:38:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB556B0092; Sun,  1 Feb 2026 01:38:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 296D56B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 01:38:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD7875B95D
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:38:38 +0000 (UTC)
X-FDA: 84394934316.30.31FF622
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA08A40003
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:38:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=smbFLQG3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769927917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwyK35BqHJ9vMxdC101Hpkz7OEl6VsmM8t+q1gtlYtQ=;
	b=BosWOcRfap6aSXTSsOneynF+w2p14GsRfxgQGdHWg5akpzhzSLj7UfNR91Wui9vQFlgiW+
	f4cATEZ29za8nkyle3HWHZshlmSoTUQeX9Lo0xnk9Eb1JBESHQzBPL7jLQufFDHXtAGyXu
	GwniK8BKyJrjlG+5k7gltx/py2kC7/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769927917; a=rsa-sha256;
	cv=none;
	b=lGIAK7iueOORBVZ55lMRdClqoqHIfFpEkveBNB5QE8hr+qEkiWPzx9LxqHW2hPIZHH1/ha
	raQz+zD3jXuZ8edo2jaohJP4FE0vm1iSRcJEzKtRwgHqpmB34Ml0p9rxGscUXUaS1Z7oPn
	cgNC1Xhe3ueWQwd9l83QUecvcchmmYE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=smbFLQG3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
Message-ID: <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769927913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZwyK35BqHJ9vMxdC101Hpkz7OEl6VsmM8t+q1gtlYtQ=;
	b=smbFLQG3fxi0EmdEQh5EfbtGQ62LpS961djirjg538qndfMoJIldCdV/L2GKzWYzuysN/1
	/GumBEceCbaFABLQT0FDfy4W6hBDyhGvjE/RBwgY8Fercg7NI2raGGc+bgtYZDTz4/ErLu
	bI04FQJ+kIrizpByKTlcv8fJSr/4ST4=
Date: Sat, 31 Jan 2026 22:38:18 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
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
 <20260129212510.967611-3-dmatlack@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260129212510.967611-3-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AA08A40003
X-Stat-Signature: xj99earfiwneoaqnudmn75w11yu8au45
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769927916-519739
X-HE-Meta: U2FsdGVkX1/iYyNj+msCJh6sf32I5tHMdn743qHf+3QIAFrBdMLMfYMYOfajtfktr/i/O2tzWJ3cgLVLSTu74EL47+U/atzVsHZ53BQGVRNVr3xSZRMLk7gaNkshIJGmLaVd7qcgGAO3rB2hyizeFF5QprjUB49riD5NDZ1aKByBtmDqaAZSviqId+grMVk8YlRdEjj7wswIsEFoEs28tHuej5QKIfDx8BjUM16lmlKp7fuOqhsFvn1uXltqXWexzM5YZaVa3TKG0AjG4NOmo4bbu8c/ucXlAkq1yb2w+IQrvoVb4ZwTbna4F9XEbzQjH1Kkdzh347jnr70t+nghqnq6FYK1hADVwB7lN+hzx78jNUltfOaGsDlB1UZdOl6mu/bUUcWQGkA0EoDQzJHsmbs+moRQ7aHGu6uHfQf55onp+k9IhlSMAmEhtCtRC8NJVmxO9EdUh4zeaIFj6OQhT26phPvb4Xws7YCv5RCXAedIDR0ab9sfmWLoMrjysZ/z05l+z9lZTrH4jjF5M8AV6H4G5Cw146RnvlQS7pVjR0CDoIQ4uci1/JKVSF2EhTPcp4VEmttWNgUwYB1EHJtZk+l1JBOYvsy6fdqEeAlcmfDYhdGzMRnXjjUWSfBOlFbBMjmb+DnkwdPagiECPPnfNz7QoQrP8UOSM9KcyHkrP6qmHsOMnEZB2vUdcl9+mt7qr4hQbLBIpJmpTRFt2ilUyX+H3SlZtu0KdAcHrVHlDo3LtcUu7jMbgV/0Didb3cLtNCXRNmtwgexz6iqghiuTj5oTlB6ddg/aX5EKoSjWmlPI/5dHKZDVETSltRa7m5+oGsm8Bwq7UFUBikiCUONgSXxZkorSf8F6ITAiu0ynRpd3VY4beUzMOntbeb+LimY/F/Bq7kER0P6wdPfRHnstdbuyiSlD74x9wbrLSQmnISHhJlYSJVAuq7PV9uRfL5g06at2gFGfPQRav+CHYAG
 Str2wJqf
 t9bon1tvAFfDL8NtqkIxGfVoByyt8MfOj2Uc36AwRoZUjtRX6zJmK96kfCZ4xUxF1NlIHb2GharEpBqXBlOXr8dN1IxOOlN9WCjIdNLZIdYUPZ5iHs/PxKaPLfGhHH78PW4TmXU7CYG+xX077mNyXZOQTdPQPTxjj/TGdysCU/WFLYx4tHpCdy2j1Ijxm81rar6KOigEKhvuBMtpYrVr9GMRewBhLOW6HzkoFcD9nv3THZTfRvG5yoSsmpHTc5cWKyu7x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/29 13:24, David Matlack 写道:
> Add an API to enable the PCI subsystem to track all devices that are
> preserved across a Live Update, including both incoming devices (passed
> from the previous kernel) and outgoing devices (passed to the next
> kernel).
>
> Use PCI segment number and BDF to keep track of devices across Live
> Update. This means the kernel must keep both identifiers constant across
> a Live Update for any preserved device. VFs are not supported for now,
> since that requires preserving SR-IOV state on the device to ensure the
> same number of VFs appear after kexec and with the same BDFs.
>
> Drivers that preserve devices across Live Update can now register their
> struct liveupdate_file_handler with the PCI subsystem so that the PCI
> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
> to track the list of incoming and outgoing preserved devices.
>
>    pci_liveupdate_register_fh(driver_fh)
>    pci_liveupdate_unregister_fh(driver_fh)

Can the above 2 functions support the virtual devices? For example, 
bonding, veth, iSWAP and RXE.

These virtual devices do not have BDF. As such, I am not sure if your 
patches take these virtual devices in to account.

Thanks a lot.

Zhu Yanjun

>
> Drivers can notify the PCI subsystem whenever a device is preserved and
> unpreserved with the following APIs:
>
>    pci_liveupdate_outgoing_preserve(pci_dev)
>    pci_liveupdate_outgoing_unpreserve(pci_dev)
>
> After a Live Update, the PCI subsystem fetches its FLB global data
> from the previous kernel from the Live Update Orchestrator (LUO) during
> device initialization to determine which devices were preserved.
>
> Drivers can check if a device was preserved before userspace retrieves
> the file for it via pci_dev->liveupdate_incoming.
>
> Once a driver has finished restoring an incoming preserved device, it
> can notify the PCI subsystem with the following call, which clears
> pci_dev->liveupdate_incoming.
>
>    pci_liveupdate_incoming_finish(pci_dev)
>
> This API will be used in subsequent commits by the vfio-pci driver to
> preserve VFIO devices across Live Update and by the PCI subsystem.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   drivers/pci/Makefile        |   1 +
>   drivers/pci/liveupdate.c    | 212 ++++++++++++++++++++++++++++++++++++
>   drivers/pci/probe.c         |   2 +
>   include/linux/kho/abi/pci.h |  55 ++++++++++
>   include/linux/pci.h         |  47 ++++++++
>   5 files changed, 317 insertions(+)
>   create mode 100644 drivers/pci/liveupdate.c
>   create mode 100644 include/linux/kho/abi/pci.h
>
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 8c259a9a8796..a32f7658b9e5 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
>   obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
>   obj-$(CONFIG_ACPI)		+= pci-acpi.o
>   obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
> +obj-$(CONFIG_LIVEUPDATE)	+= liveupdate.o
>   endif
>   
>   obj-$(CONFIG_OF)		+= of.o
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..182cfc793b80
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#include <linux/bsearch.h>
> +#include <linux/io.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/mutex.h>
> +#include <linux/mm.h>
> +#include <linux/pci.h>
> +#include <linux/sort.h>
> +
> +static DEFINE_MUTEX(pci_flb_outgoing_lock);
> +
> +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_dev *dev = NULL;
> +	int max_nr_devices = 0;
> +	struct pci_ser *ser;
> +	unsigned long size;
> +
> +	for_each_pci_dev(dev)
> +		max_nr_devices++;
> +
> +	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
> +
> +	ser = kho_alloc_preserve(size);
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	ser->max_nr_devices = max_nr_devices;
> +
> +	args->obj = ser;
> +	args->data = virt_to_phys(ser);
> +	return 0;
> +}
> +
> +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_ser *ser = args->obj;
> +
> +	WARN_ON_ONCE(ser->nr_devices);
> +	kho_unpreserve_free(ser);
> +}
> +
> +static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> +{
> +	args->obj = phys_to_virt(args->data);
> +	return 0;
> +}
> +
> +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> +{
> +	kho_restore_free(args->obj);
> +}
> +
> +static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> +	.preserve = pci_flb_preserve,
> +	.unpreserve = pci_flb_unpreserve,
> +	.retrieve = pci_flb_retrieve,
> +	.finish = pci_flb_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_flb pci_liveupdate_flb = {
> +	.ops = &pci_liveupdate_flb_ops,
> +	.compatible = PCI_LUO_FLB_COMPATIBLE,
> +};
> +
> +#define INIT_PCI_DEV_SER(_dev) {		\
> +	.domain = pci_domain_nr((_dev)->bus),	\
> +	.bdf = pci_dev_id(_dev),		\
> +}
> +
> +static int pci_dev_ser_cmp(const void *__a, const void *__b)
> +{
> +	const struct pci_dev_ser *a = __a, *b = __b;
> +
> +	return cmp_int(a->domain << 16 | a->bdf, b->domain << 16 | b->bdf);
> +}
> +
> +static struct pci_dev_ser *pci_ser_find(struct pci_ser *ser,
> +					struct pci_dev *dev)
> +{
> +	const struct pci_dev_ser key = INIT_PCI_DEV_SER(dev);
> +
> +	return bsearch(&key, ser->devices, ser->nr_devices,
> +		       sizeof(key), pci_dev_ser_cmp);
> +}
> +
> +static int pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
> +{
> +	struct pci_dev_ser *dev_ser;
> +	int i;
> +
> +	dev_ser = pci_ser_find(ser, dev);
> +	if (!dev_ser)
> +		return -ENOENT;
> +
> +	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
> +		ser->devices[i] = ser->devices[i + 1];
> +
> +	ser->nr_devices--;
> +	return 0;
> +}
> +
> +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> +{
> +	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> +	struct pci_ser *ser;
> +	int i, ret;
> +
> +	/* Preserving VFs is not supported yet. */
> +	if (dev->is_virtfn)
> +		return -EINVAL;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	if (dev->liveupdate_outgoing)
> +		return -EBUSY;
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return ret;
> +
> +	if (ser->nr_devices == ser->max_nr_devices)
> +		return -E2BIG;
> +
> +	for (i = ser->nr_devices; i > 0; i--) {
> +		struct pci_dev_ser *prev = &ser->devices[i - 1];
> +		int cmp = pci_dev_ser_cmp(&new, prev);
> +
> +		if (WARN_ON_ONCE(!cmp))
> +			return -EBUSY;
> +
> +		if (cmp > 0)
> +			break;
> +
> +		ser->devices[i] = *prev;
> +	}
> +
> +	ser->devices[i] = new;
> +	ser->nr_devices++;
> +	dev->liveupdate_outgoing = true;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_preserve);
> +
> +void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> +	if (WARN_ON_ONCE(ret))
> +		return;
> +
> +	WARN_ON_ONCE(pci_ser_delete(ser, dev));
> +	dev->liveupdate_outgoing = false;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
> +
> +u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return 0;
> +
> +	return ser->nr_devices;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);
> +
> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return;
> +
> +	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);
> +
> +void pci_liveupdate_incoming_finish(struct pci_dev *dev)
> +{
> +	dev->liveupdate_incoming = false;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_finish);
> +
> +int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
> +{
> +	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_register_fh);
> +
> +int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
> +{
> +	return liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_fh);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 37329095e5fe..af6356c5a156 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2060,6 +2060,8 @@ int pci_setup_device(struct pci_dev *dev)
>   	if (pci_early_dump)
>   		early_dump_pci_device(dev);
>   
> +	pci_liveupdate_setup_device(dev);
> +
>   	/* Need to have dev->class ready */
>   	dev->cfg_size = pci_cfg_space_size(dev);
>   
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..6577767f8da6
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#ifndef _LINUX_KHO_ABI_PCI_H
> +#define _LINUX_KHO_ABI_PCI_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +/**
> + * DOC: PCI File-Lifecycle Bound (FLB) Live Update ABI
> + *
> + * This header defines the ABI for preserving core PCI state across kexec using
> + * Live Update File-Lifecycle Bound (FLB) data.
> + *
> + * This interface is a contract. Any modification to any of the serialization
> + * structs defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
> + */
> +
> +#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> +
> +/**
> + * struct pci_dev_ser - Serialized state about a single PCI device.
> + *
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + */
> +struct pci_dev_ser {
> +	u16 domain;
> +	u16 bdf;
> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @max_nr_devices: The length of the devices[] flexible array.
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Flexible array of pci_dev_ser structs for each device. Guaranteed
> + *           to be sorted ascending by domain and bdf.
> + */
> +struct pci_ser {
> +	u64 max_nr_devices;
> +	u64 nr_devices;
> +	struct pci_dev_ser devices[];
> +} __packed;
> +
> +#endif /* _LINUX_KHO_ABI_PCI_H */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 7e36936bb37a..9ead6d84aef6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -40,6 +40,7 @@
>   #include <linux/resource_ext.h>
>   #include <linux/msi_api.h>
>   #include <uapi/linux/pci.h>
> +#include <linux/liveupdate.h>
>   
>   #include <linux/pci_ids.h>
>   
> @@ -582,6 +583,10 @@ struct pci_dev {
>   	u8		tph_mode;	/* TPH mode */
>   	u8		tph_req_type;	/* TPH requester type */
>   #endif
> +#ifdef CONFIG_LIVEUPDATE
> +	unsigned int	liveupdate_incoming:1;	/* Preserved by previous kernel */
> +	unsigned int	liveupdate_outgoing:1;	/* Preserved for next kernel */
> +#endif
>   };
>   
>   static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
> @@ -2854,4 +2859,46 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
>   	WARN_ONCE(condition, "%s %s: " fmt, \
>   		  dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)
>   
> +#ifdef CONFIG_LIVEUPDATE
> +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev);
> +void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev);
> +void pci_liveupdate_setup_device(struct pci_dev *dev);
> +u32 pci_liveupdate_incoming_nr_devices(void);
> +void pci_liveupdate_incoming_finish(struct pci_dev *dev);
> +int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh);
> +int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh);
> +#else /* !CONFIG_LIVEUPDATE */
> +static inline int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
> +{
> +}
> +
> +static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +}
> +
> +static inline u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	return 0;
> +}
> +
> +static inline void pci_liveupdate_incoming_finish(struct pci_dev *dev)
> +{
> +}
> +
> +static inline int pci_liveupdate_register_fh(struct liveupdate_file_handler *fh)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int pci_liveupdate_unregister_fh(struct liveupdate_file_handler *fh)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* !CONFIG_LIVEUPDATE */
> +
>   #endif /* LINUX_PCI_H */
>
-- 
Best Regards,
Yanjun.Zhu


