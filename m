Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F898C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13CF6B00A3; Fri,  7 Aug 2026 17:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB096B00A5; Fri,  7 Aug 2026 17:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16126B00A4; Fri,  7 Aug 2026 17:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 660096B009E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF2471201CC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
X-FDA: 85075823742.26.9703D9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A11111A0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tu9qp0fC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dp2B1HYu8T6LJzdATobu+gWnSjnmzUw5YxABih2b+6w=;
	b=NOFZzLNMUtXC4ZIZWFxMDJu2+Vn4dpcBBDu9WmlhKjCY4beNsu9QYN09RiJoElFR8UJh5p
	HvKWCm3j+qqi3umB3c2/6LjnDFpzix3th6Pz6/uNQWh8sTnIFn665uiOnzkKZ/SiYDwKOL
	bhi48YObIG5DnA+5bE86YnVUGVX1VTo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tu9qp0fC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139569;
	b=hGwp3Zy69OWbc0OjThlr91WnybSU9knJmngS/QIBTzcySNF3w9gOa0+HvWQotnNpJo1tJi
	1a/0VrVN7dI3/4UXhOLXy8m33zesG1P1q32kuXDZs4ZZAv6OKvyOLTkn/17shK0wlt7bgI
	EomO0OMLUrubKVv6UY30sO5winOhqUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52ADF4406A;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7E3CC2BCFB;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=yJVooWS7ae6T4DJ/d7fNHTSwQ4/FQ/9iT74RjMBDS4M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tu9qp0fCgOU1ZQzkJ3xliAmJ8ZxuKuuuS6VelWzX/+nZBDPqsnXo379Nqk/LNtm2z
	 lgizkdMdLLhwx2UE4FTLVef/8nyikhDjNeX0o8tRHZJvrAuXHplsYZvnMqejPysxub
	 x/LC1Qk3fuEa+KpsWEe0TFmzF1NhxzKQXtvEQRhYd8bZNuCmyug1dUuOngodmAt8Ej
	 hP46pkcPfZ4Rd9M+iZXDfPX8dvfKOo70lFWEiAhZ5a5Dw4Nd7ZqOnvg4kCuFMLYewg
	 hJNV1d+HVEFNJMGjmbodrpgkYGOl5P95/yokA582HonZVXDO7dTOXwNHdWwNy+Cc+F
	 lbCP+BmDiXMCA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F37C5ACD1;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:41 -0700
