Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38702C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4630B6B0098; Tue, 22 Sep 2026 14:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413886B009B; Tue, 22 Sep 2026 14:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301CE6B009D; Tue, 22 Sep 2026 14:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 014266B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:54:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B56D1A04DD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:54:20 +0000 (UTC)
X-FDA: 85242298680.19.76B5498
Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id B66EE80005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:54:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYYfmfkf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790103258;
	b=Mcaf7P0JHll7WFprIRREkmuzkdSbxMC3LkUHqEfhP3H0RZNT0mvevBFilPZPcHRFmjP0qO
	cQKjVx6520oWq9B8yX+A871Rw12R++O6Gs3C8gdp/fGCxA9JMl00f01m0TcRBl7icWrA9C
	nLTXcNZxdgD2bPL0+IuxKbnpCQCuzpk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYYfmfkf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.9 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790103258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvZvaVqgEfsPGi/8CiIFQWn2sWTekYobYJgkbqLLrKQ=;
	b=6cxm69j6B2MjRmfgUSJbFW1JnxC02uMuAgKnGCM2Wyeah8hj6jLFbI0xXE2BBAYgiqowID
	OiFF+eiwsTD3kJexB4na89R8EjbxF73HfWo1em/sC8pnnk9VPDjq15HMi7ZsPsQs5EfWpO
	spUF3VbTHKavprQXz0vzr34aDXnM89c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6aIyKz4AnS5JHbIqf+A2NRwM8YIsSjoIpHru7EXknAs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790103255; v=1; x=1790708055;
 b=JYYfmfkfSbOGVu3Tj7VY3/t1XklDDmmm7x8p1Q8dRHneBGsE76iER+jzTrqMRfpI5V4675N3
 CpHc1JhCqGVS7u7FKjJJL/zz5SWVFNzoIAvLVX31Swsk9VlFDY32kEBh4C+WqVWbAer8ISCgEgl
 MQBAPq4dsfBMAnbNAT2qSdDY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2e391d2af89e296e;
	Tue, 22 Sep 2026 18:54:15 +0000
X-Mizu-Trace-ID: 2e391d2af89e296e
X-Migadu-Flow: FLOW_OUT
Message-ID: <079e343d-c6a6-4430-b900-25918197bfad@linux.dev>
Date: Tue, 22 Sep 2026 11:54:08 -0700
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
X-Rspamd-Server: rspam06
X-Stat-Signature: ynfxnejrg4yg5za8bx49r1objihncbjc
X-Rspam-User: 
X-Rspamd-Queue-Id: B66EE80005
X-HE-Tag: 1790103256-405509
X-HE-Meta: U2FsdGVkX1+nhZZ/OqOVF552phY9g3B+Jch0sLDdsQ5vkmnXU/if3reSwztqnHOKpOYbStupeD1fD10CVH9OH3TCPVy7UFeWSQ1uSRcH1EsdcNZqrWYhBAlExoCvU/B/qhNa7aE1LtLtgpAptwbj1mCGd3Vr/07sztGN90mIZ+zu8kMW21n/rlGOURHZzAoUrajtn2zqxPyos5L4mdQOvDoB4cyOXq8M/6eKtR2RIKWPl9Gwue60keIPBX+PPOuwPNCmVKClCtx1PrvMra5LVz/xJOnJ2J2AL6NxgFW9NWLp3E9PoL2q5UCVZNFDj2NvlNCSMiV4PNdI3ddWTEgFgLdD+CsVMu6rOeIGDYJGxMnfNbQxyY+t++Y8WuGvZKyD6g7EHC+p5ATUHAMtXlvSRLYayAaWPcC7pqYZIE/gIps6AGCobLioo+uaupQdH7xBW0zSKydNrQPAh+d+5T0eJu6B4tgOZrKBWe6knIw0GCRucxkJ3AdJEmFwjAGx+g2AbPFRVR29+SQ6m5vSm3m5iINsqSyNfY/H3+ZuK27O8ldMMlz67DUGLIoInZU8p/icfXuIQKmUITjAJxLZPySRD2HsxJhQOGpyaYhPJz4+78Qd6WD99OO1CgW3rYCdb0e+IFpZcaIO/1SV3AIj4Vlp5kFwHe6HZ98SuT42G5FE8i37eDsT6Yd2HAW4wSpFOStAZfO3caiiwqkyK/90TnGNQH/5uGPToqlZlfJXFHyl+UjEiNWf/EC52Q4r+ayHucBks69HS6BPDFSv+kVLj/jKrTuf5WWjzBn7Me6x3gA9ZPgN0xuuQPHllG+RFs/HAr1g8+4q/25vpyEipd1fwoTc446hkTrtAZm98fTaMDYUcsOcFouv5SL8IfUu/urpQjjiF8YAWaZ1UwhlFPV7v41W2SAJXeQKNbLDhz19sEdBrYUgvB96XTfK1TshRl5PArMXOGTtaMExWBQJOvtNJ9o
 96YHtq9R
 Xp1TVBW0oXLx75Swzf88BtYcx86D6EprnrImSBHDLVaNLHGGfhwbNZf3oZ8LFIbtRcPzztyrNChsRvLLfgmh+s5gPILgj7VClxHvPGfbpuo+R9GMXm2RnmFmoWYSEwVH+CzRe+8wnqKInqIqdccvKhKdrb6S7mBO6vo8u5tOhvPn41qBv66GZ+h6/q7Oq1xnQtmsxgAtj5xCY/VOJvwCFLi3j7RF4sKluX98iRWlPmiOoLtQALERSwl8JLKHjhRbpxnQ2ywspUSpi/I/qAEbIpcUEsGmWU4k0DKa+HE0JTQNGB7Qwk3HWWLYqBmB4j8cKEzyJDwvaVhAJZDnRZZS3mnjAkxB9wlLH4qUXZe/FtWGF23zlWloOi88vS+qQBHkZDsZJ30yRht/N3H0N+8OsD0C9gFB/Y3Dwadtp
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

With this vfio_pci_liveupdate_kexec_test based on this patchset v9, I 
have made tests in my local kvm. It worked as expected.

Yanjun Zhu

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


