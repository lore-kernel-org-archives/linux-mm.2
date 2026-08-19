Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53ACCC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B496B008C; Wed, 19 Aug 2026 11:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BE86B0092; Wed, 19 Aug 2026 11:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C476B009B; Wed, 19 Aug 2026 11:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14A536B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:18:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A16191603E7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:18:04 +0000 (UTC)
X-FDA: 85118374488.09.5D9228D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id AE92F40003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:18:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jvLs3fsz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787152682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
	b=qwsmyktTVs3dXS8IGzqYqQ2nhx6QFtiW7JNRgyC7USRYj1h7ZKHBR7w4RaNCF2QrA6sCya
	7haWLAFcc16lR96Nlgz5wAG0Bnv0HJTnNwBEdbdCEbPZVln0S/SJ92wcr9hTiPMFUYgSO8
	Cof21rA0pvnwVrNYLDXDZNBW8xTi2R0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jvLs3fsz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787152682;
	b=bN+WW3uJhPaZ5jYbmHDLn8gB/b+ONqev5k9bgfnfHCbQf2Dy2jFr1iqeh5bEF04Bo3GdXS
	KCeIDZkuogdBTAjF9lB0g9feops1cJCR0Sad0R0d3DdM+UrxFrVuBaBbWI/AgQrxKjFK9v
	vdJqhpqmbNaB1aabRQ0tB4ZB6RPOq2M=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495509b08ebso52105e9.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787152681; cv=none;
        d=google.com; s=arc-20260327;
        b=enna9iVx9v+06jYzMFSwPFLBWrm5KjjusUjT4afY2lIivvpHRsBuomZztBQAJK68qo
         0IbUha2vG7v0IIHB025gAmM7tsbaptZFzk+CjcMGeba24/Hb5SJjcNkLJVj6/OzzpbRm
         MtgSRgdSQq39fDS0QRPvsEWprp127Un3hemFdk+ZdIQoiR6ObBfdScIvAlHKry92sCys
         LpJLeqzM2VBjydzQFFjnC14yrrGu+SJcpLbIN8k3l8jRv4ijOUSUXXIikFugrqO/n3cX
         2VUrd7JDnRbDS87mi5dfW/YZOFxZiGXSyNGEPY4gwQws+dnKzr+UG+u6pahGRuMnMyh6
         7+Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        fh=WuteDcHJe+b1ODbHq2Luk3cO82VfKrkWH0CP/v+hiVc=;
        b=NCJ92Qn/OcpsPAK10OgKUDxY/hOZ9FVW2iEZHwpVuZold2iHGVARCuw/xsPzUKConq
         6KTRUIjmhbh+rna3YGVIrjhsrZll0y7XFMi6F4/9sbosOaC+2SulPJpQmogXYM4ibLRm
         CQYC5WJu6rykEkQ8Xy1mZfpJsDs89hKMpNplupcicsCRqBZdvAyiBwsfvtRJaM0fMcHi
         /d5vAhVd8P2Qtjqv5C7jRtATkgZ83u0SIJUJggdHry/+UpgAaRKji9KRtk9/zw8x921R
         gV+819ujXOyf4yU3VpYuCfCA3R5HVX9FM6HC7Tyb1/ft3EfY+bSO2CAzPzIxYlgOtkE9
         lp9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787152681; x=1787757481; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        b=jvLs3fszVVh6auaeCQKQ6HljSgH1Eu1/hB9jLLDAUpj73hhRjbCYdCfCYGTuQbnKuH
         K7F3Gz3OY/k5ZKaBl9KiFSJkNGVA39QWttZIfyG/x+akEoE3kucbsE7UWnABxJXd+KU/
         ELIDYUVSfg29LGZ8L2l+Jxz9LpNTEWZp8NfIVpLZluOjMLUzcKI1XVxuh0XgJb1qgsoj
         U9zEBt+iNu0h6qB2eBGUFxD55ck0qu2DJKb+8Aw6kXUVPJQU7XTewvKf2bOQ/JiO3Loo
         X2t1OnMfXGX1NW9mD5oKY2IZ/P8Xd3m3Ibp+nOKw5ZF6HYBdqIeoSIU1go8QFNwySrbZ
         4Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787152681; x=1787757481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dA7U2ubhCpnou09rJaye2RELeJzotdjrKQldD8EV4vw=;
        b=mGZT/gqqVauMLggSGwVUb6CmsHu/YyB1WEu2IOmO5ts9GtiE9/mMbesVRB5gczZxwq
         66EiLFOOKRNEDTEm0as2Ub9l8FTQpdvCAMjmJAB89rCijlB6zMtfeo9XO2Ls0TFVbGTg
         /zOYDJ3qkcnN3kmCa5aS5ddcb+okXOeXt79XkPjc1A6tI9f4OCGcsYh/gxqnfyP37Lle
         zrT7a7i+2MchwiX2MQA5khOffZZhl5QO6TB2DwT808HbgOy8WQtVsEp9Rrj3MvbdMWFG
         EFxAc5P3BwCFjhWOMeYIP++3B77+TGKcqyGUXqGQ2TnZrazEWLf9biwSymPykmqTBrLS
         5Scw==
