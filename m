Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCF0D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4646B0095; Mon,  8 Dec 2025 01:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562D26B0099; Mon,  8 Dec 2025 01:35:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DED56B009B; Mon,  8 Dec 2025 01:35:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2236B0095
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:35:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D92CD5BCA2
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:32 +0000 (UTC)
X-FDA: 84195342504.22.C242B5E
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1531720006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="BE9DLZ/4";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sXE2aQgKCL4newsrqmyksskpi.gsqpmry1-qqozego.svk@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sXE2aQgKCL4newsrqmyksskpi.gsqpmry1-qqozego.svk@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175731; a=rsa-sha256;
	cv=none;
	b=WW9UVYnNusYwgFsw1LWKSQ57IlhBppjXTWgGla4eIwNSsqCwj/lCRrd6mDePaHCSs/8qAy
	+tyS+QfUGwkCVx1WvESL8nGE3EFsSC3qGWf5/M2yZpIvl3HC0vQb31NHzQCRuPnvOa0pB/
	4suwFvcGXt0/rtkeqAih6uT9O7czCvY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="BE9DLZ/4";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sXE2aQgKCL4newsrqmyksskpi.gsqpmry1-qqozego.svk@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sXE2aQgKCL4newsrqmyksskpi.gsqpmry1-qqozego.svk@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
	b=2ydgw1+o/SHVMVJ5g7fDZ7SMkNhb07i7uTwS8OJSzILU8AJE5Pe/dknU9ZhtC1l7dDnRwI
	pK+zSaw/SPi5DhGTXs7LtILM5NTcWL0H3dLIqFbmxIXi74tR3S/5oFIrbJhYPFUGAfNiAY
	nKzqJ63/CxPeI+mAqfUILudnhKUjbco=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737e673so5298540a12.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765175730; x=1765780530; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
        b=BE9DLZ/4SA8tYP4kLPl8l/5UjwHZgnv9Xa3oLbWCZp57lUO2gfLhgsw3ERUQFPOSKj
         S2xsNALmvA3LyqNrKv0shKycoBoCj6tsnnJbBAQTmHA5eALREee+3T22sgYDAnthIyKL
         YhFSWqelPBWxi3jQrFYXsE7/+kryTgIAGobFYy1k7TgetkFnQ3JXLJGNgm2skuEADP8F
         cMPLDgGcK+a6bVbQeayAgr5FMJVD6Lu3hx8eHGgcenodzFfyKp+OX7BlY61j3xi6Iq9b
         Q2QIWmY8ZCiySGKSMEMQUgCKxZLZcwSANYkbZOK2uc7nxfxyM3nmiIVeDyXdmORSar75
         2dYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765175730; x=1765780530;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
        b=LiYsY1XH+k9oLQ3X26xlrsZFIfSjwGhLRrXj4rnmJJTZCxg8pP3hVpzj7xE+xsM03l
         hUYjCX5J3cUBBuKbvU318SHz+0+5afXdpPkr3RXcA2Metae1Mz9WM5SqN71xPfDjaBr/
         WXOcRaMzcEmQNvDnxYdOtnFE/VGQ/wLC6Bqxz4zDKGtvIHxSzI9HH+tK9WJBzbfBPcXe
         822t7s/yaxk+B7OmFbVpJjh9tABYQy6S4BaOEwb94uHj+mPG7dH/ixH70Zd6yw3MIcJK
         AOCmDKICyAOHuHBXnf2SOd2EgvVdbzUsXQQ/BYEYCUckI2g6ceNCKeWP7GgrOGxE0MQV
         UfGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZwWluVZ+zzMXQ4IAA5h1T9NDKLgAZxZdnRxlPCw+ow6MbF7n4QTbq3Npf+1UCfrd/LPQkllGevQ==@kvack.org
X-Gm-Message-State: AOJu0YzNAxuMGZhAV6AS0U/8N/QAjrN0t62ZfOkEurFlYRJMysGwK9V4
	Ti8OlFbNShHQ3gjsMJoUBUIOHWuWAbK4xnH6KxecstJ3D2Ovr5DT2XCUUsOBTWYGRy8uGHmD625
	8GyJLyNoDKIu+lg==
