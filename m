Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886EAC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E114F6B00A0; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1AB6B00A1; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89486B00A2; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 906B76B00A0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1605160398
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
X-FDA: 85159670610.23.7EC2EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0AD7014000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lsl6nZXs;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135924;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is3NeFUnpnuuJgpe18uwaEPgdGAshAmbjdX1u3cRvYM=;
	b=RFUkBjmr5NGjz+4siXPdDwUfcWWqJVforDq3LEj/V6Z78c+JAgFPF09z3X09/mZEn9yfH/
	2IC8OmtLmIBqgrqCF7RQpraE68tY8m9jczHstG8WUrUrpxCECJf2FCEXlKk9KjJM5U7V1s
	6533DF6V5jPJ/1Qq/CpFbqe7np1DfCs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135924;
	b=KSeb5870Q2m1qBJ6tHFs24mbFNCKefDyR91ca5mdJ5BNIea/EVHu9Mds5RCbC2TxjrQR4P
	fXygZfsY+nywMb19tHwiwuBfsIMs30zje9yDkIZMhY3Sq9z0Stu9jyNW7mhcnWvK/q9uk8
	cEmQnVvqkZaK53eDJyoqGZXCE4c75C8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lsl6nZXs;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AF5B44784;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FB72C4DDE5;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=NVIB4YZ2kDgX3qlQ+0A5ajMihiiTtAsgO51nyX8IOus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lsl6nZXsNgATcI3jmXs23yepveXd5oGimMzXreiqX7FTUIyIpm7Q3iHUFGX5N7ODI
	 zSJhA9Xavsd/pCjLWBrJPF8et7EzFZnqUp2GnshDhpBYzHzKsUJAAtMnbJS50i4NuX
	 MOe8YoOey3AcRCSk42GNi/p0gQLtyREsFUolSwH/KlMAeccEtQpZnOtCHusOtOSAQq
	 jCROPdORw5fz5jskYdTh+pHXCzkQbeDVYcSR1I84LE842SlJOjbtfOzXx7LNK/q+Ih
	 t2AJJgSILt+IQiV4Kr+1M5/GZ4XSwrnMamAlfeGIeyZ5bfkLWEpawnwbAnankzHpqV
	 3qqkvbbkB1p6w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2341FC61DFF;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:09 -0700
Subject: [PATCH v12 08/45] KVM: Provide generic interface for checking
 memory private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-8-85e5fd25252a@google.com>
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
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=3261;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=FbOIpdQVO+RwvRFKHPGy4BnPCrkZsXfvGDUTuDvfNzg=;
 b=gQ9Z+DSRv+BLdUurVmhuuUYQtb0izEpsgSvFLb1Fr/+8fxBISS4sS0q/umexz2Tl4hikiChn8
 OqSEFW1Rlh+D9nERLQLR9zZUdBpXbj8Dk6OpWJlGXSDA6W1ca0RGYv0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: xrprfpibkjm7cy4sk6a3oihpc8gc1gzk
