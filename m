Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA3CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FF58E000D; Fri, 17 Oct 2025 16:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9538E0006; Fri, 17 Oct 2025 16:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D8A8E000D; Fri, 17 Oct 2025 16:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5AE8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DFFB1198A3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:33 +0000 (UTC)
X-FDA: 84008703786.08.CC7CC56
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81D28C0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kuq0iEIl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3LqPyaAsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LqPyaAsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23h18nOdPjrep9qeiUX9eD9XykFWLhPvQkHoEMjMhTg=;
	b=X0g+dn8pq9Ae/wq7tdicXfP8z6A/gF290Y68jUGjrFPjmTNXblzcOPDArOr3mNh8pzUdwo
	/3v5LgeYZ2Yzi1DezwbLF5IlOYmjRrbYgZx+7eOcH4DLc7QzRdGR2R4akURNt9GOjp1tzW
	/19AkzSWLanqsyRyjCAccNSgEyxzKSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731951; a=rsa-sha256;
	cv=none;
	b=fExnzv0aOlVV6+tkBwhtnrCgiYwT0+4lg1K0DIQnOuNjOAJZHymrFtvUau3QVsHwcSLL6I
	pdH0V9dvjsQvzfg0F/jCljzZFGeoosbxtEFAvIL1G8fWAEFxmXeHyEPjtSsjHQwwT7zRW0
	RY0XEFjAI3nW2XSLmnRDFeefKgGzW4U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kuq0iEIl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3LqPyaAsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LqPyaAsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so3889217a91.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731950; x=1761336750; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=23h18nOdPjrep9qeiUX9eD9XykFWLhPvQkHoEMjMhTg=;
        b=Kuq0iEIlfSGORBpUIG/Lgpyp/1bA+x3+H/s0DGlKyg3CjRMQP2yQEYVRC3iF0hMuj9
         xJ/vID+BjCL8stVUvrsuGAwt9HcYGGHXYSXgck814fXixFnGT8/gEtlKGGNzdCJipjuu
         Ia/mNinD+3LySzUOfSPxQ5CYKzNpBRjGN98We4VpEkudYpdIBJ9DL1JvwN8HzWuglt5i
         4wN4k9Yu/6E5XPM7kK3GiAP3/P9dISFxmPH5t8N74/DPFRYC3pHHfa8t070kf0X+DCX7
         3Fff+Eas09tT34cphT8rHI9PjIfgor+GsOLrHzQ21j3zYxbLVNpfe1jFherF+jESTCvJ
         1mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731950; x=1761336750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23h18nOdPjrep9qeiUX9eD9XykFWLhPvQkHoEMjMhTg=;
        b=K1UoFoCPPfhYM/wx5lDsvfg4zRd3yHy89FwaI959qcwj1U7LhCWFHh6JHgXS57rao7
         ZO5kZs6+ytaL5USrJJgTevC7/knGufkYY0lqWjekAhOr+h2ibMXGDOTZVnSkXuwoMxU4
         j3lVCGC7vS+aWSJBHPsqzchyE3zwC/tTkv8epCB1BlKPtwXtZCO0/6iw4FIMTsX/iw+q
         2AQPdzzWZzv0e7+08SRDTPoK6mORTpxnI973JHND9knIV8OTEC1P+VEx0Gy5tHnUSFwm
         wqzH8TKIZq/DmLIdku29z9oo0vqSSIrix8ZdEGjv2x8qm/XLJ2mhxzyq4Rtgj6pMWDtx
         E2Pg==
X-Forwarded-Encrypted: i=1; AJvYcCV1W1Bc61USH993JfpZGvG3S+gVcnJ/efyQvzHHzV1bJ/1SSE0uF7QjqrMmJEARNxbsRVVpqlb+Ng==@kvack.org
X-Gm-Message-State: AOJu0YzvZ8moISUMfxNd4HKnxsb1TlDOBCw5bjMwCQDKgzQtEdQYvHDg
	NOc6li1c51NeU0ZtytTPQ4kps3JmAOL1G43IM+RLRrAYVYVKZS+HtODN9VPYtmLth9n3UbOZFk/
	8CdTxTbQml3rtbjvZQDzVTt+SlA==
