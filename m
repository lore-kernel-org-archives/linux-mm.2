Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C534BC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AAB6B00A0; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27706B00A4; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E119F6B00A1; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5E346B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 320BB804E5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
X-FDA: 85039944948.12.9F775A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 390324000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbedXnbf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQM2L7fvBlay50UUTYVFgNTSKeivv7MI0IJRMZ4sAvw=;
	b=sAf4wUv8beNU/0Xcl+eKp8Y/KDCOGCL+oxG0o6sh5ZPtxsNS6DfkJGHUavcVknSds4RLG8
	2r67jrpU+Hh6h3YKsIpQ2fRNiU56JUF7tC8RBfAGWLhW8RxNMMEfVGU6drV1DIIqMJ8ZgC
	CoUEmhPRAORKZVqx0WxBKYwhDiwu7Qg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbedXnbf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285312;
	b=ghi36pEwKzCzffDr1K2txY9V+iJVS4SvsJxwXHzU452dovdU1eGGrpfLYuZwFBK1rLRyk8
	eXJZw6DisbqRlhuvpvTNt97KhOMdjWzmQD+ZTOiohtWeYYnbdsm18eD6C/HhPK/TWHBZx+
	ywd6J3mnveykW54+/EAbSu0mVX2trUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B50360DD7;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE546C4E699;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=eA8+MjzgXaZtUOiceVEd6O/mOIwu39zs19o0YhF+nHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hbedXnbf3e437oLAFHQSAoP/EUJGYKnYcncVELtjMThxWH84FTtpw6yxzEY+zOw01
	 lRT1nvxM9HbCGa15i6saobNBekgwIiThhsIO+q0+QVyX4llbLQ2a9cNHls1K49I5hm
	 MtDWsPwXGcHIInVV3QoPMn8gQTBJRDMc+0Lvkhdzw91DuVGrVDJDw3txN+Uf35+AeE
	 CZ1oM8XGRVuulP8427N2vBqY2BsCPAtHMRw9hp1srt8/MAk+2DEIaSsEaULaF546zC
	 Qqd6esYe6N0Eg9eZFm8pCb0Q5pbzV3VBqzI1XbnDGAg2nFgdI+r+4fijhTALdyF72n
	 GGzJzFU50tpbg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E13C54F4D;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:23 -0700
Subject: [PATCH v9 24/41] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-24-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=6306;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=oRhgNbJ7RPzcWkyv4CHBnzV8AI0cfo45wdaBIhyvBrI=;
 b=j23AURyR7Djm0hgKZbwb548qa8fQjQk/B5YeJJ/dUcMEY9Jebtksosf1SmeOc1IfB3B9S9XEf
 dQ7g64iPgbADfjc5wGcs6UD76uOTqjtHTx5WY0yaFz0EzZLs2EnWmvc
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 390324000B
X-Rspam-User: 
X-Stat-Signature: 7mbc9m8xwdyf3xqfzhdzjc7okgcw73af
X-HE-Tag: 1785285312-641989
X-HE-Meta: U2FsdGVkX18LLKa/wm5UGs43IhxLYPHaoIQuFNSKXwnhDMGsHatHf9FMUa7cHN5ZGa0l+FrK/y30VqJqdGgiwK7v/TUpWDAWWrpHAk3oSs0fffZZ+vEDfc1/NEXi8pgC8gUTKFdKOD+vmWymxxtSqTyD8DZl293c53TjJkqzdWcfbSCUM4TiAcQQKE1hLJt2hMXzlBB4IIISquo79VMoWBDoJiS3xn4p9E0v+Xf1CMQMs0CycGQiUjnWwRhOwKT12pIJ9tbJutbYOJKZoSjNm76tzzUJASwFyei6SYQ8Tto9v/KZbnJM+uCh0L3bPjpFnmFqo9oXZvwlDtz6vKGj0og4Iy2NZcaaOA0HcixayPSQ27K0YlTUdg4VlPldcSIat1kaj8D6wZimPw0BxuJS/17G+paZNXpeoWhehrcWltcLi9AXMz47KnJCSoYBFxTgtsqKf1vizzHZ9Hef9I1dtqdOxVdHSG1VDQ1m7FaBh3DFEASuqPNXF8Df70YmFr9IR0YcNNYBoQvsi4LgP2ipoLkPNmuuYPxzTD/qBegj53uYWc6hS68yr1i8zmG0PDtAcH4rIbthriHkX8CUfEFI2C8Ya+fo2r6RYDYaVTNPrE40/MAiLjQ6V28HUzcXTzet3GnnMW6b0FdvhjMJmZDndwKP/1oEbkjzF0LfsKuuEtKDUH+yLY/p/6eqp6asqiPNulbBfKuwiYEX+B8Fadja82jn22NZvuCgpuJYn/7oSOST93wO18YxwPu8xBcNNufq2OxWQMDr/9kv2nyytqf6DVLj9XhDnE+aqP6DkhevLEgA7iFq/ljkqXWVJU4uDbggZxNf4MXY9sJJgle7Gx+5Hm4l703sxTccTsndYxTVvFmp+6dtJ65R9uUUvP+KSZr44DwWCd+34V7p/v6gQNKFmLxoShQEAsjcSzO8Bj1SXhlQlo3ruUSx7kdwSX3IrsxGLj63DaeHmx+ml3BiYyL
 E5VHlG5f
 1qELC3d573e4Q4yhmjVtC7JulBQO/OyhrXMcR+lyDMYaGg2sTgPT+VlmN0ubEqcCWj4zzsLWGRi7kdhYkNFlL4jz3SG/KICr0z8KT3JmBwJd2LCpxe6tLxUCAtMnKeyj51pctJ4LFkpehTy6dvEpZB0cFo0Bmg/eSDeKbKcCTpLpg0tlfUs2ReyhroIGhR+svfgj3/zA38q/rgb3MAmdvVDsv6fBa3yiBpTsf4VdF4sw79QxZUGjJIfdlsPEBzWISxCH4zFEc8bhP/H3q9DalzXNW7IuOM4NBxV50KanZfuHVWspxg7HsE1paAZsdKyOeuN0cr8kfpV3uwfCXKucfOsQV3+WamUEPOJHkwV5VYKbb25iMxWeJxIh4gilh7gtcc0wTbhQxCvGJjARgORC4p/4ViO8drboZojtaFZ0Jc9dRsZdclzgnrvb6IVU2bl5ngnOJtkk6pa5G7MhgFFirc67qeer+XCy6g1S4wPNfN15GUm/rISTRmJox7Kpzr5h7Qq15VdeoYyv43vb0AXFZSloDSVy8AVrR1nUTz9NZ/ayS203d451N0ilBUA==
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
index 5adad5d4e9cd6..2186e98583969 100644
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
index 57512c9ed579d..2017dd34001f8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1004,12 +1004,14 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
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
@@ -1081,8 +1083,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			u32 gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1103,13 +1103,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1155,10 +1159,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
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
@@ -1169,7 +1173,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
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
2.55.0.508.g3f0d502094-goog



