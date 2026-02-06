Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063AEECD9B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8C16B0093; Thu,  5 Feb 2026 21:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFE06B0096; Thu,  5 Feb 2026 21:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AF36B0098; Thu,  5 Feb 2026 21:14:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A599F6B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:14:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AE0B1B2BCE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:14:38 +0000 (UTC)
X-FDA: 84412413036.15.0BBD8B9
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8172B4000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:14:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l6cOQ2qq;
	spf=pass (imf07.hostedemail.com: domain of 3i06FaQgKCJA3uC8762E08805y.w86527EH-664Fuw4.8B0@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3i06FaQgKCJA3uC8762E08805y.w86527EH-664Fuw4.8B0@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770344076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlidvMVPyGYjUTDy8RPNhG4pUvV+uC5PBA6dgmirYZQ=;
	b=ZgMlAjhdpIukEd4wNJYsqbl3c2R3kz9X24pVeTVkfImxfTYzOs5PBqfOUeKExCz5hVu0rN
	mLnKbMJjymmUg1gUOmeWLe+SvK00/AeUgvhRHg8ZI1a1K9s7vZMqxF5Nt7gQ3QTkIvbVDT
	Ul6Gn8wYSIdXGMrq8AqWiVdnIKW62Gs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l6cOQ2qq;
	spf=pass (imf07.hostedemail.com: domain of 3i06FaQgKCJA3uC8762E08805y.w86527EH-664Fuw4.8B0@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3i06FaQgKCJA3uC8762E08805y.w86527EH-664Fuw4.8B0@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770344076; a=rsa-sha256;
	cv=none;
	b=zkP2woMGgu2cLGtsViQOk7nU0hcILZSuARBmPb1fKVPK+e02Ee6ASZ7W86IxXEgWjf9URv
	QInH9Ef3kZCpsmrPXR67og8DLyT7yzRrCdLXG4Z1hJb5TA+ys+duKMUcBTUfhMqbCheR+x
	mVkM01Pznfw1UZgZ7f5NcoG7Elw9eQM=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-124aa710af7so3760601c88.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 18:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770344075; x=1770948875; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlidvMVPyGYjUTDy8RPNhG4pUvV+uC5PBA6dgmirYZQ=;
        b=l6cOQ2qqVoHkXUT8ZbEul/Cu4VBh3TVW53NxFXqdIV+Q8X7F1Jt4cgC8Bjn8HbzBGu
         sSUuR7BPIJNSItvrHdMHaoBpE+xyvGeF8fgJubHWKeXL+b/w0hqcLUSTC3qsiZgpXGwW
         q1me5tTA2HMeK65FM7Aryg9kMX4lVs8LI3X9KXHhaN22YSHd6gakNd6ce/amMFuTEARC
         EymYLrf2o+HLVAtygdR8LldzuRk3zL0YgRv5JcF7gyLUDffeClXOfFqeQaK8ulmv2Ql9
         3wh1Pd2VGpSCeA2FIZih6EC7JkfAROHCd/45qVtIDD0m2BQwNoVCgMkJs5SeCBCuG0qE
         tXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770344075; x=1770948875;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlidvMVPyGYjUTDy8RPNhG4pUvV+uC5PBA6dgmirYZQ=;
        b=IiVR8JKBxQ7pzv7dM2WIx8LMBwwMP+HUPgujQYYTHYXW3QsaJdxWYuzttDkuHgO04K
         dbPWl1F3LM3moABACYr0aHpdPebQl+TH4CTZhRF8eVnIErO5Yc62c1tB8MaL2QF6UKZj
         z5DZLf7Bac99L2UwjrSOTDKMNmsQwfTmLC4RMxZOAfht0Jl/hlsVJ9yhe2+L+y9w7Qeq
         PYVj2Mp/jjfJvOQ7BMOCSwJ0D13St+i5lvpe+xXcoHycsHVS3u3uaW/ThkoxWpfnC7VR
         aYyj6WlcXFLjWuj7Au0XMCdWoGE7rg05k37b68XhpNMxgtm13cvhm1iAUMnGOAqy0/DP
         jI6w==
X-Forwarded-Encrypted: i=1; AJvYcCW6JK23I2lgqUrrFJQVbPulKOapi+Sy01RTtBxRLRsTVYMQAHUF4Ae6gaMFx8Jr1taRays66Nz2BQ==@kvack.org
X-Gm-Message-State: AOJu0Yyeb9oR21WqxgpsiezL8dF82eu5uGKLT5xpkcE2sdE965ZqdVhQ
	qD75UOTxPkaG15wCpWSwoK3iTAD3YdhWcZjQQ5Xtugf5G86zLjBHbIGB5IrsBNE6sOPdd3AC/9J
	Q4cgF2xx0Sw/sBg==
X-Received: from dykh9.prod.google.com ([2002:a05:7300:5709:b0:2b7:75b:cf5a])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:dc0b:b0:2b8:26b8:3444 with SMTP id 5a478bee46e88-2b856482b73mr508138eec.19.1770344075153;
 Thu, 05 Feb 2026 18:14:35 -0800 (PST)
Date: Thu,  5 Feb 2026 18:14:28 -0800
In-Reply-To: <20260206021428.3386442-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260206021428.3386442-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260206021428.3386442-3-jasonmiu@google.com>
Subject: [PATCH v9 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8172B4000E
X-Stat-Signature: ehxdkcww146cnzk1adz96f8ypyodhspi
X-Rspam-User: 
X-HE-Tag: 1770344076-733721
X-HE-Meta: U2FsdGVkX1/T6BpIOx/89er3nwLVKt0wt6ktEGS1fUvi1Z6EwikvDi0MdT9yJAWMVu3qv2O8dFcgkQY+rU4luduM+UTOd8j4PQyB3XQiiwLGpr3IhNsJesKy4h0NhN/++oVZMvb9rLw0rd/DWeAO9yFRt9yiNhrOW/LNBxztdcTQ8EFdqnmLgxshaNzYoi/PPNxZWiidlnr9e1v3jTJVM4ipqCu7RCTNs1KxuifL/HPt6zv0b1W9/Oi6623PQiBq4FdKLhxENxayZN6x2y79niEFmUG+uQukeK0VQTFvtjVZwdLpdnwDwEUCBsOKAhnU0X5HuNN5/nnq5QQ+ciEV5Kh3eFlml0Pvf6R0F5b8FV+/Pp6A31YWegrOM9FB8eeuoNXYlis0cOl/WikiJ++w+LDw13zyP/sgBLHu5RoZxJqUGmq+Y8imCnw1Z7OifZkRDaEGtShD1JEkd/w8BEJ6A5L1PMeibdShhJPKBH5ySQ82kW5QM5QTJrJiUz92tE9UkwVmf2h3J0QTZbIto9W+T3DoFSONWfEcDx5XqNqlEgILO92bMlcQOqr1XjncE1I1L0l6TkN9enfpyJ31ZqTINymCxELpZqHQfrtoIh6XV5CU9SMWQ+kXch9I0pmkfskbx2d1XoxBlil4c8hDKc/WaEh4Ra+NYELIyGaPDZ1CdC4dlsn4qsad2yU0D3xTPz6PpWlwqE1gCrDd2HZEmcuOnSJvnDJ0qv2WUTFVKZviwCSIxjfF1qrOe5RMd3OGKEr51VEtKO1xnkNoJ0SDrx8ugfrS4nHUQ12T2NXc+yI4Vhrb6LlnNa3mTLl8DmXPDOG3hXON1SFcuBeronEa4WboMw3H/CqFkWcbiEXWoK4lWK1TbzAM2nisrTyrL04gy+QgvCk+aG2A1AevimRRYi2Fvt1Lz4W4z+hJc+uN7FEA23iC/R461EujkUWazvF0Af5qeEy/nPdltEdyVVmAE3M
 uoIha7zP
 s6wlVR3SrmgYfLCSyMb4hVhxbtoWGyOcWgxyQyZuBKax2EATzyWSQjFWxIu06Ok6AqIlZQLEgcXNPCT2+57Yuu1ZAd3948wD1coAWGhFTJ7es+Q5WMwF95+xETWeuoWutU6A5rRjBPmBV2B7t/Ae9csexF7L3S6UrhOpS2q/jioH+v1ZrGdt5nzfk8HWf10xoizPSDyLe3ocbwcWIk8AOl0PLUoXPo39QuJXYInmvvmYpVwSsx3ZkmmE2kHCin3U/pMu4LfOGE+w7Y4J1SsPMey6a9hH0jtvYBE7s8R26HkTdK5slOo9DJW4NZysLaPJH5p8vGWIbCQDvRiOhARCyLdIr4BFSytAM8pDlAD+LGrcLvE3gnkpWk82ZWLC47DOek/zUE7FyjVwtnIugCsfO2Z6ZPWBG//kB02zLn1A829sNz+0WoeBF2Ry5EVFFW1MuJno5o8IUYBl/kshy358tCCY7/jC75yU9CUP+NPJYIIit4AG0t4tCxPsk8DB2YQjyC6/UER5YhN+J/5ASkEjKeHqWMRB5+lBtfK3DzIAOrZSY28pILr9MSG2BUsUJTulmaOeqbwDik8O+sSJG7sYn5vR246IWhaB45TTVVLvQQbapPcp1oTTFfY+zpiM1UJeSFMZB3s8PEbmi1m4=
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
 Documentation/admin-guide/mm/kho.rst        | 53 +++++----------------
 Documentation/core-api/kho/index.rst        | 12 -----
 kernel/liveupdate/kexec_handover.c          | 21 +-------
 kernel/liveupdate/kexec_handover_debugfs.c  | 23 ---------
 kernel/liveupdate/kexec_handover_internal.h |  3 --
 kernel/liveupdate/luo_core.c                | 12 +----
 tools/testing/selftests/kho/init.c          | 20 --------
 7 files changed, 13 insertions(+), 131 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b886..cb9a20f64920 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -28,20 +28,10 @@ per NUMA node scratch regions on boot.
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
-use the ``-s`` parameter to use the in-kernel kexec file loader, as user
-space kexec tooling currently has no support for KHO with the user space
-based file loader ::
+To perform a KHO kexec, load the target payload and kexec into it. It
+is important that you use the ``-s`` parameter to use the in-kernel
+kexec file loader, as user space kexec tooling currently has no
+support for KHO with the user space based file loader ::
 
   # kexec -l /path/to/bzImage --initrd /path/to/initrd -s
   # kexec -e
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
+``CONFIG_KEXEC_HANDOVER_DEBUGFS`` enabled.
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
@@ -100,8 +69,8 @@ stabilized.
     it should place its payload images.
 
 ``/sys/kernel/debug/kho/out/sub_fdts/``
-    In the KHO finalization phase, KHO producers register their own
-    FDT blob under this directory.
+    KHO producers can register their own FDT or another binary blob under
+    this directory.
 
 ``/sys/kernel/debug/kho/in/fdt``
     When the kernel was booted with Kexec HandOver (KHO),
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 002bdf0beb2e..0a2dee4f8e7d 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -71,18 +71,6 @@ for boot memory allocations and as target memory for kexec blobs, some parts
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
-
 Kexec Handover Radix Tree
 =========================
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2cf781a5cdc3..c09755a76d72 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -68,8 +68,7 @@ early_param("kho", kho_parse_enable);
 
 struct kho_out {
 	void *fdt;
-	bool finalized;
-	struct mutex lock; /* protects KHO FDT finalization */
+	struct mutex lock; /* protects KHO FDT */
 
 	struct kho_radix_tree radix_tree;
 	struct kho_debugfs dbg;
@@ -80,7 +79,6 @@ static struct kho_out kho_out = {
 	.radix_tree = {
 		.lock = __MUTEX_INITIALIZER(kho_out.radix_tree.lock),
 	},
-	.finalized = false,
 };
 
 /**
@@ -1244,23 +1242,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-int kho_finalize(void)
-{
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	kho_out.finalized = true;
-
-	return 0;
-}
-
-bool kho_finalized(void)
-{
-	guard(mutex)(&kho_out.lock);
-	return kho_out.finalized;
-}
-
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 2abbf62ba942..430c9521d59c 100644
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
@@ -198,11 +180,6 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 	if (IS_ERR(f))
 		goto err_rmdir;
 
-	f = debugfs_create_file("finalize", 0600, dir, NULL,
-				&kho_out_finalize_fops);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
 	dbg->dir = dir;
 	dbg->sub_fdt_dir = sub_fdt_dir;
 	return 0;
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
index dda7bb57d421..84ac728d63ba 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -230,17 +230,7 @@ int liveupdate_reboot(void)
 
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
2.53.0.rc2.204.g2597b5adb4-goog


