Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D44C79FBC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 19:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5976F6B008A; Mon,  5 Jan 2026 14:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547BF6B0093; Mon,  5 Jan 2026 14:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463D26B0095; Mon,  5 Jan 2026 14:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AD496B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 14:55:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F010D1ABD5
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:55:58 +0000 (UTC)
X-FDA: 84298965996.01.910F500
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29A37140009
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:55:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mzi7MReX;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767642957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iog+hYgLiZRC3g3lYFmRjl8SBSTmMSwxCWcvManxv3I=;
	b=5xiNwTuJ55d+/SRrnbpx8csQXSDYYXqS5L3n74Nk4PVwqBwIUHtvFBnn5KgAOSNAIwfAno
	/TaYEAra7+/mOwRbBTU/AoQ45RarX4aUodbY/fKff63ZxnJiVErXFupcpnbGi+In78DI3Z
	m4KhLHlmKC2waCuH2oR9LTfHtB6klo0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767642957; a=rsa-sha256;
	cv=none;
	b=T0Lt/L1vaWVs4q+XTHGi0W1ZdhPfhVQYrMzyHrM/GRWCfmPcY3vkihlYv78LtGVAveasYc
	ILYDGtcL6Y7/0q5GZZnJABmTPnwRUR1piMJik0UKRrGoc6xOBMpiGMtfkog6blNx1AKaUa
	6b9/becf3CI/wmH21+6J4VSH5214gqI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mzi7MReX;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2a4b6876fso32031385a.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 11:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767642956; x=1768247756; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iog+hYgLiZRC3g3lYFmRjl8SBSTmMSwxCWcvManxv3I=;
        b=Mzi7MReXQotmgZWMpRideD9BmBz90sRsX+qNHrweEWgMvkm5MHU2C6DYrBLfJIOYr2
         YfvQBXaPVbnSjmBztP/Wesw5g6BHGeOEX50EWVdEzr+7skgxDVJQZJY3h7YneOXWqqJb
         MrTkQE1XxWixV0MjhPW/ocR1hk499yF1zanxjmb4/mLzoP4/8+SDQXEs6nT9SijbXZPi
         zSXDC8HnH/uoYFKY0yiHVGtq3ldqO7Y08HdduZyjdaO71QFaq6oVhtx/5I13Hkt9Fbqi
         Gdm96BeZGMzUFv9I5Eoh9FA+DqAsPT9SAbUFDPJnX8xda+XKSVhmfS9C0n65v7zBitpw
         sZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767642956; x=1768247756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iog+hYgLiZRC3g3lYFmRjl8SBSTmMSwxCWcvManxv3I=;
        b=M1HDJIoj2PT9ttgnkrs/SO0Gs0bWA6a6Ywa/qPeIGLNUkBlBXSYDwjz4oEDPXLkYhQ
         VDz9javUBf4RxWARnk+TrPCWxZigvcXIzNxLeqEYQlLXInAaJ6EjFLpLjI3O276h4U2j
         c+XQmi8Pi+tzIvVHDKzhM/lFMvF3pNVuZEpVpxOBgDCuON8/qBvJUvRmSqF6vKoqVoKi
         kwHtW3Wdtdpj0klimO4CJ9yCBYwAhVqM51bK1RyaA4Vt5sC/yFJpbLglipfnxZvaMbqc
         eh6LlzzRKLJhGIq/Js+fNkeCZvrp5Y7JITcptJDRnGF2GktKSughEkLD3D2PwBUdEOg1
         ueRw==
X-Forwarded-Encrypted: i=1; AJvYcCUzuasUPbOF/J5Zn7F15jJDE1v+auRMLhDDQA6uW7ZLZ2r0w3WI8IBsb+kOhtwMIs9BM7wKAOBMmQ==@kvack.org
X-Gm-Message-State: AOJu0YzH/0H3DSp/tE524mACMto8s1RuZZJBIucGTOkVmMJsmrX9qOgV
	fNzUJzVLH5d2Tle3H+rOg0+VSO+6yMmLid2bAbgHiXSwwFmroL5MRZyfSENwNMepmQLtmgb2D7U
	eIj1+jL3hqHxPjHTvdz1klFaG3e1YEeGj4ufY
