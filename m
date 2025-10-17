Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906BECCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9498E0029; Fri, 17 Oct 2025 16:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72CB8E0006; Fri, 17 Oct 2025 16:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C7C8E0029; Fri, 17 Oct 2025 16:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 875DA8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F607140263
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:42 +0000 (UTC)
X-FDA: 84008704164.21.B8702BF
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B3CF14000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sbgjJARK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3NqPyaAsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3NqPyaAsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azUJ8YbBz5p8iXsJA90gvxNkNoC7gBdMtAmKtMeo9eg=;
	b=IAHc2tNbpO/GVVb0drG7s+Fok+e8hM9dQ+CROh6+9w6ralOLUzLutDdOXmHkipi9j6Pp6N
	FG7zhvllPMktTFbhBEtFih1wqDuQcQ1G0hVBg2Z3lJUUm5pckEoRPljbRmRIfJF7HJh6nx
	ApOkoFHMi2M//8mPPZe0muL/yZOCAlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731960; a=rsa-sha256;
	cv=none;
	b=HZDSILA0B+jSksuVhzfJgregb35OEM9kGUK7BxbwFEUFAhUUXDroNS0NNL0lV7d9JYiEV4
	xJRsMz7T1IRdmnyhqzFZSmuC+ypdGliv/aSFCS3DYHEMX12vy5qVuFIJYo5MzffEMASt3a
	NSLXJ19Nxeni1y/X0gOO0hbYgMMIydI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sbgjJARK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3NqPyaAsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3NqPyaAsKCJUz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2904e9e0ef9so42751515ad.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731959; x=1761336759; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azUJ8YbBz5p8iXsJA90gvxNkNoC7gBdMtAmKtMeo9eg=;
        b=sbgjJARK2BhZNRzS2YZATCVouktVK95wuEZfyvWxOssm7s/yO+Ox3eeqxAN2Fe7CSV
         FgHWS+S4Vmd06ta7rEwHb9cE5hpmiBI9ICT5PJc6UO6cb6t13e3qz0oIdCnMa7xApOoT
         aFNL1+zuTeeiygUtlhKZg6c60NRdTGHUlG2ag4g/4OkOwqKJsrHY1hbL6Ta8DKQ1XaUl
         7z0/N7FH9aerS+Lixl4b6oyNfEzqX0y9zh4ebcMczlVw/CMhTNqs8fwzENi5ZzWV63bT
         k2H5IWzAd1oU9DHUI1U6NHrYQFRKFjbT1TjEdlHYNBxvzrx6VIVulZ78Ty7xXa0q74KC
         KCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731959; x=1761336759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azUJ8YbBz5p8iXsJA90gvxNkNoC7gBdMtAmKtMeo9eg=;
        b=Bv1njEOZ9/QNy0BTcn8ZwPda5rZlMVB3/JgfhcJlOZFInIDqGaFrMUPbK3NeJqHQp9
         u3mRnPONDRXQcuR5xzFv4FiU71bVpREFLvq/NNkbES2owDG7qHNKA53RuM1UJRpgQBBh
         NX4Xkbsp/lkHknRMtfEX033Nok7E1E+XNh6goY9GBct/HkgR5Fjovs+9qWEfs+FJzpBM
         gm+1HgTbsc5+4Ldu/8iYfrSNZauDVdsa588auMCDWu4XWnoEIqRwyrZP2j3jVBc0AxLo
         NIIddw0lVzfNiY3QqMcvyjcjK9bePK2ENq7gG9v7HlTGNEnAXeBh9QdqY+J6yTisi1Oa
         kanA==
X-Forwarded-Encrypted: i=1; AJvYcCV+RuMZj35dA5/sGrfv7xkxPurA4bb6Tcx7Ujbf/vdF70ScqjUA0iz3WGuIKcsFjTyHCmgplMallw==@kvack.org
X-Gm-Message-State: AOJu0Yw+iGCFyBYA334ataysOn38aE/ozryy4/qSkQW6IOkgvKOOonQV
	gLK/iPb5Cq4pz7/Ha8Z8RUOcQX4itX/Mk+KUbcHvhz1mu3QQgiIF5d0akbJz2ZCE83mw55JDZH2
	Dp6hBXbkKhKPlQyjPpYA4vTSI6Q==
