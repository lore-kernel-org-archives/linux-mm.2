Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE04CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BB06B0096; Mon, 18 May 2026 05:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBD66B0098; Mon, 18 May 2026 05:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF10D6B0099; Mon, 18 May 2026 05:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD7316B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57DDF161579
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:49 +0000 (UTC)
X-FDA: 84780036138.12.04687F6
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 823C6100010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kl1tYDZx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOz8gAJuYfKjn0utZUC84bAY67+CiHezioPS6ecopLg=;
	b=JD7mh8SpqNnecQr2APEWfesYTgq/4Oo2hxao65dLOacen4lXLs3q8I0gg65FCZJ7BpiHWF
	thp/o4Br9AMdP+BzN74x5eNAAGBpjdDi5b+ouoKdFM51ZkWJqm0KWJEmgVtjn3vvSzWi8h
	rc2jBKIPmJcmpcqAeA3rYZQpJeBe1w4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097007; a=rsa-sha256;
	cv=none;
	b=4znteXAG9Kcn/3BoLlDGBh8K71E7Ve8t72NPyd3Hql6ALu/KRjAHvRVPehZuU1aKau09ag
	A68IODaMSJkcDAlUHvUWJzTA/DNUtxBlMIE7WLfgNmmjAVAChtonw2rITxMk5ykEDSOqsX
	BWd6gHp52NsVl52MO10yRZYjjXou9A0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kl1tYDZx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3rd0KagkKCOofMdgZeMTgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6749e8562a7so1693778a12.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097006; x=1779701806; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vOz8gAJuYfKjn0utZUC84bAY67+CiHezioPS6ecopLg=;
        b=Kl1tYDZxQxknbh4eLjncGOjqKvFD9ciWl6Eldh9HT1IbC6Qsw3kdM5NWYs+25Bys8N
         DBJH/NVg/MnvA2uyI/icLLJmKXj1ve1sMLmTbjq76+YYOPJHCGroA47gm1qGy6g0Vw6r
         Cq3VL1VHQWHzAXI/K+VMuQ3dpTtOi1OpUYcslBTs+xurBuUJREahtqh92YYH0lEbihf6
         jwonMpGLWbFxydouAcBsKuQqfHI9Ld7MvV85GzyAz/nKV650YwyMqcJyHOJkpVIYZMsa
         E7x8jpcidYVh8mnTQxuFlITBAPUzYKS4o01xioguQdg3N4delFGnljqpbcaRPcl0JItd
         hkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097006; x=1779701806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vOz8gAJuYfKjn0utZUC84bAY67+CiHezioPS6ecopLg=;
        b=S4tFS/9QeE6uWzUJu4l27O+B9F2eRWSWSyF1QubecPR5jA3GfB3ggnjsh/iAEwUg5X
         gupAdIKRBvWSXrc/3hjHr9NSlftI4kC0Qw42eFPBVUjKUs3RWFLcEIxSC5CJG5hduWaG
         Jf0VbcuHV2YreinQHrHuzaIKyOv9AD8Ou7q25aRXL5D2SWhwASR/aT8L/hmsaCCnmOfV
         r+tpmyDIkQwdzbBMpsxxnjOiPl8t88xaFs9zWpkXCdp8a4NHWi/lDXE0FH81MgSdTgs6
         YROQfbk81HFdzNPVypQhayP8nJ1CwW5Q2Fct/nhcRerIr+Nyyje/nfuWIGWlw03i4O8T
         zfog==
X-Forwarded-Encrypted: i=1; AFNElJ9hRuDl3K7p4hydJMDA8M5fcOtIKBFBZ4AUcCnpuoR324PPGyAq7X0DHZg0XY0FHOVlqxEeunX/qA==@kvack.org
X-Gm-Message-State: AOJu0Yzh1DRiaUdtY2T7DSHw6J2TfOmUErbAy17Hdjew1FWWepmBYF2x
	/i7LZu5pn+beOOUR5kMG3gz1Dl6SOkW2m9T4DcJqhHpq3+Y2X9nwS6N8WSooriuaHfYNVAvKLy1
	0hEZRVL5nt2H6uIJK1g==
X-Received: from edtc13.prod.google.com ([2002:aa7:c98d:0:b0:67b:7d11:72ff])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:46d6:b0:678:ce1e:a5cb with SMTP id 4fb4d7f45d1cf-683bd193662mr6858854a12.21.1779097005896;
 Mon, 18 May 2026 02:36:45 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:34 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <b489ff0ab6edef9723778bd0018e209fe410e05d.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 4/9] kvm: kvm_luo: Allow kvm preservation with LUO
