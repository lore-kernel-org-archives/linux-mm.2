Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370E2CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BEB6B00A3; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6781E6B00A2; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403266B00A2; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 166C36B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3B351208A8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.06.7CC7037
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E67FC16000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXZXISA7;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTIUtJwtTTuUa/yf74Ssk9yqug1o5JlDPSMs2CEc/EI=;
	b=gicynk3RVt9qJs0jQZfYrBriyTeBWL3eVC4yjBTInGp/02mG/NQxircsJVAuRiQtdOfGer
	X6NQnPVWytoGJhofvHU2pwuDVPt+1uh2qSkJD3D7mLBlm5CboCZStpXBU1PtAY+YebREQn
	flZdbcnE5ySMObPombp8tFLwRLp5buo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495486; a=rsa-sha256;
	cv=none;
	b=z8/NBlo15VHLEdqvYJSoxrqYuv7XzNerVFr95LgpRYMuJ6ua1TDu3i4akDChoan6FskPOa
	0wuq1YjQ517uvAuux65PXxfHIH7KVoO8rk3WrJWUthblk1kvBcdnSg3P+/ZLg6FQncCjLc
	82XapeKql8ylubqjKYnKJFKOxVWh6RU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXZXISA7;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59F32602C4;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92C1FC4E671;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=EC7iR2zgYWFF+UksSshkPpI72XA8X6U2L4GN336fxDE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BXZXISA7GuLO3vwWX0eZHKHa0lKMt0bccqgSotrZZJy1XzDN/2IrU3su+EMi7D1CL
	 eGpY3ntuWs+eirilrzIt1UBWflttcgxUSRbsaXKgUk9Mxx/9PSjiPO2z4B8jarILb2
	 Q/JEznLu0E8eQ0lqvmXbdJ0bKOFF2yfvrBF/cmcBIqwnr+gr5csw8+o5ek86NzePhE
	 H+XlLPh5SJ8O6P8luCktiOp5vgwW4sB+I3YYjMhKoSslShH7vPPZcnxdmpzgbwMypI
	 T/SyHNbrFiMn3Ryj8SNJpiBb5vKBfj05u5nb7Ue6HJ56/ANnL6RzFo38jE9Ib+6CHz
	 XGtaVi3PPgakA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84750CD4F3D;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:09 -0700
Subject: [PATCH v7 27/42] KVM: selftests: Test basic single-page conversion
 flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-27-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=7601;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JDc1uw5J+6quaQ+s/88lL3MHO9eIf95JOsqLWC9fUZU=;
 b=T4Tks6K4AxkVF/A+nhkSvlZdls00lGVRkcvf4S6BEQCU1YyvSlCyz2hFHNzyQ8KdOHn4+AKDc
 q3BHQqOnCkwAwW8O7RoAZcKFG/PbmWqSmaAphpBz5+ydldXnjk46vfp
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: E67FC16000A
X-Stat-Signature: hq7ko6nif6xtz47tcwg5wxim5x9iy3ps
X-Rspamd-Server: rspam06
X-HE-Tag: 1779495486-496146
X-HE-Meta: U2FsdGVkX19xq6rAkQ/8IzTHlnXA9UzB5Yy20p0AnOqhamLSawUeAE5xkqgAVhGM35cE7qqiEamrwMLfIOZdrWqyVIXwZWf5Vgdkc6oeza43IhrajlfaZPcsTh8RPNW6kY4Hdfoe1XUZW4OUbsW5vVjWo6wJnvKLvdiMSwLZIJkJJahQPUw7uZCeYrH8XUrXJzceJUa8ce6Uetj2cIzBBi1nrM4uwZ9P/Y1NoN5a07d+efDLPfbnry3wPMe3gFbj3bOwlTJkt+CqOXm5GVDmUk/VbkAYzbiNQYjAVHZU/H81C8SYPirDK1dFnf5V6UOHXTa49sp/Ep8JVw6J8rPG2dkI6SZEMXQuMLVsJoF83N6MPySMKwEEXeD1dA4G3czqliJFK8YkuKYgWBHg6cABNf0+aK5NGGpdFo36d6eAKejjUJu1yyXA2hBLhTjCutC9bq7Eu93rtSNTVQgv2OizFopF96les5SQAKXRDKD8p0dRwwXDUH9B8wEKhyFpdSFgklAy4uVCivjDnffwSY4ZhCQ9h8AuIc2rvl/wBXJjLK1DIoZyRbPVhkMmlIMQ4qsWydhV0tgpFEeZSsE/AlmghFtxb6GDNbkwjnGQu2p/o/eVeZz8iDQZEanjS75jUQogJrTFy6qN9mxK8lB5tKxHohRQ0Nz3An3nLi0yd1uwCPX6c0ddiQOemjQyIk/Lqw7pTbhjr2DOQkdTUguX04DveA+CH73YLVCRusOFsQ/NvizRN6S2t2+1/c7wKsqZpAwR9jzK/dR868g469bGtra+rRj8S5YG/Q4MoGmGl+e55EneEsSmo/TO/OZMwCX9ACpuu6bVOr1ET2dYDGSe+Iw6fDJNGNJpAsWmEt3gmh6Kk+CKtGN82YfEtLh10ttp6CLmwQ8MfSdXHaTjx3j4EpQK1ZcH9/Z6jh8RBKVUf/KeO9hcwR5qmLZiNNO9gudRxQaxDvLln+NiYfHGku5l8bU
 EoKJLdnW
 RRsweddM2vTj2spSiYydCnRIW7sSiuKYdeDP/U/+A4Opf1I2mSuxVfGQV262xSi8Dolk/613Dq6kS8bE8C/ITG0msNGrbVqi5kB0i6shDpSMM81Skc0Ron2H7gEtslrLXWiQRbf6LIsbw4rELlvZLn9BQaPnD3XnmYfkulPXaHg0RpURAsPWaeh8oMBtRUeapjdxGoQMPfwVm8RH6XmxOLhYqp6XhCS1LW5Oes3SC48o094e9aT8cMEr8s8zwJ/XLg2j9kipRl/dClS0uSwq6EJjZghQInFuu/R/8bHggJEKW8U4LFaGdDeuLVzfiiyPFkQJbZecS6h4EL8ClZgYAuh6397mOK3WwVb6CJlubeA8YQ0CU3PP9yy077JTjeoln7V66BSKTYrNtlXVFHeNmZjgTBeeTq6m/OGBJ
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
2.54.0.794.g4f17f83d09-goog



