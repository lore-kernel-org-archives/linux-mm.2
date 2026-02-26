Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F06FFD8FEC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3FC6B00BF; Thu, 26 Feb 2026 13:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B0E6B017C; Thu, 26 Feb 2026 13:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873B36B017A; Thu, 26 Feb 2026 13:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70B8F6B00BF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:04:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D93B14038F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:04:20 +0000 (UTC)
X-FDA: 84487382280.11.042F441
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4901180004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:04:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ABg26jN5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yxK92OaI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ABg26jN5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yxK92OaI;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772129058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bw/pxMCs3PGZ3t1xDbLU2eOlXd2FRM6wCa/DdIh9vIw=;
	b=H5cVT0vzWborbF/0N0WwKCAvcOvL1hsi9XqMh3p8YTq949yArLVKUuAn+qzK62m9aU4nZh
	vvm5D/mz9fIEW1A2X3jHHSvlHG/OyOOmAdHFfRbiLNMjMalZqh481IOtyMP86X9e/rJPgf
	x1NoyNNNQfon6xipNd+1nuQ0ZvU3gzQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ABg26jN5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yxK92OaI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ABg26jN5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yxK92OaI;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772129058; a=rsa-sha256;
	cv=none;
	b=kp16vU/HDefebOW1z/bV3u0HwiWxtnbaR5gNc9mVHwYn9Z4g+lM9zgNhZzQ+yDI9ivsOj9
	nOqGv2nq1+BwDOO6vi3EkqIlCzY20Q8XRR97fghX8cI3sFwqlK4kCBdfiWe/0ODM/qa8wn
	p0FZaGLpSuKzLSmGVLB2fU3NI25Bch4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6A0A4D372;
	Thu, 26 Feb 2026 18:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772129050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw/pxMCs3PGZ3t1xDbLU2eOlXd2FRM6wCa/DdIh9vIw=;
	b=ABg26jN5sboOiEbl5mP+ymHsjVlzRkzTWU3bUObNqTlzwN3AvDMtymW7EOU6+A0WAT/Xz3
	bn2QUhGjXnjp9DtTQr7G+ZucZ7cTITq8CtiR1F+OEU9HtAMG84jWnw4gi6ffjtUW2tPq0h
	Cbi5zVZRytmf/6jYXpkGdjlXGE7jI34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772129050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw/pxMCs3PGZ3t1xDbLU2eOlXd2FRM6wCa/DdIh9vIw=;
	b=yxK92OaIInZOuWsYJVe12akQvMahjC0j0h1rnulH/CXOsA3ISY/56bvMtNLVX7NAn80XCP
	YhNS71eeOaKifODw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772129050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw/pxMCs3PGZ3t1xDbLU2eOlXd2FRM6wCa/DdIh9vIw=;
	b=ABg26jN5sboOiEbl5mP+ymHsjVlzRkzTWU3bUObNqTlzwN3AvDMtymW7EOU6+A0WAT/Xz3
	bn2QUhGjXnjp9DtTQr7G+ZucZ7cTITq8CtiR1F+OEU9HtAMG84jWnw4gi6ffjtUW2tPq0h
	Cbi5zVZRytmf/6jYXpkGdjlXGE7jI34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772129050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw/pxMCs3PGZ3t1xDbLU2eOlXd2FRM6wCa/DdIh9vIw=;
	b=yxK92OaIInZOuWsYJVe12akQvMahjC0j0h1rnulH/CXOsA3ISY/56bvMtNLVX7NAn80XCP
	YhNS71eeOaKifODw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C0A53EA62;
	Thu, 26 Feb 2026 18:04:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PXyWHhmLoGk6fQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 26 Feb 2026 18:04:09 +0000
Date: Thu, 26 Feb 2026 18:04:07 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: syzbot <syzbot+709f5ab0e03871dec50a@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, netdev@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	linux-block@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [syzbot] [mm?] possible deadlock in lock_mm_and_find_vma (4)
Message-ID: <btgotj7xgnzgoqwkfwk3pviof4cd6dnhxes3g32ncxz5ogcslk@epki2rug5yor>
References: <69a05ea3.050a0220.305b49.0022.GAE@google.com>
 <ibhdm4y3cwmornxfyxckosbznmtx3hi37tdp4xvha7a7wyaktp@rkrjyxdqmgb2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ibhdm4y3cwmornxfyxckosbznmtx3hi37tdp4xvha7a7wyaktp@rkrjyxdqmgb2>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4901180004
