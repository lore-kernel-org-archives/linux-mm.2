Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34BDC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F306B00B0; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF766B00B3; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FDE6B00B0; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADC3F6B00B2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D6371404E1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
X-FDA: 85199512482.27.242A5E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F2C05160003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSDG2aRH;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084539;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xw4XHrX7znjPVuwdCn8wzm/6LyEi9Oak+wIUv9nZ1Fg=;
	b=uyAz0fdIZVdS9qSRL9eUXeyJe/ugfiAVezND4Zppj/95MIFyc4b0QEUMnDAgswQ6GcTXoJ
	a/5DuLNPvnyWxgCt4JqASOMkz++BGwpAljIhmqCI+TC7uXKbP4iHukgHzD917dGNf1tc1z
	M/52/8a+41n5nWDqS2/1IM8jgvDAuK4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSDG2aRH;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084539;
	b=JTBnDsFHL0uKHwBKS6DP7P7gPz+zce1EonbdDc8sAbwAQppjsrZD29aOZlIF8zua2smedy
	WuzyRuQsjyg51VgQCF2xHOHUp6RDu2EhU3nGUD0xTKmS1H/jIFh9dtS+UPJYSM4SBENDxB
	ZCH2P8nrxPpyek2YJtkAGSQe8IPfIAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42C3F447CD;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C285CC2BCFA;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084536;
	bh=O2pH/6lVlj89lhrbGLE2jV3WXIDAriM8n1vYzNEz1+c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iSDG2aRH9uG3W4WOmRwJM7IKqywPruTHbRnlzAbmB3T0PkiRykW4GFb+g1VU07ll6
	 os7/7eONKvJXtFu/FJs4nc7OfsnvXieY4kpQRWegbuo+V/uyp7DWj73rSQEJszhxbF
	 PyY8HpD1gY/w0tSUMfe25lXBYC5jeiR4nSHdXo7y37J9L6u9tdteNO3aWINqSRbZgB
	 7ggJYt+WG6VeMBA7JQJbsIA1RnCZkEQ9ariNYUzdn0bZasYjOk5H64u/5iNXtHA1St
	 EpD3wQecx672bitszHBAv0M9jwbTxxkCfmc7YS98CeTdi1RRhl7UT30KRHiPjKJmiu
	 YpuSQCSX8zGFQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CD7C88E46;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:29 -0700
