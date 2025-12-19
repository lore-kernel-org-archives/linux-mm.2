Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D36D78797
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C28D6B0088; Fri, 19 Dec 2025 18:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858B66B0089; Fri, 19 Dec 2025 18:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785316B008A; Fri, 19 Dec 2025 18:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678496B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:37:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1155C1A01E7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:37:54 +0000 (UTC)
X-FDA: 84237835668.25.5C3DAD5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC100C0009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:37:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ooGrO/n+";
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766187472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iDiFa9C6BbQmq3eA90hwy/boYCk4vo9zcd1KlfWLIg=;
	b=Drdk3aVMCamaXvRHhmWikDLdPxgGNksiLzMyw2C5A4j2HLxYN9egzeEA2QeStscmmJaJK+
	crO55U/HyG3+SvH0UfDjhvDn6dCDSLy1Tn3RyLeanxG1D1xvpdp/wC5380D0rDOLBzKFYY
	JKcFC0kN7vOe/RCd6jbTj2ApF/tLBkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766187472; a=rsa-sha256;
	cv=none;
	b=Ba3DUGSKz3Qii7R01081GFbI8U0XT/Jj6B/LuxlaLBfvwxofuR1wB23evFMjN0567JWHqU
	LPtlJr/HQQvF/oDwNIc4YYP9fR23dhIrwHj44dcQRU52yThuOrpSQSFMuGMZ7xvcGI7etM
	AX5ILftntzHvG+CvK1xgQ0sEgGDMufY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ooGrO/n+";
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7iDiFa9C6BbQmq3eA90hwy/boYCk4vo9zcd1KlfWLIg=; b=ooGrO/n+PKzaq+plXioglWkC5B
	f0enapG8j3yHDRAH/dXfpWR92EkbWh/zKrKUI3itCreuFQhjay6EbjHMGRDlCbqk1m4fMAm+qec96
	MsDQon4BD32uHjjhXV1HgZN/TCDLSCDnIdIyzjJXsxx8IG5fX74Y7NQX+WzW2cNOrdHYdDKJjrSNT
	+jwmKsfrfve+jyGRqIeMdI5khflMH67fBlNHQXXtkpTRU8jbzlcGJCYMs3aby7Q85lLknTf/yzDvZ
	Ku4RC2HFpriodsYWXOMIOmx0sCX7XI240JFlw8vAmYVoHJSatdbZQ/6wnya+fe2k54TMFyVWJW8lu
	cZFd6qvQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWk2e-00000008JKw-0QQW;
	Fri, 19 Dec 2025 23:37:48 +0000
Date: Fri, 19 Dec 2025 23:37:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Vishal Moola <vishal.moola@gmail.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aUXhy1Jyv7_GccIp@casper.infradead.org>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aUW05pyc9nZkvY-1@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUW05pyc9nZkvY-1@casper.infradead.org>
X-Stat-Signature: uoyouikzixpf93yq9qk4tmpruythpwjc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC100C0009
X-Rspam-User: 
X-HE-Tag: 1766187471-736003
X-HE-Meta: U2FsdGVkX18DkQ6wJ++EVjFbjWXC1aPNIflPPuaDhvR0NXwbWg1/ENEveWLN+8HrqT1+G8wfdjkESwbZ9Onol7oTgZVguzOgGAuVquxCr+AROLkv8+WOaM8NysRDC7bUe3JkBF65H6mmc4kC0vc5e2vIRI07KKwW8jtl4oDzKOYuLdNSuqQkVrHYgAxJKFcUQUeGnUC16Vac/CjaL6Ir1Dy2/EmOsZxd/ypM+qTezNcWvHUIC1PbCNpJ9kSxsBgzqOv38NneTXTJsQtMpA1TOc2ebZKVbZsEvAdXFYdBplfyP3qTUO3HH+ul4NVX5BUoMXcZLbptbCC6uBc5t41p5+UfLLl2+cE09tP8S+zYyCAPIatFWFdZ6pRWF7+0gC2nw7nUIaDh2ZKPUhdKcEt6dbSWa5eZOKPrs+QcEvVcRJcafQ06Lz05Z3Vq4sNTerllSRZvQ2Zomr5KHI+wDNIijEXuGGGbGFlLmlPr7OlBpzCOE6HaXUbXtI9DPxNFAkbADZEWnEdOlnt2F9CU5KzaB7iNveyxvvSVT08MKy0yHVQCa0Tcw/g/n2H0xkDq5kSLx2kviwszJ0akUGcpXsIDxAP9p2qWSHPN+UGc1ooW48muOrudFmT+akRrSBVlJiBygfwFdZbCm2Jmh/OaLqiok4R9jJ0P6IROYnebF/I/M6g4x0NTb7dGiCAyVxj2glqoks0lOeIrH+Pk1C5hVnCVztDJ58XoLmIGYzWctrs5SbhOXFBk4EsFqCpOxkLcAA3TyDCBK1Q7cq8QlxO7kf1LRSnCLFIjCWwUtV1a7aoq5PpXkWKmuGoshERRikk+FzOgyffZ7Cf0ZIXn/88sQjevo1L7fqO1E9EkSUUSsHe5hG190mDLfmx9u4GEB8YRFypjhjY5aEim8Onv89bi0dJcVANGsNmo2eak2X6abHkpE74LOFQLvACOt8o5IV3X7Ezp4/dkU6IbW1dSmhFXq2Z
 IZPwGgUB
 MePwajN7h2vW7GZQus4+EW/ku1YVscD7e0U/x72J1sqxTO604ncp7y1yZ4qfmZJ0079ohIDAsZrd/d/fWHp5ZzDzTN79YX9NJLnd4CzDbaIHNrQYSS97s+RJk8yGWLgUt1kRgeEcea4ZZFzxHYJ87oYN5Jmvh+qhzb6IQS8Ya4cHwETLr+WDx9ehbQoiZjqfwosTuY78wljTyIPSWPgWe5dbEBZk2BELgjEe2y0q6rrjX+XzRDyg+Lla5MpcwWIpnbUnLLDcncLiF5/vFAZMc7xzcNm0gr6VRp8TWM2HOqdE5yN7S1Y3KovT+5X+QPZQ+yoQEuKFzK2uYa4vzwsbKchwWN6F3cK7UCbLXuxAkuJmeSehFOMGzqXgsRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:26:14PM +0000, Matthew Wilcox wrote:
> Now, as I recall, we are very much doing this on purpose.  We decided
> not to disable interrupts at this point for improved interrupt
> latency, accepting the possibility that we'd occasionally fail
> the trylock.  Except on UP that's now an assertion failure.

This is stupid and wrong.  If we have CONFIG_SMP=n and
CONFIG_DEBUG_SPINLOCK=n, then trylock always succeeds.  And we'll end
up corrupting the data structure protected by the lock.  So the warning
is real, and we need to fix this.

With my distro hat on, I do not give two hoots.  We don't ship a nosmp
kernel.  I suspect all other distros (except maybe something targetting
m68k?) are in the same boat.

