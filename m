Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F075BCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01306B0088; Sat, 10 Oct 2026 04:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2696B008A; Sat, 10 Oct 2026 04:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8106B008C; Sat, 10 Oct 2026 04:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CEC6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:43:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2B1A80682
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:43:46 +0000 (UTC)
X-FDA: 85306078452.11.C426BE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F1B5100003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:43:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjJGCDC+;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791621825;
	b=z06JSl90NIjDaYMOUZaIOFKa62k3683FaaI0FZiVabgd+1+NnBgNhIpgB/6v5pXv8UalGC
	N3np9tcW8jTSPMjLfUqkc0ufgCmtrQ66xaRpYCe2AtbfidAwrI/MFHWP273U22CB2DhE+a
	XW60kiuGzpx3qlGPsO63Hrj6T1lLXNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjJGCDC+;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791621825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMhRMdEboRulS299sQmhaXW+YI7ZYoe1z6XHEW4vJjs=;
	b=4zrrTbag9bnNEXzJVN6SW21VUTKr+rwJzwQFav+JFejEpmDlR43Ehzye+gT8fpNA3JyfEN
	flQBSv+Idryh1v0z6fzF31/j0RjuH0qchFKxiT3MvYhbvZ1XvjhBWtz6uPcI7NJUizyQ72
	0YoYJkyAHiDxztOpQtm3eeJpuCrWHzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85DBE60120;
	Sat, 10 Oct 2026 08:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5161F000FF;
	Sat, 10 Oct 2026 08:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791621824;
	bh=EMhRMdEboRulS299sQmhaXW+YI7ZYoe1z6XHEW4vJjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gjJGCDC+KFlQQ26bxZqDLXuKbl4aNueNBLvuMQMHUN4tKQ0Ex3Ln42ZwAoFIzAPhW
	 4n4luK6SIuM55oNlIsJpZApLqeE2TcNDmj4froU2AjsK2W0MfdHtxRKsZbuLyGEhnX
	 czgWTxN73f/MgPDW8s24C0QrAl37lsiYNUj/m8LXdd5+OhLL8P7eUCdXlTir4zjR/4
	 3G8vXsxdlEo9OJKIS0nL8mr+1S4xUHANWrW4NdhdvZo3BcyyovSeBrZAkVJx0QEFNe
	 Q2xtPUfHiVmAES+sUYYsLsnH/jsVgcxjYijX4aOkIZNR+jDTVqPHrlfovDe3tAClzu
	 2CHSoRoF4KnIw==
Date: Sat, 10 Oct 2026 10:43:32 +0200
From: Mike Rapoport <rppt@kernel.org>
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
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 01/13] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <asn6tKL72RXItqMD@kernel.org>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-2-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5F1B5100003
X-Stat-Signature: 9zf93wdieq4iripsm5dxuwci67p8jjq6
X-HE-Tag: 1791621825-82490
X-HE-Meta: U2FsdGVkX1/pZR9D48syVRATPeLZxb1yYTHynTNhrB0/necfdTHtuFHFU2jQ+hpo4FmF6h58aHlM5zz/bp7IaFe6Z5qxWRiEImYJYLLWl0+rXyfNYYOtObqIJiSvuUM6ksocDS2wvwbWlwD+CEWH319uipcH9gDUFt0ROA4ucGBUZlK795d83iSX4lfrIvy5/D2Bc0f1q8iPUr8gIHIQCPB6RcqLoZiT65nOYABVIVS63tQXxmNdJyFrJ2jZCys3X4E5jMzs8ilTnua+eIw+ZkI4po9emywzWmz/vTZ5/vYokfbMzNci0K7inT6dxRn/gplmptDXcOg6WGTHBPDRSRtZdRn1BWvIVJiwzdOCV2CYlK1Ky7SXacoFuYp1uhxhn+UMyAWoQ8D1CmrBon9ydZcvP2NTB48AiACFlDDeGQfZB77Xf4rqAriQBhaknhy/dzF9m4OdToi8oAQboCK7DjOSgEFYmxtlHVrk9IwLmOeRYmTQ6VrDpVPQP7hlsmuuG+i0F4jFw+BUapML2w2Iqjqmt6z8YqpJJ6L+X01Bo9gbUo3GyeTlfwTZWwbTKPnCmvf3HjnIC30pXkRB74zhEYndtp/OV6B/+erFU0bUCJYm691QUUBQfukXHIgm0rknIS4EmGThOrWzBJXPRTo26Ug1PSadkyfu/0mW+s2JQbaE8ggP51fubLq85UDv/cawq/xe4i36Tx34SLvGRpx4UeAkqiA0RsBEKybUXiuZPcCWg8ilcyEaYfy3SgdzBVQnLA6Aj8ASRY5yZkwCLWZSzrspMk0PKVHbMFFi+a07Q0k49mdJpiMADAWwzxyv6Fk1OLfUsPvNeGCKRS6hszwMlBfZw7c4A0Z2oINkBhQFooN5TfU07J/GwTsaAPb+CG4pCRXW5fVpsBAso6/tKyxc4mFtDRQMH8kkLrVd0l6J5zCl17aGYb2PwxIhGqq0zU60GGV5fxgBCHEIG2Kk41q
 ouFjcI0j
 9e5oWjiuaVgwfcXUgAQPALlJUD5xTD3957VOo56G2lmp59YC7xIcjXsRw/yPkLHh+qsZpUNIhb9aRc2CSXkOqVCsztvtL/j5lKlYBW0sszJa6AtG+/ApsEkTugqzQVtCx2upfUcVe/oDzvEn89x1VAYcYrT5euEgvzrrMP0EIkRkXb3dN5QNIFz295oshkBicge5SiEbMFbHd+87CocCBQaVX6Q4JVDSu82f/rPuV15MwZX7uo9fF3U7LBi4yoObGnkD/AvfZZyUGvM6xLuRuksC10r1ni+TJ7Yjljb1hkI7/VhQrd4ioZB6jSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Fri, Sep 18, 2026 at 08:06:27PM +0000, David Matlack wrote:
