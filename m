Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC3BC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70D16B009F; Tue, 22 Sep 2026 11:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21766B00A0; Tue, 22 Sep 2026 11:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D106B6B00A1; Tue, 22 Sep 2026 11:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABFF86B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:23:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DDE7A0557
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:23:47 +0000 (UTC)
X-FDA: 85241768094.04.D548D0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4336E180009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:23:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0KIDibg;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSxYC9PBu6O3qFc8TB9GBt3gfPrtp72o3ge0jqAtRpI=;
	b=s42+S/zI5mqrlW/ddWlg9CN8czFHMbnD19XKXqPaEqK/m65URpvzchvggiwTVoPKeyLhEY
	BsR1rsF//K+ZqvT8kZ/x6lZ5QtpY8RSv7csHHe48m186lndgnDIbykbBT3P58bhZtp4pmX
	lSNL1fhtYbAl9CZm+H24HJXPBYaT+xE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0KIDibg;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790090625;
	b=vF6dIXnfqie3cRJs4vnCygft6F8V7owLzmIySmfGMzNEq5CILJFE1daeTx6cEthE8GKvSu
	PahunECsovZ5+BjNB6upZnnQSj1QibOyM0qmbLNqTS8hv0397ZMBzMjVM5k+fQdEqblQNT
	RNOHsrZ59d4MCcCN/Lq0My3G0HPJx84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EC6E4140C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A501F00899
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790090624;
	bh=HSxYC9PBu6O3qFc8TB9GBt3gfPrtp72o3ge0jqAtRpI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f0KIDibghpuCfT//z5YJBWxvFz2V4tCU0i0WBKMDTdWD3n5JHLjhSrXi7M+Bd6uwu
	 SBIuxdzV+3PvsWQEaBXEy8KygyslWiTn8kWjWDXqKj+RXo9C2Y1LRLL1Satgc5EbFW
	 db1vY9ShYPHMRn0Vj93U0YTgPQNAUGft8b+7dIiqSQmuzVu6zN1veFE6dDKOaenJ1A
	 6EBYqwuvfhDpg9jM/74fZQO3Igiz3EIBGcOksIoBtD0qgD9zlt75DYlQK5XlWhH52q
	 1+Y4YgLmeDGFvrzmwe9SUnziWvrJnNXc4M7qrT8oqlCbOyG3eTF/R9PeQpQB+R55A0
	 ymDtoW6bFe+/w==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-671563fb8beso4123783d50.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:23:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzIhQvVU6n2KT2Fhp4qqmZMSY4I1N3Q9iqW3UjqLfCeb+qnX04r/Wjqme/HxthFqLhx/tRhiG5otA==@kvack.org
X-Gm-Message-State: AFuF++l73woxoXTdMNPN51An9sLyDi8Yadzko4+tyYF8K5tRd6CL4Ix7
	gZ8TkScxdeEJplyzlGKxxUvpE34sQd+NrIU3LssHy+uvOotSsRvkirckLwtHyf2zYSc5RLamrgJ
	b2kwJSJZTPpZ8oNhGkYTmBE26alxTgvdPPNbRPjcy2g==
X-Received: by 2002:a05:690e:488d:10b0:671:2bb8:ceb0 with SMTP id
 956f58d0204a3-672c54637fdmr881282d50.65.1790090623628; Tue, 22 Sep 2026
 08:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com> <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
In-Reply-To: <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 05:23:31 -1000
X-Gmail-Original-Message-ID: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
X-Gm-Features: AcwNN1UFfFWGyxcUua8pbkXO0R-XB3znLXKYfEROGrlAbT6An5bo9JO7s142iI4
Message-ID: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4336E180009
X-Stat-Signature: wuzm3j7ygukaamxg9dh54wtk7e3kdjrx
X-HE-Tag: 1790090625-606704
X-HE-Meta: U2FsdGVkX18E2X1rFVttMlzGMYJVHCZfAXEXRReI33oNBhYGqLYbli/N++I+74RWIj1zNscdLAenTU5gBOiFyQdR8bb8NbWwQhBKq1xMBehHRWpVL9Hgp4tR4/aZHF2rc/ktxsRPQtbz6kJ350vIuunvzZSen8wQ5Nu3QadYuwWsIRJGhXoMv9zBTb7Wk9LH46Bc23L/MIj/UGUbg80FMMIbELe1qq4IddKLBsdnpKHxM3ZfZIcdkQB2do7LimysdulcJYMoNYX0Hgcc3DaNkNq32HLKnD70tEfmaeSVUiedHM8y+35jYGnIvGNLfI4pKwKy2AZDojYT6y5NucfGiyPM242Pyq8/TcLfEr3hbnGm6RjVzEPkGkE/wAPEaWKvVoN8qnx5qxcJqIFQ0WFGVWNwMaQDG8M+ai4A/oXGTPcwLm8AV2KDZfYMtxZXjV4kfgA4iPyf5vezK0oUlfXjklgcmCskPzSX0BGGVxH++wCDrJcSbk+Q8+KXDgKSSW5jcqKf/u1qiLSv1ArYg2SKu+uenLcYKBN/fhOx2vMaOtuE3u3ED0vbCa1gYdSGHef5XrOq+p0kyIEX2lZBhcrxz3FegTOpSqittxJ1uGYqByGWKUYVSqlfA1SNB82CE4r5pjpV7/bH4rIbEr8NhSjuU11+erwM33M7UNhcIFknXDtY7CQlz9ar6hijUqlXqrMBOhnzvRv2sJ0kvugIioSrwS3X2QJDpYEmKybEcf4zF/BwO9NiG7y+o3L2WldrfO04oDw8z5y06vgdSSYA27Rc2sLr9rs3tE2UR5f2rs5S01C2fPN5PBZwIMdTQFBPpoc5xsKacTMFUVILy94eyI/9iIdwp1OnpdsqfKah0UoUX0KGDIdPBdUrzygt8Nzab4Lp/1IBkZPKfkP2djGDIjvugXap23nqYLl2if3xUiBOId4l0URpZVvzeNgkArQk6Q0+GB6wcZMXUxopD7pJNJ3
 IaBjFu6P
 FHPICF+D/nh2C1rCgem/1gDe3RjdTw5lMk4YkaLGposkMErKvyc9Xjxq9I2vsPYEVzcopkFv+UNSOh8mu7nnujqHN+F4VUyK5mghRVg6Wv6UWdjcHV/Yfwj6TEqr8Oen1+VWgwfzZKLwcA6va1H7Tth8ou0Q5cJCny1h6q3LF1XK5NLEmVlqHjiCvXDa9wUk55pCS4QK0fxqEx52cidNrxqgNVVEw+z1MD5utjyfireEcHoMppoaeq25lZrkXNrlFtvCxjVDylmNlsYu9xEHF1z20Pu1LnR8KMab9/DHdyLz+r2QrPPkF1FgnCBlDeZseNrw9fyvAZMeaZdIzUt1nhp3ZgIvwAAEsS1Ev1ckFsQSWI84SoZvqfaFqWZu39Yp1e7zV7Kjd0CujfWSXZYEOLJ8tPKFMl+T9e4CVQ4T9PAa5bSMU3cZRZgVAVYV7vDPj2Brd+n6GNOY5+6EKCCjIa7mmCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 03:32 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:53=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> > > > On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > > > > >
> > > > > > Give me some real-world examples of people hitting this kind
> > > > > > of
> > > > > > limit.
> > > > > > e.g. MAX(%)  > 100% and still have a usesable system. I
> > > > > > suspect
> > > > > > that
> > > > > > with 100% zswap usage, the system becomes unusable. Please
> > > > > > show
> > > > > > me a
> > > > > > real world case that proves me wrong.
> > > > > >
> > > > >
> > > > > Here's my desktop system right now. The amount
> > > > > of Zswapped is more than twice AnonPages, and
> > > > > the system stays perfectly usable.
> > > > >
> > > > > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > > > > SwapCached:       252340 kB
> > > > > SwapTotal:      41523604 kB
> > > > > SwapFree:        9802088 kB
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > > > AnonPages:      11615760 kB
> > > > > AnonHugePages:   1402880 kB
> > > > > GPUActive:      13112428 kB
> > > > > GPUReclaim:        95980 kB
> > > > >
> > > > > This is also an example where I cannot really
> > > > > predict how much zswap space I need, because
> > > > > that depends on what AI model is loaded,
> > > > > which drives the GPUActive number, as well
> > > > > as the number of browser tabs.
> > > > >
> > > > > The system is perfectly responsive.
> > > >
> > > > Great, that is getting somewhere. We are talking about actual
> > > > usage.
> > > > I
> > > > really appreciate that.
> > > >
> > > > May I ask what the total amount of memory (RAM) in your system
> > > > is?
> > > >
> > > > I am not asking zswap compare to ANA memory. I want to get the %
> > > > of
> > > > the total RAM.
> > > > I assume your desktop has more than 8G of RAM, right?
> > >
> > > Right now it has 64GB of memory.
> >
> > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> >
>
> > My point is that, I haven't seen a case where the application is
> > still
> > usable with a reasonable SLO when 100% of RAM is zswapped out.
>
> In my numbers above, the applications have 11.6GB
> AnonPages, and 25GB Zswap.
>
> That is about 68% of anon memory stored in zswap. Not 8%.
>
> Out of (anon + zswap), zswap takes up 43%
>
> Can we at least agree on the observed numbers?

Yes, I can agree on what you observed. You are using anon + zswap on
that app alone. That is not what I originally asked.

My original request was for the whole system: what percentage of the
total system RAM size has been swapped out to zswap.

Because when you have 100% of zswap out, it will likely trigger
different kernel code path on allocating memory. You might suffer
global memory pressure you did not observe in the single app memory
pressure case.


> > >
>
> > > hen the amount needed to fit a workload
> > > does not have a positive correlation with
> > > the amount of system memory?
> >
> > It absolutely has a positive correlation with % of the system memory
> > based on my experience. The % of memory swap out has a very positive
> > correlation with the thrashing on the application.
>
> The applications thrash much harder once zswap flows
> over onto disk! Out of all the swap options available,
> zswap is the fastest, lowest latency one.

I agree zswap is the fastest one, no question about it. In our
deployment, we have only used zswap for a very long time. Things might
change now. My observation is that, even with zswap, when 100% of
system RAM is swapped out, the application suffers greatly. There is a
reason why we only have 7-10% system RAM swapped out. There were many
OMG in the past that established this boundary for us. We did not make
up that number; it came from the real data feedback from the fleet.

So again I question the real data point for the 100% RAM swap out
case. Do we even know what the system looks like at that point?

>
> Forcing things out to disk "because too much zswap
> is slow" could just slow things down further.

I did not think zswap was slow. I assumed the swap was only zswap, and
that even 100% usage was too much.

> Now, there is probably some upper bound where
> the zswap pool itself starts to hurt performance
> because it's crowding the applications out of
> memory, but that could be quite large.

In my experiment, 100% is already way above that bound, which is why
I'm curious about your data point. How do you run and test your system
at 100%? Please correct me if I am wrong, but it looks like you
haven't.

Chris

