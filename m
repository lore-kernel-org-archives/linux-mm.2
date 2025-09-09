Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0427CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12D28E0006; Tue,  9 Sep 2025 01:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA0D8E0001; Tue,  9 Sep 2025 01:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00308E0006; Tue,  9 Sep 2025 01:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDDBD8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:52:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 733A4B8BC6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:52:03 +0000 (UTC)
X-FDA: 83868640926.27.259C18A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99D5FC000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:52:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhETiKae;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757397121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDlBfq+OEptG4mcfUKWaW2aby5Ft9Ou1XtPgpaLOXeM=;
	b=H21PvmZIapw+l0C1oCnx+MzBILyEYvuoNve3H1Ne0xOIX0gsnywxOr2wByWuvOVGSL8fe0
	6yZ3HwhUL3avEWznafO+/DBKgSANyjcgEcHvfuq3+YDoge/JEe+Ms2nSJPlDuNscTHJwSU
	J+k4pPviL1LDUvhNri0x4KFo31B7+9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757397121; a=rsa-sha256;
	cv=none;
	b=mVjfk9tQUvYyWFPHoRJqqSUkyWTpr2DmD/G4HQRFqAbd5bGGMQDRcKZ3DG0qfpFba+dXED
	WPrqZ4zvADIxuckvBuFFqsCna7MpZpa6k+DxS9lFCzdy9jPfKPLoVgezcZSlK+kMvXKpWJ
	4uKK8+n4BbEJW9ZprNgizoPYRalOEZA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhETiKae;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b58b1b17d7so43901651cf.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 22:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757397121; x=1758001921; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDlBfq+OEptG4mcfUKWaW2aby5Ft9Ou1XtPgpaLOXeM=;
        b=YhETiKaeGQrvEzNPrXKgS00rGqIo0bhWyIoJ01AQGfssX/TBiHZ7x5Bp8pOjsBsH3M
         08Hkr4yYu3e6je3Lc/evh56kj8W5vuBtV8IU13q9KEEXu5pMlicfDcP24YwJhpZl0bRW
         INaP6qWxMvVns1Gets+qzQfBVR+1R9U5QoJtSaiIWRx89MoGSYmoBaliRbosP1fWtrfD
         B8ey5ZjoAem6y+bmZYbFBozxWwTBUdApHONZhP59b//U7+9wyWYFVqAkDUoUrCBbuqKP
         bpma4GgS11vHWomFqWzu2ViVESusISpcra4Z0nDT8TBxh42BBXFsWQxO44k0D6pBSqFl
         6sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757397121; x=1758001921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QDlBfq+OEptG4mcfUKWaW2aby5Ft9Ou1XtPgpaLOXeM=;
        b=Gk9bBi/aGlzuRkCvMaqcPAJh5B8ALHYeYHClJoETqWH0qmzPG0tZjMp6T1WNsZqcKP
         H3mQqLWKcAWpwTTqKV4ktJQABujfDXeOG4B96W5VHznulbunOwdO/lz0LB8E6yRGUuy6
         +4oHjgqSNir9fny8bwe9FiwRT2uTGiZYxDRId1WfMSHBZ7wzPJqRkVZYjHJKnm+DR/Vl
         2EIJ5lqMdtlCOjH7QEA/iFEpufi+roASE5uRjiigvxYgKiFKmSB67Lq7JD8qmVJaAxNK
         G5rYnM/bdjxVJsJS03P3POCumuSwRIuLYaCruPk6ZFGqzZcwGN8CpsYvlYV1QCQkDqgm
         qXvA==
X-Forwarded-Encrypted: i=1; AJvYcCUpvDIP+BPVs9BEYlYgmcvH1d/e58UihWGOUkYjD9qgdcI2LPzyDDiRHCsYbjGWCGTsnfYlSlZrhQ==@kvack.org
X-Gm-Message-State: AOJu0Yyj8+He+L7hAOmjmFxeLXwxmNU+vvj7zADeTNk9qsV+YXRkH/DT
	RIJi7tR9+Sv8mALna/pFeBMpElahILQ0q4Sg/AYGD00dHsV+7d9a+HicQAck0Lgbt9MDPgeZ8V+
	HG4jworWrMGnL3XrEovfgRFir8aztyr+t6d19F6U=
