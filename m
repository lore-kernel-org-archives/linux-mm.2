Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B682CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373A76B008A; Mon, 12 Oct 2026 04:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324F26B008C; Mon, 12 Oct 2026 04:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2130D6B0092; Mon, 12 Oct 2026 04:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3E2D6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:01:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72E1C120982
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:01:26 +0000 (UTC)
X-FDA: 85313229372.02.995B363
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8630C40006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:01:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LiCoR9Kw;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791792084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFJCTOee66kxc8V6r3kv+pIOgrnSLrYGq1H3NUTohKg=;
	b=diSMSBWoUrm6VUI0/BIMOd9ecP1eIHcYSwZjUwYzvzt9fycNEj7RWOU/fYK1pTCuhwLpBm
	vZePTl0yY6xt0IjPP/E7NaB4BWh4oGr40aHXyC+OknuaizYl7+9RfUmYj+RpNMj3b9SNeQ
	xpaY3TRxIaBd0BFO7wJezE8MCrQqKv4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LiCoR9Kw;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791792084;
	b=bohqirQSPc22uzcJvjUYRT3gAlRgtUjvYisied6lWq1wejov+hF/tudIJ8gRN93wqfFxyW
	X7CStY/7n++q6zvuzH9bEfmv/eIsSGbv7LaAqGIP2F91+2KNMURQOzO6EaFbnF89d1mCDr
	HBFozL3mFQ0i6B18R23VxwdFCuSaSOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5802F44855
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339111F0089C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791792083;
	bh=VFJCTOee66kxc8V6r3kv+pIOgrnSLrYGq1H3NUTohKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LiCoR9KwQklxGnaAd7874H4CHvE1PZVseMsln2OtO9mI46DAXRvjOBJfebS9dUz+r
	 jzNk8f7IFnVlQzGA5WvcpoR7FBjn/KUIleYP0UuD/c/Pbu5uCdVDvdYKiHbBmXEukO
	 i6j4cyRWy3EnThhhH/idFsTC7eXlXhP7DSqqENIubppmTxhPOanKOAgASMVN8/htR5
	 o9z8jpoyoPZJjo0S21ZUlPW65ddTVsm1d/l/NJHx0vJN1TCsytw2G6pM7/ekjnCpWK
	 l2KR6lg2vFszJRyE3ZRO4rCaORtn2UPSomDS0JzIkMVlXdI4F0Dn0EXqIfhl4Qz0uk
	 cJNZWLrroI0TQ==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e762768f3so215228385a.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 01:01:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxB4C2uOExYyAHLFL4ZJmmErzDjiE2wbgyWgjCI26mIvpIeB/4j4R7kesrAvTYT59ULcbmMoDMpYg==@kvack.org
X-Gm-Message-State: AFq9FYJRdcKabKnuqQIquD/zwUOkFv4Gky2H1XHX7bdd6Xe6dcG5Zm+p
	ztJbGSANxfpZmtBiQ0wLSCHVtLnjlQNMOkt8AbKzlvp1/dSJRlx9b9n5T5K7+OirSF3cYJelX5T
	M5l7m0e8UhM6BgyURg13AoHWA94wjF6Y=
X-Received: by 2002:a05:620a:271c:b0:93e:942f:b8a5 with SMTP id
 af79cd13be357-93ebd20ede1mr1614851285a.14.1791792082466; Mon, 12 Oct 2026
 01:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
 <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com> <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com>
In-Reply-To: <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 16:01:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com>
X-Gm-Features: AclHuK8IOexl_8V3bBRbq6TRfOHJmNLkbnQq5h2MM7v35kR54WFVJ9QbpGusTiw
Message-ID: <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	yosry@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8630C40006
X-Rspam-User: 
X-Stat-Signature: r9qk1mx1kckbagtokypriysgwo39aw3q
X-HE-Tag: 1791792084-744922
X-HE-Meta: U2FsdGVkX18yQIBbyBq5uLGXW/OSKqKZ5SSN8o/oClBl/+9QoTNx8FAyvIrALNEWs/AY2v8AwtMevsAezG1ORF7MBPABGh02y4TlYK9M0hwmfEOUXtKyHWr0PDtiPcj1O7ZxTP5jfHhSTu51jNDAEpzEXA0N2mLQx4JfxjQ8zGUQsWL7e4xv1sb592uLVJ9jvsjWHYniyLf5pk3AYwpeOv9TwvQyQJi0zkQRbjLcE/McFpsnQG4L17aXJ3daEbJMimb3AEifBMaVOJl1FrlzPWhMHuYr5FoeCFy/QpJE34/iU1hl7WhwFVqJhAJbA4ySwcHdgQmERLt4P1ZQtWuQPX/7DWMwH9arsfAIcvsvFySvea0G6YIc1GPt3L2Bn36BPmOIGsc+fPX1/peEofqJhzsauvTrLnT0lhbX/HutyTBd3+X0QVtCrS2o1FJOTTfGM2t8BoGdyBVe1PHfC622tF9FfkBR7f0ylKde8A6Hl0/F6pnwDz/q6gsE0GkzVYeM1v/aPVSE4Aqy+XHr6dJuX1SqHasQmT0Xu1vU3yVtsPB99s5XjoeZV98td8zDgvL0dp850B9s2T5AqDVc3jxwcnFiHAvsh9aXPC4BLVfQZgSd1JZuGwjA6L4Axr/bH84JCIAJk7AdRAYwXBSXuW9JfVaPAa9sIO3KyIoQoVISa67VVAgBaJgwSGg0lD3ILYfrcVzuqezyANmdVvYtcXeDQnoCl+TcXhUutjxWHuBs8VDZTNv5ZowhTxfdiC8LIOfa9ipCD9vzhBW3x58YF3tKgP9K0LnnfG9PW9r2Kb211rtlLm68ojMJ0RBnoIUlX8zAu6L5ivadaJogjjLt884ci/IKqyNgyQXYsi0WRCJA866AtTCC8UR4qyN5n0qLgwN2EDEKThtCPVW0JnJly3MGHPrEkJzSuMy5kiM0XpS0NeUtZSsthTGzWld8ezJGeHx9vqom9juLnowgzHK+yMz
 8CiULB6q
 xf0pzuhp9bShdgEaHyc8NKb99XUapBVBZGyPGW6DRSryPUEwklRhf15ll+vvjRTTE8LyHZmtGsbsSqQu4ofx6fPlPa++81yVT/9DL8P71I9hsZNpVhBN9H+MR4XwDwu0PQ27tcGSZGiEW3nUa7zbVMEHEzGzEPK2RKC26kfaHnz0BD6budeXP5qDHpUAEB+hCYq+ZiaENbr8Xn7YynY7AZkDxTVSS6Cb7Ryk6i2PnUrT9Vyde6zjrOiiHN0P9P4VMmaF6CbxyK85Aeu6bYXwuRpkL/k2oaxQWxCkmkXKCZTCHbq+RUo8S9laszUpf2m0rS8JmU7iWO5q2uLtE7oOYfrni/T3kLqPvSNC1m5o+ql9exTIK1rBLs6SvSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 2:59=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.com=
