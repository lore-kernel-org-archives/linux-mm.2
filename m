Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE8BCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022238E00D1; Tue, 14 Oct 2025 04:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BE28E00AB; Tue, 14 Oct 2025 04:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51578E00D1; Tue, 14 Oct 2025 04:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE8378E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:58:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A833BB2F5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:58:57 +0000 (UTC)
X-FDA: 83996119914.13.6A54A25
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99605C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:58:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ene7Vi1G;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760432335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLYcGa961yhxxYkbsF/rLk6YVjYontQ0KHKihOwI8T4=;
	b=kQFMY/ukg/ID6m5iUMBNfqf299LeUHva/jUaximWq0l5usUXVe0GdVUW1xqNwSH1mzPKoN
	yLBha3vP+jqhyd6q5mSvVOKdVlVtxusZOR29B90rpJleyxAYgRmr8oZMSoPkdXQYDTB56a
	/oq5tlCbvyPWZPD1Gm0Wjl48vdmeMhQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ene7Vi1G;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760432335; a=rsa-sha256;
	cv=none;
	b=C8rJqCRSMbF5nuCUMsjI9inlZNWRL3APUAz7mzH7A/7LSNBQK09xMBoiCJ6Mv3xADpVcwY
	xuEu+Bw/1GNxfyGK5tGD9ixoT8pHPLUCU6feXWC16YoWeTZLiD8glocZK9Xx0sGnFH2vcD
	nynlMU3B9brUUVcwqX/TsJze42U0upU=
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-8e936be1359so3076168241.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760432335; x=1761037135; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLYcGa961yhxxYkbsF/rLk6YVjYontQ0KHKihOwI8T4=;
        b=Ene7Vi1G3IXd0iJvxvzdG0WrKeRjsnjFjXTsHg1KyyPPLTe0awqFfEjUPR2xMqJpL2
         upEZJ4JDhdqMRCcf3o3EqTgTnfi4/i3unGminJCq0gcZb3RAGwI0N3LfTLeaZlOwq46z
         7+p53w0D38OAHbfyyrIO4Jf23+e3Xn/AuZBec2RpUj2BOY46zZ3DX7etx5TBcpQfAhMS
         SZPArwI2inHvfdkovKxhBqCC2IMlZOlvpE0AmaevbKiLAWLe2BOyfH7w8ojq5nN1j2zI
         LBkGQyYd6jFYtty8TWkZpVvc6wi4WDKI4LVw4ZKnu+PTWth/pDINXWXi9bJ81H2VywDU
         gjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760432335; x=1761037135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLYcGa961yhxxYkbsF/rLk6YVjYontQ0KHKihOwI8T4=;
        b=phn6zgCTfnSdp88mgBW8yB9Z9EJ8kGULsT7LPNlsb1Yl2Ns+X/sXsA71sjZUFwzuH6
         /lXzBIdc2uwZjoHRYhgu2f6G8AHutW3pXkwtcwI3ZuFGe5IlMZRtOmB0KCXAhQCcyIPG
         8zYai6m5zGa7m1gMV+Mx254BpWyFfKjRaC7wCvIqkHUP+OuqI+cEHLLyAEmOXtpkTP7w
         wtK7/YUDX3ZabnGM36wXQA3TuywT+Mx7VVgVEDp7kFZzNBAOL8qgKcBR5/oQSI5K70xR
         oD+G/pFWzCY7HZl2iNJEBB6CWyQ0651c0qnaIKHtFg4GHsjKmiJC3MxZ+qWb3HOUN966
         VFSw==
