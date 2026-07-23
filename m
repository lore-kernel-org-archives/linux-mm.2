Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DD0C531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F44F6B00A0; Thu, 23 Jul 2026 10:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC256B00A1; Thu, 23 Jul 2026 10:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894046B00A2; Thu, 23 Jul 2026 10:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 620B46B00A0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D750FA0517
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:09 +0000 (UTC)
X-FDA: 85020278658.22.2314CEB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C6B9140003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uBy4itk1;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=010wDpCrLd3D32pyHmx+75SFv1G0aLKQNuZGYw4i5+M=;
	b=WRB+1vTVWcLQjd3hccApbiQpxlZHdPZylm3Y9qG3uHm+3V+owGwSHKiyjDyMmtKGCTxXfd
	ppjx7eWrYZVTopcrX2S4uKwG5lMKIYBO+q8m+cfTb4prXtdD7z3LZ+wKgpe5xmArQ3uHpm
	DF2rmvl1xDZWAI+bL/ZIMKk9/sRBZz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817068;
	b=Q5iWMtf9eVB1jjQrqZuqBOoJuqsEDJp6B9ZtlL/NqKHlq8vib562UHjD9NUV69xGeHya2C
	/ip1rHr60dOeSGyEV9fBQU348gFaYkgGhPjXzidRWPjfk7dCL4coL9T0Eemo1+9C4gR1qY
	B7MYA2p5YAh7v7InjaXfYGXdIQFPCxw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uBy4itk1;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=010wDpCrLd3D32pyHmx+75SFv1G0aLKQNuZGYw4i5+M=; b=uBy4itk1n3e7Lkx6cb5SDL32sp
	LcADm4P9fz5I9zbs/4rvqcP7lMQzRs65RVu91befmKCIU9NYda/XoXkcEKmcQe3pokk6zHb9qHWsh
	z4/CVMRVILANqMMj2vOje7//9sDQNe4qRJNUH8FPSgDaoj11U5O2cj954q/KA9zTMKqF+3WOPwGle
	UNS6Q/prVtBenR+Y1FMIMbEBjUkqjw9w8N9ZIE8CpcwkvB7cKb8Zk3Hm8U1flvaDHS9fs9oMjS1E4
	pjeqtQ+hAeECvKR04915iEpQRxTTkmwUfuiiXcck2CZRyOj28yHsbcefQFOYiUdF/VYjQKMCBoVca
	tNDQ0EFA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jhl-0K9s;
	Thu, 23 Jul 2026 14:30:36 +0000
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
Subject: [PATCH v4 00/14] Use generic_file_read_iter() in hugetlbfs
Date: Thu, 23 Jul 2026 15:30:17 +0100
Message-ID: <20260723143034.175661-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C6B9140003
X-Stat-Signature: bz33ufhyhcqudirukzwop38gux9xs9af
X-Rspam-User: 
X-HE-Tag: 1784817068-340706
X-HE-Meta: U2FsdGVkX19dRWGphQkMT05ZZyw32maN9Vw01UN6SXYUYvqd++E3rx0e1t3q2MtUZZMpK+Y58zjI1OjvaBkE3dTfrvvlJtAQrQUw/uQuS17D1PZYN2DNHxAP6PIDcCcPcMGP+XPQykpp9p/Vq15EapmLZj9eZDkhnPjeuyp0KGwJDo8fsJb9b2cYmxWFaYq/F9M1LUvvV7p+oDNNGnn8AqoSPFn50IKQOyyXpw6bemnCriJvp4jourlwkDQcumJJgABah4/R6UwGMW4uF0s0l/jWOGZvkBeUSUV1Jt17/omP5oTL5pmAX6RlYYPk+n6wAXAolUHDNXZdgFc9ACqKHBAdSLJlSwKimRmXKvl7xWi/j+v8nEzx8x3BHYvVByB6svfgSLys0Ci0YFvHTtgpizc6Ye0l56tOxdGu4YCEmFxrVN+FuZ0k0vC8cv/J0vzLIosM/GJIYeS6FySEGj9VRFOZ3/SnfLkbxTJAgQ2whvOkKeVW6R4Smwydv1F9UH8QnwpMUE7wZVwDCCM1HUyMWMaXOAMQLzXov3Ig/aymWI6qkRBS8n7W6WoII9y3/9+1ybGq2XeLUR6lI89XsURpdGLajcK6jFThJ2hXXCbGnRO+jEKoFVaXCQD+fz919bGN05/CHpppsI85Qszj6v6zhnP7oIxZG/AIuNUWmAPo3CnncckReytNwW5RrexTkh/M93rD1/ihnEIzyDSv9o7NZLt58LyYKtnJj1+5GdhXvYRMparapn0m1p9ToqcZ/7PChcQGyB9lhOtzQNxyOCj59WmjBu1leNkx1Fb5HkZA/a8kFunfMHljKrFosPW7FdXG0zWgEYN8Up9SW7JlIiZz4As4OOZVKVDC0xkGj2am5vB4IfkSoqsuwYIt9KkkWvpdmF2UfhJNWXOeJk4yYWOdtIs16T+Ev3PAsILZKC9Rsq4/IBNTsCujuZm14ozmbP4AxNFgeUJ2AUXtPKrF7cZ
 ZeEA4EWE
 wsV+IHjh5ClGRRTm3ZH08oejOfHcAXLe3vm78H9UwRpFFdd+iDIg92c4VFdFX0JZLM10dkKh4m2o2VwHPWvUS3whHkb2sLRkXjTHyUFcDMYZMZGA+/hx9bOPtHGncaVMk9B8/4S3KW+/G1x/B20fRgfszun9fiWr7V4dnLNAv9j0rCeXHnpDkNGj3irAr1caBUgJ2+dgk0a4h/iz5P7woYB21qeJiSDNmo5qiXX/CjRFjnQ90rooNgLwPhUpwYmCUU8VasWyq9vuNtp9yevI1OdxMznLWqYSKOFu3Ux4aUFybIdOTruCH7fyeODSskNsPClUzoaeoLSDAoGnISMEjIf4smG5w8O/pdDTVpGdnq5Jzx8pSY8aVPh5EfCmxeJ/SzStUGGfKZ7JxPK87SJvb6BdCkrP71Hk/aICmijS+CW7BJKTUkzC4zNO5xGY+k151DQfbc5Cyzq1Bfd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

