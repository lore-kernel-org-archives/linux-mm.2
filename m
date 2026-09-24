Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6E8C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F236B008C; Thu, 24 Sep 2026 13:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610576B0092; Thu, 24 Sep 2026 13:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500A76B0093; Thu, 24 Sep 2026 13:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27CAE6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:09:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95257120355
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:09:38 +0000 (UTC)
X-FDA: 85249292436.22.4B32D60
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4CB69140002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:09:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ggE9OLJD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wkn6AaC1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hD2O3EsD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xvr2MR4g;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790269776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tP4bFPUTEwnWsI4CSDU6qWh7SX+DL+G8nmMwGV9F3A=;
	b=f7Ofa+l3ovF60D25bSNTuGvI9C/bz1Kn8fBQQRGUOoJJGN63QDBg6cLqjoH7G9LrvyXDEv
	pC4ow3XUQP+Fx6aZiVaaXdbT5Ba4T+5WFDD03IPaaHv8p8X3hn47GIwVgTtpMwfTtntP2P
	RYxAUho2F38Mutpl6vQottzLrx4mmak=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ggE9OLJD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wkn6AaC1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hD2O3EsD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xvr2MR4g;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790269776;
	b=whWwqiweIcdw746Bj7J3WU/pCXxs1Y+5lPuqh0N3VYFtgN3oqEHeJ9JHA8hv4/rIrWNVf5
	GbrHIAjwq33SobrjYk+rR4GL4RXd+NkhFSwPQG3rOZ9ML2+3JvPejUzP1+ts/9WBoNZ8SR
	47/1EM/n+WrXcWzWvuvnzGIuDns1OH4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6EF6A21D47;
	Thu, 24 Sep 2026 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tP4bFPUTEwnWsI4CSDU6qWh7SX+DL+G8nmMwGV9F3A=;
	b=ggE9OLJDUJfuj/26sqpPat1KvuogdbzsgL3x/jin+yidxBp0HyZiktCVYcJwX2avqsy1xL
	8ttOD5KEh/cDFtSSWUTGea4gbv3bjBtF2LbzrWfqLuYsSFmxcY6aSfOWLQwNFTbzHL0X1M
	RDjXTuA0Bc/5p9Qgvv1GTlGk7gZicwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tP4bFPUTEwnWsI4CSDU6qWh7SX+DL+G8nmMwGV9F3A=;
	b=Wkn6AaC1odGABWmK4yEbE/yKpojIwLjfglNjgk7y1umAn55MMoRuB5x2pbn+CP+niFpfp7
	SYiv79mwutKkESDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tP4bFPUTEwnWsI4CSDU6qWh7SX+DL+G8nmMwGV9F3A=;
	b=hD2O3EsDlzyUsmri+VVMGQETJBxcG7Vx/FMbkH9WqRd1ct4ce+2NoV+rGLMRe3eeMoOEYr
	ERHuX0rbH1TPRJCj6HIAEb/t5HOHyBTt80cPpbXJPSwsq+EkIWlrSvEe087z6gWJQoaezo
	+FHDTH50D9Z7OUsOubLpNC9K29sh9is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tP4bFPUTEwnWsI4CSDU6qWh7SX+DL+G8nmMwGV9F3A=;
	b=xvr2MR4gXqOuiPmDAlcKP9+oSqCGskApxAlL2tKnBTCKaAaCTb05JspYprlqDc4sBTyCYl
	SuHJvpf6VrLx/QBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 227F513354;
	Thu, 24 Sep 2026 17:09:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4lReOkVZtWp5XwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 17:09:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9FA76A132E; Thu, 24 Sep 2026 19:09:25 +0200 (CEST)
Date: Thu, 24 Sep 2026 19:09:25 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH v2 4/5] fs: Add throttling to deferred inode reclaim
Message-ID: <kgxyhbgbewpch7pc3auxthhbcfelq7lgi7mxazdo5wvg2ael3b@hilsbf4622sh>
References: <20260911081309.14137-1-jack@suse.cz>
 <20260911085142.1774803-9-jack@suse.cz>
 <CAHc6FU6YT4EzM8VDX8V0+dhfRJtSrtWxbuwht+b8HG5yzyq7Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU6YT4EzM8VDX8V0+dhfRJtSrtWxbuwht+b8HG5yzyq7Lw@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CB69140002
