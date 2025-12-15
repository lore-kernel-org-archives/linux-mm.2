Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AB7D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12326B0006; Mon, 15 Dec 2025 04:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2EC6B0007; Mon, 15 Dec 2025 04:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8E26B0008; Mon, 15 Dec 2025 04:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB066B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:15:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53E581A0E2E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:15:32 +0000 (UTC)
X-FDA: 84221147304.15.D8ED9FC
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5D60B100002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:15:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d4O3knP1;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765790130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfRNcdMDEH6IEISnjBaZG4pgnQR78MZmgYX8/UFNZH0=;
	b=KZIaiHPatecFSfqCg8CconmqPH/B9z3z70x45rQWALt/t4V3BemLKaAhMp9OTVY5OGM2jh
	Ln7lB9zg2jGUySDXThUTv3Rztd7jtPxDxbnz9vsVAA3+3+SY9DxcJOqX1LmYLHC68bP5qV
	gChqKj10JTXWV5VCrYOBA5D3BC/rsPk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d4O3knP1;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765790130; a=rsa-sha256;
	cv=none;
	b=L7e8aX6aEIbqJPbqMD9XnQFutbhdXk3ezCeGF420O17Gj4GTMNgASw6uUJ1bcUqKYaaJhE
	kEZHeddfxUeagHKPVulvLU49LnejTZJvHRq5azl4x+ujzdPbFqrPn3DeeHk/rHX5wkMZ6t
	Pu07Hm/lbZhkr7kzVotR+0A5jPhrKP4=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8bb6a27d407so202302085a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765790129; x=1766394929; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfRNcdMDEH6IEISnjBaZG4pgnQR78MZmgYX8/UFNZH0=;
        b=d4O3knP1mK/0AoI57mdgbXKXBJUukif7TtW4hff5q++f42jEzYrXo2vmD9rERbNP7N
         1b3m9Js7+M2SX6DzGD+/anVazxPVTT9cZbKBcHJbgc+5rbHNr+fXbw1MbL2hQKIL7bVF
         4nWb/eVnxWJrDmsp6/8chJN44GP4R1CodRS5++WLos3IenFH1EdEDLeTHxTRm64XH4Fb
         HjH1llna7RmuNaCZ0pGGLqpszd5HZyW6cTjlvRCEwLzDRWihtQ5wAT3X2n1YqjH1Nkpo
         hq49O00XxzdtdwJhiSYnMT58ChTZtgcD0dAJCSbWd3mLR/GIPglRCN0YjWDJ/F1OdC7n
         hc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765790129; x=1766394929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UfRNcdMDEH6IEISnjBaZG4pgnQR78MZmgYX8/UFNZH0=;
        b=jKlK7JuI1/UT0BUV62aQ+QgGXxRHgIoKY2sLI5SY9N9Q6A9e738+9dLZOvIljA4R5B
         SdVkRwiZ37DgC7cKeYJhbzqI0Hzw8d9Z98Djt35o473dlNMtBp7S5fZAh89BpURXeOoZ
         UGmh+yRmpZExrUNMlcWEbGkPNsHN74AIRgX6AkI7KOG/Lu3OAU2lJgn/f7YAesVfsQrY
         4OKnXDYSh5p2GpqSS8esM9WzhJZuHb7snudKigm6CXWLXxkeT2f0z9PSyTUzX46n7c5z
         9Z0hDlkZwYteAhAv2dmXadlaaUXslTPA3/JCeocr0ZG4e852cwEJ5prj4jwHMwA13ib0
         C5DQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0sdLdKXS9uuE1oJJZSgyWWei+c5dXG1DEcEPsQtZZ6qFZ02RP1VqTEBpTut8m7aqUBL+6w97nCA==@kvack.org
X-Gm-Message-State: AOJu0YzMORKtpWsASvq2N1l0SQVHBb9mFV4c3BoeAZGlwe6Cg3XDMB1g
	qu5Txctn1xsH3PU8ly8J4RZH8OxmePGb74za4L1huGOknPiFpDsKLVxslMCJdQj1inHsyon5VLJ
	m4D+amYPw4H+IzPSyDIXHQe0sMJ16s3w=
X-Gm-Gg: AY/fxX6o5r4LcHLlqsDy7LinC8ehRA9kSVdSJnTtLTEGXYZEtv1NXwlEWv0iEhhn3ZE
	/NjoAJx8TdIik3TDktVNBmRltJVLya0bMfPWNLX5uju5I5jAeFnWFwF1X8JaXL3NWPRzIHe8Ife
	0ak8/pcOeO85dvRronAXJQwm8OlWpxVereHBQU+qkfcJpGenK3JXghlWyBXWCkmppuJcQrYWMJ8
	mlHuws60JTNxgvYuslymJG916xWuMktvh2S4/GecPJ2Q1tyPXB0t2eHS8C60dzTHJ9KMAFx4tTg
	dKyu
X-Google-Smtp-Source: AGHT+IHTVWz8FDB8neZeUYr69bmNb2lQ4Doe0u2X1HZ89XaT7zSOJhNkwc9rMVJ0HwIlo4Zgwo+2XtXVX7Jf2zYt9yU=
X-Received: by 2002:a05:622a:288:b0:4ed:66df:8023 with SMTP id
 d75a77b69052e-4f1d04c342amr125903831cf.30.1765790129114; Mon, 15 Dec 2025
 01:15:29 -0800 (PST)
