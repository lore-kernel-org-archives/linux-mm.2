Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91140C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692206B00CC; Wed, 22 Jul 2026 00:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642346B00CD; Wed, 22 Jul 2026 00:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5318E6B00CE; Wed, 22 Jul 2026 00:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 263726B00CC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:23:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7BAF1C01E0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:23:51 +0000 (UTC)
X-FDA: 85015119462.04.87FE715
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6D9A100003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:23:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hDYzxAis;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784694229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5lLBqkXiLoC8Qh4Iyl6dOVSKk8Sog4blIcYOY/X1U0=;
	b=BSG/K/C5ZLF3AvpaZfsG6yxDKIjOFXLkR2XpPrb/XzFejhC6tF9lwk1FnJZKGUPSArx/Pt
	OjZ/xL4goJnRB1pyZsHdpeGk7e+pmzkVeWk/U1mUBhX0VF4C4PUg0bmLAXU12FUVzWjjJl
	l7is4VausMs3p3T0dP7pNzqZgNVDu5Q=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hDYzxAis;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784694229;
	b=URYreMiclqaikL4pGjuB6+9S8BVXQU8RZUDcTGR3ktVnFMvqGH8Ui5dKgippGmiV0fsR5s
	E7uZDou7t+a2yW+PrHc5DFA5jVjS+u7Ab6VJRvhbkmI1O5ULqFvP+qsQB3mo8dW8R7ciOk
	4zf/eH6T24O5hD+/Wjn/8BDUxJGGWrE=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f360851aso1328151966b.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784694228; cv=none;
        d=google.com; s=arc-20260327;
        b=VBjtsigPSo+e68cRE9+E7/THGlyLACksNaRTRBzGspvw8WUTlPlmIEMAXGQHKNekJe
         FEMyUDvKmCvXcHaWVKkMm9D5zjmIfkRY/H+0weGldnUI/6JHRy87k489iBJ87AkJUewj
         HrFO+69UxTziHkwxkn6oSnL4n46iPpvQGzGy0goylS4d1Xud0s9BJJbpkuU9IaEAPIfC
         nf9plXR68PbwmwHzWlk++Ncvhsm5k+VE8kJio5qn3/MHtGqIfvZyNgcDzTswk8cFv0Nb
         4qeBWHUtbORWkmCEpSTD4xTdxWiW+fTj9OBH2Z41NLOt56F7mip3xPfzyeIN3Tm14L92
         jpKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p5lLBqkXiLoC8Qh4Iyl6dOVSKk8Sog4blIcYOY/X1U0=;
        fh=EtUcPd1hiphIsqmc/TVVgMwz1sc9Du6SxlM1L312idY=;
        b=GnrVRm7qVyrw2WUC63VTh758G80ANS0PwwFOKsHWrCABmKQnWfEgky2Tot75IWyoU9
         Qt8MZ73t62rEphAZ6ekMb0d09AVojV7U2gR02vR5ps1WSU8+4JkED67Gqfzyw83uAdad
         qdOaL3Kb24KfDLfi9oiBbh7Tffra4qQLU/Ao7iGVRxw3zxd5uw+u9YflCNmaJ5oZT90G
         9fFbyooVJhmMa6sy+AOQPd+F544kt2VPbOqQx0vBpgrAsNLENyC9b/V2YgyavTmov1bR
         jhp5LONHM8BuKlp4vUfQKxFOyjr1cMM0ger7S17rXTdUOXZKI7+Dsku9IStlUIXGATtQ
         49dg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784694228; x=1785299028; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p5lLBqkXiLoC8Qh4Iyl6dOVSKk8Sog4blIcYOY/X1U0=;
        b=hDYzxAis0GrTEW1vangiRbgg+v4OifWXn0G4rx126lT83hA4BTLqsGLFwtSkhR5WV5
         LEKaTX5ekt/vVtl228CJv1vTnmkMB3+C8aih4XLDXm9O+StLNhz0qCWUPk4kLN/FGkLn
         rFV4gWT9H0k4FCPshoAvYTM9rlGrSDJEztf4HQmbOcSMZ6RCXYnSCCgivnPpL6Pe8bD4
         OVpohc+YsrtLcnVYES3kLDdld97WImUYTvdHD1gMXwA7arlaliK0GXsKs4iXHMTVPC/I
         xhIEwcAndWhs78zfMe0keabPsumwy+Hfxk3yPggICzAaGyMPYSORxasrS0XNDMXoEjZ2
         D6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784694228; x=1785299028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p5lLBqkXiLoC8Qh4Iyl6dOVSKk8Sog4blIcYOY/X1U0=;
        b=C6Ikiit/JvcDYI5CUT0oClGx4ile76zoFYVHsw1GXGdO85JbaICw4n7Z7GRGSTrmGS
         kYNSt4rw3/wTvZEWLTraJaxbCf29iRSbJHqsQT4aTj3xV/oUlQ9vP8a9AVjb48VAhbMh
         ZcgZtyxMv5muNhIfkxY+Lsq7/eHB+uwyXyvUB7c71ZifYM4Ju2djDnZrcYf6Dlsmehfn
         KqMGPZ1xwRNJI4WN28a1yXQ8lzDn9kT5Hi+fvZXbAA722CDvjIAsUkUhESkS5WRawMY8
         bLB+xsHCyRz3xXm3bSIDl0JvPc1z0uJapPA+V5t1uIOSZp9FQz5rH1d08R7HM1aRV6R4
         derg==
