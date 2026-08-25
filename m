Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7D3C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B586B0096; Mon, 24 Aug 2026 20:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642546B00A4; Mon, 24 Aug 2026 20:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558B16B00A5; Mon, 24 Aug 2026 20:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29BBE6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:24:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEA291C0F5B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:24:04 +0000 (UTC)
X-FDA: 85137894408.27.C231EEF
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7B8740003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:24:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dcvPhMdK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
	b=eIZGUkyWGXDojz4hTTBgvr76l9r0I5WxQ/VdSJptz7MNHGjmt99DhtslNn4B1ygyNj0GjG
	i0BgMAN0BgsGvwUeMjQSQwqOYViM9/GgMfgmQDBrAvYQ8KfmyYQMHxTxxEh0sB76HSBzL0
	Ts3UQ3fVrLIik5LMsTKKZ8/GrO4hKDA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dcvPhMdK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617442;
	b=zsqB2+9p4CdxdoHq/EVc20I7a5ZhkkdVsmMpi2HepZx85zXAN5tasbwm654rhlXeb59s0q
	yaToNCLK5lYQan2ecv37BCBnZzwqGZDl9sSisOWwFbR1v7yIitz8dz6UGwgqsVJXHBlzI7
	Ix/zh8s75Hh6sFBwOiWfKTDCceWCDHk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso37783055e9.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:24:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617441; cv=none;
        d=google.com; s=arc-20260327;
        b=WKwh255qThnod4u+Xs1Ie3++3NJ97tQjHpbufRZQ0je3F4/SyenlvUUNxu3qlrhjHv
         GR+DkkLQpnqYbiICFXd5epgKNKShGihIlAFOLsm7XSGHcDyXm7/JgOjjewYsw/dlSyGx
         mx/RCrbpiP/03njm8Sm2qv8lCGHScn8YXumWhB6FZVnjIA3A8mP/0pBzVkKXY835G9ej
         qZ7nzteUmNTPRw6lks9q3NeCdqKT9f6rrGPPN50P05BArEoxMH2UL19uUyw6Sr5XWSWh
         9mScOycXKFvRzFpOlB62vqLMcMB23PhJzj/P6bKBvTV6SiqVDayNmDT6cCfVxSPtCqts
         VRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        fh=JtZKATEsS6uBmPQKOtNXQLDpeNDtgZOjuGO9bI5oyBQ=;
        b=ZX9RQxf4O7UBv4b6obd6T+1QW5xXGeaTDaKIfDDPzjLsfbICx7Xw8bxM+1iius61Zr
         OQhKWY8pcn8JUDZi98RyGdNLo1odDpAF4rqDdISyUr78Zp2D4/+Vp8ovzq7f/kwsOHQJ
         A8JlFmREEaR4sRc4d8Y4y5cTqK8uF7P79RSK/Pvtg7nAqVgtTCsMFO+BYjujpE9hCZc1
         gZQMYY9Ihq0CV0wRgW66vtMdQKN5AFRJbH/EXcTRSQuKMCFweOCzWY+Kfh9QiwqVWMn4
         GGEd76XKqKEc+0dD9WZPPadgTnjrDp3DFzCIjEZwJiFuo1IOQPO5wSWpdglK5LXy+D1g
         imFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787617441; x=1788222241; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        b=dcvPhMdKh94j/VBqAZQdm8XKgOKJRtD3U49wdgYD0VfJTE/AFS4+HNwCcPKh/UKRo/
         SdxGR8JRk/Cj8REjG+5FK4sQOCJ1Pq68AEHR5Pho7Hud48J8yXOJCf8XEBh8h9MgJmU2
         FPc+P6uWN1yXA2aAJ0T7w4Zerb5nHXHAJso9y9bIf0nVqMMTEFIXgmIbeOk/gnlEjlT9
         AdMUSo4p31nFfqgb/KDgsnCEuGeHscsxQC+ZAg4NvmXqKOvPEQGO/nA3BW7CsGuXGF5e
         yHIqX56nt+WNutsRednLWXAor8vtCkd/cbBzL/7+nQR8UGpXFyO7RD//OLFc1UZHZnTz
         rWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617441; x=1788222241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SM23yOgiB3MFJPRmlHg0vJfTbh4NbcSvH9yKFOdYwW0=;
        b=VuTNvdq7705e6HAp2zc6sNF583YlQkVewxwQudP1E79eZGjzFtMJe6/MmP3v6dD64Z
         Nt0TwgfuLogaCZpHQC+5z8fSrh+vvQXvRl1BuDZA/5YuWtbG/ZmZHxVV8hFMDOSA5n8n
         zGWph7Qg0Z28cGrcodRqp4DFKXgPhrOJ0i8UDRL+LNRZ2GhjRo8IJMVVt0wuvF7bFhK0
         RpyruKfMMcvYtK0JQTj0BDHJ3CoffqdbIKCtrsRfjHF9pHD1OOpSMZILTGsD9vL9E1v3
         8XOPO24e4hYiy8oPjwi3yvK9zaxozlQvcDLkz6Ni2mKivLD5vQm2ZlmrLTPp5IZxuEmt
         vOAQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLXMGZy+hWV+P+u9M/uYK7HPok1ajbE64pEPI5IjYNsvVAfp16M7ViLVDN0DFUhJavYfHICMC0eg==@kvack.org
