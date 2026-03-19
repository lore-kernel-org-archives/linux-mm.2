Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B49109190F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505A56B056D; Thu, 19 Mar 2026 14:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD116B056F; Thu, 19 Mar 2026 14:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F23D6B0571; Thu, 19 Mar 2026 14:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9086B056D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F21651A04F7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:16 +0000 (UTC)
X-FDA: 84563637312.11.68EC6AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BF63160008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8MZA6Bb;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r35YOE041kjIYjgv/OQz8KG0qzuYqKZnDI2YsRILJW4=;
	b=HHj6yT6JObL8gZPYJblTwYFgVurfeysFZ7bPUhUYW/5DG/Ajz5pYQa7QvAckGap0Ntrn6p
	M+5m7ShLohRxU+UwmSS4KgHHL7b/08I04usH1XNo55FRbHwWfJpZR0/JRiS3ACbH8zuc2W
	hkXRfYWRQi1gKoyj3Os/Gi1uq4EfZ0Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8MZA6Bb;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944655; a=rsa-sha256;
	cv=none;
	b=Gi5KcWOLW+bkObJGN36zCMPRI+IpNYbkYa8WUNNBq6Sqa9zms18J5LZYx6Jx2bzzD5wKk4
	e5gY/LsLyMTBYQJb5hyCLNZYo3LwrPAsqlfgxaIJ9ItlQbqo3aQbWqecw12T3bCtI3zVff
	YedPY8UD7bF3zrpkhQPbCgutzPUGqFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6919D4397C;
	Thu, 19 Mar 2026 18:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D35C19425;
	Thu, 19 Mar 2026 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944654;
	bh=rC8UhPo2hXOr5FxBAlmEyrOxvDFCNwpWMS0HCPMZ5xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8MZA6BbVpovPBpcDjikiDEKExVRyvFJ1VDdXmorpYbEnFCGlAEoGNfwsBpIITKU/
	 6LPZyq0TxRfFN2m9fuAuDjSaAkbZmwuW0zW9jELmCdtCs6/5y3VVTOhhPrK3vk9sZW
	 xIAwwrNC9rIffajpSStQsB0IRY92EN6ZYJ1YRX+0A39w62Q8aqI/sR48/YP8u6H/QK
	 Y5AQgl+QHTautUDpepeCkBtTsdspYZNm7aah5g+mK7IxublL/6KRC61vi40Jx0LMhp
	 AS3R3HbpjRFmtOeQjR0Pc6mnL+K9k7knc+ijyJK+V0ijCLjONmtEoHRQOBDDTqj7bd
	 lRHO1eTRT6GeA==
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
Subject: [PATCH v3 10/16] stm: replace deprecated mmap hook with mmap_prepare
Date: Thu, 19 Mar 2026 18:23:34 +0000
Message-ID: <f549353e1705dd885de4041e8facf18866c7f7bd.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BF63160008
X-Stat-Signature: gtxpsf8ptw68na31zuorij5z6gx7f19p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773944655-183851
X-HE-Meta: U2FsdGVkX1/vN3SEajkzfSHuJH9YC+3bwXHM+wRfgLTAt/WqHX0kbu3TTHc4T168xkV2ELHpBRQGevUspcyOp6CGLfB2mPf7RZBlv0gHwPoya6bTPTt7ZyisDrjf1MGDe5e7l/Y5x04MFXDEkZkvHVR6ssHrm3QfIVBVNFH33cV8PB3LE5L0265XvE2yCYp93/1TGZDIYPE/vi6arFqPBwX6hz37w3Mp47A9KrSxOX/UUVvXqZi09vPy0GmxPW6bXam9Zp4bUS9Ma7goNlpMMmKPTHOIhxxXykFjSy+Sovnsh8aWfHixW/ree6JKhHE/MR9FBkiFiJZ+S1XCViGw0tAPxupzi815iv59iQfwe4VIKxyt8hYTlpR8SuFXUMKu52dzXnqEOwVYTQK46tYPxvQwrPaItGmiToiEOB5reghEWK3BkOCcVOT65JqK7jqgpViFdB70SuCVmZ3gA1zYMzkd1BGv/YBxNRkXqvmMVHnEHcu/g1LpwYG40ubKSuMfrPZVoslfzy9EqrWY6NwHj8w38wvmMY1KoGzsS5doUUCqGOTnYwjjqdV//naKMpybxxJPndE+jDbLdib9eccE7AK6Vbm0bra06Tb8II6VTvwexXn7c+mEXOuypXpqaY5wfamb8uAkBLgrQ36BMJHYaBvtqR0s7anBr7jwSbRiH84I3x/S0bjlwJ/47XCIeNJAtE785LwJ5S8tKE8wrFiKDkfxBQJU+tX0jTDwiEXiY0RkSRwGmRZRKsE3E30GQ63GuVIr8YLChpLcO6+PZwE6KHi3Ia7pd3hc15cY2Kb4ChYA5LD53elJEzZvdC2fGKfZjKaZtp5JGmg7UJd0sKo5n6bKphQZHPHwP9JxRBh12w453Oce6xrfnLnd0XeehD0NtQtmU9YpGeqGcuQap+4T+1axIlRsjPBsautDoLJ/2+LlILI0VJFUZQB/fBPLGFbZP+cgPYJcGrbcV6wC872
 sw3QHy8D
 uLxJX7dzhq8WafGbGUy9hBeubPZOw5Va8hMJ/zRsPoWso6Q0mtjn9aDSDDODxCYjm5yo1vQMHe1E/OcjS1sTRMVFYp526I+RK5GWSLXNMstvXgMX7UQ8Cz3ady+vV4pb1xFNPYKKqU4Pwd66+JOuY/gLQxtoXiG0zCB2DiUUi+qSad2vCp2XUvlU8yvIRT2EXk7Gtpx2rcqIOF7Q4WHh4KiVpnBiYE9APTYBpdwz+HW50Tm5DDz0OLYuAGUHoFwv1jpWfKwDQm3Gjy/vrluJF426lu2MILB8U7daOOr4qytFWDiLQ/8FCm0vywdfUhb9sh8HklupzxJl+Y/q2rTsQv4VydgbUSXeNmhhtFil5zFSmDH6PrWqLUazSS702vgUgKpXI
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


