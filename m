Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D5B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KrNh25BV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lDeIZ5aP;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KrNh25BV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lDeIZ5aP
Received: by kanga.kvack.org (Postfix)
	id AC4EF6B05B7; Thu, 26 Nov 2026 06:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AE36B05B9; Thu, 26 Nov 2026 06:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964C86B05BA; Thu, 26 Nov 2026 06:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1366B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:36:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD32280C71
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:36:45 +0000 (UTC)
X-FDA: 85477067970.14.61BE503
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94E4714000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:36:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KrNh25BV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lDeIZ5aP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KrNh25BV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lDeIZ5aP;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795693004;
	b=EhHARvO7L4HtGAh6U5tbketSqv9wGKlX3zfCgPlYn1nNZyAYlZgU2okDr16AyWsA9evsY1
	3k8HHIE52Bw7f12AMHv5YJePdNSxsyloeIqa2+dbN9gzGO1OwTDVDVdoQPZPgI7nAnmB51
	/O2o3OHr24/WRCZulCb9/azEae5x21s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795693004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXXZdtfXKLM3zYE0qG9EJihyMbjCoUyvjBI3IiYPtjE=;
	b=dTtOVnIuXqR3PXbp+F3I4zvV30O4U+CIWdklQngG/tN47NX6rvgc9EW0sJ4PSiC8/rREk7
	9kuggWz3YP5xaZHoHxQdaz1uWqxyh62Au87I4GNer74Cm1jFSKx7tTon/kzMe8umRe32lL
	d1KIbdOUy0MGdYz5pE+r7OvAtr0lCKE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KrNh25BV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lDeIZ5aP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KrNh25BV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lDeIZ5aP;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D04DF223E5;
	Thu, 26 Nov 2026 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795693001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXXZdtfXKLM3zYE0qG9EJihyMbjCoUyvjBI3IiYPtjE=;
	b=KrNh25BVC2/OYPvpReolTZb5rac9a7ixkcRpJgsakyctIYmY8FB9/Vs095h+ahZbB0GdxN
	rFq1npRLL4t3h3d5fEtDA3Xfpo2jD7sgVJqHjQX43ndqnx1mbIRElhHjY1JxiwbcvsKWi9
	NRweTstgQcYPiLdEF9q1+R7OSKvtqRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795693001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXXZdtfXKLM3zYE0qG9EJihyMbjCoUyvjBI3IiYPtjE=;
	b=lDeIZ5aPYmEBynilgJWe+CqP5UKEI2XdNd68R402BpY8aHkY1qsA//qpz1mAJV92XKru4O
	4Zf+JqhJbYPj/uDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795693001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXXZdtfXKLM3zYE0qG9EJihyMbjCoUyvjBI3IiYPtjE=;
	b=KrNh25BVC2/OYPvpReolTZb5rac9a7ixkcRpJgsakyctIYmY8FB9/Vs095h+ahZbB0GdxN
	rFq1npRLL4t3h3d5fEtDA3Xfpo2jD7sgVJqHjQX43ndqnx1mbIRElhHjY1JxiwbcvsKWi9
	NRweTstgQcYPiLdEF9q1+R7OSKvtqRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795693001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXXZdtfXKLM3zYE0qG9EJihyMbjCoUyvjBI3IiYPtjE=;
	b=lDeIZ5aPYmEBynilgJWe+CqP5UKEI2XdNd68R402BpY8aHkY1qsA//qpz1mAJV92XKru4O
	4Zf+JqhJbYPj/uDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A77BB134C3;
	Thu, 26 Nov 2026 11:36:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xH+xIMkZCGspbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Nov 2026 11:36:41 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3989A27DED; Thu, 26 Nov 2026 12:36:37 +0100 (CET)
Date: Thu, 26 Nov 2026 12:36:37 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?5p2o6L2255SE?= <yangyizhen3198@phytium.com.cn>
Cc: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] block: long udev open waits during cache teardown
Message-ID: <hvxissqup3n5tti6as2csdducwz6ywju4awgfozdwjimoplmst@shps625lugoq>
References: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
 <20261120-hassliebe-arena-kaufvertrag-3ac58fd0483a@brauner>
 <4effe3b8.6085.1a217879319.Coremail.yangyizhen3198@phytium.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4effe3b8.6085.1a217879319.Coremail.yangyizhen3198@phytium.com.cn>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 94E4714000C
