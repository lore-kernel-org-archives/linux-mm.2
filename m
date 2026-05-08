Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF40CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17776B01FC; Fri,  8 May 2026 12:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979866B01FF; Fri,  8 May 2026 12:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4666B0200; Fri,  8 May 2026 12:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1726B01FC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:53:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BE2E1C057E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:53:51 +0000 (UTC)
X-FDA: 84744849462.19.AFE1F3A
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id DEF4840005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:53:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=do2BJmNo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QaoHM0ZCmmMCsFlDINbW+hCiP+12jItyCcYa0Cn+33w=;
	b=6g66fFGPE39zCJbk2FNGcjrHEfefExA6geRMFuFlGyAIaSFPdrp3gtRctLIC4i4fncb4zX
	4adO/LhvqfwpHlUm/nflnIvqOfLDBSzXewEa4bNYZCC1QBPXsEZ7pznV+YE9QHzqHHEoL8
	o7LwTy7PD7okizryB9v0ml02qimqYsc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778259229; a=rsa-sha256;
	cv=pass;
	b=3W8A1C5yKZm1GeJ22EDXaGoJsYrQGrhM2izgj7mJX8FvzLp+7pF2zccqBeJisepjX1Hg9I
	xStVfpZV17/C9DQY/AB0xudtXrmPTN1IE5JJeCqio4qhaP4Pb71WP1mgyxkOBYHByknxa8
	k/cq1wJJ3As6YhMAcoHzY3f+wfZChh8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=do2BJmNo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38e8292423fso16235431fa.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 09:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778259227; cv=none;
        d=google.com; s=arc-20240605;
        b=hdif5knlvOHtMRfWx5SCBj0v3bjZZx64mWOIB5NAy5m+rlPFYvo0uKnA+OygUCrapx
         FWIUw1Ow8g9dujz3pZI4KRZuo/Jk93mSSBfMmkck0Ozz1DofR982YRLxR/MxmqR+IxND
         xUvvg6JSuCozqZ4y6S6tWpaFZ7lls5WeMBYb5pT/vdR3sNmHJrVTYZzIiHfQFt2+rui7
         qV6S09GJS6RKdpzAqWgx1DkiPoKJyUm0qyjAnCBfQ6M3yNDBRRynyDLLQ+TGWwJGyxBt
         x5qPamIP1YW7dcfC9P4yBaWvC14eKTS2tQtL9QzWoE+wihgTdqdePSqlWpAMZM64sbl3
         MtLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QaoHM0ZCmmMCsFlDINbW+hCiP+12jItyCcYa0Cn+33w=;
        fh=mMklXL5h2gUedig8/iS+g+HGqqgRNdyBuWc+AOUmJbE=;
        b=efd/ndyAWWAVv4rBE2bRcSsHhgf4htP7vUmpgJ/z3BK9Qr39CUgenlCEZGU+WbR6V7
         iW5miYB339afNoZ0jO/3dlah8CJNt8ftdRJEujLnt70KMYKjFTTwH0FYICAayelkKgJy
         3vJ4zbLjsPPIVwutRwutChR38EI8LqH5qnA+abw/YdadzHjDXys5fYKewf2Wbe3lxgCT
         kUivdicDPTP/JqbTk5GqtyoAM/6le1mg347icFg+El6himNgk4XN6ORrbljKYV6Ln60/
         x2EWHX8dVBWW6CxtNywPEX222sk9dU0VNMccEMCfS/L10y4aERXKUogtlRG6olzDdojg
         R4Dg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778259227; x=1778864027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaoHM0ZCmmMCsFlDINbW+hCiP+12jItyCcYa0Cn+33w=;
        b=do2BJmNon+taeDDxPMi9UF5nTZ7tVjH0KRVBznmSbSSSPro3r+wT7H4hgSQiIAxkbH
         32KY2Vsbk8v0Kh6ls2zriHE7ruaIDzz9LVWfRjLCGwPDSO1KAUhnuCnTuBRfceNLi0rK
         teOB9jGWnFltFkXwSAblfoq3BnO4m4dI0ld8pnPnvq4jldq00xs9MmiFzVg2N5nNtNgi
         DZbQ65PUO3d/JBFNpjMhJht8rGBZhaFKJ/VK1YNDbRs7EQNVpU6vYpQteezEfoSVPON5
         zeaLD5xIhY9ze6dHODL1B3tjAA7EbGZeHD02Q+bqOxAwsoCiguYMeCpxUTAIVrmif8UP
         xllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259227; x=1778864027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QaoHM0ZCmmMCsFlDINbW+hCiP+12jItyCcYa0Cn+33w=;
        b=L6wOUJCqiKjeoDKg4skXkapVwS0nhDO1+L5HG33JRhlRuE4MUJQQsRxC2j9CT7StkB
         pz+LCbretINrp44/Pk+bvxbROEH3MkW8Jcn+3PHUxU149pv7GBH7v062SIm3P6XMoueM
         ScoENUoemoq20gLXIeMMpzHwYtMAdw/Wh51b8lHG4rm3bEsiCAc1V9zn8fwBFb/DCTzJ
         HEykSKVYbbxkRHc1bBrkNqCXocVEukhknNCtJXYwiw1/2jgtkTgLJfSKdYcJrKo9JChV
         mf7hClYfOugpVQDHQYsL6iFcSguVOR/aCUG3a5utLQT2YeQuFRI+cbBCAMcPxoVaTEHK
         YIcw==