Subject: [PATCH v10 02/41] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-2-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139564; l=8465;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1nOMPFicDBXgDI3srbMuJXuAmX4cJHFBglLbazHe5uM=;
 b=OiqsSQH799o+a0nXP1B8S8quubZv0zAEmDtuW7nunbn2va3CCzQqcfD1DgjWR9G0Q3GCly7N5
 q8LTBzZDLGzBZ3l9gLtanHYelXoY0vI5fRSyIy1lMUKPvigVI0z/Tan
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A11111A0003
X-Stat-Signature: 595rqrwk5ee6y4hohwce5xnyta7e8ozp
X-Rspam-User: 
X-HE-Tag: 1786139569-645599
X-HE-Meta: U2FsdGVkX18CSjwskVWXXDHvxxqJresbw8LBCF1kBptJT9pB+gElgETHdKtNroNS+k/w+P9+E7DD58+FIMTX7JQjB8kUoc/RNdwuqAJfdtsU0cxMtPVvgfCzQtAzjjj0NfNotHkzfeWs8kQt0Tat4kiwd4q1PdzFtiql5hRH6NEe+oPGIdAWmvhASqXW6C3lpRQmVqHx2K2EOk+dBBz0n+9o7qTzSTic6edVCMzHsogaVB4W4XMXQk24/X2SqAOmdlhMasi3Tzpp+/rHt5dKt9stJcazIvuIDd7NyTMZDh5Tzev+YRMMxLdVQF8Y0SGLLeyM7qb7qAqVyoJ2btYyazH2lihKyrAnqdONEk4xtHffAdtgg2n2zGPHn9zPTx7fT4Ksk/yU7q2VdbYiQ7xPkYlkBhOEZEky7XtNXMB3xWpZCUZR3fXrZJCpDys8aAe/mXN96tEbf341LTKimGh0L/j+fkfP2wtbphvdmYamrSiMNM99HxH4Iv+SD09S+EBWqiEQp08JrclJ6h59j0VjDgDIRRDnQuWaO9FoGGKYD4uyVs6giEUFOplphGqhinYF1Ipd1wyqYmGnZGu/CKEDS0NaOQ4OmyHACbDse1o+sZyAojbZ4MT1w6B+oSyoSnDYIAjS8omvviWfxVIrCh/J0xh6ZLOo7EaK25q7ZYze9FmLll+MrMa2B25JxUD4Fu16WXD6YPPnHqIOESTkONNJ0PmvOwEOBIgK/Fq1fHLtKSwjpffxJ2+J/rViAT/dlNEqTbvwf+ld+BGosm3sxNNOjfGNP8BGnuUW5WdMNZO6E3AGWW9W93JZ+rz6MC8ncah4KtDgEzp5Ur3qGxsxsYz3LdbVwgqiGy/6kmgzWMU5PM+iGGeyy8vg3YK6ly+1M9JnzWUgNEa17S3ThA8c0zRb5yth+vXoAN7RKIODXsNp4GT40LG3IF/QmnbBnOGQxLPPhjLE1ovX4/Y9hRQfTiy
 kzVTc4yS
 HEbXvxGxv9OUWFUnOi2fdHW8u9B8NXiSkJqlQS9Ad9qTLfmmN7+xRCSLwHrj+BUH1p3+SuEucdnKUP/kdv3nvVL6nvLe4aQOPAe7QL91P4R0XeEx1qsFPwVnxYmbHhMOaIIeQUG6LmPYlS9Vxz9iWrNWHapINZqoeGR2TDzkbd8/wZ9UcvBzxrs7ypPz/smijaRn2DdDHdI57aG28LiWgcaWFSqW6MiwWZuecu1gswlcTikLwqGiZKOSCqXhG6FtN7tt3NYnsMrtOzqQByaZLfcMMs4V1uR7smb0rjy0zz7tN9nEhXLkNyMeN24Jiy+ElpwsyxBiPgjOVKL0rjTFLilQlbFbORLeDxugRjK14PiRdiD1BiTuXZaYgRo01we1Y1qBHYJdP++Vx9re9zEEm8I0ME5/oRv8sYqlSEEapKSAX4pnMpHp5vs1ttQVMZM9or90MFaExSZNRCqb9BB4yYCF06GOuYY3PJDqRD1FyY0LgmCIpAsuVuE8EmKNhjK5tTf1aUGxa7laUkMYAXySczbnLI6yr3GPBJiBfazIY7DPhc1kcbS9nZV3Fk1VRyqGJiBYcaJ13IPnLzn8=
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
can't work for in-place conversions as the shared/private status of a given
page needs to be per-gmem_inode, not per-VM.

Use the filemap invalidation lock to protect the maple tree, as taking the
lock for read when faulting in memory (for userspace or the guest) isn't
expected to result in meaningful contention, and using a separate lock
would add significant complexity (avoiding deadlock is quite difficult).

Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 133 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 116 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a11cf6dc785da..1f1ae61b4878b 100644
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
@@ -34,6 +35,13 @@ struct gmem_inode {
 	struct list_head gmem_file_list;
 
 	u64 flags;
+	/*
+	 * Every index in this inode, whether memory is populated or
+	 * not, is tracked in attributes. The entire range of indices,
+	 * corresponding to the size of this inode, is represented in
+	 * this maple tree.
+	 */
+	struct maple_tree attributes;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -61,9 +69,25 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static u64 kvm_gmem_get_attributes(struct inode *inode, void *entry)
+{
+	if (WARN_ON_ONCE(!entry)) {
+		bool initially_shared = GMEM_I(inode)->flags &
+					GUEST_MEMFD_FLAG_INIT_SHARED;
+
+		return initially_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	}
+
+	return xa_to_value(entry);
+}
+
 static bool kvm_gmem_is_private_mem(struct inode *inode, pgoff_t index)
 {
-	return !(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED);
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	void *entry = mtree_load(mt, index);
+
+	return kvm_gmem_get_attributes(inode, entry) &
+	       KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 
 static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
@@ -364,10 +388,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff))
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
@@ -520,6 +547,51 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
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
@@ -550,16 +622,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
@@ -764,9 +829,13 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -786,6 +855,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	else
 		folio_put(folio);
 
+out:
+	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -915,6 +986,15 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 
 	mpol_shared_policy_init(&gi->policy, NULL);
 
+	/*
+	 * Memory attributes are protected by the filemap invalidation lock, but
+	 * the lock structure isn't available at this time.  Immediately mark
+	 * maple tree as using external locking so that accessing the tree
+	 * before it's fully initialized results in NULL pointer dereferences
+	 * and not more subtle bugs.
+	 */
+	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);
+
 	gi->flags = 0;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
@@ -922,7 +1002,26 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 
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
2.55.0.654.g21b8a5bc05-goog