X-Gm-Message-State: AFuF++nVvDTHsFAk+K7wlgezc9t5dRtPLrl8QvPLjrZFYkXdUeRFS303
	60Y8Vc/d4EplDlSv9fIizJexK5b7/1UedaPoNqVG+jsK3cHYaejuwHgYLpky2uutaU3YudeSf3B
	kSTMGUIWMI5JvfuNH7MsjT42jEvhemE8=
X-Gm-Gg: AR+sD13Uv92vYRlomjjD4XBX7rKsCX1PPMrgnbaWoB7aOuxH/VhMZl3M24hiCCXoFaa
	azMSB37OqHRcUAn+ix7E1bHl816roeV5IPQhtw206YqNJLNu1yRURBwDHOMrand/7XZaySxR0Bf
	gXAT9sB7g3x5q9Wasa1LDxZJPZ2EONEOTzwTacKYU6HZZn+zPZILR6Vdvce7KUWRT6RgnywBVXY
	9EXTBc1vKRghDdzNYfCTxKTEwJkAkvEqnKKBsEnz6eAVH0rhCPZ/kofbQ7QaUkqd9n72ahZruet
	6kke5vZkBqBTcTNuswSfpadxos3UsGbAqlxp5oASmzZOVjXje4dGggV3wgR1rMWlhvfNXaTJwBB
	LEaJOkU7yJRSsB0VR9leN1kAOrPYHqy8dl050/g==
X-Received: by 2002:a05:600c:800f:b0:499:a5fc:207e with SMTP id
 5b1f17b1804b1-499d64e89a1mr29445385e9.8.1787617441435; Mon, 24 Aug 2026
 17:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 17:23:49 -0700
X-Gm-Features: AcwNN1VvhoQUdKysuMaaEXxvbCegYlGP-f6bdSnaoNT-mW2XzDOEHtfE4jJBGi4
Message-ID: <CAJnrk1Y-ZaT_3QGZBc_RRKM-rJdEsaaQp20e39Omwh5nv_Lqag@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ws6niak1mxzcpu9z3m1cdntttx8skdpy
X-Rspamd-Queue-Id: B7B8740003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787617442-636043
X-HE-Meta: U2FsdGVkX1+/1mqRoRGspcUUg9bpe0Fy1GmJxl3mDhQyIQQeeuBDfUrKwL+LZL8VWacTaBj7++GKbpSHluNxFMUotXb7O4uQnsc/rwevy0Fyf+eUCRtd78t+3/ogiqtP+2eNvS5zYBjwnG6F5VMq1dfg81uZElfwmVtQgGdFSSteEJLK6olGogc7vkAH4rXelTmS+yQeG7lrfZ9jvorY1d7jKrxnu2Cwdjch2EswiwFtXxZYkqEQn3VgBqEi7jmbj6NR/siGXldD/YzBR4jGL3/2qjbsPPuoArvoO01+w4pscOY3WRJM4q+YBi4BAbnqq6YTjdCxYhISL9TeR/YuII3dDo61OkOliDPzq1k2PEQPQCsHzRTM4t5Xz5D+8imJk+WeEqoKnBAuwVERr4fYeLK0xNZxmrtt8ATEunY1KQbS97FvzAnUHCYZZIGEFG3OgHPumbN/Mt6eZ6cRuhjURP4SsRynBlbt94bmo0Cpuag+Iau7xMuvgGqDcthWX21gQ3zxMckSj3GMcBH1vF1oTTgFDyBbyZMvSqJACQWajsIBSMNMn8QyATdaSqLp5C4Oe8tjxBKJbfcZNOVMTgGbL25CkFABC7L/rvGxyhynumeJOCHQB7ivtIfDaqehxa1pjPb5/iIw5XThGeYUAaq9hsiXwFIkx54TYV6A6JLxTNPy4RsSxQNVdEFm+T/0siogzdAQ4m9meB7m1fyiv5FrcO8oy2ujDvBdBoRNzZlR94mzjqEmcfxuS3D4gp1AIeswDDRbzJwXSCUlk7mIEMff76SuJoN7YVDlo/euHOGcnNJWOKxj/J3QBi3ON9DGyB6ooLlrGIzJ/PFqEiZktmpdBXtgdP1Lptv0l8JVER38X8HbUnlshAqwN0y2IqcZWLWiVU7yo5JWSnlAgeMV+Nneg3rhpmcL/aKJEQT1Dr/qkWREHFnnMvIAkUV7vIAQwRVcU2InejCsOGo+XnMRaLP
 S2mg3QFe
 kpMXbGc0odWCymYrtpLaN1ox5tX56pKOYhtkXgV2Vmstxvp8XvOZOREEAco/xLJI1q1YvmNqQvCT83w7fp5Bb60N4qc32WarrlVHyPpMtkQ16R+htd0ywbW0QqDdBX+cYJIMpybyc1MGGtXzQgGn64M763+2LRojEA3Nbo/fXSIp1u/PfLompayb8vYwDZITqB2j2g1IifKfnI6XYf3Qyu1Q/kMDYrL+mDx85BA+eojJQ95NahPrbT864+Vg7Oxh6h7fAWJxg8ZCrjWJ7PNKHk+QtDWBkFZpai6cAdKk8Dm3HLiVN6tp/UbKPlMhrW0kgpbcdKWnQFt7gifIUbgajmaRl/qupnPgTlngJzumNfkIWxTvKPn97TqN/KsWwQPj9MAyxrAOrMW2qEUJu7WluPgBHHK/jpJYQYbmpkqbArsiVmbTtFkZSXOxcVGDiTiX24KJjFRzusPcwVoq6HNGaoeazvhiuKc+I+zJLAYZLMtKAXvSB7Qjj5h6R0xgU2ifkndzHFvt+Q7JHU81JBGcX4D+BZwZLVv4RZPbTvqcDDoAP2Ww55EVEmNq5SNoUPuaXGQmLVvDNtUljox4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 2:31=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Thu, 20 Aug 2026 15:18:39 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> w=
