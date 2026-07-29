Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A725DC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981D46B00AD; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9602F6B00AE; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8203C6B00AF; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57D196B00AD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDE601605A6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:17 +0000 (UTC)
X-FDA: 85039945074.06.059403A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F0AA140009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTk+Qmd4;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285316;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whAX2o/iSBCq900SEZrmSlZckcyQszjt4/Q5Qf5JLLo=;
	b=dqYWIv+tzcgqKGqbKxKjiYLsnQYGAkRohCeLwePRFP89kHC9B4IYFfKELzAp7ce62hR1id
	hIROd/SL/G8o/ST6QXMSaAkuizelMiLXzS0YTxidZ1wEk+/AhZUTcW6SVSp1iEy1UrRxq9
	Za6mxuXvWx1jsiGAILYWImI/bzuncp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285316;
	b=yVyYJGBgQDVXjtkWIgvY/Xp/lSHhXb8F6JDvtnHmSdzJ+3HdttaS+45FWYe37ZDNKaUZ22
	CE9QNX6ZClOCgR7qGzRDLedHYS8KOUOvqK8a37yrluFA0uE2jddzMWt0A4ru0ax+yKxTBu
	IMybSV29J9/Uzcf40JD5uBv0iaJlIVY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTk+Qmd4;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E73451FE;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39E8BC4AF55;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=hjGgfJEmj7T444uRhdYBRyBigX+r2du3cYJM48y7GhY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kTk+Qmd4UtDSMVtbyn0MLPFK3CZ5F/CuFT8eWid5LdAefgR9/p8HBB68jXigkAXJ6
	 2wP5rxay51uK1CYvr/+2B9hUkPXH1vx6fGw8YJC2ibLAU86xQUJ+9WHO3OPNr8QPk9
	 NcRhQpg/V4++f4m2T9E/lphESXbUIrxvxj7shGpamd3PFWgqeptQ39GTRTGFvW08NQ
	 oqcTBgr3BvYkN+BhCJt1eGasG6Ky5REd8iecWuWfsj7YYxqSU+W1A+QP7x/atym2gP
	 OuGr8GEkim4ISdJtmmchxb269pneshxK6Wa6qHxj7ZViq2ALnksRfT9IAT3ELU/aOR
	 bw9VyHrv5okDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACE0C53219;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:16 -0700
Subject: [PATCH v9 17/41] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-17-35f9aec2aed2@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5596;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=no+ubBrm59/MCoDwBuiCml6nOA/Nqpdk8zlCUSYBJ+Y=;
 b=xNxDQ2aTcyaHrdGjFdmwODsJqaVNDBfQSgBeJghNIIcKNILv+GJC9TeNQ0uyHjfEIrU13f0Th
 U2ME/S1f9xNDbgY4l7JXXK4gySpZxloNWjfpIY+lcXHt4cNu08GiHa2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0AA140009
X-Stat-Signature: ci4gh16dcco65ieqf876ed1onrjb49yz
X-Rspam-User: 
X-HE-Tag: 1785285315-179815
X-HE-Meta: U2FsdGVkX1+hvQF1PhbYpgaoi7JPhk3LsZcxb5WglnNMTrIOE9qEszhdAyCjMLbjW9PU+IudnF6O8mtODC+Vxx3yWgsXLXK4F2ptZLg5nJkWbNr4UL/KL1LBF1lrbyWMjkqQr41hOkJjmMmxyg3A/jJZpdCySZbaBYY1np9LXDW8lvUPMCZjoTB9xMWxytnVMZSBcCZP6By205aXK6w+D6ZB5O/nOxq5iXLhILNTakFaP0GRPkzl8g90mNE5YasuBT36L7d5JruMySGmjo79oRdgCa7jZuDK0oaDmjrOQPA4tY427UuepjLVWsS9hjjhxSZ81CTaw0gIn/yTqbM4x7bfhBWEpfjtpBawia/PUw+VATJYKQwDAojjg2ZFplh/bONZ81qR1HtwHO4JxbpnpkDF0GcgaQZvhpKrF3cUZgsxVbrvQWBp51WANhw5HlV2LxB54QOJpkrNsksHqxWo7CVcx/iB2gke5/+Jw94z/MWQ6/ZJcVJNa4GnnmTsiGEWUjOuqtZEmii+AThoeWZmhrrb+V649BmXm2p1nicrKJC5gUsbvfqVUvV9tYbNl+WMZDbp2Hc+dlko+SeB557dm1wwOx1ETLgBt8nYt4erQImLET9gK3CYFF9x87f9y5kfIBfNgnUif1PXvI+RI68q/o72bWpAqD4wFMlZF2hLQmy8daUZoFW5PHDorloSce1x6KwyijqteP6eBHP3AvZugtA2y0VkHeXBJ490XtrMCMUD81A9g2uIFT+uoJ8t5d7IdMgdWiNIxIftry1qCyHVNU05XAiHc2eyjO5SbDoU2zBhianPefojVxIyhNnDbgjYmjlIgbD7vcNceaPxEKkN0YzRkGZDzzYQiB7Jd2gU7IIJF4u5UMDamji3H4UYnclJ7q8GRhcgReKIfZx6IjT66wmxTXO4i6ZnGL/PyXlImisEDvAHz3cKKLaTBxOlzRRbMLwzCH3IK+yO/09+PdK
 eO/R1suM
 PlnoLPJ5cbKGIDEsd+GDnUp+wRhYoJQMK3n5LUkHow5lmICo0w1wcN/kie8SpPXrYYyvzn9EhIjZ8ODv5GCo9Q7i3Qqwn7vMlEnHAtE8lGzt3fp8Esrxum8u24iB1ZWD4v456wftxa6DZ4142/YaS4kKWAhIthDERsfO3GYayG7hXjtxL1l74zE5G35ecyG4ul/RiLxlqIfHF7Fl7uO1Lw4OUB18qnS6J+fEuMeootVxTJlflt5WVAFeOSno+DYEPfIDgMKZd1d7XRl1UI3uPn7CBNirfXm2bdGH11RbqkYBCCikVVO0SMFacmfslJ+5kjB5Jo/HAxv1Jf3dmFz+/7/7ljp3WDOIY/Pi1ZoL0Vo2slkUEbRg0EqldsysBp2Kbw/zHBYPR20Pw6zEp2wYuqsWDl0X5rlKxEcwjWQr8HHjpIRbMD57alNOfL31GZqY/F509wk6GD+4OtUzOq6vRtxwsQbMf0ujv+5ShljQYDuvBrRkHzhJnG1MSPiB8uRALVeH8oEQuiXchjK+Bg+wIdRw0XWkD9By+F2vrT5CoCJcLr4VoJTvLqZGGNQ==
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
index 90a08d36d843d..0f6fec21c1355 100644
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
index f0f802eaca16b..e961cc297ba2a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,6 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
 bool __ro_after_init gmem_in_place_conversion = false;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 
 /*

-- 
2.55.0.508.g3f0d502094-goog