X-Forwarded-Encrypted: i=1; AHgh+RoNtbjs5GQl/oaVVXvWN9e1Gx29dE8TFqt92sKKvUrQKV5rfK4iEPBxISa2qGiyfpbygqEkIOWXfQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9w+i/bWn+8hUiYR1A+ja3striNeNYcFO6EXKkbQ3ita0UbvMA
	IQsE4raXzJAKAyzlSyW9ys1Tw/HxDWyKLaI0xyaQSKOn8a91EmCxUmwXWLjyD7PUNXky314oLhp
	Egp2pY9TTaBAOD0EgK//E95G1uhX2wscogf6DJs1H
X-Gm-Gg: AR+sD13Iu+2YLz7nRKbmsqlMmreKkQo+Un70w4SBJnJm5YoABBDoFG0MjJPTxNDbG7x
	o+plZ4jkcbo4FdDxd4spyfrcb4xp3SZdJhBLYl0TmyiwwxVjistz+2zduih01WVMHm9oJ8R5xUS
	fVHPvXdK+HAqJWeUdGdl71Is8SJ7lXNgsGkBgM10trMR5KevE2dvx8u9hGBomoyBpqaV3YVSnSM
	PMOGcRdiQ5x4k1K1+hP6hPC9J9trJA2gY8Vz9YeRYNFLNsr4E3PeyPr2OyrGwyEtaouwhucHcDz
	EYQpYSWlhc5weBdBB2Lp/R8W9mSCGAtPU44t9Mq5tD8AUZ0S+2YwtNITb6k1JivZ+b0Pvd+lEzE
	=
X-Received: by 2002:a05:600c:4d0e:b0:495:5515:3c00 with SMTP id
 5b1f17b1804b1-499abd0b9damr816445e9.9.1787152680616; Wed, 19 Aug 2026
 08:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-7-shakeel.butt@linux.dev> <an1_z6V5l7CNaCSb@tiehlicka>
