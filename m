Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDE6CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003988E00C0; Tue, 14 Oct 2025 03:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6588E0005; Tue, 14 Oct 2025 03:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5A58E00C0; Tue, 14 Oct 2025 03:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C83318E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:01:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7535D8838E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:01:21 +0000 (UTC)
X-FDA: 83995823562.24.D461813
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92AE820011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:01:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QBqQDYBI;
	spf=pass (imf03.hostedemail.com: domain of edumazet@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760425279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsQ1m/aFutWkld5ryO0dQSkVhTvtxn9NWV5ydHxepQA=;
	b=Tu3gkX5sY11tsjoz2LF7Rm7J0EkeoeaZs5NaPQt99X770xp4HEyBUh9w7se7ioqTS/WdSN
	iBgFwzDySRhifIU6UMcRuUvl2Z6XadyH0msVKfI0lK3EXngsbxZU66x1yyzXx3KcfMULE9
	lx6a7Jn7QtjR9AQiXMKJl56AwdhoaEQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QBqQDYBI;
	spf=pass (imf03.hostedemail.com: domain of edumazet@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760425279; a=rsa-sha256;
	cv=none;
	b=rBhA7I9T2GhB2MSA9X5ghJiYlk6nlnS1n7DVScrVpMpbcgtLrCMLRSbLSuXWQ5gWttitcp
	gl78a9qiUOqFgfGVUyZEo1Qrc3spwGP5inFLDV1xBzSGPRjSPPgcgdLoKU0sRHdxyeZzag
	haX14yDLUhtdrcy+3mKQpZp7Cg4Mh/Y=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-7946137e7a2so77132436d6.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760425279; x=1761030079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsQ1m/aFutWkld5ryO0dQSkVhTvtxn9NWV5ydHxepQA=;
        b=QBqQDYBITg5li4JJIQcmEr3w6+86RfNYzb2AV8iv8Lo1mSDBf37UcU0KuILc8wvZE3
         E7QmD4t7CJfcIR8rzBEK15SIx6YwtPxjwaS3ipu0dzINFzUp1TT74onolcS/i61Ld3aI
         NlE+kVzptJt0qjHbS6OZfP1wi5t84a/49LmOChpL4C4aaMR4Kq4InGXwUmSxqLdUeiHD
         wgQByQqk+/OYPYYmu8PZqzH38pAaM7i59EvMdnU3sxR2TpaAUmAtRDxww73A9RhRDHtc
         qmo1LTyB+e+CdwF416p06I91wb2ZFH4aphCzCUwJx4urom8yo5RaD7VKw9ORw4DIZkwJ
         ehZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760425279; x=1761030079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsQ1m/aFutWkld5ryO0dQSkVhTvtxn9NWV5ydHxepQA=;
        b=glwkNbIwOCnp6GeQ97cI7xJpBjfWw0IXmlAjWUQserQ9/Be7pkgcWPRLfCSaSISsMX
         xh4KbImBTrx8vaREoglAwWWOM4DWipwQHOQSeAJF05ulnVOjkInGCr2FZvpVako9Jk0r
         9SSxQjcU/SwVmtKBtR9w0JvylzHGKC05S8ZZvjbpFHPBGMT8EWlCh1h37cN9zP/ItM3Q
         /K6LwFJzckdnaVvA3jAYPEHpL34noaivkG6yAXk5XAscesZY4/9I4Bs+1GMvqcmgYvvG
         XE3+88anrc1IyLpQweF9sFTP/AO8ZiGHQJYBeCywLYfXfeMsnU+iNe//7ExLX3z+JchV
         1QnA==
X-Forwarded-Encrypted: i=1; AJvYcCV3hNt5t5mmc40mcCxtvMI//+y6zJvj5k/aVWTPGYT2k6Sfts4MjqDHGQU+YywKzAx2nMeEvayDjg==@kvack.org
X-Gm-Message-State: AOJu0YydojRvNCD7rsXHxf2ikLqNERgEjN5JO8ntz+P2umPfL0BA2I8H
	g2aZOBuClLRfaxH3juV8e2ixK+KtnUkjOzgjJHnBphgMAWrb0eafaL0I6FzSeypm5gt9/TAkHDQ
	wCjzLViSVO7/lZu+QRda9INaRl5seN1NkzlZNsOBq
X-Gm-Gg: ASbGncs9FQLvniMtvW6maekiIdm4iVPZBJ1lxrMu2s+94ybGATYEKf9cx5rN8A7t8zH
	3X4vXlHDAdJWc1ABtZQZF9zS9T6UiRj/d7tIIomDcNOfOipkRiJ0ZQ5p4nbhNqxz/JQP4kBLgO7
	WiteP7wd8dEImF+ZEOqlrCWb2icwe0aTAFqpKomg9ywldpYGHnoNklMNZCwZbmOZPnyABPP8+o/
	UelgkiRfk4WKwOtK9KNWhof6/BAnJjQLg2YE82jBBU=
X-Google-Smtp-Source: AGHT+IHR7KeqfX1q4j3neFi7CD60ffHHvOgtSgSkxcg1JbCbIReg3SIb3TKWDF50WzB6YocPrnOGpWynAn63FWdOqTE=
X-Received: by 2002:a05:6214:2622:b0:820:a83:ead3 with SMTP id
 6a1803df08f44-87b21032994mr371828316d6.23.1760425278145; Tue, 14 Oct 2025
 00:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
 <20251014035846.1519-1-21cnbao@gmail.com> <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
 <CAGsJ_4ySSn6B+x+4zE0Ld1+AM4q-WnS0LfxzWw22oXr7n5NZ=g@mail.gmail.com>
In-Reply-To: <CAGsJ_4ySSn6B+x+4zE0Ld1+AM4q-WnS0LfxzWw22oXr7n5NZ=g@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Oct 2025 00:01:07 -0700
X-Gm-Features: AS18NWD5ciaHerlqKb1LSkLizTAcEH7y8M_BZABcYRSz9LQQyJTFiKiNPr9pVjc
Message-ID: <CANn89i+j_CZM9Q=xTkSq-7cjeRkt29JikD3WqvmPihDrUHBQEQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: 92AE820011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kctjpqzasjuhwu41bp4qt6swxqkwar84
X-HE-Tag: 1760425279-42013
X-HE-Meta: U2FsdGVkX19mree2oRfjAi+Kpm0auyfRfBEk5GlgkY36qVyZv7NV4NBCgW800PspYgKgEjp0Qu1Oaa1rsMts8IBP3L1MoRYhp22KukJtVE/gfy5yncCaO+VJ8Oef0sz1wgRaakZJ+L/aPEVOLpsyd0BRE2ahFLIsULwcPfmyOgWoS6nkQrIMzhrEg5aTkhkow0/JdQba5tCuQWvgKrBWv/KlVCFo3cFfqxQYntpcIXX7Zo1FvB1T6IsQ97pVZVrlY506ueSG8FCe0fTkG19ZF24bf7uMy1beTnz+crvdzF5rrpqU+DGQK3SxdB5MjWWO5zZZ174ffytyUFkADVDJvY6ZmE2qitIIvPunrVPw2rohnq/X8DabfbK2vxp3dvIQouYo3MT9qXZv/Xv9QesPclWphNp1GAoHPPZYU7Qvy0SJWr2mGDIve1Or0+2Oor3r0kGG4xOugPpFbh64XEIpn33wHmLmENHFaafY/d826579nrNu2CVwn3Ron6TRO1sCewuRPqNHQn2ksEHN5W9YcDnvcbZj7PRG2ldWIkUk2Go6Apk95oHl04gKYaKu+SBzuCCjmsmivEvJxEN+1yDst1yrsyM6KsxlNUXDhHFsFTE9X98c30tKGA5ELXLkgVKAahUOOvwviUA4HzzEanr6AXmdxsLi2UcpKmWNsyqKS+ryDg/Kx+GyfGN5JYJqaxnxqSzRCUto9aRL5c6Lg72++KACCyJG4aFCcL180fztgAdo84wDzYfvFk+ufmQVJef29fl0fRHB5TA/HDFAW/vt5MRmVkoehScnCf8/Y8gIrhlD2EZgnkIYf2+UGH4dECE9J86gLO+Cjl3NdioRx9rru2raqkpIHzx1mYma5BqlcuOOurEYvKYnAUFG+3DXrzNMvbeHjZyNZBM1FmLiCo5Q+6ZX8jQ+ag9YW1Jrp7ZiNbwktREr5ZxK8HxvthW1sVCxE6YEgYRLiKp17ofYzUV
 OQy8FcSl
 F5OBPLztwufU27OiS4eQDslM5d9UCsBB7BqXH7/O47k+zu/dnAPT6Dhjg/l/tLwJaYzyyRVpYaXGQnWeUjZpZ0F0tPUaBAX4UxFY2sn1Fz0nureZUF6PzdTGLBz/jZI96QLf0qkaQTgGxN3ej8DT+bg+t99ZO0tWiqdDBWvve2oFEdgmpy3VymrgeEnQ9v+hSAj/lgEQsPc5Q8pyAivYOjfM/4cZBXJMnw6XV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 11:43=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> > >
> > > A problem with the existing sysctl is that it only covers the TX path=
;
> > > for the RX path, we also observe that kswapd consumes significant pow=
er.
> > > I could add the patch below to make it support the RX path, but it fe=
els
> > > like a bit of a layer violation, since the RX path code resides in mm
> > > and is intended to serve generic users rather than networking, even
> > > though the current callers are primarily network-related.
> >
> > You might have a buggy driver.
>
> We are observing the RX path as follows:
>
> do_softirq
>     taskset_hi_action
>        kalPacketAlloc
>            __netdev_alloc_skb
>                page_frag_alloc_align
>                    __page_frag_cache_refill
>
> This appears to be a fairly common stack.
>
> So it is a buggy driver?

No idea, kalPacketAlloc is not in upstream trees.

It apparently needs high order allocations. It will fail at some point.

>
> >
> > High performance drivers use order-0 allocations only.
> >
>
> Do you have an example of high-performance drivers that use only order-0 =
memory?

About all drivers using XDP, and/or using napi_get_frags()

XDP has been using order-0 pages from the very beginning.

