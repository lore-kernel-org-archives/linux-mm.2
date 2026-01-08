Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F665CF6A88
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A6E6B0092; Thu,  8 Jan 2026 03:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A146D6B0093; Thu,  8 Jan 2026 03:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923276B0095; Thu,  8 Jan 2026 03:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 829806B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:54:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1169E8C123
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:54:48 +0000 (UTC)
X-FDA: 84308186256.03.93224BF
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2CF9D4000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:54:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rtk4qArv;
	spf=pass (imf04.hostedemail.com: domain of suhua.tanke@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767862486; a=rsa-sha256;
	cv=none;
	b=kGQODPg8hOQ7k/tfYtoDyb3D7jDdIGHTBtVgh7pDTWRAkiaztv2Ahh6ALDQdhaLtW5GBjo
	LL/lapKQSs1uuRQYb+F/A9H7L5eyxl/ZQWAtGCLV2izBldQglKUoV1ER/9ACHf5Yarh9ke
	SBEmWPLpZnn7Zrv7jfQ+oB2rF2xFjSE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rtk4qArv;
	spf=pass (imf04.hostedemail.com: domain of suhua.tanke@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767862486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWtM0yl4KTyuF2JiyplsZFaC0Y10MB5neqtODWmo+As=;
	b=jT8luVyc6n0xmfpXdFRGHqwYVBmd6ZSQDPa30qfBBDykUEp44TGpi4apQcMULqGAWJr1lp
	+h5Uzqjy++NxqZwha3yKRcdNNm4YXbDc/8jvCFQyVKYy2cjRfNEbDeHiKTxfzubpV0xrDx
	bnHg4YeC4g+g2E9ZXoeffUI109+pCCM=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2ad70765db9so3730746eec.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 00:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767862485; x=1768467285; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWtM0yl4KTyuF2JiyplsZFaC0Y10MB5neqtODWmo+As=;
        b=Rtk4qArv1oQ4VsSCZrghixabibYWQFldfNYSKDLPinugqUdjWOSBdF5GCDlFD+mK6w
         zCChBmqUIzehR3JM43dZgWCRfPdmDZ8zphSK9gqu2wOVXgIwNU+5PzQ3H+Y30jPuVLn5
         3iM5c41L1TtXZ6GDI/KgvkTW0ByLALNECJbYnml7bl6Zn4AYMC/ra7zxIIf7F8EH2x36
         rY0/+NGMVx/zWyp2t2JITY/vgdlM0qQmYhvaVxWNPjfJkzNGKTL4QYNwbCebbh19ZOQ6
         6V9lhE+UoacDT2W8V3PTpJvfXiM/wA5aGAV9Z5u3uy4LolfQ3E0NBXUpbxX+MraOJRBQ
         twjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767862485; x=1768467285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AWtM0yl4KTyuF2JiyplsZFaC0Y10MB5neqtODWmo+As=;
        b=YwGkV/4mx7F+fD/M9oskmBEYoBAFHvlB9bAqd7sfYPPDTN6qJPL9J7ZJxJ2QjfCqda
         FMxfecO38GpQBWzsGoB7kB+cxw7TygQWsC2OryGJSDsQubjQtqt4uhh4hwDinPt7DzqG
         sJN8V9QN1ZrCuXyvcjK19zqznf9do2FA/rCMEZZdyRbZqFDzUIITbbJSHIrXmbcep//u
         T35+DwCjiPZYGsQqP6Mi4O5UpD/AFQx/iDRqcJrX8Ai7rmrsddOyiNLy4Vko9wQFRlND
         p9EsNcmr5G0ic+cuZ5axxYFQ0xinj+b0JI3unaDp6lmT7RhrUOqzSwioYDDwy14tNSpc
         foow==
X-Forwarded-Encrypted: i=1; AJvYcCWiL229qnVCUwfuffwNlJ2+6VVMNnY0zTBrDu9lcX099AC1fmerilN0+muBe1eh+soEVunPsa+TKg==@kvack.org
X-Gm-Message-State: AOJu0YywZdoQz5B/4DoJ/+AdlrJzdrpb14c1oK48c9CG0/tKRog3PoPP
	ZjLPVj9ygXcMPKNsukf/hQ/Im0RJRU5rMDoxzMQ9T+6kAPuNezAufTYn7jiGxPKqzoSp4mbOQrk
	Sp9iDVUd8CELi4CM5IwVNK7XnqDjZW+g=
X-Gm-Gg: AY/fxX5gekRj1lRSN65UBodgJTJXJnSrhlC0k4WVGER2bbIm2F3nl8YnEb0lvZoF9Ha
	bxWRcu2JSJP+4RFpKJrxTzOmTJkctnQboGLsvy9s5/j0N54aauF9ftOXgbhvJoilf3igS7jQNGI
	ejeyew/juNxbpDc2iajRcrkMd6XH2XD+pa5/E8D36u7xiuAjfu5kwzskpv5Im3d08kv0I1N3uX8
	wj2qM0exaCrH/trpT2pchNcmSgD7VlILa9VWyhdTzDRljapdjkevddDJDnKepMiSbUsTkHA
X-Google-Smtp-Source: AGHT+IFo9jZLc4iq1EieWdGCiBNKRW9PsQNtb7mO/3X8S4PK4d76TdT7P/WH2Rlmndb8FIPecPhHbwrDKoEpe/VPNKE=
X-Received: by 2002:a05:693c:60ca:b0:2b0:5435:2e04 with SMTP id
 5a478bee46e88-2b17d266983mr4298186eec.19.1767862484836; Thu, 08 Jan 2026
 00:54:44 -0800 (PST)
MIME-Version: 1.0
References: <20260105133250.763076-1-suhua.tanke@gmail.com> <aV0ifCtvKDPvwFug@tiehlicka>
In-Reply-To: <aV0ifCtvKDPvwFug@tiehlicka>
From: Su Hua <suhua.tanke@gmail.com>
Date: Thu, 8 Jan 2026 16:54:08 +0800
X-Gm-Features: AQt7F2ot_zfp2qNEB_Eacf1N91ao3oi2YTQtj2QQ6WiRno5XV8PKkZJuuA3xiF4
Message-ID: <CALe3CaCZD=wogTEA-uaRpawZcyiaBcOC8sDw_aOi_9xeKi=RFw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix execution order in alloc_contig_range_noprof
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hua Su <huasu@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CF9D4000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 4ws886a5fp35eco1ffys9qhr56w41iqf
X-HE-Tag: 1767862485-41210
X-HE-Meta: U2FsdGVkX1/gSxXzkrtzjzeRD91kN8ky9/kMGAusXJsemk3eacxkiA5m+zROALOe00yxrd7u6qpAHsQ8ueCDvHDI/Vz2eZyFEFZcuJU/fu3QsUPJaD2X25NUJYb1wwIHeSpPLXdq0s+PuoswXcx0og3yZaOO/krJMpaYcTOrDVFjwVN27miItF54H73Lg8xrLmBoZ9+NFkAL7KtN1UPA98uUL8QrAKo2kt2+81iwph3CAdfKlVM3hJyQ4rbRYymr33d+1xiS79KWGujRQ/4EZ4kz/1svY5FUFUIp0tFpmissyU6IFII2/K/qSej11N1u3eZlIXr9IMA/Ous2lOYZPudneTBS0JdqBWpiUWpfNYm7H0lO/zGVW11dUEVzhAiH4jrfEdY+gqV9P5qXoduvwP0eIFMn1nkiZqCdhCgb2zPj5U+aZ6r5uel3QQlylWv5xgNGtFkwoqSUV8ovZL3JLZX6ULxmCe4KWJiDPFybpdvVqRM3qG/I1e2LuhNXdelIbeB9L9v037wWPf2nwQLKbNQn/gd5YJOKjRszQBKqxRs9dSMzjilyC95LCoFWBwL7MIbp65NO42fAr6tMnq/OaDFLSJPAp1mIs6t0QykQXppmmo4m2k+NlbhibLYnN69MQiKPX42Yeeqfgoyj1mkOAQep2FuqP2brJG9789G30X5YekYHvTL50hIhdOJm2MCK2/RvWc7qMnU1aDj3ptV3IrEhcFGYCVhKfa46U3aGgedXHp7MAqlrgdHym525gtNRb13N1+A6LchVe6vYgFKUyMNyAteZlk9r8DdkPo/lz585c8HxhSpXm6MvQSPc06J3D31E044uy2p0VOvEPWtxs7Agp7Oi0fPBE6RarTP/XVylo8WL7HkghR05gvhYqX6fapZn+Y5vjB8/YKOZWd+GzBqG7Uo5IHX8ByAHkyjeAbZsXrC9UFsNC2DCm2PXiOgimxKPEZ6pATJsdfcBr2w
 JRrzN5TV
 pxOp79Y8WsHjrzwtIG7gZ0X+EFtLkVw/AHt5LZs8A9wRU9YWTW2p/QMDuJRuFety760rGEgXQkOYIOd53S3WUuO2Rtp285Wynd6XyYfY/6BmibIkAb2Rzk1HFa3kasMwiXmg9KZf5LtBZAiNu0HGlMVRyE4ZUPxEYPpgBFi1ApFC97VzqkphtOkI0421pKgpuXmAAaGnroOKtBDvgk8mL7BbuElRRtLcCZdf2Kad0n78OYdJhMNg4GycZrev5BJiefLjbw4AfIrZKddqemtMEd5HtQitEsgY4wVZvIKZ3QhQUvDS++Wc9XA44VNbG9ZJkG/VcQyvHvP+/nBMTybKwdHsr9hYLxc/5khHKNQADJW2jTWX7BYHgJm5L1SL+x+9uLxfadnv5mEsNpLEz9FA4dBjY/EFrXUCK0cuCf+5SMkN0LHNkTw6TzHXoQ0TT/eRLn0sMd6r1ciqHEz2cW3mJ1svnednXu8EuozH6tRlJji7JecZl2QO4OPHR3URRuC40moGRtZqb2Yp7OizcjYXzXpUX58LCXQgm8eCC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=886=E6=97=A5=
=E5=91=A8=E4=BA=8C 22:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon 05-01-26 21:32:50, Hua Su wrote:
> > Fix the execution order issue in alloc_contig_range_noprof where
> > drain_all_pages was called after start_isolate_page_range, which
> > may be lead to race conditions.
> >
> > Based on community patches commit ec6e8c7e0314 ("mm, page_alloc:
> > disable pcplists during memory offline") and commit d479960e44f27
> > ("mm: disable LRU pagevec during the migration temporarily"), we
> > disable pcplists and LRU cache before page isolation to ensure no
> > pages are left in per-cpu lists during isolation.
>
> What exactly is the problem you are trying to fix here? Is this based on
> code review or are you hitting any real problem. I find the changelog
> rather hard to grasp.

This submission was discovered during code review. However, it seems
I made a mistake.

Disable LRU pagevec is for the problem where migrate page might fail
(origin code has already disabled). It seems not related to the isolated pa=
ge
operation.

>
> > Signed-off-by: Hua Su <huasu@xiaomi.com>
> > Signed-off-by: Hua Su <suhua.tanke@gmail.com>
> > ---
> >  mm/page_alloc.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 6a47443c48ff..d08f929ca64c 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6815,8 +6815,6 @@ static int __alloc_contig_migrate_range(struct co=
mpact_control *cc,
> >               .reason =3D MR_CONTIG_RANGE,
> >       };
> >
> > -     lru_cache_disable();
> > -
> >       while (pfn < end || !list_empty(&cc->migratepages)) {
> >               if (fatal_signal_pending(current)) {
> >                       ret =3D -EINTR;
> > @@ -6850,7 +6848,6 @@ static int __alloc_contig_migrate_range(struct co=
mpact_control *cc,
> >                       break;
> >       }
> >
> > -     lru_cache_enable();
> >       if (ret < 0) {
> >               if (!(cc->gfp_mask & __GFP_NOWARN) && ret =3D=3D -EBUSY)
> >                       alloc_contig_dump_pages(&cc->migratepages);
> > @@ -6973,6 +6970,9 @@ int alloc_contig_range_noprof(unsigned long start=
, unsigned long end,
> >       if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mas=
k))
> >               return -EINVAL;
> >
> > +     zone_pcp_disable(cc.zone);
> > +     lru_cache_disable();
> > +
> >       /*
> >        * What we do here is we mark all pageblocks in range as
> >        * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> > @@ -6998,8 +6998,6 @@ int alloc_contig_range_noprof(unsigned long start=
, unsigned long end,
> >       if (ret)
> >               goto done;
> >
> > -     drain_all_pages(cc.zone);
> > -
> >       /*
> >        * In case of -EBUSY, we'd like to know which page causes problem=
.
> >        * So, just fall through. test_pages_isolated() has a tracepoint
> > @@ -7076,6 +7074,8 @@ int alloc_contig_range_noprof(unsigned long start=
, unsigned long end,
> >                    start, end, outer_start, outer_end);
> >       }
> >  done:
> > +     lru_cache_enable();
> > +     zone_pcp_enable(cc.zone);
> >       undo_isolate_page_range(start, end);
> >       return ret;
> >  }
> > --
> > 2.34.1
>
> --
> Michal Hocko
> SUSE Labs

