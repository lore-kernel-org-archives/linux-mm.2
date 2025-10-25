Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DE0CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C648E0126; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85C78E012D; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0E98E012C; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 751E98E012A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43A1913C5FE
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.01.B79B621
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id DF099A0007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTW+IsYW7kRjDSZvIq5ZbgmimylNW12mUP3Eh1tZBEg=;
	b=Vuz8aCQocHww4wVN57M1bDmxtYphk8M7/QCjmof7fly11/7fEHMMMLih4ReM7cpIEKGxhr
	xCdM6MfNM9HSkkPBWOdppcpsRyDg4MnadCnJLd5GsY8alylxiH0uHlFhTc/wQJhoMXKUNv
	EjT1yDALu8ITCc1ovT4FsXEW2o4NH0I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=ygKBQQXI2d0zRAigdsQV3HRubcX4/SPSAjhGDFoe5fAa+5eJwXYmgNC/Cnpq5pMV547VJp
	GtcU0Xe3VQaCYntGNK8tbFAMGczzXR+LGz+byLMiGohdE3Ex1Lyn4rbSXKqotFdXucesRh
	jZpsCKHuzaFUWry52/xpJGdGWCIQ6VE=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS6LvhzKHMPY
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 95FF71A19E5
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S20;
	Sat, 25 Oct 2025 11:30:04 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 16/25] ext4: support large block size in ext4_mpage_readpages()
Date: Sat, 25 Oct 2025 11:22:12 +0800
Message-Id: <20251025032221.2905818-17-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S20
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rJw4kWr43JF18uw18uFg_yoW8Gw4fpa
	93K3WkGrn7WryS9an3XF1kZrnYga47CFWUJFZ3Xry3Wa47tryfKwnFqas5XF4jqrsxZr93
	XF13Wry7AF4rXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I7QAAsD
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF099A0007
X-Stat-Signature: eqkdq8foq17nid1gxqsx8rwoigfckhr6
X-Rspam-User: 
X-HE-Tag: 1761363013-34427
X-HE-Meta: U2FsdGVkX1/9SbPFLAQqPKW5nqPesimne6PeZwMvIysigwGGXPo9ZoGO9j+G3yxuC6dkdvzTqAXJCLxG/cX0IGxTQvO206Rc9EMbsFPPMXIrZqPMh6IH9IQHX906xEsHSt4HBGQgQoiYFSS2KY9NeCBvCnRJ5nHciAdBLjj3RqQK2eCFYJcqqQjBidQ5k4bsulTW0pQ/8Gg45os1JKN6clyMZA3V7K2buzyd7U9LD/PYj+fHhy6g44gf6t21W5yR3owCrITJA4SVe1bGEQUrmbQUaz4YDt/SkDtlEEL9YlmU7wkdoLclzsqSJlcQyaxpCOlDjMrsO/KYTaedU8U3phFj1/TIPYT8Z87tZkHmZe9Wqe8uDuZyTkaVRUa/MwaFTmY1oLygQYu6iDcZMevvigJFlxj+htNisItmYxiymhU4Hqzfkq4bSp45nQ4vpKONVPFY98svZRqMCHWfWRjatmhSQrHpd+DCDqJnneVz4j1mneMTKdGGmkPqnc4DJD0evmP6GZdsQCwNbELM/LcDhAs+6aPaMSV/bI1u9VJzr+oTllb7LXorcAtQQwGonOqcsDyPWqtwN2AqqjN680Y3Ey4SEFnU/kOfObJs1UFbqj34QwY69+aMjR51yQAOWlKQSw+NBnhvfgpza1Nrayiir22/9DP4cJVyPftQhjy36ypRvMC4gZbXlrTrlH52eRAXqiJwAcr2ZCNrtScuxZ1UbT1jIoeGlABkwfyvqsmnxwWbjoy+89TRqkJNa3IxB89Zo6HS3Fkhm9jsEit52a3wVexYdUX/u93MO7Uj5h0jt7nYWMhJUTcv+eyV18HGqSmKfXAnhc8W54Q7OzFyqfx9VekZrrOMo3Usu/GDEWqBE3YvE5a3TrQhUYsYkrbRknwyO5LnHkJ0fJJeL1Vbwt5/DUjOM1ftmes7eWErGdpt1zWyA6LEwMCJrxvh+X7i63JJnt30zeTKUfbXTLXXfgm
 ihWKUSXi
 crx+DYBWSlFRBzlJ3viSwmFCLo+FGpElR/80P79rFnsBQ/3eHzCeTMRaKSTL06iOp5zf8wbZK+82eEfvqHibAo7D/3xV32SPytmwrijpdxbDkIpXnrqU8cP824TueTuxuqBZybQjGNP611E0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Use the EXT4_P_TO_LBLK() macro to convert folio indexes to blocks to avoid
negative left shifts after supporting blocksize greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/readpage.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index f329daf6e5c7..8c8ec9d60b90 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -213,9 +213,7 @@ int ext4_mpage_readpages(struct inode *inode,
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
-
 	const unsigned blkbits = inode->i_blkbits;
-	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	const unsigned blocksize = 1 << blkbits;
 	sector_t next_block;
 	sector_t block_in_file;
@@ -251,9 +249,8 @@ int ext4_mpage_readpages(struct inode *inode,
 
 		blocks_per_folio = folio_size(folio) >> blkbits;
 		first_hole = blocks_per_folio;
-		block_in_file = next_block =
-			(sector_t)folio->index << (PAGE_SHIFT - blkbits);
-		last_block = block_in_file + nr_pages * blocks_per_page;
+		block_in_file = next_block = EXT4_P_TO_LBLK(inode, folio->index);
+		last_block = EXT4_P_TO_LBLK(inode, folio->index + nr_pages);
 		last_block_in_file = (ext4_readpage_limit(inode) +
 				      blocksize - 1) >> blkbits;
 		if (last_block > last_block_in_file)
-- 
2.46.1