X-Google-Smtp-Source: AGHT+IGjtEU34dqqnybB19rBgoWD/tF1TyeATlVnN+HcnvWeM3cm6kpWoOjHHimLdS4u0Zp3tLd6gH6GokckyTqWLA==
X-Received: from pjbbk24.prod.google.com ([2002:a17:90b:818:b0:33b:a0ae:940])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cecb:b0:290:c94b:8381 with SMTP id d9443c01a7336-290c9c89dbbmr63619355ad.7.1760731958742;
 Fri, 17 Oct 2025 13:12:38 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:47 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <a3795f7fb4f785ced19abe18c2f33aa478c4d202.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 06/37] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
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
X-Rspamd-Server: rspam01
X-Stat-Signature: mu9quh8rs5w51zaoiue4yp67gazyiic4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B3CF14000F
X-HE-Tag: 1760731960-751962
X-HE-Meta: U2FsdGVkX1962TfFiwqxM8ZVRRl2Fs4qhXzGaBJiNn55ZFjcvEp+3i3JwccdTHyxIUXDBMKBRDaoAe6cFKUhzjWE7HhoNSIVllWp1GjEK7EQ6nWVG+AECCJRvTMzjtNfkL1EmkMfdwqcW9Ikl017ng/6zp+JwLkAkRrQRQpDo5SHTGiKfSEj2kiJlyY7jPAFxeY9XUT3+LaTVjimW3DiVikzOIVrTHF3LR0BtnrO+DvwvGjavPOHO2VMJyhwBUwDT5nRv9znT559OaDOZ60Pw4nNxV8rUKBbhcyvx7LsnNd3ltmxGdNS9I1uMaI+CytpzsfLDOgiucsXXrnDzg3Ih5YBwbu/mTFszy6AXUjPDWKwoJ+bs2luUPLL6hTBjusVwmBWaf6xLwB3IaNaG6e4kRJ5Z/BM2GV4pYhVeMwfXYSpOPrSDGv6tk8ulW+xq2p9oHZFLTHfznk5O8yiKUj/gvlWqx73b/j2A38Xo5XYSRY/U3nvmVfSuX3dUIhyXpF700qOEC8nzjfAl4yO0oip4rQ8Gd9S4LmhHKqvRjC9i8KfifziEeBJg8zgCHelX7lLF/UPVpISwRn1vJRyLScqnv1OMHgOn2iNKuCWghtxfjarPiIhFGrlGyNm3bwPT5FhtsaWHtKh0yiJDm4RShXoqhIrpx9IY/11c4YMcOmze/fdJTm4exumBotS6gmLKDBROdHTQ+WgMyb6NmbZ2btLI0Tlwt6e1rbP6qKTtCsXCe6A4HRcT+N1556KF3+Ial1HTquDsIw3TBlUAHx9TBwzgD1KIphCKcWB7ChkTK6AzGviGcrRp6IT7jbOn8S62H6KPiseLQUbsQhC4r3kCRcmBsiFX5ZU7TcSu0Cmj7yp1S21HeZ9+9FBXcxHBTMHS6JfM7mPBCEk2GoClwI5baiSzUwuMa75zBXGS+EoBCHNTFVxTkCVKgFvqY2Vx8IgAVxnVpNeR/3DoRwiNgU8sgb
 f2a3WL7y
 MdZWSg094qNw2b88LLfhU1n34iW875ih0I31HsyYQ2cWP5mU8rW0bEnwlPFsJQ7mdeGlOrhvh8pSo8POTFIdiSsfz/C98612Azbe2qwlewJ6myMcJ53CRtE8HKpwC6AjIUHuMCnEwlQ9IIBEJjl+b+iR7837djM6rVkMw5r0KDH10Re342BfVU5gKoVngNkdU7O1HGMARmT6KWUl6YHSP8uSom87p0wDgkOkXgT4gjtOrGa3H6ydDutWyUfBdxFne5COVRCgaTzBZqyJV6IK46DEPEqHxNkCwJz/Hw0Ct7EICzsJYH5Bjt/2QEAGdXhWInVCsrkGLlutDSBYgXLeFplSD5P3i01UWM1frQmEunPnUotT1eSbd9EE0uxSJliYLfM60KmY/66NkeqZckI1zQNtM6SMjRmAbPYfXR2GHGe40KK0yDyrkPAVj/KV9cZxxRUmFUz3fjLZ4UCIQnlH764xB241HzPdspeMHozwJ3JBLlQ1nhhOcFZeLWZ1P487suXwfDG32vldrkU6Bl9HBMTBSgMIx5FeBRXH9/0zr+xmAREKjhbwzluTkB5Z71eyhAxp1d5E0SEGBtPg5HAxImwU1gQoG8/jsIB1r7IncjOMFORZCS/wyPrSpqiFodBpGUhdG6W1rSvlJYNwJfeuOe/6m+Hv8W2K5zpxQFPa3CQeZcOetKzQDl7ePoksncfgjwMnoanN2yv9ObG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the guest_memfd populate() flow to pull memory attributes from the
gmem instance instead of the VM when KVM is not configured to track
shared/private status in the VM.

Rename the per-VM API to make it clear that it retrieves per-VM
attributes, i.e. is not suitable for use outside of flows that are
specific to generic per-VM attributes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h |  5 ++++-
 virt/kvm/guest_memfd.c   | 26 +++++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  8 +++-----
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4542b37b0db6..52189853cf4ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7897,7 +7897,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8418cc5851f1..b48632ee242b3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2535,12 +2535,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+extern bool vm_memory_attributes;
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
+#else
+#define vm_memory_attributes false
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f62facc3ab776..855e682041311 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -907,10 +907,30 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
+				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	if (vm_memory_attributes)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt_for_each(&gi->attributes, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
+	struct gmem_inode *gi;
 	void __user *p;
 
 	int ret = 0, max_order;
@@ -929,6 +949,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
+	gi = GMEM_I(file_inode(file));
+
 	filemap_invalidate_lock(file->f_mapping);
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
@@ -962,9 +984,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		while (!kvm_gmem_range_is_private(gi, index, 1 << max_order, kvm, gfn)) {
 			if (!max_order)
 				goto put_folio_and_exit;
 			max_order--;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c73ebdb73070e..35166754a22b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,9 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static bool vm_memory_attributes = true;
-#else
-#define vm_memory_attributes false
+bool vm_memory_attributes = true;
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
@@ -2457,7 +2455,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
@@ -2591,7 +2589,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
-- 
2.51.0.858.gf9c4a03a3a-goog


