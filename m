Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D255ECD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D8F6B009D; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BBD6B0096; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196CE6B0099; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCF8B6B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DEA2C253E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
X-FDA: 84796772214.28.80642A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4793C0010
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SC7nZ8JS;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwzD6bs9Npv6NgR+LVcp6mSZd2Rheb2iI61aHiPMw1M=;
	b=jjs/ymH3MEf/GJzYITKjYrOpJR7ztC2Eja4Xs5hNiEauylQ6Adca9LoC+47GAst+uqXf/u
	KjQB4fOzHx/n4VD8iONMEKmcBOAPgQ5fxxe8NaHXSlOhfnfRF3YRTPVTjzKXKRjGVniWzE
	qKHYW8LRx15SuAzb4qb5iI7PUTRSg5Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SC7nZ8JS;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495485; a=rsa-sha256;
	cv=none;
	b=7jvuNNyPJbNSlSs9YmPXducW5iMysWjmOnN5YGIGEUEA7a7Fxb8d1JFmUaiUt49436zxsF
	JQicqTQLTF0QPpLoI9EhcYb/kuJwEe5BQLvF3J1DNjb15k++oFZfqxf2wLKIrRnuvXs+Mn
	vGNtb9leRpk+96xNrBziEW47S5PbVWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 880F06022C;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E98E0C2BCF5;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=Boqi8sbXg95VRLBwCq3tWvHpg5otRariH3mGKwgXFWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SC7nZ8JS+7XtItXqMAyQvoYpDkiSEZpbpI3UKvoKWq8qBzqqu6vt/900Ll6IkSBcW
	 ESEzr8/6HEI2cmVdiCSssda47XTgN8i7qpWpVQnFDX7L3FkFmqT4WKjSbtNQkPhtNI
	 fjJdfApY+c+YLZeldrQhQQK5vtCompAT2wynMGM9WPnt5ud4iJrnqLvjJ+MaUTkfku
	 dwaItZJYPfwN4KHV/1+/qMBKyMReNSCpUJIONykvL4ytG8QpXNr4YRavps3x6p70o3
	 sd3bvoWbIBLvXkcfbTmwsHTPWCGyHzIIzsz/K0zv781HBUSjl+xBFOCvkLIuZtxmzH
	 tHsCjNmLQ/LoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1D8CD5BB8;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:51 -0700
Subject: [PATCH v7 09/42] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-9-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=7283;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HWWF/B8Mmi5CCmDlXM2emFhsk2m89n4YIEwFVbTYm5U=;
 b=fhVMZBKTmPfrFJZLWj5eSEU4L269lPKyIokehy5mKK1nbrFuG5Xpj6lN94T9UTTKHrsicAan0
 DSPefMTqRAOCy5zBVNa1JSuioc807er0r08sPo7ZeeCGC05cRsiEH7+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: j3nthhkc4qq69fx36py88sfmm7o1p8cj
X-Rspamd-Queue-Id: A4793C0010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779495485-985801
X-HE-Meta: U2FsdGVkX19yVhFDYiqOZerKP4eqtLjJ8Q/XWQoqCdMH3RR2td0QfyYc/w8JrXsPbgybgnmshael7CjEjLHgUSqma3oxypCV1WMq/F7eWLGNLS5VnGCFsD6byorMSGc41dAIvrRUSSI7OcQyC5cFnsUoFHlRb7z/pDfQbYHYd9O/SInl8CY+0SUJDzHntzrtoXKoD4i9RQv9QlxFv9IUkuQtrnT+r22dt6LF/4LJIgU9EPWSzZjM57qhyc1E7Pu9NeZb4H8EJ7lef2S1CvsJ6gHEMaJMyob/o5h5gUgkvqaM9kTUXcYVKnLQmYUZ1uOvpJrodUNFgLuyQPDKOCXFkcU0pcBocPPH6eu1P8a5/d/5kt1VfhaqbUsCEJFL+/gz/TpzBNJw7jCer1tBRcUlPRwq/hB5ZPYSrFXAqr07NG4DVbD1g+qBK4qJT7PkSeQ7wyEZjwUAJ+oZIyKiDmXVOeW3TTHQlMHRrTRxNP4bpUztW4YmxiOmrmzAvi8xuhzaithlcWp2tPRh/Kd5zsjrpV50zABUZtCuYeNTHWJSsKxpvZoEEUjBx6iGugtPgHQPGYQgqYBmjmXXmCGTKI6BXhUEoz3neFcFoPrInaQBt/YGqK5t7vCSuCJ3hPCB1vmKoFVvz8al4s8mUEnJaDwEe40M3o/BzPHkL2k+Hc26ZmwWDkFeqYFaSotvcI6eTegVQsAEyOX7zJACyUWacn4zZayZaUnq31bDnDEmjKsRjVP2B36aBfYrVSSpvPkmxwmJBE50KGnggVRXUGcJBryZjiwRN0h/7feaMq2vdtfxlVoN/QVDZ/leQMKaaa3s+ZGq2RvkSp9E2MzF2lg/nfFsdQeMAfU3APCLWPv2zRIJmrQ057SUjn7PS6OT42ZF5kMFg3VLFhlSp5goVNGffrhRYysJySg/dBTmzI59kxhSn2/LMGEVDxYcAytNlPbDHkmjzN4QxuTWUWgIIX2pcTy
 hLxk+NBh
 43mJDbNX41yQo6doLpv4a0wCBiByi5EF+pI3bxpu/a5GjjpGvJaGTT9c9ksHcfBB4QlIS6eJwgir5AJsIPW2w6c7M1J65m3uq/EWi5N3t3qHPPDMAXfaeqptIedEehr+KId3P8p+UBor5jfmtJgUQWyWrUr7U6RBArV9Nb/gaYGixRaTL7BzDfDo+UPMR0rFi4thF5+jfR2biby15kQyy/kr9xhV8o28U6E6Z6+cYftU6hlCCxQ4JaGGCFlcwkoNfHjtrByX3mcNfdldw0ylokldGCF0ECIdYlHK+ODRtXDa3lI13ul2BWKYx+X2S+TCXmzXoxSi5yF0DYfKxzA3YeZ+4FH+mb5TZuuz/uo4LrO8SSfJBzHDsyYRUVbtToUaduuwAYqonOfi6VCiPP5tMk7uN90P+vV6eUFGBfJbXUNjYJgsNjr9rWun8I5+MGcptFBxbomo7fJ4EooE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