X-Forwarded-Encrypted: i=1; AFNElJ8KSonpTMKCLaxgdUEbxbzlN6wBiAzbFHJkyR0me8nFHReaCTBx7PcMevFUbOVhvdqJOdBks+4zlg==@kvack.org
X-Gm-Message-State: AOJu0YzhxuEFqm8m7c0Iiep+bJhcctdRfPuzWnnFRBP1e+64aHpeAjFy
	Lh4/SF7ES7pRRAiFvfSm1GYxpj3dGUkNXjYDqgIea4Xc+HyR8JxdC6UmzmGWuUsYrxT7P5IRvyO
	/2eTM/cRjsseUY7bEB5NthMEEvacsPAY=
X-Gm-Gg: Acq92OEB1nioWpPCIwzFCD0uZZtKVOBFg2vCkiAj4fydqBxu+q0wWgFaNfkgmeV3B6u
	YUABzU7lrRamh2xrHUcHIivsATLEzB5XViT+OAYx1ZN0yNwybawddsL/delpGIXuchgd+y3jisY
	of28ujo0nhKdX3SSm5+IRGAI7BelZVwtzUrj6nFxPddhpvwDEq8ZuqRGi3u1qjVIfNYuwxI7gAj
	/BfJSDBJKTabhMlkG72iOjQI1Bggd84hIgHwCRV2QqfXgDuDVOZQJsAGBMzNMU+ozyU3M8Sgu9o
	WJwipA==
X-Received: by 2002:a2e:9807:0:b0:38f:e9fa:266 with SMTP id
 38308e7fff4ca-393c43492e6mr39138871fa.31.1778259226695; Fri, 08 May 2026
 09:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260508150055.680136-1-vernon2gm@gmail.com> <af376QFXC36uf7kp@lucifer>
 <af4IEwbAAIYUH0z9@lucifer>
In-Reply-To: <af4IEwbAAIYUH0z9@lucifer>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sat, 9 May 2026 00:53:35 +0800
X-Gm-Features: AVHnY4I9xn5qVPzznLhQUYYLZZAVQPP79rbvSZlePl1QwuMT9t3JE9qcslwsgOg
Message-ID: <CACZaFFNdk5EfBxCTT0WOPGLiG_01wNESem_DKAu9SK1hrzBhow@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP
 more transparent
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, roman.gushchin@linux.dev, 
	inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, 
	daniel@iogearbox.net, surenb@google.com, tz2294@columbia.edu, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DEF4840005
