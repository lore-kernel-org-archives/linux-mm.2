Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01487C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2DA6B00AD; Tue, 28 Jul 2026 16:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA186B00AE; Tue, 28 Jul 2026 16:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92306B00AF; Tue, 28 Jul 2026 16:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4B396B00AD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D2EFC04BF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:40 +0000 (UTC)
X-FDA: 85039363920.12.D1450C7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBED1180004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qrO7Cw2g;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDDIWR17RnluwUMSI/lBv++7pmkRYI5juHNtiKs+PSc=;
	b=2JZHmO3fYwqlbqOgw1gBa+ScWPV4qhnoGSMfuomum/PEN4+ckgbGqrZQOk5EHgz1XsXL60
	y7tgBXdWEwHeuoTit9Lz7qGt1GWPCASp03OXu/TO5xE0Lc8AOa0RRypuz7I7HbpH2E2C6K
	uUL2f5jMTLAMarlhiYiNTjtHejBFeB8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qrO7Cw2g;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271478;
	b=IzGm+Z849AeMz9rsz1aI2M+a7Weqia+fEtczvVmXA/HHOiezQDjoiFtfwLUumLjXjQMHL5
	xw9q0ca5uZcaJnepafJ3oGshPluPLqClfq+K2df/DRzFMvZSWmo4q59wkD2ZfEPoBKrklX
	vI3eafi4a7+iWGJMHl7i/ktUOVfY4nc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=yDDIWR17RnluwUMSI/lBv++7pmkRYI5juHNtiKs+PSc=; b=qrO7Cw2gr4ZZFsIBsPnTEiTcu5
	3wCV3tGO853KDfW7Jx10rmW19nYo6kaHLyUImocIR72SI7r17BH/gKDnmmNL48HZY54bwZHdzJBlf
	IJIZsLlQkDBUm6i629fKBYIykLLrMVrAUjhVPVJha94zANNDCsAPZzO0ILlZgLsVol/yMDuVeEiQG
	BUtidWHLsyTmqvibuC2HuRqAUTlucwkY5gTW/YJfIxovbxr/3uJAFkqBCTPqGN8jR38J9V+1IINGa
	wohwNYpQ5ZUtVCKtg14ZqK2/BRKSbDz2wLAwQzR+ohTbx3ojr7mnPdK01Gn+QY67D8IjeRPIw+ggd
	17Fckm4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeq-0000000EFWz-1o5j;
	Tue, 28 Jul 2026 20:44:12 +0000
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
Subject: [PATCH v7 11/13] hugetlb: Set mapping folio order
Date: Tue, 28 Jul 2026 21:44:03 +0100
Message-ID: <20260728204409.3396238-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBED1180004
X-Rspam-User: 
X-Stat-Signature: cux63yde48db65bc8hytn7p81xhd9sqo
X-HE-Tag: 1785271478-467171
X-HE-Meta: U2FsdGVkX18BNFs3bouJN4vfntf/KK5vt5/Bhx9ral87TRY6zJKfDKrTH7utIlJCMgbsoDNA+/QaowncQ0HQZnJA8K2uZHjxBGGM9vTMeto+qY/KH2a1rIncc9Gwzxu5JzAa00pzHvqPdRq+hTCsRq86P8DnUhx1UDk9LKRwzZyfFwvmveNTi2PG+s1LlG9q3BywsVF2U4JvVFndAv+E4FEyTz21gLeqHazpb1vPudaHhopkPDedtfXrjF+FZwOkp7Tas8nttEGs47PvOhoqLjVZ69iQUhOoZpabTmhnHGZgUsq80OrMCYhnNKV0HOzVtY6y9eKktcBQFzPoCCqaNtjbK/ZtzYU7Z3Q9rRCO1oK2b5n2QtGwicLJFBDja8VoLp8bIWOI93kkPSbGt64Cok8+//cDTRL3u0O0v4RorkzokVDvqan1aed+MG2XJxLtgDqMDdktEt34citHOBqheD4LVwazV2M4eqvahVcaCPIqNUqXMyOmLGBM+Y1RF3SwnYvifcAOc8xPcAeUyNU36uV3NDDIs8+u9O5GaLTEIHKpVSiHWrRieYXZi44e51wYbvZC+3uvLl57RwZezbqFBvmbNrnjq8Xk8KVMf8jnuizUOIij8BbCtmuEd/mvslxn/YUM5WtQk4Erogtb8V7Rnm4TLv/Qk7FZVTprRP0zuf38wNqOnoTD/fOv7w4Q0dtzzCBPw2jI0QTrNzVTSlUyC39G8cDk8KQs3aCYkGjjyQ/4ZNjwkCGYvA0bKXKgdaArphBLXbYbkJ3QYld3EbTSiVNuv4yz/8ZNKQKBqLH/BNzkBIqjfUnZWKncUG+eX/mjRSZO03HCUrageUmEEPQM7CRiGfqSkAejLHNhGbAKaRcP3h5ATzvew4IetiFEh7O9trRlkaVRSS9DCimX3GBlSg4QTc/2hRNPN/2aRF7RX3srpGjUXlPjna9BV6kCD4V5kdyFJh7ffQaScmrbE41
 VKn0W54/
 lEvraYwbzZZNLIgtoGCwyMhQvqusn/3SlgARJKsKEiUpXbCleJ5+DGhGgS85aImg5EIjJwVP0ESXwRZkYAUbV3IBnldIM/qVeFFuRuTOpFJZumjoSyIO7q1E0yeFc0S65/IKvob04Il7u1frDUHdbzudC6uhOCzz2KrmW6UQ2iqt715pAlvCKrReDWSRBQrhAphIW+3AJ07iudIVg0KWWb40/E28Wd+UolfsZulYeeoLv2JaYX5MFRX3oSqsJ6vnlPU6OXX3OyelIFYpNQD0/ClGYBoYiebGRMDB4P4e64kp7m0ZgVBvUktWcdSxwM22kMwv/fcRdJYSGLC8VTFiAVGwnQRibG57tc77+g/5a9vS/6pGX6IwqattQJA+GlaQQFw29W0/1sT/LvWGO8vWU1KtPU2C2WN1VtTqu
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


