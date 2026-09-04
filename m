Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F6DC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7CE6B0088; Fri,  4 Sep 2026 05:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279A36B008A; Fri,  4 Sep 2026 05:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A6B6B008C; Fri,  4 Sep 2026 05:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3B366B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:00:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63B1DC0AED
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:00:24 +0000 (UTC)
X-FDA: 85175483568.29.A396A42
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD69780002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:00:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2n+IpX51;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oKLGQ7sf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X745eKzP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FT5soJ5p;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788512422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=yNikeuC/Vt9OYgrNHZI3ZwmAh+BiENrnmRGkaYFimNcC/RJZTT7aH3zRK8uI/Doc1cBIrJ
	JD+Ag/n5xXwkRO+Pxi7Lsc+BDSONLrm1D9sYuUV/I6RuHUx+gNVbTJua8Ft1dRJTsspPxc
	LfQGiIS35OH9+vYAYjpNd5hW4gq1yKo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2n+IpX51;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oKLGQ7sf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X745eKzP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FT5soJ5p;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788512422;
	b=sa+MPph7tW33k0CNZfAZ9isbEVEqJ+oi61UBRpOinj1Rn5L7MeI2N2bbyfvDlnV/cL05vo
	SZkpzItfeiR8mT0SfFyKYAGhYY/phA8aJQqQXAc+dzJDKzojuadaqZETnkx4rg6xMpbFGL
	KqKHVxVh7TVUuX4k/QWRHMXnC6CJidw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71B5122B0C;
	Fri,  4 Sep 2026 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788512415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=2n+IpX51oNNOJVS+8qwEdtvECRq/AlSxFxH3HPpvkm3/Jbs/DGzbHpVuN828h9P6GPP7GE
	PH+pTFrYaan+XmNqEfGHVg7yT/NPqdzhIETV5k8zi1qnbj1JBiMYUj2WlT3pRgiuE6Or3b
	XjPD2CbmZJx2UuqN+or/T7cmaH3yIQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788512415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=oKLGQ7sfZ1iSt3f8Jg2UBQtw+OkGbj+ZayZPdfnP9EIpmCuAcDjJHSvdzWwvTfvd8ts39I
	EzHRl6TnuV2MG0DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788512411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=X745eKzP8BUGBUEj5dHInWHKaxpaFHhUT/sdYJtrjAYuDYBhlwzpow/j+ZxflKHx3KsoAe
	V0Z3L1ys3TMeqwMfN8h/A9l9Q+x4peXrOznZX6L0BrnlScO6GXPcfChIyOGk7A1UX0Guil
	vuPsGQtQNkf4ijtZjGu4uJSgosFohXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788512411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=FT5soJ5pKEagZVToBO4ECQ3dY1VxfC+VphmQKcFDkyQmfS2tT3O7MUkn6VSuLaKNw80sMt
	MFPaXZ3ZpVwEINCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C5CA13726;
	Fri,  4 Sep 2026 09:00:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aVGXEpuImmqjbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 04 Sep 2026 09:00:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C6E41A13CE; Fri, 04 Sep 2026 11:00:06 +0200 (CEST)
Date: Fri, 4 Sep 2026 11:00:06 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, 
	jack@suse.cz
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
 <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t9j3iy855yttoionmpmhr6oti5x3a3jf