X-Gm-Gg: ASbGncsXz/7DHJDMIFCgsmamO7rKJPjMHMA1D3qX8+mdPX3C2iyTjO3RjRW7O+F79sb
	ykOjlOSJEGaQvyFDqIc0+BIvIlKW5stPGtZbG6emxYBsBk75wF+Za3RruJ3HwKK/eTWfrER2N/e
	ATbXS6pU9Px7L79tNh9p4EEOrAd7v6vRav/7XoIeZMca7fFwBLu2QjvhyNCjUA3ZiZzsvE38Nux
	KcQ9DU=
X-Google-Smtp-Source: AGHT+IEGe7RC3sEl9RbBIRw6IqpZXA1uqkfpFpm+CkeX+EvreA3fGNj8iq7SGfzUKdSlXUdnbHCwrtwBvvRvMJhQhv0=
X-Received: by 2002:a05:622a:1301:b0:4b5:d6db:eea1 with SMTP id
 d75a77b69052e-4b5e7e3acccmr178260421cf.39.1757397120602; Mon, 08 Sep 2025
 22:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
 <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com> <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
In-Reply-To: <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 9 Sep 2025 13:51:49 +0800
X-Gm-Features: Ac12FXzwsJwyQxk__dDaL2SUQqBHIqsOfguBknbmiD_a54HOkOGQe--sJU7s-WU
Message-ID: <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zq3iteaexm16s81ezb8sihgrgq8ou46n
X-Rspam-User: 
X-Rspamd-Queue-Id: 99D5FC000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757397121-702053
X-HE-Meta: U2FsdGVkX18HbVc0Pr4aL/wl8QVvaZvQWru0/8/tyqWtnTIWyduWo47JL6J56uavZcaff6dZZ+/gSlOKTcqOeivIwR2bXu4z36MKOcPmEwHCaee+9ikPu65fP3msHpNHV2AlLRHk9sGzjkASf5yWpF2xErjjw3GXAELjd2vckPNvWSq+jzI5SLypSgAPFF+0W2PTmnqeiZNhiFex9tpEL7c+9OL9S2/077IITimGJY1DdnfEm69xeEMBHptTAhKPr1wCPQSjwidkF7juxB64XzGjFXEELDZpMvt+ZsfyMKqXa5jmLKb7dElmkdphY/fFGL/CQm4VjdaLBjMmIWaSIYxww1ylrhIMD7ETohj9o80z4B3a563TiDbEZL/tagQqwaoVNavKyD4WjyzVK+TJTQQSxM30zsVusPNNdDJlJGERnxFv5RwA92kjOG3IZZOmOoVi5sEK8V2Y1Vkcls97qxyyTAxChPbQml5MPxszciSl9Nx/Cg6GoWp9NwV1PCyTaCyDYvVi7oAP5ENJS+qrs0aVu2SIGE/a7UAo7wuevwwSjB6rqV5hp1hW72rqkJSHNIncjqoECV6mbkMW42DKhgPVxllJutreolvpINcqenVF7mi2KrOS/1MenTUDY6tX0OCYbEwd4Ur6DTRlRdvrbAKDWOUHQo1+Q/F0bCx0oELPoNk/G0UlOqDVrUkLz2kGgPx4BOcnf6NTXTvYGtjJQO7lAfs4mg+QtUnKhi31RedXDo8OKA+eEtXYZbjw45xOd72T/cS5tMuhVhL7Hjyg/vrxTS6OBPDZbs88WhgG2vUgqe8l6Fraryp5XzEyHvlW7F6xN+Vgi/jxS42mgYHxBitNsXzhj4BwMJLzX6grueGW8EDITCGswBNFiwGHyB0Zl/VCKSEcLXGIHpxUj8G1jYuK8b63NYbBX5PrBnqKawTKYy+1BX9i0Pd1TBnxlJXXVUBcTZ2/gUrBHEGGkET
 ODfJwUOr
 KDufZ4DC8E4wXGIIYIQkN726Ed3OlfvFdAZp3CCBnpdwUto06vhPscraAKDCevv+TqvASuWM51MvAYml2tLJG2FPLUPg39M9jxhWrssIqtR5T3D5nGrYQSBUm/quRbY3AcaEx4p2rCrwf9z8qLB9v3jCft2IV6qbVgBck6JH8rAQ5UMXtkUYUoVTeyXv2bjDF/2CjPSTQpq8TLKvOYx2gFxImFq2D98t8d5sTHgWJOMua1+XCTUAkit3RakaOxyRKr8s7GAU6cRi5dJYRnCopokLUwjJh/kIbSNZpko73YXFjJcZqAAQQi5CKUsWQaLS3Ewlt61OaI/69WdEUywNwV77i+uZOPEJMwGI1vypCAApd/JWCMwpIYJCq3nGq7A2iQQYz9dTIDTp3CSq9RVEG/vk4bJv4S9V8dg9BLj9hfLaMimjKHI2fdtnoJsFgaxD8noawwj6C4OD1TsSEGvfZ1D0FPY5gRADT51Z+Oko+iwSTCO0R8wSDR0GrUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 1:37=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.com=
