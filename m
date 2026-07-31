Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DBDC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D016B00DB; Fri, 31 Jul 2026 05:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE076B00DD; Fri, 31 Jul 2026 05:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3B86B00DE; Fri, 31 Jul 2026 05:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2B526B00DB
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:02:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CB8780374
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:02:12 +0000 (UTC)
X-FDA: 85048480104.20.C5CFE50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F0F6C0009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:02:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnawAYAi;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH5sgQ2Isj+Bn8CLnRE4QGnPT/KVxtfiKWGupeOprKk=;
	b=ExrmoU7IAB0DTlvcxccPAn5nYq8nyo4+oIiNDWVtTVzED+8yU+FwPC29WyWEPEeEllz5HU
	wAt9wpA1tRIMTZLmelvLQ+oIELndAI8R6596eNUBVOkDFB4hDvIz6549SDF0rQRKphK7lN
	KUvf7PizbiKUZCkW7lLl3X6ZiqN3Zow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnawAYAi;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488530;
	b=cExmzzc1RJKOqKMsztoVUkrIaYgVUM2lWXPqJO2G2seUirZbD1oT1F5m0BiZYah7cCgHLG
	C4GM8pGgccDBD+Dj0YnjLRp4knODLwTf0o8XfjX1nGzuY+GOSW+/jOuZ8yA8X9UZvcvC2Q
	6JKxI55ZiC+UQQ9pd73w8+afBNpCPYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4648600C3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9830B1F00ACF
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488529;
	bh=tH5sgQ2Isj+Bn8CLnRE4QGnPT/KVxtfiKWGupeOprKk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dnawAYAijEE35zyyhF21O/IchOwlMTKZw6qZdSJh9FCx/e3LECRrmzxtLkcIGdHci
	 r1YohYFo0JlbNoqb2lCaM5HiOM+VqFy8Yr+JdrFU2LJhfBzF6Z7GSZO4htyULTxszo
	 EuJoBLm0M2vwwzJBCejnqY2LCq7Y9q+5RPnpeUb4taSRQjzQqqmrlGRN3HhUShzIGA
	 NdWk8sw402U9mRXLCW4MNzriMZi2vUbn5GKbO00ZyJ8yJUQO8keE5wnlrASbjBB9qP
	 seAdh8F3eXf2fxuc+xrcSb/fynwnLwDaMQ392SzAkzI6ARafKFJC9cMl2WstUDsg9z
	 wdY8uVaX7Iw2Q==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e55b62640so37234085a.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:02:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpD6rtQ6kFEYTO83worIcNcX8DHWXmPDU2vG4ybNMQe9Heu1K/jLBfJFuV5WNxkquUMok/gW87dtw==@kvack.org
X-Gm-Message-State: AOJu0YwWFj+g0vTlIT9ZKgHYYLpBYhFJww+AGG21fVRnZ3AkF9B0rVqn
	mX18n8LGyxySV8cmfvmmzvfmXgB7D5XxVBU9GW6iLamcPYkS6mrFHasihRomHIubBkDm6qeXnEe
	N+HKxCjnT40x0/5gPLIkl8YAT0Q6MxSQ=
X-Received: by 2002:a05:620a:c4a:b0:930:b4f9:f327 with SMTP id
 af79cd13be357-934965c949emr136732785a.33.1785488528960; Fri, 31 Jul 2026
 02:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260726122123.7614-1-baohua@kernel.org> <20260726122123.7614-6-baohua@kernel.org>
 <3869ea1a-23e4-4b82-bebc-8cf1ae282fc5@linux.alibaba.com>
In-Reply-To: <3869ea1a-23e4-4b82-bebc-8cf1ae282fc5@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 31 Jul 2026 17:01:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wqd0xnXS7kB+Y-EQWdOE-EuXUnuRrTkbnqRuNaS3naMw@mail.gmail.com>
X-Gm-Features: AUfX_mwUwnM30KOYVRxTO_p55KbjhN509HxB7kXb74QP29zptrf80XSO3630zzw
Message-ID: <CAGsJ_4wqd0xnXS7kB+Y-EQWdOE-EuXUnuRrTkbnqRuNaS3naMw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/5] mm: mglru: run aging if the preferred type has
 no folios in reclaimable gens
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, stevensd@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F0F6C0009
X-Rspamd-Server: rspam01
X-Stat-Signature: riwrn6k174dn4j9jn86x6e9u1b5459qo
X-HE-Tag: 1785488530-946651
X-HE-Meta: U2FsdGVkX1/ECPhcw0CDGD3oBf3Rd8QVtHsj8BGr48iSiuniD8lqaCBckftK9ypTKgfygL2+K+v0NqOR5SRgD53QRm9SkYOQ2mDmlPUlbhOToHh1S1nqFqATsaqf10YTMebbfSg1Hg+28XMdU/xSqL16meICS8voQ/ifjdYTTWOxFDiThm7qU+Dsf9PnOmgCXFzybF+tr/LbBKlNgf0gDgVtv8RJawWG8tf7uhYNlVpeNLzIi21cbP/vEKdPLxZ1gHgnkc97dH3AlLTemGljjtp8dSywzgXTJgvth/SgB/3Aq7YrDDsPn337BoITAO/Gwx7MTmdy8l0yb59DUF2SFJjI6iF3y0z6PbEIjEJL5btCbj7TEpWpsdbLlg8K6HHOuTV0LEuJJTBUOQOeyJipf92J+LEVdPlPWwglGqi57mwNh7soIFgcmFU4wtZjU9V4pDW4LUetAd3i4n8t3Cjs6v2CaRWfHbsz5eBQc63IMl8NQc7GvFejoM2pihzk67p3ZMHMSs6NrwY7z1JoHIMBwEi+A4QOUsmSktN1ZonY/uxxZV1gt4aw00mQ8KPvHNYZnEl4ac6KKodT9OmaPlbqu3UWLCj9FIkrQooyyR1cLTvkUvv5YvdndR/S6LX+FMOnQfpO/y6nhpRAr4meoaeZbKDPiGEQiOzFNGtzI+vR/NnOdguGFsGDbE7wFD+5eRcNJt9w+EcjJZqMLSxaiv7ZAC8z4ppY3FILyRWzz2sTu1EE6w5sp9MSGwN1/faSFWlYgXus+XI6RdGELhp3hRjFfA8CWSH8cD2rD59LYlNzKeZQRE8o+XCXJdsAhhoufHp3PAEf2WnHRpJSVWrIdjpvN0gLICVvtOBHWuYhEkaufJUPcECMPXNLNHU1V+fkF9f1gkTMjAvxbSnSO0qchnq/jxgMV+f7LqjPMS17OUvXbxs8aVSurnAGyPBdUbG5AtRIXEO1i3jIAr+dGXHzw/a
 6hr4s3yF
 eW8WPtgLaDucoVSEQLnM7L0kmnEYgz1n52YREwOe0S4YCpAl6cDN0hSEMN7eun3RZbaU6mCXMpkF9w2ALb3mpcMrQYWTIlH7fo8JWa1kJjiTThL8zbJKLrnXJGOXkIThqLkNTM5yC8381NVkiUZ6jbrMtgzJQHtYQUomEriFM+AOWgi00Z7QDY50HJnWDrrl8CYZk1JVlvLmCIfTGko4Np+LtcEVk+QrzEy+G2j5HFJrhPpufGg8zFlAkTEUPZtwIYhRfblGa28CoLX0Ev0Y1ihaNiGkED2qflKunTx5R4gij//GFR4rIhsYN11GOnY1k5Z8yWAWaX0UMqnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 3:27=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/26/26 8:21 PM, Barry Song (Xiaomi) wrote:
> > Respect the type selected by positive_ctrl_err(). If there are no
> > reclaimable gens left for that type, run aging.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >   mm/vmscan.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7c13dedb0b1f..d63322cdb1bc 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4996,6 +4996,10 @@ static bool should_run_aging(struct lruvec *lruv=
ec, unsigned long max_seq,
> >       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
> >               return true;
> >
> > +     /* run aging if the preferred type is exhausted */
> > +     if (min_seq[type] + MIN_NR_GENS > max_seq)
> > +             return true;
> > +
> >       /* try to avoid aging, do gentle reclaim at the default priority =
*/
> >       if (sc->priority =3D=3D DEF_PRIORITY)
> >               return false;
>
> Looks reasonable to me.

Yes, this is reasonable. However, I also noticed that it can
slightly increase system time at moderate swappiness values
during a kernel build.

At swappiness values near 100, overall performance is more
important than strictly preserving the swappiness bias. To
address this, I refined the behavior for balanced swappiness
in v3:
https://lore.kernel.org/linux-mm/20260731083843.37811-7-baohua@kernel.org/

>
> Additionally, for sc->priority > DEF_PRIORITY, is there the same check
> logic for the scan type?
>
> if (min_seq[type] + MIN_NR_GENS =3D=3D max_seq)
>         return true;

We also have an imbalance check: if there are only three
generations (min_seq[type] + MIN_NR_GENS =3D=3D max_seq) and the
folio distribution is heavily skewed across them, we trigger
aging. This helps preserve the intended swappiness bias:

https://lore.kernel.org/linux-mm/20260731083843.37811-6-baohua@kernel.org/

Thanks
Barry

