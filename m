Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97285C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971B56B00D1; Tue, 14 Jul 2026 11:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9225C6B00D6; Tue, 14 Jul 2026 11:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810866B00DA; Tue, 14 Jul 2026 11:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4506B00D1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDCA3A0430
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:12 +0000 (UTC)
X-FDA: 84987730464.25.8A6323E
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 476C21C0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DF0F2dTf;
	spf=pass (imf21.hostedemail.com: domain of 3fVJWagcKCNQL8F8DI76EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fVJWagcKCNQL8F8DI76EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AdMdxqs5Z8x509tTZKpL2bKGAMA2jSi8MmCd4hShlVQ=;
	b=vf6q3Olem4BtBktz8P+BUItlGDP7xN9cv0ZmCu81Uye3T/Lkok2najQKcJ2Eum57EMOWVZ
	g2yoFblJlgGfod64Sg31uA2xg7EutskfRkfajiwWZ48x8R9z/XvDf8TWLfJMoAV3evQKeQ
	UlWE/d34J9RU53WCMFblsVswETKQKVQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042111;
	b=Xg1ofdE9084PytEOr3jLqQFdKvqCkHhbujjTDNneE16fuTu70j8oLz645ZfPGhZdYqjq1d
	vkPfiIcVTYf4DAI5Zfp888EBD/xfU8sfKpixNU7xyTVGhS9qvVQR4EwbJ8XIAZJ0VqM5jp
	mc5O0960ijPrlNNmNElLAw0pAKg9wtQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DF0F2dTf;
	spf=pass (imf21.hostedemail.com: domain of 3fVJWagcKCNQL8F8DI76EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fVJWagcKCNQL8F8DI76EE6B4.2ECB8DKN-CCAL02A.EH6@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-84a06bc82easo4135517b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042110; x=1784646910; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AdMdxqs5Z8x509tTZKpL2bKGAMA2jSi8MmCd4hShlVQ=;
        b=DF0F2dTfhDhigpMX7/dVIsn5+0tZmfGnz0ZbDq0SUb8ZV5gzYBANWohOhLydBKnv2M
         ugzyb+ytq8sXF/UxulT7ghr9Mt9gdN72uXN2MBew9AsR2yZQ7mTO/mLhAZwBQTwoUlVn
         NB1wUF8nmuxsoIhUFuaJ9bQq3dtc0KR02M6ZNcZyBFSz3Zl6UCW4ONdr2PhehoBRpLVg
         FPu61ILe6aQQKZ3yc/nLorD1BhD0IdiqmSJZVuqIlWsCWAUfkmoHhP4J1o4Q7yrR8/Bp
         EQHGc7ndCco31xO88X+Nr9iBb590y7HbsvpI1320pTNaJEZMvzicooPUjeHxRVD2XAqu
         4uFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042110; x=1784646910;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AdMdxqs5Z8x509tTZKpL2bKGAMA2jSi8MmCd4hShlVQ=;
        b=iCI7/Wn5PGID7S/h7GwluBAtQcI8AGAFtlAjSuS2Y+Owjyrmj7weLmAJSd4wenvwjN
         iRhmfUHw4PKyvI2KmNmx+fRYWusG4Pyxn//lY0kxCVo0Cu4Wp76C7ZLSHvY9bV22YmDs
         3CSGO/dIeklMAtkSspMPJc0T9UdOJi7Wq2mSwpe6NFysDNScbh3PQI94tOflqRFF7Pq1
         Ntikarf/TicU9IRqEJwLBVxQjmyoMUW1vKfPHYYbWDB1AS0dMhOFdtl93aEax5qATnui
         xPKKU7CBlFGgz3/Y6gyVsS33oc6bDp6EgcCOobCYaVvGlOxPYwR4MFOSFoZig2rzWj4s
         rOMg==
X-Forwarded-Encrypted: i=1; AHgh+RoD9TlwsJbYQQ7bbl7KR8VvS58C8h9kWq0YzZ84Tx3nIzONTZfXfC0yoB9S+PkA+J8aoc1T9avfsw==@kvack.org
X-Gm-Message-State: AOJu0YwcqbmZG9Hz/VUzqeJXOxgGfjQw1RNtIXcHo2RPdkCjb6YzeCcL
	h2YE2jm59TkemuUyBR981Dezb23yaboAFEaNwoX5aTJ7UdThk5MkwVUPu8sOpKz9e6ROLsFVUuO
	4WQ1nMtUJvQ==
X-Received: from pfbhh6.prod.google.com ([2002:a05:6a00:8686:b0:847:9199:e06])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:460e:b0:845:363e:12d9
 with SMTP id d2e1a72fcca58-84a554f93damr3265089b3a.3.1784042109576; Tue, 14
 Jul 2026 08:15:09 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-1-vipinsh@google.com>
Subject: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 476C21C0009
X-Stat-Signature: oy56hnj5g864daohnnewprpbtze54bi5
X-HE-Tag: 1784042111-354106
X-HE-Meta: U2FsdGVkX1/D80goG2qKPwLuIXVBekXe4ShY8l5k/kRbeTqgGgvUG+ixd4nG4V1n/6W3sTS5phNRx1oeNLDxMzoPthuo6w6nwUWXOneSRmPGCtZRIGjatbnejmD4IxIVoj+C0SzUmXejHHZIqZDF3H0YRlRyQhjrFnhXx4cFADxqDvcfzyY34woj1Hcl8qq1f7GmEcTfbsf4hzLmJJvR5P9B3ycBgS/pmr3GhHvFA/NfJBKV0sa3oqejdFV/uWks0tC9mr2rPf1uKd6exc63J4iLDJdaI3QaNHQ6/wUNJGq2QTKdqvrlM4T2RUc1Wd0JRlRUSUW/g1W0coFmrd2TpCdN+Dyk2K4PC6j/0ywkceIZi06zXgIrvZQJg49vL/8QwRlI3OcYVvuyNIXiUxJZMgIkeigF+P7Ni7xcOEjJ23oj/ByAhNAicH7wARsCQbS5yYuRAc5OeZMyRn1JfvREU/WRHGnRc6l7mD1Y3jIbI3C/71JAf2as8NemteCwiejNov3xlEELWy8UuN9hHdbaxgMkaCgjilDBctUcru6ZqwpPaasZ8ZkVBuSE3p6JFw/GfK8DEw2usb8bbUT4KYnieDOvou0kqwGgrrqpICyKMFZNsvJAmd5GqCGvFqGntiAxV/sCgoH1LI6HzNNY2o2+v8wPU4guAwsnHqFo3YBkqjdhHaO5h0bVIMg0/QALelVwbptSOlyWjqXJGuiyLuwmX8iCmuqk8LlbXFluxc38ThV9WNnxfpDTJyMd3yb1Ghz1VJadfMPhXfvm7H7o3n59Bx9xWNhZ8WLoMGAi0wHPj2RCVHhNKziCDq+EskvbKGSDYliXznlOsMJgR+DN6RG8aLTpdYPBWbmRKjSwZZu8mT0heqg8psc9opMj5rT5GmHTM1JcZsevOP/S3OeRQbJcbfJMPCUfa76NOSiQz6lu+jGaxeuoYQij9QV7KGOpaKj5joSxcko9i2uvtkBve35
 0jBFGa3W
 //oWGss/VPwBwUdJj9FbhWE3VoCp6kIC8ruSUgqeaLor2/PNNBwnB2FOyyR/VvE1fO7KCmyykvZvqRXHHFko6ObC+yMTZ+abSefqLWUftfKOLoG+K+AXvDXo93pktR/TuaoTy0r0owVzQecfX8IGLR9wIkWlG3xyctlyIpqvAAsAgidsVV3MLCmQsaEDxg2U65AO+hze8WrMtHqp7B39EWOuclwxFv3cze+ofxwCFWJykaFTHYMECMNPKp5jooueI52yWuq316LrTUQJgAyx4DnN/a1JHm4fJIu8v6Ro5OIClvKVFkOYJTw49NDAAq55KsP+bCHvfuIfFchdygSr65Bpfk1zOY2V4poQeOnpzlrKf0xXQH/QfO3CjBQJAPayPmdYKQ9qJuZqldCcUwpKmEk4T0D/qTBe3gk3ouD6E/KuCW+13e0l1314GdDY0TGwe2l7yoXFBYLu+AqI2tbxJiLgMCCeVum/cJEdt0MnFAnqmN0PLXMJVA9AGae9XXAccKJksGCUM/Wy8oiq6SOWEdZNkF2JX7/06VXRlhaEat4Wub/T0WhPgP3QozemSL5bagD1o5MbsoCH2lszcG+0AtK/T3E9RAlNtJecEuueEQ8dUMtuPkouk2Sh801vg641r/1Y8472SATSpg4LC5zR+W4hfEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This series can be found on Github:

  https://github.com/shvipin/linux vfio/liveupdate/v5

This series provides the base support to enable Live Update feature for
VFIO PCI devices using the Live Update Orchestrator (LUO) and Kexec
Handover (KHO).

Overview
--------

This series makes the following changes to support VFIO Live Update:

 - Puts VFIO Live Update support behind the CONFIG_VFIO_PCI_LIVEUPDATE
   config option (which requires CONFIG_VFIO_DEVICE_CDEV).
 - Preserves VFIO cdev device FDs across a kexec Live Update session via
   LUO/KHO.
 - Enforces that incoming preserved devices can only be retrieved via
   LIVEUPDATE_SESSION_RETRIEVE_FD post-kexec (preventing legacy
   group/cdev opens from accessing uninitialized state).
 - Quiesces the device prior to kexec in freeze() by resetting hardware,
   disabling bus mastering, and marking the device frozen to reject
   post-freeze IO/MMIO.
 - Includes VFIO selftests (uapi & kexec tests with continuous DMA
   checks) and kernel documentation.

VFIO PCI Live Update Roadmap
----------------------------

We are planning to add VFIO PCI Live Update support in phases. Since full
support of this feature will come in phase, VFIO PCI Liveupdate is
controlled by CONFIG_VFIO_PCI_LIVEUPDATE config option. 

This series is phase 1 below:

 1. PCIe function (non-VF) preserved across Live Update without changing
    BDF
 2. PCIe function (non-VF) preserved across Live Update without resetting
 3. PCIe function (non-VF) preserved across Live Update with continuous
    DMA (noiommu)
 4. PCIe function (non-VF) preserved across Live Update with continuous
    DMA (iommufd)
 5. PCIe VF preserved across Live Update with continuous DMA (iommufd)

Dependencies
------------

This series has following dependencies as shown in the diagram

    |---------------------------|
    |         VFIO v5           |  <--- Sent in this series.
    |---------------------------|
    |  Liveupdate Selftests[1]  |
    |---------------------------|
    |        PCI v7 [2]         |
    |---------------------------|

[1] https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/
    These selftests changes are needed by other selftests also (iommu,
    kvm), so, I have sent them separately.

[2] https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
    This is the PCI v7, which adds the live update support in PCI core.

Github branch I have mentioned at the top has all of these dependencies.

Testing
-------

Tested using VFIO Live Update selftests in both QEMU and bare-metal
environment (Intel DSA PCIe device).

  $ ./setup.sh 0000:00:04.0
  $ ./vfio_pci_liveupdate_kexec_test --stage 1 0000:6a:01.0
  $ kexec --reuse-cmdline -l -s /boot/vmlinuz
  $ kexec -e
  $ ./setup.sh 0000:00:04.0
  $ ./vfio_pci_liveupdate_kexec_test --stage 2 0000:6a:01.0

Kernel command line options used:
  - liveupdate=on
  - kho=on
  - vfio_iommu_type1.allow_unsafe_interrupts=Y
  - vfio_pci.enable_sriov=Y
  - vfio_pci.disable_denylist=Y
  - vfio.enable_unsafe_noiommu_mode=Y


Changelog
---------

v5:
 - Addressed Sashiko feedback.
 - Removed condition to disable CONFIG_VFIO_PCI_DMABUF.
 - Expanded vfio_find_device() helper to safely discover a registered
   vfio_device by matching criteria. Internal Sashiko instance found
   data race.
 - Updated selftests to latest changes in VFIO selftests.
 - Rebased on top of PCI Live Update series v7.

v4: https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/

v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/

v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/

v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/

rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/


David Matlack (7):
  vfio: Enforce preserved devices are retrieved via
    LIVEUPDATE_SESSION_RETRIEVE_FD
  docs: liveupdate: Add documentation for VFIO PCI
  vfio: selftests: Add vfio_pci_liveupdate_uapi_test
  vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
  vfio: selftests: Expose iommu_modes to tests
  vfio: selftests: Verify that opening VFIO device fails during Live
    Update
  vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test

Vipin Sharma (13):
  vfio/pci: Factor out the reset logic in VFIO PCI device close path
  vfio: Export various helpers from VFIO
  vfio/pci: Export vfio_pci_dma_buf_move for vfio-pci module
  liveupdate: Export symbols needed by modules
  vfio/pci: Register a file handler with Live Update Orchestrator
  vfio/pci: Preserve vfio-pci device files across Live Update
  vfio: Introduce vfio_find_device() helper
  vfio: Refactor vfio_device_fops_cdev_open()
  vfio: Add API to open cdev device for Live Update restore
  vfio/pci: Retrieve preserved device files after Live Update
  vfio: selftests: Build liveupdate library in VFIO selftests
  vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
  vfio: selftests: Add vfio_pci_liveupdate_kexec_test

 Documentation/core-api/liveupdate.rst         |   1 +
 .../driver-api/vfio_pci_liveupdate.rst        |  23 ++
 MAINTAINERS                                   |   2 +
 drivers/vfio/device_cdev.c                    |  67 +++-
 drivers/vfio/group.c                          |   9 +
 drivers/vfio/pci/Kconfig                      |  12 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |  13 +-
 drivers/vfio/pci/vfio_pci_config.c            |   3 +
 drivers/vfio/pci/vfio_pci_core.c              | 119 +++---
 drivers/vfio/pci/vfio_pci_dmabuf.c            |   1 +
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 340 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  28 ++
 drivers/vfio/vfio.h                           |  18 +
 drivers/vfio/vfio_main.c                      |  67 +++-
 include/linux/kho/abi/vfio_pci.h              |  43 +++
 include/linux/vfio.h                          |  12 +
 include/linux/vfio_pci_core.h                 |   3 +
 kernel/liveupdate/luo_file.c                  |   2 +
 tools/testing/selftests/vfio/Makefile         |  23 +-
 .../vfio/lib/include/libvfio/iommu.h          |   2 +
 .../lib/include/libvfio/vfio_pci_device.h     |   3 +
 tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  25 +-
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 +++++++++++++
 .../vfio/vfio_pci_liveupdate_uapi_test.c      |  97 +++++
 26 files changed, 1097 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c


base-commit: cbf37fff757e87376e80e11a8378393a8f25145f
prerequisite-patch-id: 85705fb54d3065efe1d87ab4b69e828a9f3404e7
prerequisite-patch-id: a33ae79b5fc0259bd013b430c18cc3d14a678599
-- 
2.55.0.795.g602f6c329a-goog


