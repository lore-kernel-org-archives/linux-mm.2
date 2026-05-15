Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352A8CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92F36B0095; Fri, 15 May 2026 05:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B076B0096; Fri, 15 May 2026 05:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58446B0098; Fri, 15 May 2026 05:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD286B0096
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5069814069F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:04 +0000 (UTC)
X-FDA: 84769178088.06.710188D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id 85A0C4000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=i7WLzVYf;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOpXXq0yhxeFCV5hNBrcOoYY/AYcpwADf6/pjp5Lkp0=;
	b=J5CUDKYgthuXzMvr9IKgMQXg4P/ZFBluJrA8kyI2lnjj1MqhKoZtDDNWWbgEf0JKMg+pBU
	zG/qz9frIgVy1c7k3OlrZaffEzS3eb9v+7s2m0FjrWO4PCWsJkQRhjkW/2wDK2QaVxu8ck
	X23mAbDP6q0kR5lpVirJfz9/z+HCzVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838482; a=rsa-sha256;
	cv=none;
	b=gX9UCYxfmt17apvPWjy8l+jps5xvg2SP4z1i2De8YXSDpzy9MxzSVXcIhbeXlxLctHgq+F
	aI4lYJuAVr/HgQzJgN9nGSoSC1xAtuISt4zr1jBkHpePEQpZ6M7UsuSBVLSqgxOEdzoBVm
	g5Ae/3vfHeqpcEpEXIjiUX3JQ14aGus=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=i7WLzVYf;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JO
	pXXq0yhxeFCV5hNBrcOoYY/AYcpwADf6/pjp5Lkp0=; b=i7WLzVYf0vV3XZUCeZ
	42Slhj+3H1wPtoGcQ/A6IS+HzEFrQ9IpkqShlJrKTuWvXb7yXAaOG6j2ZYMOaX2J
	gXKq8/i1lXOS1O/Gyjht2+wpKFRqQ7f0sl13POg1E9Ptlh/MaUvjHexZHGepQD5h
	0nRvFAA8nhDeYkFhq1rRALm3Q=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnVxek6wZq6RobBg--.38248S6;
	Fri, 15 May 2026 17:47:19 +0800 (CST)
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
Subject: [RFC PATCH 4/4] mm/shmem: make SGP_NOALLOC succeed on hole like SGP_READ
Date: Fri, 15 May 2026 17:47:02 +0800
Message-ID: <20260515094702.1092355-5-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260515094702.1092355-1-chizhiling@163.com>
References: <20260515094702.1092355-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnVxek6wZq6RobBg--.38248S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFW5Xr1rAry5Kr1UCr1xZrb_yoW5ZF1Dpr
	97Gr97GrZ5W348Cr1Duws7Zr1UXan3KryUK34agw1vyF98AFy0kr1UAw1j9F18JrW7Ca1F
	qw4jkws8uF4UXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxkucUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wdA3WoG66dn5QAA3P
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 85A0C4000D
X-Stat-Signature: i3335hq3ia8u6zmoojeox7951xgwf5sq
X-Rspam-User: 
X-HE-Tag: 1778838481-113758
X-HE-Meta: U2FsdGVkX19GXjtbppiV/pwJ688WqAx88eFWqAkfNtYsHsJRGXFVHhktHtqSRrhpCm9fvLiUjUHOSeRR1XTEMD4F2t0rEF9OcDDKNBOQWDgPByRvQ2GRxZQlRXa6e8TzTo1050nGeQTjZr4a/+beotlzYf1M1+u78cJubM0Extrug5NqtOrLgJapM1Auv/jDsSyQiLLMf/KffXBPpTtF0kL6hR2Qwt0FQV7xkge2vlkS7CoDkswgh17aol4tPb8z183DgFiEPJq6OwHQ3g+OWhsnRyp9SjHv5SOF1xdyIgsvbSy0Uxyo0F++0/4vKOTspD5ekoSQxDbZMmxQl1Z51VgRzHQtiiRr6NUmbebBpSu5OSBWSwT3AX1WSxEOUH7L9koawH7ZM0wK2X7cqeYXLsFAf0tV7pchIh2tkyweTYNUPumFbliBFcTrpjF2rDZo9b2Yb/NGn2tNWebbv6nY9JGQaaVEnUoRhLZwZ8VFYyBdo7VEgVQH7oOZi4NWS8dWHkUtH0bVK48/NZIqcGT2sRSLh+pv3RaMKOJg2CMmYO0of6BaxmOXyx3sCdclzIKcKz4PjWsnCUiRsDHw+4hmlXdjN12UwzRFxp9pRHLVmarmuCr2EhcS27AEvFTMgzGg+4zTSHbAs1+iWLDEL4g0GqhcR0tovJTroPE1FQc+lVe3pmcUDCuLHR+GnKNjyz72JvkKQRE2Wmtzxj/WEkIiaAL8fvG8cBsUdEc4wShbBKVd4i4Um62dAo+6JsJ8fvPZBr653hYiQJs5dR+91FhfvX7c2mzwWKeHi52KAmjARDMcY24PulUUN2HdfjO0tKSBZYUHGZtJSojp1he9dvpHgpYfBoNdNk8Zmc+iuojRbOsbu4GTO87Q3uDDpaVRrKQ3AebEp4pQvUzTOvlJ41KCdq3NeQ9SA6zNrME2xZlk+BQkS/r5GSkBA+tv+r+g7CU5WQ+PeD3h1j9yOgCzw3e
 2eJjb/Qo
 3QtwtCuXf65kxVIpdcXBzMvGfP1qxpWVZKvmPMGnkp2av+QI0YeAvdKA+pAAa33SgTd550x2lyyCUfDCtztNDzeaMlsOZ6YtS4+Dsee9c3eB8tzRbVc3WpKWXa7kNHIY0W4JkeqEBKJKKNVSw1G+yPoZ/jn9vpvg6Ui6lwEmykOqfOvW9DOj1CK8Vnv+hiJZR6+VOeMK2YwwWku8+o724zUrpvrZXR3MOTrFR0SfdY+dDPdOiH2T/P0XE0icCHaO8vc4wpQuPVv2+Kdc2eWKoS0cV5nLaTNOXHAKAjCc7L6QCd/yZypyRmYb4mGdYvddTpqTvMAAMjXDXnftjqiHQfGEYG95UYNRDiKWHwXN1ih7fZMufkXDnd4WzzDbaB88i9o7397BCN12hubFMb8owe69SMIoXU8hOkQYz2ugXfEZ8h23RGFBC9KecXfAn0mjCOq8+nVuq6Wtb7mIWTDGXkvAFAseW3QK/qw4D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Change SGP_NOALLOC to return 0 with NULL folio on hole, matching