X-Forwarded-Encrypted: i=1; AJvYcCW/h5YFM1U1wjZ+2lKTeO/YVnrB+35uqiEb4PY8wAjlnH0T0Uv6jxOFYr/XWZxL5trcpv2tf1MTVw==@kvack.org
X-Gm-Message-State: AOJu0YyjWDMRokF9WTzlM0i1xP01dMJboTno2J5XyrFJddxZVUZEBEbq
	gGSihQ6PHCwjevV2QWMuQm2GiX42L9coTzSAzVDQpHLm17z8MwzJsZJ9ISevCV5F5kxGQIY3Res
	RINdYNNFycDnAt85qCvT+yoTFOBI/m5o=
X-Gm-Gg: ASbGncsLQQXyotOUUTNhIFu4I7y8esWhqJWJEzgVZgpHhoW4h8yfoozs7F7I8BeatGj
	LhuW0/oluDB2VNwZuzisPNHB8FijZWkb7dr0+GRToPiJHoDCTEEMbmf6jxFoldDsma8Xl2xqibN
	qqtKzK4uoCgxAxJN21hNvXBdqAMZ334lBD3oNlQqWcz1iFLjBVwNLBOu6w+JpNizhNEWAaIREvr
	X6itU/07sWlgirAe5i5jCxnTsHg8AEnbQC59W0hJgd+n85zIRPnOepjag==
X-Google-Smtp-Source: AGHT+IGX4PksrMyWa5G15wFPdlRrAfYAlpyBh8eq+zBl1laEShj5dhtzQCGqBWE2Cgx+teji5G7o41ixrF4TOb83K1Q=
X-Received: by 2002:a05:6102:3e14:b0:529:e9a5:c216 with SMTP id
 ada2fe7eead31-5d5e22127b3mr9320305137.4.1760432334547; Tue, 14 Oct 2025
 01:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com> <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
In-Reply-To: <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 16:58:43 +0800
X-Gm-Features: AS18NWBgpajHqeXyjq2SfshUK90UReXA3HYugsOOoYy5fZXYwfWha3ufAj0-PzY
Message-ID: <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
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
X-Stat-Signature: reamddt9r4yixtemcfyq3u9h8bu3zbao
X-Rspamd-Queue-Id: 99605C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760432335-629536
X-HE-Meta: U2FsdGVkX1/ZTm/6J41oHPIGGsu7yKum4lLgybh2JqAGy/SrjKiIjc4HTPfgohM66ZWFg056AtYQW0JLumM1ScYABdkiFxzLRxQwLXT7ha/gOCKBJ+cpG7ieLlWM5AI2OrOl4MmFa90i1ffR0oXU6alv1vZjqanYz9e6H1GAjaBT3LKOiwVbo2mKH2MOae6iECwFXx9jnoNJSclgCCt/GFdeLcQ5dtiBCw8vhZjKsftmHjFtuycoW4670ZrvkGALh7zdv7toyW5d6uBzOzIngHV1cbLT4FZbllGh/YF/LZwcdu2VGaYeDHSlmXgcW2tX8pOwxj+2fjDxe63DHGlwm1badAWv52rF7klWgRJJC/cgPK4VgmW6lfRj7qdS5DeYbKRUjf2SwkOY7Hr81jtagCAUrAUkCbx27RW31dCUS4e0rwHqQUhYX70wvf9KIyF60oh+RLaqn69qZamS+VOYe87MN8H3TQReN6K/Kf1kU01lQUQ1OFLcVn6jEz0zUiOJfn9R63P3WLl+IqpKrZk/bhbJvCT9qzrn0dqfr4AQf3+udZkRA0/vOxJ+CxD5VLAcEARZa2q5RqOnuF1Oi10jO1O3b7UE+/h7hN7oFDi5IVafyjw95YLFObGMwy5lKaAQJKvRm1QGfSxEGZl6detUc5rFjjpfuOhf5ANL6i9RZmqgLVf295fyxCZAgbHGhkdj9ZakNLMd5dLi+fOaNJzmRE0VVMdiiBmsDOgXLim6ShtE2i6kFsB1b09ISw4QMcfkRZHXh5OkD4P0S10A/Gpd/weC5R1hyTWdF/u03LjpI2R4BTTf9Y11z0ijN5y20e6PYt5gxnEFCarl2kEBXq9jpbvWOJ8JKo4/FzrzcXg50u1eFARTEuv4rVANBo5YP5AGXoM1rUyx0DpkBTHacJAwarHOs9aaDPhd02aA83zbfiBsfPXBJNJuUB+/DW6k+Smv4RHoarnOaTAmSgCBtl1
 bMGwVnkg
 NidE6Z+/SSH+ejgcK9oKRPsxBT0ASQxQ12Sk+txowMLv7Fzxrfb+C4/sV98K/SF72adsE4qHorkomCtQnhoO8L+tU1knubN/ARv6DrL0VyV5Cj8NR0b8WJDXVUIRX+z+oREd275OwKbRkpdomg9YM9DkwmjdwREVPWYSiUOKi5mOvhXZxvSX1HXbx2AqyodLVAZlEm1+s3aC/H5j7FKFtaEdwRejwKLj7jAflnD2hYGx/EmZL39zOleX37Ozlssq8AEChnMQvpdpK9wKZEXBTANYow1688kfhYWpab5aMcgXFZPiuJ7oSbATxKtbmDl0aa+nXZL3f1Ppqf4FJajUFU+/wt+NBx7qS+uvfoQ4B5n+AZEWBBERPH2XSUEahy4PbbELec5E4k9/wnFbkYgm/St1mT6gYEjjienE3MrPwmSPs2uoVwbFAmvu3KuCbhwYlvFsBAQnhL1+Eg3ixW1zTEzPZWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:04=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Mon, Oct 13, 2025 at 9:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Tue, Oct 14, 2025 at 5:56=E2=80=AFAM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Mon, Oct 13, 2025 at 06:16:36PM +0800, Barry Song wrote:
