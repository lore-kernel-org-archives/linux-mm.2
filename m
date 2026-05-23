Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB1ECD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4573F6B009B; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4E86B00A1; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93DD6B00A1; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C09B06B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F162161A34
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.19.06D6B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9071040005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ssEnp+Vi;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEK7RAPe98VUZNbWdoO3Xvf8Pz+ZzCBWe1VTO/OICiQ=;
	b=WXt3n/a0KSZDJii5wX3PlIlMmNWf8nJvkcliJT/OG7+33N+hAXNb5uOamCKzC9X7FP5pE0
	xNFLnkd3VizVFEZSYiRwv2qdxs+BWIwQq6nD7xyC2hO+0bW43hcMtxTooLAc8a2oJeIs2m
	HIUnSZDnwo0B7IP/iP6Ta8cPUrQ36Ao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495486; a=rsa-sha256;
	cv=none;
	b=02NXvs1jPKG0gz8B41VGJjgzpIib6B7P6prqerOEcDqQkwZYhTGP4YsIhc7Xq5M0jMzG/n
	g2WmyAmkGj3BveloYpuT8XUcuY6kfOSa9M3p6horpJK5bqSNSNFqvAi8Nf5vIXt4A/Ww0q
	BZ/NBz/lQLlq53pl18WrKwGcDtYq4bs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ssEnp+Vi;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 119D644627;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EB47C4AF54;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495483;
	bh=KRNbaEsSfNYktqK+TdhL9wK5NA+yc8w3OKg5NAanuCc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ssEnp+Vid6mz9P8b14IeQGHzJPNYLG9B6D1pjL5rDmpdoqstNHSRrqVOf8zKhzvvc
	 HafiNJwvOSPrnhcgyQL8y9PhJB6GaEAsMEy7TzTSk+EPxYaihGfhkw5+l2frfUrE0U
	 bW4KhryqtChlkykApqLcl/1LQxioyO1Ys9jKEPRmoaOFWU6ii1UWLnJRF8CPPv4wZg
	 1P4bM9jlU12qlNXpGKW2EeBfp0p3I0toNHBJ0xHjbLu0vNJrVFF2npPKnAGOBzb116
	 OotgeEo1Pcjzf7t4u5tE4kbbLr3wQkhs2XD+PXWH3flHNZ/xLotIPmNHiJ6oczTqtq
	 JoGA+9YGaRqBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBB4CD5BBD;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:48 -0700
Subject: [PATCH v7 06/42] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-6-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=5845;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=T09Pq5q0ZyF3JHYQzQ4Ky1UwiTvUdLqSOIHXfWHbSsE=;
 b=hPW4FLiUYOMXm2sa6dFvqWbQZ6f9551sdFzSpJa8eViKfRt/Fb9zxvr5r7yU1mHBr+rzE53FI
 v+4bSkxqzqQDiZ/n0DOXpdVDlKP+2AhaUIhoRZl9De/Tv9iHOgJimJ3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9071040005
