Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE955E99052
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DCE6B0005; Fri, 10 Apr 2026 04:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EE56B008A; Fri, 10 Apr 2026 04:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C986B008C; Fri, 10 Apr 2026 04:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9A846B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:03:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9689DC19F7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:03:06 +0000 (UTC)
X-FDA: 84641905572.13.CBE538F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FF031C0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:03:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jiang.kun2@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=jiang.kun2@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775808184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=i4hfQBUq+NP13pm7RDDqIV/eYyYxcif9UaXbfhK+a3g=;
	b=60z4MOixVzjlYtfZ7FdqZnz5rpxAkC1ld1cU67tP3sDWnVmm2IeBarkU9ZfgJL7otmonWl
	StTH1rSl+0Xh6d9oA1nxPmyzdQr00u+vZzF5MBhD/6qC+VJT+FYcEM3/Jhf3Qy08CgN6VH
	DenKm8nJXeVqP1bQkxjAk0ECt3Ai+C0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775808184; a=rsa-sha256;
	cv=none;
	b=dgjhJxSx/TubBdJY6oH6de5julXMB5qZ0jrt3+cEFPHM57lmMx7yrLmFb/4voRM1PrUrGd
	x4BkN2fAwn0QUMikwYF4AX5kQttuvUgbkBbLQ7dnjXiinJ4fXiZ26g7qHSk5p9hxLVDfBh
	C89s0BSyMMo7SkK6KI4beZPCfP9uvZk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jiang.kun2@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=jiang.kun2@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4fsTnD5hwJz4xPSP;
	Fri, 10 Apr 2026 16:02:56 +0800 (CST)
Received: from njb2app05.zte.com.cn ([10.55.22.121])
	by mse-fl2.zte.com.cn with SMTP id 63A82LUU084046;
	Fri, 10 Apr 2026 16:02:47 +0800 (+08)
	(envelope-from jiang.kun2@zte.com.cn)
Received: from mapi (njb2app06[null])
	by mapi (Zmail) with MAPI id mid204;
	Fri, 10 Apr 2026 16:02:49 +0800 (CST)
X-Zmail-TransId: 2afe69d8aea9b13-cb0e8
X-Mailer: Zmail v1.0
Message-ID: <20260410160249749i98jwNgNLmLMKRNVeoKVe@zte.com.cn>
Date: Fri, 10 Apr 2026 16:02:49 +0800 (CST)
Mime-Version: 1.0
From: <jiang.kun2@zte.com.cn>
To: <akpm@linux-foundation.org>, <liam.howlett@oracle.com>, <ljs@kernel.org>,
        <david@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <xu.xin16@zte.com.cn>, <wang.yaxin@zte.com.cn>,
        <jiang.kun2@zte.com.cn>, <lu.zhongjun@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9tYWR2aXNlOiBwcmVmZXIgVk1BIGxvY2sgZm9yIE1BRFZfUkVNT1ZF?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 63A82LUU084046
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: jiang.kun2@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 10 Apr 2026 16:02:56 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D8AEB0.000/4fsTnD5hwJz4xPSP
X-Rspamd-Queue-Id: 6FF031C0005
X-Stat-Signature: b615k1pw86hiob459sytggp9c17afrum
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775808183-996030
X-HE-Meta: U2FsdGVkX1+BLtfe++GY8qx/2EUbqzCyhz9WA+7JCWFtvm8v3+GhNK3bPeRhUgJ8kHirby0X7OoAHxfYXH25R80NpedfNo0nf3nEdYYd0eoXdcAToSX0JxYeTOgJ3N8fXYCcqugexAfww+bpBmdBBx3h23TrqhMILmMCFzWlnv0tjR3YqwtVvl8UxxRdgOf1Uf1NvA120qzVEpeo6cQzsUt0XaA/hSu5K1amutdd+x0kpuY2SpJropifh5kzIuXV1O3JaxJ4b1UsviJqGkuF6T1KSzpKT4ayJKtx8iMk7lzeqWZz12X9Ac3OvazzWuLCxNgBppK/8XGdsCBNabAW3LkcwtfQzTCQzqCM6bFRr5BCeBUcPFJM9y15sx0q1416TaHRvlPaI13g70Ra//WKWnJNw3MFnqy0RL2fW5zKiRWgm3REXvaJYXXlkqd81cqlFu7Ap6lLOU7m+T6WIUSfymDeuAVTI5oP+hc5zzLPN0+Voymr53ofseXRTUM/PB2g8KMIusVoJzYvOzVKF57TnCJ6Kv7l1WL/kG9AVPlyeWYwASI+oaNyaIVfk6J5NksF105kmjB6M1tVdSXTG37Y7mTC1rpsQd/Skcyn2/mLh/Ufb49paamiCIrqZW4a3fuoYls6dlrsowE9FV5qPpVtze43nMfHHCdIZ9byjwZa8ezjAgAOGixVXZX9qJRyruRTWNzEeCMvtNHursP1HWD0N0BiO1UymiRISr4AFdmawDEGXVmuQ6xyNSTp7dYyRpVMgF1X8Pm/ZT10qwhnjc65+K4Ow98ufuLihbV6gIl16VvxLBjLa7/vYhqyLsr6oFaBIpLvc+QId+0wmMqwLBdQK0WYiNqM2mlz4wKvf/V+bdVBqMJmA/ioRiYe/Mz51QHcIVev0GG5uikFtvqC5RCOxBw++2XbqraP/PS6VSSjwCkRb4czvRqEU+0IbfIkEmecR4E25lZESBd6Zd/RDfc
 7Lzu8sX2
 /mqcgsGk4N8WsXLch7FSUyQhizgXBrcS7HXPUhJDEE/EtSoWZ8zVDLfPzJSXGiPg4dbXKxrr4bv8kpD4yvWUJ3bHU0HBbnD8Nxc2yRe/JRLqV4hO2Q0jP1n96OTmgWg5N/geqnGn6z69Hv9O85jjqyA2hiZ3G6CGzNsQY/c9oWe2aO12YE2AWiJJR61kIn2vzN1rWq+EXZjCVvGQFCKIvMg5jqVsoEXSRpgJds1w9Yh1mENDo/ylNYZPOhlWE5r5DkQceWIf3m9ilu1n51Sy4dOSFKHolisiKjtYqA7kjV+n0PR95dZA06NgiVBxELX1e0o7SXsJAAOJdNz/XYwqaCJg9JidpZKDCjgjEGE+lnF316rH91e0U3XftRppa4BAduFY+WGMhlS+4DZTi/mW/0la0CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiang Kun <jiang.kun2@zte.com.cn>

