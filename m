Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7511C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456006B008A; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406A46B008C; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343826B0092; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 249F26B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C390F12C7E5
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:19 +0000 (UTC)
X-FDA: 83713026558.25.062754C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E7DF180007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=avRDumut;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692018; a=rsa-sha256;
	cv=none;
	b=07ZqN+NkbYDGuRzA4GtGULjAiyADlj4p2ETyDM/qL1GbUEfx6noQ6vWYJaeKXb6FHqMIO8
	LOS+coAHDzx4R9Ykfmf1UbEHh9PlWcm5R5nV/FhNY8WmLXCITR8T++IZxyrxmG4/rLHAV6
	G6s2SucAfxvOIbiRzhMYQb5qMvJMX5g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=avRDumut;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/UKDMw0joXHfqIOWrWMvMtfuY+C4akEWZAyWYlG4oc=;
	b=CC1qbCLGsA3/KTnfiF5uRV+dgNJIgbU0mtUHNqjza8nk6rHuMgYEAtUeVHSZTkyBp7KXYe
	6YOZX1b4K0FKSgPYN8P5O5q3us9PSSVvVN7LLlI6faymSuLeJqWWV2HN0fJvzZM8q9rmfd
	Ep3/UaMi3j8cZoqiarR6hchaBAaHWkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=f/
	UKDMw0joXHfqIOWrWMvMtfuY+C4akEWZAyWYlG4oc=; b=avRDumutFFV7+/xhP7
	lAv3mT4OTjWtezxFpYrmQJGArckPgmn+iy4Mo49wDJSbVrMnCuOlmccX3dK+vb/L
	gYXpNEcfZLPuCGqHKuaiEedsDpCdn1dhaNCcuAONs4UxYY9lDxhIPBjCGRn8tcy1
	5f3Yf8UaP+pM5zRjqclK2AwCw=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAH9a9hN4doAzUWCQ--.8415S3;
	Mon, 28 Jul 2025 16:40:03 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: willy@infradead.org,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 1/2] mm/filemap: Do not use is_partially_uptodate for entire folio
Date: Mon, 28 Jul 2025 16:39:51 +0800
Message-ID: <20250728083952.75518-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250728083952.75518-1-chizhiling@163.com>
References: <20250728083952.75518-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAH9a9hN4doAzUWCQ--.8415S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4xXw1DGFyUtFy8GFWruFg_yoWftFg_Wr
	W8Zw4kGa9xCF9xAr4IvF4DJr90qw1v9rWFvFZ0qF43A345A34kZFWqvF92gr47Jr4FkFs8
	JwsFgr15Zr13ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8EtC7UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFBSUnWiBj9Y5uAACs6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E7DF180007
X-Stat-Signature: 3ex8ibtnpqmea9gtjcszxus61tw8em6o
X-HE-Tag: 1753692015-759193
X-HE-Meta: U2FsdGVkX1+9GVPOKMIP0a9ELcWNfpj7aaSdwPIFTbWtEcPO21EszBohLjceZTUQRH0FXTy8Bv/Yms598Tt6GwG9W/ZCg4UCvccjj9pinNCzaTHol1a61ULdN5KsQBQWO/TSDroKRxdSzY7OCzDliqWbsdGJ7Eol2Ho0lF9w+TsYE9ygjQzSN2qO4e9nD4dkWS27eX717yeWQZHR9H1sE5KPLbIpp660pF6bq/D3C9ITbIieFXYhYGfs0bUEASvY7oXk/uEAsxVjMt4XxCiU5a7BQXO4W3kB1z8hgsjp7STzPHLJUgPulijGrMa6ZcDWrVYfFzg48Qxyw40bXbNTIwKAAoZ0Y1kS4ehkKWDbnPUUd5xtDvyzRz7/oTe5QOjI5b9fvocNW07nz4Dzsc6fysoQUPZ6ie4LcXa2fgJyTNKpDEF1WYEB/tkdgcLYxBdip4K3l1H4UmhrqYHcjMqG3y43TYXBL+100mYt4GI+PxeVfEQdQ9VTMklxNLOtcRbXfh1NClWgKsyJtf5rBXfVGvovjBQuUorbL8Sgw2vPAzsqL4gSMMsHp896tiLQBGMO1zcLZmwq7PdICvDkUYdMO0ujYQSTuIuFKTWdB0pn6AjHuAoCXRw2ukTZ7D0AlnIVdkzNEu9eAD23KhUDh/6DcsglAKszNcNaQ00dEe985yWawo9cYpWj3rljX1XQCjDRjNx03xkZezomrGvgbwzi/j785Gl8L1WS/pima7EYtfnecZ1p2mnbrEjEGU8DakngcTfJFhDmTuR2aloZ6v66XwL5lmNCnUjowpbEu7pmOjIhRzEnUcg0C7c/bAYJYG5mvtUR3y2lkfTRdcGVYrjfohtqrcJnMEWkZMPybMp4V/3bgeX6XEgWZyYhZbGxU2g49KYYXfA6dMQJMlDEcIXVXeC/aVpK4DKGM874Ds8qnDPANOjCwYgP89JdBiDG/uUqj0zpvfhZ4ZcC5C83yX5
 BJp7CSVs
 DjA1v0jxTm0GjbqmYYxmHmnIf03E+UjJU5gARwMmXBPI/EQkwqC/Dau/9FIh6++jrYpz6Dih0buY6VOQ8CQrMNmXkRr1k7swo9wNFmY2GR5jYzTH3rqlklk+ujALlufr5d/M9I6qnMWKkSpGlNQtsuBpVzizGp8Pci4022cOMtgmpiSmobdvqcCUd0b2/0MQdH/FL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000078, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

When a folio is marked as non-uptodate, it means the folio contains
some non-uptodate data. Therefore, calling is_partially_uptodate()
to recheck the entire folio is redundant.

If all data in a folio is actually up-to-date but the folio lacks the
uptodate flag, it will still be treated as non-uptodate in many other
places. Thus, there should be no special case handling for filemap.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0e103fc99a8e..00c30f7f7dc3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2447,6 +2447,9 @@ static bool filemap_range_uptodate(struct address_space *mapping,
 		pos -= folio_pos(folio);
 	}
 
+	if (pos == 0 && count >= folio_size(folio))
+		return false;
+
 	return mapping->a_ops->is_partially_uptodate(folio, pos, count);
 }
 
-- 
2.43.0


