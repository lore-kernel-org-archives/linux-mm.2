Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25479F53D9F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2206B0392; Mon, 16 Mar 2026 17:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875816B0394; Mon, 16 Mar 2026 17:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A426B0395; Mon, 16 Mar 2026 17:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 654C56B0392
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 222E21405F2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:11 +0000 (UTC)
X-FDA: 84553179102.16.7987E28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A33DC0003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JF3FLVvy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MzaylRSoV0od+zmumgGmm8GrMCsX12e85QdvFyRDu4M=;
	b=JvSB14CMQiUBeMtZynfFvFHb54KJKQQjrhNXewL3WhiDkftF0nwIZPgAg9er7oUarX/q/m
	zWL9zqWMiBEkaP3bhUDABTVKbKHO1SHSkTrbgKqC05lSDuPX7TeZpXJwiYss5VKKfl2I6C
	n3V8ogUoetjaZ4Zz6mc7P6NLIMWcX9Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JF3FLVvy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695649; a=rsa-sha256;
	cv=none;
	b=i0mtPlOOr5vVjrX8GfwNKAVohvG3F69+0NzNqyGPQ2oAaX5Xpl2oUIQ9VHK9EgIHfjipOS
	PBakK+tYhuZ2lvIo2KfR8PVxitz05I4gixtjW5tRIMS8uvqntep8JxwPHiDltfT/6ZVVy8
	/6FtPsmiD7TEIr4Jfmiukzr3K7dQORk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84F5A4347F;
	Mon, 16 Mar 2026 21:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E83C19421;
	Mon, 16 Mar 2026 21:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695648;
	bh=2FQWrvwYCkzh7VnGyHG3FIB6cuWllzKv+ct94SBACcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF3FLVvyJGVdZkSE+FdP5FcBEUne8jUO4XSz7moQxYmpOmgJMXXVQCFWkd+Zna1NU
	 He3whoJ4Uxp4evCK1SA8pVH4752aAjCgpoAtA70KmB77QDNH5xfxW1OtYDKbuTglWE
	 8Ixnhn7P96ejRgJB2L+xQMa690n0cpvspUBLjnjy8UD/0DS/IMeuDDPV2CPyPz6d3P
	 setbJNSK027pMm28L7mf39SCjqW8UffXnFvK+CwK7z0QE+3rx/MCvRk+mcjbU2UT8l
	 RijMbEkUU22+Nba7XDA5hJqZZ2h2CQLpLs12DBvGtXoCkx1vlEYA0Y9FjoLlEl3kBs
	 6F5J6duPdbw8g==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook with mmap_prepare
