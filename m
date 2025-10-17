Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A97CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7DE8E0063; Fri, 17 Oct 2025 16:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34808E0006; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88B68E0063; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB0268E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8909986DB9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:03 +0000 (UTC)
X-FDA: 84008705046.17.E7387F1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9053DC0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oijV92ba;
	spf=pass (imf10.hostedemail.com: domain of 3TKPyaAsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3TKPyaAsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGBR8ThL9h1g6JtPgOVB6QJAz8D14GRCTcht+yz9Ebg=;
	b=3T69Gm43+zP3KH4v+OQ7cr6aZ2M5mnCOJpcM0FPEcDjcrZUexhSdifvCCzbtLGVgofvJzw
	vw52iXG0GIvj8ouFoQl6+BYcwcvGuA9mFizRaWTmBBAullQaClDgOoCnv7l2qfZWWxew4e
	DukLrhTcW8iCzaoK+eTeoEImwqDq40Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oijV92ba;
	spf=pass (imf10.hostedemail.com: domain of 3TKPyaAsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3TKPyaAsKCKsLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731981; a=rsa-sha256;
	cv=none;
	b=YBEnnhB9sDlnpKBcVYBxPKhh6FrYmhtuqkHbeN6K+fLf/JQo4nlCqYNWccbJE/Mup7BYW6
	hJSCEuFbniBcdSlwFdiplC3ZxX2zeZoc/adqntmVzRahTG3Cyjq3v/Is3fEVvd1zTRIE7q
	FVZzGQC3bIRqo4AESoLt9/Qssw1rlwQ=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b56ae0c8226so1549875a12.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731980; x=1761336780; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YGBR8ThL9h1g6JtPgOVB6QJAz8D14GRCTcht+yz9Ebg=;
        b=oijV92baWpja5toHH+xWq8DrwMPMudubNzXL11XRyPHkf4A5zR3p4avXIzenQ36FTi
         fUOpUZyiEi5dWL1RYDBh+bT1qgPN0HmbomxQxXX7bJXG6Yze291RS22lxK2/lmuMPmhL
         WkAIMNhZsjaFtsylbpt9RCz+m37YpglVJ9gf/bWE0bcPwYJsCFC/1d9fjcrTjeVXQaRC
         zPwk5pMDrZNZhrTQ8fP3N8+zrmOczTGmzqgcFbTsCrfW/zU5rigBBHpF99bi4tHWb01I
         clO9tPJ4lAqeCKZM7hKOCjbhJd4jYqX8hMr/lYgi80ldvlO8t20T9GPwfjH1QGKe6jVq
         BFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731980; x=1761336780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGBR8ThL9h1g6JtPgOVB6QJAz8D14GRCTcht+yz9Ebg=;
        b=ENp1WDDXiQyUCe3EGfzP5lyyJn5lSt+rDAi8CStuodANfPvZMokhtahZVnzGVyDQjx
         fHCO+DPr6ODqO8cnComkGzPn1LAoKHaFT2aUhWcY47ayrcJAoifuL34GAPes/nGQlND8
         ZCi3fcSDiYHDGEBhoZ6vrgWxnaSPuCwajcyT6ST1/zoEzrWdxhmyiguQ5dy7ARyUKe4n
         pTpenTG/LOvY3Rzo9daEY0ED6hkMif/prRYAPXmb+xKtz6p3T2vX+FzIIq55Hm8ryQWK
         PrMc9rtw42wYny2aGRsl3ZoKl2fPaExRm0DEVsBpoa0B4mu6c/+jZhJddkf8DfqqSg7r
         oBqg==
X-Forwarded-Encrypted: i=1; AJvYcCVVpYV1Jp0lmdTTJdbavqIJ0M88DDal0OTKvDHSjc/TjrQdjZQjWjVmuWpvucMF9tPxXR8+7AlV4Q==@kvack.org
X-Gm-Message-State: AOJu0YwFU635eXW6HKmWpugXl5C5g6xw/4jwFh8znzVuGVkR+a/mMuFf
	kqRPa035L5lIZEKeAULvurErZWPuo8wMRIYsjYxPrHl/1dnBriT4aBEM4WWt9fZw0tDarzh+lEF
	Ta/GqvBJWZDobNO1zCfpojUbWWQ==
X-Google-Smtp-Source: AGHT+IGdmlTsq6lbztVMRjjyO56iRkVOugKmnUTTc7HxcXV8zgK0D164prISKUum078Iz7YNEFORelYEVoqF+X0ffQ==
X-Received: from pjbga16.prod.google.com ([2002:a17:90b:390:b0:329:7dfc:f4e1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b0f:b0:33b:6612:67e1 with SMTP id 98e67ed59e1d1-33bcf8fa20fmr5503758a91.29.1760731980245;
 Fri, 17 Oct 2025 13:13:00 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:00 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <023edad5cdfc155a125e30bb3d61aab3fbf6d986.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 19/37] KVM: selftests: guest_memfd: Test basic
 single-page conversion flow
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9053DC0003
X-Stat-Signature: rf8rxutfyet3mrbknuh1hx7zb4ng9q5x
X-Rspam-User: 
X-HE-Tag: 1760731981-613338
X-HE-Meta: U2FsdGVkX19KVZ8HVB3NOOBZYp2OIErXESTPNw7WqN4JEL/TNJ9WE+0o8LzPDVYZm4dRF+onB+UcfJ7/T4wHNApbbqASm20ypdS+WtKusnIo3kZs8OBxld21VOyz5C2m+ezQUl6k+4SWKS7N+MVsrIyWayoIOOBxg4iAXx5V/04xaLJ45Y/fypWjNCCRAV+8kA0V7w7365Nvh/o7bN5azsnXaV/zO4ParwlPUgvG/hnJFWY9QNUS35LwntFW6flJA/N2WggBAqzOoi8aLCV1uJg74dJsVZuTjIdKpHrtqhtWTljzLTwmLlJSpU1E75G4qctig2fjlBOouZOmmvXHyWuWh/3NW+krd1oJHLNXKWVlcko7G+93j8HcxSZD4tjZ2WVIlOc/BtvktsHBCtlwb41V0vE6UDLahqmARS6JaZFSxfMxf5vSPUOkDruQFoKbOZLXZvrKm/u9ufOoRR6VyQtne+1XxaN2HlC7ATACn8mpyb621t74YYT8FoqADGLQfbQgMeuSjwZgxMk9YHqtk6XWjNLOnT51RPwOKbvkpqm5hO95DRM4GgOi9OpRyfF2v0sIojvYaAOoZrJDQvIOBboiSHm0G43EvjBcP+95JiRU7duQHEut/fx/jw0mjnCUOLLuXdiaxdJQVqbODjKBYS/5T3P5jZKhr5HOJaB283+d9jdWF9qI9n8ZXTGVlHzy7XYpJLYWY1f/Z85riK8vu2Bm6y+kdZCPYlCqeErDWjjaBE6fD10OEAMgigznYCVS3G3PJkF+2tIw5T6mJ03MlCH4CiuuSMJ4Q8/WyrVull+j4O7lUOaIy2CpnTh9UDEdXjBzWldLXVtSh/5gND8A4guweIYTOVfYbnUg1yq2a8F6Px3TL0ZJ4gm54PhyaK+dxKrBsVAM9wAk++ia/CxB3gQ8d18WkYqmP/WyyNuzZjIXfONoCKbYBkzcazHBYXTxBai8JUm0sPnBI9C4kEW
 DH3LM7Ri
 dXcUATuuBHjBUUztUczjBdCBNwuRRXc5/PGLeDnUmy4GxnCPfkfm7cy9LTRsnXmlrRetD9KOtpZGPOU474Ghjgul+3xWjQD6H2EUhYdEcwT2F76FleXB8o69oE4Jof2NtvP3Uc2bBJ9ej4USmFyFf5vFr2Uzq31NFurHMt2Q0dSvSfzL6UZCj9kiARCB/Shik8Z24ans0/Nfga7YqW/20VkYzXFmUvP2b1Pa3UkAzYjArfnhQJSzju1THdI7TdE7kisBMO2OpY2/O0WTmKZEk7o6CRGzay+uttG1/DbOzuQ9KytxuEEBExfffGZ0AgNc3EMgAE4EvqEid2FfnvMU/4tTbPBU9zETsm0GbKyQBRxTh1av37hUZqZv9b5H7iJg1M9P7RE0G12wylPSqBHqx7mqqKeDtoWYGra6/6oJ3L24oBphYp/+W/smP6z7FkpHh/ir4pwR43cJ3Nw4t/1WdrTjLRLfDf2Y9Zb/ktgP0fmdM5yHJns7e5U6vKIIwbgBVOv7Pu1INKUDuQ11beD8MI9bi/UA04yRXlBvratsKTuZUe5s8bthxGABSGCwtfB5dLl0NnVG9mNgouNGctoWb776nvjMkSGuoYgOID/4gtF2/PgIuGlTOKRwgENj+bD3t9sS6w1HkBZ3CMTLlEJjcgsbNa6FvVtdsesCkyGa+P8rHPYCCh2dwMKCTYs+nv/oT2/IJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest for the guest_memfd memory attribute conversion ioctls.
The test starts the guest_memfd as all-private (the default state), and
verifies the basic flow of converting a single page to shared and then back
to private.

Add infrastructure that supports extensions to other conversion flow
tests. This infrastructure will be used in upcoming patches for other
conversion tests.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/guest_memfd_conversions_test.c        | 207 ++++++++++++++++++
 2 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_conversions_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24be..ddc1bdd51b834 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -141,6 +141,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86 += memslot_perf_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
new file mode 100644
index 0000000000000..e0370e92e1b24
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, Google LLC.
+ */
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include <linux/align.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "kselftest_harness.h"
+#include "test_util.h"
+#include "ucall_common.h"
+
+FIXTURE(gmem_conversions) {
+	struct kvm_vcpu *vcpu;
+	int gmem_fd;
+	/* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
+	char *mem;
+};
+
+typedef FIXTURE_DATA(gmem_conversions) test_data_t;
+
+FIXTURE_SETUP(gmem_conversions) { }
+
+static uint64_t page_size;
+
+static void guest_do_rmw(void);
+#define GUEST_MEMFD_SHARING_TEST_GVA 0x90000000ULL
+
+/*
+ * Defer setup until the individual test is invoked so that tests can specify
+ * the number of pages and flags for the guest_memfd instance.
+ */
+static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
+				      int gmem_flags)
+{
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+	/*
+	 * Use high GPA above APIC_DEFAULT_PHYS_BASE to avoid clashing with
+	 * APIC_DEFAULT_PHYS_BASE.
+	 */
+	const uint64_t gpa = SZ_4G;
+	const uint32_t slot = 1;
+	struct kvm_vm *vm;
+
+	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
+
+	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
+		   KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);
+
+	t->gmem_fd = kvm_slot_to_fd(vm, slot);
+	t->mem = addr_gpa2hva(vm, gpa);
+	virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, gpa, nr_pages);
+}
+
+static void gmem_conversions_do_teardown(test_data_t *t)
+{
+	/* No need to close gmem_fd, it's owned by the VM structure. */
+	kvm_vm_free(t->vcpu->vm);
+}
+
+FIXTURE_TEARDOWN(gmem_conversions)
+{
+	gmem_conversions_do_teardown(self);
+}
+
+/*
+ * In these test definition macros, __nr_pages and nr_pages is used to set up
+ * the total number of pages in the guest_memfd under test. This will be
+ * available in the test definitions as nr_pages.
+ */
+
+#define __GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
+static void __gmem_conversions_##test(test_data_t *t, int nr_pages);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	gmem_conversions_do_setup(self, __nr_pages, flags);			\
+	__gmem_conversions_##test(self, __nr_pages);				\
+}										\
+static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
+
+#define GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
+	__GMEM_CONVERSION_TEST(test, __nr_pages, (flags) | GUEST_MEMFD_FLAG_MMAP)
+
+#define __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, 0)
+
+#define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
+	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
+
+struct guest_check_data {
+	void *mem;
+	char expected_val;
+	char write_val;
+};
+static struct guest_check_data guest_data;
+
+static void guest_do_rmw(void)
+{
+	for (;;) {
+		char *mem = READ_ONCE(guest_data.mem);
+
+		GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
+		WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
+
+		GUEST_SYNC(0);
+	}
+}
+
+static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
+			     char expected_val, char write_val)
+{
+	struct ucall uc;
+	int r;
+
+	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
+	guest_data.expected_val = expected_val;
+	guest_data.write_val = write_val;
+	sync_global_to_guest(vcpu->vm, guest_data);
+
+	for (;;) {
+		r = __vcpu_run(vcpu);
+		if (!r && get_ucall(vcpu, &uc) == UCALL_PRINTF) {
+			REPORT_GUEST_PRINTF(uc);
+			continue;
+		}
+		if (r == -1 && errno == EINTR)
+			continue;
+		break;
+	}
+
+	TEST_ASSERT_EQ(r, 0);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	case UCALL_SYNC:
+		break;
+	case UCALL_PRINTF:
+	default:
+		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+	}
+}
+
+static void host_do_rmw(char *mem, loff_t pgoff, char expected_val,
+			char write_val)
+{
+	TEST_ASSERT_EQ(READ_ONCE(mem[pgoff * page_size]), expected_val);
+	WRITE_ONCE(mem[pgoff * page_size], write_val);
+}
+
+static void test_private(test_data_t *t, loff_t pgoff, char starting_val,
+			 char write_val)
+{
+	TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
+	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
+	TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
+}
+
+static void test_convert_to_private(test_data_t *t, loff_t pgoff,
+				    char starting_val, char write_val)
+{
+	gmem_set_private(t->gmem_fd, pgoff * page_size, page_size);
+	test_private(t, pgoff, starting_val, write_val);
+}
+
+static void test_shared(test_data_t *t, loff_t pgoff, char starting_val,
+			char host_write_val, char write_val)
+{
+	host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
+	TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
+}
+
+static void test_convert_to_shared(test_data_t *t, loff_t pgoff,
+				   char starting_val, char host_write_val,
+				   char write_val)
+{
+	gmem_set_shared(t->gmem_fd, pgoff * page_size, page_size);
+	test_shared(t, pgoff, starting_val, host_write_val, write_val);
+}
+
+GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
+{
+	test_private(t, 0, 0, 'A');
+	test_convert_to_shared(t, 0, 'A', 'B', 'C');
+	test_convert_to_private(t, 0, 'C', 'E');
+}
+
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) &
+		     KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	page_size = getpagesize();
+
+	return test_harness_run(argc, argv);
+}
-- 
2.51.0.858.gf9c4a03a3a-goog


