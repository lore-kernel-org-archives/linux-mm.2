Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3DFC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B906B0114; Tue,  1 Sep 2026 06:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E55A6B0115; Tue,  1 Sep 2026 06:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACC36B0116; Tue,  1 Sep 2026 06:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBBE06B0114
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:33:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49E3C1202E4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:33:00 +0000 (UTC)
X-FDA: 85164830520.04.C51099A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 734EAC0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:32:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZaqD2/r7";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788258778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kz2UKluoElEtbtcr6f/jgfNgmNiv9DhwSNGNfkgr3+s=;
	b=zc6id3mTVt1ADtiK+IelsY4NgGnVhEjWtN47L/WDe6GQ3jDBhTETHWyB3YaG17iULfaDLs
	AyvZFguXhkvqYNRaALfEy7C8vQ3A80YTNz8fyRPZzFIGc4jHvKRJPqnpgeL8D88eoU0n+u
	fRstW6Ib0HCt2eFmLKttIj0FHZTmKZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788258778;
	b=PNa+fwTQMVaLfqFUt6IP8e/JhD0+39TwRe7YUMDxi06LNuFL7iWJDAbIrLc93R3sQgMd+p
	Y5uwzqRRckWT9MVLFZZjQVIjC4ihx6W8Gy6yt9TwDuPKLDMiTBu7xgM98l0ZJqlWdW6/Y0
	bN1B8hdjV8dh2qKXq2ZKg93jOXVVrJ0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZaqD2/r7";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C3EA429F9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F6E1F00A3E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788258777;
	bh=kz2UKluoElEtbtcr6f/jgfNgmNiv9DhwSNGNfkgr3+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZaqD2/r7DOFhHjl3Rwijm+UVxqJOCWeFYyAuth1jKdEaSwgX50/BRaHJ7PDb884aH
	 VdBZsDI7gTFyvvjMplFzrrfv+TXrux6NhVTT0HTF1qx+tvxU2w+d2YijZj+gf6ohOk
	 ER8cZ7J+1qlOb0Hlg4ov1mDlck0NQ9vn+4rfTJNdHRelnkwR+BMqOe+Q1Z0Xx1jnpa
	 U+LzaZLsAitBO+eRMa04FUz0WfCAvIN1iFrds9GtUeSe1KNamkywZ5OhiSPNLfiM7g
	 OfS84d2PNLPxKjEcXij0qmUmr6fAub7FeTX/Jj4nrctAPFC/Ue12sKvrnXWBXGMq4y
	 xPzC4xCx38Zrg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-936e393176fso65283885a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:32:57 -0700 (PDT)
X-Gm-Message-State: AFuF++nNzL3SfM6H+SJ1W5W/5Qb7UbfjlQOf7mzw1yjQycEFR5DjwzQf
	uXoi07bqcdQ2IvCSuziaVVhvMrztcXNckYwo1iSWNBIAmb1rH7IySAuooiC0ePb8+cxQCXmWngB
	Ea3E0PNDWnNY5Uv0zx57EMrENJycZ3bo=
X-Received: by 2002:a05:620a:4487:b0:937:6ed3:78d with SMTP id
 af79cd13be357-9391390b4b4mr2930150285a.20.1788258776414; Tue, 01 Sep 2026
 03:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com> <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 18:32:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbXhWfAv1EaTW81yyNRDHO7HVpcR3uRcB9v5Afeck-5A@mail.gmail.com>
X-Gm-Features: AcwNN1XHWhtzaukFlsh3FhGGQunilwYP5RcrWIDVoEx7eVnU4Ym4-Iqdeoh4g2I
Message-ID: <CAGsJ_4xbXhWfAv1EaTW81yyNRDHO7HVpcR3uRcB9v5Afeck-5A@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3dx86j4x11e9dek33yfz4orf5xyswcnu
X-Rspamd-Queue-Id: 734EAC0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788258778-7603
X-HE-Meta: U2FsdGVkX1/Rrzc28LG8gMqqed06BphHrYX7DAwznduLbJKZKXVKpkRqbGSJxWBxFff6gUEuOxCvkSOnIpPUdWEbEVg3U0q+Bf0PlYeX1BUkClg550CC9LelnQBhnyUpynNFOkeZScuGUT7S85Qx8Rd5gh3NJ6OrXWSmk82OWH4UNQN6Yfw1gywjJrCyAGvlYwMC3IKCqx7HW1r/kO5vdAuByCOa8fueIA3KpOcz1Txn6hhskKtEPtuqt+SJTw59KOT9ssCSVyxsCDrY/avkWidnS07BfIhLlH1Dy+C0Ogv40D7qku2oOWOE8/6By23Xinktd/5N/nFM9nhbN6UF+GYPE9I581stpfRMUbnFJEMjm5G51Iw5ps0FtXXq6AjVyAq/TkuD6c1avu5DZ/Dt/AuLuPj0HmuRrlmavU0lngu6ezAq/YiVe7DEmvIi1Copn5wzTtJuqU7YpjlMhGnGwYzDmynwjS2x56V5XAKgedU49NTtR0DigYwyzynf0RIT8chw9XPT5CSwZdHtyF+hSTdfyP3aioN2+FUl1SXJ7l/AQBoNsdR/mpVk4AM0P0Bb4fmySDSDju0LsD0ibdQg4bf2DrWSInGbpPgyLP/cBQrP8i0cJv/mfLiHcADzEKrXCSOg8FO42A83y1yeTBbYuxDzb/1aYYhvWo70cCJa2eSZ+48bbNDQWh/MNFbScoHeVRx/4IwmpEx/oWZ2zqYtmwF/1slf7fWQWLOmdgohQ7KYBY2XoOZeBgr29m36bw/9sRhHC/d4VrqrIaiMaglu1LfvtPb6+2U4Kzmts+KTRvSDb0mWbXNQc70RjqsThWMftJqH1Np+k+3CVVEgS3/kW7uZgV+DHYW1bHc5vQ7lIoUxsE6SiF4qaFwbQPMgjVN9l5WPbODwBA8avmeDYgIQg35NIM0fxMwWGF8sfcCHXEiWNboRy67LOnVzxR88bQh1eFqpI2yseLROABfNc7p
 3ANVQUxo
 W0cdA7mGIAbs195lfpVup5IMfkA1W25oCdZI+4w20NKoDxmqxitlQI9k5DR+1HPkOa9eDwHXXJyIambqdsEn3He8sj760cptctvb7AbTLBaH94prkhwGokqBz9q3b35d0DyzruyaN4rY1FEg8UNvkB5E+ZUyFHHEo81tVX9Z04lNiqSXHAVjK1SifkeJ41KCcCUWC5Nq6mBMlYOFN5THTx78Ue/wlnKHDexaGg2TSsgRTRuOq3KKJjB6wAePUb2zTatu9Vmy//ql+/4yTtwjwrMP5UAuKyLwbaRrTwYLjxeBRuP2/5vyJjeW3SZRgc05+CBq/TPqNg4fYDZog2UOylCsg1H9jrNF3eItUpTFeuDME+aVW4/qlQ3SVOsDu+gi4dRiiOG9wktMBXTV6PDom7RaHxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 2:43=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

