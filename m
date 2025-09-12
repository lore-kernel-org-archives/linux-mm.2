Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71771CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDA56B0005; Fri, 12 Sep 2025 13:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E416B0028; Fri, 12 Sep 2025 13:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAE68E0002; Fri, 12 Sep 2025 13:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB8F66B0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:15:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48B441608C7
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:15:41 +0000 (UTC)
X-FDA: 83881250082.29.6441F05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 814D3C000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:15:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dq1gGAGU
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697339; a=rsa-sha256;
	cv=none;
	b=qRwrx7KZvmcTEa7USbZAjXv/irjKJRl1dMTAO68SSXCc9D0CJ+FwPcF/aIiu9vC8E3iZgg
	modoFm1kZPh8LgGDDD6I9Sn5KIAHbdZrMO76iSMnMS6CVwF9kRo9RwPrtEiCsPY18hws8a
	cOGhOkYnWYR/tFQuScS87N2tcgSxwnw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dq1gGAGU;
	dmarc=none;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mACRupVkoZ303cQFM5AZgG0pe40b2jKBdiZV9tXrW0=;
	b=dSqEU5KroBmqusr0Kt6ms8EyUjOBOunQqM3xTG6ZXnmyu+4HQqBZhmvyz9gCEqWedM1PLt
	tdG2/TjnFJAi2tkMaB5XHGXwUwicFHmCdOsAL14TroTQYWi3IWoZgdfD+bua4oWFE0xYaY
	L3MwxKBaPYqObQ0lv0DLHrqNlSJmpZQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/mACRupVkoZ303cQFM5AZgG0pe40b2jKBdiZV9tXrW0=; b=Dq1gGAGUIecMjVoAzgNv5v3/cV
	ceIGzx5xvAC2s9XYb7P3QdEsMuqHC7hkxLq6OL/Aazr3KQ8gUn39C5JcS0f2lGlqgHpHrwwe1LU8W
	3Thv5U9l/Gl9Kz1g3vR1Y/u58/8TKFVcfcngDgrEm7moMzmne4+SbTIowX/yNVCAYMILzETWABQyg
	WJA30A8m/P/lQ/XWqf5Stdbh3z81h6hzf8QJrE/ME80HdxTwX5Yba4oAxtm2BSgzNkCwrjSXWdDws
	+AOhUY/HItwivIj9tX2u12eMPRZcl/0OvQO7cYEKTjtlxcXMDmMXuKRD4iBgGz9z+r3awCb3fDWlT
	RP0hFlZA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ux7N0-00000002jb4-2eKQ;
	Fri, 12 Sep 2025 17:15:34 +0000
Date: Fri, 12 Sep 2025 18:15:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, vbabka@suse.cz, harry.yoo@oracle.com,
	mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org,
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org,
	rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in
 alloc_pages_nolock().
Message-ID: <aMRVNqH47mdkl5Ke@casper.infradead.org>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com>
 <2kaahuvnmke2bj27cu4tu3sr5ezeohra56btxj2iu4ijof5dim@thdwhzjjqzgd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2kaahuvnmke2bj27cu4tu3sr5ezeohra56btxj2iu4ijof5dim@thdwhzjjqzgd>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 814D3C000B
X-Stat-Signature: omfxi1uxh35r87cxc8m3zhtjtp8mewar
X-Rspam-User: 
X-HE-Tag: 1757697339-181195
X-HE-Meta: U2FsdGVkX1+tZS3eIahpXgg1SdLgUWm+4ARS8ycjXdoB8D77QMSYjx41sja/qj82DkaEAlY9iMyUlWql3foInCvt/Xfiuc+4vFfSCG7nMxXMvncL/jXSEVpMBFfuWkye6CJ1F3Dl9xdcAkDYQJXEVXH7OXEKVbWt7rWSMRPCM6LrwxXiliDiEkAQn0sDvgEdEKnLiOglZPGEI2oX+1vsbKDL2dCkqNjGG61VB30hw1s7Rvqk3dLwaB6NAiRM1SF88dvPTs3HBoP1DYFtngpt/rT9lkoggWkBt5tpz3rkYBT1tnxMGcUGeOsUT4brAdrGOIWLXxVDRtW6IiFpqSG19BUnGYCk14GKgmhWRrpwgAuD4NCYP1dv7z+0ohnhT5+fLYihnSq/wUxTvwefTByyg33GrwxAT6TQA+AMBOjNKBCUndFA35I9WBnUKo1lWmYodw3a5U9DsqHT/2qv2oUjFNMIxU/wTeLiwLwYRKXI+mqa42BFP5fhT+qPo19YzOPqC5/k9Wx+KA/uxwZYLABXw3oYxqCXW2qax4jjBKyxS1Rxpf/OSChK/WQmiJBqpDeRr65C0bBOLwJTMFhJpNlebDhuFw1sqimk4dZgYITPPPJf30QxKBpqO6794nsT9aHZhEegvfa3naD6/lGXYNNh5NXJmyKDBk4BdNANUOynRECjYDjyxUJ9wPzpwpkc6O+bhuKpAc0Pzs5PMwcJiWQ7MUM+1LJrfKvNWp3l/quedEytM/+jXRrHLex0RQtTP5q9mUaLqdJSAOTZXtRl4KrFdWyv9+0EEV8XYIe8CcAyOLUAIMjuH2uPahyfTPyYk2bYjmihEifDOD5WOYJqNFhTUJC8wLxb3q6bDih4S/KZmW6JhO2HopwqD4uegndMlawVPxZf0BjsTeFz6F4SfhY0WNKxslshAfkJmxA3bJYL5/hBZTeCM7tHxhWiO3XPGt3uGyDkA52b1D/3jajllUh
 VeFueJyG
 zTKxoFd9de31hGu1kZjz9gRz18+AJew53I509meOUrsCihafSxAttwex6z/WSf6uU5Yq3JeyU5QiaqVmX/QNk5RZnul/b5Cp5++j0l6crU0BZ2RStkWuBa+38pdGyDeMyHVSdGMiQs8cWcASbWrOIO+UdpsCAa3SxWhB+q+JiR7rxpdUfho6SU8MPnXney0ijgRRKZlTX5PzpsEzz2pz8z1ZWFp7Ru8qjIeWcHMnVEA5Uu7mo/KDDBT5FJ6c4eBUINNggHReaTKMt8gClho7S+oOzZug6aFPIIRoQ+XxMQa4B3+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 10:11:26AM -0700, Shakeel Butt wrote:
> On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
> [...]
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d1d037f97c5f..30ccff0283fd 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -7480,6 +7480,7 @@ static bool __free_unaccepted(struct page *page)
> >  
> >  /**
> >   * alloc_pages_nolock - opportunistic reentrant allocation from any context
> > + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
> 
> If only __GFP_ACCOUNT is allowed then why not use a 'bool account' in the
> parameter and add __GFP_ACCOUNT if account is true?

It's clearer in the callers to call alloc_pages_nolock(__GFP_ACCOUNT)
than it is to call alloc_pages_nolock(true).

I can immediately tell what the first one does.  I have no idea what
the polarity of 'true' might be (does it mean accounted or unaccounted?)
Is it rlated to accounting, GFP_COMP, highmem, whether it's OK to access
atomic reserves ... or literally anything else that you might want to
select when allocating memory.

This use of unadorned booleans is an antipattern.  Nobody should be
advocating for such things.

