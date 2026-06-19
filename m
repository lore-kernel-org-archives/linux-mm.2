Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63854CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B878F6B008C; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC38F6B00B8; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8186B00B9; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF836B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3AF61202DC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:03 +0000 (UTC)
X-FDA: 84894784926.19.29E6C31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A00D918000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQs7cvL7;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829121;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G788mdy466kwUp+XSmu6gq0K2MvP5U3ETQYIUhNx+NQ=;
	b=H5pk8ijEh5nmJeEtXrAw2rsINfBFkKt4BHebf3LIINPMsR08i23KmCxfBCkFCJwDMVZeVV
	2mLL6PVaxBOCsZ5iNIj59NKyZWt54cH2SiBUnkFAbkjEtCZUNqavTbsdtBff+CksBQji6Q
	mwd5Z9t+qZWe1/pNJmple2ijNl9tqB0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQs7cvL7;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829121;
	b=ZZL/EvE3PLbkfV2oqm3hpa1+uc6t2ORcchn1zmoavZ9cR2W5QjTrIQZ9SxCnl42QT/LZl5
	6nmCwh4wIFk9ad3jk0wATE2bThodNV6WAGJLHKrvYBUx1gag9DJSH8QgzleESxMa0E6MYK
	qyihmv6fWCT+YDcvf+1r6QIAp8YnxB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 419F94460A;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19F6AC2BCC6;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=t2YBdaCl1TWZMF+/P7qxbmgJ93C6a0OlIfwj03UWIac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EQs7cvL7dprDrfNJ+HCoECrGestXFORzRIEHULuoSMGpLbq8BpYjxF1oMBWahGjO1
	 6j9ZROLJzQpIXaRONXXEellnJTHvuHniJ3nRMtAVkdVs7kwGQ6bZrivkD0hTtcvpVt
	 PNY6ZrobwitLk3K4j3JKih1y6kwQqcpjcbo+5h6WRuvs6fPj3SnjJhUfcDK/4F+x7N
	 WT2OU2geqasB3WjNAIcV/GXUWYx31oNjPxlNGn4GB8mGoCm46ADpy6TO05REPUYS76
	 SwSquW1fhx0bEliEQdwfJcwQRLf63Ip5CRO7hGG0r+dSyRcg9sIW26C29uFr1UgIwV
	 6lMZ0t+AqL00A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F360CD98FA;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:08 -0700
