Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D90ED7B91
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE816B008A; Tue, 14 Apr 2026 05:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238776B0092; Tue, 14 Apr 2026 05:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DFA6B0093; Tue, 14 Apr 2026 05:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F281F6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:16:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6661913B087
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:04 +0000 (UTC)
X-FDA: 84656604648.23.4F6F129
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id A33AB140005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBmjgWhe;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158163; a=rsa-sha256;
	cv=none;
	b=hciLs5HljbFI5DK166WQJC1zfZn0LnqFx4hKQQ9rMRYNm2kqZynfbOVhwOJmeEmehLWNI0
	mnJDjY0QMBcPOhaET9VYEgV1+d/R50h/cHBOUCQWldr5y9IjOmdGppQhXaMYZ9wwW8rSui
	sa7gF4kEK9/u9oNUDUI+uFfqxXuYktg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6YYUjeEpkPT0K3PrG6y+MGQFD9TJLnkIu45vx7R6QHM=;
	b=tXTAL0zTOiXHa1XRfJM0/T+pqeStvN4RKvFfQRMmrtutyveaUB0Xc+HMOHDWCyhSfY+/ro
	p84Ms1ekIbIZhyE6lABGLaW/WJp++u0HtP1148y/RPqs+CVIeJBQHQi+gpd8umSFukNWrp
	Fxz2AmffBcEn+7u+Pazzc4ZLvBVoHyQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBmjgWhe;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776158160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6YYUjeEpkPT0K3PrG6y+MGQFD9TJLnkIu45vx7R6QHM=;
	b=EBmjgWhemYC9xXzGLKTfuUv73w2TQ3liFjCP9Lx7hLF4VySn9RdWC6gpDmSAk1srRGfAxL
	AlAFpJ7Pa1dQza/tObIUYm7suI/FKqYv69jHVqvlU3lOynSO11JouOoljg2QIl9kSNs1XV
	Zcoid6DRSMXaGAi2mry2DiA6rafRUBs=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Ye Liu <liuye@kylinos.cn>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm/vmstat: simplify folio stat APIs
Date: Tue, 14 Apr 2026 17:15:17 +0800
Message-ID: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A33AB140005
X-Stat-Signature: 9w8w45guepr75edofzjgu3xxkfbkckre
X-HE-Tag: 1776158162-409858
X-HE-Meta: U2FsdGVkX1/nP0mFYm4K6VLwG+LWKgw+Lc7ovwL0iNvwOR1L508wh/Js05aKhZ3mXLnCKAWSfIN+yMvygVBtEJGbmjD66APaekf+pGfhbfJaDCSevCHSbesQG1crQ/OHAI7gMZrnySXJORctLT0E1zJoi2qX4F1l0B4PKUL3+tcKPx3FxmZSlm5BSuDNt7rd0gWUoLbevuMzrhiI+CfhIW08x7mQG+DyuQ08p5sb0+DkSIIHvFadg772Td/HqPu9vcQNJIQVGqvBQaiI/cIbgQ+Dt0ZJ2CqVwjd03Jo46xRKnfsefuu1cbzMvdHLKXyt5XOJ/1zLU0dqBucFvTH8zCWLWUkVE6SlsJguN8pcSuNbr5OpYi2+eJST0tfv0kP3hgLz6iwoMv1wPV35gIGEIhO4TLMqe6cwoTKrmX5q8UmmHBNWuwWXXIFbpRC/B+0L3xrgP5C+jkQlaOjdlHTt5+bkzXpLTK6X+lZm3fLa+SGp8iezxQizeyZJPYT/wJQq+eUT7eYSt8c1RSf7ypPK5RQL4lpMdqXKtBknGl3u0sLLD7VtQ1ryJrMcmcuZzKBX4VWTen1DZLnD+FiJUo3bg4xzFeWgQx4k3HZb1xtu6W0cpboXO7JyHmacazIo20PWjb0X/QjP/qUGvBLWNkUt8Hzj78F43rv6APIz/0xT5ibNrbf75UgngvmRlvZCR2AmL10syGB/J5FbCthj8N6JFVNsRuTecL6yz10nQbnnGDLsbCGiCQlMcOiRjlxT9FE9LVlAGiGx6IOKeXr1yM8h4KUoSMp1lA8nwnwEXeAgFGd52+G0KpFElVd/Mad42IjI4U0tHVA+83pCmepCVAQrzBgVc8bxlq8p9wVF+SfdsZaE2WMt02SuN+x7wfKgwFD2LOam+X+9xDzFuIRN40HblxIUdn5i4BKllpGPW7BUYedxMaCP6LY1+p++gBNZTR5c46OXgKbVKLIGxuZsM2b
 YsLD5U84
 ei8YdOm7JT7M9gdbq0xi8y5ZPocWFjOriMkxpGCWcCZs10+acJHbUMMS8DkdUXXx+ViFxx4E7OsO9pvh1xXVkIptK932LSwZ8qkmfDCF+2KbjrrnZMldIUaL3NXt/cMLFGIagi2/McGRQ+ujwD1mPB8VNoE8v4XVLLODnBP5XKHPIlkxZ4/TV5jhsD/K7lB97jM0cq9/kS1kqsX3RNRDjhE/+raLpQgxkPYj+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

This series simplifies folio statistics accounting by:
1. Replacing node_stat_mod_folio/zone_stat_mod_folio with more semantic
   add_folio/sub_folio functions
2. Removing unused __node_stat_* and __zone_stat_* wrapper functions

Ye Liu (4):
  mm/vmstat: use node_stat_add_folio/sub_folio for folio_nr_pages
    operations
  mm/vmstat: use zone_stat_add_folio/sub_folio for folio_nr_pages
    operations
  mm/vmstat: remove unused __node_stat_* wrappers
  mm/vmstat: remove unused __zone_stat_* wrappers

 fs/nfs/internal.h      |  2 +-
 fs/nfs/write.c         |  2 +-
 include/linux/vmstat.h | 36 ------------------------------------
 mm/compaction.c        |  5 ++---
 mm/gup.c               |  5 ++---
 mm/khugepaged.c        | 10 ++++------
 mm/mempolicy.c         |  5 ++---
 mm/migrate.c           | 12 +++++-------
 mm/mlock.c             |  6 +++---
 mm/page-writeback.c    | 16 ++++++++--------
 mm/page_alloc.c        |  2 +-
 mm/swap_state.c        |  4 ++--
 12 files changed, 31 insertions(+), 74 deletions(-)

-- 
2.43.0


