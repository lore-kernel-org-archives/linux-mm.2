Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144F5109E528
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73B96B0089; Wed, 25 Mar 2026 19:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDA16B008C; Wed, 25 Mar 2026 19:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC54C6B0092; Wed, 25 Mar 2026 19:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1BBE6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:12:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44F121409D5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:12:11 +0000 (UTC)
X-FDA: 84586135662.23.2AC5E9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A401D40008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:12:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EXmipsm5;
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774480329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=oooundxB65Sj4cf79ZYKfovdgx1SXHgHntdl/QRgO4U=;
	b=R+6uLpcwACwwSy6x/NJWrB6yq07rlVfgZTanI8il/0Y92sbWbbHatLKLigjSb4IJNth+Ft
	HG/ChxmNLjmc3RwBSBixphSf07Jcy+oxC3iC1L8AI7qRbUZTplnwYjvuv5xXJRJmqtEtYx
	/hwf6cg4VadgyaVbPiUGSdIZV7B3gHE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EXmipsm5;
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774480329; a=rsa-sha256;
	cv=none;
	b=OjycLM2OcM/RTh20blXzyNhJ3foCVyGOybDCaZt2aynGAiSXJQi7xT4syJDKlyZHfj1ITf
	NI8Hc0qL3Lct+JYT1aoeeZ4xxwwnBswCWmw4Kp4dAKQXqH6QRGqvo7uReQ00wMMagqnfPr
	tjSkP/602XZYeSzBqy07tI8Uku7NYiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3D3160053;
	Wed, 25 Mar 2026 23:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFAFC4CEF7;
	Wed, 25 Mar 2026 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774480328;
	bh=Gw/bZ+ZhxB50horVj011SHxSz4iN0d250AG4e1a3Zpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=EXmipsm5nrnGwOesj66NjosrqMAR8uumvBJRDUYKAapbkohHsOgYGB47opQ8DGhJ8
	 HQJeG+WPhDUSf0bnwEb3QkitroJhqUMxSAHeKOxIxahZ/PELwbLUFGWfhjipeXiXqh
	 oJWPEPe7knxfgIbJ3kEIwH1nRSRDi3sijshD9fi5vyDOOAGnYpvfoaautdjcTrvRLq
	 iPMbIpDRg7Lf4e0LMrzbhB4oVBlJawoOucc8dtxyFwUlzWbF6/GcGlZF3yLuFSbMsV
	 gc+Nb28zxU8dPlbJl92pEUXNKhwsZdnwvUN/7MGAZDIX5r6qqqpjxpFeUgqAVq3p9V
	 eDFu7u4Wd+Ogw==
Date: Wed, 25 Mar 2026 18:12:07 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260325231207.GA1292813@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323235817.1960573-3-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A401D40008
X-Stat-Signature: 6gtkgbaksdegmwno41x8pnbu3ra8wyhw
X-Rspam-User: 
X-HE-Tag: 1774480329-993904
X-HE-Meta: U2FsdGVkX19oEhpdpxWrm0K1FE8q2U00ZdO5ZvM7zA4HgX25W5Iqo14xxPq02DJv9PLlA0b5t4+zVKipXkm29RAlfb0JLw8BTpZHOVkYffiagltZL4u5XIvAB1Z+kWrLS/1wp2u2SMUijoSsPHZCHrAP+aeaY2G6vz7/Wc7VYxpXXj07mzBjgcSjcWvD89r2hCG86cMbzrG+aUuxs42knJWDfMXC1uxKjyKzK6gEkywy0ObsKHbHIUyUBnQgJr5lTkLm5Xjellx9PyLMdr7Kvq7iYHKeNyGyzHvRGBhvypOae7HvldQiOAkmAK2OjDi4ONxmpQkdviauKqD5AsrfLCE8pg9wA0XZc7uPDtRts5ULjVhyKvrKBZgyviLNjyEyKVkLERfqD90niuZac4UxoiVLJgkzmxXCpxSMgDPpo/E6sVStuj33UjXAc+ejxRW8E5+Oe6eG0RTrgZ92DaBqmEYSRIw4rYTV3a3X29XSbChIJ0QiSSxfxA8CFpk96Og/ajm8psYFg9peYeQX9OSNdyfhoO2QI3eLDdCCETNdnPkKMHOmEhwrpzOMAI4GQQw2U4TQvzlwyIKZ50DxVBzGAlzoHFbDLtQh2eE97S91Zq09+MlMa4HHhK3fVJ54zhmYGxZHLlo2aBgN/vFmkKV/p+sQCKFynbHvjwx5+A3H5ZpF8LCjtVrY8ut7ajpsAiB71pOBrjmkX1x59n+7a/lvEKPvplaTC4gbjMYTeMHFJRO0+I6dey62RX3lrqZR+/az4pczeHresvGaPsrHeirXJS9Z4uHRJ3k8CcFL59OikGiLRDMMROkPL8E0z//B7XxL/tNsj9uP+fLfhqegwXhlldtLB2RVMtHOza4rqhh0tW6QTlr3Sb0P7iZLd2X1TZTTu5KRkQb+JXL4u9cGxKtYD+1+KjC0GKoNG/Fz1Jy4j3S34/bEnvplR/0ETZoPH+VFbvKOnLHj2Wn2S36q4JG
 C2pjBjE/
 BP7zRUneAdQKx+3YecwTHgep9CUfFDLglHH06NrvOuylj9IX88XvUKP1/CqLsw2u4uI//WyvEGwhza+E4UIlkxu+94882dZK1bQvdUJkw0uZu2EB+fpMPYOGSCPaWiqUmbabgPCgB5tWgd8tVDE83Tqouaw4U9SS14GllUfHyXLCb5pbXAo6vGYu3YUkCh0b23SHan7RAbIbIMFmkiMpn4zGAiXa6/T+9WPiNvPEfcEqGmlBdHlWzzBfVienKETr/DYu+Hwd+rYkFaW8qo9oZQKdEeswescLK0Sta6DYjKWLEyLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:57:54PM +0000, David Matlack wrote:
