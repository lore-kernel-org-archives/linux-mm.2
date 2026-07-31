Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66EFC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 23:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3886B0088; Fri, 31 Jul 2026 19:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78AF16B008A; Fri, 31 Jul 2026 19:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7136B008C; Fri, 31 Jul 2026 19:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 404D16B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:33:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7D26A01E4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:33:31 +0000 (UTC)
X-FDA: 85050675822.17.DCBEA25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D55E0C0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:33:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1q1CWJi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785540810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7915x5o+7+QwzRXdlpGQp/YpYXzXT04kydeHEVKdkWc=;
	b=34DD974Xy1ZyukiTBTlj6fY1HCgEFQc/AX3l0OjQV2RMoAHxDnHdooOpGwjZsGhbXnvGkq
	LL0kUED5jij+Rh4FOF1DwK/QRDL9fTb8X9dxHFfmmPPDiRmsZXR6n7gwabt3X2BfCqwWDB
	P7DJ0Cs7+zKf7QQ50ddhzpetmNUdvfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785540810;
	b=Wz4Bnc+kx9ULvX/Wz/JDPYAr5/6WG/OsPmRRi5iKtlgsXYFtbFQuk1RIqTiz+mhFFPWcaG
	dBUrcCZka1NPDkG0PuQyqa13Kqh5UqPu8LAvCH5c0FzxB7bTVH1qSvIWFfuNTL+Wqwpp7Y
	Sqz6LTQuDgX/hkJiZqJTzUY272WDwSs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1q1CWJi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3435444FEB
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4EC1F00AC4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785540808;
	bh=7915x5o+7+QwzRXdlpGQp/YpYXzXT04kydeHEVKdkWc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m1q1CWJiWqw3tnVHwvtoE8Lz6ojQFGQ6AZdX/Ld1jE8jY+vb+sSU1LEwjPNb7/BO9
	 HFauED9ifVOfJUyRRHPQGOBFHR71wyNaWbP+j9HOf3+WehDN9i5tj1GuKgD5gL5oWw
	 Ne6AwrB/XPHVBYFuyHXmY4YocjJg7N0JQ+rwMiXWHQPmqb561SW9G4LWZ2fZkBV1/k
	 e7RjOQWFKy56uiHSZhzt5pJ3d6YT1MyX3t78IZuNHt8w1QtH2/JiOpO1S7p5n8h1h0
	 3FGl81ViOiFZauZRhd9LHK/XCyfesccr1saZ/+IZd+oGy5ZFq2FpEvyatTxPBWu4Ek
	 YRassCcurrvGg==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e6c4a867cso106514085a.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:33:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpVibG6DT4+AeOW8FYrkR/B3dpHo3Kpm6xiVxwGgMLh3AliZ0kg+EBQsl6ovJhSjYXPLTVJ6QEebg==@kvack.org
X-Gm-Message-State: AOJu0Yyb8mZXhVNIZM1hNPa/rIN5Eu7VxrZqSeaT6pEzBPxrkCC9j+lS
	5EZtdKTmHVRtH4jhBKZ5xESjgK631oNSiahO2mTfd7w4gQWdA1QcBhRNJQxxgC6KTVpc3S+5VJO
	gGhSHUvTzfsTn89uo3Hgb9/3x6Ew2km8=
X-Received: by 2002:a05:620a:410f:b0:92e:e695:d622 with SMTP id
 af79cd13be357-934a093821dmr371165985a.28.1785540807225; Fri, 31 Jul 2026
 16:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260731083843.37811-1-baohua@kernel.org> <20260731083843.37811-5-baohua@kernel.org>
In-Reply-To: <20260731083843.37811-5-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 1 Aug 2026 07:33:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y_v1PNyAEg1Xj8FciPNSkaoFifGnxM34QuUWFWMup79Q@mail.gmail.com>
X-Gm-Features: AUfX_mxrSwBCQcSPvJ6gXz-cE-o3KgiYpFl_Hj0twi_cEW52rNMntKNum63ZrMY
Message-ID: <CAGsJ_4y_v1PNyAEg1Xj8FciPNSkaoFifGnxM34QuUWFWMup79Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/6] mm: mglru: improve scan_folios() exhaustion detection
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, weixugc@google.com, 
	yuanchu@google.com, chenridong@xiaomi.com, zhangbo56@xiaomi.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D55E0C0003
