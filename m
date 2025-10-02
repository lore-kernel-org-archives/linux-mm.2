Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D7CCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3674C8E000B; Thu,  2 Oct 2025 18:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317538E0005; Thu,  2 Oct 2025 18:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206358E000B; Thu,  2 Oct 2025 18:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6178E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:10:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8D6911A893
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:10:46 +0000 (UTC)
X-FDA: 83954569692.09.F29FA33
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 17B30180006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:10:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WZ6iM/Pt";
	spf=pass (imf16.hostedemail.com: domain of 3Y_jeaAYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Y_jeaAYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759443045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi8/GlubGIEdZ+duqPrIqBmO1DB/k+E0Kj0HX5P5EcY=;
	b=QPZJVdCEqa+eOUcrjDU1l7EnHdCyQHqO2X/RrBI1gpDjlgwY0GvaHrSCB1QxCHJhqer0jF
	hF07KnnJvXzivNOvMXR//ADo5JM9hKUUf85CyahNo98HQgXM4gcmX6tBAmGyb/3C0+vjtq
	nYcCxgQkQCzEWnd9mRxlYYoKU4p+7Bs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WZ6iM/Pt";
	spf=pass (imf16.hostedemail.com: domain of 3Y_jeaAYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Y_jeaAYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759443045; a=rsa-sha256;
	cv=none;
	b=wepjK09d0MrvZTaQOT5N89gh4fD2+M1HD9Al/Qhk1fRGQqzVXNWqox8FliZUzvSRGplq2a
	Th5gU4BS19cfUwRDV4BHH14dkXAtlSHx4Ai8lH9l2/F0JFzgB/W8r6rKuI4JAlsemM3keT
	+WlrNuYsef5RVas6RtMHqMC0a6gJV3o=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780f914b5a4so1444653b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759443044; x=1760047844; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xi8/GlubGIEdZ+duqPrIqBmO1DB/k+E0Kj0HX5P5EcY=;
        b=WZ6iM/PtpzBcBtrlBYGvgKFXmgt2adeU9A5IEgphF/FASwKakPAWthrtFkpW3/9lVL
         ejIZmXzF8dV9bMQ1IwiNiFQIq4bfZhGZirp5mzaTu9r3QRVebTkcLcfJccQ1ZeLRlMri
         KEF2qF+LYeoDJ1MnMsvRLxSEEbZqPH5b+DpxsVwNNmPj+/6LJOaO384XmrwZVV6slR9K
         F6HIfNTgKsZh/b+xbvDiEzST/rwhEb/djqiJ9xPiZWK9iFLG1ZLVzeHxQn9XtA9hvcGW
         lwNXIhUHyDi3K9m6f+upDpqqyE+MnQIqPCPFuyvfj38a/d8sBIGuudSGdtByru/ahK4Q
         qL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759443044; x=1760047844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xi8/GlubGIEdZ+duqPrIqBmO1DB/k+E0Kj0HX5P5EcY=;
        b=uGV5KEGE6E7sMuMYQf1HhtHXcwcYkhT8/Rd0vB4+/Ojt/axoZC+zWrzyycOu+s+9VU
         38pGADdfVjdI/wmfjYqrZflL/sMvYMStgXNJdOCMzZf51HtJCLRV8qw96Z7UYFyl5gW7
         VuJ8r0uTGLrp661NRXPk2j9s4y4hRxL81Lh5gsLIHgA2QO/ZKHR4/FG0qs7NNyVSLXzV
         pyLy/2vPUsXaPXHHYoxAyxqXDCm8HxHTC4UUSj14XYvv9cDjGmFGe4KftgXr6sK7T6GO
         p11P4zIWTb8ECIgyiJuP1gJXDd7uKhqtbobpXfwae3GCGJWIJWXHloX+28NlQcNpyjdq
         zNsA==
X-Forwarded-Encrypted: i=1; AJvYcCXF4yMfIRxg7EuBqGTnFa9aH6DDhlb/BRukwzEb1LBvwvbu8AI+//jX7M7w3fw38VyovRJL2eCdaQ==@kvack.org
X-Gm-Message-State: AOJu0YyAyhFGlsJTTbxnE8W9P4DbqSb6LUsIo/9o5/Y8UeVRlaupjXca
	7o5GmHNWpYYODgKpbmABZyJr9BYx5KY9JG1zHtCRRzoTm0lsBznypfwQa6SPZeXUldK82ngKKKV
	V61d19Q==
X-Google-Smtp-Source: AGHT+IFY2COPi/SI+2tZew45JFEEDJ5/bh8axBRWt3QhZcBrGQw8oD/D+HMrLzc+u2Hnjo1OVXWBB8HiVDo=
X-Received: from pfbgm5.prod.google.com ([2002:a05:6a00:6405:b0:78a:f444:b123])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:84a:b0:781:d21e:136f
 with SMTP id d2e1a72fcca58-78c98deac4cmr1265878b3a.26.1759443043713; Thu, 02
 Oct 2025 15:10:43 -0700 (PDT)
Date: Thu, 2 Oct 2025 15:10:42 -0700
In-Reply-To: <9a9db594cc0e9d059dd30d2415d0346e09065bb6.1747264138.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <9a9db594cc0e9d059dd30d2415d0346e09065bb6.1747264138.git.ackerleytng@google.com>
Message-ID: <aN74Yt0XvOkRPnFh@google.com>
Subject: Re: [RFC PATCH v2 10/51] KVM: selftests: Refactor vm_mem_add to be
 more flexible
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 17B30180006
X-Stat-Signature: oaonku1a5efgbgjcquamfibdy7curkp4
X-HE-Tag: 1759443044-25856
X-HE-Meta: U2FsdGVkX19O+hzMYqh/PkGVHe3zITu6cGDA05EEsjGEtCkDHnlnw9Rpb18JX9mi1klWdfkBfRg4TiHQVcxWJ+xVZC+jsHXdH4c3AQUT6J9dRzUvDmJJvLOTbO4yRpzdYdQu8ouBNjy9aGpeiQ7rqItSVOIXArcTUVAF8vT7amu9q+RqoICOGUuQ/fryuKpqlVGbk+yfJcknDAyt5XL0ddEaw7+8gsjw6bsihFsG6jJOwjjWCfGegZRmXqzRp573Wn5y7YWPWJG7pDZVKUublTJdtlCnbKMgfCHrRQmb1sVt6BvMXrJRtxpG/L8jEg0GpDVUZLiC4Z6YIhfLR5gI593Qrnl1eWjdyTargHU2yokpQv+ZyppmN/2vzeCtPy9EyGy5CbEGFYuAmFKYrlznX87LBbHPIzQDZrR6p2Su1upi8Z++lAwDhkEr7+PJK03Hz9e5JCwHZUnIC/bSbjcyl/PvSBqgo+N4kUWksCxbY2bgWpMM0qTZILPLGbj9qi/Ggn9j/CwTrTB5s4WqZRRaD+r/W0cI1EPrj322XgjuzZcIQzr9Y9kxGqflC7zNU+cUW6WuiKOUovgbNcsX6jvoIn0ECkTavyv2AI+dcAmZg1O12fGdb73hbBsi7BntKTW5hR4BEeW9zqe09yVi/B1PYSa3bT9t+zouZYWCSW4QzHm03NXJQLPOVRzNoZ+uoVqguqQx3Gsx4vzsRCo2eqg+7p09b9LVW9+jNyUjovMpFxAZNCbxaFx90nu5tYNgHdEllYXdF/u545QsLdmqJkBQ1cJo5kgfq+Kfxisx4MUus9Mxw9wIZjMZsMf1y5Mh7w4rqo3mLIDn0rltKy9a2ntvxgfy8kdr2cBDX8WnwJYQ6+64VwPWfG5Xy8HTb9T3zcpWP3hcmxYeYTmGM66dof0lxLJKTXU4GSw8rlOdcR2fWO4S7BdZZBG+2a6T2+0CFNMWwukpWSpP1hshiqUB57w
 Pr/vYW5+
 3rATYEIpEFI7RgtKcxdC0gdr1cftOSOWrIDlPAt01pCKwGjDxQ5XzoOplRt2ZTBoqPGIlK2hb0zGKIf5t/mBcykJ9vffBKW/YNgKiu5aPkpn1Mw5+H2JGr7R024nDnW7Cx4jphUM7iwyw2RN0cSXbDMumDm+mAe9lW+tPWd1WjZIzuiFBizpzZ7jF9BrDjCI+sXZyY2nKqgkxY2oHZkUcFgg3D5oyh7C6YtKok6obWA1+v4LvPwmVetSStY2lNKBtVS6f+Mi3KghtS30LaY/lbR+zcw/yF1UsD5VGgjtyh2w+fa//KHrJ1BhymC4pFgYHnXA5U4nFYD8T09lTUahjy5cJ8yYdVOCbPE/3XCClrofe8yujhSnJUcjV3hvZDGRXu8+hevzEOoY0G+DdttwIp79AN0zQpvzPI5EX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 14, 2025, Ackerley Tng wrote:
> enum vm_mem_backing_src_type is encoding too many different
> possibilities on different axes of (1) whether to mmap from an fd, (2)
> granularity of mapping for THP, (3) size of hugetlb mapping, and has
> yet to be extended to support guest_memfd.

I don't disagree (I added the FIXME after all), but IMO what you've done here
doesn't improve the situation, it just punts the mess to tests, i.e. lets the
guest_memfd_conversions test do its thing, but doesn't actually improve anything.

A test has no business dealing with details about "installing" memory or even
mapping the memslot.  The whole point of the core library is to deal with those
details so they don't need to be copy+pasted.  Adding a gmem-backed memslot
shouldn't require this much effort:

	region = vm_mem_region_alloc(vm);

	guest_memfd = vm_mem_region_install_guest_memfd(region, guest_memfd);
	mem = vm_mem_region_mmap(region, memslot_size, MAP_SHARED, guest_memfd, 0);
	vm_mem_region_install_memory(region, memslot_size, PAGE_SIZE);

	region->region.slot = GUEST_MEMFD_SHARING_TEST_SLOT;
	region->region.flags = KVM_MEM_GUEST_MEMFD;
	region->region.guest_phys_addr = GUEST_MEMFD_SHARING_TEST_GPA;
	region->region.guest_memfd_offset = 0;

	vm_mem_region_add(vm, region);

Again, I agree vm_mem_add() is a mess.  But overall, this is a big step backwards.

> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  29 +-
>  .../testing/selftests/kvm/include/test_util.h |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 429 +++++++++++-------
>  tools/testing/selftests/kvm/lib/test_util.c   |  25 +
>  4 files changed, 328 insertions(+), 157 deletions(-)

It's also not reviewable.  There is far, far too much going on here.  This is
quite obviously not one logical change.  The changelog is appropriate for the
cover letter of a decently large series, not for a patch that touches core code
of the selftests.

The massive refactoring is also unnecessary, at least for conversions.  With some
prep renames to shorten line lengths, all that is needed at this time is to dup()
the gmem_fd into region->fd when the gmem_fd can be mmap()'d.  It's not just a
clever hack, it's also how we want gmem to be used going forward; and for non-CoCo
VMs, it's the _only_ sane way to use gmem.

The only scenario where a test would want to shove a different userspace address
into the memslot is a test that deliberately tests that exact scenario.  And that
sort of thing belongs in a test; core code should only concern itself with the
scenario that 99 of usage will want.

With this, the test can do:

	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
		   KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);

	t->gmem_fd = kvm_slot_to_fd(vm, slot);
	t->mem = addr_gpa2hva(vm, gpa);
	virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, gpa, nr_pages);

---
 tools/testing/selftests/kvm/include/kvm_util.h           | 7 ++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c               | 9 +++++----
 .../selftests/kvm/x86/private_mem_conversions_test.c     | 2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 45159638d5dd..de8ae9be1906 100644
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
index 885a0dd58626..196af025e833 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -944,7 +944,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int gmem_fd, uint64_t gmem_offset)
+		int gmem_fd, uint64_t gmem_offset, uint64_t gmem_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1028,7 +1028,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			uint32_t gmem_flags = 0;
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1049,7 +1048,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
+		region->fd = kvm_dup(gmem_fd);
+	else if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
@@ -1116,7 +1117,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint64_t gpa, uint32_t slot, uint64_t npages,
 				 uint32_t flags)
 {
-	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 1969f4ab9b28..41f6b38f0407 100644
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

base-commit: 3572aeafd53394f4bf0a61d79c5c1b8cfccc3860
--