Subject: [PATCH v8 31/46] KVM: selftests: Test basic single-page conversion
 flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-31-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=7605;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Aaj1r6p415lOJrG7HItUYqgdFdjkfZkBEnE55A0fzjI=;
 b=PYoyn07IsHIuU0Ra3/aaOHiQoaPtZMT2FQKrvnk9TYEo/6pmhyWOfhUmkb95VHG4uWyh1B2wp
 WLQQYjIvIRzDDqcYeWw3u2J7nJnOzPZCBiWTWF7qCMhmp9DRhkPj4+D
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A00D918000A
X-Rspam-User: 
X-Stat-Signature: 4qqhswn63t5sq8r8w5y5ie67746cpwxd
X-HE-Tag: 1781829121-376689
X-HE-Meta: U2FsdGVkX19d6ok70D/D53v2BqsX44kBtH9mzUTL6rvPxK59p+x10Opg0tVkIbtoKICysz2L+X2QULD+J+rYuc/kbuV1QZQyLkQUaUq5+v3F9L2JKxIzjgwX4/hRGYn7PQ3OAMuKYTzS0vSt1dzXZg994axNF8nXmqsd1z1VW3pmM0A1DXZRgWMXTxAamGTWFFba7t7M9avVzZY+cXDMQ2PT/Hey4+i6WeE3hlopw4IuuvYTLe5QILVqNV9BjsfLl3S5QDsdK36KkxcmLcx2ndOgFdhDUwF63bwwQu3BIk3vu+GQ4E5V7hsBUWMMFbA+Hfx3iTFk2ySIqgIkagHaKcBfceq3XsM022OIf5sZufbkyeSy+tLDg3DNMCgq6aIjTXkv1WoYv2i8qqOFCcC/zBruLU2tIMpaU2cAHQ0Ijfhahsrj7FqJy3zXZFqSsAHcsHwCv8kVn22bQUCCwmr5KbuwbWurNyBDkdVNeRKbPiiH0BwJvBCM97ZlaedmgoALDASVXCOUtlsWVFyi4/a/YsEwVl5qGnERrNUSYXAuBACdu45hJGDUh3A7MtDtaN6mqBONO3FtgLSHhc0C6zM9VjWfArhxHC8ktwWptejiKTLqEViLHUXvLFSCQLqNanuey9sOij3QdWoIQCzBk2OY+4tsYTxJOiCgK4y+qQdyiwhL5IxYK4BT2zotHU9/MBHiMKUM6r6cjwPz9Otl9hgGUM5QRmGxQ54PHA0PSIT1TIooF7CLIh34zUYpZfPuD/QA9VKKihWdjv4xWIGCC43zuGutGaw5piujJ9/LoRTiKMvCi4ErA4CPr3n6+Ask2kuC+7R4r6WBo09y+pdlUv7weUIRT3EguBb+o0ofrWcIV14Fg3G1fBQc7h4NqiUlOntgLnC3KedjpInBz1MdqtolOhVLtgSRg06GV6bwkAc1v4rEDUkbIvgcoPhJpKn1xSYSZgbm9v/41t+bFLgq974
 axzYuNIN
 3DVDHkfchyLHsrSk3+ovUti57LjxMoFtYz++K7dXrBkDU3uCibFQi0yM4oBjbfQaVRaT0oWkAv8BS4sKinYe5pNTSSzBQJCE6YFAmzzlxDjVttfEpT4k0q6p8zhRnKrsRMKlDEq3YPNxB+EiapAV5eC+h0rYTS9QWF4PtIDYUe88uCPvqGWfP1PisOkk3ClaHzRxduFpRxQSHGMiyxadNw0eS0jm+XBtdhMnUS/vR7pyKAUz1HiBzvFzEhVTT9nMGPPAfGjNhryToumaqjPpAcdkJTQn10qF1bD3EmBLmn0jew02g+CbeuF5l164+hVlDY5zjhbGAD/txTeW0AEXdhLsWjsT16CAQOsdr6KxhT2lIn0nPXarfvm6uTPBgdceElaVbqcUPZ817oDeB1wTUMjcateyjRs9Q+y3MaqAPlCvmZZvf39FOskdcbi+vQHpAwEaI1pATAK6S2kA=
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
index 4ace12606e937..b0e64a6dde21a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -152,6 +152,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
new file mode 100644
index 0000000000000..8e09e241723e5
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
+static void run_guest_do_rmw(struct kvm_vcpu *vcpu, u64 pgoff,
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
+static void host_do_rmw(char *mem, u64 pgoff, char expected_val,
+			char write_val)
+{
+	TEST_ASSERT_EQ(READ_ONCE(mem[pgoff * page_size]), expected_val);
+	WRITE_ONCE(mem[pgoff * page_size], write_val);
+}
+
+static void test_private(test_data_t *t, u64 pgoff, char starting_val,
+			 char write_val)
+{
+	TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
+	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
+	TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
+}
+
+static void test_convert_to_private(test_data_t *t, u64 pgoff,
+				    char starting_val, char write_val)
+{
+	gmem_set_private(t->gmem_fd, pgoff * page_size, page_size);
+	test_private(t, pgoff, starting_val, write_val);
+}
+
+static void test_shared(test_data_t *t, u64 pgoff, char starting_val,
+			char host_write_val, char write_val)
+{
+	host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
+	TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
+}
+
+static void test_convert_to_shared(test_data_t *t, u64 pgoff,
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