X-Stat-Signature: 65ox1y8ehiqunzw9euoay4atecci9zdu
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795693003-940816
X-HE-Meta: U2FsdGVkX1+clKF8zBDP+UNvfkL0S2OZnfsMnrujmuusYicjFiv5o3kD1ZkfWuJ4RZkAMY2QhNg2ARQAdiHqhlanRa+xUAgOukOqf/3N6BrcxZqsaIb3SbNdrzS5OqlzK92CLbHr52irksn13VhlaSv3Jysfp1fsfKNmhk+uUDFP/1PtDV77PB7oaEzYMvehRWhJpGPFNZeT9DgfJSJaKgXaLamDK4duVcxg5uhufbY8Qk9taYnsHYcb/nuZhHzyjFoWtDUQXrL5O2RdzL2Vr2cAWfDpGHHvWW7FvTcIvK3Mmab7o8J/3isTwd2s5M7a3GHvANwTdomrV2+8ggm7H6k/gh49ZzfAr+GI+Zx87nA1Bi+q7XLKyKnJxjcEL6n5pRIXA8LN+kEcZFu0UcDfqH+LHUZil+kibItEpmUl5OapBtH1dHSLur+v3qaby8/Co3KHeseKFwL41YEoisrH2pjlIttQE6NnPNuPgehj2h4ZHe3sr7j+AMDHHhrK57k7xAvgNmL4EmiZ2kInOT+DNOtvQeOIu3GdaMeQgFSq2vvMHgN3EbsnQXkaeTiRaNAy1uTW2lVeo307vxRu+0Y7bi0dU4mdBIBPm9Xwf+v3qtx04I5w4oVXksyssVcfbh4taOqNI4fxJ8jKeGDmYLPrmXK6MWD0k386Cydj6EQAC5ZSLpxtTY5ee+vUgemYVo9/ulKEyaiGHrEt/8sQKU0Rj0wDATT4HIIAJJJnSvCT8eSxB/nnUskR/PofLeOUSRvvH4EXOkpCqt7LdYU/ZmjpFC+lCCzQdhXUWcGRDSsNwBQoMkJi6yvUNVeK4NTkVhi/dzmM1Jpfl+buNmtY5JOz1LEXDaMyDyvVVud8a8xRJpAXtocSxB5CaceExgoUSbTRNt6b0V8VWc4aH846aonnGC9YfmbwKWC0gRN7q/JL1jVkYL4N8xwWD/nap/zNpQa8lYXOQ8d5GgtBNQxsTPf
 q0ILCapY
 uptdailMtbTg1OpcGavZk+5O3Ybeyj4BTJYfqmovguH0VhQIn9ENb+J9Bc7dLvZoWI0WtWZrNtAB65egIBvCqN0qiXqY++wgzAi7vPf0rKY4kssM3Sx1MaxrY1y0zBmzOQKLmXgD6YVFGJ3rOrrNVcg4KV5hltpCyhf6m4YLUyCoHliu81vvu9q4Y1QtXyKfJ0lxUssNs1YLqBfvKSA/OCGeoEu4tLfqZO2OYSut0xD0PZXDBmIYt7pttVAnDbdxT4NtN2jRpdUBC9KOOYol6MS1GsiXtYzkXkZ3bdqMW9kX8vaA+6jyU0WfmH4sy4xpXt1/4rUhU6s/68/Z38a0daeFVFfb/QFEjBsb093KJZZyvZR4BRsHIgwpy+xfKO4kdGwLLUMypaG7At/HguG1gfiqm5Kch9CTeulVw7GRFfqidNqoqKtIDg4xuyn8h3+tB2ygNDuutLOwez9+XmPfEfCBCHFt4htmiwCbmN23mazCXlxzD7NivGLmwl5kogjE3XKnJi37CgPlBfUJRKGN6g0/nwmYglSki1ehMjbiHFV8QYcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 26-11-26 19:04:50, 杨轶甄 wrote:
> Hi Christian,
> 
> > If that still reproduces on mainline it's a question
> > about the bdev release locking.
> 
> I reproduced the long udev open wait on upstream Linux v6.6 and on
> Linux v7.0.14. On both kernels, udev blocked while trying to open the
> device as mkfs.ntfs was closing it after a full format.
> 
> Thanks for pointing out the impact on other openers. I agree that a
> udev probe closing its own file could trigger writeback and evict
> cache that another opener is still using. I'll drop the __fput()
> proposal.
> 
> I'd like to understand the locking requirements in the block device
> last-close path. In particular, why does kill_bdev() need to complete
> while open_mutex is held? What state and ordering requirements does
> the lock protect during this cleanup?

The page cache cleanup in kill_bdev() needs to complete before we allow new
openers to open the device and open_mutex serializes that. If the cleanup
would race, we could destroy data the new opener has written to the page
cache of the device. 

> I'm asking because the device mapping can still contain a large
> amount of clean page cache after the early sync. In my tests on the
> vendor 6.6 kernel, about 805 GiB remained at final teardown, and
> the truncate took roughly seven minutes while udev was waiting.
> Could the release path be changed to reduce the time open_mutex is
> held while preserving those requirements?

Perhaps. We currently do:

        if (atomic_read(&bdev->bd_openers) == 1)
                sync_blockdev(bdev);

in bdev_release(). We could enhance it to:

        if (atomic_read(&bdev->bd_openers) == 1) {
                sync_blockdev(bdev);
		/* Still the only opener after the writeback? */
        	if (atomic_read(&bdev->bd_openers) == 1)
			invalidate_mapping_pages(bdev->bd_mapping, 0, -1);
	}

This is safe to run without open_mutex and should get rid of 99.9% of pages
before we take open_mutex and do a reliable cleanup. Feel free to submit a
patch with this change describing your motivation.

> > And mkfs can just fsync() and POSIX_FADV_DONTNEED the device itself
> > before it closes it.
> 
> I've submitted a patch to the ntfs-3g project that calls fsync()
> and then posix_fadvise(..., POSIX_FADV_DONTNEED) in userspace
> before closing the device.

Good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

