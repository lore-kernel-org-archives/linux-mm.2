Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38957C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAA96B00A5; Mon, 21 Sep 2026 17:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2F96B00AB; Mon, 21 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB0B6B00AC; Mon, 21 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D91E66B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DD54A02F1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:32:49 +0000 (UTC)
X-FDA: 85239069258.15.1E8DB0C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3634D100003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:32:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUxn7DaT;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvz5d1nkszGRqC60BnhQHEmnkgXMWAbP6TdaFQ4ccNw=;
	b=SqQkCX9097FyJakmZ0wLvzaWfg99NQXAdt875tl3HeJ5EXacGRY3U/+enYJQwt7NirGBz/
	2aWnVXOWql1JC26XA07fxmyjFSbdYxifJInYjmMe945db17nfXyHgYcMkCoulNJnO6RLHr
	eydWYRdm61qa/VGfpF7OGkcv65/ipo4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUxn7DaT;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026367;
	b=KQtmzbjBf2bxqsM1c7nPs9+0TF103O+R1pEgPeGE7BtkkMYU37JHzvpGZTiZComM5Y+Cg4
	C7Tw7l3JnMy0c2X0oOI69fa3Obmd3OUpU3wcUUcpxc/c1MOAYFvnZBdV+AUae5leokrio2
	0QCD17yXCApoE+tltnrdP5ztJecVGQE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pvz5d1nkszGRqC60BnhQHEmnkgXMWAbP6TdaFQ4ccNw=; b=TUxn7DaTfka06pTTkO0kWqVrYo
	ZqrIHsV8WlJZZaftmU22W2YS6T8/7qWGstaUpya0CjN88jRKFAmS27x7R1q2vomy5MO44Sk111T6Q
	naaeXMmuHb3T9nSP1dSdYqn+8e3BEU3SZRukZlO/l2gQLvtWf0m9BTW1SOudXgJYFf+zwxDQN1SKo
	xE/YgsNg8lFhYDEhc4XRbG72UXEV3j/XH9RZq7m4/2kio2gpRrLUd0F9EDKMlT3TBTDeR9jqWXm4a
	gg8n7l235hGnOxligthF5wOABST1+kk5h/V1UjfM+9bXW1rcjvLGsUvlHMph9QwCAY3rcECeqZ0zY
	AUscQK/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8lcu-00000005bQT-02LM;
	Mon, 21 Sep 2026 21:32:41 +0000
Date: Mon, 21 Sep 2026 22:32:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <arGidwZQrrWVPAoj@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
 <an3uN4TAAZ2miXhe@casper.infradead.org>
 <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
X-Rspam-User: 
X-Stat-Signature: u3ufwa1y6jg9u7n9twgpcdkwqdq1jrkb
X-Rspamd-Queue-Id: 3634D100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1790026367-497749
X-HE-Meta: U2FsdGVkX19fl23onPnlT0Ggoh3sxA24PCTSb2xzoh2g1N3ODPYSPWmONwa3VghwIDXc6LNXbKPIOEaDk4SCLNin1CDjlEomTBIJSTpavJrXAiCdIJ8NpLKBD85zEP78mT3SxXCtq1QIVl7/eBax8kFT7dQ1yqc54lxaPBiYaWo0gTHCVQHBIGc68f4WaF6kWs9wicta6NTF8eyDpZl0MB9aaLGebnYxiGgv+4urT8/oa74H65PwSX1zapZcnLNXuD6AdwQZXf0vOAUnZx28QTzYXsC1DXqZgJhhpMJvEJiTIo+6ZjrCaJ2397N2/UJo3YZu7BF7jIL4bcNX3WjCUda6izevxsRbqE3QBy8PGy39Xk+wKe+mjhdxgj20IAF9DQA8aYdHJPCO4JLsehPO8qMkJ42NBaxcqmOI8Afyp0MZFG6+vx196akQpEjsRkQegISi4AL1+W0Th/zVUwoJXL5VXsSKe0neAzuspqRKAPAZJMyRt63/0+do9+kw6XaTexHyHXUL/OTvV9h4VpPGvzt+oZj52J21/hdlytvcLihpI9jgJs9g8qreVkavAh8ve5yncPgaL8sRLkwnvqpwvnpk7n2MgwreMUzZQjLRd54tFtIiwXZCZy08ACqU50L+G8XZxmfWbc9PnDOwGiMGMCjT+q5xNeEIYyIhl3YYNDK06TQJ0W5XAKI5cYRzcVJ3NKV14H4nW/77Y42sDshRTQFYeXaO/as7iL8qWAcq0ZK+CPtxrAWPFdfHHNrWVO3SX4sAJ8QZ1duEJD8aWNqoHai5fuIiln66/bWMUzmX04CtcPbRuLjlqqcLwLOCCD7TgQKSqEI+LYz5mt5kSxfAAB53MzLnXFMFx2Fe6Xt0nPoE3OIs7Z5oXK5+TO2xSJdQ211K9wbysAqTQF5pByOWNuRNP8tEnvIHSx/hrrmPgjU878sg0/xMei3NWEL738iUhnTq9U5iitNLYfFsuBd
 uFP/qh/e
 6vYLAYPoux6GlgBuEwP90Tl6zqVTLClLIVyM7p1Nw39l32ck5b97BgTHpJ9UeKeDJrf/oNtdAQIqFqYBaDSbLuhZLIoDPggR/mb6ldCk3A2zYhk3ztOeO3X18dgjDy5V0xLoRXraa11dzvLG1E+ZgCPCbJJZ/dQWvBBNKMq2yFKGmrf1MX5FVIWpyemDo3XNXdQcKg8t0zgNDemWz4fWC7zJgz6WcbAVm7w7yr0tQZKAoUxKdyvOptuBxb8uexiMqpH3B1wyRQ8pA90c/s1yqhWAf5JyXqTwskXODRSVHScyG7Bkl0QjIwVI0408Abkp9pc6lBYDyHoq4HjJcH2SfisdhFh6cl8uge190cQAsim6vtk91wlDJSdUtRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:44:12PM +0200, David Hildenbrand (Arm) wrote:
> I'm a terrible person and it took me way too long to get back to this :(
> 
> > 
> > You make it sound so easy ;-)
> 
> Heh, as long as you hold a folio reference it really is :)
> 
> > 
> > If we don't hold a reference on the folio, then the folio (whether it's
> > hugetlb or not) can be split.  And then folio_test_hwpoison() can hit
> > the assertion that it's now a tail page.
> 
> Right. I am/was missing the connection to "generic_file_read_iter() in hugetlbfs".

We might be able to split this into two series at this point.  Is that
worth me spending time on doing?  Originally I was going to use
is_page_hwpoison() in filemap, then it became obvious that this was
inefficient when we had a reference to the folio, and so we ended up with
is_ref_page_hwpoison().

> > Before this patch series, we don't always hold the hugetlb lock when
> > splitting a hugetlb folio that contains hwpoison.  And we don't want
> > to have to grab the hugetlb lock if we can avoid it -- unprivileged
> > userspace can hammer these paths hard, and I don't want to see this
> > lock be contended.
> 
> Right. But doesn't at least the pagecache always hold a folio reference when
> testing for hwpoison?
> 
> I mean, there is other code that might need care (PFN walkers like memory
> offlining), but I was surprised to see pagecache code require a rework of
> lockless hwpoison checking.
> 
> I'm sure I am missing something.

It's just how everything evolved.

> > Oh, I'm not happy about it.  But we need an atomic way to determine if
> > a page belongs to a hugetlb folio with hwpoison detected.  Short of a
> > complete rearchitecture of how we handle hwpoison, this is the best I've
> > come up with.
> 
> (did I express how much I hate the hwpoison infrastructure and how it's racy
> left and right? :) )

Yes, and you'll have the chance to do it again on Wednesday ;-)

> >> (what on earth is "huge_poison" is this supposed to be "hugetlb_poison" ? Why
> >> "poison" and not "hwpoison"? Really odd)
> > 
> > We're inconsistent in our naming on both of these things.  It doesn't
> > help that somebody decided to reuse the term "poison" to mean
> > "uninitialised struct page".
> 
> Right, but let's be consistent with hugetlb and with hwpoison. ;)

I'll take another look ...

> >> I'd expect that we actually get rid of folio_test_hwpoison entirely and
> >> exclusively work on per-page state and has_hwpoison. But IIUC, now it's some
> >> mixture of folio checks, page checks, folio_has, mixed with some hugetlb oddity.
> > 
> > If we could get rid of HVO, we could do it entirely on struct page.
> 
> That's what I hope we will achieve at some point.

I'm not sure that's a realistic hope in the next few years.  Even if
we get struct page down to 8 bytes, that's 2MB of memory per 1GiB allocation
(assuming 4KiB pages).  Always a tempting target for someone looking for
memory savings.

I would prefer an out-of-line tree that doesn't rely on a bit in struct
page.  Maybe a bit in struct folio wuld be fine (which tells you whether
it's OK to skip the tree search).

> > Or, as above, entirely rearchitecture hwpoison handling to not be based
> > around pages or folios any more.
> > 
> >> I am not quite clear whether the change you propose here is actually required
> >> for the remainder of this series?
> >>
> >> 	[PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
> >>
> >> IOW, do we really need all this hugetlb hwpoison handling just to accomplish
> >> that, or could some of that (bigger hwpoison rework) be done separately?
> > 
> > Blame Sashiko!  I'm going to ignore it in future, but it's really good
> > at nerd-sniping "hey all of this is already broken and you could fix it
> > as part of this series".
> 
> Right, and this is only the tip of the iceberg, because the entire hwpoison
> infrastructure is a complete hacked-on racy piece of ... engineering excellence.
> 
> To summarize my question: is it possible to separate for this series the
> pagecache part (Use generic_file_read_iter() in hugetlbfs) from all the hugetlb
> hwpoison rework?
> 
> OTOH, if it's really not avoidable, please let me know.

I think Sashiko will whine and complain incessantly if we drop the
race elimination patches off the front.  I can try it, but is it worth
doing?  Eliminating the races seems like good engineering anyway.

> > try_to_unmap_one() is already 200 lines and contains some tricky code flow.
> > I'm trying to at least make the problem not-worse.  I think we should
> > pull out even more code into helpers, but not in this patch series.
> 
> Note that this code now was partly reworked such that this helper will soon no
> longer be required.

Rebasing it on current Linus simplified this a lot.


