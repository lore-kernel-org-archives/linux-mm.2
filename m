Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7980C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 03:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0E66B008A; Sat, 25 Jul 2026 23:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961CE6B008C; Sat, 25 Jul 2026 23:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B626B0093; Sat, 25 Jul 2026 23:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49B436B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 23:41:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9C1CC03F8
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:41:37 +0000 (UTC)
X-FDA: 85029528234.29.5B8158B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A3B41A0003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:41:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlGBpR39;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785037295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkADIxC9LollhrgQLxTH7CQ7/itWZvo+cSzWq1mnaeY=;
	b=EkEnxWp0xVww4wm7yre4nxRbjDNy0z4nCZloNd5rUKtJTpe/g8Av5xxSAmwF6aoE3mptZz
	+53Gz9tQyORR6EZgPaVrJIOT2rhSLHj939IuonmIkhonAOYRwkF02lo0l+3s6aTMSWfx+r
	xeQ7pE376kyl/oYOnNInmxI0BbjXBpY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlGBpR39;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785037295;
	b=u3Qikb0S5fUTKdFz4oCEqvvnpRfYS1lgnMl3XPM9aDWNqMwCIOD+E8Q5c7eiOiIhumLKZl
	fa/Tr6McDWfAKblOGq/l+jcvBDI+fyv+YwpbI8/fBC13VilHHQu/jdA6UWbf6Kw4yQ37eL
	7xJlzIadl8CrenJhojDAgKUsRt3hKYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7973A43D8C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB21F00ADB
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785037294;
	bh=NkADIxC9LollhrgQLxTH7CQ7/itWZvo+cSzWq1mnaeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YlGBpR39A7BI9JnZeG4ESuLwKsnszBdpMmIOwTrYXL9xda8T7PALaWNCm587VTD7L
	 SnhAQ3ElkzP5WmcrOC6oPqlf5dt9torCOiYyFXnrFaUFqB7BDZIWU0p2lge449OBuF
	 yqSUpk9nzNU2l5kNrNHRVwnzJjF1inSM6JhfU8WNrqEHPkLctTxNVupNyo61HpHkj6
	 i+XZVCuO+T/uSrGlkZodwsng6iPMfrXKadUFCG0e20mOfUN3rwLnfabZHoIjisb/xQ
	 FC0tG9XLzDaYavJ0ExLJiOhLbAe0IBiPQug/e7oWjx5Vjo+dzCL35YT4AkVt/Xt2Cq
	 KsgFGceLQeqOQ==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e622cc874so94728585a.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 20:41:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrc1MvCnkKL6f4a3E44CdAPrk1FKcF7tZAxj0BGBKH+mTkCzV57aITe6SGiuttRfm7qRSmPoQH2ag==@kvack.org
X-Gm-Message-State: AOJu0YwPvaqAhq+dmI2PRFWvDaCCZ+7bEKwOGnD/cJYvyS7HzMxikycl
	UXK+Gf8YNkP0tG3p4+J/kQIS8DoGo6jJxclUjf1dpLdeDrtJBoeMreGX8KVNxGyk60nXrCLuP3+
	wtC7cOFHoVGCnVmjxiWSqJwr0afvcszI=
X-Received: by 2002:a05:620a:648a:b0:92e:c118:18e3 with SMTP id
 af79cd13be357-932df76e53amr390974785a.90.1785037293482; Sat, 25 Jul 2026
 20:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260726012946.18684-1-baohua@kernel.org>
In-Reply-To: <20260726012946.18684-1-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 26 Jul 2026 11:41:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ymvbGLrqzAp55+WgbqVy7GmDdsqK4ThAajZG_qDS1Hzw@mail.gmail.com>
X-Gm-Features: AUfX_mzahjOhIDTWyjSbGRNY2BgNfAcx_ceV0_LpDczmMYPdysf3jsuuCCoyMc4
Message-ID: <CAGsJ_4ymvbGLrqzAp55+WgbqVy7GmDdsqK4ThAajZG_qDS1Hzw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] mm: mglru: fix swappiness behavior
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, 
	stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A3B41A0003
