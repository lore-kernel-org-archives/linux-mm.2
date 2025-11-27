Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A144DD116E3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC456B0008; Wed, 26 Nov 2025 21:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83566B000A; Wed, 26 Nov 2025 21:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98FB6B000D; Wed, 26 Nov 2025 21:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB2CC6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:07:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BB47BA529
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:07:49 +0000 (UTC)
X-FDA: 84154751058.11.F38D30A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5ED8480005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:07:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdUv72nP;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764209267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QsXO0/ltkjNthAzb+5fKgAw5xy3VhugmfFY3/nPKRE=;
	b=bgl+iG/9Ekcw8G3T5aYNpZ3+3ZLbnd/WoH/HCENhtMJJqejtmNDD8nMqYMOunt1OeV8sz0
	kH2iXzWa4qk6KKAYE9XHnxIoDPQ5Gvyar4ZxnhLOcA7fw0ri55uk7U5PCvv71CBGBe3B4k
	G63xqsSZHrC0m9cjy41IF0RUPT68Mjs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdUv72nP;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764209267; a=rsa-sha256;
	cv=none;
	b=aGJGXakps/R5Lza5zpJGTrNZQzDdReW+0AWndao9c60l30VQ+cx18naRQAD5cCnD/A73pd
	8xyiS31ZorPqwcH7siMZABETbj6kBqyr+yN4cKaVfPiWRTrN5GuM9FnuPUDnTRbyVdPped
	yGWwBpNgpx6MbfWE60NXFDJrRTntpIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40752442C9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDEC2BC9E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764209265;
	bh=JyHQau1jPePL4iE8/FInYHImDcBfvBwFSfIQr6jTBFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WdUv72nPs0kFbBQAHrvG0X8cCDZ67FgklgJFA6RPTCM9pn8sq8T6kxPDlPOPABh8u
	 ltq2daAuWwDTwnMyTtY3Wx07zz3nyUaq/uXGsirZj1vckZyhO47RFT0u4e4Yyco4Im
	 jI1mJJEXOR54jM6gFtp4BZe6HhHqLQV3KGO7JineRR6IxA+TKKoNT/Pkps6UtbRsBl
	 4vy6t25pMuUVtsZ5BCxY0lEy1iCRLfHWiVuDxM1ejCb7FMe78HOMX1ZcHuQy6u93EM
	 1ya8aNuQItdTHfUT2PYekBfL32k1eSSCLTyab+kciMu2u2eZeMwb9mDz6csdi5B/YJ
	 tfYEHBe+CRpew==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-63f97c4eccaso346557d50.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:07:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUKz/Zyy1o+quSvqubDDc3URVwWrdV4ql3+0rBnk3RdB6B2zvZZ3Gf+deLk+wRMmopI6K4jt3lomw==@kvack.org
X-Gm-Message-State: AOJu0YzvgxtmDqh1S/PhfjCnMWkkb6bNFNeZjbMKyID4nY/U141zxrQ+
	n6B+JpVtqiTVQRxHvGAvAUoFXYbogrV3FTd3q+JZivlri9SZFMpEmwynUlGLl5sBav5GatCf847
	kdEAhpg804/F+DSWQVn70UlPoydk3jlFx976eq0M1yw==
X-Google-Smtp-Source: AGHT+IEn374zuoN9lEsxWsZrkcYzSc/EPORRtiXRsCSQ6ySKFR8BL1scZhk2iSxr/sN75jDRTpYcONXC5+0gddS4g3I=
X-Received: by 2002:a53:c049:0:20b0:63f:ad6d:cbd5 with SMTP id
 956f58d0204a3-64302b0833cmr13343599d50.60.1764209265172; Wed, 26 Nov 2025
 18:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
 <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com> <3e90ccb0a3fd20e9b2d6e2cf19db9590394f7edc.camel@surriel.com>
