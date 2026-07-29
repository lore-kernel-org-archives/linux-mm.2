Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BBAC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E966B00A2; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561DF6B00A5; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317EA6B00A4; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8A106B00A3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 654F2A056B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
X-FDA: 85039944948.29.707FBB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80DF5100002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hK8v7ynD;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urBaRgh1pesK83hC4Dngk8qu56h3o71NjSa5g270Ig8=;
	b=CffULwmIeevWYL7VlGJGyEz0X0vXciv44RLy3d8GoO4jv4I4eOh6iiSBuFG1ghjnpO8krJ
	ffDlF2O3jCUplpYIa8PEy9IYTaSBnubNd7ZJ/EChxnAOctleXO/IKShypBofeM9wz5iJMC
	ACHTQf+OjGVeL5eRtnPUxbID+RffrSU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hK8v7ynD;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285312;
	b=58NXW24q+TSh6Q0Tr2Aft6zZPD+ruMFw3MGZV8cXVpdowMS1GI0b/SjK8YMrKKszjITaDo
	vuSFCH7bfx6VADg4/8aQuObi4e1cm5NuYSr5ou8D/AmZ1I0NbglhFfjWK7UUQPNlqGdXsg
	vF8OHyaC+GfNyTF+J1L1scygn1mkMSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABE4B60DEB;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08519C4AF48;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=kTUy+7mGOQ0+HwF8ZKoStLP2md/ZeTFtPYGmzB1KzHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hK8v7ynDCiASeX2PbUUvABhAX/QmE9+uJmq4I6ry6EaT5wO58Kg+8zcCDPNy1kHwD
	 85LQ7mxGGGUFJqR1deRyCy45aIJMyK+H0AsJNaG7qo1vwUlrP8FicYprADZTr649qY
	 lQDDKiQEEKlLPm/fyI3wcH9PCvSO5cDaCZRwu7sjtF0QVq2D+cDff7gpGwV3zH7DPx
	 sEiu7JBHbWhMSYR61Wtj4Kv11oQjZNYToFQeHXjzHBGN4YBJnm0/H1hvKwSbvNMjtW
	 7fIFP/SHiSUqP8x5jFegQu2/L3lM0jiPCUup2vZJfiyBHOSyHb342xs2qWWMjkDKGq
	 HTeyO+p1gXI9Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A93C53219;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:26 -0700
Subject: [PATCH v9 27/41] KVM: selftests: Test basic single-page conversion
 flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-27-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=7689;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eVdD8dCULg5STQ2BafgYG7reedAagyOzOimHD9KGdaQ=;
 b=BgNxelj8YCDzVFK5eLNJ0DvCMfnfhaegdC8F5qC6KNrO8LQMmHhdfDJfXupl5UuIqSz/F7gVx
 TWgGbogF5wiAt0f5AqKiNL0eir0icBQKPL+yqvbH0aEvw5oSaujTcdo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80DF5100002
X-Stat-Signature: pddch5rrsk7xhf8x869rj7h5sktt5uc4
X-HE-Tag: 1785285312-527863
X-HE-Meta: U2FsdGVkX18AUKY8uQ794vcqr5I5+VKqkyuKuw0FK/3C+wRcq8RCn2a9IAqhB/PX9mXLf7c2QPa27kaT0u0KHZ5cVhUCNzFHnv8UmwvyhhnCsFRMG6N397ble2KcILX2UvZGNdBOmBu7xzWmuxwM4uaOc43HQP/SEkc3FkFtSP/y5vRhwo9Z0hImSVftv+yywD3UbBn6JMSQ70B07E6TteezrPVbgZgHumDjMIz0ydDurr1cLbK7FSdsc172X34qI504k7b7c9n1i7OX77Pg8kFGgtvT+INd1e8FAtgtG+KJDz1pA8htZn5BPY4ltG/KTKYGlNlzGuMTW5d90ftfhoGxO9TzSkb597OFUStCZA9/f41CwA5uoEqJrt3eEWhhunsIQ+EO6iOARZt2MiUOKCqOTPUZSYHHVR1y7H+AeXJHLzzzD5WVpDPKRiDSaLi/q6lawByXHjEr8OSN6OOmD/3dtvw1BVWMBxUZKzu6rNlnEp+5qlPUsFOD2zJRP1lMSUYIjvKfSrAHsGZANaTiRbXc8Jq1atd1qkRb++vGlkeekq6Z0TX15OruBP29IIBGkJ+mEOsYH35NzjcziCfSnh89sRFJZcUXDHb6ZazQ7hDpjmPdwYceP3U/U3uKPmROLF0e+j/PywYUq5r8/S6GZw/SIGVWujvBm1Yp8R2hBSdc6JB3ZREPbvNjSUmbNt8PgHXGo2+TVttoCGOtf04f56igVNTfAjzMSG9tUoRRtZavuREdi1RzPfoAU4mPsfy2N2lZJZbaN8NIWxbJ8bsT0CGvr3dvxSqvtc0c2ua3YXb/081ML+od7/reHr9oh7kkcg3U+Ur2UqMPtLaPlAWQByN0Mb2PyCk2DHY79d6mMs8i+MgmNWm8EOOQ+zn+yJKWyelqfpd+tOcsRs6CaSd5bO/4tW1FqQJ/4aGl3d9/HPAGW3UynlRaxpL1JekChk8mRVkqptmLGYH8RLSw8st
 66b5Edft
 Fobu+muAsELMVOQ7WxXzxpU52hqtrbt7kKEsMcAyEHT/1prBWzipx/B19sfgnMM4XR/t6K3fgzpXfpnaDAig4Yvf3Vlyb9cvklQ7YhQMXFMjAfeJkLqpcyJW1g4GWIvuM/68NaWAe4ah+9bvjO1JBowg4PuukKtVcwJQQ1S11ANxCnj5rP5UVonA7lLoeupp89v9bYpVFHIsLd/e4ogNqY83yb6smc1FPVbwGSjSWJxZJIxsyJyqTEvXmjslO9o+Z9G/Qr/twoNAvbPuH0AhEtFGCsQ7CDoLZnp1S54MwwSRSqtgAEsTdFyLURZwsCDGxxJK0MBnlsvS91EepJUTID+oCItNIHpiG5mMBGdAKVbbQP5L8RY1Q7xnnWDdrPVqN+zGUQmGk5egho5ufElYjXzE9/4B0eqK4fJQuRF5d9sUkCcutw6rZOkEZUqPLmuxHtGPm3ZuXOLWth0mrvpEIDVkL0OpusZ7UVaMItO7XeewC5H9H/2TWuQmDYtt4DbJ8/Eu4+e175xp1g2g=
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../kvm/x86/guest_memfd_conversions_test.c         | 199 +++++++++++++++++++++
 2 files changed, 200 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 88c6c8046ddec..daecab00fc984 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -153,6 +153,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
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
2.55.0.508.g3f0d502094-goog



