Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF23CFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4A76B0088; Thu, 23 Apr 2026 17:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585C76B008A; Thu, 23 Apr 2026 17:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4742F6B008C; Thu, 23 Apr 2026 17:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 317B26B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:22:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C70BE8BC24
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:22:46 +0000 (UTC)
X-FDA: 84691095132.23.FB0BF72
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28E37A000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:22:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I0ZbFON/";
	spf=pass (imf25.hostedemail.com: domain of 3o43qaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3o43qaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979365; a=rsa-sha256;
	cv=none;
	b=z6e/Ozloyo6K0rITWd3P7zkFRD6Hhnx4Xvy4q2djcKDZhUWmBK1iMDX9LDwWf3ei2cJudh
	ROc7tp0IB4ybP8nv1/CgSytJH4acWAsKMp0jN2dUHN0nt9WqMH5APHtGG25dMxrIvz64eq
	cp0yY0EJ4XTP0gIxa8ajUV/YelmDto0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I0ZbFON/";
	spf=pass (imf25.hostedemail.com: domain of 3o43qaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3o43qaQgKCL4hqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
	b=K8wAuYTij00EiIkFy+MbalaEpTqzr/5abVDbIJMuzt8rK8MwsZJ2JOVUADH8c2B3i1edmM
	Hr0AAK0okaz+QywSE0qlciR6t1/IsXN035JD5mc9lmcDwmdPPjn33Z1i+bnS8XHNZD4UV0
	w9hKRAVmA3CSuK2QTBrBu29oQjKwmpc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b2eba42b8dso63912475ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979364; x=1777584164; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
        b=I0ZbFON/eExzrg5z6Gisq/IbWQ1qWq6x6kJPp7gmJOmGav4QJbpigDWJA96p88tmXX
         hDcQHqev06HGIF8mPViMT0wgHwEApp4s+laRpjH7Mei0Mq1o/SZ80SJP6jxkiACD5Lr/
         rN5WApLjpXv7+5AFKv4WMOeh8ZXW9y42TclCCvxaPhxGj/12c1Hp72ev4E5u7JXaahcR
         dX3iQ6fp3+/mTGVSrU1iXnQeSW6Np4gprp/YyOODvzHdhwG7Q7uiOBIU9sdd/jUyAOu1
         gKuJAc6Y/1SbImf0B9wy11DBiBLLT5h/rVuYeXx4EXoQ6HRhkqYwcEtO9n04u0Q2CN2U
         k7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979364; x=1777584164;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kl+pv05082o4iUYPTAspfzDZexWtIImSBuw1JtCkgoE=;
        b=MpoZ0SzXq+RR8EYqGZizp9ahCCueU6jKYRJBiHDa8eKiqPPEnUHB73v8vArlrqFBLv
         nUL4tDM8CIPKiHWyE4HMNU/Mh+HC10sKDM2NViT/9oRNSQO6CIo2u9UCYH0NP0sRPSSW
         Ua1YJGDCPrJxDTEB0amd8kNPsB7ycnKaa1+Rvo0f1oLmE6W1NlIk0DkalDLaVhR9rTMI
         WYR/P+TptFMxndziymYgBV8Dt1LxIrASa/l0ylvzsYz/4TkPydABl03zGqaBq6PY8av1
         qpfrMHWv6dL0P4a1ssrc2bGgVYCdu8e+Up9mkDXJRVCQTujQGCoxHGqJ6LLUjvZ1MSh7
         vrSg==
X-Forwarded-Encrypted: i=1; AFNElJ9jhQG/NILolY6FmVxMNStxZ0wm6ezvMozRTraamuQSUqLyCGWyjCQbPfRQw4wU+yva0kBwEC4LAA==@kvack.org
X-Gm-Message-State: AOJu0YwxJh+12NfxilO2Ex0ajMGzEe7C+S2LLWlnAgLpfQLfgkSxetK5
	nVEIbWW9ocpeR0ek64MF4b+XqQLFH3iOyjjyP9rsOsGCCtwmNSkRITAcwGCEkeYMJsSiWG8B0M/
	JfobnIYJDOg5V8w==
X-Received: from plnx22.prod.google.com ([2002:a17:902:8216:b0:2ae:ce70:7c80])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:7d8c:b0:2b4:604c:ec6f with SMTP id d9443c01a7336-2b5f9f86840mr213628685ad.32.1776979363647;
 Thu, 23 Apr 2026 14:22:43 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:22:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212242.3431136-1-dmatlack@google.com>
Subject: [PATCH v4 00/11] PCI: liveupdate: PCI core support for Live Update
From: David Matlack <dmatlack@google.com>
To: dmatlack@google.com, iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 28E37A000A
X-Stat-Signature: okozxjcjggwz5sxyyaaro8da17tk9dw9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776979364-718358
X-HE-Meta: U2FsdGVkX189aZwfTlAOK40VxiYjEMY4kDw3ImJJw4rh0x6XMeSYqjjfElYqBhlAAo+CdR4g+VDNkkMIo/yJyuoKDGYg2QkpcC8dWs0+43fNVsWgVlPgPDTUikzzJ/wrF0ec96yhwiDhxhoACbaz/6mDUId7K36iOf4ZzouNPOqfw1iTRcKQfAHwoXN5qA0Qv82ZYDE+sFo2lOgNedt7ByUoyP1/hhdEQB69Lzvcvv5CEbJSovLPYX3rOwhgILcSpo5cQnlHvWM7HU5r68gYCeGp3d+d435wDtXH5ViiTFnhzm+Bu/iZ5YP2mmqf4hs/WugFQhxhxWf9dlNKdNcpPx5J1hd1zEFsGEy8JWexeY8Y4yIZbYmkwDpbQQA2eG3KiWjrga4ZB4JfbBkQEujylP/JOAei+tm5vOIbYE0pe2hf6Ob6nGd05syDRZwr9WrT78mXC3oJcAq26pgtQ8V7J+qTXe+RgmCDKYfUai6SBUakPSWgPzUwRGXm0uMKL2OCAqxUOxC5aiUliaIX2kTHq5yUyjVX2Ux2PnlaYXTy9DpuPTWNcOPx1GTV1acnCVRRp40gcwB3NU6ZxoKrozsiQz/XdQIuzsL4cl2vdJnvNNFmVPujYo+ibhEZ3PoXyVfLcUELb0ErcFyJ09GhJtGqEKbaGxG5nW+Hnhr1E9npvdMNbT1CXkkAOKy16PfW13Iy9FSRJFAx5Em6FM31wCVooCc2POFTh32oZsfxWG2NbDgxlOD0BzHUFpPnfxGtiW5cbZD4LwnyZHYT8FZKSSNR8hZneIQHYelBErSPfJSY/fpQSPipjgxwmhsQ/8VazxzCgQgMiaVkOawNKAFIISJELnD+NEsEo7c4Is6QGIHmtY16Ehm/3Tt8/2EH0ptEPWflV6j3gfjyWV+E8btQQMss2SxzmbVxOkJlitbutAATOi+pmZmVW2v8Q+KOZYdA7U5ysSPIm7vhq6+0QCDMWRq
 UFv3DP3U
 y+wLEIvn5zQ279vti53JnJ4lm+9d16V6ZCNdC7pqXPp64VgiNw1zlER8AyEa0GdYLkkcVjrHT/l7wPVnEU8kVzTeV+wiEcaYsrK5U/EGJC5/K/fzeCmijhQj6sDLwebwLR48LAhXUK75sIpvR5DnX/ayDGW43fK37osO66arTtZAg6DQFy7b99PnGrdOduB2hvJKAR2ZmR1Fb9gXJ7Ma5LkzZkd+hlhvq5rGJnDwubgC9KnGmVT0fdQb1SXuEkFvPX/Nxb1Y775IAYEEw6+lay8oKAfz7Q44lSl93cngD+J7cIR13Ub22nafSPxYFzFSTkTNAMzzJ2yjGq7KtplvEwYgCh4E7IApRs7h737JwI/FgElQ5PqRmRyvBCPhTGMC2XmTNW6rO/WW2fQ4FKumGVkG9K+6tJ488ZW6NN7ZG2ZqprqcSe3ICBw9pqDxPfFTzU83R3EON5j1Ic0RGf0iwWSj3hvymsoav3fJ0RyiRFArw6aHCZb2TWqPoE7T3KMTGVvZ0E0kewFt5jnlz//FprKP+J6ns1h0zhcMBvWDkdu7Sw2SP0pfw7p+fKAl4cRN9+vm75TS8Nfd7dXxNGP8ppr+DaEv3jc/Oq9pa/hQmct2sx8166tki4bQ9GxDzfFvfQ2HK+KKDF8HoEbATTm/Kzb6yyzfUzPK3C3y5UhJ27C/hfaPTz0aSee6lrw==
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


