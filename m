Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA7DCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C79D6B00B0; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014416B00B4; Fri, 22 May 2026 20:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEDB6B00B0; Fri, 22 May 2026 20:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A589F6B00B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75C6F4084A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
X-FDA: 84796772508.16.D6252C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92169100006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrTbq+gi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XusEh9OdVaAP96FZT3HPB2o9vrUQcgbC5L4tcWyRMK8=;
	b=u3BQy+7THGIygLgcD9n2nT4p6rgcK27nrbKKK7syPxAGm3IticjZze39Ocxtx6h0FKfORt
	B7jQC1wJHB3EvLFB4xZn+oktM54fTEx42gY5p0ee1W9QLbvv7aIoe0Et8BDM397pwVXCpl
	r7qolUsA0U+QXfMBBJhG9/JPFYDER04=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OrTbq+gi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495492; a=rsa-sha256;
	cv=none;
	b=Z9WA56xEEqHrbAxzVJdr2A+GbhDEQ07lSvMBz/4r60I7dOCZzli/7kR/+SV4IRRuw+6mUv
	gXjHgU47FRE9q3IgkzxZTViTKcJxoXjKg6CNqWCYoXyVYSHiXtz2Pfg49v4FEw9iETJpab
	PxWRkE/akei3rFy6dLGPxWLmLQMXSj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E99644706;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3904AC2BCFA;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=mgGYPVkk4Ny4behIVC+ZjLTIlWxLGy17rItOHuy4ICY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OrTbq+gi/tzBDiM5JJA3dm7dtmfNretL9vZ8sImKfkrPWqMNMOk2bwjiL8Xzvryir
	 d+8BFGpid4Jv4JERSCpD40ubHQjBBqlpQw47AZp5kT8a++2B/bWahMF4jRjh4WSQl1
	 ilh0AMp2QSFzh34XigIaaDNxtbtY8lxqB23oqYrlgRdFZldBuTCDlIn7TY3TUo/Jo0
	 TObuii3xkh1iLw9ZGLGSiL1qdU82mz11dcbhseUGvwyCQlf3fmD1PCeZ1qC/RLmjez
	 TTlXYKsuleU+yCMMrpYgmL8zDAzmNDgo06+mdfm9wl1WU7iYUrs6W37690emzj6Q0s
	 7c1d50o7Bct2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297EBCD5BBA;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:05 -0700
Subject: [PATCH v7 23/42] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-23-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=5001;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+eSSS7wmwPVP8BmDPgs3Jzyd3i7iwpHJN5gO7x6OCMc=;
 b=Q95aSFd3R820jeulPrbodqgqYqpY9/jBUpuB6WEdc++KgQ1a8JEyB8kfH0zNL3iS/E6fODrvW
 9IZO94aRSMJB38i0s9L0Iz2ZWgN0ozKaAZ+qoIXKkiA15OmVljlqhYq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92169100006
