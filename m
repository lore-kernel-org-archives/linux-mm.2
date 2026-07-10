Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00735C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806E66B0096; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A556B0099; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678486B0098; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A03A6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97D131A041A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:09 +0000 (UTC)
X-FDA: 84972726258.04.65BFE8D
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7692A000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=agE7ElG2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA0XWlOSFXwnV4uX+LVXg/mov5uKfo1EYc+r8AW5TT8=;
	b=5TqQrU4utWueU/ZZylhQMquaMp7SyxGc44bFbz0+j6BvT+pEq6zRKJA9RNy3xnk0opncIW
	uep6EXUTnqBDJIKqT8Rd/rPGpv4xp9bnLXzXQy0LifVjw0MixaMz8eqbQCgEq+8MEVmvPM
	927xD5+nIfXrY+xSAEQGZHmcWYtq1E8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=agE7ElG2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684867;
	b=8TWjn/4ha0/iGqIhmV1dP0wY+u/LGvcfWsdjxSssI2zl2AMZrQdVsKcOBw31Cj4HE8mEBn
	NxT15x2NNW2CXhwn5Y71dxdXvNdRPduhpndNzxhWRHjM7JQhOOWdaaT2IVHqE0IoyrTKlW
	MGX9UItIEMasOhHQLcZeeHUjL0hcgzc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cA0XWlOSFXwnV4uX+LVXg/mov5uKfo1EYc+r8AW5TT8=;
	b=agE7ElG29ZIS2AYW4dQ/D8ogYZSgo9EqWfNgVJv6FaPOcNugpVLhHBxVdFYieYZwYzyHAxI46
	DEicUtEoRXg9PBRhr6m9nDCADpkF2YUvwp/2HWo6rzdROlrNiPFTBUkOqscIgAoFAEGoIa7rLHJ
	0p61CsmktAhmW52IhLB4Jdg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gxVYG3VWkzLlTD;
	Fri, 10 Jul 2026 19:51:46 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CC7AC4048B;
	Fri, 10 Jul 2026 20:01:01 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:01:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 4/5] mm: mincore: improve mincore_hugetlb()
Date: Fri, 10 Jul 2026 20:00:50 +0800
Message-ID: <20260710120052.103886-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7692A000B
X-Stat-Signature: enqo81zojkop4n5q4t614qi4g4axaxwz
X-HE-Tag: 1783684866-641824
X-HE-Meta: U2FsdGVkX19Yi6H/sbd+PLHmYgK1yUa7MtByp2BWXxSpvuIkEAKF/9szqifWnToBaMviWI/Se9Hs9NC27jGHp1r0O9GkqCoSNLJ7BWih8SGl0KwSlgGfufqJgYmjFJg+2si7gQGsx5S9OGNi3CDEoAUxNzcQACSWW5Wgi9MgXQQDkuPPRSFMXj/J2P5gK1xTw/H5wjNRnFpgVqLMRXPFlJGNr787p6fF5p86V/6a02UslN9pi6v49xU2cl8Zz7t8Cbimswz9ji2KReJvCwJx1NuR47qu98q59HEA0jyTDSsdW6QNiDBZYsJCzmKaht3DNh4xcYrmx7oO+X0jtLvu1xeT/qxuT5X059Lh+RMYWL9tUUrutdNvyoKLCky4Qhb2hLRt7yJNHaSkuz0OP/vs1gk/4ebafJ3gFW2r8CDoe/uZ0+hOURS2vWavxBjUmEQWfIGNTsguV4kYFVjNBDG9m2OEdYa0y7w7c8qF9Ocri8QSKHAXNLa2kjVfG4mHVsITUGr0qIYtXCKwlPNwAKcp9i2CmApaXbBw80ZznpRREfc3VjZrmJqDjjNivo9vBbnU3IDkZrvBVjER23wqjEmVYPVKNrXyIlTSAG5DU0Q8MmGEE7der0VNv8uSxeZigzGhPZuiEsuNhyX9v5njM74ys/sbnYnaYSVyNHaHo1+yZ5m+ATTDLNbblV/3AdO/NDMsngUXGgxw+TDfOwTNc31e1B38xF44o2jYvq52/DpzfWfKnVROvIKaf8fmxf5Tsn5VzBss2qf3Hun49K7+B4zxhLAFSz4KLj+vNKhfcvDgn0NskW1JyE+TN9Oy3lJS5q2dbGnb95i6iWYT8oOuw1d2JwdmSw6W+7bY5PnJumpbJnvzbsuMik4eN0lA5erpvrtTVvaLHa0VBik2xdIwFRw6GJ9OUWkcVXLTNxftFeqUy1YkEkXu3h5Y7skoDJmz+TdQYnFgobOK9mYOFd1OJMr
 HGSDssDv
 PlJzt+NR0zEtszx4twf9By11bhWe5bQT51KZwrxXmQG+hkHnkCKCc9TqTkIoWEyTs5ppSF+MZd0lQI7DynDv45YG80hnNu7niwKi1zxHlxRA6yJH0xF72c5cOmuNQUg86I787Rtc0CGh/WnQC/sjjqaXipsTDIEjs8gIjK32oA7vpyLeMBJ9K3R/ADCkyv2F+VMunLD/L8JRsQ8lCDKiA2GAMh8S4hLdxeqj3h4WIlBP2w49OaXQjRLzENnkpd8iusNxgzw8yPjBmoy1XhTyJhVJqw5huMgW0r8YCsqQORP5xHyXywqFw5kA58zRNgfsfajs+LOP8rhVJfrQP7ljmwGef+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The walk_hugetlb_range() always passes a non-NULL pte, so remove the
dead NULL check. Replace the per-page iteration loop with memset()
for better performance.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 8b5e6afefb91..9952bc3edf76 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -28,30 +28,17 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned char present;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	unsigned char *vec = walk->private;
+	unsigned char present;
 	spinlock_t *ptl;
+	pte_t ptep;
 
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
-
-	/*
-	 * Hugepages under user process are always in RAM and never
-	 * swapped out, but theoretically it needs to be checked.
-	 */
-	if (!pte) {
-		present = 0;
-	} else {
-		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
-
-		if (huge_pte_none(ptep) || pte_is_marker(ptep))
-			present = 0;
-		else
-			present = 1;
-	}
-
-	for (; addr != end; vec++, addr += PAGE_SIZE)
-		*vec = present;
-	walk->private = vec;
+	ptep = huge_ptep_get(walk->mm, addr, pte);
+	present = !(huge_pte_none(ptep) || pte_is_marker(ptep));
+	memset(vec, present, nr);
+	walk->private += nr;
 	spin_unlock(ptl);
 #else
 	BUG();
-- 
2.55.0


