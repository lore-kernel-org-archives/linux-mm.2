Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DC3D29DCC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87E86B008C; Tue, 13 Jan 2026 00:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C5D6B0092; Tue, 13 Jan 2026 00:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D61D6B0093; Tue, 13 Jan 2026 00:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 784D76B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:35:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B53B13850E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:35:35 +0000 (UTC)
X-FDA: 84325828230.29.5BF1666
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6EDB5C0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:35:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V2cLz5eC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3pNllaQgKCEEmdvrqplxjrrjoh.frpolqx0-ppnydfn.ruj@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3pNllaQgKCEEmdvrqplxjrrjoh.frpolqx0-ppnydfn.ruj@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768282533; a=rsa-sha256;
	cv=none;
	b=p+tF+UlxqwJJLNGaRFwHQJV5sqeG5lI+civ3YNPs6TYOOGTKNK/EMy8yujsIPA7JR40Wkk
	NtRQW8QRsp9tVaFlm8yl1lJRJVaO5YKtc8B6DJ/kJtBZNNoOG6G9qNT4SMn7bOCjJ7zYAL
	GIjUFDphZGQjcvOcMBNIvRCohKSe17E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V2cLz5eC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3pNllaQgKCEEmdvrqplxjrrjoh.frpolqx0-ppnydfn.ruj@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3pNllaQgKCEEmdvrqplxjrrjoh.frpolqx0-ppnydfn.ruj@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768282533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZdzwmCXe3gMoHyDDRR+IMK5xDno+0lJCEG1fStGGwY=;
	b=aRrpwg6T6N+MQyqAMJcGxvEFnx+5L46f9vDMfM5/2k+bA1IXFWyTkLeehAhE2CtzdjsgPM
	QUucRacGtUnGr5i9zv9eM+HclrQWDdQL8MJubIXCdVbV+hf0p+99mFlbouRhBwf+QDtNmR
	xORomaAGgE18X7JYjvQDshICHJFWiPM=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b1766192e6so5866936eec.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768282532; x=1768887332; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ZdzwmCXe3gMoHyDDRR+IMK5xDno+0lJCEG1fStGGwY=;
        b=V2cLz5eCN+9uTdTKdOCiVosc1Ptv9RICYuoIX9Ct29Wcwh20ZjDGWoJBKmeIf0BEip
         SQNruoyXUaJEzaQoLZVsKh6fiHHGWtcYoicKC9BYimqU1LwM80vHeEhytkFqmCpcLxmU
         YYc9RZitlUPTtFIIyguocsx2pz7y/O2W61hj5GnzgRQFk7L5Ook7uYTbnBsRy4EyfEh2
         ibtNguqIihlGI41jQtfHoHdq6vNCqJX93uWWJLOk7oSbWRvx7bZ/smbHGRmCxqwOnu5i
         ibaV2MneFQDncE1N5PxdVA80HcLV01YdbV4wuz8whMo+8z3lG4xOx3vUY0cimf/ar+gx
         okjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768282532; x=1768887332;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZdzwmCXe3gMoHyDDRR+IMK5xDno+0lJCEG1fStGGwY=;
        b=vVhY0Hr4b/ersucd8U0zOH935OTuo6sTtZYWIWL52fbV6OhWTk9Y8qki7qs56o5XG2
         JjP4g51H/1ztGm3Y1lP9cxZlPF7mKeAbJO15SWNFgHW2F/zG1Tpy0enaHrpYY269Hyk6
         07Ba4xoTOLUSm3OxGu7EOdhrYHkabG9Qx/bNZV0zeVdJdBfAOmfh11bKuEEtnMmK8q5H
         0FxG/PSvAILWwGRyYi3SoWfrRoZqcC8JgjK85hcPjSlWs3yKAIAw9dDyuhcI9BcTZa1g
         i+IaPbnKS5YvKHWwcBqP1OnD9Ypu0x9yR9IdP1SqWSJQ38b4adROBbAr1pcgjUdxscrm
         8iYw==
X-Forwarded-Encrypted: i=1; AJvYcCV8JOUTH76hTfzcSFb5/vnjMQwE95jkk3++GKHVisCQ8HWTDQFv8ZqOAnGAzjECqyGf4Q/p9XR6Zg==@kvack.org
X-Gm-Message-State: AOJu0YzENsSLyZqiwJGRWtI3WjqzH3IVXlH54iAahxiPcNE4rjz5e8Yo
	oyrjRKPk6fCOBmum2dLYXPCln5HCZNbIs1awBAwQT47SklkiZdlfOO79jA5AkymGnxDhsvoHJ5N
	gIXJhmyOOxSowpg==
