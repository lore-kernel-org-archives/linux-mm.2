Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F288D1099B4D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE0D6B0139; Fri, 20 Mar 2026 18:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686656B013A; Fri, 20 Mar 2026 18:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5746C6B013B; Fri, 20 Mar 2026 18:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AFA26B0139
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A53314037E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:54 +0000 (UTC)
X-FDA: 84567912828.05.415DA58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 552191C000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mzh/VzNf";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUN6a4cDbvBltK2YEh9SuoE5bXfaETxEpplOZ4ELQ5I=;
	b=K8pxqv6g1mYJDKRjoU3FretChOH1gUJK5EBIqwVL19aoYTUc+ft2HYv3uxl5KGuftCUqHa
	QXP3tK4Q9DfMi6LiTyYe2/H9YZCQIjr1POQr1pKnI4p/0Cbo3OUpRmH6YsQUzyrDqOFDlK
	+4dYqNZGGresNJCcEqhVbLYJR/j+N7s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mzh/VzNf";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046452; a=rsa-sha256;
	cv=none;
	b=kKv9+Msf1jglX9TCWyHDI5ZH859vr9HalmYgMwDmmUuUlXX0sdvJKQB7N+A0duHKBGXJpy
	9CAoG1kvGjVyzSD1E1G+3X0VyJ1NeLnfnZoh8zIgjuYLyBXEN2fRSJTaWQbhX/WFjMeqII
	gVkDhZCQqlMiLnvMhc7a/4abyumB23w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7932C4403F;
	Fri, 20 Mar 2026 22:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA946C4CEF7;
	Fri, 20 Mar 2026 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046451;
	bh=rywd1FEi1wWV4fl3gPPvz3vegyh8dDCmAT13xfhNCIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mzh/VzNfn6owZgsAvp11YUWy6Ov62q3AksJSQPQGotGTLaVk8DUWoGOSIuPJc2Skm
	 GcNkj89ZRfB/AJhumMEGHyopvzejgPPjD5JMAqXv6ekioGaY6Wbgk99VTAfg81a4fg
	 qkbjrAhoW8twMolBCVxcIPE5igQ8FEeeXR8AoONojgL/vaNxVDE2d6TlODG+3M8ZPD
	 kKZ3aDnmBxV3JHk5JTfrvS9Zi8Ur8+j6R+VmxzzEj0iV4hxRnhBbqbqfFaig73ngbW
	 74lFPJeMzaejB5zScvPpsfMbHzCIr0pK3HWGQOCNcfheiHFK860SpEuHrdRp41KD/5
	 m5QwNoosDnA5Q==
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
Subject: [PATCH v4 16/21] staging: vme_user: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:42 +0000
Message-ID: <08ecc1e1d319564fd49b9e9012f994edaff921db.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 552191C000F
X-Stat-Signature: qgx6eimgxy1gqak5furxy4oniubr7dsy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774046452-918351
X-HE-Meta: U2FsdGVkX1+iCC9AK69zaQudqAub8XyuNzRWolPbyEMPZ7fyjfMsVNtiYm+BeKctJa4FZsKbx08z8syEbpF0d1jFWqT7D2GIifwLVUlGLEZ7C2iESYuGJgKaG2BE5sgV6u6rLTl5Qh11jeryTwis1dmk5PBCl+Ri19T9nigRAsYTT4mv6LdE24Xk/xsUaPMhHbA2ATigt0U+vtcFLgwUxp7ikexuvQo7/QjfGuKermvJv9zLOhipyDO2qUnuq1dVQbXIGTMXzhu+T8gX4pW/NPD42GWyOleUV6sHiwPAhor24z2BQIZdZTfP+5pBm4CnFrwS9TulX9+BY9FaPf0E71JHpjvMbo8ld10pSpE7GUtw7QNpVzwAkRagyvaX52op+l+ye9VD+S/y4A2WMCljX+6Zge8Emh5uvnnzQyYyrGn5rPP0++4c/gvuSG9gI1LadXjemlpmunsk79UgnnRMfMVX8d/rUMLXlfj1GJ7spzs+MNrhDYfXO9D4e3UDzyBCNb1rjqk78/sv4s4WHrWf0+2EzfwPg/N+Lhp719amAWIDVixAf+s5ShVieWZYfVRjdEw9VZFETeKeMKcjAmePPz4KRw0+r6mk7ykWcmctJvW4/y10+rd6slhcrbmFUXPZY4Bdm1aqVxQ7cs/czaqnW8xFuYUuLGsA8gjumxtnVig4JAam8zAl49o+KIjxzNGzlIsNh9P/iDGpc2AE1XinZcFmlRkWuo1Rqjuegci4u+yC0rM1GXWt1cOpvqARypvxPctkvehr8TJZOdu6OSQuJ7ssUfOkV9aFwshDlbDylF8e1KfIbUD2bWfPhEqKAk14dKwbvEhBc+5+ji3giS9cKknFww0U27xm7Gd4mWODDxbRLEeF/Yf0qQuHCa/+vPksxoLMBhGG9Z9fXXWEOc6o8T+axlv0Wilja9PUFc0rLppkP8Zt1EQbPhE8YregUBqBCcRw3am5Yc+e+yapg48
 Dbl04oUc
 yFCr+2gKlZYOK5ttxMNWAzqUL74sPm+5jxpZGZk+YnPHlEujz4YbSABRipWH9lg1Q8xLs9TCcNQQsmucngyQLoS+LQLRPTLOxcGEO1Xcr7hlmNdF3raHConB0l+gHdLHcpG4g6Jv9Wf5NnX2B5P3IMSqDJ9q2QxqG5kileXyWA3Bw12elhM0gCNaC5Pb6klYJ2EYxcArzjV9SDvjjTlIEfnfuyTUGSjqgDJF+IuyvYUulSKj6iOMc1DIlhgbs/DbdbpN5KRNDQZx8MjNFyG24wZ1ocIzjvYamNS05D284i5PlVK4ZEv3L7Ai7mKgUAtt8sjgq/uE+cmWQvxPh8e5qXyLxhQubR4x8UssvYol3+G/wdVW65N1s+LTSvg==
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


