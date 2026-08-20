Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532ECC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE786B0095; Thu, 20 Aug 2026 18:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FD66B009B; Thu, 20 Aug 2026 18:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F366B009D; Thu, 20 Aug 2026 18:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09A2A6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:18:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86940C02E9
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:18:54 +0000 (UTC)
X-FDA: 85123063788.07.478071D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C21240004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:18:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYNvn2nc;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787264332;
	b=taHor0fsq4/tIa6GOkP6mFkAZ9BnkhKPzycSMZw2l9YqISHxwIu/FJAmmhqsmoX6unsr8n
	cumEWQlJPO2mIKMFyjcDAnbsW8ukQVCGQWbPg8J9ZJ2VezwOmZWeBuJT/yiEL9cYYmZ5Uh
	mpFvJyZHteruejF8r6Nk1VZ3OhsnTHg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYNvn2nc;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787264332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
	b=xEp6aKnm2O+Nkdcp/5yksAPU1XUT7s3msBZ4b1Bb5wSo3LoV9fzRgxc5xGlQnBDPQ10lNF
	PH4HC9Oimbq8xckMTiV1I9iq/Hc1m6SNYKKx83qFvBpz4vZ0l8QmydjNImmQl6HkeVpYlu
	qt3CR285UOKVlfWq87TfBUfeJgjxCUY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499b57cf2f3so1993205e9.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787264331; cv=none;
        d=google.com; s=arc-20260327;
        b=XJud6Z5fTWmTB/UlkHC3e8kJ1U/ka319r/7FKnCglzMFWiNOCZcN0ST6WKIYWSvzoP
         4GRoPBQVsanRlyLbxx1cnCl01+yVHvn1FGULEz5OMUIoZfsviXYt9Sv0y7r4pqUdClzw
         XSEiZRARpaDY2J4bR05DLqBMrzVX8HeyrkESoC8hi33xhIWcXFj9KvmmtOBSrElU7zWG
         j9ncdViz5JCH5S6/qu29panLkrIs+24zUw04+tSPO6z3ONE02TCLI2UW8RU6gE0Rvb96
         luzk6VXefHNKREYi3MGEHLL0hFykaipp0Guso8F6JAJHitu3fK4HmAAFOOFwZBvCXkSz
         dL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        fh=Fh3pGCGM9pnnblkdZaVonUvUJd2Sdie94HoAr0WZmno=;
        b=ZB1sRaclO2iWVa9taNk+svQhJ2ZvBi3TP+o7PfuQmch/NHZQDWtWFQxKBW6AA5fWVq
         6yZDxrCK4l4Y8zAotMIAsgcs8FYxwwbIhwPEbgHWFGExaFFqr7U/HkOmHPoTSD8mv6mN
         IH6/NOMgDq7aYsMkaMFNl7kIoDoN9ORsbrcCiCRQ+CCp9ve4EeJmSkVhG3kSUqEHp3Ar
         R3SwCnPuZO8hmQuG7vy0XelI0RBTvT8kpjGkFAtvihIbd7ZVHpRzEacKb2mct1E57T1I
         1WKTiapKdemawvParBVv/MDuCA96/8cEr+/opAYkMnXrJLJVWWKCKjgQt/fAQwqYHqfn
         826w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787264331; x=1787869131; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        b=TYNvn2nc/vGfwkIr48B9+ialnQ3yAuV8bl7DyO8PIDnXfP+OKBOHhUt55dvH8vR5Ra
         RBhERamlh4dBpcA9tkAqL5iu6U3ZP9D7Ywmky1jGrkP9J15SoYHQ8JHWIJVIuZmpfBbG
         20S9F8VA6ZZEnpUbV+feW8Yls/ruid95VYQlZjoV1EH1WWCM+9JNb4t87SAlG8c4GuGC
         +iGqyv+/urtCwvZO2GKjZjZf6CQMTTJHJcrHYONaIXQVpvGyMCcXtM1pdra1o+TXUct/
         /Q2Qzr2f2vJeD6hEtrfkSPqk/1et+jK46f5USWcj8ECx0AeHDDKBSZBup/2miytbwFSX
         NeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787264331; x=1787869131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        b=G/WJNGPFI9WXNfAXHZHPQe091gHigOUcvqNBz/WNnKGXTigL4zzqq3NfTTI3QT7N6z
         HgAyY3LOPcEydN0EPChXWfYdDYgXVewr0uqe5ApggQX9DTPf5w9lYNHUzENMpyxxp7t2
         zR24/R0fjrmbGSoPzfZU4E+jdLdBH5gAazee7psIun6q9XNKIFpUTvUBfYjQpUJKVCZq
         Qc8hnpvJy9LEJCN58+VypLud3A/8Lu7pyaJ4u6mQwKGOAL3e1qdx9zK8NTMHud9f8eBZ
         4pbaZkqkBuEsk9HhAtPGgujmja+on2dmlCt34gWmF74SCStkivsvV1Hjf00vCYXREqEE
         OW4w==
