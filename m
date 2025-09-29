Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F55BCAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9048E0007; Sun, 28 Sep 2025 21:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99EC8E0001; Sun, 28 Sep 2025 21:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62208E0007; Sun, 28 Sep 2025 21:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA2688E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 716A11DDB12
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:34 +0000 (UTC)
X-FDA: 83940489948.17.4B94ED9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F582C0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FwyKdxBv;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vx2NUMjo1lV2HrEdGE9/MkxnCEs7/OOXznUHgDJat/A=;
	b=H8gEwZ8PaiMe76CgYRV9SkCvJA6inQyeTS2AVdDYonsdGnkJO+4LuGvuYl5kIksJURApMw
	42nulwvpxO5zvm/ynDbsy9NN5FpNUAzq6fb7MIOGJER1I7ClivEfA0Tb2n3d40RW6VRHlr
	eDOecXiO0sP4qT2j1rFjshUZ1pHFCiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FwyKdxBv;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107812; a=rsa-sha256;
	cv=none;
	b=h3lG+FgaLCXC2FpLVssWlUovyPAXrCjhMu1RG3wIqRbFyyC1p9NCDsRcaHAABsR0T1WnqK
	EgQvpumHHNzNeMaJ20LRMmYFfMi1GzNRA2++uEzzpP6SbEG/lJeATmwtjnQCtzLRhCNPDY
	cHtkyk4BZ0Lc2qXOHLYMMRQ1BWqQY/k=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4da7a3d0402so50066341cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107811; x=1759712611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx2NUMjo1lV2HrEdGE9/MkxnCEs7/OOXznUHgDJat/A=;
        b=FwyKdxBvoAKKLzBn7y6LWXKEUJ2CKTq16zpZj2qTGQmptEGtwI8ha4522GClKxSB+n
         dalXK6iyXdb4A/YxHHALEsq2TEXzmSDCbue/13oCvisJuruMMhMXUeW1lA4X8zaHv5ps
         /JYN0hlDVMJb5l9XzTYpj7eJc0CfYDI8bxkh6ACvYqxyo+V8fnX2Vd+/EoCo4VDlihyN
         lOo3hbYFCrwX7QhUzCQzfvZ6GXL8m2HPu95obVDcXVAfVsn5MSJmhMhkGLiA0EuflL1s
         N9ycXK7fdDRw0wt8n7y75foepwleY2+CbOy7nqvZlf/XX0CSOsMkW3/+LSER27XdJhmK
         /baQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107812; x=1759712612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx2NUMjo1lV2HrEdGE9/MkxnCEs7/OOXznUHgDJat/A=;
        b=U42v+xLT/9NbkIsOC2yD9UnfPA0BRXQGXZJgJnZyWh9nSDX0foGjV7MEGhpethH51r
         3uawnuT+ABMwq/TF7Af8sX5DwMf2rH7wzh7F5jBtpvWzaDOxjwL+4ItzE9RUr1azTfjx
         dJz6m6XRydbQM92PSYCEylYPjp30SAHsUE2r/f21sLlKwT6jjx0DutF+MoIDx8QqDTk8
         jTqtJFEdCsi4LRz1zhwNeVvPhBi/uY6cUu+EJ/+8j9h/bA261LxCQkcLBuaZZf96rvUm
         XVl//tAhcU72auAavvxeZ1Fc6ZkpUlHkaJ0ctuf4AmcNAu8WOaed7vyltyCSTgVeov7r
         mnCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh1Xrw1k2UsEKMPHURCwq1jbZwJA6uMj5SLmzQF2C7DUk6XKbcqTeOwaGxCwr4fCmGGKS7SqtcwQ==@kvack.org
X-Gm-Message-State: AOJu0YyG4PaTBmo16Yrt7mr6tHvzdyUrV/oj7fcv9KxOlQwDhKWY8t4D
	iDX9OaDgpQ8081VkBHnR3I3XoWAWOQVkfY55aq/J4rHjWsSLmwltxiL7oLPjX8Mkayk=
