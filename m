Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4379FC88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE526B00BB; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5D16B00BF; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3B36B00BB; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE3C76B00BD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51E921405DA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:46 +0000 (UTC)
X-FDA: 85199512692.05.A97B137
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44BD2180002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCyKGBzL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084544;
	b=Bm2D/gw8N3T3jeo52PAONVdeyqKvT7LRtnPgg7F9N36LXh9ZPKJyGJEjhsD9nekSq/HL1r
	fzaIL275XA4aVUP3jVlGEhO4Kq1GtYj1QRRuBowgsJ55U9m3WsfopVNvloMnxSXBqVoeRV
	NtWn0Gy5wlVFsyZYG9DbY0sq42BKoFI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCyKGBzL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084544;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOVkx07mZ4jrMefZOsxVoev+R8lCiPpXXUDrtvXhHhw=;
	b=XyIIaM/7VATHQTpM7oEf9x9o5MP96XGDTuHO3vjBO1tsytL7hIhl32EJHZAOKGGqp4pwbt
	G6JnvtDyWTy0/NvWPC/8mDsng3rIE2IjDgGvE+hMCiW0BqUOj9bgUhYgIg8h7M7W8Z4ij4
	VM5hpny8r3CV4YVPRHZc1y/Al2TBmtk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84970447CC;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FA26C2BCFF;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=gGM6cYb630gdWoJEJn4fvEBtwAcYmnpAVbuU3m8hixg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rCyKGBzLHZWHjByQEvp/3J+bhaghA38hro0nxowD1vP4RKw0B1LAa3zU7l9MJmkje
	 FYMTzDXJQu99FujV0FHz4M56GC0TI5f73xy3qYXDSMiX2hm9wLISM6lwzMDuf2cHAE
	 TbSNIGlHEvf3e/acZnayLgtk9UzjeYt7b3EwNQLdF7VIV/0S5J+AW3djIrmIU7t/YW
	 w/3zJO4V4rlcYidR7ob3cFGPDwCRqGa8dKlMJR3D/Y0kmzd3vXcA0kKTgbBv9xRmuG
	 DebQPv3jLe+zobRMgPuiHWwaSncHCEgeu44Uy3wkH3oP5Bxurtk4PMZcV8qLELcqwk
	 xOcJ0BaBQQpsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46592C79FBB;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:42 -0700
Subject: [PATCH v13 16/44] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-16-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5988;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pnjcuYiGgOrTACJiDuCpEUUXJmfVPZdc0nxxctxlq1I=;
 b=8n/zqT12bJsDEGglxVJpV0qF7heq6Y/6E8z8+2TPGozDYy2KIXFbkJruoR9CqjTm5xYcISqXB
 uNl2w215XnvChWobjBOo60K/Wh3YvU13WDJU5+Z2PMtVpViNfPkT54t
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44BD2180002
X-Stat-Signature: i4ize5ibpsbnwwcuqri77zhfycdb9a1u
X-HE-Tag: 1789084544-795792
X-HE-Meta: U2FsdGVkX1/gwCbksdWYQs3aOpux6DLK9rPgD1WJPovDBRHW8n4EP/H75a97HC9Y6xbcEsLJZH5ShzcBknv/LS8LFKt3+D1lICIFmJOEmJC9iutMxqHoZbcrGDTQcwq3EIF6ALnwrY0rdL7g4xSqStMq8IiaYR9+Xor4Y9F9BBiqLXpU30rodZK92lAapDTfPVtbwpcLJx5o5t1q4Qnpq/pDKHM8tvrVK8gbBpb0uY/h3O0qBPrQV8YfOU/Hqadp/27wjee/LpEbt5Y6mPzckrckozez7I5MqXQVDzK3Ya9sBT/xcbMfLObgnrVtRrlycimGEDIxMTQsn277v3WB95k7QrFvazJBW0KGlr3lorB+1QVTZQEFM+vGvqCPsNNUhUP7LnuTNwd0DPye4LLVNJ5mONyHbgKwZEruDXdaF7160jNFtB7qnGKeiWnubgXjSzBY44C+0z4agETCJbQmFxiK7gMhMkY1gISZywgcJ0Ir8TKrrz/mb6dfbaGnWIJb9eYP1X2rfalWNNp6Ek5iRb+Zw5Au4OXmtA9EbVhf4JhtWToR7GsFYrPmoexNDrmeWNYbcrybPYOCofLNajCuYfqcZtosWppJiKYEOjRtwzZcvz3UzOrtafb6wox5r8YHr3rEacSv9S+ILz2BFivnCuhdrvDrTMX+Kh1BZNhoNbv5DlAEaSMmhnEY80s4bauFmB75FHzo84Bt/nf7kWL00SYobI6KxoqgTrCyEivcnllQOlxZl/QqWW2j42+CF2yPLI+R0hWverM7W6c5+09F8ag88Lw0q07s3EtsXEG+PHtKVnluj96t4kudZH+TfMUN2jT3/s6H4b/XlorUiu2eYG6VhJmclKI29e5dk7YHhGJoICqwJuTC02Ipk3Y77ZR7GSTRhXSGgtgc418j3Fbsq0Lw87r7wHsX7l1xJe6PMgNLt3W1H09vclcVqr+xysaSPaQhvJUzOn0FIIb7Q2s
 +sOTSVN/
 SkUcZrBNgAFYq2Y/gKl6+RBSvfY9+rNTukXV53wlZWu8+8zLgt3VFBLPL3JP7HIFlPTrcjCcYk0dvB2s6eNEbCSrJCRTaw9x9vUs9jrp1EhNpDMcTbDm+XedVwctex0DCCMf59o3dR6oTyl3NzXPjfnl84LRm4m7bYPcGnooSJKqDKyO7a2fUOA30wkrNXHJcoVc8mbKix8so/zUld8pc9PJSp/dutOQvVCxBFSmfAYEsr/nX8gcMocDfc5Pn0bAvvCXb3uvRVVshlutc6B7H5kSmeUuiyd7JxW4RxVrdpRnum6kR6jlNbgJkMTTWU4ahuBIIrt3zONBlPXw7UENfZSAtM1BeuHf9xC72kkczKdHl1Dsqb3n0dSbryhdccgQ8nfmC8bPEF6H86WmBT10ZRk7a3qYwdPkAw0z86gV/Tm/yn+NoFLe0xpUPWsn/7MVS2QGnsseNcmEL+oytZq7eVM1GlNDRbAetS0+aIbI+49OSD77gZ5cTQaCL+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When doing in-place conversion from PRIVATE to SHARED, immediately inform
