Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528A7CD6E6C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772C98E0002; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722778E0014; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5550C8E0002; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 466248E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01DE212972
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:53 +0000 (UTC)
X-FDA: 84105754908.14.525CB7A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 910E610001D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BJSwr/hp";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042692; a=rsa-sha256;
	cv=none;
	b=F/G5UDyOpWpxJEUziskQf3Rna6Tcwl+DL2aNmZiuyhsLeEa6LvbijNZuJLqnAzilVCxNsE
	TFkIOETQ8NTnjj9Q8PBa0DtcsCFwgbhSScWvvFOgmQDZQmrhCNmUhJvewNaz1pBwmMUY+m
	estdJzbdoB/4pANHfbaMMaLX1fa8sDA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BJSwr/hp";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PIxB2SZ7rupVMd5bijQH8D2Cg4/f+arsWvrNy55hOjc=;
	b=EDXz+zgw0pQklZMxmejOBS9opX5tJ6uyiBCyIRXoSPBuENwIsbUHs1XlJfowr+uDxi9sxc
	jSIrqbSdZ7Dx0lgRL3P43JLU2Uf0kMPj4BHHGC0hSVNC77Nvu/cQj6kLaQbnxwyISM8jQN
	3nvXz0dFeSAWrPSdsC63HokBrkXfg0k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PIxB2SZ7rupVMd5bijQH8D2Cg4/f+arsWvrNy55hOjc=; b=BJSwr/hpyirqDlpW4gjaqtG/Ts
	qtMHIxl1MgyF83xHbdTafBOvVBVavqNW/qeybIIAf3VBFNOQ84OZ4dGap+G/GsmIozeMerKRTmS0j
	d+FJgpbMsez7nxa5uC4YgPLQmhcVNdizxgxulL6Z67Z8RiERTElLOj75PZBhmFBetD1PO7lnZz51q
	8+yT6r5FGKh0bCkdkkuph1htpylRfnmOYYhA7E47BiENuPmKpwWjdIRtdOuxpxDr7mKE/29mcxQIr
	9IkhFaVWuHS3NLgwJgSv+DrhzRrEhEFdX76hlUzaHYQz3buxrDbJhPy1jxhxKmgk/+2dZTfgLhZb3
	Ketb6WiA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXwQ-00000007c8B-0e1r;
	Thu, 13 Nov 2025 14:04:50 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 0/4] Convert pgtable to use frozen pages
Date: Thu, 13 Nov 2025 14:04:42 +0000
Message-ID: <20251113140448.1814860-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 910E610001D
X-Stat-Signature: yczphds56z5kih4rwq6hsbix16y3wfsf
X-HE-Tag: 1763042691-400044
X-HE-Meta: U2FsdGVkX1/otVAyJEtOPRO3z2KtbyodfTrLNOZVLuo4ftnWspQh9ozQBLts+/XPkzjN8OoR8AyfH9GrixF3JpyuVnErBWGCRGV7y3n7Njdjb6/HrMlMdIgNuHU/2nhHlK15KCRVPixl4A7g5wFxi/9mdoxhBbLePGgPYmijm2oa7r6D5PnrZ7+gNGY060n1H7AsQxjRSs54c/kCeRNqnOBOVIGIX4wW6bfr9ifXR3xsITdH8WcSFQJsb+2ZaSo0WQQxzLNurJ9gnmGlVM3oIcARmcObQv7BJ4cADdls8lPNYDhSvoFavUp/sVd7audAtUVQDLpNfplyDz1UnSDzNMamjU4q7Q9ugXpmc+rmFrJ+aAPPFBcf0EWAEPes3l4u/VaUCzge0gceE9l9JmRcvbqWzT//Ox2bM3sC7izHJ6M44oDEIm8vVFxe3Z6+wmcXTz8ImIQlQphkvkFV+x41fmMvD+BFnsaIptU8gDkJcVbHZ+vS4LJSKIdQJ0RgKsF6W4D5qVFzfcWhDeyW8viInhxUTDi55ZrFjoHytFYUgmk2rqrJYGqNlPDQweT4N8W+yJ6pZp2DLjGZ3QpOOQVCfJwb0U99UKN/VPAf46cQFcO6P+EC6+ayzWt1KmgJmjQ6K9uQK9ZAS+BqL5jFc+Q2MoUEmPU64D993ZlLARznVjsUyVlXCKhTevYRuUWBo4/I78zQRT98qiMaKSGQcmlnnN9FtziYSSz3OrxwK9Klki/HrsfFxwGYAxLobxMNW4C4gT67hcJZdprl4OnWsCV12JevcBdOAQGKjy1HFk9YcPU4/WlGx96a+oBqYCNkg10CK2vaEuSh9XhS8L4vjPYBYoR1PbQAQv7I5Wfh1W5vfC7Skh6R8zx+zb1LULbnr4WcH9fUJHvUFnPY6fKkprKroYqX/LKolDKpvmqSnMhnlWYbOmn/uO9cICdyi6Lxa4w4ilbJXZLBEtFvwei2Ams
 tYVPXO3w
 xSQWyJByMrhwi5RGcGOJlVl9hTEgHMaRfQ9L2qERsDpgTLAcZMGChIElIbUGIbEOz7PTXjDjw4JbTB76kJyHgSsCT2G1986ZUy6h7limeZpzGYKiUCo2q1kaSpziitxAO6VS1f/wsBiha8encE9m/nJJLodpzb79r3AQlFC7aU16g0vK1sLCe/bLtyxM8TS7hmKdFiSh8y1Gj386SYlKGg/lT7G+9wQPFqeHw94JVfqJiHFUQLVsVTZRDk4+GmFPW5MQ+qRScvitLwrF853ilEpmWIEx2Y5Szp61UGBlSYfiOMME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page tables do not use the refcount in struct page and have a
straightforward alloc/free model rather than get/put (even on
architectures which have multiple page tables in a single page).
That means we can use frozen pages which are slightly more efficient and
confirms that we won't need to include a refcount as part of the ptdesc
when it's separately allocated.

While I'm looking at this, simplify the constructor/destructor machinery
and remove an aliasing use of page->lru instead of ptdesc->pt_list.

Based on next-20251110.

Matthew Wilcox (Oracle) (4):
  mm: Use frozen pages for page tables
  mm: Account pagetable memory when allocated
  mm: Mark pagetable memory when allocated
  pgtable: Remove uses of page->lru

 include/linux/mm.h       | 75 ++++------------------------------------
 include/linux/mm_types.h |  1 +
 mm/memory.c              | 46 ++++++++++++++++++++++++
 mm/pgtable-generic.c     | 27 +++++++++------
 4 files changed, 70 insertions(+), 79 deletions(-)

-- 
2.47.2


