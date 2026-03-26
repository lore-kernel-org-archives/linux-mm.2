Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC29C10AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C036B0089; Thu, 26 Mar 2026 18:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3628E6B008A; Thu, 26 Mar 2026 18:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B196B008C; Thu, 26 Mar 2026 18:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115986B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C207E160EAD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:28 +0000 (UTC)
X-FDA: 84589644216.20.29F2EBF
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE07C4000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GlJ53G3l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3GbLFaQsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GbLFaQsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563866; a=rsa-sha256;
	cv=none;
	b=glqIGgmWKmJwR0m73fSZ3EpG2G+GNVxLnCbw3nQ38IUEvvcKF04r+Xb4GB9J4jpWZLbJS+
	woanhae/NLDBMhVS75yinUiR/ZMQATRjeAEyE1kF3aJf1eLZkaRf68/9jeQVUX/hfLINbq
	s2gWajtUHlOy4WHY9hliEwEWF+vZJJo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GlJ53G3l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3GbLFaQsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3GbLFaQsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvLclgOKHNaEuz+5qe94Ple9yEsi/Y6tRhhrH2HYDiI=;
	b=joFvI7/gbjOjlPwL+euSaMqaxcl61jsFZ539j1KlfspFQpT05/PthMX/BSvvzKn0BFaSF/
	6/zFsq00rA/L7k4rO7JIrFnJ42PqDKYCed7iFORPsOx4AYqixd92FJBqfiTyAtzDuMGk+n
	w8PDH3lUICXUuoxNSYbSh3DGznnfJ60=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7656dba76aso932974a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563866; x=1775168666; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvLclgOKHNaEuz+5qe94Ple9yEsi/Y6tRhhrH2HYDiI=;
        b=GlJ53G3laeAzZjZrhLaJKs5LPd5ofyaxSGN/u6XPZbWDiyoVjIT9eD/nS/tioNIPDA
         q7ycbMKvFKhvnMRRvGGG+3LNXxceKHrsDb3vho8TsUw4K7x7WWJcCczNYnKR3dH9yuHW
         7RVacIKDjVY9pfx/P99mzZPZgvjiseVvsDJeal13HoceXyU+6KiZrsVKrgEKiYhgG4ge
         JW6OyiivBVi0m8nFQBD8CXg6UmC1sgmqgJqc3TBy+cZ3MGvF4zQu2JM/xky0hqS0YoN/
         jBv1PqW5VXiw4qrCJ4vzvcP2BGfmOTDZzm1gg7BMSIDqaL3ddxZm9EcZdk86heLyQe9u
         Tztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563866; x=1775168666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvLclgOKHNaEuz+5qe94Ple9yEsi/Y6tRhhrH2HYDiI=;
        b=TkWV1Q2xGcDVxHUGgYYNx3ufUXLTljLN7CbVAlPbLUNARYRu5fwOMqsyjpwIciexxU
         B6b3IpXKetL6RV2/F1gXIsmN1No4xvN8wFDYP3lhfav+TWkALaQvhQJsgbA8ssOaqGeA
         GnQwmyAQXUOCp6jHjJ321e0o12JREUqg9ApEAcaMppxSNxCe1OHOdXWRJawv5xd2Kn7d
         UDlc/NfNBV2oAb/ixJI15NLoNDqkHAu5iAhQ6pzCRYrvlm7RtPJnjnqUZnsWgaMf1Nph
         iKiAguUJESxMQW+DyJ/A+Ll5hElq6y7ZQLDg8CNtrl/I+hcGdsy4tz33LNrXhVspF7ql
         Ow+w==
