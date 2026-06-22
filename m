Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0927CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49EF6B0095; Mon, 22 Jun 2026 14:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A213C6B0096; Mon, 22 Jun 2026 14:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937A96B0098; Mon, 22 Jun 2026 14:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 935AC6B0095
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41C9016672D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:11 +0000 (UTC)
X-FDA: 84908436102.06.57119C6
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C131140011
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fk3/GaOg";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3o4M5agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3o4M5agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eO4/5+rWmZRxRXK4rz/cib79Y3hRHk98N5UOT15asUE=;
	b=evvKhpstmZOl+c3Smmt/i4UrhscvZBpO+vCKVqzI+zDcT3Ce5zZSF6ont1jQxN3MH0v5Bz
	i28tfoyoyWbflZLAnis/9qaRrp1coUREx6Jq5PeuzpgUbIsqEFUH8Ehku/La5FLEy3lT4R
	M/aQ0YGGc73r2rqW1Ivxt3GCW3JhJkA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fk3/GaOg";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3o4M5agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3o4M5agkKCOgdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154149;
	b=uZkX2s+8Ypsqp5xt+j8zZpWRiH4B/mGcb/4r5H1KhdPzRCIvSaLe7sHsgbp8h1hpMyH4Ws
	eSeUclGwHRuYt2WoI4L+K1qDffgKYfgnHQLmIla84xVzuTqnouxL2/vryCMHlDz94bLpyu
	bKm55NPsS7PtBPuejWlP6cj420GX47g=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490bae3a39bso42775395e9.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154148; x=1782758948; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eO4/5+rWmZRxRXK4rz/cib79Y3hRHk98N5UOT15asUE=;
        b=fk3/GaOgDQpeKrYSWTPP902Xw7l8aM4z/mFCJIuPu5QKnCh4I07TZN0kXi3E0fS3Pe
         0IHt9EaYLWglVNDMbnAzOHfpMeSF5yRB5Ha+G6jMSD+I8LrSoCRNF4uJAbxbhXiReeUT
         4nSlnnlcE50PFEMGqK6iutXB2tJ5KvqjFsrH4XRw4VjXEf3kIIZ4QdeYV4awOioqgNZl
         EkcUREKAZ8yuab5JkjuuxTby83BT/bGRYtX5buXNuZJee7bOxDthe4Q0meihiZI5f3XM
         sfqQCc+5YAvmC9UQpqfon/3wtayQpMUEQ2kot4nw5WqiXOiBM9jBlRc5xH8pig1ldcIk
         3Iig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154148; x=1782758948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eO4/5+rWmZRxRXK4rz/cib79Y3hRHk98N5UOT15asUE=;
        b=qP86TpRvvUmm/Sqm8+YyRc4FSUFYt3M0xv/AowceDWYlm+goI+8oFHHqa9XGlcxprL
         El6Df3hJLkLsdPxAOE029rveWqO1Ek7HFP0uoOqj1KSaEyLe7cbTASdaDyF5xdDzuU5D
         29WiHya4PrZsriDLx5cXfv2ft5ivUeP7DuzT1K7oEkjLsor5hfp1mjIRrQNHC9jeQ8n2
         /AXxdy0GjmFfl7AEe9G6ei1hRJgHthj7PYjy8HlH23eRGBQqSf6Gvv6Zhz0zLZ1rlSNt
         zxI0bkOo5vo8t4YxyuSmI8yuM3oeF249R0mLSJoVsLroECMdSffdS5OKi/ik6vtQkqB8
         Mv9A==
X-Forwarded-Encrypted: i=1; AFNElJ8EOGxE180rs0pOzOouvpfTz1Jbtf+3Ys9VyEZ1tBlzkPsGxTAeiAnH7zVnyNmdsUmnfGtoofRhEA==@kvack.org
X-Gm-Message-State: AOJu0YzQQg6ZsPt2Do2nQJ+ckUsxAwBPoIaMYq9tCxXw6ude+F94T4kI
	hc9i24OJGMecJZYerxHUZ5xCMDjhMebqLy7CooHdjHaZSZj92J7eNyB//jCQvw2YR/Ly89I6MWm
	kIKHOIe2PX7z2G5dgfw==
