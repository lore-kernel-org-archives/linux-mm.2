Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60331C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34ECF6B00C4; Tue, 14 Jul 2026 14:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFE16B00C6; Tue, 14 Jul 2026 14:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215BF6B00C7; Tue, 14 Jul 2026 14:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2E376B00C4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65BDA12048E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:50 +0000 (UTC)
X-FDA: 84988168020.13.C5AFD74
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB271140007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q1XKHCF1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052528;
	b=X/8sHhYvecb2SbH58TIQ1SwPqjP32cVo+GVcT86D26rdAagUbYa5/7x9umQHQaFaKR0UKH
	qIOkEMIcBFn1k9TuiGH2opf2aiHctTTpNtsk8d7OxehjqQ8W7+6kmm6utBmBV1N0q4vBS+
	TBNI4Jwa6f1AhSNl0Ukvm6giim79XwA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q1XKHCF1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItkheW7o8MDheAOq0+eksdc6lZRrHRH2+xlsXaM+TEw=;
	b=y1a7EQBz3raTh8MiMHmPGag+3Y+5WJUblRfWF8QXBK6VODO7pJ5uPzUL3a+5wfqi0QaSRs
	Mw5AWCEbs7NM29w6EPpCc0QV0cDPdhP1Vg/qn397c1MsldzrNAj1UsX/KKMQcFzdeZh8qX
	SVacrsuSXttzwJ/jdvSdSw2tZ+A2frk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ItkheW7o8MDheAOq0+eksdc6lZRrHRH2+xlsXaM+TEw=; b=Q1XKHCF1NcQCCkYe1FUurI0saw
	2SY3+LBk6CNUrVThHugCN0aWZ8+bJac9E2jiS51/VAAqH154z30KXYNLaXOLw9mfumCF493Houpod
	nBmNOTk8lAzdOZJLKvStkn8xo/0sJI/SZpHTz/7O/m6Wplf6rn+sUuI5d1xx/4mVJ0Y4o9HseDI5K
	S5wOc+nTnStvZ8/OYQF6/BFIIgo/UT4dddeB9kmmYNb0qIyScuZ9Y5HyEAzr9holiKCtVUJ2B2nXu
	jkEuPBaH/QzoNbcNXjPjp0XAhkbriAiwIa+jv8nPiMKqSwzsLAEz+Hmfec0qE4jAWy9m4b7mxVibT
	CP7cLKwg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000Fege-1noY;
	Tue, 14 Jul 2026 18:08:43 +0000
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
Subject: [PATCH v3 7/9] hugetlb: Set mapping folio order
Date: Tue, 14 Jul 2026 19:08:37 +0100
Message-ID: <20260714180840.3731244-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB271140007
X-Rspam-User: 
X-Stat-Signature: dfosfku45spxmwn6hszey3xkenfjqqqa
X-Rspamd-Server: rspam03
X-HE-Tag: 1784052527-421124
X-HE-Meta: U2FsdGVkX19EiKzRTsuWbmy2fnQux0ZfS5lzwpPjiEcKXyaMF9JMtt2ZkKuPkOnBQhBXKCse5FbxQxwlBd8QrXEC42BQi4fJ/NxRw4qjAvIyof3jpx0FpjST2THbczFcuLZsynYODSDffAzCmSbbgAuq1YRdJjdZ/iGU/rx8ts43Ku6ySG9Dd7hgxDUJPzHpRf+kGj4v+6vUgJMlbbLPKpL2/e74Yu+U1/bY3DvKJ3OQiv+RjF03oyCnTR4CYI9SY4nxAaaLpQOI540/jeHg7Eoug/QQqcwHFYgEdb620c246tgAVKEUAiS72YEqRRsQuk5GUIQbSpQ+NHf+5jWcbCy4QO6iM3L8gk5+oISUbbintrMJq1yzp0YgK8/N+I7mkF5ACf2oaolHLkKG/m6v1ro4AJTniPpt8kbqhPjrFLO1B+3BUiqArLBz7aWacl7g3SVOWVQBxmqWdSDRhSEsSvZVO+5FGeDh2bJb0sma3shiKLTVsix9f7fNya3y1YHkDW+WZZ1HBZJQVEywr9BKkDekB9jRWeKE9I/mwUQMjfSKQfmbZ63pPd9ROhGPP6pf/Zm2HFWMM8bW5ffRR5cnWrxyej6SLwBTarGofB026GmTMViP0VDSmAf/S4jDImmiKs9RzKAIUPUmdR+AirH2fi7NnqCbhxxhaecQ77aoq7ojtYn5xdh/Db7dCOnJWmtzYMYxd8SxbQaw/JgkGeWJBOfYp2lRPozU0vbyS5Ql0cuu/n2jAPsD5q+bJfXcW8kxZVnqcX3WjHgl/vplc3RR0z+5a4iO/JIR+6KFXnRncWp/4KeRVsyIe40wtr4cBDPzl/G9M7iFMUXJ7YOeqTjqX5PuqcphsbatGoMyYSQn+E7iKJVfWAkrLXGCfECfUe58Lg2FBEDoxV21V6AjKRA/Uaas+gi5B2ETO+lgf57m3hB202sfz1RqiOeKf0qU+VRvFOxELw5LrPjGxMf8gZG
 ZsUXPr19
 Dm6lSATEJ2rmMEHobEa8VSwNcZ4vj/XA2R9oupr4TO260Ty4HnX7Hp7X3ZNkxYFvvQuOR1zJ2I097bhu/y/pODGwYr9l1CoL6z40igUFWXHlrhn/3P0K8yKUAmKipAAW0oTpYUIU7Umd27CgGkFZBkKdonpWpC1BGkyDLCM39nsRisN6LIU9DClHtnb16kLfIa6rRHooPbK6yWNX8qOrr+t3LuJsFH54ZPDN9hsvlHKcLYJbIDuSSoaw1F7fd5XoNZiGKP0zGm5tSwqZ12yhzw1C3fTJXx30IY/fa2I0wc5jGKHXoyuX1KvYJkEOXGHa0QH9g4RnZlAt56VoDyE7RDOsKFC/6Tb1Qd76fUUjObsJ6N6Y=
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
index f1d4e511d9b1..725bb945a440 100644
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