X-Rspamd-Queue-Id: 0AD7014000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135923-280738
X-HE-Meta: U2FsdGVkX1/nzTuREYkQSRVmm8Rk3cg78Eks+FdTY7Gt62bimP7u08gIP5lP3e+5xMJmRMSF5tf0yMlab50Nf1Jq0V5973AXLwO/ne1oQiUCvpNSTNplR74gT6znt2JHHtRf7TMoaL/wE64j82qmU0WV//7khfduVB15vkbAfDAS/VZj7NGzsZ+ZjZcISu8RygZHYxWU+bZOuoWNzoVsxSkVbPfH/MY0M7nhggU6EnYevNoxya6Q84jgQEY094MZiA7qQCCraPffWtBA+x/3ePGYWrLJxS2CqTa7v7VgoeYjA52l2tf/dSyWfaqMr/En2scrmwCEqcpn9yJ8NspJEGma8FH8IdPx3m9RbAB7tsmIql4ihsITf4ugliioSJyfYHBUBvsyKnt0+so5Aa5ZA6Z7omRxDgBFI1so7uRM2Ebl+koBTmGlOPuGIwOAC4ioIsrOEKyg5P25IaPg3SicPBHd+zAFNmUk6fDrlpmLEeMpH4yO9ncNt4OcJZ+RU8cvMvRVg+ra1Ep1Z+2PJQexHgFpCQT9PY8qlErmVKi9+2JEKtble+Leo8YvKgM2rPtNz325w71RQeJKbV59RVsfoOTJdsL4cCtUXtNrHIaDscZ0U6srnyaN1WTQn2ZQzs62ggXIo+GNZ1RRDEK6R9eGM38PlSR2iCEZwhuSQwk/LNmNQnWEgrsjPQRgXEnfKcXXvOQr/Mmul0MzOLtPyLQ2mug67FCwXneWA/PYPtRnTSbYBU/bq2Tj+t7jeSYay9QISkUjANP3BoWZirtaoWE6bTr0ENOzQucXBPyhZSkoit4/QNpoVsw6GvxoJBVSOZTC+Y0eD3nHdUgN3LDnKEc96AuVaOqcNrnW3v3Enj1epZakjdU2ofDOendMxAGCxfHEb+UqUVigMDHSFugMglsxQy7K/9yLONDdZr7TkBh9/THtv2qHB06Kbcl80qbedxGVV1UtHXxQ/rRJZTBxt3u
 CJrxhX28
 z8pZEMULX0ohKtP/+3dm17iEV50yOxTf6IJj8RltGO9lGlu+Eb7v+Lv3a1bR9oVpu9hfYcm6fURnMw2/5c98aZmKctv7r/c3ImROCIj50mF9VSNkXOUB5Xco3n8YEuAw0V6P2r0rfPjNrh1UaQLnDqq5BSS1JmXTxtZhCkgwSORIhBuFqChs4FQZ/8RonTmOdWJbOImMN/DEcaVs9lsZQJwcJ96ckKPhBW89y4lEUVY0mYQiMDcqYEcs0cJKsOcG8dCAAD5Px/eOPcJwopr5PeZQwHQEzZRl+otFF4uicFWb14A51BoOQQlXt1tYc1/8Py6S1Q85zt0DaQALD6JRuUHyOFxFsmnKazkJ8Y9+LQrqPrwlDOCeXqSrTyMzB6iauFcLrjffRt+ZJjqNm7orTNEMqsDzwWFAZloehYda/9UTdxttJDKsDH7z/vezDsdF8NnPN8CvXXCIsuG7MrS72FSgcgGTHQ/OsHVpr/4swM/Hlk372Tj/YoQRChQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce a generic kvm_is_private_gfn() interface using a static call to
determine if a GFN is private. This allows the implementation for checking
a GFN's private/shared status to be set at runtime.

In preparation for choosing implementations between a guest_memfd lookup
and the existing VM attribute lookup, rename the existing
VM-attribute-based check to kvm_vm_is_private_gfn() to emphasize that it
looks up VM attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++--
 virt/kvm/kvm_main.c      | 15 +++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9b97266f61ec8..3579feb631775 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2573,16 +2573,26 @@ bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
 					    struct kvm_gfn_range *range);
 
-static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_vm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
+#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+
+#ifdef kvm_arch_has_private_mem
+typedef bool (kvm_is_private_gfn_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_is_private_gfn, kvm_is_private_gfn_t);
+
+static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	return static_call(__kvm_is_private_gfn)(kvm, gfn);
+}
 #else
 static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
-#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+#endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 91d5af7d60d0f..78278730b2ae4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2628,6 +2628,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+#ifdef kvm_arch_has_private_mem
+DEFINE_STATIC_CALL_RET0(__kvm_is_private_gfn, kvm_is_private_gfn_t);
+EXPORT_STATIC_CALL_GPL(__kvm_is_private_gfn);
+
+static void kvm_init_memory_attributes(void)
+{
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
+#endif
+}
+#else
+static void kvm_init_memory_attributes(void) { }
+#endif
+
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
@@ -6541,6 +6555,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.55.0.897.gb25b4bd76c-goog



