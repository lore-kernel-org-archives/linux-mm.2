Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07BAFEFB5A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB4A6B0089; Fri, 27 Feb 2026 10:16:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474066B008C; Fri, 27 Feb 2026 10:16:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A18A6B0092; Fri, 27 Feb 2026 10:16:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 238656B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:16:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC17B8C12D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:16:12 +0000 (UTC)
X-FDA: 84490587384.20.53A4277
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7397818000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:16:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2FuJYGnS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=euG43Sf6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2FuJYGnS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=euG43Sf6;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bT/5Ey+UiP9GkCUmIfSuz5KQqLzi1KyS/67r+nhyFs=;
	b=PxRBaIr+LGefI2FXLIYc8nABkCZLf0HOUVVbMO5FoSRh+SRhnS3q7b6i8me10wl3ZyoxwQ
	sTkPl8d1Ja5OiusbbMMas+taACg5abGj5we1JK/xvLt3OF3lkNgitYM9OChWcbgE9dMfzU
	XAmbPXnxRVvMA9Ih8MoUTEBIoIINkiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205370; a=rsa-sha256;
	cv=none;
	b=ibvLlgV3993KFk09SoW7a32FwplpcFyDVOjJZDDXbhFRlfEe6lPQbr4lPlBqZHssDNOAZQ
	B7NsfGnSF03FvjaW343ciAzKSlU6bw1cV1XOtpZRZDSrb0eMXTV83wO4lkaZNbHR8WEWWq
	1zZ6Pv7ax/5hynJzk1phxNUePR+tX5Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2FuJYGnS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=euG43Sf6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2FuJYGnS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=euG43Sf6;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 345DB5CFC1;
	Fri, 27 Feb 2026 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bT/5Ey+UiP9GkCUmIfSuz5KQqLzi1KyS/67r+nhyFs=;
	b=2FuJYGnSwUJoxXJIPxzWy6iFa8O7PJR2pTuSP7UVBdgGiD9vKncPMG6CgPzCKTFxIKlzPW
	z/4CRcsr4Em7WbXSVuwoKQrQxfyPlZWl1qkH0ytj5QxrAjs/ZXbPr41RF4ER4VEvKPjU/F
	LlND7a++E9FOJhZBVXMY8PQG7sXFSqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bT/5Ey+UiP9GkCUmIfSuz5KQqLzi1KyS/67r+nhyFs=;
	b=euG43Sf6v7MU+Xhf66zBmyXAAuu8uH+ZbLtijhXAJUpqP3U0Ki2m/xLStH40vWH2xOzVtM
	EWXK9XSHIVpFJKCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bT/5Ey+UiP9GkCUmIfSuz5KQqLzi1KyS/67r+nhyFs=;
	b=2FuJYGnSwUJoxXJIPxzWy6iFa8O7PJR2pTuSP7UVBdgGiD9vKncPMG6CgPzCKTFxIKlzPW
	z/4CRcsr4Em7WbXSVuwoKQrQxfyPlZWl1qkH0ytj5QxrAjs/ZXbPr41RF4ER4VEvKPjU/F
	LlND7a++E9FOJhZBVXMY8PQG7sXFSqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bT/5Ey+UiP9GkCUmIfSuz5KQqLzi1KyS/67r+nhyFs=;
	b=euG43Sf6v7MU+Xhf66zBmyXAAuu8uH+ZbLtijhXAJUpqP3U0Ki2m/xLStH40vWH2xOzVtM
	EWXK9XSHIVpFJKCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B2333EA69;
	Fri, 27 Feb 2026 15:16:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bSiECjm1oWmDHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:16:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC09AA06D4; Fri, 27 Feb 2026 16:16:04 +0100 (CET)
Date: Fri, 27 Feb 2026 16:16:04 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 05/14] pidfs: adapt to rhashtable-based simple_xattrs
Message-ID: <zfwhp3c4mtf4b7gw4qmxayfqrzf4h723s2vfjpfid62yfjz2zt@6ali24hx3ihp>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-5-c2efa4f74cb7@kernel.org>
 <qxctwu77wp7gv4ua3hn6kg7r2vt57laomn3ebjisemzzaybagy@mvoo2wpvu2ux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qxctwu77wp7gv4ua3hn6kg7r2vt57laomn3ebjisemzzaybagy@mvoo2wpvu2ux>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7397818000E