Date: Mon, 16 Mar 2026 21:12:07 +0000
Message-ID: <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A33DC0003
X-Rspamd-Server: rspam07
X-Stat-Signature: ijtgwhjz7jzcesofb1rf1fptg7bbq1p3
X-Rspam-User: 
X-HE-Tag: 1773695649-547309
X-HE-Meta: U2FsdGVkX1/AhEXP+oXWrk+Ct8+jE3dJSEiHiIqaQcqDfyZzC2cEebl68JsIDUgMj+fF7DJdnd2DDD1P1gFlG3h3TBOjh9OC0TdkBxr7GQtQ7Vkc+JoMLuVM/lAapLzq+gou7c92ODbsK1SzC2YWTeLcvq1Qp7HHjjPEqwcqGZTpV3pUwK+BtNcIiCCs+w8EZGMs2mtNi2iiWVuvRvq1JxFNuUMtx0TPTnrt4OYFfLmLFDgUkY2nmF2ysg0NaG7YxnBoGUycxhWz1fTq591ZviTV8Bto5/vz9LlMwJC7A0rIlUmU18IT67ifS7s+/1kZSxSPhJ10ThuqWKyLEH/2aUl9EjhOunS+fq/vXHLpK0l4lkYVhLVCQq7A9tlNRLJhzu4DBGY+V+2yUNulDo/KVbBS9BON8jXAifjVDrWFDBhJYcXU9gLwiHf7Zzh9haEq/MsurXq9GvvIWqvLhmsPeIvInYBZ00Ac/8sxklZ7Lr/cMG1s0EOGwOzfcdv51qtmnTeUTKt+bYc7XeB6BRDTU8xKP4QE2w+miGDaPVZhwZ7EziqeYfZgG7w7Se9qgHtzLeZYSj/aP61MUfHJwTA7CAZ1sslT2rKexPMX9hSE0LJ9rRpJp+hV21NAaVZm2sKK1Q5qA2KIBSuprefd3oPykHRCE/AK62P2AilZgEQuLXH/VSqC5UmHR2f8mj/N65J3HnQt9kNGUfJkIYHi1Zj0yp+hS/eQXgP4ry4vhR4ZlPf0UGccKFKCoQVTZ1hg5svtOiOMZrKTI8uIzQ6Ur22SxC8sZyuBTpW2RFLrJckPItAIGlJ6h5gB6ZI8TTPpLgK0hYIBATVEcbk50EL7YrjNpH9oxw3iY77/mGWIBayAWMLiwSaFkp2K5WDRuaQ8goPcPxXQHF/bj2jHvGJawS2Qcru76JicQlLacHtexfc43bQ73uf5NyVLueeTNrvU09sRCJzK7UfF5TS2kYnA9Qw
 7g965spe
 HxRyMlC5/w9Yjc/9dISXFZX8gQcnEpXrtWsPr2Jy9iZ4mvkedJLocl9EHZbtiHSi3/uopithYqgCfXCKhUHY69MtWsWa/PMY4fuqJH6RTfOPC/9MDF6PO9SbUML7lfGktHhpWdq960R9glIv/fvjf0fPggTNV5CGyWcL6loPSUGiX4NLzIdX9cX6sHor+MP1Jl3qunu0lAlUPbz/0TS1ibFPRSGBAl2/UE5T19wbSvrOI4RrXf18paWXT8rDETwH8iD6aAPMNH2iHw1KZYghyoMa4YUK+Dju2XwkN6kAGA6bTrFqkd9D5ya99AgUiQg5im0rjIpKG/UIzR0CP7VzwuIeBSCLOBKZahxccUgTLff69dqIGRKLEgdPv0O+3DRB4UghAgg6fFPLEMKY9GKRfK/WhwrVyNHhvMXTxvJBydocVMCXbQxzkHr5FKfsTmwJHW2SQGdKn3hHjeXqOrthY95296Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Functions that wrap mmap() are also converted to wrap mmap_prepare()
instead.

Also update the documentation accordingly.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/driver-api/vme.rst    |  2 +-
 drivers/staging/vme_user/vme.c      | 20 +++++------
 drivers/staging/vme_user/vme.h      |  2 +-
 drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------------
 4 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/Documentation/driver-api/vme.rst b/Documentation/driver-api/vme.rst
index c0b475369de0..7111999abc14 100644
--- a/Documentation/driver-api/vme.rst
+++ b/Documentation/driver-api/vme.rst
@@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be used to read from and
 
 In addition to simple reads and writes, :c:func:`vme_master_rmw` is provided to
 do a read-modify-write transaction. Parts of a VME window can also be mapped
-into user space memory using :c:func:`vme_master_mmap`.
+into user space memory using :c:func:`vme_master_mmap_prepare`.
 
 
 Slave windows
diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_user/vme.c
index f10a00c05f12..7220aba7b919 100644
--- a/drivers/staging/vme_user/vme.c
+++ b/drivers/staging/vme_user/vme.c
@@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask,
 EXPORT_SYMBOL(vme_master_rmw);
 
 /**
- * vme_master_mmap - Mmap region of VME master window.
+ * vme_master_mmap_prepare - Mmap region of VME master window.
  * @resource: Pointer to VME master resource.
- * @vma: Pointer to definition of user mapping.
+ * @desc: Pointer to descriptor of user mapping.
  *
  * Memory map a region of the VME master window into user space.
  *
@@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
  *         resource or -EFAULT if map exceeds window size. Other generic mmap
  *         errors may also be returned.
  */
