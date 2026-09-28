Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D94C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC906B008C; Mon, 28 Sep 2026 06:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D296B0092; Mon, 28 Sep 2026 06:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6FB6B0093; Mon, 28 Sep 2026 06:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8ED6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:58:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7DF1140197
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:30 +0000 (UTC)
X-FDA: 85262872380.07.9A61543
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5AF07A000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="KPkv/fqc";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW80Ao4GSnyo3++EWYs+N/9yYhqs951UWTJTytHYXHI=;
	b=zgrQdxRlmYG7ZLINdC63VBil239C3of7NOiKnxJfLAp04f1SYiWliDd9iw7ysnLQ71Ht/5
	hKtRo4cfb0driB5nT9ZzQvgfIJ4feZ5tx6ATOC7xMlu7ZJFbuPAmZtp3+L8XAVvGqREEKH
	NnmaoAPE3Jxs/ARrKTujbFP0Vu63yMQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="KPkv/fqc";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593109;
	b=MUFPy6rqWMxC9cuWWIA3Ta/3ESQudWNQL3bWimHhiWH2ruocA7DM4MxUbod+V1xR3qMTul
	2BPBFh6yC9SPB87dB6tcKZKXB/Xzruy7AFxYRSHQjyWchE5Rwle6ZyWJzc/g9iHXnUbJsi
	DXlVVul3AGEQ0ixjENRRuGr7K6g1gr0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790593103; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=EW80Ao4GSnyo3++EWYs+N/9yYhqs951UWTJTytHYXHI=;
	b=KPkv/fqclzYLSyxP3CTYUHMtTi6NIfZcA+e9Qu+jkr4L/pgwcOXjRxm1AXOOF9ianwynNTN6Y/XBAcqiZvyTdy47S8WmmrytDaSWN3SkH1mXQ3dH3lGrwzcLEFm9vs5MSUsIQfwdZz3ZJD3dB+x6FIIynBEs0h7JrhSg289rc8Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XBma20y_1790593101;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XBma20y_1790593101 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 18:58:21 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: xiangzao@linux.alibaba.com,
	david@kernel.org,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	kaitao.cheng@linux.dev,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned pages
Date: Mon, 28 Sep 2026 18:58:04 +0800
Message-ID: <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5AF07A000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: imbyxhm64g9jjkmq7d56dh3kc7djm8g6
X-HE-Tag: 1790593107-662625
X-HE-Meta: U2FsdGVkX19c4X+86OmAx3uYeEOEta4PxHoW4p54KFqKGJm0lEqO/EqM+4P0vtDBprMIbtJ72tjQtxgnIlxBSvHwr0GYPXf8FXEagK1B9OEtJjtq+VsidREDGXRaAivBhI2+MBDYWTe0iW/b0eNCaBfiaZB9W0HIBBO/41HDVfake7t2/qJ3g3IKJqLZXfS5aX0YSddT34CFK38UQPwudOs4ftmHb7eul/yFrMO1PjkMyF7OB3SBg9aK8HKClm1BBVcbbjKULxhKY+9JiYGBSvLAIwYHCCN3R6ojCWAE/5QE+zB1VrdR/IQtOnF6XmX0d12FkHtBHRI/r5CSlKf0PtswdSP7/AL/XlnC4OzdxjFvSiTqeLcfNruhmUSeGDCoYWv+PMzV2XZDfruiV2UDXREDcpMb8PVcxuubQFNtSYUjGBi5nSUwNSu5DLz2M5SmprpvBQW2ZyXHKHzZP5oA0Y88cFvR2hwhd7H9jjV/75yv45VNEnyygUFCFIxdRzNsnmpxhd3xmOh4AbVnQcDkwH9pXxQVxSlTWrChe+HFCInkeGDYARnBKmLwbwtVoZTcCt+6DpUC7wZfG2ne4XPU+q35L/geFUZ70oZfbMVXrk7k/OmF/DyIwvUElQqFPa1dBPh3QW0let0sZ5r3qw45GQPdX+hLKxJFXN/DIKc3NjrOHC9T+GKhz85Hkc6yzH5YWUdKP29QKq8+ycmgg7+aE9lhC3wQkzDZl6BdinD7TijDZ0qluMq1ETTyoqUCUbDg+56a4UEYWoeghIuHXet8BteoPgaM5PQmRO7b5BIqpZ+vxqCPjIFz477T6wTM2SGdxn6ARNWNJ+SMVT6P2Iy5+4dtUc/et+KiYCvvCnh7Sm3fU95BZaYT4AvaqkWYXRbJ6eJuzC+w4Ehd99Rsl37gQsUQEB59Lz6zG9PGz7bLo6/ngoefYcG9SxEPBLZpG3TJAa8pMXI97w2kjxqQsu8
 iDlqU8vQ
 Owoz44CT7Hgkwe5QZwT9N1eBnyNrXqPqzgHr8rhptyIUGg1HI4wgpF+TDXU5RXI23s+PcdjHvbPp8v9roSoe5CJiXmQQPqvzW2Q37kU8EKop71ZPvvggea1qi3hFqnpSCamu1v4SWwnFLTHhCl95g+l5FeUlB1bUrTv1ol9X3VQ3cc01zlchtA39ljSqOdNQ0gZXM1mFfH0Sk/JTCcaBLZJUsxoSggUFgUnOaA+6PmFfQHrRzTlNWtZAfLKBQ5cWVg0ZsiFUmQOgr9iy/W+eTbr2ZYGTgWdDjUW+6yYxjBGdISx6vLN9SMEqtFAG3S9a7vXBwXBla8YJo4Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory_failure() sets PG_hwpoison on the error page before it manages
