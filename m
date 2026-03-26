Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6764E10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC606B0093; Thu, 26 Mar 2026 18:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F896B0095; Thu, 26 Mar 2026 18:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9570A6B0096; Thu, 26 Mar 2026 18:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78F9C6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 484A91B93FA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:35 +0000 (UTC)
X-FDA: 84589644510.18.E5425DF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A5CA140008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VQWA0tPp;
	spf=pass (imf23.hostedemail.com: domain of 3H7LFaQsKCO4QSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3H7LFaQsKCO4QSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uuod0qNsBqG0ybFgd9PBXDc0yAcGuU/GT8QI9Nhe6Gw=;
	b=3h8skO4hGR4/afuBGGpufH+HZrtYWVZCCsEVWceLXTd1WBTh8CY+7NzWyw51vbjnNnz6we
	x1e5fpx2SlbIcPOHRF7T166g8e2ns54acHQcd+8bLAgVxm02m0JPPbkFVHWJNe/l2vTwag
	0/kDadHhPziqnPZeWWpWMX1NI3LbDQE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VQWA0tPp;
	spf=pass (imf23.hostedemail.com: domain of 3H7LFaQsKCO4QSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3H7LFaQsKCO4QSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563873; a=rsa-sha256;
	cv=none;
	b=FNlUKOabMcJD91OKDPip3s4Q2y4algV5SNvPXCLL1MbVv4fYKqDlx284Dpkm++CKVT59qy
	iN3vlAeXpTGwk63rM/6CNbni0jp8knsgzW+KTKpzxTaM87uWqK8bvRoWAVokMoyEF29WHw
	+FxC+UGzZwFl6N2a8S2eOdEqQ0aCbXk=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7380305a9aso1776437a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563872; x=1775168672; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uuod0qNsBqG0ybFgd9PBXDc0yAcGuU/GT8QI9Nhe6Gw=;
        b=VQWA0tPpE1gMznnHQCnOMdgrJjQT8OYl2jVScD1p4sFcHVVyBz9LrH+Y1U5GWQTMH5
         LYewEn7kMwIOOkzo3X+RjAkvpBo6T0Fm98hR+JQQa9fwXOL5NRhw9DR8ZHT/5x+sJYFJ
         CWYh5RWGSwO38mAt1Lobwn2z5zyNzMrzl//VCvCktZD2hCyMfJmjN4CMMtKym93ahDX3
         WzCmzMeJ5mmqxvXLYRd9PiBepEP8hE2E+R4kKT91GG/kiSQ5Yx68TSTbgmtTKiltccx1
         3g2/aUWlArNq9hu32cxSaPilyeUEEbYytaQZDbvpOtB0pZj+0OPokLFx09AaFxc3E/tV
         8+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563872; x=1775168672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uuod0qNsBqG0ybFgd9PBXDc0yAcGuU/GT8QI9Nhe6Gw=;
        b=PseGRy/VnrEfrmz9X5Q8WyfCjjnTBU7RmJJHd79LfsdNO2YoZXF0slKfNX2F94hTAy
         uaf4yOhG7vIFRM+0ZBhm010qpF+yZMhM6NQYTDokC8zBBD0v207Iz7t4E7tstt1Ha+6C
         +93Cq0v7DQLtpRX86Rbo3nJBsRQ/446Nynj38/HzwteZ8SctQ/6v0Mt3CAsfZeXgqKoE
         EG4HgL/dele34oGnfrkNZKbVa4P9RbsnYf6/8rcd+9h8F/TzLE5AXxiUvTqvqxLWeoqs
         H5B9Mzai9i2S7sBUXWMJyrKfaLnFYcit2KVz0pPxQdxfwOs65C70D+3rpgBz4zFmrEG/
         VSKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkGc07f/dk3pc7llTrvY6z44QfxlgxQY1aQR1xigRqGqokrvVy2TGnLLsW33+y7aOilrrOu6RRLA==@kvack.org
X-Gm-Message-State: AOJu0Yz7QkjjS/201Nj8iMbNtVJ+VPaLY95JtiumwCjc+R1H8yguxK9r
	QNQXMSQMrSc47RXXoCCu5JouAjDeVHdqU8Zca+XSHlnDjqlNuYo1IfYdJ2hMtW2yMbpAh8wU5sS
	ecZ9j530YIbBJd8I3CSo61x9ntQ==
X-Received: from pfwy40.prod.google.com ([2002:a05:6a00:1ca8:b0:824:b498:b016])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:734c:b0:398:7796:7823 with SMTP id adf61e73a8af0-39c8a6c2c3dmr53801637.6.1774563871440;
 Thu, 26 Mar 2026 15:24:31 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:13 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=7205;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/JytenNZfjjNb9hRJUQg500AB0c4FxxGLQWAYRKsn0w=; b=4r4+flO7ttXNdQ93SWrdcLKha6lQNoz8f2QPBrxTfNAA72iRfUoeW262p0DxOmnmH5JuJg7+G
 HNG+G6sGKY1BRkJ5Tm/HoIP7Ry3hoOe95oqZJa1ynzR3czBKZW15qf6
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-4-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 04/44] KVM: Stub in ability to disable per-VM memory
 attribute tracking
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A5CA140008
X-Stat-Signature: y9f6hmphwcjo1yr9siw4ein7q8rywdbf
X-Rspamd-Server: rspam06
X-HE-Tag: 1774563873-293871
X-HE-Meta: U2FsdGVkX1+v6yBZS7UfwRfhw+2qNWAorSyeREmNOXFV118uTqD0ipibhm5yTp9cx4PRnjg64ohUy8muSTfwtJXEyQTk/0tIEMXsdQka2Fh15cr/eu1v21vvUUqpIOV07koxCXR1oIkkRow0jFC/aQ0FajHbzmcIrTKYMbtSq9yi293F96kRKnB+TSIdJjsF9uT636iXePE7y+Kyvd+g/hbEsCFViz4HDhj8IDpeseIZXaMlBiFw5JOWCiu6DuJLkKlp1ZqiLon8nXi3JL0Le6Xu75r1JuQstkeKemSMA4sZfRw7zb52+Cc3YfZPYNPaCifFkmOSPQYKAHGqYKwGEiZTUe8rjyFCGiXDNDswuMUNYhLVvsp7pUoL4DmM3n8oSL5QplN2tZanfrJetK9SucYh0iu6LdSL7yIWPvlghH7QtPDz39hHbPEdD96L0KpJQMPpBKugPi7/f5pze6EeocZb1jspRnX26GlRLhOawZYyLiLPXFLKUR9QjIzcxaQeQNyOzJA1JhI2pjMIgQ6DYn42qzfjizUaF+ab3t98KDhJhkzeSxhXkfdrOMStAAZ2GYAbBICE2VY49iEwMc1u/ybBTL0ZckEZp1U6G4O/2kgzERob253wix0zw5Qg0+JZTEqNQWoKhp/chPWPUWJqMue1aTEzHe0ZTOktitUmfcH9k8hS7f/laC9cqUEvZtuJqUOReQjE/As7ibey6AF6V0EdcNkBk2A4DJfYkwTRq+a2a3hFWD+AwRW9YD9kQdBlhKQYaFpG90psrJtFRrq74BEFjrtnOFFdgvu/kewci+xUpQvoGBvg6t05r2V7L+0vDsILU8qq1O32jxcDXta4E8tfh0FFksiK48uMt8rMvTD3b67Xd3irq+bbItNMvXYU9p1S/w1rIzxwlKlozcQQIKBjIB1vQ4iaK7Tq/QU2SWYRrVR3/JnCnKntrf1hLfjYmuwfTmhQlpCUga356d5
 O9o8W9SY
 AkQGe24CiUpSPV8n6wqKUu1x/CwhWpGIWajTEYmpEKjGee/JKiNoiyFlUjeKgqHFQUShVL+Q+VzeZ+Bh8QroWi7l9cAIlk12wCGsYcJDOG0urdi5sgrkx00tkGhhVeLxsoDxndDwO0QSh6VZ7y9gef0ssXmvwVyHrP5QUMwwb0TedNRQ+ZAersNgf4zXP/5uPwZF1nl0h7TvAMdPg4zciqOiAJYjonPKVjeVBISXibwKnd7pRRm65pR5mhEia78LK0/56E1tgjD7zZEO5RkEyhmfu3mCfhg3c1Y5NJQ/rkYYhhP8f6QYGHv9u32r6dQkdxZWPHBvq5Zpa3iJoqrh5d8iCTDcCqM1K6SrCyoC1qM15hfVAepStt3O/ohHbbH6tcfJdxhkIeSJThUgxUUZUxVtoMDiMKwuZuoDN52o/2sZaYwSj2nqZUdlKyU/uDILGVsr0mXWKyg5250FKkcpPRdQIM/G8JbLoBN8V4CWQeoQRdJ3yg/YuJmQbBQ30vNhEg94ooZMTYiDCJ2gRt1aTXQPDDx34UXGs8ueD0oZtfKs8EP14sEQfLA8KJul40mk0EgHBjp2S+gPBSkHx3t+UJFKmQyk4oRZEes3oXHK6mp5N4KUa6YmO/jry5uOJqTJnBG8HJHPaS5oIVn8lrualCZh0eAdHxXowuRjjHXSV4iaEf4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce the basic infrastructure to allow per-VM memory attribute
tracking to be disabled. This will be built-upon in a later patch, where a
module param can disable per-VM memory attribute tracking.

Split the Kconfig option into a base KVM_MEMORY_ATTRIBUTES and the
existing KVM_VM_MEMORY_ATTRIBUTES. The base option provides the core
plumbing, while the latter enables the full per-VM tracking via an xarray
and the associated ioctls.

kvm_get_memory_attributes() now performs a static call that either looks up
kvm->mem_attr_array with CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled, or
just returns 0 otherwise. The static call can be patched depending on
whether per-VM tracking is enabled by the CONFIG.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 23 ++++++++++++---------
 virt/kvm/Kconfig                |  4 ++++
 virt/kvm/kvm_main.c             | 44 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf3d2bdababc7..537f25121e345 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2329,7 +2329,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ba42a1278d5f..5393854ca5966 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2513,19 +2513,15 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
-	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
-
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
@@ -2535,6 +2531,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
+#endif
+
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long mask, unsigned long attrs);
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range);
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 5119cb37145fc..3fea89c45cfb4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,7 +100,11 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 config KVM_MMU_LOCKLESS_AGING
        bool
 
+config KVM_MEMORY_ATTRIBUTES
+       bool
+
 config KVM_VM_MEMORY_ATTRIBUTES
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 793a2c8476b09..dbdcef90a4950 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static bool vm_memory_attributes = true;
+#else
+#define vm_memory_attributes false
+#endif
+DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2425,7 +2436,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
@@ -2436,6 +2447,12 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+}
+
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
@@ -2632,7 +2649,24 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
 	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
 }
+#else  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	BUILD_BUG_ON(1);
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void)
+{
+	if (vm_memory_attributes)
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_get_vm_memory_attributes);
+	else
+		static_call_update(__kvm_get_memory_attributes,
+				   (void *)__static_call_return0);
+}
+#else  /* CONFIG_KVM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void) { }
+#endif /* CONFIG_KVM_MEMORY_ATTRIBUTES */
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -4932,6 +4966,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
+		if (!vm_memory_attributes)
+			return 0;
+
 		return kvm_supported_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
@@ -5338,6 +5375,10 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
+		r = -ENOTTY;
+		if (!vm_memory_attributes)
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&attrs, argp, sizeof(attrs)))
 			goto out;
@@ -6528,6 +6569,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.53.0.1018.g2bb0e51243-goog


