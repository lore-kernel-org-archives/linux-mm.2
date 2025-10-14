Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA87CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 10:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7D58E00DD; Tue, 14 Oct 2025 06:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F618E000D; Tue, 14 Oct 2025 06:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394C08E00DD; Tue, 14 Oct 2025 06:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261CA8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:19:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD6665B715
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:19:19 +0000 (UTC)
X-FDA: 83996322438.20.4E43830
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id D08618000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:19:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jwcUOnvX;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760437157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GhdPCYEOIPlUxhGKbw+Pmeq+R0XeZpDT4H4TE9DD8w=;
	b=XYelmTSvP1A5IUjyUxzYWp3usPlJCMaTFkaZyRb0XiheBT8GBNBApCQ+51qeB3hNe9SS6S
	bCWbicbQFCA3tg85F0lTwEaSpV6IcMLkJF/5+Du0m4kcQA8PjWf2H3bU3eD5mPtfEam5g9
	XHObSGyN5lEZzm9sdL65PHVfViDViZA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jwcUOnvX;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760437157; a=rsa-sha256;
	cv=none;
	b=Bsy8alWgy0u4AxGBNK1SkFugmCNMBZpbsM917/PKT9BV42VLeBZLz7XLTgnuaXw3veIZGp
	fThI6VgXYsXCj+rWckgJ+D9EJ9wmw6l/oZjEsHtD11fOdTe4B69aJba2OFdRt/EaLf45eD
	33O2HiU6nMCYiRqXXBnMLqxPGymbwDY=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-84827ef386aso484586385a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760437157; x=1761041957; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GhdPCYEOIPlUxhGKbw+Pmeq+R0XeZpDT4H4TE9DD8w=;
        b=jwcUOnvXifVwqwhwmJ4PSSyXvu08mfF4b4t+9ezP3VoG6jctysIE6heiSfib0vlsTA
         FngFbEG8yRNydiJ73PoWlb/Y8omS/G7Ebc3awbYTdGOSavY6fe6P2qxvwIm7VduGhiiD
         zYHYcQ6suThgTpeIbI/r6gkkbSygv3RIUyiiKfaWTlVJxiB/iNPQNGP35rNLfaskw+mF
         Q1NgUDrvo9YE7sk8fnYqgMWsEU2aAs+wqmFhurksTV2iH9Nu0MuJlr8IBV1Crbk7ZvSi
         rKcYxglNCAUUSLRcXigDBdHZIVFiqWe667mh7Wnz9jPCEW/4b7OkxEGRjNoA6yiWX0O1
         z81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760437157; x=1761041957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GhdPCYEOIPlUxhGKbw+Pmeq+R0XeZpDT4H4TE9DD8w=;
        b=Gqki6/hS1519g37s616k86663GaCUwLO9vaqWXZfXkcXiYEdd5JZjqCwbknp00ESw2
         2/xeDsVDdIcFDNSmBmclw9nwgsrDOVM8dZbZOCI1wJ3IZV1gu3MJV3R5sC+5lg0iKljt
         0TODWI8mRYyjnMhYdZNfKGQwIV2OTLrLAkpb8yD58tos06sVFSQ/s7heMdwg+YooY06q
         DrehSpbobTltUqzU7bFUso6H4kZc/1llEQqWtBJX0XE/udy7nI5b0XlXZdrtcHPjS4gt
         wZqwlpnX2vftLasOHlf0dn4tGGPvOh76268TDxGe/BSVf7vnXMll00eEw4/dAGKaS68E
         1cmg==
X-Forwarded-Encrypted: i=1; AJvYcCVDz2bf6lsF1RZCBC9Gi84PetnbRHaVjv0645AWBfLwKzgpw03koIpHEMGtAnkb7GRzbW/ELDAa1Q==@kvack.org
X-Gm-Message-State: AOJu0Yxe70vjdyisEkS0MTzu6OnpqjtaI1kSeKHlwiQ8CS+JO4lluzgI
	eUnvof6TSok3VaQnbWz3mcQFoiqiQSikE3F0EtsWC/c4+HhWHtmxEeimoKiUqmy8ihj40X8NU9C
	NvfQdeOVBcJFCeFGIqskvz4Hwm8N8EMM=
X-Gm-Gg: ASbGncuR4F0v2VDbYEv4/tpBZBL2SYtuhoe/vkH1fKbsmgreccyy/bp8HsBTaSQc+rA
	/gGz02R4CfLkOZ3JWHJfEaxTPNJGeyvk0NgKk1rXUP71xeOpwV/7OHjCuQty7kvXHUobXErqVJ+
	MgdIAdh51GaFvLdcf/72PgGlKn5u6YHs6xWarTDqdojHuNg1WPZ9uRAQH0kK5sMuAmJNO/aFqvv
	oRcFPF/M9Xkh6Nr7/ZBH83YHit/jIcpk+kV74EqbV21Y4gybgjqJfXHlJONZ58XQUC5
X-Google-Smtp-Source: AGHT+IHkG+3MijbAqPzBuX6WT5qM1UH5wFEx4+o96mRJarvePfqJF8HiiyZhUvW6BxCxk3W2HxXrCx44GyONpuhGsYg=
X-Received: by 2002:a05:620a:1a82:b0:864:c4b9:da16 with SMTP id
 af79cd13be357-883570ce5e8mr3684480185a.73.1760437156675; Tue, 14 Oct 2025
 03:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com> <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
