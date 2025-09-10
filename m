Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37C7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1697C8E0006; Wed, 10 Sep 2025 19:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11AF38E0001; Wed, 10 Sep 2025 19:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FEB8E0006; Wed, 10 Sep 2025 19:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E870C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:01:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94F90C033A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:01:38 +0000 (UTC)
X-FDA: 83874864276.11.6CD0859
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 390A0A000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:01:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="fTZEC7k/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757545296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Us/N8j9SQOgdu66H0Yzp27YBDXndkSUWY8EcpCAMl/o=;
	b=8j1i6gnuFHepLIP8TW+683vSk+pbHlz0YPPODRjaYFGmxc9qt8D0rfwdys+T28z9aVd4Vb
	UER1+/+ibDAaSZsVfW5/+cl7d3Kh+pqX6oThVQUqT40SZiiEsoj+S3KF+7jMRTAcxuwgiz
	bJ1LcZrEwAVcbQvW5O8/9r6PsJ5r/D0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757545296; a=rsa-sha256;
	cv=none;
	b=77jxP5b6b2R/76tHGUs1ad2eRip+WVturdKfrRL6g7YdXb09t1X8XPgyFJQUjpCTWnDTFF
	H7ACA3Tn0jhN5AEwAffrOFO4I37uRoU8dzIda1us1yHvpKeuBLuuvHmiQdapXhw96kqj8L
	P7t0mAZc5OKBZnntYLQjsLlgRJrVLLE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="fTZEC7k/";
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Us/N8j9SQOgdu66H0Yzp27YBDXndkSUWY8EcpCAMl/o=; b=fTZEC7k/Yx0WVVXjxLwL+JGfdp
	VddH7CgCSp1cBCrmp25M/+nfSB0ugEtYcAynOozwGhWRtbGOagqYvjiq+9nbQ0ikiMhksED3G+crv
	6v6d+FNLG3N+HD/XQ6+653XokL5pk8U3AtruZe/8+tfuN03FPepk1fK2fA8nvVui5u99DcSzZFTkx
	3bSN+M7aBPpLGukuwhsy0a3Y87/itJ+/k+dNgtxhXCa+asfVput8wQexxch3KQw3VSz6SH/OPKfdk
	FYPqf1XHFijtkyvm/hObECAFiI/MJOEOtFM0B5gvUkaHBshOH75ByRoKVZ1weILIP/rzMhfc3l0ur
	PSg98s9g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwToh-0000000H82N-3e7V;
	Wed, 10 Sep 2025 23:01:31 +0000
Date: Thu, 11 Sep 2025 00:01:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/22] slab: Reimplement page_slab()
Message-ID: <aMIDS820ovAjZbaA@casper.infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-7-willy@infradead.org>
 <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
X-Stat-Signature: h4ztcqaidk4d4usu8inz648gtwkyeiux
X-Rspam-User: 
X-Rspamd-Queue-Id: 390A0A000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757545296-672781
X-HE-Meta: U2FsdGVkX18tME1j2BCRjf+9rv7Z/49qMTs8BZZDHgEfnufwuSs22r5vtpHIkz73fTfUO1spCxq5295IZRRY2ElQOjm7M3c6oZVPJZ9fxM7TxFXbvxuKBX+egGtAN/8L9yc08QW0LqdSv71o4BNcKKXwJJ7uijCJ49aWO9uygqHkCwtpdEgFiQiMkjRbjftRw/z2o3jlERbxjCb32IVDZPA0HTixExNn3ivoJSHVejEDEPNqWGJWvBp9x8HP7Q17B1lUTht5S9WCd9VGBA560j/I1zuDpng37FGJdQElw92IIPVPl3k3fygCs1MGUS60fE1aMZSO+XDMmuawWbS+TCSCeyqqYv2eo2xivXEzOu1wizVC+YRrCvnQH85lBcRDz1axVEx6a2e608SDSNfWjhhyMcSvZ2a/NXnIg497YfuIWcKwMENvviNuNAuvBzj65cEgWyOnhHe3iP6fOEF4brUn4lhx0ANliK82ivWJfp8bfpkG67OnYTNd6j26NVbm0rJDmdzltAjY2IknBPC/65v7LyKlV0zt307XzAfgIYkQo+FzB5ZSHhD/YMoU+xtLCn2KMz4iXsElZHuZ0WevEp11lpQ3beWmsJkL33TzQCeA+lj8UMkV3SW+DKhRK//ht9cupCm63RHgZiFDIMDXCvvttfx2A3QAtV4BZQDQH8w7S26BcEQvIL9sB9DwmheSjSMGUBwTs7To0XoMv07OfBkTmk3kJKJ+6uHXBa/3BdTFOrsLsABKCYY+GFDlF7IwjZlCtRZHyIBP85m5dFVZhlEZEjJzPYwUUS+o9SZd4v1LP6uGOErIjtjqV47a7uK31EKX03SMckkgNKgC49v3SWWSRTRgwP97fwA3gbw1D1BeME+/YJz6uNomvUVmSxcZtztPxP2rplW0wQkSaPgHbw3GPaCPfWbULaRGRuNHGMrnqZHFMuQtHo66FBq0cMt2nwwhh5xKZj8DzsDeCfj
 ZzsCnA7E
 P23L3QyBaN7AnYsKWrJTl2Ja7UtvetmXcWkntxfq/94Nmj1IxAu0FKTfGzsnQtrI+EckscBJFNkx0ISLKjRXusrneX9GUeMX7dYJ0s5vSj3RA1o6bmiehz+hbeCI8PWXreBRHnymAi29jFCpg6GWdOsZAvK4DZ7AIWFC3d9t5XaUzPBGIWFv3WYPlTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 03:46:29PM -0700, Christoph Lameter (Ampere) wrote:
> On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:
> 
> > In order to separate slabs from folios, we need to convert from any page
> > in a slab to the slab directly without going through a page to folio
> > conversion first.  page_slab() is a little different from other memdesc
> > converters we have in that it will return NULL if the page is not part
> > of a slab.  This will be the normal style for memdesc converters in
> > the future.
> 
> We are looking forward to another level of indirection in order
> to get to struct slab?

... so that we can shrink struct page.  We've only been talking about
this for the last five years.