X-Google-Smtp-Source: AGHT+IFMU7AuW4YSMGBBVS7LMeWXqgqOlXfXkmhWt8KWVMRO66QTJ5hB8/bvb8GxcMq3/EW/k0GLaCk1evDr4Q==
X-Received: from dybia15.prod.google.com ([2002:a05:7301:30f:b0:2ab:cd21:c657])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:d40d:b0:2a4:3593:c7cc with SMTP id 5a478bee46e88-2abc712e394mr3049842eec.12.1765175729835;
 Sun, 07 Dec 2025 22:35:29 -0800 (PST)
Date: Sun,  7 Dec 2025 22:35:13 -0800
In-Reply-To: <20251208063513.3633942-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251208063513.3633942-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208063513.3633942-5-jasonmiu@google.com>
Subject: [PATCH 4/4] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1531720006
X-Stat-Signature: n8tw7dcnfsa4g1pzbjf31tbbbzaz8un8
X-Rspam-User: 
X-HE-Tag: 1765175730-194033
X-HE-Meta: U2FsdGVkX1+nmEU/PVO94VIZQqM2WTexm6tlu2nTMxmHMpN/qILPHwa2jPqwi+xjlLVXlXyRKS67g3Kraw04y0gNXmXoCrf1TQOpWSRJ9tjNuMVS/9L6gkEo9bLK8IQnG4VLGxcEAFe9m2rRWihQFd7OSUyXvh/LWGBYwTDRsy0Pwfoz9KGQec8Dkpj0v1Ff8U7Ek1lRfcrUshZ6tHHvvUUcygJcenasGiFLVdDlILmMcmbhqGPineNK+Q5A1pfvoLoyT0d4JAIpqV++xE9zW2Ib2nH8BFBpA/Gyp6RcaayhadT3QBA3gmrka9MPGnLySo9DtJYMhGYdeCrSFEPD5EQK7Z1EkQhHunlMYYOTtJue9/l2W8ljomUqmO5NghHJ8pU7gIllQFra0u3ZXlhUXbZWO4JTL8fn8bvdbZLATgG6tU9qUMwxt+OOb4iNLSvuX1FoNkZS67GkLhd/uUDqTssEuZAGb0l6yUfckivBoafyCqEoqgtx0uFq2DG6r4UfBVOoi7LHsRAPnm7o9yKrr0g0cJ4zBS+AMvhNU8Bu8sj62TEoJ6m6a39Wb651HblX3WPzUio8u0z4GQbcplj00YdRc9IIBzqfHFhP6VLLoRQ/g9GAjHAsZDelyDHxSCH5huH2tHuXnV6c0Pe8m8UhM1nr670+SdDvVTMLKTuJXu4l7qtedCEzYYCuwiZ6Q3TVJyKEft4ckzDnPFWuSL/FCQS3/97k9ydzuI7ks0UAf/2KBfEZGK8Ylhc3baUBulHKfHg6oKH4GzVaoBf4i/V8oL/fcrOjqt7I2MN4Ta5YmHZ+DCyVf0TpTUFPe15V7UuMY+2cYP8fKC9PXjq+Cmyh7g/AV7roOUxBIImSmdu3SmFlf9oiPgMlVLboKMNZXTcws9IsQGVwNz4vAb+C4Ldn6P19uuXBzaz7qoOUjlsZlfRQE4hP7+vF5TRXgnu2DKLuVvO5pwG45zB7rQhMfpD
 6xDyWJJs
 oHFSv8GBGv9H8Lbg8wLZGVxnNREckQTdJITooUPEntw9P2c4EpLvo3NZps+zjbxY9iYNX4V/xflOUqlPuo0kIVMwjiVle1DqpKhJuwoMUMlM7bde9yYd4roKqvIMf6j/LIfE8LPLn+TpiPUQuvo7LadKwNMLbn+ufUjx2kpSz+c93xJyeMmQN/fj9D5i3M8r1oGObH74+Jn/OQnStI+yj3aeXlKrxhx7RU4Oj3jlxN8OUfvATeyLlbw6iQCCRcwWB3wWogjFfwlchUT8dUFc2WfRjRpRlOF3UDB5PamoPRHANJvuff8ttKeHaGqZzVTbhJYzUlSnj+Kb/f+vz7WalpuMinVdXkIYS5pjnGVoQynPWMXTruQLchm5a//c3PvFE430bnCxXdpGMBINEnGhy71XOAtGLUp+gjDXOcm1j70xgHw43teKeDohWZQcsQe/win15yfDuZH+Lf1uht95yHMOvOEXmWZHhgwVHqV4AO6jSY2CgpuY9DmMSpeHWND3Uj7hzbPGR8r2nBnB7dLLL59IPBdg65xEhqEd0XTnIBveKWksMyabHLv2bNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eliminate the `kho_finalize()` function and its associated state from