I've made a lot of changes over the last week; mostly with regard to
hwpoison handling of hugetlb memory.  Thanks to Miaohe Lin for
suggesting using the hugetlb_lock to stablise the hugetlb folio.

v3 here:
https://lore.kernel.org/linux-mm/20260714180840.3731244-1-willy@infradead.org/

Changes from v3:
 - Fix unpoisoning a hugetlb folio
 - Went back to hugetlb_hwpoison in the folio instead of having a global
   list of poisoned pages
 - Rename CONFIG_FILEMAP_LARGE_FOLIO to CONFIG_LARGE_FOLIO
 - Added missing call to mapping_set_authoritative()
 - Fixed polarity of check in mapping_set_folio_order_range()
 - Added is_ref_page_hwpoison() so we don't need to do the extra work
   of handling an unreferenced folio
 - Use the has_hwpoisoned() flag for hugetlb as well as THP
 - Added folio_set_huge_poison() so we can detect unreferenced
   hwpoisoned hugetlb folios reliably

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (12):
  memory-failure: Fix hardware poison check in unpoison_memory() again
  memory-failure: Test the page is hwpoison before taking the mutex
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  guest_memfd: Use folio_has_hwpoisoned_page()
  memory-failure: Remove raw_hwp_list_head()
  hugetlb: Use the has_hwpoisoned flag
  mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
  mm: Check individual hugetlb pages for poison
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  filemap: Add support for authoritative mappings

 fs/Kconfig                 |   2 +-
 fs/hugetlbfs/inode.c       | 123 ++++---------------------------
 include/linux/hugetlb.h    |  24 +++---
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  59 ++++++++++++---
 include/linux/pagemap.h    |  45 +++++++-----
 mm/Kconfig                 |   6 +-
 mm/filemap.c               |  51 ++++++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |  16 ++--
 mm/memory-failure.c        | 146 +++++++++++++++++++++++--------------
 mm/memory_hotplug.c        |   2 +-
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 virt/kvm/guest_memfd.c     |   2 +-
 15 files changed, 258 insertions(+), 228 deletions(-)

-- 
2.47.3


