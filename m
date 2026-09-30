Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0A4CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A516B008C; Wed, 30 Sep 2026 11:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC226B0092; Wed, 30 Sep 2026 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA8D6B0093; Wed, 30 Sep 2026 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58B576B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:47:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF8E6120133
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:47:39 +0000 (UTC)
X-FDA: 85270858638.03.BC3E432
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7A22F4000D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:47:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kbnbRj+I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iezzI9hD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hU2ovLJx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6O7KPyP1;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790783257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=lASx7GuBR6iqiSHJF1V3tI5z0VjNqXxOvQiCJeHtjcykfW9+HuzKy97cxmzQIdsoisLMa0
	wS3IYpPWaQ3kJlXWi2oMQDR+k+T6GIvJRC9miDl30SgOxtQEiYkVymM7LVk43+9QffDSee
	YpRuNpVjhl2mL8vT5HA8oumoGo3Yv+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790783257;
	b=qgM/kONTsyyB+x4PlCc/fxMfSyXeqCEw2znhZsRA7lpa+PP1SgP51Q4HSlSfN3Nh7P8cKs
	NzKpjZjAzjMETCtRUAlCEhd9hHxbSvA4iAoVAGtcrJuP6NlcSiOKBy+eGhBkp3ln0dIukx
	pmnZ5iNPYSLJ507LsprlTRQGkoE5KuU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kbnbRj+I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iezzI9hD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hU2ovLJx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6O7KPyP1;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95ADD21D7D;
	Wed, 30 Sep 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790783251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=kbnbRj+IixvFQRj5EbeHLkwt0DIzrLadWWg2fQURXb9XsCxuJtMMIE1cSeNJyjKFIhJ7LJ
	hlYp83Gr12g6RUHz2UC0QbpqJiNkOwr76yiWJK/qS8LNWXDu6+nf9CIOBpb+OVT6u0Nevi
	SnRYELKASvbSUYGFBkV6g4AmIB2tmCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790783251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=iezzI9hDHDK+9JKCZCutemhDTh9upiXYLoJVnBQb5eqTLU/4IQDD3SA0x7fICDlV70BWwe
	wPXuJdS+DoqgmUBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790783247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=hU2ovLJxWFHhvaqHNLrf2Wpc9ib1CK87oDAEREZ1HBxWlOo48uMhpjr0F+H63IRjZRvWLM
	3dshQ7T+dQtdr8GXIqybiubeCKBE3uOVgBrHhvpgTV/03LKIb3sRPuRv/ld74C0KjaPJ2b
	iZSsnKvDEdBZu2R+7ET3ZcAL1DyO6hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790783247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=6O7KPyP16ybWmUhZROefAnyOZbGtbjGI5pDyZUGdtfOc41DjBd9+/B+KFPCo9wggqyhrrW
	rTLFYjkyOwzdOYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 455F713722;
	Wed, 30 Sep 2026 15:47:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XJhHBg8vvWrFTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 15:47:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B33E5A13AD; Wed, 30 Sep 2026 17:47:22 +0200 (CEST)
Date: Wed, 30 Sep 2026 17:47:22 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Liz Fong-Jones <lizf@honeycomb.io>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v3 0/2] writeback: let foreign flushes reach dying cgwbs
Message-ID: <7pajqtogz2c4hhedorbcb6ts4yr7pxevzwt2rubxsbwidiqs4t@u7lfwce5b3bf>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
 <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7A22F4000D
