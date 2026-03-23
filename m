Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1146DF4613B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716A26B008A; Mon, 23 Mar 2026 11:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED796B008C; Mon, 23 Mar 2026 11:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6038B6B0092; Mon, 23 Mar 2026 11:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9156B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:33:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F22BB160C1C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:33:12 +0000 (UTC)
X-FDA: 84577721424.25.DB99987
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id D93E61A0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:33:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DrK6Qlka;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8/EpSUMiobTzSVmJaDTjFNXTjCi0aA95G2967Wvfq8=;
	b=hpjS4k/QquGu0DwO/bDAIOKvwa5wvo/dDAxFwGAMVTMZeICrrbC1f+1eVpRNpGdkLjhBA1
	S+zoPwPiTpGmE6/MeTTDFmxX6zj3zuAvGUQ4ugoxElLEwOuiaVEV/bbbVuSwuGoC8RksYG
	rymhZiy86G7azQzJX4rujodAe6lJJZg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DrK6Qlka;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774279991; a=rsa-sha256;
	cv=pass;
	b=C8WFb6A8aQifbnM/0DVZ9ATt3pEHKObrA0zyPfPqwY/oQeegq+tISlLTZMbFq4pKPPbfQ/
	O0rL+OjLbyyMx2YeKZxRSWCo9FXJLVAvCzNHQUVsyOhQiL8xgV2IxasvRpe9ifI8uoD2ev
	p13jjyiLDZHKmCqZPrmfl4LtPGkdi7I=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439b7c2788dso1899515f8f.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:33:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774279989; cv=none;
        d=google.com; s=arc-20240605;
        b=RVjHSz38hsRkqQV5xqykPCYvSmNPPuYjYI2jcKvwRF7Zj9kGPsMhGt2MOZ3kobCeKa
         W+AE/Q1AM9u7z2DqDgPWuTiqorW9GmUzW5vFeHSabea4AdBoyQmu13gzTbJGynsSWmL7
         gI4Or0D6zOBWD6lqCykWwSLKy3OReUDUe03s72T/vNZpQPbeL28+F7RUpQLIUuedftin
         JeYRPh9RgrjZheSvQJf2Bw4YEeyP78YKcGNn2U73M6QmnCcdCqIlEnkvG65I9DuKfaSa
         QdkDN+WJPMnUCSzLlTjwnAdzAi6L+AQcnbqV8XZjNgJrfphnY5ks6zNOoVUJnQYl5Vks
         a+oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/8/EpSUMiobTzSVmJaDTjFNXTjCi0aA95G2967Wvfq8=;
        fh=WMx2nM0oLLZHvG3SPtIuBrTX4deXZG62/mTivQl+La4=;
        b=Myv6fFbWp8SZewiR+Y+FDHrF2Rz7JmLdjh7afPNZEZagUpt1ovZAODWiVGpnw4UYTm
         GZZhjECdYZ8hlHqfuBZI83P+DoDS6g6CIonxqJUdPphWYlXxLDFVJsQGvr0aAwpdPt+H
         m2sr8bxAS+4q/ipkvnhq75XrBdNhxQkao7MJl/xBhpHQ6uSt2Lh+AoG603djN4YThfNr
         qfC+nTuKFO4f5BPhVcuM0+F6heA2/NinUQku+XtL4I34EPNOn0yCsJJNNoNGFI4TSSL0
         LIQ48YpRvXPqC4tBeWMpQ4KeKtpu2OR9bIj6R1iR2jZLECsIIbCJtV1gLBnjOq9VZQB9
         mDGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774279989; x=1774884789; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8/EpSUMiobTzSVmJaDTjFNXTjCi0aA95G2967Wvfq8=;
        b=DrK6Qlka0KrKnVZ4IKe2pRnjvsnQ9wEUzMP01xPDkxFsN0QjucJs4JrLiv+7chH7vN
         rISzF1NkZV7HuAdvgBM3RVR0hgARIuVYvJ2A7Tqo/MoHAJs0B6rFqVC0eh2xUGNZyWtA
         1JggJl7Irv27mEdNvOr3diMYubt3eRxxd6xkJXWSw7G/Q+Ipm1EfclKcEoCx9BDEVeAO
         Oy2AIuGJZTpAet4c5YU3AZ8YE6fw2GXLeZKkh1kTXSf5pAZR4oc9iL13Z0KeOcDGrp6G
         KODb5kfRl4f0f8IglfUPap83ZjC893q/SfoE2sO99gJe3OPW3v5InQFt3VTNMZ9vGDEO
         z8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774279989; x=1774884789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/8/EpSUMiobTzSVmJaDTjFNXTjCi0aA95G2967Wvfq8=;
        b=bAMRY8/2j0hJtpIFbWqBgXL9hHHcnyIymzKtsGXggJtMATETGY0L9IPK4V7C+/L41T
         OgdfB0zWLZ+YeAjeYJJqfmWRi5w4y8ZhcYthm0+nv+ALhDL8bTHFBXJqgH9bLdWkrEaU
         IWtCDfLEkEoJ7Em/+SLjyd5bgl9hsWXOZDCcjhjKaiJfnVy08mLpnH0qfveBGSRy94N1
         fb2qVufybbPyrLRFFB8qAYKF75Lf8UfbjhbFviAWLBmALCSAmeBUcawocBa3l+zWyfbm
         dYgG+sll/k0GoSAQ77Ocjllwy9L1QPQ1xJX/a0IlPL04V1YH6Rj+FsQG+uUKIWY3HsgB
         ps8w==
