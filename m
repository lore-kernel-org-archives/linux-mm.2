Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13F4CD6E5E
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B936B0272; Mon,  1 Jun 2026 01:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5C96B0271; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EBF6B0273; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADD076B026D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AAF21A0588
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:51 +0000 (UTC)
X-FDA: 84830287542.04.6706A6B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf21.hostedemail.com (Postfix) with ESMTP id EAA131C000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ND7AD0lX;
	spf=pass (imf21.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+6KLnho3oezstBwK6DjSQ5GUBc1NeDmONzGfJ6sfTU=;
	b=zJ1RfPQ9wGs0HKsqLwRVicLy+/9yaF6hpeKfnyU8fg2cZwRCJEg1G5MqLIZZ81snTyQvDR
	okqW/TBFnwRZN1k/yIX9iCYJZ8WsJxgVjYeIEhXwuaQPrJoonKSuvUqEueUDuU+RL1FQCy
	uE/luvQ0ZBd7Y2OHYjw0quf57644Qlg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ND7AD0lX;
	spf=pass (imf21.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293469; a=rsa-sha256;
	cv=none;
	b=f5/IrZd7k2knaF89BHtiNfGP5giVkLAQIW5UfRHDAXPQtaeGi4I6CUI/jpG7mzu1qrm3OX
	XnBftxFxaNHmzwq7iWbGgTcKXHGX38zhHaCWrnG8jYuWxlXDzQiQhOVZ/ioX8zW3VlQlCa
	tT2iHWwWGkgNQKdtaaGyt6zYIUWBjf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9+
	6KLnho3oezstBwK6DjSQ5GUBc1NeDmONzGfJ6sfTU=; b=ND7AD0lX3Pw6CblwZR
	ne7nKzAjfBi6+VNGaDazXYvQ2e/OV8wq2YI/gr5wnKvO6Deoxmyw3RcL9CDvKEAY
	984cD5HEAgPcOEsRcoNUG8NGtOJuupYBnu2HaWK4sNYfs4QWdZfkn+5SZra5iJFa
	QicBpYy42Xf5N6kzCLl4Rhsa4=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S6;
	Mon, 01 Jun 2026 13:57:22 +0800 (CST)
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
Subject: [PATCH v2 4/5] mm/shmem: remove page-copy fallback in shmem read path
Date: Mon,  1 Jun 2026 13:57:03 +0800
Message-ID: <20260601055704.167436-5-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF1DWF1xCFW7Kr17Wr17ZFb_yoWrCw4xpF
	W3KasIyrWxJw43Gr17JFs8Za4rK3s3JFWUJFyfG3WfA3Z3tryrKFyUta4F9FWfJ34UC3WI
	gw4qyr1UWa1UAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeE_NUUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+AK5V2odH0JEmQAA3j
X-Stat-Signature: 4prdg4m4ebyiw398gzfmxtr6t4gpgrcs
X-Rspamd-Queue-Id: EAA131C000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780293468-518313
X-HE-Meta: U2FsdGVkX18Zd40wxVu4+WGp4ARwyH3XFBo0DEGGReCQyY1nGG2gxeYKcyKR9o1aAT++C7k0oAh6MOtyhobDiRNVSGW7AkQkknlIEyKOGHnKA21xNnNfFYj+I4DAableNCTn3eQo3jSoodLS0HrG2xWt6Ht2NRqEo17Zt9fb2lGts8xWxcmzF+KogtGuFi6iOFmV4jcxdm2WzmsmlJDmiUeEwN8g9gO451Hhz20vmW/B77y10hqZnXjluFKyTHzAcMluaDUxKlC4E84yxIyEusLGG6xtgWVkcAvkpk8OvdU1LQ2n+WduaLnUyf9WsqStL5LKH8yQyZI6rmL9XimlWt8QXeBLzaohXTtMPg3d1BWlhxY3ooJuH0pQAIiMQZ+Y0wlblIWwYNrcRii9CXyQLjxcOEZCJ7AhWxxZ86I0ZFTOLpckgJg6AKCUgToFE25pYuBk5/zdvS3XkngmzJmpFSZaqkMB5Cmy8N5bFgvHJ5GL1nhij8hEtSF5tuln6V72A4bswSqWqwwy+ldhlGGXCMakdcjrgKBqHcr/8frkqPfelkeg3RZhSt3YcNK+wUUGXdXT02i4xNDqjzs79TRCM3+oCNppAjxdz7alEDTpetyTgqCXeQgwZmEN4eQtLWrAnMsyG6HQP/UlGizEoaGhIgq6PBwHsrpE8vjAyoM9UH9KEmfyDu0HTASYT3y3yizb4ivOxEFb0DM8QbrwTwrsyh8L1CtEg3TXqOoS5WVcDAWAWWqsqr8QS4h/r6ez7aMU5WF6AS+4QFeL+5O6kzh9iUMnR2O+UaqJDmuQXbfQt2oQKlVxAWISboetlF3gcwLecdFq3yYp7fy2uRDRCftqc0hXFCuGyRYfBBrb2AdK5rBukja9IqVcBqjB+JTjHEAxcIeqgYFLfF9mmz4ZymSIiDRoQuEM6QM6/H4lTiuE2lPboq3otmdZRXdF/ms3bLdGY2xqUfmOYausHpQovc2
 Lu7IScUd
 HtlBz0O4vl3SWYuptPajDPCo+T4lJV4hYOzakf6cKORM3XyuHdLqqwBaGV0JXqucV0ticZpkJ3IHNueSMwFRt27Bm7epMKyV9Hr2KwEU2hialt3TGZiBQCuqmUt23exaaVvGLA+pXhM1r1/FjTqjfnZdAsrhCLgW1BpV46ndugmP4D3CGDYf9VArKMru2KrIs1rP0MwH0i6CCk72q0zxFUA4yAiAcBhrErgeiYgpQcSNNjUSAB3RB6pqipezDZZXwa2EDyyxUA7TzdgI1+19AzejKRbsDNAKGDfJepha7vG3xJfRXzPgeBP2f30vIsLk57ONo5V51Uzc9JPUhKzxdPwSTig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This is perp patch for folio batch support which removing the fallback
to page-copy mode from shmem reads.

The existing hwpoison fallback would require fetching the same folio
multiple times to read its each pages, which complicates the
batching model. Instead, move hwpoison handling into
copy_each_pages_to_iter(), allowing the error path to be centralized.

This simplifies the shmem fast read path and avoids special-case
handling that conflicts with folio batching support.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 63 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b08118fbd275..cac355685e49 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3353,6 +3353,30 @@ static size_t copy_zero_to_iter(size_t bytes, struct iov_iter *i)
 	return written;
 }
 
+static size_t copy_pages_to_iter(struct folio *folio, size_t offset,
+		size_t bytes, struct iov_iter *i, int *error)
+{
+	struct page *page;
+	unsigned long off, nr, ret, written = 0;
+
+	do {
+		page = folio_page(folio, offset >> PAGE_SHIFT);
+		if (PageHWPoison(page)) {
+			*error = -EIO;
+			break;
+		}
+
+		off = offset_in_page(offset);
+		nr = min(PAGE_SIZE - off, bytes - written);
+
+		ret = copy_page_to_iter(page, off, nr, i);
+		offset += ret;
+		written += ret;
+	} while (written < bytes && ret == nr);
+
+	return written;
+}
+
 static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -3365,10 +3389,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	for (;;) {
 		struct folio *folio = NULL;
-		struct page *page = NULL;
 		unsigned long nr, ret;
 		loff_t end_offset, i_size = i_size_read(inode);
-		bool fallback_page_copy = false;
 		size_t fsize;
 
 		if (unlikely(iocb->ki_pos >= i_size))
@@ -3376,25 +3398,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		index = iocb->ki_pos >> PAGE_SHIFT;
 		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+		if (folio)
+			folio_unlock(folio);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
 		}
-		if (folio) {
-			folio_unlock(folio);
-
-			page = folio_file_page(folio, index);
-			if (PageHWPoison(page)) {
-				folio_put(folio);
-				error = -EIO;
-				break;
-			}
-
-			if (folio_test_large(folio) &&
-			    folio_test_has_hwpoisoned(folio))
-				fallback_page_copy = true;
-		}
 
 		/*
 		 * We must evaluate after, since reads (unlike writes)
@@ -3406,12 +3416,9 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				folio_put(folio);
 			break;
 		}
-		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
-		if (folio && likely(!fallback_page_copy))
-			fsize = folio_size(folio);
-		else
-			fsize = PAGE_SIZE;
+		fsize = folio ? folio_size(folio) : PAGE_SIZE;
 		offset = iocb->ki_pos & (fsize - 1);
+		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
 		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
 
 		if (folio) {
@@ -3420,12 +3427,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			 * virtual addresses, take care about potential aliasing
 			 * before reading the page on the kernel side.
 			 */
-			if (mapping_writably_mapped(mapping)) {
-				if (likely(!fallback_page_copy))
-					flush_dcache_folio(folio);
-				else
-					flush_dcache_page(page);
-			}
+			if (mapping_writably_mapped(mapping))
+				flush_dcache_folio(folio);
 
 			/*
 			 * Mark the folio accessed if we read the beginning.
@@ -3436,10 +3439,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			 * Ok, we have the page, and it's up-to-date, so
 			 * now we can copy it to user space...
 			 */
-			if (likely(!fallback_page_copy))
+			if (likely(!folio_contain_hwpoisoned_page(folio)))
 				ret = copy_folio_to_iter(folio, offset, nr, to);
 			else
-				ret = copy_page_to_iter(page, offset, nr, to);
+				ret = copy_pages_to_iter(folio, offset, nr, to, &error);
 			folio_put(folio);
 		} else if (user_backed_iter(to)) {
 			/*
@@ -3462,6 +3465,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		if (!iov_iter_count(to))
 			break;
+		if (unlikely(error))
+			break;
 		if (ret < nr) {
 			error = -EFAULT;
 			break;
-- 
2.43.0


