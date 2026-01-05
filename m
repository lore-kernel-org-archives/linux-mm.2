Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8758EC79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3656B017C; Mon,  5 Jan 2026 11:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80B16B0184; Mon,  5 Jan 2026 11:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA026B0186; Mon,  5 Jan 2026 11:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7E696B017C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:17:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AFC216013E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:17:56 +0000 (UTC)
X-FDA: 84298416552.11.90E7A5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8468E16000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:17:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629875; a=rsa-sha256;
	cv=none;
	b=bDIuGPtxur7obXJsNKLE6c/gjlJ8Dyt7yw7i+YQf5rNH06/GsbiR247IZV4WqsbPxY003u
	lUf41UDMxilGGUNOZXOgtXS0ks9CL2pZ7TAy/uE1qB9a3o6NvyrkfffkM0pzyAxi5mLbIz
	N5AT6bIny58yI9eEqB76A9fpMAaUFSI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=e3iWm/lYsOhP8R40mxWlclaAvDaPCSkJYGINSh44ewM=;
	b=VCUnHPqTcXhKGZ3Nx3IKUu0uS2drx6x3OO7MKwL77wLUMUevGZwejCbYIsqGLRtk4CqaVK
	7h+BWioJc1/7QQzxgxPYd62yUcWUyYZlSHrgzF5QHdLzLHIUKxjvUDvMgfPdQnN8SJAQIL
	HXGChRHX9XEaPVITNDAUCNHdV3etmQM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89D63339;
	Mon,  5 Jan 2026 08:17:46 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 840A63F6A8;
	Mon,  5 Jan 2026 08:17:51 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Date: Mon,  5 Jan 2026 16:17:36 +0000
Message-ID: <20260105161741.3952456-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8468E16000B
X-Rspamd-Server: rspam04
X-Stat-Signature: yeywejfjha84fyy7snumn6odqbjj584h
X-HE-Tag: 1767629874-817852
X-HE-Meta: U2FsdGVkX1+VYNmsbEQV5UWuEoLlzkIm4QayWw0kuTICQAztK1D36aMljrPT2EPWRsmjVrA2EYeAwJncK61vigfwTpq93xcw0jZN0PvniognCIrwLWmxVN46SJPB0q2yiIFPjZnYEaA3rlcsuJHM1LGRLuV+y2yNiB+zIWXhnsL82Ux5bC6LbXCaY7DKaLkV+Lvl/whWgbqTj4i2nT4kRIQ8jlyW5xFX6OMvkeXXMHrrQgLUQwFWbjWLzsFflDaz1GfjfZS75zvqM10Pxn31/QKShEXVn9AYotnwlSOgX53WwE/E64p35ViW7+UoVluIDlbu9NAvTa9M0A+RbAqLd+7ZS7ZdGofYxTbphBm/Ee53YRS7oIUxGGEa4SSiC86opokFls3B1tKhjP+jsVX8TDIVqeYEW3EnQQ41G3fS7O3rTbaK3orphx4aec6zzWt6Qef4gQXmHJjqFzIedzp2FVS95V56Pjeobx6ucoRNkQifihVfVmF0iwl7vAbPOnoF+rdHVy9Ckps9Qvs4R74Y/E6XuhiySNaJzgHwK/gHG+GcTfosT4sMFgQeIVqIawewW/eaYPGGZWC5Z/KN8z3kFkGJ+mh7wxArAe96YW7y6dndte4AzB1KguZHZ89Q8ZjU8OfhA0kmuL8oUjsWir/7WVf1U45r1aqw+xzePJwG51E1xHh2QxLyMjDkiDvn2D91EPjj9lzo8jNo6sJ5QoqNcKan6ycfM3OXCAhZ6LEIejqQpgg89iJc2UnEgEVamvzuHJB77XschLtEfvUDsL5GSYoe9OuH5CralWkBRGKQrYw8L4rHfO9Q4ZZx8Xe8NJu6rn+IytQ3xEMQdcW4hmM6yMAhu5J3QzEzBKj85Q25TomWokwdN3+xjIVGr97IHHO5eOPiDydl3tYeZ+G2oPO7MxsgvUuo1F4PoLJ/1QjIaM5P3raxGZq+HaefFRl2te6GULg3SJNEY5+o9O7PDFt
 UQ+5Imtd
 G59zw+Iim6K967Ycdt/lKCErQvLfduNv8IcmJrgJWWC8LeIRRGJSU8dLIJV7mxqAoq/570OwelTlGNtTCE7oAmTHxTEV37uyZw788nnZDHJCy+asoToVr3TCSfCBQHukyXaR5z0ij77cHJ3LN3EhKvHBoRog4WxJAQfOT9cjl9NsgVLamv0AynJSd0X3+PGkWJ/vS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

A recent change to vmalloc caused some performance benchmark regressions (see
[1]). I'm attempting to fix that (and at the same time signficantly improve
beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.

At the same time I observed that free_contig_range() was essentially doing the
same thing as vfree() so I've fixed it there too.

I think I've convinced myself that free_pages_prepare() per order-0 page
followed by a single free_frozen_page_commit() or free_one_page() for the high
order block is safe/correct, but would be good if a page_alloc expert can
confirm!

Applies against today's mm-unstable (344d3580dacd). All mm selftests run and
pass.

Thanks,
Ryan

Ryan Roberts (2):
  mm/page_alloc: Optimize free_contig_range()
  vmalloc: Optimize vfree

 include/linux/gfp.h |   1 +
 mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
 mm/vmalloc.c        |  29 +++++++----
 3 files changed, 125 insertions(+), 21 deletions(-)

--
2.43.0