X-Forwarded-Encrypted: i=1; AJvYcCWkd2vCCBCH+FNSWXpTNmJccN5F8RaWB+/pVU7HXSpX9hhKcILLSFJr6CasQfrMTHPjKTV1LXaciA==@kvack.org
X-Gm-Message-State: AOJu0YzV089Vgn1HYNzO4GvTlpLTNjaA8o4XaZIEB7Y8LXoeG7oFGlPC
	Y6jJxJtTQdd0OlXUNPE/tpA7+u9km3MLnKrUceLxuBqb70coZG9Q5ZbIeY/CiCl81h3ju8gsspH
	WGj0dtY5bCmw7+s4bTioms6siAnipSko=
X-Gm-Gg: ATEYQzxTpNFXoA/tjlgxkpBYXgB9lUgHaF7fZJbRljflGNeQi47z/Nope9Higt9cRKu
	uRBrluCnn79QqIfPztUOd2yRSy/k5I8MKIU/UMqY3augakECKwGVuc00SIA7SUZlNLArFdKTHb+
	xmggZ9kwXa3sQ+ejfgn46DJRCsNy/nPwJ4hrGcJDsvOvKsI1vdgG/CIScoU12pb3lsaolzPC0oS
	/T4EURP3c0LrN1CkhHzqoMn1OLZAZYj3nZs6Xxih++GiJy1boPfkp76Tg8T8o6IAvcT9OdBJOdZ
	Ie2BVW+EXN9DlvYgIwc6o75Riql0+DghjksZiTjKR7Kp3h8tGhn5
X-Received: by 2002:a5d:5f84:0:b0:43b:4703:9de5 with SMTP id
 ffacd0b85a97d-43b642870f9mr18306704f8f.44.1774279988876; Mon, 23 Mar 2026
 08:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
