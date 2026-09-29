Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C1DCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ED76B0093; Tue, 29 Sep 2026 06:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F666B0096; Tue, 29 Sep 2026 06:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E756B0098; Tue, 29 Sep 2026 06:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4EED6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:38:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2303E1604A2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:38:09 +0000 (UTC)
X-FDA: 85266449898.24.77B3935
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDF3140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:38:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GyRdH2US;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xfr4CAhk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="SKB8A/72";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lFcBPR3;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790678287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3kx3aUxxfT1+0stFtzxC2Kua9DU5Q56H9l9MHd9/TI=;
	b=KFwd655g7zGPFO3nuLhc9ERhjd0mDuyDwGWpfkLmGG1nUikrrus6mwCFA49V5pBVFt+HoV
	0N8ykmBqqnibdkgZkLRzWLjKNWitHaxCv+52bBwsNduhTc66TP6nyIncuOEW7xuclAHpS9
	Fgpo1EX/OhwmtGufpFWrR/8pHgp8wZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790678287;
	b=l0d25d8IeNKj0kTn2KiwgRqoTGAeCdXDoOIusMJRpW+xuMPa6oz4Mc9Ankyzru+KtJ97O6
	8ycX4QEcoU63YWJXueJHzIiXqPbRH8BXbG1HxN0uzhrCoMaw18Riitwt7Oif2mM4ZH97H7
	O52HMsVvV7xKWDzyE67HI8yl3iYmZCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GyRdH2US;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xfr4CAhk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="SKB8A/72";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lFcBPR3;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1CB021BF6;
	Tue, 29 Sep 2026 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790678281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3kx3aUxxfT1+0stFtzxC2Kua9DU5Q56H9l9MHd9/TI=;
	b=GyRdH2US9jOkxJWDH3nyD8AxxpX8qEVO9JAzNDrod7NIrqv0VHYBADf58mXldggRI2Hypc
	35HoSWMqNIc96vU8LFweWFE0rWq/LdLDwoAaVF3+zJA8qOZNFp1jucrIKYJxKhGzWW+E04
	jOQT0r0fH6RNbp14XlBxNvi+jnTbe4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790678281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3kx3aUxxfT1+0stFtzxC2Kua9DU5Q56H9l9MHd9/TI=;
	b=xfr4CAhk9IoMoE9bKdv3PZOq8cXQ2KGSp1Tr+BWFz8UA0b36AJvqtvPw4+2Yy8/Qk/HDB/
	HjVjU+Dy4CnNvxAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790678276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3kx3aUxxfT1+0stFtzxC2Kua9DU5Q56H9l9MHd9/TI=;
	b=SKB8A/72t+jDiG7Ei0pxRSq3F3khsAZGIrHKtb3x4FOVyWW8KPoa0BoDtKh65iKjOvilAz
	SwK+PBuj/qMk49hXAlnToEr6aY5Dxg0ijAVqXcSOCBsUmeLyisKbljKD7FB83Q6caY9cgT
	zn3ZBb47NOwJO6jo0bFnblF69NbY8LQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790678276;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3kx3aUxxfT1+0stFtzxC2Kua9DU5Q56H9l9MHd9/TI=;
	b=3lFcBPR3mHLv1HMJUeXokuQxSiSdeLubn5Sn5jei3nq36hGaK62B+bp+4kPFwDkR8d0kZ8
	c/71CrT4dGhU2vCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74AA7136D1;
	Tue, 29 Sep 2026 10:37:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TfxEFASVu2pHXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 10:37:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC50BA132A; Tue, 29 Sep 2026 12:37:55 +0200 (CEST)
Date: Tue, 29 Sep 2026 12:37:55 +0200
From: Jan Kara <jack@suse.cz>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	brauner@kernel.org, hch@infradead.org, xyzzy@yandex-team.ru, tytso@mit.edu, 
	djwong@kernel.org, agruenba@redhat.com, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 0/5] fs: Deferred inode reclaim
Message-ID: <cxgitt74gb6d42l4mdiztrz42xuaykfggsxoussgdmo3h2qur7@injom55qowrs>
References: <20260911081309.14137-1-jack@suse.cz>
 <20260926024829.3051410-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926024829.3051410-1-matthias.goergens@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDF3140004
