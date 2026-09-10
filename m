Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2001C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0890F6B00A1; Thu, 10 Sep 2026 19:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A896B00A2; Thu, 10 Sep 2026 19:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46D16B00A3; Thu, 10 Sep 2026 19:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEEB6B00A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:48:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABC9D40683
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:48:28 +0000 (UTC)
X-FDA: 85199494296.26.F7192E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE02518000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:48:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPFD3EsR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=veei4zxnSmGQSdcpRlhDQcyCNXo82aQ5tDwmq9b9C9g=;
	b=NSX22iol3Q4H7cy5KVUR2lM2xPdvzQdSDJJj0MXRIICGVhqzqUfYpTfg77epcgaGy42E0Z
	HN6dnLqOJ5K5fJEMqSzz/rI2UGEfB3whAsRk6Kq0Cv9iRByi8UgTyEJX0G915ZfhxVUykk
	e7leTbtDZZsN5a+Mo/QtTtjNvov/Dj8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084107;
	b=Swj9U6Va/4tbtGUugmlBOHWfdibDYMHLhFym5qIJl/B2biLudoXaT4IumW39DzfqbtTgqm
	87Z4N8OVtWuRNJFKvW12Fcgle+DAXaIWXu6eqJfxMwVS+NAbHXDnGrM9xQJjeUQwyPLb0q
	k5UgtabKIoZnHC3gecSGKC/86Sf6+Pw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPFD3EsR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DB66435CD;
	Thu, 10 Sep 2026 23:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359201F000FF;
	Thu, 10 Sep 2026 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084105;
	bh=veei4zxnSmGQSdcpRlhDQcyCNXo82aQ5tDwmq9b9C9g=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=VPFD3EsRcr4ia0sKruJohfqNMlr0NVwgC2Ew7jj25LFYREBdckasctt5X5XrbDg2s
	 l1s9JR5H9rwkZP+oMf0dARzjSWFPSzgEGSwo0E4FAKUSK8ZxuVMrQ9vWpAN38ZCy4i
	 zcl/EGT5+6gWDxhv4pX0uEiJer7TjC1TuwK2WU5OQAdkO88J9gjriMZwoV+7FUYOsE
	 9PL3U2gmyViGURsIseLdyUQbO0UsayyXUSuMysDSTnHFAR3wLkT0ZPqHFl2oEAIn1k
	 TM3nI+8zvWasXzt356+nogS+PTuKt4IgACezaOw3gI560jBnM4AWXnhtIo4jz84Hw9
	 UvC/f8SMtIojg==
