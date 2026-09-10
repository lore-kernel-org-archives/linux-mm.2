Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBC5C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132186B00D7; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2366B00D9; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50536B00DA; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA6906B00D7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2291516058B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:58 +0000 (UTC)
X-FDA: 85199513196.23.AF0C63C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3953E100002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaPlc61H;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084556;
	b=bQSkvEjOel97rDGR5f1o4zZh2sYuUKakazk/I73RGuLU9UDSeK01cUgm/R/+ldXCUApo1n
	Zb+Oy8AN9d8lBDNHKOrQsy/NDIGV4jouOFawY7otbv5nogEQa34GubmGGpj1a8d3f49tj/
	x8FyZP9KbWZytMNeXbRcJl0s/AYqFlY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaPlc61H;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084556;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3ciVCtkLXciUmF7dhhHegwxxsIGE3I84dUCrqJC3w0=;
	b=FIx+nEWrSsdiqW2McouJ44yKVDgY77na1k68+b5r4ni+u9KV4JHpECY6NIYtqHg3zDv9lB
	qZ1lcucLscKKZ2KJIzgmjXmKqPf8lRUc80m1DCj0ox48Oc4uGn6xwYu85FRmxUN1IoFqYE
	TNtHrsKa223nDVqimfBSbprMhHNVNUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 185CF41657;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF681C2BD01;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084541;
	bh=Zm8m17UNWN4NPB96skt6eznY+e6ivIIGv3vH+lbtkSI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XaPlc61HAPQarpNPXa9tgdCWhBEbyuernT8L7vmMdY1T3ravHuwUoHthgSjEldFO5
	 UQwp3s5iCq6HJcyYSNWxzSvd3fw3DJF3Mll4NDE2to0LayCsN6D+XH/Br6J9FA/SLM
	 7Aohrjf/O2sFK4kcN23zxRBVdo2nAy/im36lhGZe7uhBebJQnhfLG/l+WDvVc65Pe7
	 /9IK3CkQw2TvdqwgbzGDgLODMLhII0GTBhYdTC8gAPZo15dIk8/JrWpJX/zWEPWDkz
	 J5YQil69+WboMXvr2YUJfsCGHCzh7wrS4xD8fW+kpxHF0CexF00hLpBHgeyLxUUJLP
	 qjmt8Y5KxIV4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA749C88E4C;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:08 -0700
