Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2688BCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6436B0088; Tue, 13 Oct 2026 12:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DB56B008A; Tue, 13 Oct 2026 12:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F7C6B008C; Tue, 13 Oct 2026 12:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86CB86B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE89F140C84
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:37 +0000 (UTC)
X-FDA: 85318128714.18.2293F7D
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id 284112000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gg4WEuaE;
	spf=pass (imf13.hostedemail.com: domain of 3flvOaggKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3flvOaggKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jeAXIyFq6wDt1DrhCTJh2CZ3Qk782HPpYdtAi65KBOg=;
	b=TpfQC7M5/Wknbw0OLJiFKdy551ac/y8EkU0EKTqGPvzqliZ8hxWlA7CfIIFNNx7yz9V8J2
	w+VW3cRa8jAhWunNHt2Ap9VM7f8S2BLK7kZg4F0UIAiUDuIEuZ+euo0jdesPGzPW0ZoewS
	HtS+dL+JVd8yV7aHNxbn4pNNRckskUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908736;
	b=Tf74vQ2jQdNRrcGcFlxgw0vgDWfVHJTptiq6Gsq9+z2piry5U5VhuTSu2GV4y98QKpX1Ej
	G1tHdhHoz1W2zrK2wQi1JxgyVerc2fQwetyp1riH9fWgPCK3nd/lhQ9S4lFXWyUp2BgPwY
	Lr4R/e0qZDyKPbn15YHp47rP+/a3g48=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gg4WEuaE;
	spf=pass (imf13.hostedemail.com: domain of 3flvOaggKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3flvOaggKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab7f1efe5dso6493642a91.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908735; x=1792513535; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jeAXIyFq6wDt1DrhCTJh2CZ3Qk782HPpYdtAi65KBOg=;
        b=Gg4WEuaERcJCxNSklrzF/hB2AWr8yLrs4CidWGJah4zxLrVvKbaBsmn3ReidHl3Qy6
         n5JNV1Dx/ugYs3X/VQhzh9zCuFSd2y9ByvNHFIkE58oVNfwtKN+SQfAkC5gYV7R4XNpu
         dIuSSLSAf0AG1OslQa4Liq7ojY5pNcqEndA/Xqx9GlUo0XbwbxoKfRfbqwCprhED7Xx5
         olNAZSgFlYFi5Hpau6UIfrAg8lRVqWXsK23hssXCj2XGIhQuQztT2eF9mswk15HXjC34
         LecJFabuogC2UuJX6vi0eq+Z6V33fNVoF8n2cAGxXHJ6nilF70vebJ8e/hX5DXAgaD7h
         TTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908735; x=1792513535;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jeAXIyFq6wDt1DrhCTJh2CZ3Qk782HPpYdtAi65KBOg=;
        b=L/c3gDwzdH7h4RIxSsnHCh1KK+gh8x7eFyUe/+BLyvItZO+BB32SLIDvrxT53L4e+q
         n24OTbK7UWwC5Ahu8tpq5i/eLWvDxgowrhFXn80maJszOoP2orDvqUKh2wU5SPFeXsvb
         Txre/J7XhzbIy8gTGlCq5WSvTj/GY0FTmCaU1SuQ2r1zJOznd/sIjXooGDByiL7/aLWm
         p0OGEvv/k9064HjCBIogGhKxs009V/nJh+hh0z+wwt3OfBFa2rFsc/2Fg1fbfOV4AUBV
         ZIUXZQgmUH8ce+NhqSWkP7YeYxsc8ZUht0bXejl54i6KEo8E0kqo45gXzoYxN3EtZa5t
         UW8w==
X-Forwarded-Encrypted: i=1; AKwUvBxH/ku8y8+EjXJSbHrvv0yH9TVTDYVlYk9jed0vVJGXvvr09ublu0YIDSYVP/9VmCCMK9H+v+v5bQ==@kvack.org
X-Gm-Message-State: AFq9FYL+duiwFOYl+UPjdpK9AfHHQuChJsCIvh4RMWgdtyQl0Q0Mn7E0
	WGXQckvglWijzBD3iEpLe1Uh7B6MQOlD9t28LSM4MjE4CpF7apQ0B3zK4HLBaUWfcyPX32Ev5ep
	tMPTPbJoAauGLSQ==
X-Received: from pgbe27.prod.google.com ([2002:a63:501b:0:b0:cc7:dec6:f87d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1f91:b0:3ac:53e0:4ed5 with SMTP id 98e67ed59e1d1-3ac53e0532fmr683953a91.39.1791908734381;
 Tue, 13 Oct 2026 09:25:34 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-1-dmatlack@google.com>
Subject: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live Update
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 284112000B
X-Rspam-User: 
X-Stat-Signature: qkgp8hb9tydmny58dxauq1hopmppny4h
X-HE-Tag: 1791908735-103349
X-HE-Meta: U2FsdGVkX1977hxikth9gpP/hbyjTdRddPCc2Mgi5hW1bbktuWkOfeVG0Lh2sKbg3lketG5W04JaIH0WeUIXbQNllwffr/CjkfxXYNKG+Op4MiAVCj8+wbMMvXVijWjsqta3mPxPGLZeU1XmaqWqOfkhbqKnudzct6/AUF0gYgyVxvhOh9V0hR4uQl/M5BUI5Tf3tD7ifB/sM9K1gTuQkcxDBkfLv4DHJwZJV+w1P+u/TPTFeizIYttO9hhRWjG9gyRFKNckFZfDutpL0PfaPBuYPuAfnPSuxNnArkgZ5zjpmFDQztTl4U4VhLsOtUfM8WZFk3CS4f1hrbUjhc5XrFg89okZs02Si2xoqtl81HeIPdRIiJuGTGl3cZHhVFoHaCKYxkx6zO6iUQB5k6RS+kjASZrY20XpS9ctoi4/iiOIPrhn+k79n4omLInxgtrafm5bCUSEtrfY7Kpa4L4RmRRc6DWDq1yhhreePkOlLlji/FrPYQFsv7Ly1Msy39/Yu4vAiWflNlMm7nSRXQ0p/wuZreP2SbPuLqBb6jzLKQ26YI3TdodYMjYUOg8TL0PINr7L4woMZj0tMnvQM8eExUp2fzhPBJGnT2UfbMM4ta2QELuQ/Df6OBmWXwviRrhZPOx2x8G7xw+SWz9ncnczvO+qLomaCPTqLxeUXh3TLRsef6b6tkCgmBkB0rXJ6DQWuiKIQovcts4lA16EUKl0l9zL82fKguPKi8yapB0f7vaV2HYqTVnPvyAH8CGFBDRSC3c+zvaZRMW8m7/Xpdi9HCe0a03twQUElbpYgY97Q/ieTGYq6TS5/5f/tKuu6QEfVFegOt3gJLcsz0+9jCavvCgaf0O0HJO+e712x5tf29b8L+oqQfxJj2XPURkOveeF1ZxxAXsVjlOYyvg/ztHCtoP9srjXOPYluPMW7PfA+bv9OauUzkgLJh1GWoe24/GIfAUAYRi5UY/JlkY9ycc
 a6ZL+HbD
 O/MS94fArANT2lBjzS8AP/aXmLrMd0S9lrN34bqcoG/+fZVy3p7yhv6q68lxdb+jS/ThPvSgN6N4xGPDnBz6ZmPfq+Uu+sn6sboxQ+V1qOGgQ8qNQ/og5yA0Ts5V1qLe4wZ53Jd+CpDXZg2QR3JBFF7wnp59cI3SXNb8r4kpiaGvBSr5LPXbsaPvbvVFhC6d4VtsB6cEBQ02ifN+Xr2CEqWQAG04dSwPEis2Pnz2siYA+dYBq+KEu/ZBZmln5Tn1ICaF2NYmKWGTGwrtYBnhijcazj2rfELh+Pu1C/PfxbR/GcirHFPki1jlSnWzIFg7EGEVSNmUdkFvZ6vxXb6RhjSvUd6yygT3qR7YJT4OxrXdpfC8XMFQ6E92oIGP0FCn46+nY+GDbWd8lkuZsYxP/6iLSZcVauHm62bi6gZDGKIBNPbQd5kqc5S2+hHtawKxjgv1XAvtHPoqg72/k8SIiT61WOn8253BtG9kxtopzyqC3YKidqEz6r6Oto2jLIXEStbvlLH4CypkypdV3kjfscq55+6CF+QgAYZEDnuzUPcFMePFvm+bZCBWznqXTPdOT/liutckDJEtLu848xkLMa+MawjKV+DVHSKKtoHUPYbKvjwky0KUz+TB6WhACi2O6rzd3DDoqbkxTrYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10

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

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10-with-vfio

Testing was performed using the new VFIO selftests:

  - vfio_pci_liveupdate_uapi_test
  - vfio_pci_liveupdate_kexec_test

Both tests were run in a QEMU-based VM environment (using a single
virtio-net PCIe device connected to a root port to exercise bridge
support) and on bare metal using an Intel EMR server with 8x Intel DSA
PCIe devices and 1x NVMe device.

Future Work
-----------

Please see the PCI core Live Update Roadmap:

  https://lore.kernel.org/linux-pci/20261001232133.560284-1-dmatlack@google.com/

Changelog
---------

v10:
 - Save and restore the ACS Egress Control Vector along with the ACS
   Control register, sizing the save buffer from the HwInit Egress
   Control Vector Size field (Alex) and drop Bjorn's R-b tag
 - Make CONFIG_PCI_LIVEUPDATE depend on 64BIT from the first patch
   rather than adding the dependency later in the series (Pratyush,
   Mike)
 - Reword kernel-doc comments to read better in the HTML docs and
   spell out "reference count" (Mike)
 - Replace the version number at the start of struct pci_ser with
   required_flags and optional_flags, and record the size of struct
   pci_dev_ser, so that the PCI FLB ABI can be extended (LPC BoF)

v9: https://lore.kernel.org/linux-pci/20260918200640.887030-1-dmatlack@google.com/
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
  PCI: Save and restore the ACS Control register and Egress Control
    Vector
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
 drivers/pci/liveupdate.c                      | 1038 +++++++++++++++++
 drivers/pci/liveupdate.h                      |   62 +
 drivers/pci/pci-driver.c                      |    9 +-
 drivers/pci/pci.c                             |  159 ++-
 drivers/pci/pci.h                             |    5 +
 drivers/pci/probe.c                           |   16 +-
 drivers/pci/quirks.c                          |   58 +-
 include/linux/kho/abi/pci.h                   |   96 ++
 include/linux/pci.h                           |    7 +
 include/linux/pci_liveupdate.h                |   72 ++
 17 files changed, 1562 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd
-- 
2.56.0.385.gd3acb90ef8-goog


