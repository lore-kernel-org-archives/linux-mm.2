Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076FEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E726B007B; Tue, 28 Jul 2026 06:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05AC6B0088; Tue, 28 Jul 2026 06:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C706B008A; Tue, 28 Jul 2026 06:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D70A6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:03:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 122551A0334
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:03:39 +0000 (UTC)
X-FDA: 85037748558.15.93B8EA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 41B684000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:03:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCMwd14L;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785233017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Dm8NACStiqwH1pQVtU6/C+ivg0sQ7L2N6PO5I5XBOk=;
	b=hEKX59vE0RLcwiPYR4IUYxUSTWBuHq/EUa0VYVMkC90TB5XPCWMLwCZjNTF1gxCIqwphsa
	pCBesPj0PfQRUzWyTsBtOOB4lqSEs3TKzplR5Wh6+YO0FKLYdln7hQznm6AkTBrRP7AYo2
	hEwJ13RpcYhXc0guM7qRWZG+wmaeKoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCMwd14L;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785233017;
	b=kb0eV0oXaRAGUWawh2mdc0h3HS6Kqf/SqIgTg2/LAKAtjEDJ2tiYgBM9vSmTr0P40cRZ8J
	hPgn8h4JtFX/nD+G2//R0FFfogSVznfF6n7jjffhlkJyoNjVGB/5s+jUmmcevbMY8WS8W8
	sm4KeL6QTnmqml/YO0SltSwKSRCQlPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F50260AAA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DD01F00ADE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785233016;
	bh=9Dm8NACStiqwH1pQVtU6/C+ivg0sQ7L2N6PO5I5XBOk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SCMwd14L1Fk9cJ3DJyfzKeXzuirkV9aptQPyrLKNNXQ1QaLbid5eP2fOM5UrHN0K8
	 Rgvp56mych8JzcTCv7xMJmQ+Y/idyBeuUXmYcaXdwXre2N/wyKO3iYRNGavqj7JzGd
	 KXZnuCftFAFz8FClTE7SS4SxFbYS8/nPQG22kzeV1/WX1BHmJ0pegUwXETKpNGtH9o
	 Ek7Ph5UuyYCiG3/KxZvKJ33cc5xpyaWpr1VpeY9j6MDHGKZiKCWS6bO5EAus9f46Gy
	 N/+wtz03ivgI82gSIOq/J8Ot9f8XI2FM/13LPEp6BH5ZlJhrkAvI6uCosqJrPs+R3o
	 YuJ6o8D1g6s6g==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f18d92172aso45376716d6.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:03:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rps5bDb/Iolc/Uzv9VtJ0+RJqkjrhOnBYBw0B4lPugJ13Yf6iweVj7bYW/Wd8yRB2grEED8W4RQ8g==@kvack.org
X-Gm-Message-State: AOJu0YxSU1jNL+OXgRzxyCZVdB/YmVRTRcUnnTV0VK2FGnChMyWhN5eM
	Ra5h0zSXGsNjcMk1w3vPY8slpRiUkzIxqxdfm+NMVcUjEHdyxMbzPU4ZepJqSoc4x0z44L3xPyf
	SN9Cn6v/UYqtGkzKdQz+aNT/RgG5064Y=
X-Received: by 2002:a05:6214:2428:b0:8ef:4749:b1cd with SMTP id
 6a1803df08f44-908173959a3mr16376526d6.30.1785233015248; Tue, 28 Jul 2026
 03:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev> <amdC_-OvG1ZUjmot@tiehlicka>
 <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com> <amhXvAdmDxX71uxd@tiehlicka>
