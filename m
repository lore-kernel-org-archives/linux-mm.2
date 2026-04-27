Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D602FF8869
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE4A6B008A; Mon, 27 Apr 2026 11:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F116B0096; Mon, 27 Apr 2026 11:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B0E6B0098; Mon, 27 Apr 2026 11:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 162E96B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:36:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBB101205B1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:27:31 +0000 (UTC)
X-FDA: 84704715102.22.964A6CA
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id C6B2C140014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:27:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kDZ/K9GI";
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777303649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FRyQ/RyoABp4v/5IEB82Be0LFi6IsNcT/3z4X4HozI=;
	b=wwhlsXwMG++0jiCIZBpCwbeEPA4SBwFXEx5aqYT1etOdxYfHyEnluxlbmxbiSx/c7ZtGjQ
	CAV6zSA6lqZnnHnu6IxRmbIjJQgucZz3IFBrKNu3FIrbYDBP0HM9h3fpv6lalQatv0rFpr
	0BXa8pGW9oh9Rj39ZMgbZBBVK9jdUok=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kDZ/K9GI";
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777303649; a=rsa-sha256;
	cv=pass;
	b=zbgKsxQe1zE32Zw2cyH6mux67LZNAKZwOK0TTXHBepFhRwBWlxaN5hw4whTo6Eeeur+zAT
	j0LQJQK5LZZXzZM235AF8fhAgXlZhdqrZL5NhAermaNkKDZKVQVQdBwWdo1hFwMHRGT9DQ
	dHQ5ZU27niCLf914wDvKbfQ5vmETl0s=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d7badbd7dso5128123f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777303648; cv=none;
        d=google.com; s=arc-20240605;
        b=cKc4cqawf6NZma0/kU70JB++TJ0XBZUvm2hwFfWfGBJcnIyuYuPHhmI6CXUs316JF7
         fl/7ztI+vo1TMy+tjUz2T+jwPMpEFdqH1M9zroq3wfnjq1fRHQ+O2DSwZSUkR+ZxtV4L
         M0Vz8ps0M4cXfe5NEt7CQCju5UJzqAwsnXH+hynNxYppVB9Auk761hxd8rReI2nSEMxt
         oJJH+UO3cb+gBc/MUh4ixiLi7yjcictz7u6kYS/eL3wWhlb99PXv+NAXnZfoqbYSvIx3
         o7X3RHMf8zkB8SHAYGNMsz2UfyqLiKV/9IRpUyWquj5Yq92T3VhZPxt8/tBIiW1thVn2
         LnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2FRyQ/RyoABp4v/5IEB82Be0LFi6IsNcT/3z4X4HozI=;
        fh=ryJI26Ydwvvi0lKpgOMnYiSCRHuW/mYgPwt7QzaoEWc=;
        b=Y8keL7UPkWleHC8mAhdRHRzcdLzFPpwk6N8rWuKF2qCH/q1pc2SxR/QPVkMS4Wkoiu
         k+6fAO0WTDqVFvSN49RSiIxJT0qwf6tSgIE+RiVv9586ozsw4Sxf5gwoVdmWnHJSzyL+
         o9h1Wj8OCp6qXSHlXAOWBJjQKLZEUZaTKtPVH4MWnMpYirgB2Gn35kPYcSGl+vGss+4Z
         DVYBGmJxmu3FlELKrNDTvEqrSER/nGMM3bANSwK3zegC76fMlESYoDDbpvFvSbb+dV7t
         SVyHsn4o0iGEOFWibBVSITBH3kfVotmOghanewe59jp2Y1hVlA2YM5vBwfQ2emGB2I2c
         uI4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777303648; x=1777908448; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FRyQ/RyoABp4v/5IEB82Be0LFi6IsNcT/3z4X4HozI=;
        b=kDZ/K9GICC08L4O74710rqkQVjUFKQSjiksT+P9BC0eNEYq73NjqmTz1egKscwr1xZ
         5bEYBLdQ4STowtCVGimJGB3u/FB2Bhs73qaFUGQvRjjHKL2kWgrjkSJwR1mF4eg8O46G
         k0jxVfeg0YbEqiXRXo2wR4jzyQasjwNmubtNwsE7Zt9nqMGvRXKXe1phhhEhA1DbNILW
         C59JmuLRHRcgkjqoRANR0XorK48jgOEw/bCKrMZKhKyfbIOUKZmZwHy/fJ5fFwnQEn3P
         SqSXAqODnAzH96jEFmUjvXaLTsxZYf8c9JaJCRMDWb7ePhZIDELBhGBhRa4CFVNB7zAK
         howA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777303648; x=1777908448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2FRyQ/RyoABp4v/5IEB82Be0LFi6IsNcT/3z4X4HozI=;
        b=cQilUhgg1tUtCe59Xl6umGocyQdu+jP/ki9BVxdx4dpPUchfGIpswsYESSGj1X9zbA
         xgaKkJpG7eo8OQi2ODAqKdWT66q1CPkOEwa2yRtkQtQ1R6fQWxC+/ZUOyzWpWrnOpPP6
         yvhdgX21nInO6z08kdkxiH5atJoBn7f+mpsEKYbYjJq6M2zNWI/UCnebeO1yHd/GYsUD
         5S/PAN/oG/jfWxMuHvS8/e4TOjqpAec9OTdODpKLWFZnWoplRc32sooIHvWL05Tscr3H
         iNERBPnn2aCSlR1y5Ig5FYMvkbSl3l6eCVMxE+TtYYOZ3rmXhDYYa8M0YnlrSTBCk5Pf
         fjkQ==
