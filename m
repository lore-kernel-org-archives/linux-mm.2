Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121F2CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCD48E00C8; Tue, 14 Oct 2025 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393D98E0005; Tue, 14 Oct 2025 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1458E00C8; Tue, 14 Oct 2025 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A84C8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:17:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EF075AC0C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:17:42 +0000 (UTC)
X-FDA: 83996015964.11.D3DF7AB
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCCC3C000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:17:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Pys5/qwW";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760429860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hB5XUi1+cDwXRPWde5CzSKgVrGaXvz4WI2PJ/mRCG6U=;
	b=t4nEVVwKlrbPaFJoKXvGjjQlgr1ddBIYlXqF/AK/8LoXpmAf3tIgwDduKWVfoOVDeg5I9K
	6vqbA6KmyWQtHn8IijUrZhMtMR0Jdk2KwHfK774Nirg1whpzDp1plxrbS6MjYfjarYj3l3
	HMikX6xEj4LVK7r7IdXMkIkXHb0IaXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760429860; a=rsa-sha256;
	cv=none;
	b=UG/0c3DAiFpvB7f31kNxxGj01vYHcwaTGgLpqthe+koySteyILntSUXYmeyYopNDNQql4X
	3oNELdrsS85w1L9UpKDVl9Ldqf49fhlTWceWAsu3ts1VnhCkjbgNWTsIZx9sHRvCruWAkE
	QhQHkK7KZq3VinPKJ8h6fCYu20RK3lw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Pys5/qwW";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-905b08b09f5so1185030241.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760429860; x=1761034660; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hB5XUi1+cDwXRPWde5CzSKgVrGaXvz4WI2PJ/mRCG6U=;
        b=Pys5/qwWQEyKybh3DmN1VyPBWqZOL0EwdpbtNwkDLvNztmkZxp71VD682Diw6Fqx2R
         sYXmo2u7UXIqUXVlwCyOAJzSHGjLkRZgjGga6pFvGxEBRuB1LomyvJ7WASJo+UoUe8PL
         ZiUR2gRLgYLWcgDo7hsmazZOLrQGhgJI3duM4cWvmxfcjWJs7B6Rvm0YJX2ifX3wGAVI
         FuGe0e1a4zr2Zw18p47LBPKvTBKWoEIcfyHrvsg1OCheKDn81Bakyn1fs02OS2tYaabh
         i7FxQxyFvLgIwV8hu5DRufWUmNTU0ETjUN9jsNUYoYOSDKh+M4E21oeydE8d+J8mOX9V
         lhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760429860; x=1761034660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hB5XUi1+cDwXRPWde5CzSKgVrGaXvz4WI2PJ/mRCG6U=;
        b=Ju0yt97cViicnKpwS2NWEDJggKTSTZ6yI5GiUNBrlKmQx7Lp9Z+kN3eoQjFY3sO+fY
         ElV3FJzZRkCPM9lx8X4BOICcg3KFGo2D6Zaj2yMxrBJQMGqVdMcdcn4ULk16L2Rrw3gD
         etznlj+2iE4h8qDsBiQ6J4HDMbak1+yfHZZTHaNO+YbWcKb43e4ledwyJFdHo4clkYCI
         BigwEN2QkETt1BZYuW12tryp3bCfCIj85mV/VJM7WE6VJC6tR/D5QuD7YBCBkVOSom0q
         FJ3YPZPfHJCluC/4CoU1gc6bPVnn0ZJWMM2igZI6SkMrNpsM2KTV5IpYH5+kN23zN0OL
         NTcA==
X-Forwarded-Encrypted: i=1; AJvYcCWoXWqfG2ElVvBmOzTDmN1A2hLdIF5j09YfwB3E90GCmXeSFGp8oM7XvBU/G6iKbiwzvexHnjc8xw==@kvack.org
X-Gm-Message-State: AOJu0YxvyFJhCo44HfHfdCytQMA7rByt7R8uQUAqKIcORInczwjCS8y9
	GLjFO9p24MocGNib5IfD9JnhhBfg0Sgx4SxHL/sbyc3xBVnFXRaqefXAZSw+KO4uleL+oIUr2p8
	RvVTOJo1/OYIJid+1XpmlmUPn6fjAdtU=
