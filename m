Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80EBC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA346B00BA; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1F4F6B00B3; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72686B00B9; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EED96B00B5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37D611401DB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
X-FDA: 85075823868.14.259B2EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 317014000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJxf7rF4;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139572;
	b=bWI4U3WieUjKki+vQX+QWz8gn5aZUGaiAv9sd90SKm38vZuFq+GOXoKMDpQFotO+3akfHr
	fK4bLyq+1DCZLVEypTwOHLIViXpgB0vpd0tlfn/naMjVPODJT1mUAxBEwzb7mRQO0bbXmU
	8UvNsx8lcWwbsikGYhK0+d0UKfIhuSY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJxf7rF4;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hLAdMBokqQ221hQIaf0GQKNpcEiA5GPQxu71lqR7Bk=;
	b=Y6Gp8JMQ7U9jQCauOU+urPe0cQyPNC/174Isw5ByKh978+cbwD/lyuk/dG8HBnG/Dr01aG
	dsqpg2UREDN2wdP/Sij7MEqZpDRjlcqYEnrEAPpK4FuiXKmPrplleXv7/eCX7Dfs3Lyb6c
	D3+L6LsJq+IEhvGhWNdAwjJtGO18noY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E429044FF2;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E351C2BCC7;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=R28ZEIBAzL55bIZ0Jfb2Dv5F59rVFGvixvPDAxwkpYE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gJxf7rF4QQgoi2wUBUXO07as85mWqVIidSadVmC0eHXDaMcgDktxcVMi8Qfe7KrlO
	 5kr2s12ePf4GDC2Y2sssMuWmWyRkX9x8Eq8vBFLQPt0YRRGz6XlsLWgfcKNgQ1t5/4
	 RkYZ865In/RYwQFA4uHXM8fdzGNIgef6JCY1HNks6w080B7YxiaTNi3etByORrEXd2
	 Sm6Z+fSkUHNPVFoG4uyGQqAcS4GfSJv1ulEvLsai2Nmrf4LFdX2a58gL2RFvC9qHTp
	 2GChyeIOtEd0MbnmJmbQBvwwRrEvZhpaxlgF5V37l2bZVOkJgbPCcY3yiIChnz/nhe
	 KtXUU8oVbpriA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44301C5ACD1;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:46 -0700
