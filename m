Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA66ACCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4918E8E00CA; Tue, 14 Oct 2025 04:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441548E0005; Tue, 14 Oct 2025 04:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3302B8E00CA; Tue, 14 Oct 2025 04:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A99E8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:25:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9CC0115FFC
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:25:19 +0000 (UTC)
X-FDA: 83996035158.28.15755EA
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id C673F140007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:25:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ygLXyFR3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of edumazet@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xedia4qpks7I7EdQJJs0YGYLRIvZhKtcLLcwC48lucU=;
	b=swKVfnFfTzwMMMf8+6yP/zm0SJR5Vvt86fOvTYN9emldzzRKwXJ38zu5PoKEhV8WmvNi/U
	q024VZs3PaJ7b3/TXUGbzmePuXmv4t34WW7zM8jBnQO0SJuBpZbaT3KVGAGQynrOwcXVMd
	At0sipLRXwSmClzUIahusjBwnMsl2z8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ygLXyFR3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of edumazet@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430317; a=rsa-sha256;
	cv=none;
	b=FH+g/xPA1ZwvLjvFGxIa7gGWs+M64DUmtAjcnSi/9oaE1C+94kBZdQzD/Z1OLFB0GKNPzy
	Y6HXBO+qthN/Ca0x9TGIz+2t4Fp/x/c56bJ3GsgCLMGNL4acjOKtdysoXRgqUHhUOS46gX
	gVVrkoDr7WGAT4CTRFSqt/xV1Ez7tLw=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-78f75b0a058so65100396d6.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760430317; x=1761035117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xedia4qpks7I7EdQJJs0YGYLRIvZhKtcLLcwC48lucU=;
        b=ygLXyFR3vwsmDMO833uuk9qn8IHVS0woYYoxtkl1Ud2g9xbXBT24y7/OhDE8URI5EJ
         swF8RCNZGr8uG7q480EcS8MBxnYUT/u54Th8wVjXbyPKH0+ieeS9eQvkbrg4/cW/zmiy
         rInUG16maL7hObvy0rBH51o1cnMxx/+PdH3oa6hOYaoaR56H3UAJK8Ocjw17ky+dY9BV
         34HNZBziSeaLPJAnXj1oQL4Sme987LJcfPV7qmh65V+vYQoRIh94r7ObYdksSRrhgb4V
         M9L7GL7ou19OXPYmeorFdGKqDtEdK/dxJCq7QNXQqOyK6YJYURhBp735muDiUJjgoRyM
         1GHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760430317; x=1761035117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xedia4qpks7I7EdQJJs0YGYLRIvZhKtcLLcwC48lucU=;
        b=EI930V640lS3Y3FMpcUuDgGQvkC4XYedhcaoHiZgvVxxaXqCmkKUZksN2xJKcalcQX
         csp9mYGysOFXXK7mbqh0fktqRfqY8JTlIZlOTVsjcxGJpHfYV2Xu4GjQrRtDt6apbO1C
         +QYQTjXr5X30rK0cScpeYOecnSvrsLGMfyLaTBmMTmeyOQcwqagEC/qgLIbuibvmKh+Z
         NGHNAxYnBvAnkBqk2gmSk1B6FllsBHCAJBozQJmV+nGFkwLh78pkBVJpySrFw6KVkI5P
         5eVu804nkcwQiYUgYGkp4qm/irxTLsdIAkj0R2w3w/pVQzNc4kmvV/gqCsX+H3NFwr7N
         WKdg==
X-Forwarded-Encrypted: i=1; AJvYcCU05fr5HiG8JwdhtBpPUZvnq9WCRgtbJbsNhTwvcmlU9+iBYVQzH42N9d+tH31BzSAaxh25jZ0KoA==@kvack.org
X-Gm-Message-State: AOJu0YwAN0HaBxPgjKoIawA9jCCbWlgxxJ+hfuN8BIwcoWVEXD1ZlfRi
	5COKH7qtwn3urPCAm9ZHoZt/X+IlejHDZDE8buQQmEQ9FDvyOI+1PqWixLJUEQTfoRKmzV+VoFK
	bYuKETygI92VI2p7ml7OX7k2F0VnzUj+YetXTgJcp
