Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27266CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A41D8E002C; Mon, 17 Nov 2025 06:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BD48E0003; Mon, 17 Nov 2025 06:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9098E002C; Mon, 17 Nov 2025 06:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A00E8E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:46:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E18E8A028
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:59 +0000 (UTC)
X-FDA: 84119922558.20.140E225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 948FA18000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rf/8XkGu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380017; a=rsa-sha256;
	cv=none;
	b=wmJBf+7aOmeS+MhesrpWJK6fEFQkFSxLvIchDlNAmep0PmKEJsiyDGKvxoLANIW4K4eMVB
	Anl3KQF9R78oxH5yXcH+NjR0Wjcelmox605hNVumW7L1p617I7xfX9uwuOi1QzJmfYIddB
	xfa3XPp6dzu2OWpMh3wFK6GTooT1DTg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rf/8XkGu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfuD4/wM6iC83CYIumcwxFHRVOHtnx9THrGQgJmC4Aw=;
	b=UnhaNhdNhxIHWxJ3frzkev7qW0u/QQEsJGev6drDHBiIEBR8375U35mzhs6nTa5pOUYMHQ
	vHpGkUMU6ksKUe5LfLKLEPXpU6v6yoOU0ONcltkRGyr8Azu6ZhBZl+zLzeuhrA0e3l+SlB
	kGsqqxGl+X89cX7sUuGd+QS0+oi5RwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E7F6601F9;
	Mon, 17 Nov 2025 11:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC696C19424;
	Mon, 17 Nov 2025 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380016;
	bh=tJnQnmAt6Wvr+31OW1+YrQRyI6HqICukDnZlnmjRypc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf/8XkGuM+tcAn7TrAR0d2+5u5uqFi1D2E8h6j3T7SAafDrHya+wVSKsW2gDh1b5y
	 K2+2fvSNEgBJHtSSo8PvpHFVe0MRhtZLUgUDyM5oiLcdphrXC9eA/jZDjbPZAaTrRo
	 rDSRA5Fyu+Mc6vvW0F485NTJQU5MHTAXSiDwm8yfmUXEags6P5SK3CBc6Bq3cLDWM1
	 x3SoyKBJLLxA5hA/COB0/KXlRKgglY6gJt1CaBK5SHXRz5JwsqEW3ruUzmlPsYRe4g
	 rCHLAeIKpe0YthRimRzIIgMr1b2m69ExF0wnE+iXlAn+vU8WTSITB0irmna3kmD7K1
	 20YszAdK1urcw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 3/4] userfaultfd, guest_memfd: support userfault minor mode in guest_memfd
Date: Mon, 17 Nov 2025 13:46:30 +0200
Message-ID: <20251117114631.2029447-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251117114631.2029447-1-rppt@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 948FA18000B
X-Stat-Signature: 666ys77y68zwip6bpff5psimtfp4e36h
X-HE-Tag: 1763380017-435357
X-HE-Meta: U2FsdGVkX18lczAFIdG9ioG1pLkE1hZlw0JzMz0XobUo6j1nIYFOWEuDyH5wJgDUx+TEFZkk2DZxfA3sOrtApXHNZ7obmb2P732ZSAfarDJJMJWOWn/JCOAVqjukDyn8J+l0PzS35T0CyBnK4DJfP3kfaN6I3HqiAj0Jv/SZw056/tU3LsUv2y1oB4rQ50ksGABA8lYMBjuaIvZR8XZC+B7p3MALBOD+N6Gu5KzarsW4X7HzFXFPGU+3c/j491APWqOABNPHgOwwGcqVVyv46i6GRL7ekbzRRKYP5IKzX8Gxa446AGGFTwZbJAry/9GMtu7pB3osNQ2GSufAJzx17ZidPH8kUw8/LRVyJO7kOl+1eZfWhJRdY7KJiDvZbWP5zfcsluyMm4eU+M/TcwzrStDxtsEo267CiFTugyIQuBJuZXCnWEWABuu/UL8W9mC5jRLnFPLUfHHGGHwu/CoITnFL60xEHppDrPF1eyqye1at+iw5OvmLqYgG0M/+LVZYS0d/gYXnJeajhe1DdRRxm5kYOMwo3jlbbZzSvGdVdNoy+NFyU4djj84YTqADRgy+/BDtZMA/Wk9eXneIwy3TE9NqOMAIrvFPjScxayC/tTglBepstBVIMgzFVTIhuhfqcioMDkglbcOkgu2GFkz+fg42vfXnqZE5N762ziiGael8JTF+suvdMJB9tF/butgbTtT6gc33PuqZuYwWlyFDZpbyKo1wtTfnX64UDzlZVzdwr+0alGUbUbZjrHFLfkLoSwV37tBTtBpJe6XkayJ+H6D0ZkdNhKVCoSBiWxrDyU3DItHAnBawsQQIT2LUhzfGA0jTTKTmc93GQlPAUvs97dQkfrpODHewxfV6TbcaOcj6KVnsrTfze8EFLYJht9n90fXKyfGp6M7FXspnDhaxQrysP7mqywg3Yy83z7ph+Z9s/NKJhsgQJZz0pWGS4t/mCxN/GIHUnWTRCK7F5CZ
 zvEy9UiO
 pnIjKx8pVromkh/ov1VQGBbM9iioj6tbvMy+4KhzgCapaN22CV6rLD8OseGpS0BQpm4f4as5M7fCCAhLkdS56teNYk5jObCHXA6KaFBapxBlszfQ3VK1gwmKn022v1PKF6qi0k8er3X5DFvnr2OEIzxBBDzY9pnTYiJ6ec8w3P8N0Zk5t4o+JXWltQYoZ377xnCx4xp7zOrKjuQnYUdI8/DX+1wAvNPJbPcIIXhjWMDyErrRks+LfFs1zgy0yJ9ivE+gsb+d/7Yx9qMaejp0T4Ckj/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

