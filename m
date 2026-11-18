Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8626B606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oznys8hh
Received: by kanga.kvack.org (Postfix)
	id 744E26B060A; Wed, 18 Nov 2026 17:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4E96B060B; Wed, 18 Nov 2026 17:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E43C6B060C; Wed, 18 Nov 2026 17:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 250A06B060A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7188160901
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:10 +0000 (UTC)
X-FDA: 85449701820.06.6D47C86
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9E9514000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oznys8hh;
	spf=pass (imf23.hostedemail.com: domain of 3kyj-aggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3kyj-aggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041429;
	b=lJaaqiK8yGHhFyf/Ejx50AfccfbuZ3jJUNYHw/hD/bqvzeIUQGaAppeyOTnvKTS77G3mfh
	tbvEwcyOgyWxJaCgorzwsEGQOTAia6jmTrKB3o7sbP5ZEHduO0FBLwLV3H1QwcvaliVn03
	1K00mXkAjQ6cQdx/1RpGA2NnwIY+P0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pk/I3wSfbne6vIr6Mw8kkpXlHwTn38hslTEt3tHnxeE=;
	b=G+ugWZEMNsjsuMmZ5QbKKED+341GtFYg1e+D0UTEHEmLCbnbudsitHAGrF0U3mgKIU+H2y
	5KFpNWANqzu8sBfrzdZErMqzk7AjPNDrlSqAsPnJqllrK5YQxkm/fhUNjLpZFRAkNsyNPC
	x87rudlA7PiHiAspeTwTeDMaWIElprI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oznys8hh;
	spf=pass (imf23.hostedemail.com: domain of 3kyj-aggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3kyj-aggKCDwbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-4aaa152fbecso1613710fac.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041428; x=1795646228; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pk/I3wSfbne6vIr6Mw8kkpXlHwTn38hslTEt3tHnxeE=;
        b=oznys8hhjxGvJ/NygHnzjiFqzpBt8OhJ740uFqbQZxdvaCbmiE5c5DT17UYF/XSZjG
         kabjjJo7v6dIQlaPdXJg4TOAJFp3T4Ad3/COtrgRr8Sj/g7JypEBcolTUOPIsbayGBV+
         QF0nqDL9KT5sXQaDl8BBx0hMY/Fr72HPdEwnPYf+6G9M47s/4+eI6srSux26q8y2EqU3
         oeTZWjeZ0dXgvep/iWx3TfydrbnlmoGOukXHUx1evADQ3hNpQq0eztQs3+F5ceV/ydH3
         bYuEg57ZA8Eff+4paBdo80GwwnnVb7yy8XatdqHMMVUZzkwmRZquvXrat+qrh0lHfGKH
         Rxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041428; x=1795646228;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pk/I3wSfbne6vIr6Mw8kkpXlHwTn38hslTEt3tHnxeE=;
        b=U8yo1fUwBnwbIdsbBOO5+WGe9EmpTTtI1qCgqjVRvEZJZojjRPiWVrZQ72G+N99viQ
         su6anwS8rH38ktLdWbhJIDb+DLpD8nrlAkbSUC6JV8VKVNTyWEycbrs44AZJVjEen+Cx
         zDUSLxeci236EfDaRjHFE4BcdJVFxszARYHKOdNNBCz/4jOeuVLpXwtx66dT0JDMs0Zw
         JffNQd5i772wJyfGHoZ0fsEWJp7yZTfQD8UOSWFi9Wv3tfC2lt0V22SiZcePdMK0e0PN
         htQhpy7es/sMufxBuVJ/iJHQNHhaaUvJE6ULHHIC5fW9R/N1MWItuB7aOIPvsSYMVvTp
         Nlbg==
X-Forwarded-Encrypted: i=1; AL+hErElwYWxE/g0QdvhpmwXJdAdsT2RLdr77/167bp+cXEprBsrwVeF2LuT1Tggz3g2YHDer2s/yw32OA==@kvack.org
X-Gm-Message-State: APuU4Z/tGh1xlOG3NcF1z8gUWG61/4Wuzmk9349LkfTDKnVKEW3Y+21d
	Nc1fKOuDUgDx75zr3HzQXuPRuZk7McrJnUddDtHLv5oLW4RAPNaWYlrDWIrBbJDPd6bkJ1zexw4
	A4AMudzNEg6sOFg==
X-Received: from ilbdx7-n2.prod.google.com ([2002:a05:6e02:4207:20b0:549:b431:8d75])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:16a8:b0:567:e971:200c with SMTP id 5614622812f47-57741228693mr4525440b6e.41.1795041427354;
 Wed, 18 Nov 2026 14:37:07 -0800 (PST)
Date: Wed, 18 Nov 2026 22:36:51 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-1-dmatlack@google.com>
Subject: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9E9514000D
X-Rspam-User:
X-Stat-Signature: qzox86by8ontuiaxnxzdqn4m3815k7tm
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041428-336406
X-HE-Meta: U2FsdGVkX18tdHVPvlo4rZ7aNtpslUndYKi6pY29fdqwy0Y6SIl6WUqU//2ina+dNWzJbEiyuwAH1BpbdDmV1sH48qh2mEuPNx9/oVAcORspBmYiT8Zs0mL9NXSbeQmIRCGs26HzagBy9r2bOACSOKSCewAVD3pJphjEIt2JABv2Pg+NV9c1y3jrxi1jm3jtjGo85tc/6NqAY2ifTQICu3H3S1D8BZyHb6vMGEKDUn5flRtiHltF6terpMSAoWX0ZBEFsNntQV5Ws+euGukHVqyXB+NONWstbtYRlzMxXQhga+Da2lMfsR89GJNNyLnCHClvnyf/cxUQydB9ftjlBDrvZFy6i7WgjiKeaHFGb3cc/KTX5GN/PDM3Q+xcW3O0bir45qaEhrAYy7cRzLwl0NqctywPI8gHxgFy3DNSf9O74tc3d7Es1P8MubOqvwZ3Ni+otoWIUJbEgTN5AH8dPjjlK4oNpbINEX3t0lJXATU3hG1YI3j9KrTzt2Db7wse41M/qa9rkqGXSoUHUhmNrJUtXSmw6jZWwMWE2zzdCBcTCBZHeWAhwx3TTmeSSQbeKQP9uxWX7/XwS795XjxHeXcAzn2VtKNMQtH2XRsZOCa9yGXktwNalYJZQnSZM+EoBybYhqFRXRQ1ewGuCBH8woFJ+7lVsp4H0xngCSvuhgFJn/yhPfnih6embQXZk29CWEV51t2u5u1LRqGyR2LOHoR+iBT7zGe4+lbtIORREYGHFhdzRcmFWEk6kIDrKTLl3ZpImHihikmZmzWkvSZpnmJLy7qfmU/N+RtRGKTkWLNNhmjlu4ytOEYmgKgncP5e6FZRcZLiqXKUwX07LBDVMCAwBenLXaEjlC1/SWWS0RzHRy2oUz0oqcU02oowGlig2cGA7o/mz4ji81jF4Nib01xAZOYK4/a7+PBUNF1y9iqXUvIRMUYWSrPwP0cNUqR1jhh8JjsTbTZHRNDb/cr
 Gaax+NQ3
 QKr3yfM8cEFredJPNdlXZqAJ1DWwT/Rc+KCNF+4AlZE7pTnOZcVzkyyb2qeyxMDy4n1IRbpM1Es0TbCqt1UHn7KMxkwAnYBemnNAZfdsjL7z/QT1gJHH9jZwocyFrNXIIsycu0Q4kIlwX14QfOQia1QAeda8edJY/vNefFMHFJpPyIkSu9uEIMTNUrrekYx6ZReUuTPfxa6m7/0CUrxfQRd7/6cLX5yHc5KbRZ9QMf3+5boKgVz4riqzPbijSvTp+7K7rE6RoUunSeP27b3N0bgaka3a5BZkaBh2tO9FdXdQwNiJz7Pth+8wTrxHuQbCJ/3+1ttooLoD4l2L0TqjpOQbVhwHfaKE5PGsz73nTzcshQdwwTag2rbvJuAZetmzGArPWJ4nyS7f0o/YhZOuylOfd+hMfkm4yvmUFAQDLvO150vqzoh00KeX6xlH4bdyhSfyI9im9dOcldvjDxY+0jQXYq34oNyexZKFP6FWd1orGgS4gp4EFo8uukRrehchFlo3gjrI/QLl14fknqonggrJ4Mr5Tt1NUmcWiA5rwmrdGe2leq+MCh86dp7iN5MkQq+hCfruH3JKNAARgQtLZYWZsqGkAYT3HQKLssNT2cYgGJj7G1uypa2wafleCwdBQKMI5vS8L161XulF2gAysPu+0z7e64R6CKPGbT/zpYYgJA6BY1xOJjynU6mfphXyCCvVIODEUTgNQlbJCD16KcXkj+8+gmF9IhP0Ij6gyvev5dCdL80dHjcDI9066+XfUKzr1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v11

This series introduces support in the PCI core for Live Update, enabling
drivers to preserve PCI devices across a kexec-based kernel update
without interrupting the device. This lets devices, such as ones
assigned to VMs through VFIO, keep running across a host kernel upgrade.

Preserved devices can keep doing DMA to system memory throughout the
Live Update. Devices may be behind bridges, but VFs, devices that need
device-specific ACS quirks, and CardBus are not supported. Support for
P2P and VF preservation will be addressed in future series.

Series Overview
---------------

This series implements the following to support PCI device preservation
across Live Update:

  1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
     PCI-specific state (struct pci_ser) across Live Update using Kexec
     Handover (KHO).

  2. Add APIs for drivers to register devices for preservation
     (outgoing) and for the PCI core to identify preserved devices
     during enumeration (incoming).

  3. Automatically preserve all upstream bridges for any preserved
     endpoint. Use reference counting to ensure bridges remain preserved
     as long as any downstream device is preserved.

  4. Keep the Requester ID (bus, device, function) of preserved devices
     stable for the duration of their preservation by adopting the
     secondary bus numbers, subordinate bus numbers, and ARI Forwarding
     Enable of preserved bridges. After a Live Update, pci=assign-busses
     and pci=noari do not override this adopted state.

  5. Save and restore the ACS Control register and Egress Control Vector
     across resets for all devices (patch 8), so that adopted ACS
     controls survive a reset.

  6. Keep memory transactions to/from preserved devices routed
     consistently by adopting Access Control Services (ACS) controls
     across a Live Update, from the endpoint up to the root port.

  7. Freeze each device's preservation status when it is shut down, and
     avoid disabling bus mastering on preserved devices in the PCI
     shutdown path, so preserved devices can keep doing DMA during
     kexec.

  8. Add Documentation/PCI/liveupdate.rst, built from the kernel-doc in
     drivers/pci/liveupdate.c and include/linux/kho/abi/pci.h, describing
     the FLB API, device tracking, and the division of responsibilities
     between the PCI core, drivers, and userspace.

Merge Plan
----------

This series is intended to go through liveupdate.git, the tree listed in
the new PCI LIVE UPDATE MAINTAINERS entry.

v10 and a follow-up patch were applied to the lu-pci-preservation branch
of liveupdate.git. This version is meant to replace them, and applies on
v7.4-rc1, the base of that branch.

Testing
-------

VFIO
~~~~

This series was tested with v5 of the vfio-pci Live Update series,
rebased onto this series and the luo-internal-api branch of
liveupdate.git (which the VFIO series depends on):

  https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub.

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v11-with-vfio

Testing was performed using the VFIO selftests, including the new Live
Update selftests:

  - vfio_pci_liveupdate_uapi_test
  - vfio_pci_liveupdate_kexec_test

The tests were run in a QEMU-based VM environment (using an emulated
Intel IGB device connected to a PCIe Root Port to exercise bridge
support) and on bare metal using an Intel Emerald Rapids server with 8x
Intel DSA PCIe devices and 1x NVMe device, all of which were preserved
across a Live Update by vfio_pci_liveupdate_kexec_test.

PCI Selftests
~~~~~~~~~~~~~

This series was also tested with a new set of PCI Live Update
selftests:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v11-with-selftests

Each test preserves a PCI device across a Live Update in a QEMU VM and
checks that the PCI core keeps the device, and every bridge above it,
running: same BDF and bus numbers, Bus Master Enable left set, ARI
Forwarding Enable and ACS controls adopted from the previous kernel, and
no PCI config writes that disrupt the device during the Live Update. The
tests cover endpoints on the root bus, below a Root Port, below a
switch, and below two levels of switches, as well as booting the next
kernel with command lines that would otherwise renumber buses or change
ARI and ACS. All tests pass on x86_64 (q35) and arm64 (virt), except
for the pci=assign-busses test, which is skipped on arm64 (the option is
x86-only).

Future Work
-----------

Please see the PCI core Live Update Roadmap:

  https://lore.kernel.org/linux-pci/20261001232133.560284-1-dmatlack@google.com/

Changelog
---------

v11:
 - Rebase onto v7.4-rc1, the base of lu-pci-preservation in
   liveupdate.git
 - Fold in "PCI: liveupdate: Factor out pci_dev_ser allocation and
   release", which was posted and applied as a follow-up to v10 [1]:
   introduce the struct pci_dev_ser allocation and release helpers in
   "Track outgoing preserved PCI devices", and split
   pci_liveupdate_preserve_device() into separate paths for new and
   already-preserved devices in "Auto-preserve upstream bridges across
   Live Update" (suggested by Bjorn; the follow-up was reviewed and
   tested by Chris Down)
 - Don't allocate an ACS save buffer for devices that rely on
   device-specific ACS quirks (Alex)
 - Adopt the ACS controls of preserved devices even if they match a
   device-specific ACS quirk, logging a warning instead of programming
   ACS from scratch, and panic if a preserved device has no ACS save
   buffer (Alex)
 - Clean up commit messages, comments and documentation: fix
   inaccuracies, remove filler and duplicated text, document that
   pci=noari does not override adopted ARI Forwarding Enable, and note
   in the documentation that devices cannot be preserved or unpreserved
   once they are shut down
 - Panic if any outgoing device was never unpreserved when the outgoing
   FLB is freed, instead of leaving dangling dev->liveupdate.outgoing
   pointers, and share the check with the incoming side (Sashiko)

[1] https://lore.kernel.org/linux-pci/20261109174009.735309-1-dmatlack@google.com/

v10: https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/
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
 .../admin-guide/kernel-parameters.txt         |   11 +-
 Documentation/core-api/liveupdate.rst         |    5 +
 MAINTAINERS                                   |   15 +
 drivers/pci/Kconfig                           |   14 +
 drivers/pci/Makefile                          |    1 +
 drivers/pci/liveupdate.c                      | 1011 +++++++++++++++++
 drivers/pci/liveupdate.h                      |   72 ++
 drivers/pci/pci-driver.c                      |    8 +-
 drivers/pci/pci.c                             |  169 ++-
 drivers/pci/pci.h                             |    5 +
 drivers/pci/probe.c                           |   16 +-
 drivers/pci/quirks.c                          |   58 +-
 include/linux/kho/abi/pci.h                   |   96 ++
 include/linux/pci.h                           |    7 +
 include/linux/pci_liveupdate.h                |   72 ++
 17 files changed, 1556 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/pci/liveupdate.h
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/pci_liveupdate.h


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.1.703.gf848ed807c-goog


