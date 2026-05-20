Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0502DCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A52D6B0092; Wed, 20 May 2026 06:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F456B008C; Wed, 20 May 2026 06:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B126B0095; Wed, 20 May 2026 06:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDC46B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB2E61C0143
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:10 +0000 (UTC)
X-FDA: 84787400460.18.BFA38F6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59E2510000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bjPI6Jhy;
	spf=pass (imf05.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POY07p4j3GPNthuCu4k23r6LNTlq73DDrD9MKLgmiwk=;
	b=qL8xUKal35u3YTNHlieA/57nT5oHx7nhaS0bO/zIsrRiIunrG7NbMICbEABLeaFXIbzwOf
	PSVgGuMldz6WJ1EwmEqbOSPycjNii3Tc9iY3Lm3gKYk7WwbAOO5lhWufjoKy/fR4EQgUip
	lRXO3Ua+HGRSVyNQ+Hay/TrK5RkV2Aw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bjPI6Jhy;
	spf=pass (imf05.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272349; a=rsa-sha256;
	cv=none;
	b=KdCDMNaXDQMP1N+L0ofcn90J3UCb9OFvLu5EYggO/H4uxbdUCAGb85nwY+nF8OmV/0mYwW
	E1cUSOn63W3OZFZ4pZUkQeIt0aeE2l6qq1MnjBKPkGHSv7NUtTGNpxZqyFMYGGHnlrOD/G
	R8PdCE9MRoysN6wvqBkPoZ4gSe4CNfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PO
	Y07p4j3GPNthuCu4k23r6LNTlq73DDrD9MKLgmiwk=; b=bjPI6JhyYxNG7cJPhz
	OGjxgBVi3zkiNRH/3i+lshSHVTH24MxKIYauZD+5SBvgzQWsezV4h2+64cYie76f
	uv28g+XqDwsRzDUgD8bim6RipQNFx138Z1I96Ei5JAfgWRtda+9IeqorWlpieuP3
	7n9R9gbRlPYJVkReKTkh5exwg=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S7;
	Wed, 20 May 2026 18:18:26 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
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
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 5/5] mm/shmem: optimize file read with folio batching
Date: Wed, 20 May 2026 18:15:38 +0800
Message-ID: <20260520101538.58745-6-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF13ur1kJF4UXr4fKryfZwb_yoWrXrWxpF
	W3KwnxWrWxGw43Wr4fJF48Za4rK3s3tFW5JFyxG3W3Z3W5J3s8KF18t34Y9FW5Jry7C3WI
	gw1vkr18X3Wjvr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jISoJUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xKcOmoNinIMpwAA33
X-Rspam-User: 
X-Rspamd-Queue-Id: 59E2510000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 18w5ertbdw9dhtmg94xczqcmtbpz5txd
X-HE-Tag: 1779272347-759468
X-HE-Meta: U2FsdGVkX1+IDDBHSOWaAP305IsKzB70F4GE5IN6SyLM0W0EFIBZezDJeM9OsQOJ+5EAqwEk3bFHITJxAxc/7ZQXC2j59+EUpBcf42cPTHdvxhsCncXIsQVKeL14du/6f+pd2tYNCqilzXYb/+ZCiKwYkOSmru2macBnIowWgWo3P5OX/qfwYuMumz6clk2iYZ/GfObL15POszjOx8dmr4ySUTuIEvQBwCWs04wv4NVs4IcwhykbE1ZusU1iSSN3CXCu3tsRcIQI5OKy0XXATknh3N353j7WiVARgtL9TbjUbKpE/KCTlOLMz1WWWzTMBI/MtExA6sXncG//diigpH7alaQDd92VkJ6kQIdl/mBkcDaeNr3hioPTftg+mdSQBkc5QowMhPzh8rKIt+iscXso+j5x7mFOnPlYh7PrAPqg+Ketts/Id8N+feXAwGVlkd/gfwMIzXTPzIJwwYov74Pl9LLzFe9seMFyujA+Pb5VGar5ZMPwiUMQ78gWz2BWeIZmwzXTFsbKGw4rnf051qe1mQ/W6C0S5EmOFsjg5jpscKQOuQOYKQSaiCBFsxyHZmpAonmfn+M5otnk3uV/Kce8UQ5LYv6WxlG25dnNX6B3acVVIux/Qr5Y+X39V0TGlVEfH/EbtDD0PZDOYnkO99FIohSDuAER9G8HNetTcxVJdHDRmSBAaezq3Zx0CmkX9GjYYtGCu6jnaoXA7a4tKg2C99MwPN/IsRuR7kL7kQE450MqRAEMYSuBU1ousFasA/Jugz1RotBdEspNIK+JBbuqJ6T2rPSwyj9yeurlLCpbGTLnCKYPGAVmSQX74nNgPfVszwnymb6lq9yj1Tni2KYeMS/az1mYCqrnmHOhQi9J1srJl4KAP0rNrN6pFMKhzuz+sncxZBJ7ESphl6qSVKDKUH1h38naAEK8fQl7Q4NTvO/YVZz79bHUU6NhWdgsS8u9oXZvjpgk5W8XotQ
 Q11oWssA
 485TPMn1Y1MS02tIdOUSv8FPIiBNkzbhTGpZPy7wiHuaCxglqqF5Fw24DqGS8KxLpwIUbM6Au1y3A1jonFCWfKKSA0TExArXHwtDl0sww0WVktQmglj+yeF3VkzdMa+KzcAf9RaFSICOrboGyxCsIeYz04xQYCLa2UTWLORFpoZqteJVjHyXgowvbGppLiXIEsNnamT6vZYnTHKD43m5ApGpNrHPTrA5OvVqiSk7Mxwmmj/B8rxsbaSkb7x4lwSWrVjI/JNhQSqvj+YjxyjHvu+TfRfpGwbjk/xgIaqW/7W9X9RXesD6ym5hvY2ARismzreoAJrKI5eijXAFM8D2DD0uUiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Optimize shmem file read by using filemap_get_folios_contig() to
batch fetch contiguous folios from the page cache, reducing the
overhead of repeated shmem_get_folio() calls.

When the folio batch is exhausted, attempt to refill it with
filemap_get_folios_contig(). If no folios are found (hole or swapped
out pages), fall back to shmem_get_folio() to handle these cases
individually.

Additionally:
- Defer folio_put() until the batch is exhausted or on exit
- Add folio_test_uptodate() check before copying to ensure data
  validity

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 96ea5a4c0aff..e0eacc23cccd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3355,11 +3355,14 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
 	pgoff_t index;
 	unsigned long offset;
 	int error = 0;
 	ssize_t retval = 0;
 
+	folio_batch_init(&fbatch);
+
 	for (;;) {
 		struct folio *folio = NULL;
 		struct page *page = NULL;
@@ -3372,18 +3375,38 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			break;
 
 		index = iocb->ki_pos >> PAGE_SHIFT;
-		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
-		if (error) {
-			if (error == -EINVAL)
-				error = 0;
-			break;
+fetch:
+		folio = folio_batch_next(&fbatch);
+		if (!folio) {
+			pgoff_t start = index;
+			pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
+
+			if (folio_batch_count(&fbatch)) {
+				for (int i = 0; i < folio_batch_count(&fbatch); i++)
+					folio_put(fbatch.folios[i]);
+				folio_batch_reinit(&fbatch);
+			}
+
+			filemap_get_folios_contig(inode->i_mapping, &start, end, &fbatch);
+			if (folio_batch_count(&fbatch))
+				goto fetch;
+
+			error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+			if (unlikely(error)) {
+				if (error == -EINVAL)
+					error = 0;
+				break;
+			}
+			if (folio) {
+				folio_unlock(folio);
+				folio_batch_add(&fbatch, folio);
+				fbatch.i++;
+			}
 		}
-		if (folio) {
-			folio_unlock(folio);
 
+		if (folio) {
 			page = folio_file_page(folio, index);
 			if (PageHWPoison(page)) {
-				folio_put(folio);
 				error = -EIO;
 				break;
 			}
@@ -3398,11 +3421,9 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -3411,7 +3432,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		offset = iocb->ki_pos & (fsize - 1);
 		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
 
-		if (folio) {
+		if (folio && folio_test_uptodate(folio)) {
 			/*
 			 * If users can be writing to this page using arbitrary
 			 * virtual addresses, take care about potential aliasing
@@ -3437,7 +3458,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				ret = copy_folio_to_iter(folio, offset, nr, to);
 			else
 				ret = copy_page_to_iter(page, offset, nr, to);
-			folio_put(folio);
 		} else if (user_backed_iter(to)) {
 			/*
 			 * Copy to user tends to be so well optimized, but
@@ -3466,6 +3486,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		cond_resched();
 	}
 
+	for (int i = 0; i < folio_batch_count(&fbatch); i++)
+		folio_put(fbatch.folios[i]);
 	file_accessed(file);
 	return retval ? retval : error;
 }
-- 
2.43.0


