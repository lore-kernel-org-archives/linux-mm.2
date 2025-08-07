Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D53C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4796B0089; Wed,  6 Aug 2025 21:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75656B008C; Wed,  6 Aug 2025 21:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D706B0092; Wed,  6 Aug 2025 21:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A42806B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4272881EE4
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:49 +0000 (UTC)
X-FDA: 83748267498.04.8E2A8F1
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id B60C51C0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C4AEUZSv;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5t5WgdCKzZLs/8XYDHF2Wi+CjvSv2e7yJlvUgWs9NXE=;
	b=GshlLQtbN/bE8xBULJhdtI/zGa07N2rEGNriqlIsUlKVRe0YFH7yGL/DoStjFyY/J3ikBs
	qHCCJVkyLbpzPQkRK7fDWkmL39Pk+lfxsBU/trY0x4Agko31huwPlHoeUkatWF+qIC/fNn
	jCXEok+5J5qItVoV1/E8uJcT2q0RVkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531087; a=rsa-sha256;
	cv=none;
	b=LpiloIsNePYhhNywX0RJIQpJhUe4OfXopGDB59LpZ0/Lpa4jeyJabAg4b5BpxF5RLKfnLI
	dZHz/rrVXZE9Cv3x/+Edudrv4AfsALQTo48jNx0cfD1XEx1D033w4C9UmgjwbY8Bx2R7jZ
	w+aJ9+7JZsrXgmjO2A28ZJ9iepcWxzI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C4AEUZSv;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b0770954faso7715561cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531087; x=1755135887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5t5WgdCKzZLs/8XYDHF2Wi+CjvSv2e7yJlvUgWs9NXE=;
        b=C4AEUZSvHO6KuW+HsiYWPFG2J+lciG5php9EqmvNquK5igjNpabyEe1b/FlE7x+MV/
         0WNTHqEKxyadYDKxmEXyEN4/owjibXNY/Cf9/Dom5SJuS2qFQDXnwnk+u5EzfwrHmct/
         GCypj/DH70MWHps2tf331U8pjvBPzeN0GV+UyuNnNCpcCZZQ/YY+v8+aW0/uosqXqxlS
         cKuswcn0E0VPYY6ZzEz39U0dvymzKM/MZi735JXDQG2/J0q2OtTb5HLbcH2TckNCxhkM
         uyohalKbO8YpLF9zZax+NMCXFd8pFT3euVLG+0r/Xhzj/CjoWRl8qkhClA8j9GgqEJny
         pkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531087; x=1755135887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t5WgdCKzZLs/8XYDHF2Wi+CjvSv2e7yJlvUgWs9NXE=;
        b=GTO1ERh7oQnCTSqpgNoTPZRf7HuAB0lqR/2vnSCD8O+QCGRoIFCkNjb1JMEaUG2mt8
         vjvw6vLzFQtubQ4MZDRU7tq4xo1xnyezhhUEDGQBQy5oigBNOFVBY27vimRl/pFyk1gx
         2KO5qNPd0qi2eoTL5Y+8kueSS2FTtIbrUAykWcurmGNZRc3RkAes3hHQ5/LNXs+Znclk
         fQAJGu1daJeAzXgAOzWTStabiMYslf7o8UIPZsDKQ+03CJSrXA4KYWnf/vy4tRKPw/55
         mE6xdke7G2rT0VcBLyEFV/igWW8fTCAGyQDtINhfCWYtctdVsO7K4z45yXvvGkdPwD65
         bW7A==
X-Forwarded-Encrypted: i=1; AJvYcCUKV8RjfVPhAb72kvxm9/pyQAw6LygruM+4+EEuM1xEJFXNfS4KOa1Zkcv3Tjq3bm72wmomZGr4yw==@kvack.org
X-Gm-Message-State: AOJu0Yw+IervbGxiPf0o6POoLE/5mtzwKhUSaiv4M+peoY5J7vZwFu23
	lQ8CCqGGZhGFWpQi7yQ116WOS5SL9IiabrSx5P0C3pG3DCo/KjzRz6PZ6b1GGCmwSWY=
