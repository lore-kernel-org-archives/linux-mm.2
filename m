Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17118CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7276B0096; Wed, 20 May 2026 06:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E946B0098; Wed, 20 May 2026 06:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBCD6B0099; Wed, 20 May 2026 06:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0E96B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CA918859D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:21 +0000 (UTC)
X-FDA: 84787400922.15.A2933C2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id 894E8A0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AuLw0WFb;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=th5U1L5vmkhODOQbkCC1ck4kSZkOj2dVnpqhVaNU8Qs=;
	b=H5XD/RfvVzXyTh7RBpnIMfznJn1sxXmmeUfkV8dss0mYMLIW8zxA4IFlQ77nEJ2svMp8JI
	g+Knv6COs3Y5T3D3CHjFgZS9EiDtp473M6g0mALxvt3NGSj42R/g/V5xmL4pvNy1QH3s3J
	dLUH9qhJiDm97Sc5+M7NpDc/faVvhl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272359; a=rsa-sha256;
	cv=none;
	b=8ehzopwHcfnovBKO0wznfJyoUYuEzn581inzkyR8Metws+BWLGH9PUHIg/mjEFUIShNA8T
	DigHuTdAfCdlpFbVMcf0HpgYkIlZiK0q3A8u4sYrG0JEzwEOUcJmvOiQyiki9+jeLhf43Y
	gVq+HEF/cbX6utZhlW6KH933OuRl+Lg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AuLw0WFb;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=th
	5U1L5vmkhODOQbkCC1ck4kSZkOj2dVnpqhVaNU8Qs=; b=AuLw0WFbsvQEJCokO1
	Yp3PrR43mnNKiQroLSUV6P0BDgy0E1XKXhERkECG0XxbAuXsuiH8pwsyEVyDP/ub
	xKkUmmJRSPbRJl6EWXabBLOkqpdR4LEhpERQ0p3TbmRrawwbo8AH+6Zv8lUOivZZ
	qt2H6lhmk3kJ4Ha6m2pWwH10k=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S6;
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
Subject: [PATCH v1 4/5] mm/shmem: introduce copy_zero_to_iter() for large zeroing
Date: Wed, 20 May 2026 18:15:37 +0800
Message-ID: <20260520101538.58745-5-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4kZr13Kw18Kry8CryxuFg_yoW8WFyxpF
	y3G3Z8Ar4kJayfWr4fXF4rur1Fvr93J3yUGFWxGF4YvFn0qr98KFyrKFyYkFWfAryUCw1I
	qa10yryYka10yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1-erUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xKcOmoNinIMnAAA3M
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 894E8A0009
X-Rspam-User: 
X-Stat-Signature: 35tnye4mfkzh6chgukxg515tqhbdh8ax
X-HE-Tag: 1779272358-81294
X-HE-Meta: U2FsdGVkX18UxlyIyt4xS9JUh3Q36BpUXcIBYjSJcYgVhAM6Qtple8wRNpuRMNY+BCBPyifgs+GV8tAKn03dsc+aflWnd7HhEwO6h23zO1eTljovVhy8BVCtcYJFxvg6jsOOoFghLqkkX0ofdUhBCdFt6c7pX1KhTWzLnAirYSOIlYwMCzC88H5PGoh3/QEWdgZc1f+PbNCiLFgscWhbIrlpTmN4Jcb1FQUk72uv+mQdFot2eFlufhBD/zozNtbHEMjxGnzk6pqit1k1xocqDo/NwxQ5v4kuthzsYrG0+eEmpUvXUJkDfJ5+hzSCfpdmB3m7TviEjgKlh9m3syrDCJFen6PSC4pEYneldwtQ5rfyvS6bqfR65NyHMw40fumfI+4vQsS9TMkUmg6jjvdRD2APzj+8e1WlMmplikynguvPdI2oRqejoLql32MIzyNMYl1uNiszCSr3T0cCKFtP/4jHU80BUOh/w5aY2PM/eOJfNZkAW7iWVJlN4B0jFCF9NFB/HK1RD0AYkLdvGUmRP1Bhb5SJ6LryZWekOvrpk7yd1en3f/UXsF+HyDZ3FOqHPrjCvoX+s1ZsOyKqoVqVdoYk1F4WcIsFFuF2fW9XyGt1INX8XvErNp2Xf0BA/ZIjxarwcflMgW/F3YSgQPBIDQaO2E2sS05JZFMmVjkXo+2rkLMOdpU1ZbX65bW+3OQib74eFiqsPIMaUb3gjW3BTWk0PVW6TGKlVw6NIXYj1qJWPPBfSbLMWtnxXM/D1sUCBL8dvvRBA2OmMUDAf4TrMf5xMi6egMtVMVjmQG3R5xhFXcfuPpXoaXOmyIK78oJhCp3n6Wm/wlqs9AthZ0v56gi4OdeGTtA8QsLHTq6K2c605qZRJpX3hXPHRQE/Rd0/+3at6wWz1CoyRLtgoZR5MP+RceLc0r3j33P2l5w01Anrbltgzwb0plYzHJunJXFT93SaofPCIgr6rAJ+9lu
 7C8Y1+8Y
 5mX0K49jfpCrxACyva5PLSYqexuIoRKvz5ogS4vmSFLvyETTmIIpEUYYf/TEbD2dq6kSC8QPqT90/rV0abSpgw4feAvCh8GDk7uQUZFNdEerMV1uY1B9BovlInUjPTdIwbVC+Zb/LyKQedopxpUGZXrYkKz3igYP7crAEJ1CSig0KaBsapgAj3qcupRMbwPKWw6QqT9xwXHvci9pe/T3Zbo/wAo3y2YOSNK/eRtvRUub76HNkyBOT5zvtfg/pmamxTwQ0aiutgZ0Y0UOiVmSmcIN8vKFvvrTSA1cm0VFbJL6rR7JJhJxe+rFU/KoNYBp66AROdxmBUB+58wpkIpLnDqGlKFfB7F7C3ENasWM9C2+P+EK9lE91vqk5pj/BOdnfUFo75f0WbdR4NnM=
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
index 458853c506ea..96ea5a4c0aff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3336,6 +3336,20 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
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
@@ -3430,7 +3444,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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


