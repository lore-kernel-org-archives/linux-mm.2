Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424FBC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB336B00B7; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581C06B00BC; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4714B6B00BF; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 152206B00B7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96293A0149
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:55 +0000 (UTC)
X-FDA: 85075823910.20.A360198
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B6BC1C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXjpFj8U;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139573;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTxz84DgDrdmznUsW/d5flFCyqS0l4okiWQ6C/dRdOA=;
	b=V0vw3kdf7QZJ9mQnxpizCz+TpDmKRFDKZOgr23juF00CiKLwyn7JyGRoS74xh1bSG95kRF
	x/KS9uKIe7JThO7DV9E2xlmfJX/Kxlyzgt9GNTVXu43uK3rXcTPV3OzrajZGjIoxmXSdeP
	Pq9BfNekaXR2WNAbDfp9NR0mvHiIuqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139573;
	b=poIPw996+HIkcnvuS5h8ss5I4gho3WE0I5XEChOM2lSIp2rTFnzMw5RntSMJkL1uNCh86j
	f+I69wFh3mCqU3xE3KKbYw/H+cKiFTxA/7k6vlQ3HnRRTkRVqve/lqEYTMlzT5cdKTjOV3
	9WEpNyaTw4vUZgiUN4ovqbSKKnhv8w4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXjpFj8U;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30A64450E8;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC742C4DDEF;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=Pzuw2+81iEHMVCvjZGWhoamaW8gUEktYXEZIbXEYWm8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MXjpFj8UxkR60BzbXuxOBUAvRDAAEd5gZZWzIZ/F9UX8XBm4Ka68HBk+DFoP9OGUM
	 CrF0sGwGkk1z2w4zqpxG3FFXc9BviSpiexj43Q0vGg2C0kkjQ/iAajj8JBxlntVTvy
	 /6zf7A3ylHAvyId7JeGICCy+X8lo2J/Wdo9+b+dwtggYAE2nNEjDyLBNuTosN7d1nc
	 AeaRVZkFoiSLv6BYJQubSyHPjHyOaCVFBhs8FL2hfZklglCpPyTcpvZjyG6GJpx8M6
	 DwZCPsaeOfjNOqyNUrxzbiwrlOAf1wa4Qn6oNWmCBRJYbamkpa6vT220yh8FqeD7tr
	 w7XZJDRglrTYg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FB9C5ACD3;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:51 -0700
Subject: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
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
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=6041;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1Ng/R74A05uOweRslhpPPJqNeRCRV6qc3VuI31edYL4=;
 b=w6qJsbvqKpJ1jhvhTXzGaTALgmTVrH8jPUJRQ4YOCMRGuHiWXfbnsjNn0MBtJLU507DXaYk0I
 tsf43LlCj/2AIdPYDntlj+M1qVADWcBl2bm5DKn9EYaUaTvSna1wvQ6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B6BC1C0007
