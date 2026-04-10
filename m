Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AB1E99049
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FB76B0005; Fri, 10 Apr 2026 03:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419E36B0089; Fri, 10 Apr 2026 03:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308536B008A; Fri, 10 Apr 2026 03:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4456B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:19:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98DF1E1B1C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:19:46 +0000 (UTC)
X-FDA: 84641796372.01.572BACE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id E33D940007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:19:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MGVJsZEu;
	spf=none (imf17.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775805584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/kagYmVsXElg7lTyBHh77u9odsxBWTXsyTBAIuO6lc=;
	b=MSU2/JjmfiIbDMoWWozwMJZkNDGWUmZyqEFN+jgcr1ElxvOF3Lev02NiPa4xxb0JIqWOOl
	F46VNpCXiLnAlodNxNjVeyYfkvHNm/UuFOYuhfLHNxjfNLe5q+yJuELTHPeY8zYMEoLLtU
	ZuYX4ycoNb+It56cpLjVYaeMMsThf/4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MGVJsZEu;
	spf=none (imf17.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775805584; a=rsa-sha256;
	cv=none;
	b=EJihoP+tVfazUmuGuAIvHmtC/kJGRRYSnDckI2HDX6pMVUkyjSvW1poRhqjuOHjbsZfLYV
	SxzR/B7S/x600qwvtc08UPnreyjFBDDnhs+xLRAipKjm61xVJ61lHclxsMb3EpoJ0PMB4C
	Mujnd0zoF8XJuJnqVXC/OP1f5OBi9lg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q/kagYmVsXElg7lTyBHh77u9odsxBWTXsyTBAIuO6lc=; b=MGVJsZEuqUkcOnsTZIQOdFsPt7
	KvEjZq2UYGDEvkE+ajwptiwBqgEBkNGi5xUR7oVoEup2fw9EiAhu6OcD1nj8ai83nd52bSJW7zelj
	ZHTDOguDQ47pRxBaAGDrN8lH8Vs1+t/I88sBtzGmxX7mZuTNZJR9jNAGu4uNGThd8Ko0Cf0t9mPsp
	a1YD2A6ap2TbRyeD74Lg9GPVwl5OschvOEA5h+godygdpOyPHbq4iTGMDhrDLEOeu8BWHoJgDuPgJ
	T+Wg+h6VnXwgogYidWGjxBXFpIKsrVHHxbgz87/Wg97i78vsPevtl4by35Ba3zSuKJR0xKV4l6u/w
	YcXHP9og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wB69X-0000000Bj4c-432Z;
	Fri, 10 Apr 2026 07:19:43 +0000
Date: Fri, 10 Apr 2026 00:19:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <adikj3y6OXgSyObW@infradead.org>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E33D940007
X-Stat-Signature: ofimjw4wh5enwmai7a87icxm6smmw8yt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775805584-872857
X-HE-Meta: U2FsdGVkX19Q+Axj68FOxPP78IIB4GVnApyFOMtXO9Ra3X/gdUkgFeZyUbmRsw9UqnajP17n+6X+pvtrpaQiArQN5Dc7SiEjFrzOBU6e1L2yWVCWnC0M5O63HwDqmTqABKQZJF6iAFTUu1nQUlCvgHYQ1DPf3FeUAEcjPPZsqZIr2cR2uV+SaSNBYDodEm1YuewwiIFrBpEh98CXFYxw8+a+JedrJn0fri/xv42OjBxkg6LjLQAJLKt+vYXnxp4Z26qB+B7F0NEx74UlScEsnIa1SAZKLW0TZbIK2G1adj6WwmHvtvT+6plxKWx8FXgjhcuu0qvcEQNmEiJeh330JlCUehewPTj+/emoveRaKbC5uDAUgMB+hUd0Y2v71xlo6HqgYrRksaz2GnM1cqauBDNkJV25rssWCo6XediWs3D+wyTBvPEZ+dRrESUcNnPvz3/R53Li91UpT0a5tNCBRmFe+grmItjjHAEoCUlSvvMsdLAv65UIIh4aptgIc0vG6wHMAKFUUic3D4jAvjcEqSuMEAtWeetv/6bmgc9rMrYtNJTjX8qeF2ZVMqQJxtEJ+yhvLyTfMZLC4sKeiVl4deyNMGfvPWicv23/yyApViD75MnIFsBOTAxyK2+VmG9DsSl6TwOL7m6VXVN+icG+ix+cnbnGiD16a57zy6RaHtrvKrTcU1t0irGWaVU9i+sAp8Wxehiir8xi9jFR1NRrJnzQ09WeBKCQWuXGIok4kJhO6oQh5Mn0eE3pvj8rIBo/N/Zt67eSl/dsulLwHcYa4fSXufKHea4F0Qw0Sth0So3r6iQF4i83LA3sL6ocPUQMJMQ79Kj8zh+4COkI9/JBphwnFihMlNlYQF8F2waexBCHfFJt+M+reAhEVc+3+Q5s/2wsUjK/GIM4GFGAtBZo3eSd59BYDWgY1zcXv4zhThp7sgfXQnw8zo09BY2XflrywknICZHhnTCLVNPAroA
 8WIpshwS
 NhJ1elFWdAZKTq+JpHd1LcDORD9g/wtgdpVxgOUZ3PK5Rca2cFOHw+8K6Bl5yd+J8qeUv7+3WOFsm1CUIAQnyIyw9E36EV2BP+z8v5M/J83EgkI7255eLk9EI+Euj7nN2WtfN/gTdglp8f+rGS1Xal88d01xiDyxpggHPllHh60LNzJSC90UNKXi48t7J2Fzrh6tbIEsXB8pQWmwVVSLZ3A38AWE70vYdRGPtbq+B2l5xItBjnTD3k4Cq28P8bhkLVe7OwPg0+B2fDa0zAWTM3OGWF/NYGVIg4JL0fHtwrcGV5bcyGUxF05B9DQsocgY3bQDt0F2iAL+Bd7eNzuQBs4cD+fWUS6j/0R1QFJNs3v3Oat0MUqZb/ZJ3M6dwaT6rLoLSyAVqkVr1CAlhJgy+zld/xHOLkxRqy9KvzkVqWlqvgqguDA9RMdBeUZuKPCsLHkBNNt/ZEclysxtH9JnEQM9VeGq0wbIcxKuwkb7hC5LsyTQ/UXQNUueUkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think a patch is more useful than a discussion here, that idea has been
voiced multiple times, and effecticely implemented in XFS.

Trying to lift the XFS logic into the VFS and finding other consumers
for it would be very helpful.

> 1) Filesystems will be required to mark inodes that have non-trivial
> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> whatever :)). Usually I expect this to happen on first inode modification
> or so. This will require some per-fs work but it shouldn't be that
> difficult and filesystems can be adapted one-by-one as they decide to
> address these warnings from reclaim.

I think otherwise we call this dirty :)

> 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> performance reasons. I expect this to be a significant portion of inodes
> on average and in particular for some workloads which scan a lot of inodes
> (find through the whole fs or similar) the efficiency of inode reclaim is
> one of the determining factors for their performance.

Yes, in most file systems most inodes are clean.

> There's also a simpler approach to this problem but with more radical
> changes to behavior. For example getting rid of inode LRU completely -
> inodes without dentries referencing them anymore should be rare and it
> isn't very useful to cache them. So we can always drop inodes on last
> iput() (as we currently do for example for unlinked inodes). But I have a
> nagging feeling that somebody is depending on inode LRU somewhere - I'd
> like poll the collective knowledge of what could possibly go wrong here :)

I've heard this theory multiple times, but we really need to valide that
we don't need the LRU.  It also doesn't really solve the above problem,
as we still would not want to perform the expensive inode inactivation
work inline with the last dput.

So while this might be worth investigating, please keept it separate.


