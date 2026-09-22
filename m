Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFEDC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 21:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E736B0088; Tue, 22 Sep 2026 17:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F876B008A; Tue, 22 Sep 2026 17:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D766B008C; Tue, 22 Sep 2026 17:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85FE56B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:47:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B4D11C31BC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:47:43 +0000 (UTC)
X-FDA: 85242735606.04.A8DE503
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD7761C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:47:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mvujhRK3;
	spf=pass (imf20.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790113661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZseRs3VM5qy6NfSEI25R9aNsCqbQNgrWnR+mKGskJD4=;
	b=fHmQ5qItGuu7Vh0kjIrVuMAWu8QcL7EKnHR9UJ9tVPAWU8s5oBrn2iDQnD++Mu99zXy+sd
	cSKJM4tUvGhdh/jbgc9cqzo2jXF+hqOJGz43zSNW08w8D8fBvRZ09Pgk+2VIV7mlDcihUG
	a8fkfKCNpjpjG7cuRr1m14hwRZsDNwg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mvujhRK3;
	spf=pass (imf20.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790113661;
	b=klOb4aehvi4rKHRPki9wwQlG5xl2TetFBfZe9YzTUChoi8i0UO/FYV0A1hmCGQBX5jOUKt
	ceM3rpcGFHVkSjh9KHexs12eV6xip8E+nhbWmBru1OwdqrtAX59peyL9pTbJjsURmJ8OYf
	ADxkhh0PbO2cXmYX/0c08KkO1yH/Oy4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j978S3kujL0t2IzwtfW4gW4OFjeQsDQ4dfVPJMp9cw0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790113658; v=1; x=1790718458;
 b=mvujhRK3HPNWh5jZ1O6mWbwgc5ofxed21gj77WTukikBzLL5PMkjFm9ZNtoKhhu+ze6BQWY9
 S62VL/gheKaPl6qzTKvUmIpaGRvnG4+/Yk5aA9180TL2mN1+7ZAiTJkXbJDW9pMpJjimd9oazka
 4AbRgZbCIhZWTlIX8GqCS3dA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dcd07712fee43c99;
	Tue, 22 Sep 2026 21:47:38 +0000
X-Mizu-Trace-ID: dcd07712fee43c99
X-Migadu-Flow: FLOW_OUT
Message-ID: <4e893390-ac53-4c50-b2b4-50d415ff3d1f@linux.dev>
Date: Tue, 22 Sep 2026 14:47:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260918200640.887030-1-dmatlack@google.com>
 <079e343d-c6a6-4430-b900-25918197bfad@linux.dev>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <079e343d-c6a6-4430-b900-25918197bfad@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD7761C0004
X-Rspam-User: 
X-Stat-Signature: b78rbha1qzcgu1r3wwykpxzx6i7ygpy9
X-HE-Tag: 1790113660-963231
X-HE-Meta: U2FsdGVkX1/7SS0tbak/91gueko61+/lCfFDIkZto14lcYqmTyfCyOSk4M4Z93f1jNOStKG2TBT8bxqJpazwO6RfJhHjvB8e4D92zuC6H7vW2zP6ygopHxPbZrm/AgfkJ97uvwCJG77+9sTs5yBx64hWP1M3C2o26YDQnY1IjVyZu0tzh21CIYTbizcG0FydXV+eszow/WaAbaUkfsQVm7nT9ZsszQjzQ2aDE9l59cSl4lSW177B4XagHvpxo10aciAHNzqQAx3B33BAo+AXnuGRP5/9Lxq1qb9zZMlkcXcN5EUzOkumw7wwgA/CQeRu+I379z6YWKinzlQIlc8kdKmxSkbNCAA+yN7KJeSJcLLLMYvLVFESNIpeH3Y7vO6Np8KlcLERpFOTjEoHsLSgNv02QA+DqNJODenrl86EdplIS7T+QOprywk6E6yPSxajhjDPs1nX4kP3F6LiGvkcgqZskauAawS8TTH93JIBClZ3TkKbIVEDJFSG/3VcoW66MVvFKHBRNJuDITUibWfax2UsF+nnHdqFEG/nZmP6YkudV4yluIwW45UwKbY8j27/Ingl844hb+CMplevoCW06k5BL1n5nKSH0x7T09hwS4BR4bwGOOoeTEx2+kwUGgkTKxerKSQUyvbpla3qH+aejVn1aMNFqxGWFV7lixkI5adKXvtMc3OxoO8fczq7D5mbFQA2PnbDupNc9bN3bAE/J+eGvABH3Zqgh/qW3M7xT7muqfj+PyPdxSa6AxOvVLVIpD8QQF53JD7hCQS56lhmf9f7+JY8CJPeBkHNJqnFk+78CzQbrCUWXmu997aIy0gNTaV1m/b6Qf3mDn02x/nJ2yX/8QWQudzE+lZdWYi9aFhYuo1iKYfoR7qZTfXJi+DEXMEVSMX0suN5ihLfR8VMKUmSx5A6955nybYa3aO47OUV/65kvLASH+z0BDp9N3mQV0blktB5c9SSGbivrOr
 +IzcOaP7
 uwsJmA7/33ipjcZ2sAJXS/F17qJSsc2Phkh0pW9lPGmg4cvxeMMI+YUbbNBsvfuYKW83UQB4aTl2KKfY2AmvU9NhkTwh9PRuM00EATyTMwEUgmEwYfCN7vXnaVZeYpWoTzHb2EoxVJDighedz4SyyWjB62K2n5Row7TtuxZj1URwx9qWTlJAHaVXUT11opZpa2fvaRBE7ft36wAvH6EAyriPSikApH6laSOTW59fV/G5/iBx6AqffQckEHqlbulBV0otTUPev16tRWUBtF96xCldk8mtAfFTvXcVn2dgMLtPulTMLa+pEmLXJIJZPLcwuBIAUd3hPxwCMGL5TPXhJYGrZ/8rSJqNg/m94s28iQKz2pXPE2qg8WqhBASITDyZ7GwrmzX56OcDLu+WRXMBHeaqGygCFaV9x9tv0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/22 11:54, Zhu Yanjun 写道:
> 在 2026/9/18 13:06, David Matlack 写道:
>> This series can be found on GitHub:
>>
>>    https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9
>>
>> This series introduces support in the PCI core for Live Update, enabling
>> drivers to preserve PCI devices across a kexec-based kernel update
>> without interrupting the device. This functionality is critical for
>> minimizing downtime in environments where PCI devices (e.g., those
>> assigned to VMs via VFIO) must continue operating or maintain state
>> across a host kernel upgrade.
>>
>> Specifically, this series allows preserved PCI devices to perform
>> uninterrupted memory transactions (DMA) targeting system memory
>> (specifically, preserved memfds) across a Live Update. These devices can
>> be behind a bridge but must not be VFs. Support for P2P and VF
>> preservation will be addressed in future series.
>>
>> Series Overview
>> ---------------
>>
>> This series implements the following to support PCI device preservation
>> across Live Update:
>>
>>    1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
>>       PCI-specific state (struct pci_ser) across Live Update using Kexec
>>       Handover (KHO).
>>
>>    2. Add APIs for drivers to register devices for preservation
>>       (outgoing) and for the PCI core to identify preserved devices
>>       during enumeration (incoming)
>>
>>    3. Automatically preserve all upstream bridges for any preserved
>>       endpoint. Use reference counting to ensure bridges remain 
>> preserved
>>       as long as any downstream device is preserved.
>>
>>    4. Guarantee that preserved devices retain the same RequesterID (bus,
>>       device, function) for the duration of their preservation by
>>       inheriting secondary bus numbers, subordinate bus numbers, and ARI
>>       Forwarding Enable on preserved bridges.
>>
>>    5. Guarantee that memory transactions to/from preserved devices are
>>       routed consistently by inheriting Access Control Services (ACS)
>>       flags across a Live Update, from the endpoint up to the root port.
>>
>>    6. Modify the PCI shutdown path to avoid disabling bus mastering on
>>       preserved devices, thereby allowing preserved devices to perform
>>       uninterrupted during kexec for Live Update.
>>
>>    7. Provide comprehensive documentation for the FLB API, device
>>       tracking mechanisms, and the division of responsibilities between
>>       the PCI core, drivers, and userspace.
>>
>> Merge Plan
>> ----------
>>
>> This series will be merged through liveupdate.git, matching the
>> agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.
>>
>> Testing
>> -------
>>
>> This series was tested in conjunction with v5 of the VFIO PCI driver
>> series:
>>
>> https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
>>
>> The full set of patches used for testing can be found on GitHub.
>>
>> https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v9-with-vfio
>>
>> Testing was performed using the new VFIO selftests:
>>
>>    - vfio_pci_liveupdate_uapi_test
>>    - vfio_pci_liveupdate_kexec_test
>
> With this vfio_pci_liveupdate_kexec_test based on this patchset v9, I 
> have made tests in my local kvm. It worked as expected.
>
> Yanjun Zhu

The test result with vfio_pci_liveupdate_kexec_test is as below.


1.
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/iommu/iommufd/iommufd.ko
insmod /lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/vfio.ko
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/vfio_iommu_type1.ko
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/pci/vfio-pci-core.ko
insmod /lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/pci/vfio-pci.ko
+ echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
+ echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
Preserving device in session
Preserving memfd of size 0x40100000 in session
# [STAGE 1] Forking persistent child to hold sessions...
# [STAGE 1] Child PID: 1214. Resources are pinned.
# [STAGE 1] You may now perform kexec reboot.

2. kexec reboot

3.
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/iommu/iommufd/iommufd.ko
insmod /lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/vfio.ko
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/vfio_iommu_type1.ko
insmod 
/lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/pci/vfio-pci-core.ko
insmod /lib/modules/7.3.0-rc1-dmabuf+/kernel/drivers/vfio/pci/vfio-pci.ko
+ echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
+ echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
Retrieving memfd from LUO
Finishing the session before retrieving the device (should fail)
Retrieving the device FD from LUO
Finishing the session before binding to iommufd (should fail)
Binding the device to an iommufd and setting it up
Finishing the session

Yanjun Zhu

>
>>
>> Both tests were run in a QEMU-based VM environment (using a single
>> virtio-net PCIe device connected to a root port to exercise bridge
>> support) and on bare metal using an Intel EMR server with 8x Intel DSA
>> PCIe devices and 1x NVMe device.
>>
>> Future Work
>> -----------
>>
>> Following this series, we expect to make further improvements to the PCI
>> core support for Live Update:
>>
>>    - Allow P2P across Live Update by avoiding resizing or moving
>>      preserved device BARs and preserving all upstream bridge windows.
>>
>>    - Support preserving Virtual Functions by preserving SR-IOV
>>      configuration on PFs and enumerating VFs after Live Update.
>>
>> Changelog
>> ---------
>>
>> v9:
>>   - Simplify pci_liveupdate_preserve_bus_numbers() to always return true
>>     if a device was preserved and drop pci_liveupdate_scan_bridge_end()
>>     (Bjorn)
>>   - Add pci_liveupdate_refuse_bus_numbers() to determine when it is safe
>>     for the PCI core to assign bus numbers to unconfigured bridges. This
>>     required moving "Auto-preserve upstream bridges across Live Update"
>>     before "Preserve bus numbers during Live Update" (Bjorn)
>>   - Add "PCI: Save and restore the ACS Control register" so that the ACS
>>     Control register is handled by the normal save/restore path (Bjorn)
>>   - Rename struct pci_liveupdate::was_preserved to was_incoming, to
>>     disambiguate incoming from outgoing preservation (me)
>>   - Log unfinished preserved devices from the incoming FLB rather than
>>     by walking struct pci_dev (Sashiko)
>>   - Document that state handed over by the previous kernel is trusted,
>>     and panic in pci_flb_retrieve() where failures are detected rather
>>     than unwinding into a caller that panics anyway (Sashiko)
>>   - Fall back to programming ACS from scratch when a preserved device 
>> has
>>     no ACS save buffer, since there is nowhere to record the adopted
>>     controls and they would be lost by the first reset (Sashiko)
>>   - Drop Reviewed-by tags from "Preserve bus numbers during Live Update"
>>     and "Adopt ACS controls in incoming preserved devices", both of 
>> which
>>     changed materially since v8
>>   - Extend commit messages and kernel-doc comments to make the FLB code
>>     flow more clear (Bjorn)
>>   - Address various spelling, formatting, and stylistic issues (Bjorn)
>>
>> v8: 
>> https://lore.kernel.org/linux-pci/20260728221007.2098560-1-dmatlack@google.com/
>> v7: 
>> https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@google.com/
>> v6: 
>> https://lore.kernel.org/linux-pci/20260522202410.3104264-1-dmatlack@google.com/
>> v5: 
>> https://lore.kernel.org/linux-pci/20260512184846.119396-1-dmatlack@google.com/
>> v4: 
>> https://lore.kernel.org/linux-pci/20260423212316.3431746-1-dmatlack@google.com/
>> v3: 
>> https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
>> v2: 
>> https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
>> v1: 
>> https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
>> rfc: 
>> https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/
>>
>>
>> David Matlack (13):
>>    PCI: liveupdate: Set up FLB handler for the PCI core
>>    PCI: liveupdate: Track outgoing preserved PCI devices
>>    PCI: liveupdate: Track incoming preserved PCI devices
>>    PCI: liveupdate: Document driver binding responsibilities
>>    PCI: liveupdate: Auto-preserve upstream bridges across Live Update
>>    PCI: liveupdate: Preserve bus numbers during Live Update
>>    PCI: Refactor matching logic for pci_dev_acs_ops
>>    PCI: Save and restore the ACS Control register
>>    PCI: liveupdate: Adopt ACS controls in incoming preserved devices
>>    PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
>>    PCI: liveupdate: Freeze preservation status during shutdown
>>    PCI: liveupdate: Do not disable bus mastering on preserved devices
>>      during kexec
>>    Documentation: PCI: Add documentation for Live Update
>>
>>   Documentation/PCI/index.rst                   |    1 +
>>   Documentation/PCI/liveupdate.rst              |   35 +
>>   .../admin-guide/kernel-parameters.txt         |    7 +-
>>   Documentation/core-api/liveupdate.rst         |    5 +
>>   MAINTAINERS                                   |   15 +
>>   drivers/pci/Kconfig                           |   15 +
>>   drivers/pci/Makefile                          |    1 +
>>   drivers/pci/liveupdate.c                      | 1015 +++++++++++++++++
>>   drivers/pci/liveupdate.h                      |   62 +
>>   drivers/pci/pci-driver.c                      |    9 +-
>>   drivers/pci/pci.c                             |   79 +-
>>   drivers/pci/pci.h                             |    5 +
>>   drivers/pci/probe.c                           |   16 +-
>>   drivers/pci/quirks.c                          |   58 +-
>>   include/linux/kho/abi/pci.h                   |   66 ++
>>   include/linux/pci.h                           |    7 +
>>   include/linux/pci_liveupdate.h                |   72 ++
>>   17 files changed, 1429 insertions(+), 39 deletions(-)
>>   create mode 100644 Documentation/PCI/liveupdate.rst
>>   create mode 100644 drivers/pci/liveupdate.c
>>   create mode 100644 drivers/pci/liveupdate.h
>>   create mode 100644 include/linux/kho/abi/pci.h
>>   create mode 100644 include/linux/pci_liveupdate.h
>>
>>
>> base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd
>
-- 
Best Regards,
Yanjun.Zhu


