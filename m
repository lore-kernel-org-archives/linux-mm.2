Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E030FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846026B00AB; Tue, 28 Apr 2026 19:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DB86B00AD; Tue, 28 Apr 2026 19:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7333B6B00AF; Tue, 28 Apr 2026 19:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61F956B00AB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56BB31C0EE8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:35 +0000 (UTC)
X-FDA: 84709548630.21.EFB30E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 359E340002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jd9eHhBG;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418733;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fx8a0eC2sYzZ+YS8gbIjfW11iJPXljDQ1VOVsh6s6e4=;
	b=3v/IkJne5+qeNn+BFp6XOqHW3hQ7UeADgBXrXLuP8LILQx2HfseIEBlal5QUhwTszUb1+u
	uSR+8bvJ9xEgK394gVXZFmUiYh48AWs2VeL5EEECZeYu4V1dNVJlcAbRm1zcvbSQucmQy+
	QNzMa0YGFkP/CJujiR0qYpNSGg8/7BM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jd9eHhBG;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418733; a=rsa-sha256;
	cv=none;
	b=0pRH5tr+YfgAbn5bEVDLI9uinvvj+wvbqSXTwqZLbeY1KccOdLq1scAz+LRzXW8zv7Duct
	dO60StgppCLw8wj3/EnrrU5aJ3AMNytw5jxhKtkf/9hKk0tecE4x6Ac65dA3g3f2JfNUlr
	8A+ffwC4i3sTj6IznQOr07huAiPlyhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12BFF44A88;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD445C4AF1A;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=yexdFTEVv+31wQtvzDvKuoWyweqmVlE/A5ffXV/oVKM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jd9eHhBGG9P76cOcIzUgEGQ9UJ0wGfPk/RLEXiD1U+PvjyVgIZYtwQbUoYbeg6rqP
	 8i567fDXh/ea8HxeKj6m4GtSlRGIEusj4p8cyIk4ijJtMVcNXs8JlIAbdzwiuJMIaD
	 p/g6hkjUKhoPPdU47H/7SH5RtUmYQ0XJKdiyfqo+dkUspt+ePTb4rtqF9stpkGwDZj
	 M1PGsUG8lOwdyqTWdYQtctIxJEr51RPwJfFoI80ywz9NgekuuIbaf4h9U/RmfdheNT
	 /CjO27qvnAH/4ss2RiDW9czDu1U5g3X9Ubj9OcMQN7rZtOxKJdrJe6nShf9haQPIgQ
	 3KeeaDrugq/XQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B264CFF887E;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:25 -0700
Subject: [PATCH RFC v5 30/53] KVM: selftests: Rename guest_memfd{,_offset}
 to gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-30-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=4957;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ky/Djb4z6u0gPC8eEsebTUyxChuRf79nsfBVLue2KhY=;
 b=DClKgGB5DXNYnlQTxOI+voCiqTvsj8S8byo1LQy9IRVlRzdSlTL2OVu97+F0n4whjqi9yS2sL
 9MLZVcRHgPLCM6a/AXz9qu4i1CCXZKWFxxM7KVeGayOBirO8ORDwLYK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: t91da6zdbz6wpzygsiiqtw4q65yrgode
X-Rspamd-Queue-Id: 359E340002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418733-391421
X-HE-Meta: U2FsdGVkX1985qkKu47+aClwXQgpvXrzqdtdPTxTbaa/vvI/6f1JaJBKeprsy7wG58bRL4OKWcqP1R/+QgcT0BwFrlYjNmk2v/6I+tNV4PZh6jZb5pU7sAb24pW4ICzVX5hTKMUIbjN5mCOpm025rAZW2Yt9MqaxNeQ/aTeLHwkfxRGdwBQYAZ2k6HvuuqvsYu6mokVa1LKZezerwaia4KMDpK7tQPPgqcKX36IzOeHGviXFqUST01fC8E8Fjdix/3O40Spl9/KI9pX3wKH5bpV6HhUlqg6Bb2qICinS1Zu6qmj3i7HQGsTM5vwirpKFAvn1GK0SetRjqIGM7KckbC7ZYRDtqZ8fmsuoD//nRqu6r7pbAbmxizn7v0eb1mU7KAsBH76ICx25hhyk6kB9vGerpM0TYG+qieVxFi/qP6MJ/IDaiQVyk/SVsaWxEa7zQ6lmpuUhJNz4gvP9SIinmbbWEq0PCzc8SRBm8sEJT20WRqTLwRBhJMKc96MSW5QAkKuhFy0RN4uwhXWnY6oEdsDOEJCN59JedkEgD5YNTCn/dG7gTnvE5vvJ0+Ed/p7Osp99N2mxgLstxGVoEgxviYNtnOKy3SJkyLgjzxJ3mEBs9DfA1RSADHmH//+6HuKYSf0xgidvZGvxpbX05x3qOFBjI2b61WwG8b8bEd9B7/HzNhuck0Fj5rbGOefZa9FcKxIZpbqAkUL30PvaO0xdn53xpl8GZ8J062RplOI8pO+3W4ag7j2xzT+tz/laEJpUtT8B8EqSdtn7oLrwnH6SpFARbHWJnOFP/k3bw9GJahhD28+UlYFsv8oZbST/YYZ+Jf///mvbJDMMgDnvhxKtrM1G3QERmJGVM3ktfxMYWzYeRy9l5L38djM6FWwwIE1TdJlRMd95yXVyhQapnxJKhxKQMgaYeR/rnpLl/cdVyeOX05w8/NWfmSzSb68hmL2Zji/dDu4CN8CWEg1HQkw
 s6102+ie
 Is1VbFJYn8dwTJAWgGdgPefF9MvZZeoRvRQWJxu0Nee025rRJGxyBHMPz1ZY4BHv4b4RUmwL8Ll7UKL5xp+W0kPZ5MhMGr2glMkOjeMOdzZQxiLK4ML+jD3prHKvhKBzxPwTajf6l5aCiomYH0J07ZF6J+yjxx9fG3A5K6NR/kYx9ikcFR0Xhii3vybHIxUzUnlQrvKQRW4XN6YYZnYUOUsa3+ZhFVvZzLt0DEJnjKgDF4AtXtD8aB0LzlMNsVOh3vBP4x/obMq+hrFXYCKnBw1A3ZPneiH/4oV/c7IEdK9wuNiDrnl4NTfvPVEOcEXoJy61EFkN7UX0AUT8QJIJJwW7RUHwBEpMA1tfcGnzuFvlr7/2HQAW1eEvrO0RvlQItk56glACtoSRCT7ueGKzu0mZrl19oogiiRSctcFkhwJbO+/sE66j/SxJKwqv8+2yeUYd/fywmErn/6+yL/Jxp8XnZgw==
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
2.54.0.545.g6539524ca2-goog