X-Stat-Signature: mz8buen1tfyu4gcf6dgdg396fus4ecj8
X-HE-Tag: 1785037295-361860
X-HE-Meta: U2FsdGVkX18Zs61N3EsQh7tx1xwKQLk3fHOXksAx3CfCKb+yKRdJupCtAsrkKbW17qi9m9Fd2xOvdu9y/+tRb9ftOJUoO7W28skwhMFvnrAvEJ4F5HVI2ojCiT7kkRicUItsq713ztdIPIuRwDug1Uh8N2F/imctMNGDO2tG1aF/qV9bIxkb49SdkaZYWt3FnCWSKCf5bCf2jK7N26wYMy/JTsSGKNqflmP+0eed/U1zd1Zza3lZPR2zhzdgXCjn4KSn4eeIpE7qhaqGoE+6tPzvGgNLc/KUAJywkMpfY/iMcUiEge9UZqFVCcWy1PjY44ybYZ+ymgwu4Ap5DaonEiGrOOHZE8A4X5auKSsYc5SRqe909RXOeSx5MTVli+Hx998Ap7tV4vL7nc0WT/iI3rWB9/P0Ddhqw6b9asJMspsdt7uClVHS1ZU2uNA1IIex7sTibBin4APO/fwNN+3S6lJaVxzxddJFEnCoyb7VZYfMw+D546auqKv3MfvTAhB81s+PzsLvQXH9BX6QsWfXGRJEUc4jx+sHr/Iq1s68v0zO4z86G+zWLTy9aHCiXRw4ryMKeJO2adrOcoHe1/PEWczyphTKmpZZa2Icz775CJA1yvFnW7/vbh5Qw0gRfO3ZrvLyvohng6fXsFVwHdIK64AluJbDVhvkTmRSFBDZZflm/nsbZMGRvrXg3it+6TfxL24TA2Cd3tJpOk/zBwp3uYTtV0anpYhl10Tx7bByAyvQi8WxIyZOwG6r6M9SisVjJlujOEk3T4Qkc7hhP9UKu3fFmJOPwgP84WLmx7yvJRMSbhfMaK98LNbt77ZgRvqGbt45ai+dKsky7v4h/MMN1O7nbzY7pnLu6QtE0Bho+NMamgQEumVU/y8GxfcUNz0UWjWwwJY9UIibZWazjIzOJm7Afi2UBNPKCB2CfYvOdbS/0B8tv5VI2sMVdD+FWiV0t0hIWAUIbf0XANbMnaZ
 xjgzLIzV
 Kqwyr5fkg5QSok7n7Fqpy8ndO7Lv+p4/cW739bJrn/PqchuquMx3unpyjs+V+noSF5874b7nX3MDuXZJcHPg3A9nFmeSXAYLB7wd2TnEkmE/noKZ5TradopUe+oagOiThPYtsf5rUZV6voFTAjXv3UaBTOINlVvdnhTK6I+Y+alHwr80HjXcrqTbiANwOWFY54Q/84/6WjzRIGUEALOkccSqRpDxoQBCFkP43LCPWaDrlBsZ1yUG/bVYxuNuE0f2oaeJSspzRUl6aj12JJlikrrPrhOoFJLqi8Su4+xTUJb0+C0LojCgRL2tQd3v6kQB5iOPxjX2N6BTTZBAeNqtBAaqHsUnPu2ps/zeszg6WMvspTrBsbjh/vC5dtTOfm7fkpQ0h9Jq/Wam3eDBmqVnv0AXX7TzNyx/vga2+Ocu4ybRr0FXCLGcLZ+kePYFWhs7/oHaM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 9:29=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> The active/inactive LRU respects swappiness well. Anonymous page
