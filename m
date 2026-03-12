Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C65E106ACE9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD3F6B00AB; Thu, 12 Mar 2026 16:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870696B00AD; Thu, 12 Mar 2026 16:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701BE6B00AE; Thu, 12 Mar 2026 16:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE926B00AB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C85BC1A9B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:17 +0000 (UTC)
X-FDA: 84538548234.17.4DC9E25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC64540006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QS8U48b1;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MzaylRSoV0od+zmumgGmm8GrMCsX12e85QdvFyRDu4M=;
	b=dJQoYjO0sX6Uv4A+2tmvevdjCwOzyWJgrTpfH2xmY8fgkvwK+d9VlX7MEQppuxuB4WHTSx
	6ecHI773vn796Y31s/SaLKR07+HE9COih7LsxUAo2VXgM9y2wQQ9KwxtXeGnCyV5xdBk0w
	LLPCKSicNBSa+mocOBCXRvoZSTuPKNo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QS8U48b1;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347295; a=rsa-sha256;
	cv=none;
	b=JyR8080NaTQE8XVSwYAdp+LGgJK18opdzfpiQtbbKD9so1l95m72wkCpl2rZAFJY/Ma9Nh
	a+ZSbmHnoPlc6CQz6P2M4dk4iWwoZsAN03Z6LkuiPRCetN/t3q/3Z52F6gvNch2vNJgbZ2
	06uDldDJd+UkGnMAanO8r48gs2XdV4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF28B44552;
	Thu, 12 Mar 2026 20:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EF6C2BC87;
	Thu, 12 Mar 2026 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347294;
	bh=2FQWrvwYCkzh7VnGyHG3FIB6cuWllzKv+ct94SBACcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QS8U48b1DoVfHUrxjsa4yUEmtMYEM6tYjFlL0tuUp3bSzoISAi+DJNvqgPtxF75/t
	 iLI3yT7OBczdIeHc/AXP9F8kflIli7gwSkuPI0dCk31W/X2JMmLT1E8dEozgQcp5qg
	 QvQxeP/+fEP/vaG03+5/e9Hv/Gu+/Ja0HBnPwOW9GtlwEtX+mpOJT/zenzj9YsNUJh
	 UYChAElRQWE9ATCslkshyHg0OkPXrd1ziHJvXvZHTAdpK5VPQXBY52gJKfH3MPchjs
	 ioYPcK9iOlgMq5FL1nC/c9F7TLm57EI4yP6WqMhKIggIQcBDCBwninGNjP9Veoe/xB
	 CcueoPncYH0gg==
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
Subject: [PATCH 11/15] staging: vme_user: replace deprecated mmap hook with mmap_prepare
Date: Thu, 12 Mar 2026 20:27:26 +0000
Message-ID: <9494da55a9156fc843fa7b48a7026d219959adf9.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC64540006
X-Stat-Signature: ksw58zd8m1xsze7q5ozga5ehumd755j3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773347295-381994
X-HE-Meta: U2FsdGVkX1+9E7EiYYMSXEKRiPDb2W97ypu4uVZ5VgVwJyic7cV/zbqaRYpBn28JtgGu0nTavotkcO56EM/Kp1S307LTbKFCOLvNUHsNK3z6waPWJydqIH3wgG3H/hRrQZ0o3eTYi8xVrO9VZ6npPXhrfoZS1j+cQ6qnC7vtQohJYRjWWKneLCOTXAoDyXoh1Lmtw1dSHdkELE6XvKR/vFARkI6hJQsuVid47z9pIv8SeYmkrJ/VypjNuTzRO88JnZ31sRP7eybdAGGZRrHTkxfC4HcbiUYxdXrGN1/adR3nPY8kCTRP9nce40kFQiO6gpSgnA/nT+rcDPzYsXlsFUIjblxZcjR5SFQ97wltIjETeqBQ4JkyBCCxpZFfJpYH4k8rl+40O4g3jir4FoTIpn9xC2eXuj0kvcb4KNEqjuIewwipp4xaYpPVR7HoJkzzlosii90HE9hCi53AmQK/DBxmHLgVrbZqbd7I4mojXCEUZQ82XnnD9rS4ZxiF75FkK90OjM8Cx0PgAxY7zYFPEYbMvRyGBghru7uXWN89Rh+3+1ICqrWzWSWwtN3idNLepD9v/d71J5bH0Kiuv95akdo3PN6RgTbxU+j196fgnAhk8WzHPn3yMeTVWwzAr45e6KJA6+N91lUJFupWM9PQElS9npX/ikZPcLPtS1jUJ8/dzKVh+VcsU1xhjMW16rrzLM+Nk6XUG52B7d2AvenXqAfifOFCZreT9XKOCaJmfx/MNlfq0cm6cFy3xHW2NHL5kSH3KgZ3VUV5o04fxv2qmz2K7iHkarLhV0v2CQZrn1BmUNYtl5FpTr9zesutjuSGU+6tOTlp959IuX8cjCSsi/AOTZ2+lMSPugZlnP0MF8MTfm0ae30qEuUOSUEFx3WfF3TirNIAyrsnYhsM8KMh1OYumKk85n815LGi83ceoeINACu32f5qz6Ti9F310AQJ9i9HOM+BdXKsX0lJHwB
 Y68DpWqq
 GbFuGyFoO1MkmTt6Th4LVeiCicHYhoG53KLJFK+D5MMhl/FfEHPc1+D3Y3lyl7TcghyBxyxGRUhPB3QbO3dAU7j0lpw==
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


