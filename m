Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01A8C44507
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45F06B00B0; Thu,  9 Jul 2026 14:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E106B00B2; Thu,  9 Jul 2026 14:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35736B00B3; Thu,  9 Jul 2026 14:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 758446B00B0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 061818CC9C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:11 +0000 (UTC)
X-FDA: 84970123182.28.C3243CF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7AA18180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dl48xbCl;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajN0xgR99tv6l81DifCTyf3GY/vdZ+aOfksjFBPqRjY=;
	b=ud/s5/0/3sRa+aEw9foAegsosvT5R6BIqkGHtK0uTc/ZjNWk0/GzyyfGBcdSb6TlPrHvIq
	PxlnJBHItaOHzELBGq4HOFkceGxlZjyuVAq5UtzK1MSM7Bb0k88qqGXi4sTVHrcR0GmbxT
	9z/12dKo789AAFaVI/HBeGcmO5uMd4A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dl48xbCl;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622889;
	b=d58/gzp68+ZQt6btOp5wChSREiEttADaxGgiRcnld+VvywBHn+pXKYQOvOUT0GHAOvKRKj
	4vfL0VcO9RA7O91PfTBleHi1b/s83R42poK/3w11hS/wQSGrcHho4QSwweJUAKQznVWXZp
	IIPqBbcq1TeOKqwX9drbw40QMXd8Pxg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ajN0xgR99tv6l81DifCTyf3GY/vdZ+aOfksjFBPqRjY=; b=Dl48xbClpVu3psx+V80MUjtdAj
	8UQmYnc7eQGd+BeTLmmFz2KJOj3scPE4gecweu+K4OOAbSU+sJ1XMhPmvPnyRtPpVE/6lxE2QbN5q
	QC0f4GcS1SPL84JylUphQeFB1MjI1Va1lykEtf6uaoy0b/g0Tux8mlBKh2eBZd/5bD2iw7wKbhWAN
	aEMbWYHUM3H//nHywxQRAusIG3NLZVtxA2N8YW3TIcPW1oSzdCBBjTbyoncB/7W3p8rwZ2cEGuJE6
	IKmeGYJoif7IpRMChYalBoM5/1ttpCXboUv8NRC/n3T2Pl75ocYZi25l7xc/70OT+Nvm5AV3Vcc0a
	YoLB3uZA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhH-2kju;
	Thu, 09 Jul 2026 18:47:42 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 04/10] hugetlb: Set mapping folio order
Date: Thu,  9 Jul 2026 19:47:32 +0100
Message-ID: <20260709184740.1286561-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rntb8g483dx1dkoc847ccunmtgy6ejk4
X-Rspamd-Queue-Id: 7AA18180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783622889-558400
X-HE-Meta: U2FsdGVkX18RN2D+ImAYLJKp/Dwuc+l8vpjnM8egosGg5xbe8toi0zVw5E3a+p3uPf6led5J+HygcZB9XGgi3RPHQvcf8xlmjXG+j7pHwvRM+7MgOmv8LSNUY89CFmOmEhRpZYpSVJJ0W1uKFPtLJfQg6mR8/GL8v9cGmL5vclgUi+HxyRThjwXNVc8bIbBt9TB5ECj11FcK67OUsbZh0Ujoscx4xSymO8UCVfhl6GTYb3Vzg/vnmWxR2TCWc8WyOf7maRw6u92Z2J6fKDxBKW2EETbj4gQ8ME0V1AaoeyfUDRZY/upPJh4uVaPB/rGX9Z3nNP7dIY2NnOYUzgY96yV+WBk0SLmvTiWgNe0sBwJdzUXRY5LWCJBBVywGUyCqIXjrJOYWgRlmuPyqGg4lE0Nicy0RFukGf6HoHFel2Y61mm9k7F0YGkm25hzHe49GCUeQbJZBVq6pStoFqsokIbq+bFDOBLZm5yQAuSw+p8Po7U7JTXhzhRHcvawucqQ5OFbXnt6hgFNSPRcUuZOXniNwB3nujRj2R5oxg6fkao0ODb8bNKL467LmoVYhAweefBJ4H5GuxPU4AMwNU5djWZHCylwbJEHpdw6o6nRUBP0Xuv4JgjK6IOaw91RjTxUL31riYd0sS3RJOq84wMTVZo+4JKbrNRILtw4LixZoE/qnXoKBuWnzbVfFYqDiTChP7nIsdgjBFd/4FnkssE8Ibv5ZhR7bkd2pma+HoGxrRblILNmMnfzdfiBmKbtV/cEXwqs8bXTNvpyQOGMKK1H18Rfz+zn+UpX6otWfYt1WDZjS7Pwto3rDmbUp15gwtzq/s9hhZF0hNN7JiWlonlPqvdgzGcb5Ca5Rqx03oeoud4OM2WGghUf9u2SNE8QV24ajQLomFsshFQhIK1ogSOr3L7GMeJCHDF1ASXgT70lkb47n1ALj5J2TDgApDsdObaNRYM1yCU7CXkmznUarF7x
 VWqYafcN
 EkBlL24pxfyFXm0vqVWKA2/lkd8uRPEugYSdawhCg1NmNDPcM6RG+v446jRI+Ts9OxYbDdnAqGs1SsKh84+znYE+TMXwmfu2eFYvoG+Le4dg38D4AXgcf+3n0ZO9+JUU24h0A07hTGIJgX6TIl8U7DoGjjcOtnRz+m/AwS1NPMOZEIYzigEXCvXLeDnN76Z6sBGgknnTfjWQbzCs6DgLYa/mQQGPd7zrcBU9aC/qN1VvjkbrBLljgcDPz7C42jbxcoYaMT/Htd6CNnkKClqTbpmtwrzL47yNWuTB8WcMjJlVy9nXKe/acCgYPImx6xAzvLiii+4CCI/5NOBHOOgL43RLK8FrxcbWDvtYjYPObTTrW2xg=
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


