Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85E1C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816C56B00A1; Wed, 26 Aug 2026 05:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE746B00A2; Wed, 26 Aug 2026 05:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704516B00A3; Wed, 26 Aug 2026 05:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47B5E6B00A1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DC2D802E1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:26 +0000 (UTC)
X-FDA: 85142869812.25.65AB79F
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id 886D420009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U9A0W0rD;
	spf=pass (imf03.hostedemail.com: domain of 3Xq-OagsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Xq-OagsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735904;
	b=PxIXSBszrJ70N/CLlbry0Vgb3D35A7hQeEBIWgwUUgknVahZFtyfKyxEV1OOGQljrgvWVz
	4rj/wwITHIO5ETjBdTD+/JIwzUPJzMIilDvpkuyc/d8y8eODaAkZsbVrBopRjIdcY4jwBH
	w1zbmE9E6F+20okD/FGN7fsBppYB91I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U9A0W0rD;
	spf=pass (imf03.hostedemail.com: domain of 3Xq-OagsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Xq-OagsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSXq5ekbbkjocQyA2ly+0l1pZ1/sTajHAbm8h8os0E4=;
	b=Zr7DtP7qaGzEVTo5BqGu+u+Kk9010pOZqjVSkESQdiVeCixg8CbZuZnRVeJ5H/bSQ85gr3
	/DDWVMUE4Ye2+gno82fKXrilQtukO9qWRxT4na4xCjKFfxd/xVOlAArSKI4es2mkGFFoUC
	P22QNYg+TYegPOi12h+aDRu3DU0FKjo=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6f73d0f89so12331305ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735903; x=1788340703; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SSXq5ekbbkjocQyA2ly+0l1pZ1/sTajHAbm8h8os0E4=;
        b=U9A0W0rDiGiXvl+sfYRtangCbl0iCOKJLWqxtpBsul8niu0zI3YEuRzykEuzIT+uqw
         8GfnwCAfkROE1jKDRDhlQNpRb51v4g8GzVjFg6JMmlVXE4/dpJ0UnEEfEbEp4hTRExUd
         N5h+4Sp6ZvnHxg+tHNfue0FT1YBpM8H6KNnK567vp/hb4c3uAM6ARStvJ+4EAP2mwOs4
         r3cDiT92tPbQDdFQfXKgsruBZHxi59TXWsIFY8dZiGW3LEx+T0zHpoRV9L1QlyPWflAw
         TcXEG0umMwo6RorBRXrBh9stM7QzMH4hgB0RJTJQWMtk2v6xouKiRi/sLLhAdJ6ftCyO
         4N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735903; x=1788340703;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SSXq5ekbbkjocQyA2ly+0l1pZ1/sTajHAbm8h8os0E4=;
        b=p9TuJQZRo+9JZfgp0tGSELF0tyfElnkPiu65EF/UBgrCfuQ1XOVJuebAtLAwAwRkwB
         htACqg3KvJMMJQs9ofFfesRi0DKOpwzjepqFwq63qEJ8UMg9JeAjFbqAlKakqQxIiCav
         g4WjJiEWfB6cwmqMiUvM9tp9Wfa1AbzFPvvVyMTskYgYAgc+ugQsxl/1ZMYKlteE/cSQ
         QJXWXCo05pKLKtw7dGaWFQxPFX09RqpPXXRR4fdirJU2CX+naXjaxNsDCCYggmVG5nEV
         2xZ5WmiGWM4H35g97y3LGadkBMnXtat6W8w8klFNp9z8bBBk23Hlhrx2NfSlfscEa+TJ
         NpkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp4B9CMG3sYSMvoz2Uh8zVeXyrmRA+P8Pg6D+gciZZLBzAZcqBU0ylQBex4K8ljF0HK+LPpbrT/cg==@kvack.org
X-Gm-Message-State: AFuF++lo5wuuKYt2d8mCDBjhPjNv9NpOg39DsxQwQpJ8aVwxgy8pse8r
	AeY0EyAPW4Tjo4SH0ogtCLqVTeLR+U3xA+UzZjjVWXHqHFkm0rUI4iWO+qDv17cRwZvWLc800o7
	SmPb1eSU5iboG6MO//mOyIDIAMA==
X-Received: from plef20.prod.google.com ([2002:a17:902:f394:b0:2cc:79e2:e717])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:950:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2d707c07e9cmr94715185ad.13.1787735902734;
 Wed, 26 Aug 2026 02:18:22 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:07 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=4464;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1e6H60cQHVz8Bv0xghWxdB5aRwHV1nZY+mB88+mm2c8=; b=QZPrMa3y1le9FkvjJp/5dcixvnPW1Cxrktr1jR2BDdUqrbGMBmSkGWfgX2OA62TxPhPTRY20/
 nmfCwWRxRRGBHS3hWtg+rcWOgYmgbTgMgedq1wXxcS572my0zLrZjAF
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-9-0a15d8a799aa@google.com>
Subject: [PATCH v11 09/46] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
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
X-Rspam-User: 
X-Stat-Signature: apcmitcroinh71tz8dwkg6caetkeqr4z
X-Rspamd-Queue-Id: 886D420009
X-Rspamd-Server: rspam06
X-HE-Tag: 1787735904-21370
X-HE-Meta: U2FsdGVkX1/Gn8Wr6JtkVhE0PiRho4oyO2oZ3/43b1snQiynrqs/UgENvCBZtBBSXOKnnFyUiQQ0EEPvhCiOO99Ujnzu/XscAdtxJcsSc9NypXLH9V4ScM5eK3WrKXi3CHt84PyC9Zo1of+BuBBWnnA2azcCSQFIUGH7hg/l4SoXd5tmLR+EPVDYzk1GH964kCZAjDkp5wbMIPvAtdVB3afE7BtzNNbXsMgY9gJgWqQVgHdrdh0kLMYPf3ZWtXG7hha/y2PTYVf4cvb6/v7wMoaWUqmndT9w7Ja+4FVpqfApH1174hYIBaNEYmXjmo63szmLyp7lVb0C0HY8Vz9GBAhpzrnrDpnKQlLcG2gxmZEBu9SwwAWvzUtFqF8ycV1UtLixHfz4jZPQou1MUp8E9labyLqNUFMSSZmfx3MOkL0KeFjDQpvOiZSv9Zl5+UyK99RTmgVBnT198HFW7K9X5us2inp3YdghDOU8pbawMMg8uzFXbHK0IhF27dJtaJOa4cem29arQgf5PcQFHmKHXRakPU8WJxu8ShaQ1XuIhoV2t0rh3TXHRi2sIDJT6OXG3D+04TMzcA2Ggx9nNLUtlI2KT2wq7+m1gtqSc665T0AxUOKUTRzbTtv+8ShrH83RsLEdHlOB/A132qoRv5+i9ONBK42z6mgpiG8MVePWfoDtg1jzuP7WjyN0Zte/bV4A2gspzA6mxRNIwtw5iOZeIpuhJKpYA1E7mIRm0pkUks4JqKYo3sDmNEVwM73fbyIFSBfaCfwijrbvHySuZ/lrKbtZHHhs3bMtPNslLeavsFX2NXJpf5zhawhOtOlk0YWNuhcs7cVbD1oXlL0rhJhGVQNxDNmApTWoOqjxVxps5/jOR/G7k/3XJdXdjb6c5oBhiKCotw25u4nxylslxPSjGkzeGWQIdrfZmVxid0k3qU+xy5BYHBzm2o1JSFnQfZjv6jtngSrAE/8/KCca5bW
 LSZMnqRq
 0qN/EY7iVICbl6BycS6903gnNMEBvmA1WUbLSNJuzBuIsA3D3xtXNCsnjSHlQB8rdxs2fYNEQJd0S9QIGRVvDSuFBO7aQSxLQIEAq46pUuP7DROjJfjuWcswYa+dbBE19xICH5rZIkAKzKD5QsGkw9mDxTvMmYIJavUK7werTxanxCglPzX9Rj5SuUzxVBQyvFUGnx8+kk/d/aq5mplz7wmfkrtHufIMqMn1oERa2wV6jyQiHW9uSWehnf12r7SAPIurkjTp93F4nPb+EhTQdLUqNvAhAnWp1xi7Iu1R4eBeb9fwfELIuhcuW4ZKmvT40aKR47yHWopxlIkHcmvno8JRpI5ahbMDCAdzYh/o6QAqGY3pVW4o+Y1Qe+quWql4Zwvebzg63lMGppvcH8GXuFjwyGbIM6Z6sv56V5p8GUeZuCh7JtwTD5EdxW5ihNylFbSV870wapl5wiYdkGAvKbq1auC4Xz5jfDkjvAvcEQC7GwuciTYg49h3iDGoshTQN+S+Oo1qFCfSptiCG511Uf3jpT7L0QGyrTYgvYy/1MKLEf2wEeBCRo58o92b2Mp+Gs9toXscASB6WcGaC7fmPB9AdoQI4i6RetPiKc7aeMTKqujyelYYB011k9vf+DZ5QeUrozdHBWRwAQ05XZ3IOE5EKRSUUt72hvWOrdUNTzyZr49yTt3fXwlV4jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Stub in global variable to enable in-place guest_memfd private<=>shared
memory conversion, which will eventually be exposed to userspace via a
module param, and wire up the __kvm_is_private_gfn() static call to the
guest_memfd version when in-place conversion is enabled, i.e. when gmem is
the sole authority on private vs. shared memory.

Cc: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   | 26 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 12 +++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3579feb631775..b0110143d2ff8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2580,6 +2580,8 @@ static inline bool kvm_vm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_is_private_gfn_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_is_private_gfn, kvm_is_private_gfn_t);
 
@@ -2588,6 +2590,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_is_private_gfn)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2595,6 +2599,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b9fee68c90311..5399ae4aae0e7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -478,6 +478,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a stable result.
+	 * This result can become stale as soon as the lock is dropped, so the
+	 * caller _must_ protect consumption of private vs. shared either by
+	 * holding guest_memfd's invalidate lock for the entire duration, or by
+	 * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against concurrent attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private_gfn);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 78278730b2ae4..46d2e123448c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2423,6 +2427,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_is_private_gfn);
 
 static void kvm_init_memory_attributes(void)
 {
+	if (gmem_in_place_conversion)
+		static_call_update(__kvm_is_private_gfn, kvm_gmem_is_private_gfn);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-	static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
+	else
+		static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
 #endif
 }
 #else

-- 
2.55.0.887.g758fc8c411-goog


