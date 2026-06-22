Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D667ACD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541446B0098; Mon, 22 Jun 2026 14:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519216B0099; Mon, 22 Jun 2026 14:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455C26B009B; Mon, 22 Jun 2026 14:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA50B6B0098
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F5E41666EB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:15 +0000 (UTC)
X-FDA: 84908436270.07.3CA26FC
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 31F634000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOCWebmA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3p4M5agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3p4M5agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPJYW9yyEh5zSHVb+w9eMw3NvjLrmM4On0OVVA4PIM4=;
	b=10Iq8St/J8jp//q8y0O8d3F4Mphs7th/UKJF5D754srsf3ZOmiZF8v16ZW9Uqxk7/7ROLO
	nq4C5yFF1kCZtmwRNX6qTV9P9p5+KtGX09YOg03pgSRy+dxRhnu/rsFuG9nPiiuHGbbIMZ
	SBCzynO0xGK7Ww8hIAAPGXWOJ1t/3do=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOCWebmA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3p4M5agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3p4M5agkKCOwhOfibgOViUccUZS.QcaZWbil-aaYjOQY.cfU@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154153;
	b=mjRcP/9+De1Y0dpG8D9w74157aMgEirRi1Zyd5kDFuxhBW8JYNl+wZBLGvCuSovyn88yvn
	Mc7yC/xKxA9xFSKwHDehg54mIKlH3NUV1JASxeiwPXJLdNDS1Q/zIAqjnMAOlF3HyKa7VN
	5wdlbtEaPJbVbq8SOtHlJbSMzv6zAuk=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69763fd5cbcso3889889a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154152; x=1782758952; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPJYW9yyEh5zSHVb+w9eMw3NvjLrmM4On0OVVA4PIM4=;
        b=BOCWebmA5/RWJSyxiHlA8Rxy18NpH+HquLUKz+gjxiIbBjlroulZn/eMfYphbd1CW9
         7r2vBMPaJI8IdJhDSXPVgKmmk6k6m2h6dUfhi5DEpTvLf4MOu9nI/3clutrxQIXuSaSS
         LOg8ARPgeKN1u2yEbpgTqCaakOnNFSffWhC7yre44muQNvopNR3YND0+f2hBh2E2AIW7
         HnMKyOPaNK30Ku8mD9QoA6dL1eBKJz9vzDSQSo6zTZGiMOepVbjSK7XhcYteKqqjsefG
         p6SeoKx51ocp7W78ckaTvaw/oOtRHUBseveCL8ZXWuTVLe6kgIcRrxFs7ImplvuAe0SA
         uVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154152; x=1782758952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPJYW9yyEh5zSHVb+w9eMw3NvjLrmM4On0OVVA4PIM4=;
        b=JrTc3F2kQNfS4R//WGmjLsIXFw5QH0zYsXnzIoEtZkCoRHfg/Saj9gfAQo/K4uAhHZ
         8X0l5AOWi9x/+L4lgbb4FT7WuLto23MtrdKzGZ9YOpjn4aLoYUkZlB5LcxkaQSSddTy1
         5bUEOY7wVXY3LD+Afa3k6bPjZmLs8gGQFIL7YYqdLiFppsKErFe6rVZG/pnmMMqBrjwV
         Tl2I3RCJWhMqFZy24LrA8EiBRH8qS282EyDS6gVXgN5+zPX90piqgRsTYw/3hYmq0ExQ
         x6ltvNoyPBtycC+vKFT9mC7H8Pmmj0fXEsbT9vQYKS4m8YFsrrOL//CjN8EXLJUvD1ly
         cp/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+ZBG4tyN7PgAggypDMy8FwuP2GXaVpJIGuUNwcusgDSPRjJ3dW0XQI6FVW/rANIpjLQEHtlGBZsw==@kvack.org
X-Gm-Message-State: AOJu0Yw5gEV7lNDSbB5axMQbchw1SXI0qaZ6ZcE0clAOSd8vFauhnBA+
	qXh5pvp3OrOHlIbkwjSNANgGJ6N2bRwyY+V639NWYfwsMWi5rNP4T7BjQkjp23cVYC5oS9Qgecu
	v8GVFnwB2dj8cwRGfLw==
