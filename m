Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F65CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F528E0007; Tue,  9 Sep 2025 02:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657CC8E0001; Tue,  9 Sep 2025 02:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F9A8E0007; Tue,  9 Sep 2025 02:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4262E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:01:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA3A785A85
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:01:43 +0000 (UTC)
X-FDA: 83868665286.30.F068CD1
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D17C140010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:01:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMI7l1Mb;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757397702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AG6yh/H5QJxLcghDYp8QbyDiZJnFOxz+dbnxAFmfczs=;
	b=0D4m3K2Z6mmMpWyn3EDyXD+S3e+ZBWwDnrW4qRrpdChz9sK5PZcCcP1KGuHSZqR2YCJ6se
	N2p6yJUXPXXyD5obzzpI4AqeQUV5vnjyHslUD+/tBypoCXIAAoPm3ypFVJazoBSLEmJOoh
	5fXcVjm9ocu0DIXf8X4GXfiMAXDP9tA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMI7l1Mb;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757397702; a=rsa-sha256;
	cv=none;
	b=KNKmV/ZrFdIxTISni9cs7uKllySJVySivKcuQURDiq4Anx5WKbWufGvXaICETfEND88U/i
	Uxf/h3XTX3/4wdkm5MDzYMm3AkbtlUsUhVD3ZKHqaFUyQm67yJjxuh6+uFhngHHBLoVYPl
	BEnxlvQQ4arKGekQFUhdygtGk42nrdc=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b34066b52eso51030931cf.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 23:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757397701; x=1758002501; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AG6yh/H5QJxLcghDYp8QbyDiZJnFOxz+dbnxAFmfczs=;
        b=LMI7l1MbQOV4TY97KUzLhCPjgbICw/uVRzxFVniqffL53BG5FA7wZWF50U3d7FgFl/
         9mTi9ItHO/1L+72Qpn++SgDVNpv68ftdi9+bWh25217dV0R8d7VGWkmUNbCpcQ2kAV1d
         sduzJKltRrVuyiviDT1kPgtyJCHi+6Ouqd2P3DKflLwB9FMSLuXuW3GydvVZlWSMZBOS
         sLXGMtEp75rok7m7sB9gvd7bMHAPrz1VPKk+lrvqJXcJi6TCjro8YpBctF6qlbzcRreE
         OILwLJ4TqRpY7cxzw2RKQ5ZB0H1bkunTxgX3a5IAiFjF1QC5t8/jS9SFX37GucuTpJuX
         tJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757397701; x=1758002501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AG6yh/H5QJxLcghDYp8QbyDiZJnFOxz+dbnxAFmfczs=;
        b=CkF94hjb+GRocKfhHifEGnzK2m1kmnRFv/7aqHzPoMP/kqwV1Bohic0a4R9TbqnV/0
         HD20bgoK0qA3jyOW16z/cN4NAc01MToouh2MbK/RiHJ/5R9RmTcdMcPaM2Ska268qTCs
         pMoJDZfQawJi66Az00iugWmxuvJK71/QRF30eSK28ohg8hMPlrQbjufe16vvEKAdI06B
         uBbZzbFjMsalJFY1HAGjKIoRF4OId0pLQj3Z1JFl9YN9WtWqSTAljz/PsWDwmfLBMvDm
         Fh7btHy1eRUXTXtTp4XMRaP8MgT72qRqg3IJ6kT6NySZzwA6tTLfYeeF2Qtfodk9DG2B
         wfoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaVcCey1tyZvGNDHKDr28ttL8WCDySGiyPWx+ATUZ7WuDZf1swhD96PYRqxxvsWYKoAwWhlk/mog==@kvack.org
X-Gm-Message-State: AOJu0Yw6UAo1yY4IomW8naQIPJoO2zO5dmu4nmKS48UxnPRKG9bE7irz
	OCj7Yg6gzI/oH/aMw/17/5PwuTOs+5M6qUv/8Tqe9nJofAdfFarEgVaLBwkDQpkb+rqBndm7nBZ
	G8BwnhvyQ2FsNy5Xxs9sRk1RzE+QynDo=
