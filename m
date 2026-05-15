Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD266CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183F36B0005; Fri, 15 May 2026 05:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135956B0088; Fri, 15 May 2026 05:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024456B008C; Fri, 15 May 2026 05:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E210B6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8716F40274
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:01 +0000 (UTC)
X-FDA: 84769177962.30.C111932
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf29.hostedemail.com (Postfix) with ESMTP id 940CA120008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:47:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=G15ZBj01;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf29.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838479; a=rsa-sha256;
	cv=none;
	b=BkcTKfK8K15t5Zuvt5FD3D1wqcXRO8w4ICaGSq2yY6l2KnlvHAmEMn1SeHqTfl9vEocYTW
	kkqGoRV45BAuusmlr9iD+9+9qAT4m8PICn/ZuRKVKmDTHM4dOEBYozpO5GOYOSfUxv96XL
	b/5PN6r79pbb7mBMq2PreGxsEc4eRXM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=G15ZBj01;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf29.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1ch1LMRZ8v16TQ/TGRFBp+464EezxW+tb87/9Sva4E=;
	b=i1eFZYJ80koIwUcu78B4tRIPMozwStL9EaBFGKyS7aV3lxvSqlWET95ElfdRkxSJaqvi3z
	QqXZxp3Rvq31fXJW3n6s3D7POsNwlOYS6HGHcV5p/nPtThz8EU2kHnGZ62vJr+Hs9oinI+
	nTZ/fjLrnTXu47QjiBm8u2CvB5G5oIc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=x1
	ch1LMRZ8v16TQ/TGRFBp+464EezxW+tb87/9Sva4E=; b=G15ZBj01k81TcQUSs0
	3m3R/MrQfVi/YrxYMDFwaXQ3HGMNWCJG2D9HuyzGaKEdO4LG59WXiZVLgz2wJ0cl
	f7GoyiIKBpZRqsS3hLdmf9JOv763sgYA9MA15aroJoU/bLkMTgO8oUzzavq2n2RB
	VYfSarMnHTyYRgBhW46HDGjEo=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnVxek6wZq6RobBg--.38248S5;
	Fri, 15 May 2026 17:47:19 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 3/4] mm/shmem: optimize file read with folio batching
Date: Fri, 15 May 2026 17:47:01 +0800
Message-ID: <20260515094702.1092355-4-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515094702.1092355-1-chizhiling@163.com>
References: <20260515094702.1092355-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnVxek6wZq6RobBg--.38248S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr1xtr18Gr4rAry5trWxXrb_yoWrtF15pF
	WUK3ZIqrWxGr43ur4fJFWkZa4rK392qrW5JayxG3W3Z3W5J3Z0kF18t34YvFW5ArW5C3WI
	g3WFk3W8W3Wjyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jLWrXUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wdA3WoG66dn2wAA3x
X-Stat-Signature: epdqtzic5jn13tytpz5znk9aoniiad5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 940CA120008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778838478-735351
X-HE-Meta: U2FsdGVkX1/+J8i3Qe1k1NA4H0RX9U+3gRCet/dSCtT7kgK6+hitHCNjdduJZ8hMMRlT5ruxjMAUhUc2RIqqWgUXJWRKzfVNnv6gvqLDKtOT88yGPkHQU4aifNsT9U49da1EGY3qlWIV/CEa2nDRQGnBnVCRJgeOTxNn97VNdBcxDq9lCYzWdgmyFdVBUYEHaQVSRIMw5KBup0vvuECYhqeIPa/7PmDIzhGFaHrA5Yhoi0KjG1tSz9mGRO4trWlGAGgoV1zC1MOjU4Hb/5uvWZzYK9W1QORhXhkPhamoJQF22eC/efWt7yV2dmuq/5zigUBvglTVXngkKvNcnZoKHIdsj8z/lj9UpULPCQ+RLmhQQsTa0AytO6yWnOa3zMsJpzbqqM1vI0ZOKvbnzdrkZ2gLoXZRf1phecomcr610MgsKWvXj0xvlHrlH6/EUjQkkNg5s9fTHuq1S8EJehevXIXkMMdJiLZsfhnRQe2nnNndbLfphv74qqs1CiMZbTyPgjQjIBlr6q8SBAUxVv/FAsz/sur4aKYEVfElijHOMjQFLX983fzPDQmMRv8WKXghkhgRvHd4QkoLhw6ZskMlL22oFr9GmnzKvDeJKWB3IxHVnGxqK449qtDdWDems/lydXleP2fSMqyU8KB8racXVcv4HCZz6Iz7lesugtsPhjBNiWk6AmMH0eIyX0EOFQi2Q3KTQy1T5ZndQBI7cLA2gPk7Tf+0hHHwZQHF2XgyZJ/l/OCEe7WTXW7ZSn5AnTVA3w3usJJb2dvPnrRkpuCiecSQGT5eiPFEVyF8yMDr0tEYW4qMxMMlRl66EUDN/rgrs774xnXQPvuTopzJUy8oXmex+a70Mjf74/MFYp/SSr5jXLrZLXMXkxBlaMa4j4jTo911Vged4nt/zKbgkaCr+rjH5xHZyEzFPLdIAOrcG9i31dTh79p1yY/2V4LyY/MAnhUTW2nrqyvKp89kaoL
 2IX6OMWm
 dyL9SYd8HgjVUEaynTp81x77gb6UvX4F77EAqPwIhfsxNxN1Wjn04AtS6LM6ete2gGCoPVePK4nzaFDkgwl3Y6orFLOKpyD811+gRQub7CumnjmgcGisgDonJ85ediRosZ751aHqU8L6/1DMKyrkh/UuZ2IupgxAHNQkOBrtNiNT2YCHXjRnzctio5NPgaQe8rjf5xgKrq8gkGEJNSXuzgaGfJy3EMLh4NJNNnVzII5O/tPhi2lq0iGUyPQSjPoqRIVdBBlB1d3QwgQDmmH7Ct9/9zgY0neAb0PxUbMjFiQvw4HR5xiOvrRLlcqBSA5mru1CZ8PRxJrAqFM8Cfgi6TZ82pKHidlMDjDP0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Optimize shmem file read by implementing folio batching in the read
