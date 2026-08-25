Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419F0C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2ED76B0088; Tue, 25 Aug 2026 17:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF726B008A; Tue, 25 Aug 2026 17:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF196B008C; Tue, 25 Aug 2026 17:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD106B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:11:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0E501601BF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:11:32 +0000 (UTC)
X-FDA: 85141038024.24.F27BFED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDD3114000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:11:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nb3p4RDP;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787692291;
	b=YtYeMyqz2oPisrowF2MfpxZSNFUBSgFljmZ0hQrfkiN8/frrjANSo33E1R+BcRKfvYrsnN
	z6I8nrlLMGAwL6asMbIbSHl1HoPPlb/3KeR6OV6BpvISgUSVmnsj2aehUm5pF1MWT0AjvT
	9NZJmqtR8aXCaUe14hOr7qSJ3xdl08k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nb3p4RDP;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787692291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NqYfsC6aODjPHXjE7kXaZ0g+VvWgZRR9t4Th5jDjDA=;
	b=G+z8LU8sM/lkJtlRHBYGS1VUxF56JbgX2jGvTDD0KLX6/gLoRrZKg9RUyplu4qscY/Y1Hd
	EeajSPuhkbwR9x2Ag+H/Tv4oCa7lWmpedJ1Snn6xntQcVT2QYXaGE8luoT9F74LNTnubq7
	j76iReDrd4U+nRpVMNGl4EASKct5FVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39AC941A43
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B441F00ACF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787692289;
	bh=7NqYfsC6aODjPHXjE7kXaZ0g+VvWgZRR9t4Th5jDjDA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Nb3p4RDP9MI4tBPe5jhNUUizVWXliDN5d6WZ+IsmSZFdN6yE4Vm6M3BticrICOc72
	 0c6qrY+qwuJMG+AiouyKe1weB5K5dGjZgXEWsmTU0BjpbPd2yh73Y11PF7e298wL8s
	 KVcRhomNW31w3EXwBE4BiVQAaAji9B//YF9MY5dluWWg7aQLY0lCsfewj5T9gtjwtz
	 ODteY5vF/wCs5rUEfpp3UUUBcEdqZ6WVHgqIJnu3s0VohLf80fmuEhc5Fe+uu2l4VF
	 Q62Nl+i7SorSt7kMtvrnSClZiUubEA28lvv8YkYRQCAA/qh124VKydd14Bm/qZX9Rk
	 kmyTdz6kXYX9g==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-90cbff85fa9so2220136d6.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:11:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqmcW/qQEC2A2MD5QZuzjb/8RQo29a6L2JXxvgzpv9pq3EpaVU0Ub8hMgfefw/xNlHWGdrFEvvcmw==@kvack.org
X-Gm-Message-State: AFuF++ljp5dWqXvQF5yIXeOAQQ9D+dy944/GP8gmgCapcWnw2gDiEc7c
	0Bfb9SkXUR09meIrAFnnetzmg/X6VYn/FEoiyXYLthk3Qslwruo1VvJsIm6/4T+sHzqOiufcZHs
	SDF6RXAsxAEKgVoCxsxaWRRhqvA/uGG0=
X-Received: by 2002:ad4:5f08:0:b0:90c:b767:4d6b with SMTP id
 6a1803df08f44-90cc79ba89dmr18028066d6.19.1787692288189; Tue, 25 Aug 2026
 14:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
 <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com> <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
In-Reply-To: <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 26 Aug 2026 05:11:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com>
X-Gm-Features: AcwNN1WclAb_e-WVovZpkoLLs7qTpO1pibaBKeuK5kIf5wMMZGZFSQFqinkHsk0
Message-ID: <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, axelrasmussen@google.com, baoquan.he@linux.dev, 
	chenridong@xiaomi.com, david@kernel.org, hannes@cmpxchg.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDD3114000A
