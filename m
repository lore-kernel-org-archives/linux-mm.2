Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78335606C2DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FnEHRgWo
Received: by kanga.kvack.org (Postfix)
	id 67E246B05BB; Wed, 11 Nov 2026 17:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EB06B05BC; Wed, 11 Nov 2026 17:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545616B05BD; Wed, 11 Nov 2026 17:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEA86B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:01:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86D0840436
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:01:48 +0000 (UTC)
X-FDA: 85424211096.08.0D851A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7190840007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:01:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnEHRgWo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XW+W+IvRYtlcrp5klt8UaDvpzVbHTAiI7YDJRBlK4lQ=;
	b=vYjKGgueN/fWp6nIEemtXibloK5LcjqP2oBeSID5Mjat6d4pg7Szh2n9jYRUBp/FntcKea
	Y9m3/UlZeRdArYO0jISrd14F3J0NbeaGp6HvIM6XHB1BSpkw2qhWojSdBznxRifVAxThOv
	on/q9nLL6CJQdwi8yKPGX89VDTPKBHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434506;
	b=u5wYeoPKucwKYsKvPrr1kv0jTTYtaQLDAcr2NG4tVnGt23uq4cxaTEAaHMdo0mzqo/EXYr
	6iGSXVOu+5T3J0+ranqPutZaXu6hPqv0wckxfP0vTRc1+0Ft+wTsEPA+DZqaEzBTdqPTdz
	4SqegGQrkn7HG4R6HzG9dIIqCAKRI6I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnEHRgWo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92B1F4784E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F781F00A0C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434505;
	bh=XW+W+IvRYtlcrp5klt8UaDvpzVbHTAiI7YDJRBlK4lQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FnEHRgWoYi1jbqXYbUUgH87NLAN/rjVD9CNEag67OtavTus3pAXmPuoEXYV09sUmV
	 7dIrTJmaogazMfwW9LIEtKK7B3iH8fr6ksHJOkqeqpyXh8/R3wSGBAkr3pTXeqg8h8
	 aTz2PyOZBU5pTgGhFQFFh0y6uU4BR8+zcq+ff6dhJ7OSflm9q13knJ5isljuZRgQsL
	 Rk9YUL3UoUa5FAPToyqjqrg1yTyYLlU5R4Jcthy5KzcHqAm5/MR4nsUD9lOzCGEsT/
	 kJKeW1+8BsqVA68yRbqKjZZT9KLZvBZTsII6RY3qejg/6nzKWjA1pMO+dx+Z/eI8/0
	 kjKgYy/JRwXZg==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91f0c4f7a8fso7369896d6.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:01:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH1EQEV1C+vVGefzxaU/Bso9oSItTUJApCAbzGYZnyUKmRvkqFsinAgtom+SSbmCF22Q74eCSkX9A==@kvack.org
X-Gm-Message-State: APuU4Z//ls5oc3qIK7PIqjsucao3/rgkVPF1SNI+h/y9fPRxYkbVMcBg
	ee7UQwGl8pwQIrlD3NEai0ztLjSt2JtVjMQpTprTGhTxYMLqQIt7L1gnaf5pPv106V21zjzXwwO
	QIWIXigQ6uzuKLxdh1u4RXaQwztXBTgk=
X-Received: by 2002:a05:620a:a195:20b0:947:b201:fad6 with SMTP id
 af79cd13be357-947b2022f47mr420628885a.68.1794434504674; Wed, 11 Nov 2026
 14:01:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110202025.25736-1-baohua@kernel.org> <20261110202025.25736-8-baohua@kernel.org>
 <sashiko-outbox-207744@kernel.org>
