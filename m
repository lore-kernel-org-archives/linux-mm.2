Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D28C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7F16B0113; Thu, 16 Jul 2026 13:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562266B0115; Thu, 16 Jul 2026 13:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A156B0117; Thu, 16 Jul 2026 13:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12B316B0113
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:03:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B079C0257
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:03:08 +0000 (UTC)
X-FDA: 84995260056.08.8DB4CA8
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7722E14000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:03:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C4b2ZbcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784221386;
	b=5E9XSYQVdtkjVISFkyiTrm0B0e6nq2C3XJMKA97RVi6aqSRunEIli5Z04hzvsku1nDt3Za
	TkEbIvDyhxhmCOEDWgca5ybu3D+2vIGys21Nv5pZKxFMtmpvlSpFrQfTOIyhRXJuh4dIOX
	vGn42iYOOHlVKXsVzz+6zcg2tt056bY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C4b2ZbcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784221386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSpduXrrNhMv2bQ1Jzsq3XCQMeUYVVM0a32/RoJcQnU=;
	b=XsCbF5rgd4vqJb6f1HwSPnqZcsGxTOSslcWROjB2k7+/OCVat37tyq31YfRz6e/6NiIIRd
	w+RKa0lKxYOW0UtbSkRae2W7s9u58dmFGN4E85pZahpCZxPF7xPu67ixLgclPkt52FhF5N
	DL7T77Se0eoZFs7v4d+eY8niuyduDRI=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15dd4b9132so1021781066b.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784221385; cv=none;
        d=google.com; s=arc-20260327;
        b=qgCNNMJP21lwed5zFPsLNq/y5kmIUXTdIx8pfv7l1yHNjxSVcvvSDKJZdve7l6kdkb
         mGQqnmOUMt06L9OCl/h03ZARTIGlfF38urIo2fkgHzhXSah4pm3knnHj1DmXTutckrNn
         zRlSxcT6Am3RekXxv1etBfRjjr6ypZJfq+AaQR+FpGODg4WzaUqBWuij/rg3fihDqTzD
         k/VDal6ms9FdLK0LUOiVYst0Hzp75XvNZhvaBzDjm1MUVkElcnx1c0/IjUmXsFCzlp5z
         ElQtYBFPlBTEH6j6b2k/X7wEZLgUA7uPirgLfUTmEjWM49MUWNQ1cWwc6rCiBqJSbdUT
         SR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lSpduXrrNhMv2bQ1Jzsq3XCQMeUYVVM0a32/RoJcQnU=;
        fh=Spwf2kiW5Z91/GEfmo0jIRhAL8Hz1PFfgEdhF9FfQ4I=;
        b=GwILhJdbRteDe3nZuAHSitT0VmBYbpqiUi4tGZ6oeU62lpqL9LKGgQqg1gKLpYzcQR
         tyKke8MJvpB+VNNWNqY8ScXIVbFUZlNXJ7kKpghM7/i/SKeOXYdJ4s/1A7Yl08UDDKXt
         IMiCtb2on/WDIKCUcpeOrrRlj4Ij8lO1/mOtV0ZB3ftCEURXOBwGh5h0mAiFkbFnPPTo
         ZkVzEgSzu4HR7OusG3sBv+2NC4iiPo7zeY0n6r4UruE3Oy8mrqqA7h3rQavgulIb7zPf
         cl0W1UQDDrBe4MkT9Z1HjhLUTcP97sHQ+y/NC5IMUFeniwMN/lxDDGocfOdVcWOA+WCU
         D4mg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784221385; x=1784826185; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lSpduXrrNhMv2bQ1Jzsq3XCQMeUYVVM0a32/RoJcQnU=;
        b=C4b2ZbcIo05gZZ1Iq3FDut573OM5hgP+aXZPK8eE6NTF7NtiWYUDAJQCu7dYmdJrYN
         9pga7vuk6TXjd/mt9tPXb9TSRrQ7zcAz45deXUcIwCjajFl5RovYa63sid5/KmlpMQIb
         ZS1fl3kgQnsGyXqL8o+JJgr4ihdxSiVT4wDrf1ai3Cgbh7CYK5WYZ88ZEslc/8x3xgpX
         GVj0efqVLFSY2UI521iqX8f7esh49MYmLwRhEEmkOTBBKGLWigCu/+iOsIaFR2B6EKJ7
         Tqxgoa+IbS6WHmYlYAofX2w1D3tk+t+v0brlK/cODCyizuPljw5JpCqWBlw9E/UkfWMw
         3Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784221385; x=1784826185;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lSpduXrrNhMv2bQ1Jzsq3XCQMeUYVVM0a32/RoJcQnU=;
        b=bg3f5azII2QmB9mtUwRtS1jDPr6oSCdNdh6O09jsQzWTNxQvOE0+ILWJ8cb9hBcXth
         WFOOL0A2pPdn4Wujq24kj3+e3tg3OASAuhtVw7fsTdtzQV1COI+rqzjo2j1tKizHl6hf
         xwsz2fj2g6Mca+TZF40W4MBZmFu9Ltkq3c11YUTZq5mFA2+QZMC/2u1x79ws7UeiuNoe
         V3IbbjPzE2C0Jb3teL8+Jup3Z/ihiv+ji02dy54X9EclafzcTpDpkbb1pGn8vfmqzwyg
         gpJdpnkM+xbA0kc9OBkSW7H8+fiPEwMX+u/IPcT6LPdCRgYFdAOCOefXXYTRyk08WdCW
         e4fQ==