X-Stat-Signature: 5j88f966cjjijko1odki36cng935iift
X-Rspam-User: 
X-HE-Tag: 1790678286-517583
X-HE-Meta: U2FsdGVkX19Vdh8b+IJPqyCUrA+YTb/Vjn3bU879j4G43/HV/qU/0AirNPYK/OpCnm8f3t1svJWGCHxTJURLoXAxn0xByx29TJxkBWSMKX2kZgl30envf4tafTnvff32xQiW0D4kRvfpCX2XFKsN7TE72XhWWPacwDacrvJkv1k9H6LW12uMH1ruA+d6cdhcQ8BpoLA8IGBGjvy/rgApd0YKapeCeyA0qo+YlQjeykWrRUIp3OL6SX1Y0wod7zyZ1LGnC4/RU/+htdVzzV8/gQwlW4zt+xwkC34isCwc2gfC/gLgNbVAHVsvw/IoroZDWMpBiyI0GEWmSeHoQN9TKxd4ax3zbUS7KAPHDrmYbviOKADqRpWdj77aZyFVWsYpzjz7cuTqMb2l9G0Fl+bdBm3lQeiN2Fq6ya9cFV4QSkmstdJFB6ThzQDnFXzjl1hJhYPhmYxSIcdPsevhtKNeHfO7a1EMFUZmbkx+lWfZiJ1e6qbM9pun5KoCLgFwBvE74jd2IeCM4hFVdjvy1uTCmsU886vh1Y3qu1GKnKJWdLstG6diRuuWTisDjHUp/R3DEkXBlwybw0JmDMrgvk8mXz7ekb8gmVDMzEy4xz4cqWgtGcf/Zezk0qiMEAzXbHHCiNV1e6nV+nhUI8XyxzBQObCHr/iVohUdJwM9M85ym0Eo4n95t8qg+vCZQzDtUyuCjjovL4ZK4YVqIAUuT7yLueqXnv988cJ/sliA0ZnztLU9K4HA4pqQbVdjfCkRCFpyPQltL8Okrt5JFmoYGQHMFC9fzChUI4ZFiivix0wCioRUzXllod6cVda7moGVrpUrYYltXyi7ggyZZFmuVNj3x6Ag6ByYGVj4Zft1KGOCsOxYVho35hks+mSZGfMQYsIJJcSYsHuiFtYbLhpFZv4tlNrmFu0QFcujqIz/YqeDNu55Rk6FSw/RWM8cM4KdaUorXzDnVpd8AnTW/ZEh+2a
 u9PT0ZcQ
 rYvII8X0+9iYvkx5vd/RA/EyX+bSfxfwWsZNyWGcDYUTjckkRvBCuFSebEgGrM0rCBf4QG4Q+DhyNzUjROs0K6TiJQnL/VbE2vF5a7+BIkKGBdsyww98bcx2WBQwt5TJC5BP1s8e9FruA2wjBRaivZ0PubDNNweDioCarFlkFh/k43AheIsoY/xUwYoI2nV7P2+kr2ZZ3LqLOYrpX2LOIH0UETTqQrpgxWX+judYqgBXd0D+4ehGoYtpdhIUqCE1kB09hQ82Thdprskfq8fsowe5KqhzjUVWX5MgPSewjkykUfuf3K0R77kCZO3OiIXKDdqgTIB4/VPdMWYkLIkg0XTjdFpbMrKIQvZmWa+1vrDEJMUl71W4sWdeAN+E2uB/cFLwdkZ4MQFg60RvuEtInXi8jgwd0cCtx6lrTqVjSaW3b2yZuYvJMPMKsMfpFdC9t7Q9cWIetwzOwLqs5/YafMIJUmGf0O+LHMQNyuAPLuUYlr8JZ/JETJOcp8vCvNc2UvliOmAnPxxM6lE0FA5i+eyp3cSnjzb10e4J1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthias!

On Sat 26-09-26 10:48:29, Matthias Goergens wrote:
> I ran v2 against its base in QEMU, on syzbot's disk image with a config
> close to syzbot's (KASAN, lockdep):
> 
> - Lazytime churn on ext4 under memory pressure: the PF_MEMALLOC warning
>   fired with the sync_lazytime() stack in all 5 base runs, four times
>   from kswapd, and in none of 5 runs with the series, which evicted as
>   many inodes in reclaim context without reading ext4 metadata there.
>   The workload also runs drop_caches=2 under memalloc_noreclaim_save()
>   from a debug patch.
> 
> - Hibernation cycles with /sys/power/pm_test set to devices under that
>   load, with inodes that 5/5 defers queued in each cycle, and with
>   freeze_filesystems 0 and 1: no freezer timeouts and no hang involving
>   the queue.  The stalls in throttle_direct_reclaim() from
>   hibernate_preallocate_memory(), and lockdep's warning in
>   __set_task_frozen() with freeze_filesystems=1, happen on the base
>   kernel too.
> 
> - One path the series does not cover, see below: with the series
>   applied, unlinked ext4 inodes under an overlay are still deleted in
>   reclaim context, and the warning fired in 2 of 3 runs, as without it.
> 
> The reproducers and the debug patch are at
> https://github.com/matthiasgoergens/linux/tree/deferred-reclaim-repro
> and I can post them here if you prefer.  The Tested-by below covers the
> lazytime and hibernation runs.

Thanks for testing!

