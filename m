Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C631C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5837C6B00D5; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5371C6B00D7; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BEE6B00D8; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0806B00D5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99F18A0443
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:01 +0000 (UTC)
X-FDA: 85075824162.19.52D2BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACDE420006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U3Z4g/kJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVILQJ6G0mQHUef7p6e0pxqNRyjInHNi02jOT195NXk=;
	b=kK/jxFfXwXn2tUVmtSvrDuQegBcZ52z9xsn//VHY4ldcUzB+M1Cqg0LRBxz9p5Q4ekMScz
	bevphNQvAPIiPJYqVeajboNMNbJC9H4fmu17fSeb0Vl9b3kLUQ0QI3lCey2yLHygGidgDJ
	9YLsAy389Kax6qnPgfbt8RxYSYAeNqU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U3Z4g/kJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139579;
	b=kyD9Dye2h8iIQ4IOfJ4m0StEHaXp0Kf3fi3TiZLuF8vvDBsjhgz8VzvbDG/Ky/QXzREkAY
	nZMpST+JxCW/LWjf+CjV2CH5qXZF6I1UP8GF3TL0jl0nP7UIPsVK3rO9zCarnry3UumD14
	j8frqsPny2wgwbocmrOJ8Lu/UvmnnGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5210C451D9;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28138C2BCFB;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=scg9tFUVSd7SioxMaW3R0EyEJbBVbgyzVXz5qhAsZL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U3Z4g/kJ1DES/1AaEOyc4cRmWss29QuR8bSwGQbuUX6DeGuTAm+aW/iXoSwUXSpr8
	 6XZrj3IxV/BNPb0Grrbf4SA251JvMGyJ8B746thg+8IlmcXFlBjFH0Gai8ekc3mNp1
	 pXo4YmBU3BddsOBaxiWuyr6/rcM9eRAezg5X6iraqEJUQt8cy48k5mvzPz2B5VUmql
	 dz0BT9Oo3V/6XpZWwaOrENlyyzZE8znxTDg+ZIB3/16dHze4pW3p4c9y7n+h8R3E/U
	 7T71Q19apYO7r49lYkefb+ALLEmKnl2rgv3+u3HTXIgZFtOEFbAkSzgCKjpRwJuvzx
	 sN5UE8jVeszNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142D9C5ACDC;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:03 -0700
Subject: [PATCH v10 24/41] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-24-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=6306;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VBHp/vdMcryEsIZeiWdhhlAw8HGf34l+/e03cVZO2Ek=;
 b=psXIjFcRaJxdQlWPBmTS90CFkZKsrqIoQuJRSJawiu+/3XoHQaJEwz4gu9S1o5QxuRNjilZrI
 2QgaoUilsPOB5AJWlU+WleDpQ3usnY5iYYHYrpqHONe10as+jgd90F4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACDE420006
X-Stat-Signature: f1p7oamch6qdjw99wziyd4983un41rtt
X-Rspam-User: 
X-HE-Tag: 1786139579-443489
X-HE-Meta: U2FsdGVkX1+nfKETPgayU5e5QLXK2Vmp+Ft3/d6XL0PiESx+BxFUr9BopuWsscTsrFBN9I7Gbxv/MCS2ozpcX5QppyQueFeEF8PTnJMRMonXkZ2T5wKScBXkJSM/bLmhSc6jB3RfFVLHSC9MJflgMbTRiOpFgNWJaVhadv4LuXjFcGz/NLsQOuwseCv76f85FFCP8fZRFJXf1L8nAmvPjnSlizi4Sq79ZAPc50wlGz+DPkBQPlUWoXjp7r8l+sx5ziVBep/F1UASLFklPTf5eBnxvEhaaGzVUZMLIvAcyhpOoU9e6c9pX0WxLh66nLawMfr6MCoJldxpsRT1Tf5/rx8S6TdRzwZBmTsXE9bLT92re8EW5aL30YmDI4bMH1JDNeY429DpPfhThyp3uw9hm5t8f9NpDBG8+g8rWqQOjURkKZZDqZ1oqvk4N9uRNl9AR0yebcYKeVUmPMnBX+E5fd0i/bJ/eAlJSTsi+qtKFOceWB3157jOXXsv4FDN22clSqi5eW82AObwFwGa8B951yltntKXTloNUI1yRH5jSFRpTrroIm53EXvWKlBaquixlO1gbT5cdvSjwyu+L83fCXqlXvXW5MOpBWjm93hVcoomaQYQp/ogHvu4AgwNJ4U097JqjPntDiFPMbAuB7k9ADiU3vrJZNQUAJnsjFcnOK/tlr1HkM+tin905U6kWqAqfCiqiXVduDjA1HP2bdyTffx19LexOrzcinfCjeYE8ND81Qb8wAHXSYj9dxrfQq4m8bgljfr3cedV6T5dHSIUeKkib7k9zpIubk91luygr0cP+Adbk9PF9G2GjnKVmqL5BvmzrtcVeJcFdre8PjWQxka5DpFUrE8ZCmach1dlIRLYRHjMcSOVsJw8t1z3oDk2nz6NywvE735KJb5gIl672Aao5ZOsIquS5B2DtjOGEHgyxGwRO36LK5a368TwaYlWPsN/lGQdFCylCyMorug
 U5idUAv0
 Gpc6BanaoyfUqxw8SGhdDofIK/WyUaH0YttarA65m/u7QiBxnqa4yuhAiu+tW1U7q57aXhsidpmR7B2zfHszYtA6erC1DvSnzg+X/hrriFCEyaT+9EDoZFutavig+0JxeiSYT33c4ZziT8DSa5MjZzjg2qZwLwKVmUPNlQeR1FonrukUGLrSGsh0ws5WJOJYMBbejXDjR0wP4zI6Eia0/h20338cFRl/Oe1EDMCML2PbGT1s9V9DFwHzU0uBioy4zuvwIH+I17Cn5cesymCqLbPsr72F/pzFr/V3P/JRTVernXoKUx1AO9M62muFjApzj2iW1EZd7eAj8o2FAwmlmM836ZypBTZY//yMxDZxIYE0WbZPGcH2vjiKq95XFPlWE20/+xjQPaDO3h/Ew8eQCBGwYA8sUMt+Qdn9h4wS6vZ/oQwZo3bZeT5XEY0vWdms7eu6sszVG/Jyr5vdEUmPgA8OpBIIftMFnfay0p4fVovB0E0mV+cDFAKXokNgqwOcEWIXSLgpJMnMRh0oYUo6cFTnBoj4JNojT7+0s9yfXDAhc5qQALB5rBfjA2Au3mW85NAN9
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
[mmap() with gmem_offset, and always with MAP_SHARED.]
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.654.g21b8a5bc05-goog



