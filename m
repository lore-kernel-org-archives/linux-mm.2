Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F3B606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rXw9sjaM
Received: by kanga.kvack.org (Postfix)
	id C63AB6B05B0; Sat, 24 Oct 2026 12:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C0E6B05B1; Sat, 24 Oct 2026 12:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51466B05B2; Sat, 24 Oct 2026 12:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80F2D6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:19:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 036C340418
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:19:50 +0000 (UTC)
X-FDA: 85358030982.09.1E2237E
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13680140006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:19:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXw9sjaM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792858789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8jBptDh3nGhMkmWNwW4GPM011tCVyIihOeKHGlsDRI=;
	b=4yhiTYIRBzfW9HFIDh+7LdU9IwqSlrGLj6bWVTR16NSFNSOypH+afUBckfe/buHfnyox8S
	10TKgfViRUEwvez2mUeovVPj0OBKoU5d551NtiBudUy0x0bm/tgmbBLKV61ZbLGVIeJB51
	+/MVb54ipSbfmAqySRbyZfF/MoU+F/I=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXw9sjaM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792858789;
	b=rqZlyP4yogCSOd+Cm8DaiFW+rtarZvI0SQod/0Ji5er3F18npOSDRaXYpnSeHcMP12ydbe
	kj2bbCrtpY/+a90i7blOphXfCzNJKIJeIa5gE2Zi/9lx27ZAWXZrvx3/Z2nArOS8cXg4mz
	FqmPEXbOz2OOYi/9a0/7ph4m+oJzxj0=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a07078200fso678746b3a.2
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792858788; cv=none;
        d=google.com; s=arc-20260327;
        b=NQBScwivwK+Tbi7y7fcHpQ+EyUApauI4vzC8hevYNHyq47cu0OaFcVg/THLUO9mmwW
         H3bUqXGwya91hqpFLmSQQfLV5HADak3v+KH0f0FXyCN33Ia+B+J4JdD3ticOA6dql1rv
         zTofFhEVtMz1tc2tT2iYzpesAzOkJkIMmSquDCJ+/sLkLbfm+fgZgFSzPhuyACSbjA+P
         l7hTeE3UOBYqxJAvmarwjHIVBPC3ph1rjygO+30oLJeWVzlAxt8qs92IopSfdQ4is0NO
         YNbtp9a2IGtUdD6AMfQl6sw88rIqPOl/jMENGTvwAuzQhmthnHBzfz+L7aL+wMTxFl+d
         omXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z8jBptDh3nGhMkmWNwW4GPM011tCVyIihOeKHGlsDRI=;
        fh=Ea7bK9o42X6N+BEfdZbuezlcYs8rOGtURV2YmmmMXI4=;
        b=LqibiwuX+joGmRbrc2jmvDV9zDZPZQMS7hApnTfRTjaFt1CpdfjxfKaau35Vukpl9g
         cskVqlPmDVeaRMrBU8HRMhHcUmuY+k/KCqTIv0Z9bMXhJOgyI0UDbFVEX+KQgZHEXA7C
         YBWeOlLU2pq6gBmwr1WcmiySKQczzZtRNtNvBGhhAqozPn2tW0vQaG+cF5ZezM0SfvQ1
         n8l1m26spz6orb+f9IuEiF+l7erVellmEtOoRU5EKK1rcaaO44hrfptgUfR9RLFO45v7
         WYn4Xb2Ox4qd29/keRIJcp1f4xLjmA0rsgrblmtmBAgUtIcgjFYv8E8glU+6Ne3Th1Nf
         vOow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858788; x=1793463588; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z8jBptDh3nGhMkmWNwW4GPM011tCVyIihOeKHGlsDRI=;
        b=rXw9sjaMOZeU8zAkXgzg4rX9/TzsCb+Znb5HeGIpHTWQEJUDIRIkq12a2srlpT3fou
         RaqQly02ErNaJRxgU7Eu7BfaFBFoJYvPYJRnMScT6/KLFFpSNL5q4Up3QNWCIAXHwYqF
         swcBNxNN9BdqFe6eUalSoP/KTTJ0AAR+thHuyAAHuMdJg50dCs+IleYujc1ML6PoZiCf
         IiaCTdsSIdCgGshk3LBzM+godp14gHRTJcrB8/z09aWARZpkfsqK12Y6iSxPeD0Y8bhJ
         SdP1zMStEQ7LG2v6EQGLG/jYoICBwQzOBnFfZM1Ay3XL0N2qBi8mwF90ERtsE8oyKptH
         MM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858788; x=1793463588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z8jBptDh3nGhMkmWNwW4GPM011tCVyIihOeKHGlsDRI=;
        b=CGUnI9FMl8ko48EAae6jKPmHfLJC23LQBoGCIc+IMIVLz32h3MUjSCB/0qe054K08X
         XBlEzntHORbJvrX3Nz9kDxi6T1DFcQo7fO73T0hgIafBs5Bsc4uYmuHq4L22rxlWRQyj
         KMOSI1rrG7uzzOobUYuBXS6SSu8y+juHYMQ3ZIfCGlQh+22EZ/fJG8iisQ/Iq/QT7NZ6
         V2stgZtQsTpBoFVu7rkPu8wVZ56IUI2rv7/uEXNALLKJHE3V2p78K4yQfW0B4ob8zWhk
         xbBlzzGC0dQRprvxnauod7ccBVMTbKznjw9cigCMctle3mDT98qrtjM5+7MG5wtwXhux
         ZhOA==
