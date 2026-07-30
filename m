Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710A4C53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 00:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05446B0088; Wed, 29 Jul 2026 20:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6B76B008A; Wed, 29 Jul 2026 20:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC746B008C; Wed, 29 Jul 2026 20:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82C956B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:31:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 221231C11AC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:12 +0000 (UTC)
X-FDA: 85043563584.11.9A9B953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B4EA100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfdKRFkl;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785371470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=223Lw9K3r/YKNgDc8O3HO2tfWjMepfaOnuVJWOvxOI4=;
	b=Tdz2R/CwgFHzVFEGJD4VJTmOpFs5x0OR4cBXiJh5/bpPZUb/eHDYUAjm/4eYxtEO77+4BP
	E6dCvt2eBfO9yWOYwN+WvScKDIltvzotU6KrLmfuRca3b9r3aqWtTSZ4xSBLrFMNtuZfIi
	/QiYoFYurX8bT+of8T2J21okuUFLse4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfdKRFkl;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785371470;
	b=k6lRjbOU3lN6+ERO1CrOfRUjUg7VmU50w09KufZiejWDy2Hce72RfqM8txhqDTf4hKOdlk
	SZU6gksAVsp63wFwmEbwYbuLoAj/YiUCEQCl5beKQBQAiQd0sYQ2UCNtOsIbMPlznoqnZE
	V80sn9LvJFeyjm8Jdug/uH2FQVxxdJs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 199BA43CBD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3881F00ACF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785371469;
	bh=223Lw9K3r/YKNgDc8O3HO2tfWjMepfaOnuVJWOvxOI4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nfdKRFklDNUurArltP8U4rxO7Qro6nf3tlY/PIbjjmp7aC5NIx/FB38kvWdwAxj2P
	 +WI7XndHSPbOuXAik5bgfIpKgS4cheU9njAMaP+kUQ+etMUHBY/5t9Z4YETlBdwZ5O
	 PFU0b0s7Yh2fN+2lS0j052EkpYHn18uTne9ws1qC0KcTRjmwfWytiS6lkhlC41vtgm
	 0UpbbKSvoOEQVwGIxW41J+slwmhS07zFfm05WS6eyFI4UHX9NHgOvVJ9jrmBO4pTj1
	 8Ryi/urIRG1ktSHTQDijgfXUUV8t2lFLuQXdktjHZ3ILKb3fA5GS74yPO0VGGIM4F7
	 +odj1+z/YMblg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1677c91969so184787766b.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:31:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpA94QoO10g63aCqbFN86jU432ySgIxPzMklVxR8/UauhjIu7D+QBVFPISNv1ztyD0fuCNB9lbI5A==@kvack.org
X-Gm-Message-State: AOJu0Yyok3hTiN1qSvTH1H8/YQGUTdFkOT3fW437/pot57kdaOZH6i8z
	71UZ6lWSdrnnxrSritnya+mdXNxJCXZd2TcojFOwsXVl58W9hisbfQokMn6PwpdlZzN4kYTa0EZ
	sAJb+lONL37GBkc33eAAyh3cK/mC/UG4=
X-Received: by 2002:a17:907:d08:b0:c1b:1315:163e with SMTP id
 a640c23a62f3a-c1fa54c4b5bmr24929866b.29.1785371467863; Wed, 29 Jul 2026
 17:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com> <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
