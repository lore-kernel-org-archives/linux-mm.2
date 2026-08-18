Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB7DC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B35C6B02D1; Tue, 18 Aug 2026 14:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489CD6B047D; Tue, 18 Aug 2026 14:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F7D6B06E1; Tue, 18 Aug 2026 14:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12EEA6B02D1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:35:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99047A02B0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:35:22 +0000 (UTC)
X-FDA: 85115242884.24.9BFB9F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C23D5120005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:35:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ie1glb95;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787078120;
	b=LxgMLvsXhZ4LX4who58wBvhHXfhkGWaYWjBFSTMNoumcpMh0NIYSuR/lbOz2dQy9cR3x46
	4JnQUmcIwLbybbMkzriQQHGiTrIXF54s5glyWPY1qdarlhcfAAAItOPcqgCie5ErqRXK5l
	sfuj/eJayk7Clav500Ead4q7EIQHFYM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ie1glb95;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787078120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nD9alVem4M7AVItlV4nlRl6Uyfz7vLLSdNxJ+Yr1jCA=;
	b=dxW4pPjRi+smzLLNIbs+Ol7JXMriWBhwF+2QbdoiomAQuebh2i0Cfpe+i13dd4kZcF0zsf
	kmlRCwgM0mlwY+1ze541DofiGXvTQxlm1Fq/4uMAjg/940/1PHBIonpzFw+qVODVuasae0
	46IXGew4rRPCg96jrMuwj+ZJl6r0Ljw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BF760204
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9701F00ADB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787078119;
	bh=nD9alVem4M7AVItlV4nlRl6Uyfz7vLLSdNxJ+Yr1jCA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ie1glb95zaKBXlAb+RIz+qLby/qvHHBIXjQPQpf/Yb/lG0bftM8DJKG7jfyy7Rnj1
	 KsTrEhl2hhLcuyFzvLcYHEyMPxivzsEa2xC9Kq+k81NI3FOJI95D7sIYokTPTd4TBQ
	 /k90gZljqGygUNrwU7EpTXB5V+TyVgfKrLiLVLv+A7Opd5uTGt1KfW5rcG15SrRkY1
	 7xnwNhJJcoDleiZVAu1VGYZztB5G/k62h164N7gh4PAcMokq6Z7x9xPppobO2N0N3o
	 H8penjN1DDYWN7qLmMiJEYvmoGC5a1N8Cu+6p5YHJymdQRf/KBM46scApsWP+roR07
	 NGUyW5hDOGLwQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so15208266b.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:35:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr6sbkE86U60JGRrTVsYva3Ysgqgo0h7iKVca46hmw2T5yJIvnDbVCfgUknV6kL8BDKYXh8H1xmfg==@kvack.org
X-Gm-Message-State: AOJu0Yzk47qc3+U6TG0p8wd47Uc6HyiwGRODUwTKE9mfcTv/ia3LvLZD
	vhkBjhu9l3QLbv88ISUzQIhYjir2FxHrZD7ED0I1k5lrVU1MGsbaRE1J0/M+7BtJ0cH9CspHhlE
	a2dea/vCMxfJLqwBlzE9gErlnhx9PeZY=
X-Received: by 2002:a17:906:9f90:b0:c21:72b:dec0 with SMTP id
 a640c23a62f3a-c2216dbea77mr29484666b.5.1787078118783; Tue, 18 Aug 2026
 11:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
