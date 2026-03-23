Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11ABEFC72D2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5C06B008C; Mon, 23 Mar 2026 19:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CCB66B0093; Mon, 23 Mar 2026 19:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E38E6B0095; Mon, 23 Mar 2026 19:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBF146B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C8B6C3CEA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:40 +0000 (UTC)
X-FDA: 84578995200.24.8A08516
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8D13100005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nI1KSduu;
	spf=pass (imf05.hostedemail.com: domain of 3rdPBaQgKCLATcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3rdPBaQgKCLATcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZJphTQtAwt37fyli6EqFM5TvIsP7A+bmY4QV1yw4cuY=;
	b=b5HHcJck3Y2BkgdJBhjyf93VXPoQblzeWukCI/VlywkqZGo2m2JLdSGvpGP2BxkDphrRjV
	f1XVxvZe3gDDzUTGqQIawz6MPIk41ECM2LZq5XHReg8zCBZKCfwElr9C4lzD4aBrS3YwHL
	lyTqn+xoAT2wNjnHQjTxakTMePWr38M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310319; a=rsa-sha256;
	cv=none;
	b=hLG4VQjKyONVojfW/FrdYH05LJs0Ubf/jp2D5RGkOF8u4967LwwVUgcuyaqVekPK5fEb86
	3szCaHFHBZK88KJb+oKqaIA3e3CXtGzAUw9SLreS374DmtJ4WoNOKBMQuo0E4CTR3VGDyy
	MvrmBRuv2j8Z4LT+POfl7C4axAVmzsY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nI1KSduu;
	spf=pass (imf05.hostedemail.com: domain of 3rdPBaQgKCLATcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3rdPBaQgKCLATcQjbQSaWeeWbU.SecbYdkn-ccalQSa.ehW@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b064884a7cso335537445ad.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310318; x=1774915118; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZJphTQtAwt37fyli6EqFM5TvIsP7A+bmY4QV1yw4cuY=;
        b=nI1KSduu0TNUKsxrsHfFkHB6/rL5rgmhnK3qksZcOCmYgeUUzE9JD6u9ZoZVi8+Pv5
         gkt7sxs32ilZEGiWrMwIrMx29J3Q6hJNbf4nbuS1UFIsgmn7AQyqZW3IQls2/n+K8Nsz
         U5YwwIS+6ptUhLA6pCVrQyKZ91EozX0KVkHnkDsvdcAednlko9MQ/62/QNLlNJZmbvJV
         TBD2OESb8aUTPRV5csOlJe6ks1SJHi7gWKGdNu59Kmd7sL6PyZYVzIlGWnaRBDdObk86
         RRkfKXR4MfcoZK4hHsKWBWXqM8NUepjI0JgFCVuWj28gsw0td1tMZ0iecvEnLhx1bWND
         ZXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310318; x=1774915118;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJphTQtAwt37fyli6EqFM5TvIsP7A+bmY4QV1yw4cuY=;
        b=Inuw+7cCJdfFisbkOHna3i64ulr99peg/3V7RGB11GKM8bbhER1e8Ei6/6gUX3VZtx
         8s6QGVoDFzHpVpTiXggTYUj7m0SRjMt8I+wUCGMvizRuy+ciPoTdm4HxQdiQXJZdyy8v
         FOy2xhLRNVSa2vuvtdwiKPl5Edku099NwH47btcHZIJI6nfeCltt11TEnkIIjTfpyZak
         2/tQSgeLiONZD5Mm/F5z3OfURf70E9wDA4qlU0tjFxsJpo+EYrj7vIFUbxcfB9mDMX3Y
         iki2i2zJxVJMmcQ6UndF6BDyL/DxQMd4Dpl+ZYkTzSbsAOl4FIetfzisAwav+kBI4ul/
         UAVw==
X-Forwarded-Encrypted: i=1; AJvYcCUxKWms6pw2AyrQq17GJp5CnZKcUHgaWpNDlSS4iVVBwu0/h1Wi3tKkkfFZdTZThVoAtc50WbUTyA==@kvack.org
X-Gm-Message-State: AOJu0YyQ1+vRNH4UDXBB2e0Ygbh0y8OuzoqT9gNXQn9ngDJaaFhgEonJ
	trrdHaRXIz+F9cUPFHwvJx4cm7jXlZ3EK7XE5KUNL4/DW61j4HquyHRQrrSdEdE6Ek+6fBoUOY4
	fnyfnxhIryaPDAA==
X-Received: from plfu18.prod.google.com ([2002:a17:902:e5d2:b0:2b0:6cdd:87e2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e850:b0:2ae:7fbd:3dcd with SMTP id d9443c01a7336-2b0827e30f8mr133238585ad.52.1774310317408;
 Mon, 23 Mar 2026 16:58:37 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-1-dmatlack@google.com>
Subject: [PATCH v3 00/24] vfio/pci: Base Live Update support for VFIO device files
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: gpsxq1nuowz3b5hci649oxyc8cjnrscq
X-Rspamd-Queue-Id: D8D13100005
X-Rspam-User: 
X-HE-Tag: 1774310318-398677
X-HE-Meta: U2FsdGVkX19PBsZ3IvhmgdskbkBCehIdVvjdhXOgg9zGbcXMdv1k83gkRMbm1ZzcJaC4tESQz0YvoYHAjh6fWH3YZnsl/NpMHtrYj+PBVkaP3/5sO5SU/O3aSkTPbXLdbdG3dMkTEzxFs4wGcHFkFU0PanYumsB/c9szwoLrur7p89yN9L0+64GaGsNJDF70zx/0CQB6glr/YC6n6ScWyRW92yX0dJdqsf1aTOJFZ1LCG+z5GjOz/2guOjxK4KgELJsIUpmxp7uqluBBC4XuK6DC/Zsfk7ZWgL+IWM0CTwPkvrixkOzXRPMLQWQMCXFPJuIhHUAUTcQVeRaWNCG6nn5SxXXlhyyKrMq7QzW52HjAlDtCvTj2Doka/S6KM0/H6pRzqi2p+vgQHjMwEnxcbajmOjcSTEFVL29eKRDsQznlhUG6eueNmtDo/iYE7zRQDaDOpMVs41K7Xxcufnzl4QlSEyZG9La5MfWJ9lY/Xfjxo/MmA584m4xBJTUqtgCpouubyRoBom48jhd2LnMtgLBrtSUTCqICPpqNFuvXEsfG3o/YT5ODtOkBjrW0beGDterwRx+1mBmVeojDO+UavRb57sTUcy+tr+IatoMTBDeE3GroAWJWV21/XbImwwwivxeI0vjL0i+LCkjfsK7dG6MBDIV7pbU4/YSxE1ziGWpkNR38lSgmGxmn2sqy/RolBZFiZY0MYWZI/jrAwUjBg3e8pq5DsYDYZGID0i25Zw/3YyyJAbybfCftXYi3CaeVTZckj52iGF8xX/1QgxQY49CTNIdr4TSkBfI/zeW380/GZ9AcF3+Oy1AKU5APThSEXUj0vrHAwJgPbLDZsu6KNr7BJNq5KP9qbxVvPe1qccK3rSu7htap75LoiCW2BIidL2eLOsunjTwAOM0Jj/76gscIwDBawki/zHxHYkgPeGNpai1cNnGFs8gXZoS/qqXPPG8S99KYcL2DrGram3q
 pfQlow1n
 3szteKoapUs7febY0tzqozGmvpe5ClFFao5VgNWbJwMybybaZC7GPKQbSfJ70bNskhq+2W007ySRRklzVqCKpLLuwD936RqlxbXbXJVAwPJ7HQbRjje8pkwDNXgRsbOwpOQvbxplSTAQNfsJrT9YFVV7woGpDOHg8csvE0KUhpMtbsIRz7hxrv8HYwnLtvtIgbEYZd2yInJ+xQsuK0fH85TPFky1FLPXk0/i+BBnG0YG5ZIze+zyfTkaOtctWxzpN4COpigTdUqd1bgbW49sEtEptbpMmb5J9iVXHdTUBuYUHmG4X8WJcKjW+pVBt49vJq26vMz9+CNYE3DZc47NNoBMFBojKjHttGdArgmmFxwNMkBkUQig4dDcKrMdpki7QyYs2QJ2uOwMCXZBGwkXPuABU62DMi6DlbYN0ztL5k+CqW0vj5dJ9k3Tlapn/pp6tcrbcPHaqNlRGEf723xmeKdofsDBW56IikSmtfSxIhiZciVZM+MufoZbnH3JiLlJra5nJvOsB6wTHZkL81Z1Rsrr8tmBvfjMFuq6JLDNQJuKBu+jN4X4mh43iFh2Atn7b1RJCmibRgxfagUpAft/YZ+2ncX6+a9JqYfbQ6/r34IVxvf/MmFFiFXb82iW2TQk3QScHqZ2Blz/iUKmTxiTvKmEmlBGMfwqC9uF9cNsbyceFA76IxcluUOqqVDg2ICdY9uuLfIDD6bhYzyOLoDqD+8VlYxHBCB6NtCyvOvKDq+EKulc3lBSOh2MrKME/R14LzEerxxSPTHDKKLAt8We2O4O4ozLrCkhfwDLw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/vfio/cdev/v3

This series adds the base support to preserve a VFIO device file across
a Live Update. "Base support" means that this allows userspace to
safely preserve a VFIO device file with LIVEUPDATE_SESSION_PRESERVE_FD
and retrieve it with  LIVEUPDATE_SESSION_RETRIEVE_FD, but the device
itself is not preserved in a fully running state across Live Update.

This series aims to provide a foundation on which to build the rest of
the device preservation infrastructure, including:

 1. Preservation of iommufd files [1]
 2. Preservation of IOMMU driver state
 3. Preservation of PCI state (BAR resources, device state, bridge state, ...)
 4. Preservation of vfio-pci driver state

Steps 1 and 2 are already in-progress on the mailing list. We are
working on a detailed roadmap for steps 3 and 4.

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

Dependencies
------------

This series is built on top of v7.0-rc4 plus a series from Pasha
Tatashin to fix the module refcounting in FLB:

  https://lore.kernel.org/lkml/20260318141637.1870220-10-pasha.tatashin@soleen.com/

Changelog
---------

v3:
 - Add logging & documentation for pci=assign-busses overrides (Pranjal)
 - Use 2026 in drivers/pci/liveupdate.c (Pranjal)
 - Use 2026 in drivers/vfio/pci/vfio_pci_liveupdate.c (Pranjal)
 - Drop incoming/outgoing from PCI APIs (Sami)
 - Eliminate duplicate extern declarations for vfio_device_fops
   (Pranjal)
 - Keep struct vfio_device_file private (Pranjal)
 - Add comment about not supporting hot-plug (Pranjal)
 - Add comment about not supporting VFs (Sami)
 - Better error handling for liveupdate_flb_get_incoming() (Pranjal)
 - Remove liveupdate_enabled() checks (Zhu)
 - Remove liveupdate_enabled() checks in vfio_pci_liveupdate_init() (Pranjal)
 - Drop IOMMU reference from bus number commit message (Bjorn)
 - Add fabric rationale to commit message (Jason)
 - Swap incoming ... outgoing ordering in commit message (Bjorn)
 - Use vfio_device_cdev_opened() instead of df->group (Alex)
 - Add comments for CONFIG_VFIO_PCI_ZDEV_KVM (Alex)
 - Add comments for vfio_pci_is_intel_display() (Alex)
 - Use pci_dev_try_lock() in freeze (Alex)
 - Fix device reset locking in freeze() (me)
 - Use u32 for domain in PCI (Bjorn)
 - Use u32 for domain in VFIO (Bjorn)
 - Make pci_liveupdate_incoming_nr_devices() private to drivers/pci/ (Bjorn)
 - Fix dev->liveupdate_incoming readability (Bjorn)
 - Take pci_ser_delete() out of WARN_ON_ONCE() (Bjorn)
 - Drop reference to userspace & files from PCI commit message (Bjorn)
 - Rename __vfio_device_fops_cdev_open() to vfio_device_cdev_open_file() (Alex)
 - Fix NULL pointer dereference in release() (Alex)
 - Handle return value of pci_liveupdate_outgoing_preserve() (Alex)
 - Make pci_liveupdate_unregister_fh() unabe to fail. (Alex)
 - Move vfio_liveupdate_incoming_is_preserved() to drivers/vfio/vfio.h (Alex)
 - Add vfio_pci_core_probe_reset() (Alex)
 - Forward declare ser struct in include/linux/vfio_pci_core.h (Alex)
 - Bump compatibility string when adding reset_works (Alex)
 - How will userspace detect partial preservation? (Alex)
 - Require single device per iommu_group (Jason)
 - Rename pci_liveupdate_register_fh() to pci_liveupdate_register_flb() (Vipin)
 - Use ksft_exit_skip() and SKIP() (Vipin)
 - Move documentation to code (Vipin)
 - Use __u64 instead of int for token in Live Update selftest helpers (Gemini)
 - Add documentation for drivers/pci/liveupdate.c (me)

v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/

v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/

rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/

Cc: Pranjal Shrivastava <praan@google.com>
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

David Matlack (15):
  liveupdate: Export symbols needed by modules
  PCI: Add API to track PCI devices preserved across Live Update
  PCI: Require Live Update preserved devices are in singleton
    iommu_groups
  PCI: Inherit bus numbers from previous kernel during Live Update
  docs: liveupdate: Add documentation for PCI
  vfio/pci: Notify PCI subsystem about devices preserved across Live
    Update
  vfio: Enforce preserved devices are retrieved via
    LIVEUPDATE_SESSION_RETRIEVE_FD
  vfio/pci: Store incoming Live Update state in struct
    vfio_pci_core_device
  docs: liveupdate: Add documentation for VFIO PCI
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

 Documentation/PCI/liveupdate.rst              |  23 +
 .../admin-guide/kernel-parameters.txt         |   6 +-
 Documentation/core-api/liveupdate.rst         |   2 +
 .../driver-api/vfio_pci_liveupdate.rst        |  23 +
 MAINTAINERS                                   |   2 +
 drivers/pci/Kconfig                           |  11 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 415 ++++++++++++++++++
 drivers/pci/pci.h                             |  14 +
 drivers/pci/probe.c                           |  37 +-
 drivers/vfio/device_cdev.c                    |  63 ++-
 drivers/vfio/group.c                          |   9 +
 drivers/vfio/pci/Kconfig                      |  11 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |  14 +-
 drivers/vfio/pci/vfio_pci_core.c              |  90 ++--
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 328 ++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  18 +
 drivers/vfio/vfio.h                           |  18 +
 drivers/vfio/vfio_main.c                      |  16 +-
 include/linux/kho/abi/pci.h                   |  62 +++
 include/linux/kho/abi/vfio_pci.h              |  45 ++
 include/linux/pci.h                           |  41 ++
 include/linux/vfio.h                          |  13 +
 include/linux/vfio_pci_core.h                 |   2 +
 kernel/liveupdate/luo_core.c                  |   1 +
 kernel/liveupdate/luo_file.c                  |   2 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |  14 +-
 .../include/libliveupdate.h}                  |  11 +-
 .../selftests/liveupdate/lib/libliveupdate.mk |  20 +
 .../{luo_test_utils.c => lib/liveupdate.c}    |  43 +-
 .../selftests/liveupdate/luo_kexec_simple.c   |   2 +-
 .../selftests/liveupdate/luo_multi_session.c  |   2 +-
 tools/testing/selftests/vfio/Makefile         |  23 +-
 .../vfio/lib/include/libvfio/iommu.h          |   2 +
 .../lib/include/libvfio/vfio_pci_device.h     |   8 +
 tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  60 ++-
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 +++++++++++
 .../vfio/vfio_pci_liveupdate_uapi_test.c      |  93 ++++
 41 files changed, 1715 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/PCI/liveupdate.rst
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/kho/abi/vfio_pci.h
 rename tools/testing/selftests/liveupdate/{luo_test_utils.h => lib/include/libliveupdate.h} (80%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 rename tools/testing/selftests/liveupdate/{luo_test_utils.c => lib/liveupdate.c} (89%)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c


base-commit: 3251ac3df4374e4e94e4fbecf49ad1573933018a
prerequisite-patch-id: 37ebd38e2247ccb02e6a6c7543a378534d69a038
prerequisite-patch-id: 19c8469a9ae5cd13618481dd75012444330f80f9
prerequisite-patch-id: 2ba04f598993e2c2d941c4cd3f2dc1e98905d68b
prerequisite-patch-id: fcab928f6ee32a145667822ceca5e4f1f567d530
prerequisite-patch-id: 6d11347278609426baa9eacc1726b32b48d09a25
prerequisite-patch-id: 94a9e8a8cb6004e12de90fcc0068e8a8b12652de
prerequisite-patch-id: d658019a7ac7c82ebe4a6c6086457e27460174d3
prerequisite-patch-id: 41e68c9fc8e8c5e493497e87ca13577b3167cf80
-- 
2.53.0.983.g0bb29b3bc5-goog


