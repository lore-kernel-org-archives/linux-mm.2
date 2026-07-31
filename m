Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEA5C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B586B008C; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C526B0092; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6326A6B0096; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 288EF6B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88DB71A0153
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:09 +0000 (UTC)
X-FDA: 85050158298.23.494473A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8094DC000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="YyB/J0H6";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDDIWR17RnluwUMSI/lBv++7pmkRYI5juHNtiKs+PSc=;
	b=jQLx0nLZkEpQqpRhp4qoUa1XH4XHL6G6dxjDhHbnjUnXmv69SumOeNixxjjj+EyUn225YD
	WX68tN8TZic3zOVRz/ZiTlVxFcDWiQf8129v9vO7SE4XzDWqBo4OHpW/wjyjApoIB/ueQQ
	Jhc8oYmulM5zhubaWsLKbMrYo46n6mc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="YyB/J0H6";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528488;
	b=7MORaLTVtXz+OqbH5HSXUuALF8AjBC4mlxFfirstAheD7dCEh/rQqWMrckuJsLcjouBdaf
	f9qoLnx0qGAULmBK6/zlD+NABcfPtlfUrFn61gVizVAoDtUT5xyn2Yiw0ZJzM2QGCY/S3y
	hXosFSgpdv9lEhVF6Zhz1N8OEuRyUb0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=yDDIWR17RnluwUMSI/lBv++7pmkRYI5juHNtiKs+PSc=; b=YyB/J0H65u9XYmkYOyzAESRHg+
	+Kg+ZN6VrIPKA1Z6J56rax2PJjDmiUgMiMQD71OnosMZ8u9lpY2MM//LXJm8Ac9Rpkd98mwwujGQ3
	bhfsDkSIJdR243iS1mqNaAQrR42e1uSGTyARQAbaJbaovn4coUi2AM/Na6VzlInl9xkBPaHPAX3h5
	xIfjdMlZyw561PJt6hfihL0Dd6Z7t406lgnK5rbt0V5QXePzH4Salyi5c3LsGORU/+KnHI/1eSlL9
	X1zoZqBwQlfxk8h2tLZHe8vCWOAix4Q4uVrqGjYOBNNpsgSkb2j18t7QpqNQU3FpUe77a+EVSKCjH
	AWTP7XYg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002Pnt-2p1M;
	Fri, 31 Jul 2026 20:08:05 +0000
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
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v8 13/15] hugetlb: Set mapping folio order
Date: Fri, 31 Jul 2026 21:07:58 +0100
Message-ID: <20260731200802.574821-14-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8094DC000B
X-Rspam-User: 
X-Stat-Signature: 4drn6f3w5iih67kg35hre645t5rrwxio
X-HE-Tag: 1785528487-130592
X-HE-Meta: U2FsdGVkX1934UeML8/S8yYEESRUZka9qu89+5VmpqQZfEmoojf3kSblYvn2GJy+N//52ImBG6QypwsgUjf9/fDZoiB0yIOKd/PbfLOjqNb7xg5z65RQ6km0nIfeMxENVOBBSWnKHAPbzrs1tzqNUmvDp+v54PuYA6q/IsE+CplMZ1fQOdRSFjWhzEIxx+pOBO0rbOOKPgcuNiq7Brkl7IotjU0owg7Gx3uF1oHX8ZETwNlmHu2YuCl1uN4N60++LYY2fgCQNLVG8D9ntf202c36po++KtZJrKn79gabKNPlzIVtu7RTNhp46kjVisQLtbyB5lsrxwXx0pDzwhjVezrsFqEyjdUlzxXceJ+YDBB+b2BTyTWRmD3Vzs+F2TCNC8cbipnbO+fUUDhviUO19N2oBFmHDOSMynV4AHPC7s+AMVRJk0PjUcuVmGqyOrkWjs5nlru66FO2dyMVI//mT6vRsl2Z6Df3WwNN+7ieQmnGwzZxP7g/54sRQsNMKFixfLDCH5B/zOKyf3rqLeCPNHKPDY+9BdtuBOO9A2jmFUBuFtPlXMqxAq+ZRyXLXm6l+qnRHoYaTqLY7v9MlPHJEvijoyFthPnBoxEWuKbTpV73+8yJ8dWe95pc63cvDYzjKpFMljmNhAYppZAn5kk7c9PRQSGJ2AfFEba03TsavDkEB/TwTuBr494hWO8f5A0V3cbFwJPkcJwXqji60MOwynqy61HbhqtH/cMdSjZ/3Q3PvLSgeUjtXkSzty/jsgHj02ZeG56g7hGS3AdRPUdz/c2MZ7getsBW2uf2s4l/K/UEw/xxcznHKScXF6/hhVyBong+J+KbNvKa/VqCp5rIt33PswKo/4qs+GGXmVVY4UQxDPDH80EcDQ9jmX6a5910iMPhydR606GyIp45RC1M7FgWXqIwTeBbNrw+EK3A8xBU9I40LbCTO6DbNiVdTcLoclC0XZwLLf5VdUuFQNK
 yzsfGxok
 Q0QBaWFpJPema2fMwkD+6cB9FxYt0dKM888jg2IzTqBdLfCDr/sVhoFMHaGsRIcsCJIsyctnhj9XXzlQqg9kOoHY/DJsLB+ZhUnbBWSWMZPd4yUgyTnSLg8UHva8ncV12T+dYJpo6jtkZilRuCzsuE6ziNzp5TVBD+coM0YbOwTU7yoPH/yECCEYZoD3i5ssgXuHEK6SZwOzh+POMUEavkN+JbMqYo9yzcqhq2BvNehJEVLo9IIkzw86Sg58pefYKeVhWev9MqOTuNkzKirtBFpnmCP1chJ6Pii7+Tn6nlzSLML4reRs2rMV8N7vBTlDvJhCyQkz0po0C38VcA1boIm3W74c3Sw5XGRQd7yJ1fHSxoO3xSgS+0gj/WyU9ANTF7FGSpz6pHexK5BZos7t3w9VsafvbWOoD2Pc6
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
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 fs/hugetlbfs/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index dbca3f713bbf..8d15413a67ee 100644
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