> wrote:
>
> Hi Barry,
>
> On Fri, Oct 9, 2026 at 8:22=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.co=
m> wrote:
> >
> > Hi Barry,
> >
> >
> > On Wed, Oct 7, 2026 at 11:05=E2=80=AFPM Barry Song <baohua@kernel.org> =
wrote:
> > >
> > > > >
> > > On Wed, Oct 7, 2026 at 11:39=E2=80=AFPM Alexandre Ghiti <alex@ghiti.f=
r> wrote:
> > > >
> > > > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchr=
onous
> > > > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap read=
ahead.
> > > >
> > > > zswap is the same kind of in-memory, synchronous backend as zram, n=
ot a
> > > > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > > > swapin_readahead().
> > > >
> > > > Here are the results from bypassing readahead for zswap too: it was
> > > > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, =
shrinker
> > > > off, on Sapphire Rapids and 3 iterations.
> > > >
> > > >   768M memcg (sustained swap thrash):
> > > >     metric                 mm-new    + bypass    delta
> > > >     build time (s)          405.0       341.7    -15.6%
> > > >     zswap-in (GB)            79.5        53.0     -33%
> > > >     zswap-out (GB)          144.8       115.6     -20%
> > > >     swap readahead (pages)  6.79M       0.45M     -93%
> > > >     swap_ra hit (%)          72.1        89.9     +18pp
> > > >
> > > >   1G memcg (light pressure, build not memory-bound):
> > > >     metric                 mm-new    + bypass    delta
> > > >     build time (s)          177.7       176.0    ~same (no regressi=
on)
> > > >     zswap-in (GB)            10.2         7.5     -26%
> > > >     zswap-out (GB)           27.7        25.1      -9%
> > > >     swap readahead (pages)  1.07M       0.08M     -93%
> > > >     swap_ra hit (%)          68.6        87.2     +19pp
> > >
> > > Hi Alexandre,
> > >
> > > I assume your configuration is as below?
> > >
> > > / # cat /proc/sys/vm/page-cluster
> > > 3
> > > / # cat /sys/kernel/mm/swap/vma_ra_enabled
> > > true
> >
> > Yes
> >
> > >
> > > I am curious whether setting `/proc/sys/vm/page-cluster` to either 0
> > > or 1 would result in the same performance gain on a zswap-enabled
> > > system?
> >
> > I'll test and report back here.
>
> So I ran the same workload (kbuild -j16, 768M memcg, zswap only, n=3D3 pe=
r arm):
>
>     768M memcg (sustained swap thrash):
>       metric                                        mm-new
> page-cluster=3D1    page-cluster=3D0    + bypass
>       build time (s)                               530.0      462.0
> -12.8%      452.3  -14.7%    452.7  -14.6%
>       zswap-in (GB)                               95.7        66.7
> -30%         64.2    -33%     64.4    -33%
>       zswap-out (GB)                           169.3      138.3
> -18%       135.2    -20%    135.6    -20%
>       swap readahead (pages)            8.37M     1.93M    -77%
>   0      -100%    0.53M    -94%
>       swap_ra hit (%)                            73.6        86.5
> +13pp          -          -          90.7   +17pp
>
> Exact same results with page-cluster to 0, so I'll add that to the
> changelog as you suggested.

Thanks! This seems to be a strong indication that setting
`page-cluster =3D 0` can also resolve your problem, even without your
patch. :-)

But I'm still glad to see your auto-tuning patch!

Best Regards
Barry

