Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8A5C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDD96B00BC; Wed, 26 Aug 2026 05:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530A76B00BD; Wed, 26 Aug 2026 05:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335376B00BE; Wed, 26 Aug 2026 05:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFC8E6B00BC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D08DD1202D5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:01 +0000 (UTC)
X-FDA: 85142871282.18.B48C747
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 18F1B1C0003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nwgTFmTm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3gq-OagsKCHcVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3gq-OagsKCHcVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVBwWKg0mQrXO0O10YWfHe5lznyWgkfKGCMSeuSJr3I=;
	b=zZVsR9bDih5EMcLAN7jG//nZ6Yp8YCN9ketkB/HmwtlwwUoc4xBbhjQ6IxS9edDKnrFauJ
	uPwHQB1Gk10Bx+2XUgUa6ug+epUkWW4Be5RMPC4IybcODi0Op5xFnq8ppKj7b/+5ZVQyFc
	9fPj+q1py2z3zue/kXdbeBPywkkekq8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nwgTFmTm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3gq-OagsKCHcVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3gq-OagsKCHcVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735940;
	b=AbM6IYACGXaNW+iKM7zyWeNE2cE0wv3o1XYMWErEK88Dy/sBnaq3sBifxVqDvTeGYVUDDu
	poFQZUckV2TUxHqApRlzAHNmPv5zw1pjP/Jf0o8b3ucF/V5PL1mGLd1cFQtJWdM0P0U5Y1
	os9QyvII19RVksVWK1Bcl5fmH8cNz0k=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so943991a12.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735939; x=1788340739; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LVBwWKg0mQrXO0O10YWfHe5lznyWgkfKGCMSeuSJr3I=;
        b=nwgTFmTm8wYgvUpTBkXmsz+doHqGAzlPtVGDqImy8YhnJPdZEt4XQAV4ywXIT2TxFz
         ay9+CajxkQGEaSMmJFLZE3TivRsF8Wtu6pcfXhvoHElGtGqfKrH7f1XdPAvlYasIpDiv
         MocJs7HQlvEWt2gPld58AdccUNUBIM+7YEt2xBrt+Yp8e7hryU/Qg6ajdg85F4xfboXC
         4GGNYczE5buCBcbiabA88eDUslgG/pTL7CiUWIQ14BC/TBQHB4iy6uZ3VV3dxV2gsbVd
         r7qgKSvt2qmeltDDIxE3TJcTWsc6aMA+7o2s0VT65/e7HJB0InMb+xi0AEEilU9y8nT2
         BkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735939; x=1788340739;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LVBwWKg0mQrXO0O10YWfHe5lznyWgkfKGCMSeuSJr3I=;
        b=s+XGHB3lXrE6zFIbu7qbKdB8D15x+5Ay0zdYRcAb7nVaxmSE0wu8jYxOAQzddq1s/A
         DiUh2YrhAO8FCNOWis7RO2kG1trCCxeHiIGZxeS7liBWXIOg+HdVoVrQOczy0JTn/gov
         MlfXqPrtI/n6utiVH90EEzGJNiC/vdCxXOhGVMZBEoeLFwWnsn9Z8xbUJJ+wAlrUNdnt
         01eWnpb4j8pn/WZxtfWd0kFWgTcSCOsVSjnA3wsDynFsxfKA3y4T+5b8As8pu6x2A5Nu
         UnxZGKbRfbaDyFZ8ICmdzlUCSW/jR0hMAielJijsYXse1SWqLfSQ9qunT9hr+By5+RYE
         py3Q==
X-Forwarded-Encrypted: i=1; AHgh+RrYDndVOnwOsN9tjXDCSb0K4ix7rAtFxTOTDp+cmIJRV/DD76jod+E3Cm3ahKPagmlO8KXvfPPA3w==@kvack.org
X-Gm-Message-State: AFuF++laAcpsyS139z6EwPwHdZJhjULE6mzWT8kjTZV/I72jc61L00Bo
	rEVBNOt9ejNlVadlRQ4GVCGsrkWLWPAqMTx/KbosuHs9z0MCVZo1QZgjr30pIepPnA05DZA9OmS
	xmTWoGEPKblBGUTlsWzogzpCw+w==