X-Received: from wmkn22.prod.google.com ([2002:a7b:c5d6:0:b0:489:1f08:926])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8654:20b0:492:4fda:7720 with SMTP id 5b1f17b1804b1-4924fda7824mr96334525e9.14.1782154147352;
 Mon, 22 Jun 2026 11:49:07 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:48 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-7-tarunsahu@google.com>
Subject: [PATCH v3 6/9] kvm: guest_memfd_luo: add support for guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C131140011
X-Stat-Signature: pstkb55axunja1m8bbmzx15m1zf6jmyo
X-Rspam-User: 
X-HE-Tag: 1782154148-438991
X-HE-Meta: U2FsdGVkX18Ck6+eerwopfX4kdN5110rYTEKqdwH4SgK3iJMMa4ja4BaG24R/GDeuH4mfCCL6JM3q1U1J2I1PgNp0fJqAhGxG3ywNVLR8s9gRayTS1xaINKGoJb4gyc9DazD8HMxD8pEpaPcmwpbJJwVgo7fhVtU1q5fu7xPVQcA6yK0vFfzce/BiRWq7jCDqkKvMRNHznvuqo+800Il19B+Vtyp6Frvf/MjH8NtOtW/KLiyyH4nLNr1xVK+SqOqy9OSON0YLQsGxOZEIseV0dtIsk04RDJuerLT8j55At0u8ggma3R7kIoK1ArGRagZMoBFpJB6LmpTlFdVUzKLHE5JMVjQ9LmD23md8+yUny0SvcB8WXWrZ7+Zj6wpRTkkzw/ixBm/1S1v1ngNPzKKepGfNMGAzjHqpbjzaoQ6nocruiVGA1flrdDpmMHpMq3ArZp+TKANMTaud14Kxr1bzn+meHBgyfnTZrS6EPmKk4XlMoDUTnYPipNL32YT2IPRrj3N1bKzI6PTWQLBHkThJJuU9Xi7x1ry4tzn46wbvl28b6YMgYYaLiFMYnPylu6PCt5l3CC7uppsRkG+7nO5wDSPIKH0vM76WeZAgj8hAe76R/ef6LhXCxVqaoVh7FVk7eohtB8+K8+lzAbpXR0/xk1fjeS19g2jFkmjicVMBpWOJk8Gwd2qQy0b7aYzQfvAKtl27teglVisHqnaHpuCQeAIT8LiTo7bmGME9XeEED9sqQu9WJhDiB+uhJGkUjjfX5P+4+Vg7K0JoRsKdlD72QrzObVZf7RNYCBIwxL8l0Pw7SSai6FRPtSJfECdHFPiQ3o5dNDNHfSBDGwRKTV9vxV/bfjVFEzdqsPa6hPMBo8Pe1Cz9dggdhjyddAqil/mhV6E7uvWNMunTrtzo3S/e6fErOyXFAelWkQ9l15bGzfZMIfAcxQd/+es9cAfQu3OEfz05J1goJbVf2yglVB
 GnM+9OGk
 GyLn7vGLKPKnDNK9M/w3avx+QVMaPekr69R34kVi1d4u09miqNK7ztHUXA7UOI6zOxYT69b79d5Sz3ynxpvi8G7KUg6UiNmIUZEdVjDCh+lNptMfyXOcnOsUMoV6QUmiV3ULIW3ACu4Qb3RFHgR19NI9ib9iSjpDrPPm5SMp8g4C7GcClf4hN6LiTjcoXAEKOw1W1XyyNQG3NufI6e3B2ifhdlMJuLN6g0oPQUOA0pMc6WpSjQRcDxslh4TJnLpMQv6LvPaIS37fWR8LenNsOCmCJEeiSU/Ap96CUImuceHLjKW5QB8EhQp2RwcNf5Z65pOJUZxDm0w0NtOBIVPYy5WbaaUjvFmOhxZtK9JdfQB8xaQwsXEL4DIhEwtfYTq1w9K5cM+OgPXWL25z0zcBjkM6o+rP4vUidtudHbJaanOUb6o68NW3q5AeGGdsuqbSBZdfDPv1gZvqDyLX4i3oXzTa68eRpz0Lc35hhPniQh1dtAdsqme/ICRmF+pGh7/63i4vLjrdzd7Jx9UG7vkeAAJzkStUKBcoPzRaDbvH1Ty0ciSj6Aae8ob9MWWYh+P5XGoc4N+d3OYsUPpV4WaOO6pbiBLgH/Ku72x0TaajSkh17ALM/nJcm2fxIH6vg/2A5chh1ksgFi3KizlszHwpgGB32PowZkjMczQFDDq7lgnNBn7kCThZBH2mFpDWXJiWHfPpA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up the basic infrastructure to preserve the guest_memfd.
