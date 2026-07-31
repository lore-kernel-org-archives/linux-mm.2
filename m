Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 908CEC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C536B009F; Fri, 31 Jul 2026 16:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233E76B00A1; Fri, 31 Jul 2026 16:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144436B009F; Fri, 31 Jul 2026 16:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D80896B009F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CF99C011A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:20 +0000 (UTC)
X-FDA: 85050158760.09.E0C61B3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id D500FA0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nBxlqtTP;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pfcGJd0Zogu5lBcBZbtpBfo+xRnEBjukcFUlsBluOJU=;
	b=zIPOrZMnR/FvmkboXIlTvh5J/tTWWuhutG78xYNFnKLxtz7iaIyMULSLvwKL/xEO3+AXcl
	oZ5gxdYwBnABz6VfMHOHyqGRauLES2U4fvQw1rXnVOnGftfp0nT/e9hsVg1y7zTdWmdEjJ
	kXNnkUynHTAbJzh1uNDw4z2LKZXfDlk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nBxlqtTP;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528498;
	b=u+dYJIYhpE/Pgl7IzlZk3KkpiqxZK1ZmGRWDpxJEXEDg0N6C+SH2vBAMYj4ItECkmapThf
	fj79cuNFF4b3jiLhstLv3ahZpZ61g5ymYk74/kSvQM5/DbtsWGSshQ0QW4EQlIpkgb2099
	eT6B1TRv4Zp1QMLbcsAmam6eAne5mbY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pfcGJd0Zogu5lBcBZbtpBfo+xRnEBjukcFUlsBluOJU=; b=nBxlqtTP27i8+63bzV0/yMQxEU
	7PK6NVE7qj4Rhqa+qiBgZlElQfCN8B9Z6SNEn4TwGrGzer2YSVE268m5b9EkKTbSKEZ4QGsyuD1xb
	CgNzUVAHyexiyvhwMgmMLwL6HJvS9FkTvl053rgVxriPGnyNCRmlPKSRqIIMW6NBPjA19G1ttbKyP
	b/uB6O6I1ytzJLim6X/nKrnUEy2s8G/Z1n5+vsCjLT8qCi+rpDAapdQ5cs2qKd82O3BEb8uxK3gnA
	a7zgd8Y8l9/FLopT96H2S5V9eC7uQVU6kacWh4pGcjfYfZqPPo9rkRaV1Yj8FbhmKc/7ZbVd/Amfd
	vA2CFmmg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWV-00000002Pen-3RaC;
	Fri, 31 Jul 2026 20:08:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v8 00/15] Use generic_file_read_iter() in hugetlbfs
