Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94693F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13546B0398; Mon, 16 Mar 2026 17:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8416B039A; Mon, 16 Mar 2026 17:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E2B6B039B; Mon, 16 Mar 2026 17:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3F426B0398
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C56F8BF22
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:19 +0000 (UTC)
X-FDA: 84553179438.26.C42B3FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBE1818000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9wa1g+q;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KitnuocgZgQg7Ir1VfK22FmdlpgGcxsS4OrRm8gAAo=;
	b=ENAn6Z6HoSq5VgLSgNQ6PfhDBddBHKtzhcOWzWubMCW/LrYSdKRhGiWU5KzAHOsaPdnzSL
	eY5Yevuu7vEBN26uMZ+hDc6WrjqqJnK6RPHxr2hLp78ft7lBLb8B641YG9yk9srFMp69Ru
	JGuuQwZPKeNHUqVkyT1j+qHQ96G4pZk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9wa1g+q;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695658; a=rsa-sha256;
	cv=none;
	b=Dw8Z1DLJZEyuSSTKviIcaTsfNv7RUdYbHvwIbmZbGzA8cxVQdhB5UkNTBzBRKMTqg+gv6K
	1MEACcchm7o+NIZQdaPA07/iJM56+W+3F7C53AwNUvkKytj3eI/jEnFAWNkt6Au7kY3QO/
	dvJIGrxJ9lt9OxYZG0sxGZOePZ9mYyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB0B444501;
	Mon, 16 Mar 2026 21:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B998C19424;
	Mon, 16 Mar 2026 21:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695656;
	bh=fgCpyzFg81kyNJg/EfR9MYplzdNgFwcM7fKHK8x1TBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9wa1g+qYZKP6JvRfHYdd3Mi7gE2gobzLF3Ef0Hpjr5s4CKaZ03ETRYKOxBQksNe5
	 kvq7s2PDuJ1CxtBB2Zbp24YhKCzCA6585G1sYDVP59cf4EQTIvrNaxH6jCTahGeH8+
	 nX2aJven1SgNUxh6mp5GdVaNUBRPKrwHJHJpRPFDvJSR/h0YUmjAWYZI/S+ef9Cxp1
	 TuIHRbmGdEMHNnllEIgEiUsIIGxhRkjTEHGe1m8A0voIHe2vkHveO0bJ2nsGF/BeXt
	 +XAAykshocro6yJ4+7d6BUurBngpzoZH0nPFZ3REHSh7l8WhwsIHx/5WwesU3quOSL
	 ph8COYuLyZSyA==
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
Subject: [PATCH v2 14/16] uio: replace deprecated mmap hook with mmap_prepare in uio_info
Date: Mon, 16 Mar 2026 21:12:10 +0000
Message-ID: <892a8b32e5ef64c69239ccc2d1bd364716fd7fdf.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBE1818000B
X-Stat-Signature: 1mxr5394xgiyuz3zz4ga1i8r41hpn5rn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773695657-761323
X-HE-Meta: U2FsdGVkX1+h9dMOiV6Tym8YDKfQFKZNJ85qG0ryCG0NHWeh7kbmoOpTMA0qT/QqVyJnZcxc0+wdxFMgBFVj6qOTF7sGEwQlGsJtRkQG9KAcxA99d6Csl7wLik8Yzyh1bW1FJXddY0tk36F0k+ow4gmsSuLqVKBgzc+puKKPurXycDB4+QzvyJrBLr+e92zDdrh5lmF2/LwH2AfjaJFoJOoBI93GMgSOGOS/dxUWIjpNyjoQCGeVixk88toto5PONWUL1kI+u7B8DYBLgyBajDZB1+/Ozu+2ZyGVpO8T6iVVwUKFAbB/zboSFtqQq9v0uTqDuhDTqwX5HD2fg0yMuF8G0ls84hNTTL0piIshhu3t7I2JQWq++3x39cIBbexEOSaRw68hnHuymxPxLRhBpDtqewvRFFBwSVT6TqAsY+Ntlr0j0hy6UOGqoFMAWpCJyK3jPeMLLNAz4d146vtmbFW3RFPNTYnZjedioQSWB1BRXxq1N9H4s/Q1QXTvJtoP7/ZImP5RIe9y7gXxWb7bjjlFZTI/pfkS5kZdzujxJUs3dTQ+ftzhEdThgHqy8KqdGo8tQZpTZZyffvDbxcDo/HgtbGEB7ZCvEv0sPiO6jPfHKFbKCc0aB+y4ZbokkCmHZ9Ev5umdD4uKOk3YqaCSL7D2LxM+uf0TM9JvVoFyq7thMI/a/PNOLpl5LIOzRIe1D7TqJGnTLQ6kv8jxYm9QYBJQckiG970qg/5Aho9BFKOAgTB0mHEy+8xJ1zBL9285vJ3EZZMS2I8ZL7HsZ8Gtuy8rX3DRBakQhSos5ojRUSN2dROw1A+P94TbuEvX56om20BmvNxr6aaCzfkLDU8IPaybU72oaSSGKnGvH83wAP+pJlqKWyFF/0EsjTsxOzPOl+YBfo9a9AVuy6m5BFQnFb1P/3SkmbBn855Z8OxewGj3NWEo9Wj4J0edG0hutKVg9pLs2qbdhws7OZFcjFY
 Sj2QpVWJ
 K0E+0JTgcC/Qrns5PCjd+5Z9XqD5vlYGKUiW14dKnD0EmIhBzS//Jvde5vqPujnUn7qzylP5yqmUc7LtQKIMG4GZavY77v12XafrgvcCSsYC9yWWigsheMpm1lkoE5f7Dp8DSoKCtAQYO7ittMc2cjqKscxPnESa72ggoCN3QbMwFT2R1JgYnMTGyJLW4aYVp50M28uPCJaNTrC03iButYn3FLlWQIO7FHpL7HjPUJPWbNIXvqpSzUt0ZSK4WSKoGpe/pXGiKd4ZEWvMe4pnm7iXQc1Z5J4fF6GcIR2uAiuGgi2Z2QCdGyVjxf0ZvgeEjFvTprROwwt980RW3sseEr/pzDHQrOX2+2FJASPssenCRy09Rasg9dBM9g8e48eocgQDQdH22OG+3l6IZwnSS5VMZOA9bMML48xyBlifNnEz6UfHbG5zGL4vt2bT4hfY7xCXAF06BDB76IOjW/f2jBfc25Qo+/C7vYZ26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update uio_info to use its
