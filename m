Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDE1CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90158E000C; Mon, 18 Aug 2025 02:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67C38E0001; Mon, 18 Aug 2025 02:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4FE8E000C; Mon, 18 Aug 2025 02:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCFBC8E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:10:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75384BB7EB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:10:28 +0000 (UTC)
X-FDA: 83788853736.15.BCAAC76
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id B75A5100005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:10:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Tlbmw4vQ;
	spf=none (imf14.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755497426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeSQ7eBoZowddy0LRvxIFt8h4KXKJcQQ/6taewzmG9s=;
	b=VafBmHRdPB242PSb5IugzdkRQbovIBRNOvawnS5tzN8SE5KlmzPkEHNMIN2k2tpixjzHPx
	UxkYPkDWVqBNkQzWiccI0F31C7mTGeMKzmOFdHMVDU6gOmNCziqoO7ckkmTGtPTa7Qxy2Q
	trEapN1BLic9KdPeZq0iLKH8d3G/uP4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Tlbmw4vQ;
	spf=none (imf14.hostedemail.com: domain of BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+597369eda0ba97e1de7a+8030+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755497426; a=rsa-sha256;
	cv=none;
	b=c881COunQclGFbo1COCK/zFBmqqsnOR6YmdbJdDYLtaZ7m3vDuWi6wz0R1eSxUjyAA2S3K
	SWxleRfukh8Ray1G2P3dOEEWlrGT09hNbMBUAPSHyPT0KzRXE8URHvOwYr7kL/Z0RMgxUI
	AQp/LuZwLqfkzQIOZYDrcAvJS3BQrLY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aeSQ7eBoZowddy0LRvxIFt8h4KXKJcQQ/6taewzmG9s=; b=Tlbmw4vQOEVbufkCIs65ZnEobQ
	8vsNebYv1ST3EvpCMTvJZci/y5eE4S7imFHUKIIiMRLFnnfKqzpI+21jeBuYUrd8lBJP5N/PMXhgI
	U+SEm11/BPwWQhuS7iEIVlAelxVfNBytm3gY43MUqGKnG+mtok6l1P/C+WumwHktgT7R79+/z/qSf
	qTWD52sEDjHRbu4VI2qOFXaagsOOFm/SU/xnIx9CU9yv8omuRZyEkAi4wgkmy3yse95fLW9KqhZxL
	IK5eH+UfP1swn2IYqNBUM0TJ2Rx5u8EZOOcB01LkVuou8WhX9nfs0a5y9q8vi0ciMLU/h4sM+kgGA
	sfgNy8Dg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unt4Y-00000006bmO-3TjI;
	Mon, 18 Aug 2025 06:10:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	linux-bcachefs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] ntfs3: stop using write_cache_pages
Date: Mon, 18 Aug 2025 08:10:08 +0200
Message-ID: <20250818061017.1526853-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818061017.1526853-1-hch@lst.de>
References: <20250818061017.1526853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: poikjyd7pxzgocbszgdjfte5nwjuzcgz
X-Rspam-User: 
X-Rspamd-Queue-Id: B75A5100005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755497425-508592
X-HE-Meta: U2FsdGVkX18dklEbX+jcNpbk8AyXuuIRUWeO9Ar5J3Fjek4uzJNuhrk1rHQFxsraFLZXaxfpKBc8Hi3uSbzuH6xKC0VkjN1fL3KHrWb05dFk71lNNCJ92zP9kalYk7J/iU/+jHg3AeaQPk+mC8KiOsWtOeZfEKFIg4ACBUyWeLbfFLprqmexTxfzv8zMPu/oRhZjrJG/vqQZSDalGWgRZghloAG8hvDrVtfmvbQNmaPRhivj7Z2JE80qjEOLGVNbzqDwHyAKb4ZKXQ4qTFUgRKWtxMJny1ulEemNojKcJk1a3hhSRMhnV7klAJ0aa4BzOpEOs2/Co+TYw3XbtXnPe5EkkzHBpM4TfS6PbvPzwirtT9eYmbEtcIqJ9MxRgH6iG+dMihM4xxQxT6v8kNYsVtiuej08OjBMihL9g12U+rauX/kF1w8UkLplpf20C3E+NnzHKF1E5Uuu9C6pDbsRiS+DP3jqAkJnCO4J+ienFdbPV/VRls7U5QdBijETs9ZSRAXQ98yGFSINlhSxHhY0jb+WxTj1YGqhXfaQE60xUuTQNoYRRZ3BMB1P00ZrsAgYJvzgaP8axDN/OHnMcy221mMKmjRLmfLFnoBD7Uq1OFvoDRKtkiRzi6ktoXz3rt120bj0LY+gbQeHNvj7bsAeSHzJDPYyfzy4Bi8T3igCPygMmT68Ot9xgFbtstWAuNTsHksvFwjP6av7KIlTB1xh6HWOyZBIJ4yJjdCiNnWBqRlZnSC43XqwJyOwVV1bDElhgKnx6XUtWnnNZwk2emyTXF4SP2zb9YEzFCqvYzoUgqU0qiDPTwMoiEtQSJHJaTFbISibAmGN+2fznJh3p6or0CLDVumv5/v9Nd3uSxF6vzRWz4LwdytF+bAdXOmlNT08S64UfKCHhoSsny9sB44Hgedf/ANL7ORLr8+AxoZDhxzZkrmOZk+K76snLcTEVqFdYfkFyuEA7IdBhh/Ik4R
 iYG0Nnmd
 6ZHzh/0F4MYhUt+XsGKMdpaE8u8aJfij7j3yfdYYjSJC/0FTgEKzWoTicKUcSiaxdSbEYTgd/6JeqW0ErVKLwmB9jnPq+x61zlDAyyiENQFRiaCyIXK+RV1t+yG28Rv37YpsEIwfP6koCtFGOY1C3gmQNtL/1QOhMnorg819CRYDK7JaZnmFBGu+90E/DHbNQ12DOvGgenJKeTXyZfQ5h2fl2mlfh72ayoBxieC/K9tixVrTEJfHeHPluj7PJ+wpmZ6PSgu8xXZQPPjOUODp119Sx7lyBAdYTM+BdUKeI6dTUboTdpwvnZTJM2N4DXQBedfIsOGflGb9pDYz5mg8YaGx1EDBjuwrQLtDFTcdHjPOcmz+9/EMbsIiXq7kRITPogoEdLL93VaihOCRBMom8A84G6a8JnGQuanUJWIwCmgGo8BWlE7jwqeRxqMV3gnS/cekhq+tOUsVYhLmL+FlcsPEN4vIEL8R+8eXIKv/NHKP3aLiUNs6M7DgpL01YTJG2C8aa9l6otnQdscZfOFg3IcnsnUdQxPy6zttp+pLmQ0fbBvtMh8sgAESLpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the obsolete write_cache_pages and use writeback_iter directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/inode.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 37cbbee7fa58..48b4f73a93ee 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -871,9 +871,9 @@ int ntfs_set_size(struct inode *inode, u64 new_size)
 }
 
 static int ntfs_resident_writepage(struct folio *folio,
-				   struct writeback_control *wbc, void *data)
+				   struct writeback_control *wbc)
 {
-	struct address_space *mapping = data;
+	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
 	struct ntfs_inode *ni = ntfs_i(inode);
 	int ret;
@@ -907,9 +907,14 @@ static int ntfs_writepages(struct address_space *mapping,
 	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
-	if (is_resident(ntfs_i(inode)))
-		return write_cache_pages(mapping, wbc, ntfs_resident_writepage,
-					 mapping);
+	if (is_resident(ntfs_i(inode))) {
+		struct folio *folio = NULL;
+		int error;
+
+		while ((folio = writeback_iter(mapping, wbc, folio, &error)))
+			error = ntfs_resident_writepage(folio, wbc);
+		return error;
+	}
 	return mpage_writepages(mapping, wbc, ntfs_get_block);
 }
 
-- 
2.47.2