X-Gm-Gg: ASbGncvCQnrracNbJCRgQfaR8gl4oCrFVsdpOkBJT//pIgk9KX6Kr+377pW3f8qysqs
	0+gXfF/6M+0CB9lRPZU9si4RPhnK7EXa+bfCi/Zc4I4Me3env09+Ai4PwVl2qAuw48R3yc8TFVM
	jwqJG2c1o9FMrQvh4VHykaea0Zg45JwO4JH9eiPK3peDay0c3kIEyiqglPX78l5rrGSOQD6gPox
	0B23tg=
X-Google-Smtp-Source: AGHT+IGDKGUoHglyYgwNNnO9V7hv7U7abAtfBCJrWWee8C4k9zzxHUJIh229SXB+LmF95KA5NUhDwYlqqb6opxpSsCo=
X-Received: by 2002:a05:622a:1101:b0:4b3:78ac:150d with SMTP id
 d75a77b69052e-4b5f8445ce9mr100057281cf.40.1757397701115; Mon, 08 Sep 2025
 23:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
 <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
 <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
 <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com> <CA+EESO6eNfb+92+uYDRRWdx4SJnHGY34QtzbWUpoB54yjvL0xw@mail.gmail.com>
In-Reply-To: <CA+EESO6eNfb+92+uYDRRWdx4SJnHGY34QtzbWUpoB54yjvL0xw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 9 Sep 2025 14:01:30 +0800
X-Gm-Features: Ac12FXz2mysAEndoTXiGdBcI7RRpNcwFV5AySbusRxHys4eXxubZ4YFFo2tSDos
Message-ID: <CAGsJ_4yJYUbP5DZcmvpe7GwEDYnjMsycgN0TXKZoytrCk3VXxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2D17C140010
X-Stat-Signature: yg6ncbqyn6qgwr8xiorsy4cb8pqwispn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757397702-109859
X-HE-Meta: U2FsdGVkX1+OonTG264P3Hz8C4ihDaQDU7zrtMLa52iQ7ccoCR1ElFdAAPJG/wqm+D2MNO9ttx1pY1FZt2lO1aP4FWux/DCIW2+9YWYVfQ82kEBZBTTizXn3GX53BYNtEm59azOF0UH48WRcr7aOBlQfWPQs63tPYUH5FFoKlLW6UOlMgBSTo+9olbEx7NRySFEZmSfVzAoGY2Tn0o7ZGlLwkoSJkCDQ5iNVwSfDD7gcPnf41OVnGw232lLAqZAHCEl5zKE5utJ/UgS23vSz4g7prjIExpL8d0AweoqytT3ut4mzGoMGu0i+8l8BxuITcIg0Ie9SG2KE9RQsLsXHv1px9EKe6TIMYGGAF2CL3+lWTczSin8UpDqR1KMSH6zsp61EUWt7xANl8tKSxdAuCgDTu0YKU8WgOJxI4oyw3eotkfXSmDSwyBe6o50PwMtobRqx2eZ5nMg7hRFqgyqzuOCvXtMdvldtZI4Shm0Jic4Ywx7QRV1kLqoJtAoNTMGsMaymuSUBSfzwwzBHJkbvjF0LGfX6QGMjPnMKurb/QUM5Lvkxg4shJEodgikG6J4W0+dCe2ItMxRU5TC99fwB7c8OtCJX3MrwxsTAzoH4mRVcN1jcYFbydFf/oRO+nrz6ti+GoM6+nSyxabBQOSH1Nk8oHdGRE91/6nn/MPSwLvZRHaX5JBqjBZX9YwC00bsp0fZTLh4+sn5XMKeT/f0tR71BbUIX6rWdExyVxLQq9fMIcr/oxYvXtRy2mMhEMHwHjyL4kjnJAkSLl8mYX3SJ/SVXBmPD7dFSc7NngIW51nLgcv953q2ucyH8uY1UnrwoL9ImoO2PtdHMzZl7YUognVKQE55qSPZUbftrmqz+hiAqC5I8allO1DgrR3pPKzBSw3BAwi4ONHTh7wwsxuY5TcVlDsyrGpLuVoB9V/J0QJVyDq/41m/bM3JzDl3/kOXp5KPi1jzunIG1jTYV3an
 RlEjDVt1
 Hz0l7PsAVck5/wVjmJpoz/WixNyBzmlELfk9ik4pDWwaDFkLlYXCSPX7Q7c3CC7Se32YR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 1:57=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.com=
