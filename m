Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0652DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C39B6B00CD; Wed, 21 Jan 2026 22:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D876B00CF; Wed, 21 Jan 2026 22:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545AC6B00D0; Wed, 21 Jan 2026 22:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 414166B00CD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:55:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB0911A1734
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:55:20 +0000 (UTC)
X-FDA: 84358234800.16.D53C16C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A7A0140002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:55:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Bt/NZyh6";
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769054119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeOYHGjjMiblWMiwD3gJwuwX7/B++TRGRlJnS/d+MF4=;
	b=i2Rnh461vlEbmNTQBpZmDr/qEVrStnY1Tojyp3L2DzkAx+FdAHrHH6U4EwfD0rRAVAraMJ
	m7hs9Mt0nXnNMBjKoECyivwqcrtYFvqcAtMZylk3GvSvKLEiCVBsmOAKhRl08bYyLi1oCH
	f7ANApby9xRbvOUqbJQNhwT9cOGV2Us=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Bt/NZyh6";
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769054119; a=rsa-sha256;
	cv=none;
	b=E3FUhQhruMONJ6N/38rV0W334X/zKSDM2JKX5WLGfMADvHyjET077K8/6Ohwj9Ejt997a/
	J89OZKEii3Ec7dP/dEJXPNfSZG/m9Ix+vqu8QaqoTdG2KAypw/lo33OzdJkCznmDStTbQQ
	zp4MnIj1UCfbsZbV9Q5My8BJczrHCTo=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-81f4f4d4822so305363b3a.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769054118; x=1769658918; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LeOYHGjjMiblWMiwD3gJwuwX7/B++TRGRlJnS/d+MF4=;
        b=Bt/NZyh6wRAjEeCL8Mhs/hn2PVmeciqJwSqGg29vj+6wpUm86kHnZenC0GocWJMBiW
         EUUxxJjH+o/+rknwBtpUa0b9Zksrf3U3Tz7/CfddfYpBL54z+HPtgWz2sahvSSxXhYbG
         KeH/R/xubpztry2Y4EnNEGKajI9Nm/PgDkO5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769054118; x=1769658918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeOYHGjjMiblWMiwD3gJwuwX7/B++TRGRlJnS/d+MF4=;
        b=GQ3He3gL0o1WxRmSFeV9CuJBWa+vcGGkrk1uRU72nf8aoO5OBpx3Pr3QlPa9ipC11c
         zO8hXY6sNeEgfaXqGTTrUwz1wa9Lk/000o2heywIkI7fJEHAthpO4w8sugPewulg0PfI
         z1CBqt42yBf1mRUmpKzyMbRdbHCklVkVirT4DjxMUCGMXaKH2GFcdiq+cmSUR/LKr0dx
         T9SukZkcbcO7MZIiWRlaEvM3yjlEv5HmleQqHevtECm1PdlfzhkpRMb9uKyBFAw2fIJ1
         Hwh/hFZM0vX02KphIMTSTyhCMvUR6kD16/Jo1jOFudOM44Gq4a4b7RUyOmp03/xpwQyx
         bd8g==
X-Forwarded-Encrypted: i=1; AJvYcCUe00IM/zDECCFozcQR+cMaQNSiD25GH+CnGOYJhRZeDBcZIt6cbL/WYiJezMJ51oBwcisFeoZpQQ==@kvack.org
X-Gm-Message-State: AOJu0Ywr95BiX3/i1Db2/5uogAI7iK8+76QvMpREQW1TVJnv6sGOB4aR
	90XjV1r44K1wdXYV2aHOoKgXKTWhYSuaK+yYvf292E0ZIlLuuNSbV4yd+KnR6gjTZg==
X-Gm-Gg: AZuq6aIUWgQc7g3IpByqssb8d0kUg1UDHE4tcpAmJ3b/ar4EYrQeJvPVPxjto7llVMK
	HTtQII/u2RBevjvOGY9NWkzqlGkIz1as4Yb8Az2rHLFjqmR5MA4HSSJaOkvxsdCUYnOKD70GQL4
	2/xiiDkOJyLlaK/jAwU4Z6Wujgv2dgermtZkETFR15nD2QEE/MtZJEtO1CJVhKJEFXSnI+9YVMl
	oZHIcLMZPDy3IID6MUQ55Cc+SFLqmdyFYksxpIzVQlejQEUnqxxj7rP1nxPheTpDQE+MnoJpPnm
	DDCk2n20O/NUsqJfriYOg6XyK0erAFfrvRTSpTDmm7FCrVDSwOA6URGmJ99OrfF91fYwU+aVmLP
	c7EtGG3Pi+Zf8D2R+4yNhru0Fup8HyKElZqyj+j1/y/CwOc9DJr8wrqG4z3TfALwZcREtAcs5dM
	vikDtyjB0hDs7withxrVHuffjfGmXqm8+jJnE3Eu0SltfLxahpMqM=
X-Received: by 2002:a05:6a00:4c0a:b0:7e8:43f5:bd4c with SMTP id d2e1a72fcca58-81fe89edea6mr6888682b3a.56.1769054117813;
        Wed, 21 Jan 2026 19:55:17 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:302d:ca04:e174:1470])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa108c23esm16555155b3a.8.2026.01.21.19.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 19:55:17 -0800 (PST)
