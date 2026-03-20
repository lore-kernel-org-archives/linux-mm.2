Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243831099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 21:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891966B012F; Fri, 20 Mar 2026 17:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869AC6B0130; Fri, 20 Mar 2026 17:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780126B0131; Fri, 20 Mar 2026 17:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64FF16B012F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:01:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1676258775
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:01:00 +0000 (UTC)
X-FDA: 84567661080.26.C087B25
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1194D1C0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:00:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eq4TJ61+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Td22Nguf6oElD8TYee87KyVv8CC+6yr9W1jc6lZErI=;
	b=lHCmNLHd+RbXKci28J3vaJa6PSmJ3y/QYA0rHv21hiyVXhNDyrSMVEjwOBFPkehYcdCdCT
	NbFXzcdqPsrSDTcWbUhIcEf6Vxva53tznbecd+F64y48aVPMyypx+xxwPdA8+Pn7Obo1Q2
	TqIaFC0aJAGwKfeTZOhcGTDOIezaCEs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774040458; a=rsa-sha256;
	cv=pass;
	b=1tLi9eSMTDkvpWidgD0xk0BiN+gNwANn54bEtthNdX6PmuJy70nM35s3P/GTAtknjUdW0R
	G/jAO6vD5qgJiLXTeovi+mCGdmskqOWBCk64gehiA5PsSY6Cm8/MwZvCd4mGMMI3PO/JeW
	YU2zPn7YyORSb8J1nytu5TerVmMC790=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eq4TJ61+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-126ea4e9697so1066c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:00:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774040457; cv=none;
        d=google.com; s=arc-20240605;
        b=dbEwt3pqm0hmvQXttfXqRF4hltO9hO0pvC5zFgz32SZpO0XXrvIko63u9M5AsBh9eK
         Uqe9tj5e7tOxz+AC7xKEAYRvcD2ikxjvchNnBl83aBsjG19cMDsNBtZqrwcCI1LuvKPt
         Wggz/5g9KLuE2WqVoZHhi9KMRTFoJ0IDj8W34tRi4y8UTunzkBYoJQJuql/Um4vYQ5I2
         82ShYeqydMp0ciTz7hMxFaP7vumzFLCMsvHNzYnbOqZ521iGCEyYxbazuavIppTwU2WN
         43i0Mq2WOidEK0czbEFLVJbbRYv0Veeou3F+Jf3qHUnDpOper3LEMPJJOABXvbK76zb2
         dSPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Td22Nguf6oElD8TYee87KyVv8CC+6yr9W1jc6lZErI=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=hUOq100zvbGhgCU6ljUzWDzLv3MBBg2lP7OTyVjninMBT59j3LjGnTrSUX/rd7q+ty
         223/+f1PxwPYj0/ms+I4ih+WE8/82nd4irMDxSSv5sZ7QV7Yquty2eO43p3GXeCaMsOF
         VQ+exlpqWbRmrIgpj5SjRG3PvSYFMKJjOGt978Q/ZaEG7JvwqnFnJA5+6YuOFl7WwRYe
         cWAv4RPxPKATXWbVJJdk9/OKK67QvBh/ll2+9dc3BoBHowyEjJCZSEwgbzvtT6Gmu1ye
         RWE9+44U5FeDTzLgHslImQL5qwN6oZvFRH1k+N4ySWkk1eQKzOSvKefsBkp3pJaeYTkX
         bukA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774040457; x=1774645257; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Td22Nguf6oElD8TYee87KyVv8CC+6yr9W1jc6lZErI=;
        b=eq4TJ61+iSQ5fJ05dnOoI+0AwAtFofTH1HUa7Smq8WW5e64VXQ4iRHObqN5r3jgwtH
         5TVx+EejU6AuNR0Re9NSsoxunJR4kDdpbsbHLTSFNu4HHqHqqitpwmFd4IiFhJ9TSweU
         umH61ZBGaH7ERNC28A91S/DDVae80TVVQETnG6Kwlq/iWEY+J9X2LZxyCQBNvxYEmpBP
         F8tYzhR4hj+nBisKqjpfDiiMG2R9iWkeI6FQQDo/5+wNkz2RXp8xfgMIQFGwZNbcTlfv
         hBylUzSJ+ocR66niDHF++Tne8ziNHNlxhtEpmKrfEB1ha4Y2PKseyMipthVosJRNrQRK
         MA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774040457; x=1774645257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Td22Nguf6oElD8TYee87KyVv8CC+6yr9W1jc6lZErI=;
        b=VNqROIlaqRFkUkH8J1bIh8YwOS+JQDrS4+EFajmjjPxccFO+JWbWN8dTiNdBvh9HGF
         5ZcAc1E0JYtc8O6UDJs7ImqiLwvVaT0p0ASk1dn72T3d6sXLp2T+lbD6wP+rwDV7DNfs
         aTtfira+LzFoELM/UToXO9iWUaLBuAYlivob2bq798GpUJQW0zHhW/oVg6/OTdXikJp1
         4NniZaFH5NAkb+lOktTBe6z1BlT9l9WtJ7Ot/YSmq8sJW/+x4xc3PdU0KyJA39pW0hwr
         IMazMiaqfs+Dm+5V5h6BsFt0jYtcRPynf1H344U6hyHsXnoEyMYZ5N7FmD7LQCk/VXZ2
         Auvg==
