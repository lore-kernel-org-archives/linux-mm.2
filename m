Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF148606A333
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=mga3BmeB
Received: by kanga.kvack.org (Postfix)
	id E83D76B05B1; Tue, 10 Nov 2026 14:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CC16B05B2; Tue, 10 Nov 2026 14:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB8C6B05B3; Tue, 10 Nov 2026 14:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9B286B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:25:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31DD4160A51
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:25:53 +0000 (UTC)
X-FDA: 85420189386.29.62FD185
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5693440004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:25:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mga3BmeB;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794338751;
	b=ldAWEwQ08aVlVwS1fhYbSlAoOWPXC4lVgXwdBfPR90TkZBqCz3h5JDR1K9Oe0AndHYzHzM
	cOkpQB1NrwO5QJsk4MsNeMPp6cY5Nlwv82gCB0VylBShRIiq3yI5cWOi+t8/Ny2iJ7cvjp
	f3lTbrAFPM2YTIAI2MJwoTWsUj4k2P0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mga3BmeB;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794338751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExSFRNBdpFZqpaarK7S24/veHyaXPw+cAkj34YFoUsg=;
	b=hy6Gop881T68JQtvaWThVL6tx/4QnjE9TOCaJhgILLDu0rII+Q73M2ymOS8DZER0tUjukf
	CpokyCI92C5mvY+2dC0NOLHYG6RgQh4cv6kNBmm/iovHFX7CB7wfagtg//iTA2pNt1yWqS
	8DwaCWmJvfN5k3waJ9JJ8DrURwZytqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ExSFRNBdpFZqpaarK7S24/veHyaXPw+cAkj34YFoUsg=; b=mga3BmeBgZ2RPvRZvXlBQ7Q9tz
	XouFPDsqvq8SAEQvaqGMv7iU2O+VEH9MG23DJWzJJzD+yrCHWUvM2L8PjOs9b5feXZXH4rEGw14rY
	ZQ8X5cwp1Q4/g4sMooNR7ciLkpZqwN8zkW4at7wmvuvY1+F144VSMQlZn9QZW9aE72mlMJaeY8kVj
	m8kRJbfcnClHz5IhKU8P5KjpVTb2yhuCvGELCXhuujyOho6cVXAlv87ukRNnq+P59eUjN5INC+SZU
	EvQC8rPJfUWhs4w77LHL2DajB6bVUHL2EIJtSZyYCvNMUnwodQOCI7xx9XfanOhzIiU0qnTtCdEcq
	yYulOyNw==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQrTV-00000000TR9-2wpr;
	Tue, 10 Nov 2026 19:25:45 +0000
Date: Tue, 10 Nov 2026 19:25:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avNvufn4HLIhVm2k@casper.infradead.org>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
 <avItd6rDqP3GB6pL@casper.infradead.org>
 <avLzpIM1VdE31a-B@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avLzpIM1VdE31a-B@thinkstation>
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5693440004
X-Stat-Signature: ps8kpgn96fgw37fo6qzn6mpsochddw8g
X-Rspam-User: 
X-HE-Tag: 1794338751-505713
X-HE-Meta: U2FsdGVkX1+XR7zLpB28b9ImD34n2Qtff7BwYp0cQLijVrawsoFpxFlKifTcguCJwSUD0TgJibQBbxR7L7l5Cb1CG1rRigguAmhRmp6I9QORo3DEqweCuzwLEpIdIydtXQY9OHsWNftXiOB6eYrzy+l1UEW8bRxZhPDUeA7x2kvKNmfYYbPjoUsUscHsQhu5fb2ZqfFMDeXOPqizxC4zuk789+VctRQWHK83lXcJEzCie0z7mdlJ6xgLlm3vKLHwvECBH+0PJGhUr101KrrJlw7yqFFF/TxBmmm51Mv9aJtReG7dvgsDb0LYcDeODIpgGAxpRUwTlSYdUFzBjd8NSaMZ6kjrb+NjeBfhgPx2nsOG0xeMFEIRkCFEln8Oc/LNBO5UWjMs9Ly/Qni/8lJiDCetOTZBgocm4TuK737PPXKRx18hAdU79NFZ7QJKuikhP9pFdSjWbNopy9U00xU7dZF9RLCnARIW4Y6bxMZNA7oe7NRdlnj/LNklwU8xqEZ5w+EZ42FWune1RhHFt9fl7XTnW3jRC2hwclJ90kVp31jG2kI1O3GKmU8nsm/ea5mzbG6KhPYTKFmZgo+iRDejIMGYIVDleSHMENdPvgLgskt039UK+agYseDXKqPF1tj/Zi2nqHLsAGK6+UVC1voNC/KvP94ihKA7jvygzGHBvoGxBEqhngEAADeK6eDUBAHIy4xE5UWnug3QWugCoV2/yddDufDrkSc+5kXt4ra/inXSJ+7iEyjJo5wVPfn2Ejh/0jvzu9dxn5b/nyY6wctDpUVPR/HpnOff+etRF02XomlaRjQ6RvIEdxzA+RXKxoTgR/hD14ZiNOZBrNs/2IRd2lEKICbnxZsKl+DULnloEcqy9hjNPTDdVK4mYqW22juf9KGY82TYmXDqmXSHK4EsC7g4eRxqFhom6YbES5U9FQ7yMb1XtQyoeYk5pzgaI17O2X/2ap3Y8T4ywvdm63G
 3MRbIp1u
 0FGfWF8mMwX8uEA8ODcuWLqjJH13raq1aUV2YgINM5AJ6GBWy2ZWT2EibQAo5BI1dtrqNz1TPtUKuOA7CobAPAEZP0tQdn1DoJfDIPP0XC/kTaOuaFS1EFWi4AP/+rE/lMcYCIeVyEztRxH4MLU5Bb0ZrxNYHOAzwqXAVRZoqSfSsY/+iT1u5updjDgpiLDnpxUPfCRB8W13RE0blBh1KwoqZrgCCOTaVo2Bi6oDKQ0xpN5nchl+gzsadxZ+muIf9qJARYbLNwrZndXupaE2GoOGiJKzawP1tF17y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:38:34AM +0000, Kiryl Shutsemau wrote:
> On Mon, Nov 09, 2026 at 08:30:47PM +0000, Matthew Wilcox wrote:
> > On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> > > do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> > > can lock it in that window, fail, and clear PG_uptodate with the folio
> > > left in the page cache. ecryptfs_writepages() does this when encryption
> > > fails. filemap_page_mkwrite() relocks the folio and checks only
> > > ->mapping, so the fault maps a folio that is not uptodate:
> > 
> > Filesystems that do this are buggy.  They shuld be fixed, not worked
> > around like this.
> 
> Fair. What is your take on the way out?
> 
> Is there a timeline for the filesystem fixes?
> 
> Until they land, mm should still not map a folio that is not uptodate.
> 
> Would WARN_ON_ONCE() and SIGBUS, like the other checks in 2/2, work for
> you? It flags the buggy filesystem instead of hiding it.

It doesn't matter which way round the race ends up; if a filesystem marks
a mapped folio as !uptodate, there are other VM assertions that will
trip eventually.  This is one of those cases where we should ignore the
bot because it doesn't quite know enough.

