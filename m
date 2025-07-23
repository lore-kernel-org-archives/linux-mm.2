Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3217CC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F4C6B00AB; Wed, 23 Jul 2025 10:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6506B00AC; Wed, 23 Jul 2025 10:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5DA6B00AD; Wed, 23 Jul 2025 10:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A57D6B00AB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:46:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DD2D1DA045
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:57 +0000 (UTC)
X-FDA: 83695806474.20.F0D581C
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B13640017
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b="aJTUI/m0";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282015; a=rsa-sha256;
	cv=none;
	b=amIWDB1w3rvN0HulYoaNHWdAZVjUVI5134EWSQpqoAo5b5kiaD1/YVD5k2pNtVir6hphXb
	+eNudeAXnnm484mTWn9fEGx/PNx1j0WeMfvwzJ/5V2opoda0i76CI5n7MX9H4A6xGrMBHj
	eVLLQYICge2kwcKNhKg96aCuDbsn5cg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b="aJTUI/m0";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=if8ZeEYWjW8ZrRaLafDDRFmlzkGM98gEOVQVYa5YjdE=;
	b=H132x54SplugG4YMKB/69ZDlOVdmHWVpB5sOiGMNLqprLFFCy9qJdCcyal8PQvLas6RAaN
	yDAhRFLiEqpdYTXvvEUrULrAHHEYmKEmxbsjUCXNfjqBCkC+MSNKSKeMP78901uZslBlqS
	OsDpW3ORR3vxTXL/whvZJNGJja6pdiY=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-70f862dbeaeso63730217b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282014; x=1753886814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=if8ZeEYWjW8ZrRaLafDDRFmlzkGM98gEOVQVYa5YjdE=;
        b=aJTUI/m0Uy/Ah4z5w7jg0hZclw6FwuLR1wHxtFPiY9h5HiTL6VuK+rzMwLOYNawxr9
         JKO8/AyllHG+3ulhCt3JDVznANOyGUugwEjrXWXEJuCmt8f32j0iYuJvP2CdKnxbUIvp
         VR96FCJBIBdhCr4Yk4WxIX5Ej2yDjs903qGwuQFMI39DcGUpJdjIE8YdTCutY1vYqAKv
         n+gjQh8OXBrJhL+KkhlLWhraWz7e2Q3D85FDMjjuDALsjtlFSsUR2FmOswkFyybaTLAe
         B25+iPj0wYt4WU0dsMk4aEw1ypIiT1n0eCpjruCaO9l4LQ0uQPJe5V3NyLiw+4aXg7xI
         +paQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282014; x=1753886814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=if8ZeEYWjW8ZrRaLafDDRFmlzkGM98gEOVQVYa5YjdE=;
        b=tUo8nEb4ehlS7c1TMdh4c17YOymDKw6Hk1JZxH4anucdfcMEmjrgxCuLAAK+et4vt6
         w77G+iWruVg1mHlkEmdrsH3L/jQ456pcTim+YB5jzAzci/r9xVyv2kKCgS5uuaSOY+Nc
         dPUu9/xG1ZpHCXc7JN8U+ww8FveGFTFLyUCNxyhc3Y8lGAaRUJp8PMUUO9Sib+JT/H8E
         VUQ5BoSFMytkZfKKwQnLJCdDUIHdi2GcYofI9xVhXYDviBMdZZu7JUcXDySu6ShlkSlP
         7ppTsVQjqdU8lzm6CfqyuZHQu1Ok/pFbgC8wTw1bRO82AMRNwZpBqoFWZrmXnfnDPKvI
         RxmA==
X-Forwarded-Encrypted: i=1; AJvYcCVUs5RFdeCsCXMWYgZpxylNTvLPcW8OAeptBu5O1aHxoK5Do6Rhg7SdUwCfU9UC3i7nRf2rMpCGTA==@kvack.org
X-Gm-Message-State: AOJu0Yy8M9DJsvofA0amN/+TWQr8vnJ+D8N30SNac4ZuWvmA4Dg8qg87
	TrxScDtYOJpPfAlLl24kDtJvHyo70SW6xw9ahzDev0knUmNPLaFRxk09ypuATSTJiE4=