X-Rspamd-Queue-Id: BD69780002
X-HE-Tag: 1788512421-46681
X-HE-Meta: U2FsdGVkX1+/QGq+rFys07gGoHl8b4PfjUYLdrfGRovyorqWB5tXKFgo70zkmKIhUqXetdYQDx+oiwgS6ttYrohGqByYZlrZG4HcBAfv8qOeLixuYz3/IZgMc76lDg67Pfv/y6LQKk9lUUae3BaiRTgEsKWc1qvK6pHWEUJecasvtVCra0VzR5EDmzAs6fM5x6mpsCHY06gIeQHgtSPZ6tOwK76jWhuDmd//8AZvVCeao+g/LbVjb29vtDM5qAjUrWbZBsBOBMSSonkHX3lTgdBzYLBbTxgauSV6JQEXdf3uoQoryp1Su4+sUTZQce9c6xi5yxEQy3IhS8vdhSEhHNHHa2ZoLgZb8G59KF3Hmx0KT71/Gdb1duxdHI2TIwp7nmnVRNctfqWko8ICkc6db0OPSYEQ9gE+UialT4R48uoUoGfeCDoK7qEV5jBdJLhuON4Vc/hEwHti9Lnn7KxPaiYXw176IfnCUjfEze0diK2egM2KCPLMFYeD9AOpEDmXGQ208MHZwFpHpA6XFmc65gLfuYHuvpnirWUq3PxyO5lZxMmOcskyZ60fdoiFgiR75AY9ImtnDFdV0kcmHmOhiwyYSHKlvbx83DC14YQ4Cvf95C1oFj0d/y1Rz5Gw0OfHbmciZUajaF/Fy3yuVmZBBrig3CDPr7Cfd/z7tk1cf+fI6gUwdeeY0Sky77ERGQYKE7+gFJJi+IzDPZhfIV4TQ7gpFrb6acsiRATDlTmslJaVKOq+X0jzIxbeb3oPv7rHVJ7+99XZ7Et+ffbrfMSAW+6VK5B8PT6VTImMmANVzI6weHxJzIGrorUsyhX2j7SHsy5Wpo8CDmILY4l+cWZWSusfS8UfkDy/TD1h9UGk0ptiXnDtJ/U6dQd/oMQlbNj0SyERlTtyQIu0i/060atq70XrphO7Fj4ANCGUSmroN6DkdcLg1RtBdoOJDSgi7Wzj8IiNO+2ksshSjsQMkv/
 itCnF9wM
 6MUNpKB5gXcGDW4NqH/eX/dfF+QUrS9HQsoKOx2CDoY9mcbhIYocYMmZKkpnR9kOTcHGI4rCM5SvkdGb7sSg77WLfaMQ77k5powQPgxz5cuihJWM/2SGcVpXPgW1c52iahyh4VJSsDjxouymI0Ajcf2azUlkhqVIBIr/ZAnO++cV7OWV+1ks4Zblb2H0/lHZZdSsXdJ05alVLH/Vqo351vMhzTj/I5fqUs+mh2haIyY8PnL1kP7nNDjN/ZNhgxtRWuVdL0zoQzZcPOcCNWDx9gU4iaDVxdthnxiXrsPB1Tji3TG43gbvqPHyc6lEpwGaezMrX9XznjizxhaGJau7YfUnAFNzB6RZvsYFJY373tK67HtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 11:39:23, Julian Sun wrote:
> On 9/4/26 3:34 AM, Andrew Morton wrote:
> > On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> > 
> > > Foreign dirty flushing handles cases where a dirtied folio's memcg and
> > > the memcg owning its inode wb differ.
> > > 
> > > wbc_detach_inode() notes that "concurrent write sharing of an inode is
> > > expected to be very rare". This expectation does not hold for bdev inodes.
> > > A bdev inode and mapping are shared by buffered users of the block device,
> > > while the inode has a single wb owner. On ext4, buffer-cache folios used
> > > by metadata and journal I/O can therefore be charged to different memcgs
> > > while sharing the same mapping. Normal bdev activity can thus produce
> > > frequent folio/wb ownership mismatches.
> > > 
> > > This was reproduced on cgroup v2 with the memory and I/O controllers
> > > enabled, using ext4 on a loop device. jbd2 repeatedly generated
> > > track_foreign_dirty events for bdev folios charged to unrelated memcgs.
> > > When one of those memcgs entered dirty throttling, the resulting record led
> > > to a flush_foreign event and queued writeback with reason=foreign_flush for
> > > the bdev inode's root wb.
> > > 
> > > Skip foreign dirty tracking when the folio mapping's host inode is on the
> > > blockdev pseudo superblock. This prevents bdev-originated records from
> > > triggering later foreign flushes.
> > > 
> > > The tradeoff is that dirty throttling in the folio's memcg no longer uses
> > > bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> > > folios remain subject to normal writeback. This is preferable because a
> > > single bdev wb owner does not identify which cgroup is responsible for a
> > > mapping shared by buffered bdev users. Flushing it can write back data
> > > unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> > > foreign dirty tracking for non-bdev inodes remain unchanged.
> > 
> > When fixing something, please always describe the userspace-visible
> > runtime effects.
> 
> Sorry, I overlooked this aspect.
> > 
> > I'm thinking probably "unnecessary I/O"?  If so, has this been
> > quantified/measured?  If not, can the effects be guessed about?
> 
> We suspect that a large amount of prematurely triggered foreign writeback
> consumes device writeback bandwidth, thereby degrading the performance of
> the entire writeback path.
> 
> On one production machine, the total nr_pages of the foreign-flush works was
> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
> Although nr_pages does not represent the number of dirty pages that will
> ultimately be written back, the actual number of pages written back may
> still be very large because the corresponding wb was continuously
> accumulating dirty pages.

As Tejun also wrote, it would be good to really quantify these effects -
best by demonstrating how this change improved writeback behavior (and we
are not so much interested in the number of submitted writeback works but
more in the observed load on the storage or completion of some workload).
The problem with your solution is that it has its downsided as well
(possible stalls in dirty throttling) so it should be very clear what are
we gaining to outweight this risk.

In principle I agree that a lot of submitted writeback works can degrade
writeback behavior - a lot of workloads has some set of folios that is
practically permanently dirty and if you are pushing writeback too much, we
will be just writing these folios over and over again without useful work
really done. Also if there's comparably small amount of folios dirty, the
IO resulting from writeback is generally less efficient. But how severe
these effects can get in case you describe is not clear...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

