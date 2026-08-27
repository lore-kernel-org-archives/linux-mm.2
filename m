Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103DDC5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 05:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607316B0088; Thu, 27 Aug 2026 01:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B81F6B008A; Thu, 27 Aug 2026 01:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480646B008C; Thu, 27 Aug 2026 01:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18D6E6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:09:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E4508031C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:09:24 +0000 (UTC)
X-FDA: 85145871048.25.6831E74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8CA7340003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:09:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WbDosI2g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787807362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIemAInrSQAqRGk6VU9YhZnzgdSHJsdHYZKk+J1gQ1I=;
	b=4H6e0YPi1soH/plcbXPyJRmY2rJjuVwF4wXphOtqOZ7/sXwO+9MBsnA8WUE+xCLpa6M3hi
	3M6FLzB+c6nKEvnXCELstOwF89hwHtsSZ5WFJms3EBPv2Z44mQsrD+3cz+orpfErOv6Ncq
	kFLB1YMDArsatUFle9CsugUkU6D4oMs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WbDosI2g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787807362;
	b=zbk3g2PIoYKonSWOZ41M8wOnYr96yNPzPxANtHOAo+XKiUCL7m7Xcv0Vw8l8utKOcqaZK+
	boNzsHMDMclNgYSQpLuUvSInlMPDlHFnBOI7QZgDXeL0t5/UdvUUnvQmvwIuGzQ+DzZynx
	xu6w92hKv5hw3PwxATfaefgpBiiN3Mo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F42343E4D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5549B1F00AC4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787807361;
	bh=OIemAInrSQAqRGk6VU9YhZnzgdSHJsdHYZKk+J1gQ1I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WbDosI2gb8m/mz5SS50+NCKseZM1oVAnz3JxUAH6CCRz7ue80sUB9wt6+rrFOKzSo
	 VqrgFcnGjnrXu5+wj2CxDo/vCHXUfhtPtDQjc4DJNI6+210+FCFMN1gnE/qUDI6GWe
	 SWto3HZqTlKQfuAevEf2YupkAbCp9oThy4y3F3UTiKqhYYpOC0ItKmU+7OVL8CbLKA
	 WSfzOSBDvo2aSTnBOVv0MGr1efxVhUXjzRtmgiSXtuALdOcevcs2AXimjY+1uDAm96
	 5MZOKE/rd8lktMKSatPzA7UuCERdYmVNEUTV/G6SIEPu6GMbCaPag6CwsqjPqGIon7
	 q7ENaKWyxrHBQ==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-930f618435cso112894485a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:09:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqbCF/HIuA8+hnbPwoRx6Bye2S82VdbhCvnDngZe5KcVc+56LRA/N7vzxPXaGOW9wsBaZTatJCI0A==@kvack.org
X-Gm-Message-State: AFuF++mp1mgQfxDB1OMuXlbOovwkbP/v/IHL4hRiOU5ut0zvyHOANmou
	P++X0zBYtwWDa0rDHsmn5+QvwRtS1wn/SRbRa0X2oJ0LS/XN0p4SzlWgpbE0pT8ujYbGgeWrMtJ
	W/Zx9JnQTJkSWqrkaLXSKRBKTJhcP5Bc=
X-Received: by 2002:a05:620a:5805:b0:936:bc78:791b with SMTP id
 af79cd13be357-9378016fc29mr1040773985a.15.1787807360659; Wed, 26 Aug 2026
 22:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-3-baohua@kernel.org>
 <ao6tlwWNN1MH29w7@fedora>
