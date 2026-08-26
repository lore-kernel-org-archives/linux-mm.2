Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C09AC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85476B00CD; Wed, 26 Aug 2026 05:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE88B6B00CE; Wed, 26 Aug 2026 05:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88C16B00CF; Wed, 26 Aug 2026 05:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3B7C6B00CD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC50A02D2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:26 +0000 (UTC)
X-FDA: 85142872332.03.8C7753B
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 51ECC180007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=awJxAirS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3mq-OagsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3mq-OagsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jz7w3ahlJ2XXJ+zdKH+uz7IHVQmm2wlsntFHCBVHzEo=;
	b=6U+nE0pFsodyuZnU5DfFelOY2W8HdMrPj1j8HtLs1CVUR1LOy4UOrQ7UZWm5WzPl547Iuc
	9e/TLQNctLRyiszzc8RI7j5t6ZZTufj28DyMTzeQutFldeUMa9A0Z5vbh3kYbc1OLSmrJy
	RmgaDDCutRVuJkhWqdhX6bnmh0ejrJ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=awJxAirS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3mq-OagsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3mq-OagsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735964;
	b=kqVAkNTEA5LdUgsw9fUcsGuvjZIHyU4sLhfOpqQFXA5XgOkeL17ZdKZgdDJQVBLJYxLZFj
	q5aUPWaG63YfwADL9g6ugGW5JTdJL1mLo2xKZKIym9U47YMZqYbvN1y18y60DAXoGmCr/z
	Hv0d8UuAEGN0D+pH+PSpDtwMORN9VOk=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84870e7f498so52549b3a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735963; x=1788340763; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jz7w3ahlJ2XXJ+zdKH+uz7IHVQmm2wlsntFHCBVHzEo=;
        b=awJxAirSo8lxE45gMiCkFhOerzFtVwuBcid5/tv7GgYXTybxg2eqDs1briihNJZKKS
         44gAEKsB8DzBi/jv6Omxs7zsN7w5L1zLl/nG6KvQQJn3s0HUcKibC9AzeujA//Iety2I
         /A3/Hq7xuwp3r34EXbWISgp9trXc6QJzSOfrNPwHzZdHrDSW3HTdR+GbgXOXMqCHC/vP
         3XG2mWBENSNL05pMS7l/Qbrwy6tA/p2duE6uywMSPNwhezTRSBxl7dczuzlNjI9REcBP
         jZORTqh9kZo/1XzjGldvachLre25dAQy1SMTNERXSqzAXNOcoJOM9EeUfW1HGoILdcXi
         Y+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735963; x=1788340763;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jz7w3ahlJ2XXJ+zdKH+uz7IHVQmm2wlsntFHCBVHzEo=;
        b=eUHzMctS5Qiezhxc3omANJqtGkprX9AYjwVL3nYn5R0hD6V5FmG3FDmVRz9E7HnM0u
         8N2Y4IsMmb7eGOCNCbfnitBsqyIz6hSJDSjm5cROrClUezGm60R6V6wewKkXX12e6WZe
         G2yR+oYP6JXQHyVDiJ6/nsy48bnt9gfU5sEX16JUZwN/lnWChncWG4AmucZtJuHqhCRK
         ZhVHCCXxNWxYAJ8EDdeoWlbwXoRTfcCovFnlTP/tTMKocNvrxs0KlE3wP8b12pXVNIQm
         WvtWvwfXCMuxGsz2wcocVkCqltdI7osQ5a62Q43X1WkFZ4ufZu1wltv9gWlps5PbGokU
         mrPA==
X-Forwarded-Encrypted: i=1; AHgh+RqP05W019D7JTIgvmx4boIMuxi31XXu+ep0mevv785MGbQx/J0PW7ukzFtJ3JOcMvxP6m2ytMknHw==@kvack.org
X-Gm-Message-State: AFuF++nfuMiSK1ftnEkUvrERCmYIaNXf0KfqIi1RteLA+jwUVuQn3YTs
	y3KBXM1dlwWaobo/WnuxlO4FyGHGyYlLXoU4MS4G9qt0lOEtKx0hy+mBskJRdVZSAX89ri5lg6s
	UQ4gLb9eSpix1P0jrmZvItYkIKg==
X-Received: from pgbcr9.prod.google.com ([2002:a05:6a02:4109:b0:cbe:e120:3788])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bb0e:b0:847:8acd:747c with SMTP id d2e1a72fcca58-85374ebe486mr8878186b3a.13.1787735962670;
 Wed, 26 Aug 2026 02:19:22 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:42 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5603;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=sPZHu6CIw+fRiMalmPEts6Uh4jsHKlHCx6VuhBaSH7g=; b=bc/CQRB4ghM7RBxbU4UEgzRadqchF8JqcorHB5X+jTCT4Ow+7Y+I0O0F99fDiLd5s3UobJ854
 7jfsBkZtDy0AJ7cv9qPJR7hlIRFbgTbM0OIMWLsXAcqj1brU61YZrtq
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-44-0a15d8a799aa@google.com>
Subject: [PATCH v11 44/46] KVM: selftests: Set up page size and alignment
 independently for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51ECC180007
