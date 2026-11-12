Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F9606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 23:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RVNrKQ27
Received: by kanga.kvack.org (Postfix)
	id AD4A26B0621; Thu, 12 Nov 2026 18:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85C56B0623; Thu, 12 Nov 2026 18:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DD86B0624; Thu, 12 Nov 2026 18:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 659A66B0621
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:50:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D73B4422A9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:50:39 +0000 (UTC)
X-FDA: 85428114198.14.21F73B5
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFF49180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:50:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RVNrKQ27;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794527438;
	b=3IqqtBrCvM+kM1giFFQWPTMt3SYWtThEdbJnhm2X9QkMLF2VcuV6ih6dwUAzfOy6HSLPYD
	uBMTWyd6g1m/7s65fcfTF1mecljXYwV8Kx9LeHYaXQj9C784eeEYYe+fjQk04B0jlsw9PI
	sGbAKWN3EQ5jJsL1UEQEg5ZW2hm7mYs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RVNrKQ27;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794527438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YG6wgH4NYREC3sczRPjJgVCvMzmzIvAQZxCNlydueHU=;
	b=Co0134fkY9jBQ/Rj0+FE90Fb21w1wwlDmquDjvv3mXdh6mcvUlCY5sLPBkwVeMVq95SGa7
	0RNk+tFWJlZjBw/gW2R7/7dIyiMnTCndDmbmaELzrawN9fLoh9iPpcU4fa9IoFJxSOIZvx
	CV/IktPZ64VO3+DBh5tsLhsuZerL/7c=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4922dbcee23so150668f8f.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:50:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794527436; cv=none;
        d=google.com; s=arc-20260327;
        b=ZjCGrvAjrx34/hUCVpaASpgGFlsBCznEU7rEs2AF4DF6ccMf/Ipm4BlAO2l8xrxhN1
         sXIzgaOj+U3o59FV9b3UqBFmsSyKmN0T/8zRhCmwwCMWjtPT+DfoNVoCOKVbfzi54tyH
         UG7bdZD0FealBxjBJT96xPX1l78yFMlD+VQtFreofTYp746/iAb1WCA5SJSyZie989M0
         NujzWu0Tay/TlfIKSTRgeYj5N/rhDklsIW32M1B0B8z1fv5tHbu1e99eZ6+E+tLYkp+9
         l2ZQTVnGj8tKLIb89ojgHVd62MXBB2NLcZS2T/mkV8LPy76Lk2U1tJS9uZf1WccjKibF
         dD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YG6wgH4NYREC3sczRPjJgVCvMzmzIvAQZxCNlydueHU=;
        fh=MIZh3jTd2wZM1JS/vshSZPg1gjm4lugu445u2Xro5E0=;
        b=lfrDhaRiExZ/BZ3HqdJxphvbKNQUEZ4Of6S46NYGG2gdCgFeGziv1uDSOIVVhb1Abe
         q2Q1DePCaRdKpparpMs8JBq8K/r+SwBhCP3vDnG1VyNfsX/pS/R0xJzlNLqX0HlLjskJ
         j31ErPuY70q+M49f7LUI8FC84dFbcV8YbZXqVpMWFyP9LJMi6gnq5L4/HmAQsWes7/4k
         jQ9lZ6K/t+oHI+8sDOPUp6xtTHg7Ea3dWgJPLhodJ2MQbDOIC1IMoWFu4jOnUSRaOcRF
         yf35Tq2mx5O7TFWnOcQsF7/g7Ac6DHM1T19MFyBDBj5+2Un6vKTpTp/Bwu9tT2Y9x0ZE
         yoSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794527436; x=1795132236; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YG6wgH4NYREC3sczRPjJgVCvMzmzIvAQZxCNlydueHU=;
        b=RVNrKQ27Uz1q9o+6yJpwB1SHG5U42kJJ14mgfuRIsFSfOUf7l8d5y3PpxABBUCdJHl
         jT5gBYUyRmWpPp7Fat61eENgJZy1ndqTqGpYY4/+3pn+HhjJskU4oVB+RsYyoDXB9r4S
         qg+eNsA/g6ttU5cSh2YTI1pa9Qxtl9RJc24OChtAvbYojX5eDWpW0ood1aJ/C1BSWM/n
         P8AAJCY0PeT1KenbuJL0QBAJimowHN13aa1eW7A5UYLJmoydyZlB38hyGUqr6aZANlKy
         xEtw9eG3W97bOI20ItxUPHWeERyFskw23bnf/bZ7cUML9336WH8FldNihZm5NkeD7nH4
         nAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794527436; x=1795132236;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YG6wgH4NYREC3sczRPjJgVCvMzmzIvAQZxCNlydueHU=;
        b=jfyY1Vl6fjoIqRXkWJ15XjkGt76qKvbUh71xeg+hbM/XSDf1kKmTFEUVgVk4CwWG4q
         fB42FqvYG6w1naFyBW9P230Gzn+nbzSvySbw/BVPOSAX8SqoEN5pwPet/X4d89j2IOSe
         mulPNX21xaPIHlQYU8Uh8iBuDwfgQWeaGoMPcmx/B4HVhFfK0GEw42hRF0FyHDSdqja9
         FOS3dBdmKciTvr04NBh3LoGXEgvKNUZAD2HZIRuCwsbqEjjup5Kv7+BRQm53NhD+mWbF
         2R1OLm65sTwNtlouJi4d4MRntFe1y+lFyIWCt83NNh1TJ+jiG3VrTA5lD2S9oJUF2U2u
         RokA==
