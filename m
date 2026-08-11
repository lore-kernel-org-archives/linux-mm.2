Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BD9C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C226B00AD; Tue, 11 Aug 2026 14:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42FD6B00AE; Tue, 11 Aug 2026 14:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D590F6B00AF; Tue, 11 Aug 2026 14:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A127D6B00AD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:26:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 216C01401A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:26:12 +0000 (UTC)
X-FDA: 85089818184.15.2A5580B
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 28220100005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:26:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jdNFgTNR;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jyescas@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPHOJuQuNJebZzMyVStdnYyi24KhNdsxUWqnnk8qPcI=;
	b=0qr70wZtsU0RbCaTeFJ+BbRH6iSgpiAbWl72kTkWfuW/uwomk8lLLNMy/gipm3NskymwQO
	ASc7s2LvXSTUKNZHdeAeOoGqfPesNW7hlmQV+QAEKDUTRuBq5POMSEEFB+u54hygKk09Tp
	1J3UWm5U0IT08xg+hTpo0QmH2wafcZ4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jdNFgTNR;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jyescas@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786472770;
	b=MCQkzqqUIdgZosJxshl6TMcfxxegCy1TzBO+dx8OHetS/jY5nxBi2f1kl3INAZPZ3oMmp6
	zXlFlNLKbEHu2VUz131i6TvlPCZtgWKpJo0APJPitXeIIIxsaApdp2irnzjQBIT/p8TGUm
	RefDW4gi5HkfZup5YxFW+SoYDyJq0Fc=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso1230e87.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:26:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786472768; cv=none;
        d=google.com; s=arc-20260327;
        b=maFXjx/S5TB50IrmZQWEDnwOHLDqQ6ehreFyJt75tycM4+b8QT8I9oMluPs5HsBbmR
         dg0ZOinDn8vqFiMCOnrOcGFSA6loyYkB9n00yzUbAJBeYew/jWv10Oynx88f+EfD3Mhd
         S7sYstjKlXgfsASDk5en9ClsNdipWxGXPuf5IfnCc8CFckTc/EnPeejeML2+2cBCB/lZ
         MgLTnvq3FPDereOIqEvB2dMA0V29A50g2spVVpjYDE5hnMw8DytL02zh2ObtEawhk5Vr
         DA3gLU7OE095WGxj3TH7ehdJsr86KC2tzaqHInwVnmSFjeDtA51kYxDgCQ3iWIbn4Qn2
         VLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sPHOJuQuNJebZzMyVStdnYyi24KhNdsxUWqnnk8qPcI=;
        fh=eVcXh9sszFVygF/6b6rr9/TsGaHhWOpV3hdRfUY8IeU=;
        b=bFbW95mMoSePZfHDO40yiTqBVi0UyY9dFBQ2tD6Zxl1NSyG1uRmDVuhIo+F4pmk84m
         Ogbbuy7SdHIReqXnv2xmMjpWskMRaKiZs9S+fB+9AlYgy//ES+ExT4otLCap28Zps9SL
         ak8j04PEipoO1Pjcle7r21tL6EcEjJV2kxo0xeVKxajR7VU+KScQq/HehwHSaXcQfrSA
         iBlC55bjt/EIOOLmHA2xqhjsGz5MTSl4CQeAQ/lilDwV+A+gspKVnf/PTXu4sy8YUnv7
         /+X3+OIn2rBSU9LVyQCwiCIM6ivqTFyf3WpksBL6ZvAVkqOEOaL1XHitw8TMHzMCqdx0
         /oOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786472768; x=1787077568; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sPHOJuQuNJebZzMyVStdnYyi24KhNdsxUWqnnk8qPcI=;
        b=jdNFgTNRO5R4R1qLbWyuxPA6skWLZ66Gy1OVoLhxmxcfJltGc3yrlUyuPrW96jLV81
         dXkv6Xva6g6nUZw6LRMWUH7RqZJGaePPrWhcsKgINKYAcy7Bta73QGPIBt90QEdVreV2
         mfXX/Y5ZuDuQeI/uj9jIR8+lNE3qKdysiRurZlyXk1/jwJB4wEEgDLcohnE1hX0AENoF
         CFz2dU9WSCbhicd4kxZQFk/9e69tAoXWwIFKQS2wJRzXO1hjIrfSz4g4K473/1C7cG+5
         J8R6i+WTH9TwP0nwDl9Y4NgTw2kctYkfIPrsO/W8mT14Tm2y/zTYC/HukZeVyMHN28qc
         Oa4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786472768; x=1787077568;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sPHOJuQuNJebZzMyVStdnYyi24KhNdsxUWqnnk8qPcI=;
        b=XnZMEMUhd4fmWdv5zLTc78NraR1n012U7ZLAk87zUafwgXoYP/jTGVa0ktWH0R3YEm
         XFVy+g2FYWp2ewAlXtIYrSA6ld3Z1w4qvm2Z3wMoAJiBA5fLonNk8+fTAo+iddYgbzWS
         tDPuGS+0l+io/Uj5QQZyUW/ea/VvCYhx4tozHIbzNuRJdyrRhs5aMMUEbq4P8EjgV1uJ
         nnDvplFRX/wk6FLnKqG02ENx/tFPYwjtkJZnQkfMaFSs8NTQS0v7MEiFv6uqlyJnNoOQ
         xKxmdRmjZpbLzYqut3x8SxbcgJ4heHMgT5yLbzVz1QTOAsD8nG2AJdvM8b09gq7wjbmi
         Dq5A==
X-Forwarded-Encrypted: i=1; AHgh+RrfU5XTgawkyVwOl8YGyTI7WKuOAGDKa4mPAAv10BFOhd9b+fELeJ5fq9TgiAUcvXuMDCY+GP6E2g==@kvack.org
X-Gm-Message-State: AOJu0YxzhNJsV/eO9xXCJb06udQ94syD3sm3w8IHi7gEJLf/7dHCq/1M
	T7uWbg+HlQsTSQvfDoIBWVZhsy3dZWH3qLygY8PaDpvYHSd0HrZdvhBiWJbNJRQfiS/ZKWfBVdg
	vphUqCaK4YeUP6GkjDxB6EEe1pMkmvuGRb+oV9CDbRuC59xoK+f4AfbcNCZC8sA==
X-Gm-Gg: AR+sD11/OrwtOSx8oQvYEjMrfwhSPcsPj7NcYVQyZjcA3GovXuY5Uq1Ugv5oFW8QyPd
	rObLxkSDMieHHVJxYaqzGAXl0VlkuCHZ87jmQTJdVz0t8U85GQP4YGr4h9WnDIRz9KYsNSwP1Kj
	sPkfRPpfhKTx6q/caahRw6r2zCJC2secE1PCGclSTt8AF07UCQLzs6ecv+dBh8NUfEgOSRSPoHo
	vcEihBFVrEUfN3VQbmGe6jrZYFXWmv5h9gehY0tVDh1bXoRpcM++Q6+NnwjdLO4z6n0dXXRPcdj
	GC2EEBuPuf2CQVxrl/KnIuUuz2QcwgrGrRSVsYXDKzF2lDybLOTbCPY2HwW1ne03da4DTXCiiJK
	j/+P5HP8HpjsEow==
X-Received: by 2002:a05:6512:a85:b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b44d145993mr25332e87.5.1786472768062; Tue, 11 Aug 2026
 11:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com> <anRRLwa3N5bVCHET@lucifer>
 <9adb6304-a25e-4658-8fc7-e3a16c7d34f0@kernel.org>
In-Reply-To: <9adb6304-a25e-4658-8fc7-e3a16c7d34f0@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 11 Aug 2026 11:25:56 -0700
X-Gm-Features: AUfX_myvCY6RcXQrquX3SEZEBp613HzCO0QoVm1i0_JwQgtHN2drwpNgY_mw-u0
Message-ID: <CAJDx_riyetLWXjsygnkFJAbzAPe0NCTN0x019phG4XVLLz0bEA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 28220100005
X-Stat-Signature: 8q1dm3skgokh9afhtgmuhwcg1zs9icgx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786472769-626402
X-HE-Meta: U2FsdGVkX1/arZ9pQW3Qez6q6mhq78ClcZg18Ho35VGfm/SDvJupRHJU7b+Zi6kuIJ30s6xOJTilGUYT2iWY8PmQEduy6yhuy00Dfwx2paAt9CYeS6Kv77W1bsJ7MiMo10f4VhjGj5oTEpmuqLLL5X6dg973gDIjjYj4CsWFOdR7lkJMctpZOjtTO4Vib05J5gRa/sgxZv2NFCAZByjBPftlw/7b3BwBfh51bVlAlh5MFer35fGefHDN/BxboIEUamkn8m3yRXj9oKWpba4NBwX+jhIQ5NbGjw2F9sJ6qnK8UJq/2MTgpU0hInbN84Pbs1oih5BYUrHHL66SrLhSSyyuqh8E9xqp1z8JzcWNiLPmgLRwjjObNOVv4FyMAIyowV+Z5LxCC17sBb/QoaTzg4kfl98hrv/6M7YJlBeIpdvdzdjIx+NCYAHXiqvr7dT5J9FpSTR7nbZVB91NJWoBvbZ2hYpt8hy89iuGxcQQtSoFqD8d9iakM3NVNm5YONb0wLcOIuUOpdfE6DU2dwSwVhQQQ/OOnDDyG/QSMn2sH9kPffQXTwXGqgGLSDMStBnD6djJLjV1J/11ldSV7BIbB2KQplsulYMXnokgza3gYP+D66BInUhGWYnquq3IhYi8Op3aFZDqLdFH8YGZrbKuDO4b8HitXle/f7e8oDVaHNytuwdPO2tMf1+98xOhRCaHm0nXu0cEzQ4pQGKQCZC+OyQpZrbX6eaqeTlyFaXuFNvBRkBTnxuGQUAqxWv8CDY9vfZN90I8GrIvh/rOQYzR0PIc62yYEezoQm9g//x6Iq5OJ1plucNvxBSc2sAiurvBSimuigfx9sAy2zhfLQzIJI4dBMxgK8agiO5ChJeS2wJZbW/LyxPpVxDrjA0iThEex/M6Fa5rzm+aRTsUHRkEHZdR6tlfDOyKapiTZU66o1Uz5qzJhdXh/3EMjw2d/1XKZvUn770NbfDXgqZcmHN
 ObVNrBnq
 b7bqpEPQJOam/EgdsJiC8+VY9CxkTl0xEeYKmk6MR6aNViIwK6A3C63BY4uNvbfXOYABWCf6TN6BFNdFzbtSNJblSxa6ZzRyaY0DHz1U4vOz8JIjU0Z9am9jRfaZcIL418qtN/ZtowX6+LgtIVUmsTM1Po+VZfrMKIcFsimKW0hOkM3ewOoevilhjILDiG+qh1cKhWQB8msdVmIoR1MA/8sE5wAGmPZT+Qa09WdOQoHNsJEfCUWJsSjwyg8LwsyluQOj4uRC3feazkPQ/SCCSuN4ZXCm7HSWWrKDXb3sIMEfOlLUn7SSDvnlekMLP/tq9aspljWBtJxI05Z+HWJb4IPB2Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 4:17=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 8/6/26 11:48, Lorenzo Stoakes (ARM) wrote:
> > Hi Juan,
> >
> > While I think there's possibly value in people not re-implemented their=
 own
> > allocation injector, I don't think there's value in having this be part=
 of
> > core-mm.
> >
> > I really don't want this to form part of any contract or to be blessed =
in
> > any way by core mm as it exposes internal implementation details and I
> > really want to avoid adding extra maintainer workload here.
> >
> > I'd suggest keeping it as an out-of-tree module as David proposed
> > previously ([0]).
> >
> > Alternatively, keeping it as part of tooling (e.g. in tools/testing) co=
uld
> > also work.
> Yes, I would prefer if all MM-related testing modules actually go somewhe=
re in
> tools/testing.
>

Thanks David, apologies for the delay.

>
> I commented on that recently when finding some of them in lib (and we als=
o have
> another GUP one at least in mm). Stuff that doesn't ultimately need to be=
 there
> should just be somewhere else.
>

I think that works too, if this module is useful for kernel
developers, we could place it
in tools/testing.

Thanks
Juan

> --
> Cheers,
>
> David

