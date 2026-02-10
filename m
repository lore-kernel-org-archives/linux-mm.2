Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03607EB26E1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8606B0005; Tue, 10 Feb 2026 11:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEF16B0089; Tue, 10 Feb 2026 11:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206656B008A; Tue, 10 Feb 2026 11:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13E896B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:27:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A12761C623
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:27:33 +0000 (UTC)
X-FDA: 84429077586.20.4AEB6BB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0AA6C140002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:27:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vvcKPWrp;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770740852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QfAoeexURF3xNLX3k+kUOdLmxKsQpukJ46ztP6jhSE=;
	b=tdsl+VrXBBX3BB7wfM+UlSFHXqB1+422ZcqyG/duf6+Pnon0ArDPTwyFhRpf5K2UV16P19
	8n23tYngrV4VrgvfSnniWAbvqYQHo6Ae4ioTy3fYREpbW/dDHX4MEKTnJ8HNZwJMMRaiu2
	pIZtdb+T40e+7sv3Oi1Od1SEgGH2Bwc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vvcKPWrp;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770740852; a=rsa-sha256;
	cv=none;
	b=KL2mhnIEmAbaIVkdm28mD6YzM5PSm5voAYuAPGKn5t2GN42bhegP30egIx0DBx8RTgxF4K
	ND9jr/cN9MOQH1a41gD7mU1bJ4lYo5bRilXb0UrSmwc4Wdi3ewlGhnZfYRhzRd3Tu4KWlG
	1ya4H3YDCc2FmXJTX0sfhheGDrH1qw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8QfAoeexURF3xNLX3k+kUOdLmxKsQpukJ46ztP6jhSE=; b=vvcKPWrpnF0WIX6d6ydro8WGu0
	JCIbSgFDOYi5HlN9JCoR9L9ULRPHHccl54Hqmr9aO4zaZONyvUamD5Er53kYH7qCUD5xy8+1ECwSO
	at0T5nOsyHRdkhzSS2Bop4gfvKrRv6XmHq1PcRHKYiIYJth7zMCa6IOHbGr+i5nRKven3rItjgyh4
	rJ5FL78y5C6rWhQdfFVZ3HNE6wOMIkU2FTE0D+gIpyffbelx5vJxEExQRdjw0kQvOfh8VO05OtbfZ
	tnejMyU3yzXCFRr918Bn2lfZApCUPcbNEuzT8iAzkRsCy+iUEWWNWyTttZvSbsmcCtKaZ8J0112iM
	mGIO+qTw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpqa9-0000000BKsu-2Izr;
	Tue, 10 Feb 2026 16:27:21 +0000
Date: Tue, 10 Feb 2026 16:27:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kirill@shutemov.name
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
Message-ID: <aYtcadXtbV1Ng-Oc@casper.infradead.org>
References: <20260206135648.38164-1-dev.jain@arm.com>
 <aYYHGisOQFQINXwR@casper.infradead.org>
 <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0AA6C140002
X-Stat-Signature: cay9xu1obzrjhjfxi81qqrzdhnhs3h8f
X-Rspam-User: 
X-HE-Tag: 1770740850-512747
X-HE-Meta: U2FsdGVkX18kku0Pz5fKZHOC3kbtYYuXmuibfzFl6DhmYBJ9pNrjvBT3iFDxBT9rJZaZ5zuP0+/J0INh8wHbxjEmy6vTKnGwWuq0+jQyMk07udAPZNHBhfaPa9NyrrHupr5nzCjHZVe0PYCtxR6dnnRXKwNFqWkH27RiJ9l6/6+CJDijUjrpCcNcAFFcd/yV22CSy8bzDQEyaOsYeUm8Pfhw4gjkdXWDoEFHv9Fok/QIulczASjWjpGr9bztSa0WxKy4Fl1b3t71a7t3DbfXQGWv/vPvfhS7f9kjL6qwlt5bxPm0oOkofPJFiQKr+P7qu/t6mcmv/2lEUSNbLT+szFbjTU0hre7U8Qd7Uy1c6Gh6O6eKlBXyagac5qulUldstE9P5IJsCn9IqnZZWZMGZkdJSVPGBVFIHb6bJsftVk503TBo3ormW+i9Xk7lUySapxWrKIg5VFZhIOHcxrH06n1gvrL2SG0q0qM/+xoNjo2ZbwvTh2xNjNuHRAAdCSsLRXg1RZK+2yk41So13VbMkzVrHXERclDaktmsLmLguIhOjbmZrJMp95aYswIHq+lY39bGwPARyVjT131c0wOTLSnxB64B7Y581vP1RZUQ8tol6Oxge5z7THT2p/xYG4Tup4vhjlnoYJOOQo6WWwgQFYbk2ZIO0a1RinKJcALCHPxiaM7lxY0qLm6WXO+BRdNSiRad1gWDeikKxs9WtOmxP4WQeUIVIhf3RPBKtp36uYUJiWbGr8C9lN6jGUngV4THXAxEJaFFHncbtcZDmxLHmhIAjhhdAAfSVQj0soLZ6Ar6rLFKVQAz68KEh1K0jj8ox3kr5uE8AZOajQOMFoYScj13QW3fRzRQKGmqAXYUcUtIfBllYT54Xr12KgBr+97/jTUOzqg+AHQSx83ftH5kSAvtF5zLlsVWpoIe0u+6eESaZRhsGrD30qsttvS7WuU2t2t4+SL1I1xRe6QVNh8
 i6oFdFN+
 FJWOIZBCzTOBf3UmS3rOJT5RoxJJofhzxBtVrbRCwaDnPaeiOOWwysF3O6qVTEulnw1DgHLpo4M+i7EUOdHszb8cGbiC/g+W4mmxQ5J0ME4YO0UPYB3uzG+nSm1mXHQ+WmsWH1h2vQOOP1R16Zr6bziqj03DMCDi/eFOQsl77H820MhMzoEM2DL1OWazdeXaSfdfrN089qsZf5xtRY92wgSwrLmr4sA3iFi90fXG2xRoVwdMYrTnmvtF0WJk5Z/kBhs2TpwhC3S/UGHkofco8E8rJk8XEHNKMUDrtH+6CYpSblmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 06:58:37PM +0530, Dev Jain wrote:
> On 06/02/26 8:52 pm, Matthew Wilcox wrote:
> > It's nice that you can construct a test-case that shows improvement, but
> > is there any real workload that benefits from this?
> 
> I can try to measure this. But, I constructed that testcase to test the
> code path, not to show a perf boost (although the boost is obvious enough
> so why not show it). As I say in the description:
> 
> "Align finish_fault with filemap_map_pages, and map as many pages as
> possible, without crossing VMA/PMD/file boundaries."
> 
> The patch should rather be seen as an extension to 19773df031bc
> ("mm/fault: try to map the entire file folio in finish_fault()").
> The code which my patch removes, was added when the norm was to still
> perform per-page fault, the argument being, RSS inflation.
> 
> Perhaps I can polish the patch description so that it clearly mentions
> what the objective is.

You say "removing code".  Diffstat says "no real difference in amount of
code".

 1 file changed, 38 insertions(+), 34 deletions(-)

You're messing with some complex code and you haven't said why it's
important for us to spend effort making sure you haven't made a mistake.
Please persuade us that this is worth doing.