X-Stat-Signature: 56hb3ghk3r9tnciifkdn4gyxi4uywoyc
X-HE-Tag: 1779495492-717190
X-HE-Meta: U2FsdGVkX1/e/yRrZe2sRYcmrsgeaOumKfn/jdd3ObGGa0w/LFe1po4olhY2Ly4DlgCBpx1Usjz3cJ7P4+gp4agr3fExBb+KVhT3cTNsAwyjj2yYDEcgUSiMor80OldlrtFAztHOeR4PacDY0w1zJ1bK33FKMjaJqZBrJorY8UesgKMEVdDtsSXlOzjiHOrywPS2reBA+DZeXET/Y8ua1wnmtsyaTRqiV4GsNIRnteWWsy/2tnyJ/NpxoLPz7nIEMLiRGM3EZi1oORsYL4coUGJRZhj+zonecRk1vr/qKToOMb26PlQQlhL5G1RJDnnYuzT/fNStXU5jkLIpC0BC0jmxdsv3EnIDvpf7Ycb01gRco9IPK4ZKGsxB7c9xbluhYPeEOyBQdRU+JXKokAOLPU9XnJF5qROGgZU7QAcfdio0hXjup0CDdIPhsm+gUJxktCjFzoVeG4G5EwLSECZJ4qDuxHG0jn3EukSwstfo057PEIWX75SMYPnDfviGLquoA4smA1ty+Pzwu3QYWVDz07/gJL+eL1ZVQT1XIsU3X7jyoCNMtBsR5PDsD0hfiYv+yOv/+I3GfWoZbJCB+12tOzfFtznPbeQGT17gaMAlqk0QIqnzHJwgYTpLDV1OFbtJ+ljtae14cdDdYbHAHNCObikP6CbybpzRLBhXFjTj0NJ/Nmtnah3SGr2rYBFhHZC7Vp2wlSiGVXdk2z9yCrTEutty44fhrt0ztP5FS1lVC1fsz3EsLRE9xdRSKHdmpQMciRMugXkjpe0QHsC3KdOaP4JG3f58Up6nCM0TkZaA2dKsqTtHAyHqtzVuEWi5OXNwlvXTFRXg5L7f/Jw2UV+HkNZqe6jSz+Tuz5sFK2EGvj2qMAIbhNO6HvFAKBN0aXQ4uKH7OflZHuuUyRF3WAGFJ5fAafFM/C57b4FbnTVTpKuYLupTVtPAPFZzDxQMJigr4GPbtvvJXei1W+NEZwu
 3AB4I5ks
 qkUHmbkgp15JvXG5gQVST4jpELPMerfK8yUzTnKcWyQVi/tQ7BosMfEZ7CPilzzEgeYGNLkRAMTlfRYgTrlUjnMalkFum0YILu2HZRAP7Gsz7fleZkJSkeSy9POP+afEcA9YT5rtD5w1Yh/8rs0lBxTFtFgBar2zpXHU1JvmzR5pgzbzmtYadkoMfXQT7Wux0t/lZVt+O+CVDRuMccV9BaREa+btdnuRzGX5dDkB179dlzoMFR7+jUKv0gve4gQ47dxW4Pr8hWJpd43JkH6eCYOeKxZwxmMHqwehiq79taaRwlYzpp7kPlegQdoYdH0qfafXX59BJmSnMNdQHgcrY+09whdG/yPEosUiKVgjObZyQ+3E1ksOyYOPvXzEhTwefYkRmgNOCwJctkPvy5R2M/9IPkJ30Bnx6/gBwkqZISWYUvchowBuOByVx1BnPE2MCvOVJ9SUdiPvG1wUIzK+DCApc5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename local variables and function parameters for the guest memory file
descriptor and its offset to use a "gmem_" prefix instead of
"guest_memfd_".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c     | 26 +++++++++++++-------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2ecaaa0e99654..f19383376ee8e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -690,17 +690,17 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva);
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva,
-				u32 guest_memfd, u64 guest_memfd_offset);
+				u32 gmem_fd, u64 gmem_offset);
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset);
+				 u32 gmem_fd, u64 gmem_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd_fd, u64 guest_memfd_offset);
+		int gmem_fd, u64 gmem_offset);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index df73b23a4c66a..11da9b7546d03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -947,7 +947,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset)
+				 u32 gmem_fd, u64 gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -955,8 +955,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -966,10 +966,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva,
-				u32 guest_memfd, u64 guest_memfd_offset)
+				u32 gmem_fd, u64 gmem_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
-					       guest_memfd, guest_memfd_offset);
+					       gmem_fd, gmem_offset);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
 		    errno, strerror(errno));
@@ -979,7 +979,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd, u64 guest_memfd_offset)
+		int gmem_fd, u64 gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1055,12 +1055,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->mmap_size += alignment;
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			u32 guest_memfd_flags = 0;
+		if (gmem_fd < 0) {
+			u32 gmem_flags = 0;
 
-			TEST_ASSERT(!guest_memfd_offset,
+			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
 		} else {
 			/*
 			 * Install a unique fd for each memslot so that the fd
@@ -1068,11 +1068,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			 * needing to track if the fd is owned by the framework
 			 * or by the caller.
 			 */
-			guest_memfd = kvm_dup(guest_memfd);
+			gmem_fd = kvm_dup(gmem_fd);
 		}
 
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
+		region->region.guest_memfd = gmem_fd;
+		region->region.guest_memfd_offset = gmem_offset;
 	} else {
 		region->region.guest_memfd = -1;
 	}

-- 
2.54.0.794.g4f17f83d09-goog