X-Stat-Signature: 5gjongfih8gegpga83bwaeznzrj5yqxh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785540809-668241
X-HE-Meta: U2FsdGVkX1/SOxK3rmpL3olyV3k5mCsITczMN+ftuv4jmepIrauwXzRfPOMVEvxN+yBUZd8h7Qv/BXxdwTPZBOuG1gJVOfnU2bw6smGxaVbMTwWt1+A/bn+1QyYd4J9+Ant9aAMgCPaDCzixAb+XOP9Dl4wtEC50TC3i14uyFy0Cm5SJzPMFfChgeEY12oFHUTCLFub+gW804KksCbllKusgxiG8B3FLl46QRrUbNu83LdT1Z2EE79QcQkwOb2Oddn4k3YLxENLMCqbtZeA5or+BId6cscdyybVxDdUDdMV7OFtoVVBclXagDD+b++8vC0aSdBw1ojEQ066Dsb4L2WF/Z0M9jYbNjgZcPkQwkowvkXlgNc+Ro4M1vEyMjEYm452BsiS3sMNs+aBXjlrx6+WZEdfrttoE0LN3tBBzaRApwra19eSPZdgm4YApKKoBCrBYIgQsqgX+sExiQRb926Jx3ZlkUqhhnCY9dmKoEtkVAUeUfSlrmTbEY8fhdfkh/91Ez+dFT2VRlTeHsdAKZYvFbf/niuoE+kLJqCdVsTK8PgaIo9/GEROHMn6hPoHDuzhjx4NFWPOfDovLJDDsP1G9X6LXaBbc/2UnnZ4ByFUyZefiSfvqRjzcQYnogslANroaUXFgyrPERpugC7qplAxAhocKM5kXUSjovLQtFReXIx2cfQH90Hk5flcO48dQKDeA5VubHoEAqpGNKIlghwRAejobLfc7/cYktgRGoaEusEbSXChpvummiRsxjqO6+uB/1S3H6bRvHzZjIMxwbHIRYNB5NQSG1w7lDnKuCfiPrOTJh4MfRkDVE/S9Sm9hTpJ/r0vWP84VHnG1lg19bwI23MZ6Qs5/ncoXfv/Av/z1yE4ofUvP3iBt0+8XqR/PVb/4ccSHSVuqN5NvG0IyzM27QauLGZDxj+Er5DEgllmdjKNa+SSuIhSEDFbC1Yii67imz3OEl+AZmwcFwmv
 SBpZ0vWF
 Scx7Ax1psyBOMPb8fg8HRSOiCUTbRU8me/Y3jwcwRjimKCoqRNpxtBHdPeMLbNyzG8j7XZDW/YNxd9xkhG7p1HtmING3+6nFsD/Y5dyaIpNelvUzy/S/yBWkoEp32WHDSKCgTwOEWAFsaxdkbUlPCJ4kOgJ3cj2LuTiz7oaV1s1CleKKiWZzyn0uAc6+9k6yLv/yY2k+PUT+jJXZw796oRqsu38Nrm0OuKjO7RTshf9+c1XUt9+MFQAWa0EY87AxuweP4+SmYT672yfRpQWO0V0BuC6XkMxtKK8Sp9hyDURYvvcS0trU1v24r7oGuoIon464/pxON3UnT5b6mIsfLkaJR32/gCUQE9Lf7p2lTE2BFTs7Ha2mXxTneZEAMadCaIUMKGRF3AnRQQn6WTgKppGhbdPdEvdZw5rRkkpGkCu3DcPTHQIV5x9NQ0Nkr4ON3nCt3FyvzldHZkGpGtLQxPCic8Fkf7vJhwEsccWVXmy2dulY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 4:39=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
