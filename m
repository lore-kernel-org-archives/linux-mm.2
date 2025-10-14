Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D269DCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E3E8E00DB; Tue, 14 Oct 2025 05:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155948E000D; Tue, 14 Oct 2025 05:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044818E00DB; Tue, 14 Oct 2025 05:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32388E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:49:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86FD487782
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:17 +0000 (UTC)
X-FDA: 83996246754.21.60E8C1E
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id D66631A000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UTjY4oyS;
	spf=pass (imf19.hostedemail.com: domain of edumazet@google.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760435355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rejcU5EZuKfOaVf3kGuy7qqlEcfNKn49oLZoxZhzh8=;
	b=69cawLYT64BcB064gaQn0NHTQMa955h8r1h6ytLpzqHUC6mtef7da/t8uaDd3zyBWCsQ7o
	QJOjvxYio+hX+7QeDJ+Mt9wJtfYM1gxu/MI7Y973A4kipIggg5EVsdvrrZ1vus5bU25Czt
	ykgeO4EOm6YZqSLXYx3qRNfreQbs0hQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UTjY4oyS;
	spf=pass (imf19.hostedemail.com: domain of edumazet@google.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760435355; a=rsa-sha256;
	cv=none;
	b=Hn263eKZUK0gtqofvt2mv1Wqc6wdiixKbNSSI7Xu/Z+UfoO+M4JkVcOmBnRtxetM0okzlZ
	eDI35W1J6MMaOhN1rMY9ZMj0IsyYc3WlU6UXtKwlEExOZjVFao6HBLz7hbOYfHJdJ/YYWo
	c+iDXL0/lv0WWGCMVTk4oTtw0u5MpcU=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-816ac9f9507so788201685a.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760435355; x=1761040155; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rejcU5EZuKfOaVf3kGuy7qqlEcfNKn49oLZoxZhzh8=;
        b=UTjY4oySyTY9u6/dULluXonu7WAU2y8BdgDxv5YwOZlM6cXBsi7ZmoAIuEY2K0l3wb
         8Rv8NRbqQF+gY0offU7jrE5mgl1KaRXpqIy8IZz3eFmn7uKpdR/OJdw5Cj4eyiCHRA78
         ZRan8DOOMxBhZ1ZYX7mKS2XgK/0flmjzGNsrwMRPIyejwm+EPIrKygT3dC36i03YHOwN
         nvfeFMLgTYK34hYx43IiEXxEqDFr0sZVvq1XiNhuhRTxQmoNevNAWXEA3D+bsqhwhGES
         OZ19dLd/3MLQDBJSZK+y6AMZNSvO3rVtyu+HDcdld2K6IGtpt3Bg0lnrxJl2Sm13Q7fT
         s69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760435355; x=1761040155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rejcU5EZuKfOaVf3kGuy7qqlEcfNKn49oLZoxZhzh8=;
        b=ruIDA/JpKsQaOYBi6VE0lZGN/0aVNu7rFWRHVW6k1h9tHXHIVqywSaMQL5lQLtFBMq
         4x/JLfnHyPizFJXgaNlpDO7JkRGdBfKVgrXfeNYHZylnbc+y3ir2hVlkkXNYtKv7eH1f
         A/Sglo2DuzoXqqA+ALClTIvUl7jqY/D717EE+/KbbADAnzpf3ngOPjoNV/aZqnKZQGQT
         ievC5+RCDQAdeEG5JcnXXCOuBHesFhsjBlqfeNd9gJMTiACkx0Gs3SJYrmB0Q15yYif9
         K77sLAQUXNtUp7yj521vkr2aVsTIIT85cF4QlRwOHyCxaAp2Ui7K0dOkS1F4+6r5VnEz
         uE/g==
X-Forwarded-Encrypted: i=1; AJvYcCWLw54SiiFgIqen4OxNeUMWPL5mFkRv/oe+fGjbTZPT/9IbgF+JXntBNmeQ+WhAHhZU5j9s7HsIlg==@kvack.org
X-Gm-Message-State: AOJu0YzjFR4AC+Xz57X4Qhlo+zktC5hrcV38eEDnzWwqaZZa7YMMJW1x
	TYdPRTlwkqZNdovNavdPCznkA7sGJ02nf+aq9rUMu2Op9v7tUZ6XJjED4uFkMku7kF5xHjC5hKH
	ZRrvZGbccZ/8g1EITi8/Mf/Vu1qQgGCwyF7qJUGLIlZ7sZ4ikb24x8nlMb5A=
X-Gm-Gg: ASbGnctYDcQiqWSM89J5XPnq625DhAHULcGJBdWhbMLuO6NVS2BK8MVBaj7Ofpf4VfA
	B21tFTJMENizQV34r/DuY4kgXpb/n6k2rhgtaZptQh8k56TmbETdA0kBMj5wAoCN/kBpPUMSyuw
	9XoEZaPOzj5DxCvo75O0CYrwpLh7iymglAyNvQEm7dQHMhSgD7eM+CF1wawb9YRvlCVjpZoXu7t
	hv9ZVMLkNDJCBgUXgsS/erpNbSFlGcOEUcnJ/aMmFk=
X-Google-Smtp-Source: AGHT+IHl4KYhns6HjXctJUP8o5ymMntOlhxSsAztTQ/ElyRGupOcA1nshFbafOIGxpIMTBr9aCbejFNLuYJavjSBG/8=
X-Received: by 2002:a05:622a:1651:b0:4b7:a1b6:cf29 with SMTP id
 d75a77b69052e-4e6de928b64mr379844891cf.41.1760435354432; Tue, 14 Oct 2025
 02:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com> <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Oct 2025 02:49:03 -0700
X-Gm-Features: AS18NWCJcjmV12JbFBOiX1xuqww7glxnYRIPGxjvTUEA69A11zlzBQw_qx0TUQI
Message-ID: <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D66631A000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rwnjwuh1whfuf4jz3tfeh4ozc1zfc9k1
X-HE-Tag: 1760435355-527135
X-HE-Meta: U2FsdGVkX1+9lJyHoTvrnBIlvtjAdyU5bPjD7C7wrBMTa2PLLsr/OiR4OnF8+uxe5rFeKsnbfwD5mo9NcXGwdGFxzju2e/s0VKG9iORLxhcbId5xfS7+F6s92KdbWfSGTdmMQ9vxKsIHSysk3009OQQ1D/Bsy2WCXseNAfdjQI100XU1XaXzkNUhBqY8qn89yM53YA5J6QwDwOAIOLCO2brphs2WK5UKMuwnPLZPpqDQY6rIZQtHzdo9Mp7I7jCBkmdN8gN6tMAlKm33tzRTPo1lSLLMBMEML/rlfozuDVhV+H57P8cjdhYSEjhzi4krzv2EO9emOhAJrpEFA+Tt7yew5xvSviMdcm8Ocz90YDurfBnSM629JiqPMwx9YhpkW1a0WM2EO0lzqP9xhJ1MxBVKMDLhZqnlcUZTNd18UO0C+gZI78JVylEA8I6kj4x8xSffGo8Sd03M858PQRL+nJm66XTb1dCVRS1skGP+wpaazl12ykoYESvn56u2Jh713CulLBKX/3+5wZt1mPPTlTswXmIFpNalsmhZJA8sIgqxcv7nSHtxbLOdrdAV1OnsL58WjTlwQSf0xq8y2rK0A6NvZ/qWF0ZvlNkUCZ2V7AeSaAe9O8gL6Hzs6h8I7t7Y+peDULGR23igrKkR/oV4gD+jay3BpWMdXYOjfkRzPZ4UbVJ/1rkypzTtbS52mP3jnzw0b+v65gatBEJTbemCSYOgtGBQRdrtoEtgj7MEiljDWkLpzUTqMQ5Fc+nSq4WiTO3xyJ5HGmvL/Ch1XoZ6gvEYVmkF9KM3mirZulBP6ulP7x2jipr1VdbFIsVQ/leMBO0lu4URpcz44pVX6kvLFQTP999dkPmQauyZV22YnJxubDcWlEjZvo1rwvz82hKDYwR/D+n3tWyog4PzoKFa0Q8lfNWgUPu0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:58=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Oct 14, 2025 at 1:04=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Mon, Oct 13, 2025 at 9:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Tue, Oct 14, 2025 at 5:56=E2=80=AFAM Matthew Wilcox <willy@infrade=
ad.org> wrote:
> > > >
> > > > On Mon, Oct 13, 2025 at 06:16:36PM +0800, Barry Song wrote:
> > > > > On phones, we have observed significant phone heating when runnin=
g apps
> > > > > with high network bandwidth. This is caused by the network stack =
frequently
> > > > > waking kswapd for order-3 allocations. As a result, memory reclam=
ation becomes
> > > > > constantly active, even though plenty of memory is still availabl=
e for network
> > > > > allocations which can fall back to order-0.
> > > >
> > > > I think we need to understand what's going on here a whole lot more=
 than
> > > > this!
> > > >
> > > > So, we try to do an order-3 allocation.  kswapd runs and ... succee=
ds in
> > > > creating order-3 pages?  Or fails to?
> > > >
> > >
> > > Our team observed that most of the time we successfully obtain order-=
3
> > > memory, but the cost is excessive memory reclamation, since we end up
> > > over-reclaiming order-0 pages that could have remained in memory.
> > >
> > > > If it fails, that's something we need to sort out.
> > > >
> > > > If it succeeds, now we have several order-3 pages, great.  But wher=
e do
> > > > they all go that we need to run kswapd again?
> > >
> > > The network app keeps running and continues to issue new order-3 allo=
cation
> > > requests, so those few order-3 pages won=E2=80=99t be enough to satis=
fy the
> > > continuous demand.
> >
> > These pages are freed as order-3 pages, and should replenish the buddy
> > as if nothing happened.
>
> Ideally, that would be the case if the workload were simple. However, the
> system may have many other processes and kernel drivers running
> simultaneously, also consuming memory from the buddy allocator and possib=
ly
> taking the replenished pages. As a result, we can still observe multiple
> kswapd wakeups and instances of over-reclamation caused by the network
> stack=E2=80=99s high-order allocations.
>
> >
> > I think you are missing something to control how much memory  can be
> > pushed on each TCP socket ?
> >
> > What is tcp_wmem on your phones ? What about tcp_mem ?
> >
> > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
>
> # cat /proc/sys/net/ipv4/tcp_wmem
> 524288  1048576 6710886

Ouch. That is insane tcp_wmem[0] .

Please stick to 4096, or risk OOM of various sorts.

>
> # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> 4294967295
>
> Any thoughts on these settings?

Please look at
https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt

tcp_notsent_lowat - UNSIGNED INTEGER
A TCP socket can control the amount of unsent bytes in its write queue,
thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
reports POLLOUT events if the amount of unsent bytes is below a per
socket value, and if the write queue is not full. sendmsg() will
also not add new buffers if the limit is hit.

This global variable controls the amount of unsent data for
sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
to the global variable has immediate effect.


Setting this sysctl to 2MB can effectively reduce the amount of memory
in TCP write queues by 66 %,
or allow you to increase tcp_wmem[2] so that only flows needing big
BDP can get it.

