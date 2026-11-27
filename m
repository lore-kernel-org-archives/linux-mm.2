Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7ED606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mNTdifR/;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DRiGJy2A;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MeNzC41z;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aJdUm6K8
Received: by kanga.kvack.org (Postfix)
	id 3DF4D6B05B0; Fri, 27 Nov 2026 12:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3686F6B05B1; Fri, 27 Nov 2026 12:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209EF6B05B2; Fri, 27 Nov 2026 12:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB98C6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:08:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE36D160470
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:08:37 +0000 (UTC)
X-FDA: 85481533074.15.38D9EE9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96882140010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:08:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mNTdifR/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DRiGJy2A;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MeNzC41z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aJdUm6K8;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795799316;
	b=UtCeVuCKCM/Ju8+V9+yF7R6E7OmYahGUVNLc6M/Prp1wIA8RSNJAmux1T8FIeJYH8ZiDAg
	ZJ99Sv44vY0Fk51lhQZoNp1N080dCxC3lbgakrsRjggCHdU/0r7pFd6JP4cILHlq4Z/5Sb
	ZR34A/Ze3+LuD8MdJ7t0FoyxPP7TExM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795799316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVpLUefP+MIwYnC6agl4RSnMJhWhOW+a+vNTOAONsJI=;
	b=ee8z9GGQjbVnChoftU3Z0LSbmv8o/0vluwRlJa4e6WVpmHKBPWp9iLpsTCO3qKuH8wVPR6
	vmx26BNpKhj75Kd4jM7cd9Svz+Xv3gNhMB3Tu0+m9h9i4Ilr92y3Fil7Z8E0z0R4pWDi/E
	n3hvHiiVnZp6F79ncvy5wLeBSCm/RMs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mNTdifR/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DRiGJy2A;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MeNzC41z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aJdUm6K8;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E57BF1FD45;
	Fri, 27 Nov 2026 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVpLUefP+MIwYnC6agl4RSnMJhWhOW+a+vNTOAONsJI=;
	b=mNTdifR/XMbIUTPQkDJqz40FNUC2AZh0a8Vmv1NrvDH3ZcCJBStuLynUmP8yETFL2yuc3k
	Fg/tB3988PFqN8LjSnhn9aE1aFXKKtnkXKVvvdX01ko6RYZqiM+WzBifyIm/d+D6XblHhR
	FxrfoYigqTvg/ROZM92lnG2qrxbdurQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVpLUefP+MIwYnC6agl4RSnMJhWhOW+a+vNTOAONsJI=;
	b=DRiGJy2AyDs2dQOBncEOUvB7uuWcLqzpLximgJ2CvrG26nVc6y3sCdGQquxPxWfipOnYUk
	yZiwg4Y2Ce3bu/DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVpLUefP+MIwYnC6agl4RSnMJhWhOW+a+vNTOAONsJI=;
	b=MeNzC41zU4/QfanxQsKgxP5Nopz5f3JqPDVHJXapm1QShKSIbOjkDpZ9mVty4+CZSesxDb
	OG2d2/ztt9GP9qpR3yGG/jcp/015PPhr1h+m2xc+jsndzEkRfsH56fA26vqZZIEGS3rffy
	c5fd9+F7bmWXiySXdGJRA6Ge9bNikl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVpLUefP+MIwYnC6agl4RSnMJhWhOW+a+vNTOAONsJI=;
	b=aJdUm6K8atftQcd4gjqzdhgvd93ZTOKly6v3Z97oYTBP/QokmvH2MxXfse1/EgKxYZo+gG
	2m5QYqA9u5rrlBAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B621013432;
	Fri, 27 Nov 2026 17:08:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AGZXHhG5CWtFdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 17:08:33 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 1AF91510B1; Fri, 27 Nov 2026 18:08:33 +0100 (CET)
Date: Fri, 27 Nov 2026 18:08:33 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 2/8] fs: Avoid inode dirtying on last iput
Message-ID: <ecko2ufkcdcy4qojpo4ya4ra625ok4r4zgzdxzwaospr4umb4j@3frg4pq3o3ll>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-10-jack@suse.cz>
 <sashiko-outbox-233311@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233311@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96882140010
