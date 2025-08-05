Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B829C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5316B00B7; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093AA6B00B6; Tue,  5 Aug 2025 13:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA40C6B00B3; Tue,  5 Aug 2025 13:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D44CF6B00B3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98B7C1401CC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:13 +0000 (UTC)
X-FDA: 83743374666.06.42DE5BB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B03F1C000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pAOxT8HI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V0SLO9tJ4xHjOMrFsWA1jGa+Y36uZMJ3OAAP5LTBBGA=;
	b=7i+EXzPRCCcWjgT6Ansj3aY8cxhlbDCIsyfwH8cYxlLa4Pq0vFoBRP9LGOYMDiIzEVad56
	+ps4EWoRh5i6ulsDGuEFtVTRGLy0QQSUxfoIS+5TRyrzlTc97pO4VUGmrlTkCyf+1trQGf
	8Zit7n9QmPr2+rCvPVsJMsxVfEeJiUc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pAOxT8HI;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414592; a=rsa-sha256;
	cv=none;
	b=itlGTFJms6rTdwDyDZSHNqq18toG8k4N9+8eEHijE47lXsPlN/A25/CAEnfOqhaEAAzBPp
	sOrsgUkpHFPJ2hP/xFVKJCRaSBtFTA5QnUtw8VOXqB1joCPnc9u6VXnYZx3ozwdWLIV65X
	8iwEBkoBOK4dlYzWp+iJnlqgCA7QOiY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=V0SLO9tJ4xHjOMrFsWA1jGa+Y36uZMJ3OAAP5LTBBGA=; b=pAOxT8HIJWH317JqG17wRDHURl
	JwBuXevaHHoDzxZKtfF8e5v8F2iUPzFbktC9rXY2rZW1jFjKmIdfxTf/3/7c8dGrmweHVN28RB1eW
	om5nUFepba0w1qg0iRuVmg9vSM3AsDiRqRF+f0+fA0ivwmhj7xI2MWqsoO5Rd5B4vlKEic3G9R84V
	egXcHzvOXnY4klJwvTtNzsnQwhRkD6kUKler8PL49UllXRltArfcknb0UDmOnF+fi32nVsMaVv5AK
	UwKvQooN2fjOSf3Jnty6/hRP8bi5CaXBxqFuYtNbh8F/V/jh0t529WxUndLQm3OZmLHYV2h+giE+o
	CIc+wHJw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNV-00000005T4L-29YE;
	Tue, 05 Aug 2025 17:23:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 00/11] Add and use memdesc_flags_t
Date: Tue,  5 Aug 2025 18:22:50 +0100
Message-ID: <20250805172307.1302730-1-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B03F1C000C
X-Rspamd-Server: rspam06
X-Stat-Signature: z1qa73ko36ga91nj5owwaa11o331gewo
X-HE-Tag: 1754414591-276628
X-HE-Meta: U2FsdGVkX1/uUqT6zLZ76nqCDrkwknDmU4Mlxcmai/ZZWVxo5SftUEg0JutAnujvuNvNohvklHtLH2hdzwNVcvdejslQCaNEDTp1MhxFbsvm9jHt3nvKVplpS70bN+p7pB/uDNMiCf+XGJC8/8/3STFkUwpziV3LJEEd0ZdtldknCrznZ2vK6pkCvtt43MX5AT6aIxpVcbYBi4xIyoW+fopTEsrq32+04h2pFVcykYacXyWU9NF+5CHiOyNBV6xYpOKfVDCaqmiK3JnDgQsmXZpvV0YlwjYsXFJPVMuEYT7ubrmivqpmU6zUN7Gz+dpg/CLHyYsSFbNoiyzSlz5teZ7PPihpZFYmtKtOrFv1I0VbQEtPDamie8U0zC0rvAdWDWCTgBSbOShtCstshr6tidA6F9TZUjLIGqB/qAQQEi8iHoxbMapbqOL+mhnCAuGbWI/suo/SO/quRtZz8bvWbfbbaITJ5Oi2RCv7s0yhnOLsBHBFQx1S6PCrjtjLltpC/FRgddyGW3NLX3xZNNbSUpLzUYJcP1vzusfMqDlvNVN1fI9gSWy1o0sZL/HSkxNx9Ikdx8scCXZisNyTpe5Cgswfxg4ysafhrJ3OV0T5RiP/x0iX1d9NZEeh6Syx+H0cfFXx6DABPD5U5yWgzc7jzEUfEcIRB4d3ErRYwK+dcZHI1NcWoGjZZYICiIG7CS45U0/GF2vx06fQhpjKSd6bP7UMBR1SOWD927u+3cvU+hC+BpDX5qE5nm6T4FschYCQvAKjIf0Pe9F9uar6v4893QI2nRekro4yzlOgGf3ouwggssDouq/1ORVE/9mMFW8PnnDYDlV34/vaPfivZeMUMpgiiOTWR2aj3BKDQZJt5OfZd5OiLWvy+Fxpp5AedreDB72bOq/Hf8995dT2dY46qu+LBgsR3huoQBO4PYm6luwOszi4FPEwQD7a9qRz61D6N4aQ44sqG+MTifwxYgE
 ghbMfD2Q
 oOOZnXknHV3oBW7eHQJ8NiS6/TntyEWV0p4wR26KtB6KZXzmHzGDA2+YCJG4l1GHivX1cK3T/NTw7U7NOnZUxL1ja455EJ7SHsHpkby/agceUXPATfH2iueG7FpnhFslUtE0FrwkvBj6xwfbT4m2Wr0iYXtHz2WkH34epa7gOfLNkKpv5jbNWRtgWNl13sn0cnhwgorLtoEvFSqGltn+G3lCfhqkZ2udRJxAAkRDTPSq/GoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At some point struct page will be separated from struct slab and struct