X-Gm-Gg: ASbGncty6WTROqqKoADcZBktNCl5MyxOEgLZq51oZ0OZSwNvMfOigsIUApR4sZ6S36N
	BXlM0a6rr5vx9u5rvW4V8maxGBkEl9u5RJjASNf+K3VqMqbw1ZyK1vvMYfVkHDmOBc60gyFdgPr
	8f4Z8oFeSStKVSV2kAIYb0+7npe+VV6EiiyDeAM/+Ba4vOAFl9I26I2L25FzEtyjK1ALi85vb5z
	HcyRwAMPXrYjkFsiy647uTi9N+lnz16suoYg3y2BB8IoixTT5sNgw9PAjUtvadWD6WHx/CEnI7o
	AJwEbHyRpj0KOBmAKO+sy1ITwiJai9y5wV0Acj/iUguAFNa+cqOrQkJ9RpV3pDX+6h5wk2grkcs
	fjuT20ncebjkAyeBLUBiazfU8esRAbzf4JoWuAUo6BSmArw4wVGM6lIOIjq+4+Al0AbqZtf7aj+
	wnhmWr//usj8BcLQ==
X-Google-Smtp-Source: AGHT+IHfeyGrGpwMqWoTs+cMnz/MczOHJOsC4r/AMbo9203NvJbVmY/Eapb7Daq4cxr8/D95b08pGA==
X-Received: by 2002:a05:690c:744a:b0:719:3e4f:60f7 with SMTP id 00721157ae682-719b42b63eemr43234707b3.26.1753282014299;
        Wed, 23 Jul 2025 07:46:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:46:53 -0700 (PDT)
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
Subject: [PATCH v2 00/32] Live Update Orchestrator
Date: Wed, 23 Jul 2025 14:46:13 +0000
Message-ID: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B13640017
X-Stat-Signature: jw3e7134sy5qjifpy1phs1gnzgp1oj8m
X-HE-Tag: 1753282015-117502
X-HE-Meta: U2FsdGVkX1+Td1+QLrHITEwmrArvpH7NYIXiG1kP6gfyFqP0pU6+0QA+Il03+IX/xXvph1O0JSsxm6ytonhSiAvoVUmrnDpTtuS1veji3FxAm+HCelSIn2TqmDgaksYlXBpFcUiKT/NrQbDwZsws4fIh9LzboPKsFXuQQeMc55VEv6o96cn9HpuXnwzLdZAWupQg3oUP4BOCRUACA/KiJV46RDMwDSroAOoOPeeZs5xY+FiO0hde/T3v5SBFu/8WHtqjxprucQ8l7spS3LLz9BD0dkziUI1LQkyqG8RoiGNpOEtDpUMTZ1b4Cyw1P1688Kouj/6f30H7gm7qWClguT6snldTrCdshr4KZO2JyY4TdORZBI9tSyT1AIylL6w1U1hf5Hi1Ak0JDjV6lrGBMvVuSnE2ovn7CFFiLdLFYI7zOfDFdkCwJz2czVQ+IOEUkrdNwlvQGPrE6y7Kf/dcBNZ4W8ZiWCW+RKobWPUQQYOL3b0rLA5dE7ciG0HmqEkofJDwS0wzdSsdgegEqDxvSxpUU/ouWDZXT/ECLaGWj1HgTKSsC7eWXmlEpYh3BMgS04PrZr+4J0MAMM7dWv/DQFMWdUv6q+oU5fyJ6Oo+nKXOscLtN+8AEToba+xQWy6pqHv151pXJC6Qea5nQtJyvk4Yqpk1fDC/G3KXBXYjd1xCLhaxM7k9qVFvuz2kpHxBAP4LWw5TE9ShhIqYZsIIBpg1HZ0rmoSJ6tAwYJbQqbqQYieZZ/r27EFZl5WmsAhEBd7i1DEUBZ0YId9XJ1fttakwAcy01K2EfTBdfKS9DxIeWp7mhjhU9J36jotTuEsi8GSI/iZZgsFhHpcBDJuQIkmebHiB5hzVJNzSxFeiof/lOixHVXkWV7yIU5z2nbUPvu6B+Eep2FubeL+ZaNP5V3p1w6JZ3DUDpfPBwDiMTdaamhzLsY595PC2JH3ZII1Cx7msUDMI5I6obONnYby
 kuMzJJIW
 BhVzl7ck5rMZU0VO1RU8COP7u1aWOJJg0UYaqrzq/iv3w0jH7wow2RxQF+lJHLwdR0KXnHj7HeIe9M+dvu9ooJFr56T3igcckO6lfMhOQvkMvlI/J9wbjUU3vBhbzaXfZXXbvS4YCNs+9Q6i5pIAhnlCxq7BKcWbpiMZfy+0dG9uUbVohZR30QtDAQutzgsAmLbEdtmqdofK8s5AL4t+RImZ9bIL2fOg9n9oVPsia6noJmCsqPr5irkVMuLvDjXTMyzTarKwUng2oEGmKKC7zyPsBchqJGJyhIXBAaNRDbMMGWxNN0a2baug8ZQydlmcWU082+5AcqKf8rOiSg8S6lVEJ4vyi83qWkQ+bOfCKwPaHOF2Sf0t6JRB5qp/0z9RLQSLUdVqcc+t7nERNPkTD1hKqQ4h2C57S9wLod0ux+REdWPrrVCJuO3kA2uwxYHLRJXFyO2v9QwjSwkvaOGnM0dK53Ty99dHtO+ElW7wgALsKGx7YW75ZsGg0nHQfkHOCdo3TfCwn/5Yu7GpoqlieJzAFE9gRHmitH5ss
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

