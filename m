Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381C9C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47E86B007B; Fri,  7 Aug 2026 12:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7D66B0088; Fri,  7 Aug 2026 12:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99196B008C; Fri,  7 Aug 2026 12:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 872CF6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:25:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1302EA041D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:25:16 +0000 (UTC)
X-FDA: 85074998232.21.BD2202F
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1771014000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:25:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E/o356Vg";
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786119914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nq9BpeHJ6tTNRTc5GmXO5u4Rdj0A8ZpVtKET+19eWXw=;
	b=IOCvMflXNN6RoQbKon+2RCPZ6KZptg3IzRZiqhrikuGQF/yi5zv3p12MtHrZbRkC6bk/Pp
	9cMBoMqUqbr0/RcAipbW7Q4csFC5dxmZzxaAjoL4S0SNqbwCimw1U8eL3v4Z+qj60o8+2g
	dePm2Cx5pRD4A499+J/YT7rxz66ZmXo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786119914;
	b=lCaljtc8RkkO0ii67hf6yxzeA0YoMQz0kgVxlm+W2O7H+832/TLW2W0oYltud4OS13GX82
	HTVTB+ruENdisTgsfTMjr7StOuQTDZUkVYDIUzNy0rzA0yUOOCeXWuUQRG5WlgX9AnXPJL
	8UUk50+VoYp27YoEwfyaQJWev2hD7uE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E/o356Vg";
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f71156e1aso1635078f8f.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786119912; cv=none;
        d=google.com; s=arc-20260327;
        b=d4mAWbShj7c3rH6RrRMpLS42tTFxlrFTNaKqWSs/083OoXUZezN1B1rgcxdSfq8Mt7
         jMoDJvaE6co0efH75gTbrfKVCudSp4NhfzrQMwyUc2lYUBN1ktnapjMEa492GF/oflUf
         StrEML/Zaq2Gy4prq8h2ogXXwly435G8o4H8dDcEZoAfhVtSte9GfRZr9TdmBVZ3iryo
         jsiXS0TtwFeTUvCscY1HtlZZT+B5Qc2vS+wNjyimfjcnLI9WDVV756RHZaXPnfY1neGq
         ghkPrlw61GbNk2huft3Sf9Ll8acUxFisBThkf+aOgnPtU8NWtV4jGWI/bYvrifN+Mp1h
         WuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nq9BpeHJ6tTNRTc5GmXO5u4Rdj0A8ZpVtKET+19eWXw=;
        fh=wXN4MTq2uvo6Dc9jznLxt2YfzPtV+TzprXjfEUbF+jk=;
        b=pU97nMbTB5R1bQhBRyPbPrZYdcULaSqQD4O9ACTQOZH1r/g7nzdjjynKhbpPcV7aTg
         atc5FayazF46ikEAbGHMuANzvPuKG/dK3mfuULGHqSpTa3hhy8jI2RrGrSyT1bT4Besv
         XxySuUydK8oTsXHMr5XfYsQ19DnNFMbjtZjWZaaeuN9AwXkOw1heZNDRED2bMFpIY2ph
         GRiUYMItJW0PFFyOxYsFDIFLhlJUKZbMLtOAIgDoVrRox9XIpvwDGhlQOX3BbqFRkC31
         yOkfuQwJEIuHtq7alZV4ntPlWUo75eV3BbGJxCYf2gQzH+dJjOSlvOs1D0/ImaCFfy4z
         d0Fw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786119912; x=1786724712; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nq9BpeHJ6tTNRTc5GmXO5u4Rdj0A8ZpVtKET+19eWXw=;
        b=E/o356VgK5nT/OvaHSYnmv9bPOdM/j3xm4I5MegzwGrqiiEdtPpeODPBVpVUDasW0d
         qMAyvQwTbjScEr9fLzQBK16LbxfgYZ/guC56UFkQPqkF6w0YuGmpcToPr5ch/xm5hjWN
         U9HdUIHMh9r+fanr7WXEXFKMNRgZieVoFr33PaGtMYmFek44Szt9XqMy53LVWvtLXxJk
         iGQyryXPST/n7B00Y1XqujOySBIJOpCiVdp4di0z2pFCyO20DYuGpnUtvfO3TxiLueDw
         4H+FMznBHOSltZyn4C0toMSGmlm4Vf6Hd6edmV/YLdPJ4T1rQHAH9P5dT1CT7Xum3tiF
         n2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786119912; x=1786724712;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nq9BpeHJ6tTNRTc5GmXO5u4Rdj0A8ZpVtKET+19eWXw=;
        b=ptQgkNpRH/ls1uY8G5UlQucOeQR5AFO1eKV5HJcxplyAu93BsTGTD60QDYqpuqM3sB
         /xkP3YCJVLNS5zrQKkxJj0z2RQlYh8/lDShNJP1vreiDOtA+75t7ZiSWRguO3dRlk5rp
         l8c5F23gnN7Lkm+sZ0XpDjeF39G6OjWXK6z25p3TykJmKshlonnr2cAYAlPvEPYI11zY
         fUaBKY+isGYWsH927PuunsKwRmxlFmSLlVJKjN0ym8grayQ9WA2T6K4zv8/FHN3R/uRn
         gNFRaawRsCy+cRJyGS+4v0AYGZBlAIU2RhAhk3dTlffsWlLr1MtSzUuF4Mj6sI2M2o4v
         +WPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpk5Vfo2mirTwU5OwAVjoCkQVZ3oZVy0MiSCanPM2izkk860IOBipgH6jkwGFqNKdUF3SaEuJWixw==@kvack.org
