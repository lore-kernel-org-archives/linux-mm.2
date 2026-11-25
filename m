Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE4E606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c3hAMxVU
Received: by kanga.kvack.org (Postfix)
	id 832086B09DB; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D01E6B09DD; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5727A6B09DE; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34CD36B09DB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3065DA8D73
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:07 +0000 (UTC)
X-FDA: 85473498054.22.4B7B348
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A5DB1A0014
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3hAMxVU;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795608005;
	b=ySfFglX57E49QpSkO78obxeDLqnxxedrmaXuAyzCFuDKsAK8jR6udMA3QqrY7blOWUfFJa
	M4YXzySOQfPYLuhrAaawYyJACDCrpwY1u2RHnyAJ38GqJpsk3c1S7e9dEOZsFcgvXVPgjz
	R6FI6fFanIE67+SAryCiKbO29iNGUK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795608005;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrDPr0YfAMBcivoQ1eblRppmItCHefVbgv4gG21ypps=;
	b=tbNhqMmyFvouTanu2r1Ixgod3X6pN3gz1U/L5sgdAuSq0XexmPV0h0oD36R98IZTAEplUp
	bePE4hz08uYnZg/FezUwNlInjeYlmjd2vHiLhd8OaKE+U3IkbTSt1PDlxf5oJhxcVVVslC
	WaisV9lUoaQIyeUP3htuGyrJa4VNb6Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3hAMxVU;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07C01623EA;
	Wed, 25 Nov 2026 12:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40201F000CF;
	Wed, 25 Nov 2026 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795608003;
	bh=HrDPr0YfAMBcivoQ1eblRppmItCHefVbgv4gG21ypps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c3hAMxVU7FP9o5xC1EM1du3Zb/zdRVDKj03Y/yPEYlqMNKlgI10WIPJ8bRSPeY/Yb
	 0MJ/w8Z0HpKx98de/aY+6vDrjKBj2yA3T22et3qy+MTiLMk3swmSqf3gtBMaDOWJOL
	 v+9bC4Sxl/NHtHo541ZXQUG+doO2lUzO5cr17MraMXEfKu39+t+Yz7s2pCv7kcqa5d
	 Fa8ujwIa3tmSvNWvrZqIqt5jrPwNYlMgY8lGKP/Dvnkr0h9jJWXBMKMGiu1XFH/42V
	 sRz41e5gotTPK91JcziOhxrAkFas3QE2py528CbSsmPHI4i7loCOIbrPsf1snFAOZk
	 UBubvztXKjBdg==
Message-ID: <sashiko-outbox-233311@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] fs: Avoid inode dirtying on last iput
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org, "Mikhail
 Rudenko" <xyzzy@yandex-team.ru>, "Andreas Gruenbacher" <agruenba@redhat.com>