In-Reply-To: <sashiko-outbox-207744@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 06:01:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y4PBNutH3antEorzOw75GzAj50Y4-zXa3AW6wZ1PQP0w@mail.gmail.com>
X-Gm-Features: AclHuK-znX198smVgGAytsDbBJGgYonffly9uT4RSqSFEL392RS9laz-yJy7pwE
Message-ID: <CAGsJ_4y4PBNutH3antEorzOw75GzAj50Y4-zXa3AW6wZ1PQP0w@mail.gmail.com>
Subject: Re: [PATCH v6 07/15] mm/mglru: balance anon and file scan budget by
 refault rate
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ibs7hnuhxacszzd8cd7op543i9kre9ig
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7190840007
X-HE-Tag: 1794434506-934027
X-HE-Meta: U2FsdGVkX1+eq7T24GQTf9ob07mVmwCXZGexeTii6vdfZRG0P38WDAfK64YoB+3UuGFaAPqmW+h7b01QHEJZ5YEA2n7OLvBktntAzoLZ4HjXcT3Oy7IXCaLRpV0SK97aF9nU0NgLD4unlp7f7c/iP9rICsVIR8jxYon7Oi1hpKVpQFuwhtEAgVSmkNVdkutpw4wwY1ZMkEanWAu9RewlmVLzcOrCkRf9TrWMpXxPalCSmkxqWENAMh4L8uQThVdmuf8K7dOOCY+LMFLdjjKBDRePV5SUB3Ot3nbHUgAq/BK1PyWjPI4V4LIFlRzW0bduou2Xt81/UVmzMF8TinqQAxcmizoRhxZL2aUBXhT9peazUW1Sx9V4XH04VCbIsCalsUwfvQWpJprS3kWCRqrkGrKfYPkPmM7C7yMZQdlv6c+qm9wzTUlxr/Jd0UnesF2SVT2S2A0jDyAekMr9K+yWS7b399WVylq/kVjX0t58kfz+3+jX/DoKr5sj/krPiN5jVMGR+Ngf5WsLd4wqV4ib8D5w8Nh904fQ5VSmMpS30ltwWDOjKjgwA4bXD2cWnIw7orR/3mrcpnnYhJ5ZqjJhhUliwHnImRnEz1lkn2+ppFXtLJGKPhwx/0+EWNZeVu5JAjrX+4zMRjt1yLF96pN4ModTSZSAM/ziNnO+OjngjbfnQVbmBDmDoiGg8KCEzsKNdBOLzT6wk7I21Ct8iyUXWqrhemozAg+JlDuLoKQxBh0bB5+cY1iUV9xND9wQk2naBT4PdmzmMGhLpnJwrH2Dpj3Hs7jGqT7CjQ9AIRvLLEWlsTdW0AnNeupDgLjJU8Z/Jt5fvB1+JGmUE6U7DfaJQTemdPQy1K0NSvvAYewB9ElW853dEmRITAXagGSRXpFATEmvcTnMUjZh1+yILP3qobuGMjQ+tElt0mopDLxIyOVqT2hKhmLbfkulDmdBfTRAFlNoyt1dAt+2S5TXihC
 bAa8lxqL
 IAuGMVhT6VqsVstySUtLBdn+MCypbnNEXMhATuBgz+Hd1+LLKmrgKgv9BWgVUpJvtrWHvSSLb/aD0FuLtKH9BdhGttHQq+ZP5AO6AoRCGdSl/aAkQGkXh1VLaImus2e39cmRUL3v6pN0nf9ZsFRe/GaYxeT5GSLvyCF2aHTWzbqu2pUe/P2t+LiOl7vVkFaMDC7q4zdcXetDd4y/03MDQ0l4DV8vppOdx67c8f4hcjneIiX21Vc88yu/af3+15jqMRy53+cdeVTqWKjRs3X5TSDftcLH8w8fLNBnXcZwitkXwoZbRK/Om8ZUBvznbgFiPVtZS1rebzi4vtktJ3S6KBhxDf5souRijHdHvhwk4mNP3UNmHqH9fyn0WFXflfc4GKWkkVCJIksCQFpgr764CO+W8JzXMQDgwuUOTTeUDv6m6fISPjDsOBFdNaShIGwbMvC3kBgDIMS/oHaCYWKcXOm3w0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [Medium] mm/mglru: lru_gen_balance_scan() budgets un-scannable
>   generations
> - [Low] mm/mglru: lru_gen_prepare_scan() re-adds obsolete offline memcg
>   check
> - [Low] mm/mglru: u64 overflow in lru_gen_balance_scan() excess budget
>   handoff
> - [Low] mm/mglru: unzeroed budget on empty scan in evict_folio_lists()
> --
>
> commit 20aa81528d31d5bc56afcb10aeda259624bda6c8
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: balance anon and file scan budget by refault rate
>
> This commit replaces MGLRU's single-type-per-batch selection with
> lru_gen_balance_scan() and evict_folio_lists() to split the scan budget
> between anon and file LRUs based on per-type refault rates and LRU sizes.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index e2807faf26deb..6b325fe73436a 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4858,79 +4858,110 @@ static int get_tier_idx(struct lruvec *lruvec,=
 int type)
