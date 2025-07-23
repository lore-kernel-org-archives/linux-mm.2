Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A25BC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB54F8E000D; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C318E0001; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C778E000D; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B36CA8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 933E21131A9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:28 +0000 (UTC)
X-FDA: 83695202976.07.D57B0FF
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id E211B1A0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t3MCIUiW;
	spf=pass (imf19.hostedemail.com: domain of 3vb2AaAUKCIY3kllkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vb2AaAUKCIY3kllkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcETzHTWiEWR8GOIStOaS7XhZknr1voGGAhaPeQn9wI=;
	b=p937rj70HCm9TCh9Sgk75QkwAEdjt98n39RK0jrAXx/8RX4cJ2K1keHP84PysRjRC8RfFd
	8lXGWOMN2Yy9xpWsiMuGITqVjafjT/o29eKGSP+W4696+PyklGjdmiZdQzOFBaXOLszjhm
	dEFVKvlAes7TKyUbp1eKH/9kELaOPwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267647; a=rsa-sha256;
	cv=none;
	b=hnerUrNeNfPfo2w/OSiDStAKskDmPG+VFuhmiC6530zBPlIUTrpZDBu1qMg/lDedUQy1+3
	ye3U3eSKyNqmBlSxNodaCNclAWeL4vVGKLrqH3pLsd+jRq+qe9eVfNRdzncaJOCA5WVuEK
	Qz4MHv2Q7QoSa6JP94ANpKRR++TAZbk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t3MCIUiW;
	spf=pass (imf19.hostedemail.com: domain of 3vb2AaAUKCIY3kllkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3vb2AaAUKCIY3kllkqyyqvo.mywvsx47-wwu5kmu.y1q@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b5fe97af5fso2762154f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267645; x=1753872445; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fcETzHTWiEWR8GOIStOaS7XhZknr1voGGAhaPeQn9wI=;
        b=t3MCIUiWETVVGX5EwzHoru1inuHHYtVoVivk2NIDxE083wObN+EltaElYCobtXijwH
         yMHT0GGZcnDktpRr/8f9FiWR2/fZun2EnPin9bncS/U+l1XJUetivxxmeH6HD6JckiG8
         ChIPV6/gIWGaX42eVhks/cbT0KUZvhlNAPBqXAGs8LJaTqNnqfbWMhC5QpYkE6F0txGj
         YTc51/8y0X2XeXh386DKGxUAHMVoh1UlIFks4gS7nQBl6Z+OKC0c8OUSFkTmE2ra3tlp
         bnf2uyCvbU+xwEaD7LgEJMK34fX6E8m73uaDgB2qPRAbQ5al+MnHQ4AvuFJsCPL/GLAZ
         NQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267645; x=1753872445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcETzHTWiEWR8GOIStOaS7XhZknr1voGGAhaPeQn9wI=;
        b=NO3Vry7GurmmxRz29ACnaDXhiuB3B0YB3NVmzdQIa2hbem/i4ZrYHothEUvhKLl6IH
         o1GM4XJUu9JurgFp4MskM11CiITYscjp0+5ptEzmagQQ9Wv8L8gijEPN6AVqkqdPs6I5
         Mzp+4yolRktSKB35JOCQkQGYpoLvEGXdBEUKGRLfEqWL3bUOoEF8z4I5u0rsb/iBdfIL
         pAToNIUD90xEzs6TZXKL7UHNBqadNJS3zRmGrkYP4nGU7dlpvTQSnkAhOmnMOZKhrXFi
         C9GASUeQijKVy2QVF0uXA+TcFXRD2PQ3TvRkbd2b+fbID/se5a1iyTeIjJWBcZ7QvY8i
         ZZ6g==
X-Forwarded-Encrypted: i=1; AJvYcCVLWEVf8NK7FaYwxTDYwcNsxfI/D9R0GiHz6T+f4yqWDJhmnDa0u7RS//kNNUf7hKyq+IfCekmarg==@kvack.org
X-Gm-Message-State: AOJu0Yx71Pfi57qePjMamosymbK8v+zOdnJg7DsHnr0rSz9PY5T4ryrX
	VVJFUT5zR4TL4z9NtfUNK7g94EszQ1rv9L8Ahm6ldJcwm1LPjlrpB83mywpBzr+mX5acr8mQvHp
	kyg==
X-Google-Smtp-Source: AGHT+IEe44MXl/ytA6bQwQoEc18ccfi02+HhAg/vYEYD6fmTIl5PZmuGxIaMa7BS20QwG080yszRIEU/kg==
X-Received: from wrbfx9.prod.google.com ([2002:a05:6000:2d09:b0:3a5:2220:5be3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:230d:b0:3b3:9c56:b834
 with SMTP id ffacd0b85a97d-3b768c9d38dmr1845396f8f.1.1753267645473; Wed, 23
 Jul 2025 03:47:25 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:02 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-11-tabba@google.com>
Subject: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E211B1A0007
X-Stat-Signature: i5eb69aymm4apouckkmjxc3kdzkfppqd
X-Rspam-User: 
X-HE-Tag: 1753267646-883245
X-HE-Meta: U2FsdGVkX1/A7eeFEBTu0tFJHzq9Aj2nL8RQRlwfXsJWPZ4kz7Jjt19zGmuCgpo1BtySpLQXPjhISIgJnEKmsY/eT6BMe1SgHsH9zHKHv4P6i1NFEZhVk0uHGdEVlUJMZEZFs/FbttE4lNTetw6DJs+As7Tyorm0uI6zacuFE2UzWFSiMu3g7ox3YJHnu+3nW5nim8OjrpptYTTr2AFZhvJp2jvFpS4i0T+aF/cYTlqahKBIQfl3JxJw1uSLrwK4QfdF3SOw+9kagViqU9hW2ZinngmJCeOXBM5Vv9pH7ZOyprxV2rG0beP3UD0hQjZIn+xq0+rAmIPT7p3gZ7WWW2Ng03FhI4YzQe/M7Y2k3qTHM25Nkh9ij/Ptr7f5+L3ncn5IrZnqX8xC81Kx0CgRhxlF8FAwVygH4XTgzw+ETCdzOVlehQ5qQWGpmPotki/0ue934DPFcUNXrk9UN6Ax1NVbl1SZqpnYicJzv9+CDTrYTIQvqmQA9kXx86C8m+LBm57EkjDbFcBK9RFjvXIvq1Sw3HjBL3d9lBdfWOam2gmKjLISSThZUL0Nw8WEIwx7anmZJK3p6P25i+bt1z74u1kxdI5WjjjnS3KRGp69Np1z+lK90GZm5j6k1eI1rx2x7Kwl1DmMkZE30tTIVO+A12caT2rfajrE/S97tCdBq2Z6nJ/pUvj65NhzUQoBryiTDeAMvXsHBntCxZNggyw0J+SYAbJ/fZUBjadmNJ880gSlLR8vWqCLRnYCpASk7+go/VkBu26v+7iEP0LVj6WPHdBGGzOkGmEBql5IudsiMJw8QpWmhjElfdiAghDm+3d8WhT8B4P055s0q8fjtcXx99+Z2KQqIXqj+rqrVAJLh9gGotKBRGOjDJ00DLhwnPQpsJyu4vfc++lEsdvfiUgOPrtV95M6vr8Ou8VtQkvWm51Ea/Ty6/YkUw3kgZIGD3MEF5kGaN6dMRtEWmMoTyo
 Rxa0Hk4j
 BRh71YfYzwdlTZFlZUPjF6SiuaGKp0dySjJ6ywu9Sazkir0tTZJErggBkpczRzEqplxCgQdcsJn/9EWmpW5/L3vuF6QVjgrlpEt/m3+Gb8/1NuyQAM7RIPMUUujFaY3mgk8YE8o8DdaNZRM2i9XFl8hIJT41yei5uKN9u1xuITpRRQPq/DCtFWrCl5JJdoCza5r1s4K6HJXvSLwB5jO3Vc9N/6dZDPAKz6M/cO95fn6Suu4pV9i1Vg5GUhkfDIXSIoxqo42ZmA922VxrNWSXf2VhIJSnkLNU9a1wslnq6YFj491YdPFjzfF1aRyJDzm0AKj9e6oi5gSjsbbq0PmxAbb2lxr4iauDuBUBb3xQ5J/r4TFw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the core infrastructure to enable host userspace to mmap()
guest_memfd-backed memory. This is needed for several evolving KVM use
cases:

* Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
  entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
  provides a unified memory management model and simplifies guest memory
  handling.

* Direct map removal for enhanced security: This is an important step
  for direct map removal of guest memory [2]. By allowing host userspace
  to fault in guest_memfd pages directly, we can avoid maintaining host
  kernel direct maps of guest memory. This provides additional hardening
  against Spectre-like transient execution attacks by removing a
  potential attack surface within the kernel.

* Future guest_memfd features: This also lays the groundwork for future
  enhancements to guest_memfd, such as supporting huge pages and
  enabling in-place sharing of guest memory with the host for CoCo
  platforms that permit it [3].

Enable the basic mmap and fault handling logic within guest_memfd, but
hold off on allow userspace to actually do mmap() until the architecture
support is also in place.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
[3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/x86.c       | 11 +++++++
 include/linux/kvm_host.h |  4 +++
 virt/kvm/guest_memfd.c   | 70 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..e5cd54ba1eaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+/*
+ * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
+ * (the private vs. shared tracking needs to be moved into guest_memfd).
+ */
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return !kvm_arch_has_private_mem(kvm);
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
@@ -13531,6 +13541,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d1c44622056..26bad600f9fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -726,6 +726,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a99e11b8b77f..67e7cd7210ef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,72 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_mmap(struct inode *inode)
+{
+	return false;
+}
+
+static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			return VM_FAULT_RETRY;
+
+		return vmf_error(err);
+	}
+
+	if (WARN_ON_ONCE(folio_test_large(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+
+out_folio:
+	if (ret != VM_FAULT_LOCKED) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return ret;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault_user_mapping,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!kvm_gmem_supports_mmap(file_inode(file)))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -391,6 +456,11 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
+bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return true;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-- 
2.50.1.470.g6ba607880d-goog


