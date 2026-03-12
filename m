Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25105106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816126B00A9; Thu, 12 Mar 2026 16:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787656B00AB; Thu, 12 Mar 2026 16:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F106B00AC; Thu, 12 Mar 2026 16:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 555B56B00A9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22BB61403CB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:15 +0000 (UTC)
X-FDA: 84538548150.17.BB93382
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CF7E40012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWsa4YCw;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22u/zPXLif+tmx8jfL6mwxg5k2jKGBmc27j1Epm3TuI=;
	b=HsCZ6PaSSZDtRUzKhARKKfE/HLmpPNjpNrYuyTrGXN1s6fOvx5cHt3+zwOUZ4ZsuRp8/SR
	gtvX9u8JRhasd3ROzdOJ2hDsqFdllZetF+Km/xT0U2+DxcMlDkDUVbs+ZUIc/vu+XH/gXA
	x03fS+VNoMNUlpl/baKVjbUMUaS8YhM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sWsa4YCw;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347293; a=rsa-sha256;
	cv=none;
	b=N/NJmqFER7B7Adg1JU08ZX4gOPyLLFHIgYBhpORp163N9nW8Q/l+zerAqygKg6f+0ywn4g
	xLDtJ6e6AefTWKa0uvA0JUtBowZQtUjkNb4N0ZakD8s25ci+dIsuSzdUVYvsMJrYkffXFU
	nUyadftTPg+N8a8txWrrugVrAGJKgdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7349442A65;
	Thu, 12 Mar 2026 20:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CA5C2BC9E;
	Thu, 12 Mar 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347292;
	bh=GSvvK91SQuAGo90FmVnYDSWYlOSBV2oGchryB/VUxUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWsa4YCwUKUZ6NF6FYl+pCdBC1dxci2Ej9zB0JHhNByo+147eLDUQ5j+WO+JV3dDT
	 HPGMlhtmjp1vUY8qrJhcezjYyDbT6t8kN73X+N7ASnDu1Gs0XVXr5JIkNghq2FJSJq
	 fc0ghbJShYJ4L3gBRp0CQK4fCZfDK0VNeCKnfBCH7R80M78BVItR+Smim/TYIv3o/g
	 j55D8qFvvK06ryl48cViDm7kPX92qwyVcSOZ6lejCdYpmzI6mgUU2UnRDcSu1cKuug
	 ZzB2nNVwTFGi3cqApGKwXIWslumCVtZokUxr7PoiWbDx6tZD6MGmI2dCRDrE26/Mkn
	 qjzCQqiUkRaSg==
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
Subject: [PATCH 10/15] stm: replace deprecated mmap hook with mmap_prepare
Date: Thu, 12 Mar 2026 20:27:25 +0000
Message-ID: <671403f4278a7c77ecbb7617e0bc762536ce25da.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CF7E40012
X-Stat-Signature: 69ddsndzs58wnkizha8gujyz33gsorg3
X-Rspam-User: 
X-HE-Tag: 1773347293-359745
X-HE-Meta: U2FsdGVkX1+DYSTX4aVoZi8NskvwK/WlgbvzEK+B66t5q22FChB8UfZ60bR+VcKshqJaDCYMICRi1vO8VhjzrZncm08Ab+FjYbHA99yjvutjtZ77Y8CWPZf2vZRNyuMouAM9E+s+Q4uNFarcgXvUDF6uBQX5vXVdlNTmrNfxh/q1QaYjGV9pOWsZ7A0ZnYJ1Ed4dpkadzHKOjAU4Hy03QyFvEQN7vMapZCSE4hBT67ND4U4U1Nes1E6RoA09R9ANvD/XeCGSD9R/5eh42RKrc1LYsYMqKS4LyC8HuK64rFBQ71OYr+uvJalm3g2WrYdK3IWO2Hxg65i27a7oaQWezdgyt1kTGLgOGSZWv4K4JE3cvXZrN2ui7b8u46C/VS90QlR07MWeTzxs/YMmSddO92K5tTd+vCm2YPLSJxAxfIFtCWpXN0GjayUcrPLTRCom3BNhFFx9INl9tW5fWSmIQyP0CrvoO7yOuR4/ekJM2Id8L8Dr8ZuUppTIyiufaXKukWm/K4ygsWIW3HsY2yfGoigYXkeqDdj2lOHtiXkSDODlAMg/QbFWwxGtuGsi+3gRdoEpgllwv7OSnyjgZFDZ5/sshhjPrmkPC5dbirOkMQ1ZwRhy3iKoeqAwlaHTtqpTu7pJNN6e+WjY8bCqhzMo6M8DaT/TH2FQN8DEwCheMAA5AvK6bhb6ERKakFLk1uLNNWyizP17r1uRChQ9NgbxvoDnu4jUs4GSMMFcHS9a5pQBX/eyOmxzmNe6j+YdYEM44p/+NE3+aBgXwVbWQjzwHJgFqJEwZSeA+MM+AQrmRW93Lkp7xANB6X2fNifi9jViFuQqqxfwN1iEJikoZ7KQeJnQcHOX/DGTp3Rw74S8VGZxH+6w0PA8XyXRMTAjBAhaqYMyNTduTDzTW25NY18x3XgprifyNCwG5YAAGM/fj5X/cDDy/3Q7dgJTv75zfhRN45zMVaxUys3Wa34+oSx
 10fXGBlF
 Sc5Dw49HlZgpQR5Zojc2LeJIussDP0OHSXUgBqQf8oL/Vb0U+NMPhMbJoxuzdmifGTl+auRm+ehKSQwR9gWvI+lID1Nob2PDf9CV9U9wJNuDhi0FRuWF9uvMhoobRDB66sbo8HvnkQve6onI/8TDCd2mVb7farqjenFHaPmLdpd7FLJL8olRfLf1TdOwLm0oiRu7dtXByIZZ7G7ce/9GhxdFXxHUJFeqbliLpj7Tk/Zn6HLIhhDS7Zdo2HXGD5DkzGH65XDf12frq7KT5Ldop6nQSruibU6zUbIS46Jbd7jt643aY5zeozNdtILaboW34WhMY8rXCABV6ywg2K3koMtXXUWPI/YP5DYE1
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