In-Reply-To: <ao6tlwWNN1MH29w7@fedora>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 13:09:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zFRy8qMCSnxy7PnagBnh6eXCPXnaJs0=yT1Q2t-6w+gg@mail.gmail.com>
X-Gm-Features: AcwNN1UnPSDJP9kKhtNpolLcjcslgDDP1kSy4F-YbS4025-D83rNQERov2iLCrA
Message-ID: <CAGsJ_4zFRy8qMCSnxy7PnagBnh6eXCPXnaJs0=yT1Q2t-6w+gg@mail.gmail.com>
Subject: Re: [PATCH 2/6] mm/mglru: batch update lrugen->protected in inc_min_seq()
To: Baoquan He <baoquan.he@linux.dev>, Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CA7340003
X-Stat-Signature: nqxsea3hce6ic91s5e6ppzozs9d4tai5
X-Rspam-User: 
X-HE-Tag: 1787807362-265683
X-HE-Meta: U2FsdGVkX19z6axpeB3CsO9hr+V+0koBuVGGLC0TdSB9LyF78WzLmv4VNqrF5r9VpHO39OP/l4zYKnaVa2cK+L9iCRcxhr7AjC0lzzenqrJcmGi2As3bkte4RC2L4jS1Gz89fNrOxYEZyRubYi/QkyP6wxwPUlXErW8JFUc/UT9MTKJLka7+ypRvu8R9LWm6I5c/LwCTVQ1E+ZVwb5F8F1cOBJWPMowdtO/Juv5UTIIgsPJ8XRseKTQ5uN3No/l90Iuq0X/c7uSxgD+M5w+FOZqFK7JcaQl62PB2g+0vxzkSznM3IbV/IV9BcNuowZQfbpcgxozBpAlzzjLfwLqB8Q3oSPzFNLjTQ5lOXJTkingnmyerdB7A1UWL6EIYNWqbtAoEeQ9Ro05tk5/xTpW+ByVKHBlAfLqP+kk+zZ7QKrzbJSCn497aAsTXDwzP0AaVIIdAHA316TaXdUpSzRmmyvhHyljgT0Dy1JzsLnTEfIGDNDsJ/tXHXERPHid02Xpa6TKoXJ8GBcvDHLd7kvYUbG9TvOcfF//9POg9vlL5+A/JEoK5vGhGErbB3LcVusK0IySLf0/rsPRxku8dyAhiJ8YGYYDiItJtfjNP9YeHStim5zsl99hApbV0opLkAB4uq24ogRACDABaqfSk9CEhceeJBewCAqJ1z+eQj016nqsQHC/uL/tjpCR2CAwWGCfXbkEAvZUVF5DGwvGkgicKVz0tCc45V+nefVPUxCOLg41AWLnzKTwRqWi3PdXAaatwXgGRdRAbAJMiL6E4E+HVxAKhq0sy2sSoYvwWo5zlYexkqR13PrmXgWzAJqN2J+daEyJg1PT1P37Y33M9yzkqKSTOc8aWLitzvpgZi999n6BxRi8nylUe8vbNmvjSBEXLJTkUq3qGovic1NhUbZJ/MSEcWOYomgWYZHEyjjq9FHxo+M5bE/hCmlsNgUJpX2f3Zc6/xYSd4jmgCuu+62y
 J6fobJHZ
 1w13REbOWwAis5ubG4N5u59Ba1uyBzQZzwM8djLF3RqN7WYkk3/igNiSDjMeOkYIEyIUs3LF2DcQctEcpVdpfaKH8aWlgKuFoAg2cj2VC/5WDKnzdYaVZp7yAzSuzFMKgVfIW9KLVl4lSvFkKN/Q1umj4jlMwjmq+osNs0mLRpQ+Fxyu17cqmZmBq/qHOZA7jVYLEulWt4R0bvhKbIhfknU+LYJR8p2Hs2xoWCDaj/2fWWenT9WygYoyLeUJU/MyvaCiYZHw+fyQRDEQ+GMUFl51y1DOB0N9zQcSN9wBAqChEXYPaXBkuYsigxg9Y0oCpg0lKMGLtVPSa9AVpQjmo2EC3e9vXt3sJUERt54oausqNDavGO6VuzQXJ0OkfBw2grLs+z/uCUnNBnYuyoeyK2VEJ+IU91BCdn1TzDTjCaKsoBqw2lDBByrR3QNsi/p+BQPldBBNIoJ6U8hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 5:10=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > Avoid updating lrugen->protected with WRITE_ONCE() for each folio,
> > which may prevent potential compiler optimizations. Accumulate the
> > updates locally and apply them in a batch instead.
>
> Wondering how much efficiency this can bring, is there a number for this
> standalone patch?

This is a good question. I reverted the protection batching to check its
impact:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 996b48344ed0..c9a2fd9ad844 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3957,7 +3957,7 @@ static bool inc_min_seq(struct lruvec *lruvec,
int type, int swappiness)
        for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
                struct list_head *target_list =3D
