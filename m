Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D98CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 04:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C058E000C; Wed, 15 Oct 2025 00:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25588E0005; Wed, 15 Oct 2025 00:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62288E000C; Wed, 15 Oct 2025 00:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4E6C8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:29:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C9A2BD042
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:29:52 +0000 (UTC)
X-FDA: 83999070624.25.DA623C8
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8FC26C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:29:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BQ+P+C4D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760502590; a=rsa-sha256;
	cv=none;
	b=xvf5tyO0pOENa3fExHPZPa+XQHtiB/y5iSCQt3O9FoQuo8IA6z+t9e6rNmIV3FZBsdTPR6
	gD/ObcRO7ZNtRVTaTd1FDbYLO3kQ1QBfdYmnExmfGDxXBNRf+Tm2sEhhN6JfJYTXYiK7d1
	QHYFQMvvo374QYic4ajfY2tVAh9afwo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BQ+P+C4D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760502590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7umbxdKyXD7nTBpBrjHh916Yt8tG8NcUNNJJ+puN24w=;
	b=Bc3bz3M4FUakvxxWHqUh2+cW14qlWpvUi17JVlCgePKut07Aj0P6Wq549e5VF+AuimzcsV
	Tff8xMpJh8OVWV4fAa9MUcsZ+jDU1s6WThS5f0NIbn97ZilMsysEqBCtEdY+awCIT1Hc2u
	SbjFIw+BvoLj9Ub9YMjtiZd0m1/U2Tc=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8582a34639aso470053785a.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760502590; x=1761107390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7umbxdKyXD7nTBpBrjHh916Yt8tG8NcUNNJJ+puN24w=;
        b=BQ+P+C4Da85Pc9HT7fg0kpzWz/CNU/X8jl13p/nHOeFtK0VMbrh8fuCA3vVSWhwHFF
         r6J+N7Ysoa2ije8BG37lfR650QUxFLgJVV2yvEk3Fz7bEibt7vC5dvvjChG5T+nvtjjy
         CS/9nWBcYpC2MZ6Es+h5XryYEZHP9LBc1655LWtT/WpmCgkrTIzzFqBvQtx2G02LPxjW
         bHKf6wmIllmJqcaLcnMiuaRIzSoHUCWy30Uv7enX5rr4+sisNu9w8RKRJKzBmlO4xWpq
         ngCihXkCS0ad8Z/ICVcMVlcQCzK9KAVX8zYTeUlVfu616RX4vkcpWV35sXIDhOWlE34J
         u1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760502590; x=1761107390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7umbxdKyXD7nTBpBrjHh916Yt8tG8NcUNNJJ+puN24w=;
        b=rEhhZwiBSw+czK0LEjhOnBK9QZXPAQBN4kYbJ2ER6vaZnv85eTOKL8Ri4MsrtYOL6j
         SP0CHo1OBvR2Zzw6HwoK7MACu7T09Xc6swU3RiXWMkD+tkBuC+DEXkchoes/QoFyav2D
         HTDSuaqy+MHjYF/dStq3tYUscRi2g+i2RtKl0YuqoigWtqyMYned/TsYIsMkIaOqLEf6
         qL65mCC2lmbWCliZHUIvCtxsJJGbqTOYVdJaORJzAphL2spraxn7mXotiICYg3nxy+5h
         Cwjdj8hWPWtOIt22VMCzVWQ9/5Amj7ZS8BP0vw0W1EkyhNsLVNNMUHfsgPJXQiix3BSX
         xZow==
X-Forwarded-Encrypted: i=1; AJvYcCV5gt48qDwhNzCPVDWESlS4PzeG10uI7XsdZtQK4VYvkBE6EU62TFtpnbbWeYYgF48MHGg/dwD34Q==@kvack.org
X-Gm-Message-State: AOJu0YwiWI8eOxS6EldyQV+VIlH9HBzsyeXMAN7r6vbFLmN9/47QlAmS
	ubLY0RGjcJPppHO2kn+hE2VTRQdnxacHvzRjeNmbeSx2lI5bk41BgzE357VNrjhtRXEqSU7Q1rj
	Q1fla6AODti5Ns+6234NSmcU00d7AwMM=
