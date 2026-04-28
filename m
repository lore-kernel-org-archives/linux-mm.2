Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6A6FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989296B00E7; Tue, 28 Apr 2026 19:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F336B00E9; Tue, 28 Apr 2026 19:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8752F6B00EA; Tue, 28 Apr 2026 19:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0E26B00E7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:31:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 378C0A096B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:34 +0000 (UTC)
X-FDA: 84709548588.12.C51CACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0298C140003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPo1ak4h;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9GMur7wQnhoCXz5MiLw5xLGOsG/Tcll/AKb60TdC3s=;
	b=Xb7S5CJRhcdfphdBSjGOVe8vDfUlBHh5Lw1OSKLq32ZyP5Bux0BdIXDh4RucoP8YU5AcY9
	PguXXDtUKEfAZobbz24Fd7dABmm4WKI8j7X1NBbEPLggd8+WXYOi9dz2aM/dPI42qIwCCa
	s0d+HjF7L960Gock9oUBkevAusnbN0w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPo1ak4h;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418732; a=rsa-sha256;
	cv=none;
	b=Gvk+6O83I8kDsim9zIvf8NTphxI0cSAdvHKgjf/3YhPnaKeEs2TXGUfZXX5ka+xMdxHS6W
	OqJNQD3LwUH8PLXgUj5GvqbREe9DTmC0yGAOiTRbWIoaq86z5VNQJ52o4fb4rpyAKNRWDR
	MZnOLeBJZuMlO7Mlo+AB2hWI3u7sRlA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C131B44A6D;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96C13C2BCAF;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=8ldZ9tHAeXetrK8aWEmsZfkrv8T0wMkcO8Q1/+uxlWI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KPo1ak4h7ief2ISZWZW/EZ/7mUK0FEIdHn2SODaZCs0Xf9ufV8ZFGVD+Zvn1XPy16
	 hOPfyNzOV+QHcobBqaiFHqyiR564LH6VCqekgHYYkg/Y8lwpVVCgKYBlgKuuctko5o
	 enSa0z2IGSPOyRO49DfClhcVZS8kELk+tSkcoG5HsX+wHT9yMv64B6Isrxj/DOkR3d
	 64p1juXX/MayYcil/tbYNM8OzvEoLcNYa/EoZUr012aUdWyzvQNAQbsxNL+wdycRsN
	 MF6X1JVo+QubUlUkjEa6BJGfJx/+cOZhRxthZAaXtQuEm235OEBXyBl1KbexW7FOGh
	 8X7sSXG5wpFKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EE9FF8877;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:23 -0700
Subject: [PATCH RFC v5 28/53] KVM: Add CAP to enumerate supported
 SET_MEMORY_ATTRIBUTES2 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-28-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5528;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pIqYKdyBIT9N1Rsog/1YD0EZWPUQYi37ZuQ2ZuzAyaY=;
 b=LQBZ48AGkz7+oQLurDh/BMdAf+VaqtbjZWVqTJOoJUGv/ubksh354Cn4r3Ib2Hs6R4f/Dz53w
 n3OEKv307fhDKS75Bmp15XQZ4T1xi6Ti7nszk4NxAk+S39eJn3ZXztw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0298C140003
X-Stat-Signature: qb69zspsxa6qow493yw9f6ooqsozh1wa
X-HE-Tag: 1777418731-429622
X-HE-Meta: U2FsdGVkX19oT6DaJEizCADZ/Of07NXJOQnSymdk22IzOMz7SzN/vU2mzVAvVJq5iSxb57lKIgMbZxm/4mS9t7WbHNtrwmImBtHeqPQIvRFp3JKpvIBfS9MaSKV6ULbv0sCIwGh06RE3NQ8bs85V2IESlMAEkAapQxtUZZ1bZtsO81mtGtVVqd4sldRqzvsDfc8x8qPTFq1PKHU5kWjLDLXpJd2n+Rb/OGqzO0QzsVoSjYkHI7/rfNl+ghg0Z2EkaY/dufCAt4EigEfQQ6sbJ5PEOCTPJoFqoPZvkkD4+zhPiSdVwsl2UuTK80KdPSrQJ6oa8uydmcuKumCFVaBi0oQbyGE3AUeqaMJ2j2lJq7tmAdTer6PD4sIWq4hddxoBmwYW9bkfsOv8LLFHqwt0enMRSbgSqqu2HWnNnXo2hy/d6sD1Ar2rpERMMVfiEyBw048uSkHn/yYa0+Mg/a35CdXUBCrjuvz6pfg8mBOb/2yR3kMACPRxF6TMrHDHniu/wB50RnR7EpbqarN0A+P+CURg6JcyY3HU3GptOl1by2u9adF5DH6ByGn1YTjXOoBoSrK0o+L7b/QVzUhaZXao08lvE+ok8pB/NaAO4rrjgpfMPqm3u4sF6dsChk+8Wo0194WDBTV4MNAYtDoHGLWdrsfbig8tP0ViwthFQ4tZxVXLvPkdmR9v75KSnFmKDkaUQSROpSJuhbyYrRjj/Vn+CEDZ/40WVNBtUpIguZKbk6mTeDQ5x3emfLDZNJ9zlGsjM0glBAhnr9bl/cbIKjCMdv0wZpL5ONUc2pnQqvpgEen5S/VXuPRDUYdaZr2xg/30h3UFeFCALJfz9QrW/YQi7SKVbvSV6MNqMeE5HDXXOArC88Sa8UyTs1UXZW0w7/YFVDuMu5b15VrsRrNuykA5iIWlo6S5a+IAAuQJ450GOha6lnUTXXAk/xsniy6QqsxbnQrTpkOLiqrpx4vBXSZ
 1nuvkDFA
 /fhtBP9mXg/AARtSQz11mmsAgFMSeqR1R6ZpXYbs0PUldGjAVvix9SWSJ2yIyLbhitUYNs2FxiPMY6RN14s9lt26ciNSUcUwy/Qf45/NZ1FDDwtkQtDeWI0Gxnl57sMa+ds7/QCEU1sgqvP/kRP0kEMBgoB1D8GY/ZrJHJN8Wc1YX7cR2iKIZSLI1hGVpF41zDvJoRago2d5VffHEAAJQ+Cd5YWIujK7u5yOCXCM00tGFZvgcCB76j5scplx2cQdaxEVZ3zUpkeLpE0vrBG/rH+sGPwZTXO+kr8M4O3V2mkQYEcEoK4aNfL63ZVMKFucLP3IvqtG+mec5WzEcNuiXD7/MtLSX6eY+bDyWjBfS1CKydBzeR4tkyjIXYE/wxRU4kgb6D9iFrXcoLqa9aaQrasaS8rPRiHc9EHPcvw277gAPIMYPLgUZbucfenLLlcy08Y3OMGOPxkf7i4mmF5p2YR2Qww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add CAP to enumerate supported SET_MEMORY_ATTRIBUTES2 flags, so userspace
