Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1853C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76ABB6B00A6; Wed,  5 Aug 2026 03:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BC76B00A9; Wed,  5 Aug 2026 03:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D6A6B00AA; Wed,  5 Aug 2026 03:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4BD6B00A6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:26:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4204A03F2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:26:43 +0000 (UTC)
X-FDA: 85066383486.11.4A8652B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 134421A0004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:26:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hRK9TGUD;
	spf=pass (imf19.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785914802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U3wrcV0k5ZLgN4YIkNlOZPK6c/r+xRI0oP9uZc18DtY=;
	b=j8kfR6csPSSnkJZBKY+xmh54+Gk6xzW6FspgydB/hr08HnF+pNDVnxsE84PICK6PQBDxOe
	o1q8fOWbEzIInBCT5DUTL/ZLIKozNXWIXPSU+kebwmN44AjsuEuhaJ8FLlFz+E/5T8N0Xj
	1E292IQqp/dlHzeL66EiGB2Y4JPbrPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785914802;
	b=Vmk5Jp7ziskMY9iCyHmEiKLkHquqXfkdIy8sSf3GaoPsZXeXyaUoAXd55WqtqDI9iX0nLq
	s8h3EJXLWd3UnYebP/T2TJa0vQp7Amzx5k06ki9PVof+UUVmq2rxm3BNFZdexSfNnG54OM
	eM6icjpJZGgdT9wRt4AJXWHY2lIHbaI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hRK9TGUD;
	spf=pass (imf19.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=U3
	wrcV0k5ZLgN4YIkNlOZPK6c/r+xRI0oP9uZc18DtY=; b=hRK9TGUDUFYwWSlNvX
	Vfq/LuomIQNXbdTld13rt4HjySi+PhGrWZZhMGar4j//Q40KeAmUT871oeQ/Pm8W
	MfNuEI/+cLJj0t4NIkSoqrUXC7n1S+A9B9WTr5hm6wdXNkp8wXT7vpG7x8sxIgSX
	Ih0JihXuclir3NxqN7G64zShc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3PzWi5XJqs4gTOA--.20967S2;
	Wed, 05 Aug 2026 15:26:27 +0800 (CST)
From: dayou5941@163.com
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/memory-failure: fix concurrent access issue in min_order_for_split()
Date: Wed,  5 Aug 2026 15:26:25 +0800
Message-Id: <20260805072625.2437636-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3PzWi5XJqs4gTOA--.20967S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr4fKrWfGF1fXF47GrWDtwb_yoW5CryxpF
	W7Kwn8XrZagwnF9w47Xw4DAF1Fk34kWa1UCF93CwsrA3Z8Aw1qkF47Ww4YyF4UGr48AFn7
	tFyDXF1093Z8tr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFzuAUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3gPYh2py5aPVGAAA3R
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 134421A0004
X-Rspam-User: 
X-Stat-Signature: friajymbjh3zyfb5y5nsie3hxzunt5rf
X-HE-Tag: 1785914800-473314
X-HE-Meta: U2FsdGVkX18divRomojwfVJd/wcIalq1R5JpjdkK8HkY3y61b8wuADC7VfIEcYZmIMi9wWy+vm5GGZckBAjDkccDH52hGk923tgd2wnRqiUKhl8zPs2FhKONz/dFUSk1O2jlqJoswExjL3gWcMjwR9OpR/hjF6HIKv8zPmJjzC6RXRajHXcjkOgI3NtopeOOyRl4kGpnm8vDJzBnRewafGBIIwlmEKy2+LEN42XcBshATSZ4iqy+jToaxUTv69DiF4PadkxQ6ixjUPNIvvNfwe1dKASW1h6Tx9EFsBi/H1HZn1D+1g1I2DJfKTAgAlJx5MZ6K3GUEOpvKX4Ri/H1ajIKK4Q/c6Ng+Z+9TQn/54pkHbmbW0XismmWC0Foi36P7hbbRFXcckhE1JDCAG1FBw1JnBAwUCYZAZ9P5ZxvInWuogMuD16rPtoEaJxtGzOqk+sAO7FtKAlLH6lPKIeDbaJXeq0jZWAzeSIj46ZgYoKSgqqOAP0bh5FTuPzc+ziq3y/o/pareDLQpuI2M/AGYUYqN/P/V70/qgpreKkWqwXlHrTcTvr2+ukmAUIibsS56TyN8YbGPE+QX2eB5EbdmaG+MKL5gR+qSHU7za66U0FADjzNmLqyjAfC1xmFrKY60NInkkuOl8L3D0DmZoPW3XFAEnva34LxxhddYpL4f5D3QV4RH4wIbXs8xuux0EfL6EVjDR0/01HGqBZp83aitBbnTT9bRfsxDlBKlifrZSXpxASlqD2YiBlskT5dIV/k0Z/I63pR8o3h43OeRQH1Cng2TehBOgua4NrTkPcVAZGk+RHzgvnSBAetotCY5pWGAx1SXXiIB8q6hwUwo30QYvHM25evAcA1j6Tvn6C/9gJ5lprKIOUi/FS0gpGv6BiH8ZBoOzZx7Wm1ehzXyUZLhwKPhbWCG6CNM/OLNFI4dOaVeUs90AGjPs8GWYFUOcgahpvdRJ4o63jlPlrO7mh
 B/8tFX7b
 ittDSh3koWGAWMCtPnCDMFWVy75al5nmEGRP2voQGqIbxhMd4RvUR/vPTlFTiuaqydlXkBqg/emGuaftGWkNSo6q1Awspywy1PJm3yFF2X8whiycXtbuRRRRjRkAm4d3Bryj+fRgZRjcQIBjyPuBkOQL3fXlBjR3+U5GvQPRjV7fmsSmpdrkmrUOUX1XmL8gAl2oTKwbzxfc9VLFAg09CtNI+Jyhbcg7cnKKYToeewqmP3oNCD39Z63PGx+piYWMxG3CgMhd77dqWPYif8PvYH2VCqpEOaNQ1S42XGFN9gOLEeupWQZp3Arj2LUS9LhJeFoETc31cHTat98Li04suJAPWW0XtrdSr4uNCkP0N8mPJfuHchJVrA5dPpD6S+4lLyO4MTbHVss1NnKTuilVb1VbpzFvzd0f8AWc1n0pWLUhh1LHcs9SBdc7KN9zvstra57J4GHBOkUPJWH6fWkrEenk07rX4v+Y7Zk5xm6LhyKeOqXumlE+RTLLRIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liyouhong <liyouhong@kylinos.cn>

min_order_for_split() accesses folio->mapping without proper
synchronization. While the compiler typically caches the value
in a register making a NULL deref unlikely in practice, the
real issue is that the callers in memory-failure.c do not hold
the folio lock at the time of the call:

- memory_failure() explicitly drops the folio lock before calling
  min_order_for_split().
- soft_offline_in_use_page() has not yet acquired the folio lock
  when calling min_order_for_split().

This means the value of folio->mapping may be modified by a
truncate or invalidate operation while min_order_for_split() is
executing, leading to a torn read or use of a stale mapping value.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
Cc: stable@vger.kernel.org
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
v2:
- Dropped the approach of caching folio->mapping inside min_order_for_split() in favor of adding the folio lock at the callers.
- Added VM_WARN_ON_ONCE_FOLIO() in min_order_for_split().
- Updated the commit message to clarify that the real issue is the callers not holding the folio lock, rather than a TOCTOU race.
v1: https://lore.kernel.org/all/20260804035828.2684059-1-dayou5941@163.com/

---
 mm/huge_memory.c    |  2 ++
 mm/memory-failure.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 58cabe6af33d..e3f16dadc1d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3b1e6946821b..7391524b5046 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2437,12 +2437,17 @@ int memory_failure(unsigned long pfn, int flags)
 		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
+
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
+		const int new_order;
 		int err;
 
+		folio_lock(folio);
+		new_order = min_order_for_split(folio);
+		folio_unlock(folio);
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2796,8 +2801,11 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
+		const int new_order;
 
+		folio_lock(folio);
+		new_order = min_order_for_split(folio);
+		folio_unlock(folio);
 		/*
 		 * If new_order (target split order) is not 0, do not split the
 		 * folio at all to retain the still accessible large folio.
-- 
2.25.1


