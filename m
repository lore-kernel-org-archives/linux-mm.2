Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2742BD5B16C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCF06B000C; Mon, 15 Dec 2025 09:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D37F6B000D; Mon, 15 Dec 2025 09:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810CC6B000E; Mon, 15 Dec 2025 09:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71C196B000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CEB688AF0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:22:29 +0000 (UTC)
X-FDA: 84221920818.26.30E5F52
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FB4B140019
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:22:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ij+j2+CX;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808547; a=rsa-sha256;
	cv=none;
	b=UP7xaHl/nNJVMMqKV4UWhDQZtEeKWRpA1AzlLhrh7tGW1/VXZdbYcLl+1wS8RqAxSb3HuR
	DqFAqBVU0HgrY08PhMT9WL+n6UyB0nd+Q1M7gUofFzy9KYNOHafHncGDSElXh0fPlpl6or
	zCykUgqhb/iORz4+oqgjxKcJ6kamp3M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ij+j2+CX;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JOCBskt1hE4p1n7Rzhx9tz8mseOjMeyQqwwc4c8jDg=;
	b=fsP5yMiHSuJA4f3F0sSSWNyU54ljN7VkdDy0ZXUlRGRPBODuOLULM1tU+2whr6N9BkXxeC
	Delgvlg8blI8CGy3NRYGVg6/pwQq2uo7E/yCXb9eKzJZ4uVtUi2xPEYhRTcOH38EEIbpPG
	J+vf2iN5mAvRk8u9gp14hjN3T088vw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1JOCBskt1hE4p1n7Rzhx9tz8mseOjMeyQqwwc4c8jDg=; b=ij+j2+CXlr1c+DXVR9pSCkJk09
	V3GJwrBK4pYYUPbnk0uEm0nSd4IvyUF8cLyfxNhQY5ZizJxNxRUXU5DyewzqCdbAeDx6cpAvzBPnV
	HghkM3vySMVL5SEwDYsbuTnF7C7RcNGXSVC3QL+OClSpkyRFxJJJJ+cJdESPTxfEcYjMnTwh6Vnjg
	V2tKXk/zcwTOxVd9uvM5ohyIGiu6EGC460Z0PFF+C9ZZuwTQIyARgNF2MG/TUaPOMFQH0Qv5diNi4
	qYTqvMEz5+3qMfRLo9cr2EDWTg62yU2O1xJ3cBbXW4Vh+Ft0ow7hUyv/qLjpNr6fd1cSnEMwia/PJ
	IllGppmA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV9Sx-000000020VP-2z91;
	Mon, 15 Dec 2025 14:22:23 +0000
Date: Mon, 15 Dec 2025 14:22:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/readahead: read min folio constraints under
 invalidate lock
Message-ID: <aUAZn1ituYtbCEdd@casper.infradead.org>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215141936.1045907-1-wangjinchao600@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FB4B140019
X-Rspamd-Server: rspam04
X-Stat-Signature: f7nmtjyjop8xeq38csota9mzememifuo
X-HE-Tag: 1765808547-21197
X-HE-Meta: U2FsdGVkX1/iPsqe1K7d03UkAtL+n7rclVfoM/cZKPK5y0xxW76610gyxJ+AvBHkIsLTDrwG9hdYlIZd/Lk61xSPeyD5PK3mXVe7YsSLUZbdGnHfHY/JxQlyuC7nOp5PwMvmcRa6a4Lde0RPh4E1o7oBV2Aq1BhNVaYxbotej6HGRqnVJJiQOjmk7xoOGfUyV9K/xMxqMc3OjrCDxct/cDyVMHQ1PaPo//8Ftlv2fgleaqvCRlUR0lKvMwu9keCOzMaB16Ixwx0orTIH2052Uhl5SwB0C2b9PTCaPoNuB+D3JYnDWYklxkH3ioj2uDWPq7DEvJn9J67OuTF0dzUHd6s+fbHVWBWSlRiHHDqcv2mBNNUSJpELge8cmYk+jsTZT4zKPlAGRWkoin00bNqTVyLhgVuF6CAnBuP2tCMpREN+AUp6f728GLUr8ZAQYQFLGEkI45Uqn+yuebu1t27SdcaCd2ASiiThKWUknJMeA5Fo5yv7slpTl0xDLldznxJtdUk9q/TYt+m4Ly+VlwoIo2TCwS5mVHjlz5U7maMDUlOYQCmwJDuK+dAn0lTVj1i+A1/D2p6aFip/EoR1s7ztTgesmq/u8lCLcWhcoudqUSEm77fCi6a9oovdW/i+VfsruNLpAh+buNyqYgB3vWp23mTu+yOqtNeOSjpu7o60mu8TTALCb32g9J3vyAIjezsIiaUrzWPbYi94hJ70fN+QFjEdTi4BBI0YVPyHWa6dApdxHLCMMv7lijv6YbDRDlmlFNEos8xvE1YfDZbxyM+lLHMWi/3qCQ636mD9HVmJVC0X1AdTOtlt8Z1QM7vs44YBJALzRA1qMbgqeoDnQrYHbVF/QXLtyOXI8xMgTYg4ZbiAJXzKR/GAVHLpkju6h9BghHfewqG31qadV4dK5nZ1Qe4TmGYV41JSu/3+QAAldPJ3EiXSnj21VhavBSBbYtlgTBVrLiDaOhOi7poW9yr
 ZddLdtLQ
 LG+1mH1eGwc8kjEJ7hn2dsPhdKTTDZsr37faL7F6ylViqMElH88AjjfiIb3se6sSRzSC8Z+zy6+GhhFRtH/AIfyZFLePloqk5hxv/9Kg86KZLhgpfM8kSPTLE+/2pf4dgjRVLPWoH0WOb2WZ9R/z1VKg1IIdgTjaF285SZaUze7BbpGDOZwrhdDIFwPml4tX37EHI5qmP4A/HiHaCZiyiig62p8zZL7jPLfqebmMvvQR4/7kPVDXV3vTv2v6mWPyfXb1s7jdxQveUN4wP23qBz4Asl0u/eQ+K0Xi48ebdQX8f+Pm2myamgh+m9OC54PM5m5YiQStIIOMPwuKAaEJVu21+1lnDk/zF5ijrx49F+s1N1mS0qulJrIEprA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> constraints before taking the invalidate lock, allowing concurrent changes to
> violate page cache invariants.
> 
> Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> allocations respect the mapping constraints.

Why are the mapping folio size constraints being changed?  They're
supposed to be set at inode instantiation and then never changed.

