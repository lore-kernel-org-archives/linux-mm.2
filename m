Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E78CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7C16B0005; Sun, 14 Jun 2026 22:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69136B008A; Sun, 14 Jun 2026 22:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B578B6B008C; Sun, 14 Jun 2026 22:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A24B06B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:39:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BA531208B8
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:39:04 +0000 (UTC)
X-FDA: 84880589808.01.E4BBD1E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B40BA0003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:39:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnQs8rsC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781491142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OM0sP7wWVTQptCkIXgFOHkZiGuvJwwRHDUE5S5OI/2g=;
	b=o4kMRyJ49Ihqkj8eOEkcGJkRYgzp19SX83iQHsmK29xlgJJcyB8bUWxJ7ZNdY+gVq0v+vk
	/VeIBm0GTib4N82WdXWAdrzclwyMqviz0cFwkticHQjg0ByHCZ0Kso69CukK3utw4KeQKh
	TPsqqC6YWUjv2VP+mewaF2dnauaaL6Q=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnQs8rsC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781491142;
	b=YzkQrlTHUOJo6NCTmg469e1lQIIV+f5vtNrxUSFH/z3WiSyq3kyMzV+jFVeIDFDMiKpW/j
	3M/jgzLcCG+XMGi4h54XI3E3fVVqcnrsn0ZY1W66l+KRF5E029KPgTbuAyF4nYbQ9i0b0k
	QhZiRKVUKdPMArudUvJYs/7KRyY/PVs=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490a76757e5so19599505e9.2
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:39:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781491140; cv=none;
        d=google.com; s=arc-20240605;
        b=JORy9K/qqWKA2EEpdCeH3kCtnvCEoTb1Zctw0efyOLUh0d2PmpgXvyrC45XRwkciYa
         49Cb2r4mR6Q/3V0TsAA6Ce6qTZjFiA1jNtx3KHPscqDqB2VX0yhppGWWXZu7y3ifwhjL
         hHyYzAfPqi+4kl+wzw80Ks4OKwww/UEzwG5FXACBG/Q4I+K3cZ1i98939tvfg3aWdKs+
         CWAlANz5qd6ABLpTSG5LYlqE8SBp8mBpt2ISHiqh3D0JVuvpeajr69TH/8hrles7YnLw
         0KsPXUFOiwpWxqKjYD3Hx5kFgxsPdiWnXeXyZAg66fxgLJny2u5C5LfGIuz2jJFNUMmu
         MgYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OM0sP7wWVTQptCkIXgFOHkZiGuvJwwRHDUE5S5OI/2g=;
        fh=ns/CoaAy4AGHxsGWgtmwxH87Q3x2l44w9EtdicbsZ5w=;
        b=F0fgm+K3pqTXjzLmhpPnXgc4/9pZyXplCopVuSMsZwe8yhdiWHnloYhuVxiG4Bq/Qd
         9B3NMpiRjiGJ3To9d9jvsg4HuuIPrK80WYlz2ypu6JbuURtw5KMxVDw+rS01qbdm0d7p
         3XM1Wa9EKqRQG5L7lO2zLnUgTB2PyI1m7qfj/y4ZZ7OoFLdJzCKyy0aLHj7JAT5dOkdJ
         8An/TKsMiCazBq+nATTB4A/k8j5ZKJVSkYQfHWWct9T2gbRp2NeKNCT1yF8Qwr7AXWcf
         Q1qWXvmIRci2FVkjAhfwRHwXlEnTF1kvi57GmFHD1gKTRXR25OAxWKondnfoZCIJCk4c
         5fyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781491140; x=1782095940; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OM0sP7wWVTQptCkIXgFOHkZiGuvJwwRHDUE5S5OI/2g=;
        b=lnQs8rsC5uSiwKxwUrHp6dkUFLo7W+xCfK/kun0P2vBumlQhs90TDmgllmyQxrnaAd
         uYPOG3rleiMnlB/36VZVNynWRnYHeLvwL3CHL/7Do5+/iUl+yjgviEjNbnV4DU+tH2Fq
         yLNwAnrxEaRqu9m/sNrwJFFLYAsOYnn25raqfHrgfU10DY0L8E1lxAnKLhlQy2ROfHWy
         /pc6pYD9pa2PlpjxaNk+1GCJKnTvjgVct6GSjWTyh5iQZ5iuI/Q78lN0xXLhBMFk0149
         AvlWEWa22G/Kgxyc0KgN8jMuThNNvg8QPg/9hDdf5RC0eUZaqiKo9pUik3W8sva3jv08
         m74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781491140; x=1782095940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OM0sP7wWVTQptCkIXgFOHkZiGuvJwwRHDUE5S5OI/2g=;
        b=h56EZ3GKfYfww+yiWZ6WQ5cjDcy2nubf7Iq1q+Tb/VkIHNgirm4JOyAl1YSQugaWfB
         UEDhpQmHq6L8x8oCBUbEDEsZZ8iiMpbk2w54XSQxwvr7j8E2pFpNcj+UvB1HcKTxD+Ah
         2OVAUccfFKfPxJLdEgUytfOEo08KWZSy3Oja1suLL0LoBXBZL8UWW0Q97ovrh51TeFm0
         Gh9fRGXvJEmhivnsBZcr6xY9KSd4IuixG77NegY6cekE+PlavBipNS1aMh7IDOQVhIC5
         Fq/BVJdq191FmWMEVIGvJp22CC09o8JiXAxL51fuu2JIkHpxy/Hb3ADEZr4eFt2OeytM
         WtRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+C3Rtoy0ZA7oWhBxGreGMGsxkFj3+sq5bBSSzXqSTGKNyLYRPhOB1c4bDN2/FbebYydn/4cyUOpA==@kvack.org
