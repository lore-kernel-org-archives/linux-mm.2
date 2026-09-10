Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE9CC88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA71D6B00C0; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59E36B00C2; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9462C6B00C3; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD4F6B00C0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B354FA06EA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:47 +0000 (UTC)
X-FDA: 85199512734.21.2B8E790
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A210640004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=es8Z2iTS;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084545;
	b=BbiwAeEbvmyVG3lShmyOTz74G8xfrcuJeT279XFLEk4Nu3fa59mFSKtmKkMxVza1ikPlbD
	EaUTtwjabWm5e++E610NJAGK+L/FUkRpKe01NS8vKU6vnAvmnr9z51u5xQYW0J+LVmSgOp
	kazWGe5bBgeBbO2mTv4RcmV7RqmJ/l8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=es8Z2iTS;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g47rL6zNbckouPwTwSVdEB1fnuuR5YS9WJ09vrEiKeY=;
	b=UtMAOpCZXfxF/Mew01Kyi/UeFWuY+ojbsCx8glFc2WG0y5q4KaKu7qF+tjxrsprkSvby4N
	YK57RslSoC3O8uvS9C6f5zA4HiG399IqntrMYEpHmqjSzcnT409PwKQRoiJ8HiJEGiGZlu
	mIwn8HvC+Jt+KUAq9fsychWtzH+l8mc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB4BE448AF;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE3FFC4AF60;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=EQZ7fThtZ0mv0GbdIDzzKHGH1Enl9yVk/17whHPCbNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=es8Z2iTSW3+0RS4RJNn95OgQab9cNJgtwk0rBqyELLDJ2iT5Ge/QkceuFrjG4GqA6
	 WwMrqQAhGzrgtq6F/7CJDds78nWL5OXpsfaqT8RN3BWsn6R4foA4C+vfbSehfOFVBr
	 vuyfRYTlToAi8cgyNikX7Kqao/dow75UfUusECVZJBxYWDI4r1QKs9Osw2na+Lj1s1
	 Aa+Hlj6DeoFFY7iKJ4ycLcfcB6tuzC+068Pn4cnVpMNNhOeTAAvCfc76joOqbtpkKH
	 XFWMeZQfp93LR7QUe673qZA+Q7NcStxGUrbw6xwG/7izr1txM9f2piLsH2wttDnzyW
	 PE8AzCgKsm7kA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9659DC88E49;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:45 -0700
Subject: [PATCH v13 19/44] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-19-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5607;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=M0KJetB6k9uxwlfv5vfaVdz3anpPnZs7qNbQ2GOmmnY=;
 b=f6mG6Ov0l451S9qRAr8+7G13FnMboNwr1+8jNER3FqzT82TPxgBm/4tIIUOT78QMFnvcVw7DX
 jFvnN8dlljdD8y1sAoh8g9VM1HhcmMoqwGhP39NSDxQ36fUVY7YC1AQ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A210640004
X-Stat-Signature: qn93g4tw96x4s5immwicsg7o7cmcnhp3
X-HE-Tag: 1789084545-135456
X-HE-Meta: U2FsdGVkX1+Y7suutru/JcMstWN7KW01kIgW9DbH7MXpUlgKb6k3R3AiB9ZhA1TZjENV82cfWeJOcPSXKbNB2UeymdVQ6Yw11ZHzlvLs/nq1xhsR2aYskbw2X+KNdxlfgZwT649w5rcFV9kqTW5cQUzhjpEFwG/fJIKQZhi5rrDr0cImzteaC266fe2Wv08nDappmoANYhbCbOd2Jqn5eUSoFKeyrR43vKkjcUrzpVTCo5Si9VMtNL+Sppx4kTreT58FySqA3nv4v3wYFG9ccjvCX93eBh5gI9DwgFnh3gf7KXzN7wADNfbRh5SzvWq8X1Ujaz6UzAIUTmdok5MjSYcgv5I7pITMqZkB9O3ErKHzNE0+p0lsutlR8icv62BWNG03nfP+sPHsryY8qhshKMEVULVn/1UbF/cyJuMvF0ub7EhRfapW5/x8zWlTzM3b/9D8ehAYjLScUDcuUFbroIBlqpnj5vxBYOQp5+72pdfLydN38rQUWRgKJezMatnzmI2gRPrNLkqWhJf6ET58GjeHYrynFVNpmbkzGnb19WANSP/QnIHYsIZVANhp70Nc5gOaGpE6N8lwasT9N+Vuv4NAiYhuSq1zqbAN8UbVw66+b62xUc6ADJ3saHNTee+MukFie88R3HVVcVftGNgY7b1n1TMqEDfXA44UgqL2/kKXLKGOaGMwMyCnERajAa2Ax4PNj9X4STOJKPEn4orSrwnB6rjKDZDQ8qkvoEjx9Y1R9QxDEw3Uzw8+7v/ShucgWyPutH9thOk7JBS0KFgG+NbJCnMZxK6DPIBsuOTx1Oj7xl3kO4Sq6Gg08wihC/SmXRsnCDK8oImYXYgCijOaY7UESzjex1fNxH9nawxSqGztxqnU43eCCGZC0ClKafKMx/kNjm6yzfbN3NpDFVE9auHXXTmLjQBqR8r8QKEEMUQQCurrBi+3Q7Vc6FxVCIabBMQxomvPSyUh3onb3f8
 sN/QcO+X
 5/jSRqxYruUjdBlARwsZ6eerywUjeGr1qGx/6i8zcvLPx4qhD7RI31sJm4yx+P/BksAml9hGqiee86LFYP7/PgoV7HnaQtj93ncD7VqlwJvuXEppYueOh0DAuOWy1WRoesJADF2enYs5l2bDxdtY6WskwcpHlAqC7Tbxwb0FUZNQGrYgiIXtCoP+Sf0TTHOtyXxYpwNnQruW12Wdu9pZEfOTimyaaRNnfFFIy4oCDMZskj7YLhrsX/9HwM5rrWaB82cN+sGX7WvxW7jV3u+CWnG6EK45DtbDf13RLMYUXgFSF4nZGB9ihkBZvW3YfvpTT5+UsH+yaC0p5FFPM94fp75DJP7qJ+gSxDYitwsi55hmSAcwfAP1yDtBNWXGRL17yP+akeNkqTy89yVClA4pxd9p7ZgQ3ykgy/glEDddEwHf1vUolEhAxAyIET4c/WniybsqnXu2/aGe2KPrmBqnHL6k+FdQCfqtHaZt1a78kvOdnt3AKcFiTul6s9HTJvA6uteWcqYj29syZMrvb1b/imBRxOQ==
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

[ Sean: Moved condition to snp_launch_update ]

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
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
index dff684b88f153..63e8cfa9bf559 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2400,7 +2400,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
-	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
 		void *src_vaddr = kmap_local_page(src_page);
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
@@ -2433,8 +2433,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2446,7 +2446,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	if (params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		src = NULL;
-	else if (!params.uaddr || !PAGE_ALIGNED(params.uaddr))
+	else if ((!gmem_in_place_conversion && !params.uaddr) ||
+		 !PAGE_ALIGNED(params.uaddr))
 		return -EINVAL;
 	else
 		src = u64_to_user_ptr(params.uaddr);
@@ -2493,7 +2494,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	params.gfn_start += count;
 	params.len -= count * PAGE_SIZE;
-	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		params.uaddr += count * PAGE_SIZE;
 
 	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ea8198821917..05c518c9b8078 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
 bool __ro_after_init gmem_in_place_conversion = false;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 
 /*

-- 
2.55.0.1007.g17ff1f9808-goog



