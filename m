Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D4AC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53AE16B008A; Fri, 24 Jul 2026 08:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC456B0092; Fri, 24 Jul 2026 08:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD936B0095; Fri, 24 Jul 2026 08:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1426E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:45:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 921C9160257
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:45:21 +0000 (UTC)
X-FDA: 85023640842.17.CFADEC5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06BA4C000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:45:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EQbMwHMm;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784897120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9FkAcADkptXK+VYSYgJmUWhT49FWNMBvgdLcEYJFEQ=;
	b=FPWQwfuYn9/MG1WFhdBIl0xIwumxzaALuNX7LULK622uVJkwRfdF3NwNN2LArOLViWfXA4
	52WicMEm8WCuYwLOrgi35wpfGZ7RVtYBDBsFZ544EBur2WoIT76xPDx2hBCgy7w0jpSBXB
	t5Y14J7NkD36DFM7q0HzZWCiFVtiQZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784897120;
	b=t0gIqpvZZB8KYHFpYI2dx6d7xp+uf4lHDa1gSVUGNaqzAXlQjK0v+WvCQuTiaaoMMhP6wh
	M9ZnWXnA3F9Nh3fVX/0arT8DwLdQY+U/fsCZG3B2wGE4Yz4XcBl5FYTGwR5VRcKzHG/VWf
	Qf9BLLJlv6R1xjX9NjKqpW90W4qO6tc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EQbMwHMm;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j9FkAcADkptXK+VYSYgJmUWhT49FWNMBvgdLcEYJFEQ=; b=EQbMwHMmdEgoJejfBOjo5/eBam
	BeGPIsGcmG0o5+55Cijdo3TqLPTRIheMAGLBE1SMtL3EX4Ty0CKncjXA0cFitvvcWdPZUsSiH3HQF
	6lQ+4Ntj1NGoHsO1mOpxP+sH5utY3bsCCY3chdh1++oTR3zaRFv+5GJ8+vWa7AL67VzhqefszSYeD
	HJcknILtoF7sqmoJNg2C+kKE5HrEM+jPn7u0OWUPf/LKDzFGjM1PAeqSUEbHxhfdKLytfX/lupTW4
	ey1xWR/d7ZhE4CVg8smK8uFtlyG6Hw/AwV9eABxbiE22OQMTSiNps8WcaFuCzuSklrqqT8acRrvwt
	aLSLnXcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFHC-00000003U26-3PQK;
	Fri, 24 Jul 2026 12:45:18 +0000
Date: Fri, 24 Jul 2026 13:45:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 06/14] memory-failure: Remove raw_hwp_list_head()
Message-ID: <amNeXtnxn0yV6-Gw@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-7-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06BA4C000E
X-Stat-Signature: qgf6ue4xzojzm553h788w5c1ewwnw75y
X-Rspam-User: 
X-HE-Tag: 1784897119-942834
X-HE-Meta: U2FsdGVkX1+QRpMqGVGiH9ZhFzoRQM9pi5RyY2KHtK3HV94JgiEPrigPE8+L9vnxK8Fqv9E/Uy/EqfLpI19WBcXuOHjZnQbQIKowf704J15bZH/Jo+YORV+jlSBaSNt89bARqPS32dULYnNwgZ95aeYbu05wKpzWquj3EyZFa0eVH3hgIEaBiaPB5mttusBzQh+ppfSN5khY6eAni+P9ziUVUticx4tDa150N5oFhgDw59MgNj9SaKJAqbC+thzd/ZLuOmZS4OIiOovPc6z0/7lAqc8+LGkuGYewZ7f7ZMyVPS6L9JwGL88RnWhfq+2yqCTf3szyHmqYTxd5SlOoYS2/vO0xxt+M0r5OZ0OPQ2dKPoV5onNhv9gBWxNfVpqnwg9VjS83fJYLcOsxM+TEfXpBsSbnwBGH3gUWfW9awgVICG+6JK6q57K6H5KAqvmf5n39BAGffQLTL1Lo7Z9RljYIZw1HcluUmud7ehjaJwHIMpnTgsgsbGFymHk21jAfpLfJqZR0/S9ejiON2dlrl9HBIP/NIghgxqMzSpXwp0eDcSVGZh3BSlfh/IlLsjiWYfJwCPT1KCTzJodfy2yKjOok8mb+WoY7iFcJdsBqQ43wWFR4WQ46znIvO8ITaU/wLruNYyzVv8ZuCJ2iwBqbLn3qz4ggXVgk4c9eERnnO+KwlfOHT/g+PR8BNbCSqHlso4A9YSe8+nv56UDxxzFXKc4AERf/G4Na8j4rQH3inwcbIS4/vGo226JyPJmzMyTJqvv9VR+5Y6mOYk1yAAJVIuqDEMubRQhJSEHsa/MOr3iJutnxxA0SZezU+1CTR0H1ehNEuwPcemo8Qbgs37hXmEo07D4jrvDdUzGac6c+2GeDEC/mbEYX76Nk5e/p7BjsK7AwtgTh+gmwBn3/mf+zrOvGA18NSrBt2ruT6fiVqgbnV36K6dlwyeuc83xfVg5SFL8FmxArsWf1sy45HAS
 Qyf7rlya
 4fplAl3+HUssNJjKv7FY1q2dh9YyDPnpRZ14AeyQ4+/OqYqizhr5R29IsQX+jfVoaM4iwEDZQOSqDEvKKft2Gq65CoDBxKwKoTSdLE1UGhUqCaE/qzXUjLEKWTX1oig8S6E3AzPKa+XAKkmQGHNxDqvLbVjJNe6UzGJwgMOpHyIQ95ekqR/P1r0WhdANvpPkk4KOJAOl1YhU4qsYVei/4x6vBmcUFUZ3j96auwU2ka3rHQHQKjjjmL0HYDYvxKAEmN1TgSrDJYFxilkjh3wdL/MVfRQjbR342MpC8kHpNbHIhZYEpfagbXMDKAQat29w2PMHj87i3O7/HnvgrHKMI9Xqd/1xVejJcZghSUDceAVOHFnlS+ycbqy52+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:30:23PM +0100, Matthew Wilcox (Oracle) wrote:
> There's no need to hide the llist_head; we can just declare it
> directly in struct folio and do away with raw_hwp_list_head().

Sashiko finds no issues with this patch.