X-Gm-Gg: ASbGncvI5yPT7uyWpIoKFkUFJPSoQhmMB7dtJjrjnS6a/vt+9k9nWA7rOX1fudO8k5b
	rvN+fHE/Fc+/CvbfcY+lwVYZSD1sjU1GpmLHZ/kxt3C6deBxP2JWZHKXROy5qtSKw8DT0s9JMTr
	hAEct7Q/g2WbSoQApODzZ3b7quhX2Br98c8sDm/o6R0su9SUYeaSnhwh6nxp2uw84g0bNOKrGmO
	xPVX7QmaWRboMMx/++CGOEplS8so81xi2bs/bAgpvfelIPlBqEBlytRcqA7uR02vkbVg6cqFnj4
	zLQyexV4mwyxkN0yJ0r31YnD7fEL1oTqu3Yv7AqXprVcvL7GEpi9cFN7MouF+TVd7cSFVCCMy6P
	pwT6NtS0BnQdxOtMswje8jMlbxJpSQDpzIqwGnf9nYRY4N5N3eySxRM3EeMWcKDHfUsnH/T8xRP
	RY1wqAoANcuQPJR8hyhg==
X-Google-Smtp-Source: AGHT+IHvfQHKNIJph8GKuLGIcgL+56dTeKXQ7+SUATkT/idInZP7Lsbeg86nPFDUslPD6Un+9PFCAA==
X-Received: by 2002:a05:622a:2cd:b0:4b7:b15b:65e7 with SMTP id d75a77b69052e-4ded2c7eb63mr89972641cf.5.1759107811442;
        Sun, 28 Sep 2025 18:03:31 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:30 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 00/30] Live Update Orchestrator