X-Forwarded-Encrypted: i=1; AKwUvBxqawG9fRgSeWVJWYxhdACKwCPRtZ496nI9xKoYC0vQa75tFOrBzumH/NOjbT5Wg5ephiyOlCyn1g==@kvack.org
X-Gm-Message-State: AFq9FYKTJumnqwv4bakzN0TUoZmRHjeh15yLkYP6xl98+CMLnn1NovRR
	agUVApQbZaOuxWlYlMFbhX06rshjHLV1DaIP+xQO89V5giG5IcZAXXWXh0KB6y/wmULEDP02mn8
	eXSSjcw9IXjvcjKku0cuZWDjPGIVg+LU=
X-Gm-Gg: AYBFou2yDeW5x4OLVhk9EbDbcxWn38HaN7Pj9Z/angihLS2Mx46YX7DT3UnkwnGqAsV
	5o30tOgofhKJd2vQVFywFC5NJ4Pdio2tt0JO1odyHjYYMAkZxBDCEg+m46PHW5hn/6D10d0JQbU
	xz3/lF3GAvVLPEIO+Dx84LT0jbZuElOJvx0y3bJ5fHd1JXqUWzExzJSez804iDQXj+TrRNUdnAU
	huws5Q8G/hMRhJSOEHExT3kuxBEFyUmWUavBavt256DzjRFDbs8IYA29VlgsRtB+8qgSEnuyi+f
	pfRbCDzV5AStRviL+zCfWnDAhCTtj93vOb4sdN7BbqKknwEyMjJf/IEWJG3eIXHuqheCrbjZmq5
	7lAjQTcFDz4bZ8IzXPdWwN4bMQ3f2G6TAiHwRwiCZnrlij0xzPM3crsWErvMCzqR5igi06Q==
X-Received: by 2002:a05:6a20:548d:b0:3e0:c3f8:4821 with SMTP id
 adf61e73a8af0-3e7cd4da8b4mr2356336637.41.1792858787664; Sat, 24 Oct 2026
 09:19:47 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-6-baohua@kernel.org>
 <sashiko-outbox-183271@kernel.org>
In-Reply-To: <sashiko-outbox-183271@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 00:19:05 +0800
X-Gm-Features: AclHuK-xQtv4r8dDkN4YIOrd37L7SThU05g33L2D4y29AVDXw1XAksvSMWjHm9E
Message-ID: <CAMgjq7C4Tu1zVCpyv82aXrGh_rmkQLngGCkoKvQrRgEYf7sC=Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 05/14] mm/mglru: skip zones above reclaim_idx
 instead of rotating them
To: sashiko-reviews@lists.linux.dev
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, 
	liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, 
	kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13680140006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 3pya4ro9u1hjtqdze8347ihcgnn55iqm
