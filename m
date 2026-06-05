Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D36CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378C76B0088; Fri,  5 Jun 2026 17:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A166B008A; Fri,  5 Jun 2026 17:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218C46B008C; Fri,  5 Jun 2026 17:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 107B36B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE1D61C1427
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:17 +0000 (UTC)
X-FDA: 84847124754.28.A3A7865
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id E51474000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JlERDA3Y;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DBoOnWfEM7GbopQoF/ni1AEm1oH3LvPc3svVnbeBTyA=;
	b=FW2JAL6GSdGRzx+z2hrYXEyX6LltGRqZTVPUQ0mCjKfVARJb7N8Ar5SbJIcz/I5vZyBjMs
	od6fHNA0h9rL0bcfR2obSdTI+H3LwJeBnBcTn/XaYp1ThDbB3wTATY5pDa1xgQnwd2FeiR
	K6PLh6uvq5uBvxRH04CJK0tRIDmXW58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694356;
	b=2ap45Aoih3ZlHCpq+Uvk33xrPpUQFQ2RUEJ4VoWf1VX+Lj8QAb7Mbhxg/LxZmFEAfn7Q18
	8G3+Wn2Tq8D9EtgxJ6beVRRRUrtW50DGZCYGteBxnncrTZvtzIMWSPq3TT+YavqHvAkS7l
	NGmRaFMvSBdhy0Y2BELidrpbUn53reg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JlERDA3Y;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ce9ddeddefso25034126d6.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694355; x=1781299155; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DBoOnWfEM7GbopQoF/ni1AEm1oH3LvPc3svVnbeBTyA=;
        b=JlERDA3YU0sci/aa2NjXg3CEahc7RXWEoXBkXqUf/XYTS1YT8dCOhG3HkEQ57s9imn
         h/GTTZ2cSzsa4d+ugC8VkS7W645CK+vmWOUUuxg+Og428QjhvEOcaaiuxDz4+vpmaW5l
         0gOI1T2CU6u/oEPivRvuKZ+OUNvzqciFXlVvjnkQy3et5rsAe23LlOHkwPBML9YlJc54
         1y25KqLdwbUtDS++bEu57zRae0llXwWHxoo9CGN0JLw44sy4UoXvnFOlIKN/kqS/lJF5
         bN6OsO+z7OuEewOHKZwkN1r5UDnQ/2t1jTrt0JwTrk/4WXoViHGYZQvEgk3DG5fP8chb
         mNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694355; x=1781299155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBoOnWfEM7GbopQoF/ni1AEm1oH3LvPc3svVnbeBTyA=;
        b=h6R+Bma/NQejHg/zgOd+TXmnSV/PXGn6UNz1ErIl6mIx0azpoeDaLDpgIdSEkUnWan
         quXzz4fTR2rZV34efpOLP/u5hqX3UKLPAcWECm2hXlrpVv4ZWhB9q77kMIBAqSFyTHfu
         yYwRGnQ72SRSz46pZ0/4h3FsyUkKvV0KNiV5fyZsWHuWXbnZDsvgarOXPpAzpLQtUPyS
         fiZzmfk+4pnQAfSRbEngLZYbjh0wjWwjVcOjKHrAly3FyjiXd9e5eHk7wrEsJD44UHjS
         PdayPdgb5VTHAVGfE8VTgUJplOtxWciIL/sULU8bHlA3I02mZ20aZQgt4taaH2QHthrP
         wqqQ==
X-Gm-Message-State: AOJu0YzJhmoqylOHxyPfocKx5HhfrQxQwwBHeGbjcNrh5HfmKtVgAwEq
	MbMZzQXcm4+FEPFA+h5Dg9OgUbK0PVx83yBs+wxSYeNcb5Aq52WKg6jIWWXCv2yGc8I6oqrbg/i
	sFSu/ah8zpA==
X-Gm-Gg: Acq92OF6BLJjn/cMA4xAW5rXy24YPgJT880F0aFfDshs5VmpQyDgw0xy7+G5xFRMTMh
	RMlWp48Li0JgMfLCJOlrhr9sWmoBMLNVVFtELf3/P6xg+nmWaiShPy/EBPhwH8sfspoJ3dlJEhb
	2vlRqvtrd7jUpOd0FD3h1qgOCVUBmdiOgxo5RiMHR3y44vIT8a+9zf+RsvN4kHEkuqHuAyAb1JZ
	kyC9Cp/UwWbkrGaZSOkvd136wSDPnDqzQlJAiOuc+412NLkZz0O8uyA19+PGv1h3aZsj62zI2w3
	HBsFDyONx8fALavKqbS161RjOp3L0HFkivFSvj41KCqkVMqEoKy1Sww9AMwZdvHkuTl0YyXrhzI
	/e4R9W5HAKNHJ4VGrfx/D6IIbwaMXKlFfA1rKwLg0Wwwu9lM6BmXXwk/PSGnzV9it6app5u9Vtx
	UiIHBZg1CTnXmmq2CiB7pfWGPu6ZZZVeIS7Yr9Rf+rMc/qjKycUcyKFKr5Gy3esmjvzZmQpdqMT
	BSH88LSmuSKFhJZ+C2oy+U=
X-Received: by 2002:a05:6214:484a:b0:8ca:1ddd:a6b8 with SMTP id 6a1803df08f44-8cee600836dmr88586746d6.14.1780694354764;
        Fri, 05 Jun 2026 14:19:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:14 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 0/9] dax/kmem: atomic whole-device hotplug via sysfs
