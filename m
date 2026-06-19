Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA150CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0144B6B00AE; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30216B00AF; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CDC6B00B0; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1BBE6B00AF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 154431C4829
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:58 +0000 (UTC)
X-FDA: 84894784716.14.51AA971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BBBF20008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NlF2jgAE;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829116;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4RVBOPCQ0OqkjxPnXfMfXDfrntbnqc+DKIM7iXNXsI=;
	b=rg7RQtDBPNO7z2z7UWeFZbOQ5omVWZFJkfIK4wRfw9NH7ayW+KownxU6Td465v/2R59Mdc
	ZgPEMPgv/8XkXVYLDxNYhwVcPCQHl2sOijM+i+ZbOVTbsjaODh8lHRQTwIi4U1tpRAMTJX
	+bCdFNTB69/qN+maUFnHBckNb9GeJuU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NlF2jgAE;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829116;
	b=gVme4thR108XHOsnUZqJYa7cWvRmmpHyIM3DXg8WT5PTXA9KdaD28qiSX+ebaHTHlOp/ki
	TWhfH0XA8LApnt0nCHyyjdvY02nazkQR+MvW652yQsAPP6505cLGVMo5rbT6AuMABPBZ0q
	JtRcqVOQVKNwo6uvRG6hCpT9/V222VI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29795446E0;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0545CC2BCF5;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=Y214D8EYmmgv568dSI8IvVw1cEvRPeVuqU4a72w++2A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NlF2jgAEgLXc32TObuwkFWM6FDc/MRDYtPW3Pdje7AtJ7TMv2xfqzEfj0C8N5UJoY
	 ADvhT2NwZ8bRX2k7Y0CU20PNOxpk2TvopxfN4F8UkgCo4D8YcGZI7sSKIOtrhLLvbl
	 hoDp4kFb/jLnpCS3OoRv5A90K7GUQlGgcWUwDb81I/zz98U3tUWcsSbjOzpoPiZ4vU
	 tH57XhPE1VSrZLb8FjchEG5AzwapOZwjv7+84kDhqRNb5oDi5Emi8pXdbuhdJgHz5h
	 wywsOJdL0kySadWdHzQp2Ar78B4Xhkz5xQjtvX8fRFqXlwNEurC1BW0BQEc+5OdMjT
	 599aDvLRN8r4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF939CD98FA;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:59 -0700
