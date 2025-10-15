Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A7ECCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B5D8E0016; Wed, 15 Oct 2025 04:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803438E0002; Wed, 15 Oct 2025 04:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2728E0016; Wed, 15 Oct 2025 04:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59A6E8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:40:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00F66C0BC6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:40:16 +0000 (UTC)
X-FDA: 83999701674.22.EF44627
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D54418000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:40:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=axwzjcd4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDsY2VBapz+UptqvTnMcZt7pORUL703BjZYmcP5YKY0=;
	b=eiOqy/wOxfJg7cAjb0kNChesNiWgvnf1X+UIvcaUZFFDwDO8sCSxodEjLyeuV73dxYc+GK
	X8OG2wyyB5lrYKbrdJO8ii4GF3CRUtyQNE2k9NtHB5QOkjs9gP2Vv2C5iuts7KY7/58DnZ
	oLaIHx8WyEfZ2uRiotQoc/PFRl5OGhw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=axwzjcd4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517615; a=rsa-sha256;
	cv=none;
	b=XCMQB0CynqVG5Nduo/7GRsPIZqZHi0UYCWWoW6rtNIIEDTPC48dKPKHmprSoa/iY/S8sgE
	KaDHPldZhweoDE2MXXtaEmF+pz9KnSnywVUbKx2id51NW/TMTf3JLjevYYOwgNNXRWnqiy
	Qfr+pMSX9odgvXogseXgaQYDw7veWcw=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b3e8f400f79so82903266b.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760517613; x=1761122413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDsY2VBapz+UptqvTnMcZt7pORUL703BjZYmcP5YKY0=;
        b=axwzjcd43oHWvhzeWZw3xKVyQHMmrCeUSe/w1L/ejh6FwIp6hoJ2l4Vd0ohUcejgFB
         5Cz5Fo49OBWqSTUIB9iPhuUOglEiR8fkl+CeIcVTASDzsAmMGxie4YqxC2pPGGsnlLbj
         RHTl3PnJD6AYzEYsH/FISQDW7acviY/UnbbQp///sAvQhQAovgiTaBP9kjw8WuU6IZY1
         97x81EkMibLGbN9ipkFd3SBRUHyVnh7bjo2m55rhqWj90TDfGrLEiGoyoi0AfYB80m2z
         tBaTmWgOKSMLbpYbwNT6nK1ZYvgJxZd7NpdkVr8Q3oJnc5ndFhyj9BXdoSOW0kmN9JQx
         x3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760517613; x=1761122413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDsY2VBapz+UptqvTnMcZt7pORUL703BjZYmcP5YKY0=;
        b=GVScaqmJZzrcjUKF+ufkUhwsvytXpCZ1lWykPu1gSx5DxntssxspHm3RPEnp0Vn0q5
         2+UI5OkbAjGd01Kr8wX6MZ7wUAEMXnFWi60L1eezADCttiTY9z7RMKKH5m/n7oP/HTUc
         JYJ53ENdg6fHA9fvz4xcjAmZ/ZUWwFOiVSUc7eNCq1i+aB2CAwCU+phYzj2bZ0lvuZ5a
         FKZmTzhCvWMb/P2q320SJbwIi+d6Z1xN1DBxqR+A9Erwv3sdqMBBY+4sXtMkFrUfj96Y
         UsEXPEfbXpfGiMFu8rh+WPdrwzlUBSzPSUOCnXGcmpXBSqsIu+83Q7KFNxI5zr1s4mxZ
         izaw==
X-Forwarded-Encrypted: i=1; AJvYcCWR02FfN9yyEDfcOMDeG4w0UUiVN0RN9kcbQG7b4ytaXX5+JAkOw5fBZAeyY79ketYzxkAwesXtGQ==@kvack.org
X-Gm-Message-State: AOJu0Yzgqu+nY158BiIg18AyjjtgM2Lxcw/rNsHpz/BBi2en5DiEMTUo
	HdR5pgFPs9uo37wmMXORNAgfkGKR6d6W5cQ2vhKUXZVQOiT6IuRdG5aSF8K7Cl6BfN4=
X-Gm-Gg: ASbGncvxh6UV1TCpaIVV/6W2GBkOTSl6A/eb6tFF2uRiIL4bCwGbff+TMgXi5lCeQ9r
	jl04ejXYvOLlRFqlfK/Y9RTkxH2fjMsDsT9mxRigcsYSkSxL0aaqaAhia7UTUgra2FEcJyoKYg6
	UtV2+PxxrLW1vpfvvbYJTlc8nzpg+uz45uVuAAMjUbZu3FxdC08TwZgbnei3oP/L1snxY6lGrwU
	ufy5tRoXZHK9kjf/3/Cu02vhLnq+sTP57nIeN23tpHxiyXTIQjKpJbuzNUYOVYkbzogCJ1M5F94
	FNHjBuTf39WrVFa0RqcygYw4IP5aaTRH6qrp+leVLfdKNahSkdlkSS9gcmKyCi8aORl0ZxpgYKs
	fLO/kQed7erNjwnJWV3bSK1lYGD4Woj6UDwNzP4PvOScaKy5Sk5521QGQzMmuUCblGp2yuf+q9O
	MfEbmmWesYZkfcUTPfFbUKI5mTFnCyCITq685HJsfoSWxT0Gsbg08IPU3APw==
X-Google-Smtp-Source: AGHT+IELGd1QIrFF53QcX+I76rx+ZG0TLeQwEgYCUqwVFMJIjoxdZrhJJkMTqEZ8KN0QoxSWe07NSA==
X-Received: by 2002:a17:907:e8f:b0:b44:fb0c:5c37 with SMTP id a640c23a62f3a-b50ac1c480dmr1491862066b.6.1760517613246;
        Wed, 15 Oct 2025 01:40:13 -0700 (PDT)
