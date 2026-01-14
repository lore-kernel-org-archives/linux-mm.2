Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC688D31A02
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 03:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303216B0089; Tue, 13 Jan 2026 22:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0F76B008C; Tue, 13 Jan 2026 22:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B10F6B0092; Tue, 13 Jan 2026 22:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A57B6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:24:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B1831AD721
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:24:36 +0000 (UTC)
X-FDA: 84329126952.02.C385711
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7017B80007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:24:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768361074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=lLc/hwfTg2aUotxaFMe4VP6VThBSxzsG6ZHvTkBJzmY=;
	b=fkOqJxcYpYnz6vC+aei9t5y/TKqXnrftFzjY5nBZg4VtlAwQyXWhoDsAzkNKUW/iG+9nSJ
	7J2/T7p8njNFDPrtC+eDTKXsm2gvWEEvMgiqv02Y9cHt7go10LbQbLyHNtHjmoDpYo6zl8
	Sw5UxeS4zxu9Sn6HpC1ED79ek+rkn/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768361074; a=rsa-sha256;
	cv=none;
	b=nHcpQkAUFn6CgyhZIqcEw8hyVq0JzUePJjVEUlTjrp8iC864A8Aillm2M4mnREDE7taGAj
	fJTPjypMGTvBH6ufWw/GlTqQUsFbIh4ipmMHJdhLhZVRgBApgfxWoMi+OVBbTL9Hhmsb3Y
	tdIrQe5p0SEZz9RVjhurEA+YPrrBsDM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4drWgc3QpTz6Fy6F;
	Wed, 14 Jan 2026 11:24:28 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 60E3OG20017867;
	Wed, 14 Jan 2026 11:24:16 +0800 (+08)
	(envelope-from wang.yaxin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 14 Jan 2026 11:24:17 +0800 (CST)
X-Zmail-TransId: 2afb69670c61485-b4fe3
X-Mailer: Zmail v1.0
Message-ID: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
Date: Wed, 14 Jan 2026 11:24:17 +0800 (CST)
Mime-Version: 1.0
From: <wang.yaxin@zte.com.cn>
To: <akpm@linux-foundation.org>, <liam.howlett@oracle.com>,
        <lorenzo.stoakes@oracle.com>, <david@kernel.org>
Cc: <vbabka@suse.cz>, <jannh@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <wang.yaxin@zte.com.cn>,
        <fan.yu9@zte.com.cn>, <he.peilin@zte.com.cn>, <tu.qiang35@zte.com.cn>,
        <qiu.yutan@zte.com.cn>, <jiang.kun2@zte.com.cn>,
        <lu.zhongjun@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG1tL21hZHZpc2U6IHByZWZlciBWTUEgbG9jayBmb3IgTUFEVl9SRU1PVkU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 60E3OG20017867
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yaxin@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 14 Jan 2026 11:24:29 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69670C6C.001/4drWgc3QpTz6Fy6F
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7017B80007
X-Rspam-User: 
X-Stat-Signature: yyhybomosupxrjfd4gpgxzbmbif1u8eq
X-HE-Tag: 1768361073-171371
X-HE-Meta: U2FsdGVkX1/CU93/Kxje6Bjtzi2SmymAO9vTsta1RT0Daop+FDgh1XCoSNmDUmS2iKVLLUzz+QUY5HwloGnSCxI5SPpGjFRd8dcYAmvpN81+tUjZvPo7MJ9/e3bfRsoQXMeXgo4rO5EGCEsHMGBnrr9LX7hE6puDSUO9Cw/t1R3nHtQaG1txP7LjtHINaPh/dw1kUZdC/Y7d90cTN5oubJMZ9g0rpo5AtCJBDumesf3mSZue+OrswuRpRzi3L1aJvuM2Je9MmyPKxNr2vV8EX3y4/6HaerYv5QA2OWnDiVgTykqWJeLuWJvn8VmvncEoelr8sO70w50l2RkXwGHTFGzMQWWoFP4fLlhuXGQrgMBLoFcix47uiNHZsuc8OVCSNBqfqutIG1wE8EHmMCDaXAEDuaXqV4hHDbPuuGltqnPiP//vE53mU0601I3g+PeV4Q7o8j7MrpSBVwC5yh2OlJ6G2XZMVmWqtuAD87eNgwcCkCKBsTyqheG3/n9FMubcUyqbnaP9LYcL60AW2azy5sxQKujmLunl+YnPc0CrLuTeavw+KVK+7l1yMOUDjUfVhNjBAeHmr1JwI7kzKeZR2+MQH1/7BxbGUkmO0ZGQkqBdImPZ3KzX+NB6qliA9aMlnW8EH7RC0ZPuuUgQsuMS40agdnk/JQ9GrCwD1HKRQCLiivhiRXKLI3427xgWMRlqlyG+psCzYre+/HWcq5KBLtLJ/h19Kx0QqSZlv9StCAXKZwZMMYkTVTOO4VkXqrsFMWO51s3EGnc+wfghhJM7I71+idFkkfKaTO5cNV8WJIE7CBikZKPlhQOx2dIqTRfXUIALVM7cAofrM/zKrC3BgSQk/iJ0sPCzSQJq4vZrQvqIYxwIiYkdsOxqNqFH8qxmD63s2opQ+4WLapHEDgm8dwCR6j8KmqeBHlTqfDcTSSWTGN4T11eZTl8HIsy5QUMQrMFzmXJLpAukx66pUJh
 IX89Pr77
 UZSEtCsnHUgqnWGk/8LeYJ7qqR6gXuCKbl0kW9skQ76pkDWKAoSClnEJDmJY+wOjyqW7rXIuWFXkk3ReZHLLjJpGKT0pPDYC1CaUN1teXZ76kymxWH/DGOtuF7CVnbj6tG2/tHOulXfmaIlxEgjnl3vVx9yiNblENmHmxWoGbcLi12gQ4pnurNwReSrA594UymcJsd8Sj9VptEZU2U64uTJ6nYH+/NvOUd/48iD1amBLZkbx7hK9FUa9hz8zEhj32AmBTUxdup/Pmswk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiang Kun <jiang.kun2@zte.com.cn>

MADV_REMOVE currently runs under the process-wide mmap_read_lock() and
temporarily drops and reacquires it around filesystem hole-punching.
For single-VMA, local-mm, non-UFFD-armed ranges we can safely operate
under the finer-grained per-VMA read lock to reduce contention and lock
hold time, while preserving semantics.

This patch:
- Switches MADV_REMOVE to prefer MADVISE_VMA_READ_LOCK via get_lock_mode().
- Adds a branch in madvise_remove():
  * Under VMA lock: avoid mark_mmap_lock_dropped() and mmap lock churn;
    take a file reference and call vfs_fallocate() directly.
  * Under mmap read lock fallback: preserve existing behavior including
    userfaultfd_remove() coordination and temporary mmap_read_unlock/lock
    around vfs_fallocate().

Constraints and fallback:
- try_vma_read_lock() enforces single VMA, local mm, and userfaultfd
  not armed (userfaultfd_armed(vma) == false). If any condition fails,
  we fall back to mmap_read_lock(mm) and use the original path.
- Semantics are unchanged: permission checks, VM_LOCKED rejection,
  shared-may-write requirement, error propagation all remain as before.

Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>
---
 mm/madvise.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6bf7009fa5ce..279ec5169879 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1015,7 +1015,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	unsigned long start = madv_behavior->range.start;
 	unsigned long end = madv_behavior->range.end;

-	mark_mmap_lock_dropped(madv_behavior);
+	/*
+	 * Prefer VMA read lock path: when operating under VMA lock, we avoid
+	 * dropping/reacquiring the mmap lock and directly perform the filesystem
+	 * operation while the VMA is read-locked. We still take and drop a file
+	 * reference to protect against concurrent file changes.
+	 *
+	 * When operating under mmap read lock (fallback), preserve existing
+	 * behaviour: mark lock dropped, coordinate with userfaultfd_remove(),
+	 * temporarily drop mmap_read_lock around vfs_fallocate(), and then
+	 * reacquire it.
+	 */
+	if (madv_behavior->lock_mode == MADVISE_MMAP_READ_LOCK)
+		mark_mmap_lock_dropped(madv_behavior);

 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
@@ -1033,12 +1045,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);

 	/*
-	 * Filesystem's fallocate may need to take i_rwsem.  We need to
-	 * explicitly grab a reference because the vma (and hence the
-	 * vma's reference to the file) can go away as soon as we drop
-	 * mmap_lock.
+	 * Execute filesystem punch-hole under appropriate locking.
+	 * - VMA lock path: no mmap lock held; call vfs_fallocate() directly.
+	 * - mmap lock path: follow existing protocol including UFFD coordination
+	 *   and temporary mmap_read_unlock/lock around the filesystem call.
 	 */
 	get_file(f);
+	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
+		error = vfs_fallocate(f,
+					FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+					offset, end - start);
+		fput(f);
+		return error;
+	}
 	if (userfaultfd_remove(vma, start, end)) {
 		/* mmap_lock was not released by userfaultfd_remove() */
 		mmap_read_unlock(mm);
@@ -1754,7 +1773,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 		return MADVISE_NO_LOCK;

 	switch (madv_behavior->behavior) {
-	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
@@ -1762,6 +1780,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
 		return MADVISE_MMAP_READ_LOCK;
+	case MADV_REMOVE:
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
-- 
2.43.5

