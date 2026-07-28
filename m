Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8A4C54F56
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085916B008C; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C9D6B0093; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C436B0095; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE8246B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C83216052C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:23 +0000 (UTC)
X-FDA: 85039579926.27.7149B35
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE8EEC0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uYsy9Vmi;
	spf=pass (imf22.hostedemail.com: domain of 3zChpaggKCB06F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3zChpaggKCB06F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276622;
	b=lS/4lAThyBgLevotfolG+nR3k/+TqmlLRxPqBHxrDkZEC95AHOBmKWmxRvHPhXmVz1QYj6
	AdsCUe8llgkEG6X2a/S/uus7xnuA/jcb1KSn85NuzMOEYyms/RP418jNdYYw8WHUYWThLR
	Zc6kYEUNNDEROObI2C1geospHiVY9VE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uYsy9Vmi;
	spf=pass (imf22.hostedemail.com: domain of 3zChpaggKCB06F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3zChpaggKCB06F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=APTOBAxUiPao4l9S27Y+m2/wTZqMb3MMdg2HVgF0ixE=;
	b=zdh7duNzlUTcVMYGLH0BAwqtvqj4LKxPo7okoloEk3XUB5YLyP9+z2D9AC/YrBWDOO3zvP
	xCnCnb/vuIG4I1z7PbV0vj6e3f/HprV/7wmVxfWuF9N8J6Jt4BDFDo7vsgNMdkxDQkB85K
	cV7ewYsq3BxUe9Sac/6x9MF6HjJ1nGI=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8488ac68185so631239b3a.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276621; x=1785881421; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=APTOBAxUiPao4l9S27Y+m2/wTZqMb3MMdg2HVgF0ixE=;
        b=uYsy9Vmi3BrkqRl3bW3IAVWcKWWu2b0MJaEW0rdr49dqQNIqxza3bNWjcYOeXVFBCI
         fVB5Xtlm7vVuxgldNfc7DbuoqVjKl64r6aaxjKnHTrXDyE5rVbw1yHvxzEaAnXOwLcvN
         JWFWJwyGMSGvN1nLPLwGkXiLFVy5rBF50BoXBPAfrj7MpyU0R1BtKRFyQ3WVke7dV3nk
         00qAUo1RurdwyMYHXiQYgcWjSXhHzstzqBWYcIoop0/hNl91sMxyjTqEl8oCh6OgEOfG
         kCzuU3T2z1iGXX+EPzs2YYCxja56pXW9fp3lBNBgqADvM4Obtmnj5FODnoKPOpjeYjvK
         9ZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276621; x=1785881421;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=APTOBAxUiPao4l9S27Y+m2/wTZqMb3MMdg2HVgF0ixE=;
        b=Ga4reiWm9CG7+H4kEDjLe3j7qqLB6FaK4+Z7dykt8SxV/tsJgTF5xzh3FVao7wvQNo
         kXbaIAzpyNUtL64EspcjZUuPfGRnJWYDeey9frdXpOPJH/WvrORnb5/E6cbo6Uc0hU56
         QA+DrpdBs0YtH23c2275Pv8JHTj2YeuvukMpbUuSRLpy4WyYmwLttOZBjpiwykfZ/HYs
         TQh8GF03JlSz+cUuxegbflLzydWpt4Dkx1Dq13yoxndxFoLoLNRtBN4GrfOM5HeK2EIu
         ljDVdvhKbKeHj8+HzFNg3R9es2hd366pBmOFqYkhVu3qaxQMJQZPlE89PRSM/DrSSffu
         lt4g==
X-Forwarded-Encrypted: i=1; AHgh+RrtpcfqH3Do1uc5lEv2FWUUQk+ntAKOJzu3uSOYz37grH2v8DZetwU6PMH/pPy/FEQWXXHtthMIhw==@kvack.org
X-Gm-Message-State: AOJu0Yx1AFS9DuxXgyCEA4UtZpW0mGF1iPZBVtxCloA1H3CdqDHTcd3I
	iHHhrZuZj+FB5uj+/QhvunrP4aqFsiDy8bYOuSBR8QnmvkpLi2FUvQhuKF9i/8Fdjzy+g3iR3P9
	NB+5i4t1DdYI/Dw==
X-Received: from pgbfm24.prod.google.com ([2002:a05:6a02:4998:b0:c8b:2706:11a7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2192:b0:848:2f84:f433 with SMTP id d2e1a72fcca58-84e93367cf5mr4264411b3a.76.1785276620540;
 Tue, 28 Jul 2026 15:10:20 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-1-dmatlack@google.com>
Subject: [PATCH v8 00/12] PCI: liveupdate: PCI core support for Live Update
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE8EEC0002
X-Stat-Signature: niy8jt9njcm3kfomfkjyczy8ukc9prhd
X-Rspam-User: 
X-HE-Tag: 1785276621-850977
X-HE-Meta: U2FsdGVkX18qSsFy+XvfzsMXaQ3gtEPRwXTBF5Gf90Tftr8SnA+Fi4oziASPP3mNsgUQcn1kha+M4UoXLPcPgycECLSlPnBl8et5LALaoiDJ5knfovg6g2ZuAjdoJ+xFSWoDxCgkYvEXdbJyP0gYB/jbC3DwqAylQ9G9xr6h0j3O+RcqxNDOXYa/D51Q+NDF9YGl33j+Dpv6fUSfIp2d2UPRVEgtZXz6C/ohKyuerxudFrsMGFB9EUZQ9zCxcmdpwZwbmU5l/kqrRzIeYhSGRWy9SuS3kCPpL+4sin6QQS2/A0Aml6dKp62jVPijwD5gU81cjH8kv/lleKhK9DMukvGken2OYJwvUOkA6gt9yERrg4kdPRl0e9oL4okoVBhSGtmKTlDpxNIHL9z+rrWLbXvp7PPGE0AqDx9/0TDBM6FkAv1zmfP/46pUSOwnJEJcaN07TY6TX/+hspEGm7wvIgLfCTR3aNCzReCwFono6EDjvBVhG9dvDPU28vNkMwDZSJf5dGxUIDu6w2M3u7iZhMRHfvHv0UpcvhryJOp3J1PFSxJu/oSr/zqHzp2MQAQlzvnl6RPlR+eaKVRAvjOFtz0pTHVnT7jaY1dauXvHRQxpdG+xqxyLM7urwiOEU8O90A9RfCXD6cAi7g9bd2KzhFf0BRvB+DYN/BEuViikeJmySKWTW3LULMjl9+oG/KQZbXooO6gDXpS1+DF9Oorcl0hQ8e1Al8oMgwLqcbqUUEOMxcbNU2NDgC5sg4iEjHUHABzYEp7DEgCLnQkbo80J8pZkddu8yOC7Zezryee/1bTa5AzfQwvQUYm+swpY2pChw5m9BjiuR+bSU/NFxAVn0Ds+wNm/v7WW89i24I73vahF0jR58wO7pmnR5JC+jtZbdydVGTWgsqYB6lizh3sAL3JXUdfXLn3xeaqmcDUoWIOE+35+gi8MmoCsz5Wuao/4Laz5RHNBiAJojX08tpR
 5Ij9vcy4
 poWS5DoJLGxHAaOHWRA7wwPtFzs/+36LYwiLDXvTdB3EPA1SH7qeWeJ8pXdHQcrHLdc55gHNkn3lbITGuonzdMTN9caOGYuNT32FvKTbmZnEiHU079EUOmldYUduy9Rhxf4gl7k6uyn4/TDfdez3w1zFsykvfusX4QcnevcadcIQi8ThC4SC826lLC6RXrFbycsmcUAuMuGcHXwMmjY2bAaVXrkVAtqiJQaR4MCZw4qRIE9JrF57u5HNtcixBrvXCioLqANCfkYyWyH8gh7yfUeyZbuE+vkuYkxkjXH7Sgs+2AW857we/YGKk8RVElx4BgzCg/vRpHlH7IoAyK+IPaCO4FJZLTM8VvKOL4LuKUc113MuxZgVHpG0LJdTzfGv4L8WjZMmqHuwfEwGp4T1dLHr5qkX2ft4kmaCSHdDtRTkDS6eimCyMYH/86d380lVyMS20KZTitukWVMwis64KKsnRKFkuMy/KYBUm8lP/FveWzRQk8crTIvWEaU3LiVu64OdWoAuUbxtUb4KiiiMHnQ03LOf0AIxikpxv4vlljDs7D/gz5KHWm0NHgtLmAfTXes74TiocX8ms2/VL4TGoEeqzTM8qZybzUSRMY79HLT6o+ZfyJ8++UN1xyWpQYUl8PR2WCPeeLcTBI+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NOTE: I am sending v8 out a little earlier than I normally would since I
will be AFK from July 29th (tomorrow) through August 6th and would like
to post the changes made in response to v7 feedback before then. I will
respond to any review feedback on v8 on August 7th or shortly after.

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v8

This series introduces initial support in the PCI core for Live Update,
enabling drivers to preserve PCI devices across a kexec-based kernel
update without interrupting the device. This functionality is critical
for minimizing downtime in environments where PCI devices (e.g., those
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

I propose we merge this series through liveupdate.git for 2 reasons:

 1. There are some LUO core changes around how FLBs are refcounted in
    the next branch of liveupdate.git that this series depends on.

 2. We had previously agreed that the files covered by the PCI LIVE
    UPDATE maintainer entry would be merged through the liveupdate.git
    tree (which is the majority of this series), so this would be
    following that process.

This plan still needs to be Acked by Bjorn Helgaas as there are some PCI
core changes in this series.

Dependencies
------------

This series is built on top of the next branch of the liveupdate.git
tree for the incoming and outgoing FLB reference counting patches.

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=next

Testing
-------

This series was tested in conjunction with v5 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub.

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v8-with-vfio

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

v8:
 - Use __free() and no_free_ptr() in pci_flb_preserve (Pasha)
 - Sort linux/kho_block.h include alphabetically (Pasha)
 - Fix reverse-fir-tree variable ordering (Pasha)
 - Eliminate unnecessary loops to allocate a new pci_dev_ser (me)
 - put() the outgoing FLB refcount now that get() takes a reference (me)
 - Document -ENODEV handling in pci_liveupdate_flb_get_incoming() (Alex)
 - Detect and panic on PCI FLB version mismatches instead of silently
   ignoring (Alex)
 - Panic if drivers violate contract to call pci_liveupdate_finish()
   before LUO drops its reference to the preserved device file (Sami,
   Pasha)
 - Use pci_upstream_bridge() instead of raw dev->bus->self (me)
 - Add a comment about ari_enabled bitfield safety (Sashiko, Pasha)
 - Add drivers/pci/liveupdate.c :internal: kernel-doc to
   Documentation/PCI/liveupdate.rst (Pasha)
 - Collected Reviewed-by tags (Pasha, Bjorn)
 - Remove use of KBUILD_BASENAME (Bjorn)
 - Make pr_debug()s more useful (Bjorn)
 - Refactor bus number preservation logic, variables, and function names
   (Bjorn)
 - Move for_each_pci_dev_in_path() to include/linux/pci.h and drop _end
   parameter (Bjorn) and _start parameter (me)
 - Rename and add kernel-doc comments to functions that adopt ARI
   enablement and ACS flags established by the previous kernel during
   enumeration to make the code more readable (Bjorn)

v7: https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
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
  PCI: liveupdate: Preserve bus numbers during Live Update
  PCI: liveupdate: Auto-preserve upstream bridges across Live Update
  PCI: Refactor matching logic for pci_dev_acs_ops
  PCI: liveupdate: Adopt ACS controls in incoming preserved devices
  PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
  PCI: liveupdate: Freeze preservation status during shutdown
  PCI: liveupdate: Do not disable bus mastering on preserved devices
    during kexec
  Documentation: PCI: Add documentation for Live Update

 Documentation/PCI/index.rst                   |   1 +
 Documentation/PCI/liveupdate.rst              |  35 +
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/core-api/liveupdate.rst         |   5 +
 MAINTAINERS                                   |  15 +
 drivers/pci/Kconfig                           |  15 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 939 ++++++++++++++++++
 drivers/pci/liveupdate.h                      |  66 ++
 drivers/pci/pci-driver.c                      |   9 +-
 drivers/pci/pci.c                             |  14 +-
 drivers/pci/pci.h                             |   5 +
 drivers/pci/probe.c                           |  23 +-
 drivers/pci/quirks.c                          |  58 +-
 include/linux/kho/abi/pci.h                   |  64 ++
 include/linux/pci.h                           |   7 +
 include/linux/pci_liveupdate.h                |  77 ++
 17 files changed, 1302 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: cecfb90c5f2cc0622b363c2291b69d6cad272897
-- 
2.55.0.487.gaf234c4eb3-goog