X-Gm-Gg: ASbGncv/87lHzfnNnbtE3zyvqKvCfPKJq3Rdu11z5h/BK1uVxnVzc3+TFXqQWCVOETY
	SwaNbFOjg30SimzTpb608WJr5D//eo3xt5o+iqLlIGLc5U/bdi7mI+xGiEefDEzV5O8R0RMR/2z
	fl9IjNCSJv09TSdI7N2SoizO+JPapHU1dq6CEosOzzZgY+KC4wnConqkXx3LkHIV7crkZjG4BN6
	SBoRMGCQbdS5qbYkkGkFRNHIZWGDDIFLwbj7YRVhxnMHt4Mm/e0XDdb+Yx2x/zG8VcxShUEhz27
	CjDk1F3EapQvL0e4UyZco7thjAemYE378m+OBvgijTrDcQdfuAnzJViXS2SUCjhVz9VpMXY4Y8a
	ma1z2jTgJU4CIBsqhMpgPQEfWSPG1in4HWUeKT+dhM04TKWwBG5D8aOk4yz7TJDCzRbqLuZBGJX
	AsvsIAXMGCHhQ6
X-Google-Smtp-Source: AGHT+IGPO+4xl7nmrZIZyIJy0fZvzD2A/U8JcZ0l0oDJH7U01tS0yC0z69NB5gtl+sosZxuKwCrmqw==
X-Received: by 2002:a05:6214:4015:b0:707:6323:24f3 with SMTP id 6a1803df08f44-709794fdd52mr69986346d6.11.1754531086578;
        Wed, 06 Aug 2025 18:44:46 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 00/30] Live Update Orchestrator
Date: Thu,  7 Aug 2025 01:44:06 +0000
Message-ID: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B60C51C0005
X-Stat-Signature: aeo1tstik658g5uapm693sb6gdy685wx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531087-559342
X-HE-Meta: U2FsdGVkX19A13Nyyu78VuUlIVr5NVY5Whwwc83OphXemBHnLIZp3hgwRD5MKf27s0l2NL38BiddzhzE8+vHz6mTi6qeUhSQIiOakmeCxc4/8obJ6qJ+WfFaNN0DVacv2mn72L0DQdb4Z9/0JK44sKuhXbAkCuxF4tuV4YYnZa+CrFu9bkRrOIu3RambBXXkL/lyk9cpATuOoT5KMyo6ihFqzLy/MvA3rY5ZLgvck7rYal0GV2U7mYiro28b5CPldhma7/9FEdO3uHK0dDpN5LZlKszZCNm2L700c7DtebzfD5Li5Heuq0zS0JXF5yMcxEr3wZOGt6ENbbk8y/c+DibMywjkvbthFyY0PFah6uMPClWar2oZ769J2RUv+9mzjuuEoCG/BeYba8UpaX6vx6lY5QGi8bXoRClV/5jVVaZGQ3RL5tzF1ImD/T0NLTyB11Vu4vcZsTs6MkVL20E3+U0GBkUQhWoQobO4qDiz0fpdspRLNTQQz6xd8zlccAnZm0I/UMTKnT9JDKmHznwZA/OSYHSs0AGKHzeDenWfVKzXpSYXuLVHiGyGhzEiIXdM1G89vdWTz+761VZ3/PowC+LB/v9WR7eDQrSa+uIuT9e/MYxRES2CbZMwFCP+jyZUDc3GIQ2EcVE1OAJvu0ruZ45LoBxKjymSy6Rxrk7ljUDHZ2/8VfU4t2a1wtKJmzQoqUqhICzXxYJy59SNUiB4f2GC5gZuM+nEAHIHKTKI7YwCTtZ8HeWgnvqeiCaQTeKlVRXmlB7BUp4E+4OE2DrvIIht+5QOQhgWxt8zi8QyWf5yAdTpordwWlUG99CrTWU/N1myoPxW7RuChkfTben38M+5xPn/IANJ5X0Tp8yvuTNgExIDm4cMxaY0tFJpOCHlADshRO87iWvy9KdEADmO2Wth5887ufWJThA8IwlQSgwnRPM3od6An4ekEhgNhW+RZUdA5/w2aMIKyj6NyjQ
 L9lJnHk6
 0buH3tH1lXRsfn3HACLIJfs6xybFsCk4EJRlr5r4EYEfBRQCiajPyP5U/WaMlKNyodJig4dKv+EcsNhWxQZw/DBg3mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the LUO, a kernel subsystem designed to