X-Gm-Message-State: AOJu0YzZXvoaKUuIc/b1ftIUk/vyZpHa230xku6MtAx8dT8WoZIUSsFk
	/RLdGwRDkJIXz6bxhmnTbuEOEyBRWWHEsMf+Ol1YLqWNjwEpUhW4GkjH512AKedhYEUQ9nuAG9+
	NW68eaI9FeZnJpbPSL2G6cujDDEoxTSI=
X-Gm-Gg: Acq92OEvOaIrC1oZBrMuCj/oOICOiJ1Ht/kCUV4tETUHiks/jPexp5fdWleYEy2RRYG
	W+DUxHcK6ns5xj9z/b8LVgw9FMCLFJ69jMd+o1ghvJI19nxsSGYjfp+57t7fz/AvQ2nhhXk6x3J
	kRvSc7PXqPdZY9DDP/mXiZWBAe8I2FaPA78NCxfpPhY/KiaiH+to136x1QQm/yWPthhy7DbTBfM
	nNc+LBeZns7MYsyPU3ZTkWvY5pq5WEicrSgStk0ZmDhnyyVglLkfPV8fURVAU0vkuLwZ5jQEnHU
	Wd3d3e+4jossL4BI0/XujfFj9jw/UA4swZMreA==
X-Received: by 2002:a05:600c:1d06:b0:490:b8e6:be40 with SMTP id
 5b1f17b1804b1-492200c01c2mr118630585e9.21.1781491140502; Sun, 14 Jun 2026
 19:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330>
