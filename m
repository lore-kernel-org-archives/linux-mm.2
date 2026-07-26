Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DEAC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216266B007B; Sun, 26 Jul 2026 18:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE006B0088; Sun, 26 Jul 2026 18:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD0F6B008A; Sun, 26 Jul 2026 18:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24846B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:08:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3ABED1405B4
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:08:54 +0000 (UTC)
X-FDA: 85032318588.19.7E9E845
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 494BF140009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:08:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpFKs7ot;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785103732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQ+eVGlwGDMKJsCmDuC5xm5gCdi70fz3MqQyw7q6x+g=;
	b=6MLZ8JO9gmcotma9Lpld+utZO8UONz5MjXBtWmR5n8EVJl14bGhbDKjvjYEUqEQgKBXdX1
	ZIIHx19uNvCmeWDR2hVzuBg5KRxH7ctSxa5eGl1XUlq8xXMlzq5+f5RgOq6dPuds4BVEe3
	ELKPx9tnyHtsFtzuIB3Pk/Sr2BsCiYs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpFKs7ot;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785103732;
	b=WRX0ey8bcWwy1D+073symqcXM0l9FtJ1jV03laa1ng2+no3EXdGQdRyXGCWvXecYc2psdN
	xItC2PmV6Q23DBsy1zcG4pFP5LiIAWoRGZY2d0GStAuHpylTVmaD2PjtyAKTy9dHmV6yKR
	icoWd92rFi3j4DI3CLLTWoR5sbVM5jQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 260F7437DF
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0020A1F00AC4
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785103731;
	bh=HQ+eVGlwGDMKJsCmDuC5xm5gCdi70fz3MqQyw7q6x+g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YpFKs7otGwdJqCOjtQQhxTsoBnhoGEusyVxc8KJ+xMMgV+T/2P7dmK37Z6uEfQiip
	 yWy8lOzyWSxebGJfcrQRxbjV+3zgiionN6JUt2GIHgrVHXhOu/dBBad8oHyjEsh5bN
	 KxI8wEwZDSBC9fMIwp77EcQzPMP72ns9eo6lUyZ/CZQV0AgQhZXGjwbheiYZth1diH
	 vdYxuvfYhLXO2/nrYqN6FGLTB/J+srlmo7f5QVWQ7grm3Tlq7KdM4cSEZ0KN5TbTiO
	 gajVr+v2+9mO+sNj2b3Zh+4EOonvltsNgLxzj6Kl/QQkDlNChR6yD0VY4f+0B+ApUW
	 06ne/HA0GS8Qg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-930f618435cso161253685a.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:08:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqDiHa5bzOKI9XNhvvscn6wEt3/9Bv0Uh25uOJ6tEltrZFmasDB1W3Zx4T9A9xTFXLdyZ8ixizc1g==@kvack.org
X-Gm-Message-State: AOJu0YzQh2avX4Env8Ir+VqtRk7atfSs0gtEEmdioQroi7SuL4T2sYGG
	b/Lwb7cDJtW9TXTwN0czGQKxENcj2GcMTvmgB/ZikwabjZieUjgQZahzGAn9GMmuWAgLyUs1Hkg
	bINNMCtS5vl7dpD7MNMgaIBnbOFyh5+Q=
X-Received: by 2002:a05:620a:2246:10b0:92b:6805:eae7 with SMTP id
 af79cd13be357-932df746152mr466203185a.68.1785103730242; Sun, 26 Jul 2026
 15:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260726122123.7614-1-baohua@kernel.org> <20260726122123.7614-3-baohua@kernel.org>
In-Reply-To: <20260726122123.7614-3-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Jul 2026 06:08:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLmU8aOxX9HSCVOAQ+tK+9JvfZNJeajmbDFhf4LZr_5A@mail.gmail.com>
X-Gm-Features: AUfX_mxDCJyZR8GbeTm4pYrRguoXmKe1k13psXZv8Mbr6oKeNROGnzmMNMVYEo0
Message-ID: <CAGsJ_4zLmU8aOxX9HSCVOAQ+tK+9JvfZNJeajmbDFhf4LZr_5A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] mm: mglru: only fall back when reclaim is
 running at high priority
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, 
	stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 494BF140009