X-Stat-Signature: gtnpukun6roapucmhj88fyf6oqj54qns
X-Rspamd-Server: rspam06
X-HE-Tag: 1779495486-809090
X-HE-Meta: U2FsdGVkX1/g68vc6aesS/1j0ZTgJNULbwqLK2epsW4BNjXULO0uBzPk0CpDEs7+nd3IcUdbK4c6/wNZtAGI8eDnPgDcvILw+aRTfoKbqQQMLhqBamOiwKotfe4eA2xycCTC5MQjKcwiZf2WryukMTjx8JosFJutDT61gkJeGXRwqzPlXzXRnbXcIqumc+Yb7w4hb2RK4gcf3nIif06n4sk/1OTLF4+modRfdzww7g0spA/zl9v7C591oB6jGNF3lrG/3MdIYXG1bok2rZu4X/1L307jzq5MInpF19QPp9Dvu4SXf6upIH7P6S89+SwAIvIpFbHDZM9Dcy0wXhm7Oj9EwxSsQM9P2PUQjseLyq+SXyj38uJsA8Y3ok7GT3oNWqzHoo8iTj2EXXTNYB8L/eJkdFNQgiU10VeEpbwemv61cgFF6Y94itZixjqJz3tbDaQhF1RegnzeNrUXFm8vNt1BTeGqL0rmtC54PsmcjFcJW14mHlKsDzszh+OzyUUKGuuQxwU+tuNOuwYKR00TjUZrhVrnDOSrbIwHCAJ7zOjdrxXGjWzHOT0cqMUhkAa2hGGZqBlrt1AKDDspnvfK7/KZoJouO9nqesj53Ea+XuPVVFY0v23rcPGvjwy59OUA1TZKw0eZgYP3ELRRKlMGJboRnqZI6eWyIk1DaHcLLXveH7f7aiSt2mYNGPThfk6rUnlr7la8if8WUhP4aQg6BkHVD3+gjV/5FsqePH2OcPPpBMif1dVLL347IUl0agAqCgVLSgaVoOlSFrcYnQgXG03e31by2dWN02XOTcnog94QGmQBudlqkCQuGCpR67s/xG2Gb703LVDJmZ4T+EfyY44EuadRrINcUOi44W9ZnBX53BmnTrWLdrUdf85HZmbTPZpJDH0ES80LfGu/VXawO5xFg/eQENoYmjW+I4XhhrlwuY5gmUQbUu7KNh5mwG900FmnLQE0SuhMAdXsiUs
 sJFG2KSf
 YTQ/KcdFYrUxa98fs1SQtrbOpIIlljX6JWVdG+RXbF954WgfCpf47VY9tGbRBUKohIUKrdLc0PebmkiGvvrv1Vocosucmu4tm6Qz/Ko6/w6XULHhWdavdlIeyPsyBkDdwJhy9CEn1OfCnOqCt0iTUZMgX1Z4QWvowzIsyeD1wY+uB7dkMCrY+kfJGbLHjTsWzBP6alU1ljbcz9jDUoqAigHiHeZ6sJu+bvnZUQWKsjaToKSHG2ned4jVTMDvb8xNbHLKIr5jphmPKjzeVGKpmQq5Z9hR7eHsMZf7G/gftRAmmLB8ahiGkG/o0h8jNIoWWEFN9+emSZPtB0ZyrXK9xqQCKiWtHM6OJx9Py2vOBWzx0oQ11BUbQV1dcE0JZ6cKd6a2Z1Xz6nlKaSlKiKvlWpR9e3of0D15jva1fSJQhHVylG4WonNuBXsHu1K5V+CNfhvukEbJN67McAm0Nx8o4ttsbyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update the guest_memfd populate() flow to pull memory attributes from the
gmem instance instead of the VM when KVM is not configured to track
shared/private status in the VM.

Rename the per-VM API to make it clear that it retrieves per-VM
attributes, i.e. is not suitable for use outside of flows that are
specific to generic per-VM attributes.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h | 14 +++++++++++++-
 virt/kvm/guest_memfd.c   | 24 +++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  8 +++-----
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b53a0c4b4dfca..3f70859232b07 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8060,7 +8060,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7de85474c75bd..3039b291e4b09 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2549,12 +2549,24 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
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
+static inline bool kvm_range_has_vm_memory_attributes(struct kvm *kvm,
+						      gfn_t start, gfn_t end,
+						      unsigned long mask,
+						      unsigned long attrs)
+{
+	WARN_ONCE(1, "Unexpected call to kvm_range_has_vm_memory_attributes()");
+
+	return false;
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c55879e033d96..78e5435967341 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -930,12 +930,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
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
+		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+
+	return true;
+}
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				struct file *file, gfn_t gfn, struct page *src_page,
 				kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct gmem_inode *gi;
 	struct folio *folio;
 	kvm_pfn_t pfn;
 	int ret;
@@ -950,9 +969,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	gi = GMEM_I(file_inode(file));
+	if (!kvm_gmem_range_is_private(gi, index, 1, kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4139e903f756a..0a4024948711a 100644
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
@@ -2450,7 +2448,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
@@ -2584,7 +2582,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*

-- 
2.54.0.794.g4f17f83d09-goog



