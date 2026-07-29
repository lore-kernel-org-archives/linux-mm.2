Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56383C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320C16B00A7; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D0E6B00AD; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6736B00A7; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D98F86B00AA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 783041A05A3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:16 +0000 (UTC)
X-FDA: 85039945032.16.6FE5C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8919940004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APQ6m3bd;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfGtNColFEFXuxlIRcOXw2qzP6gPUo+8b5fXDDfbkBQ=;
	b=GNcTSiqfmILvhiyieXHN8HjaCSNoW6KlF09sFHb+FBjg/Ohd5fkYj+yOnHgxmge5PmWGF/
	RsfVFKuM3LkoHuVHC2jP6XvXPD9ARlX4HEGMZUxMTwREkym51/tRks29hBIxThka5UTsls
	fpKRT+sFaHJT2/quMrdImz9cfTv18pE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285314;
	b=gTEwIrosirUbo0HU2mjKTcfl2DKrk0FKdc33+8WwK+T4l6w33U9AOGaK9yAOVWG4Apy6mL
	ubOHnU473LcZO8KgO9W/Kw5bOWu3RoLWYnFn+yfWjQW9iKnlpc9R+c8VgRHUUqTsYO807H
	Tn426uk6KyTtjOY01Sgr7zZO95fGa00=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APQ6m3bd;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 763A745138;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D860FC2BCFF;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=Nma/ObjTPxxpCXAu4Yt1qJ93u/qcx4lmrdm5w0qIgsQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=APQ6m3bduRN7z/p4LS5RCVrAubi5iLKEAV2y+hZsvgEMUQg8/+DmH6aoBMJzvTyDM
	 XCtuqH65qYSqWmH4eMNY5+YQu8f9I5LnHb+oSvBxLfk9w0mXrMBZDJU3Z0TcUK5a4+
	 2A4csRHbTSwZWsDqsh3x+h//TQETW99QPQRUKunPG8bJie7cj1n+Sj9bwjJclMxq2A
	 sgqtLEPNKIAmKLz1GugQwF/5t4BzVRA32m1xt02N9Y3pMzU5MvXzzMSNMU2Wzg5d82
	 2p73nGXoLWrYegQ2i8LhZQlOj92G0P3M8+/COCYGoI3Y/TgKU0Jgaw1xJ8NIe3d9Nh
	 fBNnNphPGIpFA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD622C54F4D;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:11 -0700
Subject: [PATCH v9 12/41] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-12-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=6046;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nUCtHuvQOgEID2sEaBVtGBbYYOXxHtY/vHu5+U+7flU=;
 b=JVHWisPEvyT64j9UDw/dyi+yBCLt8UvXH140ei1qHoEV+UPYzhmNUwNF+kbphIE4RySE9IaUa
 pfu730RXiYBABHPhLbMD1LsZ4avlupD6hxe/0rDfL3c6Nm/B7YrSgxo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8919940004