> isolation makes no progress") uses scanned =3D=3D 0 to determine
> whether scan_folios() has exhausted a reclaim type. However,
> this is not always sufficient. It is possible for scanned > 0,
> while the oldest reclaimable generation is exhausted after the
> first scan_folios() call.
>
> Add an exhausted output argument to scan_folios() so it can
> explicitly report whether the reclaimable lists for the current
> type have been exhausted.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0038f33aa318..2e7fef6975b6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4707,7 +4707,8 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list, int *isolatedp)
> +                      struct list_head *list, int *isolatedp,
> +                      bool *exhausted)
>  {
>         int i;
>         int gen;
> @@ -4723,8 +4724,10 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
> -       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> +       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS) {
> +               *exhausted =3D true;
>                 return 0;
> +       }
>
>  next_gen:
>         gen =3D lru_gen_from_seq(min_seq);
> @@ -4785,6 +4788,11 @@ static int scan_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>
> +       /*
> +        * This scan exhausted the reclaimable lists before reaching the
> +        * scan target or accumulating enough isolated folios.
> +        */
> +       *exhausted =3D remaining > 0 && isolated < MIN_LRU_BATCH;

https://sashiko.dev/#/patchset/20260731083843.37811-1-baohua%40kernel.org

"Does this logic properly account for early loop termination when large fol=
ios
are skipped?
Looking at the scanning loop earlier in scan_folios():
} else {
      list_move(&folio->lru, &moved);
      skipped_zone +=3D delta;
}
if (!--remaining || max(isolated, skipped_zone) >=3D MIN_LRU_BATCH)
      break;
If a large folio is skipped, skipped_zone can instantly reach or exceed
MIN_LRU_BATCH. This causes the loop to break early while remaining is still
greater than zero.
Because isolated would also be less than MIN_LRU_BATCH at this point, could
this incorrectly evaluate the exhausted flag to true? This appears like it
would signal to isolate_folios() that the current reclaim type is completel=
y
empty, triggering a premature fallback to the other reclaim type and breaki=
ng
the cost-based reclaim balancing logic."

This is a good point. We could break out of a zone once
skipped_zone >=3D MIN_LRU_BATCH, provided the zone still
contains folios.

It seems I can fix this by checking whether we exited
early after reaching the scan target due to any reason:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 902d85afc5f6..c0e14048ab7f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4720,6 +4720,7 @@ static int scan_folios(unsigned long nr_to_scan,
struct lruvec *lruvec,
        unsigned long remaining =3D nr_to_scan;
        struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
        unsigned long min_seq =3D lrugen->min_seq[type];
+       bool reached_scan_target =3D false;

        VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
        VM_WARN_ON_ONCE(!list_empty(list));
@@ -4758,8 +4759,10 @@ static int scan_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                                skipped_zone +=3D delta;
                        }

-                       if (!--remaining || max(isolated,
skipped_zone) >=3D MIN_LRU_BATCH)
+                       if (!--remaining || max(isolated,
skipped_zone) >=3D MIN_LRU_BATCH) {
+                               reached_scan_target =3D true;
                                break;
+                       }
                }

                if (skipped_zone) {
@@ -4768,8 +4771,10 @@ static int scan_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                        skipped +=3D skipped_zone;
                }

-               if (!remaining || isolated >=3D MIN_LRU_BATCH)
+               if (!remaining || isolated >=3D MIN_LRU_BATCH) {
+                       reached_scan_target =3D true;
                        break;
+               }
        }

        /*
@@ -4788,11 +4793,7 @@ static int scan_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                                scanned, skipped, isolated,
                                type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANO=
N);

-       /*
-        * This scan exhausted the reclaimable lists before reaching the
-        * scan target or accumulating enough isolated folios.
-        */
-       *exhausted =3D remaining > 0 && isolated < MIN_LRU_BATCH;
+       *exhausted =3D !reached_scan_target;
        *isolatedp =3D isolated;
        return scanned;
 }

