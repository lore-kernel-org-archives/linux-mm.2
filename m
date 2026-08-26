Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115E8C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB036B00A0; Wed, 26 Aug 2026 05:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C40B6B00A1; Wed, 26 Aug 2026 05:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3CB6B00A2; Wed, 26 Aug 2026 05:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD7396B00A0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 875771402E9
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:24 +0000 (UTC)
X-FDA: 85142869728.03.E9268A0
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id A3FCF40003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nBgAHQv+;
	spf=pass (imf01.hostedemail.com: domain of 3Xa-OagsKCFIuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Xa-OagsKCFIuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2wiHnbE+Ij1tQvsnQSqnQTpOXXjEOrAZMWxy0XisNw=;
	b=SHLV9TunlQqIkagaTazTEi/DhWSZfA+9z8ZX08I4hk/pXfqHFj/i3bsBEtbg51LrWiXM+r
	7w787w1klLngBJPED26CqG31UqQercS37rmNKgTpfCDPZINVcJ3G/egipA7+s/nbA0qj3Z
	44lXjrNHRLhwS9HKRdiCt+zvPp5ve1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735902;
	b=qI5zX6neuHu4fHamIsdzWGsJ4QZTwCAQrf7LKWmymCRswPGD/TzEVQPa4UpAb96LT1C+ny
	2oQrWhPvRspNVvkZhtAN3EgdNrSwAVxlx0WtHV1jeDNkX+1pJBUTOJrMsxoysGOX05Hojk
	4awSKa7YhRbg5MZCpWtKYxd+MXFRxvs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nBgAHQv+;
	spf=pass (imf01.hostedemail.com: domain of 3Xa-OagsKCFIuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Xa-OagsKCFIuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cacd6d37edso11904915ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735901; x=1788340701; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g2wiHnbE+Ij1tQvsnQSqnQTpOXXjEOrAZMWxy0XisNw=;
        b=nBgAHQv+yv7yHs7kJL9FoozVOKpl3B+h3nG1N1Kpsxn9q7USsyHEu29z5oz+YkgpFu
         4sCjOrwlWjnifi79D9ew8ZiaEdWkemEBjO5kZnWkgv//dRYlIxXQMkwRiMlN24XC3IFN
         sywa+Fk1DwHi5cbObA/67EMcudKNSFYTclbYxpcEvi/Uy2NYtZOyIOYcLio1ybBCHVgx
         xzTdlqPN3PXTujlJ7l5olVhOFb3IEaaSTX2OZxewFGSfid4GfjanYtZqg4i2Dvcv411O
         OYRtcABcGd2VN4bISLXyA0qAfzRX2RQos+kKxUrjtBikjcP1Uh2pKFrWls7Xw9Q3UrNr
         siEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735901; x=1788340701;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g2wiHnbE+Ij1tQvsnQSqnQTpOXXjEOrAZMWxy0XisNw=;
        b=D0rz6VpqeOFfbnlF1pOtaIen7vRqTdrN/yW0pPOfV9/3UixHtpPXB9fdgONmQNPE2g
         OJSEIQhrTGYJ8cq8fVaBDpTCiY3k3QwS4klbqI8d/4rUFm0EyiV5c57tNkoU4tLwa4AS
         0xp3kHG3cPGVd1x3TOqkJx1Nl4PhIYV0u8/Krus6BTJfTXHLlJ4K0hKUNe3Y0TkV/2x8
         NEr1/UwLOfo0eaTsgkLz9XHK7Yqajj5LcLziHoj5EwYiaoUMV7DNsoWVDZs5oXQEtVEx
         3CEhGU8Z4GHAuYZUgOuQ/DhXcD1Ze7cavy7fAnVFO8cE0oVb8CbSvODWGJ1Dbpi8qhlm
         xmXA==
X-Forwarded-Encrypted: i=1; AHgh+Rot/7+p+uRiQcXNVWsDbd+35dgYIlmXAnvpy9FUHYinp2V+cjxnR6i3MM3QWT9YAwJdi4KqLFWcCg==@kvack.org
X-Gm-Message-State: AFuF++lc79PecBD5+4JsCiaZQANeRxfAQJ2zo4A/IQIe3MAvHiIZsbfZ
	pDg5BYfpqvlbbru4V/OdhoJR+KFX0eqXACHwsar2H9+4wj9tyMosVhbw8RzTP8gFum7ma6fB4U7
	BAfPvf7Hi4LOKjLyeHud9lcch3w==
X-Received: from plbmz11.prod.google.com ([2002:a17:903:350b:b0:2ca:cbc9:76fd])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:38c8:b0:2d5:ccb7:12c3 with SMTP id d9443c01a7336-2d7079579a8mr85171415ad.2.1787735901060;
 Wed, 26 Aug 2026 02:18:21 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:06 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3261;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MYp0jcv/vyqcAp2jfObXcS1n8zbY2OhrXS0jgL07qmI=; b=OjjqRhEDO3WNi+cijL7f8lpbM+OYCuVBl/W4q/2CiXbz6fOaq/lU1MP9wqHNLxp82huANiFAg
 XO5HfFH8jJwBqR2M0mKoQUKWsQqP9fUpPRG2nMdyg4DpIjwzDgaVUTk
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-8-0a15d8a799aa@google.com>
Subject: [PATCH v11 08/46] KVM: Provide generic interface for checking memory
 private/shared status
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: orgmtohb7g83s9gupe5w9g418a6udj41
X-Rspamd-Queue-Id: A3FCF40003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787735902-948101
X-HE-Meta: U2FsdGVkX18hA1RapEmSW6yYB/sJWh812cCJL24GcpB68pFj94D8Uu6qotXKst/vQpmhVq60dSYWlg2aO6ZEAC3+rO+xghOGzSKktCFB8UWSrKJyTXLKtjfRvW0Eop8drDRh8UM3BHOnF/t04ntli/qvri4fYvpXzHdMKFPoCCN2LlmmI/9AqTdK3By1H7Vb13vhXZKcgWQ3H+CowTZP9517GGVpiqFtwDxjujKjAWIOQ70Yg8hjmsWhArAEmEWqtaR7+DC0+2zvvznb7+Wv0SiblAHu7pfG56/PcrI5yeR/H5pH6U8EYDbN/xNtQoEROp2j6yX8YQpvScErhmF9VY/rVczPQTxOSKUshpYwZ/8Qfci4UFKNd+ITb4cZH/XfmrImqr5/rRP4Oney4dusdF0t35CmoQLc2FTE25YtwZTTWi0YxflTfE3zLYFKmgzkeiqFc1Oony2SlkY/pg/JQU6IZkyKnNR237V6TWRWGmzRKERTbL7SxIXovLghSDuwqq68YHMaZA1VxMPKJDTCg7gsN6RBR9WlXVwImXe8dWizknlyTVA5TLsV6Z5Bz+1lPrVzYIiaW32vitVJxqhzRCQVSsjX5ti+n/rBoXlfErg0kOsevkll2hChGLJrN7LVMasZfLJ0QbGOW6JnWjzSRuG5ImK/Txybg3FvbjSu075N9MUvmhpgIKhdg5d2uTeAaG5FIyKYyRdWIopz2kt9GycCS2+8IKbTm2XzHZKb67sBbUqVWsr9z+f7zyuoPzcPZ3IjWAmFQHm8nGHuKcD2VX+1sEtpsFo+fGQZI44nvHUwtz/S8g5Q8UJglVnABPl8EYH1J1wRi+fLK5q89E4rlNetWfSU353bd3KvvY3mOUOp92tJ2JBEZBXbnmshf7IzkUw+a67Z9Qk48gr9wcV9KEL3Le4uJntYuKuinVvhCuktFu88AurXktaW4p8UPeNAzfG10TrR8cxTeAyo7hj
 gQGMNktG
 TAIruYV+NHs85bxbJgiGERPTdid6sox/dTqua9+1FRJO3q2oJVseBM3jUwn3kdy5kMi8VJiqdOwgLVxXdfFs0kg4QitWgoUWoKin7W7y5cu4jDs/7BWt2d8hFLjHxbD3paRmp2eABSpEkWMCBoMp/lWZspfL1b5u5ncPutzLmBOzJWlJyGbOMpKdE9652NPphKsKhIdbZfmeY7E0qccJNMv4Qtv+xwOSPfOtIXNOqKcSh41BTMe0r6NGJRRSDKx9ChqiVmilqXlDk+eaBOvTZUpLtqSNDgfRsSVWwFxHOeid+RRHfmOxOybyH+LHxfEvzr26tIn6XJg5Z/r2lH9XFLNRGYJxS20BT99riYM2bOXN1uWPwSqMl7NJPe05o8OMhguRiNRoGHUBvlboYUbKq7A58QVgfwepNTNNfwoxpaMdWtYtfhy4dugcv/SDPCUI8u69oa3a8sLvzLa49PHwaPBSgiPxaLjA2DhJJGvD87RWPA9yG7AA34541Ieg0useizFnZHeLOLZsBHPMU7rF3rdJNgKb2gTzPXuA92GuFmGU9kN7E4zKnHkjFViEEXBtz1JWEgpGinuIO2OG2oXYRhOVkmXuyIH01EQ0/9l46XGbce1Scmxlty6xlVFnVUG1A/dnnnZ+ky7vL156NUuI6CM8OlZjj7h7XUIfT
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
2.55.0.887.g758fc8c411-goog


