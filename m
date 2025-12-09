Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D29DD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991996B000C; Mon,  8 Dec 2025 21:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969436B000D; Mon,  8 Dec 2025 21:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858C46B000E; Mon,  8 Dec 2025 21:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 738636B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:53:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA6D1403AD
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:33 +0000 (UTC)
X-FDA: 84198411906.08.18C2C72
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53547180006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0XLeKalX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Ko83aQgKCHceVnjihdpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Ko83aQgKCHceVnjihdpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765248811; a=rsa-sha256;
	cv=none;
	b=q2R12jn404IUn1zZiRjqFnA4BcHNWwplgPVL/H/jfNWVyAi9m5MBBOq3sO9kEU7onIzBNT
	ZWWDq62maFXWYIpdn9x2r4wWXeeCS8f8t2Wdu3l+jb9fpozcUw1Sks3Yj75dmzSJiE69d8
	x79qZ7amt6ZldPfePs0tVSKh6+OBTfY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0XLeKalX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Ko83aQgKCHceVnjihdpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Ko83aQgKCHceVnjihdpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765248811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
	b=tQfPMqFEvjKVMZ5QvRL85DRs+z6l/waZ4iXyfiTTL/Qvo3naJ1dynq73adkJ1gAZZEOE1t
	VQEO2KH3njFY2a23t7ylZ35DrLhccocOZN2C++FDx+kcAffdxsgf87hAbquFD2l7T3yOwm
	W2rzlIPLoPQU6KRKyn34jJW28yuFmHs=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso5999232a12.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 18:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765248810; x=1765853610; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
        b=0XLeKalX88X/pbjInqa/mKHUbgXzbUt3uXpToQotxw9tEfIPOqUxG96YcVL/Qc43U8
         L9zSjGg5/FylFkvRMk/ncrLmYFLq9egJtCEfWM2dbrPUWpiiBpeBlSlOhMcSlKeWbXDj
         5I42LTsycaHuzrBS5Z5WhtMeUef+KvS1B3hapg77p7l+CQnJOybQjIIwlC/SXx8dDQkQ
         psrZy78E5B2yQe4FRafkkOYzlO1fg+q7RFHbETXlSNFgUo5mFzbBje5vwbfwKnZGZ8KP
         2ynOHMrgyLQ7W5scD854k8uLNlMHWi83EhYJmd5q23+/9FRAbU8jJNLur0A67aLlyJyn
         29vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765248810; x=1765853610;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KshiYXV7msSpU9cl75Ojt3IGhY+gwGaRSdjYRirqx3s=;
        b=IcKgvlIZogc6cTYq+zz+jRZIwMikjc8WxsASQz5bExyFMCur97lFGfwnaL2gjmLD8F
         RESxScGbgJalPY+JEoS9k4FVOmcjucRk5LLfC+sscQr7LDmj1fGrxbqrb5BI6QGrI4sQ
         k73AlbLs26PYZNk22klMnhuj8vhCUDz+gSgKrfIHwQUnCF3D5IgYgpgF6IQA9OzBznJ0
         GaEV+SNmm2fxdhcRuUKeh2Mm/DRSjvASmNEIYTbQxoJTHBhKnFzsXgHXWKXCLYZjrOWo
         4Ar9e/5fRFxkVgc1I1nkSZTg7wVciucjhfiSuKvE3I/lRJdhnXgiuQf44Qd7DYAO5zN5
         HwOA==
X-Forwarded-Encrypted: i=1; AJvYcCWJVeKXmIPpp9pVDwdpd8qByG2TTm48EfBFskUS2T+sYzKcZEo45ClZX+807mMxIi7V5OZetkhZGg==@kvack.org
X-Gm-Message-State: AOJu0Ywt27bK2vL5yzA2yYHiL7OLSF64KVSslZjnYm6g3idNc8Sh3q8M
	tgcDngz4AD2jk57ceOXxTZEJGQb8AugSjfS+z2Cwjkdf7e6NgNs0nuH0vGmxbTtOUyKa/vqak6T
	A5hbCpxN6LXGvGw==
X-Google-Smtp-Source: AGHT+IFClP5phTsaQmpFtJ4A14CfMylc4B7SYp/2612GMMu8hUh6AsMjFy4WJ9S94iPvuBTuGOQmw234CmrEmA==
X-Received: from dybno7.prod.google.com ([2002:a05:7300:e607:b0:2a4:7587:4d39])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:4312:b0:2a4:3593:ddd9 with SMTP id 5a478bee46e88-2abc70f79c7mr7581649eec.6.1765248810012;
 Mon, 08 Dec 2025 18:53:30 -0800 (PST)
