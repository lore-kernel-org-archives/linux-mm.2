Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5000C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 01:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE5B6B00A4; Thu, 16 Jul 2026 21:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EDA6B00A5; Thu, 16 Jul 2026 21:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439EC6B00A6; Thu, 16 Jul 2026 21:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06E146B00A4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:22:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85BF8403C4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:22:25 +0000 (UTC)
X-FDA: 84996518250.05.FA9D97C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEF1F40007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:22:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hpo4JIsm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784251343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ormtaaAQI1kJriJV8w0UaOPBG1awEzacrP6JzlC/B8=;
	b=PckTjNrIcdyXdJwDg0wek1alU/YIxcwAZw9JafA7KVERxrwWB2dAF8IUFKuiiK9ksjeT5k
	hMIEHWQXhjzIsQ2mf8iJWyjuAsq/Kgb+q5B0f9TYJFN8bKz5o0GLGDLcFycE5ztWuB/+RD
	8ztm2E4To2/7v8eyYBdMAdnbH9xJAbA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hpo4JIsm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784251343;
	b=29ASFAnnfgjYYJHcuSx9RdR8HgEK195Z378vJC7yMTQvXwEN9UexVnjp9Gf7ZteBclI4vJ
	t3we/6T6KUvWej5NsGk5Q2Ad9HHFeTyAlxC//sTKxEvbZ0mX7vV/mnbEKTZB3pxOR5O7P/
	3Yd5YjEalR/nHyb/kD8aNDwGhM3CGCE=
Content-Type: multipart/alternative;
 boundary="------------0VBydqEaTIEQUYVbr1iOzcZC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784251339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5ormtaaAQI1kJriJV8w0UaOPBG1awEzacrP6JzlC/B8=;
	b=hpo4JIsm2oDbymV7d/m/pK4ojbssWmdllPjGWIs4WmkBHJHQaBUV4nwZcJX5jPLoHbNvpq
	rpbrs6ncCDsDYet2D/ZLdY7aHEEg69bwI3kvIAy4M8y62lsn6/T3Tg9Ci4SV1NQhgwUN+4
	Knld2HRpcDuSBNOSzYcCeexbYdRew0w=
Message-ID: <8fd94fad-e457-4839-9e41-ae257a138bee@linux.dev>
Date: Thu, 16 Jul 2026 18:22:07 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
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
 <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
Content-Language: en-US
In-Reply-To: <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EEF1F40007
X-Stat-Signature: 338um8aatdkgja47j1zmugncm1hzxt4h
X-Rspam-User: 
X-HE-Tag: 1784251341-602167
X-HE-Meta: U2FsdGVkX18fBYInPXxIyGuwnD8nChj1u7iB+WdAPLckzD0wFIaXZJ/FDxkZ2h8cyFKnJ867mhxTEXek/5rygcAVXXXluE82gQPQ/RWsERSV/uJTU3DfdutL7qQccB+JBPa3AoruFGQ93aaDPKJEI+lqQtXtvA4dxMkf1Wb1aZfUulye8QcTyMl4mcz0x044ct3LVb5rd3cLVe50/uBCdZprvVePWtgzhDZdgKeXY+uFxD/0Q+7XfdaVO4MYGFo/nfrdowmyQ2xj7N1+gOVMSZjt4WztkTjhf2Qq8/K53NJgXtcMft/CpGIj8Tzoy4ZtfB8bruWG2h782kbxyONqJOSDB7VGx2aZGxHnM2e42kFspa7F9dfavQT7XtfPws3U1cB2bPrvR3IbQqttBCPaN1F9xbfsAqhA7F7X1RQba4lkcv69P1IfJd804GSVKSHPkvsZT4UlaVSHtGZrql6YrKnYWoxK3EWn/VDH2WSbiG8fuwuBoYyztsVJ3Tn3vSsTnTgipzv1OhOvj+aqCdvSkiB4+1yzhApDy1EI/sR8+gYgrC1drKeW2+RvVLdQ2a40zAHUcPaOtklLol0Phmknp6fh+nxh+gAvdfi9kCWRbGQjcU1Ms4H2EzwLCPV12k4J2C1GciPak9oTrKqhkwJwgOeAB0eZQSSPL1LZco69LcJfmYT0RJVJHCbUwOFic3QeQFQSiNxfYI6TBKDr8aFNevHsTikDDFtD48Ao5U2z+FCSWlMrzRe1o806ZuM1EEJFeFmF0Lg+hjkkAJuMMtS0LqJe7XTGNq6Z+G3CJO+pPzmu109R3rgTOShfFmwxkHAaPW0bT3doyxdJIaaHAyqpZRVNuQPLk9uoqhjsxmebCGPaA/SMTkptIZh8CkxSi0kVAHfdTlB0GBsz8qcL5dnCkGKzgOghZ2YZ+As29pbz/LKW50hSwvRNm1sAFqy/hTO9oC714WKJe1lGfDFyFaj
 OrHMVVFD
 +5k5mFqF+k7b0P92/io0mB2fPPwWXdwCw3Ru2Jd+PWRjfHbsd8HQ1NGAruMBa23rdO+k0DWcsxr/rVrXr+7yiwZHFsH4BgTHQtC6F+w1YHzgA+QfL/jv4t8IcalSKLcV/Vh9coitnyoCP2emlwIiyiV7gamSRp7V8KAIsejiR3ItYa3P9X1KNO8WF0bUMEbVPBOCQxRt/VraoNJj/+byHz5zPfTYR8p0RvGEOKhB8XDr96tT+ezuGcSUyg8JdN9a82c049fIKVarRlhVrWRrVsaaQIdkgR7HFJUGrnWERuYFyUvKZm8sOPm3R2DXmWb+XJ7hHrx0yBAcUBFMifU9TlWp+xQfFOzak97ps61xOtDzYqVwiRPyNuZD/a3ZEq4YLOigqIw7DA7mQ5fAuTIL6dOW3ezrruVkz1yVkX8b4ilKV3j0IIi3k20Y1zuQJeyIxsu3CcVrkkuliGGRPAPRbBYR0M8vOEmyvrMOh6IyQazHfpYErQ6OPyoUpa/Ea83yR9Y1G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------0VBydqEaTIEQUYVbr1iOzcZC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/16/26 4:24 PM, Yanjun.Zhu wrote:
>
>
> On 7/14/26 8:14 AM, Vipin Sharma wrote:
>> Hello,
>>
>> This series can be found on Github:
>>
>>    https://github.com/shvipin/linux vfio/liveupdate/v5
>>
>> This series provides the base support to enable Live Update feature for
>> VFIO PCI devices using the Live Update Orchestrator (LUO) and Kexec
>> Handover (KHO).
>>
>> Overview
>> --------
>>
>> This series makes the following changes to support VFIO Live Update:
>>
>>   - Puts VFIO Live Update support behind the CONFIG_VFIO_PCI_LIVEUPDATE
>>     config option (which requires CONFIG_VFIO_DEVICE_CDEV).
>>   - Preserves VFIO cdev device FDs across a kexec Live Update session via
>>     LUO/KHO.
>>   - Enforces that incoming preserved devices can only be retrieved via
>>     LIVEUPDATE_SESSION_RETRIEVE_FD post-kexec (preventing legacy
>>     group/cdev opens from accessing uninitialized state).
>>   - Quiesces the device prior to kexec in freeze() by resetting hardware,
>>     disabling bus mastering, and marking the device frozen to reject
>>     post-freeze IO/MMIO.
>>   - Includes VFIO selftests (uapi & kexec tests with continuous DMA
>>     checks) and kernel documentation.
>>
>> VFIO PCI Live Update Roadmap
>> ----------------------------
>>
>> We are planning to add VFIO PCI Live Update support in phases. Since full
>> support of this feature will come in phase, VFIO PCI Liveupdate is
>> controlled by CONFIG_VFIO_PCI_LIVEUPDATE config option.
>>
>> This series is phase 1 below:
>>
>>   1. PCIe function (non-VF) preserved across Live Update without changing
>>      BDF
>>   2. PCIe function (non-VF) preserved across Live Update without resetting
>>   3. PCIe function (non-VF) preserved across Live Update with continuous
>>      DMA (noiommu)
>>   4. PCIe function (non-VF) preserved across Live Update with continuous
>>      DMA (iommufd)
>>   5. PCIe VF preserved across Live Update with continuous DMA (iommufd)
>>
>> Dependencies
>> ------------
>>
>> This series has following dependencies as shown in the diagram
>>
>>      |---------------------------|
>>      |         VFIO v5           |  <--- Sent in this series.
>>      |---------------------------|
>>      |  Liveupdate Selftests[1]  |
>>      |---------------------------|
>>      |        PCI v7 [2]         |
>>      |---------------------------|
>>
>> [1]https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/
>>      These selftests changes are needed by other selftests also (iommu,
>>      kvm), so, I have sent them separately.
>>
>> [2]https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
>>      This is the PCI v7, which adds the live update support in PCI core.
>>
>> Github branch I have mentioned at the top has all of these dependencies.
>>
>> Testing
>> -------
>>
>> Tested using VFIO Live Update selftests in both QEMU and bare-metal
>> environment (Intel DSA PCIe device).
>
> I want to make tests VFIO Live Update selftests in QEMU. But how to 
> select a PCIe device?
>
> what device do the PCI ID 0000:00:04.0 and 0000:6a:01.0 mean in the 
> following testcase?
>
In my qemu,

