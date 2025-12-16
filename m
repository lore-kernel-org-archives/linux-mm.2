Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BE6D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9404C6B0005; Mon, 15 Dec 2025 22:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4696B0089; Mon, 15 Dec 2025 22:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C34B6B008A; Mon, 15 Dec 2025 22:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 670556B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:53:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06FB5C046D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:53:24 +0000 (UTC)
X-FDA: 84223964328.12.11C3220
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A67980009
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:53:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JB+5ejqX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765857202; a=rsa-sha256;
	cv=none;
	b=RINN6uTP+ernIz7reVgVHTHZ3foYbMxSLQGPMaozdCwcQOTi9+JkrXAz0xLdRRDcdSIcKJ
	sCs7Uoeeu1+G1wftmj6PZUpNYNJU2EdnHvs1JDlViJgwLk3wS7RN+rQS7tvNlqHuMX6hs1
	JRoDLWyOava1reSvtucOi1o4d0NzfdI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JB+5ejqX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765857202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64NwuPvbdpCK0JttfTKet//HJpHaJvO+yNGslTME2Zk=;
	b=xaIVS6Pl7fEJgDHTcqk8icLspIsELyZEqZKbJmAabT7QPSh/uWSzby2coctu+uDWyrqh85
	4MHvHNK4k30qWsa+VkcAA52qvyIxhJzinli2dR3Ge1Itp7xDsrqM47jmQX2DYov9kF/5EX
	XzD/hpLJiFAUfNbUft384nwbCbJOgRs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=64NwuPvbdpCK0JttfTKet//HJpHaJvO+yNGslTME2Zk=; b=JB+5ejqXSSsBBruNtD6JEmqINs
	urZTRcjrObJDhcfY2uYv9C3omLGiQsTACPBJ/NWJ5aTok9fOy9vboRY5mkQJjrIhBmywBKRID+OdA
	a/+8M2WyYWsIa+5yY9MMo9RKm/4SQtTUHLUwVn8WLd7b9by4d7+669qPl8LyRAyRvHDyiENT61L6S
	BMt1HV0+Y5crydJdX2vXu/IRLCC5W05ChrMgWQfFhBPOSzl65pJlh8dPRL/vBVT4tRJUr0LoM6rGb
	G9oRBwO5yZHIwC9Zryswo+NRT7MUSX7QB5j/xTs0RwteHxrJKNnAXQ0nhm+Eq46X1dXh/VzUybdFw
	dNsfrskg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVM7h-00000002mHM-3hBf;
	Tue, 16 Dec 2025 03:53:17 +0000
Date: Tue, 16 Dec 2025 03:53:17 +0000
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
Message-ID: <aUDXrYgwZAMYkXVu@casper.infradead.org>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
 <aUAZn1ituYtbCEdd@casper.infradead.org>
 <aUC32PJZWFayGO-X@ndev>
 <aUDG_vVdM03PyVYs@casper.infradead.org>
 <aUDOCPDa-FURkeob@ndev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUDOCPDa-FURkeob@ndev>
X-Rspamd-Queue-Id: 6A67980009
X-Rspamd-Server: rspam03
X-Stat-Signature: w45m3bs6m7ca3yh41crjotshbaw44ok3
X-Rspam-User: 
X-HE-Tag: 1765857201-724845
X-HE-Meta: U2FsdGVkX1+RtztwN/QhLhXddYVS3hOqmugBtiA9paio2fDF4lYghHPmKKOjWH/oaCyO14F0ivKTWXZU55juiZJvkvR+XEdIe8RsIiPWH6Sm8KBSyvZCB0m3VItDppnAG1ASfH/MspK2FtYeEmsEHdSMmE8rNsCW4nWCF2tYk03GvRn39KmjuNZxg6+Xrbtu94ROkjPlpsjo0USBhRgfE67K6CGkioYpQswIPQstty9ndjofdNwUFBv2OQMBtKMOUGkFak5RW7fuSZuKdbInQG083NTUj4OBq3G7fdb93U1hEQfGHw9F+nPypOxx7OzGgbXYf2pZ3+MPeIfhvqRIhP3ks0ynISB8EQY+VB/RMvPe5V/Enz7h+FedFx5VzeOVoWB2CbFT5WrbVhAqsDHlhuOlPtVwfe/6AfMEJog4RCUDeP4EINTs9YJi8EQFjBzMBbba/iqIwehYCvYP8bfFOAZOmTZ4sAbyucXM8ZX94zdujWs7oNE9x2dDRAYxIfLPoI1Q+E/sNOyR+X0zOfo+GhaVXE9BwGwL3TD5eXk4HddBUqf2rNKUHhmUEfpjO9PUP81s/3MgXMrxN4o41kBkDf8y12r82JUcrzm5pgcGfLSHVGbZj+IcGzsi1xkDYx2ydQJoxSPiMd+Vjvtg0q6FbMVO45uX+LDEmZznyaOaFXIA2lkCFQLegyBglbR8J7zVQ5jg6bRcCkwWiCeZHzgJEHmY/os76JeajjXdnvQbz3WqLfhT4KNvEZBCsHDJ7Bkoyy7FPptEN1JR9YQCzw56IsW+uI/XQNdnRxCS/L7Xm/JqyukfTXMvwYjWQhLw6Owd6pqYTk5Yj6aenN66F70x8gXXlbuszoEaHTo7kmalF+HrVebQGbDS/me8V/7KZ6jPq6FZRlHiaC9pY5QEgWtXr8IYqpLaorUHlDUC/tPHXE/6oYKmbp53evW5kDv4vu3V8yWpoee3oFFhH8j5EwP
 C+YsZTro
 ogLp0sHOcLpko4e15tyz4oXLWY17SieNrGYzS9vQwHsCrWuaqyfaXDQRjcw7ngmg7pXmwu73UyzRcZ4SL0qfFzDDfdP8lgD8ju0BiGFl4SY/M//srK3PdWxRANmtvC5he0FY2aesq/V2JmtrGW5cQGmq4d5GvRxvu5S/13L80N7hpPm/cR8LrcLCSGnIoeNzJ94miEhEsGigtrD57xTpaPirhSd+VocpET5W2t5USmOCiFfXLHSfoA9ywgjE76lWko1CmIhbSY0TdWZDtBsBI6/FKhi52jSuTBNJVKHI54Ut0BZIMIprYvrAcYKvprRtELEexPabGFZfvBz8JT96oShTz+6vQosK1iHMn0J8A3Jfo+jQlv/Alc+2hJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 11:12:21AM +0800, Jinchao Wang wrote:
> On Tue, Dec 16, 2025 at 02:42:06AM +0000, Matthew Wilcox wrote:
> > On Tue, Dec 16, 2025 at 09:37:51AM +0800, Jinchao Wang wrote:
> > > On Mon, Dec 15, 2025 at 02:22:23PM +0000, Matthew Wilcox wrote:
> > > > On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> > > > > page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> > > > > constraints before taking the invalidate lock, allowing concurrent changes to
> > > > > violate page cache invariants.
> > > > > 
> > > > > Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> > > > > allocations respect the mapping constraints.
> > > > 
> > > > Why are the mapping folio size constraints being changed?  They're
> > > > supposed to be set at inode instantiation and then never changed.
> > > 
> > > They can change after instantiation for block devices. In the syzbot repro:
> > >   blkdev_ioctl() -> blkdev_bszset() -> set_blocksize() ->
> > >   mapping_set_folio_min_order()
> > 
> > Oh, this is just syzbot doing stupid things.  We should probably make
> > blkdev_bszset() fail if somebody else has an fd open.
> 
> Thanks, that makes sense.
> Tightening blkdev_bszset() would avoid the race entirely.
> This change is meant as a defensive fix to prevent BUGs.

Yes, but the point is that there's a lot of code which relies on
the AS_FOLIO bits not changing in the middle.  Syzbot found one of them,
but there are others.