X-Stat-Signature: 8osb1iw889b3y9zmkayh7oxjeuneepqq
X-Rspam-User: 
X-HE-Tag: 1778259228-420276
X-HE-Meta: U2FsdGVkX19rmqyWB9iFxadltNx7+T9MDl/R1wSRMnmR3v6hZugLj0i+B0JmkiscAkltJh30KkjMCjwaMaVfEcuowh+sTowdRJ4+Mdodh7mpcSO4kgk4Pn3W+NMU5F6gU6AMl6WqF2ilI497NUrtoP35xGY2+f6VKRAF82ekgxRtJn1+YU1lAZ8vNQlK7iEV1t0ot/r/6oHYxfnd3d+bTw2/ov3Ze8MmsW86JhrpqjQZuN0EzIUXp9WOe3D1kNzHiqjqSH99t94ZVEYJD4GUo4QricF1Up3hCl5GqhO1Wx5cBZ8tRo4UuqdF09bbJ8f2C/RJhcs+AJQBfdU1+FyT+qiNT2VVRYmPh4zbOOuuOZgWf/7sKkJ1PWGDOP3Xwbjv8v5qFXis7VRWVW/Z2JJuMa47+Cgg34HG7o56bglXAcEqmVOIMAW5bzPb/zHEIM+roLW0gYZT/iyXrfMeMYym8uugskgZflvQHPXrEwwwgJLXn4cX/OsthpoIeA045lus4LLKYYZ1aKQVEVc52003aOcq34s0UphETCl4PyIdKtsh+1W36FsqEHypfsOHnT5UiI7aRBfSx+G2PDwRoFOkIUHis2ZBFA1pejiHdefgytA12crMhqY/tUD3YrND5r9pFRVeo7xKlYiyN1ts4RA4sYxxjWCUex/OXn23V4uFNDTwKV9CL11WkqDIUClbGMXfpKLP5iMhSOm9Fg0WN9VL6aEPLkkB1NSk1axpa8bbcSeVjF84X0x6xqZ5xxYO+1S0c0xhHH5G6nrKe7VKaHiXBCSZvnbHgyD4DIAdGwpj9Oi4PsNnssIbgJjceFFgpUfUcwSGh8tLe64tAfzZeV6NfSFv2ARer/4Gx1/qsB9VbTYIOd8qABAw+DUwCmgiveaARV6Xr/iKawq2/ppLGqcDCVgAUKu84mL9H+lgfa5Z3rVfyNx7PKfyU1fSXcE182L9n9PJyhJmOZjjTREdvci
 +aT5aHCZ
 0G/BfMy+sIk3+2gPRLFjOUYHCpAGshprjpkCTHRXeg21DAfXtMnrLZVxq7d2s+iuUBbXkKRL0hRNvAwbC49zn1AViS797jf107+RiRe3T38bFsI9Ky8xMGZMcm0FEHwvo5+snNxcqiydC1lw605qM9J9EKIbyJ3CbXvPlA1dRqRDmwjL+dQGpZFUXsC8ym4AzGkSi1xzjVPAgiy0dN8eCnkcKZCkZGFaZy/WoEe3kq68lTHmN7iNFK6p5wSlxRDv02clCU+1Jyj2UyqDH1+EDwKluAvm1LZUHx3+QcT9PXEcptgliN4FdHjX8VaTRo8ocswj6Dzr5I9peQGvJxQqPf4jxRdn7E+fY530L2ZkH23777x/6Rx8yW2eArh3KwfZb1BcjUTWFQoDPdVZXLv5Nu1SSn69+W8DmBOoHyPUNCP6pLR8lssfNXSb3qkr1sVaKXq+N5KWjcgXc33OyiLpxF1VNEsQw+Bb0Q5UYdxQzOaBtDUyMFWoDX0iNHPaxxtKQWkI8iGLGE7uGZDu/x2/boXt2U2rsEMQ+WUvz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 12:05=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Fri, May 08, 2026 at 04:15:04PM +0100, Lorenzo Stoakes wrote:
> > Thanks for the series, but overall it's got to be no to this until THP =
and mTHP
> > are in more stable shape.
> >
> > And this is an RFC, you're trying to make really fundamental changes he=
re, it's
> > almost... rude to do that out of the blue non-RFC'd (unless you're a ma=
intainer
> > perhaps).
> >
> > Right now the THP code base is a total mess and mTHP support is not eve=
n
> > properly merged yet (khugepaged support outstanding).
> >
> > BPF interfaces are permanent, we've tried the 'experimental' thing befo=
re, it
> > doesn't work and we'll not be able to yank it later.
> >
> > I've said it before, but we really truly need to get THP into better sh=
ape
> > before we can tolerate large new changes, let alone an user-exported in=
terface.
> >
> > So can we defer this until we're in better shape, and then send that as=
 an RFC
> > first please?
>
> Yeah on second thoughts, NACK and don't send this series again please.
>
> I was already annoyed you'd send something this invasive and massive with=
out an
> RFC, but you've also ignored the feedback we gave to the last THP BPF ser=
ies
> while ostensibly claiming to have taken it into account.
>
> And then... I mean seriously... _shamelessly_ trying to take control away=
 from
> THP maintainers and reviewers who work bloody hard for this community by =
parking
> code that changes mTHP behaviour in an entirely distinct and unrelated
> MAINTAINERS section...!
>
> There's a biweekly THP cabal meeting which you didn't raise this in, you =
didn't
> bring this up at any conference, you didn't send an RFC.
>
> You've sent it too before we even have mTHP khugepaged support merged... =
or have
> really stabilised on how mTHP is supposed to work overall.
>
> And also I have made it really abundantly clear that I want to see the te=
chnical
> debt _paid down_ before we add anything else major.
>
> And as if that wasn't enough, AI review is finding endless problems with =
this
> series on top of all that.
>
> This is NOT how to engage with upstream. Again, please don't send any mor=
e
> revisions of this.
>
> And next time _engage with the community_ before proposing something this=
 big. A
> [DISCUSSION] email, or an RFC, or in a meeting or at a conference, or eve=
n
> off-list or on-list mail, something.

Firstly, before mTHP stabilizes and enters better shape, I will not
submit any new version.

Let me clarify a few issues:
1. This is an RFC. I forgot to add it. Sorry.
2. There is only one issue in the AI review; the rest are false
positives (the AI did not find the dependent patch "mm: BPF OOM").
3. Regarding placing bpf_huge_memory.c under "MEMORY MANAGEMENT
EXTENSIONS": I never intended to take control of THP away from
maintainers and reviewers. However, it is still my fault for causing
misunderstanding. Sorry.

Also, I would like to ask: what work on mTHP still needs further
refinement at present? I can help out.