X-Stat-Signature: i9hmpo7uw737hxn87c6jf5iqdy5rjgan
X-HE-Tag: 1772129057-786822
X-HE-Meta: U2FsdGVkX1+0usyf7OTIBPhiVmNZfuBhNbnBW/DzwSDRbRp9urWsY9nXw3M+0va138LgBhpmbAQUyOKh2WAX4VtHJQLpfGVhV3HpwUOz7bGhS9XBC1lVhaQm9MDo3eK75v27c5/9awQcBft12KVYG0L+25fvvtDWQG60SqBZCyeyaL5p7ZeOiaXpd6QQBv9q3JObImu2ctF2yU2fGykuL1XbmaBkwd/ohsT6YBaBmmsh51SxmYyDttOCsQ7VF/8PcvS6wZDYoxiIonlqbrUYViLBIMe8ilNe2au7iK29eF2OOZnV1lhRx8Y00Q8dix1CFdMbvlFGNQl5EvgzGUCwolRWGBeTv2Z7w4u9rqJEizWQF/5oWvGTCnGTYQ1svZoW2U0sLooMCZZIRin3QfPB3nu9Gjs+tPjLTdy86E2Bm+Kvhk9Oby9UIYQjGoKxvWHOlW6gk89Osvn9uTEMVxs7eEbeOF5SHhGTCGxDY5m89k6drJaDhana3pWpeYrcm4UUtZb0IWnb9/ygIDC4a7VA5E8yr44MDp+E5W141X63qBT8Ckw3EFA0A4705b0kct6IfQ71ZLkFWKR+UbVB7dDj1ykv6wNaDXYLh6UJm/z/faDivKGLFVqV0FZImomd65j4WJXibQbxd9s4bdmL5cKgZuW6a9pFxTZvNcrNfsXWhBpExIZML25rhb6HLMR97BxkPAi+iz85uMOnBwYYmpdqOvbSwqkt8TYKrXKUEIDXbfVF7LjCeyi/0SzkPhorUgg3t7Lb0Eviuk4GMH/BbGxvjqGHbZYAptBEih8PgtIx5VhZw9kzdYBR5W9diI64H/3DXQp6eAYzDQol1rMwr1cO3IVB6tG4TsSw5eTdNWH+jZeelWK8kOzhTTFKQI/hrErqpB5qMZQL9JYP4Coch1j5a3uKXjRv4jM2wYgUZirWdFbI1HhXKMcGtkPN2hPfCOdS4waFZT3W2/otRyPT5AM
 uQGF4FVS
 PhSfyiRqhHEYcB60UyNtOVol+YHWO+oLar5prr55BV/kxATMBj2coS9WFq4o7tKZWYOYxoF7tBo1X0SAQS0Vk0+9XeKG0XkmdRHUy5gFL8J/HRjqfpeMFUTOiChlYq1gNRuo073Vo4LNHyixU1DJ7PgUJdz5W1k4NSAJZtv8Yn/iyXGiZm2C6nkVuUJ88X9ygIQeLjOwo6KT25NnUI6gf6zGRYPmANtFAC9hArKb++OnwLgiyaZ73ZhlKtrfL4DeJt5wJz+xv2BeJEhdEETfvXf7NUV5aAuUvytm/rSGSVkZ/h+AEtDIJGg8XP19Ws3nFROQ10eGeLxnOVgjU57veh32z6tiRAME/y1IwyKgt5dnvOK49ZztfsNu4LKy97z7Mnin8e8eXxxo/BersEJfg4wzTDsrWITeYe6pwLDO/DVDK7ZdCvkNaiFAiQkBmXlg/S++MwximksPz7AYiEjPeLL1OqLKWqk2lFb1bwIpgsn/OUbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 05:40:26PM +0000, Pedro Falcato wrote:
> +Cc netdev, block, nbd people
> 
> On Thu, Feb 26, 2026 at 06:54:27AM -0800, syzbot wrote:
> <snip>
> > 
> > Chain exists of:
> >   fs_reclaim --> k-sk_lock-AF_INET6 --> &mm->mmap_lock
> > 
> >  Possible unsafe locking scenario:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   rlock(&mm->mmap_lock);
> >                                lock(k-sk_lock-AF_INET6);
> >                                lock(&mm->mmap_lock);
> >   lock(fs_reclaim);
> > 
> >  *** DEADLOCK ***
> > 
> > 2 locks held by syz.3.3387/17804:
> >  #0: ffffffff905e2228 (br_ioctl_mutex){+.+.}-{4:4}, at: br_ioctl_call+0x34/0xa0 net/socket.c:1225
> >  #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
> >  #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/mmap_lock.c:441 [inline]
> >  #1: ffff88807ad4b440 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6f0 mm/mmap_lock.c:501
> >
> 
> It looks to me like the issue is:
>  setsockopt(nbd_sock) -> takes sk_lock -> copy_from_user -> page fault ->
>    mmap_lock -> allocation needs reclaim -> fs_reclaim -> fs does IO -> nbd
>    grabs sk_lock -> deadlock
> 

Another funny case that came to me just now:
sendmsg(nbd_sock) -> lock_sock(nbd_sock) -> tcp_sendmsg_locked(nbd_sock) ->
copy_from_user() -> if VMA is backed by file on nbd bdev -> ... ->
lock_sock(nbd_sock)

Right? Is there something extremely crucial that I'm missing?

-- 
Pedro

