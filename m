Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D12D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5446B0005; Mon,  8 Dec 2025 05:48:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0562E6B0007; Mon,  8 Dec 2025 05:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E871D6B0008; Mon,  8 Dec 2025 05:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65C46B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:48:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C52B160A5A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:48:49 +0000 (UTC)
X-FDA: 84195980778.21.6D31A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C1E920014
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:48:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=trlcaSQW;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765190927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxbeF2ils8a/WP1gcY1lf7VSr0dWgYXqsJf0XSTeT5c=;
	b=oLGZyD5CaM6ryOiVkekt0h6YxGL1skbkseq8tdwonMA0FQ0CvBgVYMNiDw5lqS3DQ8cZpx
	cxIU9LsDPA/Ct6WcizeMWzOsnbaSlgTq9eqDWLqHluVkEnuKFiIWFbOmnjGd9p12x/feJi
	aNKcmu8zbX/ZWxUAo7JTKA/9I5zPWbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765190927; a=rsa-sha256;
	cv=none;
	b=suLtky1LF1/o3G5bGm86SKF00ohb0Vp6UtoAAA/pixnZ3GGA1GuvpJmS+3v+aoYEIaj7Dz
	pKQeV7D0Mil00j0j1jZklt3pO0HF5V+6ldy0EP2jj/cASF2o+b2gAMQtc1VhSH4HWwYjKi
	BoHBNOdaQ0j+R4NQqhyKhKoyNpuYJdU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=trlcaSQW;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABC3240AD9;
	Mon,  8 Dec 2025 10:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F9C19421;
	Mon,  8 Dec 2025 10:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765190926;
	bh=rcNksnfe6yY86JGogzwOwacOXhLYj1M/JZHVPYbr7X0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=trlcaSQWYBzrnbny2MMx8VNEQCqlwLvbkDMkgUROpD5e1JCj5v2+wVDjPtR2HbbLt
	 lRqFE33DfsJPCH9gFtA1gtiSxNUVCRnX3DBenJvw+Td4XgvlhWswGuFmG+X70Q2P9Y
	 wxyPBY5/LRWzBjfV2gM1lDKNHTzrAz6BeScF+hwrQDDD6PCv1dSNlnjmiskTmzLcFf
	 Pg7y2WXsD5gifCUr8yYD60DcdcVDKerpdYau59Qiz8q2K7rTg8Fje9QlIiDp4e1X5c
	 nI5i2bvS9XnGxOSAfUBxQK1jqfnEMSCDilNp1FsV46qIlo+pmmkjBoXx7ge5YaFLdh
	 wIUvcigTabV7Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 280C9F40068;
	Mon,  8 Dec 2025 05:48:45 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 08 Dec 2025 05:48:45 -0500
X-ME-Sender: <xms:Da02aRk-30AokWEJl_zHP3tZAQk3SRaGGby9UXLSEB8v0QT2zvT3DQ>
    <xme:Da02aTpMBMIWgYd9R9X0q1CcTw6FtZKH6Y4NFJzBYFAl3FgZkeFR6_1RGKQh7yqrM
    yEB8FB8RjVlfA66u4QXgijvruMDzj9FTz8lmsbDBRenErlfIhJ4pA>
X-ME-Received: <xmr:Da02aQknVucOW0l-XHMMnb6z8azwz90k7NCqDsVJlLt41gEVmEG5vF_7guVoqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhu
    nhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphht
    thhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuh
    hsvgdrtgiipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:Da02aUaADskLn7TlDBumoCTkxl3JM5pYFFPJVrxO7vYyqH6gz7B_rw>
    <xmx:Da02aUEFpLbHRWQ3eTNEXt_48wOOFRkSzAvYKUcdsjhJQHLLPqUTHQ>
    <xmx:Da02afMKabkartllZSf0AHe7sfCc6EQb9ExU-PW5JnxoMKYSArnoKA>
    <xmx:Da02aSw4VC5kJGsxMes9Na5AP-7k4fmMZsRmuD0liTXI2B8VeGnz4A>
    <xmx:Da02aUm7TOir-Cy1Avs20u74eEtlGINRXFYhpFEykZYxH2B_H9vyvhio>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Dec 2025 05:48:44 -0500 (EST)