00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest 
Service
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin A routed to IRQ 20
     Region 0: I/O ports at d040 [size=32]
     Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=4M]
     Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]
     Kernel driver in use: vboxguest
     Kernel modules: vboxguest

I am wondering if the above pci device can work well with this patch set 
or not.

Zhu Yanjun

> Zhu Yanjun
>
>>    $ ./setup.sh 0000:00:04.0
>>    $ ./vfio_pci_liveupdate_kexec_test --stage 1 0000:6a:01.0
>>    $ kexec --reuse-cmdline -l -s /boot/vmlinuz
>>    $ kexec -e
>>    $ ./setup.sh 0000:00:04.0
>>    $ ./vfio_pci_liveupdate_kexec_test --stage 2 0000:6a:01.0
>>
>> Kernel command line options used:
>>    - liveupdate=on
>>    - kho=on
>>    - vfio_iommu_type1.allow_unsafe_interrupts=Y
>>    - vfio_pci.enable_sriov=Y
>>    - vfio_pci.disable_denylist=Y
>>    - vfio.enable_unsafe_noiommu_mode=Y
>>
>>
>> Changelog
>> ---------
>>
>> v5:
>>   - Addressed Sashiko feedback.
>>   - Removed condition to disable CONFIG_VFIO_PCI_DMABUF.
>>   - Expanded vfio_find_device() helper to safely discover a registered
>>     vfio_device by matching criteria. Internal Sashiko instance found
>>     data race.
>>   - Updated selftests to latest changes in VFIO selftests.
>>   - Rebased on top of PCI Live Update series v7.
>>
>> v4:https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/
>>
>> v3:https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
>>
>> v2:https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
>>
>> v1:https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
>>
>> rfc:https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/
>>
>>
>> David Matlack (7):
>>    vfio: Enforce preserved devices are retrieved via
>>      LIVEUPDATE_SESSION_RETRIEVE_FD
>>    docs: liveupdate: Add documentation for VFIO PCI
>>    vfio: selftests: Add vfio_pci_liveupdate_uapi_test
>>    vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
>>    vfio: selftests: Expose iommu_modes to tests
>>    vfio: selftests: Verify that opening VFIO device fails during Live
>>      Update
>>    vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
>>
>> Vipin Sharma (13):
>>    vfio/pci: Factor out the reset logic in VFIO PCI device close path
>>    vfio: Export various helpers from VFIO
>>    vfio/pci: Export vfio_pci_dma_buf_move for vfio-pci module
>>    liveupdate: Export symbols needed by modules
>>    vfio/pci: Register a file handler with Live Update Orchestrator
>>    vfio/pci: Preserve vfio-pci device files across Live Update
>>    vfio: Introduce vfio_find_device() helper
>>    vfio: Refactor vfio_device_fops_cdev_open()
>>    vfio: Add API to open cdev device for Live Update restore
>>    vfio/pci: Retrieve preserved device files after Live Update
>>    vfio: selftests: Build liveupdate library in VFIO selftests
>>    vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
>>    vfio: selftests: Add vfio_pci_liveupdate_kexec_test
>>
>>   Documentation/core-api/liveupdate.rst         |   1 +
>>   .../driver-api/vfio_pci_liveupdate.rst        |  23 ++
>>   MAINTAINERS                                   |   2 +
>>   drivers/vfio/device_cdev.c                    |  67 +++-
>>   drivers/vfio/group.c                          |   9 +
>>   drivers/vfio/pci/Kconfig                      |  12 +
>>   drivers/vfio/pci/Makefile                     |   1 +
>>   drivers/vfio/pci/vfio_pci.c                   |  13 +-
>>   drivers/vfio/pci/vfio_pci_config.c            |   3 +
>>   drivers/vfio/pci/vfio_pci_core.c              | 119 +++---
>>   drivers/vfio/pci/vfio_pci_dmabuf.c            |   1 +
>>   drivers/vfio/pci/vfio_pci_liveupdate.c        | 340 ++++++++++++++++++
>>   drivers/vfio/pci/vfio_pci_priv.h              |  28 ++
>>   drivers/vfio/vfio.h                           |  18 +
>>   drivers/vfio/vfio_main.c                      |  67 +++-
>>   include/linux/kho/abi/vfio_pci.h              |  43 +++
>>   include/linux/vfio.h                          |  12 +
>>   include/linux/vfio_pci_core.h                 |   3 +
>>   kernel/liveupdate/luo_file.c                  |   2 +
>>   tools/testing/selftests/vfio/Makefile         |  23 +-
>>   .../vfio/lib/include/libvfio/iommu.h          |   2 +
>>   .../lib/include/libvfio/vfio_pci_device.h     |   3 +
>>   tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
>>   .../selftests/vfio/lib/vfio_pci_device.c      |  25 +-
>>   .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 +++++++++++++
>>   .../vfio/vfio_pci_liveupdate_uapi_test.c      |  97 +++++
>>   26 files changed, 1097 insertions(+), 77 deletions(-)
>>   create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst
>>   create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
>>   create mode 100644 include/linux/kho/abi/vfio_pci.h
>>   create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
>>   create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
>>
>>
>> base-commit: cbf37fff757e87376e80e11a8378393a8f25145f
>> prerequisite-patch-id: 85705fb54d3065efe1d87ab4b69e828a9f3404e7
>> prerequisite-patch-id: a33ae79b5fc0259bd013b430c18cc3d14a678599
--------------0VBydqEaTIEQUYVbr1iOzcZC
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
    <div class="moz-cite-prefix">On 7/16/26 4:24 PM, Yanjun.Zhu wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <p><br>
      </p>
      <div class="moz-cite-prefix">On 7/14/26 8:14 AM, Vipin Sharma
        wrote:<br>
      </div>
      <blockquote type="cite"
        cite="mid:20260714151505.3466855-1-vipinsh@google.com">
        <pre wrap="" class="moz-quote-pre">Hello,

