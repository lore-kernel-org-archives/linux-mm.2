Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B650C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027E26B0092; Wed,  9 Sep 2026 10:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F42106B0093; Wed,  9 Sep 2026 10:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FB66B0095; Wed,  9 Sep 2026 10:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE9676B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:37:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F8A640218
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:31:53 +0000 (UTC)
X-FDA: 85194462906.08.5372272
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC9C5A0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:31:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Df/dGnAR";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gaz9Tuhu9FmWVu5POkpWAA/nd2+j9iwcTYE+kF4AHDc=;
	b=HnBxiHGpQklQoDzp1H39VlCu9ka1IsR7uC/wOZvNc1WW2JYFGoNm1KUf1ZhlTDlrV7d6K4
	CAb1wx4ZnS2kduwpT3GG+b3zIXFrEAUPZgFo4UkBndZz0X+uRqal8ILcHvMT4N4WBAY7Wt
	B2a4IAJzR8+MlCULNHbyMo18X9QJVYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964312;
	b=WE4RnzrI+TJFNoThD5YMbAFjSv+NpH10zqMuh9i+jIFHT+b6HGcTpobeXbB4zrxy930FRx
	64KKPOwdu2AeloUmuwqNGDOPbSBHOXKjs4DwiH1UOkUX5n5jA4mw5hct7ie9y9M1+UUCcp
	ykJH/VXJt8CAep1DcPtCdxYicoajYaI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Df/dGnAR";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14E0840A90;
	Wed,  9 Sep 2026 14:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AC91F00A3D;
	Wed,  9 Sep 2026 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964311;
	bh=Gaz9Tuhu9FmWVu5POkpWAA/nd2+j9iwcTYE+kF4AHDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Df/dGnARTkxzFRzDixhnWOuMKgdW4wnSErIOvIPiUpSucU6BJS1lQUBfG77feyCS4
	 78NfoAcRIYZWKbtrGKBkLQLkYx/nIiZWfw7alc+xzob72+07elPHBBMXMV6VAg6o6m
	 KRDxJEI9ITF2JgjNx5POuNg9JpK184UGxzJXYHogP/SXB7dLYvz+PxgEY4iy+ONjCm
	 U9/Zw4feJXhcnCAeHw88asiVFV5j/eqQpsKgo1nhv39JxMRuyyBzINxMNIDIPOlNwd
	 lWFWW54Hl+0caA/K8iM/Yc/vFhgZNxB5NRlCR/DMpchKzUIuswtAYN3PrF4maSO96n
	 MS5LdPLFhVjmw==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Wed,  9 Sep 2026 07:31:43 -0700
Message-ID: <20260909143143.106666-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6f1e4bde-da16-4510-b1c6-16ba2a24d3f3@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nc8x7iwaww66nsnxjt11gqn1y5c9n6gf
X-Rspam-User: 
X-Rspamd-Queue-Id: EC9C5A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788964311-241440
X-HE-Meta: U2FsdGVkX1+WSaw/T9mRwheUfsegEwZEt0yCqlYPSUyMozT+Q1Qprh2A3V8D/mIRlR62YHhs9gK1cau0h39CyJYNiolQCen++JGPyJc/KHQ2UiqUHBjuM7fPBUpbwEIah6y4TcZdyTVmxwxrcGBguzOd7ZJuuLt6ofN33uV6qtJ1q+UbJ9WqXD9dh7LdzHVgpnCdytV1vRz9fy2MrzC3UOj/lbqTycD/AWHQpVo8APnTJ/2aHviVMa3KhBG+aW4ezt0fXIp0cqzrKQxhRMffT8kFDapmjFVpEfpDxqp4z3iz9a+5RXE0FDnwiFkSML4n3ZKrruO1+a7fz7Go2S7xG9JRDG6sd4YPaEwLrmaAH5Gy8Guh2lp0ORothCipYLRdyt7MY/X5zaNZo/ZSHEaNAbMxBtotzJCsv1Mn4R+ZVwBO04fj76i8rVJOFvXZaA3NonAmeLTXoKfnZjB/Ll1Cr4LZEW2EVeyKegRJzM1jtzP0xCi2YgzJwFIBpKjpebA7t0mcCDwRfRCuGzs32kJiINwx6ehRBtyLNsiKoXAp03tyP9ZLKu3uqZKS92Lf8TcPICbOEMjN4IpQ5eMJFhrjKb9vt3ib7wf/OMPATlhtoRSbibrkATkbB2dWrdMKSQXVhzRZnJtaJ9Pqma9sG0/cuAI81WcOXSlNndYyA6jXees0sVJRnRBtapo14pPuGeOpTwTHQO3Jlmhe7Mbab4+YertsdogG6k9omvWC5tPMaian2uPO7KrFVM2bvsGSRydexqq3f015BnLHtAwHLkZmzVSjSjSMaHm4XIRvYrkgoqCRuLXkhPaoGHEv6NaKVACV9qJOxbogwPPgt9goZk/0z4U++G7+oMYNGs2UlCCfQCt9S9xsMsgj1XKzKiDm+mvGtQLkwyHhHZ6WmlMrha+Y2ye4me7sy4l1fm4RFPhUzXumHSMhvdCAkgl7lqSkImvG1ZnakJJz0NwyZbni/+S
 c7wKtmU+
 sjvN+TuAgq+CPuT3vMmPYDH/dszuP/12ukLThGwqqm13aEv7TiAZtzPTNBm+qBIiHt8ot6PQUQ89Ik5wL5m+y+Dp0zHr8xQ11j6JT5W8M7jWI34isAiG9ZxcCtckHrgZHf6rk0q/wBijMP8vC2mZf09PsLPLgECBYCkmCnn8KDyVyFcn/HcYVq4jKcPsHW/w1CXMya/BpVlSWMwY5E1RwsAtSiWMl/h7qbjb0p4UbcaGutHkobENM5xQ+CZ9ACy4sXSVEr/nDuT88uSpgPd0F2otBT/fnZrtzPeelBEtilN2yozKFMeKItDieKo9ntVddEY7oytklKPN8nRa3FcM1pRRzihATwscEk9ZLwZoWWu+wEDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Asier,

On Wed, 9 Sep 2026 17:25:51 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 9/9/2026 5:04 PM, SJ Park wrote:
> > DAMON supports data attributes monitoring.  However, only the physical
> > address space operation set (paddr) is supporting it.  Add the support
> > to the virtual address space operation set (vaddr).
> > 
> > Patch 1 adds prep_probes support to vaddr.  Patch 2 moves probe filter
> > handling code in paddr.c that can be reused by vaddr to ops-common.c.
> > Patch 3 adds minimum apply_probes support to vaddr.  Patch 4 extends the
> > support for hugetlb.  Patch 5 extends the support for pgidle_unset
> > filter.
> > 
> > Test
> > ====
> > 
> > I confirmed it can capture ~48 mb working set of masim in vaddr mode,
> > like below.
> > 
> > First, start masim [1] to access ~48 mb memory at a time, in the
> > background.
> > 
> >     $ ./masim/masim.py run \
> >             --config_file ./masim/configs/stairs-50mb.cfg \
> >             --repeat 10 --quiet &
> > 
> > Note that the config says the working set is 50mb.  It is 50 million
> > bytes, so ~48 MiB.
> > 
> > Start traditional access monitoring of masim's virtual address space
> > using damo [2].
> > 
> >     $ sudo ./damo/damo start $(pidof masim)
> > 
> > Confirm it can capture the ~48 MiB working set as the 4-th region on the
> > snapshot.
> > 
> >     $ sudo ./damo/damo report access
> >     heatmap:
> >     11111111334[...]3000000000000000000000000000000000000000489999997777777743333333555556[...]8
> >     # min/max temperatures: -1,150,000,000, 80,009,499, column size: 6.963
> >     MiB
> >     intervals: sample 5 ms aggr 100 ms (max access hz 200)
> >     0   addr 85.355 TiB   size 55.703 MiB  access 0 hz   age 9.500 s
> >     1   addr 85.355 TiB   size 18.984 MiB  access 0 hz   age 6.700 s
> >     2   addr 127.183 TiB  size 278.516 MiB access 0 hz   age 11.500 s
> >     3   addr 127.183 TiB  size 7.570 MiB   access 0 hz   age 900 ms
> >     4   addr 127.183 TiB  size 48.133 MiB  access 190 hz age 800 ms
> >     5   addr 127.183 TiB  size 54.977 MiB  access 0 hz   age 1.700 s
> >     6   addr 127.183 TiB  size 55.113 MiB  access 0 hz   age 6.700 s
> >     7   addr 127.183 TiB  size 37.902 MiB  access 0 hz   age 3.900 s
> >     8   addr 127.990 TiB  size 120.000 KiB access 0 hz   age 11.400 s
> >     9   addr 127.990 TiB  size 8.000 KiB   access 70 hz  age 0 ns
> >     10  addr 127.990 TiB  size 4.000 KiB   access 0 hz   age 11.200 s
> >     memory bw estimate: 8.931 GiB per second
> >     total size: 557.027 MiB
> >     record DAMON intervals: sample 5 ms, aggr 100 ms
> > 
> > Stop access monitoring and start probe-only mode access monitoring.
> > 
> >     $ sudo ./damo/damo stop
> >     $ sudo ./damo/damo start $(pidof masim) --probe_prep set_pgidle \
> >             --probe_filter allow pgidle_unset --probe_weight 1
> > 
> > Confirm it can also capture the ~48 MiB working set as the 11-th region
> > on the snapshot.
> > 
> >     $ sudo ./damo/damo report attrs
> >     heatmap:
> >     00000000113[...]40000000000000000000000000000000000000000000000001111114999999533333336[...]6
> >     # min/max temperatures: -840,000,000, 330,002,000, column size: 6.961
> >     MiB
> >     probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
> >     intervals: sample 5 ms aggr 100 ms (max probe hits 20)
> >     #   size         address       age           probe_hits
> >     0   8.000 KiB    127.990 TiB   8.700 s       0
> >     1   120.000 KiB  127.990 TiB   8.600 s       0
> >     2   55.543 MiB   127.183 TiB   8.400 s       0
> >     3   110.008 MiB  127.183 TiB   8.300 s       0
> >     4   55.352 MiB   127.183 TiB   8.100 s       0
> >     5   55.605 MiB   127.183 TiB   8 s           0
> >     6   55.691 MiB   85.355 TiB    7.900 s       0
> >     7   54.430 MiB   127.183 TiB   7.900 s       0
> >     8   50.391 MiB   127.183 TiB   6.900 s       0
> >     9   18.879 MiB   85.355 TiB    6 s           0
> >     10  52.844 MiB   127.183 TiB   3.500 s       0
> >     11  48.039 MiB   127.183 TiB   3.300 s       20
> >     12  4.000 KiB    127.990 TiB   8.500 s       20
> >     memory bw estimate: 0 B per second
> >     total size: 556.910 MiB
> >     record DAMON intervals: sample 5 ms, aggr 100 ms
> > 
> > [1] https://github.com/sjp38/masim
> > [2] https://github.com/damonitor/damo
> > 
> > Changes from v1 original post
> > - v1: https://lore.kernel.org/20260906184417.96621-1-sj@kernel.org
> > - Rebase to latest mm-new.
> > Changes from RFC
> > - RFC: https://lore.kernel.org/20260905202634.88102-1-sj@kernel.org
> > - Drop RFC tag.
> > - Rebase to latest mm-new.
> > 
> > SJ Park (5):
> >   mm/damon/vaddr: support prep_probes
> >   mm/damon/paddr: move probe filter handling to ops-common
> >   mm/damon/vaddr: support apply_probe
> >   mm/damon/vaddr: extend apply_probes() for hugetlb
> >   mm/damon/vaddr: support pgidle_unset probe filter type
> > 
> >  mm/damon/ops-common.c |  32 ++++++
> >  mm/damon/ops-common.h |   2 +
> >  mm/damon/paddr.c      |  23 +----
> >  mm/damon/vaddr.c      | 232 ++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 267 insertions(+), 22 deletions(-)
> > 
> > 
> > base-commit: da659d141e9797b3a2e5d0e2b457bfa4e8a8cb2d
> 
> Nice to see the progress with probes.
> 
> Since you are adding prep_probes for vaddr, do we need to check for
> the existence of prep_probes in kdamond_fn?
> 
> How about this?
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 645cb367019a..7b308cbf21ab 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3935,7 +3935,7 @@ static int kdamond_fn(void *data)
>                 if (kdamond_wait_activation(ctx))
>                         break;
>  
> -               do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
> +               do_prep = damon_has_prep(ctx);
>  
>                 if (!access_check_disabled && ctx->ops.prepare_access_checks)
>                         ctx->ops.prepare_access_checks(ctx);
> 
> And maybe change the name of the variable to has_prep.

I'm sorry but I don't understand a benefit of the change.  Rather, I show it
could cause a problem.  Later code does below:

                if (do_prep)
                        ctx->ops.prep_probes(ctx, access_check_disabled);

If do_prep is true but ctx->ops.prep_probes is NULL, this will cause a problem.

Am I missing something?


Thanks,
SJ

[...]

