Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB1BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2EA6B0095; Mon, 27 Jul 2026 14:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AF66B0098; Mon, 27 Jul 2026 14:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AF96B0099; Mon, 27 Jul 2026 14:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F09D6B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 120DDC015F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:20 +0000 (UTC)
X-FDA: 85035353760.28.CF2AFCC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F1401C000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oz776JBe;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785175998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=;
	b=rGFYNHMRq/HwJdjKtI1w61puh058EjHm5pxVuf1VxPe07ZSvzXwIXYFfZ8WOyoZuBy2Zqc
	uSaF023Gy2e1ERyxlRjubMzqGiJAZIX18Jy1NBZ80WAh27g8YttvuOBncKbcHnluCj3wPV
	ufwQrVczdeP/6c82/d3eH/GBQBZKpiU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oz776JBe;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785175998;
	b=VWgWRKWPv6oMRnhZtj5iWDGQdo5kmA6DOXdV6aWuVVH2UaDoMUROzsueGYdUT8fKOVvzwj
	ODWFowOK1HmPP3in6fdHyD1Djykd6i05Vvs+ticaCm7f3IJPyNmZAkVkc44SwnnKp/we2U
	EkzOADWf/PpLrwzZEfy0I/TO6vJl968=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jQPhhI85VU/RfstxHcf4iE//LF5DLMgP3hQKUkFlgwE=; b=oz776JBe0DGpHe3ngY7Z6/gRNK
	EnyoaMcqERpj8aYH/pIwiabOXVGscoJYFc1xm8T70FvipTtt3+Irc0WMU5qeVaBfGEAIxVKqEpJTT
	UWjO+Vg6ZHJUZgQH5IDo0zlQGWg0nbr1Q4S2BChCgcwG/U6MnTbxWgOr+1i2q7P/vxOnsO8vjOioG
	9vTVX3WAHj+1xdgC0+SPserGusLhmErToizGPw75QIhYv+cbTCaTUp9T1DxzO+K85cAFJUyfneGk/
	HlLVNlhM8tzodYt3NQlvFu3IwSXEX9qpJZO18ebphXbtjKonxnHp9VZPQEtpn+aOs6SD+BTPYdsiv
	Dt/mpdYA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7g-3igh;
	Mon, 27 Jul 2026 18:13:12 +0000
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
Subject: [PATCH v6 10/12] hugetlb: Set mapping folio order
Date: Mon, 27 Jul 2026 19:13:06 +0100
Message-ID: <20260727181310.2671972-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F1401C000E
X-Stat-Signature: guyj3yjzsx9ezmq7ipjoi1pjda3idhgz
X-HE-Tag: 1785175998-859716
X-HE-Meta: U2FsdGVkX19bFc+3BVhaPTVH11SiLEAHMa3ubDuAXW1CiPdSdY5wg7U08KNXPjjQ01v5c0x+x+Tpcf0cNiDBa6myNYb6xxHYQQ/xCOybeo6CF82lOE9/Kc4sQ01ZnWIWa5UgHqe81ltsSNEyBxG6CTs8yCHhVOppRlc1vAgetXGjwJ6bZk5cg98zcAjyM9Be6lPdPxumsWIybPlI/T67t6AeHvijL+blYC2mKjl6QF4Tl/QH+RwAgpYOuQ6UeBTvZ+4714gnu9d1W7DcvlkLasfBm+V5mxoVEeAHB1KJUuz43hjz0kj9ofAMRGjUnBSKpRg0IBFezwI/BOe8UHq+OOQJpMtKe77vh+qJW0PVouy5HeD+JAcohFkhL3RfD6pjVyBj1iEJsGjKw/p7MLcPTyteAJN748td3M7d7EBLUaWb+ImGe3wakfYLq0/We+NPkacMw+le1qm7Svco9hOq6a+7doiXM4BmOjFWTUl5Y9/kLyeud5MvyRmzD4CpQMfH8EDajRZ5n6dyDjRSDTo38FH9jcW9EFjWb9+c2j2hZ+DqRN0hhpgaL6VLm1XxWQG0Ep4p1JlWMuMmcZ7cY7/Nu5Rp61kyD237MfZKHXyKee8cpwdaU8NAsmm6VYY+oNHvHS2vJaROgMpG30l2glxjyA8L8HPBQfvquODlgP9atYG7dOIvGbbDGnQjXz4mNDP7ZLeYK+2scbR/N7gumyrYroJUGbmNeiNspovtjn7LVn31sJmNOfXXouPoE9FNpV7oEbaZp1OOF58jmplG3SLQHMPFdsaAreSXQMJxg9pOEwm7OTVd/7VrUXGmove46IX0ZYQUq9QytQniE8e8blLrfkky70fIUr5F5rnrAfKTn4OoYKA5fsg56oKqjf3CBrr6+NJ3hmpGnhUEiODMDDqjlKdJeV1V8SoQTza2wbv8dkOWD9s+nM93La9lfD6HUxmq5ImPlj0yCvCBz6qbxSt
 hLlkpMkV
 a8LfnsEvCrCRtkqh8s8iebhcknJc/xoRXV/LrJ0V8WC539H4rPbT37B/d6OHQb/tgzczktPhsuvS1T9BfTyaB28feGCJMJ18+U1Tw2qE06x6yHF2UjPau2t6FzaQAtjItjqbvC7KwUleAotOzvDOo3c1PdwkuJ3TeXZWH7oX5zl5ycOM2GjB8VsVlgbeHMAMHxcqYSZpv1VsVtVexOHf3+AHlrPEDdYF+2/n02IlhbPgeEMuaVYWFXWbTkmPSGfHKsbJvlB0fbAv374aiDsvqNlb5lHKBovMF1/FOOga0sstqNFkeuS9YKJovG1jTy3dKau6LXRuCteLdHJI=
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


