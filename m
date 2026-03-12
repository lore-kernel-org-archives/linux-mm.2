Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A862106ACE9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB0D6B00A3; Thu, 12 Mar 2026 16:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6EB6B00A5; Thu, 12 Mar 2026 16:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920C36B00A6; Thu, 12 Mar 2026 16:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD536B00A3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5483C1B7D15
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:08 +0000 (UTC)
X-FDA: 84538547856.24.48B42A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B83B140017
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8Lr4cy6;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9B3pMfcmhUvrwYQMqWpFT270OgRuERYObMYNPfb0lo=;
	b=sgSRq47OFz3fLOGx7AvOCEJzflFdxT3Mib09797JPswyOKZ0aqtLLhr0ASC1l1POpBHh6Z
	n9TTfAJe3e4lRvOkLWiEgbdpkcPRlfPo+ZHd7LPXlBWN/pQ1aOnQdfGCT7R/ut7nXtwX7u
	6g29h1tlqZUBxcVlX7V+L82LzY7SRXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347286; a=rsa-sha256;
	cv=none;
	b=Rn5Vm+Zyd7PFakKwQ3Iv3gRvz5oMADmnI81syh9QMpKrnT+STm+UN4GV0DWlZTtNhbI78o
	Iqk1sh2a+iN3KiOrusSB2ZD5Rh+RgB9Xej9Lyy5p7oPjLftStH49lvXD0IgqSgAySOQgoU
	/Zc/03Gkuxux+gEBcgiOZUev/D/uSYE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8Lr4cy6;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0C0B44542;
	Thu, 12 Mar 2026 20:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049CDC2BCAF;
	Thu, 12 Mar 2026 20:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347285;
	bh=Ety6uMqPsqMphsUZjHWQlJPo7xJz901fcYuIgrq0DKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8Lr4cy6WpIq5NFpjNJkHw+vaaT5zBpjWw7ea2sJ1hu4elzSc3C40x74CEkq5xY1Y
	 Q+XCS4Xmz+p8a2LUr/gK2AxG79b/5ANj+Dm8VpZpE/ycrhElZJ7fYp+Ydb1iI7sjks
	 2AHRsN1B7zv0ajZoq+/vhPDx2WPyqc/aOt9grFeK5nlxyoHB7qPFPwWaE2kg6Oftss
	 HK64YjkYpdwPendsINx3umhhLQA8GGowKg0BH8krGexcUy9WWvAIJQKjfcmTEz8f/P
	 /cZ2qo8YyD5AeyTGzgbcDMoCDn8v4qphivqaAA7q1C0R0Xh0b1Ii+jexXmgaw0JDAp
	 cqXv2YE7AqCKw==
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
Subject: [PATCH 07/15] misc: open-dice: replace deprecated mmap hook with mmap_prepare
Date: Thu, 12 Mar 2026 20:27:22 +0000
Message-ID: <0d5534f0baa8761795d2d92b1a8bbad08aae5f8d.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xt9oxpb1oizbqga37jqh33chabibmqqe
X-Rspamd-Queue-Id: 8B83B140017
X-Rspamd-Server: rspam03
X-HE-Tag: 1773347286-631967
X-HE-Meta: U2FsdGVkX1+yGzWP5I1xqQEBGoIW26uYUbnFgUOlso8lio3pYZ8Vebo+q7hIDfJ4x7BHp/DhN8oFRxCyfBDxpPX6Fv+RaMOcHIJFzrCdnXkVQUayQ6ml3GlXIUyrYne/nHKSX+nB8XgHIU8wCkaJuabbqkhDIdyieX2wEAPbk3kI6Cf4GIzvkCmhxitV/YsXhc6emq4d9brSGxPtWlHukauHBbABIbgZDWmenF4G3bkFuZb5xlGyPH/+3hOjQGOdV8Q+BVNpbfNLJGurJ01z9LZxVjYCEFrrM3YecDcG1cAqfJDtZq7S2GDobnRaMMBwQ5UbDaNWl5BTtNic8MUpw2OTIDqYvSfSNeaehNlFAXB820/+klgrr8EY1WhyKTKyY1ZvVcxIw7AuxHM7AmfqVpMtPO1HAFexEFPYJbcpnoeEzd88OWXwxKfRq9T/pAHZSUOyC105Y9C2a85C4QGXhAO/tbQqEJwdW/5Jc5rh1O6CYqJMq4RNQ9zrr9/06JViczzICsgXMU6yhNaJkNgn049dV7MuVEDfjrN3Lmnm/NdpMZTQWRrZs6TLbVxmN3MhmZpj0rQ5EgmDO7rYy/OSoTRVWDrReIXMxSx7UkWrtfr4Fd7RluWEg0naxbr3dGELhqC88FarxA16fh+BV63yT/6JCwlChGYwqFKE1GqIfkHFP8LFiosJ84uLdOuXc5LIyQ8DlOpuSEjZD7yXmfKUJqqX29ugDg+/FeDLTb9tOZownyYgYN+zcyPUvzUY+pyF9Q3Bjzhggil4GQ86erlNHtCHIquPLu6Y+Ib+SL19ZkL+6ZFKHaYcAxAqJIz4USiPtugBkcTIHhN18hsapJuMlgLfAFJNE0F3lGldRlG8dijBImZbe4aYwls/6E8Lnwoove8XiHspQlDLiNZhaDvbZtzSduehgxHgRESyYWFBBfLiHiDjs3bnBiuc20NBPi0o8uysSQN7KVORN37YOd9
 g2VhVTYs
 6zu7YNKjOZ5uKt84IbzTqF+4FWZkxMoZNqnOPMoTfFo5P8xuRXcW0Pl/5JlnUH+DW5n+14bDH/YoKRmZ9Lx7GbSgFwISH5dap5zfPp7HRUCMA6v4WnAB+eu1vTvMEds1Xf5j9TQaOw/dBl0gBpKTp3VLvwsdk67eHeHV9D+Qj5w1cj99vxOPjFOC3mJbsc1lv7VzgpUzRdPLbYjxmehBG1McaIzSysDdMQmyIi73BZe2whXT0i15lCKDVAa/Qryiaf+QXy8hMzdBlnxoGq5EB4wmbpYGZnI2tjo9m2gSlKKwdDI5uvFmvbKCcFAT6WV8W2wcA34qkd3eU4AGRguERCVVq7g2x5SToB2YP
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

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/misc/open-dice.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
index 24c29e0f00ef..45060fb4ea27 100644
--- a/drivers/misc/open-dice.c
+++ b/drivers/misc/open-dice.c
@@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, const char __user *ptr,
 /*
  * Creates a mapping of the reserved memory region in user address space.
  */
-static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
+static int open_dice_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *filp = desc->file;
 	struct open_dice_drvdata *drvdata = to_open_dice_drvdata(filp);
 
-	if (vma->vm_flags & VM_MAYSHARE) {
+	if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
 		/* Do not allow userspace to modify the underlying data. */
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_desc_test(desc, VMA_WRITE_BIT))
 			return -EPERM;
 		/* Ensure userspace cannot acquire VM_WRITE later. */
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
 	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
-	return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->size);
+	desc->page_prot = pgprot_writecombine(desc->page_prot);
+	vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
+	mmap_action_simple_ioremap(desc, drvdata->rmem->base,
+				   drvdata->rmem->size);
+	return 0;
 }
 
 static const struct file_operations open_dice_fops = {
 	.owner = THIS_MODULE,
 	.read = open_dice_read,
 	.write = open_dice_write,
-	.mmap = open_dice_mmap,
+	.mmap_prepare = open_dice_mmap_prepare,
 };
 
 static int __init open_dice_probe(struct platform_device *pdev)
-- 
2.53.0


