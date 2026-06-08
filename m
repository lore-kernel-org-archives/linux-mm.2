Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8201CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271F66B0005; Mon,  8 Jun 2026 12:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222AF6B0088; Mon,  8 Jun 2026 12:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1387D6B008A; Mon,  8 Jun 2026 12:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04FB56B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:45:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3B051401AE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:45:12 +0000 (UTC)
X-FDA: 84857320464.17.58DECE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCDFAC0014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:45:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Miu2Kz90;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780937110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipGCjwv9gnvMRM7h8JLTQKxUYjkO3bCbc7n0K+vTvyc=;
	b=00rBgex+IUaM99xe/XLEZOjmVvC+9ZO/0Y7y0Px05J1LHakxwdisLa7pPJDvmIU4A3xcfB
	PGLnPd1YZeOL1X3vRJoCRSIIaXWsz3xdMfn9xNAznD0wSpP0Z5kDKAmXxpspRGzjSMUQAq
	HnmahOBf2muVSug+0e/zYxsqnqK2U9o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Miu2Kz90;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780937110;
	b=5tpPXqtkszD+Kuv6W+1b5UNfdxNXb+JULJ91SFm6XEJczdGvhzvnlRGRMSFxnn1ZTZ/ZNU
	YXZY88vrYfoeohdjbwpdfSaCrp5RP0aALzy9A+Txb8aStCxgq074ydcl+/RBmtNv73ffXx
	NspzlE6uCyoquYwQ57YRxns25/P/8DQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2357C601E2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94821F0089F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780937109;
	bh=ipGCjwv9gnvMRM7h8JLTQKxUYjkO3bCbc7n0K+vTvyc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Miu2Kz90Sss0hHyz/wczZwHMiEB9E26wOqbsVFZgOkgv1IPFGKTzsaEVNQvfKPvY0
	 8vqvXXAcCzeGKTMMXTBzmOW3/oHllpQx+HOGKHXdrfui97+PfCeyROjBi0Ag3W0CWu
	 5lQmGvOkEswsPiN8vDVO14jpkwHAHMt0jjfPHwnvrsqfLsa9c+Fq7QQJJUe9UbylMu
	 6RMnDzCc3xTmzxlzzpKZ/MTk7SWYNesDMJyCsyr7ZiOhbaJgLTQsuN+XudkhjtCFoT
	 x7l8v3gdlR3KEXRNeL/b1LVRuymGkZZFePKigytY3xTQEiz6kiJYYMl6nlLG099isl
	 rk7D1e9SU84aQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bf84a2b2077so84205266b.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:45:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/2u1S+tK1UF8odyhbZmfubxPyGqQmOGQixC8doruVj2Vr4357hBMrEi+fufCk9x3tBNEyb3+c2Zw==@kvack.org
X-Gm-Message-State: AOJu0YyV8yvvNVZy+TJjsTzaKO4l5P5KSE7SzqvQg7Re0W5G7KVNiHhS
	AnkWTFMofKfxNc8MEvIMS9GYz6F5gGdLkRfCMLXluOjBD9nY20/X7lq9JbN9hNg/ywxSnXorZcV
	FSn8ZxY/2ZI800Oi6E08QYoo7zmSSX1g=
X-Received: by 2002:a17:906:8a46:b0:bd6:4d8c:bbff with SMTP id
 a640c23a62f3a-bf37234bcccmr523737466b.22.1780937108568; Mon, 08 Jun 2026
 09:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com> <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
