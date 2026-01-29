Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D6BD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D786B0088; Thu, 29 Jan 2026 16:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B0D6B0089; Thu, 29 Jan 2026 16:25:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF9F6B008A; Thu, 29 Jan 2026 16:25:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEDE6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAB0C13A2E0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:40 +0000 (UTC)
X-FDA: 84386283240.12.E262F6B
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05236A0008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZjoZGRed;
	spf=pass (imf15.hostedemail.com: domain of 3UdB7aQgKCDQTcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UdB7aQgKCDQTcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F7w0g/nR8ml7KkZqbualmYDfY5KbOVPfKhgZAMsaNL0=;
	b=XKTn0CUHQ2dceIjv92DLO5qKDYZEJG3dIXJld+2eww6Nv23LxdV3bWfug6IVsKTTdoD4YR
	xsW9jwcLkh/ih7eDRyyoz8qMu8B/2pE1KACcs3Ome1yT05cMtqsItT5RiWcO+VRi3wInVy
	2cnWcOYevVEIRjOEya+36fAAfx3EOz0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZjoZGRed;
	spf=pass (imf15.hostedemail.com: domain of 3UdB7aQgKCDQTcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3UdB7aQgKCDQTcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721939; a=rsa-sha256;
	cv=none;
	b=3srmcZC07TgkxgrAMsQ04zD4n1yxmVeaxmNq6aKQPzotegqW2KDm/UXFzXswWvgmDLk54K
	lU+8+nIKZ0TbLkWNwumGl6FcqBQMFqaiGYuV+huTbKMLkGQzF7pAZc9JLQ4ISCWR/RxixJ
	eXPVhMqxEBjIcqflPA4kQat0wV63nts=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac814f308so2198801a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721938; x=1770326738; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F7w0g/nR8ml7KkZqbualmYDfY5KbOVPfKhgZAMsaNL0=;
        b=ZjoZGRedJsdSbZ2eCsdXwSyLosLwRWK8xulkPSvox2yxFWb1TJ3W6OfGTmdqXyYGh8
         iggMAbB0AyFFdzJTeOYKRxbJRprqgN8Lt+FBZNz53jtO9hu6oHQKmwyoRx4ItZuJNI9j
         q7JpN09CewqErWs/wuGXJizx3huP30ow5bw4LZmfa2quDk6y8cWv6D4ogDK3USU7sInh
         HbCWxmvS3SFj4UmxfXkZWLmp6UKegc4wokf4g8H4Gi6fAv0UC8f0B2gKsroOB02xRtC5
         FfSo6fwCTE2eUV7alvWpTyETPd9ZzB3zAlqKsbGb0ENQN1aMlO15oI6lVtWn27QWwXQ7
         dd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721938; x=1770326738;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F7w0g/nR8ml7KkZqbualmYDfY5KbOVPfKhgZAMsaNL0=;
        b=ensnrKs8LjDK0YbmYKxAyLgaDuBgJZXGIEU0elee3brCC6XJYWKtJlv3YWsWrRT7I+
         MZTzI4tuNklgFxm9muDOGdtZEL5TvdbxnxjT7BzS2R5LIRhaAqB414Bm0EyaRMWonxuy
         4vQaCdU36Y/tekg3EH91zFmw/Yaz/dYdVVrKnoUllXKm9UbMVK+nWVJf0Hp5NOF1/xXT
         dwKKNQX6UseqJprBfY6uWR49spwOwbM461bwb/EO+dOL/l9+VtbEFR/oPPECN7a2Smr1
         B1YkgsM/qZ8yi1wET8DUMhMKxmmOO+EdiOgK8tR07xYeQmXeQjpQhTNuHa8mKiSU6qAo
         tgzA==
X-Forwarded-Encrypted: i=1; AJvYcCVcTLa463qONDUk7IAGSBxrT3XbHFcIENceB9rVPLg/duohi69YfejYyTsalAOR6hH/ea7EIfVkNQ==@kvack.org
X-Gm-Message-State: AOJu0Yxkvhs9E8e3DO0LLovIyMsER5lNAcwZG09MIv0MAzmlFAv0C/P+
	U1+VlblEg9zwqUIXseLowSpoB0T1FX6r7Ftr9S4zyVyx/bg1Ss854gPkTLL8SY0Z+g6czteDyUe
	CMlEycU1+ic+NXA==
X-Received: from pjd16.prod.google.com ([2002:a17:90b:54d0:b0:32e:ca6a:7ca9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d06:b0:340:d81d:7874 with SMTP id 98e67ed59e1d1-3543b3b43f0mr808394a91.26.1769721937697;
 Thu, 29 Jan 2026 13:25:37 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-1-dmatlack@google.com>
Subject: [PATCH v2 00/22] vfio/pci: Base Live Update support for VFIO device files
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05236A0008
X-Stat-Signature: bynm6pb7j3skp5s1awdxe4qmrshqgash
X-Rspam-User: 
X-HE-Tag: 1769721938-157817
X-HE-Meta: U2FsdGVkX1+Gz5uUrs2HEW+Fq3AzqXCgutANKr3YsLJlC6s8OhcY+I/nLeVpb1LBMhq0lnt422qhdcAJ9YHacJqd0ftvrMkGuES0k+tKJocggbPnQY6GImCnXbDmhJj41l9OQhPB1rg7ENNDT3i65yEyQfbz9JKom/2vMNnzRJJNX7r7HN4haEHSN8GrHlskfhcPSib8FfNrHrC/2e3c0HneG21+Fd020mT/yzxiV4xslITkhTAndwg5wcSvEpUqzWGCqSdqw41d5f3qWJwR2X1iHj07+PYSc/sJyY15svZ7hFa1ZaIpxOZZvfApofHexCn93Eho9KTCWojYpwa2uABU+SqWjNVs2S0J6tSXyVDLs9itXExbIYOGzXYSb9HxMpl9+xF68xbQZR6u87C5poskwFTYPqcwYSoctYDShyQ6wLMbtFn46zYWIBot2fE7f6s5dY+3ZAyQWD7Zcd3UZ1SJfF8/IaKzFcL88u+UaOpRzHl183optG0dGyyn4K2VPUg3ap4otLLq3myyXUaHSi0H9Me/3iyHkRUxsV4Hk/MzM9GWF3LjZfTu/C01/SSAme7QmdWHiiIhl/GI5A3308m4ENNkeZt3HzHg9FfIcpHQeF3syQe64eUj+5MNT04hdzSLsDgR1Ri4xwl5mhFVqS9MGC5qSX/kxD0bUjGpSMcZnUq8qnXFFnJlFTR1/sR+vCzayc70MFQSAVYEBfn2zxGJR6B4bvdn2fC8CtM6RW/lJM3/LkPFTIJWqUbKIqE244Gy/22tdypAHf/3IPi99TZNuOXaN9bSGpiz508k9660k5VOOZpdtpd+2kG5VkQ2ZLjr2zt+fWmovSgAaDLnFKi3Myv4N3EJbZCSjItNiBA+0O+gA7lXEemkJ5fKCcAOfyxJwDjrfr7aN8tXZ3G73xGCqOixoddpRI+Mc0FIAA1DhGIjNPi5YDROqzp6wFul1zIdd0nJsK/9AVHptoo
 IabyVlo/
 Ut6irY20TKKR1z7MpObVJF1lWfGzaeZn5xaSMvgBk/HHbLM+aG0zcStulYTv076EI0xAMd3oaJrGwkP+S4sclucVYZZGmeZdp4JTHGKULFk1gZvy9xixCMRBpypo3AOooR7+1lYLYCpLx8EhoyQXIZdOeJDqw8TAF8VfrWHizZCiUeqwyh9EI8hFHjn2/V7UNI493WEGXeiWRs9+H5y4q/jCOdKTgXZ5Cqz2hRVu/63Jnwj98dVCU/RXfHcD9e5nLmhEzfdhhkzhPq2wjewvgjzAQqxBKS7UVNmObNURqsoDvXSPxnSugFHLDI5eticuMtRHftM0bJ3iMc6kDWx8BArHLq32HDKaWIG8Bcq8mCgxcYS+YKVTiRQCNr0e7UdpmMlqYl01pWgp0OhhWmEh8SfUMmV2SVU8gASV7w/9Ol4uCWbRm5BbJxlG6oSMS1w+ikRxuNbRPe5nXTA7DDtX7u4/TxBwIwKxFkGg/XVMufQdIVzuq3K2NApLffhPek+2x1Bxlvz3tYATYu6FegVNlP0MC9FYpl0rKm5rnF2BcXaAoX57Rv82hBvfqC408Wkv0kaXFyGiWezEV0tqyPOMKG6kOrbBetlwXXUG+ewkPlghjPxCybwIWrGGyU6CKIVFYmF0ICHOfWJ22N45IRNoP6vnwZGSjKowen0CDJj1luQzgj5mUIMNkUaOrHiyxOua+R2C1qwopPf+fx4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/vfio/cdev/v2

This series adds the base support to preserve a VFIO device file across
a Live Update. "Base support" means that this allows userspace to
safely preserve a VFIO device file with LIVEUPDATE_SESSION_PRESERVE_FD
and retrieve it with  LIVEUPDATE_SESSION_RETRIEVE_FD, but the device
itself is not preserved in a fully running state across Live Update.

This series aims to provide a foundation on which to build the rest of
the device preservation infrastructure, including:

 - Preservation of iommufd files [1]
 - Preservation of IOMMU driver state
 - Preservation of PCI state (BAR resources, device state, bridge state, ...)
 - Preservation of vfio-pci driver state

Testing
-------

The patches at the end of this series provide comprehensive selftests
for the new code added by this series. The selftests have been validated
in both a VM environment using a virtio-net PCIe device, and in a
baremetal environment on an Intel EMR server with an Intel DSA PCIe
device.

Here is an example of how to run the new selftests:

vfio_pci_liveupdate_uapi_test:

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test 0000:00:04.0
  $ tools/testing/selftests/vfio/scripts/cleanup.sh

vfio_pci_liveupdate_kexec_test:

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
  $ kexec ...

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0
  $ tools/testing/selftests/vfio/scripts/cleanup.sh

It is also possible to run vfio_pci_liveupdate_kexec_test multiple times
to preserve multiple devices simultaneously across a Live Update. This
series has been tested with up to 8 devices concurrently preserved.

Changelog
---------

v2:
 - Rebase on top of linux-next (tag: next-20260115)
 - Add missing EXPORT_SYMBOL_GPLs in LUO (Zhu)
 - Add Missing EXPORT_SYMBOL_GPLs for vfio_device_fops (Zhu)
 - Fix circular dependency between vfio-pci-core and vfio-pci (Zhu)
 - Handle pci=assign-busses (Lukas)
 - Drop driver_override patch (Jason)
 - Use kho_alloc_preserve(), kho_unpreserve_free(), kho_restore_free() (Pasha)
 - Don't access PCI FLB after device initialization (Jason)
 - Fix folio leak in vfio_pci_liveupdate_retrieve() (Alex)
 - Add Documentation (Pasha)

v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/

rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: William Tu <witu@nvidia.com>
Cc: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Josh Hilke <jrhilke@google.com>
Cc: David Rientjes <rientjes@google.com>

[1] https://lore.kernel.org/linux-iommu/20251202230303.1017519-1-skhawaja@google.com/

David Matlack (13):
  liveupdate: Export symbols needed by modules
  PCI: Add API to track PCI devices preserved across Live Update
  PCI: Inherit bus numbers from previous kernel during Live Update
  vfio/pci: Notify PCI subsystem about devices preserved across Live
    Update
  vfio: Enforce preserved devices are retrieved via
    LIVEUPDATE_SESSION_RETRIEVE_FD
  vfio/pci: Store incoming Live Update state in struct
    vfio_pci_core_device
  docs: liveupdate: Document VFIO device file preservation
  vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
  vfio: selftests: Add vfio_pci_liveupdate_uapi_test
  vfio: selftests: Expose iommu_modes to tests
  vfio: selftests: Expose low-level helper routines for setting up
    struct vfio_pci_device
  vfio: selftests: Verify that opening VFIO device fails during Live
    Update
  vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test

Vipin Sharma (9):
  vfio/pci: Register a file handler with Live Update Orchestrator
  vfio/pci: Preserve vfio-pci device files across Live Update
  vfio/pci: Retrieve preserved device files after Live Update
  vfio/pci: Skip reset of preserved device after Live Update
  selftests/liveupdate: Move luo_test_utils.* into a reusable library
  selftests/liveupdate: Add helpers to preserve/retrieve FDs
  vfio: selftests: Build liveupdate library in VFIO selftests
  vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
  vfio: selftests: Add vfio_pci_liveupdate_kexec_test

 Documentation/userspace-api/liveupdate.rst    | 144 ++++++++++
 MAINTAINERS                                   |   1 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 212 +++++++++++++++
 drivers/pci/probe.c                           |  23 +-
 drivers/vfio/device_cdev.c                    |  25 +-
 drivers/vfio/group.c                          |   9 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |  11 +-
 drivers/vfio/pci/vfio_pci_core.c              |  24 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 246 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  16 ++
 drivers/vfio/vfio.h                           |  13 -
 drivers/vfio/vfio_main.c                      |  23 +-
 include/linux/kho/abi/pci.h                   |  55 ++++
 include/linux/kho/abi/vfio_pci.h              |  45 +++
 include/linux/pci.h                           |  47 ++++
 include/linux/vfio.h                          |  58 ++++
 include/linux/vfio_pci_core.h                 |   2 +
 kernel/liveupdate/luo_core.c                  |   1 +
 kernel/liveupdate/luo_file.c                  |   2 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |  14 +-
 .../include/libliveupdate.h}                  |  11 +-
 .../selftests/liveupdate/lib/libliveupdate.mk |  20 ++
 .../{luo_test_utils.c => lib/liveupdate.c}    |  43 ++-
 .../selftests/liveupdate/luo_kexec_simple.c   |   2 +-
 .../selftests/liveupdate/luo_multi_session.c  |   2 +-
 tools/testing/selftests/vfio/Makefile         |  23 +-
 .../vfio/lib/include/libvfio/iommu.h          |   2 +
 .../lib/include/libvfio/vfio_pci_device.h     |   8 +
 tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  60 ++--
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 ++++++++++++++++++
 .../vfio/vfio_pci_liveupdate_uapi_test.c      |  93 +++++++
 35 files changed, 1410 insertions(+), 88 deletions(-)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/kho/abi/vfio_pci.h
 rename tools/testing/selftests/liveupdate/{luo_test_utils.h => lib/include/libliveupdate.h} (80%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 rename tools/testing/selftests/liveupdate/{luo_test_utils.c => lib/liveupdate.c} (89%)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c


base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
-- 
2.53.0.rc1.225.gd81095ad13-goog


