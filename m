Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889C8C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7296B0092; Thu, 30 Jul 2026 07:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760E86B0093; Thu, 30 Jul 2026 07:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F4F6B0098; Thu, 30 Jul 2026 07:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC316B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:52:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4565A0037
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:52:58 +0000 (UTC)
X-FDA: 85045281636.18.4C76D25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 021DF40013
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:52:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldP3F+jC;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCiqclBM/dmnXYqBx0zgZwAVSukyrsw2g1mawsiDHEE=;
	b=rh/tgneStn818Oq9we32QNeiQ6epgT0eMCl+a4cNRwruMaOmga4Fa7/kAAIVI3aISLcgEo
	7SRcss8Y4Tcpuepaq/g8blHJ5ROv7H1MEY/IiUxRQoYTRgyC+m0bNaudyVjQbSED9mSdpw
	wKV/3OVnybME/uilUFjR3z1RjwcbT+k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldP3F+jC;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412377;
	b=znkFnnFCtxauLFwFDLTcjyHAOxmphJjzamNWrKbPpPvM/h9KbnTKeSxGI22nWdFbQO3PHv
	rKSTwKeEd09ySN7jpBvB3GRX/sZ5RBz0JPzsdGEConSSSinrCKUETWNnqWK/N8LpYIL2Q7
	Nem72uLy751auerQtI/1fP9WrID4bNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BA40600B0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A821F000E9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785412376;
	bh=XCiqclBM/dmnXYqBx0zgZwAVSukyrsw2g1mawsiDHEE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ldP3F+jCDzh1PRmeHJRlXoNt5RV9w2bDrnvG8pR2sMZHgCDlHDIaNHwqbroGSca6m
	 BrKXdHBs3GhLhvoTWYNcBtaM8GXY3YT/6DgD9vEIUT6VkhZz+Ay5NDIxWst6P7Sb1E
	 6aBpNhDzYvyDbfzKFJPR2jpCoZYte+GOTzdnvwDrRqaXzCIBa2/khv8tZK5SQNkm3b
	 3+GTSr7QMzHvfXoJsFOL93T3C4dj1N5+hzvf7fSA79UpnHxRP0pBpk/O1tYA0lt1OO
	 jbXukW7BQVx8SvaulYTBqMGdQ5KmMsEw7P2qxO6Tgg2VNySA1+TzmDWijDc//UJwFL
	 rZneghyihzxOA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e4fd65b2bso112678685a.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:52:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq5Wx0uHgL4f+1+4d2jXI49ZviYQ98ByUdVFq6tcNkbgVz6Wf6F3WAkOE9KMevh03s4v+BHlbJJMg==@kvack.org
X-Gm-Message-State: AOJu0YzptfMKoHhbVInGVOBDJVy5EOhNbo2zj8UPVr3un58XfIiOj0Cc
	ATFReWLSLmGBhDGJ+cFtcUuTWypCDqqTUlfxNjlRbSj4E8QeOCigPTT7T60cO97PZMzwFII9rgP
	eD/dbEhfpTDHMgJLF/LD8UMBVmUdrUBI=
X-Received: by 2002:a05:620a:483:b0:92e:64a8:2319 with SMTP id
 af79cd13be357-934861538admr149683285a.57.1785412375401; Thu, 30 Jul 2026
 04:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
 <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
 <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
 <CAGWkznFCzz=ow2eDyzQR6UsAkLvuamEYpyc4PXJXXd6rF4HHcg@mail.gmail.com>
 <CAGsJ_4znO0fPzNBH-CMakf5hcTFyh6exBTEhMZ1TRmn6283rOA@mail.gmail.com> <CAGWkznHS+j=NQkTjMbEcU-8oS94r2JOgxjGm269+YCj0ye6o8A@mail.gmail.com>