In-Reply-To: <an1_z6V5l7CNaCSb@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 19 Aug 2026 08:17:48 -0700
X-Gm-Features: AcwNN1Ulg1tGco4bBKbK_ME6II0uAPH6pfpMeFoRn8Pigcnf9zHc2CjVhJLZ3VQ
Message-ID: <CABdmKX2EXGEX3wNnsKa15hzZ1-VXWVHDJOwhWbD+co31iZoHZg@mail.gmail.com>
Subject: Re: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: i1tne83udn3sjixic7bnfeumqn9ex8q9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AE92F40003
X-HE-Tag: 1787152682-294064
X-HE-Meta: U2FsdGVkX1/upwQXTGo9xAQerYU3JHf6LG647eTsHkm7LyNBkaOOHOiOw1rPu3XQMXEdJFW3BLl4wDiaX7UmVdY+uThPuYzFPnCf0ooEeBya8r8/gQxDxVAWw+q04uSL/PrmjL+FTAtJDUztYobT8HPrf23wZO+YRaojzOKWqLjzIL3AwtLNngD2ZFeZ3JVap/NR1yJ4xSOweJGCiLS9ApvXs6fiXI9qR718Mh2XZgCmiv/JhFpWfctB0XMUuic2VThFSajIAyorp5mDs2M621+01DH+r0y3H8r7cMTgl6PGNeWjj/SsPbE8lc2gqlfe3N3F9NbukBne9oje4kok6vYxWmq7aYQ4Zsex5bHTB9O70TqcjH+tG5iGueF3ItNdBIto+e6rRoeggSdSLtv8gYJuPeLbyXn9REk5ScHIFpw1jT7QmF5W+Ttbl3O+SAr6u/0K45+V6bUmc3X8qE3mD02oSqdNylT3G2C7KOD45sWBGGRnGz0rQygmCcNO4goMYOqFUgFHDpaOmXnN0ifbhhV/ZtNNXU0t2u9r6tTPXO/GS7lRbVgVVw77KlGjHls5S02kJNTMLLt3mWb7l/qocchqPgnE0yyHE+OyorOb9yW1GakN8gzxAy69oNvx6HycVTL3X1nCtom+nc02P8wRib8ywTbs2nd6mw8zk6r3C4BVME44j3lBBxLxJ0qhcxsgu5Ay3kd73lHUrnLyzn9IcN+10Z55tqTz06TdetiPHdeRlpw0g7Z0CNtb5kxxIFBEHsAru90MQ5t7imlp8CmPFSdZTUjyjXFEGZCt4OpH9DmNjZLsExyGZuxxkbiJP3Jtl0+dJC30BxKO3BEXzqtYznDXXTVvaG7dFs2CeM73b4mHSfdwAJVlHlAxPlK6WF0bfEWcd60AJj9bDaWpl45/ck0W/k3h20orHrLCVl8zKlu6bEeUXqHKzdGW6pKmazKZZ3pJe5AhN7Q5mexhLxj
 YPCvMUjU
 zabk8VMElRAq1IOl/jBQyWDxwhj7NobAjuzKtSA8L7fm/iOx0UT8e0OzqHdeEo/DH3ZwdoHTj4Tbw77MP/2cDNItfYLVsgiqjXcdfIPV56UyOTgyDWUDalSDAnHzTxXE8BGrw9PNYk/DOKX+Ms+apUFcknZVwKfmtpRGb3hTTX/ALCsmA5Vj+bZ2p20kAFVVPVx7dUWngaHh2UDFCC8A0vgYq13x5NeM8bDbtkdE/b18v0UIMhnj0qc22HPoD1Eun9olHGjnq7FoWf8id0JEfJcuGX6M4Ma6sLqLg7KI2djvDRlhuF8t6Rnxc7S+CB1Wiuo60YgBA+us69qbD1Q2uS4IN6aKY4G0UWjykVN0sBAqa9HdjR4DXDvcYHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 1:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 11-08-26 13:32:00, Shakeel Butt wrote:
> > The soft limit rbtree was the only caller. Dropping it leaves
> > MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg wit=
h
> > that op, so remove the op too and update the memcg LRU comment.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>
> I am not deeply familiar with MGLRU to give my ack but from a quick look
> this looks right.

This looks good to me.

Reviewed-by: T.J. Mercier <tjmercier@google.com>

>
> > ---
> >  include/linux/mmzone.h | 30 +++++++++++-------------------
> >  mm/vmscan.c            | 16 ++--------------
> >  2 files changed, 13 insertions(+), 33 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff5416..01fabd0ece0d 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
> >   * For each node, memcgs are divided into two generations: the old and=
 the
