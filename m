Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0591091910
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BC06B056F; Thu, 19 Mar 2026 14:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF33F6B0571; Thu, 19 Mar 2026 14:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08A36B0573; Thu, 19 Mar 2026 14:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF6806B056F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7401013B0D8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:19 +0000 (UTC)
X-FDA: 84563637438.23.B6744C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E85DBC0008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/SWFDPp";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUN6a4cDbvBltK2YEh9SuoE5bXfaETxEpplOZ4ELQ5I=;
	b=N/huLBVo2hDhg7MITiFCkL7eRftvhc7vQ5FTtYMLJ3B8k1pAbVlt0NK994rjoPkXit7c0h
	atOus4xYejSFib6tqbq+sP+pN3EUqzO13iL4YtwHkqtEXuc9N+SPtZMUocQUM4tZUbiSmJ
	smmO70529B7XnJpfJVtqiTk7QJW648Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/SWFDPp";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944657; a=rsa-sha256;
	cv=none;
	b=pVeM4Y21Qon7pfTViuJ0wDgvlbIMRs135SqOx1Bfg93nfyRH3gPMMsISF9t7C7pdlJ5Xjw
	Jd59vB/igez9vdRdJsLQ0DEJATcEQgm4+DU/Kd4mxvVyuhwM6GX5X57xxa7g4nOJf6/kpm
	Tha2EdL91mHMfGQMc2/1BQXktfMwi14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E8C560133;
	Thu, 19 Mar 2026 18:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87533C19425;
	Thu, 19 Mar 2026 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944657;
	bh=rywd1FEi1wWV4fl3gPPvz3vegyh8dDCmAT13xfhNCIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/SWFDPp/Ts84cvlaB/Qi1k/S8R+UEuypLUXJ0pIsRslBHhIoc6LyLx6zxeNTpGS2
	 4ez9z6YZdGfCdOHupwQoaziazOmdTwigKVq/6YcauP6xT/Wj2J+lJwnObayLwG/o4p
	 rVpBZsjYL6tjg1BmOwnwNu8eEfK437IBH5lV48arSRDnYHpuCl4p6iyGR4ltslA5Rx
	 32jfbLjVhpZvAVN/CDpGJO+OS+cQHyxm6mAxeuKW/e4ybdlsSn4aZg6b8dnZqpfcbE
	 N76icg80NqYJ3h+Amv1KNS0CrsngojkcjXpTqj50aPg3wyO8dpU3fX0lf6UpR8FVyp
	 fmy0xg50AD3/Q==
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
Subject: [PATCH v3 11/16] staging: vme_user: replace deprecated mmap hook with mmap_prepare
Date: Thu, 19 Mar 2026 18:23:35 +0000
Message-ID: <3cd88c01d1bc8179e98c41c4da0f190d3300b86a.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E85DBC0008
X-Rspamd-Server: rspam07
X-Stat-Signature: uuyjsp4eyjtwtypkhd7ga3ugzuq5ri9n
X-Rspam-User: 
X-HE-Tag: 1773944657-289367
X-HE-Meta: U2FsdGVkX1/ztmUlIWJrMh95kjGWTH4gbXkSlDMX+/WlAutce83JoI/QD2jTfBzjcLUk954XeY7tDtR8WI34ys7I/RtHQPVtLjfPdy45JFpW+uRRZUzKdV4Hrc+YR1KuqV4yDwXNFw6JZjsEbwpTC5aRCL4UMNl16Mcm0LzOdi5rfXuIr70d/T7RSdt60JVBAQ/Agf8RckvpsdUFBltUeCYo5ulgBvfiY3HTpQLRDxstrf0muGpYPg0SplfuLZoU5YQReio63jzZD3MYBXFW83uQ4KYcUFHLY0x5k819eKD9zalGu06/bOCr273rxMIIoAgyDzdwOJLurPsgQ3DH3MYXKPNSXluRb1+iy4IFCjg5ouJXqjgJWfSelnreDkkX9tV3s/zOFxIg2VvekHZilrdMwmDJw0Sg4fIUVCnTZxrgkYWiP/kb7PrSNOvk4+/+LfhRr0TDG+rG4g5rgl1h57uQ7DhgV9yxF3G6Lwlny8h0b84vqecYra4Kvulf4unGXvheIqIaGz1/4luh3Ew+8qAaCcRQx+U1oxMLbfwjUdsheXXLeHQSvA+LOx0TRpCu7zb9xDQskD+I225cZ2BZZxV0kAxyiCn79Walb8l+uUmjedbPfm6fHJlc5DlRFexvUxLTCsjTkrxKSANQBu79/8BXaj7qV+cielG5qBmP809gHHT4FbL3NrhBOAqwVx/kMz85MOnka0azaVSKEgIFc8jkz4PGuwsiJiqO+JGgBA2/crB9CDfoFgoyHkT3S2hM5l5HXkm9O0NlncQD2QB7+7E1pJqfUwjTUJfRjhQUEXf+2zsnsZpnuR3ARFy2zETEM4zEweWUmpg1wa/D2g/cSk9ue7pT5yNxoi0mxwCEHV9Y3xogwScsECLoIPPr7hcV7VDRrxOMFu8flZ2INBVl5Z4TIXsBbglX6mqvIxcfJFYPLSNvxTxuiDXrh9g4bq8h4n9RSMwvAcdhzqBpnEJ
 C+wwBCQo
 K9U8EXaF79DPSBsijVMpb6oWIkHBA7HIbbvi9B2CjKqIOgVwP65giMjZK0JeMedcMO0pN91N0T4itXkCSLO9VGNhcXF2UVW84ACRNkyfkNb/BoaKLbJksrtX8SXQ1YjouCrhA5bth2DNoqsQaGFqQ4arbzdsOv7ZmJ2Ngfq66PKqn77HpQToeYCR0H0sUSIhUokr9VOPD3f7Z7z0ptq1UZzW0qQEzNWxryRsiJ2Gry6V24yH7ZwE/J5PXRvH233DkA5vDG2N03hknBIUnxeU9gbX/snmkwRRzSVMJVRAdSgHN2hM/g8l5XaJcEBpJyAVnYr+LwTiFdxAXUZGsxJ0Qo0FFvfqaohGj8ZwxKxUVeE64/6Wr3YpY6yYuxw==
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


