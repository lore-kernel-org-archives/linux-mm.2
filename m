Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD561061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779286B0095; Mon, 30 Mar 2026 17:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750FF6B0096; Mon, 30 Mar 2026 17:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666BA6B0098; Mon, 30 Mar 2026 17:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5324B6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:47:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA42E8C61B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:47:29 +0000 (UTC)
X-FDA: 84604066218.06.F140596
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20B1140008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:47:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Utnp0roa;
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774907248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8Pgus3VxLH1J7NLwB0o5Q4mhGIUXkZIsrToUQKpi2M=;
	b=zomjd+8PxB1GRIQSEizIyrRsT2mUucGbzq120pp7PtBmfMq7dvaZtiF9lqmcj5lNtIaAKj
	wrdbR8BwdcUAwfbaDnI8C/5u3SJi82aVFhT8glfXjmMpo4jNWkgw2ZqH13GaVM3fGmyK8b
	XV2+zU8as8ED1WZ+UsgyT+f84BRydkc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Utnp0roa;
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774907248; a=rsa-sha256;
	cv=pass;
	b=LUnHLlRMiQ6lHW4AA8W+v5XS7Fs0cAMVIzBx231BxwO3pmqd2gLV2l6X71ifuEhAF5+Ti2
	WI/lrXum5UDr5L9Nqe2kxRsddsznUO3T6CXGjpSCpJFb0U4Krafz2rgrV/OFUvIJNJ8f7L
	oAbt6ioQXqDywF6ak44/6P1TdmkQAjw=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b6b0500e06so6684226eec.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774907247; cv=none;
        d=google.com; s=arc-20240605;
        b=WxGznuxHpOLecKeMtRY2mWmsfGZeTAx0ymsU2uNrpIJSTsrY1OTUht6Fde3a28s8EV
         BE/s1t0/X4jLuyyr/wDauyan2ZbuQtFhHZe6Y19/WTSOzBJKxMOrYWhB1zRXWvOnA1Ge
         WFGrJ75m9QHKHPLj1x5c3w9fgS0O92vQXCT0tS49HpL696Mh1mJ+vSe0YI2d5NJ3lr1r
         ugJDc3Md3DHRGMGTyk8ILmfeK86BNBVuLgt/uMHRFL1n0Ln8V3ZtyspvTzFazYmyKf6E
         5SE10wWjEoENPZeBqSqIgOkKG5g5ovlX+IQFGw6D772hBlh9ZrfiMFXGtq4ifCDAlAOb
         tVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C8Pgus3VxLH1J7NLwB0o5Q4mhGIUXkZIsrToUQKpi2M=;
        fh=1UOSkHX7sxNgYZVFcQxJlVgS+fT/Abd7MRq4V5/r0fo=;
        b=gVX8QQsxVbRTenCKTDeOHudqC8oyH7fr9VgaYH9IZFi++57n3G3kmI1BMv6ijNHDah
         7Yk0HLKTm1h+W/Mz/UWn4AZeeumVvK50Xt7jYni5qesZmWK/sUiAez+VF7aRInr2m5CC
         KbxctrfPxvoiVHo/OfHrrzvhQ4s4bFuNM/+k0aj8MPEhJO+z8cjPDRNatC3sh1QNaV7N
         /fhkJW4wfuLmfJtf6mqebIBhIfyfo2ixTUXff7MRMddN+mR/gES14lYTHqg0dqJrSBKl
         ORD3jFlYwxMc9GThgX8KxgQFu8NSqqEEiU9qVNsYggtUtoLXO8WyBvhE+KP58mUhbeHH
         iASA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774907247; x=1775512047; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8Pgus3VxLH1J7NLwB0o5Q4mhGIUXkZIsrToUQKpi2M=;
        b=Utnp0roaYw1i2OYIVJ6OWijWuztnMxPgp5/TbSYqcxH9L8W2IfMB9AloYXze0m8I4y
         egWn83qY9yJy7a5MYNaKfkQYUtSYa4rD415wAxUNYXwmtHDLl50pMqtaqBi4aHCHAugH
         F/mYO7pN3B78pnnXFov4BqE0PJHEWldtlQA0knIbWNHnAKJHV+2y1XEgmoyS8qpzRB++
         DlSRdYA+lgkfr+GysI+0YBNMXGI2nS5/2HTD8jx46KsNyyQ9wMlTiGTjk3R4FzSsCsKD
         VzEZE38McQ0SY0U3cS8UdxGyAm2zqGv/xtHbWaYo5CmdUwYBengJ+E1hs/TDNq4kU8At
         ECdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774907247; x=1775512047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C8Pgus3VxLH1J7NLwB0o5Q4mhGIUXkZIsrToUQKpi2M=;
        b=nJ8AmgK79fpdUfd2UVT1n2jCqdoqoHcJpRHlGE0xCgO0CaeWFQ0g+3EloqbpmIi6TE
         QN2Xqi5sj1ZbLOwrF2vf1dYbthRcGk9oXWcLzp+QAS9NQ5dEvxACo9KFDv15/zsv3NOD
         jasEwJq+cEK8MMR0arq0iNzi2QXysvEkmdggTIJd2ipZFzKSNoMOzSFbAuw738fSDrnr
         315dWX9S3bISPNaMOdVLNVmnPHMHe9CC9fO90Fa6aDPfgXFqO4UJ9ocAKKTzbBUF9JTo
         wPWf+smmeA9mSyuU+Yg/85ITOgjtDMIgrVpEogWIy4zSkkUbxnFTD2iDX+Ocr6O0PI+R
         S5rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdc1XQ12mgXpfcxPZYeZpwJqWyauMAEd/vRjCQn/2bd5KzkEGwt1wVlRoF8r1886m/KNFqgcohtw==@kvack.org
