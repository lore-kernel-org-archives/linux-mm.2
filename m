Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E8EC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 23:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D885E6B0088; Mon, 27 Jul 2026 19:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38B86B008A; Mon, 27 Jul 2026 19:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27C96B0093; Mon, 27 Jul 2026 19:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE806B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:18:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CEE040233
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:18:19 +0000 (UTC)
X-FDA: 85036122318.18.829871B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B06F100008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:18:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESsPbMzB;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785194297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLbnTx+vIhvKbP+T/O+t3USLP1ytabDaw0IfA49fM5Y=;
	b=vFekWrwiYuwYeXDOYL2xg8Nj4oRuLVahGW9t5ZDxhIy2aKXXg4Yf8fVyF8GUjagh+DOazw
	TbmGiJG+bQA3ydPUdPY6pDJaPjpKMP/ZZjbBvKz0cn+9qIMLabgSe/SZxs9MmiMx4L4s0r
	VSfbJpG71hpZAJIxziXRxOOTCvA24LU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESsPbMzB;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785194297;
	b=kmO8gGLDT9tM0so0ViRSl3ZC8MDk4CrO9lVXEZKr/D58S2+S47aVPqhWcPD7Tj635FQGaV
	NVe0Fhzjkdy3RO6VUYCwfZQZEEMlpPFu+CFEuFzNaMcDjwm2dn4hcg+F3aoxoMrn23FChC
	teA0duoC3nojbAwIOlSggg8JUhUwjv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3214443F52
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF91F000E9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785194296;
	bh=gLbnTx+vIhvKbP+T/O+t3USLP1ytabDaw0IfA49fM5Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ESsPbMzBupbAYSCbcptttJV52Yw4Tf4/uMQcevLwBsRdYsBk1gj3VRqtTBbhgMqm8
	 MlVoray1NI+VfaNa7G8dlK38HxnuwiiQSL1y6H1GxdvIUnmJ6/JPNqB5jyTHpidqkS
	 A5tMo4TwnwiAa1z/vs4w/n9sS6FHCy2kbrNp2gbuqb1uTRJ5YhhZPMJK6v+DNPukSM
	 PnrSJhmV8GmLpPszr/heSraSeuBgndC57JBj+Z/9+mSY6EcI4LNMcvJmMqO6zowcyl
	 7rwAWvi4YXScj/4hdrD0lv5FlMtIzDgPvYpfHEsemxXWRThXFJ22LrgCvBInFKErC7
	 oDXnTmWrGmTFw==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c04bf4711so31960581cf.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoiNXKZeGuCCejfGC1ubvJzH/1cctXx2xntJ2XnT3PBWNBml7+s8VffFGIl62RTbGrHtpQ5mDm8Fw==@kvack.org
X-Gm-Message-State: AOJu0Yyomf+pk5KPy06ROeo9wac4LanpzuqoT2+RHvsfReTiPcyfSCxY
	JFdtkk5RYF7lk6FKTczmMyQNNINjOzO8uY4hbu8DKwZxgjh6JN7wJfra3SQqH1/5EQhqDRi4/7w
	KdXYwgUjMUYB3g8mGZKLi0GS83chbusA=
X-Received: by 2002:a05:622a:250e:b0:51b:ee11:e71e with SMTP id
 d75a77b69052e-529d16f266dmr17364751cf.1.1785194295508; Mon, 27 Jul 2026
 16:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260726122123.7614-1-baohua@kernel.org> <20260726122123.7614-2-baohua@kernel.org>
In-Reply-To: <20260726122123.7614-2-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Jul 2026 07:18:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w=gpjgwkndm3PAmZXxRm+E8ASG=6XFpprWwr3AxnpvSg@mail.gmail.com>
X-Gm-Features: AUfX_mxz0ltOjwcKQZsRorMlJjtuPqD3BCfvxMyavQmPfGD98smSy9H0diiNhjQ
Message-ID: <CAGsJ_4w=gpjgwkndm3PAmZXxRm+E8ASG=6XFpprWwr3AxnpvSg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/5] mm: mglru: avoid scanning empty generations in scan_folios()
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, 
	stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B06F100008
