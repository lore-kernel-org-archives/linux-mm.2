Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CA1FDEE27
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5114C6B0088; Thu, 23 Apr 2026 12:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7796B008A; Thu, 23 Apr 2026 12:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0696B008C; Thu, 23 Apr 2026 12:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24F2F6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:42:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5B3412036A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:42:50 +0000 (UTC)
X-FDA: 84690389700.03.23ACC11
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id B2D5F40013
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:42:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxLxrDwv;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+QkA1oAtbdwJWVoHl2LBARGYjytOFHnCUJvD5+AJyw=;
	b=eVvLXIWMdFBsPvHKkrpEq7ox0kldYRuecjGuzR+qrI//5ClmOUkDl4kfHhq5lygl22K3XC
	RnMZenBZ/py7Qksm4TxetFufnqQB30YWQlD4Rsv6+PJvgMEgPjh2l9/AYALs4Nqnr4c7Cz
	br/swSdNy2L3TJDPZbLASk74WPhgI/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776962568; a=rsa-sha256;
	cv=none;
	b=O7N9/6wZYmiKyDifxXjETcWvjrOMvSyl5StQa97b6an+94CmleRkwZ6Y1XhMbb8FF1Yi+2
	PZ5fMM+k5YZU/Mu/6c6jfiC1O9e9S5CFsrLpmKt5GqKgmSfbEYQu5WwY84TqJh4eVRgUYH
	N/FNlOpVs/H3ivJje8zYnSDgJqx5v+A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxLxrDwv;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f2766905fso3216787b3a.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776962567; x=1777567367; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u+QkA1oAtbdwJWVoHl2LBARGYjytOFHnCUJvD5+AJyw=;
        b=UxLxrDwvF+NihKSfiTU8ROakZDUpduvHil2CyxTCJ4VzOzZsbfs6au5IbkNURO0qeE
         DnEqOLYtD5WmqmjzIjBiO36gTId0ajFNw+/dH6xNmB1FT1N/+JGgjXlBWvv4m9gNIXk+
         t+nAA7K4VvT8Bnt2Y8QBZEHvWNLYas16q7Lea4W4P6Z+YqNCTYqWLko+E58MXEjH1WHp
         ifuA+dMxGUTm1ZVRk34ehsw+BxzB1Xd/232+92/GAAJlCpTVu/SP8CgPa8qCBgOTYmUp
         VndfqgmoySSshYTQQHZLFatYrO6m//arhCAXoM77WefGShM9AvDmftpyLTtav9rNgM1+
         sNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776962567; x=1777567367;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+QkA1oAtbdwJWVoHl2LBARGYjytOFHnCUJvD5+AJyw=;
        b=T2XiZFT/Jw8TbYkUSjSc0olCsEgMWEFZj0GX9dlCoaPmCj0fhR2OHuXvXwb89fNMNF
         qN3SrU7aMcPQC9qfuaa+Rzg2TxmJN8roqwuTWBWny/pYexhvp5vTy5w2LHG8FojE0y2Y
         nYrbjMPPCrvxF+Gd4P4cJse3vyQxUJzZfnsmBQjYUfnFPrMRdSUmEzB09dOW1rywZWtO
         lNVJ8oitMZqtZxppA7OxtvIWgTrD7QUYTgg5W3trPrK/w0HHOCFpnxfWqs8azizJp+eO
         dH6NTJ1mlm+hWRObbjbN2oCTVl57QVKWLD6M+b95K8O6KIoKKC5hjdBqXACS00DgqxwV
         /kGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9h4fAloa/mg7j2qksCn/jwzqgcckBNEihHTJ8BwWseYbP/PG1iRaO5B0jJAsbznvw1W+JJdPslpQ==@kvack.org
X-Gm-Message-State: AOJu0YzHhELfRrQOhAIbI82c4PFlBLDx8OQadU3/7lDHAZ64bylCDHR9
	ofSLhXJ3AOBXL9zkdCM1T0KkW8kSmRKcUmKVOCoCVXKlLl4T1MmrwQJP
X-Gm-Gg: AeBDies92IITUuhoFpplnc/1zbT9Q9lqrXoQr4z1WnIq4NWqFNppSRJqwLIRW8ebBht
	s8bUYJVtMW5Ss92tmaB5cWoeVPsI57fE1jtHEYHjVd2TLCQExs204/ZNjouFtFcjuP2jr3orlA2
	z+aenD9OETZp19thjPb7PvFqPt1MK+UwbwLVKtQrFn5QaGfFMcPn79raJDRnLVzpaRvrCZRJJ1X
	DZBC1xJgS/742yHL/xWLam/PCohWRXBosFbSv0/m6FrN/QrfQZqwv45c35mVNGJHngUsLMso2Mc
	/sKVS3hLsZihqOXMQlxgjSbODty80HI7oWWmummkU1wkw7n8UCl2L3YpRtgASqdL2RRcanCuxYX
	FUPoNMrTOzD1GcFS3xYQW8D10rXNgwQ29p0/gIGYvDJ6YOZROYHY0PPAEAUf7kNVFNKYmYIgVYI
	CjyPJ/oi8/XUYm6m+7MWAJsOYhF/vVBiKZlMDpWjsYdqd31AfieTayvu4Hqkek6KIuWo+ZDg==
