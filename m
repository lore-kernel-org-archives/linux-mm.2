Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C74D46634
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2366B00AD; Thu, 15 Jan 2026 18:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5A86B00AF; Thu, 15 Jan 2026 18:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F576B00B0; Thu, 15 Jan 2026 18:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11B4F6B00AD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:00:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3D961404C4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:00:57 +0000 (UTC)
X-FDA: 84335720154.28.E05B791
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id E85741C000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:00:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iaTYCw+i;
	spf=pass (imf18.hostedemail.com: domain of 3pnFpaQgKCIEofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3pnFpaQgKCIEofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768518056; a=rsa-sha256;
	cv=none;
	b=hWn4Sy1FzIQxFSF+uUuF1JuU91UYXPkATv50Ai8spcq0KCsnhx578MpUU1ggOuDdBUBlP+
	asQe9TgULSTOP1DIHQSap5PoEd4bcXc0ggE3tLaQyRl3mYeQAxNViyZqp+cIhHenJ1vcuP
	r1HEYjbZEkBtsoFIpZMhMEAFptuTZL4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iaTYCw+i;
	spf=pass (imf18.hostedemail.com: domain of 3pnFpaQgKCIEofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3pnFpaQgKCIEofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768518056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMdtswLamt3UOykeQTkJyuYvDnFmHdnfUUvbhOgS5Nk=;
	b=DgnVZIPpyESYo+AmVOmhqCyn7E1rQSwkifu7eLcjHQtsKdBR3zigIlmx2qMhiqzIFx66pi
	YowRlgShQH8BOYimLyMTi5AE+a14hMtfgA1NU08VBMfaae8VcObRa5+IZD77Z6A5GPAbhp
	LIYPMNQ/Yc8wAwVWu0Br3ZAzuFRLgig=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b6b823d819so395171eec.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768518054; x=1769122854; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMdtswLamt3UOykeQTkJyuYvDnFmHdnfUUvbhOgS5Nk=;
        b=iaTYCw+iMhBhFAXjCrXMNH4Km2WMiH5uGYFotdWXjfg1u9pLe4h16u0+sDhqQzTWzh
         cxBNiFwXKST027tHV2L6mn0QC/eMFu/oP3+8PoAA9KJYViF1ywFzidWfU4WMdZUPung8
         Sw4up3zLTKsMNrbQFx3tKVu7UgNrL5qxR0A+SzB3FPDSFmMgsECDAkNYsWLJUnBou678
         MlxAqJOt3vKgX7CI+MqVnI83RrrVNMeOWo3xPOafj1qe55QaqGE69UhPIkAl+BUQn40y
         Sno8BHfHbgAzG7Hh3BOmnTkUP/KRM0E4oYWSWfcRYq3+BqT5PaykPTEOm4Wf1hQbRjUG
         5v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768518054; x=1769122854;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMdtswLamt3UOykeQTkJyuYvDnFmHdnfUUvbhOgS5Nk=;
        b=kUv9dIpCAM5VBJQgGy8GndLpur4SnZrb3W7Bg2/WkSLPG5CQggyVS7glij1xoHSWTR
         jxSG54oY3fKRTbUfwgTqKncx97Ram+WLa0KRJdU2mq4B9/th2hlbfqq9vLOhfaC5onbD
         Cy2cUeNQX/G8heVFHFgMO5eidbb9y30YzE8v6E1naUEy4RlKVc5tnmzk3ScF6hw9d3to
         WOEpu5orvK5w+6dZTrsLV5xW25uOWKa/kDdZHD3azS2bW+GYmDLr6ldeke8ktXkKiqRu
         +G9BaQGsRrsaonBsti+hub12BexF3ToeikiH8dKYvk0wWc25ZkmW526UHBMnhBK1Z86i
         sPJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb+4gyNzwJ4tlBOAZ223v2O2GTxq9dUGO9+yChOdi5wxbKk1fX1fjwiChrAx+EYUA77t4V6hElZA==@kvack.org
X-Gm-Message-State: AOJu0Yza4QrLXSmqJc8BZ4lNvtUWRmD9NoNrrnGFN1wiy63zwXS55PsV
	LqSPWhGuavsNNHGwciFUM8npGl0M2Cu0kgFoFQRWCMfQDX5ePTBkKC7kkIyVY5ZeozlOVyZIAOr
	lU263thbXODF0nQ==
X-Received: from dlbui3.prod.google.com ([2002:a05:7022:3d03:b0:11d:cfca:1df5])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2206:b0:123:3bc6:1ffe with SMTP id a92af1059eb24-1244a70d2e6mr1427106c88.15.1768518054137;
 Thu, 15 Jan 2026 15:00:54 -0800 (PST)
Date: Thu, 15 Jan 2026 15:00:47 -0800
In-Reply-To: <20260115230047.1220580-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260115230047.1220580-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115230047.1220580-3-jasonmiu@google.com>
Subject: [PATCH v6 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E85741C000A
X-Stat-Signature: 5roam5uiszkabsrumeakrj8ijb6ggc3o
X-Rspam-User: 
X-HE-Tag: 1768518055-474050
X-HE-Meta: U2FsdGVkX1859TkPUQf0CU1h9L1YR3B3+wqslo3aAoQ91QUledIhEOiYQYDBYl/jrZLrCVRrZApYm+dIJblm/hwWKATV7zYndgNTWMSSTh6BLy6jp4Pkb0xOOUN1MmEwosVu7QyLSzAwki+BH5b+C1Mq8p33JDUv/w8lRj2x0HdnA3cj+0oDAnlvP+o3DtaOwjHQZUP7Pm2I0sJ+glapZWONM3hLK2g7KXCuEV1Vubij+C4tSaXEfYcjiVRCBhI7/BaDs9I7pVsrUI2CUSU5hlXW3mD62gNSX3QJXKJ92af2+VVxxp3PF6yP5EaPDljfnaYeU4xwqZHW7LX/zg6Cey+RJd9NnL74CzN9O7LKjpKoI0P1NB/bqj9Wf7x3mqxDn+zLVe16PBiC1YamAa+2KwclS7CfDJyGGRL+hNZoFiC482DlLKk1why5bBi0JJ8zBkk7V3JXMQnAzzcGqvon9hSOLLV2W67H8fqldIstrHVKgZ5Zh9wA9tK0a9Y3dReJn+UBU/B6kvo5pE6kLP6pfTmu7LZLmo89HskCmiW+tXY6YSeCuJlapaDo8Xc2B+2OQjnVV545Rx7GhMDMZpEdooYXpxsNJze682IvHMHhlIvPzk0T3dTV0ATMXeHlnnZPI1ySPrBHTZ44rqsbIZrnshmacNptSwO4lEwrrn2dSEEpPyg80iCHiiFDlxMccltcArqdP/U3msf7L29I+bt+2/bmlsTHQHKBnmiJ3P8JiwRDheYLeTlCXz2b1yKdsWD30Mmnzu5zTROdTDPC9S/cXZ+aSNku0iRGLtq4dUXjvIJ2fpRrYyGvRSQFHfHZY17uYdSSzG+6O3xjjybIgz8y21tKsj0ACBzF5uY6zChx9jeI7MRVUM+5UQx3yIt6YqnqqNo1nvGxN9PuBw8vyOZuO5u+4qaEYUu6OqLmvP0PbsAzMIJ81QnQEw+mrayb9ZE58/OmT8OPPhGJEbJYZAM
 6Zdi2Rr1
 K2qg9ZEMqKP7kCTezmD3ii+XfufyXLI2u6vPmskLql2CmHgltpGTwDg7xmZfaQkfb8vH+fMxjMkajrb/ofSDl6rbg7Mw1+5ARpV6EFcyz11ze8F22hE8K3z87GBliBj/zueG3rlJsclh8wvqfhSeh2tHcPdiKtiueOtEUJkJEC3GBuL3ZPEbsw5xydgzkIAHR3exS2yJBellpih82AhoY5di6/fyC2gowWhnT42hcWpxpOeHIZvfEI3nr5LRy28h+0iYe7eIgzv5+uuSBD0yt4lZUJh75n5wIrk81j00pUM/VcbvnBuUc3fE+QedluPKFyXE9luPNVBVGJsrlTnjZHWiVaa5Ap7VgBKS2Wb0zwKT7iu57Z7xm+wkmMpd0QfeCES+7hGkNo4nPy+v+clvHzgaGnNKQPi1riR2u5xGZQkya2QyT16HzccNBQ2FKrrmY0J4pjHDAQBHgTonvowgdxcx7jS5LZjMNPMmP6p48i3t/ZJdVR/d1JOc0VXf+iyHfyb5ZgZ1jtnG1TS93N+B7qJ6tCJ0cmvbNmoKe6L5SvOuA3Fgph2PZJnnQ4A==
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
 kernel/liveupdate/luo_flb.c                 |  2 +-
 tools/testing/selftests/kho/init.c          | 20 --------
 8 files changed, 14 insertions(+), 132 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b886..454b378cf239 100644
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
+    KHO producers can register their own FDT blob another binary blob under
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
index 33ba1c7db661..411bf7aa80c2 100644
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
@@ -1196,23 +1194,6 @@ void kho_restore_free(void *mem)
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
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 4c437de5c0b0..22f6409875c9 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -630,7 +630,7 @@ int __init luo_flb_setup_incoming(void *fdt_in)
  * data handle, and the final reference count. This allows the new kernel to
  * find the appropriate handler and reconstruct the FLB's state.
  *
- * Context: Called from liveupdate_reboot() just before kho_finalize().
+ * Context: Called from liveupdate_reboot().
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


