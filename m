Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6407FF532DE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8686C6B00A9; Tue, 24 Mar 2026 02:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818D56B00AC; Tue, 24 Mar 2026 02:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707B86B00AF; Tue, 24 Mar 2026 02:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F02E6B00A9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:05:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 090A2E02B8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:05:20 +0000 (UTC)
X-FDA: 84579919200.03.091B4F3
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AA2B12000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:05:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARVyopsm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774332318; a=rsa-sha256;
	cv=none;
	b=bnTHX2GTRgeqpG0wULXxBH5rXxVY4WWmpu6qiGFStM1mKq20B7Qv876TtxFNUZlQRSTV0j
	pvjnMLUkiFyB3FtaEO5uOF6JNNaHCn58UnhR1CnkoIoyOdPCYCi3C9ZCIAAtWO49A1tnQ4
	CgQc7oSe3bqlFrSkjWX9eM1C5RO5sxM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARVyopsm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774332318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEdlrKcdSr700OtysgTmR1jEDaTt2UkGKyE2FtUG4ts=;
	b=OzsPHJ1/zRBfMNmId7pjuXHsSdtqQV2VX140/C0HgoLnVCTvnoUFZmAzRzmlso8IlnsrNY
	BJJrH1hxPiEMEJoWjUSENczQIW5xJWevyqiLXrQqT3pN0vek67ajBBFbQAyQ0K3mkWW5tE
	Vh4Jx5DbGwRfXjoA7LidVgObm/hu++k=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35b88a4f123so2430596a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774332317; x=1774937117; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JEdlrKcdSr700OtysgTmR1jEDaTt2UkGKyE2FtUG4ts=;
        b=ARVyopsm9V9me5aGyXLt9WMFA0K0ZxBr/auDvQ3G6D5Bpp7EyfxJFwWkDDDAnFt9+/
         LB5+7KKlIMq2qDUozv5v2t0YMQM48fiUCJP7+8WIroITOrzixZFB38Gc803EkoDaFeMX
         voOsf032Rm5Yeuy67EjvuQ3VCrm5P6t0TdaHQPMVO+2TpNfQ1ALC2Fh2dmCP0owVY3lS
         R0ya4VKZ2IOQcP2K2wrv8ZRaJSVOK1EQ5/+i9XuYDwhel28O1YJNDdBXtX9vJn4KcbeX
         p0CZCgP4mLRm2bFWVcwVj3Gl+ejyVXx0JHmD8pgWd/yXNcAi+CJ4XhqT+MSqCyuysrXu
         3AwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774332317; x=1774937117;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEdlrKcdSr700OtysgTmR1jEDaTt2UkGKyE2FtUG4ts=;
        b=Qeo8Yt5XKCO0OOvi6PyEJ1wKkc5pdeW5mPrgRd5HJpoQhW/Ke8qbQdzVJqF7tcoPGK
         QHM1/ZGMwJ2l7av6CNnBpgBywBXs+dSEto8vo3N4coc5QXDFThqN8G8LGLMpdJT1u70s
         UawBbXVWKJ5C06f/yTJdMDXBV64aSBEgfyJschRkhRuCf+9LRVUEizgrDMy+LBnrCbxq
         EdNHgrSBN26e4Dkqd/j1KW2DykPbrUnK1J2Z+nLw/H2z9AIPw3LAH0YIoab4AcXf1Awq
         YcX69SRz9iwCRByBniWp/qZqStFQCKmEdEiAeHRTuNucLGjPbRaXwtTGAwZ2uBTTIfbv
         TlNw==
X-Forwarded-Encrypted: i=1; AJvYcCVK47aAJ3dlsUDSLedRBYnUXrsWjasTGTTIAvXmS1EltfN4TkZ/NgZdffz4gom/CCAvf80ZJXeJ/A==@kvack.org
X-Gm-Message-State: AOJu0YzVfDPzMMXgVDVaENjIY9ZcALagdIdGuzy+aUmZrMVVzYzci+Ow
	wSQeIAlaWQizI/InpVYbCel99DXH9iJNiRmd6Tq2TX5I1n2f4/jfGMbt