X-Received: by 2002:a05:6a00:aa08:b0:82f:b0:28f0 with SMTP id d2e1a72fcca58-82f8c8e5120mr31598227b3a.34.1776962567316;
        Thu, 23 Apr 2026 09:42:47 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ea09914sm20341382b3a.26.2026.04.23.09.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 09:42:46 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:42:37 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v5 04/14] mm/mglru: restructure the reclaim loop
Message-ID: <aepJ2wzJ9a6pMQZY@KASONG-MC4>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-4-8eaeacbddc44@tencent.com>
 <CAGsJ_4yQDgD-etzDzXJvaf2mOja6GAuFRw1WS2NZqxBvo7Ag8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yQDgD-etzDzXJvaf2mOja6GAuFRw1WS2NZqxBvo7Ag8w@mail.gmail.com>
X-Stat-Signature: j6xrh7fnb4gxjzgbpfspbjny8e6nd5cq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2D5F40013
X-Rspam-User: 
X-HE-Tag: 1776962568-7421
X-HE-Meta: U2FsdGVkX1/Qd5aCbHKsbzxgKP7qRYUZuqe4/NcrpUV/uJI4rP5zj6/Vxb3i1n2IrCR+NxF7Dg/3ts4gId8M7DwB1Inx++Hr8n2qfuo5Fw8eMeTrZAwRdMhqxBGLc+DOWJwNCwouBLd33RJy5Id3POb2NB8U7iyRMOFiZS7oSwiN4GyNEEdA/NP+Sg2s5wpbWFctWXjSRa8YjP9MOlOsLUwRYo9w5c7FdBEZ9f2lZUE294Cs6GtugiCl5xgBz/U8BSWMOg3/VqnpJTDLZndvgEiN0ShiQ3oROSA7IpwefaCscproTHYoj0mVEIjimzs068HUvPeVrgi8deGh91UoWvcB5MyANcFA9UyiC0RuReibUF9iR/qf6vV4xcJdUvUSprBk4RfNtSgikIyrr3RDXlecS2PuLazMPLSyQtSE3FaNnqn17PCQmRN8hAULCemtSaI8LDY5/xAV7GjBS/uBqFosFTxzyMa+RQq7JmcE+Z36D7dPItZnutIE3Xq5y8LKdDQY46pWEKOGZsQ/6XMFHEMDRLfRjNR1ZMncF/p7IG1MaoIlZBnO14VpJ/zaUL5UoZAkEwGBTfoFo9ve7CFuOr/yMvcSlKro6QhsPnvEqEs0Pr5xyFfr8XTiVc4TMyn5rl+1aPGpwsY3MjUgssAMT3ELCtIhwBRyhZ+UllAOtwXh3SaZ5FfI0CRgZl8CloVvHBhLYBUNfaaAe3sMP5sGvvC1ccxxXnY0ZIBADDCLcbVjzrMb6hlFdaLToRFfmtmR4CZGgzsptC2X9oS0HTQtEolXgBfc6SsrosnFGqziBw9zVk33xJtF+6Kj46uZqS0Hc84t3qO+2jvJqdCVl6yzy9LLNvBbhEdRrns+xPjmh8JcJqhLpZYuwCGE+Mgw6w5FqdmDGHppfFy+vdwXiLhIqb/m3ulMn/AokmkBcBFOHu/SzbAg0plkWy5FusTaRhYBo947dgUysQWY7woSfWl
 ds+jELFU
 7RzTYCnSqmB0rjYvMNmy1lj9KV1hDx5emVYgkSpQC2g0SvIMpjsN/lOSJ7m52hQ4aGaeiTy9OB9vJZCZDj+W0fYcx19LVqZjzX664ItqiCL4JjEgs9FTQ2I8yjmTELqZRMAdjdVYrVMZ88g2sShn+6bqSaXuXzcl0e5KmQFHSWOCrfEizBr2KnUqw8GnVmwD11wTzMEcR2ockL2TsbUoN2cqWE5RU3omNohzEyRyRMaUhb8J9ovb7RQntxEUfgjfd50fafPL0GzLYm/d1Vt9fpbzeqODrgLbgjutsmI2uiphFUFGJ7a885MtCfnc1JO0DCMlUshznTe9VPbXEbK5Q80I2A0zP25nI6szg+0JMgRD9a2Vqg2wN8w51cFpXErO4cNQqOkg0RzG93SydOLrDxadhLPwV+K10Ztzfnqhq4VZeReW07M4Hpuw4pAll0L3GSOipHpoEaDeMPm9BNbvMS4IWzbqqS19NW1OuaXoQ3fMGF/qMrSooO3/oxqPY7y8wuSWmnWJSMlH/I2dZEHNFWHZgrfDjaedjsbeHgKk+SXFhtyeB1mRe3EOCzRAqu1V3So4Xi2vsK0cZuxGKjnA3Ks0YKethfuef7p5M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 02:33:48PM +0800, Barry Song wrote:
> On Mon, Apr 13, 2026 at 12:48 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current loop will calculate the scan number on each iteration. The
> > number of folios to scan is based on the LRU length, with some unclear
> > behaviors, eg, the scan number is only shifted by reclaim priority when
> > aging is not needed or when at the default priority, and it couples
> > the number calculation with aging and rotation.
> >
> > Adjust, simplify it, and decouple aging and rotation. Just calculate the
> > scan number for once at the beginning of the reclaim, always respect the
> > reclaim priority, and make the aging and rotation more explicit.
> >
> > This slightly changes how aging and offline memcg reclaim works:
> > Previously, aging was always skipped at DEF_PRIORITY even when
> > eviction was impossible. Now, aging is always triggered when it
> > is necessary to make progress. The old behavior may waste a reclaim
> > iteration only to escalate priority, potentially causing over-reclaim
> > of slab and breaking reclaim balance in multi-cgroup setups.
> >
> > Similar for offline memcg. Previously, offline memcg wouldn't be
> > aged unless it didn't have any evictable folios. Now, we might age
> > it if it has only 3 generations and the reclaim priority is less
> > than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> > might still hold long-term folios, and in fact, a long-existing offline
> > memcg must be pinned by some long-term folios like shmem. These folios
> > might be used by other memcg, so aging them as ordinary memcg seems
> > correct. Besides, aging enables further reclaim of an offlined memcg,
> > which will certainly happen if we keep shrinking it. And offline
> > memcg might soon be no longer an issue with reparenting.
> >
> > And while at it, make it clear that unevictable memcg will get rotated
> > so following reclaim will more likely to skip them, as a optimization.
> > And apply a minimal batch factor when reclaim is running with higher
> > priority.
> >
> > Overall, the memcg LRU rotation, as described in mmzone.h,
> > remains the same.
> >
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 72 +++++++++++++++++++++++++++++++++----------------------------
> >  1 file changed, 39 insertions(+), 33 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 963362523782..d4aaaa62056d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4913,49 +4913,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  }
> >
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
> > -                            int swappiness, unsigned long *nr_to_scan)
> > +                            struct scan_control *sc, int swappiness)
> >  {
> >         DEFINE_MIN_SEQ(lruvec);
> >
> > -       *nr_to_scan = 0;
> >         /* have to run aging, since eviction is not possible anymore */
> >         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
> >                 return true;
> >
> > -       *nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
> > +       /* try to get away with not aging at the default priority */
> 
> Not a native speaker, and I’ve been struggling a bit with this sentence.
> Does it mean “try to avoid aging at the default priority”?

Yes, good suggestion. Let me update this comment while at it then.

> > +       if (sc->priority == DEF_PRIORITY)
> > +               return false;
> 
> 
> "This slightly changes how aging and offline memcg reclaim works:
> 
> Previously, aging was always skipped at DEF_PRIORITY even when
> eviction was impossible. Now, aging is always triggered when it
> is necessary to make progress."
> 
> It seems clear that you are returning false for DEF_PRIORITY.
> How should I understand “aging is always triggered”?

It can return true above. But yeah, my commit message can be improved.
Will slightly update it.

> > +/*
> > + * For future optimizations:
> > + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
> > + *    reclaim.
> > + */
> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > +       bool need_rotate = false;
> >         long nr_batch, nr_to_scan;
> > -       unsigned long scanned = 0;
> >         int swappiness = get_swappiness(lruvec, sc);
> > +       struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > +
> > +       nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > +       if (!nr_to_scan)
> > +               need_rotate = true;
> >
> > -       while (true) {
> > +       while (nr_to_scan > 0) {
> >                 int delta;
> > +               DEFINE_MAX_SEQ(lruvec);
> >
> > -               nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
> > -               if (nr_to_scan <= 0)
> > +               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> > +                       need_rotate = true;
> >                         break;
> > +               }
> > +
> > +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> > +                       if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> 
> Could we move the original comment here:
> /* stop scanning this lruvec as it's low on cold folios */

In a later commit we will drop the "stop scanning" behavior,
but I can keep the comment for now indeed.

Thanks for the review.

