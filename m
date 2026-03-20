Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD241099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2D76B0088; Fri, 20 Mar 2026 18:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E306B00CB; Fri, 20 Mar 2026 18:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810696B00D0; Fri, 20 Mar 2026 18:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7464E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:41:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AD17B9183
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:02 +0000 (UTC)
X-FDA: 84567913164.25.919BA38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 73897100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9KiFrke;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nK+Y9WEkrPN3nsSCULtr7I5j/rrQAPEfK/nOzwrDhE=;
	b=Pg2KadembDtb1HbjCkzin84WL6GTcfFxdkViv8S27fpmQx7lkT/dVd1R+M2tLb6d9ymYzx
	o2SVCMvHgtDv1lIeKAgoXfaOtmrJGLPKi0keY8S5eeBHQkvS7eDstJkEyxmSziezFGQhgd
	FcolJ1nYHUnm4+swfGgxpxTvTfYOStE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9KiFrke;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046460; a=rsa-sha256;
	cv=none;
	b=jK3oLMURLAWHvtixtogRW0Jt2Qub37Ii46oaz5+swuNrXjXx4megIaE7TsWt6QSFle1IOT
	jXXdUuKmTuFaC935XDSRrKnpLH2JAxKpCwoZxwM4cWgGZLimOshKJmhulVWU8rVu4af+s+
	vZVWKkh7QPQdOMD7GKrWM8UpghnKx5U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5758435D9;
	Fri, 20 Mar 2026 22:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D17C2BC9E;
	Fri, 20 Mar 2026 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046459;
	bh=RbmL9EYUSm+5mPpVtsO49vrMj2KZeRXZE1ebFppsMFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9KiFrke6/pWAK9+oFWd7P9eAYjZDzF870vM+tWk724Ryw4Olx0yNweK87TZ70mz1
	 WyOmWBl28Snml/0ZjgQ3MTDeN7jmfaylo1ES4KeSCQKcJqnD/JoyZdvv5Vyam7SA4s
	 Kmz+ogGB5QCjFjeOkqt4UUNDpHvbUTEmg+OONpPr1XQpNBCfI24BXG0ah+cLWMz7xi
	 BugY6CF2cXfB3GwMfbyce9XHA+WMXsW/t7kVNcyfonju4ZoR40+4/+W3aL/iNiDTRp
	 38FjMrd8mvmNwW7IkW7tGGMljFTpkO6nTKfpE/nmlF4xR3zSVTWbJd17n5Dr64LmUw
	 Lmt7Jo3FLLiSg==
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
Subject: [PATCH v4 19/21] uio: replace deprecated mmap hook with mmap_prepare in uio_info
Date: Fri, 20 Mar 2026 22:39:45 +0000
Message-ID: <157583e4477705b496896c7acd4ac88a937b8fa6.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73897100005
X-Stat-Signature: x541gmzaxiay31x6ewiw14untbxs8xq7
X-Rspam-User: 
X-HE-Tag: 1774046460-598752
X-HE-Meta: U2FsdGVkX18PnoCUWPGHUHzPkHZYLVY42qYzQ7pcmNXTUZohAxvfXbLA7QVtU8DEwVtytBQ69z5lX5oXuvLeXaR9lgc8qIfUx/vq7J92d0LUibTn6NgkrPmKI/1llFG8pWszDGCR1SFBnyugVF0qf8GbsQj8qBxMaVehDab0sFUi8/JB6CCn/btNSCXBANoSbolwSawrwr+B1vz1m1pHOKo3gopSgfgtuNL+G10O/nqvBS2UicUqTblIDhFPMfaPiHkmtlgQzeOC+bVoRSeQidTEqJ0IzWxKN46qih6W8xstkDSJiOegimgJqsdRdDRfOP6FlQi1jeNznQS33O6EQiYjb0notUQh6MpljFGlg33Tpqq3jb3wb99GVRfF2/TXQpfeGwSGpCVuqEopBz+gbgcGcE7ztuHnAicDO91uYeVmb56kSusTYjRzhtXD9CbsUB28y3/O3dn/dFGANgoUk1L4DG5xXCYLNYXYnFrMbl/lITKcwLg6D5D4Bhy2RMT2HZlcCYCunsqCH9yYfT5SyTwupTVHyeKMTA/NuWSs4x+32MSrOg06gDH9PqsQqhG8AJ8hRNXY9IcnrFTK3oAtU9TDm7Fb+uYKaAWvtF/Cpp8sl5pjmNHTEb6p+lJwG3exLzlHREv6RVAOdSlum1Qk0p+mrWnkULmnZXFgxqp8YsjJl+sxfqUbQfd9YXuF3mRDdi3ERjc/aPCBBaWDPso9g4JYUMOAS7YrKuMP7cdWoX4nlW9inV4YKjF04WsXXoSmiwq8JFWEFsNnvtePVcw8RWyMsgy/dOX3xfTqGtSjxfl8s1SF5ylf8GLp8n4JgwrKh9fqWORUTAgjiT2KYZPYX4b4AIehymEXc74SF4aorEhrs4BQwmjgdrrkOOhmkG69DsB/Y9cevGNMu4Dr6oZ3FRfDUG0eqBz1yYNFW9UDapVHXXbOlaCXpxY3OupCB0XStlGne8kYdAgm3QNweTw
 0za6363P
 e6uQOjt/ypJRAcKatiAowZ/fwEoH3P1dPn9CzC8NRtTYBL7D1Uq0pbn94zm17PgEz1Dl43aOJ5ThWENbq/w2lRftWVdbiztGm2i/S7nbLzhBb1USCa6p70w6z4PKhzEwxjhAx5McXw5e3WdhPpC3fp77bn3PWukGf+agIP+fX5dGq5LeYs7co18BgPE3XMd/lvA4ZNX+Jf3HhAJcvNT1bseqFuuCwlE+CLl8XHej8c0wh2R+yQbSI4A6uVFYJGZwLR3eNwlpH4D1jMOirxXU1q4spEUe3LAZP2LE7tFE1YzEa1cE5wZKHaRdtJ6iYQFO77SoCgDSi5Vhf8HDAVmLoXYUXK2aIU1/XOVBFDNWySZ1PKYIx7k+D6XremA//E9XqOUmzSFIk+WX7xKrSBZAgth8rBXQbxPs+lU3cLHzuNfUCx+IrlUiyTun475fp1a76w0WpV2DsxMp77Uz3Gw0yCSP0/L2SYMBkhP3V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update uio_info to use its
successor, mmap_prepare.

Therefore, replace the uio_info->mmap hook with a new
uio_info->mmap_prepare hook, and update its one user, target_core_user,
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
index af95531ddd35..edc2afd5f4ee 100644
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
+	pr_debug("vma_mapped\n");
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
index 334641e20fb1..02eaac47ac44 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -97,7 +97,7 @@ struct uio_device {
  * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
- * @mmap:		mmap operation for this uio device
+ * @mmap_prepare:	mmap_prepare operation for this uio device
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


