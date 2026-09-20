Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FD4C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7952E6B00AE; Sun, 20 Sep 2026 15:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CAA6B00AF; Sun, 20 Sep 2026 15:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B166B00B0; Sun, 20 Sep 2026 15:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 313986B00AE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C56F804B8
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:21 +0000 (UTC)
X-FDA: 85235152002.19.BBF3874
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id CFFE140004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="TCSP/E5V";
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJieeIgM+cp8bkpFe8Ny3KapR5wdIQZOgEecLTuA7iY=;
	b=kMoDTa/WviRJ+eo/eAq4q58JBkF9/I4ci8wCp/c0TkNF1YLzdPnfDhrVPm9EFFbPW24mqy
	qzYmrSGYrKbz+MK34hfGchCItafiAoB7I8BF6MlQNFvGZe9ARQenBgy/4RBXfWCqz4eMJ+
	oJSJeLeqpnBo5hzn4dLYj1gcCt1PwmE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="TCSP/E5V";
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933099;
	b=u7HK7kP+2NJ/Sa98PaGM/N/X9jPlumMn1BhJiNi//Uy4+DciJSJTOjRmmCyJY4oZthFmP1
	SEEFC1JD7yr0aEHDhwpgel4uU+GZK+uItSozigEA6hi5Pj1WifM94wTyVFz1MnBPP7j0j0
	bP8nyC4nwLeir6wCHZXgrgQanOX99AA=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf31683so18035777b3.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933099; x=1790537899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WJieeIgM+cp8bkpFe8Ny3KapR5wdIQZOgEecLTuA7iY=;
        b=TCSP/E5V2wcSzlfbYFb03MMP5gXLsUMb89BeoYmikyVU6TJ3la/hRmQF624CSeafAO
         odOyz0ZnxL7H+HzjNBIlcG/RvgMGtXqDUjGE4/96htWZvpHrddU/dz7/+tc6ZMoA29Mn
         Ap/EaWlvvgo92oNfqQIU15RVJ/HrmUIc5vHaQDXCLejygZkiCBKd16YTZq0iEMgEJCOr
         uvWzQvaRo1Ee5Q1wMv81eMqQoTNYTxEZeKpD2wpWLLq8CUeSAxxCdu7+pK9yPf+Gjy7l
         WNv3Kqi+OTq5O/xRQOt6W96Q1FVlgdvFjYmdV67sukyl8B1U1I2foHKQeRnS3cFlN7+u
         iwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933099; x=1790537899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WJieeIgM+cp8bkpFe8Ny3KapR5wdIQZOgEecLTuA7iY=;
        b=qdPZ15EXQo9NmlyBxXG6m2ixoKHBrZwrOc/EpFpzTfvIkxgJzjMrMY3vpEg+pSs58A
         p0eNzMnTTWvQvXJexJZrnATJDsn9eLQ1g06g4g/sJhTzl4zdjNzJ4pC+wSK5X5Z4IbA+
         3xMpCT7FAPAZFO/9xiN/19mzLaSRxNY7JvIg83xQll9xbEpMMxHzlAkUTfi5GsgnnkHL
         nzkuj191WkivWOIG2qXN+TMZ3xyut8HlY3V2Wxy1gGXe3ZoRDxjBErwyYuFnS2HLdcgx
         sWwC7z95vFiMu75qKzHFYW5h1g4ZC8DLD8KbaUsqnIXEDewhpGu+n0cuEfSReMFf7ppw
         o+bQ==
X-Forwarded-Encrypted: i=1; AKwUvBzuTcVGYDWRd09xIRzdFfg1R4gKcYY1cbAPNer4YZtrfNX4Sj+evenIOd5QTWOvLy8sOB5A1jEu/Q==@kvack.org
X-Gm-Message-State: AFuF++licmByR4q78vYBDcabEIG5oueVtM8IylOwhok+qeXdMrscGUgn
	Kjp+ccm9ld2H04f3y/YZ8tSCALdH4Jv2seQGBYkFGQFAHH+cFoVBXWdjIfaGKnN13KQ=