Subject: [PATCH v8 22/46] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-22-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=5933;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tQi8qJkknAfBcTf104klaFd67JuBPmTFwmizL4oPy4s=;
 b=cBnNnoLB2QhAJ01EMqCMeHMFVTh1iL/r71OEPnr9gP+uhJkS5miQxdNfBwmLFGOyrFudZ3yq8
 UKBdIrAZ5GoBQvjOaWCtl+Vff7GXA2/xXhyee4hOFCtbxfJHXEGcS+L
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1BBBF20008
X-Rspam-User: 
X-Stat-Signature: u8q7yqgwomwjkfqnsa5znn9xawr5sfh5
X-HE-Tag: 1781829116-379953
X-HE-Meta: U2FsdGVkX1/11ZwfnWPa3qw6lsdIYM9zUSEF1qxKgudqc2LIpr4poxLeVePOqVFxq4aLsO4m/fpMwP/p1rrmW3Hdnx1JBwPuns7mF+1Ue/JtwOmjDAl27DZz5gza3IfyXB7ZVLnlAkU/3mJgwZAoOU1505TPjVnAYNKtpXKOYpifDuHKl6qTX9cFlSoWW68CsWaF35oMjIB7nBzFZtAel7pphdOk61o3+ZXwPS//qG6XqlwfBez6mW58v+g7WjRJVZdnIKoGfa3kli8wbouBB/nrx8+1D7YIdnrfAXK0heeios4SpSZmn4EySqyeSk+KkSURFVI7uz1bdaHSMk1Nm1sfBWoU70w6FgVKiXT1cKw9pI5l+bFrcSwkv4mf9ymbO3ARC/jEalohErY7kYSw81wIb4LzKDdl6C1sHP4gMw7PQIBEt9ipHrI0F2rqF/5bp30I7CPcJh1iQk8b7RYDez/aRGGNa5pgYgjWYFXzYU9BlRguy7JmD/51k2uMcevLKvP2PxmdQRHG+trdGzv9CtcFql1ZtifWpNm12pVZIjc7klcSIJzs4ljioZoKaYqbhgmWldXoUDM1xA8RejsmSEUgACLB3n9TOKYPAcrudjaGR9VwA8XlZioHazgMXx3fe49IniAG7EZqYe3O6dEjY8m9N4rphJoO3Vb+tnUVRg9HdGbVp+VFoDx4dbh+4qCSn1AGSQzIMVu7eQkL8oL7T+1WY3j3rqkZyRoggMe6Pl/KkALfhz5yBkc4PlWzLZDE/sO4aDxG+7jJYVEI3ybRctzJNFEzbqcEsYEwXDVo3ksdjaKZddqi3Tww9TksKdpwb4Y8+1wOHmtjn7zCDI5L8kK785YD/NPFZzBSDwiS1NCjOHGosSvidsLOwHVVvEMQ3luVT4bu8NLUhOSeKUjgYHLr/N0MvrmIO0i+439E/xd3WzwTAl8a5gXr8Nii/vWNwTjB2R6R/lSTUdzZUuI
 NhdyrmIe
 2v7Tfcsa2o2OGHXM7+zWVVpVCo9j7KCfBG0bu9F+BmEKSOxvI6psn+uBfljxbYYD66TLQgacnn1oFoa/qSV9xldg/oEI2f82f6PG+7wmkz7fnACVEe3hNB8YfxWKhf8BZMPu9MIM/Bv8RxA+4rnD7kizESwxQ+syfaBnb1Zjc5jDAIoEmP1WtVB6XHpZ5xHqBqliq7G0a/TI7e5W5GRg8l45Imr3jKjhLkrt5/Ehce8LFCWcxM7ra8ilipYIc2nAbhVmcgEIbx29aYSGa8JBKe6L5lZd46eJHdL4DM/Ria5xTJuTG2YGu9I2GGw/9ZBgBEYR6NelnQPyh8JzdKlBCIG5K+yF+tUFCmVIFhKqAUKX/mupQC655axt1iPJyCOBca+67qNNCAwFdrungEu5mHhf4/0ybXtHxkoalUD8pCEISYVxoq0UuWVD+iQkYW/XOIUdy0uhpLGmx49SvGyrLp5CwInVCiVElTGo1/1ZCM1G5ledIc2XfZr29wMpG8Iazt7VTRgUQOxa8t3/exrDu+zvD7A==
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
[Added src_page check in error handling path when the firmware command fails]
[Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: drop explicit vm_memory_attributes references]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 13 +++++++++----
 arch/x86/kvm/svm/sev.c                               | 16 +++++++++++-----
 virt/kvm/kvm_main.c                                  |  1 +
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index bd04a908a8dbd..29409297f1ef0 100644
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
@@ -511,9 +512,13 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
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
+conversion is enable, i.e. when the destination can also be the source, and is
+required if in-place conversion is disabled.
 
 Parameters (in): struct  kvm_sev_snp_launch_update
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74fb15551e83f..2b7569b6a8609 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2330,7 +2330,13 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	int level;
 	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
+	/*
+	 * A source page is required if in-place conversion isn't enabled, as
+	 * the data needs to come from a separate physical page.  Zero pages
+	 * are exempt as they don't consume a source page.
+	 */
+	if (!gmem_in_place_conversion &&
+	    sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
 		return -EINVAL;
 
 	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
@@ -2377,7 +2383,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
-	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
 		void *src_vaddr = kmap_local_page(src_page);
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
@@ -2410,8 +2416,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2468,7 +2474,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	params.gfn_start += count;
 	params.len -= count * PAGE_SIZE;
-	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		params.uaddr += count * PAGE_SIZE;
 
 	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 044486f128c37..dd1d18a1d2f68 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,6 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
 bool __ro_after_init gmem_in_place_conversion = false;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 
 #define MEMORY_ATTRIBUTES_MATCH(one, two)				\

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