X-HE-Tag: 1792858788-305364
X-HE-Meta: U2FsdGVkX18/HCGZCN+6KzYE+FYXuqW50TCqs8Slw0uKtxcMeApxR6vWVdioe77g5bVkRS+L2j5QX31dAndbQiWkiGbLddlLXXjFVk6elioXzb3K+0j6LfmDuqlpmK0h+ACT1A73RThMG6cd9wZW70lARW08pBw0GQ+2MNpx4C0x8xIyBJpf8D0g3QCy6TjYepZQHEJ8A2RqTRveFuoGGgtmr3zuuTCq8Go+lVvtQD7x2LyjIretf1dHme0llcPOB6pZNnyoHLB6AxSJZZJsutDzbwpJCZijNaPnx0fPUmOLV43jHrVMvsNHIaLG68nHaFG2HxrKPuqh4Br85jR4jbUwDbBEBXi0ZtS8ZjlBycV+QEH/6PrC1NUP9rCTz1S8Liu907ULhUaJdiPdmqSN41qzvlpjefN6HXZuZo/BRUJu3AisJyoHiDZfoilDmPBfp6MZ+LwwwpY0UiTAXe3wTwEvXmYrD4OHRbv2Fs5zMifqsbh7Ir25A5nrw23TTmE0EBmrGCvd3lKGMQH+8nzcwJ7lp1EU2v+cR9dJCjWbfGaCHjJ1YCHr707Rfe+xA/e3pi20lr65jM6K1cJLmjdK8oMqatzJdUkY5KuMHy/yuJSwFpo2fnX586b/NUaiHv4ldhWU57/HcilPdLDayn2CvkDoDMyza3CxPHNiycUvTnOm9Ybt78QH0zbl2yhsnp5kh2R7Om3Ypul5MQOyetcGsGk+6ljZ39MTKi6k/coNs6EPXuCBvdUBGdBzUxjejUtfJjYsC4CG5CegjXzFdbm8V5nwWtMhiOlKTn+W+OrrpJj/nteUia/sOtaO8d1r6ab10ReOtnKwBC9ks2hpD4n6ohbHXgZrgHu+FCpEGKXc/xsVMIpbufkE2zlt1x3NnqP4tLeJ6DWyyV81dGjstR+rHi8zxDsXqPp9ay6IC8mP+hLj1x8JgXLGy+o12X/Wds+eP9c4UCCom2lkbchY4MH
 Uq1BzB4O
 3mQ/aiZenlSCtP5SeRCoNwFX6LQvyXUDcCwziiFcVL8BtrKmb65HuoFMfH8zrzSfplVc3o4riLeK20v3EL9bz3g6E5UkY1mw3Svi5HFsvWx7JXhprafSdWQE21O8nXEI6qigmiSfZhpTVc8EfL5LIMDKTAwM7p6zqzO/SBifyY0Sye6d/BvOY3g9kSWWjinrkXLAjKd4wXPD1xkJW2h0G4WWcz5z6ACbGtfRG1CGPdWEzqPwgmzIYCVwhUA41Rzpjs0xJmax3rFkuzzrbJpI3ejsPZPUWB3VTOTOVVH6vWuKmGJLbkM7lliN6q8TvBapv8lSYr5sJzf7VgntUVZWTBmMz7FMGrzRyTRPxFmwqht5tFx4u057a+mVn+NN2CPDR8zu+QIZEJKlGYSdBJlyLg9WTZaSLv8xqlMxlJ3g1cHiwTaguVhzDu2CMgd6EQlqLn8WsB5bL6KCvFL8P4EBAUNxl993ZEt9DcYjovoH/Yt9Ztz9jPsJYZaxcwWg2ZLMWgxHR4w/7AttoxZPsE4cLw/0hNK5Loo0M9ZdJMv8Xq/70N7YDBdKJRU0kCtxJhCncSoLq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 6:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] mm/mglru: pinned min_seq in higher zones stalls aging in scan_fo=
