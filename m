Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8ABCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BAB66B009D; Wed, 24 Jun 2026 10:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B056B009E; Wed, 24 Jun 2026 10:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034126B00A6; Wed, 24 Jun 2026 10:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78FFD6B009D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:57:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64E641A038C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:57 +0000 (UTC)
X-FDA: 84915110994.26.E4A71E1
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 956C920004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ljixrzwv;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313075;
	b=xGxnjttrSWzwbxx0b5AJ14HXT6O0Uw3a/36Hd5O8xTijHcjAIa5vHqn5Fn+yKb0KHNbW/d
	ODfzS9tFaXppFHI/YjQVvYndw4cQGzFNXhp+e/7VnLDmGuukCLoWPJzI0U87Da/2gw3I+j
	dj1OVhzSmtyQHTcdfoRyh3YxDxFoA3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=342v7Y1wIc5Ucn3x8pxabI10RJuF4OR+Mw4ajKzQlTY=;
	b=chysvmu2dcw+xUEvzx6A4OXwuYDb74j+cnYpB2YO91Et8LJZ2sOzt8tMdvH6e6VBzTKi+e
	bSZRz1PmhKpqjgMQuPVlXP01x+Ui59YEhikdExCiopZPxUp8vBkKyh1yjaqJYrkeuezRQN
	lb6XRihbBrjwQnyPNbFZuHZ8rdLm9Ug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ljixrzwv;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-517b1f2c6adso9593691cf.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313075; x=1782917875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=342v7Y1wIc5Ucn3x8pxabI10RJuF4OR+Mw4ajKzQlTY=;
        b=Ljixrzwv4isoLgyBMuCxslcrx3GGhx6bYh9xbuAYavokAc2VyxhgBzDGF1oZdDSWDL
         fUTqFnIwHgyECEQSg+UBvbaxQS9UXcyIorISonM9AdyZQNpMmz13PVr+URd3xbPB0d77
         tEdhPuFQFTkIyZvo5YOh3kbGIMHlQ1qrjRDPdNmv09iWfGnkp9aDvByzdgaPM2cux+i9
         +SNZIfdeday2FdqXKV31CW5pF01P18vxblxHjYOe+vPKMv0q/LsPlbIjNaWp2iI6Bcg8
         bMEOZdHexowEQ7AqOObaMSA5b6kEzkPYhgRuIBEtPcO5ydhpbP3/hfeIDkpwHOnj5mJs
         ov7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313075; x=1782917875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=342v7Y1wIc5Ucn3x8pxabI10RJuF4OR+Mw4ajKzQlTY=;
        b=Fe8nyoO3P+hL2oLZ0uzWSxt7su0L2j68wYs1O1KXvrW8sUsk/nx4YrtHdRgWkKbkgr
         hNHpk528LzaOs9/eZj5UsBHzeI15yHtWHL8c64vW/l9XUYVd7jac9ZyylSB7m8OChpuj
         3YJdnwjgB7M/hgCtyX/FyiSjE1NZrjsr9JJ/wdfsKu+EvUoXV1lQxVrfohixzi2hAGYo
         aEakD9deNzHa8dkyEh8wVBGHWgKvhflo8sjoazly15/09OiK6QDla5IL/UFEATwL7fTT
         NgvyU9DplzkVErz3GAQQENxjjCpWzTK8jvbnrYresXIEysKOPUkD4L9qqD9cWOw0cE/t
         Cqqg==
X-Gm-Message-State: AOJu0YyXDCZ9NzhkzWXgPewSZZ047EdatWva6kwxeTQKF/gISE5PKWCx
	4fvLu6zUKxO49IIdhjQiFpZPZAsMr8Uo7jB+pJwSX8w7zxoxXzoVp+SnEhBmnbIvKOik9PKwrPL
	DLIIL
