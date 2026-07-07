Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D142C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0656B009D; Tue,  7 Jul 2026 05:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1983A6B009E; Tue,  7 Jul 2026 05:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFE46B009F; Tue,  7 Jul 2026 05:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC2F06B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:42:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68AFDA03A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:42:57 +0000 (UTC)
X-FDA: 84961491594.10.A5CF62F
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E00F80002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:42:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YvHISaTr;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783417375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NG43xqiTlZetTkoltquLMxLW5gZsV1d7NlplgwQVb0s=;
	b=Ay/vMAwnfIW+NCGVuGGqD/yUD4IjAcaHNi1T4KiCUKrXxo+Q92ZOqg0Z9rOC3FaPIz5Eu0
	vZFWpy8IxlDMkst85pcoGI26wIaQn+iwt1EZW2XmZn3F7W13GdpQb+LMcd17KZ+ViT09Hp
	xPE1KVmORXp0z67Sp9y2JiBhi+Y52ZY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YvHISaTr;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783417375;
	b=quF88nnOSW2HliTGKQg0qRnSW+2ZJ8CL9sNeh89YVqiop4ZoZCHiCuxRwHQBzRNMK7Isj4
	fq7AvnkoyM+JywvrE+t/I/xH5pPzsldX/RsOA9o8Dt/QcHx5nkEGfdIQFRwgGygZjSMWSw
	PYr2ltBKHjuCStNwPz9f/V7wbRCD/i4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1828172a91.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1783417374; x=1784022174; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NG43xqiTlZetTkoltquLMxLW5gZsV1d7NlplgwQVb0s=;
        b=YvHISaTrS2QGbpg9T/8iD2LowJbJCakhoWlmlCGB6P2wNXiiyR5rTEEf8db1QLMeNX
         JqqnnhfXxebe34f53Pr2fy3n3gpRJpDlpVpD/t+xnKIXcn2aBE6dDXOdff2rCkTdfEPP
         wqjM6SvcthNO4RKzOXbUkz7QIps5nFxKW7tLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783417374; x=1784022174;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NG43xqiTlZetTkoltquLMxLW5gZsV1d7NlplgwQVb0s=;
        b=swpGBzHOKNz6dSHGW1mnJn5A/g9sSLYn9LvC5sPbAel/U5t3u2Pfwns23U93PZyZHq
         7nDd0YG5wsGr8zqAKblj5w0W2WCqsH35FYlzws+RXsYmQ5f/arhLyA5feA3Rl88s61cZ
         LAbm5E9c8P9IWFCamu+8hFlHLkOjPQjzu3n2O0kPnvBk7qUaBdQYaH5hLdNGeoGI5q/a
         xPvF5zwhgGTPGQfEq7IcHH37+fnYQ9koVBbOGEd2pjbtfwk7N+MEwZ/aYu6uCB3jnYkC
         Nnu9IfO+IHFiXKQFTv9UmJwgrfm7Cl7SJtZ/oGgAEBFodjpMrb+fqaorQqzJPEjAaNyh
         44gw==
X-Forwarded-Encrypted: i=1; AHgh+RrZ4TjNG+E9Zi1xp6F2bgEG1AdQj4tEyEDR1S+e9AkuoQ4wJzYDWP6TQL7hw34EQvU5U3vcRI9POg==@kvack.org
X-Gm-Message-State: AOJu0Yz9i5sAQl3N9P8JfCtij8hsvvqUaEfeg+gs7W5OCMmG2qRjb17e
	6hFYhEc9e0nMmhOiMUAkzb/2cs/lLtanBzgPOrJF+j2mf4AhDwNkjC3enu5zF1fqNw==
X-Gm-Gg: AfdE7cm9E3GYEcrtpAmYTkS/m0fWEEJzeroglF3xmkcLsS7mQgPU63QlBU7AmfqNPuj
	OS5xylQXtjkRlj4+eq/JWcrk0PpEmNiGmBus3NB010MzQ4YU4EQm+Y3vp2iPsKip29zBMxW0D/t
	YgwIE/X3mVoPCsT6MX5hT6oTFmrPqsA63wZK/LgU4iP4oI+GYDTvLmLRA3V21aBql/nvvr1w4so
	f5KgxerLyggpvlizRzvITiHLy9koA0Cxv12MAxQY0Ej6llGWq1LDfbOhH0ETHpABLVRfL6LIssG
	ZTCOgxvvG/NF1VCn+R3MdHWw/xK7am26NgJxwavrvlnSMYwtOqbNdI2X9tROQ2FobiULV+fOWQM
	r7/etC/36l4zPNpdn1hZSViAXcTt0FDYzyko2pQM7pp11CC5Iv9lCsqheAIITtYsTY+ccQDZFlK
	/3vhOrgq9AcBbMm4l3U4IWdZcvxJg8x/hkGyF5U/Unnr1i5N4zhpPb
X-Received: by 2002:a17:90b:3808:b0:37f:9cdf:f037 with SMTP id 98e67ed59e1d1-387572b3d9fmr4095937a91.26.1783417374535;
        Tue, 07 Jul 2026 02:42:54 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:d4f4:6328:49c0:b912])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d20a2f2fsm797739a91.13.2026.07.07.02.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:42:54 -0700 (PDT)
