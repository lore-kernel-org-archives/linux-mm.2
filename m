Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4B5CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD646B00AE; Thu,  7 May 2026 16:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D52F6B00AF; Thu,  7 May 2026 16:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA186B00B0; Thu,  7 May 2026 16:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB056B00AF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1E048D0DB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:02 +0000 (UTC)
X-FDA: 84741747804.24.12C1742
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F01961C0004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnvEEDX4;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmkwFQcX5Ll948QQC8TINwU2fqw3urQvjMwctOiKFnc=;
	b=bI1NY5MbyIgv4Z+BzKYP5Xbg0b7aTU6YBU0wNpSOKdald+nbq+szqltRaaa4CpMD+qeRyv
	PmVTyZ4Lla3WjL1xYIhqndqkvrRSexcFVYQU92QU+xgHvhJohcjSbBWpr38PZL0kZGgX99
	BREpXzRfMbEitkHC3DRpBvDgE1c4WZg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnvEEDX4;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185381; a=rsa-sha256;
	cv=none;
	b=MrTPaMR3h53I09G/jkVhFcTUEg5EJVE1Cp0BncQbUfjTndaiHQOAPeIPaBkcRlJpzY+1Jg
	qL1wJ/eOQ+jZHuEdRM58QqWodBGbk9WxrsYJs3crqk3ttAW4i/utkb7dhu4HAqDIWULtso
	LuhmtZn7XqVfdiWUiDpSGBfyO+dRIDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F28FF446F8;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6DCAC4AF0D;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=TNHilAW5thOJ2PZgyw/A2QUdZ08vBxaJW5sTEBhIx7U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cnvEEDX4aBxKM0+1ZwsQ7Gi+NYAr+LbhmYeAb8yoKBeP5/FpnxTIMRoN1P/kE8vSy
	 DXiym3od5qY17PVn/XPvb2YaAgfpDh3ZU+6js2apvbN0MwGXSMzPkELTTcYxiDHD2+
	 h86lMFMt+TuYIjhXnkvR9iztuFeT+FsMl77RF5LQMIU50d3WWqWINxGXK+XaB2150q
	 Wn0ZC/jGsvBZ5mCurzdPPJ+HdTxoexwwIzaS+cejt4Wp7AtJp4BSv2VfAYP6M97E8C
	 1VhFDHz/XA8qlG/w6iyENXzsuQBN06C0g73H8aVYQx9OrTLUax6yYKnaIzqYgbeP97
	 GnhYVEIc27pMQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A389CD3446;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:44 -0700
Subject: [PATCH v6 25/43] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-25-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=5449;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=b9lNsHFbMF0ToptO1Wpva+FNCHAqGWWJC7Pbd/PfquA=;
 b=7VG9elETxfz3F0ZRVNfv/0inINCFcfJsY28+u8RRkiagrh2zVIrUVzpGnXVT4OK4GAK3tUPgV
 gx8vUmOy/OHA+HlcQIdyYQZ7n63OtfIELfwApqQCmPgwN2uFxPhFenx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 6zupjwkp3ty8uthfpujqcx1a95sk3kzw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F01961C0004
X-Rspam-User: 
X-HE-Tag: 1778185380-506868
X-HE-Meta: U2FsdGVkX1/caVDMMExcLEPkb5OqOAO5PA8VS2WTIJ5PB9uMksSFB115l4XpxrQDR628unDA1wEA2nz1dd4aDk63atIT/I7lXGCdM/ZFCo5tk93TKgmVS6OYlg++5F2nEEuSiDKje1f+M+oHs9yDigtek2BmvrHuYJgnGePOqsU59Pzd7/bEknvxgZ+dFhdjmVNYeb625WpnG7dRFUm2BJ8TbUBrjJBw4otWr/AzdjN5m6e9r+Nzajn5u1rI5XxWYKTQYgM0wRwNQ4Z2SKPbmZ5hDnCs3rvKb9t80iPVrXPB2cDWFOSGucQFrfP0t+QtMDv5kt0Mb7unJP8yf8osXUlkLosKV9Vr5SWDQ94Mrt+HMC+USQbvl56+8o47F3oRB0k9jTMCVGZymFmO/EelSYrp/7RGeo9LEzYEIwHJBrZ+w3xwKq5oI5vKpzXokMYlNTmNooHSXbCk/5TLNdEDjkrApyUaYOO1aqnSthtz29Ugw05xyVEXGPTjN5TExd328vU830EEVTQTdIgK2DFesNyDeuup/e291fmIOXIxv8ulfTWR4mF3bhM7t0go4I/RfkOhnU2iQMCp82wGYr284Avg0/jR9TaiqaDdVPglPEyvcxRJzhU5+Y/hB8YssUz+4yYUE5+5HQLXXJ3n8K7nTMWdM3nDjgmK/kH1AftSGNfPTNVDKpX6+VNJJMKpMZnII01T9irkjLD3vjnuOKdNBihGrc6Qrp++3CHW1oJa/pf/ZSJd1MGrtMoXx7jF1D5Y5XBxlyCOLfTquHssZMxlldTpGUU++jP4tFX30iQFj9LwQaiHLhaTYoxghoWmQU2aVja+BZYFAJhUEEzeIOjwJBzqtRltXGJyczVL+BoeCzKlQqMiQOx4dA5gp8mXxsc881/TM+nLSEbM6+bjoJfqQ67cY/fT9Ebd3OimF/RV5jgxGNFsbyI5aK+n18etKgv8i1LtjP+ksnRMvSkIRYL
 JSzXk8h4
 8mftGwWqtNwGqHwvIUydA7Jt0cOr7Of8dgb0gnufr7GL04oycTDCZTgfgs2ydVIwRzB82BOCOtgt/shfcQ5vqxdA3fwuVzeAjH66UuW2NRCsVkMvF2pH7D6wmeN6pgTYPCv5EKD4btOGOyKIwT2zjHsbjR02gQNZb6eHGXzLLnVe8XVYr7IQrXhSyKWFdDOtLY2A8sqz+TpmOhxE3QfsCZaqT8STbDArD6bD0fqQYxLbchLDuHfyI2i92uaxwkf+fs5JniYmyqi3o/fMHcctWwR2Gum4uX8X/kmDRUfyFJhrFMrX6Resqwp/cioOUXBj+ZqgNNaHwjMdMuW6NLWpAcmNKFYO0lncv9RW3Ccl99HjAqZezKFWS9WdfaVyLhlC8DJ06Zrq8zbFli+j8U2eqyB+ycWb9B6/DMEf76ofEGSwt0xA5Gfm6y0SI3N718SeRFGZK2FOQ8iwXxtFhhDhGmu7MEw==
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
2.54.0.563.g4f69b47b94-goog



