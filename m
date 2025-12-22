Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA67E674B1
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1AC6B008C; Mon, 22 Dec 2025 09:02:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F2F6B0092; Mon, 22 Dec 2025 09:02:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E866B0093; Mon, 22 Dec 2025 09:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 932116B008C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:02:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C8FD1362B2
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:02:25 +0000 (UTC)
X-FDA: 84247271850.30.1FCC0CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D842D40027
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:02:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYFrts4x;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766412143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daaZUI0rHG3L6JFJxg0Lscj5aU+I5LpIKFJCNAQN5mY=;
	b=xOKAL3O+LJU0R2xQ+1P/dMzw4ToXuJt4ok6XbTnHkDPzUNAEpkR2NFCeoyPKXMeVwUyaMF
	bR3Vs0AqbIDRYOeLRkvNDPo3bDi9QNOXf2KXNIjPwg4HcdfoD3Rh+Gk7YrXbjg4O3Q5mX0
	kLLc0SumPB4oP0GfTehFU8RrFlP1fKc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYFrts4x;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766412143; a=rsa-sha256;
	cv=none;
	b=2wE4mi46EoHtfXSvublFxlu4vJX9Ny6CFf+5Bt/9CqhGtqZeEULc85thDkl77oK8RZaQmV
	kXvtQhiuxhEikiPvKaVKYJ5wVdsPSz2Mcz/cnH9dg8Qu8bvX6j8864j6EEkDp46iILflRp
	lqYIN5W5H3km6XxW/wkqFvPC76/Xj/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A5FF40C3F;
	Mon, 22 Dec 2025 14:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB074C4CEF1;
	Mon, 22 Dec 2025 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766412141;
	bh=angDPqsri1l4EgPCTQmTTdKIzaMZfzd8+IQC+H/aT94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GYFrts4xxirZO22X9CKr9WB0kdffJivhT8qfT+xtawnIcCKoEYoBzS/tVdPt8Ux/8
	 Q4KJ12mLmASXzyWEyRXQrW+v5HuI7GwR3BSW9vWTMvW8DAPkINNqJfY/W6xRxwIdfp
	 rtAUAeRm1Sj2TRIrifkjyXu5rwtEW5YyFEqbgZo2Oj2vmIUObgppiI831obbl682kH
	 yT9OeqFvSrr5qGzWy7tfXJKbV+sG+FTJ4C9mVyqy3zgxwy/jkj1/EVoS1ZonggzlB8
	 /27kR+L0saXw9hC+5Nu2n6m06zppqMljKqZdY7lvjn+HhVm0JPDnbt1jLi+x02GWFE
	 ilItFqXkzhHsw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0CCA4F4006A;
	Mon, 22 Dec 2025 09:02:20 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 22 Dec 2025 09:02:20 -0500
X-ME-Sender: <xms:a09JaZtnaUXQ4I2PSprIbMw-RRZLUBM0JlXpSAuOgDNJ7OSZ-6OE4A>
    <xme:a09Jad19GUwjHcmMHVkgRDv1W0CkRxB7-ufpdm4C2WtK1ZSRwJ702Oc57dwt60so6
    OXvHGf4l0KtAIC5rCthKsGzlWqxEZuqrCkYYg_iwOLqz92kQ-ITukI>
X-ME-Received: <xmr:a09JaWIrXChbBF057lHRcADCLqo0lIxIQB9Y3U1e1cJxhRtsOXX4FRl8fYVZ9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepohhsrg
    hlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihies
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehhrghnnhgvshes
    tghmphigtghhghdrohhrgh
X-ME-Proxy: <xmx:a09JaX_M-2vxdtu08YVROLuORFY8naL_-GK9_bhTIMqt9F0FXNG8EQ>
    <xmx:bE9JaVgXreAMY98sPJEgWQpKNsDW4rIDdB_H155eE9vvuqiGwEKVeA>
    <xmx:bE9JaWwqMaDOPVPTfagL47fTmsRjsJdvBalg7uwmI8oNqRCWmj6ewg>
    <xmx:bE9JaUrivezvxDm3npsh7Dckqioi3u-rU_4uTe3KwrG1jAizcu1pEw>
    <xmx:bE9JaS4wxAFXrkKNV6urY0QeM3TOmEZfW6y5doYXV0BXOX_50xGm-Git>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 09:02:19 -0500 (EST)
