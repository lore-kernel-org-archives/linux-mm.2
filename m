Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF346F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 20:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC856B0092; Fri, 10 Apr 2026 16:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB116B0093; Fri, 10 Apr 2026 16:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9D56B0095; Fri, 10 Apr 2026 16:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEFF6B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:56:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5E6313AF70
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:56:23 +0000 (UTC)
X-FDA: 84643854246.14.2A71BC1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C332140010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:56:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0fShj+ey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wwMK+R/+";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0fShj+ey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wwMK+R/+";
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775854581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9xV/M6Pi9WCMcCVh2ICHJHx7WicuWqDuyCYoEzfrvE=;
	b=dIiQVAnBZiOCRUL/kxbA5JNuKSa78Q3K+eNVYu2v/WO5wUm5QJAAXBjuquZ/frZ2dzKx/y
	6tx536hC0pry9Wh+TLUGi2NRtPplmA6QYs49RkPVo+enAR9XjhGYgh82zDupdNKp6JDT/0
	1iDVycpy2bJV0ffjEPJZ/94cQ955Mkc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0fShj+ey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wwMK+R/+";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0fShj+ey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wwMK+R/+";
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775854581; a=rsa-sha256;
	cv=none;
	b=8gECD9fva9rP1iAwL7P3EJQI1KDp8tCcD6dRq/uzlqbGf2bvP08WMVo74kG6/7p/evpzY8
	liIC0gSXkTQ5SdWx7acnbnKlNFulBo8bxa7xK4hViIRAb6eb5vy3n+VlrGW8j8DoHQZjXa
	SqY6R8FnYQ7TlmLQIfY5H5yBC7q4GC0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7010F5BCC2;
	Fri, 10 Apr 2026 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775854579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9xV/M6Pi9WCMcCVh2ICHJHx7WicuWqDuyCYoEzfrvE=;
	b=0fShj+eyLYcH42qGsifiG+T1YV+qRicGtDlmj5P8iSkveXQTnctTHfC7uDhZDTbJNxndyO
	+OOqm4O/rkP3nJWuxswUizI2ZWbIWfD1PbLD70M1QMP9dZ9+zDqzCo2eD/kXYv3XLPc8pa
	R4GsXuJ2GFIh9Lq174kDeSmyU5q7qwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775854579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9xV/M6Pi9WCMcCVh2ICHJHx7WicuWqDuyCYoEzfrvE=;
	b=wwMK+R/+26mPovnVbd28xQmOTAYS6sLxiOgm/LSCrCC9XAVn4ZeS90VNYnb/YYt/nNxaVA
	WsQwMpoNIpbk/iAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775854579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9xV/M6Pi9WCMcCVh2ICHJHx7WicuWqDuyCYoEzfrvE=;
	b=0fShj+eyLYcH42qGsifiG+T1YV+qRicGtDlmj5P8iSkveXQTnctTHfC7uDhZDTbJNxndyO
	+OOqm4O/rkP3nJWuxswUizI2ZWbIWfD1PbLD70M1QMP9dZ9+zDqzCo2eD/kXYv3XLPc8pa
	R4GsXuJ2GFIh9Lq174kDeSmyU5q7qwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775854579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9xV/M6Pi9WCMcCVh2ICHJHx7WicuWqDuyCYoEzfrvE=;
	b=wwMK+R/+26mPovnVbd28xQmOTAYS6sLxiOgm/LSCrCC9XAVn4ZeS90VNYnb/YYt/nNxaVA
	WsQwMpoNIpbk/iAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 667C84A0B2;
	Fri, 10 Apr 2026 20:56:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jZkAGfNj2Wm8XQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 20:56:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F2C8CA0B52; Fri, 10 Apr 2026 22:56:14 +0200 (CEST)
