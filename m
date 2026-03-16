Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08671F53D9E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBCD6B0390; Mon, 16 Mar 2026 17:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FFB6B0392; Mon, 16 Mar 2026 17:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C106B0393; Mon, 16 Mar 2026 17:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 415F76B0390
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DFE61A05C8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:08 +0000 (UTC)
X-FDA: 84553178976.20.9AF221A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66F0E100002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOpvgf+n;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22u/zPXLif+tmx8jfL6mwxg5k2jKGBmc27j1Epm3TuI=;
	b=c/P8jkwSlu78WhaYPLbAhbPwnp/yGORK0W5XsEK0Vh3w2GnCLZCPY5v89uP4CR4vypxWSq
	8jqY+25bQjnFcl4lGARvlRE4IvGgm8s1mdbLggn+DfK6ovKVk1XzB7U/bUONgT1Z5d5jXf
	bK9SqSsygdsSKduHStVfZT5vJab17bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695646; a=rsa-sha256;
	cv=none;
	b=Qop6q1KwOBTaIUItjq9ibW89ewhOi4yqDz4diirdRVxiSABiD7Q1WEteox/s5PiH58+SuH
	rmjzcKr4hQo8Zc7dJas61nJPp7kOybDtw08cSGw95Ll5Y4ZEin/fC2nWCJV7escrCcJL6Q
	rwErd3OOnKisY+RCht09Q4rEH+kecUU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOpvgf+n;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E950560123;
	Mon, 16 Mar 2026 21:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A443C2BCAF;
	Mon, 16 Mar 2026 21:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695645;
	bh=GSvvK91SQuAGo90FmVnYDSWYlOSBV2oGchryB/VUxUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOpvgf+n0IrRUfwxTPsPjWcWeL2agf7X2Q3cZAX3WMAt3lkVZVATJlBeCGrE//uUQ
	 VntjBcXYomVj18FLQi1d+mHVPk0SbQT5HE9DnQSnA97Gk6TGuFs4SQBKF95PUjw2/l
	 KehKxNDGMLZBV7sE5ZZQ/Fm505cgqDDHgNW2PVMZ+2gDhZSyqaw8l2FWbDMWk0qLMI
	 43UuJnnFI5UbKsvjTmQf/C77Ec7oaNpxQRC082bygg0hBc1z3Jj3/+uBuArC6w3/ry
	 8ybhySHmn2B/Sbgm0DrVSWCB0b2MVrgHjBd1KEfwsWB9MX+Mm40OiGsRNBxZTHDUJt
	 yySLVoVqyamXw==
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
Subject: [PATCH v2 10/16] stm: replace deprecated mmap hook with mmap_prepare
Date: Mon, 16 Mar 2026 21:12:06 +0000
Message-ID: <d34056a65bd387286f4e155d52449106ddc99f78.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66F0E100002
X-Stat-Signature: ppe6x6w94yps8g6d97te55ebwasq4f8d
X-Rspam-User: 
X-HE-Tag: 1773695646-445373
X-HE-Meta: U2FsdGVkX1+c39ts6x0FUDhvXUWpx5Lreu0oDgNFpJqbY7nuzS7Hmxz6PXYMytmSNwjSCKKogeNXLhrBMblLY2i44+zva1EquqfA03OvQLU0ogTTyf6Szvzn7FFReNsNFjq1baOee+iJmLqIgk1iBNbEVmAdnOY8y7qXZukcScbJY0B+Y3gq7XGKjMlk7x+wZLAsE+3MAVzXHqOCvYWxHTcNsAxUbH/kR0p4ARtbJSfv1Y5y5t3sPjzIocBNUv5RlbWHKNVbHLmJNbsFnsP0WKg2fQa9Qkys6oRUjLCq3KoW4QsuLNNk1vYGKyElih/KoG+icDtdp/TLmTtZhFDFIoWhpY6SfkM0sVWcHdWfpXe2TW9sVk5AUl97fiZGV/f5HjSFc+1ijFjUiNqtzFxGxQX1n5QB2DBa+WHU4JLitvBAungf/uUYGc4UzeUJs3xaOMAtUFI9mKeq8sPrjxi0Nntz8a9+j5WtTI0UQKgKaDYGE29eRyq2MRNx2bzhk2UJqRyu8IDYfsw5DR0QZbCO9fTBq/EA0oSkg3hqCwPdoc3J85CawN91oShLjoSZ7w+pNEEXFUjaUZdxE+finmyGJCwFRxDFXF4XmhY4RE4B9gfEzYSLs6jnoctfQ13vWPfk9qQOgmzCIjTIvqeUY15qTCDGt19rGLQzSouBD6qPvMygZGZqS1Pm+jtmNij0wzZiTZeMWs2cDrJV0q7ubIq/By/Bjbikd6mMEz/2m717MWC+OKUEJNeUeEZcW/JIVpVhgrHty+98iPkq61GeFO7FKBhpgF/Y3Rgylk0AD6WW6dzThnXl+BqieOUXKsvf50SbvSggOhltL2JLlvyHMlCZRIcV0QQvBn+K1O2mMWaWutU7547r/7RrgI3H+7mrxkwIUnH2X5Zn3MEEBxdsYwsfnDKjOFg8VgnG31LYJnHqlYVxPwkkjwikFqnCu2ZDpYpD/wfCLcFnnlF1uaN5loW
 0IJVHNBm
 NVkKzxvXqMPGj0Zhpy8ZoHHuhJq0AjT6LuOmHp2DeD/UHiA1Y+MdGdy8gPu9ScHBRvb+qbwyvZIkrDUXOokuftfAhhffj5Qr2d8J6IR9WCtoXWEio9OST2MlEruKP8u/svjBbWIk5jOyzJdRhD328AMzy8uF7NM6C2v0XsO6JfFsUcZwgQgUHwojCZorFVbUePBuk7CXcdiZV35UPwwF7x8TxHEbDVai7fniO0r38PFtJnwMhoeANu+3YkHmGLU5haAdFOHR6CX7ssEujpqkCWD+GAza/Ly+fNbQOfEmJ21VWBgYmTuutDuYLSrmXHR2X1kD6u/HxlUnKnAcz9aY/YW72PYGwXqMwqvMH/ZhkkXkei7wBZ2fHkhWE8EBooCdzNfx5oKnjNGJGGNjg7d0gF7FaIsYj9/Y3lfpBcdXR4ycCae0OFwm0/qGqY4gq2XRiP/x+2YA40OYSw55SArUBabKi4kCSAlgFz65d
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