X-Gm-Message-State: AOJu0Yyty6yarKJzqHaeUfi+fnxILn8yPnBggSvnaUQpR1WPUtmnIE84
	FOgLxNlOSFVJ6aYRDg3ncPxfgRW/L/AAq7JAC/Mf+JsVWR69oiqeQS2gxBETNE/omDojwnidMxF
	xAbu8lym/ZiKnB3YxrTgEyJkMd2r1rjY=
X-Gm-Gg: AR+sD12V/OV93uvyvzMLnxB6zkQUTWoJZwFbhpoq7PYZQLJmFqwcwQ1W3YCpNwr8bRd
	TauT406HyHFmk36dj383+/KRzEvQ4IKDKN1bfWbVJ820mvH7y8BYWijMMTmbfNo2C2P/cMeqwuz
	AKgVr1VMDn6AoOkQhHJmqjYNjI/dKYtomh/VH/HJvh1R8m9LIhOqJVrGAh20vIQLYs/3t0qXjn0
	g+iqO2CNYroUOYi0llkTtT5kjdn1lclPLCclxRrSEDnWFFEo8xnKYZiKHFXPjFLqIcxG2R8tNan
	ePfYTxWLMY1hGtzuV26jz40R1EC1
X-Received: by 2002:a17:906:9c82:b0:c16:7c0:8f1f with SMTP id
 a640c23a62f3a-c16b47c8068mr990921266b.44.1784694227944; Tue, 21 Jul 2026
 21:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com> <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com>