X-Stat-Signature: 5dt3sk6yqnebnarjogrmeczqdnrrfrwf
X-Rspam-User: 
X-HE-Tag: 1787735964-880744
X-HE-Meta: U2FsdGVkX191t2EDJYpcc4+b3AOt6VFGWXOPyABVyfz3/qNwU5EZqyC4g41Nsll+1RNfyGOQUo2jm/aNGJh6VLL1TqLMaN+Ok3qYLdRkoXGNiQQlM4pLC7mBvlEqEfEljztbXJQvd4buIaDzUG7ijy2XB758kKb3HXG3ys/VIgvUGJnfeMVHaHwQePju3aHUcwFKrpMr+66xyRfWWsF0677r71hQ4qk2ZIWERS6yQNP/PCuyjgVv9Z6x8DutOrUMLIn9/z6i3v4r5AJYKkh+6HGQ5ea/PjS7rluKSyNpYLlppXrIZFAgPJda+tHe8d2uFQ0vUhEjiPMPDetj85fchX24Er5GhMgtMm/6X8G5NeMVZsYIEGOqVwY3MpeEwLKmlJNBKidXJp3kBLX7pzaKTTr8yRlOncDExQlzy6HmmZDCIzPwFNN2S7QACS9d9L53k6wuThSfL7wXWLtLyKI1O+yVKm9cmPyNQ0zwA3irEiRaIa78u2NX9n9owU6Km31LphXVvDPWrsGXbcLueUXqcaNOki0PsWjUOsuDGhNu/ygnk0sE8y2EYGhjQ9PwfJj7v0YmAFt1kGmUYQMqxsus8W0oYJluGdfzOdj7ZdUuWh0u2eOG8vzOjiSbpaoos/0I3P2o95TxzIRiPbyRFw8IunZ874wkMNZHY97zHwtqRg7qr7ZVetXzi/CdEKW+Y6a8GHlfdGdQRH3WN1BwuaHDC74Ew2cqzMru7Zh40GRS7P7i70D3AFqvB+mXPnPQjTCDdpoYAyaJpyICInhO4s508hVZW6Qih9v/u/f609MP45Hq7z3zURiJ8o5+/PBJpVMKChZZzamyibKy8hIyBpivB/bAjaVgoZtbng9lIRkIjBjl3Bdgt6DmsdSXACu2sUI0idTQUnqrRfZsRVoXR1UzGDlXu2pOQ7KtLB3MpZgGd8hImTsCWkLJJlIxZsEzJYeuOrXy7P8GQTgbiVGDwDJ
 vWv8hNGG
 fnYI+l/2jpZjliADCCP7DQAbiE1V6W1FcEJ7Z22oxf2gz/eklb8PChj31Asyt3NbJesJ92kw3PPOio/oQPVZtwJhpkJLuo/2HjZlGsNX4WmzN14/l05ChI/NFcAhDFvTeQrdosTBv9wcDsQ/KKbf/1MHkDEcxxbofaqTH51G75lbUzGtyoI3xxUz201UqBi8PUGLOVzb9z8PHM0DiXfM/HqffU5uQ4flsxB4GWsR0288HQY+5xlrPqaMeWC16dr0HdKtfCerMZIfIdVMtfFpf8d/lE/E8LvqNemXf8cnLNSyXMFC4qExcn/TwCGacHb+7CcBIQ7N49pBTmcuUNEFOrD9fOXiqdUlvLh0BAf51TDkkYqkmDD0pMRGUGY5MH+S3DZSOLj2zhiRRi/9NIulxyJqDCTmv9FHlGvobjw7uRUoBRm1C7NfoIT7lU2c6NalB2lubGlT0kYsK3rlRanORuijzF62t91e6RV1YdEsJQMb0WniYTLRUC2BP0iMwkvHn9GfwFy8xSpjYh7JWOI9boNbEb1kXMrIn6XEfECspaY48WheI54eewLKKN+na4QWqnmjBmbt8hLSBRafl10OvpVyA/VmlU8mPbz8qYTkJvM1ONzUkZsWGy4ehHaSa9IT1eWBe41Ij0lF4MVF6plRoR3iKrVZX31EMghzqhnozqOsSv38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.55.0.887.g758fc8c411-goog


