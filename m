Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43535FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06C86B00B8; Tue, 28 Apr 2026 19:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE736B00BA; Tue, 28 Apr 2026 19:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4116B00BB; Tue, 28 Apr 2026 19:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6986B00B8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FA031C1158
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:46 +0000 (UTC)
X-FDA: 84709549092.05.0592F0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 49E7740010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VezrHNtt;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418744;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQL5QLVMoeryCpSzxvgbAeWL/sAblIpjkDMs3WHgUq8=;
	b=vjP4u2m/BDzfvsCyf2l2hPSUw06oLActarIGhYO80tJ9j9W6DF2k/kkEI7Jk+DfoglhoB8
	mYcjpqlPcEWrk6oxKtqRRkmCQ9xMKmLwralxrHte13G9ykQi8iytBN6F/yyGZIgSmeewqr
	dz5fpvttFeYCwrPg8ArNVGSQj8xgcpg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VezrHNtt;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418744; a=rsa-sha256;
	cv=none;
	b=jTcSxLuwyvKFMCS5sO4QZf7OnOEgJ7r7HSoLgiDJHXOsNiyvRSRQ87XqHD3ACrNgyllqzM
	4Zzpd0/ceEqcXo/P7dSsQBYeBO4XDa1i67E9k2D19h01wV6G7CX4nLxMyBWMFXfcGFWo/n
	hvP0Iw0lwX0jQSD6JZhIc/wAObmUD5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6759A44B77;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41627C2BCB3;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=sREAP2MxGPEbvXSq5SRQ/nStAIIJ5drv06P6dsUlKj0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VezrHNtt59Dx1C2KXiPFAf1qGG5aL14O7Xt7SsmDPsDSSgIbQWWaGeuzsqrPzSKEp
	 JbuN/2lpgyJygOhSexN9SK8JmQITv7LcE5VPw0t7fmbkqA8tyW/2yefChZdspqpq60
	 vavvHsIuCVZ3BZLh/OT5DUdnktWbZTJEWoEd+ccLzkzVqipIku1AgZveNH624/W5Lm
	 H6h9LdzhdIjBf5Mjj4hertntX+O19dQ3qTFpUSSgNeTkHD1OojScPF4znehmOfb9cu
	 kZPWaAyYk2QJjJy68GT56xz7R6rRm23XpttVgdhFpBDUNWcw5TbRweBE/BzCVpkORH
	 deJqVab1J4ijQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38514FF8875;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:42 -0700
Subject: [PATCH RFC v5 47/53] KVM: selftests: Provide common function to
 set memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-47-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5499;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=x8WxP9zvytzuqL5tzXmnvDO35wF0Bk1eLqxImWMw/aQ=;
 b=iV5e1pQisdMevCU5CiJtojdosppLVl1PRMIYiUBBT/pi9FZox4TCPglLIzytx0XkHy9Ph9bsO
 xFjPgwK5wRvAwZzt6Lx1VOzRt2Hz4eVHfIO3i7PgOCUXg601spXNW2d
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: nww6brrzuofifrkog7ggzdkfxqfjacak
X-Rspamd-Queue-Id: 49E7740010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418744-678796
X-HE-Meta: U2FsdGVkX1/67R6qwibFNtzdr0tacAkN+3EVbjamfbFYQaMG0v2XR/OlRN02cjqmqm4XhCg9EVKNR7DwAqpgpoACWh9Snn1z4PdhodfUQChjWdEZ29JKRn8kaSTGJ1hh3l6g9Jnalbn34HX5q6MBjwBfm1E6/IWdkBpD9kVDn/Ewccg1Lm7OX1wDk86e7oV4oJeOGnHHmKQ0TlJTQLYj9vUxLNEoEpR0ajm5r0VR3BriLdbQo578Q3Ko9aiTzmlvbY1TAng+CxATTMROxBm8pYo5dWYgm+r+NXcz5Mf9FG/lQpKW0+2hxWR6PZmkXvgH2eH2gvSWWQpnVm9AUaoKc8RgqoA9/qDYfnFttUkeW4beP5zfBc57v20C7EQAgHvjgJ8I2dvZHmnHpfUV5SnYkodiG7vzJhrrqnZFccJU/gAFTrbOfMiGlkDhBIMUihJPxzoPiklcf3mU1cdTjqDOO6dAemClXLGfUlmc8zGLdeaEdW6L7BDA36zmqH6ZFAcjImTRdnd9yi7R+40ksXODD/bCga2dKxyfaSdDCVLJxfEtooVFgDrZL5TW4cpkeJTPnt4D7iyVJtQeqkXvLtz2UUrPvSpecoaofUDi0xxY2E8RwcZ+mXCDiykDx/lnRsA8kxXzGPTV8WxIGLUuuwGGKU6JO2I5qpuAa1bAqEkVimoCwji4x6BsB6T0SGxXKR0zfboHCzmwDCaqUNxt40QT/ctsWOlsn3b+Bh4dxyslbAW+6WujP362x/VokbRkLgAE9eB04/JabI1dvstgg8HbpUvdzHsKXO67/S1aRP8HG+A7bNJtiILB7P1uOhBBxZgeQjspfFLh0hC8aTxShGBSwJe85i28CjQwVjxMlRdlCQBdmMuXDjqsw/qchKxf2YnqOe3WLYcIDvKJ6lPdsjaG1IyvUZZug1QpoCtIl6fLWJQfHVx+/RIDhgZwlN7iJ1ZvQJvMno5qILZ0bMIvzWh
 +j/cpwXn
 +LCx2MRmcFAAXWBBknMSKr9DorS+4GBMupV9YiBTPmk/8PSjVefUhMvT3bEJjH8eB23qjO5wp4rVy6564d1Me8P/BCasv0NcdXScE2N68XUg2VZsk2aLdOCAgkUnl3T9QUBJVK5rSXHZ+tr9oiYi65FCrChcAbITexJc4I8KTOLthIbYlgOajQt6/qYcf8LF5QWqMwnBH8OeXzBE5m+CVN33KFScZaE4uDsVVaR7aAadsYE5LuYjJ5cm+f4UFqhB2q2cButHuEq7NPYi23OhJ26bxHrgMh655P7zM5i1RLoZnpMBHNcrnWdTnjkwVNY25rK9xDZZZ+IzPt3d87O6uA2kJbhZtlBorK9Ct6vvBhFqrZnDYn8NOtxlV+YeYeDBB0Xw+wdVNg2/8uLbBnqnwKeraNU2nDdGsk70D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce vm_mem_set_memory_attributes(), which handles setting of memory