> Add an API to enable the PCI subsystem to participate in a Live Update
> and track all devices that are being preserved by drivers. Since this
> support is still under development, hide it behind a new Kconfig
> PCI_LIVEUPDATE that is marked experimental.

Can you list the interfaces being added here, e.g.,

  pci_liveupdate_register_flb() - register driver's liveupdate_file_handler
  pci_liveupdate_unregister_flb()
  pci_liveupdate_preserve() - preserve device across LU kexec
  pci_liveupdate_unpreserve() - cancel device preservation
  pci_liveupdate_retrieve() - not sure?
  pci_liveupdate_finish()

I think it's nice to have an idea of what pieces to look for before
reading the patch.

> This API will be used in subsequent commits by the vfio-pci driver to
> preserve VFIO devices across Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/Kconfig         |  11 ++
>  drivers/pci/Makefile        |   1 +
>  drivers/pci/liveupdate.c    | 380 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h           |  14 ++
>  drivers/pci/probe.c         |   2 +
>  include/linux/kho/abi/pci.h |  62 ++++++
>  include/linux/pci.h         |  41 ++++
>  7 files changed, 511 insertions(+)
>  create mode 100644 drivers/pci/liveupdate.c
>  create mode 100644 include/linux/kho/abi/pci.h
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index e3f848ffb52a..05307d89c3f4 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -334,6 +334,17 @@ config VGA_ARB_MAX_GPUS
>  	  Reserves space in the kernel to maintain resource locking for
>  	  multiple GPUS.  The overhead for each GPU is very small.
>  
> +config PCI_LIVEUPDATE
> +	bool "PCI Live Update Support (EXPERIMENTAL)"
> +	depends on PCI && LIVEUPDATE
> +	help
> +	  Support for preserving PCI devices across a Live Update. This option
> +	  should only be enabled by developers working on implementing this
> +	  support. Once enough support as landed in the kernel, this option
> +	  will no longer be marked EXPERIMENTAL.

This would be a good place for a one-sentence explanation of what
"preserving PCI devices" means.  Obviously the physical devices stay
there; what's interesting is that the hardware continues operating
without interruption across the update.

s/support as landed/support has landed/ (maybe no need for this
sentence at all)

