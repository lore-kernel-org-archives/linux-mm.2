Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02329CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAD36B0095; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236CF6B009D; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD396B009F; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBA1B6B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AD5916601D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
X-FDA: 84894784422.12.8AD0498
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E06C40002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7AupsXW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829109;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANmgXmWCGQ6RNsoVvWswLiuOotxg7NR5lu88EJ3Oh+0=;
	b=xRKno11XV93En46milq5JJ7fSBaby1djZRZ+WQgiP+GsNnsoHzqu7sZ/yTp6i/OlWli2NK
	607U2QOKnpcn3b1kq8GEMG5hLUJh40wOGrLYRYe7ixH8YtTeRnCAUy+dplvAZyj1Xzeglo
	2TjUBw5RMWmc5UWA68Zggo/cBNiSJ3A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7AupsXW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829109;
	b=LD85O0cidDah1jp9tlKmB0lCH+xodwSKnw9vDyjaNmnLMqgmgrRZDGYRnMslyViVlmJFV1
	NjYSFq4qWXAN8HX6hN4tDXAc2v5GLzQ9oIYnE8xAPpBQI9Zq92NVdM2bHyTzdA05C08opM
	+g1Ww2R4mzelcwfbNfrbBmtqJKR5/AI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D50C60215;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF89FC4AF53;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=05np0kXD+1HBAH7Gncn5wqrhYUmgbGkv7Y+NsUcBfHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=X7AupsXW60gtNP2MQTOW4/73lQ1R/RPs6lrpd/fY0ph7LpBxzJSmYHJxGVicT0Rio
	 v678ZF47iEIKkj9gwsncmfUqBjccrqjwJIsvxrjyMmItve3uIox/1ZjWVIyckOL4wh
	 3q+5d6zpHuBuahIj2ViK/tO/vwWvhA0r2gmkfYrQudCABulqX2V12mhSDiNSNGZHxg
	 GyrFtiwRPf83bwN7OfOq58w3z0dCVKExnwFpf2fnvf03gZ+hs7rSNsyQGCnb+RtbPX
	 xwb5lf1yb/J4r7PN6ej+U0rpwL4c6sxfFA+rSSxdGNpjdmIu4Ify7kHIYvEsgPgfZ2
	 j29b7rCTcc2+Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ACFCD98FE;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:47 -0700