Subject: [PATCH v13 42/44] KVM: selftests: Set up page size and alignment
 independently for guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-42-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5652;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4X2PaHnMnamjeHImpEBasyFu/253pOYvVZroEZMdQ6Y=;
 b=ZhDaDs120Ou7ZWAQavmPguVCp/RlOxS5vpc027gvhpbRxPNjGdd3TcRvOCYTcfA9FUovDs2F/
 FCVlgvLvq97AmSOXoTgfFGx+viRH9d8k4J9HfA0s69Mp+19FF/f5j9v
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3953E100002
X-Stat-Signature: mgumk957ojko4o76ntr4yb6fnky3pjqz
X-HE-Tag: 1789084556-77991
X-HE-Meta: U2FsdGVkX18jAn/agJkNdt6MuTE2Ek0KUadLTZCmLqdoDX5F+SpHc6pSa8mfw7+4JjYOiRXffniCRxDn2XzxcuCca++Po7Cd1EEDWPttp/e1Stsy6MsabBnHndBPKjH9aFti28S6B/TukyW7dQq9nkY7+7nqyi5f2BF4ij+7jo2fHdE1RI2p8yTIyqFfyHIgp4YFDeztfJdG4qKmecJU6BqyMmvLZFnVCXC3bDGxWOaujDVi5iPpwgBvzSDTtK0nvuByMXyZr/YKt0FgklqxOc7yM3EfnJ0tW8/BjBXuehlZofj0tIJe+aqAu73Y5AXpILZftjLH5GQNTEDu3BVY1+PGAigjBsWKdD8MAFnHlgQ0otdLUVoFwq/NOnKKeFVnjIfREDvMtn11FqCS8yirGpu3rxeEb+wMXeLL9UnxJYRII4Vcf1duTBcYZBcMdALnxdbR4cUXujovsFiLUHvkZwJW01DqFdRwuoEXrLmPpeUIikiknSQo9XZdlXoq9JfcbLsDecmBWDAfN36dmYBnsAcpaV0EBP2O+FPvle1G5Y7S3KrDgFU9i94eM/GTj/nU7BYBAl97tV316YjdTmHdiM+kouFdrzdJKVDnX4s/uxRbudzo8rWDGOqXhLo8U8CW/nl0ntU9caAVOB1NILh2BVA7NvKWobzddk28veRibBtURL7098mHHhx+K9sHFZfIIK/Uh/8bojctGu25reidM7XfM67iw5J2dZSCnu9zm0ds/SvzrpFD+oSHgGDkvkBetnKkN3t0k5ABIkfFhKkGJAKh+pDeoYWsXMedLWPdATq9IOMNvOmaYPwSZ91JaE3w19zvZDe8U2OL6OehLDkXLaQ1VD6x6sE42V9aM63tcWqVwLjQwY37emOjrJM8GmV+jgdAiFeDopk84XtUkGY9n4zFtqH0pQQJCyVD92rOLG2TyJMbQjM4Vl2bqIGXlx3/LaLiUJJ80jU8LhrkuZ4
 9rKBSag0
 +48vzP32ziwyE/64KiQaEEHhajzqYq5DxrscaOm6WjcRCq9sjh0b7ihomqvV3i70BenCPp9ZzkqwfPm6w+ut9ZTfMkw0goYvBYnGlJp8Qxm4TidF0hsXuPxNxtIT+5y5gMvmKOQFXa4bE5mx3AepVwYWuj2/M/uRccLvG5A2/pIXI//H9uBkwnxpmEALvH9u8J8izrdoL2Kl1RpnGxlPXE34qzY4Z6Hi1FhAu3d1FoCzNBy8OwZdKbdf73BcMAz3Pi9AM56VLGmf99mbjIF3Tlru5Y2eDgk1LGvtn4xWmMyoKLCiag3uKh/EGkb8UMgRqJYcHxAmKKfFazH46tyosAX0hnQSQac6lW4NiHahZ+emvXgJtlr/wY/lp9/wWiQyA70tqeX98zCuWnheh71IxrUig4j14rbqkpDya4RXLXUHowyNnSGTPemq7hIBF/kh3+NTo1LsMQriLY1Q96aAdI0G5vvkFprkYHND4zG04WWURPQykTEuBSlWL5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Currently, vm_mem_add derives the backing source page size, alignment
padding, and mmap size from the backing source type upfront before checking
if guest_memfd is being mmapped.

With shared memory also mmap()-ed from guest_memfd, the alignment of the
mmap-ed address needs to respect guest_memfd's backing page size.

Refactor the backing store setup to configure the backing source page
size, alignment, mmap flags, and mmap offset directly for guest_memfd
when it is mmapped, ignoring the backing source type.

