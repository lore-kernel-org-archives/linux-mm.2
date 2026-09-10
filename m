Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F07C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE716B00B6; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159016B00B9; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C4A6B00B7; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49876B00B7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF2CB805EE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:43 +0000 (UTC)
X-FDA: 85199512566.06.FF124F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CA85518000F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzT27q2p;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084542;
	b=gYind9sc2VfCBCyu1Idv1bmgQ8jaZMzILq4wPYYcWmCT6rDD5zeQGM5hPuy4YB1PaSIuVq
	KkPpH+2jGHST56FmOcET8e3KKGgVNGpMmCe97t/8zjGnkxqf1aliyTe3GUfWQm6KhhrI2E
	wFaxPd6fBiDIiwVdbDJz8Q5gVePYGfI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzT27q2p;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQYQKvmIpBVDWWBEnSZJHrZUw05wLex9WKs5g2H5l00=;
	b=q6eQqmArZBCZuQ6IapGRhF3BW5WGV2ma7FTcOjuczMajCeUUWPFR0JlQFs4Xlz4MRkQtXm
	J1Hy+lZ3W2zdYo5/Y1p9JvqBNqff4wTpoKXrpaugvjJcKX3/I32nOfFh4FYygnTJkIMdkQ
	JnWWqRdcdyFlSdcbl0YfYLxsJIyOS9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2BF94481F;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BA7AC4AF1C;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=NgzltjearIdYAbaLhDfIdgKbYgAEHzjHukniWRiPY0Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NzT27q2panlQym8GWrU3ebl0Gj4Emp0UZGXwh97FIS2jwvLBHPFIw07QjeUY2DenJ
	 5yBXg5yyxsPQdOGs4FgP2XBAagzdnpQ+L6esFw1Qjio4JJLjMPoKgCJTRgh9HEEZ3V
	 /raMnkVOgPQM1YerraknQqLyiVDG+US5Zkdk+90p1pUOjGmumtsuRDHbBJYdiVFZao
	 wdYOBHND0i6WQuIDoq7+Kp8U2HCsRQKCWgb1guQ0DqPSoiUwQ6E2bq5WsaZaFdzdXF
	 1cB+2VRsC68qSpKm7+sCdoS08JpVWQBXt+Z+v54XoP3W61WCpD9ERUd9h1NMaZS2c7
	 M8ZpaS8uGS1eQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDC3C88E41;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:35 -0700
