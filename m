Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF687D73EAA
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED58E6B0089; Thu, 29 Jan 2026 19:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2B86B008A; Thu, 29 Jan 2026 19:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB50F6B008C; Thu, 29 Jan 2026 19:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C75E66B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:57:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78D6814048D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:57:53 +0000 (UTC)
X-FDA: 84386818026.03.6853A4F
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id A2FD21C0009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:57:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0iuAfeWQ;
	spf=pass (imf18.hostedemail.com: domain of 3DgJ8aQgKCFU6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3DgJ8aQgKCFU6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769734671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IT04DZp72z6oqQ7w+25ZmczdJLtm0/xVjJxO1KrmGw=;
	b=CU1fC7cpXPzODber9VokssGxTojNtV+VMe617MsVl7vCFCvbTlzZWUJARU4iWRf0NQoB2B
	hIEoAvFoBq7G8zRAMxjoZbMAlEoMJYd4eqsFoYLViNRqZY3POwbEW+xSavu8JpQ1/GKb05
	v1w6Qv6vaMxaZgG4n35Oz8O1ATeJmpE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0iuAfeWQ;
	spf=pass (imf18.hostedemail.com: domain of 3DgJ8aQgKCFU6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3DgJ8aQgKCFU6xFBA95H3BB381.zB985AHK-997Ixz7.BE3@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769734671; a=rsa-sha256;
	cv=none;
	b=j9j0hljAwuExGn//X9wUSGONO35ktja7NU4A2q5PqeDfBTiRx0KM0FGOSnJrYW1LCAQLAK
	5MGhuPraB+XeARqQc0HmyYpH8OVbGUrDx59orXS9A4p2zbeINypFwusQY/ed+JOMabDvx/
	cKbuqceb5GZ+hthCuncsy5no6kMA6QQ=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12339eea50bso9450334c88.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769734670; x=1770339470; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5IT04DZp72z6oqQ7w+25ZmczdJLtm0/xVjJxO1KrmGw=;
        b=0iuAfeWQE/piKeod56yIOzqB9nl1rsWnAw4FCHcithnx824Su0aOuCmq3qOTOLDGeO
         pcVNlrhBrYW/nDpTKrlwY99WuT3ThH4o1pNocn5TW4ADzDaeeqH460Msi6ufdRko8X2m
         WY55eCtAyMwUtJ50za0MTBY3WJGJjh2WMnPt7uC2pjQBAgxgtPw246ya4GU/OY4c6iC5
         5fkCiVKkdlyBse8q6AhMET6qRTK1lkyeUYP/KRDp0JTcjG+/Obw9BexqD7BMmGmlFZ3h
         vo7EYe2iGVdB3+jRJAv/tNv4TQ1FihyS5YPwdxwjP+N15T2xaXAtA0Wqk+sCztK2u50q
         Hkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769734670; x=1770339470;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5IT04DZp72z6oqQ7w+25ZmczdJLtm0/xVjJxO1KrmGw=;
        b=O+g08PGvY8JpVwhBj82JEtemmR58bY8FDci8vlDMo7Mp3bFPrI6e/ykSnAm9jjZigO
         uLrBQcNnAwcjj8oOgUSMzgk/KMTZ0eyvk4+DgcIAuR2816bMlYfd/tc4qHP8sXDdbxmF
         Q0jRlALPPi/MVFBgp1r/cYNNoNfGDnXR7jo05Bc3NgFZdJk4Uk4PEkSn9F2mNsgGLmFF
         VdJEPinOQBIIxOzTmr3lY0NzolA9d066xKrK9Rz6ZO4HmIWU45xKwAI9VwbG3kCGQWVL
         k8d9cs1i1DpuVyuvL8QQzN2wAS97cLW17UrfmLI5Oo31lURM6LXJPuCWMdhpc46g8XPG
         G56g==
X-Forwarded-Encrypted: i=1; AJvYcCVjTFIbDp73cxKqLi8kuFXFLc9Ix2ik8+byfWeulPFxnqFexPq/Sv55Ek7QM2nvV0t+YoJOP9o0SQ==@kvack.org
X-Gm-Message-State: AOJu0Yxj4k3jsHKNB40sMQrzLlw06fva9CvwoAnRwdDtECOpuiENzfvo
	zGeY4D7QKqWQoUA9Z9oDmUisJKgr1UmNE6ldwJmwzMTy5pZvox0aYgX5Ttv8+6Rz9O+lJy1Z8Sf
	Tt9WfZENrtEXB+g==
X-Received: from dlag15.prod.google.com ([2002:a05:701b:250f:b0:123:2800:6acb])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:6a1:b0:11a:e426:911a with SMTP id a92af1059eb24-125c0fd5576mr606323c88.15.1769734670293;
 Thu, 29 Jan 2026 16:57:50 -0800 (PST)
Date: Thu, 29 Jan 2026 16:57:39 -0800
In-Reply-To: <20260130005739.3163049-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260130005739.3163049-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260130005739.3163049-3-jasonmiu@google.com>
Subject: [PATCH v8 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: y1z9rdmcffyomxw45ymwbkdniqe63wnn
X-Rspamd-Queue-Id: A2FD21C0009
X-Rspam-User: 
X-HE-Tag: 1769734671-373522
X-HE-Meta: U2FsdGVkX1/uTnrCqJ6MeRAxrP61W82VsVywrJ+G0zw4kHfwA673TS8ES89u5i4fxbhkAy0cP58+cRv6/RfQt3At7RVcrambT42nrldxe40wZlOluI/hgl/JDszSb2mooqwVGoShnaTHHdslnMebQ3kEe6uyG15Vx+2/NSrCAUsACtAVLQbXsfv0nwTeKrWC3By1fQM8ci1oCMviPeKowx2Na9M8QxOuEnMkc8lbFvutFd/JOzZKXzzZXq8QeVJ4FFxGJez9IumtY4bB4hfAaNa/CNDYRkKFQNwF/xIdxqwH5v+TzP3XBj9wKQqYYLLEHpGwTZcNjUigWVawkdbIzSJnfrSsZpHbSwWjoRStLZeMAgnJT92BI0Q3Hz4rAzYV9x8NrRl1x3MxZEPukunjfSW2nsIBcabOfr0EZ/f2fBnxefJFXpuGVCDx+xAC0lykIDpoKLzvyUwceYPHgD+WsXT6Eg+4r9Ree3VITTxqhKPtyf4RTSimLPy7ji0mPWOKzYqcnq+G+9QJ/4J0j3dx0C/EefY2v2MZfzPtdqVOFf+1gcXFBFvJCZ9Dv/vRBsxuxiU3iCmmLV1m+fiXmPJtAFj/0KLJ63j2b8mXylxocts1JWrEfsJkuKbc2X62oQurncipuXQrzXmpB33MUxOz/ACUHZMbfsACYfbjd2aJxDeQyU+lKhkGbY81mrTfbF39bnT8ZJbZhTN6VEoMH3mbbi+o3ki3pd8LwfTej52zg3fgHV7tu9wq9M+tNwO7g6aRgWyZdtxEAwNaurKD5wwEf/KB6kLksze+9wm7uumnhHkGGxxc9N4XeF6x2f746EYFMems0gNNxN5QYeEZ7f+bm/8ygjM92eYUKMl16qOLz/uTV2jkDsBm9A0sqd9ijmdcv7M25T1RrNCtNsiZgd5KIqY+St0Qm/UdNhVLQwyLHnxR13le0xIPSaWvecP1vndjTyjLYWZhBC2BcaYl9kM
 HHvHsSLd
 brht3wi5uU/5Ny5sU+hboVulV71AfDY7+rAXYmBxvmEkyfkx0bEVFUgBaGXIgBVIDoh4MhhgohBc1hE2drb8DHRdTLhueXrt/4KR2waMbIaVzG4VTupvmhBWRy41iVGTJbvlLea1nVoruKY5YFsZRTMicg58X2x8o95OCrMhdAMhzVSGEfYEuVVI0GYWjhl6qNdro4yhz38//7lGXXBoV0XN3tcg9PjHWxfLvwVQRZ3aCAPcrnC+L5luAxEgpfJeRD4GuIConUkhi7vlE+JlRCGvY/cSvDWdpGqD+9A4HAQgDXpJaHbhxqRntFZHfBFZ3jrTSzMeLjdryAkYck2JLU5acYv7t0VahjcAgX91n3hcmMQ9nDfd4GRMKn1lo5ejo+FOqa7BM7BEe3WPy/xh73ZxYHwxvgoRvdBM7EnunvkE/C8jVmz9Shi7+gN/zDGNtAo//552EpE76jS2/RzOqE0YI08Sa2ptr70SFuHZnnRovKyB6W7aeYP9P4/homIGZbC4Ef/C0JvNDzj7OpHP3q4iqvOCKmm7JbTRvLP2Cx8Kl0Ddu6aprMmxNlu7Sr2SI48JxBTA5wSkS7HCCnUHeSlPizyWHIa829uLubZ+4RTsS1zYtXyBu2hExA8THfUE9HsLEksRN/+EU+Sk=
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
index 7210756a1f3a..56d8312739b0 100644
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
@@ -1246,23 +1244,6 @@ void kho_restore_free(void *mem)
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
index a26c093eb8eb..925319368026 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -225,17 +225,7 @@ int liveupdate_reboot(void)
 	if (err)
 		return err;
 
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
2.53.0.rc1.225.gd81095ad13-goog


