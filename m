Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC39C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A76D6B00A1; Tue, 28 Jul 2026 08:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357BF6B00A2; Tue, 28 Jul 2026 08:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247306B00A3; Tue, 28 Jul 2026 08:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C88636B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13EC6120378
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:50 +0000 (UTC)
X-FDA: 85038071580.22.4BBC597
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5D58B4000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5qVOnaK;
	spf=pass (imf11.hostedemail.com: domain of 3gpxoagkKCLcqXorkpXerdlldib.Zljifkru-jjhsXZh.lod@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3gpxoagkKCLcqXorkpXerdlldib.Zljifkru-jjhsXZh.lod@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQr+6fiwmjAuN9/wTMWLnl7iWSgvc3fwt3jZTZM3qPg=;
	b=KpG962OU2K3d+ghAI10QDBjWQh2UiRVx4KErWGgO33PaGOTDwAgaNVbCvTrOgPBW8McHoa
	t93gcoe1faalf41AlzslKcbdjXvbgxltb8rjUUU/iLRuEomLkd3NOdwddWZ/PvYd6GMb9s
	jv4S8xGF7uA/zOrQU7/0IYH8MuRsHws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5qVOnaK;
	spf=pass (imf11.hostedemail.com: domain of 3gpxoagkKCLcqXorkpXerdlldib.Zljifkru-jjhsXZh.lod@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3gpxoagkKCLcqXorkpXerdlldib.Zljifkru-jjhsXZh.lod@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240708;
	b=6YVn2/7Cu7Z6WUtEATHLmzALyrcOdGmfuvT2RrMx1MS7lzwTwOUQYB959CT7RhstUW//NA
	MUzcSJBlzcIHe4vRSthTrdAZ3rSKrOrI5EmF9foZO+PT9Ry7JUNy4FDb7Tg9Dh0AQkgD2d
	91VKcKCzuMePz/YwIIGuKlyNnpjUlUk=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69fc66f110eso877377a12.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240707; x=1785845507; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hQr+6fiwmjAuN9/wTMWLnl7iWSgvc3fwt3jZTZM3qPg=;
        b=L5qVOnaKiSsCN+3aBWQ5IbQ13sKFtLfFpoeY+2th2m4hAZdNDGa44Sf2KiJqPysLCQ
         BEheOTm1MiLaFRHL0au5zAzwws3AVRQYTPG3bON/LPD07t/anutO9k6mOjl7BmhfGQiv
         WG4eeruB/7+GoNMcv6FlmzViPro2JE0mYHVC9VCvcqGIkiKD/xkhegaa99VZjHA4dn/q
         iahZS+ibRmqPcYV9C3pjUx2ui5llVfxipHCs9s4f1Tu/aGKgRYIuQyj4Io7bxzQ4n+hy
         IggP054q0nPajVbpzb8AmPtzdt2zeEP/qrDlte8hyh3L/M080wWsEy8vco18gcmJvbTa
         ppzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240707; x=1785845507;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hQr+6fiwmjAuN9/wTMWLnl7iWSgvc3fwt3jZTZM3qPg=;
        b=I38GqjeXECzo3pqkQmPHZC/KKdq1FAb0VE0mig5ViLmrBHY1NiUdMxRPSQPp215D0U
         9RmA0r/HFLRsuzFvqcEIlmZ9a6pRmWh4taCQuyIHU8RaV0X5YzKR1ryYtyaLY2QmAnnL
         NgLTaxaFIsjp/Uw9f4ZXJEIkwxddRCVBsFsNDc/6Puv8BGz2hDgdrnhF1zlPFt4abyr8
         Sja13cn5fypLAz0oB1wY5nQnhL+gbKRS5l8ShQWyRGIT84fHoVKFPEoUQJJmTKQxYPBe
         l07udwzW8C5r1ViXhStlVKVnb/9Zm9tVNkKQTqhlEw4Cq67iWNLvzLiz7ouQQqr22cXx
         b7cg==
X-Forwarded-Encrypted: i=1; AHgh+RrKnUVwL39uD2cCespPQ9qKy7rTCl8fesDwWKVytPpzZ2SACJ2gHKsITA0t+3KVAb189FKGz93a1w==@kvack.org
X-Gm-Message-State: AOJu0YyAnCfzmJEx9HvCnMJ/DDZAK0nQLGqSbhhhJDXqrff+HwJ9/x7p
	+HBoJTvsUibjgDEAnFUd8KZHPPcIwiLG8rsOORSzrFmlnZTVxYdvR5eOz0u9ZadmkQLWxdTPnit
	lhlMU+G1M1Uzf8btpcQ==
X-Received: from edgc8.prod.google.com ([2002:a05:6402:a608:b0:697:e97f:2f91])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3604:b0:69f:c929:b88 with SMTP id 4fb4d7f45d1cf-6a0349ec474mr1201988a12.5.1785240706549;
 Tue, 28 Jul 2026 05:11:46 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:32 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-6-tarunsahu@google.com>
Subject: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5D58B4000A
X-Rspam-User: 
X-Stat-Signature: k6u9roxbwye5t1a581tm1hzrzwh3gb4d
X-Rspamd-Server: rspam04
X-HE-Tag: 1785240708-206289
X-HE-Meta: U2FsdGVkX19QQjLf8S/25EUpF0hDUy9TuJ1F0KaOhCEAADonAyb3hBnJtJFIk06VHIw8ELpYI5u8Eu3Gcou4gevUQySj+w6gLwQGQPfLBFMLgCu+0NhbGI0zv16+uSds0JuDYKxJz/aLGaGkrl9RK7DjJr8H9qSYf0BlcS73mYSsmI71T1hN+70/uSRurNxuEMM0ivfJZ0g3YjodPvxBcEFY3FZ1Tlq6zpgbB9i3qG5s0KezzD/ULOgZN92ju2+VBwGjUD+RF31Yd4MHxtvynFU6a33bsg+b5DTfXmg/KkvaIesU4FMAnC7qEhu1OQvrKElJnv7CFzLoSKUcrKYo+Kqxpa5prm9uOC/VYocM6bKjoEOMKPcf77J04Tp4LQMD9WKNVuqpCx4S7mjQia1oMy0Q3VnWL/Hxn/qfwwVd8ORK0SJBKiQeYO5GMnhdYlNQD9tcJ9woSwEqGolNty6tWt9wp2L1fTbb0KsVUYdLhpFq1iFrMTbXyhfAK/QP9UyoKdCs+serhE0MxT+Z693xV+vFca6T/v4LbizcvTO99bFhRzVNFAySY3J/iqimWEnmFidsuY7IEgZNHc6mGQER6Oe/h0iFcBU+wZZA4zYqaY1tdtnGUzEmP9uT0P4p9F94l5aH6mFcProynb/Ad55EzbPrbmp/YXkV2E/6CTebD3ZEAyoI6Y0t8sN5X1OKHBffPeYoMB1gOFerk2dx5jc01Jm6Kqc18yCmuBZ7B0E+AA3pNa7wntv0fiPFJMqH/sxM+KfwcixsVWgWKRl/5nObXbQw8MHwgfi9HspmhIDnUKprlR0jPOQio6U8NCoByz54MIHltGLpiJlkC0pCbTKlNECgSIYVPP4PUDcWo9xAdcGDKKf7q2wrUWrOdgUJmbqC23bwHQd177YN4kwvcSzi6Xg5dg6qqV1PbW22sLbYFcLNPf3BSz6OFvsoEh7MIR507C3kyxv0wyou43zMmVp
 Y0z1FcvA
 6UB7/eQRmGminv6t/1q+ZGL9Um2SRSGGkL/moJuCnKOcXBBQEO2rePwytnNqnRC9L3HQfQXk8CyDjQ66Y3QD0AyQlf+TOJ/Yu9LIANl86NG/BUlNtVxOxbSLYxZnFp+g3MOclYdatibXsQ+8hvZqM6Goxz983MezXZ3uzH+YQf0x+fY0+EqHcg5CAyp0Ev0AT9ifs43pvePidQ6YYcmUjoFolv/gdOfbiNhWAu9+ZANPBudk0lCGV4UtG97qjFrHojz2NbD8sk4MjgpzmYkkjwWr0PEhecdII7URoG4xxluEYmeYk2Qk3w/bX2+sjkXt/KO0Nr28DgPy8q1asJkWU9bPOmx8pA2Gt3/8vSnHeoAdjEgcZHawylMPTOdozGpemMUF3vgfvR28MihwbUMydfcBxJv6dpvSFkPSvIjH9i44U1gFdRTr/nLMeGATjZZIy0UKGfPZ+A7Cpy8QEXxK4r/4ny4NToTJdqmvh5s5AYU1yUhISKCfP6HsifWs7cE8hmoOjM+8pQrFFgr6kIf9q+fhmga7pFh7+N5DeLsqo4TCicXt/6avhwFA3dFxLy1aplqjSrWI2LtzlwwLQ5Q5dgdeF4/Mm2EKHKQ8ocKdX136gDn3eYmk7V+JzBW+DT6/Q6g+dTF5Od/w7uJRykzZ8oKg3GFErStRFQdMP98qzj+CVZXo8CzyDy3bxNNQczl9MJ5iTcOo0cozy7KfePE6jyyxElPhHwENDhIr7jUqVv6tvA6z7LG/wydwQmoNMMBUrIFyYIoBBlNX5kh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a Live Update Orchestrator (LUO) file handler for KVM VM files
to serialize and deserialize VM state across kexec live updates.

Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
of VM preservation. On retrieval, kvm_luo_retrieve() recreates the KVM VM file
via kvm_create_vm_file() and use an atomically incremented ID for the internal
fdname, as the final fdname assigned by userspace is not yet known during
retrieval. As this fdname is only used in debugfs infra, This will not
break any UAPI.

This infrastructure establishes the foundation for preserving guest_memfd
instances across live updates, and can be expanded in the future to
preserve additional VM state.

Also updates MAINTAINERS to include virt/kvm/kvm_luo.c and
include/linux/kho/abi/kvm.h.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                 |  11 ++
 include/linux/kho/abi/kvm.h |  39 ++++++++
 virt/kvm/Makefile.kvm       |   1 +
 virt/kvm/kvm_luo.c          | 195 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c         |   8 ++
 virt/kvm/kvm_mm.h           |   8 ++
 6 files changed, 262 insertions(+)
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 virt/kvm/kvm_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a3ed337e827d..0283f0fd6ef4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14539,6 +14539,17 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/leds/backlight/kinetic,ktz8866.yaml
 F:	drivers/video/backlight/ktz8866.c
 
+KVM LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Mike Rapoport <rppt@kernel.org>
+M:	Pratyush Yadav <pratyush@kernel.org>
+R:	Tarun Sahu <tarunsahu@google.com>
+L:	kexec@lists.infradead.org
+L:	kvm@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	virt/kvm/kvm_luo.c
+
 KVM PARAVIRT (KVM/paravirt)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 R:	Vitaly Kuznetsov <vkuznets@redhat.com>
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
new file mode 100644
index 000000000000..718db68a541a
--- /dev/null
+++ b/include/linux/kho/abi/kvm.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ *
+ * KVM Preservation ABI for Live Update Orchestrator (LUO)
+ */
+#ifndef _LINUX_KHO_ABI_KVM_H
+#define _LINUX_KHO_ABI_KVM_H
+
+#include <linux/types.h>
+#include <linux/kho/abi/kexec_handover.h>
+
+/**
+ * DOC: KVM Live Update ABI
+ *
+ * KVM uses the ABI defined below for preserving its state
+ * across a kexec reboot using the LUO.
+ *
+ * The state is serialized into a packed structure `struct kvm_luo_ser`
+ * which is handed over to the next kernel via the KHO mechanism.
+ *
+ * This interface is a contract. Any modification to the structure layout
+ * constitutes a breaking change. Such changes require incrementing the
+ * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
+ */
+
+/**
+ * struct kvm_luo_ser - Main serialization structure for a KVM VM.
+ * @type:         The type of VM.
+ */
+struct kvm_luo_ser {
+	u64 type;
+} __packed;
+
+/* The compatibility string for KVM VM file handler */
+#define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
+
+#endif /* _LINUX_KHO_ABI_KVM_H */
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index d047d4cf58c9..c1a962159264 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -13,3 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
new file mode 100644
index 000000000000..025b53151b6a
--- /dev/null
+++ b/virt/kvm/kvm_luo.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ *
+ * KVM VM Preservation for Live Update Orchestrator (LUO)
+ */
+
+/**
+ * DOC: KVM VM Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * KVM virtual machines (VMs) can be preserved over a kexec reboot using the
+ * Live Update Orchestrator (LUO) file preservation. This allows userspace
+ * to preserve KVM VM state across kexec reboots.
+ *
+ * The preservation is not intended to be fully transparent. Only specific
+ * VM configuration and state are preserved, while other aspects of the VM
+ * must be re-established or re-configured by userspace after retrieval.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of the KVM VM are preserved across kexec:
+ *
+ * VM Type
+ *   The VM type (e.g., on x86 architecture, the vm_type parameter) is
+ *   preserved.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * The preservation does not cover:
+ *
+ * - vCPUs and vCPU states
+ * - Memspots / Memory slot layout (memslots)
+ * - Interrupt controllers and IRQ routings
+ * - Coalesced MMIO zones
+ * - Device bindings (VFIO/Eventfds)
+ * - Active paging or guest registers state
+ * - etc
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
+#include "kvm_mm.h"
+
+static bool kvm_luo_can_preserve(struct liveupdate_file_handler *handler,
+				 struct file *file)
+{
+	return file_is_kvm(file);
+}
+
+static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm *kvm = args->file->private_data;
+	struct kvm_luo_ser *ser;
+
+	if (kvm->vm_dead || kvm->vm_bugged)
+		return -EINVAL;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+#if defined(CONFIG_X86)
+	ser->type = kvm->arch.vm_type;
+#elif defined(CONFIG_ARM64)
+	ser->type = kvm_phys_shift(&kvm->arch.mmu);
+	if (kvm_vm_is_protected(kvm))
+		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
+
+#else
+	ser->type = 0;
+#endif
+
+	args->serialized_data = virt_to_phys(ser);
+	return 0;
+}
+
+static atomic_t restored_vm_id = ATOMIC_INIT(0);
+
+static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	char fdname[ITOA_MAX_LEN + 1];
+	struct kvm_luo_ser *ser;
+	struct file *file;
+	struct kvm *kvm;
+	int err = 0;
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	snprintf(fdname, sizeof(fdname), "%d",
+		 atomic_inc_return(&restored_vm_id));
+
+	file = kvm_create_vm_file(ser->type, fdname);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_ser;
+	}
+
+	kvm = file->private_data;
+
+	args->file = file;
+	kho_restore_free(ser);
+
+	kvm_uevent_notify_vm_create(kvm);
+	return 0;
+
+err_free_ser:
+	kho_restore_free(ser);
+	return err;
+}
+
+static void kvm_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_luo_ser *ser;
+
+	/*
+	 * in case preservation failed, args->serialized_data will
+	 * be NULL and kvm_luo_preserve takes care of cleaning up.
+	 * If preserve succeeds, this condition fails and unpreserve
+	 * function takes care of cleaning up.
+	 */
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	kho_unpreserve_free(ser);
+}
+
+static void kvm_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct kvm_luo_ser *ser;
+
+	/*
+	 * If retrieve_status is true or set to error, nothing to do here.
+	 * Already cleaned up in kvm_luo_retrieve().
+	 */
+	if (args->retrieve_status)
+		return;
+
+	if (!args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_file_ops kvm_luo_file_ops = {
+	.can_preserve = kvm_luo_can_preserve,
+	.preserve = kvm_luo_preserve,
+	.retrieve = kvm_luo_retrieve,
+	.unpreserve = kvm_luo_unpreserve,
+	.finish = kvm_luo_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler kvm_luo_handler = {
+	.ops = &kvm_luo_file_ops,
+	.compatible = KVM_LUO_FH_COMPATIBLE,
+};
+
+int kvm_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&kvm_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register kvm_vm_luo handler: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+void kvm_luo_exit(void)
+{
+	liveupdate_unregister_file_handler(&kvm_luo_handler);
+}
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14c32541ae34..d9c3dd1afb05 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6577,6 +6577,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_virt;
 
+	r = kvm_luo_init();
+	if (r)
+		goto err_luo;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6590,6 +6594,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_luo_exit();
+err_luo:
 	kvm_uninit_virtualization();
 err_virt:
 	kvm_gmem_exit();
@@ -6619,6 +6625,8 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_luo_exit();
+
 	kvm_uninit_virtualization();
 
 	debugfs_remove_recursive(kvm_debugfs_dir);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 624161793fec..87198715fb01 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -100,4 +100,12 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 }
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
+#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
+int kvm_luo_init(void);
+void kvm_luo_exit(void);
+#else
+static inline int kvm_luo_init(void) { return 0; }
+static inline void kvm_luo_exit(void) {}
+#endif /* CONFIG_LIVEUPDATE_GUEST_MEMFD */
+
 #endif /* __KVM_MM_H__ */
-- 
2.55.0.229.g6434b31f56-goog