successor, mmap_prepare.

Therefore, replace the uio_info->mmap hook with a new
uio_info->mmap_perepare hook, and update its one user, target_core_user,
to both specify this new mmap_prepare hook and also to use the new
vm_ops->mapped() hook to continue to maintain a correct udev->kref
refcount.

Then update uio_mmap() to utilise the mmap_prepare compatibility layer to
invoke this callback from the uio mmap invocation.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/target/target_core_user.c | 26 ++++++++++++++++++--------
 drivers/uio/uio.c                 | 10 ++++++++--
 include/linux/uio_driver.h        |  4 ++--
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index af95531ddd35..9d211dad5e53 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1860,6 +1860,17 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	return NULL;
 }
 
+static int tcmu_vma_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+			   const struct file *file, void **vm_private_data)
+{
+	struct tcmu_dev *udev = *vm_private_data;
+
+	pr_debug("vma_open\n");
+
+	kref_get(&udev->kref);
+	return 0;
+}
+
 static void tcmu_vma_open(struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = vma->vm_private_data;
@@ -1919,26 +1930,25 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct tcmu_vm_ops = {
+	.mapped = tcmu_vma_mapped,
 	.open = tcmu_vma_open,
 	.close = tcmu_vma_close,
 	.fault = tcmu_vma_fault,
 };
 
-static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
+static int tcmu_mmap_prepare(struct uio_info *info, struct vm_area_desc *desc)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
 
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &tcmu_vm_ops;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &tcmu_vm_ops;
 
-	vma->vm_private_data = udev;
+	desc->private_data = udev;
 
 	/* Ensure the mmap is exactly the right size */
-	if (vma_pages(vma) != udev->mmap_pages)
+	if (vma_desc_pages(desc) != udev->mmap_pages)
 		return -EINVAL;
 
-	tcmu_vma_open(vma);
-
 	return 0;
 }
 
@@ -2253,7 +2263,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	info->irqcontrol = tcmu_irqcontrol;
 	info->irq = UIO_IRQ_CUSTOM;
 
-	info->mmap = tcmu_mmap;
+	info->mmap_prepare = tcmu_mmap_prepare;
 	info->open = tcmu_open;
 	info->release = tcmu_release;
 
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5a4998e2caf8..1e4ade78ed84 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -850,8 +850,14 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 		goto out;
 	}
 
-	if (idev->info->mmap) {
-		ret = idev->info->mmap(idev->info, vma);
+	if (idev->info->mmap_prepare) {
+		struct vm_area_desc desc;
+
+		compat_set_desc_from_vma(&desc, filep, vma);
+		ret = idev->info->mmap_prepare(idev->info, &desc);
+		if (ret)
+			goto out;
+		ret = __compat_vma_mmap(&desc, vma);
 		goto out;
 	}
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 334641e20fb1..53bdc557c423 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -97,7 +97,7 @@ struct uio_device {
  * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
- * @mmap:		mmap operation for this uio device
+ * @mmap_prepare:	mmap_pepare operation for this uio device
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
  * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
@@ -112,7 +112,7 @@ struct uio_info {
 	unsigned long		irq_flags;
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
-	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
+	int (*mmap_prepare)(struct uio_info *info, struct vm_area_desc *desc);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
-- 
2.53.0