to pin the folio via get_hwpoison_page().  Compaction running on
another CPU can isolate that same folio in the meantime, so
HWPoisonHandlable() then fails on !PageLRU(), the retry loop in
get_any_page() exhausts itself and memory_failure() gives up with
MF_IGNORED - while compaction still has the folio on its
migratepages list, flagged PG_hwpoison.

Nothing stops compaction from migrating such a folio afterwards.
The corrupted data is copied into a fresh folio that carries no
poison marker, and no hwpoison PTE entry is installed on the way
back: the userspace mapping is silently redirected to the corrupted
copy and no SIGBUS is ever delivered.

Note that a large folio with a PG_hwpoisoned subpage can also sit on
the LRU without any race at all, via the THP-split-failure path of
memory_failure() (kill_procs_now() + MF_MSG_UNSPLIT_THP).  Guarding
compaction is therefore needed regardless of how the race in
memory_failure() itself might be addressed.

folio_mc_copy() does not close this hole: it only detects corruption
at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
Software-injected poison - what MADV_HWPOISON and the hwpoison-inject
interface produce, and what tests and fuzzers exercise - never traps
during the copy on any architecture.  An isolation-time check avoids
the migration entirely, on all architectures and for both real and
simulated poison.
The check itself is two flag tests on the head page (PG_hwpoison
and the folio-level has_hwpoisoned marker), not a walk over
subpages.

Neither page reclaim nor memory hotplug lets such a folio be
copied into a fresh one: reclaim unmaps the poisoned order-0 page,
and skips the hwpoisoned large folios it cannot safely unmap, in
shrink_folio_list()
commit 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list")
while memory hotplug refuses to migrate them in do_migrate_range()
commit 5f5ee52d4f58 ("mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper").
Skip them in compaction as well, for the same reason reclaim settled
on skipping: the UCE is rare and a race with compaction is rarer
still, so skipping is enough, and a later memory_failure() will
handle the folio if the UCE is triggered again - while a migrated
folio would silently propagate the corruption instead.

Deterministic validation on v7.3-rc4-75-g62f4c998b297: order-4
mTHP folios were brought into the stable "large, on LRU,
PG_hwpoisoned subpage" state by pinning a sibling subpage with
vmsplice and injecting MADV_HWPOISON on another subpage, which
makes memory_failure() take the THP-split-failure path; after
triggering compaction, /proc/kpageflags shows which poisoned
folios moved.  The unpatched kernel migrated 16/16 poisoned
folios and 16/16 clean controls in the same pageblocks; with
this patch, 0/16 poisoned folios were migrated while their
controls still migrated 16/16.

Soft offline is not affected: it only sets the poison marker after
its own migration has succeeded.

Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
 mm/compaction.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..491adcbc5313 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1093,6 +1093,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (unlikely(!folio))
 			goto isolate_fail;
 
+		/*
+		 * Migrating would copy the corrupted data into a fresh
+		 * folio with no poison marker; skip, as memory hotplug
+		 * refuses to migrate such folios for the same reason.
+		 */
+		if (folio_contain_hwpoisoned_page(folio))
+			goto isolate_fail_put;
+
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
-- 
2.43.7