Date: Mon, 22 Dec 2025 14:02:18 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-3-kas@kernel.org>
 <430d554c-840f-4813-b715-5191d74571a0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <430d554c-840f-4813-b715-5191d74571a0@linux.dev>
X-Stat-Signature: fbxqx3njge1y3qf7jnkzp6qziuu68h3g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D842D40027
X-HE-Tag: 1766412142-245610
X-HE-Meta: U2FsdGVkX19lraJa2rBbsi5FKJZy+u/XKftDsUoT5ITQnsMiaur45vtSZT2Uveuxu89sC8MGpDh0zI9BMeZr/03oVMZAuamcpcfjRO9jJG5uTTqy/6u2NjyPVoY5e7IJFkC1HOtwBExVwJcN9GPkhlIJPDOWwMOOhWsmSyrF5kN0hTImTe9BsBp6W6W11QJTwy4iFyypMAAdHHuyNtMdh3ap6wask6c0dOn0IZL2US0r7XkEaTCKlXudQpNctxacE+lYh6WPB5K1ZeUrOaduyftGEzW8v0xf9Xdyksz2lB6G8awKB2SEomkpYrpJ75SiwjJ8/zbhlazMeENpRDXDzUKMQsqhtZUtKBh4V1Ynl7OoL5oc/indbNE98gLmeLbkXNcrA/Nz0oiTpRorjS+Vl9c48ID6gY4bh6oe4TT5inMYJ8dNcptutjJ3FE3tEKH7HSsYDX5KgiMggdz7na9xv0LTh/NYN90hy3f1Tqhaz2khHEK1FrrPoGF64DnuTp9fBY25CduIKQsCFPWHMEWjbf8RVKDwu5AsYHBk6mykTNpOKFw0ngz6YSWnxLIZJmCQroYnI5MckY5DR5xbLyBwq4DSESF0Rqcd2od4TG7CUBXiIsCrUjxKTTJMinKFUHDRA/3sCSNR4qPSPW0uqBLmYhlaS63vYTzx7hliDX4wxnQXc0MVAnq1EryPTlvlW7DPcCnoKx/UrA47YAiznZvMfLlqq0PbvfGfmUhvFV4oSeKRWSWFywovkgJSAHzdQjBg1KmV35c19Fh8X1iO1GkJK/x0wJewhjW8I0FrkOWhdlWwVDEwOJOBBhHnpvcDpKMSAHxkKuT8t1vzarHMNkHba1wJy8ntajPFPACbvMrr2zGUF4FZbSZJYhwtfsCeh8Mw7JrFIzwbFL0/or/nwbc8v2HySFpck96JNJzUyxI4uF7plp3mmGLsljV15WPfVEYw1krND5IH6Fb/T4vc5ps
 E0WsX/SD
 eX0Kvp8cZj/setckaQymdtcgh8LRVtD7be07oPzEBHymPxe1tTP8DZNvAuVS4ewS9s9z9I3dlULeRj4oNBRQKnaKUMz/joZEzSs5AvxOvAxXzW0A5DFyOgaxILpNH/Zt6vS+WEhJGgeV1oitpxbl27e4uHpIsg0YFULufVFQi0x3/DJWCbYePI2qR30+B+MJayPxdKGtiy29SoenEjhWwQILTr2DcKoBbZ+tpEVIphMvhoptObSS7ViYo2WR4BfgCKAcvW7PQyCuCDk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
> 
> 
> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> > The upcoming changes in compound_head() require memmap to be naturally
> > aligned to the maximum folio size.
> > 
> > Add a warning if it is not.
> > 
> > A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> > kernel is still likely to be functional if this strict check fails.
> 
> Different architectures default to 2 MB alignment (mainly to
> enable huge mappings), which only accommodates folios up to
> 128 MB. Yet 1 GB huge pages are still fairly common, so
> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
> miss the most frequent case.

I don't follow. 16 GB check is more strict that anything smaller.
How can it miss the most frequent case?

> I’m concerned that this might plant a hidden time bomb: it
> could detonate at any moment in later code, silently triggering
> memory corruption or similar failures. Therefore, I don’t
> think a WARNING is a good choice.

We can upgrade it BUG_ON(), but I want to understand your logic here
first.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

