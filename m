Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C9AE9410E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 05:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001BD6B0005; Tue, 30 Dec 2025 00:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF18E6B0089; Tue, 30 Dec 2025 00:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDF56B008A; Tue, 30 Dec 2025 00:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC3556B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:00:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F5241A1284
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:00:44 +0000 (UTC)
X-FDA: 84274937208.08.05CAD38
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5768EC0012
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:00:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R1AL9HVd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767070842; a=rsa-sha256;
	cv=none;
	b=0IeyuybE7NUZcpm0LSBwTMqoChROVRAAF4RBIGrNP5Haiz9UmVI60BVfxXrZ1bU9mxMhbf
	H28YuXPnfFlXperAtly9yOtmyGmqPMBhT/zFFmOxrV1X5dgJxdqHTmF7VsNHlLuv6L9drO
	LCVZbwYEZFvyrVTSzVh/Sq1eBf/xILY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R1AL9HVd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767070842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMr04uON7jEv/LYYTvDAXX0QaeAVqYYlAVhPWGZ9pro=;
	b=5+VcpewewyXWtjP2lbMIV0lLHfmmH/qHrewwGzb/7hhvFo8jpGndUYu3CrNEBdlZqQpx4P
	09cdNnL1rrwMdX7rHkAxWigVJHozKO+YNllqXhYC4Lsg2MCF1HEZmIiap95wP/Oz31n1oo
	3vBi0lscwrNaV3l/d4snhzcfOUWh3Ys=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yMr04uON7jEv/LYYTvDAXX0QaeAVqYYlAVhPWGZ9pro=; b=R1AL9HVdE5SLR+T1brmgkWm3w3
	Gmcvb80r+VbjD+n7jIYnzFhcoXcBb6p3RIiCYfLEHf6238Jz5kEL8wxesHCYVsrHnrmvTAdS4MfWQ
	GDIssg6hocG0KWol++twx7RDenSrh1zGBcrxFXvdbN+8MvUn9EL2CycDSSxywHaT4iaVqIkoD0HlW
	+Mmhq4XXMbbCubPQVFI9CzErCfM3myKdSr/BxunBVEzG97LfOzgwRlaHZ/aMtOsUqPW2GXFr4wfQ7
	acnEHVSUj3sdTP1Gap9pDDvGCNuEOjm7xeKpRnej9AkgUs5llwzj3UPmRh0xUgrCvyYHpw5RHaM9H
	bHvAWnbw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vaRqV-00000002cwR-0szh;
	Tue, 30 Dec 2025 05:00:35 +0000
Date: Tue, 30 Dec 2025 05:00:35 +0000
From: Matthew Wilcox <willy@infradead.org>
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on
 set_pmd_migration_entry.
Message-ID: <aVNccyCxjCPRjJiS@casper.infradead.org>
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5768EC0012
X-Stat-Signature: ci8teufc4whq3cewebxgy8rx4paoqxn8
X-Rspam-User: 
X-HE-Tag: 1767070841-214304
X-HE-Meta: U2FsdGVkX1+lj312XoYxpNtiE0FxFP3vps5X2PiUrxpcMI0aGAvslrffjIlr/2+FwUSigEYjEwG9EHuXK4e+dpf0Fo40WfMvt62oul6vfYhOOSqSDZVSGkse45GezySNsfURH+Qh3kdILJI0aU+x5k2NtFQYyetiPtmTfIkkBrGmwDYoH0byBR0gDef9e3wC0JmDj63UFtkY8bHKHM3To7cC+YJr3lCf1ZXBQvzdnk+h8j8B5eUAA3J19Xo2FWlzOT+kbrTfyJ/ROmEiGt8Mm/Q6Y+kQEkZHxwxjtznPs6oaJuqHBrFBtUmoxkjxnojiKj9+aFFqQdwIghUzQktGtYcFsIMyyKk/g3GCHGyKmZHplYKPfRquGM1nCDmc7EeNiOkuL/cKoKbtD1YcYxqs0+Sip64WaIBGeVfhlqOBSoLoidWTYVHMBWnlz9Ijgi1QYVYIUU6tKZkzZKZUDLVPLVbv0JBE/pljdExjZ0YQJr9sIie2GThbHut8H5bEmM5vebVBx+6QqTh4pmCpQw+D3JOajP1s/HlnRqIdEwLxjWEXHIPM8gXK1yrzxUyRRUK8/osvx9jNSSFhmya9T/J0V9FNgpt2z4rNdkuxUBEMsyllIut2wNLp6rY51pOfw0dR6xMgQ92QDUCLitIoXS/u8rXjqYI9tQmEGnJH4bnFtp2GM9kS/hBDESddQu/GWLsW3iXT4M3N98qWpY/GbBs2T3TpCfV50LhP3dwb3tffDRvYHvmfc/OuHFmKMIQVjuoFQxj+gXomBsQc9b0CvPdXXVe9I7GFj9Y3WKdpFh/eqyGNBopgWaykFfw1emj4vyfQ0mfuueGArP4fsq/rN9s5YC9DVHXRFN2GJVp7c8Wc6Omk5AVi9YJXJKVbCS/ZaR0ipDvkWRiYS1burshefrT7FIRgHbbNJ7qNP+hvYMdgJkfCnHbVGzI310xOkoeAj4ggKRNaWqH21q6OxPty0Vq
 C0wffiif
 PjNa31SMPfMF5kvDkEvov/U1rmQmToaTnNEsePvp+gssKhas5e5cqyx39GRT+X9AeSQ3T9e4xEQb7SnXMWgabPJuQlFosMuXRG0gjkbmFL0hukSM7wdDkMO9WqGrOn1aGz2L7xyQJAYg2MEJyFJ/VR0/QIk1Few8TTBLOT2THSsfLgrl1xUEPy/WV0wygbEctDNodLaaQmpSXbOW9jo0nsBtNUhXQ+DxLvy+nYojtmkLYuySuWn/ELOT7aCRmKZm1qDl2YvvYm1v9C/mS7bUl7c9YZXyxNdh5T4EUiO9nuWuGdrllo2n5xHfPovPUckRC0nhD+d4OJpXZAvczJ6OSWDH9sJ1IbgitsafMQ0jH6wfzg/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 07:45:48PM +0800, wale zhang wrote:
> I compile the 6.19-rc2 for arm64 with -O0, this kind of error log will appear.

I don't think we support compilation with -O0.  Why did you think this
would work, and why did you think this was a good idea?

