Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65264CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8556D8E000B; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718918E000A; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7C48E0009; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 361C78E0008
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDD6613B8B3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:03 +0000 (UTC)
X-FDA: 84016577526.19.C515056
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62AE5100002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UWzQbFFC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b+8hNctvdPNw0JQxbyLiciMUbQAxO3onD9sTlvcEZnM=;
	b=hjZ18AX27unJatib7CcUR2VfHTnDvWUO4f3O9Vc0j4RDgZt3mfqmOmH5Jjh4iQkQIj+TOh
	tPvGBBgygNmMXE7+CGt0FeF1y0gRi9yxtDpq+1ME0ThIYKRHDeARfwwtnSwJ4Avfl9+frM
	5zKzB/XFG6GfV+Hv385WNFdlmKAWnRg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UWzQbFFC;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919422; a=rsa-sha256;
	cv=none;
	b=H/41Kan6LJhLPFttRH3Td++urUftmCFiVZxfIjcrugKAIb7O6D+kb9cFOD1I3BvzWNFVbG
	ZXwTUoK+WEtcCq6L/+yJB3INOmFrZ1UX0uCKZ6tD1g9hYg1ZOxqCkaiR7zSQEHX/e46qKP
	qOvkU5BoeXMdJUOZr+k9FSBcmIgefBA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=b+8hNctvdPNw0JQxbyLiciMUbQAxO3onD9sTlvcEZnM=; b=UWzQbFFCl64U6jXTKNSEf0HN+5
	ydDvwv64ywhDDKVk8DFB2TMyRzeXNK/SZO0DA/kxC20XniQMIE+kA+AGWU+RUN7e/8yep/2t3yLSU
	5BDCa1NJo+/8UVjcaRIXZfKHqjeMklPkauF/B394R3Z6wlURs8pwGRG5GX9xPgAVATbMD0sJV4Ear
	77fCKP5O5SrlT8mXFQjO5c8pVkq62T68+uEer5N+ZISiKDWi0TbkPTK3nm6kjGV3UHkT/W09qJXID
	pKZjWr4kg9FAWsKmX4tQSg+0QnSrGI+pFgGZz7QeiGyOFPfU3UoXZlMkW7AaE5XEQS0TVkUV7FKHt
	X01xQZrg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda1-00000008t2K-408z;
	Mon, 20 Oct 2025 00:16:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 0/7] Separate ptdesc from struct page
Date: Mon, 20 Oct 2025 01:16:35 +0100
Message-ID: <20251020001652.2116669-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62AE5100002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5fam8oueefdpthzxa56k3iee5fqyxhm5
X-HE-Tag: 1760919422-811224
X-HE-Meta: U2FsdGVkX1/7kW8DFRO7ZLlf7oLzVD+RK4ZjV2UB4t4YseDbb6nocP5NldTAAnwTzMQqC+J8VR3w0I9dTj7Mi3o67ITSdbqP7yscGylahhYN6q7+j2TPTsRfEJ/T4Nz/LJrph1VvVcQsXLICRzClZCQvzWNeIk43MIK7XlpM2g4z7QbUrLUzpaTfqoSjPfztamF3nno6Vn/LXOeDUVVGRVAPbc4LGtbIl1wo5auu2Axjgcua1n22qfN1sNeVtGFMdCRXChIu1AIOvfOSB2xYgDFkD3/VaphPL91M2IMh1+9cZtll/lITz+pvEjZcBfQggi6B0xcq+t452DsZsF9tKbG97oCwDJlIzllWCZ2vUoWI6s0LxkwSBXtYGNyXrT2X+/l4YAfHM4pDyYfhe8mJeSXzRsyxkjLoN82m0e3GV91rTnp8y2MMGwzGDpCxhDoxQA79n1YWlOf6IoKXhno7B5VEuVV4mFPgBPKEhMN0oFtxdvAdObw2uD7zu1yafCxKDy0Q1U0mdN491XRiy889UOdXaTrbGY1sHVHao0fwmfBaBQyCa/nSzXOd3SKTpx0/+5bobjcqLwDwznuYsNvSI5JUdXHkcD/SkeT0T29ejXTNUxggsM1qCgPYiaigBhKDVUyUwQI+24Dm4IZVsYR4w1hBwzxk+OJ77Jdp2HO2qq2+ZRy2B58bYWTTBpqdBYg7IVO0mw7adPnVIAMjdaS8DexS1+aiCY5d9LDLvz3GZ/BVjFX1q/2DQwjJFLiAWEYm7WO94fQfO4zlJuRv9WVv4OnM7xV+aKek6q8pe0C/vlh6IeZ2E+P4fT1h3d1eU7Of8TQkeFOq/QBAUAdR1jak/hpxhZJKowltxjgF9H3xNurq/Xi5jjikCDLGQuj7/QyShaTx0Sye6qRch9jOIWrVuvNpHFjAWelQw1ZdEMJ33qRjcpOdWj+NL47ZHz6dRdaVABl7dwDWcJrlZ8+BDk5
 GFNufxJD
 dj9qf0FiP0On18vukwQs/YwzwBs3HMgCw3nXUMHIfeYVO3h5vjD82DTVdK68uAFZqIi98g3vodPK5SOFwCGCHN2qSbNolyQ2GH1hqFShXE9YmXybkiDs/bg9RgT8NctfSpzaMWKa1pvBIQUPbURTPPIB2OWtas3HVAo9xMuSEZ5iCZBmCQXvFXrFTeExUcoiI6UMA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With one specific configuration on x86-64 this boots and runs the fstests
