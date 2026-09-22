Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F381C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE916B009F; Tue, 22 Sep 2026 06:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186786B00A0; Tue, 22 Sep 2026 06:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C74E6B00A1; Tue, 22 Sep 2026 06:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB2C76B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:37:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB49D16044A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:37:54 +0000 (UTC)
X-FDA: 85241047668.06.FDECF6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E26AE16000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:37:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Px4tA+AE;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790073473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JSFfIOR2fYyMqbn60xzTN3TiCBndTmuqv+8JkopuP0=;
	b=rJ/8TgKCZDwZ5xlLKhTDzfrIs1XTHCz93rMxJlm5vrpMDGcw8wYHOO9jTGz1HqhaAqP2cP
	A+y2Y2RIzxaWT7wYJrQKLxy+H2KbyL0NPe/KHlvqY9He//Db6+xHq3088pDdn6XVU5HIUa
	rMaQ037PEDdCEDPkKtjVOIXkzB0ZPgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790073473;
	b=zDr6GPcZiJDjzUljVmwIRfB4yVKrt2peimcBM2hMJ6fQ1o/Ms86squnTbu9QOs5XJl7L51
	Vr6l5lqGrv6GaDimFQ+JQXX8Hb7BAhDKAUMB0U4o0yH3xsFZGxgy/amPmnkbY1/h2bV3Qo
	92R2VFGAgNZcv8OftmQ2jZFowQdvTCo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Px4tA+AE;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14715448D4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF8D1F0089B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790073472;
	bh=8JSFfIOR2fYyMqbn60xzTN3TiCBndTmuqv+8JkopuP0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Px4tA+AEtypPbTbUuW1YA+jZqU6HHzwhJKhu+nzAhGFxVn6fLIdlFtuFwj78s+O+k
	 18hVxnKHRHMVwEZfoVJwbH54x0zVvqKApIy/c0FXYxQFltvtYSKltGATI4j0US6PR+
	 StTI9SP89oRehwuVbPoDlsEjr5iEkzSnxmPT7fU5VJRXRWEackSQK1uqsmryq3IH2Y
	 Gz/TB44ypMsBkWoMzAOG7pwFXyeseGtFGzVJERr643HkovD/hrIFYzFeC1ByhAq46R
	 kh4OLRmHO6wi0zZVEom7nu4MYCFYDMkETWpbi2yptLUlTmJ7T8AbTIduGUxzr++gtr
	 KDo15MvPUNE0A==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cc46c7so380550885a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:37:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy0y9qtsy7oxA6HpR128SvKsIL3k1Ch5A7YEH9k7rRXI4xk4dXk9z8sCG9Sk7CnOL+sWV5amHb+wQ==@kvack.org
X-Gm-Message-State: AFuF++l39Mmr7/5HQOynn8BHQ3rBOFGjGffOvOST/djIz+R4jbJHcSmJ
	dwo0zezYcaXWc57tsfWwn0Z4ONBVQnjGNvWRExN4TevEe2Eo7x2bjb5pW5H93LODSAy1rzIQO3x
	YJbHPQRbMkCCvTEOfgnK1I99usXQL/HM=
X-Received: by 2002:a05:620a:2556:b0:93b:d7a0:d9ee with SMTP id
 af79cd13be357-93c19a9683emr286636685a.72.1790073471173; Tue, 22 Sep 2026
 03:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com> <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
In-Reply-To: <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 22 Sep 2026 18:37:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
X-Gm-Features: AcwNN1UWmFBBjyVOBpgbroObIEOZiFHFaTZdwoniNhkfZtgQcsm0FIKNvDnSJaM
Message-ID: <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, willy@infradead.org, 
	jack@suse.cz, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fjwybjks3kkidk5h4of59h4sk3sh7qii
