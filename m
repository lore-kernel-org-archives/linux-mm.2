Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECA0D5B85E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 17:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4B56B0088; Mon, 15 Dec 2025 12:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695A86B0089; Mon, 15 Dec 2025 12:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5833A6B008A; Mon, 15 Dec 2025 12:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3267D6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:50:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99B40C01B7
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:50:01 +0000 (UTC)
X-FDA: 84222443802.17.2DF9CBB
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf12.hostedemail.com (Postfix) with ESMTP id 800D040009
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:49:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Lnhp07r0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765820999; a=rsa-sha256;
	cv=none;
	b=A1+Xb6qnYPJo0ylX6ssHKj+CEiC01Yrd6V9fHYh/hasUjF+29LPEzq/32WbP7KLO+7okML
	qcBYXgOyzjcGsJwxEwr5NB8OdpcfKttZYn3b/lsiHVM7+JeJls/WD0CuziwSFbJD4GwhXm
	DqTmOZ/SRiE5b2qaqzg4tET0PHFuVfc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Lnhp07r0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765820999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUQK5ROZQGe5dE7A/2KMYZ29UfZNXQkHdANhLdHHkW8=;
	b=fl3JenUJCjQGRkQsHgKlP2rp+C/b9CE87JW8T88ojtjZ2Yx16w1OV/IJUYNPjZ4AvbEZbG
	GogGKxbY7MypHhX/6SMAA5jlsSmMkLYwoSgl7ciLqHb70am2FHTp7klI8tKIgZSDRTaGzk
	KTpfN3gar9gQe9JEJliVOmp5rbxmD/c=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so28855135e9.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765820998; x=1766425798; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xUQK5ROZQGe5dE7A/2KMYZ29UfZNXQkHdANhLdHHkW8=;
        b=Lnhp07r0ZmjWiqOGGI3n89t6xZ7fU8q1aceiNVi3x7AL6qrWTa2/g+FAM5DLXObH3V
         Ydc7rozwuNxr6bGiAYQV/7oX1mx0Z5wwGIxIsCLdXyS21pBSIjq/beJZBP1FA84FpX9C
         A9V4lYOb6ZrBSf17WTaE5Ve5LrzZvGwVr997BFIej5Px0AVaaw21GpBVz5xbFjsDNSaF
         CYwC/zzhAEUSA8eZs/+IjIBRER1F+6ATQ+t8lm766Yc85vE2VoLnC9MWyzLfA03RElRH
         zhTrYysKkcS3wyESL/bVjfftz9NM9kLzXBNsqOZmIQngEj87uq2y5/LV1GTB2nN4hUdQ
         9A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765820998; x=1766425798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUQK5ROZQGe5dE7A/2KMYZ29UfZNXQkHdANhLdHHkW8=;
        b=sBTda7a16Gy18QspjSHuC7vKj4d5McQ4jSpPU9VwwTH7LNK8GyI8OnzL/c3QW7xqe6
         aASNYdFz9/ygHoaH+ZFYK9vRg6JZUMsm7a6j61Qu+e5GSwiHf3SDKg54x87zvPUEFtV8
         n3Psr0f1ESubUGiV9OvrPqZX7dQjT8CMwFnS4NgpYH50wIo5PBPUgFIykc3erThjbRbT
         asFNDMGgzt7b6M0r8RJtFTH0cCdQ5peiIMFR0hijpMaGiq/pF4pmaadOixyI6nMulbAg
         XtX2mYSY5+ocnytSenqioGHMoZ6DH6ulGlqaOo2l+EsP5vF4L1O7WDjBnetkEDLkI8Hm
         2ZZA==
X-Forwarded-Encrypted: i=1; AJvYcCWmwa5VUSzd0aVMskGhInIQTDnB0Z9hXw4i1n3C3wu7UIC2fudrfJB/lClmKoZSbH/jmz23cbEPBg==@kvack.org
X-Gm-Message-State: AOJu0Yzm3hCvBkam8c4/BtY69gHmtpO0fWoIkVRRsDYRTnZ0+eJrwGzj
	28wof+fG84sxiXOFOj61l0lBlhMqdylC7NxGmCdOmR6ObKIh3gOsc0Y6//pbJdpsoJE=
