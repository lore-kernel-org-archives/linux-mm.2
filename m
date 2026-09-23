Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAB6C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D5A6B00AB; Wed, 23 Sep 2026 06:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975726B00AC; Wed, 23 Sep 2026 06:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8152F6B00AD; Wed, 23 Sep 2026 06:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 595826B00AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE1BB1606E9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:32 +0000 (UTC)
X-FDA: 85244620104.05.B39585B
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC4844000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GX2In+zD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790158530;
	b=NMITvyFqvBXhuQ+PlS3+p5svi7vfiVm4w7W3f94T1DDbmSkDRtn2JlYpMPDO1A2LwudXQl
	ZTIRK9ovUp34WCQseU7Qy4dH2EjnPtXzaoz2b3oG+TknSQ3Oxh9zETnPbK66J/YTfgM2mo
	Yr56YVtc+vL8hw1Yk3eBfpsmB6JgNPw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GX2In+zD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvjRsKuG4XK8dy8/ip76T2dDftOg0LvGvvMlM7k4+Go=;
	b=SBZRv9tnB4n6YVgYOT1wPlcXO+6qmwR/ktWyGL13hdqdb/s0X4sLAnXdqa/HhNRnkoz7r1
	fa2R0Sko0hqx/6etHLzwjqKaFYZcvzkkyeVz6fmj8y9XabrtmwQroISGwBCncz+P2JRyDG
	maC4sn7aAtvb1veLBXp9Ax2EFdubD6o=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55efebso107870666b.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790158529; cv=none;
        d=google.com; s=arc-20260327;
        b=nutYQCNn0s9u7rsjMHFJxXlNb2qqcXXJltqWJn8qrUjal9bDZ3TxzJe2ttABaJbpkH
         mckMgHBhggM6OSCw8uW0rGvCZDf7/hb6ynO+TCnmLPDkC8gvG2a+1n9UUxCmCqQdmF8v
         a++42+mJyo1GXMkyDR1SbkyhfwiDJHYzdg/RcUCbCPxFX4fZ4LhKJ3XLJDAy8nGomsdN
         8rwFxd0A4J1cbsIXtv/ykZaE3cr1D/RZV60anEMzrfJmhBjpp6IiuLsXDn968byXJqUK
         GT2uR+m3NNGLWFbj8HWfc+Tt6Tkn5eo+rsG1Q26En3zDyuxtbdLJmSQlfENF0W7ljArl
         daTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yvjRsKuG4XK8dy8/ip76T2dDftOg0LvGvvMlM7k4+Go=;
        fh=1PIocPM1gKsdVWZB15+RRn8k5e1otkYXdM9s0834NnE=;
        b=CTHqqDGjqOWrGR5HLI0/PUlsqZ7nSr9daZjsZ9pdz4+PzxWmvSJXYROFYkAgxbUerf
         MvJ8z+rTi7oducBoZXWqcD5KyU0p9g2RIszwYRDM94CCKC/b0tMT2FyG3ESo/L1QYj9A
         9xnr2TES1j8UybyK/3MB/gdQTNHyCN1RG9Xdo7uxAvodZwZihyXxofLW0gOpR2R4w3JE
         Kc7FAQCGgr9vyH4xTfmpc8NpihKId5BnwXRFKbU+CGtJbbCxpNAY9vtjgdrm6z6rXBXe
         QLrVwViyW0SQpb/geFbWyJEPf6630g97vs/v1rg3K/tIl5zz6WFHDi2EdLa0qCbUOHt9
         vEGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790158529; x=1790763329; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yvjRsKuG4XK8dy8/ip76T2dDftOg0LvGvvMlM7k4+Go=;
        b=GX2In+zDEOYq1utjnmu7yLzPErBPZSCeE5QZQlNoTYuQ9H71R5n9zX+UTXvjS1gv6h
         /vBjgnuWJt2MSM0Zd5ofZ/y9widvgrD9fN34JxVW1iTrL1Fh2rNy+xLUsJ7JHw3GNCE5
         FSYh6zFCkWRaRlJqckCEzTWKPfwK4OsH+/ePjU8SJIuzI0HZOAy+4WJ5CO3vxZOBzu+z
         /2pwMt8CJgfkwLh1K5vAkpUf+t/LWrZvKni9LgRVtTUcpGhPJh6THdgSHbZaayEXz7lS
         UAeu3DEJCfQ5mH5OkSfCJHoOge0bLqz1qbBM5RZAIEngd/bWcvb+riGd3/gmiIomfAUo
         T2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158529; x=1790763329;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yvjRsKuG4XK8dy8/ip76T2dDftOg0LvGvvMlM7k4+Go=;
        b=K1QQLhXpKMWKJUNcCtC3XPWrr82BSZh4SERSLuEqiRNB+ThOP8rGjTdqE5uTlChA/Y
         H+sp9f/Igb0l5myKHRf2E1jL0lqMgULLNeubVWS5iUmm6y4C5wVbXlnzOnGPyj4iCWTV
         ht22Opol2cKa1mZNpXStu6/nd7uET0CfyA+lusFPNzkOu5FVz+njyQnVpsbP9SSNQ9fC
         NmxPpZLcEepcPDVz/tPgZi7lDb1Kpd/Ymt7WB+5W3sGTfHgKVUmdqe56d8pBLyFZ50eF
         crSTN5b8+zJCXtuadt7rugjsMvTezYJt+zolCviC7XczOkbiKZuzfKFwOubse9Hi80a5
         1W7w==
