Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED360C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA82D6B00C8; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F346B00C9; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994FB6B00CA; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE7D6B00C8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EE2C1405DA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:50 +0000 (UTC)
X-FDA: 85199512860.15.4C645F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 84E3C40008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iODvrWKK;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084548;
	b=rOJG5H3CqtGb1IkodhKAkdMXXm2cf8GXgYYf8V8YdA2MFA67TalbbbBfdg7BNdgSoNJRub
	u/98S2ovALmK0WygdUKUHq2T+4jMF/uN9BZQ3XZ4AWsDTUwHtZLwKO+p1AZYh+dUGmUkNV
	Glrlwrt7lmoVcO002SNDT4WMBBRxMmg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iODvrWKK;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084548;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIA/wXio72gbqJkE4ETOhubct5t0ktXEmbdsYntoiHs=;
	b=ExMWLo3Cv3q1Mx33+3oQz2ldY1L54Gz2iceqKFy+UDo4KhStLUSY4UwceEf+3KBFVOQfel
	1cDCGhaESnAiOCO/VD0ezb47QEIJsbRmzUWEHtg1VtmOEnVT3OqhxGQaA1a6Bs6wJdcEuu
	6IfJPMqlVVyVpUnIljqNMztlDubaT5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8450D4490A;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51C59C2BCFB;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=mOSBuvlhXRw9kKLle6wToweA8590YKvVlaB6BBJrVuI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iODvrWKKkE/CSUKjml99Ys/KdQp+NFxVgxGZIKKfF7tiuOhuU0KLf2kf6UWuFuqR2
	 tWQiKUMtzrkzp1uf5je22uVyuI4Y46XZTCprvzrNP9anrd3TtToQiDSJmeXfcN7M6C
	 pxmZLCWPasWz+A2M2qVKAXi3MbhPKdLXNB9E7efogaD9655vnounLVfHFjq5EZmO/A
	 Ert6QJXHxuUwYY70p4imxMQgT/aAb5rdckiwARFWungD3BadJJvk99mPmmJ7ttN7pG
	 AV7MA4FZXdJt/YUyZgtKnah+QMpe45w/3+kLC/AG7u2E0OvxNvBnpevFZh5BjeNtQm
	 kaLHQv0xYejbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D50DC88E49;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:52 -0700