X-Gm-Gg: ASbGncu1bxNmutCq4eLyR1GE3H9pVEpqJOVQU3TPPpm8y8cuMGzvj1upzS5VAUQ1Oht
	o217z6prDazqeF9ZRsyu65t+inbQO52co7otvNFM9PdcrZXLJTkDl4c2m9UHbde8bN/ugVSNNiF
	+KazyMflt5KoLpGa3Fd93baipwp7BvIj9B2hPj8TiAj+Ud5aMPd8o/CPpREkTvqNpZFx5hpwtNW
	EJpU7nzAZa7zd8Cqfr28feNz2TqNfXPo5LJgqv4/FaJIyYRhfbVXkdPW9TuKJqJ0f4c
X-Google-Smtp-Source: AGHT+IFSd7rR2yhuM6ArM8rTJIOrMBD13K1D0UP+LCqiXo0xNEGlzCRv09AviUeb7DJrScDn+uFmR1UaoQZWnRfwSxs=
X-Received: by 2002:a05:620a:254b:b0:88e:1671:2e4f with SMTP id
 af79cd13be357-88e16712febmr189204685a.78.1760502589399; Tue, 14 Oct 2025
 21:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
 <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv> <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
 <CACePvbVfRCdGaqu4SgB0MnZWUgBRDH7VJxs=XxrLfdqjU4z4Dw@mail.gmail.com>
In-Reply-To: <CACePvbVfRCdGaqu4SgB0MnZWUgBRDH7VJxs=XxrLfdqjU4z4Dw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 12:29:38 +0800
X-Gm-Features: AS18NWBsciOrvSLoH8Oapvy5UJKe0mw0QOMCocN0lLrRyuj-vM8BDufgeKaNehI
Message-ID: <CAGsJ_4zzLYyGDuZbMU2j2nqatjLi1kP_eJ8XA3eA1UqN3JgWvw@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: keyjax6e17e9qinw74bp3aws8mzfqjo4
X-Rspamd-Queue-Id: 8FC26C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760502590-79180
X-HE-Meta: U2FsdGVkX196Mv1zq8NhXfWTG+u8OXRk1tOd+RLbIoZbxNYi9vucmBY6etKK1N1pSg6VXHnL9mxrsGbtjIlCpMGWU9lcJxcjaRNjLn47kb0EfodNPUM/KK10MWd65x5hPrTKdcYflwerqPRXLsJXCpmLymZxyAsjxyorFPZEG85WArkDLgJ5LDt9foNtmgYBAAO/MKEA6wixCAEpnYWRYR3hWuhiTIzyMHZwZ/Z4ILdWcUiOq5BnHeCowB1kQTmQV+h4cmEbpjV0nmjMMTNfAL/h2JnLj8PyJvetGLSnYJO2spDG9EHX+GO2jK19/+AxggXLjzLSsVwBo3wQPlSJGtLRHGl8sQEZFapxmi1xni6yz5LY7uHgDsQOqkzoAh10voV1bzdSznl9PlYZTW8UeDPeFkHTd/Si1LRSvGBiI/rG+KtLfUo9w1ltQC9Q+wPUrfbjd7O56zcQ/Hvl/Ocn6Njv7F+hdQckHejLh3vEHULwBvMSojRcxJIoUPhXXJhJvyrzYn/6bR9+5lEEuxZLY1RAcoOsHAPobKwOdsJm76xDRfo1K1PfbtO7kdQc926qBCSLhxa1yiAK+wGxXhaLV0+Eq+Ifb6eF++KjNKh5fz9FWhtH8/pG+/opnI9y6MBVwUBniGaE1iOhCsDN8FIMOa0fs28K63P12T68g54iyM7NPskRzhp3UYwMOX3j03D34i7jeOsSYEepQlHjbcbSHlWwR3AdonOrRRxFB59Xv3acpu2ZR+1PQNfAyWjtCz5orYLAvxB7pZPtoVXkiv27eHcrsQpgYYDGUG6eZzhypNwveWPM79Gi4mYTJ2ohTPCDl9A96vMJPjWDTtZV/MdORGXzPMjrhWS5Q9u9WNhkE6skOVOxnBq5VSzhik98I7XeXKKkIlld76W4S9drcQzO0zy3w9f5PqGYzRmq+h1s7RBL8g+0NeUMDJKp1J1wC7G1bLCMXvOxsE4ex8w9q2Q
 5GVOvXi5
 5pwK6hr5PwawGP+QUt3MybseTVui2FwlryIzLqGQyQjJ1eqvz9KIH5TzOgIax4KS55A/OVGtWcijAt4xJRvlKVba7tse7Axh0Id8g/ZTs+wLEGFm2vpt/3w9Lnuejyow5P/fdGzWbZX1j1GoWQEGCKyVNN/p3z34cXzeDimM7CW017XaOck8HIMix/fAqagTIbw4meuu+vOl58YTz8ueeVgGLATZcE0N32KSTYug8kajCGwtqZMHn4Nbwx+oMpyYWiG2RuuAG+mlUDF+W7noSvqoxK1ry2jc5K9N3JQhcOgOfzLQ0q80NkAP/hdsS7v8ut6J4/2G579xuJdq53C5HSuxRTWD1cQsxfulRAPvRez8Y2QCSUhkhfk0dnOt5pTYoiTFRvnyb4ACoC2DuFrcrgVNTAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 6:49=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Sun, Oct 12, 2025 at 11:17=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > However, after commit a2468cc9bfdf applied, above behaviour had been
