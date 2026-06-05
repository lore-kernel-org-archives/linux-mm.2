Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CBECD8C87
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9536B00A1; Fri,  5 Jun 2026 13:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558896B00A2; Fri,  5 Jun 2026 13:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F8B6B00A3; Fri,  5 Jun 2026 13:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9E86B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFB92C12BE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:52 +0000 (UTC)
X-FDA: 84846493704.18.7664F25
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id E6AAD180003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bXYKYNPP;
	spf=pass (imf16.hostedemail.com: domain of 3oQIjagkKCIo7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3oQIjagkKCIo7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1VWus93ymHXqxzcryRmxNh2WmAw3PDs1/dZrztpQgM=;
	b=0obmPdYHUELMcqYvW27qd7KF7jLHY2HcmprDzWbxdRWQwaYRIbDuo3Wz/7dCvtS4oyZPsL
	MNuEWar6M2NQCYWR9IkJsZRhkUH4FGLOZ84d5XTqknGNUGpIc/0hr52dF47WkP7nhx6QrV
	lus4TBRmlrd8/NZe3ViQU0Wldxv5xyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679331;
	b=nEl/NQDCFyHvOZab4or8EJdS2iP/q8dFVtYQu0qDmeY1sRUumAMFmZfs/YyB6wjAMeXJr+
	VKvXuiD+puvDnc6Q8iEaP+VHLxNcrbksjisgt9JPSFRCMxJtnBdo+ILG6hrM23qTEugpjq
	LT2fnxFPhDeCW1hPGLZvIVSBIYvn1u0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bXYKYNPP;
	spf=pass (imf16.hostedemail.com: domain of 3oQIjagkKCIo7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3oQIjagkKCIo7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68f9f08cfcaso1694986a12.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679329; x=1781284129; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U1VWus93ymHXqxzcryRmxNh2WmAw3PDs1/dZrztpQgM=;
        b=bXYKYNPPmOzmhGvo5JI/Dd7f+HZP1cUIZqrWCd7vzUj96y3oekJrkf5R2Z+u/vzVWF
         LVJsIEXsX2eHEXNFbhWcplVhdEzNOUPRF0rgqSFdC/+hR3umJ0tWZsCmovBbGSg6oKt9
         eNRlm5672IDJrAm3glacplZkczZ2junrx5Qb9rmng6mmZcEw4xHaESq3EgV2dY+88irX
         JtD5u8uKhiOv8cfg5nmaTagNVUM0HVosW899CjZLeIXKrr3D2DUBC9dfiIVwGN8CV278
         gM1bk93RDntJkCmzxs2Pw/dmqV0TBpRE49/Ahej/TjysYAr0p8KebO+ARIZ19oZQqN1s
         iQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679329; x=1781284129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1VWus93ymHXqxzcryRmxNh2WmAw3PDs1/dZrztpQgM=;
        b=NEQSBEvBSmseEyaN6H/ZasW06nL7hrF1TJH2IFslouXqVaRcX3Jyrl9AQEOVRMWTTp
         D9UVXk8RdR0XrsLxGuP6peEZOf7UDljH3Cb5gC2pz9rexdyIyT6ca/50rpMWwwQ/Yt65
         JgCfOLMmhxcQvX/0zH8+WtdwV0FOAO3ZbC+HKp3ODQsQj7WgHEXJs+xIDgEULMuyWBr6
         5Z10vGxdC8BdAtNp5kCTTeoNVTSAv8JtkFqJXv+1tZn9bYg0XO9hs1UH8tSuhmoAuq0+
         nYhv8czp48IZDisaTLO08fBXA8QjQgeFI1QlpmPEx6sbfcY3a905D0JY93QnU19S0gQl
         gwbg==
X-Forwarded-Encrypted: i=1; AFNElJ9xPE9KcJ8Y4RXrmUJxI7at0N91csenNHtum32Hc6ZGqWNzG0HDt3vW12Pxrqipr1nAmd2QqwEJnQ==@kvack.org
X-Gm-Message-State: AOJu0YwIOeCajDLq+wRB4igQpBA0P0uuFsL+Sq7rEJlNUNE5TnVl3/nB
	8E/p6CC6WDNf+BdcPZ2g8JqW+ow6uuCbiQYtmILf9gLItC35T4eEhO/WP9xCEQWYS9jJtLByt5S
	fYTvj2spTPXp0rX94Qg==
X-Received: from edbbe6.prod.google.com ([2002:a05:6402:1a26:b0:672:9dc4:7c93])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a512:10b0:691:40cb:210f with SMTP id 4fb4d7f45d1cf-69140cb27d1mr346393a12.7.1780679329256;
 Fri, 05 Jun 2026 10:08:49 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:32 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <4b2216f5c459fe699a3f62464cbc765624e20ae6.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 07/10] kvm: guest_memfd_luo: add support for
 guest_memfd preservation
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
X-Rspamd-Queue-Id: E6AAD180003
X-Rspam-User: 
X-Stat-Signature: jacei5eehnfqhpjkc6md8akose1j1oqg
X-Rspamd-Server: rspam08
X-HE-Tag: 1780679330-356093
X-HE-Meta: U2FsdGVkX196rMRI75Q9f90kmZrnzpNnBLmFsPMRwvX01asmQqu2jVgEXj24d4pLQJrl0tRBKhich3EI+u+VLn9MlP1LW9Js7F7IVhuvZBRufRHSqigoYgrP0IN4QQY+Wdrzm2MQedJ4SOv9F6rd/k8O0Uxh4q+OT5UfCJ3fAFweMenGWwveIFAH61mjO9KpGL6e+6MDoSADivUb3RHJlWzwgRrh0wyJLmyBVecDXbsPI355viZoQNf5m9JKUbujXi51T101GFiQWHAsVMd6D4gBMBgMTdrQHp9oCbua/TROUshzc303NkW/t2d72AOh4ldDI9hGhhONpNvcNfmN0u8x6goQHqS2Lh/sREGkW7Ay3k0Zhei/pxAMFH5ukjiio/eun8OfmZC4A/E48myuxWp5cda87RJzbVHyzHhwuNQLTGmoCblBKDqkgwREoPc1FiEjFAisbDkMut0g3dScoOd633zZN15HhDvM1lH0OHGqXLI5LO9Yp99nEeucF1M/N3ZoI7TYLEhiXyJ5uX3JLRkdWm2nlMG84PwgZZArI75IMMj/9GNObbO4AwlD2TUnVq4J6wk2du2e1VwBED1s1QGV05PUoe7lubrKY2XbcykgsvuWwSInArSBxzpaaJ11UFkA0c9KZJDPCDQBLshcSvuDnBe+TC+38jMI9hZjllwSnIGVRWtk+7X10YfSXTp3gq84h/4spCBlM8LWYigc1BRdVqioEgC5iDj3ss++q8BOYUqORDNFdklsxvmF5+uQEsQe7xBeqE6VuHxagzGzlSGjWXE9DWGTHsCs9x0T2HlSS+v4DTfEui69iPdzlOTIujGWv2KQYsfpa2yHW0HRekTEDiyvmZjH+svqG0mV0laIpEHnZwk69X18l+xVl/PwrFXyPkl9442DX8XPAiWr07yC0Uea4b9OCwpWy1l8JkBv3sEr7zjsz8b2L6f+5ZV8ZTIht5bZjxrKyauuk0v
 nF69bBML
 oRmigtLSJT5NgiCy8Xoqx9pkFI5NrpM+vNvd4G21K+0wzUYnTviD1jVOZKppKXFIov+HUE2RPr8P8gsT/2K3nfm1j5Vd1M3gECXPhECeVz4dradYLt1IUnDCJUEe2Cim24Bv9mwPk09QnujqzB02bcZgqDcv5SKjni5FW65Q2yijEfbuG9EvKaq0n9GU+r4saVmfRxu+MI55tJreleFFC5zoInAyK46riSg25fhgEfXBpDVX8H9W9oYeEerz8Mz9bjMi4DLYJjuvm8od03wIzRdo4Nf92FBlGRbiqWq0k/Rvhq2lv69BjYV7Hwljcsn8GfiE6RFmbZeZcR1G7D91R0Rp5363Cdrl3ZHZMyK9uyzR2zEWhdBLuC7oJcxsH8qkZ0ozT9elrwnZ+5lxFSSNrO2VNLIKjEWFLLRAPn/aVd/65RA2WR6p6qTmKy/yw70oNHBDBofAKqekjOmGmIwoILN/xEj/nTK3RFYT9I1bCyscQUmyXsG6/1R5k8Txxq2NuyevVNmeRkYxiHcFFv6Uc1dkJUj5P9DR6mxlier7QO40UySH+ViQtiZlM+yYxfvca1kYxWXHLO81IPIvpies3okng8DOtNDfipW7qxXS0cPhNvY6SOG73ADdi3g8NWDO17HZTyX/1mZQezdhS1LMq71wugXE/U2OdToYd3G+F4o7VzFC64QScpz/Sf1FbVTJ0sUApvscdiMYcNf9HNDBBzpUcyFRH1obJjbf3UPWBboeFWQKtMmZyrEVxwUWhJubT3Wg/CJWKNFsdtlMNZ2aOdsKnig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up the basic infrastructure to preserve the guest_memfd.
Currently this supports only fully shared guest_memfd and backed by
PAGE_SIZE pages.

It registers a new LUO file handler for guest_memfd files to serialize
and deserialize guest memory. This allows preserving guest memory backed
by guest_memfd across updates, ensuring that guest instances can be
resumed seamlessly without losing their memory contents.

Preservation is straight forward. It walks through the folios and
serialize them.

There is kvm_gmem_freeze call on preserve which freeze the guest_memfd
inode. It avoids any changes to inode mapping with fallocate calls or
any new fault allocation (fails) on or after preservation. No need to check
this during the page fault as preservation is only supported for
pre-faulted/pre-allocated guest_memfd.

While retrieving the guest_memfd, it requires the struct kvm to create
new guest_memfd. So it first get the vm_file from the same session using
the token passed during the preservation. And use it to get
vm_file->kvm.

This change also update the MAINTAINERS list.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                 |   1 +
 include/linux/kho/abi/kvm.h |  79 +++++-
 virt/kvm/Makefile.kvm       |   2 +-
 virt/kvm/guest_memfd_luo.c  | 485 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c         |   7 +
 virt/kvm/kvm_mm.h           |   4 +
 6 files changed, 571 insertions(+), 7 deletions(-)
 create mode 100644 virt/kvm/guest_memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9bfc3c1f6676..16cba790a84d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14418,6 +14418,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
 KVM PARAVIRT (KVM/paravirt)
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 718db68a541a..42074d76e04a 100644
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
index 000000000000..d466f889c9aa
--- /dev/null
+++ b/virt/kvm/guest_memfd_luo.c
@@ -0,0 +1,485 @@
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
+	struct gmem_file *gmem_file = file->private_data;
+	struct kvm *kvm = gmem_file->kvm;
+
+	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
+		return 0;
+
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
+	args->serialized_data = virt_to_phys(ser);
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
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
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
index c70346906a89..501a5d048418 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6580,6 +6580,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_luo;
 
+	r = kvm_gmem_luo_init();
+	if (r)
+		goto err_gmem_luo;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6593,6 +6597,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_gmem_luo_exit();
+err_gmem_luo:
 	kvm_luo_exit();
 err_luo:
 	kvm_uninit_virtualization();
@@ -6624,6 +6630,7 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_gmem_luo_exit();
 	kvm_luo_exit();
 
 	kvm_uninit_virtualization();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 118edc47df83..d8ccb68e7e9b 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -100,9 +100,13 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
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
2.54.0.1032.g2f8565e1d1-goog