MIME-Version: 1.0
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com> <20251215084353.nmznnnmcpcqo4ldy@master>
In-Reply-To: <20251215084353.nmznnnmcpcqo4ldy@master>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 15 Dec 2025 17:15:17 +0800
X-Gm-Features: AQt7F2pHnVsszNsNVjCNDbbtmRd_uppjCc5OwHc7ZozeduH_eU_PwYtY19rC75M
Message-ID: <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: ahyatekjur4ueq185qm5z3nf8txegfre
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D60B100002
X-HE-Tag: 1765790130-590502
X-HE-Meta: U2FsdGVkX1/D2yBQlkTuv+AF4iVSqtniFM1/ZwzyUEKvs/8MOR1op1hppKLPZBaGIo/vf8ncN0y8DvHaoNDlf7mWgN1ezsmLjTVb6lSJWE6T1D17Csplg4eqf/HWyXa/jj+2MtzXf9Ql278GLz9x2blc1M70039t1ghfjgjMj1iMi8UsOaGWrc5eHz6BTkcOrAoOesYIM1RhJyVw3p0MmLVi8Lra5mRaaPVwvkx1j6+8tiO0IvAhWWnBSwKwqz/r7weF+hW1CFQVKQ4SQW9fZNmzOYalkEEQGCW5Y3Goyqj/tURJ2s1qBZZw7CJag7w7EFFeApmNC3hq0pCxC2n/9r6iry4EZY2Wqz32SNBGQHYSablSqWWdRpwnnSeVJ9l0tURaQjQXV4m+DH9+vsgLpSRbVJTjlEcqGKulWF2G6ajO9ZojqiAODEhXP1bdUMUo86M8BqVUpC1UiwO2rlci4+SKwlHIu9cKrov9Gxlc2vXy1FIsGqs95vnznpIMqwIARvrS+/nxi/9Lz62qOdSsYtRayOD5iblW7xlUupNV4GfidB9c/ty87C3imwaQd8KH/sKi/j7iYTVLRPyAOwYXP+tbUPmQxcA+KSIg++ejrlGSI3w6pXS/hROvXGTNPRF+Dwpj9M+N4uYZNTEewkd5NSBEZYICRiLjv0rUpvHb+Uq3zikgN4ceyIwmJLjypkRY0YIpyhsh58WmZLtvfSPhek2OQ2jBWIf8oEIrLPpLWqLRgIgxob2SzeTit1v9sBZZrygL0ATCHwBGQ8PmEqIZHbA+l78nOFOgq6Hwinn8Fhe747rB1WMZI6wwwTABKuwOy99CuRlirldGzMxz4t5eEsVZhMAzfnJ+m9w+Ir97XEFliBajMLjTp3XjDsQUFrcmZ3yhbvonP0WJvbkOZwUNGQNVpkIfXhhA7B73Q5KtPMiV5Tv8yDr0BlivtwotPEKNpA2KEit+ck00sbOqErV
 kTqBqMu5
 0sNyZFmU416rsTRqLiI94m4HfhHdL/L0MM311R9gAqQ5mpX18onjYyJaYZrZc3zDGsNSPIaGtqKHlFRFWWYgHuQQ5eGS5UR/j4AbaCrbbDmFR6gRk+DdA9iUvCAQuMX+C1nUuTiZYd0Py3kykCvyumzYxdV1t4n/HI6tjgqek3Yxr+sitDaV1CHIHRfZypDJMrr3q3mcqg+RWy4hGwkjPV1ngvAly6crDadsdx1DGkycQcZ2evhRkGSA5aXK7wCQAaSy4oPHj4uZfqBDMfhxJmlp6Jiokw4AO2TOxmwEuilCQ6gABYa1UVJHU5oARMgyKPOoAPix2DSIodp9NkIuuBIw0v8aNnlN6kIoel0BKdI7SBczMrCnr8KJHxztHRflbmXwi1N8dD+Pzb9pu96UqfcpBvA+sMq8R3s148et6NDmZBWCD+haieFNR5DcKrHpxgLJJaVu8R69TYktLuc453ELaepkolyBK9r/b9wJcLd/bPSr2WjX71lJ79PxQbqT9TtXtkn5iKqLbOAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 4:43=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
> >On Mon, Dec 15, 2025 at 8:49=E2=80=AFAM Wei Yang <richard.weiyang@gmail.=
com> wrote:
> >>
> >> After splitting a large folio, it is necessary to remap the resulting
> >> anonymous folios.
> >>
> >> The current implementation determines the end of the remapping process
> >> by counting the number of pages that have been processed.
> >>
> >> Since the final folio in the sequence, end_folio, is already known and
> >> tracked, this commit refactors the remapping loop to leverage end_foli=
o
> >> as the termination marker.
> >>
> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >>
> >> ---
> >> v2: move folio assignment in loop
> >> ---
> >>  mm/huge_memory.c | 13 ++++---------
> >>  1 file changed, 4 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 40cf59301c21..fe812d9c7807 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_stru=
ct *vma, unsigned long addr,
> >>         return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio)=
;
> >>  }
> >>
> >> -static void remap_page(struct folio *folio, unsigned long nr, int fla=
gs)
> >> +static void remap_page(struct folio *folio, struct folio *end_folio, =
int flags)
> >>  {
> >
> >Do we actually see an improvement in readability or performance?
> >The existing code feels a bit more readable to me; nr is clearly
> >the number of pages :-)
> >
>
> Hi, Barry,
>
> Thanks for your review.
>
> Currently end_folio has been used in __folio_split() and
> __folio_freeze_and_split_unmapped() as a termination marker. So continue =
to
> use end_folio here as a termination marker looks consistent and improves
> readability to me.

In both cases the variables are temporary, and they look fine within their
own self-documented contexts.

Now that we=E2=80=99re crossing two functions in the context of remap_page(=
), this
doesn=E2=80=99t seem to be the case, though.

>
> But yeah, this is my personal preference. If it is not the case, I am fin=
e to
> keep as it is now. :-)

I personally find the existing code clearer, but I=E2=80=99m also okay if
others like your new approach more.

Thanks
Barry

