Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D50DC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761006B00AA; Mon, 17 Aug 2026 06:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711D36B00AC; Mon, 17 Aug 2026 06:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B32C6B00AD; Mon, 17 Aug 2026 06:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3146A6B00AA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:07:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9397806DC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:07:16 +0000 (UTC)
X-FDA: 85110333672.29.24F29EE
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id A535C100008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:07:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O bw+j5W";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jc5xJb2V;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786961234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRuNgn93bXJUfUxBiQxkO2z074NGsTuHkXM1In4i/2g=;
	b=nQW7yQwmmgYjzTYe5p58I8H0UuSx2mV1AkHp0haUQEWRh6d6jupVqeuNqXP/RJ5YE2mPIX
	To9V8NdTxdaI6BeHnfkX5++e8j7e11xbNSwBp9UWJImwBf/yyaEFpsv6VjjxVVQ9WDrjdQ
	EO1+UlJI4uIY09MqGrfytOR+wST6QjI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O bw+j5W";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=jc5xJb2V;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786961234;
	b=EAcDM2f0JaGaldj5b6CNAwerjZK7tp3TqkTwMZWedfi+LIM+1jEZ9ls34K7Tws6d1nS7Ai
	xWHX3Xw47ndIZZe/2ilzFUC6UX0uaNMTYkZhua5kGgRxMngKjoSasxH/8NCzua6JhsbEFT
	jMoak4Rzqn8RTlm3tLKOhhtn6C6lsmQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 5ECA31300157;
	Mon, 17 Aug 2026 06:07:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 17 Aug 2026 06:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786961232; x=
	1786968432; bh=aRuNgn93bXJUfUxBiQxkO2z074NGsTuHkXM1In4i/2g=; b=O
	bw+j5WgWN+X6RQhGAYltwX6zzKc0Fc3AgF/3bxvz2QdUBFHjnMtBLTcg+Y+dnImg
	CyzEfKss1yEa2iQcZJvd7MoCY3w8OU/SSX5g8LouAtrJSqf2QgP4o3DVmRU4RfAE
	xL6WLF8j79qAZvgk0xHb/r+suYpm9YbGpJj3HNbBlXaIFwCjomWvp39d7bu0pE9O
	FQ7J9brTf0KpLa4NP5We5Yt5jfLeGAcKf8WLpTIrZIz5BEL9gW5R0udM8ieJU8AC
	6+tWXw25nO0maJonQZMdrMIZq3EXoX0ev6OqrvgZfzxh6dvU6RvUG977GDJbSb4v
	7MjxthZq5Ew36jTVBXhTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786961232; x=1786968432; bh=aRuNgn93bXJUfUxBiQxkO2z074NGsTuHkXM
	1In4i/2g=; b=jc5xJb2VoVZ1fl2S6LLqziq4i2u2Rbe32OHQeJVp/2ttPYTXew0
	7fI87ivUzXyjtnbDs9dM6NQNV3o8ArPMOKaUgnltc5Lub9V598q6WxgipKSq6vty
	zeDD7M/ZgRR1gOO4hUgeirt736eb0ZwlUwCWnJNZDvk45D3gRHqaNGzzARe++MR9
	T8wj+C5TYn88f0zcpQvtazCWS5NJGNTs8rMFuHegFjkZ7AePLSicCWft5HQoGLPo
	Ln/FnQvW+gGfYcLSaa3nFZzFQoC5+Ljnv2h1n2phwmmvNY7BrTExfOMM6wYBBug/
	CEcTRhxwPoeOjpi4FPmH/fDkD7KGYVnvEwQ==
X-ME-Sender: <xms:Tt2CapXMRrdqUkLUYClECzMGWz7C6_A8JSuSSJczEnq-CYWn6lQsHg>
    <xme:Tt2CaqBxYZMKV3YyzhukbCH2OSBWz-cCHzzrGjyuynRYx5hdylU-XPFPbhGqWCImY
    hw6SzT0-0rOPRj49_5_IZYpzj-lPJn2bXjj1VxLQrLJl4bXkRPTjbzP>