X-Gm-Gg: ASbGncsq22Vs0Qwnd4kl4OvEtcK21J/klksFIZfXIcw1xee54SPdODcN/5nVbtO6Jyj
	efgEwUa3q2YLUKARTRealzHWbe6vvLGnR0PhDYRTk0pm8XhWC/r65PEW74V0TwM0NuEYPYey9H2
	QlkAb1DYJkD9svJxmP84trLExosS6W/nOew3gackMkByI7mTTkqAURCNpmJzhKl5h3rGd8C/yDp
	i8UtI4ssCSPDPlO4MkUVaFHdOfSZDzG
X-Google-Smtp-Source: AGHT+IE2XZuUpY6yf1dVWPffNJkuGfhZwF35m+45ndZ/A0W69WaedUjJkm4TDgb9gRxsnIAXSMksxOG9bcF7EYiqZu4=
X-Received: by 2002:ac8:6f1a:0:b0:4b3:2dc:8b84 with SMTP id
 d75a77b69052e-4e6ead513b5mr378830371cf.47.1760430316382; Tue, 14 Oct 2025
 01:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
 <20251014035846.1519-1-21cnbao@gmail.com> <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
 <CAGsJ_4ySSn6B+x+4zE0Ld1+AM4q-WnS0LfxzWw22oXr7n5NZ=g@mail.gmail.com>
 <CANn89i+j_CZM9Q=xTkSq-7cjeRkt29JikD3WqvmPihDrUHBQEQ@mail.gmail.com> <CAGsJ_4xC=5nCSOv9P7ySONeXwdXN-YK2V+4OZ2zdCOeYiQHvzQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xC=5nCSOv9P7ySONeXwdXN-YK2V+4OZ2zdCOeYiQHvzQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Oct 2025 01:25:05 -0700
X-Gm-Features: AS18NWCsffjFXuh9SOpm483ZoDLgHXwm8ssjSph3yipxi4Ti2I03tEtjJ8_KnP0
Message-ID: <CANn89iK0OWswFFHH10PLzFdcFxZXodWorR5YJSdPq+P6+Qsu1Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: corbet@lwn.net, davem@davemloft.net, hannes@cmpxchg.org, horms@kernel.org, 
	jackmanb@google.com, kuba@kernel.org, kuniyu@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linyunsheng@huawei.com, mhocko@suse.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, surenb@google.com, v-songbaohua@oppo.com, vbabka@suse.cz, 
	willemb@google.com, zhouhuacai@oppo.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C673F140007
