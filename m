Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51548C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355AE6B0096; Fri, 18 Sep 2026 16:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8C56B0098; Fri, 18 Sep 2026 16:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF0A6B0099; Fri, 18 Sep 2026 16:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9EB96B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:06:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6683014079A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:57 +0000 (UTC)
X-FDA: 85227966474.16.5CAC2D5
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB721180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8pvNYdn;
	spf=pass (imf06.hostedemail.com: domain of 33ZmtaggKCCQDMATLACKGOOGLE.COMLINUX-MMKVACK.ORG@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=33ZmtaggKCCQDMATLACKGOOGLE.COMLINUX-MMKVACK.ORG@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q9dgEgtpibtgILH/mmPgortIM28q3qh0q2cfvPFa8qo=;
	b=Wlwe9gqse+r4IHydhEsUm3bkctiE1wMAYa04cky4CClyvZ9/x5584gGRvCR4yLQxRe93QL
	YTDx+WrlJoNmj8j1ZoFIPQ2WTbu9YCrHB6jevdRlIcNYavr2BAG2d8GPiN8VObqt8DBzfK
	r9HX73VoaiCEtEyB4EANPFFRvMd9Ikg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U8pvNYdn;
	spf=pass (imf06.hostedemail.com: domain of 33ZmtaggKCCQDMATLACKGOOGLE.COMLINUX-MMKVACK.ORG@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=33ZmtaggKCCQDMATLACKGOOGLE.COMLINUX-MMKVACK.ORG@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762015;
	b=QPPFCxr0srvLrZ8zZvbSZ/doXPEvQ4HEuAKABThYlraMB50QDOGhHW/14M3/qNOgUy9ANZ
	eDz6v1X9hiQqq3xJDQQOjYA66/oALqL+zFqNLwGuE9q7i5rv+mlVK1z7Y4fGux+5njqghG
	LI6SlsUARgUrhNK45o9vJReNQ6qgDdM=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d02df2bf09so11708595ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762014; x=1790366814; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9dgEgtpibtgILH/mmPgortIM28q3qh0q2cfvPFa8qo=;
        b=U8pvNYdnSsqwRLKMPUwiN5b6P6POjXO5S/w1JBMVYHvT2lNCgd2bs66nyEGS2DJ6r5
         91AULUAYTaQUf1WQm3/wW8qGMmvm64w9ktqHsU/nvacMkPMhX5dt5h+tIml+hMkSig88
         idWR73ySB1eucAq1M3/TW91Dj9FNaVkSreu05PcGWlal3IwbwVKJcZrU3SU2AZWzXaB+
         FLGF/yD7bf4jcGDxq6yQao/Q9nu9nhAjOy3b3EvmyDXCKw2KmxjSo1QxsR6WY8YVRX4g
         K8qZUn+5JAcI/Ah9x81Wp+nRap3YCmW7FkmkEm3sMwr8yNl9sQQKMFbSd7oawGzd8hec
         5y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762014; x=1790366814;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9dgEgtpibtgILH/mmPgortIM28q3qh0q2cfvPFa8qo=;
        b=FQ6EZEcfuRss3E+ElJYy6nk5uvCJKWjr+v20FjrKZA5wQ8fjM3XZ8lxPjGfMXGY0CJ
         +UN4z0wKRLbZZ2jbyMadYsBLuyRlMgjE4kHYa7tDaazC4rIHbAUG3CoU7J55efwTIBDh
         7rP/0XTb+CkrpI5K7RmuzWr2T05Ui+mU3bL0CSXuFI7B2xRIKkTN82V0aRVJIBjkIsAp
         ipuMubkXUohOhtiNPz8F9G65APi608QtBfO6dw7lpxHAmk0cMKL1oA5gQo/WK6DZj+rt
         3mxRwQYArAbYOeCqR7Ae2UDeKuLUOA+djqPQ97fVrgVfZGtmgD8bLpRWAjd64CS4z9HW
         GoZA==
X-Forwarded-Encrypted: i=1; AKwUvBxsdH9LsFjvgmFMgg3rZdNMZqnVmMUqAFcSR2QnL4fv/6SqgIrQ2I1avoogcv0+ydENTLzw5jM0Hw==@kvack.org
X-Gm-Message-State: AFuF++nGro5zOkwQfqlHVLO89Xr8afBxCecaHaEMoqegd3WU1r2gvbH1
	dEATHix5Q+CeNNfl8h8hNFYvgJjiZl1p2uQuj4yiHMtAAsg6l/GsP4NqTWPCpjrhMFdvFUbl91b
	AzrXCfgC5jCCUIw==
X-Received: from plrp17.prod.google.com ([2002:a17:902:b091:b0:2db:1a39:c145])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:fa5:b0:2dd:c053:82f1 with SMTP id d9443c01a7336-2ddc053841bmr11711945ad.40.1789762013609;
 Fri, 18 Sep 2026 13:06:53 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-1-dmatlack@google.com>
Subject: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB721180002
X-Stat-Signature: kkdckcyaoand9fufaupoyya5jaqaswmb
X-Rspam-User: 
X-HE-Tag: 1789762015-311663
X-HE-Meta: U2FsdGVkX18TXVwpHpJm2XKAHAA/fmMwryknf7KLH/84BZI76itQ8RJDN+zr7lcs9rEDBnJmbEnrplmDaJD09/Ie7KJ1zNWSjS2ei0XEXtGuynJtmB1czxInfHVhWg/4r+wQAtBm8pis7cEORVk3znVQsvUmuor/keHNvDP+JzBzD1NFkx2tzmcwA0eAU1S2B3VY1Z8cNQbF2Av0j+nVIPz4fLdCywGLH/1fW+3LX7a5RKtsHte5fqkq+wqlSj/85tdxvU3tMhJNhWrgSoty1ClTHGuBxYDUsldiQoc9JxeNoqeih4fD1ij5cLGCeu4atGEd4shlQutrZQglm+sJZkasdkunSM/cgIrQc8yYHr4gN8V/WyNt+D88haC4K5Uqyyk+KESP70uTBlr4HSxy1oUQySD6zNrJENEtee5QMWBLdCStZ9Bheiwt2T+z4+amn8+PZ40TCee7RPaMngnZ7zyynoM/qcsO7ttxlcA2OHuW9mIjiDfGdV0XIwkFJxmaAuR+g6uTBK2kestziO/UO6E89474FUctdkWU0XB4CBpX5hhubWB4Dv88nz5LddCqCZrxc62co09eNBCJvqJhs9jfpDyDhtN7xOAuoin2jqYnNlFj6irsajr+6+IzOeBWoRn7ET+iBgZSY4+or7dkidvwwJmYPSkkq0RLPjaXhQgeKlUq1pokqcQEfcYLDO8EetFn/YS8UHkaGq7/P8Iv9N+3Omzoy8joJDCg5y9hH4xsONtoDfq7Ui1CpjBQmNgOkVMDVN9togyAB1P1cT7vYXWlVJ5vaqP7FQ6D6gt3Fa8mquPhm6tjXuaNbKCafVJ3N3nhl6KGDjSiT6t0OGAJc8cQlt0ATKldKQj+3gO9SPISo49WqOeCebH+dONi0SBOcKpB+NpeT7a10bdo0qRla97f59AflEyK5tQLOxAOWJiLnz4EjBFgNuDTIDM6ofEY9VrN3YOMRTDeTDxBjxm
 8Rv83UGQ
 HDFIjzfJ906w1ANnESGG9r6ARoLJOFReaDgnUdol1q6GadpPr+305BNU72pFqZgPF3+AMUZ5tIwGtZ9q3R226TeGhlfXq059PKS43VwYKMjymKhRcCX7fHMu3znnD+qUcrrXw45LBW1DxwDNRXTenwUC/cSIdP6wcdTPddskznGtJyfSJHt3w8bWeYghqzHwWou856vPewCM8adK8gH1f7wEZuzAs5Lyg8K5ZsYyA6jaRqke92GaTWK1cbhFCXex+Ni7DOqKBjAN3W0yrADVUeZqTc3jZXqfyV9cfpT8VrSSU3pmedcuikwhJ1BM/7foat0IA2PneNlObnmoVYzHnYhCnXr7LRonmSed7t0XQwFww5YGXsVpl07UgWRwWU8eYo6q7ASP/xKbI2+pHbbmSL16kG6qQ7PrKGaflAAOhFHFB8ZcVDaXTNrnKF5ShpCs7yNjfBhHwiIMCjJkdMwPKS/Yumur6NnFquPdsowm8j3bDMwoBG85/47tnQcJ2YAGOhRQNWe24tSU8iVKoSbcpAQHY35Km1U0GfjR/x4m9/GdhRma1ID21k7uavZb65u0OkA84k7RG/ovnopuYLbSlbnpxcdxp1b0ljLX9WgdQtd7P1ZxwXVcKuG0ARgNOqAuuXldQKV5HrWAzcyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9

This series introduces support in the PCI core for Live Update, enabling
drivers to preserve PCI devices across a kexec-based kernel update
without interrupting the device. This functionality is critical for
minimizing downtime in environments where PCI devices (e.g., those
assigned to VMs via VFIO) must continue operating or maintain state
across a host kernel upgrade.

Specifically, this series allows preserved PCI devices to perform
uninterrupted memory transactions (DMA) targeting system memory
(specifically, preserved memfds) across a Live Update. These devices can
be behind a bridge but must not be VFs. Support for P2P and VF
preservation will be addressed in future series.

Series Overview
---------------

This series implements the following to support PCI device preservation
across Live Update:

  1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
     PCI-specific state (struct pci_ser) across Live Update using Kexec
     Handover (KHO).

  2. Add APIs for drivers to register devices for preservation
     (outgoing) and for the PCI core to identify preserved devices
     during enumeration (incoming)

  3. Automatically preserve all upstream bridges for any preserved
     endpoint. Use reference counting to ensure bridges remain preserved
     as long as any downstream device is preserved.

  4. Guarantee that preserved devices retain the same RequesterID (bus,
     device, function) for the duration of their preservation by
     inheriting secondary bus numbers, subordinate bus numbers, and ARI
     Forwarding Enable on preserved bridges.

  5. Guarantee that memory transactions to/from preserved devices are
     routed consistently by inheriting Access Control Services (ACS)
     flags across a Live Update, from the endpoint up to the root port.

  6. Modify the PCI shutdown path to avoid disabling bus mastering on
     preserved devices, thereby allowing preserved devices to perform
     uninterrupted during kexec for Live Update.

  7. Provide comprehensive documentation for the FLB API, device
     tracking mechanisms, and the division of responsibilities between
     the PCI core, drivers, and userspace.

Merge Plan
----------

This series will be merged through liveupdate.git, matching the
agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.

Testing
-------

This series was tested in conjunction with v5 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub.

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9-with-vfio

Testing was performed using the new VFIO selftests:

  - vfio_pci_liveupdate_uapi_test
  - vfio_pci_liveupdate_kexec_test

Both tests were run in a QEMU-based VM environment (using a single
virtio-net PCIe device connected to a root port to exercise bridge
support) and on bare metal using an Intel EMR server with 8x Intel DSA
PCIe devices and 1x NVMe device.

Future Work
-----------

Following this series, we expect to make further improvements to the PCI
core support for Live Update:

  - Allow P2P across Live Update by avoiding resizing or moving
    preserved device BARs and preserving all upstream bridge windows.

  - Support preserving Virtual Functions by preserving SR-IOV
    configuration on PFs and enumerating VFs after Live Update.

Changelog
---------

v9:
 - Simplify pci_liveupdate_preserve_bus_numbers() to always return true
   if a device was preserved and drop pci_liveupdate_scan_bridge_end()
   (Bjorn)
 - Add pci_liveupdate_refuse_bus_numbers() to determine when it is safe
   for the PCI core to assign bus numbers to unconfigured bridges. This
   required moving "Auto-preserve upstream bridges across Live Update"
   before "Preserve bus numbers during Live Update" (Bjorn)
 - Add "PCI: Save and restore the ACS Control register" so that the ACS
   Control register is handled by the normal save/restore path (Bjorn)
 - Rename struct pci_liveupdate::was_preserved to was_incoming, to
   disambiguate incoming from outgoing preservation (me)
 - Log unfinished preserved devices from the incoming FLB rather than
   by walking struct pci_dev (Sashiko)
 - Document that state handed over by the previous kernel is trusted,
   and panic in pci_flb_retrieve() where failures are detected rather
   than unwinding into a caller that panics anyway (Sashiko)
 - Fall back to programming ACS from scratch when a preserved device has
   no ACS save buffer, since there is nowhere to record the adopted
   controls and they would be lost by the first reset (Sashiko)
 - Drop Reviewed-by tags from "Preserve bus numbers during Live Update"
   and "Adopt ACS controls in incoming preserved devices", both of which
   changed materially since v8
 - Extend commit messages and kernel-doc comments to make the FLB code
   flow more clear (Bjorn)
 - Address various spelling, formatting, and stylistic issues (Bjorn)

v8: https://lore.kernel.org/linux-pci/20260728221007.2098560-1-dmatlack@google.com/
v7: https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
v6: https://lore.kernel.org/linux-pci/20260522202410.3104264-1-dmatlack@google.com/
v5: https://lore.kernel.org/linux-pci/20260512184846.119396-1-dmatlack@google.com/
v4: https://lore.kernel.org/linux-pci/20260423212316.3431746-1-dmatlack@google.com/
v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/


David Matlack (13):
  PCI: liveupdate: Set up FLB handler for the PCI core
  PCI: liveupdate: Track outgoing preserved PCI devices
  PCI: liveupdate: Track incoming preserved PCI devices
  PCI: liveupdate: Document driver binding responsibilities
  PCI: liveupdate: Auto-preserve upstream bridges across Live Update
  PCI: liveupdate: Preserve bus numbers during Live Update
  PCI: Refactor matching logic for pci_dev_acs_ops
  PCI: Save and restore the ACS Control register
  PCI: liveupdate: Adopt ACS controls in incoming preserved devices
  PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
  PCI: liveupdate: Freeze preservation status during shutdown
  PCI: liveupdate: Do not disable bus mastering on preserved devices
    during kexec
  Documentation: PCI: Add documentation for Live Update

 Documentation/PCI/index.rst                   |    1 +
 Documentation/PCI/liveupdate.rst              |   35 +
 .../admin-guide/kernel-parameters.txt         |    7 +-
 Documentation/core-api/liveupdate.rst         |    5 +
 MAINTAINERS                                   |   15 +
 drivers/pci/Kconfig                           |   15 +
 drivers/pci/Makefile                          |    1 +
 drivers/pci/liveupdate.c                      | 1015 +++++++++++++++++
 drivers/pci/liveupdate.h                      |   62 +
 drivers/pci/pci-driver.c                      |    9 +-
 drivers/pci/pci.c                             |   79 +-
 drivers/pci/pci.h                             |    5 +
 drivers/pci/probe.c                           |   16 +-
 drivers/pci/quirks.c                          |   58 +-
 include/linux/kho/abi/pci.h                   |   66 ++
 include/linux/pci.h                           |    7 +
 include/linux/pci_liveupdate.h                |   72 ++
 17 files changed, 1429 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd
-- 
2.55.0.1082.g2b9226bbc0-goog


