Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A964606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHwPePLG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WgJMAj7z;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHwPePLG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WgJMAj7z
Received: by kanga.kvack.org (Postfix)
	id 3CA9D6B05B3; Fri, 27 Nov 2026 12:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1956B05B4; Fri, 27 Nov 2026 12:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6CB6B05B5; Fri, 27 Nov 2026 12:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB3466B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:16:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E04D801A7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:16:58 +0000 (UTC)
X-FDA: 85481554116.20.A09AB3E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id D77F54000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:16:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IHwPePLG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WgJMAj7z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IHwPePLG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WgJMAj7z;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795799816;
	b=6EX9JYEINdVjXImxczHY0PuCOEeb5gRWJAUaKBMys2ckH9DbqxnTTXls1t81aGs+mA5txp
	mfd8ztclrWHdwPOg4umm22lDnW5JeKs6IFprOe+om4FqGIMurJPow8arguBIjVl/t53Dp4
	nf7fLPGU34Blx/sTwEFzYigFMpV/YLI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795799816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAzXSIrHc2uUhJu/CxQuhNZ0je5ZI9pQTwHRwSeTS7g=;
	b=hJIweKojKdf465Bxlss/GSVm8APOyCtr7/JGv0DqT0zIQecB84jQzaGyYijM/M+O5ZwgKB
	xhBU0C+AUe8VEyrzhYfmmvHBkdaIq3aZlhv5Gy6i56KY4jWrzMgTYqBuxx7K0Mi961XQ5j
	COoXI6ei+0l4bSeAUagrNpIvodkESpU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IHwPePLG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WgJMAj7z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IHwPePLG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WgJMAj7z;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 283ED229B0;
	Fri, 27 Nov 2026 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAzXSIrHc2uUhJu/CxQuhNZ0je5ZI9pQTwHRwSeTS7g=;
	b=IHwPePLGKduelpYcdvMWPc1pbPT/wqwz7lJKrydcMBw0aFpCbyz+nBWbzIMLiZCYlXvqBZ
	ivXQhPpaAmUwYqVneSacfyEd/JN4UPbZl94lFpgBiVhGy1dbcX2qlKhJzeJCXMJl60Ofo5
	iDgfeAXoEgT33VlI5s8istPZl5Nq9Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAzXSIrHc2uUhJu/CxQuhNZ0je5ZI9pQTwHRwSeTS7g=;
	b=WgJMAj7zC77qL/I0jIS/1O9wDaSFwMAIvN5sdfbs3gXi2bD+3d9jEygZ/yFkDoF8UKuGYp
	sjQA9z2VqOQLYlCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795799814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAzXSIrHc2uUhJu/CxQuhNZ0je5ZI9pQTwHRwSeTS7g=;
	b=IHwPePLGKduelpYcdvMWPc1pbPT/wqwz7lJKrydcMBw0aFpCbyz+nBWbzIMLiZCYlXvqBZ
	ivXQhPpaAmUwYqVneSacfyEd/JN4UPbZl94lFpgBiVhGy1dbcX2qlKhJzeJCXMJl60Ofo5
	iDgfeAXoEgT33VlI5s8istPZl5Nq9Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795799814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jAzXSIrHc2uUhJu/CxQuhNZ0je5ZI9pQTwHRwSeTS7g=;
	b=WgJMAj7zC77qL/I0jIS/1O9wDaSFwMAIvN5sdfbs3gXi2bD+3d9jEygZ/yFkDoF8UKuGYp
	sjQA9z2VqOQLYlCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF8DD13432;
	Fri, 27 Nov 2026 17:16:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OEivMgW7CWtXAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 17:16:53 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 814A9510B9; Fri, 27 Nov 2026 18:16:49 +0100 (CET)
Date: Fri, 27 Nov 2026 18:16:49 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 3/8] fs: Basic infrastructure for offloading inode
 reclaim
Message-ID: <d3rd2i3q57x6vbluvmaoay5yp3pliqj4e3nlhvckcckagqpelj@pobjh5ixkbpa>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-11-jack@suse.cz>
 <sashiko-outbox-233312@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233312@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D77F54000E