X-Stat-Signature: usxtug6gmh7jqn9kugokox9b794uo6bu
X-Rspam-User: 
X-HE-Tag: 1787692290-91015
X-HE-Meta: U2FsdGVkX197hffQjEfWW5cuhkPOq3ZRN429+fN5xwWrvaAjPx2PSIY7yIIjIu6XQ8vwblrizuQ5ghqGkbqTUTUb4LOGIovN3mzPkWbtfw7Fj3Gvw3rB+/mpNSsiUHKCNlOXWSSLu1tt85JLuas0DtB9qYl/nrw0ClEnVmhSvoMr8L12uB4VIvYnJ1fcKygCJ1Eno/I3Dg9eTaQyZgazPQ4sxHy92iamKPnE/iJpcl7vlga7JVpjOgWKRLpICFzfqXglCMp7U9rsP9RCajomhqOCZfRTm3idFhlE/dyuZxso+2pCAWBrgSArQ3FBcyvTNLCkF7mfTDMLj78vt/Ao563r1gm2eqhUhE868Zplhl6xOmEafhrSEJtBedd8n2FzUZIrWZ+xvHycz1cTfB81qy/ua6WIp+aRR6trHepHwt+pUstl9YstKriKAJP7S/fsRoFpgx1mANAw6+ya25SLXteYQtU4Kb1oLZKOvAOQn4qdzpLHmedWeueMcjREMmMTgEhEMBk2cQPui/o754lw0bn9qQuXQnMrWCjdbXKw8ccX/lBBucONJMDEXD0r6q00ZHyvbhuFS2ydlGydlLJgGpR630GNt9bVb+bc4x0y/3l4/+tbH05Q91BJQzZskUk1FiyLkd/jZXKHwugClmq1MhdmgpJu1+KqZAwgxWgmOueVyj1Qqr4p3kAo3O6P4I4rfA9FAjCMYPDUqTRKZNM70uLnJIgIxhXxjvUH3xPVGQtphamvyoahUIeqf30pGybUCjIZe/4QKPyeTsOiFXI8E0I96+aVLHVFat54SdyScbYHcfeVR/1muaBNcdZmnjGtzt2m0XealRf5th8s5QsRDaQCgNUi0gk9hzDxgNVnVCRJ7PjWOfucFTgvAQvNIieALQXHVZH8OAY+/HUGjJmGBA4rH1RO8/eco4YNyDkEL55GmOfphtEgx+C+3waCouhAwCWcbt6omAcWRy9B/SO
 dGxgJMtH
 6POVFNIQYA4I5tIU1mB28yVooUvj1742LtBa5JqKHsTkNiSoHLHzvudpGu0MIMIKu8Nv1A7H6QaDq4pXdM1iSCyVsaFcIMu/OFednM8ditf/ChOwcjdlPhjH1qNEUf9qaO3f6VwwSXLXU8ucRH7dqOwwZwhTi5c3PK6/oWmDQRZncFu9RchdXxlTLqE+Nloa7K1+8eCnfvfl2ad4ZB8or3gUokEw7c+woMNfA4/v0tW2qxuYHxYdcYP+c4rFY9MmICmWcBulmvTGaMH8tv5WWQepWMAxqWGaFc/O7Xh4hgeEkh1PYDjeIH1UVI6dmkBKgnCe55YBxVk+3AuVa7XpXQLY1Tm6QjCZngh6Nkkmdh5vY12SuI+BuWwaGZupEc7lKrMBedY3LVBFhDGmvRYLGJ7/+VmkDzLP9Q6MedgyxGF2RFqhGesUp1vuZgXloFDTvJ98BBRCS4c2CtD543QRLNuqpUH29G4VKD89G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 2:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Aug 25, 2026 at 5:06=E2=80=AFPM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> > On 8/24/26 7:05 PM, Kairui Song wrote:
> > > On Mon, Aug 24, 2026 at 3:25=E2=80=AFPM Baolin Wang
> > > <baolin.wang@linux.alibaba.com> wrote:
> > >> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> > >>> This is a cleanup series split out from the MGLRU swappiness series=
 [1],
