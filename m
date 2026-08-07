Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91F6C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842A86B00CB; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820686B00CD; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730366B00CC; Fri,  7 Aug 2026 17:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311586B00CD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C695C01F9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:58 +0000 (UTC)
X-FDA: 85075824036.15.E102E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65D1D40005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5MHI5lA;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139576;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5ttymlAzFr9iTf+TSvKIx+lBBTxOxj5AEFhlVO6J74=;
	b=GggockvtIh1/1a3IUBjg13CHs786beCEAvriBEjBeHXxRu6aK+3HOgyh+UWTiQCp7D5jk0
	FirnCrqiYF9AuA9pa9tGThDpUydINPz1l/pHJnc6x5Z1OMyAXy9e4HNuxkPtSSPBq/0gRn
	aztGed6zuI4DwHNq6KorF5h5mnrAxT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139576;
	b=wM1LCCM+nODCc2P75wz2ld826tVuJYTID5UJhYd5xAjp8Cv2IUxYZqeMKiAvMgsOOKRg/U
	y2NQppNudhCDPd8N8Ud+209QN5mwWVk1l83vqD1X1sLNXwBcNQSPM2++TEXnY3MkCBmLgX
	yFnuBjbiNQhbEAqiYt/UP2TLvqW46gw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5MHI5lA;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A4C84517F;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51D44C2BCC7;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=YLkbSQhpDpMycPtWvUxnGRmi6OR/9u7YMYaQaKabGgc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=C5MHI5lAd4WHcV83RSWSMUwIcuq1DMdmnnW+xBxBTCudosL+aokFoNP06Qic//xqJ
	 G1lmGjXtQGoNgwWayfgn10YWPcQdLHWkTy+BB9nyXcvU3Z7h7IE8okCKpItEQ7O+BU
	 XCtDc6w4B6qUFg1MWLUSnLt6kXSd5itStTf4djDHZ5+kx4zRKA9RGHhUpf/7cruTTL
	 75glyqUuD3wrxFLsoElo58sfxNzU2hHMwi+vuxN1JLJQRHKiajiSwQVoqp74ov7d8F
	 8iokMsI4Dibkb/vNQtiS2oKvQgtDij1nkXSxvB2BDIkP/1K4X1bfGQmPeRyQt+/KlK
	 Kf4U0CU06X9JQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B57C5ACD3;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:56 -0700
Subject: [PATCH v10 17/41] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-17-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5596;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Iifl8NJUsDgSsBpjrwts0t02fef1fqDsec4cScY8f1c=;
 b=cZ7fBEFP/xuyv8gSTtlch/yP4N5da9RI6xl6mhTKrajA1+LsfZh55074pb/jZTksdexu/WOr9
 gcXzEitzx6jDPYdYwYlLRaWoPYBxx79GoUQxwq+dFoqHAlMdkkyiIAs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65D1D40005
