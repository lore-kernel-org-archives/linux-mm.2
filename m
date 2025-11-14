Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AADCE8D4A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E7E8E000A; Fri, 14 Nov 2025 10:53:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F65A8E0002; Fri, 14 Nov 2025 10:53:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BA48E000A; Fri, 14 Nov 2025 10:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA7A8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:53:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB805B6A2C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:53:05 +0000 (UTC)
X-FDA: 84109656330.21.60890C7
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 002AA40013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:53:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bwXiSQFy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135584; a=rsa-sha256;
	cv=none;
	b=mMVE5kjzEvg81kMQrtT9y7S6slZm7hLLBGjlT4HBMDqcEoR4faA1bmA1wcZ9xlzvJ9CkMi
	/xKqLEReLqoLZo6rLqyy0gi3gDpjKuTkxqILn3FvqPeJZu3IhX9FOd87IcQxegvkmkz8qN
	qdhrLG6mVgWKcTohxLsvGa/bcgUMbYo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bwXiSQFy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VlPRoWA1WNWSkQNV6PSFUUa4QpcAdRo/Ff/t9LGw90=;
	b=P0TlVbO0iZ+AWmYmSWpETJrouskm2niyi63bw2LovHW16SlwM9BhimbuUoqzRO8XKtbvjX
	mrtt749/GUDqq1PMOl+yW1E8VDnqtasFiAKFqvKTdCZ7an/WZKCa3aFSKi1lRu1vp3QWap
	/6oEuJokp8gccCD3222O3Fdu6LjWUO8=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b735b7326e5so262781266b.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763135582; x=1763740382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VlPRoWA1WNWSkQNV6PSFUUa4QpcAdRo/Ff/t9LGw90=;
        b=bwXiSQFyz4oXt0Tm9eR7a/gkJsK1Dav2Ml4+pcmbE/+k+J95YDqFQ0IrY4Qo1PWIBB
         zmXeyL98zXJyWAq2fvSREr5sSipvsxsS0nSmsBL2UgkT0QkyRO5xKX9BAXz8Aeb8pvR+
         4SsnHXcrIRTcRqJiaF5OjSDVuoqnL5Q8n1Yx11Y2MFRumzNkUQxTAMBWDd8Y/GR7Kgme
         rMa8LhR5SXjJwkmBx31hpl3/R76aJ8O8XuDhLjub1brzw5c385UakN1CLM4C2ZajmdlL
         dWI6NlAxtqyfz8He2DnRZ+G54LK1jIx8D9xqKCbOmMVpAg7JvNyy19T/OtW0ouwnk5lQ
         TpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135582; x=1763740382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/VlPRoWA1WNWSkQNV6PSFUUa4QpcAdRo/Ff/t9LGw90=;
        b=JgHpfyGLmHDl6KnisQm7NVcGu3MiGAC1XoKxW33R8f2PuTyU9vo/CrpAZqmyzmj6yb
         7PvuPi7RXjSrG4olzlMzF/bj8yRqVoN8WiRJvX6miv+MUGCpvzVYE4uqIKuKWM1mdQNz
         +Rvq5+O26VZEtRQC8L0EdM5emgXQfbtsiCyPruDu0KmnJu+hmNWhlPJttrHwEDpW1ZO6
         lDwV9vYjpS4ZuCZuvonOt0UYOlmdbGh+EOUCwGr+Kvu40Zh6SKVfs2VWTxKyS+F1jW35
         kWi4uGHk7WMWI7cvp6MysufXnsij4X12ngedIWjO0xnL9MErvC56wA5a1AUW6ogU50kY
         Uwng==
X-Forwarded-Encrypted: i=1; AJvYcCXWZfjBZ9uYXCo/j/VexBIdodJr1RMvtKq0ruxr1yNX8DGzsyQrkzodf25Q3LvBH8+FlR38yr/7SQ==@kvack.org
X-Gm-Message-State: AOJu0YxwiGNjGtlsisddl4wNrWgpn4/lfYPseygawz7So9LkaU7KqfI8
	8Gzh5vpqVNYZGYwHHFcXjXuh4Km1J+Os6sUZh4W2ytDV4ys3TrB2DveGTn2CxDJPle47VoLpVN9
	xG2uWTyVx1G7Z9kOTXO5mvgttLAR2v84=