Skip hugepage validation and anonymous memory madvise calls when mmapping
from guest_memfd, since those are not applicable when mmapping guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 74 ++++++++++++++++++------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index cac5624e99774..3f559f207408f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1034,11 +1034,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 {
 	int ret;
 	struct userspace_mem_region *region;
-	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
-	int mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
 	size_t mem_size = npages * vm->page_size;
-	off_t mmap_offset = 0;
-	size_t alignment = 1;
+	size_t backing_src_pagesz;
+	off_t mmap_offset;
+	bool is_gmem_mmap;
+	size_t alignment;
+	int mmap_flags;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
 
@@ -1090,19 +1091,31 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	/* Allocate and initialize new mem region structure. */
 	region = calloc(1, sizeof(*region));
 	TEST_ASSERT(region != NULL, "Insufficient Memory");
-	region->mmap_size = mem_size;
 
-	/*
-	 * When using THP mmap is not guaranteed to returned a hugepage aligned
-	 * address so we have to pad the mmap. Padding is not needed for HugeTLB
-	 * because mmap will always return an address aligned to the HugeTLB
-	 * page size.
-	 */
-	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
-		alignment = max(backing_src_pagesz, alignment);
+	is_gmem_mmap = (flags & KVM_MEM_GUEST_MEMFD) &&
+		       (gmem_flags & GUEST_MEMFD_FLAG_MMAP);
+
+	if (is_gmem_mmap) {
+		backing_src_pagesz = getpagesize();
+		alignment = 1;
+		mmap_flags = MAP_SHARED;
+		mmap_offset = gmem_offset;
+	} else {
+		backing_src_pagesz = get_backing_src_pagesz(src_type);
+		/*
+		 * When using THP mmap is not guaranteed to returned a hugepage aligned
+		 * address so we have to pad the mmap. Padding is not needed for HugeTLB
+		 * because mmap will always return an address aligned to the HugeTLB
+		 * page size.
+		 */
+		alignment = src_type == VM_MEM_SRC_ANONYMOUS_THP ? backing_src_pagesz : 1;
+		mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
+		mmap_offset = 0;
+	}
 
 	TEST_ASSERT_EQ(gpa, align_up(gpa, backing_src_pagesz));
 
+	region->mmap_size = mem_size;
 	/* Add enough memory to align up if necessary */
 	if (alignment > 1)
 		region->mmap_size += alignment;
@@ -1129,10 +1142,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
+	if (is_gmem_mmap) {
 		region->fd = kvm_dup(gmem_fd);
-		mmap_flags = MAP_SHARED;
-		mmap_offset = gmem_offset;
 	} else if (backing_src_is_shared(src_type)) {
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
@@ -1141,22 +1152,27 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					mmap_flags, region->fd, mmap_offset);
 
-	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
-		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
-		    "mmap_start %p is not aligned to HugeTLB page size 0x%lx",
-		    region->mmap_start, backing_src_pagesz);
-
 	/* Align host address */
 	region->host_mem = align_ptr_up(region->mmap_start, alignment);
 
-	/* As needed perform madvise */
-	if ((src_type == VM_MEM_SRC_ANONYMOUS ||
-	     src_type == VM_MEM_SRC_ANONYMOUS_THP) && thp_configured()) {
-		ret = madvise(region->host_mem, mem_size,
-			      src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
-		TEST_ASSERT(ret == 0, "madvise failed, addr: %p length: 0x%lx src_type: %s",
-			    region->host_mem, mem_size,
-			    vm_mem_backing_src_alias(src_type)->name);
+	if (!is_gmem_mmap) {
+		TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
+			    region->mmap_start ==
+			    align_ptr_up(region->mmap_start, backing_src_pagesz),
+			    "mmap_start %p is not aligned to HugeTLB page size 0x%lx",
+			    region->mmap_start, backing_src_pagesz);
+
+		/* As needed perform madvise */
+		if ((src_type == VM_MEM_SRC_ANONYMOUS ||
+		     src_type == VM_MEM_SRC_ANONYMOUS_THP) && thp_configured()) {
+			int advice = src_type == VM_MEM_SRC_ANONYMOUS ?
+				     MADV_NOHUGEPAGE : MADV_HUGEPAGE;
+
+			ret = madvise(region->host_mem, mem_size, advice);
+			TEST_ASSERT(ret == 0, "madvise failed, addr: %p length: 0x%lx src_type: %s",
+				    region->host_mem, mem_size,
+				    vm_mem_backing_src_alias(src_type)->name);
+		}
 	}
 
 	region->backing_src_type = src_type;

-- 
2.55.0.1007.g17ff1f9808-goog



