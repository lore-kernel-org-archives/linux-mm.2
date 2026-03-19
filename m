Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BFD109190F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEA46B0582; Thu, 19 Mar 2026 14:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA51C6B0583; Thu, 19 Mar 2026 14:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F3A6B0584; Thu, 19 Mar 2026 14:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C40A6B0582
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7715E8C11C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:28 +0000 (UTC)
X-FDA: 84563637816.17.F44E44D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC8A62000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Li3vZE+/";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nK+Y9WEkrPN3nsSCULtr7I5j/rrQAPEfK/nOzwrDhE=;
	b=a0IaXOrJqrgvo0kcZR/rT/Og2TSNvDQptg3zdTBYK73Z3dmWvLv0huVUxdNBE9HuGxkpFy
	dPBv2tDy2INEtOmjmU2h+xcUDVrqUiM9evjztl2waT2kqR4zEtwLaCSAB+L/73xjkaRvp1
	1wtZXRsflwT1fkTKfULguQ2l/CFwU2U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Li3vZE+/";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944666; a=rsa-sha256;
	cv=none;
	b=wOt+nQWI/Ei5pmHO75QtZDKL2HE6L9vg3Obk5Zm3ongU4DQt/jHcbf0Yk08tfTFBDJ47n3
	CzVBjMF/PcON/E+8KynQv4Z3g6MvcCQToFInwxMDfbNk6Q/QGel5va+EVu18gnfMoayeTq
	WMx3erFSvM3Cwaj9J9GZbZDBf8PUYds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A28460123;
	Thu, 19 Mar 2026 18:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD20C19425;
	Thu, 19 Mar 2026 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944666;
	bh=RbmL9EYUSm+5mPpVtsO49vrMj2KZeRXZE1ebFppsMFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li3vZE+/Si/AoZBnvM4NobxMzxsIZX6Ut248bBHQWfZdKE7gPmzegajhyMNbUvdiu
	 n0jsjkoZKX51lr5qi2zT8yNVl3HLzObVuPV3wio9zNDOXVxm4z87m+Hi5m3DLG+ib8
	 kOYTPardnhcl3zgOzKqikvzIY4+NZxPUN9G9f5Pocv/ragZCxVs9kk7dNkVbHq5l+J
	 Y0Y4z1uKYhqOUm8MewoNCLIZhcrGvn42rm5lZv+JlivRIEjNdpU8E+qgSv9giYxO0w
	 Qz5yNWwBmUGV1jhNJkc5FhMYFTuOtwdDT7EPTm/goKWFLPDRFB3nZmFdZwRvXlrCLa
	 QMiaODDlA6kxw==
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
Subject: [PATCH v3 14/16] uio: replace deprecated mmap hook with mmap_prepare in uio_info
Date: Thu, 19 Mar 2026 18:23:38 +0000
Message-ID: <22866c41d2886554517f6ebd93b321ad068c8abe.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC8A62000D
X-Stat-Signature: ghjbxq4k9ocehfj8rgn5jczszeb9nf5e
X-Rspam-User: 
X-HE-Tag: 1773944666-7054
X-HE-Meta: U2FsdGVkX1/YtbZU/8XFPAc6wg3gXiqWEPguPNhrNOXYucIWMDcc2RK2R/LOUpQU1OFI80rLjOl/SueTyYSwQmYtdCqdnMIVKmvtJFl1R/rxoOPy/P1KTHgBZBjwGxlp7kpwKtavaOKSDIu8E8eijEabJxpk4LeIoh0R1BkNhnuDnyG0QPCCITDdjLBztAPPdetzLiIQSEI9gQ2oOrKnxSoQl8Gjyfs14z3RE/xGDJzUjBinn8RUIz9mmuEpY4eWgc/WugIedG6YF0rsj6Bz1nvMkzJZygUvmI6xIQ+BM/8+0iaC9DY6cpDjDYLcSFYsVXBBUTo0Q2Fu0/+uqY75tZ06ygWaQkRH5aRz6r/eEEVXun+tXvSRHGY2e7XFqzsBE7CS/8qn5wQSlcJzu+PRuDa+k1wMkyebkMSKTbPtY7SQF/UVKaCYfrSm5lNUIC5I7yz3t1IIRIInKYXTs1UouxE5mWorNzAXcER2/CSZ8/QJ7LHjfLdRRYmD5BJeQ+CgLbvyL1uEkn9tkGLByXF+KIbbiNUiX4qLiNaMtUKbMsQljQueHsgriKNJePI9XxqJbbs3ZDLiTlCl9xUnL+g3nndxZCu/ruuJj8WV2eG/VZ27nmfigNMCL9zaruMqn8Rm9JpBTT0jP+lz3wjWRduEhakJWSYBeN/0wRzdv4HysPK/Mri/ZhBZSfYVvHH2kHpR1ydcn9wL/ixafAjUtypiT5YGOS6g2QRYSPD/Okr27bBMMoT38undWs0tognymqUPLWw9h7QRv5LRR0sUP2+dyS986lGdJxqf6HFgXVjSyGisfzNGH69bh5CRnzvY5OfEtU7Kwwau2tEbI/OtGGWw+sc14soXhnr34dwMw8lRVYJO0c2zu83KIpMe59wi6C6sZhLH7gGwnceFj3E1XYdyeNPaYua2lRd4Wrwa+r5hpNcR8bXSxCnCuF9VoH1xub0+sgVn9ldjHtnH8/1Dt9y
 nyZU2S11
 99xBigBryEbLsLNadKZltb7dxPFuYzJgOl7QOdTC6UTfCL59kuzCJwqzKZVSceh50las40XwkLyY1kwuq36nV1ZUcgCszArPyGd+7blsJOCMRwr4A3FxYJtFPYq85vrtro9dIPxTkZb/nZ15WOsnHoyxbFW9ESArZaBn0pHB62boG9cCruYo9+n6FaqWQWNf3cbo8TgJIj0mOXdYDPmcGFh/rg2kjiY0MmsPcxO8TTulAHMqMt8p4YUJEV2wVZTKdH3j6pQBJQ7B3N+uC78nDQMVsfw57pHmqcgUcMKsupDJr1BT3140PA7kmW9lY2K+jqswyGcoCen8R5Ybk8zpNid/tCNpfUxPfgQ0/jRAjb+YjMeyuc8DhiPNMvcyzmTbNyPc31CG6xZkMfmUAk4TCwaB7CdcfH94LRtwoBjNbTe6lK1GsWPqxEJWDseKNsBDD/uW+VQBWfyi07Y/vjKVC4DfWnWdV7L7AUd78
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