SGP_READ/SGP_GET behavior. This simplifies the sgp_type handling by
unifying hole semantics across these three types.

Previously, SGP_NOALLOC returned -ENOENT on hole, while SGP_READ/SGP_GET
returned 0. This inconsistency required special handling in callers like
khugepaged and userfaultfd.

After this change:
- khugepaged: behavior unchanged (checks both error and NULL folio)
- userfaultfd: behavior unchanged (both -ENOENT and NULL are converted
  to -EFAULT before returning to userspace)

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 include/linux/shmem_fs.h | 2 +-
 mm/khugepaged.c          | 2 +-
 mm/shmem.c               | 9 +++------
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 24698faea5a4..6f7f8b9e2a10 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -166,7 +166,7 @@ extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 enum sgp_type {
 	SGP_GET,	/* don't exceed i_size, don't allocate page, don't lock */
 	SGP_READ,	/* don't exceed i_size, don't allocate page, lock folio */
-	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
+	SGP_NOALLOC,	/* like SGP_READ, but accept fallocated page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..3309d1c094df 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1950,7 +1950,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index, 0,
-						&folio, SGP_NOALLOC)) {
+						&folio, SGP_NOALLOC) || !folio) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
diff --git a/mm/shmem.c b/mm/shmem.c
index 4bc4e463ca97..41f5e251f7ed 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2531,14 +2531,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	}
 
 	/*
-	 * SGP_READ/SGP_GET: succeed on hole, with NULL folio, letting caller zero.
-	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
+	 * SGP_READ/SGP_GET/SGP_NOALLOC: succeed on hole, with NULL folio.
 	 */
 	*foliop = NULL;
-	if (sgp == SGP_READ || sgp == SGP_GET)
+	if (sgp <= SGP_NOALLOC)
 		return 0;
-	if (sgp == SGP_NOALLOC)
-		return -ENOENT;
 
 	/*
 	 * Fast cache lookup and swap lookup did not find it: allocate.
@@ -2666,7 +2663,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  * When no folio is found, the behavior depends on @sgp:
  *  - for SGP_GET, *@foliop is %NULL and 0 is returned
  *  - for SGP_READ, *@foliop is %NULL and 0 is returned
- *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
+ *  - for SGP_NOALLOC, *@foliop is %NULL and 0 is returned
  *  - for all other flags a new folio is allocated, inserted into the
  *    page cache and returned locked in @foliop.
  *
-- 
2.43.0


