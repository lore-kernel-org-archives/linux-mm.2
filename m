Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD293CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DC18E0007; Mon,  8 Sep 2025 20:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005958E0002; Mon,  8 Sep 2025 20:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83E88E0007; Mon,  8 Sep 2025 20:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D847C8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:40:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EA3B160322
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:40:27 +0000 (UTC)
X-FDA: 83867855694.20.9D8F29E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92B70A0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:40:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XeCv0E1K;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757378425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xcKwcAH0vZe2ghCgVsHWktJ0IgRk3a7iueM+OjaN1Q=;
	b=ULr7EKttdd0W1hUskEGfnHX0TmBbaPkjrLPlhW1MPxs2Mr/1AlteHIHJCV22s91MjBhbLn
	IB1mvT/ChO3sjQAche8mfbifDXX1rqdjPCm76n8+B0Y6lWqDvxRNdFDVuxGcAjE6+F5yoz
	S9oNwPX9HeXl2m0slIpZ7/U3qwKJDy0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XeCv0E1K;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757378425; a=rsa-sha256;
	cv=none;
	b=qmUnQKgGyQ36eROcnaEwNajIyPWrylZtU5MVypu4W9cdsX+QBB5nZJWoW5DBenf/qi3WQE
	FYD0d1/JA6Vv2Qmg2rK+BCpjXQ2/cIZ2qWCNK4Y8JLmWuC1TEuuH5ZOu1Q+etuohBDilab
	GNFYWYJB+KDZXyhBVWwmNm37jJtEOKE=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8112c7d196eso311210485a.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 17:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757378425; x=1757983225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xcKwcAH0vZe2ghCgVsHWktJ0IgRk3a7iueM+OjaN1Q=;
        b=XeCv0E1KqMwzg5nHwV2g5XKVTQHSnHwtjpiCuPB6OzbcM+hjEr7CtBP+l4r4VhLFEk
         C+UEqMm8IJd55QRouOxJy2/Cl8fxQydnH0RN+sB+se7ZLKXxVqkh3r3vW8RTO9yivH86
         aeQ0zbHEauEyQjRdt++o82ndayVpN4tpsmKm1TSs1l2zcHv2PmftGgO2Sow8W29nWMfz
         fqSok4fl31ivSIeN38ztbIeyySkQ1tQFJvHPBbSmQJHFK2wDS/lcRx/ze9rnh6k1fqrj
         3fdGa/AyPuGtgXS1iC/dfh0FCpuBN+TkJMzsTvgm3aqtwfws/hOH5dXpNvAvss0d3QVV
         C1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757378425; x=1757983225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xcKwcAH0vZe2ghCgVsHWktJ0IgRk3a7iueM+OjaN1Q=;
        b=j6lUN73hGaT7HGr8kVC//82BXtXKZjFVD6s9NrSObQY3lC/Z5Cnf+zVHIOxs4CAa3m
         bTNyVYUXn2cBpcgPak72VMo5NMYmdQG33oIR+bag2cJIfRnr74DeuN/haef5mOWJlSqj
         vWsG1mEN2racXn0fLlLzlPt2BEK20RArAftZqCNV3zKNzv96AG/UjH5mPLz4kO2AFtHk
         FDqdff/hAEwu9vgHkd6nh3wIVDJSyWRnXzpu4XhS2X8ib2gE+wiS4iTZs0y8LEbHQn4+
         kSXx1aI+4wVK1wopMN3d8J/JzfEa6FQqw86KFmVHRnwuSzKx8GCDvyXCzrABrhzMfgKh
         Sy/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXo/SocxbQzmbpE5ybNi+M+9yDgVZHwJqfzVxAaLA3uQVxpNpLDggWibwLfkLBiMfcpVDZsguTnkg==@kvack.org
X-Gm-Message-State: AOJu0YwGVbA2Aaa2+wMa8qpt5R69sr7Hv+D4cwyu3ecd50noKPbN/Byf
	6HlhdO5g06fLCTQw3bVvl7KcFMFGsGFs3uQf9AsqCcxL91nAh8P5mD/+Zo1vat0eJ1OriNjhAtm
	N2bWNCED991dp8WtnN6Q8G/G/kWMAIMQ=
X-Gm-Gg: ASbGncta+nGe3GlO01TzGy3JD6ULwihIDxjTFxvYl3xTqfpOQ2xfz3yRRsY5A6C0m8o
	+AL5FPrWvIc7VHcKw149r9REDjsy3yH00OASKNQl1pP1ALbQLvsmt6IjsSEda8bzGWklUR6fzYN
	YEdj79OS1FcZskKcLknGQcgMsihuue9g9hh2SlhXGrqyPYS1EzU7+G7qwToVNwP7+e8+dahbmL2
	Epdr04=
X-Google-Smtp-Source: AGHT+IGmUbMh2Sjyvt1dSllIgFTptn8uItgbjHtKaGYL06/whcitidl+4H4+iSVFgl/2HFSzit0OFdkl+OAC7kTuNaY=
X-Received: by 2002:a05:620a:4714:b0:805:8a17:924a with SMTP id
 af79cd13be357-813bdf6553bmr974105485a.4.1757378424657; Mon, 08 Sep 2025
 17:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com> <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