In-Reply-To: <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 18:19:05 +0800
X-Gm-Features: AS18NWC6N5v2tw8omBV7hBy3g3GX8bmzsyDFnwNBZ4EEXltiuUXlhijttlnObnI
Message-ID: <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Eric Dumazet <edumazet@google.com>
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
X-Stat-Signature: yjz1183mytj1fa8guhd7e36q87qr43w9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D08618000E
X-HE-Tag: 1760437157-24693
X-HE-Meta: U2FsdGVkX1/tCF1N2mvvc2qNTm5/pp6R/BidW6J1tY/3c0uGxYXYxIGADaAPX5AMIwHyr+CfeiwOOglQjwQUY+dnPya8k/C/vCZ30qlQoTPTys1pbISRGrbtGZcc7VUuQW9MpnMtsJYXgrgXrOGNagXGc8P49jllmrjv/twK9jG810+YrEfIIMRaCppU6yV4qmp+3kbvNSmERHctnawT4CDz1yUgYeb4gMjZdtmWWC8RBg2gTcQ3ioh2hlv6R4oaz7FD594ahCYPZPreMakXTkAgUGpFJdwbpAIrrxj8tJI+0tVgTl8sPB6xfeS4Ka3KDtOZObEGeeKY1pHIDCSgon9gApisyzanKR5+qbQzFkMZ/qGYMcJ/RAhqznrZU8XzJd93hmFUn0x+dPbP0czC7aRdCTWlKCcee+idgCe/O+K/Bt4r6DdlJFMZvgmSDHxXjOPQXK9GKDAemtdjako76C+Nx5qYB0XQpmdvIaSj5K0npsHMfrzNEbbuB7jb41/8RGCG/2DEufxBcgXztHPVAvtHhp69+/bcVNDiYxm4/2kglhuyApKxm4sQK29IL61OFsNW/b9k3ue+GBrCxn/GrCYPshVi+TvMY9pA+HD27KvsU5Ad3UuJ+6Qkg4TGiGOfgFGCN+0J2q3XrChQ4JrUZF3V8wRS9xjZcAtBX7UP1eu0Qp3iSknFWIe+A5nLfx+PCGL7xnVZrRO5UUuJz6I8dLMX2r5wCdJBtxWPExjJWenjdab+FaOXKv6kMpXElyPVjj0ZqHgmvSNFljlYW5QkbBZX0prbn6RvrIhPBD27RTwdXcAV/cgEUr5BmGykg1jtJA65sXTpyu89LYoCqPmYJcA4Yaerno8FuKxB/kPMe1VMVbeDJZ42fQKB3T0iQh12fzisepCJNpXnQ5mfi9OGUvdoK9eIz7Nmiag3tXa/34k7pw1PZn+7X2ta4C+kmSZrDafLWA5hpK7cvNDASJb
 eRCDTmEE
 /II0GQ63iupru2T/5UBrLgFuNLZigTDWnPDvNUwbepagz4mRiAW9ii+NWzme6qH6zdHbpX8V2kxiBfY8lDQrTyh/R0Bhzcpc2a18TyNBggwKUrgOtul2h0wZvgIv+MbAYVFBJGC6k2oeofq1Np5aFG13IafaInLQtfddWv1HIiM7ST+RgnsRoa2STblNO9WYJzTyuVb0c9Fil5941bNfPdIlu1zo3Md/dsXB9Isoc1ZlBA+S6CsB6uqWwvNHpfjwvctlsTenZHbSEwI31zTZ/OQY4QwYo03tJ39WpBowy9E8MipaXSZfJA+iqIyjRa0c3yZ2Jly3zJ8PrVg5Q5usc9/bJ9AEpFT1N4cxm2puaK10aqJI6xZ5D4QPaIivIdvofCxRR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > >
> > > I think you are missing something to control how much memory  can be
> > > pushed on each TCP socket ?
> > >
> > > What is tcp_wmem on your phones ? What about tcp_mem ?
> > >
> > > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
> >
> > # cat /proc/sys/net/ipv4/tcp_wmem
> > 524288  1048576 6710886
>
> Ouch. That is insane tcp_wmem[0] .
>
> Please stick to 4096, or risk OOM of various sorts.
>
> >
> > # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> > 4294967295
> >
> > Any thoughts on these settings?
>
> Please look at
> https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
>
> tcp_notsent_lowat - UNSIGNED INTEGER
> A TCP socket can control the amount of unsent bytes in its write queue,
> thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
> reports POLLOUT events if the amount of unsent bytes is below a per
> socket value, and if the write queue is not full. sendmsg() will
> also not add new buffers if the limit is hit.
>
> This global variable controls the amount of unsent data for
> sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
> to the global variable has immediate effect.
>
>
> Setting this sysctl to 2MB can effectively reduce the amount of memory
> in TCP write queues by 66 %,
> or allow you to increase tcp_wmem[2] so that only flows needing big
> BDP can get it.

We obtained these settings from our hardware vendors.

It might be worth exploring these settings further, but I can=E2=80=99t qui=
te see
their connection to high-order allocations, since high-order allocations ar=
e
kernel macros.

#define SKB_FRAG_PAGE_ORDER     get_order(32768)
#define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_MASK)
#define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE_MAX_SIZE)

Is there anything I=E2=80=99m missing?

Thanks
Barry

