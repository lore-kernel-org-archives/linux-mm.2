Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BA1C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968A26B008C; Mon, 24 Aug 2026 21:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919D66B0092; Mon, 24 Aug 2026 21:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808DB6B0095; Mon, 24 Aug 2026 21:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61B9F6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:57:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 602E0120310
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:57:00 +0000 (UTC)
X-FDA: 85138128600.15.70BC882
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99A5680004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:56:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QXB2oxdu;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Oo8NDm9dvwfDBbQ2Wad7p0r2TT4On7jjKPyUzxLsDc=;
	b=k7akG5Mok91vwLJZl3f3COQR+tl265eqoBxGZmQ/lDpHUNos0cQvRPEU9BS9UvB+rfxBw4
	4BVrgdwsVzPYNJsYoQ/mGv6dnACetkKQam6unqqzd+h81DSrw6SMhBJcRKMeWpGcA0sX1Q
	ssPV0ajCeSfdipnKHZmejqkbsgjUcVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QXB2oxdu;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623018;
	b=oCFwtiPA5WWWEr1jCD2fb1vPWOxA308xO05rDmQEWyK7jYiAkDA0LwGdWRLxm4cgrPGlz1
	7ERCWcCz7Fh9+sdZB/Z+AJDVyDX/OuV+tA/iftX96elBGY4Dbt23VWUbDrA1H6IahHMfRt
	kTP6qOG8J6Hvxo/DXkzCkpNvj/EkSI8=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so4653077a91.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787623017; x=1788227817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Oo8NDm9dvwfDBbQ2Wad7p0r2TT4On7jjKPyUzxLsDc=;
        b=QXB2oxdu4Ib6wP3RUxjaLqUR+/z/duMezdeQienUHM4xPB9cXGAzTG4LtyQ0pPSGTb
         vE3W7VKmfs5mFG+cQKsJuwBIfiPWIFx5bKZPaUubp+a03twe5FMpLQbX6X7derW100nJ
         Vzzr+fyyE0nO83BKUH2DDK1ORJvgkGGE4c1vJMUpSifAKPa6NCKG2r8ysSwHlOOJcja5
         +TMGJhEmbaXL1pL9H5fYMlIHeNiSelFq0Pu+BbSfKObcye8M5o573iq0SBz9C5jaIj4D
         m38Si/7z1SL0vUuxQ9y3X181xd6padBVfsvPW3ID221LATOaubeGwIRy0x+Bianpqavi
         /5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787623017; x=1788227817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Oo8NDm9dvwfDBbQ2Wad7p0r2TT4On7jjKPyUzxLsDc=;
        b=bguBzPlr+yA3LCeDZYbZUIn0rKO/TgehDYQ89c7uq8vckRQjBP5Vv55Vze2sWL5zbB
         hbhngnnYFRcIZymI7ZJv19Mq4bIQ/NMu/qsEQVRHui/Z+bSSm3nbEfuU0Qbashul5+Kv
         hMWtLmPtQYIm8dJlt549USfulGck+PwfpJrUGZtI2WkJaHnVMNc3fPLpOlwQbmkHZ5c+
         GSOXHXhuz9pcShWaQNM+hDYV4t3JAADr2RqQvxTkCdFpasvmw+DFQ9GeNMmGY1zitF0V
         owWl0HJVVd2qsLV0DIG2F7QDbDUGWHrCzqaB9Hq3QlIjTB7NoqcsDONEDdQPaQUEss+K
         DgYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr0//vImcnxqf+wM26589XYnUwv1EUobjxVB89n2dkYeswg79/rhNjbK8vFSwTsnwl2Pgnsc7IVOQ==@kvack.org
X-Gm-Message-State: AFuF++lyhAbwTsRD7IS9a1Yr31sl5vjPhKcydH2TLvOuDyrCdPrxlXvU
	Ovx+evGhDBaxmL0aQy/TiMufJQfkaU/FL/wLXbHWXRbD/nW6jpFiQNMw
X-Gm-Gg: AR+sD110ohMjEZWPRUKq0HWEUkMatUfPCcO09y4pJCoSlQeI1iRu0Gv7HKGlPgtUTd9
	t5NMRREDno35k0MzlTMNcdCCpzX9aSsbGdclcR2GxG2xgwPRuWLehb8fnSSl2iGzEN1ZTL/K6sv
	gqqe3LaPDqoAIJ70csil1Crhm3Y3ul1rg5c8P71iGz2ShTTM6PUnErQ13KIxZY2OHNcPrvbIK7D
	3xFqmDK/AkEAGKZO3yb0zDu4ZgpC8svPPdsCfp6TjkBUS9n4M7yIelp5SZFXgPcN91pAFDhand7
	ZS42Mtk9IDEs8/qPsyeMC2tvAwbHPfvpY3q2cLquqEtL2dkPDrlFR94bTIwNbq6czowie4hloKB
	naiknPhbFDwgQFkhhjOLaahhiOJM56M6uelM5JwzH9FlHOmGMF5kRQNoz/5aoigQBC/UbKbbG8a
	hbwkkPBVPIVqW0y6qkZUsWrLS3r2zWvFSuCAxDUkP4qtmExvfa+wxKHWmJL98wFSZU0LKE3iZtj
	meWMRM6xOTeWRJsRro=
