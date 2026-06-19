Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE70CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DCE36B00A6; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D9C6B00AA; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A716B00A7; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACD26B00A7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6D711C1A40
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:55 +0000 (UTC)
X-FDA: 84894784590.06.14073A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A807B1C0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKgdhA3F;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL4rTshL5bVE0zIhkoDGKeCo0HsS4R30i6gGAsHRFjI=;
	b=SjD4ExJWrcljP5BzAxOg2hGsdp76IwoPnwm3MO9b4JhHFznQVjeo7Ly9Vzf0u4ACjHgqW8
	b62YFYrSHQv7gf902DudwJ/LO5q5PFh937lxcIce/HXVIyEvFxvR2NnTEW/Sv4eFe2dJjM
	9sC5WWJ81MtapG/qgZLmOzs+Y44msG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829113;
	b=xIgF+Wu7m+pEDA/ey8z/HJu4ZdcuLF2iYPkryCWFM2W0V1vskzN2BgSWcN/KjOlpcdKnBa
	BpJgtfiC7aQHe9IYrZ35tYHoAgSvHlOTFokMoAE5/IiM2LbUw+yMfsUtR+Dv4Ih6rs/gCy
	Nnts9xOArrXvCPHIJiSp3zTilovIGiA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKgdhA3F;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5216844673;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A2A8C4AF11;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=o6syndKhpxWoj+2A1j7qSODfDXvOrvCLyh71JwrxvHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DKgdhA3FetSJuU/N4kl4aey4ueBmhWhLXZKTXY0Ytj1QCZu1JjqUASifEYTJTlM1r
	 gu3voLzkzx1+Z83XeHHovKNZLZZINRSOVcG8uW9h0BKoQyBIDaUYwafsVEi9AO7MpU
	 7DiyhFB+xpM8+AAqTerLVBbnlj4VXqmFl7h9J+CguvsQLD7fflaOD7sVaPiIurHMSV
	 j6jJNRrb3O+E4V15ZCoAuXnk1hbhfOb/WMZYL97ztZUgaJx9J8BrMr/8Xi4+kcRs00
	 s0MgErHPoW/+Rbd8UQUiRxkysz3+HVulPUpYcQKaNPUhJlbFxtT97djiOSqRDqxDIm
	 xmwsSxQ0LtyfQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47EACD98FC;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:50 -0700
Subject: [PATCH v8 13/46] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=7259;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hLFu2VawfIFIHQ23HTUVD5Ob9Hl80lZPaHDlxI+7tiE=;
 b=/HA8lyDxilcqYj0k0NVgc6b6zeSZDL22GRQUXhz+PUr++dVY+iKpUxbZjheGEf8AdcLQ/DucY
 xh1iKT6c3VqBi4p3C3mRKA3sHuRP8JaZnAhEj9n8b5IWn7K0kPPhkhZ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A807B1C0008
X-Stat-Signature: rx6zy33bsane948sqx17wjefjdqturg8
X-HE-Tag: 1781829113-401352
X-HE-Meta: U2FsdGVkX181FBGmsHdxp8xQP1DYPut4tvHABunrpeqoTE1A26yNA+4P0A9vF+HfX5LZ1OQJhaAPs2aAuzgRYoQXFXefrQLjfqLrF5vbHE5ijca0wgtpWj/0zySYIRfuqMHrzzr/VBqYFbFx2yDyUV4lH4WQehTOLWTTU+wqJP1YSF2eZNs6ZPBdF595L8XwQRhydHIwrZ1FA2JsbsbrBIQGPGQ96FoUPxy6D6Yq4RwlIjtQa6qT21BaTeLEp0RK5wVWJIcMF2mBK+pfx8WbNde8X9M2s352CpelzCBCge6bCSYmjLMMn3pEkuSIERjr6ZLZZtniOVxAqxQWrgn9bWkQqaxYu1WrVhyK2G5sVVpkOoeaw1ZkLssC8nIYNn52TXYZ8DK0qRE0hNmSqU6H5NmUZrBo8hYlhoDtiESD0BaHjFRW30xhqXTXq/V0LCOGV9XhpGWKBt8snKFEOABIy72kzv9rWtGyvAKb3NtdbNCXxJS9rzjaHWdB1TlMUACAIvR7xlfa36Y27j/Cz0ZFJM5ak2yQRrrg3iuR1S82IMGyl9vB7pMD5XeH2DIJuG6BJTeU14yAltbTXFA9JYHNgBq1yiji6DOiiHViVZcXowxsU9hS8F7XzJPzA+Lfhg14QCelGykQ1xqACCu4vQrxLA/M5+1dk9lHCISEQ0kP+8c5sstk8Mv0Sj4UIRKaF5gR4qLsYbFtJMeZMGkZxc31ljxlSAykfI1n9LqXMBba5rTbNdnXClaPx9p29w1xzlfQBU0gxfDzlOlU7KrDQJ/qmxRBvtKAshVnn8YDm1YztfDir5yoxCxUJLwlx2JR3hdsPJSN1QnKBSIJRiYds6czkdiQ+nZKmY2Bh9GHz4WCt5oCBuAZoHPJK9CAXpu4s3GN2OuB/ALGQ6dVYO4GSR5sCm9P0lVU3BxXQzsdh2Rl/DxmcMZuSLova5FE8mVlzCKpNetU2hn8rNPm9vkYUTj
 8Nvk6hKK
 fE+hdw8pHPzpURg2yUCfj7SX4aqO+wmiak6mNY8Hdz8rT53qb/5Li1iZeWFUpDeCcw7YXdoAMSlSAEzx31oG95fbOjFjr1gDfpgxNQaSfdEN+464FmMJc6lArGkD4fO5jjihRF4wJnS1gQ+veuv/GhzOm/dJnJbof7CFCY5gaiiFYZ3gB+xm91CSHFE4IwudYX2KLwbPpFnjutN28ol0UVsvk0Pn8WUTBQlDJjL/5wfmhDuc4g60c0lxN+/K4eBZbkoTKenssjNo7I0fvEdYt7ph+DDXDsqam0B0dkFLnKIDw9pjisya/y6x7z5lTGdYLdCymK1UjQgrHfgSonYyN0FZciiVR3h7eskrl/Eps8ML7L4Qv/VO0n9F9bkOBaPys2wz7AXr+drHxVwy715Mj+0EHNio9TmzCkJFK++z5G+QpQGG2kUag/RnsCuoj1z58v3zbHWBpIl491nPfIB1RK9/hVEWcrzJVzkSv2DPjC6z9WR7/CMP88LJMfQ==
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
 virt/kvm/guest_memfd.c   | 116 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  12 +++++
 4 files changed, 142 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8e..956877a6aab05 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1649,6 +1649,19 @@ struct kvm_memory_attributes {
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
index 297e4399fbd49..cfa2c78ba5fb9 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -102,6 +102,7 @@ config KVM_MMU_LOCKLESS_AGING
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select KVM_MEMORY_ATTRIBUTES
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 65ce795c090d9..0d14548c1ed22 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -541,11 +541,127 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
 
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
+	kvm_gmem_invalidate_start(inode, start, end);
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
+	if (!kvm_arch_has_private_mem(f->kvm))
+		return -EINVAL;
+	if (attrs.attributes & ~KVM_MEMORY_ATTRIBUTE_PRIVATE)
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
+		if (!gmem_in_place_conversion)
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
index 01761f6e25d25..a08b518cdb175 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,6 +105,18 @@ module_param(allow_unsafe_mappings, bool, 0444);
 bool __ro_after_init gmem_in_place_conversion = false;
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



