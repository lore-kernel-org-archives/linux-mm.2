Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 651D5105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47DF6B0089; Tue,  7 Apr 2026 23:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1D76B008A; Tue,  7 Apr 2026 23:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999426B008C; Tue,  7 Apr 2026 23:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858D16B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:16:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7930B1A0A39
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:16:01 +0000 (UTC)
X-FDA: 84633924522.13.269C43D
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92DFA80004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:15:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WaHyOqA0;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775618159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5BAqHbb5bhnkhjYz3aTCjg27+CiWn9lwJmI608v3cI=;
	b=AyLMQYmIegHcYLccnLZIdRDGDix2+p/shfSk+Af0W3KEEPqdtb8VSdnpNUtR4TMlcIToaU
	FePTz5Ovkqh2GHsfHom3LZ6XDaXKFiGQrzJibASK9/HWpMDYgxVt+M/73mIckQECcRiazZ
	czcS759rIQIQwcT5TU7EbjtUi1YYGJQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775618159; a=rsa-sha256;
	cv=none;
	b=hbxQ96M5gstV+bikliHhOzHNsdN+QVquL7iqkxrpyFa5ZW/vcE1nuLCys8e7M3Is8wdZdC
	P5JHHKHgqFdC8Gz76LYMnKUM/ZSn7zqPvea1zXRiDpn5VE5gxgBK6c0GwlhlsjbmrAWnpv
	BFnXqfq0a01eDCbGulhrY7HZNxprias=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WaHyOqA0;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c76cce85bd9so2106838a12.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 20:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775618158; x=1776222958; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T5BAqHbb5bhnkhjYz3aTCjg27+CiWn9lwJmI608v3cI=;
        b=WaHyOqA0/mQoww+rYNdYlNhT/P7oZAQou2oXQzHpzWnY+Kelravt4nTXFHUKra5QPY
         rssKTbxWwsQZ9rw5N68YrizgEPaXDJo0vhEXrxNnaz21YbCV3a6o+Fk+Z4wcJ5NbZ020
         jg/jMo93+VVvzBFn5PceFVBdBRD4oWFMhVQw1PimnjRpqrUQtAZMZP7AW9dYNqTcBoIu
         r0YAZLCO3LfSDPphRjhftWClFLdmrCq2D9NXTi5slyFbx1vQEWr4itJX0YyPO23JDbQx
         bVWScrH1M5rsO3XvNgaHJYhX0OH3EAVwA/2YTVE6/Qc5AzihJrtS2IRDsYpuK/m2fkvw
         K1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775618158; x=1776222958;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5BAqHbb5bhnkhjYz3aTCjg27+CiWn9lwJmI608v3cI=;
        b=l7vEhnwrZC6uQ6BPHCLjkZDfDZtYjnhdaORvR5jtAjQbMCukOoBnVEfbnfAJyfp+a8
         uNMXh+L2/CLcWbAgoecMl5crK+g46lkZLxuU0ciIN6c8GZz7pidZAur9acgDrGWsHC0E
         v+yIMsdU3uuEP/fc4xWkeGWGMOzMnUgk3G24tHKAb5WpX1UMTErGriSayGKrMokMTk3x
         3kb2oiySksC795ckx44rUeDGarEp7oty0SQ1VDyWbQYF2E9VgqzQZsTEWpCazL2PmlWw
         54+yqrDQL+mRoxfHIWuggpG7oj7EijEZXOBGB39cneOTMSHQ13iovLTiN9A17yTu9C9p
         35kg==
X-Forwarded-Encrypted: i=1; AJvYcCWq1k0tNXQXHvuMG81tjnHSKRqblg+8RthHChFa8uuEF4s/6Ba/LEivgfrhiAGWPPgfHFP51C7jmQ==@kvack.org
X-Gm-Message-State: AOJu0YxWKTtG57xEwYuZEx0pqO6VcVsEJF3DOZk+BcigISGeh5/CWJmt
	yJ1LeJgLwUXhF3PDEEz2ikTgdC7mf9sGmh1LRhl1UPuIn5dXxnCEJflu
