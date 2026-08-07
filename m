Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D07C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E052C6B00A5; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24996B00AA; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C385C6B00AC; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 911D86B00A5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2D904005F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
X-FDA: 85075823784.20.5CDC547
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0032940003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D193Nm1K;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139571;
	b=x5N1yGbwj7ei7w8aVvGs76kTjzh76GlZbKoBezcuGcPYj3MuV5EN5jPOUc1YOjN4sjvyC4
	+CRouWYal+ycsb4yMjAXPNhMDCiDmejmJ6fLzO1tO+CVrzOOiJdRp8YbhcSIUuat/zW5Ei
	aO7EzqFm+m1HSW7i738hHNyAOVZ1Ir4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D193Nm1K;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PQ0puH8MGPi14GRW9Uw4LspurGVNNeyCO3+CjYIJm0=;
	b=3bVhGimyBM+/SFHOT0HsaYyia0CUsINavnaoeEX3YUPih7LC/izGy62qsBTNbjKa3qJtzC
	y+0M7sdiXwM8f9E8u5winBXp6W3SsjPngEQic8KPWih4O3JC0HOuvyY9He2bdPrLTnYoIg
	rShCdG3EPHT7jX+wKphij1MCv1w/lRU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B7043DF2;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47122C4AF55;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=uI91Yewbkf+Mkw4PYrkVUsL5tNVKDc9QB0xaPQu5GMU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=D193Nm1K77USjqqEfj9Z4y0RWpxu6gOFevMfkKCa6iJpcIZ5hY/Hi0ikY1CBS9asF
	 /8jK83cFG+CSwHunIHDHvGDgDCLbXRpDjfJQUK+8+rRZOpODp6UZGhUZVZzH8w0gcZ
	 xAbM5SNtGxT1HMw2ZlT5kkqQSrPQo5r/SEI85Qb8Op8xH2JMPH5hamkfo9lGCihjA3
	 F/D1o7fwqmiXY1I0unnV90JKzXEiRhkReDEno4i1kkuc9p4JUMHXWlslFYcc7ZmuE7
	 42hT6MNC+e8fiBeTXuSIz6bBxXczn/KS2zzdZvPRZHnRZymU2o9xVEnWCnfAK0ebsR
	 wA8BT8x/rdjUw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8E1C5ACAB;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:45 -0700