In-Reply-To: <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Jul 2026 12:23:11 +0800
X-Gm-Features: AUfX_mxXHqOoOMloq0SuPwyanEOdzRqpoC4Ur2-xiNpv6zWScxPmjeS7-Np9S2g
Message-ID: <CAMgjq7CmQjuOgeU5XOEwA532TB0=8U2aDXBz_prKVdFY0uyxWQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E6D9A100003
X-Rspamd-Server: rspam01
X-Stat-Signature: nagpp54j41kuktkr6ggdayo3fyzqiad5
X-HE-Tag: 1784694229-616045
X-HE-Meta: U2FsdGVkX1+JiKDBzJ4ApL7RDHpPvvwn6Mi2mHaSTFr+rD3ItauNXN+Fh7QstiORZwlWw12h7Xyf0rIwkEilmnQuFRkgMe/B+VA3CDlAs/Zqx7bJB1I9P9ew1iKcHKXzpu7Mddq7SD+h/TNLCCq9BJ8ineyfoqpORBcYKCZSjYLC+G5UUAP82oo6od9yGLmmkFOcbdO9y8+u3xRCkkAo0ApCreGBRsU5Poz+E7IAGpXvZLGt4fG3IXO7burB9exUAZGw2GFnjaAS5iF2Mtb6uoroVnbIWT3aga7iHXaiGH2i8KrOLomocO2QV/y4npkryHAhmFesiwTbfHCxRWCDbsX9MlrXeEyIi9OybPqWB8BFczTTDa70hlkpBphdlGP1/0M1m4UO/W9059SZfw5y+6MizeOLc25J88d9XNX1apy/cmaJhErakm/+H7zidVKLFtqffNBcS7OJjFkpBDOWWI0dvy+JVz0KEGMGVY5r5EmP6UXpgEM9uVJxmldygIC2gOvVKPyEcY+YCni/K1O9ECGXOL4inPOKRHjH9LZPnzJDx+rOVn2WnLyzn5UkQyY5pNnmegNi6L8pqr7CIY1myIPILFIwUEp3pmKcwX8FqoeSOKpBxJJPVViq2tc2xC3pumZPUWkOva16SeP2XCvU3lXjB1g+QJCeXPhqJ2rFEJAibxg5QWttMu4+9XVv/uQVfJskSWCf+gZgFkEcwEYpLWacvM+S2oSE3v2oS0JmXlNqTl7+8U4ekAERZxGZQ0dA5omvrTvw4K03H8GJ5aMS9kxIYEtFw5I2UMqGjqJfB0C1G9qURAuJbYma4le3iCWp4EtlHBI6VQiRjDqtG17G8tUyipgIHHtRwT9Z2KLtzOWeugmtqDvK3x3uHSoG5epLgQ6gp5NR+bvgvEpQzN+L4r3ZnAlRQPFA1SclyD1wH7joYvZRjOlZvZ6qvsqhfwHQrIa6rHnlPT4rGym+NCN
 liDz9q2y
 DAdpmXdaPTsygu+tgKpy1iaf3+lLhXE3aF+Wd7sFaxqcoTgtYwkJb+ovQ39lwCfwF6bJV9Wi9OdvBrGhuNnNlsTfNg0uFhXDjQCIyrTw0ruzdcWHZgp0HuKBN/1nORboCiIUT8j5dj7UeGbpFJkrgOyOk3pfveE3QEzvfG8jc77wgUHqKUsgyCyWmBFakbhxVlepFgqrQyobns8dsPeROdpnfUo8J4l116JVwC79QhFvz3SewsBrbV9rKwtoVPEsLOh2a0NXjckE63zZodDrVhCzNzyKpjrvWulyb6Me9EUnz343aLkcHWGzXnVmQBN+9VsCJ38FY8B+xzjiIga6m5oIGtWmAkZ6K5fzU0ck82T2T5FjANTzEDNoa1lc2gLP9NKir587YpY9S1GYOB8mCjslwT6wWPwJEtJSmDUQHlvPa+U1s2xegdZ6ig2gx3S+Gj/fVvsMTUygoFg86ecfPW46utje9F2F2tYs9f/eCMrTFZGqCJ+c4KCsyldhlVnG0KSngwTOqwesG8JWuWN/t6PEFyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joanne Koong <joannelkoong@gmail.com> =E4=BA=8E 2026=E5=B9=B47=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=89 08:03=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 1, 2026 at 2:03=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > This is an RFC following the idea proposed as LSFMMBPF topic [1] this
> > year for demonstrating the design and improvements, sending it out so i=
t
> > can be discussed better before or after the event. It's stable and
> > performing well, but obviously, it's too long for review, so I plan to
> > send these out step by step if we are OK with the basic ideas here.
>
> Hi Kairui,
>
> Could you give an update on what your status and plans are for this
> series? Are you still planning to send this out in independent chunks,
> and if so, do you have a sense of the ordering you're thinking of?

Hi Joanne,

Thanks for asking!

Yes, I think I will send an update next week as a new series. There
are a few other MGLRU related things going on recently, so I spent a
little more time on swap queue (which is quite important to solve the
allocation issue for layered swap and multiple series may get blocked
by that) and other patches. While I've just setup a new test
environment and suite for better MGLRU testing on both server and
android. I'm also collecting more test cases from others, and
comparing performance against other reclaim policies like ZFS's ARC.

The code didn't change much, still appliable on 7.2, and I'm just
tuning the params in it to fit more workload better and some micro
optimization. Testing is the hardest part for this :)

Latest tree is available here:
https://github.com/ryncsn/linux/tree/b4/mglru-fg

