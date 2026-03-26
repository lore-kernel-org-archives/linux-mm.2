Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64F810AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC516B00BA; Thu, 26 Mar 2026 18:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D866B00BC; Thu, 26 Mar 2026 18:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB2D6B00BD; Thu, 26 Mar 2026 18:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02A406B00BA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C999D13C2D8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:08 +0000 (UTC)
X-FDA: 84589645896.17.23E85A6
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id D142180003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDddGKdh;
	spf=pass (imf30.hostedemail.com: domain of 3QbLFaQsKCBIsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3QbLFaQsKCBIsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEpiZ3Ie+u8cFKZvwOJ8qoXWS/RraT/cFEJPQll04wM=;
	b=SHD+B1ag0MhWGT3XMMOog95rJ2reWKmOBdemfj60MxJJ8vgTXwRhdB+buOIAeO0tnXwntQ
	X6o/uZ9AU2S0OxbFIqgtAL+NgpUnzCpOgs9mwUWjBemPH+jtOvNXLJO2oXOvR9KCUCzUS2
	4DomiR6tlMAJBdHGzxykwL2mnn0PrDM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDddGKdh;
	spf=pass (imf30.hostedemail.com: domain of 3QbLFaQsKCBIsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3QbLFaQsKCBIsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563906; a=rsa-sha256;
	cv=none;
	b=v4l81AfDPk5/RfN4EQoqEBH6qt84F4RfzwA5ncdWSUZcVRjdukqmJyYw9jbfHEn3+2s//z
	V0b/RAamTu9cHx68KcX5qqkxpN/ygeCirrFxk6MBv07sdwdda7y9jagQl2wBPPeAHjFIz+
	H5vO8CMhWkHMWyoZf1FqGENTGIcWs50=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b059ab124dso19484355ad.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563906; x=1775168706; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WEpiZ3Ie+u8cFKZvwOJ8qoXWS/RraT/cFEJPQll04wM=;
        b=jDddGKdhZBB1NH9DAMjjlTfjLKktnoWy7NHdrqc/+QTWh2QYL7Pg7ofxx5rrqCBkvb
         fcddFGrcphozAl+rFZDNoxiY+bfOkm+wAlw05BgyzeQyKP1MYLZJyLKw43wlGpVjND0Q
         BayIGg0WNV+8EZ9D2wfnHNFy/ni+xNVMZaVfT89+lSEf6crkntg62vMsJuGo6VTJ7pav
         9ZZiZq4hCDCuJ+PDSHsVEQRef2s1zL4UUrnDmio/+THWWTfp6mELl8C674uDa8ewR0WE
         Fa+Z88J5SDXQITnB3041OvgAj8GbtRcz0QW9mUofhd7OUtGb+CuEf5Bew3GF34pMSDjx
         +mOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563906; x=1775168706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WEpiZ3Ie+u8cFKZvwOJ8qoXWS/RraT/cFEJPQll04wM=;
        b=UNyqrIaRUprWkZ2TJ3qWPWr0OJM2lqwviCl5fRom8CPT7DabV4JVqiqjbr2kTcAnXH
         MhddqeGccSo6ST/hZsfCV8ckiT1HeKOLMrj7nlPlv3c61UmYwi/1++aYq5idCpDo1iee
         eyWEY50/L0tv27qLdqFnOE82aQZoSG+Bz+BQ5ob6dtZdVIj+1mIphNR2Y6ewVTOStDnq
         nT8VHACMgCEJ06NQTwODuf6ijjdh9zkfGouoC29eo5aBWNMj+BPIAs/S6I9PkhWEDNbR
         iklz2WUu/PUjo1Q1PngZK/hkxQiXZalkafmDot3NGiFOY0t3X2enEYf0sv6TGmHzhE2X
         kUtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ0pc7wUxYtHGzFSt6JzPxSg3gZvjpV8d6DS3qWA47nYKFlH9lPx+X+i4RbDEySszkGIT8P6xosg==@kvack.org
X-Gm-Message-State: AOJu0YzJOgcVhFtJhVFAy0HaK6BNIXgqu1obtNe6+bQ9VgNyUcwglveO
	Y1Fk2gLjOM18xc6BPVWz1GrrufVE9zWHkilbdXOl9JZiGX6Dn9fJjCSjlsjeVhx/g7ryMup+ovL
	pWPaQyRrU10Z7ozsjxfUJYe7Biw==
X-Received: from plco20.prod.google.com ([2002:a17:902:e294:b0:29f:25cf:e576])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:40cf:b0:2b0:9a6f:cbb with SMTP id d9443c01a7336-2b0cdcb0c85mr2171345ad.26.1774563905367;
 Thu, 26 Mar 2026 15:25:05 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:29 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5500;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3vNAWgtLoposophLWrViaHYvvOXZ6Fk6ckKHKISBIQw=; b=5ZW/84CSiLisXbfe1r14r83e3Hy3AoEnZdshNnLemzJjOMY2dPsrs925RHSHU1mSj258Dyyz5
 VMpW+WjIPY4DZdPwGAgjCBX703FNh7usPXzDd1fpjoEGG2Zj0tLFl/f
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-20-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 20/44] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: geeet7irsrsqmeh5i4ase3awsu5ikff9
X-Rspamd-Queue-Id: D142180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774563906-932175
X-HE-Meta: U2FsdGVkX190YmCP7cI2rUVPBDp4VZHFaCMkaZZ49nR6f6XrTJmwaH/0Y99T9Y3KcJaYx1v2ubcZpGgNIR9dKQUFz2Ak2/KBtisRk3+hNMuaMsPiCjwCB30kGrcDf9BfWEfDOwdPinWciWCBfnj37rH0zUuWvCO/QwERu2NlM+gCzLL6OCiKRMdF+Irjq4fqGoD4/FrvirJbDqBovhmUSni2N3zZOJdKmW4RDtInBrUbZxBCELo0OUZrhttVljFDkzq5qnB3VQk9yKueljVcAtCl2rRUCFvgDJ3RS6P2PEf6RkiqmiDD+Bwa67v6ATymykdBL9KmqUW5bkSyUm7AfzYdnTLNZYy/jZQl5tEZUbKxOiT71lZGkXXHTuiRXa73ehTsP7gXFjFKYUtZkG5gIuqCdPJUJyom6jHyrioBmwajKZMQlpVijZlxHWBKdrtYJ4D8J7+HGoScm96qhCflP0zrcQXd35SlHWWA4meJ9bcbYDRWBIpJuoPESoLckTXuReU4nHPe807XTSXg9YCDdi6a5UCgq+Hp0IWw7fiLU6iEbFj7feHLXOEx0v0ahdfXEBPLN9aKy8dIH3x5FjalOMcQ6tZuB5xa0P5CzcaB7hc+3JabZBY1dPhnegWWl/LUchiTZ0OtPx/3fIxjE/MinhuRhIrlKUbbvfv6j/PYfujehmZybjveO/mib2uJSVqllTSYhAB3R0X6IAv3b8Sd1Njbf8Vnxixjh0KbJ5Dzt9Dvxq80fDt2POg7h57WF2/JBaM9X1qbSOm+EOFugDHBKEYtehQSCj2Vi5ljBmjXigQ0xa041yG3WsGaFAj3STVRVlEot36x3OVnTok4taNijbPHQKyIe9n4J8MoG857/Q5zOctyEqJpPKuzVfmKjbpbr88L5Q5FAaZx84vFvTw8NfjC66kvBRxGrRKTtANN3al/PjY4P83bXYE7JA2PCt8OO3IzsvJm0Ycutbf9O0/
 MTCuRbOE
 Fj5B2DeIMjaKJgXD5aixg0iUQ7ZY66w4A0W0dpRU6Mg8bJc90bqGHwCDS9Bd8eOreIPufENmgPdRS8/77R9BrGNJoeKjIaBWjjciTywkipZ4hy+My07LYUlXHKsIBgH7ha+Tw4XUye6wYvezXh2rRz43hzX44E9Ty8CVyR3iamI9rt+OUxFhRRDA/VcHZAIkEJoo3JPY6YGUCMkbhiEc7jWbEusAwFzfLzg89jEl77vgbZFn3cocDDuPXx8d6DQrJR1UAQil0Sp28EaAh8HLk6G3o3SzG5WeeYndmDlW74Y34HFwDm+NStIwiCfEpQ2vgoYXw5TdHN8zzp4HIj47FUVrsjgd45vlYelrdhL58PnizSDtWrzGSCM4XaydTQ+42eFPtQQIV0+yu58FHxRNGsDe16K1RxsZSpc8+iVNIkLS/hHWAtbKp+LuZnIqQZVUEomac6v7q3KLZvCMyrDIEt2tD0+6+S9uWMiDiUZqytgqpeSgtKFnUVq+8KgcJvwbRfeJ+eQ/7lstv9jdi7USvTnw/KsLKQX7ARQJkLcRa3hr6OEsFBLDXf+0/Jy15J4k8biIQra+tOjc+A0x+WoICPYXyg/74mUIhOWqZI3cDFG2ZfFpTcdDycfSCtXF6HEJhS+incMCWcdnRhxYdu51j57XV1HsWZDAV7u0H969oF1VmnD26g/AbEPFFlh0T0HKYp0Yh7f1CDZN6yVnTYwgpob1UQA==
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
index b2d35824f2a72..4e06724cd2935 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -701,7 +701,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint32_t flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int gmem_fd, uint64_t gmem_offset);
+		int gmem_fd, uint64_t gmem_offset, uint64_t gmem_flags);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -735,6 +735,11 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+static inline int kvm_slot_to_fd(struct kvm_vm *vm, uint32_t slot)
+{
+	return memslot2region(vm, slot)->fd;
+}
+
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3b64fbadcd88d..82d6945efa29a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -979,12 +979,13 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int gmem_fd, uint64_t gmem_offset)
+		int gmem_fd, uint64_t gmem_offset, uint64_t gmem_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
 	size_t mem_size = npages * vm->page_size;
+	off_t mmap_offset = 0;
 	size_t alignment;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -1063,8 +1064,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			uint32_t gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1085,13 +1084,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1152,7 +1155,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint64_t gpa, uint32_t slot, uint64_t npages,
 				 uint32_t flags)
 {
-	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 1969f4ab9b280..41f6b38f04071 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;

-- 
2.53.0.1018.g2bb0e51243-goog