> +	  If unsure, say N.
> +
>  source "drivers/pci/hotplug/Kconfig"
>  source "drivers/pci/controller/Kconfig"
>  source "drivers/pci/endpoint/Kconfig"
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 41ebc3b9a518..e8d003cb6757 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_PROC_FS)		+= proc.o
>  obj-$(CONFIG_SYSFS)		+= pci-sysfs.o slot.o
>  obj-$(CONFIG_ACPI)		+= pci-acpi.o
>  obj-$(CONFIG_GENERIC_PCI_IOMAP) += iomap.o
> +obj-$(CONFIG_PCI_LIVEUPDATE)	+= liveupdate.o
>  endif
>  
>  obj-$(CONFIG_OF)		+= of.o
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..bec7b3500057
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,380 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +/**
> + * DOC: PCI Live Update
> + *
> + * The PCI subsystem participates in the Live Update process to enable drivers
> + * to preserve their PCI devices across kexec.
> + *
> + * Device preservation across Live Update is built on top of the Live Update
> + * Orchestrator (LUO) support for file preservation across kexec. Userspace
> + * indicates that a device should be preserved by preserving the file associated
> + * with the device with ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)``.
> + *
> + * .. note::
> + *    The support for preserving PCI devices across Live Update is currently
> + *    *partial* and should be considered *experimental*. It should only be
> + *    used by developers working on the implementation for the time being.
> + *
> + *    To enable the support, enable ``CONFIG_PCI_LIVEUPDATE``.
> + *
> + * Driver API
> + * ==========
> + *
> + * Drivers that support file-based device preservation must register their
> + * ``liveupdate_file_handler`` with the PCI subsystem by calling
> + * ``pci_liveupdate_register_flb()``. This ensures the PCI subsystem will be
> + * notified whenever a device file is preserved so that ``struct pci_ser``
> + * can be allocated to track all preserved devices. This struct is an ABI
> + * and is eventually handed off to the next kernel via Kexec-Handover (KHO).
> + *
> + * In the "outgoing" kernel (before kexec), drivers should then notify the PCI
> + * subsystem directly whenever the preservation status for a device changes:
> + *
> + *  * ``pci_liveupdate_preserve(pci_dev)``: The device is being preserved.
> + *
> + *  * ``pci_liveupdate_unpreserve(pci_dev)``: The device is no longer being
> + *    preserved (preservation is cancelled).
> + *
> + * In the "incoming" kernel (after kexec), drivers should notify the PCI
> + * subsystem with the following calls:
> + *
> + *  * ``pci_liveupdate_retrieve(pci_dev)``: The device file is being retrieved
> + *    by userspace.

I'm not clear on what this means.  Is this telling the PCI core that
somebody else (userspace?) is doing something?  Why does the PCI core
care?  The name suggests that this interface would retrieve some data
from the PCI core, but that doesn't seem to be what's happening.

> + *
> + *  * ``pci_liveupdate_finish(pci_dev)``: The device is done participating in
> + *    Live Update. After this point the device may no longer be even associated
> + *    with the same driver.

This sets "dev->liveupdate_incoming = false", and the only place we
check that is in pci_liveupdate_retrieve().  In particular, there's
nothing in the driver bind/unbind paths that seems related.  I guess
pci_liveupdate_finish() just means the driver can't call
pci_liveupdate_retrieve() any more?

> + *
> + * Incoming/Outgoing
> + * =================
> + *
> + * The state of each device's participation in Live Update is stored in
> + * ``struct pci_dev``:
> + *
> + *  * ``liveupdate_outgoing``: True if the device is being preserved in the
> + *    outgoing kernel. Set in ``pci_liveupdate_preserve()`` and cleared in
> + *    ``pci_liveupdate_unpreserve()``.
> + *
> + *  * ``liveupdate_incoming``: True if the device is preserved in the incoming
> + *    kernel. Set during probing when the device is first created and cleared
> + *    in ``pci_liveupdate_finish()``.
> + *
> + * Restrictions
> + * ============
> + *
> + * Preserved devices currently have the following restrictions. Each of these
> + * may be relaxed in the future.
> + *
> + *  * The device must not be a Virtual Function (VF).
> + *
> + *  * The device must not be a Physical Function (PF).
> + *
> + * Preservation Behavior
> + * =====================
> + *
> + * The kernel preserves the following state for devices preserved across a Live
> + * Update:
> + *
> + *  * The PCI Segment, Bus, Device, and Function numbers assigned to the device
> + *    are guaranteed to remain the same across Live Update.
> + *
> + * This list will be extended in the future as new support is added.
> + *
> + * Driver Binding
> + * ==============
> + *
> + * It is the driver's responsibility for ensuring that preserved devices are not
> + * released or bound to a different driver for as long as they are preserved. In
> + * practice, this is enforced by LUO taking an extra referenced to the preserved

s/responsibility for ensuring/responsibility to ensure/
s/referenced/reference/

> + * device file for as long as it is preserved.
> + *
> + * However, there is a window of time in the incoming kernel when a device is
> + * first probed and when userspace retrieves the device file with
> + * ``LIVEUPDATE_SESSION_RETRIEVE_FD`` when the device could be bound to any
> + * driver.

  ... window of time in the incoming kernel between a device being
  probed and userspace retrieving the device file ... when the device
  could be bound ...

I'm not sure what it means to retrieve a device file.  It doesn't
sound like the usual Unix "device file" or "special file" in /dev/,
since those aren't "retrieved".

> + * It is currently userspace's responsibility to ensure that the device is bound
> + * to the correct driver in this window.
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
> +#include "pci.h"
> +
> +static DEFINE_MUTEX(pci_flb_outgoing_lock);

It'd be handy if there were some excuse to mention "FLB" and expand it
once in the doc above, since I have no idea what it means or where to
look for it.  Maybe unfortunate that it will be pronounced "flub" ;)

> +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_dev *dev = NULL;
> +	int max_nr_devices = 0;
> +	struct pci_ser *ser;
> +	unsigned long size;
> +
> +	/*
> +	 * Don't both accounting for VFs that could be created after this
> +	 * since preserving VFs is not supported yet. Also don't account
> +	 * for devices that could be hot-plugged after this since preserving
> +	 * hot-plugged devices across Live Update is not yet an expected
> +	 * use-case.

s/Don't both accounting/Don't bother accounting/ ? not sure of intent

I suspect the important thing here is that this allocates space for
preserving X devices, and each subsequent pci_liveupdate_preserve()
call from a driver uses up one of those slots.

My guess is this is just an allocation issue and from that point of
view there's no actual problem with enabling VFs or hot-adding devices
after this point; it's just that pci_liveupdate_preserve() will fail
after X calls.

> +	 */
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

