Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3544CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BA66B0270; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A111D6B026F; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704326B0273; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7686B026E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE74F4052D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:50 +0000 (UTC)
X-FDA: 84830287500.01.41D8D0F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 297FAA0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=CAX058sM;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwM4pkP8SJrbgKz+ttAiFjnJ2HZxTx+PZU1H2nT4urU=;
	b=SmXPJPEScpweRdZRRtbNsazIa9aFekXSMbodmRBsaTYAZK/QIr5hZepep5z/mteZ5rdkF2
	P9xllupGz5lMTZHMUho5JbRzDQpQHBfp42tPENLpno4ZhT7Rg/5a05qPwxqaKNqUOq1cVU
	aO7WyQ9yGE0rkGwATiuSc3Yrn/J15XA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=CAX058sM;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293468; a=rsa-sha256;
	cv=none;
	b=P554BKRfcTPc0reIsbb5i6aLKZZgFiArz1vJ+E6J6hfH/ZkKRAyk1y7E/g0xsnNZKW1afg
	zKH/6Rhj4Tn9rt3M+RWqcJ5JFQEJ0VeBSMGzduGnS9zyRP32k6Zfl7VjghaaBvEap0hnl3
	/P1mHFyi58q6RzrbULwc+fC36EAFi0k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Gw
	M4pkP8SJrbgKz+ttAiFjnJ2HZxTx+PZU1H2nT4urU=; b=CAX058sMffpNy193aq
	v83uUOayxBBAYsZi1oA9/Il+UOCBIyuaJ/tp5HCEYtUKcpGyAsIHqg2IdM+NzByK
	AU3bAlF4tkHoGIB6qszRG9esP2NcI6zlmsVDlR63pgHbPRq0SKe8iTBTdT4tO7Fv
	XYfQCCgLVv44ZxHWLx2aw+F6w=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S5;
	Mon, 01 Jun 2026 13:57:21 +0800 (CST)
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
Subject: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large zeroing
Date: Mon,  1 Jun 2026 13:57:02 +0800
Message-ID: <20260601055704.167436-4-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4kZr13Kw18Kry8CryxuFg_yoW8WFyxpF
	y3G3Z8ArWkJayxWw4fXF4rur1Fvr93JrWUGFWxGF4YvFn0qr90qFyrKFyYkFWfA34UGw1I
	qa10yrWYka10yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j70eQUUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wG5V2odH0FQZAAA3F
X-Stat-Signature: f6jgo88z3skuegz6pbh4kw9ti45ymuso
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 297FAA0006
X-Rspam-User: 
X-HE-Tag: 1780293467-587748
X-HE-Meta: U2FsdGVkX18f0jEZQTjUebcJNIyyQSkSVzxZzstD3uOtN+ScUGuZZ6ukM9zicrow7KSTLBMIupzJGZp6orK3bHLTNRwuaAPiDrjSlf1WwCWS3w8vFDEu7/EMa6H3Xw17L321P5wgKO8oKCICSyPcRBshzMgJT7BCvom/sQZ7kDGe44UPoO+ssgkQ68ir1IoW9Wnmr660EoFvFPqIqgsXA9rsLVsg5LNrNpkzV+kIS8Yz7xewBzoPmP05szIQT9htGfAyuJDYi+tb7w33vvbeNYYCq8g/oBNXmQ1ePOeRW2mvRRo+C45k7NDLoj0lzjxwdms5k3SsbqJXMlRtoUIcbMniK4cegKhM2G/Qye+5WBqW/wPYbDhtobhsBGmkrkWnSRYvZXf+OLQoFzoueQ71Zp8TRtGG5c3n8k9Mr1G5r4U+YLpDZ5S0ckETGBZpFPEnXlnaz+IhQbCCAWvxUhAM6ICB1/U6n0vS6nemeLnI4W7yJcjQdkf4OReQvHt30IVlwr8H2hDYJWFrD5dxMVvFW645+4Aaq43+hjt7CIvl3TY07LYC9/n+J9CCdidH8HZpyh+zj0OMf7vGdhYn1JY411Tvvfrkuw39Utk9J+8CIuJLSLcxRR1T6zyvxLEWOLn+4uJUPHDqMRUsGtcuZpDt3C3aF0VcPhdl8dS+lf/tfXRxcxV0nmDdKVOFRFvgitHL2tTLJejXtsO7qkNImW9IpBsgBPVcVSYuJH0zP+i+6qPaxW4WZ8+QUexsL5x0EXS72Gt8cnl3CWAE/+HzNtJIQc2vH4BsmPqOK4wKCVtVakDzVBWshB08/+05ucHiaQL6SljlT/rLN9rx8wgV3KNbSL1JWZxrpw5AUcPIhGjaAjelVT8+356D3tv4mrVzTBzXV5O9rIJqE5l7XV8XChS5OGwqMHPAS3esMCYIQePKXAdMnAGEz5u4lCu8LCmkI0tsbZOj8jHwMIiwQ8MWdY4
 ZjQf0UhW
 dioGR0Eo/A8X367zqPcmXyGGnsDB8trld8qiAh7pnERckHYkq0nBQDEFWDu+7ph1RDywfkjtlZW+jmNkHLNWMCzWMgyw86iK3pfx2KYVEBqZYTBUrFaOaszcBKkaD7yJ4GDuwOT+Dzui3siGWHfWVFQfznhMzZ8Ti0y6d5KjnQgZjeJwQkQi3/Jh35SYxKKn6Qx1/EjcH1d2A8qBhw5FEBei3pUQg41X1UOdhIGc0a6bGgqEN2NRvp2HFvjSCkKG5HPYWIDWG5tv1P2CJNpeN7lEIIIfPMpvji5adRntuBEy9CycOUbL4MuNkEcsk+N/3e7sv1Z4d+WDym+pTlYcUAYWb9rSAtXnWrvgXjA5fxCNs4HfDUc2jzKyBj9F71GRXyrN6skBp604UuVsnYJs2lcteEH0L3oxs+1oaZ3WNNHB+2RMrst+0h8xt3B9jFMnDT0S7UPKFWv82qARO5MbGiqnK4Pbb70i8Ge+f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This is a prep patch for shmem folio batching in the read path, where
non-uptodate folios need to be handled in the main iteration loop. A
large non-uptodate folio should be treated as a hole.

Currently, holes larger than PAGE_SIZE cannot be handled because
ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
wrapper to support copying larger zero ranges to the iterator.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..b08118fbd275 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3339,6 +3339,20 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
 	return copied;
 }
 
+static size_t copy_zero_to_iter(size_t bytes, struct iov_iter *i)
+{
+	struct folio *zero = largest_zero_folio();
+	unsigned long nr, ret, written = 0;
+
+	do {
+		nr = min(bytes - written, folio_size(zero));
+		ret = copy_folio_to_iter(zero, 0, nr, i);
+		written += ret;
+	} while (written < bytes && ret == nr);
+
+	return written;
+}
+
 static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -3433,7 +3447,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			 * clear_user() not so much, that it is noticeably
 			 * faster to copy the zero page instead of clearing.
 			 */
-			ret = copy_page_to_iter(ZERO_PAGE(0), offset, nr, to);
+			ret = copy_zero_to_iter(nr, to);
 		} else {
 			/*
 			 * But submitting the same page twice in a row to
-- 
2.43.0