In-Reply-To: <amhXvAdmDxX71uxd@tiehlicka>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Jul 2026 18:03:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xLPpf82CoS=ZNNP6nZoU+k=69oJFL3-YT9zibop78TnA@mail.gmail.com>
X-Gm-Features: AUfX_myosbGdhrmjnp3dgxInzakBGfy3bPkWOPdmqjI4xEWOKQvkLKYVjveEKNU
Message-ID: <CAGsJ_4xLPpf82CoS=ZNNP6nZoU+k=69oJFL3-YT9zibop78TnA@mail.gmail.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41B684000D
X-Rspam-User: 
X-Stat-Signature: ah4gnbeu4h5563aksnexsha7z7n7516j
X-Rspamd-Server: rspam04
X-HE-Tag: 1785233017-675871
X-HE-Meta: U2FsdGVkX1/YEOomvZD7cteayZzsg80oIxgWkUzHkIyhGzZQi/+3LU+D1vSzw8/7ntLtYifoFTUfGzya35YnnfxoT1UjJxD6Lryh4+ZjscraNPKtfOA/FMVm8MM5RQcDf6MCruaNOWViyyRJBIAnsPuhpqh5mqM/Fb1oP4oLtDCcLGCZlYfW3BhtdBWRfRmDMYMzsDnve3BjQWCZfTEKqQKb+mPPkPLQJn6lZmlMifKHO0vbeTfN3HSK7SLADZ0NUvhV1QKBbHKIuuuGGQgp1rTIwW32/EKYqrQ+ZYROjLMmFhPcldl39BFQO11XanpANSUFSsRKOYfVcLWLy5q/BMeIp+4irg8pJnOckvELsF3fESCrkFmkwAzjv2CAP5XqsbJQpM3OKDotbQKnXdMsq+7bZYPJ6dLA9El2ma0g9VVKkOBSlZHKrNQ7ta+JjBQMlGTcVuj6xaSL1UDnA5STuyzGsE/EKXXtnrqkoDrj0cav4Kgc/9tTHmeP9qGxBYuPUfft5jgXbcJWtR+q4sQsa+0Q2APnxTHLt89Reo9n8zx7hAnJTJBwwQsNlkYK1lcqBNG3BY/MA3Ueya+UGLTd3GLw+KMVb35vrC4uoZG0Us+g7pKO5Vp15MNizW96nO18P+xLrRgG2M5pVXJpC8AMqqbKI+xJGIUbj9VIRcT2cAbMVvi+uBiuix/qEXygZubDYo7LWirhPOzCbmMvPU8H6lpn9a4KIkwrEmm8AoAbB/AzzT7dwEzgv6JEPTzccS7kRBpUmALDTdoeKM/RVt6F+dfoiPfJMiNAzlU3JePvAxmgCsfm4wPq+tOpZ99UKIM1mrqkkp7xu4659u+lqNRKBDZEU5B3swtvTvJ16IUG2p9S3Zt+mv7cCB1DqurCQKp6NbkiVyqfxYwxACWt8NPj6vvz1NhSdWdJ2X1DtNzBzrtSQ80tBBQBW2v4FO6jjGHnaY341kGHq+LZl1L0dM6
 86nbUqGX
 UcCHWAhNUi8+zt2OiD6x5s6/OoKyFCrL2f+Kmia5QeZcQcQgnngonKe2DtVBsuAPXa1lOpMsjfxksaU85WlaYz0zUaFo6p1HMsrVEmtIuZcL2ZDVlsCxCtqkulSbC1i1kVYrRongRU5nvRvqTIlRMo+nLjPlYWXmujcsQuugHXN2/3dsWHdA+6oPZmpuyCa9cniSiGuBQaskCJlqpHGu+JqIg/Q2xda0soy7lymqOXkrDBU72gPp9Z+mjV8p1zOvG/cawj9JML4czKWLYB2f1Nf8OzeepIg0kT6EjDg9/TebbAZeL+SI0m4nOXhgHIMo4jJ1LeUVDJ/xDyJjOBLinSl5wOhL6hlx+7wEuvsdqog1jRKbuILL7fGZasA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 3:18=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
[...]
> > >
> > > Looking at how the code is structured currently doesn't the following
> > > express the intention slightly better?
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 35c3bb15ae96..4fd38e3f1b05 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2503,6 +2503,10 @@ static void get_scan_count(struct lruvec *lruv=
ec, struct scan_control *sc,
> > >
> > >         /* If we have no swap space, do not bother scanning anon foli=
os. */
> > >         if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->no=
de_id, sc)) {
> > > +               if (swappiness =3D=3D SWAPPINESS_ANON_ONLY && sc->pro=
active) {
> > > +                       memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> > > +                       return;
> > > +               }
> > >                 scan_balance =3D SCAN_FILE;
> >
> > The question is whether we should allow falling back to SCAN_FILE
> > when swappiness =3D=3D SWAPPINESS_ANON_ONLY and !sc->proactive, if 201 =
is
> > ever allowed for non-proactive reclaim in the future. I guess not,
> > since SWAPPINESS_ANON_ONLY literally means reclaiming anonymous
> > memory only?
>
> If we follow swappiness=3D=3D0 then yes we should fallback if we are clos=
e
> to system OOM. Now arguably SWAPPINESS_ANON_ONLY is a wierd global

SWAPPINESS_ANON_ONLY with swappiness=3D201 is a rather odd
interface. I suspect it was introduced as a workaround for
MGLRU's swappiness behavior, where swappiness=3D200 can still
result in significant file reclaim (not much different from
swappiness=3D60 or 100), while the active/inactive LRU
reclaims few or no file folios.
So `201` was introduced to prevent MGLRU from reclaiming file
folios by bypassing the file reclaim path?

Qi, please correct me if I'm wrong. :-) If it serves a purpose
beyond this, even for the active/inactive LRU, please let me
know.

I'm working on addressing mglru swappiness issue:
https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/

With my patchset, `swappiness=3D200` under MGLRU reclaims very
few file folios, similar to the active/inactive LRU. If that
works well, I suspect we may be able to drop the special
`201` value in the future.

> policy and it is quite possible this will not be ever allowed. My
> argument was not to prepare the existing code for that. I just meant to
> structure the code in a way that it current assumptions are more
> explicit.

I understand your point. I just find

    if (swappiness =3D=3D SWAPPINESS_ANON_ONLY && sc->proactive)

a bit odd, since `swappiness =3D=3D SWAPPINESS_ANON_ONLY`
already implies `sc->proactive`.

So maybe:

        if (!sc->may_swap || !can_reclaim_anon_pages(memcg,
pgdat->node_id, sc)) {
 +               if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
 +                       WARN_ON_ONCE(!sc->proactive);
 +                       memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
 +                       return;
 +               }

?

Best Regards
Barry

