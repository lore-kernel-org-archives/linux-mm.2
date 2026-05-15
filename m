Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969AACD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFB76B008C; Fri, 15 May 2026 05:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7746B0092; Fri, 15 May 2026 05:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B961E6B0093; Fri, 15 May 2026 05:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08076B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8177FC2AE9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:02 +0000 (UTC)
X-FDA: 84769178004.05.BB97A27
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id F26D340005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:47:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hcz3fYBk;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlESWM+x9CBZx/ibVibR9kzkEAIwGUCZhksgluuowXA=;
	b=5diY9BJVgCZ1eZ512JRlADm6ADScFm80V2dOmN8svZvIxkKhuTqjjlKBKhhfRJ/0fkJfL7
	/002q0eYmPSJiDtqzXqEvVuhvg/izVMODMsEZrjpjwO3qph1DVS4eqvRsNVxwovakMhIBP
	aw8bnsVO+3p8Zn8kQni1fvVfaVrV08g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hcz3fYBk;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838480; a=rsa-sha256;
	cv=none;
	b=bRtKn09Y8+8nKQIhOyFFuEaao1PY0gd3iB9RhsCl0Uqynqblu/qFINXDM2d95EeZ4O7h0J
	3nimoJH+e6KC84lzSGmS7nDwygxf3s70nobp1IYeL9TULv5Z30dZmJm5qVl7czhONw3jfB
	juXOP12x2CPmTeQuGzfbYyXfnd1kJyA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Al
	ESWM+x9CBZx/ibVibR9kzkEAIwGUCZhksgluuowXA=; b=hcz3fYBkFNRAnwc4mg
	6gbOq6nbAGobeo+RnyqgkioZ97HqWpMaXTrbZfUwYyQkEDrnI79hKk8BBisRqeIN
	k7R5EQc2GsuWTgspXYc2hwjwyyDo+Szb9HVzyGPQXmMbh5g46+YM3OIG6Qbmn1Xo
	Zgm9G7t0vBKZAXszc/2z+3kXA=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnVxek6wZq6RobBg--.38248S3;
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
Subject: [RFC PATCH 1/4] mm/shmem: add SGP_GET to get unlocked folio
Date: Fri, 15 May 2026 17:46:59 +0800
Message-ID: <20260515094702.1092355-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515094702.1092355-1-chizhiling@163.com>
References: <20260515094702.1092355-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnVxek6wZq6RobBg--.38248S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4DtF1ktw1kXrWxWFWkXrb_yoW5ZFWUpr
	ZrKF97trZ5K34xCwn7Zw48Zw1ru3s3KryUK34agr1IyFn8X3Wvkr10yr1UKF18trW3G3WF
	qw4UCa15uF1DZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jIYLkUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3AZA3WoG66bf3wAA3m
