Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4777C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 04:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369696B02E5; Fri, 14 Aug 2026 00:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB906B02E6; Fri, 14 Aug 2026 00:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209DC6B02E7; Fri, 14 Aug 2026 00:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAE9E6B02E5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:29:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46F2A120337
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:29:10 +0000 (UTC)
X-FDA: 85098595260.06.771F000
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7024040008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:29:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QptvfSGD;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786681748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YV4tfg2m9+nVp0ZHuk/9lCg/ZtZzpaoDWN5osX7Noo=;
	b=RAG8Iwz5Jj9dDNKFuCcacXx9gDPFEVnPqWS6B0laTN6ApMZQAY++RnBku20vTQSHw95szv
	KUv2/Zk4nWojNLewgIHVbWLCQ5Sqqjku7SIyW/KIVa9GO8si+G1lbB8VOduQuQiqkVRBh3
	O0MsMYxg60rHVNVZ5IfAgDsDFZmtats=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QptvfSGD;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786681748;
	b=vZ0zV0hXko91K840SEceiK5W14hCE5DRyJ/8Eswu2cGAw2LrPVIrGwdkU/YPGGY2SA+BP9
	FgN6ohzaqEjg35o1Uji6HmC0MBH3N5lG4nNL176Ur/XbT+nuOZmnStcNqFAvmgjIOFZKRj
	BI7xc6QJDDOMhQs4+EukYVw13fSD5p8=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbeeaac53a9so592755a12.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786681747; x=1787286547; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9YV4tfg2m9+nVp0ZHuk/9lCg/ZtZzpaoDWN5osX7Noo=;
        b=QptvfSGDIUxy3kNTPeQEI9OU1xnFJtPUWCBC6lqU1d4UT4T+YiYiDtQnKXGmCO178V
         uCmeEmOR91KA5EjfsLHQ5aJWWLZKcKWDEia04nccaeKId1rVgkWwxI/zJ8mvAy4Tx1Ku
         dTE1DPZqf5wxc95t9ZIQGoJ2KbRx3/irT1ZTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786681747; x=1787286547;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YV4tfg2m9+nVp0ZHuk/9lCg/ZtZzpaoDWN5osX7Noo=;
        b=UggrY03knGWYmuY1TiuR6D3PAX+p17s0Dyld/HqOenNZl0BI/BIX8qSwwYr9aFg8zQ
         Nn9gsZ2W4eOQK0ckH6NYtGmwCrwmlcaJnXcr5pMS94Akhc+akohnRM0UKcs2Tm0kNc2n
         NLsDDj2dT4DtXoP/tqUhrnpU46GQ7eNTHIKmeygB67MC3oBTH0YGA3HUEz1GPSVzH0xC
         MlXcJREyxmfXcNh1dr5maZfCo0lm35whFITOgP9adbBa4mX8b5V6aoo/DVPRYxxLBcM2
         p1acuizMp+mmzxFsHufJmMtm5Fo192bt/llGapOjLuEjV4dNblrHd66iFDJOHtq1mcfs
         ktJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqVZBaMLixsYt1Xu5zq+SuwY0pwwxz1Z4kXFYPwbuGhE66ibWxkZFsjpERUkwYzJEYB/KO/arpK4w==@kvack.org
X-Gm-Message-State: AOJu0Yyxp0dctjXCbFost9eGIHi26XszoI3Jr6d3QtaZKU+ABsBlosq3
	PuBtPLN6I9mykPvnnbF9TsnJJCBAy671Y2Qdua1y/2eWZ+FBhKKh9Mqq3a0dpugirA==
X-Gm-Gg: AR+sD105RtM15szWP5fVui7R7xdiEXSbFsC97d/knQVC4CiPwj8UW/XUVOKtE5ZtUEh
	XB4ibSGFm8952LYbJJMuqVuwwIRQQ1qW/pdclu5YVe1Bq2Up0H1Lv6GUY+IEjL7qoJfd/zAEYtX
	sjHHv5gc9QRcdigwZo/rjN2II/F0YuomwUUqZJyuqrYlZGgIysxJvRetOz52zsd+0HcUoubd2wl
	+wL+HfZPTOiGFlnwnkh7C9XBDPDzfkYvk17yovLCuwAISAaXu9lLPkwhyJNhH60bETh6nCen5D1
	6VIYO/MJ3HY0diN9SeKr6p+cyK5nB0nEGvdG7oHKwCE0pKe1UbqI2uZLgaWFX438hjn8QU5JSQa
	89PCx4ojZjT8wZQobrRKalSUbcKRHnSdOIAIc4faMh5M57iqNPfya1VzE7EgX7GNqb9+onmov24
	BKJHF9PaRtF0fAGivljGfw/cb6kL1peEVLp0nwd+utqLPVwJ6jSq6onZmJQnkIzg6x4MglmQyBR
	nvpWTwgv/S0XNUpz0Nqf9Rbk94=