> scanning and reclamation increase roughly linearly with
> swappiness, while file page scanning and reclamation decrease
> accordingly.
> For example, when swappiness reaches 200, both pgsteal_file and
> pgscan_file drop to zero while building the kernel in a 1 GB
> memcg. In contrast, MGLRU shows almost no change across different
> swappiness values.
>
>                    pgsteal_file
>
> Swappiness    LRU         MGLRU
> --------------------------------
> 1             10567455      763612
> 36              990706      480205
> 71              688170      415848
> 106             446294      386164
> 141             286307      359196
> 176             201733      351686
> 200                  0      330093
>
>
>                    pgsteal_anon
>
> Swappiness    LRU         MGLRU
> --------------------------------
> 1              4410548     2726362
> 36             2465268     2762859
> 71             2677908     2885124
> 106            2737227     2841796
> 141            2984276     3035015
> 176            3381338     2938302
> 200           13116359     3113499
>
>
>                    pgscan_file
>
> Swappiness    LRU         MGLRU
> --------------------------------
> 1             17997223      923094
> 36             1325674      539571
> 71              852345      464222
> 106             538207      464477
> 141             357253      412277
> 176             217536      399446
> 200                  0      375902
>
>
>                    pgscan_anon
>
> Swappiness    LRU         MGLRU
> --------------------------------
> 1             31639423     5987136
> 36            23441521     5753224
> 71            26067110     6101780
> 106           25619448     5782919
> 141           26842088     6234264
> 176           29200021     5980292
> 200           62193924     6413125
>
> This patchset respects the type selected by positive_ctrl_err(),
> which uses swappiness as its gain. It does so by:
>
> 1. Avoiding premature fallback to the other type. Only fall back
>    when reclaim is running at high priority.
>
> 2. Running aging when the preferred type has few or no
>    reclaimable folios, so more folios of that type become
>    reclaimable.
>
> With this patchset, swappiness starts to behave similarly to the
> active/inactive LRU.
>
>                          pgsteal_file
>
> Swappiness      LRU        MGLRU      MGLRU+Patch
> -------------------------------------------------
> 1             10567455      763612        3507619
> 36              990706      480205         528781
> 71              688170      415848         478478
> 106             446294      386164         411632
> 141             286307      359196         375137
> 176             201733      351686         298586
> 200                  0      330093              0
>
>
>                          pgsteal_anon
>
> Swappiness      LRU        MGLRU      MGLRU+Patch
> -------------------------------------------------
> 1              4410548     2726362        2876888
> 36             2465268     2762859        3022062
> 71             2677908     2885124        3129555
> 106            2737227     2841796        2974192
> 141            2984276     3035015        3092280
> 176            3381338     2938302        3353395
> 200           13116359     3113499       14348518
>
>
>                          pgscan_file
>
> Swappiness      LRU        MGLRU      MGLRU+Patch
> -------------------------------------------------
> 1             17997223      923094        5842416
> 36             1325674      539571         648111
> 71              852345      464222         569930
> 106             538207      464477         480767
> 141             357253      412277         431911
> 176             217536      399446         337768
> 200                  0      375902              0
>
>
>                          pgscan_anon
>
> Swappiness      LRU        MGLRU      MGLRU+Patch
> -------------------------------------------------
> 1             31639423     5987136        4658593
> 36            23441521     5753224        5444726
> 71            26067110     6101780        5755804
> 106           25619448     5782919        5872415
> 141           26842088     6234264        6144096
> 176           29200021     5980292        6615500
> 200           62193924     6413125       22984986
>
> Another possible approach is to decouple anonymous and file-backed
> aging by maintaining separate max_seq values for each type. This
> allows anonymous and file-backed memory to age and be reclaimed
> independently, enabling the swappiness-preferred type to be reclaimed
> more aggressively while allowing the other type to lag behind. This
> approach has already been adopted by projects such as CachyOS [1] and
> Chromium [2].
>
> However, this approach requires substantial changes to MGLRU and
> fundamentally alters its design by breaking the shared aging timeline
> between anonymous and file-backed memory. This timeline is the
> foundation for mechanisms such as the PID controller and the
> min_ttl_ms thrashing protection.
>
> That is why this patchset aims to fix the swappiness behavior
> without fundamentally changing MGLRU's design, with minimal changes.
>
> [1] https://github.com/firelzrd/re-swappiness
> [2] https://chromium.googlesource.com/chromiumos/third_party/kernel/+log/=
929932351492d01f0aee37a0ac3be8c7bd88f80d
>
> Barry Song (Xiaomi) (3):
>   mm: mglru: only fall back when reclaim is running at high priority
>   mm: mglru: do try_to_inc_min_seq if scanned=3D=3D0
>   mm: mglru: run aging if the preferred type has no folios in
>     reclaimable gens
>
> lyugaofei (1):
>   mm: mglru: run aging when pages are severely imbalanced across gens

I checked Sashiki's comment:
https://sashiko.dev/#/patchset/20260726012946.18684-1-baohua@kernel.org

