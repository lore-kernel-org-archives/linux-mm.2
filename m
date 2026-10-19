Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A626606A328
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=BdWjSwId
Received: by kanga.kvack.org (Postfix)
	id 6C4F06B0388; Mon, 19 Oct 2026 17:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6772E6B038A; Mon, 19 Oct 2026 17:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564BF6B038B; Mon, 19 Oct 2026 17:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBDB6B0388
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7475A835E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:23 +0000 (UTC)
X-FDA: 85340672046.05.88B30AD
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0707D160003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BdWjSwId;
	spf=pass (imf08.hostedemail.com: domain of 3KIzWaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3KIzWaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445482;
	b=mNre5jzocGG2O/nGoIJH9H8K7cAgpF9aS79EX8oHqNyIt8GPLgAbA8y5aLagNmNycali6g
	Jk60Ykqc29BNbaWSE/dMlOHlEPb4Agi+fjR2yVaHWVeZ1ejQzOiEIIH9jZGhnckI2m95p3
	5qHnc5mgcdvF6d28zqyQXb1apLaOXVo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BdWjSwId;
	spf=pass (imf08.hostedemail.com: domain of 3KIzWaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3KIzWaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LkNUC+PMoXZDStaNEegSy7SLi35cqcuQZkVqC98j7D4=;
	b=JcBz7Tc2Bo/1NBOPD6cZIQbRocnIvuTXMj2khkigsNlJxFBGNZdNYrMd/WmC9m83pDGLqk
	rNNjJVwlupRUGAE+SvzvhIz8zoFkBRVMehic6eNPfQon9974W4gp7taKB72NsQwAIapJ5p
	n6mXEBmAmBpGUx5VnxAwqZCKekPu3dw=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so24192675ad.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445481; x=1793050281; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LkNUC+PMoXZDStaNEegSy7SLi35cqcuQZkVqC98j7D4=;
        b=BdWjSwIdExj5PcQxWPwNa8x1DAj6AG3RrBJM3JCfl79ijDQI9x2iZOPK65Vdy3bOAQ
         ymvoytUurqFAsoMRJ7P1uxafZD0MRBGio3jDftBjcKXf1puDRoqxq6rIaIuGLOOTp3AK
         kCgbeCyzG0uMI86IPEZSCyQ+yqZIN6rFWY2hUdnHhy1OasgSqCK8kKE5zNobQ5BNxKte
         Z92MBpmnUcoRSQ3HrjfgtIaGmDoCZKTfhnpS7+FmM+nDMF/DII7zl66F22rvCgRPwPpU
         mkcPiASyc0f2WSH8BrqydubKUwKUxdtUIJZf609yMzmJu8JMFxXbImVKfUf0Sb7TF+vq
         aSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445481; x=1793050281;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LkNUC+PMoXZDStaNEegSy7SLi35cqcuQZkVqC98j7D4=;
        b=MbCqzXu2r/i1E27A1KK/MwDgrsOMGyGwGP7g0fSOxSkyvoKSnlNqNiMrkyH1d2vpwt
         vLIXA1GAvSvL+Vzl/7KO8jPlpijMV6HF2KwhcuE5JUu6W4NIWKwK27vNG/iN35C52iTk
         TXp3sW2bvFZr4ypGNU0VfqicE1tgcbiyRNxZfZEzEZKG9nJUfqUP13V/BasKoqJSJ7qP
         7W3Dq0mzuFh31P4qT10SH0cmFuwwH6QSQ8Nh7sjRPYnzx4qrd8q+U44Nv8pR5+C+R0Bq
         /dWmtPK+L5ZRwYq4R/a2E0FkN0UWTsTktqwJdf+MspTaTZhzVpFzHpQupw0fhrc94Xox
         Ob9w==
X-Forwarded-Encrypted: i=1; AKwUvBx7FlbPWcYRwA7LbhO1CET06xkV29HsQFFlpxElvrpVlqfD9umeJWK/aZcdT/VwafIm0v9GLY5gEA==@kvack.org
X-Gm-Message-State: AFq9FYIMcFWkszpdc2MXZDK3jAHOk1H5e87IoUwxtVDG+O5rJc+fypRo
	fESABL56Y3tGFxYyPxnWhRuE24F5MCrNULNarnz5MHd17V3zoraesKh0aDc1q4xbbM92uAsnvMG
	tAqE/1i8V/gatYQ==
X-Received: from plcn2.prod.google.com ([2002:a17:902:d2c2:b0:2e5:40ef:ff34])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2c6:b0:2e8:4f3f:60dd with SMTP id d9443c01a7336-2e9a69e9987mr69340785ad.37.1792445480207;
 Mon, 19 Oct 2026 14:31:20 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:44 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-1-dmatlack@google.com>
Subject: [PATCH 00/10] PCI: liveupdate: Keep preserved devices accessible
 across Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: onkwktebjymxgqr5wh5bt39okmjhoq9j
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0707D160003
X-Rspam-User: 
X-HE-Tag: 1792445481-262803
X-HE-Meta: U2FsdGVkX18Cse20+hPOHAZPw5GmJGoQJ9y6MKzF/kwCLcsyK5/vxzu+nwPpDMSXXIMCQb90i8cskNeW42zNzFEFHMLlHY/zLROS8XYdBwWcNVw1eRB3SULxpUO15trPgPYDvNuh4X32kTRKWXTL2qaQWs4DTKPUtIeAOYYTbVTucEtM3e7J+XdE9b10Yg/uQyaHnrJ6oVJUPET0aVwAgnD5cwrSn1cjTOWhWkjSpAC1dMYT2vCEODi9o1EIK1JfkWDXWCd3nZsOLB2GsJxUHJidZRFUjyxyRO93ft4OWSkTrABihAn4U857IV1Oo3y2CD5m/KXQP3Y4ICXhbCptCPDYwlo2f80O2OVLs5iCqINSFpMnAJuMqpJhbOrFyai+YDv0HenOBFDzVlHhIcC9Qb9RSX779lqpXyEW+0SjOuQw9IKSii8sAZ2sRSOJCC2jSOhRIbXNth6CDkD1aqB59GO0xY4tlHSgncInhnLd2GY+kE4AxxDbb4lpln6dPKUqzU2tKWQuKyNGvXO/43tpYL20n+iHnjmKlZ4hV0d27hzPDNsJSSUnqRilHL2w8NU8RiBit8wX0RHZNnZ3+InwlThv/qitRczXihat2/Zg5HXUAPULXLPEDlwzX2S0wL0EQ4jDjmFAbfNI/r6mku0v0oRSXF5EVjv1JHGFpQLzs8vURLctEp+IxihsOGA0nk41mb19SmO/s1VptUYZLy+7vmUkQc/4PeCu7QjB+spwgM43pdVRQ37VeAdFkBLrdrvAH4rKS6Nb8Lh+/2UV6q1Xg97ilcoIrlM9POG6VgVFljZLWjJaCqPaRAbax54E1qqK7I9QMDvfYvCPHkHHt4a08eZDr3qHsWFIfsT3C3oQxLoTNFTAkHx5SRLkDQjtwluUp2AP0ER1AKwOV7IhRYmrR0hM04B8BuWKrPjmtdEw33hl4LRVDSgwAKjqSeBXvbgeykrgXnZW2PwoKdbW8Ka
 cqlOcDds
 AUEDGDGJj4ABHTkHk72z0QZD5oL405A9IMy1qE11fKJ+2M7ZouGrKHAGayOgFlIxTPoTgqoFI6h+mmc62tKNaZeZIS+io7bksPVhKlFrFW8FSscCoHCCqqyEwIe1o5O6XTi+/QhNKKfFsyMu0Qup2SpC0Gz/g965tjNqYucaL0sWOksWMtRJWOnE2yQeGFqKuJyrXoqkzV5vMUEobh/9IYgtEmN/0i0L4T3RFcfbbPQaK7FkE7KOBg6QzKq3NI8QRj9s/+7/JzVyFzB8tWRIBXUcILW0WXhpcl0tLSiHdlkOeAwXcTQZKdHD2iXJzbxN1I/nzdL4vL8XgLt4Qs1rQAADWRLNH0E6KXvTsqw3Lz492CpeElCtRHm2jdLSjEKvVdSVFmaTpDWkfssGqryPd5xa6GHJGf6Bl94AWWAejFncrcxAl1SNAJ4elwIK7zAy6PdBWQlbdpIpTCMpvY+LL5etXsh+oaIAhruDU9tsSn9PjNkp4Gu5I/MW/HklDrqEIiHQSd4ZTbJ+ULKFuiDHu+Fc1gphWStk6Iyfw3M8XlF5bMWgP0902g331VEIocTZU+zskhpy+Rll8noZDloEaUj3p6ZtdjIdLnJPtKFIHifT3kuKgbTbgH3/01fZbTRmHHGztWZp1S/d0JFnAGMn4LhVu5yTBrrFMMIgyktT+E1jps9lrBvI2xw6KXl6Bfyq6uJcGvY3ZL3FxTzs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/pci/p2pdma/v1

This series builds on the PCI core support for Live Update [1] to allow
memory transactions targeting preserved PCI devices to proceed
uninterrupted across a Live Update. The base series allows preserved
devices to perform DMA to system memory across a Live Update, but the
next kernel still sizes, probes, and may reassign the BARs and bridge
windows of preserved devices during enumeration, which disables
decoding or moves address ranges out from under anything that is still
accessing them.

Use cases include:

  - P2PDMA between preserved devices, e.g. between devices assigned to
    the same VM via VFIO.

  - MMIO from Orphaned VMs [2], whose vCPUs keep running in guest mode
    on dedicated CPUs during kexec, and therefore keep accessing the
    BARs of devices assigned to them throughout the Live Update.

To support this, the BAR addresses and bridge windows of preserved
devices must not change across a Live Update, and the next kernel must
not disable decoding or forwarding on preserved devices or on the
bridges above them while enumerating them and assigning resources.

[1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/
[2] https://lore.kernel.org/kvm/20260920193650.3373435-1-pasha.tatashin@soleen.com/

Series Overview
---------------

This series implements the following:

  1. Avoid sizing the BARs of incoming preserved devices. Sizing a BAR
     requires disabling decoding. Instead, have the previous kernel
     pass the BAR masks (the values the BARs return when read after
     writing all 1s) and decode the BARs from those (patches 1-2).

  2. Avoid probing which windows incoming preserved bridges implement,
     which temporarily disables the prefetchable window. Instead, add a
     generic mechanism for passing the results of probes that require
     writing to the device, and use it to pass which windows each
     bridge implements (patches 3-4).

  3. Skip programming bridge windows that already contain the values
     being written, so that pci_setup_bridge() does not temporarily
     disable the windows of preserved bridges. This applies to all
     bridges, not only preserved ones (patch 5).

  4. Claim the BARs and bridge windows of incoming preserved devices,
     as programmed by the previous kernel, while scanning and before
     anything sizes or assigns resources, regardless of how the host
     bridge driver sets up resources. Panic if they cannot be claimed,
     since that means something else may be decoding the same address
     range (patch 6).

  5. Prevent the PCI core from assigning, releasing, or realigning the
     resources of incoming preserved devices (patches 7-9).

  6. Avoid enabling INTx on incoming preserved devices, both while
     probing whether INTx masking works and when the device is enabled
     (patch 10).

All new behavior applies only to incoming preserved devices, i.e. only
after a Live Update and only until pci_liveupdate_finish(), except for
patch 5, which avoids redundant writes for all bridges.

ABI Changes
-----------

This series uses the optional feature flags added to struct pci_ser in
v10 of the base series to append new fields to struct pci_dev_ser:

  - PCI_SER_OPTIONAL_BAR_MASKS: @bar_masks and @rom_mask.

  - PCI_SER_OPTIONAL_PROBED: @probed_supported and @probed, a bitmask
    of probe results (which windows a bridge implements, and whether
    INTx masking is broken).

The ABI only contains hardware state (register values and the results
of probing hardware), not kernel-internal state such as IORESOURCE_*
flags. If the previous kernel did not pass a field, the next kernel
falls back to sizing or probing the device as before.

Merge Plan
----------

This series applies on top of v10 of the PCI core support for Live
Update series [1], which is targeting Linux 7.5. This series is
targeting Linux 7.6, or 7.5 if feasible.

Both series will be merged through liveupdate.git, matching the
agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.

Testing
-------

This series was tested in conjunction with v5 of the VFIO PCI driver
series:

  https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/

The full set of patches used for testing can be found on GitHub.

  https://github.com/dmatlack/linux/tree/liveupdate/pci/p2pdma/v1-with-vfio

Testing was performed using vfio_pci_liveupdate_kexec_test with the igb
selftest driver, which keeps the device performing DMA while kexec
happens. QEMU traced every PCI config write, and each run checked that
the next kernel did not write to the BAR, ROM, bridge window, or bus
number registers of the preserved device or any bridge upstream of it,
did not change their decode or Bus Master Enable bits, and did not
enable INTx on them, and that their BARs and windows had the same
values before and after kexec. The following configurations were
tested:

  - x86 (q35): igb behind a root port.

  - x86 (q35): igb behind a PCIe switch (root port, upstream port,
    downstream port), with a non-preserved device on another downstream
    port of the same switch.

  - arm64 (virt, SMMUv3, generic ECAM host bridge): igb behind a root
    port. This exercises the path where bridge windows are not read
    from hardware during scanning.

Future Work
-----------

Please see the PCI core Live Update Roadmap:

  https://lore.kernel.org/linux-pci/20261001232133.560284-1-dmatlack@google.com/


David Matlack (10):
  PCI: Factor out BAR sizing from pci_read_bases()
  PCI: liveupdate: Avoid sizing BARs of incoming devices
  PCI: Factor out bridge window probing from pci_read_bridge_windows()
  PCI: liveupdate: Avoid probing windows of incoming bridges
  PCI: Skip programming bridge windows that are already programmed
  PCI: liveupdate: Claim resources of incoming devices during scanning
  PCI: liveupdate: Never assign resources of incoming devices
  PCI: liveupdate: Prevent releasing resource windows of incoming
    bridges
  PCI: liveupdate: Don't realign resources of incoming devices
  PCI: liveupdate: Avoid enabling INTx on incoming devices

 drivers/pci/liveupdate.c    | 363 +++++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h    |  26 +++
 drivers/pci/pci.c           |  18 ++
 drivers/pci/probe.c         | 110 ++++++++---
 drivers/pci/setup-bus.c     |  62 ++++--
 include/linux/kho/abi/pci.h |  52 +++++-
 6 files changed, 589 insertions(+), 42 deletions(-)


base-commit: 312200e9211ede3f9a03cc17d094805e06e4674e
-- 
2.56.0.212.g129ede20d9-goog


