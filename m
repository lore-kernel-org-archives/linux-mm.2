Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CEB109190E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA66B6B0565; Thu, 19 Mar 2026 14:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FA06B0567; Thu, 19 Mar 2026 14:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45096B0569; Thu, 19 Mar 2026 14:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3D7C6B0565
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 422EE13B819
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:08 +0000 (UTC)
X-FDA: 84563636976.26.0FAC096
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C2421C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvwse2TY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQ5fcRfRZBqewJhpBVyDo43yFkyuLWkspExiz7UwmeI=;
	b=iQneCAjidkZZsKunjj1hf3STAMxrVcmN8YGZFA1wuZlOdS9BbvZPIngx3/11i2ahCWJ3f6
	CnWKI66BhSZDFg1CkQW7XSUghO0yXu8Ltu80+u0RL7x3NJwlvKLAWpOo/KC6wV5dsdZdFP
	p5OH/pBJTIl7FcfTQs3eWgQO9PWwCpg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvwse2TY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944646; a=rsa-sha256;
	cv=none;
	b=f7daA9O4CQQ+jykl6SzCYLkv82KWRC743sPW6JW+G5qUVIHIgRIa0+eRygRry1dh39nqDi
	Z44djcFlWGhxdLH11a3huMHYwJz0+2ZRapTIJw3g71+GgKnft3EVHoulqdQm/xU1AkPdRw
	6d66okrdKKgLa7M644gceYvnQRQKx3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D2DE4369B;
	Thu, 19 Mar 2026 18:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFBEC2BCAF;
	Thu, 19 Mar 2026 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944645;
	bh=zxWNAJj7O8GtoZ6ysYQIGq3mbn9MaN35AkA3dod/SuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvwse2TYXUyFSEEHXSYnuuMx/6EtWicIHQiNBtjzi9BMylWZnkZolWGYbY1Dm8dG+
	 iZEMNApPU9MiUIMHpNkl/dbTN6gvv/L5XR7vAeSUfPQbNgGc0qi4PAIw+LoNeFQTY7
	 ETXtpSK7lClP5bOuhcNyWpLEH7mMQSWw+sIGyY0cfgoAewXRRByojGGsFCR26P16+3
	 AsVf61sZnPetqHYg9LmjGvD35RA33pP88xZaLa1mVutFMFphplkO2Ast/BoDGGgJku
	 7pPiqFXnb9yA9xPORUBYg0AaceYQVG4OVbOfd5gvitBw3kYujc0gpf7sK4qwnesfiH
	 BbuNePHI8EsiQ==
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
Subject: [PATCH v3 07/16] misc: open-dice: replace deprecated mmap hook with mmap_prepare
Date: Thu, 19 Mar 2026 18:23:31 +0000
Message-ID: <eca64f8c12ea145c9667ab7059ce16c50d919b44.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C2421C0005
X-Stat-Signature: owu6s945omxddxxb3sewee86wq1pakqj
X-Rspam-User: 
X-HE-Tag: 1773944646-108877
X-HE-Meta: U2FsdGVkX18NtSpJiJEOtVe+iAqNdfaZSGB2tubsgilUfL0u8hAWqcazmfm3FNOPV4EqZxuZAehigDaGXszzHMSbz2wkOXBAVF3j2KMX5DkRKQMxt/HqGD3QmSq7td/9Fdynr5vKb1RYqDoIShUsEurt9vAxt1TKDfneo4FRPNcNE47wDIQZC9SyjX6pke9rAU9TtOxhNS3pYcqvBTe9FVG6EeN7QymHLgOPaHuW3Hsz6c7TE0rQLRi3gEuVJtWs+7eAFPSlCD5ZJACzl98+EhDMQizSUj7QcQlDBQs6RJSY2LooYfQ0s0oi2/X14fqH36keRFTKWF2oHlbyuPvpVkhuSpVf5xzxFIskFeti5rcNX7QbFKkiWlWUkXmZZLlJCb9Yn2WRxp2rnxxNCh3fej46KVgGSws9M4l/C7TndaxvMFF6jlO0ZUkbprSAXPW9yO4XnVg/WdA6DtI8vsXTvZHHGAVAuen95ug/H9onBsLcX/YOa62pEJltRAm3GQoVIU1IFd4M0qCODu5P7Omm/Rfj0s1onbDpOEltfXXL+6TPAnZEyL5EZySiJmRZYd0JNC9WTCMnpe6RGUAGkCdWVvTPtn/ZwnsKERB5Gwe9qa803gcWePeBGOX1rLLR4KAC7Va+cFHB9VMiubsAV7P8/m2iQIbcPMiOgj8CUKw47ULR8f2SoGltN1JCwPQ2JmJXCrCR3e6Dm0I5M6UOlEqFk5zVYJW9X/0NtMOdRnsZ+eFvd0Ajg0pi2UI12oYYhuA4kz03qTiXnOe0Ktz6KQ2R3CllBVqSCEMAGxbz7ixz7fj4ULFFVB7N2eOQ9xC8CC/kPUpKd5djndq3fxAKPQ27OkPJciYez89SAStIFYIUKMLLqQKqKgIWpUbwsDUjEvv33uDSH29ZLeRfMx6boBmBBvRp27WTSl7mCcYQ6uwteDxx+92e5op3xsDmSLXgLAt7wlOF5zD8Sm80U/nWOud
 R59I1JJ5
 lW43KEFeyn3FSfq7Nd+t4dt/3rr4SSX+uP2j+rF+LGP3uZe08WMXr58NCyc+UqPZZ+Imu5toYHRHzoUF+W8MAxHIktk7R4LnTFZxdJRxAFVnu2ytHnfVqh1pyFR/KpFg0HvB1QbhMtTFi4z4q3niCJ/+pHAoBF1PFJ4cHZHqdyHFxMCzdgfqeKMwxDwJKvma3jNh8KdJj1nEb+p5ITGlnPb+VM0ptk1En+5BM+6RVyWGVZ391DPoeT/vlw3rT7cAslFvA+kJIjYTBdbWByNTRX2qsQsygxg+URpedn//6dAxrrEu2JcfJus1yw9KDvuDM1FGuYCYFd+Be3Uf0A0egw+bnrrqZ+nmpDdrkXWsGenKiMEDe2Wx9L7J1cY7yvl83lOhe
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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