X-Gm-Gg: AYBFou0S8OnaA30OtZkXujmOYqfGJBedRiODsnMK2sO8HaVQTXido1aDSEC+xmBc/im
	dgMCcj5dFIs0bM3lYBSgYqRU/xpphxBHT0Sb3eP4d+Uqdp2mUFRB+Wrm1Q6fQPmPr4ux1aLUrk1
	NKyogwkf53kEb08BaUgAt82qR4Ukhsrb4upl77NCHuvgTeC4s6wVCaE8+nRr/0lCDJQbc3FayCK
	vANq0muHeV4A+YbUIV2ZAAbO927zxUQAvR+ybdDA+YnQQW58tUsscbNjZApYuCHdjwcZycBHuaA
	olWe9uROSw0IG80QXClUwl1jm6cs3HleJydUUSl0ZgJBZV/wYPryiupGVSmX1XReUMD9NFv5+Aq
	TrDDs/QwH0aVaIvVIfyC3/UR7JGY1USvosOva61g4SBOTE91YXk/2YtpsHEqxYpLAUIghycwizK
	eIPRUzQEPSj9nUstLmjeDAA7BLy/GeyLYB2MRbC0jU8eEyoC5w5VVgMaEka91suCOQsL3aqlfZE
	xLt6hrwClI/DkmEvscSZfxZgoss+B1aDPJtqY3A/RkHFSJCIp6SiSyQc0GgTBQ3wf4JWbWtvIYM
	vxD95AWlF2Z76Jiym6YdHp+xtKPxmg==
X-Received: by 2002:a05:690c:ec4:b0:873:5c6b:a2fb with SMTP id 00721157ae682-897363672acmr24218447b3.41.1789933098791;
        Sun, 20 Sep 2026 12:38:18 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a415208bfsm19238877b3.3.2026.09.20.12.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:18 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 14/46] cpu_preserve: Add core physical CPU preservation state and park loop
Date: Sun, 20 Sep 2026 15:36:18 -0400
Message-ID: <20260920193650.3373435-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFFE140004
X-Stat-Signature: qt968d4x93gyy75ha1jm7b7n4o6cxrko
X-Rspam-User: 
X-HE-Tag: 1789933099-121292
X-HE-Meta: U2FsdGVkX1/aIOlLqkZ5047mtAqdsQTjD813MGvkeslhEjUbe2QXLcn35kquasvbxaSSqGKh2RDVuqgUfAg18EnA/xn8qvhvxy2FFRPDpc0qWcbwQtSJMYShuaJYRAq1XOE0G1+8pIT9/K0v9wa0KCy72zk2qb02NxSqxIYYYFIM+gYMmAD7+BAR8dVTC5hBjeIqUMMb0X5kn+MtGLOni+j2uonXBHPAYX51hrmw1N+aAzyzaku1n+RDqyfxDAeKeFzSA5FnZ1vwJERg867t9zlSstQXcwN8/nWtL7tS2zkNFWaYtJOWNgh83/9ne5r7Ocem5ZyS79ZPUfZWDnRWv7nCATTZ65SZYwLuJGeWybWXLmzAHtj32NZWgg4MW160tLmJknDhLe6iTUkYegMj/qiFP+h6PjqUO9wfyHeFOmmyVyvTsXYaqQuwUFQ8VFhLBl28lzJvLgwoYyccaLFKrqZHCgi72w8f/31ibf9FuY1y+mUfP8Crr7i+Au6X8gmuWB5CzR4R9ucIJB6nwiAC3whF/ZaByXeAXCpKAdHOwuh/pVwWKYyg4yzs0cFKst7/NT4U3zCCCIweUkNJOrtMViwhPOGbrqXf0/IcFHesfEREDh6hE5dTtq8uH4s0GE5M5EpESVppGy1ukB29hmhBSPFxwp4cwYFO+49ewgLykR7GLenS5CCiYvDa9dZxvY+IDHFGvYt32OHZ/Xd232uQUFReOpJdQ3yiTBdKMWOypVfo2nxN+iDsyTLEzkCq8iD07SdL7JrXXTI9xcD0eNWN2yRJIZm8KW28d1C6scYF/KsM/Q2eX0NY3rdhx9lBIYVNZrjszfPglBscwG41D23+ZvAcw2GcvBP8FcvAODMacsvPr6EJQNWSEbmU1pGSO/C0bkN5yOn+Lj1ws8PJ0TNxzuqPBQfbR/BQMDjoLwAALDRVFESCgkJ957yomyPZYYx1l7PvhdZ1NKEnq3TAAS6
 lfNCnBJ/
 eWJdVhJlGIM+KNswHgKzAwPLiwDL9ZH5Sj6ZWqayYOo3giMtH9FnzCvGIvbniXH9xmxkSRVpHxmmF6SlFbpg3dcGJxqyG106EUI88IEtUA4Dc32fNDv+6WhamR7HGahXeW50s+JvyR8APOukdQ03Tz7rJ8r+5b1h5LHqqYpnasKWbxsRAiJYSQX0nC27Exq3R8vcz/tb/GC8+48YIqANydavzzdZG+Imkw6Qy3P/udgJndtmxx63vMyhrTcIx1FNOQMM8UqMxva9x8efNV0z1HuUNpovxlmopb8QFnYN+ViIpyZhl22/ODsL5ihTt/mZigoa37JashUJIt5Uk4L5E28QQwU/l+QqTLmSLkIbkGXo7G6WRKq9uzrYOBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the physical CPU preservation state tracking, cache maintenance