Subject: [PATCH v13 26/44] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-26-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=6307;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Y0/M8zFLRVYzxfNZnbsRQ1DqeXpThQossdoX7qTMEj8=;
 b=XAsQUFepWY5SR8UbbaaDfFFPDICKe52oWYXSPLiOrFWLVzrN7Qo78he0P9VmecuIgGWz1M8Px
 ylx4ksESxALBPxOuNv/z1PyhY6JUf4Y2zlZCtSdZ31i4crJFpFV36ch
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84E3C40008
X-Stat-Signature: 7adwcjqmqf61zb1gk84tzgz7hpy51t37
X-HE-Tag: 1789084548-141043
X-HE-Meta: U2FsdGVkX18Ns5Ivy/TeCeAVYG0nx4kaooLw6pHX5v7OW4XRQkaoeW4sLWfCM80NAsKTnCcWnpbBK9sha+Bluse6SBWmX6VGo7DsP3HqHApPGDvs7bvjLAkDpmRuXo074bGVDJxgiSt+nYiSdl1foU7wycdl/GUbY4G9MOi5Lbb3HK9MDzLr/nCD4lA3GduEQW4CU5NUQzygkKIpXCxOYDOWTV6kYlDGbvQLIY2Y/FfOX5LA4jEJUBnZ651HLnYRHF7eCVkOzssg1JDI8dQ5J4X3w/UPVukmsm5CJrNS2EV8k4oeqeHz7IbLvgMg0tQ4vTSwjkY1ZXx1kaA2rexJxywfQqQBpEivGKT6XsWLagfn1sBkSAYYPmNEMOx/TddX6P6IJUws6xysiFJ+G4x+1LTHDhCOmg//8Zp9IPaGGvezdpurGZ+O6pJtlcuDdxRE/0f8Lgiup3StkeV+jpwcoGCbi6SCVKXgfGpD96nJ8S2ZZ9Gex3CBDuSe9cCeSlXimjGr6nCsJMA866A+buIiCo8JvzLXZ43DVZ3bN9gfCtmh0m+saPKYnBHqYO38zHxYPk1uAN38orlpLtjSN+jDfBQMfyViRmPLazZnhK8vOC5X95k/4YGKLiF4JQ1nZIxO35A55NKmSjdmEgVUd2nlhO79Ac0wbE0JQw/mogXl7UdvCdrSjhZnOteMqKxmtE11SZs60umG7HCcK1WNNSsueeYkaqKe1RR5EO2QQPLBcyXtOmOIylefZEkeexufD/JY8s6L27k/aaA/jANj0+YnD+80jcXfBNEP1Vybvm2dy6ubtqgHDiQ4QcpOCuRzht91T7Hnw1yAgFzpkzJfh5CxqNcG6hsEOUg8M6ezW9TO+lKhumiOodTyrjeI1pkTXuL8+O5Wikt07c1EbeXfcU5iuu5Ifk3j5Ia/APOHJwVtJKVhbgGniiVaLYRk/kroKO5jLbCDqZtENDAR/4wneKD
 SELnLUQi
 zHPq9jVfYCrPs0QTJKoNmFCQ+J9UGATpCFCm/XUBYrJir8XXVJCEYI7XXL7zJCdGdp+bF50qIHSKGlkDWoCy0Y4LIKmrdIvSd5uE3BiUXGn0aBzXrCvnJ1cUFARW4DhPRT/YKX+qYTC7ZUVZqJ2aY3K6cSfkOfbC9D7W8EuhdLWlfJMxhiPHMzKq5j7vRuVu+VzQuoAiHMzNbVqeAMIIMseAOse7eaeXH6/eorr5t9X3uCxGFUnPA/uMH9MCXliLpTaDQSmZzptNaORUwmE6dovpJt0HHJyDz7D0P5s30hyt+cSDIZW3S+5HuJqYILPL49tbR3dH/MtiNDoGGOY+SsShLWFCDeAWXTN8qWBrLHsYnXOuFXRUJI0yUrm0Mh/yH/P8GMTaiggI+z2kTOmJSRp/GqULfaIJlBgwunV5i4NgiHTR/qemG/8jGeiFrpmVCr5AIVBZP1WjD28pRi/bxiI4jqzy0232YH2BEDOjxipzOoXHgCq4UX3dRiIamTns06ojGAC9LjEEb6Jo6Rg6aXGPBZg==
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
sources.

For guest_memfds, mmap() using gmem_offset instead of 0 all the time.

Always use MAP_SHARED if mmap-ing from guest_memfd instead of reading flag
from the configured src_type, which doesn't include guest_memfd.

Add a kvm_slot_to_fd() helper to provide convenient access to the file
descriptor of a memslot.

Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
preserve existing behavior.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |  7 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 28 ++++++++++++----------
 .../kvm/x86/private_mem_conversions_test.c         |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index cf49a84de02e8..a091c495442a1 100644
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
index af501a27211a2..08d0bbcd421ea 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1002,12 +1002,14 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int gmem_fd, u64 gmem_offset)
+		int gmem_fd, u64 gmem_offset, u64 gmem_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
+	int mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
 	size_t mem_size = npages * vm->page_size;
+	off_t mmap_offset = 0;
 	size_t alignment = 1;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -1079,8 +1081,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			u32 gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1101,13 +1101,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
+		region->fd = kvm_dup(gmem_fd);
+		mmap_flags = MAP_SHARED;
+		mmap_offset = gmem_offset;
+	} else if (backing_src_is_shared(src_type)) {
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
+	}
 
-	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
-				      vm_mem_backing_src_alias(src_type)->flag,
-				      region->fd);
+	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
+					mmap_flags, region->fd, mmap_offset);
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -1153,10 +1157,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
-		region->mmap_alias = kvm_mmap(region->mmap_size,
-					      PROT_READ | PROT_WRITE,
-					      vm_mem_backing_src_alias(src_type)->flag,
-					      region->fd);
+		region->mmap_alias = __kvm_mmap(region->mmap_size,
+						PROT_READ | PROT_WRITE,
+						mmap_flags, region->fd,
+						mmap_offset);
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
@@ -1167,7 +1171,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags)
 {
-	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 3aa0673f79f33..f3de2a4ab0551 100644
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
2.55.0.1007.g17ff1f9808-goog



