Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1095DC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 23:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99AD6B00A1; Thu, 16 Jul 2026 19:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B720E6B00A2; Thu, 16 Jul 2026 19:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61346B00A3; Thu, 16 Jul 2026 19:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7365E6B00A1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:24:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8BE7C0380
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:24:53 +0000 (UTC)
X-FDA: 84996222066.25.229AC7B
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf13.hostedemail.com (Postfix) with ESMTP id B702F20007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:24:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iG/Zzsop";
	spf=pass (imf13.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784244292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JG1UU/uJ7FK/8WjJHN4kAEWcanKcZQ/cD5/GJyTgbA=;
	b=z03OjH/ouEclKO980aIWPpQmpJWV+J4uWjkkmLkhP3zwFl0v7rabrJr4XNQhlZn1DOoA8L
	tuziOtxuxHAkKl8a5i5CDb1IavEZJxEr2bGtxw2lwhdOK1AZgFaYTMAx/odEyq8C3OO8dX
	1935EGi6SpfFKUHQZJGhLBm8mRCregM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iG/Zzsop";
	spf=pass (imf13.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784244292;
	b=UpJnyQSaRkTNum9JZnZ7I2MsOdat+OJrdQDRawyZQV2DyqI1Pezk8xPmCNXBDP2a+F/oxX
	SozenPruWOFvrjFr+QQpDfP/UzXGr/QqXJlptOZWGv1yHNgesjQSr53cMQLKDUfZ0jTrjf
	tXFxP9whGAIBhiv9+VQkBv0SDJHDbvA=
Content-Type: multipart/alternative;
 boundary="------------s1cz6qfNZ767lUpLzmFkFTgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784244289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JG1UU/uJ7FK/8WjJHN4kAEWcanKcZQ/cD5/GJyTgbA=;
	b=iG/ZzsopyrbiICJChs6M1OQ7oU0Iy6jF+aGaI8+ejDtN7431tX61f681Q17TKzPVPlVX+n
	/Iyg5HVM1rl/CVyiEGlc5g290dXPf177Zs8trrI+19gVZKERoi6vdN3w7xWFkYrOnWUShU
	u76bL+EoFZfrBFDYFOQR2+c7YbunU60=
Message-ID: <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
Date: Thu, 16 Jul 2026 16:24:31 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
To: Vipin Sharma <vipinsh@google.com>, kexec@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
 ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
 chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
 dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com,
 jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
 kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com,
 lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com,
 parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com,
 pratyush@kernel.org, rananta@google.com, rientjes@google.com,
 rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
 schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com,
 vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com
References: <20260714151505.3466855-1-vipinsh@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B702F20007
X-Stat-Signature: wzg576xeq5ebwgd5pzpsf1ntc5kxrkug
X-HE-Tag: 1784244291-241575
X-HE-Meta: U2FsdGVkX1+Z26UONUJoxFDevw/zx/zDMQA7yIa1zhV9pe1lMBrO/DUh2EMKSSg/hdJvmf3zZUMK8TXM4zw2chBoN86IaouUK9zLrx6VHy4oVcjhL9YcmRrh9gl+yQL9s00qYnzVAcuLjfA77p2puxcG19yQdRedtRl/wrst4DQjnvrtGLNzx5aAS7I03qjuQbeyA8chxcfinNUe4RBZEGctWSm4ArvQKhAyJHquBKg/74R+AuO3QR84t1Pj/9PgeSHWBEJ+55qF7e6eb1y9I7pNmp1eZi/PsOXBRoSMIFKx/H2AxBQd2cSnxwXjzMok4ztFi3No5DR0uFzA+hr/tu6xQhxkXmbcBz2FzllmFKmj3YkkGndeVbnSSxWsXbVkO/gyZGtBDzWAFQlVHVbTqh1BlcR+uviBDZQCB4nzl7qzime6U3CHgGhIa4CVg8AD0gwwIINYjMNI1WqLChDwFW81epwP5MqNp1yuauMxP6kBKOAmu1bqZh0VlcnWLi0BGQ3Zz/9WEFo+SEQ5rSsXlvkkqBfeVv8Yn2SrT/lPmeMzF5ZYAxpXnymq9WUo27wrCRqgBj7xxmS5r6Gf7tFUV9d/JHQZ6LO8ZEJTjQo1U4qnvoTAtYIb1uT/LLq2May9ZlI3gPFAGEQVMLwqaKx7zGYeDTw+LNJhqmZ3quGCy2dk/voJh70BQ5V03kix9wrcWSkt/TQ85TCO3nutkeX/Xxh8tVUM2c6nuTTh/+xY8CLK1fSHEndeRJRSM09MW/v4SRzVue3+XLWdABs7dnXkU/18WU5JofcGSS/cUChxDUawl5jPEEmewEUVQMfOWx6qg4A3wcvXeeOO0WvCAIf1H2Zh8LNWE+D///s9zdasULnnWwVQzNZ9FxAToWbMEMWYhUJoJYUJp3lXO16PiRZ7srqmEzdl1vYBbuqs3bTn66Je2g+eeQVSFCU7iyIZlJlpLfo+dgPu+pgEDeDSyxd
 0MYq7p+b
 +7mRA26ZNpyEDkGNjvn67GKkxwGuGOpYHSF+VZtMGZ/Di7ckOfuXbFL7xrF7qCWymixWcN56xxIxcDnbMh5hhh9vDFKjcaq91A4nJDm4Qlonb96oo01M5p+xXWd7fNXsfDOsXmtgRmJ282bCQQNwiyoxvAvLG2i11A/rd4zn3O2TUH96tjfQYg++WIxobT7mduWODmTLf/Ft5dI0PdCu1skRdHvM663v8udGLD1ZNfoDNCyqLlA4Jg6zLzuoy7eyFseSMGazEQ/BVOAre2u6THZZK+UtnxtDzBusQVryuEbtKIlKLCtt3Yy40H4Xy5qiBaMZ2NLJgpaNlsweR2H6YMtRHq35CQfadezqwozFwcEsIuPK7YqZW3baQgRGl0FdC4fyfXfv6YJ9UYZRdCfKKUMxDM4oDNUtgo2fvlc2ucpaHPWodnnYLve/0f9iquWDmcSGukguF9AO2Tgl50J3dv8SQBIClNrfyRijHRyLYpetAoX2r1JtJeRbx4gV8fZJihlFc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------s1cz6qfNZ767lUpLzmFkFTgt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/14/26 8:14 AM, Vipin Sharma wrote:
> Hello,
>
> This series can be found on Github:
>
>    https://github.com/shvipin/linux vfio/liveupdate/v5
>
> This series provides the base support to enable Live Update feature for
> VFIO PCI devices using the Live Update Orchestrator (LUO) and Kexec
> Handover (KHO).
>
> Overview
> --------
>
> This series makes the following changes to support VFIO Live Update:
>
>   - Puts VFIO Live Update support behind the CONFIG_VFIO_PCI_LIVEUPDATE
>     config option (which requires CONFIG_VFIO_DEVICE_CDEV).
>   - Preserves VFIO cdev device FDs across a kexec Live Update session via
>     LUO/KHO.
>   - Enforces that incoming preserved devices can only be retrieved via
>     LIVEUPDATE_SESSION_RETRIEVE_FD post-kexec (preventing legacy
>     group/cdev opens from accessing uninitialized state).
>   - Quiesces the device prior to kexec in freeze() by resetting hardware,
>     disabling bus mastering, and marking the device frozen to reject
>     post-freeze IO/MMIO.
>   - Includes VFIO selftests (uapi & kexec tests with continuous DMA
>     checks) and kernel documentation.
>
> VFIO PCI Live Update Roadmap
> ----------------------------
>
> We are planning to add VFIO PCI Live Update support in phases. Since full
> support of this feature will come in phase, VFIO PCI Liveupdate is
> controlled by CONFIG_VFIO_PCI_LIVEUPDATE config option.
>
> This series is phase 1 below:
>
>   1. PCIe function (non-VF) preserved across Live Update without changing
>      BDF
>   2. PCIe function (non-VF) preserved across Live Update without resetting
>   3. PCIe function (non-VF) preserved across Live Update with continuous
>      DMA (noiommu)
>   4. PCIe function (non-VF) preserved across Live Update with continuous
>      DMA (iommufd)
>   5. PCIe VF preserved across Live Update with continuous DMA (iommufd)
>
> Dependencies
> ------------
>
> This series has following dependencies as shown in the diagram
>
>      |---------------------------|
>      |         VFIO v5           |  <--- Sent in this series.
>      |---------------------------|
>      |  Liveupdate Selftests[1]  |
>      |---------------------------|
>      |        PCI v7 [2]         |
>      |---------------------------|
>
> [1]https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/
>      These selftests changes are needed by other selftests also (iommu,
>      kvm), so, I have sent them separately.
>
> [2]https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
>      This is the PCI v7, which adds the live update support in PCI core.
>
> Github branch I have mentioned at the top has all of these dependencies.
>
> Testing
> -------
>
> Tested using VFIO Live Update selftests in both QEMU and bare-metal
> environment (Intel DSA PCIe device).

I want to make tests VFIO Live Update selftests in QEMU. But how to 
select a PCIe device?

what device do the PCI ID 0000:00:04.0 and 0000:6a:01.0 mean in the 
following testcase?

Zhu Yanjun

>
>    $ ./setup.sh 0000:00:04.0
>    $ ./vfio_pci_liveupdate_kexec_test --stage 1 0000:6a:01.0
>    $ kexec --reuse-cmdline -l -s /boot/vmlinuz
>    $ kexec -e
>    $ ./setup.sh 0000:00:04.0
>    $ ./vfio_pci_liveupdate_kexec_test --stage 2 0000:6a:01.0
>
> Kernel command line options used:
>    - liveupdate=on
>    - kho=on
>    - vfio_iommu_type1.allow_unsafe_interrupts=Y
>    - vfio_pci.enable_sriov=Y
>    - vfio_pci.disable_denylist=Y
>    - vfio.enable_unsafe_noiommu_mode=Y
>
>
> Changelog
> ---------
>
> v5:
>   - Addressed Sashiko feedback.
>   - Removed condition to disable CONFIG_VFIO_PCI_DMABUF.
>   - Expanded vfio_find_device() helper to safely discover a registered
>     vfio_device by matching criteria. Internal Sashiko instance found
>     data race.
>   - Updated selftests to latest changes in VFIO selftests.
>   - Rebased on top of PCI Live Update series v7.
>
> v4:https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/
>
> v3:https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
>
> v2:https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
>
> v1:https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
>
> rfc:https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/
>
>
> David Matlack (7):
>    vfio: Enforce preserved devices are retrieved via
>      LIVEUPDATE_SESSION_RETRIEVE_FD
>    docs: liveupdate: Add documentation for VFIO PCI
>    vfio: selftests: Add vfio_pci_liveupdate_uapi_test
>    vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
>    vfio: selftests: Expose iommu_modes to tests
>    vfio: selftests: Verify that opening VFIO device fails during Live
>      Update
>    vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
>
> Vipin Sharma (13):
>    vfio/pci: Factor out the reset logic in VFIO PCI device close path
>    vfio: Export various helpers from VFIO
>    vfio/pci: Export vfio_pci_dma_buf_move for vfio-pci module
>    liveupdate: Export symbols needed by modules
>    vfio/pci: Register a file handler with Live Update Orchestrator
>    vfio/pci: Preserve vfio-pci device files across Live Update
>    vfio: Introduce vfio_find_device() helper
>    vfio: Refactor vfio_device_fops_cdev_open()
>    vfio: Add API to open cdev device for Live Update restore
>    vfio/pci: Retrieve preserved device files after Live Update
>    vfio: selftests: Build liveupdate library in VFIO selftests
>    vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
>    vfio: selftests: Add vfio_pci_liveupdate_kexec_test
>
>   Documentation/core-api/liveupdate.rst         |   1 +
>   .../driver-api/vfio_pci_liveupdate.rst        |  23 ++
>   MAINTAINERS                                   |   2 +
>   drivers/vfio/device_cdev.c                    |  67 +++-
>   drivers/vfio/group.c                          |   9 +
>   drivers/vfio/pci/Kconfig                      |  12 +
>   drivers/vfio/pci/Makefile                     |   1 +
>   drivers/vfio/pci/vfio_pci.c                   |  13 +-
>   drivers/vfio/pci/vfio_pci_config.c            |   3 +
>   drivers/vfio/pci/vfio_pci_core.c              | 119 +++---
>   drivers/vfio/pci/vfio_pci_dmabuf.c            |   1 +
>   drivers/vfio/pci/vfio_pci_liveupdate.c        | 340 ++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_priv.h              |  28 ++
>   drivers/vfio/vfio.h                           |  18 +
>   drivers/vfio/vfio_main.c                      |  67 +++-
>   include/linux/kho/abi/vfio_pci.h              |  43 +++
>   include/linux/vfio.h                          |  12 +
>   include/linux/vfio_pci_core.h                 |   3 +
>   kernel/liveupdate/luo_file.c                  |   2 +
>   tools/testing/selftests/vfio/Makefile         |  23 +-
>   .../vfio/lib/include/libvfio/iommu.h          |   2 +
>   .../lib/include/libvfio/vfio_pci_device.h     |   3 +
>   tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
>   .../selftests/vfio/lib/vfio_pci_device.c      |  25 +-
>   .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 +++++++++++++
>   .../vfio/vfio_pci_liveupdate_uapi_test.c      |  97 +++++
>   26 files changed, 1097 insertions(+), 77 deletions(-)
>   create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst
>   create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
>   create mode 100644 include/linux/kho/abi/vfio_pci.h
>   create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
>   create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
>
>
> base-commit: cbf37fff757e87376e80e11a8378393a8f25145f
> prerequisite-patch-id: 85705fb54d3065efe1d87ab4b69e828a9f3404e7
> prerequisite-patch-id: a33ae79b5fc0259bd013b430c18cc3d14a678599
--------------s1cz6qfNZ767lUpLzmFkFTgt
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 7/14/26 8:14 AM, Vipin Sharma wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260714151505.3466855-1-vipinsh@google.com">
      <pre wrap="" class="moz-quote-pre">Hello,

This series can be found on Github:

  <a class="moz-txt-link-freetext" href="https://github.com/shvipin/linux">https://github.com/shvipin/linux</a> vfio/liveupdate/v5

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
 - Includes VFIO selftests (uapi &amp; kexec tests with continuous DMA
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
    |         VFIO v5           |  &lt;--- Sent in this series.
    |---------------------------|
    |  Liveupdate Selftests[1]  |
    |---------------------------|
    |        PCI v7 [2]         |
    |---------------------------|

[1] <a class="moz-txt-link-freetext" href="https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/">https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/</a>
    These selftests changes are needed by other selftests also (iommu,
    kvm), so, I have sent them separately.

[2] <a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/">https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/</a>
    This is the PCI v7, which adds the live update support in PCI core.

Github branch I have mentioned at the top has all of these dependencies.

Testing
-------

Tested using VFIO Live Update selftests in both QEMU and bare-metal
environment (Intel DSA PCIe device).</pre>
    </blockquote>
    <p>I want to make tests VFIO Live Update selftests in QEMU. But how
      to select a PCIe device?</p>
    <p>what device do the PCI ID <span style="white-space: pre-wrap">0000:00:04.0 and  0000:6a:01.0 mean in t</span>he
      following testcase?</p>
    <p>Zhu Yanjun</p>
    <blockquote type="cite"
      cite="mid:20260714151505.3466855-1-vipinsh@google.com">
      <pre wrap="" class="moz-quote-pre">

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

v4: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/">https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/</a>

v3: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/">https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/</a>

v2: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/">https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/</a>

v1: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/">https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/</a>

rfc: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/">https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/</a>


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
</pre>
    </blockquote>
  </body>
</html>

--------------s1cz6qfNZ767lUpLzmFkFTgt--

