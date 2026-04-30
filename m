Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8C7CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964876B008A; Thu, 30 Apr 2026 11:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BD46B008C; Thu, 30 Apr 2026 11:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851A76B0092; Thu, 30 Apr 2026 11:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73CAE6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:27:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8E5A1C436E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:36:28 +0000 (UTC)
X-FDA: 84715472856.28.02A475F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0CE910000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:36:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=arxTyA+c;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777559786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQlknuZipNDuFZ62P+n6GU9aKe3q53J25WUk7F49X2s=;
	b=xn7zfouStfetqkaTBUfFTV4WUdXciBnLG59GCWEyxtnXveJ9EjmYgiY8eW9grPmrzMavXQ
	SmMPqfAc5YLzPk562YhsgJeB/M76DPm5WmIf06j87wLe7/2rH0Qsu9mHGZ97dxz+dgOk5O
	JM1Db012MX5CKZxxrmAmHnzd32abfy8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777559786; a=rsa-sha256;
	cv=pass;
	b=X1ILd+ENDF7uJzFvKGqZay4HqMw6AOTZfhWokWqOY9LO5UHvZl83M28nw3heYMcZCGguIS
	42+J+0tKB7RXysLLglkgcHwDlj9F3tg92Q0I/x+wc2pc6OYlailOLKi/7ubFAG7x6aGIe8
	pjrSf7cBU/wRhc7CMiSbYYvRrAUCLQA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=arxTyA+c;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-671dad7cac8so1277584a12.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777559785; cv=none;
        d=google.com; s=arc-20240605;
        b=Wfa58t81s05HOQbYp+SJEEuid1Eqe10dUkm6C5SY2pc28bFbVpIuUyeR8Fj8a4jyPL
         B+TgufLCdHW6lJAo07E0/Sh83PbLryDsSYyYpIAvMRS5lBadwxlnYbWu49qAoQa+HLhW
         OBPLkHtFoWzDW4xFxdTcXjzys8Ii7pD7k2Ih9B1goQEmiL2F8WVnQVZVIJkCkLcsbaP1
         8OmHCmeIbdYhw87PxlEN8otubXpG6JB/VSWyBc5l0lSP9Rr9ZOQboGsT39dLpVMhAXwY
         MP3oFYhGyzrQN0mOSY28Bv7wXc1Mbnze12FHHNGenSN0gwxUvvmOQ7KOMwotXjNS2A5l
         BmPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uQlknuZipNDuFZ62P+n6GU9aKe3q53J25WUk7F49X2s=;
        fh=S0nCfgDpMmhJltiJ1UbtBu777/KN9sp6HIkDgJhaiB8=;
        b=aVFns7JdvFjRwVkckThku9iaUQz7/C96Y4pSK2g5lLaV3qzKuQUwE5Ro0A11Szv1aj
         G1N3gBar4i8vCZ8n9M4NJt8q1MvdRvpN2ocHw6ESgr9+1L5kaXKsyjxcCwtsno90Xjxd
         Uqve5RUka038CcND2Oha0uSN/Db6mxujaVl8e7Zr/kFONm+b5ppwYrvYr7t80cSl7knf
         UR6+lsOtxkD5oGBeeYBLjrsDkBISxkPeD2dy6NvRrYQGq1m9yYYKCaiIJPA9yTSNJf7z
         VHI2OgNh03OZqjfXQRZ1Mx/JIg2YOSY2lASlKBbphaUrXs/NBn6T8PfUWIGLTo4dqYyf
         PVgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777559785; x=1778164585; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQlknuZipNDuFZ62P+n6GU9aKe3q53J25WUk7F49X2s=;
        b=arxTyA+cxXWqoA9802baJSy5blLGN0W8D4fe5apTFB4P2pYszcGriqKZpnNGYeGgQN
         UBwmpjVtqgTfR2z9frEtTYviPGR3shoHmI5k5U7/87Mjs9QyI+6Xv3ITuhTm3MFk6u+i
         Yr+XT8gGpJAjNDlKXm7oNH/zvpzUeEtjHpFbRvuFXmeUrMbRaEXe3A/dWxLCIOvRRCML
         NvllPNhl12Ef55QXlyBSOk0I4HCzJ+Yg1NwIc3XcW8A4nYTs33y2MSnc2E5xYO6jGiif
         7TOK6mn27fAixkd+7aKWjUVZrgySGlZalhT1rxzCgHRyoH1Z7ZZ7hE/9QTfIkoosXG1f
         k4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777559785; x=1778164585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uQlknuZipNDuFZ62P+n6GU9aKe3q53J25WUk7F49X2s=;
        b=SEvB9yeiljrOpYWIGWn1zj0zWSeChnmSQm7eCv9iK9/ZPJ9nicDwIcuQY/+vJfXx7u
         e1DOabnLd6sL1HtGrS8DJuGJmmN+TJXHE1yxaGo+eD+3+Mj0CCsPvwe0QzAOFgSYiYrP
         C2C0ab5wGHuGp48n4knEyJDzPq1r5e9gJv7onPX2DYHMph1X5V/5y1VofZ+J5XwywZut
         T3soSu86lwtR+ay5Cw/SeGozIHEYY6Q/gMGT4w+fubmMluZwLvP3cCLli2bQWbNlCiua
         7jUXw04uKhluZvrIMDtARorAbrWUtLV9PolP6mfuYamfGIUgpAJDKuHCNV4GEZQOernU
         6P4g==