1. Sashiko says
"
> @@ -4858,6 +4858,7 @@ static int isolate_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
> * Only fall back when reclaim is running at high priority.
> */
> if (!scanned) {
> + try_to_inc_min_seq(lruvec, swappiness);
Is this call to try_to_inc_min_seq() redundant?
The caller evict_folios() acquires the LRU lock and calls
try_to_inc_min_seq() just before calling isolate_folios().
If scanned =3D=3D 0 on the first iteration of the loop in isolate_folios(),
the lists haven't changed since the previous try_to_inc_min_seq() call.
This means get_nr_gens =3D=3D MIN_NR_GENS, making this new call a strict
no-op.
If scanned =3D=3D 0 happens on the second iteration (because the first
iteration processed folios without isolating any), try_to_inc_min_seq()
might advance min_seq. However, the for_each_evictable_type() loop
only iterates twice, so it terminates immediately without scanning the
newly advanced generation.
After isolate_folios() returns, evict_folios() unconditionally calls
try_to_inc_min_seq() again anyway. Does this logic successfully retry
with new folios, or does it only perform unnecessary work?
"

I observed that scan_folios() always returns 0 because the list is
empty, making the following early-return check appear to be
ineffective:

        if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
                return 0;

So I thought min_seq should be advanced when scanned =3D=3D 0, since
there are no folios left in the reclaimable generation.

After taking another look, I realized that isn't the real issue.
The problem is that try_to_inc_min_seq() doesn't always reflect the
actual oldest reclaimable generation. It can leave min_seq pointing
to an older generation even after that generation has no folios
remaining:

static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
{
        ...
        /* see the comment on lru_gen_folio */
        if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
                unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;

                if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < =
seq)
                        min_seq[LRU_GEN_ANON] =3D seq;
                else if (min_seq[LRU_GEN_FILE] > seq &&
min_seq[LRU_GEN_ANON] < seq)
                        min_seq[LRU_GEN_FILE] =3D seq;
        }
}

I think the function itself should be fixed instead. Otherwise, I can
leave it as is and simply drop the newly added call to
try_to_inc_min_seq().

2. Sashiko says

"
> + gen =3D lru_gen_from_seq(seq);
This isn't a bug, but is this second assignment of gen redundant since it w=
as
already initialized to the exact same value in its declaration?
"

This is right. I will fix it in RFC v2.

3. Sashiko says
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 566c4e837c7d5..f794027607767 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4855,9 +4855,12 @@ static int isolate_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> * If scanned > 0 and isolated =3D=3D 0, avoid falling back to the
> * other type, as this type remains sufficient. Falling back
> * too readily can disrupt the positive_ctrl_err() bias.
> + * Only fall back when reclaim is running at high priority.
> */
> - if (!scanned)
> - type =3D !type;
> + if (!scanned) {
Does this logic completely prevent kswapd from falling back to the other LR=
U
type?
Looking at kswapd's reclaim loop in balance_pgdat(), it explicitly exits
before sc.priority reaches 0:
mm/vmscan.c:balance_pgdat() {
...
if (raise_priority || !nr_reclaimed)
sc.priority--;
} while (sc.priority >=3D 1);
Because sc.priority never reaches 0 inside the kswapd reclaim path, kswapd
will never satisfy this fallback condition. It will repeatedly scan the
empty type, fail to make progress, drop its priority, and eventually give u=
p
and sleep.
For direct reclaim, this also means processes will stall fruitlessly throug=
h
multiple priority drops (triggering VMSCAN_THROTTLE_NOPROGRESS delays)
before finally reaching priority 0 and falling back, which could lead to
severe stalling or premature OOM killer invocation.
> + if (!sc->priority)
> + type =3D !type;
> + }
> }

This seems to be a valid concern. I could address it by:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index be34b8b946ad..d69a0ed26f8c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4859,7 +4859,7 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                 */
                if (!scanned) {
                        try_to_inc_min_seq(lruvec, swappiness);
-                       if (!sc->priority)
+                       if (sc->priority <=3D 2)
                                type =3D !type;
                }
        }

4. Sashiko says

"> But with a stricter condition: the youngest gen must have at
> least four times as many folios as the oldest. This helps keep
> folios of the preferred type distributed across the reclaimable
> gens.
Is the commit message description accurate regarding "the youngest gen"?
Looking at lru_gen_imbalanced(), the code checks:
if (seq + MIN_NR_GENS > max_seq)
Since MIN_NR_GENS is 2, wouldn't this condition group the two youngest
generations into the young variable rather than just the single youngest
generation?"

Yes, I'll update the description.

5. Sashiko says
"
> +static bool lru_gen_imbalanced(struct lruvec *lruvec, int type,
> + unsigned long max_seq, unsigned long min_seq,
> + int swappiness)
> +{
> + struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> + unsigned long young =3D 0, old =3D 0, seq;
> +
> + if (swappiness =3D=3D MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
> + return false;
Does this unexpectedly disable the imbalance heuristic for systems where
swappiness is configured to 0?
When swappiness is 0 (MIN_SWAPPINESS), get_type_to_scan() correctly selects
LRU_GEN_FILE, but this check causes an immediate return of false. Wouldn't
file pages still need to be balanced across generations on these systems?
"

Technically, we should maintain the balance for swappiness values of
0 and 201 as well. However, in those cases we always reclaim a single
type, so the swappiness bias is irrelevant. We can therefore skip
this.

Best Regards
Barry