facilitate live kernel updates with minimal downtime,
particularly in cloud delplyoments aiming to update without fully
disrupting running virtual machines.

This series builds upon KHO framework by adding programmatic
control over KHO's lifecycle and leveraging KHO for persisting LUO's
own metadata across the kexec boundary. The git branch for this series
can be found at:

https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3

Changelog from v2:
- Addressed comments from Mike Rapoport and Jason Gunthorpe
- Only one user agent (LiveupdateD) can open /dev/liveupdate
- Release all preserved resources if /dev/liveupdate closes
  before reboot.
- With the above changes, sessions are not needed, and should be
  maintained by the user-agent itself, so removed support for
  sessions.
- Added support for changing per-FD state (i.e. some FDs can be
  prepared or finished before the global transition.
- All IOCTLs now follow iommufd/fwctl extendable design.
- Replaced locks with guards
- Added a callback for registered subsystems to be notified
  during boot: ops->boot().
- Removed args from callbacks, instead use container_of() to
  carry context specific data (see luo_selftests.c for example).
- removed patches for luolib, they are going to be introduced in
  a separate repository.

What is Live Update?
Live Update is a kexec based reboot process where selected kernel
resources (memory, file descriptors, and eventually devices) are kept
operational or their state preserved across a kernel transition. For
certain resources, DMA and interrupt activity might continue with
minimal interruption during the kernel reboot.

LUO provides a framework for coordinating live updates. It features:
State Machine: Manages the live update process through states:
NORMAL, PREPARED, FROZEN, UPDATED.

KHO Integration:

LUO programmatically drives KHO's finalization and abort sequences.
KHO's debugfs interface is now optional configured via
CONFIG_KEXEC_HANDOVER_DEBUG.

LUO preserves its own metadata via KHO's kho_add_subtree and
kho_preserve_phys() mechanisms.

Subsystem Participation: A callback API liveupdate_register_subsystem()
allows kernel subsystems (e.g., KVM, IOMMU, VFIO, PCI) to register
handlers for LUO events (PREPARE, FREEZE, FINISH, CANCEL) and persist a
u64 payload via the LUO FDT.

File Descriptor Preservation: Infrastructure
liveupdate_register_filesystem, luo_register_file, luo_retrieve_file to
allow specific types of file descriptors (e.g., memfd, vfio) to be
preserved and restored.

Handlers for specific file types can be registered to manage their
preservation and restoration, storing a u64 payload in the LUO FDT.

User-space Interface:

ioctl (/dev/liveupdate): The primary control interface for
triggering LUO state transitions (prepare, freeze, finish, cancel)
and managing the preservation/restoration of file descriptors.
Access requires CAP_SYS_ADMIN.

sysfs (/sys/kernel/liveupdate/state): A read-only interface for
monitoring the current LUO state. This allows userspace services to
track progress and coordinate actions.

Selftests: Includes kernel-side hooks and userspace selftests to
verify core LUO functionality, particularly subsystem registration and
basic state transitions.

LUO State Machine and Events:

NORMAL:   Default operational state.
PREPARED: Initial preparation complete after LIVEUPDATE_PREPARE
          event. Subsystems have saved initial state.
FROZEN:   Final "blackout window" state after LIVEUPDATE_FREEZE
          event, just before kexec. Workloads must be suspended.
UPDATED:  Next kernel has booted via live update. Awaiting restoration
          and LIVEUPDATE_FINISH.

Events:
LIVEUPDATE_PREPARE: Prepare for reboot, serialize state.
LIVEUPDATE_FREEZE:  Final opportunity to save state before kexec.
LIVEUPDATE_FINISH:  Post-reboot cleanup in the next kernel.
LIVEUPDATE_CANCEL:  Abort prepare or freeze, revert changes.

v2: https://lore.kernel.org/all/20250723144649.1696299-1-pasha.tatashin@soleen.com
v1: https://lore.kernel.org/all/20250625231838.1897085-1-pasha.tatashin@soleen.com
RFC v2: https://lore.kernel.org/all/20250515182322.117840-1-pasha.tatashin@soleen.com
RFC v1: https://lore.kernel.org/all/20250320024011.2995837-1-pasha.tatashin@soleen.com

Changyuan Lyu (1):
  kho: add interfaces to unpreserve folios and physical memory ranges

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (23):
  kho: init new_physxa->phys_bits to fix lockdep
  kho: mm: Don't allow deferred struct page with KHO
  kho: warn if KHO is disabled due to an error
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  liveupdate: luo_subsystems: add subsystem registration
  liveupdate: luo_subsystems: implement subsystem callbacks
  liveupdate: luo_files: add infrastructure for FDs
  liveupdate: luo_files: implement file systems callbacks
  liveupdate: luo_ioctl: add userpsace interface
  liveupdate: luo_files: luo_ioctl: Unregister all FDs on device close
  liveupdate: luo_files: luo_ioctl: Add ioctls for per-file state
    management
  liveupdate: luo_sysfs: add sysfs state monitoring
  reboot: call liveupdate_reboot() before kexec
  kho: move kho debugfs directory to liveupdate
  liveupdate: add selftests for subsystems un/registration
  selftests/liveupdate: add subsystem/state tests
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry

Pratyush Yadav (5):
  mm: shmem: use SHMEM_F_* flags instead of VM_* flags
  mm: shmem: allow freezing inode mapping
  mm: shmem: export some functions to internal.h
  luo: allow preserving memfd
  docs: add documentation for memfd preservation via LUO

 .../ABI/testing/sysfs-kernel-liveupdate       |   51 +
 Documentation/admin-guide/index.rst           |    1 +
 Documentation/admin-guide/liveupdate.rst      |   16 +
 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/kho/concepts.rst       |    2 +-
 Documentation/core-api/liveupdate.rst         |   57 +
 Documentation/mm/index.rst                    |    1 +
 Documentation/mm/memfd_preservation.rst       |  138 +++
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 Documentation/userspace-api/liveupdate.rst    |   25 +
 MAINTAINERS                                   |   19 +-
 include/linux/kexec_handover.h                |   53 +-
 include/linux/liveupdate.h                    |  203 ++++
 include/linux/shmem_fs.h                      |   23 +
 include/uapi/linux/liveupdate.h               |  399 +++++++
 init/Kconfig                                  |    2 +
 kernel/Kconfig.kexec                          |   14 -
 kernel/Makefile                               |    2 +-
 kernel/liveupdate/Kconfig                     |   90 ++
 kernel/liveupdate/Makefile                    |   17 +
 kernel/{ => liveupdate}/kexec_handover.c      |  554 ++++-----
 kernel/liveupdate/kexec_handover_debug.c      |  222 ++++
 kernel/liveupdate/kexec_handover_internal.h   |   45 +
 kernel/liveupdate/luo_core.c                  |  517 +++++++++
 kernel/liveupdate/luo_files.c                 | 1033 +++++++++++++++++
 kernel/liveupdate/luo_internal.h              |   60 +
 kernel/liveupdate/luo_ioctl.c                 |  297 +++++
 kernel/liveupdate/luo_selftests.c             |  345 ++++++
 kernel/liveupdate/luo_selftests.h             |   84 ++
 kernel/liveupdate/luo_subsystems.c            |  452 ++++++++
 kernel/liveupdate/luo_sysfs.c                 |   92 ++
 kernel/reboot.c                               |    4 +
 mm/Makefile                                   |    1 +
 mm/internal.h                                 |    6 +
 mm/memblock.c                                 |   56 +-
 mm/memfd_luo.c                                |  507 ++++++++
 mm/shmem.c                                    |   52 +-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/liveupdate/.gitignore |    1 +
 tools/testing/selftests/liveupdate/Makefile   |    7 +
 tools/testing/selftests/liveupdate/config     |    6 +
 .../testing/selftests/liveupdate/liveupdate.c |  406 +++++++
 43 files changed, 5448 insertions(+), 417 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-liveupdate
 create mode 100644 Documentation/admin-guide/liveupdate.rst
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (74%)
 create mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_files.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_ioctl.c
 create mode 100644 kernel/liveupdate/luo_selftests.c
 create mode 100644 kernel/liveupdate/luo_selftests.h
 create mode 100644 kernel/liveupdate/luo_subsystems.c
 create mode 100644 kernel/liveupdate/luo_sysfs.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

-- 
2.50.1.565.gc32cd1483b-goog


