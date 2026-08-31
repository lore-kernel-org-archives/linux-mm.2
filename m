Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E47C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3A56B008A; Mon, 31 Aug 2026 04:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64806B0095; Mon, 31 Aug 2026 04:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A2E6B0098; Mon, 31 Aug 2026 04:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A51C46B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:57:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13327C03E1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:57:17 +0000 (UTC)
X-FDA: 85160960514.07.205524E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 577FD140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:57:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EyqF/SjR";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166635;
	b=Cm5BIktHiNMPZUPVDV9Cq4gh6Ffl183bDwpU+BJrO1s7syb65fC5Oa1cZfkSDee9Df97Xi
	07MSV1XDY7amhASbhI5VvOAR1pUr1HE2Z65V6q8uWIMA2PyLfuTLDp32LPuaZVuRCvSSu5
	W32TarCweMMwbkGwfKgcAzdzULFNZhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpqPq4bvtMsOVeG0UN+yy/NuoFZ+H+t/+49d1u/I1io=;
	b=K4Ew5ET+PauBAzjua95zBgXvc52ydFIvIzVUYw49Z4ZNVY38om1M4beXNisoNuRqA8g+j6
	yn8K6yYd21raiisJoZ9pEO3LfN3F+GwCrSy3dHmM9AeuaZ6NjsjAJBV/4n4JvA8DrkeLkx
	OO9bRG5Q21p5HFD5CHEtBjrXUVZ1DAQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EyqF/SjR";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0DFB411B0;
	Mon, 31 Aug 2026 08:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1274C1F000E9;
	Mon, 31 Aug 2026 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166633;
	bh=YpqPq4bvtMsOVeG0UN+yy/NuoFZ+H+t/+49d1u/I1io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EyqF/SjRvWc/h8CQwUE1TihCdfdXAUbBtv3y4A0dT6UbuMtRzhhG0ezD1YP8W6IB1
	 D1UC6+/yv2T3QyDTv/QKSDkuhr16a7cryNgwZ5B6fcR9kxnoN3Rzu1psKdUKxDkIYd
	 54XgUOPP0PK3+aGg3J5NrGYHZ2Olr6u5urt8HbFyNnKED5mKtDkI/30RyVIOpHeDT/
	 5ZCfkLhsWRwLFq0zE0aJsZM/2e1qpUcEmHgFIPds4GXPE1n0n8Q4v4jVTv8c8x70qs
	 5iGeZvi71UgCbxIg4rPs/lKJWa/iDnwILmdscXOHeUODYzlfByh+0KRz1cCHK442nz
	 QvYs+X0zqjPQg==
Date: Mon, 31 Aug 2026 09:57:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apVAEJtgAzX-kAwN@gremlin>
References: <20260831075635.2244437-1-noren@nvidia.com>
 <apU-lExw89P-zKgD@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apU-lExw89P-zKgD@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 577FD140008
X-Stat-Signature: 55s66up19u8m3p67dycf859jz6ogiha7
X-HE-Tag: 1788166635-546795
X-HE-Meta: U2FsdGVkX1+kvDC1zyv745cDPbP0uPT+SQ7gUw+owmlZIG1YzeS91rqo63MQOhIVYED7wTjriEeF4W9O1caRh1rKuiv9BoYCz//PHnt83nloKjtmNWmoDfoLexpkvqOH9qy/73OyBjdJuQgABlmmSOwLnoq8OX0B3z1nj70SfG1/ypKCzfezVu+P9KVFI09IOU6aGm3SKjCcsXgjg5N+ZirikcbjrmV4k2bVKiL7/rOwFAgAlCVrQAWcCNdLBB9egt0OG5BYYrt64LpQkrbgRKOLk4MJ6H3o8r8Tazd+Uo3XQWLrn2hvntESwDzUz0SlSfsG/iTlsq9d2VZAU2kjVyc5teOEpnSjsClDYjpbElRAMDwa4wv3szS3WQEvsqTnqlhSf0J0qDraeHp2Q69VswJ6/tCwFA6OErM+hjHbmlHz1uhbqUUHZPexJMOyZpJWTKTcvHSnuocfifwd1M03SIWDz1oIKNHv+oupm0kyz55StfllgRbq7ZCy1nhq2yvjS2gOmwAh4nRsNYnLp2bMe8Dd+Vx6sXAoPBNFEgmcD+uvdFNqQ5+/zMQdTA7WtHsPFpsOAZzuBsc6dZahkcfJOegB/6B8eDPxUjR4ygV35dWCYvimyTiSHiCC6OruQSDp0G1RBDnV7non7SEnuFla5P7cq3NinqWByytiPJTLCwTWdS8kbImUfOmpFN/mFqdjlRgOmZUT1upbCVjp4R4maMrIR9Pkb7YwYcgIDKVd88Cqhal+CKvb8T9i0rcr5d9elNHRe1FudmCTe3b+NHVhyfdxVKXzLtxLJDmhS1uh/n29Fl7DGLzO9xS9P8UvhVft3TUMXEaj00OX1abejz0I0tU6bAoZBpOPBPUYQA/VoIUPlkmTv1JOEWM59jiFtL+BBYANK2SMplmFX524gtDJvC4SJXBtGLNorRaqDQz4sgU8ESS66cYrISKrVxDK/UMeK2F7pImnbtXpk5fSpkR
 a/ehc7wS
 bbz/vWchwhMxu5uhGDbNULkNRj233h1pEwvOIqBl/hQvvhrr1EvWa+FtyoFha0R1sDdblbz3SbrLY8zjJ35TEW8ehcBNAli3+3Yn6sheiMyJ3en0zTmd+07BCyX7Jae4q5TeNZE7efd1UmSmpvnKgmKSjSuTK/1xVdeGv1Tk7GBgc/w8ZLrEZ4v9bRTuWc/oDBjZtufITRkLl2C7S/yMjrEIV0M+lP+lbdDF4TEy9SxzeLEBSWuFEfLxXtddNGoNuO7GapjqF7V/MGWj6NC+H3Ky2hrf8IMNUVjbXJb0HKUhnPZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:47:29AM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 31, 2026 at 10:56:35AM +0300, Nimrod Oren wrote:
> > When THP is enabled, set_recommended_min_free_kbytes() may raise
> > min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> > With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> > pageblocks for every eligible populated zone before capping the result
> > at 5% of low memory.
> >
> > This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> > configurations, but scales poorly with larger base page sizes. With
> > the default arm64 pageblock sizes, the contribution per eligible zone
> > before the 5% cap is:
> >
> >   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> >
> > Consequently, min_free_kbytes can reach excessive and unwanted levels.
> >
> > Add an absolute 1 GiB cap to the recommendation, in addition to the
> > existing percentage cap. This bounds the automatic recommendation to a
> > sane value on systems with large pageblocks while preserving existing
> > behavior for typical systems with 2 MiB pageblocks.
>
> I am not against an upper limit for min_free_kbytes, but I think the
> root cause of the problem you see is the size of the page block.
>
> We at Meta switched to 2M page blocks on 64k ARMs recently, targeting 2M
> mTHPs. A 512M pageblock is not practical.

I mean we do keep looping around on these things as 64 KiB page size is
fundamentally a big problem for the pageblock model :)

I don't love the idea of just making page blocks arbitrary smaller for
higher page table size, because hey the intent is to get a PMD-sized thing.

So really I think to do it 'properly' you'd need to rework how that whole
thing functions.

For me the approach here is a practical trade-off - if the intent is to cap
at a sensible value, then just cap at a sensible value.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

