Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DE1CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 17:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787DB6B00C1; Thu, 25 Jun 2026 13:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761016B00C2; Thu, 25 Jun 2026 13:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F896B00C3; Thu, 25 Jun 2026 13:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36A816B00C1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:59:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F1AFC111D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:59:57 +0000 (UTC)
X-FDA: 84919198434.13.5A81A0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCF8540003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:59:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTMDYN1M;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782410395;
	b=Xv/SBzSnolooeNlUkOGAdWkXJzye5Y75LnJ9eGFMLA4FJjk3Ac4OlBesdwiaCtodY4IgC2
	+zoozQ1NJOQ36AYaSs3sbAPCaMZk1ozjo1gfZIrFmIiVtRa9xITpziJ9qYvfkO8H06qTuN
	wl0AwDctXtWKVNTqKAQYZZI/Uc6fPL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782410395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maBD18wndqrXXyxBBamm4qyhPlaRjOfTNx99c6xaonU=;
	b=iw/4BrTFfPYi9/A7Y27XL+Yd0T9IqDGwYxcynbmByPUt2pbdpwbEr7XeThj72FyC4F3N/E
	BN3mnHtOxUjnbmhXB0Wl4AYFD6vBPxIMrwgvwoojWNVk+vd5+irkPG0N/6ytnuUUM4AGT5
	EYe+XysQQcirlcYAsvNbua5pGaSin8I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TTMDYN1M;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42365601D9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE301F00A3F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410395;
	bh=maBD18wndqrXXyxBBamm4qyhPlaRjOfTNx99c6xaonU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TTMDYN1MkkiCADF5OAf4cZrCoUDfwifR422d8+QUrPyQw0rVIiKYDRPTUtFo018mb
	 3AgXhKV2s6rgWMQTwbqzwm1SKkhgZji7SC/ToLKqDy8v3jiRibw6XpZ/HRqmGaN3Rz
	 MquNL3HIL6/1yTI9U9CPYfqGwVH8b3oQo3TJVe3pn6Ek4zLT/Ix8JwcqyyHiFcVWQH
	 NtPtIfYsPr/hS+G8Y5CjOfOfFYn6cGHBFhWgPEqBNcDkELDYtorFIcPksmvq2u1+se
	 QAWrRCB/agz+NJZ1RnpUMEGyYo0mCyeM+oPt+tGg7PHqGzLOQZ0QR+bjOzq/sLuw8Q
	 QUVKkL1QDZ5rQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c0e12cb1d90so7821966b.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:59:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrU3Kxn0joVL6nsRqGFui3L1MrsV8Q+kize1DlYNvdprESwtdM3KjgsIWPEGQKpQlKLN/B3LyZysA==@kvack.org
X-Gm-Message-State: AOJu0YzVWNR1jZrU/GmNrUeQSiUZL5MR9esnLAMMBV27ra8k2c6NeS/a
	FVGMKrLjGzLBzO+n1RRk3H7CnycZccQCG6inewjl/C3ECITAfJbGv+r3FjzqE5AY7cG52m0vwlu
	S8eK9xk5tau9u4BSnXRVLo0uO6Q7iVxY=
X-Received: by 2002:a17:907:9722:b0:c0c:c98b:c379 with SMTP id
 a640c23a62f3a-c1205e6d95cmr237202266b.14.1782410393872; Thu, 25 Jun 2026
 10:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com> <ajnGTt8tkbAWX8Oc@google.com>
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com> <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
 <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com>