>
> > Worth noting that the design is still not finalized yet, the tier and
> > refault calculation can still be better adjusted, and with more
> > benchmarking and testing. This is rebased on top of the current
> > mm-unstable as it is supposed to work on top of another series which is
> > currently there [4].
> >
> > With this series, I'm seeing an obviously performance gain for tests
> > like GET/SCAN with LevelDB (which is borrowed from Tal's paper [2])
> > and MongoDB with TPCC [3] or YCSB [4]:
> >
> > GET/SCAN LevelDB [2]:
> > Classical LRU: throughput_avg: 993.64 Ops/s
>
> If I'm understanding it correctly (and please correct me here if not
> :)), the changes in patch 22 ("mm/workingset: simplify and use a more
> intuitive model") for calculating the refault distance would also
> affect classical LRU - did you also see any differences in performance
> for Classical LRU before vs. after?

And I posted a similar (but less competent) result for CLRU previously:
https://lwn.net/ml/linux-kernel/20230920190244.16839-2-ryncsn@gmail.com/

Yes I did a long term test for that across a few weeks, Classical LRU
seems also worked better, however this is quite long time ago, based
on 6.9, and tested on top of that older email, so I can't guarteen how
it looks nowadays, should be fine I think:
                        Before            After
                        99b80ac45f7e      dc6364e0a90c
mysql                   7461.17 qps       7587.36 qps
(2G Mem, SSD SWAP)                        (+1.6%)
mysql                   89915.23 qps      90204.59 qps
(10G Mem, SSD SWAP)                       (+0.3%)
mysql                   66962.37 qps      67186.73 qps
(2G Mem, ZRAM SWAP)                       (+0.3%)
mysql                   94720.35 qps      95135.87 qps
(10G Mem, ZRAM SWAP)                      (+0.4%)
mysql                   100694.54 qps     101018.13 qps
(24G Mem, no SWAP)                        (+0.3%)
fio                     6707.12 iops      6769.88 iops
(16G Ramdisk, zipf:1.2)                   (+0.9%)
fio                     1784.00 iops      1786.88 iops
(16G Ramdisk, random)                     (+0.2%)
memtier                 79199.06 ops/s    79595.91 ops/s
(6G Mem, ZRAM)                            (+0.5%)
build-linux-kernel      1766.03s          1764.74s
(make -j32)                               (+0.1%)

The gain was mostly from removing the workingset_activation, but the
overhead of that function was reduced by a lot since 6.9 so nowaday
test may not see any gain.

My plan is ignore the second part (refault distance) in next update,
so it can be reviewed easier and won't effect CLRU. It contributes
little to scan resistance related jobs, none of the benchmark included
in this RFC's cover letter benefit much from it. In this RFC, the
refault distance unification is more like a demonstration that it
could work and improve working set shift or significant over commit
usage performance for MGLRU, like the file scan test in cache_ext's
test repo (result not included here, but it does performance better).

>
> > MGLRU before:  throughput_avg: 951.12 Ops/s
> > MGLRU after:   throughput_avg: 1344.72 Ops/s (+41% faster)
>
> The numbers look awesome! Do you know how much of that is attributed
> to the MGLRU-FG changes vs the refault distance improvements?

For this particular test, >90% of the performance gain is from
MGLRU-FG, the refault distance part contributes very little.

> > This series basically composed of three parts:
> >
> > 1) Make the MGLRU be frequency guided and rework MGLRU's flag format
> >    to shrink the bit usage. The format rework and MGLRU-FG design is
> >    strongly bound togther with 2) below.
>
> Could you say more about what binds the flag format rework to the
> frequency-guided changes? In my reading of it, the patches for the
> flag reformat work (encoding refs as a single int with
> PG_referenced/PG_workingset as the low bits), the addition of the new
> generic LRU-refs API, converting all workingset / referenced flag
> users to this new API, and then deleting the
> PG_referenced/PG_workingset page flags seem all valuable and
> non-controversial on their own. Would it be feasible to have this
> first as its own standalone series, with the patches that change
> reclaim behavior (MGLRU-FG, refault distance) separated out into
> follow-on series?

Yes, exactly. I will drop the flags unification part first, it's not
mandatory, just to show we will be able to redefine the flags and make
MGLRU-FG's refs tracking calculations much simpler. Without that, many
strange bit shift is needed for every MGLRU-FG refs operation, but it
actually won't hurt anything (just extra 5 - 10 CPU cycles per
operation maybe), and the flag format looks a bit ugly.

