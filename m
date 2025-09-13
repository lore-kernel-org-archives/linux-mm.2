Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC12CAC58E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 04:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616158E0002; Sat, 13 Sep 2025 00:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6B58E0001; Sat, 13 Sep 2025 00:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503628E0002; Sat, 13 Sep 2025 00:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 430F48E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:27:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCB721DFAB2
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:27:18 +0000 (UTC)
X-FDA: 83882942556.17.7711BDE
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1C66A0012
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:27:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gkC0fHcn;
	spf=pass (imf15.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757737636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blrxGJEUUPTcsFrTcd8XfRhY99hJp8EqG9gyFD99ZxM=;
	b=RSofL3x2AdVu2fa4EaWNzUteX0x+bSF1j14E2r2H8RUw0Heg7FfFyrZpjc0lEfaNL15S9X
	6hqVnvcNX3Fh+zZd4fm/rYkkdIb4VaHxhf1hz7KEwaIW8JsVPxaTRImmXIyepLL3/8CL/w
	iYmh7ApRLjs/PtCdkilIwg6hitedt1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757737636; a=rsa-sha256;
	cv=none;
	b=WmhxgkVYRQUghtrQxEDBEGwgHK25rV+dSFXYOKgZVibBq+QfpsSKEikprTLP4qOcsp9kzz
	Lxh3PvAniFo8AMNQMJLB8cLa3q/YyBbppxEmaBGkAb5sB5M+41bFmGj449c7reWKhVL6uA
	zPAcZ19CoiBLyeThdllbZkjLvuqm0pA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gkC0fHcn;
	spf=pass (imf15.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so2537a12.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757737635; x=1758342435; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blrxGJEUUPTcsFrTcd8XfRhY99hJp8EqG9gyFD99ZxM=;
        b=gkC0fHcnFuzWZ4qcBeFBr3byMLyPY25+SGfUAG4sx1lNFhdNNgb8TkuGuSPDszX2YH
         owLaSeyXXg1YLyIS5ovsFk72ZW6ndkaUzpr7ScoQ9PEjVvB2hfszEzA5b0vwlnWo+HEn
         qij/OpiTkOlLsx1tlru2dxTlhs6Gv85fmAVvw9TCL9kDxefXH0Vr22AJoiqCH8Hw4BFw
         +h3fqbNsRbRCtfvwdg3AYpldM7d6rEgZA0Ekx6Q1+bt5mcXqb+tqFq+TqOpThC2HndX/
         1nnOoN5XhtQN+/W7VXQcecXOyE/c8YNFz1Aqd594JISWyFu2m8CDWGCPOve8dM35opst
         c4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757737635; x=1758342435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blrxGJEUUPTcsFrTcd8XfRhY99hJp8EqG9gyFD99ZxM=;
        b=O8NGGyYP/KMnh0tp4wIXFhbdOKQdNJBTp6G7r4nOSFTUmNyY9Duzn07+GkCq5Ks/Ni
         spcX2rOhMiPERQb+C3dzxeTk0hb9Z1C8Q4+cPA9DUeU/S6xlfB3NglVpEOmlNCfRzL63
         8OR3uo2CRRmHelQDLz5MKUIi1FnoRbjYzg7rW0bxezaI4i3eNN2akLiRinDC+dBjMVfD
         bSowu2WstltRorutKq2KFyEbiKRr3GkvUyZ1Lg+BRcf2eX/bjG8C3dQkTPA5U/JNMyMs
         0alF6lORW3UbdIw/qHQoLy8GkTqngETDwfYhfQLt3+ya+exIAzWPxZu1VPszG+q0ct4/
         Dz/w==
X-Forwarded-Encrypted: i=1; AJvYcCX6rPuojVuUMPObQJy67sG8T6jd4SXXeo8hh9eqLBlNcp3v1XQ5nlTr/uNXF9x/Gty1ypuVkB1OiA==@kvack.org
X-Gm-Message-State: AOJu0YxC4IoQKCBN5DX6XB9afhOqR1u0JqLM+d7YuQ8pjxkvSYYI4EcT
	ZQPuMVMbapQhm//CerXlw+o8vDjbhXaGmcdxiYFriZfsPOpY4exWlM0J1kcOgmgHHFiDivKOFIB
	Hta74/0WMC/DQyEaNMThnQAXj/mz8t7IFKq6RBTdg
X-Gm-Gg: ASbGnctzSTv0hA/Dinw3sM1ZfUdUQlkrvrSZqSYehktPLvRmqJMDl+0ukAtGMsiTA+v
	G1gjS/7caKst0u0aaN0ykEIUOiXt3kZjsgY6ITNFQ7S/5qEXce6dH94HJTIQyAOSVNmXCkzxQyP
	LVfZYaT/vRtGXMTyYfeDnlsxWNGaOo2JwoVDVIJSJRzBo9fghcQeFrVkaQpy99MhuD0ihq/d8eG
	eAZp1u8927lCgKQkwPqKGYLT+3nQlcPTGrzizgs0VwuKCg=
X-Google-Smtp-Source: AGHT+IHjFw2Zg2JiBFqjUk5Z6gMn2JCEfkhFslCWm77ZXeR1Q/G+nsrA50IIlOGyl+GgWAbAeLhbFj7ZxBQk2EyomnM=
X-Received: by 2002:a05:6402:4415:b0:61c:c08d:359d with SMTP id
 4fb4d7f45d1cf-62f03e2b937mr35968a12.4.1757737634875; Fri, 12 Sep 2025
 21:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <d507dc89-e6b0-4360-bc77-1a8bf74b9134@lucifer.local> <3f37af16-abf2-4ed4-9894-0028a9f02f76@redhat.com>
In-Reply-To: <3f37af16-abf2-4ed4-9894-0028a9f02f76@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 12 Sep 2025 21:27:03 -0700
X-Gm-Features: AS18NWA3XZo4rdm4oou7ezMAUiUYL9jGdXUz2TYAt-2RnbIiKYE4Cg9f0NuB_DU
Message-ID: <CA+EESO5D6CBezDCnN6=7zujzczDZp1t-kajXQCEVsgYTYciT4g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1C66A0012
X-Stat-Signature: tzi9rg7cf6xpsme96ebzqkrbm488jsss
X-Rspam-User: 
X-HE-Tag: 1757737636-323398
X-HE-Meta: U2FsdGVkX1/O4d7iwG4OawED0N+AFx0FOTXZIRdHPKnI/xvhbcEOM0zSnzxnzGxJUy3rmiCj1Kt/FZB9e0mp9XIUxYhz+gdXUpF48JEUP817qeuqm1PxO9tEAjaLl7FVfACDkbBCVcqqfp+0hGq3u3J/qvk4m+s3AeuGy/K0E2pr9AfjA06qLOhBBzISVnzphMe0AkqEl58bEdDPDGTh+C4o5lOF5+6veh7FUZwq7rHF/iuP+NcHNNbbsC2YU5wgab0Js7ekvWfNMyZf5zEIxSeITCFPV05r+PihFzqIyNu+cFtCmMY12X5ChjEpDSiPt873Kv8Y8RnOwqlYx5noZoWRT7fqsdhKvsj0QIhEA8623ZyX5bXjn9I8QF8N9wVL4hDQbfQv9WrOff9I2R1oYrXYGR0/MMR4JHRftIqys8oSDvcc9ucTiT4F/ea+9dRFIVhVTmZaKyxoKBsdEkJ+dBlv3Ox/NUqwfegNrlT5xwezokH+ZU1t24YHnQb3F/qHktq0jwmT/12Fm7YpMuzQIyiMSEJQ7gwmzjCGjpycoxsS2OTgO+C7Lk2u+G567JtVA4nOHW74Z7p8nwZEvv2C7F+cB597u6rviC1FVYXIuJXD0OjlaXf77nhHDooMgz53kdm5kN13QHJJQuXq0TI8ZLIcjAsKkCH6WBcNFH2CekKARmii2yiFI3P13HaJcJfqFT7P6oXwM9dn67xtkpXdX4IFyuHOcZ2zkggZ2dRDZ1mY98Xp0au6zUhBnyYuWNE0QorfCBM8iurBTmGN+qR+q5P0Cj/r+WAATFJ/t+qPdo0XhkSoOhNu1tpzGRrRgwni7NQO42qUctXFPvCjuV9DkQZlpKpeY4/iBuGEaW6IZzOpcWqj8lBNOb+m2I1YSO7Loj2kPPoOCtYPy0jvBrzT2LUkrgvpX2Rd55Fpj2Eda7/aTI6mWbsS2zDXhxWtzWhS1N/0YFhjz5YVL7+mBRi
 LKLVA3H2
 A7TB/HSXqYhoPWC0vl6DDy1idkzzAAUpf0jfQn8h/lIkDzi6kVEO3gz2KL7JQFh9NFnSDh4Cv9Ce9X2cOiIHc/IhBzYnKuX2eN7HSQj6oVj+Lqnv+Nmw720RiDnaCLAoGVt/DEGZbITFYCvydtdGx4UPjgDpoqnFaclFTmhaUwNKRQPN9ZszWijbnUD7z7cGK8KNsNyXqIMPi1ybOHIXrPXZL3pz3m6uQICGhUICfPdPp/UWstdR9Ra6oh++h5sWdNCLJ3btHzN4gYu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 2:03=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 11.09.25 21:39, Lorenzo Stoakes wrote:
> > Please please please use a cover letter if there's more than 1 patch :)
> >
> > I really dislike the 2/2 replying to the 1/2.
>
> +1000
>
> >
> > On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
> >> Prior discussion about this can be found at [1].
> >>
> >> rmap_walk() requires all folios, except non-KSM anon, to be locked. Th=
is
> >> implies that when threads update folio->mapping to an anon_vma with
> >> different root (currently only done by UFFDIO MOVE), they have to
> >
> > I said this on the discussion thread, but can we please stop dancing ar=
ound
> > and acting as if this isn't an entirely uffd-specific patch please :)
> >
> > Let's very explicitly say that's why we're doing this.
> >
> >> serialize against rmap_walk() with write-lock on the anon_vma, hurting
> >> scalability. Furthermore, this necessitates rechecking anon_vma when
> >> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> >
> > THis is really quite confusing, you're compressing far too much informa=
tion
> > into a single sentence.
> >
> > Let's reword this to make it clearer like:
> >
> >       Userfaultfd has a scaling issue with its UFFDIO_MOVE operation, a=
n
> >       operation that is heavily used in android [insert reason why].
> >
> >       The issue arises because UFFDIO_MOVE updates folio->mapping to an
> >       anon_vma with a different root. It acquires the folio lock to do
> >       so, but this is insufficient, because rmap_walk() has a mode in
> >       which a folio lock need not be acquired, exclusive to non-KSM
> >       anonymous folios.
> >
> >       This means that UFFDIO_MOVE has to acquire the anon_vma write loc=
k
> >       of the root anon_vma belonging to the folio it wishes to move.
> >
> >       This has resulted in scalability issues due to contention between
> >       [insert contention information]. We have observed:
> >
> >       [ insert some data to back this up ]
> >
> >       This patch resolves the issue by removing this exception. This is
> >       less problematic than it might seem, as the only caller which
> >       utilises this mode is shrink_active_list().
> >
> > Something like this is _a lot_ clearer I think.
>
> Yes, fully agreed.
>
> >
> >>
> >> This can be simplified quite a bit by ensuring that rmap_walk() is
> >> always called on locked folios. Among the few callers of rmap_walk() o=
n
> >> unlocked anon folios, shrink_active_list()->folio_referenced() is the
> >> only performance critical one.
> >
> > Let's please not call this a simplification, I mean yes we simplify the
> > code per se, but we're fundamentally changing the locking logic.
> >
> > Let's explicitly say that.
> >
> > Also I find it odd that you say shrink_active_list()->folio_referenced(=
) is
> > 'performance critical', I mean if so, surely this series is broken then=
?
> >
> > I'd delete that, the entire basis of this being ok is that it's _not_
> > performance critical to make this change.
>
> I think we can mention that as a side-effect of this performance
> optimization for uffd, folio_get_anon_vma() gets simpler and we no
> langer handle locking of anon folios different to locking of other
> (pagecache, ksm) folios.
>
Thank you both for the valuable feedback. I'll upload next version
within few days addressing all the comments.
>
> --
> Cheers
>
> David / dhildenb
>

