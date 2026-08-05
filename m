Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81FAC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE256B0096; Wed,  5 Aug 2026 17:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5AE6B0099; Wed,  5 Aug 2026 17:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4546B009B; Wed,  5 Aug 2026 17:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E38786B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 463281205B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:13 +0000 (UTC)
X-FDA: 85068448626.11.A5ED8FE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99980140002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vc/N4CXk";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtdJZNakGmGRjsz9IEgGidM+eaReBPKKgi1Qg3iRYKY=;
	b=f95CMVZuO1GY7L0gJCy19+pRBg2xvk5VFvgSyfjjltitztumUlzpuDNm0xM1qDJXQpvDhy
	ai+C3Qfz0Xk7mNggj9y1wTKipQaza4ILfvzbiMwOO3BNpHqMaKc8Bx1miu3SRfzogGgW6t
	rPIqAO994MSlPRA0NYiUnKAYxdIw9UE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vc/N4CXk";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963971;
	b=rKuos8SD6efa3xCuiOlzS2GhhIl3oAGIvasCRwdTgRw/h6En4B7YxTt79ylyQ6T1vAC8N6
	VSwSFrVp5TNk2osLMcjYheN2Vlcp3fF4aZTi//aEuypkiEwM6uHA2l8eVxk8iID4fClgUa
	dR0blXV0aPLrR8mx8SH+N32MJGGWlVE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LtdJZNakGmGRjsz9IEgGidM+eaReBPKKgi1Qg3iRYKY=; b=vc/N4CXkVWjjdWI8CaN6o3kNA3
	lAbtKtDyNR2ngOniJei/RIP68v0xHx2vZ9MnV1+411mhiBLHgFX4dINnEZ9KgrCPrDILKN18a/ML2
	PVTacigXGtjZ2mN8H7Gjln53ImX+a6fqMBFV5cWYljm2mHS8IeCm0ZKAElLFIAjOCPUdhAwtRnibJ
	7wlDQFrgnpPRVasUB0IGOuHPYF1/fc7Fh5IdPQaogAxkdiGy7PySV3FUc8RzhBuT/cXh70RKlc8I+
	C6Mu/piH8HdEicsToaTwfReAU+y+I+vl6F27JWpYXkzBsH/R7q/2y36I6wQxpdV40SHBjAbEZ3HtB
	HHM4g7rQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6T-2r7a;
	Wed, 05 Aug 2026 21:06:00 +0000
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
Subject: [PATCH v9 13/15] hugetlb: Set mapping folio order
Date: Wed,  5 Aug 2026 22:05:53 +0100
Message-ID: <20260805210557.1118966-14-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99980140002
X-Stat-Signature: sy5xgnwh81sgprtna7jcdt3aeg5hhyoo
X-Rspam-User: 
X-HE-Tag: 1785963971-560186
X-HE-Meta: U2FsdGVkX1/WDyhH9fiC77H5LC4JQZou9YjxSvKM/iQSrVy5chBLYHWqTXA5A5AfJWCeDG/vvnqxDfHadgTgBioQyiKmZFZX4TS7pqPQpsutIIaUMmHZdyJN37JmDqqcYXkfm/yc75d2PPGFjYCWoI3JpK6/MLliZOE5VBjLDuWzKW6T19BEy6AvS9hyDpLzJhDVILcu+8YO/MGZUgvHUs+ICdFvCqj8Ou3zb3ZhBsVBgwf2FBeIi2oqD6DBt9819bS3MiAhBCJK0RtsBChqrPhoGAra4XiFk3oj6lRRFvavkSGksQMCuI8e9yDFxXfSPh0CMo6fb+d8STMSfzSw6CiBgcJE4vmyHp1Oy81+Kvr05QT/DrjLZh+/rnR7CzA2HfTc5CLVfPK6Zg6F5/K7uSqP/eAmLV8k7zrE/3eIRudruc2ZW980mpMAWXlTNrXh638+XMa29Zp4lYBJubDSS9kM7TtpPYzaD0wRxJ/5ux5m/3K3IDBsoqvRaYP5JW18U/e8vcEfsSlSSoT/A8asQRbW/M90nfaW/+8fJXf8DxGikStRwSRazCNJB21C+rGGwEfLPfyWBsoE8/7pINhITzyzcPHD+amqSnUxsfE0lCfvsoeRaf2SXJ1Z79wZ1pzpaKNJMATrdpbcza9tNtfjfZyP3NkO7Edmj0XOSTLeYqzr3FhsVxtCJT8uJJ/Nos0PBae1x3RzfUSFd60Zssd0pDt9iPzVbHbUL19LDCaASgzjvHGu202L7Wlus0UufDFuSflW2fmnrohLmpMNFF8p1ZjiJXustGEIv5d6iWrFkDU2g8AUEpwLhwv4fmBMB1rr9Dqpj2YjSODWrq+/qblwkC+ZaOAJfgOlU4rMvL2QvYsweL15tmcnjJ3684cEyqBi6++X1+tgxraWzZ/f+etAxFK2SLM+9WlnaWaQhXNtdGtsX1oqncXkUdsLqWpb2JINL91VsEcWyE4rR7gilq6
 1z+rL9iu
 nSSjdvtCtAJS9GBM7LypUVG/BJ3Oba02omECb0z8k4nSvW4eN2aJVrWEen2gmjlpRMTrYZZoEk9NVJTyUHc656f5NZSjfZVKkTgOFlYy5PvsOTuWhWyCoj3pzj8vR8NRwqcen2CLWTWUqA7wxCazacNtRnKnfPd0qpll5KTQVcdlucLiK326eXq4/wIvsWlgdOheOSWh8ZaO+lDVh1VYG9PjpF6cHBTBdnwjX1Ba3lnK6fstjVuqMnt6dE0D6Gsce7Vj1Mm3HcBDo8paQMHO4clQKtfZvSO67aZRrTd+zbsVcQSG4Fn922GB6WOfYJCKC+MnbEKBNKJhkOWFAhQGz2INN5weugZbBBDu04tTlWTBSr4BIlCpJLejeGhhqmE/6WDooAGWlQ61GwAPj2kHb08VQaXfNCPYslHLH
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
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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


