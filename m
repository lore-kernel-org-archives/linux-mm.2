Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056BCC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CF06B00D4; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEA16B00D5; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3E16B00D6; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533A36B00D4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF19CA0443
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:00 +0000 (UTC)
X-FDA: 85075824120.09.7D4E087
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id ED4B21C000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZjfO6Sm6;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCAXlIeS5JSrn7TzRI7ySQCjlJkpARrHmiGjUWDtEHw=;
	b=fB4VCoolXkxBSMIksT2NdN/yiIz5MbLbCJZMmYp2OBuy3NpLxfvfzHIL0q8veueBfxJP84
	LoEfTHOvZLKPiskPC2ODm0imvjEvp+qFB3oPTGUoYZCiOkGa3vVRE/fiGhea4WSLb3Hcnd
	VYe5B74mN5KVLHWl/xn3Ok937jc3We8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139579;
	b=pNPON2Cszg7LG0wg8pLOvIEjz3EZo5d89pxuTbRjQWTUNGNu1+251DywjRX7wcRCBa3Fwn
	hwzjkei6mmY9xuwwdwOl5EvVAJVsNJj5M3SUq4Z3t7AR9xhayYzSXcvWn/V+YKs64MWkrb
	cLKmy5PJ6T1lYFeUE44h3Hotz3IEfiI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZjfO6Sm6;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44433451C7;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14C88C2BCFA;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=jdgmdee0VIp5GU6o2Un+L0cHI9liYASYll25N6JKH44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZjfO6Sm62xmwgnMxJc9ejWzS/caZOJeV+132pYA3GfVVdepLWPptuSsaN6fcGKTBN
	 nnudRyYxogtekJe0cKk7oDD+geO0c+doTo6c7OMuwdhL9WDcPmiQm71j+gDr2bzhSr
	 c1Phcyi/Z2pj21TXFm/2R45BtxYQhS7WHsio33O66Asn/meX4+myC8pG7seQVrOH90
	 N8anA2qyZokMM3yG/BU49sLy5EcdN5HQwD2TVGu4tzcu69MwOneix51pqSl6QL4sqS
	 1wxwfLrkXu9P/sw16QoVBnQU4L/zvYHZnWpEq503Nyjd3BPIU9BcYrtq6RE53i4TIu
	 cxMRVlSlhaduA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22B6C5ACD8;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:02 -0700
Subject: [PATCH v10 23/41] KVM: selftests: Rename guest_memfd{,_offset} to
 gmem_{fd,offset}
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-23-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5047;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5HKry2PgG3dtuPHsW375sKL/s/MS4E47nwDAYuxF7d0=;
 b=3Ma1ku5Wd0XPmXUwV09jwFygGRy+GJxC5HBm9OjlCWajYL8bU7jpGRlKWEAc9YOqUyw7oWIH5
 6/JlcB0W/bOAQpHQsgT7Uq5eJjRU8MXE6ZOfKd6mlAC3pjGLLLDtOBX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED4B21C000C
X-Rspam-User: 
X-Stat-Signature: khm1pc4hezkien3t141mc4354cmc3u5s
X-HE-Tag: 1786139578-133193
X-HE-Meta: U2FsdGVkX1/bHAwRXws5He49SY6spv7OnICP2Mq0sO3BPhBOjg/RTNQ6uIONFPARjj1gLu3Lin9OGvwBS5I6tbU/U9KfxcHyr3Yyo+TERPsMMgkyitSSopogqmh7MjWlsaiColrqWTGiJ5m5TE01j8w/fMdrgQCIwhxCJKDXO7+wazC1e/BY1/pXfsIzWc8xwhE/hxsxq8eDzwzGJT3gXhbuqrAR2Mb6h07T8u6uOkWHIqmQwTFF19Oac7mHubySKhLvuKcECUk1N53hSrTMCI2bYWWJ5UIxU5RL+Y0vsxvD7aJyyciBSIFBB69Ppa1aHofp6WrbfbSOBnCA6uE5/2MdZWF/16FXVYo7PAg6vpD7DYws0jKqRgneNIdL/PuQeWqvTaMgKEPRkOCP9EJwqSdbyHWDxA+ORmlaczg1OJxJHN/qIcKzpnnsX/2mjLjF8wBuI1rkEUXYH5ajXIrIZdMhqFsyiaoIwvIZU0HxfdiZwJpUYWfZb2FDyzts/EhwEWt/WVI36Oz6Z1uRALzgKEprc4GV1hY+s9LzWvixCZKapksm2A9Jjs2myANvF1Rm6ZDVTiOV651lQ5titCxCPwQfG4/Pp5hqRRrvgXa6qASJEEHiNVQVD3kx/fxKAPesF20p9hAjewacmj37Xfxu6pIdF7gtzznQvcpImqBGuDTEM284Er7T1qUJx9I0tEhh2FJh0n5EUNsrUEByVWvBPMSVNoqin8eUx6dKllRZ+CDw+JshNjcatUn+okeSBNoF4gm/mElmoE219e7DuLwIRmA1+KbBt9dOmBF/wAOAeZgz9leVfqfCHhG645rwDxkJlg6XzKQeG3NsFfLQ2UKrH89vmQ9XniNn4Rfdp2ROFyTVDOXHmikGks3Zm+hkOpBu4UoYFAplXPN1PTCqcvhj7alHif+a0Qz996NV80C9DUlLR0UPrP5iQd1702lecuzTksS+sjTowWAmzGW51W9
 ckwHyX2y
 k7t8hCUegofjlMtzmqrb+8J9xjXdkR1i5BnLnHQUwlRtagPKJknvujKm38inA/XkqZwAkllxJJPmC69w3jq/Jl0gd9RmvFbqVdROMEc6nQsQRloHA2dgreC29jbUJmI6A8lwd+VyxRMvv2fYLZJpDCDIfsCFvaI5OlCQ2XCbY+5E/uLX/SeWsN3+iN0doLwoQLE1SzUP/nDBtzJpdedrl4gRxEQvyueEOJBXapFA5uCDhcykWGV4QU2oR7AW6JzpHEy9AvqycTIgJTlnhB/tG8Dd/t+tiM/c+KlM6HrMcxx+3L7Ov52ZdA/byrV8TRQizrq2FPWcGiyAtRWOnJ6XBs/I3lJ0kcmVmDPL7RZ4sZobwWiqZ8YfuDfkseboULOlYYsC3PEpiXW9pGQCDE1wfWMf2TrfbN93+0TBZkGMts1lBTnwiJJ8uJ/FgQXUoYJhCQQasNASLEM3qiVUGq+iqBdH0lzo7Jh71x5xAXx4DaxHDsquXtsOQKlkDH/P68UskbWQmshn4/2Rhz4lye10od0pTubA6JRogCkrEKmcEWoTUpaGMPXM1c0bQoA==
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
2.55.0.654.g21b8a5bc05-goog