X-Stat-Signature: 4uuog5ejxwrdwx7wss5j44okr6qy4oq8
X-Rspam-User: 
X-HE-Tag: 1790783257-393220
X-HE-Meta: U2FsdGVkX19Co9TyKfXhar4r3pUlNNu+vrfobHjFj+IvXP/96mU3JO92PfEzdzkfBeidcP6efdZ1tpb8PMHSN347iZ2VGDO0caYjIyCiqz5BiKaddIPJ16UONPGR9ozRz9Jl6rXNBHBjIiUTAPtURKBIna5ySC5odprgTJ8MPxmqZKBzU0m/mOwUDbRKjzt/7xZTTveMIltx6B4pMJO0yIqRj7bQInQJNGo7AfEtr20rhjTeMeQsTi4+7Uq0Y3nfZAAP6IqX2fPcJeYUImbOJ3fAtavAmJaZ5yHSio0ruE2rDiLJ34gNwdPJWc30KCP9fJM0TueqMmSxE3x70ACem9bRMm79W1z0c47CkGc+EPW60RlMT0+hgazrmTzXlssd5LROjIjZ7kjl6JMKyVuDqrLS9B9JqlER2c6nmv0W/97xBp66l5r2nAO1wZn5qQ6UvJPVvfWunrL/1wXgxXZds3NQ85disN3HrhSc6PqzAGhmj0FETz0j1b6pMLD6KkKCJjivw+dUTxEHF2ftjNX4h1xBG758KCvBH3d0HfLH4yhdNu6kKnM7xFzLo1N6KMU4cTdMJasOqUPi9uNRiWtR/hUbj8LpSFeoWJKggKMy4B24rYTsOG6SDPvYbiHXpL2Fe73wI/pWeC85yddi0fsk1FLVnpf0O2h8fpAlzZYFHxvYw5xA2LPKczHviNK3llTOgKX6yp/giNWFxcAGlvODjp0wVe89zGuBANfs6cFdwFyLQFh9uqa5hcT0xRebjs7c8gkwLR7RPlcnKmcTSHwQ5pqyGe9KBgXB1PbQWRgAIOUvQIWxx33g1WRFi0PaCtd/uyTr0OPL9Z5/cMOVYynr3WQBXwjJT5nZq4CDCpAakSZUm05lj/fCjggPRtrpohbuec3G2rHXKbCwsPQyESi/jSkyob6QF/pp23qeAnBNpeyF5HEiCBRebraAdwfKMaC9XsVk+ifOd4BXp/oDU2L
 8otJ0XtS
 afpioeT94tPWDHE2VH4Nuv7iENXnj6QJw55rdxrDcUirDpLsz3mJQ8qFFvY9OraMygGG3nCL1HzbxcpgtIXeZAI6W1Cm3f/faQ8NThGKkhLyADc6ngwRx/A75bQs9JJKSczp/gz0rXR4dHvrFdPapxAU/OxhxPF2HzS+IG5GphBfzzNGOypr7pPXOB0R8GGghB8dR99Gaumh+nGQFJrC0fdN3PwEiu7mkAYXNzucflKkE1VLrtwQOjzpjLxASz4d5Ft/MNCWpizL1rs8M1miH7Vpv2WIBqCQdFso+Is1A5anPkLefScKWTpWZLgCOw01S0ygbM5VFIcHw6bKN0c9y4Akong==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Tue 29-09-26 09:32:01, Tejun Heo wrote:
> On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
> > 1.5s and 19.5s with it), because writing back the old wb's backlog took
> > up to 27s and the sibling's foreign flushes reached the new wb in the
> > meantime. Should foreign flushes also reach a replaced wb until it is
> > clean, or is that not worth it for this case?
> 
> I don't think the old wb needs to stay reachable if the new wb takes
> over its inodes. Instead of kicking writeback, can the takeover queue a
> work item which switches all of the old wb's inodes to the new wb, like
> cleanup_offline_cgwb() does for b_attached and b_dirty_time? The switch
> carries the dirty and writeback page counts, so foreign flushes reach
> the inodes through the new wb and nothing needs to be flushed right
> away.
> 
> That would also mean switching inodes on b_dirty, b_io and b_more_io
> while the flusher may be working on the old wb, which I'm not sure is
> safe. Jan, would that be okay?

The catch with these things is always to make sure that things like sync(2)
or sync_fs(2) don't miss inodes that are being switched because workers on
different wbs work independently. But these days we have wb_switch_rwsem
so switching of cgwb should be safe against racing sync_inodes_sb(). 

Another possible concern is that writeback workers assume they are the sole
party responsible for changing to which wb list inode is added, at least as
long as I_SYNC_QUEUED flag is set. But again AFAICS
process_inode_switch_wbs() takes care of all the locking properly and even
currently, switches could happen while writeback is in progress when the
inode's owner wb changes. So this should be fine.

Finally, I'd be concerned about the performance of inode_do_switch_wbs()
when we are switching many inodes with potentially many dirty folios. It's
going to be a lot of stat item updates... With this I'm not sure how much
it will matter in practice but since we'll burn those CPU cycles when doing
writeback as well, probably it won't be too bad.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