> wrote:
>
> On Mon, Sep 8, 2025 at 10:52=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Tue, Sep 9, 2025 at 1:37=E2=80=AFPM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> > >
> > > On Mon, Sep 8, 2025 at 5:40=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@go=
ogle.com> wrote:
> > > > >
> > > > > On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.=
com> wrote:
> > > > > >
> > > > > > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgid=
ra@google.com> wrote:
> > > > > > >
> > > > > > > Prior discussion about this can be found at [1].
> > > > > > >
> > > > > > > rmap_walk() requires all folios, except non-KSM anon, to be l=
ocked. This
> > > > > > > implies that when threads update folio->mapping to an anon_vm=
a with
> > > > > > > different root (currently only done by UFFDIO MOVE), they hav=
e to
> > > > > > > serialize against rmap_walk() with write-lock on the anon_vma=
, hurting
> > > > > > > scalability. Furthermore, this necessitates rechecking anon_v=
ma when
> > > > > > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read=
()).
> > > > > > >
> > > > > > > This can be simplified quite a bit by ensuring that rmap_walk=
() is
> > > > > > > always called on locked folios. Among the few callers of rmap=
_walk() on
> > > > > > > unlocked anon folios, shrink_active_list()->folio_referenced(=
) is the
> > > > > > > only performance critical one.
> > > > > >
> > > > > > As I understand it, shrink_inactive_list() also invokes folio_r=
eferenced().
> > > > > > Shouldn=E2=80=99t it be called just as often as shrink_active_l=
ist()?
> > > > >
> > > > > I'm only talking about those callers which call rmap_walk() witho=
ut
> > > > > locking anon folio. The
> > > > > shrink_inactive_list()->folio_check_references()->folio_reference=
d()
> > > > > path that you are talking about always locks the folio. So the
> > > > > behavior in that case wouldn't change.
> > > >
> > > > Thanks for the clarification. Could you add a note about this if th=
ere
> > > > is a v2?
> > > >
> > > Certainly, will do.
> > > > > >
> > > > > > >
> > > > > > > shrink_active_list() doesn't act differently depending on wha=
t
> > > > > > > folio_referenced() returns for an anon folio. So returning 1 =
when it
> > > > > > > is contended, like in case of other folio types, wouldn't hav=
e any
> > > > > > > negative impact.
> > > > > >
> > > > > > A complaint was raised that the LRU could become slightly disor=
dered:
> > > > > > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifen=
g@oppo.com/
> > > > > >
> > > > > > We can re-test to confirm if this is the case.
> > > > > The patch in the link you provided is suggesting to control try-l=
ock
> > > > > for anon_vma lock. But here we are dealing with folio lock. Not s=
ure
> > > > > if the ordering issue will be there in this case.
> > > >
> > > > Right. Not sure what percentage of folios will be contended; I assu=
me
> > > > it is minor. Maybe you could share some data on this in a v2?
> > >
> > > Any suggestion on how (or which test/benchmark) would be good to
> > > gather data on this?
> > >
> > > IIUC, shink_active_list() doesn't behave any differently whether ther=
e
> > > is contention or not, except when it's an executable file folio. So I
> > > doubt such data would be any useful. Please correct me if I'm wrong.
> >
> > Since we skipped clearing the PTE young bit in folio_referenced_one, a
> > cold page might be misidentified as hot during shrink_inactive_list().
> > My understanding is that as long as the percentage is small, this
> > shouldn't be a concern.
> I see. That makes a lot more sense why folio_referenced() is called on
> all folios in shrink_active_list(). I missed that young bit clearing
> before.
>
> Any suggestions on a good testcase to gather this data?

I would run monkey for a few hours with some debug counters, e.g. how
many folios pass through shrink_active_list(), how many get contended
and moved to the inactive list without clearing the young bit. If the
percentage is small, we can just ignore this disordered LRU behavior.

Thanks
Barry