Date: Fri,  5 Jun 2026 22:19:02 +0100
Message-ID: <20260605211911.2160954-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E51474000B
X-Rspam-User: 
X-Stat-Signature: ehjyz75k5ys83gtoff4mb7w359z9jw31
X-Rspamd-Server: rspam08
X-HE-Tag: 1780694355-384451
X-HE-Meta: U2FsdGVkX1/IzsMZvM/SUf4pODDBNhsNACgaLapk7ltHqGNZFbiJciBaoKSjCSbmdGWrgdTgjPzqfi3CdLW0ZiTSVAHPJMaYaFMrJjm/24Uvu1IUUUIhBZXq1hHnsoPSayrpUfGf/2i2EY8W4AqePVPhPU26+9QBInnR22KbEJOk2vekveEFsFUctl6HtRKP+j0VJueH5TqDf0HSQSyOiUDY6KGpCDJne+nEmnIks5euMi+Z+YDubhDKZheHyvac9EJ0Sv00/K0kzBNpiYwCAZgNkcQfv1z2KFc++NlZ1umFkL0jvp25BwgUNksiDB7zCPexabPamsYKolj+on9bEt5wUw5sDY+dxo8GhWw25xI6U7O2pdS/jF5YZL1PEUU9SU/J+Yi6AhWzaDlHEJmPWlTZJmwBLH5ZC6xvkj4H8B56UscwshAuu49a7yFafUWslBn5m2m13jyRuudrpm/mjFUugCzzM1bkkq6LfbP+T6f5pDU6hpwxFmXBINAHEwmbXa6G/eN95ZP6Zoeq/Dj1pi16UYOrNvOTygEcI9+20lRxvCSrSW+rEcN2Gi7VM54CU0Gsvc5qDSMRWHykqS8yA5eZuYdjtn8srlrstskG0YchCYUwSkxaJx8xNfbHPmlp8MshZP9OIYc1OEfxhzlY0Ni2+yT/OIhMabnJ9lTbQjLWCgCZzR+PCsEjddfESMEj/W9VPth2Hh7aFlQ00Woz4sfwVW44VoNgGr+95eAywVZOLzKBFbYIwrTDjGCOE45lEmorOAtSyDTVjVIXB6N2rUDUnt7wX+o1ZLk4L7bG2RF0IIHyT418SBNecle7MuRzOu1L8YusmFW4z/6M8XWUJTULnjR3aZCoh3ZcRVibWPz6I5gEOLPdAh7dn6sDSxLK9LmM0JB/CzngFzXouddgIfH0MS8Ow/6ZqcqHygINlfG4ufRl7/RaG+d8WbvgAGOwfNI9M9tuIYPyuqDm/+P
 Us94Iju2
 T6DxiZR89OPMRbxN5LS9aZh8E3H5j1N/BJ9LNegC106alqHaNQPc/jNqO0409ko7ZjKr8e8uD4LC+Y/YFoo8FYpVP43vR+mq7vo6f/CnPMzcl5eCDzFIgxfyUtByc+XyjEjEMnFD/sTICBJeUSeuD74ZeP9D86e8g4lCvugjT7LjjDOFaZD/P+8ojvuQZpjzQzxhLENw+k2cpgvY24pXUQeO/FoP9NOEfgPmdi1iZZpnng7x5qDM0MmxUAor+qBMOTJufk5q8ffGUIdzjldXfTSos1en4B4YeynW5rR9UUTdR/qK9zyIvtLRj/3g7feu5RFrbqsGjq5qhcU7QPmgVpCmJ6M7HQI7MO8sH+RzsIGtXvgY2WxCyHXO8oEWFJa01YCrCtSWkWJmUPJkZXFXmIbeL3v1vR2JWHDy+
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

This series adds a sysfs "hotplug" attribute for atomic whole-device
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

Changes since v3 [2]:
  - Dropped the memory-tier dedup patch - mt_get_memory_type()
  - Added offline_and_remove_memory_ranges() with rollback
  - Added online_kernel so we mirror memoryX/state ABI.
  - Fixed a backward-compatibility regression: probe now always creates
    memory blocks (offline policy -> present+offline) instead an unplugged
    device, which broke tools expecting the blocks to be present.
  - Restricted the __add_memory_driver_managed() export to the kmem module
    only (was "kmem,cxl_core"); cxl_core can be added when it grows a user.
  - Renamed the alignment helper to memory_block_aligned_range() and
    dropped a dead enum->string helper (reusing online_type_to_str[]).
  - Added an in-tree selftest.

[1] https://lpc.events/event/19/contributions/2016/
[2] https://lore.kernel.org/all/20260321150404.3288786-1-gourry@gourry.net/

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

 Documentation/ABI/testing/sysfs-bus-dax       |  25 +
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   2 +
 drivers/dax/cxl.c                             |   1 +
 drivers/dax/dax-private.h                     |   3 +
 drivers/dax/hmem/hmem.c                       |   1 +
 drivers/dax/kmem.c                            | 500 ++++++++++++++----
 drivers/dax/pmem.c                            |   1 +
 include/linux/memory.h                        |  22 +
 include/linux/memory_hotplug.h                |  12 +
 mm/memory_hotplug.c                           | 163 +++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 145 +++++
 tools/testing/selftests/dax/settings          |   1 +
 16 files changed, 774 insertions(+), 116 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings


base-commit: 7f981ca4cef222e26fc2b4ceb2d2bfe7a6153d3a
-- 
2.54.0

