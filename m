Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF75CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD36F6B00B5; Thu, 18 Jun 2026 20:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36EF6B00B6; Thu, 18 Jun 2026 20:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8106B00B7; Thu, 18 Jun 2026 20:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4545C6B00B5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C773402D4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:01 +0000 (UTC)
X-FDA: 84894784842.21.BA1736C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CE3C20008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pl855Gqk;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmZCA3dPAFWFlbyTr3sx64FfYsV3kUKAh/NaCERXjgM=;
	b=BlaLYr0eMj34IdRZCFqGOFI857rWDf0LAWO6nHiNOo076bPzYzERCzXD3hE9yJHRHUEsWC
	e9POVuLsU9CHf9oqi0jTNMtCY+akBsoiLpsPWYk5Kp1tHGjg5n5HzVSP142HC7Y8Xusj8c
	Ib/LuvofFhPuNWopEfrEfgWu6Rgv2jg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pl855Gqk;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829119;
	b=VFV7o5M379y4vHJcW4t8iqi9VKqOVvtkSgbKvkNxVM7J/8tg9GLT95UYKhGWukuiE6m/PB
	J0aLoJh6rP7W6krgBiSdEl6i3zk30M65Wah01/0splHknII3iTkvBaHFlCLvxguKCmtC0k
	pTYRDlqFVd3N/LpZWuFuB7WPovmlLUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D50EA445ED;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADF8BC2BCF5;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=Ll+43sSYqY2OH2Jli1Ltcc2BbQuBgtKf9K8AI194+eI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Pl855Gqk6TkFZ/Vl1UbG+exuM/n5/20p+kIAOoCUhYvoYskbWXjqQehVGhapcelZg
	 S95sMa8Yw5qTY0gITleVadTpzM6+nbGJ2hKXHuX3ZX4POF7Oj3lnRJTntE/3qtKqJ+
	 QNPlZpEYVimUS31tdlr2a9iHg+PnGd030pAra1S/J45zSszH5r5IR+cH/zFWEFfEJp
	 XOaaZuLeh276iCbYp5Ml5GNM7+OY8N272kN1mwaq6UkkJzzxRo8/Zv6XCFudoX29wR
	 qq0XlIR5GV9l53cJrJNTY94Oty77FcwZYBOF/0zkyK7Fzdd+5N4PnxcpxT17QI7Y6p
	 VWOyD+cNtbOJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2458CDB461;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:05 -0700