I guess this means somebody (userspace?) called .unpreserve() before
all the drivers that had called pci_liveupdate_preserve() have also
called pci_liveupdate_unpreserve()?

If this is userspace-triggerable, maybe it's worth a meaningful
message including one or more of the device IDs from ser->devices[]?

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
> +	return cmp_int((u64)a->domain << 16 | a->bdf,
> +		       (u64)b->domain << 16 | b->bdf);
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
> +static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
> +{
> +	struct pci_dev_ser *dev_ser;
> +	int i;
> +
> +	dev_ser = pci_ser_find(ser, dev);
> +
> +	/*
> +	 * This should never happen unless there is a kernel bug or
> +	 * corruption that causes the state in struct pci_ser to get
> +	 * out of sync with struct pci_dev.

Corruption can be a bug anywhere and isn't really worth mentioning,
but the "out of sync" part sounds like it glosses over something
important.

I guess this happens if there was no successful
pci_liveupdate_preserve(X) before calling
pci_liveupdate_unpreserve(X)?  That does sound like a kernel bug (I
suppose a VFIO or other driver bug?), and I would just say what
happened directly instead of calling it "out of sync".

> +	 */
> +	if (pci_WARN_ONCE(dev, !dev_ser, "Cannot find preserved device!"))

Seems like an every-time sort of message if this indicates a driver bug?

It's enough of a hassle to convince myself that pci_WARN_ONCE()
returns the value that caused the warning that I would prefer:

  if (!dev_ser) {
    pci_warn(...) or pci_WARN_ONCE(...)
    return;
  }

> +		return;
> +
> +	for (i = dev_ser - ser->devices; i < ser->nr_devices - 1; i++)
> +		ser->devices[i] = ser->devices[i + 1];
> +
> +	ser->nr_devices--;
> +}
> +
> +int pci_liveupdate_preserve(struct pci_dev *dev)
> +{
> +	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> +	struct pci_ser *ser;
> +	int i, ret;
> +
> +	/* SR-IOV is not supported yet. */
> +	if (dev->is_virtfn || dev->is_physfn)
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
> +		/*
> +		 * This should never happen unless there is a kernel bug or
> +		 * corruption that causes the state in struct pci_ser to get out
> +		 * of sync with struct pci_dev.

Huh.  Same comment as above.  I don't think this is telling me
anything useful.  I guess what happened is we're trying to preserve X
and X is already in "ser", but we should have returned -EBUSY above
for that case.  If we're just saying memory corruption could cause
bugs, I think that's pointless.

Actually I'm not even sure we should check for this.

> +		 */
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
> +EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
> +
> +void pci_liveupdate_unpreserve(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int ret;
> +
> +	/* This should never happen unless the caller (driver) is buggy */
> +	if (WARN_ON_ONCE(!dev->liveupdate_outgoing))

Why once?  Is there some situation where we could get a flood?  Since
we have a pci_dev, maybe a pci_warn() that would indicate the driver
and device would be more useful?

> +		return;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> +
> +	/* This should never happen unless there is a bug in LUO */
> +	if (WARN_ON_ONCE(ret))

Is LUO completely in-kernel?  I think this warning message would be
kind of obscure if this is something that could be triggered by a
userspace bug.  Also, we do have the pci_dev, which a WARN_ON_ONCE()
doesn't take advantage of at all.

> +		return;
> +
> +	pci_ser_delete(ser, dev);
> +	dev->liveupdate_outgoing = false;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> +
> +static int pci_liveupdate_flb_get_incoming(struct pci_ser **serp)
> +{
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)serp);
> +
> +	/* Live Update is not enabled. */
> +	if (ret == -EOPNOTSUPP)
> +		return ret;
> +
> +	/* Live Update is enabled, but there is no incoming FLB data. */
> +	if (ret == -ENODATA)
> +		return ret;
> +
> +	/*
> +	 * Live Update is enabled and there is incoming FLB data, but none of it
> +	 * matches pci_liveupdate_flb.compatible.
> +	 *
> +	 * This could mean that no PCI FLB data was passed by the previous
> +	 * kernel, but it could also mean the previous kernel used a different
> +	 * compatibility string (i.e.a different ABI). The latter deserves at
> +	 * least a WARN_ON_ONCE() but it cannot be distinguished from the
> +	 * former.

This says both "there is incoming FLB data" and "no PCI FLB data".  I
guess maybe it's possible to have FLB data but no *PCI* FLB data?

s/i.e.a/i.e., /

> +	 */
> +	if (ret == -ENOENT) {
> +		pr_info_once("PCI: No incoming FLB data detected during Live Update");

Not sure "FLB" will be meaningful to users here.  Maybe we could say
something like ("no FLB data compatible with %s\n", pci_liveupdate_flb.compatible)?

> +		return ret;
> +	}
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but it cannot be retrieved. Proceed with standard initialization as
> +	 * if there was not incoming PCI FLB data.

s/if there was not/if there was no/

> +	 */
> +	WARN_ONCE(ret, "PCI: Failed to retrieve incoming FLB data during Live Update");
> +	return ret;
> +}
> +
> +u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	struct pci_ser *ser;
> +
> +	if (pci_liveupdate_flb_get_incoming(&ser))
> +		return 0;

