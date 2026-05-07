Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A56CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1E46B00A9; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79B16B00AA; Thu,  7 May 2026 16:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68AA6B00AB; Thu,  7 May 2026 16:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B723A6B00A9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FB6E1C04B4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:00 +0000 (UTC)
X-FDA: 84741747720.27.27DCEB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F5CE20006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMZx338H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185378;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYfJardcMIFiX4N/J8JKGNblhP5CWs6fz34F3QMYEOg=;
	b=6GtRcILx40rtBBym0vHhiuHR543cqx4kg8G4YuV9Qn1wyjyqA2P7G49AFnz9oUBjhrxKvi
	9meSKdxJ4VHh/ZgjWDR3NSyolJet+BOf2MHF8wLIEbeEHTWkN5L9L/D7rInR/t6evDNNjV
	yvFYj3rRLa/udIcW0iZd34T0vPMmfF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185378; a=rsa-sha256;
	cv=none;
	b=wb8jCFLrtAn8GxX+fM3HUxo4kQeI+pifuEDkD0V52/g05nESbyi1F0gkpN5SrghwrofkL1
	4mfSA40mzHWIqpb7h9yKBp2SXanqTYoHfYAYiwPlymaBga866QJYcmKK48Rtv70cI6D1mm
	1FwYp2P3pTA0r+MncDmp7gzq/CFU9Os=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMZx338H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 527F14479C;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 287F7C2BCF6;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=sTft/dnvEfrCKOimjJG86NE93ygCbzwlKnyy/Nf48eY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OMZx338HSG2/a1Eghr+jiT2WMR4ZE88/u/yRIvbJSdaHsk32fhRD7V8Dprh+HBg+E
	 qXSOGHrvmSrqo8rOPP45roJTocuZEddPkwaNF1Vw05kznEwssLAxK6OAGMnLgOKd9U
	 4/hSPsN4c/cf9MbAp4dTO31l8DRpkt+bFnvuewPbSa+awtQdOKB+GpVgvQQSikTMIM
	 Lw/98YolVa/SUaEPkgl7EG206ej7tdcu6yW1HlhCK+tpqFbyFrCPxaQqk16miRgTNG
	 pYTYy8QaDuBUtHVIIkAft1Q4Y08pRmm6hfBsjnk45iQXRPVwZJz/AF1jF/+h3jHQWt
	 uTr3iwYjuEYzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D60CD3447;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:40 -0700
Subject: [PATCH v6 21/43] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=6272;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zGXgvV8XagrmhNGW3FqK8V8Ed3DrtckMqzLcrjv//4M=;
 b=8KNgU3INYotVGPDvIZ5SixAfnZXpUvbdFJR58jZxBe7aATbRBs3UbCYyP1oH7PBi8HSmu9MI5
 XdJtyaovuF/CT+DyJsAvLdpkHbThnWayTrnSEphk3Dz8iDN76MSVc0x
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F5CE20006
X-Stat-Signature: ym41dj1hm6ysaiwqdbbf64dry8aza9ni
X-Rspam-User: 
X-HE-Tag: 1778185378-328178
X-HE-Meta: U2FsdGVkX18IX8c62e0ZACI6Pzs1bqw6zz7Fk+RCXTaMPDP43B7u2ncn9ccvYJXbPLYOMjGdD3838ssRI6bTslH3Hs9xiorVQ2ccW8sqjgS8hF2YxamQNy3G5FnL4NEVC+nQfTaCJeoltnKQgy+7lydlKr+zikonFoI09z8+7WAIBDoPwCUDrilBzf908otaFR+pUelNHZlPXxwnO3HvvCnQo9n8HyJo5EawKVu8Qrjjatg1+UK5ORdnAcTqv11/Xp0+mhspZ9Vn/pNxOb6HcFj6dxDg+IHwlafDEP96JcNuwc/hD3o1KKQtX8YqmdiMeVQrO5Mz9S7CjwV6Lmor0rpnkpoi276vOPaRKmcHIJbSxJycukyfkcKL8GvM3cpk5mvW13DQSTFjmNu8o9VpPqCTAUeQogA9VhBlLBkXu8+uJ7zfB5RKQeGUNVREZPXAX/xxvdkpA6CI8T3ZlVuOw9MRcZMGzkwgc816ITkmD+7hDGixnEvJPOqp20Ua8Evyj9jtPczGPb4Z6j8uYd+mj4nr9ZwlOsODvIlzPzN3BPzd13YXCZGDA5TOOnAMQhTbiDIE58T3tBPdBa/70pYzpLhIrS6lw60n2cP9N/HZz85HP6HyA7lwyoMkxGV3k9+EF5708oASfMCmeOXcFxKszBPQ/KkGDAA/Qkz3grS1v9kdhyTDG7ydtgKERFFudgmO+5wMmB/Z+fhvxxVidvwBJhXUyfQUu3m70Yid7Z3WP6Hd9JMWc2zWH0tqlvUwhvoPJMNa0buE8WWr7LQRlpeT8IzLVHkJ7KxAqeWZeWXFPhV8MW0M6BPejXN8f9F9Qm6zkwFBJDT7uuAuQGHb8V3ozmaul9IrprhZWJ/ckshWIuq9RK4OTgEJbFmU0ZVtMneHJZpa0TAl7DKhrnFwymARlyNPTUBWRP3brzpK0irfLYBohMQkSl4m654ylrm3FbtvC5Zui112jBRCHTAJEeO
 OdT4SZqt
 CTu5LHIicnExpNei7adqE0JwUeSubO43gqhuwk0TVCFRlnQu7GQ+5dDVy+jvh22wTBF8AY7stGpm5bUGLKq1kYCDlLw5w4qHB7lmoM7rznrPbMDWOX5hJESmv6R/BdmZf3eeBFYLXZUaw+BKuzsTWK2VX/JzeBfMD2uM4desO5rhbFtvBUOQlGrYYed1x/+uKz2V6p6aXxSkJpHxVUwZQ9mOU5NQp5w//pm2ERIsB4pexvFI13mm52mWXa/0tHTQhEN99MV5ws9r0HUE1bVdDYDTDaesqcTyw1pE1dBSo7aD8EAtXmPOQyvTo3VPo++ugZEfYwQ+tVCvUTnXsT80xB+YfXn9tz7KM3rLY6EidClz81nmMWM6ONKOBKIV5cEWftywmQZfpMNDDPeacIbdxOFXUNxQf/PNGKiv4zHIfFd1xi48MamYs3yR9yPhC595t297OPOCBfzkN4eCgFNsPjfQ+u4m4TbBGb0NCtFYVuQ33nAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michael Roth <michael.roth@amd.com>

