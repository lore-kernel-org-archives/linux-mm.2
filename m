Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D88C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1BB6B0098; Fri,  8 Aug 2025 13:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2316B0099; Fri,  8 Aug 2025 13:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791296B009A; Fri,  8 Aug 2025 13:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6260D6B0098
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:57:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D98461DC6A5
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:57:56 +0000 (UTC)
X-FDA: 83754348552.17.A1CBC75
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20B9940014
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:57:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fi8WhDR0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754675875; a=rsa-sha256;
	cv=none;
	b=Ygyr7nzg4k60LcpMT/NtsecxMmpJptNYmEWu7u3V/S5YWO55GFY+0nCEUjKzgfr/3N6Nra
	1zvvHBZLq/ikrB4jk+O7TAVmfQwWLTXC45oV0b4b4moeUWk3TcSMQBUJIgu0D0XV1LJgEe
	I/6ljZNBgzHNEXanwvYZnFFP7jWJHY4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fi8WhDR0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754675875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXaRHIxKHmo+v71n2kAA1c+fGSZPzmAH7E7N7+TC49Y=;
	b=MVJFJ+4XrrvwliUeQZuP/tgJOyyoN0gG6p4B1PBvfT9927hqZWtTdj6Q9SKSmsy+fxcJo5
	gKOectBXkE/O7neKPyCV3NGWPLGDaOXadYPUSbPOXzaFGvufB27qdCepUmk1Lk5ztBUzhF
	Ofvn5zjKNi2ltpV6kY5EH/2rO7Cdu/8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55cc715d0easo765e87.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754675873; x=1755280673; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXaRHIxKHmo+v71n2kAA1c+fGSZPzmAH7E7N7+TC49Y=;
        b=fi8WhDR0vzBKsC9albAlyeGqjAttx14EvqXZ1nD6VPM4uWC9ndFbIseGP2T/6mKA7l
         mR47y0XXOAh3agm2d27M3UiPnmmNwEuZ2CaDNUBjCrR+qDanrHtkeFD76GPZvekHPZp/
         jixhwu/X8UQ5HwFkFRIuVjdYQM4TJuc1x/Y4OGdLh1Iqlxo1WE7GsSa03WL5ZGIomfrR
         HKU/XEPkXMp6TWoYK7dM9P8FbYWXtNzJZFqD1s7WcAg+wqDpVn4T8GMxiuN9g7Ywq/YY
         itfRX/zFTPcDlfv2Fth1UNE1ukzRwqj3ltLTy5nCqKmS5AnTS+keWqfW1WCp6CmTOovv
         Nt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754675873; x=1755280673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qXaRHIxKHmo+v71n2kAA1c+fGSZPzmAH7E7N7+TC49Y=;
        b=g1b6JLbiMVsxVs9FJX/qmrIpn0wCfojXqjDHiaaCHnB6rHeqZ4T9OYZxYKhEcBr+nB
         Hx5+knNtQXLnCzq2cE56BManbgfwOyulFYlLmxqU/XKe6Mdx7nsWL5AZOYmkr+J4ngdm
         KMZlxv+A+Rj/xYlWavSBjYuVnB48Ln2Djl0aSlTIMyGnWw7lnCZAVCZDwSCmi7lknIrj
         n9wG6J0Y1xKAm7FYMRFcsX3FUCEGLtqJYqtzOmU9XFnYOEaYWHslp/sS8lFr/L8U13ub
         NUf9F2WHnOanard0gI+Qk/+Aca+5glIYxxYIEE3XBwfD0r7xTeiUE6SW7yKCI9WJcm09
         zgUg==
X-Forwarded-Encrypted: i=1; AJvYcCVP4xm990BHIADBA1/vvCIC4g35CjacQLloENW/GryLrdbfHe2QT8bxR3MJQJR7fAV/xajQzNZMEw==@kvack.org
X-Gm-Message-State: AOJu0YxMVao8movmNtyZhU/CoXzM4y6GGYalVxBvK2pu+9GzpOoVt3X6
	dQp0JL+RhO0chINPHr+qwismd0RI86xVBgTwVdueCS4yMiC/vVO2qLeBJTDfrDzzEgi4LI5hk1r
	c2tczzONf0gbqN7a76KIJhcB2l5QlkVUviSHUFVPy