X-Forwarded-Encrypted: i=1; AFNElJ9avw2gqRdlJM4Kx69mz1BYQdZ9Zf0xW+mY+bkxz1STVGfMuNTUOhAZFaeCGcXzBFgFGbD66XlTUw==@kvack.org
X-Gm-Message-State: AOJu0YwyaWU9pZb14YGm52lL1tf8OdquCJndMc4CbWvzgDRtfC3xA9Pl
	ReK17ro0xB+CJyPNYCXq5pSyLDIN8Mbtrru4BvR2p82hKw1X4/3Xviwmvu5gbLBiqlfnZSEGxMV
	V8uW9tzhHtnIp7ayvtQrXFMr7DNa8Gv8=
X-Gm-Gg: AeBDieufsmxRvhWjcdG7FafEpJDNUey3vLRWoyoh1afo91U+gncn6ZT8w26DTwBuLqR
	+ZFBPzG1lonUpQM98/LpzHMcZ3O4FKoabsy+FLw5AYgBWBaz0RUOIZCIdWknLkByZvccWysEfwB
	pbTG7incM7mf8UMwIGWpoN4J7fYF9cmhQmOBYyMJUnMOByjUPnLqvBQ+XpyXfrN8QivSCY5ZA4R
	s3LFsSBNdYPJ2YsvmcnH2st0eEa9BAFYFHfoiChVq91Wv9Uni8muhfdrgQ2khQXPL9BgfsdNxEP
	Qvx3pVcm+KiFhRa4jcpYpLhQ7tnUv387TFvu4sc97uZzWPpr1Vs=
X-Received: by 2002:a05:6402:a0d7:b0:670:a401:c979 with SMTP id
 4fb4d7f45d1cf-67b5d97c572mr1504123a12.25.1777559784504; Thu, 30 Apr 2026
 07:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260429185441.486804-1-agarwal.vineet2006@gmail.com>
