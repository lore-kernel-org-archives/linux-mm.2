Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0052CD37B2
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 18:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03466B0088; Sun, 10 May 2026 14:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4326B008A; Sun, 10 May 2026 14:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA476B008C; Sun, 10 May 2026 14:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5A26B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 14:14:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDB511A0465
	for <linux-mm@kvack.org>; Sun, 10 May 2026 18:14:10 +0000 (UTC)
X-FDA: 84752309460.19.36B4745
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 535991C0007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 18:14:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GgKCXiRQ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778436849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7DQ/vYvARfFdJB/8x28wyGNzuZPqszRQWFPsJhFTXk=;
	b=3BfQQWnleb+n0BmztcgCvND80IU7pqzHK7ECnu5tSEtTRPfmi8EpM/Mp9OXe8y7PkwumNi
	LWD0LT8OwznuxlA2zckZ5sjngmUSzD5p0BGfHlZMsJrfPVZsFBWIJp547aVNMg5Z4KsOfr
	6PT7j9DQcJZs7HEi2qrsHXTt5zYNIVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778436849; a=rsa-sha256;
	cv=none;
	b=wwX0YDXyhommYa59tl0yrBoeIOi3gKEPAvZv/MA4Z9GgFUXadFUZnsOBUHAaP8guJM9xVm
	NJtm1hb9RqO4YttTz+mpNPXHA1pkb6CKFj0VzHTzW7HI2/MBhf9WtEw67b96vatuswaxB3
	buO9oVaK+HlAuFZrRjQDWDQkNFxooDE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GgKCXiRQ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W7DQ/vYvARfFdJB/8x28wyGNzuZPqszRQWFPsJhFTXk=; b=GgKCXiRQMDX1z0icy8zy7crt/O
	htvqNd1Iy3SJ9eIdtoLcJ1HUdlhue0sYkt9FLhXehrPrkAyAUap77KeCVYaxTTZmOq0mMeDBbhwgu
	G2gtj8NDrO/+r0vYE78ttuIJfDPifSvvVvWwtgqoBQoRv82QDRLMuVcmeW8HETTgBfxMnU9wb0A/u
	kibGr0Yc6VHdh+P12gU5t2aMuyvxrmGo4aKeLVTh7ovag8Eh81ftT9HayNLGIyCAGY1/5SVRFqi0X
	Sw+ztLChK4995aHcOb/no7zNbwzPuMP2HX+arpl7hbnXpYaZTMWliJoMWRAi8u3Khjyq+cr4QBxOm
	OWSa5BFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wM8fB-000000078hx-0W3t;
	Sun, 10 May 2026 18:14:01 +0000
Date: Sun, 10 May 2026 19:14:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fujunjie <fujunjie1@qq.com>, David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio
 failures
Message-ID: <agDK6PkESVR5OOYn@casper.infradead.org>
References: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
 <20260508163549.40a7f3c8c4286a553855b02e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508163549.40a7f3c8c4286a553855b02e@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 535991C0007
X-Stat-Signature: c1nh6hr3jbipysjcou1rfoqyzxwbuumw
X-Rspam-User: 
X-HE-Tag: 1778436848-900396
X-HE-Meta: U2FsdGVkX19130bltNEDGUoXQUOKdYrzjnbkhrK/of+tIwpZ7FgW860IBjzVLRzgHPbEUUdx4ME4HBlywS9DyNFIC/3RCM6XOF6nvo66/1fI+mXYNApqAZwbTxoFW/KBwN5kQWYsvfg+y6/L0IbCQui3J1TtJraJIsF3CBVB4H6VIaH0qWtP/YyoEI89acqijkme6rFtllx7tyAC+PvJZCY4citOgxYm7CGtkXj4z6A1hPOWNlQWroByxFiGJ8qt1pUQuBQ6Jd+fFN/A45Pg6hwxrmwe1VqcPH1SY5k3rpqYeccfYT24UNMflzJggKGaftBPjf7uGLR9YxYXXm0P/eVU7xSQSxEguJmWtwXW+nbsNpPHgcA9wHiEhbFYeMg//gSlfnT5mkgagDyRzmDF5e3RZY1+Na+Lz6gOdnjxiVz2ApaX0Ay4qY7dT6rMkCvkUHOlFUawiItaOGQYMbw2FzptysP8UNIcNfOm4JWwHtBOZiCpE3UjLi1M6nNpxKT3HAxLuOR5hgfXjnql4TL5sryaHujk8CGzxdN1DASPee/yEs/d2WzwWppoGMgikRAWuuvdC1G5pnbnuf5Fg5Wp7NSEvc8tmJ3Julxw0zBiYTyVKwdugRdR0TfAmiK6wJeU/5gfvRILn8DYUuplSujk4StK2j8u+gx/SoXIvUEWv2Oa4ZwGY02u50r3fIqfo8C2PPbgnvPAPaABNrHLurJxBKVZaI38GwAaIAKuIffh9sYjVTxVAKqKFz+ihhlBcrEBoGampVVcV85kGUjGiH4Fw/UHxd03hCqyHFEMWhEQGKDuCwhOX5yKRNmb/Ei0KbJdw0YJpgpZ09v3Tbk5jLhQmd5NK/mr3nIVm7SbB4twqEFCVL9zIsXDSyRJL2XicZKnGnR6pW1QgV+fPQtQzIBH9qHC+lOICBjGn2/22r2LvnXjHEnoIIPhL0DjK7780Z4kzrFWUt3N0Y0EAsOSe0I
 v0EvVRnA
 neFOwHjYi1/nS/2UX5ogBBb4s+v5M9zNE9k2N44Qa/HulWYWLMC3/Y0vA6fi3ygzSvyV/RMSbbiY2wWno3EZiQVnozJzorvpAPi/jH2p0A0eIhyHSngVErE4LkO0zthZ0qoDivNm/QvrT8k5YRiiHAEFGIanathCVCxEoruXXnyTkMXGr0Q92mGJ26RQUU77rWJMpFl8ephF+ADKyHf+qJb/ZcLitVB6H2BsUjaa/wJbqEZL3FPOpRNyp7lVZ8lafr432UF4xwN4N66Nk8O3juCOdwGrjb+2yUFvD4JGC4Czds3/oxRvPugZrMTzyDqRRA4q5eFI7EMMJCyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:35:49PM -0700, Andrew Morton wrote:
> On Wed,  6 May 2026 11:23:59 +0000 fujunjie <fujunjie1@qq.com> wrote:
> 
> > generic_fadvise(POSIX_FADV_DONTNEED) drains the local LRU batch and
> > then tries to invalidate the requested page-cache range. If any folio
> > could not be evicted, it assumes that a remote per-cpu LRU batch might
> > be pinning the folio, calls lru_add_drain_all(), and walks the mapping
> > again.
> > 
> > ...
> > 
> > Teach the folio eviction path to report whether a failure hit the
> > existing refcount check on a clean, unmapped folio. Only request the
> > global drain for that case. This preserves the existing fallback for
> > failures that a remote LRU drain can plausibly fix, while avoiding it
> > for failure reasons that a remote drain is not expected to resolve.
> > 
> 
> Thanks.  AI reviw asked one question:
> 	https://sashiko.dev/#/patchset/tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com

That's a pretty poor quality review.

My question is why we do this bizarre thing of switching between an
unsigned long and a bool pointer.

I would also avoid creating __mapping_evict_folio() and do the test for
folio_mapped() in mapping_try_invalidate().  It all feels a bit weird
(both this patch and the original code), and probably needs a lot more
thought, which I'm not in a position to do right now.

