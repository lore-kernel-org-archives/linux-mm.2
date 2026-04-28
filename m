Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF9BFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630626B0106; Tue, 28 Apr 2026 19:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1336B0108; Tue, 28 Apr 2026 19:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFB46B0109; Tue, 28 Apr 2026 19:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 327B36B0106
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E03A51C183A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:30 +0000 (UTC)
X-FDA: 84709548420.24.20B548F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D53A140014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJlnpg58;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418729;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vV20ScH3EfN+//rv02Pyw6aWSkLpyi3EguIv1/1f35c=;
	b=4Q0ueB0V9Kd/VO7/Uf1He+DqP9b2qZ6eWKcFpaCA6AC8COw4g+faQPv+RBcJIRIza5rHPc
	xAqjMXEqYUPo2+YFFuaPJZoEhQg5f+fZ5Re9Dd0yhsiGobOLYmmuf4C4LSfAgUWpGiya1W
	TASrF9By7F7hSur5zHmyY3WTF2QFyMQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJlnpg58;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418729; a=rsa-sha256;
	cv=none;
	b=Zgtd9D3fLvIKJTg7+RkAi9sP5cZhnro7FV79krn5AnrkIMl6OGz+3FS3/yJ/jz0ktJ1fKr
	G/IaDXmEsgR2sO+ms8WUJ+2xli41cu7vJrTt2bWicjM/+vcI006yZhh/HZW+xfE9gLkmGF
	3Fu92rK2IYzX5tD7OYzWVqn6e74Rj1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55D2744491;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2104AC4AF11;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=m2bOW0DUVfOZna9REsWxASypSF6X/t2k8+SwYTvUrgc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WJlnpg58o/wMHP8oA2epKzXvuu0F2uImhLPh4i+yCuIuUFUijKUcfQmk+2uN/pT7h
	 0cWGPK1gsPZsRGlY6uEWokR92R6JrFtTMZNz/hOPFIUyvlJDtPLmgpNGxkQ7BeooAj
	 dXdSHhbv52GEyuZHyAoqqCj8Ggc6dPfwE6ETRPWQ7+uEs90xRB4/aZ5gLE5GdccoCd
	 BepwaMv/5kjxDgHxS+6ycmPBriizSk/vDHl9jYlE2ON+EBB9gKhNOB3vl5A93+hgfg
	 6uNDvW5/2JlGSqtPjhVPmjyd6jIISjqN47JhWDQGSf+PsEuGcOs/6QTQ1ka9++XE3d
	 ASdkLEjLfl5MA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5E0FF8875;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:17 -0700
Subject: [PATCH RFC v5 22/53] KVM: guest_memfd: Apply content modes while
 setting memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-22-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=8609;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MUDFg3cF6c9zZj9eh+GrJ3J5VFbXgeIVHlW3jinLVHw=;
 b=2XGqE3iV+Vi1bSn0hlNODYxtik3QyF9m9aUmkOk9DiJ6SyFSFBLsOf07/9slTvV8WlFojh1kw
 cm5zpBbGFbjByQhM6jLEcwU3cELZfDgCodbO76TBbTHf8UHrktag1mF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: q5nte9nu6hntnabh41pii9pbneyurda6
