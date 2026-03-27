Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B76810F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712306B0096; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA8B6B0098; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFEB6B0099; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7766B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29B3C1A0A59
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
X-FDA: 84592342338.04.6206EA4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B18D40014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Jy3sN4o5;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628107; a=rsa-sha256;
	cv=none;
	b=2eZ3SCe6gldPKc769FNKJYzVt2WscOj2ZS7KDsVUjhYrhh3pDJyYlxqTHERPJR3mNGJ337
	RVYbYxB4Xpb63uzIaI58rapcFNhH6dJD9ru6325E94gwaUuXja9YHs1njJMYgmOJdfOfmC
	ISChdVVEULxrlzVXzLYUXdyrS681zRM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Jy3sN4o5;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8xIH/bLFhgsX9Xukaml3GhxkGzwhy8uKInPK3LEkRJI=;
	b=8YUD/ba4w4tN3cPhUOOKvrLapWEPh/U27ZEizYk0N0YWPm6v72z0NDWgJ2t1bGNGCeaBqf
	RIVtRgtH9Q7cNjrHMVCPBnmIp1tYJEC9bK+BjmZpO6vX73N1OYR4z/PwKkCMjbdeVfIQ/f
	OfypKoSUc3W4PZi+/8wSYNfMl54Bkms=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A3669BDFEF;
	Fri, 27 Mar 2026 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628105;
	bh=8xIH/bLFhgsX9Xukaml3GhxkGzwhy8uKInPK3LEkRJI=;
	h=From:To:Cc:Subject:Date;
	b=Jy3sN4o5JTt/lp3RF525qilKkgZ3mjrIsZeMDOsqPvoKly6lLxKMrQBT7QQN3D8zf
	 HLKqPqSRlY21uGChc95OFIkq0p8gv7Fva9n2UOzD3MskSoSq3CvW5KcbFLldxRXDsX
	 aCZy1XftEM6xrxzN2ZcKq8cfBp4KDSI6Dn29QwOg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 0/8] mm: use spinlock guards for zone lock
Date: Fri, 27 Mar 2026 16:14:40 +0000
Message-ID: <cover.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B18D40014
X-Stat-Signature: sx3oksmfymyjrpfp66yn65pkwekih7x7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774628107-572188
X-HE-Meta: U2FsdGVkX18s+alTWaOvoXJ9uuB/h+jwRnq/Ha+JUZVxGm4fzVZNFPqds9L2UsveNPQHMLe0SGc/OTt7nnIsU/SutvFBIf4MQtQF6xj9zZM7jgTbv60a+nOMOVhNpK2gsUoYxL9JltZdPvMhLrFSG5xM6649tZQ8QEPZ//B/bGq836Dc+p1O2GJXYqK87j+jA6S0vZLF93XkDTWqqPjR9v/taSA3V1iM2CeX3IwXnOc4gpoUFg76jkCtmnIncIEtBqWcbL1sgyENQdpgxBwsV+wzBqQoAHK+iqOhFrP5PZRL071gHWfkkug5KCKCmrKQharccW2Wu4hj7UauzrqXWkJEs2KZ6MvTeKNwgnejJRacTL+s02KlS6npy/OQhJNbFJwd8RG78Ct5WPtRSicqhBsYEvx94bbYNyu0Sc4Ph5y+prfQbg+zfO/wlrPdbzSJ3/a3FfVztiFNG0C1GctHnpfYHHN34ovVEBiBO6ZkP2JYDrPn7bTVWa65IFBLcyLmDA88MdImPZdEER8K5W62MMhzUUDF4oSb/hFcjiJqjc73GRacpAXsiDjSm6VhZSfnbr4JTPYq9m8+Mj4F2UPg55j2pe6yJAK0Y6yyw3Qq2/dSGbkdLnhlKRAfWt6WH+lhWG+MtAEOaCTTke2joaDptyU0O6q+PQDrupwvZzK0o9YiQUoNEuCLIeo1IG6DqNDf27emxSs9bXeTTc4JhtGMHmVsh0fwZKhGqxvui+2/vNmyLKL3tEAAWGxvXtp4QMAlmybFFmsWJGv3MMPsHqJSxLsTuYpW41cSbFkPfbsh5MjfdLbKXEnClGc6bV8Xes+QdU0orUdeJ8fB8LbFF7yCW/sSB+pj6SaaNy0ZYK3lMrPzvTsvq0qxYOj2Vqfmpxkd2CKrKcVT5t/mrMAC6pFUIj/2Smzy58OT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series uses spinlock guard for zone lock across several mm
functions to replace explicit lock/unlock patterns with automatic
scope-based cleanup.

This simplifies the control flow by removing 'flags' variables, goto
labels, and redundant unlock calls.

Patches are ordered by decreasing value. The first six patches simplify
the control flow by removing gotos, multiple unlock paths, or 'ret'
variables. The last two are simpler lock/unlock pair conversions that
only remove 'flags' and can be dropped if considered unnecessary churn.

Based on mm-stable.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

v1 -> v2:

- Andrew Morton raised concerns about binary size increase in v1.
  Peter Zijlstra has since fixed the underlying issue in the guards
  infrastructure in tip [1]. Note: the fix is not yet in mm-stable, so
  it needs to be applied first to reproduce these results. With that
  fix, bloat-o-meter on x86 defconfig shows a net decrease of 49 bytes
  (-0.12%) for page_alloc.o.
- Rebased on mm-stable, since the patch this series depended on was
  dropped from mm-new.
- Converted guard(zone_lock_irqsave)(zone) to
  guard(spinlock_irqsave)(&zone->lock).
- Dropped redundant braces in unreserve_highatomic_pageblock()
  (Steven Rostedt)

v1: https://lore.kernel.org/all/cover.1772811429.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/20260309164516.GE606826@noisy.programming.kicks-ass.net/

Dmitry Ilvokhin (8):
  mm: use zone lock guard in reserve_highatomic_pageblock()
  mm: use zone lock guard in unset_migratetype_isolate()
  mm: use zone lock guard in unreserve_highatomic_pageblock()
  mm: use zone lock guard in set_migratetype_isolate()
  mm: use zone lock guard in take_page_off_buddy()
  mm: use zone lock guard in put_page_back_buddy()
  mm: use zone lock guard in free_pcppages_bulk()
  mm: use zone lock guard in __offline_isolated_pages()

 mm/page_alloc.c     | 53 ++++++++++++-----------------------
 mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
 2 files changed, 45 insertions(+), 75 deletions(-)

-- 
2.52.0