In-Reply-To: <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 29 Jul 2026 17:30:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
X-Gm-Features: AUfX_mzEIitLB3kH8Hiawz-YUBT-nt1v9BFc8j6q1ERagl2zhHIwEwDmanOLo5A
Message-ID: <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B4EA100006
X-Rspamd-Server: rspam01
X-Stat-Signature: cqfyqoqs3we7ktif71koez5n1bkgjwb4
X-HE-Tag: 1785371470-700683
X-HE-Meta: U2FsdGVkX1+NrX3+IKafhxYWF23HudnVHPkwBDOymfO8k2yX1R9b1krFLJXKJ8yCV4KlU7zJfCBg6DlDrBs8F072nnb6e0ZhffbpX9HOJc52dWnEK31Ip5G3xcMgGmc+662JnBKgucFwMzqfvGFUkKS/unK8V+Vn60Wx8lI0+MnE3BEax2qt/pPCgD5D/rFJy9xuf3SaJWCsnRm4chNchOatkDys2dGeYAariiZJGEPb+Y4KvJRWd285HSveWjleK6sWpbJYTazMUOhdnxeqC/igPfbFbMfdksbEZKXK+7lAQALN2FCn6lWQaFgrGM62NIA81Na2bHhX3MNNxuDLG7GgfkYL+SJAgxUqY1AjSnTvZN2Ag80XTNWmb90pOV6hJaB8/T+KgjxGS7IdIwaHUHC23ucrej1do9FLef3gNROLfTkAQGsQzwXkAyzAghz8MOmcUcOPBycAaM2KbTzvLbHx9iBzbhmZBYoFxlahN2gKC1deBP1Hw2YMVKVJbnrnU23Ezal0BZPfdpL8+HYgTYk3nfByYN8b3OWZqc0DzcKevyPyvYYtsME9kftrU+SPbBq5LjXn/7r+1Divkt/XlSoci8BrJEShnaxEl+Ww7No8vuTO5/UYWzR4g0Qi7SIeBqzsv1THfuMfUtLUcXm2wb16ZYt/o4oSzniIifeWutsAx222dxh5XqpTO0NBwcBAuYG70yXrWBQTxctvmHnK419EQglI/+VvqiRfmhwjt65u7wmFKuJqr4bvn0QZ8vdRcYwGtq/gdQSpBEWWkr7CiGJDUdcmidLNy0Mtztwr+nKSYxMt6mJFXB7vkFw7QSfNnVK/FFPw75BoGCiL5cQp6f6krwI8XTLrz0G4yvnWiOyw6NUwRCd6m6x8KaJmFIRpM8MwRUPy4cAfk9jQVG4MbMy1lVo/xThyA6fnyp+RtppUXkzg+SCOHVNAQ7oWD2xNOnYtYWZq8J6zbG6FQ0G
 lxvFejDa
 +GmWDGVExPYUmiEJeYAXK+BRGAOua3LTM3/KomNm9Cy5FatPzmoyaRb9eEa84vmFmTWBjoWMVbxn1KfbTN9J6jYguEaEOyzVPqLClGIu/wPbGGTHLvMqGExYEO8x3V9pHA1SNL6yEO497XMu2ySOcX8jj6oxNG32RTIrBn1CSaqBe4/fxoerh8Iu1I/bhnpWq72d9i6CYZlYCwQMP/1D2Ece4gc1yiVJRb4nm4GBm1vVUm6vew9Zor6CL4OHaZ5WFRzUueLAz1NC8PqPFJY7r0z8bX4r2TtDouR2Ch7mLCt6XtsgpDqlvIZ8Gf0b8xFO43hv+f2cwIA8YT7bzFelxcfI43TPHqT3YXPx22j+3Z3l75nUUDpAZvNCkndHh+NMIwpnr8n5n6oZp4U6iC4jm3ov5uJjYyu6XKibDtDHUQocuL5E6C6zTru4WNJMQQn7K6uMgWu5D9RvGdsm5H2geBh80y99u6vNiex5XR1PmqAnRwRFK8kiU9u4SfXXv80BLG64kYDyGRV+TB5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 3:58=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 29 Jul 2026 16:42:05 +0800 Hao Jia <jiahao.kernel@gmail.com> wrot=
e:
>
> > Zswap writeback when the global pool limit is hit fails when memory
> > cgroup is disabled. The pool remains full until it is organically
> > drained by swapins or memory freeing, leading to zswap store failures
> > and pages bypassing getting written directly to the backing swap device=
,
> > causing LRU inversion (hotter pages with higher fault latency).
> >
> > This happens because mem_cgroup_iter() always returns NULL when
> > memory cgroups are disabled. As a result, the global shrinker
> > shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
> > failed attempts, the worker gives up without writing back any pages.
> >
> > Therefore, when memory cgroup is disabled, fall through with the !memcg
> > branch and shrink the root memcg directly.
> >
> > With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> > LRU is empty, which means the total pages are already below thr. In the
> > absence of heavy concurrent zswap stores, the loop then safely bails ou=
t
> > via the zswap_total_pages() <=3D thr check; otherwise, it will resume
> > shrinking the memcg after processing the reschedule check. For any othe=
r
> > return value from shrink_memcg(), the loop is guaranteed to terminate,
> > either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
> >
> > Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> > Cc: stable@vger.kernel.org
>
> How does this affect users?  What behavior do they observe when it
> occurs?

I think the first paragraph sums it up pretty well, especially the
last sentence "hotter pages with higher fault latency".

>
> > Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZ=
eLc=3DeyTPKPVQgX4g@mail.gmail.com
>
> hm, that isn't really a bug report and doesn't answer the above
> question.

Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
it because checkpatch annoyingly complains if you add "Reported-by"
without "Closes", so Hao just linked to the thread where I pointed out
the bug.

>
> AI review asked a couple of questions:
>         https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.kern=
el@gmail.com

The review on patch #1 is something theoretical, we discussed it at
length in previous versions.

For patch #2:

> Does this batching logic break NUMA fairness?
>
> Because for_each_node_state() always starts from the lowest node
> ID and breaks when the scan budget is exhausted, subsequent
> calls to shrink_memcg() will restart at the lowest node ID again.
>
> If the lowest node (typically Node 0) consistently has enough
> items to exhaust the scan budget, wouldn't we exclusively evict
> pages from it while ignoring older pages on other nodes? Could
> this cause LRU inversion across nodes, keeping older pages in
> memory on Node 1 while hot pages on Node 0 are evicted?

Yes, unfairness is possible.

For global shrinking, it's probably not an issue. We reclaim until we
hit the acceptance threshold and it's very unlikely this will happen
before iterating all nodes (given that the batch size is 32 pages).
However, with the shrink_memcg() path, we only reclaim one batch, so
there's a chance we'll always reclaim it from node 0.

Maybe we should just drop the early bailout and accept potentially
doing more writeback than needed. Hao, WDYT?

If you respin, please also drop the batch size argument to
shrink_memcg() as it's now always SWAP_CLUSTER_MAX.