X-Gm-Message-State: AOJu0YyPD6LlC6Q1SCkuccc2VvMIv2du+5b/VqPkufUZcBvwStVbh5Eb
	RMPZN4Af7EpZJCEeZv/m/1m1Q1UjtwkZUhqdzjh2/r0jgad23pGCKj69OUbPBZKO1rjPtbpLPBt
	U5cPrrKbzm1xA0NiYmp90TJmb1Hm9Cn8=
X-Gm-Gg: ATEYQzxmAUnBe1OyKsKQIfVJusvmFa0S1LO+DKkxy8EQVbiK9cpGdghwlXiTwJzqo7z
	OFhXwoUwMLnymTbav/auiOT78FxfXvjQEltUG+DcejSy8fsYfV8ieviBIa62O+yYSDm68NWE/lh
	KOBlKpYZuUij+z1x6Gnx7vjODiRKv95tLrpuZShXzwnmoTLt225j+2kqreSUMhzSgbBnxd6M2v0
	4kDZAIQNS4/1O/OP6ImUwjWeWm+tonyxWDSFXdDoQAo5L0EDkXGEAQQU04p9eYcMWC4JciNvXHp
	/2dJTg==
X-Received: by 2002:a05:7300:80c4:b0:2c7:3a7:c7b6 with SMTP id
 5a478bee46e88-2c703a7ee5amr2071781eec.6.1774907246799; Mon, 30 Mar 2026
 14:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
 <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
 <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
 <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
 <CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com> <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org>