> >   * young. For each generation, memcgs are randomly sharded into multip=
le bins
> >   * to improve scalability. For each bin, the hlist_nulls is virtually =
divided
> > - * into three segments: the head, the tail and the default.
> > + * into two segments: the tail and the default.
> >   *
> >   * An onlining memcg is added to the tail of a random bin in the old g=
eneration.
> >   * The eviction starts at the head of a random bin in the old generati=
on. The
> >   * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GEN=
S) indexes
> >   * the old generation, is incremented when all its bins become empty.
> >   *
> > - * There are four operations:
> > - * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin =
in its
> > - *    current generation (old or young) and updates its "seg" to "head=
";
> > - * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin =
in its
> > + * There are three operations:
> > + * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin =
in its
> >   *    current generation (old or young) and updates its "seg" to "tail=
";
> > - * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin i=
n the old
> > + * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin i=
n the old
> >   *    generation, updates its "gen" to "old" and resets its "seg" to "=
default";
> > - * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin=
 in the
> > + * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin=
 in the
> >   *    young generation, updates its "gen" to "young" and resets its "s=
eg" to
> >   *    "default".
> >   *
> >   * The events that trigger the above operations are:
> > - * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
> > - * 2. The first attempt to reclaim a memcg below low, which triggers
> > + * 1. The first attempt to reclaim a memcg below low, which triggers
> >   *    MEMCG_LRU_TAIL;
> > - * 3. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> > + * 2. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> >   *    threshold, which triggers MEMCG_LRU_TAIL;
> > - * 4. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> > + * 3. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> >   *    threshold, which triggers MEMCG_LRU_YOUNG;
> > - * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> > - * 6. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> > - * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> > + * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> > + * 5. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> > + * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> >   *
> >   * Notes:
> >   * 1. Memcg LRU only applies to global reclaim, and the round-robin in=
crementing
> > @@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_online_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_offline_memcg(struct mem_cgroup *memcg);
> >  void lru_gen_release_memcg(struct mem_cgroup *memcg);
> > -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
> >  void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
> >  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
> >  void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgrou=
p *parent, int nid);
> > @@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct me=
m_cgroup *memcg)
> >  {
> >  }
> >
> > -static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int =
nid)
> > -{
> > -}
> > -
> >  static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid=
)
> >  {
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 790b50c78a2e..71244cf33d59 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw, unsigned int nr)
> >  /* see the comment on MEMCG_NR_GENS */
> >  enum {
> >       MEMCG_LRU_NOP,
> > -     MEMCG_LRU_HEAD,
> >       MEMCG_LRU_TAIL,
> >       MEMCG_LRU_OLD,
> >       MEMCG_LRU_YOUNG,
> > @@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *l=
ruvec, int op)
> >       new =3D old =3D lruvec->lrugen.gen;
> >
> >       /* see the comment on MEMCG_NR_GENS */
> > -     if (op =3D=3D MEMCG_LRU_HEAD)
> > -             seg =3D MEMCG_LRU_HEAD;
> > -     else if (op =3D=3D MEMCG_LRU_TAIL)
> > +     if (op =3D=3D MEMCG_LRU_TAIL)
> >               seg =3D MEMCG_LRU_TAIL;
> >       else if (op =3D=3D MEMCG_LRU_OLD)
> >               new =3D get_memcg_gen(pgdat->memcg_lru.seq);
> > @@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *l=
ruvec, int op)
> >
> >       hlist_nulls_del_rcu(&lruvec->lrugen.list);
> >
> > -     if (op =3D=3D MEMCG_LRU_HEAD || op =3D=3D MEMCG_LRU_OLD)
> > +     if (op =3D=3D MEMCG_LRU_OLD)
> >               hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> >       else
> >               hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> > @@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *me=
mcg)
> >       }
> >  }
> >
> > -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> > -{
> > -     struct lruvec *lruvec =3D get_lruvec(memcg, nid);
> > -
> > -     /* see the comment on MEMCG_NR_GENS */
> > -     if (READ_ONCE(lruvec->lrugen.seg) !=3D MEMCG_LRU_HEAD)
> > -             lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
> > -}
> > -
> >  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
> >  {
> >       struct lruvec *lruvec =3D get_lruvec(memcg, nid);
> > --
> > 2.53.0-Meta
>
> --
> Michal Hocko
> SUSE Labs
>