> > > changed. I can give an extreme example, imagine on a system with one
> > > NUMA Node, node_id is 0. Then I swapon several swap devices w/o node_=
id
> > > value (namely node_id is -1), at last I swapon one device with node_i=
d
> > > 0. You can see the last one will have the highest priority to be chos=
en,
> > > then other swap devices.
> >
> > I assume this adds logic to prefer swapping to the closer swapfile firs=
t,
> > while still maintaining the old behavior for non-NUMA cases.
>
> That commit a2468cc9bfdf changes the default behavior of the swapon
> which does not specify a priority.
> If you claim the revert breaks the user behavior, that commit also
> breaks the user behavior as well.
>
> > > So I would argue that if people realy care about the default priority=
,
> > > it has been broken since 2017 when commit a2468cc9bfdf was introduce,
> > > and complaint would be heard since long before. While we didn't hear
> > > complaint, means the default priority doesn't really matter?
> > > >
> > > > Or if someone sets up Linux assuming that a newer swap file will on=
ly be
> > > > used after the older one is full, then this change would break thos=
e cases?
> > >
> > > Hmm, it could happen, but I doubt people really count on that. I woul=
d use
> > > 'swapon -p xx' to specify explicit priority to make sure it. In the c=
ase you
> > > said, swapped out pages will be swapped in, it's either not guarantee=
d.
> >
> > Personally, I also dislike the behavior where a newer swap file
> > automatically gets a lower priority than an older one. However, since
> > we have a rule to never break userspace, is this considered such a
> > case? Or at least, do we need to update the man page as well?
>
> See above, we should update the man page as well.
>
> If the a2468cc9bfdf can break user default swapon behavior by
> introducing node_id in the first place. It is totally justifiable to
> break it again to revert it. I fail to see the logic why the breaking
> rule only applies to the revert but not the commit introducing it in
> the first place.

I=E2=80=99m actually referring to the part below, which changes the default=
 priority
to -1 for all swapfiles while it used to be -n, -n -1, -n -2 , -n -3....

-       if (prio >=3D 0)
-               si->prio =3D prio;
-       else
-               si->prio =3D --least_priority;

I agree the NUMA-ID swap patch (a2468cc9bfdf) has partially broken the man
page, but only for very rare hardware whose block device has a NUMA node ID
(yes, the man page should have been updated back then). Now we=E2=80=99re b=
reaking
the man page for all hardware, so I think it=E2=80=99s even more important =
to
highlight that in the man page at this point.

Thanks
Barry