In-Reply-To: <20261124115850.3512-10-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-10-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:00:01 +0000
X-Stat-Signature: cyj8qztztzrrqc4fj9jgngremcefmft8
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A5DB1A0014
X-HE-Tag: 1795608005-640046
X-HE-Meta: U2FsdGVkX18HgntVMGhn6KnNIBPoP24J9SW4liFUokTip1GWtl0HMrGP5w6yg5kOhu8q/1bkCG+NopUn8At5S5gx6pHBJ02izQ2r6zrSsCH9KpPwQedIvROcFWCLbDsUlU/0+NC4xiL9k031U1gALd/0HBX3m+OrizRKETtVPlJhZ1Rl6EqyeOl1AtUba5H5gVPieEXips1aTmL5KfU5UqDsB+qXeriXm9QaIS3iD673LOeld29Ft7Te1tFslkZaTMZSm8PGBsk3Fd0xmiucg1BVTVW5tA+Nw/q4h1MgeuMMPDTEA5t30gXL60ug5dnM31qi5OEYTuuc0oh4nsZWIlCmjCRub+A2viefxvSL5scGwazk1UP8O6+Hdbwo3BaRKjWREq2tuvlt2RdMbdlwdtuBXylNM5tNfIlQuIl39gvMlvZxJ7HaxxzCifkiUnKZR6gpBox1/mG/sC3IW7beN4Y1aNwORf9THcj3igm4tHH4LDS9Hv4/mpFzG2mJbhnY5W7lFyhN0QTMr36hctBYGvMlRUcyzXHZ2X43Yg3N3nKpKjZDdZDloLHOD65N2gNlpSZSuhQfrxAepe678/ihJCfNUCu9Y/EQUG0lNRBDw5oy/UP9ovdtSWQi4x1ao8o17RJEm9BKjA2uUacuTAZTNYpoSUIyTL4qsEa9w6anvD3k+MIMw6Sl6MJSrdpsY3ZWMnKYJOHqrUFZwbueMQkzI7VJ2E31TSUWbJr7QR7YFap4MfzJZMdJ9T30VdPQ++2rc986+5W9/lE5aIgUtOi+iYfzYuKCx/ER+EGNlgW1Pj3i6tb4moTJtImfTFnNvZ91j7stsxfhfz0VNLUyrOYNJ9vgRregGQ5ONfWgLBf3ACtcE3eOZ0L+PqPgzRd609nqSn9Ac+7eb18bEhwUDjWrhehZQEMbLllhXt2j+Qhr+zVLXnhbFE9KCqMjfLcvQwJZUhBBlZsDpCQXa/CfenC
 IrvKEPZ5
 s59c9is4ZJdMmsbTPBjo5r+T+9PUxbWid2SyDyYBnMTFW8VERU21Pn/mn+ToE1VtqlMBJjYU+FM0STIdVQAEUdw/whOKfyqsLeypwt39zSMDpL7UYQU4g3nHfcnBvDZRwSI4qpaJ02SxHpx8MHHxyr9fhu8AuQCwP/9hbweWUyvcUqMkAUr+YLd0ruBxlAgW5d1aUG2VY8Q9VDmyhUjwfYIEXyZTCkzAN8DizVa1h1HiKm1lMDcCcMNmf8SOUhDTeX2n7sLZNA52t9StzwZ/1x3tlzT9n5tiKst7rTOEpe1nGlNcheuvmdyN4Q8RnI/tJNOwytIuatmIOC1D5P5g6jgvKaAGCAmnw3YmzkblsPG3wKbVKP0n/qwseZc9tbYz52yQc+LwC3NEavivESsX4hSGBB/kuaun6a5yRngNLCzn3AYtL2CwJ59mHWOPeNmlzqEDvcliQa+u09D2GOKyalx0Ia5pCIzpyIbUqNLPQ929+WMlNA28+kJx6z194ywRUD8LWdud+d2sp6yO0H8h0nTN2UaZxeTkmUeb1d1TwXwLwS6j4FoYYffjo7UUM2V/xvaVd6DlxHn1o/cUTHI0LVVgMHdpUzeUdUXRWP9U7ApLHII/IzFKr7QlBR+fmJt38ezViTt/5b/7PPrHlGt+q3gl8KpHr1EDy1+nGyeZp3UNCJo/Z7D7xwRWw0rJnwMSdUFDVolUIlaKQYw6HQkaY2xiuWwYq6Uo6A38p1vRBNvAlcPg60O1EZ2efmweE8CuyL0HfrLkhV+7X6fqOvWZESHYPwiFx0GZ54viZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] writeback: missing delayed writeback wakeup for unused
  I_DIRTY_TIME inodes
- [Medium] writeback: missing wb_io_lists_depopulated() in
  inode_add_dirtytime_head()
- [Medium] writeback: clobbered dirtied_time_when not reset in
  __mark_inode_dirty()
- [Medium] fs: lost lazytime updates and wasted queuing on immediate
  eviction in iput()
--

commit ee4802f28b5dfd62a7f8c5bc17c60aed4d146987
Author: Jan Kara <jack@suse.cz>

fs: Avoid inode dirtying on last iput

This commit replaces synchronous sync_lazytime() on final iput() with
queue_dirtytime_writeback(), moving unused I_DIRTY_TIME inodes to the head
of wb->b_dirty_time with an expired dirtied_time_when timestamp so they are
flushed on the next periodic writeback pass.

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 65b1af2879e87..0332a2edef938 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1583,6 +1583,42 @@ static void redirty_tail(struct inode *inode, stru=
ct bdi_writeback *wb)
>  	spin_unlock(&inode->i_lock);
>  }
> =20
> +static void inode_add_dirtytime_head(struct inode *inode,
> +				      struct bdi_writeback *wb)
> +{
> +	unsigned long new_time;
> +
> +	new_time =3D jiffies - dirtytime_expire_interval * HZ;
> +	if (!list_empty(&wb->b_dirty_time)) {
> +		struct inode *first =3D wb_inode(wb->b_dirty_time.prev);
> +		unsigned long first_time =3D READ_ONCE(first->dirtied_time_when);
> +
> +		if (time_before(first_time, new_time))
> +			new_time =3D first_time;
> +	}
> +	inode->dirtied_when =3D new_time;
> +	inode->dirtied_time_when =3D new_time;
> +	list_move_tail(&inode->i_io_list, &wb->b_dirty_time);
> +}