X-Forwarded-Encrypted: i=1; AHgh+RqZsk/zGDFqqV6YBtN/MrHvKDQbhwTXzK0OcAqHQ7jrjszIpsbYj60COzhHI0UiMcsXj8woXK2aPA==@kvack.org
X-Gm-Message-State: AOJu0YxwjKuowgiqr25tAbnFxC9hwH2/oeLaMzX9QsQQ1GBLEJmHB6ur
	bincLu8Jw6XIZQw+rperapY3XUEDuMRFvodQ3xPwED2jnYw6ihzdB+SfHdC7ZXtuwllO4yOVDHV
	Dw/LL9BrwdLDmtSIYO8kSpfgemKwacoo=
X-Gm-Gg: AfdE7cnM4Kt6d47YpM3LTujCqO5SGX7CP6PC9qpAS+O7KLlsdgaatgYWbLXTOjTN8Ai
	hzMC0WYbRpo/qiylEXCNC2uih2pt6nWBIRyxGbGCxi1JVk94wysWHjMsQJmw7OYoiOYxK5VvrNh
	7yem5QgFAtajgU5QRbsW8Um/Wv29Oliplx8Wlo2WBm1EU/kItP8Ph+QeyHCHR7Xn4Dn2dHtlYXs
	uICHA6XYlqUFen4sFP+oe+6uygb4VOcnqh1ppgqdz/9ivU5uUweiFJat9pOeV6v1hsRj+A7eynP
	+J14ScIdjLbvDtuNUSg=
X-Received: by 2002:a17:907:940f:b0:c12:7e24:a76f with SMTP id
 a640c23a62f3a-c166797d82cmr672511666b.20.1784221384623; Thu, 16 Jul 2026
 10:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260713093350.2154226-1-hch@lst.de> <20260713093350.2154226-4-hch@lst.de>
 <alZ0fgRSy0RpHxcT@KASONG-MC4> <20260716121953.GA28985@lst.de>