Seems slightly overcomplicated to return various error codes from
pci_liveupdate_flb_get_incoming(), only to throw them away here and
special-case the "return 0".  I think you *could* set
"ser->nr_devices" to zero at entry to
pci_liveupdate_flb_get_incoming() and make this just:

  pci_liveupdate_flb_get_incoming(&ser);
  return ser->nr_devices;

> +	return ser->nr_devices;
> +}
> +
> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +
> +	if (pci_liveupdate_flb_get_incoming(&ser))
> +		return;
> +
> +	if (!pci_ser_find(ser, dev))
> +		return;

If pci_liveupdate_flb_get_incoming() set ser->nr_devices to zero at
entry, the bsearch() in pci_ser_find() would return NULL if there were
no devices to search:

  pci_liveupdate_flb_get_incoming(&ser);
  if (!pci_ser_find(ser, dev))
    return;

> +	dev->liveupdate_incoming = true;
> +}
> +
> +int pci_liveupdate_retrieve(struct pci_dev *dev)
> +{
> +	if (!dev->liveupdate_incoming)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_retrieve);
> +
> +void pci_liveupdate_finish(struct pci_dev *dev)
> +{
> +	dev->liveupdate_incoming = false;
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
> +
> +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> +{
> +	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> +
> +void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> +{
> +	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 13d998fbacce..979cb9921340 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1434,4 +1434,18 @@ static inline int pci_msix_write_tph_tag(struct pci_dev *pdev, unsigned int inde
>  	(PCI_CONF1_ADDRESS(bus, dev, func, reg) | \
>  	 PCI_CONF1_EXT_REG(reg))
>  
> +#ifdef CONFIG_PCI_LIVEUPDATE
> +void pci_liveupdate_setup_device(struct pci_dev *dev);
> +u32 pci_liveupdate_incoming_nr_devices(void);
> +#else
> +static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +}
> +
> +static inline u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bccc7a4bdd79..c60222d45659 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2064,6 +2064,8 @@ int pci_setup_device(struct pci_dev *dev)
>  	if (pci_early_dump)
>  		early_dump_pci_device(dev);
>  
> +	pci_liveupdate_setup_device(dev);
> +
>  	/* Need to have dev->class ready */
>  	dev->cfg_size = pci_cfg_space_size(dev);
>  
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..7764795f6818
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h

It seems like most of include/linux/ is ABI, so does kho/abi/ need to
be separated out in its own directory?

It's kind of unusual for the hierarchy to be this deep, especially
since abi/ is the only thing in include/linux/kho/.