X-Rspamd-Server: rspam01
X-Stat-Signature: 3gdsbegngri48ir8gi33qh5wt9zyqit1
X-HE-Tag: 1785103732-13774
X-HE-Meta: U2FsdGVkX1+FHoX1VCHZiHfI7diaYBoL37u3Vm+1dFd1x0g5j5fg1H8rnQnKiAIfltzIJd6S3quyR9f2504lNtJZaQnjw0RXOE6W+HPemoFYoewl8ROamgkyogUD665CvxVqR8sftTbbJCibSgsH2/EMn/dYPkSrmOeLpwQiJ2iGdhyNlGxUScxL2ITvUBTTTb23LDNUfcgqmdGnc2f/b+sPg29Gghd39m67eKI5yu2RS84yDqdNXZmUs5ZGCLMdP5KE/AfwVod6MCIiuw8oOefVkfCn28qyXtpnq1akjJeuuV5+Scvcd5xa9g2aFHUCkqAIaodne1bHVVmlD29aFOcX7qioSHZc9+gF0s/rlwCzhZYTbplO8NTSXtwttkcMEScOG8OEA1bl9kA9RvLNsSXrQLTKYhHQuoBLwHeYMtOgEpYju5GiJN9PFSLcnCkPmWof7sDnMiglQs6U3lHZSeWtDPaZt8ghgekfDlviw8XfSOJpkowfXaPyP69nSQ2gFdgDuNwHUasqVQaq5Dd4RcEMwhF+/AZpSk04mbMRv4K03rpV+MERQRsNM8rDEM42x7iZoxUS4UEWR+h6P71hjFCD4lMbLSoqaFco0xPIlRXT1Pa7WeIRwNoKNbn3SMDW6moYUWJlv3zm6vdhfguBv9es+wo2elqgVTcGRFds0VyoEuCtOK5zr6b9Ey2qkyJ3hZ3TF1AOoWiZMIS81HyZ27StGWnZFC9tAjWfHY/PEGipNad8HX7VwK7tvsjbJmxeiKAXpUM0fw8WZ9C6Ke8qepEP0zHjriehseIHU/oyalzJrUr2SwYDkSiak109HM66fzt9tXTbskDC+HjQ6+/tpacELDu1tn/aUcQEVTAWmbmzUCG7Azk4fB37+F2Xzyd3NIwlFeK5PU7w9LeuDEjX9PfmHf6behnuW8jO9tbrpdHz3JoiYwIkX8M9jzL8PKCMe3WT9Ou2YQPsOag/YXO
 a3ZHFkLS
 UBM3XLd+qbusdsANXESUJ60EEvntN+BR7j90t33KMLpoIDX35KvKj0kF/WHm+7tNxgWmTQoNTFySfMiNDQgtFbDCu3YXINkG+SoxaVKyDcbLOhdOyO23lBITiLRkXW/S/puQhk2W9GljsSld34/hXCMRwFJVINZMONFM0WSqBOrDb2WMy8L6hLc9xAdcprCgdp0g5/rDSjjb7qC6Fmob6JTK7o4R61nLf951XvOlOqjVYODUXw0w9aiVtXZFAavjcipmUBRWGyz2o7b47++bZHu5thgBhTYPUAzaxhHm7vNQ48KWC3jG/l28mpSYBUD+HT8GZswsDcY+In/7YsT3NY1jDRJ0xnv+y817ybcZ3TQ3r28ORtXWSMHCztQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 8:21=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Respect the type selected by positive_ctrl_err(), where swappiness
