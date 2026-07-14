Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69296C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08FB46B00CA; Tue, 14 Jul 2026 14:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D566B00CC; Tue, 14 Jul 2026 14:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCA26B00CD; Tue, 14 Jul 2026 14:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFD6B6B00CA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A19C1C0496
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:58 +0000 (UTC)
X-FDA: 84988168356.22.2AECD98
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 65C7614000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q3B9eheO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9lX01UwLV7UAXCKe79JoK7OX7vyBJAoMehKWTs9zGjE=;
	b=Qr/CQtMhHQCgtjwt6+tHp2p54nxjfVyU/ObVLb1L+lE+Ef/vwTscF9HD6sK16YZOopl9h6
	BLAo++c5HkMNF9BdI9iVJaW/h5138e4rdVMR7h+XWRCxFzb2K5dFJ7iW68IwoNN6SSRfpE
	YZ+M7r9gThJ4fYkJ31b43XpECDN8yjE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q3B9eheO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052536;
	b=SidQy8WY9S+7UDdyMqyMRR/aJ4T59SZzVhUv4I++02vadbC53k1HFcgHY1Df3jxOAHcfgu
	/cwHSAv8RySzh4wbrXEImIP744L7aFBk7OgoJv85dhOlUceV9ByGB2/vdSKCnuCt4B+Dpa
	FFA+vtog0OTO0GO+ufJpaIb+0RVRUxM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9lX01UwLV7UAXCKe79JoK7OX7vyBJAoMehKWTs9zGjE=; b=Q3B9eheO9hBpEJSLxvfbrZwdd8
	2lR4t/cZ3h+MB0UgrmT0ErbhHru3FHk+5P1tyTgFCe76wfXPPWl/k2F2VZV4Fw9PF/rIOhQAehMrk
	NT2/QVIS/rLDrjyWAEFBtg+bp4mc0NAj3cUK/T7BcTeXfYUt2KRkYwLBdsUk0cEWw72S9wj++6oFD
	Nr+YUvX1Kce6Hg8MFXYjqrXnOyU59xi+sJsqxJCmMxhIMWGgI827Vx9VsWInhE8XobP5AFtTy4nrc
	XJlIro1AluTcgCf192CiblhBz4GnzVHz8W+o8lrlvPErQUl1D01bpVMeGXr6Wp/B1Oi0cGbkgZa//
	ed1E3gBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYg-0000000FegN-2K3I;
	Tue, 14 Jul 2026 18:08:42 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 0/9] Use generic_file_read_iter() in hugetlbfs
