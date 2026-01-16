Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE524D4A5EE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562826B0089; Thu, 15 Jan 2026 22:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D506B008A; Thu, 15 Jan 2026 22:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0946B008C; Thu, 15 Jan 2026 22:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259DC6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:44:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B90A31A0528
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:44:42 +0000 (UTC)
X-FDA: 84336435204.01.2165C7A
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D578140002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:44:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oD1WJJF+;
	spf=pass (imf23.hostedemail.com: domain of 3J7RpaQgKCIgvm40zyu6s00sxq.o0yxuz69-yyw7mow.03s@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3J7RpaQgKCIgvm40zyu6s00sxq.o0yxuz69-yyw7mow.03s@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768535081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcuPkSqLOux6274EI/zkba/sq+NrsDAz74ZEl67RkaQ=;
	b=8Kb5FeF+PPaGBErMLgG/9j59tY0y04d9j09EFYHeElYOsE7PN1+JgrcCxVhn0K+maySBDK
	2SL6wPQGy9XFavjUsW8t8ZR9nawvj4EhGNavaR+C01DV2M+fTsbalt4OpHKFxwVbqGsS9g
	VO7vMUOzUbC84eIhYr7Adv2fQi7W4B0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oD1WJJF+;
	spf=pass (imf23.hostedemail.com: domain of 3J7RpaQgKCIgvm40zyu6s00sxq.o0yxuz69-yyw7mow.03s@flex--jasonmiu.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3J7RpaQgKCIgvm40zyu6s00sxq.o0yxuz69-yyw7mow.03s@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768535081; a=rsa-sha256;
	cv=none;
	b=OmH9ayGJLiKaL1ve+5rlptBLuzh8r/gD132L+X6hTLiy9vNyZpYixCB4dn/Mu9cQpFTvrP
	a4BHb0tUqfz07cMS5/2KAYVgquVFPrRf7fNsWsbx+CWrWnwN5ybLAXrYp3DYvCyajcYlYe
	fnwGvlPWv06zSGcjFOpyeBxlf2FvfLc=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-11f4617e256so9802753c88.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768535080; x=1769139880; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LcuPkSqLOux6274EI/zkba/sq+NrsDAz74ZEl67RkaQ=;
        b=oD1WJJF+ludypy6LkI4hvN7Y5JpCPnjghu0D3JtGJywn/v39l/RdCxZlefI6xakSGP
         dPRv/8Y4B+fP0/3C6w+7cgehOcKxXHPn5kav+eT827vpUE5unTi+V4LDVCk3ku2XpUJw
         S5JMwDyFcp/+W06mWND7OZcpSFWBLCImvgGjZ4dGpNQhNdb2nwKQmRa/kjP0OWZpMNKj
         eOUoTp/dxEb6hUXsLLPWxjBGCqdsT9CHneWabbc1OLigvGRpkWa1RfpZ6z63MUjNKKOU
         +WF7HdBUnj0f3vqI/pzkk2V3MuCYrvObGa6R+uzr5pM6OuxULAzikp+nCuVe5j/wUgYx
         aXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768535080; x=1769139880;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LcuPkSqLOux6274EI/zkba/sq+NrsDAz74ZEl67RkaQ=;
        b=azsJA7lfx7by+xGc367bUPZZG6arbOHpR/H+8D6fvZUaCr7ZumhXv7Le1dMeNa/2zm
         hnmkrDYaYTDffxTa5JsecHRd2zYYabsGfnsX2HMIYedR+7C+91vgAJ4KMfR+xpA/CqIi
         DvPBmcBoQxzmImaX7Lz8m5i8k8inMD+t4WLx5J9pRJ+puBKvhBQ2J2pv9cydhOAs//CG
         MD1hXzHuxSm52ZwiZ216Sxot2Jq0/XUAgMHHvKdAjfwNKHoSbwrBNxyEwlSuL0kNdSlT
         gRm9lLjL3R2xeiAS8qZKMRrChfpyyzz7q7mf+4tR5/OpqaTBK5agmOZ1yq+D5tB/HRQh
         I85Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAc8a4teXt/R+b04cfGWEeFU9M2lM+ezRMAv59/YwBoN4TbaOZ00zuVRMJnuJHvOZkdBdICcrzZA==@kvack.org
X-Gm-Message-State: AOJu0YzumOhj1JORP7uIB+7RI67UXUuS9nWoUiX9lL2JexFNN7O8i/6A
	hh3ulkmtgzMzGefQ14IJDXOLnKuT9dSmmjo3s00VI2Mbg6BWs4xr5YSWkNNSDoq1usVmv11JGIH
	nteNQu8C/acAZsg==
X-Received: from dlbcy2.prod.google.com ([2002:a05:7022:b82:b0:119:9f33:34a6])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:b97:b0:11f:1e59:4c2d with SMTP id a92af1059eb24-1244b32a793mr1267091c88.7.1768535079985;
 Thu, 15 Jan 2026 19:44:39 -0800 (PST)
Date: Thu, 15 Jan 2026 19:44:32 -0800
In-Reply-To: <20260116034432.1520731-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260116034432.1520731-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260116034432.1520731-3-jasonmiu@google.com>
Subject: [PATCH v7 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2D578140002
X-Stat-Signature: 3dkn4kwgc4jpuh7yuhihwoaksazmt8pq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768535080-110756
X-HE-Meta: U2FsdGVkX19pU6F3Jadcn0YHJzLzmYQxfdf8SWHuvhu1JcMqhG7Eal30S/5XgIgOCr8E8E3TvP731Dy6aTpV+e8dauV8VV+zKYxWE79m+ggnzmroYWpAsYw1rXiVPuC7BxouwLN0IbSUU8b+ukbaCvek67HbeXajl+kusVRqQw+kVyHyuoUf2bSkS8WXTUf0loOUbockRlkvXV7mPHWCAyhU6/NIqEtq3fMVT10Dxx7zJnjbewU4ecnXUuvMvmXif/0GICuCck+L0181zM2Y8wABUwmh977dom5EXFPlomRZnK/Luto/oscSIeUFmXM3NsKg96PLR1gxWszv+1sa44uK0rdwC59ywNV/d0nhkyBszrYmldAYROOB79FwUJSGlsl8raxUMq+qAWYTqCtaPjeh1QmONb0pVdZ/3LNrVe3AsR5HpKk+BSWn0YCfVtyxpeRLzu5hFiIfBmME7oN2oEzyrayc3VQmpPCwR+Zkn3Qhr3r0KnwxCvJr4XdYkvvwzFoPE9jNKujsb13KLXdaIFfDJh/XXqOZwUCjhG7iv0oHYWaG8j0hRTYe+sHSSc/Q+yF6vzfyJHAJjIfJOq+JOPcgKLlwGnnqYcfAq+dxTqcsIm8vhZiOo9faClFqsZVu+uNQKRryH9+gZNeVdObrBnWSkEkHAVuQBuXAXd+v+TbLI3cdSUNCTNYqrrS5YCZfd0Ma95GXxIsgCwjA1Ucn758++Mqgx7G8Fg5A1rkcR9f722+OX3MHIbfEJjFJEzgavy7byaSI7jAoHSk4lomTTaLyHhhyp/yKTBJ5jZ9dVDIeChe8Min4F2MlufLHhg2Z9A9oS4+ySVFbcBhWttYstvnRc+DYLhvE/jsXC+JSAaSwd6hGiKxhIQxMS9POHHe2xH8PFu35WibaKEW8c7FJKg084VlrUKZ+JsYAPkbQWcnmPXgRx+whfygqEZcGJn5CNR4JUSEqFwLUBlOXNaV
 ZUnQNM5q
 inKG/O2gVsa7FyklfeWIJgWb6SvvFkjAcb7WmlmWHHu8mo5UZIvDqYTcCIEL0uTKFoeEHUeWHgq5g/niW7ch9sw2K9YRIhEAoHX6Eo8gNs77xNFaqHxYaPjJ/NVHohyLx8e7IHzmG3zUgyZbewOZFLb906XS5qbbXhMQMsZUiQZs/uZjZNw6g4Ze4ic3HFXoQj0uKg557wCJZ+xq8cvLMGj1UOWZW5KJqxPuqjSZ7CrLHSgVw1u70xBp8k9xyV4oo9xsCAuEyVLPxS37MWMfB1myjKHgq89ylxoRet4uJLciVwW7i5xbOCkOsOGjxhXawq5zfPiWnRBAIvE7PATlLcwVjkrKn7LZN7tW7
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
index 06adaf56cd69..14d2c66491a6 100644
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
@@ -1209,23 +1207,6 @@ void kho_restore_free(void *mem)
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


