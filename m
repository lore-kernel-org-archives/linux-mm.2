Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75501C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621326B00AA; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9526B00B4; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF3C6B00AA; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE19A6B00AF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B3C41601DC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:53 +0000 (UTC)
X-FDA: 85075823826.28.88F0359
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37B0140009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bMRuzehk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9oZwo6Twl3aHE6hgk8BzK9770NkRW9eaYIKok2W4lM=;
	b=RRspvj+DcYRQRkO77LbD9/Ib+vnCocw1k3eRas+2Ki83PLa6G+OeFkIXLy1BqfaPCt782I
	RsO5CE19Lpb+F4Bn+rvzsun91Kw5AMhmZI/GHMIir0j/+iX+8LELyUkPgba8WE4Sv9+2kV
	L+YYWeywew4KrLG/auEAjTp9QX9ObFA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bMRuzehk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139571;
	b=vxJM//chm1tZQ0oeOMnOBW6Us94Id9yis0MqbDx60mpGvbQ5m/rhumhTi9gTnfbFAQcnKQ
	T48vceXSj4GpfwVL9fHD8ESTdlpsS+btrkUQSK5kjEga5F2ToZTZMff6aXuiNv7NSOJbpC
	/A7UrFfXzKgS88dEjIgAKc+/FEjz1eU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6B4660254;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71FD3C2BCC7;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=rJhUYCuZkomqLg/f3nm1Ab0nssnx4ZZWmryG5s8NUPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bMRuzehkqPUCCDnyO7M7FESAfG1s5L0To9jFnaN+EifP6TnTyw5k4MmcMl01VP02N
	 KHuAStyn2YGXR8Yg9G+q1FkP98rqzGGhtl0An+sOsyMJHCCJOQUlnCcLhA2KLsFlFI
	 wMfhlLulfYdiohLG0Gol6wPnZ/ZViXd726X178rcOAJubv0uGBJZyDWjb1nRaXEHbK
	 xjs4rPZ+Eagi3DWO5UBgGqps2QRLSC7pBW3v1q+W/x7wCqFT1g/sVwY4B1Ku0ip/y1
	 q6qpd+aAKuIetFMXUsyd5FqH+qdVJw5VxjeoEKu7jHNFuzQG0ckiieYd7kchqfQE6X
	 /mIcay0rY+c/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC98C5ACD4;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:06 -0700
Subject: [PATCH v10 27/41] KVM: selftests: Test basic single-page
 conversion flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-27-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=7821;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/ioEF4WAcrdUq/WVZjNnIPnEDGY6AwstSZrVFbO6vLk=;
 b=M1nY/sD/bB5GfnRwV2WI6PXt8Abaqa6MH4yAUZgEW6aRSY4lPirunpO94zq6lzDGngmyZbAEm
 bMYZ6LJQc9VBtJkjkjcGwFuKKt1aYdJBkAPfEr5jFXMwCA/CE3BbGe/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37B0140009
X-Stat-Signature: 8tzdqyogobisanugzrx3uy5ouoqghtz4
X-Rspam-User: 
X-HE-Tag: 1786139571-547548
X-HE-Meta: U2FsdGVkX1+4NEFrD/GvzXUJW9nxmIN7Mg7ACMUosxnkpCOKPu98Nd0NDx6NaCVxpjIy8feao41v7M8r54MZPVPNHftjrydVttcpcsjY2AvPhV+fCwvVVW44XYSDjgqBDalMuzPQ/ZJPVlw6CcFIkg/OFJMiUTOxRrbR1vw4suMJF7V994Or6mHDW0WJ2YS3ea1yysSEmXOvvvpu6iT/j+sMPc+DHIx+auNmu25TUbd+ZzmPhKMNrcaqflfLkQVo1P68ePaAO2tMIaSznyQiGTKDn6hTJtNy1+wQpUff0IDSWUwynlzgAcGmSbFafGgmgZ6tahobmsS+yWRBQKQtZ5vvzPmLNeXreTaD7EvSMr3ysqOEnjrGmjykZOyCsBRmzF4Qw9mNbArOJitofaj9TJ2t4Ow2cAle73vhuJmnxRriaGnDjxw9Mzgl2iz6k+quNyBkLt+hZ5XOM2uKue1FV8TwUz4CPTGzv4M12tn7XOfLxAAF/QUAT1uZJzwobp097/hacSV7SvR+QIoKKlBbNP/9nMMztTCe8Zx0LGlufFu24rZUER9hmyvfuuhgf906B5HYY2MwHJlqg8lZ3GPxFamUI2mSJZKfD88U9OXZpIJ1R14Xi02kXW4D5CnHSxWpK23bT0dkdruHmS4p8fYBGqN6gguq3zMqSJBkswhnnbRYDbbhCYm/Gyki3AZQMFwEI1ZMtrskjcx2RGWGg9oXDqTerSDuoJGjQHyixJ6SFu4BVkI4bweuRghjc6i0XGkkVJIKJFhrkVqSKDkixziOSKDOrDw70UnERbxsqHBhebi575ca6UYVwFWvNw/0uXJ6F+AqVvoaVv/Ek00DfLXe3Kl9ZB2wtt+cwICZA4I9VzgiP6rWjJodbqRyqzT4pKToaWnLfq4i6mXG5fqYNYXOFX+zwnOq94jSu4NQySfy6FVoJp6KMNeY6rj0zEPPliNx4blAh7ZEWBOcJ0+Du+7
 lkre3ybF
 qRLpZoz1HfFuUI3prYjHEUuC9PLkw0P3/AnIMSdKNWbBBXXGvdz8t6BgBoP/Nrqk/ELwEJNSYtDte3Cd6U0hZQurfeqGwUmMVanFmIZ/Hy1Qngpj8HRwlEo2WPXXShgSJydBd8oBfSIVcN+Y+58ouhA84Sjff6X4hjl6PSlnMvtvQiwcHNMFC3TrBRAGj5eCRZ33sbQI+ubFPkfzsco8w6QaVI0GR9A/U2NVi6ufrwDNF4f397khPmA4pTzeSk808RfsvDsuxh5YUBEdE7rUnGV4Im3VepH6c7xInUJjsOjVpUdZRuUq0tnHcvzeZZFNzoN5sTC5wRkowLkC1Wav0I/id+kiJm9wEHUgGMWMmvx8nCotjkFV+W+FTCmptVOc83yZPLXBpNj09YyeO6gA49glXgAntXv5lDXKEhTwiqTOF6i8ziXrwR1FiAIxa1YPCLiaw2keS6g8C/vIUK5dY13/LF4qVZpzPLAYyc/Hy735DxxvbIW7IW6CaQUwdrHG77XYywEO4hbySBs8=
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
v10: Updated __GMEM_CONVERSION_TEST macro to avoid potential macro argument
     reuse
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../kvm/x86/guest_memfd_conversions_test.c         | 200 +++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 00123169a190a..049306cf0bb7a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -155,6 +155,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
new file mode 100644
index 0000000000000..77f95d49349ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -0,0 +1,200 @@
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
+	const int nr = (__nr_pages);						\
+										\
+	gmem_conversions_do_setup(self, nr, flags);				\
+	__gmem_conversions_##test(self, nr);					\
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
2.55.0.654.g21b8a5bc05-goog



