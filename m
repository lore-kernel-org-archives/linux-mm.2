Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA1FC79F82
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94E66B0093; Tue,  8 Sep 2026 22:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B5E6B0095; Tue,  8 Sep 2026 22:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81C86B0096; Tue,  8 Sep 2026 22:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96B156B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:36:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EFCBA4DEE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:36:15 +0000 (UTC)
X-FDA: 85192659510.07.E59CD44
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0BEA20002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:36:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pu3+x7ze;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788921373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3X7M8wd36LdkjWaRhem4HHD64AbWVsJuXoeZADo2jJE=;
	b=NquVSmpOiEm1FJjJy6MePQAZ41M1qh09ohzMHiBXvOH+0WcytAkeVZbOF1EXJI/6LD+G2+
	GiABn9GuSHi6SUOLRGEebn1EOqrM4UqT6nRhXuairmJeYNGBZlOpgUcYgf5uJLcTjUhYRH
	0mqEYExQFW+1eNEpzORcALfR7hzyrTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788921373;
	b=KXOhGhvJPP6AacY2kWFbaR8rcF1pt8G9eV0+oy8BDSm/CF9BHzVjIlcy7hzyhs23iVrjiw
	9OwRPeQT2m2cULSGFrvxjoVSxPXWyvyacG5xuv9hR/4LyBoSCiJfk3X1xT4fgW/7zOqOwd
	MgbQzBe4SAz9HQzm/gvmPI3yWIYvBIA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pu3+x7ze;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3X
	7M8wd36LdkjWaRhem4HHD64AbWVsJuXoeZADo2jJE=; b=pu3+x7ze/ba44xU2s1
	QGQt/R5WsHwZiLHtTfXTFqYHE1Q0SbZwy4ZGgE7IIoce1t6SOYxzAFcYBQNLfKqw
	+U9AYyBFEzQ4Tu73QMImvHUDXHePQRnnN9ktFkRRJtIQYNc0aYoaNV5aRsEt4PjN
	s/fdtd5GrJ3bQoRe4wNhuix90=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wB38SYOxqBq_1b3BQ--.26192S2;
	Wed, 09 Sep 2026 10:36:00 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/ksm: trylock the mmap lock in the unstable tree walk
Date: Wed,  9 Sep 2026 10:35:07 +0800
Message-ID: <20260909023507.1408925-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB38SYOxqBq_1b3BQ--.26192S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCrW7Kw15uF4Dur4fur48WFg_yoW5Jw4xpF
	y7Ka4jkr48Jr15u3s2ya1kuFW5u3s7KFZxG3yfta43Arn8JwnrGrWftFy8WF1UWF1Skws0
	vr4jva4DKayDXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joGQDUUUUU=
