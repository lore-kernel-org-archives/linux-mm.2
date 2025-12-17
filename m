Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDBCD66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD02B6B00AA; Wed, 17 Dec 2025 14:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB246B00AB; Wed, 17 Dec 2025 14:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAF36B00AC; Wed, 17 Dec 2025 14:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC5916B00AA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:34:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F7C116086E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:34:48 +0000 (UTC)
X-FDA: 84229965456.19.9372498
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13345A0009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:34:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Cj3wAwEZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766000086; a=rsa-sha256;
	cv=none;
	b=wbQPQaKqZ6VhF1FOgqvunGmmMOYcb09nkh0lG+vvRAbzmgkYTu7YgamNihJZ4g13TgMKeC
	Kk+1uSu4IJcPqc+5GLrP7Vydq9FZETOxtlrACugetRJWXB+UqV9qbv72md1a+qA677mOEK
	gBM4ti3lpFwSJExoPrcZRRMwhiz9MLw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Cj3wAwEZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766000086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5Dox/IjhxlL5l7CCk2qZ8fasiOHF/NJHXR/kudrHvQ=;
	b=xse9na4G5VWiksXayHPN4hN6mqh2XH5y7YIsXK6QeLHMWAW249jSUYwUJHA4vOXMGDo/O9
	bG7AhrupUf+/ZfgUMpKPDATd84fr45a779G+7T061OXE6lDKZM4y34XZ4unKt23/BUeBw9
	UtvzMqswFBbvoHmWKpM7cGFY6iKQgck=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-42e33956e76so2842643f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766000084; x=1766604884; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h5Dox/IjhxlL5l7CCk2qZ8fasiOHF/NJHXR/kudrHvQ=;
        b=Cj3wAwEZWXROhV0O48uV1JeeG9pMp05DdvY56tTX+17IGmawLeh3gSeJqzQCQEQSMc
         P7B272/tE8ly8QSDEE5s/MswB+7h/m8Nu0bDIDCqHFmsdHYk0s/MC3kv+vJBSISBt6Vg
         CmMZSkoF9ny8rmcZYHlMqQXN0wPsCfHqmdAlUuEBjJwPouuAGIBQs0T7F6HIgwLdlUYE
         zefCvxS2BzlIGaIRwFa20h7jxYGkwc91HYrLec5YbeS8GWOZEQjNe3UYN2t7l7zDjAWf
         7MbQ4I9vlXD+WVzVPHAEtnwm8Z2IqyvnaK6DqfXSAjYxGDl/hg9G4uS+tvpIf2KgeK9Q
         GMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766000084; x=1766604884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5Dox/IjhxlL5l7CCk2qZ8fasiOHF/NJHXR/kudrHvQ=;
        b=EjR2UkOCy4S6XfkwAe8T6Xs5JHllWsHrLRf0Hyvtf9kx1ULXD8RZM7BG0FrXhr9Vs7
         S87XBDVePV/gN9/INfC7tVLWConGoX9nD/+FkPSNmlph1yZTadB6cpuTsgVgbaQUR74N
         8GmAU/pZE+82+W5BFjLhPs2NpPTzdZh6h/UmrM5sdi5qSOoKod8gXYQrt+rD4pwhwHWF
         sA+SLC8PJg1kKkUmPVUIga8g3JxyynCBnnIegeX0b0Qlejld0v9YBY9Wgv6zmcjPx+qB
         q+rM2pc/Q59TxPml+F7grfUhWbuQuvB2+p9WilBr6e6/zg9D02qdyciR8oPpBgm5L5sP
         Ju+A==
X-Forwarded-Encrypted: i=1; AJvYcCV/MrY5rxPovU8WieRicukB6BUWtpk3YCsOmMMeRpHtVl7LBL2IFhR6Riwiat6ijHTMO5f6Ltb02Q==@kvack.org
X-Gm-Message-State: AOJu0Yxcoi6BJCGNT8/Gt/Pnlu1PDnegmMVJ92Fj2vN+wT3/cLk0kyXe
	bA7ZRinJtriHn1ZFAQU47zCv4OpnwSqUpVt3X166wiqmLAahAlD4KEeGMjBKx/skNG8=
