Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E898C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F3D8E00EE; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47298E00E4; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83E68E00EE; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97ADC8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:23:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD8F31DAA14
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:22 +0000 (UTC)
X-FDA: 83767264644.27.99D81BA
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4112D40009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LIB6XCvE;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754983401; a=rsa-sha256;
	cv=none;
	b=EVuEy+bdbHLXO19v6wDL9H2ITkewHPeiNbJC213C4ndeAx2uaxTUFncw2xoaOYpUSG/c61
	3fKRcOWlce6MORtpXt9FFMIgvddsjy9400N0qOBGAYHIzdrJi3d7BzomJ3tf6wF97Gpk7u
	reij62AZVgUQwGLAy/+0IO59xjEy5uI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LIB6XCvE;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754983401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aka2tvGvdvr+T6MVzxzapn/JbQtAeasW67ww2wlOOMM=;
	b=wICW1ETS2rsdZGuoZHzo8FwTiAqOFqqiU1fPr8LpTO0/gppQo7bSTTM53UhuyWxG+GvUTM
	e8qU1xZwJ03SjPaf2J0AVlVROezyxD1v/Mjwht7D6tJr7fWl6jG7yCXpOfgli3S+tsZhMg
	nz7Rg1nT+/9IvYMYTIOxICDPFmK1bJw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ak
	a2tvGvdvr+T6MVzxzapn/JbQtAeasW67ww2wlOOMM=; b=LIB6XCvE+rue3Zqmhd
	HLSen+jg4n/Gj4dfQKF+GL493C3pwhNKeIjzxEW8mJaPkpK3wdKBJWIXAERnSZ+u
	JvPu/I0k79YoL8rDjEgBLMPAV8HjH3oUJO8Zzt0z9VNxGCY7IFcp0MWKmHL+Fjc2
	x211Tm5yM4WSk0zny5MKNZiTU=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wC3RSPN65pon26ABQ--.34118S3;
	Tue, 12 Aug 2025 15:22:54 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH 2/3] mpage: clean up do_mpage_readpage()
Date: Tue, 12 Aug 2025 15:22:24 +0800
Message-ID: <20250812072225.181798-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250812072225.181798-1-chizhiling@163.com>
References: <20250812072225.181798-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3RSPN65pon26ABQ--.34118S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxAry3try5ZrWxtFykZF45Awb_yoW5CFy3p3
	9IyFnxurn7G34Sva47Jrn8Zr1SgwnxGFWUZFyfAa4fW34Utw1fu3Z7X3Z8ZFWUtF9rZFn8
	XF4Fqry8JF1DWrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UCeHkUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawKnnWia6QNKpwABsn
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4112D40009
X-Stat-Signature: fo7syogt81jtm46tzx15fujcsqeppzbd
X-HE-Tag: 1754983399-921823
X-HE-Meta: U2FsdGVkX18Rcw52FzBPZMRzzt3yLiWbF4ffUkzLIh6pGV2okSxZv635hpaCHxoq458UAhevg9wJoOItGEGv9+4d5MfuwLGn8KZ0ECascwdn1B2weeG1hSsqpXCdo8jZlQhkFNYG/o1jOubCLHnItPWZ1XTB9Rfot+WAXDYK2/KGgcmvMnhnxxYxJMe1M9WYegt1UcG/ofF4taG4ICcaod59KYLwLJS2keT7rmluDrkuHJEnrCfqZeLgaF83NhFaJfqLvzC2aBInDf0UFPfZNeaN8e1/mvuCzWUjFbebqOP1d0lgwvGB0WjgivvnUZORf9bNq95SW4J2qG97qsNOJk2U2B8LCHFuIqZOIKYQJw1vMFhzs7EL0Yfe1XDNYSAhJ4TGg0XcP7svb63OOQYcmQ1SOwm+3geXDOwklzH91tybbxnE1T+niLMVsz9UMebVt1tdD39XOHnT5ZH2PkU4Xf9xVbrvJ8iY/42rku3PeauRRlseMdA7MSvsR8fSEViIOc6i7wWx0RH5ERfTD1wxzfChZ8fkwS7GKVzZd1tgXgi1qfpSdBnMDY50WVU+Nh3N6kL3t+XTD0bKUL1VycElI+G+1yVJY7l0o7eBnCxa3+57x5GmoC+wSK+nX7VEAYbyZAMOfLs6qElAtU9jjxXFYiiMKfd5VBj+Vypf9nXjjYjWZCHAaVO7U7Lfr3pg97qV1DGCk6ZgPEw9QHJf21qT3voZtEDEa4EF0lPs/Iy8sDxxd2OrsCNoRE4GqARCsd41JSXLq5arUcsltVOgkJMIPU+kHzGZFNGKIjdlkjnHqfLHzRiDkiMGzH6uqPaaTIsQMPp+oqs97bSh1iPZr1ZnqDbSp/Luqyxk3WlR/lcediAk3q5zKa8OZbbKpEG+FvflqfY5ceZ2zH/jALUm53yTEDyxMQ/DAOIL78Fpeg62FkowcZYAhYj5G9W9MyCIQFtugP7JmuXn6Q3rhe4q0jN
 zy5d9fDp
 ZVhqnqX0Utfmb46YNJRuTQEwOuojwXVSNuoTz622kqllFTRIZmSLD4WCXE2zDm6aegOSC1gRi0n08OWDUtg9EGowb8FQGOIjW2IRiv6b+z8iF/vIDSWaLY20vZAiEyo17kcHAWvOMHqrvdL+Ece1SO+XrxWKOLY9kJi0L3O2RjYjz6EkiUUMK64MAGeAT9PZOCQdCyl+DLEqR5IDK9joQP/B8OxD6xTY6dvHjyRIbVkX01s0M+m/HnTdqOGiZIwVJh6ngxY0qEBWCE+JGWLF1RuzS730LqfOWL+FTV+sIYPgAots7rc6MUQ3nTIDXvVnEdEyu9N/IXVvp1hP0pKziI+jfAzqeM/uHsvS8jaoGL7pGhiKTyoozMhwVbmYs7pkiCaXI8uKA58e9KTtkW/FN+v+a5YAYk8tFaMLYUqzkIMBAahU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Replace two loop iterations with direct calculations.
