Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3F0C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16076B00A3; Tue,  7 Jul 2026 14:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDB36B00A4; Tue,  7 Jul 2026 14:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03CC6B00A5; Tue,  7 Jul 2026 14:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68E286B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:17:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D54911A054C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:34 +0000 (UTC)
X-FDA: 84962788428.23.4FF8C4D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B1A140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SmuqzbVw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajN0xgR99tv6l81DifCTyf3GY/vdZ+aOfksjFBPqRjY=;
	b=2e8/a3U85qnAj75cLgdDbehBSrOPQwzyBUGx/JKE5ibn3j0837TDsFqGx4pbS334uVvP0Q
	veOSzwYPnTGMaGO5dkOTU99Z3pb3CE6lFXMOPcLOL9hais+AUSxA1ta9xXc6gKekaQYoaS
	usPZ7DEqh66vp/0wGVzvfgftgm46vZA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SmuqzbVw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448253;
	b=c2C6iKnpSQi5n7i1TkezMeSC/WiVCc3mbIl4R+wflsyGxOTRrV9FAk/h7Q+FGjaAsdtAFA
	4YAay41e4zSHqmFbG9gup+0IvLkm8z8k3pIenvnWHaDtksEDYXeFPZRCaeBrPBMgux4BAk
	CWwQEFNL1sWCjv4ywjy91J1rE9kn9IE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ajN0xgR99tv6l81DifCTyf3GY/vdZ+aOfksjFBPqRjY=; b=SmuqzbVwI2/S8nCHdATorK7DbY
	GupE7/fEnL1QMlnpK525lc/eNFeXeUwpzrbaD8RnnF9BRUMdKv5X63FTnH6MmhpOODjbFC70/sMPf
	rhbmuEMHUYXupuVAkKk+Y4ZDEsVjZGT+e0T51K2aU6rdCZRFPBpSTdcGP2e/gK7fLmctmTCPgKJ1Q
	YuiGcItgtOabNz/Y6aJtSj79MILQv+b/UkZQ8irLSG7CjOH52rXNIfSqVZF1SDc2h6XPzf/YTZo5M
	NqdpQmyRiMrO4JaIm/xFXHlI66WlUt1+QCNYs4TLNta2sibwhhpBh6VGpGWM2mpoA+1151ZQ7KHAd
	tf06ROZg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whAM7-00000000sBe-1k7g;
	Tue, 07 Jul 2026 18:17:15 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] hugetlbfs: Set mapping folio order
Date: Tue,  7 Jul 2026 19:17:08 +0100
Message-ID: <20260707181713.208282-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707181713.208282-1-willy@infradead.org>
References: <20260707181713.208282-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmeu3rha37jnyt3dxjiyygc14ari45fm
X-Rspamd-Queue-Id: 3B1A140009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783448253-928505
X-HE-Meta: U2FsdGVkX18V1QoPKjR7udWxhCcCn8bLQb4zoOdSF0NGErtz2LAVm/ZQFmBkTK6iMgeKw3MN3SsWAPQUPFp6ljqwtgyQKZMwk362dcmw59jffoZd6yCvI299AaTkli0kucN1EHxq/612Wv+bQND3Z2zw9bW+1c5h3FIpB48isvFe7a7lRUsHnAwNyYzdudK9VPWBQn3DypzZAE791tGpcY+SH7Ab7v3L+yhN1+JC7b2+3V/2QoAZPVSNoylVI6bWQBZbl4a3bYwAxZ7SuxwHO7pvzHBJlNrKCowdyT00+jnEfyuvk2i+u7Y6VxIWr5ANJfQtjRn6w8kv6iJ2DcN7I00iRHnI2nh5vlwt34J0a8EsuPQsGsPsrXWavKtrPZBkvhTJuJDiaqymzxEK4sFxpsixMzFmr80xC1MH0YLTAxAbaFlOldB37y6HIhUNT7KrD4Xx5KiFcEOzz2fotf0goT37R5rxiDBKHWA0g8KSkHLrqOCUctkvdQzu3MD3Wi8yYmRc3/j/IIrSUwGc1lyd0etm9uE0ERQ/H7GXR7yr7YtJr6gHMBF+Ce6yBWipk9LzujqYt3i+12G7qk+6Y5bfyVfU5YJavZr6mpj/2kdEH+4JQYxA2pZZSPRhCtcU9i2Z+/z2qZPKD45xjdw9TuS6ZAqJp/T7ghXvWjaUvzS7AYkY4SNIpKhKRnU6zDQXUtEmeXyVIC41Xms4xy/7Xns+RYJQCo2bvkVwgxgdQ94UX1JuFXCTNZl1a3kWLmTswpiSHY4xJzyj0YKLNwkW6QVdA2nBEBLVOvnSsDPYJFp1YG7Mf0x86cXeEfvfez/93grLMviMCVNgmNtYcrsItlIhsi+Q4p+v1dW0Uns1qgr9tkbqApcuAWrFkwzXivA8Wq42dRhQwnba2JPjaXGkVNuyRWiG5mYjhtx3G6WyKRDLZQ4oT9SsVjxF5tyUbf0vRIUT7uP1wPuC2hQAj4UX6lI
 p+32q5Da
 1QpvfGjhcLkQIVmYvTBs97bp5q7BzdheYAmbKjTFHTkfLk5VLtxCalgAPjW/rx2YfNUsUQN2/QrSuKpamIOHvyFGOPWp9VFX+V+jTHxELcgwjnnoUgosxhM5sMd261zDxKuZG205Pl0BlH3vlj4mE7rYpDPVQVEVRgxx37gU5LQ8qaX81cjgQAuKs7jRdIp67TSHWrnDNTXC4ssUQGl2AlVaWSfREpTVR3C8yPVtbmEGZU4ykJJPBjBK3QF4oJUZbVJc+FIghI41xFGjxcDczTND1TluS2JHqaSgToLFi4uMm+wTZZVz9kl44dHeQ7uKOGXnss3xdkefiVDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlbfs currently uses an fs-specific way to determine the size of
the folios in its page cache.  Thanks to the support of block sizes
larger than page sizes, we now support this as part of the page cache.
It's somewhat more efficient as we have this information directly in the
mapping rather than going from inode->i_sb->s_fs_info.  We can convert
the rest of the hugetlb code to use this at our leisure; this is needed
now so that we can use filemap_get_pages() unmodified.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..1760df6f2709 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -883,6 +883,16 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
 	return inode;
 }
 
+static void hugetlbfs_init_regular_inode(struct inode *inode)
+{
+	struct hstate *hstate = hstate_inode(inode);
+	unsigned int order = huge_page_order(hstate);
+
+	inode->i_op = &hugetlbfs_inode_operations;
+	inode->i_fop = &hugetlbfs_file_operations;
+	mapping_set_folio_order_range(inode->i_mapping, order, order);
+}
+
 /*
  * Hugetlbfs is not reclaimable; therefore its i_mmap_rwsem will never
  * be taken from reclaim -- unlike regular filesystems. This needs an
@@ -926,8 +936,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
-			inode->i_op = &hugetlbfs_inode_operations;
-			inode->i_fop = &hugetlbfs_file_operations;
+			hugetlbfs_init_regular_inode(inode);
 			break;
 		case S_IFDIR:
 			inode->i_op = &hugetlbfs_dir_inode_operations;
-- 
2.47.3


