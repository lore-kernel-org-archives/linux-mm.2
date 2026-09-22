Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70876C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CD46B00A1; Tue, 22 Sep 2026 14:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDF06B00AB; Tue, 22 Sep 2026 14:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5033A6B00AC; Tue, 22 Sep 2026 14:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28F376B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:36:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C7EB120560
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:36:35 +0000 (UTC)
X-FDA: 85242253950.19.97AC9EC
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC278A000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:36:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IzkiYu3q;
	spf=pass (imf25.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790102193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nghDcAWPVDPl5zImMfn4YxpSAIcjo6vu2fMf5BQL85w=;
	b=s4QVFSERpXwraETtFMNn0M0Y95wdq3emOCjjf9iU7abQk3JXGh1kjmadykzZ8rpRDYqeuA
	N4SJntegD8e44nPF5kowuL7T/sKitiVi1UZug15kIrQD8hnnVm/tSsX4FLCeI2Uiubj/Fj
	n5tYdMquHnNzyybjJrqGDxMi6e6496U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790102193;
	b=vY9zXmR+OPsOsYHV8PLlO0qqI+/TwtUx6KpSZyhmTCIpcndrG+/Db+6tOdBnTZBl56HBKz
	Ac2up/JwEW92xJOwaeQBm5qs+12xuJnDNoqaQziYAPGgj/Q09aLrV7WLUc2CdFkIvB0Elt
	VS1UxQ3Fa1vNMpBw4t2IfGRMEpbXcBk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IzkiYu3q;
	spf=pass (imf25.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/+76OAMwYnGkbf/lDqubqIo1lwcC6f4Jt7YNkLvU34s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790102191; v=1; x=1790706991;
 b=IzkiYu3qwBFU5LKonFkKgqt4GuAKl+Ws32FEFpXq107bwJsBm+A+kShxuT0CQBi0753q1K7+
 vl59sdPSmBxo5Znevs/I0slgsAVF9ysgZQ5hC3GNmSntqCJS3G8UhuUg5f1yPcuHk6u5Iq3eqag
 A3VoKBbqOSXwRdI02wK7o8fw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4506db173dfa046a;
	Tue, 22 Sep 2026 18:36:30 +0000
X-Mizu-Trace-ID: 4506db173dfa046a
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
Date: Tue, 22 Sep 2026 11:36:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
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
 <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260918200640.887030-1-dmatlack@google.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a8peccfixm9quxr1bcacemo7k5cm3q7w
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC278A000B
X-HE-Tag: 1790102192-688838
X-HE-Meta: U2FsdGVkX1/rKr3xbGYWlf1SBEYXffQTAPuMoT9YIpphyfgCM4x6ZCFUJ9YrzDew1wEi2TBg2Yoi/fEMiGxb1JEVEt02gNMbcRkcM+y4WXydjv8CHqPyY9aU9kOWUdKqRXGUXiIb2uCo3HvhGbyjtN+l5bvptjN7Kc3A9du8pfHhGH/sBUR65i/+N2/h7K+aIXC19NuvQPcsPwsM2nvL3pvCa9sAagnwBtndQdPCIocUOvRKWFltnFflk5dsnV0EWsNGFGpNQg61YSo/UyxFekxiZNjP70kUSVdIHMdds8oiMxBVa3cn61M6nbKFFCCM0FsMbovkZyvLQFmzfbbV7pFw4eWxjANyZmznvUhbt1xqnWToL08K5EQ1F+i0FxT8yPUuupcsQGLYNNnTX5ajOvac1QwZ6AAqnZY9fiYG+RczCIOfBV9cW8JXM9rQr7JWrY/TILDMf2YU+Ubh1lfNKZZxOLX+oG7mw/4hCu1sqLKNLdV0wq4ZkbyHEic/062D7i863p5KjeZVjVl9ZnpUvVYbdkyHiC+hrfI7DyiOaF31XOUi2DgxALUGUcM8nN08bHEJW/AAirqGfxW5Ib5eNFh/jmBxA5riaEr7uIuDVvH4EyVLSAPhJeC504aL2bWed9L5eVo04j2puceP6xsHNwKdsPKoIboDKdyv9iffGknuRq0uPTdZPCNkT2KFT3dxCbL5ocoRdv8cwWWRVZxT3BxMyOiGWNBooZ6nS2kRx4YgSuIySUesqrS6s9Vk6iKW9sWJX+Wh7Wvk3y7JkFLWJOVP4fDPGrf2+FbvA7RzwKFSgsp6RB2EHUb4TnuBdPrkJIlfPpkmzWohcG9xPD2QPSHeC9BNzrFLckZ2nxuA+TFWrxI3QQWU2eFeK2fKxNzyu2R7mfkF/t3pfC/67Fcz39ZD3xAwXdWyeWeZZnZ5ZpK2v6S9ng8FJ673+Z03hN1oD9owumdcb2KRHfx25eh
 gTXqCVKf
 c0o2S/yg2anprdirmBJqhoNygbx+HI66jkZKS+bN/ISdyghTbS9N8kvf+TrkGFaLzT8waZQgRU0EsSqf1GYfLkfAdfhuAEVBJsw0jjvo3h+i2LTqUNxpvF5arkTB9lw+ZD7pv6DPv+bCkyvO58bEvRMhVr17sY5QvQ2EQM78XwWFq3sx2CIUXN2/Bs1jNe+8C2rYinotJw3RviyXZt8UpZw3Xc7kmXT4L1Ih8s9M0lDzczAuNi0RUxmN+UeSvdSTLAoqflonBkjJidEMlbdxR73hXbObQ4EStgj+Wta1vbBzUu5sH2i6vHQS7dmOVBAE6Pv+hpA1yRP2+cjWQGaSgQ0vOHCSa2Iji/Lab0Q8Voh7yuW1fCyDMk8PevMkXeFad3tEvmBqK3KE1HAKtAJBKOcoGMgPm4uq2x3Wm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/9/18 13:06, David Matlack 写道:
> This series can be found on GitHub:
> 
>    https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9
> 
> This series introduces support in the PCI core for Live Update, enabling
> drivers to preserve PCI devices across a kexec-based kernel update
> without interrupting the device. This functionality is critical for
> minimizing downtime in environments where PCI devices (e.g., those
> assigned to VMs via VFIO) must continue operating or maintain state
> across a host kernel upgrade.
> 
> Specifically, this series allows preserved PCI devices to perform
> uninterrupted memory transactions (DMA) targeting system memory
> (specifically, preserved memfds) across a Live Update. These devices can
> be behind a bridge but must not be VFs. Support for P2P and VF
> preservation will be addressed in future series.
> 
> Series Overview
> ---------------
> 
> This series implements the following to support PCI device preservation
> across Live Update:
> 
>    1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
>       PCI-specific state (struct pci_ser) across Live Update using Kexec
>       Handover (KHO).
> 
>    2. Add APIs for drivers to register devices for preservation
>       (outgoing) and for the PCI core to identify preserved devices
>       during enumeration (incoming)
> 
>    3. Automatically preserve all upstream bridges for any preserved
>       endpoint. Use reference counting to ensure bridges remain preserved
>       as long as any downstream device is preserved.
> 
>    4. Guarantee that preserved devices retain the same RequesterID (bus,
>       device, function) for the duration of their preservation by
>       inheriting secondary bus numbers, subordinate bus numbers, and ARI
>       Forwarding Enable on preserved bridges.
> 
>    5. Guarantee that memory transactions to/from preserved devices are
>       routed consistently by inheriting Access Control Services (ACS)
>       flags across a Live Update, from the endpoint up to the root port.
> 
>    6. Modify the PCI shutdown path to avoid disabling bus mastering on
>       preserved devices, thereby allowing preserved devices to perform
>       uninterrupted during kexec for Live Update.
> 
>    7. Provide comprehensive documentation for the FLB API, device
>       tracking mechanisms, and the division of responsibilities between
>       the PCI core, drivers, and userspace.
> 
> Merge Plan
> ----------
> 
> This series will be merged through liveupdate.git, matching the
> agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.
> 
> Testing
> -------
> 
> This series was tested in conjunction with v5 of the VFIO PCI driver
> series:
> 
>    https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
> 
> The full set of patches used for testing can be found on GitHub.
> 
>    https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9-with-vfio
> 
> Testing was performed using the new VFIO selftests:
> 
>    - vfio_pci_liveupdate_uapi_test
>    - vfio_pci_liveupdate_kexec_test
> 
> Both tests were run in a QEMU-based VM environment (using a single
> virtio-net PCIe device connected to a root port to exercise bridge
> support) and on bare metal using an Intel EMR server with 8x Intel DSA
> PCIe devices and 1x NVMe device.
> 
> Future Work
> -----------
> 
> Following this series, we expect to make further improvements to the PCI
> core support for Live Update:
> 
>    - Allow P2P across Live Update by avoiding resizing or moving
>      preserved device BARs and preserving all upstream bridge windows.
> 
>    - Support preserving Virtual Functions by preserving SR-IOV
>      configuration on PFs and enumerating VFs after Live Update.

Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across 
kexec is a foundational step for minimizing downtime.

As we look toward complete end-to-end support for DMA preservation 
across Live Update—especially for VFIO device passthrough and dma-buf 
sharing scenarios—IOMMU table/domain preservation becomes crucial to 
prevent IOMMU page faults when devices continue performing DMA during kexec.

I would like to ask about the current status and roadmap regarding IOMMU
Live Update / KHO (Kexec Handover) support:

Is there an ongoing effort or RFC series for IOMMU handover / page-table
preservation currently in development or under discussion?

How is the coordination between the PCI core Live Update mechanisms and
the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
restoring domains or handing over root tables)?

Any pointers to active discussion threads, RFCs, or future plans 
regarding IOMMU participation in Live Update would be greatly appreciated.

Thanks,

Yanjun Zhu

> 
> Changelog
> ---------
> 
> v9:
>   - Simplify pci_liveupdate_preserve_bus_numbers() to always return true
>     if a device was preserved and drop pci_liveupdate_scan_bridge_end()
>     (Bjorn)
>   - Add pci_liveupdate_refuse_bus_numbers() to determine when it is safe
>     for the PCI core to assign bus numbers to unconfigured bridges. This
>     required moving "Auto-preserve upstream bridges across Live Update"
>     before "Preserve bus numbers during Live Update" (Bjorn)
>   - Add "PCI: Save and restore the ACS Control register" so that the ACS
>     Control register is handled by the normal save/restore path (Bjorn)
>   - Rename struct pci_liveupdate::was_preserved to was_incoming, to
>     disambiguate incoming from outgoing preservation (me)
>   - Log unfinished preserved devices from the incoming FLB rather than
>     by walking struct pci_dev (Sashiko)
>   - Document that state handed over by the previous kernel is trusted,
>     and panic in pci_flb_retrieve() where failures are detected rather
>     than unwinding into a caller that panics anyway (Sashiko)
>   - Fall back to programming ACS from scratch when a preserved device has
>     no ACS save buffer, since there is nowhere to record the adopted
>     controls and they would be lost by the first reset (Sashiko)
>   - Drop Reviewed-by tags from "Preserve bus numbers during Live Update"
>     and "Adopt ACS controls in incoming preserved devices", both of which
>     changed materially since v8
>   - Extend commit messages and kernel-doc comments to make the FLB code
>     flow more clear (Bjorn)
>   - Address various spelling, formatting, and stylistic issues (Bjorn)
> 
> v8: https://lore.kernel.org/linux-pci/20260728221007.2098560-1-dmatlack@google.com/
> v7: https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
> v6: https://lore.kernel.org/linux-pci/20260522202410.3104264-1-dmatlack@google.com/
> v5: https://lore.kernel.org/linux-pci/20260512184846.119396-1-dmatlack@google.com/
> v4: https://lore.kernel.org/linux-pci/20260423212316.3431746-1-dmatlack@google.com/
> v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
> v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
> v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
> rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/
> 
> 
> David Matlack (13):
>    PCI: liveupdate: Set up FLB handler for the PCI core
>    PCI: liveupdate: Track outgoing preserved PCI devices
>    PCI: liveupdate: Track incoming preserved PCI devices
>    PCI: liveupdate: Document driver binding responsibilities
>    PCI: liveupdate: Auto-preserve upstream bridges across Live Update
>    PCI: liveupdate: Preserve bus numbers during Live Update
>    PCI: Refactor matching logic for pci_dev_acs_ops
>    PCI: Save and restore the ACS Control register
>    PCI: liveupdate: Adopt ACS controls in incoming preserved devices
>    PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
>    PCI: liveupdate: Freeze preservation status during shutdown
>    PCI: liveupdate: Do not disable bus mastering on preserved devices
>      during kexec
>    Documentation: PCI: Add documentation for Live Update
> 
>   Documentation/PCI/index.rst                   |    1 +
>   Documentation/PCI/liveupdate.rst              |   35 +
>   .../admin-guide/kernel-parameters.txt         |    7 +-
>   Documentation/core-api/liveupdate.rst         |    5 +
>   MAINTAINERS                                   |   15 +
>   drivers/pci/Kconfig                           |   15 +
>   drivers/pci/Makefile                          |    1 +
>   drivers/pci/liveupdate.c                      | 1015 +++++++++++++++++
>   drivers/pci/liveupdate.h                      |   62 +
>   drivers/pci/pci-driver.c                      |    9 +-
>   drivers/pci/pci.c                             |   79 +-
>   drivers/pci/pci.h                             |    5 +
>   drivers/pci/probe.c                           |   16 +-
>   drivers/pci/quirks.c                          |   58 +-
>   include/linux/kho/abi/pci.h                   |   66 ++
>   include/linux/pci.h                           |    7 +
>   include/linux/pci_liveupdate.h                |   72 ++
>   17 files changed, 1429 insertions(+), 39 deletions(-)
>   create mode 100644 Documentation/PCI/liveupdate.rst
>   create mode 100644 drivers/pci/liveupdate.c
>   create mode 100644 drivers/pci/liveupdate.h
>   create mode 100644 include/linux/kho/abi/pci.h
>   create mode 100644 include/linux/pci_liveupdate.h
> 
> 
> base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd


