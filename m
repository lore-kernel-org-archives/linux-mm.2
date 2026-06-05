Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE14CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E07F6B009D; Fri,  5 Jun 2026 13:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645AA6B009E; Fri,  5 Jun 2026 13:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534816B009F; Fri,  5 Jun 2026 13:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39E8E6B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0639416109B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:50 +0000 (UTC)
X-FDA: 84846493620.27.3DB2023
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DB31C000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BDdocTuZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3ngIjagkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ngIjagkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trlmXVdS31p5kQ7BefhczDlKJWOvBF99ud4hEtoc9eM=;
	b=NRkdH9y+kvmW55N6PXO8F18LTm55I8wIS6VLrCG+xhkXlOZhOnpRP2Fcw15ItaXBwHzuJ+
	MkWiL+aCy6jr7QknoN24k9Er56jOHs/+YM4TA7Uz9rN0ctrtc+v01OembyF1xEYnF2fxH2
	xuPfAjW0oCIcGmONAUlgMPSjA8l+4V0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BDdocTuZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3ngIjagkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ngIjagkKCIc4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679328;
	b=VWFk21KjbT0XDmsT/CDrwblt63bAYJl9SBrZPkEmS5LilrMpMjmziHXG/g2rRfFi7gYBe/
	qEqMz0hIbErJNmco5H9TQpP3duxOKM3l3ojYsbTWyGB7T/dG9/BLJN5m2iXW9g/W+cSBHc
	H7WRF33K0mk9ANMTbShCD+26s2d7tec=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6913ff0f1f7so293442a12.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679327; x=1781284127; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=trlmXVdS31p5kQ7BefhczDlKJWOvBF99ud4hEtoc9eM=;
        b=BDdocTuZscnGjG+yr/muNsh1RP7rSWXChFTnT6gR2Ife7tHGwOs0OYK+ZZFQiFJ3yo
         g/E2p6mMrB5px0hoDh6s0BhQ2+HG6TL+NDACnvj6sRtkh12nDl+Wt2bAFn/R8m5mqZ5k
         B3b4uPwP5jKguulBsdeLKjmXqCqfKIr/jBD87XKECRTN1BYs5+bxspc4cz9F+YNEg4nV
         1eQiPbRrGj8ADDNpWoC27Rb5vIZJ9SwSZh6tjZ7qjo1M+B6AuVcDXqQW/7Mfuu1YTXHy
         aQcYxKPqiRd2YAhHO2PaTYNOrvVaEdh8iy+CwfkBGn7P8kLzroxooYbmNS8ay81zIAkA
         N4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679327; x=1781284127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=trlmXVdS31p5kQ7BefhczDlKJWOvBF99ud4hEtoc9eM=;
        b=ZvD1iUWuEQsVFmCObY/hg5bscmm+3OdE0uf2wb7H3EkTn2161nnXo+8e9XBy5c4R4W
         YWqAYn72O0UTS9agP5dhD7ekmr77ySaDANLjBRb0Rs2wpKEYIAZXoEHmYjbsNn6Zsqmi
         U4eejvQNJlLqzrJcYN2D/1t+2/iQqC6WzNLrKOS+/9RsqruRw1hwIKNEhat1ZjUexklz
         h0fKaA1GExj/0wmuxOEL+RYwoeAbXqeYBMK1ONqFOqC/6Yh1fVbseLLvskf14Psye8wu
         A3lqyf2wYiJtJdjxvrUSv14JtGf6+6SWWDs8jjO/peiFPbvfKMPS3I//R3Bf0YTYXC1D
         njAg==
X-Forwarded-Encrypted: i=1; AFNElJ8+GDbwy2fITDLerwZM/kA/DD+adXqDKD+JK5TW76hTSx8y6mvOxgqZW9//ydD+iyGSvqMwE+NFbw==@kvack.org
X-Gm-Message-State: AOJu0Yw63CpHUyCHosZxatn1QP9Vz8aH1FwFnbSHiVrS1ydath0aY8Lf
	tO0pR/c5jW9lpzhOV7nEgwqauoP34fpICkNm5rG04xusE+xhdq8LbvCNqX0EQRQ/o60KiDx7X6J
	6YkFolGok7nOVdNIMuQ==