In-Reply-To: <20260716121953.GA28985@lst.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Jul 2026 01:02:27 +0800
X-Gm-Features: AUfX_mxKNFMVEtYgoghg5gFADaiKAQx2GL1Zw86Er7pR8l5RINAtM1-rXj0VQGk
Message-ID: <CAMgjq7BLD+OV3OUcWZidkbKwmb3dCeLdAWP-BOpgRQSM3SLrSA@mail.gmail.com>
Subject: Re: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7722E14000C
X-Rspam-User: 
X-Stat-Signature: yefsswef6ggoae1pz5e73n1tnx8uyuqu
X-Rspamd-Server: rspam03
X-HE-Tag: 1784221386-893463
X-HE-Meta: U2FsdGVkX1/BoCbTZbdJpufRsA0X+tFND/NYB2irqRJhm+L67Nxs2HvnGO/d6AjclUUoE4+Jx5bfNfeS1XLEdzV9Ts6PPaqRBIVHRO0+3tiiY6nzSAeoQWyCD0hLu5hwd2qFAmk4r25N0eP0YE0z7CE4JRe29S/U8ueAseQXQ+GG3wNRBGkF/U3mO1c9kehz9bq9lgZDy9vb4RUPd6OuMBpg+I//HxhQk9eRPE/y42HvCyGt4nrf6lIgD1e2rdOJPSwiL5fiEkmGdVbIJy0qkwCAlaxEjNfAdN47IllEHIgS77LHudyKjoUEm4BTh0l+aPVnnUnWZVP6g3bSM8YbsNXIbx9bU6jVJkTsBNw4Z7cNcbfhM5jrB6PsicHt6DuyvyRw4v8OjcybSAiBf4OO5s+XF2ZUrgOcQ9nVxqwXOLYw700Yy5O9ogkYxeDV6b+vhQCjUpr5x8ZbMJoGpw4TDu/8loTLu4HXmmkOeGoMqigMdOSFqjJ7VyanWoCapTJ93s/WyKOC538bU67d/jg61LDbHN6ZC7Vzth7dUVx0WUc7Dw4wnfsc+Q/OCe8bITz/czMSoCo6HDsit2IQLd1zZ41FM0lAmgRA5GyJZBhyuKrpkBFXEK6+xtsCwYyNWGtpgG+k4w+eFe4dF+8qQS92g8Xcs1s9xqTg7vC56d6LjHznUd6SiHleEpa0qO09u+YVlNaFiGdNOlaZZ0vvEwEs8b5V/80SbgYGp/Lx8Ec74k7nAgwx/7KiAZZ/70HldH6uipX+oXaj5zsSvxJjtpFnVFCDPn1/KcTAiPvuYBpceRTnURP7CGTLrO/acmWgAtiMY/UAe37Os8hAhNtg62wUPGi1+0bwSD6Dvfihs+XcJ0sw2gY6oJq/O0zCFII8rE6X7ii3YektfcUihOw30MijyBQCMzjjLJ2jMIdtMAMZY0hKhUCa2ats9dW+UGo6ZFcUC2qvIH+AMbAuQQZfx3e
 qHAF7zGp
 UA7V1Ax4/HFgLnpWu2mrhXRT07uucCOrXVSIQwB9qbvwDqxAjH6SjDOrge4MqdCFkuEHWhHH4OHTWvc6wFOmFgYYNcZ/Qd1TtHPm7iyHdRI2zexR3f6v+nV17TuVv5ooNUtH1JBcX+jQfrJyJ/kBABu/x6ZioxJ1aSRRBCxbdm5fUTq9W2jYYq+pL5slF/EgZKDkkTzayECuoRvWBzn3R4vkfGRPhKGTH4wv0N8WZ4yG/OXKDaOxyGyOKQStKsXL7powu5oFE88vM5zWOkTHgmkV4jw9+RHIMQWgT2o2MfkP6yf5SgqMtq8ij0z271acv9PjOfnOl9cD6Ti079jsRN7QyxsWtFcWHnNsoJl6TUEuII/M5IuaIWvYqJA5PZy/qcS8AOkfdz0oEe3BR/UKR+2sZNFu8pGId2WlgYdCEEL9IjlOoTPDBjLnIZ8I+6BEMJR9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 8:19=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Thu, Jul 16, 2026 at 12:03:22AM +0800, Kairui Song wrote:
> > > -static void sio_write_complete(struct kiocb *iocb, long ret)
> > > +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *fo=
lio,
> > > +           int rw)
> >
> > Will a bool rw suits better?
>
> Not really.  Bools as arguents always have the downside that it is
> really hard to guess what they mean based on the callsite.
>
> While READ/WRITE really should be enum, it's probably the best we have
> right now.
>
> > > -   bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
> >
> > bio_add_folio_nofail also increased bi_vcnt, now it's open coded and
> > bi_vcnt stays zero, it's not used right now, could there be any user
> > of it in the future?
>
> bi_vcnt only exists to assist bio_add_page*/bio_add_folio*. So if we
> assign the bio_vecs manually we don't need it.  If we ever switch
> to using bio_add_folio_nofail we'd need it, but then we'd already
> maintain it in there :)
>
> > So this removes swap_writepage_bdev_sync (which was calling submit_bio_=
wait),
> > we are replying on a later swap_write_submit, and just add the folio to=
 ctx.
>
> For SWP_SYNCHRONOUS_IO, yes.
>
> > Before the series, pageout will detect for writeback finished and clean
> > pages under PAGE_SUCCESS, if the IO of a page is done and writeback fla=
g
> > cleaned, the page get released immediately. But now, almost all pages
> > will be put back to the LRU waiting for rotation. This also make the
> > reclaim have a stronger bias towards reclaim files, and anon reclaim
> > become less effective.
> >
> > I do observe a real performance regression with classical LRU and ZRAM,
> > ordinary swap seems also very slightly effected but could be noise,
> > test is done on my laptop by building the kernel using make -j12 and
> > tinyconfig in a 2G VM with mild pressure:
>
> > Before this series (with 8G ZRAM only):
> > 175.39user 125.89system 0:40.54elapsed
> > 26581840inputs+0outputs (1186391major+22698964minor)pagefaults
> >
> > After this sereis:
> > 165.59user 216.02system 1:04.06elapsed <- the problemic one.
> > 53531464inputs+0outputs (2550441major+31974007minor)pagefaults
> >
> > Because all anon folios will be derfer freed on next iteration of the L=
RU,
> > which caused a much higher memory pressure.
>
> So this is zswap which does set SWP_SYNCHRONOUS_IO.  I guess forcing
> a submit after each bio_vec for SWP_SYNCHRONOUS_IO might make some
> sense as a workaround, although it is a bit ugly.

Thanks, a SWP_SYNCHRONOUS_IO check here sounds good to me. This check
can be dropped if we also drop the writeback check in pageout by
letting LRU / MGLRU have a unified batch free after pageout, things
would be pretty by then I think.

