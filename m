Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7758E606A889
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j5xXhGcP
Received: by kanga.kvack.org (Postfix)
	id 8D1CC6B05B0; Thu, 12 Nov 2026 03:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8F56B05B3; Thu, 12 Nov 2026 03:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E69A6B05B4; Thu, 12 Nov 2026 03:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEB26B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:50:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C3521C3219
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:50:51 +0000 (UTC)
X-FDA: 85425846702.01.27CC064
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 850AE140009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:50:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j5xXhGcP;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgmgKd/DyKlf9Jtf2sOIeUuR+eT0nZJ9AmuIRwu4FJg=;
	b=gjZt8mmQK6qCAs0RmHmzrlDMFBKpAsUonRi8ovzpQpFPziQEDKRftrQYPelnysAVpscrYu
	a0yPSEcKfvk0ZtLMWMgFA+3gpgoLXyPIhPJtJDLSYSt9tbtI5BOuwCM6bAdEiE1ltFjGMH
	h4HbcpSB3yXAj9XliHosHUyu4sxCnBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473449;
	b=1Dhovh0zOxjIPF4pxHGn6FrnEmGTEysjQwzsSyTzq8dNQOYNAkwxNM+arUUm/rfLCGYsfZ
	UJh8iEceWR7b3FwHuBgMFNGcW46O9aZgqFi9IZRSHbbpjtPGGfiboAYYPE0FOjkDkecUHG
	/2GUJPvhnVP1yX+b0EANMxi8lN4WIbM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j5xXhGcP;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A08663E32
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A3D1F00A0B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473448;
	bh=TgmgKd/DyKlf9Jtf2sOIeUuR+eT0nZJ9AmuIRwu4FJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j5xXhGcPvIioCturQTJcBFChT91tq0mZ8srQmggLxlI14nbEL5pCIMk4nbjJoxVco
	 iZde+72CtGI1BY8Rr1NcspVQJqB7/msEossP2/KK8qFeZ49EQoOfkVwcDFBcblXJIz
	 /u0he6NfCx8xsZ3qzKFEEWU9PEoHCTwAmHstCMup3SeF+6+I+UfbzeQzifnNK/hcsy
	 Oz0P4d9K3xYKm+eDR5IY++/2x7ycbsOe8Vz1052nYjdYuuYtAstqpOFoGtVq1Jdzaj
	 hK7wASCRmbR5One4EkZsxpVs0jVCsisFYqQOl2iHaNGt38l+8wDEGxCVk26Z84cEov
	 r/gUqJXQ68FVA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9441591aa5cso71005185a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:50:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEr2Zeq8eg/BJVR8ASdYb7ZNivdR5Z3ZiVzx+ERj3I7aYISF5YSWq6RUV32X2ea9kVgTGqSUIDVtw==@kvack.org
X-Gm-Message-State: APuU4Z9pPtgXLIrznnvWGdnIaxphAbDOWT0fSooMdTkHhqUZx3/a84Ex
	4BOQNwLf/nbDm33eG5+7AGJCsPO2001OpJQWWVB8Gehn2yCThfn/lNevL9KMR+Eec7q90BjHkgs
	0aLSyDcELgKtWyfycPl9Kao1iWvQoQJY=
X-Received: by 2002:a05:620a:2a01:b0:93f:231:9ff with SMTP id
 af79cd13be357-949330d5136mr338513285a.27.1794473447348; Thu, 12 Nov 2026
 00:50:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
 <avV52J2rD19cjM2J@KASONG-MC4> <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
 <CAMgjq7Disoabm_4yyp60=AdaEH1RWfUpawc8vckV2e6c7g2RmA@mail.gmail.com>