> > >>> with the cleanup changes separated to make them easier to review.
> > >>>
> > >>> Right now, isolate_folios() is quite difficult to follow:
> > >>>
> > >>> 1. It uses for_each_evictable_type(i, swappiness) to iterate over t=
he
> > >>> types, but i is not actually used as the type within the loop body.
> > >>>
> > >>> 2. It uses scanned =3D=3D 0 to detect whether the current reclaim t=
ype is
> > >>> exhausted, but this is not an accurate indication.
> > >>>
> > >>> 3. It has an internal retry when no folios can be isolated after sc=
anning
> > >>> some folios, but the retry is implemented in a way nobody can under=
stand.
> > >>>
> > >>> This patchset makes these behaviors explicit and much easier to fol=
low.
> > >>>
> > >>> Run kernel builds for several rounds in a 1 GB memcg and take the
> > >>> average build time. The patchset shows almost no performance impact=
,
> > >>> with a very small improvement that could simply be noise:
> > >>
> > >> Just FYI:
> > >>
> > >> I tested this patchset with a 3G memcg limit and a 10G zram device,
> > >> running 'make -j32' to build kernel on my 32-core Arm machines, and =
got
> > >> some performance improvement for ths sys time:
> > >>          w/o patch       w/patch
> > >> sys     1845s           1570s
> > >>
> > >
> > > Hi Baoliln
> > >
> > > That's a very interesting result, can you share a bit more info about
> > > it? e.g. vmstat? I'm curious how this happens.
> >
> > Sure.
> >
> > > I suspect patch 2 or 3 changes the swappiness / reclaim / aging type
> > > selection behavior, or maybe it reduced the reclaim amount?
> >
> > I gathered the memcg stats as shown below.
> >
> > It looks like the direct reason for the performance improvement is an
> > obvious reduction in anon refaults, which is what this patch aims to
> > achieve I think. That is to say, we should respect the type chosen by
> > the PID for reclaim, and try to exhaust that type before falling back t=
o
> > another.
> >
> > Before this series:
> > workingset_refault_anon 59706846
> > workingset_refault_file 9229283
> > workingset_activate_anon 15108561
> > workingset_activate_file 365660
> > workingset_restore_anon 15108561
> > workingset_restore_file 1018493
> > workingset_nodereclaim 0
> > pgsteal_kswapd 0
> > pgsteal_direct 92589340
> > pgsteal_khugepaged 549
> > pgsteal_proactive 0
> > pgscan_kswapd 0
> > pgscan_direct 456629355
> > pgscan_khugepaged 549
> >
> > After this series:
> > workingset_refault_anon 41277086
> > workingset_refault_file 9131522
> > workingset_activate_anon 12924656
> > workingset_activate_file 345901
> > workingset_restore_anon 12924656
> > workingset_restore_file 1005959
> > workingset_nodereclaim 0
> > pgsteal_kswapd 0
> > pgsteal_direct 71723800
> > pgsteal_khugepaged 4013
> > pgsteal_proactive 0
> > pgscan_kswapd 0
> > pgscan_direct 342179445
> > pgscan_khugepaged 9311
>
> Thanks for the info!
>
> I think it might matches what I had in mind: we currently have a very
> subtle behavior for MGLRU: in try_to_inc_min_seq, it will refuse to
> increase the gen min_seq beyound (max_seq - MIN_NR_GENS) even if the
> last gen is empty, if another type still have MAX_NR_GENS left. As a
> result, if one type is reclaimed more, and another type have many
> folios stuck in the olest gen, the over reclaimed type will have a
> very tiny oldest generation (all new folios land on the oldest
> generation and are reclaimed immediately), that olest gen will stay at
> a near zero size and gets exhausted very frequently, with min_seq not
> increased.
>
> This will happen to file type very frequently if swappiness is low, or
> happen very frequently to anon if files are frequently reclaimed,
> really depends on the workload.
>
> The old "if (!scanned && type_fallback_allowed)" will return false and
> raise the priority very frequently. Raising the priority means the
> next reclaim cycle with run with larger reclaim ratio, resulting in
> over-reclaim on both folios and slab. What's more, it might trigger
> aging.
>
> With this series, it will see that as exhausted, and fall back to
> other type, which in fact respects the swappiness / PID less, but also