Subject: [PATCH v10 06/41] KVM: Provide generic interface for checking
 memory private/shared status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-6-2fc18ee6d3ba@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139564; l=3207;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tXmTU53UAzCKCqiruNWMK+ptv3ayxg/pSi3V0XXYtxc=;
 b=z5CpksCk8raj6CBDraRTpqXZPGIP90pBjTwW4L9SU1f/B5Z+N8ACkkCgv6UAKJAsNfqQUg4j3
 cGPMWEfZeFABf/uMelDu+hsoaBtRe32LfvkbrAecRj8ak7vwbMR3p5X
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 0032940003
X-Stat-Signature: mx6zugw1s5ang4edhxs9sb1mxjd9x9gr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786139570-395847
X-HE-Meta: U2FsdGVkX1+lbf+tbTJZcKcavi/5SQ/hawxs2+ziOfudQvszOoGziLF9R//bZuXXwYB0idc1Fe7nXoQWywgI9Q+DixQGi6BuyXIUPFbdYenhoU9CS3hsrJbK/sAtTg2bCU+pgVfnXhbbS25UiKbAzLW8o4XvdJpS7IKBtFEMXDZGocwIdgw3kzo/2L1F3Vu8dHCSBaTRbXYb9LCiyAQ4LwtQ4RcKLyD9ZJpJ9RF9ZO3hcnDkfKiWfXCZ/3j1FL2cAL4KU1b6HJUyx7IZDkelbT0HcMS+Qxs7nA11CYX8nQJCgYJDYEqZb5pHx9Xn8aLGKA3Q58bHx458wR5FMwNirw8wr+8+YureMCkKI6ATjj6VPvXLHPoN0vQrWtP1LgDzpYuvCq87CKWlxWhohgfJDYnhlZOAQRnldSmEb77NaZLDkL4bjUtIlydl4Pi/TCAQwxOl5C59fgqpDYP7oF7PWb1sL34kxLGjhBgf4gt+EhZwehqQH65Ym5usZdUUVDNKOinXhqMFoW3eNN9Ki5uvzdV7jK2oqS6zhkRC+3NHWiphkta8Nvn7fCLg422NiEMMDRZSYIcbb5+alVKBgrOLfeDG3Bx6/TTSMht+OxYktaDFuxjcfy/K0lU22r56lTG3JlbMrX6sLhT+fLrKT9a2nrvT9DaQ+O0ujLRNm7F0wClTqeJM0lofUt4cD9Ov420YrkZeNEW+V9zKS0lZRg2u0gFfDo0OZxkLb/X2SNpIW5Z25gVbSqwOcw+ldZ0bYytERIYaZgfWH6Raa+VvqJk6Mm3nQSf1+ttxGkdgAaZ7rv1X3gHUVY0XOZBb+njKmb5SnM0KUA1DpsGWTc7+gSe7PRPO9irABKgypBEZVKqZEy+7KPRkCUkpZGpIH0edxs8gZmhzbKu2YSWxvhMHqxYRs9bwPEVH1+eYQJAOtGEnaSOPejl/GQz2dGmPsDQyiNXneS/VFQfKYTLQqZCbgCH
 4ZGbchVj
 D4Y8gWv7rQ9m+MDI8NjxvY8Tk8F774OYPkAvB0RmY8Sq42PtELF+P9416GehKxrGdUsiICPd5os9vHBBn8MDwcGGrDCO2yMrpluN8DBx3zwZ2OEANO3L8mtDNExtixOob9BHJHfIZlodFslMhrkvtVjGsPc+lTd6yia2l47y7tfJp8eMWHvi7B+H3iokZDC6us+nKrIM9IKjCaNPx8lyKTS1iFBuTDS33zsk/dDAfYTO+fo/nBbI0/x/KY+hneUj7br8I5qFOcD4vQeCS0wE4g4EaLFmiW77JhA2JA0ABh5kjGDwxLUyUN6R/JVWCRniUmJHUhZuVLyeHtlIyTgDFenQd16Nj7x4agLu493+JGMfBczB6c2BkQMjsioTRVMDqurw5tzSqCRNsXieyLFbY99MnAvp/h7eBgzemTCseqQqaolhV4N52r3ndnpW6zl7Y0UAAkAFkaVMhRfHEiribhLMJ8zKNWyQPgOzTEY5434DiJ9ErKi1JQ1fTrTZi0nMR6jBVfECNNxzo5e1TR9vJxOn9IFzciJq5drh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce a generic kvm_mem_is_private() interface using a static call to
determine if a GFN is private. This allows the implementation for checking
a GFN's private/shared status to be set at runtime.

In preparation for choosing implementations between a guest_memfd lookup
and the existing VM attribute lookup, rename the existing
VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
looks up VM attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++--
 virt/kvm/kvm_main.c      | 15 +++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3464a0ddbae74..65fbce46b63f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2573,16 +2573,26 @@ bool kvm_arch_pre_set_vm_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_vm_memory_attributes(struct kvm *kvm,
 					    struct kvm_gfn_range *range);
 
-static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
+#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+
+#ifdef kvm_arch_has_private_mem
+typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
+
+static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	return static_call(__kvm_mem_is_private)(kvm, gfn);
+}
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
-#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+#endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b3f9396123be2..a01d336eab18b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2628,6 +2628,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+#ifdef kvm_arch_has_private_mem
+DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
+EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
+
+static void kvm_init_memory_attributes(void)
+{
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
+#endif
+}
+#else
+static void kvm_init_memory_attributes(void) { }
+#endif
+
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
@@ -6547,6 +6561,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();

-- 
2.55.0.654.g21b8a5bc05-goog