X-Forwarded-Encrypted: i=1; AFNElJ97X982Hq3pRwNScdbxqO2J59cvJg73qzwjY8ekQVXlzZ+VN6BXmK+dQlf1RMfo+vp+f53I/pvkYg==@kvack.org
X-Gm-Message-State: AOJu0Yxq3oSt1zU53P7UNgTRXgF447Qom6g5UFJtQSS+gNiRYuv3OvAK
	8z/dYLFN5YBbLT0aLDOjAd01+ZU1LQ6scjXqziykhmrWYxcEwFKFWbeEQt6gZUjk2q5YhrBsoeI
	mcbXdHRyNGalyYd7IjYIjLWYQ76XgrEc=
X-Gm-Gg: AeBDieuGgO79nWy0r4K7loNg5jGZxY2ShWnsF1E9ftIZdPar2aAxVDKN9yO2GhsLlpU
	fzy4v4UXr2jo6H4YKxSQacxfUoWhNkLnYrh78eM4ft+TjPOIJauOI0FdM3S88e1r39CnoBcYHmD
	bWSNZ409pEOL7m9n+GTgJbTlhx2m0+xelA+YwOROedEZ8zoLn3dV6G4DBfMqfJn5YhmrzKTWJQE
	BeZSHy5klpg+tdqHXrtleErhUh20nqSslisstcACkRkSndTZeh8oZwhUblKIjh0mmuX2IUSBZ6B
	xw0hg+e/AERr4iTuv48HF+C7MUP0KHcaYFjqFA/FlrtbEBwUDSuU8lKp1cVrjLYzP0hMVOxi67U
	CT/s=
X-Received: by 2002:a05:6000:4210:b0:43f:e808:4ee2 with SMTP id
 ffacd0b85a97d-43fe8084f09mr59050768f8f.8.1777303647931; Mon, 27 Apr 2026
 08:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org> <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
 <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com> <20260427081547.4cdbb9a5cade734f143902f0@linux-foundation.org>
