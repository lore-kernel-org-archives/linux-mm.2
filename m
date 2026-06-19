Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDA4CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34026B00B4; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C426B00B5; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA826B00B6; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8705E6B00B5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9CE3A02B3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:00 +0000 (UTC)
X-FDA: 84894784800.14.5EEAF4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F155FC0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOj5840G;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbqEGZ/4I42Mk2OJJY2MT5BntTlagTbnj/nZWzg3RVY=;
	b=VTyff+erKe7WHnoH9XMpW8GyZoqt3klNIiQqJMc98jpJypXHa9HJ+shaxl0Y7zTIuktoFZ
	0H3f9PwlKFXuQRc/b//8gVgRLLFf6WQ1PlkctMHX0PKY17wVu1S8EavV9OCGPVO4rABIGB
	pS5a5E3VZXMnuuAjI6INbOLU0lI8tbw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOj5840G;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829119;
	b=RH/xxf4v2NEDMa5SVpoWNh44hIjeFalf4UxC+X3SuigLKwg1kE0oIpY/87d2EMjTxD/pYQ
	Gp6LdqQ68fmYaz2vSJhQzjlh4BB1oamYzWzzVTAABz/7pK6WbpxV4HsPOv3a4El5JEPIQf
	f1mLgy7GbaO1oZZRx5ztFA8Q9c+WnAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3FF544CFF;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93482C2BCB0;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=7B6FkHwPlJ0RAxyvAsa42VYUqBJrtkgS1TcCciFUkp0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lOj5840GnRKy44JFDOMoFTqRW1hYjjlTzUaFgL9G3M8vWwU8WXDfu6H5SaABWrbiu
	 IvJqsU/bNLpOrbtHLyISjR5cEJLAjxKYPd7CeaB/xFtRA+uXgLkA2aSq/xjhO6zMzB
	 km4pjV9EKkOHaVFNto8Sl217ohUE1agD91wQ/TthYfk5hdWSiO68pmifCr33/AYhCx
	 aVYNl2JYFRA4sK0wdyYimZOjhDGom/UAeutYPaI5sVrywzNd/zvqXabZNrXDLm1Ovq
	 r5M1srdIgLtzXB+z0y2Y3BQXB2MLdiSgFdyjuxMvwvobzD+ObQ3KKeTClgIaMZ6pRb
	 tFtN9FVk2Hc5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F84CD98FA;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:04 -0700
Subject: [PATCH v8 27/46] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-27-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=5005;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xayPga442mYYJH9FILJ6uO7pkcC7R4Qq8H6TxlAL1KQ=;
 b=i9GHlITsRr1ylmhuC7zoE2/9SYRdox0taL/Dr8BuFcZoHlE26moEFPry7DsKGhBnWS14enYqM
 zqSHIaPtdzfB/qmJzCRoQsU5lg1eQ8U1T5mePJtsErxB07F9AAVAZ2o
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F155FC0003
X-Rspam-User: 
X-Stat-Signature: twqcy6wjgajhgci6gxantwpko5acgmeu
X-HE-Tag: 1781829118-947369
X-HE-Meta: U2FsdGVkX19iaBTjAGHcSnftmR/tmZaULI6fxiHo5lqXkHyR9hUVicL3WEZUJrncIibGfoxKgS13Wwe/RXfS85uIh8ewHBC/4503MJbLHLr6bWhnr6wuLwB0RHTxW6LKFkyhfvPbUhbDxvpdPTrkQ7PBEcxdERsJFsVDaftRvh25khxeD29lMILj8w8eqkb9tjncfWw6lxLgauHeFnab/lvHpViVMAqo9efqgY+gLElppemU0W//fZli08HVMXqdMCpBEvViZJJhT16QuPROqpE0B8IdpIEl36YEPu86uORX5UY0cDAHLU+twNzayZsVjdX2WP6Uq6g54WSHd3py7xIsJqbj0MXaD23BbTAUN+5NVzgKY0b6+E/QrA3KmbpahJ2bxsz5aXWxkbVfW0jne/UuIFT8+J8l6/ojHMO8WlNqTMj1D3hNVlbXIZw9sFltI14x6mSw5+RB+GhlHxuy3M2g/7TaVenDtmLO0YXTjToGflwleVS9JIyAF38sgcg/Lhs1hDe4GyZ26vPn4ZU6hLBizBAT3nUOvrobNA9jimfN0f0SdcQu7+DcY71J/55Q7ZPmPpcu+N/5Rq7JqkvhCDAPIEUxbifhug9ZzSq616Sc2QZidG49VZ3Fe1fVhtnDABbQV9g2iyfqWFuBNxzPYLbeiWXlG0U+o/f89Ul2JolZcg5RtrsTgpmx8Bu4yEY8VcSYB5UjkizZt7S6lpNzJRcQ6h+GSfyx3l68zB1xPw1F77cDah6hCcsHI6CyaZJeXMmW/35tObS34zpbemD/Wih+DZObHmyOdrP07XA16HTW4oQHsXSYpATx2Xs3isUnX24qPIbQp/4/uPB0O8rbj5GTsTtGUuEtn7G5U6FWSx71lobzJTsAmmBxQLLF7FGAQMPzDPK4bWlMq4iruazRxS9fwvMRJcD22BQlJhk1jmBm5AdUVcemxNsIQ/WpKZcogNDoAzSIGty/nr7RtHQ
 BDcTcKRZ
 lm47iWed22BSqKGvrdl/Vvub6LaJYhX/8YL8DjUNU1yjQXkYqe9+1zJeGPHTxADKlBnrV+PQ9iW7w9EN2vzpVQFzSbLlTxmqcKznry8bLK24UxgN/dEDerHOPZbTD5FWzfSSHERWQBBTL78WwoZThZ8rUHBx0a6TS5x2B8W+pL6wo33CcKEkOd/8OoKL8K5Tc5FHFmcmEAxkRSmHNK1hZOlegRicnt4qiUgt7uZ+GkjKmZBYR2fh425fDfWyhe4QCQRT2L+gVs3WASbsG0HsmTjhwxlcKbzhMQMtPDWH/SekPnTE52+U5OEB/yoRxQw/YaflIcwcLHarHHiNsPRQ9oWGdhKZqR5iOCA2qB7t+yfzNM1xe2zAhu9rA2TffbZPt/UfRsg9pzS5tW7TpHdymP7DXeP5IbW87cUdY7wN7vfcPz1hpW7k7XX52MRV6GEeOTYvtvZ0BbQvK6pCrnipQ8tYC26mppLWZT/lko0JafdpIyy5xlEJEkkYLJQ==
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
index 04a910164a296..d4c104cb0418f 100644
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
index 2dd87c903ede6..9b482778f7379 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -946,7 +946,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset)
+				 u32 gmem_fd, u64 gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -954,8 +954,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -965,10 +965,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
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
@@ -978,7 +978,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd, u64 guest_memfd_offset)
+		int gmem_fd, u64 gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1054,12 +1054,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1067,11 +1067,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