X-Gm-Gg: AY/fxX6WxYpr3s08jwn9W20XvN5+88RYX3eHGDLaFy3UfaD4YI9ATpNjzgZusOru6gW
	ChdgQh5ILSbOqv0i/k35jANgjGKwtqkCG76kwFx5Hif7w4UG9uZefwtYh11dfuWzu7/bD0R+Ae4
	hE6/O1eRuq+MuIyPrcb0H0vpg9j74tw8QqQ3W7Wh/FVk+aTFxikdLEkL8aB/IX3cOEzqDDEIGuo
	a2BCrrevJTe8MmWUCQdrqYYozxMF6STxJq6XFmrzxTZkP+lC8/djoqgUP9AY6+QsqpPOdAW7w9m
	cj1lylzzZls667CP30/ksARcEfMKhRNwqojTfCl7CIbu4hVo6fiSpQammJugB7ptLyNOHjh+nR4
	k2gHHcL6jzlIbTarZ7BRjpjh3GEGnNuMtGhsflIusbAlmIGyfko2yFT0s3kilDWgSpoql/X7UBb
	59NecEBAg/3otBuW2ba7+gA1cc52tA9/eqbLY=
X-Google-Smtp-Source: AGHT+IFoGs2wdqL9XS4JsAKRnOl1rHpCgPt89A2Z4w82CAVCNT2UUiuHB/eJ2CZAcr2P2cCxIdwdjQ==
X-Received: by 2002:a05:600c:470a:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-47a8f916db9mr118138145e9.36.1765820997911;
        Mon, 15 Dec 2025 09:49:57 -0800 (PST)