X-Gm-Message-State: AOJu0YytNxueAo5CWejFYDgXdFHczsoDc8iAv11kR1d858u9ysjWopQ1
	BKuXqNnhoBUjPqYNVbcbyDmxv+3p/i3bdyKDJVwdFB6CjbRcff+AHmgsAJYv/i2J1ZykX7BfEOY
	bWYhSoXjPfDK4FKPDSU6lFufsm5Dj+DDsORZjFXYj
X-Gm-Gg: ATEYQzzlOKOX0ycqeK7dEfTfB/wMVY5bxFX5STxH7u8qI3URaUDwefi/dp3v2WRYn/1
	2bgzWoMB/1hW4l0+KbMcpHOfW1kV0EanGGMsmz/QgSKoGesjT1nIxL0CUezQBYvRLDnhk8P5uzQ
	QXzVeUZDESAV4UWguvwwj9YKlBbtu4M/QIhWdqXafrWVbMTRZbPnSwqWBcuqIVgdaUIabgwg3X6
	5cBSPlBjLHEN425cHSDha2ZMZvKiBzMp4h6Ra38UG77cSQEz8o2167ie1qXiT2u3N9Jz+ek6K3g
	zNlEcZBr5Cv2PIJxam8=
X-Received: by 2002:a05:7022:698c:b0:119:e55a:8087 with SMTP id
 a92af1059eb24-12a7afb263emr27528c88.4.1774040456088; Fri, 20 Mar 2026
 14:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 14:00:19 -0700
X-Gm-Features: AaiRm52nutGgdtZL7QL0vPEUp6MWism5f6hM2BLECCn5iZ8-fSHAN8IYaAlYcWY
Message-ID: <CAJHvVch+S6MDoBp0SRhPC-v5nVpizF2Y9NEYn6B9bCVqR9Mv-w@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to callers
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8zib53yri6nb7fahfww9w9nzwuqu64qb
X-Rspamd-Queue-Id: 1194D1C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774040457-810330
X-HE-Meta: U2FsdGVkX190zx5JE+ISsu1TBcenHiloGK5/9czuqO31sIEISPAYUfrx9MThaFR4JFtSv/PayjiK7xrZLmklHjiSXw1xphaZEWxAY4r/9r1KtYLRIzAc/HSj0jCdSzaZighFVOiwhF5GnwxdUaQRwIY/UxfDQoFH+uWBOZv/CAFUC1njS18CaDTnJOpKZRixjEdCxN68ZsHSGZx4OYA65GACkXkSQdpDv+JLSxx+PisoxH5hfpaI4LhHVYwgLyDSvEqe2tNV1AROqrtWpet5ukV4wObOxv+Mt9pkzazWoTS6wGVtzZIYxK4kM8jD8+GrxCf6Web/YEbUMQLAB3tLUqbzVV02JuDmdgkEvtgJA13vEXJxXrevMvfVVVjEWRntcLSohL/dTAWSm1XCfRVaWku4CADYNmtJwN7l0RY2QstZygHqarMB8ty914DGSYz3VuqZ2jOxHx5QyJPs6cYycVRIS4Ngr71o+m4kQjyf8wHY0kioh3QmmuzqNiTr0M5QER9fgTbAWwihCI/ta65CAccGO/QkRctTNScTuh+fTULVAvlFi7kTFmv/j5w/LdeNZ/ZyuWsXJ2eLOeFHHhoXdCfSPvf0iTxTOMAIISYL7d7fQ1ypPH0JgyFNHoaK2ZtzqFBSPTq9+qwvsOkNea8uBJ6COmocIxlFmP/T3ehmGuH+4sNirrSK9SamtUR4cjKkEYI2NxOQgXU9l1hNLT6f+apRSplBU3KSLKCp5ikttOt4wx2wPetwL0gQO1jXcBcPYMUNpd7VAlHDbVsS4EtLQ2mCddhbwaExjg+b1xleuKKFTNY3EUJI2c6Kfi7kOiNttdIyILfrX8/qJMrfQcrMo5NuqqNYzcf00CXcyF6OOTe6RhVHUQ09EZEAmTkQVtKj57tFHYe10GxlfJszFN1C8p6qCNGxetzUomx/u6mY064GcLaxHl9JpYbFoCPTiAAFGeegmTDvaI72e3rfe5i
 8OGmS14b
 T6peRbrR3FHH1mLYmeTH24p5xLH2bt4ymjaGdB4MdzDWA00YLEV07961qU9AFKmTDbfTmjrl/3vGcrkW0jzRmIcbBLe032Va8J6TL1zZUZGmaryZHo2AXAE6JpMx5B8xYVy5+kkARdWjQjXEwnz9yw9gRZk8DAX7yTDW9wGoDTdV0nJDfJxDGEohPGLcGdCR37ZRVKyFRBx+IgaeizTdikPRLnJZz/aqVRXcH1X9V1jOxqvlv2LJsFPrH2UM5XVxXx3n5Kj3NK+wpEXcnOt12SvldNwFQ3lreKWg0FKsGHOEWXi6k5LEQh/RkSHFpQmSvwcAToKxW8hKgLuuKyZccwm/Q8kSLiC6I63tDWr93O53ix2LJDpMV4xK1WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Same as active / inactive LRU, MGLRU isolates and scans folios in