the KHO subsystem. The transition to a radix tree for memory tracking
makes the explicit "finalize" state and its serialization step
obsolete.

Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
implementations. Update KHO client code and the debugfs interface to
no longer call or depend on the `kho_finalize()` mechanism.

Complete the move towards a stateless KHO, simplifying the overall
design by removing unnecessary state management.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 Documentation/admin-guide/mm/kho.rst        | 46 ++++-----------------
 Documentation/core-api/kho/concepts.rst     | 13 +-----
 kernel/liveupdate/kexec_handover.c          | 10 -----
 kernel/liveupdate/kexec_handover_debugfs.c  | 20 ---------
 kernel/liveupdate/kexec_handover_internal.h |  3 --
 kernel/liveupdate/luo_core.c                | 12 +-----
 kernel/liveupdate/luo_flb.c                 |  2 +-
 tools/testing/selftests/kho/init.c          | 20 ---------
 8 files changed, 10 insertions(+), 116 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b886..13910bc68efe 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -28,17 +28,7 @@ per NUMA node scratch regions on boot.
 Perform a KHO kexec
 ===================
 
-First, before you perform a KHO kexec, you need to move the system into
-the :ref:`KHO finalization phase <kho-finalization-phase>` ::
-
-  $ echo 1 > /sys/kernel/debug/kho/out/finalize
-
-After this command, the KHO FDT is available in
-``/sys/kernel/debug/kho/out/fdt``. Other subsystems may also register
-their own preserved sub FDTs under
-``/sys/kernel/debug/kho/out/sub_fdts/``.
-
-Next, load the target payload and kexec into it. It is important that you
+To perform a KHO kexec, load the target payload and kexec into it. It is important that you
 use the ``-s`` parameter to use the in-kernel kexec file loader, as user
 space kexec tooling currently has no support for KHO with the user space
 based file loader ::
@@ -52,40 +42,19 @@ For example, if you used ``reserve_mem`` command line parameter to create
 an early memory reservation, the new kernel will have that memory at the
 same physical address as the old kernel.
 
-Abort a KHO exec
-================
-
-You can move the system out of KHO finalization phase again by calling ::
-
-  $ echo 0 > /sys/kernel/debug/kho/out/active
-
-After this command, the KHO FDT is no longer available in
-``/sys/kernel/debug/kho/out/fdt``.
-
 debugfs Interfaces
 ==================
 
+These debugfs interfaces are available when the kernel is compiled with
+``CONFIG_KEXEC_HANDOVER_DEBUGFS`` set to y.
+
 Currently KHO creates the following debugfs interfaces. Notice that these
 interfaces may change in the future. They will be moved to sysfs once KHO is
 stabilized.
 
-``/sys/kernel/debug/kho/out/finalize``
-    Kexec HandOver (KHO) allows Linux to transition the state of
-    compatible drivers into the next kexec'ed kernel. To do so,
-    device drivers will instruct KHO to preserve memory regions,
-    which could contain serialized kernel state.
-    While the state is serialized, they are unable to perform
-    any modifications to state that was serialized, such as
-    handed over memory allocations.
-
-    When this file contains "1", the system is in the transition
-    state. When contains "0", it is not. To switch between the
-    two states, echo the respective number into this file.
-
 ``/sys/kernel/debug/kho/out/fdt``
-    When KHO state tree is finalized, the kernel exposes the
-    flattened device tree blob that carries its current KHO
-    state in this file. Kexec user space tooling can use this
+    The kernel exposes the flattened device tree blob that carries its
+    current KHO state in this file. Kexec user space tooling can use this
     as input file for the KHO payload image.
 
 ``/sys/kernel/debug/kho/out/scratch_len``
@@ -100,8 +69,7 @@ stabilized.
     it should place its payload images.
 
 ``/sys/kernel/debug/kho/out/sub_fdts/``
-    In the KHO finalization phase, KHO producers register their own
-    FDT blob under this directory.
+    KHO producers can register their own FDT blob under this directory.
 
 ``/sys/kernel/debug/kho/in/fdt``
     When the kernel was booted with Kexec HandOver (KHO),
diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
index d38bcaa951e4..0ac01760db18 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ b/Documentation/core-api/kho/concepts.rst
@@ -6,7 +6,7 @@ Kexec Handover Concepts
 =======================
 
 Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