attributes for a range of guest physical addresses, regardless of whether
the attributes should be set via guest_memfd or via the memory attributes
at the VM level.

Refactor existing vm_mem_set_{shared,private} functions to use the new
function. Opportunistically update the size parameter to use size_t instead
of u64.

Update existing caller of vm_mem_set_private().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     | 47 ++++++++++++++++------
 tools/testing/selftests/kvm/lib/x86/sev.c          |  2 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  2 +-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  4 +-
 4 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7de88cbdfd2b8..c9dba44ce6bf9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -454,18 +454,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
-				      u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
-				     u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
 					       size_t size, u64 attributes,
 					       loff_t *error_offset,
@@ -536,6 +524,41 @@ static inline void gmem_set_shared(int fd, loff_t offset, size_t size, u64 flags
 	gmem_set_memory_attributes(fd, offset, size, 0, flags);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
+						size_t size, u64 attrs, u64 flags)
+{
+	if (kvm_has_gmem_attributes) {
+		gpa_t end = gpa + size;
+		off_t fd_offset;
+		gpa_t addr;
+		size_t len;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs, flags);
+		}
+	} else {
+		TEST_ASSERT(!flags, "Flags are not supported.");
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
+				      size_t size, u64 flags)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size,
+				     KVM_MEMORY_ATTRIBUTE_PRIVATE, flags);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
+				     size_t size, u64 flags)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0, flags);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index 93f9169034617..d0205b3299e0b 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -33,7 +33,7 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 		const u64 offset = (i - lowest_page_in_region) * vm->page_size;
 
 		if (private)
-			vm_mem_set_private(vm, gpa_base + offset, size);
+			vm_mem_set_private(vm, gpa_base + offset, size, 0);
 
 		if (is_sev_snp_vm(vm))
 			snp_launch_update_data(vm, gpa_base + offset,
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index fcb57fd034e67..9d16a277696ce 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -184,7 +184,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
 	if (private)
-		vm_mem_set_private(vm, gpa, TEST_SIZE);
+		vm_mem_set_private(vm, gpa, TEST_SIZE, 0);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
 	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 10db9fe6d9063..9309d67841482 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -63,7 +63,7 @@ static void test_private_access_memslot_deleted(void)
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
 	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
 	pthread_create(&vm_thread, NULL,
 		       (void *(*)(void *))run_vcpu_get_exit_reason,
@@ -99,7 +99,7 @@ static void test_private_access_memslot_not_private(void)
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
 	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
 	exit_reason = run_vcpu_get_exit_reason(vcpu);
 

-- 
2.54.0.545.g6539524ca2-goog



