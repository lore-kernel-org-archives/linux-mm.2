Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FC9FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4823C6B00B3; Tue, 28 Apr 2026 19:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4319D6B00B7; Tue, 28 Apr 2026 19:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3269E6B00B3; Tue, 28 Apr 2026 19:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF3B6B00B3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D24C51C0E44
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:34 +0000 (UTC)
X-FDA: 84709548588.13.7A49999
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9EB310000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDSTg4WS;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6aQczMyawgg4B+5C9jON8jngQOLO2h+spudzFzlLhE=;
	b=HIw+CvJ3fIR9erU/BJeKGog2q45ntKBX+s1mPD1aA3Cv1atsPRoGJRGamV05wkJNyaxd2C
	aVp/ct3frkZh+nPdXda8C3VVQ7OA7wbTMtMap9lQLu6G3dVVhkhHMzYKzvimdolraLXqOq
	lfsYouJcCGbUbTozwdeQKac3nBDzJYA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDSTg4WS;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418732; a=rsa-sha256;
	cv=none;
	b=gt7u567O8wb0nGSztzH3ebD13IdwVw0/+AkImfDUlO7T1WzuG0RKJDjnK/hpHez5m8CtWS
	IpNZDy5wUKBhGIYsQb7fupQ/P0wSd6AQt46Fv2m61v1BhtCqxFqSfkSCwhP/oUOeJSmlqm
	XJ+GISGpq8+BQtw2vwP6zHcr6rfDVng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 084E244A81;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF4ECC2BCB8;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=Tb5TguUqj83q6EkDS3KK98jP7mZKk3DZAdSKTO+qVyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KDSTg4WSIZFOC5Ne9UPdjPf11FJ2ufRAsp7BnH1g63i8+JvnsKb1bwRa7IkczuiPz
	 fpYVsVUxrkjgtxLek+knPsaeFBrqT4IVzST2ph6s+zhTp8oJ+coEphM9oVvLpFBtMN
	 bs1FL17Ck7z8IKneb3i7RO4PGF/RADSxwCrp1GqL3Q7VlYPqfo4EMrRW2kd3Cqi110
	 1akzhK4luTxaYhC3WMAQATv0oETiZj+2Yg6/NSkSASCJjJESareUF2ogoqxZO/DD6u
	 cLSA7FVdL7fHukrZPStXG5d7TrXAB9IyjC8wOH8+KwoDPeEtzuAFPzPDdZ+zTC8UfI
	 gmeixg9KrIrmg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C589FFF8875;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:26 -0700
Subject: [PATCH RFC v5 31/53] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-31-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5449;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9LuZKo8RnG3pI99RA8uUaagBn7KtPFHLhC8KQm9YV7Q=;
 b=a5nVRdhvKlIKuUk1DfR/yQJcWLS2+TX8K8rJWDhgYQaX3s6oiuHHkvhGzXMmyHNeeQ16C+zSY
 45XzSUi64ncDaYSqmwLop1tZ3QU92mUwgcnpg8HmfrsWfw5lBZhlUqM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B9EB310000D
X-Rspamd-Server: rspam06
X-Stat-Signature: mb5m8fnhhiworu49zdni686rsm6bycbh
X-HE-Tag: 1777418732-202546
X-HE-Meta: U2FsdGVkX193qTFCKS7tMfS/pX9RZnsIZMzKAePEJOqZPBa/xhMB6diMrP00meEUhmUoUa3OSMfx/eO92uPxIgO4UHnhv76fkdqe0Bg2AOAol7eebZbU13zQVE114jSJyZgztgayqDGO+VhCRRavfM4GH5zK1reILk1hStbw44Tes6WvepdTdJFsAfy1w48YRQCPqf8/tDpaW8AZcWQJzgPe9T2rZ3ailBxYwas9Iwnzh7/3KH+ihWXJWysWNmwtRwz8NzIcroJgKHWT05O16G8Lp73LyI4FXc2rXK+NzjHKvfI5lK4yjmNxVUsGjsQD72Rcs3K6L9NCJe2AyPDYPSV5ev9NB/rhbJlsKkHkUu24RsBkkBkhzoKWBjszthUlA8WDEh3PmWKhryoFmTeJHq438aNzlZBAgMZu5UiIsCvi3eH1y7CKkDOhn62YnBCqTU4wTdyjtoW1HMZItbp3g3qzL3SEYZUH1UAZROriMd1vYKEVPEG5Ft3zNxaX6K9Ke++kFlLQcqgh2+Ts+gpNGSsHSXwjGBc4ZxRJdc1tPbhbxN68l1K4VEpzvji2z+rNxP2hXe+zmAhmhSga3gAV9kL1xsPm0Zbr+pT1BHy3sltIBYjsiqPMmKz5In1y38v4Gl9ZY55GLQAmx4+ot0kl12dJ8JpftgAuAioYkIpU6g/bDOY4keSsOD++isH1sjdXcRu8BG1l++sDGZIaS9F0nHgkAYB3BgnJrApvo+Cl6CEk6x4X6g+0dlFq2RZz0UP3SXExnEJ1FO1gdFUTDNnAGqfAzxyIhD/tLFAXuZvzEMI/vrBp1peJ22lb32jhYV7uj0SrOy7nbXadq09yVzoyJ26eKeYQlvlwzkBfzdhJtu60A1eoZcYS0rL84UnMOBGj8XDnjzA9ycvIiHexPC81a3kdVsZO5YY6Ek/QiG0N2xsoGZasDEH5GSd4lWO4XODNBZqRyIeIMSdyxwgYKOg
 muWb8w69
 qJPVruTQVDoi4Ii0udDNgQizzn5Z09c/vEVLQcxZV9CJ0RjXF1Fgl2md+wqXXZSET8OZm2NFybIxIv5jTJK98NKxn31YRV70aL9uphW6KpDgGBH7K9FYorzlPcCv3h3fKLaVmBjHgqs1QnEupy1HGvD5wFosIrM9rbJyL7xadJOp2ALY3VPXkMkaeMIHrq9UT4z0xirRmViwTcl6a4pHvpB6+sD3tc7U8WyDAFGugZ48CIh6NKpUU5x+rEkKDXYQc2OoAb74tiPCLllkLEcl5mUA2gs8Fw3h6fC22B77Icz/jFw8w0USssbvsG3IyOc0tSBVgrQX+1PaSPi6WLhAN/6mPAmmqEqGAfiJyTLTcc206Xnsk2KhbUBgK3Eg2SMYhgUtlMoQoJh89r2YWRka3f1cq2AwAlJ7FRbV42ifcQk+W7Er077xPQ4/DHTKsvzL6lh28S4vDU/pXrEiTPiKxjfxE9g==
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
 tools/testing/selftests/kvm/include/kvm_util.h        |  7 ++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c            | 19 +++++++++++--------
 .../selftests/kvm/x86/private_mem_conversions_test.c  |  2 +-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index f19383376ee8e..fb54694e6568b 100644
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
index 11da9b7546d03..ff301e7c22b2f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -979,12 +979,13 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
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
@@ -1056,8 +1057,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			u32 gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1078,13 +1077,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1144,7 +1147,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
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
2.54.0.545.g6539524ca2-goog