Received: from localhost (109-81-92-149.rct.o2.cz. [109.81.92.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd5f8ae74sm124075e9.0.2025.12.15.09.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 09:49:57 -0800 (PST)
Date: Mon, 15 Dec 2025 18:49:56 +0100
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	yuzhao@google.com, heftig@archlinux.org, oleksandr@natalenko.name,
	bgeffon@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
Message-ID: <aUBKRDkIqlisJzF-@tiehlicka>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215041200.GB905277@cmpxchg.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 800D040009
X-Stat-Signature: ry94zbiq4oc1sc8myjrgpyszwkp1qiyw
X-Rspam-User: 
X-HE-Tag: 1765820999-468124
X-HE-Meta: U2FsdGVkX18aALcF5Lrt9I2OIOgXILH/djW+r4VCDUxC4hiDBJv8r0UPewMeIurVjH6WAcUUHzkD1Ev1Pz9FwusIfqUHEBPbgNgzZ3RJ3xdgmkK3guxtYpzDKjhJ4WQJ0Rd/juBhNpZn7Q/uTAEOwdMdjqTJuRC/o7GhlfTEWjg58/Ek8jYOroZ7Hx1X+OE9yqztK+N32A1aWWPRfyuItogsgjpQuvJ057Pb67rJNCc8warGomxoXyfjqeWXFLWd7O7Kmn6TERkaV2qrryphKDmfa8sRsVtRUdG5HtOgTIuGm6XnGnKioC1GdWlAsVW4Qs3nmE1DvxlPr6jhxNFBaw97CdsCws4IQJuf5Mj0YVxbpOxJwZoaECOg/Cw2wG6RCT8jHFLSxf5hiiWhTppdDQVxR+tb+9UBkJoq2Jeth4/DDiRgSlTk7Dr+HkFGK1M7Jm3lSKSTmI/2hAbZNTRWFWadBA1TiXPGhmpMgjWXctprm1KFq+f4E9NtaJ0kMackUOCsvgZi4HYV+ixYv0uK/n+NdA1GuY7pNRQeMME9ccNbUdlSiPhGZiuD1KVJq+ueCBjXNdPtiN6lQcmUzy1ktR6ohGNOtwr5oqbd6QnhKxsHOBCYRRM2pDfVKx4+ll54ulh/IQBooTStgNpCLGfXthjD5sxm05CMSNjuXDMb5rZWcbBQJKN8VTpTVRkDusK6ZTCrDsntlvLS7uh4WgM752p3nhgOj2yYBQg7kijUeTFwEKyqmyoPxbXdMVzk3uib/hZXSmUdmX9+kZUgjZ2pRUJ6GTfMeRwZI/QDeSgxGamxfye5QnzWu0ERHfcYws8F694plEo7RdboLR4NuTLbblLmX003aWxyqxmpDPnmaTgJoNkRhYN4S8nyv0nDwWOMxaVtgO3zTiUBKThFwOZVkrHkG22LiGhFrnsZZgMFX1Ban/xZyjAmDUjXB+9rGM0KfrKfAsuzYOhHgh7U47t
 wl+L/OWG
 bZ360+LP/6SF4y0+nelVRZNAsz5lDZMrIigIJIgc49MGnfa27+fyNl4xhcLotEEDzIesHT//v1dEbKTS/ge5PRrrhBApl8IwlLA66P9+kjfVpb0XY9eeITfTs4QlM8aV8thg0sV0CpMYXa+y8IynbWiGDvLG/B9B1HLsGyXVfec8w5ZM74G2pVthmG0AfreGElxd+ADi1KrfMibgo3XWkGgkSLhf5bitAG3YDuhDSF4YTOLCTeVbjxyBeRfEfH+Amah60P2YAin8ahNwP1OLUFgHR21iNl8jcOa3UEpbqvQVNMthWq9ma2dh1Md64GVPGGZ5xx3j/uU7O87CR8v8oL//SGzrInaEtcHPt07YnPOulGaNw1nmW+EqhOJS0E5A45NDSmWF5IP9DO4D1qaWbFrSwjuSwf+XdSbrTL6dlP+Kee2wxcU6ahtnJ1i2UWTEZ5ec74EF744+rBzWwOQ/Pb7EdD8U7Q/NRZ3a5zY1e6KvDREBZzCBPt9vnRE4OE6DattEqPXoUuDDbUvcamoqbwqH3RX9cdma5tdRW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 14-12-25 23:12:00, Johannes Weiner wrote:
> On Sat, Dec 13, 2025 at 02:06:39PM +0530, Deepanshu Kartikey wrote:
> > When laptop_mode is enabled, may_writepage is set to 0 in
> > try_to_free_mem_cgroup_pages(). This triggers a warning in MGLRU's
> > lru_gen_shrink_lruvec():
> > 
> >     VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
> > 
> > The warning occurs because MGLRU expects full reclaim capabilities to
> > function correctly. The call path is:
> > 
> >     mem_cgroup_resize_max()
> >       try_to_free_mem_cgroup_pages()
> >         do_try_to_free_pages()
> >           shrink_node()
> >             shrink_lruvec()
> >               lru_gen_shrink_lruvec()  <-- WARNING
> > 
> > Unlike kswapd or direct reclaim where laptop_mode's disk-saving behavior
> > is a reasonable optimization, memcg limit enforcement is a hard
> > requirement - memory MUST be freed when a cgroup exceeds its limit.
> 
> That reasoning doesn't make sense to me. Reclaim is always in response
> to an allocation need. The laptop_mode idea applies to cgroup reclaim
> as much as any other reclaim.
> 
> Now obviously all of this is pretty dated. Reclaim doesn't do
> filesystem writes anymore, and I'm not sure there are a whole lot of
> laptops with rotational drives left, either. Also I doubt anybody is
> still using zone_reclaim_mode (which is where the may_unmap is from).
> 
> But let's not introduce more inconsistencies, please. The only thing
> weird here is the MGLRU warning. What is it trying to assert? Clearly
> whatever assumption was made here has never been true.

Completely agreed. This patch seems to just paper over a warning that
seems dubious while doing something that doesn't make much sense in
itself. Dropping laptop_mode from the memory reclaim seems like the
right direction anyway. I seriously doubt that it makes any practical or
measurable difference even on slow rotating storage laptops these days.

-- 
Michal Hocko
SUSE Labs

