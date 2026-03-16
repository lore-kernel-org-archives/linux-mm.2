Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AFBF53D9E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8B46B038E; Mon, 16 Mar 2026 17:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90486B0390; Mon, 16 Mar 2026 17:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7CD76B0391; Mon, 16 Mar 2026 17:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 974BF6B038E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 574B513B394
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:05 +0000 (UTC)
X-FDA: 84553178850.27.16BB939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C7E771C0010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L851tmo5;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7XWGLN4bgXSA3HhWAw68SB9ofPSb8HwBGkDoIXFEGk=;
	b=J8/gBsVeZUYNdVBGJMb5+aSYfAIXUb7Mu7m34SwTl1SdJBxGnenL4cXervlYucZDaRZRaR
	yy0+P1JN+s7rJe2W7jLC5A8JFh8xd65PnTXTQaRTMBZ+Wl81HWEdeadw9pqGRJJjewQx3z
	CrJ+4TllWPIveWACwUPHddTTJLudtnQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L851tmo5;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695643; a=rsa-sha256;
	cv=none;
	b=rK8ieMCd6Cc6eVLjE4uxSRQK85QNRwcDApxWCJIT5Osg8OfJI/Qb/MR1Puv357zeimP4ZA
	YYV4dIKLcl+Gf21zVYD7pqWC7sKsbfrG3WZ5noc69WdGoMl6fW8nfTUpWaT0JccSkOJWqy
	luJb76otKtyRVXRpMsfzKDqXqAjYtvA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32C6B60018;
	Mon, 16 Mar 2026 21:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4068DC19421;
	Mon, 16 Mar 2026 21:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695642;
	bh=xj+/JrCOmW2N2PV/njSsEjr7rELQWaiXJ1jd0LU4DrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L851tmo58ppDwux2Mpnj+FZxbfkIplkdPxJHfycO9WNNDY7sZYeQFCjfwmFU+Fh45
	 aGdDoJEgZUxVMnut+bnWzxTDIaLFOe78WTKM9S7RSFC3uT/xfT05m2ZlAsIq28U4iQ
	 9jurjcxG80MdMhRbbNDlcqmDGC2PrLhOGX0db+AAJ71398lwzDtMCoct5askADFWxZ
	 Io2E/A1jMzOx66Kn0KNQSYKM0bUnjpDpyComzKUDNfkZ0WRcSMiiuaSNzZYs4uNe13
	 XC4FPAahrQJUgC/LkBLaGQJvQxEeZ9GAF5mJk4dBQpoxwjy5s2NZDrJ28uUbyZHkWZ
	 0VeVtepqiNWgQ==
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
Subject: [PATCH v2 09/16] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Mon, 16 Mar 2026 21:12:05 +0000
Message-ID: <e3071ae43af79277d3919bafb71f009694d0854d.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C7E771C0010
X-Stat-Signature: fzjr13w8kntay8xid1yyd9ycqnsy8rj9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773695643-827323
X-HE-Meta: U2FsdGVkX18Vu7IdAjyixbga87j1bUK6bdStzEX+4pFY7o5yMIjP4LkNwCDdVOiF9jqjdNAWaMdlFhnH6bYA6zUcr8RjIrmWq28wRbUY8LbYNidmX9UO/cGNHvQqnVFRysqdZHbQElJ61qgXpGKR2aOxHuoe8CZwgJjZqgvK2DGYYa8+mSstFWgvGrtSN83P4wigJkIf0gd5ao0msnab3FzhuOHuDeP2SQaQ8JLIJ/Lm7Wcv5rEhcz0EuaQIuHMZOhCfBNByvWii22957y5bwNVeMZIsgD1SQoEKiz6Jl7Mh021XMR3JjC64a2wbLn42UoFX8+9AVHk5AuISaTTmbh4u3oLwB+f+7j9OPcKxVsqrgwVd9cuexYv65zTNHYszM6l2acaqR+XRVjlOCGrk+LgBzMXNbnNsvqke3so6r+f7VsBFCNoh6gPyZei8PDli2/Skp6bOj4tWU/nuUHaOvQzYNQVRx1Pf8Q5mwXyvjpXmgD/xufdiqUTFw6Ty378x752FBn9+f3IB2IuNugSdKYDNL87pfp434bUVLjyxg1P4+8ysdbnn0+326b3eyntlRQA6wFLB8JbGvYxjXumCdSE9Ss6+vWSw5MWcGLjuyjK85DWXqC+iCmSIHxI+SmLQJFVIL8HFf2gJcqkk/2MKHbr78xgog8JEQ8EBbfLGm8lGnCdbmQDUu07PldbuzowY8iYW4M/x/7s7euresS7gU2S5oXkMCRNJp1sI0gAMU4SJZSCfL6OszRWhC1xlLvH2XL3E2yfyIyQUk34CRCI6ITLq2vLNS2JPXKBC7NDAZcQJHOP3h2jyvw/++puY9MQYeA1eQ+oix5ljSdqtoeezXbPobvl6MVEICF2p5N7H/NP+3uRSumhJC9Zg9M/e15SWCF6M2CJCHw+rvUs82lk527kfChjLhrx0uvURwyVqMHKFUkC+Vs7o/d1QhyGJLp0AmF2yVkVCO/GcKCekVvG
 s04BRfwS
 XQSrBa3AITGKKSfEtkF5qQ5mYF3DMp+gvCdk5qp+2VT9x/UYufQCCeu52UkpCujInb3kpRkZmTJ2E4m8l8sFkwVKl5JPX8353cKowikurraAeCDMyTYpsxN0lhU3l/nLme+t3C85wOAbnZQu2NmR7jEoKsliLFvdR9SSizMJ6V5KthO//wNKDKMro8JQAt82zSGH4/77wsK7+F+HcLIi5Bl6pIyjePfp2D0tA33Nqf96J8xZe7NGfFh9Az/+8rch2ypVdGGTX/8pQkTljUMkcbAx3iE/JJrfrcaEknLgEN11aQU71ZDldX8SbqEJ/O1NgjkoWsgq/XMEmuFzjIcY6v8YS5Z0Nql2eLsDLdYX90CzZ0JWHj0gvdAr0bp+Wro7ovdWneFv87MvzYL8/lELlX/Z0rR27sZogUEFPzNVB+SaH2O3tPumHXH21fxJ3+cZm0keojjclKwD9f23ud+44D9Bupg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated mmap callback with mmap_prepare.

Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commented
out the CONFIG_MMU part of this function back in 2012, so after ~14 years
it's probably reasonable to remove this altogether rather than updating
dead code.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/mtd/mtdchar.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 55a43682c567..bf01e6ac7293 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1376,27 +1376,12 @@ static unsigned mtdchar_mmap_capabilities(struct file *file)
 /*
  * set up a mapping for shared memory segments
  */
-static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
+static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
 {
 #ifdef CONFIG_MMU
-	struct mtd_file_info *mfi = file->private_data;
-	struct mtd_info *mtd = mfi->mtd;
-	struct map_info *map = mtd->priv;
-
-        /* This is broken because it assumes the MTD device is map-based
-	   and that mtd->priv is a valid struct map_info.  It should be
-	   replaced with something that uses the mtd_get_unmapped_area()
-	   operation properly. */
-	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-#ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
-		return vm_iomap_memory(vma, map->phys, map->size);
-	}
 	return -ENODEV;
 #else
-	return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
+	return vma_desc_test(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
 #endif
 }
 
@@ -1411,7 +1396,7 @@ static const struct file_operations mtd_fops = {
 #endif
 	.open		= mtdchar_open,
 	.release	= mtdchar_close,
-	.mmap		= mtdchar_mmap,
+	.mmap_prepare	= mtdchar_mmap_prepare,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = mtdchar_get_unmapped_area,
 	.mmap_capabilities = mtdchar_mmap_capabilities,
-- 
2.53.0