In-Reply-To: <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 09:44:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMmFuR-==D2NhjzjRr3f0TzCK0woSWaX1JBjJhM=_NOSg@mail.gmail.com>
X-Gm-Features: AVVi8CeITmeIMmAsTo-NaZ6aU_2FnPB84tu3aV4hStlh0vvIQtZippyM4K4eWRs
Message-ID: <CAO9r8zMmFuR-==D2NhjzjRr3f0TzCK0woSWaX1JBjJhM=_NOSg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BCDFAC0014
X-Stat-Signature: eedqhke9cnrjrkuyatywe69rfh4quxjd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780937110-972623
X-HE-Meta: U2FsdGVkX19zPHelwcd+8vCs0E1XxKEfXa0lTeQh5Npo06DIywxSDwh0m62kBz6DuiOLyjW+aBB15qk9qVkVqEEB/ATzta33dQ9LDSxUcQRjUOWc6WlTAVWfdqj/y20d0t9qBB7CiOT1cwaZ8DdeU4NyVhV8N0VYTlzk4wbyn/842yhIZEhToLA7CThK4eNkL9QFjjLfjLFC3Ed54X87kEdUph/S2wxWB7jwpXUG2yiTnSXxxXtDvJ2LQ7Xwv/5xFXrYuPQKfC5cQrS6XLts+MmhG2apypd6TPmY7hvfoU0n1iXvUyFgxpPSiB9SJCi+t3sYvlAaQ+KY4lsLEIffjMlXy2GRbHzILIQuA0Fy5y9wE15t4kxiYaRTNB/J2IbZMhLyIgoB0H2QDY9ymB43YLIaumymopegF49J5oRGlCfU9XekttVBmF2Td1Fs155IrMRSFndoENMa5WbqrgfDEogtDLPOwxyExcr7kLxvmTOdLCpEThQFKUKWVJq0YuPbQHl3VXslV8vVMOv9WjLqx33AZLvb5heZirbSibj1kLilipieW4Z6nTuL/nGxV+vO8+WsQgyJ7733pfh0rBT/yDVKTbnrlM2XK6AX45hCCD1lFWMexqU1uz/j+6wjUSj1dXFyNuci0rV/x4pczigNGBAGbPbXQVc5cY6a/DGbCzBrayEtOMc1Wt4NXAK756UfAC5H4l2F8AkvZLgnf0HQ82Ng1xovlN/u/yfEfXfA86rF7KoL1kx4r+UPk3Fk9r8NZkdXpYaa02A026vAFxg4+ylwmzZaA2SbJ/0FClWO0e4yxfyFkLtajlAGyBcLM9G0i5fx5B4wM17LCZB+rkQ5jfHR9Z1CTYnglNcGK23yUOzWhR2Y63uBYrL+QthxPbOq1eh07SIA4uqIXZOzbWAQXaglCBr8RNOXAjfKaeEjdRXQ5+aY/pi+lJdMqYJcAolk6ra3jrWtaR8pOUsUwwn
 gBd8JIFK
 ZXVu/pKzyLK+5i9Fvg18wgeQvdnh4JkgWOg6afTGbriaVN1SxuXjZN3TjzpwAJYp8LM1hS6utH+YSrDCTbjAfajm/se1gop+TT7Fzd9TjDSbZ0GLMmRosmmvODav7e6ykTTuiMmEE/ZonKsXUk9rnVO13dLrCbKu3kJLMfdr9qINhInho4sIXVU4PoXF9O0Mj0f5IeDlxOIGRWQXgEsW33E5LpPS3uzFsrQZCSFX/SEeMxTv2DBU65f4z3rh05ogJSVgcpCQ5B1P4Dme/VKXkEgSeC6BPCGurHJ8s3rSVMp2GkO/Jx0iWKEf1sELGlOB39g2lce6mpzEwQ9CbFQBdiOAICwyHeGd0nSh1qCKpxDbur9q4pXmbOwCcxbCCw/BJ2W+0JxKQygJ9Fu2HNMYGMwT8klQeQtnkgTAvbc50JADGxZPpEm998sjDhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 9:23=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Jun 8, 2026 at 5:50=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> =