[Severity: Medium]
Should inode_add_dirtytime_head() call wb_io_lists_depopulated(wb) when
moving the inode onto wb->b_dirty_time?

move_to_dirtytime_locked() calls wb_io_lists_depopulated(wb) right after
inode_add_dirtytime_head(), but queue_dirtytime_writeback() does not.  An
inode with only I_DIRTY_TIME set can be on wb->b_dirty if
inode_do_switch_wbs() placed it there (since it checks I_DIRTY_ALL) right
before process_inode_switch_wbs() drops its temporary reference with
iput(), or if redirty_tail_locked() moved an expired I_DIRTY_TIME inode
from b_io to b_dirty.  When queue_dirtytime_writeback() moves the last
such inode from b_dirty to b_dirty_time, WB_has_dirty_io stays set on wb
and wb->avg_write_bandwidth remains added to wb->bdi->tot_write_bandwidth.

> +
> +static void move_to_dirtytime_locked(struct inode *inode,
> +				     struct bdi_writeback *wb)
> +{
> +	/* If the inode is used, move it to the tail of b_dirty_time list */
> +	if (icount_read(inode)) {
> +		inode->dirtied_when =3D jiffies;
> +		inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
> +		return;
> +	}
> +
> +	/*
> +	 * Inode is not used. Expedite writeback by moving it to the head
> +	 * of b_dirty_time list so that it can enter LRU and be evicted.
> +	 */
> +	inode_add_dirtytime_head(inode, wb);
> +	wb_io_lists_depopulated(wb);
> +}

[Severity: Medium]
Can an unused I_DIRTY_TIME inode moved here miss periodic writeback and
stay off the inode LRU until dirtytime_expire_interval (12 hours) elapses?

If final iput() runs while I_SYNC or I_SYNC_QUEUED is set,
queue_dirtytime_writeback() clobbers dirtied_time_when and defers list
movement without calling wb_wakeup_delayed(wb).  If the in-flight
__writeback_single_inode() already passed its I_DIRTY_TIME expiration
check, writeback finishes with I_DIRTY_TIME still set and calls
move_to_dirtytime_locked().  That moves the unused inode to
wb->b_dirty_time and clears WB_has_dirty_io via wb_io_lists_depopulated()
without scheduling wb->dwork.

The same stall can happen when queue_dirtytime_writeback() calls
wb_wakeup_delayed(wb) while wb->dwork is already queued for an earlier
deadline (or wb_wakeup() runs it immediately): if wb_workfn() runs before
wb->last_old_flush + dirty_writeback_interval, wb_check_old_data_flush()
returns 0 without checking b_dirty_time, and wb_workfn() only re-arms
wb_wakeup_delayed(wb) when wb_has_dirty_io(wb) is true.

[ ... ]