>
> [ ... ]
>
> > +     /* Cross-multiply the ratio above. */
> > +     anon_scan =3D mul_u64_u64_div_u64(total_scan, anon_factor, anon_f=
actor + file_factor);
> > +     file_scan =3D (u64)total_scan - anon_scan;
> > +
> >       /*
> > -      * We scanned some folios but failed to isolate any due to promot=
ions,
> > -      * protections, or races. Retry once to avoid a larger loop.
> > +      * Bound each type by its evictable size. Hand the exceeding part=
 to
> > +      * the other type. Any excess left when total_scan exceeds both s=
izes
> > +      * is dropped, since it only stresses the scanner with no gain.
> >        */
> > -     if (scanned && !tried) {
> > -             tried =3D true;
> > -             goto retry;
> > -     }
> > -
> > -     return total_scanned;
> > +     if (anon_scan > nr[LRU_GEN_ANON])
> > +             file_scan +=3D anon_scan - nr[LRU_GEN_ANON];
> > +     if (file_scan > nr[LRU_GEN_FILE])
> > +             anon_scan +=3D file_scan - nr[LRU_GEN_FILE];
> > +     nr[LRU_GEN_ANON] =3D min_t(u64, anon_scan, nr[LRU_GEN_ANON]);
> > +     nr[LRU_GEN_FILE] =3D min_t(u64, file_scan, nr[LRU_GEN_FILE]);
> >  }
>
> [Severity: Low]
> Can anon_scan overflow u64 when total_scan exceeds total and both if
> branches run?
>
> In lru_gen_seq_write() -> run_cmd() -> run_eviction(), the optional
> nr_to_reclaim argument defaults to ULONG_MAX, so total_scan passed to
> lru_gen_balance_scan() can be near U64_MAX.  When anon_scan exceeds
> nr[LRU_GEN_ANON], the first branch sets file_scan to
> total_scan - nr[LRU_GEN_ANON] without clamping anon_scan, and the second
> branch then adds total_scan - total to the unclamped anon_scan.  If
> anon_scan + total_scan - total wraps modulo 2^64 to a value smaller than
> nr[LRU_GEN_ANON], nr[LRU_GEN_ANON] is truncated below the available
> anonymous size.  Using else if (or clamping total_scan to total upfront)
> avoids the overflow.

yes. else if:

        if (anon_scan > nr[LRU_GEN_ANON])
                file_scan +=3D anon_scan - nr[LRU_GEN_ANON];
        else if (file_scan > nr[LRU_GEN_FILE])
                anon_scan +=3D file_scan - nr[LRU_GEN_FILE];

>
> [ ... ]
>
> > @@ -5051,18 +5083,22 @@ static bool should_run_aging(struct lruvec *lru=
vec, unsigned long max_seq,
> >       return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> >  }
> >
> > -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc,
> > -                        struct mem_cgroup *memcg, int swappiness)
> > +static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_co=
ntrol *sc,
> > +             struct mem_cgroup *memcg, int swappiness,
> > +             unsigned long nr_to_scan[])
> >  {
> > -     unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> > +     unsigned long total;
> >
> > -     lruvec_evictable_size(lruvec, swappiness, sizes);
> > -     evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> > +     lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> > +     total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> >
> > -     nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable=
);
> > -     nr_to_scan >>=3D sc->priority;
> > +     /* Just scrape all pages calculated above if this memcg was delet=
ed */
> > +     if (!mem_cgroup_online(memcg))
> > +             return;
> >
> > -     return nr_to_scan;
> > +     total =3D apply_proportional_protection(memcg, sc, total);
> > +     total >>=3D sc->priority;
> > +     lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
> >  }
>
> [Severity: Low]
> Does this re-introduce the !mem_cgroup_online(memcg) early return that
> 2e203d692b0cb ("mm/vmscan: remove redundant !mem_cgroup_online() checks")
> removed from get_nr_to_scan()?
>
> Offlined memcgs already have all LRU folios reparented and
> lruvec_evictable_size() equal to 0, so returning early here only skips
> apply_proportional_protection() and misses setting sc->memcg_low_skipped
> when an offlined memcg still has stale effective memory.low protection.

Oops, my fault. As mentioned in the cover letter, I ran into
quite a few conflicts while rebasing, and handled this one
incorrectly. I'll drop the following in v7:

/* Reclaim all pages calculated above if this memcg was deleted */
if (!mem_cgroup_online(memcg))
       return;