Date: Fri, 31 Jul 2026 21:07:45 +0100
Message-ID: <20260731200802.574821-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D500FA0007
X-Stat-Signature: aeozweam9g79t4mnwah84pcrxiid96bb
X-HE-Tag: 1785528498-281223
X-HE-Meta: U2FsdGVkX1+l4dqZVAmqoi64BSqOQ3bz0BjgdxhCdUuRtj9xDRdUnabRvYVWqhCwclJ6hTxSm4k2zltc273pWPtNUEOjHY/3aYsrfS8e3AJES4vNZQuzm7J7HlrrdZRPFc/rJT/ayCaaSq37zCyo6MVP6munWtMkW8+owYPMeVWpUrOGz4+hNvY8Pnt2yWs35C9g1/1SUhZJAQHxnlKt6KqGBEqHCB1LOeXnP866AngMy9/h9wVdAtK3YesTcZ2FRlWi75Iqj5x+/QKopJ95vzAZxGFOUYLyKfgFrJjkjmOQcjlIBoG+sLhxzPzEpe+a5USkK3wVV8lVcE3Rq1Sp7EJ07a0fQ2K3sod8IbamoPCMf9dfFY3XBB7vU51M+KUSZRfX1bP7s1EtOTt+xaXFF7RXpj3LB4Li2XIyMKjzufX1DPF2XbxiM8pa8cDdYo6xo7ILEGKfisQz/wzWM5DUWiUc/BVWTr8YuPi0FtJFud/L82HLxEpvf1H/nrzTIBLYKKb2hH/u066wzYHhYP1dKD3vUrF8HW8UWDtYVGaVpzOZ87tNoLBr2+CSgqswnqn9NjU2lFIUNiGr5NbJQGbUo2GqCMOCbc0HHxZzS5Jo+zAzQA+QW7JNQD8NBHwpODoUYmNetj3F8kl3Fz4TPCG1pbpArV3WTSQO7al4xqYMDsGsDm34Ef6408k703q0M+8lq0Oj2CUuJyATqZ4/93nDLgfXavu5yznuWSPMSPNEB3NFuGgcjEv36hDgfyZBd2l2OYsooizVOI5GvnYv7nRnqiEguwqzX+2ZVVdtb+MNAS5eA2CSIr2r5Ye5ej20Osovasw5hUR0Eo2HxQhhTSvEG5oOClnExF1alGww9376C2Ogh/VEj6sNLyHTfjlmBFCP0gsPU5SbvzbzfrlKvzKStMhAOoOpmQ/5ST1R9Q/rMFDZeWI26Dins1H97gUBjxpXXhA1Tf5D4yuMswHXKpe
 8HWQpdH9
 7v3cxlfXxgMQ1sjUf880AfBHy/Rbs7MRsgjW4KFFv36juGAvUY/FdTpG/Ff66CVQVVILEUHmRTsO5x2VRE1gWDbr5dor7aFamATUQnFFPEnG3ahpm9CyYYgm/PreRhTtwUpHJbuqb4qzHJTxsPkWOuR/PyzyxekD6x5MeXGjIfdG1aanJNe67iq+Zzf+CpqQQDhzq1TVXSCDvpEIBjm1AVS7BJbYg6rk1ZGdLNjDrX6EuqxOb9YnYm60/s8segmQNPyfDRA8qZh7E00qERco8/Bhu6Hfd83pHHhPqJ1QI0PcULqz5C7sUQ+qILhEZ5KMiNHM9jDY+Yzfc7KsmFMWO3THsI/7Y6OQpA9u/2erpprqwIHmLC85WyHCUR1aDuegTu+s9jXya5ZNkBS1cR3hgqFFuOeRSQ+1vwoCtwZPun/0CB+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

We need three things to use filemap_read_iter() instead of a hugetlbfs
specific read_iter: hwpoison handling, treating gaps in the pagecache as
holes, and having hugetlb set the folio size in the mapping.  hwopison
handling turned out to need a lot of prep work; the other two things
are fairly straightforward.

Sashiko complains that the implementation of AS_AUTHORITATIVE is
incomplete, but hugetlbfs doesn't use any of that functionality.
We'll add it when we need it, either when hugetlbfs uses it, or when we
convert shmem to use filemap.

v7 here:
https://lore.kernel.org/linux-mm/20260728204409.3396238-1-willy@infradead.org/

Changes from v7:
 - Split preventing freeing of a hugetlb folio into its own patch
 - Add hugetlb_lock_irq() abstraction to fix compile bug with HUGETLB disabled
 - Use is_page_poisoned() in kpageflags
 - Collect tags from various people

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (13):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  memory-failure: Prevent hugetlb freeing during unpoisoning
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
  hugetlb: Move poison to pages before clearing hugetlb page type
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 +++--------------------
 fs/proc/page.c             |   8 +-
 include/linux/hugetlb.h    |  43 +++++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  63 ++++++++++--
 include/linux/pagemap.h    |  45 +++++----
 mm/Kconfig                 |   6 +-
 mm/filemap.c               |  51 +++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |  41 ++++----
 mm/memory-failure.c        | 197 +++++++++++++++++++++++++------------
 mm/memory_hotplug.c        |   2 +-
 mm/rmap.c                  |  43 +++++---
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 virt/kvm/guest_memfd.c     |   2 +-
 17 files changed, 367 insertions(+), 269 deletions(-)

-- 
2.47.3


