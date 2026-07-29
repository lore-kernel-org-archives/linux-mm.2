Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C07BC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1812B6B009F; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142EE6B00A7; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89316B00A5; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5E126B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48F431A05A1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
X-FDA: 85039944948.18.BB31A5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 526F640004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKKpH51S;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOVsbsuqmG84W3H66tPBm+yu240/Kw4sgMgG5XrKGRo=;
	b=HARGEh3wzwcoefdffRvk0xdm6CnI82KrXu5sCG3nqTQi5YYG9W+tmvzkM1KZYBxb5MTDkl
	4B6z0UaS9EG1WrrhHBhPiZuxGRp30qCf8PdBabHYBet5aszXpATnsy7PV7IiVwtoRBAsMo
	AsvKaVREAflGFd1BE8BL6kayBmTWtZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285312;
	b=RH1qGMHjDPKBnwDz+B6LqeE2A7e9nE0PY0AbGs4aKOxd+Pv/xxY5YR8oJf/KznMrS8eQHc
	6ywqmT0nDMrUt8d0DGN6VhsZeHavEIoh+ZRDIxB6XuxyiCvRJec/xZDApLKpxjXjombFDL
	yCTXCHkRGmwXr3csTdPd4sEmDqia1JA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKKpH51S;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6E1945166;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 281CAC4AF19;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=Rr+fXnWaxGybs+AWEondw/0B6Nh+LgNpDLrKdIyfAHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gKKpH51SjITRNdhUTuh3G3X0yqQwxAESgR7Ikwou3Nq7PBNWDsKLPHed1YxLUdXWi
	 P5MsMkyClfkKfWFTpvxx+LewIEDMs5dwu+d421k1yGpJzE2tInf/gH79bQaZ3y1aFj
	 uR5fLuKOB6Y7UOlTY20dZFfVnhrmHxPs6+u+QnNoeSBByz3Pkmdgg+21Bq1guMDs04
	 JKM4OAeVpxEgd14B3Xtw/K1ivPTstInsfubXTjMicqPx8vzQYaG/sPVaL4dou1twut
	 90gD1Dwl01f+Xo1YQL0YCu8K7Wma/xDg1n9m24N80dbpjvyD860nuwZPtzWB69cfhI
	 E7j05/xWvUUcw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059CDC53219;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:04 -0700
Subject: [PATCH v9 05/41] KVM: Provide generic interface for checking
 memory private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-5-35f9aec2aed2@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=3207;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lo4Gzy+LZN1Xb6HGgda47M2L38FFpVZSB/P8dGlPKnM=;
 b=iEl0F2TmAh0HZuon0fRMIFG6VBy/MiktRfz/Bj49faa9Dv9LwvJU/ac1q5NU5RtzUbPED6Mom
 CuTa53vGcDmDExd5Ne/IVQgruY+UWXcUTv6MotbNwwAV+nSViIoAe0o
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 526F640004
X-Stat-Signature: h5dcg8o6fzh58fymo3icdguwpcig3r6f
X-HE-Tag: 1785285312-24978
X-HE-Meta: U2FsdGVkX18+exSGueAueNe6vQkzG0vnYV1Qztejtb6SOgJDJKOaZNdeAAlG7MbnXWy/ql4wNOiVj736HNGJYV1PXajQJ3/WuwyycqjDCpMSj88BVJR64FK643e2z0G2wqGT5n5uMvg5CqXN+sfChDehEsnVptjtqqZwQRNZkLlUEhedY9R2G6DG2JjbrJdUWh6I7lWhhed045+5C3rPr7bEi+EH9N0zxtGXD37+joQ5QOMyHGyhZYgkNWlzNOF1KZf5n5OxddL3Ryt4f8hPpa/ZOpaZ3noKAFyq3hGYD/eViRrC76vmxcXo83jFruaD3n7SBT6I9Jonys9ui8HxoYpTxUCQTiZn9Woe88v59MwKTWKXErqw3VPsaQ6ITI38Kv1P+kPZEvEz+7hZPUGZ6pZrcLrB/F9gGpRmQKEZOL1xYudBEZYpnBEG990i+k/pJmHHEWY7j5o5tsL6mNKf6MLyJnwlHCL+Z4ADqUrn12yFK29LpIAewi+8thq1RRMYd7Iq2nytGyrzxhyzIYVh7Omcf4wXHpQ4t2CgizWNz1rQNB1i/tEvIDwIrkw5/bmLF6/FtXLZCGnq1J7Kv5wJt3HH/Q9TEvTgMpa/IGifKMHvmybXIH4hZe+VMDt8gwenM+conABWwzy6miSsXeedK3r3Xe2Q7gbPoxMd6Af0KWQmbXh6y7ip0KEHicuvXBCLR2cMMeNJQQeDOMCQPxmfJgJdq8U+MXsS6hcWKZxn+XLuiaQAm6G4TI5Aeu0QoC8RLVvMa7mzBBvSBedGZI70PVzZIxygUgPDJyuucvgYNOBi6UXMYrAtHAG1dgSOgoXMhUPBdOlpEmxacUwlWBrAtlRCnFL4JGX1F7iilIYNAl6wDt0k9ORllEgQDpojOG/8LGufLvjJKa8ddClrHxiukT+vjhIxQuOTj9PvoE9dG4o3IOM7edvaGRMIcdK7NZ1EMJeMpAcP6n7wJz/D1KE
 NMWEkAmc
 MBX8NF+SY/3bT95n1LBA5Ue7n3kiD12ielZqSjBUCTzTgpGoWR4v0HQlWuS0BHsNGfh1ZLv2XWAa6kBnKrLr5wV4yw7xVbiV7FnR5qPl+glM8Suo02tEgPSuAvXtXEmh2ifGx6zP3UIjlhfGOjkh1DgWS0sOyCf8gOKg3uWhDGpYxIcN4xjfj1RfCPHPFXs1yMt2N3eskYt4PW2LKCbbGZF6zqiEJ3iCKrnzrAeItuwOBugGmc32T/OZLh3+QpYjGevDYDwrAyhSCvYFGaUiWk8kBGsyTgEZudhRjG2UPKjYKyZ9vI+kODK3ssTgW8c0mKEF5rw634ixnybH/VYvPL81IUikMMA9dcqCxvpND2RJuduleIy7RwqnsPm51290Pg2dsc0eRK2aRECaII4mVsxBGgNsAYxQG91EUYzOiZBdVb8ePi33XULJHPDqfjVnARQML7vMxmmGd8eEEvqof7lRYZ3lWRhVSmz5c6HTfIG9MFPgqdZrhHkpFV8XDUTvTMXDHOtM0BMSlxE5cB/MM91onhgmSdTQfylIV
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++--
 virt/kvm/kvm_main.c      | 15 +++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 297cb06302223..438567e3fa6a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2572,16 +2572,26 @@ bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
 					    struct kvm_gfn_range *range);
 
-static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
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
 	return false;
 }
-#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+#endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6f0bcab7a0ebc..80317d2c15d07 100644
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
@@ -6539,6 +6553,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.55.0.508.g3f0d502094-goog