We could have the following cases:

 1. If the reclaimed type has 3 generations left (with its oldest generatio=
n
   exhausted), while !type still has 4 generations left, falling back might
   be the best behavior. There is no way to avoid the fallback by increasin=
g
   `sc->priority`, because `should_run_aging()` will not trigger aging whil=
e
   !type still has 4 generations.

2. If the reclaimed type has 3 generations left (and its oldest generation =
is
   exhausted), while !type also has 3 generations left, falling back might
   violate swappiness. If we return and increase `sc->priority`,
   `should_run_aging()` may return true and trigger aging instead:

return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_seq;

So maybe we could slightly adjust the code as shown below, although I=E2=80=
=99m
not sure if the added complexity is worthwhile:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1f302386d8ab..181285463bbe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4878,9 +4878,10 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,

        /*
         * We are running out of the current reclaim type. Fall back to
-        * the other type if allowed.
+        * the other type if it has at least two generations to reclaim.
         */
-       if (exhausted && type_fallback_allowed) {
+       if (exhausted && type_fallback_allowed &&
+           get_nr_gens(lruvec, !type) > MIN_NR_GENS + 1) {
                type =3D !type;
                type_fallback_allowed =3D false;
                goto retry;

> avoid the raised priority and over reclaim in some cases. I did a test
> on my machine and it seems matches that model:
>
> Before:
> *** Executing swappiness 1 ***
> sys: 665.941
> refault_file: 945242
> refault_anon: 916129
> pgscan_anon: 13195435
> pgscan_file: 2419874
> *** Executing swappiness 60 ***
> sys: 650.801
> refault_file: 238839
> refault_anon: 1026646
> pgscan_anon: 13082867
> pgscan_file: 809642
> *** Executing swappiness 100 ***
> sys: 621.135
> refault_file: 211113
> refault_anon: 931943
> pgscan_anon: 12008517
> pgscan_file: 778586
> *** Executing swappiness 150 ***
> sys: 633.591
> refault_file: 198239
> refault_anon: 987093
> pgscan_anon: 12645094
> pgscan_file: 709927
> *** Executing swappiness 200 ***
> sys: 627.747
> refault_file: 163649
> refault_anon: 1024657
> pgscan_anon: 12088189
> pgscan_file: 653841
>
> After:
> *** Executing swappiness 1 ***
> sys: 729.234
> refault_file: 962067
> refault_anon: 1175614
> pgscan_anon: 14588298
> pgscan_file: 2396037
> *** Executing swappiness 60 ***
> sys: 677.685
> refault_file: 238877
> refault_anon: 1008627
> pgscan_anon: 13744350
> pgscan_file: 888445
> *** Executing swappiness 100 ***
> sys: 668.947
> refault_file: 250359
> refault_anon: 994929
> pgscan_anon: 13307019
> pgscan_file: 794981
> *** Executing swappiness 150 ***
> sys: 649.764
> refault_file: 180899
> refault_anon: 971073
> pgscan_anon: 12238885
> pgscan_file: 709684
> *** Executing swappiness 200 ***
> sys: 648.377
> refault_file: 228112
> refault_anon: 1237758
> pgscan_anon: 12653346
> pgscan_file: 734499
>
> So I think in theory we might see more ineffective swappiness after
> this series, I'm also a bit concerned about the "lrugen->min_seq[type]
> + MIN_NR_GENS =3D=3D lrugen->max_seq;" check which is strictly related to
> the limitation of try_to_inc_min_seq I mentioned here... In the long
> term I think we better get rid of that limitation, not sure how the
> behavior will change or fit after this.

In the earlier RFC, I got rid of the generation sync in
`try_to_inc_min_seq()`:

https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.org/

It does help with swappiness, but also slightly increases sys time at
swappiness values around 60, so I dropped it from RFC v4.

Basically, letting file and anon catch up with each other seems to offer
the best performance at normal swappiness values such as 60=E2=80=93100, bu=
t it
essentially makes MGLRU's swappiness a toy.

>
> BTW the above tests were done with ordinary block SWAP, with ZRAM, I
> see an improvement instead (it's related to how SYNC SWAP discards the
> folio immediately and blocks the thread while ordinary SWAP does IO
> asynchronously so there would be less concurrent reclaim, and changes
> the dirty/writeback mix that evict_folios()'s
>  loop sees, especially nr_reclaimed, and here we will avoid raise of prio=
rity):
>
> Before:
> *** Executing swappiness 1 ***
> sys: 599.135
> refault_file: 925843
> refault_anon: 1838025
> pgscan_anon: 20390687
> pgscan_file: 2423955
> *** Executing swappiness 60 ***
> sys: 591.367
> refault_file: 336184
> refault_anon: 2350551
> pgscan_anon: 21099503
> pgscan_file: 1109003
> *** Executing swappiness 100 ***
> sys: 593.672
> refault_file: 328276
> refault_anon: 2332940
> pgscan_anon: 20894727
> pgscan_file: 954910
> *** Executing swappiness 150 ***
> sys: 585.939
> refault_file: 296374
> refault_anon: 2063673
> pgscan_anon: 20537898
> pgscan_file: 935107
> *** Executing swappiness 200 ***
> sys: 574.283
> refault_file: 313356
> refault_anon: 2065897
> pgscan_anon: 20145043
> pgscan_file: 881381
>
> After:
> *** Executing swappiness 1 ***
> sys: 578.699
> refault_file: 844457
> refault_anon: 1793171
> pgscan_anon: 19307170
> pgscan_file: 2364248
> *** Executing swappiness 60 ***
> sys: 582.053
> refault_file: 390580
> refault_anon: 2066277
> pgscan_anon: 20413030
> pgscan_file: 1201373
> *** Executing swappiness 100 ***
> sys: 567.520
> refault_file: 295709
> refault_anon: 1923291
> pgscan_anon: 19299837
> pgscan_file: 978007
> *** Executing swappiness 150 ***
> sys: 582.983
> refault_file: 311833
> refault_anon: 2041126
> pgscan_anon: 20547029
> pgscan_file: 940061
> *** Executing swappiness 200 ***
> sys: 562.710
> refault_file: 301914
> refault_anon: 2005846
> pgscan_anon: 19257095
> pgscan_file: 839522
>
> So in summary I think the gain is avoiding priority increase (by
> falling back to another type and satisfying the reclaim target in one
> iteration, when one type have a tailing draning gen); the loss is less
> effective swappiness. In fact, I think we might fall back to another
> type MORE, especially when under pressure, not less, contrary to what
> the patch message suggests. Not really against this change, just a
> headup that there is a impact on swappiness / aging of this change in
> an unexpected way, and things may gets more interesting if we want to
> lift that limitation in try_to_inc_min_seq as this is directly related
> to that.

As mentioned above, I=E2=80=99m not sure if we want to increase the code co=
mplexity
by distinguishing between the following two cases:

1. The other type has 2+ generations left to reclaim. In this case, even
   after `sc->priority` increases, we still have to fall back because
   `should_run_aging()` won=E2=80=99t trigger aging.

2. The other type has only 1 generation left to reclaim. In this case,
   `should_run_aging()` will trigger aging, so the previously reclaimed typ=
e
   might get a new reclaimable generation in the next iteration.

>
> Right now I'm checkng if we can archive perfect swappiness as the IO
> cost factor for MGLRU, and avoid OOM when under high pressure, so at
> least the blocker "get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS" for
> reclaim will have to gone I think (we are already seeing tons of OOM
> causes by that blocker).

I tried a couple of ways to remove `get_nr_gens(lruvec, type) =3D=3D MIN_NR=
_GENS`
from `scan_folios()`, but all of them increased sys time at normal
swappiness values. If we really want to remove it, we need to figure out
how to do so without impacting performance :-)

Best Regards
Barry

