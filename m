Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA917CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7FA6B0088; Fri, 15 May 2026 05:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFB26B008C; Fri, 15 May 2026 05:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58586B0092; Fri, 15 May 2026 05:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B51426B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 858531C1B90
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:02 +0000 (UTC)
X-FDA: 84769178004.04.3A0FCA6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id EADB2180008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:47:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DwCEea2W;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCAvDF399KUDDlsRRvXTB3FeBcx5LWuoyIvPW26D+rA=;
	b=WPf3eQtVfZNfca57wXl+P5G6lNazHSqla8Nd8lQ11W43apyhs103DFBeAuVagWSB1LrxEm
	kweIxFCEYxo+iKdlIMx+Z10uJamvM5OyWVyncHGUr5sz1/Uo19tsPDwIkTWsLbYCGgUyJp
	PGuf/utFQ3ARNFJD3nHQHb7XUHGfk9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838480; a=rsa-sha256;
	cv=none;
	b=y2mbQWRoZiFMdUrrUGWq+kiwryoHsHDAeSWts+Riqn+jYg6CieYxl00yn9M78un+VrAdUw
	0WmzoMPvi0hUAA4Q5yzaeA8Xfy1d5MLqYmVbS0S8si7WOjK8RQR+kxR6U9zK8L22sLhi5H
	ttAFGH3OiOHbRIyr+D31zXguLZDaStk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DwCEea2W;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=tC
	AvDF399KUDDlsRRvXTB3FeBcx5LWuoyIvPW26D+rA=; b=DwCEea2WZ5HljjrfYt
	aGWsT72c229yIttmDYQTd8hcCUk6JCkTUwyQCNSthHZ3ruWWeMjSsaQHdgMR6H6D
	c7EFbBte8s+hMpUkFY3B5OAuZ0k34xHsU3kDiMV6zdA/uDgcI+FGhlVam+x+xYu/
	dru0TT5Bt8Y8n11L6pN01Uphw=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnVxek6wZq6RobBg--.38248S4;
	Fri, 15 May 2026 17:47:18 +0800 (CST)
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
Subject: [RFC PATCH 2/4] mm/shmem: use SGP_GET in read operations
Date: Fri, 15 May 2026 17:47:00 +0800
Message-ID: <20260515094702.1092355-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515094702.1092355-1-chizhiling@163.com>
References: <20260515094702.1092355-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnVxek6wZq6RobBg--.38248S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFWDKr1UJFyrCw13tF13urg_yoW8KFykpr
	W5Kwn7Xrs5J3yUuryfJayrZ34Ykas7XrWUta9xGw1fJFn5JFykKr47t348WFy3ArW7Aw1S
	g3WUGa1jv3Wjyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOcTQUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+AZA3WoG66ZsIQAA3P