Date: Mon, 29 Sep 2025 01:02:51 +0000
Message-ID: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F582C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pu3wn4o1zb9zdi5sf1aq3gnricbxr83s
X-HE-Tag: 1759107812-88888
X-HE-Meta: U2FsdGVkX19UyfzeMEYw+HO8AcccLxA7HWpDMU28+Dx6aII7wyHN+i/ybMIElIYxRGNcEbiHNsrPR4/8zcsjw6u6rBGpVvzm3pavirrr4TOi9kWsC8ggkGfVFiitrRqRScgPpkCUv2Lp1fmfBa12A5UOrtionE0ngxLloYCrRmKLfYbP+2DB6Jg/gQ5+7V60Z8LKTmBKjq5W7BiieTDdgwNF2TR2p69BoAQjr/ergyY9c4QVfvoNSNhGIYuykRrqYm3nRyT8WOKewi+A3Kpunmka6fss3ict6VB4Jf1b4KDBWEnwh1cvGdH1Pz+LKzxjFvfdco/FPEBaclgjYc9k+TaNfQUsSH9Nl7Qal6PyzLcnVDyqZ4m66YA6PHacss648wl9JLTktupWzHKyIwwXK52/pqE35gf9xBcBPHHyYyrJUcEhQeYVNplzWvaERbSX0sRwcqj3SLS0dnnRGwbHin30aTcuclAHBbdZor6Ez7VMKSyuXU7YNnieKkWW2nUUyU/fe6ffJ3yYqBWAUVyQ8G8P0t75LeFmos3wGSdO11PUKW+yVZ+eg0ANxjTQKw9Qjjv4c4hyRkOpxsTD0A0HJK5gaT6BuJnKSh5Xk+nOyL5uciuZkjHL45U9vqfyw95caS1C+scunlN+TOKuj42WKPf8hS5RNbiNzTshCYYUJxM7s/ZeDHsOJZNviomcaT07fuBFABLgkV2o1nGGQSHyh6clSRsXyj/SGbkaXbXDjDshI674muR5wE01dKFHkZdVbf9yFU6QEQr1tM5flPlIljC+heE3W2VnKsQa2sqiqd0VHhOx3QKPbb9fz+IL1Q+5ntKPSPvWto6WUugToknzOF1K5Cx+XuvG1QVipWNLHCvGRE4lWNv/RqZw9c1pv1xsymTA0W40w2dnFoh0h4Oprd9LfXGdKtCHuGxLdg7GKC7HBm1B15Pd09C6Auy+d7SsX0WrC45lzEKDd2r2xmL
 bqoKF0th
 /VoOeKQx2R7HvQ6mejXDAlkFFMTI0Vi6ChaF+C4srMfziM7UrREdt1QOKm3OWrNL0+6vuVCWk0nMCRfydyiJ1B7BrRjCYMviiuI4TmuH6F7QGW50O4Tdmuejsgmgf87QFDGrPJ+1JuH40gEu1QIU5oPDPnnC7wnMRMo5ncCPjYy2oDp3fdYA2c3EiyLny1scyRD2nq7oH4KvmoYAg3BJ2vLXXFaA/Cnh0TTbDfZFFA20hmcamL7AQ7KGzMQb810P/hf3wzmpEMXD0oGNN1VxLwWNnAw6RYC5XcDwkzpo4Xm4Agd08OiWfeMZw9g5CwDAyuxjoHRo7FR24fS5U/sb54EgNMvj9u/KyA+804lM4SWuFTXPCBpFGaOUbivOEzucF/MSCT2SkCsc2BgccvRuvtzwr25KYZtXzRKrwK4JAnNzZAnUnrMQt6DU7EtGdItG5rpowTL43CLnrPVJwXVvZ2zfHlTMWBGuu4aZ4F0OUInrZllIpBh2G6O+6O5L+iexbjT0RZEp2jJ0fVoL39lIx0pDkV6K52BKdAd1qzGptqj75Ra4PtYMzFDtH3+E+Coke2pDObWrkKwlFjiZZgYHcnwMPz1be0IKdz5JWZOYLoajZ0ZeHQIXdwglweRT+RaQ1ev4kLc7ZWQ629zOEPNbLqLZxexKvNgfLtwEDadvJHO8+/oUw/bFjqbziLHhHfymB8/IAuWzRXvApeQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the Live Update Orchestrator (LUO), a kernel
subsystem designed to facilitate live kernel updates. LUO enables
kexec-based reboots with minimal downtime, a critical capability for
cloud environments where hypervisors must be updated without disrupting
running virtual machines. By preserving the state of selected resources,
such as file descriptors and memory, LUO allows workloads to resume
seamlessly in the new kernel.

The git branch for this series can be found at:
https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v4

The patch series applies against linux-next tag: next-20250926

While this series is showed cased using memfd preservation. There are
works to preserve devices:
1. IOMMU: https://lore.kernel.org/all/20250928190624.3735830-16-skhawaja@google.com
2. PCI: https://lore.kernel.org/all/20250916-luo-pci-v2-0-c494053c3c08@kernel.org