X-Received: from pgbaz9.prod.google.com ([2002:a05:6a02:49:b0:c85:a528:228f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:b7aa:b0:3ce:d411:8120 with SMTP id adf61e73a8af0-3cf84e514a9mr11917462637.15.1787735938666;
 Wed, 26 Aug 2026 02:18:58 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:28 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=7821;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4q9bpvk0He9dlg1zIfuX1OzTZApDcwh7V89/D7oUpPc=; b=nyqc1iOPnm21bfxaup4U15mR1PPdqF8HZQY61MTVaf2kB9Xz/xKXwWrUm5V0Q9oK9FtOtdvcV
 EWZn+3RK37LDtybAneIdqnQHWLzzevvjPYAXQ+cyEUvkGhFhcxIrW/C
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-30-0a15d8a799aa@google.com>
Subject: [PATCH v11 30/46] KVM: selftests: Test basic single-page conversion flow
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t7qdanq1u6gqekn64huiqjbxuae394oj
X-Rspamd-Queue-Id: 18F1B1C0003
X-HE-Tag: 1787735939-548469
X-HE-Meta: U2FsdGVkX18JMOG4Qz5y7CczPaDIScvSWsuKfT6BlPsu2z+SQU+bIbShsVNqP5iwkr0JpVEnQOa8DwID0ZJt3t75Vx1UpE8HsfJHk1o+6mlD3vh4ymVcoL3hBHw2UZLGfHCLoTLXU7qdDut7iq8oQwL0DCE4sTlbsQDHG81R2Ogrmfhx6A/BgwTLOciCZ5eGzOns/J2/JoSLovNcjh5wUCKnvW/PyCiA4oHlJ2QCGMTHkdbvfL/jWeE4amWkFu2Yq1jjLPp29GSpRjbKt7ycScNSzu0SQz9yuo/FzVGby7SByS3zTQaoqrfSVjCJqyO3+5Tat5r6l4keHrBA00vNK8A/YqYlLBv/QOl6/NFXnW6c7DwAEf9gk4V9Y7RiMj3SA2toA6g3bt4LX8d1GKhqX5YnwLfrFKDfEtwv03nQrIagUoBOC+qYqsuMtPzOQzSKaqQMu8HA9VYK+r9mTxWbRtZU5phkqrh7H/Stn+RbKnJzjDahs2oN+NRPd0C93MJDSB+WKSnNCqmfQPx/eG83iD23CZgF+gPWzMub/Qd4cc14YHpY2sKZbd3re/pib8H4rd45hnEYihSwCCgP5Cl1aa0k5N/S+jGps18zVO4Yt5l9kvVm2yQlhKNG6RMKTd4ktdyRzthWVRDAPWnp7SgFr3Zwf7cP8xIQPmpNgDy4EZAT/00E3z6+5XoNYMsylNFG5feX+QdAzBhLP+XXoiHpj4k15nkeEaCJyjEL8gmo/rrI77SD4bE6DUs/cU8/SRlFDSv/86J1NvztX89QMNE7f9pFCtByHih2/x79jDbjxRWWummH7cgPPuPmJkdaS84m/GNMXCBEdhQgIwV/jEzI6ZcEz+3A9sl+rVAgJ7qp8gHMb4f0mXetZvNUsrPFF1pDENYhfAHtEO+rCW8+zVVnoUwrDUqSd00PFEV+b34t6oWzu1jnD/ByAVHvngeSm2RhPoAr4g391rYkzjT5nNe
 MkvN+/lv
 xHEVuzoF0oq5JVFaR249H7OYvu7/JSZtGMH/uqCaLvY7NOWkLIyw5rHH0mXRCp1Nvspzk/7gkDoG9X3/3+iP7xEHLkesdXx975jAMwrhAX9q1H0byy+szWk7whYgCTRIXOVsfInL5knatWrlodOYMl+c/DJ1iRLLyMVoc18JMpU0cNqlkDT/BAEK/nmA1Vp1Y4VcNE8ma6ZmD4X760dZzTMVx8CDlAX5Vo5qyQtD0kWbn0pxlVnqod5druEXK2lOmcp9iIs0LQH9T/2sC2SqeLuUkg++TwalAhRHCy73b47WFB9t/GlWTF+vimKUbaOtwI0xnMOSI9XswXKLEj3NF5g1EEs8OSTXHcDISefsQoqd9qlTbfUoakGO+fDV72i3J56U4ycmo9IGDPZ1M83qTkpzRBmPCq7y/IvzWZk/J7ZqUb10ZOKtmUNm8I/0VCt8B3e1lyU1QBOIKl12t4AV0tbFoVzDID2XOxfegi5ix5KN91FrKs230T8+MNJheorOrRviKw1WcLEUJzn5pw1VKTxGSEqG9uqnWLKNsGAHzdxtB53gI7eYqq9LChO+ikOOBMcI+UJqA6t29zwzeU4maj66MqdqdfP6/yzBDT/Tlp912Cc+x+1ax6z7AXi0mp/txBTBcPLZRezKvAtM=
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
index 96bab7002d39e..239bc61ea384f 100644
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
2.55.0.887.g758fc8c411-goog