In-Reply-To: <ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 14 Jun 2026 22:38:49 -0400
X-Gm-Features: AVVi8CdL1KZfURrMHERaHUdEggMOH7tTPmf0sRtg1e0zJOWDwYMtBzIdo0u3nJk
Message-ID: <CAKEwX=O23a4iWBZoewKVb8QqODte6r3Xijckw3_oCJNoiO9M5A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] mm, swap: Virtual Swap Space (Swap Table Edition)
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B40BA0003
X-Stat-Signature: pqsk37mjeydtp839j8nrphh5jzxtpnce
X-Rspam-User: 
X-HE-Tag: 1781491141-959287
X-HE-Meta: U2FsdGVkX1/YZWLjs2q6CEkYXGLP0OxJRucu9BaHu3U3M++hYCGDVnW33OPVb5rzJWnDHYp/XcQtwncQP8/pcElMnouo0pRBHa+PcCNj7uwLYkRIHO0tckCU5gVJv4jn1bZ6Pf3j4gceTwkOnrmTkjfu9h/nTqhWL3PojOql2rAgc9QsBzP8T00hleSA/vShrNa1R9CWlbO9FfwDyN58d1sikq9kVC6IdJXnSbYLfJSyaCV89mOgikn+OcVMTBFO/pnZrh+/8hWUeSWzau4vfR+BXrgjCV/NbZtwMQVLB3pFBPRv4kksFd3qwc8/hJjtN9q77qHjOcAbxAyH178K684t2XNfO5nQt+Aqu0HQLU9ttu00YHFUZKpHbgXR+kb8Y54U3pQVZ7TshvY01Zzz/jtG4t056UkvFV5ekQG1Ev7kXatg9jfOG8qhVV3trKXqC3aUz9MJl1AmSHe16KX3pjQOYtxIlJN7Y9KSWTBL0N73RyOAnS3LNTJfli220hyf5WT4XUboCYTC+gW9rRKKapf4tZcfD7lzXoChU4QVU7Tg/5afMD1hWFuOEhb1k8jnDlFInbOG/u96jdP3EOQtPWwprrHaWQwIBoCgFAHhghmDBiFrnSkQeQm3aLKVypP4FZ5NMMvkkGBMRgKFGRw8fZ+slXcJu5x72WiXFm/4QyKRl3TvFOQPI3fZwHZohUCKigiAJ0Wt+WD/wNTeF8lMMJeevJ521gX3LiyPpr634Rroq4iZMR+v37EjSzqcuqiOHqD6qI/iidKVe745mYH5E9jueN63GpE8iPm3bZZqf2Xo+f9OOwqme+SrA6uJHkPZxkbCHhLDLyb1mvx9ihtYRE6HbpkXnPwYu4ZB1mXUPkiQVjcDj0Mj8v+LkUtiQyJ2Ugswqd7UmTnAyVQrknTHP9Qcou0LzRDNnBtJ4KYmRwkgpS1ffgvHygm14Rq0QFeuOVzhPTsuNk231L0DUJy
 qZaREKlb
 Q7h9ty3fjzlGj6Hk1Fi8d1azflnTV4DK9VkSKAYJOVJloPXXb5I2KWtwVmcUNhE40eowyJ+2nHJWrBUwiSX/JV4s8T9PHvaoWn4FOfERJbGvI/aUckc9lS/ywbpxTsNrPsWWx5B46cb8heKlfhT7EqWYKj8c05LVJMozilLoEE4M7DX6uw+POU4Q1UsTnl6l0jgutWcIWbj3Q+/dcCs8IoZN7KmPrf3keP0qBB/bVg3qqUgEX807ALz/1K04PuIrAOV7uqvoXlgMwFU8DqEil2bIbyUlvfSkrBJI9SNzG1LtxR2tSZkAxPa4kj6bFU32UftZSv4Pks0qszJsS93FkZgpHCyJ1w2S4Gc4sVq4xEF5pVVjoCYYfxEhNxsJKGzvm0PUAgczcmq2YNUKev3TmPjtp0/uEXOCFGSnvGTD3ThR3DMmLnAHVLOgc/lwS+q6sqV/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 4:20=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> ...
> > * Integration with swap.tier by Youngjun (see [12]). For now, I'm
> >   leaning towards opting out the vswap device from swap.tier entirely, =
and
> >   treat it as a special device. Integrating it with swap.tiers will
> >   benefit the cases where you want some cgroups to skip vswap for fast
> >   swap devices (pmem), whereas other should go through zswap first. But
> >   most other use cases, either the overhead of vswap will be acceptable
> >   (or not the bottleneck), or we can just disable CONFIG_VSWAP entirely=
 :)
> >
> >   Youngjun, may I ask for your thoughts on this?
>
> Hi Nhat,
>
> Tier 1: VSWAP, Tier 2: ZSWAP ...
>
> I don't see any problem applying the desired functionality with the
> currently proposed mechanism and interface. With this, a user would be
> assigned the default Virtual -> RAM swap tier, and the overall picture
> becomes one where swap tiers are composed according to the priority
> setting.

It's more - is there a strong argument to let vswap be a tier (which
is not supported by just turning of vswap altogether).

Because right now I'm not exposing vswap device to userspace in any
manner, pretty much. It's abstract and transparent, and minimizes
complexity (no vswap and swap.tier interaction) and surfaces for
issues.

But if you have a strong use case in mind please let me know :)

Worst case scenario if we're wrong, we can always do it as a follow-up
down the line.

>
> A few more thoughts came to mind.
>
> Shakeel also proposed a per-tier max for the swap tier interface.
>
> https://lore.kernel.org/linux-mm/aiw2p5ANjsQUCIHA@linux.dev/
>
> However, for vswap, rather than treating it as a case for limiting the
> amount via such a per-tier max, I think the current interface is the
> better fit. (But, as Shakeel mentioned, if we only allow the limit
> to be set to 0 or max, the usage could end up being the same. I'm still
> thinking this part through.)
>
> I have a few other thoughts as well, but I plan to raise those points in
> the swap tier discussion thread instead. Please take a look at the
> related thread, and let me know if you have any opinions. :)

I'm following that thread too. I'm still thinking about it - will let
you know when I have a more definitive opinion.