X-Received: from edl4-n1.prod.google.com ([2002:a05:6402:4244:10b0:697:7e74:f769])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:51cd:b0:697:b75d:fa13 with SMTP id 4fb4d7f45d1cf-697b75e01d3mr2901786a12.6.1782154151321;
 Mon, 22 Jun 2026 11:49:11 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:51 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-10-tarunsahu@google.com>
Subject: [PATCH v3 9/9] selftests: kvm: Add guest_memfd_preservation_test
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
X-Rspamd-Queue-Id: 31F634000B
X-Stat-Signature: rgjn3y5rx9c5wm8qesbsux7j3dp5pq38
X-Rspam-User: 
X-HE-Tag: 1782154152-654270
X-HE-Meta: U2FsdGVkX18eKg7umx9vKv82XogVYo8DHi59WNThrYe+OtnSMK8z22/m/Z+cb6zDmTNVVtLtgt33OJVoHVGH3M9VhpXB4qQjLjeLbQR9MmQlojm44PNEn6Y0kXRT4tUTnIP6Mo4nGdiv0FKGmRfrkmDoF20atwBybm30oOC4WJUCWa2VnXr015LnIRhLDpOMDl3Tl33rgXBhY59SFyapzLUJ/MyH79+Ba77XAJQsMS4+4Ic6BVypPsVUmDmPIf3I8vWlSvetgHNvqXktEpIMWpRzbtyfbw5aUJD/SrvbD/JZq/aGxLPBxbOorK/9LfKgc0vh5pWKPZkrf7eAeDm+jAM2K1z43g1m9jVStIE0tb7DHVF1k87HZMkdplpBgpiQU4iq1Xt6BeZ201zJKA/wSDjUX8pWcIFiEMkxhzBHRTG5NLRCBK3WA760/GGNFeoBP4vDFGG7VGASbtRzz4km8+4MWahKbi7TM/MdNgGuzLj0M4qcFHSaVH0EslyGVSUXilTl/87k7tDEzMg32Dsc3HDMpU1vJXvVdpiFNeuYsne7WDIqPLXVSuZhyVQH2IcRUy+bJiocWztu9HiPFJZBwi/oqVnN62gWPtlgeJkZAq4EtV0hrNvT16c4hDVdQttuuDchOgMwCa8LSeyQrkdYV+NSv0AkDeAPh/4JqKgNMAp7DPnS6wZxpFPXqslxjlnjannpRHemfLoCtG0RYWtDePTlH9EsR1bBwai9iGHVnn8o3vA+gxAyLIIHS9/tM1rwK+pepPiKaGcvrrg3xdgAwmeM49uuxVqPBkn3Dq6FeKWngm1Owwf/pwZJZ6AlBD83LMVCbDyZgc/HoDvbgbEps0mgrlgYcDvL7SGh18wFGgIMHrKvUBlEwPLQU61kSM3FlVRrRRppVYF25tjBw0Gt4YPlsu3gylcXqXi12RVPdCXyTpaxWtAvIYt+bq0gswu7x38mAsOoPDSPCij5a6v
 Cm83VXa5
 UXGioGeNyxZIGmV6bo6xwF1h/ocTce4C6QZBnETWiI+K7tRtZ9DbFb8N8+q7b6gfra/PAkPQHm0Bqqb1+t5sgwo8JZk4SIQb8cUTaqa0K7V4u4aJDGC7eXd3RPaRYdU7FVmCtY0kSB9wCHDpA/UZr06Vvy40iqpZDFUOEBHM4lfSyRQtrwNYJTuy57VqtTl3PHLGJ/yg0S7um+oKLlAUj32yvcr5OseKG/Fg2dRySwPQmMYro3b1iHG8zWMatqWewnhw0JU2EXsp9/7t3OzJrRMBlETo7P1XxBs2VfIXIkpxt7XeXsSM5ZvSS6FZfkJjWSO/tFbxmYmFNJMf7vqC02gxSPqp6v1SwCyw3qFxKEPgrFINZkH+7uq6EGJqCdvUG++NxRWULGW/5Hs0dh6k7blaOkIvYpYM9JwwLiHDvhtWvKdeWuPanc8HNT78isIxB1OFZPgqgMs5C07ROPzbqBnZH9dzEi66WP58S0Sb2mpMuYt08Eakp3OktpDlTZFKI3oBWy8gjzE3RKoTVo0odIOR7New2o8MXBzhe6GgBVZIzrCWrUH31WKi8hR8O+EEYQKAx3gravPw95lvlsKNS6MHv3MR/Gu8Gnsvtwbo7D3dbZMNDx1uly2BXeOR8KCikxT2WmeEaCSXM1m9naFPNHzLG6e7Vt9M+u9LO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new KVM selftest `guest_memfd_preservation_test` to verify that
