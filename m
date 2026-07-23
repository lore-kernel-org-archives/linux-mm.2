Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1EBC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4FB86B0098; Thu, 23 Jul 2026 10:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00206B0099; Thu, 23 Jul 2026 10:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C170A6B009B; Thu, 23 Jul 2026 10:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984D26B0098
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:30:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17C5A804E8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:55 +0000 (UTC)
X-FDA: 85020278070.21.F20407B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 571F9180010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uDCMJk5i;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=;
	b=jFNMo1nFZC5q2LUetPJTl3iQf297H2Pq/zJBVrEvQdrZlSzyLiJRn3jgVg8C5tWbVkqfz0
	ZGzofkzB0pZweZScfiJmzO6z8LJALh0lg1TXxnBdYd8mTnCTn2xOcaMTgOKlXPgsQHtIgp
	N1mB7zqq/XSQmQrr7T2jbR7AtWuR6rk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817053;
	b=vlsooC0pgKaBKhe7uwq4Jyu2ikoCj0nmVVwLLQeaAHBLaAbOTfPpSCjhUm6LwFlNFAIy/7
	ZVLn+4m1PFvHxV43Ko6ZAs/ImRxamha7N8apG5hIXTPnsn7mt6ALvb4HEAVw1u7cbHplNZ
	qbMTwDCqgJ0RjRq/vZ5BTrsc/EjIRMU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uDCMJk5i;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=; b=uDCMJk5i9yVb1qLrSaKWZt43nv
	hVgugzBdxmBU0aIHJ2ZPV5AEmmji9peshWGaRsn80mHXD5lo2Ucn1ENa9uE24Anb8Ws6QexlEmQI2
	gxXRZQdk9rJdT/7jhFwyFDfI0Rd6NAzIh61jIdRTkNi5U4CKqkamgoJUZSKqmwjiPAi6kAZTLsM4L
	b9vHL/cDIN7G6YLHZamSpfNJTex+cQl61ZDyVNO9n5ARCVhCM9j0jMLQpCpHwr8Y4zQuYa8QNBxmn
	5y9diPp3XTQcHwRnT3t4oQWLp0yeDJXSfzIeT8wdYKDS7Zh2I2X7MPcU6sQqvgJ29W23GHQaP9izN
	Yo6faBDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000jiB-2pSo;
	Thu, 23 Jul 2026 14:30:37 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v4 12/14] hugetlb: Set mapping folio order
Date: Thu, 23 Jul 2026 15:30:29 +0100
Message-ID: <20260723143034.175661-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 71wti4izma6ipjydcxfih61x9dgn9r7p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 571F9180010
X-HE-Tag: 1784817053-737170
X-HE-Meta: U2FsdGVkX19m/YOfscgTW0B4JBeVXnlzJv8fgHZ2JnnuMu0bPkx0Fizpb+DyQaOxw53+yu+q9RkUVuqk05wZAqbLbQqqaIM510DRpsXXYOJ5e0ZYL/Je/f5iEfqLJogzMbs5qmWRrnG6W7OZJGmR65Elm1Dbb3rtJ8jBemO9dR5GZCrJIgYIe1bvafG94PgeX89ufjRNP6C40mCBJanLR0vbQrxZKRMZGaDbh6T3AYH3YL1Wxl8dxBA8xLPiZ9Nfr1RAVE7S+hxvzwHSNVsWT5H1ECuorEC+tmUPCpb6W7KfTSOQNZmb1eF7Zhtne0ISZbEV0JJYJ1GhZqKMu78ABkd26GRHJJewEtDo2OHqNdT96SCQeR8uwVN3e3MS4sgpUEdKf/rgmOMFej8EJ5WJgamGxSaiCF2vekEicrOz3DSi88YJchR3AOzbeUUpwKcgoBHX1v71tiy3BWrCGNV3ore165ifIr3ArYa7NBksdnPQiGRF/ICbvpYg8s+50thwA3GIBf36Rd7LwvDoeuFGCauLjle1ecHomgxUgdLU+TfT5VxHIeEk4Xrjr1P9xGwFh01BMdx5Yfig/72fH2Jt59LZw24EfIvtgjzeLeLUduNrBfx8h2wTXYwvzKFjgYi1QLz2T7BkFybAtOlRQ9CU8tOHlIQ/WC5UlETqi/dVWMvSaWC0FxKuzmJn9G0TRVnNv7eyR3LTn1OvkCwM2q32IbH6Z0gBYU8aPsLA9w//IeaWwOReaXwmKU/xtQUfuYvNqo5qSUFiAxZkMDEkQsf74XUVLY1ZIY8V1EfUg2IwQ7RWHeIDVroYZ6uPb+OCSaYQsRExk3NuzVxMhKOyeGcKPUV9DSAfwzQWNoc1FVYW6xsevYJXDByNUy4C83LR+/1v/GWQJJ1Y2cT8v9ygg0sfA1uQodZz8PSAIk+6OnjCSDQb/zWV1fvQHepGxB29MFV9rrSv2MjIeh5VB+fT1L3
 bcie/y/V
 2K/fu5kcoBnpDURxzC1/1I8l9/lvm8ONi/ajQp+wU18yeDVQf8uxyGOxpyz3OEZAOIwTbZ99LlTXp/SQ3fQlhsTr7WDEmbk9Thni+TgpwDy8/wAX/77pb72FrN6rn5Mpk7spJ8Uw6ZOcHTxVGVL28V9+V5IEUPus7oHnL8zMeAIC+fTDH9jlPm6M25HR4FX3pPJSVfkFb9/WQjdmd3jEB1lOART8vx4qBMkxTK1bScedmXLXJDh8M4efmziWzXSsDRb9B87P/jSC/UblL5cbd7INyf24i4jyL5H8vXQUXSwE2Hk+OiWCcBWJE2U7DZ6yOLr4HvQjfAqQ6beI=
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