rote:
> > > >
> > > >
> > > >
> > > > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes t=
he
> > > > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which sk=
ips
> > > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap stor=
m
> > > > >> with zswap.max configured, a container takes the global rstat lo=
ck
> > > > >> on every swapped-out folio.
> > > > >
> > > > > Any reason you are limiting zswap through zswap.max?
> > > > >
> > > >
> > > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > > can soak the pool and crowd out the others.  zswap.max is the only
> > > > per-cgroup control over that share; memory.max bounds the total
> > > > footprint, not the share of the pool.
> > > >
> > > > >>
> > > > >> zswap_shrinker_count() had the same pattern and switched to
> > > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count(=
)"),
> > > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > > >> kernel cycles under osq_lock on a 96-core machine.
> > > > >>
> > > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > > >> before the patch and 198,968 times after, while
> > > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > > >> attempt count almost exactly; the remainder comes from other sta=
ts
> > > > >> readers in the swap path.
> > > > >
> > > > > This is a known issue. Using ratelimited interface also comes wit=
h a drawback
> > > > > that the kernel may react on stale information and the consequenc=
es might be
> > > > > unneeded oom-kills.
> > > > >
> > > > > There was orthogonal discussion on moving zswap limit enforcement=
 away from
> > > > > rstat. Yosry, any updates on that?
> > >
> > > I am not actively looking into that, but Joanne was looking into
> > > AFAICT. I will respond to the thread there and CC Song as well.
> > >
> >
> > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > (switchable behind a runtime knob [1]):
> > a) rstat + forced flush       (baseline aka what the tree does today)
> > b) rstat + ratelimited         (Song's proposal)
> > c) hierarchical per-CPU   (Yosry's idea from [2])
> > d) page counters              (following what all the other memcg limit=
s do)
>
> Hi Joanne,

Hi Joshua!

>
> I hope you are doing well! Thank you for running all these experiments.
> I'm not biased in any direction but I was curious what you did for the
> page counter implementation. The reason I am asking is because I am

Thanks for bringing my attention to your page counter stock series.
The implementation of page counters I used for my benchmarking [1] was
unstocked, where it incurs an atomic cost per charge / uncharge
instead of doing any sort of batching/caching.

> working on making page counters more scalable / performant by pushing
> the memcg stock down to the page counter level [3]. I wonder if the
> caching that stock provides can give (d) an upper hand over (c).
>

I think caching the stock would definitely help the update cost of (d)
as you point out, but unfortunately for this zswap case, the nr_cpus *
# descendants * 64 max over-reporting the caching would introduce to
the zswap stat could lead to overly conservative rejections of stores
that should have been allowed and/or OOM killings for cgroups where
zswap writeback is disabled. Thanks for bringing this idea up though -
I had a similar idea to this with batching the per-cpu counter [2],
until Johannes graciously directed me to commit 2d146aa3aa842 (mm:
memcontrol: switch to rstat), which had switched from per-cpu batching
to rstat precisely because the nr_cpus * # descendants * # batch pages
error bound was getting problematic.

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35fa=
f58c33b1d7c9b
[2] https://lore.kernel.org/linux-fsdevel/anpsLy_pCanocgS1@google.com/T/#m5=
ed6ff8e64eeb909ff3c92bde5105406b1ddaf10

