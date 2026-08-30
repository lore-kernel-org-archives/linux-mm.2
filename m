Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B280EC61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 12:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56FF86B0088; Sun, 30 Aug 2026 08:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520736B008A; Sun, 30 Aug 2026 08:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436856B008C; Sun, 30 Aug 2026 08:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 234D16B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:40:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 844CB1202ED
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:40:31 +0000 (UTC)
X-FDA: 85157894262.20.1FF1297
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5186D40003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:40:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vi16hdNt;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788093630;
	b=Wh9rpPJKz1FN8cyGDQpzH7TJAcbEUM3pquIkFk9uVNBtMVZdJEXfqntt7LuGa/pe6bRT7O
	z+i4yrRqC1XZSqEjMi7fvDntNUGY17xV3VIPUHoYLK/hEfncSImub1J4wxJxjO2YntjOrc
	ZAzRP1ObLEOpQrgCTcr9C+wfEEz/dGA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vi16hdNt;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788093630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2Yu37RyGHuTKU6LsWqjv/TrIzDjNCcF8SRXvGzqih4=;
	b=sI9ePO99FTa+AofTJZr2y5eER8NXEr3uhXdDfFhHPRehEZuEwZ6/OpXRxjHQCc3rmRWYM8
	9k2+Ivc1Ob8EHEuHbMjqVJSCONP+HnyYQ99rvIAkyy1+ZeP3CeNzooViNxmCYjtsEuf15T
	vjZYTSzSPbvotdrUHnZu1gpvJhcDa0g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w2Yu37RyGHuTKU6LsWqjv/TrIzDjNCcF8SRXvGzqih4=; b=vi16hdNtyhciZcatyDKz3kgJy5
	J+WeKhMezb5Mt6ZiVsesV0t1vOTXKwUlQLOpI6X+1YqOQmFQKxWPjb00+rQBWKg6TQt//WfDabH0q
	GMvIrCLU3AZ3zOku2lPW9zwcccZAC7a/BVmo7wfMCae2+g3fOirlK3Auoor5CJRxWHUfthMht4AbA
	YPOh79MZLOSjAuDsq/cxjzBQMD8A2KSlYPdF7RhmVqPMsU/KinIFEGhVd3HYiH0A6xIgVd7S5dUfo
	pNfhUgBGgu4Z3CW+NoDoK02aZponE9o2wgNhkDNk+xNr1X4TAIGrBSyamNbnKNBRz1oKNomhZkQoH
	CQCCDpkg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0epe-00000000zXY-0Jv4;
	Sun, 30 Aug 2026 12:40:18 +0000
Date: Sun, 30 Aug 2026 13:40:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	axboe@kernel.dk, trond.myklebust@hammerspace.com,
	tz2294@columbia.edu, chao@kernel.org, qiwenjie@xiaomi.com
Subject: Re: [PATCH] mm: filemap: skip dropbehind folios during fault-around
Message-ID: <apQksVlTvJY_0aTi@casper.infradead.org>
References: <4a4ac0b4accb50641f504f205663435047c4b26e.1788086386.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a4ac0b4accb50641f504f205663435047c4b26e.1788086386.git.qiwenjie@xiaomi.com>
X-Rspam-User: 
X-Stat-Signature: 89fpo4s64r6ishp61wowku6z9d5q76te
X-Rspamd-Queue-Id: 5186D40003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788093629-40462
X-HE-Meta: U2FsdGVkX1+yi78zZo93M1rUMSR+aOvEHli+cKg1D7IgUMHa1nAhCQ0yML4YP5uXPVwoR5+yyT4YB40w/7WWDVU/VLEa7p0RcoGRXdUBaTMtkJwaP2n8UOJXGQJWJ8Cw5JUhND25DFsqTjbZQcrz21O82aG0hBT3AZbmVPQqkvmqJcx1rnSQF1KR53Py1m/7RyafhxTp0O7AOq1N9QyjaFCXPTPyeypsqCLguD9A5oAGfQDy6RpfkiwGXdNP/1Z/jRx55cjdVmWBQl/c213fFC8vzHuKd9CYUKhW1lUpjk46GYvs36N3KaliPXGSp/xUD68/BdMFDnQ9+5mB9HfalQMv3N+SK3ysnHRLJ9hmpEzr/lWgt/11bSjiZepPs+2CI4eKkC0hhV4idmdVpjxWKOJ5JpOLgLeicDzP1RqDDYBj/OAa7Qddp/+HLJRE/rvkDG9hYH7LDrCnEBtoXVtd586EzF3FvBL2U9Jw7ztb9dB8S0nltrHwt3zWDDx5J6/Es/vwhX88nAxOAlVCYsNp3kPLNlX/a0fPfr/ZyZfBZw/4kzjuwoTcQEE3ER42jSMjrLU7dtWab3yiDGi0cxlzsRWt1cOShcIf6cPOO8htVC/O9Qv1sdFHCAAeyfE/hLxzgXdP6aTaN5yRLR1jmxdgaQpVgHAcQEi6pHLUSFVvlXwyZ/Mwy2jpt1I7Q0D+7PPHEZqpaRx01GNze55zBvWoR7H2HTzyaJC98SN3RIzIkSZNYTpkpDXW8ABi/q5/FpCfTyyuusr5Mie7WrIo3BTdfJIqOspX8s2Cu7HRE7ahFh9K8fH/YLmRqWFCDig9AwPD3gFIGA4AZyygFWtBb7ggG+LdAIw6xcfIJM28gTU9IuNzV3q68zj3t89ulPsy//YiJ2jM+BZH5GJ+m95NZyHQ4i4pDkd6e32s6w/lkDrtKUG7b5xNSHnSpoNTjs01WY9l4HOlqm4iBGRmRKFp+Ea
 lVhn1yps
 WPlom64aWFU+ih9b3v/07kVO6wQsXtdBRDSf/GCDi/QqF36iEw3dh4ZijL9fDCrDmapOS9SJf8prKRjs8ugP5jeUZAseQkv1NIks1Cnn5uf/4HNopW5/1fKbW41tIEErJ2JV1GKvEgtaUrcvZfPmL23wvMaLBRU+lb1Exsm+2+KBLIdtuIMj6vIWdvNoNTsPhGGcfBazze5MLPMK/ooMER2j36qg/Ws95Fo+VhTMY3JVXmtVeQRgTgZMMYKcbfXhI9dksU0AccIbgB6hzXR9tDFhNCgoHKkrUaHhSEJwxs0a00Y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 07:48:45PM +0800, Wenjie Qi wrote:
> From: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> filemap_map_pages() maps uptodate folios speculatively without going
> through the normal filemap lookup that clears dropbehind. As a result,
> a neighboring dropbehind folio can acquire a PTE and the mapped-folio
> completion guard will retain it even if that PTE is never accessed.
> 
> Skip still-dropbehind folios in next_uptodate_folio(). If the skipped
> folio covers the fault address, do_read_fault() falls back to
> filemap_fault(), where the normal lookup clears dropbehind and updates
> WB_DONTCACHE_DIRTY accounting before mapping it. Speculative neighbors
> remain unmapped and can be discarded when I/O completes. Normal folios
> continue to use fault-around.
> 
> Dropbehind is folio-wide, so a fault into any subpage retains the whole
> large folio through the normal fault path.

I don't think we should do this.  Even if a folio is brought in through
fault-around, it still indicates some conflict between dropbehind and
another user, which indicates that the dropbehind hint was wrong.

