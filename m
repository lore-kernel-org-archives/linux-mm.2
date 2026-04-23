Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E401FDEE4E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86FD36B008A; Thu, 23 Apr 2026 17:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EA56B008C; Thu, 23 Apr 2026 17:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DDB6B0092; Thu, 23 Apr 2026 17:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F9A6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC17A1A057C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:22 +0000 (UTC)
X-FDA: 84691096644.17.40B1647
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E320120011
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y3a+LlpD;
	spf=pass (imf29.hostedemail.com: domain of 3x43qaQgKCOIHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3x43qaQgKCOIHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
	b=0vPg7/gibcN+FQ0XGGRM29NkOwBSCjHDs/7TjpDswbbu4n18hu52c3KDJTGnDcbXDTHRct
	pncR0Q6qobfruOCmN0h2K+8uWDRuuahGntbgD9CleflhIw6tKRZyMW2cBmZAQnhTqE0WwI
	eCnf5QQq6MAKEoHh7NYHg3bE+XanhlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979401; a=rsa-sha256;
	cv=none;
	b=ozq3wTsgHLk8GIcw2xWcnhf5cJeR4SGEr9sfLEm1VfUI2IGcc5nOVkyVXWvSdf5+1uBsjL
	IYdXzvpRET7eJdkAXPBd30ftwKZCY8RcyObcFDu/29YZP4sUvdWJCwvNtKmHkCfuPylTDu
	K88GQnrigPh5noYQfl9MvNO6SHLL9Pw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y3a+LlpD;
	spf=pass (imf29.hostedemail.com: domain of 3x43qaQgKCOIHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3x43qaQgKCOIHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f5f48458eso4235208b3a.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979400; x=1777584200; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
        b=Y3a+LlpD7VpZFCDlQ+cVyqmtnFAIE7Toi48XcybaZY2M2IgWUsdwq/AS2HCFiiyWmS
         hprgaQhQmTXHjVNaWnnD9QRrOjktNhi9SA6qqvSW4oexmeNcqHmyJSUpBdXPf+5zjnkF
         2e8z0EtSzY85aJ9wgUf/HJ89l08AXlaeeW23FzQJv4NBhkpMm30+auWpILDvwQwBUdv8
         djrUxf3v4049nMpdNPt7Tpx3lDNVnqAD6JeXGKozToALk84LDLIbtSjWq5Dj0ZfUknva
         WL6UZLq3grtI1N3p9FCB2Ust5yu3DRU0KfqO7FmYmB/q32NtYZBV6/a8GGkPtcMY/SJx
         1eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979400; x=1777584200;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
        b=RC6fcRmrxm7JoLlUAs35Qpcea/wduWBdfq4bVIBYZQZ/Q8a1QtZAYDVtKol5o9xL8H
         a2Xin+fPtwUIEV5JV0XK15Ag07SmTRpocbV9hs3E1N1RYAj2e7mWGzgI+5RqKqJJmzk4
         lrAt6lcHGC9d1XKoOnx9Av4mo4Ux6YIQ5BLN3JBluOGFuV1ltrizjvfU4Qak1b4SHfJR
         6pyPEB8H9b82dCjR4YeiMOKrY101R1FUBzMMzwiZJxEZN3x2TBXQaumKrceLceHtYNRq
         ZmQ0fNUvUcvUufRCPb5C1Dk21aLDDT8Cfpi8clGPBloxZa1i7aQORhwkQZt9RojIZTzA
         mBmA==
X-Forwarded-Encrypted: i=1; AFNElJ+nVXM3oCuhDjLHz8l95Z5cPKNH6ucIXslsIuq19DnrQzk/Cgyd8yjJjIHXxqWFpHksfrTYhm5OvQ==@kvack.org
X-Gm-Message-State: AOJu0YzAVIrZQRBrS6mvFbQjjkWdpxwn0YPMhAC4Q25LGn+Czi1DdSib
	Ab2aOOqDkGeEnpQupqC+kn+i/FCr+OKRiOX4R9TGwdsdPxM9hHVRAsqZhoZGsYhggW0xkOhVt4H
	3gL47Nj55G8kWVw==
X-Received: from pfhx15.prod.google.com ([2002:a05:6a00:188f:b0:82f:3c29:a283])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bd0a:b0:82f:74b2:7fba with SMTP id d2e1a72fcca58-82f8c7dd0d9mr31341067b3a.4.1776979399901;
 Thu, 23 Apr 2026 14:23:19 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-1-dmatlack@google.com>
Subject: [PATCH v4 00/11] PCI: liveupdate: PCI core support for Live Update
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3E320120011
X-Rspamd-Server: rspam07
X-Stat-Signature: okozxjcjggwz5sxyyaaro8da17tk9dw9
X-Rspam-User: 
X-HE-Tag: 1776979401-469630
X-HE-Meta: U2FsdGVkX1/OE14ucRsI3uYnilEx5xsSWTc+sEMgONdyq/K5p5Sw2PdAn+x2YvAI1mOx0ETVb1TS5geYvxx+cvW4EmgG06cVycxmHcVjvCslyyTPngXHwAW9IKP0Ls5feHEX5rUGA7298bzzcK/u7puMJau9F2URtdsUW9AZCiRJqBu5Q1d4SfZzRgxvPxVWrModP3qwNQcoMMry+oDj6pXSQknNJZNhQj/8vDPomvSngZ9S3/zSwyG+yYzT9JXDwRN/zDFX2wchFWW+eehn7eMZLCypFO34CXOXXmJhRlcvUO4WoMlB5mZDoT1gQ/mB6I3ZbvE/s+2t5zJ19HPNv7OdkogsTu7I47VZTeB9vfE0LUQblsaqRVEdmOOZCiwLSPmP7Nb01AEoPVg0hxw8Q8Zzu4cQTnPis1RfelWK/8Y7emP2gz1bQ0VEwU2JlBzAeiV2X6I7NFHiMyVYWEgo/9Je7GscIjriPLtlR9I0SGF6Ok3y8gvd4QZz5vRv/vNnMBlZ6hQtwdPi24CiOzLk/DTohpbjlHiqT61LE9LuaEo4geITcPyNOIbepuzH+UwLfbVOs2g+r9Lyn+eyOySYGuv6rNxRLCNeRGc5PjUM3Pxo6PE/ndq9tkqLxnA0Iw8Hd8MgeMeuUyw4seRqwVHrVuD8TnxF7JGigAh9HfjnhVH9wNqzWQl1QErhSjeBQ9bos+Nlii3rswtPub8iV98TedehEFQiY8s3+hhm8VKtsQUPUI0gFDoKjznMlTB6pyGZwLDuziZnZ6NkIEiH7h3GLFPdXd7oUrgBnm3uvCOxOXK40pZQlE7KCBr/HuS56oJunuGLNHYZ76x9mxgwe+gnc5crAcISD56Ea2wEeJ5mBEeuNK2m0t1ZYLVTtHthSzIcD/nqxz8pOAof+v/9OldIplyr6SmzvmHvMHjYkA3hm3z56sTCmwz0ASB9qIrnsHdIEODmv2/YJJEZFmOqUGa
 hqFttESN
 H4u51zuofB4YRQF/6p/dpIf8FbAzroZDHwGReSpj8mBt5GCnScBei0JmDOnVsezMIstU1nuZn5ZpkQLP6QY77G2D9mJUCOLfLE8+/F2NF+fax1BMW+QplE8t0ARniapcbPeMiv5Fn3PQg9o9V1nIQYtUb6C+dr0jWKEcVnBe76CK35ZaU6ATcHu3EI826NEgcRf0WUSOo9NpH+hR5PbnU7hzYRZDi6TcSHZTOaSQQ9PKnJopnMCAh7cHbNcDWyQvg5BYta8QV2ELJDIyWqEsblgCAKNugxmPWlWlId9ZcFWTzNYWtEwyOnnyCZjgAZSHFt4RB89saxxX9F648CSJtCINE7/MUid1EKSTL1QRcKE1WntaB6GpCSIiqLQFFVGYmX5NSrayKQuS5arEMN+uOwuG23N2K0CUhM2U7GypqBsOINuQgF5f2hc0fNm/8+YbqyLmOfcFlqNO8cFUA7Wmng1IoPojIM9gAeRzcdnX+9buC9WWX9l7CbiQnt/Kx3qy7zdzEon0pEiobcNXGuVEYSfYjiwcLNiC7MYL09LAccPiskhLISIB0R4e3EVoR2H5rJdiaU07wJ0DpVzJpSxIVmc06sWW2PntSxYNiQtb3bA7buJ7gvonRdEQH4sojCaE/z7qA5eMWU2/V0e8/io09SkkvTZpIiUq90r5GkemymahyEaAoHIwdD/Sk+VBPyfqI1JQh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v4

This patch series introduces support in the PCI core for Live Update,
enabling drivers to preserve PCI devices across a kexec-based kernel
update without interrupting the device. This functionality is critical
for minimizing downtime in environments where PCI devices (e.g., those
assigned to VMs via VFIO) must continue operating or maintain state
across a host kernel upgrade.

This series was split off from the the VFIO driver series [1] to enable
more rapid iteration on the PCI core changes, add breathing room to
split changes into smaller patches, and add some more functionality.

Series Overview
---------------

This series implements the following to support PCI device preservation
across Live Update:

  1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
     PCI-specific state (struct pci_ser) across Live Update using Kexec
     Handover (KHO).

  2. Add APIs for drivers to register "outgoing" devices for
     preservation and for the PCI core to identify "incoming" preserved
     devices during enumeration.

  3. Automatically preserve all upstream bridges for any preserved
     endpoint. Use reference counting to ensure bridges remain preserved
     as long as any downstream device is preserved.

  4. Inherit secondary/subordinate bus numbers, ARI Forwarding Enable,
     and Access Control Services (ACS) flags from the previous kernel to
     ensure a stable routing fabric and consistent IOMMU group
     assignments during Live Update.

  5. Restrict preservation to devices in immutable singleton IOMMU
     groups. Require that all upstream bridges have the necessary ACS
     features enabled to prevent IOMMU group changes across the update.

  6. Modify the PCI shutdown path to avoid disabling bus mastering on
     preserved devices and their upstream bridges, allowing memory
     transactions to continue uninterrupted.

  7. Provide comprehensive documentation for the FLB API, device
     tracking mechanisms, and the division of responsibilities between
     the PCI core, drivers, and userspace.

This series could be simplified down to fewer patches by limiting
preservation support to only devices on a root bus. Supporting devices
downstream of bridges could be split off into a follow-up series.
However since I got bridge preservation working and the series was less
than 15 patches I opted to include it for now.

Dependencies
------------

This series depends on 2 LUO patches to enable refcounting of the
incoming FLB so that it is safe for the PCI core to use
liveupdate_flb_get_incoming() during enumeration.

  https://lore.kernel.org/lkml/20260423174032.3140399-1-dmatlack@google.com/

VFIO support for PCI device preservation is built on top of this series.
The following branch on GitHub contains all the patches together to
enable testing (the LUO FLB changes, this series, and the VFIO patches):

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v4-with-vfio

Testing
-------

This series was tested in combination with the VFIO patches mentioned in
the previous section using the the new VFIO selftests:

  - vfio_pci_liveupdate_uapi_test
  - vfio_pci_liveupdate_kexec_test

Both tests were ran in ran in a QEMU-based VM environment, using a
single virtio-net PCIe device behind a PCI-to-PCI bridge as the test
device, and in a baremetal environment on an Intel EMR server, using 8x
Intel DSA PCIe devices (each on a host bridge).

Future Work
-----------

After this series we expect to make further improvements to the PCI core
support for Live Update. Once these are done we plan to drop the
"experimental" verbiage from PCI_LIVEUPDATE Kconfig help message and
documentation.

  - Ensure bridges with downstream preserved devices stay in D0 across
    Live Update in case preserved endpoints are doing memory
    transactions.
  - Preserve BARs of all preserved devices to avoid disrupting P2P

Beyond that we also plan to add support for preserving Virtual Functions
since that is a major use-case for Cloud environments. This will require
keeping SR-IOV enabled on the partent PF across a Live Update.

Changelog
---------

v4:

 Enhancements on top of previous series:

 - Split "PCI: Add API to track PCI devices preserved across Live
   Update" from v3 into 4 separate commits to make reviewing easier (FLB
   setup, outgoing device tracking, incoming device tracking, and
   documentation for driver binding)
 - Use new incoming FLB refcounting to avoid use-after-free bugs during
   enumeration
 - Use an xarray to speed up looking up of incoming preserved devices
   during enumeration
 - Use a per-device bit to indicate when secondary and subordinate bus
   numbers should be inherited on bridges instead of global data to
   avoid races between the 2 passes
 - Inherit ARI enablement across Live Update
 - Automatically preserve bridges upstream of preserved endpoints so
   so that ACS flags, ARI enablement, and bus mastering can be kept
   constant on bridges across Live Update
 - Avoid clearing bus mastering during shutdown on outgoing preserved
   device to avoid disrupting memory transcations being performed by
   preserved devices
 - Add a MAINTAINERS entry for the new files to support Live Update in
   the PCI core
 - Add info and debug level logging for various events throughout device
   preservation

 Changes based on review feedback on v3:

 - Fix up typos, wording, documentation gaps, and code style (Bjorn)
 - Use pci_WARN_ONCE() where possible (Bjorn)
 - Require ACS flags to preserve devices behind bridges so that
   singleton IOMMU group topology is guaranteed to remain across Live
   Update (Yi)
 - Preserve ACS flags (Jason, Alex)

v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/

v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/

v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/

rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/


[1] https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/

David Matlack (11):
  PCI: liveupdate: Set up FLB handler for the PCI core
  PCI: liveupdate: Track outgoing preserved PCI devices
  PCI: liveupdate: Track incoming preserved PCI devices
  PCI: liveupdate: Document driver binding responsibilities
  PCI: liveupdate: Inherit bus numbers during Live Update
  PCI: liveupdate: Auto-preserve upstream bridges across Live Update
  PCI: liveupdate: Inherit ACS flags in incoming preserved devices
  PCI: liveupdate: Require preserved devices are in immutable singleton
    IOMMU groups
  PCI: liveupdate: Inherit ARI Forwarding Enable on preserved bridges
  PCI: liveupdate: Do not disable bus mastering on preserved devices
    during kexec
  Documentation: PCI: Add documentation for Live Update

 Documentation/PCI/index.rst                   |   1 +
 Documentation/PCI/liveupdate.rst              |  23 +
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/core-api/liveupdate.rst         |   1 +
 MAINTAINERS                                   |  13 +
 drivers/iommu/iommu.c                         |  35 ++
 drivers/pci/Kconfig                           |  14 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 562 ++++++++++++++++++
 drivers/pci/pci-driver.c                      |  31 +-
 drivers/pci/pci.c                             |  22 +-
 drivers/pci/pci.h                             |  13 +
 drivers/pci/probe.c                           |  25 +-
 include/linux/iommu.h                         |   7 +
 include/linux/kho/abi/pci.h                   |  62 ++
 include/linux/pci.h                           |  58 ++
 16 files changed, 858 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h


base-commit: a13f7eb5b2d5bef886659768680093bec1c0470d
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