guest memory backed by guest_memfd is preserved properly.

Here, I have used the kvm selftests framework by creating a new
vm and mapping two memory slots to it. One is the code that is executed
inside the vm and other is the guest_memfd whose memory is being
written by the guest code.

In Stage 1: Once data is written the vm exits and wait for the user
to trigger the kexec.

In Stage 2: A new vm is created with retrieved kvm and again two
memory slots are assigned. Once for guest code, and another is for
retrieved guest_memfd where guest_memfd memory is verified by the
executed guest code. If verification succeeds, The test passes.

// Kernel is compiled with CONFIG_LIVEUPDATE_GUEST_MEMFD and booted
// with kho=on liveupdate=on command line parameter.

$ ./selftests/kvm/guest_memfd_preservation_test --stage 1
$ <kexec>
$ ./selftests/kvm/guest_memfd_preservation_test --stage 2

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 236 ++++++++++++++++++
 3 files changed, 242 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e27b677..d0033a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14421,6 +14421,7 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/liveupdate/vmm.rst
+F:	tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index d28a057..d5bc8be2 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -164,6 +164,8 @@ TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
+# Manual test that forks a persistent background daemon; skip auto CI run
+TEST_GEN_PROGS_EXTENDED_x86 += guest_memfd_preservation_test
 
 TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
@@ -258,6 +260,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -312,7 +315,8 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
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
index 0000000..c0a20e7
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026, Google LLC.
+ *
+ * Author: Tarun Sahu <tarunsahu@google.com>
+ *
+ * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
+ *
+ * NOTE: This is a MANUAL test and is excluded from automated CI/testing
+ * frameworks because Stage 1 daemonizes into the background to pin resources
+ * and requires a human operator to manually trigger kexec before Stage 2
+ * is executed. Running Stage 1 automatically would leak the background daemon
+ * and cause CI runners to falsely interpret it as a passed test.
+ *
+ * Usage:
+ * Stage 1: ./guest_memfd_preservation_test --stage 1
+ * Stage 2: ./guest_memfd_preservation_test --stage 2
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
+#define STATE_SESSION_NAME "gmem_preservation_state"
+#define STATE_TOKEN 0x999
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
+static void run_stage_1(int luo_fd)
+{
+	uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	int gmem_fd, session_fd, ret;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_TOKEN, 2);
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
+	ksft_print_msg("[STAGE 1] Creating session '%s' and preserving VM/guest_memfd...\n",
+		       SESSION_NAME);
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
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
+	close(luo_fd);
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
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int retrieved_vm_fd, retrieved_gmem_fd, session_fd, stage;
+	struct vm_shape shape = VM_SHAPE_DEFAULT;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d", stage);
+
+	ksft_print_msg("[STAGE 2] Retrieving session '%s'...\n", SESSION_NAME);
+	session_fd = luo_retrieve_session(luo_fd, SESSION_NAME);
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
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	/* This will also close the vm_fd */
+	kvm_vm_free(vm);
+	close(retrieved_gmem_fd);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	page_size = getpagesize();
+
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
-- 
2.55.0.rc0.786.g65d90a0328-goog


