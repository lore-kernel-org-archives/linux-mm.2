Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA9DCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8A76B0092; Thu, 30 Apr 2026 11:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659456B0093; Thu, 30 Apr 2026 11:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548006B0095; Thu, 30 Apr 2026 11:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4044F6B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:30:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E998A162987
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:45:19 +0000 (UTC)
X-FDA: 84715495158.20.CB6D249
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id E162440007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:45:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCC7R8yN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOK2pP/zau4SgUA2N39e0oS821j3dKc1kbU0GjnTeN4=;
	b=L/bL5Y/JR59/vXxtcNbaoCHZAYHOa7BMnVF5060HNmX9m6uCkLsAbEb5fkOcP4BIax48QO
	vOOyneVMvlmAveDxzGAhqNTtlJvbjl/9kv1BPtQh97Gfur6+myPSZHMKyhO3hDoT0yxirN
	O5YrxFjWenJei981SPakDgGsZ+0Z9F0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777560318; a=rsa-sha256;
	cv=pass;
	b=ju2HM/WpsS3eXEBzFJgHE5g+9FCp2UabebKWd1L4vUQHpxQqzNe5I9jkAXJhvvkNJMxt5v
	N34m1tUJ0BtMssF+EqssI/DABWkRD/fTCj0xq/4mCRvhu3uAMnLfWtJ6x4wXrxNh9TU7fx
	qQUkFOYyXnGQpPScaU9WAn/x+cBE2i8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCC7R8yN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-573a81abef0so605090e0c.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:45:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777560317; cv=none;
        d=google.com; s=arc-20240605;
        b=ZjIyvnkkPUWn0QFLb5C4Egc6CjJHDNW64vgqJwWgS+fHGIY6Tzrbgr2ntodYv89HUD
         3uNIMTgBpg7iC1hWR4l3wwL7Yx88flZIaghH22hz8Kt+5RnlwkMqaS9hXte6wY00Clow
         5vy54+Ofo3eVEQMjLH5UbTGsWtIyMShx5f4yOmGMNmjjn6l1JfQai1Z2udc9ZRX6mCym
         Hiu1PDU2B7igRc8gGp8iP6FzFEYQBClsrVT62l0oVLRMOH//c9QAttq0y+TX4Wk7/ciX
         kX6sxomS7T5FFYad3ETVrD/x5auXGa7mZtPLC1m5rd2sKPoulHUaFTcdU/WZYNi55jKb
         gDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NOK2pP/zau4SgUA2N39e0oS821j3dKc1kbU0GjnTeN4=;
        fh=EqwPbkcCqItBkxRHSPrpPRdf1qSBGGzV2AUXlM73YmM=;
        b=gxVO9wnZXSGQKBowdEqkxx+S72W6NHW/gY/JuAYL0/hVmUQSw7woBCxgpsdgKa+4c0
         pKPUxIR3wnodnZaXtFhc4SQQDagM2s8KZK+gvEdPc/Y1u+Yos3xcrKi/vATlWmHHKelO
         vLlYMfFA5YT93zwG85VONEnPqJ83P9TGaKjUFxkQ+6GgQcPuoh5UMamzHK3p/lOwdlVN
         YUBdAJITkTw8NvNbFvVhTDiFj+EPekkhmquOUZ5Kfu/Kr+cKMFZNXH7MXziUFa85Vzl7
         aPKN3aSVC43DQIlAcen+2ZKOSd7Xp33xmTibC32RYvZxDHBQbNhq8K6IHYfSixf5uMeQ
         JFiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777560317; x=1778165117; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NOK2pP/zau4SgUA2N39e0oS821j3dKc1kbU0GjnTeN4=;
        b=eCC7R8yNokzeZIIWjQR9gQSQhyHO+aNzzea8THDJXADIksN8sMKYAUTXoxk2tFqnrc
         ffvfWtAwMpDliD2eE3h2Yw53Gnzw5JxsLundn8TeIr0vmALJwRZFI1pOTxwF+BMGmFqU
         IwK0uXn9c/c1SNWuMfeWUyDU1oOeh5nJMQUnMmk2JCLQdFUwmvvlD/mbyBM4AaLeHRQn
         TsO7KrAapo4j063XMSgQZziROOsIHFi57WHlbId3/bIlDvnnLnXPKqbbs0Gw7xvaJvTj
         af5P/Mtiaefcw4O79g6xlgmisqWDLiNWjUEaQqCldCnYWwubzyDEtZUG+bN1d4ZctvfT
         GwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777560317; x=1778165117;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOK2pP/zau4SgUA2N39e0oS821j3dKc1kbU0GjnTeN4=;
        b=Ef5GkVYenD8xyzB+0S7ks/mZishDHmE9bnhOLJflP0HtJrTPrj48MjIHnhZPiElsIM
         vCbOhSr9NHAD1q2xiLbsWAgjJBZ2rP9YkJdv4qgnNt2N8Nxh6usKqSCj9EBNe0+zwKDZ
         QgYfCu7boiWsI2oiZEncl/NY+0dh2q03oRKbxNT2iznlpB+hbdK3PO7EXhto85sh7ow6
         hOEiW2NTpP1+85HK2U4uH0eyhFtfFhy7M8R/qJAAJXVvbkLIPO3FaEqmEW67ZeN+CxUk
         Rvh/iQm8o682meNVhagEcgsXq9epzGJi+MNsO5TlZBg20ARUCFhpXTtFYgnGujFrPNee
         4zQg==
X-Forwarded-Encrypted: i=1; AFNElJ8hjOgyTURehQvXZ0fooXRRMWlHdTccFwYK2XYX1p8O91XXLjeRwxRB9x1FSCxduNI3ShJZ4I8J3A==@kvack.org
X-Gm-Message-State: AOJu0Yza+jXLNn43IRRXuET39UvL/C7c0uv2jMrc45yib+Kk/pMBJBJA
	NxVP+2iB6VtVePZRjSwvQ98/bL/QwsocqBwcD9JdYOZD+/ZklwXwpzG/Co+5szKteGMUnouoIeq
	nxEIy+OTAGnVTFrXgFvEae8P7tj0/fsc=
X-Gm-Gg: AeBDiev+mcR/HzhTnamYjgat3phynbAZy0pDvTQvCJBC75CTlm97Kfm9UmsR7d2wxF1
	s1a9TXGC5YFu1LoqYi1lCuAHI1lLS2mskE15SZ/RCrMYxythju4z8YIusxmQHNYkbxA4CevsH3N
	OYmXdpSM9+7DqyzsKdckGEZsFMWi+jDAiTNiW2cAJf3ol+y7Qg4q+0QDQqz7HlGIq1vghJhyGV6
	VoW7Udd4F3Rh0+flphavonDl2xsmAR6+19wTpfAKtjw600Ep+8C/APQO419xo1FbSSdaCjzv1Wq
	SasT5tOCpjztB2FGozlfIPc3l1W79QfZr5liH5THTxvtuE33DbOr
X-Received: by 2002:a05:6102:5cc2:b0:611:82b:a599 with SMTP id
 ada2fe7eead31-62ad4b81c17mr1657994137.21.1777560316835; Thu, 30 Apr 2026
 07:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260429185441.486804-1-agarwal.vineet2006@gmail.com> <CAMgjq7DFM6rq5bHzkSHWTn2fV3bp+u5u-z07bH1j7of-E1F49w@mail.gmail.com>