X-Gm-Gg: ATEYQzwfZ9zIuNY63LY19DKQG9VCzHn32F3IBKSojyP7DpL8jQ6JytH4S3mLGx1hpPN
	og8JLAuxjp9uc05kfPdboYPn26drR8p0E/Te6wPb0+TNqsj+yJkxdwGHMtxXJMEso7JmNrFcZSm
	yE8Uq7WSLFTuO1bgLfeJpOSw376c5WHkHIGk0oTOO2HiYvgMwQzWc1B12YmxbIb1MzjsW+JBcFp
	Cq9sWXbJO0AVKCe6vNbovPyBRMRe7hh5eMp6gB7WQ/5vQYHWTzerC1k4AjtBoEcoHcwd66G2Vrr
	hfm5BLL6rUSwJg5Xi9jC1E8y5zDJOhCIMyXH2GTTUwkqWJkAKBATaVlC6nxweK9jVLqP+NhZpdZ
	QrWqS4M8yZV8hFGZZFk5LIcMQy9z1pe1QMcxKx9cM5+LeluUg/8n/6pZZb/HYMSO+dqIeNTtCAh
	V6jmRQ+eN7iWRCRjzmNMHLZGSb5Znn8ZUNxamyEnd/JPz+NYuyahdgSW+C8ElpwIlQEWK/
X-Received: by 2002:a17:90a:ac17:b0:35b:952c:43ab with SMTP id 98e67ed59e1d1-35c00800a4dmr1211816a91.4.1774332316767;
        Mon, 23 Mar 2026 23:05:16 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c029a5e66sm430802a91.5.2026.03.23.23.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 23:05:16 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:05:09 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <21cnbao@gmail.com>
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
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to
 callers
Message-ID: <acIpMqDADLBVUMLQ@KASONG-MC4>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
 <CAGsJ_4wExxpA53XVb1qZ=dr4kh2Xow-wq1UFYxnCwUwF+S5xkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wExxpA53XVb1qZ=dr4kh2Xow-wq1UFYxnCwUwF+S5xkQ@mail.gmail.com>
X-Rspamd-Queue-Id: 0AA2B12000C
X-Stat-Signature: i37ahdoq1e7sxtq9pkmz6p5ptwmsjh5q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774332317-124743
X-HE-Meta: U2FsdGVkX18PLXVIMprD0yyucR4cNCNn2AOk/sHO9TfQxuKh42AHeQ36+G9V1wrY9uYr1KacJC7QVEnlOax9RPUHpXKkvnOuQtCAy+l5QpDKS9C2zgZOOqxKAhCoB5NZr+pCsDWPObXpuKQLEz2XnrN2SsWUY/QKTwYA/cAlSP8tz0A49/7UiC8ilCdFrehnnIYNeIUHHeYAZwl19wmrS2qm9eqMXXfPUK8GHDnrnv+xPv03qhLC7Fns9N7aFW8Ji5dIKDWIfcsg/WbZkU/Vwcbr2bEYl7N9fIl63uZ0S50jO4LioZ3vO2bjkVgcbNZGYLvzi1bzqDBxWboh6NQgdxa393Y+DZBAYR2/E2e/bpvIW5T96K8p1uEpAakJ5ZLJBB199JUGjMigYZMhF3/llS/fuZCEWJ+tvKdZyXEk652e302tHpqf8VoTa39nU/ibs3kjqWEBtGuaDS/ibBKvRHeUapEdq1vo+DfSAJ1TNJF/fx85k1EVkd47VZFygrt80cqoYOgdzigX0Sa5bGm3uaeCfhkh4sskprVrVpxSaae4jsyk99S/UUyTgz89/wJg8xpgDEcA8UvMEK9iZQCaI3TpqZn13ZD9PQUJx8rvz+ORWt4KckLVlw6Iavk3J3rs5PUqDDvEsnaFXxJgmu19srNQwU6QINdTaMU9i7ISyl8tTlpg19kWiBJ00k4rpd6G8SlZTZH/AeajUH+TCOQb7rGkZ+BuRvZyvHQi5/81BQB7shKHpJSt2pL5DELCiaqisK7vpbed+kOyGzGsbwffiflBQy0kndNXhsXzapIBHr9u8hDGEGLcCbd1Sw35AT6AIBWlFZokrOzhdDwC/dDODcVQ9sACZJl/1DB67xQZouOH+GsSASxAHdD2n4L8SR2/M7xyybIDNS/c30XFrtVJK8TR15dBCXmcPYJgLFPIMcJILuB1YpL+ySXqvS4nymdYf/SrFtyxQDsedGl6RbR
 Akz6P+Tq
 z3gX11LzjBSjby/H25WWuwclktan0A3Ap3kjkyhKsv5s684Ez8xzc924L5Uu++gA4TOzRnlRwbwUP6xxveBJeGCjnj1hRVEjkZ8MtcOjTL4UIKlu1OQUrlaYTHahn7MEsh/AkYFqgJ0b6BMH2TO+pwSDGORRoO3mLsilKtl6O/Bu/PZM3Xq3c8Rg7Dlevwa7fH7cJaU3Qgl0Flo/d+Ne9av0PQrXrzr+6aBd2vqWEOvo7qLzdWF69OyFSJugdDWkZD6NTGGHezUh1nTeELzeXlBC3rSpEYfUJzyNOp9mvIvqE/ltgDX54gPMigoJFtla98WfOspPbdbWWnCAgcN8d73ObTlV6nz+z5C1lpP5AcYIdOMmZjOkig5PODUJq3ZWRZIpRxObOGxmMT3QU+YOAju2Utl2jSLt+2nhk8KJpRzuyovzn5rfEwYKwebNvH1N8K1WmhWzqWDMaD2MEIQzQ4OyZpjhl9m+L29WtFnPpVSZ4ExbzTOoG6hfztFVWGwrxR5fuj5o6IuyElxguyX+amQjIdJbyCfvKfeR9RS6Km1dabW4/UxGM7qnQGkWQ1L7Tnxglk1Q/upotNdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 04:14:31PM +0800, Barry Song wrote:
> On Wed, Mar 18, 2026 at 3:11 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Same as active / inactive LRU, MGLRU isolates and scans folios in
> > batches.  The batch split is done hidden deep in the helper, which
> > makes the code harder to follow.  The helper's arguments are also
> > confusing since callers usually request more folios than the batch
> > size, so the helper almost never processes the full requested amount.
> >
> > Move the batch splitting into the top loop to make it cleaner, there
> > should be no behavior change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index d7fc7f1fe06d..d48074f9bd87 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4689,10 +4689,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >         int scanned = 0;
> >         int isolated = 0;
> >         int skipped = 0;
> > -       int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> > -       int remaining = scan_batch;
> > +       unsigned long remaining = nr_to_scan;
> >         struct lru_gen_folio *lrugen = &lruvec->lrugen;
> >
> > +       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> >         VM_WARN_ON_ONCE(!list_empty(list));
> >
> >         if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> > @@ -4745,7 +4745,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >         mod_lruvec_state(lruvec, item, isolated);
> >         mod_lruvec_state(lruvec, PGREFILL, sorted);
> >         mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> > -       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
> > +       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
> >                                 scanned, skipped, isolated,
> >                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> >         if (type == LRU_GEN_FILE)
> > @@ -4827,7 +4827,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >
> >                 *type_scanned = type;
> >
> > -               scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
> > +               scanned = scan_folios(nr_to_scan, lruvec, sc,
> > +                                     type, tier, list);
> 
> Do we need to change this?

That's a irrelevant blank line change, will drop it, thanks!
> 
> >                 if (scanned)
> >                         return scanned;
> >
> > @@ -4999,7 +5000,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> >
> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > -       long nr_to_scan;
> > +       long nr_batch, nr_to_scan;
> >         unsigned long scanned = 0;
> >         int swappiness = get_swappiness(lruvec, sc);
> >
> > @@ -5010,7 +5011,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >                 if (nr_to_scan <= 0)
> >                         break;
> >
> > -               delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
> > +               nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> 
> I wonder if we should modify get_nr_to_scan() to return
> a maximum of MAX_LRU_BATCH？

We'll change that in a later commit to let each iteration use a smaller batch.