X-Stat-Signature: argpfcjqhp6k5b7p8rarebeiieckhbz6
X-Rspamd-Queue-Id: F26D340005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778838479-332600
X-HE-Meta: U2FsdGVkX1/LKHzgUaX3pb6GsV52k+F1+iptjLkU/6wQNcRmIP4lHVoh+9LrZlvK1WdegG3miav+nIGzrREUKLul/WMGy9He33Pdu9qJJYN7lQxQcBEsfExWx332eGS9l5BMPr9oCIaUXrVcnyfACo1RQbzb5+3xAnWIDmM2Ocu6ftAIQllF62FMcW+FSWeKefJVs4ktzcR2iA4Xq2/d+AiqELoqy3zIxXryrdr33j7ellDIr9XtK3LFG9GV23k2tnttgdph3x8NUrn4UAqYc+ZWF51JNJxc76dWcFkmM3vZD0s5M9OG9gDveQ1Opv/xspX1QRkqlmRupQHT1PWON0Oe5FnIdpoU3TBAD4/yyaPWEdSJCrsf3M5VaGxqFHHVtq0ezuOPtBIBxjRIYyPgDmdCBem3XCVRRQUxSUQVk5e4vTydR2zIuy58gnxtYP/Wh6Ys6+6wiKysDayuHv9oxST439bUB11PMijm3xMyllA9MyfeqCrqlaORkXl97YpX1DJ76/ESCzWl1+Vi+B345F5bQkqG1CA/ISPmPjtqfmm8hP4EoF5yaxEq8gAQeMPJ2I87Q8ZqOaOa3zuV8/7NZMck+oPAV86vwXAvB5CGnmpW9g6T5AhTnnGvmvuIFnGmqhjYNr7wCOw4hJPhGNdq4tMqf6ShMQhngjRZ/yt9yayQ9LNc9kRJ8EuNAmRZzqCqZhv57DMQbfPErwTkIPGZOCp+kD8xkNHtbEvYuPB41NPpxtMl47gFpJjt0ZgGEcmEM7j/AOxlAOhLAtRVjXEaDxWaeGpitxGPpIB7LLsYb2FJwf8vYGrpLqBLPu/DTHrmLny2KrkAcPNgtIDfY7XdkeV7K1NoKe9ZR+7MIniRPWjpzgEDZMyYaXgKdDnxoFtvvbHMr5HBgUcu1Z1bcHwMYjf+lvh0ZU2VSsKcSxOdN8vNSKSBJJGkwBEUyd7QmlPO664PonGdK5LjQIPwuFv
 Pq8U9hiV
 kgt3oEOH6w22VPmO2llZ/ii6oQLTzfOBn29YE86+gB0OUpl7iVVW6ebGEBI2lLfKLu8gfW/iOqQUV+KPhIcZOTRdD3GQfvnl3ONNyjk8ETYhxuIf5LkXdq6EGd9J1C3LODRsVsmMyyslB1rpkj7PBR7tP3s+qiFdHOfGega/5/+3nSavHDEVlx/mtmlu234U2MtApX1agPQWK6RpSlfnPCwm13g0hDVahTEE278kBoL7AmiQaki2tTqSh0O8ZZ/1TlOE0D/Hw344OMFAygMOFsbWJ6tXxCryqyeS+Yd/86mKZtfpZ+Nyi8BEfIL20xE1jLtv5HLN9u9L/4oZZcQ1ebAMHv8zKyR7z9YY8vYUySVjAKIyddTiA2TFQKN6nCl4IrmU69+pjbTsZ6SQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Add a new sgp_type SGP_GET which is similar to SGP_READ but returns
the folio unlocked with an increased refcount. This eliminates the
lock/unlock overhead for read-only operations.

SGP_GET skips folio lock and mapping check, suitable only for
short-lived access. Caller must not rely on folio->mapping validity
as it can become invalid due to concurrent truncate. Safety relies
on refcount and uptodate flag (truncate doesn't clear content).

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 include/linux/shmem_fs.h |  3 ++-
 mm/shmem.c               | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe..24698faea5a4 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -164,7 +164,8 @@ extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 
 /* Flag allocation requirements to shmem_get_folio */
 enum sgp_type {
-	SGP_READ,	/* don't exceed i_size, don't allocate page */
+	SGP_GET,	/* don't exceed i_size, don't allocate page, don't lock */
+	SGP_READ,	/* don't exceed i_size, don't allocate page, lock folio */
 	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..ef19968cc51c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2504,6 +2504,13 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	if (folio) {
+		if (sgp == SGP_GET) {
+			if (!folio_test_uptodate(folio)) {
+				folio_put(folio);
+				folio = NULL;
+			}
+			goto out;
+		}
 		folio_lock(folio);
 
 		/* Has the folio been truncated or swapped out? */
@@ -2524,11 +2531,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	/*
-	 * SGP_READ: succeed on hole, with NULL folio, letting caller zero.
+	 * SGP_READ/SGP_GET: succeed on hole, with NULL folio, letting caller zero.
 	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
 	 */
 	*foliop = NULL;
-	if (sgp == SGP_READ)
+	if (sgp == SGP_READ || sgp == SGP_GET)
 		return 0;
 	if (sgp == SGP_NOALLOC)
 		return -ENOENT;
@@ -2649,13 +2656,15 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  * @sgp:	SGP_* flags to control behavior
  *
  * Looks up the page cache entry at @inode & @index.  If a folio is
- * present, it is returned locked with an increased refcount.
+ * present, it is returned locked with an increased refcount, except
+ * for SGP_GET which returns the folio unlocked with an increased refcount.
  *
  * If the caller modifies data in the folio, it must call folio_mark_dirty()
  * before unlocking the folio to ensure that the folio is not reclaimed.
  * There is no need to reserve space before calling folio_mark_dirty().
  *
  * When no folio is found, the behavior depends on @sgp:
+ *  - for SGP_GET, *@foliop is %NULL and 0 is returned
  *  - for SGP_READ, *@foliop is %NULL and 0 is returned
  *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
  *  - for all other flags a new folio is allocated, inserted into the
-- 
2.43.0


