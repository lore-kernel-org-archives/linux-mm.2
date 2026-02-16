Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2628BE81A3A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816176B0088; Mon, 16 Feb 2026 10:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3F36B0089; Mon, 16 Feb 2026 10:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698766B008A; Mon, 16 Feb 2026 10:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52F796B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:55:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC58E5D642
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:55:45 +0000 (UTC)
X-FDA: 84450770250.21.DACC824
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 28F2240003
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:55:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bLN5Tvhh;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWvwt78j1MWWZWHT5xuvg+akNAgQWYTfkj3HpojwxkQ=;
	b=BFoRKILP4bl1cvFT4sKXddk8yms6AK8dLrQTCOnsBbEmBDfGnFRyBUJsTBfUjnXywsCPLf
	6tyY39HBNj9Ca2MdQ4mLj0Y8fvvnsGGLAxc/9dJ7bWo4lB465HTCOxqcciXOq0miW2qnBP
	dJ6IcEyNPkC6To0X8XcQ7KaF0LfEo5c=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bLN5Tvhh;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771257344; a=rsa-sha256;
	cv=pass;
	b=faDcVUfUSXZOt3Yl9j0IrzIlG02y14jc1SumGDkgmisy2bHNQGWV4R8H+dAamsjGU2sJUN
	Ykp8GuLz0/5K6dc+goFoIQQSKAbCP1zlfsyih40ICRYUVfjYy/Cpbaiti46L160lfqxhvb
	J04ynay4PHNOUbTluVJmY11uFaIOf/s=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-794f701a3e6so27581617b3.2
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:55:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771257343; cv=none;
        d=google.com; s=arc-20240605;
        b=RQYkbh+ZYYbnL7RV0Bi1KjJ1mtNZhSOqQqHdPbKKo6BZUK0TMKwHb+29BVTxXUv90t
         9IYVTwFRMEDjmlg7+rjDwcrIlPNd5QSBActmTdg3rV0xS5nNfqCfyAbQz+sBwU8P4UEg
         aDkEA0lt+bYXzI+Q4AJTwNugu41inKuJsGhCEUD3RGXY3v8Pcfu5KHVprhcydT7jOtQV
         1FwAO3t2rPRIqeEs81jlv/HrxRUgsdGM4HDtFrqXdpSTorYv/1y3VPiXLOL+GLPBhqwg
         kj8i72uU1b8gQ51kOeoiNRLH1GVynZmF3VvhTUpG5UP93fA5i5ZFzS20ow9wzFf8a5eV
         gOag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bWvwt78j1MWWZWHT5xuvg+akNAgQWYTfkj3HpojwxkQ=;
        fh=vAlsdeQ0claFi8Luh6HhaV7kQqIadKQw6M100Do9cz8=;
        b=fTojdhkMiVOffB0FeNk0AtcRXBudehtPcwq78Blq/pvmGuz0DiUfwZETyyEin5NAab
         gsk5JW8GHTn+nNSqZ56GtwxLoEj+QZPMe25zWLKiKJCeKym+sbJdieqRD9WbL+obSyqG
         TwySauah357X1GBEQER0/pYqUYo45xjssa0S9jUS0dqnarPy6awoaq7+xFjyjZSupBt7
         UU4MK53vEuZqwV6mjhyqkDyDHNJq6iJW3Gmkpr7bdfbK8c09+nGmtcyB0gzsQG57DuXS
         BgmqaNufKKX5TI3MrAw943CSS8t6L3hR1KaiTWRueUfikXrhhThGdKoR54fqzVyHUSBt
         fiyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771257343; x=1771862143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWvwt78j1MWWZWHT5xuvg+akNAgQWYTfkj3HpojwxkQ=;
        b=bLN5TvhhgM6SACzc9gsQI44OcxerVfr20YVle/ToV7MRR9j/HNCWTPTNCxpbq627dz
         xzpzru8v8uVN4SmUWfoD9YPxs8edbYKzNI5AJOqyw6kX54MXDQ3yegVrhxDDJInlYm7O
         qYQt2kWFN3KooLrwhGQQtG1x3BXq4NFFwW0WkDinpp6HWQmtClNxgl7C+k8FCjiIfYW/
         dR1jZ4r7P032uZiCObsbX+ltQHo+8ol4n7LEn66gJz8nY/O7P8HAWLjG6KM3cKYY+Yuh
         kbVXfAW6PWNpQoHZk5GocDcNMyn9/HjLpxhCTVrY4cxl2hT4RHbQAGUmF2eA0EkBdyfV
         Va3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257343; x=1771862143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bWvwt78j1MWWZWHT5xuvg+akNAgQWYTfkj3HpojwxkQ=;
        b=ZRPPKay182Hu7rU36Ol+FdEZHICsWjE+Dd4Mpvkx3U/VRJ85FXrrcReqo66uRmKkp0
         I5d493ZswZy4N9gfjY9/YVYbf4E2ErngLgyeiy6IKFCO0w5hflcFAQMvVVJv87WwYdqa
         QaFxEsQb3OzvNk8NCuz/r33jvSfDn/7M6DMuzOio2+vw3aNseWnKY8XihmslXjJyPY+a
         ByYAnDBo0+QVU/zX76JkVJxKKFVm3Lww6TZUNezb1wbCbM5emROjYXL5kqQXiBxWfx0I
         HLYinlh9wURpY3ERA5+L5jBzOIBL8WfvZTO3vP6Hxrib3DuJ/qFkjMZLYCudgM6Kf+Xd
         xFEA==