Subject: [PATCH v8 10/46] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=4770;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fOfywxdTO/Whh+2RzVAHLLfy1oRrTLQnZ+x+DH1XTyQ=;
 b=aaYGk9KsmcaKJOqUgBq9hpVZyNGJXy22b6TtABP59Y1iKXqmq3CHRYIz1a8ITgKIMdzMR+tZ6
 4SbI1OwN+YYCBGfJ6ejj9djCaIeXmuq2/AJHq3RfZgvSqrBwIfRZqXd
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4E06C40002
X-Stat-Signature: c4rofrbnrgmrrb7do557ipqt953arobe
X-Rspam-User: 
X-HE-Tag: 1781829109-569244
X-HE-Meta: U2FsdGVkX18wf7VAG1d0vkqMMVJRoYgpy3X8g+CfTmhVlGjDdpRJXx3ev5IrQMOSgwIJiyuPlL3eBrch6T7FYpbwteQ5mcdXIIAwLOAkva9/fdF9+3JSI9pfqkyc4XxDNaf9iRJr8WBfwa6VGBkIi51ac+GDGOkwZmw7DCbozFEvSpmp/OIc3luInlwcuiRc8qHzAXp/LiNoeBrm41/wwagWCOqTBuleoeM3uAS0fDF4+YaPVh14Rdtx4TNxa7iZJRS9kzkqQqv22WM7DbGgqoN5yRkCVQt5vJxRmUQ99A5bfaoN+1cCxpX8LviPHh/W/NUU1mvq7Fe3OYBDOzKDkv+Pqk/tUeTUIlCK1DxUC/WOEVzzp2TTtPKRgpvyR192Lt+8vQZQJjSu/dFcpVviuc+rAqw4bX5cdv8hr8ZivnrPGJbLc+suUMB6ryGhnBDpdqblVrFoxXMmT19QiSv1S2/2dUs1ji4cYayrBWK1X81V7ZyzQol7dgF9JGC1qdF7e5oLi3fFKzKARd/H22+JVTfhVEMi2F5SDQfRFnS2uyxXolaq4RhF4X/acniTq44+YfLq8XBhJ3dkXhkr5J0CWdjuZhsaAUziVfSgRra6aGqvRDrMuvyIVoFXFmBtS/nopX8G8XbLIVLA8Tka2moyWQ6kbm+MHmUhaIOsvI1ZufzkBozfEJCzOkU2I9Ys/+NWmqz0LTSij3MJKlJ7CMirSJWUY7aOlO15ZhJxa2Xw2zNjmhQEa0BCInHc3WHS3iMvNKtt2a5iVDIKV0MvPqqLwiN7UXQOLhy8qFIe7nnha1Lq2ZAVKAJTQ/FQn0WIrRnLVsayZVFt3JlVMZCRRLo0ojbWlCtUfhH9LW62ukp+xu8YxxBDKU9O5+J7Ffsk/ziV38dnpHw2A3jkgZ7w1cd+GeAxdmwy3Wan9ddZptWOXnxZeTeXw3uL3zSoLgoj+UK2mmWELjNEfpLSvAa2KBe
 QZ+DtQhw
 g2hHMS0TbhY3GY9BDxaUr0yC5nZkJ4zmX3hx6vm+cSIxZQwVkE/T7b4uR0ROf3gHE0aMkg07pxYRhe4J09ow0jd4n5m/Be4C7ER9RcwXvTVOofbpEnv4QWFBCba+szLEv+GxeNazPcd5AtDGfjM2mQNGyqz2PupwcWo8t31vjpZeaw5Zb3afp0xpscI7b56NEzJnnCM6DKyvj8Cs8POnCp+94+N6Y8GboA6UqqwuDlyCGIKkNlBVQjAsP340gtfldJrmNblZdK0pwuIiBm2eesrN9V58JqMxplXJsUm5M7jDAVkIqezxC6qS1sYjmn4o0GGGj7w5nKF1kReL3Vnh0onxVDjVXQneT4bG7MWUgbRzvgh4XdOgtWKPflHyz0A6CS3kaU0Y4GEAnU3Xf0YP+yMGtnXYKE3RLrzFqeE7vB0TK22xpwk1knH7iuntS8FOxSFhoAca9OEEe7YyMwPtfqcaz1pXgg/ONcTGaQp+UG/2SpXEx43Z9Czec/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

With in-place conversion, guest_memfd is able to track the private/shared
status of memory. Use a global flag to toggle between tracking
private/shared status per-vm or within guest_memfd.

When queried for supported vm memory attributes, return 0 if attributes are
tracked in guest_memfd.

When querying for memory attributes over a range, look up memory attributes
based on the flag's state at query time.

For per-GFN memory attribute queries, choosing an implementation (VM or
guest_memfd lookup) at KVM load time.

The flag is always false for now and will be made toggle-able after all
in-place conversion features are added in subsequent patches.

If/since the flag is false, if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is also not
selected, the per-GFN memory attribute query defaults to returning
0 (false/not private).

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  4 ++++
 virt/kvm/guest_memfd.c   | 22 +++++++++++++++++++---
 virt/kvm/kvm_main.c      | 12 +++++++++++-
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27687fb9d5201..acb552745b428 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2560,6 +2560,8 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
 #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef kvm_arch_has_private_mem
+extern bool gmem_in_place_conversion;
+
 typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
 
@@ -2568,6 +2570,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return static_call(__kvm_mem_is_private)(kvm, gfn);
 }
 #else
+#define gmem_in_place_conversion false
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index bca912db5be6e..e0e544ef47d69 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -926,6 +926,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
+				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	if (!gmem_in_place_conversion)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
+							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+	return true;
+}
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				struct file *file, gfn_t gfn, struct page *src_page,
@@ -946,9 +964,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE,
-						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_gmem_range_is_private(file, index, 1, kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b238e461b854..01761f6e25d25 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef kvm_arch_has_private_mem
+bool __ro_after_init gmem_in_place_conversion = false;
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2422,6 +2426,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
+	if (gmem_in_place_conversion)
+		return 0;
+
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 #endif
@@ -2633,8 +2640,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
 
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



