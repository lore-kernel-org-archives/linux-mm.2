Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376B4CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E58B6B009E; Mon, 18 May 2026 05:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA996B009F; Mon, 18 May 2026 05:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788616B00A0; Mon, 18 May 2026 05:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD746B009E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A7C39263B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:55 +0000 (UTC)
X-FDA: 84780036390.27.98DFC41
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53FBC140003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oGrOxfZq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3s90KagkKCPAlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3s90KagkKCPAlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097013; a=rsa-sha256;
	cv=none;
	b=k06rOnjKSYzqr3bAgRljL/IQ8/VOhsjWhkAJoMWa+chGihKkXyoNR9fWt4b7N8QKBmt88J
	T9C15HhHRha+kpc15CYFCdOCOTcrcJirscflSXYaDXTHda2uKMQuB7yEfS6BzAekOaMy5H
	m3JQkmRUpiu/asUhZws0ei/i7IWBTNU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oGrOxfZq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3s90KagkKCPAlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3s90KagkKCPAlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7OlXwmA5HFHQvyK/b9w4xYG/XKhpdapsDQN7y6zQXo=;
	b=Sg9qjC55PJA99iHHurbdES3urH5HYxMK7ovONEK4dYCdCYUeIDUvnnELMP6gH3HuMZEB2I
	ruLC9NpLd+l51yIva+Ee2Ah5DUDbZq0VOs3zfLnQu7pdJ75kBg/N36IWfxHBR4UoA5suaN
	bPuNnahp4YlYl7I+hnZpqdquKLnlhXk=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-671656523efso2891695a12.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097012; x=1779701812; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7OlXwmA5HFHQvyK/b9w4xYG/XKhpdapsDQN7y6zQXo=;
        b=oGrOxfZqOnnxXoTiHFktaVx/JrX//p64YhJYyIxy6qR0YgQatLBgLCyvKW8aVqHcHT
         /k3cpGdCzDvDNj8VX55d5UEIuhga6lOKgqL9PTUbeMGLVWd/sB6Xuj7pXh2mgq7hNNPz
         uxFw9gjgOEFutd1D4b0bieYFg+fBfMOk8f7uY5RBA+ae/eZ/PJvMtlzradWovOePuexT
         H4EbD8d8XfvF+VA7AMzo4Mo06MvXP5kJd+/wcUL4V21owntu+w3GxhjayI0cUS4l6KfN
         9/thmdVCRZgLvHHqrwvHO80nLExr2WJ8ZsUozFMENvUyNTqyiWImjybNYcsBylYlwi9e
         QwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097012; x=1779701812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7OlXwmA5HFHQvyK/b9w4xYG/XKhpdapsDQN7y6zQXo=;
        b=MyjU0X8aFp/g0m8qwS84zKWllmZyeZcC+GMYtqlNjQ2nFjdEzv//WYyLIq8SecYn+K
         hDz+k9XYqG/UkN4YqnCg7dJr4GhU+L6msahHS4UvOhrJUCF2ID2VB+AhALHlMlGUzgsE
         HoFmrHqNQT3E7sJV6ydgXFaczJLGW1glI18EfrAzyROt/G1dDbC96EqrjbL8eE/1lIwF
         Dznl5xJyGwhrUSHq5ZbX23+Jvjmko1FRFaGpNLAiywLLBBRA8UDa857Ao70jU+NvhFR5
         Q6vKhDigOHhICebxzq8Mh6VMFtMceLqrv2Y2XDKDVMBYggRZWLpohE/E4pMtM2/lZemZ
         4wqw==
X-Forwarded-Encrypted: i=1; AFNElJ8GZpme0+uPMyeFI2w+nLSf9slbH/ziuqigyOv12DSPdcKWBCmGluyo3mB4lvj46Y7pnpby4mtXLA==@kvack.org
X-Gm-Message-State: AOJu0YzHLUKJ2/ABrkSPRobhzUZNRS/Z8VX0Bci6gxLSWRsiuF+R0sKO
	olSiRUiamaSBW/ZvIKLydZ+O6/bovMI1kiz/j2VKTwV249npwb7t16o5r+K9OC/aC//1TP1YfZH
	twWlZ6ARRzOPZINewjA==