In-Reply-To: <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 25 Jun 2026 10:59:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
X-Gm-Features: AVVi8CdO4P-Ec9VD50shnHTdmKHFyCt4FDu6VKnLqYJ_-pw3WTO4T2Njs4-xTgc
Message-ID: <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of shrink_worker()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CCF8540003
X-Rspam-User: 
X-Stat-Signature: 78upptd6cner6j6bn61k8rtmdts1k7zb
X-HE-Tag: 1782410395-943382
X-HE-Meta: U2FsdGVkX1+CubLAeb1+3CfY1e1Zr5DPbMWQ4nmgqLx8H4Q4gjDOOjTlPqj1rttOU4tzwUSsmEXXfuwIuMkcsHzbAitBJvjLaVr0NLOvgN/ScM0UKjBiUV0WwxuPDcWUzBOAn9oQU/7X9b6TYwTXiy4tFUCFuxcJa7qZVG/MB9uAYuABVA7XX3bnhDod1P5iIAMoVlPOJgZK9D5G2843Zn/BwPwUMt8Uhn0hzFx5Ov2yi9gDf3r4jd36mt1M6UWoc97pT5lrXp4kqO9mJmIMe2jeEJFE3ZkW6pNoEItMsmEbw30YWL4KWjRWmWoQuiuwa/s9DIud3tELlSPH0RWxVkMLscgLXllHpMOgOPWPUGtjkcbYZuFu742cEHUO8vEiVUBd1vn0eQPRk/RbZRTzJpffRv2AekW7z1/bpMbMuO8+Mbhqk06jHBM+yxNJxbtFBF5cJDAAjbT/uN0r/d16KPw2ocgGvXdD2Mll5Ty/ZIjOAaP2gLVMxu6+Qf1/Dwkqi8KzC+WJ5tnhOgSzpq2/sidw49Zujpp9k5Z0Ql2vwdBYWY4xa8/xoFqAz8yAmCWBW2YxoeqWo93xaUkUmSufloZeI0fem9uE95MgrpSfHRHy6xiONiZwqah3jPo7uQnjJOyPdwiRl4B0wfG2K91MRKnSUMvako72NkeeiwjMZ1AP9/4WQa/qWJAezbtqZ32Qv9lSOtfub8y2C8f0mPZEuYRdtP19IrSV+dGmuSkVY54R8oCR1KrWqCKvjLTrz/rJB8P1BbCpSN0CQHRqKoBQrP8Rbtt0cN9WT59ysjf+ulPdMkGz72HpOQYhQJhbWFMPYp4n7rUTX8GOPon2P942GgZxjznSyNvhYO9EQP2PgymOu3QDILa4j7A/14wqsR0bNqJf+2BrVbOf4h8XrgELDLKkqoO3ArxnfzUrpKLB5tuNxQKfIwYP/j9RxZYqr80xjU2i9YTCZPQ0AuPjX9U
 PEF5mt9o
 xHzIflB/Td07eODWEbz/wUCXpq4k4g8V0K9ZJabpKeRQfgJB9YsXGiP4UTlZ7oceHJK+I+ry1lbnrjDkj0FsSIvsL19dA+0qTCxvXLONHnyRPqTIMTohWah/sOtMIAt39/B+avfZ1dySUqtnPlW0rMcsYKfOIOcZ1OsSjM4wvMIV8B3OvrzyUC8kljxGgF7QeDDEjcgo38tezDVnR9X+VQRJomM+u2uawPOwRt4IGO5opFcm9o0p3fospLKbG5bdeYpMDHuMr+H2vBANLSj4x3mE/S4y4dzihLhXv3DmohfasGyuubSqzuRudnc11/9tOc20m5sUUfb4Igct1mGFNzuYr6XYiTuJesoiv8sAv7PU+sSrFlsNgyiyhnVWEVIn6Lw5gAXO0JsTiG9QOq8tAfct3kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> static long zswap_shrink_one(struct mem_cgroup *memcg,
> >>                    struct zswap_shrink_state *s)
> >> {
> >>       long shrunk;
> >>
> >>       shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> >>       if (shrunk == -ENOENT)
> >>           return 0;
> >>
> >>       s->attempts++;
> >>       if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
> >>           s->stop = true;
> >
> > Do we need 'stop' or can we just return a value here to indicate that
> > we should stop (e.g. -EBUSY)?
> >
>
> Perhaps we could return -EAGAIN instead of -EBUSY? This would align with
> the semantics of the memory.reclaim interface, which returns -EAGAIN
> when it reclaims fewer bytes than requested.

Hmm but -EAGAIN tells the caller to try again, while here -EAGAIN
tells the caller *not* to try again because we exhausted all retries?

> >
> > I think splitting the shrink/retry logic over 2 functions makes it
> > more difficult to follow, so yeah I think fold
> > zswap_shrink_no_candidate() into zswap_shrink_one(). Then the callers
> > only need to iterate memcgs (depending on the context) and call
> > zswap_shrink_one() for each of them.
>
> So, something like this?

Yeah, something like this :)