X-Gm-Gg: AY/fxX79Xu/jDWH03YNHwAJIbpHdP0f8bP5kxErXWFRNNFyhUFG+hpSSv9rFjA3j+rk
	O9VKa1UjktGmCDMpjRjQkGNzarOp1BoVX/LsjC2ap1+4JuDWS2cH9FLtTyQ8hg1pd/zK2WzqyMT
	5s/MO1iLUYFTAnqrqYUtSh4nDbfNG8v777l6rnNOXCCQ2oVnDOVGEj6KiluTkvNQkVNyHhw6zhI
	WoTpAc5ZNIhauLsUFXKTFBGfX8yRRMmzhtVH7v5jNeC1thk6MZTtQPhuDF/TtpRkzSTTg==
X-Google-Smtp-Source: AGHT+IEcXiL8f+s52fan8QBIB8gC3RmFY4+fpmlXK2z6PXVY35c7s9hfXufUtxNhmOF/muXn/qtrDW/8Z7clxD7o+HI=
X-Received: by 2002:a05:622a:198f:b0:4f1:e99f:7d74 with SMTP id
 d75a77b69052e-4ffa76d7eb2mr10837171cf.12.1767642956158; Mon, 05 Jan 2026
 11:55:56 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <20260103100310.7181968cda53b14def0455b3@linux-foundation.org>
 <9f9343f6-c714-4d2f-985b-e832c6960360@kernel.org>
In-Reply-To: <9f9343f6-c714-4d2f-985b-e832c6960360@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 5 Jan 2026 11:55:45 -0800
X-Gm-Features: AQt7F2qxuG4z8c8Qm515xNGzMMbs8p-UQIVayICF-AA8ax8cqWJEnRx16FYQQIw
Message-ID: <CAJnrk1YhqsoNGFocqbDhbU00c1ZZCqGrDVDf1ZCFqubPLQH4qQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, miklos@szeredi.hu, linux-mm@kvack.org, 
	athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tg7nabj3mu15z17r8eozwdwk1whngznt
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29A37140009
X-Rspam-User: 
X-HE-Tag: 1767642957-685634
X-HE-Meta: U2FsdGVkX19fxITiN5QzrQVow3zIfqTyVjdFNnFNz9hAtK9AO/uFF4aLPud/VQDwyk7UoFj9RZy1PmaA+yeB290kSM0BOKdEqsRczzNcXS2QPL1vlAy5Ki6ZdvWOVp9Ka8Ak6SC/MOlUAvD0WIBP41f2aNGe77t3z46aWRWQT5CHO/jLxNq38EbHREyJPCq/peCYkrre4f6N+RibBxrX9QrKMbunQrwSDiRCoUYFg49ED4s75c6d29lOXz5UzzkW6Q/bxNlwC92gVApOxZeW61WNI2r3+t9qdryMHCzvbhIeruj3RlMk3LgvFIu/tNYJMqCmyis2Fytj9QowKvB9l2oHUoMCjz7UlLnUHP3penswR2zcxQywlARimscXeh8Hr9OQfGZfzWhOSxc2jqzMB1/NJYAUkjAF0yACyugpfi03CnAuoeBnUJtT+7VAz2HioQwEdJdRg5CQwUQg525m+Kknki7gFwpHVOlQJIDpELWH1VrqZMUJQ5UFHEDNSeE02cS16d9dZkU10xK7n5+qsvwSLmAOIYEDk8rDY5RX//PabdD9++T31YV33q83B5bDVoRJIHylX6mTb/jIBTKueGmV0jNr7v7/fvsT/oZdAHJFQa4RFV8LAHO9qx6+ewWXc/WqjKXYgcP+qCfi/ILTWMIzJPdCehxM0k6PcOr7sd6UieszhYR42HgDu+c6Wm567DEIiqJ2TAHlaC9QVh9m246tA/s0jYl3ukNivghZP7uBXybLY5Wbpau3d/lCN/WhNeBdW2YKfR9EZX4pa/QULWgX+O40IwnMTubUEiZCpWDcHENU59sQra2rSAtSUz2Ji8Crs6r4u4LjL6UmF5ESZ79ejzbb5HlOFTK/xZ58xTaU0uuBW+JHKD4TQh52wG+PtU/ELVXe70Aoc89LDpMg2+j5O9TfHHwqeckBFobd9S+R5/i1+whWTaz19s1hwdUvYdQNwTvrL1DU7VjlODx
 rGIXrbM7
 jkHzKhq9Q04Ovzsj1WAM32IizLFH4ZiVKeOl7P080nLajey9/u/MUQeusV2W87PrdfT1+FawSmPf4LJThr8pDeUBH+y8YiO3jVeB19M4MA8Tn6b66i8qCdReQAdymw+zh9nAq1eT/eC0G3bEOn8tvkEP6Jaj5nap5tT6NanyR5e85Mzaw2CHCC5G33q1Ehs846isYrahG6l0Re6QI3UPhv9J0MXftrtswVVIGR60uWA6+pg9cX+qWz8EeiDPUPoZa4xnrDklrBhgrDneYVzIAevCyWraXSXlKf9R/EsxZlo4U3MIooQnhoZaIwdp2D+ObXM8KRUVkwDWNxpNSjobYbVliRMMRPnLuw5yceH3cyVqg2h3S6fH3nRPQmm6Z88rByiJ6OD4/9vzMOy1VrCk3Yk3DrNvftAtDlRajgIbePIB5d48HA6z3ceZVBKxijUYwiu77eQcTCrJrMNjnKbHRGF3uZuvlYEgMxHGv/MsnPxtKhgYXZ5XgAcT6AsUAKT92eq901xam5wr0ByGyCRJIe9KCqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 4, 2026 at 10:54=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/3/26 19:03, Andrew Morton wrote:
> > On Sun, 14 Dec 2025 19:00:43 -0800 Joanne Koong <joannelkoong@gmail.com=
> wrote:
> >
> >> Skip waiting on writeback for inodes that belong to mappings that do n=
ot
> >> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> >> mapping flag).
> >>
> >> This restores fuse back to prior behavior where syncs are no-ops. This
> >> is needed because otherwise, if a system is running a faulty fuse
> >> server that does not reply to issued write requests, this will cause
> >> wait_sb_inodes() to wait forever.
> >>
> >> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and intern=
al rb tree")
> >> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> >> Reported-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>
> >> ..
> >>
> >> --- a/fs/fs-writeback.c
> >> +++ b/fs/fs-writeback.c
> >> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *s=
b)
> >>               * do not have the mapping lock. Skip it here, wb complet=
ion
> >>               * will remove it.
> >>               */
> >> -            if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> >> +            if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> >> +                mapping_no_data_integrity(mapping))
> >>                      continue;
> >
> > It's not obvious why a no-data-integrity mapping would want to skip
> > writeback - what do these things have to do with each other?
> >
> > So can we please have a v2 which has a comment here explaining this to =
the
> > reader?
>
> Sorry for not replying earlier, I missed a couple of mails sent to my
> @redhat address due to @gmail being force-unsubscribed from linux-mm ...
>
> Probably sufficient to add at the beginning of the commit:
>
> "Above the while() loop in wait_sb_inodes(), we document that we must
> wait for all pages under writeback for data integrity. Consequently, if
> a mapping, like fuse, traditionally does not have data integrity
> semantics, there is no need to wait at all; we can simply skip these inod=
es.
>
> So skip ..."

Sounds good, I'll send out v3 with these changes. Thanks for the
feedback, Andrew and David.

>
> --
> Cheers
>
> David

