Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963B4CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 05:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40188E00BB; Tue, 14 Oct 2025 01:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E183C8E0005; Tue, 14 Oct 2025 01:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D547D8E00BB; Tue, 14 Oct 2025 01:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3DFC8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:04:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45FEF140720
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:04:42 +0000 (UTC)
X-FDA: 83995529604.29.EC88AF1
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 712831C000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:04:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y6okOmfE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of edumazet@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760418280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irzV2QUfJJ8dqUzMZqecWufn5bUU0255l1546dL2h1g=;
	b=L4Y5ja5cES6lsDHvXaAHEJ28526E95C/4yK8ro3g1eeHwadg7CODeIj32VPxmgcJt1NDUQ
	MhY6kgHpE0USggwwZqvrqk13Vi6oFu1WWB3Tl6TptkHxr+qEx7Qkc+fqWW9MMVP278YDo9
	4boefvaAYjPawMYYHZhT8zQVEq8mT0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760418280; a=rsa-sha256;
	cv=none;
	b=jBE/U2YEnzKMn25YpticQT5xHgc5a3Dha1Z7TOYBh3LSO1DDjyymTG+q6q+APUWaMQJjpj
	MQSW9js/YKEtuI3jtWvCFJRUhYY4w6a+kuODvyLSOmhg43W+hwd/6OlUUZ11a8nNvKt3G/
	2yvHHBEagwFsPOvqW049jscEmR4QzHs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y6okOmfE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of edumazet@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-79ad9aa2d95so86067796d6.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760418279; x=1761023079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irzV2QUfJJ8dqUzMZqecWufn5bUU0255l1546dL2h1g=;
        b=Y6okOmfEJ0h9ZrmccBahN7BUczzC+Eo05bQvBxIoDUZRu7dyDz/ndY1lBDMhVvf12a
         72+rmHuobc2vZVOQawlqwuAF5Cqby+Ts5WFFLOvlrxZW0w16fc2xJXYkzGkhDxq2DHGW
         biPrM5OJbhKkUbM2LwZ2Tw3jr8X6B5pARDjLO2kP924Aki7/E7bPPwTdhQCvaqqCcG0T
         P83xdP/yIJgll9JuPcJM+QOHbJBXIhbkRLFSltlcYBoiqM7++wYgCbjhuhHAz+vDdUrZ
         CVwyMrvTUfTvlbyC+7V2raF/qlvPKJOf0ln6m2rR5TAEhHaZG1/GZRnsGeDl2YNwjsqE
         mRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760418279; x=1761023079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irzV2QUfJJ8dqUzMZqecWufn5bUU0255l1546dL2h1g=;
        b=UyoyKMoAeuTmjgpTNwF2SSGftTQ2u7GH9M/2gu5oavTYB2wXuoJZIluuCrkWPfbf5m
         70bmLu7l/WEt//gf7AmBKC26Ndpu9g1g78oiYeRuuc0EHhjHSrDuCmJ5hyMqBQQViNsV
         yCIo/FyuAqEzoKDHP5L6QJT2OQOUgdJojH0fHP0JizytNZ/8XNLndF1Mmcy+cSGQe1ga
         MaDYhxsUvJIhaqX10pQHmhk/wgDt6jKPczGD2D8l2VDpu8375pD50L8IcLt3qEzzm7p9
         E1WKVeHANEoQi6UOjcckvEHsOKKqtXff1rjDgsniWS0QqHT55TQYBcgIHezd8Q0ucgQg
         iiLA==
X-Forwarded-Encrypted: i=1; AJvYcCVyD7VmgEgSDC77wXXOJ4twClfA3879b7CYlZziEez7JBG2CO4XddMbye5L/1S3bRnajj9CO7D4Hw==@kvack.org
X-Gm-Message-State: AOJu0Yy9gD3NEoGxosLNqJqYViTilrJnEghtWfqxG3O1/DjLU114Ejxq
	W8ibbWFQwk7WD0w7XWzPCi2U9Q4Ar/VOWSurjz1TqFTi2m5rbMZ7slOFOXKWusMzBoscNs2IPsq
	AIjD096C1nWXBrDx8vclFzoZ30c+VheGgdpuDYcqx
X-Gm-Gg: ASbGncv5J8KtYiNV/WxXpLJihlI4/8DWq/PNqh15E/bKGEo/oLa4hl/9Nr0noVA5ykF
	w/p1L6tMRKLzFO1o3DrTCgH0AYykBq48UxaZlu3kkzEg/pFghaIShouIxMEWSPBgKKkuByCmAez
	vjNTb+l52MLRhAwkQOOIaUWk3W9lLqHlUg+D6SdiHP5rO3betWJVVl3ZsXwOVRg/hLUNXf5xIEa
	tg61wYuvtN9iPzoLCE2TTEu4e5gik6DoNue/pzOfhg=
X-Google-Smtp-Source: AGHT+IHZgIxpjg/6kkvcMW/J7xD1PN1qAsKtx/7STdfwV4yzIcWv1dUE7oPcxZBo21d0/mZd0RfXxsWJndcH5nudxHU=
X-Received: by 2002:ac8:5755:0:b0:4e7:2b6a:643a with SMTP id
 d75a77b69052e-4e72b6a671cmr56529361cf.12.1760418279258; Mon, 13 Oct 2025
 22:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
