Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B2DCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD536B0005; Tue, 12 May 2026 14:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DE76B008A; Tue, 12 May 2026 14:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9938F6B008C; Tue, 12 May 2026 14:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A9F6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:48:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 599C11C147B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:54 +0000 (UTC)
X-FDA: 84759654588.07.42DBB2E
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 988F2180009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:48:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iOyWIhe8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EyguY5SyRRz30bfysN8DgGpUMffGCDjWMOlfWBdfAYk=;
	b=SdQO+5B98Z1CSBmUpbL0mYY9I8UyfQ27c1mGe2TgJMpzpUYxqauDr1BBwkPJRQNn81ysro
	gfZ3bi223yXZeigSkEgZjFzo/RwybUj9CONT5Wmv9vJOpqy52nIWh1pQYYZzFZoqHe0cl4
	ncaZtrCsl9Sk4Ap7NTgS2LtCSz05TaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611732; a=rsa-sha256;
	cv=none;
	b=DYyPP5RwrrOk1kKebOKLUtVsnrpZnSbS5Ur3sZY4QFQshTrB6ifuR3mwO6XJweqcjHgEsB
	lkH84WsclUiJJRlERLvdvIRs0fBSAyxh5qkY3Ox0SL9YYUq0DYCXgSuBKW3ynidb2Obe9i
	GRxkTPh5Duo5scZB1TYtq0V6mvBxAlo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iOyWIhe8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3E3YDaggKCGQFOCVNCEMIQQING.EQONKPWZ-OOMXCEM.QTI@flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa5ecd760so3091780b3a.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611731; x=1779216531; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EyguY5SyRRz30bfysN8DgGpUMffGCDjWMOlfWBdfAYk=;
        b=iOyWIhe8awZWbpUQFs5sHnuewohObwe4obWa32waEvjHJLCXLUYqn7zyetRRvHh+BH
         pNijPLoCEzWmRyT3i/m0iu4cDUfeC/DSgMk3DFANwVCynzYUbS32KCaqL9BOMvKrbmSn
         cpYRxWvd770TfEgdXdPXxhHErLp0yvK30Isa3ZVfDXp8/m65pSl+pi1t5GS2yqw7XFyu
         bNPb2HZOfvd5/oyUH3o7rV+dw/ChoS/5Y8ln8hSFMHxeiOTjz/eewFCEXTFtKNpdzK3J
         HK94lPJL8r9SkG5HzQx+dQpTAKmzIy4mPKzU9I+cPOpidqYGKOtu6ZzfgeE7rq78d3ai
         sdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611731; x=1779216531;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EyguY5SyRRz30bfysN8DgGpUMffGCDjWMOlfWBdfAYk=;
        b=cKOpX0aOUjV4nvke8DZTdU3dRSrTAtavKZorLVdaGBfDg3yXxPORG1s3suDNlb7kjg
         yMfQoY0aSQmUcj1xUEGb6QjvMxBuP2/pfSKyUH9g7ip3DeSaOkcKiWqVGgdNuDfez60g
         lbBVWcNiNmRb/kpvsNj/po2bPJK+zd48PvcSsD0/x2O6CKWX8Hp6qrtQIgv2CjAkfTfY
         fX1oJhrtYW+2yj4SzXOZPrFPBEsHeE8XmA6Ti+95alPvrJxVmHKCH6G3UJgwsYG65piE
         B5lDoy87KF08CVvLsLo5rZF6ZNcm2+LXSFEP3Hg3F026xZKjMHcj/9J+cb1eUte9IIM2
         9fAA==
X-Forwarded-Encrypted: i=1; AFNElJ/mXEnnkmGODLeUOcZ8sxjva50IwN6q8fDly6XS6jY/aVq7NlcV0GUvPHfHRxGZk0OJ9RYqG8rAQw==@kvack.org
X-Gm-Message-State: AOJu0YxWFfXbxAmPSVi1PzGuZ4mn+cyZj6WB4fxxuxPFjx2DobliwM96
	+wVCZpp8qEriClZE9q3odNMSp3n+/bjfJfZlG/ZIPfQlJ2TyCoASrNk9COj9ccnXUZieVdtC6lH
	gOo2QqML+DTnLUw==
X-Received: from pfblu4.prod.google.com ([2002:a05:6a00:7484:b0:82f:7d56:a149])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1784:b0:82f:72e6:ed4 with SMTP id d2e1a72fcca58-83eeb85bbafmr4618299b3a.0.1778611731139;
 Tue, 12 May 2026 11:48:51 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:35 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-1-dmatlack@google.com>