X-Forwarded-Encrypted: i=1; AJvYcCVQ7UfpXPr57GJuVHjuNFr/LS3Vq3Ltw/HKc9aAQT58uf1sx4k2upjDOJiaNsRtD6jKQpl4b1rZHA==@kvack.org
X-Gm-Message-State: AOJu0YyHr7UYYNKDZxO+Gq5PzYnwpRe+ZJuuROVfKEiwwO33LcL/LRpd
	5pu81cGo31wm56aGhDXquRVjj4bGEpoOITVmuhXEppJ37UhtxkUWRXe/OnejuwZAkrJOwNw65hj
	BaoZ9Q9i3eEwTcjjDjG6j3VyoFkdu6W0=
X-Gm-Gg: AZuq6aLEemHYP7174hi6MF081bdqSb8936mPDI/vvXRT900Su+pWRfA7+USJpLpXADS
	me3oVGDGn/t/hvbtodM0+ncNEFur0dSGJfTojcQVI4CQUHQt7fLPIQAOnDlAmcWGGxkcwhmJGOL
	QmyVCWbp2SK7DzA3w48axG6i5zwAZ30FFDk9tNz9/5b5aqFh1tgckMVImVkvagRL+54llYETA/n
	XFNdgcm4OQogYmTFtVZdyZppGKpwrGjGJ7x2EXeo/u1q61V9JrZwGKEaKoymXk0No8i5c9YgvBE
	zNgeLrgi
X-Received: by 2002:a05:690c:2606:b0:795:15e8:8a08 with SMTP id
 00721157ae682-797a0bf98c3mr85736567b3.16.1771257343063; Mon, 16 Feb 2026
 07:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com> <aZMoQw-86_FtUvLU@casper.infradead.org>
