Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92198CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9116B026E; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7796F6B0272; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D266B0270; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 397436B026B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C263E8F1D4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:50 +0000 (UTC)
X-FDA: 84830287500.05.13D58E9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2608E40002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dQkui9ew;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8RQrqromftC/nCPgQZhg6QK2Ox4EieThtfTf6AdAQo=;
	b=BLe7mILE7tX0jSQHt9KBjhvconU9CvWH/oa44k8OsdEUejXmkkAkOjTnOCJwzTt8Ta3drw
	jRQ0jQmHaI1JcgupVBfU49LlrCtB06D05KYkfuxLyH+GTE9a+LSOAZzA9lxw10Rj3mEEbw
	bhz37UEO0wE/L/EFWP8AvGieCPKOTdM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dQkui9ew;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293469; a=rsa-sha256;
	cv=none;
	b=BuHfm1e4z3cG/fDU38nf1CJlSvprH1+3r9ZkEx/MQRojKkCAfQ4SUNAoLGWPouzaKYAKju
	rj5HgihOl7jLnfkbcDr0MTgNLGTiEWcuWnMx4ws6TGj+oxGylETuseHrZ84+hxZPToZUB5
	ASspgP5+bP0SxFcvWwJgXTxgD8cbLoE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=y8
	RQrqromftC/nCPgQZhg6QK2Ox4EieThtfTf6AdAQo=; b=dQkui9ew9GNqXbNcE6
	xWnzBmmRZQ25fnJ9RyI8uabGx6AnJkV84lvibaoa6svGxSn/AT6BDIhsk+QIK/9+
	lWV5UmeJTHkArpo0ghvPMKylnRj5RUe15kNf8/UUF4F1/kwpXdR8vGjAcobHfgfd
	8oyBC2hV+UbLEc0R/leHRdMEs=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S3;
	Mon, 01 Jun 2026 13:57:19 +0800 (CST)
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
Subject: [PATCH v2 1/5] mm/filemap: reduce unnecessary xarray lookups when read cached pages
Date: Mon,  1 Jun 2026 13:57:00 +0800
Message-ID: <20260601055704.167436-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur4ruFW7JF1rZr1DCFyrXrb_yoW8Zr13pr
	n5Ka4ktr4DJFWYkrsxJ3WxZa4rK3sYqay5JFyxKw1fZFn8JFn8Kr92ga45G3Z8uFyrXF1I
	qF18Xa40gF45t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7a93UUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9x+4VmodHz9QMQAA3w
X-Rspamd-Server: rspam12
X-Stat-Signature: keq3rig3x4dx65a8gfrhg3jkos6mcrgj
X-Rspam-User: 
X-Rspamd-Queue-Id: 2608E40002
X-HE-Tag: 1780293466-100351
X-HE-Meta: U2FsdGVkX1+KDUkXWAAH9EWUQGTOTq7dcI9SBjI4yjZc/1NtKKbLfGCLZKoJNSOU6ySLQBU7DmqbTx7yC+gKrmT0ejW2SZXvNo22jduw1JclKePAYqlLBEHgq6nbyYkk8qccF8cKvRISa74XtgdI2G2m0jBRD4zM4ttpYBO1Emv9Ulg7MQIfV+L6b6wvvh8Ze49/3iWeqmzVPzvZM33W1xXjI7oJoJCnnJ9g5vAbUW6rehbbSfBVaxAOsDp5RPq30AEqlDPcRQSHuO+cOmVu2vK3va+UyhXOlc8FAvuPrJzk8jYGgsHh62BfS/xjPXbGmhdKx99SB6nBGl5TjvAhH7r7vV3OQtta//kaEW7uteZBpcBo6voFfa2avffQ5vXbCesLVEOkj5rLZlMQMShr1MXkR5SrKfMYIrSH97m3ycYM/31TRpr2r7rUo2bvveB62pqRJuElGC0LCIC3ANp09e+TRCueZJLkiHCueObeW0hxkhSV9JErtkZfH9WltD0kY7CqQ3MmST7pyKSC0h1QaqV28h1NIR77dScadkVAMLh1njQKL0gFTInaWZGH7YjieLGIPK8vn3uf/+LfxDwdl98IKC8ilTqxriGmTtGJGFSFV2uDw7xuYFKnKUdhd/u/BLPKKB1bSZ4qBUy6sMxFIsGBP8NIb0PCogCfBLuE62D+jAOVbHa7pb8OfetNstMSx4/RraT68EnHBzLMgPQPDoMHLzN3JqDanmUeyKYxA/RiaZnO/WyT6O/wlvH5TO41xZkim30yl/3wqH+MpLV58fRUgxowA21fYbB0WDOSK7kPXw5UZCYzdzalR0hlOPGqUhdwLp3vopVSFBDcXs02ZgFC/F80J3+ZWqV8pAFe4JRVFhI/Fkk7mhpyBKOCGCIbhf1BCkOhvnpFfznVEbXSfc6qdrpUwDrb+N52lqdR7sUSGkbv0aS6dwBGocPlfEJKo00l5iHWuLQe6qruzKf
 yR+UXG8g
 Y0/IjXXKnDKppB9Obc63hp5gAh93/VuckjqvbwdujDELgPDoHyU5oE2LZ2XcNrODu8degMo++NPYVll3CGkf0b2L5w2SA2txdR9j96V7O6rQEkUfrEutrXSZrkRh7HeyVzcyxLdU2UczfoNlL/deMMtEnWmqn8Ya3O6kiT0wS9EmSWr7hmvmF7p53B6esZrp2iNOwNiHoVOHlT/Mxfp38LhiX2aseJg3DCpdxgyPkI836MuUSzX2cflT5t5QKufolYxWvPy+jruGI/1c4/CP18dZJLjeoqZh08wMCcYM+LQVT0M1AFLqcjOqrHiIl5nPWaPa4znVI9NsO7z4GL7707Wb8Db2cbhWxV/0B63NReqjMfJPGUrXcMuUdcSg8kr0beAxE3B+6YGCoPIZQ+PD7AbaFtXMAwgqYsAud6fn/MEE02hnvZiiy4036w3kUzlXyyrUVdAMXX/IYtMYuKDcZcd7bWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

When reading small amounts of data from the page cache, only a single
folio is typically returned from filemap_read_get_batch(). In this case,
calling xas_advance() or xas_next() after adding the folio to the batch
is unnecessary and only introduces extra branches.

The same issue exists for large reads, where one additional xarray walk
is always performed before termination.

Quit the loop once we get the last folio in the range, so the final
redundant xarray advancement can be avoided.

The xas_next() does not update xa_index when xas->xa_node is set to
XAS_RESTART, so the put and retry path would not update xa_index,
hence the warning should therefore never trigger.

During the 4k reads test, the overhead of this function dropped from
2.91% to 2.53%.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..d54450e529bd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2458,12 +2458,16 @@ static void filemap_get_read_batch(struct address_space *mapping,
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
+	pgoff_t next;
+
+	if (unlikely(index > max))
+		return;
 
 	rcu_read_lock();
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		if (xa_is_value(folio) || WARN_ON(xas.xa_index > max))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2479,7 +2483,11 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			break;
 		if (folio_test_readahead(folio))
 			break;
-		xas_advance(&xas, folio_next_index(folio) - 1);
+
+		next = folio_next_index(folio);
+		if (next > max)
+			break;
+		xas_advance(&xas, next - 1);
 		continue;
 put_folio:
 		folio_put(folio);
-- 
2.43.0