In-Reply-To: <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 Oct 2025 22:04:28 -0700
X-Gm-Features: AS18NWArWNcPKS90Zk5Pwo5Ct2LOmBIBPcz-hhg5UK9PsI9_HIhdsDtGvM5VF4s
Message-ID: <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 712831C000B
X-Rspamd-Server: rspam02
X-Stat-Signature: eicrom837hnw1c98zm1bejsk34yg8us4
X-HE-Tag: 1760418280-157945
X-HE-Meta: U2FsdGVkX18kY/ch21V6EqcGyYl+hx1oYKZHfuRUvPNsTI/mJQNVWhBu97gqJItxY+3V73Ky/baJ3L2KadYewZ/AbmKKDiqvz1gsAcBQ1bZ8CpUqwBJ65cTvDSpgJJ6sh8RbdG8h0O3ATUsP8rlrcBuodqD35JdrtHIhAdEGqJx2KFb0ziJaj9tz8I+Qxq92cVdcU2ir4nvswDYfyvckzJ9on/e4BNKIMWxmWtS2sYAOHS1lnv8To0ULlw9qlz8dNZEo4cmmtFXY2CcWxob5rE/RYzKHojON9mevLfX7hiLGkPnxFf08OEypcS13aulv3yBDSMt8QlZjF54YF0wNt2z2cAm79YTPp8C0uyeu0Rk3LB3v3EXRAlWE1EU0AX8yCcOUaf+zrZZVACxS+2lxtzXgU+WVVXQJKhZ4tVGGl0iFc7eEHWPNiQg4g+dv6DvHnEZSTZq4DrIuchdP7MrIksUEjHKzFEH/7fd3xC/sYWfpFsAOjSW491IGhHzn9ODEnccmUS562WlHWcLxZoFGczPh/cnvNDuMHvDTR5zKBadg9ojGV5ml+B7byEuXjuOhyiMiveulnQoxy1xwgo6Nke23zvU9OG2PNieadyXkHgS8cvo5v/b9K7aiygCYISGw7I37l7lsfjw4gpsrgBeIpoU7kdIn/radZW+zf0ZMLV5FjRwwL3gGCyIUFPCG7x9KiLiSrFcx6wlwanWDaYXm8dOa3e9qZyDuSEGBOawSluI2XM1t8M9ohNlmyLiIdZAn/vmO//MMNdNyf9QMGxT6e2hr7lzStUEsOjuCHSnE+tMjpvL1FVPUTkbp3IhVLFnfL7yH0hmI7d+XBETUxhf/KcInXrKtlcpb52joEULE0fZEm+pBqmlCoGzQln+8Y4aA0Gtvc4quWies7HVVRiFlzd0SlH3N3kgPaOXUG6CQLrQCQSfIGYWJQkRdEJpgsVqtU/SoNFBkw+aK/sONsnu
 HKypdnBS
 v5gMhVfEdE+VI8xaAx4A5V+KtcDBR9dBDgRTN6wZyUgLGrLmB0Wnip7Yw5KHyTY0myVOr2PXG40NZB+5Iimp0ETWmh8MA35/SQ6Doash9mpHqst7HoCuLd5VksafG7yBfMt4g1IFKX9vEls8zTpTuPkk/8AapKrQ0HTdNcklo5QmYYhsruooQWiwf0tIpohqbz6fcEvYQw1S5Xv8vojzIj+pVvOmktcozJ9XUXHVdm43ghsG6x84m+jESN/e3etUaroPCKOOQWCL+WQbpK6xSThrokgZLeCHzLrv/JlH0P0KbTnWdjlgYA7bhng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 9:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Oct 14, 2025 at 5:56=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Mon, Oct 13, 2025 at 06:16:36PM +0800, Barry Song wrote:
> > > On phones, we have observed significant phone heating when running ap=
ps
> > > with high network bandwidth. This is caused by the network stack freq=
uently
> > > waking kswapd for order-3 allocations. As a result, memory reclamatio=
n becomes
> > > constantly active, even though plenty of memory is still available fo=
r network
> > > allocations which can fall back to order-0.
> >
> > I think we need to understand what's going on here a whole lot more tha=
n
> > this!
> >
> > So, we try to do an order-3 allocation.  kswapd runs and ... succeeds i=
n
> > creating order-3 pages?  Or fails to?
> >
>
> Our team observed that most of the time we successfully obtain order-3
> memory, but the cost is excessive memory reclamation, since we end up
> over-reclaiming order-0 pages that could have remained in memory.
>
> > If it fails, that's something we need to sort out.
> >
> > If it succeeds, now we have several order-3 pages, great.  But where do
> > they all go that we need to run kswapd again?
>
> The network app keeps running and continues to issue new order-3 allocati=
on
> requests, so those few order-3 pages won=E2=80=99t be enough to satisfy t=
he
> continuous demand.

These pages are freed as order-3 pages, and should replenish the buddy
as if nothing happened.

I think you are missing something to control how much memory  can be
pushed on each TCP socket ?

What is tcp_wmem on your phones ? What about tcp_mem ?

Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat

