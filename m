Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B023C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1EE6B009D; Tue,  7 Jul 2026 17:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2296B00A0; Tue,  7 Jul 2026 17:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791AB6B00A1; Tue,  7 Jul 2026 17:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4714F6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:50:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD69BA0377
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:50:13 +0000 (UTC)
X-FDA: 84963324306.18.FB9471D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D56731A0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:50:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cvWZxz25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783461011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Hslq07Rv05EgItP7vGw5o1P7WVmqMuQLrNi01fX+zY=;
	b=YaZ1tPTHCTocc1HrVIp3dz+2HxlK2/n9mcc8svsFFSQpmBobE6WBLGAXZdHtax0xfPQkMJ
	HYM5NdMGqZTL7Hb0NuyDtjJX9Ke8Ntr6iUzA8b1gX0da/A4eivEIeizwgL0TSPkJsWv/uw
	MT1wXbnq4ZSvE3zmuEDOu8KogTQwTsI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cvWZxz25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783461011;
	b=SNpZ2Bv2857WSxUagHEkwRBLigrZTPAxReUuKzKTvImIXxK8axwMd6Jo14pC8m2K7XTUDl
	fspWodziyv5eSYkD5pMLnccardT5ElozmNzveAXg5TXhMtpHaW1I7xR75XfpJdf8hNqetX
	192+pC+MzHG6awmDcBntt4qj02YeBik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 045EE43660
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1C01F00A3D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783461010;
	bh=/Hslq07Rv05EgItP7vGw5o1P7WVmqMuQLrNi01fX+zY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cvWZxz2565zWFGDjwgAkiyAviNnyNRiGshTFpXv86sWkklnjmiS896UhFPrfrG1DR
	 YPWmqeLhkOuDPmmlyzRTzG+NQmS6TSjoOQFFPxgLa+HOfjqX6kb0darkvfsa+483nL
	 J+/Sa3KDr4IY3MTaJVxsdqstlTNIQR43nA+PI+LsB6xmBRFUiNc49kqMAeh4H0qn4D
	 Am5wh9jeHAY76bzJRY+dORT/dy306Z0fIOvtKmJQ68Ml/+5DZ1c6b1z50YTIOZmBep
	 eYR0Iz6w7WEOv9ghCfTXcllrxPCoNlnjNt4x3OEnRCnOauTNW49vGucHECFdweK3rM
	 cSfmpYOgLEeAw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69a50189d25so44509a12.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:50:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrekVMFu9wtViCfNzIzAhOW12VnhveBochbizNqLwYzZ4uRAbIjXCKG2TwdLg10C4eXCwBk9Jlu8Q==@kvack.org
X-Gm-Message-State: AOJu0YwGjUEjsFFrg8sEz9osQUgvS4bim3LoCQTKknolQfgdbiGcBY80
	BvgSIkiMG8a6micI01lbouwWJ2yLboTmYjUaochv29/dO5DJUyxOTDsZom/fnW0ea1v4v3pVuUk
	hguA0uQ0bILiqKk22rJscpg+Driw5ERo=
X-Received: by 2002:a17:907:9811:b0:c12:58ac:9869 with SMTP id
 a640c23a62f3a-c15a66b3229mr385276966b.9.1783461009836; Tue, 07 Jul 2026
 14:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com> <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