X-Rspam-User:
X-Stat-Signature: 5pbnqcy8oqnannfb7boyoz3ph73wih1b
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795799815-278766
X-HE-Meta: U2FsdGVkX19MW671ARKok7S3aYiVNsYNBosHVhE8dizM7YqLv2WXf5/l041pLTqMLK2nDZCvuGUVQpfNtwwxU+Q2XHM3gibHtHFDaF2snJnQIjMDR4Bb4tTlMPUrMZTXvS/YG7n/pdCGKjwJHXrJv8gmVkUVMjEXyNw1vrbM0euEZp51IMR9zodVDWR3TjdNfd6mniCDwbBaw8MQE7B9tVnqy6FvkK/EzcTiZlME/Yopsjny41YbgQTK9l2reA0f3Pz11AXkEeWsXd1sAnbVdmRUz3Cy4lrXiUq1302SOlKBdsZIlV4vTiwkwzSvD9T4JAIOvDt+fpbTiTme0blQpdQ+99Ic2zcUSRORa82x0gwpHuurQKJKzhvQhl/Q8aN3wCc9E0zpSOBMXe4YKkITvXNJsTj+KefvawqPQ6B3hN2wt0VitKoN28HphO677ypK5nyIHN+SJPmwZlK406P8FzbVvdbuueXQEnu8FaSzhEI+A9iKKXxBxYYf7RG5/oOsR7Vi0g+FF3UWMGeROyOA9K+dK6hs2D2KXiG4ZkdedKLjFN3JlXZ9Xagnbe0prLZSQ0EjKAyRiypyDn+aT6AU/frozPMqfipA9CN06ZaM2BTlhjiEU45p2n8wETU/Zb1aMU91IbxLNJy+vQeSJuImYZ66Fl19y4nrktqEapL7zZF8cr2BgBJWdrobP8mq+ZfAooIfd6M2pFilOf84COkgw8z57vRrW4j8/Nw1beJ7TzjLORYwZmm2UBysX9CxxXdsm5qeQNj9+jbvKKknRnBGX+e4WmAiDTsapupix4fA6jq2Cu01R1XfSf0ocCpRmqVUic7P2KOgKnUgojLByoUz21ZaWzA5kx3x/FiOdIA5OvTnAdexKtgK8hjdO6dsrbP5ZSR9gthPqR6C2DdDGR+lxOmyph9MV6YnnzqtOnEg5q1Lrl9ilj8s1dv3pZul4RNYRmVaBNPp/xqXyeREXdC
 4W1bw0DN
 miUDfMfeHt1kuYGf/LVJ8X0VfW2/pxcpmbMVvkOW+p8KDXQtmvc5TtxRIc4JgEKJASta0mIkh+2gZXR4jZSbVXVzkBgUnjm7rKDDG9APtvHkwziY45N03CSURCZ0grazHA6s2L0zCrmPFe8Fo89Avhy8faVw4MBfebJ4YsEpjRj1YA5zabuFU+FBt+mJAnG8dyG1k4+Crw40sz5aap6hGVXQCV8SezRjW34Vsq7HC8BRTTFkP3iJQlgn0q8F/jfGSiJztsvc/IWszg7l3njXdz0h+EonaDg5GwUF1X0hzt7cy8kZc7xmcMkMZj+kos+lRs4EndEo0w+WXQuw6Lvq153jB5ALkFIRK613UYR+QWpKLbW/Izzr2JESVlFtpd8QNVCaqwPFDVOjnioqD6XKW79lI12PmveylOIFlHvWHm2ub2x4thrpE/Bo91FYT+ffwUzANNwMy80mGgVO69ADyGlQnqnCqDxF0kZWIi4UPWXvKNqlC93VFnLf8yCMepQaEqnHoO9rlsuMqpqT7HppuqZT/p6m3yWIsnel9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 12:00:03, sashiko-bot@kernel.org wrote:
> > +static void queue_deferred_reclaim(struct super_block *sb, int count,
> > +				   struct list_head *list)
> > +{
> > +	int id = get_deferred_sb_id(sb);
> > +	struct deferred_reclaim_queue *queue =
> > +					&deferred_reclaim.queues[id];
> > +	int i, wake_count;
> > +
> > +	spin_lock(&queue->lock);
> > +	list_splice_tail(list, &queue->list);
> > +	atomic_add(count, &sb->s_deferred_reclaim_count);
> > +	spin_unlock(&queue->lock);
> > +
> > +	/* Queue works to process inodes we've added to the list */
> > +	wake_count = DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
> > +	if (wake_count > deferred_reclaim.workers)
> > +		wake_count = deferred_reclaim.workers;
> > +	for (i = 0; i < wake_count; i++) {
> > +		queue_work(deferred_reclaim.wq,
> > +			   &deferred_reclaim.work[id]);
> > +		id = (id + 1) % deferred_reclaim.workers;
> > +	}
> > +}
> 
> [Severity: Medium]
> Can queue_deferred_reclaim() serialize deferred eviction for a superblock
> onto a single worker when inodes are queued in batches of
> INODE_RECLAIM_BATCH_SIZE (16) or fewer?
> 
> Because get_deferred_sb_id(sb) returns a fixed starting index for a given
> superblock and wake_count is computed only from the current call's count,
> any call with count <= 16 sets wake_count = 1 and only tries to queue
> deferred_reclaim.work[id].  When multiple prune_icache_sb() scans (or
> single-inode queuing from iput_final() in commit "fs: Defer reclaim of
> unlinked inodes") each add <= 16 inodes while work[id] is busy and already
> marked pending, queue_work() on work[id] returns false and the loop exits
> without waking work[id + 1] or any of the other idle workers, even if a
> large backlog has accumulated on queue->list.
> 
> Computing wake_count from the total queued count (or advancing to the next
> worker when queue_work() returns false) would allow sibling workers to help
> drain the queue via get_inode_reclaim_batch().

Correct but I don't think adding in small batches is going to be all that
common that the lower parallelism would really matter enough to complicate
the queueing code. We can reconsider if we find evidence my gut feeling is
wrong.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