In-Reply-To: <CAMgjq7Disoabm_4yyp60=AdaEH1RWfUpawc8vckV2e6c7g2RmA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 16:50:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z85u66MuK1ior30sQG4FjyAsZTwO+DCuLpD_DoXgRGtQ@mail.gmail.com>
X-Gm-Features: AclHuK_JbBbTc7uJJnjqDd7xtYHR6W7Z1uxUQ58zOfeU92Ldv0UBDEv_UNuetu8
Message-ID: <CAGsJ_4z85u66MuK1ior30sQG4FjyAsZTwO+DCuLpD_DoXgRGtQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
To: Kairui Song <ryncsn@gmail.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ythdz9es59p4qxz7nhwspoktim1ojaj9
X-Rspamd-Queue-Id: 850AE140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794473449-756854
X-HE-Meta: U2FsdGVkX1/3XBGdtW2qzK6HaX5yf+ieTJxMeCBxmiHcF8X15CbILA0QDqyJh/GIlTCq6CmZsqTKq8kh4FhCT4zhc+slNOPSig0SgBbFyCwl/iymoxCMMprQ2G9jC8kn6nrs4ZC0MLuUg0BQKurlzzSCbnlJ0Pf0bwdlAWeHs0Oe01bbcgKsfTMKev4tJZBzYGgdm5hwVAo6cEu3KI6mKb0PvLxB8vN92jT8za1ft+KLRM4nT+c+2oWp6LG3sFexYHX0DGYc0yjP/epreX2t1rsyK8AnMHw9pPUv3TD+XJYFp4OVjRgKaRZiFTwkoHF2EpmPpkYHkx9wI+26yHZCGb9Uw1GoVigemC/e//5x2k33jf6+cNTQNcMesI2tzcojmzYaTZWxPJO5ezShpw+PgqaQ3onfPrTJZe3M51brGmkl5rPMzRfecVPBG2oSY5uuCQ5M6LMcu/e7lit7AnYA04AAkOKKYLN91o65p1WmEoYzUUajdtCv/QBe0QPBq6BzOiSOX0WyUJLW6t5+KcdiQ2zPbMRkPN4lEHur5JijJkARIkNbWJNCohJ/2GpD0jSopD6QOCL7nleasqIE/UqoOcDkYlzUm0c3QC6ibqado7C93mWYNsKuj4Jk1ON9Yp4anI6vh4r2FGBH5MIG8IaYOqCLBg30htB7YVlDWc2Saa0UfF4IW2n4ATk5MV8wwx3o83Ue2F7aBKs79FV69pOk9mXkfe2TCrCQZGR5tCXM7L1puSl+uT6BqcvMEon0G+GPnbM/chBADUseBC1UknoP1fNuIEYFSE6xdzhEl87h98jvsONscvaLYenNEtk8xQZOvwTXznF0pfgFNXeFoS3jgziD9LDi12LzlUdIv+fnaaJGPcdyvy3g3y8YdjeRDgaoUw+oViUlKkiQMMVeQWZX2adv/ucZexOAojdKJQ9ZQ16l0vxFptF0Q+vFupwv4k/eTPbkIhwlhgb+9B6TCrY
 ZZbP7fPV
 PH3i43atxJ7RqZ7yLr3Ncm8QrTDFAsZr7ScvR30FQdqF79+O8BDDTTdaVgind0+ZmhxVpgsbQi33UQjvPzXNTJkpbJtZLu8yWy5muVySCORolKbtgrZdR47Dj/U7nV8LUCmDW6Mjl3rwxSz+RDBq/pC12oanGpFwSQwZPGy0CjjMXuK77Byw9Ba2MWLaVhKDuDX0Dnbby2cKJ0DSeveOeLq27xXC6CHBTmNSo0m/pugH841JsS2EDPaFF7HHYqcArGlaC1MaHhv+k89cd6AiYKKr2zv+CUofheF43vpPrguBrETvic1rwFBLC6ns8WindvjBCTZxhB40ZKuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:47=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Nov 12, 2026 at 4:42=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Thu, Nov 12, 2026 at 4:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > [...]
> > > >  mm/folio.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/folio.c b/mm/folio.c
> > > > index ea3adb6a89d7..c412d9b398e4 100644
> > > > --- a/mm/folio.c
> > > > +++ b/mm/folio.c
> > > > @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruv=
ec, struct folio *folio)
> > > >       lruvec_del_folio(lruvec, folio);
> > > >       folio_clear_active(folio);
> > > >       folio_clear_referenced(folio);
> > > > -     lruvec_add_folio(lruvec, folio);
> > > > +     /*
> > > > +      * For MGLRU, lruvec_add_folio() places anon folios that are =
not in
> > > > +      * the swap cache into the second youngest generation, which =
is an
> > > > +      * active one. Add the folio to the oldest generation instead=
, like
> > > > +      * lru_deactivate_file() does for clean folios.
> > > > +      */
> > > > +     if (lru_gen_enabled())
> > > > +             lruvec_add_folio_tail(lruvec, folio);
> > > > +     else
> > > > +             lruvec_add_folio(lruvec, folio);
> > >
> > > Hi Ridong,
> > >
> > > One question here, why MGLRU/CLRU have to use two different ways to
> > > add the folio back?  Will this cause over aggressive reclaim of the
> > > folio?
> >
> > I guess that is because on mglru, that is lacing a way to add the folio=
 to
> > the head of the oldest generation for anon folios while CLRU can do
> > that :-)
>
> Right, but lruvec_add_folio_tail also added the folio to the very tail
> of the inactive / oldest list, could it be a gain or problem if we do
> that too for CLRU?

My gut feeling is that MADV_COLD says the memory is cold. it seems to
make sense to do it all the same for both mglru and clru - to the tail
of inactive(CLRU) or oldest gen(MGLRU).

not quite sure if userspace is expecting things like this. I feel it should
expect this if it says it is cold?