From: Tarun Sahu <tarunsahu@google.com>
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 823C6100010
X-Stat-Signature: s3xegyb88mp71penoibk4b3tzmfi47da
X-Rspam-User: 
X-HE-Tag: 1779097007-609954
X-HE-Meta: U2FsdGVkX18aILYTMLbzzK9rSK++g6zBStjLrkgnWyfh4gjQ4a/hkOkCVeCMKvCDL93W7l8hK3eaJFhEUCF12Y3ELLFA8oN1KehTsoeefpYbUORVZeYe8pswNETGYPnQxDCIvfOufhk/R7QS7IdmmMQwADILPrZKzfwmwmshJl5+46Zzi/3/OW3gaIRAarLbg6g7watKgdrnGaJtKSfYZM3TwVkVtzbjHybouUbuwCtGx2+3VWzz1YcWOFx/IMaSvzBC9O+uZ2EYXxLE2yX9bM9TSQ2bNBusH+trw85ssmQYmVFVI7MlOJ6NcHnQHTr0GSxSSHUTvkdLictUyXQsy+uy/q2sa052Txu4c91X7ettMZtMVhltI+CPK+XCWN6PvMUbLP9gZ95iyMzfBlGMqCg6JEFOcH2KM2xZcWxTKjwx0UX0uF8lMlrd0R2yBaa7/i+L9QoMyPb92A7dqJXd67AF0C2VwCduVSVW9juUtm1jKo957IxI8VCFokJmbhFKekX+2V7PJp7sAghZVfQ9x+/MNc4g/xaK2o2Z8Cujtq/mFen7nk4fxYk3Q7tVurRIGG6aAxQcioJ61Xzh/FxjE07N6sqf4cxQEreTYRnogGca7UUDA7Hjda1QCb4vd7GakOwlrn2hJO1lgQ7TfU1B9aaqy6Z7Z/zG5CT/eNRYqmsu4osNJw5kD/g+4ZcUIehSWkFMYupR338eQGzIS71CGVqBsjyKG4AJPRtd29jVN1kHiqfHK2RRypCUfTIgPU7KjzHxSYRCaShUvu4AolYRt5Oue8NtnaJO4HMbAxAVxgz8/Rdm9WZ65LqaMFyccxq0H1FzNO14I3lrI3/o9WLzj4eP1d1BA0yBnAJKHigliEetvRI+nuxbH2IStUGNkuD9B4wAhwK7aCRUK6GgPz9Gvto2EdHe1elU4IQtVIShbEWR3OQM1MenLPQ1LNUDQNV9hV9V0uKxu4kPJhc5wgm
 NI+UR9c8
 BPpuPfdJnS9erCfdWUNBP2Es7t+MrOJWyrQRMYX9FvoD+2gZ69zMO3tzPDEZ/trQ0bQXhL6guVlQdAxBm9pKSmv7S45GfJA7oi7bukWfPDNp9oSUTpkHqsb2k+y5Ninew4Tp6GFy+bK+WH5MmxVRF/JS/ATUiSWOh6Rn970OhUXppq7nGVkdCiw0kYd9LcRPq9Dtud7jPKxPIvhLqmSFhX8JrD/18n6/dzEkodNqifcCDTo3z5z6lBtNsbeIGGtUbynOhG9Ggf+JKGRERGSp/gcPxX4WYWh9cuAUvsjvB627xO8S8vPjrt8MeA90GIfTnfYo7nqGlfbUyXzN4ru1RzHT6rxvuWROdnf0LtmTw+FFFOvHN3+LjDJ8TzmbgWiAv7JP03LlmILNIcK5hFZS5eOqotyWhamxJIbVVWodn0iJMNBXCd9JC7yYzWLljxuroXZeIfCMsen8mmkpZ+vxrznkDDcRpT+in5S97h2ZZYL3lajZaTrJKXFt2sf0rA66Gi3hcKI4zSciy+jWSOvmAII1gzPPtds2iKMqBB00egCiPGmCkCrXMpVSKdNoX5HcCsD7JiNLmSEfHrwNYr81iSWdKgA02NAQ5hlmXlPeFCV5t7duTMllPdWqqqixDYKNc+rtUvQGqZCg6b8+PYkVNisvONU5b12pXxJnakQ/QuGYU4iOf/AdXxEXFIARItrGmp1/LjmVjR2HY6iMOOXrrroTlZy1UK2rPnJ3afwkf8UdeXgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce KVM VM preservation support for Live Update Orchestrator.