Date: Thu, 22 Jan 2026 12:55:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <7u6k3kfvifkfcwfzxzgbwymdhjhcwmb2z6o4ju2kddwlfwtsaq@xapk55ehdonc>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
 <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
 <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
 <cevxzukpt4363kdlb5ofre5tquuvm6jyphstp6nlxjxqibj4wx@2yg4xwlcxwg5>
 <uodv6dukliy7bnfprh4yoxjkrn77uqljarlg5pmlippxsxygzv@gthjss7yyrlf>
 <fjb3hzhbmnlgqquahaevekydn5enb45rhgzhixqrtykxaxjk5f@xlcyzanq6qxp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fjb3hzhbmnlgqquahaevekydn5enb45rhgzhixqrtykxaxjk5f@xlcyzanq6qxp>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A7A0140002
X-Stat-Signature: t59i9k7xagff3caqjky5dxyi7zbi61ck
X-Rspam-User: 
X-HE-Tag: 1769054118-503088
X-HE-Meta: U2FsdGVkX1/kQXyiR6R7b7RsSwdWM6zpJH3n/UP/CdyYNH9tkb2DUFKO+ol0YNZvkvPYtVZTAElpoO8vEZ/B2JAfUzEh4sKaYWPzzk7r4C/Omo6xkhckxGMYpx7yiZZbvkNHqntZZT6gnMIbIjPwXfJq17wxXWM/mYRLI8QOLC1cS2vQamhODo9LmanOiz60QEDOoF7NiWIyV0Vo89u1DxTBB/34jcAxYU8jYY+GBw5BMwnwGuPJ85TQvasd5XD0iRzm+mom5K2p9IGZDioGnlpuqbsjaVH56A/+rdeBSr/ZduJ9KWh93uwiFimjAu01EBtdrh0NcYrF2Ge8PutIGvUAHGtANJFa+KRXmTV8mHvfB0E84SbmKxwkfx/4s9MIobQPLS9ZGGInQk73IyIdLHiVrBTd3U+l/p3o+Cy9067ablQDlHKfPLb3tO1cOFmuPpfYmD1heBUYpxoXRMRuaDpk70/WcWo1nTufmDWr3GTQ52/EKUEv3XfJ56EjeYJIRBCmH56xvLdKLoQxG9daV4mI4B10c4LAVYZmVAT8owgHK4XqskeqQzKHQxIl7VScNwlNzvKcks9l3x+hfuAbmEY1XerPfxtXvWkeDBZg3HQmlH8hsQXslx5osjeL1ql14cJd+bYk6oGJPMQLtRBjoBR8fvnvtM+0P2cy705Jd7RXDF1spSSrSCpHB3I3/aN/Ym57RKEjltJRpdLZ1tvC+f/ywJq9WxJv/fWC+LJZXupRb19MaLtYp66nQUAHht8t8jE5Q9abllvzYIlQvqQZrUOzhx9t8QyLi5z0sqtxAqp7KCSxhxrybdN4t1A4FQs4tWShi4C4Rjpow0Am+IdhlLP+d9v0VpBg6euus3/Ej3jfgJDtTKJCrcjUheteYQxyUfABfvYuS7p7Ipqc1lhY6loLYC9My+CIwfUsomZFI5hT7+PTgs2U8WfVLa5HngdX5eGjP48QtRfTgUbzqG5
 O16Cypcx
 D9n4+c9iFwuGjzGe6CKSjcOidJ6wT8GgCsv7mMJZ62MxyvElAL2Sz++XdkKO0sN5XW+UFLHZOTyi9ShpFAGvjutdBPNzHWsKiWbV90TuEGR8Y0xeAodUNGS58E3PsUmBvK5HqlRhfrRte8L/XMzP7bRMTprohjP2DhbMHh1E27vsAweh2YkgbXxg4M69Kfkhq+tNsDSJpzlnc0OT+MDofcPtAXCe8h4GvBu/TSRq8pjmD1TXO43kbd90Q2PsbhVv2vemMSP66Q90+3LJDOBNYr+FCwWomxMfPVTjSEBNZIHee0fslrZ+iqHGWYEAeFm8i1AyPMokS3wPeNBX6Zt3OeOqFeFBdCCDD1vdyR8Xc51I7kKpTyW6lC1EPtZSph1GONYpG3Ya6GzumZeBWfayTdQ+Xvq1sGiBSoQbAaeTrezZ7dLwWVbaUcPHYTJsjoSrCl1w5A9YNR1r95+mOcHa7hE7cRzW45Ytz5JlZQD/IFjumQZdoaCzcCB9D0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/22 03:39), Yosry Ahmed wrote:
[..]
> > That's a good question.  I haven't thought about just converting
> > zsmalloc to a singleton pool by default.  I don't think I'm
> > concerned with lock contention, the thing is we should have the
> > same upper boundary contention wise (there are only num_online_cpus()
> > tasks that can concurrently access any zsmalloc pool, be it a singleton
> > or not).  I certainly will try to measure once I have linux-next booting
> > again.
> > 
> > What was the reason why you allocated many zsmalloc pool in zswap?
> 
> IIRC it was actually lock contention, specifically the pool spinlock.
> When the change was made to per-class spinlocks, we dropped the multiple
> pools:
> http://lore.kernel.org/linux-mm/20240617-zsmalloc-lock-mm-everything-v1-0-5e5081ea11b3@linux.dev/.
> 
> So having multiple pools does mitigate lock contention in some cases.
> Even though the upper boundary might be the same, the actual number of
> CPUs contending on the same lock would go down in practice.
> 
> While looking for this, I actually found something more interesting. I
> did propose more-or-less the same exact patch back when zswap used
> multiple pools:
> https://lore.kernel.org/all/20240604175340.218175-1-yosryahmed@google.com/.
> 
> Seems like Minchan had some concerns back then. I wonder if those still
> apply.

Interesting.  Lifecycles are completely random, I don't see how we
can make any assumptions about them and how we can rely on them to
avoid/control fragmentation.  I think we should have global caches.