X-Received: from edgg22.prod.google.com ([2002:a05:6402:1ed6:b0:67e:2459:8ce9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13c2:b0:67c:7ffc:c4b with SMTP id 4fb4d7f45d1cf-683bd384cdbmr7475294a12.19.1779097011469;
 Mon, 18 May 2026 02:36:51 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:39 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <a1bc78e4f43b5b6b079012954af9af1cf864b3f8.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 9/9] selftests: kvm: Add guest_memfd_preservation_test
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
X-Stat-Signature: icfx4h1ib5e8n5tggaz58eso1dp3r8ks
X-Rspam-User: 
X-Rspamd-Queue-Id: 53FBC140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779097013-444085
X-HE-Meta: U2FsdGVkX1+GJnKFp7RkVKBm5iTcvgmybaPLqoyoiCRTKw9nHTR33ykKk8Pk1hIY/52SJq3ZUVpTWwCA5cVzLIRtbZZdvVkeHuKvEVuGrZ4LL2MNT4iSjmnQtkDtyN0Vp2BIERKRb1kGsrVZzYv2WSCTecMRDKGMF7n/SFVVn17sLU7k7mDtTl1qsaT7pcMSVLFjJ3F7kC4Z7X90h8qoRvVbdiw/7gRKO1Wfmor/Gr+5lveYprk7yAktncT19pWM8hOTgZYKyqeppxeYpGyVxMf24WzUVj5YkMahKnE8K1Tm+XWIRhczt1BLDQ5ytYKvzzZDSM34Ffa3me8zCA60cwhRNgt/pwUj6+l4nt9MiNV1XH22AeO8MoQZDZbuawFpUAn2spUmpMI8/UQx+bo1NE0R/4y/hMK6njD/F/VdmXg9v0lCT5Zmm69bpxkoy+Cc94N0TkKaIGdxZHJU8WTsJGYsg7t43JRV+h3JCtWXTfr2rUpf84TpJzs9pawNYXtFfaD/v1ihfRPPVQVjUIkpFA58mgiaWmpckLtftWUn0ENQqHxh5KHI5r3ew6fv4xqHvETjuVm5ZkcAdHdwxqlc/U1SiL4wI6TDeUgryf2x0/1INqTqBkj+NqA/5Mdf6CP3ZJuMmDzXq5btphAVh57G6iVq5tJBMrJYZUqwEImrESrYNER5vaplQF1nc741dyKeF05k0XYjoU2KfacUlcSeaWGQHc8VUyLAuYzEJGBfOcSRM7kZppOP4oSofX/HKyMOU1fbskQdLmRzAiDH4/hbuubdishEs83bAhptVSIqY4LFDEKTcx170tB7vg+RnTPRxRNs92L2Wf0GWBbXfTfV3EQrghN0rc3Qm7K5xdgW+fKeHS8zArIV0Nmiib4MFEQd2Q2UeA7w+vpFzLaa3BqePht+vgzAV7G8Q+AdltK+VWmwa6EV9Zc7aWpXUXfxVxRwE58Mf0nb7D7uGcgvz12
 YubMZzg4
 ZIxYw+RFOjWtc26+4G8KIdOapoTLCflFMzeOOnQVFlCWtPyeiY2IPUyveHy8A05a3ASC7lXnng+sC3ps4BlSRKTEEP96pH75iFgq5EkTiVxq4cpCnd4uIxgAuxUY7HOOpypciMqV/ZPZYZCIrMaPoNgJCC5FC/G6YsBaLh9vexRMUyetPay0yUpYH3nD0qqY4McEyTnqiY6YB0yBb24rQSWyjjOSkiI1b2/75YX3pegkAObDOJO/TVMGRAow431KC+1PRWmU3GE+L6KWutkSa68cnv0+tgUthfa4LUFBFkGFohK4SMwjiFGQIekDCgWcpehn9/bL0I6uhq8VwymgkFdtDNMiHHib5OucJd3s5NrVoSRg7idw50NzaFRAyCoO9BEFMZxOleazICf4jY3QdEdzqPZITb+QR2/WfnAfG29Nv1a9Y567/I25kV6nSmyEn3q4UuhZ+tKBVmimj7V4/aa27+XMxg89YfOxmjpotP++QObn/w731R6kPhAPNywjVPgJvDg9/7ZeLNkmVmJZvZtgVKqjt9SWtnwRnDFUcQh+WJbC0lj4l7vsD9ld6NESB+HcCeFZVq3nDKU4+Uw3ecmAvPBF6hLsO0XruIIIBPGQeXYnozjhCtWp0YDq3ht5VCvjw9SRU4S0zCn7MIRtLwzmtGqI4GxCqcUfvrH/ryFNAeMsx/C4QjA1qySRDWmp4yZLG/8LQyoNoDOucWymC8eFLzw==
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
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../kvm/guest_memfd_preservation_test.c       | 285 ++++++++++++++++++
 3 files changed, 288 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e5402a56ab98..647d60f6a1e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14413,6 +14413,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89..4ea6cb7bf001 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -161,6 +161,8 @@ TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
+# Manual test that forks a persistent background daemon; skip auto CI run
+TEST_GEN_PROGS_EXTENDED_x86 += guest_memfd_preservation_test
 
 TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
diff --git a/tools/testing/selftests/kvm/guest_memfd_preservation_test.c b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
new file mode 100644
index 000000000000..ad7b305b48c3
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
@@ -0,0 +1,285 @@
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
+#include "../../../../include/uapi/linux/liveupdate.h"
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
+	int gmem_fd, dev_luo_fd, ret;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+	struct liveupdate_ioctl_create_session create_sess = {
+		.size = sizeof(create_sess),
+		.name = SESSION_NAME,
+	};
+	struct liveupdate_session_preserve_fd preserve_vm = {
+		.size = sizeof(preserve_vm),
+		.token = VM_TOKEN,
+	};
+	struct liveupdate_session_preserve_fd preserve_gmem = {
+		.size = sizeof(preserve_gmem),
+		.token = GMEM_TOKEN,
+	};
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
+					guest_code_phase1);
+	gmem_fd = vm_create_guest_memfd(vm, GMEM_SIZE, flags);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
+				 gmem_fd, 0);
+	ret = fallocate(gmem_fd, FALLOC_FL_KEEP_SIZE, 0, GMEM_SIZE);
+	TEST_ASSERT(!ret, "fallocate failed, errno = %d (%s)", errno, strerror(errno));
+
+	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
+		virt_pg_map(vm, gpa + i, gpa + i);
+
+	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	dev_luo_fd = open("/dev/liveupdate", O_RDWR);
+	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
+
+	TEST_ASSERT(ioctl(dev_luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION,
+			  &create_sess) == 0,
+			  "Failed to create LUO session");
+	TEST_ASSERT(create_sess.fd >= 0, "Invalid session fd");
+
+	preserve_vm.fd = vm->fd;
+	TEST_ASSERT(ioctl(create_sess.fd, LIVEUPDATE_SESSION_PRESERVE_FD,
+			  &preserve_vm) == 0,
+			  "Failed to preserve VM file descriptor");
+
+	preserve_gmem.fd = gmem_fd;
+	TEST_ASSERT(ioctl(create_sess.fd, LIVEUPDATE_SESSION_PRESERVE_FD,
+		    &preserve_gmem) == 0,
+		    "Failed to preserve guest_memfd file descriptor");
+
+	printf("\n============================================================\n");
+	printf("Phase 1 Complete Successfully!\n");
+	printf("VM file and guest_memfd file have been preserved via LUO.\n");
+	printf("Tokens: VM_TOKEN=0x%x, GMEM_TOKEN=0x%x\n", VM_TOKEN, GMEM_TOKEN);
+	printf("Machine Size: %llu MB, Data Size: %llu MB\n", GMEM_SIZE / SZ_1M,
+				 DATA_SIZE / SZ_1M);
+	printf("------------------------------------------------------------\n");
+
+	pid_t pid;
+
+	printf("Forking background process to hold sessions open...\n");
+	pid = fork();
+	TEST_ASSERT(pid >= 0, "fork failed");
+
+	if (pid > 0) {
+		printf("Background child process PID: %d. Resources are pinned.\n", pid);
+		printf("ACTION REQUIRED: Trigger kexec now to boot into Phase 2 kernel.\n");
+		exit(EXIT_SUCCESS);
+	}
+
+	/* Child process: detach from terminal and hold resources */
+	if (setsid() < 0)
+		exit(EXIT_FAILURE);
+
+	close(STDIN_FILENO);
+	close(STDOUT_FILENO);
+	close(STDERR_FILENO);
+
+	while (1)
+		sleep(60);
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
+	int retrieved_vm_fd, retrieved_gmem_fd, dev_luo_fd;
+	struct vm_shape shape = VM_SHAPE_DEFAULT;
+	const uint64_t gpa = SZ_4G;
+	struct kvm_vcpu *vcpu;
+	const int slot = 1;
+	struct kvm_vm *vm;
+	struct liveupdate_ioctl_retrieve_session retrieve_sess = {
+		.size = sizeof(retrieve_sess),
+		.name = SESSION_NAME,
+	};
+	struct liveupdate_session_retrieve_fd retrieve_vm = {
+		.size = sizeof(retrieve_vm),
+		.token = VM_TOKEN,
+	};
+	struct liveupdate_session_retrieve_fd retrieve_gmem = {
+		.size = sizeof(retrieve_gmem),
+		.token = GMEM_TOKEN,
+	};
+
+	dev_luo_fd = open("/dev/liveupdate", O_RDWR);
+	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
+
+	TEST_ASSERT(ioctl(dev_luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &retrieve_sess) == 0,
+		    "Failed to retrieve LUO session");
+	TEST_ASSERT(retrieve_sess.fd >= 0, "Invalid retrieved session fd");
+
+	TEST_ASSERT(ioctl(retrieve_sess.fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_vm) == 0,
+		    "Failed to retrieve VM file descriptor");
+	retrieved_vm_fd = retrieve_vm.fd;
+
+	TEST_ASSERT(ioctl(retrieve_sess.fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_gmem) == 0,
+		    "Failed to retrieve guest_memfd file descriptor");
+	retrieved_gmem_fd = retrieve_gmem.fd;
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
+	close(retrieve_sess.fd);
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
2.54.0.563.g4f69b47b94-goog


