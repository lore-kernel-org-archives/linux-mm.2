Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6A3CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1F78E005A; Fri, 17 Oct 2025 16:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159488E0006; Fri, 17 Oct 2025 16:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73578E005A; Fri, 17 Oct 2025 16:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C018D8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A6341402E1
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:58 +0000 (UTC)
X-FDA: 84008704836.10.E461F37
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA2D78000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0tGltSi4;
	spf=pass (imf02.hostedemail.com: domain of 3R6PyaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3R6PyaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZrm0bBpyP9vTvkArtXHnxbGIMZ4Py8QfqHZJRCW2ZI=;
	b=FNIuMyqQ5/qrAf0Ydr5rG0Cu/Gwe2Qv8f+kp2E4xbhr2pB297RWbJmcm7Xx4i2SGSvSBuL
	7TRhXWAJtBa6kewUZ88XqSJjYK9VmxxJpfBLVEs2/R9mUocrDrPLrWOgFUyKfeEH6SSfhN
	uwuA5/QN1cq0DlyyOZK4T346JgZBVz4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0tGltSi4;
	spf=pass (imf02.hostedemail.com: domain of 3R6PyaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3R6PyaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731976; a=rsa-sha256;
	cv=none;
	b=KY8QMEWgbE8DZl/uMY1i0njz6d7i6Pr0sq2pF3jBZyOaRJAFWkC4r1R/dzHnNMvLNn1DNw
	dS5CFB4KWFDnasmPcaLhH8ok7fJ4IK6RUZq/9CHd8QVp2Eilvbg7kLSEYbfAaW9A03L3hc
	iNaeVDq+nA/apux5Zk4eXETFOQwal3M=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290e4fade70so8716725ad.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731975; x=1761336775; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FZrm0bBpyP9vTvkArtXHnxbGIMZ4Py8QfqHZJRCW2ZI=;
        b=0tGltSi4u/0xaK9gRxzq0NiCyX9ywakG2dvKXpF7DSFgm37xLNgSLrWqQ86E975opa
         E25bptDpocK+6AiRxtqsBktyuvfDQT8n7jcjn+MN5+9D8nBBmJ0FUG1DdiwdhNUgRnsc
         PqiTAeE5TM9lcXeka8vf6GUsE62fRK5lEisMSf9FByT2zUwP/rJlRuVuvM9qnxw/AqkS
         6G9fdK2bhfUTv8UqiUfY9078Wcns1fqClz+zo3A5WN1f0cYUpZpFABIk8lajAsEQ2Kc7
         n/0Org4V+xwjGW0aHGjsipDkfpjOSaUxCWJgszlMmCx/XG8kn9QuyINyuY5CCysB34PM
         +9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731975; x=1761336775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZrm0bBpyP9vTvkArtXHnxbGIMZ4Py8QfqHZJRCW2ZI=;
        b=cN13KpPz/6q3To99XcPYnW7iCsKZkl4HzCqV0vrmU+EMulXH4J+k8PpeJsPFwJNdLk
         cJu78bG8/KNUW7W7UiLamJpnFnyYdxsjpvtaVUGmJ+Ioj5O/ATwo3K1rSiuZIEYmuI7J
         yYgBFOA1MOmsoDKnZZeWZ7si2J04EePdYVwcVvnPI6nSbck/0gWOhiIA44nhiKuD410V
         NxSvoS8TIPPNCpR1aUGip5HNvbMk0T43gX6vAgjTfvWaFffx1B8BJ12up92QVxQ75LW+
         3K9w5aLf/q9wQLGRs9wVgwrP5v+mu8n2X88Gp0CxXShGVvVe69y8/mf/EaJ2JNVFU5lA
         rXCA==
X-Forwarded-Encrypted: i=1; AJvYcCW2tZZffGT8vjL3NoXkactDlSURWhFOj39tO3gl5R91aY+R6wK5UvI6oh7d4Zw/k054x2JWz7Pz1Q==@kvack.org
X-Gm-Message-State: AOJu0Yygv3P2kBsGqjAbzyDQiPy9L6JqE4Rgfwx399km4uCJlbC/MwCp
	58Hs3JHLprgVRozubt83m96MjNoHyEMr81JrDUQU8aATMuR3fl+Fib4Kuohsyx57/awh11BMq3I
	qY6lx6zKFyxBSs+BuBEqF7hkcnw==
X-Google-Smtp-Source: AGHT+IHeEcTma0Vf9iP7bayAuL5X24WwVW+rZLP1mtrjCO7SF8PjjpL45P1H1MJ3MINmLICN5Aa9w6/jdnFaODUMng==
X-Received: from pleg12.prod.google.com ([2002:a17:902:e38c:b0:268:4e0:9c09])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ec83:b0:276:305b:14a7 with SMTP id d9443c01a7336-290ca30d76dmr61848425ad.33.1760731975492;
 Fri, 17 Oct 2025 13:12:55 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:57 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 16/37] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA2D78000F
X-Stat-Signature: xyt1mnxidjq7jeiq38no7bwxz3xjsfaq
X-Rspam-User: 
X-HE-Tag: 1760731976-680382
X-HE-Meta: U2FsdGVkX19ZcCaGZ2dqhopkujqK/x1OMjlSgzEDnXXp8w4momoHRLd40/3IJk210yU+aBecy0woHv2ueJX+js9QluMe0M2ZH7fydlS0XHkzttTm3tJEDiU+Ii3Zy3AnUMrwLgk8FiBg7FH6y1xpszS/OVBaSrCqxb0Z3X/7rhAIYmR4no49RxKdaiL8URGEzFLMsMqefapu95zULNbca43+lAlIk0jicf229Q3zo1HoiyQMGDokgASKzb4ryPildcU+kR6oBSkKXJdNRLLztS1a5PZT6g2t2kbG3XqvqX30mqcp4YeMMSsY4VLmE4g3X7gbWu+l5+ElA8SoaEH6rtqqQfCnwUcBgqkgXCryKqkmEyAMSt2UHrYhQSGwoWRGmKXuu911nRgUeSe3RQGUZCZd6KeDdTNliu8zT7maBNPtWphU8JS1zvQv/LMLrZZo7fwQVNyKyIAm3uhi/cp38PZbl4soNDDxVD0DM9olYUx2UisqP+ptTKoMNW8vNjFxubI7Sxy4nicXrebQQ2ewwvvf8bYuRqqbt6B986I5++l2frE7i8h7oNm6pENhxAgL6YG6dR4lY88kPY6cX2S4D0flhH8G9JX1T2h0G9tBL7sxTEA4VUk7PJ0kFkIRsDVzN/4YZ+UHzyHwckQm9l3N9ldoMPVrC3+lue7tpgqOY4odH/hY9LBmIT9BBnnO20OLh69L4yZ9rzKJ2RmewiQ7L0zqTOnMYMdfCOZaQfzX9zkzB+2bpab80n21Wh+LE5XGsUptg9YqQY94yNm7erswKn4r+mpl279s6m+LI/0VBn48LEvBU75D9FuDsxhD80HFBseuP6D6N2PERW1T5d/lirPtbn1XCn4V4OH9qbl8oLILeKOF901VEcjDU2difoc73sYmJg3eHCZIyCue7b39csc+oLXPTXwu3xBntrQBUCnOdBm76F3KXSGOS2HDZvIPB4ZaygxNLBwJYPnhi8D
 DVW85N1E
 7U1t+Oi0l7sj0/OSSeTth8p59Sz1TyBCXT6Hu6ii0InvBPvJsYD4h/FGZ9ZiWb8B5FlgdzlotatT9jbC6eBxjLwEjyT4p0jHfPkRJTysH2gOQbGat3uKDabAcUMj2+lST05TmkioF/2wDxLRzB+uilljxw5P/Szjjvvj7GTNQMIqdzSwkpjuFv+PSLk6s4q707H9rfehxYOUf7XUn9+mRwSLue0JrxwBuFz3lNm525MERoVLz8eqjasq2I3qFRdjCbk2Jes6OcTXdEPClCfOaH4rIsEFh7NZJdJial01SCYsZrk60pHc/p4Ahlbw456wvzKLDGD81ye+l38BHtbOb0yRRNgnOQi7oLp64pTByQYopvZlTfaLEVutdRCxIDxda9gBxM2AYh1zxjwN/DJAHtV25DsnJqF95ap6UkT2kcTu5gHbD8MXQHMNYf0O/l8NbbU6E/wuO1ybeysVt6UIkOkyHH1YmUMpjfMcXTXiuqTpG9paUCX8l8S5hZFRHR0L4eVT2kfB5LSdKY44X2VH39sjbW5yWTc4OjwdulO+Akqp5Gu1qOONpVu9ERyV9uIhBGo09fC7XxH8+iXUSLRqVdGXGSwMm2oWeTbLYpbaK0DIVAMEtx5iTV2xStqG8aoRqbGA9rHIdtEQMFg6Ci5Shq2tlCeJnL0nT0KQNprKbY5jROtwqndZoP0bFSV3u+MDJzhM8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 tools/testing/selftests/kvm/include/kvm_util.h |  7 ++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++--------
 .../kvm/x86/private_mem_conversions_test.c     |  2 +-
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 45159638d5dde..de8ae9be19067 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -678,7 +678,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint32_t flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int guest_memfd_fd, uint64_t guest_memfd_offset);
+		int gmem_fd, uint64_t gmem_offset, uint64_t gmem_flags);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -711,6 +711,11 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
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
index 8b714270cf381..19c0445c0b296 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -944,12 +944,13 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
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
+	off_t mmap_offset;
 	size_t alignment;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -1028,8 +1029,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			uint32_t gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1050,13 +1049,16 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
+		region->fd = kvm_dup(gmem_fd);
+	else if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
-	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
-				      vm_mem_backing_src_alias(src_type)->flag,
-				      region->fd);
+	mmap_offset = flags & KVM_MEM_GUEST_MEMFD ? gmem_offset : 0;
+	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
+					vm_mem_backing_src_alias(src_type)->flag,
+					region->fd, mmap_offset);
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -1117,7 +1119,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
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
2.51.0.858.gf9c4a03a3a-goog


