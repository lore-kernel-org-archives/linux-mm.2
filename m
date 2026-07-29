Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92EEFC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452886B00A6; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3658D6B00A3; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BA66B00A1; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5CB6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21EFC160584
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
X-FDA: 85039944948.07.1065BB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3207B1C0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F7Uwlqll;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9CGe3cAa2gt//kQolPe/qP099hk0qPsyzhYRoNhYSk=;
	b=RrNQADYtBpFuprtB6HM+Mzb4b1EaIW4FK+gTlaw3JbkmM6U5vHgRYwAk8jBNFPszqoJ5Ku
	PwQcVhpqP3o+Qb907EGe7FQ3GF6o3FxDsQfHkcvtGU9XeUYTvn/ONFe/AE7IQa44a3SeZF
	YHdkxdUtQBy3l6dXEX/AoERfTmR7S7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285312;
	b=ujjnfnSGLDrkQN4uAoibidRBl6C9K8iJTGpxhRrFsjQBK4Z2O08WyGa23TUI24m/lqilCQ
	k01I9UrFn2PRtm+awaPPuODS6unoVeSKc8wWvl27OHJVETdfpYxayAabBP+1ri7dG2W2ak
	9yVZ7XNn5HQV//hqFTLhCEK/r62WPcY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F7Uwlqll;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FE0760DDF;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1FBBC4DE00;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=e1jNe5P2YlIwATuQsrfeIJFqCltIjzi5jdDHrR9bdlQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F7UwlqllGcROCG8sdc6vgSvxGwbI1lAvGxo3qMPA1wlvOB8E/OuHce4g9tm0VNX8y
	 hSyolsCJyGEghZ1vcxUKxJh8/9kLjs8yVYL+echLwR8WCyTJBsBBxRF5ZHj6G3H/KX
	 PCIgHxMfoNCGpdbFFgaHJzGnRTQf+VfSXNsPGlkUF0KMyGvtztCMlzO5KVnoTV3A4K
	 afzOVs5w+RJOsEIwOYVCTRP+cevzQYc2fVlSNHI3HM/vn14wQdIRUwg4n1n75l1sut
	 0ZJmK6qwOYaJfD25Y2y5QZS5Ip6Gd8rtBDVTdoS6QvandhArKyrCmLrRYVuYzi8aPJ
	 n60d7FlCigHig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCADC53219;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:22 -0700
Subject: [PATCH v9 23/41] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-23-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5047;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Qw/MaduGzQhmOcEIXes0uUifLmIqgQRHQDowC/ivx2A=;
 b=HiOnOiaNC2UuknndyO5zS+zgrUb1VMS+GbCRUwUDYMN2YyRESLCpAq11FFXW5zEJVJmODFHAU
 wp7ka4fk574DC0UrEt6XaHwjOg3Rq6PZ80Iox3wgckxat12qUbYjEzr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3207B1C0006
X-Stat-Signature: p8g441ptxqxi43ymgo6ihjb6sf9e7b4b
X-Rspam-User: 
X-HE-Tag: 1785285312-43228
X-HE-Meta: U2FsdGVkX18uzjxpQHhBmhkh83OoiY3UfNgTQfSwz5Dt1+Zam5pC2RbviHLlkOLXXlK+YlZpDlDpM23xsdr20j2aF4SbhWXIA70Phm/JYCSpvluPBuioM7uvTUcpIJ9z34v41J+X+g66P8qZRO1ueDB57s0BS2dxMzC9oppjopVzNCaeZfpm1P18X8OoK543ewEF4FllYNj6dE55nL12tiMMXhcbMVar5g+dckPKzPK53qF8H+azKgjTFGnPRAgL6YmiUPlDQozHYu0vuoB2mXAPldrEYzI0YXkTXF2mCsCyvucbJ53epn5T8Pi3d5wdeipSIztqhK4yyTK0QpcoDUgg1wavWQXgThy40qHmSM6haP6l5MCnS9IbeyVoye75NCwyWxnShMuxEFfBA1F/ItJGxEDXYJxBON9MPj2Rns1Q1PBm2rz5IQ5KjmPf0J4LotOtmPZi8ZBWhKY9q9CVGjZtrd0L5PL1lhbFCDol4Wlo9TFBMl06I9Riy2VCk21Eg3vbrhLsOX44IhUU+jkTzmU/l8dGhQ3REXn7SL1255gxaccZ4KiNHaPOHDZw8ZQFYyYQOhipEt37Fpbl3uCtKru5iuzWDRpfb8EvmsmFicSdivaUxdMt3MQotX8dHyUr9TNV0tANGkYbQzaTmRfiIGCTXKq/yv1tcm+pt1oHTNo+XJipplfLDMhjhwfb4+UiNlsANphtlUIO5/+tx4jnLj9kDbmD4kHTDOBXeC69hXx0FruI575QGVHPSSLhIebGcZn4XX8Y6zcsRSfxrh8UUKxC82wEyaWSQ5g4yWpaypAT/EL2S8hCFaYeJvuVY+7m5k185rcQ2s/sqm2jG/g/eQrsJrxVZT+JHsdzX/qMWUkFKOZ5DxN1Ashlg1kkW+jMWg0vUeakILARo0xkxCJLTtHEsfgp/4i9gbGLxqb4ESVQzO9KZElBMZQO2PeMx7zLAhzsd6AUNEUyip5dUNc
 GGc7V0Jo
 B7fSvQQ3nsK7d5N3wB59LMOgjG/tkrHzI9brcq+HeUreJPJaqgloQsNIwy69eVJuQ76H3W+T7YbHpByb/8PhU+NHmc9RaFpm3Zpcrn6KsZc2JfodQDHdOHiAQyU1wF0ChFuwFtvc4hkxCWQ0hjMDu7RIyma8/w3eBGn9YZ9hNiMtys+hpAQwXIbZAGTQmL9WjQykDTJh4lze8YrdPvHTQqnUkyZSvBn8YebGALJgzAh/HV3ac6eeGW6JnGwESEbJ2rJRt0f990dWQ8voBbyDROjAoB8n1E6ag9EiGUSnggLunx/v4R8LfNiQXL1tof7QFeYbulb6mC58jUl5UR1UViqMwmBR9rXsgQk7OheW8VKYAeng9citdmeqAN5nrvTlPJidIOkbB+ef7HRXfn78D2NrqQ/UpU/jXMm6PfLK+JVGpSwz0WgFd3lRU5071ZoTEkGTE2YRkmWacSAkKnTwgjKHWATQmnarLjddCIf5EpwmDYB1I4lFTDpbUh1qmB73rNoWuLJPgyXq7KKxIvb5JcxHOo0TmRVIzbkI5txuHvCtgIaEfBzoOARrWdQ==
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
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c     | 26 +++++++++++++-------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index b39e713c30a46..5adad5d4e9cd6 100644
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
index 8522511c99558..57512c9ed579d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -972,7 +972,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset)
+				 u32 gmem_fd, u64 gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -980,8 +980,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -991,10 +991,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
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
@@ -1004,7 +1004,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd, u64 guest_memfd_offset)
+		int gmem_fd, u64 gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1080,12 +1080,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1093,11 +1093,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
2.55.0.508.g3f0d502094-goog