X-ME-Received: <xmr:Tt2Cam23dXjUyNx77-7MMZ_lxv3FAf44uQvC9wprJ7cpr2x2MfiOIMp7_-o>
X-ME-Proxy-Cause: dmFkZTGPke0xlf6uK3/vVuV73Zp1ci4I00XU/mQfuBGFKH1EChMGX2W2K2Ay2xhloeELQD
    YiSpOdYfS3z1XRkLC6OwopMYsiHdQ/yeActqocVNoFvfU/5hj7DZTAbsGqeu/+vlYMOKYe
    MWZ9Q8UiaBU71nzHRAot0umiaedntditcGBLwUem5zhFHFf5OpfS/6n4GvupEXcpjvPGj3
    YS/MsMxbcZPoVQjXb4Y5nmgZiQQTorgVnlVV7XtccWjaPbJxsCJxHuas6xK55NYWz1sLxN
    BrpX30FWPC089z3CGRvQuRihRi+MjBpPadK+XwuOwmXhO/v6SpeTG64SVzAEO1fg3twnP1
    Kff7Ds0jl28z1J7Pw/pA2yU9ggaWKCe8j6+zwfuGFFyZuYj9ej/W7PLO9hSwDLHvIdW6e6
    Mr/XVT8/uY+izsqEvf9nEEzVsCTyF+Mu7ocLv1N8u1P7CBjqyb9zStDL6Ow8OhJrSPvHnZ
    CY4gqFI+3SIrPoHTIQjBKp2kK4SlVy31eGOwFfSooL93C7phrDuEtE6RThgrayhp9q/CEb
    MtROetx8oiqBJOf2mJ2ieygLVtmzuoOpIsCwDXTmS1tO5vJZ8JyienAdNO5QvrPaiK4piA
    hA0YgweTdo/51rf4vottrOb6FRoIjt2cLXIPrFbDaGaLAA1zaoVYm2Nyd23A
X-ME-Proxy: <xmx:Tt2CasUuEtiP84tS7a6-AsE2jEt4pUnaX_etlNhxWeXrpK8Iiw-iZA>
    <xmx:Tt2Cai9U7lLXVYWTLOHt9tMTtMIJQhUW-2RPfF55m9wC3ZiigfrLbQ>
    <xmx:Tt2Cah1N-5Sw1mAJFbviYO3ob6StIInc6Me9s3_0UAv57rrxd4fFhQ>
    <xmx:Tt2CatD1gW3cHx2rVnpjpUMd3hGXJN-wCfU4S8HoIuNJkC5uGGA8kQ>
    <xmx:UN2Can-cWdfMqC3gdMhs9v4sDRqa48mv37iCCpvVjODesicJh_YR0Jdx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Aug 2026 06:07:10 -0400 (EDT)
Date: Mon, 17 Aug 2026 11:07:08 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoLc38LkU8bLAJ3Q@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <DKQUL7RN5K3W.30VLVVWFPBRXZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKQUL7RN5K3W.30VLVVWFPBRXZ@nvidia.com>
X-Stat-Signature: q77p4xpdff8i7dp7odzbm1nz5xmofdit
X-Rspamd-Queue-Id: A535C100008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786961234-6482
X-HE-Meta: U2FsdGVkX18Wf0w69AsIcnu4zyPyDA1PqiBBh1AYzGO43Nx5Jemd4vb4U+A/HJd+e9o9nby8S9VYM4M9wLgSLSncRd9GQPvqmhKaTS+JwejPmASRkNuAAQ/3uWRTMcgW1Ki2WC9ahtsWPM9yc7Zmw7QI8j4AZ2zfx31KwZ7F10xyfzz9iUR+w+EcR/NQrgK1cHHx4xWFOHKoe1vPIPXgykGq6N2YX1bth6WkPuJ3/2xQhFSRkIrImAvm1wMsW9SKH4f2BkMEfrAiwto4LbwZkc7slUx7LEVhyn7aC6tn1n5OGNT6rdNd+crzAW/b7PAHVyH+2+OklX2m9+HV6ZzCP/VCVQO9Pez3KyWTC4Mngy5tHWvdUn8BAhn6jXXP9ZPpx5h6ZMVbac9tF7tFnVwJ/KESfNat9Jy/WnaqTVlU1Cslev3dCgAxcF+VMaKdqv7ktsd16RY8grTWPUvtMQF0zHVRJe2gNCnxUxDZvvpbq6nd5zClHHp6jhtCuVSN2J3zDFa9owYhWF6JVf7eF9cUKI/PSyNduaxgJShTelrZlmVhlexlOVmBCJJShCEj9IT5gPlosZi/eLp8vf5czxc1ZYMTFz64ON0DJdxPUZmT3Lu1T4cAmuPJQBHkycm9WgdTHoGZywwEG8KvY7QRv7HnV1XM3zJhVzr5gmGHiC8YrbOo61vASI7yoX3CDx1SMKha4WPlywwJ1v9Tja3hWuVkw1XJGOUDddq/6brsipTfTK+7V/ji6zmSolqUkAN5VYGkCzlQDd7M+ra9B4zI/RhVTWD+nGpYYIXo26YcJ+3lVY15QdwvBDcKrOSYfE+8L4QIiKjyixb6nbhL5HjCQLJqlTxPvvfFnDUxj+R937OXZMiAolXWsFRIwFGmzOhFlluXAgv0JEttKvIYyMZI4lAzLMJYOFBaKx4rUrz8KORKzQYoclq/j2HsEwAPH4yvaNtLunF9d5IERBi2p4hFWI1
 t0Kt+zLP
 8PjDDWgpSm723Tovrgg2y89WS8jpHJegIjBo/7s2Ey+9MFXoGKBbQa854j9FExR3dkT3QBNGlvlIe/VGYgvWrOkasTB8Km2yc+Dsk+Yl5GxmwgkEVaUHcOlX75mXCY6IXEz8qv18nvcdrRvfNw6MI8oOI9Se0y+kf7ZyHMGo1KjrTf1LTZgiAqv9jPf3CAEwiHAYgcUFt2fDNQ4WVimyXJJgVqVXZprNbo2+Qv9H3+AYWOunI/D3bTlG26foeAGpSZ61ikw+3E7/dbC8bfJ9aJEPU+omODhX8VXVF++V8Ru7LXDDdRqZ7Dy6C9cAHT7ble1rkFL8mVafWEIXqf8nGMkGqXm+AW0hEcEal8cKGq7MV/hn7w5mLq4aOYzCOq9poq0AhQfN9YlpGiLquDHf8Npy+64hh4EygQCTaxuAF2/yEt2PqKqouyHsjRw0RxyWIxUrk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 10:02:53PM -0400, Zi Yan wrote:
> > What that removes from every collapse path:
> >
> >   mmap_write_lock              -> mmap_read
> >   anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
> >                                   locked, and the engine holds that lock
> >                                   from freeze to putback
> >   tlb_remove_table_sync_one()  -> nothing: one ranged flush per round
> >   LRU isolation                -> nothing: sources are inert in place
> 
> I remember we were discussing using migration entry and the issue with
> mmap_write_lock() in the context of in-place THP promotion and the
> conclusion was that because MADV_DONTNEED (maybe MADV_REMOVE or
> MADV_PAGEOUT) works on page table and does not change VMAs,
> mmap_write_lock() is needed to prevent things being changed under
> khugepaged. Anything different in normal khugepaged collapse process, so
> that it is OK to use mmap_read_lock? Let me know if I misremember it.

IIRC that discussion predates Hugh's pte_offset_map() rework -- since
0d940a9b270b the helper takes rcu_read_lock() and fails if the pmd is
none, !present or huge, so mmap_write is no longer what keeps a pte
walker out.  MADV_DONTNEED is still not excluded, and the engine does not
try to: the install re-reads every slot under the ptl and publishes only
if it still holds the migration entry this round put there, leaving a
zapped slot alone and dropping the rmap the frozen source still held.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

