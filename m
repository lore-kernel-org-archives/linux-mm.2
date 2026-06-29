Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FFCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D6E6B008A; Mon, 29 Jun 2026 04:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4C06B0092; Mon, 29 Jun 2026 04:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333786B0093; Mon, 29 Jun 2026 04:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAF16B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:04:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B3B01A05F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:04:27 +0000 (UTC)
X-FDA: 84932212974.06.25CBF3C
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCB2F2000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:04:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Pkkz+KTL;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720265;
	b=PQTPf5qizRmrxU3M+8dQG3UCy6qww+4KoWcmo+txKLV+DlIAf3NWKnkl3y2jBYMVfE67Hc
	a36ifqLbCHw812EK7PtZtZhxie69H7LCh3NAls1IiCFZIdMneU8duq5b866uBNdnwwE+He
	kRC+n8VX5jZ0QWKM3xxKChAhXESVgtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=83iBgkm51rIv1+lt3fvIipGPuFGfW+56rCub8m7tfiU=;
	b=u6kyJqHCKVzBhWMEp1km2fjexw7jVHFnWv6Nvrlu2opYeiiqgsvPQ5f4cCtC7vGqFdKGft
	/mxkfGtTI89dPoGGXam7Kr5pvdB3O87xH5C/qxNXIMg0D3dpx07EJnCFqG8bPRV6EjyObA
	ZkQhyZB2h5VPZLEpyfioWczJHdAgLHI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Pkkz+KTL;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782720261; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=83iBgkm51rIv1+lt3fvIipGPuFGfW+56rCub8m7tfiU=;
	b=Pkkz+KTL9fW2xlCUdBxdQGK/T1zJZpOGg57guurE0443iJlApJ/1GFOp5bItDsQ/eJ0PbavD2YWAqZ35JBCHtiTJshgtiRefR+nPvg4vp32h+N1ZaxJ5P9UNW61AYj/dzhuRk61stJTOHN/51kAvEBbiGt5/wriLTEmWI6ixLBc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X5pEijK_1782720259;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5pEijK_1782720259 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 16:04:20 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN logic
Date: Mon, 29 Jun 2026 16:04:06 +0800
Message-ID: <def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCB2F2000B
X-Rspam-User: 
X-Stat-Signature: 8dy3sr933ortmpkyyz77qzh4exqazaqa
X-HE-Tag: 1782720264-775006
X-HE-Meta: U2FsdGVkX19wQvBWiRsYzRm84fY85S17od0quVbu1fcAYUOmEVqz2lUPwiLgNzoXN940GQMzoJVp3DpCl6tCReHc58Hd3Kl9ninqMgirrNAyjiDe4hHk46AqksRoRRZ7ushz9klHjuM6uZ8+re1E54WFIOlIW0v68w75WqaS86D3QYY+j9+3TprV0vhLFuUzHS2+fg52SEKyMnJtKiDUqodKzOJ6MQVgAaETbashbWw0q3MnicoB/4Q9iN5Dv1ukaLx+MDs3izbCORmcgK9N+SIMLDc/jDOCj5HwEBVZ8PEwuBOzrVD4GyXEs8XmGPqieB4+dPYVtR6PLgZMWSmsqk/x+JTa8hc4/OfGsE7OTHUyu6J5sPODyf1gCCnkVSXYpmVeXXk36b+TIkRTrvXT+AmmNqFNWG+E4lbNGkxCTgai59o3JzQ7xI13evQQHrMSY2nZni4AXsHG7wkFp9Q2n8wvy2yn0gEK7GPLkUMMNMEotN4XH/FuDir/p3YFHnQapqAWWLjJZd18Y9jBlVGT4QVlvORpc2bjcYmTYW8T4/y/Hc8qLfH1JpL9j1ZLfIVwyIquMEFJkEKZbSt6eoKsGJ4VYjXY4SYCJCJ0FzKc6lYXXr1idtj51K/pLTRnGZAZkWu5xThfNpRMs+0K3XQksYpJdzt8gSO8SOgUK3dRxGpfKAKom+ByprnLjVmP4GVSLvH5aN3U5t5EHlEKI/oeZo3SjAetMwBsVMLIJsbn0qWIu6WYvHseLSr/Vtksvr/WjIh9j9fDQY5VV6eN4tuW+YGPoWJWrMwOdo7P7+cwUbb+AyAK3p7keM8lntClbNTe6norZ9fLuQwhLGZ4DC97ptcIeVSWet51yvLg6JXLDKliBat2DDB9hDvZz4qfijib/2ld7sXe3iYEA35dz/gMHT7aEc8q6eqBqWP2PC0iF2P6CC32iiY8a0E7bK2Q/mtVcI1cPbIpbXvR0s5y4YJ
 OCgQ8AqP
 bK77a9adWLkqg2sYQvmkNPNGBjftUuQRlLm6iqbGO8CKlrj47q+4q7tTZCBCIWHpMAZjwSvKBGOK7uPX5NNQ1Y3QlOI8lXg4R3dt2+oY7yyz3kPCs4m5BwfFoWgl4wyztsbZsTNNsC4dIO9xuhazP4zL08PDLsXJ3f1dQD53AmZqL9SJLUlSPHTOtbJa44xHp6+21MhzeW6wHhKQTA2i0SWlSkgGaxxwhW3F5/Vm5hQ8mnMjPdr8ZZ3il/SyGnly0u9HWMpA2f9ssDIYaDeJJjnx2V0no7b8S7z/6lWCDx4vgwJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_check_references() will return FOLIOREF_RECLAIM_CLEAN for referenced
