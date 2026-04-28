Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA2FFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A6A6B009F; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52296B00A0; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67206B00A2; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948B46B00A0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 501E51C0F9E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:32 +0000 (UTC)
X-FDA: 84709548504.23.FB0BF05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2BF09100003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KUZBH2j5;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418730;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2izoILJJrOA5C6xC4AqpNrHAePx0ezb2d0+nE2qNjo=;
	b=DLYKamrL5HoSubiUt804xORRe001hJll4tSFd8vZ2fMI5JcWprvVFESj/TJhZsXFOsGEHT
	NAg80ztZXvLeY5MymiHksBucPckbvye1Bd5JSFB/s6+LavhaYuF4DpapbxeMpY7pewDnfx
	O92x3Rj67uWT/FjCt0qUTp1MS4bupss=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KUZBH2j5;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418730; a=rsa-sha256;
	cv=none;
	b=xqAbJJkw82sZMIUpHcMwQWBFL8bTDG20ftpa//Kl3jztb7nj4IGShyjxRVyNSJ9BGtUgcO
	P9lvuR7LB8SyiGF1aha9lrSZW3LmvCbp5AsHs2m2Irv/7yUuojJ/cGW3Ebj6yK5hwVmV/J
	Vr9Pc1+vKS848Zaq5Q3FNTtPITOesbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80E9044A3B;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 407A5C2BCB7;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=zncE2hxQkprEk/co3eBc2SR0h1oYBU1WvKX4YOZi9bM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KUZBH2j5InYqZEArSttoYJSjeqs4A/ExMhyoDcp25A8Wz8G9/mSZcuLXBAodSZ1gl
	 H+1NyM1FpGLECjTF4lXRXex+qmXR7w2YczKNVE7aC5uAH6PfnOC1t8bNkI+CXxpOCb
	 IbsFwKAvIyJ3lkupbeSAizS6VBtk6uCiMgR8oc07MRuR1NoJvL/jfidW7dzpFLZk7b
	 AXsPioKlZqSzlS/QuVwy0nCbbROpVmRVh46/8byaGXZVxoJC5WUclq58cLgnkwEYD9
	 WcBTlO8VhgdYVxMSG7JJ5ALHLXHVPHnk6PjD95vSto/EySxo9zvPWfdXqUOo8IG219
	 SMnIfeS3T+BOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37697FF8877;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:19 -0700
Subject: [PATCH RFC v5 24/53] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-24-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=6631;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6I5qY356QuKhvOxH1JQe8xcoUJLrBsuBlWTdyFO/bYI=;
 b=3BKZsofxSpmgNd3PfWxQbf4StcoBe8YmYcPFtSyrf7dW6HwahUfNHnny0P0z2E9XtxJTwkPtk
 oW/xZZKZ1dNAcwDaMXpkp9YNj3ce2/puK45bRgGtx1pY7P5UFEHe9vZ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BF09100003
X-Rspamd-Server: rspam06
X-Stat-Signature: 5c7if3neox5gwgwh68u9j3ur7g3rqmuw
X-HE-Tag: 1777418729-830294
X-HE-Meta: U2FsdGVkX19qnlPOZ2p78wrwBVJsO1uNHk6vhrGbJJajyfPqiKGB/PulQrlyt1qP4rHDZvJv0OZm3y8bDQ89GFsWu+mAJ0/zXOA6gQeJiPIDs78ifZOXXtNn9CTSzCfjUYP25qBHq3WPxRqxJhluYKt1FjFw3fVsw0Uh7jpG1UPILIHAAV8CuDsZ2kAlhO58F93ZlbgCTMXPs2HDgTR0MywW9KLxgiRj2gqQli0EE7K4APVhlOmE0COT2m/lm33sUeu4y607U+Bgg5bFR4FU5APOak/U+Hb6msZi9y6FJn0S8Ibyjfk2ZyAwmxBnA9WvjoL2PZmSJDfY+OteFoKkXKufzUQHOUqJOjml+kENZ2MgUBwVDcVqghTN/dIlVzJkrRagsTZpmaYoSXPzxdzc53MmPAQpiyTaN/SlmzP77Y9ozaeiB7yc2syW8qrqz2PIR0+GGa5fPJxpNwhVYGCC4W1W3F5D7EAeFYiQUtMjXIDNL+fmKIZeLa0OqeSgZu0B+vDmuaxy27hrugw0CumHeYU098A6kjM/zJ6QQYLRHdmP6ukiVbIR5e9kSXbuHjR6BPnWsMRxADG1PvDwXgBSfW+SNWWSDZ/OsxNpf+SUI+thCF8hVvLMrnY+w6qD76JT7FPVFPXcDuMNo6+GZWOW4P0+y/G34agARIxtBjn3U1vzWMeNmUAcGhA3JIYTGHAR53//CDoUOy+fPa5NPRXKcQ/jjlCT3YP4yCkgQtwDRETfR7Mtxk1Law06MwBG/+AQYhdVViWO6FR3qx4i3FbPXKStAIV6By6ZpdJ0OApYQJ/U2VEV/h5l+I5kh4oSL96isOjeSwcCyB9Zuex1pR517rwSiOHmsuTN1ovE8+U4MO3nR5sRWe8JL6EuqJJCX43Vm0YNoox9gHJL7PP9NMdk7dB2fXWZLYXcrHdIwpK7Kzex3gjEdnaBjUaDbqFNvhR0TwRo0vCUo/N70YCehM8
 MHdsNRQY
 RF3xBZ1RQZsRyCBCGYOW7/S4y2tLCSBDJ3mHl1Ef9f/luz1D2yCMmijv6iPxRPAGdMcRWRlb4sJaZS/phi2yf27mI6Dt7pkpLpArIQhEPOlUhj90Hl0Cjfh0XeD2nw609rasAHuVGEAZ/Xf+Oskgmwh7ajBFP9aRb0lg6a1fU9A8THt7TzeFafGjJL0wyk5P1wTzdJ2u1/5N8P5mmLUN/simQuMb9lYGMhLdbnR1swNrTqU6HIoyjsbReWY0y0X7CDqK5ugz7ac3BwJsAHgSqq21njYHflmXkRLD7yKw/aJEQdPPwQ+PdWeUt33yGm1udo6KCO86JikHqc5WW9JVmsEv8IT6qYafFwshSlkD3EUfOm2n3dQhxA1g9sCswlEdCrBDZ/yUH8pcX3T0cqjgZI8yByKMwXTOCGG23g5IpRTXAHHNTshHW9mmWbTr95YyDRDXN637yvh4ZtXf4gY5uBvoqKJur0gdpyx3f5Ad1P7e6DmM=
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
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 19 +++++++++++++++----
 arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
 virt/kvm/kvm_main.c                                  |  1 +
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index b2395dd4769de..3b9f36a55a95b 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -503,7 +503,12 @@ secrets.
 
 It is required that the GPA ranges initialized by this command have had the
 KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
-for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
+this aspect. If running with kvm.vm_memory_attributes=0 (to allow for
+guest_memfd to handle memory attributes and allow for in-place conversion of
+pages between shared/private), the 'PRESERVED' flag/content mode (which is
+only available via the KVM_SET_MEMORY_ATTRIBUTES2 interface) must be used
+when setting the range to private prior to issuing this ioctl.
 
 Upon success, this command is not guaranteed to have processed the entire
 range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
@@ -511,9 +516,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
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
+kvm.vm_memory_attributes=0 and optional if kvm.vm_memory_attributes=1, since
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
2.54.0.545.g6539524ca2-goog