X-Gm-Gg: ASbGnctLI5PcebiwOWL7zPJZhJmHcfGfOpXFAotqdE/cWUvyOWjdoVZBZKV6vRvq+Nb
	Co6O8wIGv03naOI75GKryuYTn8IogQ9Ty+4TmH3wG1nhi/U8NANAuqEkCPDjATe4fKgGkbSGmlh
	c7of8r96Fv973wNnqN/gpjg+8GDsCRsTP5/nGLRpXDhHOvXGwzL1bSu23GjYhAR4mSW88bHQNoU
	fRf6uhHXJ3Ee2JmFYM13hSqawAFwIROKL5dkwr5/OyFz4dcYvL0o2FcQOSYj64j9mAW
X-Google-Smtp-Source: AGHT+IE74/+9NMWbvU+qO/+W07sc5FWF1iW+Jodkjrw6Ldi09g2hF8G7tsWXqr3Kth9KAyQqpDa/9zGf3F+nkghdsOo=
X-Received: by 2002:a05:6102:f07:b0:4fc:1a18:aaa2 with SMTP id
 ada2fe7eead31-5d5e2217442mr8155988137.5.1760429859483; Tue, 14 Oct 2025
 01:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
 <20251014035846.1519-1-21cnbao@gmail.com> <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
 <CAGsJ_4ySSn6B+x+4zE0Ld1+AM4q-WnS0LfxzWw22oXr7n5NZ=g@mail.gmail.com> <CANn89i+j_CZM9Q=xTkSq-7cjeRkt29JikD3WqvmPihDrUHBQEQ@mail.gmail.com>
In-Reply-To: <CANn89i+j_CZM9Q=xTkSq-7cjeRkt29JikD3WqvmPihDrUHBQEQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 16:17:21 +0800
X-Gm-Features: AS18NWDxwbBeHYYzY9zkajM9730iY7yUrkf_deZ_-1VTrKeqK4m8413YWm5g-Tc
Message-ID: <CAGsJ_4xC=5nCSOv9P7ySONeXwdXN-YK2V+4OZ2zdCOeYiQHvzQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Eric Dumazet <edumazet@google.com>
Cc: corbet@lwn.net, davem@davemloft.net, hannes@cmpxchg.org, horms@kernel.org, 
	jackmanb@google.com, kuba@kernel.org, kuniyu@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linyunsheng@huawei.com, mhocko@suse.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, surenb@google.com, v-songbaohua@oppo.com, vbabka@suse.cz, 
	willemb@google.com, zhouhuacai@oppo.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BCCC3C000C