X-Gm-Message-State: AOJu0YwvWflorhmMrL5UcZGexeWL4yh6cMDlZZFfZA1b4uq8hQlKRlHj
	Gyy+awVPdXh4LZshQk0vydSbFafsS4RwlKtY024treyd4ZU37Gv3JfDahwG6YZCcESNm3CV1Oir
	kcA7XoO1SDliB77VDsGrryswJvf6gPa0=
X-Gm-Gg: AR+sD13bl2FUtqLrbZjTzeLnNAz/mvdubkzf4rRp+eGjKzOmEi3dk8PulY9wQq7KNtq
	7wXmsTQoc7/H65TCxggMYGfEpsYyKAGCZQnl8h7dFKrjihSgFd/o/ZIsucCNHJNdiXLn57STabm
	xg+NYZHBByi1apfnd7XutrYLRAa/SSZm+ZPeUPSbY7kIGzBukLWKf/UCI1Z1+GBfKjSxJkor2pF
	bXGlGT5D6ZBgPfiZS20gD9fx2tLvFKh1vxtn4FaUxk/wjaXrPypvjvfAjOL0+O/KqVEMK1Scvpy
	QCAnSsApAAeDImLq1ia+ViR9x37iZntYbHNQoenbXjji45SW6rPw81cP2Dd+h8mY3wZZdER4kmH
	J
X-Received: by 2002:a05:6000:2999:20b0:47f:e886:6dff with SMTP id
 ffacd0b85a97d-48130e7e5e4mr1319804f8f.4.1786119912273; Fri, 07 Aug 2026
 09:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