This series can be found on Github:

  <a class="moz-txt-link-freetext"
        href="https://github.com/shvipin/linux" moz-do-not-send="true">https://github.com/shvipin/linux</a> vfio/liveupdate/v5

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

[1] <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/</a>
    These selftests changes are needed by other selftests also (iommu,
    kvm), so, I have sent them separately.

[2] <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/</a>
    This is the PCI v7, which adds the live update support in PCI core.

Github branch I have mentioned at the top has all of these dependencies.

Testing
-------

Tested using VFIO Live Update selftests in both QEMU and bare-metal
environment (Intel DSA PCIe device).</pre>
      </blockquote>
      <p>I want to make tests VFIO Live Update selftests in QEMU. But
        how to select a PCIe device?</p>
      <p>what device do the PCI ID <span style="white-space: pre-wrap">0000:00:04.0 and  0000:6a:01.0 mean in t</span>he
        following testcase?</p>
    </blockquote>
    <p>In my qemu, </p>
    <p>00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox
      Guest Service<br>
          Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
      ParErr- Stepping- SERR- FastB2B- DisINTx-<br>
          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
      &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR- INTx-<br>
          Interrupt: pin A routed to IRQ 20<br>
          Region 0: I/O ports at d040 [size=32]<br>
          Region 1: Memory at f0400000 (32-bit, non-prefetchable)
      [size=4M]<br>
          Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]<br>
          Kernel driver in use: vboxguest<br>
          Kernel modules: vboxguest<br>
      <br>
    </p>
    <p>I am wondering if the above pci device can work well with this
      patch set or not.</p>
    <p>Zhu Yanjun</p>
    <blockquote type="cite"
      cite="mid:2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev">
      <p>Zhu Yanjun</p>
      <blockquote type="cite"
        cite="mid:20260714151505.3466855-1-vipinsh@google.com">
        <pre wrap="" class="moz-quote-pre">  $ ./setup.sh 0000:00:04.0
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

v4: <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/</a>

v3: <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/</a>

v2: <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/</a>

v1: <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/</a>

rfc: <a class="moz-txt-link-freetext"
href="https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/"
        moz-do-not-send="true">https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/</a>


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
    </blockquote>
  </body>
</html>

--------------0VBydqEaTIEQUYVbr1iOzcZC--