X-Rspam-User: 
X-Rspamd-Queue-Id: EADB2180008
X-Rspamd-Server: rspam04
X-Stat-Signature: smny1opexozc5z7ai8cmxnyf1qpxmpzn
X-HE-Tag: 1778838479-201032
X-HE-Meta: U2FsdGVkX18fhZNFHbpe6UsPo7ujHdfUCKwU70xeyUZMV/tZXQkcYhkSO306vQ6F8OwUNFK41BCK+0XZMmUNAWffGFnyTLHgcYLhMOpMCu9r6pqxPUEJcz/pEb1XnlhroVN0OpP9mqQx4WKKWO1YL87QugN7V3EAdXFXSp/ZhMb0Iku40926G9RMz0V5W8hU+pwLe6gFk9ehUceNvapH3AGWQW65hYuIc8sxnbECFECidK07ga6t7FDkGI/qhtJClctpnH4gWP7qKhud5nZgoMk+Acr8BXmm/LcLAxFKMsXLlgb+NpxtXfyfqRkj8KtTsH6/GqnRlenUPP2bebkUZs3j9+8TaFaY6+vdBcrDy+Q0nP5+toD3GX7jQmSVHncuB6LXFLxehFV2les+HPN6GDJmPsIbQ2hkIMIldRTUcN+u+ctCHKIgHBbK5wO7zOK7/efvrmSxp4wQ6Kw6Zd05IsZSWPUeGSJProEXuYS2AhrlhVRpf/4iTbLLn8cGn9wt3wTU1phHYQCl+wJ52w6/kooM8Ucn9w9cAGnHB9cA8Pk3eP9eu7zBTRok7O1X4APwLEATVtlTREI4mRSzoUp7YigeF7fYtlWsvU2Lmyj5l5FUOcYCviSABJZPY0/x+nHtliSMrsyd/+S0y5gKxCb9WGaO7JIf42JD3vHn8OCUJJsV4yx86h6wmnZh0y8sjEa/8O2hb7xwP1AIH/Yq8wOzCfyzyw+o/VHH0yMxpnKnkyviLSP9694O6DT69zE+IQQQbB6BT9E23jwLSxLFhNTQcpOEYQiMbni0LEZXq9g8xmYDqdBqR1wVXi+wPRWvJ+d+WtWhMv6/G+wdwyoqsqrHS1pWsbBeEMECgOG6LEG7Qaf85Bey74ZiSacDRpEixcQ4ISeXPXWC+KwcCZFzQ7IbWw787JAhoi1TyeTLjDbsYYBsh5Jz4rXhbu7eQB/bdo92F8RsphZHfhRh4WMUyTt
 3IcBkvSI
 cAlcFZTQs7kcs7387d8Lst1PeKTUf01QAgsB09NVETT64KK4Qa8pi/LWJUVMaQ8IgbggKc/E6rGvjRP0kPKGKFhyQZyCtNid5YuPQj8v3rEfkJ0gxsNwk0bwtEnMpHQRF2Ta3ALPCcHX6StN6V5ODN861WjMGpBHegwVLRjQq2KuOPhiPYzQUp3s3wuM+osy0jv1M2Ax0svhVU3J4mutTaV5OvsHH1gqgl3le2ZdsgYkwEkG/YS1eyEb6cDBO33P8016vuzap0OUDHlvtS6Ryf8QvOYIVG6GWaj/NoUzji4SbkQqWVmCZ5tJLnDdGT9mqEi1JmUJFLVs9oAo/PSSXsH/CIym083w3PzBySWdsAsD4yTc6ASZV+A7uCjXw8QOtXt5dYHctHht2zAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Replace SGP_READ with SGP_GET in shmem_file_read_iter(),
shmem_file_splice_read(), and shmem_get_link(). These functions
immediately unlock the folio after getting it, making the lock
acquisition redundant.

Even though folio_lock can protect folio data consistency or prevent
truncate while holding the lock, these can still happen after unlock.
Since these functions continue reading data after unlocking, the lock
does not provide effective protection. The folio reference count is
what actually prevents reclamation during access, making the lock
unnecessary.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/shmem.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ef19968cc51c..767610f78d0d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3370,15 +3370,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			break;
 
 		index = iocb->ki_pos >> PAGE_SHIFT;
-		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+		error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
 		}
 		if (folio) {
-			folio_unlock(folio);
-
 			page = folio_file_page(folio, index);
 			if (PageHWPoison(page)) {
 				folio_put(folio);
@@ -3561,15 +3559,13 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 			break;
 
 		index = *ppos >> PAGE_SHIFT;
-		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+		error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
 		}
 		if (folio) {
-			folio_unlock(folio);
-
 			page = folio_file_page(folio, index);
 			if (PageHWPoison(page)) {
 				error = -EIO;
@@ -4170,17 +4166,15 @@ static const char *shmem_get_link(struct dentry *dentry, struct inode *inode,
 			return ERR_PTR(-ECHILD);
 		}
 	} else {
-		error = shmem_get_folio(inode, 0, 0, &folio, SGP_READ);
+		error = shmem_get_folio(inode, 0, 0, &folio, SGP_GET);
 		if (error)
 			return ERR_PTR(error);
 		if (!folio)
 			return ERR_PTR(-ECHILD);
 		if (PageHWPoison(folio_page(folio, 0))) {
-			folio_unlock(folio);
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
 		}
-		folio_unlock(folio);
 	}
 	set_delayed_call(done, shmem_put_link, folio);
 	return folio_address(folio);
-- 
2.43.0