X-Stat-Signature: oce6y684sgerydrgbsta3bskfbhguk7h
X-HE-Tag: 1785285314-658158
X-HE-Meta: U2FsdGVkX18WKMJuyASE3zKigR16AkmoQwPD+JR9PgPOLKl0RgCELaDPvjHU2Kuh80AyD3LNwGqkUED0Dtg2cWsWOFXegvtp4f+bIulOXtE042wZZZKqFFZrqZiuUrQ8Iimd7wYwJkmO1yeHj/08wPliUDQH9d1iniGdJI99+3QAZ/1IZugWK5aeIHB5Tzr7B6AhFdoFDwZjhGoCMU5mZX3b1DX2xyUFK1WIJOfHxXzyt9DlYZVJiGl5VApkBlcPRGOPdO6whBMnnhH+OGELyg0MZdcRkgIAfksPU/U2ao6VfowAdS6AC9iR7J6hpowuew9q6R8tyywN8DYw5GFZXZQAGheatnYRK6M33pXIRX5Qru0Y5LiiLA3KVsGi4EtV933rLKdFI97fG3/qUY5CqpC3XBhgRX5ZdvC3LzcXjFQ6vecCF0UqANQHvLtcxDwlX2nUk6m9THhnxPwN6pgIjGU691Ww3TzOxCutmyhLyXiQp6/EnlzbXELQpqc5aMnEgcEawXXpNvf4g8cmYCa6MggT7CWRoZeRiCTnv2fZS2z8T81g/3UdFG4x2DoIgW7BEYoNpDTpcKzxOOzpjPDljWsa+a+4iRJWHiaaYddS5AA+E0O4AKn9Vq0iINcjn8tEHsMAc1HFb780p+K1OFzaCGgnUts37n5F52aYOHLim2juIr2PdcR9fHppMBzwOg+KbXJbnonMtpXspaG5QXgPMUFRjoqZoN9qk2wux4cETUbB2EJsWImjFBL/a8QxtB1NJIFVSQ/18vCJCMX8vRd/fOJF8Y2uoZtES0h+reegM1fkUDmdV9KNn60oYEU7wlXeL4noZ6WAM17DTEjQ8fNlIeMMu/Jn1OrkN4nPb7HwRRzUMFmOMIypDPecmQcTL9GhrAwknto5Qd+LQ2jp/Bj7GlofXtZ5IDQPGy/RB1RdaNqsla9d44SPqPCwlAtaNKvw2LJxBalxaey/bfbHzXw
 WsHFnCmU
 znOQGGzKtbNqq2PUT9djXSId/7HjYpGfQtWAiz4WS3sQU1YQAH8+G4H9fThCgCzOanFEDYTrl16YElqt50YN/tU6AanXMNxH/JUtGKbzMX+EJ1Soq7EtR7gB1fci1PvtcuzSTrvPbfXckxShxh51SlNwADi/D1eaacy9He5C4aU4ZVAp+g4IbH4lgTzcEO1ZnjjhK4IM0vd7B0SYElU3VvMl0s0bRNJUOR9HB9OVOhqU5+b0V1imQanAIG8/AGUYPJISyNTxCMKcxgDDfz9RhUxM73RjYPq5+wP1wE1/NYl4vqeBMtw8IzibfI1OrmJRs75hSPrTQyXtlCpj82t3GvF1f9qnhWsWbHgo9qcS852Fg7opIEelkP3wbMOPEmyqe8zXcuztbeCu7y/k3mugMb2svqqCbO2vQF5nhrX6iCP1Hagv40MO2SrRmBIm//yrSRTSUYmvz0ZxmsPyQNsmHt7w7b46niE6AqqxLcY6V3mRRW4DK20dAZtZ52lWfWuimENllmPqG+bQ9iYfQFNKi8walZJJVpysiHUhd
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
kvm_arch_gmem_invalidate() hook for each PFN range. This allows
architectures to perform necessary teardown, such as updating hardware
metadata or encryption states, before the pages are transitioned to the
shared state.

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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/x86.c                 |  5 +++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/guest_memfd.c             | 42 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5cb132eca3c35..8e0d6970c43b5 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -149,7 +149,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 KVM_X86_OP_OPTIONAL_RET0(gmem_make_private)
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 KVM_X86_OP_OPTIONAL(gmem_make_shared)
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9fdf13b071097..ceb2abf43b76f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1730,7 +1730,7 @@ struct kvm_x86_ops {
 	int (*gmem_make_private)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				 kvm_pfn_t nr_pages);
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 	void (*gmem_make_shared)(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3308d58342955..52de3ec7c7f73 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10639,6 +10639,11 @@ int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
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
index f408746d315f7..47f633cddffe0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2612,6 +2612,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d3c813dcbf96d..612fcde4ae8ea 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -563,6 +563,43 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
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
@@ -605,7 +642,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
2.55.0.508.g3f0d502094-goog



