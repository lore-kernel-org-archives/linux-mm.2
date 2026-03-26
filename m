Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BAD10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D596B0096; Thu, 26 Mar 2026 18:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D756B0098; Thu, 26 Mar 2026 18:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD716B0099; Thu, 26 Mar 2026 18:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B42E6B0096
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63A6BBE2E9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:40 +0000 (UTC)
X-FDA: 84589644720.06.CFD42B3
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7777B40008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qF9c7Jsw;
	spf=pass (imf11.hostedemail.com: domain of 3JLLFaQsKCPMVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3JLLFaQsKCPMVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L64Ei+w9HuDhN4D3+e2YG8ZNRPlnX30IypUuq/5FXOw=;
	b=hRCjSp5E1XGCPmhkdJ/OoQJaBMkaRsstePfnoCfuCUwedqniI6yvO39xeVf4rApbir7wy/
	o4FBxTF9QuJuLAm0yRAAqgHLa6vNm7DkD2o17ke3W5q1vlKSKMOSCx4GiWD/25HJHKvpiJ
	yw4KWp33cTfFu/vxP7t3AF8IAgyppZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563878; a=rsa-sha256;
	cv=none;
	b=nAa9i6fMhLyBSHPpxzWji8J26ST0bdtnMWy4Ri/hwNYBtBLAKbxBDvYfYyxep3pyu87QYy
	JEfC5Opq/z+xJQF3H0LEvvw7Q1yyzfG6Yn+Fywk8lghQYJqt23XbE/cRw6IK4GiqcUzHq6
	68Opv9zv0gX7JMDdk6vNPuNOjzxJ2cw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qF9c7Jsw;
	spf=pass (imf11.hostedemail.com: domain of 3JLLFaQsKCPMVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3JLLFaQsKCPMVXfZmgZtoibbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3595485abbbso2073545a91.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563877; x=1775168677; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L64Ei+w9HuDhN4D3+e2YG8ZNRPlnX30IypUuq/5FXOw=;
        b=qF9c7JswH4t7w3uU67q7agwbWPM6cBrEGTHStsWZYQw64q4LSgiiKGpFlc4hzFB7mB
         /KH4dlrYFIsNFMVs1BRw3rkkxfLy1vVOfHmkX4PzA/PTYLy4vgLG1mrUmTOCpAm0YLnq
         bUUJN1Syi3evSh6tLfGxDuGZBUBD+SrFONeDKA8OwHdprJpzA/GQ0ScB9iMwe+rwVZmN
         3sPGL5pR82k15nmi1PaUedkNl3pTVAEef7nAXPmYGuHgamBsv5QFWMk3JocddRlbCFsz
         01zhnF8VY9lVakID/1JLJS5CodX71CR/XxKfIArWeHfH98uAv4CvwYTSDLGBUP664yzm
         YtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563877; x=1775168677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L64Ei+w9HuDhN4D3+e2YG8ZNRPlnX30IypUuq/5FXOw=;
        b=CN2mPs78SPC9L650UEl5OC7CSBMC4O6lBjb4xWYFqAd+yohagN4k5PZHy7zdsZdGk1
         bKghSCNkJ4x3GolbTUllKNqxfmJrLc2xKP+v35dLm6aagK9P+8dGMhMeUAyTHKG2EIMH
         Yys2+dM8nEH7z1l8musH8g48ogvO8Pcq9SzrlY84ooQvCgrT5zJ9myckdR6GYeoVVcZr
         Cayf8Vcjnoe5kAALmRzBFHuOWe5DKGV0m+kwN/taIQBnIxe6ptO5W8EblXOLeTApiIF6
         Y8z32D0i8/pGeKO5brt9lvo83yOQKTtg6QqU5o9Zb/91fn73mUoNRS5jRA1Biof/7MVF
         aEAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIQeHL82aXa2e0mQ5VFj7hJIqRXtM5o//7Rqn/3rrwk1fbsLjTgpO1FUlQnoYwp33QJsKhgP2LYg==@kvack.org
X-Gm-Message-State: AOJu0YzMchEp1/vXi9QqTK6vA824HO2j5WV6Ttd4HzH2fSw5Zk8a1Ngc
	jTBYvztNHdIR3bBH0LTb2uK7zbnd0Ea9OyHHOpwqz0RAdgB2w2ToeiTXmNoYCuKd5dbDZ78iLMa
	RxYwNkh9kKJ9fl9M28cdYCv+g2w==
X-Received: from pgbcr6.prod.google.com ([2002:a05:6a02:4106:b0:c73:c1e2:84e7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:431d:b0:38d:ee4a:e82f with SMTP id adf61e73a8af0-39c87c4aed6mr312128637.63.1774563876758;
 Thu, 26 Mar 2026 15:24:36 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:15 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5802;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=vymNc3F4VBBGneenNd8IucPbAr1SdMuDYSLrejXwwUQ=; b=1LWUYI7gs645uKY5pvp+JN0SJPLpfIcJb5vTHCCN4uONoDtA/ZkQwB57ZGcilNgQcL6dc3IRn
 laHi/lbCytrCWoczD6QHAkpcw7DrsnR7zLOahw4n2P3/9JSmm1eBIJs
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-6-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 06/44] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: raa1pjfysy7grqgsd7wjw5hgzehymqkq
X-Rspamd-Queue-Id: 7777B40008
X-Rspam-User: 
X-HE-Tag: 1774563878-829848
X-HE-Meta: U2FsdGVkX19dYfrfHPj2EzlPoRsu88t+U5a/oFg4fUp6xIe+EOAaue1RGtzATk87EiKegR/DVOpnovQ6Z8sr199PMdQfu0oKeUjFznCTVUu7Ve0uskaNFrosSX1bg8pElWAYGh1j3xJG+GAif4x4dDcL7GgrG3DX6GTZuCJDiwuSxr1igB6IYa/jvgn16VdwNorPPn6ehl8A55IUk6KG7MSwTGZkZhpIhzhm4AdrYdwWyW7qzzTk3NxuqfPNpQ+m+qMoA4OIW92HnQlf7BZyPMOcFVx4O+HIiJXdNACpdMepeoaMhAkhzV1L3aRb/bF+CAAvM6C/XS85mGxFcxKRG002POht8YNZzerngVVZzbA38HJGY8vxXKHM9LUbpzUpHnBu/UEKX/W+w+50DJQFYFN23LoWCmz3xx+ZLMI0Z1nsAD/rbZXy+Mx+5d8pCPoPWjOKSVsK97IVWgwXrNmeHxEA0tQdhQDVkY3uZUxgPsvTCs3lRm/C+qv28X5MBJ+JMaoEWAqTCAM4M/kyLasJ07GF/SbdRBfRof2P7X+YjvgwSjvVPXH+ql7TCnxVZCA5ymT22HcoXyg+HpSK+81r3zAczqzRk9dJskDY2EoRaKQ9ByJPgPE+tAJn+pVvDQnsM3xqG9p9KbEg8yDW2eMCCjIT3cFMFCQ4UwBWiuTAKH3s7u2It9I1tQS8fZZCkVZspH+mA44kw+eQ+AHyFCTUwJ5ZS7hyy8ejItDnYI9RDxv9cR0ne+IBhktFvByytae+cf7qpDxRquUHNgckqw84F/Q10E3RHCUAMIixQh+GxCUUKkYuXD5Gjnyf/hMy0DGnAd5wLEdzKjCn2/xf04mXcD5uMHt4sOIYRDDqEG3ZJGl5WB1PPkp+jE2+954kwrVu/AoLdLhWIPQw/p9daOJu4QHXCGFtD+TOcQeiJY8oZF+4qw2oiLEbNipbk2b3856QUhcuxF+q4/odgpr5L56
 zjc0TLXX
 wGhHV55FP2g/nRb5DMWm6NJVnD/3xGlmXTMaBfjjC8yN+xb2xXBmDl6QiZeBMRNso6Vol4GYZ4HEPchf0BkwHCL3gJr37XroeCf7Ct89uaDHL34gDOMbB0SV6oj4LkKifDxLVFGfUNJNsUf0ESzbM2xFX/XDuBjd9ONHQ8ruPJ7ZXRDdXyY3y2C5wSzFnS+kPi/jyvyC8TR75eEMKgRc0TZMq3cLO+XBDis92T3Aee3/iEv0A2KJXH0ES66EuPyPem52Q+XRF+i189zNV11a387ZGZQh7v4cRx68zf5o0BIPN8YhB5pIW+Vol6p0P3u38nEPnUZCalu10Ez/A48NgBl4py+gS7s8L0fcH320F4tGKRuKyUaX8+jyj+3binZSsX2HT309bkvZbLYGCKB1G6lAsUU3qXJO2NNsvvVGkI39Yn241FTXBZk6kYn48Uy2lL7TEJkeI0TZ1zQ/m6i1LAAxkmaiCc1FbLDoh08IhYHt7GqDwsK7UQ5aFnnYLOR13VgjWrx7uKSe9GlbuiKEE+sfkUlTswYO6nKnxTsv/3J+Fziz4jWhrreRYCu3/3tYSRC3we4aZjwg6vJh/Bk9HPk3hFsl9q6IJ2FidasifNO9OeUTph8utxnaPs0Z9rWTYmjup2bB44G4YHAV4I4E/pRZBglhielnCJYrZucGIrqdzOmZBb1lFb9m0tKLiM1/jlb03EQr8daVMg0AgAt0wOZ9AIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the guest_memfd populate() flow to pull memory attributes from the
gmem instance instead of the VM when KVM is not configured to track
shared/private status in the VM.

Rename the per-VM API to make it clear that it retrieves per-VM
attributes, i.e. is not suitable for use outside of flows that are
specific to generic per-VM attributes.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h | 14 +++++++++++++-
 virt/kvm/guest_memfd.c   | 24 +++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  8 +++-----
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 792701b093234..f21e16f22dd7b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7978,7 +7978,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f84421b3f49e..19f026f8de390 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,12 +2534,24 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+extern bool vm_memory_attributes;
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
+#else
+#define vm_memory_attributes false
+static inline bool kvm_range_has_vm_memory_attributes(struct kvm *kvm,
+						      gfn_t start, gfn_t end,
+						      unsigned long mask,
+						      unsigned long attrs)
+{
+	WARN_ONCE(1, "Unexpected call to kvm_range_has_vm_memory_attributes()");
+
+	return false;
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6f4252c8b3f59..b6ffa8734175d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -936,12 +936,31 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
+				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	if (vm_memory_attributes)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt_for_each(&gi->attributes, entry, index, end) {
+		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			return false;
+	}
+
+	return true;
+}
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				struct file *file, gfn_t gfn, struct page *src_page,
 				kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct gmem_inode *gi;
 	struct folio *folio;
 	kvm_pfn_t pfn;
 	int ret;
@@ -956,9 +975,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	gi = GMEM_I(file_inode(file));
+	if (!kvm_gmem_range_is_private(gi, index, 1, kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7bb59679c9316..70b594dafc5cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,9 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static bool vm_memory_attributes = true;
-#else
-#define vm_memory_attributes false
+bool vm_memory_attributes = true;
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
@@ -2457,7 +2455,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
@@ -2591,7 +2589,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*

-- 
2.53.0.1018.g2bb0e51243-goog


