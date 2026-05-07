Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F926CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9476B00AC; Thu,  7 May 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0E56B00AD; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D411F6B00AE; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B93406B00AC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 863C6A060A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:02 +0000 (UTC)
X-FDA: 84741747804.03.27FBCBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B289100007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAJgK7Iw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185380;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3z3reUtwjcFnn+QwaUYEDncJTewJViEdjanf5O3Sp4I=;
	b=GIh2ZAjaTI3eWjg+JNjUQs4nXw2qSD4ZT70g7cqfOKvCgc85MDqRvf261q+UrjDnTub+0O
	ahfGZBv6ClN2wgV3IFwnBBWZsvAK1KujwfvXfIRNwxpTmHxODLdAzsPiCq+ienSSgcsSNP
	cBnEE7fMAEMiHPSe0y5GvEieOuqmVMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185380; a=rsa-sha256;
	cv=none;
	b=4lbt0JFSOfPQOHilTBKFXGS2zNaBe7LfifxmqLVU4OMhH/JZc/xb0VeKn3A49QSFQmhXcj
	ZN6JdasD/eUGzpvz5yrudDUhYtsIHJjAYgFoSMnptUr922NA5FcPVvwPJ+BPM3CDIUrhTq
	u3chmKvcVsG1fkfZS/dg5qfrXHE+tig=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAJgK7Iw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C949444577;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 855E8C4AF0F;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=SfL6x644Fi5cszrJSTJMTrMgTC3Z9VCFM62yNpfqexA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OAJgK7Iwwy8V/ExhPurG1XvRUApkze0QmsPysuj7gEWWqd1xS2Tf55hHBQxDwhgqY
	 g9wZJ49CoQwGiD9pe5B1aIKR2i9yv8Ku+LSuRqjeB0/d23dd9GsxpUxix1npIEHuep
	 AyJckUgJVIEyZaUwV9FE1UcoJ0hG3PLl7COdfknwnAgI7Me8g8ffNlghxWJpSH9Beo
	 UYIm2QYbkCGtgZANNYcfFzCe9kmFl12nTZ409OEAVkofY8XGW1f5S40ooiyTdAemZg
	 ULWM/2oOhStmWpPoarr8oJOO3sU41TmApuNawjln+N1OYzV2jpv/qjXtWSnDvq1Sxq
	 7Pkw7TMss5UTw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF65CD343F;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:43 -0700
Subject: [PATCH v6 24/43] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-24-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=4957;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6daczBfc/gZgtlui3Ra7hIOZCf8xQ9U//k9SGcHhlv4=;
 b=RfK0qTe+5PrGgx2iOtb2FTdbPAOrswCr+92BGCgqIosAbbSKGHAnRIl+9QUqVQ5+UShmHof+4
 VTzBkeN2w23CPQ9B6Nz8HAB7OHzn+yVwYnXxUd0e26wEH0NwAQzMCwX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B289100007
X-Stat-Signature: xdcenid59p8y4hdp6f434chymesoy9oq
X-Rspam-User: 
X-HE-Tag: 1778185380-564378
X-HE-Meta: U2FsdGVkX1/LK4kET4VfkN3HYyyWQEH8aSOY3mOFAzLken7W/aMXCuiWKJrI6hT9JhTHyIWrXlflzK59CkOCAkks9lRSskZe6le0BWY6lf3GvFuGNCnA0EZjHsEDgm/wUjsCCRxzsYqqmMK02wZF7TADWNNDRH03oPStf199qVWJ7SH8NHbqM656GsyVMpxqNLvdL5MSCFpMmlSP4wjQ2KffOhJqsMBFq6Qh+s6Rs5RPyM8Rlfil+whJFGLNzj6lDx3a6+BB3gTaXKaEw3+Xl6ZYwLJ+dKwAe2exSVHevKLLwzVv5NVp7oIQYQ8UNao8LW3iPENaf2tX414sHjr17E6NTDRKP6YwsDo094UUrYSmzuhZGZ99Yc/uQroy0V89B4HdvnpKyoZdtscHWhQGi7Q1eDomoNYyl2N9PKeHz5JhVHeofgVWqo38Rvxa4ax52w8GCaMEBcpym0Nn6/8M+7jIs30VwYDOlHhfifQvPRtm4MrBCboeJ/sWnsqurVwAwvTTOJ05KF6AwtcCIehvR2ecoLMyuGQsBfMMeGWjSmlJtFUHtm6f0c1lylQAsveeAZwN/s3ynBe9vAXdG1otnIJrcNyhONAZu+DvOzkXc+sujpy6OGCQ70ev+29pPTXr56Zg1hcrsIDWG7rIvz6jZBjyuQ+9DObINIZ4CQVZvdcfpremDqlu1j++dHEBcHVdJ+3DNqjJeC13WjbYiVgjSVcqqjZPvIBycYufryuaZYVxD7YFpyqtTcy3/xx723ipioU91uce9R+oQdKBISZoWwTIjcO9ZsZTGkG85eIHndPj3pQg0BJwN6BwIjjooEd8V40ALL2DPqtueM7xRKy6ZKXjfXH3QFYXlnbdD5qeZToY7291zxyxtVy6OIEoe+2wjOQmBDt5+j8RCmxAAP/VbKppBTTo9cBPDAoAwgbaU/cbC4ZQwaHANGdMn58HJ6fSZILCjMTRbJUw/0NFWVp
 SbutksjM
 HdeYTENXYjAJLDJnlVYNNO5csyaeYijg0VOXvjfMBEliKZlkYCqhGIkEZfxkYOn0biwCmG9IX0ZJ+ORBGNhvTtHgaOFemgXba5S6FAaBvvcRe2lQG13Xs9dFYSnzWYkdCmUnB6YzYfh7PhMqjQxAp1f2t/Wlc34D4tgSTdQIHkCF1zZ7cee8+OMRpdzxnTcl5UQ9O7Q7mBwj9CQBVQPB85gfV/a+iUtBZldMBKLjBBpSGRWPuW6aAFXpUr97V3yKMpqLZ20lwwRd7I9ysihTIxHbIsk98wEJph/6wZdov0K9K5FEYoV17b4sjCuNQst65GzeyrJGZ+hnA1GSoz9U0W3kg8vr3UZliJRnmiZ/6tC150ou9FBumiyCR6mXlpVK+N9vUJYhtdqrDQnGhy75Z0priKnZFbXJGYy8jISHSx12/Xhc59mxDweZm+DiBXxLcN7lQxh2brEoyTivp2gvHSNrp2Q==
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
2.54.0.563.g4f69b47b94-goog



