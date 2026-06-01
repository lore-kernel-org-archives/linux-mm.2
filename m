Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EEC0CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F066B0198; Sun, 31 May 2026 20:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FEF6B0199; Sun, 31 May 2026 20:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44F46B019A; Sun, 31 May 2026 20:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93DF16B0198
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:25:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E8CD1C0649
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:25:38 +0000 (UTC)
X-FDA: 84829450356.29.37B7636
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27616180003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:25:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HM3caD3c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780273536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqgK1wg2ERDyOtfs5+7z5PlMWVVQC+GT9AiHeZIUsyY=;
	b=Xb+6BylhsmHvNPzJ1wx9fYI3PCHwjoz8pBZ0GMstAzbNPet60QnX+wf4L1qEmJroAJvhsg
	tBhm42Dgsyd4G0JmsPMl0tWhtezhRV7lVnE77xE+br1jFmKKRl2/+cVhmEsRpWB778yOAm
	Fis+ElzwTGbOZ8LdBukBHYsJaOHrxbY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HM3caD3c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780273536; a=rsa-sha256;
	cv=pass;
	b=YOhRgrs3MI32thody7WUBPmyinLw6Tys5vdJkAcuoXNeSbYLfQIAiL3QmikZCfh/3xucv2
	ZqOAlPl0L8OgBg7CElUEl23BL1lE7DTT3keAjafBmDte/Q2YLScAwXdr+8mmZA9HOyXNQY
	MLSY1X+gQ2s06Kn9DvEV28745jJMkt8=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aa68d9dc18so673623e87.2
        for <linux-mm@kvack.org>; Sun, 31 May 2026 17:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780273534; cv=none;
        d=google.com; s=arc-20240605;
        b=I3vfprJo+y6WQBzQJ1KSm2VTIvYPWeQyXBDdN+ZyL05LOL1rxOm12pxtPovG+ts8OE
         fZY8Bf4oLWeVa0XHh8hHg7qlM1FenFGVSsxnAuxPp2iL1fL8x3rY9oCxPYRa4ohX57aS
         5j7TTcOohRvR3HvGBAp+eSz4CboRiE6f5Ul0OqYyYSZ8f2ylyDJDrXfSWxbbrM6JLoqx
         qYTyXerX7ij9DtfeiPxELUdXkofV5WmTTh+3PrwKT7hCxDDMcsoouEqLpMYYkUZwhjhw
         CzTCNjEdFOqBlRFZJB5qKdgxHG4Z9lDAk43pxbWwkNMbku3Bwm9R8BUzGGlfG4goDtro
         UCMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iqgK1wg2ERDyOtfs5+7z5PlMWVVQC+GT9AiHeZIUsyY=;
        fh=YDIh2a2NNuAJU1SitfZ9D+3Ta3KHg6ova947N/aJV6Y=;
        b=jQntTHFcJWDw1TUEAi0y+OgX2G/g3kUikq7Sa7fOS8EIzsRTNqOxZPaEmOCZrptNIs
         YBypr4w0LPG/XYuqUTM/B7DH+2BUUmsXFsvk4vyIzGKTjJzFE3SFWbRgvJ1m3DZ6GfB3
         GvPxE1jjjfipBQYB8NxlJgjHcLOvMibG+x4h7OdGeWzGgOvGHm0knvPrTBN6U12P+PFX
         QxRo52wb8UWm0/JW018pO7Vu9xUBqALBuOtmdTrL7ioO6+SR7fvXK9VqVGHhyCbbUjdM
         2Qa0eblwk3KSKusFzpnevm/F8o15JrrkhuuCAHEVdo+oKSbFsLwAU0SrDhaNYZoqb5Zs
         eoMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780273534; x=1780878334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqgK1wg2ERDyOtfs5+7z5PlMWVVQC+GT9AiHeZIUsyY=;
        b=HM3caD3cZNj98JbQ9+UTj5J0fW2Lydp9dwt7nWLSYDO5Om+mjaaJf+pZoel8uETxLm
         2QBROZJYA7Lpq2B8PUllvxmBo8NZiwmXma+CEnkZY+OaBRm0bL0ElYOV9vFpjWmrhYiB
         AyqY46SSgxCTiR2kSNHqotjnDaRjGaNTgvAUXT+WagF+It90Q1ewLdei0BEGQCo3Yse9
         oGldooqneAuJMhsmXu1eW2Xeqgi1oEuPDDPmaMbzCpWZQXjpYrqAw0A1XtZEUlpFpvPN
         +RBpte9U093GPINjSCzQfz8GdilXS6ZGgQfVTIfZIGuUIXcABUDHMQwvP461wsmo/tRU
         YbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780273534; x=1780878334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iqgK1wg2ERDyOtfs5+7z5PlMWVVQC+GT9AiHeZIUsyY=;
        b=pq8QSlXLjCaur0Nae8FoR2y4VcGBpn+/EML7Ig3dqQUvkoT9cZ/MqfYzfG/WrV7s+/
         f1TSjt0TXQiU+h+9xwhshvAwCvYaawmeRNvefBWSc0LNmddt+2vNb/sbDOs0PfH646t8
         8xaTOvt2PJGWCk0gw0KAEWmRTxLs0+opHcw3aZcOGcvJIsQ7Md+d8irbbxFhz2ccfyCH
         9K5+AVyT918DhmH6awMZQ2JUPapJ1ii2JfFqq+gWdBLSHZAMu374qkp9jS/GyJJ+8uAx
         0gPuXtslrXnZKH9xLUWkmmMR0z1YcINuiP4Ammt+tsTv6lnW+UXOjFrLU/4Tu2R0nqfR
         JOVw==