X-Forwarded-Encrypted: i=1; AL+hErEte3yeDeFHKEQHI0EUaGh4dBCj1uHKpDc3tHilB4ZUdWk3MajrDUnimsPF6fM21olvuXMkMbdE4Q==@kvack.org
X-Gm-Message-State: APuU4Z+aaKu27jLgLGBX123MRR42nH/DKHAo/nbyku9ZoV71VqSbWv+E
	Mm5dXMEXKq0M6oqWcd4ARH+0jxBqfO9Gcmy3qKftd9vFRSMtNUu2rIuqqLzN2c1xG0o660RTblL
	UBI5c3+cp2gMRjRpUKJ1uHTeNiQIXqiE=
X-Gm-Gg: AYBFou1bPm0fBFaAUv/2lR6Ru8CcTYvq0C32p2oucTMsEkPT8jaS4m0e5XzWVgi6Wmw
	tCVGL4A5Gqb0M2m6xKUQOIa5MEdUOVM0+LBuSdrf7D03rVLWPE/xG6eQSc/CSs1IzgBxO3SCLza
	h7Lg1H+NrJed48962g52pR770HfbRt3UNF2h1DGnOCM0QDzgss7BghDs/pRF4vXIsdYULenSZ9V
	Xyf1tsCRjodz0G/CXsQ3I1ZpXgu3BqXD6mD18BpVFIPiqqWWh+Anjwuiyn5clngM62/I6u0Qx2A
	K9URrQ5sZQPquRwbZ+py1IahE2Oidl3bYaFeNlwUrJRk/CNL0XIwQbaQP3LNNfOkF3Y74/jROXG
	ZUlQUU7+BjHJXPrtWNKtzEogG9ljLOCiZ7M+rLIk/rXLU8/tgUV2D5Voe6czrJZsBIkH7mD5jvH
	x7oFKXzgzCCbXLnn+y2Q==
X-Received: by 2002:a5d:59c9:0:b0:48e:bf0:352 with SMTP id ffacd0b85a97d-49c6e68da9amr2380781f8f.5.1794527436420;
 Thu, 12 Nov 2026 15:50:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-2-joannelkoong@gmail.com> <DMR874E7OJFG.160T3TW5FF6PL@nvidia.com>
In-Reply-To: <DMR874E7OJFG.160T3TW5FF6PL@nvidia.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Nov 2026 15:50:23 -0800
X-Gm-Features: AclHuK_3MjZTlmO8UhZN8NOAa4yfi9CpqH2r-h6q_5ZPIs6irn_rE7NAiMGuwd8
Message-ID: <CAJnrk1YgyS9VE6FCrAH_Nz=2+XnnRg-wa9yuE0ZhJjQCRedVEg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the folio size
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, 
	alex@ghiti.fr, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFF49180003