X-Gm-Gg: ASbGncufo4TZv28wmrAsrUQaJtT6d/VChq59KsiWD+keJ7+ssQ8p9pX+15tXI9VtBOY
	Qup2/J+EUJojpRPhdAY+XgOMn/M6d5KIjv3T4SDrqXGfLvyNO5wpda+/RCDmRU/BYf9ll6AFlry
	GyrQGAaagjG25o5kKJxjtwVhLsxAYwuEL3xsREx97cVIVjTOQdIn7IzZI7oJFd6vxdEZoJojSWQ
	YhcQUHlNPZlHT8Ldz4ilmHvvOqZoZIhVVc=
X-Google-Smtp-Source: AGHT+IHH/Bdfwpdrye1XnlPV3h9HpFB1/06JHSyWIEdcjNIJ0rmEv5ndWkpAOlHZcLVkI6FjX6YHe5vd+NN3G3A6EIU=
X-Received: by 2002:a05:6512:3683:b0:55b:5e26:ed7b with SMTP id
 2adb3069b0e04-55cc77c7fafmr13830e87.0.1754675872884; Fri, 08 Aug 2025
 10:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <2869548.1754658999@warthog.procyon.org.uk>
In-Reply-To: <2869548.1754658999@warthog.procyon.org.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 8 Aug 2025 10:57:40 -0700
X-Gm-Features: Ac12FXxXcgcstidfh2aNH0PAqgqSvM--1mzTOrN4RVQkgf4ePB5KwUufWkqhH1w
Message-ID: <CAHS8izN89j9deyODUjxQroKrLoiAq1kF+RVowuvVecmg4tNAUg@mail.gmail.com>
Subject: Re: Network filesystems and netmem
To: David Howells <dhowells@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: willy@infradead.org, hch@infradead.org, Jakub Kicinski <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Byungchul Park <byungchul@sk.com>, netfs@lists.linux.dev, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 20B9940014
X-Stat-Signature: wzeqtg8sa6y8q8fonce3ojoja7kw8w4f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754675874-380569
X-HE-Meta: U2FsdGVkX198BLjvyANtdAuHZhhFD4VEq53p6UtMDmz4rfrLmpyqr6pCwQtXJSh6/PTpXyI/t7bYaBi8SXWNhGopuBziyKZht1s4QyhPcaA4KbiBqOEYa0cR/lEZDBVHo1IpE0ANPQTo2uEPJiTxAtFXE1IQzsaW0/6rfqO//DG2lGOufPI3newtdP/sC+WnTS+cC0Ve6qNynBUA0bnGu9/ph/r95IujNnslK4VBPesTcjLmnwbI3vbwawE11EG2npYC6nvQ3iHEGtBnbId0iSYrfpR6dYQep7bCyhTXEjjWVHV2GMeaJCSRPc8utApR14ee543NHSujeXl/CbmLKfEOzG3fsWXcE7pI/3bXro9U0Ujz/cD1R99yi5LN742OU3Le2KN7mvb4s9uLZiikkaWns7WOL4x93NJDizuR3mXwUXBEIT/zS2VYsK8cIUVT2w01u3Q7AQshZsvpVUXw/9EEJXIE0dCYpOctCSe9S4XFzlSGke/x4hzUZlTbaMVP+RShU2buCsMh5zNF4G1OrkAliPvkweE7bXn1j7W0fdqG6gxuTxBHDVkyp2RxnHtKEYOCoDfQ6xc+WTs/3lYSD+VAIJX0c5PjGuKOgk8Z5+esbIhl2Ti07K/EPn8qLu+GOVXqOuaRrcAA7Wtf3nSdYZR20mYYprygRMU6euoyifbE9Us/RToPoz62oEcNffftDi/2X9KEQKeLzJ2ucshPh6x14GjSn+5tgI0oaN/Xd4JDJTuaKa8W1PO13XBXnCyUH7aAFut0WyyA2iBZZmDGvlNcSHQ4qN3SL9av5a+KHhEWUdlw13SghvjjCm4/BBwpzziLg+8+OrCLp+qpifA1FfX6CA8jlTYXt7GYkQzLzQ85c/DASJII0PtdE1rgIfoUF3C5IMCVUNKfIvwtunteCXx99T6c+dzZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 6:16=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Hi Mina,
>
> Apologies for not keeping up with the stuff I proposed, but I had to go a=
nd do
> a load of bugfixing.  Anyway, that gave me time to think about the netmem
> allocator and how *that* may be something network filesystems can make us=
e of.
> I particularly like the way it can do DMA/IOMMU mapping in bulk (at least=
, if
> I understand it aright).
>