Date: Tue, 7 Jul 2026 18:42:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <akzJlY53m3XBg9Is@google.com>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
 <20260707064030.D843llKh@linutronix.de>
 <aky05GBxo4VKGD58@google.com>
 <20260707093024.DPG2lvt_@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707093024.DPG2lvt_@linutronix.de>
X-Stat-Signature: oscixyz1h4jcc4ms7repxyy1cc3r31xm
X-Rspamd-Queue-Id: 8E00F80002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783417375-259058
X-HE-Meta: U2FsdGVkX1+uAKVMooOG5/9aa44N+hEQer8nzkhetNX1LQkZCkVpsMnw2wdWepoICWabi7vFXHCbjXbzlKolEhjdaK45s94QaP207wg8uLATMID0wfczK9hzGtFDfd7yOchH8KpbXQkongXdjrQ8xcZ4xUqwm938bkCLpIVzSY6I8AaD65/W12lWcMBIYedGb+CIDW2dKqrBs/Iouhd4v3sB4/oXq6tP+X1Yq1tixLFVg2dVObUJHDQd21JkHt8EKCtGjCswAvfcAbwivhQ8KVmq2ePzPqXvAgX82z9BCC+mgmAXCRNqiVDDRINO/BIELOtcyEcLHoDp+84ptMeM+FJveP856cCXZGvONayQkftxoqkS/xcACimLJHGhQzrJVzbe1BMoE5qVQ06wkC3lvuGpjSUMjGhuAll0DJW4EHPZQb0zS82W8hnVWv0ebEH6Gmu0x22aNeC2HrtkbvQ/GETUsXJ2CUGBkUej1Q+mN1sC52wethg0Kqw0X6RWxGsSbUuNKRmPqYytvCmFi/OBl4Dj8t4GgoWQ6d2wRqI3wfZC+h9XhYADTi+SBLXhu5T1g8O8/jVPCSvyJsVhx2XPBgisf4Y6aj/A3zebp1Dz+T7WQgB7JSfaWImBrN/uNtdDEIQ/NveEbOLMdfcBCT823XYh+VC2LcEQlX8HZxE6F703mE+rMNxRZ5EFi5fW1HtwlfuNYlcZ0KCqMSeH3nqY/MjYElUAnJHtnobXHIEx/SHttgWc7MO5NCRbM4Fq2iY/KNKisVrOKq5DlZs91O8lJOVN5s3JRFpHKoIkh4CtGZz9jNJYY3xvoDMvJh7zu7R9ejNZEeWz8h5dc9tN9/siJgVvmVM9LxZRKwxSoCk4jM7D6yRzfU+F1DlFOt6xc/4YaAEn5GcIEd/hCKneO2nqp5nGp/ZGFKJs6PUObARsxt1NJQRkzdY1ozYUEilMaiYZcRj/4svoayaBVNNLYOx
 vK9k0fm+
 uqVtBqb0Qdphtnaw8fjL21o7nhATmzwNtL9BOm90rlnMyzeI+kuHFGWOW82uKbs4W6HsHO5hDxnluAdkeAe4zXLN03FHKSyugzXH/IKsXRZZ5U//jV/XmDIlN1YbD3WYAxrDvLG3gsUYgmQlYogwQaR/Kx+KCgKtB2yumMwvkpQf74PlSUK+MTF5O/olaI7lEXcHn8q5P6k8gcZcI4O7nhHjB3wK7lMtQ+yBBd735L1xN2LH7f0nCHjifAWxuHegEAmhmkxTv5UhUOiOXXktd4CZr/rFJlhfb3EejWtZGJJMlWQh0sZtQt8idbfJziEfieJd5ir7nk3pArbK2tl9Bj1KfVXhzcUdTsBtzaVDnk52heKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/07 11:30), Sebastian Andrzej Siewior wrote:
> > > >  static void zram_slot_lock(struct zram *zram, u32 index)
> > > >  {
> > > > -	spin_lock(&zram->table[index].lock);
> > > > +	unsigned long *lock = &zram->table[index].flags;
> > > > +
> > > > +	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
> > > > +	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> > > > +	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
> > > >  }
> > > 
> > > Looking at this, is there a special need to have a lockdep map per
> > > table? Wouldn't it be enough to have one per zram? Logically you use the
> > > same __key so I don't think it makes much of a difference but you could
> > > lower the memory usage a bit by having less of those structs per zram.
> > 
> > So the idea was to separate lockdep maps and keep them per-device
> > because various zram devices can be on different IO paths with very
> > different locking graphs.  E.g. zram0 can be a swap device with all
> > the locks that swap layer has, while zram1 can be a "normal" block
> > device mounted with ext4 with all the locks that ext4/vfs bring.
> 
> Ach so index will be 0 for zram0 and 1 for zram1? In that case it is
> different from what I assumed. But you use the same key so I think it
> will be the same lock from lockdep's point of view. Like it will
> complain if you do
> 	zram_slot_lock(zram, 0);
> 	zram_slot_lock(zram, 1);

index is PAGE_SIZE granularity "block" of device that holds compressed
data.  So they go from 0 to zram->disksize / PAGE_SIZE.  Should I use
dedicated per device key as well?