-regions, which could contain serialized system states, across kexec.
+regions, containing kernel data structures in their live, in-memory format, across kexec.
 
 It introduces multiple concepts:
 
@@ -56,17 +56,6 @@ for boot memory allocations and as target memory for kexec blobs, some parts
 of that memory region may be reserved. These reservations are irrelevant for
 the next KHO, because kexec can overwrite even the original kernel.
 
-.. _kho-finalization-phase:
-
-KHO finalization phase
-======================
-
-To enable user space based kexec file loader, the kernel needs to be able to
-provide the FDT that describes the current kernel's state before
-performing the actual kexec. The process of generating that FDT is
-called serialization. When the FDT is generated, some properties
-of the system may become immutable because they are already written down
-in the FDT. That state is called the KHO finalization phase.
 
 Public API
 ==========
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 81bac82c8672..92b052450ce4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1212,16 +1212,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-int kho_finalize(void)
-{
-	return 0;
-}
-
-bool kho_finalized(void)
-{
-	return false;
-}
-
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 2abbf62ba942..2f70d9c41831 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -75,24 +75,6 @@ void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
 	}
 }
 
-static int kho_out_finalize_get(void *data, u64 *val)
-{
-	*val = kho_finalized();
-
-	return 0;
-}
-
-static int kho_out_finalize_set(void *data, u64 val)
-{
-	if (val)
-		return kho_finalize();
-	else
-		return -EINVAL;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
-			 kho_out_finalize_set, "%llu\n");
-
 static int scratch_phys_show(struct seq_file *m, void *v)
 {
 	for (int i = 0; i < kho_scratch_cnt; i++)
@@ -198,8 +180,6 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 	if (IS_ERR(f))
 		goto err_rmdir;
 
-	f = debugfs_create_file("finalize", 0600, dir, NULL,
-				&kho_out_finalize_fops);
 	if (IS_ERR(f))
 		goto err_rmdir;
 
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 0202c85ad14f..9a832a35254c 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -22,9 +22,6 @@ struct kho_debugfs {};
 extern struct kho_scratch *kho_scratch;
 extern unsigned int kho_scratch_cnt;
 
-bool kho_finalized(void);
-int kho_finalize(void);
-
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 69298d82f404..e4db15d81f89 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -231,17 +231,7 @@ int liveupdate_reboot(void)
 
 	luo_flb_serialize();
 
-	err = kho_finalize();
-	if (err) {
-		pr_err("kho_finalize failed %d\n", err);
-		/*
-		 * kho_finalize() may return libfdt errors, to aboid passing to
-		 * userspace unknown errors, change this to EAGAIN.
-		 */
-		err = -EAGAIN;
-	}
-
-	return err;
+	return 0;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index e80ac5b575ec..92d35eb5e6ee 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -632,7 +632,7 @@ int __init luo_flb_setup_incoming(void *fdt_in)
  * data handle, and the final reference count. This allows the new kernel to
  * find the appropriate handler and reconstruct the FLB's state.
  *
- * Context: Called from liveupdate_reboot() just before kho_finalize().
+ * Context: Called from liveupdate_reboot() just before return.
  */
 void luo_flb_serialize(void)
 {
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 6d9e91d55d68..88a41b6eba95 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -11,7 +11,6 @@
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-#define KHO_FINALIZE "/debugfs/kho/out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
@@ -22,22 +21,6 @@ static int mount_filesystems(void)
 	return mount("proc", "/proc", "proc", 0, NULL);
 }
 
-static int kho_enable(void)
-{
-	const char enable[] = "1";
-	int fd;
-
-	fd = open(KHO_FINALIZE, O_RDWR);
-	if (fd < 0)
-		return -1;
-
-	if (write(fd, enable, sizeof(enable)) != sizeof(enable))
-		return 1;
-
-	close(fd);
-	return 0;
-}
-
 static long kexec_file_load(int kernel_fd, int initrd_fd,
 			    unsigned long cmdline_len, const char *cmdline,
 			    unsigned long flags)
@@ -78,9 +61,6 @@ int main(int argc, char *argv[])
 	if (mount_filesystems())
 		goto err_reboot;
 
-	if (kho_enable())
-		goto err_reboot;
-
 	if (kexec_load())
 		goto err_reboot;
 
-- 
2.52.0.223.gf5cc29aaa4-goog