arch code of the conversion for all allocated pages/folios, e.g. so that
arch code can put hardware metadata tables in the correct state.  Eagerly
updating the table for to SHARED conversions avoids having to implement
on-demand updates, e.g. when faulting in host userspace mappings.  Skip the
entire flow if the arch doesn't implement conversion callbacks, as getting
folios from the filemap is noticeably expensive, especially when converting
large chunks of memory.

Deliberately don't eagerly update the metadata table on conversions from
SHARED to PRIVATE, because assigning a page to a VM (versus "returning" it
to the host) requires the exact GFN associated with the page, i.e would
require walking the memslot bindings.  And because KVM *must* do on-demand
metadata updates when getting a PFN for KVM-internal usage, as that's the
only time a relevant memslot binding is guaranteed to exist.

Note!  Inform arch code of the conversion within the protection of the
invalidation sequence, to ensure that any existing mappings are dropped
before hardware is updated, and to ensure that new mappings can't be
established until after the conversion is complete.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/x86.c                 |  5 +++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/guest_memfd.c             | 42 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e213c9ae3e301..67b43c167045b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -150,7 +150,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 KVM_X86_OP_OPTIONAL_RET0(gmem_make_private)
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 KVM_X86_OP_OPTIONAL(gmem_make_shared)
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 744c1f6ff03ed..83e26ce45fb79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1732,7 +1732,7 @@ struct kvm_x86_ops {
 	int (*gmem_make_private)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				 kvm_pfn_t nr_pages);
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 	void (*gmem_make_shared)(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2292249570314..75e03a2f79db2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10653,6 +10653,11 @@ int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 {
 	return kvm_x86_call(gmem_make_private)(kvm, gfn, pfn, nr_pages);
 }
+
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages)
+{
+	kvm_x86_call(gmem_make_shared)(pfn, nr_pages);
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab87effdd221f..485f18454eb45 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2610,6 +2610,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 #define kvm_arch_has_gmem_convert() false
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2de39ce8aec13..85446fe720603 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -588,6 +588,43 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 	return false;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			pgoff_t start_index, end_index;
+			kvm_pfn_t start_pfn;
+			kvm_pfn_t nr_pages;
+
+			start_index = max(start, folio->index);
+			end_index = min(end, folio_next_index(folio));
+			/*
+			 * end_index is either in folio or points to
+			 * the first page of the next folio. Hence,
+			 * all pages in range [start_index, end_index)
+			 * are contiguous.
+			 */
+			start_pfn = folio_file_pfn(folio, start_index);
+			nr_pages = end_index - start_index;
+
+			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -637,7 +674,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
+
+	if (!to_private && kvm_arch_has_gmem_convert())
+		kvm_gmem_make_shared(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.55.0.1007.g17ff1f9808-goog



