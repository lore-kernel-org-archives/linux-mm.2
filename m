Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3421C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856086B0092; Sun, 13 Sep 2026 22:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807706B0093; Sun, 13 Sep 2026 22:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5926B0095; Sun, 13 Sep 2026 22:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3A56B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:48:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 591F9120ED2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:48:04 +0000 (UTC)
X-FDA: 85210833288.22.1DE6876
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CD98140006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:48:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUYWUEkw;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789354082;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXLI3k9/pMTK/BtsjTVMEyDksi2gFy8I9idpjBEt+8w=;
	b=B756pq5owg6VxC+gw8xYaBD5MbAZPP2mvyDhqwXNLj7U8jLjKLASChAvR/6OHnJ/RnjL2I
	qTk81oroSs0hABbVyU3zV7gXOe/rkJFOOhEGLKMVqVzXUxpfFtpO9kMcxQdPp29WPZ+xxe
	qOx+TNsVc6eMSvSikruMeZy80eKm+Is=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789354082;
	b=ZAxx2ntCXM8bjcmXXFDZ2yVik93HppsOjMHuSCqa5BnGHQCo/Iw5LUnYKoWVHl88rqpPlc
	+ed3G4GWhUWqx1j9RbuFxcCXZNcTX3b9fig/Giqcj2DRaBdGaWwQMnTayTwOH0WusXEBBU
	k9ka+JOsc4H+MmRZ2Z/jLOfZX8dcPpM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUYWUEkw;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B302B413B8;
	Mon, 14 Sep 2026 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087EF1F000FF;
	Mon, 14 Sep 2026 02:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789354081;
	bh=AXLI3k9/pMTK/BtsjTVMEyDksi2gFy8I9idpjBEt+8w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aUYWUEkwRAc/MPD1E8wD6u4bTIsbzSq0kvntl9FVDaEATIYAy4I4sIHXFRhg9t4Yz
	 04T63Uk3AKoDRg5NkaKSEjHUhOI2lbC8ikAkEKvl4oLWjLlij9tg1sMybkHau92g4w
	 i3lIV7y5nDKFszslBx9YR0befexyZn9Vr1fRxtdL1d8YPb2I927c60O5OWDxlgwQWC
	 iLso1LRAbVRq0e23KFOTaH+/kqOtLqBi3rSyUQuZVP+dNpzy+Hg3aD3BwD7OI5jIoU
	 CW38fNAoU1X6qNgr88GSJx29l8IxFbmBXdbF6TD/ns1HI3wJQltPrXO1+RIlLwDk4I
	 VHxM1iKtfDtGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/16] mm/page-flags: remove PG_private
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qi Zheng" <qi.zheng@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Kairui
 Song" <kasong@tencent.com>, "Alistair Popple" <apopple@nvidia.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Gregory Price" <gourry@gourry.net>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "David Hildenbrand" <david@kernel.org>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Dev
 Jain" <dev.jain@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Zi
 Yan" <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Barry Song" <baohua@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Jan Kara" <jack@suse.cz>, "Baoquan
 He" <baoquan.he@linux.dev>, linux-mm@kvack.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, "Masami
 Hiramatsu" <mhiramat@kernel.org>, linux-fsdevel@vger.kernel.org, "Pratyush
 Yadav" <pratyush@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Dave Young" <ruirui.yang@linux.dev>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 02:47:59 +0000