X-Stat-Signature: 7kq3fpdrsuqbk8sy66fpucr7anrtdiik
X-Rspam-User: 
X-HE-Tag: 1794527437-390053
X-HE-Meta: U2FsdGVkX18U2USH2oHAURlMLvS/sPdOhYbQ3kJO4DD+Lc8ehFAngojv7grIhD+KEz9Vc8gRl6yW8pkc9bTVRh5pThpKt790yBhLhtf8kPlTi+gJCPyYg70alRdHWUXfsfTl7QQ8NBgzVtXrHsSfZh5jlFhS6OyfgNolWXcYXgBfGH3kGchhR6FBsvBA3C+ExHUQorOKGBCQqgW3do50yQdtdZauGuqDG/h9tblGsubd3kha51LqPMqYTHkHKwF6SXghVVdR526oLy1F5VbBf6Q0++4W2lvpS90w2quhxEP5F/T575gjuBy7/eWhRBagUUe3xqAMru3xp7XgZIl9HZQxUsbiNRu/+o075AV33pysoPTK6P/KMrFaWAfdBA1VvytHfpd3aIpzjR8fff3Bmy4YcFrdyzUoi6AZiGTwJJ+nwg1zPE7DpEjI159JfdPx+ETPnQrtd3RHggRvGyxpglc5D0H7/giz5xviiIo8IpJNBN2T3lj6nBF0oJ5JQVnm/aIAIow+fn6bWS0ifAyypBhjrFaL/VC4go/IvQLtbfr+GpQZxqYz6cRrfBqloQcruKJjKgKt4iuP/KQMctZXXZtYoh8agCHdIL0erT1xn/OMqJ8OcLTlH11w05D2N3jlPtR827gbfPRRq97OSx0UptwgSheOJNYomJytQ8fxuikFJu8SIltXmkB8O/WB+ArStZC9WA2YZU0xlGvQDvhz45KIIK+96+BB1DyMcG6uXuRD4aicUQ4Eitvu/Dfv+SFIpkT7zP4J40iX0KmwwSTVWXt4ok0fA77ZQUQaw5FEnUpRabRrk4jNB1GmkAR6Ax5sUgvkaMQ8Cz8LioCzCcHebQFmYEl9KrWrQkE2LmvZN7zg1IZzzvnXyaDHHOBM4r7TECESz6es4E4GmO31Er0thyjq5pFamHaH7sXNiUGJRhnTY2eFi1kmVaAZmeyFp47Hz29jfyEuJxWx79Oa7gy
 oU8myrAD
 D+tHoLkb9EGk6NXFYyCayVUSI4/qwzTmf2SQIE48EtdQkhUvH8pgGcXI0B2GeBTQ9TJXaK58k6nYbTOHD/cd0saIMUBENA/Ut5eXtDowJK6i0MExyPx73XhQ2XxPJXGNAGRklajS93h86BxBiv2CJFyC7UW85YgYbm52urp/9SiWdBu3lm4mGbiMZwGvUGRdPRR/AYPBK3nVg7bQgev3ipP7cr8qPLm4Jn1Jh4MJ8MdvQ4K9DkrgCxlaYdipmVsy9Zj12EUnLwwTqhzAOttyylVEgU1zpzPXFhHTjcgS4zuovx8QF2ekvHGpHo4WZBgLp5qTlqfNYTLASdy9Jm/vmsQ2515NPHdxoyMqnLAL18pmM9ovoJZ5jo6g9fOupUEkeW5blyHm5oGlp2WMO+MrVLzGGp3NEBWan1yJF1kM/aPZ0jQsnNf+d6VJPLobsA6B8jW6iBlB6t/tVmkEZbXIl8jwDig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

 On Mon, Nov 9, 2026 at 7:54=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 14599d0fff01..3720c12bdb0d 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4625,25 +4625,33 @@ static unsigned long deferred_split_count(struc=
t shrinker *shrink,
> >
> >  static bool thp_underused(struct folio *folio)
> >  {
> > -     int num_zero_pages =3D 0, num_filled_pages =3D 0;
> > -     int i;
> > +     const unsigned long nr_pages =3D folio_nr_pages(folio);
> > +     unsigned long num_zero_pages =3D 0, num_filled_pages =3D 0;
> > +     unsigned long max_ptes_none =3D khugepaged_max_ptes_none;
> > +     unsigned long i;
> >
> > -     if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> > +     if (max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >               return false;
> >
> >       if (folio_contain_hwpoisoned_page(folio))
> >               return false;
> >
> > -     for (i =3D 0; i < folio_nr_pages(folio); i++) {
> > +     /*
> > +      * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD=
_NR.
> > +      * Scale it to this folio's size.
>
> It is better to document max_ptes_none is different from what khugepaged =
does,
> especially khugepaged_max_ptes_none is mentioned above.

I will add a comment about this to v5.

Thanks,
Joanne