X-Gm-Gg: AeBDievQcJf0ZUVi+Szmxqr5vh5ahua5p5n/G05xwQqw6YEg4eUDWwsKioDSzgxnrIe
	iNJcRbkYuLqLE44kENfNXa0MTrqjl4ErG3k1GB39q7YnHC8Ie4GfZj8Fx7t3c8B/b0035SONSlX
	mWGwV9Eh63FEPxHN40jeZmEUD05ZYoIc3JShmpKD6SYpSW+DAGi6RxrIzcz/12O6odJPxoyEHJI
	LqaxISzM90LOfLg6Epg/i3GgxIvAhiQa/zxi86UzVxzNDo+9bksd2dPIoAZN3vj16upituVHGzt
	zlHMQ1k/Vh66HUJ3PR+s1XQf2Nkz/Hsj0hmegLpTddYWnSS9/XlKfLHJ8YPUdzeV/2iuQtHez79
	VWaRfaNwMOTSjLk83K7rWeGwrMqiP6K7fS+Xzi6K2CAu/JJEbMkfR7HvPv25IvXWOqg2XhRTrkj
	jWeWt5KrYX6nH+4iATSRGhDqntUWyF0JRmydttT3BEw4NFhE3oVL+mf0Fc1WAf5JVU1oTO
X-Received: by 2002:a05:6a20:1587:b0:39b:fbb2:5e46 with SMTP id adf61e73a8af0-39f2f0968d0mr20221375637.40.1775618158243;
        Tue, 07 Apr 2026 20:15:58 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c65a3f08sm17170990a12.31.2026.04.07.20.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 20:15:57 -0700 (PDT)
Date: Wed, 8 Apr 2026 11:15:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: wangzhen <wangzhen5@honor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
Message-ID: <adW_O1-QAQadQ68-@KASONG-MC4>
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
 <4451bdc432864aebb54f401eee51ea53@honor.com>
 <adUM54W3WYwEFj3J@KASONG-MC4>
 <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
X-Rspamd-Queue-Id: 92DFA80004
X-Stat-Signature: jyn44eh78y7myykpkz3xij9wmjxd5d4g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775618159-123779
X-HE-Meta: U2FsdGVkX19LDfDMrWOjgi+CJHnLgyglsAxQf/EA2QpoZFy7SQBwAAYwmgqAlpYma6orPAXsPmWSXNK/IO+xsLW4iLngGfSkzy6jtvpk2Z0AAe1Q9ziL73RmwNR9/FZVV1IV6Ol8dIDJUmi6HqCDYfzfcarhWvlHZFjpyALL2fItue6nNNOJ6Qj310F+/5n68Yewe5BD+h0dE917yrBdmF2cXxtVreMAXjlp3sVue75bcrVf3cPuhI4JeW6tiwXUDvQPUFzma/X1I/RYzxHmUxhTaswuPfTd7tRc1fsp7yD8nrpsiTRHVUmgx7Sx8jN506n9Ydi63r00082KU2JWddu3/wvS4LeMtt7rVRX+jiPkLcpJYS+ZQn+iubc9OJkUiYngpqMY0tw1aqmlu0tj0MwBpaG+ZB5QmVra5ubzA1pfuP5PrS7h3BXLnli0CVpAMWEovV6sUYDSB6VhlEmFGWYeQejHkHXCvpFZkqv/UT2kq53NFXdLZJuwUBgE1tnLtJJA6bxcKlNZXwQbDuNrhI/mkyIjrfONy/+wRoHu/kmCf2oCTubpk9r4TEJQ+y1Un+D5hU8TjslM+z0hyxExzNOJRT8vZWx9kue7mOEzrthdtRjApc2bfOjAjFn62OZegbGhttGQ6ScQ1+KWknNS9K8ROPTR0/4d+pf6iwZQu09hzB2tJjQbhw4fjPkblUvwqclon1mmVrY+t8QimoKle4ZUpUuw8zyLvW0NVSDn61ialv+AFM81r4SnbqaIbZxXAXS8ZL73FNwlAq8n5leHAiYG5kNLq4BbN+z+EC8oi9bwbGSKqG/iPhXu4ZCEfTzbzG4AWCrBP7QfV23FAifx3cWT42D2uR8nX7dS9J9ZIjBHOgYPb4c/UtgCiTxo8hYX/7uMg770FTiYurGvbjjgYM3pIh+ycUelt7APcu2FEf04L0IxDfoN16tlZkX27KN86E2HtrvxZqd9i51lvMf
 t5zwr+wb
 flr+9XZVBMMBmmBv147mus+Pv6JhdklJYF10/LboJ2Omnd+0xrVOVHxHnpfQJVlz0eNiq2MigF3urMmwq2tFGeBkJsj1lW58KT3iD3W1VbTeEpu5+Qwk6BqOGNxkJ1ks7CEAUMncPog1AIQlufhcAOE6RhtOwz0T6Nwc3MNwV4Ple1wgdLDmiBqH2shlraJRbujHwGJChF5kGn5Q2+wlClYQCxAWokSZPmxa+PfJ99a/85NYkPqRf2s4HwyZ5fW+H5VGYQXZy1DUblOwiYkhXMsl6AV1PYmn2IsHMebxm3fubUGZ+ITYhY+kpG18kGs3gC8nPnFk7DiR/vtG0n16rI7qGTO6WujBCwy4MLEbyww8uUo0OWEHItoxdQ4zDNlK7qkHIc5wr/Z+jkgOF7VQS3rQb/I9Axp1BbF1y0IwdBste0xIgpMOwyhr6wEvPcFwJXzCFvF9P9RtkRxsX7YgfkvxLWjAVFB0lscmKYaCY6uyUqrdFzjQrovpYmQpd4pU/bw4nlKpiHSC75iFgEIJBsBlzreqZlwBEszBlmEmDCCTgEJwvGR4lyO56Zh/Gima5ymuQ3stWvPMX70+6AosOtPBBEbV0m2t9lD8h/fF2sSTWX2jHZNINXC0oiG0a+AWccFNSUa0tvJGoOroQ/bZNUac/PZlwolgGm3cd1dZkW+OZkPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 07:00:17AM +0800, Barry Song wrote:
> On Tue, Apr 7, 2026 at 10:26 PM Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Tue, Apr 07, 2026 at 01:37:08PM +0800, wangzhen wrote:
> > > >From ac731b061f152cba05b9aa351652a04f933986e0 Mon Sep 17 00:00:00 2001
> > > From: w00021541 <wangzhen5@hihonor.com>
> > > Date: Tue, 7 Apr 2026 16:17:53 +0800
> > > Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness = 0  or 201
> > >
> > > In some cases, when swappiness is set to 0 or 201, the oldest generation pages will be changed to the newest generation incorrectly.
> > >
> > > Consider the following aging scenario:
> > > MAX_NR_GENS=4, MIN_NR_GENS=2, swappiness=201, 3 anon gens, 4 file gens.
> > > 1. When swappiness = 201, should_run_aging will only check anon type.
> > > should_run_aging return true.
> > > 2. In inc_max_seq, if the anon and file type have MAX_NR_GENS, inc_min_seq will move the oldest generation pages to the second oldest to prepare for increasing max_seq.
> > > Here, the file type will enter inc_min_seq.
> > > 3. In inc_min_seq, first goto is true, the pages migration was skipped, resulting in the inversion of cold/hot pages.
> > >
> > > In fact, when MAX_NR_GENS=4 and MIN_NR_GENS=2, the for loop after the goto is unreachable.
> > >
> > > Consider the code in inc_max_seq:
> > > if (get_nr_gens(lruvec, type) ! = MAX_NR_GENS)
> > >     continue;
> > > This means that only get_nr_gens==4 can enter the inc_min_seq.
> > >
> > > Discuss the swappiness in three different scenarios:
> > > 1<=swappiness<=200:
> > > If should_run_aging returns true, both anon and file types must satisfy get_nr_gens<=3, indicating that no type satisfies get_nr_gens==MAX_NR_GENS.
> > > Therefore, both cannot enter inc_min_seq.
> > >
> > > swappiness=201:
> > > If should_run_aging returns true, the anon type must satisfy get_nr_gens<=3. Only file type can satisfy get_nr_gens==MAX_NR_GENS.
> > > After entering inc_min_seq, type && (swappiness == SWAPPINESS_ANON_ONLY) is true, the for loop will be skipped.
> > >
> > > swappiness=0:
> > > Same as swappiness=201
> > >
> > > so the two goto statements should be removed. This ensures that when swappiness=0 or 201, the oldest generation pages are correctly promoted to the second oldest generation.
> > > (When 1<= swappiness<=200, only both anon and file types get_nr_gens<=3 will age, preventing the inversion of hot/cold pages).
> > >
> > > Signed-off-by: w00021541 <wangzhen5@hihonor.com>
> > > ---
> > >  mm/vmscan.c | 14 +++-----------
> > >  1 file changed, 3 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 0fc9373e8251..54c835b07d3e 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3843,7 +3843,7 @@ static void clear_mm_walk(void)
> > >               kfree(walk);
> > >  }
> > >
> > > -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
> > > +static bool inc_min_seq(struct lruvec *lruvec, int type)
> > >  {
> > >       int zone;
> > >       int remaining = MAX_LRU_BATCH;
> > > @@ -3851,14 +3851,6 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
> > >       int hist = lru_hist_from_seq(lrugen->min_seq[type]);
> > >       int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > >
> > > -     /* For file type, skip the check if swappiness is anon only */
> > > -     if (type && (swappiness == SWAPPINESS_ANON_ONLY))
> > > -             goto done;
> > > -
> > > -     /* For anon type, skip the check if swappiness is zero (file only) */
> > > -     if (!type && !swappiness)
> > > -             goto done;
> > > -
> >
> > Hi, thanks for the patch.
> >
> > We have a very similar patch internally, and the result is kind of bad.
> >
> > Currently MGLRU forbid the gen distance between file and anon go larger
> > than 2, which mean with this patch, when under great pressure, you may
> > have to keep rotating a long list of the opposite type of folios to
> > reclaim another type.
> >
> > For example, when you have only 2 gens of file folios, swap disabled,
> > and there are 3 gens of anon folios. Anon folios are unevictable because
> > there is no SWAP. And file is also unevcitable due to force protection
> > of gen. Consider anon folios are mostly cold (at least a portion of them
> > are), now the oldest gen of anon folios will be very long (e.g. 12G,
> > 3145728 folios).
> >
> > Now, to reclaim any file folios, you have to age first. Before this
> > patch that is usually fast. But after this, it will have to rotate
> > all 3145728 folios to second oldest anon gen, will could take a
> > very long time.
> >
> > During that period any concurrent reclaimer will get rejected
> > due to force protection, result in very ugly long tailing or
> > unexpected OOM.
> >
> > So I agree this is a good idea in general, I agree we should do
> > this. But better defer this until we patch up MGLRU to remove
> > the force protection first.
> 
> I suspect that once we can age file and anonymous pages
> separately, this issue will resolve itself. David already has
> some code for this [1].
> 
> Not sure when he will have time to push it upstream, but I
> may carve out some time to take care of it this month.
> 
> [1] https://lore.kernel.org/linux-mm/aam5nOyXs1sNdjTe@google.com/

Hi, thanks for sharing the idea.

Right, a few weeks ago I also got info from CachyOS that they are using
following patch for MGLRU:

https://github.com/firelzrd/re-swappiness

The idea is also split the seq number for anon / file so swappiness
works again.

However, I really not sure if this is the right approach. It changes
the model of MGLRU and things like TTL may no longer work as expected.
And TTL does solve real problems too (also from CachyOS):

https://github.com/firelzrd/le9uo

TTL replaced the le9 patch above in a cleaner way for thrashing
prevention.

Right now we do page table walk (and it walks both anon / folio)
while generating one unified new gen, meaning the folios in that
gen have the same (or at least all older than a specific) access
time, which is used as the metric for TTL.

Besides, having unified gens also help implementing things like
workingset reporting where each gen is like a bin for histogram:

https://lwn.net/Articles/976985/

Aging triggering could be a bit more problematic too.
I think the right way is to just do the aging asynchronously, Yu
even left a TODO comment in vmscan.c:

/*
 * For future optimizations:
 * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
 *    reclaim.
 */

Then, we start the aging when ever there is less than 4 gens, and
allow reclaim to always go on even if there is only 2 gens left.

The performance would be better since the is no more blocking
on aging, no change to existing model, and the change should
be smaller and easier to review IIUC.

One concerning part is doing reclaim while only having 2 gens left.
I think it seems OK. It should be rare as 3 gens act as a buffer
already, having only 2 gens left means the async aging can't catch
up and system is under extreme pressure so it's unlikely the folios
will get access enough times to get meaningful heat info, and
refault will be more meaningful help to sorting out the workingset:

https://lwn.net/Articles/945266/

Cgroup reclaim can do some throttling on that too, and kswapd can
still do aging synchronically.

Just some ideas, we may need to do some test and benchmark
to figure out which is the best solution. Discussion
is welcomed! :D

