Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2540810AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F326B00C3; Thu, 26 Mar 2026 18:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0056B00C5; Thu, 26 Mar 2026 18:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91186B00C6; Thu, 26 Mar 2026 18:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8427C6B00C3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46335C461A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:19 +0000 (UTC)
X-FDA: 84589646358.19.FF975A5
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4626B4000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S9M80rLY;
	spf=pass (imf04.hostedemail.com: domain of 3S7LFaQsKCBw24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3S7LFaQsKCBw24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/xEg8U0k16qmBs22Yin6V5IasSwJGzfsYduOVmW5QE=;
	b=zyXHXE8FxAVCZ5eVit+8Kea7SqNdEwSEDhOt14iKzVXupMjHXp/kjf6zCuSn7YFxYSdID9
	Kaq12we2Vr1/nRIorzCloU8NbAgkRq3plAI/YNrHZSpuvE+1pUDqcdLMQgfmoaKmazN8ty
	LT0WM+X06JEcPqnT4Y96c5l727Od4Ek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563917; a=rsa-sha256;
	cv=none;
	b=UxP6/Snt09odh6H8bItTy6nvyYIDEyd3QBjoe8DiydLUqAC1A1lfVwWtK2BZtqf9wL2Xcc
	jFKdMVKCPH8Jc9VxDYTuFFnzKnk0R482VNrhYLstP0nG1E0SyPWNuhWr5RZQHtPF3nWovA
	TgWVXh4dWXjVEO0oeKvA7nMLFgBUPAA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S9M80rLY;
	spf=pass (imf04.hostedemail.com: domain of 3S7LFaQsKCBw24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3S7LFaQsKCBw24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b06c242a34so44860375ad.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563916; x=1775168716; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K/xEg8U0k16qmBs22Yin6V5IasSwJGzfsYduOVmW5QE=;
        b=S9M80rLY844BKwzPWR1CmrzjGacQCPI26XoOsehKvejqz1sWdYC2mpVymvQ2OLPUSH
         Chu1+0B0UcIr9AhFyAlCEf/XadEBXBBeglNQiKcnVoAjoX+wbSWot2zfDytw+7rxqPJn
         mzp393wgUKHoo8oyZr7eq0qBT5MxHr7noEwAYIBaosTbsF1zPUTre6Bapuwc185j5jxi
         yBNhV3MCPpeQtvrX+xLh1F0g5tWzaAdvGlX6DWZZE0KU+VtZKtMkAB6kKfQRDpAWpA8g
         aXSQvGrgnbh0hYAz56l0/FSQdeU8tdxdtFj1n915AKlKgbY14aLbAGKop3QRT8TJ9izI
         W8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563916; x=1775168716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/xEg8U0k16qmBs22Yin6V5IasSwJGzfsYduOVmW5QE=;
        b=PrMGQppiCotQKzs9lyX4QabhbKFwV+YZzfSsjbmluxHq2Oo+vC0/A9kWKqXgRUh3mn
         +r0RccgSVH0eMQMSEl9UbseZVecq/nyxyjC5f8RK2YVBR01MCQjhvFGcSaVemzGYHuGK
         2N+U6fFBncQysw0YSVmjaa01n6fLIjhgfBPi2JR0ZoFBGEEEeJPyQi3mCl8uiHiFh+Fi
         Bg1NMetMXgiXmwmoWDuRNR8r3UvB/NEkwCnsfvFQTE1UiMqJJEgn/G4cSI73jC8D/5h6
         BvariyuvjkigElym9Wl9Ylkt2XE0pF4gf6vRWPge/EWHScEcq1yed+RpSZinLmAuoaLF
         TqmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8RGu1Mv6sN9kOWLc+CVPWPvWi751yG3sN3KbY8y9Et4oWKgqmvtYNGdWlqoyEpn7tvmSFY9IdWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4e1uASfOAhIJHbcfELxHt1rAn8M/VkMd6Rs8f/0C/gTifmQIv
	5U79SdwxQHpzzzHn+xggv0AyGS+tYV8p3SmKyydnse+Sqm4pfPk3iUUgNnrBGjYLO0SP0WIQBwq
	jnjPlLHQLKvzZ/VrMan6I/Y4Ovg==
X-Received: from plbw4.prod.google.com ([2002:a17:902:d3c4:b0:2b0:6147:a0ee])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce8d:b0:2b0:4fd1:ed5d with SMTP id d9443c01a7336-2b0cdc04394mr3089425ad.8.1774563915706;
 Thu, 26 Mar 2026 15:25:15 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:34 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=7748;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AxVKgPSCm2I7h8Lx0QIPdypNEPHgsQvWmCjIPR9V/GY=; b=RIi45adW++Tghf19GJO9/Kc2z9rBRs5GXnlv3MugDCYn5rDU3Qh1nIWxtW/nBK1Tj0b7PewD/
 Gzl8YIGFLTvDROog9G2zJe9/IotvK8YhPpMYAEbP5qZtfHbDG2bnNWL
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-25-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 25/44] KVM: selftests: Test basic single-page
 conversion flow
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 5tctbfbupawqa7u7ogujmynhzthtpg67
X-Rspamd-Queue-Id: 4626B4000E
X-Rspam-User: 
X-HE-Tag: 1774563917-852237
X-HE-Meta: U2FsdGVkX19JLE6VUIXflEV+MavV2HHk5S7KQvoaqRw6fAawXGHxoyoBinMtHNvlp8d0Hw5M1x/QNvsL6ax5Qq/kC0oFp5vaCB3xbLb6aTXXhEpkbrrwxsrc0prgCJpO0XOWiNgkNZGuDjkjiYFEXOa+51FEK0XXLAahwIwGf84Dl6v8LveG1708XpWnnxFIVGa8pQd9G5fqbQmmci4dNz8HtSDYFaY/8ftk+3SFNf0YsFUu6DTCziGx/QN8wYFPSBC4fPPm/y3nLfJc4YpA2gBMFEx+BpmwZAdbsrmVMJWNbZOdRHFSu60w7ibOyMjl0t/fJYdikdchSYpIHbs5VJmnaLiPv9yIgVqKZyEPXmrRzcMLDu48tblgaHHC3D3jVcKvBZWUGKRgLUh2hEJ17gyKRBLByHwhpoBNLA7Mq6ABIxDOX+SiFYZnlsOmmyPnhlcWUrjfEtUXdNOsN5DVAkMbcUkSpTZ+aH1WW6u5deMSf3uAvnZHLITsV08HvrqOXVVy54KZpPLnZts3XScvCK4vjXGPv9RKH78jDENjvMvUdCjbiV5Rh671EtVJx/C0IQo9PTeDMIuH1ZPqhMQ8TXJJxK5ABwY56EX3zNtw0VcNkFVHkk9qvBfe1/s0wrrmo0son09+pfZHiTsV0lK2MYntSGYSTFvLE5LUmryo/DOwES+5jVmwEk2Luk3nRjXaj0VZo2O1SS8sh6Frke9D7rpMlXUQ/ok2IyMkcsZfkiFf70L+vMg/IzdGOWoEMQuf8p89DiVxrbyKYMF3xbqygeuzoM2aszehDITtrvQvDg2K0rO01JQeJYgF287q8D0UXINOcz1VkyiBicCR04GVjho/LMIDp+4/AlYdG5iCM0RN4mrehdTa5OHV0zR+UtfD1WHyCk8fm8A+n9y9NLdsCWQpKGiDq3fs1xFarDrsEffX7SuXJg/Qk38XH1gILrX6ozdVJSjQukzZxXeeg2+
 K4Z9jzO9
 yPxxlahp/SXfoNwWiY4sVS86HYjAQd/9yUvA8PQkMke9vYrZodZy2zVnPeGhHWGdv2Teh3pfIhyywtgcmHGszEC64GRP4OQURXJtWIK/oB6bCCADe8F+BqzD0tuAP+DL3vyC9UWtYIoIVeA6LfoWAp19LzRZRz9gOp9MMG56LD51kAOYEHFL+m2/qIT4OhqNylfgVEqy4AWaQ9J6gsI5kFQpMzJCu70HiB3b2koAF1uNviFd7BmqySawRMc4gO78IF7AGBpt5paJECEEOyiOEB4mB/EzbiQFEl7tXcdjyYTWlpp+ktreffmbnVIHFK/yTkN6kgQYKPvZPdSwf2xE7bUXfxcHBMLtz3cM262L/NP/xVcK4Aia8OaSIm6hyjgdcR2ZaE6zqhnkSyKEy51ivrmHliaa090f4VD1C3i0HSISVbTXyiB07lsQRWSXo7BNyte3BaiCcWOXjYDAdlMcbNM8AmP0wmV1ZSEPRKmX5ZDEojkZrQH7m3FcM2At9NCdrtIuGwAGLQZykL3NiNehiHWC5OHZ8NuiWt73m2tNY17n8vUYmIGliLsWM1eEnKGDu4bqjigKMSfQFasC+HlBBS9qZqBEY82WdqBM8l0DKBbfiRHRalqnT/Fpp80Ptaj6ZftpFS8RQqC6TrdFXnYK1DiPXbQTIxrnrr7HgggFcklPY7yk=
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
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/guest_memfd_conversions_test.c   | 205 +++++++++++++++++++++
 2 files changed, 206 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index dc68371f76a33..0e2a9adfca57e 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -147,6 +147,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_memfd_conversions_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86 += memslot_perf_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
new file mode 100644
index 0000000000000..841b2824ae996
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -0,0 +1,205 @@
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
+	u64 supported_flags;
+	struct kvm_vm *vm;
+
+	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
+
+	supported_flags = vm_check_cap(vm, KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS);
+	TEST_REQUIRE(supported_flags & KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
+	gmem_set_private(t->gmem_fd, pgoff * page_size, page_size,
+			 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
+	gmem_set_shared(t->gmem_fd, pgoff * page_size, page_size,
+			KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
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
2.53.0.1018.g2bb0e51243-goog


