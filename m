Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37F4CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DECA8E00DF; Fri, 24 Oct 2025 13:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6398E00C9; Fri, 24 Oct 2025 13:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35FB8E00DF; Fri, 24 Oct 2025 13:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEE948E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:08:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 857C0160F2B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:08:35 +0000 (UTC)
X-FDA: 84033641790.09.12D0D7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34F472000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:08:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J5nIVsHm
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325713; a=rsa-sha256;
	cv=none;
	b=6iHduAkZIxSvY28Q8S8VZbOoUcE7dkQYYnqnQiZQWuhgqm7dgzk+KvJBdF/hqyijDezYH4
	BAQgk1FNeFBpOxRtg6Gr0eGvvzzLbCwotk6fwfpSWSxUUYa+rV54OY0eC/9w7GrVhBYBQc
	pJlO9frLtfALNwmsZwR+g4vXIldVqes=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J5nIVsHm;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZW5olhctt8pQPRZxoAAJytfYIV9yoFEgRh2hZHi7Ks=;
	b=VCDQ7rvTO1/Z5j/MQfXavpjDj1iXbeyuk29K/OtPvqxjHurMUV8LFCjWzNqjWqjyJBJ7U4
	PYlnStRipmQXs9tdtpA8TNWzRExnAYusr1ziBf2vGoOKs+i42jwNtEo4e/jLZ1hBVdiBFR
	zklln0CXs+SH11hAwQnPHJOUNcUNC8o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5ZW5olhctt8pQPRZxoAAJytfYIV9yoFEgRh2hZHi7Ks=; b=J5nIVsHm9KMzkVsz+UUroU00Fy
	B0yX4QuYTnVGZWEppX1RPvG05Ya1Bnz51s1AJe65eYrxxzRwoCOA4RVt5gmygFvqRUDZFocbE3UQs
	1HVy2IFtL80K6uonYWg1UpSb3rAC2wl6znxX6WucN+F6j43yVzrWRifH7yfcQIhGt5dTTxqUsagLp
	H+n/MYBlKaa+IX6FesApAibC2STndf1Xj3+n7P9XsebBEDOLNFY0QvJiyjezRRCttPrk8YkCDHoYa
	+Ppr0gm4egEcU8CT6D/qzgEWn3ZX+sbq0EEB+zCVXSg8VbPfZIFvepHZcej+Q3hMIN6WWPHB7qfMd
	dA/t7aPA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCLH7-00000005zMA-2jPO;
	Fri, 24 Oct 2025 17:08:25 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: [PATCH 10/10] mm: Use folio_next_pos()
Date: Fri, 24 Oct 2025 18:08:18 +0100
Message-ID: <20251024170822.1427218-11-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024170822.1427218-1-willy@infradead.org>
References: <20251024170822.1427218-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34F472000B
X-Stat-Signature: uzun14wsbbro9ft4i7889kb7oc73w56o
X-HE-Tag: 1761325712-630878
X-HE-Meta: U2FsdGVkX1/o9d2yLNDMPYUE+egFs3k76bBWgBr/jTa6NjJ5U5H83tGT/c9Q7yd0Jj17KkOjvXRUv/uGO3aqyox4aTV5CaLuduDcdTK380/szO8xF4EmH8U5LF3qJGlyoSF4G9wcHR3VBeKDyTJgFON8/xD1WvW4p/ERq1UBjNFhQPa2OzZwiyOvBM8mo4u2gW4dvwcmVB1jFq/fuzPUijQlisAbi5tGtNzyRQDO1VK2OWUqBOEjtA5vfawFLfe4fmST04Zz+Qd+2wXkY57j0SrwEkxyN77MZxia2gF1IER58EPhF3hs97vM8Urfh1flViAfgpS6VyY05EGSYjQyR7+ikm2wfCerusrSjHqH5TU1zELFxwNVw0IOkVdyFvXc+9EsCU7LknTidsbQCFHYDfB3HqjC2jhLpdmE9ztHVGx5ybpODpJWk+yBxpc7yBqc+TihJfKD5HETOthWRFjkH8L6h5LQKMLUU95d6LLp3e57RwKK1WWPyZeZx+Mqi2Y3IVGzoAhivStNbRG+FcCHxvyTwlaSxFS0Lb0ERC5wHpDFLKXML/woXhl124mrKf5Ur3+RArP8T23CtaV6yOfc2E/yfGonyLVtqxhZhvW0cytrP8FXZvgBrOJmI0uzAbZF7qVgWsttqnTOwIPBXYIdEuIMA5MROBetoaVVhfihlGdvNEoUAfRQcDp37NprA2F4sPzWmrkB+JLCp3KZO5VmXL+LalmjfdBLQFd6ddJtwTicZxCbouV7/omewqP585t728HkJW+9NOai9UcHanuuygWAnr0fievq+PXPtu0IpufgMrnIqyaz6J+J4Q/rNT5+4VJaWM3Dk+joMWksPwI4CTRbRRFnQ0hnSx/0S5YHdx5JJvfcf4wrrisMvj/RVYY0YNc2CipAn4W6rmbgkZbyCevNzF+UmtZn8dKNk6rRAeWOXBmVWpw479ntoNBMkF15tlFgweEW5gOhICbPZxu
 kJjaeRNo
 IpsP6iF2UITPEnlqD1uL0J2xWZzD0OzS1Gm3uqZc4HH+6mt8UzsjhUcDH8dstXEyNikrZmVW1nrEYSicORm1Ov2aa01MlK3b8t5F/ADMm6iS7RcsMlmCtwwcI8IaHjDnKK1BuFTVCAmlQcihlx6qKy63xZVFASMfyPhqG5etQABP11hk39ORTcEyuyu7gqdo7QpuPYABXjmE6fMnm0VeK7cor7plW1P3QaxvDIKlHWuvZQqd/J/pD4L0c1x3/5eJcq7IDuw0bEo+dbScxH0UqgGDZEdsdrTEeVvCfhaMYdttiDgSTSo+cwV8JT+saTgs4vdQMvf3jCf7vy91ofwb3SeeLk48YZ6UiDU9rDjmL4IZ1sDxX5NcxNikM/39q0Tx9q+QNoohmFwN7aSA0wIYRV36El1XcagN4OpJjr4AQnfspuuCunWg3vh4vQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is one instruction more efficient than open-coding folio_pos() +
folio_size().  It's the equivalent of (x + y) << z rather than
x << z + y << z.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 mm/shmem.c    | 2 +-
 mm/truncate.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..c819cecf1ed9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1133,7 +1133,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
 	if (folio) {
-		same_folio = lend < folio_pos(folio) + folio_size(folio);
+		same_folio = lend < folio_next_pos(folio);
 		folio_mark_dirty(folio);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
 			start = folio_next_index(folio);
diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..a3d673533e32 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -387,7 +387,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
 	if (!IS_ERR(folio)) {
-		same_folio = lend < folio_pos(folio) + folio_size(folio);
+		same_folio = lend < folio_next_pos(folio);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
 			start = folio_next_index(folio);
 			if (same_folio)
-- 
2.47.2