can find out which flags are supported when sending the
KVM_SET_MEMORY_ATTRIBUTES2 ioctl to a guest_memfd.

Add a parameter for_cap to support enumeration of supported flags
irrespective of attribute being set.

These flags are only supported by guest_memfd, hence, if
vm_memory_attributes is enabled, return 0 - no flags are supported when
KVM_SET_MEMORY_ATTRIBUTES2 is sent to a VM fd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst |  3 +++
 arch/x86/kvm/x86.c             |  5 +++--
 include/linux/kvm_host.h       | 11 ++++++++++-
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/guest_memfd.c         |  6 ++++--
 virt/kvm/kvm_main.c            |  5 +++++
 6 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aaa4a82f0b75d..38938243c2dfd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6685,6 +6685,9 @@ guarantees are made on offset ranges that do not have memory allocated
 and range [0x0000, 0x3000) was set to shared, the content mode would
 apply to only to offset ranges [0x0000, 0x1000) and [0x2000, 0x3000).
 
+The supported content modes can be queried using
+``KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS``.
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 296ed3b8ace6c..92709735613d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14195,7 +14195,8 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 }
 #endif
 
-u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private)
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private,
+					  bool for_cap)
 {
 	if (!kvm) {
 		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
@@ -14227,7 +14228,7 @@ u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private)
 		 * shared, memory contents for pages that had already
 		 * been faulted could be zeroed.
 		 */
-		if (to_private && !kvm->arch.pre_fault_allowed)
+		if (for_cap || (to_private && !kvm->arch.pre_fault_allowed))
 			supported |= KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE;
 
 		return supported;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 458bad0083c37..13d126dde32f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -742,7 +742,8 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 	return flags;
 }
 
-u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private);
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private,
+					  bool for_cap);
 int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
 				     pgoff_t end);
 int kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm, struct inode *inode,
@@ -2551,6 +2552,14 @@ static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
 	return 0;
 }
 
+static inline u64 kvm_supported_set_mem_attributes2_flags(struct kvm *kvm)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return 0;
+
+	return kvm_arch_gmem_supported_content_modes(kvm, false, true);
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c7cc6c22c2023..c0d465a5577da 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -997,6 +997,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
+#define KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5c1db67e6fd35..071bf636ba5c0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -693,7 +693,8 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
 static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
 #endif
 
-u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private)
+u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm,
+						 bool to_private, bool for_cap)
 {
 	/* Architectures must override with supported modes. */
 	return 0;
@@ -709,7 +710,8 @@ static bool kvm_gmem_content_mode_is_supported(struct kvm *kvm,
 	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_ZERO && to_private)
 		return false;
 
-	return kvm_arch_gmem_supported_content_modes(kvm, to_private) & content_mode;
+	return kvm_arch_gmem_supported_content_modes(kvm, to_private, false) &
+	       content_mode;
 }
 
 int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3bf212fd99193..9fa6ecebab939 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4979,6 +4979,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 			return 0;
 
 		return kvm_supported_mem_attributes(kvm);
+	case KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS:
+		if (vm_memory_attributes)
+			return 0;
+
+		return kvm_supported_set_mem_attributes2_flags(kvm);
 #endif
 	default:
 		break;

-- 
2.54.0.545.g6539524ca2-goog