> Set up a File-Lifecycle-Bound (FLB) handler so that the PCI core can
> preserve its own state across a Live Update kexec.
> 
> Preserving a PCI device across kexec requires preserving two independent
> sets of state:
> 
>  - Driver state, e.g. everything vfio-pci needs so that userspace can
>    keep using the device in the new kernel. The driver preserves this
>    itself and the PCI core is not involved.
> 
>  - PCI core state, e.g. which devices are preserved, so that the new
>    kernel knows not to disturb them while they are still running and
>    doing DMA. That is what this commit adds, serialized into struct
>    pci_ser.
 
...

> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..66dbee0bd3cf
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,206 @@
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
> + * Preserving a device requires preserving two independent sets of state: the
> + * driver's own state, which the driver preserves with no involvement from the
> + * PCI core, and the PCI core's state about the device, which the next kernel
> + * needs so that enumeration does not disturb a device that is still running.
> + * This file implements the latter.

This does not look good in html docs :(

> + *
> + * :ref:`FLB <flb>` Data
> + * =====================
> + *
> + * Userspace decides which devices are preserved, using :ref:`LUO <luo>` file
> + * preservation: a driver exposes a file that represents a single PCI device,
> + * and userspace preserves the device with
> + * ``ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)`` on that file. Binding preservation
> + * to a file gives it proper lifecycle management, e.g. the preservation is
> + * undone if userspace cancels it or goes away. How a driver exposes that file
> + * is up to the driver and invisible to the PCI core (vfio-pci variant drivers,
> + * the first intended use-case, use their per-device cdev).
> + *
> + * LUO only knows that a file was preserved; it does not know that the file
> + * represents a PCI device. Drivers therefore register their
> + * struct liveupdate_file_handler with the PCI core:
> + *
> + *  * ``pci_liveupdate_register_flb(driver_file_handler)``
> + *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
> + *
> + * LUO then refcounts the PCI core's FLB against the files preserved by that

Please spell out reference count

> + * handler, and that refcount drives the lifetime of struct pci_ser:

           and here too  ^

> + * pci_flb_preserve() allocates and preserves it when the first file is
> + * preserved, and pci_flb_unpreserve() frees it when the last file is
> + * unpreserved. In the next kernel, pci_flb_retrieve() hands the PCI core the
> + * struct pci_ser built by the previous kernel, whenever the PCI core asks for
> + * it (e.g. during enumeration), and pci_flb_finish() frees it once the PCI
> + * core is done with it.

...

> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..4096e3cd3324
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h
> @@ -0,0 +1,65 @@
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

This does not look nice in html docs either :(

> + * Live Update File-Lifecycle Bound (FLB) data.
> + *
> + * This interface is a contract. Any modification to any of the serialization
> + * structs defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the PCI_LUO_FLB_VERSION number.
> + */

-- 
Sincerely yours,
Mike.