In-Reply-To: <3e90ccb0a3fd20e9b2d6e2cf19db9590394f7edc.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 27 Nov 2025 06:07:33 +0400
X-Gmail-Original-Message-ID: <CACePvbUCeEu3dkq-M5fL-k-bca2c_h8A4HTCmLvRaV1aFW5qnw@mail.gmail.com>
X-Gm-Features: AWmQ_blNlEbVyFNEJxbqxeg2gLnmmrZ7WwiTA9ZVkvs52cNRrGuTjxtkq2EOfUA
Message-ID: <CACePvbUCeEu3dkq-M5fL-k-bca2c_h8A4HTCmLvRaV1aFW5qnw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Rik van Riel <riel@surriel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5ED8480005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: j8qo39e41kkqxm7bsm9t8aefe3darccx
X-HE-Tag: 1764209267-789843
X-HE-Meta: U2FsdGVkX19Gat2ftBraPSiz/l7vSc+SvNfsIbnHb+v+fAb+5kDm3YuhlBrRGWWTyUHBJV3ieyIMCBOboDuqwSgBQ/mcgRHh7Ox51NnKm0vqYz2QkwKmogonSETP38F+AXvbEsfYU1A3G3N+fjlgB7n4gRLRJwifsReY9xFpe8phXJNAhVDQb7s/vInXAn3bM4y2Hi77BG1RASAJMKb52dEjwaazoRu6h67G5vfQRCzBEuVSxqp0GpZbHuHhdbbWd9BLe7J7nCIKQsn9p9ycp+NfamEIQhkWujLMZ15Mm6biXCVCXheKWJkKBsE5SfE9/izlO3Cj8KjfXkKvSNnJRyKLw4sdPscL3y2fDfvLGLGrB8rDaRuSVDY7u1Ti5YryrNcSjKlbwrGxxFtvcb3ZheEvdloR88uYOzq4P0uDP78Xf70bQtmUpW/JCf8wFlM3L9fdjj9OM76FuY6FlhN7+fDDJFXFyMCvwq3wTyQ2yxz6FvIzgYAx88qXv2U7hQZ+Q8OxuwkNo+vCShCwc5Pfvg39n/USvnYs93LUyLj5nH6dTiV8cMs/0sKxQ2s2I54v+jwCPD3YAKBJTAAORkyyN2QQWZD7BJ7vE2Md3ac91oMdxUjaX4W4commL3UsmGVDLuxldZ9+CxigOgJJ5DoLU/DEYyqrnV8ovyYbPxu/3Dv5Dztb7Ao52KvXALL8igXNGJsFt0TtQtDFIX3ObnqK6GkfvPssU8RMt1wrF1GJOUpFwZ0neOKdsm/xbf+4Ny4XlRMg2eJJAl2qX+fPY94frFkSj6ukmHKuHtiqeWY3gKuclB4tHJ2JjKAOK8OKqgGE2lZMR6Xa4OqqaYTA+fVgCWp/cx7RD+1J9nfJt0yU9SQX+o1mzXZWb6KMecEVR3CM0rl91nw9SD7ibjG8jYuVlF+IUD3gRzWWZGGFuLjcRHKEHVP0wRx7LMSPMnWTxe7z/0TMRosMd59Qjt4LED6
 oFAy/2cK
 7XK7cNCv4gJpGJHOi62CR57fk75RYpVCZekryRzkllE8zri5lj9QKQ6Fb8TQsUBBu3mNGlLpY7Layoh8oqCf7RATp+3DElX9K2z9g4gS+sFs+z3YcxwrZG8iHUZZYfepUxfI/BKHHlRaYslMY5Ulu9GV9NFQXlRA59yRvGyvqN//OMLzvrh2kNsSiUfHOhYQlYTaqUuaC/gFFp1B/5mu+NRlsArr3NirKyMMErFFk7fCT4vv679peHY3uRWuxv/yhytnM+gtHX+jbB2YKv1EHK9F5ITT/Ea+gLN6rO2SxyJoLMImctAnbxU2Wvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 1:59=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2025-11-25 at 22:50 +0400, Chris Li wrote:
> >
> > > - We still cannot do swapoff efficiently as we need to walk the
> > > page
> > >   tables (and some swap tables) to find and swapin all entries in a
> > >   swapfile. Not as important as other things, but worth mentioning.
> >
> > That need rmap for swap entries. It It is an independent issue.
> >
>
> Wouldn't rmap for swap entries be more expensive than
> simply always having indirection for swap entries that
> are in use?

It might be, to be frank. I consider this pretty far and late in the
stage of the game to evaluate the rmap and its alternatives. Do you
agree?

I might or might not try the rmap for swap entry. Right now I don't
have many data points nor insights.

> With indirection, swapoff can just move pages from
> the being-swapoffed device into the swap cache, and
> if needed the memory can then be moved to another
> swap device, without ever needing to find the page
> tables.

Ack. I don't think we have any disagreement here.

> This sounds like an uncommon scenario, but it is
> functionally identical to what is done to pages
> during zswap writeback, where the page table entries
> stay unchanged, and the swap page is simply moved
> to another backend location.
>
> Why implement two things, when we can have one
> thing that does both, with no extra complexity
> over what zswap writeback needs?

Let me ask you a clarifying question, then.

1) What exactly are you trying to propose here in what project? VS or
swap the pony?
2) What stage of the code change do you have in mind should this
change apply to?

I can't speak for VS,  I am open to embrace what you suggest in order
to swap the pony project, that is after I understand it first.

Chris