X-Originating-IP: [2409:8d1e:1b11:5c8:1d59:5ae4:f58d:d2ce]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xB4cWqgxhCKNQAA3N
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0BEA20002
X-Stat-Signature: c3pjrwc3j5h3qineigshmgfyhtcqhzxc
X-Rspam-User: 
X-HE-Tag: 1788921371-153467
X-HE-Meta: U2FsdGVkX19MfUIWLxjNUVmBLeWM4A96AWTxM4/Bey72D/o0oZL4LU+hqiebO+DV12KZlPMUP091QC8VugMxuKhwOgAiESII+XgvSmFT63BQacccZwv7lDuzmuBNufugQyjmprPiWc2+q0D2NdbDJ4wq4BLTMsSqqA5cba6LGNZ/CvKKFJ+eemVeciErxOf8TgLaQ+3HaQUWMuVCKcvi4zfczMm4swJY6c9YtEG+XBzKnX2iEuFD9K1iAXQuK8DhMuo5ipY0lW32cWNFfy0JW2OnnRdynyxRRJD67J043QEsKE3Lyv2hU3GXP0gKzbZx2xTQ9rGqRUrZiqnDtohjH9GBTo95TyxODsixAJ/yGL0rRBldSwUWwouj+p3QsQfqTpmgX1T6yeqB+/cQ8/LGmZi4D2WHuKRvkQhoUKqejjaaWTTMEjIyViZiDLBGdWr9d+hNLf1pScFa0DY3L61lppsI9HJcVjYXWK7LqkHdYCII28HdOaphaMGQIWZ8wrtfHrzdnz2GQgTFFcD8YoWSEUImbF0yySO6Ku9/aMJ3kdhq4gAcl2Jqc2f9nGnQ6GAu16UAA9n/Ha7ym9xmqEi1jt55dwwHqSkJUxr19dtwpr5qmVHPeMfjB1evt1ImQeb+0HEPkIPY2wUS/1+IlOmzOEsvEGuM8HUqpDcYXj4T/iIgQ+MLwG7oFj+GdNXyfrXHtuHjsRj9yJQOSncne/Wyf/BZI1OMMbJ38thGzfqkS7/XvFllZ/xDNWCmPjWbVxgLZ2OR2dY+l/yvqWYo7+YxIHYAe+qaci63x1ocZe+uNEx4oGgR/TzTRj+8pQ24/6AbeXLQzyM8+uHkX8oOqMNrfCqtrVFPeENCwi3IEzM17l8+D1uK1ofttuzQzGEpBc77fCcIXqFNsMCkvC1lrsKvx7fM+PJc0leKB8wlpDyvLHPLTHs8dXXZbHShg7Kv/pLd3nF1rJKRnbbEsz+VuiO
 mve2K7pX
 lH2hhTj9r7/f9aAg7Dxjt0YAC5s4PTlaPK2KWtq8m7rQCGeV00mPVzAig30UEeTcmqPwXnZO2qZCk4vYQ64XhCgNzgNwUc0Ril8GWuh37cJhi8UkwxcRtz0BIT7TxxSLDhEjs2eWogoHeSfFkO2/vf/w/14jvM2kHJD6W2iMlmFt2ki4rgggYNOElzXfRBYMM+1Wep6/D5jdvbAfKI4pN3CGYxSxVy/x5vUzW2b4OiCF6Hjs2VmOcbp0JbNJ21CPKad7BEEkesFQjXjHzbjIdbHL0eZ78W9zXY9hoyso12MTUy/v0yLgtTeMHs9bIE43BSzVqhMy5+/O0/Wel8Rs1DawemyiglzwWOn2ZKy/D7SgVskic0IXQb2TLh8CwVAxKVXh5Y7QJQFdYs+9yMxusWBIzSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Every node that unstable_tree_search_insert() descends through is
revalidated by get_mergeable_page(), which takes the mmap_read_lock
of the mm the node's rmap_item belongs to. These are taken while
ksmd holds ksm_thread_mutex, so a single mm whose mmap lock is
being written to - a process busily mmap'ing or munmap'ing -
stalls the whole scanner, for every KSM user on the system.

Use mmap_read_trylock() instead. The trade-off is that pages of a
contended mm may need more full scans to merge; in return, ksmd
latency no longer depends on unrelated mmap activity of the
scanned processes.

Testing, on a 4 vCPU QEMU x86_64 guest with ksmd at
pages_to_scan=100000 and sleep_millisecs=0, 5 runs per kernel
(median reported; baseline is the parent commit):

1. A contender process registers a 64 MiB MADV_MERGEABLE area of
   unique pages and runs two threads looping mmap/munmap of
   256 MiB, so its mmap lock is held for writing much of the
   time.
2. Once that churn is running, a quiet victim process registers
   32 MiB of 2048 unique pages duplicated 4 times.
3. Sample /sys/kernel/mm/ksm counters and ksmd's /proc stats
   every 0.5 s for ~2 min of churn, then stop the churn and
   sample until the victim finishes merging.  The same phases
   run without the churn as an uncontended control.

Results (median of 5 runs):

- contended ksmd scan rate: 11,473 -> 58,397 pages/s (5.1x)
- contended victim merge time: 10.4 s -> 1.7 s; the contended
- contended ksmd CPU per scanned page: 13.4 us -> 3.5 us
- ksmd time in uninterruptible sleep under churn: 78% -> 57%;
- uncontended (control): merge time 0.65s vs 0.62s, scan rate
  259K vs 247K pages/s and ksmd CPU 3.9 vs 4.0 us per page,
  unchanged within ~5%.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..3cfb09a926ff 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -820,7 +820,14 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	struct folio_walk fw;
 	struct folio *folio;
 
-	mmap_read_lock(mm);
+	/*
+	 * We trylock because we don't want ksmd to wait for an mm that is
+	 * busy changing its memory layout: we prefer to skip this page and
+	 * let the next full scan retry it, like the folio trylock in
+	 * try_to_merge_one_page().
+	 */
+	if (!mmap_read_trylock(mm))
+		return NULL;
 	vma = find_mergeable_vma(mm, addr);
 	if (!vma)
 		goto out;
-- 
2.43.0