X-Forwarded-Encrypted: i=1; AHgh+Ro04gk3zZyj5jUydK+uhNaod1IJwqmnlY18UzaVCgNSHJZVouJ5A49mEPO+wiIHAjLzP0muSZawGQ==@kvack.org
X-Gm-Message-State: AOJu0YwQk8SBq8rh6Xm2ZhcbE7pdi8ZdE/Gn7WVSWYt93rxrQPHcuCkS
	fj+iJScw96P9j2Quit19wUdf2jasTn+Xt+pNJG6T7qDnWh1h6nstN/2z78O36BA9zVGE69HvnH8
	oZdYX3OyK3vTCTIWxbmg3junba3dBRB0=
X-Gm-Gg: AR+sD10S8CxoQAfOCNzcBjDP3ICuv8VdJnMpHG5mj+5EUFZAYDdr5MSEr69LKgdt4Bs
	9OMIxnqypwkeqnYDzYBuSTdN8RU7FLsL7360Mw89B1bvoE5SWI6MtqCbN+dAgzTITGLDOHwtAy+
	/B00VfYBhsY/o2+WmF/v1wXW4MIVeSvEObirj/ssSDuSEWjecrZ9FWqyYSYQPekxchqOQpuDYmo
	CddvOsLH4amrbV8SISCIagdyvq5c8LuA/Ka97+lSWgEvoOS5Eghk/evgFf/ZgTgEr/jEtZ/XFet
	mDVU5oVEr+zYhHeRgXrczXTQ3RydlHIg47M5yf9Qs9XTLXsP/WsSN2Q1vejjRXXT27WMpYCT7k4
	/29PYkMhZS+YtYlZZXERepm9W
X-Received: by 2002:a05:600c:a49:b0:499:a5cb:b7c0 with SMTP id
 5b1f17b1804b1-499b918220cmr8341265e9.3.1787264330884; Thu, 20 Aug 2026
 15:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
In-Reply-To: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Aug 2026 15:18:39 -0700
X-Gm-Features: AcwNN1UmS6o7R2p1JRS4hnYVKjw12Bx5uXT5qvOPMj3jePhrevkwxCe1iUpKn9s
Message-ID: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Song Hu <husong@kylinos.cn>, Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C21240004
X-Stat-Signature: n3hkguj6k5eymspnyb9qdgekbtiwzpp6
X-HE-Tag: 1787264332-639512
X-HE-Meta: U2FsdGVkX19t+/L8d0z1EoMHlzyDHUtB4shLzb2KbOe9m1xV2BmJtvAywl3Nnq5DNzZV689CY0aAATArPJrvIafPhddk5+k9tDI34aQC1cuNd959TaV5V2XD/zCo9EVEeIIYcUVyr6DkYjWwiACiQF2rUgyLonkU72JkXShx7KkjFu47SnA0JSa4JyolWlyfUchsyh7FsuYgG75kLTMjrF6dMHUbv7AjuhskYodbJm4PL4KzowtP+JmOtpTQ6NuWXJ2NsFcfhQeC6G6rTCK5u1T2kDP6YO77MsIIn25Q5BLYphYUW4NN1hxuZC2Xlo+ZLQjHEoehDuUmbbZYOI1LhBsu+yYOBl6MrIAE5K32w/IyQcWIHTp3lMRQ0nN9QE9/nY86TbFm2r2GEM0BrKERhU3iE87WKbzzLeKCfhagNnyCVrpXPMcJJ5VKl+nNAynwjDkc8Nk0l4UozetGeZFNW3gAcwIfVeHcx3oYrCIKUyPAoi0h726szPoPrk2kSW3/6hM+hS88SRWsEhJlHdK/CEo9JG0bd/lDL3ppxZ0x26MIbQBp0ArVSLuKGawp6M4pI/wvznCkt+M1CYpq7mcNZavvUCfQ4Yukzg9BZfeiN3kcjXAg8TTQ9iR+ZuMHgxT4XSyNFpgx/7KipA8vxWzgO/Yx7d+cf4+sgDJyFk/D0XEC0CsBsENO2FMN/EvIXQg4ufD1uI3ZCdaR6kzrCM99V/WIIBNSsvtnJFtAOq25IFfWQC2cLexpuwghlpy6iYjqY6ij+NghKTzcBsxCQYz136Vjrw0hbu2zpoMGHunrtvjcGbrwliW4QYjExUzi33ZzMq3Z3VCuw0gUahWTPz+qhYU7fk12OIRJiqV+AxW6mJjYa0lsLfG5IG2iQ9WMJbnh4emWjzqUA4CtN5pm2UnyvDAUoFXvac4j2D42/QQKazitMa8seDDqbM7r2D82lg2nKFA2y8QbW0pQSiq+vm2
 M9xl5/uZ
 5/7n7TrYCwMzFPocz0WUU7WmCE8TftR/RIlzW0ktKAJX1+Li5RIcIpiLTW+nvj4i8rkq3+qKl7KVPBMcky1xW+zJIUbAgtQrd7m1nV/khKMVTsqrbyCyQW9KgTkJzemWK52NU76a4kN8+CceOOpGVn/biACaN6eyfbzd0vJh3EHVDN4T1cDOot6IsBnhOdFR06kVE6Pp010JqY7LPOrTI/pELFF2UMMuQkKxOJJBhKzO9sd/oLFyncxJ/EnPTAKbmhrTTVHtCX+ZnGj7ko0S9N3oUcA7oU45HTj0prOW1xaPLIGN2hBxD9gbh8VKcYHydwlV1e9h64lx/NvC9eCNgt9O9xY5zHsPYrC11H3C9hLnrEh0OIFTHaEqb73upGtSJOgeUe3re10v7H1iq6xzX8Wa/Ulf1rwd4Wf+RxmxuKlOT/qQ9lz9Ezvfb7kOotSC12eP0JuYBObGxFn7PVODTEf61ZwRoaNUwQE89RYQ8h1C+3Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> wrote=
