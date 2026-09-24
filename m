Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C141BC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 04:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1006B0095; Thu, 24 Sep 2026 00:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852836B0096; Thu, 24 Sep 2026 00:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A8B6B0098; Thu, 24 Sep 2026 00:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3586B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:07:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3BBDC0205
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:07:46 +0000 (UTC)
X-FDA: 85247322132.09.A070F8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D7DF71A0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:07:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+eQpLFa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790222865;
	b=rlgpcp+gJaAwynbfyIekeTBncBmih2LBr+rCACRFxvb5+HlnwWU+ZK1zt0wX0OoMcxN+60
	bkNfu5WwKeNxiIXZgA5Vqg3Q8M67Z27I4+4GTsahH0YzgC9ye3T7H13LviKNCwmRycuHqS
	9lGuptNJC7j24a42JxZy3klXPUOAVLg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+eQpLFa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790222865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlxzHAl4jd2Dy0VVw5bc0eae7SydK76Gy5QsoWtTugw=;
	b=xejyz0sDcQGthD23x2uVIUlJ99vY/bZYlQxsOFzYjs3fCJkRlp0zoMc+xm73gffh7CAr6r
	H0xZ50zo+V9n9MrseguOk3K5sdX0jtxRJGeDPQ7mQcn6Dye3ePkgobSJ4ps1kDpn+2NQIe
	S9D8jVKyZAygIs2YI+idQd0VgtW9Ye0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B628843751
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0571F00893
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790222863;
	bh=wlxzHAl4jd2Dy0VVw5bc0eae7SydK76Gy5QsoWtTugw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W+eQpLFaM2rcqsBrwxptT+1AE4q8ovSwO3chFMk819v3awDKts+y5Vk6cayF3ClxE
	 Fl5WCojNXMrnxkT4G+aF96bfpimhq6BS3ZvRyNDiIFIlXxQvSXF8INmmLoc+yvkKC6
	 NLx9Q6TnmT5AIco6f2+k549wDAisZdSuDL54+mE/2ctC7zPDHPJrAdVLnnTZ43sgGC
	 XrZQ9MliKDafN8cVGbCYAtNdWJhwGnTqNQOU8jbiieEIHq45AYa9Jp3tzr9Nhn6tC5
	 +B5kJ6gY0a+Qmk1rHyGpvh5fcc8iIMUwF7ja9OFZb1D34FQi7KYflEF0xFN4XYIm9g
	 bO6pNhB4cMVFw==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cadea0so96031085a.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:07:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzRNRMz9pGyBeDyQTjZ82cF8Pw+Y9GRA/Wu0UR9+/LvCGC45ix5ZRFjZh2LOz5wyG6y9FpDO1NwYQ==@kvack.org
X-Gm-Message-State: AFuF++k+/LprTP5Pio2WLqKD2m4LD1gQZHFk54a3qwGp5JEWjxWpfCon
	0RumVuuec0uyB/b6tT0uoDkAupA/jvDKtcs+GMGI8/If9EaUpG/vzCWdpSWtDdzUsU0FQxI2+7j
	piQPfmq9rmcdiWG7uZWAtq3MGi60ilS8=
X-Received: by 2002:a05:620a:178a:b0:93b:6113:21c with SMTP id
 af79cd13be357-93c3625bfedmr121073085a.10.1790222862939; Wed, 23 Sep 2026
 21:07:42 -0700 (PDT)