MADV_REMOVE prefers the per-VMA read lock for single-VMA, local-mm,
non-UFFD-armed ranges, avoiding mmap_lock contention for such ranges.

However, calling into the filesystem while holding vm_lock (VMA lock) can
create lock ordering issues. syzbot reported a possible deadlock in
blkdev_fallocate() when vfs_fallocate() is called under vm_lock.

Fix this by dropping the VMA lock before invoking vfs_fallocate(), after
taking an extra reference to the file. Keep the existing mmap_lock fallback
path and its userfaultfd coordination unchanged.

Repeated benchmark runs show no regression in the uncontended case, and show
benefit once mmap_lock contention is introduced.

Link: https://ci.syzbot.org/series/30acb9df-ca55-4cbf-81ed-89b84da8edc1
Link: https://lore.kernel.org/all/aWcZCwz__qwwKbxw@casper.infradead.org/
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>
---
 mm/madvise.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..0932579bccb4 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1008,8 +1008,6 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	unsigned long start = madv_behavior->range.start;
 	unsigned long end = madv_behavior->range.end;

-	mark_mmap_lock_dropped(madv_behavior);
-
 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;

@@ -1025,6 +1023,20 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);

+	/* Avoid calling into the filesystem while holding a VMA lock. */
+	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
+		get_file(f);
+		vma_end_read(vma);
+		madv_behavior->vma = NULL;
+		error = vfs_fallocate(f,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				offset, end - start);
+		fput(f);
+		return error;
+	}
+
+	mark_mmap_lock_dropped(madv_behavior);
+
 	/*
 	 * Filesystem's fallocate may need to take i_rwsem.  We need to
 	 * explicitly grab a reference because the vma (and hence the
@@ -1677,7 +1689,8 @@ int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK &&
 	    try_vma_read_lock(madv_behavior)) {
 		error = madvise_vma_behavior(madv_behavior);
-		vma_end_read(madv_behavior->vma);
+		if (madv_behavior->vma)
+			vma_end_read(madv_behavior->vma);
 		return error;
 	}

@@ -1746,7 +1759,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 		return MADVISE_NO_LOCK;

 	switch (madv_behavior->behavior) {
-	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
@@ -1754,6 +1766,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
 		return MADVISE_MMAP_READ_LOCK;
+	case MADV_REMOVE:
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
-- 
2.53.0

