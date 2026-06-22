Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D6CCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494F16B008C; Mon, 22 Jun 2026 18:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46CCD6B0092; Mon, 22 Jun 2026 18:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35AE86B0093; Mon, 22 Jun 2026 18:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFCC36B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:10:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6751C1A033F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:10:42 +0000 (UTC)
X-FDA: 84908943924.24.6167EB1
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76EA210000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:10:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G895m2yN;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782166240;
	b=VA8xlxFMEz9Uw0gPS38tleZE4MXeI5w0rMwhAylPsADXSPOoWlQOH6+CGpBRvB32ahr0DN
	AeuKYPhmzFQzSUejJh4en6mY05cFI0/sXuzHWEEFzCwgO6BPou4d4OItaWAlMamAGjaQ70
	1sS7NrzHmCaomwK7QcSXqZwGuynpPKg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782166240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lWcRJ9xv3vj+kuUslXqTMu2ZS1PDN9hlN/ZqmuvJzU=;
	b=AT5EiMQz+UtJO8dAG9gVP9zNuDJ2xp7G9zSM2pijTXEtjj9OuFPp8uZHgJxU1KagKhQd6t
	D0X+ByWp7mQWzedLU7/7EUzzA5VAceQgMVoGMYvJGbGtPGeV5QdQvUCgpiWV1qcV/f/4I5
	ByyY128N7+eT6p32tDOSQDRCg7wwBTM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G895m2yN;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a0ef0e88e2so1084213eaf.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782166239; x=1782771039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lWcRJ9xv3vj+kuUslXqTMu2ZS1PDN9hlN/ZqmuvJzU=;
        b=G895m2yNSj1tvfkBxUhH7tjkEaVXfLSLdSpY7vKDM06a1t4Dj1ZvOeJBhL7xW1RjaU
         0d12wHX0xjrRMWSn2QQCs+I59YS1oKvloLt4qRGq5Cco7ZVgjUgJvJegKN59+IwRzqLf
         MIMgD48/JdhRDQSCUWlpzpoBkaYszGRAqCYuy/1BtQV4cUbZcVWnn2WmXGiAIvgsAlL5
         wBZqhuA8pD4rChMBucLkuzODaavIblgAjM3A+6AIG39p9Mdzrlgx3EI6M4mYHDcRiI7W
         iaqxLD1wZBN6seytyQ+pJMHuwgMokeDz9AGhrg54m56zc8kIA3T6olkok1gtmNFEBV4T
         EsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782166239; x=1782771039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/lWcRJ9xv3vj+kuUslXqTMu2ZS1PDN9hlN/ZqmuvJzU=;
        b=YjFQmwwjAVlAl/o3PhsdCg2V3lsOTF7ABJWKTviCR2tpwBhtmR9pJTzBnexy3+zB3e
         QNWohfipOQH1g6djYvi01MnBZjogI9Q3EAhcrt2RAzNZ9iQCRPwCpExVyOUV/v0ln4Ob
         0qOTv7f6BM6Vfav2GSbt7EflBz3phfLmtnevPZpO5aikfwgAlCHDG3tpiO94BczJtI9I
         +r6CmoGfjH1jDxcDO5bHkUubGGQupA/zoXm1EIGcMQfRGVL+HY7e/5bpqCSsY+uGzxYG
         0OmU7Nl/dJQeWkTszFtLBKP2jF4byRewKMShhse1fvbHEnLan5gqNLnxaxRiKRpaDxEf
         uT7w==
X-Forwarded-Encrypted: i=1; AFNElJ9irPqsOeXpMbKLibLkATAdxDbBhxGKaYWRy3UrauO7w0mXaBwsspy03DqVtStCzkdyPFDAEBJfDQ==@kvack.org
X-Gm-Message-State: AOJu0Yzyt4sJi8D15hBwDgrBxdqV2hqxDr2LZO/OEPflFQyT4zi6yR6Z
	w6aomCwNTtP23soVzL6sRLRT8pPuxij8zQEc0ZnkBVFqp40G2WYPgbdA