Date: Fri, 10 Apr 2026 22:56:14 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <4q7d2bi2qjg6crznvr55yfnv2gcomfqdt5j2dgkrwp5hh3ynqo@cfgy5o53zjwr>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <adikj3y6OXgSyObW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adikj3y6OXgSyObW@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5C332140010
X-Stat-Signature: hsfwqocmrfzsi916qpi7sijaued7ggac
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775854581-490230
X-HE-Meta: U2FsdGVkX189Y6nW7U5xQrXU/4cWV/fbHUxvbyMSKlXQQ7ndmq4ogrCcnMmN//dBZ72LbpUoAsTcf9WbQWeThP33zmxOJpYRXzDCpMpp5TGlQdsnGXn+Q9uZe4hw/oh9Xm9ugto3ZeZG1jpbg/HQzrlsqoE2/RVTQY5ZBdOGb8brLdBVVeHVo1ui482/mjkhUvXfqLtwMe1DKqkVtxXum2rLpQ3SODbZk3PTn2aQVQ2WXd9li60kUf/A5+TW+9CoECqiYf7OKtOEk1QX3HnLV3A2yq9FOnTJ3JGsEVySFP+juUdqzua5q8PhlsddHreK1nQf/l4vlGgWBFD8POr2UyArTagr9jVmkj2Icu4yl8gFXQeCZ6i/wNjK6sTced7fB6U+FtUEBj4BhTA1JH8xSZ67plWocEVyMxj6ChEPkK3EHub5NdlTEBSnXq/JxGPNFkDIrW0QR7/o2/CS2T/kSZcbbd+pAtHcxAa5g3MLvcRYK2U/CrG4dg1kuUg9nnJ8JHlRGsZMx/pDmXa7hxKxggV6Hxoug+qbMv3H2EWj7x3GF4JdyDLsbhq72F3bXK3LObTUi+/tuHZ58rTePc7us8aqImt/E3ZDTnSsl5AmfuAEx3qTDj/B9Iyi2U+/xzY8w1QPoJ0JMl5z5vKIdT7d8MvM3PYMswWBWDyR9FnaMtwtFeylF9GBiRFbwyi9j+lu3CBpG3mw/c7Wp0KJt0KZAokaDlc/NpfMHTVxRcS5ffDMVhgI5sPgnGVljPPhbgy9dOPHthGghYBnHB6NUUusXiZ+uwKHgnSL9iJPEqps0gMCRUr+OxRCcSKJ2zAd635xZi3Sou0cJREEeFhHYYwZMbBz0tXcWVM6g9qptW+unKwrctsZt/gMRs5oLFdktvgLEeit62LX+2cO6QDj2uplLuwtfZeBL5eR7pCPBY9eOh7KFHoes4z18lm9vbcm+51zCbOeh1M8Uv4jsGt7H6r
 TbM0b67a
 qAula2WI6ETlieEmQbm/Ci6f9r2afbBrsKt7+wB9DBzae2Vo7NcXbQtjtrJUzY9S4cI37mnZdWGa/r65sH0rBNDFa3hXPDolw3BdQUrOps6L6SkzGTt3fjfw7FmGLmIwCftTRoF9/kYw3TUliCkW0UKukD0HPvacu8doy4N3BG86zV7ygnu60VOJLIpUtBCzU1Nrpeg0RxWsCEDwKVu03AmIG41IIZcWk4zuA9qpkPQK38q4fjybzYjUGhIPDijMJtG+BKTGQS43p9Gix68C9qRpVDonw9zsaS3bZxjD++d+R2IQCLQvy/aIzUz6EbULHYF523WaY+Aq+3HzbH1RaYLej+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 00:19:43, Christoph Hellwig wrote:
> I think a patch is more useful than a discussion here, that idea has been
> voiced multiple times, and effecticely implemented in XFS.

I know but after thinking for some time I wanted to get some feedback
before I start coding.
 
> Trying to lift the XFS logic into the VFS and finding other consumers
> for it would be very helpful.

I hope not to get all the complexity of XFS but we'll see :)

> > 1) Filesystems will be required to mark inodes that have non-trivial
> > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > whatever :)). Usually I expect this to happen on first inode modification
> > or so. This will require some per-fs work but it shouldn't be that
> > difficult and filesystems can be adapted one-by-one as they decide to
> > address these warnings from reclaim.
> 
> I think otherwise we call this dirty :)

Yup :) I was considering for a while to use another kind of dirty flag for
this and then clean it from flush worker but in the end I decided against
it as it would be IMHO confusing.

> > There's also a simpler approach to this problem but with more radical
> > changes to behavior. For example getting rid of inode LRU completely -
> > inodes without dentries referencing them anymore should be rare and it
> > isn't very useful to cache them. So we can always drop inodes on last
> > iput() (as we currently do for example for unlinked inodes). But I have a
> > nagging feeling that somebody is depending on inode LRU somewhere - I'd
> > like poll the collective knowledge of what could possibly go wrong here :)
> 
> I've heard this theory multiple times, but we really need to valide that
> we don't need the LRU.  It also doesn't really solve the above problem,
> as we still would not want to perform the expensive inode inactivation
> work inline with the last dput.
> 
> So while this might be worth investigating, please keept it separate.

Ack. With the point Jeff made about NFS revalidations I agree it won't be
straightforward.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