In-Reply-To: <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 30 Mar 2026 14:47:15 -0700
X-Gm-Features: AQROBzAyqsYIACvjnrc57k9eOu5TbgsuN20r9qECUUWBQeOi5GPjdSpXaUp5RXU
Message-ID: <CACpmpod9uVySybpm+SHebMzb-8ZOPjsAhdYxxMpi4n-+LuTH-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: p3b4ak7sxkuftwuzqmsxqzrcsrydhd6n
X-Rspamd-Queue-Id: 20B1140008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774907247-820963
X-HE-Meta: U2FsdGVkX1/nw+XIZ/PAwNh4R/iLuV87/Ze1kytIIDd/LHn4Ob6eX4/EodXDahOGwXdQ9iB53Z3n+dgIazBiV5znYAUABwSlqvjnW/QyVBE9wndD9MxkbRa5R/X2FoyRAnO1KciJ2xk7zsaGYT6V3B+mqtVh3EPmOGZonbMuhRjeAMzvaz9EdaOPCpqJwjMFpcNPNm5AmzJ6RMLE+y+Vuq5sMYqkIdx3VGWl4UNSquUzWeBT0JRU7ErUfuSCP8FTy4ljTE22Bbh0Zdo1PlEGa5+9XqdemAZfSzw4GYC8RFQuU1ZIDUc662lEBRVk6ycFuH7wiV96k9+pp2tYYUlq9ClqAX6R9iF8F4/d0d6AI/C/5aWw0bOI+y2hooP3nPKLBoT9xdqrKPd6d3LJRx1yVWo8yqvlIv0kj+iJxiZ2fcgHsHKQOGp488K8iKkqSO9JSaUTFIurgLVPLJwxnAvK4OMib5NOTF9WeP5ruwaVgce8HotII09ZqsXtvO+DVKMmeh1J2hfpLTiN5fFo1ay9rKmr9to0rqxFkWGxWlEvE0L81j3yp7eGJYcj9Q6CoLPCcR49ikHTz5SM/cWKkp/Sx36bw/p8qjot+qDEty0tFtoqMVkpl2aLRMBBMpRbwykYnkTpKaROxgOAhCMLYYkOTO5l2rroy5VVniU8Awpz9B4u5QvMnvCaRW9EDtt70BgDV329cR8TjSy89pIHPxf26yRcfl50gj5Ykzduf3/LpHhxR41FAwux3PxGptqbe/y9F8m/HT6okURyIowmcKIBd1CWzc9W8KS1KBo61pONDZMlVOuoZb1/9+st7/yrDb75YUs3rqZnoWYSJv4wEvrdeIk60NDvH622smfJ3BSS0+hfBfpr7U6vAKVUjiuOJE1ATXtHh6FWMKpAF3FgBiErdtJRmIySSlX+Ksi4efC0FYuK8m+YDxn3JgNELmJMrRfc5bvhQEVeHdAO9O1FIPX
 IliW1U5f
 B76pYRtjHW/JZ2nTMyUQkPv6tG5vrSqurdFndUrdUQjDk1KFha9mSRE1jIAtCKLxcnDds7ZPYx3arXnD1rQmuugkqsCvrZd5DDhTYF3l8V5X4amw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:12=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 30 Mar 2026 11:59:04 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > On Mon, Mar 30, 2026 at 11:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Mon, Mar 30, 2026 at 11:51=E2=80=AFAM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> w=
rote:
> > > >
> > > > > The patch looks good to me, feel free to add:
> > > > >
> > > > > Acked-by: Yosry Ahmed <yosry@kernel.org>
> > > >
> > > > Thanks.
> > > >
> > > > > That being said, it might be a good idea to resend the patches (n=
ew
> > > > > version for rebase + Ack?) to get Sashiko to take a look,
> > > >
> > > > Yes please.
> > > >
> > > > > hopefully it will be able to apply/review the patches this time.
> > > >
> > > > I expect so, but I don't understand why Sashiko is having trouble w=
ith
> > > > this.
> > >
> > > I think it was a transient failure.
> >
> > Thanks Yosry and Andrew! Although, when I get the latest mm-unstable,
> > it already has the v2 patches :)
> > Should I still send a v3, with just the Acked-by added to patch 2?
>
> Yes please.  Just to retry the Sashiko scan.

Sure, I will do so.

Thanks,
Kanchana