&lrugen->folios[target_gen][type][zone];
                struct list_head *head =3D &lrugen->folios[old_gen][type][z=
one];
-               unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D 0;
+               unsigned long delta =3D 0;
                struct list_head *pos =3D head->next;
                struct list_head *batch_end =3D NULL;

@@ -3984,7 +3984,8 @@ static bool inc_min_seq(struct lruvec *lruvec,
int type, int swappiness)
                                if (refs + workingset !=3D
BIT(LRU_REFS_WIDTH) + 1) {
                                        int tier =3D
lru_tier_from_refs(refs, workingset);

-                                       protected[tier] +=3D nr_pages;
+
WRITE_ONCE(lrugen->protected[hist][type][tier],
+
lrugen->protected[hist][type][tier] + nr_pages);
                                }
                        } else {
                                flush_lru_batch(head, &batch_end, target_li=
st);
@@ -3999,9 +4000,6 @@ static bool inc_min_seq(struct lruvec *lruvec,
int type, int swappiness)
                           lrugen->nr_pages[old_gen][type][zone] - delta);
                WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
                           lrugen->nr_pages[target_gen][type][zone] + delta=
);
-               for (int tier =3D 0; tier < MAX_NR_TIERS; tier++)
-                       WRITE_ONCE(lrugen->protected[hist][type][tier],
-                                  lrugen->protected[hist][type][tier]
+ protected[tier]);
                if (!remaining)
                        return false;
        }


And I see:

With protection batching:

Running scope as unit: agetest.scope
mmap: 0x7c4b1d200000, size: 512 MB
memcg: 12893 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.538 ms
gen   4:    0.937 ms
gen   5:    2.348 ms
gen   6:    2.300 ms
gen   7:    2.302 ms
gen   8:    2.294 ms
gen   9:    2.296 ms
...
gen 100:    2.292 ms
gen 101:    2.307 ms
gen 102:    2.293 ms
gen 103:    2.293 ms

Total:   235.718 ms
Average: 2.334 ms

Without protection batching:

Running scope as unit: agetest.scope
mmap: 0x775682e00000, size: 512 MB
memcg: 12823 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.542 ms
gen   4:    0.948 ms
gen   5:    2.338 ms
...
gen 101:    2.340 ms
gen 102:    2.342 ms
gen 103:    2.347 ms

Total:   240.505 ms
Average: 2.381 ms

It=E2=80=99s 2.334 vs. 2.381, which is really minor.

I=E2=80=99m curious to see what the data looks like on ARM. If there=E2=80=
=99s no
significant difference, we may drop this patch in v2 to reduce the amount
of code change.

Xueyuan, since you=E2=80=99ve been testing this patchset on ARM[1], would y=
ou mind
checking this on ARM as well?

[1] https://lore.kernel.org/linux-mm/20260827035416.3012015-1-xueyuan.chen2=
1@gmail.com/

>
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0d74fc00abd3..99ee3c833d54 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3931,7 +3931,7 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >       /* prevent cold/hot inversion if the type is evictable */
> >       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> >               struct list_head *head =3D &lrugen->folios[old_gen][type]=
[zone];
> > -             unsigned long delta =3D 0;
> > +             unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D 0=
;
> >
> >               while (!list_empty(head)) {
> >                       struct folio *folio =3D lru_to_folio(head);
> > @@ -3953,8 +3953,7 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >                       if (refs + workingset !=3D BIT(LRU_REFS_WIDTH) + =
1) {
> >                               int tier =3D lru_tier_from_refs(refs, wor=
kingset);
> >
> > -                             WRITE_ONCE(lrugen->protected[hist][type][=
tier],
> > -                                        lrugen->protected[hist][type][=
tier] + nr_pages);
> > +                             protected[tier] +=3D nr_pages;
> >                       }
> >
> >                       if (!--remaining)
> > @@ -3964,6 +3963,9 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >                          lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> >               WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> >                          lrugen->nr_pages[target_gen][type][zone] + del=
ta);
> > +             for (int tier =3D 0; tier < MAX_NR_TIERS; tier++)
> > +                     WRITE_ONCE(lrugen->protected[hist][type][tier],
> > +                                lrugen->protected[hist][type][tier] + =
protected[tier]);
> >               if (!remaining)
> >                       return false;
> >       }
> > --
> > 2.34.1
> >

Thanks
Barry