Subject: [PATCH v13 09/44] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-9-dd6fbf94f4e1@google.com>
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
 Fuad Tabba <fuad.tabba@linux.dev>, Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=6433;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1gG5ZbGkC7+8aa3BRkAOtEFb3BMFWAIwkdSXfAOjliA=;
 b=rkveUKzWAElVqvkW8O2AomhKayphQNqwoX/UCYgVOjECWqSUNWGVn0o/li/5D5EmXqxINuTkG
 X0Ir9UE7D7LC6JBXc0UcIqzcvZC2YVe10StOMne1c2mWpnIrfrqeFGU
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA85518000F
X-Stat-Signature: m6en4yzbfyk46khprieu6dq1c7mzfdm3
X-HE-Tag: 1789084541-104348
X-HE-Meta: U2FsdGVkX1/bCwC67WwNiSeSVIRp1+tfqQNnlUsAVljm1UmMY8KjWSfoI7EAPtacK+DLVjJACHq0JHHiAEhSUHBINEXez/NUVVtkGgX2HSrl8hXbYTf5V0j6PicEKSmSRh3+35IcxQpqETw6aHjwRzXRed4RdozBxgp1n2H2+bD5ok9okN6CMXvN6aajhgvVbdzq43mEpS0rlj+cFjUNdO9tydIuRExuy2sn2hmLazZ9G5kQgDuZUlKLFd6MsEwU+KVbS9XNuOIRfJvx6rRy2im4dIaxL7D66VrQF1t1RjeVtMIXdkdi5FAIl+T1398z4U1hVBR6BnWJfZL+dIuouVEXLtyK3xNfn3ShRvOcACCgimNMKEUjD99QlzM8H3aYCYzCcN1hZknJbXykrpgRfgc7B7RcdGSpqYOQW1IDyn407zUWD98F7nct3TeXGjJj3rm8noZxnJ81TUB/6/r9UOgL8rQVffb/z0DsV/HGoxV8KvOePkBtV4N2LyOFR6Zeubm3LqLVJtpQte89Xd2uksFZCU0uLY7QeAN27U8SfW1x1QBx1/wOZAUS7RbgiaZCkpHGJUEsfh9Ylgm13w8giRE3mYx4QiHDh0qRxrjns2eI8NkiUt/1BBOrhkeynQ3iyXEBk62xC3NPetSYtrQZy7hiuba6KJaGXdXVMDsFvy6DT+vvcry7Mdtx+Dw19RylTYXvAVXZiImesx35xDQSEsyJml0MpN8Qks45E0EdbVRkEgp2Oo0tFcVfptjm7ExLGs/UI1sqcQdWDqvG/kwPj+z3emn3Jq8KynuQVj/AT9++xxmQwtULSxSUhb7bE2DeP+sR5BOCXxJSl/TjEGx2fYcxNs4upNoar6inhn0XQuDZa01aLiY/o1FyqcDt+Ita2+b9zCPV0/GTV097tg+XVNC2io9GfVlZNr95TIyKvYb9OWIbXZoWZCjGB18dkWZCdtwG8HOTJORoUrIW0xM
 vA5j2eCq
 ujLNn4tZ1VlKLcuQFWl0sWiQ58NFFjmWTONl/4qPWkRUM9VRa+gJZSoGSHuKqqRUfhZYeZM277POeXvNo41f0hRi7Vll8jIfS1LRDqwZzX/Rb7iMhDq9fzJI8S/idjY5DRYohztDSSlGro+f6akCiJCNCLU6G6suFPSi4pWYegR+JQn4fUrgHKNfgjwyZS5gA2ArD/DHq7cmYfns3EmPAvu8rLmMh0fl5Q1mc/aKhSfb4qWHvb9iVALIKF8WlrxedUrluCLdvGT1PnJMm7A5Yj2wHhANo0UUitXuxemUhL+TlqSEoE1yJ/VtuY9lpiS/r8ncyS8ETUKIhrdMJjAj+GyAvp668Yd7FRaN9TouLXICvEKZvlf/B65e44eUbFY3YH/msZtVu+sjmIYjNRyzP86XneuMBW1Gug3IYD3kJCNiZzjIkVt5xAjgZjFQafFiSjn1JtBfxklTjFNsj1sCS1OoilyCRmRmoaszvhDnTt9jEEqFOqmsCzrplxP4OMyJjmfnDzAH0+UBtyqI=
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

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/api.rst | 17 ++++++++++++-----
 include/linux/kvm_host.h       |  6 ++++++
 virt/kvm/guest_memfd.c         | 26 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            | 12 +++++++++++-
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9e..09967e0308031 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6381,11 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
 KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
 on-demand.
 
-When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
-userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
-state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
-is '0' for all gfns.  Userspace can control whether memory is shared/private by
-toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
+When mapping a gfn into the guest, KVM selects shared vs. private, i.e. consumes
+userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
+sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
+to find out more about the creation-time shared/private status.
+
+If in-place conversion is disabled, KVM selects shared vs. private based on the
+gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE state.  At VM creation time, all memory is
+shared, i.e. the PRIVATE attribute is '0' for all gfns.  Userspace can control
+whether memory is shared/private by toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via
+KVM_SET_MEMORY_ATTRIBUTES as needed.
 
 S390:
 ^^^^^
@@ -6429,6 +6434,8 @@ the state of a gfn/page as needed.
 
 The "flags" field is reserved for future extensions and must be '0'.
 
+.. _KVM_CREATE_GUEST_MEMFD:
+
 4.142 KVM_CREATE_GUEST_MEMFD
 ----------------------------
 
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
index ce5efcacda36e..cd966eef45b69 100644
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
2.55.0.1007.g17ff1f9808-goog