* Export handle_userfault() for KVM module so that fault() handler in
  guest_memfd would be able to notify userspace about page faults in its
  address space.
* Implement get_pagecache_folio() for guest_memfd.
* And finally, introduce UFFD_FEATURE_MINOR_GENERIC that will allow
  using userfaultfd minor mode with memory types other than shmem and
  hugetlb provided they are allowed to call handle_userfault() and
  implement get_pagecache_folio().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/userfaultfd.c                 |  4 +++-
 include/uapi/linux/userfaultfd.h |  8 +++++++-
 virt/kvm/guest_memfd.c           | 30 ++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c6..964fa2662d5c 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -537,6 +537,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_FOR_MODULES(handle_userfault, "kvm");
 
 static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 					      struct userfaultfd_wait_queue *ewq)
@@ -1978,7 +1979,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 	uffdio_api.features &=
-		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
+		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
+		  UFFD_FEATURE_MINOR_GENERIC);
 #endif
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 2841e4ea8f2c..c5cbd4a5a26e 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -42,7 +42,8 @@
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
-			   UFFD_FEATURE_MOVE)
+			   UFFD_FEATURE_MOVE |			\
+			   UFFD_FEATURE_MINOR_GENERIC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -210,6 +211,10 @@ struct uffdio_api {
 	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
 	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
 	 *
+	 * UFFD_FEATURE_MINOR_GENERIC indicates that minor faults can be
+	 * intercepted for file-backed memory in case subsystem backing this
+	 * memory supports it.
+	 *
 	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
 	 * faults would be provided and the offset within the page would not be
 	 * masked.
@@ -248,6 +253,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_POISON			(1<<14)
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
+#define UFFD_FEATURE_MINOR_GENERIC		(1<<17)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fbca8c0972da..5e3c63307fdf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -369,6 +370,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		return vmf_error(err);
 	}
 
+	if (userfaultfd_minor(vmf->vma)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return handle_userfault(vmf, VM_UFFD_MINOR);
+	}
+
 	if (WARN_ON_ONCE(folio_test_large(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
@@ -390,8 +397,31 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	return ret;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static struct folio *kvm_gmem_get_pagecache_folio(struct vm_area_struct *vma,
+						  pgoff_t pgoff)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct folio *folio;
+
+	folio = kvm_gmem_get_folio(inode, pgoff);
+	if (IS_ERR_OR_NULL(folio))
+		return folio;
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
+	}
+
+	return folio;
+}
+#endif
+
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
 	.fault = kvm_gmem_fault_user_mapping,
+#ifdef CONFIG_USERFAULTFD
+	.get_pagecache_folio	= kvm_gmem_get_pagecache_folio,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.50.1