>
> [ ... ]
>
> > @@ -5095,6 +5131,30 @@ static bool should_abort_scan(struct lruvec *lru=
vec, struct scan_control *sc)
> >       return true;
> >  }
> >
> > +static long evict_folio_lists(unsigned long nr_to_scan[], struct lruve=
c *lruvec,
> > +                          struct scan_control *sc, int swappiness, uns=
igned long max_batch)
> > +{
> > +     int type;
> > +     unsigned long batch, scanned, total_scanned =3D 0;
> > +
> > +     /*
> > +      * Scan both types with the given budgets; the caller checks if
> > +      * reclaim is satisfied after each pass.
> > +      */
> > +     for (type =3D LRU_GEN_FILE; type >=3D LRU_GEN_ANON; type--) {
> > +             if (!nr_to_scan[type])
> > +                     continue;
> > +
> > +             batch =3D min(nr_to_scan[type], max_batch);
> > +             scanned =3D evict_folios(batch, lruvec, sc, type, swappin=
ess);
> > +
> > +             nr_to_scan[type] -=3D min(nr_to_scan[type], scanned);
> > +             total_scanned +=3D scanned;
> > +     }
> > +
> > +     return total_scanned;
> > +}
>
> [Severity: Low]
> When evict_folios() returns 0 for one type because that type has no folio=
s
> in scannable generations, shouldn't nr_to_scan[type] be cleared to 0?
>
> Leaving nr_to_scan[type] unchanged causes try_to_shrink_lruvec() to call
> evict_folios() on the empty type on every subsequent MIN_LRU_BATCH pass
> while the other type still has budget, and then run one extra iteration
> (including should_run_aging() and try_to_inc_max_seq()) after the
> scannable type's budget reaches 0.

I guess we can do an aging when one type has no populatable folios:

@@ -5116,6 +5117,13 @@ static bool should_run_aging(struct lruvec
*lruvec, unsigned long max_seq,
        if (sc->priority =3D=3D DEF_PRIORITY)
                return false;

+       /*
+        * Run aging if scan budget remains but no folios
+        * in populatable generations are available to scan.
+        */
+       if (no_populatable)
+               return true;
+
        /* better to run aging even though eviction is still possible */
        if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max=
_seq)
                return true;
@@ -5220,20 +5228,17 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)
        lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);

        while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+               unsigned long orig_file, orig_anon;
                DEFINE_MAX_SEQ(lruvec);
+               bool no_populatable;

                if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
                        need_rotate =3D true;
                        break;
                }

-               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-                       trace_mm_mglru_aging(lruvec, sc, swappiness);
-                       if (try_to_inc_max_seq(lruvec, max_seq,
swappiness, false))
-                               need_rotate =3D true;
-                       should_age =3D true;
-               }
-
+               orig_anon =3D nr[LRU_GEN_ANON];

>
> [ ... ]
>
> > @@ -5781,8 +5838,11 @@ static int run_eviction(struct lruvec *lruvec, u=
nsigned long seq, struct scan_co
> >               if (sc->nr_reclaimed >=3D nr_to_reclaim)
> >                       return 0;
> >
> > -             nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_LR=
U_BATCH);
> > -             if (!evict_folios(nr_batch, lruvec, sc, swappiness))
> > +             lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> > +             lru_gen_balance_scan(lruvec, swappiness,
> > +                                  nr_to_reclaim - sc->nr_reclaimed, nr=
_to_scan);
> > +
> > +             if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness=
, MAX_LRU_BATCH))
> >                       return 0;
> >
> >               cond_resched();
>
> [Severity: Medium]
> Can lru_gen_balance_scan() assign scan budget to a type that has no folio=
s
> in scannable generations instead of handing that budget to the other type=
?
>
> Previously, isolate_folios() fell back to !type whenever scan_folios()
> returned 0.  Now, lru_gen_balance_scan() only transfers excess budget whe=
n
> a type's share exceeds nr[type] from lruvec_evictable_size(), which sums
> folios across all generations min_seq[type]..max_seq including protected
> younger generations (such as max_seq - 1 and max_seq at DEF_PRIORITY).
>
> When one type has drained all folios in its scannable cold generations
> while still holding folios in younger generations, lruvec_evictable_size(=
)
> remains non-zero and lru_gen_balance_scan() keeps assigning budget to tha=
t
> type.  In try_to_shrink_lruvec(), that share of the scan budget is lost;

Should be handled by the no-populatable aging logic above.

> in run_eviction() (where priority is fixed at DEF_PRIORITY), if the
> remaining scannable type's share rounds down to 0 (for example when
> nr_to_reclaim - sc->nr_reclaimed is small or at swappiness =3D=3D
> MAX_SWAPPINESS), evict_folio_lists() scans nothing and aborts proactive
> reclaim early while the other type still has cold folios.

For run_eviction(), I think we can remove the newly added
code, since sc->priority used to be always 0:

@@ -5845,6 +5905,7 @@ static ssize_t lru_gen_seq_write(struct file
*file, const char __user *src,
  .may_writepage =3D true,
  .may_unmap =3D true,
  .may_swap =3D true,
+ .priority =3D DEF_PRIORITY,
  .reclaim_idx =3D MAX_NR_ZONES - 1,
  .gfp_mask =3D GFP_KERNEL,
  .proactive =3D true,

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.25=
736-1-baohua@kernel.org?part=3D7

Thanks,
Barry