https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v2

Changelog from v1:
- Addressed comments from Randy Dunlap
- Fix from Pratyush Yadav for missing vm_flags update
- v1 submission had mail-server issue, hopefully it is resolved in v2.

Changelog from rfc-v2:
- Addressed review comments from Mike Rapoport, Pratyush Yadav,
  David Matlack
- Moved everything under kernel/liveupdate including KHO.
- Added a number fixes to KHO that were discovered.
- luo_files is not a registred as a subsystem.
- Added sessions support to preserved files.
- Added support for memfd (Pratyush Yadav)
- Added libluo (proposed as RFC) (Pratyush Yadav)
- Removed notifiers from KHO (Mike Rapoport)

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

v1: https://lore.kernel.org/all/20250625231838.1897085-1-pasha.tatashin@soleen.com
RFC v2: https://lore.kernel.org/all/20250515182322.117840-1-pasha.tatashin@soleen.com
RFC v1: https://lore.kernel.org/all/20250320024011.2995837-1-pasha.tatashin@soleen.com

Changyuan Lyu (1):
  kho: add interfaces to unpreserve folios and physical memory ranges

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (22):
  kho: init new_physxa->phys_bits to fix lockdep
  kho: mm: Don't allow deferred struct page with KHO
  kho: warn if KHO is disabled due to an error
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  liveupdate: luo_core: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  liveupdate: luo_subsystems: add subsystem registration
  liveupdate: luo_subsystems: implement subsystem callbacks
  liveupdate: luo_files: add infrastructure for FDs
  liveupdate: luo_files: implement file systems callbacks
  liveupdate: luo_ioctl: add ioctl interface
  liveupdate: luo_sysfs: add sysfs state monitoring
  reboot: call liveupdate_reboot() before kexec
  liveupdate: luo_files: luo_ioctl: session-based file descriptor
    tracking
  kho: move kho debugfs directory to liveupdate
  liveupdate: add selftests for subsystems un/registration
  selftests/liveupdate: add subsystem/state tests
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry

