Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4321099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69256B0136; Fri, 20 Mar 2026 18:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40C86B0137; Fri, 20 Mar 2026 18:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DBC6B0138; Fri, 20 Mar 2026 18:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5AD6B0136
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA66140401
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:48 +0000 (UTC)
X-FDA: 84567912576.20.EA01E8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC4F4180003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K1kclIJD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WJAlWvMvYkS+6WYdocVnt1a4d1lO198hZRen0i5ofk=;
	b=giTTiGyaSqWeg26CCA1WHuTCAF0B0kEnj/Z6oN7mSO745rUke+lRauVe3obSdYRWZZolfD
	2wSnJPVyR2d4i6dND3drfLaj31KWdvhLyhReeQzBCMUFoQ5GeYSMvwtBt0ot1j5Moz2/ds
	fmobswQD39YVKhhww80AA/cyMZtU/V0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K1kclIJD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046446; a=rsa-sha256;
	cv=none;
	b=eUL1OTsQw9+Kl1TzpvZpwjTyA/YXfPUyb+OFhaOj7w6+V4iIaaFyQwkq8nPt9o29MB+cGZ
	B29l8XCXdWC8nSijQA/6AEVctVI+zj3hUH2HFG/xxqSxN7GifuFp4/OvTAUR/U4fokglUA
	NASAnIzyvehK8ak950xRz1GYKpq60UQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1893160141;
	Fri, 20 Mar 2026 22:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCFC4CEF7;
	Fri, 20 Mar 2026 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046445;
	bh=sJsnVE59stSeWATG7qlVuZYBseXJSjXjZYGmtSdmRzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1kclIJDvpcatekEIiKHG9JLd6yodFFlAIimrHkQrYpfpaP1j083wqjfQWuqEPaAW
	 jK/AXSOIeeUMo2zyW/8jErZ2Ttt6yeHOlqzmSnEX0soB69ZhZQPdvd4Kkw+8F1ya/E
	 Bhg55hrFfeQRgRtfiJH31w6IqxgqmTfzjKX9uzowCmnX4LQpdBAredD1TMCm85ytAJ
	 0T4oBFH4/404Ahf7q0mLNvE/PhIzDdEKpljKRgrEXbdFoEF4ZVatPwEanwAbtpUZdQ
	 8XCqkSS7grldEDxzRlQ8cWj2uKIUTeMDSAsVRTzI7glhE0bC9YnNsGvx2Qo2X6+Arm
	 tf/+H4W3fsB2g==
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
Subject: [PATCH v4 14/21] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Fri, 20 Mar 2026 22:39:40 +0000
Message-ID: <d036855c21962c58ace0eb24ecd6d973d77424fe.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC4F4180003
X-Stat-Signature: p8t5y5fobg4d14kcngk89obroigxam6o
X-Rspam-User: 
X-HE-Tag: 1774046446-102687
X-HE-Meta: U2FsdGVkX1/zDlauOC+I/FqE008SdxkBPKRcci2HGxwXi2d+8EA1BBo0agEfgMobWdwnvdoYnFtFbm/n73V0uS0rLghriJtWpQE1qW9WlpveWL5ufEWdgjQO2sBmvNeHinw2RYUDJxgOt6+bg7o/89RuFiq1YHKtwJQq0NBu+QiWsoT/IqqfbM0QlSxoUzvbTodAEeuvjk6OiE/D0oZwX2Auxk7wNP/kaLPQwPHXHVDxo4fZIp/w4sQngxZUZBZxIwuxxb5M2vE9ksNSMCmfvOEFIvbl2pqJRc6/5KBqummtK0g0XgfyqRCDFFFySg0xr0wRbKEgrFDo6LOo3kGmrlMl/SfaFIAbuCt4jJTJeXX747BeC1vA40P9Fg31gOQgsV6625Z0yMUP68Wc8S8IAtbFvV+YkSb+Y06flX15Zq1JpOqVU25BoYFinuhtq8smyjuRI+I65/C8COXMle0pRf0QYmRKFkATnqYELiGuTrNzyk8j+r5uQQ2zZuPzl0x3U4vk1mSDIN53YTGPuQdzIUkveRlcY8IFW2T9oObfayocYR/bMW0rbmh24aKQjUGwL6XzlN/1DAof1TvP90ZztyuTM4TzxEDmHvozAPQuNPqyLzWx8jeUUdVeJtC/zeaFvCEVvJqQPQK/ThWKfuBYk/OO2DD7e+/3ZksHrNhxpzTOo5VhO5hw5czU/K7vKfWy7ZoqQXTRgSQ1OJtKEJy65UpgcYNBPGTi2lIxpUCDL+XEtZk2N6bjuLcPbu/tPHhOtSzrKrFZGRt6BK7GSL8Xj6/Kg6vIFi/Xe5fXm6rI6rpIz967H3iVEgFmqZLYhQU5N9C8rugtx1qSXt7mLZo5T7gXDLQa0rwdph5ufXZflj4pcLUKd3uJQ4Fd1NQl33QjwwoDjNfAzBsA+3HwE7do+hJIChjOoFpbqkzUWgnPCbqDnYANZ5aKKySF8wxih8Q+rmncXztvyT3D91dBdDP
 h6spjflD
 ex72+PDWvS/TPjaz7CBxVcCnRqGa5WZoOqju8xJ+OfXvdvNbitQVdaeRFZRvtoduKRaRlnbGgmWoe1CL9wnq7ivl0WYJkt3Y4/u2YLr741j2jjGf4SFC+F7f9Eca5gQifVFwgXcNXbM93EQnk+xZO1519DKF9iXAdvKavfFltwp3Ltaq7xoPtEEuPXc8acTBB2+V2HMxnPSk7A1vhwd0Hb93/EocNPD4NAFrSa0DbBGBVFcOpKBYqKM8qqJ3IOjtWUKrEHb0G5/ylSD8f7Vi0jvznuadi7tb10Zi7rkXZcjxLIU+VyXkSlsYTOZPItyMbRCEvrYqmd2ZKXJ+ug0RAUWDDBsB+lJdFXq+MtqytAhsONM4D7HXzPHiEJnA6ymI0R5InFWxET3bG1EtgERNMF5yfMe8FBUaXG8pBY1FE373Qys3KwfMksjYJlhtoa0zPDs8berd3MB4124dQFVG6W3ndbw==
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

Acked-by: Richard Weinberger <richard@nod.at>
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