:
> >
> >
> >
> > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which skips
> > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > >> with zswap.max configured, a container takes the global rstat lock
> > >> on every swapped-out folio.
> > >
> > > Any reason you are limiting zswap through zswap.max?
> > >
> >
> > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > can soak the pool and crowd out the others.  zswap.max is the only
> > per-cgroup control over that share; memory.max bounds the total
> > footprint, not the share of the pool.
> >
> > >>
> > >> zswap_shrinker_count() had the same pattern and switched to
> > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > >> where the same flush on the shrinker side showed up at 2.88% of
> > >> kernel cycles under osq_lock on a 96-core machine.
> > >>
> > >> Measured on a KVM guest with a swap storm under a cgroup with
> > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > >> before the patch and 198,968 times after, while
> > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > >> 80,445 times after.  The removed 200,572 flushes match the store
> > >> attempt count almost exactly; the remainder comes from other stats
> > >> readers in the swap path.
> > >
> > > This is a known issue. Using ratelimited interface also comes with a =
drawback
> > > that the kernel may react on stale information and the consequences m=
ight be
> > > unneeded oom-kills.
> > >
> > > There was orthogonal discussion on moving zswap limit enforcement awa=
y from
> > > rstat. Yosry, any updates on that?
>
> I am not actively looking into that, but Joanne was looking into
> AFAICT. I will respond to the thread there and CC Song as well.
>

For this zswap stat, I ran some benchmarks comparing 4 approaches
(switchable behind a runtime knob [1]):
a) rstat + forced flush       (baseline aka what the tree does today)
b) rstat + ratelimited         (Song's proposal)
c) hierarchical per-CPU   (Yosry's idea from [2])
d) page counters              (following what all the other memcg limits do=
)

For the setup, the benchmark creates a cgroup chain at depth X with
memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
every level, and spins up 20 processes there that each allocate 100
MiB, fault it in, and touch every page four more times. With that 2000
MiB against the 1 GiB memory.max, it triggers reclaim continuously and
makes the swap traffic go through zswap. The machine I ran this on had
80 CPUs.

I also ran it with no memory.zswap.max set (ie no reads triggered,
only update path runs) - as I understand it, this is the configuration
that is more often used in practice.

These are the results I saw:

kernel cpu time (in ns) per zswap store, zswap.max set
                      a)                     b)            c)              =
  d)
depth 1        567,116          35,604     35,841     34,995
depth 2      1,082,007          35,507     37,803     36,209
depth 4      2,153,329          37,591     40,117     39,893
depth 8      4,211,692          34,963     41,070     44,211
depth 32    15,728,220       53,575     94,685     65,946

kernel cpu time (in ns) per zswap store, no zswap.max (update path only):
                        a)                  b)              c)            d=
)
depth 1         34,787          34,062     34,930     35,630
depth 2         34,913          35,061     36,404     36,360
depth 4         36,422          36,809     36,922     37,483
depth 8         42,177          34,440     36,679     40,793
depth 32        55,309          55,321     57,671     59,190

c) and d) are for the most part pretty comparable to b) without
introducing the staleness problem of b). Between c) and d), I think d)
ends up outperforming c) as the # of cpus and depth gets larger.

I'm seeing that all the other memory limits (eg memory.swap.max,
memory.max, etc) are already using page counters. Is there a reason
the zswap stat can't? If not, does it make sense for the zswap stat to
switch over to using page counters?

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35fa=
f58c33b1d7c9b
[2] https://lore.kernel.org/linux-fsdevel/anpsLy_pCanocgS1@google.com/

> > >
> >
> > Fair point.  The direction I had considered is the benign one -
> > stale low after a burst of stores overshoots admission for a cycle.
> > But after a burst of writebacks the folded value can be stale high
> > too, and premature rejection with zswap.writeback off or swap.max
> > tight ends in a memcg OOM kill that accurate stats would have
> > avoided.  may_zswap() is admission control rather than a hint, so
> > the guarantee matters more here than for the shrinker side
> > of ea80da363a1f.
> >
> > If moving the limit enforcement off rstat is happening, that
> > supersedes this patch and I am happy to drop it.  Otherwise it can
> > serve as a stopgap for the per-folio lock cost - your call, and
> > curious where Yosry's discussion stands.
>
> Not sure how much progress is being made there, but I would really
> like to stop the proliferation of ratelimited flushing, especially in
> this case where it can cause OOM kills.