X-Rspamd-Server: rspam01
X-Stat-Signature: 7g14nw5gcnnothynqhwt5sst6kmbm8ca
X-HE-Tag: 1785194296-216319
X-HE-Meta: U2FsdGVkX1+TfzjZzzjmxDVFHLfO4HzrQAMl2nrZGyLKIb0B3sqTr8idQ8lBtYc9v1kRQszSD/onxiF8GC+trB7eIX/IpWPjFMnFJeO6OgbagNQn+uoXOt6RqUN4CqLGh6ED2ui1MRIsw1V+EzbDZx2Imld4KAApQOlEK0AQ/vzjKKQJxU4oLL0wker0BnN27JveyRDfLCBVU6pKiInpPj8AmW0rEqEu2MU/OOV5PAdxF7O6hhUCcUlZoimLrSEI4j6dd5Uw0mwmKTMt1XwG3UEjXp8LhEqbH33mI8u4MKq6DqTtZV7yxFPJ5Zgo+7ifa654C/YusESMbTdkiKRTVuzq+uhIc6HEkhqCcRIMjr/29v0SvihTXJmyQ9L1sPF2Y86bBVbuZnSLlRKFuHx5XTqNdKi/NwbTU4fdS0yBKBsdqrKtzQdVG9K5trw0YhE23fH2MnVvbwyDU/m0TQW+R5y5hWzv1WV5B42CBBTACS8e5Yh/3NI3vf4L7ozi6iGzXeIlK4eXGYDrXLdRJoI1GnWTI8v2o8Z6ZPkCT5XI8uLLOwIHdJHh3RNQVlj3W4Yt2adf7UGo3jiULGidAUnL28wHribTLxDFhW0Y6VJInIbK9XQ81DwyUM8mcAFjAgB/JrfEguV3yKWU836YgXgUGyZJx2pMAPrqbpvyF7GMFeaytEoi4xHh2S6MbshiCju58ghMvE7l6OjEbnfD0TX3DFb+ugkeR6sTYGmnyEnKHbioKcXV7Ty/eaGcLcXhrgdiQnDvleSNsU9XJL+t7NYXr9Y7qSg8jRHhrM8WjS/1hTpTVFP2UBboRuxm/mg/aw0jDwXvlFfoMKPtN7rdRjOU0hkQRxnXjsNaAVk7C6ZF2gEvQo/s/9whJ/JRudt5TW3ijPfZBk7S7yulmgQ3Ch+ZqtCJD0sicjXY2ncv/hA3jvsPr4Bhym9QZViC3kiu8PQdEdn+ypLEbNvboz7gCuj
 oqooL5GX
 j+LOyz2a1dEv3a4UZRrq5rSu5RfDYLaF+RwFZRou8g378LaaWYsOQf+bKzgQooABgBJNThBoGgR1GzIPZnxjItkC2jM+vbfM1HwGNak++BVi1fu2DtBbRzDpeZnSQ9QLj2SDgR0/hXaYOMULE+vSQUeJ4ZX56q/RcvwfREtIOr0J6ght52DbMeM0UyR1OzAQpUEp+lwDszZTiP5s9esrLmAnj3Md4EIYaTLO5YfOSLo7Urb8jmBFJFS85shMxvrFG9TblY872ulIA+4FVQuLRLxPGG/vP9SwVfIhbZymp1IZwQRWYyv7WOFdalVbPdRN8iYTZtByBI/D+AZqCD7JMOuZGwUqRxSWoo4vdu+2R6+wA5fnh6A4J9NAGH9iPWeu4jxeshXvHvRRiMwX9QJB77mVp8tek/jP7olBg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 8:21=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
> isolation makes no progress") only falls back to the other type when
> scanned =3D=3D 0. However, I have frequently observed cases where
> scanned > 0, but the older reclaimable generation becomes empty
> after the first scan_folios(). As a result, the second
> scan_folios() for the same type performs a redundant scan over an
> empty generation.
>
> We can avoid this by checking whether the reclaimable generation has
> become empty when scanned < nr_to_scan and we still have fewer than
> MIN_LRU_BATCH isolated folios after scan_folios().
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 566c4e837c7d..babbce4bbfe8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4852,11 +4852,14 @@ static int isolate_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
>                         break;
>                 }
>                 /*
> -                * If scanned > 0 and isolated =3D=3D 0, avoid falling ba=
ck to the
> -                * other type, as this type remains sufficient. Falling b=
ack
> -                * too readily can disrupt the positive_ctrl_err() bias.
> +                * If scanned >=3D nr_to_scan or isolated >=3D MIN_LRU_BA=
TCH,
> +                * avoid falling back to the other type. The preferred
> +                * type is still reclaimable; otherwise, it would have
> +                * already run out of reclaimable generations. Falling
> +                * back too readily can disrupt the positive_ctrl_err()
> +                * bias.
>                  */
> -               if (!scanned)
> +               if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)

https://sashiko.dev/#/patchset/20260726122123.7614-1-baohua%40kernel.org

"
> - if (!scanned)
> + if (scanned < nr_to_scan && *isolated < MIN_LRU_BATCH)
> type =3D !type;
> }
Does the check for *isolated < MIN_LRU_BATCH have any effect here?
Looking earlier in isolate_folios(), there is an if (*isolated) check that
breaks out of the loop:
if (*isolated)
break;
Since execution only reaches this point if *isolated is exactly 0, isn't
*isolated < MIN_LRU_BATCH unconditionally true?
Additionally, will this logic work correctly when large folios are involved=
?
If scan_folios() encounters an un-isolatable large folio (for example, an
order-9 THP with 512 pages), the scanned variable is incremented by the bas=
e
page count (512).
Since nr_to_scan is capped at MIN_LRU_BATCH (64) by the caller evict_folios=
(),
scanned < nr_to_scan (512 < 64) will evaluate to false even if the generati=
on
is completely empty.
Does this prevent the fallback and inadvertently defeat the optimization on
systems utilizing large folios?
"

Right. What I actually need is a way to tell when scan_folios()
returns after the current generation's LRU lists are empty, but I
haven't found a good approach. Checking scanned < nr_to_scan works
well for small folios, but not for large folios.

Maybe we could add an argument to scan_folios(), like this:

@@ -4707,7 +4711,8 @@ static bool isolate_folio(struct lruvec *lruvec,
struct folio *folio, struct sca

 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
                       struct scan_control *sc, int type, int tier,
-                      struct list_head *list, int *isolatedp)
+                      struct list_head *list, int *isolatedp,
+                      bool *exhausted)
 {
        int i;
        int gen;
@@ -4776,6 +4781,11 @@ static int scan_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                                scanned, skipped, isolated,
                                type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANO=
N);

+       /*
+        * This scan exhausted the current generation before reaching the
+        * scan target or accumulating enough isolated folios.
+        */
+       *exhausted =3D remaining > 0 && isolated < MIN_LRU_BATCH;
        *isolatedp =3D isolated;
        return scanned;
 }

Then another question comes up: suppose we have four generations, and
scan_folios() exhausts the oldest one while the second-oldest still
contains reclaimable folios. The current implementation doesn't move
on to scan the second-oldest generation. Instead, it returns,
leaving that generation with no chance to be scanned at the current
sc->priority. That doesn't seem right. Let me investigate this as
well.

Thanks
Barry

