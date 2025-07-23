Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C134C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8046B009A; Wed, 23 Jul 2025 06:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D580F6B009D; Wed, 23 Jul 2025 06:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DD76B009E; Wed, 23 Jul 2025 06:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B17A86B009A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:19:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6002313389C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:33 +0000 (UTC)
X-FDA: 83695132626.25.3A83D1C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71636A0009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I3IAC7VJ;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxRTtoCdCaL68C/uZpXKvMr8wgXODWBtugFbqWI2Ch4=;
	b=0yAshsbgqVAF8/BJhidy/Le/kbYG0IRLI2rVxNPj7NBKzFnXwN0gQ9ZuIxjUTljPU03Iqr
	0HJenp++puNzOS7qASSEE0BKEmfOwX5qjokBr9/ZCFYorFWkKJ1gfQLApDPpEA/DbciQ38
	QohFwwQwA0kblgVXP8BEGxZ0mrp8Rog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265971; a=rsa-sha256;
	cv=none;
	b=7w3jpqiyzGycAcwzprHZZCGhkmNi2WUC0XJjulJMzETgg0Aws7PbjK2DvrteVD/gB88fuh
	IIQSCLvCbroc8BOop737R1DDBBzmUhjV4pppkIeBqXRuVCNkMiKUc/kekNYndzO1b3yVq4
	JwkinZjNsqLDeEDpttJrUgDjHBwZFX4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I3IAC7VJ;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Gx
	RTtoCdCaL68C/uZpXKvMr8wgXODWBtugFbqWI2Ch4=; b=I3IAC7VJteG4IFIgIK
	BbY2o2VburamF74x7I3g/AUUKauYeZRSgA1ITpIJKT/1jkDJwa7u6b76QjzPe808
	pgWZeBgeNKHLEH9W+8MPhKxSbN8iB4tItvW4DUuOCqGhXqP27j+1JUikTAf/nxUf
	bxW1lmxCaXuOpbk74m3hKLYg4=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXpNEAt4BoaJF8HA--.11729S5;
	Wed, 23 Jul 2025 18:18:41 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: akpm@linux-foundation.org,
	willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 3/3] mm/filemap: Skip non-uptodate folio when folios are available
Date: Wed, 23 Jul 2025 18:18:25 +0800
Message-ID: <20250723101825.607184-4-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250723101825.607184-1-chizhiling@163.com>
References: <20250723101825.607184-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXpNEAt4BoaJF8HA--.11729S5
X-Coremail-Antispam: 1Uf129KBjvJXoWrtF4xtrWUXF15CryUZFyxZrb_yoW8Jr4Upr
	WrKa4kKFZ7XFy5JFs7J3Z7XF1fWa97Aay5CF9xKa4UZFn8XF9IgF1ftFyUGa18JFWrKF4I
	qw1vyFyUXFWUXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jdUUUUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgAWTnWiAsAucXwAAsb
X-Rspamd-Queue-Id: 71636A0009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: x6qu1zs1664oufja6ftenp3jc14h8hrs
X-HE-Tag: 1753265970-136306
X-HE-Meta: U2FsdGVkX18DYVplgRQR21NWJiotzS1G1o4zYvMnU/lkX60BccLeVr9hx/kB/VsaxpgdKTHc70UOIJb92K3gX1cCMxUN9Y5Ifl3DoZsIMJUjQ0R3KEXBdPmR+4FMdbbgzt39/45PxsQ1Cu8hShYfJdg3tPIpQiQoVVBfuq4vbAtoBfAurPKQe/YBnNK0maYlcEEJ3oehq2sYmtX8t8SEy+3mPJwDT3tr83vsNd6x4P7podxs3OEtKOpuSpoPpzYQfIyMarttJIkUmjj7cJrBNnGTxG8qpXTykmE8QvsRUqjt7jFsqsiPbejspIAZhwmSNfD0w5qa27BdoCHvfG9EapVYZVYzB4CXDgHBDeiHPtbMJBw3ii4e1e7lY+kV65RI4qHzG5OI3PCgrbz53F2fELBSRpEuUtfr6Y3iepb7vF3avxQopQFZOwu/3dImHWxIvnuuIRrbpvDwWxYN+nMg1XntUmNYIhmps7qBXhFWGgBZvFtJAeeUNZFA2/RVhIK/KG4RuoXsA9S+h9YFdGdB81uYZpm9njQAkken4vGSDdD9I3nKJndYIVPFCN18MoN/jghbuGOGx7TmcJLUc7pJJKhzPd7EnE50tuW5vOvV1M3/xCnSMdOQlSrfbZ65OCmWYUMVHYyumEzayf6NdhHiL/GwphzPZGotKPiXHs/Wfc3zXXm5E6kf4g4FpXMbeTed7hb3s+Fa4Oc0YErWd7xFfLb6m5OzDh1Pdn6IBStkDpkYtU5o6RIlmAf1e5Bv7NwCGDOGUS3Qj5cpFnCKTP8QycnsAg8blH/J5nvrrcUsmRm8vtJYsJu97NQQeUGoLAW9XU+MQUPhufz8FmfEaLkO9UvQ0qqvx+n+m1d/SwM9rJ50zDkCQxmZ4mFc6ZroCsBfW8CncD03gGv9fpx3ajzcjjAhzY4Xbh7IlrcEd8fQpX4oFDesUjXXql76kJPsQ4nc6Wl6W6jM5UzuDG9F6pJ
 uM1Pps7L
 6aDyFKXFsQQ6hN3qEu3QQNjUBLPaCra7gCVnE/y/WCaJ6xpEr6woIuSgleJ/K7GtnzJdJzoLtwTO4g02Ci1+MXMaFHW9lq+C5QWZSk53f39gk+/FiPYEI9BSaomgXl67gFtDHTeyOQyGoZLrbr9MDVBRolrnok7xkwxGSpluWc8gSt+fnJ6f+GlCxef7bj6JeAlgGWRiLKDZymMyDa8ZzgjVvBhuGbk/HHdXWUMLWuIcrA5UpOe7/dp16D6hddG1ocW9xpd3jADZuLzjoyeRUeIkKWs4ddixibju2em0PEynRkTkva7qLJG+WSbmi9vxoVEoZ3lF8MMIcVLy6nMadWyUj7m0GKODgsiuANsSKPcl+HtkfHBl79r4O+cceO93rWUZvzaLBjZ30mZ2mw9YnJ7d1790GlJ27C7vnu+uPrrW0aps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This optimization primarily targets read operations that trigger multiple
IOs, aiming to complete the copy from cache to user buffer as quickly as
possible after the final IO completes.

This patch achieves the goal by minimizing the number of folios left for
the final copy loop.

In filemap_get_pages(), when encountering a non-uptodate folio while the
fbatch already contains folios, we skip waiting for the non-uptodate folio
and proceed to copy the available folios.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 350080f579ef..894584a5bff5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2625,13 +2625,9 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 			goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
-		bool no_wait = false;
-
-		if ((iocb->ki_flags & IOCB_WAITQ) &&
-		    folio_batch_count(fbatch) > 1)
-			no_wait = true;
 		err = filemap_update_page(iocb, mapping, count, folio,
-					  need_uptodate, no_wait);
+					  need_uptodate,
+					  folio_batch_count(fbatch) > 1);
 		if (err)
 			goto err;
 	}
-- 
2.43.0


