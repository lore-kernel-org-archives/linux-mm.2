Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB02CC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E44D6B00B2; Fri, 10 Jul 2026 17:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCD96B00B4; Fri, 10 Jul 2026 17:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3AE96B00B5; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE7286B00B2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 659B9A045C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:26 +0000 (UTC)
X-FDA: 84974150772.06.DC1705F
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B3C280002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HXRzKTNn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=he4LlVclK6dw2y5zUcgVn+6YxGRxdITg+d/Le4uVaLE=;
	b=lRuEtQT40p60hSCK8T9muaflF3lWTD0h3ucxX0DHlJ1floSGU6ZNd8R0huWdWOip7mZgh4
	/bgWVkq3RQIK3FcpTNO2RUaPxTvMaS430OFBlnH7Y3MWu8hd1bsGWd1XLQpiL82PNFtw9g
	HMHQa0vq06Qcsl5/YQUDoZtvjvtgLlE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HXRzKTNn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3f2NRaggKCOQJSGZRGIQMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718784;
	b=rKVZvPrsDHpRROtb1uRlS7K6Ohxr5PyCQkGdxnyp13e9sicL4Dq/LjMV1sbyiu9VxmgdiE
	gm4t9D4QZtOIGhM7wI0TcBHBZmJx2O4a59u9SORRrsPhWye7ImtTO443tyWVOMyPQIwU65
	bjpZi2pWO+10xhChN3FRJlhlGwc71UQ=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848662cd2a1so1740498b3a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718783; x=1784323583; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=he4LlVclK6dw2y5zUcgVn+6YxGRxdITg+d/Le4uVaLE=;
        b=HXRzKTNnFkWtqypZCapH/dczvaho3qsWHBQKXNEkwjH1lMS6/1TLSQb/wIl2DK+OXW
         bk2At9lEvg1FO05txNHtoOxEgeJmmM7cVMrLse3fRd/7JCxWU6WOBMJpObJE3l0tBqgK
         djSv9pRrdqDTTCX4gWqPcDoolrYo8I4+SeBaUHW+D1bjQu+xDMrCGXMBVSw0ivMuiXog
         fuHXWh73R4TT92mWA/Mjg0kch5wn/5R3M/KdWSupTvr5VirchEabwkVUdHM7wlmBnJCf
         +tAiqJww5huPDNG4ZHf+gUFM41urCwWz3vBmgNegX0tLCuyc0iMOhpl0EedjcLhC3s/J
         Iv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718783; x=1784323583;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=he4LlVclK6dw2y5zUcgVn+6YxGRxdITg+d/Le4uVaLE=;
        b=C6AAUcCsUpZzzxo3tts+YkykGcEJYpVp4+ZxbMTvChXx61jHZ1heoECNtrYCIAYypc
         h/zexNBg0u4C1GdhkJ+Fc78wmo5oOETKs/ObN0BGZ9rX2tXlnwm4rakXGEcDfhpqDCSg
         0LEFOwy3O105yBfFV0VQy+x4edICcwkGWa3H7tfRhUMjnDI2inu99FgQBlAfghqDsobE
         P07aSF+CtanRTbRnUWsPUrCcLgT9w93+n8L0HoYiWbqandSJwMxOIWaH7hnU2XOyAeso
         zEd3BD7Ai9KwPPlOgItUonplezQicbhJLMhyyPxT/wABlqPzrOFHCW+XkuI5m4WuV5Mp
         MW6A==
X-Forwarded-Encrypted: i=1; AHgh+Ro+gJI/wXKhdUzhQTEjOUTMSwYk9Yi8EkGiCdi+6l53XEyvDN6IJnBG0WhZQYlgAtUxuwEysjcCTg==@kvack.org
X-Gm-Message-State: AOJu0YxAWn+Douc89x+ALmfq/oNuH3MAT4M3Q91DBVrehwUKs94XXJUZ
	4c2i7uk3x/WLE/II9DCfzzLzN9qt+QuYB+CcEdFsvN/olRJrrMYH5LRe52esPDmFn3e9pKgdia7
	G/DQn2ly1K5QDTw==
