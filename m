Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9FC606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jN8xl8uy
Received: by kanga.kvack.org (Postfix)
	id E52676B05B0; Wed, 11 Nov 2026 14:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBFB6B05B1; Wed, 11 Nov 2026 14:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAF86B05B2; Wed, 11 Nov 2026 14:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5EFA6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:19:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36773403ED
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:19:11 +0000 (UTC)
X-FDA: 85423801302.27.A3F1E16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A8F0180008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:19:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jN8xl8uy;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794424749;
	b=xl0HdjN2msLh/44v1e8RF5fG1ZxjyspZ2REewG1iM3b35XLRA/p7CmaSM8ImBWs3fyBDam
	OfE8LfrC5HwhuVaCf5cutHaL03JAD/qni85Ed1pZwcXIs8OKuXaaAtikopieCffeUXGjRm
	nwxAsNtUA/6TdQoQ8CoBxbxZoIN18qw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jN8xl8uy;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAPPZVTkRlTwW1+3PqzGIZjGZrGorIqtZwoux0Jo1t8=;
	b=TNMmmoP3ZMJrsod9kDoqOfyIPdd+v/Bfza1pGKrGCOX5aL2rayJoP0g7iQyuMJsdD/NpM8
	U+MVRULf/dqocB/+HblTNv6DgX4yht62+oVy/pZGZ3ekbgb2FiPAS6CQA2k1D2o4HU0Vov
	VMgAZTi69g1bJc01FlceuKo24cvpovk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECCD060E06
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3D31F00A07;
	Wed, 11 Nov 2026 19:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424747;
	bh=qAPPZVTkRlTwW1+3PqzGIZjGZrGorIqtZwoux0Jo1t8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jN8xl8uyWxmv2uIiItBYJrA7J3GD07lP8UBakX7bPdZOsi3/k2ug6PPdtIMCnK4Os
	 amnP1YUDR4/T4pwSUgkp5+JcHRPZAbZYb5aMdcTwof1uoiynngiIEdWycThTBjmudu
	 woqN4zn5dOVUATWwbgqhkB6iNPXjztGdmPwgBGXpk5AswBP0aUNWVT5WiuR7yehVwk
	 UNTAqtyuGnZoMq0o5/bQDrXyBu7NjHXJen8Jpz57AvuKTT0SW5Sucnl9vBGwRcPVx8
	 +5PKe42lahspMkM2jIH4DW87DKIxgq9pFVsQPRcHSXjc2xBn+Awbygf09wPY5tuEBT
	 aO1p8luxO05hw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 29859198003A;
	Wed, 11 Nov 2026 14:19:02 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 14:19:05 -0500
X-ME-Sender: <xms:pb_0anxl5grZleYVCEAHUdoMH_SIdXgNi3YSamqe-e5ICnkz1tGVgw>
    <xme:pb_0anj4-ow4J-Se1P-HX4G-18PohrUySEMfY_cCS7lwhGvvhDfrubhKQv0XyM6vC
    PENWpNMYUejKoGDTcfI4npDv7t9ZqBXQy1cNES9UyrELkCHzVW2KG4>
X-ME-Received: <xmr:pb_0avL9ISgP6BHP6GeBHZCV9oJpcCy0y8t1mPqxNIyK1fbV2GJABeZC8i0>
X-ME-Proxy-Cause: dmFkZTEN7KIAjWcjeVWSiqg1tb1AV3/0ocRjzhPZnrhv3Y9U5nJDiFMvHQfgcNVbET2IHS
    V4PgnXLV9GMRFgEU71pzcq6gDDgB+miAQQzBL2ylvgYsAvj0QwsytTmr4w0cUsyke60eOy
    uJ6Hvpqb7Yanyi8J+98etPY14DsAqvHzmY5dXKhYnySsPS3S7QJZ/cGuW3BHs8xDfim0NH
    MUNL9Qj6r+CWWTM1Cj+OeR2EF3jO1lP67NDR8ZmuFyjEXx8bdLK1a9V7dJK+wa1ehM6+lI
    pj6EITLBXH0M9k7DH7EEEU3dSIOSx0j0jWAnqHk/C2/g4M6eZpEQa7nxOkec3pGqah7MS8
    eerAnsVmA/fyaJ7yTNv6jfnGcFrsI2GHWkfZXfUCLJpXT2qURk1xU83UgPK+e+gvCXUz4z
    nuMl5ejEY1zX8zCH9Q6C7PlXbAgwKNDJ8VDGKcAZvL6VHUw9t+lWjBJpRGJ8Za1Lb+P6vM
    49kWRACh9Tdxm2S4cXwNPUtrTngDa7lskaOikaGR4VI+Y9r4nFTlvEklE/yCMmbGpk0R7A
    9qhI9mAw/GZWRLLTTQdklNUxuAFU3ccIPHnjNF0BINrY4KEHMNMh+9EVJNv1DG12kcYOPl
    zamrk15mS2yRIKoeTbObYg6PttDCkx6vUt9yHNXH+OLLP5esTe3qIo1MqZiA
X-ME-Proxy: <xmx:pb_0amfQkex2AYXXuqLj5bosFxgke5x06wC7JqYEKkSx_dz-wO57fQ>
    <xmx:pb_0ajg02CKYIzWlBSgSCGDx37QItlV9TVwSxDOJWHWiO0zyd9xSuw>
    <xmx:pb_0ark10NYuWkVCt-oUoafq6WDDt67eV93dfUXX1vf-hCtqLpjPIw>
    <xmx:pb_0aqVfRrB4FhOwkLuDgt4nXNI86V05WUNmvz2UCGKQ4OzjjMmvfQ>
    <xmx:pb_0aoo61dkYFNf3bBx8bvoZ1ywawEbkp1leS6v-OghpHYIw8xqMxwFP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:19:00 -0500 (EST)
