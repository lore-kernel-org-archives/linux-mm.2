Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D74CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B176B0005; Wed, 13 May 2026 16:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AA96B0088; Wed, 13 May 2026 16:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612D96B008A; Wed, 13 May 2026 16:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5016A6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:53:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAFCB401FC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:53:19 +0000 (UTC)
X-FDA: 84763596918.03.54E77B5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCAA6100014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:53:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bl5A16tN;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778705598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/DDsGtZ0cVyzetyiZE3huiuNEguykSuxbVV06c2O7A=;
	b=F50imIbcxM8MhvZlnuNinS4T2bCZe6zRwnnwSf7FKiQk9LOSB3lJ4rHzm6Y46t8YsoTG9+
	nnQyoxxKLvwZ5BcIDhv18ivwdEAgAYaNWUPXu2EysUAEZBGHKr/pw1YBUZ5Nl+u5Tzvddp
	OTC8ctS6cghphjcvzwNg+HUrABU/R/M=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bl5A16tN;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778705598; a=rsa-sha256;
	cv=pass;
	b=LM1uXwHnMBa+a/JWHZ6UrI95o87fKjSNg0ab8goDv9zedZiek58ertB6wbM1R1GqgrRLcm
	AKHsWTLJlPBkJ3SH8B34nyfkYcfZZbUJRMONaucikynEKkWG2JFU9sDYsNnXDYN9Yd+N1w
	z3zvMuqgn3Ocr8dMw+zY3nxO6yujYlA=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-453903ee4adso6271250f8f.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 13:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778705596; cv=none;
        d=google.com; s=arc-20240605;
        b=JeVTFYHXEARPEvuZK8vkvhZ+0BliTJhx7qS9fKUhVOUBy2pioUNZSKvzJpRU6KVSMJ
         IWB0pSL79g6pFh/YUolUzm+kwpgYEXj29U5By0w6/yrVSVKEL/WuMhWriYzPIbUG6UXW
         zm29Yu7qZfpz1n1zf3oB0JyaIYxRWJ5irFBrmyR0GrxVnvbgaLis6AGz8tyoUhT3JToF
         zdE787X8zXirryQZMpf5VmypTVp0KGbe92Y+QohdzsJr1JNVAa88gBgTKcm0xXKdPQCB
         6S060wHF/ujVmy49w8/HVOfCsZOiRpW/0MVpmUnuA/FJKGpinDJHsad3t3VoLKNUa9xD
         e6zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X/DDsGtZ0cVyzetyiZE3huiuNEguykSuxbVV06c2O7A=;
        fh=14V+wk1+U4oe3zW7ftlXl2dJJ3VH73VqoIIuAszJUaQ=;
        b=f4HxUw+ZHyynB2zvPpefUk0IGjg8S1bCQS+mLuGoRFf/Is5wlqAI9ILisSWkX/6A+7
         HqmUuUrMkF4r9HfeNUdPdF+0ERX4aBJdgvLzRf4Qoavw9OQJ01wYdkpLprA14f0F4jyr
         x7I0PAdoGvQGGlOng5J3MGvdPfutiSsvspYW3Ys874LfXrdf+CtPi9RYQ+LfSFkEWzkn
         8HUmyf1SQYJP6ZIibFARE2efaZfMiaLWWbslmcRlBMvyJ2SyQYia+YApRVKa72GY8OTY
         +DC9Evj8ZBjrbtRnBtsL25unre7r7BxAwOOyRozxh2T7+yflcI8vk8qOF+v6IAkHLyFU
         wEUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778705596; x=1779310396; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/DDsGtZ0cVyzetyiZE3huiuNEguykSuxbVV06c2O7A=;
        b=bl5A16tNSkaFl3RoDohjbgRIhSeIOcQTxvdLdOF/D37anGvTjRYu5Utz4pbEID0Xyk
         xG/FtrsHXdjYponFF0GIdd9+Ks1ovW8x6nLS4+NpNbb4Dz8iUg1GZc7ZXSaNWPyDvGUy
         l82mhMLu2LRmuoLU5ScG9Gi2w8L4MehYzm3vbEB8eG1/B6waMXueHbdf7CuX/8BT8FZi
         nTTdaMQJfQlcCLEDnEuSrHbYf2pwJIvDOcpgDA0MQ+gCtvGBQvnQAUp1KNjai1svMF/+
         l2f661Uon/TnRSUowGlWPUqVq7bGwicAH7DOpEK4PwX/O6nsmmZZopf9syLhh9PQOdAI
         zStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778705596; x=1779310396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X/DDsGtZ0cVyzetyiZE3huiuNEguykSuxbVV06c2O7A=;
        b=Z2pRmc1vz1YSjazJQr+w3VwYJZu81Tj8+xVTUha50YdPwekJywc4SmihxhFx0irPGI
         g5FBsR5yOx30TvVSMOjmmrfShe7JRMgFEzt49SjRf52elXDJWlhm7OcelOeqT4ebiwmI
         MjEXcCsdxWiIamnquNjoub1HVLCYCLaw6LDkjyXMmXAhYWqNVgjy0OWsNbARBTkEwgM0
         /1sciu4ZVZavKoXkr+KLIAPUkMYCo7eowaVO0qjrBX4f97k8t4bKo8OBZv2jUgB9pPH3
         ZJc9OeY7tUo5FvsUwwM1DOM5BIp2QxW+PwDN9ML+c3DZX/kO612UhAv93gFtGoodktLA
         7oZg==