Currently this supports only fully shared guest_memfd and backed by
PAGE_SIZE pages.

It uses INIT_SHARED flag to check its shareability and
kvm_arch_has_private_mem to check if the conversion of memory to private
is not supported.

Preservation is straight forward. It walks through the folios and
serialize them.

There is kvm_gmem_freeze call on preserve which freeze the guest_memfd
inode. It avoids any changes to inode mapping with fallocate calls and
also fails any new fault allocation on or after preservation.

This change also update the MAINTAINERS list.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                 |   1 +
 include/linux/kho/abi/kvm.h |  79 +++++-
 virt/kvm/Makefile.kvm       |   2 +-
 virt/kvm/guest_memfd_luo.c  | 497 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c         |   7 +
 virt/kvm/kvm_mm.h           |   4 +
 6 files changed, 583 insertions(+), 7 deletions(-)
 create mode 100644 virt/kvm/guest_memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c000e6..d1d699ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14420,6 +14420,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
 KVM PARAVIRT (KVM/paravirt)
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 718db68..42074d7 100644
--- a/include/linux/kho/abi/kvm.h
+++ b/include/linux/kho/abi/kvm.h
@@ -9,20 +9,23 @@
 #define _LINUX_KHO_ABI_KVM_H
 
 #include <linux/types.h>
+#include <linux/bits.h>
 #include <linux/kho/abi/kexec_handover.h>
 
 /**
- * DOC: KVM Live Update ABI
+ * DOC: KVM and guest_memfd Live Update ABI
  *
- * KVM uses the ABI defined below for preserving its state
+ * KVM and guest_memfd use the ABI defined below for preserving their states
  * across a kexec reboot using the LUO.
  *
- * The state is serialized into a packed structure `struct kvm_luo_ser`
- * which is handed over to the next kernel via the KHO mechanism.
+ * The state is serialized into packed structures (struct kvm_luo_ser and
+ * struct guest_memfd_luo_ser) which are handed over to the next kernel via
+ * the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
+ * This interface is a contract. Any modification to the structure layouts
  * constitutes a breaking change. Such changes require incrementing the
- * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
+ * version number in the KVM_LUO_FH_COMPATIBLE or
+ * GUEST_MEMFD_LUO_FH_COMPATIBLE compatibility strings.
  */
 
 /**
@@ -36,4 +39,68 @@ struct kvm_luo_ser {
 /* The compatibility string for KVM VM file handler */
 #define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
 