X-Rspamd-Queue-Id: D53A140014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418728-574001
X-HE-Meta: U2FsdGVkX19mMRP90cbAQuHtbMINK1GeWknxC8ah/zE4tvSjokB/v521lY2iA9Ay4q/pwXmhVmHHdn7bWtUoi3TqeNpuiMOXxAvaLqey37optX+vgpufUCHWlArRf0LqQZ1Fk1MVEShm5a3I2DudksJZEfozAeuwnrR/zFUnrUqLIL3Qpa5+0J/F6p9h87y5XDoDoCJ7vW7ABEeYdhr3SQI8wAJxoTwXBOnmKdKCxo83YGGFJJGvNwwr8O1MVR1bGsYihRsiRtG+EeDma7UelWkw5RuVk2SS0KcKE4PMlIl7+KUYbDzSZNqWh8QhYr1mEZtS6iYBjbd7MZpb0xLPxAWEXdycC2E69m/aNJ68gn55yaP4J3kzYxhzPS5r49y+VLUwjRFJcqZ4tY9Ffh0VxnqE1O6yHu7EW8WneEpvXnpBwyyVr/gI8tyjjw8VkTLL96GnWSkYZdbYCL4vxYxZ8fnqgdO1zdie9+FGG7vrsYpEKLhJJ8p+xFlDCuAxKumo55yiC93XDSFGd7zi2O/w8a8jlGHtOeYSfpG1JqwfZBmHqD7H2TXf5+UpVWe3m9/o1eNTL+nV9tj9Fh3ODu6x+0zOF+onwEHpbfbD+rJrrzRk+Q3SumlEPXXyrFv6niCaX4KdTpkH+GjFnQh755PP+rOuDfBpUOuBDs1NPPyzkF1pFqNwlLya+886Op1OigN84iaDi3ewz23m49UWd0vArIDGdF8Hi9DsKHlSMfDwrZPpGjiaShU5RWkQYe9GhVgQ8XyZS/KyiiPo1dfMMs6uTRMelDmjTQ1ybitHXR3p1neovEJdRl6gGEr1EWu1yFw0BP2Zud2TAQtawpTxDsGmYwu1sdtRx8sgwIXNa5hHiKkHwkYbzwWg/+nOEuMWedw7sp3rl2VDOoAXYqGPPIMhfDwsV7XI6fEQCMS7fr99/50GWi3dyitXYvOCHe3/1B/GlmzfR9MchynvScJBwES
 ur7KlAyN
 Ce9SWguGO6i6AQBzupjhlHaNh6RmT25hAlw55s6Gu45msyybdsv+ZrLa3E7rOaZVDKGMHyqZ9JtFMJMOigBrIxevEaGBdO8RjC443wCWKujtBCAWBKDcGA2DkNxfWyxd7idNzCg6Dscs6xk9ll0cstl7dCZZI6niYuVge6wYNsSZEXNvpitvvJCTOykdGbx/66s/BCWfM3UmXcssgRevJw1S2O1AocmWD/+PtGUTJv6qRjifLZKFfIdkyLjlX+s+E+yzUkaMJZlgpnk//uiR6xdIpjuh0p+i2Dwv6xpv/l+/DPc6g33hfPu/4WiazpuHqW/L+vi2efB+F4acvzrHUlTb/73P1onGpkoKZbsF3nmtDg1Ob6FPKc/96KZeBKvY4ifJpuHyD77S2pCyp0dLN/EEQoQmdCLb4kZfeQG+zZ5eFK9r89UUecGXCjOhrh582yfzSimpZnKVIDuxOMImBBvrx3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Provide defined memory content modes so that KVM can make guarantees about
memory content after setting memory attributes, according to userspace
requests.

Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  4 +++
 virt/kvm/guest_memfd.c         | 56 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ce10c8ddb634..61b9974ba52e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6573,6 +6573,8 @@ Errors:
   EAGAIN     Some page within requested range had unexpected refcounts. The
              offset of the page will be returned in `error_offset`.
   ENOMEM     Ran out of memory trying to track private/shared state
+  EOPNOTSUPP There is no way for KVM to guarantee in-memory contents as
+             requested.
   ========== ===============================================================
 
 KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
@@ -6621,6 +6623,65 @@ on the shared pages, such as refcounts taken by get_user_pages(), and
 try the ioctl again. A possible source of these long term refcounts is
 if the guest_memfd memory was pinned in IOMMU page tables.
 