For vm_memory_attributes=1, in-place conversion/population is not
supported, so the initial contents necessarily must need to come
from a separate src address, which is enforced by the current
implementation. However, for vm_memory_attributes=0, it is possible for
guest memory to be initialized directly from userspace by mmap()'ing the
guest_memfd and writing to it while the corresponding GPA ranges are in
a 'shared' state before converting them to the 'private' state expected
by KVM_SEV_SNP_LAUNCH_UPDATE.

Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
copy in data from a separate memory location. Continue to enforce
non-NULL for the original vm_memory_attributes=1 case.

Signed-off-by: Michael Roth <michael.roth@amd.com>
[Added src_page check in error handling path when the firmware command fails]
[Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 15 +++++++++++----
 arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
 virt/kvm/kvm_main.c                                  |  1 +
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index b2395dd4769de..43085f65b2d85 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -503,7 +503,8 @@ secrets.
 
 It is required that the GPA ranges initialized by this command have had the
 KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
-for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
+this aspect.
 
 Upon success, this command is not guaranteed to have processed the entire
 range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
@@ -511,9 +512,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
 remaining range that has yet to be processed. The caller should continue
 calling this command until those fields indicate the entire range has been
 processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
-range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
-buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
-``uaddr`` will be ignored completely.
+range plus 1, and ``uaddr`` (if specified) is the last byte of the
+userspace-provided source buffer address plus 1.
+
+In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
+ignored completely. Otherwise, ``uaddr`` is required if
+kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
+in the latter case guest memory can be initialized directly from userspace
+prior to converting it to private and passing the GPA range on to this
+interface.
 
 Parameters (in): struct  kvm_sev_snp_launch_update
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c2126b3c30724..bf10d24907a00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2343,7 +2343,15 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	int level;
 	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
+	/*
+	 * For vm_memory_attributes=1, in-place conversion/population is not
+	 * supported, so the initial contents necessarily need to come from a
+	 * separate src address. For vm_memory_attributes=0, this isn't
+	 * necessarily the case, since the pages may have been populated
+	 * directly from userspace before calling KVM_SEV_SNP_LAUNCH_UPDATE.
+	 */
+	if (vm_memory_attributes &&
+	    sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
 		return -EINVAL;
 
 	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
@@ -2390,7 +2398,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
-	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
 		void *src_vaddr = kmap_local_page(src_page);
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
@@ -2422,8 +2430,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2479,7 +2487,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	params.gfn_start += count;
 	params.len -= count * PAGE_SIZE;
-	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		params.uaddr += count * PAGE_SIZE;
 
 	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba195bb239aaa..3bf212fd99193 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 bool vm_memory_attributes = true;
 module_param(vm_memory_attributes, bool, 0444);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(vm_memory_attributes);
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));

-- 
2.54.0.563.g4f69b47b94-goog