+/**
+ * struct guest_memfd_luo_folio_ser - Serialization layout for a single folio in guest_memfd.
+ * @pfn:   Page Frame Number of the folio.
+ * @index: Page offset of the folio within the file.
+ * @flags: State flags associated with the folio.
+ */
+struct guest_memfd_luo_folio_ser {
+	u64 pfn:52;
+	u64 flags:12;
+	u64 index;
+} __packed;
+
+/**
+ * GUEST_MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
+ *
+ * This flag is per folio to check if the folio is uptodate.
+ */
+#define GUEST_MEMFD_LUO_FOLIO_UPTODATE	BIT(0)
+
+
+/**
+ * GUEST_MEMFD_LUO_FLAG_MMAP - The guest_memfd supports mmap.
+ *
+ * This flag indicates that the guest_memfd supports host-side mmap.
+ */
+#define GUEST_MEMFD_LUO_FLAG_MMAP		BIT(0)
+
+/**
+ * GUEST_MEMFD_LUO_FLAG_INIT_SHARED - Initialize memory as shared.
+ *
+ * This flag indicates that the guest_memfd has been initialized as shared
+ * memory.
+ */
+#define GUEST_MEMFD_LUO_FLAG_INIT_SHARED	BIT(1)
+
+/**
+ * GUEST_MEMFD_LUO_SUPPORTED_FLAGS - Supported guest_memfd LUO flags mask.
+ *
+ * A mask of all guest_memfd preservation flags supported by this version
+ * of the KVM LUO ABI.
+ */
+#define GUEST_MEMFD_LUO_SUPPORTED_FLAGS	(GUEST_MEMFD_LUO_FLAG_MMAP | \
+						 GUEST_MEMFD_LUO_FLAG_INIT_SHARED)
+
+/**
+ * struct guest_memfd_luo_ser - Main serialization structure for guest_memfd.
+ * @size:      The size of the file in bytes.
+ * @flags:     File-level flags.
+ * @nr_folios: Number of folios in the folios array.
+ * @vm_token:  Token of the associated KVM VM instance.
+ * @folios:    KHO vmalloc descriptor pointing to the array of
+ *             struct guest_memfd_luo_folio_ser.
+ */
+struct guest_memfd_luo_ser {
+	u64 size;
+	u64 flags;
+	u64 nr_folios;
+	u64 vm_token;
+	struct kho_vmalloc folios;
+} __packed;
+
+/* The compatibility string for GUEST_MEMFD file handler */
+#define GUEST_MEMFD_LUO_FH_COMPATIBLE	"guest_memfd_luo_v1"
+
 #endif /* _LINUX_KHO_ABI_KVM_H */
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index c1a9621..d30fca0 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -13,4 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
-kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
+kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o $(KVM)/kvm_luo.o
diff --git a/virt/kvm/guest_memfd_luo.c b/virt/kvm/guest_memfd_luo.c
new file mode 100644
index 0000000..c242b1d
--- /dev/null
+++ b/virt/kvm/guest_memfd_luo.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ *
+ * Guestmemfd Preservation for Live Update Orchestrator (LUO)
+ */
+
+/**
+ * DOC: Guestmemfd Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * Guest memory file descriptors (guest_memfd) can be preserved over a kexec
+ * reboot using the Live Update Orchestrator (LUO) file preservation. This
+ * allows userspace to preserve VM memory across kexec reboots.
+ *
+ * The preservation is not intended to be transparent. Only select properties
+ * of the guest_memfd are preserved, while others are reset to default.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of guest_memfd are preserved across kexec:
+ *
+ * File Size
+ *   The size of the file is preserved.
+ *
+ * File Contents
+ *   All folios present in the page cache are preserved.
+ *
+ * File-level Flags
+ *   The file-level flags (such as MMAP support and INIT_SHARED default mapping)
+ *   are preserved.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * NUMA Memory Policy
+ *   NUMA memory policies associated with the guest_memfd are not preserved.
+ */
+#include <linux/liveupdate.h>
+#include <linux/kvm_host.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/err.h>
+#include <linux/anon_inodes.h>
+#include <linux/magic.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/kvm.h>
+#include "guest_memfd.h"
+#include "kvm_mm.h"
+
+
+static int kvm_gmem_luo_walk_folios(struct address_space *mapping,
+		pgoff_t end_index, struct guest_memfd_luo_folio_ser *folios_ser,
+		u64 *out_count)
+{
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	u64 count = 0;
+	int err = 0;
+
+	folio_batch_init(&fbatch);
+	while (index < end_index) {
+		unsigned int nr, i;
+
+		nr = filemap_get_folios(mapping, &index, end_index - 1, &fbatch);
+		if (nr == 0)
+			break;
+
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folios_ser) {
+				if (folio_test_hwpoison(folio)) {
+					err = -EHWPOISON;
+					folio_batch_release(&fbatch);
+					goto out;
+				}
+				err = kho_preserve_folio(folio);
+				if (err) {
+					folio_batch_release(&fbatch);
+					goto out;
+				}
+
+				folios_ser[count].pfn = folio_pfn(folio);
+				folios_ser[count].index = folio->index;
+				folios_ser[count].flags = folio_test_uptodate(folio) ?
+							  GUEST_MEMFD_LUO_FOLIO_UPTODATE : 0;
+			}
+			count++;
+		}
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+out:
+	*out_count = count;
+	return err;
+}
+
+static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct gmem_file *gmem_file;
+	struct kvm *kvm;
+
+	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
+		return 0;
+
+	gmem_file = file->private_data;
+	if (!gmem_file)
+		return 0;
+
+	/*
+	 * Only Fully-shared guest_memfd preservation is supported
+	 */
+	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		return 0;
+
+	/*
+	 * It makes sure that no memory can converted to private
+	 * even if it was initially fully shared (in-place conversions are
+	 * prevented).
+	 */
+	kvm = gmem_file->kvm;
+	if (kvm_arch_has_private_mem(kvm))
+		return 0;
+
+	if (mapping_large_folio_support(inode->i_mapping))
+		return 0;
+
+	return 1;
+}
+
+static int kvm_gmem_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	DECLARE_KHOSER_PTR(sd, struct guest_memfd_luo_ser *);
+	struct guest_memfd_luo_folio_ser *folios_ser = NULL;
+	u64 count = 0, gmem_flags, abi_flags = 0;
+	struct guest_memfd_luo_ser *ser;
+	struct address_space *mapping;
+	struct gmem_file *gmem_file;
+	struct inode *inode;
+	pgoff_t end_index;
+	struct kvm *kvm;
+	int err = 0;
+	long size;
+
+	inode = file_inode(args->file);
+	kvm_gmem_freeze(inode, true);
+
+	mapping = inode->i_mapping;
+	size = i_size_read(inode);
+	if (!size) {
+		err = -EINVAL;
+		goto err_unfreeze_inode;
+	}
+
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(size))) {
+		err = -EINVAL;
+		goto err_unfreeze_inode;
+	}
+
+	gmem_file = args->file->private_data;
+	kvm = gmem_file->kvm;
+
+	gmem_flags = READ_ONCE(GMEM_I(inode)->flags);
+	if (gmem_flags & ~(GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED
+				| GUEST_MEMFD_F_MAPPING_FROZEN)) {
+		err = -EOPNOTSUPP;
+		goto err_unfreeze_inode;
+	}
+
+	if (gmem_flags & GUEST_MEMFD_FLAG_MMAP)
+		abi_flags |= GUEST_MEMFD_LUO_FLAG_MMAP;
+	if (gmem_flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		abi_flags |= GUEST_MEMFD_LUO_FLAG_INIT_SHARED;
+
+	end_index = size >> PAGE_SHIFT;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		err = PTR_ERR(ser);
+		goto err_unfreeze_inode;
+	}
+
+	/* First pass: Count the folios present in the page cache */
+	err = kvm_gmem_luo_walk_folios(mapping, end_index, NULL, &count);
+	if (err)
+		goto err_free_ser;
+
+	ser->size = size;
+	ser->flags = abi_flags;
+	ser->nr_folios = count;
+	ser->vm_token = 0; // It will be set during the kvm_gmem_luo_freeze()
+
+	if (count > 0) {
+		folios_ser = vcalloc(count, sizeof(*folios_ser));
+		if (!folios_ser) {
+			err = -ENOMEM;
+			goto err_free_ser;
+		}
+
+		/* Second pass: Fill the metadata array and preserve folios */
+		err = kvm_gmem_luo_walk_folios(mapping, end_index, folios_ser, &count);
+		if (err)
+			goto err_unpreserve_unlocked;
+
+		if (WARN_ON_ONCE(count != ser->nr_folios)) {
+			err = -EINVAL;
+			goto err_unpreserve_unlocked;
+		}
+	}
+
+	if (count > 0) {
+		err = kho_preserve_vmalloc(folios_ser, &ser->folios);
+		if (err)
+			goto err_unpreserve_unlocked;
+	}
+
+	KHOSER_STORE_PTR(sd, ser);
+	KHOSER_COPY_TYPEUNSAFE(args->serialized_data, sd);
+	args->private_data = folios_ser;
+
+	return 0;
+
+err_unpreserve_unlocked:
+	for (long i = (long)count - 1; i >= 0; i--) {
+		struct folio *folio = pfn_folio(folios_ser[i].pfn);
+
+		kho_unpreserve_folio(folio);
+	}
+	vfree(folios_ser);
+err_free_ser:
+	kho_unpreserve_free(ser);
+err_unfreeze_inode:
+	kvm_gmem_freeze(inode, false);
+	return err;
+}
+
+static int kvm_gmem_luo_freeze(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_ser *ser;
+	struct gmem_file *gmem_file;
+	struct kvm *kvm;
+	struct file *kvm_file;
+	u64 vm_token;
+	int err;
+
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
+		return -EINVAL;
+
+	gmem_file = args->file->private_data;
+	kvm = gmem_file->kvm;
+
+	/*
+	 * Obtain a strong reference to kvm->vm_file to prevent the SLAB_TYPESAFE_BY_RCU
+	 * file memory from being reallocated while it is being processed.
+	 */
+	kvm_file = get_file_active(&kvm->vm_file);
+	if (!kvm_file)
+		return -ENOENT;
+
+	err = liveupdate_get_token_outgoing(args->session, kvm_file, &vm_token);
+	fput(kvm_file);
+	if (err)
+		return err;
+
+	ser->vm_token = vm_token;
+	return 0;
+}
+
+static void kvm_gmem_luo_discard_folios(
+	const struct guest_memfd_luo_folio_ser *folios_ser,
+	u64 nr_folios, u64 start_idx)
+{
+	long i;
+
+	for (i = start_idx; i < nr_folios; i++) {
+		struct folio *folio;
+		phys_addr_t phys;
+
+		if (!folios_ser[i].pfn)
+			continue;
+
+		phys = PFN_PHYS(folios_ser[i].pfn);
+		folio = kho_restore_folio(phys);
+		if (folio)
+			folio_put(folio);
+	}
+}
+
+static void kvm_gmem_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser = args->private_data;
+	struct guest_memfd_luo_ser *ser;
+	long i;
+
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
+		return;
+
+	if (ser->nr_folios > 0)
+		kho_unpreserve_vmalloc(&ser->folios);
+	for (i = ser->nr_folios - 1; i >= 0; i--) {
+		struct folio *folio;
+
+		if (!folios_ser[i].pfn)
+			continue;
+
+		folio = pfn_folio(folios_ser[i].pfn);
+		kho_unpreserve_folio(folio);
+	}
+	vfree(folios_ser);
+
+	kho_unpreserve_free(ser);
+	kvm_gmem_freeze(file_inode(args->file), false);
+}
+
+static int kvm_gmem_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser = NULL;
+	struct guest_memfd_luo_ser *ser;
+	struct kvm *kvm = NULL;
+	struct file *vm_file;
+	struct inode *inode;
+	struct file *file;
+	u64 gmem_flags = 0;
+	int err = 0;
+	long i = 0;
+
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
+		return -EINVAL;
+
+	if (ser->flags & ~GUEST_MEMFD_LUO_SUPPORTED_FLAGS) {
+		err = -EOPNOTSUPP;
+		goto err_free_ser;
+	}
+
+	if (ser->flags & GUEST_MEMFD_LUO_FLAG_MMAP)
+		gmem_flags |= GUEST_MEMFD_FLAG_MMAP;
+	if (ser->flags & GUEST_MEMFD_LUO_FLAG_INIT_SHARED)
+		gmem_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	err = liveupdate_get_file_incoming(args->session, ser->vm_token, &vm_file);
+	if (err) {
+		pr_warn("gmem: provided VM FD token (%llx) on preserve is incorrect\n",
+						ser->vm_token);
+		goto err_free_ser;
+	}
+
+	if (file_is_kvm(vm_file))
+		kvm = vm_file->private_data;
+
+	/*
+	 * Release the temporary reference taken by the liveupdate_get_file_incoming
+	 * call. LUO still holds a reference.
+	 */
+	fput(vm_file);
+
+	if (!kvm) {
+		err = -EINVAL;
+		goto err_free_ser;
+	}
+
+	file = __kvm_gmem_create_file(kvm, ser->size, gmem_flags);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_ser;
+	}
+
+	inode = file_inode(file);
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			err = -EINVAL;
+			goto err_destroy_file;
+		}
+
+		for (i = 0; i < ser->nr_folios; i++) {
+			struct folio *folio;
+			phys_addr_t phys;
+
+			if (!folios_ser[i].pfn)
+				continue;
+
+			phys = PFN_PHYS(folios_ser[i].pfn);
+			folio = kho_restore_folio(phys);
+			if (!folio) {
+				pr_err("gmem: failed to restore folio at %llx\n", phys);
+				err = -EIO;
+				goto err_put_remaining_folios;
+			}
+
+			err = filemap_add_folio(inode->i_mapping, folio, folios_ser[i].index,
+						GFP_KERNEL);
+			if (err) {
+				pr_err("gmem: failed to add folio to page cache\n");
+				folio_put(folio);
+				goto err_put_remaining_folios;
+			}
+
+			if (folios_ser[i].flags & GUEST_MEMFD_LUO_FOLIO_UPTODATE)
+				folio_mark_uptodate(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		vfree(folios_ser);
+	}
+
+	args->file = file;
+	kho_restore_free(ser);
+	return 0;
+
+err_put_remaining_folios:
+	i++;
+err_destroy_file:
+	fput(file);
+err_free_ser:
+	if (ser->nr_folios) {
+		if (!folios_ser)
+			folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			kvm_gmem_luo_discard_folios(folios_ser, ser->nr_folios, i);
+			vfree(folios_ser);
+		}
+	}
+	kho_restore_free(ser);
+	return err;
+}
+
+static void kvm_gmem_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_ser *ser;
+	struct guest_memfd_luo_folio_ser *folios_ser;
+
+	/* Nothing to be done here, if retrieve_status was successful or errored,
+	 * Cleanup is taken care of in retrieval call.
+	 */
+	if (args->retrieve_status)
+		return;
+
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
+		return;
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			kvm_gmem_luo_discard_folios(folios_ser, ser->nr_folios, 0);
+			vfree(folios_ser);
+		}
+	}
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_file_ops kvm_gmem_luo_file_ops = {
+	.can_preserve = kvm_gmem_luo_can_preserve,
+	.preserve = kvm_gmem_luo_preserve,
+	.freeze = kvm_gmem_luo_freeze,
+	.retrieve = kvm_gmem_luo_retrieve,
+	.unpreserve = kvm_gmem_luo_unpreserve,
+	.finish = kvm_gmem_luo_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler kvm_gmem_luo_handler = {
+	.ops = &kvm_gmem_luo_file_ops,
+	.compatible = GUEST_MEMFD_LUO_FH_COMPATIBLE,
+};
+
+int kvm_gmem_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&kvm_gmem_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register luo filesystem handler: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+void kvm_gmem_luo_exit(void)
+{
+	liveupdate_unregister_file_handler(&kvm_gmem_luo_handler);
+}
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9c3dd1..e8e2f10 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6581,6 +6581,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_luo;
 
+	r = kvm_gmem_luo_init();
+	if (r)
+		goto err_gmem_luo;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6594,6 +6598,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_gmem_luo_exit();
+err_gmem_luo:
 	kvm_luo_exit();
 err_luo:
 	kvm_uninit_virtualization();
@@ -6625,6 +6631,7 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_gmem_luo_exit();
 	kvm_luo_exit();
 
 	kvm_uninit_virtualization();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 8719871..1295ff8 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -103,9 +103,13 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 #ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
 int kvm_luo_init(void);
 void kvm_luo_exit(void);
+int kvm_gmem_luo_init(void);
+void kvm_gmem_luo_exit(void);
 #else
 static inline int kvm_luo_init(void) { return 0; }
 static inline void kvm_luo_exit(void) {}
+static inline int kvm_gmem_luo_init(void) { return 0; }
+static inline void kvm_gmem_luo_exit(void) {}
 #endif /* CONFIG_LIVEUPDATE_GUEST_MEMFD */
 
 #endif /* __KVM_MM_H__ */
-- 
2.55.0.rc0.786.g65d90a0328-goog