file folios, indicating that we can proceed to reclaim clean file folios
or keep them if they are dirty file folios. However, after commit 6b0dfabb3555
("fs: Remove aops->writepage"), we no longer attempt to write back filesystem
folios through reclaim. Instead, we always activate dirty file folios and wakeup
the flush workers to write them back. As a result, the FOLIOREF_RECLAIM_CLEAN
logic is now redundant: for dirty file folios, we will no longer reach the
'references == FOLIOREF_RECLAIM_CLEAN' branch in shrink_folio_list().

Additionally, lazyfree folios are also placed on the file LRU list, but if a
lazyfree folio becomes dirty, try_to_unmap() will fail and thus prevent reclaim
of the re-dirtied lazyfree folios.

Therefore, we can drop the FOLIOREF_RECLAIM_CLEAN-related logic.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 299b5d9e8836..2f7e5878faa5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -823,7 +823,6 @@ void folio_putback_lru(struct folio *folio)
 
 enum folio_references {
 	FOLIOREF_RECLAIM,
-	FOLIOREF_RECLAIM_CLEAN,
 	FOLIOREF_KEEP,
 	FOLIOREF_ACTIVATE,
 };
@@ -920,10 +919,6 @@ static enum folio_references folio_check_references(struct folio *folio,
 		return FOLIOREF_KEEP;
 	}
 
-	/* Reclaim if clean, defer dirty folios to writeback */
-	if (referenced_folio && folio_is_file_lru(folio))
-		return FOLIOREF_RECLAIM_CLEAN;
-
 	return FOLIOREF_RECLAIM;
 }
 
@@ -1235,7 +1230,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			stat->nr_ref_keep += nr_pages;
 			goto keep_locked;
 		case FOLIOREF_RECLAIM:
-		case FOLIOREF_RECLAIM_CLEAN:
 			; /* try to reclaim the folio below */
 		}
 
@@ -1381,8 +1375,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto activate_locked;
 			}
 
-			if (references == FOLIOREF_RECLAIM_CLEAN)
-				goto keep_locked;
 			if (!may_enter_fs(folio, sc->gfp_mask))
 				goto keep_locked;
 			if (!sc->may_writepage)
-- 
2.47.3