In-Reply-To: <aZMoQw-86_FtUvLU@casper.infradead.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Mon, 16 Feb 2026 23:55:31 +0800
X-Gm-Features: AaiRm51KD8ke76MeCQCtufCwLmalDJ2FNTUwXvE7u9dyzD1mLpvwzn203IhKnEc
Message-ID: <CAOptpSMXu384dbhAeUhRVpaqG-zACfSn22dOpyhs1rD=v9+MOg@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28F2240003
X-Stat-Signature: q6ygzqte88kq9twxun34rs5yg4xc1dr5
X-Rspam-User: 
X-HE-Tag: 1771257343-754983
X-HE-Meta: U2FsdGVkX1+xyFqXwhkzXEUugy3cviayLmg7pjzyHmcejMTS1fmdtYwSulsPexxuiJbk8FeANRYR9NRB5+p0wiXb7FGL9SATMz2xlZvNwMG7zmggmDlGQ/W+a4Mof73uxJ1fmTm/acGJ+R2qFmTZVlWdKrIjpaKvSprYHWV677aGb5JjRUZs7TgxHMpElfIW+M+tCDIK7cYSA4U5FZDwJ3N0IgUFstTMLoQTdZbPUUsQBTtDtQoTMmctEgObKIU/odS+4pdh/RrUxonAQC/FbSNnyIVx5u6CnqVgGgihIYdqdlPrvRyDGqB9W6OVQg2aucZiXZs2INAEBbqTVc8/m7/lfDLXOQNH4yU1UCvgO6eZHgNhPXXJi/jNJSOPT+Dtwon5yY7ZOkDdSuGl25nlJUgCK8jY5igSxtNmfWBQMNe+m/ZnstW0o7pQnjN/LSml4TdjLNaGf8TwY3EPc6RWJ4CGrQ+F0plfqEmHD/JSGak8rU/b/Te0d8U/oDE8ny0F0NfhonnIGzl94oMt5NkaVJHqtuoBv40u1nUz0vAU2dG7B8VmH3cJms1ePLNa+YHEcuGO71tATyKq69VyB970Fjus0B3tDPL5zYwVvWCgXXbpWbX6Tizxl/ie2n5ZOUuH7zJLV0q5g5o9ErvmoLhxA5ftY7Hvua5eKfF3y3SZuf/no7TnD7bDG21+CndQj5wO2JxZWoFdLx07/l7shTOEyGSpR4uccOxuuulTpuT0vYVhvPKm41rK9xEAJa4dfsFwkHB8vRxNCh2V6xz3TbtmX6dv8m2Tr/TKTnAHg2lR6nMxNyigl0G2fAW2ZHaPSmAVHsx2mJ51ejYC6c96UJDMjsy3GsBmYu4FCDPfc8DTIAL9mN3xvGNhAb/6/FP0fUf3iXcRJHhje/8nQDiOcesZ9J+h+tlE8soFHgv0OQ3dQ4i0KkxISfU/fn8yhYvLNM77D9jtx2Nr1bKdUcTVu+0
 CSqMdb6J
 fjz+3yKEKduVbMFKugexB90lC3oFx5D3tjm23xfJf+rFHATAtL8beoQeLcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:23=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> > Add kernel command line option "count_zero_page" to track anonymous pag=
es
> > have been allocated and mapped to userspace but zero-filled.
> >
> > This feature is mainly used to debug large folio mechanism, which
> > pre-allocates and map more pages than actually needed, leading to memor=
y
> > waste from unaccessed pages.
>
> Why are you trying to get this upstream when you admitted in an earlier
> email this is just for your internal use?
>

I see this as a debugging feature, not limited to internal use only.

Our real goal is to gain more precise visibility into how system memory is =
used.
A basic requirement is to measure the memory overhead caused by anonymous
hugepages that have been pre-allocated but never accessed.
With this information, we can implement various policies:
 - Allocate only 4K pages for applications that suffer severe memory waste =
from
   anonymous hugepages.
- Evaluate per-process hugepage waste during low system load and proactivel=
y
   split hugepages accordingly.

So I believe this debugging feature still provides value when merged upstre=
am.
Currently, there is no effective way to account for memory waste from
pre-allocated
but unused anonymous hugepages, and this feature fills that gap. Or do you =
have
any suggestions about how to get this info?

> Why do you think that "unaccessed pages" are the only, or even the
> largest source of extra memory consumption?  The vast majority of files
> are never mmaped.
>

In my view, memory waste from anonymous hugepages is less acceptable than t=
hat
from file pages.

Although file pages may also be unmapped, a cache hit can still reduce
I/O overhead.
By contrast, pre-allocated anonymous hugepages that are never accessed repr=
esent
pure waste.

Furthermore, the total number of unmapped file pages can already be
estimated from
/proc/meminfo, so we can already apply policies to control file page waste.

From my research, many memory-sensitive environments already apply
special policies
for file pages=E2=80=94for example, the RFC patch from vivo that manages
readahead file pages
separately:
https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.c=
om/

But file page waste is not the main point I want to focus on here.

Thanks.

