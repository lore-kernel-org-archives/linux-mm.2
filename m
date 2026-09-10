Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119CAC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133736B00B2; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B026B00B1; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6B56B00B4; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBC86B00B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E286940215
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
X-FDA: 85199512440.21.A4C4CF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 07BAA40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbuont0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbuont0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084539;
	b=ZnCLr5OPjLQhR7uUMXKVrxQF0v4KbHZRNeutdDJjYlFz+eR2P63P0TMAswbNFXeMYnwouo
	4ftLgeq1d9IomNnLeJyMkfRTYu/rWRZ5mSMI5KZ52UNWm3ZvI88lcIsvqxKvMwt/swRAmt
	VtF/btNq54ZEQCg63Nk9uXcyZYnU2Ec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084539;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lLePvpQNYXIu73rbmTB6gWWQWeEBhhFedJyY25PnvM=;
	b=EJO6W81GAuOwicoeYWWn9mrmBspn6at7oYXVqbqauVdm8zBQbaHa3gtq+Blpu8rUnL4GyV
	YMOTS7apVPsRUr0UHT37x1VK0kkLqEeusmuI+x38Nt2PqEhabJjIRdeQ+BMy3vvzHonwqt
	NMF8B0FAm/yoHTEhfAIRFNMEr0XI5vU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E749160514;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 580A8C2BCFB;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=hjyEUAJ+jhWaxhmjTF0iGEgrP8zFWvXv64ZHYkopano=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fbuont0qgl04sUkQJBPwHnL0vyuy3b1lV8kDhg340wcMOCmnBbQAORRrmS9gdHpoG
	 2++AiPBGRGRnMnf/vQOAe9d8OcQ/HDXbCTsIVAM8aOBXxSVQxkF3MwwDNE5u6lT1in
	 UVqmDkimOwbmP2h6enZRaJYFkhzkml0f5Ycz47AJbY5mAGok1c9NkKXVLGHLKrB7gX
	 kwHqpXiwCazvyHQHSzOu3fEyWzlBEsrP20kQgje6gvGH3y7ILHKDLHUB6bDFex3SRe
	 jubg+R6pKA3A6ni1q1sQl7af7wMSGMhVHaUviKVIDdqCij4AfM/KS2JNaTtD4hAdPE
	 4dGxbulYDwvnA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB90C88E47;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:34 -0700
Subject: [PATCH v13 08/44] KVM: Provide generic interface for checking
 memory private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-8-dd6fbf94f4e1@google.com>
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
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3262;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6GGPpLviZBl4jqQUaYcKJ+tOY9xiIEbPpyZFIZSx8zA=;
 b=lZ+Qe53KpaqQSKaY4al3zERjE8Tg1dHaqtQ7vOFXCwY8FhKk0J8dhwB7IpQQgXXA8WWVxe1HK
 xjStRnFzvVYDwLiU/L4oLpF/soB1bfAFrjUuNx3na5OSijhIAuiraCY
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 07BAA40007
X-Stat-Signature: 1wn6u15x717671xu66h3gmb84rf7czsp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789084538-532914
X-HE-Meta: U2FsdGVkX19tCBj7tSnZc2VLHTg2ni96PS/A5zavxOH/4l73CiUbfUuUqC9Kt41OA79NNKYNAEQboDoSO3Yhn1utIfzXG4aLZzfF6A9zCc2XKiPprYaS9GMxq7UctzRBcWfRid9Dv3Ug+FPZ7eWO30ZG8MQxwdqeh7R4PAu+8sbBfj5unCMPhz/eaeWr6KBEt6M1/EmYmsZ6FY58SHbwZ64oN7USVLMaslcKIJ58wgTXj4XzIAyOzuPFaD5Rm7pnYcIJ7NiWSw7mLvUsvCfRIuimdI3mK3sVwBWbYR6oxucC8hXpqGwKDO9tSjFDQivzeq6xGecuXKAEvoVseIXa5psufVaH4J67XiMP3fDG08wBos0Jc9bxvbIA/geHy9J0GXbhWqLpb/QsGqujqwnZt2FjfQ092EGnAii6P27EVQGFvUrRhzvgNRUehsfXBB4HjWAFTB+p9VEpIzF58zItWmUbcEIe0t8GByvnB7vS332V7MdS5f9Zg7snmW61I1+GGkbq6zRxGeQKUjf1gCiCxw5Ha4Dtt1sJDWnOOi9PdcEMdzxfLhrs8f+0RXwIMIqHt2EKHzfzeP1njcca86wN9B3++1Rc8XJ8fm7YLKMpY6rMwOXJqUgaXK/jJqEJg6yVIQSCFmOkCdw/ht/apZ+8eKEu34k+1Yv3/R2/h6VU2ZOdeAJP9vYK6ETZIcZxRh94YTsM4aqB4Tvkg6Vhbk4LoXnXdAEJsg1tROlC4bzJJsCTyNVxM1d1TauH4545LoG+Av2y3XwWV4xGuYK04OCyN4AleR9Q2rCgyBoTgXOOAn7Xux1Bw1ZQV+yVhhwBluTEQi/JG1pGBmv55JKRV/BDlfjie4+QZrh8vGPYxthlx+XhAEhhKvCTlKjouZWwYi+NkGynM39WKkBHSeTL0PelICxM9XiF5SxUj5JGHqUKrD/ZVIpjnWIPfNf+ueTc13QPf5yAXxMnbxptD/DibZr
 ZQNpXMFr
 6+l4O6VEL8YZLbWX3PvCm0H//PVuaA1wnBcagw6ebjxNI3VCrnsALz1Njp3GMhZAo4PVLVsSgHgXw+BWqfa8FiGeAyOVjakjZztUBvNT+VWAgf6LnpXrLBpTC7IVt6H/XCpsDyjPTcy1D2Zxe9VqcEV5BOjCpjmFTjExsyTnSDOtt7avdum2IX0/KVjgEvqS9gUyXiQ7qqgdpV8PWPc/KCIX0Th09HJX3y4fI7fV7Q0cU7ShnqyEWcrm9CB5aVC9gVElPgoA1cn6scHFcfQEwzjlFIw/uEA9KkfCjgGvO8paj9xhpn7qTnC63Mreu3IWfg0A/mLDgfum++j8LTIJG9hQEc8LaizylOwfDDUaRGVCDrBytjp7itJja0xpAEkYasqyf81JK51vJ28QwEub8HPYz62315rDX315hEHafNEIfygZfSThccBkyB9cENXGWAGTYOPUf0sBXn1F2WlzvruCYssDxWevq9gfnQN0FZURv4/sDOZVnsAKGPQ==
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
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
2.55.0.1007.g17ff1f9808-goog



