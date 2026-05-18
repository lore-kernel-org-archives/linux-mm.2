Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F34CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C166B009B; Mon, 18 May 2026 05:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D1E6B009D; Mon, 18 May 2026 05:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE316B009E; Mon, 18 May 2026 05:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3116B009B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41B3C1C07C9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:53 +0000 (UTC)
X-FDA: 84780036306.20.08720CF
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5EE641C0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HUXnsSOz;
	spf=pass (imf21.hostedemail.com: domain of 3sd0KagkKCO4jQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3sd0KagkKCO4jQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejBb0SYl6zXB44TKLfFrfIt7SEHIRghpBzn0BwO26w8=;
	b=xK7c26BRPjLqj/9uzdIUB+FypGQopptI6GoyCJn6ai9lhStCtJt96vEGNGksdQyOmQ1Rlg
	+YBJs6cH9KjNF88ysDvMAhgMYrNlI5EZQ5YYGb6+6X0u+2C9zYTXfr6tF/tjnLYI2PQDul
	WIpFFqUxpnhK7EiFmZVhOqvJKtC30Lc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097011; a=rsa-sha256;
	cv=none;
	b=jBFxYofsHmBJhayhFlAeS6Y8UwCg2EBLRcPHiyF7SVeeT+KYEwDJwDxbHjkHSyIUK6Oidf
	1ZUcqY8W07ZPcdpFeLLGo2uJuqDUSl9tdcM81kXgiILXey4JaUjEFdXEq52WiPEQBci6a0
	xBD/1y3yCJanhjaoufbBDO9G6YurVPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HUXnsSOz;
	spf=pass (imf21.hostedemail.com: domain of 3sd0KagkKCO4jQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3sd0KagkKCO4jQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bcdbb46dce2so178764066b.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097010; x=1779701810; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ejBb0SYl6zXB44TKLfFrfIt7SEHIRghpBzn0BwO26w8=;
        b=HUXnsSOzdapEDs9BvGeiP86OIsRmEKtSKH9vSSCfDbYYTEnSZuMvljo/fzMhJ/AN2s
         SvxnRejkKyUYxa061LDmY1MdJQ8WFhtFvPFu9QxNBAOr6DnHFhwjN5+p+RugMa8JYmIg
         REhVEu606HzyRJPltwO0hOkLKAlxpaGETbCyY+jDdxo3ciQ4mxhu/eiyiCfv2kUC9hIJ
         tkNhcJo0XI6eZR4qwn7EjzxldoSd/oGWBlJynbeBXth51sfvuDqZO8Oa0Y+jJQMp2hmZ
         dQS8NzqwDKtwfeJSRzuXygkgA/AUXkoX2CGAGmsqtrzmCcpdx185RYcMQqVtPJHo2ZdF
         v6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097010; x=1779701810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ejBb0SYl6zXB44TKLfFrfIt7SEHIRghpBzn0BwO26w8=;
        b=eFfkMPtzKzJ7PlRcgGkb0N5pLNkiAAqVus+Ri4foG7kLqGGCI1LJW6FTIJ7F89XhLE
         gxsiNHaJhPPVh+pIrGgB+TkFAq+r1t7bu0MdYY9cgYUtOzPbURg8nDRiwcmdTq+GlUMA
         TZgV3xEnrT21KngxSyQniGOjqP0kgwj+FQ0eMleHP3Gv0v/mTruz2DcNS/UNAhXSl4A3
         H7BbdXgu06ecxgnlCkoAEXp8oYlVIBp3/TuW7mj4d+Z2oPSDk5HHrSzfQi1ffoW8Q+2D
         nd4Nr/cRfT9EIbxZhKNXmyyEZHrSuizbZBIAUGN2G6O/5tU96VBvQFnLJSYx4fF62NNM
         7kUw==
X-Forwarded-Encrypted: i=1; AFNElJ/kq1JYnT7I77VOv7EozfwhSv0Iza2nuV9VHMMNZfkUFtNKUEPE/tnUbAukyz//u/8yHErHg3AkFA==@kvack.org
X-Gm-Message-State: AOJu0Yx7Isi9y7Ofpql1yH0sTHzdVFbqImBcH2yrJmZjdHUTddBidvkk
	8AU5DDC7kMtxaVR415wIm4Dwxrr9IpChzgRFGSis+r5QI7BSqhPRZDADpFFluXWZmfY/UA8v5qg
	Pl0A+hJN+Zh+3XKxNZw==
X-Received: from edgi7-n1.prod.google.com ([2002:a05:6402:a587:10b0:67c:76a4:f702])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d89:b0:bd5:7c2:42bf with SMTP id a640c23a62f3a-bd517af6eb4mr598467566b.49.1779097009480;
 Mon, 18 May 2026 02:36:49 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:37 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <4d444f77f973f610386b78c5689b9726dc5f4c73.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 7/9] kvm: guest_memfd_luo: add support for guest_memfd preservation
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EE641C0007
X-Stat-Signature: ec3oreimftgi487xd7bipoksr7gytoq3
X-Rspam-User: 
X-HE-Tag: 1779097011-939487
X-HE-Meta: U2FsdGVkX18A2w6u9Gv0XxT2ak+oGH+R2Mjs8CgeNZlA1L3bvARoduwIfiTnDpfDUCGFJ7iPz1PiOjE9R5NKS9QAxNNcoFDt9tLSuhzLBVo/mO9b509rRBgEkSouoBru4foi2IhH1B4eqsNCX8ne1EV2P94m5GJfCaFEwXvwUVRWZCPE/eKgPOPMmba6nyHKXSrfD7xmSf7IfU3E6p5C3Gtt+v21BN0O1bXbpYfrYz9pRkjZ5hWH9CNwsvgMMoltW1w09yrhZFvVy9f1/urs66hNsDSmpEXyiRf+2/riJ+ek2FxSPhJMwg/878fJmYC9pllyA5XjEKBuv5eJmKhxluOVSNaKt6zRDWhOYJRhemnvga7OiWDDHzd9QseqQLhmdVNZdnNc7FQbw22kwn/cZQJDgE3Q1YtF+qvs6KC8Hz/f3YfeJVmBfJKY6CmSfDKOoUM4BRAgfhqAnYTSXTbG4dhMsMUN31hPeEUjHPTWTxeg4CNLeNaW6sjsM+1OTVbjxsVbHg8A5g38mBUIhy6L+Edw9A84zXGypLFZSdyFVT6IZ4ZBXsc5BJ20YF6nftqhjGU/T2ePK5B6s7P3ac1Lq7fRG3PwMs7gFPvYN6eGJB0urkGQjMc39OIjZ7DUmUGX8hqvFqBYI+twkxJHeo9MkrH+DXjBwX61vzFDACx+0vdw5KRd8WV/EjXgjYkJ8QyUoe4DbX21nCyBagwhWaQHWnEYsx3xHTAkuDFUHK/L+1pd9rMt4DKqdGMUaeYNFxFSL9vWPcXiViGKkNq/2MA8aD1mZlinUfPDPlJ+exaasjVDBW/7G1Ci1I8lSM4tVFtez6gPv+nQ22WXICF2R2XPOa7uDIoCxke+9slfleMjrOm/fdXQZLXqP7lXqcw+DgfogxkhYOVdg2EvnvgtoxH+gFkXoQoYB0JpnHNt4KtZTTwn/i00GB5RGd7ZavoZWx96Voeca7mZhumz8ApjkiV
 JMZ1/6H7
 L8WazfOYjzPs50fzolN4wilL+Fnmcw75sx+KSVJqOWrpRT8oMyTvw3uflOPjGWisidzzqSCY69widIQQ1PrFqxDYNvSxrsO9HYbrBWTJ5p6BvPiDQckg9ZJo97kzziDqdJWmmhA6PJogTh8GgB6W2hTSjVv2aKMKOfEV3jn0efLBJU7ShnYlF3rc+xQQ7/f3NgYodNsLgDYK3DewaMiCa98lb7vokAetEVsH9QWnW61mnWgGY+ihXBU2VAa3j79wZVBKRXjTZPZTlvUZvm8/69qnTkcA/UBXVsm/Y7SVvvdhehHroAxDlZ1AWSGeNfE6sj08w/1KW6NyOLG8C42aSmlCc4DQ1zuiTcN37EWekkzrmF0jEGLaUr0mFuvJLjGlaU4xxN/w5Mtj3+udlQvN0AKmltk01aaOYjKNwp0zaIBS/dY8PKWhK0GWupVEE5vr1kuhCldmypxZLQZyZh3O4+6Fqv9zOk3ZLceKP+AKmyVwq+NQcnmPaEA1i5eKUr6+k3Kf3g0rvjtJ1Tc/S9vtJq3bvnriJPyVIGUzUo4/YS+qjf11uYZps41P3I4cWeF1z3BNgVXAbhNlTz4SoxpUlsvC8Dzk68E+5j48V+5++z6/ZhPamQyUQ9nT9RCCYBH4sAFPe0oYVEPOLMrPNZczHp8muHNjw94WuH5TgDlcCZm8BzuuxDEVIvRLWnsk7RBXvWIMg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up the basic infrastructure to preserve the guest_memfd.
Currently this supports only fully shared guest_memfd (INIT_SHARED),
pre-faulted and backed by PAGE_SIZE pages.

It registers a new LUO file handler for guest_memfd files to serialize
and deserialize guest memory. This allows preserving guest memory backed
by guest_memfd across updates, ensuring that guest instances can be
resumed seamlessly without losing their memory contents.

Preservation is straight forward. It walks through the folios and
serialize them.

There is kvm_gmem_freeze call on preserve which freeze the guest_memfd
inode. It avoids any changes to inode mapping with fallocate calls on
or after preservation. No need to check this during the page fault as
preservation is only supported for pre-faulted/pre-allocated guest_memfd.

While retrieving the guest_memfd, it requires the struct kvm to create
new guest_memfd. So it first get the vm_file from the same session using
the token passed during the preservation. And use it to get
vm_file->kvm.

This change also update the MAINTAINERS list.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>

---
Also, I wanted to use the luo file handler compatible string
for guest_memfd_luo same as kvm_luo (KVM_LUO_FH_COMPATIBLE), but
unfortnately LUO design does not permit this, every handler needs to be
registered with the separate string.
---
 MAINTAINERS                 |   1 +
 include/linux/kho/abi/kvm.h |  79 +++++-
 virt/kvm/Makefile.kvm       |   2 +-
 virt/kvm/guest_memfd_luo.c  | 495 ++++++++++++++++++++++++++++++++++++
 4 files changed, 570 insertions(+), 7 deletions(-)
 create mode 100644 virt/kvm/guest_memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c26eb17bc0a..e5402a56ab98 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14413,6 +14413,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
 KVM PARAVIRT (KVM/paravirt)
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 31bd39588bdd..fcdec609a41e 100644
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
@@ -51,4 +54,68 @@ struct kvm_luo_ser {
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
index c1a962159264..d30fca094c42 100644
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
index 000000000000..66b931eafc82
--- /dev/null
+++ b/virt/kvm/guest_memfd_luo.c
@@ -0,0 +1,495 @@
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
+ * .. note::
+ *    Currently, only guest_memfd backed by standard system page size
+ *    (PAGE_SIZE) is supported. Huge pages are not supported.
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
+	u64 count = 0;
+	pgoff_t end_index;
+	long size;
+
+	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
+		return 0;
+
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return 0;
+
+	if (mapping_large_folio_support(inode->i_mapping))
+		return 0;
+
+	size = i_size_read(inode);
+	if (!size)
+		return 0;
+
+	if (size & (PAGE_SIZE - 1))
+		return 0;
+
+	end_index = size >> PAGE_SHIFT;
+
+	if (kvm_gmem_luo_walk_folios(inode->i_mapping, end_index, NULL, &count))
+		return 0;
+
+	if (count != end_index)
+		return 0;
+
+	return 1;
+}
+
+static int kvm_gmem_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser;
+	u64 count, gmem_flags, abi_flags = 0;
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
+		err = 0;
+		goto err_unfreeze_inode;
+	}
+
+	if (WARN_ON_ONCE(size & (PAGE_SIZE - 1))) {
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
+	folios_ser = vcalloc(end_index, sizeof(*folios_ser));
+	if (!folios_ser) {
+		err = -ENOMEM;
+		goto err_free_ser;
+	}
+
+	/* Walk: Fill the metadata array and preserve folios */
+	err = kvm_gmem_luo_walk_folios(mapping, end_index, folios_ser, &count);
+	if (err)
+		goto err_unpreserve_unlocked;
+
+	if (WARN_ON_ONCE(count != end_index)) {
+		err = -EINVAL;
+		goto err_unpreserve_unlocked;
+	}
+
+	ser->size = size;
+	ser->flags = abi_flags;
+	ser->nr_folios = count;
+	ser->vm_token = 0; // It will be set during the kvm_gmem_luo_freeze()
+
+	err = kho_preserve_vmalloc(folios_ser, &ser->folios);
+	if (err)
+		goto err_unpreserve_unlocked;
+
+	args->serialized_data = virt_to_phys(ser);
+	args->private_data = folios_ser;
+
+	return 0;
+
+err_unpreserve_unlocked:
+	for (long i = count - 1; i >= 0; i--) {
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
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
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
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
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
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
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
+	if (!args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
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
+static int __init kvm_gmem_luo_init(void)
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
+late_initcall(kvm_gmem_luo_init);
-- 
2.54.0.563.g4f69b47b94-goog