The variable nblocks now represents the number of avalid blocks we can
obtain from map_bh. no functional change.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/mpage.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index b6510b8dfa2b..a81a71de8f59 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -158,7 +158,6 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 	struct buffer_head *map_bh = &args->map_bh;
 	sector_t block_in_file;
 	sector_t last_block;
-	sector_t last_block_in_file;
 	sector_t first_block;
 	unsigned page_block;
 	unsigned first_hole = blocks_per_folio;
@@ -180,9 +179,8 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 
 	block_in_file = folio_pos(folio) >> blkbits;
 	last_block = block_in_file + ((args->nr_pages * PAGE_SIZE) >> blkbits);
-	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
-	if (last_block > last_block_in_file)
-		last_block = last_block_in_file;
+	last_block = min_t(sector_t, last_block,
+			   (i_size_read(inode) + blocksize - 1) >> blkbits);
 	page_block = 0;
 
 	/*
@@ -193,19 +191,15 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 			block_in_file > args->first_logical_block &&
 			block_in_file < (args->first_logical_block + nblocks)) {
 		unsigned map_offset = block_in_file - args->first_logical_block;
-		unsigned last = nblocks - map_offset;
 
 		first_block = map_bh->b_blocknr + map_offset;
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == last) {
-				clear_buffer_mapped(map_bh);
-				break;
-			}
-			if (page_block == blocks_per_folio)
-				break;
-			page_block++;
-			block_in_file++;
-		}
+		nblocks -= map_offset;
+		if (nblocks > blocks_per_folio - page_block)
+			nblocks = blocks_per_folio - page_block;
+		else
+			clear_buffer_mapped(map_bh);
+		page_block += nblocks;
+		block_in_file += nblocks;
 		bdev = map_bh->b_bdev;
 	}
 
@@ -243,7 +237,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 			map_buffer_to_folio(folio, map_bh, page_block);
 			goto confused;
 		}
-	
+
 		if (first_hole != blocks_per_folio)
 			goto confused;		/* hole -> non-hole */
 
@@ -252,16 +246,14 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 			first_block = map_bh->b_blocknr;
 		else if (first_block + page_block != map_bh->b_blocknr)
 			goto confused;
+
 		nblocks = map_bh->b_size >> blkbits;
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == nblocks) {
-				clear_buffer_mapped(map_bh);
-				break;
-			} else if (page_block == blocks_per_folio)
-				break;
-			page_block++;
-			block_in_file++;
-		}
+		if (nblocks > blocks_per_folio - page_block)
+			nblocks = blocks_per_folio - page_block;
+		else
+			clear_buffer_mapped(map_bh);
+		page_block += nblocks;
+		block_in_file += nblocks;
 		bdev = map_bh->b_bdev;
 	}
 
-- 
2.43.0


