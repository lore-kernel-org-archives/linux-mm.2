Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23123D277E8
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 13:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F5E6B0088; Sat, 10 Jan 2026 08:55:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EB86B0089; Sat, 10 Jan 2026 08:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21A06B008A; Sat, 10 Jan 2026 08:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE2BC6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 08:55:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E46BC118A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:55:16 +0000 (UTC)
X-FDA: 84316201032.19.8CD9FD3
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id B658440009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:55:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E86uzEDB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768053314; a=rsa-sha256;
	cv=none;
	b=GevI2tTIbXUXoKwDQET8YJ+In3dcQvowQ114gXmgj7TvL6ojJEWDLLnfTPw16nIy8PoXZb
	DN8zuV0Mx00bDI9kpBB25/XfvTbPrnoy2G56E0rnlNFq5LXu/bzbyXInzsvpH3d4F2yqP9
	OyqCwm2VtF1JqbddS1na0KTDJTEOL0I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E86uzEDB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768053314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bF15tgDtFzb7B//rb6r4Znze3ckqkWQR0unvRLAwiw=;
	b=XQ+4BDOU9Lcry9cypAzcfvDTC6X6l4PRZgy+hHSYv1kvP4moPRbIkFFuxGMkB9yKa3JULX
	MMQUHTjxX4yaBteWKIB2EgMKj7/Kv54m6s/a2jZzxoqnXDlQMiljK51k5IOrTtB/5SqHij
	XN6nx84nPBa51p1J6CdUdn3gXIrXL14=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8907f0b447aso55166456d6.0
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768053314; x=1768658114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bF15tgDtFzb7B//rb6r4Znze3ckqkWQR0unvRLAwiw=;
        b=E86uzEDBmsUw0h0fDYsB2jSNVE7IIxFMI3HjD02mkuT+d/O2g/NihumXA9l2OLTUFC
         V/ohybIV1tsXXn41gnEG0IUEpnVPlL/rYEbCa/zZfj7Vpj7stmeKiJ5ejRXqbTeoMbXc
         MXVLvmFhQE6wFJJH/8/MCxxX4feRr9wrko2lof4WgyhE9XKOOTok05R0uIQK0Qs4NIf0
         nHzTLrfS4CUiwSyI4PtWm605KtWyePFEDaUE7SSh8ibfh2jAUs4HB8yOO2GVaBM0aMKD
         Jbh45fyrb/es62qMEjcBgrRxK9NfuT4uv/FphOPMbA6s4Uqn1/05pC7/demvrAMoBdvJ
         ACdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768053314; x=1768658114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6bF15tgDtFzb7B//rb6r4Znze3ckqkWQR0unvRLAwiw=;
        b=hwxMFItRI2UDM4jijlyPuXV15gM+jV8r26KZTmZCoYr7WwAtyQtZV0WfesMUzfjS0I
         8E5xCtuYc03OI+SKgBAB6sRV4YBM/suasU/E2V5H93We5juF61qQ9jmDr1R8Du2JbJqI
         LC55MvqBoHM//4NnsxI/CeAf3XzU3EGbE2QQV+QKJJDMFT1gcqRRncVJ9zZjdxyYuQsO
         jcCfnZQzWsyhpyPAzGCE3K7W+Ihr8EE4yUbh6zAgjJt7GWiTw5HQ5YJ6FNC/ZtaHbF5k
         FB5pVEngffLlTejMqzI90oVEIDFuViWtBJ2ys5ch0nchfQElM4ioqaEE5iCzE0EVWOcC
         CxwA==
X-Forwarded-Encrypted: i=1; AJvYcCWgnD9MjcTcHo6trtSNHsUA1Ppk8o/iGbvxtDIpQJVr5hFVFk/bW6/iQwKIVLsRa7BKNCFFG8vXjw==@kvack.org
X-Gm-Message-State: AOJu0YyznWrS1Z5SMTTvb+A74PtRzTS8ej/0tHg/XAxsPQx54KzPpkLg
	nlKfGEjSdgEBXdf6SMy5R2m0vtn+cRdx1ZoBSIImo3BSawfjpXBfn9C266DdNUf+ADbPFKvYHfn
	Vog9rl3EGbDrOXxayIWRl6bkXIzZj6RI=
X-Gm-Gg: AY/fxX4OUvoW6LlWgpulIoFRlaxd8Nu5Io7pkfdgMxWG066IPWhGYrOGbrlDOK3U63L
	Hrxjcm5c+KGJi29mGhVokDFy0yIxf4P4WOyKzatWoOesxZa+bxVLy0E3LdDr6Ujm+yEEmH5NAGK
	opQZn71V/LNlAl/w+yB236y8vh25F8ezTBtJ0i4EFdAaPdl3hx9eymkOOyQIML7aVIKVKrzCsHu
	8jiH1SxHBeTVdZGYfEXVIiCGdEvbcEuCtML1EgVyJpEs6SixBrLgvP/Y+y2Y19TTE+/z+ucnefT
	P/PKdxFQmFc7GZfcN41wtk9yyxjzxYC8OA==
X-Google-Smtp-Source: AGHT+IEDYC3cY6soBRLQg0jrKD+eKmTD2ovAt2yrZmq93YN5K8GrT0NaJGJRys7cFEZm4N+ttZhDuYFIVnybaRJXjUM=
X-Received: by 2002:a05:6214:27c2:b0:87c:1d24:7b7f with SMTP id
 6a1803df08f44-890841aa05fmr191022996d6.23.1768053313735; Sat, 10 Jan 2026
 05:55:13 -0800 (PST)
MIME-Version: 1.0
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com> <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
In-Reply-To: <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 10 Jan 2026 22:55:02 +0900
X-Gm-Features: AZwV_QiB1arM2112x9CFryUSneEVqs_KakkkX2Yd9ULOgdOZCKyZki0KapMs8FI
Message-ID: <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: gourry@gourry.net
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B658440009
X-Rspamd-Server: rspam06
X-Stat-Signature: xir8oq5fitmeg7qcrkggagp9r8ig91aj
X-Rspam-User: 
X-HE-Tag: 1768053314-404436
X-HE-Meta: U2FsdGVkX1+mfceVIIH4mKEUGs+yLlbmiWShdNx/Wab4cox9QZHclqmfJ6mOqFz0yA5dBd6s+9V2HdVDHXjpcGnPoJsEEMAXJq/NrqMwS67ovJq+85RKlI+d/yCU0OFBYXKWJnkFxMud/3o+X43c0+cJ4XaEfOYgOQ0GHViYW83Jmabt9l/FJcva+DGuOU1ABjQW//mWcAkyhALhz7nU8sYhmpkT9sn7wPwONMo8+PdwTzQDTmWG1chugHKwxi7FEq3TMknJ68tZ6EylQrYvuzPO1SV283KFxP1PtgczEFlthCJD+D8pj2wdPNfRinvn9apNmtC/+/TmQRcGvQQf3kZyNvjV6hKOH/JHEt9Pp7i0bxCt84tFalRgAcySMjiju9TDAPSzlaYQISfZH4Xf9x7GrXsg149g9+shZkOtzIjLyVLlxXz/HbzJp3821rMST4MEuuxmCabQqt3q81UVhPOmjb4hV4GzWF2qohuPfYGgjmCsp6Gg8mCPrWHx7Y4ySKuqUoDOlAUv2dpWD56Q9S7RgG9hTHPbncF8Osfz5sghf9Ocn57Hvg4NHIyxr5NmHg87sdci/rTUR5gxznGWQCaGNxGkabxYNSU+5UAMaqb1tVmt5/A0NHPAo/swV2pEIGEzSsV+9Oq1FmvSBPC5PwandIvn9i2njswjsst+hQWXrY04TS5OC7uNuxhFxIC+sX6PxSl4o1xDRTerAHFXqrWOQvrUciMWWaBNvLt8UzYOviYviiPtxUtvGfil1ePCRwn5ayaKurkUnrLFrQaNDQrLxNjfYrACkqDDyw6gDiULGXt6FHCFN8gmWjN282NiEk5/lytOvsZioUdun9LHmN7/ZxO/fKDOSC4BiS/a9wUjv10DUADUzY3fuuoqiqoAqBHGnAgtVvkFgGSAiG1ahl0uoNIN3Pm04sEh95PAI5uC0bOEbKfSk/DAf9W+Tu0pOL2qQ2FIse68UrARfNg
 8EzYQSTJ
 Tpt1FXtFX5lridnHYmjrgpuSIQbnY1BtMgb1FyH9w4z48A3S6fJ6p7wEj48FLE7RQMw1I3EhZeZ0TN01sRaP9iO41FA7aKJ0whZNRhoqqmcwv5hOxU1vpgUmeIbBRRTYdIVsZgn+WOrQYrczYjjZU5WJRTTErLvUNR6P2nWWRQyKfuhljSlbj+Ye4PCdutJy4CDlURxF8q91waVocl110dFgOIfe4TEo+afYTnH4BetuOiD5pPSbeRutGJrGdc7TzzeWthfUNU+wNVjqG8TdBfJLJkDFfKzYRUsrFlH9dIMMDt9v5b2iIS9niSNv7pLZtFqb2b39PhIb61+qC9zK1AkAghQ5tg7kkj/9/+ew1PXHJRP6QaT+BGjfn4YxLxKgBhq+VETEtb2oslBRyQuwbavgM9y8XveyLUiO472JAbYd/pBMGb67Yr127IEeNzS898f5GqU8HKX5H90FWMKYxbarygwj19uiOYbuG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8810=E6=97=A5(=E5=9C=9F) 1:08 Gregory Price <gourry@go=
urry.net>:
>
> > +     for_each_node_mask(nid, allowed_mask) {
> > +             int z;
> > +             struct zone *zone;
> > +             struct pglist_data *pgdat =3D NODE_DATA(nid);
> > +
> > +             for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES =
- 1) {
> > +                     if (zone_watermark_ok(zone, 0, min_wmark_pages(zo=
ne),
> > +                                             ZONE_MOVABLE, 0))
>
> Why does this only check zone movable?

Here, zone_watermark_ok() checks the free memory for all zones from 0 to
MAX_NR_ZONES - 1.
There is no strong reason to pass ZONE_MOVABLE as the highest_zoneidx
argument every time zone_watermark_ok() is called; I can change it if an
appropriate value is found.
In v1, highest_zoneidx was "sc ? sc->reclaim_idx : MAX_NR_ZONES - 1"

> Also, would this also limit pressure-signal to invoke reclaim when
> there is still swap space available?  Should demotion not be a pressure
> source for triggering harder reclaim?

Since can_reclaim_anon_pages() checks whether there is free space on the sw=
ap
device before checking with can_demote(), I think the negative impact of th=
is
change will be small. However, since I have not been able to confirm the
behavior when a swap device is available, I would like to correctly underst=
and
the impact.

