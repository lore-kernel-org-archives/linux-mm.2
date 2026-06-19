Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735ECCDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8039F6B00A4; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4046B00A5; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2EB6B00A6; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABED6B00A4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 827C51A02E0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
X-FDA: 84894784548.06.FB5D439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88047180006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9DB8Utj;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829112;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNdrlV7OONAeLzc3l2iYwGT6eRlK3ZbBDI/CYO+xD7U=;
	b=I7FMAJLP0FkjGCili73zvxOIcknmpOzzbF4OAjE3A9tawdjR+pgsGx0a0ejErzah7gjxIF
	xO5OfsP6YuHBCostj6MtfETTkZkHsGqyPshpX2PPa2KqNYRf3DilGAX1aSHA5m1MuRXrSG
	UgG0W4noTOkg0aeBMVVmBFz6fYSDbbQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9DB8Utj;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829112;
	b=7KF4t7j7p6BMeg9uSMcsu+3Qak1zxV0vReMAyLmsYYbQkzmAMWMVZ9lhAQUQHIE2g1IV14
	mH6qJqBEn0t2Gj1MwfWPqVVs22I1XLMB93czIdeAnMu+UmukYT/6lhDjJs6JXlZnGK4tzG
	1yj71bA15zYecn2I4fEtHzjeMmAYH44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CDFA4464C;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C19E3C2BCFD;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=ffPfB7W2p/X+Zi6AqE5YxEoEIXsVcYfg8B3a3wnpzfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N9DB8Utj0jX55WECyxRQhq4N4sf5juzgrtHCKzCutbnD1GsGxfuXYAaORcRi4VD5L
	 Wp3RZZ2Ef5QXMcWDb+OjDQ5KSLzuPrTeLD9YBIeD+poUMlF0xJXPMVB7Qol1tX7ql4
	 3ThZhFNEC2UauSdsWD91VzX/pu0Z0sKbY5OaqT02as3PEmpqFSS1g1j4+L1J/s58mX
	 3GmAU0g8nGH4jNRvQj+EUH11DnowQbmOPdcKzAtIsbpteCb9nZH9u2HMusOkIWOMHt
	 ldya8jzgLVDoe4b4dKBcjsbj8Nc9M7ZCGJ4F15s4nI3d/k+JJ63bzBmQI57dkPQBZe
	 QIVKVgrvRVTYQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C8ACD98FA;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:48 -0700
Subject: [PATCH v8 11/46] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2246;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=s5muBk4J2pYtq3TG8sGbu83VhdOzartFjXOVxIUT4J8=;
 b=pDEXXqLxVt6PYEExhSMxog1SfopkGVUT8KzY2GzGAZTBVHM6jTpMDtzJqZZt2GbnQTjej564I
 No/3pACnkqdBgAIJ9vdFJYvp0jrehi/Rr8V6zaUIPlFN6fK486xv4Tw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88047180006
X-Rspam-User: 
X-Stat-Signature: i6un6uoyusic37zsji9rbi3ckwr4e6eg
X-HE-Tag: 1781829112-991343
X-HE-Meta: U2FsdGVkX1/JnRNf6Z+hbZHxulD5U6nFMCFtrk5fHm22yT/6TxwJ/ZuOMs3XVukNfwxRA+g6fWe4vrPLNlHY+nGMndxAYn0hS/LjdfT1qOPshi6kHKZW4FFlE9NxMVquCYuHKzKvUjfUdWseEVKww6YmCtcnQq+jz9r32J8bZkstdwEctCMBrHZhiz+tnjjQ55HvTeeO1PjQ0oEV2yATylg+5n2MJjqFoH3BiwRB8DmaQ5sFqNTFU2cBnAUpPdnSi2e4rgijKRW+D/ooZ0+YXut52clbFwgkV3DvQcMnIq6B+zBfU1gp+LnhVggVzXXaHRg7QB9Rs9W4vel3ifA9qAlyI3vwJ6kcE5LqYH73EHs0sF3Ukp0BLNi2JW+VE306ZieOTAyIskkX3RYK7YJmPxsXWMmlX6T7C5oCCmCQBJK5qW2D1UoVg0rNRpQWe0ZvIoYOCJ+QhQcGqwJ4UFtIW6plfyP77CXrbOwndqP2pcIZGrMaKyszU7AOh7DZN7ygdpDchLwcoMJCwCyimB2/Zjopi3N2ojz29d51EXdjkr8KA92UbKFtqXwfjmsrHvnbLxuKSVJrkVodwNUwrLQEAaLzrEOtF/AO5mC6LgL99gjAHBzTtTNhw5oVl24f7LVpXshdYroqFYJpT0PuRLkhtpiBEQex/6KuQGmq0n/7r4fVnAKq9jrfv2/RtNz3d+tc4MMVgxae0/ag7n/BRHlja6ZJFgx3d6C0R9JEAiVVyf3vjXInDRZWcieAx3+v1Ji3EtkSxyhwIN8B1ODirCG+c7MBmHylB1Asg8ewQoiQYak7K5w3SR3z5DiD4/JV0wJAagdVbuqmYgUygFaDmqxhtvSft+67+aFnd3LPAeJaZYouTt/XDrSvPAH1oAj3n2kh5Be9xctLR7LwhAL40Nxko8fiBdyngBqNtPzpWjrD/IWxZ9/h9X/IcaIVMCQw39hqvUOwCT49Vjzn5yHoJ1t
 oiZ68vnU
 y2cktm/a7x+rY0PkSmX1YMDQPr/cLcMMzA0x69r+0IkForCVJuFxbLCDC09yqE2r0pM+QL0iEW1HeO8+DGQVj4/Of2otpQEvH7MswtjiTMwKNn1CfXc9HUM2ric0hieHplBdCMC5QG2rSI+bG2o9PXAR4qbi/mTaPJ6M7dYrX73Wl2V1/3WIJCtARgVFrepwzG/hKyO3MHXndAHhXLJX+zSUmezigrL2JiIEojg7nSDGt7Ypy5ccsY/6F7lx0BIAe43SUoACCqIw4eatCknSjt2MfMZPMUD1M9u4gkmNdVWKRUuWE5PRldy56JFcxAvq8ckZBuuGfF6BCNNm2Zx+LDQr2jyE1DZf7rxkzd4BDWicUz4+oPiPUsswUeVjJoG3Z1CdinIbXjIIMNDb5RgzWZieMOddg2DXjobRUhdq+jXBozu5E5RhddSMIJOoKB+eNu9uB421F2EAg6yqiLqchHamivyukTx/Fyoik4jTXyOPAn37gyo5W3o46rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
and so that related code is clustered together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index acb552745b428..9c1cf1a6559e3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef kvm_arch_has_private_mem
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
-{
-	return false;
-}
-#endif
-
-#ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
-
-static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
-{
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
-
-	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
-		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	return flags;
-}
-#endif
-
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2572,6 +2551,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #else
 #define gmem_in_place_conversion false
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2580,6 +2564,17 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