X-Rspamd-Server: rspam02
X-Stat-Signature: 174orbx9rtsx1xoujeutc7nnhisei39w
X-HE-Tag: 1760429860-371302
X-HE-Meta: U2FsdGVkX18DhB/JHVrm3nVvAyPESveX4INOGKfjhIYrk2zufM/4a30crtjRFjwl5AeGsFGXtEc6nS4ZsA3LbgYUgV8zS5M7kw45+XeWkNewJjhq1LwO7KZhAKBg25IVdlamggSYVJXMrifz1rHIBnM8SYsQ5MrIt9jAkJzjpi/ZPEBIR6mKqpD3upIZz/ev+EVNSvCGptDl+ZS0YVf5apfFXcTEEB1eLELVfdJk6kMaRsJpFVdy8BQkcZU8p+b8n5Wfjeo01Scu8/dZ5HQ8L78PwuI+EUnQXDof7usnBg9U51cwj7dCCUN4Lt4uw3umSWrXS2h+/gx9xNrt7zLcmqhQjEIoCxLWPg7dx9kNXwOfmkHmwLsab2VjLxxFBQRMz0we1+PjBUZ+AvRoYN5NFjf8SBVyvyD7htQGg4B9XXZmEncEmLyHlTg7o8XeMJlbqdVHzJwbx+5iY4sa6umysbxK6d2qH5cd+f8WeipZ4GHk/2AeYVNHKc9H9Su/XjC3YzYk1/WGe2Z+IuvJSjqg5mgtTpM5JWiunSzAGwjsM6Jx+WvKNHc+6JrcBK1QUc0LPyQ+hM6Yx/7EQ6VkwDnbJeMyuLhel7gNmXq7GWxYgTegrKuQNcB443y8np2GioBjbrvCmFmpnuuBKuOQpx8vZ4lyJEC7cAxgwCiCOkZcS6b5bl8HwDxy5QkdcopW6Kx/scj01S/4kcpJpw0/qZSDUBlUNbVq0w9CdFjqOMf1uTEgdEds87QfX2v4PdRmzqBUDls23PORzxZqKgtCRGVnCmLIyCZgRZuGU/XFtqz5epMnfJmkrcQQOJ8zz34wM2juGEAvGG13lI2SnOYHQRudY3mf79xBFB7z7QWVZoeIvz29pGJO/0eCd68Pk94FDYU1u1rPncV22NyZ/NP+H43HWY4+Y8euQNFQT4C7G8qFdFtnVRyCe+LU+2I2wVvxGUowr2AVsXp1DMfagdMI2ts
 9CSLv1A6
 3pFQh/DDbtvWaTiyWoNi1RGwAD4sW1e5uldzgKYo+qTiZ8ojpalH7ZzJvQNuD7zj85+5XRy++ntNLOETO8OfJvG7TisefcNZq6cgCVb1gRroJpIotAiOO7lttWxj+/lbS/xtTcl1OCK2/AH1PrieanQBsZCHdgvFxBrUZwdUdwgZWOtocf1hDKa9ZyTKPus8oTcsR3EmAO1y+qsT1bJZot5uCUS3YJi6nyy8Ha+1/ucFeDFQ7fUYQfdwC03ZtxkuhnY5I/QfjEACUtEw6Rh1WVkqIEH3Iku6eP/ot3qfxhp3uDuQ3eU6iyPHSKjXVwmz+55XBjvBhJ4wgOVBWvMA1JEzul6Zbv34iYV3Nl36qtRP1ZPCVi+v4LmPoeT9YO3m74bVqOWLcTa52LYUONsaiU5UOXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 3:01=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Mon, Oct 13, 2025 at 11:43=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> >
> > > >
> > > > A problem with the existing sysctl is that it only covers the TX pa=
th;
> > > > for the RX path, we also observe that kswapd consumes significant p=
ower.
> > > > I could add the patch below to make it support the RX path, but it =
feels
> > > > like a bit of a layer violation, since the RX path code resides in =
mm
> > > > and is intended to serve generic users rather than networking, even
> > > > though the current callers are primarily network-related.
> > >
> > > You might have a buggy driver.
> >
> > We are observing the RX path as follows:
> >
> > do_softirq
> >     taskset_hi_action
> >        kalPacketAlloc
> >            __netdev_alloc_skb
> >                page_frag_alloc_align
> >                    __page_frag_cache_refill
> >
> > This appears to be a fairly common stack.
> >
> > So it is a buggy driver?
>
> No idea, kalPacketAlloc is not in upstream trees.
>
> It apparently needs high order allocations. It will fail at some point.
>
> >
> > >
> > > High performance drivers use order-0 allocations only.
> > >
> >
> > Do you have an example of high-performance drivers that use only order-=
0 memory?
>
> About all drivers using XDP, and/or using napi_get_frags()
>
> XDP has been using order-0 pages from the very beginning.

Thanks! But there are still many drivers using netdev_alloc_skb()=E2=80=94w=
e
shouldn=E2=80=99t overlook them, right?

net % git grep netdev_alloc_skb | wc -l
     359

Thanks
Barry

