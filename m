Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F50C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3386B00C7; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C8B6B00C8; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B476B00C9; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC3D66B00C8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B59D1A0632
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:50 +0000 (UTC)
X-FDA: 85199512860.12.1507D53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F6FF1C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s79bPsSn;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084548;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqOIM1tuojFE51AxJlC+GDIO3dAd3dmQ8/3PvMoeUJY=;
	b=knD3vy22bcVDZg2WNqyRs5RmyfrLs088ORlExcICNWdMP69sXmLUejPKr90rmVA4c3GhWV
	UE9WQqUamSU3UruudxfW1PhcF8wf+HwK+fgYN34aTWdfOeyD9uyq1EP6PD2O0V0eIXvIw9
	2O5ioQXZBcHpahO5lcaHNJbzUFuoUzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084548;
	b=oU6rKER6UThT1pNvijTCxvrbtRjvA5stjvDowkuKY3+/n/7DSWi2hFJBFg+28jK6dSXuXd
	hoIM9px9TMY3H7jBYIClpkcJXWW433vXA7OOOZ/76lEQJKPE9C9kK9HcT0P80UCFGmt2om
	MiZoR8sxkSZn5LhaGSLhmpEQTmugiKE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s79bPsSn;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68AD7448F9;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FA91C2BCFD;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=jk1LanJjrko9+DRZ9uXvKjbkkmM3bdKeA1IL7qQc0gc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s79bPsSnDE6MzflWYCF67EGgJ+LAi2Ad+GMZHe+wU0Mt+FKRWMWVzSlh8z2Kzosss
	 ASPFQkf3zIHgQEflx/cMYx4zdgy07RkYAw3c/oI5wIreCy0QaGaidjhjjTbHjw56lv
	 ZoahOjCXl7GwDsTOU0q2G4LZ0tCDOZbszFGNJ+MaxqM7QsfqtYsNsvFIp/jZ7+TvUa
	 ESZdmhbTGsCNV9Dd2t5YqV2IDzc2hMyzk1WI9KL0ZlEZtROXUrRgXiuDKYScvUW11h
	 abW6Ges628YViWKMcRutzZsBkQgZ2jj8S8+w9YvEogH46isJ6yvK7HJLJXn4TLArNz
	 88QVw5OwyMNSw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27ACCC88E41;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:51 -0700
Subject: [PATCH v13 25/44] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-25-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5048;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PuKR62AgtIL/OgppZyqUKkCf7z3QM7wFLt7eBK4n464=;
 b=zdD6arnW0KJmJy9TLSGNEKNQNEmzt27arSC2EDcx3IQ8D+gJ3ahPRQY/OTZlGPNTnPd9QnnAF
 0V2hQ9tA7W/AAYZBQTrf7iOAO6qNfc91wCbK07JtT2YKiVVorb8B1AB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ask1gotjoxcbb1j1odsjmujeaicgkgnm
X-Rspamd-Queue-Id: 2F6FF1C0004
X-HE-Tag: 1789084548-347041
X-HE-Meta: U2FsdGVkX182ysYBslhQTv/TY49vwf8xfXN7lCq+9uJXXnNk1z4uZRm/t2sPd4aYS+F1dFseTsr1XYPGO0A18L0brZ5ksIqBGgH/No4BduGFsr4dCal1TDigqQew0GOD9HlTJ1qQzzIzpSBI1bVT3TxzbkcWln2YXWMDjkFgS9yIH/40bFAsDgBpph6hxdHEo6v8ClNrplVQi/Nrmh8OjOzo4fZlapIOFfEfV+Wlqx4XLl0vC3tEIx/PELcYt2vEovSp3VBFoyeMNepwWvl+6rBfBp8iy60R0qSWDQ483Ip0C14ZIdC3Jer5bq/OzOO1W7UGUcEJIbrTIe87QGFFMRA+/Dl8+WE6crBykwmlfrNwwLOX8TfvulfEX0dxeE1lLj/qGuJqqq6ZXFMT9xgV3L+wg0i5NaxLG5qO3dhpNOVKn8XVc9a3Scyc4w7ER+Sd+1KZLcMhc84MpnB5dN844bWd5rQvFmftspu1jafdDAbeiWlGbtZJECmU1TA6ZlxMaJFfUGBgBXkpTx1DFZJTZfC7dCWkeVEpRUd48fGex0OHqZaec7jhc5/EPs3VAciWSjHbhDrdvIfKr3Gx6tRyN6JVXXrrCkVr5tsLDgE+Nlc8/lx+TfQwmQ22Vky0O1anE7ikOHEY5C6Y6jB/8E1i828ew8lo6tL0olo15qmK/UC0BaISgyPjio5uwQwSmYv6+sZjK9QJMU+z0GpI5nkEhuLSqAgaEndY1cOwNbHX6Uj++B/Prez25wKiEViEXhD473GH5b4j7NHAKAwG6hc+sRUne1cuyKZ3rvArAVC66CPKRMAprnwUZwpEdJ1VJ5m1EXVZYyYcAGE3kignxL9SLfWQvHbx88X0Gcxnla3oAHn5OwP1XIj7ix57cc65TeJWLi/b4mUai+exYtwvboamMAv2j4586QQrviK2px++rTET7O+fMB29loXzLvAn3XR+PKKkLhXiL4vSRWLRB4f
 6eFtItXD
 nOOwp6NRFQJy01+kcmzx55wEJvPyV95qv+mAq0lr2eLAzHKz3Js2ZSaQeVCRay7/m516LgxsdFQdls4vR9N7/GMlKGoiWcv6iFYU+t6McjRdUeIRkjbRP4A4Xr0bN/jPKDU/VeXF40+ZZuKW1Aa2McsIi+VwLUB1n9G6vBhvDuR24w+z+pLlrMaoioQ4hQ4mloHp6oET7VEvy/AOXpUYoQvPPL/XyRFOCLrtUwsFmD7EgCZelclzIFr6zYxRzd2UDrlgHloSW7aB5vKbou/hxpDc+RmBNDEJEAHwFDSlz7+aERyImrGoBmW6tXoLUTltpAK2UyUXftIjkyyg70Ib/kmkHPyVD2R4HHVJ8p5pkYoTdyZcziyJMXRst5MgEGW7xlB5U8cTWgKxGZLkhxzxW8yDrO6HbeOqEtO1Gh0YPmk9FlsV/Qxgyhuy8t7JBQhyNkUvh/4RH5vy/mI81ib6csO2ameR8xC1vG4tXkxYQtOkOUsmzjG2WqSOR0Ji01jFZQZpGyiYB9KRUFFo=
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
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



