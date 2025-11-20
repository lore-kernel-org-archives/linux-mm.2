Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E9DCCF256D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510E16B0026; Thu, 20 Nov 2025 00:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6646B0027; Thu, 20 Nov 2025 00:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422796B0028; Thu, 20 Nov 2025 00:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3128F6B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:01:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 608B31A0769
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:01:06 +0000 (UTC)
X-FDA: 84129786132.17.0926B10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5E6AE20007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:01:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSnknZ5c;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763614864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eS/KBjPYoCr7fRnK2jMtf54XMo5mOZgaGLvvf1R4/9c=;
	b=ftPY5aKqsmpQB3Wl4pD9+uuJiEBj/FpQC5GsvamqtB6ePPYyB8rty8yu/0JrcTyP6x1lnp
	AobrouT76Po0rZvEbZnYNdSiS5OleWDioZfq28b/6gBTiyLXdcc1kFEoVIBmjvuhkdJEEh
	ktXipA6oi8JDDHH2ibEfopBQSU/QTdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763614864; a=rsa-sha256;
	cv=none;
	b=pxQlvkgz9nIlcBttmrvmOf59q3y0WaewDq9YlAEEAyaj1tz1Y1Zj7WMTEM4CSr3Pmvvchc
	OAoXE/mPAA3QVce3ehpbbPf6nFjZERCNWzhByKjEm9iLxqcLzEZx80Tcs5CaraNvdT01h2
	B8jtF5ozStCooQ2926EoRIWHVNkQN1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSnknZ5c;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3BAF429FD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFDAC116C6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763614862;
	bh=eS/KBjPYoCr7fRnK2jMtf54XMo5mOZgaGLvvf1R4/9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MSnknZ5ckbuk2TTAZY9RsAcbvPeNg3MNUF/Ta6erW9MQlpLiDlCR4uV7zZdpkBf1k
	 z6TKgAy8m9QNwUDUgFquIe7iuDKxuFz7didTV368Piw6W7JSKYQJEyqDeRqB+KtSsE
	 DyWgvEejSzJ4jHqumFETS/kWPsgx1/dwKZal3QL74QSVDOBtcoVJ9teDuYr6hSBqjJ
	 HW5oRIyPwOqjDF3C9IxQhK9VG3OaVsaibj56R1vd/nKcFlkrUs9zD0mFUfIR9DT2jf
	 FE+xsoBF4KIfB10TZ37/c7yTjWaQz2rPLFUc05DYggKRH5wwQRKONWNZEVbZY5Hy/K
	 eeFncZSYCFu8w==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-640e065991dso413523d50.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:01:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUn+VynrtDe56T4Ck1xBs7s7+2nk/X3EZyG7WsN3xjVoeRTMbB0RS88fbiopfHTSgC/Gxl9z1NVbw==@kvack.org
X-Gm-Message-State: AOJu0YwCQGuruzamwuLqsJhD18S+x9uoSuDK91cgbVlXSQM9whilGJcQ
	C/1INo93vMyCfkWvY9W9lBx8P6BKrhUAzn5jHOg/qIUkxJUJJe/4rLuB+btBCV9QHWcQA+RfHQk
	NsofuMkusMlHlcUUhYt+ms5IRnk+kH3fhN/Nh+brwYw==
X-Google-Smtp-Source: AGHT+IHvR0bhrPFn+krsez1ru9VZBAExJsov3yiU7r2e48NDHcV3GEAvjeMLE3ErTqO3Q4izxeqYERqJVxGWsRx1ZZ0=
X-Received: by 2002:a53:b111:0:b0:641:f5bc:6986 with SMTP id
 956f58d0204a3-642f7e9ee56mr992792d50.82.1763614860917; Wed, 19 Nov 2025
 21:01:00 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-4-youngjun.park@lge.com>
 <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
 <CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com> <20251105162953.74b38e11ad1a28093e751822@linux-foundation.org>