MIME-Version: 1.0
References: <apcVhWzEwkwHYjB1@KASONG-MC4> <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 24 Sep 2026 12:07:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
X-Gm-Features: AclHuK_Oo5VaIVxMohMOcnCcWX2KkBDujM8Sp4JE6sgnmpi0H7GmNxPODugX6SA
Message-ID: <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: "ryncsn@gmail.com" <ryncsn@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"weixugc@google.com" <weixugc@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"yuzhao@google.com" <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 19becgh381by1xktxptcee8bmex6oszu
X-Rspam-User: 
X-Rspamd-Queue-Id: D7DF71A0002
X-HE-Tag: 1790222864-802193
X-HE-Meta: U2FsdGVkX19IwW9RdjlU5B2Ukkhf9eNiHDOpkYgX2YL6wvUMcParV4W4oKdQeOTphD4iIMmixKxCaVS0zEmSwSRGETzsGRcWeWVlBhQTg+u+ww7UWY6CiSW30oNmLDdUiRxFx6FYlX1Z3hdwMgX1fUtZMo1Y6xEty6srB/Mj7AQDJgfdElXZuU3UwFKfIBj3KF2WWwshbqrbHv1OHocu2aAP+Wxkt78xFp5xXPmpOt5SOqYVZbHFZqerdmnIeWwrirFSBE0ewaZliplGNgX0DJ9l6ym50obTmeAjFzGql9CHarCzwG7Dr6CYDeVdu/hsv537lqRRyZoB1vnVivL/Mcatb73uOEdygak3tJQM85pETfR+XR4dJJM3zmyDOQmSEaPG2Sfl3ohBM7HXPcggjxgtTTmaefxrkHa8xPYKSVJzkAghQtUAOXxPyWkc/sEbegKpBTkHCpehb1DZLETxHFERsio/J22yn2pPccxPDMa+Yr2FdiRuUE4OG6G54Fnb6h67xguBsdXFjMOY0e5aIUThJhE+HYiOlfp09NcAG8W8tNaeMMwhwa2SBL9GjaeBcKbbledlM4vT+oQ2LGAI2HvCjYzpzDCFu2F0kzYPLcJRQ0kB1qvfsEL+SCQkuCBsoISAo1DzTv28UBgfLD5ri2CGSR9h1pv3eJN4H358UeetJ4+DmGHPYEJQUc30DE/r5bkZ2atUgI3y5RLxTEQbXC1abA74n6LerJwTwrXUhzDx+XKUoxDniDu9uLovvqfUhM+LZmodCMiQENgI7eMYy/3YxZkUfBMPYOpcoLzBSQOpij0jo7VIBjQOafxsvpCUQ+bMAyH6alyan1O3zEJCOaoSeEDH9tY32V1YmgbyYKH5ZnxkymbnbQrf6tWXs8BmlkMXiVyzQyHsCJ0EFoK66wOuB3qHfohuIeMXcG2v/LVzgTqklpb08wvD7xA2XJ5Qk6r4a95KllXN1BDhjcU
 52HwrqXY
 4oWobPv2pzk1XBtvT7CCkki99srYIOMjIo5gAUejrFx0Ah0Lvdresv/atkTahKgbUxFe2QFTxn7+XiXhOXkIGgj2EgqyG086kV7tjURLgvdC036QWgLFq3bPBiaZg0xqpn4uXOxZCs6egCnG4u4Qt5sM/xKLEnjLzXTVCf6isgS1s3pO0wImdtnlScdEWKm9/jQ0wtCQWhgbE8f6OmGpIY5yjwKF7YuiDtwngr7gG2/08BJnovlO6Q7iyqwfhri0SULrTNmFIFc5kVl4ISjN97Sm7/wnKGiAgcqmEqcQRKXcfUWdKVpif8xDp99IgD19FwjIBSEStYzRbzam6NnKpdhjvLamsgpTUmBxXPEohzyRdFyqbU3Gz0weN0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:43=E2=80=AFAM Ababneh, Ehab <ehab.ababneh@intel.=
com> wrote:
>
> Hi Kairui, Barry,
>
> Apologies for the delay in getting back to you with these results =E2=80=
=94 my
> test environment got corrupted and I had to spend some time recovering
> it before I could re-run the benchmark.

No worries, Ehab. And thanks very much for your testing!

[...]

> > > > I agree that reverting the commit that caused the regression is not
> > > > the optimal path. I expect there are many workloads and scenarios
> > > > that benefit from the behavior introduced by that commit, so
> > > > reverting it could unnecessarily regress those workloads.
> > > >
> > > > I will run the Cassandra benchmark with Kairui's MGLRU-FG patches t=
o
> > > > see whether they address the issue I am seeing. I will send the
> > > > results when they are ready.
> > > >
>
> Thanks for the pointer =E2=80=94 I gave your MGLRU-FG fix a try against t=
he same
> Cassandra read benchmark I used for my patch (4 nodes, 720s, 100 readers)=
.
>
> Results with MGLRU-FG:
>   Op rate:                  55.0k - 56.5k op/s

I noticed this is even higher than your dynamic
readahead fix: "throughput ~51.9k-52.7k op/s"

Is this a run-to-run variation, or is the improvement stable across runs?

>   Latency 99th percentile:  6.8 - 6.9 ms
>
> For reference, here's where the other variants landed on the same setup:
>
>   Regression (6cbdd9726fb5, "mm/mglru: use folio_mark_accessed to
>   replace folio_set_active"):
>       p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
>
>   Revert of 6cbdd9726fb5:
>       p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
>
>   My dynamic readahead-credit fix:
>       p99 ~5.8 ms, throughput ~51.9k-52.7k op/s
>
> So MGLRU-FG recovers most of the latency regression, but the revert
> and my fix still recover more of it: p99 with MGLRU-FG is noticeably
> higher than with the revert and my fix (6.8-6.9 ms vs ~5.5-5.8 ms),
> though it's still a big improvement over the regression's 9.2-9.5 ms.

We also have this :
https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

you once reported it as :
"throughput was approximately
49.4K to 50.3K ops/s, averaging about 50.0K ops/s, while the 99th-percentil=
e
latency remained around 7.0 to 7.1 ms"

>
> Happy to dig further if useful =E2=80=94 let me know if you'd like more d=
etail
> on the latency distribution or a longer run to confirm these numbers
> are stable.
>

Thanks
Barry