In-Reply-To: <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 18 Aug 2026 11:35:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
X-Gm-Features: AcwNN1X0fMYlCQhwIAy4yXr2cG_a9NPX56FNrRgmFSglhsymz0fEqah-11M1DVE
Message-ID: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Song Hu <husong@kylinos.cn>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C23D5120005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xhqrzy1c1g1adjuf7gc58hbrcqaxcaba
X-HE-Tag: 1787078120-170924
X-HE-Meta: U2FsdGVkX1/heKC9THhYeHW4Ckj6qBleYszeTJaNz1z7cRQxOehUxUbLyspllrISS64A4wUT8Jsn8cf1V7Ko4U8mNiYBfoMjK3v3ymyDRk33IhVHu5UC+Xp7Gv/8a7NijB/+1BEIYJJDzgV9pdy7ZIV5pNEk6kw7JXHEYN6H8uywjHQjocapDTdHuHe96zATPn8s4/EwIEn8Omq5E8nHeD6OWS/5ekRHjhM/UTtc4vQd3pzr3AthBALSZsPJzochrZdJX/D3yojqLJ59+8uglV9/Q0ZRZlpxdUP/FSl6nuVtJ/Oh34QAo9NHke4v2XFLPPdjWJ72JkkZCe8EZUoIf7pZh5o5g+EfkYYL5Lei/PGV/uKZ6hllQ64NnSJLw3/AITUDM0ZSW3dxUovfNjqDXaDuszPHY065aGGh2qCIPxeqlag8n+fCnZXDp/G9DkLpScxTPvNT8r5MeBLxZDlrJsmeVR/dbX+UG0psmQXjhnMEgdXTWgPpuw2HglQykwHY3q8W9cLMTYx8ziJJ+2KzoD2TdjHuSKB//ZyipLdRp+LgV5y75YsiiEv+5js+yh5DlaEMQImSanKMRXJbrQIR4riwwq84WdRQDKpqFWfPAR5Owu6gn2ADzuqgOwamrZnuezmDO91ZO1MHhI166sxbf3oxrQ6FR8yok9wo1yKQo9eE9S9AtGOkel1wIs2LjJj6UHO/iRgp7wTAWs3TJfzYmlxwCe7K6pA089LNPX34ijTGeA4PgMzu27L9lupdpK6+PLBVwiaG+NVBdIGMqafUnllsuC1JMGbjnTdR276ogUGv1T9J81rDp2iAVOqmLCWl+ml0194jPPz6gtaEEAgaqIml/tC24lyD/FiNk7ZURALkM6nx3P5Af4yO3FbqKBITUBOOgeDO2tVdUOEROFj1c7hItzVD5N8jRAm69kCwfFGI0LCHSSmHO1R8GkRKRNq0oA+mmBAGBJnJfQyu96K
 mSmzyh8J
 qIQZpTsibbalAbWyAR4LzysF4vDFYptbqGD0DymieT2yBYOBHFqQFCyyo/F9T5iSH/jvXKkG9hxi1+6HTTIJUfQA9Ptb6nLK+013/bsBzR7EjHJ5K0fCSjMZpo8NkyBUAWk5XvD+4jaKCP0zsy6+Bn8bTgSU34JgIZQcS0JJ4/irQ72Yzh+ymhhs4oFCInS7SN1hF7E/ea5ZuLvre76X1pyIEEG698fB9wJwtOQDqq/X0f4rihTugyJuMlMpO2Uejp12+2MAFecDllIl4fRdyKDP0TBd1DeegESRqkV0ajW/6XMSWkiLdP0Nxa1EuWZGQqOZ2pOVsDqJbBoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> wrote:
>
>
>
> =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> >> obj_cgroup_may_zswap() runs on every folio swapped out through
> >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> >> cgroup rstat hierarchy synchronously with force=3Dtrue, which skips
> >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> >> with zswap.max configured, a container takes the global rstat lock
> >> on every swapped-out folio.
> >
> > Any reason you are limiting zswap through zswap.max?
> >
>
> Mostly fairness on a shared pool: zswap.max_pool_percent is global
> only, so on a multi-tenant host one cgroup's cold anonymous memory
> can soak the pool and crowd out the others.  zswap.max is the only
> per-cgroup control over that share; memory.max bounds the total
> footprint, not the share of the pool.
>
> >>
> >> zswap_shrinker_count() had the same pattern and switched to
> >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> >> where the same flush on the shrinker side showed up at 2.88% of
> >> kernel cycles under osq_lock on a 96-core machine.
> >>
> >> Measured on a KVM guest with a swap storm under a cgroup with
> >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> >> before the patch and 198,968 times after, while
> >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> >> 80,445 times after.  The removed 200,572 flushes match the store
> >> attempt count almost exactly; the remainder comes from other stats
> >> readers in the swap path.
> >
> > This is a known issue. Using ratelimited interface also comes with a dr=
awback
> > that the kernel may react on stale information and the consequences mig=
ht be
> > unneeded oom-kills.
> >
> > There was orthogonal discussion on moving zswap limit enforcement away =
from
> > rstat. Yosry, any updates on that?

I am not actively looking into that, but Joanne was looking into
AFAICT. I will respond to the thread there and CC Song as well.

> >
>
> Fair point.  The direction I had considered is the benign one -
> stale low after a burst of stores overshoots admission for a cycle.
> But after a burst of writebacks the folded value can be stale high
> too, and premature rejection with zswap.writeback off or swap.max
> tight ends in a memcg OOM kill that accurate stats would have
> avoided.  may_zswap() is admission control rather than a hint, so
> the guarantee matters more here than for the shrinker side
> of ea80da363a1f.
>
> If moving the limit enforcement off rstat is happening, that
> supersedes this patch and I am happy to drop it.  Otherwise it can
> serve as a stopgap for the per-folio lock cost - your call, and
> curious where Yosry's discussion stands.

Not sure how much progress is being made there, but I would really
like to stop the proliferation of ratelimited flushing, especially in
this case where it can cause OOM kills.

