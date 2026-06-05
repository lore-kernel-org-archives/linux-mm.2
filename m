Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3C1CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE89E6B00A4; Fri,  5 Jun 2026 13:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78766B00A5; Fri,  5 Jun 2026 13:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CF06B00A6; Fri,  5 Jun 2026 13:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88FB96B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 442BE4021D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:56 +0000 (UTC)
X-FDA: 84846493872.23.8D530EA
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 639B1A0003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GxORypqu;
	spf=pass (imf15.hostedemail.com: domain of 3pAIjagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3pAIjagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679334;
	b=q/2N3aSdn4b3cUSh+ArRq3nr9HtYr90wWSi5wWDlLcK3m99QQN1CupWIWHoWWUtAYcu5Cu
	JRUYvsJDj9+jIVNd/GWoXEtrTHWuRQWx+2txmJyimm+wFzdARA/uq5+FYKZJW6x9d408kw
	aopHH7UuRWGSvONu7a1GBGhdCElSpwo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GxORypqu;
	spf=pass (imf15.hostedemail.com: domain of 3pAIjagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3pAIjagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKOif6j4jVPzr5ukiPmavhItUicYy0w0O5SDkKy/EaQ=;
	b=TV9AA88T6XSb25W9LXpHAzZoagAL9CRikrtMemWei87Pm42yQJVuslg6hrVePLYcxWbfVu
	QuWxsxuUu2T2fJ3yWJLx0Gkry5cH/0GckZxoWm1nVcaQJFZBU/Lj0f4SOhLuSN5e2f3/AH
	2oiQLnL48PWT5yipCxUI7NnG8spCXgw=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bf473656dcdso31295766b.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679333; x=1781284133; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JKOif6j4jVPzr5ukiPmavhItUicYy0w0O5SDkKy/EaQ=;
        b=GxORypqu4hh9U+b/JAtoCGW1lfCmd4mdIdHgvjqIn627Eb/2nnahcROcmY9aIYEJby
         ZNLcCEDtHyxwRpAR8vjTg5tF8UTN+suvSLXg5QOSChDAYpDT7eD0mIuMyiZivBs8rin2
         8oxZ9DPZmK/LUy+SbMWsCa51Y9/GnHCl/fctDL62BUcM/U9oIFVoMC2HShJbXUdode7w
         3RrtlD9GiloKl7zi5jZzMM3yfKpaR/6vd2JH0AJB5DID3F3cDCsdBiS06/zCctsh7/Wm
         zy6B1aQNOHjv4zzRf2tMfsHL1tUnA2wMuOszgV13GTXF7gCpQuSE0f9FXiEpI3+pgARO
         /xBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679333; x=1781284133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKOif6j4jVPzr5ukiPmavhItUicYy0w0O5SDkKy/EaQ=;
        b=FNVgk3rAH9Sly0PYqVA10vJygJolrSWhCEZx82dS37KORHtyrplS70GFo34B6GG3/C
         +XQ7j8dVRCA2LWexMH93t95Ro8ckMBkZSwTpwO06WOoSD3GmmmX4ms3WSDznWGgsLDSC
         y+exwoOuFQb9Kt/w7PU5monaOxeOOfds7qUFX6UD7IMPNrOT2IbUosJ5X6jKCKOGNiK6
         05jh1+E2MZXB48NNg7eB+15QBtsvFHaj6fwGhvHAAKTEINxq3TLEq8cwFenqB/rX8xOo
         l+GIc9V8C95c+ThtXSH7BH0O5h3TIOWUkS+VeWjAy1+30Tbo0QYxGC64gF01w+vxUNJV
         d+KA==
X-Forwarded-Encrypted: i=1; AFNElJ+M4cLcwgO1fgzM6CSoTmVdi4zCyvMIS8ZrQTyM0flHTcQhkfmP/YdUAwKMYsJGxVHjt5MHdOfsDA==@kvack.org
X-Gm-Message-State: AOJu0YyTkHJfAEXydSc2xYajelVMrQovyKDxHNXRWXplnlDcT+vN9GSz
	hayrax16c1WTXShcTTBdn+hyUmvvWfhruvcgUfR0ap4pcdZLBYWHo3zqYLslNCaRyHrRk99eW3b
	MIDjh/O3A/xuDyZzyaQ==
X-Received: from ejgi16.prod.google.com ([2002:a17:906:3c50:b0:bee:1279:f6c5])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7a8f:b0:bee:31b0:b53c with SMTP id a640c23a62f3a-bf3748d76f8mr236059566b.47.1780679332631;
 Fri, 05 Jun 2026 10:08:52 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:35 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <deb20fbe3584a8c6bfda276447fe464c6553737d.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 10/10] selftests: kvm: Add guest_memfd_preservation_test
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
X-Rspamd-Queue-Id: 639B1A0003
X-Stat-Signature: gc5i5kei3ur8c4qoc6pyqnyat475f11r
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780679334-883969
X-HE-Meta: U2FsdGVkX1/IKFAJ3WlYohqloIm3Aq7/IeLqNfnp9J+D4BRf6i2jkM5egQ7W9mZI/AFUbrAIIN2QxVZO49CPmeCFkHgOI8wYXxpn8ZPyF6bw/WSJAXQWe1vUIbnbO/E6xWQ92i1FDW4nt9cDhaFIvn+YO7Y543EhWZ3Flz4NUNeMm7HQu2uh65hHNj9jubS4T+LtBInmAbrW59n4pmrx832AmVMfznjkfzj8BwVvokABqVZyAH2cxbwRHNf5dkeUA/UrWXbgqGAd7avH5zjaopgAubP9mmB3B0Mgpn++h9/b9tV+y8jx7/XvvcU74alzeqkB8rrurkLWTb2W3ASTxTttX+7+IIxACm4+V4jfKE3PLyrfMsERv9OQ0yatuDewsm/UeEanqXAZVplKOEWjtKmPGx+rhJ6Daci8bwLCsfoWd3IXGJ+x6gq4GNK3MU5iDWkdQQVxj3uMXnx9HXAsEzcFD/A6loLi/K8bnzSjDSrt7i7PFuu1SlzwOlEhPbjwVO1m65fCwtvXkMN1V17kwN+2+u/BXdstmGc+kE0XeM+0RKrUyKm7OEGOaNkYQCMUrhzCbksaDEx9vIRJTWfn8LI3aeP6dJde7OJzkc1vpQqRSBrsB+cHf0OR6SnkEaiw4I2B9xY8qQQnycfGUvOz6ABnPX0WzdJ3uA5ZUOKxqtp8Cyk5QYohwh2wLVyFn3fRlamp6SP7PiTgk8ruwQFzFir5VT4euwFhuY2+Ps7RWvWgaQczzQ00ItesI2vyMyGBNO7Vzzupr9hUYEi5csNuNuY1tvVpxtzl9o239sOqosuxaNEwj5i05zRF3sjKRgBgkPsLi5ew+L9h0C/Pvik/RR1A9/sSYiwGNx/3YcHyxxYw3lQUdialYM71bHk3t0VzQZHJtVeZoS/BeyPVxSxj8N1wf9Sy4PZlUkSdlKMyedkYL9pEkvN5xCdqkDyKM+Txar0aq0nI221akKLoi7d
 NxGjKISQ
 NjkY+QJdvGMVW8YCKjnOssxNUDYhLH6UwJJwzHbHoX4xqiPbI0JVvvyOvxRwd3ZvVwcywnU63rqtHMro5BzmYQSLTvOrFS7Ff/LvCTaGnlF5n6OcYwXX1jA6/2IGePomuwM7XdfkWIbWcxqwQamr+yQBII7rAypI2LXz6V6z0TOo1yo+xrsiksugYpJ4YHiiAGPVl4SgYY6YOdUEDXyPwRtls9Q/pNXT1rqYGBHGDPNmq7GQh7w5QM0QCnxepHyPuGHazPBC+R/Uuzv9E6GQ16BYzwJN5ERx32/G5Q8QrF6dRBCMjrY0iWG8n49ftsEuw02vFqyqiktKV+pqbmhOo5BO1SlAOykCC4EHhAWq2Z11WOqmLJZez6k6Ur1iBspepOY9s1advZSJntox2KYw2ILJzEfeNuBGYVju/KYQB8WjBfG50Vum2RWyLNFBkMRW50h8gV2w0B4sp7U74moMlUBrc2D5KQthw9BhevERSUomcaXgIQM531SCB9JEbUD4jMo+kCtOHYDUPn4OJZTbSYxWhUxKtDoNgdtOHbC1nDcrsdl4xF+TPPB6N3XV2rTTNlrn84oh1ANLppJRpvwHJ2KL+sdkup7bVMUppcjxEUJXWXSG0fcGE5Ri4a65QMFNhSo4cxhv/03ezU5fAulTWyVu+64FtJZYS7cBHe90iNwsLzt/n3a75Ij4RWeGj+3w8MpxfSPVD/U/fK573aa4zpcM5DEBIRN50mVQJVRiLAkTm2dtbSguVqstnSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new KVM selftest `guest_memfd_preservation_test` to verify that
guest memory backed by guest_memfd is preserved properly.

The test leverages the Live Update Orchestrator (LUO) infrastructure
to validate that memory folios and configuration layouts are
successfully saved and then restored during kernel live updates,
preventing any memory loss for the guest.

Here, I have used the kvm selftests framework by creating a new
vm and mapping two memory slots to it. One is the code that is executed
inside the vm and other is the guest_memfd whose memory is being
written by the guest code.

In Phase 1: Once data is written the vm exits and wait for the user
to trigger the kexec.

In Phase 2: A new vm is created with retrieved kvm and again two
memory slots are assigned. Once for guest code, and another is for
retrieved guest_memfd where guest_memfd memory is verified by the
executed guest code. If verification succeeds, The test passes.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 230 ++++++++++++++++++
 3 files changed, 236 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ca459d032712..76e59620d2f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14419,6 +14419,7 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/liveupdate/vmm.rst
+F:	tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89..68584d4ee1b0 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -161,6 +161,8 @@ TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
+# Manual test that forks a persistent background daemon; skip auto CI run
+TEST_GEN_PROGS_EXTENDED_x86 += guest_memfd_preservation_test
 
 TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
@@ -254,6 +256,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -308,7 +311,8 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) \
+						$(LIBCGROUP_O) $(LIBLIVEUPDATE_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
diff --git a/tools/testing/selftests/kvm/guest_memfd_preservation_test.c b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
new file mode 100644
index 000000000000..74f90c5c4bf5
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026, Google LLC.
+ *
+ * Author: Tarun Sahu <tarunsahu@google.com>
+ *
+ * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
+ *
+ * NOTE: This is a MANUAL test and is excluded from automated CI/testing
+ * frameworks because Phase 1 daemonizes into the background to pin resources
+ * and requires a human operator to manually trigger kexec before Phase 2
+ * is executed. Running Phase 1 automatically would leak the background daemon
+ * and cause CI runners to falsely interpret it as a passed test.
+ *
+ * Usage:
+ * Phase 1: ./guest_memfd_preservation_test
+ * Phase 2: ./guest_memfd_preservation_test --phase2
+ */
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/sizes.h>
+#include <linux/falloc.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall_common.h"
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+
+#include <libliveupdate.h>
+
+#define SESSION_NAME "gmem_vm_preservation_session"
+#define VM_TOKEN 0x1001
+#define GMEM_TOKEN 0x1002
+
+#define GMEM_SIZE (16ULL * 1024 * 1024)
+#define DATA_SIZE (5ULL * 1024 * 1024)
+
+static size_t page_size;
+
+/* Deterministic byte pattern generation based on offset */
+static inline uint8_t get_pattern_byte(size_t offset)
+{
+	return (uint8_t)(offset ^ 0x5A);
+}
+
+static void guest_code_phase1(uint64_t gpa, uint64_t size, uint64_t data_size)
+{
+	uint8_t *mem = (uint8_t *)gpa;
+	size_t i;
+
+	for (i = 0; i < data_size; i++)
+		mem[i] = get_pattern_byte(i);
+
+	GUEST_DONE();
+}
+
+static void guest_code_phase2(uint64_t gpa, uint64_t size, uint64_t data_size)
+{
+	uint8_t *mem = (uint8_t *)gpa;
+	size_t i;
+
+	for (i = 0; i < data_size; i++) {
+		uint8_t val = get_pattern_byte(i);
+
+		__GUEST_ASSERT(mem[i] == val,
+			       "Data mismatch at offset %lu! Expected 0x%x, got 0x%x",
+			       i, val, mem[i]);
+	}
+
+	GUEST_DONE();
+}
+
+static void do_phase1(void)
+{
+	uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	int gmem_fd, dev_luo_fd, session_fd, ret;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
+					guest_code_phase1);
+	gmem_fd = vm_create_guest_memfd(vm, GMEM_SIZE, flags);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
+				 gmem_fd, 0);
+
+	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
+		virt_pg_map(vm, gpa + i, gpa + i);
+
+	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	dev_luo_fd = luo_open_device();
+	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
+
+	session_fd = luo_create_session(dev_luo_fd, SESSION_NAME);
+	TEST_ASSERT(session_fd >= 0, "Failed to create LUO session");
+
+	ret = luo_session_preserve_fd(session_fd, vm->fd, VM_TOKEN);
+	TEST_ASSERT(ret == 0, "Failed to preserve VM file descriptor");
+
+	ret = luo_session_preserve_fd(session_fd, gmem_fd, GMEM_TOKEN);
+	TEST_ASSERT(ret == 0, "Failed to preserve guest_memfd file descriptor");
+
+	printf("\n============================================================\n");
+	printf("Phase 1 Complete Successfully!\n");
+	printf("VM file and guest_memfd file have been preserved via LUO.\n");
+	printf("Tokens: VM_TOKEN=0x%x, GMEM_TOKEN=0x%x\n", VM_TOKEN, GMEM_TOKEN);
+	printf("Machine Size: %llu MB, Data Size: %llu MB\n", GMEM_SIZE / SZ_1M,
+				 DATA_SIZE / SZ_1M);
+	printf("------------------------------------------------------------\n");
+
+	daemonize_and_wait();
+}
+
+static struct kvm_vm *vm_create_from_fd(int resurrected_vm_fd,
+					struct vm_shape shape)
+{
+	struct kvm_vm *vm;
+
+	vm = calloc(1, sizeof(*vm));
+	TEST_ASSERT(vm != NULL, "Insufficient Memory");
+
+	vm_init_fields(vm, shape);
+
+	vm->kvm_fd = open_path_or_exit(KVM_DEV_PATH, O_RDWR);
+	vm->fd = resurrected_vm_fd;
+
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vm->stats.fd = vm_get_stats_fd(vm);
+	else
+		vm->stats.fd = -1;
+
+	vm_init_memory_properties(vm);
+
+	return vm;
+}
+
+static void do_phase2(void)
+{
+	int retrieved_vm_fd, retrieved_gmem_fd, dev_luo_fd, session_fd;
+	struct vm_shape shape = VM_SHAPE_DEFAULT;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+
+	dev_luo_fd = luo_open_device();
+	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
+
+	session_fd = luo_retrieve_session(dev_luo_fd, SESSION_NAME);
+	TEST_ASSERT(session_fd >= 0, "Failed to retrieve LUO session");
+
+	retrieved_vm_fd = luo_session_retrieve_fd(session_fd, VM_TOKEN);
+	TEST_ASSERT(retrieved_vm_fd >= 0, "Failed to retrieve VM file descriptor");
+
+	retrieved_gmem_fd = luo_session_retrieve_fd(session_fd, GMEM_TOKEN);
+	TEST_ASSERT(retrieved_gmem_fd >= 0, "Failed to retrieve guest_memfd file descriptor");
+
+	vm = vm_create_from_fd(retrieved_vm_fd, shape);
+
+	u64 nr_pages = 2048; /* 8MB is plenty for slot0 pages */
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	for (int i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
+
+	struct userspace_mem_region *slot0 = memslot2region(vm, 0);
+
+	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
+
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
+				   retrieved_gmem_fd, 0);
+
+	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
+		virt_pg_map(vm, gpa + i, gpa + i);
+
+	vcpu = vm_vcpu_add(vm, 0, guest_code_phase2);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
+
+	printf("Resuming / Running VM in Phase 2...\n");
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	printf("\nSUCCESS: Phase 2 Complete! All 5MB complex data verified intact!\n");
+
+	luo_session_finish(session_fd);
+	close(session_fd);
+	close(dev_luo_fd);
+	/* This will also close the vm_fd */
+	kvm_vm_free(vm);
+	close(retrieved_gmem_fd);
+}
+
+int main(int argc, char *argv[])
+{
+	bool phase2 = false;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	page_size = getpagesize();
+
+	for (int i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "--phase2") == 0)
+			phase2 = true;
+	}
+
+	if (phase2)
+		do_phase2();
+	else
+		do_phase1();
+
+	return 0;
+}
-- 
2.54.0.1032.g2f8565e1d1-goog