X-Stat-Signature: tq4tj3anehdmm7od55usz8ezxcq4ox5g
X-Rspam-User: 
X-HE-Tag: 1772205370-764531
X-HE-Meta: U2FsdGVkX19Z58cHU4Dsn/74+BybJMVC+zrC1mWDmxpJz4lRXdb6Ia+9NJweIJwpYpfIyB8LfmZuNYdkpBTxdP7zqGc0T0P7s8RjHSONhUkEK3sIYvmD6jlgEUjip6soSLQaHjPatzo31t3pMsLfSshRvcEPfljgfxf7Qrq2CeDeOs5hmAH+rDoH9Py86fGW2uAm443G0IamjNtJLPy2NE4KolcO7QNhI1nfowqDiU4yu0QtYbU7n8kJUdSkZkJr1itbBLGyK/p3cHxexxfXo6TVS/ieIKedd7PfjMcpgkXvAiRjxkScopCEWtv2EKjqZRkG6SmBtIjACla/fgjwy5wh4C9PPWyEhl36oXii7co9URE4hEGuMNczDU2hvzQgyiSNjR98+MFKttMV7S7oR91b2XND62VExuN7wLqvc1yZ6xDhwjSDHJwD8CgThBNTpSbLTv30R4nqghBulywj3NM4TXv2qxnNnjbFLoWDTbeuiq3BJTCf14zcGlXoHAEab0RYDTt+/0JL8lqiWWAypJH5zB8tyS/gFbiWEQlSLSDZcNKSxweGGTEGHahNujTA+5KUReqp2RrvADfueypEKeMO4BvmWxIMEpwnUOK/lSFnMpIsOy33MSQ4+ex/HDHD2NQqNXcTcpP7fGUBbnYmaw2j0AEg8cqVTOLXSgBvgaBlOLFYubWA8ktGTBBkRq4YpEb/n+2mabEamHHeQGx1nwT2yp/MAclkpIcySk+JxR1pvn1euLgk9fk7OCeF7FmE0D4r90ZG1hJXQGftIYs0aHzXp4uedrNoM7pf/RSz5iNSu7Rnbs9wQJIez8dXIk/tKfAoJVdkdtsgCM6Yr9WVb+YRrHq4iiGdrfKiChFcw2aMpWh/X4Z/6RDTmIn/VIwSDlhQYGHhfrQ+wgg1d/mpL0GmYFYQHLpFBIBoYt5qF2wMyn6YrvE1UYKbqPeDCvWUkNPGZv3RGFkDei/C5bW
 H3oigr/i
 XUWjwFLUnOiWigc2VndKffrEMpVOUyho+6/gPL2ZGQSX5zZ+mMJQzVtQcR+f/9JLb+ZWT5MP7ppCqpD9yChSuJBKT0bDmJRNUISEuzSF2xoW4cONqQeIZ5h+GK1TARt2SeVNESSzh/DnWoq4nEVyIC/9KipG0/Sjw2baJKXl22XSdy5Ya9kMjTn3Wie7yW3qFH9aPy9KKe8C5t+4YGoN3jBk+alny3n4uWM8jwrBTaPV3IQQHBSpJkcJnv6AUouQEE0vLBDihmzwpXUtpXFdfl5bPnzMPg1MTUbB3k3QRwHj7VJlbr8PDy4Vn3c3pNGHtbQpgaFMENLtIDxJtVk5LiP0VW/WYJ/EK/MuSrzIRy5MxAclX3JTezMbjt93LLT3i2hs1y5zobMQ8lZnzcdhtpFeKh1q+XUBLG+Fg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 27-02-26 16:09:15, Jan Kara wrote:
> On Mon 16-02-26 14:32:01, Christian Brauner wrote:
> > Adapt pidfs to use the rhashtable-based xattr path by switching from a
> > dedicated slab cache to simple_xattrs_alloc().
> > 
> > Previously pidfs used a custom kmem_cache (pidfs_xattr_cachep) that
> > allocated a struct containing an embedded simple_xattrs plus
> > simple_xattrs_init(). Replace this with simple_xattrs_alloc() which
> > combines kzalloc + rhashtable_init, and drop the dedicated slab cache
> > entirely.
> > 
> > Use simple_xattr_free_rcu() for replaced xattr entries to allow
> > concurrent RCU readers to finish.
> > 
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> One question below:
> 
> > +static LLIST_HEAD(pidfs_free_list);
> > +
> > +static void pidfs_free_attr_work(struct work_struct *work)
> > +{
> > +	struct pidfs_attr *attr, *next;
> > +	struct llist_node *head;
> > +
> > +	head = llist_del_all(&pidfs_free_list);
> > +	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
> > +		struct simple_xattrs *xattrs = attr->xattrs;
> > +
> > +		if (xattrs) {
> > +			simple_xattrs_free(xattrs, NULL);
> > +			kfree(xattrs);
> > +		}
> > +		kfree(attr);
> > +	}
> > +}
> > +
> > +static DECLARE_WORK(pidfs_free_work, pidfs_free_attr_work);
> > +
> 
> So you bother with postponing the freeing to a scheduled work because
> put_pid() can be called from a context where acquiring rcu to iterate
> rhashtable would not be possible? Frankly I have hard time imagining such
> context (where previous rbtree code wouldn't have issues as well), in
> particular because AFAIR rcu is safe to arbitrarily nest. What am I
> missing?

Ah, I've now found out rhashtable_free_and_destroy() can sleep and that's
likely the reason. OK. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