X-Google-Smtp-Source: AGHT+IHQKmij8n+nGpsHN7+O5LBztfLAEM8Fv+Jj9CZ6VEsfpurzRy3SztANuDZc53cc5UcB+fuJCx6tqK2Jpw==
X-Received: from dlbrf6.prod.google.com ([2002:a05:7022:f206:b0:11d:ccc4:4c98])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:b14:b0:11f:391c:d01f with SMTP id a92af1059eb24-121f8b8d709mr17436261c88.38.1768282532012;
 Mon, 12 Jan 2026 21:35:32 -0800 (PST)
Date: Mon, 12 Jan 2026 21:35:23 -0800
In-Reply-To: <20260113053524.84186-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260113053524.84186-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113053524.84186-3-jasonmiu@google.com>
Subject: [PATCH v5 2/2] kho: Remove finalize state and clients
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6EDB5C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: wzshkfe3qt7u93utaub4gjgh6hoe1egm
X-Rspam-User: 
X-HE-Tag: 1768282533-930035
X-HE-Meta: U2FsdGVkX19Pl6be0sK4+Kcrl8KMbaCR6eH5900aIzjn403wiwQ6jR+O92mKrCp9NoC3f2E09b1Hc2oF1cQKDW71LTZbdWYZslko+6ZkanAIa6O0TrXHHDfX9N40FKiT3Fiu6Pb0p3cEXhHpzHmxpac9Ilgdg64blMvKYSi5pO+ZI6X1fPRFUpxyTANkYdR/8j2dXpeqRxu/mtT1kFBNbYrKq7x3Bf6gLNfghzM38QhAY3q2tFtkc7stbPOM4ZzcDoNRrGZeBl4u59UHaVmAVRt7slPiZHikFnC1eqrg9EsjWb/KLJYjXszyVqF/NRCv6q77Xos4xACByUvER8JZyjHXA4RzdSUNdii5g3srluc74TAAtrIlya7MhYZDfzpCoVb41CLeYJhn2BVEr+5jbKk3aPOYM33Gu9K8drg3qfmZOVimPOg2mUAMbKctq6LX04jSYAyWBPGSH3cAKRjVstKN8qHCSL+cSxNLwNBQ0nZecyw7kOJq6v1jWmLFeIe2kcaGEQk67Ypv2F8WCGw/lbi2I3gtyV89+4+kFAKzRzieyty2ZHfS+DVCbya22w4j5tDGZp7CVDOF1hEouYA9SawLylXV7TB9Kvtcf5WM/2RRqczJakpY3ynq1P6ggGFmTK+4Ala/haQoUuAlrs4gLTngalYLoSUn4mls/t55uo6uHmyK/r8AU5elvtn0XN3ErzWDAUviVnf7E+b6YMyPxcuSmNQndXBYidlkJ/R3YvV7D2QysyBnUOfsM0vIWQY9C3krHIdIQvUeKyT/5VFZvHWqX5RWVKtLK/Q0Qg/x12fP8DJSl3yp4NX4CivuyLjYP1G+TFsb0W9LzdXuv6FBaAYMl682cewYzHRCbQUzNB8Yqr6z/FP2zFkmCg8B10L7c6VxOlhxRZpn+UimfE2lgcLjgvpBFtLhXed0pSNRxN8gb0U2EoMs+wkunYyU2jaz49XkC94LKhz0jSXJ9jK
 T+l09sFa
 7QLwWMVyMZfHspr4AA/i2bwW/7GpL/Jb3mGqNnnzE8s09rcQtom2dHFTLNrGehARc/wKMRvYgjWKCPcHewaJr+f5re6zKuv2by8KIFw+8ANKSFVeZgEZbFVsaYEAzmJVlrkFS9TzTMPI+0OH9EGB4m/rBaaBfFnY+LqMYFQ4SMoCRqWoBYJZhNZxDkPbALrhQXU2oCGeoQOZK2rt/jdi6B9JO2prxDnOiTSJMUpLl122/3DjLmH0aKVoOycBclb1usH24KplRwdPvxFFhE4M8PGCxF81sJNVzYJYZIRbyRd5IeCKUUO427W6q9roNxyo+yMXYvGilQCF8hsBv46p+hTdpdIxgtUGpFMV5SNWZOpOlleKDkRbsopi5uB4bR1KM5JRzYHCt7oUWS0tnOVJTAWjK4LvoTcBVtI34NdUabbnmCLtRmL1k3tb3yJtNzbVJR0tL1ZdT0T3oS4iHoLn46dZYTZZAv9vc3/NxPbTYuLDcoRzpbOmkHjIbzEjrU1XXfyGhwg553zTri6AKCb8oPt5Ri2SwMqOeP5EVG73ixUJlbgx0DNH70W9tHw==
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
index 2b5d91f66cd8..1c9fc91e6fcc 100644
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


