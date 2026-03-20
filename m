Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1501098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28EF96B0088; Fri, 20 Mar 2026 09:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FEC6B0089; Fri, 20 Mar 2026 09:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156626B008A; Fri, 20 Mar 2026 09:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04BDD6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:28:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3AC4C09FD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:28:05 +0000 (UTC)
X-FDA: 84566519730.21.F9583D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1DA2080009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:28:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUepx+r+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774013284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O4h0+opLFRUmpIf4LRqAamoPjFzwH0T4T5yg2VavMY=;
	b=YkDR8XtWqOVrLC0zsnBoNeOtLftcnIcbP9kQJwUai1rP5aUcopDj+sBAQdYbjN851uHhCl
	qHzeZV/QvXHhkgdJhgqruun9XuAGHFJ/iC6yHqNv4tcAoOD1TkoVbu/HiEXW/Nd4wEjGc3
	C3a6WQMssv2GNVZtn1A/d2rIVO/y664=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pUepx+r+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774013284; a=rsa-sha256;
	cv=none;
	b=AslsSI1fvrQwlCtRCzaJt0GEYFOIpN6a9uhe69DQTLoK9B2jkEKa1D2TwaenbhJYnIQyda
	/HWlYAes5J0q7kPJr19qjmYuCfsZ6Byw7WEV5wC3HTkTb34t6sf21pR+JU4ocXrNp/hnOs
	SeJbPHBzkBg0w8S4H1M4AeO3P2vB6Mg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 820BE61850;
	Fri, 20 Mar 2026 13:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FCC4CEF7;
	Fri, 20 Mar 2026 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774013283;
	bh=u5l4x5uZN5shVbY3PU85+mwh0difgnGZQOyXwfxun/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pUepx+r+sgYzj79NAcYPBsSpbBmA4dWap2FkzCydY1qsT3ymg7SRHk3c0rTqiRZS9
	 ozkynsYcBsUDjEGKtyLK3q7F1k0XXT0tdxq1oiy9olLpv6O+Tpz/y4mZiPByP3+3ti
	 MLF1oNDnMWYbQcrBlBuPvgj9k2e7uhXmxEb/52dGPXMXjODiWEKxkIKsXhCHnMAgAP
	 2O3pXUCVF6FUPAZ+2umbUO1b05UgvtI1F0ATK6y++Znz65jJPdPRnhslvynY4GZae6
	 8gtScmN+PLT19RMIfcL+674X0dJ0MB+p9K1TgMTyaWFnYfDUrm/R0Pc0TrPIoEaSFO
	 bkXz7sKw6Gxsg==