In-Reply-To: <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Mar 2026 11:32:57 -0400
X-Gm-Features: AQROBzBAs5nRbrIlBu1cKcNEaCz87nNyEV8cMyR6rMkBGG9vg_P1d2ioQYJMLuk
Message-ID: <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D93E61A0008
X-Stat-Signature: 9xij4qs6udub4dpdo3b1ysixeo8ust5e
X-Rspam-User: 
X-HE-Tag: 1774279990-398777
X-HE-Meta: U2FsdGVkX19hXZPdQSmRUdn3jjlR2WOfGF/rN4TWxdXqMqC9WlLi4UFLJSDkkQtVvZ+WjUj32DgmktAmaZX7kPyxBSMRuVApINfV2+elLgCqMqWUdu8YmzzrgEJWIP2kapaeMiENTLxjo/VdjuGPeuHNW3AiiFpJ9j5qfalCcoXtWtjfHOLMJ3SJSzyycdV11w1idecfi9a5dLQP7JGOViRfqR2ZoDHERfVEfpcP5Uw1TucCbZgheu5D/3/BHn3XUWTrream3ARSvY1Wi/ZQqchE9A8VTgp29oGruZ65eRdrNPP8E3CajkZa0gc9NV3K8UI9ETrRexkgAl/CS6Plg2xuPTpWK6aKcPnRNSMZY40/XtW1F3Td5AqlVCTrNNEDLiWpv14HJ3ObktMS0gSORaZwgvEDdvXN3BP7UmplSNag9TvXXTIPX3P0Crh48CaZVLguJO28pwaC93zBgJZPfLtpmcJ0+bUp6yzCf999xi9egFDVp/9kP/WK1rfh+p4BmuroZN5zujqI9TIrKzbsri50/ouqEcXg+LSn+hS4J2PS2pMkjxYBpGAqgYXHBK4J6SgrZucNEBQFMQO8qUbM/zrLkUfXQaZNA6mRRpmioaTZgTHPpEUVtWg6ti1yfPuFlsgpK19LrXyZslph+jF0XpuYw6htKQuTEtigPFECZG/8qnY8s2cdJ7YrxI9Xq+v0sf28nZiDYo8edlFY/vnqnY5s2hUlraz22Ms0YXj3pVQMIsReYT1+tYRIJ2Csnopv/XD+76o3/oZzUWuOe94Nzth/CvLrduup4R9JvVBI6YaO8XUIanE2mWXWKyKPL5uYrBaKPdvnfr4IhpbYt0T8/FUKb9m2gnDXINQPMm45/n2MyCLlH1D4YkF4KS/6RLhV6Kh3ITyUEvG4q0s16KqDZMXcHD/hHnxWa9IvTennj9rsjSrJYw7diOE7qhWwWhHU9TfkMOIU+3x/E+9vAUN
 PMEN094B
 KJfBUrUA4RnnWa8DGQBQomiuGvF87GMqv1YrDtR4rCDV0Cy/QAxgNEqBW6haBfyUlV2uBl0viI+nhHGqPP2CnXNn/CMo3B4sZiLYCypRfp5AyOHyfd7bFNbD4dsQDbxoKHGZDxIpa+tOrPxyLOLVsuzpoZYQ3JplhOyn+y10VMWJfUjCI65De3yLTbx+Kpa2kLgbx9GqEn1+OmcCgmgWOzPFwkcXmGuikkvTnrgfYNQjGVGpgj0FqbchdUsLY5f5tEc3CblQrl9ADNrhxcwqzZFhC7E6Z7zPnsicruSOCt29oCs0gmuW3vSzRy5eR/m3KZRLuQmrSDHfs4HddGZs25brVeaQerakWMLl0OPUhHYh+9YPUPvSSKbRfXdo2qoWhPkm/5ZbFlZDNuOSJZ2vrvDRBAAs1eoRcIYYNi+fNfWhBrabquDXlZtwTHZNCHBlq3CgncFQ72nEzrXjOrZHVNdZ8WliIc5tU7FVU0kFT/vp3tuoLMOC9s9PIuOVhqZd8j7VA5KP+RtmrzrTO11bbXj9KCNbyG3r9P9I9L2XtY51U4deJT/q7iNfwcCWi70wXEaDu270bO2t7rCqTq0EdoJ2Pr/l3tiI2vDOJssafp27Bf9Aq8RoSaLHnjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 6:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Mar 21, 2026 at 3:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> > This patch series is based on 6.19. There are a couple more
> > swap-related changes in mainline that I would need to coordinate
> > with, but I still want to send this out as an update for the
> > regressions reported by Kairui Song in [15]. It's probably easier
> > to just build this thing rather than dig through that series of
> > emails to get the fix patch :)
> >
> > Changelog:
> > * v4 -> v5:
> >     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
> >     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_held(),
> >       and use guard(rcu) in vswap_cpu_dead
> >       (reported by Peter Zijlstra [17]).
> > * v3 -> v4:
> >     * Fix poor swap free batching behavior to alleviate a regression
> >       (reported by Kairui Song).
>

Hi Kairui! Thanks a lot for the testing big boss :) I will focus on
the regression in this patch series - we can talk more about
directions in another thread :)

