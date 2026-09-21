Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BB4C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924BD6B00B3; Sun, 20 Sep 2026 20:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901CD6B00CF; Sun, 20 Sep 2026 20:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB2E6B00DD; Sun, 20 Sep 2026 20:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58BC76B00B3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:53:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A76B2404E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:53:35 +0000 (UTC)
X-FDA: 85235946390.10.4A199E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B15681A0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:53:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUmvNjww;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789952013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uT3QSlJyDb/QyaIb6RQq4e3wjco3xR5/xUinc0PHAM8=;
	b=6XOgSmKU1YpNcYvGVa8ip/GNYwSw1xevcQu+6kbW0vfSWXyQOYawgKX+wJYLcrAccjlMXF
	q8kvTQfY8Tlg4SRoNfuyFjscOl+1zoER8ykv971jx5Dav+8vU88UsIQe5pvLi1XKBDJ90V
	kA9rM1wv6lsBH+xFYuI4Iw1uQD7cKGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789952013;
	b=iqbiPNAjrlyOGX5zbSkwwavr8YNOcKIwmdodXTcnHzvtBMOtMZ7Oqks1kd/A+jMX0P885f
	QGLipkeJIBoVbLlexOhEdsQMZajhEfJXNzZVnV2jDY5pEkWz0v8mQ/lE7OoXAqOnd8hLAI
	CnMAaGohaNW3RxN7prLxU8ORjd3/VpM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUmvNjww;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F7E449F7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30F61F0089F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789952012;
	bh=uT3QSlJyDb/QyaIb6RQq4e3wjco3xR5/xUinc0PHAM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fUmvNjwwo7Prlb09QFl/qwCJc9GZ61E7TkXlb8KqsM6v11ueO/rugvSrNKOqgl9wb
	 c0gA4x9DPeE1mvz2vvIoyy7nWOGDBljjy5ncBxydkFD+7kxZkCK510WOPuA8ypZ41R
	 4mQ/hD62inbiL2R5rZ98ggSezMraCvoroY7e2QmmCYQoJ1aLpETfVaJ3JA+kSt1o1k
	 lsrJ/4NnF3xCgql0ARnnrJjyN8bFifYiW5K/luUMkh+2rrgoevmcJXoqz5NKZLZTP1
	 pd50FtZrPLlfE2dDoo2kTvh81y1ZBF1nQF/zOfcmRhcPU5WZ9SOvgBZ1LUEYp1O2E1
	 ULHCYDGx6ZK7w==
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-8659af7454eso23061197b3.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:53:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwuH9L0CiDg2pzYFuOGZ1qO9vD7kACYxatSsC1teGG4KzaI9Lsd7xqKsgqIVtlyUujUjec+u4VEDQ==@kvack.org
X-Gm-Message-State: AFuF++mZv0xOUE3Aw9R6Xm+uvn60CblP+2fJVHibUi2lUZNT6mtxUbAf
	prQomrFlIp7uZ54U2nDmIHioeYuuOG3f32jsU0WsNnlkNH5NZ5KWZK/y60nvjtyYdCqmxQJDQT+
	KlfSPZ36HJtHWrB00Me59DPr+nKjJIE5CkJx9w9/NPw==
X-Received: by 2002:a05:690e:813:10b0:671:2228:1137 with SMTP id
 956f58d0204a3-6717fcd026amr1947180d50.44.1789952010724; Sun, 20 Sep 2026
 17:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
 <aqU81l1oqGItb-0C@cmpxchg.org> <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
 <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com> <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