X-Received: by 2002:a17:90b:5485:b0:38e:11ba:992c with SMTP id 98e67ed59e1d1-395df6080e0mr45204432a91.12.1787623017392;
        Mon, 24 Aug 2026 18:56:57 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396433a54cesm604819a91.4.2026.08.24.18.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 18:56:56 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>
Subject: Re: [PATCH v2 RESEND 2/3] mm: memblock: show all region flags in debugfs
Date: Tue, 25 Aug 2026 09:56:50 +0800
Message-Id: <20260825015650.205656-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aoxgAYXqXvs0GFYM@kernel.org>
References: <aoxgAYXqXvs0GFYM@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99A5680004
X-Stat-Signature: we4rafm84azt13p8r8k7h7q975jksgts
X-Rspam-User: 
X-HE-Tag: 1787623018-167770
X-HE-Meta: U2FsdGVkX1962E/DmLZwQcuIkdP7kA08X6HruJcKU3Em8Lw1G44nR49D9GQ+2Sd4F6LXqGpOSu67cqNT8agH4gZKYy/f1f685LnsLz6ygnunbCBZko44ipNlk0xGViesvLNKJtECDtBGLu2lpEPlEOdm2GktEL0kxi2QsnR05j5qitCcR+7Ewya4LegyF8a7Y75rTwy/ytieP6LO6nttp3XhGJFcCK5HDiz3nxwm2AAnrFBA93HbTb1UgbdQj4I0xYVOnU7aogd5P4LWjfNWzV4Ac5jCsTsD9xJZLXD8TYvg7OziY2/83VIGR0OmgfFngewRkOfLveowAV+jzUvoHc/9TBHkIWx+nNA3TmDxYKupnj++gMCqw5oRlAKHszOxbOclZpc+CzqDLrQnzKHn4aceOZtV5pVytaSbofJEtiazgCCDq3S2+EoBgSqSqLkJkdPkv/S8AiOAXRHbRDsjkg0mE2QEtq4YMLN4i2j4TrKxQ2ubu6Snv0NZmHgt16euMBviNBu6wKOuTjFJO6/+05zXBKpIKsfTk5Y2afoPx1rjzdV51U23eRi4dqy9woH85ZGwNHIsqgpF9p5wvRngm6zFYkALARcWxgpVxq+29AsgDnuHwQAXY3HpZFg+Fx6CMO2qAHtYJgPnl0MrL6vPwWGx1BZPiFB7vkUpsZpD3RBjt543jdAC9eYBj3Gor4t9qjmxZtg3TbRTdQpmrJE7I5c+fJhix9i5xPJH9uKs0R+FPCGGWvpd00F3izhJVN/9JuNix33Zc7eaQwBYxqucNU1GtrBVhQVHe9C1/Mxnp4dXGQcjfqaxhK9OO/EeIo7di97gbjJFQGhiHYt8U+SmC7woJXKNzP8ZkhpWSeHZROyB4A2MbFhZwCCIQbUyCVRK3YT+qjX5+UaD1jWyinFOT1fFtSmyPp+JSCHwUbVaAtQBO/97fsw6PWwQzw2M9SCK1wHlCdcXMYPEUyvQHAu
 bg0gK8nC
 FX7EV2jSK1Y/GqwFQwbyWS3d5IwFhmo4YXVJ85hE88rfxBcHflbxD8DVsXadK+Zob/yK4QJmAbSvmrTo+Uutj9daYWsNqj6udsYiHbLx+O620ahCGK1cjY8M3kUzlnOoyE4HLfY5dX5SwtC/7DSHuJWRyHKsvQwZUSnzS+VVa/PDmXxMKbtV67eKLI6uyi+VeBitsbFirJCRGWssk0qj01MIO3H8F3FKw9OPF4CSka1J0iXVmZlUqGtbK8fwqzsxBoaKprLf+bwHi2Yu4naLW3L1JIMbNXIDybIi2AEq102qeMEsQHaRxQniceZlTVGEezOA1q6p3bszY+35TdK457lkZ6WQBZSanyNAD3rbItEbki/UNfDMmcc/kshK/l20PK5sjkVhD3OFpmCahZ/e3QdtpSAN6SzNWiz6n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026, Mike Rapoport wrote:
> first and flags can be declared here.

Agreed. I'll move them into the reg->flags block.

> Can we really have both j < count and !flagname[j]?

No. All currently defined memblock flag bits are contiguous and every
entry in flagname[] is initialized. I'll remove the redundant NULL
check.

> No need to change this

Agreed. I'll keep the existing code unchanged.

Thanks for the review.