X-Received: from pfud15.prod.google.com ([2002:a05:6a00:10cf:b0:847:9be8:84d5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:228e:b0:82c:e9cc:f61d with SMTP id d2e1a72fcca58-848896c39e2mr550236b3a.9.1783718783127;
 Fri, 10 Jul 2026 14:26:23 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-1-dmatlack@google.com>
Subject: [PATCH v7 00/12] PCI: liveupdate: PCI core support for Live Update
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
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B3C280002
X-Stat-Signature: ymruk8w8rxfmpbhkasmwzdd4pi4z5n18
X-Rspam-User: 
X-HE-Tag: 1783718784-734181
X-HE-Meta: U2FsdGVkX1/+6AG7wrAqmcw3XLlp6QkSA42ji2ffAABzlddYDsWTxqr6nvQrkEopK+LfZs0yc4whjGcLHeKgKppBVLvvugD0PulVzZbFhtrZAe7/1sj3zVzcIVdBYnB5b/KTnUPjW32UFGv7rTDJ8QfwA67hm/wTY+tfEAYRo2NI28DS+F/7KS7taqdi9fdoO98Z5NyYDIn4dCRKVxIc5iIQWcdBSHwxjA18ti5u9T4OOof0QawmXQmyoAFJ+5PaoPj1r5861IVGM3rhZcUuQTcl4w+Zb3k3u8jaNi3A1u0lRi7j4ZlPe/5d3QYf56B+ZmXfhJtWKo8XH18hmXpifLGctFUSL/4VTPisnk0dYLAlgGeYV2Lk8ZMr7xihm3BabsIn/OU21g5EOoDZJvdM6ZxtNql+eJVvWPjQ3JWohTJ5b91Lvdr1k0il+qiu0a/3I2Bw4fv5BNxm4JaG5c3Q/O+SyvF+L5+J2496DjrYhsL1XbKIOLj5ACkvEKVcFZcBpteA+V00N2K6O9K5TVOsg7U5HYC6p8GRJBCj7/rXFt66fJAA+O95AgU5jOj3bwC5Orpcq25gTFrpkXgHappemLOI+qD5T0wUtGwdcWC/54NZaRU/2oN+y28NwQs7fZovPZ2+MuWJIjlkSPwZVl/T9ZAuorHIoFtYN6ogp+YmthP7LgSDaonLM9I8ftAcibqmuG76esbqZS6lVaw1q1cTD19R2UksfLrCRLgxYG+Codcu7S0sMK2vc0zA5uRIydbd3P0BnfLhonrCyYkLVPQFXeKZvE8LztS5Ga41GC/HvSI7pUGXIqK6chGaMdaNIRHX9RTPSlaskyRHT6GYobxVThYQPc7KhYkVfj4FHbo92H1hzahyOTISckfDb/HF4jl6QkgDIYTa+GNNojrxyX7Z572+PVmXCHG+/EpWwAoiUQzG88xgy23w74MwE9jMfNskuABYEAA/Yi4HDjoguFK
 4pEGawDK
 Hm+lBMECTqSQ7neq72ZixdqkNY78eYBB5Lzd535nDuEdebq2MUdkY6gSW2Zdtxy3gFsOaPXLo4629UiHyrjtPpmBexYVoberK4gJaUPqWic7r1uPvNcGDBSVRzOusN3PEfG0z+JYf20+u2UD1HoBlspyLfRk5eyJxGDGJFCrv9RjNllsclIhBGpg625U5sZ0esXzJnMNh1YDhJGzVOAYmI49ZKUGOKpr+VolGNfmsw0vrmjmdAgDn9OkoUhMAwSQys66ag4UICFLpnBy8cNs9DiagS/SJp4l9J1g0/GBrvPYF8uIThwYAQKT5PW4z2aMClBwcsqdpSHwCJ6aGEkuhcIkg/znIOcNfrYtjBKwc4dUioMpyLCAHwN20h3HR9o+UxUY4p5Pkg2MhrdWFVaZ4nfh56HsKKScHxG1wmwtBu36blJhuRzg6EQ9HiWVpMZAU4/2Cy4crIBqVjvNuNw/FbSx+pVfrrkxt4FyUDwpEsO3RVj210kJTszCX53rGBNL14pBvVi5sZ97c1y5+EVK2053hT+ecfWOmpzKCeCF9Rkc44YBWnhAqheF7GQfQVHaJWB4SiFZ7jtHr7pr2CWDLc0Hmf3PcPv8uQPOyU4e8JyaLA2AoVX+gyj7vOscYj/R5EZmsGrDYLrT8q60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v7

This series introduces initial support in the PCI core for Live Update,
enabling drivers to preserve PCI devices across a kexec-based kernel
update without interrupting the device. This functionality is critical
for minimizing downtime in environments where PCI devices (e.g., those
assigned to VMs via VFIO) must continue operating or maintain state
across a host kernel upgrade.

Specifically, this series allows preserved PCI devices to perform
uninterrupted memory transactions (DMA) to/from system memory across a
Live Update. These devices can be behind a bridge but must not be VFs.
Support for P2P and VF preservation will be addressed in future series.

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

Dependencies
------------

This series is built on top of the next branch of the liveupdate.git
tree:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=next

Testing
-------

This series was tested in conjunction with v4 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub. Some
conflict resolution was required to rebase VFIO v4 patchs on top of the
7.2-rc1 base.

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v7-with-vfio

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

v7:
 - Use kho_block_set for dynamic device preservation, redefining ABI struct
   pci_ser to use a physical address instead of a fixed-size flexible array
   (Pasha Tatashin)
 - Add kernel-doc comments for pci_liveupdate_scan_bridge_begin() and
   pci_liveupdate_scan_bridge_end() (Pasha Tatashin)
 - Move refcount to patch 1 and adjust KHO ABI versioning progression
   accordingly (Pasha Tatashin)
 - Sphinx documentation improvements: add _luo and _flb labels and use
   acronyms with :ref: links (Pasha Tatashin)
 - Panic on failure to retrieve incoming PCI FLB data to avoid ongoing
   DMA from preserved devices causing memory corruption (Sashiko,
   Samiullah Khawaja)
 - Clarify comment about device-specific ACS quirks in incoming kernel
   (Pranjal Shrivastava)
 - Sort includes alphabetically in liveupdate.c (Pasha Tatashin)

v6: https://lore.kernel.org/linux-pci/20260522202410.3104264-1-dmatlack@google.com/
v5: https://lore.kernel.org/linux-pci/20260512184846.119396-1-dmatlack@google.com/
v4: https://lore.kernel.org/linux-pci/20260423212316.3431746-1-dmatlack@google.com/
v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/


David Matlack (12):
  PCI: liveupdate: Set up FLB handler for the PCI core
  PCI: liveupdate: Track outgoing preserved PCI devices
  PCI: liveupdate: Track incoming preserved PCI devices
  PCI: liveupdate: Document driver binding responsibilities
  PCI: liveupdate: Keep bus numbers constant during Live Update
  PCI: liveupdate: Auto-preserve upstream bridges across Live Update
  PCI: Refactor matching logic for pci_dev_acs_ops
  PCI: liveupdate: Inherit ACS flags in incoming preserved devices
  PCI: liveupdate: Inherit ARI Forwarding Enable on preserved bridges
  PCI: liveupdate: Freeze preservation status during shutdown
  PCI: liveupdate: Do not disable bus mastering on preserved devices
    during kexec
  Documentation: PCI: Add documentation for Live Update

 Documentation/PCI/index.rst                   |   1 +
 Documentation/PCI/liveupdate.rst              |  29 +
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/core-api/liveupdate.rst         |   5 +
 MAINTAINERS                                   |  15 +
 drivers/pci/Kconfig                           |  15 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 910 ++++++++++++++++++
 drivers/pci/liveupdate.h                      |  68 ++
 drivers/pci/pci-driver.c                      |   9 +-
 drivers/pci/pci.c                             |  14 +-
 drivers/pci/pci.h                             |   5 +
 drivers/pci/probe.c                           |  22 +-
 drivers/pci/quirks.c                          |  58 +-
 include/linux/kho/abi/pci.h                   |  59 ++
 include/linux/pci.h                           |   4 +
 include/linux/pci_liveupdate.h                |  77 ++
 17 files changed, 1260 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 1354afac14579ad38279f12d660df961b5f20246
-- 
2.55.0.795.g602f6c329a-goog


