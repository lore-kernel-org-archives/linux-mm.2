Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CFEC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A901D6B00A9; Sun, 30 Aug 2026 20:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18F56B00AA; Sun, 30 Aug 2026 20:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909016B00AB; Sun, 30 Aug 2026 20:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688B86B00A9
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA4671C1E43
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:29 +0000 (UTC)
X-FDA: 85159670778.02.E41361D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CCE9F20003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpR8VEQ0;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135927;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBSnJyD64okmEh0o8h3lAnQyLZzalIi0LmIimzsqV2E=;
	b=KF5y/vlHdYYnbAawa9CyVsofDIaAPG1HwxvIWYGirhAgFrU+bzu3xxeaVXlI+ZZa0S/VrX
	/jKSxobcc+mbiBQK8XeeBgoIJS7S57gHMKUgDPVZe4HMna1jo/znia2QYzS/1OrZw4P13T
	5uhONJJjFs3IVbVD/XhBS34SRS78nK0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135927;
	b=xUHcyFZ+mtHi/P9n+loOKpsB9YuzkjfD66kR6ZFWoC9VAzkJ6Rbucq0kldE9s3LKzll2NH
	/7kt9/ZAypi+G+zfLlg7cSTnrbp/yowfquTpc29Yk2vj6NfV9fsDC13Jo0beBdBChefezs
	SrO6MqN4TNUd3d+oW0gUpfT1ELB/jfU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpR8VEQ0;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B78344820;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BB88C4DDF3;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=z59hdgGozA63z31zC23BZ4GXqCsjybzsO4sM4OB80Dg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DpR8VEQ0UA58HaY31wEnwLZOCzp290pfHU61d3OSuj5SE4bgeUIjQGmPtrArEmfmT
	 Bn6I0PLu8PiCZkzeqe5O9527n28QKyFJAW3rRC7f4xktgzT3I9G9qxFQKL078NBFBc
	 iNqlPguHzpCvgruRgwpGAnMeY+flKzeXe/eftNDB6rsi0q3DM1uchmcCTOg99x+EG6
	 rq3WEyw0zzW6rsUFR+rFNNFuB3H2QQsmo6DqJXDA4RTp7TcQUeAMBXjHMxuBZLVhAu
	 OxJfMImjWtWAzXOuiiJs9ewO9CND9s0UCeeXDRV5tROKHGVvFWiBuA51K5eRaGaYQ6
	 aQoICo1yoGMAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CD0C61DF1;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:17 -0700
Subject: [PATCH v12 16/45] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-16-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=5997;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cwEhZDpHTNx7ou7qscSIiavupcBz2iS+igqE5zUMd8Q=;
 b=t6DynLmrFZFZfNeyDVzLpduvArXHO0s1vSOrUsIWpNPwO/0vT3Y8DyHNEr/kDVnMFXQfuCFtv
 SR6kCWPCwtjCJlL15dvtAK08r074OdOuuf9mOk9x9z7bVFOMfIzN+/a
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: wj7cxh8t4wntf5rezh3dz3sbmg5s7qfa
X-Rspamd-Queue-Id: CCE9F20003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135927-804021
X-HE-Meta: U2FsdGVkX1+VQn6UH4fsT54mg9vEM+A8Ev56Mg3tD7LRXEFBn7MeBnuKaR6AoiKpmyQNHZu9rDRaUF4vBwE8TOPQS0jpRf1oAgFE0Rexg6Q5CsdE8oSwIWlZuvUQLQfO419nOhqZUrzm1fwsp70RcD8UfrNGhZpBYhtZ+0m+dBbX9/GU4pL5HeESiNmc6uYs2wiI4kjO9dc+L5JrISTlFJR9B5tYfnUeGZxPwmAg+RM0i9MARblasRx2HI58etkmMgsTwhM0JLQfnP9FH+0/wNvUrrBcExqp+a6aSTYpeFbeZUPZvnuOkea6KtCSy3n41YXET7ei/JjkXJyLt4RuXA/8WK4W7qKZ8+1TQLzU25m2n7GEFMpRZ+7FMp4Mic60lMVcgWQYNv3H04qmsJ4nnhHom+wRXz8X2f48szldN0+Dg772CaBFYM/lNLXAI0kX9r+T/N/l1zROJy4s9APxBk4eUV8IA7DGqfZ9JdyHYhpbsDxPZBrfgpuEDg9EZCILGAktbWseIPC5LHUtmARz3sZKKLwRnX/3WIh49r4qzuZR/zIQ6yurvidcx+GDl4ek/Xyqy3xx3kSBsl/wPmPAFa5QKqbn5f347ajVQiECJ/SkK/C3Qjk9iwBvkeJka4HNgF6sWQ1r7CKVFNmrgshGjJIdQR/M6sF5fTBA9QpyjO4j8WtpvnLFTurLYu1yYH4oOE9X+SGO2ULgugbFITvxO0YZfh9oZZuLd6qHA9vw6aDnsIkYmjR7CQYKNciB0tPqqFz6iKsMMxbpEc2jUysbO+xOuL8GfjGRWeQTZhPxxBM0PBhJd7wTYcufIiZ0ShxqNEuNlPJvTgDW5ASnIGpYak3d5X9N6gYKkib9Zl6p83DMyskUzsVmmbWwYVo0AGni7vy5Vrle0KjSrAvQBjKOibD/BqRRMHcphxMEM7/MABOFe8kOUYlBIjyjCPJC6SYrSGCrHTfGAQu3+JTwc+U
 OLgg2ntl
 3dh1VXvrd/Ld2uxEKKJGvvIGxJS+usrh19dtHiktnQyezIAJqv3doPsu9HLnZYts1qUrUjHQa0WqaAsgetvFnqpmq1J9lNGceQL5aDsMe5bSY69J3BxB+A0h/QEFXvxWd4PQRatisJzmorB+epYTUIlUgvpTaw+NZ4gE9qky1KpUBBEN3Zlh6PyZ9TCg0myHZeFHM9HIqwuw2ZEU3ed193RCScZWJ8pM1zvOc3upMSuSztYJGEjgm1fTmBSziPBtUiNRYBb4BjJwV9Us73+Y8C6SX2Pm8RlayphHvk+YYLh/ZprfFBT3w3jW/GUoL8zdwhScTTczTISEY6u87JmWPJaqoXEV2tw4zZGYSMk1upuE5wo+0pQoNTbJTfwb4pEEzFcK+3N79kf5RcXLoAw2TfAxhtWVpxqreaAyq11MDfavxYdHrTww2vBQ/FnaRpGNaN3csanF1b4ny8dFYoZ7+dGLQeI2yS/mI2BhPP7eK4SO6gjOATUADyZg+zA==
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

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
index fe02c47c85fb5..d14a7024bdc7b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -575,6 +575,43 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 	return has_outstanding;
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
@@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
2.55.0.897.gb25b4bd76c-goog



