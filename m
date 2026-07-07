Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2703C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6726B00A4; Tue,  7 Jul 2026 05:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE606B00A6; Tue,  7 Jul 2026 05:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862106B00A7; Tue,  7 Jul 2026 05:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 546D86B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:30:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCF6D1401FF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:30:29 +0000 (UTC)
X-FDA: 84961460178.25.2FCD8A4
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 231414000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:30:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZXplErFa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Vm55d+mz;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Z4cc2eS0rwx5IwNb987CsmY1noqcB8io5t3N1GtK80=;
	b=P1XN7SLXmupJ66Wp8ixCAHGq3X73pz0v/C2HuhHwAGeDyDbRfxJX2Y+D0vDwoBKYNYDoRR
	Q8VvhZw0V2ULhjAv3CJINHo8PiPZtzWE28ZZU8Pr4vcny9/79N28A/a5/yhdY7sb5KLXG4
	2di3gWKlRs/hkSYM7DdETjyUnnAc820=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZXplErFa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Vm55d+mz;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416628;
	b=hamNnWugKZ/MCu97FRVcZgNwSYwKtgqiL3uGcBFo00yEODCVg/+RuCvhDfOPTEHJ+JYK2l
	gL3640HXZPa94O4eIGLXpUkTX+M7e2YG/7nnocB+d0V6G+gwca/PmM/zdUFCosJgBseJd/
	MzcZKe3cx8jAyyc5hhF3D801HGmuQNk=
Date: Tue, 7 Jul 2026 11:30:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783416626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Z4cc2eS0rwx5IwNb987CsmY1noqcB8io5t3N1GtK80=;
	b=ZXplErFaCfJtnofpQhPfScbWI5IdUK2H89VV+Xunnn/KIR4jTTyXZhIzQDtgACqFHq1plJ
	u9UPCgMq0Cu1Q8WI5aeG018TK9TVYApZUCbwuUIxzkh25qPVIz872R5sj5K1ZjA21xpAzE
	EldNfrx42N2pWW4jvLnGxGbbZZW4K/rDvNVcyIotFW+ovDlhk94DpkRTDkuWeujHFJHZ4G
	GHWU9dipPwRYQ3K5nTJW5t55Sf01YL+QVdGVyC8/dCH3yKOm+TrNGtR4TvfnqzyglwqBaZ
	BM89CufGHUOsIy4OLjdT2idmM1fm0WhyceubntU0K66J9dZm8xCaPIsje5B6PQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783416626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Z4cc2eS0rwx5IwNb987CsmY1noqcB8io5t3N1GtK80=;
	b=Vm55d+mzQpWrPHxsz83nQ5l7qL4+ICHzbR9+xdGQDVGEDo1qV03otXbIs3E/Y0yKzctcVg
	tP39sWxZz+i3JWBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <20260707093024.DPG2lvt_@linutronix.de>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
 <20260707064030.D843llKh@linutronix.de>
 <aky05GBxo4VKGD58@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aky05GBxo4VKGD58@google.com>
X-Stat-Signature: orsm87dog86ipjxn19s5p356bwhkrre5
X-Rspamd-Queue-Id: 231414000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783416628-218113
X-HE-Meta: U2FsdGVkX19Nu1V/7DDIfvV5zCchPAjtQaNS0fTLP49KpptUCp4JZ7eqbDR7ehcFF3JrxBldXvZhOIZYloA8zeEUegPPxkZuiFUSSdslC+pD9Elsp4Ncob+jwmeQzWWts8604eQxm+Dn63BoS5yvDbkUMkTr+w6M8vPF9YUUEAFxuYSmesgyd8CtEFxa8E6Zq6KsQwoLDPH5I65fUYN954s8xrM3498vg2ZoKWiktSjWsuo+XLx9iASyvjVNTOY2jjDOktZ2HBasrMi4eXS0N9J2t3TVXMuSn2uWhYb/HzEiqF8RH5/lXZlY8YyqbSNgsCesspYYKuGileZJAW4AHoUMIfHrZnvEzsOMkGVWLxRSuOoZtwP9XixDmrLAQsA89zjmNLFkiBWOW6s0Xlv0sNsBA7RBobC6Fd1vAC7d4AvzX+iYIxZg8jKmUtEK4Wk7hfnSLaBujbM3YePsltb1jzp7XCiZqm81MQ48tMCa3Ut+BbaiBk1vOYGJq83y7qqbbHee7YLMrv8evuY2T2wVO5+NhlOznc75N1bONaAyx7uiUDPeiMNjH/GhZch9AbRM4BwYySUpwfLKbPHAqancrjJ0+V2H0R72MXN5yyZt0cv/+3JpcIkgohR02kEP/asq8DOrlCthzIRdHH4Wd20BdOMALckaJSTdo5cDGI529jn/9lOnGrpykTIR7natHtQhzmjRNycGGgEYcWBYzbYtm7CFdO+Xt4XPIJgQPsiSejYjZTp1CwRQAXNYJZjSnxDZYZPA/mkGhq/yS4HMJ8ZBbNUZgBowWkbALoROLvO0du/bT1THViSEtqySJtTl85e0AqY+IYJQEwtNsyoAFJ2xYQk5BtV0JtWzTVR2w/O5w3sFpMYTKysatfrPWmZ9bQMB5YwCZfOOi8uXcHSPpB3OSarMnEauU6Gsi1y1n7MTHgNI/QuoUT7BOdOLSh+SEaJKnEIhpOMGU3ikhX6efD/
 0A3QmYfJ
 aFUvd6CVR20Bs/8orP3Gh4hhhN/CUGBxR9a7H5PHrdgMiZPBaZc/8crZUm1an3mlZK/05nYvi93tpzugo7mkruz0XKHyJZBp1mNcRmw6Xw0bWRH331zxuz2bTiA63NpX4w9CMjcKu27W1IB5Q3R0Sik7KdARMVeiac8GQqqokoyki7H1IjETFZR46kGAo8prNqoFR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 17:15:21 [+0900], Sergey Senozhatsky wrote:
> On (26/07/07 08:40), Sebastian Andrzej Siewior wrote:
> [..]
> > >  static void zram_slot_lock(struct zram *zram, u32 index)
> > >  {
> > > -	spin_lock(&zram->table[index].lock);
> > > +	unsigned long *lock = &zram->table[index].flags;
> > > +
> > > +	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
> > > +	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> > > +	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
> > >  }
> > 
> > Looking at this, is there a special need to have a lockdep map per
> > table? Wouldn't it be enough to have one per zram? Logically you use the
> > same __key so I don't think it makes much of a difference but you could
> > lower the memory usage a bit by having less of those structs per zram.
> 
> So the idea was to separate lockdep maps and keep them per-device
> because various zram devices can be on different IO paths with very
> different locking graphs.  E.g. zram0 can be a swap device with all
> the locks that swap layer has, while zram1 can be a "normal" block
> device mounted with ext4 with all the locks that ext4/vfs bring.

Ach so index will be 0 for zram0 and 1 for zram1? In that case it is
different from what I assumed. But you use the same key so I think it
will be the same lock from lockdep's point of view. Like it will
complain if you do
	zram_slot_lock(zram, 0);
	zram_slot_lock(zram, 1);

without nesting.

Sebastian