Register an LUO file handler for KVM files to serialize and
deserialize necessary VM state across live updates. Currently, this
preserves the VM type and generic memory attributes. This
implementation provides the necessary infrastructure and dependencies
for the upcoming guest_memfd preservation support. And it can be
extended to preserve more vm state in future.

To preserve the kvm file it is necessary that the attributes that we
are preserving must not change while or after preservation. The memory
attribute change request is triggered by Guest to KVM and exit to VMM.
VMM is aware that liveupdate is in progress and is expected to cancel
this request Or pause the VM. This ensures that no change in memory
attributes from guest are introduced while/after preservation of kvm.

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
 MAINTAINERS                 |  11 ++
 include/linux/kho/abi/kvm.h |  54 ++++++
 virt/kvm/Makefile.kvm       |   1 +
 virt/kvm/kvm_luo.c          | 346 ++++++++++++++++++++++++++++++++++++
 4 files changed, 412 insertions(+)
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 virt/kvm/kvm_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c2c6d79275c6..2c26eb17bc0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14404,6 +14404,17 @@ S:	Maintained
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
index 000000000000..31bd39588bdd
--- /dev/null
+++ b/include/linux/kho/abi/kvm.h
@@ -0,0 +1,54 @@
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
+ * struct kvm_luo_mem_attr - GFN memory attribute serialization.
+ * @gfn:        Guest Frame Number.
+ * @attributes: Memory attributes associated with this GFN.
+ */
+struct kvm_luo_mem_attr {
+	u64 gfn;
+	u64 attributes;
+} __packed;
+
+/**
+ * struct kvm_luo_ser - Main serialization structure for a KVM VM.
+ * @type:         The type of VM.
+ * @nr_mem_attrs: The number of memory attributes in the array.
+ * @mem_attrs:    KHO vmalloc descriptor pointing to the array of
+ *                struct kvm_luo_mem_attr.
+ */
+struct kvm_luo_ser {
+	u64 type;
+	u64 nr_mem_attrs;
+	struct kho_vmalloc mem_attrs;
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
index 000000000000..1cf3941c16b7
--- /dev/null
+++ b/virt/kvm/kvm_luo.c
@@ -0,0 +1,346 @@
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
+ * Memory Attributes
+ *   All entries in the memory attributes array are preserved.
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
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static int kvm_luo_preserve_mem_attrs(struct kvm *kvm, struct kvm_luo_ser *ser,
+				struct kvm_luo_mem_attr **mem_attrs_ptr)
+{
+	struct kvm_luo_mem_attr *mem_attrs = NULL;
+	unsigned long index;
+	void *attributes;
+	u64 count = 0;
+	int err;
+
+	mutex_lock(&kvm->slots_lock);
+
+	xa_for_each(&kvm->mem_attr_array, index, attributes) {
+		count++;
+	}
+
+	if (count == 0) {
+		mutex_unlock(&kvm->slots_lock);
+		ser->nr_mem_attrs = 0;
+		*mem_attrs_ptr = NULL;
+		return 0;
+	}
+
+	mem_attrs = vcalloc(count, sizeof(*mem_attrs));
+	if (!mem_attrs) {
+		mutex_unlock(&kvm->slots_lock);
+		return -ENOMEM;
+	}
+
+	count = 0;
+	xa_for_each(&kvm->mem_attr_array, index, attributes) {
+		mem_attrs[count].gfn = index;
+		mem_attrs[count].attributes = xa_to_value(attributes);
+		count++;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	ser->nr_mem_attrs = count;
+	err = kho_preserve_vmalloc(mem_attrs, &ser->mem_attrs);
+	if (err) {
+		vfree(mem_attrs);
+		return err;
+	}
+
+	*mem_attrs_ptr = mem_attrs;
+	return 0;
+}
+
+static int kvm_luo_retrieve_mem_attrs(struct kvm *kvm, struct kvm_luo_ser *ser,
+				bool *mem_attrs_restored_ptr)
+{
+	struct kvm_luo_mem_attr *mem_attrs;
+	u64 i;
+	int err = 0;
+
+	if (!ser->nr_mem_attrs)
+		return 0;
+
+	mem_attrs = kho_restore_vmalloc(&ser->mem_attrs);
+	*mem_attrs_restored_ptr = true;
+	if (!mem_attrs)
+		return -EINVAL;
+
+	for (i = 0; i < ser->nr_mem_attrs; i++) {
+		err = xa_err(xa_store(&kvm->mem_attr_array, mem_attrs[i].gfn,
+				      xa_mk_value(mem_attrs[i].attributes),
+				      GFP_KERNEL_ACCOUNT));
+		if (err)
+			break;
+	}
+	vfree(mem_attrs);
+	return err;
+}
+
+static void kvm_luo_retrieve_mem_attrs_cleanup(struct kvm_luo_ser *ser,
+					bool mem_attrs_restored)
+{
+	struct kvm_luo_mem_attr *mem_attrs = NULL;
+
+	if (ser->nr_mem_attrs && !mem_attrs_restored)
+		mem_attrs = kho_restore_vmalloc(&ser->mem_attrs);
+	vfree(mem_attrs);
+}
+
+static void kvm_luo_unpreserve_mem_attrs(struct kvm_luo_ser *ser)
+{
+	if (ser && ser->nr_mem_attrs)
+		kho_unpreserve_vmalloc(&ser->mem_attrs);
+}
+
+static void kvm_luo_finish_mem_attrs(struct kvm_luo_ser *ser)
+{
+	struct kvm_luo_mem_attr *mem_attrs;
+
+	if (ser && ser->nr_mem_attrs) {
+		mem_attrs = kho_restore_vmalloc(&ser->mem_attrs);
+		if (mem_attrs)
+			vfree(mem_attrs);
+	}
+}
+#else
+static inline int kvm_luo_preserve_mem_attrs(struct kvm *kvm,
+					struct kvm_luo_ser *ser,
+					struct kvm_luo_mem_attr **mem_attrs_ptr)
+{
+	ser->nr_mem_attrs = 0;
+	*mem_attrs_ptr = NULL;
+	return 0;
+}
+
+static inline int kvm_luo_retrieve_mem_attrs(struct kvm *kvm,
+					struct kvm_luo_ser *ser,
+					bool *mem_attrs_restored_ptr)
+{
+	if (ser->nr_mem_attrs)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static inline void kvm_luo_retrieve_mem_attrs_cleanup(struct kvm_luo_ser *ser,
+						bool mem_attrs_restored)
+{
+}
+
+static inline void kvm_luo_unpreserve_mem_attrs(struct kvm_luo_ser *ser)
+{
+}
+
+static inline void kvm_luo_finish_mem_attrs(struct kvm_luo_ser *ser)
+{
+}
+#endif
+
+static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm *kvm = args->file->private_data;
+	struct kvm_luo_mem_attr *mem_attrs = NULL;
+	struct kvm_luo_ser *ser;
+	int err = 0;
+
+	if (kvm->vm_dead || kvm->vm_bugged)
+		return -EINVAL;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	err = kvm_luo_preserve_mem_attrs(kvm, ser, &mem_attrs);
+	if (err)
+		goto err_free_ser;
+
+#ifdef CONFIG_X86
+	ser->type = kvm->arch.vm_type;
+#else
+	ser->type = 0;
+#endif
+
+	args->serialized_data = virt_to_phys(ser);
+	args->private_data = mem_attrs;
+
+	return 0;
+
+err_free_ser:
+	kho_unpreserve_free(ser);
+	return err;
+}
+
+static atomic_t restored_vm_id = ATOMIC_INIT(0);
+
+static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_luo_mem_attr *mem_attrs = NULL;
+	bool mem_attrs_restored = false;
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
+	err = kvm_luo_retrieve_mem_attrs(kvm, ser, &mem_attrs_restored);
+	if (err)
+		goto err_destroy_file;
+
+	args->file = file;
+	kho_restore_free(ser);
+
+	kvm_uevent_notify_vm_create(kvm);
+	return 0;
+
+err_destroy_file:
+	fput(file);
+err_free_ser:
+	kvm_luo_retrieve_mem_attrs_cleanup(ser, mem_attrs_restored);
+	kho_restore_free(ser);
+	return err;
+}
+
+static void kvm_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_luo_mem_attr *mem_attrs = args->private_data;
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
+	kvm_luo_unpreserve_mem_attrs(ser);
+	kho_unpreserve_free(ser);
+	vfree(mem_attrs);
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
+	kvm_luo_finish_mem_attrs(ser);
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
+static int __init kvm_luo_init(void)
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
+late_initcall(kvm_luo_init);
-- 
2.54.0.563.g4f69b47b94-goog