Date: Wed, 11 Nov 2026 19:19:00 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte()
 prot-update race
Message-ID: <avS_WaLHYxvwoZXM@thinkstation>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-2-kas@kernel.org>
 <avNEgmvYdoukt6MS@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNEgmvYdoukt6MS@gmail.com>
X-Stat-Signature: 7zgaod9gjyssjnyrnrmri6rdc6839s8b
X-Rspamd-Queue-Id: 3A8F0180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794424749-338405
X-HE-Meta: U2FsdGVkX18R57gJGZpJOcfNNy0CxjDTePqV5BOSNq3r1Ve4YixwAxEtJA2hiKDqUypzqHKP+BO4Ixh6T5HQiOOGtozu3j43D/MdDmltXnqfRVow1b1z1ATdDHiqnNC/DN6SDVhC6fIn+SYC6EK9uLBvf29TeLHX7F7HVoaVYLZRXLIui5xtpRQF7bPQlUdeR0PGG5dJimrCi87aneqUez0Ce9nXcNseVnnnsjxkhoQMyOyT2ZUuo2JQq8bUJXSa8OerN5GBAkcBdBQJTUwUrTmilaExYZyht9kAds2jeKksyz6p4PNFGxuP0a70FGZxbF6NlFfNKaBJububXeS16qoys2ZD1bKL5WWwB+OoQndJ7Vsmmt+gGmqGDTqnH4bckHew1qObvaTNlU/bINEqs1Z2450a72h1h+PmgUR12G8n2QjbHtRAArOh+tpW+BSHkad1H+yPecotMGIGHJ/XzUd7P+aPVd7fNxTfk4Kc0uL8TXQvvKTbJXQBkkOQkg1hTlWV7hwweciR2RCrH+3LFEJmj1cEOzt60+gw51es3fSM49HI1gJRuEed/fJ4NpfPGrduGe4dRomcK3bvtv+8rFrCgRPd+sNAgHdj7ciD+M73aoSYbgfqzYmbGab+3hz1D2Gn6IFQWEPuDXgMhv5p5B0e3CYgu8VYhVudXCYPqUEc+qps7VFwnDCTUuJtZOPjHlGXPeti0A/cphXEFiZEu3KdDZITTfrtcR2gROcLvFXlY/vQ676xltfRoIqU+mvQeYO0yHyFljN4lU9iMsrzhoURJevlFLkbKvtLG+DMah2k5zuhT6VzHyc3U3A3dgTmsI65Mvs6IoxNXtMMYmp24Au3fC7tSON/ieHVgV+MCA3hl4MAtlAjgDpfWuv5hAFWalavIqUK9eC7/+Uf1jRRBw1D3PzvaCJEM2J9Mrnv/YOZZAG4IoI6I/w2rZeGQ6oyKe03FIzyOreZlRFKczr
 WZbMPPoL
 XxC9dMD6PeuokTnoYcbUHQj2vMdPTWvSoy0aUHNkgQxlDTMFiARfCE3PXNfdEbIbEnCq+7pyyZ2czWKaDmdDTp3AYidWriE93VbSnSgNPmnRwzSaBeC2vzmHuGbfmouUWBLxI3XiJ5iCWooxdsNBQxoVXCutbD6TWamYEPLxaTAWpECDynWbb7p+zQo/7Ax1IabFk+7qUTFOSkQFD0uR8k6ygsXYfL3gow1U8sqOngAt1KtA/+xBe1Ka47Ciu2s6jQuNTNeiWLsLArW7LyGkKiY7fBCi5TCkUYfn+JFyAPkpUAYPsTEdpBIpQtbbkvwGYPjIn1mxaJVPgd9iqBnLi+iAjnqFniaasv4cjG7zrmXm62R5fAEIxJekc/ipELMsk9i18RYiN+5tXdGyzRGfdLrxWPGgajYChjGpi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 08:23:11AM -0800, Breno Leitao wrote:
> Hello Kiryl,
> 
> On Fri, May 29, 2026 at 06:23:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> > The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
> > ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
> > pattern for the present-PTE branch. The migration case stays as-is --
> > migration entries are non-present, so there's no hardware update to
> > race against.
> 
> I am  seeing this on next-20261109 (arm64, PAGE_TABLE_CHECK) while the
> pagemap_ioctl kselftest runs next to a workload that migrates pages:
> 
>     WARNING: mm/page_table_check.c:206 at __page_table_check_ptes_set+0x168/0x178, CPU#21: pagemap_ioctl/894691
>     Call trace:
>      __page_table_check_ptes_set+0x168/0x178 (P)
>      __set_ptes_anysz+0x50/0x240
>      make_uffd_wp_pte+0x104/0x1c8
>      pagemap_scan_pmd_entry+0x1b98/0x1df8
>      walk_pgd_range+0x7b4/0xd00
>      __walk_page_range+0x108/0x510
>      walk_page_range_mm_unsafe+0x150/0x3e8
>      do_pagemap_cmd+0x418/0x7d0
>      __arm64_sys_ioctl+0xc08/0x1338
> 
> given you've touched this recently, I am wondering if you've seen it.

I have not. But I think this patch should help:

https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