X-Forwarded-Encrypted: i=1; AFNElJ+SZr70npOJnywvk1z9pN+d8h8HhfYd8bdkqgnnfeW2ibMFrCE73sS4VcRB1901vpnqKruRnKWqcA==@kvack.org
X-Gm-Message-State: AOJu0YzUJrGQZlno3NoUCVGsFLPhlXsLjnogd++V186zg0ETQS0uUQQ3
	BxKAmJaYpiAT+mtIMBQsyPy2xc45zhqnnNUJk2OgYaX/TO6OWFxe+EdweM0ueS3jFss0Kr0iMuh
	1nwQ7etyaKvXm0bR9S3rv8oQgvmW4Eig=
X-Gm-Gg: Acq92OGYx2F/5o034bY7NqDvnogL9iBux0slOCqTqdGdbw5OPe5gxMAMixacg9zzJNG
	68yVfJVAvVJRQ+Nc20b7LXKrCzHlLd5qwbmkLOVzVWk/6vglLUPTeWHN9Ow36r2lR1QphPfKeBF
	T+10OwXNIwPaFPHTH2DB+NTp2KBOHBpJJ48Ow0GkjwgRY6oHSQ4lbUTaPiQm2qO3J6YUXEb9G7s
	xYYRxGb8pugzGcv7p0FCzdpZTqOXXAHhxuw/k6Dy/CObWPeCWJJOkjqRc+gq3k6A/e/LWDWQziD
	fF/v0y1DFIaqge5tAOqLeE5PdO5ug77381MSrm+EPUUGK/Q=
X-Received: by 2002:a05:6512:12c8:b0:5aa:6bb5:d5f with SMTP id
 2adb3069b0e04-5aa6bb50e58mr595558e87.13.1780273534044; Sun, 31 May 2026
 17:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
 <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Mon, 1 Jun 2026 08:25:21 +0800