In-Reply-To: <anXJ-5_vO7-toSe1@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 7 Aug 2026 09:25:01 -0700
X-Gm-Features: AUfX_mx_zSgai47_Mg-WL7IKdVUwkddJRTo3ii5ogQ2xEe2rL4tS5rMuKzUwb6g
Message-ID: <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bmpgn86tkgnqgcp479d8ff3o9oriipgs
X-Rspamd-Queue-Id: 1771014000C
X-HE-Tag: 1786119913-720324
X-HE-Meta: U2FsdGVkX1+e5A0da4gzEhZ93nSO7iNQixEhliTCkEoFIYslN9VES8pV/NH5wdfcek87BQ9NNkbTcLNrHUwRmSEggN8wiGWz6o0OTPXacs4mzJpZG1BzQznDZSQZwnZ3u0soOdz/VhVdwRbZjLOgVTaMZ8CxztRyjsHuo+qrEq/+qNRyHXgWJUSW9q0Zlznn66xbf43EF7uqtdeAJ4J8SQI2q5g8RvYh4eH2mYxcThurdyxTY78TIKyMmqmsxw0qNw7cPzHov051WuLvHLcOcpQnUUN/MFLOG0Qbw0c/eGovbV9Sk+qZ3q5gGEkEfqOfvKcrEpt9i2uh7PBVF72JGctpaC2IbK5Bk01IRLLuSJKVj1z2w4FWV3GuHYHnNlcPS9MLur3N6vwx3zNlmWSARyOKcneLYI3IQqGu7CWLLyESS4L5IbZMlRXr1HcHUsA1SkjE3a02ZWjfO6S/IJkiNwia8gke4X7zdb7uq0/xIrLL91foZPwVkJ+ej6UH2H37hlnIlSjkrUgUPb1yg/3O/Yc6uqysRFLDjwHJw4odu8+tUfeKAsyFrP8StrIdI+quykfcBEKlVeVdZzCd3J46U5EHkBs0IrDdq7XXAkdo47pdTwjnpdYVWSjtz8ldQ3D60WX1ISiNuEdDm8A8yWl/9EiawBghIa2gl5gdvQQvrt0SxbWvzNp2mBS26047ciXGtUoSP4HMBoTYJq1VPtWIichsVO+bTutbik9vsHPt4X3I5hzmnEUe6ZmkcBCvmvK3UNcyrCA0o/fXwPgJ79kyVslYzFbdUBDqOkK8zZxJxspvRCe1au5zXm80GsiGF8j2tFNy4Bcqa1Vgpruf+77LnNkWdusu2AvH3FLFeS8oERWEmRS3NcREOdLr8cPkESzSnJszC6bNbquZQhEnN+du6PsKOsJBnJ5JuK9NCI3hKWI3I1ooRRDN2icnf5dSa/ydSuFgJlCGElo45wb/Tst
 S9Rz2fZ4
 xrWCw4KGa9U7DqgG99fSYFTYJ1qX9Aik5CqieCUzTbSCn03oRcTnvIChILxdWUB9/nWhKNEN4Gli1tvlPqb50Qm0HPs4BtRIkcfERPRNJaReKdqwuOIxv0x88SBoBP9F9zHJOqB1MxGnLiyywT1J7S2kKoXPXXZK2CNC/8ZS4v+xN3GAwg5UNoZRkkxRAYbz4jVmAuEB+DiDVVcjE2GGdfgqm5DXMjUIJFVaRXTiCtXIFxoz5+yiFr2KoIxpps2adQIsnMQN0pPnysFAFex8CzMEbMrEfPv6WB1vakiGiRAyx247Bov6toV31CQkhpUNL0wfSUNl1hpmgOWUBMLVoARhwVJ/sDdMXILiROX6NgO7MrVQKotrzmrPOv2+YuMAyiyDYN+Dd3r1WleQu0FXkKtamkQSe8/QK8KYrkGmqKZfJ2ycJuwX/N+XO0qG0z19YcIOf07slQdm2uw5vNFSpNFeJI9OIGvFlYmGDkQFzQOKcIQhQbGMJ0ei/bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 5:12=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/08/07 18:57), Xueyuan Chen wrote:
> > Hi Sergey,
> >
> > Here is some additional data:
> >
> > I used the following definitions:
> >   compactable ratio =3D freeable_pages / total_pages
> >   memory reclaimed  =3D pages_freed * PAGE_SIZE
> >
> > freeable_pages is the estimate before compaction, based on the same
> > calculation as zs_shrinker_count(), while pages_freed is the actual
> > number of backing pages released.
> >
> > There were 264 callbacks in the trace:
> >   callback elapsed time:
> >     median:    5.77 ms
> >     p95:      55.82 ms
> >     maximum: 271.36 ms
> >
> >   compactable ratio before compaction:
> >     median:   0.32%
> >     p95:      2.86%
> >     maximum:  8.33%
> >
> >   memory reclaimed per callback:
> >     median:    3.80 MiB
> >     p95:      30.45 MiB
> >     maximum:  92.73 MiB
> >
> > The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
> > and it released 7,650 pages, or about 29.88 MiB.
> >
> > There was also a 241.91 ms callback (with 30 schedule-outs) with a
> > compactable ratio of 0.44%. It released 1,019 pages, or about
> > 3.98 MiB.
> >
> > Based on this data, it seems better to remove the shrinker.
> >
> > Would you prefer that I change v2 to remove the zsmalloc shrinker
> > callbacks directly?
>
> Let's bring in heavy artillery to this discussion, in addition to Andrew
> and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).
>
> Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
> I don't think those buy us much apart from memcpy-s and lock
> contention.  Systems that want to compact zsmalloc have a sysfs
> knob (and API) to do so (based on zram mm_stat numbers).

Hmm we'd need to collect more data in our workloads to determine, but
if we can compute compactable ratio (freeable_pages / total_pages) on
a per size class basis, can we just skip the size class whose ratio is
too bad? Would that at least cut down on the vast majority of
fruitless memcpys and lock acquisitions etc?

I'm always a bit hesitant to over-rely on userspace, especially when
kernel has information to do something smart about it. It might not
react in time, and many proactive reclaiming schemes back off under
heavy memory pressure.

>
> Any thoughts?