X-Gm-Gg: AfdE7cnOCJofCiEzXuk5ryzaSDC9rXJY45wI2DVVHaDli14ylP+RhUFmEtBdTlrj8Dm
	rEeq707ssDmpxGHfQ/B74bC7oAJhFUOOq453GwpjaIxFoNCh8e2I9PqJMJsNeJ7WJJ2jrgdBbbp
	mrPVkD8HJxVXPsvI+tFoeft8vfUpyu4pOqF82Iho1wK5pvcSRkPTHw1vTJhCpt0wtPZHeNsCjcp
	BBx1Zrf7Gcd1IK4UwBngdZNHNTHJ8n4x98Vlmxi+U6h5Ysw/KCgdAuJX9NwaMHN+xVUU7n1CFxk
	QWX//6WUNjzM2AaVDy/NnC6ZlRAozM2FHkBG9OXo1ow8Irbds5TKB1GIWqFTwG9wsm6y5ZgipUi
	fCXXUTx2sYiLc/au6Zh+m6hlIW8k7/SXguyfE8YefIMb+Pj24Ftwcfo1IC4jdi7SBWscYAQTs/J
	5u0tTE5C0kOFgRBzEk1bI9/su0VJFJQvhA+Ix+fb42MbVu+luIV4MWKA==
X-Received: by 2002:a05:6820:c85:b0:6a0:f323:e967 with SMTP id 006d021491bc7-6a0f323ea6fmr9372385eaf.55.1782166239358;
        Mon, 22 Jun 2026 15:10:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9f77720sm5727019eaf.6.2026.06.22.15.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 15:10:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Mon, 22 Jun 2026 15:10:34 -0700
Message-ID: <20260622221037.255359-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zNjyW1rh26vv2vavCM_2-r70EuynU+-7XdEmrBdLL=TkQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ie485d4pcx9yg3xr1qhr78q5hb3kg1mm
X-Rspam-User: 
X-Rspamd-Queue-Id: 76EA210000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1782166240-20264
X-HE-Meta: U2FsdGVkX18Wqb7L9EwStL3UQb03ABu1NlT6HHWAeSICp1xkcdTodZb1Ydne1fw0toQKyrWlOy8MOdAu0AI1NYU/fWBbTFDo0q1iM6WxS0khYSlbakEWqdaBiJhfZMLkhoKrYwwHLvY7hLEUZXbqfTs1xy8jN5zv2/VxmXOXaiSrs7VGOIQUNgqnL6Zq5tRT+jaf8H+FZzoZGBWpdXcaaWlXmm61zbt/pEJEDxPLlKmyUXYNmwhZV8ueQ7EA0fwsOKS0QH6rGpC+CiDA075tWGpliyyNWGHJuiEUK682gavzMxHXUWEmm/v3e+PcSmkY+pbuqIBOQlDS5IktvJBVlsBB/0rxY3yH8ef5Fiw+kgQYGDbdFIhjfnTuGmNTbpCURGz3Dq52biUJtTSP+MMoRAX6e3O0y7gkBiexoa10aGr5NiBD4OB3ZnNZVtFT+cUyEzb4G0BKh0QgOy8NV303/bliHLMc+K3MkKtXi6wGzJ4U3hyMu74fTTs+qwOQIi8DrfJbhwGVthRm765kFqIGzZGNUoieqTXqU04J+qqw/wisCP1PKKZOl8zVmCZq+oH7juKROuAL+sXPsFGtRNGTpbq9wP8QkcosYT6w0C4ACs5+P5uU01EecA5MemX/Tse4WURrsIWT0HY3Kj2zA8iPQwJH398rrIqcGDy0E0lpRx8a7mq2wDy1TCBISGWNXxv4191U3u+HUwS+G9UrlpffYz/F9jFSWTcuNdpCG2S8yfvoafvE+/TU9ZYp6xxPCjsL1neyGqu2wMkkVBxRUgVeQWudVat1iZU0BHe7fYePDqm+FE8iT56uklJVZeztnTr3Ls6rnlKBf8IO1+mfbTHZCNX4qpqcaDuNZxOB9pWzxLE+q5BCHjh14evK0IoniFU9PBHW6fchjmnPe3VGU9Ydw6Ac2rz9iAxRlvgJp4d+gkX3+lVKmaPopZX9HwurHEZGXuPIq3ckAwJ0d7TVVAF
 cuCoMQRM
 lbXZAFLjmWJ0EefeAFEmNNS3D5YQhNDRQSP5xdXKznfnsswLrk3RgD7ZM4kw0WporYgs7h48bdJeZKBKrVq2j5nZgW1A+6uLTpp7zxo6VCBNhnAs48oVEBONF6Qm3yFxEK00J8WYQ+C0Ufh2RRHH4bOni5y6sAN4PxLoocitZdm1Tz2kYMJfP9dlaN+D26YVxy6QdbJsfM/x7IiiKH7ETqC8XF2dDLOGCzau4ATSbNeUx143NC2Vl/J8ZxsWwEjTSzwgV2DVzSgptWtdhgiPNatJA5JJgi/hk5QGT3dZPgEzGkT95m7qGelku3iDXGb3vzygFdOylzuTjljdFWl35kaFuEKmC3gdujc8GisExeNkXHRilPTZsbPZ2hgiT/ctGOM4Zd1Y28P+EUCBHP/xJqjUzXJ8hkuRaOm3F11w7JU0Y4qbjHhNpOQHKAJf7/QB2XgAdOvvAq/uWePCOgd00aA0ezbzcOH6hz+06yWrF0xMc3SvjOPAxGpv5G8vodxQVWmKztkxMfWULxfco5QjvsAMTbWuE6EANANS04Cn6Lvsd5dOS7K7TMGG+28J7boqqH2X74btKuGOb5Mgr7KbFF2tCzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 14:21:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Sat, Jun 20, 2026 at 11:17 AM Youngjun Park <her0gyugyu@gmail.com> wrote:
> >
> > Introduce memory.swap.tiers.max, a flat-keyed file listing each
> > tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
> > (allowed, the default) or "0" (disabled).  A tier is one bit in the
> > cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
> > clears that bit.
> >
> > Since the current use case lacks amount control, it only supports
> > "max" (on) and "0" (off). Therefore, it does not track per-tier swap
> > usage, relying instead on a fast runtime bitmask check.
> >
> > We maintain both `mask` and `effective_mask`. The `effective_mask` is
> > strictly bounded by the parent (e.g., if a parent is "0", the child's
> > effective state is "0" even if its `mask` is "max"). Maintaining this
> > separately avoids costly cgroup tree traversals to check ancestors at
> > runtime.
> >
> > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  20 +++++
> >  Documentation/mm/swap-tier.rst          |   9 +++
> >  include/linux/memcontrol.h              |   5 ++
> >  mm/memcontrol.c                         |  67 ++++++++++++++++
> >  mm/swap_state.c                         |   5 +-
> >  mm/swap_tier.c                          | 102 +++++++++++++++++++++++-
> >  mm/swap_tier.h                          |  57 +++++++++++--
> >  7 files changed, 255 insertions(+), 10 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 6efd0095ed99..4843ffcfd110 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1850,6 +1850,26 @@ The following nested keys are defined.
> >         Swap usage hard limit.  If a cgroup's swap usage reaches this
> >         limit, anonymous memory of the cgroup will not be swapped out.
> >
> > +  memory.swap.tiers.max
> > +       A read-write flat-keyed file which exists on non-root
> > +       cgroups.  The default is "max" for every tier.

Hi Yosry,

Sorry, I feel like I'm joining the party late. Apologies if I'm missing
some context or repeating a discussion that's already been had.
Please let me know if that is the case.

One quick tangent:
I was chatting with Nhat last week about swap tiers and its relation to
memory tiering. Nhat brought up a good point, which is that while both
swap tiers and memory tiers provide a clear hierarchy of performance,
only memory tiering allows for movement between the tiers.
AFAICT, swap tiering does not allow for direct migration from a higher
tier swap backend to a lower tier swap backend if the higher tier
backend runs out of memory.

In that sense, I'm not entirely sure if we need to enforce similar
semantics across swap tiering and memory tiering; it seems like there
are some fundamental differences anyways to how we treat these tiers.

> I wonder what should the default behavior be if memory.swap.max is set
> to a value other than "max". Should the limits in
> memory.swap.tiers.max auto-scale or remain as "max"? We probably want
> to keep the behavior consistent with memory tiering.
> 
> Shakeel/Joshua, WDYT?

I think that the motivation behind these tiers is different for swap
and memory. Tiered memory limits is motivated by preventing one
workload from conusming all of a valuable resource, while swap tiers
seems more to do with excluding certain workloads from using performant
tiers and ensuring other workloads stay on those performant tiers.

IOW memory tiers exist for fairness, but it seems like swap tiers exist
for workload performance tiering. But maybe there's a usecase out there
that would want fairness to apply in the swap tiers as well that I am
not seeing.

If that is the case, I think auto-scaling makes sense but can be a bit
tricky, since there is no universal tiered ratio; each workload will
have different tiers it can swap to, so they will all have to calculate
their own ratios. Tiered memory limits escapes this difficulty since we
assume all memory can be placed on all tiers, so we have a system-wide
ratio : -)

Let me know what you think! Have a great day :D
Joshua