> @@ -2962,6 +2996,50 @@ void __mark_inode_dirty(struct inode *inode, int f=
lags)
>  }
>  EXPORT_SYMBOL(__mark_inode_dirty);
> =20
> +/*
> + * If inode has dirty timestamps to write out, make sure flush worker wr=
ites
> + * them out during its next periodic writeback writeout.
> + */
> +void queue_dirtytime_writeback(struct inode *inode)
> +{
> +	struct bdi_writeback *wb;
> +	unsigned int i_state;
> +
> +	lockdep_assert_held(&inode->i_lock);
> +
> +	wb =3D locked_inode_to_wb_and_lock_list(inode);
> +	spin_lock(&inode->i_lock);
> +	i_state =3D inode_state_read(inode);
> +	/* Written back while we dropped i_lock? */
> +	if (!(i_state & I_DIRTY_TIME))
> +		goto out_wb_lock;
> +
> +	/*
> +	 * If the inode is dirty, next writeback will come soon so we don't
> +	 * need to do anything. If it is under writeback, we cannot touch dirty
> +	 * lists now so we handle moving the inode after writeback is complete.
> +	 */
> +	if (i_state & (I_SYNC_QUEUED | I_SYNC | I_DIRTY)) {
> +		/*
> +		 * Clobber dirtied_time_when so that timestamps get synced on
> +		 * next inode writeback.
> +		 */
> +		inode->dirtied_time_when =3D jiffies -
> +						dirtytime_expire_interval * HZ;
> +		goto out_wb_lock;
> +	}

[Severity: Medium]
Does backdating inode->dirtied_time_when leave a stale expired timestamp on
the cached inode after writeback clears I_DIRTY_TIME?

When __writeback_single_inode() later calls sync_lazytime(), I_DIRTY_TIME
is cleared while dirtied_time_when keeps the backdated value.  If the
cached inode is later reopened, dirtied with I_DIRTY_PAGES (so was_dirty is
true) or queued with I_SYNC_QUEUED, and then marked I_DIRTY_TIME,
__mark_inode_dirty() skips updating dirtied_time_when:

fs/fs-writeback.c:__mark_inode_dirty() {
	...
		if (inode_state_read(inode) & I_SYNC_QUEUED)
			goto out_unlock;
	...
		if (!was_dirty) {
			...
			inode->dirtied_when =3D jiffies;
			if (dirtytime)
				inode->dirtied_time_when =3D jiffies;
}

Because dirtied_time_when remains expired, the next data writeback on the
active inode immediately forces sync_lazytime(), and
move_to_dirtytime_locked() (with i_count > 0) can place the inode at the
tail of b_dirty_time with dirtied_when =3D jiffies but an already-expired
dirtied_time_when.

> diff --git a/fs/inode.c b/fs/inode.c
> index f2003ae753745..4b13125f0678c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2052,7 +2052,6 @@ void iput(struct inode *inode)
>  	if (unlikely(!inode))
>  		return;
> =20
> -retry:
>  	lockdep_assert_not_held(&inode->i_lock);
>  	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), =
inode);
>  	/*
> @@ -2065,14 +2064,14 @@ void iput(struct inode *inode)
>  	if (atomic_add_unless(&inode->i_count, -1, 1))
>  		return;
> =20
> -	if (inode->i_nlink && sync_lazytime(inode))
> -		goto retry;
> -
>  	spin_lock(&inode->i_lock);
> -	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink=
)) {
> -		spin_unlock(&inode->i_lock);
> -		goto retry;
> -	}
> +	/*
> +	 * If inode has timestamp updates pending, queue flushing them now as
> +	 * otherwise the dirtiness could be preventing the inode from entering
> +	 * LRU for hours.
> +	 */
> +	if (inode->i_nlink && inode_state_read(inode) & I_DIRTY_TIME)
> +		queue_dirtytime_writeback(inode);
> =20
>  	if (!atomic_dec_and_test(&inode->i_count)) {
>  		spin_unlock(&inode->i_lock);

[Severity: Medium]
Can deferring lazytime writeout here lose pending timestamp updates when
iput_final() drops the inode immediately instead of retaining it?

When op->drop_inode(inode) returns 1 in iput_final(), it sets I_FREEING,
skips write_inode_now(), and calls evict(), which removes the inode from
wb->b_dirty_time via inode_io_list_del().  For filesystems where
->drop_inode() returns 1 on an inode that still exists on disk (such as
gfs2_drop_inode() when SDF_EVICTING is set during gfs2_evict_inodes() or on
iopen glock demotion), sync_lazytime() previously called ->dirty_inode()
before eviction so gfs2_dirty_inode() marked the glock GLF_DIRTY and
evict_linked_inode() wrote the timestamps out.  Without sync_lazytime(),
neither GLF_DIRTY nor I_DIRTY is set and evict_linked_inode() skips the
writeout.

Also, whenever iput_final() evicts immediately (drop !=3D 0, I_DONTCACHE, or
!SB_ACTIVE), calling queue_dirtytime_writeback() in iput() first drops
i_lock, locks wb->list_lock, queues the inode onto b_dirty_time (even if
unhashed), and arms wb_wakeup_delayed(), only for evict() to immediately
remove it from b_dirty_time.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124115850.3512=
-9-jack@suse.cz?part=3D2

