Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976F4C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424D96B0088; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD7C6B008A; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312EC6B008C; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFD66B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ABB81407E4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
X-FDA: 85254083628.17.783EC07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7973F180002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRdie+0Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta6q04SqG77ZrfRud0gsO3OunhTCBwS7cSDfW+2ERJg=;
	b=w/8IT+cMOmTfmjk5khZbdvBBB1X6I3iZi5tq9m1yMhh8zlU+4o9guy6zuiqWgM9f0duA2a
	O3poDXiJ3sPqhVu3HY6u338v5S/fjbWyCiYke/cB02F9OEJurCNh2Xv1TwaLjSN1YdjIe1
	Y7fj7ic09TOZ8YiV40vdoORrlNsbTnU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRdie+0Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383852;
	b=BSMzHG+s4yt1IGBHmBqYCQDoDyIq1Iibiuf5fa0IXu4/pj/m9+mvGYUTqauYD2jGv2fKmG
	t0uTfChUo4DQK9O8Zf1K+P2pdFHzrb+1R6wC9vKK6C+pNDZVZCITmAtXw8gX9yr8eYZcza
	fo1WdZ5hZ4/RiW06YH6YWHxvH5qCUME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87D6A44003;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 597BBC4AF0B;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=fTkXr1PH58eeNZNPaH2qmwD/yxtp1f+/KF5kh5NLTgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hRdie+0ZpmREnkuIKK+hMeNcRwA2kyfpq/iY1BFTq+pZ1Eg0eJwq2VnJLltKjtX02
	 zm7NCcwK+ljy38rUkLHk4bjm7lVgdWoDQIhVj0wfQfnSyrvXhiwFDVW15fiEDjnEuS
	 u+THxQvI+P73J3F+1UuSJxvpqpdqI92LJb0AIo20+oH32pTTvXT5nJy8s8hQ8D0dJh
	 WoitDfJcfMZw1FB7Sa/Fbabz+ITTkYv7f1z1E1MXLQCFxL4iF1AFA/unNi5vd4y1Jr
	 ovPp179RrsC6ILFUG7ar4ADIlbV+sJp/0gAP4i0iu5szkCOhjiOB6LhkYQ+BH6LQzI
	 bC3k19+w6ETPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374D1C98326;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:48 -0700
Subject: [PATCH RFC 01/17] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=7086;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4zUjXqkciNP5pVOu3X+ujVyiBaN7PXZy6uSBphoGXQE=;
 b=XkHp59VeqS8RL4E61uYAPxKL2DZ5g5s2S8hJtxolmOqLmrMCy2RdJD0RsNbhsObqvBW7Nfg9F
 gqw1a2Kxz+cDjXycbvePeE2eDxoj8TV4x+H7krH/KfuL5mAi6RBFuUU
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ff4s41ijwwep1o7wrgrwxhohyhfxwpt6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7973F180002
X-HE-Tag: 1790383852-26929
X-HE-Meta: U2FsdGVkX18Sy1bNFSqDh4FFWtSMgDaOEh9dqZjrNdEbJYdBRkQ8ZIvjsVUph+T7KocnXHktk+AelYLcA8rt8sY4tTHDL/hkW2b6II+qC2BMewz1rfwebVY2qufiM0y8HtngKgcEmVKPZBh0wfMAt367MOJdPNJ3WCtNH00ASddXMMzS3DOe3TgnJUrfIt97ay9fLDIVlDmZcCjKH0aMBQkkk1PrgB8fjfc6HLj6tPLAgWf8HyPHqtWNLIbkpugJQBUxYIA98GxXI1k7biAT95vpe13HqQkhPIjT7cTpCvJorjaC1vT8ZQUda5Kw68FSrwAp6gNav/g/5mJh3SjRa7VdCgeQ/kYhkkDLtG9+BXz00ko7shw+0ui5HIJ4SH7V4d30yH+lZtMAGYFwB6fIct1aMWHA46Tfldf5r1KJPaB94Nadz2ar0VF6I6qYF0HBXhNUloD4K/v/1X/rhW9i5k/9AIC/zy4qzbO6IIS/ZNHXxLc0s+eHmAaQOdlkIWXL2fPKHzkOR5V3AHpY2qFn7pxH6CMEUm8q+aRXwUYtjrpeoZP+qEyzMxkx630/8irNtoZh2EUPLWUaRiuf2nyYglMbqEHly7LK0vfiOsxopq9Vo6HqVhO3q698UTTGfVG/fRmBgXdYx0LtBQ2w1S2kUgP3Q+MCR/WYLN0WT8QymTAqXBrYb8wniDEBF6ek0R51wlAD69AQfzLl0UpgJKNHi+uufD6PGUIW3ImBA+bf7y0wD/uxpWNvBu9YG5YBSmUKejbZb205zAAtrPcKZ11I7qzt1gCW4QPMqshlpNwkEVUOy7PkTMiV1sr+2qof17u2Q8xesXasFuu8E+VN+5MWpYFQPewPWi6XXGo/N26aAt5Jx4ey3Be/MGU4q7VRXV+CzNDi3h8kqV0fdtKu+ohN2fiIolyfHR7z4O0NgvCQce5hpzqOBJ7B6mjmjYPbS2AXeRH0hiKfQQRXuJFK1oi
 aStFDuo7
 yF5ZO/x+KdY3INNwxqZ9AkwBT2EXpbBYJ/J8lSnMUk2gbTeBdGm8rmEjjSvRpsuBPtehmyW8YpAoXZV0Z8pwE1HM1A4pulTSgGAP40Ep46oy+tWgTD/3akuegzJ6oQ3Sbxm24pI1yKYcnrGOzwr1ooujXvRCFp8zsOMXjk7BAM3K8rIISbjVlbzUBco0iNsfNR9oRcMr8hYc6LPHG6N68y1Pe8atRgsHXCdOWvIdSGVcLt4ZU3xrCTKVGYb+7qBPhFgIJIHlmkQO68xZVI49xxubkWZkFo9C4EwLHbb7dCSbMk451Z+hzQp12aTaHnkey8NN8Kgb7gWKgInxQzG5mNYxP6uTiuJgIflhWmoP5OKnEd+zUv10WpQ5b23LE2rlt0OLeo0PgQkP4xUMBQRFIQUSBNkyngvXl77rgGJzc6H35hEpCTG8iZFXdOzJdh18ZsW+wM3PlpxvCgk/kaugxxpwg9H1amqIB/crmg1xl+NZXYLlekKbtjgcz8mjj4NDpy5B5C/uzbEsFuZcD8F+g9qq4ZZOMpjx7NTVz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Implement guest_memfd provider operations to declare that tmpfs supports
