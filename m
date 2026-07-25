Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C815C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7EC6B009F; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF256B009D; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5106B009F; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 886416B009D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10BCDA1395
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:53 +0000 (UTC)
X-FDA: 85027762386.20.2B63F27
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33104C0004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WqX8FEJg;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=;
	b=O0jk5OGW2dZ0paxMBmg2/yOHSRdpZQbqgM9eF/9raD3OFaxpom6SJ5fcPXJHTgq6TWc68R
	WLWXOYky9JSFXuvZ5kEsSWZPHe8U7Z0ZZh29MFQ+4ZkF/DULmWJ0AjlLhH7mWrR6iD4bfu
	HLpqS/M3lYuaHI+C8ZNVCIQbV8VKDn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995251;
	b=g85InrrX4ce7rCk8+bAKYI7DFjNMplRgnR8wqjOre590VAi/vLDmExMayUmOhDiGglC5o2
	cUaBXaYo/iMrNSX3Fa67i75Q4DJUJkGQfXHEBo8FOi38IlaEzyofddIlG7Tg4eJi/BLF1e
	EpBbhlhqOuPha92FEbVQUvjyNMEayVk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WqX8FEJg;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=; b=WqX8FEJgrd5xNI4QzoUx78zhwh
	LM3RjOtNqOm46x4TPbhmQo0AYvLcUmtSY2U9VzsJ7B2jw1YqAGc0J2B2aatriG5V/+IuK8GwIwgSp
	UTJPeBEuONiX+2EqJHqkgdg3y3pjK9Jz/MwkTQFHd0bdfEJWA5wM83h8KgIV8rs7eoZ3TR3nrPFS8
	oQHpM2ve7PHrdO+PQgPuI/6ubWgbCxhf2wtjsho0VHVI1oGJ2Xhoj1viSzWzk2UHv6ReKlE6x7e8X
	cBP8DnXfBoftZt6V0bMY+zGmWxwTZM46XmNpO7YZZuhf/ZD6UubttfK2lrwIpYmdtKe4MLNvttYgx
	mT7a0ZVg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7i-1yR0;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 10/12] hugetlb: Set mapping folio order
Date: Sat, 25 Jul 2026 17:00:38 +0100
Message-ID: <20260725160042.1557264-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33104C0004
X-Stat-Signature: 7i3qnarr91hzdeeq3zdy45r61wdeaojy
X-HE-Tag: 1784995251-867232
X-HE-Meta: U2FsdGVkX18cmWQVzbLZuQJ0cmUAMpQRFrl3VVBXUmGWbXIIHi4l17upzO4mQlPO8xSgnTnS4HNMfhKeRmvEnYTpXGcG1wFSkDhq6e29FIOLFN3TGtEdqkIgZkyb8JcmhuzkmXbi8egZCCQWeCRlvFr1Y9pSt3k2Hp2EKLS4weAZnCLPVatr/N81LsGQGJnpryHL0Mrd6kbzjwcakTX0Gd2gICuhtyUwWe3F+LmomEfkV3zD/5/ZS/oc1uf9Xlg6eE3AL60H4XzXkfEd+DzCj1fg8TiEW0Jj5+PQwSA54b3sPUUaK/n4zMw45f2TwH57A1g6z8O6GZHBgN5K1DsR29CzPaIqJLxeODIhbwL8izLQjIJFqfkLfEfMijNkKozeD3iSZZP2maqt2A44WkgAy7WIDfYumIrrt9YRbjq6dEhj1tDdwwBgAUzsCxxYJzF5xN3EXwtql8nflRfykDPGM/jwB3b5zMuVJ2eetR1u7u2/YBFkbuKgWXzUHcJLeSDyW7PfeDl9bF34o+87JUTmyZ/WzLvX6Oz6lzPW+wRZqhZql+pl++9VTm7u1y4+3HDxcgvVgXwtvWMVDsdktiXGlKmbqRc7vSN8rUl7tIr4j+x/9DvCMegI6f0WFNR9tC0cemaYs8kiQ925GmcHABj2Ov7/k4wacrNHHfDkgvfe7QBtOHXes/8EtYmFs/9FoEczA0CGdW0Q/oDCxn7djaNJNf59IffjTYn3BKJ5qG//+X6KuZ+kyP3FvXqFrKKIIBbe8eOykayIbxIqTiXlOOV/8wTKXKpJGGKIs1gfeqhrfwIBBl3nYIWVWyUemLKg4lfSlBqJfj3iuTDBpQtsDMtbFvJV2YfyRPPm8AdrveQkv6CCwB1aCO+egD5usKM4cqzKjgiVz/AW7Iwsv2kLHKgOWdJXuPuLnkHyeS0WDSLm+BnQfrCGBcC8sj3ygIHnH0EyE9HbK2VfTssznl+x/kf
 6aXf1ri9
 sBN6fU02hGVpbrl4rbeJlHkulc1ZDMQeymoUQ4h8QrOE4K1vjgYotSPlxDdVNtC3NHLENG/IS6Z+iY8c7WJiT33Y9LYBXDKAguTxWBIeL2fp5GTHEyCcU8JH6xAtKZHb2m0ytl7AdtryJgTXSiNpVmqyhWAqA74ec235h2MAWIQpKlcM+F+fsHiQAFpu820XWeZ1YGq6dS4TIWiEjs7a0e/cTF2Cr4cojVdNFt6x3aDOGr+lOnkz11BeH4ZCQvGnb3iea5JDueK/Usy68/0KB+TWTTEmSza832cpzpmtC2ztczZhiPC3tHDF2jb6CBYocN+RjjNyYroBW67cLNY3aJQsqqXreLqdxhQhynIi20t0u1U4=
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


