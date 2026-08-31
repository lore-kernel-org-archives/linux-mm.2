Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206EFC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5886B00C6; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7526B00C3; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCFE6B00C5; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D19486B00C3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63E06403AA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:47 +0000 (UTC)
X-FDA: 85159671534.11.6EB8FD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E7C2A0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LklT/8W4";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135945;
	b=NpTm6qDw27/VDGNOuOjMvZMfZPK+shHFE/+xUnBioh1xgGmItlspSQTvwUc1A+8vwwh4ZC
	Zhhrgs7pkyGBzRFQHDNtig0nIJZ3MQM3e93bQKxrdRM/O6iKByfOj9AaoEhCMYbecCj+Ig
	8u1FRrRPzicqtzsjI2ZH0UIJ76MgFe0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135945;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLXwI5ARUNyri3g1bJr715mXzDdsec6JnvXOLe5CNv0=;
	b=ynUi7yVcHtztB/0L3/0RHm/emQ2Mt2Zc0SJItcehlvVBliY+h4lj+KNCBYW4wG5iE1jQKD
	dsaUFHfERM4YlbI8ac3szcPhhumgrVKFQzi3pdm0HPJpinU0LNVGtupzcx7U56mh9/B55K
	o5oHPfNiH9zHYwL3oo+m+lwqn2UYI88=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LklT/8W4";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A1E144799;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1408EC32786;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135924;
	bh=EqWswed0nqsU3A77F7jDzGh2B7dnfbU8JSq2ruxvWuw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LklT/8W4BGSEFQwQTMNOCM3QYeAHhZIlYKxDRjT1AhUogmb+ISrsWVpdzhYHqF9R/
	 JZdXEOb9ngsSnvTE57UJD4kurmIWFMQ8UaUg4Qi8untiWU2PCQ4aFn73MtUirEcVQc
	 tzGHhA4ZXr3nzKDtB3MYEkQMCrX7uyp0DeGsQ72/7G5diykYW40T1DE1BaArvkpvfx
	 AfHvxIMRsnCvJlkQ1ZcFJIVACuFUo00qVI/eNOYH0B9wi4x5HCDcykDq56gVYaME3q
	 Ai+hUCIv4JAFh0Fg3wHBJWmbhlwiykIVeFXF78IBaiaaVy+2zQ+DFfhoPCSob3wBVu
	 qSDH0FctXaJCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92C5C61DFD;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:44 -0700
Subject: [PATCH v12 43/45] KVM: selftests: Set up page size and alignment
 independently for guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-43-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=5603;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ue816NztnupM7oJGebeqg3yOQdtD8BkHUYR0RLajx5I=;
 b=vOOiAnrvKW8tbEziRbwXAwLwCE2Sy8pStAetzWwVfHvGSPc7qrMG14CZg0vFAv9jCJqpGdIAK
 11hU6b2VsHpDc3yFixThGKKACuQ1aJl2isX8QdGkIRHSHupBkqI1pAV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6E7C2A0006
X-Stat-Signature: 9thfo98nti6x3fttytes811d19z5w94q
X-HE-Tag: 1788135945-493407
X-HE-Meta: U2FsdGVkX1+x29+e9OzDQvMwyThN5tADcbauW3syHyA8+r8kbWyzB5wEbB1RMkm5hakxNAQwpLqi8Rv6dG9IhtoMRgfUGFZwfuqmcZELGbCkX60qWBqSmBanwcIOkueEuifUoCPUtmJUEktafFJNYyFUsB54j1BlwPDyK4wZ4ICogllenteI2FSuBG1DpkzMLRAc54KVV7cDtiQYt8RK4oHsn8itOEIv67BQwZ6FOagX4Ih4jB2X14H0pis14XL39GMqcIR58g+t5aC2fA07Hx1BbqpAJONCrrKmlyGv7SHVT7jk/ZI6ELTEnCfjazzA0rmGw7n0SOR8JaAa0ZW8np3wlSPaBOV8XVxk/BIDuVTsJxhZ0wZzt8r5Q6xOI14er7yRnwL+zhTyowobbHaQt8Hm11U3ZvCxXOY+A7qNpXaCvhgrvMv+HUN2B7uEd9EFGtOF9l80jkp51dfWkIRh07XDT2gGKSTBS1Z8C1IIT6ihcuhLq90bE5dFbuTCx9Ao4KLn1gl4g2AC9Q+XmzgOzhbd+IBzb5gKJZbTX4tl6vaFib284qLyQr08MArWYJCk/+ACeJ8aswsqjedpN8kFC6qci46g9VuYZk8ag91Rr6r0UYTxebsDkgPC5gJaBj1zMHZ8wnxMv1MwDMHjj2YyTxKrOLofjImnaOpyf+TleijdnVvfgfFGYuAujGqpf/PH6+6jrhA7pUADWUnOc9yrnIVKs9c1tISzmBeKMwKsVxa5ma9RpL3uvcYEAmu4TIvTaROwOJgpkgGg+kONmM3Kl7UGhsPr1GvyBFWR7QrfiImXGUomYZuND0oUwAEhrbLRgYmqqonZzK1+chs53hjaWdrRiAj/8OnEMgS7KzwPGa0Rb2gu2rGt0z0nk3PPwhIPj/IqCT6/ZJiGAv3oS0p0JJMIKukQlJXpC61tfNPTk7TRzNf5pa5f5pd580vMhcjHZ5Qb7YAOOcsyoNmO3Hx
 mDHlvTVv
 rBts4BnmDN+I/0zm9V8/CxB3igW3KtNV5l5ztwn8JE3zYlc/NMWphe0fdIzlVfklRGbGOla8X+oqUHgqlvDwV3nh3OTlCwjTxNlXS69GuipW32/cRuYKgh9QpUKmqFI1Uwie+dLs5VIJBtZhpzGEkF29Z3lzviVWk2Eo4dFeXvzluEkCkUIA6h89kcMzWqTNo47Y9mkqszIdO5PwDTJKuM6VGIL8GzQr616SFYMhmV6mOEG4KF1J5D1K+/Xx2kDLQSzqPo8YB5huoCgScs4hBc8Say6o07Rp/PWsVA6MUygO3Mj/kDl/2DE2yn4ccYuKTJJ5UON4o05vPd9j44SOgSKAjFLhWGi02xuFA70EO0Hn/HKpEE5P5I3Off1CvLg8WDo5+OIHVjXiG/PhHP2dHFJW3pdqUiiPyhFHmaE3Ib236RUg+NqwGEBdp9o9g0+g7bgpH0uWzmGQSob3SJTuXd6eQyt/zob129CBk+A7GEPGoBFrlqaLYdlkfCQ==
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
2.55.0.897.gb25b4bd76c-goog