Subject: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=4469;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WLHFPoezUAm21n5cIFWjuAvOHkt2CQoZ0rZKzRZuazc=;
 b=ZDOH0/Oj5SJ3cr7plA8V5KsJ2F57SIEEItjUXWHMqaX8nEorDWE/Syxgz2w0EEtbnfoa9n15i
 Z4Jw6LnCohfCvMN0mc4oVdHsVk2dT8aCyEXPTbtZygtHYC2VjIp2QOD
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 317014000B
X-Stat-Signature: py8b868g8cehihzd7xeq1qzg93y8h4ng
X-Rspam-User: 
X-HE-Tag: 1786139572-139706
X-HE-Meta: U2FsdGVkX18AvZqs35eOjM7C1W5sP6UpApeAotbb2h9uoKJd7GrVoV5+/rzaFJozCqHM4qAbb1rfCbz60Fc5Ix/rWoQTX8cXViU2CwLnYPmw0yuUp6hbstjwf2k+bpDsXE4EmUSE7H5qf7tgqn+lgL1vXkVZOikroopEV9uRlTEXXYHZvSHxtmUEiqLDbEA78AOOjICmaBGV1TC7dCZU0P4Zv9mQxOtweYIDp5xFSVSAVjiboh7bruxY1xdwTOBt1VzXHXhyLbQkP4Xym/lGhbt2LR9/v4AtJdI9s6SP+qI8peiY3fcI93DcB1iZU5rwRXOdkDlU5Uh8oaHLBcTUaNKvEmHobpzuQvMGi6kjLOSvbYVysgzU/jCGRKOsaPqdV/ZBhsF5dNbp0oN1mzsCMt1H5ghUD0yUpv4LjgdxpnsCcvwKsQSy5Mogfb9txVr75FQnSmFtu49ruCh5Hn6d6YsMp+UleQAC9gPtZBibcBW1WF5lafBMIIpeTteV1VG3YaCYvmU3bgHgbYLG7Xa2yrAMriOe0ESNjJntAvpokfjo0Ca4VHM6rY1dlpb5zlViAbLXUuyMz7uTwt8dtBMJyiOtKSDX41uTqWgsoD+3TJa1OBI2v7yRX3kObJphJj/WQN7vK7Tg7DCtiYbFmg2kCLBNMiibVnSEppAIosDvU7wtOcplGZkNIwCRLMMH0l290NrKQaV8K80yhZCyAYfVGtnND1Qy8Aalcs41kIUkD0sSNsCssIgkPhNgfalAhGN+3WptnpQWAs/GshLefIlDQaorbGecMdYpJwoswifvlOOTBz471olijphRhXmK+X4BshqDNvTiASqJn8xwv+DUwDB9y4/9m/cRjx2EK0hUaL7/t02O6Dnb1K1ZrOYU0tQPOrWJ/8cgjsy4Y/aBgjb5Txt8m6y/Wj+Fvy4/3vdUr7LMzFWetGx+dxPmCmnRsCMmE3mmrWjbyZ3dZ/+g8/u
 kpPhjD1u
 h66G1HC8KHYSj1W42SsxM6fWAhKls7K7P38vqsF7XQFxBo2H2Hrv9Z2BdoWB2ikWuc4sDNt4bKUE761d9ZQ8yWYOlfMNsY1paEEpo361IzPyh/FIWPC1sZtEctzmf53tUDRXiAXVcYvO6qhph2mGRh0kBTegbmS7WlE8KwZjZUc7okPsBoYMwaW0PhKBUwaBfhJURT3f9uQ1WIYmjF3DfoPdkTesVso5LLHKYDpMTTgsL5rbD+3GkBWV48Jhpwvbv372Xz6P+vUNtLgkQVkZhHuN//KpQOx6WppwhaWvZGOnUK/vemxEsqRl0HttPBPJz1FU3nEZMYglr5rkHRJSE04d9TpJImZHX9N8pi6WopEKXh2uROpZdm4muHmYr0RrZT2gBt7JhlWzOcqYjyP6OnpLqNbfi2teEPsmb+wHe3KzTUWTK9Pe136efnH0tayniSPlV2+s8Q14ZxE6pAne/6SK6TnlXVnvFFw9zX4vGuedn7evgIgvilJJidXedHNAVuuImUohrn9tqzV6P0q0FEAyFQVbc3DUSrujEhUshT+LBPcauuiuf1ZrToA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Stub in global variable to enable in-place guest_memfd private<=>shared
memory conversion, which will eventually be exposed to userspace via a
module param, and wire up the __kvm_mem_is_private() static call to the
guest_memfd version when in-place conversion is enabled, i.e. when gmem is
the sole authority on private vs. shared memory.

Cc: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   | 26 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 12 +++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 65fbce46b63f4..9477ecebbbced 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
 
@@ -2588,6 +2590,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_mem_is_private)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2595,6 +2599,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1f1ae61b4878b..75979c885e030 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -475,6 +475,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Rely on the maple tree's internal RCU lock to ensure a stable result.
+	 * This result can become stale as soon as the lock is dropped, so the
+	 * caller _must_ protect consumption of private vs. shared either by
+	 * holding guest_memfd's invalidate lock for the entire duration, or by
+	 * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against concurrent attribute updates.
+	 */
+	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a01d336eab18b..0a5a1bee8de0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2423,6 +2427,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
 
 static void kvm_init_memory_attributes(void)
 {
+	if (gmem_in_place_conversion)
+		static_call_update(__kvm_mem_is_private, kvm_gmem_is_private);
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
+	else
+		static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
 #endif
 }
 #else

-- 
2.55.0.654.g21b8a5bc05-goog