> batches.  The batch split is done hidden deep in the helper, which
> makes the code harder to follow.  The helper's arguments are also
> confusing since callers usually request more folios than the batch
> size, so the helper almost never processes the full requested amount.
>
> Move the batch splitting into the top loop to make it cleaner, there
> should be no behavior change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

To Chen's concern, I see patch 5 makes use of this refactor for example.

I don't have a super strong opinion on keeping this separate here vs.
squashing into patch 5. I slightly prefer keeping this
no-functional-change part separate, then patch 5 becomes very easy to
review.

> ---
>  mm/vmscan.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7fc7f1fe06d..d48074f9bd87 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4689,10 +4689,10 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         int scanned =3D 0;
>         int isolated =3D 0;
>         int skipped =3D 0;
> -       int scan_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> -       int remaining =3D scan_batch;
> +       unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
> +       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> @@ -4745,7 +4745,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         mod_lruvec_state(lruvec, item, isolated);
>         mod_lruvec_state(lruvec, PGREFILL, sorted);
>         mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batc=
h,
> +       trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_sca=
n,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>         if (type =3D=3D LRU_GEN_FILE)
> @@ -4827,7 +4827,8 @@ static int isolate_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>
>                 *type_scanned =3D type;
>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tie=
r, list);
> +               scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> +                                     type, tier, list);
>                 if (scanned)
>                         return scanned;
>
> @@ -4999,7 +5000,7 @@ static bool should_abort_scan(struct lruvec *lruvec=
, struct scan_control *sc)
>
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> -       long nr_to_scan;
> +       long nr_batch, nr_to_scan;
>         unsigned long scanned =3D 0;
>         int swappiness =3D get_swappiness(lruvec, sc);
>
> @@ -5010,7 +5011,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lru=
vec, struct scan_control *sc)
>                 if (nr_to_scan <=3D 0)
>                         break;
>
> -               delta =3D evict_folios(nr_to_scan, lruvec, sc, swappiness=
);
> +               nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> +               delta =3D evict_folios(nr_batch, lruvec, sc, swappiness);
>                 if (!delta)
>                         break;
>
> @@ -5615,6 +5617,7 @@ static int run_aging(struct lruvec *lruvec, unsigne=
d long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct=
 scan_control *sc,
>                         int swappiness, unsigned long nr_to_reclaim)
>  {
> +       int nr_batch;
>         DEFINE_MAX_SEQ(lruvec);
>
>         if (seq + MIN_NR_GENS > max_seq)
> @@ -5631,8 +5634,8 @@ static int run_eviction(struct lruvec *lruvec, unsi=
gned long seq, struct scan_co
>                 if (sc->nr_reclaimed >=3D nr_to_reclaim)
>                         return 0;
>
> -               if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruve=
c, sc,
> -                                 swappiness))
> +               nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_LR=
U_BATCH);
> +               if (!evict_folios(nr_batch, lruvec, sc, swappiness))
>                         return 0;
>
>                 cond_resched();
>
> --
> 2.53.0
>
>