In-Reply-To: <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:53:18 -1000
X-Gmail-Original-Message-ID: <CACePvbWg3be1KippqraPp6xV0xkrtw0ZAW74tFj8so83+t55dw@mail.gmail.com>
X-Gm-Features: AcwNN1UZiIocWVlz0qgZ7OJFByEl-O8xTB4E1qJAixnrA0sBJyczejwjOKx08OA
Message-ID: <CACePvbWg3be1KippqraPp6xV0xkrtw0ZAW74tFj8so83+t55dw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B15681A0002
X-Stat-Signature: juba1mrs5bym5exunpiehjzehtt74j88
X-Rspam-User: 
X-HE-Tag: 1789952013-312053
X-HE-Meta: U2FsdGVkX1/hbF6kH/qLgeIfwrXt67RSPOiPpIOpXUoDdkQUyYcCKY0Irz+5saDLa3NN/kE20pJ36gMfePFvNBAmqiSV78CYI5EpEWZL6K7phlp0sYByC9FeJ9qKC+vZD+anHGJPARKWrYdo5OBOmibFg8krl2BilUpu7JDIAUih0+qr66wNrX02xJYzSr8rSmvw62kHr40os5UhnpO+0DZsWZH6ce4x1I2QfP/QcAWuIWDZwSdlGyZ3pPq1qAvoRWqyuIvPtbJavzxOrw5MCXwuwPa+oqOp6bR8o7lkqbgTBspAz8bJzNZ5x0vMKSTwhTRldHoNmq2QnjA+1nzyqW26lDtAbdprfpFn9k3oxaLvB4kNUfo/lMvca6tPBMD+vUcOfJqcJv5Lg500gYl7P8KQS4pyC5BprmUeDPFcJ986KWMmkyoXo2z5+nhNTiNGlwsG27+wXN6A8tKAWEN92ubNVqxu+J320THiuPHL/UslI2ZQstAbnJNLb9KktNIRUtAqFu/D97dfboHkYZzwV4hQvUGvn6oFOM6E+Apdd8hUtxh2m6Jbn3ftREJZcYuZq7ylfV4/XSehYxjOTy4DBCbKwe4w5DhURPJtjCCEwg5slA9DL3u1aCdZXFkZS0gC0lTZ4/VyhMPLeiwitTch4RF+zgtRIWfFAuVskNSkjzo3mKLOJU0uXfpRWGeNdfL/uYkR5kLo41aCzatmDW6ZYnzyMUUMDw4WT3Z7uA/Egkc86panCNe1ftt7zA09B9ONO8MdJFkBNi5p0SkJlRd1jDnRrTlYCD6NwFDw9c2JnQz6tp1A2Z2C/aRNKmIkmlW/eYA8cy1vibF05S5PWgA3HEZJoQ8temiZ0LGgShLfg4VYvuGIS/MLxXoWSCiNW08wbNmcbmDkcXbH9LW1SFVNxZLz4zvwW8dv6dfwnz+TTbOPc77RhskHc4hxMdEbl4ayAYvRRPulY71ZmrLil4K
 JO93fScr
 2YLcPRaQunxsNwiUZm4xDePOPezFWh5bCA5hrhpLtuuOxdYjOPj4NamjCwxdvZEJ8nnWoErrhY9qoOFAFzq9wodAvoa3kqi5eBiDt7T7NHDz2l/+oFkcn7hXmv7akdpwcgRvaMZUuxA1YIVKdPJT+eWAmIphh4cdQ17S/tq74FIm9Q1xdkOE81mjbOHqRCDWJG6F4L0SGuOEo68pgYJQhb8UVc8JWiRuGFQGZsJfZmAQkrSducIDFeH5kIOL3rb9ZjIY++PGVDxXcTmyOJXgMsehz0wtuJAkiWo3S33uqRtLn7LHihRDt8r+A5BtlGRxBxqsT7kln1zrID3O04e4cXokCiphCkY1Hi5S2P99tkjLKN5VOtbxgt3M86ldW9izj5G1kJMYIn0vwuZvu368ydvwhQnH/YAqVb3bZtvVKnyf4gdXopg43kkdjvkr20oUdkFOBcQe/TgoNdkW8wcI051UdQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 2:36=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 14:18 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > >
> > > > For our deployment, we only compress about 7-10% of the system
> > > > memory
> > > > before performance starts to suffer. The feedback loop will scale
> > > > it
> > > > back. I am very curious do you have actual work load to swap out
> > > > 100%
> > > > of the RAM.
> > >
> > > One common workload is a web browser with idle tabs.
> > >
> > > Those often compress pretty well, a ratio of 4:1 is
> > > not unheard of, which makes it easy to fill up
> > > 1/3 of memory with 133% of memory's worth of compressed
> > > memory.
> >
> > You did not answer my question. You are talking about user-space
> > processes (browsers). Do you run your browser in the data center, or
> > is that a laptop workload?
>
> The browser runs on the desktop, but the same
> kernel runs on both.

Interesting. The desktop is having a GUI or headless?

> The things we build here cannot be optimized for
> just one single workload. They have to work
> everywhere.

Sure, but on your desktop or laptop, what is the max amount of zswap
swapout compared to system RAM? It is obviously bounded somehow. What
is the actual number across all your deployments? You don't have to
give me an exact number; something with one digit of accuracy for the
maximum is good enough.

I am wondering why you keep dodging the question? It is just a number.
Do you not know the actual number, or do you not want to share it for
some unknown reason? I shared that our deployment commonly uses 7-10%
for zswap.

Chris

