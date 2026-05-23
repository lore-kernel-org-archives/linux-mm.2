Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3C9CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDA06B00B4; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF966B00B7; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6F16B00B6; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05E896B00B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C95661C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
X-FDA: 84796772508.05.D7CD38E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CE00C140008
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3qxqwp5;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s79gureH10X3fmffn7bQ+9vS1lFuakAdfw6BoG4vUUI=;
	b=bnzZHfAXlxIJrOhxuaXK9h/fmahFKJXJFark+2UVNaeekbra8OiCxI5uGzgxQgk50ES1cC
	RBFC0dB6AwgaMsQRRrZQqUlOfKN3dNqrW/1toINR8wh3MLK4SaLeb07l3mtY8k0g5jwkDH
	aCe25CZoz/qMODXRkb9AxRzTPBs6Bs4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3qxqwp5;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495492; a=rsa-sha256;
	cv=none;
	b=5syZgep/1cqx6skXZ365sx2Bsddm90aTqnqak2v/DXUITUIBdCRBtqrcr77l72VVCP0Aky
	SDFCmPzHme1DgvZAXDxSq6y3N11TClrxDKnSPE658Pggg+1O11VGbeSDZoIdPIRvxh87e0
	OGgooRS3aJPxfKHLIVSrQCfCHMoe2Pk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B018446FB;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EF4DC4DDF6;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=YKhy/RAXNGvTlW9rPUnFLgsaGQDdQDGu1MNrsRL5L/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H3qxqwp5mFXOBNdUZuPGPaF3Ev73e1h+ps0XeFQ/4nGnuMm0wCuydSUG3IHZ3WtXJ
	 eHAPh0yyDtvV/S/2Bj97stZgvxw8+oWLsC1EdSm3VH+yAAZYJeYbcfSER8DY/9YANV
	 DNAsrL8a50fqLWLyzBproepPbUf9bWct8bKHfBtvxF8P/qRUx1mdAEP4a7wmJUZhVo
	 cdvjurMIWU/vZ6px/b2Tl/u+PzAxlCI/Otd0fjiMy05Et705RVK5xyA+hIdBmDzxDJ
	 mKOLT9xbTUVoECXWS13gD2riDOipNzINSrLvgfwR6QGsX2EzzYlTAWYHQDLWd5hovb
	 uDdqPVJ3ej2Pw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F71DCD5BC0;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:06 -0700
Subject: [PATCH v7 24/42] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-24-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=6064;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xxAwuWxrcZq0hW+dKSWHDgBYEnXL3kuqfiR4KI+QruM=;
 b=YdRAqM05rdwvt90mUt6e7OTWup2pR/04xfDoBj94qvaDE+JhsPJV5PyA+RdhYGoli+TxTkXMv
 r38g+CEAdmFAf+rtk1tHQFML+gFccJ1AYkmR1hRHoF5Yd4eV3NWW4zT
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 9okpj3npzhoikdxbkwywhsrdxqwcfrdn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE00C140008
X-HE-Tag: 1779495492-327662
X-HE-Meta: U2FsdGVkX18ei3tggUD4Q7/GpRNgxLFeaEf2M9bI4ilmRHJXjmijA9uwWCP4IjN9xe8AkXneYcdyuMcRmXsi9ydxhlj++GWeTsGnpXzeliHLFuMWV8BHHbkzA1uAnl1h7mOMS0vBkNiapXuJo0k/5wp4MF5wCE4etw8Itmy3PTyHUk4KvEza3zB4Epbpe+EaR8YPfgfkNDH3r/JZnHXyAU/W3/P2naKb/QNezDAxnLm3TkLgdcHVa8l9Uxs0gSv8mH3Y4v4Lrw3Qr7ZjGmxcgwDoko5Tt+iLpWsFiuPDfij1UZpLEYrSW1hwnJpCcBXVI2t/v3CEpPAGeZs60RuhimuWNC1UFfmI4rMntkuBjwjlDlGW30nJDGhphR+DMlViWL9Nu80o1Z3vCbRTtXndjuYyizoOW+7+ZmeAJzIoghxX50jZ9BFieoR+/XqBxsb2ny2uwlaje0PfbjKiZtUd8KOqjlABZy210DXjCFAEmlowZ2lQacUITvkUtg74eFKCB7M4N/RVCFDEzpKx9M/tiYbI8gSD6g7hUPtyW6VaHQL453jOb7cmcEFPtiJv+l6GphrR+MTTlZdEdw6GVI7xh8xQAygpaCgfZZ9089VhvqxIGMn8jvKt3yZQ9ZJZez361nyA5bmSaUtpcML1DxFMzMVTMMHaIeq4easlofnf37vch51xAjwwQm7XPtVroVcjzznO58op4MDsQPZ2caAQzCQhx0kgxxnFcTd13bXPYgZWtkYUkr63lsNLJ3INJxSLA/d9EoNEZaCgR5UtkHPh/wU2Rm7vmPUbXklevXDnx6w8OGWl/Nu2DFb1yG95yDZybJc0TlNJ0tHI0iy8efRDPXl4GxJALA6NK/OD7YCzGUD07l2g8AVuo+eTizMZPYiX9fo7OpwySaCgVEkdduvT/YRDEUyWDvifjnRKzzKS+GIzPctTX5vEwd1kAVxpZNAqbXekICoUwK7+9GyLFRZ
 rVX503fz
 8SoPad/N7kCYuoJi9s3PPFiDMZ5bnS6GPPFOKP4E7GeOIuFLIlE6nN39H3WhUB5sbqxeKy6kBnoz+St3mWq2O60Gs3pt7wJRDOm+ZPJnVXq+v8P8xnjxz0Db18CqPMUoW/ErPLRLP7AbAzex/9yOfxBHznxetnQG2vw6jdhmANPHjv370D6XVQsmA+imEbukgBQtjHMq0mRjISxqnl4LyS/wyCVKoOBclR0zHLYXOpTEBGVTwB2HyMwE9LgQz31ZwNghGowpgibWHNPGGweOukyGHygS26iXVFHq3Y5XJph15WfbnM7YZxq/q5B8X7ef2jnNQETFBLZXZ4dBzSxZKy+y/jDsOhA36I1HZB8hEbGqlWS2NnwUVY6SbYDh20fWZuRtJT4ZsSGziYMaG7ny2LN8wIE7eVQKC1hErTdZoxFc1wq3OaizEvCEfGddRyPYW3qLtemXqSMWa7woORgV6rApDXw==
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
 tools/testing/selftests/kvm/include/kvm_util.h     |  7 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 27 ++++++++++++----------
 .../kvm/x86/private_mem_conversions_test.c         |  2 +-
 3 files changed, 22 insertions(+), 14 deletions(-)

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
index 11da9b7546d03..4eaf553fbab11 100644
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
@@ -1130,10 +1133,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
-		region->mmap_alias = kvm_mmap(region->mmap_size,
-					      PROT_READ | PROT_WRITE,
-					      vm_mem_backing_src_alias(src_type)->flag,
-					      region->fd);
+		region->mmap_alias = __kvm_mmap(region->mmap_size,
+						PROT_READ | PROT_WRITE,
+						vm_mem_backing_src_alias(src_type)->flag,
+						region->fd, mmap_offset);
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
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
2.54.0.794.g4f17f83d09-goog