testsuite until it crashes in generic/108 while trying to load a module.
Obviously this isn't fit for upstreaming yet (although the first four
or five might be worth it now).  I'm sending this out to demonstrate
(a) that Progress Is Being Made towards shrinking struct page and (b)
one potential implementation of alloc_pages_memdesc().

We can build on this further; I have a patch to eliminate the
separately-allocated ptl, since there's no longer a reason to keep struct
ptdesc within the sizeof(struct page).  I'm not sending it as part of
this batch to keep the patch review workload down.

While working on this, I've started to suspect that (when not pointing
to a fraction of a page), pgtable_t should point to a ptdesc and not a
struct page.  That's a change that's somewhat independent of this series,
and could go before or after.

Obviously there's a certain cost and very little benefit to applying
this patch series.  We probably need to do all the memdescs at once.
I'm going to move onto doing slab next (slab is particularly tricky
because there's a mutual recursion between needing to allocate a struct
slab for a struct page for a struct slab for a ...).  I know how to do
it, it just needs to be written down.

There's a certain amount of debugging code mixed in here (in the
later patches).  For example, we store a copy of the ptdesc pointer in
page->__folio_index, which lets me see when page->lru has overwritten
page->memdesc.  For example, the next crash to track down is:

memdesc dead000000000122 index ffff888119a59420
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888119a59420 pfn:0x124cce
flags: 0x8000000000000000(zone=2)
raw: 8000000000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff888119a59420 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(1)

so page->lru.prev is LIST_POISON, while page->__folio_index is plausibly
a pointer to a struct ptdesc.  In case anybody knows off the top of
their head what's going on, it's:

RIP: 0010:collapse_large_pages.cold+0x45/0x49
Call Trace:
 <TASK>
 cpa_flush+0x1de/0x310
 change_page_attr_set_clr+0x10e/0x160
 set_memory_rox+0x46/0x50
 execmem_restore_rox+0x1d/0x30
 module_enable_text_rox+0x6d/0xb0
 load_module+0x17de/0x22a0
 init_module_from_file+0x8a/0xb0

I don't immediately see where page->lru is being used, but maybe after
I've had a good sleep, it'll come to me.

Matthew Wilcox (Oracle) (7):
  mm: Use frozen pages for page tables
  mm: Account pagetable memory when allocated
  mm: Mark pagetable memory when allocated
  pgtable: Remove uses of page->lru
  x86: Call preallocate_vmalloc_pages() later
  mm: Add alloc_pages_memdesc family of APIs
  mm: Allocate ptdesc from slab

 arch/x86/mm/init_64.c    |  4 +-
 include/linux/gfp.h      | 13 ++++++
 include/linux/mm.h       | 88 ++++++++++++++++------------------------
 include/linux/mm_types.h | 75 +++++++++++++---------------------
 mm/internal.h            | 14 +++++--
 mm/memory.c              | 67 ++++++++++++++++++++++++++++++
 mm/mempolicy.c           | 28 +++++++------
 mm/mm_init.c             |  1 +
 mm/page_alloc.c          | 12 ++++--
 mm/pgtable-generic.c     | 24 +++++++----
 mm/vmalloc.c             |  2 +
 11 files changed, 198 insertions(+), 130 deletions(-)

-- 
2.47.2

