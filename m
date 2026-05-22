Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650A7CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09346B0096; Fri, 22 May 2026 16:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9F86B0098; Fri, 22 May 2026 16:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A93F6B0099; Fri, 22 May 2026 16:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 837A36B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53E5F161733
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:15 +0000 (UTC)
X-FDA: 84796182870.17.560206D
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4E464000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n8w+L1yj;
	spf=pass (imf27.hostedemail.com: domain of 3bLsQaggKCH0enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3bLsQaggKCH0enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lAtyCPo6ylTfae9lzbtctQSa6ySROp5Ur4512Ppcl24=;
	b=JAi6z3w284jgUUgNm2CxiXkAe5bBwbVp+rajBYwYryyJdiLQ58yRBTakwwgOwmEg74LoHJ
	pv2vSSh30/skNkrvZ1ZyQYGeq5cfrvM6JRKSy/kXFrSZzd+WWjcYmA01ddJIDLJ1xm3XSP
	WHXccYnL9VYhtJfc0RiNcG+Dj8R60XA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n8w+L1yj;
	spf=pass (imf27.hostedemail.com: domain of 3bLsQaggKCH0enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3bLsQaggKCH0enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481453; a=rsa-sha256;
	cv=none;
	b=kMwxSd38WvRYrrl8r3L5uERsHrIbawoFwBXdrtYVMOPqx8VRlW0ydijbw1un2wusfyD66z
	/YBptaQaptnGIDjfp/p5XSdV0xmsu+OKyG0IUTLbHwkj6Tnfu8qOB5B+Hg+Bl82Utwp8Ha
	4ZdvAHITXkvVrF9B0Yr7lNO/MAr9vWc=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70ea91bfe1so4370354a12.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481452; x=1780086252; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lAtyCPo6ylTfae9lzbtctQSa6ySROp5Ur4512Ppcl24=;
        b=n8w+L1yjy+4HnT5WO5P8kiUhZy8EFH639QByr/1m4JZey9i3v5l+LFhhSvb6VlixKB
         0JR94PlS3JiNRhYDEP1YubiQ/nZFuGM60T65OVbHzJoA5p1BYucyqMgwgYnRYOyK7PYc
         tw097JiRpIy1dGnpIG3m7HGS9PfZ43+MrZ1ZzxLLrfgoZToGqKEWnjjPjlrZlqp/weF4
         NWQHAFcj6RER1fVv3zV/JTHHtK6KuPnu8c3yXexquQxfc9c08DjQ1deHZgErJpiKLHe4
         1YqZyh4vub5OqkHTFjOHhpVt4PnHX9tRtOwKDPayAhij7JS+ybEAgKXAOE6rKt65OMya
         zqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481452; x=1780086252;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAtyCPo6ylTfae9lzbtctQSa6ySROp5Ur4512Ppcl24=;
        b=Gu9M1WuLf4bSeL7v24wLDt7fHkP1wlw1F0lWEi8GGmJN43ySmbC7w4TqTP+qrDdBO3
         NkyKdP1+rRh4kPo6jENnZsK2zrHicXtAkGbEPDNEKWESS91/8ONSmAnuLn8ypquim8Vr
         HJXIKT31BnNNWpwMgpHCGBkKSZc+fUIU15vOuW0lsVnxewTGWMgT0mJJLr5W1ADt6J94
         +1j/cuVeIzyB44WfcS1hHIqDPFPoOg2kfYC3kQDw1SqWc7fD1MsvCxMmb5ro2NrfS4ke
         r7c/gRg+WtoSrcxBrg/XzeANH6KCvM0OdjZleW3Lulkwmb4pbfS/bWBtwb5WvxzPTvN6
         nRLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2p4YEtxNavh6s+BhdHUDUd/u/V4WnDO1UCE6LemFJ9+U/tOw64jTtch3TUR+YYdDYzccEfVTGww==@kvack.org
X-Gm-Message-State: AOJu0YzWn5IAxtLtIMEv7KCF9103Nak+ZIMHXY3dn27Fvc4yjKtAQDqm
	L7FstUGARaiUYBsKbvUwNue7HR27eoUTWGHb+Wb5DuHvCYQFFJ2RqBO8LPK+a5+FGCUBgncj2vB
	qmJC8RyaHsLRKhQ==
X-Received: from pggh19.prod.google.com ([2002:a63:c013:0:b0:c74:1130:c2ea])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:918a:b0:3aa:c93b:6266 with SMTP id adf61e73a8af0-3b328c98e37mr5376986637.19.1779481452060;
 Fri, 22 May 2026 13:24:12 -0700 (PDT)
Date: Fri, 22 May 2026 20:23:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-1-dmatlack@google.com>
Subject: [PATCH v6 00/12] PCI: liveupdate: PCI core support for Live Update
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
X-Stat-Signature: z6i5w4u83rkshfy7wmoium5ajgs4yk4n
X-Rspamd-Queue-Id: A4E464000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779481453-73672
X-HE-Meta: U2FsdGVkX18d8jkwZboBJHRbwzzYEjCiTRHbtxARQuq28CXrrlgN2ubHqXeAKPPUOomkxNT09cy0fehKT3QuI+GwW4/frhKVlXUskKnGUv40qJVV9jtpsn0TLeq91TP5zuYXo8FJXHnA8SHdGmjIoVhowpuVwl9wp+jR5xQpwbIU8eCcTPIEnJexwyQmaPG+rtppCxqMx/JA9otB/nQjj7Wm+cIl1QxUio/6OXKpmBpGz1q0i95w4aqnkJXNHWrJ1MoHmhtwXh/xwriAh+dsJXyUUyEMOPZH8aek8hToOfdc1lH3eaCjWOSw7CG8i704V4t3o9OM/miLed17Mj5rqVyp7ECDIvSfrLzg/0aZdksRmqLVricQq7gEeEyuctV3jq2yJxF+zMjlPfieL9+M+YfUWCvngJK7ymRHQ4nYjDZFFxBqO4lmYAZl/Lg+RMaIXt66JMbgE5PTCy9DRjBm6LmKLjPLi+7Uvxp2zTd4FNYRp2B5ivy79zmgs7hqRSgym7qrK4JWQFWr82I0ohMyuXNWC4h4wIjjmXYJDUXo92mrrPKCTHcWm7k4UaWVF5PriIdhChnmZ58xNbNFDwkiipcya2Q8rxnONJ76UeN/gZ6NkqKd+sGpYa6h3ml//jpFzGMuAChzLQPY/4MW+gSSt9fiwrgRbic5IcQXaAYspow6k6C+vW1+2I23WvMClyENqwbrDdNqp+oNsBR2CzCsItHPNmyJlUacEXDRiKaC/ApBDzhCtAzYVw9CmckqdqNWWHPJkCWqW/+2Th7DsOm3LuwRRE9SYrFIgm7MKj1R2KaNo0VJB9AymAeDkwRBnzXjG62cbLJnVZW++5Uzxl4JLyk1nsNeK32cMVOBVucN4qXhh4VdjRUFV7rPbODuxxVYhkjFpkVVFXR8G7dIXZBo4Go1a3ViwLW6YeN/BpUwTIXLGefqDSxORMv5T24qi82srJVboAyJL31/5CPVNWK
 aK6JsCil
 hBmykmS56LEHi9jkLrRw0RH2W2TOJJfqPuy7cWA5Iz8JzAJPzu913pPFJ/TKE+sYjI7zSdhCqLDuOd094kO195yn4qwffnsZuKx7k8nhFBI7IPgX0ZHCQZRhQMEDnfHb0ud3bV1kIDRawW5vfQfj4mDMtpyoKF31dhKD0G3d4qlv5Lrp2hfDufVoZW0hSzYrkaFc+akAXM8bdIqd/XTH37usttp8KLZwQ0LR7N/iJjdBZ/zZa9ViulB08vShfkjE+b74+087WSC95jAVI7E3tus7rmNQugcEZyCjiiSisew9fAwYknKy94gTQWPLmVfI6KtDBD8/x7e6OqMy79DYxNDNTbyIj6mH0pQvg+sJOx0V9hUHPuXD81dKssr27vo6PlU4Xng7pYwJU0gH6HW6B4v9aECfyu5PocSGEvWlJ50h1NVLfTLBVfV+AB3Ux5PObjGkrG+uxKJ+qYZMfhW6nQg2B0ZAj10dQqaiKTOFsoJMUbGdVAE0ql+xp4vDLro7esBDz5Clyf+LaKSZgJudJ2QBQGK2kq/3Im3bM2XZh+19gZ7RkmXDpHC5J+BVQp8YZwOCvhFIoBWSMcYQiVyWv7GwfulrNhCMjSN5C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v6

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

  2. Add APIs for drivers to register outgoing-preserved devices for
     preservation and for the PCI core to identify incoming-preserved
     devices during enumeration.

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
tree, which includes two commits to enable refcounting the incoming FLB:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=next

Testing
-------

This series was tested in conjunction with v4 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v6-with-vfio

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

v6:
 - Fix truncated domain during bit shift in pci_ser_xa_key() (Sashiko)
 - Replace complex and buggy per-device locks and outgoing mutex with a
   single rwsem (me)
 - Use a loop instead of recursion to walk upstream bridges (Sashiko)
 - Correctly account for all devices that need quirks to enable ACS
   instead of relying on PCI_DEV_FLAGS_ACS_ENABLED_QUIRK. This required
   adding a patch to refactor pci_dev_acs_ops in quirks.c (Sashiko)
 - Fix circular locking dependency between pci_rescan_remove_lock and
   pci_liveupdate_flb.private->incoming.lock (me)
 - Convert several functions to return 0/error instead of true/false.
 - Bump PCI_LUO_FLB_COMPATIBLE in the patch that changes the semantics
   of pci_dev_ser.refcount (me)
 - Convert was_prepared and frozen from bitfields to bools to avoid
   KCSAN warnings (Sashiko)
 - Drop experimental verbiage from Kconfig and Documentation (me)
 - Ensure that bridges inherit bus numbers during scanning if their
   parent bridge also inherits bus numbers. Otherwise, a race between a
   scan and pci_liveupdate_finish() could result in a bridge assigning a
   bus window larger than its parent while its parent is forced to
   inherit bus numbers (i.e., cannot expand) (me)
 - Free struct pci_ser if an error occurs during pci_flb_retrieve()
   (Sashiko)
 - Detect duplicate entries in incoming FLB when constructing xarray and
   return an error instead of silently ignoring (me)
 - Add a wrapper function for fetching from the outgoing FLB (me)
 - Grammatical and spelling fixes (Bjorn)
 - Don't bother forcing bus inheritance when only outgoing devices are
   preserved. If a scan causes a bus number conflict, that is a general
   PCI core bug; it is not specific to Live Update (me)
 - Convert bitfields in struct pci_liveupdate to bools to avoid data
   races (me)

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
 Documentation/core-api/liveupdate.rst         |   1 +
 MAINTAINERS                                   |  12 +
 drivers/pci/Kconfig                           |  15 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 850 ++++++++++++++++++
 drivers/pci/liveupdate.h                      |  68 ++
 drivers/pci/pci-driver.c                      |   9 +-
 drivers/pci/pci.c                             |  13 +-
 drivers/pci/pci.h                             |   5 +
 drivers/pci/probe.c                           |  22 +-
 drivers/pci/quirks.c                          |  57 +-
 include/linux/kho/abi/pci.h                   |  65 ++
 include/linux/pci.h                           |   4 +
 include/linux/pci_liveupdate.h                |  77 ++
 17 files changed, 1197 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
-- 
2.54.0.746.g67dd491aae-goog