lios()
> --
>
> commit 1b2f683d6b8bd1e171eb9677315ba8a3d9431b9b
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: skip zones above reclaim_idx instead of rotating them
>
> This commit restricts scan_folios() and lruvec_populated_min_seq() during
> eviction to zones at or below sc->reclaim_idx, and removes the ineligible=
-zone
> rotation branch from sort_folio(). try_to_inc_min_seq() continues to chec=
k all
> zones up to MAX_NR_ZONES before advancing min_seq.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a365a4bc8c988..09ea72b354a56 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4132,7 +4132,7 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >
> >  /* Similar to lruvec_evictable_size, return the oldest populated seq o=
f the type */
> >  static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, i=
nt type,
> > -                                           unsigned long max_seq)
> > +                                           int zone_limit, unsigned lo=
ng max_seq)
> >  {
> >       int gen, zone;
> >       unsigned long min_seq;
> > @@ -4143,7 +4143,7 @@ static unsigned long lruvec_populated_min_seq(str=
uct lruvec *lruvec, int type,
> >       min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> >       while (min_seq <=3D max_seq) {
> >               gen =3D lru_gen_from_seq(min_seq);
> > -             for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > +             for (zone =3D 0; zone < zone_limit; zone++) {
> >                       if (!list_empty(&lrugen->folios[gen][type][zone])=
)
> >                               return min_seq;
> >               }
> > @@ -4166,7 +4166,7 @@ static void try_to_inc_min_seq(struct lruvec *lru=
vec, int swappiness)
> >       /* Requires at least MIN_NR_GENS gens for basic functionality */
> >       seq =3D lrugen->max_seq - MIN_NR_GENS;
> >       for_each_evictable_type(type, swappiness) {
> > -             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
seq + 1);
> > +             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
MAX_NR_ZONES, seq + 1);
> >               if (min_seq[type] > lrugen->min_seq[type])
> >                       seq_inc_flag =3D true;
> >       }
>
> [ ... ]
>
> > @@ -4863,10 +4864,8 @@ static bool sort_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct scan_c
> >        * longer be promoted or protected, so just isolate them. The one
> >        * exception is lru_gen_reparent_memcg(), which is handled above.
> >        */
> > -     if (min_gen =3D=3D max_gen) {
> > -             VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> > +     if (min_gen =3D=3D max_gen)
> >               return false;
> > -     }
> >
> >       /* protected */
> >       if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDT=
H) + 1) {
> > @@ -4883,13 +4882,6 @@ static bool sort_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct scan_c
> >               return true;
> >       }
> >
> > -     /* ineligible */
> > -     if (zone > sc->reclaim_idx) {
> > -             gen =3D folio_inc_gen(lruvec, folio, min_gen);
> > -             list_move_tail(&folio->lru, &lrugen->folios[gen][type][zo=
ne]);
> > -             return true;
> > -     }
> > -
> >       return false;
> >  }
> >
> > @@ -4921,16 +4913,17 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >                      struct scan_control *sc, int type, int tier,
> >                      struct list_head *list, int *isolatedp)
> >  {
> > -     int i;
> >       enum node_stat_item item;
> > +     int zone_idx;
> >       int sorted =3D 0;
> >       int scanned =3D 0;
> >       int isolated =3D 0;
> >       int skipped =3D 0;
> >       int gen, max_gen;
> > -     unsigned long min_seq;
> > +     unsigned long seq;
> >       unsigned long remaining =3D nr_to_scan;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > +     struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >       DEFINE_MAX_SEQ(lruvec);
> >
> >       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> > @@ -4942,24 +4935,22 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >        * when under pressure to respect swappiness more and reduce IO c=
ost.
> >        */
> >       if (sc->priority =3D=3D DEF_PRIORITY)
> > -             min_seq =3D lrugen->min_seq[type];
> > +             seq =3D lrugen->min_seq[type];
> >       else
> > -             min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen=
->max_seq);
> > +             seq =3D lrugen->max_seq;
> >
> > -     gen =3D lru_gen_from_seq(min_seq);
> > +     seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + =
1, seq);
> > +     gen =3D lru_gen_from_seq(seq);
> >       max_gen =3D lru_gen_from_seq(max_seq);
> >
> > -     for (i =3D MAX_NR_ZONES; i > 0; i--) {
> > +     /* Scan eligible zones in descending order. */
> > +     for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--) {
>
> [Severity: High]
> During zone-constrained reclaim in mm/vmscan.c (where sc->reclaim_idx is =
below
> MAX_NR_ZONES - 1 and zones above sc->reclaim_idx are populated, such as
> GFP_DMA32 reclaim with a populated ZONE_NORMAL or GFP_KERNEL reclaim with=
 a
> populated ZONE_MOVABLE), can keeping MAX_NR_ZONES in try_to_inc_min_seq()
> while removing the ineligible-zone rotation from sort_folio() stall aging=
 and
> memcg rotation?

Yeah it can stall aging, but this series lifted the restriction of
MIN_NR_GEN on eviction, and eviction will start the the last populated
gen of a zone instead of min_seq, and we have more proactive aging
when the gens are imbalanced, so this won't be a problem, it won't
cause OOM. I'm not sure if it will cause any performance issue though,
if this is concerning we can keep the old behavior, or trigger aging
when the populated gen that satisfy a reclain is below (MIN_NR_GEN -
1) or imbalanced, this seems a better solution to me, still avoid a
lot of redundant work while ensure there is no reclaim effenciency
issue. We already have the right helper to do so in this series, so
seem not hard or dirty.

