Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F6AFCC074
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDC66B0005; Fri,  6 Mar 2026 15:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BFD6B0089; Fri,  6 Mar 2026 15:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4984C6B008A; Fri,  6 Mar 2026 15:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39A0D6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE7F38C16B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:29:29 +0000 (UTC)
X-FDA: 84516778458.26.9A5EF79
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4646540003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:29:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uIICaxX6;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIn7ORTa5pQRsuZzbhbRJ8LKH8K+iKJyVv3+eYGhv2s=;
	b=JVpNLB+HffJt5V9Dvpit2eer/TuU1NUDh5h3Dhrzj3rqs2aJcOFx2WWjuCztPJhcw7y3W9
	nfqhLufRlqFLXmsr678Fm1wcYxVL0daAZ8vXqryMNpic7lc30rjptMICPJhizR+V+RO+a7
	g3p2+68HqVQ3Ut8txlC5IWIgAlpv33E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uIICaxX6;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828968; a=rsa-sha256;
	cv=none;
	b=cM5xGBQuBwvDS9286UvqKxc2ZMc6yLb9iMkX3njpjGPPBwVbczM7JLOWphpsVS6i9cTQzt
	Hv80e785wYdZFfhxntjlUNXyJgb3TYa6K5MC4b9Co33+Lu+20ZA/86maz0zJxrmUHu1aYo
	OYuqs6UdXoxJomxacdru+c1R2NC/WNA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uIn7ORTa5pQRsuZzbhbRJ8LKH8K+iKJyVv3+eYGhv2s=; b=uIICaxX6pWmkXckWCmtWXTnofe
	Jki5RrRIWkmfndzM8xQvAFEXVPSPmxrQkGvGp+VgzmOxOTn95ZO7aZJx6F6tAX6h5YvyVSDKHerty
	Mxl2Jqf9nn7S5Cl4aVr4t2wCYJflcBGcf/Ob13+xE5vQFAVz1A/0Wz/rxpZfvJl1JWk4Xo3abKDKE
	sbL/G0hqUlOqVEbsQPHQfqPN2KR6+mL6aE/38yXuUhbsYI4hgG6BcFo6r44BOqiBPV/Yjoz9zi8Qi
	zAeP8c/pGdTsnrrWsq3WYbMA7+LksBhAW2d5VDmur4Z2fkKzjeR3ZBA57vknbnQ7bzpkBhjl7t6tj
	mSB8VU1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vybnZ-0000000HHck-25WG;
	Fri, 06 Mar 2026 20:29:25 +0000
Date: Fri, 6 Mar 2026 20:29:25 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Josh Law <objecting@objecting.org>, Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] lib/idr: fix ida_find_first_range() missing IDs across
 chunk boundaries
Message-ID: <aas5JbauFQdwWVv0@casper.infradead.org>
References: <20260306200319.2819286-1-objecting@objecting.org>
 <aas14HsY7dj6jTDZ@casper.infradead.org>
 <64ea7b4d-1d55-4d9e-8fef-396613e8bc10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64ea7b4d-1d55-4d9e-8fef-396613e8bc10@gmail.com>
X-Rspamd-Queue-Id: 4646540003
X-Stat-Signature: wbrp668s3mdr1anjsq8xc7dqp8tzs7kr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772828968-724307
X-HE-Meta: U2FsdGVkX18Tf7ox/fgqQwlk6GH1kca+eSlfaJZW4JzyAqZViXsOSG0uBW/y3xP/DYSGQpHSYFQjk83Jg2dpujP3fAWyjKQpGMWfMJ17ywEbErG/eW78UY9N2kriXOKQqfXwRfvHexrnpiTa1cvUSLjA7p7e4zXZcXhDwb++iXAZia+WhFXDQGvHsr961PpGLZ9Y2swB+7yPZr565FT8tNFdUn0v6GPQBtnM1duYFhMB1W8XL9aRb9JmbG2XD7YJYTg0NWqv6y5wqtxD+Sli0oFzOQy4FfobH+84MRHHJaffFhwq9uilieQiJ/wptQEkIsmcFh4Wr6WCiqtng5PNlFfQOi2TRSSVZiekfzWomktZzYgBhcs0IVvOYwGgm1u/pe38wXo0Mr4W/AqPrJDIK4BeHFLSpYnGFQdDeeby7Tq8kbiJIjpzYrMQ3G4J3YsdEW9dGaw6ZG0tknhhg/6Ly/QcMlIty8NcQznGs41DCu7O9mahIneZRcM/RRdiicDYmAWvhOugtnjPSdgMfaWuiuNShulyWpzZ9QZFXSvoRZLbnVrB6k9LYMp1NYIG13H6O54swB9KuBWq9DW8ZmYs7vN51uVSfTHI7dP/nC9pwV0aKqpgkBdE9r/Ec08GOtWWBaEYLaNbW+tS5UoYmr6Kaklvv/hPvNRIYPaBevIUsn5duO8AyrCVwQSKNvGMLG/ePK+rHBfqBgmPrXmBNk9AFUJYZCxndhBW9Xt5+BtVPILZeIrg4uPwcQh46DwF+hGw76DIFWaMS8SitFtMnLH061J2MUV2Z/lEkwhgPFnPYt+1us0dTSmBSZPJdiCzL1eV47XQwITXMY5jJgTLwFAyAHesmPP1V3nOgXg2kgHx82S94w1yu830+njU29cViLAsrDf7R6K8HYyXaFm9JmAXnxXZN1khrPsZq+VQ9PIYMbuv8PwOYQx5FJtuqh2LlQ7C0nt7u6O8WlsKH0cyeQy
 XfYDo9Sv
 cJCSMEPdaSsNbp3yYLRq+pjbBcfhn3VFMtIsj7fOvKEm8QB8Y1EeoHkIFcxAbYel6TgJfjxqejeFIr6/0PAvt43P3+cAk9LV2dQ3VM+vo/gyPlFDzsI574yJDurp4TB2WeipgqEOxU3Ao04MLe4doTWu0ETEeqjKNiYaJ63KIDGBVjLd4/tm2GRDTdBg+LyOhXTWMkUcAitNTp6baoMXWcKhG3rWWuccgTyy0d1KRYqucb+BDKcuiuXB1s0Oa3hgTl/n13Wenk9ue+JutDK0PoNDAVLrbu46AFwl/s02QwALkJcYYzhjOEPAd1LH0kSR9G7zVtDzpK8qNmSgX7AHg27zSQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 08:25:42PM +0000, Josh Law wrote:
> 6 Mar 2026 20:15:29 Matthew Wilcox <willy@infradead.org>:
> 
> > On Fri, Mar 06, 2026 at 08:03:19PM +0000, Josh Law wrote:
> >> ida_find_first_range() only examines the first XArray entry returned by
> >> xa_find(). If that entry does not contain a set bit at or above the
> >> requested offset, the function returns -ENOENT without searching
> >> subsequent entries, even though later chunks may contain allocated IDs
> >> within the requested range.
> >
> > Can I trouble you to add a test to lib/test_ida.c to demonstrate the
> > problem (and that it's fixed, and that it doesn't come back)?
> >
> > Also this needs a Fixes: line.  I suggest 7fe6b987166b is the commit
> > it's fixing.  Add Jason and Yi Liu as well as the author and committer
> > of that patch.
> 
> Okay, you mind if I put the modifications to test_ida.c on the same commit? Or would you like it on another commit

I like it as part of the same commit (as 7fe6b987166b did), but honestly
I'm just happy to get improvements to the test suite no matter how they
come.

