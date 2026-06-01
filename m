Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3AECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4276B026D; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C820E6B0276; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B9A6B0271; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0566B026D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7C03C1EFB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:50 +0000 (UTC)
X-FDA: 84830287500.06.8B6A08A
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6150910000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BvOaqovQ;
	spf=pass (imf05.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293469; a=rsa-sha256;
	cv=none;
	b=nNuuvfRgZ/Ht4SLwmOFQjaK1i6+T+sICbdLDPddeIOoaoSj+mVyw7AhEpYNW1PryslSgYL
	0B/mPgy/+fbJV5i6vgkk/GU8zq3DahjFZdUcHeK6PpRJW1xt9GNx1euYR8PVyKoM22K2b4
	NdY+E4m0jmG0yiEt/dVhQ4CgRlMjq9A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BvOaqovQ;
	spf=pass (imf05.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDFqU2w9pHRcm8QTKIbB6nvNnwHJfSBH479J/vtIl7g=;
	b=IkeyDRQ3eZgkxAyQ9ZyO79CIP63sJUp7dSU+Vm3jdnLr0XxobZ6Ji/iuEgGbuwxxIhlxPj
	4SSLjQaEZZKlanfm+wXG9Xq/xrl/djJX89h79xBDmkicnbiGXND2SfAttrMpv6EImt3kV2
	1ytOmwJBWGR7nEmWgESR0UfwcBhDMlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=uD
	FqU2w9pHRcm8QTKIbB6nvNnwHJfSBH479J/vtIl7g=; b=BvOaqovQ3mE7YeTvEm
	gYj756jset545UWabWC0ifzfxwm6IYv7JKAQM/28XgmBs/VEo4LD0uJXLrTp/UUp
	mKnKyZeI49ZYbFSsOKunpFrwGO5dGqrJa1tNPg6/NcS38JtNUPA/7uq74CzckZrS
	U53BRo2AJFTM9E26kwN0iPxEg=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S7;
	Mon, 01 Jun 2026 13:57:23 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v2 5/5] mm/shmem: optimize file read with folio batching
Date: Mon,  1 Jun 2026 13:57:04 +0800
Message-ID: <20260601055704.167436-6-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S7
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF1xKF18Gr1rAFWUuFy3Jwb_yoWrZr17pF
	W3KasxKrZ7G3y3Wr1fJF18Z3WrK3sayFW5Ja4fG3W3A3W5Jas8KF1xt34YgFW5JrZrC3WI
	gw1vkr1UW3WjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeuWdUUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2wO5V2odH0Nu4gAA3R
X-Rspam-User: 
X-Rspamd-Queue-Id: 6150910000A
X-Rspamd-Server: rspam03
X-Stat-Signature: pb1gtudfywkbrprqqunsaxtggbwgjc86
X-HE-Tag: 1780293466-58600
X-HE-Meta: U2FsdGVkX1+WA+eXgVUQz/wa1jqTkwtFtxzPXwO/WRvs5dNVvLE5WIPLP7SGm7OJTaHiI8TsZ+DFpa6eLLdbjcZ1q5Sghdp2bHyrHWjestQdn4mMwbmU1hkm6H2IAqaHoDkNjSNkVed0LOqBxaChez6MEHFpyopWKkYwc26x0GYDDnSbgGw766eXoYhDg9Dq5oLFCceDpUt12lQnXWfnjvs/I5jaVgd7CoJSfUlVCbJJDRBIp/5gf2GjwkpnELAd2FUod23DP8a3iYZ53YZPkCPKZdf5maQrmnfa+sVpwh/lfUKS6MEmmhYWDEKt/P/oK/DGpS+S28n2JqDOEja6PR64Vt27ByZTs5fX16Uh1NOoXbORQntea7uvJr5TZ1vsXfgROStA8XjXfF2X3vKS8k3AlzwI92B6dyLcr3zBmibOdlxzUqASxTH6N1CY8GrNE78OStObofopnMm3xMt/RSVuBzxxR4rl11kXJHAlAlaL9MHZDx7oygXi2HAV+eeFlfgNt2LtjQynZIMc/ZzPe/Z4XxhlScs7UzV+NcFWBEa4bltrFYsfvPc2CdISYL6sA0WHhqnjpYY/Ejh43tbWAdWReLhHEXp0Fa9MjZH6uAPHT9YuoeHLWTIznutaZuqi/eLHV9gZVl7Gw904W8MZUJCqC1aF+/vLOfolZE2lA62V0kqCksdeJB+cvQwHp3fVkkM6OZ0MNhM50DMUtagmG2scOp/24vMFq8pNM4ubOHHNwx3kE7rdcNs7uRlQRFm9rZ+8BQ2y/IJVKQNnHvGWdUInPgcw48fgxAcWp4MX/Tf/KzwB+4YGSgfJyfb/y6jlwF0cC95lDdynGQNMbU7jm/QK6ccuk8FKlLD0lorhEj7jg3SbGYqlH2UU3jIKegvAepFmavrECk+nv0VtndNgHFsqa4jJwHe6JHTswiBuftP2jzdHe5hEhSdzSIn7uhRfHrVxMaGkapT+Go8jU3C
 Byvcf/Sn
 u11ekzuQxmkq1fmZXkxd5nlgarBrdH6tVAUSORYqmgEP5N5ETgUeQ1t/6jYpXjl7ro/954h1YYPt7JOkx3Mnox7bwQvvLsnAeFAQPzP9mP4SOUfwjYerxpK66jM47dVDYeXVKrc5ufz8VIPfgbrrxVI+vdi4PMFQFPdNvFF40xlgPv0IpxUVdwBc9zkT1OtiuFofYHNlZ4ogRYrotArxWg3GbOi09AqigwxBVDmBqn/H5Si/+YbIYD7IloDFk4bvrAos5Ja/IwvvtfLIsRs03o9zpHTKE7fQqwcSFKsPesqjZxfCxXjMPqFBGNi6wjagv4IUDhtoUJc0bl3r1o65Z9LHm3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Optimize shmem file read by using filemap_get_folios_contig() to batch
fetch contiguous folios from the page cache, reducing the overhead of
repeated shmem_get_folio() calls.

This patch checks the uptodate flag without holding the folio lock, so
it may observe a non-uptodate state on a locked folio that is still
being initialized. This is safe because only zero-filled data can be
copied to the user buffer in that scenario.

A non-uptodate folio in the swap cache cannot be added to the shmem page
cache. This creates a semantic conflict, as shmem zeroes the folio out,
but the swap cache would fill it by reading from the swap backing store.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 57 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index cac355685e49..61937582f08c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -891,6 +891,14 @@ int shmem_add_to_page_cache(struct folio *folio,
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
 
+	/*
+	 * Don't add a non-uptodate folio that is in swap cache to page
+	 * cache, since shmem will zero it instead of reading from swap
+	 * backing.
+	 */
+	VM_BUG_ON_FOLIO(folio_test_swapcache(folio) &&
+			!folio_test_uptodate(folio), folio);
+
 	folio_ref_add(folio, nr);
 	folio->mapping = mapping;
 	folio->index = index;
@@ -3382,11 +3390,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
-	pgoff_t index;
+	struct folio_batch fbatch;
 	unsigned long offset;
 	int error = 0;
 	ssize_t retval = 0;
 
+	folio_batch_init(&fbatch);
+
 	for (;;) {
 		struct folio *folio = NULL;
 		unsigned long nr, ret;
@@ -3395,15 +3405,33 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		if (unlikely(iocb->ki_pos >= i_size))
 			break;
+fetch:
+		folio = folio_batch_next(&fbatch);
+		if (!folio) {
+			pgoff_t start = iocb->ki_pos >> PAGE_SHIFT;
+			pgoff_t end = (iocb->ki_pos + to->count - 1) >> PAGE_SHIFT;
+
+			if (folio_batch_count(&fbatch)) {
+				for (int i = 0; i < folio_batch_count(&fbatch); i++)
+					folio_put(fbatch.folios[i]);
+				folio_batch_reinit(&fbatch);
+			}
 
-		index = iocb->ki_pos >> PAGE_SHIFT;
-		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
-		if (folio)
-			folio_unlock(folio);
-		if (error) {
-			if (error == -EINVAL)
-				error = 0;
-			break;
+			filemap_get_folios_contig(inode->i_mapping, &start, end, &fbatch);
+			if (folio_batch_count(&fbatch))
+				goto fetch;
+
+			error = shmem_get_folio(inode, start, 0, &folio, SGP_READ);
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
 
 		/*
@@ -3411,17 +3439,15 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
 		fsize = folio ? folio_size(folio) : PAGE_SIZE;
 		offset = iocb->ki_pos & (fsize - 1);
 		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
 		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
 
-		if (folio) {
+		if (folio && folio_test_uptodate(folio)) {
 			/*
 			 * If users can be writing to this page using arbitrary
 			 * virtual addresses, take care about potential aliasing
@@ -3443,7 +3469,6 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				ret = copy_folio_to_iter(folio, offset, nr, to);
 			else
 				ret = copy_pages_to_iter(folio, offset, nr, to, &error);
-			folio_put(folio);
 		} else if (user_backed_iter(to)) {
 			/*
 			 * Copy to user tends to be so well optimized, but
@@ -3474,6 +3499,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		cond_resched();
 	}
 
+	for (int i = 0; i < folio_batch_count(&fbatch); i++)
+		folio_put(fbatch.folios[i]);
 	file_accessed(file);
 	return retval ? retval : error;
 }
-- 
2.43.0