In-Reply-To: <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 9 Sep 2025 08:40:13 +0800
X-Gm-Features: Ac12FXwoRJ1YHtCyR5OfCglSHA-ORdtw48BdC4A75u-CItjtWrNMOvbZx1lLLPs
Message-ID: <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nn51d43oncspxjjzgw9rkf71qr9zwmbu
X-Rspam-User: 
X-Rspamd-Queue-Id: 92B70A0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757378425-638452
X-HE-Meta: U2FsdGVkX1+/WPiPh6tBrHz1kDntPDz3JMk4tucixVBAZO6vrnn7ABhU4J67RXZ+wSXzrUG+U6R3e1MX9067Xm/SxQHTzvP02NBkNjAmAbTHE1vLhjFFkPfFLLioSJzTAJhQHIF3ZnCfe7Kw+3ByTygiMWBN510yBC2/GoHJU92vnjEdLwl0iRd46LC+xC6gxAT7STF4wTMhCDA3McvZTQB9jrFfkJHlEiym4Y8/oQ1jSh9tnayro/IfFgKUJjAn1/9gn5J4IKrCqYzW0kXY2l1xOBlz8crfeORYegGaCbYZNI5Pj+N+eVNYy8x5PqLKv1zuotI+RfOSCMieGPWviidiv4gR9p4Mrpukn8ou0IMMUs0sOnK3YHb8W3gvpb+wTJboBBRriKsPeF9aXE+cNBfu9PxUbJ6vOcqzx4A0EyIpoNrWA+D8EaJxVFBGgpbiXN0ICVp8m5QvKVF6A4HWt3EKY62fKzEAeKFqT5ldPNZkxpgQcS7xujG5XhUICa6yB07kKtRJdcw5JGkdxVSXkZJ3IS15S+92+6/HsoAkUFD8ZHWru1FLnvZmbVwgs61qOFNUliZvXYjr1E9STEY7HdXYMi35Ubf4lz4sZ8t/6mV1ouqbsI05aDFSnPqn1JDgENFINvx6kPKT31PDJiT9vLWIvjihp3pN9noNB6T0p0SXdad4CLsSyQi46Showqo59CewTvbKHVs7CSx/EFG/ivoT4ytuBo2qGao94o+J5PydrBAk7jh4Hdq0pGm17e+xeWGg5hn7q5/XUQbrzxVKnjHuLwfNCkneFupanBxxisDN0iCyELn6HAwb13w7DnAbcVD98qBr+QR7PpBICCG1DxeFicXn0aMzqV0mGVBtHXsv0BfHnktjMaKvybjxC9j1ZndnobAUkxh8YLf/idN0HUI5imrRq+u7r9zFJsyDwDH6NZRjOfPmdNfhpFc47mCAsBEKFdZWDfU2fS6TSQO
 1WvKpCu2
 rGbWWNFW7gJYC75MJWml4l+rBephH0ac5btTFXLoSmJksrpnEtKwNZV5StWw20w9eTjx4IeqZQHoKgIJnkhMtIYMHilTk1X45Nit5ttKXkp+CcRPL3DQPnAhOPB1kiw/G7c1LNkAkLfMmVtAdKAT7xLBpJsyplcR5hryhZu2NI17Jxf+AOATgeYPmwAQa+PVZW+VfuSt03orb+Gpvc0OoINs6rTv5rO7hdOogHtbCqBwfDS3B64RClnxzCjrwSW5wAKNnRUaxXqxNtJVOjU5qkox6KUPQjul2TUUA03lKZi+1GjKVw8goCaE2Wavd/I8SseFqunqiPlPgI/K0nA31nKUwf4DTZKhiL/okEtBAV5t3ccU0rbGgV6Q0BITHUsS7CDfay1t9ONyHPaavd8elzVrlvsK/87Xc5OSU8duLtzLEXY4p4dzPU07mhD+mcF5/+AOSyGUyAaF9ZgQdxL9+Cd1qF0pczZ4BTFfQzuHQfnEFFMty03+ME8uILw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.com=
> wrote:
>
> On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@googl=
e.com> wrote:
> > >
> > > Prior discussion about this can be found at [1].
> > >
> > > rmap_walk() requires all folios, except non-KSM anon, to be locked. T=
his
> > > implies that when threads update folio->mapping to an anon_vma with
> > > different root (currently only done by UFFDIO MOVE), they have to
> > > serialize against rmap_walk() with write-lock on the anon_vma, hurtin=
g
> > > scalability. Furthermore, this necessitates rechecking anon_vma when
> > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> > >
> > > This can be simplified quite a bit by ensuring that rmap_walk() is
> > > always called on locked folios. Among the few callers of rmap_walk() =
on
> > > unlocked anon folios, shrink_active_list()->folio_referenced() is the
> > > only performance critical one.
> >
> > As I understand it, shrink_inactive_list() also invokes folio_reference=
d().
> > Shouldn=E2=80=99t it be called just as often as shrink_active_list()?
>
> I'm only talking about those callers which call rmap_walk() without
> locking anon folio. The
> shrink_inactive_list()->folio_check_references()->folio_referenced()
> path that you are talking about always locks the folio. So the
> behavior in that case wouldn't change.

Thanks for the clarification. Could you add a note about this if there
is a v2?

> >
> > >
> > > shrink_active_list() doesn't act differently depending on what
> > > folio_referenced() returns for an anon folio. So returning 1 when it
> > > is contended, like in case of other folio types, wouldn't have any
> > > negative impact.
> >
> > A complaint was raised that the LRU could become slightly disordered:
> > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@oppo.c=
om/
> >
> > We can re-test to confirm if this is the case.
> The patch in the link you provided is suggesting to control try-lock
> for anon_vma lock. But here we are dealing with folio lock. Not sure
> if the ordering issue will be there in this case.

Right. Not sure what percentage of folios will be contended; I assume
it is minor. Maybe you could share some data on this in a v2?

Thanks
Barry