Subject: [PATCH v5 00/11] PCI: liveupdate: PCI core support for Live Update
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 988F2180009
X-Rspamd-Server: rspam04
X-Stat-Signature: akhizx6am4j5sz3baqnuhtbqp45nh4hs
X-HE-Tag: 1778611732-372693
X-HE-Meta: U2FsdGVkX1+y/raRzRCC3XK6nvBMOHKSYyePw7UR0T5VW+bsBoQG/2Steg4X0kEpTxwY6Mz33RjSSgJ3LtgSq/0KibWO+ZKTnf8u9SOX6NRJKafFVFAdtmPy/smmdU0x/5xNosYRsTqXQdDvhPKu3AQBWvuve4QNEWw9QYPDl7MA2R8k2VPCuTU3JE5+Y4FKldohO6NZGfQN2eFQ7RhNu7IinETgL1fzAwJGPAbYJzMG+xP5g3VN48Q/AqBYd8SpJmXTHdAgBdNWHwV5us8yYAhPbjAitihIQzEaZnBAlbwW2i4SEdMShMQT72q1bPFKlAoCGMtG+C4KwuFlDBbSHjktSIby8JSp5JiYYd93CpAmqTAxN5hNJwJjyLjLirfxF2FWk/MuY6DJ57IfKAbdxzZ0pUYTXaFHOhRPJm5vK9BWfsLstmMVOHpF/UP/3gu9pB4w+OBbkPO31DrH6rL1r/PEevEs3NKrvu/VodfbStZfJjcuLYxUPxc5GZvMvYFKMA8biG1DEVNwHQUi67922GzLoGLYNQENJavgwnJICETRz1F69euyjOooCNGLDGAlaLu441YzrzrF0LQG0vLAzaWbwzXnixq3SYj8Fkhrb54MEdn8R2Bz4Twnap9D4nXpIsbKW1EbF06J/ke3IpQebpqGlOCr7ptcL1Rm9VplH6TlJtQpG/vcn/38NQb7XDU/fuoSe6Wu+Mhb2GjWZHU4Gu+q9AyQDhjcoQ4fDsccYwUYpno8qmw7uyKOUqp4y5QVki36LuXkIF5A1SKNHI2WsOYDZA0wCxZB+RlS6iDetdMHHM77VEa1Yo68ZS9g/VgedNfo/uHFHNkMpYLD8/LA0H/t2NvnBtTdE/2WLDEDoZaB+IDLCRlwpnITSi8ukCHbq+Z2Gl/+OD1JWR9HBGDUwQRyDWu/ISEpF41L7cZoXc6xnjrN1bxjxmZCK3W7/z+zA0/ZO0mjFhGaI0JzrAa
 fFx5P4Jm
 H3UvxqR354U002ulRNsBZlx1Qm+t52EshhcL9XcxTf3zDaemCCo5g8Gr6MeLcn1ijC9h7TG6XFezEBXkE++CtVPvSbQNQBDiiig2VxKiAB3JjEfHicvTKw2CTiSx5UU7pcyp5xSyQ5Xv4zCUVALxwwMWemvUCWSZ7PmOXGqRONSqQqM8fvVtiBAiMt0cUbvhP2OGCO3NZH8Z6boXgU0aS7xXiwXUfZy2lagfcmUwbbF/5Ap85JCOBLBfXC/0zM5cxh6IZtDU+rtZ+ux2v9ehVszAuMkCydSoafat68GoY7T1qcGtcCp5xuFHGA6JBAhBeqxR7/4Tg4hbFA0mNWE5y+tskuOYIo1r0HfUGggVBxzXg6Ii4BU5XD4v/hDQG3eXXsG3Gw7gfUf4pmZZAJ3wEKu2+Jgn8g/+xV7IAfd7e1exteuHob+suzLwDXYhPUwDUudsb6eWjHmWrUS8N9lXM/lc4Lyq+5tWxYcck0oNcsUljDQxFtCYJQ4SHRkwZ+TrsKT8AeDgwFqiEx9PzS9X9hPxKmRnkH4Li1u7yOlstG7EPdvesuNm+Lg9aqZTJg4IqMYxZ1rt7k0O3fk2DYz3qAOAArxisSx3N6/tJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v5

This patch series introduces the initial support in the PCI core for
Live Update, enabling drivers to preserve PCI devices across a
kexec-based kernel update without interrupting the device. This
functionality is critical for minimizing downtime in environments where
PCI devices (e.g., those assigned to VMs via VFIO) must continue
operating or maintain state across a host kernel upgrade.