X-Gm-Gg: AfdE7cnEGWg4AUdM0piJeAW+npdr49yFWAvKAcMOuiDdrwSKIt5Zr5huPd4VALYHbwf
	0+HrZ08cPpnsFCsSliHnv3+Gi25ZSI9gP8cMBLhnneEVTuSQGWrCQNUg9QcRAE8SUcdyw1Ec4LW
	NNnMjR9ReKF/934GGH1KKJqHJBkqMer48AXbZsT1ehPeJ2Iq6CNYW2Q6g9wTi1HK42a/2/hgb7i
	WQKN2U+I+6pz9OF5eAG+Cne/3lXlSV3DjxLXWXcUdccYovVpVb8wzrnlQcoMn1ywZkwSGcF6Lpy
	A0pDcyim6b+jSmYJ22TO2oCWW/pRdYpPtxmflc+4LuE0aK5mvwxBLAtoEo7mNQrUzyBXfRXHZoL
	/jpz0RvevCxByhnrKJgsD4VxdLzCtYtq/sMsBIx8KhyWpbjUOAqv/r/DXJu7oeQX6Xj6BBgrrUi
	TeZTpLgFtMuRLPVYsgRdDdEG2djlLBEPTMSE4D8h1kaMisLO+djHsJCL0G+H5WFRUWIR6aPiF8Q
	g==
X-Received: by 2002:a05:622a:191f:b0:517:79f0:ae3d with SMTP id d75a77b69052e-51a5473239fmr101461321cf.21.1782313074271;
        Wed, 24 Jun 2026 07:57:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:57:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 0/9] dax/kmem: atomic whole-device hotplug via sysfs
Date: Wed, 24 Jun 2026 10:57:35 -0400
Message-ID: <20260624145744.3532049-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xd6fewyo11jbn1768iqayybae7zwwr8i
X-Rspamd-Queue-Id: 956C920004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782313075-608318
X-HE-Meta: U2FsdGVkX19HJkg7S9IVm/hFHwTUZAb6swDx6yvhC/aPCFTi6nIeNbcXl/oZAkYdWC6zvkKNW1MOEmka1cQPd4eiIViPg1uphy/GYncX02ox49IoLCQnO1rd5GytNRqgdLmKBQDnUDvXwAnPiP13tOYseDvKRDGsVzk2CylRJn1ElWk/CbHQwOi8QzIqZVqQtn/axINY73ouUY00xuW0Dp8yFlwpyP7rbWwuMlluNVvulZy0m2m33D8GTYc67fGPja0Xae3I7fs9cgr0H8NvHD26mYVXg8nQZhroO5jD7zg5ligH0Q8QH5RC+5K9dCheexBc/SO3OmJ0W1HBHpLh660g6mkOZkGB/GOy28qeufaiBqB344R7h0tKpLEl+Jf8D76ftFeNdb/BDD+pm35cYza4SHmVZoPSQ8ImjlmhEbt8scxeYV+JTEvDaYVvTwM2yP+wYLBfDsETlByUawDUcIEYdTnIGe+z3L6k0sjuYEBRvqU2ckhqtVFenIgXKmlYfHvclU8O4OyX57Uo891+e465z8nvRX0lLGS2bs33LGgkrWkkQkFP426/MlTDnxCuYU+LDkYKuJT4C2zZcr0ZPcVaGMhgyi+IPhfwydMQTJvW0Rd0RE5xCqMEd6Xy7EluimbOHEiLwLDzyAiv4NGM+H4jsRv/DT/QphYkrDfIx2MKXtSjZ9bfHu+ng0Vpd5Mrppfw2di5TjUQ4JWt+0rwKuwrd47CRharin7KtVGWa8E8Xj0AuLWRxN77pjaJ8L4fJDBUDxuHW+kSFeMlfNiM2Sfa/KgKAsczdTPTzUuv0V1GedEZomXT3qIkdHw2HfR+l+08IY87yz9pS2sga6076YeFEohBp6vfPAxcbscBIKLPjOPmgIotrnMDM5yU0jpQr2YHuTOFxyt2mh0Mqk/zjs8Z3RFwzb1GglrjNxdAo6pvXs9w0usMWsjMuCTDS+m9baR4Blar+oasEjzcRDX
 ZuHMq7Wt
 Ttn3h9llvG6Cs/pwHvXXUWcxRHPJvnhZwwkIrTQ6nxKeg/IaI4tvJsPfKkngeXdolTEXmjCkET+2tRp28PGB3Cm9m0AutERYKPhiF7XH373pkXGypsOD4/dvq7t46w9FDSdFVtp38RbjP+7VZCOKNZwWibpxR+yic+2YoA4ZVHyPi54KQV3DLcDgAnvczO3j93Egvekqx4BWljEXWn1HOfIfX33ndl7E1l4DTyNM6GI4MwpbxrVxazK913w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver onlines memory during probe using the system