Date: Thu, 10 Sep 2026 18:48:24 -0500
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
Subject: Re: [PATCH v8 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260910234824.GA366888@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-2-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE02518000B
X-Stat-Signature: p75c8ff3i7q36p45t7zwgyr7d6ozye6d
X-HE-Tag: 1789084106-9606
X-HE-Meta: U2FsdGVkX1+RUSE+iW369dGrBqZqwaZxfuSeFtiUH/WR8+9Q3hsb9kZ51Ys1IPELHfd6/2bc+NTmqjgs/TqemC53sacxDNSNbz9nl4z7YTBoRgGyx1JokMintehxPzAliuQCCveR5KaX+c2nCm7yjH29qRPxs9XpBSk+up9lw3pVikKzzI+l+7mepSWAin6fUljUEChwZ/YBZgi1ftDhFcp7yDti7Rn1/DppQ/N+LOBdpM/riay7ujEX0RLZyDYnOsWwOYpGRnTvSgE45yv/LshtoisBls1mELOK5ksRXm8a37GqVy+WeCLMp8B4afcJ3rbjlpCpi3Lj7cga+iePLuhQuRMHlIBBNnNtOJJYuB62Idh40EPC+cs7T7lUa4ffAIQmBjUQpivtzmm2hL81mFHAUcK7DyCpp3aVhiwUGEKNoxqFbKFepVQZxvEdXTOM/iY8Wat6w+4K3w6UrIN5Dr65mD1mvRtquDTKa5+T/Ecf+QUEPaeYAwx0d+FRs/4rYowEpgPnHztml/eVzsfDZW2v05OKwquGIU7OW+ur2ARdSo1sLXwXaYAOa5pMozQegd/wy8d7FrcVX0mq5oaGv/D4hEwPqc7dZI7a20KRjgpbQ5S3MHCI4QU68YuIWSmPoK0BLR7VS6s4xOZ5jGmfmL4bfyIdlrThvIlKxADvIOWDSTRFGuZkjiZO4GqIThs+NBXl1DtOASIpUD00WFkZ1s8bfC7lsHNNvk2AEf6FUrsZQyC3I6ikZmFb5k2BlM3QZA8rkIE29kIvmTbO4G2pFxT3Q8ClT7CNQh0AYb63CEoRO8Ac17yFr3E9X2QUBGpsi7qo1a6mSTceepbqM0RQDoKc2BypvOYDkxwnVrVuYU6kGMUKuyrQwxAAzZlyT+PYJOuI6xtaWjP54T8G/pcb2lAnwStk2tHOOTzV8Lz98wOymu9tFV29ETn2boWlh965nF3gQTf0ikb6LOqj3zn
 kd60yAkr
 P6qT08B8lhudEVqpZ7RQ8y8EOS0pO4TtYomO5BoR+dVjVnrXI4SNtYOoFWv0AYrOqBK8hY3XPjzuUc43b26AB2KLpvGPp4yNx4TpHlhH3B0dLDRzMAmDbdarixSjNf0PrQKhus4mlxjikxHZ5OPCQaullzZzybHtyOxMEW46svsSI4pQnUu4MjhlpYQFUuPe/JMrR7WXXnOq3UsQ+Xmzmx773p6Gca2yjAC1VPoGsT8ssJjbxn97TDMfGVvluPvyxgp9JxwJCMGfitz4IGe30MdAWAUwZ5l7YQBHcw2eDV6YjooYnGcQUFmELx296fijhgVh+IVBskKoPtMHLUNrwQats41pOz/eyCpgq+PVIZBhwYnsRElJi//pV7BG7GpdLl9jjVFdGIziH04N168PeQq+CYcrmg4yldulR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:55PM +0000, David Matlack wrote:
> Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> it to participate in the preservation of PCI devices across Live Update.
> Essentially, this commit enables the PCI core to allocate a struct
> (struct pci_ser) and preserve it across a Live Update whenever at least
> one device is preserved.

I assume pci_ser is the state the PCI core needs to preserve across
kexec so the new kernel's enumeration doesn't interrupt the device
operation.  And that whatever state the endpoint drivers need to
adopt/inherit the device in the new kernel is managed without any help
from the PCI core?

> Preserving PCI devices across Live Update is built on top of the Live
> Update Orchestrator's (LUO) support for file preservation. Drivers are
> expected to expose a file to userspace to represent a single PCI device
> and support preservation of that file. This is intended primarily to
> support preservation of PCI devices bound to VFIO drivers.

Where do drivers expose this file?  sysfs?  I guess it's a file per
preserved device?  Thinking like a driver writer, I'm expecting a hint
about how to expose this file (should also be in the file doc somehere
if it's not already).

> This commit enables drivers to register their liveupdate_file_handler
> with the PCI core so that the PCI core can do its own tracking and
> enforcement of which devices are preserved.
> 
>   pci_liveupdate_register_flb(driver_file_handler);
>   pci_liveupdate_unregister_flb(driver_file_handler);

So a driver calls pci_liveupdate_register_flb() once, then
pci_liveupdate_preserve() once for each device it wants preserved?

> When the first file (with a handler registered with the PCI core) is
> preserved, the PCI core will be notified to allocate its tracking struct
> (pci_ser).

The passive voice here makes the actors a bit obscure.  I guess a
LIVEUPDATE_SESSION_PRESERVE_FD ioctl on some per-device file kicks
this off?

I guess the pci_ser allocation is in
pci_liveupdate_flb_ops.preserve(), i.e., pci_flb_preserve()?

So the PCI core tracker (pci_ser) isn't actually allocated at the time
of pci_liveupdate_register_flb(); it's allocated on the first
LIVEUPDATE_SESSION_PRESERVE_FD ioctl for a driver that has called
pci_liveupdate_register_flb()?

IIUC the call tree for that ioctl looks something like this:

  <driver>
    pci_liveupdate_register_flb
      liveupdate_register_flb(fh, &pci_liveupdate_flb)

  luo_session_ioctl
    op = &luo_session_ioctl_ops[...]
    op->execute                               # eg luo_session_preserve_fd()
      luo_session_preserve_fd
        luo_preserve_file
          luo_flb_file_preserve
            luo_flb_file_preserve_one
              if (outgoing_count == 0)        # only for first FLB device
                flb->ops->preserve            # eg pci_flb_preserve()
                  pci_flb_preserve
                    ser = kho_alloc_preserve  <-- alloc pci_ser
                outgoing.count = 1
          fh->ops->preserve                   # something not included here

  pci_liveupdate_preserve
    pci_liveupdate_preserve_device
      dev_ser = pci_flb_alloc_dev_ser  <-- alloc per-dev PCI core serialized state
      dev_ser->bdf = pci_dev_id(dev)

Seems like kind of an awkward way to allocate pci_ser.  Couldn't it be
allocated on the first call to pci_liveupdate_register_flb()?  That
would be a lot easier for driver writers to trace through.

> When the last file is unpreserved (i.e. preservation
> cancelled) the PCI core will be notified to free struct pci_ser.

There's a lot going on behind "PCI core will be notified".  I assume
these refer to the first-time behavior of luo_flb_file_preserve_one()
and last-time behavior of liveupdate_flb_put_outgoing(), which is
honestly kind of hard to suss out.

This series doesn't include a caller of pci_liveupdate_preserve() (or
pci_liveupdate_register_flb()), so I can't figure out the ordering.
Obviously pci_liveupdate_register_flb() must be first.

I first thought pci_liveupdate_preserve() would be called via the
fh->ops->preserve() in the luo_session_preserve_fd() ioctl path, but
it's not.  pci_liveupdate_preserve() is intended for the driver to
call it directly.  But it looks like it has to be called *after* the
ioctl?  Obviously I'm confused :)

> This struct is preserved across a Live Update using KHO and can be
> fetched by the PCI core during early boot (e.g. during device
> enumeration) so that it knows which devices were preserved.
> 
> Note: This commit only allocates struct pci_ser and preserves it across
> Live Update. A subsequent commit will add an API for drivers to tell the
> PCI core exactly which devices are being preserved.
> 
> Note: There is no reason to check for kho_is_enabled() since it can be
> assumed to return true. If KHO was not enabled then Live Update would
> not be enabled and these routines would never run.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  Documentation/core-api/liveupdate.rst |   4 +
>  MAINTAINERS                           |  13 +++
>  drivers/pci/Kconfig                   |  15 +++
>  drivers/pci/Makefile                  |   1 +
>  drivers/pci/liveupdate.c              | 158 ++++++++++++++++++++++++++
>  include/linux/kho/abi/pci.h           |  63 ++++++++++
>  include/linux/pci.h                   |   1 +
>  include/linux/pci_liveupdate.h        |  30 +++++
>  8 files changed, 285 insertions(+)
>  create mode 100644 drivers/pci/liveupdate.c
>  create mode 100644 include/linux/kho/abi/pci.h
>  create mode 100644 include/linux/pci_liveupdate.h
> 
> diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> index 5a292d0f3706..b3c689e633c1 100644
> --- a/Documentation/core-api/liveupdate.rst
> +++ b/Documentation/core-api/liveupdate.rst
> @@ -1,5 +1,7 @@
>  .. SPDX-License-Identifier: GPL-2.0
>  
> +.. _luo:
> +
>  ========================
>  Live Update Orchestrator
>  ========================
> @@ -18,6 +20,8 @@ LUO Preserving File Descriptors
>  .. kernel-doc:: kernel/liveupdate/luo_file.c
>     :doc: LUO File Descriptors
>  
> +.. _flb:
> +
>  LUO File Lifecycle Bound Global Data
>  ====================================
>  .. kernel-doc:: kernel/liveupdate/luo_flb.c
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a3ed337e827d..9cc7b9291ace 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20824,6 +20824,19 @@ L:	linux-pci@vger.kernel.org
>  S:	Supported
>  F:	Documentation/PCI/pci-error-recovery.rst
>  
> +PCI LIVE UPDATE
> +M:	David Matlack <dmatlack@google.com>
> +R:	Pasha Tatashin <pasha.tatashin@soleen.com>
> +R:	Mike Rapoport <rppt@kernel.org>
> +R:	Pratyush Yadav <pratyush@kernel.org>
> +L:	kexec@lists.infradead.org
> +L:	linux-pci@vger.kernel.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> +F:	drivers/pci/liveupdate.c
> +F:	include/linux/kho/abi/pci.h
> +F:	include/linux/pci_liveupdate.h
> +
>  PCI MSI DRIVER FOR ALTERA MSI IP
>  L:	linux-pci@vger.kernel.org
>  S:	Orphan
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 0c7408509ba2..3781e2b5f095 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -271,6 +271,21 @@ config VGA_ARB_MAX_GPUS
>  	  Reserves space in the kernel to maintain resource locking for
>  	  multiple GPUS.  The overhead for each GPU is very small.
>  
> +config PCI_LIVEUPDATE
> +	bool "PCI Live Update Support"
> +	depends on PCI && LIVEUPDATE
> +	help
> +	  Enable PCI core support for preserving PCI devices across Live
> +	  Update. This, in combination with support in a device's driver,
> +	  enables PCI devices to run and perform memory transactions
> +	  uninterrupted during a kexec for Live Update.
> +
> +	  This option should only be enabled by users who plan to use Live
> +	  Update for kernel upgrades and require preserving PCI devices during
> +	  those upgrades.
> +
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
> index 000000000000..fffb41a66ca7
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,158 @@
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
> + * :ref:`FLB <flb>` Data
> + * =====================
> + *
> + * PCI device preservation across Live Update is built on top of the
> + * :ref:`LUO <luo>` support for file preservation across kexec. Drivers are
> + * expected to expose a file to represent a single PCI device and support
> + * preservation of that file with ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)``.
> + * This allows userspace to control the preservation of devices and ensure
> + * proper lifecycle management while a device is preserved. The first intended
> + * use-case is preserving vfio-pci device files.
> + *
> + * The PCI core maintains its own state about what devices are being preserved
> + * across Live Update using FLB data in LUO. Essentially, this allows the PCI
> + * core to allocate struct pci_ser when the first device (file) is preserved
> + * and free it when the last device (file) is unpreserved. After kexec, the
> + * PCI core can fetch the struct pci_ser (which was constructed by the previous
> + * kernel) from LUO at any time (e.g. during enumeration) so that it knows
> + * which devices were preserved.
> + *
> + * To enable the PCI core to be notified whenever a file representing a device
> + * is preserved, drivers must register their struct liveupdate_file_handler with
> + * the PCI core by using the following APIs:
> + *
> + *  * ``pci_liveupdate_register_flb(driver_file_handler)``
> + *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
> + */
> +
> +#define pr_fmt(fmt) "PCI: liveupdate: " fmt
> +
> +#include <linux/io.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/pci.h>
> +#include <linux/kho_block.h>
> +#include <linux/liveupdate.h>
> +#include <linux/mm.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +
> +/**
> + * struct pci_flb_outgoing - Outgoing PCI FLB object
> + * @ser: Pointer to the preserved struct pci_ser.
> + * @block_set: The KHO block set holding the outgoing devices.
> + *
> + * This structure holds the runtime state for the outgoing PCI Live Update
> + * state. It wraps the serialized pci_ser and the block_set used to manage
> + * the serialized entries.
> + */
> +struct pci_flb_outgoing {
> +	struct pci_ser *ser;
> +	struct kho_block_set block_set;
> +};
> +
> +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
> +	struct pci_ser *ser;
> +
> +	outgoing = kzalloc_obj(*outgoing);
> +	if (!outgoing)
> +		return -ENOMEM;
> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	ser->version = PCI_LUO_FLB_VERSION;
> +	ser->nr_devices = 0;
> +	ser->devices = 0;
> +
> +	outgoing->ser = ser;
> +	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
> +
> +	args->obj = no_free_ptr(outgoing);
> +	args->data = virt_to_phys(ser);
> +	pr_debug("Preserved struct pci_ser (0x%llx)\n", args->data);
> +	return 0;
> +}
> +
> +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_flb_outgoing *outgoing = args->obj;
> +
> +	pr_debug("Unpreserving struct pci_ser (0x%llx)\n", args->data);
> +
> +	WARN_ON(outgoing->ser->nr_devices);
> +	kho_block_set_destroy(&outgoing->block_set);
> +	kho_unpreserve_free(outgoing->ser);
> +	kfree(outgoing);
> +}
> +
> +static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> +{
> +	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
> +	args->obj = phys_to_virt(args->data);
> +	return 0;
> +}
> +
> +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> +{
> +	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
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
> +/**
> + * pci_liveupdate_register_flb() - Register a file handler with the PCI core
> + * @fh: The file handler to register.
> + *
> + * Drivers should call pci_liveupdate_register_flb() to register their
> + * struct liveupdate_file_handler with the PCI core. This enables the PCI core
> + * to allocate its outgoing struct pci_ser whenever the first device is
> + * preserved, and free it when the last device is unpreserved.
> + *
> + * Return: 0 on success, <0 on failure.
> + */
> +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> +{
> +	pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> +	return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> +
> +/**
> + * pci_liveupdate_unregister_flb() - Unregister a file handler with the PCI core
> + * @fh: The file handler to unregister.
> + */
> +void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> +{
> +	pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
> +	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> +}
> +EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..d4881c2d2fc9
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#ifndef _LINUX_KHO_ABI_PCI_H
> +#define _LINUX_KHO_ABI_PCI_H
> +
> +#include <linux/bug.h>
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
> + * incrementing the version number in the PCI_LUO_FLB_VERSION number.
> + */
> +
> +#define PCI_LUO_FLB_COMPATIBLE "pci"
> +#define PCI_LUO_FLB_VERSION 1
> +
> +/**
> + * struct pci_dev_ser - Serialized state about a single PCI device.
> + *
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + * @refcount: Reference count used by the PCI core to keep track of whether it
> + *            is done using a device's struct pci_dev_ser. The value of the
> + *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> + *            0 otherwise.
> + */
> +struct pci_dev_ser {
> +	u32 domain;
> +	u16 bdf;
> +	u16 refcount;
> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @version: The version of the "pci" FLB struct. This field must never be
> + *           deleted, moved, or resized, as the kernel depends on always being
> + *           able to check the struct pci_ser version number.
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Physical address of the first KHO block containing pci_dev_ser.
> + */
> +struct pci_ser {
> +	u32 version;
> +	u32 nr_devices;
> +	u64 devices;
> +} __packed;
> +
> +#endif /* _LINUX_KHO_ABI_PCI_H */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index ebb5b9d76360..da58aa101e4c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -43,6 +43,7 @@
>  #include <uapi/linux/pci.h>
>  
>  #include <linux/pci_ids.h>
> +#include <linux/pci_liveupdate.h>
>  
>  #define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
>  			       PCI_STATUS_SIG_SYSTEM_ERROR | \
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> new file mode 100644
> index 000000000000..8ec98beefcb4
> --- /dev/null
> +++ b/include/linux/pci_liveupdate.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * PCI Live Update support (Public/Driver API)
> + *
> + * Copyright (c) 2026, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +#ifndef LINUX_PCI_LIVEUPDATE_H
> +#define LINUX_PCI_LIVEUPDATE_H
> +
> +#include <linux/liveupdate.h>
> +#include <linux/types.h>
> +
> +struct pci_dev;
> +
> +#ifdef CONFIG_PCI_LIVEUPDATE
> +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
> +void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
> +#else
> +static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> +{
> +}
> +#endif
> +
> +#endif /* LINUX_PCI_LIVEUPDATE_H */
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