In-Reply-To: <20260429185441.486804-1-agarwal.vineet2006@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 30 Apr 2026 22:35:47 +0800
X-Gm-Features: AVHnY4LjpnkDca8amRLyWC1PflTtdsGscQiMbBef6eBFR3hB1_56Bbn8HqDRrfU
Message-ID: <CAMgjq7DFM6rq5bHzkSHWTn2fV3bp+u5u-z07bH1j7of-E1F49w@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: fix delayed flusher wakeup in MGLRU
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	linuszeng@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0CE910000A
X-Stat-Signature: rwqyiwaiojet8knjaqzbe93s7wucfpwb
X-Rspam-User: 
X-HE-Tag: 1777559786-742867
X-HE-Meta: U2FsdGVkX19BhOtVRvKuaoRzQrSxzXIf+jv0iXRk2CaP4VeLr/vAsburyPA4MNopCtWdkm3iB09QqEwF1+SA8yg7I17Zfy67yNG+aCy3F4WYLF8ek9nLDIx5z5mM+1sGvxqZ2T7oWIODPFV0VZcahnkojGSayPdY3/qX5Z+TfIk9n6X8Mg3xD0MykyHo+jYnul2GwVG+a5ZZo2tMeAsy+62k5GPFsIEFV6j7iAFXbCo8OwkXHz8hYAH1TQdcFjjiIlFsyiASkgAen+L49c6s7fWJtnrCVts53ijC9hZK6EGvHgdEmAosGBDB7POjjNQBKiYUDsnP+Y0GH+mrNKfYu64rK1h8lAsNT4qrqaNgEo7cfHqECyNLd3c8Wx8J41GSpbnaufGa5he9sxCip+I//Z/Xj82b2OqM6cnJij389we5ACRvSm5j8t7/V0FNQmFJOLGGoEtkOYbRbhxWc6BcIpKika92mTPC65Or52CTaTu1ZguiA0bnxQ711dkEX4KXJfoHgGQpkc9acr+9sht8qDVs7Ty01Q0KKxnvxk/WAt96juZx1lBsTg+ueIRF0CjGS3CWLu59ZkCKMoFBbhZ4fgxq8V/Qvzf7UlF4QCAJfgFf+aeIA5nVxokgh4RiJFfFK4NTyHLX8B717fRAmaLUy8vQQT5+r5xeT7UhGt71XBxpEij7DLvncUzUOPcV/f6U9zbCGBf/ECl6zBGR+8UVeaR95tOpiwZTm/YZDArQAZfmpRyDiC99sHveok7n3cr4DgSz7bmPLnnhhF0iUtSMuICDHJOwKNSwkpelUpa0HRugWQIDzjJ2bDBb+JXUGJr1PCzQHIu22wbxlMW18ZM/deif7t9rfRyEMWL7exMvexXOy2sl1VKwXdISUP+AwN+47GwJz1zIFKmLI41GX1mYEdN0xKCcvhZFNXT+vQPmtsShvOVzw/wXg7zJoM5parsRU2QTrKsvMT8cbdtT4yP
 LYCGvhTU
 6BB6SHIHttKaFPMHCsyk4q3lC65LiVN+ShOXnEkJ7NQizgxSTZtNzsktYEEVDUlCU1fVulYflBbMajzmCU085OWUq3G1ty7GE0m9xwZXAMrFTykBqXtqwfCyiiOmNG6P/KlUC0pPqr4Aqusvdp4YrwI997gAahgRbfWwygyPOrT3Ho+HBuSHTuN/fQFkknpwIKnBjx9XvXg2k54avnHNkGNdGx/YmI40pewGbOR981UbuM8yixG1QrtMyqENocr1Fl2w3xdw1D7kXzE2VC1TQyA2YP3cAO+MpWAzypQrfr4hAHxg2WhUVSbbloP4Q38z76aR5ev5W+pVheLSW15QDEm15yMyRgHywhwIyUK6w6oACmYU+mWKRlUu+bcr4No52jeHJlypmEpIVnKvsMLI/4jRnzoc516R8fKec6mWDYKhPyRNczhk0r4yf2P4+8m6y8YzqSnCpA6K/srJWNh0BlSf9ry0w4yB88CFX+vcNbFczCClAew65Wk+5Vf8nmz/99FZMCh7waF3HttdUpF2fGsFpYEJpLvB9R3/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 2:55=E2=80=AFAM Vineet Agarwal