Received: from mordecai.tesarici.cz (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cba45afc5sm170229166b.37.2025.10.15.01.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 01:40:12 -0700 (PDT)
Date: Wed, 15 Oct 2025 10:40:08 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Suren Baghdasaryan <surenb@google.com>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Mel
 Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>,
 Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard
 <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
 John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
Message-ID: <20251015104008.4bcd99e7@mordecai.tesarici.cz>
In-Reply-To: <CAGWkznFG2_WGmLRmHnjV-49iTX0mrt9jxQBzZYK=K9U7eKJD0g@mail.gmail.com>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
	<20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
	<87953097-a105-4775-88a5-9b3a676ff139@amd.com>
	<CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
	<ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com>
	<20251014171003.57bbfd63@mordecai.tesarici.cz>
	<97da9924-9489-4d30-a858-8ee5c87bc031@amd.com>
	<CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
	<aO8TKQN6ifOSMRSC@casper.infradead.org>
	<CAGWkznFG2_WGmLRmHnjV-49iTX0mrt9jxQBzZYK=K9U7eKJD0g@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D54418000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zobnr3o6g7tu7gxza59fkwqx4pxzxmf1
X-HE-Tag: 1760517614-300456
X-HE-Meta: U2FsdGVkX19w19dxeH8S5sCwsdtOU8LCPzJlsumDM6Fo5kVwbrLKjgZPHUV0kC5N0qJMIpMzqr9HCMySfHT7AlUaMrECPhlBr1K9ZzokgyjQX/f+QulGCk/tPJ3gYdts1h+oBGivPacZwIOqsOVh5RahXYAvD7MNDrAxS1ofqTkC/j8F5MP6wGiktf21sQzq7+EpQoQ5ZFpFaLarJAuhyDanZyxctQgV9Nh6wDi9/jrGbuGd08OP0yc2vT2/bIk+GtASfDEWe9H9SqTQL+T35yG1pSye8pQhP/Ue2i5tk82RmUoqUBMKDui1mXD5+Cg1UFS7yjdQboSWT5x9sWKKuMhK1lezBFELE5b1lsLuNILNYqkB1+970cln18fGO154jKs+isgLrQ9mMyGjJji5yrmbpM3jqvqvfcQXX8qs92S136EQGvntCR7AKMHApS50PNem8wrd1bFMwCctqZKfUA20ViCcsrFLGSKfTBpmgFab6KFBeAwhBBKgaD2lh1AEZ/5fe+bVHA517hnHjW1OGNmp9UD0fFZ9oIefouZ8iDY7Huh5oJ2FsTjR70gGeOhSOuNYHKOzjqctMeymyYZeYyKPNheRxs6pYo0oZLYC5Y65k6dJopgq30Y/6CK5O/coM8wT5MnBOcKA7I4hxHCjeM64aHDlO/Oj0uF90J/4bM1rLdN7U3bWlownba1Fo4IuEQ2NJUx8ZfqY/tmRymp/1NA5HdWhZ5Dnhusg6NGjQtlLydQuosYyWrOHhe/aQAnlJbx2nYJ1bcQ1QcFTiJO/PsKacCC7kHfTq428nXK/IvnZU0OI1nAsbaRiDp9fOziwA/LAkR2+S3wO2onpLjF/4/zVrUE8vjPJ5Tw/m8TQk7WlOzqEjgL5xiYpZGMMcp51BrLm1nKQmY8G0SepDGBm3C92YCenXFyS5K7LkcHywDLsbaE2si1m3OQXbNB+KAjjwB6lr/2fpny2YRIg2cV
 B2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 13:52:57 +0800
Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:

> On Wed, Oct 15, 2025 at 11:21=E2=80=AFAM Matthew Wilcox <willy@infradead.=
org> wrote:
> >
> > On Wed, Oct 15, 2025 at 09:12:07AM +0800, Zhaoyang Huang wrote: =20
> > > > Could be that we need to make this behavior conditional, but somebo=
dy would need to come up with some really good arguments to justify the com=
plexity. =20
> > > ok, should we use CONFIG_DMA_BUF_BULK_ALLOCATION or a variable
> > > controlled by sysfs interface? =20
> >
> > No.  Explain what you're trying to solve, because you haven't yet. =20
> Dma-buf works as a memory allocation backend could loop thousands of
> times alloc_pages for allocating order-0 pages to fulfill the dozens
> MB demand, this commit would like to replace the loop by once
> alloc_pages_bulk. Whereas, alloc_pages_bulk_array perhaps introduces
> extra memory allocation along with direct-reclaim which could be more
> expensive than iterating the list. so call back the API
> alloc_pages_bulk_list as well

This does not quite explain it. IIRC you mentioned allocating 18M as an
example. The ideal outcome in that case is:

- 16 order-8 compound pages
- 32 order-4 compound pages
-> total 48 calls to alloc_pages()

But presumably, that's not what happens, because fragmentation makes
(some of) those order-8 allocations fail. Since you talk about
thousands of loop iterations, it looks like even order-4 allocation
fail in your case. Then I agree there's not much value in trying to
avoid further fragmentation, and after so many order-0 allocations,
it's probably also pointless to do memory reclaim.

OTOH I can see why the opposite approach is a bad idea in situations
where fragmentation can be avoided. To make things even worse,
alloc_pages_bulk() will rather split pages in the preferred zone than
try allocating from the next best zone.

To sum it up, Zhaoyang, can you please describe in more detail what
happens in your scenario and what you believe should happen instead?

Petr T

