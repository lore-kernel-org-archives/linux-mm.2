Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461D4106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE4F6B00B2; Thu, 12 Mar 2026 16:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9799E6B00B5; Thu, 12 Mar 2026 16:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826676B00B6; Thu, 12 Mar 2026 16:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 700316B00B2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E9F313A984
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:24 +0000 (UTC)
X-FDA: 84538548528.27.75E167C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8921A4000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seHyQRKf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XmssX9LZRaQSgn7ev93k/k59Xt+ibqH+EXRh1QbF0Y=;
	b=hqLQdNZbBtPzWjvF78/GANONgW16FWzXqPkpvR1IHSGFYHUJ2MW3a6AXInR8WM3YIOy4xh
	c+2kgbKdfy77MUCU52JwT2rlrDMY9d0Ee6O+iBVCqPK7ZmcjGga5acDd3unDZa3/zTUp4g
	qz939ygDKFgj1/lRr5rjVyNIC8DaMUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347302; a=rsa-sha256;
	cv=none;
	b=MWEbFNUJoX/eWp1t667Fhau6a3j5oFuWch/ayQI51chPiDQnWak+dvhxaAhKakPFQ3vK2R
	MXuHjeQPA/UGcCQQN23mflWWimTy/8GdvmFvcHsxnJP1cyIA2zCmKM+QjiBfOy4o1uGv6D
	bYgqwk60tt9mE6oX/7DDJzTEi04otJU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seHyQRKf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABB0C43204;
	Thu, 12 Mar 2026 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8DDC4CEF7;
	Thu, 12 Mar 2026 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347301;
	bh=c9ukDFMfjwhzlsDJMNmh/uTfuZTbg9jKdguqmYo0LoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seHyQRKfprsXz966V294X+6IfJ1CWwP+Y0wpW00vbCO8EQJItDqXB7+2hMzKpRTiQ
	 hYxn7e7+9UCh7o3hYaUyDJd3fWBLwSLb/VzbQhxY5E1+xRRlNEria4jIf3+0tM1TKj
	 ckVDA5igQCIE50LBljWdQUwotHE2U3Ez8Fc1WnFiB1Q5tfbcqGAHLT9MRgJT+cetd1
	 qLLkVpiJCENrZF2ULSXblNRls2CogOVLNbRgrw3r5a8qG6Yc5kSqUbGJBzNccVlFWe
	 trOGLbrWQHTLqWRwgfKFh12xjS5E2ZkFSoSWmZaKoF/+X7y7oSJo/BOQEakebgTaH7
	 Y/MtwSGbAIzGw==
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
Subject: [PATCH 14/15] uio: replace deprecated mmap hook with mmap_prepare in uio_info
Date: Thu, 12 Mar 2026 20:27:29 +0000
Message-ID: <8673929c7fee995e78c1a703949d4ad53363d678.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 76sq6mdd3qhqrq8fht86mnkknycgy9m1
X-Rspam-User: 
X-Rspamd-Queue-Id: 8921A4000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773347302-606750
X-HE-Meta: U2FsdGVkX19cAB0T+xq5TAjlxL6asbw8nD+a76MXKPN5sTBNRzDHJ+wl+kCryAaZhJSP/XOAqhGKW7GMlOUUE6sgbsAMZ0yjgSxYyTEF8bvFjBx5AM7lJsghKWlmPBgaIjvmkajPSjW8cI2+692DRvYGSJ6g6DWL7F40UYJDtjJKQh2nW4MovQ+9YWdBrp6Z09773LRy2oAdIfuBBlEdLS5LgX/4L9piomnG1PPOz/YC3mfZU8u7EtQHv8BSxd/eTsKjWh4LilCoN91B+GcJosz4vJU39PM/WJsizaAVfNorhtuDbudFAvH/sUH75RzS2CGzsoEke3n1mPz8UQvoWJesIKTX/qz6sNIQNYOd7AzFmub4/0jhwMk6YRw2CBnUzAykkNIx2OA+hpqtGikytPsevmlI6qJbK6j4Zgcf/sN2sW8d6Es5hZknMpyqvZpmz9aZHHn/xd6rb6OzzAIjocE0M+7t2U1Uv3L+RZZ2+abbolYnhRI34tQWT0bGa7abIbgUOpNqQwA0OV+5oiQwVY+pSDxBi0ZRuTvVUP1nfN0GS4QJNkuTb0sTWwVi/SNsZ+jXIcCE9DDkSn38ZoOzG2pZ7MV+4m0CN4kgjNWNcs+JfZKqIjkwYQkxtAEkDvWipMeiY9x4jgjwNe7eLU0mGKmXYB1kYiWEe+AyQDJ1tpPQfig1uRZya12KNhivY43AkV0bFcOYjp6sf5Z/RXHYzSrnYWzt9tQDT6l2SvBkOr1F7YHTubGR3+kN7iaPzM65oS1xjpUbPnTBB31mtwvKUaHxugNEq7kgZzjlySaitygMH5LDM84otmhQ2T/sdR3Ud/VsZWJYOPL4V97LlYqWcY1UK5bMUQOX3Rw09izhAAHFnU2VMMy+F3WEB9Q1KOSNUquswdTpgnOvPiZiEq5k/6kMAKa7TyIdnQN1x79EykqPjGXcaKuw0rpmgY4HMXjOM3t8tZUfSkand9XTfwk
 Az2c5lQa
 Z3uT4N/3wSONpRrEiXaTIpzffeQ2JNI7KvKs6HpqVjhAymnPj5qjwzpoQJJDv3wu7eTumLpZ896ONOjNgpfbO9BrIqpnw52gDpI1++DzGYlM1GPotjmAh+oLWFZuGW3ibLOUH8XpSyiTesb7BBHIT1w4lHao4RUMX7o1AHrYpSKLRcxcfwUtjmKNU830ZOglYzViohqunqJW9bLsugcFHwtSfrI3jsxvgKzplx2buuZRkDQvZMpXPFPJ+FH+rk5PvXQUzokEfWIXgcBUwU0/fcIEgB+jnFDPwj3txIRp6cFW5Ii/0GIjfbfcnZf8IdpQQW3++B4HzHkBNyRwiDZIr1sjhMn5KNtOpS8pb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update uio_info to use its
successor, mmap_prepare.

Therefore, replace the uio_info->mmap hook with a new
uio_info->mmap_perepare hook, and update its one user, target_core_user, to
both specify this new mmap_prepare hook and also to use the new
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