> > > > On phones, we have observed significant phone heating when running =
apps
> > > > with high network bandwidth. This is caused by the network stack fr=
equently
> > > > waking kswapd for order-3 allocations. As a result, memory reclamat=
ion becomes
> > > > constantly active, even though plenty of memory is still available =
for network
> > > > allocations which can fall back to order-0.
> > >
> > > I think we need to understand what's going on here a whole lot more t=
han
> > > this!
> > >
> > > So, we try to do an order-3 allocation.  kswapd runs and ... succeeds=
 in
> > > creating order-3 pages?  Or fails to?
> > >
> >
> > Our team observed that most of the time we successfully obtain order-3
> > memory, but the cost is excessive memory reclamation, since we end up
> > over-reclaiming order-0 pages that could have remained in memory.
> >
> > > If it fails, that's something we need to sort out.
> > >
> > > If it succeeds, now we have several order-3 pages, great.  But where =
do
> > > they all go that we need to run kswapd again?
> >
> > The network app keeps running and continues to issue new order-3 alloca=
tion
> > requests, so those few order-3 pages won=E2=80=99t be enough to satisfy=
 the
> > continuous demand.
>
> These pages are freed as order-3 pages, and should replenish the buddy
> as if nothing happened.

Ideally, that would be the case if the workload were simple. However, the
system may have many other processes and kernel drivers running
simultaneously, also consuming memory from the buddy allocator and possibly
taking the replenished pages. As a result, we can still observe multiple
kswapd wakeups and instances of over-reclamation caused by the network
stack=E2=80=99s high-order allocations.

>
> I think you are missing something to control how much memory  can be
> pushed on each TCP socket ?
>
> What is tcp_wmem on your phones ? What about tcp_mem ?
>
> Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat

# cat /proc/sys/net/ipv4/tcp_wmem
524288  1048576 6710886

# cat /proc/sys/net/ipv4/tcp_mem
131220  174961  262440

# cat /proc/sys/net/ipv4/tcp_notsent_lowat
4294967295

Any thoughts on these settings?

Thanks
Barry