wrappers, and standalone park execution loop in
kernel/liveupdate/cpu_preserve.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/cpu_preserve.c | 249 +++++++++++++++++++++++++++++++
 1 file changed, 249 insertions(+)
 create mode 100644 kernel/liveupdate/cpu_preserve.c

diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
new file mode 100644
index 000000000000..e19208670c3e
--- /dev/null
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Preserved CPU Subsystem
+ *
+ * Live Update allows updating the host kernel while preserving the state of
+ * hardware resources across the transition. While memfd-based memory
+ * preservation is supported via LUO and PCI device preservation is handled
+ * by VFIO and IOMMU, physical CPU cores represent another fundamental class
+ * of hardware resource that requires preservation.
+ *
+ * A primary motivation is preserving virtual machine (VM) workloads across
+ * host kernel updates without pausing the guest. By separating a physical
+ * core from standard host scheduling and keeping it active across the kexec
+ * reboot, guest vCPUs or dedicated bare-metal tasks can continue
+ * uninterrupted execution on-core.
+ *
+ * This subsystem provides the generic, hypervisor-agnostic foundation for
+ * physical CPU preservation.
+ *
+ * Lifecycle
+ * =========
+ *
+ * CPU lifecycle state progression::
+ *
+ *     +-------------------------------------------------------------+
+ *     |                          ONLINE                             |
+ *     |               (Normal host task scheduling)                 |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | preserve (via LUO fd)
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                     PRESERVED_PARKED                        |
+ *     |          (Removed from scheduler, loops in park)            |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | [Live Update: kexec]
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                     INCOMING PRESERVED                      |
+ *     |         (Parked on-core, skipped in secondary boot)         |
+ *     |       (State restored upon session retrieve; stays running) |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | unpreserve / finish (via LUO session)
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                          OFFLINE                            |
+ *     |            (Park loop exited, architecturally idle)         |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | automatic add_cpu()
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                          ONLINE                             |
+ *     |                (Rejoined host scheduling)                   |
+ *     +-------------------------------------------------------------+
+ *
+ * File Descriptor Binding
+ * =======================
+ *
+ * 1. **Sysfs control file:** Each hotpluggable CPU exports a read-only sysfs
+ *    attribute at ``/sys/devices/system/cpu/cpu<N>/preserve``. The file
+ *    descriptor of this file handles the lifecycle of the preserved CPU.
+ *
+ * 2. **Preservation via LUO:** Userspace opens this file and registers the fd
+ *    with LUO. Preserving the file offlines the core from host scheduling,
+ *    migrates its interrupts and tasks, and transitions the CPU from online
+ *    into the parked state (cpu_preserved_park()). Preservation integrates with
+ *    the On-Core framework (oncore_session_add_cpu()).
+ *
+ * 3. **KHO and memory preservation:** The parking loop, dedicated preserved
+ *    CPU stacks, runtime execution buffers outside Scratch memory, and
+ *    preserved CPU state reside in memory preserved across kexec via KHO.
+ *
+ * 4. **Incoming boot:** During early boot, the incoming kernel restores the
+ *    preserved CPU mask from the KHO FLB before secondary SMP bringup and
+ *    skips bringing preserved cores online, maintaining isolation.
+ *
+ * 5. **Retrieval and unpreservation:** When userspace retrieves the session in
+ *    the incoming kernel, it receives the open ``preserve`` file descriptor.
+ *    Retrieving the session reconnects the descriptors and restores on-core session
+ *    state while keeping the core running. Finalizing the session (``finish``)
+ *    or closing the fd unpreserves the CPU, signaling the core to exit the
+ *    parking loop and automatically restoring it online via add_cpu().
+ *
+ * Architecture Requirements
+ * =========================
+ *
+ * In addition to CPU hotplug (``CONFIG_HOTPLUG_CPU``), an architecture
+ * selecting ``ARCH_SUPPORTS_LIVEUPDATE_CPU`` must provide:
+ *
+ * - **Linker script:** Include ``CPU_PRESERVED_TEXT`` in
+ *   ``arch/<arch>/kernel/vmlinux.lds.S`` within the executable text section.
+ *
+ * - **Preserved text section:** Functions executed by a parked core or during
+ *   live update transitions must be annotated with ``__cpu_preserved_text`` so
+ *   their instructions reside in the KHO-preserved ``.text.cpu_preserved``
+ *   section. These are the ``arch_cpu_preserved_*()`` hooks documented in
+ *   ``include/linux/cpu_preserve.h``.
+ *
+ * - **Address-space mapping hooks:** arch_cpu_preserved_as_map(),
+ *   arch_cpu_preserved_as_flush_tlb(), and
+ *   arch_cpu_preserved_set_transition_as() populate and manage isolated page
+ *   tables built by the core layer using cpu_preserved_as_alloc_page().
+ *
+ * - **Buffer relocation hook:** arch_cpu_preserved_setup_buffer() relocates
+ *   preserved text and data sections outside KHO Scratch memory so the
+ *   incoming kernel can unpack safely.
+ *
+ * - **CPU hotplug and stop-IPI isolation:** Exclude preserved CPUs from stop
+ *   signals (NMI or stop IPIs in the machine reboot and crash paths), and
+ *   avoid tearing down local interrupt controllers (LAPIC, GIC CPU interface)
+ *   during CPU disable when the core is being preserved.
+ *
+ * Isolated Address Space
+ * ======================
+ *
+ * A preserved core does not run on the kernel's own page tables. Before it is
+ * handed over, the core layer builds a transition page table
+ * (cpu_preserved_as_create()) containing only what on-core execution needs,
+ * so that a core still running a workload cannot touch memory the new kernel
+ * has taken ownership of:
+ *
+ * - Preserved text and read-only data, ``PAGE_KERNEL_ROX``
+ *   (``__cpu_preserved_text``) -- park loops, world-switch routines, ops
+ *   vector tables, and exception stubs;
+ * - Preserved writable globals, ``PAGE_KERNEL`` NX
+ *   (``__cpu_preserved_data``) -- state machines, session descriptors,
+ *   per-CPU control blocks, and the preserved-CPU masks;
+ * - The per-CPU dedicated preserved stack, ``PAGE_KERNEL`` NX;
+ * - The KHO-preserved workload state pages, ``PAGE_KERNEL`` NX;
+ * - Hardware control MMIO, ``PAGE_KERNEL_IO``, only where the interrupt
+ *   controller still requires it (e.g., GICv3 in system-register mode needs
+ *   none).
+ *
+ * Deliberately absent: the linear direct map, all user address ranges, the
+ * kernel heap, vmalloc, modules, and BPF JIT. Guest memory is not mapped
+ * either -- it is reached through stage-2 translation.
+ *
+ * On arm64 these mappings are built with trans_pgd_map_range(), on x86 with
+ * the identity-map helpers in ``arch/x86/mm/ident_map.c``. Custom workload
+ * address spaces can also be created and adopted across kexec via
+ * cpu_preserved_as_adopt().
+ *
+ * Workload Integration
+ * ====================
+ *
+ * Physical cores preserved across live update execute payloads managed by the
+ * On-Core execution framework. CPU preservation integrates directly with On-Core
+ * session lifecycle:
+ *
+ * - On-Core assigns jobs to preserved cores via cpu_preserved_attach_workload().
+ * - When a CPU file is preserved or unpreserved, oncore_session_add_cpu() and
+ *   oncore_session_remove_cpu() update the session CPU bitmap.
+ * - At kexec handover, oncore_session_get_ser() serializes the session state into
+ *   the preserved CPU file descriptor, and oncore_session_restore() reconstructs
+ *   the session in the incoming kernel.
+ */
+
+#define pr_fmt(fmt) "cpu_preserve: " fmt
+
+#include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/device/bus.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/cpu.h>
+#include <linux/kho_block.h>
+#include <linux/liveupdate.h>
+#include <linux/mm.h>
+#include <linux/objtool.h>
+#include <linux/reboot.h>
+
+#include <asm/sections.h>
+
+/**
+ * struct cpu_preserved_pcpu - Per-CPU host runtime state for CPU preservation
+ * @stack_pa: Physical address of the preserved stack for this CPU.
+ * @pgd_pa: Page table root PA for the preserved CPU context.
+ * @entry_fn: Workload callback function executed repeatedly on the physical
+ *            core while parked in cpu_preserved_park().
+ * @entry_data: Opaque argument passed to @entry_fn.
+ *
+ * Tracks host runtime state for a preserved physical core. Allocated locally
+ * in host memory; not preserved across kexec handover.
+ */
+struct cpu_preserved_pcpu {
+	phys_addr_t stack_pa;
+	phys_addr_t pgd_pa;
+	void (*entry_fn)(void *data) ____cacheline_aligned;
+	void *entry_data;
+};
+
+/*
+ * struct cpu_preserved_state - Host-side preserved CPU state (incoming or outgoing)
+ * @mask: Mask of preserved CPUs.
+ * @pcpus: Host runtime state array.
+ * @pcpus_ser: Per-CPU mailbox array in preserved memory.
+ */
+struct cpu_preserved_state {
+	cpumask_t mask;
+	struct cpu_preserved_pcpu *pcpus;
+	struct cpu_preserved_pcpu_ser *pcpus_ser;
+};
+
+static DEFINE_MUTEX(cpu_preserved_lock);
+static struct cpu_preserved_state cpu_preserved_incoming;
+static struct cpu_preserved_state cpu_preserved_outgoing;
+static cpumask_t cpu_preserved_mask __cpu_preserved_data;
+static struct cpu_preserved_pcpu_ser *cpu_preserved_pcpus_va __cpu_preserved_data;
+static struct cpu_preserved_pcpu *cpu_preserved_host_pcpus_va __cpu_preserved_data;
+static struct cpu_preserved_global_ser *cpu_preserved_global_ser;
+
+static struct page *cpu_preserved_text_pages;
+static unsigned int cpu_preserved_text_order;
+static struct page *cpu_preserved_data_pages;
+static unsigned int cpu_preserved_data_order;
+static bool cpu_preserved_runtime_preserved;
+
+/*
+ * Address spaces are mapped into under @cpu_preserved_as_map_lock and
+ * enumerated under @cpu_preserved_as_list_lock.  cpu_preserved_map_range()
+ * holds the list lock across the map lock; nothing takes them the other way
+ * round.
+ */
+static DEFINE_MUTEX(cpu_preserved_as_list_lock);
+static DEFINE_MUTEX(cpu_preserved_as_map_lock);
+static LIST_HEAD(cpu_preserved_as_list);
+static struct cpu_preserved_as *cpu_preserved_transition_as;
+
+static phys_addr_t cpu_preserved_get_text_pa(void)
+{
+	return cpu_preserved_text_pages ? page_to_phys(cpu_preserved_text_pages) : 0;
+}
+
+static phys_addr_t cpu_preserved_get_data_pa(void)
+{
+	return cpu_preserved_data_pages ? page_to_phys(cpu_preserved_data_pages) : 0;
+}
+
-- 
2.55.0.1082.g2b9226bbc0-goog


