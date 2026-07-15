Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41F4C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3646B0095; Wed, 15 Jul 2026 12:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB106B0096; Wed, 15 Jul 2026 12:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC1C6B0098; Wed, 15 Jul 2026 12:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8DE6B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:27:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B3B414023C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:27:51 +0000 (UTC)
X-FDA: 84991542342.23.5D8DAB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21EBB20007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:27:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV5F5zAk;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784132869;
	b=YRGHiHJvJXDSJ4Q7e12iqpcT7AVPVBPF2nm88RdbPtNkUbRisnJ2wGLClVz8Giw06WOoU/
	2QkNyKcME3nyjsEzoo8rDLoeElTSerwWDDuAOkGfHTqiHesU3dUYqjZm7zlEUtBJDcxlyz
	TRlqr42vFrPiHFfyw6j9X4CBljlSmbI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PV5F5zAk;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFUfoJezdtNwPtX6kuJH95c7aAgswIHEc286AIoPtL8=;
	b=QsNuwoZImSZ2QCi3xyPS43uzJdImnvfKrxdQODwea3pt8YnwXALNIqyejZMe9CPcIS6z7F
	yFhsfA9ZA0VR4gZdXtMf90npg2HWoI3NhtFa1kuczf0DprrQEpMBvVa+4WMx0rESjDCnnN
	qVUvol57bvDo2ZANBfZPgOu5Q8vBBbs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 603A5437B6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441891F01561
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132868;
	bh=zFUfoJezdtNwPtX6kuJH95c7aAgswIHEc286AIoPtL8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PV5F5zAkMbfj7CrAhY1pV9ZxdSs3SU/COCOBAg2Euoi0/+pdi6ZVJyoJPIJABogP4
	 qfEuxWE6pm4OLze2eoyz9OsFIKQ8/gwrqQV0xiWOet5ntwa8gDaYVKKJnzjL/Ym4F1
	 6HH4P9DMJTgGW7XhMfIfK8vDH0ZmLb1bYbwO3MB+rijKyqjpJK44spxhNgElR/JEYO
	 QmDafhG482djMUoskSh39UubmS5LNlvY66b3tSvIZhwuuhYv+dwZoiqmke3cnFN3AN
	 TGiS7Ce0AcWB6f52Nnrl8uBvhwR4+MRbWQqjo4a7FChxk6CSot0Up7S2Vp//PJ3fN6
	 N2Hi+17jHWShQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c029505b389so123823066b.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqe4eYMoPgRr5yDPjEn77JOnJ2is9cmi8kEvYKrjkpzKzqaK0ztNYFVf+aZbbcHkpXhRq/8Y/TkdA==@kvack.org
X-Gm-Message-State: AOJu0YxeDAqYn8UFvoC8wvg9q/c4LUEMIYSesCGAouIxHfSnMGT2otmB
	am5GPWSixhGe6KfwyWXtStZ0AlyIJSNfYN1cXlQJpmsnMO4mSq8E8n1BiI/SZv2Btt0EcVZeswW
	GasCqSb3CNnEib1oNXOEK5jSQ3cmKnkw=
X-Received: by 2002:a17:907:9413:b0:c16:242a:4744 with SMTP id
 a640c23a62f3a-c168bb2d668mr8563166b.17.1784132867098; Wed, 15 Jul 2026
 09:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev> <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
In-Reply-To: <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 15 Jul 2026 09:27:34 -0700
X-Gmail-Original-Message-ID: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
X-Gm-Features: AUfX_mxgWwDmBkwb7rbCNPjuREquEJEs-N8I1JSatubo_uBU_AyX9gUGrWc6_KU
Message-ID: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21EBB20007
X-Stat-Signature: 35pmbxk6cixw9cf8axjwn66pfarxiof4
X-HE-Tag: 1784132868-815345
X-HE-Meta: U2FsdGVkX1/zDYxsih/nBK65rAEoz1iFgHpDCMoXHUPR4GDQ7BVSNh1LPk3goFLh++/XurQX4uynCm4EerRw6amTaldH1QGi/tgiV9nDXETjEOof+Swy3fNkDA9jMv5ZCMz8hXeZ6ZzAsCRd6yAZ8lRmY98WDjcKPAWbvD/Qf2EpMyOLZhM4CdFKkqDJKwHyiIRUtB/jWHCE/gTvmBmSOtMzHL15tDww+E9s4lVyo27+8FvNPh9cwPWP9XL3isavuN8Cv78xMP1BaOoybwMe9kGoIuCm6VWi0wEqW+xDOFc4oNqCHVccI+2KJKvO2Ul61Up65KH0uW2eoIBh/54CNlSF5GhIIUArh+hnTJ1G/1uKoFUrZMUtv2WKdVQJfw6pKhdBYuKfhf0cSrFEwYH5UXs5seBhrV9gAvmPycyOu6g9BCCFsxd9S83WSAbg9fdWBCkkVlM7q05EjxO8N6gy7mvcfgLB7ownfEDrZe0UtgX3f7QrAyAZQUy5QEiAmBeKvbg+siNVdywi1Iqvk8KPXe4bXn9dxa7u71V0klEdWz7PppzM6C1Oqq/jvdn9k3Dmqz6vIvsLkDv9jKo5nBQXImadeuRXM0t9G4s4uiV71LPVqZ2/OFBL+7ZaEq9cVbLLCiOnqMekPtg7JTpVF4qOi+rCaAMLKoN4fKxShtbyZJDoKG84JFT6uPimmmeiHYU7jn4bbY/KtWV/EyoeuixNj+PKvPvsyC1VQ8ojXJM0AMGCMik3z++iSRC6OVLcyeXNkYtXbvQIx79qkPoDLlDNRVhtanjuQ2Qs8hEBRMgJWDf0bc++izM/tWjltjqQSDUVZfR6vBTiW9VZuvkyT1dK9sU75oIRK6PJtErC/kmgT8Yk/fYmL36KYRsmTJWFTDV/Vi5eRVzgby1jNV96HB/Z452nn8G/Yh4qgQAQ98F2h4OA/qPKvome/KBTN1+5owkOWq2qxVW0eSKm6+zBwTD
 Irpgubcx
 ISNP//lqFCV9244NjDsO0JqHLpM6Adqtffp9YuksW80+biI+LjR8FAZawVov+spylBdlO9kM1b98bA3IdENgHW9GBOx2TIH5dw9C9JEwjaKD0K1z+mCBk7VVnTu7kya/yZ9uGcHDk02z1trM8xCfTW8L9ZBMwqqRUaL5frkb6mWbjhXU2HBTxFIAtVIaReszmjKxw53HdWKiSRCxaMo9NGAoN6CvbGVdU1+hc3ZdyTdbBWlHQZVzH05n6lE9FkmoQf2zniBzq+5AtLPfStoNHjtlI66gS8a7F2mct/WDhCm7WMpPwgszdy+HUwHsBRvdLtPdTOtkTIQbqN7o67Qhrq65uktdcmzR4VATeks8S5riWob9QAqR8gMR2FIbb34ln3b8BkEH56nTcbU5kEIfrK+H4QNuRriZjHhaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:58=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > [...]
> > > >
> > > > Yosry, what is needed to enable zswap as a swap tier? What will be =
the minimum
> > > > requirements for that?
> > >
> > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > disabled, nothing happens to the existing swapped out pages in this
> > > tier, but new pages do not get swapped out to it. This is the same
> > > behavior that happens if zswap is disabled at runtime.
> > >
> > > From the tiering perspective, we need to accept "zswap" as a possible
> > > tier, or maybe creating it as a tier by default if zswap is configure=
d
> > > would be better to avoid handling the case where the user doesn't
> > > create a tier for zswap.
> >
> > Default tier if zswap is configured makes sense. Should zswap be treate=
d as
> > having 32767 (or maybe 32768) as priority as it sits infront of all swa=
p
> > devices today? Also whichever swap tier has priority range containing 3=
2767,
> > will have zswap in it.
>
> Maybe we can handle zswap as an internally reserved tier which is always
> preferred over swap devices.
>
> I do not think there is a strong use case for grouping zswap together wit=
h a
> swap device that happens to use the highest priority. Also, using a visib=
le
> priority value for zswap may have a small side effect that one priority v=
alue
> effectively becomes unavailable to users.
>
> That said, if zswap is represented as a tier, I agree that it should be t=
he
> top tier. The exact priority value or whether it is internally reserved s=
hould
> be adjustable when we implement it.

Agreed.

[..]
> I agree this is reasonable. I can treat the demotion/writeback interactio=
n as
> future work and follow up separately.
>
> > Youngjun, what do you think? Is this reasonable amount of additional wo=
rk or do
> > you envision some complexity here?
>
> I sent a note with some thoughts about making zswap a tier. Since Chris a=
lso
> raised concerns around this area, I think it would be better to discuss i=
t a
> bit more and evaluate the details carefully.
>
> At this point, there does not seem to be an immediate use case that requi=
res
> zswap tiering in this series. So my preference is to keep this as future =
work
> for now, and follow up with an RFC after verifying that introducing zswap=
 as a
> tier on top of this patchset does not cause problems.

My main concern is locking ourselves into an implementation without
zswap as a tier. One of the appeals of swap tiering to me, from the
zswap side, is eventually unifying zswap writeback as part of a more
general swap demotion, and unifying zswap controls with more general
swap tier controls.

