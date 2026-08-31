Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3716EC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F396B00B4; Sun, 30 Aug 2026 20:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22266B00B6; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10896B00B5; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADE366B00B3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38FE81403C1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:36 +0000 (UTC)
X-FDA: 85159671072.16.5611123
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42E92A0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bSe4BTN/";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135934;
	b=eRe+F4AXuWuxkhjDVlySSVMTC2FivTu+aTbuTMDFRJtYMO1MirpcB/FCzf0NYm43kkj2S0
	n1qSpk4+s0picTfdww1IoraD0WzrT/LSQ11C6A1tJURf9qnq//CuBgxna1OwUttqyG4B+s
	59JPxCxkiAMgc4MySyR1K0mZzwDHUJ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135934;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2neWs9Cjsj4PX3k0IEn7OzejFObDHyq1LYAZkRkkrUY=;
	b=pG3XGpaCmn9oM7wpJ5K3el3Dqpk6gMcK3yWkCEqzljbU8J5ZZNRgwtmdKrpqQMefJ3Ee2L
	FXxQ8DkCXsQkbxCL3nf2f3OH88lngqo2/+bi8HKcd/9sl/L/N3Z1siGEqZabF7azm2qAE6
	U3echL8mPBQGkE8DYSmoGfmWFWGhYd8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bSe4BTN/";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6103343FDE;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39DD7C2BCC7;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=M3bGP8eN2EkZz+TH6F9ZZ7lnZVDiPkWGy0QRvi56dQk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bSe4BTN/UUC6U8zw2icNXCdGw6WWu+oDjPpgVDbsEgXIt1DkfwIZL8QxDdjh5gjgI
	 2gxsvm8rK6ud1BrYk87CnxAcyzN/QvNTy/S+zLvmXXDqDJEiC/+jvacDkNQo3J1x49
	 Hi5fhAuQLFgly7WHMAU0qBwDfy0XSWp0JjTGfBN9Aki9uGrrcwVDtM7/XvpEQYO+pt
	 lKWGKSX4mJ8fPWkAMdebho7fhH3qD+xzhHm4EUxKLVg+MHGhIX5R8VFwUQQT11zE7z
	 LJsWvzBV3lI5rf62K7tN0lIatAQHjfb03o+vpMrm3TW2VqmHb+fsm1TEb6Ne8z8u4z
	 Gq/frVhKC4ptQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2465EC61DE4;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:27 -0700
Subject: [PATCH v12 26/45] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-26-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=5047;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=CnemoPfuFdaUvSMt9CmQCu9n5JepQ0i6fFu3iUOfF5I=;
 b=ImO7KsNUAOvVm4KzayHLnGzn1IPUTQrDIoBwwQmwHLMBTZ4gPEZFQmcuIh7SHUEbdn8uyQ4H2
 6IUvtQf8AROAHmfLddoKJqpsR3tPXdFyG52/+m+vjDnE4tf3wKqsLW/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 42E92A0002
X-Stat-Signature: 1ek3usphdrgndcgnicommagc5ph4uy36
X-HE-Tag: 1788135934-357257
X-HE-Meta: U2FsdGVkX1977QS4VJmEFnSYO/mwQuGs9ziTYcpiM8zcOfmBiirEmoSsFdP7zJRuhcBLtscz9Ek5A7UqqH3Q71JWo0mYedoFXYaNYpQbKyQtQKP1hN32dJ2O/q4Dr8TQomcDsDw/B+Ek+UC5MuPiL4xZdA6sX6pG/DLUoTwSNctizTqfkZd9mEjiC4bxLbtd+Kkhfrk6vohKuIJLlxtVjQXt9mPJNewpQessj9QSputmaiypexLY02rqi1RgqNJtSPIRsD6rHvBLe8B3pfdU5Bp0q/gaqgJpKMjtACmcId8QxjLQeR9l2bB2Vl9pRsVMHdmAJ6NmlwK1CHZ0UnV8MwFhoDUwIlg8rVJeniLrplAeQSWKngyzon+SVkULWxhcgy9yZ3X7KBQd0ixR7+YJkg2NXtr5oAO9q3qm3U9198BSq3+/n7nxwBC6lLUXlkavCdndhcehRRDW7E3wOyhYi5He4z8/1XdJHF2SM2ZUus5ILp9m5boW0JlmQZ3cfcMGUzUDqnQ/Ho6mLM5+s+19SHBLFPWLdPqqgOlR0uuZbgV6M3m+UURAgbhSB72v1glVSqTIQQRsJ1N33Lm/KkbU6VhQ+Go1ayoKT7XtAtdPaHFiiNqSuDny4edYEP/iFl8AgtLV9x8v9Fi/LSBWyNOyrUHamBYQdf+6YVkqVpo6qLJX/R/TGi4aXLwJGkZ5RGHNSoqQ94nwZFxuktEIrFbOp/PV/oTdzkczQMAdp6HNq0zZbQJm3kF41J6kRdFJY1Z/W2M/E7QfuzsbRB/sUCQZsCxs3fwscxVifTye4khLYqadSpvwoVU3iM4hjk/1QoZAPAE6MfRWlrKWlSJ24GXkohWf2x0mTANX0d5Vpx6qJu4cKwDRx4OvWG+jyXqvcP10a9L4W47jZ4T1nArm72mllUN6VYDocwCirQLOHow1KBLkWfMrafiYEQifdTfH4Fm1mGtNhDrPSycBh7ba40r
 Qpi2Xjh4
 YZJuHkRtH5iyv9JDZ1tmMokcDissQz1lWame4ztEcODkKlP6fg0Yv/Z+I5uvdNigQP2Au5RcOX7UwGq/LePBo/7ozy6mYxKYJAVw0mqGtmCkxVrlwXafyOA/bpJckny70490LNcg9LLALQUnWkk+xXN4bgiUXpUzZtJqXhrc9LbNp66gLw6MlZivMzc4deUM0IpwOMbIiMrmv9PYpWaJX5IPRCqFioDO+xnXTN2LH2Q/apCaA4KL8R2MRHwusrX/w1oSed6Jt9eCQrZAJteAHBd5oJS6DpmVma3Lh8q12rGuXNmTbUx3ijAZQ8TYfZm+Y92ZFxprSUYAZvzl6D/Y7mD590YeS+6f4Y7Obu4U3UvHVnK9tDT3vpA1v0TSywt9Nd3hzC8luf9+9wAYQlyJ0ElXKJhmRdb/logsu8LPu+Ys3WpvqtBf2b21MH6Iau9VR8mBuNk4EG/FhXhq8MG1rpvcsGGD+dYFTlT6VwnvVbKVw8k0izRmz0le7XUywNgiGIVLmJ5tyAWIYvLr3SfWbMRdLAw==
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
index 5a7a455b53875..cf49a84de02e8 100644
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
index 3413d45e34faf..af501a27211a2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -970,7 +970,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset)
+				 u32 gmem_fd, u64 gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -978,8 +978,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -989,10 +989,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
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
@@ -1002,7 +1002,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd, u64 guest_memfd_offset)
+		int gmem_fd, u64 gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1078,12 +1078,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1091,11 +1091,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
2.55.0.897.gb25b4bd76c-goog