In-Reply-To: <CAMgjq7DFM6rq5bHzkSHWTn2fV3bp+u5u-z07bH1j7of-E1F49w@mail.gmail.com>
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Date: Thu, 30 Apr 2026 20:15:03 +0530
X-Gm-Features: AVHnY4KGgvyb2llfYsAUPncCALveY2E1P_XBAU9FpGOfEtOUUF25_WZbYx0-91U
Message-ID: <CA+rjy8cpDL+9ZZtLraaHTSJmCq0mG+XhmUDsicexFuaFPZfhQg@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: fix delayed flusher wakeup in MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	linuszeng@tencent.com
Content-Type: multipart/alternative; boundary="000000000000407acb0650ae838e"
X-Rspam-User: 
X-Rspamd-Queue-Id: E162440007
X-Rspamd-Server: rspam04
X-Stat-Signature: riaj941noe5tyriwqbnathpcziob494r
X-HE-Tag: 1777560317-275190
X-HE-Meta: U2FsdGVkX1/WIu+9NDGoRtukg7c3yjI1e62+VQpZ5JsAzhTAzc4T4VGQKxV/32wOj8eOAcTVfWFR3yz3gXnZvjxfMeHp+oYdVQP/BcmPZp8hBp1v+6O9UILlIV7oFmCNZJ5rjb7ogXfb7etDgCSv66YjWocINIzGbRU6i3Ecm6/m0LyIXJ2AfZbQxDmE+J0HfTSL1SHvZycGkite16qIoQPSJjihzz4w/rd3tz9b/fjU3MV8hLmC53virA78BdXh2ighgSBCTE2KOVHfUSF9OkXwuylJidrl2dNHXjIpso5HNWE/ltu5irtqXPeYxDSxGItFgOGtVo7+Vw+MXQSpi7HVsW9gop+gjnGRayYbD1hTaUk5UOjCWz75lzYGOLdhoUThzA2ju2Y1uuRVapKnR3EzINV5pvvoOsZPHPnm2QHQsPCOGzhQkQql+xPon1UocmteTVV7beuh1q2/uLVEeh20/tV8YoxtnioyAaAku3V77V3BlAtV0rvycf2EusH943xpyFGT1GRpXUBij3l+VM8fwJhVtTZsiFxTI9BiOZqAZOmn02u17omudOqm3JZLt3KgwEvcve7zyz+IewiAWq6WTAz8a2XxCVIU0qDzbco7MBZ0ANT39VIBD75AiEqW5yxOhIYUT2mKzMebSaHPqwL9qNQpE3VN3lKUj68NZoIE7nM2JHOniRb8hVJK7mVGPzT4Bd2VKsP6jNZPLO4TFG9rTY4akXpPJvuH38JJSczJj26qvapKZtDEfR6ktveBxARChZShq96vFQ4aPZ9vMZhaTfWrGiaDn60LsK7I6szzAuzINgljZwPlettRazxjsZyvqQdKDM6KksAuupgmbyVLiy0BYgmivtEayzfJjR9qS3imOQoC26kLwJXpHDYQEfSZ9wLXuqQ2j1XbTZ/ltgOnAZ8syMU6O0rRrMhrh3xUNzxKFNYIRikGSbqUqV+txtJbzjV6QXO071ednW+
 /NefYuU/
 jDV8LbLDo/QYpdXd5cbcJGL3vi3E+a/5yngi1uFYzP6V6cxhdN7jng/Pv6LkUJIr5CjVir7seOwFJtThVektCZ950e4LzjhtGvI5IVi/ERw531gUilDhgf2mKBsVnKG79K4vnrg+6lnU5hCsigUrfrETW2H0cQMPqxDY3rPh2BsnohjP+zL+BiYWa0mjL8KPC4h8bu0V+d2GIT+WAn4hfhveKtfhPNW7SRO/oG4YWTk3tP9+cV2YVr8Z2aO/KpqD0M1Wyjq4mo+zH4v+fBoTDRK8JUDrlbT6N2JtC6ABJu0dO0n0VM51b/5Ab6NY1A/SWXpVJQ8LUyTNdBmwq+klt2M5NWFhguKqYt1T4qJ4CFsIup2otRBL00Ko0MZPRxs9tFsHc+oPsmAApw4YNBLUKQVatKPRNeFxh0D0QrImnKltYUjI6WvVrkuqMgGqfWs/9GwSvPxpAHW0LEUW4GSIqidF+btfazC90lXnB6BPO2SUoHRoH2Qa9gaePdjRw4rxJeXXOFKfE4doUNrcG6NlldwZA/QhM1rBUR3jnkf0ndAKTsjOdLEmueLnqC/bgQKtllpFL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000407acb0650ae838e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kairui,

Thanks for the detailed explanation and for pointing me to the series.

That makes sense =E2=80=94 I see that the issue is part of a broader set of=
 reclaim
and writeback problems in MGLRU, and my patch only addressed a small part
of it.

I=E2=80=99ll go through the series and take a closer look at the remaining =
gaps you
mentioned, especially around throttling.