X-Gm-Gg: AY/fxX6vnAoNhWKt1wZfX5CnLvNeLSYQkcqD/y2BVNm0PneK/K1lVk+GwsOEBkQMYbb
	JMwFahf48nrXRTJu4G72+g5qQIr8KtFMMHMIzl05BwW19rS3sGm9fm4gGHgvzkToloNX9T4JYIf
	F8UjiDsanfG/eNWJIEpIXv0z0odYhdyBcqB/BaWrWWaG6j/Z474/8X3AUdgqyupF+nkIyYOtNV6
	9pEU4841VI1kDqPrP0afRGZPzvQjFlQ4wjmoHAqylCGlTUfIkmtnaELgU/RHfY39Jgv0coG+xXf
	J7UOgtVdcGdZZqZdbldJP9l/eVivMIl1t604yD+sX79Qh2mzkBqAXMf+7O5F8Fu+Le3dDvf+v5Q
	txorLOLet7fzWNciUF6wRzydCfJ+ccGMfuIojA5R2W5s8Pb1ZDOpWJN89LHnlZOcpNWS2MLtQUv
	UyO0+qkh6q51QJbbSVP6beAB/b
X-Google-Smtp-Source: AGHT+IGjdgNTy6ao/8/rTdokdqhsyqjO1onI/y/VT9z4i621T9Q6cGxvoTUWH6j/q9xfqIewkjNhOA==
X-Received: by 2002:a05:6000:4287:b0:430:fdfc:7dde with SMTP id ffacd0b85a97d-430fdfc810fmr11095010f8f.36.1766000084277;
        Wed, 17 Dec 2025 11:34:44 -0800 (PST)
