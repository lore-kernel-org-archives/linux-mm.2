Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F1ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32678E0012; Tue, 14 Oct 2025 00:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC6A8E0005; Tue, 14 Oct 2025 00:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAD18E0012; Tue, 14 Oct 2025 00:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84BE18E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:47:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1404E13B01E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:47:31 +0000 (UTC)
X-FDA: 83995486302.22.B3434BD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5EFC7180005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:47:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJ7JVgEEuzhrb4h7yBb4ukIiXSaoEQaZqeH4bUiPUa8=;
	b=0N7qVpEz6ub3cFiNVPMNwptGBCiHIwOeCd6E7pxuCZ5+KQ45jwC4QFGs4i6+8RVQT/HrTU
	XNShv/YbU4I1rmCTDuiqrJmYdHV73r6Esn79yOarLcQxnrbmEcDHJIJy9zUGMzDnnmFxKw
	KNsicfp6DBD+8n3nGQ228uwDIsEsrTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417249; a=rsa-sha256;
	cv=none;
	b=UJrN1SA3U4r5yL390BNzz5uUpufH4AcJVVVo+ZbSpRWycWwvbRUwsPxEdG751u1x8tqUay
	zbpUaq4+Q3Lu1sJcQjIVA0KUXNVs72Wp1D3EbUjQ/V6ZsDD5HkSe2wJV5NnMUYYLLxwYjK
	LsZPJ4ZIEPsmCK3nADbPbLSZbIZMl0Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9DED227A88; Tue, 14 Oct 2025 06:47:23 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:47:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <20251014044723.GA30978@lst.de>
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-7-hch@lst.de> <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org> <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bcpiwrhbrraau7nlp6mxbffprtnlv3piqyn7xkm7j2txxqlmn@3knyilc526ts>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Stat-Signature: x6wefrzabj43xw4m4af418qfzpidamga
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EFC7180005
X-HE-Tag: 1760417249-969545
X-HE-Meta: U2FsdGVkX19LIn/ZQccLvd3pGStdJx6lskMoy7YQqIKEBB47BA7ItkYfIJw47pToU5Ji1EQRPBpMoeF+WZEhjOIcxmbCvAtnRpb2xLocSHqEnhFO7ZAnq6qr7vZwxrk0ctp/NGVnGuKita3yrxWf8jTOxPjXyWXqZYTSkeec66nJTJJMPsbJ+N2LSqnO19Vhp4Qx6QGCvpcJ2aoEg0kJxksOEbPNsiIcJegYjKq1w0Sc2Q4V9ucJHzlS8b21K8kK133TARvao0RQMZidEQX5G/3zs42/xdw6bXoFicpb40ngResQ+KZnSk9eojCXXdyQML9WHz7kjdjWVdPl5WaNN1UVQqmYq+Yv5Y2fxnSNuN60k9fGx53J+ebEBQdzXKhpoP0WrWx5rKvjPP+iKGHMBeTzc565pvsc1K/Z6ePVbnI9XWCWHrzwMoZyLedpn+zyMfluY6ym0XGJQvObSQL3RGpoMXEdg5cLdhylyFgIHrLgSd1uLHxkRaGHqPp4cnrAj5ZYXUZxMhZ81o0FUdcZVptgy/yCvs33NwjB/skHLxeTu/HjgPj4h8zpixVmaXSrIdMjoFyTGf8WkyJ7tPyH3Ej/jIf5B4h3UA2tkvBCF2QKyP8ZtA7ohCZqvQAylTtNB3i4PRHkHNWKXiOtLmsg7iI7z9QimMXD+/pNlbyBeCHhx58L8fo6Cn/dvTQnZL7KrmD5A2Led2w/HPrsjt/nBWt/pDfNy2Y0g2oEXw6a0uh+T9G+TBgeXmRlCHVlLLSU5r6VIIF+vr5mgRQiSVNSGRqCqPYwBKTkeBjYaHWd0Mla0z+PRd3urPp3SNUTeKU0/sYQpv/ZiBbuqwJZARyT5x01Q38sPRvhG8BAnWQ6Wi8mLeUlyhxR2owf+Azg+8GXtXWQmt0HSlqR26Un2ks4c118VEny7LemL0mr5DI+UPdHLW3OF/EMX20IcllQhjVDoxK42Pr64CbaYCZWnm/
 NNoUchHR
 TerzqIl5AIoJbCxXaEtaWwx/ikRDUNJxp6/Pcj993bfJ6JTtTYKgOCGp8extyRb+T1vDZnOqFf5cXXX0Xiv+xSYjeF2Ls0VTxLwCmbHZBcm0sNmAiQG0LyMafaqg6mCrnVmyDAKXWfRSuLo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 01:58:15PM +0200, Jan Kara wrote:
> I don't love filemap_fdatawrite_kick_nr() either. Your
> filemap_fdatawrite_nrpages() is better but so far we had the distinction
> that filemap_fdatawrite* is for data integrity writeback and filemap_flush
> is for memory cleaning writeback. And in some places this is important
> distinction which I'd like to keep obvious in the naming. So I'd prefer
> something like filemap_flush_nrpages() (to stay consistent with previous
> naming) or if Christoph doesn't like flush (as that's kind of overloaded
> word) we could have filemap_writeback_nrpages().

Not a big fan of flush, but the important point in this series is
to have consistent naming.  If we don't like the kick naming
we should standardize on _flush (or whatever) and have the _range and
_nrpages variants of whatever we pick for the base name.

Anyone with strong feelings and or good ideas about naming please speak
up now.