X-Stat-Signature: s51dh8ikyzwkwg9mi5zqdbn55ikfw61o
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795799315-826072
X-HE-Meta: U2FsdGVkX19cmd3DdV/V5aAbZLfs2Umaar0tEox6JoJb7sIPKlz8g8kxsgTk2pmuzCJ0GRlTyPtNuhY7TyzoFiamBU0PQg+FW77f0+1M5GebT/nDe6lAJ6L7rk3uIzCjKStn1HzJtTubYE9OINpb4L0yRNlprbYgtVp5SN/SFLvxoex8U9EOj7i3nsbh+9+qH+a0WkyG5fd9vMKtkjg2fJLxRf7BqnKS3KkwbtpukCL5+LvSCQTdOsiOmD5yseaeGfigYHCFyMsuRtYZvvr0cKDbwxjrF1uU376dBRnqMqWHJsVJW8gUIgDulMBOIJyIXhxiT5ou4ENDDPA1oPtbFwnScqAfj6zAt8CEoM4wRcQmdSC8gXXEqn7m16sYKo9VNLpoR3cLOTisAKEGH1aN7os5Yh3D2X8ZByv/VlP2f+CMog2pNukQIfcgLdUXIGbEQrFILm/Eo30JxZzRcckXI8QSrAzVy9lZ01hXOcYMMY7B0VpM6XDeWWLKKaGaXLZAQM+J/bDHZmSG9Rpa3Us+UZ+fkix/EKifqjGO4jXivE5zobMukHXipIegrv5KUazswjuYnh3/cmSqr7hMYH2O08qttauDdJRr+n6XVtSxBzGbnhZw/27ly3ot/Ig8Gb3ofLMRGzDtB1y+KaiPwcJqHWcfyv/QyTA+CYFc2H5a06l1ddjYK24tY4u5atjFpMHHZmxJ2t1n4MFqu3smjbOlxTb4xtLlVysaO+wrvoir6J3jDI6JsmtD9f3TsQBgDkNxPIjbWp9tFIFE9SLb0RO6t6Y1udMoWY/LFJflF+UWpscsjwDosF29ohzlS/FYO2T/QXf99s1p9XXm7uO8Lj44ZCp3NdpKpaRlxE3D/PE7XqZui4CPzIPSAt/KrDPmoUY8BQEJSjF7OnCYiDs8hFF9ylU81nSSxHvhjVw6S+KR2diuj+hRuUqXAAYUZr4yGrQbrE+pO2lBDsONKq7KJ2q
 j1n+PeUf
 5z2HqTi3Ey7jWiyWJvv//clnW1sauRnLF/xqyz//DuUz7SOwdgTKTwkK/lTtPbD+RbkZJ40x8JHNS91s0QwqrH5SfoAQmuL6WHRvykeMX7C06AXw1Xc5nMTLvzsfAIyK2cbeUfN6l2UQdSeXiSqqLWc5eriWtzFgHXklGALkSU+DLV/bRCfr7bJM6tjhbnbCI7oO0zvXhmGRmm/JheSkx7agm2gZzKXnUTDBKY5qqq9939WmjXX2HyobrxKr9TMWMJvzgxiVfl6P4McJ+UX9tVqP1WakcId8RvjJ5aUpnf+05dQrv/7KQqKpSsrBagkdZK3TZLJpn8zo7IZYxDnU2Wl+Bg6m4JCNM6zBVEgUbWmKn4ssjlLMRVQ/wcVk/BA+qOOdNiWr6/32Z4hee9WlU5D/aw0weG54RPTEnji8DkO+G9tVgTKekhtOUjdcr768gPT9AXTc7dsZUKqCN1vtg0z55zlO9ARnKtRyJ36Sy0RLjsq3JTrK3f1mVYkdzYg1TUdrjALPpe5YdY1oPDJYlB4qO1mJTntFhiRQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 12:00:01, sashiko-bot@kernel.org wrote:
> commit ee4802f28b5dfd62a7f8c5bc17c60aed4d146987
> Author: Jan Kara <jack@suse.cz>
> 
> fs: Avoid inode dirtying on last iput
> 
> This commit replaces synchronous sync_lazytime() on final iput() with
> queue_dirtytime_writeback(), moving unused I_DIRTY_TIME inodes to the head
> of wb->b_dirty_time with an expired dirtied_time_when timestamp so they are
> flushed on the next periodic writeback pass.
> 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 65b1af2879e87..0332a2edef938 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -1583,6 +1583,42 @@ static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> >  	spin_unlock(&inode->i_lock);
> >  }
> >  
> > +static void inode_add_dirtytime_head(struct inode *inode,
> > +				      struct bdi_writeback *wb)
> > +{
> > +	unsigned long new_time;
> > +
> > +	new_time = jiffies - dirtytime_expire_interval * HZ;
> > +	if (!list_empty(&wb->b_dirty_time)) {
> > +		struct inode *first = wb_inode(wb->b_dirty_time.prev);
> > +		unsigned long first_time = READ_ONCE(first->dirtied_time_when);
> > +
> > +		if (time_before(first_time, new_time))
> > +			new_time = first_time;
> > +	}
> > +	inode->dirtied_when = new_time;
> > +	inode->dirtied_time_when = new_time;
> > +	list_move_tail(&inode->i_io_list, &wb->b_dirty_time);
> > +}
> 
> [Severity: Medium]
> Should inode_add_dirtytime_head() call wb_io_lists_depopulated(wb) when
> moving the inode onto wb->b_dirty_time?
> 
> move_to_dirtytime_locked() calls wb_io_lists_depopulated(wb) right after
> inode_add_dirtytime_head(), but queue_dirtytime_writeback() does not.  An
> inode with only I_DIRTY_TIME set can be on wb->b_dirty if
> inode_do_switch_wbs() placed it there (since it checks I_DIRTY_ALL) right
> before process_inode_switch_wbs() drops its temporary reference with
> iput(), or if redirty_tail_locked() moved an expired I_DIRTY_TIME inode
> from b_io to b_dirty.  When queue_dirtytime_writeback() moves the last
> such inode from b_dirty to b_dirty_time, WB_has_dirty_io stays set on wb
> and wb->avg_write_bandwidth remains added to wb->bdi->tot_write_bandwidth.