What are you referring to as the netmem allocator? Is it the page_pool
in net/core/page_pool.c? That one can indeed alloc in bulk via
alloc_pages_bulk_node, but then just loops over them to do DMA mapping
individually. It does allow you to fragment a piece of dma-mapped
memory via page_pool_fragment_netmem though. Probably that's what
you're referring to.

I have had an ambition to reuse the netmem_ref infra we recently
developed to upgrade the page_pool such that it actually allocs a
hugepage and maps it once and reuses shards of that chunk, but never
got around to implementing that.

> So what I'm thinking of is changing the network filesystems - at least th=
e
> ones I can - from using kmalloc() to allocate memory for protocol fragmen=
ts to
> using the netmem allocator.  However, I think this might need to be
> parameterisable by:
>
>  (1) The socket.  We might want to group allocations relating to the same
>      socket or destined to route through the same NIC together.
>
>  (2) The destination address.  Again, we might need to group by NIC.  For=
 TCP
>      sockets, this likely doesn't matter as a connected TCP socket alread=
y
>      knows this, but for a UDP socket, you can set that in sendmsg() (and
>      indeed AF_RXRPC does just that).
>

the page_pool model groups memory by NIC (struct netdev), not socket
or destination address. It may be feasible to extend it to be
per-socket, but I don't immediately understand what that entails
exactly. The page_pool uses the netdev for dma-mapping, i'm not sure
what it would use the socket or destination address for (unless it's
to grab the netdev :P).

>  (3) The lifetime.  On a crude level, I would provide a hint flag that
>      indicates whether it may be retained for some time (e.g. rxrpc DATA
>      packets or TCP data) or whether the data is something we aren't goin=
g to
>      retain (e.g. rxrpc ACK packets) as we might want to group these
>      differently.
>

Today the page_pool doesn't really care how long you hold onto the mem
allocated from it. It kinda has to, because the mem goes to different
sockets ,and some of these sockets are used by applications that will
read the memory and free it immediately, and some sockets may not be
read for a while (or leaked from the userspace entirely - eek). AFAIU
the page_pool lets you hold onto any mem you

> So what I'm thinking of is creating a net core API that looks something l=
ike:
>
>         #define NETMEM_HINT_UNRETAINED 0x1
>         void *netmem_alloc(struct socket *sock, size_t len, unsigned int =
hints);
>         void *netmem_free(void *mem);
>
> though I'm tempted to make it:
>
>         int netmem_alloc(struct socket *sock, size_t len, unsigned int hi=
nts,
>                          struct bio_vec *bv);
>         void netmem_free(struct bio_vec *bv);
>
> to accommodate Christoph's plans for the future of bio_vec.
>

Honestly the subject of whether to extend the page_pool or implement a
new allocator kinda comes up every once in a while.

The key issue is that the page_pool has quite strict benchmarks for
how fast it does recycling, see
tools/testing/selftests/net/bench/page_pool/. Changes that don't
introduce overhead to the fast-path could be accomodated, I think. I
don't know how the maintainers are going to feel about extending its
uses even further. It took a bit of convincing to get the zerocopy
memory provider stuff in as-is :D

--=20
Thanks,
Mina