X-Rspam-User: 
X-Rspamd-Queue-Id: E26AE16000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1790073472-182820
X-HE-Meta: U2FsdGVkX1/3D5QjPTSfF/1Rtm7PHqYftp9UsHs/c8/dWeylJwaa2sd/+4R/58FPft0/pTSApmzVNFo466GRop8ECRvKJffVTJbmQiXCeUa02nk5KSQ1JZQqUEegZUxdORaLX+IGJxBT/q7CroDadYEJpbOvayRsS79aD51ZpyjFmRNmsmA7rt4txXAakGqd6IaoehAn2v+OBgjVhhLZ+rjH5HM2VIr4tySzaZSaq9G38f5MVqwy040Nmh62jFU7jYnC8ZcpfxfwZjhW99ymXp25mmu+QkSCLXjBz1m14rrz0cLuDKd8EF2P5tQMEIsDKd+dSwbxT5UtGsTCwmhn5Tf4F3Kg6AOaVGdJoxG3wFuvoq2xRBLmRrCFydr7cy7y1+Vb6N1vMPVZhJqWo/u/8VppmuRg5LDDZoBj6nLuS2D5fbdHUWPs3OTQau+9Cj5Jtrrnh5GTw8kxAXvn0jkbswmecpw2Keg4/qgE8jOa4TCgZUa3ZDTrM02Ab1gERKwetIHnCJHCAC7rA9C3o2p3SZOAzBJDmTjM9vlTLs0pFRTDkTqbvHvVnrekVsQhJMMNRRPwUPMvcmCwKnvjKAqDgmz8qfZFZDWBsBZZjvrOUe3nNW6tAiBUr0gm63ZpFgo961rwIRBqr77ec6cr3NwwMf+gMn+v287AQi7jCcfjJFApTV/+LCNJ/XpKV6fG2vIZa5+FOYdtgNtKTZHkQqOsNLCmdEvuTJhNW5STvqYv5CaaiewGYVaIM/l4e2ngTigQu+zqAHf5gGm/VEChK/ebI5Ic4GtD3Tc8lrexPf1BtU7GteZ9zQcIjF68BHgaTPtthrB48F5uqmeGlEnYs8w8dhfiqOVlRA4vQ9pMLe5ckcxlJQEYAaCwFA3vDX5kk2NirZz0aBqEmsU3lozSiIJkW3IMECRkFEAWp12V99Sevuy6rL0fp4eiDwBABDfAZsWZRkIpBCOv+F7eSHoTZpj
 6WaBafBe
 osC4JsjdXCIsxryZ0EDjr4cZoRQIElMuFoTYvNjpA5Jlkcp8KTNwgp7lI1bla5PbPxjKDLZWkVLIf6q3KDZncekrIT0BZ68e3Kyour4HMYnSMtvTKenxvut6jcX64eTcCRybggPLZEIpKJ3B7JzbUe+bJcCVSxjHHt7Q9YR7+DwmvWSgOtepSkpTb0OF+dGuNc6AoaspZGQKwUlyfIAycKKyjIR08k3OBAftAjcj+TFUa1PJmu3ZUyuZuwzq1m424l1OoxxLCicM61KX3d5yzxx4hUSCa/nM/WcGURDvWUt73TIm6SAgwIQhFOsg/tKpSKJ57pI/xtGAsP7CofdMp+RFgDwxRAzdlIjjM8Dzz8WXTY+5POe38cMeMfku9USlhf0OndbkEZuN+ss6wLCgpzU4Zd6eexcqnCkk01fIySM+2OcUUp+wCslPKXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 6:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/21/26 23:56, Barry Song wrote:
> > On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/21/26 17:24, Alexandre Ghiti wrote:
> >>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
> >>> PG_reclaim and rotates it to the tail of the inactive list once its
> >>> writeback completes, so the memory is not actually freed until a late=
r
> >>> reclaim scan removes the by then clean swap cache folio.
> >> But we have the same behavior when just reclaiming memory ordinarily? =
It's added
> >> to the swapcache and only the next scan actually frees up the memory.
> >>
> >> Wouldn't we memory we reclaim ... just gone, like in the sync case?
> >
> > For synchronous I/O, such as zswap and zram, the memory is released
> > immediately after sync I/O is done.
> >
> > For asynchronous I/O, such as NVMe, the swapcache is currently
> > expected to be rotated back to the tail of the LRU and wait for
> > another scan. Alexandre once mentioned that when he tried handling
> > async I/O the same way as sync I/O=E2=80=94releasing the memory once th=
e I/O
> > completed=E2=80=94he saw some regression. So, delaying the release unti=
l a
> > later scan may allow swapcache hits before the folios are eventually
> > reclaimed.
>
> "may", do we have any evidence that this actually is relevant in practice=
?
>
> We asked to reclaim memory. We wrote the memory out to disk. We unmapped =
it from
> the page tables. We made the workload the could, access the page immediat=
ely
> again suffer already.
>
> We should just evict them as soon as possible to free up memory.

I suggested this to Alexandre, and he found that it could regress some
workloads [1]. That is why Alexandre is only making the folios
immediately reclaimable for `MADV_PAGEOUT`.

See Alexandre's description:

"Future work
-----------
Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
prototyped dropbehind for all reclaimed swap folios and it regressed
sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
immediately turns cheap in-cache refaults into disk reads and collapses
swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_workingset
gate recovered it. MADV_PAGEOUT alone may still be worth it, since there
userspace has explicitly declared the range cold, but I have not measured
that case in isolation yet."

[1] https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti.fr/

Best Regards
Barry

