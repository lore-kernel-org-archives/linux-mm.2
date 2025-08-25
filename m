Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4529CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E5B8E004C; Mon, 25 Aug 2025 12:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45CE8E0038; Mon, 25 Aug 2025 12:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82C48E004C; Mon, 25 Aug 2025 12:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 943868E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:16:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31ED11393A8
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:16:14 +0000 (UTC)
X-FDA: 83815781868.21.86D0F51
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB3C11C0011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:16:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m1SkkMPw
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756138572; a=rsa-sha256;
	cv=none;
	b=FxklMJtzUK7PhPhFfupyPukI3C/RcpwvHjBUQtIElWBtR1qyTTeVzltnlhIuNXh7ph7YRb
	1U2P6s6jIsgASHrbde+mA9I3n0N+JntmgYGQbdoNwHsnCVmPgBwN+Kl1tZBlWYo/MQSA+H
	9N6cm6E6XsxH3bPGwU++r9FUOqnhA1s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m1SkkMPw;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756138572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezOPy6YOeaUXwJlIYvyqJG1dN2vstuMGepcFcq7Oj8k=;
	b=7XLQwlHx25lnDVwQiusNxSe7VslaWDRQal4JOmL+hiWx28x/93oY/vXHmGE1UNaFU9bHnr
	nrigwa3EnunSQvYFAm1y9z+1M2CULSAL65pVGv1Dgg0HYqIgsQZeWKxgPRnIIYCfJ0SBEV
	+vh7qwnW15+U9tBAfLcVPOPtdSPLYvA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ezOPy6YOeaUXwJlIYvyqJG1dN2vstuMGepcFcq7Oj8k=; b=m1SkkMPwv6b31zgukz8QqVS0gQ
	RxHlNbfGnwSKppt0B8IK3RTmGhB0S4pIQ4GJMwXLL1vGzgXM3WVyeTYPoBQw6HQ3xbiFDYmfwdc9Y
	sX2fGGKYMO66hPoNeqIUIrm/viU+BhkgynbTXFHw2vk6NZwDXOigyycqbh2xgn4G41PjMZP9/+8u2
	C56t3vBHdnuCQl5cH3RpPiCUs1bByfXnT6qakdDMG20uAKSEwIBu7N8cpjZ91LVNakArsTk043ThA
	gueq2DK+mzBY4w2ZgZvP13akdQn4FDaif59GcF+yjXZ1YMAlwF5j7A6Uun8O5WtEhoSHvCqYU6ufE
	XxCGwdFw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqZrQ-00000000QCV-2wLV;
	Mon, 25 Aug 2025 16:15:56 +0000
Date: Mon, 25 Aug 2025 17:15:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: wangyufei <wangyufei@vivo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
	"open list:PAGE CACHE" <linux-fsdevel@vger.kernel.org>,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, hch@lst.de,
	bernd@bsbernd.com, djwong@kernel.org, jack@suse.cz,
	opensource.kernel@vivo.com
Subject: Re: [RFC 0/1] writeback: add sysfs to config the number of writeback
 contexts
Message-ID: <aKyMPH92SfYZcCM2@casper.infradead.org>
References: <20250825122931.13037-1-wangyufei@vivo.com>
 <9cb4adf8-94c7-4fa0-8bed-2f9274969b48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cb4adf8-94c7-4fa0-8bed-2f9274969b48@redhat.com>