+By default, KVM makes no guarantees about the in-memory values after
+memory is convert to/from shared/private.  Optionally, userspace may
+instruct KVM to ensure the contents of memory are zeroed or preserved,
+e.g. to enable in-place sharing of data, or as an optimization to
+avoid having to re-zero memory when userspace could have relied on the
+trusted entity to guarantee the memory will be zeroed as part of the
+entire conversion process.
+
+The content modes available are as follows:
+
+``KVM_SET_MEMORY_ATTRIBUTES2_ZERO``
+
+  On conversion, KVM guarantees all entities that have "allowed"
+  access to the memory will read zeros.  E.g. on private to shared
+  conversion, both trusted and untrusted code will read zeros.
+
+  Zeroing is currently only supported for private-to-shared
+  conversions, as KVM in general is untrusted and thus cannot
+  guarantee the guest (or any trusted entity) will read zeros after
+  conversion.  Note, some CoCo implementations do zero memory contents
+  such that the guest reads zeros after conversion, and the guest may
+  choose to rely on that behavior.  However, that's a contract between
+  the trusted CoCo entity and the guest, not between KVM and the
+  guest.
+
+``KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE``
+
+  On conversion, KVM guarantees memory contents will be preserved with
+  respect to the last written unencrypted value.  As a concrete
+  example, if the host writes ``0xbeef`` to shared memory and converts
+  the memory to private, the guest will also read ``0xbeef``, even if
+  the in-memory data is encrypted as part of the conversion.  And vice
+  versa, if the guest writes ``0xbeef`` to private memory and then
+  converts the memory to shared, the host (and guest) will read
+  ``0xbeef`` (if the memory is accessible).
+
+Note: These content modes apply to the entire requested range, not
+just the parts of the range that underwent conversion. For example, if
+this was the initial state:
+
+  * [0x0000, 0x1000): shared
+  * [0x1000, 0x2000): private
+  * [0x2000, 0x3000): shared
+
+and range [0x0000, 0x3000) was set to shared, the content mode would
+apply to all memory in [0x0000, 0x3000), not just the range that
+underwent conversion [0x1000, 0x2000).
+
+Note: These content modes apply only to allocated memory. No
+guarantees are made on offset ranges that do not have memory allocated
+(yet). For example, if this was the initial state:
+
+  * [0x0000, 0x1000): shared
+  * [0x1000, 0x2000): not allocated
+  * [0x2000, 0x3000): shared
+
+and range [0x0000, 0x3000) was set to shared, the content mode would
+apply to only to offset ranges [0x0000, 0x1000) and [0x2000, 0x3000).
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f437fd0f1350c..c7cc6c22c2023 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1652,6 +1652,10 @@ struct kvm_memory_attributes {
 /* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
+#define KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED	0
+#define KVM_SET_MEMORY_ATTRIBUTES2_ZERO		(1ULL << 0)
+#define KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE	(1ULL << 1)
+
 struct kvm_memory_attributes2 {
 	union {
 		__u64 address;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b0e4bb554cdf3..5c1db67e6fd35 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -699,6 +699,19 @@ u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_privat
 	return 0;
 }
 
+static bool kvm_gmem_content_mode_is_supported(struct kvm *kvm,
+					       u64 content_mode,
+					       bool to_private)
+{
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED)
+		return true;
+
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_ZERO && to_private)
+		return false;
+
+	return kvm_arch_gmem_supported_content_modes(kvm, to_private) & content_mode;
+}
+
 int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
 				     pgoff_t end)
 {
@@ -759,8 +772,26 @@ int __weak kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
 	return -EOPNOTSUPP;
 }
 
+static int kvm_gmem_apply_content_mode(struct kvm *kvm, uint64_t content_mode,
+				       struct inode *inode, pgoff_t start,
+				       pgoff_t end)
+{
+	switch (content_mode) {
+	case KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED:
+		return kvm_arch_gmem_apply_content_mode_unspecified(kvm, inode, start, end);
+	case KVM_SET_MEMORY_ATTRIBUTES2_ZERO:
+		return kvm_arch_gmem_apply_content_mode_zero(kvm, inode, start, end);
+	case KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE:
+		return kvm_arch_gmem_apply_content_mode_preserve(kvm, inode, start, end);
+	default:
+		WARN_ONCE(1, "Unexpected policy requested.");
+		return -EOPNOTSUPP;
+	}
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
+				     struct kvm *kvm, uint64_t content_mode,
 				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
@@ -775,7 +806,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filemap_invalidate_lock(mapping);
 
+	if (!kvm_gmem_content_mode_is_supported(kvm, content_mode,
+						to_private)) {
+		r = -EOPNOTSUPP;
+		*err_index = start;
+		goto out;
+	}
+
 	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
+		/*
+		 * Even if no update is required to attributes, the
+		 * requested content mode is applied.
+		 */
+		WARN_ON(kvm_gmem_apply_content_mode(kvm, content_mode,
+						    inode, start, end));
+
 		r = 0;
 		goto out;
 	}
@@ -808,6 +853,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (!to_private)
 		kvm_gmem_invalidate(inode, start, end);
 
+	WARN_ON(kvm_gmem_apply_content_mode(kvm, content_mode, inode,
+					    start, end));
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
 
 	kvm_gmem_invalidate_end(inode, start, end);
@@ -829,7 +877,11 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
 		return -EFAULT;
 
-	if (attrs.flags)
+	if (attrs.flags & ~(KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+			    KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE))
+		return -EINVAL;
+	if ((attrs.flags & KVM_SET_MEMORY_ATTRIBUTES2_ZERO) &&
+	    (attrs.flags & KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE))
 		return -EINVAL;
 	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
 		if (attrs.reserved[i])
@@ -849,7 +901,7 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	nr_pages = attrs.size >> PAGE_SHIFT;
 	index = attrs.offset >> PAGE_SHIFT;
 	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
-				      &err_index);
+				      f->kvm, attrs.flags, &err_index);
 	if (r) {
 		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
 

-- 
2.54.0.545.g6539524ca2-goog



