Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5855ACD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8C56B00A2; Thu, 18 Jun 2026 20:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59946B00A3; Thu, 18 Jun 2026 20:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C486D6B00A4; Thu, 18 Jun 2026 20:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE946B00A2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BB651C0531
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:53 +0000 (UTC)
X-FDA: 84894784506.08.854622F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37D2E20003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UQ8+Sr/4";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3iOk5+R7yUzIADWkfl3vaMUuFfqD6K9oBKLjVV4PT8=;
	b=NG66GZuNdsrvCcb4b4nBDy4zW1p/hA5d7IvLNf1TAPlAaqQqnG/w9KcB/4U0cfy5fpUPw+
	CIZJ+R7sRzmStniHlOw300zfBMsBHaMhWjomvQpxe0Sr9M077Qpf/T3v3Nv9xQwm5r30uX
	jkC+11ra6IT9ObhBqcR+ALHEW0TKIxI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UQ8+Sr/4";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829111;
	b=3E0SHmVtG97USGUk6kKFPUQJYjiJAWiOq/k5DY5QEzRm7uy4N4IDcJTkd2VkirhAEtbWLR
	pnjUlQfkbY0+5Ede0ZVBjHBCfy5yenDVUtK6voYM3x6cfMz9hOs8VnFg0A930olbBAzjjz
	EIM8marAucz82J2c0LIug3uDwOKSvkQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E96E744618;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 780ABC4AF0E;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=0H2IgUs4dzVuCzjrH58X/cGXGyAD1oZYLqxV+FhozK0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UQ8+Sr/4zjoDRjzngdzG+gtJ/Lw3UMYE+bD4PvXcNhxrUWdom4NYXl1FsewAJlomQ
	 jO5O50TozuER7C5k837zaleXt6t/z2YLcKFtI8d8wARE++jPZDpvMKxirvdhKD+x+1
	 jWxoBAZ/97yo3sV0B6DnucD4LnwyQu1nxPgO2QSm6hRc+4CLl2DJspZHyvhUMOoed7
	 ABe1WaS2sWYfpjiSUr5b+Y9Eo0J1ECJngHQBTyVys3pJiGeTSrrZ98qVCx2xxzwopN
	 U6UVESkCiBrwi+a0cHBWlV6CfDDJvI9qM61ALWnHGUpNyqnmHaQiqmtPHogkTlPVJg
	 gWqW/fF/plK2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68400CD98FA;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:45 -0700
Subject: [PATCH v8 08/46] KVM: Provide generic interface for checking
 memory private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2977;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=r3yEEx41b7aixiqjjkGloSiqCgEFBbHdxuv0LadMDeU=;
 b=xTEebEXKr9XNrY/4ClqfxpuFQfAULsVn5D/QsFNVlsoF8ytkLlqq/u9gEsk/jwR8B7+W/Cpf+
 L3vkBV+fRWvDMKig52v8OLurUuaCFzAdR6qPRXMtWgqncjfEOV0c6zv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37D2E20003
X-Rspam-User: 
X-Stat-Signature: 7djr3xsqctr7yaqr5i7pcahwc4p1s99p
X-HE-Tag: 1781829111-768914
X-HE-Meta: U2FsdGVkX18etay2/utHznKHthvYCbLyHYlz8x15+IJBZ1DMZ9hNPyF2wxpVjcentwrWRONat2CMvRAlFtGa14epBnIfVjfiq9FzeRnPjk20B/TdVCpqenbjDclEdpoDADbPgQICpbNJPWmUTd6H8LQFmZ6IPH4mFz2bc4DzzS7g3qHv3I04qhmMnmIogKWpgtfX1+eFqhGgMSDsYY51zxZVyBoVdhxPGPW+j03y5IxUp+gz+f4Pau0dhpPeYoM1VZuI+xD/IwaBGLEmqZugREU8yyIYxkLJRdTkYGqzyEGtbRgQGwmw0JGqDm4Tn3JSgy+v44a6e6Yd9mRUhD5OfZexe5oZlbTg+HK9tFYmcfOVHP4sxdQqgg0vEFfNie+rtYPYATwFbpZ93JZJxVFPpUOeDOcqAXHx0I9rNl/mgUNdsXBplesxjjX/dzM8qWu+Xdjhxa5DT5NHnXXPuFCJ1OYESehmTPANgM/h1lFvUMwgPO8lrroH2jz37jqTZq/sdshtj0NJMApaBdJT15IpJsHEsakzlYmZhS2vGw54o6QErRIBr1klB7UObZPGz9cExMefkjyz69RY51nJnL6PZgVVq0YpbBKfzRRzdS/RkmRp0meKX435f+w5UTXTp1Fv8WKf3KcIYnAoLaYmJm1UwmZBVen1BFGhN8v19UwLugjh0h23w46g0lnlpmDvHcyeM4GWC5ojtI6h/XuPPHwNiIi3Tikorbg1BGyqfPV8dUNtcG79TG1DHsAh1eTlObURgXmjv/R1p+d8Knsw2v+FOtZrV26lkd2M/zVWihbJ1o6dFDrC90gqjS8pGnQE0SB3nlnF83fG9BejPxQotEtXg2edbFMzYUqr1eJK7uiUYblwsZYfhBseiaBNAXoFDojcexfQgkxRgrkar7srv0oziQzib+g9Kjpoglq4Tf2sTKreDF9LBiSZH6LiseRqFYB3aDu+E1C2BD7YJ+KmZEF
 Q1CQXeuD
 WQ2goO54Hf3I/aVi8StOGUeBr+E4UzMg95WZJbmBsfFFUlsuDmjl8MNsnWzO4nW9I9dTgK9UV+0LAr9dHucbMJGgGSW+7IIDJ2B0b7H+KqXs7WlloUJ2DBdRUzfPdY3LQZDQJGCeY/gSuuhs5xvvsTzGbNgfFrLQCb8YPbwpimEhEnIGi+eDK+UB8eZFraolQuVdvG8lhprkhhi318Sds84YLxBrUtFiCkWMuQsJWbojkc18TaGSZ0BF6qln426z4cAk+G3AU8EkPb+cRjIlm58WWZH9LW5srnALvFmZP5CfyAw5q6MwfJzhQlMfr2F0YdbjpNe42ahE0yABKzvR6mshnNp/xtH7+jFyH8GkGj44DNYSr+keHk9mHBn0MvcTMzttglh0VJ6PJohBXM4Uvv4GNJszTL0sds70udExxQO/aFNBopxKe7+cnb0j+qucfW5NW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce a generic kvm_mem_is_private() interface using a static call to
determine if a GFN is private. This allows the implementation for checking
a GFN's private/shared status to be set at runtime.

In preparation for choosing implementations between a guest_memfd lookup
and the existing VM attribute lookup, rename the existing
VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
looks up VM attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 12 +++++++++++-
 virt/kvm/kvm_main.c      | 15 +++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eb26d4ea8945a..3915da2a61778 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
-static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
@@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
 						  KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						  KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
+#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+
+#ifdef kvm_arch_has_private_mem
+typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
+
+static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	return static_call(__kvm_mem_is_private)(kvm, gfn);
+}
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6669f1477013c..8b238e461b854 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2627,6 +2627,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+#ifdef kvm_arch_has_private_mem
+DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
+EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
+
+static void kvm_init_memory_attributes(void)
+{
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
+#endif
+}
+#else
+static void kvm_init_memory_attributes(void) { }
+#endif
+
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
@@ -6528,6 +6542,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