Date: Tue, 14 Jul 2026 19:08:30 +0100
Message-ID: <20260714180840.3731244-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65C7614000F
X-Stat-Signature: 5jk6wgpkhirnthhfruuqanydmhss3iuh
X-HE-Tag: 1784052536-861062
X-HE-Meta: U2FsdGVkX1/QCIh9KrjjS3cfrz3xk4aXmkhKsDStuqfvM4tMfsPGAecOt2e6GOqRKrR8nUrKtcJEukjY44BDJYEACctdVT2c6q89LXyaGjYB/M1+XLxuqgx2KxwscqACyCsSoWoOyuHBQzjPbQXByitZYX+ftBFnkJAlnb5hWGpELuBjinaU6/yLON00XT6C7Ml4otpxsOYUH31RFL8NQd5WRs9vWS4Xu1Z/oDm91isOzVbq8I9o+MJXXfKMXRx7m/56CGx26L9FJvs3pPUIVx+RLbZ6OJfudOi1tfUuHQM14Vgth4KbbHSfy5e+yUbrV+04HFe3gy/YoHKfRXFvHk0aZLL/SBh4/ZMRhoSMYsctlP0MxLBaLtyXgGp5jqR8CwHJ+XCk9x5Lnbxz47xDSbb6K5L1fR0nN9H+MgywFMiHS4hlM+Q45QpfDM/vvmuigUIDPXKvGd9wOoyxcpxtfzNlWW2es0NMvE04ol3LE0m+Mwc2QHrph+0XDGHiG+ux74MhTigugUoTjsNg38RbQReSyz4mLAAeYekMhJ0zF1dEPBgzFtLF/ITuSP2ptbA03uBG45gAUWvNFPczTzgydYlyxDt/TPdjxtPknUKjSa/mPJJYpx7B9Qhno2xO5tgakTnuI/TRCf9qzWMw6jQ/+ZNY4zdsI0u//LncTcj/EkeTcyMfh7nwr8VNFWWhE85920NGXTCorG//SvWYQEgDdSLDcVIUQk439tYsQbDpk6eWPIsiZNGUIpwEU6hlSlQGvWGvfuJXW+vWZp17daqv++3U1E8sZKYcJtdHhVb2G61UyjiwL8gQEhTUbDVfPkCODbRUffHvz0qCFXJKoKlO8JQ17WWVUEDpGIJ62TxHFOv0p0X4ZQP9ogDsoRkfh+Rs0J6u/+44p2cOl6LCxtNqYqc03y/rL298oWgW4xgGXBZISAiD5c9EEWyNL+6zfJy8C78+wEyaFHiLoBGDS8z
 tOCNbaQA
 QbKqe7JQFSN97WeDudrqL1mui2FzpiFMBi7AZfRuWgYMEOOKNPW5lAiIJhEZI78EMWkaq0+UwUc3RxRHCe8LkifGQA0CkMrJbBnU3S+xlWTGp5yzT3WVZlYqjG9omCdFioyJ7GNWvTjJKMDXD8uAfCT81eArH7k4nEshzMTrP9YvmWjXTy3zSaM01Mbn8aD6cBpHU000rqaCDd5gBA14AZnfNiP5QC8BVKtVjzm4Jxj8+VHKTad3hpWtZS6PBP/ax6ifZPCELmMuJGWyKUJFgl4OOSXo8LhOGTA3+DTaymJM/jeutcTC74slOghhLxwoF8yTdG1JmCmoG/jSzK0rrH6zhhiVR0FZeWS/iTCFhbiBR4fnNdqo9wAdPpDNQPVVIsYVM7Pw+cOuzkECxmwLkc++jTmkrgL1/aoeBX08UhFYFRL9hyLLwHn/9fIkvoaw+8KakhD7XSyOktgyRT4HE9OyZrlbgxlvJhEgT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

There's enough potentially controversial things in here that I think
it's worth considering them by themselves.  First, handling hwpoison
in filemap_read().  I want this for shmem as well as for hugetlbfs (a
later patchset, maybe).  Second, handling misses in the pagecache as
holes rather than opportunities to populate the pagecache.

Sashiko review of v2 here: 
https://sashiko.dev/#/patchset/20260709184740.1286561-1-willy%40infradead.org

Changes:
 - Introduce CONFIG_FILEMAP_LARGE_FOLIO
 - Reordered the patches to do all the hwpoison handling first
 - Picked up Usama's Acked-by on a couple of patches
 - Rewrote handling of hugetlb hwpoison completely
 - Return -EIO instead of -EFAULT when a read touches a hwpoison page
 - Add a call to mapping_set_authoritative() in hugetlbfs

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (7):
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  memory-failure: Track hugetlb poison in a hash table
  mm: Handle hugetlb correctly in is_page_hwpoison()
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   1 +
 fs/hugetlbfs/inode.c       | 122 ++++---------------------------------
 include/linux/hugetlb.h    |  24 +++-----
 include/linux/mm_types.h   |   2 -
 include/linux/page-flags.h |  28 ++++++---
 include/linux/pagemap.h    |  45 ++++++++------
 mm/Kconfig                 |   4 ++
 mm/filemap.c               |  51 +++++++++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |   2 +-
 mm/memory-failure.c        |  80 ++++++++++++------------
 mm/memory_hotplug.c        |   2 +-
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 14 files changed, 167 insertions(+), 200 deletions(-)

-- 
2.47.3