Date: Mon,  8 Dec 2025 18:53:16 -0800
In-Reply-To: <20251209025317.3846938-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251209025317.3846938-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251209025317.3846938-5-jasonmiu@google.com>
Subject: [PATCH v3 4/4] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53547180006
X-Stat-Signature: 3u5asy4zj711urw1n9be5ouyssbd69b6
X-Rspam-User: 
X-HE-Tag: 1765248811-36462
X-HE-Meta: U2FsdGVkX1/n6wJkW+Wv1WyICn/AkTHl32GfpMhjjZGbUoM6n+uDb0ic86UTg2B+xlBFPBjvfsq+Cr/AxgT15AE44xWatqJkOubOhvPckXPQL1rsWyYih6EckE8S9n/Mrf8MuC3+RXgb4jgIG0VGPO1JwKuGxobEUZmkebbOYHZoefax72Tm2BCb02kBHLd3AnyqsqctFZmM2GLzOXT6fWyt+ehbOuuyLikSwq+9T6Xb5P7Z3gl9PKLp7zG3hRs8+9NcCHDRFePpSTOG9v/HPVJrqaxEfumoNE9l49NP8GFLsUFWikZO9QqXlH9IbAN584lJiBNWOJLDC9nOJ1esAtWtrD1LtC3u/jHJDZZYhiD14ufBRhK6mCoH6exQDhPBzxSI7jwCA4NxLnnCkt6aq5Kwbvwina81cJCE6oSBtADnFCj/TVReviAZKoz3y8rF7Tu7FW5jlvH1db4Mf+9JekqprAIP1jhIpEpU20L/AG72LT4Owt6/cHbJPLuB2PJmMLqlW02dxFNOaRcTkDbF5S+s4X/y9t/gp7DwkZS/bee8W4mgt/EC9EqhGbU5agxYKc7qW7R9iZwIgyQSatmJpgrDEwEwVRl3tsroItBkaKCtsAtWYkEzt9DWOEXHDn7NUZ/d3QYtUBmZRNLfzBsR7wovbwW74Rxpu5BhixGBIWLJqs5M6CkCgrcMsOZM9MqozXqGUwVpq4N74iHMHuW9kP5F9zHV0fQDlD/Ud0PBrtzZB2t6BZ68cGJrsew0xxOxWhQKSK9+4dDfe4+ts5muXvS0HZk+0eFoWfV4/35XJl5tEJB5r4RHGdWBmCwCfo4IiXO+gQAUd9v0vgS8tEuw8hszhhUPaxn6iUSRHZLtpSt0yHBpco6bJJJpjpfgDWfhQNU2V/T3krsvZqXd+KojrbpGDda2cteGU/iTXJ8834QcfhvXZPmGXoCTGOpGeANzYVHMoQMQRIlei7pxV4+
 pkKM7c4D
 P8qe8UyabEMhuolD4gxEYepeoF3OcrebYpGUOXaruguN+r2QOTtrjLX4/6nemJN7FC53wMLM5rIBDkqT34NajdvSmOx/EF9Sc/StZBQGZSN0H8ujx05vqAb7OQJ+cOH8Tr2YCJzKREaL+1/YtxVr+qVLHsB1r05DJbDfNKzdjFkl6a0Hqkf1o+OCbNKuOsJdSYv/Pnbz9ZkgrTIpdh8QoYstumwIxusTK++y3/f3HZOJGu8H/Uraxx8muD5p4bbByscYCgdFEAK5GreV6BQFIYbCJ6q2ZbamMXwpoip2Hq1NHdhkgvVh0f6S1PiWI45ZGkI0Ex470FJMOS95M/dFJinqz08L2oXOXAg+EQWbw482H5M3PU3INBKE4RFtkhZXVkhwc2t5CtWPQ6vCZUOijcMzSHIzzpfQ4IHb5Df4dvqodiGfguqELjHcfs84APK3WYmNmTBJNuQ0zurov3H3tDO4mR/AVx9RMSraqygcS8nsBzkEzT7zdSsELYsO0dhvL9EngT8U6PQNMlVE5KAWacdUQOyG7trHGueoAuy29Jbc4uVf4Xv4bLf3vWQ==
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