Received: from localhost (109-81-92-149.rct.o2.cz. [109.81.92.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449346c9sm641020f8f.5.2025.12.17.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 11:34:43 -0800 (PST)
Date: Wed, 17 Dec 2025 20:34:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <aUMF0jVexy08S14T@tiehlicka>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
 <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216185201.GH905277@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 13345A0009
X-Rspamd-Server: rspam10
X-Stat-Signature: rcafoocdgpoy9bcfekc99nf9c3so51an
X-HE-Tag: 1766000085-707087
X-HE-Meta: U2FsdGVkX1/wvlL1JvIPxfIauG1XqC+UOgcYwtC77UYbP1wzrlhKxV5dQW6f5zVxu4HNjzGUnzoKAeC7mT1fILcrxgiYkXL4NQWx4oB97ZLDhX/PSpcr7+aZbXis3+3TJbOsy6W2IECkihyJcAXv4TGu2u7ibvTlRE8+sNC5ToEcLVDXJj00vOWr810HVdwAGjUvKV3lMW8a0FnArgCQLAYBK/jFmNWASNDyaBWs2LcwAaJQYCf8oqd8DEsrRGiv+iec1eX0u2zHJ7UUujx5yrVD5SS6jFfeTBXiWRA/JbrbU6dKOLUe4S/oWLFG1UdY7/lgDFGg1OiUpn6kr61TglPQu/bX/5kwyE+7VIN+g0HkUQ23zOPkcEE+7cLphYE1Q7JigHi1bGi5SMWchwiqnqsqfUr1Xksg7HgxMg+IQ5QQGLevTvf5wJOWyvkYTzRDN0xrh3lFXWVnUDAnfnM95xs9YB+9EDLuyKZ1bjssGx2I6DwoWE/gvCIT1OhbFMxkdY9LzlqU8wpCi4Ld/gAJ6UbhectFlnnlcejl6le9wOynBqRDh+fentozhT8lVIsamshPynMTOOSQy8tH7aJtYkMfj1DCewkg1ODckFRAm+Y42ckYNVLJHuVl3VATsdSzV6CtJDvWP5X+4RxAAS7GYs5yb8C4gcmPRYxqLIn5LcVICmOWJiDV25E6e6pAkbWjCK4D7ODVm93Ff9IiE/rxeBlslQgTuFT6u7t2LTHb0rNDDXl57K0MStsN9TiNoz9F1/SIRLwbGaAZ4auB4Xq0tjfhPsehkFdc/7Lopve3PDoYHbVLSfcI/ULNnYn27oh1Hxgj8xuBgZnT/ANHrxTIYK93fXqoTx9bX8qb+qRhzfXB35HG8gglncCS/cirlSC2uILg3icfzwiiQ2jCUOFxym7bUILZ9PDbvmATASgvRMYFEFL9rWXUoio4O5eoBZLoD4gU+nHKPnPxYM8azDl
 b7u/FKjZ
 ydjefaVZnJjHZSTJp2nudCyVbUiUcreXiBiMN02/pkcdIH+TntAGH7jX1FKo5RZSl2jKdhirE9gI5huXMpynjliaX1jK9qo4GNazHOSyka0gOwiJcKPV7fHDs6CJe9WfNfwhhGdXJ7WUki1D3kWYTrl+o0OO9L1sGmCLV14UJdqm1gh+LlhlQ8ldrsLxGcK2rgWygABGgKYXfSSeWMjz192qMKEGpcQpP4+tOUW/oTuZmEPOm8nQo4D+XoXH7AAgatruhx46y1+KFiEYa1dawoveUdqzM6jwfzre0IudLx6A45mmw9wantAi7e1dswNufQAhIMV4ua4d2fmbK1+OiJA14qzqr5zs25mWKJE+sYZuTWV13R7sT9tzWi3N1XQFZm6orHnaxGOt90w6Jf9VgJyyjh3QwebSzS69ySdp5iQ3+h+L8x6KN+X8mc1uujmXU5bmqVKzn58cDy1JeUSiiyPLOFQiC8Ry3L+Ni3DE2RrDR+NSgvM92mQgGqCIgpt1nYxplo3EhhMHl+ACdM0x6OIrnWZJBvgqLhDjE0nhke8c3ipJ53+ARpb0poNQmhPfw3Vgei+NKLnKr7EzLECDCciRRf4ROfMrwTIC0LIecAZv4NXoEuQs4m8gO/FTv/hEzWZpOxJtFoxvoPUClwryXpQOzG3DT4YhFwz5LeVqNHGhRxYPfNOvyW4lhJqkrEcfCsdXw/5g7/j2GKTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 16-12-25 13:52:01, Johannes Weiner wrote:
> On Mon, Dec 15, 2025 at 11:41:07PM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 15, 2025 at 03:08:38PM -0500, Johannes Weiner wrote:
> > > Debated whether to add some sort of deprecation sysctl handler, but at
> > > least systemd-sysctl just prints a warning and still applies other
> > > settings from the same config file.
> > 
> > In general dropping sysctl will break things.  So I think we'll need
> > a stub, at which point it might as well warn for a while.
> 
> Fair enough, I added that.
> 
> Jens, that change seemed small enough that I carried your Ack, but
> please let me know if you feel otherwise ;)
> 
> > > Laptop mode was introduced to save battery, by delaying and
> > > consolidating writes and maximize the time rotating hard drives
> > > wouldn't have to spin. Needless to say, this is a scenario of the
> > > (in)glorious past.
> > 
> > Maybe expand on this a bit by mentioning that reclaim now never does
> > file system writeback, and fs writeback is already very lumpy by
> > design.  And of cours that hard disk with their high spinup latency
> > and extra power draw are a thing of the past in laptops or other mobile
> > devices.
> 
> Sounds good. Can you take a look at the new version below?
> 
> Andrew, absent any further objections, would you be able to take this
> through the -mm tree?
> 
> Thanks!
> 
> >From 087f10b8046864f71ebc3a3f3316b097932cbded Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 15 Dec 2025 12:57:53 -0500
> Subject: [PATCH] mm/block/fs: remove laptop_mode
> 
> Laptop mode was introduced to save battery, by delaying and
> consolidating writes and thereby maximize the time rotating hard
> drives wouldn't have to spin.
> 
> Luckily, rotating hard drives, with their high spin-up times and power
> draw, are a thing of the past for battery-powered devices. Reclaim has
> also since changed to not write single filesystem pages anymore, and
> regular filesystem writeback is lumpy by design.
> 
> The juice doesn't appear worth the squeeze anymore. The footprint of
> the feature is small, but nevertheless it's a complicating factor in
> mm, block, filesystems. Developers don't think about it, and it likely
> hasn't been tested with new reclaim and writeback changes in years.
> 
> Let's sunset it. Keep the sysctl with a deprecation warning around for
> a few more cycles, but remove all functionality behind it.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Message-ID: <aT-xv1BNYabnZB_n@infradead.org>
> Acked-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs

