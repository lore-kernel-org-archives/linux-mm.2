Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD544EB362F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 18:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7536B0005; Tue,  3 Mar 2026 13:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E2B6B0088; Tue,  3 Mar 2026 13:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C661B6B0089; Tue,  3 Mar 2026 13:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7AFC6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:02:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68DA813A6A1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:02:06 +0000 (UTC)
X-FDA: 84505520652.03.126F9CE
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 859F3C0020
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:02:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jtDyRlB3;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772560924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foIbnYRvZEeozwct/vuUZhLqaBM8H9J20Y5TG3JAcfE=;
	b=PMQTOx2crKJyJ/sJliizbv7Ni9E5wfuL8+eda8bB5SgqWKL/poLJRJQOf6SglMGLnssido
	bk99ptxymK8+GKc6JNst6rqzTVeTOYnRYBWMkMbqZ9HCBTzRku3j5jQn7+uZMI52oPZjyn
	6kkkM6B8MCgSVXe1lbKFysJduqqhDZY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jtDyRlB3;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772560924; a=rsa-sha256;
	cv=pass;
	b=k34YZ1RiXCWCNjeATWmtQwTDf+jWf/y9+bKsW3sPjQ/xLpmfHrXf763JWRB9X6Gf8qw34u
	uWJDdnG4Md3g3NXjKsUDr7yfU4/D2rd2dd7nf4DwSJYcKrhcl6Zy/jYYXEZs/vm0my5jh3
	VGM8hIEnICZ0LOuGjp7Ytf/AL88vD5A=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43991064db8so6132136f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 10:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772560923; cv=none;
        d=google.com; s=arc-20240605;
        b=bQwi+Po+PgcplkxQwcRP/2ExMZzcJVtpqDgLwbcg8XqzQLGtzf7Wo38NruFlvdPHGB
         mDHAlLIqSH7q0nXNjViQwG2PyaAE5zwNd8BKKxAX/OoozZPuLcgKgHM4QzKwZtQsoWfH
         UPa0J2ZKTHlGmYfWODRSDqUcKNH6jZbnnfhE9rk1psOsEhcLFYkT98/jIIIDie41PCE0
         DFb8eyzqfWIEIWjBkltJ1Og/hcEek+Wsv2v9L0ghu+DT5ryKdYtkVBiCymjPnawuHOCa
         jJPYvHtlIWl8ioAD9ESplgEvhHPMNyCuJocdPsWE2ZvA2PH4rBDU27+nqX9JNUHIhPTI
         PQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=foIbnYRvZEeozwct/vuUZhLqaBM8H9J20Y5TG3JAcfE=;
        fh=RPAEwETKbquasmjLjHlJLYF3WwY98ib6fvReEscynZY=;
        b=hmw2wClqQF2bPJxI3rfy/3h8jhLEHRVkOg0As7uLQ7ggJBe36pDLvJObaQIlODCNsm
         bgEIu8JJ56DL22T8/ByZQaQx3BZoSwnJVDgT0kEhxpnD2laymUsc53q8Shdqyq+jpV+V
         9BlBHljTt/8PIeL6U0Qp+0RN9Gyzfv92eoU2JdQLTJVY+SrELE4yDHit36yBl5bI0nFX
         GmjVpxmfJH64/xw0WlLDh8V6VAqqrVIM7cQDvWbH8pXYs2TMVVjqJeTlQF/RbvxDOD+d
         jzROAihgnCusaEgdrDZupw84srLDqaw7OQ6DbnE0tnQFh2+q5Ena8rrAtVOaHkXvK/f4
         iXBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772560923; x=1773165723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foIbnYRvZEeozwct/vuUZhLqaBM8H9J20Y5TG3JAcfE=;
        b=jtDyRlB3oImdO2lJmQsXhSqu+YYXsfhNHJM52kMgWPg+goSUSssmvfFaWFJ6nG6mnZ
         Tim/x677EWrRZYSu87J5Gut8dtFBWi3SAAJYi/HF8ftsiwpF9METLZgtgajIEUE0EGG5
         6GIFkITpYMpDXUaLsQ6+ux4PArBFF4IGNhm0tgW9PJk+qqhGwUyG2UsA0h1uSVaVJjbM
         ZjMdoXo73ZE0uIgERXc8PIV+WP6IqPAsSJUcHNU/EGNvsAKg5rX4ZKuWBe7jUEUSU1mM
         Pnn4LPNNlrgRnTfDQrBcmlO2WGPfH/3Chc6Tr6AxK87ZUDBEf2sbnT56bqsitaZhkBlq
         fcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772560923; x=1773165723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foIbnYRvZEeozwct/vuUZhLqaBM8H9J20Y5TG3JAcfE=;
        b=tghkkitdWruBPKJxlRF9we0E938wjZyx/VxvJiuOfXGQ1xoS+G6LfGn8v2ShGwy7wI
         MzSh0GT3iXTHh0GILc9WDhcq7UU5W+nS+DgEstAEeXobvW+tMDxj+Xo5dEIUuces5daU
         +qdiICQ8MFKmz9vNAYdjz42tFMIMdjZ8x2zUAWV6EEsVGyYgYsyOww+mqE/m/kDdhxzm
         HcXWLGD4yesyJKrTrAhSjs2urT2l5nSWQMJS35KQVy2GYG1AY061YzDRozmBcRuTfrgS
         nTTWZt+zjXbdif4CZr0LgVUSlg7OCazULJ/RhSjYvNgc8lMDUpvuNN6x8ie81+gcjm3j
         GpGA==
X-Forwarded-Encrypted: i=1; AJvYcCVY2X9nFHFqNDCV6Dv3GS/kRQXYin0uwxdA7vKMbml+umaQMugsqrN2hUD997VIKDBKX1htMO36+A==@kvack.org
X-Gm-Message-State: AOJu0Ywl4uzQJUL/rG0bN8svQV/385b3HMxeHl/bICBKMoaZ0IKxGcMu
	HCnUDO+TU03D0hNsDKMP/Hp0nVMIFqxoAI+VkXxHZBNuJGjZgfnv7KFxKYubvoUnCEiGW/BuRj3
	3k24K3kZgpIg+3DQDbWt6uZ813tVAFhY=
X-Gm-Gg: ATEYQzyt993gdIws+kiwKE35ynar/IvMVq9ZHLVZnEVBV1HtofCzRImS9qXSVWauFKr
	kA2Lp3fKwXcnZW2HVjfO/fSvFtPbq312ewhXHhn8vVrsrifbETgH1FruDZUts0h4ooUVfAXQ34I
	RXMBSTOnxvR5J8kuJCfpDe9Y3zVjtacPbRYaV1ZDNsLd8QmRPH+Yzfy9cx78Q1pt0/C/kS9LQxK
	VeWY4NMg9H0H8o/aevMmus9DHKJ+3Wa6QqyDNuiPcGTI+MRhCUSnjisdzJOPA1emJkHaFheHitv
	uD/GuA8YkAAoWUUC6qyTRdBbUY5spT3/I7B9XLE=
X-Received: by 2002:a05:6000:238a:b0:439:c550:d92a with SMTP id
 ffacd0b85a97d-439c550d9d5mr2304995f8f.53.1772560922568; Tue, 03 Mar 2026
 10:02:02 -0800 (PST)
MIME-Version: 1.0
References: <CAKEwX=N-yzg66Ge5YgDNG7nh3ues62fSjmi6oGq1B=gkz6e2Uw@mail.gmail.com>
 <20260303175140.1032459-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260303175140.1032459-1-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Mar 2026 10:01:51 -0800
X-Gm-Features: AaiRm52gDOCcmDbHXVyYPo26Ma_Va4b_HvYpOS1jbz0JVcTO_7EGhjCQqYnuMK0
Message-ID: <CAKEwX=NW75_ftM5ZuJJRMB2CLnB-25KPvamb4L1eP=i0XuFS_g@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 859F3C0020
X-Stat-Signature: cdcmg671hrgs3xbnz8zh1azowtteq7r5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772560924-300150
X-HE-Meta: U2FsdGVkX1+NtaEhXIYIuc2xNCPRmlnVTlmz1/7ZsH+wThRLsaeDCY04tsrrxsVzEhYp34wEscCFZm/7EXRFzC2A0GPy4Xu4XnCyudxyKGqjIneCNVU9Ht8vfL7gi1awO+uoXfu7Rjd/0kMQ2I3BuAXWbzGbTeua/4XjyjDVJosSEK9Yl3qvxkM1Gq/KC+1EORAY88qSJvoplPNY8E9x5azOD1Z2cTQAO8YBlmcTT6xaJpcH71q8mYtjr0UFUMBWU1fT+pgFEBTnmd5HOUhrRS4OzNmfxTYC95U+D+j1nRJ3RSw3qMUepaZXB2iSXdCE7kTk/oZaK+E6B9bwchtvbE365h2iv2l3hNNG79QMwwHV1mZT0vNc++1pVi1jItxPIdLgxkAo6SMzvXKw2YmkzSXKeHrfJ3k7FN6rQWmX0kzatpy/SbMTbk1Lja78TSTiJt0E/V6zDNB83KzvTi1m4oeqjX4TbhewgrCRS4OUuNRxNka5OLzDEWJpWKt32FRRHVuxpyiveUEaJ+giI2fkAyMT52NLvYPPArCZBfzCJf++nk7J7lOj9U/xujrmNRYcrVdnfPYpAjNJChJSNLCoKdb2B1r5UMnJasNvc0WldeWnAHxbaUciNLN1IYJME24tEphZ0rY/ZyfKA2VEpR2wH0OnTl/BWUQ+hoe0Xqyd8aPS4LJvz9Pg6oebJvFTEflsa9MEB6AHeheV6mKrze5MGTbY/z47TrrHMcUCcV6oaBGQbBE9Xr2SWYvQXl0lS9mWPlIwGCW1LZi8nAxOHh0395Cs8omEcQvzhz4NirzAM3zouPQIBOIHxJ36vtkMI6iM9lu1a41dkZy7OY6PgPPB1gvz9IHFBpxZ4BUPCl6lquF78iFcFs9Yr3FUGqmO7+4WkUXOcr+ok5BtD4uk6KOxOQcDCGQGrQTqKOnGZLSO2CsmdA+rZpufS/23BSJs1ZCpvuYyGCVp5gCp2C6qtxp
 SYn2FfTM
 ferWo9CuVExJTsqIc2CXBtWW4VM3bqGtxmMSvUftxnd1xMLHJ1fEv9SrqHmrFtI/mSJNugCSqSNNBPkkx5QF/mtDAtNG7amt314MhrLOA7YFFSidhFRCxLD83eQrmpj7Ojz55
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 9:51=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.com=
> wrote:
>
> On Mon, 2 Mar 2026 13:31:32 -0800 Nhat Pham <nphamcs@gmail.com> wrote:
>
> > On Thu, Feb 26, 2026 at 11:29=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gma=
il.com> wrote:
>
> [...snip...]
>
> > > Introduce a new per-zpdesc array of objcg pointers to track
> > > per-memcg-lruvec memory usage by zswap, while leaving zram users
> > > unaffected.
>
> [...snip...]
>
> Hi Nhat! I hope you are doing well : -) Thank you for taking a look!
>
> > I might have missed it and this might be in one of the latter patches,
> > but could also add some quick and dirty benchmark for zswap to ensure
> > there's no or minimal performance implications? IIUC there is a small
> > amount of extra overhead in certain steps, because we have to go
> > through zsmalloc to query objcg. Usemem or kernel build should suffice
> > IMHO.
>
> Yup, this was one of my concerns too. I tried to do a somewhat comprehens=
ive
> analysis below, hopefully this can show a good picture of what's happenin=
g.
> Spoilers: there doesn't seem to be any significant regressions (< 1%)
> and any regressions are within a small fraction of the standard deviation=
.
>
> One thing that I have noticed is that there is a tangible reduction in
> standard deviation for some of these benchmarks. I can't exactly pinpoint
> why this is happening, but I'll take it as a win :p
>
> > To be clear, I don't anticipate any observable performance change, but
> > it's a good sanity check :) Besides, can't be too careful with stress
> > testing stuff :P
>
> For sure. I should have done these and included it in the original RFC,
> but I think I might have been too eager to get the RFC out : -)
> Will include in the second version of the series!
>
> All the experiments below are done on a 2-NUMA system. The data is quite
> compressible, which I think makes sense for measuring the overhead of acc=
ounting.
>
> Benchmark 1
> Allocating 2G memory to one node with 1G memory.high. Average across 10 t=
rials
> +-------------------------+---------+----------+
> |                         | average |  stddev  |
> +-------------------------+---------+----------+
> | Baseline (11439c4635ed) | 8887.82 | 362.40   |
> | Baseline + Series       | 8944.16 | 356.45   |
> +-------------------------+---------+----------+
> | Delta                   | +0.634% | -1.642%  |
> +-------------------------+---------+----------+
>
> Benchmark 2
> Allocating 2G memory to one node with 1G memory.high, churn 5x through th=
e
> memory. Average across 5 trials.
> +-------------------------+----------+----------+
> |                         | average  |  stddev  |
> +-------------------------+----------+----------+
> | Baseline (11439c4635ed) | 31152.96 | 166.23   |
> | Baseline + Series       | 31355.28 | 64.86    |
> +-------------------------+----------+----------+
> | Delta                   | +0.649%  | -60.981% |
> +-------------------------+----------+----------+
>
> Benchmark 3
> Allocating 2G memory to one node with 1G memory.high, split across 2 node=
s.
> Average across 5 trials.
> +-------------------------+---------+----------+
> |            a            | average |  stddev  |
> +-------------------------+---------+----------+
> | Baseline (11439c4635ed) | 16101.6 | 174.18   |
> | Baseline + Series       | 16022.4 | 117.17   |
> +-------------------------+---------+----------+
> | Delta                   | -0.492% | -32.731% |
> +-------------------------+---------+----------+
>
> Benchmark 4
> Reading stat files 10000 times under memory pressure
>
> memory.stat
> +-------------------------+---------+----------+
> |                         | average |  stddev  |
> +-------------------------+---------+----------+
> | Baseline (11439c4635ed) | 24524.4 | 501.7    |
> | Baseline + Series       | 24807.2 | 444.53   |
> +-------------------------+---------+---------+
> | Delta                   | 1.153%  | -11.395% |
> +-------------------------+---------+----------+
>
> memory.numa_stat
> +-------------------------+---------+---------+
> |                         | average | stddev  |
> +-------------------------+---------+---------+
> | Baseline (11439c4635ed) | 24807.2 | 444.53  |
> | Baseline + Series       | 23837.6 | 521.68  |
> +-------------------------+---------+---------+
> | Delta                   | -3.905% | 17.355% |
> +-------------------------+---------+---------+
>
> proc/vmstat
> +-------------------------+---------+----------+
> |                         | average |  stddev  |
> +-------------------------+---------+----------+
> | Baseline (11439c4635ed) | 24793.6 | 285.26   |
> | Baseline + Series       | 23815.6 | 553.44   |
> +-------------------------+---------+---------+
> | Delta                   | -3.945% | +94.012% |
> +-------------------------+---------+----------+
>
> ^^^ Some big increase in standard deviation here, although there is some
> decrease in the average time. Probably the most notable change that I've =
seen
> from this patch.
>
> node0/vmstat
> +-------------------------+---------+----------+
> |            a            | average |  stddev  |
> +-------------------------+---------+----------+
> | Baseline (11439c4635ed) | 24541.4 | 281.41   |
> | Baseline + Series       | 24479   | 241.29   |
> +-------------------------+---------+---------+
> | Delta                   | -0.254% | -14.257% |
> +-------------------------+---------+----------+
>
> Lots of testing results, I think mostly negligible in terms of average, b=
ut
> some non-negligible changes in standard deviation going in both direction=
s.
> I don't see anything too concerning off the top of my head, but for the
> next version I'll try to do some more testing across different machines
> as well (I don't have any machines with > 2 nodes, but maybe I can do
> some tests on QEMU just to sanity check)
>
> Thanks again, Nhat. Have a great day!
> Joshua

Sounds like any meagre performance difference is smaller than noise :P
If it's this negligible on these microbenchmarks, I think they'll be
infinitesimal in production workloads where these operations are a
very small part.

Kinda makes sense, because objcgroup access is only done in very small
subsets of operations: zswap entry store and zswap entry free, which
can only happen once each per zswap entry.

I think we're fine, but I'll leave other reviewers comment on it as well.