X-Rspam-User: 
X-Stat-Signature: qij3gkkdm4p7rmwe6hzragstbrj8uiww
X-HE-Tag: 1786139576-216012
X-HE-Meta: U2FsdGVkX1/5uYClEDEJJCSL2QFyu1ZjMqmK5ZH6mRzs7RjJX+lRp7R06gNl5P0CJx1DITZYTCedtNee06P9Y3+L99MueICBaSNKGHvQKfsuOa80ucEq9JAfBULqM4y2XL7hHRtaEsb17xWn8GyqhlsI5VWZaBRAbi6MqpeBl8lQGIt/4q355SgN6OThP5j+Y3F+XX7NGSb/hUQ1Al6JAwj4hwdKHEdOvjv1UPfsvrpPSxEueZGTP4VKdwtxGZxVm7xG+RZwK1MhyaY8sQcXvog9WNHo5h9noJdJPeek00aGLF/WOXYsAkZSEz5N9Bbq5Cit5eFA8D6rPFA/rtFKw7HedJX4CRltu0WBFRUyt8BlJgDfshQzVihmTmoyBYlxKNNP6sSGbd8WbVfRgq61EO8leQ3zp18D6L64nWAEcbkvqvmQEEiVu4vls8hRg1T9FHYcPruOcAjv5VZsL0E6DM5mq3bLVBAAzksziL49Xtsv34k9q5tHDIfkIr/tzWpf9xMG42A+bMHWz/G7dAY/cc70vJWzis6Mxml3BS+d1Pi3/t3a9h9mwCh3Lu5oBYZPfRq+vaZwQ6NWyT33xk3QD8iv5tGjndI5rxbZ1nn2Nf4sMBm9nQYMnDGtJoPU7C+obL+L3Hf5/zqxZNNC+HDwraDz7TmVRYm6H86HCC9JjpJ4KM6P+j/GKftXKuHsPyt8YK1fznY7YyQGC4p66cV3+HaKhq72rwgSA4GzpwQ9BqyiahNGlaEXTWHxA8dxoZbzWWET0pt6Kc2NH8ymie3GuK4IsvZxIvVw9VkQ6gcZCKIy9qP8IO2iwn3H54fOA/k6QLHWC0ERZeiOByQ033lUVIi4UmzirGqtg/DmzpciHdaXzuW3l0XYKETofQ1kZQ3vkdw+q7giiGxCgEcxZqdnPOISpMYjbalRbxitQteiu1wTX7UmpC1gklO84q7qhVYUn7vXs3N6G8PplvcHbsJ
 PxZNcbaU
 uRpJKIFbZuKVqIiWy41MBmntI0c8Vxgp3zuqZgvpfWm1J4/0+XPAsyMZGAXs42eDTgcpFFTG94/TizawusqPRBYCf/tr0Np7cCp/xx40o87hLeBp2lHilPsDY+JbRrL9caRu1/iujPGCfijCIDYR29UiIPWOg9glYt4+Drp6fKR0kCDaoJAVtrHOw5G14jQsIM6Io4sgJws9TIbcifHoVVY8Gm40RL0ZOrpCk9gqEt639RabnYUhUnJrHrfeW+I6ABK26YVpGDGF3wRJhQ8Yi1+vcjfo0fAHrzD5Cna5kfCzr6E2D2b7rg4hO52Ot7KALv1pMbToiTus7tIsryR3xQ/dikU4uikTFkMbqdbUmAUlRzu2aMqFyHXbH6rH3LC23CHiQhgHMrq3JQLREN5CL9y5vX6nlm3B3jk+P6CCj0Sr9+XKGKHezN7i/BdYHabo9ytAFUHQ2gpASD2JeDBEVZnJaC3wOh3kB/gWb27cBmlQdXdDWe+drgxGbwsVlG0l9k4UkS8h/n6cERs02yIGtH52kmUAYw15PQe+sYXLkCTb6W3uQ9f4Zw7xjgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michael Roth <michael.roth@amd.com>

Make the source page for populating an SNP guest_memfd instance optional
if in-place conversion/population is enabled.  If KVM can convert the page
in-place, then it's possible for guest memory to be initialized directly
from userspace by mmap()'ing the guest_memfd and writing to it while the
corresponding GPA ranges are in a 'shared' state, before converting them
to the 'private' state expected by KVM_SEV_SNP_LAUNCH_UPDATE.

Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
for 'uaddr' to be set to NULL when in-place conversion is enabled, which
SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
copy in data from a separate memory location. Continue to enforce
non-NULL when PRIVATE is tracked per-VM, not per-guest_memfd.

Signed-off-by: Michael Roth <michael.roth@amd.com>
[Moved condition to snp_launch_update]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 14 ++++++++++----
 arch/x86/kvm/svm/sev.c                               | 11 ++++++-----
 virt/kvm/kvm_main.c                                  |  1 +
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index bd04a908a8dbd..5977fbe33b98c 100644
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
@@ -511,9 +512,14 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
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
+ignored completely. For all other page types, ``uaddr`` is optional if in-place
+conversion is enabled (i.e. when the data had been written directly to
+guest_memfd while the page was in the shared state) and is required if in-place
+conversion is disabled.
 
 Parameters (in): struct  kvm_sev_snp_launch_update
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fcb41dfde4c02..f708fccf71307 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2395,7 +2395,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
-	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
 		void *src_vaddr = kmap_local_page(src_page);
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
@@ -2428,8 +2428,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2441,7 +2441,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	if (params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		src = NULL;
-	else if (!params.uaddr || !PAGE_ALIGNED(params.uaddr))
+	else if ((!gmem_in_place_conversion && !params.uaddr) ||
+		 !PAGE_ALIGNED(params.uaddr))
 		return -EINVAL;
 	else
 		src = u64_to_user_ptr(params.uaddr);
@@ -2488,7 +2489,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	params.gfn_start += count;
 	params.len -= count * PAGE_SIZE;
-	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		params.uaddr += count * PAGE_SIZE;
 
 	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c4c09593ef8b9..c8faf1cb82167 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
 bool __ro_after_init gmem_in_place_conversion = false;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 
 /*

-- 
2.55.0.654.g21b8a5bc05-goog