> controls the relative weights of SP and PV. Falling back too readily
> undermines that bias. Only fall back after making a sufficient effort
> to reclaim from the preferred type.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index babbce4bbfe8..4a387cc4145a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4857,10 +4857,14 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
>                  * type is still reclaimable; otherwise, it would have
>                  * already run out of reclaimable generations. Falling
>                  * back too readily can disrupt the positive_ctrl_err()
> -                * bias.
> +                * bias. Also, only fall back when reclaim is running at
> +                * a high priority.
>                  */
> -               if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)
> +               if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
> +                       if (sc->priority > 2)
> +                               break;
>                         type =3D !type;
> +               }

https://sashiko.dev/#/patchset/20260726122123.7614-1-baohua%40kernel.org

"> diff --git a/mm/vmscan.c b/mm/vmscan.c
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4867,10 +4867,14 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
[ ... ]
> - if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)
> + if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
> + if (sc->priority > 2)
> + break;
Does this logic artificially drop the scan priority and cause false memory
pressure events when the preferred LRU type is empty?
By breaking the isolation loop instead of falling back to the populated
LRU list, the direct reclaim path might falsely conclude that no pages can
be isolated at the current priority. This forces the VM to artificially dro=
p
the scanning priority from the default priority down to 2.
This rapid priority drop could have two severe consequences. First, it
aggressively invokes shrink_slab() at artificially high priorities, causing
unnecessary eviction of active slab objects (like dentries and inodes)
which results in extreme latency spikes.
Second, when sc->priority drops to 3, vmpressure_prio() triggers a critical
memory pressure event. Userspace daemons (like lmkd or oomd) might respond
by killing background apps, falsely assuming the system is completely out
of memory, even though the non-preferred LRU list could be full of clean,
evictable pages.
> type =3D !type;
> + }
> }
>
> return total_scanned;"

I can change the priority to "DEF_PRIORITY - 2":

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d63322cdb1bc..12eba6216fde 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4851,7 +4851,7 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                 * a high priority.
                 */
                if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH) {
-                       if (sc->priority > 2)
+                       if (sc->priority > DEF_PRIORITY - 2)
                                break;
                        type =3D !type;
                }

And the result is still fine:

                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10567455      763612        2191652
36              990706      480205         414483
71              688170      415848         386966
106             446294      386164         354976
141             286307      359196         348493
176             201733      351686         297113
200                  0      330093           2544


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4410548     2726362        3511241
36             2465268     2762859        3027445
71             2677908     2885124        3359352
106            2737227     2841796        3224762
141            2984276     3035015        3221214
176            3381338     2938302        3446206
200           13116359     3113499       14700981


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             17997223      923094        3178493
36             1325674      539571         517029
71              852345      464222         460869
106             538207      464477         411314
141             357253      412277         402429
176             217536      399446         333375
200                  0      375902           3083


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             31639423     5987136        6184980
36            23441521     5753224        5727338
71            26067110     6101780        5932826
106           25619448     5782919        6105922
141           26842088     6234264        6147981
176           29200021     5980292        6707570
200           62193924     6413125       23288983



If I drop this patch entirely, swappiness still functions:


                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10567455      763612        2118900
36              990706      480205         426026
71              688170      415848         396647
106             446294      386164         376780
141             286307      359196         334243
176             201733      351686         287544
200                  0      330093            309


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4410548     2726362        3579570
36             2465268     2762859        3300899
71             2677908     2885124        3183903
106            2737227     2841796        3419872
141            2984276     3035015        3121920
176            3381338     2938302        3198154
200           13116359     3113499       14348490


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             17997223      923094        2898754
36             1325674      539571         509825
71              852345      464222         470746
106             538207      464477         434145
141             357253      412277         378242
176             217536      399446         322824
200                  0      375902            694


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             31639423     5987136        6594803
36            23441521     5753224        5979158
71            26067110     6101780        6200677
106           25619448     5782919        6480037
141           26842088     6234264        6106924
176           29200021     5980292        6553534
200           62193924     6413125       22763932

So I guess the other aging patches have a larger impact on
improving swappiness behavior than this one.

Best Regards
Barry

