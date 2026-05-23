Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5B5CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D986B00B5; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07876B00B8; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B594F6B00B7; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96FF16B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 648FF140870
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:15 +0000 (UTC)
X-FDA: 84796772550.27.795CBCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6AD60120006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBZMtnFe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495493;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRnm7geYtBWQeVdU2nvQXkHlzfADT/KZT3w6PuSoJ0Y=;
	b=XL2Wboui82osd7VfiKhkBDJZi25ZazyT8jC5kXixrLYx8rXtuRtMZ5CBrUZfhXeHmLU590
	OTKEyQv+zyD85CEo2tcVvNapAnpbTnP2wnjICFJl/gnLqQoMdOZblGZFSK/63KG37SImxn
	75pxPXMmTaaOmFWgze8xwNvVQEAY2ZQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBZMtnFe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495493; a=rsa-sha256;
	cv=none;
	b=izN7x4mQY8mP+tEsSmjD1f2N7r+2ECtHXP+nFryan8UXY4mS+a+VcL4bWZbaZsa5+eUmAL
	IYJW40FkvVDf4HFy58aR9fF5OP+Zh8VABbCxNlXpnuavRepiyiAGtw5BCMJYiyawXixxmc
	h6KGGxbXb1onpD17PpLjKGRyH9VUJ2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B965544715;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08057C4AF1D;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=q1TvKUXLpZ7c+FJYy1fyUdapwsHbnbeLjFg7uBZUd6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jBZMtnFerc8Tnt4uY8DmONhsmTr7E3ub9SfkRvRlucDVvHDMMM6vFfdUH/Pos/M4n
	 ufqxNXcNLsNRgGwZIQfs/G4yBeAU2sBea0UlT6F35uJ3zDyIFPmBqjVBgLtvqXsmgQ
	 YqEk88KcDqeQeVBMfX9JnWPruruFqS/0cjn7FniPCrOjVcqZxrn5rboQtOiJE2EJPL
	 7CLXqRLMp3Zy3oIRL8m6BUZz9RujP7NG1HS7FIme6XN0dasghdmY09Al6Fj1Louphh
	 i2on3LVqap7COrEYD8iH60X9nzsGRjaTN53tBAuVLF+NYiX5p3c/LY7KdozVfvVPng
	 jNYUB2HBi4ERQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2835CD5BBE;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:02 -0700
Subject: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=6272;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1z1e5dw0ipQOWYotUI6qJTF/Qax5RdezF1fw9/+GyHU=;
 b=D1iHhLcye2MaJRbwv277OP2Di2MuAwSNxBJzzAqyZCjkriRxg8Nmapg8uTSl7FLQpbpc55mN9
 rartzC2OisYBI5eS1TAszTDdtQ0x4QG9yPN2FUH2mrVyqi4Wggom0y3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: d1awkrb8ym88oy44dcir73h1z6sd74pr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6AD60120006
X-Rspam-User: 
X-HE-Tag: 1779495493-248682
X-HE-Meta: U2FsdGVkX1+Lvz04F/Q4YvNTu3ULXzqvatNN+GBpGFRUhHjXgUAIXu1d2nxrRjkY3xVJwSA+E/B69/78tPb4QjXbKcxtIkeyMx01wAIBD4L+eMno5ctixqqqdlzPwbTx5IIOFsBT6+aCmUU4d8o/mvymIPeqkM6vH0h/0FuFinCvPPwgFxTKXqh+LoZArGv+P4jtCtsvVZz5TIaxZkBMCjuDEumX0mg/nuXJERYyfFB02q7t9xqsdlO3QftIM2TiggyOYvdzqAWbtTRx+/Icv/X9UdteIIseAvm0rqBMHP1LzO7GKAX9uAtUiY6i6LV9eHli/bWB++HwVFb+cD7gsU9DIqZGeLuQLpYpWQ2o3wpn29kN3dPOsN1895FiIbPcCzDKucg2IlERlV6HbZ19RceqH1IUCyQ9RKO8oesuzW9Sgh2RkwS2p3q9nZTOlqGzCQzfV/5kah2NPxDHXdw4CPAlp3f/QFXQDfcDo5rBHQ+L0a34MYAC3vuBtJN8b+K1GpVyWfsWT79pwerl2IoZHwFHPyLgnSgQ9GuTrdv9RkHtsZLko4yPSc1KcuKDceHpyof9FJi559peVDFXmU8aLkJ9BMAkB+AX4t+RDPLlqjENPkKog07DNxqhGUX3Rw5VLR7Hm5ZoemcWGz32vSb8hG0f7XFQKqavCSmUEIwXKteFIta/+zww1m/YvrCHAGhP6mPpfqobMfGMrwWGjoh3Y6+xZeNcNSWoIcvSr/Mf5UemF76R0okKKHXIOPH/tOk3v4i2p82wk5mABbs6z3DS5ytE9VdN/UrOfuve6w3vpGKlYc7u6tcHNaB9ecMT2o5IVGPIG6kISk6sWoQKTs5VYn6IKG/ZOuNuwn+Mii/i4BbkP8Ta3pT5Pxa67H5oQmuimIl9a8BAd0Rrp5nWXj5TRS95LBA3Sqn1nlkZeLqV8VOU3DJPZyeP71sUIf2f66fHOcNMaLeQSnJmtyK8YAF
 of8H1+cZ
 hbMTRNtIVxjjvRavYKMSb9K9GAh22qhg7hCRrvJAow+F4gmTPjiZtb8zqJ6/WNk2wWZV9ZQcKOFxtd3IP+yIDKQYYOPIeKHtc0S5xwgB5P3qtzQs6ycO4+BDaFr5nYTTOQCIIWNyqiP4Hzq9d3tcCVQXfEzOF99iHlEkv+fCbOjORy38NB+XS9w4ID7PdKzxM51F4kK3hEsi8b9GmkN8dSkNML0lSezXFv7qOAIFwAo+A9Jg4GhgkwvO8X3lCyf9FXwsR/j5HAalVpHi8QJLwzhMvt9+Tl89EbRq7dhfk8siDL75HDjE38Nf0IHyeZInF2DO4dc6/nnUyxLeIq1IbG+OnTv1Fk1mqiCHOBfND7dNhJ1ydPcNtn3bMarFFwgcoi6xWgsTNb1l14iq2OyWpM4V3EjpMUGJI8zbCwK2FFiMH6aOTuyTGQIcpNmCvLi10qcIvIyNQwBBjVovLvrjN4I/wp8TwXvVea20hQz/kxZfVuwk=
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
index 1a361f08c7a3d..e1dbc827c2807 100644
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
 
@@ -2423,8 +2431,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2481,7 +2489,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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
2.54.0.794.g4f17f83d09-goog



