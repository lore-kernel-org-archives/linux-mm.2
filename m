Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101B2606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=R9tqx0ap;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6rdCS3uh;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2zpsBrb0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tYGG06th
Received: by kanga.kvack.org (Postfix)
	id E09AE6B05B0; Fri, 27 Nov 2026 12:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA8F6B05B1; Fri, 27 Nov 2026 12:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB666B05B4; Fri, 27 Nov 2026 12:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47BFE6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:19:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEB9D1C3B51
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:19:41 +0000 (UTC)
X-FDA: 85481560962.04.E746D8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A82DC0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:19:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R9tqx0ap;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6rdCS3uh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2zpsBrb0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tYGG06th;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795799979;
	b=PaEjLT6Wp+8Nfx8p0pkAUc9XKbXj9rKValuLpH0YM9vlg1W7nEzUaTCqdgRDUgd4PnUQgp
	Zj6ThUYQc9JruyGQuzU7yKzyA2lvP0c0H1dzndBUD5d4b6fVYGvr/4WS+Tctj2h7jpF1S3
	RGT2yB1P7Ad52XTZNC9Kd264llOEOUE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795799979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eEaGQs+qlzFDOnTZyKR6/iEQUt0A17EVipFCA5PZns=;
	b=B2PioIA/nBUWBjdO75BRZIePXpo1YNHNZPsRIGwg5W9fCOYVQZhLsj5lDy/WumGd/LlaOv
	syb6hAabp1uYwi542SOISNhUJAhzsVnZj4zOs1TSsxx9G+Ccs/xAitEJyaTaoeGH5VMaZ5
	S3YALGhLXJjiuHxkghQMk3ZuJAQkWJU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R9tqx0ap;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6rdCS3uh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2zpsBrb0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tYGG06th;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11AB4229B3;
	Fri, 27 Nov 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5eEaGQs+qlzFDOnTZyKR6/iEQUt0A17EVipFCA5PZns=;
	b=R9tqx0apWJGnNiFVKnIgJX7kf0enA+iHKa9iU+m+lujnRAmeHr/RVWssBXy4bm5h50zM/N
	W+UMkuXoSxQvXDJfHNl8E4DN4CrwJzrw71+7EfdnCgeklY9/Kn+uDIwe4nb2OBLWkEQoz6
	/QxWv9OZK7mK28E7mvFEHV7UumDrM0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5eEaGQs+qlzFDOnTZyKR6/iEQUt0A17EVipFCA5PZns=;
	b=6rdCS3uhdntV0GPzxx9bemPkRVt5e2wLZryT39CmtQYsuWsnATHC/jyyFNW4rvuPatvuWk
	Nj5p/svxUYtZh+Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5eEaGQs+qlzFDOnTZyKR6/iEQUt0A17EVipFCA5PZns=;
	b=2zpsBrb0xlk4JmqXOUkxAhNu152KICb+DWgtLP/fPOB6I15TTW3QUeLINWqA0MGvudDFGP
	wiKVCd2DFq5FjYXU7r/ZSeVuAjcFCeTcaXSzXGRtoDwQBcHYe8u54j3Er5nR/dPp4mqvYK
	pfgAQq278GOt4ugC41J/QC0oL6sN4RY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5eEaGQs+qlzFDOnTZyKR6/iEQUt0A17EVipFCA5PZns=;
	b=tYGG06thAG3zeOLexa1+0RNFEz2x0ndtWUp+2ycm7wf54LviMbkLEzQ3LrO0GRoan2zygF
	tr0tXYBrHn9escAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9CDA134F4;
	Fri, 27 Nov 2026 17:19:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZMz6LKi7CWvZAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 17:19:36 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 625E5510BB; Fri, 27 Nov 2026 18:19:36 +0100 (CET)
Date: Fri, 27 Nov 2026 18:19:36 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 4/8] fs: Defer reclaim of unlinked inodes
Message-ID: <d5g4uper5qb7gmypl7qokgr6k6m6ave6vb5u4p3zk2pwyqskvd@422bmdwvrqs6>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-12-jack@suse.cz>
 <sashiko-outbox-233313@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233313@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Stat-Signature: xx7zj79p4yssyb38f6ghoqg6jf5y37m1
