Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0171099B4C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994296B0138; Fri, 20 Mar 2026 18:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C216B0139; Fri, 20 Mar 2026 18:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9246B013A; Fri, 20 Mar 2026 18:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA286B0138
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DF8014037E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:51 +0000 (UTC)
X-FDA: 84567912702.11.E31EF80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A0CB88000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDWrE0wg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r35YOE041kjIYjgv/OQz8KG0qzuYqKZnDI2YsRILJW4=;
	b=4H9pFc3dbyWxzgloGKUhrPFl7szAiyIiZXPbBgzpGKIU386gRnDsW1jHZxz7C1WN+KOxSP
	OFRsXmLgt2z+TaWn/POBMt9phwupmLdd6RjkAsbTuCzb2gpGF4uUdk8R8jre/ffZHuSXip
	Xlth66UFlfqX2+SVnv2LWge9YKhSSVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046449; a=rsa-sha256;
	cv=none;
	b=rbIsj0MXm0izk9RKb4jTvE+cmGULldFraASduXV9zwq69dqAFSPs3dwxhPm6y0O2eQyfOO
	7Np9zF8xGw6QKXF8g75bAl9ZzjQ9qsAtpCIQ4j24PLkK95xnWppiEr1ZanJUZ7g+mehCv8
	MwUYtdGqQUjB7hgaO1LUXEt57e7xts4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDWrE0wg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B969142DE6;
	Fri, 20 Mar 2026 22:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063CBC4CEF7;
	Fri, 20 Mar 2026 22:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046448;
	bh=rC8UhPo2hXOr5FxBAlmEyrOxvDFCNwpWMS0HCPMZ5xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDWrE0wgPddZzCp/6MXK6JtMRXwDHcncD6Pj3A0RlrLa9zNX5JGIJM0U9t1UwvBN6
	 twzxYKnGdtV88a0F3yVb7GNg44xifk+XFDGN25B3mLjNPX8FneUvbLeJEQNdtUt+WZ
	 /WH9NUWNCW6kMFTyjb+FmMKLFX2G4JaHL5+eGKdLNhbt7+v595DrvFQy6V7DTdK6hP
	 V0/SMtHmbCkPbpX0kqrB4ikg8rPlyLYqzH6GDsIeQ1eCh6Fq+mPmF+bPpeusN4e5RB
	 MrJLikSOWypIy40O2GVpU9qtXFTnNtyqLTtrhGWOpRG0RADI3LlJbe2hP9kqnW/0Ky
	 XEbXUHAUYlzGA==
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
Subject: [PATCH v4 15/21] stm: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:41 +0000
Message-ID: <9f3d559a264a83cf45518fcf35cc7ef1d7dfd500.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1mfawtwuwfjme4t9qtp1eq3gsgj9db1z
X-Rspam-User: 
X-Rspamd-Queue-Id: A0CB88000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1774046449-478350
X-HE-Meta: U2FsdGVkX1/nTnTdCN7RPcNtnMgODuyDFHMviVdsBxMN4Fzq6Lku+rGUsXqs3hCpBRWZJCyCNyXsRMv4FjcXB7SAZmw6SkNd5QjWitICyqqFJuZEVyHI55sPJRIOwQkhZ1xOhY56MWlxB1pDgcrAsud9nwWFxjqrAmp4CV7+z6/AwXachKEx5IgYQ0Yz/dbz+KJN69xQ2hQhHpRidw6R891LqYfy5cPvQZcu83NuKyS69e1O7tkPKGRUvhSoLNp4WJXo2EDTZzn2JAphaJe/p1BUDTBn5082qR1xpH9/HiSGLr91qghvQMdUr+ENH9S5KLhSLoyr8xOIezaWmO+hH3K4hG9a/Dgfb1f2BI178Wt5mlol4w+Uhkq1Teg1ltUFlk2MHMQl+onKwEswQSBBMINjPZP1GHAMoO41do1xsLQzUVcMNymVCEXTXvvrV126L3RuE49+yATI5Gl8StG5Qpl5+uKcknQGnlSbfV8OTDtS2tC337YXsmJc8dV+/uyep4/++/UL6fKvK97by892IKK0QkFP9+TcbLmJ7HpYOb98O+huYDCrh3TdhZJEr/295Z3NYFr3fMKmm5F7RHqjwQvpngzBkrI0a+Pl1yYTU2It5RiXmYNH86A6wprfB65sXa6vU7ag52nl4gzZIdWKopGj5/Zd5Xdm816CAxHT3RjQs9deemAgNRkoxn7whXeL2QTLnM1kPSup5NVeesfccvTChnYkbiMX9JMsDoncfdqkXpngl4/NNlvukOLMez7BaCIGStHp9jb0wNKvUoiC51FWNkCWaiz9s8aAyksBFEDe/MJLVfkM9j+wy9a+ESnPcARsLIIZSlWs2grDUEMm5SyMKN/uxHymATx7n82gahv9cgyFomhAXO8h+7NfBY/Dm55B5lIhrFxXooD0eXxT8iKghyDh41TlQu+b7UgDnp1vidOWaogYaibgI7HwPcUZ6D9eT8AasIPelTQkDAU
 u8wiAewA
 xMbishP1Ju+TG9B4CoAW4wUJJEEf/K0ScOVqlm4ES2WhKKt0QviRrEqG083U1QWRbs7nfVNSDSUDwegAoigHPzNWG04hPnAmTa6Kscs4pDru6mRkxVGz3ClHOfTwJ2tBoBWc7m9mOrsgf2kXvU8kQcJFGXZi5SodF6whbvP9JSfqlTRjoonNf9nOhgzhKkHS+NnUaydRD4oxGGtFXJdQ9ZKHNaTBlAkbkliEE6LvTrAEwBLjePSBA7Ou1PiWaLW2lwV0iUpZ2uK8QpH2uqMkBtfn43b8FX/dOtS9tg4A6iv9DWFdwcesTeSgs0zDwKR7ptE2QATPYN+lUaO4bTmeH+FudVdauM+jkSA3Uii7+q9xzS59B6VzZtHfTU346EkkA2b+X
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