Thanks again for the guidance.

Vineet


On Thu, 30 Apr 2026 at 20:06, Kairui Song <ryncsn@gmail.com> wrote:

> On Thu, Apr 30, 2026 at 2:55=E2=80=AFAM Vineet Agarwal
> <agarwal.vineet2006@gmail.com> wrote:
> >
> > MGLRU currently decides whether to wake flusher threads in
> > try_to_shrink_lruvec() using cumulative reclaim counters:
> >
> > sc->nr.unqueued_dirty =3D=3D sc->nr.file_taken
> >
> > However, these counters are accumulated across multiple evict_folios()
> > passes before the check is performed.
> >
> > This can delay or suppress flusher wakeup when an earlier reclaim batch
> > isolates only dirty file folios, but a later batch isolates clean file
> > folios before try_to_shrink_lruvec() performs the final comparison.
> >
> > For example:
> >
> > batch 1: file_taken =3D 100, unqueued_dirty =3D 100
> > batch 2: file_taken +=3D 60, unqueued_dirty +=3D 0
> >
> > Final check becomes 100 !=3D 160 and flusher wakeup is skipped, even
> > though reclaim was already blocked by dirty file folios in batch 1.
> >
> > Classic reclaim avoids this by using per-batch values:
> >
> > stat.nr_unqueued_dirty =3D=3D nr_taken
> >
> > and waking flushers immediately when the condition is met.
> >
> > Make MGLRU use the same per-batch flusher wakeup behavior as classic
> > reclaim by moving the flusher wakeup into evict_folios(), using
> > batch-local isolation results from scan_folios() instead of the
> > cumulative counters checked later in try_to_shrink_lruvec().
> >
> > This avoids missed flusher wakeups and makes dirty folio reclaim
> > behavior consistent with classic reclaim.
> >
> > Fixes: 1bc542c6a0d14 ("mm/vmscan: wake up flushers conditionally to
> avoid cgroup OOM")
> > Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> > ---
> >  mm/vmscan.c | 46 ++++++++++++++++++++--------------------------
> >  1 file changed, 20 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bd1b1aa12581..f9b6cc146a3d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4680,7 +4680,8 @@ static bool isolate_folio(struct lruvec *lruvec,
> struct folio *folio, struct sca
> >
> >  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec=
,
> >                        struct scan_control *sc, int type, int tier,
> > -                      struct list_head *list)
> > +                      struct list_head *list,
> > +                      unsigned long *file_taken)
> >  {
> >         int i;
> >         int gen;
> > @@ -4749,7 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan,
> struct lruvec *lruvec,
> >                                 scanned, skipped, isolated,
> >                                 type ? LRU_INACTIVE_FILE :
> LRU_INACTIVE_ANON);
> >         if (type =3D=3D LRU_GEN_FILE)
> > -               sc->nr.file_taken +=3D isolated;
> > +               *file_taken +=3D isolated;
> >         /*
> >          * There might not be eligible folios due to reclaim_idx. Check
> the
> >          * remaining to prevent livelock if it's not making progress.
> > @@ -4798,7 +4799,8 @@ static int get_type_to_scan(struct lruvec *lruvec=
,
> int swappiness)
> >
> >  static int isolate_folios(unsigned long nr_to_scan, struct lruvec
> *lruvec,
> >                           struct scan_control *sc, int swappiness,
> > -                         int *type_scanned, struct list_head *list)
> > +                         int *type_scanned, struct list_head *list,
> > +                         unsigned long *file_taken)
> >  {
> >         int i;
> >         int type =3D get_type_to_scan(lruvec, swappiness);
> > @@ -4809,7 +4811,8 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
> >
> >                 *type_scanned =3D type;
> >
> > -               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type,
> tier, list);
> > +               scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, t=
ier,
> > +                                     list, file_taken);
> >                 if (scanned)
> >                         return scanned;
> >
> > @@ -4825,6 +4828,7 @@ static int evict_folios(unsigned long nr_to_scan,
> struct lruvec *lruvec,
> >         int type;
> >         int scanned;
> >         int reclaimed;
> > +       unsigned long file_taken =3D 0;
> >         LIST_HEAD(list);
> >         LIST_HEAD(clean);
> >         struct folio *folio;
> > @@ -4839,8 +4843,8 @@ static int evict_folios(unsigned long nr_to_scan,
> struct lruvec *lruvec,
> >
> >         lruvec_lock_irq(lruvec);
> >
> > -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> &type, &list);
> > -
> > +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> > +                                &type, &list, &file_taken);
> >         scanned +=3D try_to_inc_min_seq(lruvec, swappiness);
> >
> >         if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GEN=
S
> > lrugen->max_seq)
> > @@ -4852,6 +4856,14 @@ static int evict_folios(unsigned long nr_to_scan=
,
> struct lruvec *lruvec,
> >                 return scanned;
> >  retry:
> >         reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false,
> memcg);
> > +
> > +       if (stat.nr_unqueued_dirty && stat.nr_unqueued_dirty =3D=3D
> file_taken) {
> > +               wakeup_flusher_threads(WB_REASON_VMSCAN);
> > +
> > +               if (!writeback_throttling_sane(sc))
> > +                       reclaim_throttle(pgdat,
> VMSCAN_THROTTLE_WRITEBACK);
> > +       }
> > +       sc->nr.file_taken +=3D file_taken;
> >         sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
> >         sc->nr_reclaimed +=3D reclaimed;
> >         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> > @@ -5021,27 +5033,9 @@ static bool try_to_shrink_lruvec(struct lruvec
> *lruvec, struct scan_control *sc)
> >         }
> >
> >         /*
> > -        * If too many file cache in the coldest generation can't be
> evicted
> > -        * due to being dirty, wake up the flusher.
> > +        * Flusher wakeup and writeback throttling are handled in
> > +        * evict_folios() based on per-batch reclaim results.
> >          */
> > -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D
> sc->nr.file_taken) {
> > -               struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> > -
> > -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> > -
> > -               /*
> > -                * For cgroupv1 dirty throttling is achieved by waking =
up
> > -                * the kernel flusher here and later waiting on folios
> > -                * which are in writeback to finish (see
> shrink_folio_list()).
> > -                *
> > -                * Flusher may not be able to issue writeback quickly
> > -                * enough for cgroupv1 writeback throttling to work
> > -                * on a large system.
> > -                */
> > -               if (!writeback_throttling_sane(sc))
> > -                       reclaim_throttle(pgdat,
> VMSCAN_THROTTLE_WRITEBACK);
> > -       }
> > -
> >         /* whether this lruvec should be rotated */
> >         return nr_to_scan < 0;
> >  }
> > --
> > 2.54.0
> >
> >
>
> Hi, Vineet,
>
> Thanks for the patch, I got what you mean, but even with this patch,
> the wakeup and flush logic of MGLRU is still very different from
> classical LRU and doesn't perform well. No throttling, the batch is
> still over large, and it could over aggressively wake up the flusher
> as the folios are stuck at the tail.
>
> There are a few more issues related, so there is already a ongoing
> work to fix them properly, and make them more unified:
>
> https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43=
@tencent.com/
>
> Global throttling or isolation throttling are still missing after
> that, I think maybe we can focus on that part after that series. How
> do you think?
>