X-Rspam-User: 
X-Stat-Signature: eyn6ifcpm1dkgmsd81m8wnxjwmm5zmga
X-HE-Tag: 1790269776-291492
X-HE-Meta: U2FsdGVkX19Ucf0zgzi12fU1Cj+x+auu8+XBjWY6y1IyT4exx7iMbtgbJxKWu4FLYqt9mLDw5X0oUtyAV/o+OF8guqtHhTcFhAnXk3TfIDe4U/8E0zK1YcrckjRK7EJveQnIf7Z1iGbBJgAAzuZR8d0n2vTWIHhs6MTelSn0hjDMMSX/HNVg6nqJAtBdTKtscrYJR0OVSti2Sn56vjTu33Hgnn9N3QQPq3g0kY+NzKnZNArWWtijpwVw79VO7ti/7djl8rkiru4OtyJ0hOVEEqK97tbee3jH8+PWF8EJWCKZnMGZkTewyKWJEPWxdUpLaKbyKjmn1vU0Y9AsG4BBQat+e/cqFOssfcircMLo6mX92xsiZlw7Gmduf4mU7Ef/rN0TmAmGvpFKAv65GBFEl5lqW+WX0TxoXO9s2HnczB+ykeX6DkDoh1u/TZxy6/uINYwnpWWcEOmkkEA6fu/Jejgnp61MkCTIj6+b7Dnu2n0qh2e2Rtq7EqIHV2RabEgskmLogYlaIXhOJTRkX/HGbf56qjJBo/8F9hwvm2RAu1bbDu1TvnngLlmOk12n5DDmaUusEqUXxt+gsAJDEMLCyw5LYmxRNIjg6NEAUkYFi7orWWSYa+B/d9M0Fgkd+QdgNRmuCTI1SA0gZSiRMFnMybJxT4EgABosVSf3ZRmV1tKJxqqI11ugdZmsFxCjiKWq0iDu6ElzmfwnzoPHWgS0g+HR0O25WQJCbk5WxqvH7QjgZslYkXlgiKIi5ddAP98OltwtV4EbexfFFP4t6J7RWikEPjvJCFDOH4BhGFkjJXo3xveOMgnTZ+X/Wb6PHBv7OalmjBJFU7yeDxAinVBmw3NhYsYm4BRi2W6uqCdol+C6S8O6HFKxwnXaArdQE8tBKoAKGJHALDtgxbKLsbsd+hFlRwenTweNhKFZ3tmtQRTm/OdtFIbJuUXwpyDe0IlycdSghu5P/WgbJDitf0L
 kWtEbrvF
 GDfVobTPHKZ+/y9JFC4AHK23fcqw+lCA8zVNVhkxsW9tHAzkfMu5Tv4O4jsK8uNO2QJz1r5qc6NoyAJkGpN47C2MGPNFdW3P8AcDGkKdTEOzuzYO17mh5C8QZMIdinDQ4jd3wFSE9hNTt7xU5fzJaQecXqWcMydTjuHLMUFgsu/FIbNV+WzbGUETZoTTqvtD4EfhzUlFhi+YBVeH8d+HrAZawso04Zh84K8ef4+TVWP1yhtoKju/IRf8AoQiuNns/A3ch0rlpAqG/0R0mCeFo2ehvv4q7BPTbthxYLjq7Lj4gE8QmFGxTOQqibLGmeOiImK5B23uZl6wI7MPH7jtKI1qbA/v6ZgaTeCYTsjBY5adU12zmCQgrm+A4ajeuui34p8R6iUtpaqMdZsHsuh003fwqtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 23-09-26 23:24:48, Andreas Gruenbacher wrote:
> On Fri, Sep 11, 2026 at 10:51 AM Jan Kara <jack@suse.cz> wrote:
> > Deferring difficult inode reclaim from prune_icache_sb() to a workqueue
> > removes the natural feedback loop of blocking tasks in direct reclaim
> > until they make space for new allocations. This can result in the list
> > of deferred inodes to grow beyond any bounds and possibly push the
> > machine to a reclaim storm or OOM.
> >
> > Add a throttling mechanism slowing down tasks in
> > mark_inode_reclaim_deferred() if the number of deferred inodes to
> > reclaim for a superblock grows over limit. We measure average time it
> > takes to reclaim inode on deferred list for a superblock and block tasks
> > proportionally to that.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
...
> >  void mark_inode_reclaim_deferred(struct inode *inode)
> >  {
> > +       bool throttle = false;
> > +
> >         if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
> >                 return;
> >
> >         spin_lock(&inode->i_lock);
> > -       inode_state_set(inode, I_DEFER_RECLAIM);
> > +       if (!(inode_state_read(inode) & I_DEFER_RECLAIM)) {
> > +               inode_state_set(inode, I_DEFER_RECLAIM);
> > +               throttle = true;
> > +       }
> >         spin_unlock(&inode->i_lock);
> > +
> > +       if (throttle)
> > +               throttle_inode_deferred_reclaim(inode);
> 
> I would expect the throttling to happen when too many inodes marked
> I_DEFER_RECLAIM are evicted, but not here. In my use case [*], inodes
> would only require deferred reclaim intermittently, while they have
> outstanding revokes. Once there are no more outstanding revokes, those
> inodes can just be evicted directly.
> 
> [*] https://lore.kernel.org/linux-fsdevel/CAHc6FU4Rf9-r8m8SSb=e0k0zyoFhQAdjupHMWvT6rStBshntug@mail.gmail.com/T/#t

Throttling during eviction doesn't make sense - you are punishing the wrong
task (the one trying to free memory, not the one actually making that
memory hard to reclaim).

Also note that the throttling kicks in only when the queue of inodes that
we want to reclaim but worker didn't get to them yet grows above threshold.
This means there's significant memory pressure, significant amount of
deferred inodes, *and* workers cannot keep up. Throttling marking of inodes
for deferred reclaim is the best thing I was able to come up with to
eventually reduce the pressure on the cleanup workers. But I'm open to
better ideas.

I understand your objection about the need for deferal being only temporary
but let's keep that discussion to the other thread.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