=======================================================================
Changelog since v3:
(https://lore.kernel.org/all/20250807014442.3829950-1-pasha.tatashin@soleen.com):

- The main architectural change in this version is introduction of
  "sessions" to manage the lifecycle of preserved file descriptors.
  In v3, session management was left to a single userspace agent. This
  approach has been revised to improve robustness. Now, each session is
  represented by a file descriptor (/dev/liveupdate). The lifecycle of
  all preserved resources within a session is tied to this FD, ensuring
  automatic cleanup by the kernel if the controlling userspace agent
  crashes or exits unexpectedly.

- The first three KHO fixes from the previous series have been merged
  into Linus' tree.

- Various bug fixes and refactorings, including correcting memory
  unpreservation logic during a kho_abort() sequence.

- Addressing all comments from reviewers.

- Removing sysfs interface (/sys/kernel/liveupdate/state), the state
  can now be queried  only via ioctl() API.

=======================================================================

What is Live Update?

Live Update is a kexec-based reboot process where selected kernel
resources (memory, file descriptors, and eventually devices) are kept
operational or their state is preserved across a kernel transition. For
certain resources, DMA and interrupt activity might continue with
minimal interruption during the kernel reboot.

LUO provides a framework for coordinating live updates. It features:

State Machine
Manages the live update process through states: NORMAL, PREPARED,
FROZEN, UPDATED.

Session Management
==================
Userspace creates named sessions (driven by LUOD: Live Update
Orchestrator Daemon, see: https://tinyurl.com/luoddesign), each
represented by a file descriptor. Preserved resources are tied to a
session, and their lifecycle is managed by the session's FD, ensuring 
automatic cleanup if the controlling process exits unexpectedly.
Furthermore, sessions can be finished, prepared, and frozen
independently of the global LUO states. This granular control allows a
VMM to serialize and resume specific VMs as soon as their resources are
ready, without having to wait for all VMs to be prepared.

After a reboot, a central live update agent can retrieve a session
handle and pass it to the VMM process, which then restores its own file
descriptors. This ensures that resource allocations, such as cgroup
memory charges, are correctly accounted against the workload's cgroup
instead of the administrative agent's.

KHO Integration
===============
LUO programmatically drives KHO's finalization and abort sequences
(KHO may soon to become completely stateless, which will make KHO
interraction with LUO even simpler:
https://lore.kernel.org/all/20250917025019.1585041-1-jasonmiu@google.com)

KHO's debugfs interface is now optional, configured via
CONFIG_KEXEC_HANDOVER_DEBUG. LUO preserves its own metadata via KHO's
kho_add_subtree() and kho_preserve_phys() mechanisms.

Subsystem Participation
=======================
A callback API, liveupdate_register_subsystem(), allows kernel
subsystems (e.g., KVM, IOMMU, VFIO, PCI) to register handlers for LUO
events (PREPARE, FREEZE, FINISH, CANCEL) and persist a u64 payload via
the LUO FDT.

File Descriptor Preservation
============================
An infrastructure (liveupdate_register_file_handler, luo_preserve_file,
luo_retrieve_file) allows specific types of file descriptors (e.g.,
memfd, vfio) to be preserved and restored within a session. Handlers for
specific file types can be registered to manage their preservation,
storing a u64 payload in the LUO FDT.

Userspace Interface
===================
ioctl (/dev/liveupdate): The primary control interface for creating and
retrieving sessions, triggering global LUO state transitions (prepare,
finish, cancel), and managing preserved file descriptors within a
session.

sysfs (/sys/kernel/liveupdate/state)
A read-only interface for monitoring the current LUO state.

Selftests
=========
Includes kernel-side hooks and an extensive userspace selftest suite to
verify core LUO functionality, including subsystem registration, state
transitions, and complex multi-kexec session lifecycles.

LUO State Machine and Events
============================
NORMAL:   Default operational state.
PREPARED: Initial preparation complete after LIVEUPDATE_PREPARE event.
          Subsystems have saved initial state.
FROZEN:   Final "blackout window" state after LIVEUPDATE_FREEZE event,
          just before kexec. Workloads must be suspended.
UPDATED:  Next kernel has booted via live update, awaiting restoration
          and LIVEUPDATE_FINISH.

Events
LIVEUPDATE_PREPARE: Prepare for reboot, serialize state.
LIVEUPDATE_FREEZE:  Final opportunity to save state before kexec.
LIVEUPDATE_FINISH:  Post-reboot cleanup in the next kernel.
LIVEUPDATE_CANCEL:  Abort prepare or freeze, revert changes.

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (24):
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios and page ranes
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
  liveupdate: luo_core: integrate with KHO
  liveupdate: luo_subsystems: add subsystem registration
  liveupdate: luo_subsystems: implement subsystem callbacks
  liveupdate: luo_session: Add sessions support
  liveupdate: luo_ioctl: add user interface
  liveupdate: luo_file: implement file systems callbacks
  liveupdate: luo_session: Add ioctls for file preservation and state
    management
  reboot: call liveupdate_reboot() before kexec
  kho: move kho debugfs directory to liveupdate
  liveupdate: add selftests for subsystems un/registration
  selftests/liveupdate: add subsystem/state tests
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry
  selftests/liveupdate: Add multi-kexec session lifecycle test
  selftests/liveupdate: Add multi-file and unreclaimed file test
  selftests/liveupdate: Add multi-session workflow and state interaction
    test
  selftests/liveupdate: Add test for unreclaimed resource cleanup
  selftests/liveupdate: Add tests for per-session state and cancel
    cycles

Pratyush Yadav (5):
  mm: shmem: use SHMEM_F_* flags instead of VM_* flags
  mm: shmem: allow freezing inode mapping
  mm: shmem: export some functions to internal.h
  luo: allow preserving memfd
  docs: add documentation for memfd preservation via LUO

 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/kho/concepts.rst       |   2 +-
 Documentation/core-api/liveupdate.rst         |  64 ++
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/memfd_preservation.rst       | 138 +++
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  25 +
 MAINTAINERS                                   |  18 +-
 include/linux/kexec_handover.h                |  53 +-
 include/linux/liveupdate.h                    | 209 +++++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 460 +++++++++
 init/Kconfig                                  |   2 +
 kernel/Kconfig.kexec                          |  15 -
 kernel/Makefile                               |   2 +-
 kernel/liveupdate/Kconfig                     |  72 ++
 kernel/liveupdate/Makefile                    |  14 +
 kernel/{ => liveupdate}/kexec_handover.c      | 507 ++++------
 kernel/liveupdate/kexec_handover_debug.c      | 222 +++++
 kernel/liveupdate/kexec_handover_internal.h   |  45 +
 kernel/liveupdate/luo_core.c                  | 588 ++++++++++++
 kernel/liveupdate/luo_file.c                  | 599 ++++++++++++
 kernel/liveupdate/luo_internal.h              | 114 +++
 kernel/liveupdate/luo_ioctl.c                 | 255 +++++
 kernel/liveupdate/luo_selftests.c             | 345 +++++++
 kernel/liveupdate/luo_selftests.h             |  84 ++
 kernel/liveupdate/luo_session.c               | 887 ++++++++++++++++++
 kernel/liveupdate/luo_subsystems.c            | 452 +++++++++
 kernel/reboot.c                               |   4 +
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memblock.c                                 |  60 +-
 mm/memfd_luo.c                                | 523 +++++++++++
 mm/shmem.c                                    |  51 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   2 +
 tools/testing/selftests/liveupdate/Makefile   |  48 +
 tools/testing/selftests/liveupdate/config     |   6 +
 .../testing/selftests/liveupdate/do_kexec.sh  |   6 +
 .../testing/selftests/liveupdate/liveupdate.c | 404 ++++++++
 .../selftests/liveupdate/luo_multi_file.c     | 119 +++
 .../selftests/liveupdate/luo_multi_kexec.c    | 182 ++++
 .../selftests/liveupdate/luo_multi_session.c  | 155 +++
 .../selftests/liveupdate/luo_test_utils.c     | 241 +++++
 .../selftests/liveupdate/luo_test_utils.h     |  51 +
 .../selftests/liveupdate/luo_unreclaimed.c    | 107 +++
 47 files changed, 6757 insertions(+), 410 deletions(-)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (80%)
 create mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_file.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_ioctl.c
 create mode 100644 kernel/liveupdate/luo_selftests.c
 create mode 100644 kernel/liveupdate/luo_selftests.h
 create mode 100644 kernel/liveupdate/luo_session.c
 create mode 100644 kernel/liveupdate/luo_subsystems.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_file.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_kexec.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h
 create mode 100644 tools/testing/selftests/liveupdate/luo_unreclaimed.c

-- 
2.51.0.536.g15c5d4f767-goog