Subject: [PATCH v13 03/44] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-3-dd6fbf94f4e1@google.com>
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
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=8902;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HcVyWCDIyCugJr/GGBPavL0jjOShNo1NVIQNL9PLRwQ=;
 b=XLjRvPpqPd2P01qz4NW0VryhIZ18xQ3qhkyGxcPFtfsr8p6S9yCzMJdya3+4oVnA9EeANQrXK
 bMmGTy/ztfvDmeFXmu+VYt04CguyQQN4yJivXewvt2njGbOZMW0kSrG
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: aigeyu7rk39ewjbgwhm766878fmcjspu
X-Rspamd-Queue-Id: F2C05160003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789084538-577428
X-HE-Meta: U2FsdGVkX18jqlQA0GE9wKL9Oo4fIPKWnHMWA8dHTDUwLSGqOW3CAvK2sEm8pDs+mDzKkEgDpOhRv5TisFdf/Ddcvwy5BTJ0jz7NjuXOBJj4fM6tx5lWBRlqQbWunE6vYZQ3KcMgWSfOf7i6MjXMPUJ+NfpfHr+5D2POrJHXfCCLbUdtcXz44um7LKe5Grq27KSWsMF399l2GpmHnC1yvKDzKxz8NrSsf6OjLs6Bu9A0z1VN8CGSGgKNolb8KONK51W0jNfrG1/2Bi9rfA8/xWIW7w3WTTCLLPoyOuNgoiKqqo/dAsOOvwQ/RpPxPsHPV9L1C2+Gojr9vVOWPKby3LgXyjPeH2MTpk0CAfGy5Fnf0u5OGmeft6wHRqOOWxOt4xSLgG6iB5MapKBWge+FmTjXUM6xwdNoM7lVTjJpOdCa7iT8crXmZ+bgdNZysv2k9lIEDxiTdbeWdI0QhM65LswSVeplHemCdhjOUNMO1AkC3Q/Ojo+sBDEFn14Tg13fsa+wNgjQEU9KweWxvVDuwpTxMyNiOOhqtJNOmKury/Rd5Y2bzR6dJ61Zt4Yma6xFwmK9Tuam8P/fm9e/LQ/MrDRitk9TruE2mXl9YvDl84NBDw6pMebpEtwgpA5fBj2dtemIlZlaNAAfyg5WQaE1TbQW1g/AVXSLeuSyR888nYAeAjrRZmmRa3PJ8WEVs2QQVy6gUt4/BU2p9YX2Tg65gss4atMSwSJ0yY8zhxwSgOxpYWccp1vQBeV5AF43LMtdFhuliM6aGoidYoErRDq170bdt6WlI9N24ApEAEQCT8IxMcQ+XHOsJ96dU1BVp2SZl3cT4Pwo4d/LNT1iT15h08b3Qi7vByw/vT8OJZ+JITe+rf+3sZXHkHn9KUJCLC1EtpY2q6GWGbDc8GEnh0SWXnqWikQ+At/G9YPNXloXdALzPTdKkbFta/EF9Nq7aFt2IFMj0tYcdaQqAo9erXa
 Y99WmeLK
 Ij13bt2Rt/uAWTqVV+mV6cnJ4eSM20Mmv4C4J8ikF517YW+4uIzaoluS4tdABGAFkAAuPrhgu0iTAWqSxl6uvD/CJlmSbOnO9Ls9ASJMfpZDrpds3lqR3ic5LG7OoeiUuvgCrtWSu1tL756TnVxmFygWt1eubaUvttjqN9gKdNiN7INiRL2Yk/p/MkbWpfa+DET1vkqt5jiPtV2R9/tfX6RwEf79gp6OKK9gX2BNxQ3gI6YhvrcPIbm+oURbEafuVAv1vp1gK63xYwnH6JooRuxnhrc8Af638lb+w/ArhX5w9n+Uqomb1r1Ew4ANUGXKH9YJREYoZOIeTkWpY8Hyl6KE2NrZLD4+JrwNN6xpARuDVaKPhPo25+QZPAiyMPEPTmN8Y55l4ws/roFnFWv+e+cLwLCjTPN+kSpLN6cAQBHz334t6fyjVi9FNjeXmcjEqAkhpqgf3T3apxU/bDkwRcjEdQ0Gw6abemG2Xrr20F19V+DSoatjN1rvFMxRB9PIYKohek1vBjZatNBb3bdhXbPCKcKUxBZq8REXIHCy18683Cv8=
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

In kvm_gmem_get_pfn(), drop the folio refcount before releasing
filemap_invalidate_lock(). This ensures that a competing conversion request
from userspace (to be added in a later patch), which also takes the
filemap_invalidate_lock(), will never see an elevated refcount due to
kvm_gmem_get_pfn().

Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 virt/kvm/guest_memfd.c | 136 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 119 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 69612bf146be1..e32ac2c28cbef 100644
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
@@ -61,9 +69,28 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static u64 kvm_gmem_get_default_attributes(struct inode *inode)
+{
+	bool init_shared = GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return init_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+}
+
+static u64 kvm_gmem_get_attributes(struct inode *inode, void *entry)
+{
+	if (WARN_ON_ONCE(!entry))
+		return kvm_gmem_get_default_attributes(inode);
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
@@ -364,10 +391,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
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
@@ -520,6 +550,51 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
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
+	attrs = kvm_gmem_get_default_attributes(inode);
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
@@ -550,16 +625,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
@@ -763,9 +831,13 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
@@ -780,6 +852,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	folio_unlock(folio);
 	folio_put(folio);
 
+out:
+	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -909,6 +983,15 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 
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
@@ -916,7 +999,26 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 
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
2.55.0.1007.g17ff1f9808-goog