X-Gm-Features: AVHnY4LCEnZxVatPf--playUbBj6ZV7jG8LbCfwqfDtwHwTtx6N_h4IJfVPbylU
Message-ID: <CAJxJ_jgk8o12OYAi68JznpwKYTUJOUizp2PAZvNz2VdVGJWstw@mail.gmail.com>
Subject: Re: [PATCH] zram: fix partial I/O config check
To: Barry Song <baohua@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27616180003
X-Stat-Signature: ijj1h5kj1hyospn864umwjwouft5qdbe
X-Rspam-User: 
X-HE-Tag: 1780273535-454628
X-HE-Meta: U2FsdGVkX1+Y4//2uEUGLk/ExZGjE+Q+B1pFJiI/iDBc8LUg2PWXhLxVLl/QMQgI4tskSGKxt65FNeFPT/Alwfm+BwPHpNxIwaq3sBBiindc9dAYbiufFGU8uFbXZNQX46bbGv3Tso6NkpMPvfAUQZwEUNruBtfupqi1rgCA6r/Jzzlr4PWENN+CLttFMuzpL9uF8leOwkv9ZTszRwXKEI6LaLjA7Kqty7cSqZt51nMe8ppyeTV45Pts05/jt4BOzKCiCh+4BM8i6CB/HZBGywToJ3sMUM7CA7A0ypwNqTZFyc0PYeDXAXysqY6dmQemFCiboKxTEQoDJ4JIuEI5gSrI5SjRdRSvQj+oinG6JWMK+qxJ9IA+pwLUn91GSPcaVZPO8yyteFtXFJBcSxps2Hrveto7muRH5otifW21xtlqy/3dCfZv+LVrXvjlH7BvcOecuo3hMiyCQqY3wwg5p4SMZtmPQ0qCfLwyG4oPxRB8Ztn2Lz/coSPegSxQcQv5wmDVSijpal1dTLNMumaT7mXVY+wpL/BY8uYxSZUh3o0ifHprDHjon4xIeMJKlDj0HWUQX4X9aZkvM+3aBqMO4dUYIkg2Phvdm1UA6spQVfZUtpcz4E1Yi34TIhz+16o2Mu5ovv5U5p9aGxNESgLMRRSs6IhNI79JgAnZJBtTWNOfpcpt5nvWvRNGrNWtnNPRQxKnj+iX3QehALJACj+a5wi97+fuQTOoQ44zuqLM3W57uD+Gg/s5vVMGpzJXU6MMnBBsNY1vkJLsd2ifGdynXDZHZ8Pwu46vO5h4r7vESXwBghwbUJj1WHREQxft6yuvpa+Qm2c0qTcqETQ1qIQVOiWs118MIA4lLYkQgyP8lCP06RKJMNBWerCDvLVTvkxRw9/riiJdowNX1XgDVl5ZMzQawNwUSGVqNm8aKd0KD4gz1jvD6w/+8bJYc7Qfrp1yXBqHeNtaCmfDUAxHVBd
 0ZtQDgUQ
 Jtc9hubYrqi8ruV9VaUnUX0Ovy40J8lXfXN7IdFZdmrf3A5+x1KQ/k9/gLYT5tBLLoifbh0ovYGPATZsF3zp4NtLIwlXYVx6H3Hh3bJ0g0l1fPrznZWYcSuCn4D4fE2q5+Bj20VnHaKSAm5jYVSQwdGUftPJIvsg9FD0fM5lf6lzwLfNNBLHB+Neazrg0T8C0O0dvW6DwqsAmbkpNnzs/eUKzfkqmLu0FDyAr4QfYtg6H5OmdYXl+WzMQVBNi0atb4h1kZ90LKpDhEzR3UMIhQx1xtOZS2RdyCv/1eSwdN9iVWvFaXD68Up8RnEYwEj6xR+iDEogxV+i/eCXDTJI0O8Ur6j86oouvmrcmn0pW54VuPcqNrDpC+frWx4x4qiMV9lAX1kEdut4bjUUvopDgdevvw2V1l/gzpRtQXDUX51f+E1X7e/YQ3jteZjeM4GnvT+YDxBGD1lZTmUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 5:38=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> > index 6e1330ce4bc1..72f89fd5572e 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *zram, stru=
ct page *page, u32 index,
> >  {
> >         atomic64_inc(&zram->stats.bd_reads);
> >         if (!parent) {
> > -               if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
> > +               if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))
>
> However, I don't see ZRAM_PARTIAL_IO defined as a Kconfig option.

You are right. ZRAM_PARTIAL_IO is a local source-level define, not a
Kconfig symbol.

Please drop this patch.
Sorry for the noise.

Thanks,
Jianyue