X-Forwarded-Encrypted: i=1; AKwUvBxcxdXgvC5BNxvCIxvXotaFhxbydCL5DhvLGRwOzbUfysEPObLQdyNWYi7k6CUF8syfv03Uxe3ZIg==@kvack.org
X-Gm-Message-State: AFuF++kFIBwgAKfqPL28Q3j0Iq0wqlZcNkndZpOhWbBm2axK1OEs0Rjk
	BfqKDbBVFzd5pVxLTUlRtPpcrkK4PUAPfSKCN2GL4T4Z2E67pvpqvPeWzQ3MpiUheNR1YuiPppt
	+aEXv0hKdTHy/CtYOErwUODzr2CwYgJg=
X-Gm-Gg: AYBFou0GWLYHZcdSyojAa3gzhBuu+lNO3PgGsgx2CgMnwmOXZ6Rp37dx5c5gXwaXzc4
	lf60S++LkGg9Ln3mHXN1Plci2dfUMUM8ovz1NUXI4lpDn+plZqHdR6jcEkaQMbo95qnwIkufwro
	4jQh/cCtPwX8UhjlSn+yK+4aZUOSKclcBY/JVr99qJdVWw2KRjFq+dVsU0IIbaiokFnKnGFMK43
	F4tpU1EG3mF4Db+NJhz8MfgkaOKVgEg6h1pxa5QCU79XLhy0pwr+XxVi342NMNLuCubw7ltsiGc
	HnvPwEAvDe4pHOLEtZa5zH2K/phaoo9jkbR9igCNiSWXnSlfPQjUlu7dmTit9v1+ut8zQJ4avXn
	ByLcOkdeI/Bh79jpu5Rw6KAWGNGlFS8cjaA==
X-Received: by 2002:a17:907:94d1:b0:c21:8a0f:56dc with SMTP id
 a640c23a62f3a-c2aadcf59aemr168360266b.4.1790158529011; Wed, 23 Sep 2026
 03:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org> <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
 <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org> <CAMgjq7DeYsJxG_VCf2KnViV5nd10m-PPYzXRD1fi8QcGWwD0qw@mail.gmail.com>
 <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org>
In-Reply-To: <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 23 Sep 2026 12:14:52 +0200
X-Gm-Features: AclHuK9mlyEK5KGjeb15PtrjRxgURBtxvyOWmKCdZfKnXFM1uVa_RwiaKUn-CGI
Message-ID: <CAMgjq7CLGyLHi7Lb8WF_m9bWUHpMRp_uDrqYNRQsH2GkuVQ=Ng@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: rkibkui7c7i943d17y37bz3r9puii4o5
X-Rspam-User: 
X-Rspamd-Queue-Id: DC4844000A
X-HE-Tag: 1790158530-981643
X-HE-Meta: U2FsdGVkX19rYgg3kDJ73Vpd/z4WSvrQgnPImSUg7MJLmZvD9wWRbX5Jvs1aszeRPsQFMO2SeuyItSJUR6cBBGhkOMIZgab2JGTIKOXL6+Uz7+pBf7VRIy9220Jah7+E6KZuAYOpkcn5J7zdFpy+cPpHR9CNa6k2LRYNNYE78geYjSmywSVOPpSDR9hq1c+sin73hHSUYTy8dUKaIzXgqOMutV3vJ4LKHaINEhi72rG+qY86lxKKZcBzCirlyxx8SHHyFOQiJnvvIJnf8qzfApAu+kpyFRyyiOrzKdkhcy7VQwwRE9cj8yiYx1LizfY0CWCCuHBNTrKEwBjGzhKWodlLii0842BsrpLdHQL2uQiFL07N8V9BySh4ELkmSffDoU3PDXMPFd3mAXN1JBnyaiXNtiqif9U2wAOroUYPqAWvoJUqUp5nWxtCfAjq85h1786TNeZzCnkaP20epRZn/iBPQJoZqwYqtIGxcbBu/vX+TReZrhp9Joq0s6VhNiibruxv9GjidWCzilDji4zoBqNuNJNi1ll9Xt40SQRusPUCUTVsX+ZqbPcdAIMTHR66p0JRedW7NVyKoY2sGEtBOYYYQqgVomF5bJyWeDw+oknnYzEbigFSVGMNg+NsJF8IYl3DOzQGe8PTWj9FqkfHn4baXxQjx5/QX+FpTsdEZCbKRwHWRBD7rX2jK77GCPL5Tgfzsi9Af/+g8EZnb4j0aLm4sZR+9jzF4wqp1G6qdgES4sIiOrjhRc123QxVxVkS1tUAEagiR/DpPpzqFHSg8IKw6LZ5klnwPEvhSNXaX5Tmg+ohSPyPGlDlOXluxI9j5dVyl9XI7ZPHC46e2Ldg/TxAn/z9f7UzpigEPDnSfBZ7woWRARYxnP/vtxg/xnFANY5WMI45d3Vij6xsF4XUeDxiPphs5jCnSuZStrJBlz5MJOtXBe9dtBVI6DdfHRGbR2+MszzkdVE7tOB9Ztf
 ZQlIBF+u
 8vP9JB8KjRj5mJvppLJfAPQeid8CX5Fqa/IFyQ+SJe5iJpOYsAoXbNU2LDU0Vluqsl5pueiTixcFh36LH/Okn8+ZMVtTbZkmLeiIYACJ9YdvWNZeLDKr88mFPSqjucIl0NRbvktU7q4aGM9qWuNFkjNgwL+x3W6rqpZVbV8bFKC52N66bX8rXS4xQSo5Uk3V1o8TW9UmtJ38FWNWCxegzPndyEYi/47GE5jDcDYs9+XIMjTEzBcJ46xcOd1YnjfNjAk4mGvlf9EuwYYsJh9u+ujXlSYvWwmxOycd5ioygH/zzJ0e0VzZiABVIAFFTUja6zbky5Onx2uBIshbXQ3wbSOmImaqGoZHQxrqNa/URRbJ93hDYkFZZSD78jUqE13azt+wAPvC5BmMQAEr7zvyIc8dbwVBcjNRrYQTEWGb5mSkX+2oRBeAmzp1/Bwyp96w4PTxU58lgIv5+QI50ggjJMOYHN68aNj6l4s3gDJ0gUuXUZC5F5m1XViJ9Tlvzu3P8XJRNgpYxYK7khzO+ARKbeVsWJQNUfrayrwm1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:47=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/23/26 11:35, Kairui Song wrote:
> > On Wed, Sep 23, 2026 at 10:46=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/22/26 22:55, Barry Song wrote:
> >>> On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> I guess that's because the LRU is not always accurate. There are case=
s
> >>> where our prediction of future access patterns may be wrong, resultin=
g
> >>> in refaults?
> >
> > Hi All,
> >
> >>
> >> Right. But these would happen in both the SYNC and the ASYNC case. Whi=
ch seems
> >> to indicate that making the SYNC case behave like the ASYNC case (keep=
 in
> >> swapcache before evicting) could actually improve performance?
> >>
> >> Or is the SYNC case in general so fast that it is not a problem and th=
e
> >> swapcache is just not a good use?
> >
> > I think the problem is not LRU being inaccurate, but ASYNC case could
> > overshoot the anon reclaim very easily. File folios can be simply
> > dropped, and increase nr_reclaimed, but anon writeback (swap) can't be
> > done durig the reclaim iteration so nr_reclaimed never increase during
> > the scan iteration. So the scan tries hard to scan and reclaim more
> > anon folios, more than it really needed.
> >
> > I think the real fix is some kind of different watermark, throttling,
> > or a different counter to limit the scan of async swap. I mentioned
> > this at LSFMM this year but I guess I presented too much at the same
> > time so few people remembered it :D.
>
> :D
>
> >
> >>
> >>>
> >>> Even on Android, which uses zram with very fast synchronous swap-out,
> >>> I can still hit the swapcache from time to time. So perhaps with a
> >>> slower device, such as an HDD, keeping the swapcache around for longe=
r
> >>> could allow applications to hit it more often?
> >>
> >> Why is that specific for HDD? It's the exact same app behavior indepen=
dent of
> >> the underlying swap technology.
> >
> > If you have a shared folio, you must use swap cache, and even for
> > single used folios swap cache is the way to do synchronization,
> > regardless of the device.
> >
> >>>
> >>> I don't know. Maybe Alexandre can share more details about this
> >>> benchmark. I'm also a little surprised by the 15% regression in
> >>> Sysbench OLTP. My initial feeling was the same as yours: we should
> >>> release the memory immediately after writeback completes, for both
> >>> synchronous and asynchronous I/O.
> >>
> >> Right. And see if we can identify why we are swapping out the wrong th=
ings :)
> >
> > I think we are not? It's about over-reclaim. In the worst case we
> > might put every anon folio under writeback, while no folio is
> > reclaimed, if the device is super slow.
> Ah, that hints at the real problem then? How confident are we that that's=
 what's
> happening?

Given the fact that ZRAM/ZSWAP doesn't suffer from this, I think this
is the cause: the main difference is that ZRAM/ZSWAP frees the folios
after pageout() so nr_reclaimed is increased (reclaim loop just keeps
comparing nr_reclaimed to nr_to_reclaim), other swap devices keep the
folios under writeback, and continue reclaiming unless they hit enough
clean folios to drop.

I can't say I'm 100% sure, and it's hard to verify but I think we need
to try fixing this instead. It's not hard to construct a case where
all anon folios are put under writeback due to very slight pressure,
e.g. a dm-delay (e.g. 500ms?), 1G anon in one memcg, very slight
memorey pressure could easily put nearly all anon folios under
writeback.

