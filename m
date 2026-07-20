Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9435C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 01:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BC16B0088; Sun, 19 Jul 2026 21:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D4F6B008A; Sun, 19 Jul 2026 21:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164656B008C; Sun, 19 Jul 2026 21:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2B5E6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:37:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5325C120740
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:37:29 +0000 (UTC)
X-FDA: 85007442618.28.08DACB5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F49E14000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:37:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iL1j0ImQ;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784511447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmN0ofH4ZHkH9tClQTnobusWgTdM/e/XDkNzSWtRzUw=;
	b=iA6jSlRlzFxhwMnSVKshbdME7fbGLG/HoAEcShkMOczw0o8XCic3ou6XyiKdZMzbzMt1H3
	z/c6zL+jLnSaPCeThGN/u4u7Pcb+LGMjVX8jZP1+zn1gHm0O2ib3DFyhjb8mfFagpgykhe
	lOsLBBxr2Fx5dOAuQeyCK6BwmV8AbRo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iL1j0ImQ;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784511447;
	b=hfwejVCzLMLNXXbywlFzsZ/6fBwfYFU87bUrv6sxqoNxoYzECh9YN0UNENz9EAqJXicAII
	xuE8pkmkJN7XF4MdjZRP2ySXr9hH7cIBYr4n15FwS7C2ck5owNU1a1k9UKePp2IvrzBeYN
	Cipg/2GGcT4WcxXREYAf+tFZcGJZdqY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784511445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OmN0ofH4ZHkH9tClQTnobusWgTdM/e/XDkNzSWtRzUw=;
	b=iL1j0ImQxCKKUBJ/pJYTMCodAq+j4pf3xsj7zSfb2cubQR64zHi/qq77hKrPR/FZkO/uEr
	e3bDAEu+JRfa3isMG4VRtdCof2JfJvSLyAmfn9RoCGN7hPAErR06M6E+gSyTaplBPr0RGr
	Bu8fmqMrEs0lQ8ot/OeBtYVZx5xrmhw=
From: Hongfu Li <hongfu.li@linux.dev>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm/folio-compat: Drop superfluous return statements in void compat wrappers
Date: Mon, 20 Jul 2026 09:37:03 +0800
Message-ID: <20260720013703.4257-1-hongfu.li@linux.dev>
In-Reply-To: <alpmcNoufw0T2EU5@casper.infradead.org>
References: <alpmcNoufw0T2EU5@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F49E14000C
X-Stat-Signature: r6tx3uxdhk6tw8g7uh3ok9rst1nhepkw
X-HE-Tag: 1784511446-912789
X-HE-Meta: U2FsdGVkX18bIaAh2MzL4k/3Kw7mPoJ7qQExhiMiIOm3O0rG9PnB0Rp9LJuR2W9eOTTqm3DkhfWp8moVCxJ9LZvHcQNReAkEgRI9LuSPlI28Gm3K9Q81p/7f/9Qc+CuIzbGMvCVYRcYHHPWJ102doHwSZecKqQcIfRl9bFrRM4FdR5GKOCwtgcV3HFzjCCjAXLXYnbHRur9jhg8Pe9D9B+3E3/NUL8lbdMkwEgCUlAl/h5HAPtigcoiA+9Lb4ocdDOxDCqaGZonBkAdXvA8vvbXktbMP2n3GvvP4SHLCWn0jCb4Gjunif3+6E6yWPOpj9qYRANzSQ+zdS4IJLOTaLp7OYr2sNJsoKUSdxo+CMHgHS8Ph8PYiTr5b2W4bh36SCBwLkz7gJtm05YETKhUC/ibHlF8d3OyBCqn3LG5DDEO3Zl6Wz1A0mqxZvQLt3h2aOKqmianfbbIc2bi4tf19Sccv4qwNGIZaz+jeirUE5AjK1GaXtN6YTdyJmsL+lnwZPWrrhApxEwe2KBqb49SLlAbeCneRC2swql22bEm+3GfU1fRS2KM6nSiE+N82qLIQwgFrsSTn2JwmmcI1h+/23UHIQMnEs0JMPFmqeVBJVJjXr5vLlkXRFleXh9JzOk8zghyimZ/BnQJ5cQuNrjCma7l2jT5ZtbtaQugpgJGpQGIDa/mqNWy2oSgVcTUANbCUFvB3OUaGBcGkliENXd1JMQPIp8DcbCCK+sbT0YU9BsdOTj+VFdhwcnrwcaE0+kdXESO1dPNZBE5SiFdk5jZMaNVwj126IE9FVvyWi8p/ICublOXc5qswqWvvcmPcmuj0KCNR8XiGRPk8adBBncIEJ6NZPUd7XWTjCbmIS/mr80mPDGh87DPCCvHyAuv6lTyziwLQP50Bjtj5CBuK6/szZOK7l6M0/GGrHDcgUrw3xofd9idiL5tuoRGaeZTIFjBOYgsFWo03eJ2jwODqrZf
 Q/ty/O6J
 8raAUZ0wncPtrlgyjg876VQ4gMOjT/9pH0vW43arbsrSbm04QnRxAWl6UTIw6Ngq3KC6QxZyydTPVwM824hSZrd/4EeM5Ggg/SKjJOEJ7ajAJySVl5DKMlBfHgKFo5n1tr15SHOL5ejQeAq+pueRQiURXv59tqMk5io0uN/C0DfjJsRTw1RjR1wyNoj7JlmgQ8Uqk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From: Hongfu Li <lihongfu@kylinos.cn>
> > 
> > unlock_page(), end_page_writeback() and wait_on_page_writeback()
> > are void wrappers forwarding to folio-based functions which also
> > return void. Explicit return statements here are syntactically valid
> > but unnecessary, and inconsistent with other nearby compat helpers
> > such as mark_page_accessed() and set_page_writeback().
> > 
> > Drop all these superfluous return keywords.
> 
> why bother?  this file is temporary scaffolding.  if they offend you so
> much, work on removing the need for them.

Thanks a lot for your comments.

I fully agree with your point. You've already made great progress cleaning
up this temporary scaffolding. I will follow your lead and keep working
on reducing usages of these helper functions.

Best regards,
Hongfu