Also, in order to correctly maintain reference counting, add a
vm_ops->mapped callback to increment the reference count when successfully
mapped.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/hwtracing/stm/core.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 37584e786bb5..f48c6a8a0654 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -666,6 +666,16 @@ static ssize_t stm_char_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static int stm_mmap_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+			   const struct file *file, void **vm_private_data)
+{
+	struct stm_file *stmf = file->private_data;
+	struct stm_device *stm = stmf->stm;
+
+	pm_runtime_get_sync(&stm->dev);
+	return 0;
+}
+
 static void stm_mmap_open(struct vm_area_struct *vma)
 {
 	struct stm_file *stmf = vma->vm_file->private_data;
@@ -684,12 +694,14 @@ static void stm_mmap_close(struct vm_area_struct *vma)
 }
 
 static const struct vm_operations_struct stm_mmap_vmops = {
+	.mapped = stm_mmap_mapped,
 	.open	= stm_mmap_open,
 	.close	= stm_mmap_close,
 };
 
-static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int stm_char_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct stm_file *stmf = file->private_data;
 	struct stm_device *stm = stmf->stm;
 	unsigned long size, phys;
@@ -697,10 +709,10 @@ static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!stm->data->mmio_addr)
 		return -EOPNOTSUPP;
 
-	if (vma->vm_pgoff)
+	if (desc->pgoff)
 		return -EINVAL;
 
-	size = vma->vm_end - vma->vm_start;
+	size = vma_desc_size(desc);
 
 	if (stmf->output.nr_chans * stm->data->sw_mmiosz != size)
 		return -EINVAL;
@@ -712,13 +724,12 @@ static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!phys)
 		return -EINVAL;
 
-	pm_runtime_get_sync(&stm->dev);
-
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &stm_mmap_vmops;
-	vm_iomap_memory(vma, phys, size);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+			   VMA_DONTDUMP_BIT);
+	desc->vm_ops = &stm_mmap_vmops;
 
+	mmap_action_simple_ioremap(desc, phys, size);
 	return 0;
 }
 
@@ -836,7 +847,7 @@ static const struct file_operations stm_fops = {
 	.open		= stm_char_open,
 	.release	= stm_char_release,
 	.write		= stm_char_write,
-	.mmap		= stm_char_mmap,
+	.mmap_prepare	= stm_char_mmap_prepare,
 	.unlocked_ioctl	= stm_char_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 };
-- 
2.53.0