> I tested the v5 (including the batched-free hotfix) and am still
> seeing significant regressions in both sequential and concurrent swap
> workloads
>
> Thanks for the update as I can see It's a lot of thoughtful work.
> Actually I did run some tests already with your previously posted
> hotfix based on v3. I didn't update the result because very
> unfortunately, I still see a major performance regression even with a
> very simple setup.
>
> BTW there seems a simpler way to reproduce that, just use memhog:
> sudo mkswap /dev/pmem0; sudo swapon /dev/pmem0; time memhog 48G; sudo swa=
poff -a
>
> Before:
> (I'm using fish shell on that test machine so this is fish time format):
> ________________________________________________________
> Executed in   20.80 secs    fish           external
>    usr time    5.14 secs    0.00 millis    5.14 secs
>    sys time   15.65 secs    1.17 millis   15.65 secs
> ________________________________________________________
> Executed in   21.69 secs    fish           external
>    usr time    5.31 secs  725.00 micros    5.31 secs
>    sys time   16.36 secs  579.00 micros   16.36 secs
> ________________________________________________________
> Executed in   21.86 secs    fish           external
>    usr time    5.39 secs    1.02 millis    5.39 secs
>    sys time   16.46 secs    0.27 millis   16.46 secs
>
> After:
> ________________________________________________________
> Executed in   30.77 secs    fish           external
>    usr time    5.16 secs  767.00 micros    5.16 secs
>    sys time   25.59 secs  580.00 micros   25.59 secs
> ________________________________________________________
> Executed in   37.47 secs    fish           external
>    usr time    5.48 secs    0.00 micros    5.48 secs
>    sys time   31.98 secs  674.00 micros   31.98 secs
> ________________________________________________________
> Executed in   31.34 secs    fish           external
>    usr time    5.22 secs    0.00 millis    5.22 secs
>    sys time   26.09 secs    1.30 millis   26.09 secs
>
> It's obviously a lot slower.
>
> pmem may seem rare but SSDs are good at sequential, and memhog uses
> the same filled page and backend like ZRAM has extremely low overhead
> for same filled pages. Results with ZRAM are very similar, and many
> production workloads have massive amounts of samefill memory.
>
> For example on the Android phone I'm using right now at this moment:
> # cat /sys/block/zram0/mm_stat
> 4283899904 1317373036 1370259456        0 1475977216   116457  1991851
>    87273  1793760
> ~450M of samefill page in ZRAM, we may see more on some server
> workload. And I'm seeing similar memhog results with ZRAM, pmem is
> just easier to setup and less noisy. also simulates high speed
> storage.

Interesting. Normally "lots of zero-filled page" is a very beneficial
case for vswap. You don't need a swapfile, or any zram/zswap metadata
overhead - it's a native swap backend. If production workload has this
many zero-filled pages, I think the numbers of vswap would be much
less alarming - perhaps even matching memory overhead because you
don't need to maintain a zram entry metadata (it's at least 2 words
per zram entry right?), while there's no reverse map overhead induced
(so it's 24 bytes on both side), and no need to do zram-side locking
:)

So I was surprised to see that it's not working out very well here. I
checked the implementation of memhog - let me know if this is wrong
place to look:

https://man7.org/linux/man-pages/man8/memhog.8.html
https://github.com/numactl/numactl/blob/master/memhog.c#L52

I think this is what happened here: memhog was populating the memory
0xff, which triggers the full overhead of a swapfile-backed swap entry
because even though it's "same-filled" it's not zero-filled! I was
following Usama's observation - "less than 1% of the same-filled pages
were non-zero" - and so I only handled the zero-filled case here:

https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.com/

This sounds a bit artificial IMHO - as Usama pointed out above, I
think most samefilled pages are zero pages, in real production
workloads. However, if you think there are real use cases with a lot
of non-zero samefilled pages, please let me know I can fix this real
quick. We can support this in vswap with zero extra metadata overhead
- change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
the backend field to store that value. I can send you a patch if
you're interested.

>
> I also ran the previous usemem matrix, which seems better than V3 but
> still pretty bad:
> Test: usemem --init-time -O -n 1 56G, 16G mem, 48G swap, avgs of 8 run.
> Before:
> Throughput (Sum): 528.98 MB/s Throughput (Mean): 526.113333 MB/s Free
> Latency: 3037932.888889
> After:
> Throughput (Sum): 453.74 MB/s Throughput (Mean): 454.875000 MB/s Free
> Latency: 5001144.500000 (~10%, 64% slower)
>
> I'm not sure why our results differ so much =E2=80=94 perhaps different L=
RU
> settings, memory pressure ratios, or THP/mTHP configs? Here's my exact
> config in the attachment. Also includes the full log and info, with
> all debug options disabled for close to production. I ran it 8 times
> and just attached the first result log, it's all similar anyway, my
> test framework reboot the machine after each test run to reduce any
> potential noise.

Ohh interesting - I see that you're testing with MGLRU. I can give that a t=
ry.

I'm not enabling THP/mTHP, but I don't see that you're enabling it
either - there's some 2MB swpout but that seems incidental.

Another difference is the swap backend:

1. Regarding pmem backend - I'm not sure if I can get my hands on one
of these, but if you think SSD has the same characteristics maybe I
can give that a try? The problem with SSD is for some reason variance
tends to be pretty high, between iterations yes, but especially across
reboots. Or maybe zram?

2. What about the other numbers below? Are they also on pmem? FTR I
was running most of my benchmarks on zswap, except for one kernel
build benchmark on SSD.

3. Any other backends and setup you're interested in?

BTW, sounds like you have a great benchmark suite - is it open source
somewhere? If not, can you share it with us :) Vswap aside, I think
this would be a good suite to run all swap related changes for every
swap contributor.

Once again, thank you so much for your engagement, Kairui. Very much
appreciated - I owe you a beverage of your choice whenever we meet.
And have a great rest of your day :)

