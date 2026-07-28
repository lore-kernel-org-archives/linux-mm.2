Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E193C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380E16B00A9; Tue, 28 Jul 2026 08:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35DE36B00AA; Tue, 28 Jul 2026 08:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E3C6B00AB; Tue, 28 Jul 2026 08:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF5C96B00A9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F82FC032D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:57 +0000 (UTC)
X-FDA: 85038071874.23.E47954A
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf17.hostedemail.com (Postfix) with ESMTP id A09AB40009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WnWKf6JG;
	spf=pass (imf17.hostedemail.com: domain of 3ipxoagkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ipxoagkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6vavulIE7r7UKcwDAn6bF21k1jHwV10gRAXEWuRywE=;
	b=mEx5KwvEAMXjg4xkSGaKuXxWN8ov6YU9T1lGaOwLHOHYQ9X4zDnRbagvwWUxz5VkvFQf9r
	aVs+P1cOY51kHbE9iLlouJCoo70biPGZnlUGnNZlv8MJ5Gm/3naM9rKqMWPHdgmNprPtX8
	3cRHxJnT2+EsZ0+sfQ70oOuCiFgKLOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240715;
	b=2uXgsJti2QpnWHRpEk+NOaoIsXCVzxggqAZe66+2bXriLFw7lbF9dK41CU7ErBInrKuT8f
	WEwFc/935areGxXWJKvzUPSWC95OtHXwb4pW/WPYCV1qnyKamB1OB13IieQl6+ZIKsmAne
	tNo7fPKrQxZ4hbE7MkYusuN2fRYYflQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WnWKf6JG;
	spf=pass (imf17.hostedemail.com: domain of 3ipxoagkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ipxoagkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698ae260973so4988338a12.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240714; x=1785845514; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W6vavulIE7r7UKcwDAn6bF21k1jHwV10gRAXEWuRywE=;
        b=WnWKf6JGEEnkTlnPYIK25ejxBWuOdOf1FUQxsk/XQT0lq5nbGMW/jQszkv74Bk1Dpt
         XudQLv7Kl4HJpW5Txzqh6zZu1ffP2E/RPyc+QHWtvtyroCkqLhEesVW/mCt3UOq7TVRI
         SMB0YVanFGnwDquVyJGd7MMgV3F4I0T504AVr+CTQ1bMuZvpniDJG4/O5MwA3EhGyvcv
         zZiRWislkn/33p9ywkfC/49Cpo/Quxd+xrkCwgj+yqtlU5xRKHoiLBqWqNwWocC7CGJw
         NbWOEL/GbRX3/3lL/bzGV3vuaxkGWVQ0VtGAXL9IPzOxIbzs2l+en0Sm0zIxXq8XS0tV
         FhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240714; x=1785845514;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W6vavulIE7r7UKcwDAn6bF21k1jHwV10gRAXEWuRywE=;
        b=Ba7vfOD5faC2+jRT8yqW/N6jpSQH8OigfEEigKTjS2kbA4QM+ETue+7N1rPEzXFxZO
         9axmkMFgn1UQTJ6OtouyPSIxNcA9o9EVWb9AsLgINt6fsyY04ebieOIEhLOYSfEJGxgZ
         g2+90cz07fH2edpDg773Hki7li+F9K6XpMnm9X0PN/Dm1R5SWCQfAiH+kAjXjBOxggZh
         1S3oyxaQzdq9SOgdWN3t6ggogo9IfO97t8umE2kmwghe8+yqR+EPS61dTeBLJeXl/oVk
         UKCQG/jOaSPXRriaPjlafNpA5p0JuR+M6RByzUTvb9GrJY+FH9vOW6+Xx66KV6B7xTe7
         Zwng==
X-Forwarded-Encrypted: i=1; AHgh+Rr6ccG3rs1mmSPDMQpORTtUoxvEtwu9K4jEtY5jFKIH5/v/5c78P4k2UfmXbHdvwYsuZuhuxmwc5A==@kvack.org
X-Gm-Message-State: AOJu0Yw/JDCOEpm+OmgkCr82W86PWEWdlQzbG3Ms9YOxF/twRbmCQNGB
	kPwxj2+e93SqpXr0Jmk7wglMRVCpbFZXX/7K/bFE/EtcTTsPxPp4IIMkxddVYunzSwdlQ2uVveG
	erZuMRRssiePUgsmPjw==
X-Received: from edup22.prod.google.com ([2002:a05:6402:10d6:b0:69c:76eb:92a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:21d9:b0:69f:b617:5e99 with SMTP id 4fb4d7f45d1cf-6a034a0b17dmr1091211a12.8.1785240714131;
 Tue, 28 Jul 2026 05:11:54 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:38 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-12-tarunsahu@google.com>
Subject: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A09AB40009
X-Stat-Signature: ihozy7qd3x9xykx8ot8h8d4y7fkpakkp
X-Rspam-User: 
X-HE-Tag: 1785240715-390809
X-HE-Meta: U2FsdGVkX1/FSgPf23rtCIJdLWERENfI1RrkIu0b3JBZXrzgYEaPTon7yKgIK7bQDbC9V+c926l5p8gs4dfWbeGVSWKHtLvB2eqI1J8zm1vl1p4aXVi6HyMPl/hxCmr8ZyGX1/83cg+Ku/JY/La/w8bp5nRZJxTLY1FVKwYEhjEh8rypCsOpCTHRopi8WpU8YhIV37+agRIHm6D93EWhMKlGDC4bgRSVLDsJ/91/CFQ+hBx0VwBKoVsgxkPeiItpo5M1mzAEwKjdREtw0w7tKuZl7RhPj0lnYt4xCQtk8++5Y3uHRP1pSlg76447WxknaeO4YWREtrIN3GoAklTROiDnxPSG+TG24VzUqH45Uw6ut0FGjvdxNt6yRnk7N+183+U9iEyhjhrbGsmCmAPVny+Yf2H3g0hPUukv+mKxj7kpYHussMa7oq0goTQNgsNw3dzlEW9KGepEV3j9eEh9EhGFMITv9ZzZwgBAfpUdM8HVZUeG+iefrcLB113kJ18Y4MdtFyN6UScrsRODoCFcC7sqLhatBRXfqpGQFxjRd8WGk0E+zrp6B8oTela5qqL7tZAmTZ2FQIQYJ9UTOTC+VETUVDTyjfIa2ozWw1SP5hqu+75e9br7gviWHCqUJw2vTbh/J2PJ0HiZgdlcBeVSRmAPLPbioPxtqwmlC73cnKOBuo6n7Bz7AsyChn5RNvXkdhx7RAKFAFq3hQ3uKTil/0JxSsA0Ho3pT/w24TRol4UA1CQvf9zokpBFlicMuD9NPnuoFXtWTZ3PThN+yKGJn4iVi0PxbQmlN6nLN73twUPRZ4FYBrpsi7azXjByWkvr3tIve4gfSBa+G0nJFMUtD7JP7d9ROY7g3Q7xjfZsdNLRkt+IRLe2zP8uPPgbs8gVn5mvjmDwW4RI6bj/uaSxcTSQSeGT9qnrJ9lPuaKZ9TbmIhiFzlBe+eKFh4TF031PlL7Y0i6SHi7AU6UgO3t
 AJwQxwPW
 WZvSRlwr8gUVp9y8o7X/aqbuedyFkBtmr5ntOHyn5rDKYLxRScrERanCl+Un8Sm+WN8z/owzg24tOd3cCLawKOJU52SrcYW0PXKgm4LCDKTBjgEatZ+9sQgj39Y5DPsCBxaowOj2EpjPFygj2wi3DVYT36alVMaRusL3zjGYeVvkJK8wfKAsE6sr5AJ9T6tvysYwDR536NqZziLbJiGe9tgjYvNKUQi3AM5xTw95laRuhFKu8S+aN63GWvP/O3TnbAtjaVT+lKt2hLdFPWqjD6bjYVVKtau+zNqB4So2D5biEovCISLZTtDPYpA3cTIDe6fhEZfMstPqTZGl0XlV2hNnT39fZLHP4soPBiY43+V4OEnud6KKmU/nALqJRJR/pzLyX/mFa9IAbmm1CCGVmOwrNSZo1PEkjUnA07aqXDFuZTX1vqBKT0yvTVRySL4HfnrSfSuDKLrWddKFFJfJYJk2ccFN1tO1F0KY9dTD/SQ2c4rVhVXsWFy6Evkohnzx2hAizOJISwkYjoT7GSHZyCZO92OGIC3O7uo+U0KXM6Fr1NYcAM+PSsSDrgkeWbJWO1fa1upyPKc71xnwcUGovXpI0DhgFPqHPnkHZMONSa/Ihw7M68NLkgIrku9emmCsbHItw8M7y+BNX5Z4Y0okz+5Gv5gIUy5S38htCIsuHE1tJFnJfdf3MlitMXSgO9CAqOK4+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add guest_memfd_preservation_test to verify that KVM VM state and guest
memory backed by guest_memfd are preserved across a kexec reboot via Live
Update Orchestrator (LUO).

This test includes multiple tests
- (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
- (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
- (C) Test to allocate the guest_memfd memory after preservation because
  preservation makes the guest_memfd frozen. Which must fail as well.
- (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
  kexec: Below is the details of stages in this test.

In Stage 1 (pre-kexec), create a VM with a guest_memfd memory slot, run guest
code to write a deterministic pattern into guest_memfd, and preserve both
the VM and guest_memfd file descriptors via LUO. This stage also tests
A, B and C. A, B and C do not require stage2 so they will finish in
stage 1 only.

In Stage 2 (post-kexec), retrieve the preserved VM and guest_memfd file
descriptors, reconstruct the VM using vm_create_from_fd(), re-map the
retrieved guest_memfd, and execute guest code to verify data integrity
against the original pattern.

Example usage:
  $ ./guest_memfd_preservation_test --s 1
  $ <kexec>
  $ ./guest_memfd_preservation_test --s 2

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 357 ++++++++++++++++++
 3 files changed, 363 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c032f9a0451b..df764e430d25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14549,6 +14549,7 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/liveupdate/vmm.rst
+F:	tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4ace12606e93..02cfd7fc718e 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -165,6 +165,8 @@ TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
+# Manual test that forks a persistent background daemon; skip auto CI run
+TEST_GEN_PROGS_EXTENDED_x86 += guest_memfd_preservation_test
 
 TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
@@ -259,6 +261,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -313,7 +316,8 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
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
index 000000000000..b790f2529837
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
@@ -0,0 +1,357 @@
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
+ * Stage 1: ./guest_memfd_preservation_test --s 1
+ * Stage 2: ./guest_memfd_preservation_test --s 2
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
+#define TEST_PASSED(fmt, ...) ksft_print_msg(fmt, ##__VA_ARGS__)
+
+#define SESSION_NAME "gmem_vm_preservation_session"
+#define VM_TOKEN 0x1001
+#define GMEM_TOKEN 0x1002
+
+#define STATE_SESSION_NAME "gmem_preservation_state"
+#define STATE_TOKEN 0x999
+
+#define UNSHARED_GMEM_TOKEN 0x9001
+#define MMAP_ONLY_GMEM_TOKEN 0x9002
+#define NON_GMEM_TOKEN 0x9003
+#define FROZEN_GMEM_TOKEN 0x8888
+
+#define GPA SZ_4G
+#define GMEM_MEM_SLOT 1
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
+static void guest_code_phase1(uint64_t gpa)
+{
+	uint8_t *mem = (uint8_t *)gpa;
+
+	for (size_t i = 0; i < DATA_SIZE; i++)
+		mem[i] = get_pattern_byte(i);
+
+	GUEST_DONE();
+}
+
+static void guest_code_phase2(uint64_t gpa)
+{
+	uint8_t *mem = (uint8_t *)gpa;
+
+	for (size_t i = 0; i < DATA_SIZE; i++) {
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
+static void setup_guest_memfd_region(struct kvm_vm *vm, int gmem_fd)
+{
+	vm_set_user_memory_region2(vm, GMEM_MEM_SLOT, KVM_MEM_GUEST_MEMFD, GPA, GMEM_SIZE, NULL,
+				   gmem_fd, 0);
+
+	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
+		virt_pg_map(vm, GPA + i, GPA + i);
+}
+
+static void test_preserve_disallowed_no_init_shared(int session_fd,
+						    struct kvm_vm *vm)
+{
+	int unshared_fd, ret;
+
+	ksft_print_msg("[STAGE 1] TEST 1: Preserving guest_memfd without INIT_SHARED...\n");
+
+	unshared_fd = __vm_create_guest_memfd(vm, GMEM_SIZE, 0);
+	if (unshared_fd >= 0) {
+		ret = luo_session_preserve_fd(session_fd, unshared_fd, UNSHARED_GMEM_TOKEN);
+		TEST_ASSERT(ret < 0,
+			    "Preservation without INIT_SHARED should fail");
+		close(unshared_fd);
+	}
+	TEST_PASSED("[STAGE 1] TEST 1: PASSED\n");
+}
+
+static void test_preserve_disallowed_mmap_only(int session_fd,
+						struct kvm_vm *vm)
+{
+	int mmap_only_fd, ret;
+
+	if (!(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) &
+	      GUEST_MEMFD_FLAG_MMAP))
+		return;
+
+	ksft_print_msg("[STAGE 1] TEST 2: Preserving guest_memfd with MMAP only...\n");
+
+	mmap_only_fd = __vm_create_guest_memfd(vm, GMEM_SIZE,
+					       GUEST_MEMFD_FLAG_MMAP);
+	if (mmap_only_fd >= 0) {
+		ret = luo_session_preserve_fd(session_fd, mmap_only_fd, MMAP_ONLY_GMEM_TOKEN);
+		TEST_ASSERT(ret < 0,
+			    "Preserving guest_memfd with MMAP only should fail");
+		close(mmap_only_fd);
+	}
+	TEST_PASSED("[STAGE 1] TEST 2: PASSED\n");
+}
+
+static void test_preserve_disallowed_non_gmem(int session_fd)
+{
+	int null_fd, ret;
+
+	ksft_print_msg("[STAGE 1] TEST 3: Preserving non-guest_memfd FD (/dev/null)...\n");
+
+	null_fd = open("/dev/null", O_RDWR);
+	if (null_fd >= 0) {
+		ret = luo_session_preserve_fd(session_fd, null_fd, NON_GMEM_TOKEN);
+		TEST_ASSERT(ret < 0,
+			    "Preserving /dev/null should fail");
+		close(null_fd);
+	}
+	TEST_PASSED("[STAGE 1] TEST 3: PASSED\n");
+}
+
+static void test_allocate_while_frozen(int luo_fd, struct kvm_vm *vm)
+{
+	int frozen_session, frozen_fd, ret;
+	uint64_t flags;
+	char *mem;
+
+	flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	if ((vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & flags) != flags)
+		return;
+
+	ksft_print_msg("[STAGE 1] TEST 4: Operations on frozen guest_memfd...\n");
+
+	frozen_session = luo_create_session(luo_fd, "session_frozen_ops");
+	TEST_ASSERT(frozen_session >= 0, "Failed to create frozen test session");
+
+	frozen_fd = __vm_create_guest_memfd(vm, GMEM_SIZE, flags);
+	TEST_ASSERT(frozen_fd >= 0, "Failed to create guest_memfd for frozen test");
+
+	mem = kvm_mmap(GMEM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, frozen_fd);
+	mem[0] = get_pattern_byte(0);
+	kvm_munmap(mem, GMEM_SIZE);
+
+	ret = luo_session_preserve_fd(frozen_session, frozen_fd, FROZEN_GMEM_TOKEN);
+	TEST_ASSERT(ret == 0, "Failed to preserve guest_memfd for frozen test");
+
+	ret = fallocate(frozen_fd, FALLOC_FL_KEEP_SIZE, DATA_SIZE, page_size);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "fallocate on frozen guest_memfd failed ret=%d errno=%d",
+		    ret, errno);
+
+	ret = fallocate(frozen_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, page_size);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "fallocate punch hole on frozen guest_memfd failed ret=%d errno=%d",
+		    ret, errno);
+
+	mem = kvm_mmap(GMEM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, frozen_fd);
+
+	TEST_ASSERT_EQ(READ_ONCE(mem[0]), get_pattern_byte(0));
+	TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[DATA_SIZE]));
+
+	kvm_munmap(mem, GMEM_SIZE);
+
+	luo_session_finish(frozen_session);
+	close(frozen_session);
+	close(frozen_fd);
+
+	TEST_PASSED("[STAGE 1] TEST 4: PASSED\n");
+}
+
+static void test_gmem_preservation_stage1(int session_fd, struct kvm_vm *vm,
+					   struct kvm_vcpu *vcpu, int *gmem_fd)
+{
+	uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	int fd, ret;
+
+	ksft_print_msg("[STAGE 1] TEST 5: Preserving VM and guest_memfd...\n");
+
+	fd = vm_create_guest_memfd(vm, GMEM_SIZE, flags);
+	setup_guest_memfd_region(vm, fd);
+
+	vcpu_args_set(vcpu, 1, GPA);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	ret = luo_session_preserve_fd(session_fd, vm->fd, VM_TOKEN);
+	TEST_ASSERT(ret == 0, "Failed to preserve VM file descriptor");
+
+	ret = luo_session_preserve_fd(session_fd, fd, GMEM_TOKEN);
+	TEST_ASSERT(ret == 0, "Failed to preserve guest_memfd file descriptor");
+
+	*gmem_fd = fd;
+}
+
+static void test_gmem_preservation_stage2(int retrieved_vm_fd,
+					   int retrieved_gmem_fd)
+{
+	struct userspace_mem_region *slot0;
+	struct vm_shape shape = VM_SHAPE_DEFAULT;
+	u64 nr_pages = 2048; /* 8MB for slot0 pages */
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int i;
+
+	ksft_print_msg("[STAGE 2] TEST 5 (cont): Verifying VM & guest_memfd data...\n");
+
+	vm = vm_create_from_fd(retrieved_vm_fd, shape);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0,
+				    nr_pages, 0);
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = 0;
+
+	slot0 = memslot2region(vm, 0);
+	ucall_init(vm, slot0->region.guest_phys_addr +
+		       slot0->region.memory_size);
+
+	setup_guest_memfd_region(vm, retrieved_gmem_fd);
+
+	vcpu = vm_vcpu_add(vm, 0, guest_code_phase2);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	vcpu_args_set(vcpu, 1, GPA);
+
+	printf("Resuming / Running VM in Phase 2...\n");
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	/* kvm_vm_free will also close retrieved_vm_fd */
+	kvm_vm_free(vm);
+	TEST_PASSED("[STAGE 2] TEST 5: PASSED\n");
+}
+
+static void run_stage_1(int luo_fd)
+{
+	int gmem_fd, session_fd;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_TOKEN, 2);
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
+					guest_code_phase1);
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' and preserving FDs...\n",
+		       SESSION_NAME);
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
+	TEST_ASSERT(session_fd >= 0, "Failed to create LUO session");
+
+	/* Run negative tests for disallowed preservation conditions */
+	test_preserve_disallowed_no_init_shared(session_fd, vm);
+	test_preserve_disallowed_mmap_only(session_fd, vm);
+	test_preserve_disallowed_non_gmem(session_fd);
+
+	/* Run operations on frozen guest_memfd test independently */
+	test_allocate_while_frozen(luo_fd, vm);
+
+	/* Run primary VM & guest_memfd preservation test */
+	test_gmem_preservation_stage1(session_fd, vm, vcpu, &gmem_fd);
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
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int retrieved_vm_fd, retrieved_gmem_fd, session_fd, stage;
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
+	/* Run primary VM & guest_memfd post-kexec data verification */
+	test_gmem_preservation_stage2(retrieved_vm_fd, retrieved_gmem_fd);
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
2.55.0.229.g6434b31f56-goog