Date: Fri, 20 Mar 2026 13:27:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <8ae5a5a3-f2ad-4be0-89b4-b8beadd957e9@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DA2080009
X-Rspamd-Server: rspam08
X-Stat-Signature: 7b7e9w3jyr8cnhj8mx8e8imi1b43fnrg
X-HE-Tag: 1774013283-632014
X-HE-Meta: U2FsdGVkX194CYrCWpj82/RF3lsb5qvQCtPaaPKU0ezISXxmS7tGHbmLGkT67/MrfNNR+/BXLveSRzW6nILMo8YIaMmT9parPgUwiNLxggQXDpi+yFA1mmP2RufsNZGgBVdEnwVc9yeGfhWjrx5WvOdM9otn+C/Rq6IgbLsaKSakzlZmEkmY0VpJqU/lNScK3AtcO/I5UCXalcjVex1dUcEL+aXikaylrQWhdQZa80QS99+BudDA+MTpKjwNuUlTr1dn8DtkIUV5jx/VtrmRaaSM7osZKl+dwyeEVa1dOGx1rbU0nL3PbsKaI2mwy8j0HpyxjUG6pNvD/uqLWK+6IrPTWFzzywijmtRZ/Bcda+Ml/X+fuDUCt8vW5l/3Dpe276BXpK3jZdvxOsCXNN3ypuaZewpbpgQREcc1jUapkunPLQf0pZxSya16SgaKXsx9mwVYqszBgwDeSGC4UbickK0f1emyEJBf+gxU350Jn3og/3/Aw362AEQslash+H95YoTcNO1v03RESwKNokrbi15rCh/kvbNLEN7zg/+DTEDelUSRDFEZiHTy2w26lykwbJuoPgU+1+6bIWs/SMJ5vHvwtln+QbS3Htyz2wPssZg13cr/kuj+vj2unhTExcYxxh69AT55w9pxafufjnEqJ0Xc4D9CzHjPuc7vz1d8Sj1w7u9Tw5B9vrsbHS+s0iybC3RB4pcXR5/SmjoBlj5V54/3jS2/FII/vUlbYEPLu0Uksm6TrvSXIYLbVXWW6ZfLNnjDKAjiNpYN7U9ZW0Dh2eCT2ijblJTkPgSiHjZP/jnPuDN6QXVlCqp/o4HRUjV5AUyCfn51jSbasG0ch8GKeOw/jO+6z7Yl2DOnnnZ2EU3BbkoetRH7cV4KqSkO6LvcTOGnHDmtTBL8k9YchWrFmWl6/uyuY0w9iSxURbFY8a1YrqTGgT9RRgtc1LqlchXE8CVevhzqB9WE4tcAynq
 yuOrquGB
 zqSYho19Azx3s+ehYAOVaDrhe+ALTDK4/Nyal58NlVvVQkM/QZGyqROWFoPIDEJcLKBOZ0Y3lkF8cSgXuAKCUuoCvgaJplxsrNnQJyxvj7VytOoMTq+SA1wWSeosEvdk+/XCZk/mIBta3ibbZu7J2XNx/TCqo6NJFtmuXXKfK4k8gm6XU3/MeOhFoqK8YTCOTPRvZCS0DcWSRH4GCqkucTdExSqNVJIIh/JBspzqKNrolVNDtpt5U6ecOu6y26ZadFMZB+eZRT/e7NHOU/FpiZ07/CAZRWeBL8D+QU/TOxw/GjMYPXiInznad6+X42cAhUPADRI+ExN+JhC5ayMHKzjjqoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 08:09:17PM -0700, Andrew Morton wrote:
> On Thu, 19 Mar 2026 13:00:06 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > The zap_huge_pmd() function is overly complicated, clean it up and also add
> > an assert in the case that we encounter a buggy PMD entry that doesn't
> > match expectations.
> >
> > This is motivated by a bug discovered [0] where the PMD entry was none of:
> >
> > * A non-DAX, PFN or mixed map.
> > * The huge zero folio
> > * A present PMD entry
> > * A softleaf entry
> >
> > In zap_huge_pmd(), but due to the bug we manged to reach this code.
> >
> > It is useful to explicitly call this out rather than have an arbitrary NULL
> > pointer dereference happen, which also improves understanding of what's
> > going on.
> >
> > [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
>
> AI review has questions, which I assume you've seen
> 	https://sashiko.dev/#/patchset/cover.1773924928.git.ljs%40kernel.org

Nope but I'll have a look through and see what's valid.

>
>
>
> This isn't going well from a workflow POV.  I merge stuff (this was v2)
> then half a day later a bunch of potential issues are identified.
>
> If these reviews are useful (they seem to be, enough) then I guess I'll
> need to further increase the lag between seeing-it and merging-it.  But
> if there's a 2-day lag before I get onto a series and I'm the first to
> look at Sashiko then that won't help.
>
> So it needs to be something like
>
> 	- series is posted
> 	- 24 hours pass
> 	- submitter takes a look at the AI review, maybe prepares a new
> 	  series.
> 	- 24 hours pass
> 	- rinse, repeat
> 	- it gets merged, hopefully with some Reviewed-by"s.
>
> Not unreasonable, but it requires that submitter be made aware of
> Sashiko's comments.  At present that's via me being tiresome.
>
>
> Anyway, early days.  I'm thinking that an emailed reply-to-all from
> Sashiko will help.  Much hinges on how useful submitters find these
> questions to be - something which I'm paying close attention to...
>

Please not yet, it produces a lot of noise. I've responded at length on the
thread on this [0], and while I appreciate the tooling, it's not ready to
be treated as giving entirely valid feedback yet :)

I think David's on the same page as me on this.

Cheers, Lorenzo

https://lore.kernel.org/all/39e6b4d2-8a30-4eaa-908d-5d11b746f8d5@lucifer.local/