Message-Id: <20260914024800.087EF1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3jj8f4e3znzckjoaoc9gsugmxdd89ubd
X-Rspamd-Queue-Id: 9CD98140006
X-HE-Tag: 1789354082-792507
X-HE-Meta: U2FsdGVkX1+pLO8m34VhTBWLIbutqkQP3c2IksjsV04wVzLEGx2PiQxrmEwqJ+1O36qg/0/+TwaASpn5BSsLj8gBt5HF55yCK49pr2KN3g1bw5dAF6IAvZWszF+KtmYi/JDyXhe1usKAViw2Wqwu6xop24RLz3Qa4ZAuHmmY1/35eC6c/i+UiDKmt9Id9Uj/ygSUUj8ev+adslGkBwjeLPL8lo/U1/dUjpQSaJLX4Y6mlObAHUGWJ3Lm3pTWuJvtX+fkD0Z6zoOiREiW1wMFow6TCGtzqJ9jjsRjmweCkkxjiTzVOwgLIAtzcryXYx3CYvq9p2HsM/402VSShIx/SyUtLw6CT56RAaNJz2dgq+FAAC1NTdXHYcQHJeNrg263zxoHYYfuJZ4xc96QH+IwVRLzEKj2CdqXdNS/hoQihPrYa2HHvdOqKfwDibBUDqTpSC1oSzTqA5oZ8DJJiRtySiwjBCG+5daOTpgQ1S56Q/eUYAn8qisi/FfnU75faYzWlHC+ICrnAlk42IRbD2R2eJssXiLVb37BD9Umncrwz77g/O6phCVi/aI0p9V5Pl17urQa1VW3JDeoV7PxrlXONmUtAwIkIxx5UVIM6R6Q1Jzi2A0R97wedtjNg5xHjK3vTFL1qo+G5uBU0eHTXK02D8kdMIMlEZuhsmBnnbvJknGpJpzvKqc8QhkV4cU1mtu04h2c/Sil1qP12LYObKEcXo/ISJeJEfhYgjuldT488xIxb3JOevimBJv2aOm/2NaGPdG/w8PUJLcevbqnKxK9/mNwpxAZK4/DLdC8ASaqsw/Cc7vH0pybMZ14sUmr/6AsURXT5USjjf8aiYpDgHiFMW+HIHXmprFUgpWG52zzLaf1DXNtQmpsjRo1er/Y1aEcSixkZlOlNmalgzZ1oulTPhWaFU/JSjUiSNHgrpaIbwQnP/3MaAmVsUMloTkFiWXMtkdz8vWWvSZIxiCmuE2
 f4WYw7aZ
 feG6Xanv126NRbp8RZwQuGbR0S2biiv0NaWecdcMxX7vM/Nm2w/8lNqVWcCTb+McOUf0ez0K5DG+JHDFBdd5XvdL8fr6+EAeGBE9U04IsOenr5niRRg9jtMh7DGl7EE7PVN6bNYRFXo5D6/PdDhaichKk7mBdsB20Gwqg9HjiWFvz+3nLsT1bcLzyTF1luj8UJr2+8H+5QCK3BWU3TS4lMt7mrPvZN880696o4PaZ0nbqNc3M2E+bV7CKRcDVuaJgqccnRj2YRSPoheJeYa0uKAOyEpIbXwjYh7vEeKTSjjxggYDGAA1GDiY4DrcWh6CAUXjNFaXaThgGop9NovY8drIbLNVjDBbpxxEBElJsjv0DXoA8Z7kR6sy7MK8fN0XLsH1PcQEUTQPTCdoomvgufP70u4gLlwmIPuBok0ys5d6X6u6mQyuChn1C2FnGbhXMajvTEOz3QagVmHNad3LLYsqvkEseSmE5p39W15dws/scXYDfwpB7CmW5ZzKvlQVXspvtAZ/Yc64iex7fxpWRVEKDWacCBuqObxcb3reZsK3keSWnBcw28RVjM1s2VzaSz/QyRR5L2rXSqRJbHNPwdrGp+uLO+7U/9Nvr07SVR1FqfdgAtSYTfdVMH6jFz8Z0zjWDrO22Cgrr5htZmJgfgGBAfJ05dDFe+AVPZEwrKUMS4TnVgs6O7Q5RbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Silent memory leak of folio private data due to missing check for =
leaked `folio->private` data when a head page is freed.
--

commit ebe4dd474a496c46897e3f790e03a43cc0508eaf
Author: Zi Yan <ziy@nvidia.com>

mm/page-flags: remove PG_private

folio->private !=3D NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as PG_folio for future use. Unused PG_private functions
are removed too.

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 08988877331ba..10f4ad075ea48 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h

[ ... ]

> @@ -105,7 +101,7 @@ enum pageflags {
>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>  	PG_arch_1,
>  	PG_reserved,
> -	PG_private,		/* If pagecache, has fs-private data */
> +	PG_folio,		/* Do not use: reserved for folio identification */

[Severity: High]
With the removal of PG_private, does the free path for head pages fail to
validate whether private data is leaked?

Previously, the memory management subsystem checked for PG_private during p=
age
freeing (via PAGE_FLAGS_CHECK_AT_FREE) to catch filesystem leaks, and issue=
d a
bad_page() warning if it was still set.=20

While tail pages are explicitly checked for leaked private data in the free
path:

	if (tail_page->private) {
		bad_page(tail_page, "nonzero private");
		...

The head page's private field appears to be unconditionally zeroed without
validation in __free_pages_prepare() in mm/page_alloc.c:

	page_cpupid_reset_last(page);
	page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
	page->private =3D 0;
	reset_page_owner(page, order);

Can this silently mask bugs where filesystems leak private data (like an
un-detached buffer_head)? Should we add a check for page->private !=3D NULL
for head pages before unconditionally zeroing it?

>  	PG_private_2,		/* If pagecache, has fs aux data */
>  	PG_reclaim,		/* To be reclaimed asap */
>  	PG_swapbacked,		/* Page is backed by RAM/swap */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-remove-pg_=
private-v4-0-848550f7574e@nvidia.com?part=3D16