providing memory to guest_memfd.

I'm implementing it directly in tmpfs as an illustration, one alternative I
can think of is that guest_memfd (KVM the module) could provide a registry,
supporting filesystems in the kernel, and loaded filesystems could register
themselves as providers.

Would it introduce ordering issues? Like if KVM were loaded after the
provider? Should the registry be built-in to the kernel?

Perhaps another way to key the provider functions could be TMPFS_MAGIC?

I put guest_memfd_provider_operations as a pointer in
super_operations. There might be a better place, to support different kinds
of providers. What do other providers need? Perhaps it's also okay to have
guest_memfd look up in a few different places, beginning with the resource
fd it was provided.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/fs/super_types.h |   4 ++
 include/linux/guest_memfd.h    |  29 +++++++++++
 mm/shmem.c                     | 112 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)

diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ecd96aeb1cee7..29e502439648a 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -37,6 +37,7 @@ struct workqueue_struct;
 struct writeback_control;
 struct xattr_handler;
 struct fserror_event;
+struct guest_memfd_provider_operations;
 
 extern struct super_block *blockdev_superblock;
 
@@ -130,6 +131,9 @@ struct super_operations {
 
 	/* Report a filesystem error */
 	void (*report_error)(const struct fserror_event *event);
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	const struct guest_memfd_provider_operations *gmem_provider_ops;
+#endif
 };
 
 struct super_block {
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
new file mode 100644
index 0000000000000..60eb4f008c246
--- /dev/null
+++ b/include/linux/guest_memfd.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_GUEST_MEMFD_H
+#define _LINUX_GUEST_MEMFD_H
+
+#include <linux/types.h>
+
+struct file;
+struct folio;
+struct mempolicy;
+
+/**
+ * struct guest_memfd_provider_operations - Operations for external memory providers
+ * @attach: Attach to a resource file, perform filesystem-specific validation,
+ *          and return an opaque provider context.
+ * @release: Release provider context and unpin any resources.
+ * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
+ * @invalidate_folio: Notify provider that a folio has been invalidated.
+ *
+ * Used by filesystems and device drivers that provide memory for guest_memfd.
+ */
+struct guest_memfd_provider_operations {
+	void *(*attach)(struct file *resource_file);
+	void (*release)(void *provider);
+	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
+				     struct mempolicy *mpol);
+	void (*invalidate_folio)(void *provider, struct folio *folio);
+};
+
+#endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346f..279f29a9861c1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -38,6 +38,7 @@
 #include <linux/uio.h>
 #include <linux/hugetlb.h>
 #include <linux/fs_parser.h>