In-Reply-To: <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 14:49:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
X-Gm-Features: AVVi8CdZcEOfGuDZGNSV0M6zgE9Yv3CDLB_P91llgHInNN2rTx5aaFTXo4dLKK0
Message-ID: <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5i4mdajjw4rb83kc68m9zig13coimcqa
X-Rspamd-Queue-Id: D56731A0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783461011-101727
X-HE-Meta: U2FsdGVkX18KaCRm03wo00df9rjMWZxJJx2dTviopIxgXn8V0F3EpnuX1eQDyR+d21z/DgsIHcwfoS+Iukr4i+x287qMlcOKyjJv6Af9Rk38A+ZcGh0NsTOZZq8wc7ZX4MkD2I7cz2reJ9HKd+x/VekNX/R3+NmV9tFixIRbliQ4sLX7h7fu67FyHvpdaSzTn5clg5a2j32/viCA4/lu54nhB/vxCZy4Dwr4KqI5+A1N67SKcwp8SjqJmYu+mqbIjtRGrXq/JvbHDhcukfoLQDjGxIt0MRNk6O0qfRyBQUyveDajCjkVyJ1ZvlaSuHFh/osv2t8XJcaD05FTZ5nM3fzIqbptwtNOVDtlpjfPluG//eR5ZNkYVgEoyBuOh4B+HQn+dMOzzPnSBC+xxAMq/17gnB82zYlb4UmwYwK3fJ+UyAOzmIz7gCAwQBVqOZZHBL0DBCPP22E5nhCt78WrI/kx4897+Kfb2UVDP4pEvO854Ao8WminC7begqIvyvwngtOY+ulBRCX7zQwMYaz2ydZOriM90FCexL3rzHrUBmqg8HZCjwJz4/8z6Zjc+c5b/HfpJ7IRe9fs09wsdo0S/hiiKteIIP3fi66k4aco2JTW1BlLc1NxIVuakYkRn5Y6nD9tjChO7UTsdRzu5Apk7cK63qk336JWsPKBXrkOLZX6lDjpAlTLOJduimKwU7muU82EyYYxsFN3LlZuzWjLXnMDe4c/7WRwXOJGMSMgf5DwtQyM5dzfCIh7mtJxYRixlu2i5QhAA5HBiL2+bVDxqEsU+SDDbYnY3xis07RhVtBFF61rp975pBfSMqAwSGmlynbO9aesO+sjN/XCUEDarwluRR6XzwWEQHWSbTApl2FsOef5NdlSkKry/ZKRm+QCqLifjb7eIUkxXdN58sATdMAUlkmaGM3HjAFDPzUisYut38/e5yGmqZ3uAW5y7eNyidaWkY8grY04iV6VaE1
 kdFMDe+M
 JfwKMTS2dNxfqArlgZuEq4tsE4xfJgCS7F/Anf617R7AoLUDl6sR7rwdtH/yzAi/Obgcp7tOtErKELGNs5u//CNmdJNux1N+dms+zlqEoq98ZeQnVR3Xd1V9fABb0QzmHRpI5JQ1IOTUrcN/Lx6hOkntoAvU7bjaL6jMRx4V1mKKLvvgxT/VvymJmgMy8dILbDGZ92Amy4RYyiY5LVnSJs+hKPsiVBHVf/gSxYVBbcZgW6HzMEjxH9jYqBeVE1JNA0KFCTMdvtYwUE6oMZVdl6ugvlz1S2/rfXXgzq58gQK3knlPeAwkOWbmNW7emgHs1EWIA8is40VOKDkekPNRsG1ZSfJksTVoei4eMa3zse51yAzLCkdzIgNYh0mmOX3R+397w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 2:47=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jul 7, 2026 at 2:36=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux=
.dev> wrote:
> > > >
> > > > We were discussing a way for userspace to explicitly trigger a flus=
h
> > > > before, which would come in handy for testing. However, we decided =
not
> > > > to expose flushing as a concept to userspace.
> > > >
> > > > Unfortunately I think the only way to "fix" the test is to allocate
> > > > more memory, enough to trigger a flush on most interesting setups.
> > > > Perhaps we should scale the amount of memory with the number of CPU=
s
> > > > so that we don't have to keep playing whack-a-mole.
> > >
> > > I don't have a good idea for writeback, but for zswap out, would
> > > MADV_PAGEOUT work here?
> >
> > I don't think the reclaim mechanism is the problem, but the fact that
> > we don't have enough pending updates to flush the stats. Am I missing
> > something?
>
> Ah yeah, you're right. Hmmm.
>
> Yeah it sucks, but maybe sleeping (more than the flush period) before
> read is the only way. Which
> is terribly implementation-dependent :(

I would honestly rather use more memory. I think there might be cases
where the flusher is delayed. The flush being slightly delayed is not
technically a bug that we want to see a failure for, but if a large
stats change is not visible that's a user-noticeable behavior that we
want a failure for.

WDYT?