Date: Mon, 8 Dec 2025 10:48:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 07/11] mm: Drop fake head checks and fix a race condition
Message-ID: <2l523g5soivzdi5yinyxdmkdd3k46q4buh5zprdeynplgeay2m@ivmuipyx33hy>
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-8-kas@kernel.org>
 <17002374-e135-46a5-9e4c-c317ac9823ae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17002374-e135-46a5-9e4c-c317ac9823ae@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C1E920014
X-Stat-Signature: d7ri8fkqkd6qm3dh83msg6a5aaj384ew
X-Rspam-User: 
X-HE-Tag: 1765190927-837754
X-HE-Meta: U2FsdGVkX19s8yoFy+1DDD4o0LJJYXs+2MJI66pyv4yai52j5kMG3R3w/5YPXNT9CZOuSmPDW0m9XoVi7ZIudWNDXaCPHAxOhka2/yJiGmbk3v1nZOBStNW0HzNrYtyQsYrMNQpZNfABTbBbTNcpP3c/2eydOVxg85E2daNnQRk5EWzL9aUc7Tq/YPqymd1sc9oAg7HLp8By07hD7xqb3B8JeZ7v6yCNoNMFXgL8yQKRVF1u4r6Lx94ZbFnUFl3mNiEE+Cl3bzrw/CQD/gK4VgJ60S2nXLHtPArs4zQSVZTMmUX8o1j0bKr0N1OAkqOQEV0I82cRPT6VoQ1lz9dJy6lf/8lKCR1FzgTph26CEdxPxJtW4F7ve2BVOpH9nwTx3hdLXhvleOeOauQLZW1pR76LVm6x0mGPehDLpXO6R3wSmljHofVImnHyTj96SWwBoiFpLgbLgv9TTTk69y9j9EZL45U1Pf9ZnU5NlqQVw1vgR8jVj0KMymqOoaCNgQ7OuaWmMftpsA3lkjdYRYlNnd5f7b46B0ZXhbqalC+ktodP8Z78rbdvf2Az2DxmDBSNcCb8S3KyrgKnTUeWt/gN7gUdQMuBGkkbCX1rxmcs8NTpC+J/aWjeOmHSB/0yjzf/Y270knIp7gGQ/j8drfENEoafRqEKGwJWqVE4xkxM2evCbinLbo7BK88ZsYk4RA+pkK2qrbqSqZ+GODhFirjm7FDGEzn+gBzZIRpEe2SM660dF+XaZXFPihbdhayjZXT1ODRMXv/iNpZye6yNW5z+30BDTk6FSWiN8o+cTVCtlDhqo6c2LbZnHsXXqmTW4kW6oyvVc7y5+sg25xCfZ4CSvyTj3bECotgcE1mZbNSo4SXd/tLQHQzzYGr7/Uyxt/o3Xbxa+FG8wkjLK+Nz2rf9ntTnl6v8jCq03qxGwygWo8+0uo973KzeeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 05:27:29PM +0000, Usama Arif wrote:
> 
> 
> On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> > Fake heads are no longer in use, so checks for them should be removed.
> > 
> > It simplifies compound_head() and page_ref_add_unless() substantially.
> > 
> 
> Would be good to mention in the commit message what the race condition is as
> its there in the subject. Probably can copy some text from the cover letter.

I forgot to update subject for the patch.

Yes, there's a race window in page_fixed_fake_head() between checking
PG_head and checking compound_info/head in the first tail page.

But the race seems to be harmless.

Unlike the race in 1d798ca3f164 ("mm: make compound_head() robust") the
caller always gets valid pointer to a struct page. It might not belong
to the same compound page anymore if the caller doesn't hold reference
for the page. But it shouldn't be a news for speculative page lookup
path. Caller would need to re-check the page after obtaining reference
anyway.

I will drop "and fix a race condition".

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