+#include <linux/guest_memfd.h>
 #include <linux/swapfile.h>
 #include <linux/iversion.h>
 #include <linux/unicode.h>
@@ -5234,6 +5235,114 @@ static const struct inode_operations shmem_special_inode_operations = {
 #endif
 };
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+static void *shmem_gmem_attach(struct file *resource_file)
+{
+	struct inode *inode = file_inode(resource_file);
+	struct shmem_sb_info *sbinfo;
+
+	if (!S_ISDIR(inode->i_mode))
+		return ERR_PTR(-ENOTDIR);
+
+	/*
+	 * Would like comments: Requiring the root directory of the mount
+	 * provides a less confusing interface, although this is not strictly
+	 * necessary.
+	 */
+	if (resource_file->f_path.dentry != resource_file->f_path.mnt->mnt_root)
+		return ERR_PTR(-EINVAL);
+
+	if (__mnt_is_readonly(resource_file->f_path.mnt))
+		return ERR_PTR(-EROFS);
+
+	if (inode_permission(file_mnt_idmap(resource_file), inode,
+			     MAY_WRITE | MAY_EXEC))
+		return ERR_PTR(-EACCES);
+
+	/* Enforce noswap because guest_memfd does not support swapping. */
+	sbinfo = SHMEM_SB(inode->i_sb);
+	if (!sbinfo->noswap)
+		return ERR_PTR(-EINVAL);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * guest_memfd does not support huge pages yet; this restriction can be
+	 * relaxed in the future.
+	 *
+	 * TODO: Block rebinding with huge page support.
+	 */
+	if (sbinfo->huge != SHMEM_HUGE_NEVER)
+		return ERR_PTR(-EINVAL);
+#endif
+
+	return (void *)mntget(resource_file->f_path.mnt);
+}
+
+static void shmem_gmem_release(void *provider)
+{
+	struct vfsmount *mnt = provider;
+
+	mntput(mnt);
+}
+
+/*
+ * TODO: Consider refactoring shmem allocation helpers to share code between
+ * internal tmpfs folio allocation and guest_memfd provider allocation.
+ */
+static struct folio *shmem_gmem_alloc_folio(void *provider, pgoff_t index,
+					    struct mempolicy *mpol)
+{
+	struct mempolicy *sb_mpol = NULL;
+	struct vfsmount *mnt = provider;
+	struct shmem_sb_info *sbinfo;
+	struct folio *folio;
+
+	sbinfo = SHMEM_SB(mnt->mnt_sb);
+	if (sbinfo->max_blocks &&
+	    !percpu_counter_limited_add(&sbinfo->used_blocks,
+					sbinfo->max_blocks, 1))
+		return ERR_PTR(-ENOSPC);
+
+	if (!mpol) {
+		sb_mpol = shmem_get_sbmpol(sbinfo);
+		mpol = sb_mpol;
+	}
+
+	if (mpol)
+		folio = folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
+					 numa_node_id());
+	else
+		folio = folio_alloc(GFP_HIGHUSER_MOVABLE, 0);
+
+	mpol_cond_put(sb_mpol);
+
+	if (!folio) {
+		if (sbinfo->max_blocks)
+			percpu_counter_sub(&sbinfo->used_blocks, 1);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return folio;
+}
+
+static void shmem_gmem_invalidate_folio(void *provider, struct folio *folio)
+{
+	struct vfsmount *mnt = provider;
+	struct shmem_sb_info *sbinfo;
+
+	sbinfo = SHMEM_SB(mnt->mnt_sb);
+	if (sbinfo->max_blocks)
+		percpu_counter_sub(&sbinfo->used_blocks, folio_nr_pages(folio));
+}
+
+static const struct guest_memfd_provider_operations shmem_gmem_provider_ops = {
+	.attach			= shmem_gmem_attach,
+	.release		= shmem_gmem_release,
+	.alloc_folio		= shmem_gmem_alloc_folio,
+	.invalidate_folio	= shmem_gmem_invalidate_folio,
+};
+#endif /* CONFIG_KVM_GUEST_MEMFD */
+
 static const struct super_operations shmem_ops = {
 	.alloc_inode	= shmem_alloc_inode,
 	.free_inode	= shmem_free_in_core_inode,
@@ -5252,6 +5361,9 @@ static const struct super_operations shmem_ops = {
 	.nr_cached_objects	= shmem_unused_huge_count,
 	.free_cached_objects	= shmem_unused_huge_scan,
 #endif
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	.gmem_provider_ops	= &shmem_gmem_provider_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_vm_ops = {

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