X-Rspamd-Queue-Id: CB3C11C0011
X-Stat-Signature: 1xs8dpdwzrmjcn41tyn5kd6r71ynmebr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756138571-549391
X-HE-Meta: U2FsdGVkX1+EkRbvyR1IU9B7MT83K45dMgvxzzFl6nN0eqMOrjKLI1m0hC35nkZ1oBjv2wvgSQIlZWtvA8/3Ws2kQfuf0mIv6NMLITvqAl9N2U1YODBJm9wiFW2SNxAEPlD65JVQKHU1VrDys6ITDGdBCEucwiEXfaYA2pCVWQBu9zKbFwdkLpmhIlBWQfG7/H5H75uNz7xICniAT7xuyWxilLf4OLa5y7sc0b7xEIE1lJ1zzRZITIxMYJzSwAMVXOGKxxCBbkWDPSnp61FL/rvDFcdoXlhEcESfeVj5h4ySV43XlGiWNGk78sEYj0iLBmtueC3Q+jYCdd51/bcY04JeIX/Dk7zQgl/cMUa1hr2qVgdSxzsmBiOsB7J238UPT1mbAbNISnv3xjaCGaXCNXYksn7r9sKfCmXOZA/AwfpqnV7pK5pAXkoz+FVbD7yGx/5zkvKrZr4wOwU2UyOZKBOvPLYBvTMDB+Aeh1ZbKVdYBNt9/OGraLsXfoL/0JxHtP9EhKu8jUzAr/Genb4V6OSSqZEuiXl6SHnNE30Qk4LXX8jt0TVW+Un4FSUh9R7LzYJi8uUMII7wHvb+3cUpUghfzF8njed/+yW7fjwUuEgeCVBkugjqHW/gPdOABR3v+abXaacbPJsXKi0aqsCL66aPq+/bTiv6xpdi3HQiwf2Vw2WQtx8YZUNHs7NsuGAbaihsdP1I+D5eZ+v+u4SB/LyPlSFV25fdB+LxsAF4YrmQKXNYKxdpFCxUMeHcKNCPCsE+UI3gOjRdj/kjGyx3CsU/XodD+i8nAgWoFho+hyN4BIy1XsKEEfh9pkKC78Do1pZdNuMm80T5gvmmz4/slD4Li1pBIwVw1asO4fFTTQTJv6tsjZmJpDQSRVtl04b5+wPveH2A8kAw1dDTpjXtQTdtzI5v1+mpMhS1QcNJlre0cRoepwwT6ZcexsIGmpLI7mJsqW0tjxvu/zBZizW
 8c5XaWUZ
 7inidz21CJVMfVKgb5/3QkovVC46M+HYEMwRApSHrULzcHzRvn1tf6jFhMHDWitl/37MfK77NeheoG00DPFKkw1li+4gjgvtSOyJX48L3FHBY32Wxun5yorM6/GTbyk5W+IDj/Z/ZzcVUQgWF7r2D+WtMAI0cC7gMSrx3mOMl11UXsUjFRE/4V4UQKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 04:46:46PM +0200, David Hildenbrand wrote:
> On 25.08.25 14:29, wangyufei wrote:
> > Hi everyone,
> > 
> > We've been interested in this patch about parallelizing writeback [1]
> > and have been following its discussion and development. Our testing in
> > several application scenarios on mobile devices has shown significant
> > performance improvements.
> > 
> > Currently, we're focusing on how the number of writeback contexts impacts
> > the performance on different filesystems and storage workloads. We noticed
> > the previous discussion about making the number of writeback contexts an
> > opt-in configuration to adapt to different filesystems [2]. Currently, it
> > can only be set via a sysfs interface at system initialization. We'd like
> > to discuss the possibility of supporting dynamic runtime configuration of
> > the number of writeback contexts.
> > 
> > We have developed a mechanism that allows the number of writeback contexts
> > to be configured at runtime via a sysfs interface. To configure, use:
> > echo <nr_wb_ctx> > /sys/class/bdi/<dev>/nwritebacks.
> 
> What's the target use case for updating it dynamically?
> 
> If it's mostly for debugging/testing (find out what works, what doesn't), it
> might better go into debugfs or just carried out of tree.
> 
> If it's about setting sane default based on specific filesystems, maybe it
> could be optimized from within the kernel, without the need to expose this
> to an admin?

I was assuming that this patch is for people who are experimenting to
gather data more effectively.  I'd NAK it being included, but it's good
to have it out on the list so other people don't have to reinvent it.