X-Received: by 2002:a05:6a00:3ccf:b0:845:40d1:87fa with SMTP id d2e1a72fcca58-84fde20e2a4mr2922939b3a.25.1786681747221;
        Thu, 13 Aug 2026 21:29:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:ecab:fe19:825:5aeb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fc4565c6bsm1584682b3a.3.2026.08.13.21.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 21:29:06 -0700 (PDT)
Date: Fri, 14 Aug 2026 13:29:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <an6ZDKb9vDWYjM1F@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anLmcHXqEX3HvSpZ@google.com>
 <CAGsJ_4wS1vhhrvk+BqLK++65ebENQE7yBPrM19q4HoRNEq2ckw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wS1vhhrvk+BqLK++65ebENQE7yBPrM19q4HoRNEq2ckw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: f14o86xgjzbmmpbkn43e4r19gubiqtar
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7024040008
X-HE-Tag: 1786681748-498415
X-HE-Meta: U2FsdGVkX1+QMU5HlbkK+WRX+vdgSKLimpC8oHStRkgSXu2h8pEl4HQPVbmgXbYsj+QodqmbrsSUX8q5NOC7ToLEmro8ZiigG5XtbYrUjCzfZswoM6QdlqbXqsyqKTrSet/MeIdoUk/nQks0DVfHE7EkqjwHJTIVPuPwqkkIlqp0x45eh8Pty2HmfnnB+OqTwZU3RTL/HNra0a8Wf5F97ip5/MJPpspM2qQQicF20wfBiHfU18pzjNThQ1cwF5iOufP/XfAY+b6RijPjOLfywuAgt4BRohHA+jyReZPfGcBsyMcu5lRqjzYTuyyiGrCmjjDyHXTYUn0opygxMgtt8NpFAtRZzXyFUdt7wEe3audl8C1I6F0U4/2doL/g5vl5IMN6KeiwC0NjzIopQ4ZRbYKRHpp7JUa7oMdmy+fYDLbuDSpRy0GjbgcZvO8lxrrvbB8xD8a/eFHbqUoZ9Au74A6GjoMlUeNigvcpK/UZBokIXXeP8iNfTnYOQht0hHrmA3r79n+BGKQsUI3yDjlBmh8myq2pFdI6Dpf+7PHNYyx/74Hqs8MJQPzeUMiHrq4cXqluji12ZLBUj933m5uulSk3LAcUtKIRcfExkyJeHHevCS6Wf63ch1IE6ZS5hHacOHhczCveQEvzegwrS1hUIfV/iQHcCiY+fDY4HCUtQu10weKXH9NgDyjI4W3oE85lD+hZGb8AzBkZvrjBFaNHUkrpGJ4bgZjc5yGZ53f/o2Z8chnEuzmdJzBy2T83RiNMjD7WJEYiJKTfoXa9/dFQiUvc61CwglbQsHoBkg2FHCzXo+UOTSuZawoo7O3wurgfsNo2zHcpk4GDG0Hrd5IbrslwivsCIEbrwGoqoOQEuF0rLGS73PSu/Pa7s8Um8QGGVT+m+BNMM9LByx+MKTAyuJER3Ve5S5r8HaNX2ULAFs21/Dhb0SmDePxHOi+AujZGcK/gNXdJp/X69iG7Sfa
 AcCcXrWz
 d+xqKIiQjuSXqdCdWY48vVooE2e/tsNMdOh0GzpFg1h2MNyFHe3Ez78ritOCjOMUd1/ODtQ6Cod/SIXcUIfQfExWNK3+MzoP9RLD8NPvGe+eTn9VoDSbBn9e49TMUXCapdg/hEoIweX4rk1IyrmWEuAwz8mchyddP5dpQAKROji+bwqZ1PKOJ3mCohAfivIEEGib4/phycTPJSZE71hiDRn/Uvd+yLnbHXHLSATEQp5ejiLywCumW0OoguD/C5CG1lrsA4O3LcGv7LaC2T/SUGUSIssJaIhVzd9P5tS3lLGhOyxJP4olc4bLfD6B0ZWHDYy2ASccyAqn3vcqLGbEwJzlGPvxXc7eUuxi/bt9V4er1Z3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On (26/08/14 08:07), Barry Song wrote:
> > On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> > > @@ -128,14 +128,20 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
> > >                * so then unlock and re-try on the current CPU.
> > >                */
> > >               mutex_lock(&zstrm->lock);
> > > +             if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
> > > +                     preempt_disable();
> >
> > We take slot_lock(), which is preemptible, under stream lock on
> > some paths.
> 
> Hi Sergey,
> 
> As promised in [1], those patches are still under testing on real
> Android phones. However, I'm quite curious which path takes
> slot_lock while holding the zstream lock

Oh, I think you are right.  We do the opposite: stream lock under
slot lock, and we also do the stream lock -> zsmalloc lock/unlock -> stream
unlock -> slot lock/unlock chain.  But it doesn't look like we ever
do stream lock -> slot lock, you are right.  Sorry for the confusion.