X-Rspamd-Queue-Id: 9A82DC0004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795799979-616395
X-HE-Meta: U2FsdGVkX18DtWPbjbRJOKHdrMJM5gQWPPVwEW4Rk8K4lNdefc8MsnYJYVe7Nnzp/XB2Hlkqm1D+weCvBtN/RsIwWq9gCsN4fJhbi2vKkm+KYOVbkyq2Yz9fTOqHXikGcCkdxVVBdGOr3JsRsoUBrO6V6K7t/WwZX9gqRn02tfOVDiVAS+YZ4TRB8hSBvqB3ASSJeMr+ID4CDFZRV0kD2Cpa41Aqln/G0BNNIKW0Yu/pBzQi2tU14ylykeu9Pm7BU2lWm6R0pe5dY8Eo3GcegmvjBjY4fReEaqFfDVPbiQHn2Dmiqa5Nd/mUW3WCN+v9SI3vy+hc8R9UY8b7ceDA+gJCPTDzi4lrfLYNUe55rHNDobEUGSIqfNMJ6bbjnvjGZUkPhwYO+Exdb2O5R+FoVdA5nIU1Ds2PN4QKpVURqfObezRPssd+g0ldQFf4FX9d0YgvryglxcyFZyoGG2mfX/NvzLISVUIt0Mg5Qm0IXM8ZU5xvY+l8m05yb25ClR67zpGi2VAJUo/yGnfN+SuOuCvTLaA4SgGLKYva2FPgOt1/RbYJm5IS+mmrn2eZhe7rrG6AGGcncrSIiw6mBCUkFNZ23JUzoO7ixdabnOJ6f80jbMMqrNcscJi0DzX0rfCttzZcFGCoD/ZWy3B9hJUSUQwxcUd+b/ftnm53zfHh+I3NmTK6Kuon0E2imFTXgnbZv49/YVhsXoStl5e6LTVMpAJiO+4pfpRIL5sK9dXFnsRUN2AzQpAWlUYIvmmhKM7MO1+ePzonYcI3IQcbMUDLbexUWhTUoQPTh91De/Y3c6kwm5Rll/qNRHPIdYmSTT2Wmb59pI9M8mUx+cLXHvNVWeloXilnT5ipBdSG1DR2WCwhxdjzyTiBSQaTBSYlZD/JnzvcHZ/Z6JT634AB/OetAH+oNn9/Qk1SwLJRr8Q0Oc1B3mvjTHJfwE5qb5swPTQSguONGTeOyGDYFmP27pe
 5mVvU2qt
 nn9JJv5aAhLtahJAL/gI5jHO7tXkg8cAGfUOyhDspPjfK6BldU1mIYLTbjoMkifWSR26DA7RFA+VZsROmacrpLAVu0HW7N2qF1ra+ULyX5xpxbyYSs1sm8ZChMjBjSz+BSRrRj6+OzbYEdzkshLGVhvnHwnsbqGD//9uBTELeSyO9DZFJ+eaRXZSQP1Ui6dNvXw0QbIkYCIIo/kJ9lNIrUSh+ExN+ffah+sNc4A/Dc8Jy0hK6bvfGHkFokM8Ggf6KxpUbEVK0ZU5RaGMVl9dptaSfYlm6sOmpabPiE8eiTbUI12u36FrNaL4IIVqsCzazcnHHfeM1MQUOh8XTFy5gNVBEhPwHCINd4JxfH4qud86pDHeNXd5tAs3LhwZn420BmXdeNvryvSomJR/bKT2A+5a55L5XJeVMZ5TjAS8AXclIIL1KK68NsS4oa1JWmIb9CmjR0Um6FIHaTw7Ed9W9VA6a5IauiWU4BfxSQWFbIT5xAl6a0mDt2a90G4s801/J82F9Pesfa2NBdFw6DebjmgoDI3fEXIhLKpgd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 12:00:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] fs: single-worker serialization in iput_final() via
>   queue_deferred_reclaim()
> --
> 
> commit 8449483727b2bbcd575fed1bb97c8ea7882097a9
> Author: Jan Kara <jack@suse.cz>
> 
> fs: Defer reclaim of unlinked inodes
> 
> This commit offloads the eviction of unlinked inodes to the deferred reclaim
> workqueue when the last reference is dropped from a memory reclaim context.
> 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 8853eb6015dc0..2977d5f1382b9 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -2240,6 +2240,23 @@ static void iput_final(struct inode *inode)
> >  	inode_lru_list_del(inode);
> >  	spin_unlock(&inode->i_lock);
> >  
> > +	/*
> > +	 * Are we going to delete this inode while in reclaim path? Likely
> > +	 * reclaim of some object (e.g. overlayfs inode) ended up dropping the
> > +	 * last reference to an already deleted inode. Offload the eviction as
> > +	 * it's likely to require memory allocations and block on IO. Since
> > +	 * this eviction was triggered by a reclaim of unrelated object, the
> > +	 * inode is already outliving the operation that originally deleted it
> > +	 * (unlink, file close...). A slightly longer delay thus should not be
> > +	 * observable by userspace.
> > +	 */
> > +	if (current->flags & PF_MEMALLOC && !inode->i_nlink) {
> > +		LIST_HEAD(defer);
> > +
> > +		list_add(&inode->i_lru, &defer);
> > +		queue_deferred_reclaim(sb, 1, &defer);
> > +		return;
> > +	}
> 
> [Severity: Medium]
> Does passing count = 1 to queue_deferred_reclaim() here serialize all
> deferred unlinked inode evictions for a superblock onto a single worker?
> 
> queue_deferred_reclaim() starts at id = get_deferred_sb_id(sb) and computes
> how many workers to wake from the per-call count rather than the total queued
> inodes:
> 
> fs/inode.c:queue_deferred_reclaim() {
> 	...
> 	wake_count = DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
> 	if (wake_count > deferred_reclaim.workers)
> 		wake_count = deferred_reclaim.workers;
> 	for (i = 0; i < wake_count; i++) {
> 		queue_work(deferred_reclaim.wq,
> 			   &deferred_reclaim.work[id]);
> 		id = (id + 1) % deferred_reclaim.workers;
> 	}
> }
> 
> Because iput_final() queues one inode at a time, wake_count is always 1 and
> only deferred_reclaim.work[id] for that superblock's hash id is ever queued.
> When reclaim (such as overlayfs dcache/icache shrinking) drops the last
> reference to many unlinked upper inodes, the remaining workers in
> deferred_reclaim.work are never woken, throttling background inode deletion to
> one thread.

Ok, here we'd be really waking only one worker and I agree some parallelism
in this path might be good. I'll think a bit if we can improve it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