In-Reply-To: <CAGWkznHS+j=NQkTjMbEcU-8oS94r2JOgxjGm269+YCj0ye6o8A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 19:52:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3TviHRDvC7ZKT=WbkdLpymW0Avks7z7qCKaL9Wc4RfQ@mail.gmail.com>
X-Gm-Features: AUfX_myrPqlGBivLcGKjsvjbQhDvUGp_iUPfc3SVoTizhu_VhnV_iK4Q_ArKqsc
Message-ID: <CAGsJ_4x3TviHRDvC7ZKT=WbkdLpymW0Avks7z7qCKaL9Wc4RfQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 021DF40013
X-Stat-Signature: n653b1h9ka1jpiet4nq1ecj9ry5cjjzf
X-HE-Tag: 1785412376-557496
X-HE-Meta: U2FsdGVkX19pd5fGgTwKXm4F79jxIX1WzqGQ3aoEMJTQ5W7GghAAjH0w+ILP0nDUeGVArb5uu602+b4T1UA5SlDPeUiIhUSJW0DdnnN+8LmZgU07+sOgSYqez4AOZtvy+kNKZZAkWNLJR5qSp71U9YnNhVrCl6tTeBCpq/Cil3zQJ+ZqDOfAUWDf5YJKbP5Pk8/xNXtj1N86CKB7Fw5QY9/CGKAIRgt1tlH02ozdjqr8j1UBQBIJj3V1Qh0UR0mMAJJGA0l2w3L44FAYw5wVSvvH5LDSZnaEsZwa0TAtMOAC0Iu2+G4g0eDXoQE4FTBzJGowA0LejeP3QIVvkh/bJ/goC8j+OD4jwj6uDc+hGlaUh8j9yiBoQElrEVD95V1r7J9gZvuFYX9pmI3/ymWHIqzkm2rhP8E4kRvVCdA4kZXatpbfZL9HyRXv+qRQEeWQciXUyhx1EFnED7cGe6CV5uuY0G4OGhZF7jqunyqdKtCzwU9Y9O+BisT6GIT4REOAKfLCaFuMU2ekAA7lYyFydvNUBt0cXcmt1zB+qfNaVWdXsNyGrg8WTYbCZmeQPrtvvNYEZg3bgboUxWq1ptRpg4CuL7qpFFshPNvSi5dPMoy57U0Df2WnyGf0sPOWtjflrDjUgKDxqnIleb1oC/VxMV6YSdKFK6LbDTlah/Pw5h9C3Q+UsfGTKYLytBDAQRPorisnyGcgkH5HRwAmML8pJMrDtFzSg81X0W/Pa1MbWxLbXM6mH8vm6S6KlFCZhg0r+IO6NEZFpSgzIZkwE6/I/WrNj2qTVSLRh9e40cr6o+ryPT/iEa63xTOkkLG7E3i+HNoiUSsviGmOcnkxL3fkIi0rlQC75MnfBDhc6zC8WXF5PV1ajHyDqqO8rbxQcmcxzACoMNKOCq6sbZef2zwL2eU8lB4O5TtoB1Vo4Nmipb2Wd6b33cnCszXlC046tEluyazEkaEjB33JPR6oO2k
 vcKuA/JU
 B5jaOi/22HGCYxtTmXnk2YIjd76l/2YIfO8cnPXWDp9wT07XPjvalNeFt3F1JzkQWBB12f1Jigu8gZAnv2+UjqxmVXBitsCOD7j76b93OrfVH+m31yxN8Y/JJ6qeJHdRKGcWHVI26qLvqelwFiljmTya4x5MlunAo71/81z7u7nlaK2pG/wsyVtvzyyuq1AfbonRVu6MGIvxO3KH++Ea3Q6oBeSloNnLKxQCNYn/PMwbYVjV610MJn/wl/lLe6wPl0KFFlTeqBkv2SJ7e8X68RhVrrdyr1/Sd/1aw1Ogl1t15oNm+3PshMsTirQE/zKrC0ovU7FSa68AoglkAq24QpJIEnwGIouP7wKqPUBzOBFuhv30UBcI0aq7cCufnJlRXxoKn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 7:22=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
>
> On Thu, Jul 30, 2026 at 5:41=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Thu, Jul 30, 2026 at 5:35=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@g=
mail.com> wrote:
> > >
> > > On Thu, Jul 30, 2026 at 5:31=E2=80=AFPM Barry Song <baohua@kernel.org=
> wrote:
> > > >
> > > > On Thu, Jul 30, 2026 at 5:20=E2=80=AFPM Zhaoyang Huang <huangzhaoya=
ng@gmail.com> wrote:
> > > > [...]
> > > > > >
> > > > > > This is very weird. This seems like using a sledgehammer to kil=
l a fly :-)
> > > > > >
> > > > > > Do you mean that isolate_folio() fails, the folio is put back
> > > > > > into the oldest generation, and the next time it is scanned, it
> > > > > > still fails to be isolated? As a result, scan_folios() makes
> > > > > > no progress at all?
> > > > > > And is it because the oldest generation contains only this
> > > > > > folio, leaving no other folios for scan_folios() to scan?
> > > > > >
> > > > > > Why can't you simply promote the folio?
> > > > > > Do you know why isolate_folio() keeps failing? I suspect it's
> > > > > > because folio_try_get(folio) fails repeatedly?
> > > > > Yes. As described in commit message, the orphan folio is an abnor=
mal
> > > > > one as it is on page cache but has folio->refcount=3D0 which make=
s it
> > > > > isolated and putback to lru forever and finally be the only one i=
n
> > > > > min_seq. IMO, MGLRU should keep make progress with bringing this
> > > > > orphan folio together with.
> > > > > >
> > > >
> > > > Why is a folio with folio->refcount =3D=3D 0 still in the page
> > > > cache? Can this be fixed at the source instead?
> > > Yes, it is a bug and should be fixed. But I think it should not affec=
t
> > > LRU in this way while the legacy LRU could move forward in the same
> > > scenario.
> >
> > Yes. But, if there is a real problem, a folio could always fail in
> > isolate_folio(), or keep failing for a long time before it can
> > finally be isolated successfully.
> >
> > I agree that we could apply a similar approach, for example,
> > promoting the folio to the second-oldest generation instead.
> >
> > However, if this problem doesn't actually exist, it seems we're
> > trying to fix something that isn't a real issue.
> It is a real issue that some android vendors run across recently in
> v6.18 under truncate and fs's gc test case. Some vendors even switch
> back to legacy LRU partly because of this issue.

I understand your point. However, the underlying issue still exists:
a page cache folio with a zero refcount is not a valid state and
should be fixed directly.
We should address the root cause instead of working around the issue
here. The workaround also adds too much complexity.
The active/inactive LRU has
shrink_active_list() to ensure that the inactive list does not become
too small, which happens to avoid this problem. MGLRU does not have
such a mechanism, but this is not a problem of MGLRU.

For a workaround in the GKI hook, would it be possible to detect
this situation in should_run_aging() instead?
For example, if there is only one folio and it has a refcount of 0,
and we are already at a high reclaim priority (sc->priority), could
we return true from should_run_aging() in this case?