just updates attributes tracked by guest_memfd.

Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
by making sure requested attributes are supported for this instance of kvm.

A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
details to userspace. This will be used in a later patch.

The two ioctls use their corresponding structs with no overlap, but
backward compatibility is baked in for future support of
KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
ioctl.

The process of setting memory attributes is set up such that the later half
will not fail due to allocation. Any necessary checks are performed before
the point of no return.

Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Sean Christoperson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/kvm.h |  13 ++++++
 virt/kvm/Kconfig         |   1 +
 virt/kvm/guest_memfd.c   | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  12 +++++
 4 files changed, 140 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6c8afa2047bf3..e6bbf68a83813 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1648,6 +1648,19 @@ struct kvm_memory_attributes {
 	__u64 flags;
 };
 
+#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
+
+struct kvm_memory_attributes2 {
+	union {
+		__u64 address;
+		__u64 offset;
+	};
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+	__u64 reserved[12];
+};
+
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 3fea89c45cfb4..e371e079e2c50 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index adf57a3a1f5dd..426917d22a2b6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -540,11 +540,125 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
 
+/*
+ * Preallocate memory for attributes to be stored on a maple tree, pointed to
+ * by mas.  Adjacent ranges with attributes identical to the new attributes
+ * will be merged.  Also sets mas's bounds up for storing attributes.
+ *
+ * This maintains the invariant that ranges with the same attributes will
+ * always be merged.
+ */
+static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
+				    pgoff_t start, size_t nr_pages)
+{
+	pgoff_t end = start + nr_pages;
+	pgoff_t last = end - 1;
+	void *entry;
+
+	/* Try extending range. entry is NULL on overflow/wrap-around. */
+	mas_set(mas, end);
+	entry = mas_find(mas, end);
+	if (entry && xa_to_value(entry) == attributes)
+		last = mas->last;
+
+	if (start > 0) {
+		mas_set(mas, start - 1);
+		entry = mas_find(mas, start - 1);
+		if (entry && xa_to_value(entry) == attributes)
+			start = mas->index;
+	}
+
+	mas_set_range(mas, start, last);
+	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
+}
+
+static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
+				     size_t nr_pages, uint64_t attrs)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t end = start + nr_pages;
+	struct maple_tree *mt;
+	struct ma_state mas;
+	int r;
+
+	mt = &gi->attributes;
+
+	filemap_invalidate_lock(mapping);
+
+	mas_init(&mas, mt, start);
+	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (r)
+		goto out;
+
+	/*
+	 * From this point on guest_memfd has performed necessary
+	 * checks and can proceed to do guest-breaking changes.
+	 */
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+	mas_store_prealloc(&mas, xa_mk_value(attrs));
+	kvm_gmem_invalidate_end(inode, start, end);
+out:
+	filemap_invalidate_unlock(mapping);
+	return r;
+}
+
+static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
+{
+	struct gmem_file *f = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct kvm_memory_attributes2 attrs;
+	size_t nr_pages;
+	pgoff_t index;
+	int i;
+
+	if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		return -EFAULT;
+
+	if (attrs.flags)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
+		if (attrs.reserved[i])
+			return -EINVAL;
+	}
+	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
+		return -EINVAL;
+	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
+		return -EINVAL;
+	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
+		return -EINVAL;
+
+	if (attrs.offset >= i_size_read(inode) ||
+	    attrs.offset + attrs.size > i_size_read(inode))
+		return -EINVAL;
+
+	nr_pages = attrs.size >> PAGE_SHIFT;
+	index = attrs.offset >> PAGE_SHIFT;
+	return __kvm_gmem_set_attributes(inode, index, nr_pages,
+					 attrs.attributes);
+}
+
+static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
+			   unsigned long arg)
+{
+	switch (ioctl) {
+	case KVM_SET_MEMORY_ATTRIBUTES2:
+		if (vm_memory_attributes)
+			return -ENOTTY;
+
+		return kvm_gmem_set_attributes(file, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
+	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff20e63143642..4d7bf52b7b717 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -110,6 +110,18 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
 #endif
 
+#define MEMORY_ATTRIBUTES_MATCH(one, two)				\
+	static_assert(offsetof(struct kvm_memory_attributes, one) ==	\
+		      offsetof(struct kvm_memory_attributes2, two));	\
+	static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
+		      sizeof_field(struct kvm_memory_attributes2, two))
+
+/* Ensure the common parts of the two structs are identical. */
+MEMORY_ATTRIBUTES_MATCH(address, address);
+MEMORY_ATTRIBUTES_MATCH(size, size);
+MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
+MEMORY_ATTRIBUTES_MATCH(flags, flags);
+
 /*
  * Ordering of locks:
  *

-- 
2.54.0.794.g4f17f83d09-goog