In-Reply-To: <20251105162953.74b38e11ad1a28093e751822@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 19 Nov 2025 21:00:50 -0800
X-Gmail-Original-Message-ID: <CACePvbVLG2BbC7CQLrC5sP1fUXxuV+MqBh=LyJgLr9REQz252g@mail.gmail.com>
X-Gm-Features: AWmQ_bmWhUeDwBPZUiJhOjv5IFxuuQu3Wj7px4rGDPvqB9Bj7dfMNZef3ZJI0wo
Message-ID: <CACePvbVLG2BbC7CQLrC5sP1fUXxuV+MqBh=LyJgLr9REQz252g@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E6AE20007
X-Stat-Signature: yuaz4unpsuc4aeod7xaqqugpjetz45be
X-Rspam-User: 
X-HE-Tag: 1763614864-435676
X-HE-Meta: U2FsdGVkX19Z3IU2ma4iRU6AkWk8UgHTliBpORkw5LO5IXofa84MNuAW6FH4nAAof6iBwsQWDwvGPfRgBi+IgIYXOjCa69zDS0VK/0uHfpVDcrLWLGSZilykwO5G+Cr53XaKuRzDIqYRSTFeDASKSYxyVBzwmwNt6Ehw3lZulS7ExsPRPvVhwdv72ptFHBu4xe1tIHpXNtHiVrE8X8hRgom/yruvusQzE6V8NTRaBws4H5mzT3HyoC9AHthTpQ3jDeSvdc8qP0+sdFHpkiFmN7l4ccyIXszTUPK9C5iK9vMRGsaBIYj/pKO8xNm8CGs9OcUVjaZgwriskDR3jvpfiXbZhtvQbLIof54BqcH57JY8azRFieM0ErudGr4ByPRdjZaoAGIS+xpPr60mXlAV8M+ORPAqfh+bvs4R3Oln9VKfn3J7YO8GqpKJi1w1baTwRGtAN/gmxkmtyns/C2A/GFFqcvn/eCb0guyo7V9voKZz8an0QamBJFDzcFkJb3ErvvOA8ojY0mbZpzGMmmSAjdl3h/fosGvAcSjY+d2jHF2OoHTSc09QXDrNLcPpaRxwEeKE1ZUBXgoM1uld7x9/gw9CjlDRuh8EA5/uZ4BzyWZXwznYsrCBrNZeHUeKlGzlMpJ6LTg4ErIdLDRHAcHy0y+xaNXylsvvdwyS3iFC9KwOyXuBpwa1AaTwC4KNcJlBhopA0Fn2jNvZT9NYjHNkB0Z3h79E36yvxvpX8Wr87gnYsTFFeRXUetQ5syR3B5JsyQzz4CV4a9lROitweOmrAsThI0ZoH46EL9Cdc71uO7b0CIVGj8V9kz23+atjK/LHcv63N7yRYrFMMy5NIFwS48p+x6YXVrmg3qns/LiTTnb520gJunD+MeyPHZ/er2C2cRieG0H2PZQaJZdprZGteH0XXe+mbgdHrSJF5TUKbPxTVW9DXhE3xI86ULEpNF/Tt9plw7E8vfGZifOnxxu
 mKLzDZYz
 A8I/l9Z7DQ8QWhoREcWVsH5o5b5UwTwkfAw3nk9FcHTc/cKGWlcAABG3ZYjpkMVY6myZoZeS6WgjFyO866ojftJsQeVyhHXPJCBOxQrHWXwo+wfZ5MlJCIwxkJY+pVmgLzBB7pRvuQXHAyz0MDoMJhul5TN51dRopGveRT6Yade+Vfns0voIsfOZGmv7rToVHo3QNPUO12FwpqxQtATq/ZVhwx4KOQJlMHVz8TIOT16U5bcnqbrBRDAK6xLfBStsMESJxAAoa8WJ7GC2FDsuueQkEfbbKoek8x+oDa+wU8L53rIGKQjNOcDRX6s5oHzHIf53glYNFNlb3Ez7+e5nHge9M7CYb6YwkTIHbXExgNApiQDdG9ROLUx2slIIOtOXLHkw7ANJ+Aa6476VRutv/cOpDXD9NQS6ICQ2HBc3HBfy2bbk0ZiVlfwTQsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 5, 2025 at 4:29=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue, 4 Nov 2025 23:58:17 -0800 Chris Li <chrisl@kernel.org> wrote:
>
> > Do you mind putting this 5 patches series AFTER the swap table phase
> > II? It is the comment adjustment anyway. If there is a conflict with
> > phase II, I think phase II should take priority.
>
> OK, I'll drop this series "mm: swap: small fixes and comment cleanups", v=
2.

Hi Andrew,

I discuss with Kairui, his swap table phase II series will need to
refresh a V3 anyway.
Please re-apply this cleanup 5 patch series from YongJun, it is
already reviewed. Kairui's phase II V3 will use it as base so we don't
hold up this cleanup series for too long.

Thanks

Chris