X-Forwarded-Encrypted: i=1; AFNElJ8oYTNKYOtewrs0qJOQrof/2W0S7//vgF2feIk+Typh0LfhfbGZX/6lLP5S4GdlGNCKQyBiRLRu4Q==@kvack.org
X-Gm-Message-State: AOJu0YzSB5USqq7URDY3LeQ4LxE54gxyH5YZsshO0+wTQ0yKITFV3nmU
	gZFARBYVYvAie2QdGUTehE8MexNestxaxtEvvyTy2V5lc5+5+SPXUCj5FqemJwinU+I2wdmrr6K
	thpxLSnuDSXC0Brab62MkdfyeiT9oALY=
X-Gm-Gg: Acq92OG7mjLDiP9eShhsI3CAFP/JcZpZ33+Jnu68f26Uoc9cxjZ61GMLupO7lh3nNyO
	ZX5cn0eQwcLrDhafK9HgxlUoDLDSelOlH9F/3QMefSAUBmU8Eg9OGbL4s8pxUhtwzcgHW71y1xG
	sPdl6G+kefo4mbZkquAl/ddMaxkFDZzTCUNiF/i1WRqenHDPW3VzZNew3/ul99he95OlpOFoF4w
	KuoeVJ5MxD4Ic2PLnWaKj2vY45ooDDQYnoozNGr8eXQoZxKSFbWWEUkx45UYG6CdKffzmgZZAlT
	7VmLmu0y4OjvGzKh1nC4G1H5TSC5bJQxcjziR7g=
X-Received: by 2002:a05:6000:26c3:b0:43d:773d:78ff with SMTP id
 ffacd0b85a97d-45c59bd694dmr7681297f8f.27.1778705595867; Wed, 13 May 2026
 13:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com> <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com> <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
 <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com> <CAO9r8zPvgB-MG2ufmdn4HoS+QEPBAehU9u7fQmYs+47NF-C9aw@mail.gmail.com>
In-Reply-To: <CAO9r8zPvgB-MG2ufmdn4HoS+QEPBAehU9u7fQmYs+47NF-C9aw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 May 2026 13:53:04 -0700
X-Gm-Features: AVHnY4LrLAgY72ojshBcIFy9xP1PEcHOYQ9m7UQfpzDmpcDw6jERR_OF5Wq4Pko
Message-ID: <CAKEwX=OY_nws-vf3VgnD54G205TK2YjkoAwRCyB9jvW=Oz3PpQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCAA6100014
X-Stat-Signature: f8857ghu48adh48orqtks7gk3yaf4uxr
X-HE-Tag: 1778705597-618351
X-HE-Meta: U2FsdGVkX19OlKvEbvh1VA020Z+0mpb7oyQWZZFt85l8QR5SCDy2JNhvvM6jfrBpVf2dNrrOHReWHwZiwWDPDHSlbwe+PShVgzTjMUgiGiJQRa8y4G4KR2+VBpFAY7Ztnj5FOHt4lKBlilvim+Ii6GCjaZVkIEhnRpYgH57TyMdVlct7TNkn5AuhGMHWoAgRC0b8jnRKtc6yi5b93ME/Rjp9+95QaY+4KezFt3oiooTjWA6HW0HzBetotRoWX25WdkXzTUihhFqr7qYzNceR6/mVOs8OZGgposlGOuFB7yavUtx2qPSbdd8wMM2b7Gdoqxhx5tvl2PtL5/7E5DCzgF6dsLxefUpbd5Kp2OpdywNU/bQA0+GEmm7q7wegarbxN3yaajwzBzMdDfl1dkrGpjmT/tFiDbwzfbxZmoTWvQ/fEaa7tLvy9N1v5L7QCfWNuCiNklAeVUcEZx0sI7dDD1ygsijpFm1aIhn0ytEOKMT+03GWfcgOEu0eQA6r7kyPvPLaAFolR4aEWWE1EZYuepIrQtzTYJwm4uXE4iH1BRwmHf36AcApuvdGoVE2RugH9OMWe3LKwVgPvdHotfkNpXyZJNx/zR+k3XFWzzpw39YfQPvfP7i920H1mJf6X3/gTfFshkrev2zEXwx0TCvCP0UPd5gpSnpaztLXrYIObg3sPpUhDPegReZZTjSWT42VwZOa12ml6b+AfBItdpVN41ACXRj2HiimVNqodeSA0gTXa5coKlEuesUsYkWtrfO+eHDR5EcBjxm40jfojKj41Mpmn1PdAm6wn5mzI1x693w5YTXtbqaLdiOhdAkd1k+WNu6EuMI0PYDj1bzF8NThB17ivpgvqchcnBMqMpAgqnSTN3w6LW4f4fEAg/jX3NU5xjOs1IMKqjIikSmQB/Z8NQPn2eLQozXn189qVNXwYSk9vwbzUU9wRyFskQT7DbbbhVKE/VRUO2yFcjuaO5c
 AvQlqwNr
 jHC726pcsRSLrbedYHAhWu3stOxqc3tTwdrQrXObz+t37jhycxltPby8FAo6t3ZIm7FyAKt6HwaWEpIvA7XIN4Pk/xWM2UkLueIgPkBTq1ohafgXeE/P2zWNfI8LhdWgLXlzaHPIZ3dIf0NuqHouJx1uUvy/VUidUdVRUf8LHgmM2qO3EwvxhijHsCskHGMyURYxW+KbjMcCMaFx+Om+mIEBM8Lwhxtwec09Eca6U4KpUEsqEH1gHmf5OtEStNHsuTuMdCFO1qpX5BhAddHSZ7iVG/U2WR+yOckPigEDJo42jVhCuDN4QgCGjwQnWZMKEZqQkuMn0ATB0P54wc67kjKqCwC/mgWo7OVwAtO0k7Jp5RRCM6wIC8UqTymwVaFopi7pXczidHSypdO9AYIXO5ZkHbeEqDPgHQCuXWdzXuGYEDFAe068tYdqDo/BicYVDRDf5RfvcNLzcqiOXX9bIL3crJwHz/QOBpf3KGjItW7vzn/2a0u07g+52gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:55=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> > > Zswap objects are organized into LRU and exposed to the shrinker