default policy, with no atomic control for the state of an entire
region at runtime - only by toggling individual memory blocks.

Offlining and removing a whole region therefore races with other
userland controllers that interfere between the offline and remove
steps. This was discussed in the LPC2025 device memory sessions [1].

This series adds a sysfs "state" attribute for atomic whole-device
hotplug control, plus the mm and dax plumbing to support it.

Transitions are atomic across every range of the device. The state
names mirror the per-block memoryX/state ABI with one modification:

  - "unplugged":      memory blocks are not present
  - "online":         online as system RAM, zone chosen by the kernel
  - "online_kernel":  online in ZONE_NORMAL
  - "online_movable": online in ZONE_MOVABLE

"offline" (blocks present but offline) is reportable for backward
compatibility but is not writable because it entices the race condition
we are trying to solve (offlining all the memory blocks in one atomic
and unplugging them in another atomic).

mm preparation:
  1. mm/memory: add memory_block_aligned_range() helper.
  2. mm/memory_hotplug: pass online_type to online_memory_block().
  3. mm/memory_hotplug: export mhp_get_default_online_type().
  4. mm/memory_hotplug: add __add_memory_driver_managed() so a driver can
     select the online policy.  The override is restricted to in-tree
     modules via EXPORT_SYMBOL_FOR_MODULES().
  5. mm/memory_hotplug: add offline_and_remove_memory_ranges() for atomic,
     all-or-nothing offline+remove of several ranges under a single
     lock_device_hotplug().

dax/kmem feature:
  6. Plumb online_type through the dax device creation path.
  7. Extract hotplug/hotremove into helper functions.
  8. Add the "hotplug" sysfs attribute.
  9. selftests/dax: regression test for the attribute.

DAX Kmem probe still creates the memory blocks by default, even when
the default policy is "offline" to preserve backwards compatibility.

Unplug (atomic offline+remove of the whole device) is the new
capability provided by the attribute.

I downgraded a BUG() to a WARN() when unbind is called while the device
is not unplugged.  The old per-block toggling pattern is still used by
userland tools and disconnects the 'hotplug' value from the real region
state; until per-block control is deprecated or restricted in some way,
WARN() flags that tools should move to the new atomic pattern.

Changes since v4:
  - renamed 'dax/hotplug' -> 'dax/state'
  - refactored the work into a shared offline_and_remove_memory_ranges
  - reworked MMOP_ helpers to re-use code
  - fixed cached system default online_type regression
  - nits

Gregory Price (9):
  mm/memory: add memory_block_aligned_range() helper
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  mm/memory_hotplug: add offline_and_remove_memory_ranges()
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug
  selftests/dax: add dax/kmem hotplug sysfs regression test

 Documentation/ABI/testing/sysfs-bus-dax       |  26 +
 drivers/base/memory.c                         |   9 +
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   9 +
 drivers/dax/cxl.c                             |   1 +
 drivers/dax/dax-private.h                     |   4 +
 drivers/dax/hmem/hmem.c                       |   1 +
 drivers/dax/kmem.c                            | 475 ++++++++++++++----
 drivers/dax/pmem.c                            |   1 +
 include/linux/memory.h                        |  22 +
 include/linux/memory_hotplug.h                |  13 +
 mm/memory_hotplug.c                           | 162 ++++--
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 207 ++++++++
 tools/testing/selftests/dax/settings          |   1 +
 17 files changed, 806 insertions(+), 139 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

-- 
2.54.0


