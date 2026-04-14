Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8F0F9D0CF
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A87F6B008A; Tue, 14 Apr 2026 09:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F806B0092; Tue, 14 Apr 2026 09:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095A46B0093; Tue, 14 Apr 2026 09:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F03C56B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:18:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C2B21A03EC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:18:18 +0000 (UTC)
X-FDA: 84657215076.05.0EF399B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD5B8A0012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:18:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZWxGBwIf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776172696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSsvXqHkk+zqYvLTBPIs4fKDOVrgYcewrUX/PvzkTYc=;
	b=sbwiN/FkmlXUhm4iKvySLCbX0QRa/Pmz0WTzmiamTS3L82pdq7B1GG5kh+uvvPoUuzB8yg
	WJiiYptoE1f+Am7dhP+aNYMuCSLGwD/kBm37Tj65Ei7MVzV/G6kz9mJ/g4Wjzra4DqMP7k
	5Cy2z6jp1vTIzmjNnpm+L8nNY2Gae2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776172696; a=rsa-sha256;
	cv=none;
	b=I3ykoXh6ed/wHjizKpZK3PizPI01nufKbYp88yfT1ozS0RboGwP132vo4jynh0v4MvjGrR
	HQyn6CdSsTaTKQSBOuukEpkmipHCaZg0omjzrGrL7NY3SRTgmRuaY2hxtu8fFcLgjXPbFT
	7lzitTdxWZuHACzBSoMg3hABihwU2eY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZWxGBwIf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wSsvXqHkk+zqYvLTBPIs4fKDOVrgYcewrUX/PvzkTYc=; b=ZWxGBwIfHG9Rx/E190VMj7+GOH
	vVPNv6THSkPLrls9Shm7y7DwgcZ9+3lRIXGAwrmz+f6tL8uNKPEiIHxZDQwIdW8XW6iEKjH6NkucK
	tpBTp3JoXq1P0W2a4P31VZrMTdgFGUdo7lpNaJVFqESaDIjqTndImTGnDl4GW/0uuj0BgkiFdL4h2
	A4+rlqdr52xL82wRksIso/DPrevX1b5YFSJ32P0LJ/o6Q20JhDIwuJfyEDhAorLNhpIu0uLx9iYnV
	N1Bgf+0SaVjIP9JEjwqszb9dKJAq4HI9kOToTEgBnrgA6pp11bcAWByI651T8g/crvZSmJSdoKAIW
	233pMw2A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCdec-0000000Fbs6-2VDp;
	Tue, 14 Apr 2026 13:18:10 +0000
Date: Tue, 14 Apr 2026 14:18:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm/vmstat: simplify folio stat APIs
Message-ID: <ad4-kpPTPqOuDF_E@casper.infradead.org>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414091527.2970844-1-ye.liu@linux.dev>
X-Rspamd-Queue-Id: AD5B8A0012
X-Stat-Signature: 1iywf7ouuso38qimjmgsqt59ekbwxzcw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776172695-908942
X-HE-Meta: U2FsdGVkX19I9ku5aisJ9UZMKJFfOfT5EhLQQW/z0wzFrlnbxCY3mql7qqYYBOCo5cV9hEXBJATyuFDsYkOpfr2QPNFSDKjE9IwaISUpitCnad0IqUc1JpteTEqv67F/htgLHDWoaj+Vj3ztXC6iE322WK3gwkWGqFp3r/eozMTR/IQXxRARDVU8I4q/OZO3/gICWQY0+z3D1FUl6aBq3fHMojhnN2zib41xaPX319wnEsBCCNeY/GD1oCw+KvjtZeg+EqxCS3euujAHs7ovYZU4ntWqq+t4zl3Evfhx7VZd43FxvC2CoSB40KUCdaRgRXuN8onL8RJpADHjXPS+lSV1FOK6dmDV757idVOH0saL1zhDNlAdgGjYvImCYcx4gJaTNNPt9p5PVPYpEWYJSe4F6rssz/byiGN2kdZZjTCsXb0NaL5gUgs2YmmhglunQecPS6ws8epDO1YP0iCnuz1PFMOF+AiSaVpS8hmQ3uM1HfF3r/miAY06UL+FoYqRJ7ZAu7BLh68/XMbwYwc5cxCvQuth9f38JnIh7GiE083ctD3Y38QajP2Tz1XXEi/UGyB8rcHdBp01nbA1V99vKpV8eM7ja8Ic2IZXYLKnRQL84WN/jaCUyszxTpV7bVAGZq86i0tPklw9mXZnmF0HdacJi4gv1OQAZnQ7DZIZY0bN1vKtMUtPlRwNghDMAbFPt7JFbLrbs36qgAU9NdIJieya0UO5px5CEKuACkZWqTEFzHleYFDTk3D3wVyvSsY3G9wc1quk11cp2uMz86gftwhJ73rhOu3rI7xJfaFbpJ4XAp0N5HSR/jatJrUbRtLoxjULSJzQ/mtxqeJwUoUHsbY5rNfYjZWmGLzabJtPa4NF9hwOF5JXNRpi2pGtOyE9Vg8Xdbdi7sziXpavp9KHUpQO9vAdxmJm/bDxE325dM5nqKfhOl9VyE1Gwdpbkix/4uisBdQ1NjvN7n03oVi
 IpcF4MK4
 uKA1jEWBgfX7yQUFfrc2dwS961lOBb8JRdk7MHWJqTDb7J+psCEaO9I3kVf9mjs97WqrwjzsqY0IyLb4gJrwLuVXTPfP9Ed6L8Pnx+GmPrfkhYUoW9TnB3gdiMvVRgNt5UacwfhvKOrK3EsKC1vIS20BrskaMh8LmZX75rOkEifW2YB773X9VZqZja+YFIyt7i4XvPXmq1NHB9/jJQZatl35LhoWRQ/6xQLUEQDRjQclQjyOqRj53I31yOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:15:17PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> This series simplifies folio statistics accounting by:
> 1. Replacing node_stat_mod_folio/zone_stat_mod_folio with more semantic
>    add_folio/sub_folio functions
> 2. Removing unused __node_stat_* and __zone_stat_* wrapper functions

I'm not convinced this is the right approach.  We've often computed
folio_nr_pages() for use by several different functions, and you're
making us recompute it.