Subject: [PATCH v8 28/46] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-28-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=6068;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=GtPDg23FPq5+sXEXdDPAincXRNuGxgcmzYFSpCwE45E=;
 b=afYmzD1q5pAaSyHEvvF02XdvzZCM+1lCDTZto3YGiuC82Gg6H6VRA8WpVYoUK+sibEVYjKF3Q
 L9Oii+ZVeTdAQimoGjjC/RPLHZ8Hm/GKmqTdE/AmkKNg36HrTf199Z7
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CE3C20008
X-Rspam-User: 
X-Stat-Signature: yn7ihmqsosc3xbd71rx7q7rbajy93swj
X-HE-Tag: 1781829119-756528
X-HE-Meta: U2FsdGVkX18cOLyNUiRblSMxwNxz3z9GqleyKhF4PN/3SpjJpYJHxXRhYfHRomdsfIlFW4FKmk9BYuysQiRk0edDJafNupTbaLKkkPf+p7AAm0wT0JzXywEqrm46wX0sat0Eyw7XgZKIAVQ74wt06sgVd/Yjj0KEnF+urrcQU7YsJsGV+KINQo9CAJcSai95eIlPfMYCTxxechwfITFdGUDJUA+PJLFJtV3RYe/nHVV7oPeymSiCFq/ZXdRzgMGTLkZmhi59ZetwxDSVfKEyhmoMa3rjxm/egzaXwLSfIcKmxymaUOoEBjtpGb6aPBzPIU/OYeY0SCrXKpaspqpTffM/z1PZ68ZeucV4FxwmT0V7lJ+yTlyaj454tVJwPUC3zOuPWdqiVjhgDEWxOYEkKInCTOdosT70Szk/SjARWtpBnwnP85ZkSGqqmH5Gjc9dTfSFtf2pY4AqURaXQZe5qmr50nqubsjvQVIPu2Mg0PZ8KzEkudYHbNMqvQDAmxbYhqaWSLFK4kD1JCQhI7UUsSU+GqAGxLcbkgwWSXTJYsIIzulnNcTyKiNhrnFq3cIlgfj0Dt9C2k4sQUf4LV5Oz2XeYUX5k4smT/utPiuGlM51hmSGbamI93Q1VwhAFAali4uxPuZzeje3ENIbqh8oB7ly8oSIDAFwrof6dwmSDqTrgGJHvAdx/eGt0t47N3L5SMPGDUBllU1EJkfOykuP/AwMM8jQK6LLD6WJHxNQeICFkOgn3TVEbAVRN5EaBb+Udd7PDZk0m7C57XfXYrEaAUmNqP0MprCIdNIden+9k7p8VMM+jEg2V0BlsV6UPlE7jqcVa3uoiSaKZ10RQ4tGDNFJ1ybxgPOd5j3xO1jbmvBIR0OJmY6SsG1qm1KQjib9amfjhySa0Tgj8YbxexTts+xWNJqQIqvGZAbqe6hrXgJlXlUwpCGTi0t9P9+ppasNzTfgsSM/d9BbyTE47lk
 qf9OOz3M
 fR/M6G3VYvUI/nQriKxnJ/FE5LMhxoeqXjKHeHHgdourIFkX+c+P3oL4fo4GabqrFNWJG+nRNsrEO4KBHqo0R7onmmzWRdhEtB+EmgBdTmKRh6Vu7uF9a0QT9vbhABU9kCZlckhKZMOoe02kF+yDmIevDBYOMiruBRWwbbXMAF4NaBkhVaOKT0/VmSbwvtj9DTxCt50fa4vB2VX+UaZusZ8Is014Dor1HsrCGCwLViK8nulsa9aBaRW4WEcgrmZqzVxv17GjJw9e+V7jn8zKOg8YGGxr5bnk6C3uxMKyxyZjRe4DSIKIG94EdI6NaaNWSmhflMdHg1LAX+l3TVLSxT7PVUkPX32XyzhzRVvU30X6Y5dtOLQuxwYUoo1cQhd+tubXHtkfP9+BdyM1lxiqxfso1Nss1QOk8fgs3I8Q0LmcVG6V90eIxH0s6zzP2Gx+gE9L3CaL/+hOxA+h3O2GXu3T6hJw3xGYSfSuu82CzhZeEG2NkePExk9txzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
vm_mem_add().

When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
provided (or created) gmem_fd as the fd for the user memory region. This
makes it available to be mmap()-ed from just like fds from other memory
sources. mmap() from guest_memfd using the provided gmem_flags and
gmem_offset.

Add a kvm_slot_to_fd() helper to provide convenient access to the file
descriptor of a memslot.

Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
preserve existing behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |  7 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 27 ++++++++++++----------
 .../kvm/x86/private_mem_conversions_test.c         |  2 +-
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d4c104cb0418f..0cacf3698b259 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -700,7 +700,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int gmem_fd, u64 gmem_offset);
+		int gmem_fd, u64 gmem_offset, u64 gmem_flags);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -732,6 +732,11 @@ void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
 gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
 
+static inline int kvm_slot_to_fd(struct kvm_vm *vm, u32 slot)
+{
+	return memslot2region(vm, slot)->fd;
+}
+
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9b482778f7379..d5bbc80b2bf1c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -978,12 +978,13 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int gmem_fd, u64 gmem_offset)
+		int gmem_fd, u64 gmem_offset, u64 gmem_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
 	size_t mem_size = npages * vm->page_size;
+	off_t mmap_offset = 0;
 	size_t alignment = 1;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -1055,8 +1056,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			u32 gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1077,13 +1076,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
+		region->fd = kvm_dup(gmem_fd);
+		mmap_offset = gmem_offset;
+	} else if (backing_src_is_shared(src_type)) {
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
+	}
 
-	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
-				      vm_mem_backing_src_alias(src_type)->flag,
-				      region->fd);
+	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
+					vm_mem_backing_src_alias(src_type)->flag,
+					region->fd, mmap_offset);
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -1129,10 +1132,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
-		region->mmap_alias = kvm_mmap(region->mmap_size,
-					      PROT_READ | PROT_WRITE,
-					      vm_mem_backing_src_alias(src_type)->flag,
-					      region->fd);
+		region->mmap_alias = __kvm_mmap(region->mmap_size,
+						PROT_READ | PROT_WRITE,
+						vm_mem_backing_src_alias(src_type)->flag,
+						region->fd, mmap_offset);
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
@@ -1143,7 +1146,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags)
 {
-	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 1d2f5d4fd45d7..861baff201e78 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