Specifically, this patch series allows preserved PCI devices to perform
memory transactions to/from system memory (DMA) uninterrupted across a
Live Update. The devices can be behind a bridge, but must not be a VF.
Support for P2P and preserving VFs will come in future series.

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

  4. Guarantee that preserved devices can be identified by the same
     RequesterID (bus, device, function) for as long as they are
     preserved by always inheriting secondary and subordinate bus
     numbers and ARI Forwarding Enable on bridges with preserved
     downstream endpoints.

  5. Guarantee the memory transactions to/from preserved devices are
     routed the same way by inheriting Access Control Services (ACS)
     flags across a Live Update.

  6. Modify the PCI shutdown path to avoid disabling bus mastering on
     preserved devices and their upstream bridges, allowing memory
     transactions to continue uninterrupted.

  7. Provide comprehensive documentation for the FLB API, device
     tracking mechanisms, and the division of responsibilities between
     the PCI core, drivers, and userspace.

Dependencies
------------

This series is built on top of the next branch of liveupdate.git tree
which has 2 commits to enable refcounting the incoming FLB:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=next

Testing
-------

This series was tested in conjunction with v4 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/

The full set of patches that I used for testing can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v5-with-vfio

The full set of patches was tested using the new VFIO selftests:

  - vfio_pci_liveupdate_uapi_test
  - vfio_pci_liveupdate_kexec_test

Both tests were ran in ran in a QEMU-based VM environment, using a
single virtio-net PCIe device connected to a root port (to exercise the
bridge support in this series), and in a baremetal environment on an
Intel EMR server, using 8x Intel DSA PCIe devices (each on a host
bridge) and 1x NVMe device connected to a root port.

Future Work
-----------

After this series we expect to make further improvements to the PCI core
support for Live Update.

  - Allow P2P across Live Update by avoiding sizing or moving preserved
    device BARs and preserving all upstream bridge windows.

  - Support preserving Virtual Functions, by preserving SR-IOV
    configuration on PFs and enumerating VFs after Live Update.

Changelog
---------

v5:
 - Update PCI LIVE UPDATE entry in MAINTAINERS to use liveupdate.git,
   add kexec@ mailing list, and drop Bjorn (Pasha, Bjorn, Pratyush)
 - Create separate headers for Live Update definitions to avoid future
   patch conflicts (me)
 - Add kernel doc for public (Driver) API (me)
 - Rename reserved field to padding (Vipin)
 - Reorder checks outside of mutex where possible (Jacob)
 - Clarify refcount in struct pci_dev_ser in kernel-doc (Sami)
 - Require CONFIG_64BIT to avoid overflowing xarray key (Sashiko)
 - Various spelling and grammar fixes (Bjorn)
 - Ensure incoming and outgoing devices do not have their bus numbers
   changed during manual rescans via sysfs (Jacob)
 - Fix refcount dropping for upstream bridges during finish (Sashiko)
 - Disallow devices with PCI_DEV_FLAGS_ACS_ENABLED_QUIRK to simplify
   ACS inheritence across Live Update (Sashiko)
 - Fix ACS re-enablement via pci_restore_state() (Sashiko)
 - Drop commit that requires singleton iommu groups (me, Sami)
 - Add per-device lock to protect Live Update fields (Sami, Sashiko)

v4: https://lore.kernel.org/linux-pci/20260423212316.3431746-1-dmatlack@google.com/
v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/


David Matlack (11):
  PCI: liveupdate: Set up FLB handler for the PCI core
  PCI: liveupdate: Track outgoing preserved PCI devices
  PCI: liveupdate: Track incoming preserved PCI devices
  PCI: liveupdate: Document driver binding responsibilities
  PCI: liveupdate: Keep bus numbers constant during Live Update
  PCI: liveupdate: Auto-preserve upstream bridges across Live Update
  PCI: liveupdate: Inherit ACS flags in incoming preserved devices
  PCI: liveupdate: Inherit ARI Forwarding Enable on preserved bridges
  PCI: liveupdate: Freeze preservation status during shutdown
  PCI: liveupdate: Do not disable bus mastering on preserved devices
    during kexec
  Documentation: PCI: Add documentation for Live Update

 Documentation/PCI/index.rst                   |   1 +
 Documentation/PCI/liveupdate.rst              |  29 +
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/core-api/liveupdate.rst         |   1 +
 MAINTAINERS                                   |  12 +
 drivers/pci/Kconfig                           |  14 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 807 ++++++++++++++++++
 drivers/pci/liveupdate.h                      |  66 ++
 drivers/pci/pci-driver.c                      |  33 +-
 drivers/pci/pci.c                             |  13 +-
 drivers/pci/probe.c                           |  29 +-
 include/linux/kho/abi/pci.h                   |  64 ++
 include/linux/pci.h                           |   4 +
 include/linux/pci_liveupdate.h                |  75 ++
 15 files changed, 1140 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
-- 
2.54.0.563.g4f69b47b94-goog