> > > interface. Echo-ing to memory.reclaim should also offload some zswap
> > > entries, correct? Are there still cold zswap entries that escape this=
,
> > > somehow?
> > >
> >
> > Yes, the memory.reclaim path does drive some zswap writeback, but
> > it is not enough for our case.
> >
> > 1. For a memcg that has reached steady state (a common case being
> > when memory.current is below the policy target), the userspace
> > reclaimer may not invoke memory.reclaim on it for a long time,
> > and so no second-level offloading happens through
> > memory.reclaim. In this state we want
> > memory.zswap.proactive_writeback to write back entries that
> > have sat in zswap past an age threshold, to further reclaim
> > the DRAM still held by the compressed data.
> >
> > 2. Even when memory.reclaim is running, the fraction of zswap
> > residency that ends up reaching the backing swap device is
> > still very small for many of our workloads, and the userspace
> > reclaimer has no way to participate in or control the
> > granularity of zswap writeback. So in our deployment we prefer
> > to leave the zswap shrinker disabled, decouple LRU -> zswap
> > from zswap -> swap, and use a dedicated proactive-writeback
> > interface that lifts the writeback policy into userspace where
> > it can evolve independently of the kernel.
>
> To be honest I see the point of proactively reclaiming compressed
> memory in zswap. If you use memory.reclaim, you are also reclaiming
> hotter memory in the process, and you are not necessarily getting as
> much writeback as you want. The memory in zswap is a more conservative
> choice for proactive reclaim because it's memory that's guaranteed to
> be cold(ish) and not being accessed.
>
> That being said, the interface is not great any way you cut it :/
>
> I don't like the 'memory.zswap.proactive_writeback' name, maybe we can
> stay consistent by doing 'memory.zswap.reclaim', but that just as
> easily reads as "reclaim using zswap". Maybe
> 'memory.zswap.do_writeback' or something, idk.
>
> I also don't like having two proactive reclaim interfaces, so a voice
> in my head wants to tie this into 'memory.reclaim' somehow, but that
> includes adding a pretty specific argument (e.g. 'memory.reclaim
> zswap_writeback_only=3D1'.
>
> I don't like any of these options, and we also need to consider what
> the memcg maintainers think. I see the use case of proactive writeback
> but I am struggling to come up with a clean interface.
>
> I also think we should take the 'age' aspect out of the conversation
> for now, it can be a separate discussion. Well, unless we decide to
> tie it to memory.reclaim. If memory.reclaim broadly supports age-based
> reclaim then zswap writeback can be a natural part of that without
> requiring a specific interface.

Yeah perhaps extending memory.reclaim is best... Sort of analogous to
the way we have swappiness to balance file v.s anon....

