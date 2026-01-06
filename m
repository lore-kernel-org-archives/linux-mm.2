Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F789CD0430
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 02:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9066B0005; Mon,  5 Jan 2026 21:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6EA6B008A; Mon,  5 Jan 2026 21:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06FB6B0093; Mon,  5 Jan 2026 21:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0E856B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:49:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B614140348
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:49:42 +0000 (UTC)
X-FDA: 84300008604.24.49B3519
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8BAA100002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:49:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DrtzPLOi;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767667780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7S7R4M4sfj4F+O8uKJV1jH+M2uc19cr+SROpwV2PzI=;
	b=SA3n45Og7r8l5U2d4giXiWRsYrHgHU8J4TV0/SgmzFjt/det2SEFcgMNzn9P0R6hjrWwlK
	KEnHZLitwVuX8nIQMGo5pW7ICRZgXYTFVfPhjXgwNUrQwSPFQbZvcKmfeZfooX+RwqjAKU
	HOrEtRIk3FeuhredJBH1f1O/yBNnQjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DrtzPLOi;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767667780; a=rsa-sha256;
	cv=none;
	b=ZHJ9vV1PGfIpmCZQMqoIUIG7iQju/acepozpupWfLWld+uewIx2pl5oHzHRu+GjDKRl0vc
	XmHs0BrMRIHyJA7HBJIXWj682uxkXNJaTY1sFEFub3ysV2DPSpwLf9cxsjJQVqdRUYgOih
	NhjL5X54XvKku9hXeKv9KnIgey7CkMo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K7S7R4M4sfj4F+O8uKJV1jH+M2uc19cr+SROpwV2PzI=; b=DrtzPLOi5MYOk5yqk+Xemsrv2A
	YmbS9EY894YFnGOdfW23ephl8stj8SkltMC6jSTKPfxJct+On+e94n+dgZmkqHTEOPWm11XEbyQu2
	gBJ8ZJmmjWQBtdJsKys0lCttjyq1bEWokfHo5jBcyS9V831RunadteBnjI7+cKFPdad8+6e7Ah9GJ
	9Ch9/n7tFKPJvoH4DpZ/s6t88f5bFf3RGqX+6uQ89jIqOCc5ONEWE7CIB0c02ZU7mH0SATgIRcndJ
	Tb/aSNCHecSSgo9MP+OzVhKNA9yqq2isAOf9891HaGyWncQFonV+yiiuqpMNWOb3JWl8SkEk97HPj
	GjPH7hJg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcx8Y-0000000BDNG-1Tsg;
	Tue, 06 Jan 2026 02:49:34 +0000
Date: Tue, 6 Jan 2026 02:49:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boudewijn van der Heide <boudewijn@delta-utec.com>,
	Liam.Howlett@oracle.com, aliceryhl@google.com,
	andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-ID: <aVx4PjdhG31LfjuA@casper.infradead.org>
References: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
 <20260103200633.246006-1-boudewijn@delta-utec.com>
 <20260105173350.d8ad7d630be1f0a581dfd565@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105173350.d8ad7d630be1f0a581dfd565@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Stat-Signature: z4iqp48w89teknyhp1afzgz49nfhaaxx
X-Rspam-User: 
X-Rspamd-Queue-Id: D8BAA100002
X-HE-Tag: 1767667779-151571
X-HE-Meta: U2FsdGVkX193sBIVtUPgFqE+nj3aLbQyByCQsCcUl0jnuvl2qG5iBg30aZA/RQCvzu09+GCX7BHVvgjiRIFOsHXpF6jYxBRAHvKY/uApNjG1v0Kn+fDTPABAvyzYS47Fw7iPCHS3Ja+AYEdlA/NTPNMirjGUrjiU+QrNli5KHnU/cu0OUrSnI487olSSx6L7+LYhjxom2+Bag3y0ttMoJcA6eSzAw53DnYnxLHVBCxb31Nww58nvIxmXSHyzYuaqrv6sPRidLIZTy4gSQI2ltqfQI0/WrDmD6nHfOJUi3ugBM+AJxCevXFOU3RUOqJKWfxAm4ujv1jO4lSrbu2LyS8k1fOHVjmOKg6bHEuUt3qVtApCvF3jl0aOGeIuJ6oMi+N0hgff0pOUTQuL66NsHYXOeyoNPehnaEgxHkbJwyFKevyCT9XEl+dEgnIb9faELja9Z8kzUoRFe7NQLO2UXBC9j22sTpOORRwXPUlScJwKVFNZHyVAJERx8G3RL2PfKJdRealbDqVEiuVy20KxknxsKJimRBoYcDTkfzjPEjPUk7h3I/68macedRAjC2C/A527l4FHA2+8ChU6czI16RMYAdAvPrZ/0Xtqg5c0NmumgqGBP0quwuKMBd7flZXZUYv/6RWnLauPPHQokQX5sg4/ESakVJQGG4TnI69wYygq7T8ArjiKrZf0NhGWAE9HdwrAU7s2D1ieao1AFczwXf52FbPpO4nB9Po+IUtU7puy2HlMC5138lyjXEzspQbA/BMd8zrFBjejRPqSxvP7Addfx9yMRtw2TOtA3A4XX8PRe3M1Bhc/D1AlaCfARlBfmZJbXZTduEQMQv731sFEmGcHQi8Pw0jLFG4zBFvNUyTog1fYpPo9BhtSVwY2Mrc6vPITH56Aog/aPtem0npqcenQccaKKVrT20CJajRp0S95ma4cNMPLwmiyrr5fiqkledd/ndRcSxO5YfEAmnVC
 snEjc6Eq
 Ry2RNezilfFhN05HLvo6cIihjcemAAWEUeIUa9imCr0sMridK6UeUY2DD7vfCSeIzLO4RYYw1B8A86JEGRK/hNCfMKfbwKaDljjkUvw/WyJaD40LhISMqyNyapyl248xtQkfwBP6qyj8QOXRVqVCEoHgNjjH/zxne59P98fnf/4bGSAfKWEcARmcGAQKHd0aDVjZ7PZ0w48UhVtj+IpoYJSuSgjVfndkw1RhUGBXSP9Sl8jDtTCS1s5DYMbmKfrhMgXFro//KzZbbmFhk4Sa4JDnT58jIH11lUiiQHGjskelvCHs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:33:50PM -0800, Andrew Morton wrote:
> Great, thanks, I added all that to the changelog and queued this in
> mm.git as a hotfix, for runtime testing and pending reviewer input.

Surely this should just be a lockdep assertion that the appropriate
locks are held?