<agarwal.vineet2006@gmail.com> wrote:
>
> MGLRU currently decides whether to wake flusher threads in
> try_to_shrink_lruvec() using cumulative reclaim counters:
>
> sc->nr.unqueued_dirty =3D=3D sc->nr.file_taken
>
> However, these counters are accumulated across multiple evict_folios()
> passes before the check is performed.
>
> This can delay or suppress flusher wakeup when an earlier reclaim batch
> isolates only dirty file folios, but a later batch isolates clean file
> folios before try_to_shrink_lruvec() performs the final comparison.
>
> For example:
>
> batch 1: file_taken =3D 100, unqueued_dirty =3D 100
> batch 2: file_taken +=3D 60, unqueued_dirty +=3D 0
>
> Final check becomes 100 !=3D 160 and flusher wakeup is skipped, even
> though reclaim was already blocked by dirty file folios in batch 1.
>
> Classic reclaim avoids this by using per-batch values:
>
> stat.nr_unqueued_dirty =3D=3D nr_taken
>
> and waking flushers immediately when the condition is met.
>
> Make MGLRU use the same per-batch flusher wakeup behavior as classic
> reclaim by moving the flusher wakeup into evict_folios(), using
> batch-local isolation results from scan_folios() instead of the
> cumulative counters checked later in try_to_shrink_lruvec().
>
> This avoids missed flusher wakeups and makes dirty folio reclaim
> behavior consistent with classic reclaim.
>
> Fixes: 1bc542c6a0d14 ("mm/vmscan: wake up flushers conditionally to avoid=
 cgroup OOM")
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  mm/vmscan.c | 46 ++++++++++++++++++++--------------------------
>  1 file changed, 20 insertions(+), 26 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..f9b6cc146a3d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4680,7 +4680,8 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
> -                      struct list_head *list)
> +                      struct list_head *list,
> +                      unsigned long *file_taken)
>  {
>         int i;
>         int gen;
> @@ -4749,7 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
>         if (type =3D=3D LRU_GEN_FILE)
> -               sc->nr.file_taken +=3D isolated;
> +               *file_taken +=3D isolated;
>         /*
>          * There might not be eligible folios due to reclaim_idx. Check t=
he
>          * remaining to prevent livelock if it's not making progress.
> @@ -4798,7 +4799,8 @@ static int get_type_to_scan(struct lruvec *lruvec, =
int swappiness)
>
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
>                           struct scan_control *sc, int swappiness,
> -                         int *type_scanned, struct list_head *list)
> +                         int *type_scanned, struct list_head *list,
> +                         unsigned long *file_taken)
>  {
>         int i;
>         int type =3D get_type_to_scan(lruvec, swappiness);
> @@ -4809,7 +4811,8 @@ static int isolate_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>
>                 *type_scanned =3D type;
>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tie=
r, list);
> +               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tie=
r,
> +                                     list, file_taken);
>                 if (scanned)
>                         return scanned;
>
> @@ -4825,6 +4828,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         int type;
>         int scanned;
>         int reclaimed;
> +       unsigned long file_taken =3D 0;
>         LIST_HEAD(list);
>         LIST_HEAD(clean);
>         struct folio *folio;
> @@ -4839,8 +4843,8 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>         lruvec_lock_irq(lruvec);
>
> -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, &t=
ype, &list);
> -
> +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> +                                &type, &list, &file_taken);
>         scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
>
>         if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS =
> lrugen->max_seq)
> @@ -4852,6 +4856,14 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                 return scanned;
>  retry:
>         reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false, m=
emcg);
> +
> +       if (stat.nr_unqueued_dirty && stat.nr_unqueued_dirty =3D=3D file_=
taken) {
> +               wakeup_flusher_threads(WB_REASON_VMSCAN);
> +
> +               if (!writeback_throttling_sane(sc))
> +                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> +       }
> +       sc->nr.file_taken +=3D file_taken;
>         sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
>         sc->nr_reclaimed +=3D reclaimed;
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> @@ -5021,27 +5033,9 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>         }
>
>         /*
> -        * If too many file cache in the coldest generation can't be evic=
ted
> -        * due to being dirty, wake up the flusher.
> +        * Flusher wakeup and writeback throttling are handled in
> +        * evict_folios() based on per-batch reclaim results.
>          */
> -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken) {
> -               struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> -
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
> -               /*
> -                * For cgroupv1 dirty throttling is achieved by waking up
> -                * the kernel flusher here and later waiting on folios
> -                * which are in writeback to finish (see shrink_folio_lis=
t()).
> -                *
> -                * Flusher may not be able to issue writeback quickly
> -                * enough for cgroupv1 writeback throttling to work
> -                * on a large system.
> -                */
> -               if (!writeback_throttling_sane(sc))
> -                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> -       }
> -
>         /* whether this lruvec should be rotated */
>         return nr_to_scan < 0;
>  }
> --
> 2.54.0
>
>

Hi, Vineet,

Thanks for the patch, I got what you mean, but even with this patch,
the wakeup and flush logic of MGLRU is still very different from
classical LRU and doesn't perform well. No throttling, the batch is
still over large, and it could over aggressively wake up the flusher
as the folios are stuck at the tail.

There are a few more issues related, so there is already a ongoing
work to fix them properly, and make them more unified:
https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@t=
encent.com/

Global throttling or isolation throttling are still missing after
that, I think maybe we can focus on that part after that series. How
do you think?

