Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FABCD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BE86B00B0; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5043E6B00B1; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9A46B00B4; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 109676B00B0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35CAB12062E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:04 +0000 (UTC)
X-FDA: 84741747888.10.35CCF54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 005872000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6J+jJiS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185382;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UJFfEEodgIXKX6TNhNy12OUu1o+6AImNFxVAYEBPwQ=;
	b=HF2kBqVm87lJv7K9jD8wq3q/52ALeOT2ZDNJh2kc2fRZtLG4B619rVyikuVXASDWTg2CCQ
	aKSRYLsXsXQdCkGt3lyhS3bK8kpS9MrEo4FlYtMlIxqy5OVAev6ie8aZ1OQBcgMj3C6L8D
	kr6A/51qlmp3iXZCsa+T8erFL3dnJVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185382; a=rsa-sha256;
	cv=none;
	b=SD6YA1pbrOmuRdW0g7/lf3MokkDRn/eVPfz0wL9dWx7wf/Kmx7zkk+Tb3aAvX+j9WeBXF3
	sLRSQvUGn8aXDLYOyBQUUZIfHfwVkUV3BOCJdMoLoKYCW0n+s7oDMu9TlgpWGDUiJ6U6nn
	Ea+awlMZFxSu8At+LrUGQCT2xTtVAO0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6J+jJiS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 327BB446AF;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFF39C2BCFA;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=YKuWgBeeVi2pIcxPgCgZp2+TXXc6mc6q7pKUxip5Ak0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U6J+jJiSMXcdOLS2x7c7w1fuz/83Ewo5izVGxDIFI5wwux0nnrwCgpizOserHEn3e
	 bbaLUsGhry10SKuKbPqZwllUziVFCLlBIYlIGXmWea9525JR0ILnLBacaxX8EULjAM
	 ocjPOUkpSiFITjcya0YBzBmgz7O0SJsri2FJdZw0dtpwgMoEZkryKq6o67JBzp18to
	 o6Hz+JeTXI0Lt9BmC5cCnYffGbHcKyl8wpZ4M6wB58/qtfpbvZ6jyTxdEkBUKw85Il
	 lZNIoYHGExgtq8mq7Dy2dreusVlighyNY8Ubo7nOYIgZWAG4Gos4VZ+GRyUYprpset
	 m4wUtpht+RYgQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D985FCD37AB;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:47 -0700
Subject: [PATCH v6 28/43] KVM: selftests: Test basic single-page conversion
 flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-28-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=7619;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HU+HZqRBAP1fuYbXIFrCGYEUfjwMktHVeGX+0sEQ59Q=;
 b=ReIfRHBsc3fJCFJyPAutuyrU0wsW0iD1htjlx3XJaLPjklZDH4j1dfRYuD9q8i6cVwEW3aXor
 NIHMZVjCnoFA/xxQUB/D2WlGn3YsOm25/JEtSpKTvRP0qtjG/UvflLj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 005872000F
X-Stat-Signature: 37h5qfuh39cnndytor5aa3958ptemjrd
X-Rspam-User: 
X-HE-Tag: 1778185381-911523
X-HE-Meta: U2FsdGVkX1+pwxyR//TOZdrpBq65z0WmS5NSiiF9hcFoN3gkycnFcTPwVE3Ff8gca4icadnmDQ6lNsEhe4cHNoIxyNJ892YahlnrY3yUU/jEvyr/BFxeskmxtfSlpEsc517Rd82XSy0V+Kv/SBEpdtZaPLv3fqMYUZtaC9FbKgGqYfWA/zywi44pgV1BebvRcUEwblM6lNtrkvgVDvSlpuWyJ9pIVqlYeUIhk4PaJqlsFgfBxt9Fk0snvi3xH1Yl1hYXt/PUkroYhy+AMxUAtnwrkillZBo4pTQtbv+ObMi7kSfWVi5Phr+/yUxV/KV0kFmXM9K8e66iyABJpc5PHZl2qFz6+fD5Mca6Bw5owrWmrV82+TETQoe+HJCv8Ibph8e38PLFgO7oFdC5j7koen0JlMBRjJGG+YyVyE2I6cL9yEMFtQPF9BS11fyWNOGVZilmICp3Bu2Y0gGP1No8zU+s4y8yN++3GFQVU/LFF2/QkBvv34jChpsiYMtTUq4evOFXWE+ThZaP5b2WPvHk3/fiUaUraBq6Urm3XB06GZ3ZQN93TOn+zuO12FLALvWxrbbdI9F2D2+uXFsXCWcIVmIM25B35cjOLvEznyroPiKkXjqeXUCfGvgQVyWkYmhwoieT73V/gBxZmdxoYsLa+ijeiPS1mIRdznzvoQkMjUHpuCT8QnPdhjbJOMrFlA90hkj+Z1o8BDMEVtcWikNvZBPl/S80ur5mFQXvEV7LL+iyfDSIKDUGzHTxrCgT8+Vu64aosphS6RVI3sn24sec3sg5bjbWbETbZMar46pKrU27zplLniTvHFRSjyKVVvnsKhcgfzaXs2TTa3WZKr+VHBsTX8uy4zCbZja+iN5eXJYEf0N2+Wg0vZqj8CgxIP36VZQ5qPqICsNmLuGyqBPUVqYVATwMcV7jJvqzs2/0Zoqm2KDn2/Ja6Q8p8I6T8aks5cJ93XXYTwvUaLJKPSm
 SBt//iby
 /U6IdWvvI/aYOiNTDBXyMsmmKeewLcCVHeO7R2JJqmPE7/LuLvQOPV2p1UgTK43GjxRK6vea54/H7oSLi4dETDuLe5IQ8dnL3G04Osy7vBE1urbtgysLxQp+xQm2dkZkFy6QRx5ylgnYKS4mLuspEqxRqXrM3v+fBbGxbOyMHSRyvsSPhDRpSUZkDGovPe+j7fx9LnLVTnr9BSY3L4vlcNj2NMaWp7d7YtQ6A5Nend2UMPt/wyeT7HBRhkaqYG+rxBPaFS7g/yiGUxqkiIvsKYme41j8vYVqdNUQPiQP/hftDyRyNjoMiLTqtmiODEHbAO8vmKiZdXQGUqh4UnuP0WPr6JAUBbHSp5dyrlZFffb3CJwrPECyXAvq/8cbJZJnPTeAovqm4NWRoFmf/2u3g7913+iMWvXE4zSxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a selftest for the guest_memfd memory attribute conversion ioctls.
The test starts the guest_memfd as all-private (the default state), and
verifies the basic flow of converting a single page to shared and then back
to private.

Add infrastructure that supports extensions to other conversion flow
tests. This infrastructure will be used in upcoming patches for other
conversion tests.

Add test as an x86-specific test since guest_memfd's testing
vehicle (KVM_X86_SW_PROTECTED_VM) is x86-specific.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../kvm/x86/guest_memfd_conversions_test.c         | 199 +++++++++++++++++++++
 2 files changed, 200 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89f..6232881be500a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -148,6 +148,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
new file mode 100644
index 0000000000000..81cf13e399c83
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -0,0 +1,199 @@
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
+static size_t page_size;
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
+	const gpa_t gpa = SZ_4G;
+	const u32 slot = 1;
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
+	do {
+		r = __vcpu_run(vcpu);
+	} while (r == -1 && errno == EINTR);
+
+	TEST_ASSERT_EQ(r, 0);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	case UCALL_SYNC:
+		break;
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
2.54.0.563.g4f69b47b94-goog