Yeah, this is more of a problem in redirty_tail_locked() and
process_inode_switch_wbs(). Not a serious problem but I'll add a fix so
that I don't forget.

> > +
> > +static void move_to_dirtytime_locked(struct inode *inode,
> > +				     struct bdi_writeback *wb)
> > +{
> > +	/* If the inode is used, move it to the tail of b_dirty_time list */
> > +	if (icount_read(inode)) {
> > +		inode->dirtied_when = jiffies;
> > +		inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Inode is not used. Expedite writeback by moving it to the head
> > +	 * of b_dirty_time list so that it can enter LRU and be evicted.
> > +	 */
> > +	inode_add_dirtytime_head(inode, wb);
> > +	wb_io_lists_depopulated(wb);
> > +}
> 
> [Severity: Medium]
> Can an unused I_DIRTY_TIME inode moved here miss periodic writeback and
> stay off the inode LRU until dirtytime_expire_interval (12 hours) elapses?
> 
> If final iput() runs while I_SYNC or I_SYNC_QUEUED is set,
> queue_dirtytime_writeback() clobbers dirtied_time_when and defers list
> movement without calling wb_wakeup_delayed(wb).  If the in-flight
> __writeback_single_inode() already passed its I_DIRTY_TIME expiration
> check, writeback finishes with I_DIRTY_TIME still set and calls
> move_to_dirtytime_locked().  That moves the unused inode to
> wb->b_dirty_time and clears WB_has_dirty_io via wb_io_lists_depopulated()
> without scheduling wb->dwork.
> 
> The same stall can happen when queue_dirtytime_writeback() calls
> wb_wakeup_delayed(wb) while wb->dwork is already queued for an earlier
> deadline (or wb_wakeup() runs it immediately): if wb_workfn() runs before
> wb->last_old_flush + dirty_writeback_interval, wb_check_old_data_flush()
> returns 0 without checking b_dirty_time, and wb_workfn() only re-arms
> wb_wakeup_delayed(wb) when wb_has_dirty_io(wb) is true.

Correct but preexisting and I cannot be bothered. It boils down to the fact
that when wb has only inodes with dirty timestamps, then there's nothing
which guarantees periodic rechecking of whether timestamps need writing. I
don't think we really care but if we do, it's a separate series to fix.

> > @@ -2962,6 +2996,50 @@ void __mark_inode_dirty(struct inode *inode, int flags)
> >  }
> >  EXPORT_SYMBOL(__mark_inode_dirty);
> >  
> > +/*
> > + * If inode has dirty timestamps to write out, make sure flush worker writes
> > + * them out during its next periodic writeback writeout.
> > + */
> > +void queue_dirtytime_writeback(struct inode *inode)
> > +{
> > +	struct bdi_writeback *wb;
> > +	unsigned int i_state;
> > +
> > +	lockdep_assert_held(&inode->i_lock);
> > +
> > +	wb = locked_inode_to_wb_and_lock_list(inode);
> > +	spin_lock(&inode->i_lock);
> > +	i_state = inode_state_read(inode);
> > +	/* Written back while we dropped i_lock? */
> > +	if (!(i_state & I_DIRTY_TIME))
> > +		goto out_wb_lock;
> > +
> > +	/*
> > +	 * If the inode is dirty, next writeback will come soon so we don't
> > +	 * need to do anything. If it is under writeback, we cannot touch dirty
> > +	 * lists now so we handle moving the inode after writeback is complete.
> > +	 */
> > +	if (i_state & (I_SYNC_QUEUED | I_SYNC | I_DIRTY)) {
> > +		/*
> > +		 * Clobber dirtied_time_when so that timestamps get synced on
> > +		 * next inode writeback.
> > +		 */
> > +		inode->dirtied_time_when = jiffies -
> > +						dirtytime_expire_interval * HZ;
> > +		goto out_wb_lock;
> > +	}
> 
> [Severity: Medium]
> Does backdating inode->dirtied_time_when leave a stale expired timestamp on
> the cached inode after writeback clears I_DIRTY_TIME?
> 
> When __writeback_single_inode() later calls sync_lazytime(), I_DIRTY_TIME
> is cleared while dirtied_time_when keeps the backdated value.  If the
> cached inode is later reopened, dirtied with I_DIRTY_PAGES (so was_dirty is
> true) or queued with I_SYNC_QUEUED, and then marked I_DIRTY_TIME,
> __mark_inode_dirty() skips updating dirtied_time_when:
> 
> fs/fs-writeback.c:__mark_inode_dirty() {
> 	...
> 		if (inode_state_read(inode) & I_SYNC_QUEUED)
> 			goto out_unlock;
> 	...
> 		if (!was_dirty) {
> 			...
> 			inode->dirtied_when = jiffies;
> 			if (dirtytime)
> 				inode->dirtied_time_when = jiffies;
> }
> 
> Because dirtied_time_when remains expired, the next data writeback on the
> active inode immediately forces sync_lazytime(), and
> move_to_dirtytime_locked() (with i_count > 0) can place the inode at the
> tail of b_dirty_time with dirtied_when = jiffies but an already-expired
> dirtied_time_when.

Again, preexisting issue which will result in more frequent inode writeouts
than necessary. If someone is bothered by it, we could fix it but not for
this series.

> > diff --git a/fs/inode.c b/fs/inode.c
> > index f2003ae753745..4b13125f0678c 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -2052,7 +2052,6 @@ void iput(struct inode *inode)
> >  	if (unlikely(!inode))
> >  		return;
> >  
> > -retry:
> >  	lockdep_assert_not_held(&inode->i_lock);
> >  	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
> >  	/*
> > @@ -2065,14 +2064,14 @@ void iput(struct inode *inode)
> >  	if (atomic_add_unless(&inode->i_count, -1, 1))
> >  		return;
> >  
> > -	if (inode->i_nlink && sync_lazytime(inode))
> > -		goto retry;
> > -
> >  	spin_lock(&inode->i_lock);
> > -	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink)) {
> > -		spin_unlock(&inode->i_lock);
> > -		goto retry;
> > -	}
> > +	/*
> > +	 * If inode has timestamp updates pending, queue flushing them now as
> > +	 * otherwise the dirtiness could be preventing the inode from entering
> > +	 * LRU for hours.
> > +	 */
> > +	if (inode->i_nlink && inode_state_read(inode) & I_DIRTY_TIME)
> > +		queue_dirtytime_writeback(inode);
> >  
> >  	if (!atomic_dec_and_test(&inode->i_count)) {
> >  		spin_unlock(&inode->i_lock);
> 
> [Severity: Medium]
> Can deferring lazytime writeout here lose pending timestamp updates when
> iput_final() drops the inode immediately instead of retaining it?
> 
> When op->drop_inode(inode) returns 1 in iput_final(), it sets I_FREEING,
> skips write_inode_now(), and calls evict(), which removes the inode from
> wb->b_dirty_time via inode_io_list_del().  For filesystems where
> ->drop_inode() returns 1 on an inode that still exists on disk (such as
> gfs2_drop_inode() when SDF_EVICTING is set during gfs2_evict_inodes() or on
> iopen glock demotion), sync_lazytime() previously called ->dirty_inode()
> before eviction so gfs2_dirty_inode() marked the glock GLF_DIRTY and
> evict_linked_inode() wrote the timestamps out.  Without sync_lazytime(),
> neither GLF_DIRTY nor I_DIRTY is set and evict_linked_inode() skips the
> writeout.

Bogus. If ->drop_inode returns true, the we evict the inode even if has
dirty pages or anything else. Not flushing timestamps is the least thing we
can loose.

> Also, whenever iput_final() evicts immediately (drop != 0, I_DONTCACHE, or
> !SB_ACTIVE), calling queue_dirtytime_writeback() in iput() first drops
> i_lock, locks wb->list_lock, queues the inode onto b_dirty_time (even if
> unhashed), and arms wb_wakeup_delayed(), only for evict() to immediately
> remove it from b_dirty_time.

Yes, we can still do some pointless work, sync_lazytime() did even more.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