-int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
+int vme_master_mmap_prepare(struct vme_resource *resource,
+			    struct vm_area_desc *desc)
 {
+	const unsigned long vma_size = vma_desc_size(desc);
 	struct vme_bridge *bridge = find_bridge(resource);
 	struct vme_master_resource *image;
 	phys_addr_t phys_addr;
-	unsigned long vma_size;
 
 	if (resource->type != VME_MASTER) {
 		dev_err(bridge->parent, "Not a master resource\n");
@@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
 	}
 
 	image = list_entry(resource->entry, struct vme_master_resource, list);
-	phys_addr = image->bus_resource.start + (vma->vm_pgoff << PAGE_SHIFT);
-	vma_size = vma->vm_end - vma->vm_start;
+	phys_addr = image->bus_resource.start + (desc->pgoff << PAGE_SHIFT);
 
 	if (phys_addr + vma_size > image->bus_resource.end + 1) {
 		dev_err(bridge->parent, "Map size cannot exceed the window size\n");
 		return -EFAULT;
 	}
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_start);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, phys_addr, vma_size);
+	return 0;
 }
-EXPORT_SYMBOL(vme_master_mmap);
+EXPORT_SYMBOL(vme_master_mmap_prepare);
 
 /**
  * vme_master_free - Free VME master window
diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme_user/vme.h
index 797e9940fdd1..b6413605ea49 100644
--- a/drivers/staging/vme_user/vme.h
+++ b/drivers/staging/vme_user/vme.h
@@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *resource, void *buf, size_t count,
 ssize_t vme_master_write(struct vme_resource *resource, void *buf, size_t count, loff_t offset);
 unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask, unsigned int compare,
 			    unsigned int swap, loff_t offset);
-int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma);
+int vme_master_mmap_prepare(struct vme_resource *resource, struct vm_area_desc *desc);
 void vme_master_free(struct vme_resource *resource);
 
 struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 route);
diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/vme_user/vme_user.c
index d95dd7d9190a..11e25c2f6b0a 100644
--- a/drivers/staging/vme_user/vme_user.c
+++ b/drivers/staging/vme_user/vme_user.c
@@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_area_struct *vma)
 	kfree(vma_priv);
 }
 
-static const struct vm_operations_struct vme_user_vm_ops = {
-	.open = vme_user_vm_open,
-	.close = vme_user_vm_close,
-};
-
-static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
+static int vme_user_vm_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+			      const struct file *file, void **vm_private_data)
 {
-	int err;
+	const unsigned int minor = iminor(file_inode(file));
 	struct vme_user_vma_priv *vma_priv;
 
 	mutex_lock(&image[minor].mutex);
 
-	err = vme_master_mmap(image[minor].resource, vma);
-	if (err) {
-		mutex_unlock(&image[minor].mutex);
-		return err;
-	}
-
 	vma_priv = kmalloc_obj(*vma_priv);
 	if (!vma_priv) {
 		mutex_unlock(&image[minor].mutex);
@@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
 
 	vma_priv->minor = minor;
 	refcount_set(&vma_priv->refcnt, 1);
-	vma->vm_ops = &vme_user_vm_ops;
-	vma->vm_private_data = vma_priv;
-
+	*vm_private_data = vma_priv;
 	image[minor].mmap_count++;
 
 	mutex_unlock(&image[minor].mutex);
-
 	return 0;
 }
 
-static int vme_user_mmap(struct file *file, struct vm_area_struct *vma)
+static const struct vm_operations_struct vme_user_vm_ops = {
+	.mapped = vme_user_vm_mapped,
+	.open = vme_user_vm_open,
+	.close = vme_user_vm_close,
+};
+
+static int vme_user_master_mmap_prepare(unsigned int minor,
+					struct vm_area_desc *desc)
+{
+	int err;
+
+	mutex_lock(&image[minor].mutex);
+
+	err = vme_master_mmap_prepare(image[minor].resource, desc);
+	if (!err)
+		desc->vm_ops = &vme_user_vm_ops;
+
+	mutex_unlock(&image[minor].mutex);
+	return err;
+}
+
+static int vme_user_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned int minor = iminor(file_inode(file));
+	const struct file *file = desc->file;
+	const unsigned int minor = iminor(file_inode(file));
 
 	if (type[minor] == MASTER_MINOR)
-		return vme_user_master_mmap(minor, vma);
+		return vme_user_master_mmap_prepare(minor, desc);
 
 	return -ENODEV;
 }
@@ -498,7 +507,7 @@ static const struct file_operations vme_user_fops = {
 	.llseek = vme_user_llseek,
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
-	.mmap = vme_user_mmap,
+	.mmap_prepare = vme_user_mmap_prepare,
 };
 
 static int vme_user_match(struct vme_dev *vdev)
-- 
2.53.0


