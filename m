Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5609CCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9D58E0097; Tue, 14 Oct 2025 05:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6D48E000D; Tue, 14 Oct 2025 05:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE088E0097; Tue, 14 Oct 2025 05:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3988E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:37:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D866BB4C5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:37:43 +0000 (UTC)
X-FDA: 83996217606.17.75F8131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3EAF3100002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:37:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gLakFHMf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R3V5Ygaf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gLakFHMf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R3V5Ygaf;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6LiiOpwbJnE+aZ8BNjDQXm+fWtAs5O6T76Dc5boMVA=;
	b=1bJ3K9MjmdSvSrwgNgTzkbVqjwPiSV4M09tHLtp40Pvwuk9TrOkapalSi1MP/1Ef/eB8BU
	5OkfH5MBPbiQmkfO9FCSxNw/maZe4WeWUIX+7AyFAA/gnpk4Gz7hFyjH7iPCOARKQ141Em
	fzb+DvyC75GFO3wFm01roa3UQXHHUKA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gLakFHMf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R3V5Ygaf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gLakFHMf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R3V5Ygaf;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434661; a=rsa-sha256;
	cv=none;
	b=iNnTL2QHXMj6FWO86bkQ1k3/q5szSrbyCHOUuQL2gVV0Nm06/O76fHD8zExmJ2b04x6mlM
	MyzgHjKhA1OklBzm1K+y7x9xNjIl9/A9GnFldMzUBpuvySdyNRi6YAyd581IiDc5NoN8M9
	h+mUMjEtjzZQDExv3UMTqzYYuQ3sa/I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AD9841F7B0;
	Tue, 14 Oct 2025 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760434659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6LiiOpwbJnE+aZ8BNjDQXm+fWtAs5O6T76Dc5boMVA=;
	b=gLakFHMfL+KFmwF6T6Oe9d0cmR0S/FGK4Hjz35D5giH1rJ5nMEm7gI7ibnvxFeYMVkhQpZ
	eki+Nlt+U1ywDGRA5m5QDrNfZZJ/3IUz2MFf6SKvxv+NXs1vcyYl6z7CLBDeofetl6ySj9
	B7iJw1AsCBRi5KVkDPqF0OkqZsvISq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760434659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6LiiOpwbJnE+aZ8BNjDQXm+fWtAs5O6T76Dc5boMVA=;
	b=R3V5YgafiR7rMgcGwINQ0jyEETmmkbLsce7GkM+/Wx+Qg1rGbJ9tv2JONNE7uldKFayP23
	xPMtLRJasD60ScAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760434659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6LiiOpwbJnE+aZ8BNjDQXm+fWtAs5O6T76Dc5boMVA=;
	b=gLakFHMfL+KFmwF6T6Oe9d0cmR0S/FGK4Hjz35D5giH1rJ5nMEm7gI7ibnvxFeYMVkhQpZ
	eki+Nlt+U1ywDGRA5m5QDrNfZZJ/3IUz2MFf6SKvxv+NXs1vcyYl6z7CLBDeofetl6ySj9
	B7iJw1AsCBRi5KVkDPqF0OkqZsvISq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760434659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6LiiOpwbJnE+aZ8BNjDQXm+fWtAs5O6T76Dc5boMVA=;
	b=R3V5YgafiR7rMgcGwINQ0jyEETmmkbLsce7GkM+/Wx+Qg1rGbJ9tv2JONNE7uldKFayP23
	xPMtLRJasD60ScAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F181139B0;
	Tue, 14 Oct 2025 09:37:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9O/VJuMZ7mj2VgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Oct 2025 09:37:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54417A0A58; Tue, 14 Oct 2025 11:37:35 +0200 (CEST)
Date: Tue, 14 Oct 2025 11:37:35 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
Message-ID: <tbgfwzv55cca563r47kwi3ycsguxkp2opco3odtzy62o5lgzk2@mipmgtzthvrd>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-8-hch@lst.de>
 <t4y7xtgfnzfpfupnb7on33n6qzrfxfphsm2hqsa5rx4liqvvbc@wwj7ckhyilpo>
 <20251014045325.GD30978@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014045325.GD30978@lst.de>
X-Rspamd-Action: no action
X-Stat-Signature: 7q9gwi3gqw1c6rtu1t3su1hod7sxqt14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EAF3100002
X-HE-Tag: 1760434660-870208
X-HE-Meta: U2FsdGVkX18On6eXcsF2zAC+5UY+FDtyRiRPrE0unFlG+0D93i1LWwvnNEXPNuYRotGs1b25AUfzIsgdYo+pfirozVlDsuJ25+xh0egoFN0yzjOy4S6eBpfOutZRkTmONsXz4sYzjv3g8y000jkVJoOSaKb4KgTCVHuiTEZbY8qbkVt3rDAA2LYpzU0G+arLhf7+qwq4P3CU0jFD9A7GZPQJzo/OdGFOjHCXizcjHhOKTGZRwga7Z5E4W4zCIYAhJpaHrn9+Jl593jClDIjuPtsDKYuaBgIAOD/k+7P6CoMf1sDajuqqqlB9qmGcu+LlppUT3G7SO6tZBRjSv0cNMlPh4HaNfEGT/fUe+7PUY9p5B6dqjMkIBjITixC3SXmEhmb5bGj7Iz0QbAIdldBDT9Fduiy0uvet0a5sZO9+IOaSSrUoNR70gd4sqRGDIarRjyP39REBndKxGGtxLp5UnyIqMqBQgfSdniNETS9OYzrUxFUZA4h9DPV2/V/yonzIxnlo5qFxMmOXK6N7ht8vSCWEaKRPXyUW4l9FPGN7wSE/9FG/mdLpWayRZR4UymR7TKCWBN2ldL05iTAuZ5UY6PPoqOldvnNkWywo01UQog+UZ0DCi0SzPvkvf+JLfn+JAoCMRGaXyY3tc5IZF1L5uluhuxwBCE8PTrNJrXrCpXV5J32P/ylaQ0Spx2S8zLe9byNcel5u4MardZcLDVjYlK+xbNnRGbf73SGpFqVXIXhxGdRllwIvJWvcYUPzWN0NtlgAEofnQ6yLV42ilgVZ2cU2go/3qAR2IYrCqeB+KDX9OK5PfbZpVETNKmuKdXcpfdcPUAaUvReG2X7dD4QUNzbJJGMKouK+OcH6B8wzuWuFk+01uqQafNJuEjuUJ7yKAzSps0KyyDZE8OD1mkMtzbnt/qlKb13Rny+yegaATR6VPAz1iiWzu4FLMJrgVjz7SLXTiNSyhHGvrz36cZx
 8/d+tZKa
 S0uJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 06:53:25, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 01:59:21PM +0200, Jan Kara wrote:
> > > -	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
> > > +	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
> > >  }
> > >  EXPORT_SYMBOL(filemap_flush);
> > 
> > filemap_fdatawrite_range_kick() doesn't exist at this point in the series.
> 
> It does exist even in the current upstream kernel.
> filemap_fdatawrite_kick doesn't exist yet.

Aha, I was wondering where that "kick" naming was coming from :) I've
totally missed adding of filemap_fdatawrite_range_kick(). Sorry for the
noise but I still think filemap_flush / filemap_writeback better express
the intention than filemap_fdatawrite_kick.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