X-Rspam-User: 
X-Stat-Signature: h5dwtw5ephekg1zxwwimd7wrrceg8qn8
X-HE-Tag: 1786139573-333625
X-HE-Meta: U2FsdGVkX1+qwm1w5MUrLer6X+VntYqT/FdSqC4zruAod6A8oB/Nv6hPCJdEYwz181LrJFhjSsU1QoUMf9pcTX87lhiyUey+cNZkklwyOL1qJcaUszKzkaB590/EXrN2MeRA+ta3JU8L0AXowNpUU12VVquOPzjGJ9EzGqApHblh/WEwWI5Q5HYa2iqT55w1Qs8iTt3+R+l/qZnGRQWSSp8XqgTdRoxwxHNB1PsHOj05aG2loWdLAPurMu4dFd/o+Qip4gmcmAPwZyLZkSL7vmOfjRze05lz5FhE4X/DFcmqnja5UIjrcmo7kqyYW0lDVPUNW3FUU9Dotvrahc+UVYGP03/xOiJJcIsM8IkzWPZNJZ6klJJi2ZKLl0iib8RlqHPJ6HY6UXGY896NzQzo4hBGI66bAYA+cxI4KzVhxcblGa7aaVVxN9/eGn+YmBFs1CdKd/aISka1KzGN9ZTagKy6SInab14yd9heZDbK85i3HA3A/rc9Tx6zvf3BmO6Cm4usBJAokkvnyESpwpLqt2G/eZUJ6LGg/L3sumPhoTfEzvKGGdzaYsVMq4zIyhPU2+bCOoeFjgdmS4TA6PdqJt7ks3xskjBn6+eXkIgmm7/1vRBL4XdlDJEYOLrMN5ktigkhTFmSuHVVFMtc6xXalixNIUuys9KHh434lWYizBux0FEMt0Q0oetSaw64BlEtqJPASAwLm0yQtXk/cJzrlAQoTpv14mkGRq54evXpeiMZNgPXW4VSWO2SYeMqTK5drFgKRubqaE6hv9jc9FWVWEIWeSG5qE+aF7Zn2/1EY4CM4ltjrtFrE97IiVKJaBhMtJ4DGzseNO2eMHcx3K0Y9bfEVegOlClOJAtG5odUOYdhmZXrEdL5yq8xiMhKzHui0G9SWrEmgh7njws0mvd479HnMdvXe0vFJbM1cl+c4bDT4XGjZltW3p3Ldk+VVxLtrKE2aYOFB7k3MpCGdtz
 Q3ofsPUd
 KuhKua4aiBpCDnqRoEmcN9aDYMzRMi6iRhiz8Q6tOgjBPGFeT6sD6Mzs3UmKQI4sZN+t6wvrVs0KrgP2VfpevoPcTfDgvWEpSV6UnQ08oJXJS2rDZRsH0AHdK3x3G7Xnw5DizjkxmkhsFXnKGlwbfS/pf8gykO6uLM/qkNAX71d/tVVIkyZbmelsYzGm/Fo/XzWk6WRLQyWoVT/6FU2kV1zEewmPq2YXnXLPzBZsbijGrDno66B+kr6An0ctukpcEgn7hXjgtCWy6zWiNyVqjlYk/iZb23ge6/HJoG4lT/fU1NdE9cb6h1iJT/+TqqMF450WbbdM5eKR66sJOCsGjK26e2XdX3TeWtbL86DX62ZbIxRbGUE/MSG1qTJP+E7HSFU0ZGMJMBUq12oWibkMIIVEVL+ZvYixr6aVPWI0szz5AvXql5Ymylru24gOKv/ICDZgtZorthqiLAmEgw6Sq7t9fCg3qOUS4TfetIHuggpOfOczeR6mrnt2pM9btT4wL2Md98URBKRNa58+0jWgjzacXVRczc+1boVeO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When memory in guest_memfd is converted from private to shared, the
platform-specific state associated with the guest-private pages must be
invalidated or cleaned up.

Iterate over the folios in the affected range and call the
kvm_arch_gmem_make_shared() hook for each PFN range. This allows
architectures to update hardware metadata or encryption states to
transition pages to the shared state.

Invoke this helper after indicating to KVM's mmu code that an invalidation
is in progress to stop in-flight page faults from succeeding.

Omit support for calling the arch hook to make private, since SNP, the only
implementer of the arch make-private hook today, would actually prefer
making private only just before faulting memory into the NPTs.

Calling the make-private arch hook would require iterating both bindings
and the filemap to find the intersection of bindings and allocated
folios. On top of that, SNP would need to figure out whether to actually
make private based on whether the memory is about the be faulted, or
whether it is a conversion.

This does leak SNP-specific details into guest_memfd (as in, why only
make-shared during conversions but not make-private?), but the additional
complexity is not worth taking on until guest_memfd has a user actually
requiring an arch make-private call.

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
index 14d86851fce78..497da6aaf2942 100644
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
index f1d977060489b..39968610868fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10647,6 +10647,11 @@ int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
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
index dfdb3c97a7ac9..a341c434a2b7e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2613,6 +2613,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 13c3989136f67..c9874bd85c5d8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -557,6 +557,43 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	return safe;
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
@@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
+
+	if (!to_private)
+		kvm_gmem_make_shared(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.55.0.654.g21b8a5bc05-goog