> /* Track progress of a memcg-tree writeback walk. */
> struct zswap_shrink_state {
>      int attempts;

While at it, I think "attempts" is really the number of scans, right?
Should we rename it? Maybe "scans" or similar?

>      int failures;
> };
>
> /*
>   * Take one step of a memcg-tree writeback walk driven by the caller's
>   * iterator, and fold the result into @s, the retry bookkeeping shared
>   * across steps. @memcg is the iterator's current memcg, or NULL once
>   * it has wrapped around after a full pass over the tree.
>   *
>   * The function returns -EAGAIN to signal the caller to abort the walk
>   * after encountering the following conditions MAX_RECLAIM_RETRIES times:
>   * - No writeback-candidate memcgs were found in a memcg tree walk.
>   * - Shrinking a writeback-candidate memcg failed.

Orthogonal to this patch, but I wonder if this can be simplified. I
wonder if these two conditions can be replaced with "shrinking a memcg
that has zswap entries failed". The "no writeback-candidate memcgs in
the tree" case seems like we should abort right away instead of
retrying?

Nhat, WDYT?

>   *
>   * Return: The number of compressed bytes written back (>= 0), or -EAGAIN
>   * once the retry budget is exhausted and the caller should abort the walk.
>   */
> static long zswap_shrink_one(struct mem_cgroup *memcg,

Nit: zswap_shrink_one_memcg()

BTW, the existing writeback logic has been broken for a while now when
memcg is disabled. I think we constantly hit the !memcg case and run
out of retries. Not sure if your patch changes this in any way, or if
you want to fix that while you're at it :)

>                   struct zswap_shrink_state *s)
> {
>      long shrunk;
>
>      /*
>       * If the iterator has completed a full pass, update the shrink state
>       * and check whether we should keep going.
>       */
>      if (!memcg) {
>          /*
>           * Continue shrinking without incrementing failures if we found
>           * candidate memcgs in the last tree walk.
>           */
>          if (!s->attempts && ++s->failures == MAX_RECLAIM_RETRIES)
>              return -EAGAIN;
>          s->attempts = 0;
>          return 0;
>      }
>
>      shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>
>      /*
>       * There are no writeback-candidate pages in the memcg. This is not an
>       * issue as long as we can find another memcg with pages in zswap. Skip
>       * this without incrementing attempts and failures.
>       */
>      if (shrunk == -ENOENT)
>          return 0;
>      s->attempts++;
>
>      if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>          return -EAGAIN;
>
>      return shrunk;
> }
>
> static void shrink_worker(struct work_struct *w)
> {
>      struct zswap_shrink_state s = {};
>      unsigned long thr;
>
>      /* Reclaim down to the accept threshold */
>      thr = zswap_accept_thr_pages();
>
>      while (zswap_total_pages() > thr) {
>          struct mem_cgroup *memcg;
>          long ret;
>
>          cond_resched();
>
>          memcg = zswap_iter_global();

Do we still need this helper? Or should we just keep the memcg
iteration open-coded?

>          ret = zswap_shrink_one(memcg, &s);
>          /* drop the extra reference taken by zswap_iter_global() */
>          mem_cgroup_put(memcg);
>          if (ret == -EAGAIN)
>              break;
>      }
> }