> > @@ -988,13 +1013,27 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
> >  	inode_state_set(inode, I_FREEING);
> > -	list_lru_isolate_move(lru, &inode->i_lru, freeable);
> > +	/* Inode will take long time to cleanup. Offload that to worker. */
> > +	if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> > +		list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);
> 
> This is the only place I_DEFER_RECLAIM queues an inode, also with
> Andreas's simplification folded in.  An inode that ->drop_inode() drops
> on its last iput(), which for ext4 means every unlinked inode, never
> gets here: iput_final() calls evict() directly, in whatever context the
> iput() came from.
> 
> syzbot hits that under reclaim with overlayfs on top of ext4, in the
> same bug as the lazytime trace in your 2/5:
> 
>   https://syzkaller.appspot.com/bug?extid=7f94fe3ce0f6613e12b8
>   https://syzkaller.appspot.com/text?tag=CrashReport&x=12764a15580000
>   https://syzkaller.appspot.com/text?tag=CrashReport&x=13530905580000
> 
> Direct reclaim prunes overlayfs dentries, and dropping the overlay inode
> puts the last reference to an unlinked lower ext4 inode, so
> ext4_evict_inode() runs its deletion path under PF_MEMALLOC.  My
> reproducer above does the same: stat files through an overlay on ext4,
> unlink them in the lower or upper directory, then apply memory pressure.

This is an interesting case. When I was writing the patch set I was
thinking whether unlinked inodes should be marked for deferred reclaim and
decided for "no" - unlink or file close should be happening from context
where synchronous ->evict() should be possible (and is desirable!
Offloading to async context always has these inconvenient questions about
throttling associated with it and space being freed later than userspace
expects it etc.). But I didn't think of overlayfs - I assume syzkaller
unlinked upper layer inode under the overlayfs' hands - which can indeed
lead to overlayfs dentry being effectively the last holder of inode
reference and thus responsible for inode deletion.

Inherently it is kind of nasty that overlayfs dentries can be the last
thing protecting the inode from deletion but at the same time I don't see
an easy way around it. Amir, maybe you have an idea?

Anyway, if we cannot change how overlayfs behaves, what we could do is to
mark unlinked inodes for deferred reclaim but offload the reclaim from
iput_final() only if PF_MEMALLOC is set in VFS. At least then we know we
are in async context anyway so nobody can be relying on when exactly the
inode gets deleted when somebody left it to memory reclaim.

> Is that path meant to be covered?  Handing such inodes to the queue from
> iput_final() under PF_MEMALLOC, as gfs2_drop_inode() does for gfs2,
> mostly just delays things: blocks and quota come back later, lookups by
> inode number wait in __wait_on_freeing_inode(), and umount would need
> the inode counted in s_deferred_reclaim_count, as 3/5 does for its own.
> But it does not work as is with freezing: ext4_evict_inode() takes
> sb_start_intwrite() on the deletion path, so a worker evicting an
> unlinked inode of a frozen filesystem sleeps until the thaw, holding a
> batch of up to 16 inodes taken from any queue, and enough of those stop
> the queue.  XFS keeps inodegc per mount and stops it in xfs_fs_sync_fs()
> before SB_FREEZE_FS; this queue would need something like that before it
> could take unlinked inodes.
> 
> On Ted's question (https://lore.kernel.org/r/aqQV6Uwma_KjUH0O@mit.edu):
> with this WQ_FREEZABLE queue I would not wait either.  A non-freezable
> queue would need draining before anything is frozen, because an eviction
> after the hibernation snapshot writes to disk behind the image, and
> draining later can wait on kjournald2 or on sb_start_intwrite().
> Freezing the workers with the kernel threads avoids both.
> 
> One catch: a work item already blocked on something frozen earlier keeps
> freeze_workqueues_busy() true until the freezer times out, and the
> suspend or hibernation is aborted.  With /sys/power/freeze_filesystems=1
> the filesystems are frozen before the freezer runs, so an eviction
> waiting in sb_start_intwrite() is enough.  ext4 only takes that on the
> deletion path, so 5/5 is not affected, but unlinked inodes routed
> through the queue would be.

You (and Ted) have a good point here that if ->evict() is going to write to
the filesystem (and currently ext4 doesn't offload such case but I
would like the mechanism to be usable in such situations since e.g. XFS
needs it even if we solve the overlayfs case differently) we need to
be careful about interactions with filesystem freezing / system suspend.
Also in that case Sashiko's concern about possible deadlocks of throttling
with ext4 transaction machinery becomes real.

So as the patch set currently is, it is correct but I think we need to
somehow deal with the overlayfs issues you reported as well. At this point
I don't have a clear picture in my mind how to cleanly deal with the
lockups that would be created by it. I'll think about it more and also
maybe Amir will come up with some clever idea from overlayfs side :).

> Tested-by: Matthias Goergens <matthias.goergens@gmail.com>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

