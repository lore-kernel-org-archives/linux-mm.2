Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA41CD3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB846B0005; Mon,  8 Dec 2025 04:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585986B0007; Mon,  8 Dec 2025 04:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D626B0008; Mon,  8 Dec 2025 04:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D47E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:22:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD381133C88
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:22:06 +0000 (UTC)
X-FDA: 84195762252.23.B8FDC67
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7F41160016
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:22:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qjN1SahT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765185725; a=rsa-sha256;
	cv=none;
	b=Aw6VCSVGlI7hSRYbzlruTBzeJwXzDxF/LSgMblYSUsZ0ubvZTyJlNtnpxLDCM8vHEUQREI
	5kkSpCIC9l47NpI/2mdsjSew8G515xSD9fVPmvOeP16Ii20Cly5GUpWwgv/zTPgGMqOjod
	IeTdzRTLztqNl6r463vggLnmzD+rWSg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qjN1SahT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765185725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dcNIAJdjwBa1TCUp38vaur9HiS4AJA/cGpCIXdnO5E=;
	b=2hil6Dcoiez0jXye8RvsKRkM1lmoobP6YJf9YM3PXJHYk1iayjIImoVKdF48h4YOw2Y6Sp
	tl0yRd4wuuqOrh3M7pUyv6V2gqaTFbArJDfcG4X2qEHL2gwaCHzwDY6dGKL/hmfcFTz5ZP
	SYfF2Ojc2I4OMofeIzRmTq5U36SBMpg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0dcNIAJdjwBa1TCUp38vaur9HiS4AJA/cGpCIXdnO5E=; b=qjN1SahTYyloXwm8SJrCrf184I
	w9otFRfJIiodnl9/tkfHtO4amgYDh3/l7ydG9N8jUIaIEFReEkPhEbGPBfzJLPA1P3VjD/0InX4Hp
	ZukfS//KM0ELhf/LrFMpObb6pJjVA3uE9LeBBfzwgb3as7+Tf5XIm+SLGDGJdPNlYBoGwNAUh2Vl0
	yvWlMG7GDDSC/pSw3Ncwubutwjued2F6uMyWlmhsRFsm3ar3Guo1WoZZ4xEXtzCpO9U5YE+u8dRtJ
	H364kKN9S6hwEv7NLtxWfLATsWg3e8U3nKECruHTRbtkxYWRzFlz11xTbvp7HTGrZx3QxcduZbuhn
	j4tYR28A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSXRO-00000009aFr-4Bvx;
	Mon, 08 Dec 2025 09:21:59 +0000
Date: Mon, 8 Dec 2025 09:21:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTaYtlTdhxKx2R24@casper.infradead.org>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTGmkHsRSsnneW0G@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTGmkHsRSsnneW0G@x1.local>
X-Stat-Signature: 5yd1egdtqnysdykktmotox8jb1k47b4q
X-Rspam-User: 
X-Rspamd-Queue-Id: E7F41160016
X-Rspamd-Server: rspam01
X-HE-Tag: 1765185723-742438
X-HE-Meta: U2FsdGVkX18i9ZY3t6LD9xukMseIRnRyulI2CV5EBGBGpthf6y6F/f3Cc0qwSt/I4U3ro76rFXvrUcI9+9a4aaYyRb44LWUnYr+/N3YPuhzVo8ZFZ98rDJSI0c0gkMMXw82mIAQ2eH3wcSTGvajCYNMbhQ2wPZZnvjIH5tY6j/bFXwxWOe1QYj45b9jGN7aWnwq0zlpBMuCBWGk+SzZ4PwurC8wdx0ad0Of7d6BoDQdR6A4cRfZ/NlNg+26jBTfXjC/MrGxYy+yrsO5wnrSRymmqM2BliSNnqtARYA14YQPf3oWZyvwXVrNBeCjYIp8/BCWhqv3MlSpiNGU1rMkEpyKtxEWYPqylNah0Xqb1VYfXJxLhWwLnOW9SF20fiXPiFldHZ6K9oW8aNKyw664Ug1/L80+D0tMAADrEnu8uEV4pbDsaSJzAfmxPYTXbNinAwp/4fDpcK5y78gQ37L3a03VrljthtIInoD1bSSeedTA3+R+B8QOdyFVhyP4xxbigSeSaRWN4Q8Do2kORzyfDAxuhEaTtWZSgZY+JB3jleuGO2NplvYDuBR8otZGZy1SDpCKMGNNbY5dvJzbY3EILBV6XOX0YVaKofTQ+h1fSV3/72NUxSxkODCxvx81hPJPdR8qF99PEOjDo73j+WrpYemYYnkOSz9XjzBiVT7KKwU8gSfhPotcNQa4Vg5gJaaDbidGXo6xEqszHsVilD+GAu6C1EVG5mfeCvpFULgbs4bxkK1o1VIfDSzkcrQ6yWZE9cjz/hgZoFZaLKsk1uMipw1L353srzGqfR77mjOfLipyYzbnfDPigzB00V2tdeBfXzWh2JTuAbLD7EqnyczSwGwL7eKkYM4UrClXpzbeQycL2hYzGVtwTAtTAJAz9NSC4BkblE0egsSXskgrsZWyyqya4UlGWiffjiiqdhTQP2lB1ZUDfDTkndi8XExx+QF2t+cPQ8LZE4sOdiNkuxCb
 atFPjIGy
 v8aWPl2SXwwfjVARtAlXB1HGYrIn3TawxNtu0Rf8HU+Gg1L/dRs0cqGgNpYJr2ZhmI3KBjQXzFM2YB609VuSzgpUiRWjQPlVhmCTlG7DsQUPmIBPRVdyZqvqADZ52QNmXUI5qYVyisNpeaDW/nTBxJMaKO67X64Bt8Wziuqnq5GHotxY2DLmsb/YD8vnJOf/Vw2/DO6sHRyKmHfDRvVzNs6gMLlUgfyYTUbr6k7DHpoOiiCshaOysZejhgiJ5mumvOW0++rf22PmCc0kogFGGgwPm2DkA+s174RrKOuH5/7sOTHihGWm77vvka949SAuOJdNTHVgypGJYaGFvrvN7ycOF68mXIc/nR9MmognKq4usHcC1nasTTNoc2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:19:44AM -0500, Peter Xu wrote:
> > Add one new file operation, get_mapping_order().  It can be used by file
> > backends to report mapping order hints.

This seems like a terrible idea.  I'll look at it after Plumbers.