folio.  This is a step towards that by introducing a type for the 'flags'
word of all three structures.  This gives us a certain amount of type
safety by establishing that some of these unsigned longs are different
from other unsigned longs in that they contain things like node ID,
section number and zone number in the upper bits.  That lets us have
functions that can be easily called by anyone who has a slab, folio or
page (but not easily by anyone else) to get the node or zone.

There's going to be some unusual merge problems with this as some odd
bits of the kernel decide they want to print out the flags value or
something similar by writing page->flags and now they'll need to write
page->flags.f instead.  That's most of the churn here.  Maybe we should
be removing these things from the debug output?

The build bots have had since Friday to chew on this as I pushed it
to git://git.infradead.org/users/willy/pagecache.git folio-page-split

Matthew Wilcox (Oracle) (11):
  mm: Introduce memdesc_flags_t
  mm: Convert page_to_section() to memdesc_section()
  mm: Introduce memdesc_nid()
  mm: Introduce memdesc_zonenum()
  slab: Use memdesc_flags_t
  slab: Use memdesc_nid()
  mm: Introduce memdesc_is_zone_device()
  mm: Reimplement folio_is_device_private()
  mm: Reimplement folio_is_device_coherent()
  mm: Reimplement folio_is_fsdax()
  mm: Add folio_is_pci_p2pdma()

 arch/x86/mm/pat/memtype.c          |  6 ++--
 fs/fuse/dev.c                      |  2 +-
 fs/gfs2/glops.c                    |  2 +-
 fs/jffs2/file.c                    |  4 +--
 fs/nilfs2/page.c                   |  2 +-
 fs/proc/page.c                     |  4 +--
 fs/ubifs/file.c                    |  6 ++--
 include/asm-generic/memory_model.h |  2 +-
 include/linux/memremap.h           | 39 +++++++++++++---------
 include/linux/mm.h                 | 53 ++++++++++++++++--------------
 include/linux/mm_inline.h          | 12 +++----
 include/linux/mm_types.h           |  8 +++--
 include/linux/mmzone.h             | 30 +++++++++++------
 include/linux/page-flags.h         | 40 +++++++++++-----------
 include/linux/pgalloc_tag.h        |  7 ++--
 include/trace/events/page_ref.h    |  4 +--
 mm/filemap.c                       |  8 ++---
 mm/gup.c                           |  2 +-
 mm/huge_memory.c                   |  4 +--
 mm/memory-failure.c                | 12 +++----
 mm/mmzone.c                        |  4 +--
 mm/page_alloc.c                    | 12 +++----
 mm/slab.h                          |  6 ++--
 mm/slub.c                          | 18 +++++-----
 mm/sparse.c                        |  6 ++--
 mm/swap.c                          |  8 ++---
 mm/vmscan.c                        | 18 +++++-----
 mm/workingset.c                    |  2 +-
 28 files changed, 174 insertions(+), 147 deletions(-)

-- 
2.47.2


