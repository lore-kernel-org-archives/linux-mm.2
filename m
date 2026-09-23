Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C749FC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA89F6B0099; Wed, 23 Sep 2026 03:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59776B009B; Wed, 23 Sep 2026 03:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47E36B009D; Wed, 23 Sep 2026 03:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4016B0099
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:11:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CECBC1606FE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:11:09 +0000 (UTC)
X-FDA: 85244155458.14.03EDF15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C926440008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:11:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4K7mJVk;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tftRg/27iV6vOu9wnOe9xdmjMcB/et17gUJyLajCKAk=;
	b=4MsMnehltvGyuyvMAVuve/9wwy/30oFa3TFUJQhcQjduLe8sJhOqK4UFoE9nGBkmHT6dY/
	8ZFWn95x2brp43SVvtkUuVdyCRsqJrcKxvf+DC2RCQa0DDUOnnBuNfY6oWc8d6vnJrabKv
	7rSWD5mM78dK4UJdrKq64/ElleugUqM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4K7mJVk;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147467;
	b=DE4eZppV+EkM4haY+JyXBNZC7O55ZICSsYEY818PMuHy7W50Np78wcw3Au6exHY7PzbKRh
	wjQ/LdDTWrM3k3Bq3FCYcuPMoryJMFOaUV/a0SNbfpJZrG0vSMevVSjgSF3zpNBAyjpRnm
	Ss4wswG+ZsoHye24kr+AReEbHGfg5FU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 062D9447E0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D203F1F00904
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147466;
	bh=tftRg/27iV6vOu9wnOe9xdmjMcB/et17gUJyLajCKAk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e4K7mJVkpkC1fa5WHn0jgNxeZgLiKbJ0V2NjaEG3qzCK5AyydHhTDbey8BS+/L11W
	 /2S046vecEhv/E5OwuYr37Y8lSMs1597S2iq3IQ/oI552uwUefIem5Tr61+VzhHBXX
	 CGbk5246ul8BR45uuZbPESGnbhx5cvZyFhIxpkywKDMvmuPBL6D4EkTQis96rJbyyx
	 5aSM/icXeu7OwogW83YvJZe8jwGUcbuikeJ2plZxXoZOXUQ5bEqOXFwVeKuYokn2TJ
	 LeRsbHsveLPQ1mfeIzgbE+giOj2h3y2bKpY9AQ8uLJdHaWgr5boSw5IMiA183DqQyY
	 3y1PR8hT30oxw==
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895eaf306cfso7766687b3.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:11:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByCW9nwPB8XKpf4PsUPDD+JyFoNi0DIbNGqEfhJChhwZFS2Ia/b+sRHWV5S3oDskY8joH+tXIvbOw==@kvack.org
X-Gm-Message-State: AFuF++mcB211pK/XMq6bLvdLPfPBdI7ubvJ+VHOkDhomTqjXJ2IDO8Gb
	+MlQUS7HcLbO/GSk89bYhEiFLW6Lpq3Pa7uTe5KkB02c0UXrXmcToMiGdE3CURGuYB3KFrElFoV
	z08w5QV6Ve1szNmku2VvA1D5CHF94TRlORsDYgO2B8A==
X-Received: by 2002:a05:690e:b4a:b0:66f:c1be:3186 with SMTP id
 956f58d0204a3-672d59e6f9bmr769388d50.93.1790147466000; Wed, 23 Sep 2026
 00:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F> <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
In-Reply-To: <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:10:53 -1000
X-Gmail-Original-Message-ID: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
X-Gm-Features: AcwNN1UwLMqYNrXn7OTzxPK_RQ9DWuqFMbs5fykDFtZyEsnuAKIyTcjTdWAUOSI
Message-ID: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C926440008
X-Stat-Signature: syjegnifwrqqnho3tj3dtk8hjzkamg7h
X-Rspam-User: 
X-HE-Tag: 1790147467-742246
X-HE-Meta: U2FsdGVkX1/aoYzHwcw/DIdfQotLKU83ODh/+pFpkR2e+cOFKku0lAjNY7h53p5aTPA+b+nsjFgwyGHmPDrvkUNaDAhgLvtc51vnpLPhtcfhz2CgQWPtWM6UNLogJD+DWMcCchqFeDnPYxdEKmftWEjl7pEemWR3gufpeg/cKV29VnxMJex0YqajZ5/xO3WS0+O96IFmb8rUbLxCnF/+UtsHDDLm46XMt2G35xFdtNpUDd1RJz9IptJRSw5SlwpdHQHKd/rqsgVEQuR6XTTMR8028bdcaxg0pKm6tdHh8ytWkMvevjRTZUcInGbOBqa0KA9WD4TTqAeTgjbpezyb6u+LWTyCsxwH0inL2UERcp2OYGMI1H1VaWby1zp4t69E5x/16zOQhZdUOfuo64pK5ahHKnVrtI6gRScL14zeen6YZEHnn4Ybqp2gtsj9FbSPOkFW68Ez4yjrFye6Gik5pLedo/kn06yFXNWUGV7Ntf7+gESBZLVstG89/UT6JQS1j06sd0G/7/Zv/f9aoN62mMWs1huW8hrzjurMMh3XNfShKAZ1g2dcwXKDltTWZGZPgzbGUFiqg4RAfl7afS7O+7TefzZZTQu2x77526yIPRrB3iHBNeRf/783np6IQjkLkdwX9uYXa7ttA3GB71SyE2O9e+nIomORs0oMjxtdYWrURVgEV2juM4uFI8XYiUFxRxCBv+HZIH8gpmx8uFpnducT+Cd8Bupqr503THT/3ZvcW4hcUtQI3hadkHyeX6XcY7zICqKcKNCfYI2RslrDTYr01L6AHUpWFQIw8wWUtFCpd4pMTclrSFRLYcMKHCFAtUBbMb0vP0pk3e5MxPcVr+yjwzzkVrAv7koVYbw9Us9eQUu3Ahk3JjpLnDm3AUPKGWmrfJByevJqHEws+xsajVV2QTVNoWG1aIugoIGaWzG9VpQ+TVFAAvaIQs5zrjah0lQ3On41QdzvlUaygEn
 V8bAaDD8
 wu0hGGouxHPcwfA3Yo2r/WCiMspiTslNFRoyBEHKJaR8nZytRtU2JsPKsR2fo+klQMi3iJa73C+9J3mnAancYgAT/qFZW5O1onUTqTXi1cY5GD5TmeJeM2sBNGurNpL2pWvL7RPFU6eN9q0BdH/SxRifSP4RixMx9Y83xqzDbCy39+/urdnjoO84P2y5Phwj94sc+cJk5nCVR/2C8zkmAaOz/qfXryUzjNgciWp8h/SYg0i91SIux7PDXqUYCD/qJxKYDZ9Rd7Bdqi6ximjHbIXc1a4xIsEx6CD4A6rPFPi06k6w63+e0hwgJwtuarFZuzcEK7NDBXA1LDAp63cFFWyovZ080KqwsHhor1I3zo0kjyWPT10E/e6dq2Cj3nY7r7SOHEvkmjWarINp2hqz9wq88XHXL0wYeQmX0XTXoA9jwlZUGYHXswNQX783/xTV8Jnhq1P16RiwTxvar85V0l+XQNMmRguyni+oLRqCM9U1Ffirogx4CZ+cgOxwerYy6BLRqF3uUcy8pHW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 5:53=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> > >
> > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > Right now it has 64GB of memory.
> > > >
> > > > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> > > >
> > >
> > > Chris you are missing the point
> > >
> > > Zswap:           8812236 kB
> > > Zswapped:       24927876 kB
> >
> > I am well aware of the point. The 7%-10% data I provided is before
> > compression. After compression, the real saving is about 1.5% - 2%.
> >
> Here I'm at 28% without any issues, with room for
> more.

28% is one thing, 100% is a difference beast completely. If you
haven't tried it, don't assume 100% will behave the same as 28%. There
is a point where too much zswap makes the system unusable. It is hard
to pinpoint the exact upper boundary. However, figuring out the upper
bound larger than that exact boundary is not hard at all. I haven't
seen any one can use 100% system RAM sized memory swap out to zswap.
If you have a data point showing what that system with 100% swap to
zswap looks like, please share it.

>
> > You are not listening. The boundary was set due to feedback from the
> > application SLO. Those are real deployments not imaginary usage.
> > Please respect the user.
> >
> Different users need different things.
>
> The kernel needs to be able to accommodate all of them.
>
> The kernel default should accommodate the people who
> are least capable of configuring their systems.
>
> Hyperscalers can set their own defaults across their
> fleets. They know how to adjust settings.

They can use a safe value, e.g., 100% of RAM. Let the people who know
exactly what they want to swap configure the boundary they want.

Chris

