Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1890BF53D9F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1026B038A; Mon, 16 Mar 2026 17:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787FB6B038C; Mon, 16 Mar 2026 17:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6282E6B038D; Mon, 16 Mar 2026 17:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA846B038A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 201771A05BA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:00 +0000 (UTC)
X-FDA: 84553178640.16.CB7CB11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 347E118000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmnL0tjD;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9B3pMfcmhUvrwYQMqWpFT270OgRuERYObMYNPfb0lo=;
	b=vCjmpjz8wlF0DnzuqPEhIZ+MDS2d/R2w7wC50ETR+4g9noGmKE8anl4ISrquL8QGDBszmd
	qq19ZUlSAYZVGdaR+ojSwnbEmV6qt+JLPIyM0mBFYvdbxShbJaMgazu/Q9aZa0LHoSEnn0
	M7tPyNv8NXcym4m9a51KqHgH9dl5wMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695638; a=rsa-sha256;
	cv=none;
	b=hMtwLGe8GxxdNdQm/pFy+1DCm89FQKRZWDSLk82b2odPVbrB7JjFmRTiE4mw33gzhrlvXZ
	zKbDASKnlEoJdvpA03JpTHI0K5yiHJPXtEhcV/9rhG2ea/CTdCyq2V40SAtjamP/WjV5yX
	2z8qoz1Z2XbQmA9UtkfPxATwOElfUU4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmnL0tjD;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FA3F417B1;
	Mon, 16 Mar 2026 21:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6DBC19421;
	Mon, 16 Mar 2026 21:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695637;
	bh=Ety6uMqPsqMphsUZjHWQlJPo7xJz901fcYuIgrq0DKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmnL0tjD2LjXqkscja+qK+o5w7KYcx1X3tNZZE+4s6jUiRbSKxC975NUisVAyfni6
	 ZPAgYMCz590lP0FEbj4vo4otQhWUiDSpzm4M+SQVKlLbHX4QVH9StZHxUT3cJw1+NW
	 mGc991yrKiEn4hkncIYU5mC8kMkfnkfdNzrr9iLncJ73hWX3VN5JP/d/zQPsM6uquV
	 gJHsvKM4YJ8z2rhjCDfyrDvhGX2EH7g7R9+s2NQqn4s27zAsmYMC+pZq7Edt6YITp3
	 4uRMMAkFqkX1hlYFoHTcFgKZVEb9+zpQOxRY+Pr0qA6jUCQdRny3jjbHKXYBIyrVyp
	 phbu2Trdoa39w==
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
Subject: [PATCH v2 07/16] misc: open-dice: replace deprecated mmap hook with mmap_prepare
Date: Mon, 16 Mar 2026 21:12:03 +0000
Message-ID: <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gngj1esteq9dyohcmxc5ypq81gs56j7r
X-Rspamd-Queue-Id: 347E118000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773695637-715761
X-HE-Meta: U2FsdGVkX1+11pX7FSEZNsT3b4CgqwLkgi6vD+1Xe4kI3gWBfO3zH9/zU6WShqsWK7/xFWnbnODTddOaqjr3bWNEqBdS86/whUiQjSIxs9TucRPGj21EVLb6MRpM6F0MIaVAuZxXK1oLyPCANQGiiKxabYragy62vYLeAPBNYqnX/YLz2xhLcNbxC4w9j4q1KmLsoio+LTYbpOiCrGARTYkUCoEKP3S4z+65/c4zV8LvdRXax5d/i+jygBpV6+sdB5PmMHRZH/7+zXOjttJ39bOnlDmlsi0JG/DoMOYG+PmB3bOxOyj3+sxEaXaPhmXPJwjggR57k6ZNx30p5Z6sEIHRzLmih0DPNv/ix/FgCMwqUUrJl/fIrjVxOGrKn0PvsPsUz3lSE8ikoYAE29Vh6kfigpbiCNgHjm8pIrDSVXczEkTPUDvFBXVEccRVcESy8uCWTDVZR0+zRWB2Q6vBAWwLYA04GAjwtXagyxLOilNLCkicSQc64pvzpvl276ZU59zMvl4X8Bo36rTQZ3ptRonxwzrGXLW2gyo5bsHIxLZbzCiKKdXhGhjZgicMmqmJ7v5hnaXJ/QWoblBiBEqC9g7E+Lih8NjqEWF/UOFLvHJLUYhTgYx9aJYTLGDxne44arBYb8EuhbhMrU2zKttbtc5LqIMVCqvlXqx1519pAJemEHeg1ucSptEmn0zuRVB4UA/x84DQDpm3u0uoj0/pVm/yM/mYaq+JzDIPTHZpQFLKCRvNMWG98BGhN+noyw1yOW5JSylfqRyqStudcntTzq8KVqUjrCLf/itTjEDsSowPtEPog8lyJ46FSWwAohBg4hGuPIv3hEiFw8C1W9JUW6xi2tRAPho1eybz/hfQc6zC4n70yrcr19yCNisFtVut6+yBf1OaXVzT8g9rvb+Lf4QQGg5GahUB+xKuCTNm+nU3oz0yNTg1VWOzwD4/j/BBTHwHnysNGcxK9uUs+2w
 CytVCdBw
 p9ZL5+IeF1HecLT7+ZEUW/v0W4xkGpGs6iDb6XRk1iD7Jv5wxOGus8rMbbje7R3Qco9xVeI86ziky+8Q42DRTA69ooCYOi6siNPXmBIoBI725kKUzLIwLMIGIK2PoW5N0TXt+AbfWGqHlaYw/+Lk2T390nr3W6xdWYgvWL45hPQu57S0P5sCKYHtKr8YEaJLL5J6AUCEVnEHqRTb+V9VDfUsJrqwFv8XXjQeZ3517gv9x+pSCZF1ACa+WNiEAE5gE6kq9HRSiHOmH+1X/k4On6e4c7T09J/PtVd263FvHg62JYO7B9Qq48FJhS6snoeAMpyjLmQd43PlC2FGHB1SSKSOUzH4Sbr8JGozahK2Mxee8VojKnahq9Thpl4kPkRXGGLGwupkUesH+0aLe2BlHLVPfvPcce9jNUqHYCdrEXjJU6fyGdPruwQjyIeC/xXTzQ5ECbUqwi1DrRoW46ftnKI6ZJA==
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