X-Received: from edrw9.prod.google.com ([2002:a50:fa89:0:b0:68a:be8f:3c00])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:d0d:b0:67c:6836:7b0a with SMTP id 4fb4d7f45d1cf-68fa525c09fmr2301648a12.23.1780679326308;
 Fri, 05 Jun 2026 10:08:46 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:29 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <8730c0e11acbd0d645a8b7187cd5cd7de373380e.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 04/10] kvm: kvm_luo: Allow kvm preservation with LUO
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2DB31C000A
X-Stat-Signature: yma95t4wzagqx7ahn59mu3p8so49yuo9
X-Rspam-User: 
X-HE-Tag: 1780679327-120807
X-HE-Meta: U2FsdGVkX19/aqZ08WnPKp7G+iQBk/CSzjxdVfXNpsoEpKw8fv0aA1eabZvKbIpex3XWlh6j2kANjGKsRpda9abjAInl+4YtkCAVJXbIqp3CJg59Coi0130SomEZINMHi5PgNaZ+Nb6P5O4BnF6nz5RlOQwLtcJ9xIGFlW7MzGLam0Kb6DsE1t1JnsTI13RUAII5kRtV5kjXtP2gR3uFLFJgF9DFczia336Dv1r/GMWVdCdxqD6zlp/YwGhtTE7FQCS3vshTQ7pZPF5nRS6X6pnel8Ndreh0ilcy5s654IEo0/9mQ6UG3Hbe5nzZhDy0syqyIs4B22ac7/HMkKDGLw2lz40oRJy6iSQ9OvCXAr7w6GFFHmqe9tfXHOrI6Ukm24AWW/v3FKnKy/vlIrodkqz8YCgrp8yR1/m32G2M/FJUTBGp22zlNDSghHH8j1R1gETDx/rH3uG1QxiIlB+hpL2nkKri8RjmX5lzAnOVthtPDQXVQ9hVtzCSN0gpI/4AW8trGnmn+oBDpw1D8zRkB3duivL/zVTVrxtBGST9wiimofDb2+bFcrh52dtOcqF5NkY+eJ7qYn5gYs7S3HSpXh1IzvfdtcD6a42Ax6EyPW7fXesszUv6SMr9tlkqABwHijuWRm2biKgFFK1FNBmeqbVDk+e/MiGiUgQjjqfBcinP3a1CGd4s5yoYsQ6ZJyeOcNdnvoUsrFh7z01VIqjdjjoJRVzgmlPhvgsEJTtKDN28m1eY4EuzZkEDzZOtAaWPJrC18Mt7P5PhIyrLKHyu7WvY0px0EZf0lRihj0gWts7EkfXQJXyfxdEStHCiNyGyLDuznKSxx51rEZfGpHLdVN4H7zqVk/Ao8STcCzsKqhx7C/sOogtzc8H70ie+DMhLpqFqc97XnWcUdp1o+v7rQzPnKm0xzclra4Tetp6buoZ8aA9wf0jMIfhA5rWPs500Y0IfogPmxpl6GJ97fTR
 BbR15IVq
 5MN/efZpGXLZURFkiz+GfdZuy5ra2xeuLe3drg3jMELSXWN9N/0H5i9gsa2c+Y/AiDTOT2wRNd3ts8JCurvwkQarLLRSuaj8CQmN39U4P8QobRurV03JDcCZfYN53DxgVfWwjTvQq2qb4OG3F+kKcXWZKvUTAxlX8hZJsTwdLdIMt+fPJQkg+Lp7cPokRufvjkzwPKcWhMfY3w/Eql8vAbuyzgmkpz+XC79MUCxT7xLgGhcDaeqHhyImEnn5oCvcXaQePRVQgC9DPU4ggl+OC+Z7RYqyOoCtLDRHGSiy0iVYU16h66I19oETs00TZSCc1Uk8MucBylGy/6O2aIMn3weR//z1vZifJSYd1YVP1FbOjPOpSF3o1qpEC/WCksX3MZyAbQ9BdIISBSfCkbermjU48agkgj4f7ekSWxxUf2ct/zcZaqv/TT4xfPgp8830gHa3heYmg+NO/4ii1XL4Qov9HNT20Cj1vsosAW+Nau4JOmqygJjkNW4SglXcAIdqf+Sh4INpt10BlkBiv5hAOOx/R5YUEtAgJIhC1vcjQYvnt4AFXOUXaNATjfbHx1F99Bo3CBhrkNLhzp4Hj1BQ3W071a59B/UsQe9DaKomiAlXpfTNGVZ0T8kdzsFsa8NecL1cfcnu+5P/gMubzL3z+h3k2RC5jKBS2831m6rvl/+KIKkZo3TJhOnNjP3aUWN9orVgMn7Eq+SdwC/sofjKppszCj6qpOO+laFUjJm1Wb5rWBlvm6EiSryIjP+r/U4sIhHNm0h3cjsNCT48h3sU5O2kblN5QOCmhFNcsdoqwN/6lvlK/8ffHEXr2AseyDFLRuXZ3YbkqBifwVI39vba8zndYtUof+33mBlcOXP6XsfjND40=
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
My only worry is if userspace strictly depends on the fdname, that it
needs to be consistent with vm_fd. Discussed more details in the
cover letter. Would really appreciates the alternatives/other approaches.
---
 MAINTAINERS                 |  11 +++
 include/linux/kho/abi/kvm.h |  39 ++++++++
 virt/kvm/Makefile.kvm       |   1 +
 virt/kvm/kvm_luo.c          | 190 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c         |   8 ++
 virt/kvm/kvm_mm.h           |   8 ++
 6 files changed, 257 insertions(+)
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 virt/kvm/kvm_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ec290e38b44..9bfc3c1f6676 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14409,6 +14409,17 @@ S:	Maintained
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
index 000000000000..25619f94ace5
--- /dev/null
+++ b/virt/kvm/kvm_luo.c
@@ -0,0 +1,190 @@
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
+#ifdef CONFIG_X86
+	ser->type = kvm->arch.vm_type;
+#else
+	ser->type = 0;
+#endif
+
+	args->serialized_data = virt_to_phys(ser);
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
index 65f0c5fb353e..c70346906a89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6576,6 +6576,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_virt;
 
+	r = kvm_luo_init();
+	if (r)
+		goto err_luo;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6589,6 +6593,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_luo_exit();
+err_luo:
 	kvm_uninit_virtualization();
 err_virt:
 	kvm_gmem_exit();
@@ -6618,6 +6624,8 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_luo_exit();
+
 	kvm_uninit_virtualization();
 
 	debugfs_remove_recursive(kvm_debugfs_dir);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 7aa1d65c3d46..118edc47df83 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -97,4 +97,12 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
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
2.54.0.1032.g2f8565e1d1-goog


