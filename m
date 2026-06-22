Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792D5CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010BC6B009B; Mon, 22 Jun 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A696B009D; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67656B009E; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 540466B009B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63A46A0253
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:07 +0000 (UTC)
X-FDA: 84908435934.11.C07DB44
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90F9E1C000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eqgTXtC3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3n4M5agkKCOQZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3n4M5agkKCOQZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxmxXtXLX2FKIn/jikNfDJMM+jo3cX9aru0TaotD/JM=;
	b=5MoJA8jztyIf7a8sf3GhmP+vs75kc8niUL1oGmQLiNslcHsMVDozjoR76e+6rNJxvZgNDm
	kj61AhaOK21hSE4HirJEwCUCJUwd90sLJvzhqK8oKdgWfkSVFZRm1le2j44rx6U3XqzJHg
	ff/wais2bBA6J0P1a8jXos3dYzUOITw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eqgTXtC3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3n4M5agkKCOQZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3n4M5agkKCOQZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154145;
	b=oeNbcALuwFP2H8VFwaY7dSWwDnpjUYJ4FOdUXXH7Ha1s12NfeqA2vBRBcyM4wC8ayZ++ul
	HeXFsVfCqG6L4nH1kwSuUjmlPG5JiOil2uQKkBVus1FNvcBtLY/xnDFSfYX9GopjdfF/Lh
	CCTFB2fNRzr1OT8SGuQKx9SDaj/E57w=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b9cd54f3so30705915e9.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154144; x=1782758944; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uxmxXtXLX2FKIn/jikNfDJMM+jo3cX9aru0TaotD/JM=;
        b=eqgTXtC3c5/6rq6i2cQbTnYVS2THQ9Oddq/IdstqHBQjQvDd4VGwFyJ2t4VF5Ebmb5
         7euRhvlyvgNF1LlLdQkSYs9u0Ltkq/QkVrsSAdCNy0mH7qcbNgSU9dlFAl9/Qb27KmuD
         gfDhWSTc6ri/UTsZl18cnEccKRxiM0LKy5UnHKycT2353okiXGvhclDR8kSO4FrjtgtS
         gVUwbL31BFfzY+O6EpnOB9jrYYqgE++RBGubZ4YeTJDe4jD/DnoBvWZJgAqFmH3h5Spr
         1Fa8TRAul8yEdz+7aWbN20J/Yom4sTYHO7COkAnzZLTHb1ymVYvmdEM2TtFG/AASd8Lc
         U3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154144; x=1782758944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uxmxXtXLX2FKIn/jikNfDJMM+jo3cX9aru0TaotD/JM=;
        b=VL737pTo3RZUIJfpRmWt+CfS4S1EfEYAogNNqa+oYltAxEKxnvVmHcqcv/YncRqjCm
         YOMnlw9RRy2UiQ281TMp05uUj9TEcHnna/gmdHp68QvkynLSD/KQIEFZNaov/zuwOd/b
         4Tov3Wj/ME/tUKVqYBRXSMlhWeYr8q7E2UMP5PNi4SW/sUPqfrkQnCDVyjgEugOTCY8y
         M1plPvpVAvui1RPBfr3We2GpYnpAp8u5rocPSSkJRU6eEH2ZgzWMT8KBYYxVHxXrWHSZ
         +vSzCWmxR7GUBMYQ5PSgCSjJowGGQ+W2p9CND+IiKF7tgOPapaU1b4Fu5aKGnBzez7pq
         aXog==
X-Forwarded-Encrypted: i=1; AFNElJ8T/XWw5EUFgEhcxo0L5nb6vM8zjFcIAOBStclpEudm6x7HhD37MsWr4WKJLXaExBKFxPjdM86RRQ==@kvack.org
X-Gm-Message-State: AOJu0YxZ2n1OazhADISB5uBoqiE5PWBXdboI/webU3hFB7eLKyULd5wq
	rO21m5lVMo35iHxCU98+3r9y4qaYynDuLvO2uXO/0ZAX+W97eTQZ0pTgBR50nyjp0voV4WVzETw
	p9+VsTW75E2coSjRS+A==