--000000000000407acb0650ae838e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p>Hi Kairui,</p><p>Thanks for the detailed explanation an=
d for pointing me to the series.</p><p>That makes sense =E2=80=94 I see tha=
t the issue is part of a broader set of reclaim and writeback problems in M=
GLRU, and my patch only addressed a small part of it.</p><p>I=E2=80=99ll go=
 through the series and take a closer look at the remaining gaps you mentio=
ned, especially around throttling.</p><p>Thanks again for the guidance.</p>=
<p>Vineet</p><br></div><br><div class=3D"gmail_quote gmail_quote_container"=
><div dir=3D"ltr" class=3D"gmail_attr">On Thu, 30 Apr 2026 at 20:06, Kairui=
 Song &lt;<a href=3D"mailto:ryncsn@gmail.com">ryncsn@gmail.com</a>&gt; wrot=
e:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Thu, Apr 3=
0, 2026 at 2:55=E2=80=AFAM Vineet Agarwal<br>
&lt;<a href=3D"mailto:agarwal.vineet2006@gmail.com" target=3D"_blank">agarw=
al.vineet2006@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; MGLRU currently decides whether to wake flusher threads in<br>
&gt; try_to_shrink_lruvec() using cumulative reclaim counters:<br>
&gt;<br>
&gt; sc-&gt;nr.unqueued_dirty =3D=3D sc-&gt;nr.file_taken<br>
&gt;<br>
&gt; However, these counters are accumulated across multiple evict_folios()=
<br>
&gt; passes before the check is performed.<br>
&gt;<br>
&gt; This can delay or suppress flusher wakeup when an earlier reclaim batc=
h<br>
&gt; isolates only dirty file folios, but a later batch isolates clean file=
<br>
&gt; folios before try_to_shrink_lruvec() performs the final comparison.<br=
>
&gt;<br>
&gt; For example:<br>
&gt;<br>
&gt; batch 1: file_taken =3D 100, unqueued_dirty =3D 100<br>
&gt; batch 2: file_taken +=3D 60, unqueued_dirty +=3D 0<br>
&gt;<br>
&gt; Final check becomes 100 !=3D 160 and flusher wakeup is skipped, even<b=
r>
&gt; though reclaim was already blocked by dirty file folios in batch 1.<br=
>
&gt;<br>
&gt; Classic reclaim avoids this by using per-batch values:<br>
&gt;<br>
&gt; stat.nr_unqueued_dirty =3D=3D nr_taken<br>
&gt;<br>
&gt; and waking flushers immediately when the condition is met.<br>
&gt;<br>
&gt; Make MGLRU use the same per-batch flusher wakeup behavior as classic<b=
r>
&gt; reclaim by moving the flusher wakeup into evict_folios(), using<br>
&gt; batch-local isolation results from scan_folios() instead of the<br>
&gt; cumulative counters checked later in try_to_shrink_lruvec().<br>
&gt;<br>
&gt; This avoids missed flusher wakeups and makes dirty folio reclaim<br>
&gt; behavior consistent with classic reclaim.<br>
&gt;<br>
&gt; Fixes: 1bc542c6a0d14 (&quot;mm/vmscan: wake up flushers conditionally =
to avoid cgroup OOM&quot;)<br>
&gt; Signed-off-by: Vineet Agarwal &lt;<a href=3D"mailto:agarwal.vineet2006=
@gmail.com" target=3D"_blank">agarwal.vineet2006@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 mm/vmscan.c | 46 ++++++++++++++++++++--------------------------<=
br>
&gt;=C2=A0 1 file changed, 20 insertions(+), 26 deletions(-)<br>
&gt;<br>
&gt; diff --git a/mm/vmscan.c b/mm/vmscan.c<br>
&gt; index bd1b1aa12581..f9b6cc146a3d 100644<br>
&gt; --- a/mm/vmscan.c<br>
&gt; +++ b/mm/vmscan.c<br>
&gt; @@ -4680,7 +4680,8 @@ static bool isolate_folio(struct lruvec *lruvec,=
 struct folio *folio, struct sca<br>
&gt;<br>
&gt;=C2=A0 static int scan_folios(unsigned long nr_to_scan, struct lruvec *=
lruvec,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 struct scan_control *sc, int type, int tier,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct list_head *list)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct list_head *list,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 unsigned long *file_taken)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int gen;<br>
&gt; @@ -4749,7 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned, skipped, isolated,=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0type ? LRU_INACTIVE_FILE : =
LRU_INACTIVE_ANON);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (type =3D=3D LRU_GEN_FILE)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sc-&gt;nr.file=
_taken +=3D isolated;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*file_taken +=
=3D isolated;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * There might not be eligible folios=
 due to reclaim_idx. Check the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * remaining to prevent livelock if i=
