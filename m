Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0354C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F2A6B00B0; Wed, 26 Aug 2026 05:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46B46B00B1; Wed, 26 Aug 2026 05:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DBA6B00B2; Wed, 26 Aug 2026 05:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42166B00B0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F21D91402DD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:44 +0000 (UTC)
X-FDA: 85142870568.08.A23232E
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2695340004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbI+GSoI;
	spf=pass (imf12.hostedemail.com: domain of 3ca-OagsKCGYEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3ca-OagsKCGYEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKp8H31vpndC0T7+bBVQC7oQPgnms4md5owa5X2MPn8=;
	b=CetY1F3nFu3p7eRjwrsPu+5e+IqTc1o5URr8dtQc3LX8ST8Zv6xBqQZnRWWiqt/mCFqh7k
	AjbsvM6FOHR4UGkQy5NReY4rGpV325YwM5OI3md121dryDd8Q9Rm5CORPk/SILjmBiV2y+
	4VQsE72MwoAz8SgLqOqaBnlw2n6Lg60=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbI+GSoI;
	spf=pass (imf12.hostedemail.com: domain of 3ca-OagsKCGYEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3ca-OagsKCGYEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735923;
	b=8LoTn7C4h6vqABpCSS4KvYPUc5BS8mJq87Jv3xioA2n6yg11pqOamaduKwebjGXSKPJyA4
	hf//f4FdDlOpfpahfyKXwNsnkN7zo3h0/+LxLauEqkdHIM//9mGrYO7m1JqWfAol3uUvK7
	XYJv3MBSzdT4rSZrxJjZsTB4X6M5ES4=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb92868263so591940a12.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735922; x=1788340722; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EKp8H31vpndC0T7+bBVQC7oQPgnms4md5owa5X2MPn8=;
        b=kbI+GSoIzyyJJa1VnH9H4M2B79/LMBcYEyvD3zE4QPqUsYha3WoyHnvODha9LuWt85
         g/0CjdtPqC3F0ELJoXcs38b7IsOoo/giCqgv4g3MJmqyLIWticdgWBgFtl0pQ7jKZSC2
         iiLa3m6S7MrvyeHAf4CJoFxxs9n2UsxHSIBiTqvrxD+fLtyDlycK+T2C3tZZDKMO63Qy
         y4xwk1qgCu5zQxij2sh3ER6qIgko4X1gssMlFHHhuAsKc0Yz7dTRHyhGeojxXZvyMFMF
         cosj0pKcCMrjm/Hxi6II/i0Jmyl6hWhFmJM48565fDvzKqg33E1rXsACf3muLgYOyG5N
         zOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735922; x=1788340722;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EKp8H31vpndC0T7+bBVQC7oQPgnms4md5owa5X2MPn8=;
        b=GvxluQaYAvVPZ1ygl709GEHaOHhWmNB46hT/M1qlRWGySOQ21gneaDtSFTpa+SG7Lr
         TwN1yk80jw1BPnqcVYRllkebP3cN+ffve27YWWvmmqIY4Eer0pazp3xD0pX4BzB8WfUb
         3dVWSpz2bYeEjBf5dS7PfCk3j1k2eoXiNvo+wQWS3iUyQc4RK6dAThuKxtEvs3x0zLiY
         QNFBDtYRBAbSsmQO1LFurw3PVGlOmTWaa3ltyg0XrXFgAJVh4/DOsM49CpptHiPBP0v8
         +dmAUyW+ndGao0DeSRINFhdymtQH5OLh4l7T98Z7vhtHG5ycrNIGHoTrLvidSRjUd4xN
         uq2g==
X-Forwarded-Encrypted: i=1; AHgh+RpY9sD/ATm8rff0MVK8/Koh1HUrE4gHB0brRYIiqOCyjeR9R+ewd38X0NZ6KEPS0XD0EbAh2jdgXQ==@kvack.org
X-Gm-Message-State: AFuF++k+CqrWa6F5rhZ+1wNYegAcnFN48NxaYTyBjzjIVg6YuTAH8tvI
	ncJsSQVC1xJcxnue50h1TT1SSKU/PppWEboS7qTNi0mm2j1tTL8PhZiqJZwerYVxqX9tK0W5c/y
	+2kdHYcu00VaAkv3s+od12pkMgg==
X-Received: from pgbbo19.prod.google.com ([2002:a05:6a02:393:b0:cc1:4e93:a711])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a03:b0:3c3:9c4e:de3a with SMTP id adf61e73a8af0-3cf82a348a3mr11724369637.6.1787735921564;
 Wed, 26 Aug 2026 02:18:41 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:18 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5596;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NFa90siDaW2AryA30Q8bJ5Qh7q7W2DqG2XaPe8+kXyo=; b=v0d5C4wkWWesFaHM60cN7REFurl8Oyg0VII9TPxllUT2UaIYDsS6Nac84jjl3ihI71jCYcDgl
 xbEFlslA2w6C5IahaWJaj2wX/VE9nKjbCz3wuE3sGID9S2vKNO9OT1k
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-20-0a15d8a799aa@google.com>
Subject: [PATCH v11 20/46] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 9irkm69euj4un6dnygrrqx4exyyyoc3z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2695340004
X-Rspam-User: 
X-HE-Tag: 1787735923-920926
X-HE-Meta: U2FsdGVkX18yPthLOoqpnONuXzxNZdJjv7Db6z0dcMkpiPxMvyB10hjO4RoI2P41NlCaHReBo9zqHgiyrC1Qc07xx+9wK5ptl2UsQCk9SoxFiKy5hJiRvd6/ydWB1XtaQvKkMv6xObsLzQw3VA6eQPGt0BXhZxVSxOdLCXjpowak82zuKb5+40FhAmjPfqDyY5d5bLAGu7XSMVrIlAN5YoT6YbKyvLH1nDTh2DnVFjHo3hhjZtpjeKCubbQF97v0sksOTbD6CAIzV0m4oT/lvbGZuFQ6Bwv5jb5dcSRc+0wliI0NWA6O6oxgK+Toc+gU4nsL/lFX3cavq7pIzt+C7a5qcxlEY7j7Fe0mF9MjY0g4sy/K/nOV7VS3XRZZRxlkha7dmjHaTxmNeykZUF7nhLiBskfkf1gfH6mcy007Jgxut2K1r4anzWoq9pj6cITHkxMNxeJlY/KROLfmeMrWxzL6aKnlwHpSbaAshRcLOb44HyI3Y6AzTxwOxNutz7aYzOPuZgEcKhoUA6pfi50y+i7I28NVf2C6vtE8s6SuEXZCP3x0hg6iQhVhN+jAJCqu87lfaY95XzS/F3adzdc43EXDSjN066HfKAjwWVNdsuOF2dsJpuUYZ6GhphK61bmQvrFOHzJXRObwIU+suP5r2ZzcVk1ocLfwtjC/VIt1eXRI2bZOFroVLBnDSC5puR20ebMYyrJEJ9Q6qNmoSf9PzfRSu2vyAvb4+SrEGrzjqJw/MvqcL4KXhGLsDHXW50bghYfeI5V5CEen/CEQNf9iap/Ke2uQdk+/iff7oZPrRwBHKDX0lXGhIg5Jxe6ph5IsFZUCdTjaOqxDJxPR7UkhLfSNfP+zB3uiVHTg0o988bDK+ApyvPe5ZegQehaAWrGq7RBKg6ATM2+0N8MUZMWuZClzM/g6/4Bl4Zj/APyERlRjjlQIQWJNczpnJb3HnfHMXEjnL3DyDokWniusKEn
 suBNSbYP
 Wy8BIXlN76icKjUDqXtVKrH0N2rb+D3rrEEYxefzzo2MuukaGNW4IyaIXBAIv1ilGXtEaBc6l6Z85sTAOTDUFaC5ejIp1LR5N+w9ZYvq4Utj/2RVg+JAfZHX/IN075SOi67NWGmHqb09TZhTTzZFetIyVDPeNzSjB8fDgN8uSHXm6qVjfFjXssCiqp9TavLJdJlERJqymBzkunUKc02URpP7d0p6o13Tnb6120sPW5eTTPuWvozAOZAK5W+GUREcQE0TD5Fj53D6unFD+k33ErWJ2GbGAJGx4LFvsiMrZmg30xplExSXeUgRXYqPv5dGPmaHzXhNiB6Ip4bIsp//E8QFmCdUXWoPJq+TeAsMfddT5FyIV/FdPJg7MMmIS3+rw7yuHqCDUhKZq56oLLKHJX/6fJGBS35VdguvZfs/OU4LyVmegPJIg6NCmma1IdN/Do5OEIo3i/tb9TRluakANFKJPdMSurT8ekVZjXVtrukKrs/DDTZGmVf6/eqL5tgnvtT1hoIPuYPt3FQClXAmGfZ513ygviWs/jRKDvCF+vHM4y3rsKyM6cgdtkuTvOlaLuXFe1c8CfvbQqvZeai/mSsCbrmTJqMvoUwoLooWPOUvhWjmUxidRsXpXmKI0JDDpV/FPeJVYSpgJbtqIyJdUICGXytjrc+xjEeZWdob4UlXMRMuiq9r279NOLfpdyJgSjJGK
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
2.55.0.887.g758fc8c411-goog


