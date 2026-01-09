Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6C4D232C6
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 00:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D2F6B0092; Thu,  8 Jan 2026 19:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35276B0095; Thu,  8 Jan 2026 19:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6326B0092; Thu,  8 Jan 2026 19:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9276B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:11:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6742B13A6A1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:38 +0000 (UTC)
X-FDA: 84310496676.12.BA3296D
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D04140007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4DB89sEa;
	spf=pass (imf17.hostedemail.com: domain of 3t0dgaQgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3t0dgaQgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767917496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKgMKBT5OFHokoCGrW4c5BW1nZH0a8FU1Tg2IfU9qt0=;
	b=s+UCbD11FtWUDehVONwcggiy2x8HNVTukgjf9AauZGATuCtIlXy3TlKrQqkVvXGF7E7r+z
	FmNfpg38vFtY2/83OAqy3JOVj+rPrFlK4i6uToLW6zVbh4ccs1JVlIKn0aGTzdr7Xmm/sP
	2BK8QR2UH2i8kh7Tya0Gr/cAS/eqNtk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4DB89sEa;
	spf=pass (imf17.hostedemail.com: domain of 3t0dgaQgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3t0dgaQgKCBo90IEDC8K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767917496; a=rsa-sha256;
	cv=none;
	b=wxBYQQHlXCDvJcDA+VlOSyIy6FMxaGumxjpNOFKi5BO112Wsh21BsYc9I2J4J9ozdTrZeu
	LxBLGjbTyg2LBFT0ukfWQHHcsnNyCslDSPTLtbCpWITIBNlhRRri0YDRTvY3S6eixkghFw
	LA4l/PPJUiAPXKssTEXP+Xtkq4Bwzmo=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b04f8c5e84so3498353eec.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 16:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767917495; x=1768522295; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKgMKBT5OFHokoCGrW4c5BW1nZH0a8FU1Tg2IfU9qt0=;
        b=4DB89sEaj8dGFNWb8/1LbjFtjRTEWAcEDBmYmHKTaeNBcIIj4hoyRBXi+F8SmXP71J
         Whw1soQKAqbR5df3J4abhtBClkP89CxM7ehmf8LgbfmYXqQYHtZzzDU9yfUA1KZP1Cgm
         m1CgZKMk3B+MSUmApXrlSSmO6EdR151uLpjLdho6BQ6Hyo24mI/7wE3p33p8rVEXstfD
         claDLR/JUwU8YLxQG6FgPxCqa4Q+KZxEakgY3WKzXjxq28XrEGJ0Jzu7OEguQGQQ5Mz9
         efaoEpNmAP+eLOhD3Y0Ea8n1FR0HszacjNJ9WuUeRyI1gktHhv/R+n4J/0Z35LZzCoub
         lXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767917495; x=1768522295;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKgMKBT5OFHokoCGrW4c5BW1nZH0a8FU1Tg2IfU9qt0=;
        b=Immmf/S/kegxdl2bhm8dStTrZfSfg74ahDaJepPUpWK6+tEQOlMn4tbf16UI0B+Qld
         b/HSEbz1r980EKTdy+qQtYqFXhaU4mxtAmeYIP1wALact4eE+o9CmKWV6OzA3TtQxSBb
         1RvaLQ4vg+xCXMhZxKWan8epHfDhNXhDHwlSCDp96vq/rzghfA+cr0UWSXAB5WFxWEvN
         4w4Xfcs7dBinLhkCXUmg9ZW1BH/ZHEhNDp+YXkC6MJxKEZIPWr+j4KyHvcl1J1JhSSj/
         4Eo2RzKV/Qxo7kF+BkccrTN+i+iQAmFPmQD21cFvK6Z1GiTTp7VGTFqDdoWpfZNwvSWI
         bHTw==
X-Forwarded-Encrypted: i=1; AJvYcCUdsqMpjn0uQO60PmJkdgzzmsG3Ni3gS3M70IDs3kqckjJQq65RkPV5bMowx7K15RPlw+9/GdW5rQ==@kvack.org
X-Gm-Message-State: AOJu0YwNdvdSkgD612ky6tfKfpFUIRr+/uN6Ebgk0swkaCXOFxXJCIUg
	mNRV2Egg4wnZz7GwUk6MQ7U5LfGFLRJjxJIqDAsmikb7cHJ2SUzPhdzBSnJvOlDeVabraevUDz6
	Fdt7Fz8a3hJOYqg==
X-Google-Smtp-Source: AGHT+IEFOtcW4jk0aXhAffgAIqkI0UKGPAV2Ujq35QNsvPluSbvTyZRl2dRJINPWfimpz9fDoX9MuIGSXj0PtA==
X-Received: from dlbdx12.prod.google.com ([2002:a05:7022:e0c:b0:11d:cc5a:2cd0])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:985:b0:11b:99a2:9082 with SMTP id a92af1059eb24-121f8adcfe2mr5422835c88.15.1767917495328;
 Thu, 08 Jan 2026 16:11:35 -0800 (PST)
Date: Thu,  8 Jan 2026 16:11:27 -0800
In-Reply-To: <20260109001127.2596222-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260109001127.2596222-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109001127.2596222-3-jasonmiu@google.com>
Subject: [PATCH v4 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9D04140007
X-Stat-Signature: ma1ysibjcm4qeu5pk7c583g33agna6a3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767917496-194681
X-HE-Meta: U2FsdGVkX1+McuJTM2uucQV1YjuGxjMKBwxmjRK/S5+1nzVRFDz700wMF+s99xJdK66Y6Y2gXxs5UDS9Y9I4JQiqfSvAFqINp7/MlRZbzhOIMCCCG/mRztdgzGx5+ePTovg+/3IrEzJqxmcpMw7tojVoywNBVd0A1l0ae5gVt4W+HVU65hTCNnb6bROGdnasmmR8DxSjKU1h4kat9bRrFbXQoz3+Bi8V39RnVoZUNmyjOjFGyLLHg0o0C+8CJafQKfz0LHHJXsJlbzS8G+76V1AElw2H0JsRKQI1HpbPnC6AFKoJUYQ4cOvpJ9ll3lKPf+RPiw8tEDCpUHJmtq6d9ewM0KheG1XIqHe7xj47/DBSvjQdlNWM7u0QfvHqF810Mt7ghTsL60Tfy4jkUaSoTI+0OLwUTzVgFWd++EKWB5ZrMOXuZapQd/V0CTrri59zX/oXSw4C/DUs9zKjbBm+TZee2wT2eYHlnEio6/ZFRYphFFImw2Tnho70qazm4sBQFy+btWp6WQfGjT0KF1Y0cEmICDY5joqo8DQvMA6DsZfBJaXT2WSPxNL4IOd3cVk52y9bCz949sYtRFfu9f3rznCGv9Ev4keW4AYHvOT9Zs+93mUC2FGhKKY9R1OfBmKR5gCzg2uXiApQog1TqvZiwbDnDMiIBwY9KrfEtB8Y64nb99vYEWiGOFe1MpTfctVtsbOOBQyVG+IAqMzv5HV9tDLrT1Uww3BMK5jjdJPNm16x9fplDjd1Gu7QUKl3mahOtYRI8sI/bpmLPspVGeJMdgtu7h3akeh0bFHk+pJQpICCBwufnPU9lNURpDzEGpM1xTAvh7l/sMj5mJTf+cpBb9Ptr1Dwe27S7bAGpmX0yqWB541QzoKbHvdZqV3f2TJUgj6RgvcG82ft9TxbkTl9lwGg7sEbsMLHULkOjSPrS/HylO2i+vWoQkj1dlFiinNCWJQim4imKJJ/Njm7pxS
 DT6Sa06L
 whIo9AJcWGRY5iIma6z4DftylsBumKOAcLXrpy2pgwWItyzD8jilMeOLjMwzwnufTrQ2jCs//OF8cIa/DBTq/ZSc/XlOTuh3PzlxNO6jn+wE3b0ogN10PD6cuXguLlEVpZ8lFjAoR807kX4Mt73ePfx1pmfZI6s8JdwfhyVRUJ1vh1K7xPpeepbl6jvLBd5cIIHB3bA9FqiPUykb/oHVulpNQ2TomSo5Zrm4Wm41G1qMBURu5EJw3wHcYkshrjc6XY4GJtWeC+Df4ePSudJtKgMHUTk58WNDQSaaXI152nl0Fua6eHqEYpeqvaRuOoGd6w9TKngLxYDgSTnEyEu3TwEscwEc0hf2gADWBvZKmETOzGI3ER8q+AJBAQ5tpOlTPtUtJHkSEQUp3mQ6Y/icp+tFwbW6Ejr3ZOsPafbjyKAjcm2v80nYi/4QVpZkj1KTcx9c3sTSx3GAi6ecD4wWkR97p9Lf4z+d+uJ7RAHQ57p1O+6UQG0E2YADc8OxqdtwDd41rGjhSsCjJfRJrrA9UWne6RB5mqgCpjIm43s0xXNk1xRu9i9BU3IvT3A==
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
 Documentation/admin-guide/mm/kho.rst        | 52 ++++-----------------
 Documentation/core-api/kho/index.rst        | 17 ++-----
 kernel/liveupdate/kexec_handover.c          | 21 +--------
 kernel/liveupdate/kexec_handover_debugfs.c  | 23 ---------
 kernel/liveupdate/kexec_handover_internal.h |  3 --
 kernel/liveupdate/luo_core.c                | 12 +----
 kernel/liveupdate/luo_flb.c                 |  2 +-
 tools/testing/selftests/kho/init.c          | 20 --------
 8 files changed, 16 insertions(+), 134 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b886..57d5690dce77 100644
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
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 7ddc4d3ecac5..286a6d0b9956 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -9,8 +9,9 @@ Kexec Handover Subsystem
 Overview
 ========
 
-Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
-regions, which could contain serialized system states, across kexec.
+Kexec HandOver (KHO) is a mechanism that allows Linux to preserve
+memory regions, containing kernel data structures in their live,
+in-memory format, across kexec.
 
 KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
 the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
@@ -71,18 +72,6 @@ for boot memory allocations and as target memory for kexec blobs, some parts
 of that memory region may be reserved. These reservations are irrelevant for
 the next KHO, because kexec can overwrite even the original kernel.
 
-KHO finalization phase
-======================
-
-.. _kho-finalization-phase:
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
index 440f6de65eb2..8d9cf939790c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -69,8 +69,7 @@ early_param("kho", kho_parse_enable);
 
 struct kho_out {
 	void *fdt;
-	bool finalized;
-	struct mutex lock; /* protects KHO FDT finalization */
+	struct mutex lock; /* protects KHO FDT */
 
 	struct kho_radix_tree radix_tree;
 	struct kho_debugfs dbg;
@@ -81,7 +80,6 @@ static struct kho_out kho_out = {
 	.radix_tree = {
 		.lock = __MUTEX_INITIALIZER(kho_out.radix_tree.lock),
 	},
-	.finalized = false,
 };
 
 /**
@@ -1191,23 +1189,6 @@ void kho_restore_free(void *mem)
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
index 7a9ef16b37d8..2df798e07668 100644
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
index 4c437de5c0b0..ddc9110a2b45 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -630,7 +630,7 @@ int __init luo_flb_setup_incoming(void *fdt_in)
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
2.52.0.457.g6b5491de43-goog