X-Gm-Gg: ASbGncs0Nw+62mMYO1858RSu2ohYhshMXh1ja2bSBta+3ctSqudfhBqcVF7ao9PJpJa
	oe65ruNNb04OGnGi/TrwuBFoSVPjSRJ8jURnzeUMw5phNFN1ydjEmHU5d0QQmg91wLyeBNYK6j5
	mTYBnSqVHwYBrCmwhbqGd/Sbe2aeLJsg4N1JIeL3K+LegOvAx8HewWtkrQOE80FamDMCWhV8KzV
	14uV8lRwIqtG5V7gP7wCdS6NUF7oUW6N2nS/sDoiEytDtdpCs8vF/Cz5crpBenGobANTDCKnUtV
	fbT8pJ13IL6vUdfnesvFdg==
X-Google-Smtp-Source: AGHT+IH+RgS5OmU/N9XmPnLjJ8PJCZ14oqdXi+3jpdUfxqJElWrDxu4B4etnV+rhcTnlU8pk1OFJ4Dj5jFS0Uqbawvw=
X-Received: by 2002:a17:907:6d06:b0:b4a:e7c9:84c1 with SMTP id
 a640c23a62f3a-b7365749f00mr442504766b.7.1763135582162; Fri, 14 Nov 2025
 07:53:02 -0800 (PST)
MIME-Version: 1.0
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251109124947.1101520-2-youngjun.park@lge.com> <CAMgjq7AomHkGAtpvEt_ZrGK6fLUkWgg0vDGZ0B570QU_oNwRGA@mail.gmail.com>
 <aRXE0ppned4Kprnz@yjaykim-PowerEdge-T330> <aRaAW5G7NDWDu5/D@MiWiFi-R3L-srv>
In-Reply-To: <aRaAW5G7NDWDu5/D@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Nov 2025 23:52:25 +0800
X-Gm-Features: AWmQ_bmvZlTCVtzzPNeqsxwnox4kcDfBHrvuVSpoFgKS95_ykKsOjuSCZG1n81w
Message-ID: <CAMgjq7D=eULiSQzUo6AQ16DUMtL_EQaRSOXGRhMJrUzakvj5Jg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm, swap: change back to use each swap device's
 percpu cluster
To: Baoquan He <bhe@redhat.com>, YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chrisl@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 002AA40013
X-Rspamd-Server: rspam07
X-Stat-Signature: erw5wcmz85q8qrextaobb9bf5z7crp13
X-Rspam-User: 
X-HE-Tag: 1763135583-91870
X-HE-Meta: U2FsdGVkX18Fnq/NvCxJfJ/mJ++69IWw5BSjH3brqGAJ8smTOnf/7DugkYsDrwKYnvXx/3x/Y5wsX9sPEme9otgF1/FeswqJ1py0dIzOB9tRIuulFcovSp77aAFnLvAgXwLhsMiqfWgjDUBEtb5L3/Nk7PuBIeaG8UHd4kmayi0CgoQSSD2huc6/id2n7nAWxfBtr2QHMblOLocNjssn3E3zp3otZfFqh+dW8fBMchp/qf8JZ/WMr00L6BK2nqRHLQBnqZuZ3nVZVoeF5YoAxPUXCoRBCg6hjbyF0gQlqNhLO66oiODabnVEgAFPvzwza7y6ieMfRRQJiQfYHKL1E6RElRnlwq5AJN6186CSG+AAtEjhxPRKvnpmF0O3tYT2WYcb/UahdLHssfuxuQTqd7pyzD0wHRRLKyTcgivIbLBq29yyQp/KB4MZLHDiLUqIOokwnrTB0kZoo3B2/KRQs6MuMpeDE0QnqLAzxdTP3D0EeL0IJuinUrA8jK2nohzWsHztdpJ7otVH79m0At+rIpDI1Junhk50wPO/AQFB0Osv3FAPdNA+WLHl3YVeLtZ+s6pcRy3kRTKJ5g9e4/vOox9p4MjoQNZdFD/diH3u29nye2E5hbic1aUY6fb89OXEEefWMAMWIzNOCZ9N6Bf3PBvvZTOgRpdOi3jxihTb01A21QsAI600KkFzLdRfEaXOByxh125JGomgCk6F8xIU0PJyrYTWHGLsRqNMFtU3126gntgXJNTwKyvkVZH3wEDV4ghVKeJUYnyrs4a4NjVCbF4d6FmlFDLSz79fkgBQUKXWQDsAsTI8bDqnzQtAWd4rzyiQnmX48W2eu8CAzKAOLuHg1/uZv3eb/jjLV9fbymbJAG+EhI5BrwIrOK7zoMYIFURiZ4/vzrgYbn4T1q4xIG8tOA5YTEsDGxEyp/VA9nqwSqEEhq6djtfrTjk0tBjY1+P04bQhUzYNl0NkRsp
 L8RxOda9
 P/SiGXTKnOp6MOmEcgJKNtpCETZvrUolbrAcj6F14MCXyZ3nEgQdwKdk/6tpnBPqmHn/D74doX9UzbnTR+7yj5UhPfcT1wARcIe/BmFEHGjGzK5fdh8MWOve5S9racfj/thniYa0cYnVljqZVAFdX7i3ixyynJHXywFK0sKOCdwq3ThMW5lxSkgl0E70B7H2lM4yvNhdoacPdKwcGTGrfc4gWwVa10z1ihqiaIPgMFfJ9ZYKt3kUsZGlvgkTBOVlGmbwvi+zHXHI6R4KOhiY+WV9PEoaeeg1uhxEIf07ywhtgRG/azwRE4Wj5pW263Q1kuj5qLTWdJMCaXFZ5Y+/qYpTn5GFswri5fxdg1sysRHBuoJKzIlvIUomvHzzpO7ho4ir1gxFL5kcqVtxRg6P6o9yv7l+P2nV5Pry2nJEXBq05fU+Hn8/BZIWXKm/g6FMInW/ZTxBU2ZiIH2jou2h91D7h914ibI6wYBd+oXKUzD3jbOYMZUThsNk8whFHUqmFX4ap9Od15BgiNvPMpmTbZSZztnJ/DBNJ1xEq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 9:05=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> On 11/13/25 at 08:45pm, YoungJun Park wrote:
> > On Thu, Nov 13, 2025 at 02:07:59PM +0800, Kairui Song wrote:
> > > On Sun, Nov 9, 2025 at 8:54 PM Youngjun Park <youngjun.park@lge.com> =
wrote:
> > > >
> > > > This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> > > > allocation fast path").
> > > >
> > > > Because in the newly introduced swap tiers, the global percpu clust=
er
> > > > will cause two issues:
> > > > 1) it will cause caching oscillation in the same order of different=
 si
> > > >    if two different memcg can only be allowed to access different s=
i and
> > > >    both of them are swapping out.
> > > > 2) It can cause priority inversion on swap devices. Imagine a case =
where
> > > >    there are two memcg, say memcg1 and memcg2. Memcg1 can access si=
 A, B
> > > >    and A is higher priority device. While memcg2 can only access si=
 B.
> > > >    Then memcg 2 could write the global percpu cluster with si B, th=
en
> > > >    memcg1 take si B in fast path even though si A is not exhausted.
> > > >
> > > > Hence in order to support swap tier, revert commit 1b7e90020eb7 to =
use
> > > > each swap device's percpu cluster.
> > > >
> > > > Co-developed-by: Baoquan He <bhe@redhat.com>
> > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > >
> > > Hi Youngjun, Baoquan, Thanks for the work on the percpu cluster thing=
.
> >
> > Hello Kairui,

...

> >
> > Yeah... The rotation rule has indeed changed. I remember the
> > discussion about rotation behavior:
> > https://lore.kernel.org/linux-mm/aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T33=
0/
> >
> > After that discussion, I've been thinking about the rotation.
> > Currently, the requeue happens after every priority list traversal, and=
 this logic
> > is easily affected by changes.
> > The rotation logic change behavior change is not not mentioned somtimes=
.
> > (as you mentioned in commit 1b7e90020eb7).
> >
> > I'd like to share some ideas and hear your thoughts:
> >
> > 1. Getting rid of the same priority requeue rule
> >    - same priority devices get priority - 1 or + 1 after requeue
> >      (more add or remove as needed to handle any overlapping priority a=
ppropriately)
> >
> > 2. Requeue only when a new cluster is allocated
> >    - Instead of requeueing after every priority list traversal, we
> >      requeue only when a cluster is fully used
> >    - This might have some performance impact, but the rotation behavior
> >      would be similar to the existing one (though slightly different du=
e
> >      to synchronization and logic processing changes)
>
> 2) sounds better to me, and the logic and code change is simpler.
>
> Removing requeue may change behaviour. Swap devices of the same priority
> should be round robin to take.

I agree. We definitely need balancing between devices of the same
priority, cluster based rotation seems good enough.

And I'm thinking if we can have a better rotation mechanism? Maybe
plist isn't the best way to do rotation if we want to minimize the
cost of rotation.

