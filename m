Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94D2106ACEB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3516B00A7; Thu, 12 Mar 2026 16:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAB76B00A9; Thu, 12 Mar 2026 16:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D0D6B00AA; Thu, 12 Mar 2026 16:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B886B00A7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBA711C523
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:12 +0000 (UTC)
X-FDA: 84538548024.04.76A1CD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 251DE140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfGi+MTK;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFYpnfLlnQRxFGQoupXsf9n8oTNd6ajINc2sJmF3X5M=;
	b=xZNBzJ5wnMRSt8kFv/PMoOCeJ369VQ116ouo4WCXxqFBIuAcdY6ehiMswmZJ5Qojar5Atk
	bkj7jDSgyloG6/VYMvd4xy7UlM8s5Rj/XjOISaBqBthR7FnzLjVsL68mkbF5M1oRv8Yx3o
	qffS5rOVrRaBdHLpsMXczLn2auHY1UY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347291; a=rsa-sha256;
	cv=none;
	b=b+Y/3rbmOBhCcaT9kOe46f6tklO/6dEpYQNRkHjzEXB8BV0+pKHsCvCmoGEIDQECI7JQVc
	U5B+mfuwFltp0Z6ZPuaOSVlfwOiv0fsFNf9IiLJWr9Jq4ZK6+HbXWfWGQj1bk+M/D8iPhD
	s1rsEvZknaRUC9Snv6z9ikrUBuTVueY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfGi+MTK;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A5A541665;
	Thu, 12 Mar 2026 20:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA22C2BC9E;
	Thu, 12 Mar 2026 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347290;
	bh=JCZVqkUElmN6+yCXi96nBc4FJ3bPC1rGzZ/PK/wD/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfGi+MTK8J6+mDwEcB2grAiIoBHNi6ToIdSweYX1KKTkIHiX3GURmWNfrAPxerS1D
	 Nh/VkCCCUnOOCtEf13Nb7zc/Q98rW4rch/4GeajMhVO7hPVVQc5xcVK1s25YhJRpW2
	 xYKrvKjtMajgyUtSI4IiXea1EajvOkTjbzEsPPlR9UDH2PcVnhQczcinWoycNGju0S
	 S0yWAgLQ/wAaVAfZXdxfrzJhHe3RVXPuTcwQxxSgJBDJHwR9hb1+Ld+hj3z/82CDeW
	 BLrnwr4XSxCp3KnFGnZtYZxl6LgeP0MJ0NsIPfiShyv/SmPPC3dT3X7Hu3a5Y/5mg+
	 AGWawBzWNWhwQ==
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
Subject: [PATCH 09/15] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Thu, 12 Mar 2026 20:27:24 +0000
Message-ID: <75cdd8bf8833104cb35268a0fe9bd6b969eb8c17.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 251DE140010
X-Stat-Signature: to5rq91c6iisju8emqtixtzyqogzo59m
X-HE-Tag: 1773347290-160470
X-HE-Meta: U2FsdGVkX19bBnuN8BvV4r8S2qK3DbejphJ5FcTyBKwxqye/NPKuX8HxacTBhcHtSrt+5ibd9+1v0q37EtJNPg92EeUfNSjlLQH8DHrSLvgCpvM64h9eHO8PY3AZWseY5K5kiFjLqdENsVNoN+MCMNMrGwKMOJpsal0jMbPFV+JlKjRMfK7YL29yYBid3D3afJyYHIbtRbYVXwCRzrUlnbWFZidvplIV/wnIR9Pw1kCDRFNN9zmGvpRXG37AIHvwD2uWcFKAakr+3+T2sGPTWyxwO9mEWQP54t936I6RW1Zw+rZOClToW0K3nH2i+qt0LLbCXvmMKgNHGgEv1RE8Gp8/LcXWV1mQl5w2xqLIp8j4VYnBMjDxKuRSFZZX+n5a3NpsSEX47iZcWKfGu06D7pOFSRRuqIAdhAcDj4QPDJdehh1AFun+SNroBkrI2ioj2DhXsWjA5QOIIPx2v/0EwjKwOVU1R8LHoDkxaBJHM+M9mEOmOG7VnsAKO1+TMZumYqnqaYOYlPchDNr7kSo2WXT0RblnAvrBBatnZS38mGv47O9rPkEWq7a2ERkE29ZHaFXivoVoIwv16sz+dWPCv0Kpq2aXG5MuVX6w+YY0ZWlkyET7mp94iJHf0iUkxKtRTS9yJ76YLBqgyhvZd0J0cc3wvbmHft7fRjFqKL6lf2J96AqN8wKBw0wETOto/VK25cLl/l3EGQbFQk0rRPJAhbDykOT/Iez/lo3iqPF8SUdMAFxeZqrqNidFpFaVhZhfL6QJH6GiZX8RU1VUmT0XVbvL8aN6v3+wMtWDKhpAbF4FF6WTSSUZIfkAxR8VsWtJoPWGo1Onja+Nc4j9y1eisSWUMTPUfTDRWy/6QCGashAGxZL+hxTbJz33IUOkKT5nIvJX1Dcx9RVioyaBhzwxfF71GIvfNDANZT4VUeFSydnEdiWR2tf7sBqixmGbBkjFp9cn7hnsBX5NBt30Pqn
 pt+HJ2G4
 TgABZPD+eGF76oa4ooZmPw4NyH8jFraJsVqLMqj/xzPaj21Lcbg7s7d6wG3c/wvwaJ+gi6nSeHjlpdMkcMgci5WKmTznXonqjciY0daEy9LVF03IuexYKm5WVm2WtxZrKGcL2RqMTDGVkZ1Rd2f+W98IXmE904oX+Lt5BPiSTgrrc3j5WOQzuwwgI+/cXqzglYTx14A+xgR10aHYe2ewOq6HDBd49aI2ytLJfKCHw+Ty1kFgT/aDFdqH9T9EoGVi97P9hDzCHiu/TIR0IP+THbq9FouQawuCvqHaR1HQDJ3z61+TE6JVoRw9wxUgD/sHWUnnTXLe36nRYy5B7VCOP2BMpTSAlANSMTMl1
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
index 55a43682c567..816ab1ae8b8d 100644
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
+	return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
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


