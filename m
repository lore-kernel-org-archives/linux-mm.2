Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A38C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797866B00E9; Tue, 14 Jul 2026 14:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76ECA6B00EA; Tue, 14 Jul 2026 14:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6871A6B00EC; Tue, 14 Jul 2026 14:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42E8C6B00E9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:43:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5CA21A04C1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:43:24 +0000 (UTC)
X-FDA: 84988255128.21.F8C1B7F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15176180005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:43:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JEZDeTSb;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784054603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qqi4VdONaPzMmzSGj2FveffiuakjmYRTDGSB2OYp7I=;
	b=E9J6S5Xief5lZFVrmURl9xEuNOt+lC4WuNc2jFNPqCXPj1qJwW5M2x8M5T9+64u++1lPrN
	LBiQvNWO6cg4tZDo8T7aogl6rLZxMzuoxKtjv5EB04PbkBefaKXrHC4tK3hMtTlLpFL3HI
	SEqtftmk5LL8ORuaWE17JyI+wvMGdU4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JEZDeTSb;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784054603;
	b=m7Wy/nn4YMIEzLkD/nJiP6jb7+xW/5nwewJdwybNcol+XSIFqsm8vOsipLnnfJjnBg/5TL
	EKTaK0HpLYjw1xgOX/awSInsMMs7w81AUWZ740r0T+Fyrmv4HEp7RCgXCaUXdFft7sdbao
	j+kL4tAQLBKseg+DBo6MdqqeTw6Df7U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8qqi4VdONaPzMmzSGj2FveffiuakjmYRTDGSB2OYp7I=; b=JEZDeTSb6RduW2pmNb7i1wSbQD
	5myTIzLkzMC2f5HB7ARMHx1Ha9EvY7XPPMjvWTdwL2uA91wLyrfmsMGwSt3Jkk2rbmd3UlJJy7TR8
	y67ibPhpyJPc40ieGjH6q2iGhZLhlX3UUONb+Fsd40T9HU9ausX20zeYAgtsMLlfL6eroQkQ4C55t
	GQJsZo5inGDxZ4T4hcpNNYp7+2XCkuQ9GplCMPxHwuzvAmeqmb5Usz23cVv+cJyz3xy3MW074vOiZ
	ifwHyXxj6y68KDCx5Q3xzIjYN/d0ADKqI/06jbUo7zgYAGAONm2izXaLbdF6k30QqLYCDnpWpNw5A
	7akP/q4g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wji69-0000000FixS-3GAv;
	Tue, 14 Jul 2026 18:43:17 +0000
Date: Tue, 14 Jul 2026 19:43:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 6/9] filemap: Remove checks in
 mapping_set_folio_order_range()
Message-ID: <alaDRerpJdISdlRu@casper.infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
 <20260714180840.3731244-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714180840.3731244-7-willy@infradead.org>
X-Stat-Signature: z4gt8j4eajeeeaaeput8n4zapkata494
X-Rspamd-Queue-Id: 15176180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784054602-504667
X-HE-Meta: U2FsdGVkX1/ApELRNp038MTr+ZYnGXsDrmlFfMZGMbh4e7UntkoRsc6ejz07UMAbyRRNUwvTNYl2trMaL5fEJ5VmKQZCvdk7zCBQ8IivxHv7YabxZJuLrhfL22opqyfb5Q/w+XmJQJxnkqMIBAbVYzQyhraUy391xXVNJnnWsL+0jFmOV+PJ341MxVTECCtPjME9NKUOJiV1Ax9A1vDwxeH902fRppXCUpr/y/4wfVDhGd8zd58aIE8OHYQngHaCln55xYdlaPjNeUYZvP5Il6VzPv8Rww7j6c1r58DCf14et/+8oFys04QU4Coz2SZB/7FwkQb/txmdRaI/CZfKtoDDO30+XC16InIzau5ubPpQ6zUSeC1mpSRLPZdBerlz07pQo9MqaxUjS0i9wAm42zzK+1xpY1ssdGUDG3E9Ub9RQVYtJFV7lMn7O0pCBdKrP5mQ9D2kZdwSKQ3FFammpAimlhOn/NR6C/eqSGp4o7O3EkbVohsZMB1sUQXJ0uFLlPPxCcW0mVE8oVSlffdH9hUeUWjtg0nlN7QtcLwthT86xwN5aO0wmdl6tGZ10wfL5tvX6BwJLVtLfH3XsuJ0QRY9HXqlD3IIqOgQ7EdvKUq5s4cEz0b0Lv0Ik1tVKUgHRN55KbD2Pt6A5XI9rwovs35Q4QFFXMYT1I4L5hPT4xMY2OyZ/X+8m5EpXptVsuIB7Bub9wdGq7hdBkunGve0UtOR2sh+Ajd4LvoQ64ICzS/iU4xyWeHWpbq8LBYdhtSWz757Ka8FKYiaSFsKOj4GqRDAfe368Zj6EtDVhdo7Ngwqvd6wiZAC8ZnN8Bb45fZ+9WtB3rR0fMHhiJL6KC40nR0McM+To/yqcPt4J0AU8d2WIMWAoJTC3tgV9pD8KBxNMMNIvKlyjPS6ZTMUDPxWzXU4n1BunZwqrrwAhYsPo6RKzK/zkUw6nxRRXzDsNrNzSS/DpisTgsqEyR3YdLT
 GyfhTRi9
 AU9So7Bdz2S2P9q1FILN8sFKZ8GvyX8C7f3FCyIjxQ8yWnFuq93/g4fktDL6AAHyHYbvMW9tv1GtTbmCPyfzbzvmfTE04GYr78WTjpY1Az03CZAVt8XUfUMp9x0yNaz42SNMntVkjMvBCmzlXjka42vrR0W0W2VS2eenmEown428EGPcbFW7ESK6rp4g3HHnWR/fVaAuEUEOgvpFOLPxqfEhA0Jp0MBJwv0jc81DcIaEdJSKAgONjLcdBQG/41K4QzL2iPxy4JlG06zacFu/007QcnHzzxtzypvBihJqcVdzhKmocp4J+N8fXqz3xINDdlirM5I8LgXwdOXq4/ooZ9jNHpuFfQebjuG4USW4U1T2XV11r1oQIBvwG42HxQgcR+JmCQd0GVVapk5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:08:36PM +0100, Matthew Wilcox (Oracle) wrote:
>  static inline size_t mapping_max_folio_size_supported(void)
>  {
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +	if (IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))

oops.  This test suite I'm using clearly isn't much good.