X-Google-Smtp-Source: AGHT+IGzIMHx5sxfwAd/ggf5vwDMz3obOs3omuhPz2fGRAWX79j+Sw8ihvoUsiE28s/7yqNKxtqfmUfdmtv/upqGpA==
X-Received: from pjto24.prod.google.com ([2002:a17:90a:c718:b0:33b:51fe:1a81])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:35cc:b0:32e:43ae:e7e9 with SMTP id 98e67ed59e1d1-33bcf8ec899mr6732034a91.17.1760731950177;
 Fri, 17 Oct 2025 13:12:30 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:42 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 81D28C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: 7q4nq4kcoo5mf19559tjznnf7ms4a5tt
X-HE-Tag: 1760731951-330411
X-HE-Meta: U2FsdGVkX1/ePYDQngcJYYp1Ja0jS4y/z/9LKAjs7pZv5avxnBJiCp13DM5yX3L3Uj/4kOWk0kXpb4Z4LAr59iT0NEc2FPMCvI9qU9AjAUsNP6EYLaenOluOr0W4Hnt1s5lzXe0NHpdY0zmfTGgMmTaONWmGdFGedDL5I1ytaNGcN6U4PfCLdJUm/rwMmehpTXNaVTRlq3JUrkeL1FM+ovtVLaFUZX3F/V4/caJjo3vz7D1DH3u8U3DGkVJJAy/PKt4KtrYJG38VnWCGyeyV70tHOZbXUJKN2oqXsxn5IIUr4a+/w24t+9scWqtP6GkchbVt1Nc076pC6sulKCE6c7SvjrYUxHGa4EhTxWVXvP2PRqLWQl6Rrs+ptDyMv4bHmXvjLaSeCV52L5HjkPb2Iar/lqrznqWB1CqC3GftEyXrdf3xtyLKubh2qT8l9B+ErLomI5UeF0gUJS6h2cOZKrQle/7Z1FeuGT/QvbJFE4wZ9CaflII8ndSjTkqezSZYOjX/wSSJl3uWKPTmm/1Hr8R0hwTYzyqo0HtzXoXFgl1gJEbkLfl6Et/Twc/iswYOZQ4Y3ITg1u3SmYsBFhB0+oGOzu3+YgCvtKlUWYnxLYKzyu8ihIAjGKgBeEVUEb73Rc2Gn/6YXR0L+Zqile1q7G84nIKWhgXJUEyXy90H9xBhtN9oS4SqkD4SdR0QMADyAzEkKRmtBV2gwGHmcJbMIrTY2RlMk84RRYGEEMembQODjAFtz7HQCmrnMoB24d1Eq9ouuH0YWUujsCRR/seV+zoMpW/rju/7j95dUL2iNE43nL/CKoUUACQS/OzUITanRGTIu19mMAjYQMhvas0XrlRcCy8eAbxnAN023EohCAsKo21OFHCBvsBaD429bMzjR8TBbwO+ewqv9EE/P5np9eDrTxaYgCR9XWEq6mJTHPRPapQCbjYU0PIq94/ljz+LHnwC+ESHA+GCbQ2yw1B
 FnyGBuOP
 a82Uzs+UgRFE2zv8WJLC1W0EP1B3VADz9nBvyocLnBIxhsKdCVxyFPJ97GrhrX5JuMKovqljpCfCgBoO5iDcb42OXwA4n4YgdcaX2GcWzK/I1i2E59qdILW9VfXKEk6GcdmrtMQRzlPT90+y94w368bqexCfFWEP8X0OJmhh5EyCYHPg/6odUFs34FQyIUJNMasNqGacgC7GDvupoSPgdi8a2nKeu5LbsJ7W8xZ5aOKHyy9eSboAUY/qyrbsduEcqfS33PvNGXVTLJDJLIJmigIlsb4p5sWCivv0gcp+n/8CnbsM1kCxrgumVgGMVOYDJrHcOQPXqstd/PE5LxQo6zzzpzYbv1Z6Ub9ELXpqqLMNvJp5mypJu5AOAdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Start plumbing in guest_memfd support for in-place private<=>shared
conversions by tracking attributes via a maple tree.  KVM currently tracks
private vs. shared attributes on a per-VM basis, which made sense when a
guest_memfd _only_ supported private memory, but tracking per-VM simply
can't work for in-place conversions as the shareability of a given page
needs to be per-gmem_inode, not per-VM.