X-Forwarded-Encrypted: i=1; AJvYcCWSc93OILIwns3UvRKOEKzr3VJjtFuhPa56dwlrhK126w8S6VJxNe87EKD4Q0tR7AczK0YylyRVcg==@kvack.org
X-Gm-Message-State: AOJu0YzUmclqJsVMcyecoR2/vAwYSIQDaktfUpt0FEqiLNwroGi74y49
	LyPJ6gtSbD0UhaWpIDrSqJ1ID9PWjmgs0xiFWTpW732u8n81caH53noK9/Io7wstTOrApYt7QNS
	034nlhPkEcT0I556sTzymTjSKHQ==
X-Received: from pfbdo1.prod.google.com ([2002:a05:6a00:4a01:b0:82a:69ed:da7f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1c91:b0:82a:ea3:c172 with SMTP id d2e1a72fcca58-82c960a3070mr122788b3a.46.1774563865140;
 Thu, 26 Mar 2026 15:24:25 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:10 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=8353;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/7d+6WxzM1yQ/r5DfFDHnWSFoF6dLqT6urgJkYmJFIc=; b=aNo2rFWL2T9tXzUkyVyzAyRPcD3TrDI87hbSexDY3eJptczvfKo0duBcnObyazM0GuJIUyfeC
 0gDwAwcBGMbDhQByr61PqkADsvCAd5UUFA+y/oKrj5z9l1Jq+K1IFep
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-1-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 01/44] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
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
X-Stat-Signature: ewt8dggddmgkbn3tth4ijwwriduz5mq3
X-Rspamd-Queue-Id: CE07C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563866-9914
X-HE-Meta: U2FsdGVkX1+qiKM/g+ah2Bf0b+yoI8GhPPDFofge6X1GZgAyFOCYQeXXBZEXMQVA/QIv39Pz/bz+7zsesN5nuKkznAbX9CJwWx8d6TkX/0r7cnDrt4Jgzl0YRfAgo9XofT/4Vk0jcg11u7lFms7TgEDOCImwtTu3Ro2WHi+8IWLaxitbC7yRUVsgVFypIm+n6q52lznlKM+iI+ujnM/TuJC8476Dk3UcRIxGt7K1IauburR9ro6bNogKDeZ83u4gqtvwAT2V2wgGXhgWCHWM1AVG9Nbxl96i3UQz+vIz8hvQK/tm0jYp6RK09iVRJ7GjHLcdNRb2WBaO+BtzGcDC8MKv5G77Yu9H9VDZby4YKv5FtxVUKfJ9BAxXNs0DZLtWWS2BBugqutoqFkWD2HspHJKrRhw5I/QUulP1tIcW6ZYJhbIK382VvTAabHwtdcxtMVw7zpmBj5qSXSWdVbQfp8dJKozWmB20L/Rr6frfOwQTTnHbT6PJ9DV2RhJzQq/qzLrsz3QwbjQOeipa8LN1VykwZJnzlRXhNnNfpeJdGelEZbEO9vTvTQC/nxSsLsx1WO3UYLpzFfAG/Gx0+xLQDsvFLDLM0/H/bN79gyKl+KlpERii3I042KeLZsDz5Xm5xw+LOpBUyxmNCCqh/udUOhCqkgvoT/O+oHYBGroaWRZ+xfyDOrgke38J9NxkPowS/zHY27FvQmtgdSn+O7JugU17KQ6ANUpGrTcoKcI1ti3Yrfb/nVu6nBIW0HNDb9eddNCNTf8sjRobpaszM6jmkghbGst3ekY6ZGTEvBwijcm8WedNvI4v7l99kyfITnMbaRxu3KHkcf5c1FL8G5ALHWKUypDXIISNiNRj1dujpJpXZHqVK/rmPPCGvaor8hkvSQ2u/h9Ltlx7P10FiiOqdScuKco5KnS9T0m59ihWCt/8oIeN+ZMXoQib07wYocxxtKsBejMKrC8M57blWGY
 etCrXvJR
 iBlBbiwyjX/xlKT/8T3KkHL4tPnP9oe1Ut/ThGg6wtyRVWI4U5gwg4JJprBoxcb6ef/xc9ycyl0EetPTe+qEoZX7zWYxtk6TSPccB3nhdVpOAghTJVFtSI4Q7LWuq04AhdJ1V2myj9+wRItk3mxFMJXvftEy8eQP8oxBvVVyzTlS9nIHRYh7+fK92sT1/YmnWAcbZKUZngb7MEP/6nVUtvvi6s3OoUvapwxruqtX2q/frUvTaGnhPNTJjR0Zcbe6tbcJPxo1jOW/jnhrYriS7UMpag42fX4iTnE5YGINlKzvkbpIs/Sioj7JB6G+bcjy6E6QHVSnPSEL09r7TjSikfp6RYfLqR9DTyuAmAGxCNqUoNs3ipi5sw6qE/yMumgWwtCDoklcQgXL2M8ngONdzbKfITVucYUxNpThP8D6JmieUqhWXYw+6bvCiIvzF6yPCxoO6cEqHLIeimo/yF6HoYE1NVnt4+dZLy0KJlOQoR9hc6aGtzQi53IcG92GtzB1u1YBA1X1BA0xxr2zWYvL64txf7OXLFgua4Za3L3Pvzxfvj7lKu2MtY4NGSoGvG907Q3B52u8GnAnX8VotTVpyk+qAlgQZNSd6z6ZyC9vB0Kr45xtxkH9LK2cY4z0hjz+4dEQf5dtugvTkZh1x4uYJvI79sNFOffTd808wTXxAyKftZYs+kysM0YEPsumgjvGd/vtcjzwcl3pnHWfgETMKIJmnlw==
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
 virt/kvm/guest_memfd.c | 139 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 123 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf37..aa2caf5114da2 100644
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
@@ -32,6 +33,12 @@ struct gmem_inode {
 	struct inode vfs_inode;
 
 	u64 flags;
+	/*
+	 * Every index in this inode, whether memory is populated or
+	 * not, is tracked in attributes. There are no gaps in this
+	 * maple tree.
+	 */
+	struct maple_tree attributes;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -59,6 +66,31 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
+{
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	void *entry = mtree_load(mt, index);
+
+	/*
+	 * The lock _must_ be held for lookups, as some maple tree operations,
+	 * e.g. append, are unsafe (return inaccurate information) with respect
+	 * to concurrent RCU-protected lookups.
+	 */
+	lockdep_assert(mt_lock_is_held(mt));
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
@@ -397,10 +429,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
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
@@ -556,6 +591,51 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
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
+
+	/*
+	 * guest_memfd memory is neither migratable nor swappable: set
+	 * inaccessible to gate off both.
+	 */
+	mapping_set_inaccessible(inode->i_mapping);
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
+	 * Acquire the invalidation lock purely to make lockdep happy.  The
+	 * maple tree library expects all stores to be protected via the lock,
+	 * and the library can't know when the tree is reachable only by the
+	 * caller, as is the case here.
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
@@ -586,16 +666,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
@@ -797,9 +870,13 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
+	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (IS_ERR(folio)) {
+		r = PTR_ERR(folio);
+		goto out;
+	}
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
@@ -815,6 +892,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	else
 		folio_put(folio);
 
+out:
+	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -944,13 +1023,41 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 
 	mpol_shared_policy_init(&gi->policy, NULL);
 
+	/*
+	 * Memory attributes are protected by the filemap invalidation lock, but
+	 * the lock structure isn't available at this time.  Immediately mark
+	 * maple tree as using external locking so that accessing the tree
+	 * before it's fully initialized results in NULL pointer dereferences
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
+	 * Note!  Checking for an empty tree is functionally necessary
+	 * to avoid explosions if the tree hasn't been fully
+	 * initialized, i.e. if the inode is being destroyed before
+	 * guest_memfd can set the external lock, lockdep would find
+	 * that the tree's internal ma_lock was not held.
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
2.53.0.1018.g2bb0e51243-goog