X-Rspamd-Server: rspam03
X-Stat-Signature: f5nzrw3ti7sdjpfjyupqbdb1fncahf57
X-HE-Tag: 1760430317-720962
X-HE-Meta: U2FsdGVkX1/i75qiTf/oSGTbNFpcZZUlBLFp2yAdQxLSHUs/UWNpmuAJPwxdI7nQyQiuk6wTS8YibFGO2C7IOZ2lSiUFb9DO1dQaVee0U5zs1qFPag43GPP9s1jqwgKhmohgLAR6Ri1slJ43XtbZhBegcumasqFNB5k4e5rlc97/FKF/2tCgPUyXbCyXSccRzJPFQYj/onE/3vAgSlMAoTc6eOdUzL2poudb1ig/uuefbMGvjqkazR7ppWZHkrWPdS1ZbcPiSfFoRCtDB1XfxPk63bv90TFPCl9YKiazroSuMQqd5qWcOsFmP+mZ6aEwvuXDy7aa73mIetRczkfckbQigxWgPp9t/9Gn20Z+D9EF+1KdNM98kgesdXfDTijZ2+CA2kyXblUkkvxWgIBt0QTcSlMkW8d4CpErbEBQUSQFcq/P8lxVaFvAk2WNSoZRYi9zkJcbVq+hngn3lw+Tle6YzXI3LTPiDAiudrdQWuMjXn9w9/JWD6arUblrduQZN72jYU/36rrHrSZLXikaCCTApKTM68/KDbcCx19/t0RXh6iRm1+q0EOOHnMMdrBfp87jmxAwiXqtljR8RaNqHxa29kNo4RoZoH1TGz84fGBj3zgdgB+D9SfAd9RfgVmAXINr9kTGsKDyowmtqm7OjmeoNebWYJfOrFSXm3swpjduLs8wX3pDfxOjR77MRvQ0lRTxg8zFGw/cxDpXTAJ7ngDKf0A7ljUYo9AHpzyuT+thUBE/UVficarw6k8oQZY/Hnndw/qk/0nx6uaGhIyFqpSt3CgH6WT6iFv+QmuZFVl73i/yxQrW4C/G7kgQ6dWklj8ZmDk2uQ407tIrLtP3rhD379oxADvRS0TTFPzDPm39TbkIx/d4/FRtW14RjTCQBDI3mMcbXkxxqpa/ETVfH61Mk5QicEx2PmxQ14phC/vLUesq981ZAKfVy1i+oRj33sx0nVBA7nNqqHrr5s4
 WATpe0GC
 3+zu+BkWsRGS28Uwg+27r0PdYTm9dpnaIzjMsht+udqEEEwJaSlmyU9hpdnQhxuEohnbTXnEshfrLb3rZwVrNcwryuGPYAZQi96SOxna2+uI5cGBWWYGdv+Bsa/d+k9JON4IWGGJRTfbyMenJFxBXfw8TIB44jwYv+gVhY+LejcJHkrBT42PmkNdJkdwo2hj93Z4JlrFF6E2lEyjAgLW7Uf72Rs+UWYCQM3K3wxCdl90jySjcz2bouy3PAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:17=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Oct 14, 2025 at 3:01=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Mon, Oct 13, 2025 at 11:43=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > >
> > > > >
> > > > > A problem with the existing sysctl is that it only covers the TX =
path;
> > > > > for the RX path, we also observe that kswapd consumes significant=
 power.
> > > > > I could add the patch below to make it support the RX path, but i=
t feels
> > > > > like a bit of a layer violation, since the RX path code resides i=
n mm
> > > > > and is intended to serve generic users rather than networking, ev=
en
> > > > > though the current callers are primarily network-related.
> > > >
> > > > You might have a buggy driver.
> > >
> > > We are observing the RX path as follows:
> > >
> > > do_softirq
> > >     taskset_hi_action
> > >        kalPacketAlloc
> > >            __netdev_alloc_skb
> > >                page_frag_alloc_align
> > >                    __page_frag_cache_refill
> > >
> > > This appears to be a fairly common stack.
> > >
> > > So it is a buggy driver?
> >
> > No idea, kalPacketAlloc is not in upstream trees.
> >
> > It apparently needs high order allocations. It will fail at some point.
> >
> > >
> > > >
> > > > High performance drivers use order-0 allocations only.
> > > >
> > >
> > > Do you have an example of high-performance drivers that use only orde=
r-0 memory?
> >
> > About all drivers using XDP, and/or using napi_get_frags()
> >
> > XDP has been using order-0 pages from the very beginning.
>
> Thanks! But there are still many drivers using netdev_alloc_skb()=E2=80=
=94we
> shouldn=E2=80=99t overlook them, right?
>
> net % git grep netdev_alloc_skb | wc -l
>      359

Only the ones that are using 16KB allocations like some WAN drivers :)

Some networks use MTU=3D9000

If a hardware does not provide SG support on receive, a kmalloc()
based will use 16KB of memory.

By using a frag allocator, we can pack 3 allocations per 32KB instead of 2.

TCP can go 50% faster.

If memory is short, it will fail no matter what.