Use the filemap invalidation lock to protect the maple tree, as taking the
lock for read when faulting in memory (for userspace or the guest) isn't
expected to result in meaningful contention, and using a separate lock
would add significant complexity (avoid deadlock is quite difficult).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 119 +++++++++++++++++++++++++++++++++++------
 1 file changed, 103 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b22caa8b530ab..26cec833766c3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/maple_tree.h>
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
@@ -32,6 +33,7 @@ struct gmem_inode {
 	struct inode vfs_inode;

 	u64 flags;
+	struct maple_tree attributes;
 };

 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -54,6 +56,23 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }

+static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
+{
+	void *entry = mtree_load(&GMEM_I(inode)->attributes, index);
+
+	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
+}
+
+static bool kvm_gmem_is_private_mem(struct inode *inode, pgoff_t index)
+{
+	return kvm_gmem_get_attributes(inode, index) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+}
+
+static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
+{
+	return !kvm_gmem_is_private_mem(inode, index);
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -415,10 +434,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;

-	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
-		return VM_FAULT_SIGBUS;
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	if (kvm_gmem_is_shared_mem(inode, vmf->pgoff))
+		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	else
+		folio = ERR_PTR(-EACCES);
+	filemap_invalidate_unlock_shared(inode->i_mapping);

-	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		if (PTR_ERR(folio) == -EAGAIN)
 			return VM_FAULT_RETRY;
@@ -572,6 +594,46 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }

+static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
+	u64 attrs;
+	int r;
+
+	inode->i_op = &kvm_gmem_iops;
+	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = size;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_inaccessible(inode->i_mapping);
+	/* Unmovable mappings are supposed to be marked unevictable as well. */
+	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	gi->flags = flags;
+
+	mt_set_external_lock(&gi->attributes,
+			     &inode->i_mapping->invalidate_lock);
+
+	/*
+	 * Store default attributes for the entire gmem instance. Ensuring every
+	 * index is represented in the maple tree at all times simplifies the
+	 * conversion and merging logic.
+	 */
+	attrs = gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+	/*
+	 * Acquire the invalidation lock purely to make lockdep happy. There
+	 * should be no races at this time since the inode hasn't yet been fully
+	 * created.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	r = mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	static const char *name = "[kvm-gmem]";
@@ -602,16 +664,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fops;
 	}

-	inode->i_op = &kvm_gmem_iops;
-	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mode |= S_IFREG;
-	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_inaccessible(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-
-	GMEM_I(inode)->flags = flags;
+	err = kvm_gmem_init_inode(inode, size, flags);
+	if (err)
+		goto err_inode;

 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
@@ -798,9 +853,13 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;

+	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (IS_ERR(folio)) {
+		r = PTR_ERR(folio);
+		goto out;
+	}

 	if (!is_prepared)
 		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
@@ -812,6 +871,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	else
 		folio_put(folio);

+out:
+	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -925,13 +986,39 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)

 	mpol_shared_policy_init(&gi->policy, NULL);

+	/*
+	 * Memory attributes are protected the filemap invalidation lock, but
+	 * the lock structure isn't available at this time.  Immediately mark
+	 * maple tree as using external locking so that accessing the tree
+	 * before its fully initialized results in NULL pointer dereferences
+	 * and not more subtle bugs.
+	 */
+	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
+
 	gi->flags = 0;
 	return &gi->vfs_inode;
 }

 static void kvm_gmem_destroy_inode(struct inode *inode)
 {
-	mpol_free_shared_policy(&GMEM_I(inode)->policy);
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	mpol_free_shared_policy(&gi->policy);
+
+	/*
+	 * Note!  Checking for an empty tree is functionally necessary to avoid
+	 * explosions if the tree hasn't been initialized, i.e. if the inode is
+	 * being destroyed before guest_memfd can set the external lock.
+	 */
+	if (!mtree_empty(&gi->attributes)) {
+		/*
+		 * Acquire the invalidation lock purely to make lockdep happy,
+		 * the inode is unreachable at this point.
+		 */
+		filemap_invalidate_lock(inode->i_mapping);
+		__mt_destroy(&gi->attributes);
+		filemap_invalidate_unlock(inode->i_mapping);
+	}
 }

 static void kvm_gmem_free_inode(struct inode *inode)
--
2.51.0.858.gf9c4a03a3a-goog

