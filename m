Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C7D606A334
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LmdpTGXU
Received: by kanga.kvack.org (Postfix)
	id 0A2F76B0637; Thu, 12 Nov 2026 21:01:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053DB6B0639; Thu, 12 Nov 2026 21:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3336B063B; Thu, 12 Nov 2026 21:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C85D96B0637
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:01:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 429BA82023
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:01:41 +0000 (UTC)
X-FDA: 85428444402.15.86DE4FE
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2AFA920006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:01:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmdpTGXU;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794535299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+XENL97JZ5WlH8CS4X3HjVZPICr7WyHaHAeuB5MXbDg=;
	b=1YQAHO6ced672KgBJyWIjmIoD8t3Qv6ukzQ8WN51YGDoeC3yaask3c2X6uFBZjeIfi3c/0
	Lt2Se7fdRL8xWU0+lEpHQR65vfGZ/1U4ongf3c/31KV1q3KlFluiQp2n30998Ok6m8EPwj
	363H6Fkmm8f/Uw3xLcvcRPezXtjUiVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794535299;
	b=4M++1jV7aIclMVv1D2DpuHNF3fhyxQApeDUo4Wj0ZnOEADHHTnH6LdpnkbmhCJpfQpPji8
	wE2+8HXgu+K1tvAQ0GEGw3vXt4nu9IH2ipnitu2w8Ke4YspE+SDCfGfDYt7wc5uEO71wth
	cdN084Dp+MhF8V0CtfRKxlimRY2pdnM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmdpTGXU;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R2j6tp93Fg7E7OEyVaIZBnzP1Orh5kRBAZflasE6mHU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794535297; v=1; x=1795140097;
 b=LmdpTGXULYSoS8ateoj12Yqnr8MFsE6nyU+iFJQAgrSXYujepC3HKsZ6hQWLsXGLG59ZTee7
 xbeaH2Wgyr0t1a/lx+MdPr6biHK39qzLPjOzZKUJibqyTyxIQ0wIvgTCrKEh1E8YBuI/diPMDbJ
 +QKUxTMd47hKufEH+r9bhFVM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c96d663c8789d4dd;
	Fri, 13 Nov 2026 02:01:37 +0000
X-Mizu-Trace-ID: c96d663c8789d4dd
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2] mm/mglru: yield the lru_lock earlier in fill/drain_evictable()
Date: Fri, 13 Nov 2026 10:01:32 +0800
Message-ID: <20261113020132.274013-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bw9kj3iboif7w6eun1marxhgi3os9jbb
X-Rspamd-Queue-Id: 2AFA920006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794535298-609605
X-HE-Meta: U2FsdGVkX18z/6wP07bpl21Rw7BweuIqpbGsNkhAy3q62MYN0D5hc5CLaQzpNlKiDaK7m5bM3JzWkXYci2dxw2gocCgmWrmfstnYSsVt/VNfultru9iPE3v659grUsg8bD3H2L2P5Ebd6a+a9eYJd2f8b63wfrh0LlHYZZnV6d17sBkS6bskKi3IcCpXoVYALi8+2R+7gYlLK+PB/ATzYKZ2l6iSSzKzTpMH0X6pVYiX2XNA4CsLHjRSy66Bhwm7EkHK45ZTlZCcCDvyanBF9CqRxbl5S1RqUFolLSBzaYoZtCJnL/l5rXbOWI66Ceu2sxOmPVhAgrCGURQJ5yIGEvEMLEjfDf35Eq08kYNQJkB1g0xU8KBQOJi8vjwXYvQJ9VNJd+iVRth96lo+g9gKHUOZFvBhidkrt7iEtIEH87ht8JEdDq19IcVSOwR81sDoKWmNX75fFSs15V7VLt1/dOUayquqEEUQdl8WKvnUVP94eLGKKJLjTUjU5OPf05F+hGJodSawP4dXtRo/7X39G7zYKeTmalrpfVhZqQnTON3JNI7WkJL/GqurcIf4e9IiSsQGva+NkWxrxqslyuJ+awUGsEZriPezrcQJPMTEdfVSCNDJ9AMV7f3aop5lxj8eXSbtej00oiJ0xhusDAatIozm9+5Vv0CPsMurgsuy+0pnk2EtZBBnkqaYW5xJIvnIYcz/QzijbdLc2ZkCdX7WwbS9gu1DmDYzpM7mWo4yb8jF0IaF4y07yRajzyz5m9b3McMWtQnOjT4TSg7xLFNsVTlqD0gJLmvjdbSp5FNJERgSHd/Rzim5CeuE2eykfLn3KP9Kmt1Cu1/CXOmTEvS7qg8V4wGRMajTaSmlcRGdrQ8ozR2Wsvqcvoz1peHd+/jzxfL/BtGeWzH5LaYDTZIWg5n9IKmWAsAm5wOz825zRqUXIKDPHHAwEj3bWtdspyPLPywOsb43Sv6tUFVSwKi
 9ij7GtEM
 6zR+dZZmO824wkVfyu5oA/jRlbJHsyNXSNibP19j+Prf2+sJf7UUYYSuncHVZjvTmGe1oRAfp7PIU8pUW9ynvrlq4E+WwPm9Elx4KOPPofI7a8BXJY9PPa+IDgF3u89i+I+lZRm5xhgx0ejF2x6GwrIceyp71vMDb8KCytFR4dVwto2Vg6UWPmrof9/2pq+nHAsCtcihN8G0s24QZEdSkXSlsG6mSsZ3UlhvHV5klKBqq4qRNy3BWTUlqjDZmZ0stH6+2AyFhmZ3DWmn0IuTP3Gry4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

lru_gen_change_state() migrates folios in batches of up to
MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
keeps local interrupts off for up to about a millisecond, and CPUs
contending for the same lru_lock spin with interrupts disabled for
that long.

The caller already reschedules between batches, but a batch itself
only ends after 4096 folios.  Stop it early when a resched is
pending, or when the lock has waiters and the current hold has moved
at least MIN_LRU_BATCH folios; the caller restarts where it left off.
TIF_NEED_RESCHED can still be set with interrupts off: a remote
resched_curr() sets it directly in the target's thread_info.  The
minimum batch avoids lock bouncing under sustained contention, while
a waiter now waits ~15us instead of ~1ms.

This follows lru_gen_look_around() in this file, security/keys/gc.c
and jbd2_log_do_checkpoint(), and commit 6e9be217a3ce ("mm/mglru:
use a smaller batch for reclaim").

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changlog:
v2:
Also yield on lock contention after a minimum batch (Kairui Song).

 mm/vmscan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..c1231925159f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5533,7 +5533,10 @@ static bool fill_evictable(struct lruvec *lruvec)
 			success = lru_gen_add_folio(lruvec, folio, !active);
 			VM_WARN_ON_ONCE(!success);
 
-			if (!--remaining)
+			/* stop early to shorten the irq-off section */
+			if (!--remaining || need_resched() ||
+			    (MAX_LRU_BATCH - remaining >= MIN_LRU_BATCH &&
+			     spin_is_contended(&lruvec->lru_lock)))
 				return false;
 		}
 	}
@@ -5562,7 +5565,10 @@ static bool drain_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE(!success);
 			lruvec_add_folio(lruvec, folio);
 
-			if (!--remaining)
+			/* stop early to shorten the irq-off section */
+			if (!--remaining || need_resched() ||
+			    (MAX_LRU_BATCH - remaining >= MIN_LRU_BATCH &&
+			     spin_is_contended(&lruvec->lru_lock)))
 				return false;
 		}
 	}
-- 
2.53.0