> wrote:
>
> On Mon, Sep 8, 2025 at 5:40=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> > >
> > > On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@g=
oogle.com> wrote:
> > > > >
> > > > > Prior discussion about this can be found at [1].
> > > > >
> > > > > rmap_walk() requires all folios, except non-KSM anon, to be locke=
d. This
> > > > > implies that when threads update folio->mapping to an anon_vma wi=
th
> > > > > different root (currently only done by UFFDIO MOVE), they have to
> > > > > serialize against rmap_walk() with write-lock on the anon_vma, hu=
rting
> > > > > scalability. Furthermore, this necessitates rechecking anon_vma w=
hen
> > > > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> > > > >
> > > > > This can be simplified quite a bit by ensuring that rmap_walk() i=
s
> > > > > always called on locked folios. Among the few callers of rmap_wal=
k() on
> > > > > unlocked anon folios, shrink_active_list()->folio_referenced() is=
 the
> > > > > only performance critical one.
> > > >
> > > > As I understand it, shrink_inactive_list() also invokes folio_refer=
enced().
> > > > Shouldn=E2=80=99t it be called just as often as shrink_active_list(=
)?
> > >
> > > I'm only talking about those callers which call rmap_walk() without
> > > locking anon folio. The
> > > shrink_inactive_list()->folio_check_references()->folio_referenced()
> > > path that you are talking about always locks the folio. So the
> > > behavior in that case wouldn't change.
> >
> > Thanks for the clarification. Could you add a note about this if there
> > is a v2?
> >
> Certainly, will do.
> > > >
> > > > >
> > > > > shrink_active_list() doesn't act differently depending on what
> > > > > folio_referenced() returns for an anon folio. So returning 1 when=
 it
> > > > > is contended, like in case of other folio types, wouldn't have an=
y
> > > > > negative impact.
> > > >
> > > > A complaint was raised that the LRU could become slightly disordere=
d:
> > > > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@op=
po.com/
> > > >
> > > > We can re-test to confirm if this is the case.
> > > The patch in the link you provided is suggesting to control try-lock
> > > for anon_vma lock. But here we are dealing with folio lock. Not sure
> > > if the ordering issue will be there in this case.
> >
> > Right. Not sure what percentage of folios will be contended; I assume
> > it is minor. Maybe you could share some data on this in a v2?
>
> Any suggestion on how (or which test/benchmark) would be good to
> gather data on this?
>
> IIUC, shink_active_list() doesn't behave any differently whether there
> is contention or not, except when it's an executable file folio. So I
> doubt such data would be any useful. Please correct me if I'm wrong.

Since we skipped clearing the PTE young bit in folio_referenced_one, a
cold page might be misidentified as hot during shrink_inactive_list().
My understanding is that as long as the percentage is small, this
shouldn't be a concern.

Thanks
Barry