t&#39;s not making progress.<br>
&gt; @@ -4798,7 +4799,8 @@ static int get_type_to_scan(struct lruvec *lruve=
c, int swappiness)<br>
&gt;<br>
&gt;=C2=A0 static int isolate_folios(unsigned long nr_to_scan, struct lruve=
c *lruvec,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct scan_control *sc, int swappiness,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0int *type_scanned, struct list_head *list)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0int *type_scanned, struct list_head *list,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0unsigned long *file_taken)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int type =3D get_type_to_scan(lruvec,=
 swappiness);<br>
&gt; @@ -4809,7 +4811,8 @@ static int isolate_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*type_sca=
nned =3D type;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D sc=
an_folios(nr_to_scan, lruvec, sc, type, tier, list);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D sc=
an_folios(nr_to_scan, lruvec, sc, type, tier,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list, file_t=
aken);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (scann=
ed)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0return scanned;<br>
&gt;<br>
&gt; @@ -4825,6 +4828,7 @@ static int evict_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int type;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int scanned;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int reclaimed;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long file_taken =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(list);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(clean);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct folio *folio;<br>
&gt; @@ -4839,8 +4843,8 @@ static int evict_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lruvec_lock_irq(lruvec);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D isolate_folios(nr_to_scan, lru=
vec, sc, swappiness, &amp;type, &amp;list);<br>
&gt; -<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D isolate_folios(nr_to_scan, lru=
vec, sc, swappiness,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;type, &amp;list, &amp;file_=
taken);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned +=3D try_to_inc_min_seq(lruve=
c, swappiness);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (evictable_min_seq(lrugen-&gt;min_=
seq, swappiness) + MIN_NR_GENS &gt; lrugen-&gt;max_seq)<br>
&gt; @@ -4852,6 +4856,14 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sc=
anned;<br>
&gt;=C2=A0 retry:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reclaimed =3D shrink_folio_list(&amp;=
list, pgdat, sc, &amp;stat, false, memcg);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (stat.nr_unqueued_dirty &amp;&amp; stat=
.nr_unqueued_dirty =3D=3D file_taken) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wakeup_flusher=
_threads(WB_REASON_VMSCAN);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!writeback=
_throttling_sane(sc))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0sc-&gt;nr.file_taken +=3D file_taken;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sc-&gt;nr.unqueued_dirty +=3D stat.nr=
_unqueued_dirty;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sc-&gt;nr_reclaimed +=3D reclaimed;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_mm_vmscan_lru_shrink_inactive(p=
gdat-&gt;node_id,<br>
&gt; @@ -5021,27 +5033,9 @@ static bool try_to_shrink_lruvec(struct lruvec =
*lruvec, struct scan_control *sc)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If too many file cache in the coldest g=
eneration can&#39;t be evicted<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 * due to being dirty, wake up the flusher=
.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Flusher wakeup and writeback throttling=
 are handled in<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * evict_folios() based on per-batch recla=
im results.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sc-&gt;nr.unqueued_dirty &amp;&amp; sc=
-&gt;nr.unqueued_dirty =3D=3D sc-&gt;nr.file_taken) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pglist_=
data *pgdat =3D lruvec_pgdat(lruvec);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wakeup_flusher=
_threads(WB_REASON_VMSCAN);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * For cgroupv=
1 dirty throttling is achieved by waking up<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * the kernel =
flusher here and later waiting on folios<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * which are i=
n writeback to finish (see shrink_folio_list()).<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Flusher may=
 not be able to issue writeback quickly<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * enough for =
cgroupv1 writeback throttling to work<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * on a large =
system.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!writeback=
_throttling_sane(sc))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* whether this lruvec should be rota=
ted */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return nr_to_scan &lt; 0;<br>
&gt;=C2=A0 }<br>
&gt; --<br>
&gt; 2.54.0<br>
&gt;<br>
&gt;<br>
<br>
Hi, Vineet,<br>
<br>
Thanks for the patch, I got what you mean, but even with this patch,<br>
the wakeup and flush logic of MGLRU is still very different from<br>
classical LRU and doesn&#39;t perform well. No throttling, the batch is<br>
still over large, and it could over aggressively wake up the flusher<br>
as the folios are stuck at the tail.<br>
<br>
There are a few more issues related, so there is already a ongoing<br>
work to fix them properly, and make them more unified:<br>
<a href=3D"https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02f=
abb92dc43@tencent.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.k=
ernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/</a=
><br>
<br>
Global throttling or isolation throttling are still missing after<br>
that, I think maybe we can focus on that part after that series. How<br>
do you think?<br>
</blockquote></div>

--000000000000407acb0650ae838e--