Pratyush Yadav (8):
  mm: shmem: use SHMEM_F_* flags instead of VM_* flags
  mm: shmem: allow freezing inode mapping
  mm: shmem: export some functions to internal.h
  luo: allow preserving memfd
  docs: add documentation for memfd preservation via LUO
  tools: introduce libluo
  libluo: introduce luoctl
  libluo: add tests

 .../ABI/testing/sysfs-kernel-liveupdate       |  51 +
 Documentation/admin-guide/index.rst           |   1 +
 Documentation/admin-guide/liveupdate.rst      |  16 +
 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/kho/concepts.rst       |   2 +-
 Documentation/core-api/liveupdate.rst         |  57 ++
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/memfd_preservation.rst       | 138 +++
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  25 +
 MAINTAINERS                                   |  20 +-
 include/linux/kexec_handover.h                |  53 +-
 include/linux/liveupdate.h                    | 235 +++++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 265 +++++
 init/Kconfig                                  |   2 +
 kernel/Kconfig.kexec                          |  14 -
 kernel/Makefile                               |   2 +-
 kernel/liveupdate/Kconfig                     |  90 ++
 kernel/liveupdate/Makefile                    |  13 +
 kernel/{ => liveupdate}/kexec_handover.c      | 556 +++++-----
 kernel/liveupdate/kexec_handover_debug.c      | 222 ++++
 kernel/liveupdate/kexec_handover_internal.h   |  45 +
 kernel/liveupdate/luo_core.c                  | 525 ++++++++++
 kernel/liveupdate/luo_files.c                 | 946 ++++++++++++++++++
 kernel/liveupdate/luo_internal.h              |  47 +
 kernel/liveupdate/luo_ioctl.c                 | 192 ++++
 kernel/liveupdate/luo_selftests.c             | 344 +++++++
 kernel/liveupdate/luo_selftests.h             |  84 ++
 kernel/liveupdate/luo_subsystems.c            | 420 ++++++++
 kernel/liveupdate/luo_sysfs.c                 |  92 ++
 kernel/reboot.c                               |   4 +
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memblock.c                                 |  56 +-
 mm/memfd_luo.c                                | 501 ++++++++++
 mm/shmem.c                                    |  52 +-
 tools/lib/luo/LICENSE                         | 165 +++
 tools/lib/luo/Makefile                        |  45 +
 tools/lib/luo/README.md                       | 166 +++
 tools/lib/luo/cli/.gitignore                  |   1 +
 tools/lib/luo/cli/Makefile                    |  18 +
 tools/lib/luo/cli/luoctl.c                    | 178 ++++
 tools/lib/luo/include/libluo.h                | 128 +++
 tools/lib/luo/include/liveupdate.h            | 265 +++++
 tools/lib/luo/libluo.c                        | 203 ++++
 tools/lib/luo/tests/.gitignore                |   1 +
 tools/lib/luo/tests/Makefile                  |  18 +
 tools/lib/luo/tests/test.c                    | 848 ++++++++++++++++
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   7 +
 tools/testing/selftests/liveupdate/config     |   6 +
 .../testing/selftests/liveupdate/liveupdate.c | 356 +++++++
 55 files changed, 7095 insertions(+), 417 deletions(-)
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
 create mode 100644 tools/lib/luo/LICENSE
 create mode 100644 tools/lib/luo/Makefile
 create mode 100644 tools/lib/luo/README.md
 create mode 100644 tools/lib/luo/cli/.gitignore
 create mode 100644 tools/lib/luo/cli/Makefile
 create mode 100644 tools/lib/luo/cli/luoctl.c
 create mode 100644 tools/lib/luo/include/libluo.h
 create mode 100644 tools/lib/luo/include/liveupdate.h
 create mode 100644 tools/lib/luo/libluo.c
 create mode 100644 tools/lib/luo/tests/.gitignore
 create mode 100644 tools/lib/luo/tests/Makefile
 create mode 100644 tools/lib/luo/tests/test.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

-- 
2.50.0.727.gbf7dc18ff4-goog


