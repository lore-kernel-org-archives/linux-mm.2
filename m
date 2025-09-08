Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E0ACAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193618E0003; Mon,  8 Sep 2025 13:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1448D8E0001; Mon,  8 Sep 2025 13:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059908E0003; Mon,  8 Sep 2025 13:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E87BE8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8310257724
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:10 +0000 (UTC)
X-FDA: 83866723500.16.A6C5871
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id B889E40004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hEI6doTI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757351469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AMBALsFXBxH7Yb05WV9VMbArEwMWS1O5ly7A/Ho6eGI=;
	b=kPLZtUa/Ez+GEnAnilfTSpVPOmtDEHa0yUGy6NHeM8ojzRb9Bz0loLF0ZNIMgOlWtOyXtE
	CtAME53NmNQs0wW4WYJMVL3HVnTFg6RwUkzHJqX+9g9+fmRRoQ5w1XKPJjeASsKg+YKRzL
	DF/cr79YOdzWhpvDo88IOl/oCc9tqFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757351469; a=rsa-sha256;
	cv=none;
	b=ninbn4Jpzh6aE+TVBed4vyxKhdCGFzd/kRl1OeE6j5+TmzY76C17LsKJjmRjgHrdeIuWDP
	BLwebVUAIlRPzpu3UxqFn3e1YmiHgX3Hoa+iJAeyGdJ6i4staBFjMVZd07tJZqZRehK6TC
	lMxFf09HsPYzRz43/VQrO+XHG5x+dYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hEI6doTI;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=AMBALsFXBxH7Yb05WV9VMbArEwMWS1O5ly7A/Ho6eGI=; b=hEI6doTIvxCCjw4849JO+4cnoN
	3IQTgpn95mETFYkQpT/SWJVbz+jgt4jzekYgIgselpXtoAS6CTDyg+22Y4YHr2nuIIvGCjAR1mwFB
	atWOe5MUHAsi1Ip62JUTA+lRTKWjdIoh9Vo01wLr64m7exq1O0UjEuSwQ4tuNKiUr/XxoLpAMqyGD
	mzN1Gw4N6LAKVN4AmjvRMm4vuU6MaMPcHE/odNdKu/WdNIxOlWcCXjogFE0RREqGh0MfZ9vHcDLmO
	yEYlTZ4/Vm/clydlEB0qjySAth7FS/wO7R7Jv7ICzaoKHabBn62gb7MSjW2iBrPKYUA2KNAk+2MNp
	ejZrkhog==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvfOU-0000000A6pJ-2R0p;
	Mon, 08 Sep 2025 17:11:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 0/3] Some ptdesc cleanups
Date: Mon,  8 Sep 2025 18:10:59 +0100
Message-ID: <20250908171104.2409217-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B889E40004
X-Stat-Signature: qix18y6osbdwiz3teh5r93ot4mp5py3t
X-Rspam-User: 
X-HE-Tag: 1757351468-95254
X-HE-Meta: U2FsdGVkX1/TGuuCtsCLxPLmm7qx406hQqNL3k09bUIuzHKHHkH5AIATihES/hHR+oYoC4osoNE8sYZHKsx5rDhlqDAQavNlMENQ6gT1ThDdzuMAbJWkdO0SlS7OG4Czub9AMIwh5Tn28e3+/I/+X2dJswOPwdNm5WY+Kj4UEvjXhRFbEB4M7ydSuCPAYNcFMz2YD0uphcH8qBKpMKkOwPPLu0OmcOIoc0HJj77ni1pKG6pjrlhHcShjDQt0ou19DZSxRVWHbLL/waWGyUJhX1JKiDLh/OIG2U+o5muEqBR66D+pvXW1KLcZNrZy2LjRgm55MspKqUb1ugwtqDitFQAgFz0tMCnnKQ67DtIN/gGtcpqp6bTcLq1ud1QiE/AtkeFLU8Q80eGJ0fmrUOwM6ALulPnCF+DVKZUPwwWyCf5jV42V/JskeaK5Nz+VmjOG/o9mjuLLXrZTCZMV511Y+tOveUy1Co5myr2vdFPj0ji3bWU5786wnCwJqnWOKK/TavwRZDbbxIB7XTCJVW/iCHggP+0+zuEOirqWelGhppLEC1wfNzTBbpbVzmU8LEgvs/pyumQbjpx3MhJcHV91p/UWXWz8sUYQlqMPDfJQ6m83FnDqOcFUYGzjOmfL1g8/YxJfI0Lz55l5PslHW1h5wy/PTehS3easu43HRCBXx/20QYMT/1URLWtdN9kZHhj5UWuk2ptZL1nWal9zjZpxK4lR49BJdfHqyLnT8ZLXKOAGSa4oMcNrWxzhBSmZEB38JESH8gyvjT1dJUQExToEoVrAPTO9e/I84CAbffXhR6p1yOLOWNcazcjIRw8F/9Nx/vqfIbHGxtNc89bFU82A8aIdT3lRHlFj/Jm5JK4TOsla8DIA1661JiX0ydDwom6raEJPjsX3UP16tRQu5zIhcanuiGodvgXV8my5v8eYydSxoljT33KVuYG+tIzSLG+rYBjrTn68hur8g5k+yQb
 pDQx9VGY
 FJoZ9QX/uwJfZSQtqxIcM0CkO+565vo8RIlipze7Rh6zdUAR/Hd0UAdqfuhp3XQe/mgp8Hyw/ZR89+r8As0DkVlmkQNqkdD2SfDw1di9hD8ZYO5jJen8AQPu5ZWpAKdRukVdX8kxlvCfQto9uF6f2kcnkhXzhPLHXY66qGeWEksV1jCy3yIThB4marmMZ4RbWIymo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first two patches here are preparation for splitting struct ptdesc
from struct page and struct folio.  I think their only dependency is on
the memdesc_flags_t patches from August which is in mm-new.  The third
patch is just something I noticed while working on the code.

Matthew Wilcox (Oracle) (3):
  ptdesc: Convert __page_flags to pt_flags
  ptdesc: Remove references to folios from __pagetable_ctor() and
    pagetable_dtor()
  ptdesc: Remove ptdesc_to_virt()

 arch/arm/mm/mmu.c        |  2 +-
 arch/s390/mm/pgalloc.c   |  6 +++---
 include/linux/mm.h       | 39 +++++++++++++++++++++++++--------------
 include/linux/mm_types.h |  6 +++---
 4 files changed, 32 insertions(+), 21 deletions(-)

-- 
2.47.2