wrote:
> > On 2026/6/5 01:23, Nhat Pham wrote:
> > >
> >
> > Thanks for the suggestion!
> >
> > I ran some tests and found that neither the per-memcg cursor nor
> > different batch sizes have a significant impact on proactive writeback
> > performance. However, exactly as we suspected, without the per-memcg
> > cursor, the writeback distribution among child memcgs is highly unfair.
> >
> > Test Setup:
> >
> >    zswap config: 18G capacity, LZ4 compression.
> >    cgroup hierarchy: 1 parent test memcg with 10 child memcgs.
> >    Allocation: Allocated 1600MB of anonymous pages in each child memcg.
> > To ensure compressibility, the first half of each page was filled with
> > random data and the second half with zeros.
> >    Force to zswap: Ran echo "1600M" > memory.reclaim on each child memc=
g
> > to squeeze all their memory into zswap.
> >    Trigger writeback: Ran echo "<size> zswap_writeback_only" >
> > memory.reclaim on the parent cgroup 200 times, with a 2-second interval
> > between each run.
> >    Metric: Monitored the zswpwb_proactive metric in memory.stat to
> > observe the writeback volume.
> >    **Note**: The size here refers to the uncompressed memory size. Also=
,
> > since the second-chance algorithm would cause many writebacks to fall
> > short of the target size, I **bypassed** it during these tests to avoid
> > interference.
> >
> > Without cursor (size: 1M, batch: 32)
> >    child        wb_pages        wb_MB     share%
> >    child0           6368        24.88      12.50
> >    child1           6368        24.88      12.50
> >    child2           6368        24.88      12.50
> >    child3           6368        24.88      12.50
> >    child4           6368        24.88      12.50
> >    child5           6368        24.88      12.50
> >    child6           6368        24.88      12.50
> >    child7           6368        24.88      12.50
> >    child8              0         0.00       0.00
> >    child9              0         0.00       0.00
> > Without cursor (size: 1M, batch: 128)
> >    child        wb_pages        wb_MB     share%
> >    child0          25472        99.50      50.00
> >    child1          25472        99.50      50.00
> >    child2              0         0.00       0.00
> >    child3              0         0.00       0.00
> >    child4              0         0.00       0.00
> >    child5              0         0.00       0.00
> >    child6              0         0.00       0.00
> >    child7              0         0.00       0.00
> >    child8              0         0.00       0.00
> >    child9              0         0.00       0.00
> > Without cursor (size: 6M, batch: 128)
> >    child        wb_pages        wb_MB     share%
> >    child0          51200       200.00      16.67
> >    child1          51200       200.00      16.67
> >    child2          25600       100.00       8.33
> >    child3          25600       100.00       8.33
> >    child4          25600       100.00       8.33
> >    child5          25600       100.00       8.33
> >    child6          25600       100.00       8.33
> >    child7          25600       100.00       8.33
> >    child8          25600       100.00       8.33
> >    child9          25600       100.00       8.33
> >
> >
> > With cursor (size: 1M, batch: 32)
> >    child        wb_pages        wb_MB     share%
> >    child0           5120        20.00      10.00
> >    child1           5120        20.00      10.00
> >    child2           5120        20.00      10.00
> >    child3           5120        20.00      10.00
> >    child4           5120        20.00      10.00
> >    child5           5120        20.00      10.00
> >    child6           5120        20.00      10.00
> >    child7           5120        20.00      10.00
> >    child8           5120        20.00      10.00
> >    child9           5120        20.00      10.00
> > With cursor (size: 1M, batch: 128)
> >    child        wb_pages        wb_MB     share%
> >    child0           5120        20.00      10.00
> >    child1           5120        20.00      10.00
> >    child2           5120        20.00      10.00
> >    child3           5120        20.00      10.00
> >    child4           5120        20.00      10.00
> >    child5           5120        20.00      10.00
> >    child6           5120        20.00      10.00
> >    child7           5120        20.00      10.00
> >    child8           5120        20.00      10.00
> >    child9           5120        20.00      10.00

Yes, the per-memcg cursor is more fair, and you can synthesize
scenarios that show that. However, I don't think this is a problem in
practice:

1. The unfairness is limited to the batch size per-invocation. If the
batch size is 128 pages (your highest one here), that's 0.5 MB (on
x86), which is fairly low? If the batch size is 32, it's even less.

2. Realistically, if you have a parent cgroup with with >10G of
memory, you wouldn't be reclaiming in steps of 1M. If you want to
reclaim 200MB, why are you doing it over 200 invocations? If you do it
in a single one (or over a few retries) the shares should become much
more even.

We're trying to fix a practical use case, not finding reasons why a
simple implementation won't work -- right?

More below (to Nhat's point).

>
> Yeah OTOH, we don't really make fairness an API contract here. When
> you set up a proactive reclaim scheme, if you decide to target a
> cgroup (and not its children separately), everything underneath it is
> fair game to the kernel in any split that we fancy. If you want true
> fairness or a desired split, you have to treat them as independent
> memory domains and set up proactive reclaim to hit each child cgroup
> separately (i.e one "echo > memory.reclaim" for each of them). This is
> necessary for example if each child represents a separate, isolated
> service/container/tenant. And maybe this is actually what you really
> want - hit the ancestor cgroup very lightly for the stuff it owns, but
> then dedidcate most of the reclaim effort at the leaf cgroups
> independently?

I would go a bit farther and claim that ideally fairness shouldn't
even be a factor. If you invoke proactive reclaim on a parent cgroup
with 100MB, you want to reclaim the coldest 100MB in that parent, no
matter what child they reside in. If one child cgroup has 100% hot
memory and one child cgroup has 100% cold memory, ideally you'd
reclaim all the cold memory from the second child.

However, the implementation of the LRUs and the coldness tracking
doesn't allow for doing this, so we "fallback" to reclaiming in
batches from each child because we don't really know where the coldest
pages overall are. If that changes in the future (somehow), I argue
that the correct thing to do is reclaim the absolute coldest memory at
the parent level.

If you want to reclaim evenly among the children, you can do that and
directly reclaim from the children.

>
> But OTOH, this does seem like a recipe for inefficient reclaim. We
> might exhaust hotter memory of a cgroup while sparing colder memory of
> another cgroup... But maybe if they're all cold anyway, then who
> cares, and eventually you'll get to the cold stuff of other child?
>
> Yosry, what's the concern here? Is it space overhead, or overall code
> complexity?

Mostly the complexity (e.g. the zombie memcg cleanup) and a tiny bit
the unnecessary space (8 bytes is not a lot, but these things add up).