In-Reply-To: <20260427081547.4cdbb9a5cade734f143902f0@linux-foundation.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 27 Apr 2026 16:27:17 +0100
X-Gm-Features: AVHnY4LB0ND1Dxh4uexvvpYN_DjpDVF5ij1OjppIGQ47kx58EMkgeVIQzdtUyxE
Message-ID: <CAADnVQKN_6fCMnv2OC3at4X1v=vuah+_LrwW2PQUYkVXqqVGVQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bip5fdjamab47jknkszbpb1o16zat9cq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6B2C140014
X-Rspam-User: 
X-HE-Tag: 1777303649-858049
X-HE-Meta: U2FsdGVkX19l40WF7b/sJGQq555c7UT9nHW2x55iAf3jydBGlG5ou/wjIz9ySnFfzhtLQgbJw6xgSH2ITUii36QYeunRxQ8xoQ3Xfw18rH+fIDBk9HC3UWhMNxPSxHfieJJwQrQvLwN2PQWsoig0AOMd0inyUD/XtdivirUJG5ld0figqcULuLjcDZPBKTb2HoMRUXRsTWGhgTq5dmorfPOVopZKvEPy5sxCr3WNvSXJsHtxhsmFEg6nXXpz9B8z7N/LhwQZQIqEk9fstynFM28NeRWmcHUJEvIrDdjnCHVrZ9BtRLaif4elaONMeTH9zFKWmNbx1id3Am9+ysF5IHKbLZj4HB4CPegOQ7+wv6QtZkcvV+X6leg6cP/X4Bf8DLGL8vXLDKmkBeDdZ8FW3IQCfyA8r91t7EgmRvwrY4uCSGmlkedshLC7FdmXuvRFWibkkj2xbw8TzVfWkVFfD1iwRfW676HlxPHWW0rdFRU3PgQjYWLTL2NTeROWglujHd2ZwEyzAOC5EbObzTOYHMO3mc1VRC9Ga27dy66lrdmcgJjszt6kRY0BeAgXXyLaEqmvN9VvzQnOfwDj36Qjn7fWXa3RQBB9H5ln3GGfNxObcTBJxBY7C+rdXZI5mDYredAQtsPBh/5lBshnE4u9DDJEECrP5gZNCQYolmRXPwbTrPQzYc5Q682pTJ/s42Xhh7+vLKOtX0wduFgVmn2CeecDIX5GAtLhOpoY9wucgtMHQLhpLzB9MEeiteEHGJDHy4OD0Fp3OE89lsHbNH8KLXeSV7xrQSXySbsec7uzegDHhpsE5JtzTKCc0dwRdSl2BTv7uShs41Io7ou5Vmp671I67AuIWEYMvPgloQVu1fU90BpmEf3v6LtlBpAdqUR+dUxzOsDSKbgATv8hNIQL/XmBVjfdR38zN/SZRQ+NVBO6XQOtuvJs/JRTWYckLaBAnyj0W+bza9aNX2I4t5F
 Grg4iU8v
 lPeSB3mHbsJZw5ZHOkQu/CEVKiXQoPGtkQL4axTHOMEORcRAKsp1j8V2/MCdUTwPu4pT6hkSHgACt+dLcbmmxpDYw9B58Aw5fTkCIICTzFEmooH1HJIvBfBsF97EzHHmfG9vyHgMlma/xvtRvNMvpFsK6H8AzliFjp+cN3EzobaJefoKmIZUYozZhRSVpZ2Neu/KzS8u5zbDoqMedx/0KaGcydbP7v9a0qYqGfHmVG2XsQjuutK/15Gl6BjkkGuEvO23qkz+xVubnfZ4qjezE6Q3YZkNVgcRoyOUhX4Ls2VV0lQrku0Y2uR66sTENiugJ7cDSIfhWJfC36YqDQOWXuFFKvLOtr/5xZfELm59jyls/Ju0HnGMaC1JwtCvXtdmG6nw8U6T5uDoCUdwcSTD22upKfp1R1N6Y1WDB+g7Z0Uzpw1iXfBsHzxoRUbgFw5UxoxOkuFhGqwuqZZRdackgOd4Fuxf/WvnyYBK6zmrn7yuXKo2VHkWHsOSOnHa/gQbpZ0AyApgsDFK8pZKG4QkOO13yNFGT37/RzC2p1RpNGQcooTDXnL6x050lcD+SzyzqDkSYK3aINH6XiCDfFhEd9rV+ii2cv4VSte13cTM7c0HDUeHMFDGCsyduNhVJ1/4egfXgqO7V2f4NuxR9vHh/G3H0PmkesZE0u12F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 4:15=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 27 Apr 2026 16:00:59 +0100 Alexei Starovoitov <alexei.starovoitov=
@gmail.com> wrote:
>
> > > >
> > > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > ---
> > > >  kernel/bpf/arena.c | 2 +-
> > >
> > > BPF maintainers will probably want to carry this in the BPF tree.
> > > That's fine - please go ahead and add it.  I'll carry a duplicate in
> > > mm.git so it compiles.
> >
> > We cannot carry the same patch in 2 trees.
>
> Git is fine with that.
>
> > Sooner or later it will create problems for linux-next
> > and issues during merge window if more changes
> > are done in the same area.
> > The only way to share a patch between trees is to
> > create a stable branch and pull it into 2 trees
> > then sha will be the same,
>
> For a single one-line patch?

Number of changed lines is irrelevant.
If there will be a commit on top that moves this line
or lines within the hunk, git will be confused depending
on order of pulls.
We learned this lesson the hard way.