X-Received: from wmix10-n2.prod.google.com ([2002:a05:600c:e54a:20b0:492:4a6f:ac6d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b74:b0:492:348:ba08 with SMTP id 5b1f17b1804b1-4923f44035dmr253038125e9.16.1782154143613;
 Mon, 22 Jun 2026 11:49:03 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:45 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-4-tarunsahu@google.com>
Subject: [PATCH v3 3/9] kvm: kvm_luo: Allow kvm preservation with LUO
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 90F9E1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5yikhcqpr45k7uip1m1pc4c8ywy1f5zr
X-HE-Tag: 1782154145-904599
X-HE-Meta: U2FsdGVkX19BoCp1L64W55zZrI2gzW6wURz2qlZkU8m23zpe+nEOCi0XGeSmuC9VevtiEVhOh/GI1ZkC5W7/xl80arQ6NAWmgN3c/HX/R8zEdqPtgi75e+NgpOTZmyYYrkt2mKn25lbbhcTUZ0+qwsi+oKLeOp2LLCaZlEb5c/RD2B40UgbMTViGr0pxYA0svl0/mVjK1Sz5xSOALCTbzk+Vv05TPMKtuXPJTBjqk0LV7L50vJMigJks/EmcIIQN936QeehtPzUfNCwR2iUR9LK1BfKnCm8fqAyGKfS9RwY+GxLBN0M3eG6/AvAn64mlVA2lXUJNSjcq8txNzaB7lIfxavsVEYhcggl9UTFeZd1WTOjYjDY0o6yyipvpty53rOgkZS7BOtPFw4hoDlguF/D7LexS9YeCBz2lZDxNXLrSFZ7zZVGlK4lfEL7QwvmDggNEd5xRSDPHNnQ3qcCHYcgt7Ajh7O0p7MvlihRIJUXhkwyrLM/JCfzkgLIPwx7kYpAAItQySq5qkEkuyRdNe0pxMjyInjU4e/54riR0eN/x8sP1/Sr5SiUB7oNxMXepW/jJ0uaYyB1uyN3tUxLl8RAwGxZmdK0Sn78bxsyBuHWtJKACuaPCWp9VO0gRNhSuF8SAv5PsTLJD3Hp8KtenOasR87WOH8Am1iZ346ADYlEA1EyyiPcTsA1kD+wZqyYHZiiuZYpLc8pPJ9yPRnORxmQaOnRI7Rq0MlbFQ7fNAuNu19i5QTV6sO4piP7unet3qovoV1mBVI3cQ683qZV5UAmy1PRtjdMPWquO+AMjTea9LTyDVq6JKh7j6qhgLNCT0Kl0OTuSy+bov7xDewFAhUfwIx8os2UTZv5S9L2RhJHdv4fXgswNqecgta4Z920l4sVRnIAD9Nmc0MDf+xSQz982xIO83Qmu/Jvs23S/dc6+f9z4nsYv5bvbiQilZuw7j3nxRBgRwOIbAfVaYF4
 7Fbi9iQH
 AKzy/CRBpWTHKD0Llaly+3i/TNjEXfcpgCETP0V4pIy++oYBrADuKNDMEWNjgZTc2Tx9GjYLKJCXsq7FLz6Ub3Vb/tWpeC/h7DepGVR+PP+pR/6SgjwFql/bYfVcBeQ4efE6TmKS+KQil7vuKe/Hj2RaKueC38Aa9U0Rb/oGTynoCmKo9EV53KRKPvw92sdjbe1sYr/Iy+fjv8o8nISKtveZ772HcooY5UzDpakIJgO2uGQj7sJUSJWtUE141JgTuPqwQB1v3Mz/PTyzQTmA3qzjrKUqY22G5/Aovcv/6T8W3fsJQUzYd4XblQmU5POs+v0L6KeRQFvpc94YOl8mPXoSr8A/UyKbRF724C/4/Ahw+w4Pm89MMfISz5hYUbEXGyTxtFmWwp2g6zmN2sZwHut10Og1UvBZYCFq4zeSLvYvsy0DLNlYkSHXb/iCuPmW66mThZQVOeaa26KBz2GTIAdofnpI9H296XxaeEAH6roihVEMSHxfpGh0duIoBledbEcNaIURmgzty0flfWPyxYEE5Hi/e8xczkoIJwcRM+j4hQStSvKQYQjS7WlS0pK6eBQOLgIyyWK3eLJy/FCFvsWfIcJ5H/p46Vf1gH1z1i9wTDOVfvdUyxiktBWR8HCze1LZ1i8GFw8SpTtk/jzNF1DgAFBerB6NRrVsFaEHFLPpbb8Q3EHF9IMiDr20uUUSYbw+/Bwj/BfWTu2qTzQetRTgweRG4TwVk9lpx/ZyvRjaA+b9ID41mXk7SreBnbCoroiNUWq91ifau+lYLfreR5gX2pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce KVM VM preservation support for Live Update Orchestrator.

Register an LUO file handler for KVM files to serialize and
deserialize necessary VM state across live updates. Currently, this
preserves the VM type. This implementation provides the necessary
infrastructure and dependencies for the upcoming guest_memfd
preservation support. And it can be extended to preserve more vm
state in future.

Retrieve is simply creating the kvm and populate the retrieved data.
Only catch here is there is no way to know which fd is going to be
assigned to this kvm file hence I am using atomically incremented id
for the fdname.

This change also updates the MAINTAINERS list for kvm_luo.c.

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
index 5dbc8a6..7c000e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14411,6 +14411,17 @@ S:	Maintained
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
index 0000000..718db68
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
index d047d4c..c1a9621 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -13,3 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
new file mode 100644
index 0000000..6728877
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
+	DECLARE_KHOSER_PTR(sd, struct kvm_luo_ser *);
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
+	KHOSER_STORE_PTR(sd, ser);
+	KHOSER_COPY_TYPEUNSAFE(args->serialized_data, sd);
+
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
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
+		return -EINVAL;
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
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (WARN_ON_ONCE(!ser))
+		return;
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
+	ser = KHOSER_LOAD_PTR(args->serialized_data);
+	if (!ser)
+		return;
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
index 14c3254..d9c3dd1 100644
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
index 6241617..8719871 100644
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
2.55.0.rc0.786.g65d90a0328-goog