iteration path. Only uptodate folios are added to the batch, ensuring
all folios in the batch are valid and ready for use without additional
checking.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 93 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 767610f78d0d..4bc4e463ca97 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3348,16 +3348,100 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
 	return copied;
 }
 
+static pgoff_t shmem_get_read_batch(struct address_space *mapping,
+		pgoff_t index, pgoff_t max, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, index);
+	struct folio *folio;
+	pgoff_t end = max;
+
+	rcu_read_lock();
+	xas_for_each(&xas, folio, max) {
+		if (xas_retry(&xas, folio))
+			continue;
+		if (xa_is_value(folio)) {
+			end = xas.xa_index;
+			break;
+		}
+		if (!folio_try_get(folio))
+			goto retry;
+
+		if (unlikely(folio != xas_reload(&xas)))
+			goto put_folio;
+
+		end = folio_next_index(folio);
+
+		if (!folio_test_uptodate(folio)) {
+			xas_advance(&xas, end - 1);
+			folio_put(folio);
+			continue;
+		}
+		if (!folio_batch_add(fbatch, folio))
+			break;
+		xas_advance(&xas, end - 1);
+		continue;
+put_folio:
+		folio_put(folio);
+retry:
+		xas_reset(&xas);
+	}
+	rcu_read_unlock();
+
+	return end;
+}
+
+static inline int shmem_get_folio_from_batch(struct inode *inode,
+		pgoff_t index, pgoff_t last_index, struct folio **folio,
+		struct folio_batch *fbatch, pgoff_t *batch_end)
+{
+	struct folio *next;
+	int error;
+
+	if (*batch_end > index) {
+retry:
+		next = folio_batch_next(fbatch);
+		if (next) {
+			if (next->index > index) {
+				next = NULL;
+				fbatch->i--;	/* revert folio_batch_next */
+			}
+		}
+		*folio = next;
+		return 0;
+	}
+
+	for (int i = 0; i < folio_batch_count(fbatch); i++)
+		folio_put(fbatch->folios[i]);
+	folio_batch_init(fbatch);
+
+	*batch_end = shmem_get_read_batch(inode->i_mapping, index,
+					  last_index, fbatch);
+	if (*batch_end > index)
+		goto retry;
+
+	error = shmem_get_folio(inode, index, 0, folio, SGP_GET);
+	if (unlikely(error))
+		return error;
+	if (*folio) {
+		folio_batch_add(fbatch, *folio);
+		goto retry;
+	}
+	return 0;
+}
+
 static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
-	pgoff_t index;
+	struct folio_batch fbatch;
+	pgoff_t index, last_index, fbatch_end = 0;
 	unsigned long offset;
 	int error = 0;
 	ssize_t retval = 0;
 
+	folio_batch_init(&fbatch);
+
 	for (;;) {
 		struct folio *folio = NULL;
 		struct page *page = NULL;
@@ -3370,8 +3454,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			break;
 
 		index = iocb->ki_pos >> PAGE_SHIFT;
-		error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
-		if (error) {
+		last_index = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
+		error = shmem_get_folio_from_batch(inode, index, last_index, &folio,
+						   &fbatch, &fbatch_end);
+		if (unlikely(error)) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
@@ -3379,7 +3465,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (folio) {
 			page = folio_file_page(folio, index);
 			if (PageHWPoison(page)) {
-				folio_put(folio);
 				error = -EIO;
 				break;
 			}
@@ -3394,11 +3479,9 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		 * are called without i_rwsem protection against truncate
 		 */
 		i_size = i_size_read(inode);
-		if (unlikely(iocb->ki_pos >= i_size)) {
-			if (folio)
-				folio_put(folio);
+		if (unlikely(iocb->ki_pos >= i_size))
 			break;
-		}
+
 		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
 		if (folio && likely(!fallback_page_copy))
 			fsize = folio_size(folio);
@@ -3433,7 +3516,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				ret = copy_folio_to_iter(folio, offset, nr, to);
 			else
 				ret = copy_page_to_iter(page, offset, nr, to);
-			folio_put(folio);
 		} else if (user_backed_iter(to)) {
 			/*
 			 * Copy to user tends to be so well optimized, but
@@ -3462,6 +3544,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		cond_resched();
 	}
 
+	for (int i = 0; i < folio_batch_count(&fbatch); i++)
+		folio_put(fbatch.folios[i]);
 	file_accessed(file);
 	return retval ? retval : error;
 }
-- 
2.43.0


